{pkgs, ...}: {
  home.file.".config/nushell/git.nu".source = ./git.nu;
  home.file.".config/nushell/direnv.nu".source = ./direnv.nu;
  home.file.".config/nushell/nu-agent.nu".source = ./nu-agent.nu;

  # home. activation. registerNushellPlugins = ''
  #   ${pkgs.nushell}/bin/nu —no-config-file -c 'plugin add --plugin-config $"($env.HOME)/.config/nushell/plugin-msgpackz" ${pkgs.nu-agent}/bin/nu_plugin_agent'
  # '';

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.source = ./env.nu;

    extraConfig = ''
      const NU_LIB_DIRS = [
          "${pkgs.ai}/share/nushell/modules"
      ]

      use ai *
    '';
  };
  home.packages = [
    pkgs.ai
  ];
}
