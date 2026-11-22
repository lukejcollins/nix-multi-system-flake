{ pkgs, ... }:

let
  alacrittyConfig = import ../config/alacritty.nix;
in {
  home.packages = with pkgs; [
    bat
    eza
    fastfetch
    fzf
    imagemagick
    jq
    pet
    ripgrep
    tre-command
    typst
    wget
  ];

  programs = {
    alacritty = {
      enable = true;
      settings = alacrittyConfig;
    };

    git.enable = true;
    vim.enable = true;

    zellij = {
      enable = true;
      enableZshIntegration = true;
      settings.theme = "catppuccin-mocha";
    };
  };
}
