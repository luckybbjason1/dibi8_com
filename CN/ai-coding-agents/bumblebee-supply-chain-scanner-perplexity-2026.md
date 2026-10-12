---


title: "Routine daily inventory — global packages, toolchains, extensions, MCP configs"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "bumblebee-supply-chain-scanner-perplexity-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "Bumblebee 2026: Perplexity AI Open-Sources Its Internal ...
description: "Technical guide and comparison"
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: 'https://github.com/perplexityai/bumblebee'
backup_url: ''
last_maintained: "2026-05-22"
draft: false
categories: ["dev-utils"]
tags: ["bumblebee", "supply-chain", "security", "mcp", "developer-tools", "go", "npm", "pypi", "perplexity-ai"]
aliases:
  - /posts/bumblebee-supply-chain-scanner-perplexity-2026/
faqs: - q: 'What is Bumblebee and what does it scan?'
    a: 'Bumblebee is a read-only developer endpoint scanner open-sourced by Perplexity AI. It scans on-disk metadata for npm, pnpm, Yarn, Bun, PyPI, Go modules, RubyGems, Composer, MCP configurations, editor extensions (VS Code, Cursor, Windsurf, Zed), and browser extensions. It never executes install scripts or invokes package managers — it only reads what is already on disk.'
  - q: 'Why does Bumblebee matter for AI developers using MCP?'
    a: 'MCP (Model Context Protocol) servers run with elevated privileges on your machine. A compromised MCP package could exfiltrate data or run arbitrary code. Bumblebee is the first publicly available tool that scans MCP configuration files (claude_desktop_config.json, mcp_settings.json, .mcp.json, etc.) against its threat intelligence catalog, making it essential for anyone using Claude Desktop, Cursor, or other MCP-enabled tools.'
  - q: 'What are the three scan profiles?'
    a: 'Baseline scans your global package roots, toolchain installs, editor extensions, and MCP configs — suitable for routine daily inventory. Project focuses on configured development directories (e.g. ~/code or ~/src) alongside the baseline. Deep sweeps an operator-supplied root, typically your full home directory, and is designed for active incident response when you need certainty.'
  - q: 'How do I install and run Bumblebee?'
    a: 'Run ''go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1''. For a routine global inventory run ''bumblebee scan --profile baseline > inventory.ndjson''. For an exposure check against a specific advisory run ''bumblebee scan --profile deep --root "$HOME" --exposure-catalog ./catalog.json --findings-only --max-duration 10m''.'
  - q: 'Does Bumblebee run on Windows?'
    a: 'Bumblebee v0.1.1 supports macOS and Linux. Windows support is planned. For Windows users, running Bumblebee under WSL2 gives full coverage of Linux-side packages and MCP configs, though Windows-native paths (AppData, LOCALAPPDATA) require native Windows support.'