#!/usr/bin/env bash
set -euo pipefail

# Disable fedora-cisco-openh264 repository
rpm-ostree ex setopt fedora-cisco-openh264.enabled=0
