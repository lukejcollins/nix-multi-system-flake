{ pkgs, lib, ... }:

let
  # Python Environment Definition
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim flake8 pylint black requests grip ratelimit typing unidecode
  ]);

  # Powerlevel10k Installation Definition
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };

in
{
  home = {
    # Set the session variables
    sessionVariables = {
      # Set the default editor to vim
      EDITOR = "vim";
    };

    packages = [
      myPythonEnv
    ];

    # Set the default stateVersion to the latest version
    stateVersion = "23.11"; # Make sure this matches the Nixpkgs version you are using

    # Set the file locations for the configuration files
    file.".config/alacritty/alacritty.yml".source = ./dotfiles/alacritty/alacritty.toml;
    file.".zshrc".source = ./dotfiles/.zshrc;
    file.".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    file.".config/direnv/direnvrc".source = ./dotfiles/direnv/direnvrc;
    file.".config/zellij/config.kdl".source = ./dotfiles/zellij/config.kdl;
    file."/powerlevel10k".source = powerlevel10kSrc;
  };
}
