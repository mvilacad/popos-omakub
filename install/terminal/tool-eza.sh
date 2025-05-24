#!/bin/bash

set -e

# Function to print error messages
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

# Check if eza is already installed
if command -v eza >/dev/null 2>&1; then
  echo "eza is already installed."
else
  # Create keyrings directory if it doesn't exist
  sudo mkdir -p /etc/apt/keyrings || error_exit "Failed to create /etc/apt/keyrings"

  # Download and add the GPG key
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | \
    sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg || error_exit "Failed to add GPG key"

  # Add the eza repository
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | \
    sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null || error_exit "Failed to add repository"

  # Set correct permissions
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list || error_exit "Failed to set permissions"

  # Update package lists
  sudo apt update || error_exit "Failed to update package lists"

  # Install eza
  sudo apt install -y eza || error_exit "Failed to install eza"

  # Test the installation
  eza --version || error_exit "eza installation test failed"

  echo "eza installation completed successfully."
fi