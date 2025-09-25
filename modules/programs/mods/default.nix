{pkgs, ...}: {
  home.file.".config/mods/mods.yml".source = ./mods.yml;
  home.packages = [
    pkgs.c67-mcp
    pkgs.mods
    pkgs.nu-mcp
  ];
}
