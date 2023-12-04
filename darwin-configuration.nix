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
    shfmt statix nixpkgs-fmt postgresql docker-compose tailscale uebersicht gcc
    (emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      alwaysTangle = true;
      package = pkgs.emacs-pgtk;
      extraEmacsPackages = epkgs: [
        epkgs.use-package epkgs.terraform-mode epkgs.flycheck epkgs.flycheck-inline
        epkgs.dockerfile-mode epkgs.nix-mode epkgs.blacken epkgs.treemacs
        epkgs.treemacs-all-the-icons epkgs.modus-themes epkgs.helm epkgs.vterm
        epkgs.markdown-mode epkgs.grip-mode epkgs.dash epkgs.s epkgs.editorconfig
        epkgs.autothemer epkgs.ivy epkgs.counsel epkgs.rust-mode
        epkgs.lsp-mode epkgs.modus-themes epkgs.dashboard
      ];
    })
  ];

  fonts = {
     enableFontDir = true;
     fonts = [ pkgs.nerdfonts ];
   };
  
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/d194712b55853051456bc47f39facc39d03cbc40.tar.gz";
      sha256 = "sha256:08akyd7lvjrdl23vxnn9ql9snbn25g91pd4hn3f150m79p23lrrs";
    }))
  ];

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

  launchd.user.agents = { 
    wallpaper = {
      script = ''
        /usr/bin/osascript /etc/set-wallpaper.scpt
      '';
      serviceConfig = {
        StartInterval = 60;
        RunAtLoad = true;
        KeepAlive = false;
      };
    };
    ubersicht = {
      serviceConfig = {
	Program = "/Applications/Nix Apps/Übersicht.app/Contents/MacOS/Übersicht"; 
        RunAtLoad = true;
        KeepAlive = false;
      };
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
