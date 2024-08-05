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

# Define the path of the gpd win mini pipewire config and pipewire folders
MINI_CONF="$DQ_PATH/scripts/gpd/winmini/pipewire.conf.d/filter-chain.conf"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"

# Check if the PipeWire directory exists
if [[ -f "${MINI_CONF}" ]]; then
  echo "Installing pipewire config from ${MINI_CONF} to ${PIPEWIRE_DIR}"
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi

  # Copy the PipeWire folder to /etc
  cp "${MINI_CONF}" "${PIPEWIRE_DIR}"
  echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
else
  echo "PipeWire config not found at ${MINI_CONF}"
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