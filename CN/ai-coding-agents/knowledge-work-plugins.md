---


title: "Install Knowledge Work Plugins"
description: "With 20,728 stars, it represents the gold standard for AI agent tool integration"
date: 2026-09-20
slug: "knowledge-work-plugins"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---



th--.png

* * *
## TL;DR

Knowledge Work Plugins is Anthropic's official plugin ecosystem that extends Claude's capabilities with structured tool calls for document editing, code analysis, web browsing, and file operations. With 20,728 stars, it represents the gold standard for AI agent tool integration.

**TL;DR: 20,728 stars** — Anthropic's most-starred plugin ecosystem.

## What Are Knowledge Work Plugins?

Knowledge Work Plugins provide a standardized interface between Claude and external tools. Rather than asking Claude to generate code that you then run, the plugin system allows Claude to directly interact with files, browse the web, execute commands, and perform other tasks through structured tool calls.

The plugin architecture follows a simple principle: Claude defines what it wants to do, and the plugin system executes it safely with proper permissions and error handling.

**Core Plugin Categories:**

- **Document Editing** — Read, write, and search files with structured edit operations
- **Code Analysis** — Parse codebases, generate diffs, run linters, and execute tests
- **Web Browsing** — Search the web, fetch URLs, and extract structured data
- **File Operations** — List directories, move files, manage project structures
- **Custom Plugins** — Build your own tools using the plugin SDK

````bash
# Install Knowledge Work Plugins
npx skills add https://github.com/anthropics/knowledge-work-plugins

# List available plugins
npx skills list | grep knowledge-work
`````

## How the Plugin System Works

The plugin system operates through a three-step cycle: 1. **Claude identifies a task** — The LLM determines it needs to perform an action beyond text generation
2. **Tool call is issued** — Claude sends a structured JSON request specifying the action and parameters
3. **Plugin executes and returns** — The plugin system runs the action in a sandboxed environment and returns results to Claude

`````python
# Example plugin invocation
from knowledge_work_plugins import PluginClient

client = PluginClient(plugins=["document-edit", "code-analysis", "web-browse"])

# Claude requests: "Update the README to include the new API endpoints"
response = client.call(
    plugin="document-edit",
    action="edit_file",
    params={
        "file": "README.md",
        "pattern": "## API Endpoints",
        "replacement": "## API Endpoints\n\n### GET /v2/users\nReturns paginated list of users.\n\n### POST /v2/users\nCreates a new user account.",
        "mode": "replace"
    }
)

print(response)  # {"status": "success", "lines_changed": 5}
`````

The sandboxing ensures Claude cannot perform destructive operations without explicit confirmation. Each plugin defines its own permission model, from read-only file access to full shell execution.

## Installation & Setup

Setting up Knowledge Work Plugins requires Python 3.10+ and a working Claude Code or Anthropic API integration: `````bash
# Clone the repository
git clone https://github.com/anthropics/knowledge-work-plugins.git
cd knowledge-work-plugins

# Install dependencies
pip install -r requirements.txt

# Initialize plugin configuration
cp plugins.config.example.yaml plugins.config.yaml
`````

### Plugin Configuration

Each plugin is configured independently in ``plugins.config.yaml``: `````yaml
plugins: document-edit: enabled: true
    max_file_size: 1048576  # 1MB
    allowed_extensions: - .md
      - .txt
      - .json
      - .yaml
      - .py
      - .js
      - .ts

  code-analysis: enabled: true
    linters: - pylint
      - eslint
      - tsc
    test_frameworks: - pytest
      - jest
      - vitest

  web-browse: enabled: true
    max_results: 20
    timeout: 30
    user_agent: "Knowledge-Work-Plugins/1.0"
`````

### Docker Setup

`````bash
# Build and run in Docker
docker build -t knowledge-work-plugins:latest .
docker run -v $(pwd)/plugins.config.yaml:/app/config.yaml knowledge-work-plugins:latest
`````

## Integration with Development Workflows

Knowledge Work Plugins integrates with every major development environment: | Environment | Integration Method | Best Plugin |
|
* * *
|
* * *
|
* * *
|
| **Claude Code** | Built-in plugin loader | document-edit |
| **Cursor** | Plugin SDK + VS Code extension | code-analysis |
| **VS Code** | Extension marketplace | web-browse |
| **IntelliJ** | Plugin marketplace | code-analysis |
| **Neovim** | LSP integration | document-edit |
| **GitHub Actions** | CLI tool | code-analysis |
| **GitLab CI** | Plugin runner | document-edit |

`````bash
# Integrate with GitHub Actions
# .github/workflows/plugin-audit.yml
name: Plugin Audit
on: [pull_request]
jobs: audit: runs-on: ubuntu-latest
    steps: - uses: actions/checkout@v4
      - uses: anthropics/knowledge-work-plugins@v1
        with: plugins: "code-analysis,docker-lint"
          config: plugins.config.yaml
`````

## Benchmarks: Plugin-Augmented vs Standard AI

The performance impact of adding structured tools to AI agents is measurable: `````
Task                          | Standard AI | Plugin-Augmented | Improvement

* * *
|
* * *
|
* * *
|