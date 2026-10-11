# System Update Checklist

## Core System

- [ ] Update xbps packages: `sudo xbps-install -Syu`
- [ ] Remove obsolete xbps packages: `sudo xbps-remove -Oo`
- [ ] Update Flatpak apps/remotes: `flatpak update`
- [ ] Remove unused Flatpak runtimes: `flatpak uninstall --unused`
- [ ] Repair Flatpak state if needed: `flatpak repair`

## Calendars

- [ ] Update org calendars: `~/Compendium/Journal/.scripts/calendars kcl`
- [ ] Update Hijri org calendar: `~/Compendium/Journal/.scripts/calendars hijri -g "$(date +%Y/%m/%d)" "$(date -d "$(date +%Y-%m-01) +2 months -1 day" +%Y/%m/%d)"`

## Editors

- [ ] Update Neovim plugins/packages from inside Neovim with the configured plugin manager.
- [ ] Update Emacs packages from inside Emacs with the configured package manager.
- [ ] Verify Firefox profile `user.js` symlinks and browser extensions/settings after profile changes.

## Language Tooling

- [ ] Update Rust toolchains: `rustup update`
- [ ] Update cargo-installed tools if `cargo-update` is installed: `cargo install-update -a`
- [ ] Update `tex-fmt`: `cargo install tex-fmt --locked --force`
- [ ] Update `prettypst`: `cargo install --git=https://github.com/antonWetzel/prettypst.git --locked --force`
- [ ] Update Volta-managed Node: `volta install node@latest`
- [ ] Check Volta tools: `volta list`
- [ ] Update global `opencode-ai`: `npm update -g opencode-ai` or `npm i -g opencode-ai --allow-scripts=opencode-ai`
- [ ] Update external Python tools: `pipx list`, `pipx upgrade-all`, `uv tool list`, `uv tool upgrade --all`
- [ ] Update Haskell tooling: `ghcup upgrade`, `ghcup tui`, `ghcup install ghc --set recommended`, `ghcup install cabal latest`, `ghcup install stack latest`, `cabal update`
- [ ] Update SDKMAN if installed: `sdk selfupdate`, `sdk update`, `sdk upgrade`
- [ ] Update Flutter after changing the pinned SDK or as needed: `flutter upgrade`, `flutter precache`, `flutter doctor`

## Pinned Downloads

For each item, check the upstream release, edit the pinned values in the listed `add/` script, then run the install command.

| Done | App         | Script        | Update                       | Source                                      | Install                                           |
| ---- | ----------- | ------------- | ---------------------------- | ------------------------------------------- | ------------------------------------------------- |
| [ ]  | Zed         | `add/zed`     | `VERSION`, arch SHA256s      | `zed-industries/zed`                        | `sh ~/.dotfiles/add/zed`                          |
| [ ]  | Vial        | `add/vial`    | `VERSION`, SHA256            | `vial-kb/vial-gui`                          | `sh ~/.dotfiles/add/vial`                         |
| [ ]  | Helium      | `add/helium`  | `VERSION`, SHA256            | `imputnet/helium-linux`                     | `sh ~/.dotfiles/add/helium`                       |
| [ ]  | WayVR       | `add/wayvr`   | `VERSION`, SHA256            | `wayvr-org/wayvr`                           | `sh ~/.dotfiles/add/wayvr`                        |
| [ ]  | Faugus      | `add/faugus`  | `VERSION`, `RELEASE`, SHA256 | `Faugus/faugus-launcher`                    | `sh ~/.dotfiles/add/faugus`                       |
| [ ]  | Heroic      | `add/heroic`  | `VERSION`, SHA256            | `Heroic-Games-Launcher/HeroicGamesLauncher` | `sh ~/.dotfiles/add/heroic`                       |
| [ ]  | .NET SDK    | `add/dotnet`  | `VERSION`, SHA512            | Microsoft builds                            | `sh ~/.dotfiles/add/dotnet`                       |
| [ ]  | Flutter SDK | `add/flutter` | `VERSION`, SHA256            | Google storage                              | `sh ~/.dotfiles/add/flutter`                      |
| [ ]  | GHCup       | `add/haskell` | `VERSION`, SHA256            | GHCup releases                              | `sh ~/.dotfiles/add/haskell`                      |
| [ ]  | SDKMAN      | `add/java`    | installer checksum           | `https://get.sdkman.io`                     | rerun Java setup if needed                        |

## Source Trees And Auth

- [ ] Update Void packages clones at `~/Projects/beedware/void-packages` and `~/Projects/void-linux/void-packages`: `git fetch --all --prune`, merge or rebase upstream, then run `./xbps-src bootstrap-update`.
- [ ] Verify GitHub auth and remotes: `ssh -T git@github.com`, `gh auth status`, `git lfs pull`
- [ ] Verify Codeberg auth and remotes: `ssh -T git@codeberg.org`, `git remote -v`

## Final Checks

- [ ] Refresh font cache after font changes: `fc-cache -rv`
- [ ] Verify relevant runit services after upgrades: `sudo sv status nix-daemon`, `sudo sv status libvirtd`, `sudo sv status virtlogd`, `sudo sv status virtlockd`, `sudo sv status spice-vdagentd`, `sudo sv status docker`, `sudo sv status avahi-daemon`, `sudo sv status postgresql`, `sudo sv status cupsd`, `sudo sv status cups-browsed`, `sudo sv status tlp`, `sudo sv status dbus`, `sudo sv status elogind`, `sudo sv status lightdm`, `sudo sv status polkitd`, `sudo sv status cronie`, `sudo sv status NetworkManager`, `sudo sv status bluetoothd`
- [ ] Restart any relevant changed runit services with `sudo sv restart SERVICE`.
