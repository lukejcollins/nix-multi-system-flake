{
  description = "A flake to handle multiple systems with a hierarchy";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = { self, nixpkgs, home-manager, nix-vscode-extensions, ... }: {
    nixosConfigurations.personal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./baremetal/configuration.nix
        ./baremetal/nixos/configuration.nix
        ./baremetal/nixos/personal/configuration.nix
        ./baremetal/nixos/personal/hardware-configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };

    homeConfigurations.personal =
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          ./home.nix
          ./baremetal/home.nix
          ./baremetal/nixos/home.nix
          ./baremetal/nixos/personal/home.nix
          {
            home.username = "lukecollins";
            home.homeDirectory = "/home/lukecollins";
          }
          { nixpkgs.overlays = [ nix-vscode-extensions.overlays.default ]; }
        ];
      };
  };
}
