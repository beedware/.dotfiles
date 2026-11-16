#!/bin/sh

xrandr --output eDP --primary --mode 1920x1200 --pos 0x0 --rotate normal

feh --no-fehbg --bg-scale "$HOME/.config/wallpaper/theme.jpg"

xrdb -merge <<EOF
Xft.dpi: 96
Xcursor.size: 24
EOF

xset s off
xset -dpms
xset s noblank

# setxkbmap gb
