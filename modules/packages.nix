{pkgs, ...}:
with pkgs;
  [
    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "NerdFontsSymbolsOnly"
        "Hack"
        "Terminus"
      ];
    })
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
    nix-tree
    pandoc
    ripgrep
    rsync
    sops
    speedtest-cli
    tldr
    tree
    yazi
  ]
  ++ lib.optionals stdenv.isDarwin [colima m-cli]
