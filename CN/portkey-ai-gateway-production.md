---
title: 'Portkey AI Gateway 2026: The LLM Gateway Managing 200+ Models with Observability — Production Setup'
description: ''
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/Portkey-AI/gateway'
stars: 14000
maintainer: 'Portkey-AI'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Portkey AI Gateway']
aliases:
- /posts/portkey-ai-gateway-production/
---

{{</* resource-info */>}}

Managing multiple Large Language Model (LLM) providers in production is a nightmare. Each provider has its own API format, authentication scheme, rate limits, and failure modes. Your application code becomes littered with conditional logic for OpenAI, Anthropic, Google, Azure, and the dozens of new providers emerging every month. Enter **Portkey AI Gateway** — the open-source LLM gateway that unifies 200+ models behind a single API, complete with load balancing, fallback routing, spend tracking, request caching, and enterprise-grade observability.

In this comprehensive guide, we'll walk through a production-ready setup of Portkey AI Gateway. You'll learn how to route requests across multiple providers, implement intelligent fallbacks, monitor spending, cache responses, and enforce guardrails — all while keeping your application code clean and provider-agnostic.

> **Quick Start**: Portkey AI Gateway is open-source under MIT license with 14,000+ GitHub stars. You can self-host it or use the managed cloud option. Ready? Let's dive in.

---

## What is Portkey AI Gateway?

Portkey AI Gateway is an open-source AI gateway that sits between your application and LLM providers. Think of it as a smart reverse proxy designed specifically for AI workloads. It normalizes the API surface across 200+ models from providers like OpenAI, Anthropic, Google, Azure, Cohere, Mistral, and many more, so your code only needs to speak one language.

The gateway handles the messy parts of LLM production deployments:

- **Unified API**: One endpoint for 200+ models across 20+ providers
- **Load balancing**: Distribute traffic across multiple API keys or providers
- **Fallback routing**: Automatically failover when a provider is down
- **Request caching**: Cache identical requests to reduce costs and latency
- **Spend tracking**: Real-time visibility into your AI spending
- **Prompt management**: Version and manage prompts independently of code
- **Guardrails**: Enforce content policies and safety checks
- **Observability**: Full request/response logging, metrics, and tracing

Whether you're a startup running a single model or an enterprise juggling dozens of providers, Portkey provides the infrastructure layer you need to productionize your AI applications.

---

## Architecture Overview and Deployment Options

Portkey AI Gateway offers two deployment modes: **Cloud (managed)** and **Self-hosted**. The architecture is built around a lightweight, high-performance gateway server that intercepts LLM requests, applies your configured policies, and routes them to the appropriate provider.

### Cloud Deployment

The fastest way to get started is with Portkey's managed cloud service. Sign up at [Portkey.ai](https://portkey.ai), create an API key, and you're ready to route requests. The cloud option handles scaling, updates, and infrastructure maintenance for you.

### Self-Hosted Deployment

For organizations with strict data residency or security requirements, self-hosting is the way to go. The gateway can be deployed via Docker, Kubernetes, or as a standalone Node.js application.

**Deploy with Docker:**

```bash
# Clone the repository
git clone https://github.com/Portkey-AI/gateway.git
cd gateway

# Run with Docker
docker run -p 8787:8787 -e PORTKEY_GATEWAY_API_KEY=your-gateway-key portkeyai/gateway:latest
```

**Deploy with Docker Compose:**

```yaml
version: '3.8'
services:
  portkey-gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - CACHE_ENABLED=true
      - CACHE_TTL=3600
    volumes:
      - ./config:/app/config
    restart: unless-stopped
```

**Deploy to Kubernetes:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: portkey-gateway
spec:
  replicas: 3
  selector:
    matchLabels:
      app: portkey-gateway
  template:
    metadata:
      labels:
        app: portkey-gateway
    spec:
      containers:
      - name: gateway
        image: portkeyai/gateway:latest
        ports:
        - containerPort: 8787
        env:
        - name: PORTKEY_GATEWAY_API_KEY
          valueFrom:
            secretKeyRef:
              name: portkey-secrets
              key: gateway-api-key
---
apiVersion: v1
kind: Service
metadata:
  name: portkey-gateway-service
spec:
  selector:
    app: portkey-gateway
  ports:
  - port: 80
    targetPort: 8787
  type: ClusterIP
```

For production deployments, we recommend Kubernetes with at least 3 replicas for high availability. If you need a reliable cloud platform to host your cluster, [DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0) offers a developer-friendly managed Kubernetes service that pairs perfectly with Portkey.

---

## Configuring Providers and API Keys

Before routing requests, you need to configure your LLM providers. Portkey uses a provider configuration system that securely stores your API keys and maps them to named provider instances.

### Setting Up Providers

Create a `providers.yaml` configuration file:

```yaml
providers:
  openai-primary:
    type: openai
    api_key: ${OPENAI_API_KEY}
    organization: ${OPENAI_ORG_ID}
    
  anthropic-primary:
    type: anthropic
    api_key: ${ANTHROPIC_API_KEY}
    
  azure-gpt4:
    type: azure-openai
    api_key: ${AZURE_API_KEY}
    resource_name: ${AZURE_RESOURCE_NAME}
    deployment_id: gpt-4
    api_version: 2025-12-01
    
  google-gemini:
    type: google
    api_key: ${GOOGLE_API_KEY}
    
  mistral-local:
    type: mistral
    api_key: ${MISTRAL_API_KEY}
    base_url: http://mistral-service:8000/v1
```

### Loading Configuration

```bash
# Set environment variables
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GATEWAY_API_KEY="pk-..."

# Start gateway with config
docker run -p 8787:8787 \
  -e PORTKEY_GATEWAY_API_KEY=$GATEWAY_API_KEY \
  -v $(pwd)/providers.yaml:/app/config/providers.yaml \
  portkeyai/gateway:latest
```

---

## Unified API: One Endpoint for 200+ Models

The core value of Portkey is its unified API. Regardless of which model or provider you're calling, the request format stays the same. The gateway handles translation between the normalized Portkey format and each provider's native format.

### Basic Chat Completion Request

```bash
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "provider": "openai-primary",
    "messages": [
      {"role": "system", "content": "You are a helpful assistant."},
      {"role": "user", "content": "Explain quantum computing in simple terms."}
    ]
  }'
```

### Switching Providers Instantly

```bash
# Same request, different provider — just change the model/provider fields
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4",
    "provider": "anthropic-primary",
    "messages": [
      {"role": "user", "content": "Explain quantum computing in simple terms."}
    ],
    "max_tokens": 1024
  }'
```

### Python SDK Example

```python
from portkey_ai import Portkey

# Initialize client
portkey = Portkey(
    api_key="your-gateway-api-key",
    virtual_key="openai-primary"  # References configured provider
)

# Chat completion
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Write a Python function to calculate fibonacci numbers."}
    ]
)
print(response.choices[0].message.content)
```

### Streaming Responses

```python
import portkey_ai

portkey = portkey_ai.Portkey(api_key="your-gateway-api-key")

stream = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Write a poem about AI."}],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

---

## Load Balancing and Fallback Routing

Production AI systems cannot tolerate provider outages. Portkey's load balancing and fallback routing ensures your application stays online even when providers fail.

### Round-Robin Load Balancing

Distribute traffic evenly across multiple API keys or providers:

```yaml
# config/load-balance.yaml
strategies:
  gpt4-pool:
    type: load_balance
    providers:
      - provider: openai-primary
        weight: 1
      - provider: azure-gpt4
        weight: 1
      - provider: openai-backup
        weight: 1
```

```python
# Use the load-balanced pool
response = portkey.chat.completions.create(
    model="gpt-4o",
    config="gpt4-pool",  # References the strategy
    messages=[{"role": "user", "content": "Hello!"}]
)
```

### Priority-Based Fallback Routing

Define fallback chains for automatic failover:

```yaml
strategies:
  production-fallback:
    type: fallback
    targets:
      - provider: azure-gpt4
        timeout: 10
        retry: 2
      - provider: openai-primary
        timeout: 15
        retry: 1
      - provider: anthropic-primary
        model: claude-sonnet-4
        timeout: 15
      - provider: google-gemini
        model: gemini-2.5-pro
        timeout: 20
```

```bash
# The gateway tries each target in order until one succeeds
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "config": "production-fallback",
    "messages": [{"role": "user", "content": "Critical business query here"}]
  }'
```

### Conditional Routing Based on Request Properties

Route requests based on content, user, or other request properties:

```yaml
strategies:
  smart-router:
    type: conditional
    rules:
      - condition: "request.messages[0].content.length > 4000"
        target: 
          provider: anthropic-primary
          model: claude-sonnet-4  # Better long-context handling
      - condition: "request.user == 'code-assistant'"
        target:
          provider: openai-primary
          model: gpt-4o
      - condition: "default"
        target:
          provider: azure-gpt4
          model: gpt-4o-mini
```

---

## Request Caching: Reduce Costs and Latency

LLM API calls are expensive and slow. Portkey's semantic caching stores responses and serves cached results for similar queries, dramatically reducing both cost and latency.

### Enabling Cache

```yaml
cache:
  enabled: true
  mode: semantic  # or "exact" for exact-match caching
  ttl: 3600       # Cache time-to-live in seconds
  max_size: 10000 # Maximum number of cached entries
  similarity_threshold: 0.95  # For semantic caching
```

```python
# First call hits the provider and caches the result
response1 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "What is Kubernetes?"}],
    cache=True
)

# Similar call returns cached result instantly at fraction of cost
response2 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Explain Kubernetes to me"}],
    cache=True
)
```

### Cache Statistics and Invalidation

```bash
# Check cache metrics
curl http://localhost:8787/v1/admin/cache/stats \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# Invalidate specific cache entries
curl -X POST http://localhost:8787/v1/admin/cache/invalidate \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "pattern": "kubernetes",
    "provider": "openai-primary"
  }'
```

---

## Spend Tracking and Cost Observability

Understanding your AI spending across providers, models, and users is critical for budget management. Portkey provides granular cost tracking out of the box.

### Cost Tracking Setup

```python
import portkey_ai

portkey = portkey_ai.Portkey(
    api_key="your-gateway-api-key",
    metadata={
        "user_id": "user-12345",
        "project": "customer-support-bot",
        "environment": "production",
        "team": "ai-platform"
    }
)

response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Help with my order"}]
)

# Access cost information from response
print(f"Input tokens: {response.usage.prompt_tokens}")
print(f"Output tokens: {response.usage.completion_tokens}")
print(f"Total cost: ${response.usage.estimated_cost}")
```

### Querying Spend Analytics

```bash
# Get spend report by provider
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=provider" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# Get spend report by user
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=user_id" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

### Budget Alerts

```yaml
alerts:
  daily-budget:
    type: budget
    threshold: 500  # USD
    period: daily
    channels:
      - type: webhook
        url: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
      - type: email
        address: team@company.com
  
  abnormal-spike:
    type: anomaly
    baseline_multiplier: 3
    window: 1h
    channels:
      - type: pagerduty
        integration_key: your-pd-key
```

---

## Prompt Management and Versioning

Managing prompts separately from application code enables non-technical team members to iterate on prompts without deployments. Portkey's prompt management system provides versioning, A/B testing, and dynamic variable substitution.

### Creating Managed Prompts

```python
from portkey_ai import Portkey

portkey = Portkey(api_key="your-gateway-api-key")

# Deploy a prompt version
prompt = portkey.prompts.deploy(
    name="customer-support-classifier",
    version="1.2.0",
    prompt=[
        {"role": "system", "content": "You are a support ticket classifier. Categorize the ticket into: Billing, Technical, Feature Request, or Complaint."},
        {"role": "user", "content": "Ticket: {{ticket_content}}"}
    ],
    model="gpt-4o-mini",
    parameters={
        "temperature": 0.2,
        "max_tokens": 50
    }
)
```

### Rendering Prompts with Variables

```python
# Render and execute a managed prompt
response = portkey.prompts.render(
    name="customer-support-classifier",
    variables={
        "ticket_content": "I was charged twice for my subscription this month."
    }
)

print(response.choices[0].message.content)
# Output: "Billing"
```

### A/B Testing Prompts

```python
# Run A/B test between prompt versions
response = portkey.prompts.render(
    name="customer-support-classifier",
    version="1.2.0",  # 50% traffic
    test_version="1.3.0-beta",  # 50% traffic
    variables={"ticket_content": "App crashes when I upload photos"}
)
```

---

## Guardrails and Content Safety

Portkey's guardrails system lets you enforce content policies on both requests and responses, ensuring compliance with safety standards and business rules.

### Configuring Guardrails

```yaml
guardrails:
  input-validation:
    - type: keyword_filter
      blocklist: ["password", "ssn", "credit_card", "secret_key"]
      action: block
    - type: pii_detector
      entities: ["email", "phone", "ssn"]
      action: mask
    - type: toxicity_check
      threshold: 0.8
      action: block
      
  output-validation:
    - type: content_policy
      categories: ["hate", "violence", "self-harm"]
      action: block
    - type: response_format
      required_schema:
        type: json_object
      action: retry
```

```python
# Apply guardrails to requests
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "User input here"}],
    guardrails=["input-validation", "output-validation"]
)
```

### Custom Guardrail Functions

```python
from portkey_ai import Portkey
import json

portkey = Portkey(api_key="your-gateway-api-key")

def custom_validator(request, response):
    """Custom business logic validation."""
    try:
        data = json.loads(response.choices[0].message.content)
        if "confidence" not in data or data["confidence"] < 0.7:
            return False, "Confidence score too low"
        return True, None
    except json.JSONDecodeError:
        return False, "Response must be valid JSON"

portkey.guardrails.register("confidence-check", custom_validator)
```

---

## Observability: Logging, Metrics, and Tracing

Understanding how your AI systems behave in production is non-negotiable. Portkey provides comprehensive observability with request/response logging, token usage metrics, latency histograms, and distributed tracing.

### Request Logging

```bash
# Query recent request logs
curl "http://localhost:8787/v1/admin/logs?limit=100&status=error" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```python
# Enable detailed logging per request
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hello"}],
    metadata={
        "trace_id": "trace-abc-123",
        "session_id": "session-xyz-789",
        "user_id": "user-456"
    }
)
```

### OpenTelemetry Integration

```yaml
observability:
  tracing:
    enabled: true
    exporter: otlp
    endpoint: http://jaeger-collector:4317
  metrics:
    enabled: true
    exporter: prometheus
    port: 9090
```

### Prometheus Metrics

The gateway exposes Prometheus-compatible metrics at `/metrics`:

```bash
# Scrape metrics
curl http://localhost:8787/metrics
```

Key metrics include:
- `portkey_requests_total` — Total requests by provider, model, status
- `portkey_request_duration_seconds` — Request latency histogram
- `portkey_tokens_total` — Token usage by type (input/output) and model
- `portkey_cache_hits_total` — Cache hit/miss counts
- `portkey_spend_total` — Estimated spend in USD

### Grafana Dashboard

Import Portkey's official Grafana dashboard (ID: `portkey-ai-gateway`) for out-of-the-box visualizations:

```json
{
  "dashboard": {
    "title": "Portkey AI Gateway Overview",
    "panels": [
      {
        "title": "Requests per Second",
        "targets": [
          {
            "expr": "rate(portkey_requests_total[5m])"
          }
        ]
      },
      {
        "title": "P95 Latency",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, portkey_request_duration_seconds_bucket)"
          }
        ]
      },
      {
        "title": "Token Usage",
        "targets": [
          {
            "expr": "sum by (model) (portkey_tokens_total)"
          }
        ]
      }
    ]
  }
}
```

---

## Production Deployment Checklist

Before taking Portkey AI Gateway to production, ensure you've covered these critical items:

### Infrastructure

```yaml
# Production docker-compose with Redis for caching and PostgreSQL for logs
version: '3.8'
services:
  gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - REDIS_URL=redis://redis:6379
      - DATABASE_URL=postgres://user:pass@postgres:5432/portkey
    depends_on:
      - redis
      - postgres
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
  
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
  
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: portkey
      POSTGRES_USER: user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  redis-data:
  postgres-data:
```

### Security Checklist

| Item | Status | Notes |
|------|--------|-------|
| API key rotation | Required | Rotate gateway keys monthly |
| TLS termination | Required | Use reverse proxy or load balancer |
| Rate limiting | Required | Configure per-user and per-IP limits |
| PII masking | Recommended | Enable for production workloads |
| Audit logging | Required | Log all admin actions |
| Network isolation | Recommended | Deploy in private subnet |

### Health Checks

```bash
# Gateway health endpoint
curl http://localhost:8787/health

# Expected response
{"status": "healthy", "version": "2.5.0", "uptime": 86400}
```

```yaml
# Kubernetes liveness and readiness probes
livenessProbe:
  httpGet:
    path: /health
    port: 8787
  initialDelaySeconds: 10
  periodSeconds: 15

readinessProbe:
  httpGet:
    path: /ready
    port: 8787
  initialDelaySeconds: 5
  periodSeconds: 5
```

---

## FAQ: Portkey AI Gateway

### What models does Portkey AI Gateway support?

Portkey supports 200+ models across 20+ providers including OpenAI (GPT-4o, GPT-4o-mini, o3), Anthropic (Claude 4, Claude 3.5), Google (Gemini 2.5), Azure OpenAI, Cohere, Mistral, Together AI, Groq, Perplexity, and many more. New providers are added regularly.

### Can I self-host Portkey AI Gateway for free?

Yes. Portkey AI Gateway is open-source under the MIT license and completely free to self-host. The cloud version offers additional managed features like the web dashboard and advanced analytics with usage-based pricing.

### How does request caching work?

Portkey offers two caching modes: **exact match** (identical requests return cached responses) and **semantic match** (similar requests based on embedding similarity return cached responses). Caching is configurable per-request with TTL and similarity threshold parameters.

### Is my data secure when using Portkey?

When self-hosting, all request data stays within your infrastructure. The gateway supports PII detection and masking, encrypted API key storage, and audit logging. For the cloud option, Portkey is SOC 2 Type II certified and offers Business Associate Agreements (BAAs) for HIPAA compliance.

### How does fallback routing handle provider outages?

Fallback routing works by defining a priority list of providers. If the primary provider fails (timeout, 5xx error, rate limit), the gateway automatically retries the request with the next provider in the chain. You can configure retry counts, timeouts, and error conditions per target.

### Can I use Portkey with my existing OpenAI SDK code?

Yes. Portkey provides drop-in compatibility with the OpenAI SDK. Simply change the `base_url` to your gateway endpoint and use your Portkey API key:

```python
import openai

client = openai.OpenAI(
    api_key="your-portkey-gateway-key",
    base_url="http://localhost:8787/v1"
)

# Your existing code works unchanged
response = client.chat.completions.create(...)
```

---



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Conclusion

Portkey AI Gateway transforms the complexity of managing multiple LLM providers into a solved infrastructure problem. With its unified API, intelligent routing, semantic caching, spend tracking, and comprehensive observability, you can focus on building great AI applications instead of wrestling with provider integrations.

Whether you choose the managed cloud option or self-host on your own infrastructure (consider [DigitalOcean](https://m.do.co/c/eca87ac14ee0) for an easy Kubernetes deployment), Portkey provides the reliability, cost control, and visibility that production AI systems demand.

Start with the Docker quick-start, configure your providers, set up load balancing with fallback routes, enable caching, and connect your observability stack. In under an hour, you'll have a production-grade LLM gateway handling 200+ models with full observability.

---

*Published: 2026-05-19 | Portkey AI Gateway v2.5.0 | [GitHub: Portkey-AI/gateway](https://github.com/Portkey-AI/gateway)*
