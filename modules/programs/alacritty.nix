{pkgs, ...}: let
  readYAML = pkgs.callPackage ../../util/read-yaml.nix {};

  # nightfox = readYAML (pkgs.fetchFromGitHub
  #   {
  #     owner = "EdenEast";
  #     repo = "nightfox.nvim";
  #     rev = "669b0ce";
  #     sha256 = "kPcwHr0qujlLGhN916zBLdNNh4QjgJMwMTSDmeWQKJk=";
  #   } + "/extra/duskfox/nightfox_alacritty.yml");

  catppuccin-mocha = readYAML (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "alacritty";
      rev = "406dcd4";
      sha256 = "RyxD54fqvs0JK0hmwJNIcW22mhApoNOgZkyhFCVG6FQ=";
    }
    + "/catppuccin-mocha.yml");
in {
  home.file.".config/alacritty/alacritty.toml".source =
    ./alacritty/alacritty.toml;

  programs.alacritty = {
    enable = false;
    settings =
      {
        alt_send_escape = true;
        env.TERM = "xterm-256color";
        window = {
          option_as_alt = "Both";
          opacity = 0.9;
          dynamic_title = true;
          columns = 124;
          lines = 38;

          padding = {
            x = 5;
            y = 15;
          };

          dynamic_padding = false;
          decorations = "transparent";
        };
        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        font = {
          normal = {
            family = "JetBrainsMono Nerd Font";
            style = "Regular";
          };
          bold = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Italic";
          };
          bold_italic = {
            family = "JetBrainsMono Nerd Font";
            style = "Bold Italic";
          };
          size = 14.0;

          offset = {
            x = 0;
            y = 0;
          };

          glyph_offset = {
            x = 0;
            y = 0;
          };

          draw_bold_text_with_bright_colors = false;
        };
        key_bindings = [
          {
            key = "Key3";
            mods = "Alt";
            chars = "#";
          }
        ];
      }
      // catppuccin-mocha;
  };
}
