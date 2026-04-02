#!/usr/bin/env bash
set -ouex pipefail

# Import Posit's GPG signing key
rpm --import https://cdn.posit.co/signing-key/posit-signing-key-public.asc

# Get the latest RStudio daily build URL for RHEL9 x86_64
RSTUDIO_URL=$(curl -fsSL "https://dailies.rstudio.com/rstudio/latest/index.json" | \
  python3 -c "import sys,json; d=json.load(sys.stdin); print(d['products']['electron']['platforms']['rhel9-x86_64']['link'])")

# Download RStudio daily build
curl -fL -o /tmp/rstudio.rpm "$RSTUDIO_URL"

# Install it
dnf install -y /tmp/rstudio.rpm

# Clean up
rm -f /tmp/rstudio.rpm
