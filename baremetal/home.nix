{ pkgs, lib, ... }:

let
  # Placeholder for future variables or configurations
in
{
  home = {
    # Define file locations for configuration files
    file = {
      ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
      ".emacs".source = ./emacs/init.el;
    };
  };

  programs.vscode = {
    enable = true;

    # List of VSCode extensions to install
    extensions = with pkgs.vscode-marketplace; [
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
      amazonwebservices.amazon-q-vscode
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

    # Allow manual installation of extensions outside Nix
    mutableExtensionsDir = true;

    # User-specific VSCode settings
    userSettings = {
      "editor.tabSize" = 4;
      "editor.formatOnSave" = true;
      "terminal.integrated.fontFamily" = "MesloLGS Nerd Font";

      # Enable format-on-save for specific file types
      "[rust]" = { "editor.formatOnSave" = true; };
      "[nix]" = { "editor.formatOnSave" = true; };
      "[sh]" = { "editor.formatOnSave" = true; };
      "[dockerfile]" = { "editor.formatOnSave" = true; };
      "[terraform]" = { "editor.formatOnSave" = true; };
      "[yaml]" = { "editor.formatOnSave" = true; };
      "[python]" = { "editor.formatOnSave" = true; };

      # Configure flake8 settings for Python
      "flake8.args" = ["--max-line-length=88"];

      # Disable telemetry and content sharing for Amazon Q
      "amazonQ.telemetry" = false;
      "amazonQ.shareContentWithAWS" = false;
      "amazonQ.workspaceIndex" = true;
      "amazonQ.workspaceIndexUseGPU" = true;
    };

    # Custom keybindings for VSCode
    keybindings = [
      {
        key = "ctrl+x ctrl+s";
        command = "workbench.action.files.save";
      }
    ];
  };
}
