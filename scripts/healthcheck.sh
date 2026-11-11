#!/usr/bin/env bash
set -euo pipefail

echo "========================================================"
echo "📊 Raspberry Pi 4 Homelab Node Status"
echo "========================================================"

# Hostname & Uptime
echo -n "🕒 Uptime: "
uptime -p

# CPU Temperature
if [ -f /sys/class/thermal/thermal_zone0/temp ]; then
  raw_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
  cpu_temp=$(echo "scale=1; $raw_temp / 1000" | bc 2>/dev/null || awk "BEGIN {printf \"%.1f\", $raw_temp/1000}")
  echo "🌡️  CPU Temperature: ${cpu_temp}°C"
fi

# Memory & Swap
echo -e "\n💾 Memory Usage:"
free -h

# Disk Space (256 GB SD Card)
echo -e "\n💽 Disk Space (Root /):"
df -h / | awk 'NR==1 || NR==2'

# Running Containers
echo -e "\n🐳 Docker Containers:"
if command -v docker &> /dev/null; then
  docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
else
  echo "Docker is not installed yet."
fi

echo -e "\n🌐 Network IP Address:"
hostname -I | awk '{print $1}'

echo "========================================================"
