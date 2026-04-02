#!/usr/bin/env bash
set -euo pipefail

# Download RStudio daily build
curl -L -o /tmp/rstudio.rpm "https://drive.google.com/uc?export=download&id=1VLdMwfsxMCcQ93NSXhOY2iRUlBUs36l5&confirm=t"

# Install it
rpm-ostree install /tmp/rstudio.rpm

# Clean up
rm -f /tmp/rstudio.rpm
