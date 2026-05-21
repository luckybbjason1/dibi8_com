---
title: 'The Cheap LLM Stack 2026: How to Run Production AI on $0-15/Month Using Free Tiers and Token Compression'
description: '5-component stack to run real AI workloads on $0-15/month: Ollama local + DeepSeek API + Gemini free tier + RTK compression + 9Router orchestration. Real cost math, model picks per task type, assembly order.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - Docker
  - Go
  - Rust
application_domain: Collections
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['Cheap LLM', 'Free Tier', 'Cost Optimization', 'Stack', 'Collection']
aliases:
  - /posts/cheap-llm-stack/
---

Most "LLM cost optimization" advice is just "use the cheaper model." This collection is more ambitious: **a 5-component stack that handles real production workloads — coding agents, content generation, search, basic agents — for $0-15/month total.** Not a hobby setup. Not "good for 100 requests/day." Real, daily-driver inference at SaaS-killer prices.

The trick isn't any single tool — it's the orchestration. Free tiers cap requests, not output. Local models cap quality, not requests. Token compression cuts billable spend. Smart routing sends each task to its cheapest competent provider. Combined, the math gets absurd.

## TL;DR — The Stack at a Glance

| # | Component | Cost | Role | Deep dive |
|---|---|---|---|---|
| 1 | **Ollama** (local) | $0 | Heavy/sensitive workloads on your hardware | [Ollama guide](/resources/llm-frameworks/ollama/) |
| 2 | **DeepSeek API** | $2-8/mo | Cheap inference for hard tasks ($0.27/M input vs $3 Claude) | [DeepSeek vs OpenAI](/resources/llm-frameworks/deepseek-ds4-vs-openai-api.md) |
| 3 | **Gemini CLI free tier** | $0 | 1,000 req/day for general LLM tasks, free | [AI Search Tools](/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/) |
| 4 | **RTK proxy** | $0 (self-host) | Compress prompts 20-40% before they hit billable APIs | [RTK setup](/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/) |
| 5 | **9Router** | $0 (self-host) | Auto-route per task to cheapest competent provider | [9Router guide](/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |

**Total monthly cost** (light: 100 calls/day): **$0-3** • **Medium** (500 calls/day): **$2-8** • **Heavy** (2000 calls/day): **$5-15**

Compare against pure-API at the same volume: $40 / $200 / $800 respectively. **20-50× cost reduction** at production scale.

## 1. Why "Cheap" Got Viable in 2026

Three things shifted in the last 12 months:

1. **DeepSeek-V4 hit Claude Sonnet quality at 1/10 the price** ($0.27/M vs $3/M input). For 80% of tasks the quality gap doesn't matter.
2. **Free tiers got serious**: Gemini gives 1,000 free requests/day, GLM-4.6 ships a free tier, OpenRouter rotates community-sponsored free models. Combined budget = ~3,000 free calls/day.
3. **RTK (Repetition-Token Compression) works**: removes the 20-40% of tokens that are pure redundancy (file headers, system prompts repeated 10× per session).

Stack the three — local fallback + cheap API + free tier rotation + compression — and the cheapest-quality frontier moves dramatically.

## 2. Architecture — The Smart Router Pattern

```
   Your app
       │
       ▼
   9Router (decides where each call goes)
       │
       ├─► Local Ollama         (sensitive / offline / draft work)
       │
       ├─► RTK proxy → DeepSeek (hard tasks needing quality, compressed)
       │
       ├─► Gemini free tier     (1k req/day, easy tasks)
       │
       └─► OpenRouter free      (rotating community models, experiments)
```

Each provider has a "specialty zone." 9Router (or a 10-line Python wrapper if you don't want another service) inspects the task and routes accordingly.

## 3. Component 1 — Ollama (Local, $0)

**The role**: Anything sensitive, anything you don't want billed, anything draft-quality.

**Realistic on consumer hardware** (2026 numbers):
- **8 GB RAM** (M1 / mid-range PC): Llama 3.2 3B at 20+ tok/s — fine for autocomplete, classification, draft writing
- **16 GB RAM** (M2/M3 / decent PC): Qwen 3 Coder 14B at 15 tok/s — production coding work
- **32 GB RAM** (Mac Studio / workstation): Llama 3.3 70B Q4 at 8 tok/s — Claude Sonnet-class quality for the patient

**Free, forever, no rate limits**. The only cost is the electricity to run your machine.

Full installation + model picks: [Ollama production guide](/resources/llm-frameworks/ollama/).

## 4. Component 2 — DeepSeek API ($2-8/Month)

**The role**: When local isn't good enough, this is your default paid provider.

**Why this beats everyone on price/quality**:
- $0.27/M input tokens (DeepSeek-V4) vs $3/M (Claude Sonnet) vs $2.50/M (GPT-5)
- Code benchmark gap to Claude Sonnet: ~5% on average
- Off-peak hours offer additional 50% discount (UTC 16:30-00:30)

**The honest tradeoff**: Slightly more hallucination on niche topics. Slightly slower on cold start. Worth it for 11× cost saving on bulk inference.

**Quick start** — sign up at platform.deepseek.com, $10 of credits lasts most solo devs 2-3 months.

Full setup + when to *not* use DeepSeek: [DeepSeek-V4 vs OpenAI API comparison](/resources/llm-frameworks/deepseek-ds4-vs-openai-api/).

## 5. Component 3 — Gemini CLI Free Tier ($0)

**The role**: Free 1,000 requests/day for general tasks (Q&A, summarization, simple coding).

**The math**: 1,000 calls/day × 30 days = 30,000 calls/month for free. If you burn through it before midnight UTC, fall back to DeepSeek for the rest.

**The catch**: Google logs your prompts for "model improvement" on free tier — don't send proprietary code or PII.

**Quick install**:
```bash
npm install -g @google/gemini-cli
gemini auth login  # opens browser, uses your Google account
gemini "explain this regex: /^[a-z]+$/i"
```

Or hit the API directly via Gemini REST endpoints — same 1,000/day budget.

Companion overview of Gemini vs Perplexity vs ChatGPT free tiers and where each wins: [AI Search Tools comparison](/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/).

## 6. Component 4 — RTK Proxy ($0, Self-Host)

**The role**: Sit between your app and any paid API. Compress repeated content (system prompts, file headers, doc snippets) before each call. **Bills 20-40% less without changing your code.**

**The mechanism**: Semantic dedup. If you send the same 2,000-token system prompt 50 times today, RTK recognizes it on call #2 and ships a pointer instead of the full text.

**Quick install**:
```bash
docker run -d --name rtk -p 8765:8765 \
  ghcr.io/rtk-ai/rtk:latest
```

Then change your API base URL from `https://api.deepseek.com/v1` to `http://localhost:8765/v1/deepseek`. Done.

Full deep dive on how RTK works + benchmarks: [RTK Rust CLI proxy + token saver](/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/).

## 7. Component 5 — 9Router ($0, Self-Host)

**The role**: The orchestrator. Decides which provider gets each call based on task type, budget remaining, and provider availability.

**Why you need it**: Without 9Router, you manually pick a provider per call. With 9Router, you set rules once ("coding tasks → DeepSeek via RTK, simple Q&A → Gemini free, fallback → Ollama") and forget it.

**Bonus**: 9Router includes its own RTK compression layer for premium providers, plus auto-fallback when a free tier hits its daily cap.

**Quick install**:
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=ollama,deepseek,gemini,openrouter \
  ghcr.io/rtk-ai/9router:latest
```

Full configuration + free-tier coding combo recipes: [9Router smart proxy guide](/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/).

## 8. The Routing Table — Who Handles What

A workable default routing config for solo devs:

| Task type | Provider | Why |
|---|---|---|
| Inline code completion | **Ollama** (Qwen 3 Coder 14B local) | Latency matters more than quality |
| Code generation (function-scope) | **DeepSeek-V4 via RTK** | Quality matters, compress to save |
| Multi-file refactor | **DeepSeek-V4 via RTK** or **Claude** fallback | Hard task, fall back to premium if DeepSeek struggles |
| General Q&A / explain code | **Gemini free tier** | Free, fast, good enough |
| Web search + cite | **Gemini free tier** (built-in grounding) | Free vs $20/mo Perplexity Pro |
| Sensitive code review | **Ollama** local | Never leaves your machine |
| Bulk content gen (1000+ articles) | **DeepSeek-V4 off-peak** | Cheap × 50% off-peak = $0.135/M |
| Simple agent (Slack bot, scheduler) | **Gemini free tier** | Easy tasks, 1k/day plenty |

## 9. The $0-15/Month Math

**Light usage** (solo dev, 100 calls/day average):
- Gemini free covers ~70% of calls → $0
- DeepSeek for the other 30% (~900 calls/mo, mostly small) → $1-3
- Ollama for sensitive (no API cost) → $0
- **Total: $1-3/month** (vs $40+ pure API)

**Medium usage** (500 calls/day, including some coding):
- Gemini free: still ~1000 calls/day available
- DeepSeek for serious coding: ~3000 calls/mo with RTK compression → $3-8
- Ollama for fallback → $0
- **Total: $3-8/month** (vs $200+ pure API)

**Heavy usage** (2000 calls/day, agent workflows):
- Gemini exhausted by 10am, fallback kicks in
- DeepSeek heavy load, RTK saves ~30% → $5-12
- Off-peak batch jobs → additional 50% saved
- Ollama handles bulk classification, sensitive → $0
- **Total: $5-15/month** (vs $800+ pure API)

## 10. Day 1 Setup Order (60 minutes)

1. **Ollama** (15 min) — Install, pull Llama 3.2 3B + Qwen 3 Coder 14B
2. **DeepSeek account** (5 min) — Sign up, get API key, top up $10
3. **Gemini CLI** (5 min) — `npm i -g @google/gemini-cli`, auth with Google
4. **RTK proxy** (10 min) — Docker run, point at DeepSeek
5. **9Router** (10 min) — Docker run, configure 4 providers
6. **Test routing** (15 min) — Send 5 different task types, verify each hits expected provider

After 60 minutes you have a real production-grade cheap-LLM router on your machine.

## 11. When to Upgrade (and to What)

The $0-15 stack works until you hit any of:

- **Latency requirement < 500ms** — Add Claude/GPT-5 for the hot path (still keep DeepSeek for batch)
- **Compliance requires US-data-only providers** — Drop DeepSeek + Gemini, use OpenRouter with provider filtering or self-host more
- **Bulk workload requires SLA** — Add a managed LiteLLM gateway with multiple paid providers + retry logic (see [LiteLLM gateway 2026](/resources/llm-frameworks/litellm/))
- **You want full observability** — Add Portkey ($49 platform fee at $1k spend, see [Portkey vs LiteLLM 2026](/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/))

The point: this stack is *not* the ceiling. It's the floor that lets you scale spend deliberately instead of being forced into $200/mo SaaS bundles from day one.

## TL;DR — The Recipe

**5 tools, $0-15/mo, 60-min setup**:
1. **Ollama** — local & sensitive
2. **DeepSeek-V4** — cheap API for hard tasks
3. **Gemini CLI free tier** — 1k req/day free general LLM
4. **RTK proxy** — 20-40% token savings on billable APIs
5. **9Router** — smart routing orchestrator

Stack pays for itself if you currently spend $30+/mo on any AI SaaS. Spin it up on your laptop (no VPS needed for cheap-LLM specifically — though a {{< aff "digitalocean" "footer-cta" "$6/mo DigitalOcean droplet" >}} helps if you want it always-on for a team).

---

*Pair this collection with [Self-Hosted AI Coding Workflow](/collections/self-hosted-ai-coding-workflow/) if you want the full coding stack — they share Ollama + 9Router + RTK as a foundation.*
