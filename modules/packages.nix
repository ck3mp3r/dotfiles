{pkgs, ...}:
with pkgs;
  [
    _1password-cli
    bandwhich
    bat
    bottom
    delta
    docker
    fd
    fh
    fzf
    gh
    gh-copilot
    gum
    jq
    jqp
    laio
    lsd
    neofetch
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nix-tree
    nodejs_24
    nushell
    pandoc
    ripgrep
    rsync
    sops
    speedtest-cli
    tldr
    tree
    uv
    yazi
  ]
  ++ lib.optionals stdenv.isDarwin [m-cli]
