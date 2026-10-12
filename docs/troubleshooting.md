# Troubleshooting

Generic fixes for issues that can appear on Void Linux desktop installs.

## Thunar Media Handling Under i3

Some desktop components expect a DBus session. If Thunar volume or media
handling does not work when launching i3 from LightDM, create an i3 desktop
entry that starts i3 under `dbus-run-session`.

Place it with the other X sessions, usually under `/usr/share/xsessions/`:

```desktop
[Desktop Entry]
Name=i3
Comment=improved dynamic tiling window manager
Exec=dbus-run-session -- i3
TryExec=i3
Type=XSession
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
```

## elogind Is Already Running

Void Linux can report that `elogind` is already running if the service is linked
incorrectly or started elsewhere.

If `/var/service/elogind` is the problem, unlink it and let the active session
manager own the process:

```bash
sudo unlink /var/service/elogind
```

If `unlink` reports that the path is not a symlink, inspect it before removing
anything.

## Default Application MIME Error

If setting a default application fails with an error like:

```text
Failed to set default application for "<file>".
Failed to create file "../.dotfiles/.config/mimeapps.list.XXXXXX": No such file or directory.
```

The live file may be a relative symlink from `~/.config/mimeapps.list` into the
dotfiles repo. Some GUI tools fail when creating a temporary file beside that
relative symlink target.

Ensure the dotfiles config directory exists, then replace the symlink with an
absolute one:

```bash
mkdir -p /home/beed/.dotfiles/.config
ln -sfn /home/beed/.dotfiles/.config/mimeapps.list /home/beed/.config/mimeapps.list
```

Verify temp-file creation works next to the target:

```bash
tmp=$(mktemp /home/beed/.dotfiles/.config/mimeapps.list.XXXXXX) && rm "$tmp"
```

## SPICE Agent In Virtual Machines

For Void guests in virt-manager, install and enable the SPICE agent so clipboard,
display resizing, and desktop integration work properly:

```bash
sudo xbps-install -S spice-vdagent
sudo ln -s /etc/sv/spice-vdagentd /var/service/
sudo reboot
```
