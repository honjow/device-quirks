#!/bin/bash

set -e

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

IS_ENABLED=$(systemctl is-enabled oxp2p-audio-fix.service)
if [ "$IS_ENABLED" != "enabled" ]; then
  echo "Enabling oxp2p-audio-fix.service"
  systemctl enable oxp2p-audio-fix.service >/dev/null 2>&1
fi

IS_ACTIVE=$(systemctl is-active oxp2p-audio-fix.service)
if [ "$IS_ACTIVE" != "active" ]; then
  echo "Starting oxp2p-audio-fix.service"
  systemctl start oxp2p-audio-fix.service >/dev/null 2>&1
fi