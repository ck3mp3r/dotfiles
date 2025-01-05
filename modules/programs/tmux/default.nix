{pkgs, ...}: let
  tmux-cpu = pkgs.tmuxPlugins.mkTmuxPlugin {
    name = "tmux-cpu";
    pluginName = "cpu";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "98d787191bc3e8f19c3de54b96ba1caf61385861";
      sha256 = "ymmCI6VYvf94Ot7h2GAboTRBXPIREP+EB33+px5aaJk=";
    };
  };

  catppucinSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    rev = "1612a23174a6771ac466312eb156f83b8b89d907";
    sha256 = "jTxUrA0vA8JnQE1K6rZQcSg4woHtPiKg0yz4rNVMMlc=";
  };

  localSrc = ./catppuccin;

  mergedSources = pkgs.stdenv.mkDerivation {
    name = "mergedSources";
    buildInputs = with pkgs; [rsync];

    buildCommand = ''
      # Create the $out directory explicitly
      mkdir -p $out
      rsync -a ${catppucinSrc}/. $out/
      rsync -a ${localSrc}/. $out/
    '';
  };

  tmux-catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    name = "catppuccin";
    pluginName = "catppuccin";
    src = mergedSources;
  };
in {
  programs.tmux = {
    baseIndex = 1;
    enable = true;
    keyMode = "vi";
    shell = "/bin/zsh";
    sensibleOnTop = false;
    shortcut = "a";

    plugins = [
      pkgs.tmuxPlugins.battery
      pkgs.tmuxPlugins.copycat
      pkgs.tmuxPlugins.pain-control
      pkgs.tmuxPlugins.yank
      {
        plugin = tmux-catppuccin;
        extraConfig = ''
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"

          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"

          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"

          set -g @catppuccin_status_modules_left "session"
          set -g @catppuccin_status_modules_right "directory cpu ram host"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_right_separator_inverse "no"
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"

        '';
      }
      tmux-cpu
      pkgs.sessionx
    ];

    extraConfig = ''
      # begin additional user settings
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on
      set -g status-position top
      set -g default-terminal "tmux-256color"
      set -g popup-border-lines "rounded"

      # pane styling
      set -g pane-border-lines double
      set -g pane-border-status bottom
      set -g pane-border-format " #{pane_title} (#{pane_index}) "

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"
      bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
      bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
      bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
      bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      bind -n C-M-k send-keys C-l \; send-keys -R \; clear-history

      # end additional user settings
    '';
  };
}
