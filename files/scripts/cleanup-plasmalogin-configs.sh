#!/usr/bin/env bash

set -euo pipefail

# Remove all plasmalogin sysusers configs from base image
# except our managed one if we had one (but we're moving away from that)
echo "Removing conflicting plasmalogin sysusers configs..."
find /usr/lib/sysusers.d -name "*plasma*" -type f -delete

# Remove any stray manager configs to ensure we use package defaults 
# unless we explicitly provide one in /etc later.
echo "Removing potential manager config conflicts..."
rm -f /etc/plasmalogin.conf
rm -f /usr/etc/plasmalogin.conf

echo "Cleanup complete"
