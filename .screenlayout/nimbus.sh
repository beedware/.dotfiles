#!/bin/sh

xrandr --output DP-0 --mode 1920x1080 --rate 143.85 --rotate left --pos 0x0 \
       --output DP-4 --primary --mode 1920x1080 --rate 143.85 --rotate normal --pos 1080x420

feh --no-fehbg \
  --bg-scale "$HOME/.config/wallpaper/theme.jpg" \
  --bg-fill "$HOME/.config/wallpaper/theme.jpg"

xset s off
xset -dpms
xset s noblank

# setxkbmap gb
