{ config, pkgs, ... }:

{
  ids.gids.nixbld = 350;

  documentation.enable = false;

  system.tools.darwin-uninstaller.enable = false;

  nix = {
    package = pkgs.lix;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      always-allow-substitutes = true;
      extra-trusted-substituters = [
        "https://cache.lix.systems"
      ];
      extra-trusted-public-keys = [
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      bash-prompt-prefix = "(nix:$name) ";
      max-jobs = "auto";
      extra-nix-path = [
        "nixpkgs=flake:nixpkgs"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    raycast
  ];

  launchd.user.agents.emacs-daemon = {
    serviceConfig = {
      ProgramArguments = [
        "/etc/profiles/per-user/${config.system.primaryUser}/bin/emacs"
        "--daemon"
      ];
      RunAtLoad = true;
      KeepAlive = true;
      ProcessType = "Background";
      StandardOutPath = "/tmp/emacs-daemon.log";
      StandardErrorPath = "/tmp/emacs-daemon-error.log";
      EnvironmentVariables = {
        EMACS_SERVER_FILE = "/tmp/emacs$(id -u)/server";
      };
    };
  };

  system = {
    stateVersion = 4;

    defaults = {
      NSGlobalDomain.AppleInterfaceStyle = "Dark";

      dock = {
        wvous-tl-corner = 1;
        wvous-tr-corner = 1;
        wvous-bl-corner = 1;
        wvous-br-corner = 1;
        autohide = true;
        autohide-delay = 86400.0;
      };
    };

    activationScripts.extraActivation.text = ''
      softwareupdate --install-rosetta --agree-to-license
    '';
  };
}
