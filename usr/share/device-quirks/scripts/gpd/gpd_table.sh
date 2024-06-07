#/bin/bash

BOARD_NAME="$(cat /sys/devices/virtual/dmi/id/board_name)"

# Win3
BOARD_WIN3="G1618-03"

# WinMax2
BOARD_WM2="G1619-04"

# Win3
BOARD_WIN3="G1618-03"

# Win4
BOARD_WIN4="G1618-04"

# WinMini
BOARD_WINMINI="G1617-01"

# WinMax2
if [[ ":$BOARD_WM2:" =~ ":$BOARD_NAME:" ]]; then
  echo "WinMax2"
  $DQ_PATH/scripts/gpd/winmax2/winmax2.sh
elif [[ ":$BOARD_WIN4:" =~ ":$BOARD_NAME:" ]]; then
  echo "Win4"
  $DQ_PATH/scripts/gpd/win4/win4.sh
elif [[ ":$BOARD_WINMINI:" =~ ":$BOARD_NAME:" ]]; then
  echo "WinMini"
  $DQ_PATH/scripts/gpd/winmini/winmini.sh
elif [[ ":$BOARD_WIN3:" =~ ":$BOARD_NAME:" ]]; then
  echo "Win3"
  $DQ_PATH/scripts/gpd/win3/win3.sh

# No Match
else
  echo "${BOARD_NAME} does not have a quirk configuration script. Exiting."
fi
