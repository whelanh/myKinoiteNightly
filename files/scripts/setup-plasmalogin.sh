#!/usr/bin/env bash

# plasmalogin needs the sddm user/group for authentication
# Create them if they don't exist

# Create sddm user configuration
cat > /usr/lib/sysusers.d/plasmalogin-sddm.conf << 'EOF'
u sddm - "Simple Desktop Display Manager" /var/lib/sddm
EOF

# Run systemd-sysusers to create the user
systemd-sysusers

echo "SDDM user created for plasmalogin compatibility"
