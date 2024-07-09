{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
  ];
}
