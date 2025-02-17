load-env {
  config:{
    show_banner: false
  },
  XDG_CONFIG_HOME: $"($env.HOME)/.config",
  XDG_CACHE_HOME: $"($env.HOME)/.cache",
  XDG_DATA_HOME: $"($env.HOME)/.local/share",
  STARSHIP_SHELL: "nu",
  DOCKER_HOST: $"unix://($env.HOME)/.config/colima/default/docker.sock",
  TERM: "xterm-256color",
  EDITOR: "nvim",
  TESTCONTAINERS_RYUK_DISABLED: "true"
  PATH: [
        $"($env.HOME)/.nix-profile/bin"
        $"($env.HOME)/.config/dotfiles/bin"
        $"/etc/profiles/per-user/($env.USER)/bin"
        "/run/current-system/sw/bin"
        "/nix/var/nix/profiles/default/bin"
        "/opt/homebrew/bin"
        "/usr/local/bin"
        "/usr/bin"
        "/usr/sbin"
        "/bin"
        "/sbin"
      ],
  PROMPT_COMMAND: {|| starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'},
  PROMPT_COMMAND_RIGHT: "",
  PROMPT_INDICATOR: "",
  PROMPT_INDICATOR_VI_INSERT: "❯ ",
  PROMPT_INDICATOR_VI_NORMAL: "❮ ",
  PROMPT_MULTILINE_INDICATOR: "❯❯ ",
}

