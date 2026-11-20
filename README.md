# Dotfiles

Personal Void Linux dotfiles managed with GNU Stow.

## Quick Start

Install the minimum tools, clone the repo, and apply the dotfiles:

```bash
sudo xbps-install -Sy git stow python3
mv ~/.bashrc ~/.bashrc.bak
git clone https://github.com/beedware/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
sudo cp ~/.dotfiles/.bashrc.root /root/.bashrc
~/.dotfiles/.local/bin/themer init
```

The repo includes `.stowrc`, so `stow .` uses `--no-folding`. Stow creates real
directories like `~/.config/nvim` and `~/.local/bin`, then symlinks only the
files inside them.

`.bashrc.root` is the shell config intended for the root user. See
[System Notes](https://github.com/beedware/.dotfiles/wiki/system) for the install note.

## Fresh Install

Use [Fresh Install](https://github.com/beedware/.dotfiles/wiki/fresh-install) for a full Void install
flow, including desktop setup, graphics drivers, SSH setup, and application
scripts.

## Docs

Documentation is maintained in the [wiki](https://github.com/beedware/.dotfiles/wiki).

- [Partitioning](https://github.com/beedware/.dotfiles/wiki/partitioning): disk layout and formatting
- [Fresh Install](https://github.com/beedware/.dotfiles/wiki/fresh-install): end-to-end install flow
- [Scripts](https://github.com/beedware/.dotfiles/wiki/scripts): `add/` script dependency reference
- [System Notes](https://github.com/beedware/.dotfiles/wiki/system): generic system setup notes
- [Troubleshooting](https://github.com/beedware/.dotfiles/wiki/troubleshooting): common desktop fixes
- [Laptop Notes](https://github.com/beedware/.dotfiles/wiki/laptop): laptop-specific notes
- [System Update Checklist](https://github.com/beedware/.dotfiles/wiki/update): system update checklist
