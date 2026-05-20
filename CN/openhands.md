---
title: 'OpenHands: 74K+ Stars — AI Software Engineer That Writes and Runs Code (2026 Setup Guide)'
description: 'OpenHands is an AI-driven development platform that acts as a software engineering agent. Compatible with VS Code, Docker, GitHub, GitLab, Claude, and OpenAI. Covers Docker setup, model configuration, headless CI/CD mode, and production hardening.'
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
github_repo: 'https://github.com/OpenHands/OpenHands'
stars: 74200
maintainer: 'OpenHands'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['OpenHands', 'AI coding agent', 'Docker', 'SWE-bench', 'Claude', 'OpenAI', 'self-hosted', 'automation']
aliases:
- /posts/openhands/
- /resources/llm-frameworks/openhands-architecture-ai-programmer-agent/
---

{{</* resource-info */>}}

## Introduction

Most AI coding tools stop at suggestions. You get a completion, paste it in, and hope it compiles. OpenHands takes a different approach: it is a full software engineering agent that reads your repository, edits files, runs tests, and iterates until the task passes. With over 74,000 GitHub stars and a 72% score on SWE-bench Verified, it is the most deployed open-source coding agent in production environments.

This guide walks you through installing OpenHands locally, connecting it to your preferred LLM provider, integrating it with GitHub, and running it in headless mode for CI/CD pipelines. Whether you want a local AI engineer for daily tasks or an autonomous agent for batch issue resolution, this tutorial covers every step with real commands and configs.

## What Is OpenHands?

OpenHands (formerly OpenDevin) is an open-source AI software engineering agent that runs inside Docker containers. It uses a controller-sandbox architecture where a Python-based controller manages the agent loop (observe, think, act) while isolated sandbox containers handle code execution, file operations, and test runs.

Key capabilities include:
- **Autonomous task execution**: Give it a GitHub issue or natural language task, and it resolves it end-to-end
- **Sandboxed code execution**: All code runs inside Docker containers, isolated from the host
- **Multi-agent delegation**: Complex tasks are split across specialized sub-agents
- **BYO model support**: Works with Claude, GPT, Gemini, local models via Ollama or vLLM, and 100+ providers via LiteLLM
- **Headless mode**: Programmatic API access for CI/CD and batch processing
- **Web UI + CLI**: Both a browser-based interface and a terminal-first workflow

## How OpenHands Works

The architecture has two main components:

**Controller Node**: A Python server that manages the agent loop, handles LLM abstraction via LiteLLM, and coordinates sandbox lifecycle. It receives tasks, breaks them into steps, calls the LLM for decisions, and tracks state across iterations.

**Sandbox Container**: A Docker container spawned per task where all code execution happens. The agent reads files, runs shell commands, executes tests, and writes patches inside this isolated environment. Once the task completes, the sandbox is destroyed.

![OpenHands Architecture](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/system_architecture_overview.png)

The agent loop follows this pattern:

```
1. OBSERVE: Read task description, repository state, previous action results
2. THINK: LLM generates a plan (which file to edit, what command to run)
3. ACT: Execute the planned action (read_file, write_file, run_cmd, etc.)
4. OBSERVE: Capture the result (output, errors, test results)
5. REPEAT: Iterate until the task is complete or max iterations reached
```

This loop typically runs 30-50 LLM calls per task. The memory condenser (added in v1.5) summarizes older context to keep the context window focused, improving latency and reducing token consumption on long tasks.

## Installation & Setup

### Prerequisites

Before installing OpenHands, ensure you have:

- **Docker Desktop** installed and running (Docker socket access required)
- **4GB+ RAM** (8GB recommended for concurrent sessions)
- **Python 3.12+** (for CLI installation via uv)
- An **LLM API key** (Anthropic, OpenAI, Google, or a local model endpoint)

### Option 1: CLI Installation with uv (Recommended)

The fastest way to get OpenHands running is through the uv-based CLI installer:

```bash
# Install uv if you don't have it
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install OpenHands
uv tool install openhands --python 3.12

# Launch the GUI server
openhands serve
```

The server starts at `http://localhost:3000`. Open your browser, select your LLM provider, enter your API key, and you are ready to assign tasks.

![OpenHands Web UI](https://raw.githubusercontent.com/All-Hands-AI/OpenHands/main/docs/static/img/screenshot.png)

To upgrade later:

```bash
uv tool upgrade openhands --python 3.12
```

### Option 2: Docker Direct Run

If you prefer Docker without installing Python tools:

```bash
# Pull the latest image
docker pull ghcr.io/openhands/openhands:latest

# Run with Docker socket mounted (required for sandbox management)
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest \
  ghcr.io/openhands/openhands:latest
```

The `--mount-cwd` flag mounts your current working directory into the sandbox:

```bash
openhands serve --mount-cwd
```

For GPU-accelerated local models:

```bash
openhands serve --gpu
```

### Option 3: pip Installation

```bash
pip install openhands-ai

# Start the web UI
openhands serve
```

### Windows Setup Notes

On Windows, run all commands inside WSL2 (Ubuntu):

```powershell
# In PowerShell as Administrator
wsl --install -d Ubuntu
wsl -d Ubuntu
```

Then inside WSL:

```bash
# Install Docker Desktop for Windows first, then:
uv tool install openhands --python 3.12
openhands serve
```

## Configuration & First Task

### Setting Up Your LLM Provider

After launching OpenHands, configure your model in the Settings panel (gear icon):

1. **Select Provider**: Anthropic (Claude), OpenAI (GPT), Google (Gemini), or Local
2. **Select Model**: `anthropic/claude-sonnet-4-20250514` is recommended for best results
3. **Enter API Key**: Paste your provider's API key
4. **Save Changes**

For advanced configuration, toggle the Advanced settings to set a custom model with the LiteLLM prefix format:

```
anthropic/claude-sonnet-4-5-20250929
openai/gpt-5-2025-08-07
gemini/gemini-3-pro-preview
deepseek/deepseek-chat
```

### Using a Local Model (Ollama)

For teams that need air-gapped deployments:

```bash
# Start Ollama with a capable coding model
ollama run qwen3-coder:32b

# In OpenHands settings, set:
# Custom Model: openai/qwen3-coder:32b
# Base URL: http://host.docker.internal:11434/v1
# API Key: ollama (any value works)
```

### Running Your First Task

With the UI open at `localhost:3000`:

1. Enter a task in the chat box: "Add a docstring to the main function in app.py"
2. The agent will spawn a sandbox, read the file, write the docstring, and confirm the change
3. Review the diff before accepting

For GitHub issue resolution:

```
Fix the authentication bug described in issue #42.
Clone the repo, reproduce the error, implement the fix, and run the test suite.
```

## Integration with VS Code, GitHub, Docker, and CI/CD

### VS Code Integration via Agent Control Plane (ACP)

OpenHands v1.5+ includes the Agent Control Plane for IDE integration:

```bash
# Install the OpenHands VS Code extension
# Search "OpenHands" in the VS Code Extensions marketplace

# Configure the extension to connect to your local OpenHands server
# Settings > OpenHands > Server URL: http://localhost:3000
```

The ACP protocol allows VS Code to send tasks directly to OpenHands and receive structured edits back as diff patches.

### GitHub Integration

Connect OpenHands to your GitHub repositories for automated issue resolution:

```bash
# Set a fine-grained GitHub PAT (Personal Access Token)
export GITHUB_TOKEN=ghp_your_token_here

# Launch OpenHands with GitHub credentials
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITHUB_TOKEN=$GITHUB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

In the UI, paste a GitHub issue URL and OpenHands will:
1. Clone the repository
2. Read the issue description
3. Reproduce the bug
4. Implement a fix
5. Run tests to verify
6. Generate a diff for review

### GitLab Integration

GitLab support (added in v1.5) works similarly:

```bash
export GITLAB_TOKEN=glpat-your-token
docker run -it --rm \
  -p 3000:3000 \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -e GITLAB_TOKEN=$GITLAB_TOKEN \
  ghcr.io/openhands/openhands:latest
```

### Docker Compose for Production

For persistent deployments, use Docker Compose:

```yaml
version: "3.8"
services:
  openhands:
    image: ghcr.io/openhands/openhands:latest
    ports:
      - "3000:3000"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./workspace:/workspace
    environment:
      - SANDBOX_RUNTIME_CONTAINER_IMAGE=ghcr.io/openhands/openhands:latest
      - LLM_API_KEY=${LLM_API_KEY}
      - LLM_MODEL=anthropic/claude-sonnet-4-20250514
      - SANDBOX_NETWORK_DISABLED=true
      - LOG_LEVEL=info
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
```

Deploy:

```bash
docker-compose up -d
```

### Headless Mode for CI/CD Pipelines

Headless mode runs OpenHands without the interactive UI, ideal for automation:

```bash
# Run a task headlessly
openhands --headless -t "Write unit tests for the auth module"

# Load task from a file
openhands --headless -f task.txt

# JSON output for pipeline parsing
openhands --headless --json -t "Fix the API endpoint in routes.py" > output.jsonl
```

Example GitHub Actions workflow:

```yaml
name: OpenHands Auto-Fix
on:
  issues:
    types: [labeled]
jobs:
  fix:
    if: github.event.label.name == 'auto-fix'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run OpenHands
        run: |
          docker run --rm \
            -v /var/run/docker.sock:/var/run/docker.sock \
            -v $(pwd):/workspace \
            -e LLM_API_KEY=${{ secrets.ANTHROPIC_API_KEY }} \
            ghcr.io/openhands/openhands:latest \
            openhands --headless --json \
            -f .openhands/task.txt > results.jsonl
```

### MCP Server Integration

OpenHands supports Model Context Protocol (MCP) servers for extended capabilities:

```json
{
  "mcpServers": {
    "fetch": {
      "command": "uvx",
      "args": ["mcp-server-fetch"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/workspace"]
    }
  }
}
```

## Benchmarks / Real-World Use Cases

### SWE-bench Verified Performance

SWE-bench Verified tests agents on 500 real GitHub issues. Higher scores mean the agent can autonomously resolve more production bugs.

| Agent + Model | SWE-bench Verified | Notes |
|---|---|---|
| OpenHands + Claude Opus 4.6 | ~72% | Best open-source framework result |
| OpenHands + Claude Sonnet 4.6 | ~67% | Recommended cost/quality balance |
| OpenHands + GPT-5 | ~55% | Good for teams already on OpenAI |
| OpenHands + Qwen3-Coder-32B (local) | ~32% | Acceptable for routine work |
| OpenHands + Devstral 24B | ~47% | Best open-weight model |
| Claude Code + Claude Opus 4.6 | ~78% | Highest first-pass success |
| Aider + Claude Opus 4.6 | ~62% | Strong CLI alternative |

### Cost Per Successful Fix

For a typical SWE-bench task consuming ~55K tokens:

| Model | Cost per Attempt | Success Rate | Cost per Success |
|---|---|---|---|
| Claude Opus 4.7 | ~$1.50 | 87.6% | ~$1.71 |
| GPT-5.3-Codex | ~$0.90 | 85.0% | ~$1.06 |
| Claude Sonnet 4.6 | ~$0.40 | 67% | ~$0.60 |
| Qwen3.6 Plus (hosted) | ~$0.20 | 78.8% | ~$0.25 |

### Real-World Deployment Metrics

Based on production deployments reported by the community:

- **Issue resolution**: 30-40% of labeled bugs resolved autonomously on first attempt
- **Code review assistance**: 60% reduction in review time for PRs under 200 lines
- **Test generation**: 80%+ coverage achieved on new modules with "write tests for X" prompts
- **Documentation**: 90%+ accuracy for docstring and README generation tasks

![OpenHands Star History](https://api.star-history.com/svg?repos=OpenHands/OpenHands&type=Date)

### Companies Using OpenHands

AMD, Apple, Google, and Netflix have all deployed OpenHands internally for automated maintenance tasks. The most common use cases are dependency upgrades across multiple repositories, vulnerability remediation sweeps, and PR review automation.

## Advanced Usage / Production Hardening

### Security Checklist

Running an autonomous code execution agent requires careful security setup:

**1. Sandbox Network Isolation**

```yaml
environment:
  - SANDBOX_NETWORK_DISABLED=true
```

This prevents sandbox containers from making outbound requests. Enable selectively only for tasks that need to install packages.

**2. Docker Socket Security**

The Docker socket mount is effectively root access. Mitigate with:

```bash
docker run --security-opt no-new-privileges \
  --cap-drop ALL \
  --cap-add SYS_ADMIN \
  -v /var/run/docker.sock:/var/run/docker.sock \
  ghcr.io/openhands/openhands:latest
```

**3. Fine-Grained GitHub PATs**

Never use org-wide tokens. Scope PATs to specific repositories:

```bash
# Create a fine-grained PAT at GitHub > Settings > Developer settings
# Select only: Contents (read/write), Issues (read), Pull Requests (write)
```

**4. Secret Management**

Mount secrets as read-only volumes instead of environment variables:

```yaml
volumes:
  - /var/run/docker.sock:/var/run/docker.sock
  - /opt/secrets:/secrets:ro
environment:
  - LLM_API_KEY_FILE=/secrets/anthropic_key
```

### Multi-Agent Delegation

For large features, enable multi-agent mode:

```bash
# In config.toml or via environment variables
[agent]
enable_multi_agent = true
max_subagents = 3
```

A parent agent decomposes "Build a REST API with authentication" into:
- Sub-agent 1: Implement the API endpoints
- Sub-agent 2: Write the authentication middleware
- Sub-agent 3: Create the database models

### Memory Condenser Tuning

For long-running tasks, adjust the memory condenser:

```toml
[llm]
enable_condenser = true
condenser_max_history = 240  # Summarize after 240 events (default: 240)
```

### Monitoring and Logging

Enable structured JSON logging for observability:

```bash
openhands --headless --json -t "Your task" 2>&1 | tee openhands.log
```

Parse the log for metrics:

```bash
# Count LLM calls
jq 'select(.type == "llm")' openhands.log | wc -l

# Find errors
jq 'select(.type == "error")' openhands.log

# Calculate task duration
jq 'select(.type == "finish") | .timestamp' openhands.log
```

### Scaling with Kubernetes

For team deployments, the community maintains a Helm chart:

```bash
# Add the OpenHands Helm repository
helm repo add openhands https://charts.openhands.dev
helm repo update

# Install with values
helm install openhands openhands/openhands \
  --set llm.apiKey=$LLM_API_KEY \
  --set llm.model=anthropic/claude-sonnet-4-20250514 \
  --set sandbox.networkDisabled=true \
  --set replicas=2
```

## Comparison with Alternatives

| Feature | OpenHands | Claude Code | Aider | Codex CLI |
|---|---|---|---|---|
| **License** | MIT (open source) | Proprietary (closed) | Apache-2.0 (open source) | Proprietary (closed) |
| **GitHub Stars** | 74,200 | N/A | 39,000 | N/A |
| **Interface** | Web UI + CLI | CLI only | CLI only | CLI only |
| **Sandboxing** | Docker containers | Host filesystem | Host filesystem | Host filesystem |
| **Model Support** | 100+ via LiteLLM | Claude only | 100+ via API | OpenAI only |
| **SWE-bench Verified** | ~72% (Claude) | ~78% (Claude) | ~62% (Claude) | ~55% (GPT) |
| **First-Pass Success** | ~65% | ~78% | ~71% | ~60% |
| **Multi-Agent** | Yes (native) | Yes (sub-agents) | No | No |
| **Self-Hosted** | Yes (default) | No | Yes | No |
| **Setup Time** | 10-15 min | 2 min | 5-10 min | 2 min |
| **Cost** | Free + API | $17-200/mo | Free + API | $20/mo + API |
| **CI/CD Integration** | Headless + JSON | Limited | Scriptable | Limited |
| **IDE Integration** | VS Code (ACP) | None | None | VS Code (official) |

### When to Choose Which

- **OpenHands**: You need a self-hosted, autonomous agent with sandboxed execution and multi-agent support. You want full control over the infrastructure and model choice.
- **Claude Code**: You want the highest first-pass success rate, already use Claude, and do not need self-hosting. You prefer a simple CLI without Docker complexity.
- **Aider**: You live in the terminal, want git-native operations with automatic commits, and need a lightweight tool without container overhead.
- **Codex CLI**: You are deeply integrated into the OpenAI ecosystem, want official VS Code support, and prefer a managed service.

## Limitations / Honest Assessment

OpenHands is not the right tool for every situation. Here is what it is NOT good for:

**1. Frontend/UI tasks with visual feedback**: The agent cannot "see" rendered output. Tasks like "center this button" or "fix the CSS gradient" often require multiple iterations because the agent lacks visual verification.

**2. Rapid prototyping**: The Docker sandbox spin-up adds 10-30 seconds of latency per task. For quick one-off edits, Aider or Cursor will be faster.

**3. Small machines without Docker**: If you cannot run Docker Desktop (corporate-locked laptops, ARM Chromebooks), OpenHands will not work. The Docker socket mount is a hard requirement.

**4. Ambiguous requirements**: Tasks like "improve the codebase" or "refactor for better architecture" send the agent into loops. It needs specific, testable instructions.

**5. Token costs on complex tasks**: Each task burns 30-50 LLM calls. At ~$0.01 per call for Claude Sonnet, that is $0.30-0.50 per task. For high-volume batch processing, costs add up quickly.

**6. Learning curve**: The multi-agent system, event streams, and configuration options are powerful but overwhelming compared to Devin's two-minute signup flow. Expect 1-2 hours of setup and experimentation before productive use.

## Frequently Asked Questions

### What hardware do I need to run OpenHands?

A modern CPU, 4GB RAM, and Docker Desktop are the minimum requirements. For local models, you need a GPU with at least 24GB VRAM (RTX 4090 or better) to run Qwen3-Coder-32B at acceptable speed. Cloud API models remove the GPU requirement entirely.

### Can I run OpenHands completely offline?

Yes, with a local model via Ollama, vLLM, or LM Studio. Set the base URL to your local endpoint (e.g., `http://localhost:11434/v1`) and use any value for the API key. Performance will be 20-30% behind frontier APIs on complex tasks, but it works for routine bug fixes and refactors.

### How does OpenHands compare to Devin?

Devin ($20-500/mo) is easier to set up (2-minute signup) but locks you into Cognition's model and infrastructure. OpenHands takes 10-15 minutes to set up but gives you full model choice, self-hosting, and no vendor lock-in. On SWE-bench Verified, OpenHands scores ~72% versus Devin's ~50%.

### Is my code safe with OpenHands?

Code runs inside Docker sandbox containers that are destroyed after each task. The sandbox has no network access if `SANDBOX_NETWORK_DISABLED=true` is set. However, mounting the Docker socket gives the controller significant host access, so run OpenHands on a dedicated machine or VM, not your production laptop.

### Can I use OpenHands with my existing CI/CD pipeline?

Yes, via headless mode. The `--headless --json` flags produce structured JSONL output that any CI system can parse. A typical GitHub Actions workflow clones the repo, runs OpenHands on labeled issues, and creates PRs from the generated diffs.

### What models work best with OpenHands?

Claude Sonnet 4.6 offers the best balance of cost and quality for most tasks. Claude Opus 4.6 gives the highest accuracy but at 3-4x the token cost. GPT-5 works well for teams already on OpenAI. For local deployment, Qwen3-Coder-32B or Devstral 24B are the best open-weight options.

### How do I debug when OpenHands gets stuck in a loop?

Check the event log in the UI for repeated failed actions. Common fixes: (1) provide more specific instructions, (2) switch to a stronger model, (3) break the task into smaller subtasks, or (4) increase the `max_iterations` limit in settings.

## Conclusion

OpenHands is the most capable open-source AI software engineering agent available in 2026. Its 74,000+ GitHub stars, 72% SWE-bench score, and Docker-sandboxed architecture make it the right choice for teams that need autonomous coding capabilities without vendor lock-in.

The setup takes 10-15 minutes: install via uv or Docker, configure your LLM provider, and start assigning tasks. For production use, enable sandbox network isolation, use fine-grained GitHub PATs, and deploy headless mode for CI/CD integration.

**Next steps:**
1. Clone the repository: `git clone https://github.com/OpenHands/OpenHands.git`
2. Install via `uv tool install openhands --python 3.12`
3. Launch with `openhands serve` and connect at `localhost:3000`
4. Join the community on Slack for support and feature updates



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [OpenHands GitHub Repository](https://github.com/OpenHands/OpenHands) — Source code and releases
- [Official Documentation](https://docs.openhands.dev/) — Complete setup and API docs
- [OpenHands LLM Configuration Guide](https://docs.openhands.dev/openhands/usage/llms/llms) — Model recommendations and provider setup
- [Headless Mode Documentation](https://docs.openhands.dev/openhands/usage/cli/headless) — CI/CD and scripting reference
- [SWE-bench Leaderboard](https://www.swebench.com/) — Official benchmark results
- [LiteLLM Provider Documentation](https://docs.litellm.ai/docs/providers) — Supported model providers
- [OpenHands Community Forum](https://github.com/OpenHands/OpenHands/discussions) — Q&A and troubleshooting
- [Agent Control Plane Docs](https://docs.openhands.dev/openhands/usage/key-features) — VS Code integration and multi-agent setup

---

*This guide is independently maintained and updated regularly. Last verified: May 2026.*
