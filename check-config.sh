#!/bin/bash

# Skript pro validaci konfigurace před spuštěním

echo "🔍 Kontrola konfigurace Bybit Dashboards..."
echo ""

ERRORS=0
WARNINGS=0

# Funkce pro kontrolu JSON souboru
check_json() {
    local file=$1
    local name=$2
    
    echo "📄 Kontroluji $name ($file)..."
    
    if [ ! -f "$file" ]; then
        echo "   ❌ Soubor neexistuje!"
        ((ERRORS++))
        return
    fi
    
    # Validace JSON syntaxe
    if ! python3 -m json.tool "$file" > /dev/null 2>&1; then
        echo "   ❌ Neplatný JSON formát!"
        ((ERRORS++))
        return
    fi
    
    # Kontrola EXCHANGE
    local exchange=$(python3 -c "import json; print(json.load(open('$file')).get('EXCHANGE', ''))" 2>/dev/null)
    if [ "$exchange" != "bybit" ]; then
        echo "   ⚠️  EXCHANGE není 'bybit' (je: '$exchange')"
        ((WARNINGS++))
    else
        echo "   ✅ EXCHANGE: bybit"
    fi
    
    # Kontrola DEMO_MODE
    local demo=$(python3 -c "import json; print(json.load(open('$file')).get('DEMO_MODE', False))" 2>/dev/null)
    if [ "$demo" != "True" ]; then
        echo "   ⚠️  DEMO_MODE není true (je: $demo)"
        ((WARNINGS++))
    else
        echo "   ✅ DEMO_MODE: true"
    fi
    
    # Kontrola API klíčů
    local api_key=$(python3 -c "import json; print(json.load(open('$file')).get('API_KEY', ''))" 2>/dev/null)
    if [ -z "$api_key" ]; then
        echo "   ❌ API_KEY je prázdný!"
        ((ERRORS++))
    elif [[ "$api_key" == *"YOUR_BYBIT"* ]]; then
        echo "   ❌ API_KEY obsahuje placeholder - doplňte skutečný klíč!"
        ((ERRORS++))
    else
        echo "   ✅ API_KEY nastaven (${api_key:0:10}...)"
    fi
    
    local api_secret=$(python3 -c "import json; print(json.load(open('$file')).get('API_SECRET', ''))" 2>/dev/null)
    if [ -z "$api_secret" ]; then
        echo "   ❌ API_SECRET je prázdný!"
        ((ERRORS++))
    elif [[ "$api_secret" == *"YOUR_BYBIT"* ]]; then
        echo "   ❌ API_SECRET obsahuje placeholder - doplňte skutečný secret!"
        ((ERRORS++))
    else
        echo "   ✅ API_SECRET nastaven (${api_secret:0:10}...)"
    fi
    
    # Kontrola PORT
    local port=$(python3 -c "import json; print(json.load(open('$file')).get('PORT', 0))" 2>/dev/null)
    echo "   ℹ️  Port: $port"
    
    echo ""
}

# Kontrola config souborů
check_json "config/config1.json" "Dashboard 1"
check_json "config/config2.json" "Dashboard 2"
check_json "config/config3.json" "Dashboard 3"

# Kontrola SSL certifikátů
echo "🔐 Kontroluji SSL certifikáty..."
if [ ! -f "nginx/ssl/fullchain.pem" ]; then
    echo "   ⚠️  Chybí nginx/ssl/fullchain.pem"
    ((WARNINGS++))
else
    echo "   ✅ fullchain.pem existuje"
fi

if [ ! -f "nginx/ssl/privkey.pem" ]; then
    echo "   ⚠️  Chybí nginx/ssl/privkey.pem"
    ((WARNINGS++))
else
    echo "   ✅ privkey.pem existuje"
fi
echo ""

# Kontrola Docker
echo "🐳 Kontroluji Docker..."
if ! command -v docker &> /dev/null; then
    echo "   ❌ Docker není nainstalován!"
    ((ERRORS++))
else
    echo "   ✅ Docker je k dispozici"
fi

if ! docker compose version &> /dev/null; then
    echo "   ⚠️  docker compose není dostupný (nainstalujte Docker Compose plugin)"
    ((WARNINGS++))
else
    echo "   ✅ docker compose je k dispozici"
fi
echo ""

# Kontrola portů (pokud běží na tomto serveru)
echo "📡 Kontroluji dostupnost portů..."
for port in 5001 5002 5003 80 443; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null 2>&1 ; then
        echo "   ⚠️  Port $port je již používán"
        ((WARNINGS++))
    else
        echo "   ✅ Port $port je volný"
    fi
done
echo ""

# Kontrola složek
echo "📁 Kontroluji složky..."
for dir in data1 data2 data3 nginx/ssl; do
    if [ ! -d "$dir" ]; then
        echo "   ℹ️  Vytvářím $dir/"
        mkdir -p "$dir"
    else
        echo "   ✅ $dir/ existuje"
    fi
done
echo ""

# Výsledek
echo "════════════════════════════════════════"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo "✅ Vše je v pořádku!"
    echo ""
    echo "Můžete spustit: ./start.sh"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo "⚠️  Nalezeno $WARNINGS varování"
    echo ""
    echo "Můžete pokračovat, ale doporučujeme vyřešit varování."
    echo ""
    read -p "Chcete pokračovat? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    else
        exit 1
    fi
else
    echo "❌ Nalezeno $ERRORS chyb a $WARNINGS varování"
    echo ""
    echo "Před spuštěním je nutné opravit chyby:"
    echo ""
    if [ $ERRORS -gt 0 ]; then
        echo "1. Doplňte Bybit API klíče do config/config*.json"
        echo "   Viz: BYBIT_API_SETUP.md"
        echo ""
    fi
    echo "Po opravě spusťte znovu: ./check-config.sh"
    exit 1
fi
