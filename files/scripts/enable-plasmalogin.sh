#!/usr/bin/env bash

# Enable plasmalogin as the display manager
systemctl enable plasmalogin.service

# Disable sddm if it exists
if systemctl list-unit-files | grep -q sddm.service; then
    systemctl disable sddm.service 2>/dev/null || true
fi

echo "plasmalogin has been enabled as the display manager"
