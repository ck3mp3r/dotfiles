{pkgs, config, ...}: let
  lib = pkgs.lib;
  # A `$HOME/...` entry becomes a nushell expression so nix stays the single
  # source of truth for PATH instead of each shell hard-coding its own list.
  toNuPath = p:
    if lib.hasPrefix "$HOME/" p
    then "($env.HOME + \"${lib.removePrefix "$HOME" p}\")"
    else "\"${p}\"";

  # The one managed PATH, highest precedence first: home.sessionPath followed by
  # the profiles a GUI (launchd) process does not inherit. User-level entries stay
  # `$HOME`-relative so they resolve at runtime: config.home.profileDirectory names
  # a different profile per activation route (/etc/profiles/per-user/* under
  # nix-darwin's useUserPackages, the XDG user profile when standalone), and the
  # `nix profile` default profile that activation installs into is neither.
  managedPath =
    config.home.sessionPath
    ++ [
      "$HOME/.local/state/nix/profiles/profile/bin" # nix profile default, XDG layout
      "$HOME/.nix-profile/bin" # nix profile default, legacy layout
      "$HOME/.config/dotfiles/bin"
      "/etc/profiles/per-user/${config.home.username}/bin"
      "/run/current-system/sw/bin"
      "/nix/var/nix/profiles/default/bin"
      "/opt/homebrew/bin"
      "/usr/local/bin"
    ];

  # Prepends the managed entries once and drops any copy inherited from a parent
  # shell, so nested nushells cannot stack duplicate blocks.
  pathInit = ''
    let nu_managed_path = [
      ${lib.concatMapStringsSep "\n      " toNuPath managedPath}
    ] | uniq
    $env.PATH = ($nu_managed_path | append ($env.PATH | where {|p| $p not-in $nu_managed_path }))
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
    envFile.text = (builtins.readFile ./env.nu) + pathInit;

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
