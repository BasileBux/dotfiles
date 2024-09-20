#!/bin/bash

max=255
steps=17

# Run brightnessctl -l and store the output in a variable
devices=$(brightnessctl -l)

# Extract the name of the first device using grep
first_device=$(echo "$devices" | grep -oE "^Device '[^']+'" | head -n 1)

# Extract the device name without quotes
device_name=$(echo "$first_device" | sed "s/^Device '\(.*\)'$/\1/")

# Print the name of the first device
echo "Name of the first device: $device_name"

increaseMonBacklight() {
    current=$(brightnessctl -d "$device_name" get)

    new=$((current + steps))
    echo "current brightness is $current"
    echo "your new brightness is $new"

    if [ "$new" -le "$max" ];then
        brightnessctl -d "$device_name" set "$new"
    fi
}

decreaseMonBacklight(){
    current=$(brightnessctl -d "$device_name" get)

    new=$((current - steps))
    echo "current brightness is $current"
    echo "your new brightness is $new"

    if [ "$new" -ge 0 ];then
        brightnessctl -d "$device_name" set "$new"
    fi
}

# Get kb backlight control action from command line argument
case "$1" in
    "--inc")
        increaseMonBacklight
        ;;
    "--dec")
        decreaseMonBacklight
        ;;
    *)
        echo "Usage: $0 [--inc|--dec]"
        exit 1
        ;;
esac

