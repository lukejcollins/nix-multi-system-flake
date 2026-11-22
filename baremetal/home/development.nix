{ pkgs, ... }:

let
  pythonTooling = pkgs.python3.withPackages (ps: with ps; [
    debugpy
    pytest
    ruff
  ]);
in {
  home.packages = with pkgs; [
    act
    aws-nuke
    awscli2
    bash-language-server
    clippy
    codex
    codex-acp
    dockerfile-language-server
    dotenv-cli
    gcc
    gh
    kubectl
    minikube
    multimarkdown
    nil
    nodejs
    poetry
    postgresql
    pyright
    pythonTooling
    ruby
    rubyPackages.htmlbeautifier
    rubyPackages.rubocop
    rubyPackages.solargraph
    rust-analyzer
    shfmt
    terraform
    terraform-ls
    vscode-langservers-extracted
    yaml-language-server
    yarn
  ];
}
