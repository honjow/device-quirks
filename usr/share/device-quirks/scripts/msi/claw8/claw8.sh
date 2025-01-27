#!/bin/bash

set -e

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

ALSA_CONF="$DQ_PATH/scripts/msi/claw8/media-session.d/alsa-monitor.conf"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/media-session.d/"

# Check if the PipeWire directory exists
if [[ -f "${ALSA_CONF}" ]]; then
  echo "Installing pipewire config from ${ALSA_CONF} to ${PIPEWIRE_DIR}"
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi

  # Copy the PipeWire folder to /etc
  cp "${ALSA_CONF}" "${PIPEWIRE_DIR}"
  echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
fi

MAIN_ALSA_CONF="$DQ_PATH/scripts/msi/claw8/main.lua.d/50-alsa-config.lua"
WIREPLUMBER_DIR="${MOUNT_PATH}/etc/wireplumber/main.lua.d/"

# Check if the WirePlumber directory exists
if [[ -f "${MAIN_ALSA_CONF}" ]]; then
  echo "Installing WirePlumber config from ${MAIN_ALSA_CONF} to ${WIREPLUMBER_DIR}"
  if [[ ! -d "${WIREPLUMBER_DIR}" ]]; then
    mkdir -p "${WIREPLUMBER_DIR}"
  fi

  # Copy the WirePlumber folder to /etc
  cp "${MAIN_ALSA_CONF}" "${WIREPLUMBER_DIR}"
  echo "WirePlumber configuration successfully copied to ${WIREPLUMBER_DIR}"
fi