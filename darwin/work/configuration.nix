{ config, pkgs, ... }:

let

in
{
  # Enable wallpaper service
  launchd.user.agents = { 
    wallpaper = {
      script = ''
        /usr/bin/osascript /etc/set-wallpaper.scpt
      '';
      serviceConfig = {
        StartInterval = 60;
        RunAtLoad = true;
        KeepAlive = false;
      };
    };
  };

  services.yabai.extraConfig = "/Users/luke.collins/.config/yabai/yabairc";

  # Move files into place
  environment.etc."set-wallpaper.scpt".source = ./applescript/set-wallpaper.scpt;
}
