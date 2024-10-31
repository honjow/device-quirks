#!/bin/bash

# Detect if the install media is running or not
if [ ! -d /tmp/frzr_root ]; then
  MOUNT_PATH=""
fi

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)

AIR_LIST="AIR:AIR Pro"
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

if [[ "AYANEO 2S" == "$PRODUCT" || "GEEK 1S" == "$PRODUCT" ]]; then
    echo "AYANEO 2S detected, adding usb_hid to the list of modules to be removed"
    # add usb_hid to the list of modules, if it's not already there
    if ! grep -q usb_hid $suspend_mods_file; then
        echo "usb_hid" >> $suspend_mods_file
    fi
fi

if [[ ":$AIR_LIST:" =~ ":$PRODUCT:" ]]; then
    # if AX210 is detected, add iwlmvm to the list of modules to be removed
    if lspci | grep -q "AX210"; then
        echo "AIR series detected, and AX210 detected, adding iwlmvm to the list of modules to be removed"
        # add iwlmvm to the list of modules, if it's not already there
        if ! grep -q iwlmvm $suspend_mods_file; then
            echo "iwlmvm" >> $suspend_mods_file
        fi
    fi
fi