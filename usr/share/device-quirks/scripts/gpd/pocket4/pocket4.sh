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

# Define the path of the gpd pocket4 pipewire config and pipewire folders
# from https://github.com/Manawyrm/gpd-pocket-4-pipewire
POCKET4_CONF_DIR="$DQ_PATH/scripts/gpd/pocket4/pipewire.conf.d/"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"

# Check if the PipeWire directory exists
if [[ -d "${POCKET4_CONF_DIR}" ]]; then
  echo "Installing pipewire config from ${POCKET4_CONF_DIR} to ${PIPEWIRE_DIR}"
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi

  # Copy the PipeWire files to /etc
  cp -rf "${POCKET4_CONF_DIR}"/* "${PIPEWIRE_DIR}"
  echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
else
  echo "PipeWire config not found at ${POCKET4_CONF_DIR}"
  exit 1
fi