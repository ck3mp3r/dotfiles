# quick and repeatable workstation setup

### Quick Start

* Clone this repo `git clone git@github.com:ck3mp3r/dotfiles.git ~/.config/dotfiles`
* Follow the [installation instructions](https://nixos.org/download#nix-install-macos) to get nix installed.
* Once that has finished run `~/.config/dotfiles/bin/nd switch` to continue the `nix-darwin` setup.

Once this has completed the `nd` helper will be on the `PATH` and accessible from anywhere.
Run `nd -h` for options.

### Sops setup
```
mkdir -p ~/.config/sops/age/
nix run nixpkgs#ssh-to-age -- -private-key -i ~/.ssh/id_ed25519 > ~/.config/sops/age/keys.txt
nix shell nixpkgs#age -c age-keygen -y ~/.config/sops/age/keys.txt
```
