{...}: {
  # Let Home Manager install and manage itself.
  #  home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = false;
  };

  programs.fzf.enable = true;
  programs.helix.enable = true;

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lazygit.enable = true;
  programs.less.enable = true;
  programs.lesspipe.enable = true;
  programs.zoxide.enable = true;
}
