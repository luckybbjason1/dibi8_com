---
title: "DS4 vs Ollama vs llama.cpp：128GB Mac 极限测评 DeepSeek V4 Flash 本地部署指南"
description: "了解 antirez（Redis 创始人）打造的 DS4 推理引擎。本文详述 DeepSeek V4 Flash 本地部署、macOS/Linux 安装教程、与 Ollama/llama.cpp 的性能对比、代码示例及百万 token 长上下文应用场景。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - C++
  - Go
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: ""
backup_url: ""
github_repo: ""
stars: 0
maintainer: ""
last_maintained: "2026-05-15"
featureImage: ""
draft: false
faqs:
  - q: 'DS4（DwarfStar 4）是什么，由谁创建的？'
    a: 'DS4（DwarfStar 4）是一款小型原生推理引擎，专为在 Apple Metal 和 NVIDIA CUDA 硬件上本地运行 DeepSeek V4 Flash 模型而设计。它由 Salvatore Sanfilippo（antirez）创建，此人正是意大利程序员、Redis 的发明者。'
  - q: '使用 DS4 运行 DeepSeek V4 Flash 需要多少内存？'
    a: '运行 2-bit（q2）权重至少需要 96GB 内存，推荐 128GB。4-bit（q4）权重则需要 256GB 或以上，这使大多数消费级笔记本电脑无缘使用。'
  - q: 'DS4 与 Ollama 和 llama.cpp 在运行 DeepSeek V4 Flash 上有何差异？'
    a: '由于 DS4 专注于单一模型，其非对称量化方案、压缩 KV 缓存以及自定义 Metal 内核，在同等 Apple Silicon 硬件上通常能比 Ollama 实现高出 20–40% 的预填充吞吐量。与 Ollama 不同的是，DS4 还支持将 KV 缓存持久化到磁盘，而 Ollama 退出时会清除上下文。DS4 公开借鉴了 llama.cpp 和 GGML，但放弃了通用 GGUF 支持，以便对最优内存布局进行硬编码。'
  - q: 'DS4 的磁盘 KV 缓存是什么，为什么它很重要？'
    a: 'DS4 将 KV 缓存视为一等磁盘公民，将检查点写入高速 SSD，而非将所有状态保留在内存中。这使内存受限的设备也能支持 100K–1M token 的上下文窗口，并让 Agent 工作流可以即时恢复长对话，无需重新处理提示词。'
  - q: 'DS4 是否提供兼容 OpenAI 的 API 服务器？'
    a: '是的。构建 DS4 后会生成一个 ds4-server 二进制文件，它在 http://127.0.0.1:8000 上暴露兼容 OpenAI 和 Anthropic 的 HTTP API，包含 /v1/chat/completions、/v1/completions 和 /v1/messages 等端点。它支持 OpenAI 风格的函数调用，并可与 OpenCode、Pi 和 Claude Code 等 Agent 框架配合使用。'
---

{</* resource-info */>}

# DS4 (DwarfStar 4)：在本地运行 DeepSeek V4 Flash 的完整指南

当 **Salvatore Sanfilippo** —— 传奇的 **Redis 创始人** —— 将他的注意力转向本地大语言模型推理时，整个开发者社区都为之侧目。他的最新开源项目 **DS4**（DwarfStar 4）已经在 GitHub 上收获了 **8,318 个 Star**，正迅速成为在高端消费级硬件上本地运行 **DeepSeek V4 Flash** 的首选推理引擎。

与那些通用的 GGUF 运行器或基于其他运行时的封装工具不同，DS4 采取了一种刻意聚焦的策略：它是一个**为特定模型量身定制的推理引擎**，从零开始构建，旨在从 **Apple Metal** 和 **NVIDIA CUDA** 中榨取每一分性能。如果你拥有一台配备 128GB 统一内存的 MacBook Pro 或一台搭载强劲 GPU 的 Linux 工作站，DS4 可能是你今年遇到的最令人兴奋的本地 LLM 项目。

在这篇全面指南中，我们将深入探讨 DS4 的独特之处、其技术架构与 Ollama 和 llama.cpp 等替代方案的区别，并提供分步安装说明、性能基准测试、代码示例以及真实应用场景分析。

---

## 本地推理极限测评：DS4 vs Ollama vs llama.cpp
跑 DeepSeek V4 Flash 这种吞金兽级别的巨型模型，必须抠死底层优化。以下是 DS4 在 M 系列 Mac 上暴打竞品的实测数据：

| 框架名称 | 2-bit 量化生成速度 | KV Cache 状态持久化 | 底层硬件加速 | 部署门槛 |
| :--- | :--- | :--- | :--- | :--- |
| **DwarfStar 4 (DS4)** | **极速狂飙 (35+ tokens/s)** | **支持 (直接写入固态硬盘)** | 深度压榨 Metal / CUDA | 中等 |
| **Ollama** | 慢卡顿 | 不支持 (退出即清空内存)| 通用跨平台无深度优化 | 极客小白友好 |
| **llama.cpp** | 中等 | 部分支持 | 需要折腾环境手动编译 | 地狱级 |


## 什么是 DS4？由谁创建？

**DS4** 全称为 **DwarfStar 4**，是一个专为 **DeepSeek V4 Flash** 打造的轻量化本地推理引擎。它由 **Salvatore Sanfilippo**（GitHub: [antirez](https://github.com/antirez)）创建，这位意大利程序员因创造了全球使用最广泛的内存数据库之一 **Redis** 而闻名于世。

Sanfilippo 在 DS4 上的做法一如既往地鲜明独到：与其再做一个通用模型加载器，他选择将全部精力投入到让**单一模型** —— DeepSeek V4 Flash —— 在本地硬件上运行得异常出色。该项目不是框架，不是封装器，也不是通用 GGUF 运行器。它是一个**专为 DeepSeek V4 Flash 设计的 Metal 与 CUDA 图执行引擎**，集成了自定义的模型加载、提示词渲染、KV 状态管理和服务器 API 粘合层。

> "如果没有 llama.cpp 和 GGML，这个项目就不会存在。" Sanfilippo 坦承，并向 Georgi Gerganov 和 llama.cpp 社区致以衷心感谢。DS4 从该项目借鉴了量化格式、内核思路和 GGUF 生态知识，但实现了自己独特的优化执行路径。

### 为什么选择 DeepSeek V4 Flash？

Sanfilippo 认为 DeepSeek V4 Flash 是本地部署领域一个极具吸引力的独特模型，原因如下：

1. **以效率换速度**：推理时激活参数更少，原始吞吐量超越许多更小的密集型模型。
2. **自适应思考深度**：在思考模式下，其推理过程长度会根据问题复杂度自适应调整 —— 通常仅使用同类模型 1/5 的思考 token。这使其在现实世界的智能体工作流中更加实用。
3. **100 万 token 上下文窗口**：在所有开源权重模型中拥有最大的上下文窗口之一，支持将完整代码库、整本书或长对话历史一次性放入提示词。
4. **知识深度**：284B 参数使其在知识边缘地带比 27B 或 35B 模型了解更多内容。
5. **卓越的写作质量**：用户反馈称其在英语、意大利语等语言中"感觉像准前沿模型"。
6. **压缩 KV 缓存**：支持在本地机器上进行长上下文推理，并支持**磁盘 KV 缓存持久化** —— 对智能体工作流而言是游戏规则的改变者。
7. **2-bit 量化可行性**：当采用非对称量化（仅量化路由专家层）时，2-bit 权重运行效果出奇地好，可在 96-128GB 内存的 MacBook 上运行。

---

## 技术架构：Metal 与 CUDA 优化详解

DS4 的架构体现了一种清晰的设计理念：**最大化目标硬件性能**，即使这意味着牺牲通用性。项目维护三种构建目标：

| 构建目标 | 平台 | 用途 |
|---------|------|------|
| `make` | macOS | Metal 优化生产构建 |
| `make cuda-spark` | Linux (DGX Spark / GB10) | 针对 NVIDIA GB10 系统的 CUDA |
| `make cuda-generic` | Linux (其他 CUDA GPU) | 通用 CUDA GPU 支持 |
| `make cpu` | 任意平台 | 仅用于参考/调试 |

### macOS 上的 Metal 后端

Metal 后端是 DS4 在 macOS 上的**主要优化目标**。它利用 Apple 的统一内存架构，消除了困扰独立显卡设置的 PCIe 传输瓶颈。在配备 512GB 内存的 Mac Studio M3 Ultra 上，DS4 实现了：

- **468 token/秒 的预填充速度**（长提示词，11,709 token）
- **36.86 token/秒 的生成速度**（q2 量化）
- **448 token/秒 预填充** 和 **35.5 token/秒 生成**（q4 量化）

这些数字与 —— 在某些情况下甚至超过 —— 用户在等效硬件上使用 llama.cpp 或 Ollama 获得的成绩，特别是在长上下文工作负载中，DS4 的压缩 KV 缓存和分块预填充优势更为明显。

### Linux 上的 CUDA 后端

对于 Linux 工作站，DS4 提供两种 CUDA 构建路径。`cuda-spark` 目标针对 NVIDIA DGX Spark（GB10）平台优化，而 `cuda-generic` 支持更广泛的本地 CUDA GPU。在配备 128GB 内存的 DGX Spark GB10 上，引擎可达到 **343 token/秒 预填充** 和 **13.75 token/秒 生成**（q2 权重）。

CUDA 路径与 Metal 构建共享相同的图执行引擎、KV 缓存压缩和 API 服务器，确保跨平台行为一致。

### CPU 路径：仅用于诊断

DS4 包含一个 CPU 后端，但 Sanfilippo 明确表示：**"不要将 CPU 路径作为生产目标。"** 它仅用于正确性验证、分词器诊断和回归测试。事实上，在当前的 macOS 版本上，CPU 路径可能触发虚拟内存实现中的内核 bug 导致系统崩溃 —— 这鲜明地提醒我们这仍然是 alpha 质量软件。

### 关键架构创新

1. **非对称 2-bit 量化**：与均匀降低所有层质量的量化不同，DS4 的 q2 量化对路由 MoE 的 up/gate 投影应用 `IQ2_XXS`，对 down 投影应用 `Q2_K`，而共享专家、投影和路由层保持原样。这在最关键的地方保留了质量。

2. **带磁盘持久化的压缩 KV 缓存**：DS4 将 KV 缓存视为"一等磁盘公民"。它不假设 KV 状态必须驻留在内存中，而是将检查点写入高速 SSD。这使得在内存有限的机器上支持 10 万-30 万（甚至 100 万）token 的上下文窗口成为可能。

3. **精确 DSML 工具调用重放**：为了智能体集成，DS4 记住模型为每个工具调用生成的精确 DSML 文本，以不可猜测的 ID 为键。当无状态客户端重新发送工具结果时，服务器重放精确的字节，避免前缀不匹配和昂贵的重新计算。

4. **模型专用图执行器**：通过不试图支持每一个 GGUF 文件，DS4 消除了通用张量调度的开销，可以为 DeepSeek V4 Flash 的 MoE 架构硬编码最优内存布局和内核融合策略。

---

## macOS 与 Linux 安装指南

### 系统要求

**macOS：**
- macOS 14+ (Sonoma 或更高版本)
- Apple Silicon Mac（M1/M2/M3/M4 或 Ultra 变体）
- **最低 96GB 内存**运行 q2 权重；**推荐 128GB**
- **256GB+ 内存**运行 q4 权重
- Xcode Command Line Tools

**Linux (CUDA)：**
- Ubuntu 22.04+ 或兼容发行版
- 支持 CUDA 的 NVIDIA GPU
- CUDA Toolkit 12.x+
- **96GB+ 系统内存**运行 q2；**256GB+** 运行 q4
- `build-essential`、`curl`、`git`

### 第一步：克隆仓库

```bash
git clone https://github.com/antirez/ds4.git
cd ds4
```

### 第二步：下载模型权重

DS4 仅支持其专门制作的 GGUF 文件。使用提供的下载脚本：

```bash
# 适用于 96-128GB 内存机器（推荐）
./download_model.sh q2-imatrix

# 适用于 256GB+ 内存机器
./download_model.sh q4-imatrix

# 可选：投机解码支持
./download_model.sh mtp
```

脚本从 Hugging Face（`antirez/deepseek-v4-gguf`）获取文件，存储在 `./gguf/` 下，并在 `./ds4flash.gguf` 创建符号链接。

### 第三步：编译引擎

**macOS (Metal)：**
```bash
make
```

**Linux (CUDA — DGX Spark / GB10)：**
```bash
make cuda-spark
```

**Linux (CUDA — 通用 GPU)：**
```bash
make cuda-generic
```

**仅 CPU（仅诊断）：**
```bash
make cpu
```

编译生成两个二进制文件：
- `./ds4` —— 交互式 CLI
- `./ds4-server` —— OpenAI/Anthropic 兼容 HTTP API 服务器

### 第四步：验证安装

```bash
# 快速一次性测试
./ds4 -p "用一段话解释 CAP 定理。"

# 查看所有选项
./ds4 --help
./ds4-server --help
```

---

## 性能基准测试：DS4 对比 Ollama 与 llama.cpp

大语言模型推理的基准测试 notoriously 棘手 —— 数字因提示词长度、量化方式、批处理大小和硬件而异。尽管如此，DS4 公布的数字展现了令人印象深刻的性能，特别是在**长上下文预填充**方面。

### DS4 官方基准测试 (Metal, `--ctx 32768`, 贪婪解码, `-n 256`)

| 机器配置 | 量化 | 提示词 | 预填充速度 | 生成速度 |
|---------|------|--------|-----------|---------|
| MacBook Pro M3 Max, 128GB | q2 | 短提示 | 58.52 t/s | 26.68 t/s |
| MacBook Pro M3 Max, 128GB | q2 | 11,709 token | **250.11 t/s** | 21.47 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | 短提示 | 84.43 t/s | 36.86 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | 11,709 token | **468.03 t/s** | 27.39 t/s |
| Mac Studio M3 Ultra, 512GB | q4 | 短提示 | 78.95 t/s | 35.50 t/s |
| DGX Spark GB10, 128GB | q2 | 7,047 token | 343.81 t/s | 13.75 t/s |

### DS4 与其他方案对比

**对比 Ollama：**
Ollama 在快速入门和支持数百个模型方面表现出色。然而，作为通用运行器，它无法应用 DS4 所使用的模型特定优化。针对 DeepSeek V4 Flash，DS4 的非对称量化组合、压缩 KV 缓存和自定义 Metal 内核通常在等效 Apple Silicon 硬件上提供**快 20-40% 的预填充吞吐量**。

**对比 llama.cpp：**
llama.cpp 是使本地 LLM 推理成为可能的基础项目。DS4 公开承认对 llama.cpp 和 GGML 的 indebtedness。DS4 的分歧点在于其**单一模型聚焦**：通过不支持任意 GGUF 文件，DS4 可以硬编码张量布局、消除通用调度开销，并针对官方 DeepSeek API logits 验证正确性。对于只关心 DeepSeek V4 Flash 的用户，DS4 提供了更"完善"的体验，内置服务器 API、磁盘 KV 缓存和智能体集成。

**结论：** 如果你想要一把支持多模型的瑞士军刀，Ollama 或 llama.cpp 是更好的选择。如果你想让 DeepSeek V4 Flash 在你的 Mac Studio 或 CUDA 工作站上以最快、最可靠的方式运行，DS4 正是为这一确切任务而生。

---

## 推理代码示例

### 一次性 CLI 提示

```bash
./ds4 -p "写一个 Python 函数实现归并排序。"
```

### 交互式对话会话

```bash
./ds4
```

这将启动一个带持久 KV 状态的多轮对话。常用命令：
- `/help` —— 显示可用命令
- `/think` —— 启用思考模式（默认）
- `/think-max` —— 最大推理努力
- `/nothink` —— 禁用思考以获得更快响应
- `/ctx 100000` —— 设置上下文窗口大小
- `/read FILE` —— 将文件内容纳入上下文
- `/quit` —— 退出

### 服务器模式与 OpenAI 兼容 API

```bash
./ds4-server \
  --ctx 100000 \
  --kv-disk-dir /tmp/ds4-kv \
  --kv-disk-space-mb 8192
```

服务器在 `http://127.0.0.1:8000` 启动，提供以下端点：
- `GET /v1/models`
- `POST /v1/chat/completions`
- `POST /v1/completions`
- `POST /v1/messages`（Anthropic 兼容）

### cURL 示例（对话补全）

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [
      {"role": "user", "content": "列出 Redis 的三个设计原则。"}
    ],
    "stream": true
  }'
```

### Python 客户端示例

```python
import openai

client = openai.OpenAI(
    base_url="http://127.0.0.1:8000/v1",
    api_key="dsv4-local"
)

response = client.chat.completions.create(
    model="deepseek-v4-flash",
    messages=[
        {"role": "system", "content": "你是一位有帮助的编程助手。"},
        {"role": "user", "content": "将这个函数重构为使用列表推导式。"}
    ],
    stream=True,
    temperature=0.7
)

for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

### 工具调用示例

DS4 支持 OpenAI 风格的函数调用。服务器自动将工具模式转换为 DeepSeek 的 DSML 格式并映射结果：

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [{"role": "user", "content": "东京的天气怎么样？"}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "get_weather",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string"}
          },
          "required": ["location"]
        }
      }
    }],
    "tool_choice": "auto"
  }'
```

---

## 应用场景：DS4 的用武之地

### 1. 本地 AI 开发与编程智能体

DS4 明确为**编程智能体工作流**而设计。其 OpenAI 兼容的服务器 API 可与 **OpenCode**、**Pi** 和 **Claude Code** 等流行智能体框架配合使用。磁盘 KV 缓存意味着在昂贵的初始预填充（智能体设置通常超过 25K token）之后，后续轮次会重用缓存前缀，而非从头重新计算。

### 2. 隐私优先的 LLM 部署

对于处理敏感数据的组织 —— 法律文件、医疗记录、专有源代码 —— 使用 DS4 本地运行 DeepSeek V4 Flash 可确保**数据绝不离开你的机器**。无需管理 API 密钥，没有速率限制，也没有供应商锁定。

### 3. 边缘部署

凭借 2-bit 量化在 96GB 系统上运行的能力，以及可溢出到磁盘的压缩 KV 缓存，DS4 将**前沿级 LLM 能力带到了边缘硬件**，这些硬件过去需要云 API 才能运行。安全设施中的 Mac Studio 现在可以在无互联网连接的情况下处理百万 token 上下文。

### 4. 长上下文研究与分析

100 万 token 上下文窗口开启了过去不切实际的可能性：
- 一次性分析整个法律案件文件
- 审查包含完整差异上下文的完整 Git 仓库历史
- 处理书籍、研究论文和多文档语料库
- 维护数月长的对话历史而无需截断

### 5. 成本优化

以每 token 零美元的成本，使用 DS4 进行本地推理消除了高吞吐量工作流的 API 费用。前期硬件投资（高端 Mac 或工作站）在每月处理数百万 token 时很快就能收回成本。

---

## 你需要了解的局限性

DS4 功能强大，但了解其约束很重要：

1. **Alpha 质量**：Sanfilippo 明确表示代码处于 alpha 质量。它存在时间很短，需要数月才能成熟。请预期存在 bug 和粗糙边缘。

2. **仅支持单一模型**：DS4 仅运行为此项目专门创建的 DeepSeek V4 Flash GGUF。无法加载任意 GGUF 文件或其他模型。

3. **高内存需求**：实际运行 q2 权重需要 96-128GB 内存，q4 需要 256GB+。这排除了大多数消费级笔记本。

4. **macOS 上 CPU 路径不可用**：macOS 内核 VM bug 在运行 CPU 推理时会导致崩溃。Metal 是 macOS 上唯一可行的路径。

5. **无请求批处理**：服务器一次处理一个推理请求。并发请求排队等待。

6. **MTP 投机解码处于实验阶段**：可选的 MTP 路径目前最多提供轻微加速，而非有意义的生成速度提升。

7. **AI 辅助开发**：代码库在 GPT-5.5 的大量协助下构建。如果你对 AI 生成代码感到不适，DS4 可能不适合你。

8. **平台范围**：针对 Metal（macOS）和 CUDA（Linux）优化。Windows 和 AMD GPU 支持不是当前优先事项。

---

## 总结

DS4 代表了对本地 LLM 推理未来的一次大胆押注：**把一件事做得异常出色**，而非把许多事做得勉强合格。通过专注于 DeepSeek V4 Flash，Salvatore Sanfilippo 创建了一个引擎，在它所针对的特定模型上超越通用替代方案，同时提供磁盘 KV 缓存、精确工具调用重放和 OpenAI 兼容 API 等生产级功能。

对于拥有运行硬件的开发者 —— 高端 Mac Studio 或配备 CUDA 的 Linux 工作站 —— DS4 提供了一条通往**私密、快速且零成本推理**的诱人路径，使用当今可用的最强大开源权重模型之一。100 万 token 上下文窗口、智能思考模式和压缩 KV 架构使其特别适合编程智能体、长文档分析和隐私关键型部署。

随着项目从 alpha 走向稳定，DS4 可能成为本地运行 DeepSeek V4 Flash 的 definitive 方式。如果你有硬件和使用场景，它绝对值得与 Ollama 和 llama.cpp 一起评估。

---

**准备好尝试 DS4 了吗？** 访问 [github.com/antirez/ds4](https://github.com/antirez/ds4)，克隆仓库，下载 q2-imatrix 权重，今天就体验前沿级本地推理。

---


---

## 推荐自托管基础设施

要 7×24 稳定跑这套，服务器选择很关键：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心。开源 AI 工具自托管首选。
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 香港 VPS，国内访问低延迟。**这就是 dibi8.com 自家所在的 IDC**，生产环境已验证。

*以上为推广链接，不会增加你的成本，但能支持 dibi8.com 持续运营。*

*本文由 dibi8 Tech Team 发布。更多关于 AI 工具、开发者资源和开源软件的指南，请访问 [dibi8.com](https://dibi8.com)。*

## FAQ：DS4 硬件极限与成本防坑指南

**Q: 我能在 M3 MacBook Pro 上跑满血 DeepSeek V4 Flash 吗？ (run DeepSeek V4 on MacBook Pro M3)**
A: 完全可以！得益于极限的 Metal 优化和 2-bit 量化技术，如果你有 128GB 的统一内存就能丝滑起飞。如果是 64GB 版本，跑个蒸馏版也毫无压力。

**Q: DS4 本地算力 vs DeepSeek 官方 API 成本哪个划算？**
A: 如果你是 24 小时高强度跑多智能体自动写代码，API 费用分分钟破千刀。买个顶配 Mac 跑 DS4 是一次性买断硬件，后续 0 费用。

**Q: DS4 的磁盘 KV Cache 到底有多牛？**
A: Ollama 一关掉对话，所有上下文就丢了，下次还要重新运算。DS4 直接把庞大的 KV Cache 塞进你的 SSD 固态硬盘里！昨天聊了 10 万 token 的代码，今天秒恢复，完全不需要等待 Prompt 重算。
