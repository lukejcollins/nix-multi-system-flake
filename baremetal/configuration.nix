{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim git gh wget docker nodejs python3 python3Packages.pip
    zellij pet shfmt postgresql docker-compose tailscale gcc direnv neofetch
    pyright nil bash-language-server dockerfile-language-server terraform-ls
    clippy awscli2 typst yarn fzf spotify yaml-language-server act jq kubectl
    minikube aws-nuke tre-command fzf bat eza terraform emmet-ls poetry
    powershell azure-functions-core-tools dotenv-cli
  ];

  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.meslo-lgs-nf
  ];

  services.tailscale.enable = true;

  programs.zsh.enable = true;
}
