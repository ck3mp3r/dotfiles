{pkgs, ...}: let
  catppucinSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    rev = "8b0b9150f9d7dee2a4b70cdb50876ba7fd6d674a";
    sha256 = "godCgBMgqzim+W3O2sHcgw91h7sHsKHjd02BdLuazZ8=";
  };

  catppuccinStatusSrc = ./plugins/catppuccin;

  mergedSources = pkgs.stdenv.mkDerivation {
    name = "mergedSources";
    buildInputs = with pkgs; [rsync];

    buildCommand = ''
      mkdir -p $out
      rsync -a ${catppucinSrc}/. $out/
      rsync -a ${catppuccinStatusSrc}/. $out/
    '';
  };

  tmux-catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    name = "catppuccin";
    pluginName = "catppuccin";
    src = mergedSources;
  };
  tmux-cpu = pkgs.tmuxPlugins.mkTmuxPlugin {
    name = "cpu";
    pluginName = "cpu";
    src = ./plugins/cpu;
  };
in {
  programs.tmux = {
    baseIndex = 1;
    enable = true;
    keyMode = "vi";
    shell = "${pkgs.nushell}/bin/nu";
    sensibleOnTop = false;
    shortcut = "a";

    plugins = [
      pkgs.tmuxPlugins.copycat
      pkgs.tmuxPlugins.pain-control
      pkgs.tmuxPlugins.yank
      {
        plugin = tmux-catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_status_background "#242638"

          set -ogq @catppuccin_window_number_position "right"
          set -ogq @catppuccin_window_text "#W"
          set -ogq @catppuccin_window_current_text "#W"

          set -ogq @catppuccin_pane_status_enabled "yes"
          set -ogq @catppuccin_pane_border_status "yes"
          set -ogq @catppuccin_pane_default_text "##{b:pane_title}"
          set -ogq @catppuccin_pane_number_position "right"

          set -g status-justify 'centre'
          set -g status-left-length 150
          set -g status-right-length 150

          set -g status-left "#{E:@catppuccin_status_session} "
          set -g status-right ""
          set -agF status-right "#{E:@catppuccin_status_cpu}"
          set -agF status-right "#{E:@catppuccin_status_ram}"
          set -agF status-right "#{E:@catppuccin_status_battery}"

        '';
      }
      pkgs.tmuxPlugins.battery
      {
        plugin = tmux-cpu;
        extraConfig = ''
          source -F "${tmux-catppuccin}/share/tmux-plugins/catppuccin/status/ram.conf"
        '';
      }
    ];

    extraConfig = ''
      # begin additional user settings
      set-option -sa terminal-overrides ",xterm*:Tc"
      set -g mouse on
      set -g status-position top
      set -g default-terminal "tmux-256color"
      set -g popup-border-lines "rounded"
      set -g renumber-window on

      # pane styling
      set -g pane-border-lines heavy
      set -g pane-border-status bottom

      set -g status-interval 5

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

      bind-key r run-shell "tmux source-file ~/.config/tmux/tmux.conf; tmux refresh-client -S"

      set-hook -g after-new-session "run-shell 'tmux source-file ~/.config/tmux/tmux.conf'"

      # end additional user settings
    '';
  };
}
