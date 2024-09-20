#!/bin/bash

# Check if a window with class Spotify exists
if hyprctl clients | grep -q "class: Spotify"; then
    # If Spotify window exists, focus on workspace 10
    hyprctl dispatch workspace 10
else
    # If Spotify window doesn't exist, open Spotify
    hyprctl dispatch exec spotify
fi
