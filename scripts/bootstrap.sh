#!/usr/bin/env bash
set -euo pipefail

echo "========================================================"
echo "🍓 Initializing Raspberry Pi 4 GitOps Homelab Node"
echo "========================================================"

# 1. Update system packages
echo "📦 Updating APT package repositories..."
sudo apt-get update -y
sudo apt-get upgrade -y

# 2. Install essential tools
echo "🔧 Installing base CLI utilities..."
sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release \
  git \
  htop \
  jq \
  ufw \
  ncdu

# 3. Install Docker Engine & Docker Compose plugin
if ! command -v docker &> /dev/null; then
  echo "🐳 Installing Docker Engine from official script..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  rm -f get-docker.sh
  
  # Add current user to docker group
  sudo usermod -aG docker "$USER"
  echo "✅ Docker installed and user added to 'docker' group."
else
  echo "✅ Docker is already installed."
fi

# Ensure Docker starts on boot
sudo systemctl enable docker
sudo systemctl start docker

# 4. Storage & Performance Optimizations for 256 GB MicroSD
echo "⚡ Tuning system for long-term MicroSD endurance & performance..."

# Reduce swappiness to reduce SD card write wear
if ! grep -q "vm.swappiness=10" /etc/sysctl.conf; then
  echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
  sudo sysctl -p /etc/sysctl.conf || true
fi

# Configure Docker daemon log rotation (prevents logs from filling the 256GB card)
sudo mkdir -p /etc/docker
cat << 'DOCKER_CONF' | sudo tee /etc/docker/daemon.json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "20m",
    "max-file": "3"
  }
}
DOCKER_CONF

sudo systemctl restart docker

# 5. Create homelab root directory
echo "📁 Setting up /opt/homelab directory..."
sudo mkdir -p /opt/homelab
sudo chown -R "$USER":"$USER" /opt/homelab

echo "========================================================"
echo "🎉 Bootstrap Complete!"
echo "Node is ready to deploy Homelab Docker services."
echo "========================================================"
