{ config, powerlevel10k, ... }:

{
  home = {
    sessionVariables = {
      EDITOR = "vim";
      GEM_HOME = "$HOME/.local/share/gem";
      NIX_CONFIG_FLAKE = "${config.home.homeDirectory}/git/nix-multi-system-flake";
    };
    sessionPath = [
      "$GEM_HOME/bin"
    ];

    file = {
      ".p10k.zsh".source = ./config/.p10k.zsh;
    };

    stateVersion = "23.11";
  };

  programs.zsh = {
    enable = true;

    shellAliases = {
      nixos-personal-build = ''sudo nixos-rebuild switch --flake "$NIX_CONFIG_FLAKE#personal"'';
      darwin-personal-build = ''sudo env HOME=/var/root darwin-rebuild switch --flake "$NIX_CONFIG_FLAKE#personal"'';
      darwin-work-build = ''sudo env HOME=/var/root darwin-rebuild switch --flake "$NIX_CONFIG_FLAKE#work"'';
      darwin-clean = "nix-collect-garbage -d";
      nixos-clean = "sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d";
      flake-update = ''nix flake update --flake "$NIX_CONFIG_FLAKE"'';
      trmnlp-install = "gem install trmnl_preview";
      snip = "pet exec";
      eza = "eza -l --git --header --icons=always --git-repos";
    };

    plugins = [{
      name = "powerlevel10k";
      src = powerlevel10k;
      file = "powerlevel10k.zsh-theme";
    }];

    initContent = ''[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh'';
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
