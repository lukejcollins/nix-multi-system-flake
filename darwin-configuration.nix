{ config, pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = [ pkgs.vim pkgs.git pkgs.gh ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    extraConfig = "/Users/luke.collins/.config/yabai/yabairc";
  };

  programs.zsh.enable = true;

  # System State Version
  system.stateVersion = 4; # Ensure this matches your setup
}
