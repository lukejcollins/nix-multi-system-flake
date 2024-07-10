{ pkgs, lib, ... }:

let
  # Simple Bar Widget Installation Definition
  simpleBarWidget = pkgs.fetchFromGitHub {
    owner = "lukejcollins";
    repo = "simple-bar";
    rev = "b275b7499861590437faada2aff1a75e2a183945";
    sha256 = "sha256-IlURi4lcLUHdzH/N3wN06oFMGJstFSqDjgRHCp3h6WQ="; # Replace with the actual SHA
  };

in
{
  home = {
    # Set the file locations for the configuration files
    file.".config/yabai/yabairc".source = ../dotfiles/yabai/yabairc;
    file.".skhdrc".source = ../dotfiles/.skhdrc;
    file.".simplebarrc".source = ../dotfiles/.simplebarrc;
    file."Library/Application Support/Übersicht/widgets/simple-bar".source = simpleBarWidget;
  };
}
