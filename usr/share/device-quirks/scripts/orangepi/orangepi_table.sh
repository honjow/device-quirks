#/bin/bash

BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"

# NEO
BOARD_NEO="NEO-01"

if [[ ":$BOARD_NEO:" =~ ":$BOARD_NAME:" ]]; then
  echo "NEO"
  $DQ_PATH/scripts/orangepi/neo/neo.sh

# No Match
else
  echo "${BOARD_NAME} does not have a quirk configuration script. Exiting."
fi
