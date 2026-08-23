{ pkgs, powerlevel10k, ... }:

let
  pythonTooling = pkgs.python3.withPackages (ps:
    with ps; [
      debugpy
      pytest
      ruff
    ]
  );
in
{
  home = {
    sessionVariables.EDITOR = "vim";
    sessionPath = [
      "$HOME/.local/share/gem/ruby/3.4.0/bin"
    ];

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
      darwin-personal-build = ''sudo env HOME=/var/root darwin-rebuild switch --flake "$(pwd)#personal"'';
      darwin-work-build = ''sudo env HOME=/var/root darwin-rebuild switch --flake "$(pwd)#work"'';
      darwin-clean = "nix-collect-garbage -d";
      nixos-clean = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
      flake-update = "nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes";
      trmnlp-install = "gem install --user-install trmnl_preview";
      snip = "pet exec";
      eza = "eza -l --git --header --icons=always --git-repos";
    };

    initContent = ''
      source ~/powerlevel10k/powerlevel10k.zsh-theme

      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
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
