{pkgs, ...}: let
  tmux-cpu = pkgs.tmuxPlugins.mkTmuxPlugin {
    name = "tmux-cpu";
    pluginName = "cpu";
    src = pkgs.fetchFromGitHub {
      owner = "tmux-plugins";
      repo = "tmux-cpu";
      rev = "bcb110d754ab2417de824c464730c412a3eb2769";
      sha256 = "OrQAPVJHM9ZACyN36tlUDO7l213tX2a5lewDon8lauc=";
    };
  };

  catppucinSrc = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "tmux";
    rev = "320e184a31d0825cb4f4af550492cbdff2fc3ffc";
    sha256 = "gMBpINeHS+5TCsbJBHhXKEF+fG58FmJrIJoQWYdQqc0=";
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
      pkgs.tmuxPlugins.copycat
      pkgs.tmuxPlugins.pain-control
      pkgs.tmuxPlugins.yank
      {
        plugin = tmux-catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_status_background "#242638"

          set -g status-justify 'centre'
          set -ogq @catppuccin_window_number_position "right"
          set -ogq @catppuccin_window_text "#W"
          set -ogq @catppuccin_window_current_text "#W"

          set -ogq @catppuccin_pane_status_enabled "yes"
          set -ogq @catppuccin_pane_border_status "yes"
          set -ogq @catppuccin_pane_default_text "##{b:pane_title}"
          set -ogq @catppuccin_pane_number_position "right"

          set -g status-left-length 150
          set -g status-right-length 150
          set -g status-left "#{E:@catppuccin_status_session} "
          # set -g status-right "#{E:@catppuccin_status_cpu}#{E:@catppuccin_status_ram}#{E:@catppuccin_status_host}"
          set -g status-right "#{E:@catppuccin_status_directory}#{E:@catppuccin_status_host}"

          # pane styling
          set -g pane-border-lines heavy
          set -g pane-border-status bottom


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
