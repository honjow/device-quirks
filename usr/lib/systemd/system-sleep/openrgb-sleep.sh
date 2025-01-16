#!/bin/bash

# Get the user who is currently logged in
CURRENT_USER=$(who | grep -v root | head -n 1 | awk '{print $1}')

if [ -z "$CURRENT_USER" ]; then
    echo "No non-root user found, exiting"
    exit 0
fi

# Default values
sleep_profile="sleep"
wake_profile="default"

# Try user config first
USER_CONFIG="/home/$CURRENT_USER/.config/OpenRGB/openrgb-sleep.conf"
if [ -f "$USER_CONFIG" ]; then
    source "$USER_CONFIG"
else
    # Fall back to system config
    SYSTEM_CONFIG="/etc/device-quirks/openrgb-sleep.conf"
    if [ -f "$SYSTEM_CONFIG" ]; then
        source "$SYSTEM_CONFIG"
    fi
fi

# Function to check if profile exists
check_profile() {
    profile="$1"
    profile_path="/home/$CURRENT_USER/.config/OpenRGB/$profile.orp"
    if [ ! -f "$profile_path" ]; then
        echo "Profile '$profile' not found at $profile_path"
        return 1
    fi
    return 0
}

# Function to run openrgb as the user
run_openrgb() {
    profile="$1"
    if check_profile "$profile"; then
        su - "$CURRENT_USER" -c "openrgb --profile '$profile'"
    fi
}

case "$1" in
    pre)
        # Apply sleep profile before system sleeps
        run_openrgb "$sleep_profile"
        ;;
    post)
        # Apply wake profile after system wakes up
        run_openrgb "$wake_profile"
        ;;
esac
