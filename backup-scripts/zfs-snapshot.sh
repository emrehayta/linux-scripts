#!/usr/bin/env bash
set -euo pipefail

########################################
# ZFS Snapshot Automation Script
#
# - Creates snapshots for one or more datasets
# - Uses a simple naming convention: <dataset>@<prefix>-<timestamp>
# - Deletes old snapshots based on a retention window (in days)
#
# Requirements:
# - Linux with ZFS tools installed
# - `date` with `-d` support (e.g. GNU date)
########################################

# --- Configuration ----------------------------------------------------------

# List of ZFS datasets to snapshot
DATASETS=(
  "tank/data"
  "tank/vms"
)

# How many days snapshots should be kept
RETENTION_DAYS=7

# Prefix for automatically created snapshots
SNAPSHOT_PREFIX="auto"

# --- Implementation ---------------------------------------------------------

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

for dataset in "${DATASETS[@]}"; do
    SNAPSHOT_NAME="${dataset}@${SNAPSHOT_PREFIX}-${TIMESTAMP}"
    echo "[INFO] Creating snapshot: ${SNAPSHOT_NAME}"
    zfs snapshot "${SNAPSHOT_NAME}"

    echo "[INFO] Cleaning up old snapshots for dataset: ${dataset}"
    # List snapshots for this dataset with the configured prefix, oldest first
    zfs list -H -t snapshot -o name -s creation | grep "^${dataset}@${SNAPSHOT_PREFIX}-" | while read -r SNAP; do
        CREATION_STR=$(zfs get -H -o value creation "$SNAP")
        SNAP_TS=$(date -d "$CREATION_STR" +%s)
        CUTOFF_TS=$(date -d "${RETENTION_DAYS} days ago" +%s)

        if (( SNAP_TS < CUTOFF_TS )); then
            echo "[CLEANUP] Destroying old snapshot: $SNAP"
            zfs destroy "$SNAP"
        fi
    done
done
