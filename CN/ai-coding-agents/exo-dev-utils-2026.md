---


title: "Talk to a local exo cluster with the standard OpenAI client"
description: "Technical guide and comparison"
date: 2026-09-20
slug: "exo-dev-utils-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "exo: Run Frontier AI Across Your Own Devices (45K Stars)...
description: "Technical guide and comparison"
date: 2026-06-02T00:00:00+08:00
lastmod: 2026-06-02T00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-06-02"
draft: false
categories: ["dev-utils"]
tags: ["]
aliases:
  - /posts/exo-dev-utils-2026/
faqs: - q: 'How do I install exo?'
    a: 'On a Mac", "the easiest way is the prebuilt app: ```bash brew install --cask exo ``` To run the latest source on macOS or Linux", "clone the repo and start it with ``uv``: ```bash git clone https://github.com/exo-explore/exo cd exo/dashboard && npm install && npm run build && cd .. uv run exo ```'
  - q: 'What hardware does exo run on?'
    a: 'exo runs on macOS and Linux. GPU acceleration currently targets Apple Silicon (for example M3 Ultra and M4 Macs); Linux is CPU-only for now", "with GPU support under development. You combine multiple devices into one cluster to pool their memory and compute.'
  - q: 'How do I start a cluster with exo?'
    a: 'Start exo on each device you want to include: ```bash uv run exo ``` Nodes discover each other automatically on the same network — there is no node list or master/worker config to write.'
  - q: 'How do I send a request to exo?'
    a: 'exo serves an OpenAI/Claude/Ollama-compatible API on port 52415. For example: ```bash curl -X POST http://localhost:52415/v1/chat/completions \ -H ''Content-Type: application/json'' \ -d ''{"model": "model-id", "messages": [{"role": "user", "content": "Hello"}"]}'' ```'
  - q: 'Where do I see the status of my cluster?'
    a: 'Open the dashboard in a browser at ``http://localhost:52415``. It shows every discovered device, how the model is split across them, and live throughput and memory usage.'