# Dotfiles

Personal Void Linux dotfiles managed with GNU Stow.

## Quick Start

Install the minimum tools, clone the repo, and apply the dotfiles:

```bash
sudo xbps-install -S git stow
git clone https://github.com/beedware/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
stow .
```

The repo includes `.stowrc`, so `stow .` uses `--no-folding`. Stow creates real
directories like `~/.config/nvim` and `~/.local/bin`, then symlinks only the
files inside them.

If Stow reports an existing target, move or merge that file first. The common
fresh-install conflict is Void's default `~/.bashrc`:

```bash
mv ~/.bashrc ~/.bashrc.bak
stow .
```

## Fresh Install

Use [`docs/fresh-install.md`](./docs/fresh-install.md) for a full Void install
flow, including desktop setup, graphics drivers, SSH setup, and application
scripts.

## Docs

- [`docs/partitioning.md`](./docs/partitioning.md): disk layout and formatting
- [`docs/fresh-install.md`](./docs/fresh-install.md): end-to-end install flow
- [`docs/scripts.md`](./docs/scripts.md): `add/` script dependency reference
- [`docs/laptop.md`](./docs/laptop.md): laptop-specific notes
