#!/bin/bash

BOARD_NAME="$(cat /sys/class/dmi/id/board_name)"

# B650I EDGE WIFI
BOARD_B650I_EDGE="MPG B650I EDGE WIFI (MS-7D73)"

# Claw A1M
BOARD_CLAW_A1M="MS-1T41"

# Claw 8
BOARD_CLAW8="MS-1T52"

# Claw A8
BOARD_CLAW_A8="MS-1T8K"

if [[ ":$BOARD_B650I_EDGE:" =~ ":$BOARD_NAME:" ]]; then
  echo "B650I EDGE WIFI"
  $DQ_PATH/scripts/msi/b650i_edge/b650i_edge.sh

elif [[ ":$BOARD_CLAW8:" =~ ":$BOARD_NAME:" ]]; then
  echo "Claw 8"
  $DQ_PATH/scripts/msi/claw8/claw8.sh

elif [[ ":$BOARD_CLAW_A1M:" =~ ":$BOARD_NAME:" ]]; then
  echo "Claw A1M"
  $DQ_PATH/scripts/msi/claw_a1m/claw_a1m.sh

elif [[ ":$BOARD_CLAW_A8:" =~ ":$BOARD_NAME:" ]]; then
  echo "Claw A8"
  $DQ_PATH/scripts/msi/claw_a8/claw_a8.sh

# No Match
else
  echo "${BOARD_NAME} does not have a quirk configuration script. Exiting."
fi
