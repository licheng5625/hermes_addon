# Hermes Agent Add-on for Home Assistant

[![Add repository to Home Assistant](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Flicheng5625%2Fhermes_addon)

Self-improving AI assistant powered by [Hermes Agent](https://hermes-agent.nousresearch.com/) from [Nous Research](https://nousresearch.com/), running as a Home Assistant add-on.

## Features

- **Self-improving agent** — learns skills from experience, builds persistent memory across sessions
- **Home Assistant native** — control entities, call services, query states via conversation
- **Multi-channel** — WhatsApp, Telegram, and Home Assistant conversation integrations
- **Any LLM provider** — Nous Portal, OpenRouter, Anthropic, OpenAI, or any OpenAI-compatible API (including local models)
- **47 built-in tools** — shell, file operations, web search, browser, vision, TTS, and more

## Installation

1. Click the badge above, or manually add this repository URL to your Home Assistant add-on store:
   ```
   https://github.com/licheng5625/hermes_addon
   ```

2. Install the **"Hermes Agent"** add-on

3. Start the add-on — it will auto-generate config templates and exit on first run

4. Edit `/homeassistant/hermes/.env` with your API key:
   ```bash
   ANTHROPIC_API_KEY="sk-ant-..."
   ```

5. Restart the add-on

That's it. Home Assistant integration is auto-enabled. The default `config.yaml` is generated automatically:

```yaml
model:
  provider: "anthropic"
  default: "claude-sonnet-4-20250514"
  max_tokens: 8192
  temperature: 0.7
```

## Using a Local LLM

Edit `.env`:
```bash
OPENAI_API_KEY="any-value"
OPENAI_BASE_URL="http://192.168.0.134:3030/v1"
```

Edit `config.yaml`:
```yaml
model:
  provider: "openai"
  default: "your-model-name"
```

## Channel Setup

| Channel | Setup |
|---------|-------|
| **Home Assistant** | Auto-enabled (no config needed) |
| **Telegram** | Add `TELEGRAM_BOT_TOKEN` and `TELEGRAM_ALLOWED_USERS` to `.env`, enable in `config.yaml` |
| **WhatsApp** | Enable in `config.yaml`, scan the QR code from the add-on logs |

## Documentation

See the [add-on DOCS](hermes/DOCS.md) for full configuration reference, or the official Hermes Agent documentation:

- [Configuration Guide](https://hermes-agent.nousresearch.com/docs/user-guide/configuration)
- [Messaging & Gateway](https://hermes-agent.nousresearch.com/docs/user-guide/messaging)
- [Hermes Agent GitHub](https://github.com/NousResearch/hermes-agent)

## Support

- [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs)
- [Add-on Issues](https://github.com/licheng5625/hermes_addon/issues)
