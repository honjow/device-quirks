#!/bin/bash

PRODUCT_NAME="$(cat /sys/class/dmi/id/product_name)"
BOARD_NAME="$(cat /sys/class/dmi/id/board_name)"

OXP2_LIST="ONEXPLAYER 2 ARP23"
OXP2PRO_LIST="ONEXPLAYER 2 PRO ARP23H:ONEXPLAYER 2 PRO ARP23P:ONEXPLAYER 2 PRO ARP23P EVA-01"
OXP_APEX_LIST="ONEXPLAYER APEX"
OXP_MINI_LIST="ONE XPLAYER:ONEXPLAYER mini A07:ONEXPLAYER mini GA72:ONEXPLAYER mini GT72:ONEXPLAYER Mini Pro"

if [[ ":$OXP_MINI_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "OXP Mini"
    $DQ_PATH/scripts/oxp/mini/mini.sh

elif [[ ":$OXP2_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "OXP 2"
    $DQ_PATH/scripts/oxp/2/2.sh

elif [[ ":$OXP2PRO_LIST:" =~ ":$PRODUCT_NAME:" ]]; then
    echo "OXP 2 Pro"
    $DQ_PATH/scripts/oxp/2pro/2pro.sh

elif [[ ":$OXP_APEX_LIST:" =~ ":$BOARD_NAME:" ]]; then
    echo "OXP Apex"
    $DQ_PATH/scripts/oxp/apex/apex.sh
    
else
    echo "${PRODUCT_NAME} does not have a quirk configuration script. Exiting."
fi
