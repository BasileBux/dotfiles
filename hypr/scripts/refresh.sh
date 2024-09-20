#!/bin/bash

# waybar

killall waybar
sleep 0.2
# Relaunch waybar
waybar
killall swaybg

sh ~/.config/hypr/scripts/randomWallpaper.sh
swaybg -i ~/wallpaper.png -m fill
