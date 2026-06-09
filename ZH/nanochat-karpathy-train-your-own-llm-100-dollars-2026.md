---
title: 'nanochat 2026：Andrej Karpathy 开源「百元 ChatGPT」——8000 行全栈 LLM 训练管道'
description: '由 Andrej Karpathy 开发的 nanochat 是完整的 LLM 训练管道——分词器、预训练、微调、评估、推理和聊天 UI，设计目标：在单节点 8×H100 上用不到 100 美元从零训练一个 GPT-2 级聊天机器人。'
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
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['nanochat', 'karpathy', 'LLM训练', 'PyTorch', 'GPT', '自托管LLM', '开源', 'transformer', '微调']
aliases:
- /zh/posts/nanochat-karpathy-train-your-own-llm-100-dollars-2026/
faqs:
  - q: 'nanochat 是什么？谁开发的？'
    a: 'nanochat 是 Andrej Karpathy（OpenAI 联合创始人、前特斯拉 AI 总监）开发的极简全栈 LLM 训练与推理管道。与他之前只覆盖预训练的 nanoGPT 不同，nanochat 包含完整流程：Rust BPE 分词器、预训练、有监督微调、评估、推理服务器和 ChatGPT 风格的聊天 UI，全部约 8000 行可读代码。'
  - q: '用 nanochat 训练模型需要多少钱？'
    a: 'Karpathy 估计从零训练一个 GPT-2 级聊天机器人约需 48–100 美元。训练运行在单节点 8×H100（云端约 24 美元/小时）。两小时可得到可对话的模型；四小时推理质量明显更好。与 2019 年训练 GPT-2 的 43000 美元相比，成本下降了三个数量级。'
  - q: 'nanochat 和 Ollama 有什么区别？'
    a: 'Ollama 是推理运行时——加载已有模型并提供服务。nanochat 是训练框架——从原始文本数据训练模型。Ollama 是汽车，nanochat 是制造汽车发动机的工厂。nanochat 也包含推理服务器和聊天 UI，但核心功能是训练。'
  - q: 'nanochat 使用什么训练数据？'
    a: 'nanochat 在 FineWeb（高质量网页文本数据集）上预训练，然后在 SmolTalk（用户-助手对话）、多选题和工具使用数据上进行监督微调。分词器也从同一数据集从零训练。不需要任何专有数据集。'
---

![nanochat 2026: Andrej Karpathy LLM 训练管道 — dibi8.com](/images/articles/nanochat-karpathy-train-your-own-llm-100-dollars-2026/cover.jpg)

2025年10月，Andrej Karpathy 发布了 [nanochat](https://github.com/karpathy/nanochat)，宗旨简单明了："花100美元能买到的最好 ChatGPT"。到 2026 年 6 月已积累 **54,700 个 GitHub Star**，成为开源社区阅读量最大的 LLM 训练教程。

## nanochat 是什么（和不是什么）

nanochat 不是对现有模型的封装，不是部署工具。它是完整的工厂：

1. **分词器（Rust）** — 从零在自己的数据上训练的 BPE 分词器，用 Rust 实现，速度快
2. **预训练（PyTorch）** — 在 FineWeb 上训练 Transformer，支持 FlashAttention-2、BF16 混合精度
3. **微调（SFT）** — 在 SmolTalk 对话数据、多选题和工具使用数据上微调
4. **评估** — 自动运行 CORE 基准测试，输出推理/知识/编程/指令跟随分数
5. **推理服务器** — 兼容 OpenAI chat completions 接口的 HTTP API
6. **聊天 UI** — 极简网页界面，可以直接对话

全部约 8000 行 Python 和 Rust。

## 百元训练成本

| 配置 | 时费 | 训练时间 | 总费用 |
|------|-----|---------|-------|
| 8× H100 (SXM5) | ~$24 | 2 小时 | ~$48 |
| 8× A100 (80GB) | ~$16 | 4 小时 | ~$64 |
| 8× H100 (PCIe) | ~$18 | 3 小时 | ~$54 |

可在 Lambda Labs、CoreWeave、vast.ai 或 RunPod 租用节点。

## 关键训练命令

```bash
# 训练分词器
python tokenize_dataset.py --dataset fineweb --vocab-size 32768

# 单节点 8GPU 预训练
torchrun --nproc_per_node=8 train_pretrain.py \
  --config configs/pretrain_fineweb_120m.yaml

# 监督微调
torchrun --nproc_per_node=8 train_sft.py \
  --pretrain-checkpoint checkpoints/pretrain_final.pt \
  --config configs/sft_smoltalk.yaml

# 启动推理服务器
python serve.py --checkpoint checkpoints/sft_final.pt --port 8000
```

## 适用人群

- **用 nanochat**：想从头理解 LLM 原理；需要可修改基准的研究者；要在自有数据上预训练领域模型；讲授 LLM 课程
- **不用 nanochat**：只想本地运行现有模型 → 用 [Ollama](/resources/llm-frameworks/ollama/)；需要生产级大规模推理 → 用 vLLM

## 2026 新增：autoresearch

2026年3月，Karpathy 发布 [autoresearch](https://github.com/karpathy/autoresearch)，AI agent 自动提交训练配置、监控 CORE 基准结果、提出假设驱动的后续实验。这是目前 nanochat 生态中最活跃的项目。

> **需要 GPU 算力训练模型？** [DigitalOcean 新用户享 $200 免费额度](https://m.do.co/c/eca87ac14ee0)，足够运行多次完整 nanochat 训练实验。GPU Droplet 按需使用，无长期承诺。

**GitHub：** [karpathy/nanochat](https://github.com/karpathy/nanochat) · 54.7k ⭐ · MIT
