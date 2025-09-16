#!/bin/bash

# Installation script for nvidia_gpu_exporter as systemd service
# For RTX 3090 monitoring setup

set -e

echo "Installing nvidia_gpu_exporter as systemd service..."

# Download latest binary
VERSION="1.3.1"
ARCH="linux_x86_64"
BINARY_NAME="nvidia_gpu_exporter"

echo "Downloading nvidia_gpu_exporter v${VERSION}..."
wget -O /tmp/nvidia_gpu_exporter.tar.gz \
  "https://github.com/utkuozdemir/nvidia_gpu_exporter/releases/download/v${VERSION}/nvidia_gpu_exporter_${VERSION}_${ARCH}.tar.gz"

# Extract and install binary
echo "Installing binary..."
tar -xzf /tmp/nvidia_gpu_exporter.tar.gz -C /tmp
sudo mv /tmp/nvidia_gpu_exporter /usr/bin/
sudo chmod +x /usr/bin/nvidia_gpu_exporter

# Create system user
echo "Creating system user..."
sudo useradd --system --no-create-home --shell /usr/sbin/nologin nvidia_gpu_exporter || true

# Install systemd service
echo "Installing systemd service..."
sudo cp systemd/nvidia_gpu_exporter.service /etc/systemd/system/

# Reload systemd and enable service
echo "Enabling service..."
sudo systemctl daemon-reload
sudo systemctl enable nvidia_gpu_exporter
sudo systemctl start nvidia_gpu_exporter

# Check status
echo "Checking service status..."
sudo systemctl status nvidia_gpu_exporter --no-pager

echo "Installation complete!"
echo "Metrics available at: http://localhost:9835/metrics"
echo "Service status: sudo systemctl status nvidia_gpu_exporter"
