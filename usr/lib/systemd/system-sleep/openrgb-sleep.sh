#!/bin/bash

# Read config file
CONFIG_FILE="/etc/device-quirks/openrgb-sleep.conf"
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
else
    sleep_profile="sleep"
    wake_profile="default"
fi

case "$1" in
    pre)
        # Apply sleep profile before system sleeps
        openrgb --profile "$sleep_profile"
        ;;
    post)
        # Apply wake profile after system wakes up
        openrgb --profile "$wake_profile"
        ;;
esac
