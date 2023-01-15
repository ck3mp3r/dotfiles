{ pkgs }:

let
  packages = with pkgs; [
    iterm2
    neovim
  ];
in packages
