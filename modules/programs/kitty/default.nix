{
  programs.kitty = {
    enable = false;
    extraConfig = ''
      background_opacity  0.9
      macos_option_as_alt right
    '';
    settings =
      {
        font_family = "JetBrainsMono Nerd Font";
        bold_font = "JetBrainsMono Nerd Font Bold";
        italic_font = "JetBrainsMono Nerd Font Italic";
        bold_italic_font = "JetBrainsMono Nerd Font Bold Italic";
        font_size = 14;

        ## Window decorations
        hide_window_decorations = "titlebar-only";
      }
      // import ./catppuccin-mocha.nix {};
  };
}
