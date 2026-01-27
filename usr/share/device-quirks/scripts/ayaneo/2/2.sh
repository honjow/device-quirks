#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"
PIPEWIRE_CONF_DIR="$DQ_PATH/scripts/ayaneo/2/pipewire.conf.d/"
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

# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate
