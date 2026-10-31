{pkgs, lib, config, ...}: let
  src = pkgs.omlx-src;
  app = "/Applications/oMLX.app";

  # Declared per machine in hosts.nix as hosts.<name>.omlx.guardCeilingGb and
  # passed through home.nix. omlx pauses prefill above 0.9x this value.
  guardCeilingGb = config.omlx.guardCeilingGb;

  # Only the keys we care about. Merged into the live file, so everything the
  # app owns (auth keys, ui, usage, downloaded-model entries) is preserved.
  settingsPatch = pkgs.writeText "omlx-settings-patch.json" (builtins.toJSON {
    cache = {
      enabled = true;
      # fp16 KV (no quantization) with SSD-tier paging measured best at 238k:
      # 3.03s warm TTFT / 30GB footprint vs 3.38s at a 16GB hot tier and
      # 6.33s at 8GB. A RAM tier only pays off when it can hold two full
      # copies of the sequence's KV (~30GB at 238k fp16).
      hot_cache_max_size = "0";
      hot_cache_only = false;
      hot_cache_write_through = false;
      # Was "auto" (≈279 GB on this disk) and had grown to 180 GB with no
      # eviction pressure. 64 GB holds ~4 sequences at 238k fp16.
      ssd_cache_max_size = "64GB";
    };
    memory = {
      prefill_memory_guard = true;
      memory_guard_tier = "custom";
      memory_guard_custom_ceiling_gb = guardCeilingGb;
    };
    # Dedicated inference box: keep the model resident, never idle-unload.
    idle_timeout = {
      idle_timeout_seconds = null;
    };
  });
  # Watchdog: probe the API every 60s, restart after 3 consecutive failures.
  # Logs every probe with its HTTP code so "became unresponsive" turns into
  # evidence instead of an anecdote.
  watchdog = pkgs.writeShellApplication {
    name = "omlx-watchdog";
    runtimeInputs = [pkgs.curl pkgs.coreutils];
    text = ''
      state="$HOME/.local/state/omlx"
      log="$state/watchdog.log"
      fails_file="$state/watchdog.fails"
      threshold=3
      mkdir -p "$state"

      code=$(curl -s -o /dev/null -m 15 -w '%{http_code}' http://127.0.0.1:8000/v1/models || echo 000)
      case "$code" in
        200|401|403) fails=0 ;;
        *) fails=$(( $(cat "$fails_file" 2>/dev/null || echo 0) + 1 )) ;;
      esac
      echo "$fails" > "$fails_file"
      printf '%s probe=%s fails=%s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$code" "$fails" >> "$log"

      if [ "$fails" -ge "$threshold" ]; then
        printf '%s restarting (fails=%s)\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$fails" >> "$log"
        /Applications/oMLX.app/Contents/MacOS/omlx-cli restart >> "$log" 2>&1 \
          || /usr/bin/pkill -f omlx-server >> "$log" 2>&1 \
          || true
        echo 0 > "$fails_file"
      fi

      # keep the log bounded
      if [ "$(wc -l < "$log")" -gt 2000 ]; then
        tail -n 500 "$log" > "$log.tmp" && mv "$log.tmp" "$log"
      fi
    '';
  };
in {
  options.omlx.guardCeilingGb = lib.mkOption {
    type = lib.types.number;
    default = 48.0;
    description = ''
      omlx memory-guard ceiling in GB. Set per machine in hosts.nix. omlx pauses
      prefill once the process passes 0.9x this value; the default leaves 16GB of
      a 64GB box for the OS and other apps.
    '';
  };

  config = {
  launchd.agents.omlx-watchdog = {
    enable = true;
    config = {
      ProgramArguments = ["${watchdog}/bin/omlx-watchdog"];
      StartInterval = 60;
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/.local/state/omlx/watchdog.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/.local/state/omlx/watchdog.err.log";
    };
  };
  # oMLX ships as a notarized app bundle inside a DMG. The DMG is pinned as a
  # flake input (flake = false), so flake.lock carries the hash and
  # `nix flake update omlx` is the only bump. Install is keyed on the store
  # path: unchanged path means no work, changed path means reinstall.
  home.activation.omlxApp = lib.hm.dag.entryAfter ["writeBoundary"] ''
    app="${app}"
    stamp="$HOME/.local/state/omlx/app-source"
    current="$(cat "$stamp" 2>/dev/null || true)"
    if [ "$current" != "${src}" ] || [ ! -d "$app" ]; then
      echo "omlx: installing from ${src}" >&2
      mnt="$(mktemp -d /tmp/omlx-dmg.XXXXXX)"
      if /usr/sbin/diskutil image attach --readOnly --mountOptions nobrowse --mountPoint "$mnt" ${src} >/dev/null; then
        rm -rf "$app"
        /usr/bin/ditto "$mnt/oMLX.app" "$app"
        /usr/sbin/diskutil eject "$mnt" >/dev/null || true
        mkdir -p "$(dirname "$stamp")"
        printf '%s\n' "${src}" > "$stamp"
      else
        echo "omlx: failed to mount ${src}" >&2
      fi
      rmdir "$mnt" 2>/dev/null || true
    fi
  '';

  # The app installs its own `omlx` shim here (it execs omlx-cli and exports
  # OMLX_BASE_PATH). Adding the directory is all that is needed; do not put
  # Contents/MacOS on PATH, where `omlx` resolves to the GUI `oMLX` binary.
  home.sessionPath = ["$HOME/.omlx/bin"];

  # Re-assert the keys we care about on every switch. The app owns these files,
  # so we merge instead of linking, and back up on change. Takes effect on the
  # next server restart; hm switch does not restart the app-managed server.
  home.activation.omlxConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    merge_json() {
      target="$1"
      patch="$2"
      [ -f "$target" ] || return 0
      tmp_a="$(mktemp)"
      tmp_b="$(mktemp)"
      jq -S . "$target" > "$tmp_a"
      jq -S --slurpfile p "$patch" '. * $p[0]' "$target" > "$tmp_b"
      if ! cmp -s "$tmp_a" "$tmp_b"; then
        cp -p "$target" "$target.bak-$(date +%Y%m%d%H%M%S)"
        cp "$tmp_b" "$target"
      fi
      rm -f "$tmp_a" "$tmp_b"
    }
    merge_json "$HOME/.omlx/settings.json" ${settingsPatch}
  '';
  };
}
