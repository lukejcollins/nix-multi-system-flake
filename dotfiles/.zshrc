# =====================
# Initial Configuration
# =====================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =================
# Theme Configuration
# =================

# Set name of the theme to load.
ZSH_THEME="powerlevel10k/powerlevel10k"
source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# flake build alias
alias darwin-personal-build='darwin-rebuild switch --flake "$(pwd)#personal"'
alias darwin-work-build='darwin-rebuild switch --flake "$(pwd)#work"'
alias nixos-personal-build='sudo nixos-rebuild switch --flake "$(pwd)#personal" && home-manager switch --flake "$(pwd)#personal" --extra-experimental-features nix-command --extra-experimental-features flakes'
alias nixos-work-build='sudo nixos-rebuild switch --flake "$(pwd)#work" && home-manager switch --flake "$(pwd)#work" --extra-experimental-features nix-command --extra-experimental-features flakes'

# nix clean alias
alias darwin-clean='nix-collect-garbage -d'
alias nixos-clean='sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d && flake-build'

# Flake update
alias flake-update='sudo nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes'

# direnv hook
eval "$(direnv hook zsh)"

# pet alias
alias snip='pet exec'

# eza alias
alias eza="eza -l --git --header --icons=always --git-repos"
