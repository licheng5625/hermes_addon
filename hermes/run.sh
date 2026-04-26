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
# Hermes Agent config — see https://hermes-agent.nousresearch.com/docs/user-guide/configuration

model:
  default: "claude-sonnet-4-5-20250929"
  provider: "custom"
  base_url: "http://127.0.0.1:3030/v1"
  # api_key from .env → OPENAI_API_KEY

agent:
  reasoning_effort: "high"
  max_turns: 50

# Home Assistant platform is auto-enabled via HASS_TOKEN env var (set by the add-on).
# Uncomment below to enable additional platforms:
# platforms:
#   telegram:
#     enabled: true
#   whatsapp:
#     enabled: true
EOF
    echo "Created default config.yaml at /homeassistant/hermes/config.yaml"
fi

# 4. Check and generate .env template (block startup if it does not exist)
if [ ! -f "$CONFIG_DIR/.env" ]; then
    echo "============================================"
    echo "  Warning: .env not found. Creating template..."
    echo "============================================"
    cat << 'EOF' > "$CONFIG_DIR/.env"
# LLM API key (used by the custom provider in config.yaml)
OPENAI_API_KEY="your-api-key"

# Or use Anthropic directly:
# ANTHROPIC_API_KEY="sk-ant-..."

# ==========================================
# API Server (public access on 0.0.0.0:8642)
# Generate a key: openssl rand -hex 32
# ==========================================
API_SERVER_KEY="your-random-secret-key"
API_SERVER_HOST="0.0.0.0"
# API_SERVER_PORT="8642"

# ==========================================
# Additional channel configurations
# ==========================================
# Discord
# DISCORD_TOKEN="your-discord-bot-token"
# DISCORD_ALLOWED_USERS="user_id_1,user_id_2"

# Telegram
# TELEGRAM_BOT_TOKEN="123456:ABC-DEF..."
# TELEGRAM_ALLOWED_USERS="123456789"
EOF
    echo "Created template .env at /homeassistant/hermes/.env"
    echo ""
    echo "🚨 ACTION REQUIRED: Please edit the .env file with your real API keys and restart the add-on."
    exit 1
fi

if [ -n "$SUPERVISOR_TOKEN" ]; then
    export HASS_TOKEN="$SUPERVISOR_TOKEN"
    export HASS_URL="http://supervisor/core/api"
    echo "Home Assistant integration: enabled (auto-detected)"
fi

# 5. Start the service
echo "Config Loaded: /homeassistant/hermes/config.yaml"
echo "Secrets Loaded: /homeassistant/hermes/.env"
echo "Starting hermes gateway..."

# Note: Use 'hermes gateway' or 'hermes gateway start' depending on your CLI version
exec hermes gateway run
