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

# Define the path of the ally pipewire config and pipewire folders
ALLY_CONF="$DQ_PATH/scripts/asus/rog-ally/pipewire.conf.d/filter-chain.conf"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"

# Check if the PipeWire directory exists
if [[ -f "${ALLY_CONF}" ]]; then
  echo "Installing pipewire config from ${ALLY_CONF} to ${PIPEWIRE_DIR}"
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi

  # Copy the PipeWire folder to /etc
  cp "${ALLY_CONF}" "${PIPEWIRE_DIR}"
  echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
else
  echo "PipeWire config not found at ${ALLY_CONF}"
  exit 1
fi

ALLY_EQ_CONF="$DQ_PATH/scripts/asus/rog-ally/pipewire.conf.d/filter-chain-eq.conf"
if [[ -f "${ALLY_EQ_CONF}" ]]; then
  echo "Installing pipewire eq config from ${ALLY_EQ_CONF} to ${PIPEWIRE_DIR}"
  cp "${ALLY_EQ_CONF}" "${PIPEWIRE_DIR}"
  echo "PipeWire eq configuration successfully copied to ${PIPEWIRE_DIR}"
else
  echo "PipeWire eq config not found at ${ALLY_EQ_CONF}"
  exit 1
fi


WIREPLUMBER_DST="${MOUNT_PATH}/etc/wireplumber/wireplumber.conf.d"
WIREPLUMBER_SRC="$DQ_PATH/scripts/asus/rog-ally/wireplumber.conf.d"

# wireplumber_config.sh
$DQ_PATH/scripts/wireplumber_config.sh "$WIREPLUMBER_SRC" "$WIREPLUMBER_DST"