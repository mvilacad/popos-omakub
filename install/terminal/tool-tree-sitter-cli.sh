#!/bin/bash

set -e

# Get the latest release tag
LATEST=$(curl -s https://api.github.com/repos/tree-sitter/tree-sitter/releases/latest | grep "tag_name" | cut -d '"' -f4)

# Build the release file name
FILENAME="tree-sitter-linux-x64.gz"

# Download the compressed binary
curl -L -o $FILENAME "https://github.com/tree-sitter/tree-sitter/releases/download/${LATEST}/${FILENAME}"

# Decompress
gunzip -f $FILENAME

# Make it executable
chmod +x tree-sitter-linux-x64
# Move to /usr/local/bin (may require sudo)
sudo mv tree-sitter-linux-x64 /usr/local/bin/tree-sitter

# Test the installation
tree-sitter --version >/dev/null
