#!/bin/bash
if [ $(whoami) != 'root' ]; then
	echo "You must be root to run this script."
	exit 1
fi


echo "Adding amdgpu.dcdebugmask=0x410 to kernel options"
$DQ_PATH/scripts/kernel-options-manager --append amdgpu.dcdebugmask=0x410