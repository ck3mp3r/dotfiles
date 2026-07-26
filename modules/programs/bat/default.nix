{
  pkgs,
  lib,
  ...
}: let
  catppuccinSources = lib.listToAttrs (map (s: lib.nameValuePair s.name s) pkgs.catppuccin.srcs);
in {
  programs.bat = {
    enable = true;
    config.theme = "Catppuccin Mocha";
    themes."Catppuccin Mocha" = {
      src = catppuccinSources.bat;
      file = "Catppuccin Mocha.tmTheme";
    };
  };
}
