#!/usr/bin/env bash
set -ouex pipefail

# Get the latest RStudio daily build direct download URL from Posit's JSON API
RSTUDIO_URL=$(curl -s https://dailies.rstudio.com/rstudio/latest/index.json | python3 -c "
import json, sys
data = json.load(sys.stdin)
print(data['products']['electron']['platforms']['rhel9-x86_64']['link'])
")

# Download RStudio daily build
curl -fL -o /tmp/rstudio.rpm "${RSTUDIO_URL}"

# Install it
rpm-ostree install /tmp/rstudio.rpm

# Clean up
rm -f /tmp/rstudio.rpm
