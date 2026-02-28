#!/bin/bash
# Disable all active IIO device buffers before sleep to prevent sensor
# interrupts from blocking s2idle. Restores state after resume.

STATE_DIR="/run/iio-buffer-sleep"

case "$1" in
    pre)
        mkdir -p "$STATE_DIR"
        for dev in /sys/bus/iio/devices/iio:device*/; do
            buf_file="${dev}buffer/enable"
            [ -f "$buf_file" ] || continue
            buf_state=$(cat "$buf_file" 2>/dev/null)
            [ "$buf_state" = "1" ] || continue
            dev_id=$(basename "$dev")
            echo 1 > "$STATE_DIR/$dev_id"
            echo 0 > "$buf_file" 2>/dev/null || true
            name=$(cat "${dev}name" 2>/dev/null || echo "$dev_id")
            logger -t iio-buffer-sleep "Disabled IIO buffer for $name before suspend"
        done
        ;;
    post)
        [ -d "$STATE_DIR" ] || exit 0
        for state_file in "$STATE_DIR"/iio:device*; do
            [ -f "$state_file" ] || continue
            dev_id=$(basename "$state_file")
            buf_file="/sys/bus/iio/devices/${dev_id}/buffer/enable"
            [ -f "$buf_file" ] || continue
            echo 1 > "$buf_file" 2>/dev/null || true
            name=$(cat "/sys/bus/iio/devices/${dev_id}/name" 2>/dev/null || echo "$dev_id")
            logger -t iio-buffer-sleep "Re-enabled IIO buffer for $name after resume"
        done
        rm -rf "$STATE_DIR"
        ;;
esac
