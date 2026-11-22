{ pkgs, ... }:

{
  programs.emacs = {
    enable = true;
    extraConfig = builtins.readFile ../config/emacs.el;
    extraPackages = epkgs: with epkgs; [
      use-package
      catppuccin-theme
      doom-modeline
      dashboard
      nerd-icons
      csv-mode
      projectile
      direnv
      helm
      company
      treemacs
      treemacs-nerd-icons
      terraform-mode
      dockerfile-mode
      nix-mode
      rust-mode
      markdown-mode
      yaml-mode
      web-mode
      inf-ruby
      rubocop
      flycheck
      lsp-mode
      lsp-pyright
      lsp-ui
      dap-mode
      pyvenv
      python-pytest
      ruff-format
      agent-shell
    ];
  };
}
