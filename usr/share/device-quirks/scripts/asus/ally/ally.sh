#!/bin/bash

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

if [ -d /tmp/frzr_root ]; then
  source ${MOUNT_PATH}/etc/device-quirks/device-quirks.conf
else
  source /etc/device-quirks/device-quirks.conf
fi

# Do DSDT override.
DSDT_OVERRIDES="rog_ally_0x08.dsl rog_ally_0x13.dsl rog_ally_0x58.dsl rog_ally_0x76.dsl"
if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  $DQ_PATH/scripts/override_dsdt $DSDT_OVERRIDES
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi

# Define the path of the ally.sh script and pipewire folder
ally_dir="$DQ_PATH/scripts/asus/ally"
pipewire_dir="$ally_dir/pipewire"  # Adjust this path as necessary

# Check if the PipeWire directory exists
if [ -d "$pipewire_dir" ]; then
    # Copy the PipeWire folder to /etc
    cp -r "$pipewire_dir" /etc/
    echo "PipeWire configuration successfully copied to /etc."
else
    echo "PipeWire directory not found in $pipewire_dir."
    exit 1
fi
