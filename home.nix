{ pkgs, lib, ... }:

let
  myPythonEnv = pkgs.python3.withPackages (ps:
    with ps; [
      pynvim flake8 pylint black requests grip ratelimit typing unidecode
      python-lsp-server isort pyls-isort pylsp-mypy mypy types-requests
      python-lsp-black django-stubs boto3-stubs
    ]
  );

  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };
in
{
  nixpkgs.config.allowUnfree = true;

  home = {
    sessionVariables.EDITOR = "vim";

    packages = [ myPythonEnv ];

    file = {
      ".zshrc".source = ./dotfiles/.zshrc;
      ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
      ".config/direnv/direnvrc".source = ./dotfiles/direnv/direnvrc;
      "/powerlevel10k".source = powerlevel10kSrc;
    };

    stateVersion = "23.11";
  };
}
