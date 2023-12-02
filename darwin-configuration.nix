{ config, pkgs, ... }:

{
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [ 
    vim git gh alacritty
  ];

  # Services configuration
  services = {
    nix-daemon = {
      enable = true;
    };

    yabai = { 
      enable = true;
      package = pkgs.yabai;
      extraConfig = "/Users/luke.collins/.config/yabai/yabairc";
    };
    
    skhd = {
     enable = true;
     package = pkgs.skhd;
    };
  };

  launchd.user.agents.wallpaper = {
    script = ''
      /usr/bin/osascript /etc/set-wallpaper.scpt
    '';
    serviceConfig = {
      StartInterval = 60;
      RunAtLoad = true;
      KeepAlive = false;
    };
  };

  # Enable Zsh
  programs.zsh.enable = true;

  # AppleScript for wallpaper
  environment.etc."set-wallpaper.scpt".source = ./applescript/set-wallpaper.scpt;

  # System State Version and defaults
  system.stateVersion = 4; # Ensure this matches your setup
  system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
}
