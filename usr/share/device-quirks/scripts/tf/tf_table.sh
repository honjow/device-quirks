#!/bin/bash

PRODUCT_NAME="$(cat /sys/class/dmi/id/product_name)"

HANDLE5_LIST="Handle 5"

if [[ ":$HANDLE5_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "Handle 5"
    $DQ_PATH/scripts/tf/handle5/handle5.sh

else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
