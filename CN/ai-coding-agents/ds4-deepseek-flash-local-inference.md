---


title: "DS4 (DwarfStar 4): Running DeepSeek V4 Flash Locally with Metal & CUDA — The Complete Guide"
description: "AI tool guide"
date: 2026-09-20
slug: "ds4-deepseek-flash-local-inference"
category: "ai-tools"
tags: ["ai", "tools"]
categories: ["ai-coding-agents"]
---


title: "DS4 vs Ollama vs llama.cpp: DeepSeek V4 Flash Local Infe...
  128GB Mac'
description: "AI tool guide"
  DeepSeek V4 Flash. Learn installation, benchmarks vs Ollama/llama.cpp, code examples,
  and how to run a 1M-context LLM locally on macOS and Linux.
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack: - C++
- Go
- Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
last_maintained: "2026-05-15"
draft: false
aliases:
  - /posts/ds4-deepseek-flash-local-inference/
- /posts/ds4-open-source-deepseek-alternative-2026/
faqs: - q: 'What is DS4 (DwarfStar 4) and who created it?'
    a: 'DS4 (DwarfStar 4) is a small, native inference engine purpose-built to run the DeepSeek V4 Flash model locally on Apple Metal and NVIDIA CUDA hardware. It was created by Salvatore Sanfilippo (antirez), the Italian programmer who created Redis.'
  - q: 'How much RAM do you need to run DeepSeek V4 Flash with DS4?'
    a: 'For the 2-bit (q2) weights you need a minimum of 96GB RAM, with 128GB recommended. The 4-bit (q4) weights require 256GB or more, which excludes most consumer laptops.'
  - q: 'How does DS4 compare to Ollama and llama.cpp for DeepSeek V4 Flash?'
    a: 'Because DS4 focuses on a single model, its asymmetric quantization, compressed KV cache, and custom Metal kernels typically deliver 20-40% better prefill throughput than Ollama on equivalent Apple Silicon. Unlike Ollama, it also persists the KV cache to disk, whereas Ollama wipes context on exit. It openly builds on llama.cpp and GGML but skips generic GGUF support to hardcode optimal layouts.'
  - q: 'What is DS4''s disk KV cache and why does it matter?'
    a: 'DS4 treats the KV cache as a first-class disk citizen, writing checkpoints to fast SSDs instead of keeping all state in RAM. This enables 100K-1M token context windows on RAM-limited machines and lets agent workflows resume a long conversation instantly without reprocessing the prompt.'
  - q: 'Does DS4 provide an OpenAI-compatible API server?'
    a: 'Yes. Building DS4 produces a ds4-server binary that exposes an OpenAI- and Anthropic-compatible HTTP API on http://127.0.0.1:8000, with endpoints including /v1/chat/completions, /v1/completions, and /v1/messages. It supports OpenAI-style function calling and works with agent frameworks like OpenCode, Pi, and Claude Code.'