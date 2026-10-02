For partitioning and disk setup during a fresh install, see
[`INSTALL.md`](./INSTALL.md).

These steps assume the base Void live image, the one that boots to a TTY.

## Fresh Install Flow

### Install Void

From the live image, log in as `root` and start the installer:

```bash
void-installer
```

Use `INSTALL.md` as the partitioning reference.

After the install finishes, reboot into the installed system.

### Update The Base System

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

### Install The Desktop

Install XFCE, Xorg, LightDM, PipeWire, Bluetooth, and NetworkManager:

```bash
add/xfce4
```

This script reboots when it finishes.

### Install Graphics Drivers

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

### Apply Dotfiles

After GitHub and Codeberg is set up and the repo origin has been switched to
SSH:

```bash
cd ~/.dotfiles
stow .
```

### Install Script Dependencies

Install the package managers and language tools required by later `add/`
scripts:

```bash
add/node
add/rust
add/python
add/flathub
```

`add/flathub` reboots when it finishes. After `add/rust`, open a new shell or
make sure `~/.cargo/bin` is on `PATH` before running scripts that require
`cargo`.

Dependency tree for the bundled scripts:

```text
add/cli
|-- requires: npm from add/node
|-- add/pde
|   |-- add/shell
|   |-- add/nvim
|   |   `-- add/rust
|   |-- add/node
|   |-- add/haskell
|   `-- add/codeberg
|-- add/mpd
|-- add/void-packages
|   `-- needs GitHub SSH for git@github.com clone
|-- add/power
`-- add/ai
    `-- requires: npm from add/node

add/gui
|-- requires: flatpak/flathub from add/flathub
|-- add/firefox
|-- add/espanso
|   `-- requires: cargo from add/rust
|-- add/emacs
|   |-- requires: cargo from add/rust
|   |-- requires: pipx from add/python
|   |-- add/tex
|   |   `-- requires: cargo from add/rust
|   `-- add/typst
|       `-- requires: cargo from add/rust
`-- add/printers

add/gaming
|-- requires: flatpak/flathub from add/flathub
|-- add/heroic
`-- add/faugus

add/pcvr
|-- requires: flatpak/flathub from add/flathub
`-- add/wayvr
```

### Install Applications

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

### Install Standalone Components

Each script owns most dependencies for the matching config or tool, but scripts
that use another package manager must be run after that package manager is
installed. Run only what the machine needs. They are found in `add`.

`add/i3wm` assumes `add/xfce4` has already been run. It only installs the
i3-specific pieces on top of the XFCE/Xorg/PipeWire base.

Scripts that can be run independently after the base setup include `add/docker`,
`add/qemu-kvm`, `add/dotnet`, `add/flutter`, `add/java`, `add/godot`,
`add/postgresql`, `add/prolog`, `add/nix`, `add/zed`, `add/helium`, `add/vial`,
`add/mpd`, `add/power`, and `add/printers`.

## Optional Scripts

Run this on a QEMU/KVM host or guest:

```bash
add/qemu-kvm
```

Run this on laptops where TLP power management is wanted:

```bash
add/power
```

## Laptop Lid Suspend

For laptop suspend behavior, disable the `acpid` service and let
`xfce4-power-manager` handle lid close:

```bash
sudo rm /var/service/acpid
```

Then make sure `/etc/elogind/logind.conf` contains:

```ini
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
HandleLidSwitchDocked=ignore
```
