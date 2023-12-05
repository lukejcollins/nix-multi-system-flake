{ pkgs, lib, ... }:

let
  simpleBarWidget = pkgs.fetchFromGitHub {
    owner = "lukejcollins";
    repo = "simple-bar";
    rev = "b275b7499861590437faada2aff1a75e2a183945";
    sha256 = "sha256-IlURi4lcLUHdzH/N3wN06oFMGJstFSqDjgRHCp3h6WQ="; # Replace with the actual SHA
  };

  # Emacs Copilot and Powerlevel10k Installation Definitions
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };
  emacsCopilotSrc = builtins.fetchGit {
    url = "https://github.com/zerolfx/copilot.el.git";
    rev = "421703f5dd5218ec2a3aa23ddf09d5f13e5014c2";
  };

in
{

  home = {
    sessionVariables = {
      EDITOR = "vim";
    };

    stateVersion = "23.11"; # Make sure this matches the Nixpkgs version you are using

    file.".config/alacritty/alacritty.yml".source = ./dotfiles/alacritty/alacritty.yml;
    file.".config/yabai/yabairc".source = ./dotfiles/yabai/yabairc;
    file.".skhdrc".source = ./dotfiles/.skhdrc;
    file.".simplebarrc".source = ./dotfiles/.simplebarrc;
    file."Library/Application Support/Übersicht/widgets/simple-bar".source = simpleBarWidget;
    file."/powerlevel10k".source = powerlevel10kSrc;
    file.".emacsCopilot".source = emacsCopilotSrc;
    file.".zshrc".source = ./dotfiles/.zshrc;
    file.".p10k.zsh".source = ./dotfiles/.p10k.zsh;
    file.".config/direnv/direnvrc".source = ./dotfiles/direnv/direnvrc;
  };
  # Note: Zsh is not enabled here as it's managed by Nix Darwin instead
}
