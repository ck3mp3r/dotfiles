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
    (import ./programs/aichat.nix {
      inherit pkgs system;
    })
    ./programs/alacritty.nix
    ./programs/ghostty.nix
    ./programs/git.nix
    ./programs/idea.nix
    ./programs/k9s.nix
    ./programs/kitty.nix
    ./programs/nvim.nix
    ./programs/starship.nix
    ./programs/tmux.nix
    ./programs/zellij.nix
    ./programs/zsh.nix
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "${homeDirectory}/.config/sops/age/keys.txt";
}
