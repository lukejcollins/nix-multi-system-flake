{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.kernel.sysctl."vm.max_map_count" = 2147483642;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-validation-layers
        vulkan-tools
        egl-wayland
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vulkan-loader
      ];
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    steam-hardware.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      xkb.layout = "us";
      videoDrivers = [ "nvidia" ];
    };

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    desktopManager.gnome.enable = true;

    udev.packages = [ pkgs.game-devices-udev-rules ];
    system76-scheduler.enable = true;
  };

  programs = {
    steam = {
      enable = true;
      extraPackages = with pkgs; [
        mangohud
        vkbasalt
      ];
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      protontricks.enable = true;
      extest.enable = true;
    };

    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          softrealtime = "auto";
          inhibit_screensaver = 1;
        };
        gpu.apply_clock_min_max = "auto";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    discord
    heroic
    lutris
    mangohud
    protonup-ng
    steam-run
    vkd3d-proton
    vkbasalt
    vulkan-tools
    vulkan-validation-layers
    wineWowPackages.staging
    winetricks
  ];

  environment.sessionVariables = {
    PROTON_ENABLE_NVAPI = "1";
    DXVK_ASYNC = "1";
    VKD3D_CONFIG = "force_static_cbv";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gnome ];
  };
}
