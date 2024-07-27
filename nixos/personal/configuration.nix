{ config, pkgs, ... }:

let
  # Placeholder for future variables or configurations
in
{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
  ];

  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };

  # Services configuration
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      videoDrivers = ["nvidia"];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  # Programs configuration
  programs = {
    steam.enable = true;
  };

  # Environment configuration
  environment = {
    systemPackages = with pkgs; [
      gnomeExtensions.forge
    ];
  };
}
