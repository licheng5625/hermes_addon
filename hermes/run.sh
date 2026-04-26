#!/bin/bash
set -e

CONFIG_DIR=/config/hermes
# Create directories
mkdir -p $CONFIG_DIR/workspace
mkdir -p $CONFIG_DIR/sessions

# Link /root/.hermes to /config/hermes (HA's /homeassistant/hermes/)
rm -rf /root/.hermes
ln -sf $CONFIG_DIR /root/.hermes

# Check if config exists
if [ ! -f "$CONFIG_DIR/config.json" ]; then
    echo "Error: Config file not found"
    echo "Please create /homeassistant/hermes/config.json"
    echo ""
    echo "Example config:"
    cat << 'EOF'
{
  "agents": {
    "defaults": {
      "workspace": "~/.hermes/workspace",
      "model": "claude-sonnet-4-20250514",
      "max_tokens": 8192,
      "temperature": 0.7
    }
  },
  "providers": {
    "anthropic": {
      "api_key": "your-api-key"
    }
  },
  "channels": {
    "homeassistant": {
      "enabled": true
    },
    "telegram": { "enabled": false },
    "whatsapp": { "enabled": false }
  },
  "gateway": {
    "host": "0.0.0.0",
    "port": 18790
  }
}
EOF
    exit 1
fi

echo "Config: /homeassistant/hermes/config.json"
echo "Starting hermes gateway..."

exec hermes gateway
