---
title: 'Fine-Tuning Stack 2026: 5-Component Pipeline From Dataset to Production-Deployed LLM'
description: 'Complete LLM fine-tuning stack: Unsloth (fast single-GPU experiments) + Axolotl (production multi-GPU) + HuggingFace datasets/Hub + Weights & Biases (eval tracking) + vLLM (serving). $50-300/mo training infra. Full pipeline: dataset prep → experiment → production fine-tune → eval → deploy.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - CUDA
  - YAML
application_domain: Collections
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['Fine-Tuning', 'LLM', 'Stack', 'Collection']
aliases:
  - /posts/fine-tuning-stack/
---

LLM fine-tuning in 2026 finally has a coherent stack — the days of duct-taping HuggingFace Trainer + DeepSpeed configs + custom eval scripts are over. This collection assembles the **5-component pipeline** that takes you from raw dataset to a production-deployed fine-tuned model, with a clean split between fast iteration (Unsloth) and production deploy (Axolotl). $50-300/mo training infrastructure depending on scale.

If you're building a domain-specific model, instruction-tuning open-weight base models, doing DPO/GRPO alignment, or running production fine-tuning pipelines — this is the stack.

## TL;DR — The Stack at a Glance

| # | Component | Stage | Role | Deep dive |
|---|---|---|---|---|
| 1 | **Unsloth** | Experiment | Fast single-GPU fine-tuning, 2× speed + 70% less VRAM | [Unsloth 2026 guide](/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/) |
| 2 | **Axolotl** | Production | YAML-driven multi-GPU production fine-tuning | [Axolotl 2026 guide](/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) |
| 3 | **HuggingFace datasets + Hub** | Data | Version dataset, share with team, push trained weights | [HF docs] |
| 4 | **Weights & Biases (or alternative)** | Eval | Track loss curves, eval scores, hyperparameter sweeps | [W&B docs] |
| 5 | **vLLM** | Serving | Production multi-tenant serving of fine-tuned model | [Local LLM Runner comparison](/resources/llm-frameworks/local-llm-runner-comparison-2026/) |

**Total monthly cost** (excluding training capital):
- **Hobbyist** (rent GPU 10 hrs/week): **$30-60/mo**
- **Production team** (1-2 dedicated GPUs + monitoring): **$200-400/mo**
- **Small AI lab** (8× H100 cluster): **$2000-5000/mo**

Compare against managed fine-tuning platforms: Together fine-tuning ~$0.50/M tokens (adds up fast for big datasets), OpenAI fine-tuning $25/M tokens (insane at scale). Self-hosted beats both at any meaningful volume + you own the weights.

## 1. Why "The Fine-Tuning Stack" Needed Defining in 2026

Three shifts that crystallized the stack:

1. **Unsloth + Axolotl reached production maturity** — the "fast experiment + scale production" split is now clean
2. **GRPO became the default RL fine-tuning** (post-DeepSeek-R1) — both Unsloth and Axolotl support it natively
3. **Open-weight base models hit GPT-4 class** — Llama 3.3 70B, Qwen 3 32B, DeepSeek V3. Fine-tuning these for your domain now genuinely competitive with closed alternatives

Result: fine-tuning has moved from research → engineering practice. The stack reflects that.

## 2. Architecture — The Experiment-to-Production Pipeline

```
   ┌──────────────────────────────────────────────────┐
   │ Dataset (JSONL: prompt/response or messages)      │
   │  → HuggingFace datasets library                  │
   │  → Push to HuggingFace Hub (versioning)          │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ Experiment phase (single GPU, fast iteration)    │
   │  → Unsloth on rented RTX 4090 / H100             │
   │  → 50+ short QLoRA runs to find winning recipe   │
   │  → W&B logs loss curves + eval scores            │
   └────────────────┬─────────────────────────────────┘
                    │ (winning recipe identified)
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ Production phase (multi-GPU, long training)      │
   │  → Axolotl YAML config (git-tracked)             │
   │  → 8× H100 cluster for full / long-context fine-tune│
   │  → W&B logs final eval                            │
   └────────────────┬─────────────────────────────────┘
                    │
                    ▼
   ┌──────────────────────────────────────────────────┐
   │ Deploy phase                                     │
   │  → Merge LoRA + base weights                     │
   │  → Push merged model to HuggingFace Hub          │
   │  → vLLM serves the model behind LiteLLM gateway  │
   └──────────────────────────────────────────────────┘
```

The split is what makes this work — Unsloth's fast iteration for the "what works" exploration, Axolotl's robustness for the "now scale it" production run.

## 3. Component 1 — Unsloth (Experiment Phase)

**The role**: Where you spend 80% of your fine-tuning time. Iterate on dataset format, hyperparams, base model choice. Each experiment cycle: 30 min - 3 hours on a single rented GPU.

**Why Unsloth wins here**: 2× faster than HF TRL = 2× more experiments per dollar. 70% less VRAM = experiments on a $1500 RTX 4090 instead of needing an A100. See our [Unsloth deep-dive](/resources/llm-frameworks/unsloth-fast-llm-fine-tuning-2026/).

**Quick install**:
```bash
pip install unsloth
```

**Pattern**: rent RTX 4090 on Vast.ai ($0.40-0.60/hr) or RunPod, run 10-20 experiments over a weekend, find the winning recipe, capture in a notebook for team review.

## 4. Component 2 — Axolotl (Production Phase)

**The role**: When you've found the winning recipe, scale it up — full fine-tune, longer context, multi-epoch, multi-GPU. The YAML config Axolotl uses is git-trackable, ops-handoff-friendly.

**Why Axolotl wins here**: Multi-node distributed training that works out of the box, broadest method support (DPO/GRPO/KTO/ORPO/GDPO), config-as-code for reproducibility. See our [Axolotl deep-dive](/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/).

**Quick install**:
```bash
pip install axolotl
```

**Pattern**: Take the hyperparams from your Unsloth winning recipe → write Axolotl YAML → run on 8× H100 cluster (Vast.ai ~$15-25/hr) for the final 6-12 hour production run → push final weights to HF Hub.

## 5. Component 3 — HuggingFace Datasets + Hub (Data Layer)

**The role**: Version your dataset. Share datasets across team. Push trained model weights for collaborative testing.

**Why this is the obvious pick**: HF has won the AI dataset distribution layer (like GitHub for code, HF Hub for models + datasets). Every fine-tuning tool integrates with it natively.

**Quick install**:
```bash
pip install datasets
huggingface-cli login
```

**Pattern**:
```python
from datasets import load_dataset, Dataset

# Local prep + push
data = Dataset.from_json("my_data.jsonl")
data.push_to_hub("yourname/my-finetune-dataset", private=True)

# Team member loads
data = load_dataset("yourname/my-finetune-dataset")
```

For sensitive data (medical / financial / proprietary), use **private datasets** on HF Hub — they're access-controlled.

## 6. Component 4 — Weights & Biases (Eval Tracking)

**The role**: When you run 50 experiments to find the winning recipe, you need a way to compare them. W&B is the de-facto choice — auto-logs loss curves, eval scores, hyperparams, hardware utilization.

**Quick install** (works with both Unsloth and Axolotl via env var):
```bash
pip install wandb
wandb login
export WANDB_PROJECT="my-finetune-project"
```

Now every Unsloth / Axolotl training run auto-logs to your W&B dashboard.

**Cost**: W&B free tier is generous (single user, unlimited public projects). Team / private projects: $50/user/mo. Alternatives: **MLflow** (self-hosted, free, less polished), **TensorBoard** (basic but free + local).

## 7. Component 5 — vLLM (Serving Phase)

**The role**: Once you've fine-tuned a model, serve it to your users. vLLM is the production multi-tenant serving choice — PagedAttention + continuous batching make it the throughput champion.

See our [Local LLM Runner comparison](/resources/llm-frameworks/local-llm-runner-comparison-2026/) for the full rundown of why vLLM beats Ollama / LM Studio / llama.cpp for production multi-user serving.

**Quick install + serve a fine-tuned model**:
```bash
pip install vllm
vllm serve yourname/my-finetuned-llama \
  --enable-lora \
  --lora-modules my-lora=path/to/lora_weights \
  --port 8000
```

Behind a [LiteLLM gateway](/resources/llm-frameworks/litellm/) for auth + rate limiting + per-customer virtual keys = production-ready multi-tenant LLM API on infra you own.

## 8. Day 1 Pipeline Setup (3-4 hours)

1. **Datasets in JSONL format** (varies) — prep `train.jsonl` and `eval.jsonl`, push to HF Hub private
2. **Rent RTX 4090 GPU** (10 min) — Vast.ai or {{< aff "digitalocean" "ftstack-experiment-gpu" "DigitalOcean GPU droplet" >}} for experiment phase
3. **Install Unsloth + W&B** (10 min) — `pip install unsloth wandb`
4. **First QLoRA run** (60 min) — Section 3 of Unsloth guide, fine-tune Llama 3.2 8B for 1 epoch, verify W&B logs appear
5. **Iterate 5-10 short experiments** (~half a day) — vary learning rate, LoRA rank, dataset slice. Find the recipe with best eval score
6. **Translate recipe to Axolotl YAML** (30 min) — same hyperparams in YAML format, git commit
7. **Rent 8× H100 cluster** for production run (Vast.ai ~$15-20/hr × 6-12 hours = $90-240) on a {{< aff "htstack" "ftstack-prod-vps" "HTStack Hong Kong VPS" >}} for the data + monitoring side
8. **Run Axolotl production training** — pushes final weights to HF Hub
9. **Deploy via vLLM** — serve the fine-tuned model on a dedicated 24 GB GPU + LiteLLM gateway
10. **Eval against base model** — does your fine-tune actually beat the base on your eval set? If not, iterate

After 3-4 hours of setup + 1-2 weeks of experiments, you have your own fine-tuned model deployed in production.

## 9. Cost Breakdown

| Item | Hobbyist | Production team | Small AI lab |
|---|---|---|---|
| Experiment GPU (rented as needed) | $30-60/mo | $100-200/mo | $300-500/mo |
| Production training (rented for runs) | $0-50/mo | $200-400/mo | $1500-3000/mo |
| Dedicated serving GPU (vLLM) | $0 (use Ollama instead) | $200/mo (RTX 4090) | $1000/mo (H100) |
| HF Hub | $0 (free for public + private up to 1 GB) | $9/mo (Pro) | $20/user/mo (Enterprise) |
| W&B | $0 (free tier) | $50/user/mo | $50/user/mo |
| Misc storage / bandwidth | $5 | $20 | $50 |
| **Total** | **~$35-115/mo** | **~$580-880/mo** | **~$2870-4570/mo** |

Compare against managed: Together fine-tuning at $0.50/M tokens × 100M token dataset = $50 per fine-tuning run × 10 experiments = $500/mo just for experiments. Self-host wins above ~10 fine-tunes/month.

## 10. Upgrade Path

When you outgrow this stack:

- **Need to fine-tune > 70B models routinely** — Buy or long-lease H100 cluster instead of renting
- **Compliance / data residency** — Move from Vast.ai to dedicated bare-metal in your jurisdiction
- **Multi-tenant fine-tuning SaaS** — Add user isolation layer; consider LangSmith or similar managed eval
- **Continuous fine-tuning loop** — Pair with [AI Agent Tool Chain](/collections/ai-agent-tool-chain/) for automated retraining triggers when production model degrades
- **Domain-specific RL** — Add reward modeling + GRPO loops (both Unsloth and Axolotl support; just more compute-hungry)

## TL;DR — The Recipe

**5 components for production LLM fine-tuning, $50-300/mo for hobbyist to production team**:
1. **Unsloth** — fast single-GPU experiment phase
2. **Axolotl** — production multi-GPU phase
3. **HuggingFace datasets + Hub** — data versioning + model distribution
4. **Weights & Biases** — eval tracking
5. **vLLM** — production serving

Rent a {{< aff "digitalocean" "footer-cta" "GPU droplet" >}} for experiments, scale to Vast.ai 8× H100 for production runs, deploy final model on a dedicated 24 GB GPU. End-to-end self-hosted, weights you own, costs that scale with how serious you are.

---

*Companion collections: [Cheap LLM Stack](/collections/cheap-llm-stack/) covers the inference cost side post-deployment. [AI Agent Tool Chain](/collections/ai-agent-tool-chain/) for automated fine-tuning loops. [Knowledge Base Stack](/collections/knowledge-base-stack/) for RAG as an alternative to fine-tuning in some cases.*
