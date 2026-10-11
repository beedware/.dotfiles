# System Notes

Generic Linux system notes that are useful after the base desktop is installed.

## GRUB OS Prober

If GRUB needs to detect other installed operating systems, enable OS probing and
regenerate the boot menu.

Make sure `/etc/default/grub` contains:

```conf
GRUB_DISABLE_OS_PROBER=false
```

Then run:

```bash
sudo os-prober
sudo update-grub
```

## Wi-Fi DNS Fallback

For temporary DNS troubleshooting, add public resolvers to `/etc/resolv.conf`:

```conf
nameserver 1.1.1.1
nameserver 8.8.8.8
```

Network managers may overwrite this file, so treat it as a quick diagnostic or
fallback rather than permanent configuration.

## Sudo Password Feedback

To show visual feedback while typing a `sudo` password, edit sudoers safely:

```bash
sudo visudo
```

For all users, add:

```sudoers
Defaults pwfeedback
```

For one user, add:

```sudoers
Defaults:<USER> pwfeedback
```

## Vial Udev Rule

Vial-compatible keyboards need a udev rule so the current user can access the
device without running Vial as root.

Use the current rule from the Vial Linux manual:

```bash
export USER_GID="$(id -g)"
sudo --preserve-env=USER_GID sh -c 'echo "KERNEL==\"hidraw*\", SUBSYSTEM==\"hidraw\", ATTRS{serial}==\"*vial:f64c2b3c*\", MODE=\"0660\", GROUP=\"$USER_GID\", TAG+=\"uaccess\", TAG+=\"udev-acl\"" > /etc/udev/rules.d/59-vial.rules && udevadm control --reload && udevadm trigger'
```

Reference: <https://get.vial.today/manual/linux-udev.html>

## Brightness At Startup

To set display brightness during boot, add a brightness command to
`/etc/rc.local`:

```bash
sudo -E nvim /etc/rc.local
```

Example command:

```bash
brightnessctl set 100%
```

## i3 Scratchpad Terminal

This optional i3 recipe creates a dedicated scratchpad terminal. The terminal
starts with a unique window class, i3 moves it to the scratchpad automatically,
and a binding toggles it when needed.

Example using Alacritty:

```i3
exec --no-startup-id alacritty --class scratchterm,scratchterm

for_window [class="scratchterm"] floating enable
for_window [class="scratchterm"] move scratchpad

bindsym $mod+minus [class="scratchterm"] scratchpad show, move position center
```

Use a binding that does not conflict with the main i3 config.

## tmux Copy To X11 Clipboard

For X11 sessions, copy tmux selections to the system clipboard with `xclip`:

```tmux
set -g mouse on
set -g set-clipboard off

bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
bind-key -T copy-mode y send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"

bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
bind-key -T copy-mode Enter send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"

bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
bind-key -T copy-mode MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "xclip -in -selection clipboard"
```

If existing copy-mode bindings already exist, replace them instead of adding
duplicates.
