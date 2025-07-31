{pkgs, ...}: {
  home.file.".config/crush/crush.json".source = ./crush.json;
  home.packages = [pkgs.crush];
}
