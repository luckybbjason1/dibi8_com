---
title: 'Unsloth 2026: 64.9k-Star Fast LLM Fine-Tuning — 2× Speed, 70% Less VRAM, Single-GPU Friendly'
description: 'Unsloth fine-tunes LLMs 2× faster with 70% less VRAM than HuggingFace TRL baselines. 64.9k GitHub stars, dual Apache 2.0 + AGPL-3.0 license. Supports Llama 3, Mistral, Qwen 3, Gemma, DeepSeek for LoRA / QLoRA / DPO / GRPO. Complete 2026 single-GPU fine-tuning guide.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - CUDA
  - Triton
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/unslothai/unsloth'
stars: 64900
maintainer: 'unslothai'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Unsloth', 'fine-tuning', 'LoRA', 'QLoRA', 'GRPO', 'fast training']
aliases:
  - /posts/unsloth-fast-llm-fine-tuning-2026/
---

If [Axolotl](/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) is the production multi-GPU fine-tuning framework, **Unsloth** is the single-GPU speed king. By rewriting the LLM training kernels in custom Triton + Python instead of relying on PyTorch's generic autograd, Unsloth fine-tunes models **2× faster** with **70% less VRAM** than HuggingFace TRL baselines.

64.9k GitHub stars, dual Apache 2.0 / AGPL-3.0 license. Supports 500+ models (Llama 3-3.2, Mistral, Qwen 3-3.6, Gemma, DeepSeek, Phi-4, gpt-oss). The default fine-tuning tool when you have a single 24 GB consumer GPU and need to iterate fast.

## TL;DR

- **What**: Fast single-GPU LLM fine-tuning library
- **GitHub**: 64.9k stars
- **License**: Dual Apache 2.0 + AGPL-3.0 (Apache for SaaS-friendly use; AGPL kicks in for derivative redistribution)
- **Speed**: 2× faster training, 70% less VRAM vs HF TRL baseline (some methods up to 80% VRAM reduction)
- **Models**: Llama 3-3.2, Mistral, Qwen 3-3.6, Gemma 1-4, DeepSeek, gpt-oss, Phi-4
- **Methods**: Full / LoRA / QLoRA / DPO / GRPO / FP8 training / pretraining
- **Hardware**: NVIDIA (RTX 30/40/50 series), AMD limited, Apple Silicon inference, CPU inference only

## 1. Why Unsloth's 2× Speed Is Real (and not marketing fluff)

Most "speedup" claims in ML are gimmicks (benchmark cherry-picked, etc.). Unsloth's is real and shows up in your training logs:

1. **Custom Triton kernels** for the matmul + softmax fused operations that dominate training time
2. **Manual gradient computation** (no PyTorch autograd overhead per step)
3. **Memory-efficient attention** with smarter activation checkpointing
4. **4-bit / 8-bit fast paths** that maintain accuracy but skip dequantization

The combined effect: Llama 3 8B QLoRA fine-tuning on RTX 3090 — HF TRL ~3.5 hr / 16 GB VRAM. Unsloth ~1.5 hr / 5 GB VRAM. Same dataset, same hyperparams, same final eval scores.

## 2. Hardware Reality

| GPU | Model size you can QLoRA-finetune (with Unsloth's 70% VRAM reduction) |
|---|---|
| 8 GB (RTX 3060 8GB) | Llama 3.2 3B QLoRA, Phi-4 mini |
| 12 GB (RTX 3060 12GB / 4070) | Llama 3.2 8B QLoRA, Mistral 7B QLoRA |
| 24 GB (RTX 3090 / 4090) | Llama 3.3 70B QLoRA (yes, on a single 4090!) |
| 48 GB (A6000) | Llama 3.3 70B LoRA, Mixtral QLoRA |

This is the "fine-tune on consumer hardware" story. Llama 70B QLoRA on a $1500 RTX 4090 was impossible with HF TRL — Unsloth makes it routine.

For cloud rentals: H100 on Vast.ai (~$1.50/hr) handles anything; for cheaper experiments, RTX 4090 instances at $0.40-0.60/hr work fine on a {{< aff "digitalocean" "unsloth-gpu" "DigitalOcean GPU droplet" >}}.

## 3. Quick Install (5 min)

```bash
pip install unsloth
```

Hello world — QLoRA fine-tune Llama 3.2 8B in ~20 lines:

```python
from unsloth import FastLanguageModel
from trl import SFTTrainer
from datasets import load_dataset

model, tokenizer = FastLanguageModel.from_pretrained(
    model_name = "unsloth/llama-3.2-8b-bnb-4bit",
    max_seq_length = 2048,
    load_in_4bit = True,
)

model = FastLanguageModel.get_peft_model(
    model, r=16, lora_alpha=32, target_modules="all-linear"
)

dataset = load_dataset("tatsu-lab/alpaca", split="train")

trainer = SFTTrainer(
    model = model,
    tokenizer = tokenizer,
    train_dataset = dataset,
    dataset_text_field = "text",
    max_seq_length = 2048,
    args = {"num_train_epochs": 1, "per_device_train_batch_size": 4},
)
trainer.train()
model.save_pretrained("./outputs/llama-alpaca-lora")
```

That's it. Same model, same data — running with Unsloth-optimized kernels.

## 4. The Pre-Quantized Model Catalog

Unsloth maintains pre-quantized 4-bit / 8-bit versions of popular models at `huggingface.co/unsloth`. Using these saves 5-15 minutes of initial download + quantization on every fresh run:

- `unsloth/llama-3.2-8b-bnb-4bit`
- `unsloth/mistral-7b-v0.3-bnb-4bit`
- `unsloth/qwen3-coder-14b-bnb-4bit`
- `unsloth/gemma-3-9b-bnb-4bit`
- `unsloth/DeepSeek-V3-bnb-4bit` (for the brave on 48 GB+)

Always check the Unsloth HF profile for pre-quantized versions of your target model before downloading from the original publisher.

## 5. GRPO — Fast Reinforcement Learning Fine-Tuning

GRPO (Group Relative Policy Optimization) is the 2026 default for RL fine-tuning (the technique behind DeepSeek-R1). Unsloth's GRPO implementation uses 80% less VRAM than HF TRL's, making GRPO feasible on a single 24 GB GPU instead of requiring a multi-GPU node.

```python
from trl import GRPOConfig, GRPOTrainer
from unsloth import FastLanguageModel, PatchFastRL

PatchFastRL("GRPO", FastLanguageModel)

# ... load model with FastLanguageModel as in section 3 ...

def reward_fn(completions, **kwargs):
    return [1.0 if "correct" in c else 0.0 for c in completions]  # your reward logic

trainer = GRPOTrainer(
    model=model,
    args=GRPOConfig(output_dir="./outputs/grpo", num_train_epochs=1),
    train_dataset=dataset,
    reward_funcs=[reward_fn],
)
trainer.train()
```

For domain-specific reasoning (math, code, structured output), GRPO + Unsloth on a single GPU is now the most cost-efficient way to bake reasoning improvements into a base model.

## 6. Unsloth vs Axolotl vs HuggingFace TRL

| Pick | When |
|---|---|
| **Unsloth** | Single GPU, fast iteration, RL fine-tuning, consumer hardware, prototyping |
| **Axolotl** | Multi-GPU production, multi-node, broad method support (DPO/IPO/KTO/ORPO/GRPO/GDPO), YAML config-as-code. See [Axolotl 2026 guide](/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) |
| **HuggingFace TRL** | Direct API access, custom RL algorithm research, you need to modify trainer internals |
| **Cloud platforms** (Together, Fireworks, OpenAI fine-tuning) | Don't want to own infra, don't care about weight portability |

The honest 2026 default: **Unsloth for the experiment phase, Axolotl for the production deploy phase**. Both wrap PyTorch + TRL underneath, so methods learned in Unsloth port to Axolotl.

## 7. License Caveat (the AGPL bit)

Unsloth is dual-licensed:
- **Apache 2.0**: covers the core library usage. Safe to use in any application
- **AGPL-3.0**: kicks in if you distribute a modified Unsloth or run it as a service that exposes Unsloth's API externally

Practical implications:
- ✅ Use Unsloth to fine-tune your model, deploy that model in any product. Fine.
- ✅ Fine-tune on a SaaS GPU you rent, take the weights to your own deployment. Fine.
- ⚠️ Build a "fine-tuning-as-a-service" that exposes Unsloth directly. AGPL triggered — your service must be AGPL.

For 99% of users (you're fine-tuning models for your own product), Apache is what applies.

## 8. Production Patterns

The two patterns most teams settle on:

**Pattern A — Pure Unsloth (single-GPU shop)**:
```
Rent RTX 4090 on Vast.ai → Unsloth QLoRA experiments → 
Merge LoRA + base → Push to HF Hub → Serve via vLLM
```

**Pattern B — Unsloth + Axolotl hybrid (production team)**:
```
Unsloth on dev laptop for 50 quick experiments
↓ winner found
Axolotl on 8× H100 cluster for final long-context, multi-epoch full fine-tune
↓ production model
Push to HF Hub → Serve via vLLM behind LiteLLM gateway
```

The hybrid pattern pays for the cluster only when you have a candidate worth scaling.

## 9. When NOT to Use Unsloth

- **Multi-node distributed training** — Unsloth focuses on single-GPU optimization. Axolotl handles multi-node better
- **You need cutting-edge fine-tuning research methods** — TRL gets new methods first; Unsloth adopts after stabilization
- **AMD GPUs primary** — Unsloth's AMD support is limited (works but not optimized); use Axolotl or TRL there
- **You don't actually need the speed** — If your job runs overnight anyway, the 2× speed doesn't matter, and HF TRL is more standardized

## TL;DR

Unsloth = **single-GPU LLM fine-tuning speed king**. 64.9k stars, 2× faster + 70% less VRAM vs HuggingFace TRL, dual Apache/AGPL license. Llama 70B QLoRA on a single RTX 4090 is now routine.

Pair with [Axolotl](/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) for the production multi-GPU phase. Rent a {{< aff "digitalocean" "footer-cta" "GPU instance" >}} or use Vast.ai when you need to train.

---

*Part of dibi8's Fine-Tuning Stack — see the upcoming Fine-Tuning Stack collection for the full pipeline from dataset prep to production deployment.*
