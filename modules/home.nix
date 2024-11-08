{
  pkgs,
  username,
  homeDirectory,
  stateVersion,
  sops-nix,
  system,
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
    ./programs.nix
    (import ./programs/aichat {
      inherit pkgs system;
    })
    ./programs/alacritty
    ./programs/ghostty
    ./programs/git.nix
    ./programs/idea
    ./programs/k9s
    ./programs/kitty
    (import ./programs/nushell {inherit pkgs homeDirectory;})
    ./programs/starship.nix
    ./programs/tmux
    ./programs/zellij
    ./programs/zsh.nix
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
}
