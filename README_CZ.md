# 3x Docker Dashboard Bybit

Tři nezávislé Bybit demo dashboardy běžící v Dockeru s nginx reverse proxy.

## 🚀 Rychlý start

```bash
# 1. Klonovat repository
git clone https://github.com/PpanchoVilla/3x-docker-dashboard-bybit.git
cd 3x-docker-dashboard-bybit

# 2. Nastavit Bybit Demo API klíče
# Upravte config/config1.json, config2.json, config3.json
# Přidejte vaše API_KEY a API_SECRET z https://testnet.bybit.com

# 3. Spustit
docker compose build
docker compose up -d
```

## 📊 Přístup k dashboardům

- **Dashboard 1 (BTC-AI-Trading)**: http://localhost:5001
- **Dashboard 2 (TriStrategy-BTC-ETH-SOL)**: http://localhost:5002
- **Dashboard 3 (BiStrategy-BTC-ETH)**: http://localhost:5003

## 📁 Struktura

```
3x-docker-dashboard-bybit/
├── config/
│   ├── config1.json              # Dashboard 1 konfigurace
│   ├── config2.json              # Dashboard 2 konfigurace
│   └── config3.json              # Dashboard 3 konfigurace
├── nginx/
│   ├── nginx.conf                # Reverse proxy konfigurace
│   └── ssl/                      # SSL certifikáty
├── src/futuresboard/             # Zdrojový kód aplikace
├── docker-compose.yaml           # Docker orchestrace
├── Dockerfile                    # Docker image definice
└── start.sh                      # Spouštěcí skript
```

## ⚙️ Konfigurace

Každý dashboard má vlastní konfiguraci v `config/configX.json`:

```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true,
    "API_KEY": "VÁŠ_BYBIT_DEMO_API_KEY",
    "API_SECRET": "VÁŠ_BYBIT_DEMO_API_SECRET",
    "PORT": 5001,
    "AUTO_SCRAPE_INTERVAL": 300,
    "CUSTOM": {
        "NAVBAR_TITLE": "BTC-AI-Trading",
        "NAVBAR_BG": "bg-primary"
    }
}
```

## 🔑 Získání Bybit Demo API klíčů

1. Přihlaste se na [Bybit Testnet](https://testnet.bybit.com)
2. Přejděte na **Account & Security** → **API Management**
3. Vytvořte nový API klíč (Read-only stačí)
4. Zkopírujte API Key a Secret
5. Vložte do `config/configX.json`

Detailní návod: [BYBIT_API_SETUP.md](BYBIT_API_SETUP.md)

## 🐳 Docker příkazy

```bash
# Build obrazů
docker compose build

# Spustit služby
docker compose up -d

# Zobrazit logy
docker compose logs -f

# Zastavit služby
docker compose down

# Restart služby
docker compose restart

# Status
docker compose ps
```

## 🛠️ Makefile příkazy

```bash
make build          # Build Docker obrazů
make up             # Spustit služby
make down           # Zastavit služby
make logs           # Zobrazit logy
make restart        # Restart služeb
make clean          # Vyčistit databáze
make shell1         # Shell do dashboardu 1
make shell2         # Shell do dashboardu 2
make shell3         # Shell do dashboardu 3
```

## 🌐 Nginx Reverse Proxy

Nginx běží na portech:
- **HTTP**: 9080
- **HTTPS**: 9443

Pro produkční nasazení nastavte DNS:
```
dashboard1.your-domain.com → server_ip:9443
dashboard2.your-domain.com → server_ip:9443
dashboard3.your-domain.com → server_ip:9443
```

## 🔒 SSL Certifikáty

### Self-signed (testování)
```bash
cd nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout privkey.pem -out fullchain.pem
```

### Let's Encrypt (produkce)
```bash
sudo certbot certonly --standalone -d dashboard1.your-domain.com
sudo cp /etc/letsencrypt/live/dashboard1.your-domain.com/*.pem nginx/ssl/
```

## 📖 Dokumentace

- [QUICKSTART.md](QUICKSTART.md) - Rychlý start v 3 krocích
- [SETUP.md](SETUP.md) - Kompletní setup návod
- [BYBIT_API_SETUP.md](BYBIT_API_SETUP.md) - Získání API klíčů
- [BYBIT_DEMO_FIX.md](BYBIT_DEMO_FIX.md) - Technické poznámky
- [CHANGES.md](CHANGES.md) - Seznam změn od původního projektu

## 🐛 Troubleshooting

### Dashboard se nezobrazuje
```bash
docker compose logs futuresboard1
docker compose restart futuresboard1
```

### API chyby
- Zkontrolujte API klíče v `config/configX.json`
- Ujistěte se, že používáte **Demo** API klíče (ne produkční)
- Ověřte `"DEMO_MODE": true` a `"TEST_MODE": false`

### Port již používán
```bash
# Změňte porty v docker-compose.yaml
ports:
  - "5001:5001"  # Změňte 5001 na jiný port
```

## 🔧 Technické detaily

- **Python**: 3.12-bookworm
- **Framework**: Flask
- **API**: Bybit V5 (demo.api.bybit.com)
- **Database**: SQLite (samostatné pro každý dashboard)
- **Auto-scrape**: Každých 300 sekund (nastavitelné)
- **Docker Compose**: v5.0.0+

## ⚠️ Důležité poznámky

1. **Pouze demo režim** - Projekt je určen pro testování s Bybit Demo API
2. **testnet=False, demo=True** - Správná konfigurace pro demo API
3. **accountType=UNIFIED** - Bybit demo vyžaduje UNIFIED účty
4. **Bezpečnost** - Nikdy nesdílejte API klíče, používejte read-only oprávnění

## 📝 Licence

MIT License - viz [LICENSE](LICENSE)

## 🙏 Poděkování

Založeno na projektu [futuresboard](https://github.com/ecoppen/futuresboard) od ecoppen.

## 📞 Podpora

Pro problémy a dotazy vytvořte issue na GitHubu.
