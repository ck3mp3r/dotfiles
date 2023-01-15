{ homeDirectory
, pkgs
, stateVersion
, system
, username }:

let
  packages = import ./packages.nix { inherit pkgs; };
in {
  home = {
    inherit homeDirectory packages stateVersion username;

    shellAliases = {
      hm = "~/.config/hm/bin/hm";
    };
  };

  nixpkgs = {
    config = {
      inherit system;
      allowUnfree = true;
      allowUnsupportedSystem = true;
      experimental-features = "nix-command flakes";
    };
  };

  programs = import ./programs.nix;
}
