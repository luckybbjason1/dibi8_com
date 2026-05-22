---
title: 'Unsloth 2026：64.9k 星快速 LLM 微调 —— 2× 速度、70% 少 VRAM、单 GPU 友好'
description: 'Unsloth 微调 LLM 比 HuggingFace TRL 基线快 2× 且少用 70% VRAM。GitHub 64.9k 星，双 Apache 2.0 + AGPL-3.0 license。支持 Llama 3 / Mistral / Qwen 3 / Gemma / DeepSeek 的 LoRA / QLoRA / DPO / GRPO。2026 完整单 GPU 微调指南。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA, Triton]
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
tags: ['Unsloth', '微调', 'LoRA', 'QLoRA', 'GRPO', '快速训练']
aliases:
  - /posts/unsloth-fast-llm-fine-tuning-2026/
---

如果 [Axolotl](/zh/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) 是生产多 GPU 微调框架，**Unsloth** 是单 GPU 速度之王。通过用自定义 Triton + Python 重写 LLM 训练 kernel 而不依赖 PyTorch 通用 autograd，Unsloth 比 HuggingFace TRL 基线**快 2×** 且**少用 70% VRAM**。

64.9k GitHub 星，双 Apache 2.0 / AGPL-3.0 license。支持 500+ 模型（Llama 3-3.2 / Mistral / Qwen 3-3.6 / Gemma / DeepSeek / Phi-4 / gpt-oss）。单 24 GB 消费级 GPU 上要快速迭代时的默认微调工具。

## TL;DR

- **是什么**：快速单 GPU LLM 微调库
- **GitHub**：64.9k 星
- **License**：双 Apache 2.0 + AGPL-3.0（Apache 适合 SaaS 友好用；AGPL 在衍生重分发触发）
- **速度**：vs HF TRL 基线快 2× 训练 / 少 70% VRAM（部分方法 VRAM 节省达 80%）
- **模型**：Llama 3-3.2 / Mistral / Qwen 3-3.6 / Gemma 1-4 / DeepSeek / gpt-oss / Phi-4
- **方法**：Full / LoRA / QLoRA / DPO / GRPO / FP8 训练 / 预训练
- **硬件**：NVIDIA（RTX 30/40/50 系列）/ AMD 有限 / Apple Silicon 推理 / CPU 仅推理

## 1. Unsloth 的 2× 速度是真的（不是营销噱头）

多数 ML "提速"说法是噱头（基准 cherry-picked 等）。Unsloth 的是真的，在你训练日志里看得见：

1. 主导训练时间的 matmul + softmax fused 操作的**自定义 Triton kernel**
2. **手动梯度计算**（每步无 PyTorch autograd 开销）
3. **内存高效 attention** 配合更聪明 activation checkpointing
4. **4-bit / 8-bit 快速路径** 保持精度但跳过反量化

合成效果：Llama 3 8B QLoRA 微调在 RTX 3090 上 —— HF TRL ~3.5 小时 / 16 GB VRAM。Unsloth ~1.5 小时 / 5 GB VRAM。同数据集、同超参、同最终 eval 分。

## 2. 硬件现实

| GPU | 能 QLoRA 微调的模型大小（带 Unsloth 70% VRAM 减少）|
|---|---|
| 8 GB（RTX 3060 8GB）| Llama 3.2 3B QLoRA, Phi-4 mini |
| 12 GB（RTX 3060 12GB / 4070）| Llama 3.2 8B QLoRA, Mistral 7B QLoRA |
| 24 GB（RTX 3090 / 4090）| Llama 3.3 70B QLoRA（是的，单 4090 上！）|
| 48 GB（A6000）| Llama 3.3 70B LoRA, Mixtral QLoRA |

这是"消费级硬件微调"故事。Llama 70B QLoRA 在 $1500 RTX 4090 上 HF TRL 做不到 —— Unsloth 让它成日常。

云租：Vast.ai 上 H100（~$1.50/小时）能干一切；便宜实验 RTX 4090 实例 $0.40-0.60/小时在 {{< aff "digitalocean" "unsloth-gpu" "DigitalOcean GPU droplet" >}} 上跑得动。

## 3. 快装（5 分）

```bash
pip install unsloth
```

Hello world —— ~20 行 QLoRA 微调 Llama 3.2 8B：

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

完事。同模型同数据 —— 跑在 Unsloth 优化 kernel 上。

## 4. 预量化模型目录

Unsloth 在 `huggingface.co/unsloth` 维护流行模型的预量化 4-bit / 8-bit 版本。用这些每次新跑节省 5-15 分初始下载 + 量化：

- `unsloth/llama-3.2-8b-bnb-4bit`
- `unsloth/mistral-7b-v0.3-bnb-4bit`
- `unsloth/qwen3-coder-14b-bnb-4bit`
- `unsloth/gemma-3-9b-bnb-4bit`
- `unsloth/DeepSeek-V3-bnb-4bit`（48 GB+ 勇者用）

下原始发布者前总是先检查 Unsloth HF profile 有没有目标模型的预量化版。

## 5. GRPO —— 快速强化学习微调

GRPO（Group Relative Policy Optimization）是 2026 RL 微调默认（DeepSeek-R1 背后的技术）。Unsloth 的 GRPO 实现比 HF TRL 少 80% VRAM，让 GRPO 在单 24 GB GPU 上可行而不需多 GPU 节点。

```python
from trl import GRPOConfig, GRPOTrainer
from unsloth import FastLanguageModel, PatchFastRL

PatchFastRL("GRPO", FastLanguageModel)

# ... 用 FastLanguageModel 加载模型如第 3 节 ...

def reward_fn(completions, **kwargs):
    return [1.0 if "correct" in c else 0.0 for c in completions]  # 你的奖励逻辑

trainer = GRPOTrainer(
    model=model,
    args=GRPOConfig(output_dir="./outputs/grpo", num_train_epochs=1),
    train_dataset=dataset,
    reward_funcs=[reward_fn],
)
trainer.train()
```

领域特定推理（数学 / 代码 / 结构化输出），单 GPU GRPO + Unsloth 现在是把推理改进烤进基础模型的最经济方式。

## 6. Unsloth vs Axolotl vs HuggingFace TRL

| 挑 | 何时 |
|---|---|
| **Unsloth** | 单 GPU，快速迭代，RL 微调，消费级硬件，原型 |
| **Axolotl** | 多 GPU 生产，多节点，广方法支持（DPO/IPO/KTO/ORPO/GRPO/GDPO），YAML config-as-code。看 [Axolotl 2026 指南](/zh/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) |
| **HuggingFace TRL** | 直接 API 访问，自定义 RL 算法研究，要修改 trainer 内部 |
| **云平台**（Together / Fireworks / OpenAI 微调）| 不想拥有基础设施，不在乎权重可移植 |

2026 诚实默认：**实验阶段 Unsloth，生产部署阶段 Axolotl**。两者底下都包 PyTorch + TRL，所以 Unsloth 学的方法移植到 Axolotl。

## 7. License 警告（AGPL 那部分）

Unsloth 双 license：
- **Apache 2.0**：覆盖核心库使用。任何应用安全用
- **AGPL-3.0**：在你分发修改的 Unsloth 或运行暴露 Unsloth API 外部服务时触发

实际含义：
- ✅ 用 Unsloth 微调你的模型，把模型部署到任何产品。可以
- ✅ 在租的 SaaS GPU 上微调，权重拿到你自己部署。可以
- ⚠️ 建"微调即服务"直接暴露 Unsloth。AGPL 触发 —— 你的服务必须 AGPL

99% 用户（为自己产品微调模型）来说，Apache 适用。

## 8. 生产模式

多数团队定下来的 2 模式：

**模式 A —— 纯 Unsloth（单 GPU shop）**：
```
Vast.ai 租 RTX 4090 → Unsloth QLoRA 实验 → 
合 LoRA + base → 推到 HF Hub → 通过 vLLM 服务
```

**模式 B —— Unsloth + Axolotl 混合（生产团队）**：
```
开发笔记本上 Unsloth 做 50 次快速实验
↓ 找到赢家
8× H100 集群上 Axolotl 做最终长上下文、多 epoch full fine-tune
↓ 生产模型
推到 HF Hub → LiteLLM 网关后通过 vLLM 服务
```

混合模式只在有候选值得扩展时才付集群费。

## 9. 什么时候*不要*用 Unsloth

- **多节点分布式训练** —— Unsloth 聚焦单 GPU 优化。Axolotl 多节点处理更好
- **要前沿微调研究方法** —— TRL 先得新方法；Unsloth 稳定后采用
- **AMD GPU 主力** —— Unsloth AMD 支持有限（工作但不优化）；那用 Axolotl 或 TRL
- **你不真需要速度** —— 工作过夜跑反正 2× 速度无所谓，HF TRL 更标准化

## TL;DR

Unsloth = **单 GPU LLM 微调速度之王**。64.9k 星，vs HuggingFace TRL 快 2× + 少 70% VRAM，双 Apache/AGPL license。单 RTX 4090 上 Llama 70B QLoRA 现在是日常。

配 [Axolotl](/zh/resources/llm-frameworks/axolotl-llm-fine-tuning-framework-2026/) 做生产多 GPU 阶段。要训练时租 {{< aff "digitalocean" "footer-cta" "GPU 实例" >}} 或用 Vast.ai。

---

*dibi8 Fine-Tuning Stack 的一部分 —— 见即将上线的 Fine-Tuning Stack 合集，覆盖从数据集准备到生产部署的完整管线。*
