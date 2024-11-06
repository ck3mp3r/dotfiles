{...}: {
  programs.neovim.enable = false;
  home.file.".config/lvim/config.lua".source = ./lvim/config.lua;
}
