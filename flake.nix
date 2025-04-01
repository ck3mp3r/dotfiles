{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    laio = {
      url = "github:ck3mp3r/laio-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    nix-darwin,
    nixpkgs,
    nixpkgs-unstable,
    laio,
    sops-nix,
    ...
  }: let
    system =
      builtins.currentSystem
      or (import <nixpkgs> {}).stdenv.hostPlatform.system;
    inherit (nix-darwin.lib) darwinSystem;
    inherit (home-manager.lib) homeManagerConfiguration;
    stateVersion = "24.11";

    upkgs = import nixpkgs-unstable {
      inherit system;
    };

    overlays = [
      (final: next: {
        laio = laio.packages.${system}.default;
        nushell = upkgs.nushell;
        starship = upkgs.starship;
        zoxide = upkgs.zoxide;
        topiary = upkgs.topiary;
      })
    ];

    pkgs = import nixpkgs {
      inherit system overlays;
      config = {allowUnfree = true;};
    };

    makeDarwinConfiguration = username:
      darwinSystem {
        inherit pkgs;
        modules = [
          home-manager.darwinModules.home-manager
          (import ./modules/darwin.nix {
            inherit system pkgs username stateVersion sops-nix;
            revision = self.rev or self.dirtyRev or null;
          })
        ];
      };

    makeHomemanagerConfiguration = username:
      homeManagerConfiguration {
        inherit pkgs;
        modules = [
          (import ./modules/home.nix {
            inherit username pkgs stateVersion system sops-nix;
            homeDirectory =
              if pkgs.stdenv.isLinux
              then "/home/${username}"
              else "/Users/${username}";
          })
        ];
      };
  in {
    darwinConfigurations = {
      "christian" = makeDarwinConfiguration "christian";
      "christian_kemper" = makeDarwinConfiguration "christian.kemper";
    };

    formatter.${system} = pkgs.alejandra;

    homeConfigurations = {
      christian = makeHomemanagerConfiguration "christian";
    };
  };
}
