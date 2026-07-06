[![nixos](https://img.shields.io/badge/nixos-grey.svg?logo=nixos)](https://nixos.org/)
[![nix-darwin](https://img.shields.io/badge/nix--darwin-grey.svg?logo=nixos)](https://github.com/nix-darwin/nix-darwin)
[![home-manager](https://img.shields.io/badge/home--manager-grey.svg?logo=nixos)](https://github.com/nix-community/home-manager)

# Multi-System Nix Configuration Flake

This repository is a multi-system Nix flake for managing NixOS, macOS via nix-darwin, and shared Home Manager user configuration. It is set up as a personal workstation template rather than a generic framework, so usernames, host names, and machine profiles should be adapted before use.

The layout is hierarchical: common settings live near the root, platform-specific settings layer on top, and host/persona-specific settings only exist when there is real configuration to apply.

`flake.nix` uses an `optionalImport` helper, so empty placeholder files are not required.

## Outputs

- `nixosConfigurations.personal` - x86_64 NixOS desktop/gaming machine.
- `darwinConfigurations.personal` - personal Apple Silicon macOS machine.
- `darwinConfigurations.work` - work Apple Silicon macOS machine.
- `homeConfigurations.personal` - standalone Home Manager output for the Linux personal user profile.

The output names such as `personal` and `work` are just profile names. Rename or replace them in `flake.nix` if your machines use different names.

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

## Adapting This Repo

Before applying this flake on your own machine, update the identity and host-specific values in `flake.nix` and the relevant platform modules.

At minimum, review and change:

- `flake.nix`
  - `system = "x86_64-linux"` or `system = "aarch64-darwin"` for each output.
  - `system.primaryUser` for nix-darwin outputs.
  - `users.users."<name>".home` for nix-darwin home paths.
  - `home-manager.users."<name>"` for embedded Home Manager on Darwin.
  - `home.username` and `home.homeDirectory` for standalone Home Manager.
  - Output names such as `personal` and `work` if you want different flake targets.
- `baremetal/nixos/personal/configuration.nix`
  - NixOS host name.
  - Linux user account.
  - Desktop, GPU, gaming, and machine-specific services.
- `baremetal/nixos/personal/hardware-configuration.nix`
  - Replace this with the file generated on your own NixOS machine.
- `baremetal/darwin/personal/configuration.nix`
  - macOS-only packages and personal-machine settings.
- `baremetal/darwin/configuration.nix`
  - Shared macOS defaults, Nix/Lix settings, and nix-darwin system behavior.
- `home.nix` and `baremetal/home.nix`
  - User packages, shell helpers, editor config, prompt config, and shared CLI defaults.

Use your own account names and home directories everywhere a user is configured. For example, a Linux Home Manager profile usually sets `home.username` and `home.homeDirectory`, while a nix-darwin profile sets `system.primaryUser`, `users.users."<name>".home`, and `home-manager.users."<name>"`.

### Adding Your Own Profile

The simplest path is to copy an existing profile directory and rename the output:

1. Copy `baremetal/darwin/personal/` or `baremetal/nixos/personal/` to a new profile name.
2. Add or rename the matching output in `flake.nix`.
3. Update username, home directory, host name, and system architecture.
4. Apply with the matching flake target, for example `.#my-machine`.

Because `optionalImport` is used, you do not need to create empty `home.nix` or `configuration.nix` files for every layer. Add a file only when that layer has real settings.

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

Before applying the NixOS output, make sure it matches your machine:

- `x86_64-linux`
- Linux user account
- host name
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

Before applying a macOS output, make sure it matches your machine:

- Apple Silicon uses `aarch64-darwin`.
- Intel Macs use `x86_64-darwin`.
- Each Darwin output needs the right `system.primaryUser`, user home directory, and matching Home Manager user.

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
  run github:nix-darwin/nix-darwin/master#darwin-rebuild -- \
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
