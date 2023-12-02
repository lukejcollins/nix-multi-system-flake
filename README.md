[![nix-darwin](https://img.shields.io/badge/NixOS-unstable-blue.svg?logo=nixos)](https://github.com/LnL7/nix-darwin) [![macOS](https://img.shields.io/badge/-macOS-green.svg?logo=apple)](https://www.apple.com/macos/) 

# Deploying nix-darwin on a New Device

This guide will walk you through deploying your nix-darwin configuration on a new device. nix-darwin is a tool for managing your macOS configuration with nix.

## Prerequisites

Before you begin, make sure you have the following prerequisites:

1. A new macOS device.
2. Nix for macOS installed.

## Step 1: Clone Your nix-darwin Repository

Clone your nix-darwin repository to your new device. You can use a command like this:

```bash
git clone https://github.com/lukejcollins/nix-darwin-build ~/git
```

## Step 2: Update Hostname and Username

Your nix-darwin configuration will contain references to hostnames and usernames specific to your device. You'll need to update the files to match your device. Here's where you should make the changes:

### `flake.nix`

In your `flake.nix`, look for the following lines:

```nix
darwinConfigurations."OVO-VHG17X6V24" = nix-darwin.lib.darwinSystem {
  # ...
  modules = [
    # ...
    {
      users.users."luke.collins".home = "/Users/luke.collins";
    }
    # ...
  ];
};
```

Replace `"OVO-VHG17X6V24"` with your your device's hostname, and `"luke.collins"` with your username.

### `home.nix`

In your `home.nix`, you might need to update references to the device's configuration. Look for lines like this:

```nix
{
  home = {
    # ...
    file".config/yabai/yabairc".source = ./dotfiles/yabai/yabairc;
  };
  # ...
}
```

Ensure that any paths or configurations specific to your previous device are updated to match the paths on your new device.

## Step 3: Deploy Your Configuration

Once you've updated your configuration files, you can deploy your nix-darwin configuration on the new device. Familiarise yourself on how to do this as per the [nix-darwin repo instructions](https://github.com/lukejcollins/nix-darwin-build).

## Step 4: Enjoy Your nix-darwin Setup

Your nix-darwin configuration should now be applied to your new device. Enjoy the benefits of a declarative and reproducible macOS configuration!

For more information and advanced usage of nix-darwin, refer to the [official nix-darwin documentation](https://github.com/LnL7/nix-darwin).
