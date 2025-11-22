#!/usr/bin/env bash
#
# zfs-snapshot.sh
#
# Simple helper to create ZFS snapshots for a given pool or dataset.
# Snapshots are named like: <dataset>@auto-YYYYmmdd-HHMMSS
#
# Example:
#   ./zfs-snapshot.sh tank/data
#
# Optional: set RETENTION_DAYS to automatically delete older snapshots.

set -euo pipefail

RETENTION_DAYS="${RETENTION_DAYS:-7}"   # default: keep 7 days of snapshots

usage() {
  echo "Usage: $0 <pool/dataset>"
  echo
  echo "Environment variables:"
  echo "  RETENTION_DAYS   Number of days to keep snapshots (default: ${RETENTION_DAYS})"
  exit 1
}

if [[ "${1-}" == "" ]]; then
  usage
fi

DATASET="$1"

# check if dataset exists
if ! zfs list -H -o name "${DATASET}" >/dev/null 2>&1; then
  echo "ERROR: ZFS dataset '${DATASET}' not found."
  exit 1
fi

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
SNAP_NAME="${DATASET}@auto-${TIMESTAMP}"

echo "Creating snapshot: ${SNAP_NAME}"
zfs snapshot "${SNAP_NAME}"

echo "Snapshot created."

# cleanup old snapshots
if [[ "${RETENTION_DAYS}" -gt 0 ]]; then
  echo "Cleaning up snapshots older than ${RETENTION_DAYS} days for dataset ${DATASET}..."
  zfs list -H -t snapshot -o name,creation -s creation | \
    awk -v ds="${DATASET}" -v days="${RETENTION_DAYS}" '
      $1 ~ "^"ds"@auto-" {
        cmd = "date -d \""$2\" \"$3"\" +%s"
        cmd | getline snap_ts
        close(cmd)

        now = systime()
        age_days = (now - snap_ts) / 86400
        if (age_days > days) {
          print $1
        }
      }
    ' | while read -r old_snap; do
      echo "  Destroying old snapshot: ${old_snap}"
      zfs destroy "${old_snap}"
    done
fi

echo "Done."