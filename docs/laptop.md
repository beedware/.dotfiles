# Laptop Notes

## Lid Suspend

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

## TLP Power Profiles

Useful manual TLP power profile commands:

```bash
sudo tlp power-saver
sudo tlp balanced
sudo tlp performance
```

## X11 Touchpad

For a generic X11/libinput touchpad configuration, create:

```text
/etc/X11/xorg.conf.d/30-touchpad.conf
```

Example:

```conf
Section "InputClass"
    Identifier "touchpad"
    MatchIsTouchpad "on"
    Driver "libinput"
    Option "Tapping" "on"
    Option "ClickMethod" "clickfinger"
    Option "ScrollMethod" "twofinger"
    Option "NaturalScrolling" "true"
EndSection
```
