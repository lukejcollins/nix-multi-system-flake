{ config, pkgs, ... }:

let
  # Placeholder for future variables or configurations
in
{
  # Bootloader and boot configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_9;
  };

  # Hostname configuration
  networking.hostName = "nixos";

  # Install packages
  environment.systemPackages = with pkgs; [
    home-manager xwayland google-chrome
  ];

  # Networking configuration
  networking.networkmanager.enable = true;

  # Timezone configuration
  time.timeZone = "Europe/London";

  # Internationalisation properties
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  # Sound configuration
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  # User configuration
  users.users.lukecollins = {
    isNormalUser = true;
    description = "Luke Collins";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # Programs configuration
  programs.firefox.enable = true;

  # Services configuration
  services = {
    fwupd.enable = true;
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  # Enable Docker
  virtualisation.docker.enable = true;

  # System state version
  system.stateVersion = "24.05"; # Did you read the comment?
}
