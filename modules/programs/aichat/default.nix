{
  pkgs,
  system,
  ...
}: let
  data = builtins.fromJSON (builtins.readFile ./data/${system}.json);
  aichat = pkgs.callPackage ../../../util/github-release.nix {
    inherit pkgs data;
    name = "aichat";
    version = "v0.22.0";
  };
in {
  # Install the generated script into your home directory
  home.file."Library/Application\ Support/aichat/config.yaml".source = ./config.yaml;

  home.packages = [aichat];
}
