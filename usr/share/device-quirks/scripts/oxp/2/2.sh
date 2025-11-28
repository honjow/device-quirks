#!/bin/bash

set -e

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

echo "Enabling oxp2p-audio-fix.service"
systemctl enable oxp2p-audio-fix.service >/dev/null 2>&1 || true

echo "Starting oxp2p-audio-fix.service"
systemctl start oxp2p-audio-fix.service >/dev/null 2>&1 || true
