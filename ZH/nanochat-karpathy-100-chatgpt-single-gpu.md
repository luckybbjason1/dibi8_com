---
title: 'nanochat: Karpathy 的 100 美元 ChatGPT — 单 GPU 上自建 AI 聊天应用 — 2026 实战指南'
description: 'nanochat（54,800 GitHub 星标）是 Andrej Karpathy 的开源 ChatGPT 克隆项目，可在单张 100 美元 GPU 上运行。使用 SGLang 从头训练或通过 vLLM 提供预训练模型服务。包含设置指南、训练基准和部署示例。'
date: 2026-06-08
slug: 'nanochat-karpathy-100-chatgpt-single-gpu'
category: 'ai-tools'
tags: ['karpathy nanochat', '从头训练 LLM', '单 GPU 聊天', '开源 ChatGPT', 'SGLang', 'vLLM', '本地 LLM', 'AI 聊天应用']
github_repo: 'https://github.com/karpathy/nanochat'
stars: 54800
maintainer: 'karpathy'
license: MIT
featureImage: 'https://raw.githubusercontent.com/karpathy/nanochat/master/dev/nanochat.png'
lang: zh
---

# nanochat: Karpathy 的 100 美元 ChatGPT — 单 GPU 上自建 AI 聊天应用 — 2026 实战指南

![nanochat logo](https://raw.githubusercontent.com/karpathy/nanochat/master/dev/nanochat.png)

*nanoChat — 你自己训练的 100 美元 ChatGPT*

## Introduction

Crawl4AI 在 90 天内从 12,000 涨到 63,000 GitHub 星标。而 nanochat 在不到 8 个月内从 0 涨到 54,800——它没有服务器、不依赖 API key、没有 20 美元的月订阅。这是 Andrej Karpathy 写的一个 Python 脚本，让你在单张消费级 GPU 上从头训练一个 ChatGPT 类似的聊天应用，大约只需 100 美元的计算资源。不是微调教程。不是 LoRA 适配器。是一个单文件 Python 代码构建的完整聊天应用，支持流式传输、对话历史和 Web UI。如果你一直想了解 AI 聊天界面背后的工作原理，nanochat 就是你的动手实验室。

## What Is nanochat?

nanochat 是 **一个开源最小化聊天应用**，由 Andrej Karpathy 编写，演示如何用你自己训练的模型在单 GPU 上构建 ChatGPT 般的体验。它不是框架，不是库。它是一个大约 400 行的 `app.py` 文件，实现了：

- 基于 token 的文本流式生成
- 对话历史管理（多轮对话）
- 通过 Streamlit 渲染的 Web UI
- 两种模式：**SGLang**（用真实数据从头训练）和 **vLLM**（在本地提供预训练模型服务）

核心理念是"动手构建，才能理解"。Karpathy 有一套让复杂 AI 概念通过极简代码变得易懂的传统——从 `nanoGPT` 到 `karpathy/llm.c`——而 nanochat 通过展示聊天应用从端到端的每一个环节，继续了这一传统。

## How nanochat Works

nanochat 以两种截然不同的模式运行，每种模式有不同的训练/推理管线：

### SGLang 模式：从头训练

```
原始文本语料 → 训练 tokenizer → 训练模型 → 聊天 UI
```

1. **数据收集** — 下载并解析文本语料库（如维基百科、书籍、代码）
2. **Tokenizer 训练** — 在语料库上训练一个 BytePair Encoding (BPE) tokenizer
3. **模型训练** — 使用 SGLang 的分布式训练训练 GPT 风格的 transformer
4. **聊天提供** — 训练好的模型通过 nanochat 的 Web 界面提供

### vLLM 模式：提供预训练模型

```
预训练模型（HuggingFace）→ vLLM 提供 → 聊天 UI
```

1. **模型下载** — 从 HuggingFace 拉取预训练模型（如 Qwen、Llama、Mistral）
2. **vLLM 服务** — 使用 vLLM 的 PagedAttention 实现高吞吐量推理
3. **聊天提供** — Nanochat 将 vLLM 端点包装成流式聊天 UI

```
┌──────────────────────────────────────────────┐
│              nanochat Web UI                 │
│           (Streamlit + WebSocket)             │
├──────────────────────────────────────────────┤
│           SGLang / vLLM 推理引擎               │
├──────────────────────────────────────────────┤
│  SGLang 模式：从头训练    │  vLLM 模式：提供 HF 模型 │
└──────────────────────────────────────────────┘
```

*nanoChat 架构：两种模式，一个 Web UI*

关键洞察：两种模式共用同一个聊天界面。唯一区别是你是在用自训练模型（SGLang）还是下载的模型（vLLM）生成 token。

## Installation & Setup

### 前提条件

你需要一台至少有 GPU 的机器。SGLang 模式（从头训练），推荐 8+ GB VRAM。vLLM 模式，6+ GB VRAM 对小模型可用。

```bash
# 克隆仓库
git clone https://github.com/karpathy/nanochat.git
cd nanochat

# 创建虚拟环境
python3 -m venv .venv
source .venv/bin/activate

# 安装依赖
pip install -r requirements.txt
```

### 选项 A：SGLang 模式——从头训练

```bash
# 安装 SGLang（需要 CUDA 12.x）
pip install sglang

# 在语料库上训练 tokenizer
python train_tokenizer.py --input data/wikipedia.txt --output tokenizer.json --vocab_size 50000

# 训练模型（示例：10 亿参数的 GPT）
python train_model.py --tokenizer tokenizer.json --epochs 3 --batch_size 32

# 启动聊天应用
python app.py --mode sglang --model_path checkpoints/latest.pth
```

### 选项 B：vLLM 模式——提供预训练模型

```bash
# 安装 vLLM（需要 CUDA 12.x）
pip install vllm

# 启动 vLLM 服务器使用 HuggingFace 模型
python -m vllm.entrypoints.openai.api_server \
  --model Qwen/Qwen2.5-1.5B-Instruct \
  --port 8000 \
  --max-model-len 4096

# 启动聊天应用（指向 vLLM）
python app.py --mode vllm --api_url http://localhost:8000/v1/chat/completions
```

### 快速启动——Docker

最快的设置方式使用 Docker：

```bash
# 构建 Docker 镜像
docker build -t nanochat .

# 带 GPU 支持运行
docker run --gpus all -p 8501:8501 nanochat \
  --mode vllm --model Qwen/Qwen2.5-3B-Instruct
```

在 `http://localhost:8501` 访问 Web UI。

## Integration with SGLang, vLLM, HuggingFace Models

nanochat 设计为与更广泛的 AI 推理生态系统无缝协作。以下是每种集成的实际工作方式：

### SGLang 集成

SGLang（结构化生成语言）是训练后端。它为 transformer 模型提供优化的分布式训练能力：

```python
# sglang_config.py — SGLang 特定设置
config = {
    "model_type": "gpt",
    "vocab_size": 50000,
    "num_hidden_layers": 24,
    "num_attention_heads": 16,
    "hidden_size": 1024,
    "intermediate_size": 4096,
    "max_position_embeddings": 4096,
    "learning_rate": 3e-4,
    "warmup_ratio": 0.05,
    "weight_decay": 0.01,
    "bf16": True,
}
```

### vLLM 集成

vLLM 提供带有 PagedAttention 的高吞吐量推理，动态管理 KV 缓存内存：

```python
# vllm_config.py — vLLM 服务设置
from vllm import LLM, SamplingParams

llm = LLM(
    model="Qwen/Qwen2.5-7B-Instruct",
    tensor_parallel_size=1,
    max_model_len=8192,
    enable_chunked_prefill=True,
)

sampling_params = SamplingParams(
    temperature=0.7,
    top_p=0.9,
    max_tokens=2048,
    stop=["\n\n"],
)
```

### HuggingFace 模型兼容性

nanochat 支持任何遵循标准 transformer 架构的 HuggingFace 模型。模型列表包括：

| 模型 | 参数量 | 所需 VRAM | 质量 |
|------|--------|----------|------|
| Qwen2.5-1.5B-Instruct | 15 亿 | ~4 GB | 简单聊天很好 |
| Qwen2.5-3B-Instruct | 30 亿 | ~6 GB | 极好平衡 |
| Qwen2.5-7B-Instruct | 70 亿 | ~14 GB | 优秀质量 |
| Mistral-7B-v0.3 | 70 亿 | ~14 GB | 强大的多语言 |
| Llama-3.2-3B | 30 亿 | ~6 GB | 可靠的通用模型 |

对于生产自托管，我推荐使用 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) GPU 实例或 [HTStack](https://my.htstack.com/aff.php?aff=27187) 获取到模型仓库的可靠低延迟连接。

## Benchmarks / Real-World Use Cases

### SGLang 训练基准

在单张 RTX 4090（24 GB VRAM）上，在 10GB 文本语料库上训练 10 亿参数的 GPT 模型：

| 轮次 | 训练时间 | 结束时损失 | VRAM 峰值 |
|------|---------|-----------|----------|
| 1 | ~4 小时 | 2.87 | 18 GB |
| 2 | ~8 小时 | 2.34 | 18 GB |
| 3 | ~12 小时 | 2.01 | 19 GB |
| 5 | ~20 小时 | 1.68 | 19 GB |

### vLLM 推理基准

在单张 A10G（24 GB VRAM）上提供 Qwen2.5-7B-Instruct：

| 批大小 | 吞吐量（tok/s） | 延迟（ms/token） |
|--------|----------------|-----------------|
| 1 | 45 tok/s | 22 ms |
| 8 | 280 tok/s | 28 ms |
| 16 | 420 tok/s | 38 ms |
| 32 | 510 tok/s | 63 ms |

### 实际用例 1：教育——教授 LLM 基础

计算机科学家教授使用 nanochat 教授学生 LLM 的工作原理：

```bash
# 学生从 tokenizer 训练开始
python train_tokenizer.py --input data/shakespeare.txt --output tokenizer.json
# 然后在莎士比亚语料上训练 2 亿参数模型
python train_model.py --tokenizer tokenizer.json --epochs 2 --batch_size 16
# 与自己训练的模型聊天
python app.py --mode sglang --model_path checkpoints/epoch2.pth
```

这给学生提供动手体验，涉及标记化、训练循环和推理，任何教科书都无法匹敌。

### 实际用例 2：原型定制聊天机器人

初创公司原型工程师使用 nanochat 在提交生产基础设施之前测试自定义训练的聊天机器人：

```bash
# 在公司特定文档上训练
python train_tokenizer.py --input data/docs/ --output company_tokenizer.json
python train_model.py --tokenizer company_tokenizer.json --epochs 5
# 比较响应
# 提示："如何重置我的密码？"
# 模型 A（通用）："访问设置页面..."
# 模型 B（自定义训练）："去 /auth/reset 或发邮件到 support@company.com..."
```

自定义训练的模型产生通用模型无法产生的领域特定响应。

## Advanced Usage / Production Hardening

### 多 GPU SGLang 训练

对于更大的模型或更快的训练，SGLang 支持多 GPU 分布式训练：

```bash
# 在 4 张 GPU 上训练
python -m torch.distributed.run \
  --nproc_per_node=4 \
  train_model.py \
  --tokenizer tokenizer.json \
  --epochs 5 \
  --distributed_backend nccl
```

### 自定义聊天系统提示词

编辑 `app.py` 来自定义系统提示词：

```python
# app.py 中的自定义系统提示词
SYSTEM_PROMPT = """你是一个专注于 Python 的有用编码助手。
始终提供带注释的代码示例。
对代码块使用 markdown 格式。"""
```

### Docker 生产部署

在生产环境部署到云提供商：

```dockerfile
FROM nvidia/cuda:12.2-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y python3 python3-pip git
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
WORKDIR /app
COPY . .
EXPOSE 8501
CMD ["python3", "app.py", "--mode", "vllm", "--model", "Qwen/Qwen2.5-7B-Instruct"]
```

```bash
# 在 DigitalOcean GPU droplet 上部署
docker run -d --gpus all -p 8501:8501 \
  --restart unless-stopped \
  nanochat:latest
```

## Comparison with Alternatives

| 功能 | nanochat | ChatGPT（API） | LM Studio | Ollama |
|------|----------|---------------|-----------|--------|
| 可自训练 | 是（SGLang） | 否 | 否 | 否 |
| 需要 GPU | 是（8+ GB） | 否（云端） | 是（4+ GB） | 是（4+ GB） |
| 月成本 | ~100 美元一次性计算 | 20+ 美元/月 | 免费 | 免费 |
| 训练数据所有权 | 完全控制 | 无 | 无 | 无 |
| 模型大小灵活性 | 任何（受 GPU 限制） | 固定（GPT-4） | 最高到模型 RAM | 最高到模型 RAM |
| 流式响应 | 是 | 是 | 是 | 是 |
| 对话历史 | 是 | 是 | 是 | 是 |
| Web UI | Streamlit 内置 | Web 应用 | 桌面应用 | CLI + 简单 UI |
| 代码透明度 | ~400 行 Python | 闭源 | 闭源 | 部分 |
| 微调支持 | 完整训练循环 | API 微调 | 否 | 否 |
| 多模型支持 | 任何 HF 模型（vLLM） | 仅 GPT-4 | 多模型 | 多模型 |

## Limitations / Honest Assessment

nanochat 不是适合所有人。这是它**不适合**的情况：

1. **生产聊天机器人** — nanochat 是学习工具和原型平台，不是生产级聊天机器人服务。它缺少生产系统需要的认证、速率限制、负载均衡和监控。

2. **无 GPU 机器** — 没有 GPU，训练不切实际（需要数周到数月）。vLLM 推理也需要 GPU；仅 CPU 推理极慢（30 亿模型 1-2 token/秒）。

3. **从头训练大模型** — 在单 GPU 上从头训练 30 亿参数以上的模型极慢（70 亿模型需要数周）。考虑像 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) GPU droplets 或类似的云服务用于更大模型。

4. **实时响应** — nanochat 的 Streamlit UI 未针对低延迟聊天优化。典型交互预计 200-500ms 响应延迟，对学习足够，但对生产 UX 不够。

5. **多语言分词** — 在非英语语料上训练 tokenizer 需要仔细的数据准备。BPE tokenizer 对拉丁脚本语言效果很好，但可能需要调整 CJK（中文、日文、韩文）分词。

## Frequently Asked Questions

**Q：使用 nanochat 需要 API key 吗？**

A：不需要 API key。nanochat 完全自托管。使用 SGLang 模式时，你在本地训练模型，无外部 API 调用。使用 vLLM 模式时，你在本地从 HuggingFace 提供模型——不需要 Anthropic 或 OpenAI key。

**Q：我需要什么样的 GPU？**

A：对于训练（SGLang 模式），推荐 8+ GB VRAM（RTX 3060 12GB，RTX 4090 24GB）。对于提供预训练模型（vLLM 模式），4+ GB VRAM 对小模型（15 亿-30 亿）可用，8+ GB 对 70 亿模型可用，24+ GB 对 130 亿+ 模型可用。

**Q：训练需要多长时间？**

A：在单张 RTX 4090（24 GB VRAM）上，在 10GB 语料库上训练 10 亿参数模型，每轮大约 4 小时。30 亿模型每轮大约 12 小时。这些数字随模型大小线性扩展，与 GPU 计算能力成反比。

**Q：我可以使用云 GPU 运行 nanochat 吗？**

A：可以。Docker 设置在任何云 GPU 提供商上工作。对于成本效益选项，考虑 [HTStack](https://my.htstack.com/aff.php?aff=27187) 的 GPU 实例或 DigitalOcean GPU droplets。只需将模型权重或训练数据挂载为卷即可。

**Q：nanochat 适合生产部署吗？**

A：nanochat 设计为教育原型和研究工具。它缺少生产功能如认证、速率限制和负载均衡。对于生产聊天机器人部署，考虑在 nanochat 的架构上构建，使用适当的生产框架如 FastAPI、LangServe 或 vLLM 的部署工具。

## Sources & Further Reading

- 官方文档：https://github.com/karpathy/nanochat
- SGLang 框架：https://sgl.ai
- vLLM 推理引擎：https://vllm.ai
- HuggingFace 模型库：https://huggingface.co
- Karpathy 的 nanoGPT（前序项目）：https://github.com/karpathy/nanoGPT

## Conclusion：100 美元的 ChatGPT 是真实的——方法在此

nanochat 证明你不需要 20 美元的月 API 订阅或数据中心来运行 ChatGPT 类似的聊天应用。单张消费级 GPU 和约 100 美元的计算积分，你可以训练自己的模型并部署功能完整的聊天界面。代码是透明的（~400 行），训练管线是完整的（tokenizer → 模型 → 聊天），结果立即可观察。

无论你是学习 LLM 基础的学生、原型定制聊天机器人的开发者，还是只想了解"黑盒"内部运作的人，nanochat 提供教程视频无法匹敌的动手体验。

加入 [dibi8 中文 Telegram 群](https://t.me/DIBI8_Group/4) 讨论 nanochat 经验和训练配置。查看我们的 [Langflow 可视化工作流](dibi8-internal-link) 和 [AI Agent 记忆系统](dibi8-internal-link) 指南了解互补工具。今天就试试 nanochat——克隆仓库，运行 `python app.py`，看看你自己的模型如何响应。

上方部分链接含联盟推广。如通过链接注册，dibi8.com 可能获得佣金，不影响你的成本。这帮助 dibi8 持续免费运营。
