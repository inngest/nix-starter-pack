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

Clone this repo.

```
git clone https://github.com/inngest/nix-starter-pack ~/nix-darwin
cd ~/nix-darwin
```

Run the following to make sure configuration is on that expected path for Nix to read.

``` sh
sudo ln -s $(pwd) /etc/nix-darwin
```

The make sure to run this command to update the hostname and username reference.

``` sh
sed -i '' "s/workstation-name/$(scutil --get LocalHostName)/" flake.nix
sed -i '' "s/workstation-username/$(whoami)/" flake.nix
```

## Build

Run the following to start the build, which should setup the Nix system for your laptop.

``` sh
sudo nix run nix-darwin/nix-darwin-25.05#darwin-rebuild -- switch
```

Then add the following to your `~/.zshrc`.

``` bash
. /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

direnvPath=$(which direnv)
eval "$(${direnvPath} hook zsh)"
```
And then open a new terminal session to load the config.

NOTE: Nix home-manager also have the capability to control `.zshrc` settings as well, so you are able to skip the step above if you use that instead.

You should now have a functioning Nix system working.

Going forward, you can just use the following command for rebuilds.

``` sh
sudo darwin-rebuild switch
```

Whenever you made a change to `flake.nix`, make sure to run the command above to rebuild the system.


## Documentation

You can either run `darwin-help` to see the docs in terminal or check it online [here](https://nix-darwin.github.io/nix-darwin/manual/index.html).

## NOTE

If you like this and want to expand on customizing your configuration, make sure to remove this repo from your origin.

```
git remote remove origin
```

And then create a configuration repo of your own.
This is meant to be a starter pack so there should'nt be any personalized configuration in it.
