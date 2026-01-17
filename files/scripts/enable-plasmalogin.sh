#!/usr/bin/env bash
set -ex

LOG="/setup-plasmalogin.log"
echo "DEBUG: Starting enable-plasmalogin.sh" >> "$LOG"

# Enable plasmalogin as the display manager
systemctl enable plasmalogin.service

# Force the display-manager.service symlink manually as a fallback
ln -sf /usr/lib/systemd/system/plasmalogin.service /etc/systemd/system/display-manager.service

# Disable sddm if it exists
if systemctl list-unit-files | grep -q sddm.service; then
    systemctl disable sddm.service 2>/dev/null || true
fi

echo "plasmalogin has been enabled as the display manager" >> "$LOG"
