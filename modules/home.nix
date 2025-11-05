{
  pkgs,
  username,
  homeDirectory,
  stateVersion,
  sops-nix,
  ...
}: {
  # fix for manuals not compiling...
  manual.manpages.enable = false;
  xdg.enable = true;
  fonts.fontconfig.enable = true;
  home = {
    inherit stateVersion username homeDirectory;
    sessionPath = ["$HOME/.local/bin"];
    packages = import ./packages.nix {inherit pkgs;};
  };
  imports = [
    sops-nix.homeManagerModules.sops
    (import ./programs/nushell {inherit pkgs homeDirectory;})
    ./programs.nix
    ./programs/alacritty
    ./programs/atuin
    ./programs/carapace
    ./programs/ghostty
    ./programs/goose
    ./programs/git.nix
    ./programs/idea
    ./programs/k9s
    ./programs/laio
    ./programs/mods
    ./programs/opencode
    ./programs/starship.nix
    ./programs/tmux
    ./programs/zellij
    ./programs/zsh
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
}
