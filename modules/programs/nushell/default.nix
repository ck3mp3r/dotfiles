{
  pkgs,
  homeDirectory,
  ...
}: {
  home.file.".config/nushell/git.nu".source =
    ./git.nu;

  programs.nushell = {
    enable = true;
    configFile.source = ./config.nu;

    environmentVariables = pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
      DOCKER_HOST = "unix://${homeDirectory}/.config/colima/default/docker.sock";
    };

    shellAliases =
      pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        nd = "${homeDirectory}/.config/dotfiles/bin/nd";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        hm = "${homeDirectory}/.config/dotfiles/bin/hm";
      };

    extraEnv = ''
      let laio_cache = "${homeDirectory}/.cache/laio"
      if not ($laio_cache | path exists) {
        mkdir $laio_cache
      }
      ${pkgs.laio}/bin/laio completion nushell | save --force ${homeDirectory}/.cache/laio/init.nu

      $env.PATH = [
        $"($env.HOME)/.nix-profile/bin"
        $"/etc/profiles/per-user/($env.USER)/bin"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        "/usr/local/bin"
        "/usr/bin"
        "/usr/sbin"
        "/bin"
        "/sbin"
      ]

    '';

    extraConfig = ''
      source ~/.cache/laio/init.nu
    '';
  };
}
