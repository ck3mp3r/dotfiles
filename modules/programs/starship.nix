{
  lib,
  pkgs,
  ...
}: let
  catppuccinSources = lib.listToAttrs (map (s: lib.nameValuePair s.name s) pkgs.catppuccin.srcs);
  catppuccinStarship = lib.importTOML "${catppuccinSources.starship}/themes/mocha.toml";
in {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = false;
    settings =
      {
        format = "$all";
        command_timeout = 1500;
        aws.disabled = true;
        azure.disabled = true;
        gcloud.disabled = true;
        docker_context.disabled = true;
        openstack.disabled = true;
      }
      // catppuccinStarship;
  };
}
