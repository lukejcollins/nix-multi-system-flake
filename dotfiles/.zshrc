if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias nixos-personal-build='sudo nixos-rebuild switch --flake "$(pwd)#personal" && home-manager switch --flake "$(pwd)#personal" --extra-experimental-features nix-command --extra-experimental-features flakes'
alias nixos-clean='sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d'
alias flake-update='nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes'
alias snip='pet exec'
alias eza="eza -l --git --header --icons=always --git-repos"

export PATH="$PATH:/usr/local/share/dotnet"
export PATH=$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH

eval "$(direnv hook zsh)"
