#!/bin/bash
# This file runs during sleep/resume events. It will read the list of modules
# in /etc/device-quirks/systemd-suspend-mods.conf and modprobe -r them on suspend,
# modprobe them on resume.

MOD_LIST=$(grep -v ^\# /etc/device-quirks/systemd-suspend-mods.conf)

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)

NEXT_LIST="NEXT Advance:NEXT Lite:NEXT Pro:NEXT"
GEEK_LIST="GEEK:GEEK 1S"
AYANEO_2021_LIST="AYA NEO FOUNDER:AYA NEO 2021:AYANEO 2021:AYANEO 2021 Pro:AYANEO 2021 Pro Retro Power"

if [[ ":$NEXT_LIST:" =~ ":$PRODUCT:" ]]; then
    echo "NEXT detected, adding iwlmvm to the list of modules to be removed"
    MOD_LIST=$(echo -e "${MOD_LIST}\niwlmvm")
fi

if [[ ":$GEEK_LIST:" =~ ":$PRODUCT:" || ":$AYANEO_2021_LIST:" =~ ":$PRODUCT:"  ]]; then
    echo "GEEK detected, adding goodix_ts to the list of modules to be removed"
    MOD_LIST=$(echo -e "${MOD_LIST}\ngoodix_ts")
fi

echo -e "MOD_LIST: \n$MOD_LIST"

case $1 in
    pre)
        for mod in $MOD_LIST; do
            modprobe -r $mod
        done
    ;;
    post)
        for mod in $MOD_LIST; do
            modprobe $mod
        done
    ;;
esac
