# Minimal override of Home Manager's `installPackages` activation. Both changes
# match stock nix/Home-Manager semantics; delete this file when upstream fixes
# the corresponding issues:
#
#  - HM#4593 (open since 2023): upstream probes only ~/.nix-profile and
#    $XDG_STATE_HOME/nix/profile for manifest.json; on XDG-layout nix
#    (Determinate 3.x) the default profile also lives at
#    $XDG_STATE_HOME/nix/profiles/profile. Probe both here so the profiles API
#    is used on this layout too.
#  - HM#9598 (open): upstream shells out to `nix profile install`, which is
#    only a deprecated alias of `nix profile add` on nix 3.x.
#
# The legacy fallback (`nix-env -i`) keeps upstream behavior for
# nix-env-managed profiles. Requires nix.assumeXdg = true in home.nix so the
# remaining HM references (home.profileDirectory, CLI detection) agree.
{lib, config, ...}: {
  home.activation.installPackages = lib.mkForce (
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      stateNix="''${XDG_STATE_HOME:-''$HOME/.local/state}/nix"
      if [[ -e "$stateNix/profile/manifest.json" || -e "$stateNix/profiles/profile/manifest.json" ]]; then
        nixProfileList 'home-manager-path' | xargs -rt $DRY_RUN_CMD nix profile remove $VERBOSE_ARG
        run nix profile add ${config.home.path}
      else
        run nix-env -i ${config.home.path}
      fi
    ''
  );
}
