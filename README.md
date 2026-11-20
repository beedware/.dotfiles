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
~/.dotfiles/.local/bin/themer init
```

The repo includes `.stowrc`, so `stow .` uses `--no-folding`. Stow creates real
directories like `~/.config/nvim` and `~/.local/bin`, then symlinks only the
files inside them.
