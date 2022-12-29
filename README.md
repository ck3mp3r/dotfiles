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

### Nix Flake
In order to use Nix Flakes we need to enable a few experimental features.

Run the following command:

```
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
sandbox = true
EOF
```

Next we run `nix flake init` using a community template to bootstrap our `flake.nix`.
```
nix flake init \
--template github:the-nix-way/home-manager-config-template
```

We need to edit a few parameters in the new file i.e. subsitute our username and/or the architecture of the system with our current values.
```
username = "change-me-plz"; # $USER
system = "aarch64-darwin";  # x86_64-linux, aarch64-multiplatform, etc.
```
You will have noticed a few more nix files in the directory that have been created as a result of running `nix flake init`...
Before we run our first build we'll add the following to the `programs.nix`:
```
zsh = {
  enable = true;
};
```

Now we have a fairly basic Nix Flake and Home-Manager setup and are ready for the first build:
```
nix run '.#homeConfigurations.${USER}.activationPackage'
```
Once complete, relaunch your terminal.
