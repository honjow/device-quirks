#!/bin/bash
# Rebind xHCI controller on resume to recover the gamepad on OXP Apex.
# PCI device 0000:65:00.4 is the xHCI controller connected to the gamepad.
# Based on xpad-fix3 from the Korean OXP community.

case "$1" in
    post)
        PRODUCT_NAME="$(cat /sys/class/dmi/id/product_name 2>/dev/null)"
        [ "$PRODUCT_NAME" = "ONEXPLAYER APEX" ] || exit 0

        XHCI_PCI="0000:65:00.4"
        DRIVER_PATH="/sys/bus/pci/devices/$XHCI_PCI/driver"

        sleep 1
        if [ -e "$DRIVER_PATH" ]; then
            echo "$XHCI_PCI" > "$DRIVER_PATH/unbind" 2>/dev/null
            sleep 0.5
        fi
        echo "$XHCI_PCI" > /sys/bus/pci/drivers/xhci_hcd/bind 2>/dev/null

        logger -t oxp-apex-resume "Gamepad recovery: xHCI controller rebound"
        ;;
esac
