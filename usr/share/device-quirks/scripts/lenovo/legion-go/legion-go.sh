#!/bin/bash

# Check for root
if [[ "$(whoami)" != 'root' ]]; then
  echo "You must be root to run this script."
  exit 1
fi

# Detect if the install media is running or not
if [[ ! -d /tmp/frzr_root ]]; then
  echo "Running as upgrade."
  MOUNT_PATH=""
else
  echo "Running as install."
fi

# Define the path of the legion go pipewire config and pipewire folders
LEGO_CONF="$DQ_PATH/scripts/lenovo/legion-go/pipewire.conf.d/filter-chain.conf"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"

# Check if the PipeWire directory exists
if [[ -f "${LEGO_CONF}" ]]; then
  echo "Installing pipewire config from ${LEGO_CONF} to ${PIPEWIRE_DIR}"
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi

  # Copy the PipeWire folder to /etc
  cp "${LEGO_CONF}" "${PIPEWIRE_DIR}"
  echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
else
  echo "PipeWire config not found at ${LEGO_CONF}"
  exit 1
fi

WIREPLUMBER_DST="${MOUNT_PATH}/etc/wireplumber/wireplumber.conf.d"
WIREPLUMBER_SRC="$DQ_PATH/scripts/lenovo/legion-go/wireplumber.conf.d"

# wireplumber_config.sh
$DQ_PATH/scripts/wireplumber_config.sh "$WIREPLUMBER_SRC" "$WIREPLUMBER_DST"
