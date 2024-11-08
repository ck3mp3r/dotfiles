{pkgs, ...}: {
  home.file.".config/nushell/git.nu".source =
    ./git.nu;

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;

    environmentVariables = pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    };

    shellAliases =
      pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        nd = "~/.config/dotfiles/bin/nd";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        hm = "~/.config/dotfiles/bin/hm";
      };
  };
}
