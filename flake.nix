{
  description = "A flake to handle multiple systems with a hierarchy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    darwin.url = "github:LnL7/nix-darwin";
  };

  outputs = { home-manager, nix-darwin, ... }:
    {
      nixosConfigurations = {
        personal = {
          imports = [
            ./configuration.nix
            ./nixos/configuration.nix
            ./nixos/personal/configuration.nix
            ./nixos/personal/hardware-configuration.nix
          ];
        };

        work = {
          imports = [
            ./configuration.nix
            ./nixos/configuration.nix
            ./nixos/work/configuration.nix
            ./nixos/work/hardware-configuration.nix
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
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.personal = {
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
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.work = {
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

      homeManagerConfigurations = {
        personalNixOS = { pkgs, ... }: {
          home = {
            imports = [
              ./home.nix
              ./nixos/home.nix
              ./nixos/personal/home.nix
            ];
          };
        };

        workNixOS = { pkgs, ... }: {
          home = {
            imports = [
              ./home.nix
              ./nixos/home.nix
              ./nixos/work/home.nix
            ];
          };
        };
      };
    };
}
