.PHONY: help build start stop restart logs clean check ssl

# Barvy pro výstup
RED=\033[0;31m
GREEN=\033[0;32m
YELLOW=\033[1;33m
BLUE=\033[0;34m
NC=\033[0m # No Color

help: ## Zobrazí nápovědu
	@echo "$(BLUE)═══════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  Bybit Multi-Dashboard - Makefile Commands$(NC)"
	@echo "$(BLUE)═══════════════════════════════════════════════$(NC)"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(YELLOW)%-15s$(NC) %s\n", $$1, $$2}'
	@echo ""

check: ## Zkontroluje konfiguraci
	@echo "$(BLUE)🔍 Kontroluji konfiguraci...$(NC)"
	@./check-config.sh

ssl: ## Vygeneruje self-signed SSL certifikát (pro testování)
	@echo "$(BLUE)🔐 Generuji SSL certifikát...$(NC)"
	@mkdir -p nginx/ssl
	@cd nginx/ssl && openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout privkey.pem \
		-out fullchain.pem \
		-subj "/C=CZ/ST=Prague/L=Prague/O=Dev/CN=*.ppanchov-takserver.eu" 2>/dev/null
	@echo "$(GREEN)✅ SSL certifikát vygenerován$(NC)"

ssl-prod: ## Vygeneruje produkční SSL pomocí Let's Encrypt (vyžaduje sudo)
	@echo "$(BLUE)🔐 Generuji Let's Encrypt certifikát...$(NC)"
	@echo "$(YELLOW)Vyžaduje sudo práva a zastavení nginx$(NC)"
	@sudo certbot certonly --standalone \
		-d dashboard1.ppanchov-takserver.eu \
		-d dashboard2.ppanchov-takserver.eu \
		-d dashboard3.ppanchov-takserver.eu
	@sudo cp /etc/letsencrypt/live/dashboard1.ppanchov-takserver.eu/fullchain.pem nginx/ssl/
	@sudo cp /etc/letsencrypt/live/dashboard1.ppanchov-takserver.eu/privkey.pem nginx/ssl/
	@sudo chmod 644 nginx/ssl/*.pem
	@echo "$(GREEN)✅ Produkční SSL certifikát nainstalován$(NC)"

build: ## Build Docker obrazy
	@echo "$(BLUE)🔨 Builduji Docker obrazy...$(NC)"
	@docker compose build
	@echo "$(GREEN)✅ Build dokončen$(NC)"

rebuild: ## Rebuild Docker obrazy (bez cache)
	@echo "$(BLUE)🔨 Rebuilduji Docker obrazy (no cache)...$(NC)"
	@docker compose build --no-cache
	@echo "$(GREEN)✅ Rebuild dokončen$(NC)"

start: ## Spustí všechny služby
	@echo "$(BLUE)🚀 Spouštím služby...$(NC)"
	@docker compose up -d
	@sleep 3
	@echo ""
	@echo "$(GREEN)✅ Služby spuštěny!$(NC)"
	@echo ""
	@echo "$(BLUE)Přístup:$(NC)"
	@echo "  Dashboard 1: $(YELLOW)http://localhost:5001$(NC)"
	@echo "  Dashboard 2: $(YELLOW)http://localhost:5002$(NC)"
	@echo "  Dashboard 3: $(YELLOW)http://localhost:5003$(NC)"
	@echo ""
	@echo "  HTTPS (pokud je SSL nakonfigurováno):"
	@echo "  Dashboard 1: $(YELLOW)https://dashboard1.ppanchov-takserver.eu$(NC)"
	@echo "  Dashboard 2: $(YELLOW)https://dashboard2.ppanchov-takserver.eu$(NC)"
	@echo "  Dashboard 3: $(YELLOW)https://dashboard3.ppanchov-takserver.eu$(NC)"
	@echo ""

stop: ## Zastaví všechny služby
	@echo "$(BLUE)🛑 Zastavuji služby...$(NC)"
	@docker compose down
	@echo "$(GREEN)✅ Služby zastaveny$(NC)"

restart: ## Restartuje všechny služby
	@echo "$(BLUE)🔄 Restartuji služby...$(NC)"
	@docker compose restart
	@echo "$(GREEN)✅ Služby restartovány$(NC)"

restart-1: ## Restartuje Dashboard 1
	@echo "$(BLUE)🔄 Restartuji Dashboard 1...$(NC)"
	@docker compose restart futuresboard1
	@echo "$(GREEN)✅ Dashboard 1 restartován$(NC)"

restart-2: ## Restartuje Dashboard 2
	@echo "$(BLUE)🔄 Restartuji Dashboard 2...$(NC)"
	@docker compose restart futuresboard2
	@echo "$(GREEN)✅ Dashboard 2 restartován$(NC)"

restart-3: ## Restartuje Dashboard 3
	@echo "$(BLUE)🔄 Restartuji Dashboard 3...$(NC)"
	@docker compose restart futuresboard3
	@echo "$(GREEN)✅ Dashboard 3 restartován$(NC)"

restart-nginx: ## Restartuje Nginx
	@echo "$(BLUE)🔄 Restartuji Nginx...$(NC)"
	@docker compose restart nginx
	@echo "$(GREEN)✅ Nginx restartován$(NC)"

logs: ## Zobrazí logy všech služeb
	@docker compose logs -f

logs-1: ## Zobrazí logy Dashboard 1
	@docker compose logs -f futuresboard1

logs-2: ## Zobrazí logy Dashboard 2
	@docker compose logs -f futuresboard2

logs-3: ## Zobrazí logy Dashboard 3
	@docker compose logs -f futuresboard3

logs-nginx: ## Zobrazí logy Nginx
	@docker compose logs -f nginx

status: ## Zobrazí status služeb
	@echo "$(BLUE)📊 Status služeb:$(NC)"
	@docker compose ps

shell-1: ## Otevře shell v Dashboard 1
	@docker compose exec futuresboard1 /bin/bash

shell-2: ## Otevře shell v Dashboard 2
	@docker compose exec futuresboard2 /bin/bash

shell-3: ## Otevře shell v Dashboard 3
	@docker compose exec futuresboard3 /bin/bash

clean: ## Vyčistí data a zastaví služby
	@echo "$(RED)⚠️  Tato akce smaže všechny databáze!$(NC)"
	@read -p "Pokračovat? [y/N] " -n 1 -r; \
	echo; \
	if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
		echo "$(BLUE)🧹 Čistím...$(NC)"; \
		docker compose down -v; \
		rm -rf data1/* data2/* data3/*; \
		echo "$(GREEN)✅ Vyčištěno$(NC)"; \
	else \
		echo "$(YELLOW)Zrušeno$(NC)"; \
	fi

clean-all: clean ## Vyčistí vše včetně Docker obrazů
	@echo "$(BLUE)🧹 Mažu Docker obrazy...$(NC)"
	@docker compose down --rmi all -v
	@echo "$(GREEN)✅ Vše vyčištěno$(NC)"

update: ## Aktualizuje a restartuje (po změnách v kódu)
	@echo "$(BLUE)🔄 Aktualizuji...$(NC)"
	@docker compose build
	@docker compose up -d
	@echo "$(GREEN)✅ Aktualizováno a restartováno$(NC)"

test: check ## Otestuje konfiguraci
	@echo "$(BLUE)🧪 Testuji konfiguraci...$(NC)"
	@./check-config.sh

install: check ssl build start ## Kompletní instalace (kontrola + SSL + build + start)
	@echo ""
	@echo "$(GREEN)═══════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)✅ Instalace dokončena!$(NC)"
	@echo "$(GREEN)═══════════════════════════════════════════════$(NC)"

quick: ## Rychlý start (bez kontrol)
	@./start.sh

# Firewall
firewall: ## Nastaví firewall (vyžaduje sudo)
	@echo "$(BLUE)🔥 Nastavuji firewall...$(NC)"
	@sudo ufw allow 80/tcp
	@sudo ufw allow 443/tcp
	@sudo ufw --force enable
	@echo "$(GREEN)✅ Firewall nastaven$(NC)"

# Certifikáty - auto obnova
ssl-renew: ## Obnoví SSL certifikát (Let's Encrypt)
	@echo "$(BLUE)🔐 Obnovuji SSL certifikát...$(NC)"
	@sudo certbot renew
	@sudo cp /etc/letsencrypt/live/dashboard1.ppanchov-takserver.eu/fullchain.pem nginx/ssl/
	@sudo cp /etc/letsencrypt/live/dashboard1.ppanchov-takserver.eu/privkey.pem nginx/ssl/
	@sudo chmod 644 nginx/ssl/*.pem
	@docker compose restart nginx
	@echo "$(GREEN)✅ SSL certifikát obnoven$(NC)"

# Backup
backup: ## Zálohuje databáze
	@echo "$(BLUE)💾 Zálohuji databáze...$(NC)"
	@mkdir -p backups
	@tar -czf backups/backup-$$(date +%Y%m%d-%H%M%S).tar.gz data1/ data2/ data3/ config/
	@echo "$(GREEN)✅ Záloha vytvořena v backups/$(NC)"

# Dokumentace
docs: ## Otevře dokumentaci
	@echo "$(BLUE)📚 Dostupná dokumentace:$(NC)"
	@echo "  - $(YELLOW)QUICKSTART.md$(NC)  - Rychlý start"
	@echo "  - $(YELLOW)SETUP.md$(NC)       - Kompletní setup"
	@echo "  - $(YELLOW)BYBIT_API_SETUP.md$(NC) - API klíče"
	@echo "  - $(YELLOW)CHANGES.md$(NC)     - Souhrn změn"
