{...}: {
  home.file.".config/nushell/git.nu".source = ./git.nu;

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };
}
