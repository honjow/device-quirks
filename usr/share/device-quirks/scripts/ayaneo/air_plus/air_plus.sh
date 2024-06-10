#!/bin/bash
if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

if [ -d /tmp/frzr_root ]; then
  source ${MOUNT_PATH}/etc/device-quirks/device-quirks.conf
else
  source /etc/device-quirks/device-quirks.conf
fi

# Force 16 bit audio, format S16LE, sample rate 96000.
echo "Force S16LE 96000hz"
$DQ_PATH/scripts/override_bitrate

# Create a symlink to the firmware file
echo "Creating symlink to aw87xxx firmware file"
if [ ! -d "${MOUNT_PATH}/etc/device-quirks/firmware/" ]; then
    mkdir -p "${MOUNT_PATH}/etc/device-quirks/firmware/"
fi
ln -sf "/usr/lib/firmware/aw87xxx/aw87559/awinic_smartk_acf.bin" "${MOUNT_PATH}/etc/device-quirks/firmware/aw87xxx_acf.bin"


if [[ $USE_FIRMWARE_OVERRIDES == 1 ]]; then
  # Do EDID override.
  echo "Enabling EDID Override"
  $DQ_PATH/scripts/override_edid "eDP-1" "ayaneo_airplus_edid.bin"
else
  echo "Firmware overrides are disabled, skipping...\n"
  echo "To enable firmware overrides, edit /etc/device-quirks/device-quirks.conf"
fi
