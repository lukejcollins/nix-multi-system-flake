{ config, pkgs, ... }:

let
  # Use uebersicht for desktop widgets
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
  # Install packages
  environment.systemPackages = with pkgs; [
    uebersicht colima raycast utm
  ];

  # Services configuration
  services = {
    # Enable yabai
    yabai = {
      enable = true;
      package = pkgs.yabai;
      extraConfig = "/Users/luke.collins/.config/yabai/yabairc";
    };

    # Enable skhd
    skhd = {
      enable = true;
      package = pkgs.skhd;
    };

    # Enable nix-daemon
    nix-daemon = {
      enable = true;
    };
  };

  };

  # Enable wallpaper service
  launchd.user.agents = { 
    # Enable Übersicht service
    ubersicht = {
      serviceConfig = {
	      Program = "/Applications/Nix Apps/Übersicht.app/Contents/MacOS/Übersicht"; 
        RunAtLoad = true;
        KeepAlive = false;
      };
    };
  };

  # System configuration
  system = {
    stateVersion = 4;
    defaults = {
      NSGlobalDomain.AppleInterfaceStyle = "Dark";
      dock = {
        wvous-tl-corner = 1; # Top left corner
        wvous-tr-corner = 1; # Top right corner
        wvous-bl-corner = 1; # Bottom left corner
        wvous-br-corner = 1; # Bottom right corner
        autohide = true;
        autohide-delay = 86400.0;
      };
    };
    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';
  };
}
