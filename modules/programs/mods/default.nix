{pkgs, ...}: {
  home.file.".config/mods/mods.yml".source = ./mods.yml;
  home.packages = [
    pkgs.context7-mcp
    pkgs.mods
    pkgs.nu-mcp
  ];
}
