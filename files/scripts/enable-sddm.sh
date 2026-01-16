#!/usr/bin/env bash

# Enable SDDM as the display manager
systemctl enable sddm.service

# Disable plasmalogin if it exists
if systemctl list-unit-files | grep -q plasmalogin.service; then
    systemctl disable plasmalogin.service 2>/dev/null || true
fi

echo "SDDM has been enabled as the display manager"
