{pkgs, ...}: {
  home.file.".config/mods/mods.yml".source = ./mods.yml;
  home.packages = [pkgs.mods];
}
