{ config, pkgs, ... }:

let
  # Placeholder for future variables or configurations
in
{
  # Bootloader and kernel configuration
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_6_9;
  };

  # Set hostname
  networking.hostName = "nixos";

  # Install system packages
  environment.systemPackages = with pkgs; [
    home-manager
    xwayland
    google-chrome
    (emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      alwaysTangle = true;
      package = emacs29;
      extraEmacsPackages = epkgs: with epkgs; [
        use-package terraform-mode flycheck flycheck-inline dockerfile-mode
        nix-mode treemacs markdown-mode treemacs-all-the-icons modus-themes
        helm dash s editorconfig autothemer rust-mode lsp-mode
        dashboard direnv projectile nerd-icons doom-modeline company
        catppuccin-theme yaml-mode flycheck csv-mode web-mode gptel
      ];
    })
  ];

  # Enable NetworkManager for networking
  networking.networkmanager.enable = true;

  # Set timezone
  time.timeZone = "Europe/London";

  # Internationalisation settings
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

  # Enable Firefox
  programs.firefox.enable = true;

  # System services configuration
  services = {
    # Enable firmware updates
    fwupd.enable = true;

    # Enable printing support
    printing.enable = true;

    # Enable PipeWire for audio
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  # Enable Docker virtualisation
  virtualisation.docker.enable = true;

  # System state version
  system.stateVersion = "24.05"; # Did you read the comment?
}
