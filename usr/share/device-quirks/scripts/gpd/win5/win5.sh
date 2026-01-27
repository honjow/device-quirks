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

# Define paths
WIN5_SYSCTL_CONF="$DQ_PATH/scripts/gpd/win5/sysctl.d/90-enable-ipv6.conf"
SYSCTL_DIR="${MOUNT_PATH}/etc/sysctl.d/"

# Install sysctl configuration for IPv6
if [[ -f "${WIN5_SYSCTL_CONF}" ]]; then
  echo "Installing sysctl IPv6 configuration from ${WIN5_SYSCTL_CONF} to ${SYSCTL_DIR}"
  if [[ ! -d "${SYSCTL_DIR}" ]]; then
    mkdir -p "${SYSCTL_DIR}"
  fi
  
  cp "${WIN5_SYSCTL_CONF}" "${SYSCTL_DIR}"
  echo "Sysctl IPv6 configuration successfully copied to ${SYSCTL_DIR}"
  
  # Apply sysctl settings immediately if not in install mode
  if [[ -z "${MOUNT_PATH}" ]]; then
    echo "Applying sysctl settings..."
    sysctl -p "${SYSCTL_DIR}/90-enable-ipv6.conf"
  fi
fi

# Ensure IPv6 is enabled in NetworkManager connections
# Note: Not using --restart-connections by default to avoid network interruption
$DQ_PATH/scripts/enable_ipv6.sh

# Define the path of the gpd win5 pipewire config and pipewire folders
WIN5_CONF="$DQ_PATH/scripts/gpd/win5/pipewire.conf.d/"
PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/pipewire.conf.d/"

for file in "${WIN5_CONF}"/*.conf; do
  [[ -f "${file}" ]] || continue
  echo "Installing pipewire config from ${file} to ${PIPEWIRE_DIR}"
  if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
    mkdir -p "${PIPEWIRE_DIR}"
  fi
  cp "${file}" "${PIPEWIRE_DIR}"
  echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
done

# Define the path for WirePlumber configuration
WIN5_WP_CONF="$DQ_PATH/scripts/gpd/win5/wireplumber.conf.d/"
WIREPLUMBER_DIR="${MOUNT_PATH}/etc/wireplumber/wireplumber.conf.d/"

# Install WirePlumber headroom configuration
for file in "${WIN5_WP_CONF}"/*.conf; do
  [[ -f "${file}" ]] || continue
  echo "Installing wireplumber config from ${file} to ${WIREPLUMBER_DIR}"
  if [[ ! -d "${WIREPLUMBER_DIR}" ]]; then
    mkdir -p "${WIREPLUMBER_DIR}"
  fi
  cp "${file}" "${WIREPLUMBER_DIR}"
  echo "WirePlumber configuration successfully copied to ${WIREPLUMBER_DIR}"
done

