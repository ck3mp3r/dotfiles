{
  system,
  pkgs,
  revision,
  username,
  stateVersion,
  sops-nix,
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
        copilot-api = {
          command = "${pkgs.nodejs}/bin/npx copilot-api@latest start";
          serviceConfig = {
            KeepAlive = true;
            RunAtLoad = true;
            StandardOutPath = "/tmp/copilot-api.log";
            StandardErrorPath = "/tmp/copilot-api-error.log";
            EnvironmentVariables = {
              PATH = "${pkgs.nodejs}/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin";
            };
          };
        };
      };
    };
  };

  nix.enable = false;

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
      inherit stateVersion pkgs username sops-nix system;
      nixvim = inputs.nixvim;
      homeDirectory =
        if pkgs.stdenv.isLinux
        then "/home/${username}"
        else "/Users/${username}";
    };
  };
}
