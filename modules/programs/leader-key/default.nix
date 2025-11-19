{...}: let
  aerospace = "/opt/homebrew/bin/aerospace";

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
            key = "s";
            type = "application";
            value = "/Applications/Signal.app";
          }
          {
            key = "t";
            type = "application";
            value = "/Applications/Telegram.app";
          }
          {
            key = "w";
            type = "application";
            value = "/Applications/WhatsApp.app";
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
            value = "${aerospace} move left";
            label = "Move Left";
          }
          {
            key = "l";
            type = "command";
            value = "${aerospace} move right";
            label = "Move Right";
          }
          {
            key = "k";
            type = "command";
            value = "${aerospace} move up";
            label = "Move Up";
          }
          {
            key = "j";
            type = "command";
            value = "${aerospace} move down";
            label = "Move Down";
          }
          {
            key = "f";
            type = "command";
            value = "${aerospace} fullscreen";
            label = "Fullscreen";
          }
          # Layout modes
          {
            key = "t";
            type = "command";
            value = "${aerospace} layout tiles horizontal vertical";
            label = "Tiles Layout";
          }
          {
            key = "a";
            type = "command";
            value = "${aerospace} layout accordion horizontal vertical";
            label = "Accordion Layout";
          }
          {
            key = "z";
            type = "command";
            value = "${aerospace} layout floating tiling";
            label = "Toggle Floating";
          }
          # Mission Control
          {
            key = "m";
            type = "command";
            value = "osascript -e 'tell application \"System Events\" to key code 126 using {control down}'";
            label = "Mission Control";
          }
          {
            key = "d";
            type = "command";
            value = "osascript -e 'tell application \"System Events\" to key code 103'";
            label = "Show Desktop";
          }
          # Resize windows
          {
            key = "r";
            type = "group";
            actions = [
              {
                key = "h";
                type = "command";
                value = "${aerospace} resize smart -100";
                label = "Shrink";
              }
              {
                key = "l";
                type = "command";
                value = "${aerospace} resize smart +100";
                label = "Grow";
              }
              {
                key = "=";
                type = "command";
                value = "${aerospace} balance-sizes";
                label = "Balance";
              }
            ];
          }
          # Join windows
          {
            key = "v";
            type = "command";
            value = "${aerospace} join-with down";
            label = "Join Down";
          }
          {
            key = "s";
            type = "command";
            value = "${aerospace} join-with right";
            label = "Join Right";
          }
          # Close window
          {
            key = "c";
            type = "command";
            value = "${aerospace} close";
            label = "Close Window";
          }
          # Flatten workspace
          {
            key = "F";
            type = "command";
            value = "${aerospace} flatten-workspace-tree";
            label = "Flatten Workspace";
          }
          # Reload config
          {
            key = "R";
            type = "command";
            value = "${aerospace} reload-config";
            label = "Reload Config";
          }
        ];
      }
    ];
  };
in {
  home.file.".config/leader-key/config.json" = {
    text = builtins.toJSON config;
    force = true;
  };
}
