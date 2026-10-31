{
  pkgs,
  username,
  homeDirectory,
  stateVersion,
  sops-nix,
  roles ? [],
  hostConfig ? {},
  ...
}: {
  # fix for manuals not compiling...
  manual.manpages.enable = false;

  # Determinate Nix sets use-xdg-base-directories globally (see `nix config show`)
  # and HM does not manage nix.conf. Tell HM so its default-profile detection
  # (installPackages, CLI) probes the real XDG default profile
  # (~/.local/state/nix/profile -> profiles/profile) instead of the nonexistent
  # ~/.nix-profile. The installPackages command itself (probe + `nix profile
  # add`) is overridden in ./nix-profile.nix — HM#4593 and HM#9598.
  nix.assumeXdg = true;
  xdg.enable = true;
  fonts.fontconfig.enable = true;
  home = {
    inherit stateVersion username homeDirectory;
    sessionPath = ["$HOME/.local/bin"];
    packages = import ./packages.nix {inherit pkgs;};
  };
  imports = [
    sops-nix.homeManagerModules.sops

    # HM nix profile activation: probe the real XDG default profile (HM#4593)
    # and use `nix profile add` instead of the deprecated `install` (HM#9598)
    ./nix-profile.nix

    ./programs/nushell
    ./programs.nix
    ./programs/alacritty
    ./programs/atuin
    ./programs/bat
    ./programs/carapace
    ./programs/container
    ./programs/crush
    ./programs/ghostty
    # ./programs/goose
    ./programs/git.nix
    ./programs/herdr
    ./programs/homebrew
    ./programs/idea
    ./programs/k9s
    ./programs/laio
    ./programs/opencode
    ./programs/starship.nix
    # ./programs/tmux
    ./programs/tree-sitter
    ./programs/zellij
    ./programs/zsh
  ]
  ++ pkgs.lib.optional (builtins.elem "inference" roles) ./programs/omlx;

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
}
// pkgs.lib.optionalAttrs (builtins.elem "inference" roles) {
  # Machine-specific knobs from hosts.nix, consumed by the omlx module.
  omlx.guardCeilingGb = hostConfig.omlx.guardCeilingGb or 48;
}
