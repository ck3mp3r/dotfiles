{pkgs, ...}:
with pkgs;
  [
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    nerd-fonts.hack
    # nerdfonts
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
    kdash
    kubectl
    kubectx
    laio
    lsd
    neofetch
    nushell
    nix-tree
    pandoc
    ripgrep
    rsync
    sops
    speedtest-cli
    tldr
    topiary
    tree
    yazi
  ]
  ++ lib.optionals stdenv.isDarwin [colima m-cli]
