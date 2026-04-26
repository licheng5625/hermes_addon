# Hermes Agent for Home Assistant

Self-improving AI assistant powered by [Hermes Agent](https://hermes-agent.nousresearch.com/) from Nous Research, packaged as a Home Assistant add-on.

## Features

- 🤖 Self-improving AI agent with persistent memory and skill learning
- 🏠 Native Home Assistant integration (entity control, service calls)
- 💬 WhatsApp integration (QR code pairing)
- 📱 Telegram integration (BotFather token)
- 🛠️ 47 built-in tools (shell, file operations, web search, browser, vision)
- 🔊 Voice message support and TTS
- 🌐 Works with any OpenAI-compatible API (Nous Portal, OpenRouter, Anthropic, local LLMs)

## Configuration

Hermes Agent uses a `config.json` file located at `/homeassistant/hermes/config.json` on your Home Assistant host.

### Minimal Example

```json
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
    "homeassistant": { "enabled": true },
    "telegram": { "enabled": false },
    "whatsapp": { "enabled": false }
  },
  "gateway": {
    "host": "0.0.0.0",
    "port": 18790
  }
}
```

### Agent Settings

| Key | Default | Description |
|-----|---------|-------------|
| `agents.defaults.model` | — | LLM model name (e.g., `claude-sonnet-4-20250514`, `google/gemini-2.5-flash`) |
| `agents.defaults.workspace` | `~/.hermes/workspace` | Working directory for the agent |
| `agents.defaults.max_tokens` | `8192` | Maximum tokens per response |
| `agents.defaults.temperature` | `0.7` | LLM temperature (0.0–1.0) |

### Provider Settings

Configure one or more LLM providers. The agent works with any OpenAI-compatible API.

```json
"providers": {
  "anthropic": {
    "api_key": "sk-ant-..."
  }
}
```

Or use a custom/local endpoint:

```json
"providers": {
  "vllm": {
    "api_key": "your-api-key",
    "api_base": "http://192.168.0.134:3030/v1"
  }
}
```

### Gateway Settings

| Key | Default | Description |
|-----|---------|-------------|
| `gateway.host` | `0.0.0.0` | Gateway listen address |
| `gateway.port` | `18790` | Gateway listen port |

## Channel Configuration

### Home Assistant

Enables native HA conversation integration with additional tools for entity control.

```json
"channels": {
  "homeassistant": { "enabled": true }
}
```

When enabled, the agent gets access to Home Assistant-specific tools:
- `ha_list_entities` — List all HA entities
- `ha_get_state` — Get entity state
- `ha_call_service` — Call HA services (turn on lights, etc.)
- `ha_list_services` — List available services

### Telegram

1. Create a bot via [@BotFather](https://t.me/BotFather) on Telegram
2. Copy the bot token
3. Add your Telegram user ID to the allowed users list

```json
"channels": {
  "telegram": {
    "enabled": true,
    "token": "123456:ABC-DEF...",
    "allowed_users": ["123456789"]
  }
}
```

### WhatsApp

1. Enable WhatsApp in the config
2. Check the add-on logs for a QR code
3. Scan the QR code with WhatsApp on your phone

```json
"channels": {
  "whatsapp": {
    "enabled": true,
    "allowed_users": ["+1234567890"]
  }
}
```

## Security

By default, the gateway **denies all users** not in an allowlist. Always configure `allowed_users` for each enabled channel.

For DM pairing as an alternative, unknown users receive a one-time pairing code that administrators can approve via the gateway logs.

## Advanced Configuration

For the full Hermes Agent configuration reference (memory, compression, TTS, browser, delegation, skills, and more), see the official documentation:

**https://hermes-agent.nousresearch.com/docs/user-guide/configuration**

### Key Advanced Features

| Feature | Description |
|---------|-------------|
| **Memory** | Persistent memory and user profiles across sessions |
| **Skills** | Agent-created reusable skills that improve over time |
| **Compression** | Automatic context compression for long conversations |
| **Delegation** | Subagent spawning for parallel workstreams |
| **TTS** | Text-to-speech with 7 provider backends |
| **Browser** | Headless Chromium for web browsing and screenshots |
| **Cron** | Scheduled automations delivered to any channel |
| **Web Search** | Firecrawl, Tavily, Exa, or Parallel backends |

## Data Location

All persistent data is stored under `/homeassistant/hermes/` on your Home Assistant host:

| Path | Description |
|------|-------------|
| `/homeassistant/hermes/config.json` | Main configuration file |
| `/homeassistant/hermes/workspace/` | Agent workspace directory |
| `/homeassistant/hermes/sessions/` | Chat session history |

## Troubleshooting

- **No config file**: The add-on will print an example configuration and exit. Create `config.json` at `/homeassistant/hermes/config.json`.
- **WhatsApp QR code**: Check the add-on logs tab in Home Assistant to find the QR code for scanning.
- **Connection issues**: Ensure `host_network` is enabled (default) and port `18790` is accessible.
- **API errors**: Verify your API key and endpoint URL in the provider configuration.
