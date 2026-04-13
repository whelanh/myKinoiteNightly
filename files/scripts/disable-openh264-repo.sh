#!/usr/bin/env bash
set -euo pipefail

# Disable fedora-cisco-openh264 repository by removing its repo file
if [ -f /etc/yum.repos.d/fedora-cisco-openh264.repo ]; then
    rm -f /etc/yum.repos.d/fedora-cisco-openh264.repo
    echo "Removed fedora-cisco-openh264.repo"
fi

# Alternative: disable it in place if removal doesn't work
if [ -f /etc/yum.repos.d/fedora-cisco-openh264.repo ]; then
    sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-cisco-openh264.repo
    echo "Disabled fedora-cisco-openh264 repository"
fi
