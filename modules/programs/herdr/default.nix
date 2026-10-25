{pkgs, ...}: {
  programs.herdr = {
    enable = true;
    package = pkgs.herdr;
    settings = {
      onboarding = false;
      terminal.default_shell = "/run/current-system/sw/bin/nu";
      keys = {
        prefix = "ctrl+a";

        # tmux muscle memory: | or \ splits side by side, - or _ stacks
        split_vertical = ["prefix+backslash" "prefix+shift+backslash"];
        split_horizontal = ["prefix+minus" "prefix+shift+minus"];

        focus_pane_left = ["prefix+h" "ctrl+h"];
        focus_pane_down = ["prefix+j" "ctrl+j"];
        focus_pane_up = ["prefix+k" "ctrl+k"];
        focus_pane_right = ["prefix+l" "ctrl+l"];
      };
    };
  };
}
