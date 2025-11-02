{ pkgs, lib, ... }:

let
  # Additional configuration will be added later.
in
{
  programs.vscode = {
    enable = true;

    profiles.default.extensions = with pkgs.vscode-marketplace; [
      ms-azuretools.vscode-docker
      timonwong.shellcheck
      rust-lang.rust-analyzer
      yzhang.markdown-all-in-one
      davidanson.vscode-markdownlint
      redhat.vscode-yaml
      jnoortheen.nix-ide
      ms-python.python
      hashicorp.terraform
      mechatroner.rainbow-csv
      jnoortheen.nix-ide
      ms-python.black-formatter
      ms-python.flake8
      ms-python.pylint
      matangover.mypy
      ms-python.isort
      ms-vsliveshare.vsliveshare
      github.vscode-github-actions
      ms-azuretools.vscode-azureappservice
      ms-vscode.powershell
      azps-tools.azps-tools
      ms-vscode.azurecli
      msazurermtools.azurerm-vscode-tools
      ms-azuretools.vscode-azurefunctions
      ms-azuretools.vscode-azureresourcegroups
    ];

    mutableExtensionsDir = true;

    profiles.default.userSettings = {
      "editor.tabSize" = 4;
      "editor.formatOnSave" = true;
      "terminal.integrated.fontFamily" = "MesloLGS Nerd Font";
      "[rust]" = { "editor.formatOnSave" = true; };
      "[nix]" = { "editor.formatOnSave" = true; };
      "[sh]" = { "editor.formatOnSave" = true; };
      "[dockerfile]" = { "editor.formatOnSave" = true; };
      "[terraform]" = { "editor.formatOnSave" = true; };
      "[yaml]" = { "editor.formatOnSave" = true; };
      "[python]" = { "editor.formatOnSave" = true; };
      "flake8.args" = [ "--max-line-length=88" ];
    };

    profiles.default.keybindings = [
      {
        key = "ctrl+x ctrl+s";
        command = "workbench.action.files.save";
      }
    ];
  };
}
