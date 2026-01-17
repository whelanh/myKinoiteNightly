#!/usr/bin/env bash

set -euo pipefail

# Remove all plasmalogin sysusers configs from base image
# Our config from files/system will be the only one
echo "Removing conflicting plasmalogin sysusers configs..."
find /usr/lib/sysusers.d -name "*plasma*" -type f ! -name "plasmalogin.conf" -delete

# Also check for config files in /etc that shouldn't be there
if [ -f /etc/plasmalogin.conf ]; then
    echo "Found /etc/plasmalogin.conf - checking if it contains sysusers entries"
    if grep -q "^u " /etc/plasmalogin.conf || grep -q "^g " /etc/plasmalogin.conf; then
        echo "Warning: /etc/plasmalogin.conf appears to be a sysusers file! Removing it."
        rm -f /etc/plasmalogin.conf
    fi
fi

echo "Remaining plasma-related sysusers configs:"
ls -la /usr/lib/sysusers.d/*plasma* 2>/dev/null || echo "Only our plasmalogin.conf remains"
