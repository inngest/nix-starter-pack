# Nix Starter Pack

This repo is a starter pack for folks interested in using Nix for,

- package management
- tool management
- configuration management

etc.

The default `flake.nix` can be used as is if you just want the bare minimum.
It's pre-configured with some useful tools that can help with day to day work.

**NOTE**

This guide is meant for macOS users considering we default to macOS laptops.
Linux users should reference the NixOS guides.

## Pre-requisites

You'll need to have Nix installed.

``` sh
curl -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
```

If you're curious what this is, here's the [repo](https://github.com/DeterminateSystems/nix-installer?tab=readme-ov-file#determinate-nix-installer) and you can look through the details.

It's essentially just an installer for Nix itself.


## Setup the configuration

Run the following to make sure configuration is on that expected path for Nix to read.

``` sh
sudo ln -s ~/_config /etc/nix-darwin
```

The make sure to run this command to update the hostname reference.

``` sh
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
```

## Build

Run the following to start the build.

``` sh
darwin-rebuild switch
```

Whenever you made a change to `flake.nix`, make sure to run the command above to rebuild the system.


## Documentation

You can either run `darwin-help` to see the docs in terminal or check it online [here](https://nix-darwin.github.io/nix-darwin/manual/index.html).
