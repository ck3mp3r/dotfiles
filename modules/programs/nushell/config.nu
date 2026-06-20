ulimit --file-descriptor-count 8192

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

def short-sha []: string -> string {
  $in | hash sha256 | str substring 0..8
}

alias myip = http get https://ipecho.net/plain
alias nix-shell-unstable = nix-shell -I nixpkgs=channel:nixpkgs-unstable
alias l = ls -la
alias lg = lazygit
alias k = kubectl
alias kx = kubectx

def ollama-restart [] {
  launchctl kickstart -k gui/(id -u)/org.nixos.ollama-serve
}

def ollama-clean-restart [] {
  launchctl unload ~/Library/LaunchAgents/org.nixos.ollama-serve.plist
  launchctl load ~/Library/LaunchAgents/org.nixos.ollama-serve.plist
}

source ~/.config/nushell/atuin.nu
source ~/.config/nushell/git.nu
source ~/.config/nushell/direnv.nu
source ~/.config/nushell/laio.nu
source ~/.config/nushell/carapace.nu
source ~/.config/nushell/nu-agent.nu
