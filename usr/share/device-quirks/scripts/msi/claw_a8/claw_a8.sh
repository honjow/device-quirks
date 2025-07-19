#!/bin/bash
# shellcheck disable=SC1091

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

# sysctl.d
SYSCTL_DST="${MOUNT_PATH}/etc/sysctl.d/"
SYSCTL_SRC="$DQ_PATH/scripts/msi/claw_a8/sysctl.d"
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
MODULES_LOAD_D_SRC="$DQ_PATH/scripts/msi/claw_a8/modules-load.d"
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
MODPROBE_D_SRC="$DQ_PATH/scripts/msi/claw_a8/modprobe.d"
mkdir -p "$MODPROBE_D_DST"

# Use mapfile to read find results into array
mapfile -t modprobe_files < <(find "$MODPROBE_D_SRC" -type f)

# Loop through the array
for file in "${modprobe_files[@]}"; do
  filename=$(basename "$file")
  dst="$MODPROBE_D_DST/$filename"
  echo "Copying $file to $dst"
  cp "$file" "$dst"
done

$DQ_PATH/scripts/kernel-options-manager --append amd_pmc.dyndbg=+p
$DQ_PATH/scripts/kernel-options-manager --append acpi.ec_no_wakeup=1
$DQ_PATH/scripts/kernel-options-manager --append pcie_port_pm=force
# processor.max_cstate=9
# $DQ_PATH/scripts/kernel-options-manager --append processor.max_cstate=9