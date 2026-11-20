# Fresh Install

These steps assume the base Void live image, the one that boots to a TTY.

For partitioning and disk setup, see [`partitioning.md`](./partitioning.md).

## Install Void

From the live image, log in as `root` and start the installer:

```bash
void-installer
```

Use the partitioning doc as the disk layout reference. After the install
finishes, reboot into the installed system.

## Update The Base System

Log in to the installed system and update XBPS first:

```bash
sudo xbps-install -Syu xbps
sudo xbps-install -Syu
```

## Install The Desktop

Install XFCE, Xorg, LightDM, PipeWire, Bluetooth, and NetworkManager:

```bash
add/xfce4
```

This script reboots when it finishes.

## Install Graphics Drivers

After rebooting, choose the script for the machine.

For NVIDIA systems:

```bash
cd ~/.dotfiles
add/nvidia
```

For AMD systems:

```bash
cd ~/.dotfiles
add/amd
```

These scripts reboot when they finish. Do not run both unless the machine
intentionally needs both driver stacks.

## Set Up GitHub And Codeberg

After rebooting, set up GitHub and Codeberg SSH:

```bash
cd ~/.dotfiles
add/github
add/codeberg
```

The script copies the new public key to the clipboard and waits while you add
it to GitHub and Codeberg.

## Install Script Dependencies

Install the package managers and language tools required by later `add/`
scripts:

```bash
add/node
add/python
add/haskell
add/rust
add/flathub
```

`add/flathub` reboots when it finishes. After `add/rust`, open a new shell or
make sure `~/.cargo/bin` is on `PATH` before running scripts that require
`cargo`.

## Install Applications

Install the terminal and graphical applications after the dependency providers
above:

```bash
add/cli
add/gui
add/i3wm
```

This installs the general tools needed for common CLI workflows, development
and productivity. This does not install gaming related packages. To install
those, first make sure `add/flathub` has been run, then do:

```bash
add/gaming
```

See [`scripts.md`](./scripts.md) for the script dependency tree and standalone
components.
