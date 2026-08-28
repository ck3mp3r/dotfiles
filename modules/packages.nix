{pkgs, ...}:
with pkgs;
  [
    _1password-cli
    bandwhich
    bottom
    c5t
    cachix
    delta
    docker
    fd
    fh
    fzf
    gh
    github-copilot-cli
    gum
    helix
    jq
    jqp
    lsd
    # mitmproxy
    fastfetch
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
    tailscale
    tldr
    tree
    topiary
    uv
    worktrunk
    yazi
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [m-cli]
