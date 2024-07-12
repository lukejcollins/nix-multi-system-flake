{ config, pkgs, ... }:

let
  # Placeholder for future variables or configurations
in
{
  # Install packages
  environment.systemPackages = with pkgs; [
    qbittorrent keka
  ];

  # Yabai service configuration
  services.yabai = {
    extraConfig = "/Users/lukecollins/.config/yabai/yabairc";
  };
}
