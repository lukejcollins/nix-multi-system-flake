[![nixos](https://img.shields.io/badge/nixos-grey.svg?logo=nixos)](https://nixos.org/)
[![nix-darwin](https://img.shields.io/badge/nix--darwin-grey.svg?logo=nixos)](https://github.com/nix-darwin/nix-darwin)
[![home-manager](https://img.shields.io/badge/home--manager-grey.svg?logo=nixos)](https://github.com/nix-community/home-manager)

# Multi-System Nix Configuration Flake

This repository contains my declarative setup for NixOS, macOS via nix-darwin, and shared Home Manager user configuration. The layout is hierarchical: common settings live near the root, platform-specific settings layer on top, and host/persona-specific settings only exist when there is real configuration to apply.

`flake.nix` uses an `optionalImport` helper, so empty placeholder files are not required.

## Outputs

- `nixosConfigurations.personal` - x86_64 NixOS desktop/gaming machine.
- `darwinConfigurations.personal` - personal Apple Silicon macOS machine.
- `darwinConfigurations.work` - work Apple Silicon macOS machine.
- `homeConfigurations.personal` - standalone Home Manager output for the Linux personal user profile.

## Layout

- `flake.nix` - inputs, outputs, hierarchy imports, and persona wiring.
- `baremetal/configuration.nix` - shared system-level settings across bare-metal machines.
- `baremetal/nixos/` - shared NixOS system module.
- `baremetal/nixos/personal/` - personal NixOS host and hardware configuration.
- `baremetal/darwin/` - shared nix-darwin system module.
- `baremetal/darwin/personal/` - personal macOS-specific module.
- `home.nix` - shared Home Manager defaults.
- `baremetal/home.nix` - shared user packages plus Alacritty and Emacs Home Manager configuration.
- `baremetal/config/` - imported user application configuration such as Alacritty and Emacs.
- `config/.p10k.zsh` - Powerlevel10k prompt config linked by Home Manager.

The `work` Darwin output currently exists, but has no work-specific module checked in. It inherits the shared Darwin and Home Manager layers.

## System Layers

Shared bare-metal system configuration owns settings that make sense on both Linux and macOS:

- Unfree package allowance.
- Shared fonts.
- System zsh enablement.
- Shared system packages.

The NixOS layers own Linux machine behavior:

- Bootloader, kernel, hostname, locale, timezone, users, and NetworkManager.
- PipeWire, printing, firmware updates, Docker, Firefox, and system packages.
- Personal desktop/gaming configuration: GNOME, GDM, NVIDIA, Vulkan, Steam, GameMode, Proton, Wine, and gaming launchers.

The Darwin layers own macOS machine behavior:

- Lix-compatible Nix settings, nix build group ID, and shared Darwin packages.
- macOS defaults, Rosetta activation, and the launchd-managed Emacs daemon.
- Personal macOS package additions.

Home Manager owns user-level tools and preferences on both platforms:

- CLI tools, language servers, development tools, and editor dependencies.
- Zsh aliases/functions, Powerlevel10k, direnv, zellij, Alacritty, and Emacs.
- Emacs package management through `programs.emacs.extraPackages`.

The config intentionally no longer manages VS Code, yabai, skhd, Simple Bar, or the old work wallpaper launchd agent.

## Powerlevel10k

Powerlevel10k itself is pinned as a flake input and linked to `~/powerlevel10k`. The prompt configuration remains a normal file at `config/.p10k.zsh` and is linked to `~/.p10k.zsh`.

## Applying

Clone the repo:

```bash
git clone https://github.com/lukejcollins/nix-multi-system-flake
cd nix-multi-system-flake
```

### NixOS

Apply the personal NixOS system and standalone Home Manager profile:

```bash
sudo nixos-rebuild switch --flake .#personal
home-manager switch --flake .#personal \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

After that, the `nixos-personal-build` helper from `home.nix` wraps both commands.

The NixOS output assumes:

- `x86_64-linux`
- user `lukecollins`
- host name `nixos`
- hardware config at `baremetal/nixos/personal/hardware-configuration.nix`

### macOS

Apply the personal macOS system:

```bash
darwin-personal-build
```

Apply the work macOS system:

```bash
darwin-work-build
```

Those Darwin functions are declared in `home.nix`, run `darwin-rebuild` with root activation, and apply the embedded Home Manager user config.

The macOS outputs assume Apple Silicon (`aarch64-darwin`) and set:

- `personal`: `lukecollins` at `/Users/lukecollins`
- `work`: `luke.collins` at `/Users/luke.collins`

The underlying commands are:

```bash
sudo env HOME=/var/root darwin-rebuild switch --flake "$(pwd)#personal"
sudo env HOME=/var/root darwin-rebuild switch --flake "$(pwd)#work"
```

### First-Time Darwin Bootstrap

On a fresh Lix/nix-darwin bootstrap, before the functions exist, use:

```bash
sudo env HOME=/var/root nix \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes \
  run github:nix-darwin/nix-darwin/nix-darwin-25.11#darwin-rebuild -- \
  switch --flake .#personal
```

If nix-darwin refuses to overwrite existing Lix-managed files in `/etc/nix`, first move the old files aside after checking their contents:

```bash
sudo mv /etc/nix/nix.conf /etc/nix/nix.conf.before-nix-darwin
sudo mv /etc/nix/nix.custom.conf /etc/nix/nix.custom.conf.before-nix-darwin
```

### Standalone Home Manager

The standalone Home Manager output is for the Linux personal profile:

```bash
home-manager switch --flake .#personal \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

## Maintenance

Useful shell commands are declared in `home.nix`:

- `nixos-personal-build`
- `darwin-personal-build`
- `darwin-work-build`
- `nixos-clean`
- `darwin-clean`
- `flake-update`

Manual checks:

```bash
nix flake check --no-build \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

Build the personal NixOS system without activating:

```bash
nix build .#nixosConfigurations.personal.config.system.build.toplevel --no-link \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

Build the personal Darwin system without activating:

```bash
nix build .#darwinConfigurations.personal.config.system.build.toplevel --no-link \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

Build the standalone Home Manager profile without activating:

```bash
nix build .#homeConfigurations.personal.activationPackage --no-link \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

Refresh inputs:

```bash
nix flake update \
  --extra-experimental-features nix-command \
  --extra-experimental-features flakes
```

## Emacs

The Emacs config lives at `baremetal/config/emacs.el`. Home Manager reads that file into `programs.emacs.extraConfig`, while packages are installed through `programs.emacs.extraPackages` in `baremetal/home.nix`.

Check startup loading:

```bash
emacs --batch --load baremetal/config/emacs.el
```

Check strict byte compilation:

```bash
emacs --batch \
  --eval '(setq byte-compile-error-on-warn t)' \
  -f batch-byte-compile baremetal/config/emacs.el
```

The byte-compile command creates `baremetal/config/emacs.elc`; remove it after checking unless you intentionally want to track compiled output.

After changing Emacs config and applying the system, restart the daemon:

```bash
emacsclient -e '(kill-emacs)'
```
