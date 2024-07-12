{ config, pkgs, ... }:

let

in
{
  environment.systemPackages = with pkgs; [
    qbittorrent keka
  ];

  services.yabai.extraConfig = "/Users/lukecollins/.config/yabai/yabairc";
}
