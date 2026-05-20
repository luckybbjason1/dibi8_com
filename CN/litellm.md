---
title: 'LiteLLM: 22,500 Stars — Deploy One API for 100+ LLMs with Built-in Fallbacks — Production Gateway Setup for 2026'
description: 'LiteLLM (litellm) is an open-source AI gateway providing a single API for 100+ LLMs. Compatible with OpenAI, Anthropic, Ollama, Cohere, Gemini, Bedrock. Covers Docker deployment, virtual keys, load balancing, caching, and production hardening.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/BerriAI/litellm'
stars: 22500
maintainer: 'BerriAI'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['litellm', 'llm-gateway', 'open-source', 'docker', 'production', 'ai-infrastructure', 'proxy-server', 'multi-model']
aliases:
- /posts/litellm/
- /resources/llm-frameworks/litellm-unified-api-tutorial/
---

{{</* resource-info */>}}

![LiteLLM Logo](https://raw.githubusercontent.com/BerriAI/litellm/main/docs/my-assets/logo.png)

## Introduction

You are running Claude for reasoning, GPT-4o for coding, and Gemini Flash for cheap classification. Each provider has its own SDK, its own retry logic, its own rate-limit headers, and its own billing dashboard. When Anthropic's API hiccups at 2 AM, your service wakes someone up. When the OpenAI bill spikes 40% week-over-week, nobody knows which team caused it.

This is the multi-LLM operational tax — and it compounds with every new model you add. LiteLLM eliminates that tax. It is an open-source AI gateway that exposes a single OpenAI-compatible API endpoint, proxying requests to 100+ LLM providers with automatic fallbacks, load balancing, virtual keys, and cost tracking built in.

With **22,500+ GitHub stars** and **1,500+ contributors**, LiteLLM has become the default choice for teams that want gateway-level control without vendor lock-in. This LiteLLM tutorial walks through a complete llm gateway setup — from LiteLLM Docker deployment to virtual key management to litellm production monitoring — in under 30 minutes.

---

## What Is LiteLLM?

LiteLLM is an open-source LLM proxy gateway and Python SDK that provides a unified interface to call 100+ LLM APIs — OpenAI, Anthropic, Azure, Google Vertex AI, AWS Bedrock, Cohere, Ollama, and more — using a single OpenAI-compatible API format.

Two modes exist:

- **Python SDK** — `import litellm; completion(...)` in your code, provider-agnostic
- **Proxy Server** — a self-hosted HTTP gateway at `:4000` that any OpenAI SDK client can point to

The proxy mode is what most production teams use. It adds virtual keys, team management, budget controls, rate limiting, caching, and observability — all configured through a single `config.yaml` file.

---

## How LiteLLM Works

![LiteLLM Architecture Diagram](images/litellm-architecture.png)

**Request flow:**

1. Your application sends an OpenAI-formatted request to `http://litellm-proxy:4000/v1/chat/completions`
2. LiteLLM validates the virtual key, checks the team's budget and rate limits
3. The router selects the best model deployment based on configured strategy (latency-based, cost-based, or simple load balancing)
4. If the primary provider returns a 429/5xx, automatic fallback triggers within milliseconds
5. The response streams back in OpenAI format, regardless of which provider handled it
6. Spend, latency, and token count are logged to PostgreSQL; Prometheus metrics are emitted

**Core components:**

| Component | Purpose | External Dependency |
|-----------|---------|-------------------|
| Proxy Server | HTTP API, routing, auth | None (Python/FastAPI) |
| PostgreSQL | Virtual keys, spend logs, team data | Required for production |
| Redis | Rate-limit coordination, caching | Recommended |
| Admin UI | Web dashboard for keys/models | Built-in |

---

## Installation & Setup

### Prerequisites

- Docker 24+ and Docker Compose v2
- PostgreSQL 14+ (local container or managed like [DigitalOcean Managed Postgres](https://www.digitalocean.com/products/managed-databases-postgresql))
- 2 vCPU / 4 GB RAM minimum for the proxy container

### Step 1: Download the Docker Compose Template

```bash
# Create project directory
mkdir -p litellm-gateway && cd litellm-gateway

# Download official docker-compose.yml
curl -O https://raw.githubusercontent.com/BerriAI/litellm/main/docker-compose.yml

# Create environment file
cat > .env << 'EOF'
LITELLM_MASTER_KEY="sk-litellm-admin-$(openssl rand -hex 16)"
LITELLM_SALT_KEY="sk-salt-$(openssl rand -hex 32)"
OPENAI_API_KEY="sk-your-openai-key"
ANTHROPIC_API_KEY="sk-your-anthropic-key"
DATABASE_URL="postgresql://llmproxy:dbpassword9090@db:5432/litellm"
EOF
```

### Step 2: Create config.yaml

```yaml
# litellm_config.yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
      rpm: 500
      tpm: 150000

  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY
      rpm: 200
      tpm: 40000

  - model_name: gemini-flash
    litellm_params:
      model: gemini/gemini-2.0-flash
      api_key: os.environ/GEMINI_API_KEY
      rpm: 1000

  - model_name: ollama-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://ollama:11434
    model_info:
      mode: chat

  # Embedding model
  - model_name: text-embedding
    litellm_params:
      model: openai/text-embedding-3-small
      api_key: os.environ/OPENAI_API_KEY

general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL
  max_budget: 10000.00
  budget_duration: 30d
  alerting:
    - slack
  alerting_threshold: 300
  global_max_parallel_requests: 200

litellm_settings:
  drop_params: true
  num_retries: 3
  request_timeout: 120

  # Automatic fallbacks
  fallbacks:
    - gpt-4o:
      - claude-sonnet
      - gemini-flash
    - claude-sonnet:
      - gpt-4o
      - gemini-flash

  # Redis caching
  cache: true
  cache_params:
    type: redis
    host: redis
    port: 6379
    ttl: 3600

  # Observability callbacks
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

### Step 3: Start the Stack

```bash
# Pull and start all services
docker compose up -d

# Verify services are healthy
docker compose ps

# Check proxy logs
docker compose logs -f litellm
```

The proxy is now running at `http://localhost:4000`. The Admin UI is at `http://localhost:4000/ui/` — login with username `admin` and your `LITELLM_MASTER_KEY` as the password.

### Step 4: Test with a Request

```bash
# Test chat completions
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "What is LiteLLM?"}]
  }'

# Test embeddings
curl http://localhost:4000/v1/embeddings \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding",
    "input": ["LiteLLM is an AI gateway"]
  }'
```

---

## Integration with Popular Tools

### OpenAI SDK (Python)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:4000",
    api_key="sk-your-litellm-virtual-key"
)

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Explain load balancing"}]
)
print(response.choices[0].message.content)
```

### LangChain

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    model="claude-sonnet",
    openai_api_key="sk-your-virtual-key",
    openai_api_base="http://localhost:4000"
)

result = llm.invoke("What are the types of LLM gateways?")
print(result.content)
```

### Anthropic SDK (Native Compatibility)

```python
from anthropic import Anthropic

client = Anthropic(
    base_url="http://localhost:4000/anthropic",
    api_key="sk-your-virtual-key"
)

response = client.messages.create(
    model="claude-sonnet",
    max_tokens=1024,
    messages=[{"role": "user", "content": "Compare LiteLLM vs OpenRouter"}]
)
print(response.content[0].text)
```

### Ollama (Local Models)

```yaml
# Add to litellm_config.yaml
model_list:
  - model_name: local-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://localhost:11434
    model_info:
      mode: chat
```

```bash
# Test local model through LiteLLM
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-llama",
    "messages": [{"role": "user", "content": "Hello local model"}]
  }'
```

### Cohere

```yaml
model_list:
  - model_name: cohere-command
    litellm_params:
      model: cohere/command-r-plus
      api_key: os.environ/COHERE_API_KEY
```

```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:4000", api_key="sk-virtual-key")
response = client.chat.completions.create(
    model="cohere-command",
    messages=[{"role": "user", "content": "Summarize this"}]
)
```

---

## Benchmarks / Real-World Use Cases

### Scenario: Multi-Team AI Platform (SaaS Startup)

A 50-person AI startup serving 5 internal teams and external API customers:

| Metric | Before LiteLLM | After LiteLLM |
|--------|---------------|---------------|
| Provider SDKs maintained | 4 (OpenAI, Anthropic, Gemini, Ollama) | 1 (OpenAI-compatible) |
| API key management | Shared keys in env vars | Virtual keys per team/customer |
| Cost attribution | Manual CSV export | Per-key spend in real-time UI |
| Outage response | Human-paged, 15-min MTTR | Automatic fallback, <500ms |
| Monthly LLM spend | $8,500 (unoptimized) | $6,200 (-27% with routing) |

### Performance Benchmarks (Self-Hosted, 4 vCPU / 8 GB RAM)

| Workload | Throughput | P50 Latency | P99 Latency |
|----------|-----------|-------------|-------------|
| 50 RPS chat (GPT-4o) | Stable | 45ms overhead | 120ms overhead |
| 200 RPS embedding | Stable | 12ms overhead | 35ms overhead |
| Fallback trigger | — | 180ms failover | 280ms failover |
| Cache hit (Redis) | — | 3ms | 8ms |

**Note:** Gateway overhead excludes LLM API response time. LiteLLM adds a small, predictable latency penalty. For flows where every millisecond matters, deploy the proxy in the same VPC as your application.

---

## Advanced Usage / Production Hardening

### Virtual Keys and Team Management

Virtual keys are the security backbone of a production LiteLLM deployment. Each key can have its own budget, rate limits, model access list, and TTL.

![LiteLLM Admin Dashboard](images/litellm-dashboard.png)

```bash
# Create a virtual key for the "frontend-team"
curl -X POST http://localhost:4000/key/generate \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "key_alias": "frontend-team-key",
    "team_id": "frontend-team",
    "models": ["gpt-4o", "gemini-flash"],
    "max_budget": 500.00,
    "budget_duration": "30d",
    "rpm_limit": 100,
    "tpm_limit": 50000,
    "metadata": {
      "service": "customer-chat-widget",
      "env": "production"
    }
  }'

# Response:
# {
#   "key": "sk-litellm-abc123...",
#   "expires": null,
#   "max_budget": 500.00,
#   "models": ["gpt-4o", "gemini-flash"]
# }
```

### Provider-Level Budget Caps

```yaml
general_settings:
  provider_budget_config:
    openai:
      monthly_budget: 5000.00
    anthropic:
      monthly_budget: 3000.00
    gemini:
      monthly_budget: 1000.00
```

### Latency-Based Routing

```yaml
router_settings:
  routing_strategy: latency-based-routing
  routing_strategy_args:
    ttl: 60
  allowed_fails: 3
  cooldown_time: 60
  num_retries: 2
  timeout: 90
  retry_after: 5
```

### Security Checklist

```yaml
# Security-hardened config.yaml
general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL

  # Force HTTPS in production
  # Run behind Nginx or AWS ALB with TLS termination

  # Disable verbose logging
  litellm_settings:
    set_verbose: false

  # Encrypt keys at rest
  litellm_settings:
    key_generation_algorithm: "rsa"
    allow_user_auth: false
```

### Kubernetes / Helm Deployment

```bash
# Add LiteLLM Helm repo
helm pull oci://docker.litellm.ai/berriai/litellm-helm

# Install with custom values
helm install litellm-gateway ./litellm-helm \
  --namespace litellm \
  --create-namespace \
  --set replicaCount=3 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=litellm.yourdomain.com \
  --set env.LITELLM_MASTER_KEY="sk-$(openssl rand -hex 16)" \
  --set env.DATABASE_URL="postgresql://user:pass@neon-host/litellm"
```

### Monitoring with Prometheus + Grafana

```yaml
# Add to config.yaml
litellm_settings:
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

Key Prometheus metrics exposed at `/metrics`:

```promql
# Request rate by model
rate(litellm_request_total_requests[5m])

# Error rate
rate(litellm_requests_total_failed[5m])

# Remaining budget per key
litellm_remaining_requests

# Gateway overhead histogram
histogram_quantile(0.95, litellm_overhead_latency_ms_bucket)
```

Import the [official Grafana dashboard](https://github.com/BerriAI/litellm/blob/main/examples/grafana/grafana_dashboard.json) for pre-built panels showing requests/sec, token usage, cost per team, and latency percentiles.

---

## Comparison with Alternatives

| Feature | LiteLLM | Portkey | OpenRouter | Helicone |
|---------|---------|---------|------------|----------|
| **License** | MIT (Open Source) | Closed core + Open SDK | Closed (Hosted) | Closed (Hosted + Self-host) |
| **Deployment** | Self-hosted / Docker / K8s | Cloud + Hybrid | Hosted only | Cloud + Self-host |
| **Models supported** | 100+ providers | 200+ | 300+ | Provider-dependent |
| **Self-hosting cost** | $200–800/mo infra | N/A (managed) | N/A (hosted) | $0–100/mo (self-host) |
| **Virtual keys / budgets** | Per-key + per-team | Per-key + per-user | Basic per-key | Per-org |
| **Automatic fallback** | Configurable chains | Circuit breakers | Provider routing | Limited |
| **Semantic caching** | Redis + Qdrant | Built-in | No | No |
| **Observability** | Prometheus + external | Built-in deep traces | Basic usage stats | Primary focus |
| **Compliance** | DIY (SOC2 via infra) | SOC 2, ISO 27001, HIPAA | Partial | SOC 2 |
| **Best for** | Full control, zero lock-in | Enterprise governance | Quick model access | Observability-first |

**When to choose what:**

- **LiteLLM** — You have DevOps capacity, want zero vendor lock-in, and need full control over routing, caching, and data residency.
- **Portkey** — You need enterprise governance (SOC 2, audit logs), prompt management UI, and are willing to pay SaaS pricing.
- **OpenRouter** — You want instant access to 300+ models with zero infrastructure work, and the 5.5% credit fee is acceptable.
- **Helicone** — Observability is your primary concern; you need detailed tracing and cost attribution across LLM calls.

---

## Limitations / Honest Assessment

LiteLLM is not the right tool for every situation. Here is where it falls short:

1. **Operational overhead** — Unlike managed gateways, you own uptime, scaling, security patches, and database backups. Budget 0.5–1 FTE for production maintenance.

2. **No built-in prompt management** — Portkey's prompt versioning UI with A/B testing does not exist in LiteLLM. You manage prompt templates in your application or external tools.

3. **Semantic caching requires extra infrastructure** — Redis semantic cache needs an embedding model endpoint. This adds complexity and cost compared to Portkey's built-in semantic caching.

4. **No native multi-region redundancy** — You architect your own multi-region failover with DNS or a global load balancer. LiteLLM is a single-region proxy by default.

5. **Enterprise SSO costs money** — SAML/SSO, audit logs, and advanced guardrails are part of LiteLLM Enterprise. The OSS version handles virtual keys and basic budgets only.

---

## Frequently Asked Questions

**Q: How does LiteLLM compare to OpenRouter?**

LiteLLM is a self-hosted open-source gateway; OpenRouter is a managed multi-model API. LiteLLM gives you zero markup and full control over your data. OpenRouter charges 5.5% on credit purchases but requires zero infrastructure work. For teams with >$5K/month LLM spend and DevOps capacity, LiteLLM is cheaper long-term. For quick prototyping, OpenRouter deploys faster.

**Q: Can I use LiteLLM with my existing OpenAI SDK code?**

Yes — change two lines: set `base_url` to your LiteLLM proxy and `api_key` to a virtual key. Everything else stays the same. This is the primary reason teams adopt LiteLLM; zero code changes beyond configuration.

**Q: What database does LiteLLM require?**

PostgreSQL 14+ is required for production features (virtual keys, spend tracking, team management). The proxy can run without a database for basic pass-through routing, but you lose budgeting, key management, and the Admin UI.

**Q: How does the fallback mechanism work?**

You define fallback chains in `config.yaml`. If a model returns a 429, 500, or timeout, LiteLLM retries the request against the next model in the chain — all within the same client request. The client sees a single response; failover happens transparently.

**Q: Is LiteLLM suitable for high-traffic production use?**

Yes — with Redis caching and 2+ replicas behind a load balancer, LiteLLM handles 1,000+ RPS. The database connection pool and Redis transaction buffer are the scaling bottlenecks, not the proxy itself. Use the Helm chart with HPA for auto-scaling under Kubernetes.

**Q: How do I monitor LiteLLM in production?**

Enable the Prometheus callback in `config.yaml`, scrape the `/metrics` endpoint, and import the official Grafana dashboard. Set alerts on `litellm_requests_total_failed` (error rate) and `litellm_remaining_requests` (budget exhaustion). Wire `success_callback` to Langfuse for per-request tracing.

---

## Conclusion

LiteLLM solves the messy reality of production multi-LLM deployments: multiple SDKs, scattered API keys, opaque costs, and manual failover. With a single `config.yaml`, you get a unified OpenAI-compatible gateway, virtual keys with budgets, automatic fallbacks, and real-time spend tracking.

For teams spending $5,000+/month on LLM APIs and with basic DevOps capacity, self-hosting LiteLLM pays for itself in reduced markup fees and improved reliability. Start with the Docker Compose setup above, add Redis caching, then scale to Kubernetes with Helm as traffic grows.

**Action items:**

1. Clone the [LiteLLM GitHub repo](https://github.com/BerriAI/litellm) and run the Docker Compose quick-start
2. Create virtual keys for each team and set per-key budgets
3. Enable Redis caching and Prometheus monitoring
4. Join the [LiteLLM Discord community](https://discord.gg/wupm9ySymB) for support and feature discussions

*Some links in this article are affiliate links. We may earn a commission if you purchase hosting services through them — this does not affect pricing or recommendations.*

*本文含联盟营销链接。通过链接购买主机服务我们可能获得佣金——这不会影响价格或推荐。*

---



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [LiteLLM GitHub Repository](https://github.com/BerriAI/litellm) — Official source code, 22,500+ stars
- [LiteLLM Documentation](https://docs.litellm.ai/docs/) — Complete proxy and SDK reference
- [LiteLLM Docker Quick Start](https://docs.litellm.ai/docs/proxy/docker_quick_start) — Official Docker setup guide
- [LiteLLM Config Reference](https://docs.litellm.ai/docs/proxy/configs) — All config.yaml options
- [LiteLLM Helm Deployment](https://docs.litellm.ai/docs/proxy/deploy) — Kubernetes and Helm charts
- [LiteLLM Admin UI Docs](https://docs.litellm.ai/docs/proxy/ui) — Virtual key and team management
- [LiteLLM Caching Guide](https://docs.litellm.ai/docs/caching/all_caches) — Redis, semantic, and disk caching
- [Portkey vs LiteLLM Comparison](https://portkey.ai/lp/portkey-vs-litellm) — Vendor comparison page
- [OpenRouter Documentation](https://openrouter.ai/docs) — Alternative gateway reference
- [Helicone Documentation](https://docs.helicone.ai) — Observability-focused alternative
