---
title: 'Axolotl 2026: The 12k-Star YAML-Driven LLM Fine-Tuning Framework — Complete Production Guide'
description: 'Axolotl is the open-source LLM fine-tuning framework with single-YAML config across full / LoRA / QLoRA / DPO / GRPO. 12k GitHub stars, Apache 2.0. Supports Llama / Mistral / Qwen / GLM / 10+ families. Complete 2026 install guide + when Axolotl beats Unsloth and raw HuggingFace TRL.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - CUDA
  - YAML
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/axolotl-ai-cloud/axolotl'
stars: 12000
maintainer: 'axolotl-ai-cloud'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Axolotl', 'fine-tuning', 'LoRA', 'QLoRA', 'DPO', 'open-source']
aliases:
  - /posts/axolotl-llm-fine-tuning-framework-2026/
---

If you've ever tried to fine-tune a Llama model and ended up writing 300 lines of PyTorch + DeepSpeed config + Hugging Face Trainer wrapper, you've felt the gap **Axolotl** fills. One YAML file describes your entire fine-tuning run — model, dataset, LoRA config, hyperparams, distributed strategy — and Axolotl handles the rest.

12k GitHub stars, Apache 2.0, supports every major LLM family (Llama, Mistral, Mixtral, Qwen, GLM, GPT-OSS, HunYuan, etc.) and every fine-tuning method that matters in 2026 (full, LoRA, QLoRA, GPTQ, QAT, DPO/IPO/KTO/ORPO preference tuning, GRPO/GDPO reinforcement learning, reward modeling).

This is the framework most production fine-tuning pipelines settle on when they outgrow Hugging Face TRL but don't want to commit to a closed cloud platform.

## TL;DR

- **What**: Open-source LLM fine-tuning framework, YAML-driven
- **GitHub**: 12k stars
- **License**: Apache 2.0 (safe for commercial use)
- **Models**: Llama, Mistral, Mixtral, Qwen, GLM, GPT-OSS, HunYuan, Granite, Pythia, more
- **Methods**: Full / LoRA / QLoRA / GPTQ / QAT / DPO / IPO / KTO / ORPO / GRPO / GDPO / reward modeling
- **Hardware**: NVIDIA Ampere+ or AMD GPUs, Python 3.11+, PyTorch ≥2.9.1

## 1. Why Axolotl Exists (the problem it solves)

Three common patterns Axolotl replaces:

1. **Custom HF Trainer scripts** — 300 lines of boilerplate per experiment, brittle, doesn't survive a framework version bump
2. **DeepSpeed config archaeology** — figuring out which combination of `zero_stage`, `offload_optimizer`, `gradient_checkpointing` works for your model size + GPU
3. **Cloud fine-tuning platforms** (Together, Fireworks, etc.) — easy but you don't own the resulting weights or the process

Axolotl gives you the "cloud platform" UX (one config file, one command) while keeping you on infrastructure you own and weights you control.

## 2. Hardware Reality

| Setup | Models you can fine-tune |
|---|---|
| 24 GB GPU (RTX 4090 / 3090) | Llama 3.2 8B QLoRA, Mistral 7B QLoRA |
| 48 GB GPU (A6000) | Llama 3.2 8B LoRA, Mistral 7B full fine-tune |
| 80 GB GPU (A100 / H100) | Llama 3.3 70B QLoRA, Mistral 8x7B QLoRA |
| 2× 80 GB (2× H100) | Llama 3.3 70B LoRA, Mixtral full fine-tune |
| 8× H100 cluster | Frontier-class full fine-tunes |

Cloud rental option: H100 on Vast.ai $1.50-2/hr, or for sustained workloads grab a {{< aff "digitalocean" "axolotl-gpu" "DigitalOcean GPU droplet" >}}. For shorter China-friendly latency, {{< aff "htstack" "axolotl-vps-hk" "HTStack Hong Kong" >}} works for the data prep + monitoring side (the actual training stays on rented GPUs).

## 3. Quick Install (15 min)

```bash
git clone https://github.com/axolotl-ai-cloud/axolotl
cd axolotl
pip install -e '.[flash-attn,deepspeed]'
```

A minimal training run — QLoRA fine-tune Llama 3.2 8B on a sample dataset:

```yaml
# config.yml
base_model: meta-llama/Llama-3.2-8B
datasets:
  - path: tatsu-lab/alpaca
    type: alpaca
adapter: qlora
lora_r: 16
lora_alpha: 32
load_in_4bit: true
num_epochs: 3
output_dir: ./outputs/llama-alpaca
```

```bash
axolotl train config.yml
```

That's it. The same YAML works on 1 GPU, 8 GPUs, or multi-node — Axolotl auto-detects via accelerate/DeepSpeed.

## 4. The YAML Config Is the Killer Feature

Why YAML is genuinely the right abstraction here:

- **Git-friendly**: every fine-tune is a config file in your repo. Reproducible by checkout.
- **Experiment matrix**: parameter sweeps via `yq` substitution or W&B sweeps. No 50 copy-pasted scripts.
- **Team handoff**: ML engineer writes the YAML, ops engineer runs it. Clear contract.
- **Auto-upgrade**: Axolotl maintains backwards compat for configs across versions, so your 6-month-old experiments still run.

Compare against custom scripts: every fine-tune was a snowflake, version bumps broke things, sharing across team was "here, copy my notebook."

## 5. Fine-Tuning Methods Cheat Sheet

| Method | When to use | VRAM (8B model) |
|---|---|---|
| **Full** fine-tune | Have lots of compute, want best quality | ~80 GB |
| **LoRA** | Most cases, balanced cost/quality | ~24-32 GB |
| **QLoRA** | Cheap experiments, tight VRAM | ~12-16 GB |
| **GPTQ** | Already-quantized models, inference-focused | ~8 GB |
| **DPO** | Preference data (chosen/rejected pairs), align without RL | LoRA + ~30% more |
| **GRPO** | Real RL with reward signal, math/code domains | LoRA + ~50% more |
| **KTO** | Binary preference (thumbs up/down), simpler than DPO | LoRA + ~30% more |

For most teams in 2026: QLoRA for experiments, LoRA for production deploys, DPO for alignment runs.

## 6. Real-World Workflow

```
1. Prepare dataset (JSONL with prompt/response or messages format)
   └─> push to HuggingFace Hub for versioning

2. Write Axolotl config.yml (model + dataset + method + hyperparams)
   └─> git commit (now reproducible)

3. Spin up GPU instance (Vast.ai / DigitalOcean / HTStack)
   └─> clone repo, pip install Axolotl

4. axolotl preprocess config.yml  (tokenize once, cache)
   └─> verify dataset stats match expectations

5. axolotl train config.yml
   └─> W&B logs PnL... err, loss curves. Train for N epochs.

6. axolotl inference --base-model llama3-8b --lora ./outputs/lora
   └─> Sanity-check responses on held-out prompts

7. Merge LoRA + base → push to HuggingFace Hub or serve via vLLM
```

The "30-line YAML + one command" workflow is what turns fine-tuning from a research project into a deployable engineering practice.

## 7. Axolotl vs Unsloth vs HuggingFace TRL

| Pick | When |
|---|---|
| **Axolotl** | Production fine-tuning pipelines, multi-node, broad method support (DPO/GRPO/KTO/ORPO), YAML-config-as-code workflow |
| **Unsloth** | Single-GPU, want 2× speed + 70% less VRAM, RL fine-tuning specifically. See our [Unsloth deep-dive](/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) |
| **HuggingFace TRL** | Low-level control, custom loops, research papers. Most production code now wraps TRL via Axolotl or Unsloth |
| **Together / Fireworks / OpenAI fine-tuning** | Don't want to own infra, don't care about weight portability, $$$ premium pricing |

Default 2026 recommendation: **Axolotl for production multi-GPU + Unsloth for fast single-GPU experiments**. They're complementary, not competitors.

## 8. Production Tips

The 5 things that bite first-time Axolotl users:

1. **Tokenizer pad token** — many configs miss `tokenizer.pad_token = eos_token`. Axolotl's defaults handle this for known models; verify for new ones
2. **`max_seq_length` and OOM** — start small (1024), bump until you OOM, then back off 10%. Don't guess
3. **Flash Attention compile time** — first install can take 20-30 min compiling FA2. Be patient
4. **Dataset format mismatch** — the `type` field must match your data. `alpaca` ≠ `sharegpt` ≠ `chat_template`. Read the docs
5. **DeepSpeed ZeRO stage confusion** — Stage 1 = no offload (fastest, most VRAM). Stage 2 = optimizer offload. Stage 3 = full param offload (slowest, least VRAM). Match to your VRAM budget

## 9. When NOT to Use Axolotl

- **You just want to chat with a local model** — Fine-tuning isn't needed. Use [Ollama](/resources/ai-tools/local-llm-runner-comparison-2026/) with a base instruct model
- **Tiny dataset (< 1000 examples)** — Few-shot prompting will probably beat fine-tuning, or use RAG (see our [Knowledge Base Stack](/collections/knowledge-base-stack/))
- **Already happy with the base model on your task** — Don't fine-tune just to fine-tune. Cost > benefit until you can prove benchmark improvement
- **You need <24 hour iteration cycles on a laptop GPU** — Unsloth's 2× speed and 70% VRAM reduction is the better fit

## TL;DR

Axolotl = **YAML-driven LLM fine-tuning framework, production multi-GPU default in 2026**. 12k stars, Apache 2.0, supports every major model family + every fine-tuning method that matters. Pairs with Unsloth (single-GPU speed) for a full experiment-to-production fine-tuning pipeline.

Spin up an H100 instance, write the 20-line YAML in section 3, and 15 minutes later you have a fine-tuning run going.

---

*Part of dibi8's Fine-Tuning Stack — pairs with [Unsloth for fast single-GPU iteration](/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/). For the full LLM ops picture see the upcoming Fine-Tuning Stack collection.*
