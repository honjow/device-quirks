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
WIREPLUMBER_SRC="$DQ_PATH/scripts/msi/claw_a1m/wireplumber.conf.d"

# wireplumber_config.sh
$DQ_PATH/scripts/wireplumber_config.sh "$WIREPLUMBER_SRC" "$WIREPLUMBER_DST"

# sysctl.d
SYSCTL_DST="${MOUNT_PATH}/etc/sysctl.d/"
SYSCTL_SRC="$DQ_PATH/scripts/msi/claw_a1m/sysctl.d"
mkdir -p "$SYSCTL_DST"

# Use mapfile to read find results into array
mapfile -t sysctl_files < <(find "$SYSCTL_SRC" -type f)

# Loop through the array
for file in "${sysctl_files[@]}"; do
  filename=$(basename "$file")
  dst="$SYSCTL_DST/$filename"
  mkdir -p $(dirname "$dst")
  cp "$file" "$dst"
done

# modules-load.d
MODULES_LOAD_D_DST="${MOUNT_PATH}/etc/modules-load.d/"
MODULES_LOAD_D_SRC="$DQ_PATH/scripts/msi/claw_a1m/modules-load.d"
mkdir -p "$MODULES_LOAD_D_DST"

# Use mapfile to read find results into array
mapfile -t modules_files < <(find "$MODULES_LOAD_D_SRC" -type f)

# Loop through the array
for file in "${modules_files[@]}"; do
  filename=$(basename "$file")
  dst="$MODULES_LOAD_D_DST/$filename"
  cp "$file" "$dst"
done

# modprobe.d
MODPROBE_D_DST="${MOUNT_PATH}/etc/modprobe.d/"
MODPROBE_D_SRC="$DQ_PATH/scripts/msi/claw_a1m/modprobe.d"
mkdir -p "$MODPROBE_D_DST"

# Use mapfile to read find results into array
mapfile -t modprobe_files < <(find "$MODPROBE_D_SRC" -type f)

# Loop through the array
for file in "${modprobe_files[@]}"; do
  filename=$(basename "$file")
  dst="$MODPROBE_D_DST/$filename"
  cp "$file" "$dst"
done

# echo "Adding pcie_aspm=force to kernel options, to fix suspend/resume"
$DQ_PATH/scripts/kernel-options-manager --append pcie_aspm=force

# Replaced by udev rule 90-claw-a1m-wifi-rtd3-fix.rules, which pins only the
# WiFi upstream Root Port at D0 instead of disabling runtime PM on every port.
#echo "Adding pcie_port_pm=off to fix wifi suspend/resume"
#$DQ_PATH/scripts/kernel-options-manager --append pcie_port_pm=off

echo "Use Xe driver"
$DQ_PATH/scripts/kernel-options-manager --append i915.force_probe=!7d55
$DQ_PATH/scripts/kernel-options-manager --append xe.force_probe=7d55

# Ensure IPv6 is enabled in NetworkManager connections
$DQ_PATH/scripts/enable_ipv6.sh