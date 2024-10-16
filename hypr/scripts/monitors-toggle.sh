#! /usr/bin/env sh

# Internal is eDP-1 when asusMuxDGPU is enabled and eDP-2 when it is disabled
# Add support for this automation

DGPU_INTERNAL_MONITOR="eDP-1"
INTEGRATED_INTERNAL_MONITOR="eDP-2"
EXTERNAL_MONITOR1="DP-1"
EXTERNAL_MONITOR2="HDMI-A-1"

NUM_MONITORS=$(hyprctl monitors all | grep Monitor | wc --lines)
NUM_MONITORS_ACTIVE=$(hyprctl monitors | grep Monitor | wc --lines)

if [ $NUM_MONITORS -gt 1 ]; then
    killall hypridle
    hyprctl keyword monitor "$DGPU_INTERNAL_MONITOR, disable"
    hyprctl keyword monitor "$INTEGRATED_INTERNAL_MONITOR, disable"

    # Monitors
    hyprctl keyword workspace "1,monitor:$EXTERNAL_MONITOR1"
    hyprctl keyword workspace "2,monitor:$EXTERNAL_MONITOR1"
    hyprctl keyword workspace "3,monitor:$EXTERNAL_MONITOR1"
    hyprctl keyword workspace "4,monitor:$EXTERNAL_MONITOR1"
    hyprctl keyword workspace "5,monitor:$EXTERNAL_MONITOR1"
    hyprctl keyword workspace "6,monitor:$EXTERNAL_MONITOR2"
    hyprctl keyword workspace "7,monitor:$EXTERNAL_MONITOR2"
    hyprctl keyword workspace "8,monitor:$EXTERNAL_MONITOR2"
    hyprctl keyword workspace "9,monitor:$EXTERNAL_MONITOR2"
    hyprctl keyword workspace "10,monitor:$EXTERNAL_MONITOR2"

fi
# Turn off the laptop monitor if its on + more than one monitor is active
# This is currently the case on startup if you use hyprland's default monitor settings
# if [ $NUM_MONITORS_ACTIVE -gt 1 ] && hyprctl monitors | grep --quiet $INTERNAL_MONITOR; then
#     hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
#     exit
# fi

# if [ $NUM_MONITORS -gt 1 ]; then  # Don't do anything if only a single monitor is detected

#   if hyprctl monitors | grep --quiet $EXTERNAL_MONITOR; then
#     hyprctl keyword monitor "$EXTERNAL_MONITOR, disable"
#     hyprctl keyword monitor "$INTERNAL_MONITOR, preferred, 0, auto"
#   else
#     hyprctl keyword monitor "$INTERNAL_MONITOR, disable"
#     hyprctl keyword monitor "$EXTERNAL_MONITOR, preferred, 0, auto"
#   fi
# fi
