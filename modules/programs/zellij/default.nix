{...}: {
  home.file.".config/zellij/layouts/standard.kdl".source =
    ./standard.kdl;

  programs.zellij = {
    enable = false;

    settings = {
      copy_command = "pbcopy";

      pane_frames = false;

      default_layout = "standard";

      ui = {
        pane_frames = {
          rounded_corners = true;
          hide_session_name = true;
        };
      };

      theme = "duskfox";

      themes = {
        gruvbox-dark = {
          fg = "#D5C4A1";
          bg = "#282828";
          black = "#3C3836";
          red = "#CC241D";
          green = "#98971A";
          yellow = "#D79921";
          blue = "#3C8588";
          magenta = "#B16286";
          cyan = "#689D6A";
          white = "#FBF1C7";
          orange = "#D65D0E";
        };

        nightfox = {
          bg = "#192330";
          fg = "#cdcecf";
          red = "#c94f6d";
          green = "#81b29a";
          blue = "#719cd6";
          yellow = "#dbc074";
          magenta = "#9d79d6";
          orange = "#f4a261";
          cyan = "#63cdcf";
          black = "#29394f";
          white = "#aeafb0";
        };

        duskfox = {
          bg = "#232136";
          fg = "#e0def4";
          red = "#eb6f92";
          green = "#a3be8c";
          blue = "#569fba";
          yellow = "#f6c177";
          magenta = "#c4a7e7";
          orange = "#ea9a97";
          cyan = "#9ccfd8";
          black = "#373354";
          white = "#cdcbe0";
        };
      };
    };
  };
}
