{...}: {
  home.file.".config/nushell/git.nu".source = ./git.nu;
  home.file.".config/nushell/direnv.nu".source = ./direnv.nu;

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}
