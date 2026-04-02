#!/usr/bin/env bash
set -euo pipefail

# Download RStudio daily build
curl -L -o /tmp/rstudio.rpm "https://drive.google.com/file/d/1VLdMwfsxMCcQ93NSXhOY2iRUlBUs36l5/view?usp=sharing"

# Install it
rpm-ostree install /tmp/rstudio.rpm

# Clean up
rm -f /tmp/rstudio.rpm
