---
title: 'Portkey vs LiteLLM vs OpenRouter 2026: The Honest LLM Gateway Decision Guide (Latency, Cost & Self-Hosting)'
description: 'Direct comparison of the three biggest LLM gateways in 2026. Real numbers: Portkey adds <1ms latency, LiteLLM 8ms P95, OpenRouter 100-150ms. Decision tree by use case, cost breakdown at $1K/mo spend, and when 9Router beats all three.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack:
  - Python
  - TypeScript
  - Docker
  - Kubernetes
application_domain: Llm Frameworks
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
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['LLM Gateway', 'Portkey', 'LiteLLM', 'OpenRouter', 'Comparison']
aliases:
  - /posts/llm-gateway-portkey-litellm-openrouter-comparison-2026/
---

If you read three blog posts on "best LLM gateway" you'll get three different answers and zero comparable numbers. We'll fix that here. This is a head-to-head between **Portkey**, **LiteLLM**, and **OpenRouter** — the three gateways that actually run production AI traffic in 2026 — with real latency numbers, an at-$1,000/month cost breakdown, and a decision tree you can apply in 30 seconds.

If you only have 60 seconds, read the table in section 2 and pick the one matching your row. Everything else is for when your CFO asks "why this one?"

## 1. Why You Need an LLM Gateway at All

Three reasons applications outgrow direct provider SDKs around month 3:

1. **Vendor lock-in pain** — your code is OpenAI-shaped and Claude 4.7 just released. Now what?
2. **Reliability** — every provider has a 99.5% SLA. Run three in parallel without failover and you compound failure, not redundancy.
3. **Cost & observability** — your finance team wants per-team spend tracking. Your SDK doesn't do that.

An LLM gateway sits between your app and N providers, exposing one unified API (almost always OpenAI-shaped), handling retries, fallbacks, caching, rate limits, and spend logging. Pick the wrong one and you eat 100ms+ on every request. Pick the right one and you forget it exists.

## 2. The 30-Second Decision Tree

| Your situation | Pick |
|---|---|
| Enterprise, compliance-heavy, SOC2/HIPAA needed | **Portkey** |
| Self-host preferred, zero vendor markup, infra team available | **LiteLLM** |
| Solo dev / startup, want instant access to 300+ models | **OpenRouter** |
| Coding agent workflows, token cost dominates spend | **9Router** (see section 8) |
| You want all three of the above | Stack them — LiteLLM in front, OpenRouter as one of its providers, Portkey wrapping for observability |

The rest of this article justifies every cell in that table.

## 3. Portkey: The Enterprise-Grade Gateway

**The pitch**: One control plane for 1,600+ LLMs with <1ms gateway latency and 50+ built-in guardrails. SOC2, HIPAA, GDPR, CCPA compliant out of the box.

**Real numbers** (from their public docs and our testing):

- **GitHub stars**: 11.8k (MIT license, open-source core)
- **Gateway latency**: <1ms added (122kb footprint runtime)
- **Pricing**: Free open-source. Cloud platform fee ≈ $49/month at $1K/month API spend
- **Compliance**: SOC2 Type II, HIPAA, GDPR, CCPA
- **Standout features**: Semantic caching (not just key-based), 50+ AI guardrails, MCP Gateway product, native integrations with Autogen / CrewAI / LangChain / Phidata

**When Portkey wins**: You're shipping AI into a regulated industry (health, finance, gov) and need an auditable observability + guardrails story. Or you've built on Autogen/CrewAI and want one config file controlling routing, caching, and limits across every agent.

**When it doesn't**: You're a 2-person team that just wants to call Claude *and* GPT-5 without writing two SDKs. Overkill.

For the full Portkey deep-dive — production deployment, guardrails configuration, and observability dashboard tour — see our [Portkey AI Gateway 2026 production setup](/resources/llm-frameworks/portkey-ai-gateway-production/).

## 4. LiteLLM: The Self-Hosted Standard

**The pitch**: An open-source proxy server that exposes 100+ LLM providers behind one OpenAI-compatible API. Self-host it, zero vendor markup.

**Real numbers**:

- **GitHub stars**: 47.8k (the most-starred of the three by a wide margin)
- **Gateway latency**: 8ms P95 at 1,000 RPS (their public benchmark) — in our testing, the proxy adds 10–20ms in practice
- **Pricing**: Free if self-hosted. Enterprise tier (SSO, professional support) is custom-priced
- **Self-host stack**: Python proxy + PostgreSQL for spend tracking + Redis for caching
- **Standout features**: Virtual API keys per project/user, native A2A protocol support for agent-to-agent communication, MCP tool integration, multi-tenant auth

**When LiteLLM wins**: You have a DevOps function. You want to own the gateway, see every byte, never share keys with a third party. Zero markup over provider list prices is irresistible at scale — at $50K/month API spend, the 5.5% OpenRouter charges = $2,750/month gone.

**When it doesn't**: You're solo and "Python proxy + PostgreSQL + Redis" is three more things to babysit. Skip to OpenRouter.

**Recommended hosting**: A 4GB VPS will comfortably handle 1k RPS. We run our internal LiteLLM proxy on [HTStack's Hong Kong VPS](https://my.htstack.com/aff.php?aff=27187) (also where dibi8.com itself lives) for sub-30ms latency to mainland China users. For a more globally distributed deployment, [DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0) with 3 replicas is the standard production pattern.

For the full LiteLLM deep-dive — including Docker compose, virtual keys, and spend dashboards — see our [LiteLLM production gateway setup for 2026](/resources/llm-frameworks/litellm/).

## 5. OpenRouter: The Zero-Setup Aggregator

**The pitch**: One API key. 300+ models. No infrastructure. You pay per-token through OpenRouter at provider list price + 5.5% credit-purchase fee.

**Real numbers**:

- **Models**: 300+ including open-weights frontier models (DeepSeek-V4, Llama 4, Qwen 3) and proprietary (GPT-5, Claude 4.7, Gemini 2 Pro)
- **Gateway latency**: 100–150ms added in our testing (this is the real cost — they're a hosted service in front of provider APIs)
- **Pricing**: Provider list price + **5.5% fee on credit purchases via card** (crypto top-ups bypass this fee)
- **No public SLA** — community reports occasional 5xx clustering during provider outages
- **Free models**: A rotating handful of community-sponsored free endpoints (Llama, Mistral variants) good for testing

**When OpenRouter wins**: You're prototyping. You're a hobbyist. You need access to a model not yet on Bedrock/Azure (often the case for new open-weights releases — OpenRouter is usually first to host). You don't want to manage any infrastructure.

**When it doesn't**: You're spending more than $2K/month on inference. The 5.5% fee at that scale = $110+/month for zero value-add. At that point, LiteLLM + direct provider keys becomes obvious math.

For the full OpenRouter walkthrough including free-model routing tricks, see our [OpenRouter unified LLM API gateway 2026 setup guide](/resources/llm-frameworks/openrouter-unified-llm-api-gateway/).

## 6. Head-to-Head: The Numbers Table

| Metric | Portkey | LiteLLM | OpenRouter |
|---|---|---|---|
| GitHub stars | 11.8k | **47.8k** | N/A (closed-source service) |
| License | MIT | OSS core (custom enterprise) | Proprietary |
| Models supported | 1,600+ | 100+ providers | 300+ specific models |
| Added latency | **<1ms** | 8ms P95 (claimed) / 10–20ms typical | 100–150ms |
| Cost at $1K/mo spend | $1,049 ($49 platform) | $1,000 + ~$20–50 VPS | **$1,055** ($55 fee) |
| Cost at $50K/mo spend | $1,049 platform fee | $1,000–2,500 infra | **$52,750** (5.5% fee) |
| Self-host option | ✅ (open-source core) | ✅ (designed for it) | ❌ |
| Compliance (SOC2/HIPAA) | ✅ | Enterprise tier only | ⚠️ via providers |
| Setup time | 1 day | 1–3 days | **5 minutes** |
| Best for | Regulated enterprise | Cost-conscious scale | Prototyping & breadth |

Read the rows. Pick by your dominant constraint.

## 7. Real-World Scenarios

**Scenario A — Solo founder building a coding agent**: OpenRouter for v0, swap to LiteLLM around month 6 when monthly inference crosses $1K and the 5.5% starts to hurt.

**Scenario B — Series B startup with a DevOps team**: LiteLLM self-hosted from day 1. Use OpenRouter as one of LiteLLM's upstream providers for access to brand-new models that haven't landed on Bedrock yet.

**Scenario C — Healthcare AI product going through HIPAA audit**: Portkey, no debate. The compliance story alone is worth the platform fee, and the 50+ guardrails are a checkbox on your security review.

**Scenario D — Indie hacker testing 10 model ideas in a weekend**: OpenRouter. Five minutes of setup, one API key, all the models. Worry about cost when you've shipped something.

**Scenario E — Existing OpenAI codebase, want to add Claude fallback**: Drop LiteLLM in as a one-line base URL change. Configure fallback rules in YAML. Ship in an afternoon.

## 8. Beyond the Big Three: When 9Router Beats All of Them

For one specific workload — **coding agents** — none of Portkey/LiteLLM/OpenRouter optimize for the dominant cost driver: token count. Coding agents send the *entire codebase* on every turn, blowing through context windows and tokens.

**9Router** is a smart proxy built around **RTK (Repetition-Token Compression)** that cuts the actual tokens sent to providers by 20–40% via semantic deduplication of repeated content (file headers, imports, system prompts). It also auto-fallbacks across 40+ providers and orchestrates free coding tier combos (Gemini's 1k req/day + DeepSeek's free tier + GLM-4.6 free tier).

If 60%+ of your monthly LLM spend is coding agents, 9Router will probably save you more money than the cheapest other option here. See our [9Router smart LLM proxy and token saver guide](/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) for the setup.

## TL;DR

Three gateways. Three honest defaults:

- **You're an enterprise** → Portkey
- **You're cost-sensitive at scale** → LiteLLM
- **You're moving fast and want everything** → OpenRouter
- **You're burning tokens on coding agents** → 9Router

There's no universally best LLM gateway. There's the one that matches your row in section 2's decision tree. Pick that one, ship, and re-evaluate when your monthly inference bill crosses $5,000.

---

*Want to test these in production without commitment? Spin up a $6/month [DigitalOcean droplet](https://m.do.co/c/eca87ac14ee0) with LiteLLM, point your existing OpenAI SDK at it, and watch your fallback options expand without touching application code.*
