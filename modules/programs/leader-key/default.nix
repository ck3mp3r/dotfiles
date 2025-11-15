{...}: let
  config = {
    type = "group";
    actions = [
      # Applications
      {
        key = "a";
        type = "application";
        value = "/Applications/Arc.app";
      }
      {
        key = "g";
        type = "application";
        value = "/Applications/Ghostty.app";
      }
      {
        key = "o";
        type = "group";
        actions = [
          {
            key = "e";
            type = "application";
            value = "/System/Applications/Mail.app";
          }
          {
            key = "m";
            type = "application";
            value = "/System/Applications/Messages.app";
          }
          {
            key = "t";
            type = "application";
            value = "/Applications/Telegram.app";
          }
        ];
      }
      # Window Management - Aerospace
      {
        key = "w";
        type = "group";
        actions = [
          # Window Tiling
          {
            key = "h";
            type = "command";
            value = "aerospace move left";
          }
          {
            key = "l";
            type = "command";
            value = "aerospace move right";
          }
          {
            key = "k";
            type = "command";
            value = "aerospace move up";
          }
          {
            key = "j";
            type = "command";
            value = "aerospace move down";
          }
          {
            key = "f";
            type = "command";
            value = "aerospace fullscreen";
          }
          # Layout modes
          {
            key = "t";
            type = "command";
            value = "aerospace layout tiles";
          }
          {
            key = "a";
            type = "command";
            value = "aerospace layout accordion";
          }
          # Mission Control
          {
            key = "m";
            type = "command";
            value = "osascript -e 'tell application \"System Events\" to key code 126 using {control down}'";
          }
          {
            key = "d";
            type = "command";
            value = "osascript -e 'tell application \"System Events\" to key code 103'";
          }
        ];
      }
    ];
  };
in {
  home.file.".config/leader-key/config.json".text = builtins.toJSON config;
}
