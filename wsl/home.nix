{ pkgs, lib, ... }:

let
  emacsPackage = if pkgs.stdenv.hostPlatform.system == "aarch64-darwin" then
    pkgs.emacs29-macport
  else
    pkgs.emacs29;
in
{
  programs = {
    zsh.enable = true;
    emacs = {
      enable = true;
      package = emacsPackage;
      extraPackages = epkgs: with epkgs; [
        use-package terraform-mode flycheck flycheck-inline dockerfile-mode nix-mode
        treemacs markdown-mode treemacs-all-the-icons modus-themes helm vterm grip-mode
        dash s editorconfig autothemer rust-mode lsp-mode dashboard direnv projectile
        nerd-icons doom-modeline company catppuccin-theme yaml-mode csv-mode
        codeium web-mode lsp-ui treemacs-nerd-icons nerd-icons
      ];
    };
  };

  fonts.fontconfig.enable = true;  

  home = {
    packages = with pkgs; [ zsh direnv gh zellij home-manager iperf3 
                            nerd-fonts.symbols-only xdotool neofetch ];
    file.".emacs.d/init.el".source = ./emacs/init.el;
    file."bin/fullscreen.sh".source = ./scripts/fullscreen.sh;
  };
}
