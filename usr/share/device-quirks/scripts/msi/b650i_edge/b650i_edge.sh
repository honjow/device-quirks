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

WIREPLUMBER_DIR="${MOUNT_PATH}/etc/wireplumber/wireplumber.conf.d"
WIREPLUMBER_CONF="$DQ_PATH/scripts/msi/b650i_edge/wireplumber.conf.d"

# Check if the WirePlumber directory exists
if compgen -G "$WIREPLUMBER_CONF" > /dev/null; then
  echo "Installing WirePlumber config from ${WIREPLUMBER_CONF} to ${WIREPLUMBER_DIR}"
  if [[ ! -d "${WIREPLUMBER_DIR}" ]]; then
    mkdir -p "${WIREPLUMBER_DIR}"
  fi

  if [[ -n $(ls -A "${WIREPLUMBER_DIR}/"*.conf) ]]; then
    echo "Removing existing WirePlumber configuration files"
    rm -r "${WIREPLUMBER_DIR}/"*.conf
  fi

  # Copy the WirePlumber conf to /etc
  cp "${WIREPLUMBER_CONF}/"*.conf "${WIREPLUMBER_DIR}/"
  echo "WirePlumber configuration successfully copied to ${WIREPLUMBER_DIR}"
else
  echo "WirePlumber config not found at ${WIREPLUMBER_CONF}"
  exit 1
fi