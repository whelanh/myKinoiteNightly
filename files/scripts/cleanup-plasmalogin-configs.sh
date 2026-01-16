#!/usr/bin/env bash

set -euo pipefail

# Remove all plasmalogin sysusers configs from base image
# Our config from files/system will be the only one
echo "Removing conflicting plasmalogin sysusers configs..."
find /usr/lib/sysusers.d -name "*plasma*" -type f ! -name "plasmalogin.conf" -delete

echo "Remaining plasma-related sysusers configs:"
ls -la /usr/lib/sysusers.d/*plasma* 2>/dev/null || echo "Only our plasmalogin.conf remains"
