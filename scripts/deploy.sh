#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
COMPOSE_FILE="${REPO_DIR}/services/docker-compose.yml"

echo "🚀 Deploying Homelab services from ${COMPOSE_FILE}..."

cd "${REPO_DIR}/services"

# Pull latest container images
docker compose -f "${COMPOSE_FILE}" pull

# Up containers in detached mode, removing orphaned services
docker compose -f "${COMPOSE_FILE}" up -d --remove-orphans

# Clean up dangling images to keep storage clean
docker image prune -f

echo "✅ Deployment completed successfully!"
docker compose -f "${COMPOSE_FILE}" ps
