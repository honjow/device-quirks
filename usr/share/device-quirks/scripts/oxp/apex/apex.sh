#!/bin/bash

set -e

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

# from https://discord.com/channels/547366894995243029/1421079632030994432/1473571480993402921
# fix Issue: Device fails to wake up from sleep mode
$DQ_PATH/scripts/kernel-options-manager --append amd_iommu=off

# fix Issue: Issue: Controller becomes unresponsive after waking from sleep
$DQ_PATH/scripts/kernel-options-manager --append xpad.cpoll=1
