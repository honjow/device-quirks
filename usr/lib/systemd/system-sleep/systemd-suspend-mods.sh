#!/bin/bash
# This file runs during sleep/resume events. It will read the list of modules
# in /etc/device-quirks/systemd-suspend-mods.conf and modprobe -r them on suspend,
# modprobe them on resume.

MOD_LIST=$(grep -v ^\# /etc/device-quirks/systemd-suspend-mods.conf)

PRODUCT=$(cat /sys/devices/virtual/dmi/id/product_name)

ROG_LIST="ROG Ally RC71L_RC71L:ROG Ally RC71L"
NEXT_LIST="NEXT Advance:NEXT Lite:NEXT Pro:NEXT"
GEEK_LIST="GEEK:GEEK 1S"

SKIP_MT7921E=false
if [[ ":$ROG_LIST:" =~ ":$PRODUCT:" ]]; then
    echo "ROG Ally detected, skipping mt7921e"
    SKIP_MT7921E=true
fi

if [[ ":$NEXT_LIST:" =~ ":$PRODUCT:" ]]; then
    echo "NEXT detected, adding iwlmvm to the list of modules to be removed"
    MOD_LIST=$(echo -e "${MOD_LIST}\niwlmvm")
fi

if [[ ":$GEEK_LIST:" =~ ":$PRODUCT:" ]]; then
    echo "GEEK detected, adding goodix_ts to the list of modules to be removed"
    MOD_LIST=$(echo -e "${MOD_LIST}\ngoodix_ts")
fi

echo -e "MOD_LIST: \n$MOD_LIST"

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
