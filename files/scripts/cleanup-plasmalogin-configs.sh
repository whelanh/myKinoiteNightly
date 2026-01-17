#!/usr/bin/env bash
set -ex

echo "DEBUG: Starting cleanup-plasmalogin-configs.sh" >> /setup-plasmalogin.log

# Remove all plasmalogin sysusers configs from base image
# except our managed one if we had one (but we're moving away from that)
echo "Removing conflicting plasmalogin sysusers configs..." >> /setup-plasmalogin.log
find /usr/lib/sysusers.d -name "*plasma-login-manager*" -type f -delete
find /usr/lib/sysusers.d -name "*plasmalogin*" -type f -delete

# Remove any stray manager configs to ensure we use package defaults 
# unless we explicitly provide one in /etc later.
echo "Removing potential manager config conflicts..." >> /setup-plasmalogin.log
rm -f /etc/plasmalogin.conf
rm -f /usr/etc/plasmalogin.conf

echo "Cleanup complete" >> /setup-plasmalogin.log
