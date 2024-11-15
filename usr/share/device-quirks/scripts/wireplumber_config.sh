#!/bin/bash

set -e

# Check for root
if [ "$(whoami)" != 'root' ]; then
  echo "You must be root to run this script."
  exit 1
fi

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <source> <destination>"
  exit 1
fi

WIREPLUMBER_SRC=$1
WIREPLUMBER_DST=$2


# Check if the WirePlumber conf exists
if [[ -n $(ls -A "${WIREPLUMBER_SRC}/"*.conf) ]]; then
  echo "Installing WirePlumber config from ${WIREPLUMBER_SRC} to ${WIREPLUMBER_DST}"
  if [[ ! -d "${WIREPLUMBER_DST}" ]]; then
    mkdir -p "${WIREPLUMBER_DST}"
  fi

  if [[ -n $(ls -A "${WIREPLUMBER_DST}/"*.conf) ]]; then
    echo "Removing existing WirePlumber configuration files"
    rm -r "${WIREPLUMBER_DST}/"*.conf
  fi

  # Copy the WirePlumber conf to /etc
  cp "${WIREPLUMBER_SRC}/"*.conf "${WIREPLUMBER_DST}/"
  echo "WirePlumber configuration successfully copied to ${WIREPLUMBER_DST}"
else
  echo "WirePlumber config not found at ${WIREPLUMBER_SRC}"
  exit 1
fi