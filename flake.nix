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
    nixpkgs,
    home-manager,
    nix-darwin,
    powerlevel10k,
    ...
  }:
  let
    optionalImport = path:
      if builtins.pathExists path then [ path ] else [ ];

    homeModules = profile: platform:
      [
        ./home.nix
        ./baremetal/home.nix
      ]
      ++ optionalImport (./baremetal + "/${platform}/home.nix")
      ++ optionalImport (./baremetal + "/${platform}/${profile}/home.nix");

    mkDarwinHost = {
      profile,
      username,
      system ? "aarch64-darwin",
    }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          ./baremetal/configuration.nix
          ./baremetal/darwin/configuration.nix
          home-manager.darwinModules.home-manager
          {
            system.primaryUser = username;
            users.users.${username}.home = "/Users/${username}";

            home-manager = {
              extraSpecialArgs = { inherit powerlevel10k; };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username}.imports = homeModules profile "darwin";
            };
          }
        ] ++ optionalImport (./baremetal/darwin + "/${profile}/configuration.nix");
      };

    mkNixosHost = {
      profile,
      username,
      system ? "x86_64-linux",
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./baremetal/configuration.nix
          ./baremetal/nixos/configuration.nix
          (./baremetal/nixos + "/${profile}/configuration.nix")
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = { inherit powerlevel10k; };
              useGlobalPkgs = true;
              useUserPackages = true;
              users.${username}.imports = homeModules profile "nixos";
            };
          }
        ];
      };
  in {
    nixosConfigurations.personal = mkNixosHost {
      profile = "personal";
      username = "lukecollins";
    };

    darwinConfigurations = {
      personal = mkDarwinHost {
        profile = "personal";
        username = "lukecollins";
      };

      work = mkDarwinHost {
        profile = "work";
        username = "luke.collins";
      };
    };
  };
}
