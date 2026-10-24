{
  pkgs,
  lib,
  ...
}: let
  taps = [
    "charmbracelet/tap"
    "protonpass/tap"
  ];

  casks = [
    "1password"
    "arc"
    "claude-code"
    "ghostty"
    "ollama-app"
    "zen"
  ];

  brews = [
    "charmbracelet/tap/crush"
    "protonpass/tap/pass-cli"
    "ollama"
  ];

  brewfile = pkgs.writeText "Brewfile" (
    lib.concatStringsSep "\n" (
      (map (t: ''tap "${t}"'') taps)
      ++ (map (c: ''cask "${c}"'') casks)
      ++ (map (b: ''brew "${b}"'') brews)
    )
  );
in {
  home.activation.homebrewBundle = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -x /opt/homebrew/bin/brew ]; then
      target="$HOME/.cache/homebrew/Brewfile"
      mkdir -p "$(dirname "$target")"
      cp -f ${brewfile} "$target"
      HOMEBREW_NO_REQUIRE_TAP_TRUST=1 $DRY_RUN_CMD /opt/homebrew/bin/brew bundle --file="$target"
    fi
  '';
}
