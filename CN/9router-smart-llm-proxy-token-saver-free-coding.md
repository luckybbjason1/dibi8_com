---
title: "9Router: Smart LLM Proxy with Token Saver — Cut AI Costs by 60%, Never Hit Rate Limits Again"
description: "Discover 9Router — an open-source smart proxy that saves 20-40% tokens via RTK compression, auto-fallback across 40+ providers, and zero-cost coding combos."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - Go
  - Java
  - JavaScript
  - Rust
  - TypeScript
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "3.2 MB"
file_md5: ""
download_url: "https://github.com/rtk-ai/rtk"
backup_url: ""
github_repo: "https://github.com/rtk-ai/rtk"
stars: 49905
maintainer: "rtk-ai"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /posts/9router-smart-llm-proxy-token-saver-free-coding/
faqs:
  - q: 'What is 9Router and how does it work?'
    a: '9Router is an open-source, self-hosted smart proxy that sits between your AI coding tool and model providers, running on localhost:20128 by default. Instead of calling Claude or OpenAI directly, your tool sends requests to 9Router, which routes them across 40+ providers using intelligent fallback logic and token compression.'
  - q: 'Does 9Router cost money to use?'
    a: 'No. The 9Router software is free forever under an open-source MIT license and is self-hosted on your own hardware. It has no billing infrastructure and never charges you; you only pay providers directly for whatever subscriptions or API keys you configure, and free providers stay free. The dashboard''s cost figures are a savings tracker showing what equivalent paid-API usage would have cost.'
  - q: 'How much does 9Router reduce AI token usage?'
    a: 'Through its built-in RTK compression, 9Router compresses tool outputs like git diffs, grep results, and directory listings before they reach the LLM, saving 20-40% of input tokens per request. Its optional Caveman mode reduces verbose model output by up to 65%, and developers making 500+ daily calls report effective model consumption dropping 40-60%.'
  - q: 'Which AI coding tools and IDEs work with 9Router?'
    a: 'Any tool that supports a custom OpenAI-compatible API endpoint can connect to 9Router via http://localhost:20128/v1. Supported tools include Claude Code, OpenAI Codex CLI, Cursor IDE, GitHub Copilot, Cline, Continue, Roo Code, Antigravity, Droid, Kilo Code, and OpenCode.'
  - q: 'Can I use 9Router for AI coding at zero monthly cost?'
    a: 'Yes. You can build a combo using only free providers such as Kiro AI (free unlimited via AWS Builder ID, Google, or GitHub OAuth, no API key), OpenCode Free (zero auth passthrough), and Vertex AI ($300 free Google Cloud credits). Combined with RTK compression, this delivers production-quality responses at literally $0 per month.'
---
{</* resource-info */>}

The AI coding assistant revolution has created a paradox for developers: we have unprecedented access to world-class language models through tools like Claude Code, OpenAI Codex, Cursor, and GitHub Copilot — but managing subscriptions, quotas, and rate limits across multiple platforms is becoming increasingly expensive and frustrating. Many developers find themselves burning through their Claude Pro monthly quota within two weeks, only to stare at rate-limit walls while trying to meet sprint deadlines.

Enter **9Router** — an open-source smart proxy and token management system that eliminates this pain entirely. With over **6,900 GitHub stars**, 1,200+ forks, and rapid community growth, 9Router has emerged as the go-to solution for developers who want maximum AI capability without paying for unnecessary premium tiers. Built on Node.js 20+ with Next.js 16 and React 19, it provides a unified interface that routes your AI coding requests across 40+ providers using intelligent fallback logic and powerful token-saving compression.

## What Is 9Router and How Does It Work?

9Router is a locally-hosted intermediary service (running on `localhost:20128` by default) that sits between your AI coding tool and the underlying model provider. Instead of sending API requests directly to Claude, OpenAI, or any single provider, your tool talks to 9Router — which then intelligently decides which backend provider to route the request to.

This architecture gives you three major advantages:

1. **Multi-provider access from one place**: Configure Claude, Gemini, GLM, MiniMax, Kiro, OpenCode, Vertex AI, and 40+ other providers in a single dashboard. Your CLI tools send requests to localhost; 9Router handles the rest.
2. **Automatic fallback**: When your primary provider hits a quota limit or experiences downtime, 9Router seamlessly switches to the next tier — whether that's a cheap backup provider or a completely free option. Zero interruptions to your workflow.
3. **Token compression before requests leave your machine**: Through its integration with [RTK](https://github.com/rtk-ai/rtk) (~40K stars), 9Router compresses tool outputs (git diffs, grep results, directory listings, log dumps) **before** they reach the LLM. This alone saves 20–40% of input tokens per request.

## Core Features That Set 9Router Apart

### 🚀 RTK Token Compression Engine

Tool outputs frequently account for 30–50% of your total prompt budget. When Claude Code runs `git diff`, `ls -R`, or `grep` in a large codebase, it sends megabytes of text to the model — much of which is irrelevant noise.

9Router's built-in RTK integration detects these tool outputs automatically and applies smart, lossless compression filters:

- **git-diff**: Reduces diff output to essential changed lines
- **git-status**: Compresses status into summary format
- **grep / find**: Prunes irrelevant matches, keeps context-rich lines
- **tree / ls**: Collapses directory structures meaningfully
- **dedup-log**: Removes duplicate consecutive log entries
- **smart-truncate**: Preserves head/tail while removing redundant middle sections

Crucially, if any filter fails or produces worse output than the original, RTK silently falls back to the unmodified text. Errors never break your requests. The compression runs *before* any format translation, so it works universally across all supported formats (OpenAI, Claude, Gemini, Cursor, Kiro, OpenAI Responses).

```
Without RTK: 47K tokens sent to LLM
With RTK:    28K tokens sent to LLM   (40% saved · same quality answer)
```

In practice, developers report seeing token savings of 20–40% on every single request — effectively extending the lifetime of every subscription by days or even weeks.

### 🪨 Caveman Mode (Output Compression)

Beyond input optimization, 9Router also reduces what the LLM sends back. By injecting a "caveman-style" system prompt (inspired by [Caveman](https://github.com/JuliusBrussee/caveman) with ~52K stars), 9Router instructs the model to respond tersely — preserving all technical substance while eliminating conversational filler.

This can save up to **65% of output tokens**. For complex refactoring tasks or long code generation sessions, these savings compound rapidly across hundreds of API calls.

### 🎯 Smart Three-Tier Fallback System

This is arguably 9Router's killer feature. You define "combos" — ordered lists of models spanning different pricing tiers — and 9Router automatically routes requests accordingly:

```
Combo: "my-coding-stack"
  1. cc/claude-opus-4-6        → Your Claude Code Pro subscription
  2. glm/glm-4.7               → Cheap backup ($0.6 per 1M tokens)
  3. kr/claude-sonnet-4.5      → Free emergency fallback via Kiro AI
```

When Opus quota runs out (or when an error occurs), 9Router instantly transitions to GLM. If GLM also exhausts, it drops to Kiro's free unlimited tier. You never hit a wall.

The system supports five distinct pricing layers:

| Tier | Providers | Typical Cost | Reset Pattern |
|------|-----------|-------------|---------------|
| Subscription | Claude Code, Codex, Copilot, Cursor | $10–200/mo | 5h rolling + weekly/monthly |
| Cheap | GLM-5.1, MiniMax M2.7, Kimi K2.5 | $0.2–$0.6/1M tokens | Daily/rolling/fixed monthly |
| Free | Kiro AI, OpenCode Free, Vertex AI | $0 | Unlimited |

### 📊 Real-Time Quota Tracking & Analytics

The web dashboard displays live token consumption per provider, reset countdown timers (5-hour, daily, weekly, monthly), and estimated cost tracking. While the dashboard shows "costs" as a reference comparison tool — 9Router itself is free software and never charges anything — the analytics help you understand usage patterns and optimize spending.

If your dashboard shows "$290 total cost" while using Kiro's free tier, that $290 represents what you would have paid if you used those APIs directly. Your actual payment remains $0. It's essentially a savings tracker showing how much money you're avoiding spending.

### 🔄 Format Translation Across Every Major Protocol

9Router translates between OpenAI, Claude, Gemini, Cursor, Kiro, Vertex AI, Antigravity, Ollama, and OpenAI Responses formats transparently. Your CLI tool sends a standard OpenAI-compatible payload; 9Router translates it into the native format each provider expects. This means you can use any tool supporting custom OpenAI endpoints and plug it into any backed provider.

### 👥 Multi-Account Support

Need load balancing or redundancy across accounts? 9Router lets you add multiple accounts per provider, with automatic round-robin distribution or priority-based routing. If one account hits its quota, requests automatically shift to the next available account. OAuth tokens refresh automatically, eliminating manual re-authentication cycles.

### 💾 Cloud Sync

Sync your entire configuration — providers, combos, aliases, settings — across devices via encrypted cloud storage. Set up your perfect combo on your local machine, then access the exact same configuration on your VPS, Docker deployment, or teammate's workstation.

## Supported Coding Tools and IDEs

9Router acts as a universal adapter, supporting virtually every popular AI coding tool:

- **Claude Code** (`~/.claude/config.json` with custom API base)
- **OpenAI Codex CLI** (environment variable override)
- **Cursor IDE** (Custom OpenAI endpoint settings)
- **GitHub Copilot**
- **OpenClaw** (WhatsApp, Telegram, Slack messaging)
- **Cline**
- **Continue**
- **Roo Code**
- **Antigravity**
- **Droid**
- **Kilo Code**
- **OpenCode**

Any tool that supports a custom OpenAI-compatible API endpoint can connect to 9Router. The service exposes a standard OpenAI-compatible interface at `http://localhost:20128/v1`.

## Getting Started: Installation and Setup

### Quick Start: Localhost (Recommended for Most Users)

```bash
# Clone and install
git clone https://github.com/decolua/9router.git
cd 9router
npm install
npm run build

# Optional environment setup
export JWT_SECRET="your-secure-secret-change-this"
export INITIAL_PASSWORD="your-dashboard-password"
export PORT="20128"
export NODE_ENV="production"

# Start the server
npm run start
```

After startup, open `http://localhost:20128` to access the web dashboard. From there, connect your first provider.

### Docker Deployment

For production or multi-device setups, Docker makes deployment trivial:

```bash
docker build -t 9router .

docker run -d \
  --name 9router \
  -p 20128:20128 \
  --env-file ./.env \
  -v 9router-data:/app/data \
  -v 9router-usage:/root/.9router \
  9router
```

### Connecting Your First Provider

Let's set up a complete free-tier combo — no payment methods required:

1. **Connect Kiro AI** in the dashboard (uses AWS Builder ID, Google, or GitHub OAuth — no API key needed)
2. **Connect OpenCode Free** (zero auth, passthrough proxy, models auto-fetched)
3. **Create a combo** named `free-dev` with models:
   - `kr/claude-sonnet-4.5` (Claude Sonnet 4.5 via Kiro — free unlimited)
   - `kr/glm-5` (GLM-5 via Kiro — free unlimited)
   - `vertex/gemini-3.1-pro-preview` (Google Cloud — $300 free credits)

Then configure your preferred tool to point at `http://localhost:20128/v1` with your dashboard API key:

```json
{
  "anthropic_api_base": "http://localhost:20128/v1",
  "anthropic_api_key": "your-9router-api-key"
}
```

### Configuring Cursor IDE

In Cursor Settings → Models → Advanced:

```
OpenAI API Base URL: http://localhost:20128/v1
OpenAI API Key: [copy from 9Router dashboard]
Model: cc/claude-opus-4-7
```

Now every model call from Cursor flows through 9Router's routing intelligence.

## Real-World Use Cases

### Scenario A: Maximize Your Existing Subscriptions

You pay $20/month for Claude Pro. Without 9Router, once the quota expires, coding stops until the reset.

With 9Router's "maximize-claude" combo:
- Primary: `cc/claude-opus-4-7` (use full subscription)
- Backup: `glm/glm-5.1` ($0.6/1M, resets daily at 10 AM)
- Emergency: `kr/claude-sonnet-4.5` (Kiro free fallback)

Result: Your $20 subscription lasts longer because RTK saves 20–40% tokens, and when it does expire, you have seamless backups. Total effective cost increases by roughly $5 for the cheap tier — far less than upgrading to Claude Max ($200/mo).

### Scenario B: Complete $0 Monthly Budget

Start with 100% free models:
- `gc/gemini-3-flash` (180K free queries/month from Google)
- `kr/claude-sonnet-4.5` (Kiro free unlimited)
- `oc/<auto>` (OpenCode Free, no authentication needed)

Combined with RTK compression, this setup delivers production-quality model responses with literally zero monthly cost.

### Scenario C: Uninterrupted 24/7 Development

For teams and freelancers under deadline pressure, layer five fallback tiers:
1. Claude Opus (premium quality)
2. GPT-5.5 via Codex (second subscription)
3. GLM-5.1 (cheap daily-reset)
4. MiniMax M2.7 (cheapest at $0.2/1M, 5h rolling reset)
5. Kiro Claude Sonnet 4.5 (free unlimited)

Five layers guarantee zero downtime regardless of quota exhaustion or provider outages.

## Pricing Transparency: How Much Will This Actually Cost?

A critical question for anyone evaluating 9Router: **does 9Router charge you?** No. Ever.

Here's how the economics actually work:

- **9Router software = FREE forever** (open-source MIT license, self-hosted on your own hardware)
- **Dashboard costs = display/tracking only** (not real billing statements)
- **You pay providers directly** (subscriptions, API keys, whatever you configure)
- **Free providers stay free** (Kiro AI, OpenCode Free, Vertex AI credits)

9Router is purely a local proxy router running on your own computer. It doesn't have access to your credit card, cannot generate invoices, and has no billing infrastructure. It simply forwards requests and optionally compresses tokens.

The dashboard's cost display serves as a "savings tracker" — showing you what equivalent usage would have cost using paid APIs directly. If you configure all free providers, the displayed cost might read "$290" while your actual bank transaction is $0. That $290 is the money you're actively saving.

## 9Router vs. Alternatives

How does 9Router compare to existing solutions?

| Feature | 9Router | Direct Provider Access | Other Proxy Tools |
|---------|---------|----------------------|------------------|
| Smart fallback routing | ✅ Auto 3+ tier | ❌ Single provider | Partial |
| Token compression (RTK) | ✅ Built-in | ❌ None | Rarely |
| Multi-format translation | ✅ 8+ protocols | N/A | Limited |
| Multi-account rotation | ✅ Round-robin | ❌ Manual | Manual |
| Free provider support | ✅ Kiro, OpenCode, Vertex | ❌ Not applicable | Usually not |
| Real-time analytics | ✅ Dashboard + logs | ❌ Provider portals | Basic |
| Self-hosted | ✅ Full control | N/A | Variable |
| Cost | Free software + provider costs | Full provider prices | Often paid |

The main alternative worth noting is **[OmniRoute](https://github.com/diegosouzapw/OmniRoute)**, a TypeScript fork of 9Router that adds 36+ providers, 4-tier auto-fallback, multi-modal APIs (images, embeddings, audio, TTS), circuit breaker patterns, semantic caching, LLM evaluation harnesses, and a polished dashboard with 368+ unit tests. OmniRoute is available via npm and Docker for users who want extended capabilities beyond the core 9Router feature set.

## Why 9Router Matters Right Now

We're living through a golden age of AI coding tools, but the economic reality hasn't caught up. Each major provider independently restricts access behind paywalls, quota limits, and rate caps. Managing six different subscriptions across Claude, OpenAI, Google, Anthropic, DeepSeek, and xAI creates both financial burden and operational complexity.

9Router solves this by treating all these providers as interchangeable commodities routed through a single intelligence layer. You get the best model for each task, the cheapest path for routine ones, and guaranteed availability when quotas run dry — all while compressing token waste before it ever leaves your machine.

The combination of RTK token compression (~20–40% savings), Caveman mode output reduction (~65% savings), and intelligent multi-tier fallback creates a compounding effect. Developers reporting 500+ daily API calls see their effective model consumption drop by 40–60%, transforming a $200/month AI stack into something manageable at $20–30.

## Technical Architecture Highlights

9Router is built on a modern JavaScript stack optimized for reliability:

- **Runtime**: Node.js 20+ for consistent, performant async I/O
- **Framework**: Next.js 16 with React 19 for the web dashboard
- **Database**: LowDB (JSON file-based) — simple, portable, version-controllable config
- **Streaming**: Server-Sent Events (SSE) for real-time progress feedback
- **Auth**: OAuth 2.0 with PKCE, JWT session cookies, HMAC-signed API keys
- **Proxy**: Full HTTP passthrough with configurable upstream proxies

Environment variables give granular control over deployment:
- `JWT_SECRET`: Change for production security
- `REQUIRE_API_KEY`: Enforce bearer token auth on `/v1/*` routes
- `ENABLE_REQUEST_LOGS`: Enable debug-level request/response logging
- `AUTH_COOKIE_SECURE`: Force Secure cookie flag behind HTTPS reverse proxy
- `HTTP_PROXY` / `HTTPS_PROXY`: Route upstream requests through corporate proxies

The service listens on port `20128` by default and requires no external dependencies or databases beyond the JSON files stored in `${DATA_DIR}`.

## Final Thoughts

9Router addresses a genuinely painful problem that more developers are feeling as AI tool subscriptions multiply. Rather than accepting escalating costs and arbitrary rate limits as the inevitable price of AI-assisted development, 9Router flips the script: use whatever providers you already have, fill gaps with cheap or free alternatives, compress everything possible, and maintain continuous coding flow regardless of quota state.

For solo developers on tight budgets, the free-first strategy can deliver fully functional AI coding assistance at exactly $0. For teams willing to invest in premium subscriptions, the token compression and smart routing maximize ROI by ensuring every dollar spent stretches further.

It's free, open-source, and takes minutes to self-host. Given the current trajectory of AI tool pricing, adding 9Router to your development infrastructure probably isn't just useful — it's becoming essential.

**Repository**: [github.com/decolua/9router](https://github.com/decolua/9router)
**Website**: [9router.com](https://9router.com)

---

## Related Articles


- [GenericAgent: Self-Evolving AI Agent Framework](/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)
- [Anthropic's Financial Services: AI-Powered Claude Agents](/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)

- [Addy Osmani's Agent Skills: Production-Grade AI Coding Agents](/resources/llm-frameworks/agent-skills-production-grade-ai-coding/)

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "footer-cta-legacy" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Single key access to multiple top models at ~30% of official pricing; particularly useful when comparing models or when direct API access is rate-limited in your region.

*Affiliate link — supports dibi8.com at no cost to you.*

<!--auto-references-->
## References & Sources

- [9Router](https://github.com/decolua/9router)
- [RTK](https://github.com/rtk-ai/rtk)
- [Caveman](https://github.com/JuliusBrussee/caveman)
- [OmniRoute](https://github.com/diegosouzapw/OmniRoute)
