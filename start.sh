#!/bin/bash

# Skript pro snadné spuštění Bybit Dashboards

set -e

echo "=================================================="
echo "  Bybit Multi-Dashboard Setup"
echo "=================================================="
echo ""

# Kontrola, zda existují config soubory
if [ ! -f "config/config1.json" ] || [ ! -f "config/config2.json" ] || [ ! -f "config/config3.json" ]; then
    echo "❌ Chybí konfigurační soubory!"
    echo ""
    echo "Prosím upravte tyto soubory a doplňte vaše Bybit Demo API klíče:"
    echo "  - config/config1.json"
    echo "  - config/config2.json"
    echo "  - config/config3.json"
    echo ""
    echo "Změňte 'YOUR_BYBIT_API_KEY_X' a 'YOUR_BYBIT_API_SECRET_X' na vaše skutečné klíče."
    exit 1
fi

# Kontrola API klíčů
if grep -q "YOUR_BYBIT_API_KEY" config/config1.json || grep -q "YOUR_BYBIT_API_KEY" config/config2.json || grep -q "YOUR_BYBIT_API_KEY" config/config3.json; then
    echo "⚠️  VAROVÁNÍ: Některé config soubory stále obsahují placeholder API klíče!"
    echo ""
    read -p "Chcete pokračovat? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Vytvoření složek pro databáze
echo "📁 Vytvářím složky pro databáze..."
mkdir -p data1 data2 data3
mkdir -p nginx/ssl

# Kontrola SSL certifikátů
if [ ! -f "nginx/ssl/fullchain.pem" ] || [ ! -f "nginx/ssl/privkey.pem" ]; then
    echo ""
    echo "⚠️  SSL certifikáty nenalezeny!"
    echo ""
    echo "Pro produkci vygenerujte Let's Encrypt certifikát:"
    echo "  sudo certbot certonly --standalone -d ppanchov-takserver.eu -d dashboard1.ppanchov-takserver.eu -d dashboard2.ppanchov-takserver.eu -d dashboard3.ppanchov-takserver.eu"
    echo ""
    echo "Pro testování vygenerujte self-signed certifikát:"
    echo "  cd nginx/ssl"
    echo "  openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout privkey.pem -out fullchain.pem -subj \"/C=CZ/ST=Prague/L=Prague/O=Dev/CN=*.ppanchov-takserver.eu\""
    echo ""
    read -p "Chcete vygenerovat testovací self-signed certifikát? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🔐 Generuji self-signed SSL certifikát..."
        cd nginx/ssl
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
            -keyout privkey.pem \
            -out fullchain.pem \
            -subj "/C=CZ/ST=Prague/L=Prague/O=Dev/CN=*.ppanchov-takserver.eu" 2>/dev/null
        cd ../..
        echo "✅ SSL certifikát vygenerován"
    else
        echo "❌ Nemůžu pokračovat bez SSL certifikátů"
        exit 1
    fi
fi

# Build a spuštění
echo ""
echo "🔨 Builduji Docker obrazy..."
docker compose build

echo ""
echo "🚀 Spouštím služby..."
docker compose up -d

echo ""
echo "⏳ Čekám na inicializaci služeb..."
sleep 5

echo ""
echo "✅ Služby spuštěny!"
echo ""
echo "=================================================="
echo "  Přístup k dashboardům:"
echo "=================================================="
echo ""
echo "  Dashboard 1: https://dashboard1.ppanchov-takserver.eu"
echo "  Dashboard 2: https://dashboard2.ppanchov-takserver.eu"
echo "  Dashboard 3: https://dashboard3.ppanchov-takserver.eu"
echo ""
echo "  Nebo lokálně:"
echo "  Dashboard 1: http://localhost:5001"
echo "  Dashboard 2: http://localhost:5002"
echo "  Dashboard 3: http://localhost:5003"
echo ""
echo "=================================================="
echo "  Užitečné příkazy:"
echo "=================================================="
echo ""
echo "  Zobrazit logy:           docker-compose logs -f"
echo "  Zastavit služby:         docker-compose down"
echo "  Restart služeb:          docker-compose restart"
echo "  Status služeb:           docker-compose ps"
echo ""
echo "Pro více informací viz SETUP.md"
echo ""
