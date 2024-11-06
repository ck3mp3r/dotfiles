{...}: {
  programs.k9s.enable = true;
  home.file.".config/k9s/skin.yml".source = ./k9s/skin.yml;
}
