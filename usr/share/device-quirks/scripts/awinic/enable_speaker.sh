#!/bin/bash
echo aw87xxx_pa 0x5b > /sys/bus/i2c/devices/i2c-1/new_device


PRODUCT_NAME=$(cat /sys/devices/virtual/dmi/id/product_name)
PRODUCT_LIST_AIR_1S="AIR 1S:AIR 1S Limited"

if [[ ":$PRODUCT_LIST_AIR_1S:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "AYANEO AIR 1S detected, disabling speaker power saving"
	echo 0 | tee /sys/module/snd_hda_intel/parameters/power_save
fi