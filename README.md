# Nix Based Workstation Setup

## Preparing Nix

### Nix Installation

To install nix run the following command. This will kick off the (recommended) multi-user installation.
More information can be found on the official [Nix / NixOS Documentation.](https://nixos.org/download.html#nix-install-macos)

```
sh <(curl -L https://nixos.org/nix/install)
```
The installer will guide you through the process and even show the commands it will be executing as part of the setup.
Once it has completed, exit your terminal, open a new one and run `nix --version`.
```
nix --version
nix (Nix) 2.12.0
```
This concludes the installation of Nix Packages.

