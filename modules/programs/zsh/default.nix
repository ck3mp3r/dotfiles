{
  config,
  pkgs,
  ...
}: {
  home.file.".config/zsh/aliases.zsh".source = ./aliases.zsh;
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    autocd = true;

    sessionVariables =
      {
        TERM = "xterm-256color";
        EDITOR = "nvim";
        TESTCONTAINERS_RYUK_DISABLED = true;
        ZVM_VI_INSERT_ESCAPE_BINDKEY = "jk";
        ZVM_INIT_MODE = "sourcing";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        DOCKER_HOST = "unix://$HOME/.config/colima/default/docker.sock";
      };

    localVariables = {
      TERM = "xterm-256color";
      # FZF_CTRL_R_OPTS = "--reverse";
      # FZF_TMUX_OPTS = "-p";
    };

    shellAliases =
      {
        lazy = "nix run \"github:ck3mp3r/xvim?ref=refs/heads/lazyvim-setup#nvim\" $@";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isDarwin {
        nd = "~/.config/dotfiles/bin/nd";
      }
      // pkgs.lib.optionalAttrs pkgs.stdenv.isLinux {
        hm = "~/.config/dotfiles/bin/hm";
      };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };

    historySubstringSearch = {enable = true;};

    initExtra = ''
      source ~/.config/zsh/aliases.zsh
      source <(${pkgs.laio}/bin/laio completion zsh)
      source <(${pkgs.fh}/bin/fh completion zsh)
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

      # bindkey '^[[Z' autosuggest-accept # shift + tab | autosuggest
      zvm_bindkey vicmd '^[[Z' autosuggest-accept # shift + tab | autosuggest
      zvm_bindkey viins '^[[Z' autosuggest-accept # shift + tab | autosuggest

      search-aliases() {
        local selected_alias full_alias_command
        selected_alias=$(alias | fzf --height=25 --border | sed -n 's/^\([^=]*\)=.*/\1/p')
        full_alias_command=$(alias "$selected_alias" | cut -d'=' -f2-)

        if [ -n "$selected_alias" ]; then
            # Insert the selected alias into the current command line
            LBUFFER="$BUFFER$selected_alias # $full_alias_command"
            zle redisplay  # Refresh the command line to display the updated buffer
            zle accept-line
        fi
      }

      zle -N search-aliases

      zvm_bindkey vicmd '^a' search-aliases
      zvm_bindkey viins '^a' search-aliases

      # homebrew...
      if [[ -x "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi
    '';

    prezto = {
      enable = false;
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "autosuggestions"
        "prompt"
        "git"
      ];
    };

    oh-my-zsh = {
      enable = true;
      plugins = ["fzf"];
    };
  };
}
