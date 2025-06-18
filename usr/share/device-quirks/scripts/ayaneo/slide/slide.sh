#!/bin/bash

if [ $(whoami) != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

cat  << EOF > /etc/NetworkManager/conf.d/default-wifi-powersave-on.conf
[connection]
wifi.powersave = 2
EOF

# Fix abnormal restart
$DQ_PATH/scripts/kernel-options-manager --append acpi=strict
