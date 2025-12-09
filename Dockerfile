FROM python:3.12-bookworm

LABEL maintainer="ecoppen" \
	org.opencontainers.image.url="https://github.com/ecoppen/futuresboard" \
	org.opencontainers.image.source="https://github.com/ecoppen/futuresboard" \
	org.opencontainers.image.vendor="ecoppen" \
	org.opencontainers.image.title="3x-futuresboard-bybit" \
	org.opencontainers.image.description="Three Bybit Demo dashboards in Docker with HTTPS access" \
	org.opencontainers.image.licenses="GPL-3.0"

WORKDIR /usr/src/futuresboard

# Kopírujeme requirements a instalujeme závislosti
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kopírujeme zbytek aplikace
COPY . .

# Instalujeme aplikaci
RUN pip install --no-cache-dir -e .

CMD futuresboard