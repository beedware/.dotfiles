# Scripts

The `add/` scripts install packages and configure related tools. Run only what
the machine needs.

## Dependency Tree

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

## Standalone Components

Each script owns most dependencies for the matching config or tool, but scripts
that use another package manager must be run after that package manager is
installed.

`add/i3wm` assumes `add/xfce4` has already been run. It only installs the
i3-specific pieces on top of the XFCE/Xorg/PipeWire base.

Scripts that can be run independently after the base setup include:

```text
add/docker
add/qemu-kvm
add/dotnet
add/flutter
add/java
add/godot
add/postgresql
add/prolog
add/nix
add/zed
add/helium
add/vial
add/mpd
add/power
add/printers
```

## Optional Scripts

Run this on a QEMU/KVM host or guest:

```bash
add/qemu-kvm
```

Run this on laptops where TLP power management is wanted:

```bash
add/power
```
