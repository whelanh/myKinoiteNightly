#!/usr/bin/env bash
set -ex

LOG="/setup-plasmalogin.log"
echo "DEBUG: Starting setup-plasmalogin.sh" >> "$LOG"

TARGET_USER="plasmalogin"

# Ensure home directory exists with correct permissions
echo "Setting up home directory..." >> "$LOG"
mkdir -p /var/lib/plasmalogin
chown -R 967:967 /var/lib/plasmalogin
chmod 700 /var/lib/plasmalogin

# Ensure user is in necessary groups for graphics access
for group in video render; do
  if getent group "$group" > /dev/null; then
    usermod -aG "$group" "$TARGET_USER" || true
    echo "Verified $TARGET_USER in $group group" >> "$LOG"
  fi
done

# Diagnostic check
echo "--- SYSTEM STATE AT END OF BUILD ---" >> "$LOG"
getent passwd "$TARGET_USER" >> "$LOG" || echo "User missing in passwd" >> "$LOG"
getent shadow "$TARGET_USER" >> "$LOG" || echo "User missing in shadow" >> "$LOG"

echo "setup-plasmalogin.sh completed" >> "$LOG"
