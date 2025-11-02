{ config, pkgs, ... }:

let
  # Placeholder for future variables or configurations
in
{
  imports = [ ./hardware-configuration.nix ];

  # Fix for Proton/Wine-heavy titles
  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

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
      open = false;  # Proprietary NVIDIA driver
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };

    # Controller udev rules
    steam-hardware.enable = true;
  };

  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = [ "nvidia" ];
  };

  # Enable COSMIC display manager and desktop
  services.displayManager.cosmic-greeter.enable = true;
  services.desktopManager.cosmic.enable = true;

  # Steam configuration
  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
  };

  # Performance and frame pacing helpers
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  # Portal integration for COSMIC
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-cosmic ];
  };
}
