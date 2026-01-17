#!/usr/bin/env bash
set -ex

LOG="/setup-plasmalogin.log"
echo "DEBUG: Starting setup-plasmalogin.sh" >> "$LOG"

TARGET_USER="plasmalogin"

# Ensure the user is "unlocked" and has an entry in the shadow file.
# We use usermod/chpasswd because they handle the backend databases correctly.
echo "Ensuring $TARGET_USER is unlocked and present in shadow..." >> "$LOG"

# 1. Force add to /etc/passwd if getent fails
if ! getent passwd "$TARGET_USER" > /dev/null; then
    echo "Adding $TARGET_USER to passwd defaults" >> "$LOG"
    echo "plasmalogin:x:967:967:PLASMALOGIN Greeter Account:/var/lib/plasmalogin:/usr/sbin/nologin" >> /etc/passwd
fi

# 2. Force add to /etc/shadow if missing or locked
# Setting the password to '!!' (locked but exists) is typical for service accounts
if ! getent shadow "$TARGET_USER" > /dev/null; then
    echo "Injecting $TARGET_USER into /etc/shadow" >> "$LOG"
    echo "plasmalogin:!!:0:0:99999:7:::" >> /etc/shadow
fi

# 3. Ensure home directory and permissions
mkdir -p /var/lib/plasmalogin
chown -R plasmalogin:plasmalogin /var/lib/plasmalogin
chmod 700 /var/lib/plasmalogin

# 4. Group memberships
for group in video render; do
  if getent group "$group" > /dev/null; then
    usermod -aG "$group" "$TARGET_USER" || true
    echo "Verified $TARGET_USER in $group group" >> "$LOG"
  fi
done

# Diagnostic check
echo "--- FINAL CHECK ---" >> "$LOG"
getent passwd "$TARGET_USER" >> "$LOG"
getent shadow "$TARGET_USER" >> "$LOG" || echo "SHADOW ENTRY STILL MISSING" >> "$LOG"

echo "setup-plasmalogin.sh completed" >> "$LOG"
