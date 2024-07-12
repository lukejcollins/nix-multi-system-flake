{ config, pkgs, ... }:

let
  # Placeholder for future variables or configurations
in
{
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix
  ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Enable programs
  programs.steam.enable = true;

  # Load Nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Install packages
  environment.systemPackages = with pkgs; [
    gnomeExtensions.forge
  ];

  # Nvidia hardware configuration
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Enable the X11 windowing system
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "";
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
