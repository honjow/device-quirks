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

# modprobe.d
MODPROBE_D_DST="${MOUNT_PATH}/etc/modprobe.d/"
MODPROBE_D_SRC="$DQ_PATH/scripts/msi/claw8/modprobe.d"
mkdir -p "$MODPROBE_D_DST"
for file in $(find "$MODPROBE_D_SRC" -type f); do
  filename=$(basename "$file")
  dst="$MODPROBE_D_DST/$filename"
  cp "$file" "$dst"
done