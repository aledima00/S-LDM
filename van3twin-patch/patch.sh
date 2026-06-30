#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <WORKSPACE_DIR>"
    exit 1
fi

WORKSPACE_DIR="$(realpath "$1")"

PATCH_SRC_DIR="${SCRIPT_DIR}/src"

TRACI_DEST="${WORKSPACE_DIR}/src/traci/model"
NS3_DEST="${WORKSPACE_DIR}/ns-3-dev/src/automotive/examples"

# Check for ns-3-dev installation
if [[ ! -d "${WORKSPACE_DIR}/ns-3-dev" ]]; then
    echo "WARNING: 'ns-3-dev' was not found in the provided workspace."
    echo
    echo "Please install the VAN3Twin dependencies before applying this patch."
    echo "Refer to the official GitHub documentation (https://github.com/DriveX-devs/VaN3Twin/blob/master/README.md) for the installation instructions."
    exit 1
fi

# Verify source files exist
for file in \
    "traci-client.cc" \
    "traci-client.h" \
    "v2v-simple-cam-exchange-80211p.cc"
do
    if [[ ! -f "${PATCH_SRC_DIR}/${file}" ]]; then
        echo "Error: missing patch file:"
        echo "  ${PATCH_SRC_DIR}/${file}"
        exit 1
    fi
done

echo "Applying VAN3Twin patch to workspace:"
echo "  ${WORKSPACE_DIR}"
echo

# Create destination directories if needed
mkdir -p "${TRACI_DEST}"
mkdir -p "${NS3_DEST}"

# Copy files (overwrite existing ones)
cp -f "${PATCH_SRC_DIR}/traci-client.cc" "${TRACI_DEST}/"
cp -f "${PATCH_SRC_DIR}/traci-client.h" "${TRACI_DEST}/"
cp -f "${PATCH_SRC_DIR}/v2v-simple-cam-exchange-80211p.cc" "${NS3_DEST}/"

echo "Patch applied successfully."
echo
echo "Updated files:"
echo "  - ${TRACI_DEST}/traci-client.cc"
echo "  - ${TRACI_DEST}/traci-client.h"
echo "  - ${NS3_DEST}/v2v-simple-cam-exchange-80211p.cc"