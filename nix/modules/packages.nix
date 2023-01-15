{ pkgs }:

let
  packages = with pkgs; [
    neovim
  ];
in packages
