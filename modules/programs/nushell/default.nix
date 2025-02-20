{pkgs, ...}: {
  home.file.".config/nushell/git.nu".source = ./git.nu;

  home.file.".config/topiary".source = pkgs.fetchFromGitHub {
    owner = "blindFS";
    repo = "topiary-nushell";
    rev = "main";
    sha256 = "sha256-pxgG2zYWLrxksDIs/nQtnpaITLYhYZ5LktWqiH/Zs1w=";
  };

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}
