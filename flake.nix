{
  description = "A flake to handle multiple systems with a hierarchy";

  inputs = {
    # Fetch the latest nixpkgs from the master branch of the NixOS repository
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    # Fetch home-manager and make it follow nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fetch nix-darwin and make it follow nixpkgs and home-manager
    darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }: {
    # NixOS configurations for personal and work systems
    nixosConfigurations = {
      personal = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./nixos/configuration.nix
          ./nixos/personal/configuration.nix
          ./nixos/personal/hardware-configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };

      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./nixos/configuration.nix
          ./nixos/work/configuration.nix
          ./nixos/work/hardware-configuration.nix
          home-manager.nixosModules.home-manager
        ];
      };
    };

    # Darwin configurations for personal and work systems
    darwinConfigurations = {
      personal = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          ./darwin/configuration.nix
          ./darwin/personal/configuration.nix
          {
            users.users."lukecollins".home = "/Users/lukecollins";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."lukecollins" = {
              imports = [
                ./home.nix
                ./darwin/home.nix
                ./darwin/personal/home.nix
              ];
            };
          }
        ];
      };

      work = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./configuration.nix
          ./darwin/configuration.nix
          ./darwin/work/configuration.nix
          {
            users.users."luke.collins".home = "/Users/luke.collins";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."luke.collins" = {
              imports = [
                ./home.nix
                ./darwin/home.nix
                ./darwin/work/home.nix
              ];
            };
          }
        ];
      };
    };

    # Home Manager configurations for personal and work systems
    homeConfigurations = {
      personal = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./nixos/home.nix
          ./nixos/personal/home.nix
          {
            # State version and user-specific settings
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
        ];
      };

      work = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./nixos/home.nix
          ./nixos/work/home.nix
          {
            # State version and user-specific settings
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
        ];
      };
    };
  };
}
