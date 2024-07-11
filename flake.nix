{
  description = "A flake to handle multiple systems with a hierarchy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nix-darwin, ... }:
    {
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

      darwinConfigurations = {
        personal = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            ./configuration.nix
            ./darwin/configuration.nix
            ./darwin/personal/configuration.nix
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

      homeConfigurations.personal =  home-manager.lib.homeManagerConfiguration {
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

      homeConfigurations.work = home-manager.lib.homeManagerConfiguration {
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
}
