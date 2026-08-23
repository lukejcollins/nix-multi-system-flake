{ pkgs, ... }:

let
  alacrittyConfig = import ./config/alacritty.nix { inherit pkgs; };
  emacsConfig = builtins.readFile ./config/emacs.el;
in
{
  home.packages = with pkgs; [
    act
    aws-nuke
    awscli2
    bash-language-server
    bat
    clippy
    codex
    codex-acp
    direnv
    dockerfile-language-server
    dotenv-cli
    eza
    fastfetch
    firefox-bin
    fzf
    gcc
    geckodriver
    gh
    git
    imagemagick
    jq
    kubectl
    minikube
    multimarkdown
    nil
    nodejs
    pet
    poetry
    pyright
    ripgrep
    ruby
    rubyPackages.htmlbeautifier
    rubyPackages.rubocop
    rubyPackages.solargraph
    rust-analyzer
    shfmt
    spotify
    terraform
    terraform-ls
    tre-command
    typst
    vim
    vscode-langservers-extracted
    wget
    yaml-language-server
    yarn
    zellij
  ];

  programs.alacritty = {
    enable = true;
    settings = alacrittyConfig;
  };

  programs.emacs = {
    enable = true;
    extraConfig = emacsConfig;
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
