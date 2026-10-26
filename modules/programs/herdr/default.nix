{pkgs, ...}:
let
  # Status commands mirror the monitor plugin in the installed ck3mp3r/flakes
  # tmux profile. Herdr schedules these itself; no tmux server or cache needed.
  mkStatus = metric:
    pkgs.writeShellApplication {
      name = "herdr-${metric}-status";
      runtimeInputs = [pkgs.gawk];
      text = builtins.readFile (./scripts + "/${metric}.sh");
    };
in {
  programs.herdr = {
    enable = true;
    package = pkgs.herdr;
    settings = {
      onboarding = false;
      terminal.default_shell = "/run/current-system/sw/bin/nu";
      ui = {
        tab_bar_right = map (command: {
          type = "command";
          command = pkgs.lib.getExe command;
          interval_seconds = 5;
          timeout_seconds = 3;
        }) (map mkStatus ["gpu" "cpu" "ram" "battery"]);
        tab_bar_right_separator = " · ";
      };
      keys = {
        prefix = "ctrl+a";

        # tmux muscle memory: | or \ splits side by side, - or _ stacks
        split_vertical = ["prefix+backslash" "prefix+shift+backslash"];
        split_horizontal = ["prefix+minus" "prefix+shift+minus"];

        focus_pane_left = ["prefix+h" "ctrl+h"];
        focus_pane_down = ["prefix+j" "ctrl+j"];
        focus_pane_up = ["prefix+k" "ctrl+k"];
        focus_pane_right = ["prefix+l" "ctrl+l"];

        navigate_workspace_down = "j";
        navigate_workspace_up = "k";

        command = [
          {
            key = "prefix+alt+l";
            type = "popup";
            command = "laio start --muxer herdr --show-picker";
            description = "open laio picker";
            width = 50;
            height = 16;
          }
        ];
      };
    };
  };
}
