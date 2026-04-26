#!/bin/bash
set -e

CONFIG_DIR=/config/hermes

# 1. Ensure required directories exist
mkdir -p $CONFIG_DIR/workspace
mkdir -p $CONFIG_DIR/sessions
mkdir -p $CONFIG_DIR/memories
mkdir -p $CONFIG_DIR/skills
mkdir -p $CONFIG_DIR/logs

# 2. Link default container path to Home Assistant persistent directory
rm -rf /root/.hermes
ln -sf $CONFIG_DIR /root/.hermes

# 3. Check and generate config.yaml if it does not exist
if [ ! -f "$CONFIG_DIR/config.yaml" ]; then
    echo "============================================"
    echo "  Notice: config.yaml not found. Creating..."
    echo "============================================"
    cat << 'EOF' > "$CONFIG_DIR/config.yaml"
workspace: "~/.hermes/workspace"

model:
  provider: "anthropic"
  default: "claude-sonnet-4-20250514"
  max_tokens: 8192
  temperature: 0.7

gateway:
  host: "0.0.0.0"
  port: 18790
  platforms:
    homeassistant:
      enabled: true
      watch_all: true
    telegram:
      enabled: false
    whatsapp:
      enabled: false
EOF
    echo "Created default config.yaml at /homeassistant/hermes/config.yaml"
fi

# 4. Check and generate .env template (block startup if it does not exist)
if [ ! -f "$CONFIG_DIR/.env" ]; then
    echo "============================================"
    echo "  Warning: .env not found. Creating template..."
    echo "============================================"
    cat << 'EOF' > "$CONFIG_DIR/.env"
# Please enter your real API key here (restart service after editing)
ANTHROPIC_API_KEY="your-api-key"

# ==========================================
# Additional channel configurations
# (Fill based on enabled platforms in config.yaml)
# ==========================================
# Home Assistant Token
# HASS_TOKEN="your-home-assistant-long-lived-access-token"
# HASS_URL="http://homeassistant.local:8123"

# Telegram Token
# TELEGRAM_BOT_TOKEN="123456:ABC-DEF..."
# TELEGRAM_ALLOWED_USERS="123456789"
EOF
    echo "Created template .env at /homeassistant/hermes/.env"
    echo ""
    echo "🚨 ACTION REQUIRED: Please edit the .env file with your real API keys and restart the add-on."
    exit 1
fi

# 5. Start the service
echo "Config Loaded: /homeassistant/hermes/config.yaml"
echo "Secrets Loaded: /homeassistant/hermes/.env"
echo "Starting hermes gateway..."

# Note: Use 'hermes gateway' or 'hermes gateway start' depending on your CLI version
exec hermes gateway start