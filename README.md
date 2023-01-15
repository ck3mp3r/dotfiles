# Nix Based Workstation Setup

## Preparing Nix

### Nix Installation

To install nix run the following command. This will kick off the (recommended) multi-user installation.
More information can be found on the official [Nix / NixOS Documentation.](https://nixos.org/download.html#nix-install-macos)

```bash
sh <(curl -L https://nixos.org/nix/install)
```

The installer will guide you through the process and even show the commands it will be executing as part of the setup.
Once it has completed, exit your terminal, open a new one and run `nix --version`.

```bash
nix --version
nix (Nix) 2.12.0
```

### Nix Flake

In order to use Nix Flakes we need to enable a few experimental features.

Run the following command:

```bash
mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes
sandbox = true
EOF
```

Next we run `nix flake init` using a community template to bootstrap our `flake.nix`.

```bash
nix flake init \
--template github:the-nix-way/home-manager-config-template
```

We need to edit a few parameters in the new file i.e. subsitute our username and/or the architecture of the system with our current values.

```nix
username = "change-me-plz"; # $USER
system = "aarch64-darwin";  # x86_64-linux, aarch64-multiplatform, etc.
```

You will have noticed a few more nix files in the directory that have been created as a result of running `nix flake init`...
Before we run our first build we'll add the following to the `programs.nix`:

```nix
zsh = {
  enable = true;
};
```

Now we have a fairly basic Nix Flake and Home-Manager setup and are ready for the first build:

```nix
nix run '.#homeConfigurations.${USER}.activationPackage'
```

Once complete, relaunch your terminal.

### Reorganising Structure

For the next few steps it makes sense to reorganise the file structure a little to cater for different types of categories i.e. shell scripts and nix files.
The structure I prefer is something similar to this:

```bash
├── README.md
├── bin
└── nix
    ├── flake.lock
    ├── flake.nix
    └── modules
        ├── home.nix
        ├── packages.nix
        └── programs.nix
```

We'll get to the bin directory later, but for now lets change the reference to `home.nix` as follows: update line 32 of `flake.nix`:

```
      home = (import ./modules/home.nix {

```

We don't need to change the other files as references are relative to the calling file.

### Adding A Helper

Having to cd into the dotfiles directory every time we interact with it is a bit cumbersome, hence why I tend to add a bash script
that makes life a bit easier.

First we'll add the following executable file `bin/ws`.
For the time being the content is as follows:

```bash
#!/usr/bin/env bash

echo "Hello"

```

The script is only accessible in the bin directory, lets change that.
We're going to replace line 14 in `home.nix` with the following:

```nix
      hm = "~/.config/hm/bin/hm";

```

The assumption here is that this is where your dotfiles checkout lives. If not, just use the path you have chosen.
Running `nix run '.#homeConfigurations.${USER}.activationPackage'` will ensure the alias is available. You'll have to reload your terminal.
Running `hm` will result in `Hello` being printed out. Now it is time for adding some usefull functionality.

### Building Out the Helper

```bash
#!/usr/bin/env bash

_switch() {
		home-manager switch -b backup --flake "$BASE_PATH/nix#$USER"
}

_print_help() {
	cat <<EOF
Usage: $CMD switch        # run home-manager switch
       $CMD -h|help       # print this help message.
EOF

}

# determine script base name
CMD=$(basename "$0")

# determine script base path
BASE_PATH=$(dirname "$(dirname "$0")")

# print help if no sub command was given
if [[ "$#" -eq 0 ]]; then
	_print_help
fi

while [[ "$#" -gt 0 ]]; do
	case $1 in
	switch) _switch ;;
	-h | help) _print_help ;;
	*)
		_print_help
		exit 1
		;;
	esac
	shift
done

```

Once the file has been edited and saved, you should now be able to just run `hm switch` to apply any changes you made to your nix files.
We'll be adding more functionality to this utility script later.
