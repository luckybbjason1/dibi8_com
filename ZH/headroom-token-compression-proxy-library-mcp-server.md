---
title: 'Headroom: 压缩 LLM 输入 60-95% — 省 Token 代理、库与 MCP 服务器 — 2026 实用指南'
description: 'Headroom (19,745 GitHub stars) 压缩工具输出、日志、文件、RAG 块后再送入 LLM。节省 60-95% token，答案不变。含 Python 库、代理、MCP 服务器。附设置教程、架构解析和真实基准数据。'
date: 2026-06-08
slug: 'headroom-token-compression-proxy-library-mcp-server'
category: 'llm-frameworks'
tags: ['Token 压缩', 'LLM 节省 Token', 'MCP 服务器', 'RAG 压缩', 'Headroom', '上下文优化', 'Token 成本降低', 'AI 代理']
github_repo: 'https://github.com/chopratejas/headroom'
stars: 19745
maintainer: 'chopratejas'
license: MIT
featureImage: 'https://raw.githubusercontent.com/chopratejas/headroom/main/headroom-savings.png'
lang: zh
---

# Headroom: 压缩 LLM 输入 60-95% — 省 Token 代理、库与 MCP 服务器 — 2026 实用指南

```
┌──────────────────────────────────────────────────────┐
│              Headroom 压缩流水线                       │
│                                                      │
│  ┌────────────┐  ┌─────────────┐  ┌──────────────┐  │
│  │  工具输出   │  │  日志文件   │  │  RAG 文本块   │  │
│  │  (JSON)    │  │  (.log)     │  │  (嵌入向量)   │  │
│  └─────┬──────┘  └──────┬──────┘  └──────┬───────┘  │
│        │                │                 │          │
│        ▼                ▼                 ▼          │
│  ┌───────────────────────────────────────────────┐   │
│  │          Headroom 压缩引擎                      │   │
│  │  • 去重     • 摘要     • 格式优化              │   │
│  └──────────────────────────┬────────────────────┘   │
│                             │ 减少 60-95% token       │
│  ┌──────────────────────────▼────────────────────┐   │
│  │              LLM API 调用                       │   │
│  │  (Claude Code / Codex / Copilot / Gemini CLI)   │   │
│  └───────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────┘
```

## Introduction

2026 年你还在为 LLM API 调用买单的话，很可能 40-70% 的 token 预算花在了冗余上下文上：重复的工具输出、冗长的日志文件、以及 LLM 读了却用不上的臃肿 RAG 块。Headroom (19,745 GitHub stars) 是那个站在你的 AI 代理和 LLM 之间的开源工具——在输入到达模型之前，把它们压缩 60-95%。它同时提供 Python 库、CLI 代理和 MCP 服务器三种形态——兼容 Claude Code、Codex CLI、Copilot、Gemini CLI 和所有 OpenAI 兼容 API。单依赖，10 行代码集成，真实基准测试显示答案质量几乎不变，但成本骤降。

## What Is Headroom?

Headroom 是一个**面向 LLM 流水线的 token 压缩层**，在输入到达模型之前减少 token 数量。它不是摘要工具——它是结构优化器。它能区分工具输出、日志、文件、检索增强文本块中的"重要信号"和"噪声上下文"。

核心能力：
- **输入压缩** — 在 LLM 消费前去重、修剪、摘要工具输出
- **多格式支持** — 处理 JSON、日志、markdown、代码文件和 RAG 嵌入
- **3 种部署模式** — Python 库、CLI 代理、MCP 服务器
- **模型无关** — 兼容 Claude、GPT-4o、Gemini 和任何 OpenAI 兼容端点
- **质量保持** — 基准测试显示在 60-95% token 缩减下产生等价答案
- **零配置启动** — 自带合理默认值，之后可自定义规则

项目基于 Python 构建，仅依赖 `tiktoken`（用于 token 计数），通过标准 HTTP API 集成。压缩状态存储在内存或 Redis 中以支持多会话场景。

## How Headroom Works

Headroom 通过三个阶段运作：

### 第一阶段：输入摄入

```bash
# 安装库
pip install headroom-compress

# 一行代码压缩
python -c "
import headroom
result = headroom.compress('''
[工具调用返回的长 JSON 输出... 5000 tokens]
''')
print(f'原始: {result.original_tokens} tokens')
print(f'压缩后: {result.compressed_tokens} tokens')
print(f'节省: {result.savings_pct}%')
# 输出: 原始: 5000 → 压缩后: 950 → 节省: 81%
"
```

### 第二阶段：压缩引擎

```python
# 自定义压缩规则
from headroom import Compressor

compressor = Compressor(
    strategy="balanced",  # "aggressive" | "balanced" | "conservative"
    max_reduction_pct=95,
    min_quality_score=0.85,
    dedup_threshold=0.9,
    summary_length_ratio=0.3,
)

# 应用于混合输入
compressed = compressor.compress([
    {"type": "tool_output", "data": tool_result_json},
    {"type": "log_file", "data": log_content},
    {"type": "rag_chunk", "data": embedded_text},
    {"type": "code_file", "data": source_code},
])
```

### 第三阶段：LLM 集成

```bash
# 启动代理服务器
headroom serve --port 8787 --compressor balanced

# 让 AI 代理指向代理而非直接连接 LLM
# 代理 → Headroom 代理 (8787) → 压缩 → LLM API
```

## Installation & Setup

### 快速开始（库模式）

```bash
pip install headroom-compress
python -c "import headroom; compressed = headroom.compress(your_input); print(compressed.text)"
```

### 代理模式（推荐用于 AI 代理）

```bash
pip install headroom-compress
headroom serve --host 0.0.0.0 --port 8787

# 测试压缩
curl -X POST http://localhost:8787/compress \
  -H "Content-Type: application/json" \
  -d '{"input": "非常长的上下文..."}' | jq

# 预期响应:
# {
#   "original_tokens": 4523,
#   "compressed_tokens": 891,
#   "savings_pct": 80.3,
#   "compressed_text": "..."
# }
```

### MCP 服务器模式

```bash
# 启动为 MCP 服务器
headroom mcp-serve --port 9090

# 从 Claude Code 连接
claude-code --mcp http://localhost:9090
# MCP 服务器暴露:
# - headroom/compress — 压缩文本输入
# - headroom/benchmark — 运行压缩基准测试
# - headroom/config — 获取/更新压缩设置
```

### Docker 部署

```bash
docker run -d --name headroom-proxy -p 8787:8787 \
  -e LLM_ENDPOINT=https://api.anthropic.com/v1/messages \
  -e LLM_API_KEY=${ANTH...KEY} \
  chopratejas/headroom:latest

# 监控压缩统计
curl http://localhost:8787/stats | jq
```

## Integration with Claude Code, Codex CLI, Copilot, and Gemini CLI

Headroom 兼容任何通过 HTTP 请求 LLM API 的代理：

### Claude Code

```bash
# 方法 1: 使用 MCP 服务器
headroom mcp-serve --port 9090
# 然后在 Claude Code: add-mcp headroom http://localhost:9090

# 方法 2: 设置 API 代理
export CLAUDE_API_BASE_URL=http://localhost:8787/v1
```

### Codex CLI

```bash
export OPENAI_API_BASE=http://localhost:8787/v1
codex --model gpt-4o --prompt "修复认证 bug"
# 所有上下文先经过 Headroom 压缩
```

### OpenRouter 聚合

```bash
headroom serve --proxy http://api.openrouter.ai/api/v1 \
  --model meta-llama/llama-3.1-405b --compressor balanced
# Headroom 压缩输入，然后发送到 OpenRouter
# 你为压缩后的 token 付费，而非原始 token
```

自托管：[DigitalOcean](https://m.do.co/c/eca87ac14ee0) 稳定低延迟连接，[HTStack](https://my.htstack.com/aff.php?aff=27187) 多区域部署，[WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 数据中心代理。

## Benchmarks / Real-World Use Cases

### 压缩基准测试

在 100 个真实工具输出（终端输出、git diff、文件内容、RAG 块混合）上测试：

| 配置 | 平均原始 Token | 平均压缩 Token | 节省 | 答案质量 |
|------|-------------|-------------|------|---------|
| 无压缩 | 4,820 | 4,820 | 0% | 100% |
| 保守 (90% 上限) | 4,820 | 1,450 | 70% | 98% |
| 均衡 (75% 上限) | 4,820 | 1,080 | 78% | 96% |
| 激进 (95% 上限) | 4,820 | 610 | 87% | 89% |

### 成本降低：真实场景

一位开发者用 Claude Code 处理 50K 行 Python 项目：

```bash
# 使用前:
# 每日上下文: ~120,000 tokens/天
# 成本: ~$48/月 (Claude Sonnet @ $3/M)

# 使用后 (均衡模式):
# 每日上下文: ~28,000 tokens/天
# 成本: ~$11/月
# 节省: ~$37/月 = 77% 降低
```

### RAG 文本块压缩

```python
from headroom import rag_compress

compressed_chunks = rag_compress(
    retrieved_documents,
    min_relevance_score=0.7,
    max_chunks=10,
    strategy="balanced"
)
# 结果: 47 原始块 → 12 压缩块
# 同等答案质量，74% 更少 token
```

## Advanced Usage / Production Hardening

### 自定义压缩规则

```yaml
# headroom-config.yaml
rules:
  - pattern: "\\.py$"
    min_compress_ratio: 0.5
  - pattern: "test_.*\\.py$"
    compress: false
  - pattern: "ci-logs/"
    max_tokens: 500
    strategy: aggressive
  - pattern: "openapi.*\\.yaml$"
    compress: false
    dedup: true
```

### Redis 会话状态

```bash
headroom serve --redis-url redis://localhost:6379/0 --session-ttl 3600
# 会话状态跨请求持久化
# 适用于长运行代理会话
```

### 健康检查与监控

```bash
curl -s http://localhost:8787/health | jq
curl -s http://localhost:8787/stats | jq
# {
#   "total_requests": 1247,
#   "total_tokens_saved": 892341,
#   "avg_savings_pct": 76.4,
#   "error_rate": 0.02
# }
```

## Comparison with Alternatives

| 功能 | Headroom | 仅 Tiktoken | RAG 压缩库 | 令牌优化框架 |
|------|----------|-----------|-----------|------------|
| Token 节省 | 60-95% | 0% (仅计数) | 30-60% | 50-80% |
| 多格式 (JSON, 日志, 文件) | 是 | 否 | 有限 | 否 |
| 部署模式 | 库 + 代理 + MCP | 仅库 | 仅库 | 仅库 |
| 零配置默认 | 是 | 否 | 否 | 否 |
| MCP 服务器支持 | 是 | 否 | 否 | 否 |
| 模型无关 | 是 | 是 | 否 | 否 |
| 质量基准测试 | 内置 | 否 | 否 | 否 |
| Docker 支持 | 是 | 否 | 否 | 否 |
| 活跃开发 | 非常活跃 | N/A | 混合 | 不等 |
| GitHub stars | 19,745 | — | 不等 | 不等 |

## Limitations / Honest Assessment

**Headroom 不是银弹。以下场景不适合：**

1. **延迟敏感应用** — 压缩增加 10-50ms/请求。对于超低延迟需求（总延迟<100ms），开销可能不可接受。
2. **极短输入** — 输入<500 token 时，压缩开销超过节省。Headroom 针对长上下文场景（2,000+ token）优化。
3. **质量关键型窄任务** — 如果 1% 质量下降不可接受（如法律文档审查），使用保守模式 70% 最大节省而非均衡模式。
4. **非文本输入** — Headroom 仅压缩文本。二进制数据、图像、音频需要单独预处理。
5. **部署成本** — 运行代理服务器增加基础设施复杂度。单开发者低 token 使用场景，库模式即可。

## Frequently Asked Questions

**Q: Headroom 和简单 LLM 摘要器有什么区别？**

A: Headroom 使用结构分析（token 边界、格式感知去重、相关性评分）而非生成式摘要。它保留关键信息结构（代码语法、JSON 模式、API 签名），摘要器可能损坏这些内容。

**Q: Headroom 能用于 Ollama 等本地模型吗？**

A: 可以。将代理指向任何 Ollama 端点：`LLM_ENDPOINT=http://localhost:11434/v1`。压缩在请求到达 Ollama 前发生，减少 VRAM 使用。

**Q: 能在 VPS 上为团队运行吗？**

A: 可以。Docker 部署很简单。1 vCPU 1GB RAM 的基础 VPS 可处理 50+ 并发压缩请求。更多则加 Redis 后端。

**Q: 有 API 密钥或使用限制吗？**

A: 没有。Headroom 开源 (MIT 许可)，完全免费，无使用限制。唯一成本是通过代理产生的 LLM API 调用费用。

**Q: Headroom 如何处理 RAG 检索？**

A: Headroom 包含 `rag_compress` 函数，在发送给 LLM 前对检索文本块进行评分、去重和修剪。使用嵌入相似度保留高相关文本块。

## Sources & Further Reading

- 官方文档: https://github.com/chopratejas/headroom
- GitHub 仓库: https://github.com/chopratejas/headroom
- 压缩基准测试方法: https://github.com/chopratejas/headroom/blob/main/docs/BENCHMARKS.md
- MCP 服务器文档: https://github.com/chopratejas/headroom/blob/main/docs/MCP.md
- 社区讨论: https://github.com/chopratejas/headroom/discussions

## Conclusion: 削减 60-95% LLM Token 成本 — 10 分钟运行

Headroom 是每个 AI 代理流水线都需要的缺失基础设施层。与其为臃肿上下文付费，不如在到达模型前压缩它。库提供程序控制，代理提供零代码集成，MCP 服务器提供无缝 Claude Code 兼容。

无论你是想降低 Claude API 账单的单个开发者、运行 AI CI/CD 的团队、还是构建生产 RAG 系统的工程师，Headroom 都能在不牺牲答案质量的前提下提供可量化的成本节省。

加入 [dibi8 中文 Telegram 群](https://t.me/DIBI8_Group/4) 讨论 Headroom 配置。查看我们的 [agentmemory 持久记忆](dibi8-internal-link) 和 [codegraph 知识图谱](dibi8-internal-link) 指南获取互补工具。今天试试 Headroom — 安装它，设置代理，看着你的 token 账单下降。

上方部分链接含联盟推广。如通过链接注册，dibi8.com 可能获得佣金，不影响你的成本。这帮助 dibi8 持续免费运营。
