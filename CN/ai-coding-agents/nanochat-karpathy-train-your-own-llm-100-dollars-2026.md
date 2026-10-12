---


title: "Single-node 8-GPU pretraining"
description: "AI tool comparison and guide"
date: 2026-09-20
slug: "nanochat-karpathy-train-your-own-llm-100-dollars-2026"
category: "ai-tools"
tags: ["ai", "tools"]

categories: ["ai-coding-agents"]---


title: "nanochat 2026: Andrej Karpathy''s Open-Source "ChatGPT f...
description: "AI tool comparison and guide"
date: 2026-06-09T00:00:00+08:00
lastmod: 2026-06-09T00:00:00+08:00
tech_stack: [Python, PyTorch, Rust, 'LLM Training']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/karpathy/nanochat'
backup_url: ''
last_maintained: "2026-06-01"
draft: false
categories: ["llm-frameworks"]
tags: ["nanochat", "karpathy", "llm-training", "pytorch", "gpt", "self-hosted-llm", "open-source", "transformer", "fine-tuning"]
aliases:
  - /posts/nanochat-karpathy-train-your-own-llm-100-dollars-2026/
faqs: - q: 'What is nanochat and who built it?'
    a: 'nanochat is a minimal, full-stack LLM training and inference pipeline built by Andrej Karpathy (founding member of OpenAI, former Director of AI at Tesla). Unlike his earlier nanoGPT which only covered pretraining, nanochat includes the complete pipeline: custom Rust BPE tokenizer, pretraining, supervised finetuning on conversations and tool use, evaluation, inference, and a working ChatGPT-style web UI — all in about 8,000 lines of readable Python and Rust.'
  - q: 'How much does it cost to train a model with nanochat?'
    a: 'Karpathy estimates roughly $48–$100 to train a GPT-2-capability chatbot from scratch. The training runs on a single 8×H100 GPU node (≈$24/hour on cloud rentals). Two hours gets you a working model; four hours produces a model that can hold a real conversation. The cost dropped by orders of magnitude vs. the original GPT-2 training because of improvements in hardware, software (FlashAttention, BF16, etc.), and better data (FineWeb).'
  - q: 'What training data does nanochat use?'
    a: 'nanochat pretrain on FineWeb (a high-quality web text dataset), then midtrains on SmolTalk (user-assistant conversations), multiple-choice QA, and tool-use data. The tokenizer is trained from scratch on the same data using a custom Rust BPE implementation. No proprietary datasets are required — everything is open and reproducible.'
  - q: 'What is the difference between nanochat and Ollama or vLLM?'
    a: 'Ollama and vLLM are inference runtimes — you load an existing pretrained model and serve it. nanochat is a training framework — it trains a model from raw text data, from the very first token. Think of Ollama as the car, and nanochat as the factory that builds the engine. The repo also includes an inference server and chat UI so you can talk to your trained model, but training is the core purpose.'
  - q: 'Can I finetune an existing model with nanochat instead of training from scratch?'
    a: 'The primary path in nanochat is full pretraining from scratch on FineWeb followed by supervised finetuning. However, the pipeline is explicitly designed to be "maximally forkable" — the modular structure makes it straightforward to replace the pretraining data loader with a starting checkpoint and proceed with just the SFT stage on your own data. Community forks have demonstrated this pattern.'