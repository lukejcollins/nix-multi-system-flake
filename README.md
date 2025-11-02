[![nix-darwin](https://img.shields.io/badge/nix-darwin-blue.svg?logo=nixos)](https://github.com/LnL7/nix-darwin)
[![macOS](https://img.shields.io/badge/-macOS-green.svg?logo=apple)](https://www.apple.com/macos/)
[![nixos](https://img.shields.io/badge/nixos-grey.svg?logo=nixos)](https://nixos.org/)

# Personal NixOS Configuration Flake

This repository contains the declarative setup for my personal bare-metal NixOS machine. It previously managed multiple systems, but has been pared back to a single `personal` build while keeping the hierarchical structure so new targets can slot back in when needed.

## Repository Structure

- **flake.nix** – defines the `nixosConfigurations.personal` and `homeConfigurations.personal` outputs.
- **home.nix** – top-level Home Manager defaults that every system inherits.
- **baremetal/** – host-specific modules for physical machines.
  - `configuration.nix` / `home.nix` – shared bare-metal settings.
  - `nixos/` – NixOS modules layered on top of the bare-metal defaults.
    - `personal/` – the only enabled deployment target today.
- **dotfiles/** – supporting shell configuration (e.g. `.zshrc`, `.p10k.zsh`) and `direnv` snippets.

The layering makes it straightforward to add future targets—whether additional NixOS hosts, macOS via nix-darwin, or other environments—without reworking the flake layout.

## Using the Flake

Clone the repo and enter the directory:

```bash
git clone https://github.com/lukejcollins/nix-multi-system-flake
cd nix-multi-system-flake
```

To reproduce the personal system you will need to adapt any hard-coded user details (e.g. `lukecollins`, `/home/lukecollins`) across the modules to match your environment.

When the configuration is ready, apply it with:

```bash
sudo nixos-rebuild switch --flake .#personal
home-manager switch --flake .#personal \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

The Home Manager invocation is separated so it can be rerun independently during iteration.

## Maintenance Tips

- `nix-collect-garbage -d` cleans old generations and store paths.
- `sudo nix flake update` refreshes all inputs to their latest revisions.
- `sudo nixos-rebuild switch --flake .#personal` reapplies the system after changes.

Shell helpers for these commands live in `dotfiles/.zshrc`: the `nixos-personal-build` alias runs both rebuild steps, while `nixos-clean` and `flake-update` wrap the cleanup and update workflows.

Refer to the [NixOS manual](https://nixos.org/manual/nixos/stable/) and [Home Manager documentation](https://nix-community.github.io/home-manager/) for deeper guidance.
