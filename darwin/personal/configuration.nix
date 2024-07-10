{ config, pkgs, ... }:

let

in
{
  environment.systemPackages = with pkgs; [
    qbittorrent keka
  ];
}
