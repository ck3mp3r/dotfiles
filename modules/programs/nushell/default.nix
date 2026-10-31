{pkgs, config, ...}: let
  lib = pkgs.lib;
  # Every home.sessionPath entry, rendered as a nushell expression. `$HOME/...`
  # paths become ($env.HOME + "...") so nix stays the single source of truth
  # for PATH instead of each shell hard-coding its own list.
  toNuPath = p:
    if lib.hasPrefix "$HOME/" p
    then "($env.HOME + \"${lib.removePrefix "$HOME" p}\")"
    else "\"${p}\"";
  extraPath =
    if config.home.sessionPath == []
    then ""
    else ''
      $env.PATH = ($env.PATH | prepend [${lib.concatMapStringsSep " " toNuPath config.home.sessionPath}])
    '';
in {
  imports = [
    ./nu-agent
  ];

  home.file.".config/nushell/git.nu".source = ./git.nu;
  home.file.".config/nushell/direnv.nu".source = ./direnv.nu;
  home.file.".config/nushell/fzf.nu".source = pkgs.runCommand "fzf-nushell.nu" {} ''
    ${pkgs.fzf}/bin/fzf --nushell | ${pkgs.gnused}/bin/sed 's/str downcase/str lowercase/g' > $out
  '';
  # home. activation. registerNushellPlugins = ''
  #   ${pkgs.nushell}/bin/nu —no-config-file -c 'plugin add --plugin-config $"($env.HOME)/.config/nushell/plugin-msgpackz" ${pkgs.nu-agent}/bin/nu_plugin_agent'
  # '';

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;
    envFile.text = (builtins.readFile ./env.nu) + extraPath;

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
