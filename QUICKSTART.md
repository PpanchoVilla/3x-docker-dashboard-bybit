# 🚀 Bybit Multi-Dashboard - Rychlý start

Tři Bybit demo dashboardy běžící v Dockeru s přístupem přes HTTPS subdomény.

## ⚡ Rychlé spuštění (3 kroky)

### 1. Získejte Bybit Demo API klíče

Vytvořte **3 API klíče** na Bybit Demo účtu:

1. Přejděte na [testnet.bybit.com](https://testnet.bybit.com)
2. API Management → Create New Key (3×)
3. Detailní návod: [BYBIT_API_SETUP.md](BYBIT_API_SETUP.md)

### 2. Nastavte API klíče

Upravte tyto soubory a doplňte vaše API klíče:

- `config/config1.json` → Dashboard 1
- `config/config2.json` → Dashboard 2  
- `config/config3.json` → Dashboard 3

Změňte:
```json
{
    "API_KEY": "YOUR_BYBIT_API_KEY_1",      // ← Váš skutečný klíč
    "API_SECRET": "YOUR_BYBIT_API_SECRET_1" // ← Váš skutečný secret
}
```

### 3. Spusťte

```bash
./start.sh
```

**Hotovo!** 🎉

Dashboardy běží na:
- http://localhost:5001 (Dashboard 1)
- http://localhost:5002 (Dashboard 2)
- http://localhost:5003 (Dashboard 3)

---

## 🌐 Nastavení pro doménu (produkce)

Pro přístup přes **https://dashboard1.ppanchov-takserver.eu**:

### 1. DNS konfigurace

Nastavte A záznamy:
```
dashboard1.ppanchov-takserver.eu  →  IP_VAŠEHO_SERVERU
dashboard2.ppanchov-takserver.eu  →  IP_VAŠEHO_SERVERU
dashboard3.ppanchov-takserver.eu  →  IP_VAŠEHO_SERVERU
```

### 2. SSL certifikát (Let's Encrypt)

```bash
# Nainstalujte certbot
sudo apt update && sudo apt install certbot

# Vygenerujte certifikát
sudo certbot certonly --standalone \
  -d dashboard1.ppanchov-takserver.eu \
  -d dashboard2.ppanchov-takserver.eu \
  -d dashboard3.ppanchov-takserver.eu

# Zkopírujte do projektu
sudo cp /etc/letsencrypt/live/dashboard1.ppanchov-takserver.eu/fullchain.pem nginx/ssl/
sudo cp /etc/letsencrypt/live/dashboard1.ppanchov-takserver.eu/privkey.pem nginx/ssl/
sudo chmod 644 nginx/ssl/*.pem
```

### 3. Firewall

```bash
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

### 4. Spusťte

```bash
./start.sh
```

Přístup:
- https://dashboard1.ppanchov-takserver.eu
- https://dashboard2.ppanchov-takserver.eu
- https://dashboard3.ppanchov-takserver.eu

---

## 📚 Dokumentace

- **[SETUP.md](SETUP.md)** - Kompletní setup guide
- **[BYBIT_API_SETUP.md](BYBIT_API_SETUP.md)** - Jak získat Bybit API klíče
- **[nginx/ssl/README.md](nginx/ssl/README.md)** - SSL certifikáty

---

## 🛠️ Užitečné příkazy

```bash
# Zobrazit logy
docker-compose logs -f

# Logy konkrétního dashboardu
docker-compose logs -f futuresboard1

# Status služeb
docker-compose ps

# Restart
docker-compose restart

# Zastavit
docker-compose down

# Rebuild
docker-compose build --no-cache
docker-compose up -d
```

---

## 📁 Struktura projektu

```
futuresboard/
├── config/
│   ├── config1.json          # ← API klíče pro Dashboard 1
│   ├── config2.json          # ← API klíče pro Dashboard 2
│   └── config3.json          # ← API klíče pro Dashboard 3
├── nginx/
│   ├── nginx.conf            # Reverse proxy
│   └── ssl/                  # SSL certifikáty
├── docker-compose.yaml       # Konfigurace služeb
├── Dockerfile               # Python 3.12 + dependencies
├── start.sh                 # ← Spouštěcí skript
└── SETUP.md                 # Detailní dokumentace
```

---

## 🎨 Customizace

### Změna barev dashboardů

V `config/configX.json`:

```json
{
    "CUSTOM": {
        "NAVBAR_TITLE": "Můj Dashboard",
        "NAVBAR_BG": "bg-primary",  // bg-primary, bg-success, bg-info, bg-danger
        "PROJECTIONS": [1.003, 1.005, 1.01, 1.012]
    }
}
```

### Změna intervalu aktualizace

```json
{
    "AUTO_SCRAPE_INTERVAL": 300  // 300 sekund = 5 minut
}
```

---

## 🔒 Bezpečnost

✅ **Používáme:** Bybit **Demo** účet (virtuální peníze)
```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true  // ← Demo režim (api-demo.bybit.com)
}
```

❌ **NEPOUŽÍVÁME:** Produkční API klíče

---

## ⚠️ Troubleshooting

### Dashboard se nespustí

```bash
# Zkontrolujte logy
docker-compose logs futuresboard1

# Zkontrolujte API klíče
grep "API_KEY" config/config1.json
```

### "Invalid API Key" chyba

- Ujistěte se, že používáte **Demo API klíče** (z testnet.bybit.com)
- Zkontrolujte, že `"DEMO_MODE": true` v config.json
- Ověřte, že API klíč má **Contract** permissions

### SSL chyby

```bash
# Vygenerujte testovací certifikát
cd nginx/ssl
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
  -keyout privkey.pem -out fullchain.pem \
  -subj "/C=CZ/ST=Prague/L=Prague/O=Dev/CN=*.ppanchov-takserver.eu"
```

---

## 📊 Funkce dashboardů

Každý dashboard zobrazuje:

- 📈 **Positions** - Aktuální pozice a P&L
- 📊 **History** - Historie obchodů
- 💰 **Wallet** - Stav účtu
- 📉 **Charts** - Grafy výkonnosti
- 📅 **Calendar** - Denní/měsíční přehledy
- 🎯 **Projections** - Projekce růstu

---

## 💡 Tipy

1. **Každý dashboard = samostatný Bybit demo účet**
   - Můžete testovat různé strategie současně
   
2. **Virtuální peníze**
   - Bybit Demo dává 100,000 USDT na testování
   
3. **Reálná data**
   - Demo používá skutečná tržní data

4. **Automatická aktualizace**
   - Data se automaticky stahují každých 5 minut
   - Interval lze změnit v `AUTO_SCRAPE_INTERVAL`

---

## 🤝 Podpora

- Original projekt: [futuresboard](https://github.com/ecoppen/futuresboard)
- Bybit API: [bybit-exchange.github.io/docs](https://bybit-exchange.github.io/docs/v5/intro)

---

## 📝 Licence

GPL-3.0 (stejná jako původní futuresboard projekt)

---

**Vytvořeno pro:** Monitoring Bybit Futures demo účtů  
**Docker:** Python 3.12 + Flask + Nginx  
**Přístup:** HTTPS přes subdomény nebo localhost
