{ config, pkgs, ... }:

let
  # Define Übersicht package
  uebersicht = pkgs.stdenv.mkDerivation {
    name = "uebersicht-1.6.82";
    buildInputs = [ pkgs.unzip pkgs.glibcLocales ];
    src = pkgs.fetchurl {
      url = "https://tracesof.net/uebersicht/releases/Uebersicht-1.6.82.app.zip";
      sha256 = "sha256-OdteCr8D9jkJklEclGwZuXqJ+E6+KshyGev5If/7lys=";
    };

    unpackPhase = ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      unzip $src
    '';

    installPhase = ''
      mkdir -p $out/Applications
      cp -R "Übersicht.app" $out/Applications/
    '';
  };

in
{
  # Install system packages
  environment.systemPackages = with pkgs; [
    uebersicht   # Übersicht widget system
    colima       # Docker alternative for macOS
    raycast      # Productivity launcher
    utm          # Virtualization software
  ];

  # Services configuration
  services = {
    # Enable Yabai (tiling window manager)
    yabai = {
      enable = true;
      package = pkgs.yabai;
    };

    # Enable skhd (hotkey daemon for macOS)
    skhd = {
      enable = true;
      package = pkgs.skhd;
    };
  };
  
  # Enable Homebrew and install packages
  homebrew = {
    enable = true;
    brews = [ "emacs-plus@29" ];
  };

  # Launchd user agents (macOS services)
  launchd.user.agents = {
    # Enable Übersicht as a background service (Wallpaper widgets)
    uebersicht = {
      serviceConfig = {
        Program = "/Applications/Nix Apps/Übersicht.app/Contents/MacOS/Übersicht";
        RunAtLoad = true;
        KeepAlive = false;
      };
    };

    # Enable Emacs daemon as a background service
    emacs-daemon = {
      serviceConfig = {
        ProgramArguments = [ "/opt/homebrew/opt/emacs-plus@29/bin/emacs" "--daemon" ];
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Background";
        StandardOutPath = "/tmp/emacs-daemon.log";
        StandardErrorPath = "/tmp/emacs-daemon-error.log";
        EnvironmentVariables = {
          EMACS_SERVER_FILE = "/tmp/emacs$(id -u)/server";
        };
      };
    };
  };

  # System configuration
  system = {
    stateVersion = 4;

    # macOS system defaults
    defaults = {
      NSGlobalDomain.AppleInterfaceStyle = "Dark"; # Enable dark mode

      # Dock customization
      dock = {
        wvous-tl-corner = 1;  # Enable hot corner (top-left)
        wvous-tr-corner = 1;  # Enable hot corner (top-right)
        wvous-bl-corner = 1;  # Enable hot corner (bottom-left)
        wvous-br-corner = 1;  # Enable hot corner (bottom-right)
        autohide = true;       # Auto-hide dock
        autohide-delay = 86400.0; # Extreme delay to effectively disable animation
      };
    };

    # Activation script to install Rosetta for Apple Silicon
    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';
  };
}
