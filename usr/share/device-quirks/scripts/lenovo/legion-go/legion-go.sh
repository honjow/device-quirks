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
PIPEWIRE_CONF_DIR="$DQ_PATH/scripts/lenovo/legion-go/pipewire.conf.d/"
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
else
  echo "PipeWire config not found at ${PIPEWIRE_CONF_DIR}"
  exit 1
fi

WIREPLUMBER_DST="${MOUNT_PATH}/etc/wireplumber/wireplumber.conf.d"
WIREPLUMBER_SRC="$DQ_PATH/scripts/lenovo/legion-go/wireplumber.conf.d"

# wireplumber_config.sh
$DQ_PATH/scripts/wireplumber_config.sh "$WIREPLUMBER_SRC" "$WIREPLUMBER_DST"
