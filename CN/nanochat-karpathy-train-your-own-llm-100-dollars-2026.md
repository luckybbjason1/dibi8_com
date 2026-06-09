---
title: 'nanochat 2026: Andrej Karpathy''s Open-Source "ChatGPT for $100" — Full LLM Pipeline in 8,000 Lines'
description: 'nanochat by Andrej Karpathy is a single-file, full-stack LLM training pipeline — tokenizer, pretraining, finetuning, evaluation, inference, and chat UI — designed to train a GPT-2-level chatbot from scratch for under $100 on a single 8×H100 node.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Python', 'PyTorch', 'Rust', 'LLM Training']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/karpathy/nanochat'
backup_url: ''
github_repo: 'karpathy/nanochat'
stars: 54700
maintainer: 'karpathy'
last_maintained: '2026-06-01'
featureImage: '/images/articles/nanochat-karpathy-train-your-own-llm-100-dollars-2026/cover.jpg'
draft: false
categories: ['llm-frameworks']
tags: ['nanochat', 'karpathy', 'LLM-training', 'PyTorch', 'GPT', 'self-hosted-LLM', 'open-source', 'transformer', 'fine-tuning']
aliases:
- /posts/nanochat-karpathy-train-your-own-llm-100-dollars-2026/
faqs:
  - q: 'What is nanochat and who built it?'
    a: 'nanochat is a minimal, full-stack LLM training and inference pipeline built by Andrej Karpathy (founding member of OpenAI, former Director of AI at Tesla). Unlike his earlier nanoGPT which only covered pretraining, nanochat includes the complete pipeline: custom Rust BPE tokenizer, pretraining, supervised finetuning on conversations and tool use, evaluation, inference, and a working ChatGPT-style web UI — all in about 8,000 lines of readable Python and Rust.'
  - q: 'How much does it cost to train a model with nanochat?'
    a: 'Karpathy estimates roughly $48–$100 to train a GPT-2-capability chatbot from scratch. The training runs on a single 8×H100 GPU node (≈$24/hour on cloud rentals). Two hours gets you a working model; four hours produces a model that can hold a real conversation. The cost dropped by orders of magnitude vs. the original GPT-2 training because of improvements in hardware, software (FlashAttention, BF16, etc.), and better data (FineWeb).'
  - q: 'What training data does nanochat use?'
    a: 'nanochat pretrain on FineWeb (a high-quality web text dataset), then midtrains on SmolTalk (user-assistant conversations), multiple-choice QA, and tool-use data. The tokenizer is trained from scratch on the same data using a custom Rust BPE implementation. No proprietary datasets are required — everything is open and reproducible.'
  - q: 'What is the difference between nanochat and Ollama or vLLM?'
    a: 'Ollama and vLLM are inference runtimes — you load an existing pretrained model and serve it. nanochat is a training framework — it trains a model from raw text data, from the very first token. Think of Ollama as the car, and nanochat as the factory that builds the engine. The repo also includes an inference server and chat UI so you can talk to your trained model, but training is the core purpose.'
  - q: 'Can I finetune an existing model with nanochat instead of training from scratch?'
    a: 'The primary path in nanochat is full pretraining from scratch on FineWeb followed by supervised finetuning. However, the pipeline is explicitly designed to be "maximally forkable" — the modular structure makes it straightforward to replace the pretraining data loader with a starting checkpoint and proceed with just the SFT stage on your own data. Community forks have demonstrated this pattern.'
---

![nanochat 2026: Andrej Karpathy LLM Training Pipeline — dibi8.com](/images/articles/nanochat-karpathy-train-your-own-llm-100-dollars-2026/cover.jpg)

In October 2025, Andrej Karpathy announced [nanochat](https://github.com/karpathy/nanochat) with a simple premise: "The best ChatGPT that $100 can buy." By June 2026 it has accumulated **54,700 GitHub stars** and become the most-read LLM training tutorial in the open-source community. If you want to understand how ChatGPT works from the inside — and build your own version — nanochat is where you start.

## What nanochat Is (and Is Not)

nanochat is not a wrapper around an existing model. It is not a deployment tool. It is the complete factory:

1. **Tokenizer** — a custom Byte-Pair Encoding (BPE) tokenizer trained from scratch on your data, implemented in Rust for speed. You own the vocabulary; there's no dependency on tiktoken or sentencepiece.
2. **Pretraining** — a Transformer (GPT architecture) trained on FineWeb, a high-quality crawled web text dataset. Implements FlashAttention-2, BF16 mixed precision, and gradient checkpointing to fit large batches on a single node.
3. **Finetuning (SFT)** — trains the pretrained base model on user-assistant conversation data (SmolTalk), multiple-choice questions, and tool-use examples. This is the step that turns a next-token predictor into a chatbot.
4. **Evaluation** — runs the CORE benchmark suite automatically after each training stage, reporting reasoning, knowledge, coding, and instruction-following scores.
5. **Inference** — serves the trained model as an HTTP API compatible with the OpenAI chat completions spec.
6. **Chat UI** — a minimal web interface to talk to your model, equivalent to a local ChatGPT.

The whole thing is ~8,000 lines of Python and Rust. Karpathy describes it as "among the most unhinged I've written" — a compliment to its scope.

## The $100 Training Run

The advertised $100 assumes you rent a cloud GPU node. In 2026 prices:

| Config | Cost/hr | Time to train | Total cost |
|--------|---------|---------------|------------|
| 8× H100 (SXM5) | ~$24 | 2 hours | ~$48 |
| 8× A100 (80GB) | ~$16 | 4 hours | ~$64 |
| 8× H100 (PCIe) | ~$18 | 3 hours | ~$54 |

Two hours on 8× H100s produces a GPT-2-capability model you can have a real conversation with. Four hours gets you noticeably better reasoning. For comparison, training the original GPT-2 cost Karpathy ~$43,000 in 2019 using the compute available then.

You can rent these nodes from Lambda Labs, CoreWeave, vast.ai, or RunPod. The nanochat README includes exact cloud provider commands.

## Architecture Deep-Dive

### Tokenizer (Rust)

Most LLM toolkits delegate tokenization to Python bindings around a C library (sentencepiece) or a pre-trained vocabulary (tiktoken). nanochat trains its own BPE tokenizer from scratch on the pretraining corpus. The implementation is in Rust for throughput — tokenizing FineWeb at full dataset scale in Python would take hours.

Training the tokenizer is a separate command:

```bash
python tokenize_dataset.py --dataset fineweb --vocab-size 32768
```

### Pretraining (PyTorch)

The model is a standard decoder-only Transformer: multi-head self-attention, pre-RMSNorm, SwiGLU activations, RoPE positional embeddings. The default config is ~120M parameters (roughly GPT-2 medium), trainable to higher capacities by adjusting depth and width hyperparameters.

```bash
# Single-node 8-GPU pretraining
torchrun --nproc_per_node=8 train_pretrain.py \
  --config configs/pretrain_fineweb_120m.yaml
```

Key optimizations: FlashAttention-2 (40% speedup over vanilla attention), BF16 mixed precision (2× memory efficiency vs FP32), gradient checkpointing for long sequences, and DDP data parallelism across all 8 GPUs.

### Supervised Finetuning

After pretraining, you finetune on the SmolTalk dataset, which contains ~1M high-quality user-assistant conversations. The SFT stage takes less than 30 minutes on the same 8-GPU node.

```bash
torchrun --nproc_per_node=8 train_sft.py \
  --pretrain-checkpoint checkpoints/pretrain_final.pt \
  --config configs/sft_smoltalk.yaml
```

Tool-use data is included in the SFT stage, training the model to emit structured function-call JSON that downstream applications can parse.

### Evaluation (CORE)

After each training stage, nanochat runs the CORE benchmark automatically — a suite of reasoning, knowledge, coding, and math tasks. This gives you a single composite score to compare runs, ablations, and forks. The benchmark is designed to run fast (< 20 minutes) so it fits into the training loop without blocking iteration.

### Inference Server

The inference server implements the OpenAI `/v1/chat/completions` endpoint:

```bash
python serve.py --checkpoint checkpoints/sft_final.pt --port 8000
```

This means any tool built for the OpenAI API — Open WebUI, Cursor, Codestral clients — can point at your nanochat model with no modification.

## 2026 Addition: autoresearch

In March 2026 Karpathy published [autoresearch](https://github.com/karpathy/autoresearch), a companion repo where AI agents autonomously run nanochat training experiments and report findings. The agent submits batches of training configurations, monitors the CORE benchmark results, and proposes hypothesis-driven follow-up runs. It's currently the most active fork of the nanochat ecosystem.

## Who Should Use nanochat

**Use nanochat if:**
- You want to understand LLMs from first principles and have the code right in front of you
- You're a researcher who needs a clean, hackable baseline to test architectural changes
- You want to pretrain a domain-specific model on your own data (replace FineWeb with your corpus)
- You're teaching an LLM course and need a complete, readable codebase

**Don't use nanochat if:**
- You just need to run an existing model locally → use [Ollama](/resources/llm-frameworks/ollama/) instead
- You need production-grade serving at scale → use vLLM or TGI
- You want to finetune a large model (70B+) → nanochat's sweet spot is 100M–7B parameter models on a single node

## Related Projects in the nanochat Ecosystem

The community has built several projects on top of nanochat:

- **nanochat-VLM** — adds vision-language capabilities (image → text)
- **nanochat-workshop** (i-dot-ai) — a structured workshop curriculum for training LLMs step by step
- **nanollama** — a learning-from-scratch baseline extracted from nanochat discussion thread #557

If you just want to talk to a locally-served open model without training your own, start with [Ollama](/resources/llm-frameworks/ollama/) or [Open WebUI](/resources/llm-frameworks/open-webui/). If you want to understand what's inside the models those tools serve, nanochat is the answer.

> **Need GPU compute to train your model?** A cloud server is the fastest path to an 8-GPU training node. New users on [DigitalOcean get $200 in credits](https://m.do.co/c/eca87ac14ee0) — enough to run multiple full nanochat training experiments before your first invoice. DigitalOcean's GPU Droplets are available on-demand with no long-term commitment.

## Bottom Line

nanochat demystifies the entire LLM stack. In a world where most AI tooling hides complexity behind abstractions, it goes the opposite direction: every algorithm visible, every file readable, every component replaceable. The 54,700 stars reflect genuine community appreciation for what Karpathy has always done best — teaching by showing the code.

**GitHub:** [karpathy/nanochat](https://github.com/karpathy/nanochat) · 54.7k stars · MIT
