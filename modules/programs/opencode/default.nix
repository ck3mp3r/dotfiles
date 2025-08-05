{pkgs, ...}: {
  home.file.".config/opencode/opencode.json".source = ./opencode.json;
  home.packages = [pkgs.opencode];
}
