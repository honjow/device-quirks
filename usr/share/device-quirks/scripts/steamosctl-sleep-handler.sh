#!/bin/bash

# TDP config file location
TDP_CONFIG="${XDG_RUNTIME_DIR:-/run/user/$UID}/.steamosctl-tdp.conf"

save_tdp() {
    if command -v steamosctl >/dev/null 2>&1; then
        # Get current TDP limit
        tdp_limit=$(steamosctl get-tdp-limit 2>/dev/null | grep "TDP limit" | awk '{print $3}')
        if [ -n "$tdp_limit" ]; then
            echo "$tdp_limit" > "$TDP_CONFIG"
            logger -t steamosctl-sleep "Saved TDP config: $tdp_limit"
        else
            logger -t steamosctl-sleep "Failed to get TDP limit"
        fi
    fi
}

restore_tdp() {
    if [ -f "$TDP_CONFIG" ]; then
        tdp_limit=$(cat "$TDP_CONFIG")
        if [ -n "$tdp_limit" ] && command -v steamosctl >/dev/null 2>&1; then
            logger -t steamosctl-sleep "Target TDP: $tdp_limit"
            
            # Optimized strategy: Total time window ~4 seconds
            # Based on observation: system restores default within 0-3 seconds
            
            # Wait 2 seconds for system to restore default (if it will)
            sleep 2
            current_tdp=$(steamosctl get-tdp-limit 2>/dev/null | grep "TDP limit" | awk '{print $3}')
            logger -t steamosctl-sleep "TDP at +2s: $current_tdp"
            
            # If already at target, skip restore
            if [ "$current_tdp" = "$tdp_limit" ]; then
                logger -t steamosctl-sleep "TDP already correct, done"
                rm -f "$TDP_CONFIG"
                return 0
            fi
            
            # Restore immediately
            steamosctl set-tdp-limit "$tdp_limit" >/dev/null 2>&1
            logger -t steamosctl-sleep "Restored: $current_tdp -> $tdp_limit"
            
            # Quick verify after 2 seconds
            sleep 2
            final_tdp=$(steamosctl get-tdp-limit 2>/dev/null | grep "TDP limit" | awk '{print $3}')
            
            if [ "$final_tdp" != "$tdp_limit" ]; then
                # System overrode again, one final attempt
                logger -t steamosctl-sleep "Override detected ($final_tdp), final restore"
                steamosctl set-tdp-limit "$tdp_limit" >/dev/null 2>&1
                logger -t steamosctl-sleep "Done"
            else
                logger -t steamosctl-sleep "Stable at $final_tdp"
            fi
            
            # Total: 2 + 2 = ~4 seconds, then user is free to adjust
        fi
        rm -f "$TDP_CONFIG"
    else
        logger -t steamosctl-sleep "No TDP config found"
    fi
}

monitor_sleep() {
    # Monitor sleep/resume events using systemd-inhibit
    logger -t steamosctl-sleep "Started monitoring sleep events"
    
    # Use dbus-monitor to watch for sleep signals
    dbus-monitor --system "type='signal',interface='org.freedesktop.login1.Manager',member='PrepareForSleep'" 2>/dev/null | \
    while read -r line; do
        if echo "$line" | grep -q "boolean true"; then
            logger -t steamosctl-sleep "Detected sleep event"
            save_tdp
        elif echo "$line" | grep -q "boolean false"; then
            logger -t steamosctl-sleep "Detected resume event"
            restore_tdp
        fi
    done
}

case "$1" in
    save)
        save_tdp
        ;;
    restore)
        restore_tdp
        ;;
    monitor)
        monitor_sleep
        ;;
    *)
        echo "Usage: $0 {save|restore|monitor}"
        exit 1
        ;;
esac
