#!/bin/bash
# This file runs during sleep/resume events. It will read the list of modules
# in /etc/device-quirks/systemd-suspend-mods.conf and rmmod them on suspend,
# insmod them on resume.

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)
ROG_LIST="ROG Ally RC71L_RC71L:ROG Ally RC71L"

SKIP_MT7921E=false
if [[ ":$ROG_LIST:" =~ ":$PRODUCT:" ]]; then
    SKIP_MT7921E=true
fi

MOD_LIST=$(grep -v ^\# /etc/device-quirks/systemd-suspend-mods.conf)

case $1 in
    pre)
        for mod in $MOD_LIST; do
            if [[ $SKIP_MT7921E == true && $mod == "mt7921e" ]]; then
                continue
            fi
            modprobe -r $mod
        done
    ;;
    post)
        for mod in $MOD_LIST; do
            if [[ $SKIP_MT7921E == true && $mod == "mt7921e" ]]; then
                continue
            fi
            modprobe $mod
        done
    ;;
esac
