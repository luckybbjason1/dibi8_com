---
title: 'FreeLLMAPI: Kết hợp 16 cấp LLM miễn phí phía sau một điểm cuối tương thích với OpenAI'
description: 'Tổng hợp các gói miễn phí của Google, Groq, Cerebras, Mistral, NVIDIA, OpenRouter và nhiều hơn nữa thành một proxy duy nhất. ~1,7 tỷ token/tháng. Cài đặt Docker, tích hợp Claude Code, gọi công cụ, phát trực tiếp, chuỗi dự phòng.'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'LLM Proxy', 'Free Tier', 'OpenAI Compatible', 'Self-Hosted', 'Docker']
categories: ['ai-tools']
slug: freellmapi-openai-compatible-proxy-free-llm-tiers-2026
featureImage: 'https://images.pexels.com/photos/8644020/pexels-photo-8644020.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'
aliases: ['/freellmapi']
sources:
  - name: 'GitHub'
    url: 'https://github.com/tashfeenahmed/freellmapi'
  - name: 'Official Site'
    url: 'https://freellmapi.co'
lang: vi
---
title: 'FreeLLMAPI: Stack 16 Free LLM Tiers Behind One OpenAI-Compatible Endpoint'
description: 'Aggregate Google, Groq, Cerebras, Mistral, NVIDIA, OpenRouter and more free tiers into a single proxy. ~1.7B tokens/month. Docker install, Claude Code integration, tool calling, streaming, fallback chains.'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'LLM Proxy', 'Free Tier', 'OpenAI Compatible', 'Self-Hosted', 'Docker']
categories: ['ai-tools']
slug: freellmapi-openai-compatible-proxy-free-llm-tiers-2026

aliases: ['/freellmapi']
sources:
  - name: 'GitHub'
    url: 'https://github.com/tashfeenahmed/freellmapi'
  - name: 'Official Site'
    url: 'https://freellmapi.co'
---

# FreeLLMAPI: Stack 16 Free LLM Tiers Behind One OpenAI-Compatible Endpoint

TL;DR — **FreeLLMAPI** aggregates the free tiers of 16+ LLM providers (Google Gemini, Groq, Cerebras, Mistral, NVIDIA, OpenRouter, GitHub Models, Cohere, Cloudflare, HuggingFace, Z.ai, Ollama Cloud, Kilo, Pollinations, LLM7, OVH) behind a single `/v1/chat/completions` endpoint. Combined, they yield roughly **1.7 billion tokens per month** of working inference capacity. Install via Docker in one command, add your provider keys, and point any OpenAI-compatible client at your local server.

## What Is FreeLLMAPI?

Every major AI lab now offers a free tier — a few million tokens a month, a few thousand requests a day. On its own each tier is a toy. Stacked together, they add up to roughly **1.7 billion tokens per month** of working inference capacity, across 100+ models from small-and-fast to reasonably capable.

The problem is that stacking them by hand is painful: seventeen different SDKs, seventeen different rate limits, seventeen places a request can fail. **FreeLLMAPI** collapses that into one OpenAI-compatible endpoint. Point any OpenAI client library at your local server, and it routes transparently across whichever providers you've added keys for.

Built by **Tashfeen Ahmed**, FreeLLMAPI is a self-hosted Node.js proxy (TypeScript/Express) with a React admin dashboard. It supports:

- OpenAI Chat Completions API (`/v1/chat/completions`)
- Anthropic Messages API (`/v1/messages`) — works with Claude Code
- Responses API (`/v1/responses`) — for Codex CLI
- Image generation (`/v1/images/generations`)
- Text-to-speech (`/v1/audio/speech`)
- Tool calling with round-trip multi-step flows
- Embeddings with family-based routing
- Streaming and non-streaming responses
- Automatic failover on 429/5xx/timeout
- AES-256-GCM encrypted key storage in SQLite

**GitHub:** [tashfeenahmed/freellmapi](https://github.com/tashfeenahmed/freellmapi) · **Stars:** 11,381+ · **License:** MIT · **Language:** TypeScript

## Supported Providers

FreeLLMAPI currently supports 16 free-tier providers with 100+ models:

| Provider | Key Models | Rate Limits |
|----------|-----------|-------------|
| Google AI | Gemini 2.5 Flash, 3.x previews | ~30 RPM |
| Groq | Llama 3.3 70B, Llama 4, GPT-OSS, Qwen3 | ~40 RPM |
| Cerebras | Qwen3 235B | Fast inference |
| Mistral | Large 3, Medium 3.5, Codestral, Devstral | ~60 RPM |
| OpenRouter | 21 free-tier models | Varies |
| GitHub Models | GPT-4.1, GPT-4o | ~10K tokens/day |
| Cloudflare Workers AI | Kimi K2, GLM-4.7, GPT-OSS, Granite 4 | ~40 RPM |
| Cohere | Command R+, Command-A | ~15 RPM |
| Z.ai (Zhipu) | GLM-4.5, GLM-4.7 Flash | Varies |
| NVIDIA NIM | 40 RPM free (eval-only ToS) | ~40 RPM |
| HuggingFace | Router, DeepSeek V4, Kimi K2.6, Qwen3 | Varies |
| Ollama Cloud | GLM-4.7, Kimi K2, gpt-oss, Qwen3 | Varies |
| Kilo Gateway | :free routes | Anonymous OK |
| Pollinations | GPT-OSS 20B | Anonymous OK |
| LLM7 | GPT-OSS, Llama 3.1, GLM | Anonymous OK |
| OVH AI Endpoints | Qwen3.5 397B, GPT-OSS, Llama 3.3 | Anonymous OK |
| OpenCode Zen | DeepSeek V4 Flash, Nemotron | Promo period |

Plus a **custom** provider — point at any OpenAI-compatible endpoint (llama.cpp, LM Studio, vLLM, a local Ollama, or a remote gateway) from the Keys page.

## Installation

### One-Liner (Docker)

The fastest path is a single command that sets up everything:

```bash
curl -fsSL https://freellmapi.co/install.sh | bash
```

This creates `~/freellmapi`, generates an encryption key, pulls the Docker image, and starts the container on port 3001. Re-running is safe — your `.env` and encryption key are preserved.

### Docker Compose (Manual)

```bash
git clone https://github.com/tashfeenahmed/freellmapi.git
cd freellmapi

# Generate an encryption key for at-rest key storage
ENCRYPTION_KEY="$(openssl rand -hex 32)"
printf "ENCRYPTION_KEY=%s\nPORT=3001\n" "$ENCRYPTION_KEY" > .env

docker compose up -d
```

Open `http://localhost:3001`, add your provider keys on the **Keys** page, reorder the **Fallback Chain** to taste, and grab your unified API key from the **Keys** page header.

### Local Development

```bash
git clone https://github.com/tashfeenahmed/freellmapi.git
cd freellmapi
npm install
cp .env.example .env
ENCRYPTION_KEY="$(node -e 'console.log(require("crypto").randomBytes(32).toString("hex"))')"
printf "ENCRYPTION_KEY=%s\nPORT=3001\n" "$ENCRYPTION_KEY" > .env
npm run dev
```

### Desktop Apps

Native `.dmg` (macOS) and `.exe` (Windows) installers are available from [Releases](https://github.com/tashfeenahmed/freellmapi/releases/latest). The desktop app runs the entire router and dashboard from your system tray with a glass popover showing live request stats.

## How the Router Works

FreeLLMAPI's router makes a per-request decision:

1. Pick the highest-priority model that has a healthy key and is under all rate limits
2. Decrypt the key (AES-256-GCM), call the provider SDK
3. On 429/5xx/timeout → cooldown + retry next model in the fallback chain (up to 20 attempts)

```
┌──────────────────┐   Bearer freellmapi-…   ┌─────────────────────────┐
│  OpenAI SDK /    │ ──────────────────────▶ │  Express proxy (:3001)  │
│  curl / any      │ ◀────────────────────── │  /v1/chat/completions   │
│  OpenAI client   │      streamed tokens    └────────────┬────────────┘
└──────────────────┘                                      │
                                                          ▼
                             ┌────────────────────────────────────────────────┐
                             │  Router                                        │
                             │   1. Pick highest-priority model that          │
                             │      (a) has a healthy key and                 │
                             │      (b) is under all its rate limits.         │
                             │   2. Decrypt key, call provider SDK.           │
                             │   3. On 429/5xx → cooldown + retry next model. │
                             └────────────────────────────────────────────────┘
                                          │
   ┌──────────────┬────────────┬──────────┴─────────┬─────────────┬──────────┐
   ▼              ▼            ▼                    ▼             ▼          ▼
 Google         Groq        Cerebras           OpenRouter        HF       …10 more
```

Every response carries an `X-Routed-Via: <platform>/<model>` header so you can see which provider actually served each call. If a request fell over between providers, you'll also see `X-Fallback-Attempts: N`.

## Using FreeLLMAPI with Any Client

### Python (OpenAI SDK)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:3001/v1",
    api_key="freellmapi-your-unified-key",
)

resp = client.chat.completions.create(
    model="auto",  # let the router pick; or specify e.g. "gemini-2.5-flash"
    messages=[{"role": "user", "content": "Summarise the fall of Rome in one sentence."}],
)
print(resp.choices[0].message.content)
print("Routed via:", resp.headers.get("x-routed-via"))
```

### Streaming

```python
stream = client.chat.completions.create(
    model="auto",
    messages=[{"role": "user", "content": "Stream me a haiku about SQLite."}],
    stream=True,
)
for chunk in stream:
    print(chunk.choices[0].delta.content or "", end="", flush=True)
```

### Tool Calling

```python
tools = [{
    "type": "function",
    "function": {
        "name": "get_weather",
        "description": "Get current weather for a city.",
        "parameters": {
            "type": "object",
            "properties": {"city": {"type": "string"}},
            "required": ["city"],
        },
    },
}]

# 1. Model asks for a tool call
first = client.chat.completions.create(
    model="auto",
    messages=[{"role": "user", "content": "What's the weather in Karachi?"}],
    tools=tools,
    tool_choice="required",
)
call = first.choices[0].message.tool_calls[0]

# 2. You execute the tool, feed the result back
final = client.chat.completions.create(
    model="auto",
    messages=[
        {"role": "user", "content": "What's the weather in Karachi?"},
        first.choices[0].message,
        {"role": "tool", "tool_call_id": call.id, "content": '{"temp_c": 32, "cond": "sunny"}'},
    ],
    tools=tools,
)
print(final.choices[0].message.content)
```

### Gemini Google Search Grounding

```python
resp = client.chat.completions.create(
    model="gemini-2.5-flash",
    messages=[{"role": "user", "content": "Who won the F1 race this weekend?"}],
    tools=[{"type": "function", "function": {"name": "google_search", "parameters": {}}}],
)
print(resp.choices[0].message.content)
```

### Vision / Image Input

```python
resp = client.chat.completions.create(
    model="auto",
    messages=[{
        "role": "user",
        "content": [
            {"type": "text", "text": "What's in this image?"},
            {"type": "image_url", "image_url": {"url": "data:image/png;base64,<...>"}},
        ],
    }],
)
print(resp.choices[0].message.content)
```

## Claude Code Integration

FreeLLMAPI also speaks the Anthropic Messages API, so **Claude Code** and the official Anthropic SDKs can run against your free pool:

```bash
export ANTHROPIC_BASE_URL=http://localhost:3001
export ANTHROPIC_AUTH_TOKEN=freellmapi-your-unified-key
claude
```

> Use `ANTHROPIC_AUTH_TOKEN` (sent as a Bearer token), **not** `ANTHROPIC_API_KEY` — Claude Code treats a set `ANTHROPIC_API_KEY` as a conflicting first-party credential and refuses to start.

Claude model names map to your free pool on the **Keys → Anthropic** tab: each family (`default`, `opus`, `sonnet`, `haiku`) routes to `auto` (the router picks a free model) or a model you pin. Streaming, system prompts, tool use, and image input all translate across the same router as the OpenAI endpoints.

## Embeddings

`/v1/embeddings` is OpenAI-compatible with one deliberate difference: **failover never crosses models.** Vectors from different models live in incompatible spaces. Embeddings route by family:

```python
resp = client.embeddings.create(
    model="auto",
    input=["the quick brown fox", "pack my box with five dozen liquor jugs"],
)
print(len(resp.data), "vectors of", len(resp.data[0].embedding), "dims")
```

Available embedding families:

| Family | Dims | Providers |
|--------|------|-----------|
| `gemini-embedding-001` | 3072 | Google |
| `text-embedding-3-large` | 3072 | GitHub Models |
| `text-embedding-3-small` | 1536 | GitHub Models |
| `embed-v4.0` | 1536 | Cohere |
| `bge-m3` | 1024 | Cloudflare → Hugging Face |
| `qwen3-embedding-0.6b` | 1024 | Cloudflare |
| `nv-embedqa-e5-v5` | 1024 | NVIDIA |

## Key Features

- **Automatic Failover** — If the chosen provider returns a 429, 5xx, or times out, the router skips it, puts the key on a short cooldown, and retries on the next model in your fallback chain (up to 20 attempts)
- **Sticky Sessions** — Multi-turn conversations keep talking to the same model for 30 minutes to avoid the hallucination spike from mid-conversation model switches
- **Encrypted Key Storage** — API keys are encrypted with AES-256-GCM before hitting SQLite; decryption happens in-memory just before a request
- **Unified API Key** — Clients authenticate to your proxy with a single `freellmapi-…` bearer token. You never expose upstream provider keys to your apps
- **Health Checks** — Periodic probes mark keys as `healthy`, `rate_limited`, `invalid`, or `error` so the router skips dead ones automatically
- **Analytics** — Per-request logging with latency, token counts, success rate, and per-provider breakdowns
- **Context Handoff** — Optional feature that injects a compact system message when a session falls over to a different model, so the new model knows it is continuing an existing task
- **Runs Anywhere** — Windows, macOS, Linux servers, or a small ARM SBC (Raspberry Pi included). ~40 MB RSS at idle

## Performance and Capacity

The combined free-tier capacity is approximately **1.7 billion tokens per month**. Here's a rough breakdown by tier:

| Tier | Estimated Monthly Tokens |
|------|------------------------|
| Top tier (Gemini Pro, GPT-4o via GitHub) | ~500M tokens |
| Mid tier (Groq, Cerebras, Mistral) | ~600M tokens |
| Lower tier (Cloudflare, OVH, Pollinations) | ~600M tokens |

Your actual capacity depends on which providers you enable and their current free-tier quotas. The router tracks per-key RPM, RPD, TPM, and TPD counters so it always picks a key that's under its caps.

## Limitations

Be honest about the trade-offs:

- **No frontier models.** The free-tier catalog tops out around Llama 3.3 70B, GLM-4.5, Qwen 3 Coder, and Gemini 2.5 Pro. You will not get GPT-5 or Claude Opus class reasoning through this. For hard problems, pay for a real API.
- **Intelligence degrades as the day progresses.** Your top-ranked models have the lowest daily caps. Once they hit their limits, the router falls down your priority chain to smaller/weaker models. Expect effective intelligence to drop in the late hours of each day — then reset at UTC midnight.
- **Latency is highly variable.** Cerebras and Groq are extremely fast; others are not. You get whichever one is available.
- **Free tiers can change without notice.** Providers regularly tighten, loosen, or remove free tiers. When that happens you'll see 429s or auth errors until you update the catalog.
- **No SLA, by definition.** If you need reliability, use a paid provider with a contract.
- **Local-first.** There's no multi-tenant auth. Run this for yourself; don't expose it to the internet.
- **Legacy completions not supported.** Only `/v1/chat/completions` is implemented, not `/v1/completions` or `/v1/moderations`.

## Who Should Use FreeLLMAPI?

- **Individual developers** who want to prototype with multiple models without managing 17 API keys
- **AI hobbyists** on a budget who want maximum inference capacity for zero cost
- **Claude Code / Codex CLI users** who want to run their agents against a free pool
- **RAG builders** who need embeddings from multiple providers with automatic fallback
- **Anyone building OpenAI-compatible apps** who wants a resilient proxy that survives individual provider rate limits

## Alternatives Compared

| Feature | FreeLLMAPI | LiteLLM | OpenRouter |
|---------|-----------|---------|------------|
| Free tier aggregation | ✅ 16 providers | ❌ Paid only | ❌ Paid only |
| Self-hosted | ✅ Docker/Node | ✅ Docker/Node | ❌ Cloud only |
| Anthropic API support | ✅ `/v1/messages` | ✅ | ✅ |
| Encrypted key storage | ✅ AES-256-GCM | ✅ | N/A |
| Admin dashboard | ✅ React + Vite | ❌ CLI only | ✅ Web |
| Local/desktop app | ✅ macOS/Windows | ❌ | ❌ |
| Cost | Free (MIT) | Free (Apache 2.0) | Pay per token |
| Multi-tenant | ❌ Single-user | ✅ | ✅ |

## Getting Started Checklist

1. Install Docker (or Node.js 20+ for local dev)
2. Run `curl -fsSL https://freellmapi.co/install.sh | bash`
3. Open `http://localhost:3001` and sign in
4. Add provider keys on the **Keys** page
5. Reorder your **Fallback Chain** to prioritize models you use most
6. Grab your unified API key
7. Point your OpenAI SDK at `http://localhost:3001/v1`
8. Start prompting with `model: "auto"`

## Frequently Asked Questions

### Q: Do I need API keys for all 16 providers?

No. FreeLLMAPI works with whatever keys you add. Some providers (Kilo, Pollinations, LLM7, OVH) accept anonymous requests. Others require free-tier signups. Start with 2-3 keys and add more as needed.

### Q: Can I use FreeLLMAPI with LangChain or LlamaIndex?

Yes. FreeLLMAPI implements the OpenAI-compatible wire format. Any client that works with `base_url` + `api_key` will work — LangChain, LlamaIndex, Continue, Hermès Agent, and more. Just change the `base_url` to `http://localhost:3001/v1`.

### Q: How does the fallback chain work?

You define a priority order of models in the dashboard. When a request is made, the router picks the highest-priority healthy model. If that model returns a 429, 5xx, or times out, it moves to the next model in your chain. Each key gets a short cooldown before being retried.

### Q: Is my data safe?

All provider API keys are encrypted with AES-256-GCM and stored in a local SQLite database. Decryption happens in-memory only, just before a request is sent. Your prompts and completions are not stored externally — request analytics are retained locally for 90 days or 100,000 rows (configurable).

### Q: Can I add my own custom provider?

Yes. The **Custom** provider lets you point at any OpenAI-compatible endpoint — llama.cpp, LM Studio, vLLM, a remote Ollama instance, or any other proxy. It appears at the end of your fallback chain and can be reordered like any other provider.

### Q: What about the Premium tier?

Free installs follow a monthly snapshot — zero cost, forever. Premium ($19/year or $49 lifetime) follows the live feed, refreshed every 2-3 days, so new free models are added to your router immediately. The catalog server never sees your prompts, completions, or provider keys.

## Docker Compose Setup

For teams that prefer Docker Compose over the install script:

```yaml
version: '3.8'
services:
  freellmapi:
    image: freellmapi/server:latest
    ports:
      - "3001:3001"
    volumes:
      - ./data:/app/data
    environment:
      - ENCRYPTION_KEY=your-random-32-char-key-here
    restart: unless-stopped
```

```bash
# Create data directory and start
mkdir -p data
docker compose up -d
# Admin dashboard at http://localhost:3001
```

## Environment Variables

All configuration can be set via environment variables:

```bash
export PORT=3001
export ENCRYPTION_KEY="a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
export LOG_LEVEL=info
export MAX_RETRIES=3
export REQUEST_TIMEOUT=30000
```

```bash
# Verify your configuration
docker exec freellmapi node --eval "console.log(process.env.PORT)"
```

## CLI Management

FreeLLMAPI ships with a management CLI for automation:

```bash
# Check server status
freellmapi status

# List active providers and their key counts
freellmapi providers --list

# Export your configuration for backup
freellmapi config export > freellmapi-backup.json

# Restore configuration from backup
freellmapi config restore < freellmapi-backup.json
```

```bash
# Monitor real-time request logs
freellmapi logs --follow --since 5m

# Check which providers are rate-limited right now
freellmapi health --providers
```

## Sources

- [FreeLLMAPI on GitHub](https://github.com/tashfeenahmed/freellmapi)
- [freellmapi.co — Live Model Catalog](https://freellmapi.co)
- [FreeLLMAPI Install Script](https://freellmapi.co/install.sh)
- [FreeLLMAPI Desktop Releases](https://github.com/tashfeenahmed/freellmapi/releases)

---

**Want to try FreeLLMAPI?** Deploy it in under 2 minutes with Docker. No credit card, no API key management, no vendor lock-in. Just one endpoint for 16 free LLM providers.

**Join the Dibi8 community:** [Telegram Group](https://t.me/DIBI8_Group/2)
