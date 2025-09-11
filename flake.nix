{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:lnl7/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    mods = {
      url = "github:ck3mp3r/flakes?dir=mods";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nu-mcp = {
      url = "github:ck3mp3r/nu-mcp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    context7 = {
      url = "github:ck3mp3r/flakes?dir=context7";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    home-manager,
    nix-darwin,
    nixpkgs,
    nixpkgs-unstable,
    nu-mcp,
    context7,
    mods,
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

    upkgs = import nixpkgs-unstable {
      inherit system;
    };

    overlays = [
      (final: next: {
        atuin = upkgs.atuin;
        carapace = upkgs.carapace;
        laio = laio.packages.${system}.default;
        mods = mods.packages.${system}.default;
        nu-mcp = nu-mcp.packages.${system}.default;
        context7-mcp = context7.packages.${system}.default;
        nushell = upkgs.nushell;
        ollama = upkgs.ollama;
        opencode = upkgs.opencode;
        starship = upkgs.starship;
        topiary = upkgs.topiary;
        zoxide = upkgs.zoxide;
        nodejs = upkgs.nodejs_24;
      })
    ];

    pkgs = import nixpkgs {
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
            inherit system pkgs stateVersion sops-nix;
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
            inherit pkgs stateVersion system sops-nix;
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
