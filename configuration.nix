{ config, pkgs, ... }:

let
  arch = pkgs.stdenv.hostPlatform.system;  # Get the current system architecture
  emacsPackage = if arch == "aarch64-darwin" then
    pkgs.emacs29-macport
  else
    pkgs.emacs29;
  
in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Install packages
  environment.systemPackages = with pkgs; [
    vim git gh alacritty wget docker nodejs python3 python3Packages.pip zellij pet
    shfmt postgresql docker-compose tailscale gcc direnv neofetch nodePackages.pyright
    nil nodePackages.bash-language-server dockerfile-language-server-nodejs terraform-ls
    clippy awscli2 typst yarn fzf spotify yaml-language-server act jq
    # Install emacs with packages
    (emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      alwaysTangle = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: [
        epkgs.use-package epkgs.terraform-mode epkgs.flycheck epkgs.flycheck-inline
        epkgs.dockerfile-mode epkgs.nix-mode epkgs.treemacs epkgs.markdown-mode
        epkgs.treemacs-all-the-icons epkgs.modus-themes epkgs.helm epkgs.vterm
        epkgs.markdown-mode epkgs.grip-mode epkgs.dash epkgs.s epkgs.editorconfig
        epkgs.autothemer epkgs.rust-mode epkgs.lsp-mode epkgs.modus-themes
        epkgs.dashboard epkgs.direnv epkgs.projectile epkgs.nerd-icons
        epkgs.doom-modeline epkgs.grip-mode epkgs.company epkgs.elfeed epkgs.elfeed-protocol
        epkgs.catppuccin-theme epkgs.yaml-mode epkgs.flycheck epkgs.lsp-pyright
        epkgs.csv-mode
      ];
    })
  ];
 
  # Install fonts
  fonts = {
    packages = [ pkgs.nerdfonts ];
  };

  # Add emacs overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/d194712b55853051456bc47f39facc39d03cbc40.tar.gz";
      sha256 = "sha256:08akyd7lvjrdl23vxnn9ql9snbn25g91pd4hn3f150m79p23lrrs";
    }))
  ];

  # Services configuration
  services = {
    # Enable nix-daemon
    nix-daemon = {
      enable = true;
    };

    # Enable tailscale
    tailscale = {
      enable = true;
    };
  };

  # Enable Zsh
  programs.zsh.enable = true;
}
