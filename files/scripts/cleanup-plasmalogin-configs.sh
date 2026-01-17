#!/usr/bin/env bash
set -ex

LOG="/setup-plasmalogin.log"
echo "DEBUG: Starting cleanup-plasmalogin-configs.sh" > "$LOG"

# We are no longer aggressively deleting package files.
# The previous run showed that deleting /etc/plasmalogin.conf and 
# sysusers/tmpfiles was likely breaking the manager's ability to initialize.

echo "Verifying environment before setup..." >> "$LOG"
getent passwd plasmalogin >> "$LOG" || echo "plasmalogin not in passwd yet" >> "$LOG"

echo "Cleanup stage complete (no destructive actions taken)" >> "$LOG"
