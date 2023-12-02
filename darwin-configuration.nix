{ config, pkgs, ... }:

let
  uebersicht = pkgs.stdenv.mkDerivation {
    name = "Uebersicht-1.6.77";
    buildInputs = [ pkgs.unzip pkgs.glibcLocales ];
    src = pkgs.fetchurl {
      url = "https://tracesof.net/uebersicht/releases/Uebersicht-1.6.77.app.zip";
      sha256 = "sha256-jxGxY1YYCMylJs7kkUCyIczNo7u2n1qcoL2KdQ58h70="; # Placeholder SHA
    };

    unpackPhase = ''
      export LANG=en_US.UTF-8
      export LC_ALL=en_US.UTF-8
      unzip $src
    '';

    installPhase = ''
      mkdir -p $out/Applications
      cp -R "Übersicht.app" $out/Applications/
    '';
  };
in
{
  environment.systemPackages = with pkgs; [
    vim git gh alacritty wget docker nodejs python3 python3Packages.pip vscode shellcheck
    shfmt statix nixpkgs-fmt postgresql docker-compose tailscale uebersicht
  ];

  nixpkgs.config.allowUnfree = true;

  # Services configuration
  services = {
    nix-daemon = {
      enable = true;
    };

    yabai = {
      enable = true;
      package = pkgs.yabai;
      extraConfig = "/Users/luke.collins/.config/yabai/yabairc";
    };

    skhd = {
     enable = true;
     package = pkgs.skhd;
    };
  };

  launchd.user.agents.wallpaper = {
    script = ''
      /usr/bin/osascript /etc/set-wallpaper.scpt
    '';
    serviceConfig = {
      StartInterval = 60;
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  # Enable Zsh
  programs.zsh.enable = true;

  # AppleScript for wallpaper
  environment.etc."set-wallpaper.scpt".source = ./applescript/set-wallpaper.scpt;

  # System State Version and defaults
  system.stateVersion = 4; # Ensure this matches your setup
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
}
