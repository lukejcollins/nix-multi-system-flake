{ pkgs, lib, ... }:

let
  # Python Environment Definition
  myPythonEnv = pkgs.python3.withPackages (ps: with ps; [
    pynvim flake8 pylint black requests grip ratelimit typing unidecode python-lsp-server
    isort pyls-isort pylsp-mypy mypy types-requests python-lsp-black django-stubs boto3-stubs
    pygame
  ]);

  # Powerlevel10k Installation Definition
  powerlevel10kSrc = builtins.fetchGit {
    url = "https://github.com/romkatv/powerlevel10k.git";
    rev = "017395a266aa15011c09e64e44a1c98ed91c478c";
  };

in
{
  home = {
    # Set the session variables
    sessionVariables = {
      # Set the default editor to vim
      EDITOR = "vim";
    };

    packages = [
      myPythonEnv
    ];

    # Set the file locations for the configuration files
    file = {
      ".config/alacritty/alacritty.toml".source = ./dotfiles/alacritty/alacritty.toml;
      ".zshrc".source = ./dotfiles/.zshrc;
      ".p10k.zsh".source = ./dotfiles/.p10k.zsh;
      ".config/direnv/direnvrc".source = ./dotfiles/direnv/direnvrc;
      ".config/zellij/config.kdl".source = ./dotfiles/zellij/config.kdl;
      "/powerlevel10k".source = powerlevel10kSrc;
    };

    # Set the default stateVersion to the latest version
    stateVersion = "23.11";
  };

  programs.vscode = {
    enable = true;

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
    ];

    mutableExtensionsDir = true;

    userSettings = {
      "editor.tabSize" = 4;
      "editor.formatOnSave" = true;

      "[rust]" = {
        "editor.formatOnSave" = true;
      };
      "[nix]" = {
        "editor.formatOnSave" = true;
      };
      "[sh]" = {
        "editor.formatOnSave" = true;
      };
      "[dockerfile]" = {
        "editor.formatOnSave" = true;
      };
      "[terraform]" = {
        "editor.formatOnSave" = true;
      };
      "[yaml]" = {
        "editor.formatOnSave" = true;
      };
      "[python]" = {
        "editor.formatOnSave" = true;
      };
      "flake8.args" = ["--max-line-length=88"];
      "amazonQ.telemetry" = false;
      "amazonQ.shareContentWithAWS" = false;
      "amazonQ.workspaceIndex" = true;
      "amazonQ.workspaceIndexUseGPU" = true;
    };

    keybindings = [
      {
        key = "ctrl+x ctrl+s";
        command = "workbench.action.files.save";
      }
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
  };
}
