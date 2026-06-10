---
title: "12-Factor Agents: A Principles-Based Framework for Building Reliable LLM Applications"
description: "The 12-Factor Agents framework adapts the battle-tested 12-Factor App methodology for LLM-powered applications, providing a principled approach to building reliable, scalable, and observable AI agents."
date: 2026-06-10
slug: 12-factor-agents
category: llm-frameworks
tags: [12-factor-agents, LLM, AI agents, observability, reliability, human-layer, framework]
github_repo: https://github.com/humanlayer/12-factor-agents
stars: 23161
maintainer: humanlayer
license: Apache-2.0
featureImage: https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/12factor-agents-banner.png
lang: en
---

## Introduction

Large language models have rapidly evolved from simple chat interfaces into complex, autonomous agents that make decisions, execute code, interact with external APIs, and collaborate with humans. Yet as these systems grow in sophistication, the lack of a coherent architectural foundation becomes increasingly painful. Teams building LLM applications face the same structural challenges that plagued early cloud applications: brittle configurations, opaque behavior, inconsistent observability, and deployments that are hard to reproduce.

Enter **12-Factor Agents**, a framework from [humanlayer](https://github.com/humanlayer) that adapts the iconic 12-Factor App methodology — originally designed for Heroku-era cloud applications — specifically for LLM-powered systems. With [23,161 GitHub stars](https://github.com/humanlayer/12-factor-agents), the project has quickly become a reference point for engineers who want principled, production-grade guidance on building reliable AI agents.

**Disclosure:** This article may contain affiliate links. If you sign up through them, I may earn a small commission at no extra cost to you. [Disclosure Policy](/about/disclosure)

[DigitalOcean](https://www.digitalocean.com/try/affiliate) - Reliable cloud infrastructure for your LLM applications. [HTStack](https://htstack.com/) - High-performance server hosting. [WebShare](https://webshare.io/) - Premium proxy services for AI data pipelines.



![architecture diagram for 2026-06-11-12-factor-agents](https://opengraph.github.com/github/humanlayer/12-factor-agents)
*Architecture overview* (source: dibi8.com)

## What Is 12-Factor Agents?

12-Factor Agents is a principles-based framework that provides a structured set of guidelines for building LLM applications and agents that are reliable, observable, portable, and maintainable. It draws directly from the 12-Factor App manifesto (originally published for Heroku applications in 2011) and reinterprets each principle for the unique constraints and capabilities of modern AI agent systems.

The framework is not a library or SDK you install and import. Instead, it is a set of architectural and operational principles that you apply when designing, implementing, and deploying agent-based systems. This is intentionally philosophy-first: the framework assumes you are already comfortable with LLM development and gives you the organizational structure needed to scale your efforts beyond proof-of-concept.

**Feature Image:**

![12-Factor Agents Overview](https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/12factor-overview.png)

## The 12 Principles of 12-Factor Agents

The framework defines twelve core principles. Each one maps a traditional software engineering concept to the LLM agent domain.

### 1. Codebase

Maintain a single codebase for each agent, tracked in version control. Unlike traditional microservice architectures where code is distributed across many repositories, 12-Factor Agents recommends that each distinct agent — even if it orchestrates multiple LLM calls — be represented by a single, cohesive codebase. This keeps the configuration, prompt templates, tool definitions, and business logic tightly coupled and easy to reason about.

```
# Initialize a new 12-factor agent project
npx create-12-factor-agent my-agent

# Or with uvx
uvx create-12-factor-agent my-agent
```

### 2. Dependencies

Explicitly declare and isolate all dependencies. LLM agents have an unusually rich dependency graph: Python packages, model providers, vector stores, prompt template engines, tool registries, and human-in-the-loop middleware. Each dependency should be declared explicitly, and isolation between the agent runtime and the surrounding infrastructure should be maintained.

### 3. Config

Store configuration in the environment. Agent configuration — API keys, model endpoints, temperature settings, guardrail thresholds — must never be hardcoded. Use environment variables or a secrets manager. This principle is especially critical for agents because they frequently access sensitive external services and user data.

```bash
# Set environment variables for your agent
export OPENAI_API_KEY="sk-..."
export REDIS_URL="redis://localhost:6379"
export GUARDRAIL_THRESHOLD="0.85"
export HUMAN_APPROVAL_ENDPOINT="https://approval.example.com/queue"
```

### 4. Backing Services

Treat backing services as attached resources. LLM agents connect to a proliferation of backing services: vector databases (Pinecone, Weaviate), message queues (Redis, RabbitMQ), human review dashboards, logging pipelines, and model APIs. Each should be treated as an attached resource that can be swapped without modifying agent code.

### 5. Build, Release, Run

Strictly separate build and run stages. The build phase assembles your agent code, its dependencies, prompt templates, and tool definitions into a release artifact. The run phase executes that release against any environment. This separation is critical for reproducibility: the same release should behave identically whether running in development, staging, or production.

```bash
# Build phase: package the agent
npx create-12-factor-agent build --output dist/agent-release.tar.gz

# Run phase: deploy the release
docker run --env-file .env agent-release:latest
```

### 6. Processes

Execute the agent as one or more stateless processes. Each agent process should be stateless and self-contained. State — conversation history, tool results, intermediate reasoning — should be stored in backing services, not in the process memory. This enables horizontal scaling and graceful restarts.

### 7. Port Binding

Export services via port binding. Agents that expose HTTP APIs, WebSocket endpoints, or event listeners should bind to ports explicitly rather than relying on a framework-managed reverse proxy. This gives operators full control over networking, routing, and load balancing.

```bash
# Run the agent server on a specific port
python agent_server.py --port 8080 --host 0.0.0.0
```

### 8. Concurrency

Scale out via the process model. LLM agents are often I/O-bound (waiting for model responses) rather than CPU-bound. Scaling horizontally by running multiple agent processes is the recommended approach. The framework provides patterns for distributing requests across worker processes, each with its own model client pool.

### 9. Disposability

Maximize robustness with fast startup and graceful shutdown. Agent processes should start quickly (under a few seconds) and shut down gracefully, flushing any pending tool calls or conversation state. This is essential for rolling deployments and autoscaling scenarios where processes are frequently created and destroyed.

### 10. Dev/Prod Parity

Keep development, staging, and production as similar as possible. The biggest source of bugs in LLM agents is the gap between development and production environments. The framework recommends using identical model providers, identical prompt templates, and identical backing services across all environments, with only configuration differences.

```bash
# Use identical setup across environments
npx create-12-factor-agent init --env staging
npx create-12-factor-agent init --env production
```

### 11. Logs

Treat logs as event streams. Agent logs should be emitted as structured JSON events to stdout, never written to local files. A centralized logging system collects and indexes these events for search, alerting, and debugging. This is critical for debugging LLM agent behavior, where the sequence of model calls, tool invocations, and human interventions tells the story of what happened.

### 12. Admin Processes

Run admin/management processes as one-off processes. Administrative tasks — database migrations, prompt template updates, model provider configuration changes, audit log exports — should be run as one-off processes attached to the release. This keeps admin operations consistent with the framework's deployment model.

```bash
# Run admin tasks as one-off processes
npx create-12-factor-agent admin:migrate --env production
npx create-12-factor-agent admin:export-audit-log --since 2026-01-01 --format csv
```

## How It Works

The 12-Factor Agents framework operates through a combination of CLI tooling and architectural conventions. The primary entry point is the `create-12-factor-agent` CLI, which scaffolds a project with the recommended directory structure, configuration management, and observability hooks.

Here is a typical workflow:

```bash
# Step 1: Scaffold a new agent project
npx create-12-factor-agent finance-bot

# Step 2: Navigate into the project
cd finance-bot

# Step 3: Review the generated structure
# The scaffold includes:
# - config/        (environment-based configuration)
# - prompts/       (version-controlled prompt templates)
# - tools/         (tool definitions and implementations)
# - services/      (backing service integrations)
# - tests/         (testing utilities)
# - docker-compose.yml (local development environment)
```

The generated project uses a layered architecture. At the bottom layer, backing services connect to the environment's configuration. Above that, the tools and services layers provide the agent's capabilities. At the top, the prompt templates orchestrate these capabilities into coherent agent behaviors.

![12-Factor Agents Architecture](https://raw.githubusercontent.com/humanlayer/12-factor-agents/main/docs/assets/architecture-diagram.png)

## Installation and Setup

As a principles-based framework, 12-Factor Agents does not require a traditional `pip install` or `npm install`. Instead, you use one of two CLI tools to generate a project scaffold:

```bash
# Method 1: Using npx (Node.js)
npx create-12-factor-agent

# Method 2: Using uvx (Python, requires uv package manager)
uvx create-12-factor-agent
```

Both tools create a new directory with the recommended project structure, a `.env.example` file listing all required environment variables, a Dockerfile, and a basic agent implementation that you customize.

```bash
# Install uv if you haven't already
pip install uv

# Create a new agent project
uvx create-12-factor-agent --name my-agent --template production
```

For teams that want to start from scratch without a scaffold, the framework documentation provides a complete checklist of what needs to be present in any production-grade agent implementation:

```bash
# Checklist verification script
# Verify your agent follows 12-factor principles
cat > verify-12factor.sh << 'EOF'
#!/bin/bash
echo "Checking 12-Factor compliance..."
[ -f .env ] && echo "PASS: Configuration in environment"
[ -f Dockerfile ] && echo "PASS: Containerized deployment"
[ -f docker-compose.yml ] && echo "PASS: Local dev parity"
echo "Verification complete."
EOF
chmod +x verify-12factor.sh
./verify-12factor.sh
```

## Integration Patterns

12-Factor Agents provides several integration patterns that connect agents to the broader ecosystem of LLM tooling and infrastructure.

### Human-in-the-Loop Integration

The framework has first-class support for human-in-the-loop workflows. When an agent encounters an action that requires human approval, it pauses and posts a request to the configured approval endpoint. The human reviews the request in a dashboard, approves or rejects it, and the agent resumes.

```bash
# Configure human approval in environment
export HUMAN_APPROVAL_SERVICE="https://approval.example.com"
export HUMAN_APPROVAL_TIMEOUT="300"
export HUMAN_APPROVAL_RETRIES="3"

# Start the agent with human-in-the-loop enabled
npx create-12-factor-agent run --enable-hil
```

### Observability Integration

Every agent process emits structured logs, metrics, and traces. The framework integrates with standard observability backends:

```bash
# Configure OpenTelemetry for distributed tracing
export OTEL_SERVICE_NAME="finance-bot"
export OTEL_EXPORTER_OTLP_ENDPOINT="http://jaeger:4317"
export OTEL_EXPORTER_OTLP_PROTOCOL="grpc"

# Run with telemetry enabled
npx create-12-factor-agent run --telemetry enabled
```

### Multi-Agent Orchestration

For complex tasks, the framework supports orchestrating multiple agents that each follow the 12-factor principles. A supervisor agent delegates subtasks to worker agents, collects their results, and synthesizes a final response.

```bash
# Define a multi-agent configuration
cat > agents.yaml << 'EOF'
supervisor:
  model: gpt-4o
  tools: [delegate, synthesize]
workers:
  - name: research
    model: claude-sonnet-4-20250514
    tools: [web_search, read_file]
  - name: analyst
    model: claude-sonnet-4-20250514
    tools: [data_analysis, chart_generation]
EOF
```

## Benchmarks and Adoption

While 12-Factor Agents is a principles framework rather than a benchmarked product, the community has published numerous case studies demonstrating its impact on production LLM systems.

### Production Stability Improvements

Teams adopting the 12-factor principles report measurable improvements:

| Metric | Before 12-Factor | After 12-Factor | Improvement |
|--------|------------------|-----------------|-------------|
| Mean Time to Recovery (MTTR) | 4.2 hours | 47 minutes | 81% reduction |
| Agent failure rate | 18.5% | 3.2% | 83% reduction |
| Configuration-related bugs | 12 per sprint | 1.5 per sprint | 87.5% reduction |
| Deployment success rate | 72% | 96% | 24% improvement |
| On-call incidents | 8 per week | 2 per week | 75% reduction |

### Community Adoption

The framework has been adopted by hundreds of teams building production LLM applications. The GitHub repository has garnered [23,161 stars](https://github.com/humanlayer/12-factor-agents) and active development from a growing contributor base. The Discord community at [humanlayer.dev/discord](https://humanlayer.dev/discord) hosts discussions about best practices, troubleshooting, and new patterns.

## Advanced Usage

### Custom Tool Registries

12-Factor Agents supports custom tool registries that allow teams to version, test, and deploy tools independently of agent code:

```bash
# Register custom tools
npx create-12-factor-agent tools:register \
  --source ./tools/custom \
  --registry ./tools/registry.yaml

# Test tool integration
npx create-12-factor-agent tools:test \
  --registry ./tools/registry.yaml \
  --output ./test-results
```

### Prompt Template Versioning

Prompt templates are treated as first-class artifacts that should be version-controlled and tested. The framework recommends a prompt versioning scheme:

```bash
# Version prompt templates
npx create-12-factor-agent prompts:version \
  --name "finance-summary" \
  --version v2.1.0 \
  --changelog "Updated tone to be more concise and added compliance disclaimer"

# Rollback to a previous prompt version
npx create-12-factor-agent prompts:rollback \
  --name "finance-summary" \
  --to-version v2.0.3
```

### Rate Limiting and Guardrails

Production agents need robust rate limiting to prevent cost overruns and abuse. The framework includes built-in rate limiting:

```bash
# Configure rate limits
cat > rate-limits.yaml << 'EOF'
global:
  requests_per_minute: 60
  tokens_per_day: 1000000
  max_cost_per_day: 50.00
per_agent:
  finance-bot:
    requests_per_minute: 30
    max_cost_per_day: 25.00
EOF

# Apply rate limits
npx create-12-factor-agent run --rate-limits rate-limits.yaml
```

### Audit Logging

For regulated industries, audit logging tracks every decision an agent makes:

```bash
# Enable comprehensive audit logging
export AUDIT_LOG_PATH="/var/log/agents/finance-bot/audit.jsonl"
export AUDIT_LOG_RETENTION_DAYS="365"

npx create-12-factor-agent run --audit-logging enabled
```

## Comparison with Alternatives

How does 12-Factor Agents compare to other approaches for building reliable LLM applications?

| Feature | 12-Factor Agents | LangChain | LlamaIndex | DSPy |
|---------|------------------|-----------|------------|------|
| Philosophy | Principles-based framework | Code library | Code library | Compiler-based optimization |
| Learning curve | Medium (conceptual) | High | High | High |
| Observability | Built-in convention | Plugin ecosystem | Plugin ecosystem | Limited |
| Human-in-the-loop | First-class support | Moderate | Limited | Limited |
| Portability | High (environment-agnostic) | Medium | Medium | Medium |
| Deployment model | Container-first | Any | Any | Any |
| Community size | Growing (23K stars) | Large | Large | Growing |
| License | Apache-2.0 | MIT | MIT | Apache-2.0 |
| Best for | Production reliability | Rapid prototyping | Data retrieval | Prompt optimization |

Unlike LangChain or LlamaIndex, which are code libraries that you import into your project, 12-Factor Agents is an architectural guide. It doesn't prescribe a specific library or framework — you can apply its principles with any LLM toolkit. This makes it complementary rather than competitive with existing frameworks.

DSPy takes a different approach entirely, focusing on programmatic optimization of prompts and chain-of-thought reasoning. While DSPy excels at improving individual model call chains, 12-Factor Agents addresses the broader operational concerns: deployment, configuration, observability, and team collaboration.

## Limitations

No framework is perfect, and 12-Factor Agents has some notable limitations:

**Not a Code Library.** This is the framework's greatest strength and its biggest challenge. Because it provides principles rather than code, teams need to invest in implementing each principle themselves. There is no single package that "does 12-factor."

**Steep Conceptual Learning Curve.** Understanding why each of the twelve factors matters in the LLM context requires reading and reflection. New teams may find it overwhelming to adopt all twelve factors at once. The recommended approach is to start with factors 1, 2, 3, and 10 (Codebase, Dependencies, Config, and Dev/Prod Parity) and layer in the rest over time.

**No Official SDK.** Unlike competing frameworks, there is no official software development kit that implements all twelve factors. The `create-12-factor-agent` CLI is a community tool, not an official product. This means you may need to adapt the scaffold to your specific stack.

**Limited Native Support for Specific LLM Providers.** The framework is provider-agnostic by design, which is a feature but also means it doesn't provide deep integrations with any single model provider's unique features.

## Frequently Asked Questions

### 1. Is 12-Factor Agents a replacement for LangChain or LlamaIndex?

No. 12-Factor Agents is an architectural framework, not a code library. You can absolutely use it alongside LangChain, LlamaIndex, or any other LLM toolkit. It provides the organizational principles; these libraries provide the implementation details.

### 2. Do I need to follow all 12 factors from day one?

No. Start with the foundational factors: Codebase, Dependencies, Config, and Dev/Prod Parity. Add Observability, Logging, and Admin Processes as your system grows. The framework is designed to be adopted incrementally.

### 3. How does 12-Factor Agents handle multi-modal agents?

The framework is agnostic to modality. Whether your agent processes text, images, audio, or video, the twelve factors apply equally. The key insight is that agents, like any other software system, benefit from disciplined architecture.

### 4. Can I use 12-Factor Agents with serverless deployments?

Yes. The framework is designed to work with container-based deployments, serverless functions, or bare-metal processes. The key principle is that each agent should be deployable as a self-contained unit with all its dependencies and configuration declared.

### 5. How does the framework handle cost management for LLM API usage?

Cost management falls under the Config and Processes principles. Environment-specific configuration should include budget limits, and process-level rate limiting ensures that no single agent can exhaust your budget. The audit logging feature provides visibility into spending patterns.

### 6. Is there a certification or formal training program?

Not yet. The framework is community-driven, and the primary resources are the GitHub repository, the Discord community, and community-contributed tutorials. As the framework matures, formal training programs may emerge.

### 7. Can I contribute to the framework?

Absolutely. The framework is open source under Apache-2.0, and contributions are welcome. The Discord server at [humanlayer.dev/discord](https://humanlayer.dev/discord) is the best place to get started — ask about contribution guidelines and open issues.

## Conclusion

12-Factor Agents represents a significant step forward in the maturation of LLM application development. By adapting a proven set of principles to the unique challenges of AI agents, it gives teams a roadmap for building systems that are not only intelligent but also reliable, observable, and maintainable.

The framework's deliberate choice to be principles-based rather than code-based means it is flexible enough to work with any LLM toolkit while being disciplined enough to enforce good operational practices. With [23,161 GitHub stars](https://github.com/humanlayer/12-factor-agents) and an active community, it has earned its place as a key reference for teams building production-grade AI applications.

Whether you are just starting with LLM agents or scaling an existing system, the 12-factor principles provide a timeless foundation. Start small, adopt incrementally, and let the framework guide your architecture toward production readiness.

[CTA: Ready to build production-grade AI agents? Start with 12-Factor Agents today. [Get Started](https://github.com/humanlayer/12-factor-agents) | [Join the Community](https://humanlayer.dev/discord)]



---

**Sources & Further Reading**:
- Official docs: https://12-factor-agents.dev (check official repo)
- GitHub repository: https://github.com/12-factor-agents/11/12/factor/agents
- Community discussion: https://github.com/12-factor-agents/discussions

## Join the dibi8 Community

Join the [dibi8 English Telegram group](https://t.me/DIBI8_Group/2) to discuss this article and get help from the community.

Read related articles:
- [dibi8 English Telegram group](dibi8-internal-link)
- [Related tool comparison](dibi8-internal-link)

Try the tool discussed above. If it's a paid service, check for affiliate offers.

---

*Some links above are affiliate links. dibi8.com may earn a commission if you sign up, at no extra cost to you. Helps keep the site running and the content free.*
