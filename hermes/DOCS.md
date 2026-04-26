# Hermes Agent for Home Assistant

Self-improving AI assistant powered by [Hermes Agent](https://hermes-agent.nousresearch.com/) from Nous Research, packaged as a Home Assistant add-on.

## Features

- Self-improving AI agent with persistent memory and skill learning
- Native Home Assistant integration (entity control, service calls)
- WhatsApp integration (QR code pairing)
- Telegram integration (BotFather token)
- 47 built-in tools (shell, file operations, web search, browser, vision)
- Voice message support and TTS
- Works with any OpenAI-compatible API (Nous Portal, OpenRouter, Anthropic, local LLMs)

## Configuration

Hermes Agent uses two files under `/homeassistant/hermes/`:

| File | Purpose |
|------|---------|
| `config.yaml` | Model, platforms, and general settings |
| `.env` | API keys and secrets |

Both files are **auto-generated** on first startup. You only need to edit `.env` with your real API key.

### config.yaml

```yaml
model:
  provider: "anthropic"
  default: "claude-sonnet-4-20250514"
  max_tokens: 8192
  temperature: 0.7

# Additional platforms (Home Assistant is auto-enabled by the add-on)
# platforms:
#   telegram:
#     enabled: true
#   whatsapp:
#     enabled: true
```

### .env

```bash
ANTHROPIC_API_KEY="your-api-key"

# Telegram
# TELEGRAM_BOT_TOKEN="123456:ABC-DEF..."
# TELEGRAM_ALLOWED_USERS="123456789"
```

> **Note**: `HASS_TOKEN` and `HASS_URL` are automatically set by the add-on via the Home Assistant Supervisor API. You do not need to configure them manually.

### Model Settings

| Key | Default | Description |
|-----|---------|-------------|
| `model.provider` | — | Provider name (`anthropic`, `openai`, `openrouter`, etc.) |
| `model.default` | — | Model name (e.g., `claude-sonnet-4-20250514`) |
| `model.max_tokens` | `8192` | Maximum tokens per response |
| `model.temperature` | `0.7` | LLM temperature (0.0–1.0) |

### Using a Custom / Local LLM

Set the provider in `.env` with a custom base URL:

```bash
OPENAI_API_KEY="any-value"
OPENAI_BASE_URL="http://192.168.0.134:3030/v1"
```

And in `config.yaml`:

```yaml
model:
  provider: "openai"
  default: "your-model-name"
```

## Platform Configuration

### Home Assistant

Auto-enabled when running as a Home Assistant add-on. The agent gets access to:
- `ha_list_entities` — List all HA entities
- `ha_get_state` — Get entity state
- `ha_call_service` — Call HA services (turn on lights, etc.)
- `ha_list_services` — List available services

### Telegram

1. Create a bot via [@BotFather](https://t.me/BotFather) on Telegram
2. Add to `.env`:
   ```bash
   TELEGRAM_BOT_TOKEN="123456:ABC-DEF..."
   TELEGRAM_ALLOWED_USERS="123456789"
   ```
3. Enable in `config.yaml`:
   ```yaml
   platforms:
     telegram:
       enabled: true
   ```

### WhatsApp

1. Enable in `config.yaml`:
   ```yaml
   platforms:
     whatsapp:
       enabled: true
   ```
2. Restart the add-on
3. Check the add-on logs for a QR code, scan it with WhatsApp on your phone

## Security

By default, the gateway **denies all users** not in an allowlist. Always configure `TELEGRAM_ALLOWED_USERS` or `WHATSAPP_ALLOWED_USERS` in `.env` for each enabled channel.

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
| `config.yaml` | Main configuration file |
| `.env` | API keys and secrets |
| `memories/` | Persistent agent memory |
| `skills/` | Agent-created skills |
| `sessions/` | Chat session history |
| `logs/` | Error and gateway logs |

## Troubleshooting

- **First startup**: The add-on auto-generates `config.yaml` and `.env` templates, then exits asking you to fill in your API key in `.env`. Edit the file and restart.
- **WhatsApp QR code**: Check the add-on logs tab in Home Assistant to find the QR code for scanning.
- **Connection issues**: Ensure `host_network` is enabled (default) in the add-on settings.
- **API errors**: Verify your API key in `.env` and provider name in `config.yaml`.
