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

# Set permissions for session scripts
if [ -f /etc/plasmalogin/wayland-session ]; then
    chmod +x /etc/plasmalogin/wayland-session
    echo "Set +x on /etc/plasmalogin/wayland-session" >> "$LOG"
fi

# Ensure /var/tmp is writable for logging
chmod 1777 /var/tmp
touch /var/tmp/plasmalogin-session.log
chown 967:967 /var/tmp/plasmalogin-session.log

# Ensure user is in necessary groups for graphics access
# Note: we use the GID/UID directly just in case the name lookup is flaky
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
