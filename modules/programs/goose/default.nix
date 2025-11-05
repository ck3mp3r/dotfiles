{pkgs, ...}: {
  # home.file.".config/goose/config.yaml".source = ./config.yaml;
  home.packages = [
    pkgs.goose-cli
  ];
}
