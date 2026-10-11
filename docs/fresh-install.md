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

Install the minimal tools needed to fetch and apply this repo:

```bash
sudo xbps-install -S git neovim curl stow
```

Clone the repo:

```bash
git clone https://github.com/beedware/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

Before running any `add/` script, update the system yourself:

```bash
sudo xbps-install -Syu
```

The `add/` scripts install their own packages, but they do not run a full
system update.

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

## Apply Dotfiles

After GitHub and Codeberg is set up and the repo origin has been switched to
SSH:

```bash
cd ~/.dotfiles
stow .
```

The repo includes `.stowrc`, so `stow .` runs with `--no-folding`. This keeps
directories like `~/.config/nvim` and `~/.local/bin` as real directories and
only symlinks the files inside them.

On a fresh system, Stow may stop if a target file already exists. The common
one is `~/.bashrc`, which Void creates by default. If that happens, move the
existing file out of the way and rerun Stow:

```bash
mv ~/.bashrc ~/.bashrc.bak
stow .
```

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
