#!/bin/bash

PRODUCT_NAME="$(cat /sys/devices/virtual/dmi/id/product_name)"

OXP2_LIST="ONEXPLAYER 2 ARP23"
OXP2PRO_LIST="ONEXPLAYER 2 PRO ARP23H:ONEXPLAYER 2 PRO ARP23P:ONEXPLAYER 2 PRO ARP23P EVA-01"

if [[ "ONEXPLAYER Mini Pro" == "$PRODUCT_NAME" ]]; then
    echo "OXP Mini Pro"
    $DQ_PATH/scripts/oxp/mini_pro/mini_pro.sh

elif [[ ":$OXP2_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "OXP 2"
    $DQ_PATH/scripts/oxp/2/2.sh

elif [[ ":$OXP2PRO_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "OXP 2 Pro"
    $DQ_PATH/scripts/oxp/2pro/2pro.sh
    
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
