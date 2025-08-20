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
    lsd
    mitmproxy
    neofetch
    nerd-fonts.hack
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nix-tree
    nodejs
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
