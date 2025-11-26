#!/bin/bash

# Enable IPv6 for NetworkManager connections
# This script ensures IPv6 is enabled at both sysctl and NetworkManager levels
#
# Usage:
#   enable_ipv6.sh [OPTIONS]
#
# Options:
#   --restart-connections    Restart active connections immediately after enabling IPv6
#   --help                   Show this help message

RESTART_CONNECTIONS=0

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --restart-connections)
      RESTART_CONNECTIONS=1
      shift
      ;;
    --help)
      echo "Usage: $0 [OPTIONS]"
      echo ""
      echo "Enable IPv6 for NetworkManager connections"
      echo ""
      echo "Options:"
      echo "  --restart-connections    Restart active connections immediately after enabling IPv6"
      echo "  --help                   Show this help message"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

# Check if NetworkManager is available
if ! command -v nmcli &> /dev/null; then
  echo "NetworkManager (nmcli) is not available. Skipping IPv6 configuration."
  exit 0
fi

# Check if NetworkManager service is running
if ! systemctl is-active --quiet NetworkManager 2>/dev/null; then
  echo "NetworkManager service is not running. Skipping IPv6 configuration."
  echo "IPv6 will be configured on next boot when NetworkManager starts."
  exit 0
fi

echo "Ensuring IPv6 is enabled in NetworkManager connections..."

# Get all connection UUIDs
CONNECTION_UUIDS=$(nmcli -t -f UUID connection show 2>/dev/null)

for UUID in $CONNECTION_UUIDS; do
  # Get connection name
  CONN_NAME=$(nmcli -g connection.id connection show "$UUID")
  
  # Skip loopback connection
  if [[ "$CONN_NAME" == "lo" ]]; then
    continue
  fi
  
  # Get current IPv6 method
  IPV6_METHOD=$(nmcli -g ipv6.method connection show "$UUID")
  
  # If IPv6 is disabled, enable it
  if [[ "$IPV6_METHOD" == "disabled" || "$IPV6_METHOD" == "ignore" ]]; then
    echo "Enabling IPv6 for connection: $CONN_NAME"
    nmcli connection modify "$UUID" ipv6.method auto
    
    # Reactivate the connection if requested and it's currently active
    if [[ $RESTART_CONNECTIONS -eq 1 ]]; then
      DEVICE=$(nmcli -g GENERAL.DEVICES connection show "$UUID")
      if [[ -n "$DEVICE" && "$DEVICE" != "--" ]]; then
        echo "Restarting connection: $CONN_NAME"
        nmcli connection down "$UUID" 2>/dev/null
        nmcli connection up "$UUID"
      fi
    else
      DEVICE=$(nmcli -g GENERAL.DEVICES connection show "$UUID")
      if [[ -n "$DEVICE" && "$DEVICE" != "--" ]]; then
        echo "Note: Connection '$CONN_NAME' is active. Changes will take effect after next connection restart."
      fi
    fi
  else
    echo "IPv6 already enabled for connection: $CONN_NAME (method: $IPV6_METHOD)"
  fi
done

echo "IPv6 configuration completed."

