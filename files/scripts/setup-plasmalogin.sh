#!/usr/bin/env bash

# plasmalogin needs the plasmalogin user/group for authentication
# Create them if they don't exist

# Create plasmalogin user configuration
cat > /usr/lib/sysusers.d/plasmalogin-user.conf << 'EOF'
g plasmalogin 944
u plasmalogin 944:944 "PLASMALOGIN Greeter Account" /var/lib/plasmalogin /usr/bin/nologin
EOF

# Run systemd-sysusers to create the user
systemd-sysusers

echo "plasmalogin user created"
