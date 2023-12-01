{ config, pkgs, ... }:

{
  # Import Home Manager module
  imports = [
    <home-manager/nix-darwin>
  ];

  # Define user luke.collins
  users.users."luke.collins" = {
    home = "/Users/luke.collins";
    # Additional user configuration can be added here
  };

  # Enable and configure Home Manager for your user
  home-manager.users."luke.collins" = { pkgs, ... }: {
    home = {
      sessionVariables = {
        EDITOR = "vim";
      };
      stateVersion = "23.11"; # Make sure this matches the Nixpkgs version you are using
    };
    # Note: Zsh is not enabled here as it's managed by Nix Darwin instead
  };

  # List packages installed in system profile.
  environment.systemPackages = [ pkgs.vim pkgs.git pkgs.gh ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
  };

  # Enable Zsh as the default shell
  programs.zsh.enable = true;

  # System State Version
  system.stateVersion = 4; # Ensure this matches your setup
}
