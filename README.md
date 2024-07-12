[![nix-darwin](https://img.shields.io/badge/nix-darwin-blue.svg?logo=nixos)](https://github.com/LnL7/nix-darwin)
[![macOS](https://img.shields.io/badge/-macOS-green.svg?logo=apple)](https://www.apple.com/macos/)
[![nixos](https://img.shields.io/badge/nixos-grey.svg?logo=nixos)](https://nixos.org/)

# Multi-System Configuration with Nix

This repository provides a unified configuration setup for both NixOS and macOS (via nix-darwin), catering to both personal and work environments. It leverages the power of Nix and flakes for a declarative and reproducible system configuration.

<img width="1800" alt="image" src="https://github.com/lukejcollins/nix-darwin-build/assets/44213313/363d0b4e-c929-4d36-b237-d80f96ea488a">
<p align="center"><em>An indication of the appearance of the nix-darwin build once properly deployed</em></p>

## What are NixOS and nix-darwin?

- **NixOS**: A Linux distribution built on top of the Nix package manager, designed for declarative configuration and reliable system upgrades.
- **nix-darwin**: A tool for managing macOS configuration using the Nix package manager, similar to how NixOS configurations are managed.

## How the Configuration Works

The configuration is hierarchical, with root-level configuration files (`configuration.nix` & `home.nix`) that set up general settings and package installations that are OS agnostic. Each system type (NixOS and macOS) then has its own directory with specific configurations for personal and work environments.

### Root Configuration

The root `configuration.nix` and `home.nix` files include settings and packages common to all systems. This is where you define the core configuration, such as allowed packages, basic system settings, and shared services.

### NixOS Configuration

Under the `nixos` directory, there are subdirectories for personal and work configurations. Each of these contains `configuration.nix` and `home.nix` files that include device-specific settings and services, such as the bootloader configuration, hostname, and additional packages. The root of the `nixos` directory contains the device agnostic configuration for NixOS. 

### macOS Configuration

Similarly, under the `darwin` directory, there are subdirectories for personal and work configurations. Each of these contains `configuration.nix` and `home.nix` files tailored for macOS, managing services like yabai (tiling window manager) and other macOS-specific settings. The root of the `darwin` directory contains the device agnostic configuration for macOS. 

## Prerequisites

Before you begin, ensure you have the following:

1. For macOS:
   - A macOS device.
   - nix-darwin installed on macOS.

2. For NixOS:
   - A running NixOS installation.

## Step 1: Clone the Repository

Clone this repository to your device:

```bash
git clone https://github.com/lukejcollins/nix-darwin-build
```

## Step 2: Update Username

Update the username references in your configuration files to match your device.

### `flake.nix`

Update the device-specific details:

```nix
  modules = [
    # ...
    {
      users.users."your.username".home = "/Users/your.username";
    }
    # ...
  ];
```

Replace `"your.username"` with your username. Ensure all paths and configurations specific to your device are updated accordingly.

## Step 3: Deploy Your Configuration

Deploy the configuration to your device. Follow the instructions from the [nix-darwin repository](https://github.com/LnL7/nix-darwin) or NixOS manual for detailed steps. I have also included some aliases in .zshrc to make this as easy as possible, referenced below.

## Step 4: Additional Configuration and Advice (Optional)

The NixOS configuration is mostly ready to go out of the box. The nix-darwin configuration, due to the nature of the platform, will require a little more massaging to get going. Here's a starter for ten:

- **Raycast**: Use Raycast to replace macOS Spotlight for better integration with nix-darwin applications. Raycast is included in the default configuration. Follow [these instructions](https://manual.raycast.com/hotkey) to set it up.
- **Menu Bar**: Set the macOS menu bar to hide automatically to avoid interference with Simple Bar. Follow [this guide](https://www.howtogeek.com/700398/how-to-automatically-hide-or-show-the-menu-bar-on-a-mac/).
- **Yabai**: Configure Yabai (tiling window manager) in `/nix-darwin-build/dotfiles/yabai/yabairc`. Ensure paths and settings are updated to match your system.

  ```nix
  # Enable Yabai
  yabai = {
    enable = true;
    package = pkgs.yabai;
    extraConfig = "/Users/your.username/.config/yabai/yabairc";
  };
  ```
  
- **General Configuration**: Review and update other configuration files in the repository to suit your preferences. Contributions and suggestions are welcome.

## Step 5: Enjoy Your Setup

Your configuration should now be applied. Enjoy the benefits of a declarative and reproducible system configuration!

## Maintenance Commands

Aliases for maintaining the flake across Darwin and NixOS are included in `.zshrc`:

### Build Aliases

```sh
# Darwin Personal Build
alias darwin-personal-build='darwin-rebuild switch --flake "$(pwd)#personal"'

# Darwin Work Build
alias darwin-work-build='darwin-rebuild switch --flake "$(pwd)#work"'

# NixOS Personal Build
alias nixos-personal-build='sudo nixos-rebuild switch --flake "$(pwd)#personal" && home-manager switch --flake "$(pwd)#personal" --extra-experimental-features nix-command --extra-experimental-features flakes'

# NixOS Work Build
alias nixos-work-build='sudo nixos-rebuild switch --flake "$(pwd)#work" && home-manager switch --flake "$(pwd)#work" --extra-experimental-features nix-command --extra-experimental-features flakes'
```

### Cleaning Aliases

```sh
# Darwin Clean
alias darwin-clean='nix-collect-garbage -d'

# NixOS Clean
alias nixos-clean='sudo nix-env --delete-generations old -p /nix/var/nix/profiles/system && sudo nix-collect-garbage -d && flake-build'
```

### Flake Update

```sh
# Flake Update
alias flake-update='sudo nix flake update --extra-experimental-features nix-command --extra-experimental-features flakes'
```

For more information and advanced usage, refer to the [official NixOS documentation](https://nixos.org/) and [nix-darwin documentation](https://github.com/LnL7/nix-darwin).
