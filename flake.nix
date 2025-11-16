{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nu-mods = {
      url = "github:ck3mp3r/nu-mods";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    laio = {
      url = "github:ck3mp3r/laio-cli";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    mods = {
      url = "github:ck3mp3r/flakes?dir=mods";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    opencode = {
      url = "github:ck3mp3r/flakes?dir=opencode";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nu-mcp = {
      url = "github:ck3mp3r/nu-mcp";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = {
    self,
    catppuccin,
    home-manager,
    nix-darwin,
    nixpkgs-unstable,
    nu-mcp,
    nu-mods,
    mods,
    opencode,
    laio,
    sops-nix,
    ...
  }: let
    system =
      builtins.currentSystem
      or (import <nixpkgs> {}).stdenv.hostPlatform.system;
    inherit (nix-darwin.lib) darwinSystem;
    inherit (home-manager.lib) homeManagerConfiguration;
    stateVersion = "25.05";

    overlays = [
      (final: prev: {
        # Custom packages from flake inputs
        ai = nu-mods.packages.${system}.ai;
        c67-mcp-tools = nu-mcp.packages.${system}.c67-mcp-tools;
        finance-mcp-tools = nu-mcp.packages.${system}.finance-mcp-tools;
        k8s-mcp-tools = nu-mcp.packages.${system}.k8s-mcp-tools;
        laio = laio.packages.${system}.default;
        mods = mods.packages.${system}.default;
        nu-mcp = nu-mcp.packages.${system}.default;
        opencode = opencode.packages.${system}.default;
        tmux-mcp-tools = nu-mcp.packages.${system}.tmux-mcp-tools;
        weather-mcp-tools = nu-mcp.packages.${system}.weather-mcp-tools;

        # Override Python packages to use Python 3.13
        mitmproxy = final.python313Packages.toPythonApplication final.python313Packages.mitmproxy;
        speedtest-cli = final.python313Packages.toPythonApplication final.python313Packages.speedtest-cli;
      })
    ];

    pkgs = import nixpkgs-unstable {
      inherit system overlays;
      config = {allowUnfree = true;};
    };

    makeDarwinConfiguration = args: let
      defaults = {
        casks = [];
      };
      config = defaults // args;
    in
      darwinSystem {
        inherit pkgs;
        modules = [
          home-manager.darwinModules.home-manager
          (import ./modules/darwin.nix {
            inherit system pkgs stateVersion catppuccin sops-nix;
            inherit (config) username casks;
            revision = self.rev or self.dirtyRev or null;
          })
        ];
      };

    makeHomemanagerConfiguration = args: let
      defaults = {
        casks = [];
      };
      config = defaults // args;
    in
      homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./modules/home.nix {
            inherit pkgs stateVersion system catppuccin sops-nix;
            inherit (config) username;
            homeDirectory =
              if pkgs.stdenv.isLinux
              then "/home/${config.username}"
              else "/Users/${config.username}";
          })
        ];
      };
  in {
    darwinConfigurations = {
      "christian" = makeDarwinConfiguration {
        username = "christian";
        casks = [
          "parallels"
        ];
      };
      "christian_kemper" = makeDarwinConfiguration {
        username = "christian.kemper";
        casks = ["utm"];
      };
    };

    formatter.${system} = pkgs.alejandra;

    homeConfigurations = {
      christian = makeHomemanagerConfiguration {username = "christian";};
    };
  };
}
