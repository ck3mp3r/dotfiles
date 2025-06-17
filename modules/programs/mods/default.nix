{
  pkgs,
  lib,
  ...
}: let
  mods = pkgs.buildGoModule rec {
    pname = "mods";
    version = "unstable-${lib.substring 0 8 src.rev}";

    src = pkgs.fetchFromGitHub {
      owner = "charmbracelet";
      repo = "mods";
      rev = "main";
      hash = "sha256-dCNVDf05wRvs84eVChMGtRtg5fOWhiz1I/L8F/9Rw/Q=";
    };

    vendorHash = "sha256-nnXvmuyv25AKf1Jh3bA1J8f/hg6NREZNE2BG/sISv5U=";

    # Let Nix handle vendoring automatically
    proxyVendor = true;

    ldflags = [
      "-s"
      "-w"
      "-X=main.Version=${version}"
    ];

    meta = with lib; {
      description = "AI on the command line";
      homepage = "https://github.com/charmbracelet/mods";
      license = licenses.mit;
    };
  };
in {
  home.file.".config/mods/mods.yml".source = ./mods.yml;
  home.packages = [mods];
}
