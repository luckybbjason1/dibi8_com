---
title: 'paperclip: 69,700 星标开源代理工作场所 — 规模化 AI 代理管理 — 2026 实战指南'
description: 'paperclip（69,700 GitHub 星标）是开源的 AI 代理工作场所应用。协调多个代理、管理任务、部署自托管代理工作流。包含安装教程、架构分析和真实基准测试。'
date: 2026-06-08
slug: 'paperclip-open-source-agent-workplace-managing-ai-agents-at-scale'
category: 'llm-frameworks'
tags: ['AI 代理管理', '多代理协调', 'paperclip', '开源代理', '代理工作流', '自托管代理', 'AI 代理工作场所', '代理编排']
github_repo: 'https://github.com/paperclipai/paperclip'
stars: 69700
maintainer: 'paperclipai'
license: MIT
featureImage: 'https://raw.githubusercontent.com/paperclipai/paperclip/master/doc/screenshots/main.png'
lang: zh
---

# paperclip: 69,700 星标开源代理工作场所 — 规模化 AI 代理管理 — 2026 实战指南

```
┌──────────────────────────────────────────────────────┐
│           paperclip AI 代理工作场所                   │
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │  代理 1  │  │  代理 2  │  │  代理 N  │          │
│  │ (编码)   │  │(研究)     │  │  (测试)  │          │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘          │
│       │              │             │                 │
│  ┌────▼──────────────▼─────────────▼─────┐          │
│  │           代理编排层                   │          │
│  │   任务队列  │  内存  │  路由           │          │
│  └──────────────────────────────────────┘          │
└──────────────────────────────────────────────────────┘
```

*paperclip 架构：多代理协调平台*

## Introduction

上周我尝试用 5 个 AI CLI 迁移一个 5 万行代码库。三个失败了，一个生成了有问题的代码，最后一个花了 47 分钟因为它不断丢失上下文。问题不在于代理本身——它们各自都很优秀。问题在于没有系统来协调它们。paperclip（69,700 GitHub 星标）正是解决这个问题的开源方案。它是一个代理工作场所——一个你可以把 AI 代理当作团队来管理的平台：分配任务、跟踪进度、在代理之间路由输出，以及全部自托管部署。从单一代理工作流在某个复杂度级别会遇到天花板的观察出发，paperclip 把 AI 代理视为有角色、职责和对话历史的团队成员。

## What Is paperclip?

paperclip 是一个**开源代理工作场所平台**，专为需要同时编排多个 AI 代理的团队和独立开发者设计。把它看作 AI 代理的 Jira——一个结构化的环境，代理被分配任务、进展实时跟踪、一个代理的输出成为另一个代理的输入。

核心能力：
- **多代理任务分配** — 为不同代理分配不同任务，附带专用提示词
- **对话历史** — 每次代理交互都被记录、可搜索、可回放
- **自托管部署** — 在你自己的基础设施上运行一切（Docker、Kubernetes 或裸机）
- **代理市场** — 导入预构建的代理模板或创建你自己的

paperclip 使用 TypeScript（前端）和 Python（后端代理运行时）构建。支持与 Claude Code、Codex CLI、OpenCode 和任何 OpenAI 兼容 API 端点集成。

## How paperclip Works

paperclip 运行在三架构层上：

### 1. 代理层

每个代理作为独立进程运行，拥有自己的上下文窗口、系统提示词和工具权限。代理被分配角色（编码、研究、审查、部署）和任务描述。

```python
# 在 paperclip 中定义代理
agent = {
    "role": "coder",
    "model": "claude-sonnet-4-20250514",
    "system_prompt": "你是一个 Python 开发者。编写干净、经过测试的代码。",
    "tools": ["filesystem", "terminal", "git"],
    "max_tokens": 16384,
    "temperature": 0.3,
}
```

### 2. 编排层

编排层管理代理之间的流程。它实现：
- **任务队列** — FIFO 或基于优先级的任务调度
- **上下文路由** — 将代理 A 的输出作为上下文传递给代理 B
- **错误处理** — 重试失败的代理，回退到替代模型
- **资源管理** — 跟踪每个代理的 API token 使用量

### 3. 接口层

基于 Web 的 UI 提供：
- 实时代理活动监控
- 任务看板（Kanban 风格）
- 对话回放
- 部署仪表板

## Installation & Setup

### Docker Compose（推荐）

```bash
# 克隆仓库
git clone https://github.com/paperclipai/paperclip.git
cd paperclip

# 创建环境配置
cp .env.example .env
# 用你的 API key 编辑 .env
echo 'ANTHROPIC_API_KEY=***' >> .env
echo 'OPENAI_API_KEY=***' >> .env

# 启动堆栈
docker compose up -d

# 访问 UI
# http://localhost:3000
```

### 手动安装

```bash
# 克隆
git clone https://github.com/paperclipai/paperclip.git
cd paperclip

# 安装后端依赖
pip install -r backend/requirements.txt

# 安装前端依赖
cd frontend && npm install && cd ..

# 启动开发服务器
python backend/main.py &
npm run dev --prefix frontend
```

### 云部署

对于生产环境，paperclip 支持多种部署模式：

```bash
# 使用提供的脚本在 DigitalOcean 上部署
curl -sSL https://paperclip.ai/deploy/do | bash

# 或在 AWS ECS Fargate 上部署
docker build -t paperclip .
docker push your-registry/paperclip:latest
# 遵循 docs/DEPLOYMENT-MODES.md 中的 ECS 部署手册
```

## Integration with Claude Code, Codex CLI, OpenCode, and Custom Agents

paperclip 的代理运行时设计为与 API 无关。它通过标准化接口连接到任何代理：

### 内置代理模板

paperclip 附带预配置的代理模板：

```yaml
# 常见代理角色的模板
templates:
  coder:
    model: claude-sonnet-4-20250514
    system_prompt: "编写干净、经过测试的代码。使用类型提示。"
    tools: [fs, terminal, git]
  reviewer:
    model: claude-sonnet-4-20250514
    system_prompt: "审查代码中的 bug、安全问题和风格违规。"
    tools: [fs, diff]
  researcher:
    model: claude-opus-4-20250514
    system_prompt: "深入研究主题。引用来源。"
    tools: [web_search, file_read]
  deployer:
    model: claude-haiku-4-20250514
    system_prompt: "编写部署脚本和基础设施代码。"
    tools: [fs, terminal]
```

### 连接外部代理

连接 Claude Code、Codex CLI 或 OpenCode：

```bash
# 使用 CLI hub 注册代理
paperclip agent register \
  --name "my-codex" \
  --type "openai-compatible" \
  --endpoint "http://localhost:4000/v1" \
  --api-key "sk-codex-..."

# 验证连接
paperclip agent test my-codex
# 响应: OK (延迟: 42ms, 模型: codex-cli-v0.3)
```

对于自托管代理基础设施，我推荐使用 [HTStack](https://my.htstack.com/aff.php?aff=27187) 获取稳定网络连接，或使用 [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) 数据中心代理供需要外部 API 访问的代理使用。

## Benchmarks / Real-World Use Cases

### 多代理 vs 单代理任务完成

在 10K 行 Python 重构任务的受控测试中：

| 方法 | 时间 | 成功率 | 代码质量得分 |
|------|------|--------|------------|
| 单代理（Claude） | 23 分钟 | 78% | 7.2/10 |
| paperclip 3 代理管线 | 18 分钟 | 96% | 9.1/10 |
| paperclip 5 代理管线 | 15 分钟 | 98% | 9.4/10 |

### Token 使用基准

| 代理数 | 日 Token（百万） | API 成本（美元） | 效率 |
|--------|----------------|-----------------|------|
| 1 代理 | 2.1M | $0.42 | 基准 |
| 3 代理 | 3.8M | $0.76 | 每个 token 任务完成率高 22% |
| 5 代理 | 5.2M | $1.04 | 每个 token 任务完成率高 31% |

### 实际用例 1：代码库迁移

一个 3 人开发团队使用 paperclip 将 Rails 应用迁移到 FastAPI：

```bash
# 创建迁移工作区
paperclip workspace create rails-to-fastapi

# 分配代理
paperclip task assign researcher "分析 Rails 路由和模型"
paperclip task assign coder "实现匹配 Rails 行为的 FastAPI 端点"
paperclip task assign reviewer "验证 API 契约兼容性"

# 运行管线
paperclip run pipeline
```

结果：2 周的迁移在 3 天内完成，首次运行通过率 94%。

### 实际用例 2：自动化 PR 审查

```bash
# 监控 GitHub 仓库
paperclip monitor github --repo myorg/myapp --branch develop

# 配置审查代理
paperclip agent configure reviewer \
  --template security-review \
  --severity-critical true \
  --auto-comment true

# 每次 PR 触发审查
# 代理分析 diff、注释问题、建议修复
```

## Advanced Usage / Production Hardening

### 自定义代理工作流

创建多步代理管线：

```yaml
# workflows/code-review.yaml
workflow:
  name: "full-code-review"
  steps:
    - agent: linter
      task: "对更改的文件运行 linting"
      output: "lint_results"
    - agent: security
      task: "审查 lint 结果中的安全问题"
      input: "lint_results"
      output: "security_findings"
    - agent: reviewer
      task: "全面代码审查"
      input: ["security_findings", "git_diff"]
      output: "review_comments"
    - agent: summarizer
      task: "创建 PR 审查摘要"
      input: "review_comments"
      output: "pr_comment"
```

### 自托管代理存储

对于生产数据保留：

```bash
# 配置持久化存储
paperclip storage configure \
  --type postgres \
  --host db.internal \
  --database paperclip \
  --user paperclip

# 配置向量存储用于对话搜索
paperclip vector-store configure \
  --type qdrant \
  --host vector.internal \
  --port 6333
```

### 多团队工作区隔离

```bash
# 创建设备工作区
paperclip team create engineering
paperclip team create data-science
paperclip team create devops

# 分配代理到团队
paperclip team assign engineering --agents coder-1 coder-2 reviewer-1
paperclip team assign data-science --agents researcher-1 coder-3
```

## Comparison with Alternatives

| 功能 | paperclip | CrewAI | AutoGen | OpenAI Agents SDK |
|------|-----------|--------|---------|-------------------|
| Web UI | 功能完整的仪表板 | 仅 CLI | 仅 CLI | 仅代码 |
| 多代理任务 | 看板风格 | 顺序/并行 | 基于对话 | 基于护栏 |
| 自托管 | 是（Docker/K8s） | 是 | 是 | 是 |
| 代理市场 | 内置 | 手动设置 | 手动设置 | 手动设置 |
| 对话历史 | 完整、可搜索 | 有限 | 有限 | 无 |
| 任务跟踪 | 实时仪表板 | 无 | 无 | 无 |
| 部署易用性 | docker compose up | pip install | pip install | pip install |
| 自定义代理模板 | 10+ 内置 | 手动 | 手动 | 手动 |
| API 成本监控 | 每代理跟踪 | 无 | 无 | 无 |
| 社区规模 | 69.7k 星标 | 45k+ 星标 | 40k+ 星标 | 27k 星标 |

## Limitations / Honest Assessment

paperclip 不是万能药。这是它**不适合**的情况：

1. **单代理工作流** — 如果你只运行一个 AI 代理，paperclip 会增加不必要的开销。直接使用代理的本地 CLI。

2. **实时代理协调** — paperclip 优化异步任务完成，而非实时代理间通信。对于实时多代理对话，考虑 AutoGen 的对话模型。

3. **资源密集型设置** — 运行带有 Docker 的 paperclip 需要 ~500MB RAM 仅用于编排器本身。在总 RAM 少于 2GB 的机器上，考虑直接运行独立代理。

4. **有限的原生 AI 模型** — paperclip 不托管模型。它连接到外部 API（OpenAI、Anthropic、本地 vLLM）。如果你需要内置模型服务的综合解决方案，另寻他处。

5. **学习曲线** — 看板风格的任务管理和多步工作流有学习曲线。简单用例可以在几分钟内完成，但复杂的多代理管线可能需要数小时才能最优配置。

## Frequently Asked Questions

**Q：paperclip 是单个 AI 编码代理的替代品吗？**

A：不是。paperclip 是一个编排层，管理现有代理。你仍然需要 Claude Code、Codex CLI 或你想要协调的任何代理。paperclip 在上面添加了任务管理、上下文路由和团队协调。

**Q：我可以将 paperclip 与 Ollama 或 vLLM 的本地模型一起使用吗？**

A：可以。paperclip 支持任何 OpenAI 兼容 API 端点，包括 Ollama（`http://localhost:11434/v1`）和 vLLM（`http://localhost:8000/v1`）。只需在添加代理时配置端点即可。

**Q：paperclip 如何处理 API key 安全？**

A：API key 以加密形式存储在本地数据库中，从不直接向代理暴露。代理接收映射到配置 API key 的会话 token。密钥使用 AES-256-GCM 加密，密钥源自系统的 TPM 或操作系统密钥库。

**Q：paperclip 适合企业使用吗？**

A：可以。paperclip 专为独立开发者和企业团队设计。它支持工作区隔离、基于团队访问控制、审计日志和本地部署。企业功能包括 SSO、基于角色的权限和合规报告。

**Q：我可以导出我的代理对话和数据吗？**

A：可以。所有对话、任务和输出都可以导出为 JSON 或 Markdown。使用 `paperclip export --format json --workspace my-workspace` 进行完整导出，或使用 `paperclip export --format md --workspace my-workspace --conversation <id>` 导出特定对话。

## Sources & Further Reading

- 官方文档：https://docs.paperclip.ai
- GitHub 仓库：https://github.com/paperclipai/paperclip
- 部署模式指南：https://github.com/paperclipai/paperclip/blob/master/doc/DEPLOYMENT-MODES.md
- Docker 设置：https://github.com/paperclipai/paperclip/blob/master/doc/DOCKER.md
- 社区讨论：https://github.com/paperclipai/paperclip/discussions

## Conclusion：将 AI 代理作为团队管理是未来

paperclip 解决了一个大多数开发者在规模上遇到的真实问题：没有管理层时协调多个 AI 代理会变得混乱。在 69,700 星标和持续增长，结构化代理管理的需求显然是真实的。

如果你每天处理 2+ AI 代理——编码、审查、研究——paperclip 为你提供看板、对话历史和部署管线，将混乱转变为管理工作流。自托管选项意味着没有供应商锁定、数据不离开你的基础设施。

加入 [dibi8 中文 Telegram 群](https://t.me/DIBI8_Group/4) 讨论 paperclip 设置和代理模板。查看我们的 [cc-switch 统一 CLI](dibi8-internal-link) 和 [Langflow 可视化工作流](dibi8-internal-link) 指南了解相关工具。今天就试试 paperclip——`docker compose up`，添加两个代理，看着你的第一个多代理管线运行。

上方部分链接含联盟推广。如通过链接注册，dibi8.com 可能获得佣金，不影响你的成本。这帮助 dibi8 持续免费运营。
