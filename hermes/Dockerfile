FROM ghcr.io/home-assistant/base-debian:trixie

# OCI labels (replaces legacy io.hass.* labels from build.yaml)
LABEL \
    io.hass.name="Hermes Agent" \
    io.hass.description="Self-improving AI assistant powered by Hermes Agent from Nous Research" \
    io.hass.type="addon" \
    io.hass.url="https://github.com/licheng5625/hermes_addon" \
    org.opencontainers.image.title="Hermes Agent" \
    org.opencontainers.image.description="Self-improving AI assistant powered by Hermes Agent from Nous Research" \
    org.opencontainers.image.source="https://github.com/licheng5625/hermes_addon" \
    org.opencontainers.image.licenses="Apache-2.0"

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
    libopus0 \
    libsodium23 \
    ffmpeg \
    wget \
    gpg \
    sshpass \
    && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI
RUN mkdir -p -m 755 /etc/apt/keyrings \
    && wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update \
    && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Create virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Copy requirements file
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies from requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Install playwright browsers
RUN playwright install --with-deps chromium

# Download hermes-agent source (no git history)
RUN curl -sL https://github.com/NousResearch/hermes-agent/archive/498bfc7bc12a937621b4215312049b1000726df3.tar.gz \
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
