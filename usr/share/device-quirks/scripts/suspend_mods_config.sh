#!/bin/bash

# Detect if the install media is running or not
if [ ! -d /tmp/frzr_root ]; then
  MOUNT_PATH=""
fi

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)

NEXT_LIST="NEXT Advance:NEXT Lite:NEXT Pro:NEXT"
GEEK_LIST="GEEK:GEEK 1S"
AYANEO_2021_LIST="AYA NEO FOUNDER:AYA NEO 2021:AYANEO 2021:AYANEO 2021 Pro:AYANEO 2021 Pro Retro Power"

suspend_mods_file="${MOUNT_PATH}/etc/device-quirks/systemd-suspend-mods.conf"

if [[ ":$NEXT_LIST:" =~ ":$PRODUCT:" ]]; then
    echo "NEXT detected, adding iwlmvm to the list of modules to be removed"
    # add iwlmvm to the list of modules, if it's not already there
    if ! grep -q iwlmvm $suspend_mods_file; then
        echo "iwlmvm" >> $suspend_mods_file
    fi
fi

if [[ ":$GEEK_LIST:" =~ ":$PRODUCT:" || ":$AYANEO_2021_LIST:" =~ ":$PRODUCT:"  ]]; then
    echo "GEEK detected, adding goodix_ts to the list of modules to be removed"
    # add goodix_ts to the list of modules, if it's not already there
    if ! grep -q goodix_ts $suspend_mods_file; then
        echo "goodix_ts" >> $suspend_mods_file
    fi
fi