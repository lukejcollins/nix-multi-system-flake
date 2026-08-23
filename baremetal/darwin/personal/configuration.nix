{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qbittorrent
    keka
    google-chrome
    fleetctl
  ];
}
