{ pkgs, lib, ... }:

{
  programs = {
    # Enable Zsh shell
    zsh.enable = true;

    # Enable Emacs with the selected package and extra packages
    emacs = {
      enable = true;
      package = pkgs.emacs29;
      extraPackages = epkgs: with epkgs; [
        use-package terraform-mode flycheck flycheck-inline dockerfile-mode nix-mode
        treemacs markdown-mode treemacs-all-the-icons modus-themes helm
        dash s editorconfig autothemer rust-mode lsp-mode dashboard direnv projectile
        nerd-icons doom-modeline company catppuccin-theme yaml-mode csv-mode
        web-mode lsp-ui treemacs-nerd-icons nerd-icons
      ];
    };
  };

  # Enable Fontconfig for better font rendering
  fonts.fontconfig.enable = true;  

  home = {
    # Install essential packages
    packages = with pkgs; [
      zsh direnv gh zellij home-manager iperf3
      nerd-fonts.symbols-only neofetch wget
      polybar feh git-credential-manager pass
      pass-git-helper
    ];

    # Symlink dotfiles and scripts to the home directory
    file.".emacs.d/init.el".source = ./emacs/init.el;
    file.".config/i3/config".source = ./dotfiles/i3/config;
    file.".config/polybar/config.ini".source = ./dotfiles/polybar/config.ini;
    file."bin/xresize.sh".source = ./scripts/xresize.sh;
  };
}
