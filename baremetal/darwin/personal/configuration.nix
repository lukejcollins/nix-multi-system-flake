{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    qbittorrent
    keka
    google-chrome
    fleetctl
    jdk17
  ];

  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  homebrew = {
    enable = true;

    brews = [
      "nmap"
    ];

    casks = [
      "tailscale-app"
      "nordvpn"
      "steam"
      "chatgpt"
      "android-studio"
      "android-platform-tools"
    ];
  };
}
