def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

load-env {
  config:{
    show_banner: false
    edit_mode: vi
  },

  STARSHIP_SHELL: "nu",
  TERM: "xterm-256color",
  EDITOR: "nvim",
  TESTCONTAINERS_RYUK_DISABLED: "true",

  PROMPT_COMMAND: {|| create_left_prompt },
  PROMPT_COMMAND_RIGHT: "",
  PROMPT_INDICATOR: "",
  PROMPT_INDICATOR_VI_INSERT: "❯ ",
  PROMPT_INDICATOR_VI_NORMAL: "❮ ",
  PROMPT_MULTILINE_INDICATOR: "❯❯ ",
}

alias myip = http get https://ipecho.net/plain
alias nix-shell-unstable = nix-shell -I nixpkgs=channel:nixpkgs-unstable
alias lg = lazygit
alias k = kubectl
alias kx = kubectx

source ~/.config/nushell/git.nu
