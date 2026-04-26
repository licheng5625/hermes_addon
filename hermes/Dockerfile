ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base-debian:trixie
FROM $BUILD_FROM

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    git \
    curl \
    bash \
    jq \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create virtual environment and install uv
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --no-cache-dir uv

# Install playwright and browsers
RUN uv pip install playwright && playwright install --with-deps chromium

# Download hermes-agent source (no git history)
RUN curl -sL https://github.com/NousResearch/hermes-agent/archive/bf196a3fc0fd1f79353369e8732051db275c6276.tar.gz \
    | tar xz --strip-components=1

# Install hermes-agent in venv
RUN uv pip install --no-cache .

# Install WhatsApp bridge dependencies
WORKDIR /app/scripts/whatsapp-bridge
RUN npm install
WORKDIR /app

# Create config directory
RUN mkdir -p /root/.hermes

# Copy run script
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
