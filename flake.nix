{
  description = "A flake to handle multiple systems with a hierarchy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    powerlevel10k = {
      url = "github:romkatv/powerlevel10k/017395a266aa15011c09e64e44a1c98ed91c478c";
      flake = false;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-darwin,
    powerlevel10k,
    ...
  }:
  let
    optionalImport = path:
      if builtins.pathExists path then [ path ] else [ ];

    personalHomePkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.personal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules =
        [ ./baremetal/nixos/personal/hardware-configuration.nix ]
        ++ optionalImport ./baremetal/configuration.nix
        ++ optionalImport ./baremetal/nixos/configuration.nix
        ++ optionalImport ./baremetal/nixos/personal/configuration.nix
        ++ [ home-manager.nixosModules.home-manager ];
    };

    darwinConfigurations = {
      personal = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules =
          optionalImport ./baremetal/configuration.nix
          ++ optionalImport ./baremetal/darwin/configuration.nix
          ++ optionalImport ./baremetal/darwin/personal/configuration.nix
          ++ [
          {
            system.primaryUser = "lukecollins";
            users.users."lukecollins".home = "/Users/lukecollins";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit powerlevel10k;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."lukecollins" = {
              imports =
                optionalImport ./home.nix
                ++ optionalImport ./baremetal/home.nix
                ++ optionalImport ./baremetal/darwin/home.nix
                ++ optionalImport ./baremetal/darwin/personal/home.nix;
            };
          }
        ];
      };

      work = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules =
          optionalImport ./baremetal/configuration.nix
          ++ optionalImport ./baremetal/darwin/configuration.nix
          ++ optionalImport ./baremetal/darwin/work/configuration.nix
          ++ [
          {
            system.primaryUser = "luke.collins";
            users.users."luke.collins".home = "/Users/luke.collins";
          }
          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = {
              inherit powerlevel10k;
            };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."luke.collins" = {
              imports =
                optionalImport ./home.nix
                ++ optionalImport ./baremetal/home.nix
                ++ optionalImport ./baremetal/darwin/home.nix
                ++ optionalImport ./baremetal/darwin/work/home.nix;
            };
          }
        ];
      };
    };

    homeConfigurations.personal =
      home-manager.lib.homeManagerConfiguration {
        pkgs = personalHomePkgs;
        extraSpecialArgs = {
          inherit powerlevel10k;
        };
        modules =
          optionalImport ./home.nix
          ++ optionalImport ./baremetal/home.nix
          ++ optionalImport ./baremetal/nixos/home.nix
          ++ optionalImport ./baremetal/nixos/personal/home.nix
          ++ [
          {
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
        ];
      };
  };
}
