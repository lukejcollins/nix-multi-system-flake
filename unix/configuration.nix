{ config, pkgs, ... }:

let
  # Get the current system architecture
  arch = pkgs.stdenv.hostPlatform.system;

  # Define Emacs package based on the system architecture
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
    shfmt postgresql docker-compose tailscale gcc direnv neofetch pyright
    nil bash-language-server dockerfile-language-server-nodejs terraform-ls
    clippy awscli2 typst yarn fzf spotify yaml-language-server act jq kubectl minikube
    aws-nuke tre-command fzf bat eza terraform emmet-ls poetry azure-cli powershell
    azure-functions-core-tools
    # aws-sam-cli failing to build
    # Install Emacs with packages
    (emacsWithPackagesFromUsePackage {
      config = ./emacs/init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      alwaysTangle = true;
      package = emacsPackage;
      extraEmacsPackages = epkgs: with epkgs; [
        use-package terraform-mode flycheck flycheck-inline dockerfile-mode
        nix-mode treemacs markdown-mode treemacs-all-the-icons modus-themes
        helm vterm grip-mode dash s editorconfig autothemer rust-mode lsp-mode
        dashboard direnv projectile nerd-icons doom-modeline company
        catppuccin-theme yaml-mode flycheck csv-mode codeium web-mode
      ];
    })
  ];

  # Install fonts
  fonts = {
    packages = [ pkgs.nerdfonts ];
  };

  # Add Emacs overlay
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/d194712b55853051456bc47f39facc39d03cbc40.tar.gz";
      sha256 = "sha256:08akyd7lvjrdl23vxnn9ql9snbn25g91pd4hn3f150m79p23lrrs";
    }))
  ];

  # Services configuration
  services = {
    # Enable Tailscale
    tailscale = {
      enable = true;
    };
  };

  # Enable Zsh
  programs.zsh.enable = true;
}
