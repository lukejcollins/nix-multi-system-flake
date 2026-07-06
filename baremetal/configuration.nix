{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    postgresql
  ];

  fonts.packages = [
    pkgs.nerd-fonts.symbols-only
    pkgs.meslo-lgs-nf
  ];

  programs.zsh.enable = true;
}
