{
  description = "Darwin system flake";

  inputs = {
    base-nixpkgs.url = "github:ck3mp3r/flakes?dir=base-nixpkgs";
    nixpkgs-unstable.follows = "base-nixpkgs/unstable";
    nixpkgs.follows = "base-nixpkgs/stable";

    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "base-nixpkgs/unstable";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "base-nixpkgs/stable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nu-mods = {
      url = "github:ck3mp3r/nu-mods";
      inputs.nixpkgs.follows = "base-nixpkgs/unstable";
    };

    laio = {
      url = "github:ck3mp3r/laio-cli";
      inputs.nixpkgs.follows = "base-nixpkgs/unstable";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "base-nixpkgs/unstable";
    };

    topiary-nu = {
      url = "github:ck3mp3r/flakes?dir=topiary-nu";
      inputs.nixpkgs.follows = "base-nixpkgs/unstable";
    };

    nu-mcp = {
      url = "github:ck3mp3r/nu-mcp";
      inputs.nixpkgs.follows = "base-nixpkgs/unstable";
    };

    c5t = {
      url = "github:ck3mp3r/context";
      inputs.nixpkgs.follows = "base-nixpkgs/unstable";
    };
  };

  outputs = {
    self,
    catppuccin,
    c5t,
    home-manager,
    nix-darwin,
    nixpkgs-unstable,
    nu-mcp,
    nu-mods,
    laio,
    sops-nix,
    topiary-nu,
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
        c5t = c5t.packages.${system}.default;
        laio = laio.packages.${system}.default;
        nu-mcp-tools = nu-mcp.packages.${system}.mcp-tools;
        nu-mcp = nu-mcp.packages.${system}.default;
        topiary = topiary-nu.packages.${system}.default;

        # Override nushell to skip broken SHLVL tests in 0.112.1
        nushell = prev.nushell.overrideAttrs (oldAttrs: {
          checkPhase = let
            skippedTests =
              [
                "repl::test_config_path::test_default_config_path"
                "repl::test_config_path::test_xdg_config_bad"
                "repl::test_config_path::test_xdg_config_empty"
                # Add the failing SHLVL tests
                "shell::environment::env::env_shlvl_in_repl"
                "shell::environment::env::env_shlvl_in_exec_repl"
              ]
              ++ prev.lib.optionals prev.stdenv.hostPlatform.isDarwin [
                "plugins::config::some"
                "plugins::stress_internals::test_exit_early_local_socket"
                "plugins::stress_internals::test_failing_local_socket_fallback"
                "plugins::stress_internals::test_local_socket"
                "shell::environment::env::path_is_a_list_in_repl"
              ];
            skippedTestsStr = prev.lib.concatStringsSep " " (prev.lib.map (testId: "--skip=\${testId}") skippedTests);
          in ''
            runHook preCheck

            cargo test -j $NIX_BUILD_CORES --offline -- \
              --test-threads=$NIX_BUILD_CORES ${skippedTestsStr}

            runHook postCheck
          '';
        });

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
