#!/bin/bash
if [ $(whoami) != 'root' ]; then
    echo "You must be root to run this script."
    exit 1
fi

# add module ayaneo_platform to blacklist
echo "Add module ayaneo_platform to blacklist"
blacklist_file="${MOUNT_PATH}/etc/modprobe.d/blacklist_ayaneo.conf"
if [ -f $blacklist_file ]; then
    if ! grep -q "ayaneo_platform" $blacklist_file; then
        echo "blacklist ayaneo_platform" >>$blacklist_file
    else
        echo "blacklist ayaneo_platform" >$blacklist_file
    fi
else
    echo "blacklist ayaneo_platform" >$blacklist_file
fi
