---
title: 'Ollama vs LM Studio vs llama.cpp vs vLLM 2026：诚实的本地 LLM 运行器选型指南'
description: '2026 四家本地 LLM 运行器直接对比。真实数字：Ollama（137k 星）最易、LM Studio UI 最美、llama.cpp（112k）是底下的引擎、vLLM（80.7k）是生产吞吐之王。30 秒决策树按场景。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, C++, CUDA, Metal]
application_domain: Llm Frameworks
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
categories: ['llm-frameworks']
tags: ['Local LLM', 'Ollama', 'vLLM', 'llama.cpp', 'LM Studio', '对比', 'Hub文章']
aliases:
  - /posts/local-llm-runner-comparison-2026/
---

2026"本地跑 LLM"的答案碎片化成 4 个严肃选择，各有明确甜点。这是我们希望早有的 hub article —— **Ollama**（137k 星，默认）、**LM Studio**（UI 最美，对非程序员最易）、**llama.cpp**（112k 星，多数其他工具底下的 C/C++ 引擎）、**vLLM**（80.7k 星，生产吞吐之王）的硬碰硬。

只有 60 秒：读第 2 节，对号入座挑你的行。其余给团队问"为什么选这个"准备。

## 1. 为什么"同一件事"4 个工具并存

看起来做同一件事 —— 加载模型 / 生成 token —— 但底层目标分歧：

- **Ollama** 优化"5 分钟从装到首个 token"
- **LM Studio** 优化"非开发者能用"
- **llama.cpp** 优化"任何带 CPU 设备都能跑"
- **vLLM** 优化"100 并发用户大 GPU 最大吞吐"

可以用错的但还能工作 —— 但你要么感到摩擦（vLLM 做轻度本地 chat）要么撞墙（Ollama 想服务 50 并发用户）。挑第 2 节匹配你那行的。

## 2. 30 秒决策树

| 你的情况 | 挑 |
|---|---|
| 单干 dev，5 分钟内要本地 LLM，CLI 没问题 | **Ollama** |
| 非程序员想要桌面 app 跟本地 LLM 聊 | **LM Studio** |
| 跑 Raspberry Pi / 怪硬件 / 要最大控制 | **llama.cpp** 直跑 |
| 生产服务 10+ 并发用户在真 GPU 上 | **vLLM** |
| Apple Silicon Mac，要最佳 M 系列性能 | **llama.cpp**（Metal 支持最好）或 **LM Studio**（底下用 llama.cpp）|
| 给 app 做自托管多租户 LLM API | **vLLM** 配 [LiteLLM 网关](/zh/resources/llm-frameworks/litellm/) |

挑了一个？剩下文章论证选择。

## 3. Ollama —— 单干 dev 默认

**定位**：一条安装命令。`ollama run llama3.2`。5 分钟内在聊。底下用 llama.cpp —— Ollama 是"llama.cpp 加好 UX 加模型目录"。

**真实数字**：
- **GitHub 星**：137k（四家最多）
- **License**：MIT
- **吞吐**：M2 / RTX 3060 上 7B 模型 ~20-25 tok/秒（单用户 chat 好，服务不行）
- **硬件**：NVIDIA / AMD（ROCm）/ Apple Silicon（Metal）。CPU fallback 行
- **杀手特性**：`ollama.com/library` 巨大模型目录 —— 一条命令拉量化 GGUF 模型

**Ollama 赢的场景**：单干 dev 编程 agent（配 Continue / OpenCode），单用户 chat，原型。我们的 [便宜 LLM Stack](/zh/collections/cheap-llm-stack/) 和 [自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/) 合集默认选它就因为 5 分钟设置曲线。

**Ollama 输的场景**：多用户服务（Ollama 默认按串行队列请求）。10+ 并发用户切 vLLM。

```bash
# 装 + 30 秒内跑模型
curl -fsSL https://ollama.com/install.sh | sh
ollama run qwen3-coder:14b
```

## 4. LM Studio —— 非程序员的桌面 app

**定位**：拖拽桌面 app（Windows / macOS / Linux）。浏览内置模型目录，点"下载"，点"chat"。零 CLI 暴露。

**真实状态**：
- **License**：闭源 freeware（个人免费；商用要 license）
- **引擎**：底下用 llama.cpp（同 GGUF 模型格式）
- **杀手特性**：可视模型浏览、含历史的 chat UI、拖拽本地文件 RAG、OpenAI 兼容 API server（一键"start server" → 暴露 `http://localhost:1234/v1`）
- **硬件**：同 llama.cpp 覆盖 —— NVIDIA / AMD / Apple Silicon（Metal 优化）/ CPU fallback

**LM Studio 赢的场景**：你的数据分析师 / PM / 高管想跟本地模型 chat 但不学终端。或要精美桌面 UI 测模型再通过 Ollama / vLLM 集成进 app。

**LM Studio 输的场景**：服务器部署（是桌面 app）、商用（许可成本）、版本控制工作流（无 Git 友好配置）。

**推荐配对**：LM Studio 探索 → Ollama 日用 server → vLLM 生产规模。

## 5. llama.cpp —— 底下的引擎

**定位**：Ollama / LM Studio / 几十个其他项目底下用的 C/C++ 推理引擎。直接跑它拿最大控制 + 比 wrapper 暴露的领先 1-2 版的最前沿特性。

**真实数字**：
- **GitHub 星**：112k
- **License**：MIT
- **硬件**：基本所有 —— Apple Metal（最佳 M 系列支持，通过 NEON/Accelerate 优化）、NVIDIA CUDA、AMD HIP、Intel/AMD CPU（AVX/AVX2/AVX512）、Vulkan、SYCL，连浏览器 WebGPU、RISC-V、ARM 都行
- **量化**：GGUF 格式，1.5-bit 到 8-bit，最广的量化选项
- **杀手特性**：CPU+GPU 混合推理（比 VRAM 大的模型 GPU 和系统 RAM 分摊）、语法约束输出、`llama-server` OpenAI 兼容 API

**llama.cpp 赢的场景**：
- 怪硬件（Raspberry Pi 5 / RISC-V SBC / 浏览器 WebGPU）
- 模型比 VRAM 大（CPU+GPU 分摊）
- 要前沿量化（1.5-bit / 2-bit 实验格式）
- 要零依赖（单 C++ 二进制 ~10 MB）

**llama.cpp 输的场景**：你不享受读 C++ 编译 flag。多数用户要 Ollama / LM Studio 包装。

```bash
# 编译并跑
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp && make -j
./llama-cli -m model.gguf -p "Hello"
```

## 6. vLLM —— 生产吞吐之王

**定位**：要在真 GPU 上服务 10-1000 并发用户时，vLLM 的 **PagedAttention** + **continuous batching** + **prefix caching** 在吞吐上碾压所有替代品。"我在生产跑多租户 LLM API"的事实选择。

**真实数字**：
- **GitHub 星**：80.7k
- **License**：Apache-2.0
- **硬件**：NVIDIA（最佳）/ AMD ROCm / Apple Silicon / Intel Gaudi / Google TPU / Huawei Ascend / IBM Spyre / 甚至 ARM/RISC-V CPU
- **杀手特性**：PagedAttention（vs 朴素 serving 吞吐提升 2-24×）、continuous batching、prefix caching、speculative decoding、multi-LoRA 热插、OpenAI 兼容 API
- **量化**：FP8 / INT8 / INT4 / GPTQ / AWQ / GGUF —— 最广的生产量化支持

**vLLM 赢的场景**：生产多租户 serving。自托管商业 LLM API。任何"我要在这 4090 上每秒处理 50+ 请求"负载。Ollama 单用户模型撑不住时配我们的 [便宜 LLM Stack](/zh/collections/cheap-llm-stack/)。

**vLLM 输的场景**：单干 dev 本地 chat（Ollama 更快设置）。纯 CPU 硬件（vLLM 在 CPU 上工作但不像 llama.cpp 那样优化）。

```bash
# 快装 + serve
pip install vllm
vllm serve meta-llama/Llama-3.2-3B-Instruct --port 8000
# 用 OpenAI SDK 打 http://localhost:8000/v1
```

## 7. 硬碰硬 —— 数字对比表

| 指标 | Ollama | LM Studio | llama.cpp | vLLM |
|---|---|---|---|---|
| GitHub 星 | **137k** | N/A（闭源）| 112k | 80.7k |
| License | MIT | 闭源 freeware | MIT | Apache-2.0 |
| 安装难度 | ⭐（一条命令）| ⭐（下 app）| ⭐⭐⭐（编译）| ⭐⭐（pip 装）|
| 单用户吞吐（7B / RTX 3060）| ~20 tok/秒 | ~20 tok/秒 | ~22 tok/秒 | ~25 tok/秒 |
| **多用户吞吐（10 并发）** | ~25 tok/秒合计 | N/A（桌面）| ~30 tok/秒 | **~200 tok/秒** ⭐ |
| 硬件广度 | NVIDIA/AMD/Apple | 同 | **全部** | NVIDIA/AMD/TPU 等 |
| CPU+GPU 混合推理 | ✅（via llama.cpp）| ✅ | **✅（最佳）** | ⚠️ 受限 |
| 最佳 Apple Silicon 性能 | 好 | 好 | **最佳** | 好 |
| 生产多租户 | ⚠️ 受限 | ❌（桌面）| ⚠️ 手工 | **✅** ⭐ |
| 最适合 | 单干 dev CLI | 非程序员 GUI | 怪硬件 / 最大控制 | 生产 serving |

按行读，按主导约束挑。

## 8. 真实场景对号入座

**场景 A —— 单干 founder 用 AI 编程**：Ollama 在你笔记本。完事。通过 OpenAI 兼容 API 接 OpenCode / Continue / Cursor。看 [自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/) 拿全 stack。

**场景 B —— 50 员工公司内部 chatbot**：vLLM 跑在独立 24 GB GPU（RTX 4090 或 A5000）上，{{< aff "htstack" "vllm-vps-hk" "HTStack 香港 VPS" >}} 或 {{< aff "digitalocean" "vllm-droplet" "DigitalOcean GPU droplet" >}}。前置 [LiteLLM 网关](/zh/resources/llm-frameworks/litellm/) 做认证 + 按用户账单。

**场景 C —— 你的市场副总想跟文档 chat**：LM Studio。他拖 PDF 进 RAG 界面。零培训。把工程时间留给真需要工程的用例。

**场景 D —— 在 Raspberry Pi 5 跑 Qwen 3 14B**：llama.cpp 直跑。Ollama 可能行，但 llama.cpp 的 ARM 优化和 `--n-gpu-layers 0` 纯 CPU 给你最大榨取。

**场景 E —— 多模态 AI 内容管线**：用 Ollama 在 [多模态内容 Pipeline](/zh/collections/multi-modal-content-pipeline/) 做本地 fallback。并发生成任务超过 Ollama 串行队列时升 vLLM。

## 9. "就用 Ollama"这个默认通常对

Ollama 建在 llama.cpp 上。LM Studio 建在 llama.cpp 上。所以 80% 用户的问题不是"哪个推理引擎" —— 是"哪个 wrapper UX 我喜欢"。

- **喜欢 CLI + 模型目录**：Ollama
- **喜欢桌面 GUI + 零 CLI 暴露**：LM Studio
- **两个底下一样。两个输出相同。**

真需要做实际选择的只有：
- 硬件折腾人（llama.cpp 直跑）
- 生产 serving（vLLM）
- 其他所有人：按 UI 偏好挑 Ollama 或 LM Studio

## 10. 快速迁移路径

你可以混搭和切换。常见演化：

1. **第 1 天**：装 Ollama。跑通一个模型
2. **第 1-4 周**：用 Ollama 配编辑器 / agent。发现想要桌面 chat UI 做非编程任务。加 LM Studio
3. **第 3 月+**：在做真产品。发现 Ollama 串行排队请求。在 LiteLLM 后面加 vLLM 做生产档；Ollama 留 dev
4. **第 1 年+**：撞怪硬件（RISC-V SBC / 浏览器部署）或要前沿量化。为那个特定负载落到 llama.cpp 直跑

不必"挑一个固定不变"。同 stack 不同层愉快共存。

## TL;DR

四个本地 LLM 运行器，四个甜点：

- **Ollama**（137k 星）—— 单干 dev CLI 默认
- **LM Studio** —— 非程序员桌面 GUI
- **llama.cpp**（112k 星）—— 怪硬件 + 最大控制 + 其他底下的引擎
- **vLLM**（80.7k 星）—— 生产多租户 serving

没有全场景最佳本地 LLM 运行器。只有匹配你第 2 节决策树那一行的。挑那个、发版、并发用户数超过 10 时重新评估（那是 Ollama → vLLM 信号）。

---

*配套内容：[便宜 LLM Stack 合集](/zh/collections/cheap-llm-stack/) 把 Ollama 当默认本地运行器。[自托管 AI 编程工作流](/zh/collections/self-hosted-ai-coding-workflow/) 和 [知识库 Stack](/zh/collections/knowledge-base-stack/) 都靠 Ollama 做本地推理。[Portkey vs LiteLLM vs OpenRouter](/zh/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) 给多运行器前面的网关层。*
