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

# ALSA_CONF="$DQ_PATH/scripts/msi/claw8/media-session.d/alsa-monitor.conf"
# PIPEWIRE_DIR="${MOUNT_PATH}/etc/pipewire/media-session.d/"

# # Check if the PipeWire directory exists
# if [[ -f "${ALSA_CONF}" ]]; then
#   echo "Installing pipewire config from ${ALSA_CONF} to ${PIPEWIRE_DIR}"
#   if [[ ! -d "${PIPEWIRE_DIR}" ]]; then
#     mkdir -p "${PIPEWIRE_DIR}"
#   fi

#   # Copy the PipeWire folder to /etc
#   cp "${ALSA_CONF}" "${PIPEWIRE_DIR}"
#   echo "PipeWire configuration successfully copied to ${PIPEWIRE_DIR}"
# fi

# Force 16 bit audio, format S16LE, sample rate 96000.
# echo "Force S16LE 96000hz"
# $DQ_PATH/scripts/override_bitrate

# cp -a ${SUBVOL}/usr/share/wireplumber ${MOUNT_PATH}/etc/
# sed -i 's/--\["api.alsa.headroom"\]      = 1024/\["api.alsa.headroom"\]      = 4096/' ${MOUNT_PATH}/etc/wireplumber/main.lua.d/50-alsa-config.lua

WIREPLUMBER_DST="${MOUNT_PATH}/etc/wireplumber/wireplumber.conf.d"
WIREPLUMBER_SRC="$DQ_PATH/scripts/msi/claw8/wireplumber.conf.d"

# wireplumber_config.sh
$DQ_PATH/scripts/wireplumber_config.sh "$WIREPLUMBER_SRC" "$WIREPLUMBER_DST"

# sysctl.d
SYSCTL_DST="${MOUNT_PATH}/etc/sysctl.d/"
SYSCTL_SRC="$DQ_PATH/scripts/msi/claw8/sysctl.d"
mkdir -p "$SYSCTL_DST"
for file in $(find "$SYSCTL_SRC" -type f); do
  filename=$(basename "$file")
  dst="$SYSCTL_DST/$filename"
  mkdir -p $(dirname "$dst")
  cp "$file" "$dst"
done

# modules-load.d
MODULES_LOAD_D_DST="${MOUNT_PATH}/etc/modules-load.d/"
MODULES_LOAD_D_SRC="$DQ_PATH/scripts/msi/claw8/modules-load.d"
mkdir -p "$MODULES_LOAD_D_DST"
for file in $(find "$MODULES_LOAD_D_SRC" -type f); do
  filename=$(basename "$file")
  dst="$MODULES_LOAD_D_DST/$filename"
  cp "$file" "$dst"
done