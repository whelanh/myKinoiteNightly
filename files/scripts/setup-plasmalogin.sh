#!/usr/bin/env bash
set -ex

LOG="/setup-plasmalogin.log"
echo "DEBUG: Starting setup-plasmalogin.sh" >> "$LOG"

TARGET_USER="plasmalogin"
USER_INFO=$(getent passwd "$TARGET_USER" || true)

if [ -z "$USER_INFO" ]; then
    echo "Warning: $TARGET_USER info not found via getent, using defaults." >> "$LOG"
    USER_INFO="plasmalogin:x:967:967:PLASMALOGIN Greeter Account:/var/lib/plasmalogin:/sbin/nologin"
fi

# Dual Injection Strategy
for base in /etc /usr/etc; do
  if [ -d "$base" ]; then
    echo "Processing $base/passwd and $base/shadow" >> "$LOG"
    
    # passwd
    if ! grep -q "^$TARGET_USER:" "$base/passwd" 2>/dev/null; then
      echo "$USER_INFO" >> "$base/passwd"
      echo "Added to $base/passwd" >> "$LOG"
    else
      echo "Already in $base/passwd" >> "$LOG"
    fi
    
    # shadow
    if [ -f "$base/shadow" ]; then
      if ! grep -q "^$TARGET_USER:" "$base/shadow"; then
        echo "$TARGET_USER:!!:0:0:99999:7:::" >> "$base/shadow"
        echo "Added to $base/shadow" >> "$LOG"
      else
        echo "Already in $base/shadow" >> "$LOG"
      fi
    fi
  fi
done

# Diagnostic Dumps
for f in /etc/passwd /etc/shadow /usr/etc/passwd /usr/etc/shadow; do
  if [ -f "$f" ]; then
    echo "--- TAIL OF $f ---" >> "$LOG"
    tail -n 5 "$f" >> "$LOG"
  fi
done

# PAM Inspection
echo "Inspecting PAM configuration..." >> "$LOG"
find /etc/pam.d /usr/lib/pam.d -name "plasmalogin" -exec echo "--- {} ---" \; -exec cat {} \; -exec echo "--- END ---" \; >> "$LOG" 2>/dev/null || true

# Group Membership
for group in video render; do
  if getent group "$group" > /dev/null; then
    usermod -aG "$group" "$TARGET_USER" || true
    echo "Processed $TARGET_USER in $group group" >> "$LOG"
  fi
done

echo "setup-plasmalogin.sh completed" >> "$LOG"
