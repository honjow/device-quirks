#!/bin/bash

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

winmini_dir="$DQ_PATH/scripts/gpd/winmini"
pipewire_dir="$winmini_dir/pipewire"  # Adjust this path as necessary

# Check if the PipeWire directory exists
if [ -d "$pipewire_dir" ]; then
    # Copy the PipeWire folder to /etc
    cp -r "$pipewire_dir" /etc/
    echo "PipeWire configuration successfully copied to /etc."
else
    echo "PipeWire directory not found in $pipewire_dir."
    exit 1
fi

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do EDID override.
  echo "Enabling EDID Override"
  $DQ_PATH/scripts/override_edid "eDP-1" "gpd_winmini_edid.bin"
else
  echo -e "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi