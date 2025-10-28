#!/usr/bin/env bash
set -euo pipefail

# Download Insync RPM (update URL to latest version)
INSYNC_URL="https://d2t3ff60b2tol4.cloudfront.net/builds/insync-3.9.6.60027-fc43.x86_64.rpm"
echo "Downloading Insync..."
curl -Lo /tmp/insync.rpm "$INSYNC_URL"

# Install the RPM
echo "Installing Insync..."
rpm-ostree install /tmp/insync.rpm

# Clean up
rm /tmp/insync.rpm
