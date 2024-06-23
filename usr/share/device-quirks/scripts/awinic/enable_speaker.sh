#!/bin/bash
echo aw87xxx_pa 0x5b > /sys/bus/i2c/devices/i2c-1/new_device


PRODUCT_NAME=$(cat /sys/devices/virtual/dmi/id/product_name)
PRODUCT_LIST="AIR 1S:AIR 1S Limited:FLIP DS:FLIP KB:KUN:AIR Plus"

if [[ ":$PRODUCT_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "ayaneo detected, disabling speaker power saving"
	echo 0 | tee /sys/module/snd_hda_intel/parameters/power_save
fi