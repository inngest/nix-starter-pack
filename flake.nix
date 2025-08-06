{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
    let
      configuration = { pkgs, ... }: {
        # List packages installed in system profile. To search by name, run:
        # $ nix-env -qaP | grep wget
        environment.systemPackages = with pkgs; [
          vim
          direnv
          jq
          yq
          fd
          ripgrep
          tree
          pet
          dig
          sops
          git
          wget
          tmux
          wget
          zip
          unzip

          nixfmt
          nixd
          shellcheck
          editorconfig-core-c
        ];

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";
        nix.enable = false;

        # Enable alternative shell support in nix-darwin.
        # programs.fish.enable = true;

        system = {
          # Set Git commit hash for darwin-version.
          configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          stateVersion = 6;

          # NOTE: uncomment the following if you want to use nix to control certain
          # laptop settings
          # defaults = {
          #   dock = {
          #     autohide = true;
          #     magnification = true;
          #   };
          #
          #   spaces.spans-displays = true;
          #
          #   NSGlobalDomain = {
          #     # Shortest value based on
          #     # defaults read NSGlobalDomain InitialKeyRepeat
          #     InitialKeyRepeat = 15;
          #     KeyRepeat = 2;
          #
          #     "com.apple.mouse.tapBehavior" = 1; # Enable tap to click
          #     "com.apple.trackpad.scaling" = 2.0;
          #   };
          #
          #   controlcenter = { BatteryShowPercentage = true; };
          #   loginwindow = { GuestEnabled = false; };
          #   trackpad.Clicking = true;
          # };
          #
          # # Remaps
          # keyboard = {
          #   enableKeyMapping = true;
          #   remapCapsLockToControl = true;
          # };

        };

        # NOTE: Uncomment the following to use nix to control Homebrew.
        # This still requires installing Homebrew separately first from https://brew.sh/
        # homebrew = {
        #   enable = true;
        #   onActivation = {
        #     autoUpdate = true;
        #     cleanup = "uninstall";
        #   };
        #
        #   taps = [ ];
        #   brews = [ "watch" ];
        #   casks = [
        #     # Terminal
        #     "ghostty"
        #     "kitty"
        #     "alacritty"
        #
        #     # Browwer
        #     "google-chrome"
        #     "firefox@developer-edition"
        #     "brave-browser"
        #
        #     # Chat
        #     "discord"
        #
        #     # Tool
        #     "1password"
        #     "1password-cli"
        #     "docker"
        #     "docker-desktop"
        #
        #     # Development
        #     "visual-studio-code"
        #   ];
        #
        #   masApps = { };
        # };

        # The platform the configuration will be used on.
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Enable Home Manager
        users.users.workstation-username = {
          name = "workstation-username";
          home = "/Users/workstation-username";
        };

        # Add Home Manager configuration
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.workstation-username = { pkgs, ... }: {
            home.stateVersion = "25.05";

            # Enable direnv
            programs.direnv = {
              enable = true;
              nix-direnv.enable = true;
            };
          };
        };
      };
    in {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#workstation-name
      darwinConfigurations."workstation-name" = nix-darwin.lib.darwinSystem {
        modules = [ configuration home-manager.darwinModules.home-manager ];
      };
    };
}
