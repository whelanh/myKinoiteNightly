#!/usr/bin/env bash
set -ouex pipefail

# Download RStudio daily build directly from Posit's S3 bucket
curl -fL -o /tmp/rstudio.rpm \
  "https://s3.amazonaws.com/rstudio-ide-build/electron/rhel9/x86_64/rstudio-2026.04.0-daily-465-x86_64.rpm"

# Install it
rpm-ostree install /tmp/rstudio.rpm

# Clean up
rm -f /tmp/rstudio.rpm
