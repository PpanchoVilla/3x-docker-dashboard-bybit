# Bybit Demo API - Provedené úpravy

## Datum: 9. prosince 2025

### Problém
Bybit Demo API vyžaduje jiné parametry než standardní Bybit API:
- `accountType` musí být `UNIFIED` místo `CONTRACT`
- Některé hodnoty mohou být prázdné stringy `""` místo čísel

### Řešení

#### 1. Změna accountType v scraper.py
```python
# Před:
params = {"coin": "USDT", "accountType": "CONTRACT"}

# Po:
params = {"coin": "USDT", "accountType": "UNIFIED"}
```

#### 2. Ošetření prázdných hodnot
```python
# Bezpečná konverze s kontrolou prázdných stringů
wallet_balance = responseJSON["result"]["list"][0]["coin"][0].get("walletBalance", "0")
unrealised_pnl = responseJSON["result"]["list"][0]["coin"][0].get("unrealisedPnl", "0")
available_to_withdraw = responseJSON["result"]["list"][0]["coin"][0].get("availableToWithdraw", "0")

totals_row = (
    float(wallet_balance) if wallet_balance != "" else 0.0,
    float(unrealised_pnl) if unrealised_pnl != "" else 0.0,
    maintenance_margin,
    float(available_to_withdraw) if available_to_withdraw != "" else 0.0,
    float(0),
    1,
)
```

### Výsledek ✅

Všechny tři dashboardy úspěšně komunikují s Bybit Demo API:

```
Dashboard 1: http://localhost:5001 (0 orders, 0 positions)
Dashboard 2: http://localhost:5002 (2 orders, 1 position)
Dashboard 3: http://localhost:5003 (2 orders, 1 position)
```

### Auto-scrape výstup
```
[INFO] in scraper: Auto scrape routines starting
[INFO] in scraper: Deleting orders and positions from db
[INFO] in scraper: Loading orders and positions from exchange
[INFO] in scraper: Updating wallet balance from exchange
[INFO] in scraper: Updating closed PnL from exchange
[INFO] in scraper: Orders updated: X; Positions updated: X (new: X); Trades processed: X
[INFO] in scraper: Auto scrape routines terminated. Sleeping 300 seconds...
```

### Konfigurace
Ujistěte se, že vaše `config/configX.json` obsahují:
```json
{
    "EXCHANGE": "bybit",
    "TEST_MODE": false,
    "DEMO_MODE": true,
    "API_KEY": "VÁŠ_DEMO_API_KEY",
    "API_SECRET": "VÁŠ_DEMO_API_SECRET"
}
```

### Bybit Session Setup (pro referenci)
```python
# Správná konfigurace pro Bybit Demo API
testnet_value = False  # NE testnet
session = HTTP(
    api_key=key,
    api_secret=secret,
    testnet=testnet_value,  # False
    demo=True               # True pro demo režim
)
```

### API Endpoint
- **Demo API**: `https://api-demo.bybit.com`
- **Testnet API**: `https://api-testnet.bybit.com` (nepoužívá se)
- **Produkční API**: `https://api.bybit.com` (nepoužívá se)
