#!/usr/bin/env bash

set -euo pipefail

# plasmalogin needs the plasmalogin user/group for authentication
# The base image may have conflicting sysusers.d files, so we need to
# ensure our configuration takes precedence

# Remove any existing plasmalogin sysusers configs that might conflict
rm -f /usr/lib/sysusers.d/*plasmalogin*.conf

# Create our plasmalogin user configuration with explicit UID/GID
cat > /usr/lib/sysusers.d/00-plasmalogin.conf << 'EOF'
# PLASMALOGIN greeter user - must be UID/GID 944
g plasmalogin 944
u plasmalogin 944:944 "PLASMALOGIN Greeter Account" /var/lib/plasmalogin /sbin/nologin
EOF

echo "Created /usr/lib/sysusers.d/00-plasmalogin.conf"
cat /usr/lib/sysusers.d/00-plasmalogin.conf

# Run systemd-sysusers to create the user
echo "Running systemd-sysusers..."
systemd-sysusers 2>&1 || true

echo "plasmalogin user setup complete"
