{ pkgs, lib, ... }:

let
  # Placeholder for future variables or configurations
in
{
  programs.zsh = {
    enable = true;
  };

  home.packages = with pkgs; [
    zsh direnv gh
  ];
}
