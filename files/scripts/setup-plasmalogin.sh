#!/usr/bin/env bash

set -euo pipefail

# plasmalogin needs the plasmalogin user/group for authentication
# The base image may have conflicting sysusers.d files, so we need to
# ensure our configuration takes precedence

# Remove any existing plasmalogin sysusers configs that might conflict
rm -f /usr/lib/sysusers.d/*plasmalogin*.conf

# Extract the existing plasmalogin user info if it exists (e.g. from /usr/lib/passwd)
# and ensure it's in /etc/passwd and /etc/shadow so PAM can find it.
# This fixes "Authentication service cannot retrieve authentication info".

echo "Ensuring plasmalogin user is in /etc/passwd and /etc/shadow..."
if ! grep -q "^plasmalogin:" /etc/passwd; then
    getent passwd plasmalogin >> /etc/passwd || echo "plasmalogin:x:967:967:PLASMALOGIN Greeter Account:/var/lib/plasmalogin:/sbin/nologin" >> /etc/passwd
fi

if ! grep -q "^plasmalogin:" /etc/shadow; then
    echo "plasmalogin:!!:0:0:99999:7:::" >> /etc/shadow
fi

# Ensure home directory exists and has correct permissions
mkdir -p /var/lib/plasmalogin
chown -R plasmalogin:plasmalogin /var/lib/plasmalogin
chmod 700 /var/lib/plasmalogin

# Ensure user is in necessary groups for graphics access
usermod -aG video,render plasmalogin || true

echo "plasmalogin user setup and PAM integration complete"
