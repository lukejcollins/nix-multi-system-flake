{ lib, pkgs, powerlevel10k, ... }:

let
  pythonTooling = pkgs.python3.withPackages (ps:
    with ps; [
      pynvim
      python-lsp-server
      python-lsp-black
      pyls-isort
      pylsp-mypy
      black
      flake8
      pylint
      isort
      mypy
      pip
    ]
  );
in
{
  home = {
    sessionVariables.EDITOR = "vim";

    packages = [
      pythonTooling
    ];

    file = {
      ".p10k.zsh".source = ./config/.p10k.zsh;
      "/powerlevel10k".source = powerlevel10k;
    };

    stateVersion = "23.11";
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      nixos-personal-build = ''sudo nixos-rebuild switch --flake "$(pwd)#personal" && home-manager switch --flake "$(pwd)#personal" --extra-experimental-features nix-command --extra-experimental-features flakes'';
      darwin-clean = "nix-collect-garbage -d";
      nixos-clean = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
      flake-update = "nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes";
      snip = "pet exec";
      eza = "eza -l --git --header --icons=always --git-repos";
    };

    initContent = lib.mkMerge [
      (lib.mkOrder 550 ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '')

      ''
        source ~/powerlevel10k/powerlevel10k.zsh-theme

        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        unalias darwin-personal-build 2>/dev/null || true
        unalias darwin-work-build 2>/dev/null || true

        darwin-personal-build() {
          sudo env HOME=/var/root darwin-rebuild switch --flake "$(pwd)#personal"
        }

        darwin-work-build() {
          sudo env HOME=/var/root darwin-rebuild switch --flake "$(pwd)#work"
        }

        export PATH="$PATH:/usr/local/share/dotnet"
        export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH
      ''
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  xdg.configFile = {
    "direnv/direnvrc".text = ''
      use_nix
    '';

    "zellij/config.kdl".text = ''
      theme "catppuccin-mocha"
    '';
  };
}
