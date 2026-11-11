PI_HOST ?= raspberrypi.local
PI_USER ?= nikhil
REMOTE_DIR ?= /home/$(PI_USER)/pi-homelab

.PHONY: help ssh copy-key sync bootstrap deploy status logs down restart

help:
	@echo "🛠️  Raspberry Pi 4 GitOps Homelab CLI"
	@echo "-----------------------------------------"
	@echo "make copy-key        - Install Mac SSH key on the Pi for passwordless login"
	@echo "make ssh             - Open interactive SSH shell into the Pi"
	@echo "make sync            - Sync local repository to the Pi via rsync"
	@echo "make bootstrap       - Run system update, Docker install & optimizations"
	@echo "make deploy          - Deploy or update all Docker services on the Pi"
	@echo "make status          - Print system metrics, CPU temp & container health"
	@echo "make logs            - Stream live logs from all containers"
	@echo "make down            - Stop all homelab services"
	@echo "make restart         - Restart all homelab services"

copy-key:
	@echo "🔑 Copying Mac SSH key to $(PI_USER)@$(PI_HOST)..."
	ssh-copy-id $(PI_USER)@$(PI_HOST)

ssh:
	ssh $(PI_USER)@$(PI_HOST)

sync:
	@echo "🔄 Syncing workspace repository to $(PI_USER)@$(PI_HOST):$(REMOTE_DIR)..."
	rsync -avz --exclude '.git' --exclude 'node_modules' ./ $(PI_USER)@$(PI_HOST):$(REMOTE_DIR)/

bootstrap: sync
	@echo "🚀 Running bootstrap on $(PI_HOST)..."
	ssh -t $(PI_USER)@$(PI_HOST) "cd $(REMOTE_DIR) && ./scripts/bootstrap.sh"

deploy: sync
	@echo "🚀 Deploying containers on $(PI_HOST)..."
	ssh -t $(PI_USER)@$(PI_HOST) "cd $(REMOTE_DIR) && ./scripts/deploy.sh"

status:
	@ssh $(PI_USER)@$(PI_HOST) "cd $(REMOTE_DIR) && ./scripts/healthcheck.sh"

logs:
	@ssh $(PI_USER)@$(PI_HOST) "cd $(REMOTE_DIR)/services && docker compose logs -f --tail=100"

down:
	@ssh $(PI_USER)@$(PI_HOST) "cd $(REMOTE_DIR)/services && docker compose down"

restart:
	@ssh $(PI_USER)@$(PI_HOST) "cd $(REMOTE_DIR)/services && docker compose restart"
