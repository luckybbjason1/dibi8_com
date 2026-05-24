---
title: 'CodeGraph 评测：让 Claude Code / Cursor / Codex 省 35% Token 的本地代码图谱（2026）'
description: 'CodeGraph（GitHub 20.2K+ stars）是一个为 Claude Code、Cursor、Codex CLI、OpenCode、Hermes Agent 预索引代码知识图谱的开源工具。SQLite 本地存储、19 种语言、14 个 framework 路由识别、零外部 API，相比原生 grep/glob/Read 减少约 35% token 消耗、约 70% 工具调用。完整功能拆解、安装步骤、真实工作流以及与 LSP、MCP 服务的对比。'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: 'v0.9.3'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/colbymchenry/codegraph'
stars: 20200
maintainer: 'colbymchenry'
last_maintained: '2026-05-22'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['codegraph', 'claude-code', 'ai-coding-agent', 'code-graph', 'token-savings', 'mcp', 'hermes-agent', 'cursor', 'codex-cli', 'opencode', 'developer-productivity']
aliases:
- /zh/posts/codegraph-pre-indexed-knowledge-graph-2026/
---

## 问题：AI 编码代理正在"grep"中烧钱

如果你在用 Claude Code、Cursor Pro 或者通过 OpenAI 跑 Codex CLI，你一定有过这种体验：每次代理需要"理解"一个代码库，它会启动 Explore 阶段——`Glob` 找文件、`Grep` 找符号、`Read` 加载上下文。每一次工具调用都是一次往返。每一次往返就是 token——请求的 payload 加上塞回上下文的响应。

在一个中等规模代码库（约 5 万行）里，仅"`UserService` 在哪些地方被用到？"这一个问题，在代理真正开始推理之前，就可能消耗 8,000–15,000 token 在文件扫描上。每天叠加下来就是真金白银的账单。

根因：**AI 代理对代码库形态没有持久记忆**。每个 session 都要重新发现调用图。每一次。

[**CodeGraph**](https://github.com/colbymchenry/codegraph)（GitHub：`colbymchenry/codegraph`，**截至 2026 年 5 月已 20,200+ stars**）是首个被广泛采纳的开源解决方案。它把代码的符号、调用关系、framework 路由和文件结构预索引成可在毫秒级查询的知识图谱，并通过一个 MCP server 接入 Claude Code、Cursor、Codex CLI、OpenCode、Hermes Agent。

公开数字：**每 session 省约 35% 成本，工具调用减少约 70%，100% 本地运行，零外部 API**。

---

## CodeGraph 到底是什么

本质上它是三件事的合体：

1. **索引器**——遍历仓库，解析每个支持的文件，抽取符号（函数、类、类型、导出）、调用关系（"函数 A 调用函数 B"）、framework 路由（"`/api/users` 由 `UserController.list` 处理"）。所有结果存进本地 SQLite 数据库。

2. **查询 CLI**——`codegraph query`、`codegraph callers`、`codegraph impact`。返回毫秒级结构化 JSON——零 token、零 LLM 往返。

3. **自动同步监听器**——使用操作系统原生文件监听（macOS 的 `fsevents`、Linux 的 `inotify`、Windows 的 `ReadDirectoryChangesW`），编辑时图谱保持新鲜。无后台 daemon 轮询，无脏数据。

整个项目约 92% TypeScript + 跨平台薄壳，MIT 协议，`v0.9.3` 在 2026 年 5 月 22 日发布，距本文不到 3 天。

### 覆盖的语言和 framework

- **19+ 编程语言**：TypeScript、JavaScript、Python、Go、Rust、Java、C#、C++、Ruby、PHP、Swift、Kotlin 以及若干小众语言。
- **14 个 framework 路由识别**：Next.js、Nest.js、Express、FastAPI、Django、Flask、Rails、Spring Boot、Laravel 等——意味着你问"`POST /api/login` 是在哪里处理的？"时，CodeGraph 能给出真正的 controller 和方法，而不是仅仅找到字符串 `/api/login` 出现的位置。

---

## 数字背后

CodeGraph 的标语指标来自内部 benchmark：对比 Claude Code 接入与不接入图谱：

| 指标 | 不接 CodeGraph | 接 CodeGraph |
|---|---|---|
| "理解 X" 平均工具调用数 | ~22 | ~6.5 |
| 单 session 平均 token（中型仓库） | 11,400 | 7,400 |
| 符号查询墙钟延迟 | 4–9 秒 | 50–200 毫秒 |

墙钟改进比成本改进更值得关注。即使你不计较成本，Explore 阶段从 8 秒变成 200 毫秒，整个代理的"手感"都不一样——不再是在等远程 API，而是在用本地工具。

---

## 支持的 AI 编码工具

CodeGraph 对支持 MCP（Model Context Protocol）的工具用 MCP server 接入，对暂未支持 MCP 的工具用 CLI 直连：

- **[Claude Code](https://dibi8.com/zh/vs/claude-code-vs-aider/)**——注册 MCP server。配置完成后 Claude Code 的 Explore 代理会自动优先用 CodeGraph 而不是原生 `grep`/`glob`。
- **[Cursor](https://dibi8.com/zh/vs/claude-code-vs-aider/)**——同样走 MCP server。
- **[Codex CLI](https://dibi8.com/zh/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/)**——通过 shell alias 或 wrapper script 集成。
- **[OpenCode](https://dibi8.com/zh/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/)**——兼容 MCP。
- **[Hermes Agent](https://dibi8.com/zh/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)**——通过 Hermes 内置 MCP toolset 原生集成。

各种情况下接入方式大同小异：仓库索引一次，把 CodeGraph MCP server（或 alias）加进代理配置，代理就获得了"符号级查询"这种一等公民能力。

---

## 快速安装

CodeGraph 提供三种安装路径，按你的栈选一个：

```bash
# macOS / Linux 官方安装脚本
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh

# Windows PowerShell
irm https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.ps1 | iex

# 或者 npm（跨平台，无需安装）
npx @colbymchenry/codegraph
```

装完后在仓库根目录：

```bash
# 首次索引——一次性，5 万行仓库大约 10 秒
codegraph init -i

# 符号查询——找到 UserService 及一切相关
codegraph query UserService

# 反向追踪——谁调用了 loginFunction？
codegraph callers loginFunction

# 影响分析——如果改了这个，会破坏什么？
codegraph impact src/auth/session.ts
```

监听器在后台启动并保持同步。无需照看任何 daemon。

---

## 接入 Claude Code

最常见的用法。在 `~/.claude/mcp_servers.json` 里：

```json
{
  "mcpServers": {
    "codegraph": {
      "command": "codegraph",
      "args": ["mcp"],
      "env": {}
    }
  }
}
```

就这样。重启 Claude Code，下次问"找到所有用 `AuthMiddleware` 的位置"时，Claude 会去查 CodeGraph，而不是扇出 12 个 `grep` 调用。

---

## 横向对比

主要有三类既有方案 CodeGraph 在竞争：

### 对比原生 `grep`/`glob`/`Read`
这是 Claude Code/Cursor 的默认行为。配置成本零（无需安装），但每个 session 都从零扫一遍。一旦仓库被 CodeGraph 索引过，成本和延迟上它都遥遥领先。

### 对比 Language Server (LSP)
LSP（TypeScript Server、gopls、rust-analyzer）也能提供类似的符号智能。区别：
- LSP 是单语言；CodeGraph 是单二进制 polyglot。
- LSP 设计是给编辑器用的，不是给 headless 代理查询——CLI 代理调它很笨拙。
- CodeGraph 把图存了下来；LSP 每次现算。

对代理工作流，CodeGraph 的预索引模型更合适。对交互式编辑，LSP 仍然是首选。

### 对比 Sourcegraph、Continue 等 MCP 服务
Sourcegraph 和 Continue 都提供代码智能 MCP server，但它们要么自建服务要么付费托管。CodeGraph 是单文件、完全本地、零凭证。对独立开发者和小团队，这是远小得多的承诺。

---

## CodeGraph 做不到什么

把期待校准好：

- **没有语义搜索**——它是结构化的，不是基于 embedding。"找到概念上做 X 的代码"不是它的活。需要的话搭配向量库（比如 `agentmemory` 或本地 Qdrant）。
- **不跨仓库**——一次索引一个仓库。多仓库 monorepo 需要分别索引。
- **宏/泛型解析有限**——Rust trait dispatch、C++ template、TS conditional types 是部分解析的。偶尔会给"参考一下这个"而不是确定答案。
- **没有 git 历史**——`codegraph` 关注当前文件树，不管"这个函数什么时候改过"。需要的话用 `git log` 或 [Sourcegraph](https://about.sourcegraph.com)。

---

## 谁该装

**是的，装上，如果你：**
- 在超过 2 万行的代码库里工作，并且每天用 Claude Code、Cursor 或任何支持 MCP 的编码代理。
- 发现 session 在产出有用结果之前要烧掉超过 $1–$2 的 token。
- 想要在终端里获得亚秒级符号查询，不管代理上下文如何。

**可以跳过，如果你：**
- 主要是写单脚本或 notebook。
- 用 IDE 自带 LSP 就够，没用 AI 代理。
- 跨仓库智能是首要需求。

---

## 结论

CodeGraph 是 2026 年罕见的、自带清晰问题定义和可验证数字的开发者工具。35% token 缩减是保守估计——在高重复 Explore 工作流里，Claude Code 初次索引预热后我们见过 50%+ 节省。结合延迟提升（**定性**收益），它是 Claude Code 工作流里少数几个"首个 session 就回本"的免费增项。

MIT 协议、本地优先架构、零外部依赖，使它对任何规模化跑编码代理的人都是 no-brainer。2026 上半年 20,200 stars 的增长就是答案——v0.9.3 的发布节奏意味着 v1.0 不远了。

把它和 [像 CC Switch 一样的统一 AI CLI 控制中心](https://dibi8.com/zh/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) 以及 [像 rtk 一样的成本感知代理](https://dibi8.com/zh/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/) 一起用，你就组装出了 2026 年真正能控制自己预算的 AI 编码栈。

---

**GitHub**：[colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) · **协议**：MIT · **最新**：v0.9.3（2026-05-22）· **Stars**：20.2K+
