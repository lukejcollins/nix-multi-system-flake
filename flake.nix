{
  description = "A flake to handle multiple systems with a hierarchy";

  inputs = {
    # Fetch the latest nixpkgs from the master branch of the NixOS repository
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Fetch home-manager and make it follow nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fetch nix-darwin and make it follow nixpkgs and home-manager
    darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Install VSCode extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    # Homebrew package manager support
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    # Optional: Declarative tap management
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    homebrew-emacs-plus = {
      url = "github:d12frosted/homebrew-emacs-plus";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, nix-vscode-extensions, nix-homebrew, homebrew-core, homebrew-cask, homebrew-bundle, homebrew-emacs-plus, ... }: {

    # NixOS configurations for personal and work systems
    nixosConfigurations = {
      personal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./unix/configuration.nix
          ./unix/nixos/configuration.nix
          ./unix/nixos/personal/configuration.nix
          ./unix/nixos/personal/hardware-configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./unix/configuration.nix
          ./unix/nixos/configuration.nix
          ./unix/nixos/work/configuration.nix
          ./unix/nixos/work/hardware-configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };

    # Darwin (macOS) configurations for personal and work systems
    darwinConfigurations = {
      personal = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./unix/configuration.nix
          ./unix/darwin/configuration.nix
          ./unix/darwin/personal/configuration.nix
          { users.users."lukecollins".home = "/Users/lukecollins"; }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."lukecollins" = {
              imports = [
                ./home.nix
                ./unix/home.nix
                ./unix/darwin/home.nix
                ./unix/darwin/personal/home.nix
              ];
            };
          }
          { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              enableRosetta = true;
              user = "lukecollins";
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
                "homebrew/homebrew-bundle" = homebrew-bundle;
                "d12frosted/homebrew-emacs-plus" = homebrew-emacs-plus;
              };
              mutableTaps = false;
            };
          }
        ];
      };

      work = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./unix/configuration.nix
          ./unix/darwin/configuration.nix
          ./unix/darwin/work/configuration.nix
          { users.users."luke.collins".home = "/Users/luke.collins"; }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."luke.collins" = {
              imports = [
                ./home.nix
                ./unix/home.nix
                ./unix/darwin/home.nix
                ./unix/darwin/work/home.nix
              ];
            };
          }
          { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }
        ];
      };
    };

    # Home Manager configurations for Unix personal, Unix work, and WSL systems
    homeConfigurations = {
      personal = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./unix/home.nix
          ./unix/nixos/home.nix
          ./unix/nixos/personal/home.nix
          {
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
          { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }
        ];
      };

      work = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./unix/home.nix
          ./unix/nixos/home.nix
          ./unix/nixos/work/home.nix
          {
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
          { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }
        ];
      };

      wsl = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./wsl/home.nix
          {
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
        ];
      };
    };
  };
}
