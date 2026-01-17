#!/usr/bin/env bash
set -ex

echo "DEBUG: Starting setup-plasmalogin.sh" > /setup-plasmalogin.log

# Ensure plasmalogin user is in /etc/passwd and /etc/shadow for PAM support
# We extract the info from the system (even if it's currently only in /usr/lib/passwd)
# and force it into the /etc files that PAM modules like pam_unix expect.

TARGET_USER="plasmalogin"
USER_INFO=$(getent passwd "$TARGET_USER" || true)

if [ -z "$USER_INFO" ]; then
    echo "Warning: $TARGET_USER info not found via getent, using defaults." >> /setup-plasmalogin.log
    USER_INFO="plasmalogin:x:967:967:PLASMALOGIN Greeter Account:/var/lib/plasmalogin:/sbin/nologin"
fi

echo "Adding $TARGET_USER to /etc/passwd if missing" >> /setup-plasmalogin.log
if ! grep -q "^$TARGET_USER:" /etc/passwd; then
  echo "$USER_INFO" >> /etc/passwd
  echo "Successfully added to /etc/passwd" >> /setup-plasmalogin.log
fi

echo "Adding $TARGET_USER to /etc/shadow if missing" >> /setup-plasmalogin.log
if ! grep -q "^$TARGET_USER:" /etc/shadow; then
  # UID:password:lastchanged:min:max:warn:inactive:expire:reserved
  # '!!' means no password set (standard for service accounts)
  echo "$TARGET_USER:!!:0:0:99999:7:::" >> /etc/shadow
  echo "Successfully added to /etc/shadow" >> /setup-plasmalogin.log
fi

# Ensure home directory exists and has correct permissions
mkdir -p /var/lib/plasmalogin
chown -R plasmalogin:plasmalogin /var/lib/plasmalogin
chmod 700 /var/lib/plasmalogin

# Ensure user is in necessary groups for graphics access
# These often need to be in /etc/group as well for standard lookup
for group in video render; do
  if getent group "$group" > /dev/null; then
    usermod -aG "$group" "$TARGET_USER" || true
    echo "Added $TARGET_USER to $group group" >> /setup-plasmalogin.log
  fi
done

echo "setup-plasmalogin.sh completed" >> /setup-plasmalogin.log
