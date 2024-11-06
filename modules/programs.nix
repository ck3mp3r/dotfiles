{...}: {
  # Let Home Manager install and manage itself.
  #  home-manager.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.fzf = {
    enableZshIntegration = true;
    enable = true;
  };

  programs.helix.enable = true;

  programs.htop = {
    enable = true;
    settings.show_program_path = true;
  };

  programs.lazygit.enable = true;

  programs.less.enable = true;
  programs.lesspipe.enable = true;

  programs.nushell.enable = true;

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.atuin = {
    enable = true;
    flags = ["--disable-up-arrow"];
    settings = {
      filter_mode = "host";
      enter_accept = false;
      keymap_mode = "vim-normal";
      history_filter = [
        "^cd"
      ];
    };
  };
}
