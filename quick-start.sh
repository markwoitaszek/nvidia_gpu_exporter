#!/bin/bash

# Quick start script for RTX 3090 monitoring with nvidia_gpu_exporter
# This script sets up the complete monitoring stack

set -e

echo "🚀 Setting up NVIDIA GPU monitoring for RTX 3090..."

# Check if nvidia-smi is available
if ! command -v nvidia-smi &> /dev/null; then
    echo "❌ nvidia-smi not found. Please install NVIDIA drivers first."
    exit 1
fi

echo "✅ nvidia-smi found: $(nvidia-smi --version | head -n1)"

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker first."
    exit 1
fi

echo "✅ Docker found: $(docker --version)"

# Create necessary directories
echo "📁 Creating directories..."
mkdir -p prometheus/data prometheus/config grafana/data grafana/provisioning

# Copy Prometheus configuration
echo "⚙️  Setting up Prometheus configuration..."
cp prometheus-complete.yml prometheus/config/prometheus.yml
cp gpu_alerts.yml prometheus/config/

# Make scripts executable
chmod +x install-systemd.sh

echo "🐳 Starting monitoring stack with Docker Compose..."
docker-compose -f docker-compose-complete.yml up -d

echo "⏳ Waiting for services to start..."
sleep 10

# Check if services are running
echo "🔍 Checking service status..."
docker-compose -f docker-compose-complete.yml ps

echo ""
echo "🎉 Setup complete! Your monitoring stack is running:"
echo "📊 Prometheus: http://localhost:9090"
echo "📈 Grafana: http://localhost:3000 (admin/admin)"
echo "🔧 GPU Metrics: http://localhost:9835/metrics"
echo ""
echo "📋 Next steps:"
echo "1. Open Grafana at http://localhost:3000"
echo "2. Login with admin/admin"
echo "3. Import dashboard ID: 14574"
echo "4. Configure Prometheus as data source: http://prometheus:9090"
echo ""
echo "🔍 To check GPU metrics directly:"
echo "curl http://localhost:9835/metrics | grep nvidia_smi"
