{
  system,
  pkgs,
  revision,
  username,
  stateVersion,
  sops-nix,
  catppuccin,
  casks,
  ...
} @ inputs: let
  packages' = with pkgs; [
    mkalias
    nushell
    ollama
  ];

  casks' =
    [
      "1password"
      "alacritty"
      "arc"
      "claude-code"
      "cleanshot"
      "ghostty"
      "obsidian"
      "pop-app"
      "zen"
    ]
    ++ casks;
in {
  environment.systemPackages = packages';
  launchd = {
    user = {
      agents = {
        ollama-serve = {
          command = "${pkgs.ollama}/bin/ollama serve";
          serviceConfig = {
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/ollama.out.log";
            StandardErrorPath = "/tmp/ollama.err.log";
          };
        };
      };
    };
  };

  nix.enable = false;

  # Cachix configuration for Determinate Nix via nix.custom.conf
  environment.etc."nix/nix.custom.conf".text = ''
    # Cachix binary cache configuration
    substituters = https://cache.nixos.org https://nix-community.cachix.org https://devenv.cachix.org https://nixpkgs-unfree.cachix.org https://ck3mp3r.cachix.org
    trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw= nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nqlt4= ck3mp3r.cachix.org-1:wKbNJDH7mrT9DuVvG1KRRtqfcy0FREVGguU7RIfL5zo=

    # Trust users to add additional binary caches
    trusted-users = root ${username}
  '';

  # services.nix-daemon.enable = true;
  # nix = {
  #   package = pkgs.nixVersions.nix_2_26;
  #   gc = {
  #     automatic = true;
  #     interval.Day = 7;
  #     options = "--delete-older-than 7d";
  #   };
  #
  #   # Necessary for using flakes on this system.
  #   settings = {
  #     experimental-features = "nix-command flakes pipe-operators auto-allocate-uids";
  #     trusted-users = [
  #       "root"
  #       "${username}"
  #     ];
  #   };
  # };

  users.users.${username} = {
    home =
      if pkgs.stdenv.isLinux
      then "/home/${username}"
      else "/Users/${username}";
  };

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  homebrew = {
    enable = true;
    # onActivation.cleanup = "zap";
    casks = casks';
  };

  # Set Git commit hash for darwin-version.
  system = {
    primaryUser = username;
    stateVersion = 5;
    configurationRevision = revision;

    defaults = {
      loginwindow.GuestEnabled = false;

      # Keyboard preferences
      NSGlobalDomain.KeyRepeat = 2;
      NSGlobalDomain.InitialKeyRepeat = 25;

      # Finder preferences
      finder.FXPreferredViewStyle = "Nlsv";
      finder.ShowStatusBar = true;
      finder.ShowPathbar = true;

      # Trackpad
      NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
      NSGlobalDomain."com.apple.trackpad.trackpadCornerClickBehavior" = 1;

      NSGlobalDomain.AppleICUForce24HourTime = true;
      NSGlobalDomain.AppleInterfaceStyle = "Dark";

      # Dock
      dock = {
        orientation = "left";
        autohide = true;
        tilesize = 16;
        largesize = 34;
        persistent-apps = [
          "/Applications/Arc.app"
          "/Applications/Ghostty.app"
          # "${pkgs.utm}/Applications/UTM.app"
          "/Applications/Obsidian.app"
          # "/Applications/Parallels Desktop.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
        ];
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };

    activationScripts.applications.text = let
      env = pkgs.buildEnv {
        name = "system-applications";
        paths = packages';
        pathsToLink = "/Applications";
      };
    in
      pkgs.lib.mkForce ''
        # Set up applications.
        echo "setting up /Applications..." >&2
        rm -rf /Applications/Nix\ Apps
        mkdir -p /Applications/Nix\ Apps
        find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read -r src; do
          app_name=$(basename "$src")
          echo "copying $src" >&2
          ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
        done
      '';
  };
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = system;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./home.nix {
      inherit stateVersion pkgs username catppuccin sops-nix system;
      nixvim = inputs.nixvim;
      homeDirectory =
        if pkgs.stdenv.isLinux
        then "/home/${username}"
        else "/Users/${username}";
    };
  };
}
