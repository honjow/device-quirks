#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"
EQ_CONF="$DQ_PATH/scripts/ayaneo/2/pipewire.conf.d/filter-chain-eq.conf"
if [[ -f "${EQ_CONF}" ]]; then
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi
  
  echo "Installing pipewire eq config from ${EQ_CONF} to ${PIPEWIRE_DIR}"
  cp "${EQ_CONF}" "${PIPEWIRE_DIR}"
  echo "PipeWire eq configuration successfully copied to ${PIPEWIRE_DIR}"
fi

# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate
