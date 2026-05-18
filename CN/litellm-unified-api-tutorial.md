---
title: 'LiteLLM Tutorial 2025: One API to Access 100+ LLMs'
description: 'Complete LiteLLM tutorial 2025. Learn how to use one unified API to access 100+ LLM providers including OpenAI, Anthropic, Azure, and open-source models.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
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
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/litellm-unified-api-tutorial/
---

{</* resource-info */>}

Managing multiple LLM providers in production is a nightmare most developers know too well. Each provider has its own API format, authentication method, error handling, and rate limits. Switching from GPT-4 to Claude 3.5 Sonnet means rewriting API calls. Adding a fallback to Gemini means more boilerplate. This fragmentation burns engineering time and introduces brittle code paths.

Enter LiteLLM. This open-source project provides a single, unified interface to call over 100 LLM providers using the familiar OpenAI API format. Whether you need OpenAI, Anthropic, Google Gemini, Azure OpenAI, AWS Bedrock, or self-hosted models via Ollama and vLLM, LiteLLM handles the translation layer so you focus on building features.

In this guide, you will learn how to install LiteLLM, make your first unified API call, set up the production-grade proxy server, configure intelligent routing, and deploy at enterprise scale. Let us dive in.

## What is LiteLLM?

### The Universal LLM API Gateway

LiteLLM, maintained by Berri AI on [GitHub](https://github.com/BerriAI/litellm), is an open-source LLM gateway that translates API calls between the OpenAI format and 100+ different LLM providers. It functions as a drop-in compatibility layer, meaning code written for OpenAI's `/chat/completions` endpoint works seamlessly with Anthropic Claude, Google Gemini, Cohere Command, and dozens more without modification.

The project started in early 2023 and has grown to become one of the most popular LLM infrastructure tools, with over 10,000 GitHub stars and active daily releases. Companies like Cloudflare, Postman, and Shopify use LiteLLM in production to manage multi-provider LLM access.

### Why Use LiteLLM?

Building direct integrations for each LLM provider requires maintaining separate SDKs, handling different authentication headers, parsing unique response formats, and managing provider-specific error codes. LiteLLM eliminates this overhead entirely.

Key benefits include:

- **Single API format**: Write once, call any provider using the OpenAI SDK structure
- **Automatic fallbacks**: If OpenAI's API is down, route to Anthropic or Gemini instantly
- **Load balancing**: Distribute traffic across multiple providers to reduce latency and cost
- **Unified logging**: Track all LLM calls across providers in one place
- **Budget controls**: Set spend limits per API key, user, or team
- **Caching**: Reduce costs by caching identical requests across providers

### Key Features Overview

LiteLLM offers two main components. The **Python SDK** (`litellm` pip package) provides a programmatic interface for making unified LLM calls in Python applications. The **Proxy Server** (deployed via Docker or pip) exposes an OpenAI-compatible HTTP API that any application can call, complete with virtual key management, rate limiting, and spend tracking.

Additional enterprise features include role-based access control (RBAC), SSO integration via OAuth/SAML, detailed spend dashboards, and support for embedding models, image generation, and function calling across providers.

## Supported Providers and Models (100+)

### OpenAI, Anthropic, Google (Gemini)

LiteLLM supports all major commercial LLM providers with full feature parity:

- **OpenAI**: GPT-4o, GPT-4 Turbo, GPT-4, GPT-3.5 Turbo, DALL-E, Whisper, text-embedding-3-large
- **Anthropic**: Claude 3.5 Sonnet, Claude 3 Opus, Claude 3 Sonnet, Claude 3 Haiku
- **Google**: Gemini 1.5 Pro, Gemini 1.5 Flash, Gemini Pro, Gemini Ultra

Each provider supports streaming responses, function calling, multi-modal inputs, and tool use where available.

### Azure OpenAI

Azure OpenAI Service receives dedicated support in LiteLLM. You can configure multiple Azure deployments (e.g., `gpt-4` in East US and `gpt-4` in West Europe) and let LiteLLM automatically route requests to the deployment with the lowest latency or highest token availability. This is critical for applications requiring regional failover or compliance with data residency requirements.

### Open-Source Models via Hugging Face

LiteLLM connects to any model hosted on [Hugging Face](https://huggingface.co) through the Inference API or by calling TGI (Text Generation Inference) endpoints. This includes models like Llama 3, Mistral, Qwen, and over 500,000 others. You can deploy models on Hugging Face Inference Endpoints or self-host with TGI and point LiteLLM to your endpoint.

### Local Models via Ollama, vLLM

For privacy-sensitive applications or cost reduction, LiteLLM integrates with local model servers:

- **Ollama**: Run Llama 3, Mistral, or Gemma locally and expose them through LiteLLM's unified API
- **vLLM**: High-throughput serving of open-source models with PagedAttention
- **LM Studio**: Local model management with LiteLLM-compatible endpoints

This means your development environment can use local models while production uses GPT-4, all with the same code.

### Cloud Providers: AWS Bedrock, Vertex AI

Enterprise cloud deployments are fully supported:

- **AWS Bedrock**: Access Claude, Llama 3, Titan, and Command models through your AWS account
- **Google Vertex AI**: Use Gemini and PaLM models via Google Cloud
- **Azure AI**: Native integration with Azure's model catalog

LiteLLM handles the IAM authentication, region selection, and model ID translation automatically.

### Specialized Providers: Cohere, Groq, Together AI

Niche providers with unique strengths are also covered:

- **Groq**: Extremely fast inference (500+ tokens/second) for Llama 3 and Mixtral
- **Together AI**: Optimized inference for open-source models at competitive pricing
- **Cohere**: Command models and Embed v3 embeddings
- **Mistral AI**: Direct API access to Mistral models
- **AI21 Labs**: Jurassic models for enterprise use

## Installation and Quick Start

### Installing LiteLLM (pip install litellm)

Getting started takes under 60 seconds. Install the LiteLLM Python SDK via pip:

```bash
pip install litellm
```

For the proxy server with all enterprise features, install the full package:

```bash
pip install 'litellm[proxy]'
```

Both options require Python 3.8 or higher. LiteLLM has minimal dependencies and installs cleanly in virtual environments, Docker containers, and Jupyter notebooks.

### Making Your First Unified API Call

Here is a basic completion call that works with any supported provider:

```python
import litellm
from litellm import completion

# Call OpenAI
response = completion(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Hello, how are you?"}]
)

# Call Anthropic Claude - same function, different model string
response = completion(
    model="claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "Hello, how are you?"}]
)

# Call Gemini - same function again
response = completion(
    model="gemini/gemini-1.5-pro",
    messages=[{"role": "user", "content": "Hello, how are you?"}]
)
```

Notice that the `completion()` function and message format stay identical. Only the `model` parameter changes, using LiteLLM's provider-prefixed naming convention where needed.

### Understanding the completion() Function

The `completion()` function accepts all standard OpenAI parameters: `model`, `messages`, `temperature`, `max_tokens`, `top_p`, `stream`, `tools`, and `tool_choice`. LiteLLM translates these to each provider's native format behind the scenes.

Provider-specific parameters can be passed through the `extra_body` parameter. API keys are read from environment variables by default (`OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, `GEMINI_API_KEY`), or passed explicitly via the `api_key` parameter.

### Async Support Overview

For production applications handling concurrent requests, LiteLLM provides `acompletion()`:

```python
from litellm import acompletion
import asyncio

async def call_llm():
    response = await acompletion(
        model="gpt-4o",
        messages=[{"role": "user", "content": "Async call"}]
    )
    return response

# Handle multiple concurrent calls
tasks = [call_llm() for _ in range(10)]
results = await asyncio.gather(*tasks)
```

Async mode is essential for high-throughput applications and integrates seamlessly with FastAPI, Sanic, and other async Python frameworks.

## The LiteLLM Proxy Server

### Setting Up the Proxy Server

The LiteLLM Proxy Server transforms LiteLLM from a Python library into a production-grade API gateway. Any application that speaks OpenAI's API can connect to the proxy without code changes.

Start the proxy server with a configuration file:

```bash
litellm --config /path/to/config.yaml
```

Or deploy via Docker:

```bash
docker run -p 4000:4000 \
  -v $(pwd)/config.yaml:/app/config.yaml \
  ghcr.io/berriai/litellm:main-latest \
  --config /app/config.yaml
```

The proxy exposes the standard OpenAI endpoints: `/chat/completions`, `/completions`, `/embeddings`, `/models`, and `/images/generations`.

### Configuration File (config.yaml) Deep Dive

The `config.yaml` file defines your model inventory, routing rules, and enterprise settings. Here is a production-ready example:

```yaml
model_list:
  - model_name: gpt-4
    litellm_params:
      model: gpt-4o
      api_key: os.environ/OPENAI_API_KEY

  - model_name: claude-3-5
    litellm_params:
      model: claude-3-5-sonnet-20241022
      api_key: os.environ/ANTHROPIC_API_KEY

  - model_name: llama-3
    litellm_params:
      model: ollama/llama3
      api_base: http://localhost:11434

router_settings:
  routing_strategy: simple-shuffle
  fallbacks: [{"gpt-4": ["claude-3-5"]}]
  cooldown_time: 30

general_settings:
  master_key: sk-litellm-master-key
  database_url: os.environ/DATABASE_URL
```

This configuration defines three model aliases (`gpt-4`, `claude-3-5`, `llama-3`), sets Claude as a fallback for OpenAI, and configures master key authentication.

### Virtual Key Management

The proxy generates virtual keys that map to specific models and budgets. Create a virtual key via the API:

```bash
curl -X POST http://localhost:4000/key/generate \
  -H "Authorization: Bearer sk-litellm-master-key" \
  -H "Content-Type: application/json" \
  -d '{
    "models": ["gpt-4", "claude-3-5"],
    "max_budget": 100.00,
    "tpm_limit": 100000,
    "rpm_limit": 1000
  }'
```

Each virtual key tracks its own spend, enforces its own rate limits, and can be revoked independently. This is ideal for multi-tenant SaaS applications.

### Rate Limiting and Budget Controls

LiteLLM enforces rate limits at multiple levels. Per-key limits include requests per minute (RPM), tokens per minute (TPM), and maximum budget in USD. Per-user limits track consumption across multiple keys. Global limits protect the entire deployment from unexpected spikes.

Budget alerts trigger webhooks when spend thresholds are reached. Teams can configure Slack, email, or custom webhook notifications to stay informed about LLM spending patterns.

### Load Balancing Across Providers

The proxy supports multiple routing strategies:

- **Simple shuffle**: Round-robin across healthy providers
- **Latency-based**: Route to the provider with the lowest response time
- **Cost-based**: Send requests to the cheapest available model
- **Rate-limit aware**: Avoid providers approaching their rate limits

Configure routing in `config.yaml`:

```yaml
router_settings:
  routing_strategy: latency-based-routing
  timeout: 30
  num_retries: 3
```

## Advanced Features

### Router: Intelligent Model Selection

The `Router` class provides programmatic control over model selection in Python:

```python
from litellm import Router

router = Router(
    model_list=[
        {"model_name": "gpt-4", "litellm_params": {"model": "gpt-4o"}},
        {"model_name": "gpt-4", "litellm_params": {"model": "azure/gpt-4"}},
    ],
    routing_strategy="latency-based",
    fallbacks=[{"gpt-4": ["claude-3-5"]}]
)

response = await router.acompletion(
    model="gpt-4",
    messages=[{"role": "user", "content": "Hello"}]
)
```

The router automatically tracks latency per deployment and routes requests to the fastest option.

### Fallbacks and Retries

When a provider returns an error (rate limit, timeout, server error), LiteLLM can automatically retry with the same provider or fall back to a different one:

```python
response = completion(
    model="gpt-4o",
    messages=messages,
    fallback_dict={"gpt-4o": ["claude-3-5-sonnet", "gemini-1.5-pro"]},
    num_retries=3
)
```

This ensures 99.9%+ uptime even when individual providers experience outages.

### Caching Responses

LiteLLM supports Redis-based caching to avoid redundant API calls:

```python
litellm.cache = litellm.Cache(type="redis", host="localhost", port=6379)

# First call hits the API
response = completion(model="gpt-4o", messages=messages)

# Second identical call returns cached result instantly
response = completion(model="gpt-4o", messages=messages)
```

Caching supports TTL configuration, cache-key customization, and cache invalidation via API.

### Streaming Support

All providers support streaming responses through a unified interface:

```python
response = completion(
    model="gpt-4o",
    messages=messages,
    stream=True
)

for chunk in response:
    print(chunk.choices[0].delta.content, end="")
```

The streaming format is normalized across all providers, so your frontend code works identically regardless of which LLM serves the request.

### Function Calling Across Providers

Function calling (tool use) works across all supported providers with automatic format translation:

```python
tools = [{
    "type": "function",
    "function": {
        "name": "get_weather",
        "parameters": {"location": {"type": "string"}}
    }
}]

# Works with OpenAI, Anthropic, Gemini, and more
response = completion(model="gpt-4o", messages=messages, tools=tools)
```

### Embedding Models Unified API

LiteLLM unifies embedding APIs across providers:

```python
from litellm import embedding

# OpenAI embeddings
response = embedding(model="text-embedding-3-large", input=["Hello world"])

# Cohere embeddings
response = embedding(model="cohere/embed-english-v3.0", input=["Hello world"])

# Local embeddings via Ollama
response = embedding(model="ollama/nomic-embed-text", input=["Hello world"])
```

## LiteLLM + LangChain/LlamaIndex Integration

### Using LiteLLM with LangChain

LiteLLM integrates with [LangChain](https://python.langchain.com) through the `ChatLiteLLM` class:

```python
from langchain_community.chat_models import ChatLiteLLM

llm = ChatLiteLLM(model="gpt-4o")
response = llm.invoke("What is the capital of France?")
```

LangChain's chains, agents, and RAG pipelines work transparently with any LiteLLM-supported model. Switching from GPT-4 to Claude requires only changing the model string.

### Using LiteLLM with LlamaIndex

[LlamaIndex](https://docs.llamaindex.ai) supports LiteLLM as a drop-in LLM backend:

```python
from llama_index.llms.litellm import LiteLLM

llm = LiteLLM(model="claude-3-5-sonnet-20241022")
```

LlamaIndex's query engines, chat engines, and agent frameworks work seamlessly with LiteLLM-powered models for RAG applications.

### Drop-in Replacement Patterns

The most powerful integration pattern is using the LiteLLM Proxy as an OpenAI API replacement. Configure any tool that expects an OpenAI-compatible endpoint to use your LiteLLM proxy instead:

```python
import openai

client = openai.OpenAI(
    api_key="your-virtual-key",
    base_url="http://localhost:4000"
)

# All calls now go through LiteLLM proxy with routing, caching, and logging
response = client.chat.completions.create(model="gpt-4", messages=messages)
```

This works with LangChain, LlamaIndex, AutoGen, CrewAI, and any other OpenAI-compatible tool.

## Enterprise Features

### User Management and RBAC

LiteLLM supports role-based access control with three built-in roles: Admin (full access), Internal User (specific model access), and Proxy User (API key access only). Teams can define custom roles with granular permissions per model and endpoint.

### Spend Tracking and Budget Alerts

The admin dashboard provides real-time spend tracking with breakdowns by user, model, provider, and time period. Budget alerts trigger at configurable thresholds, preventing bill shock from unexpected API usage.

### Logging and Observability

LiteLLM integrates with popular observability platforms:

- **LangSmith**: Trace requests through complex chains
- **Langfuse**: Open-source LLM observability
- **PromptLayer**: Prompt management and analytics
- **Weights & Biases**: Experiment tracking
- **OpenTelemetry**: Vendor-neutral observability

### Self-Hosted Deployment

The proxy deploys via Docker, Kubernetes, or cloud platforms. The database backend supports PostgreSQL for production workloads. SSO integration supports Google OAuth, Microsoft Entra ID, Okta, and generic SAML providers.

### SSO Integration

Enterprise deployments can require SSO authentication for proxy access. LiteLLM supports OIDC and SAML 2.0, integrating with existing identity providers for seamless team onboarding.

## Cost Optimization Strategies

### Routing to Cheapest Provider

Configure the proxy to route non-critical requests to the cheapest available model:

```yaml
model_list:
  - model_name: "cheap-llm"
    litellm_params:
      model: "together_ai/llama-3-8b"
  - model_name: "cheap-llm"
    litellm_params:
      model: "groq/llama-3-8b"
```

With `routing_strategy: cost-based`, requests automatically go to the lowest-cost option.

### Using Open-Source Models

For internal tools and development workflows, route requests to local models via Ollama or vLLM. This eliminates per-token costs entirely. Use GPT-4 only for production customer-facing features.

### Caching Frequently Asked Queries

Enable Redis caching for applications with repetitive queries. Customer support chatbots, FAQ systems, and internal knowledge bases often see 30-50% cache hit rates, directly reducing API spend by the same amount.

### Monitoring Spend Dashboards

Review the admin dashboard weekly to identify optimization opportunities. Common patterns include overuse of expensive models for simple tasks, forgotten development keys accumulating charges, and peak usage times that could benefit from cheaper provider routing.

## LiteLLM vs Alternatives

### LiteLLM vs Direct API Integration

| Feature | Direct Integration | LiteLLM |
|---------|-------------------|---------|
| Lines of code per provider | 50-100+ | 1 (model string) |
| Fallback handling | Manual | Automatic |
| Provider switching | Rewrite API calls | Change model string |
| Unified logging | Custom build | Built-in |
| Rate limit management | Per-provider | Centralized |
| Setup time | Days | Minutes |

### LiteLLM vs Portkey

Portkey is another popular LLM gateway. LiteLLM excels in open-source flexibility and provider coverage (100+ vs 20+), while Portkey offers stronger built-in prompt management and A/B testing features. LiteLLM is self-hostable for free; Portkey requires a paid plan for gateway deployment.

### LiteLLM vs LangChain's Model Abstraction

LangChain provides model abstractions but requires separate integration code for each provider class. LiteLLM's `completion()` function works outside LangChain and supports more providers with deeper feature parity. The tools complement each other, LiteLLM for the gateway layer and LangChain for the application layer.

## Production Deployment Guide

### Docker Deployment

The recommended production deployment uses the official Docker image:

```dockerfile
FROM ghcr.io/berriai/litellm:main-latest
COPY config.yaml /app/config.yaml
CMD ["--config", "/app/config.yaml", "--port", "4000"]
```

### Kubernetes Helm Chart

LiteLLM provides an official Helm chart for Kubernetes deployment:

```bash
helm repo add litellm https://berriai.github.io/litellm
helm install litellm litellm/litellm -f values.yaml
```

Configure replicas, resource limits, and ingress rules through `values.yaml`.

### Monitoring and Alerting

The proxy exposes Prometheus metrics at `/metrics` for monitoring request latency, error rates, token usage, and spend. Configure Grafana dashboards and set up PagerDuty alerts for critical thresholds.

### Security Best Practices

- Store master keys in a secrets manager (AWS Secrets Manager, Vault)
- Use virtual keys per team or application
- Enable request/response logging for audit compliance
- Deploy behind a load balancer with TLS termination
- Restrict proxy network access to internal services only

## Conclusion

LiteLLM solves one of the most painful problems in modern LLM development: managing multiple providers without code duplication. Its unified API, production-ready proxy server, and enterprise features make it the de facto standard for multi-provider LLM access in 2025.

Whether you are building a prototype with a single model or deploying a multi-tenant SaaS application with 20+ providers, LiteLLM reduces complexity and increases reliability. Start with the Python SDK for development and graduate to the proxy server for production.

The project is actively maintained with daily releases, responsive maintainers on GitHub, and a growing ecosystem of integrations. If you have not adopted an LLM gateway yet, LiteLLM is where you should start.

## Frequently Asked Questions

**Is LiteLLM free to use?**

Yes. LiteLLM is open-source under the MIT license and free for both personal and commercial use. You only pay for the LLM API calls you make to providers. The proxy server, Python SDK, and core features are all free. Enterprise features like SSO and advanced analytics are available in a paid LiteLLM Enterprise plan.

**Which LLM providers does LiteLLM support?**

LiteLLM supports over 100 providers including OpenAI, Anthropic, Google Gemini, Azure OpenAI, AWS Bedrock, Cohere, Mistral AI, Groq, Together AI, Hugging Face, Ollama, vLLM, AI21 Labs, and many more. The full list is available in the [official documentation](https://docs.litellm.ai/docs/providers).

**How does LiteLLM handle API key management?**

LiteLLM reads API keys from environment variables by default. In the proxy server, you define keys in the configuration file and create virtual keys for consumers. Virtual keys can have spend limits, model restrictions, and rate limits attached. Master keys protect the admin API while virtual keys protect the completion endpoint.

**Can LiteLLM work with self-hosted models?**

Absolutely. LiteLLM integrates with Ollama, vLLM, LM Studio, Hugging Face TGI, and any OpenAI-compatible local server. Simply point LiteLLM to the local endpoint URL and use the same unified API to call your self-hosted models alongside commercial ones.

**What is the difference between LiteLLM SDK and Proxy?**

The LiteLLM Python SDK is a library you import in Python code for programmatic LLM access. The Proxy Server is a standalone HTTP service that exposes OpenAI-compatible endpoints for applications in any language. Use the SDK for Python applications and the proxy for multi-language teams or when you need features like virtual key management, rate limiting, and spend tracking.

---

## Recommended Infrastructure

To run any of the tools above reliably 24/7, infrastructure matters:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit, 14+ global regions, one-click droplets for AI/dev workloads.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low latency for mainland China access. This is the same IDC hosting dibi8.com — production-proven.

*Affiliate links — no extra cost to you, helps keep dibi8.com running.*

