{ pkgs, lib, ... }:

let
  # Python Environment Definition
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim flake8 pylint black requests grip ratelimit typing unidecode python-lsp-server
    isort pyls-isort pylsp-mypy mypy types-requests python-lsp-black django-stubs boto3-stubs
  ]);

  # Powerlevel10k Installation Definition
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };

in
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home = {

    # Set the session variables
    sessionVariables = {
      # Set the default editor to vim
      EDITOR = "vim";
    };

    packages = [
      myPythonEnv
    ];

    # Set the file locations for the configuration files
    file = {
      ".zshrc".source = ./dotfiles/.zshrc;
      ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
      ".config/direnv/direnvrc".source = ./dotfiles/direnv/direnvrc;
      ".config/zellij/config.kdl".source = ./dotfiles/zellij/config.kdl;
      "/powerlevel10k".source = powerlevel10kSrc;
    };

    # Set the default stateVersion to the latest version
    stateVersion = "23.11";
  };
}
