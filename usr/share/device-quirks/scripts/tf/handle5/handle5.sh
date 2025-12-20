#!/bin/bash

set -e

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi


# copy gamescope overwrite
echo "Copying gamescope scripts overwrite"
if [ ! -d "/etc/gamescope/scripts/" ]; then
  mkdir -p "/etc/gamescope/scripts/"
fi
cp $DQ_PATH/scripts/tf/handle5/gamescope_scripts/overwrite.lua /etc/gamescope/scripts/overwrite.lua
echo "Gamescope scripts overwrite successfully copied"

