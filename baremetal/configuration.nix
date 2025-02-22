{ config, pkgs, ... }:

{
  # Allow installation of unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Install system packages
  environment.systemPackages = with pkgs; [
    vim git gh alacritty wget docker nodejs python3 python3Packages.pip
    zellij pet shfmt postgresql docker-compose tailscale gcc direnv neofetch
    pyright nil bash-language-server dockerfile-language-server-nodejs terraform-ls
    clippy awscli2 typst yarn fzf spotify yaml-language-server act jq kubectl
    minikube aws-nuke tre-command fzf bat eza terraform emmet-ls poetry
    powershell azure-functions-core-tools dotenv-cli
  ];

  # Install fonts
  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.meslo-lgs-nf
  ];

  # Enable and configure system services
  services = {
    # Enable Tailscale VPN
    tailscale.enable = true;
  };

  # Enable Zsh shell
  programs.zsh.enable = true;
}
