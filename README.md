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

2. Install the **"Nanobot AI Assistant"** add-on

3. Create the config file at `/homeassistant/hermes/config.json`:
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

4. Start the add-on

## Using a Local LLM

To use a local/self-hosted model instead of a cloud API, point the provider to your local endpoint:

```json
"providers": {
  "vllm": {
    "api_key": "any-value",
    "api_base": "http://192.168.0.134:3030/v1"
  }
}
```

## Channel Setup

| Channel | Setup |
|---------|-------|
| **Home Assistant** | Set `"homeassistant": { "enabled": true }` — enables entity control tools |
| **Telegram** | Get a bot token from [@BotFather](https://t.me/BotFather), add token and allowed user IDs |
| **WhatsApp** | Enable in config, scan the QR code from the add-on logs |

## Documentation

See the [add-on DOCS](hermes/DOCS.md) for full configuration reference, or the official Hermes Agent documentation:

- [Configuration Guide](https://hermes-agent.nousresearch.com/docs/user-guide/configuration)
- [Messaging & Gateway](https://hermes-agent.nousresearch.com/docs/user-guide/messaging)
- [Hermes Agent GitHub](https://github.com/NousResearch/hermes-agent)

## Support

- [Hermes Agent Docs](https://hermes-agent.nousresearch.com/docs)
- [Add-on Issues](https://github.com/licheng5625/hermes_addon/issues)
