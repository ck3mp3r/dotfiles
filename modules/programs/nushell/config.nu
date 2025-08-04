let integrations = ["laio" "carapace"]

for integration in $integrations {
  let cache_path = $"($env.HOME)/.cache/($integration)"
  if not ($cache_path | path exists) {
    mkdir $cache_path
  }

  match $integration {
    "laio" => {
      laio completion nushell | save --force $"($cache_path)/init.nu"
    }
    "carapace" => {
      $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
      carapace _carapace nushell | save --force $"($cache_path)/init.nu"
    }
    _ => { }
  }
}

alias myip = http get https://ipecho.net/plain
alias nix-shell-unstable = nix-shell -I nixpkgs=channel:nixpkgs-unstable
alias l = ls -la
alias lg = lazygit
alias k = kubectl
alias kx = kubectx
def tkl [] {
  tsh kube login (tsh kube ls -f yaml | yq -r ".[].kube_cluster_name" | fzf)
}

source ~/.config/atuin/init.nu
source ~/.config/nushell/git.nu
source ~/.config/nushell/direnv.nu
source ~/.cache/laio/init.nu
source ~/.cache/carapace/init.nu
