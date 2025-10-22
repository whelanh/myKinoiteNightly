#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!
set -oue pipefail

# Your code goes here.
echo 'Installing Homebrew...'
# Install Homebrew during image build
curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh" 
echo 'if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; fi' >> /etc/bashrc && \
echo 'if [ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]; then eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"; fi' >> /etc/zshrc
