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
PIPEWIRE_CONF_DIR="$DQ_PATH/scripts/gpd/winmini/pipewire.conf.d/"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"

# Install PipeWire configuration files
if [[ -d "${PIPEWIRE_CONF_DIR}" ]]; then
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi

  for file in "${PIPEWIRE_CONF_DIR}"/*.conf; do
    [[ -f "${file}" ]] || continue
    echo "Installing pipewire config from ${file} to ${PIPEWIRE_DIR}"
    cp "${file}" "${PIPEWIRE_DIR}"
    echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
  done
fi

if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do EDID override.
  echo "Enabling EDID Override"
  $DQ_PATH/scripts/override_edid "eDP-1" "gpd_winmini_edid.bin"
else
  echo -e "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi