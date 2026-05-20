---
title: 'Claude Code: 125K+ Stars — 终端 AI 编程代理完整对比 2026'
description: 'Claude Code 是 Anthropic 的终端编程代理工具，支持 VS Code、Cursor、GitHub、GitLab。涵盖安装教程、基准测试，以及与 Aider、OpenHands 和 Codex CLI 的对比分析。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Anthropic Terms
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/anthropics/claude-code'
stars: 125050
maintainer: 'anthropics'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['claude-code', 'ai-coding-agent', '终端编程', 'anthropic', 'claude教程', 'claude-code-vs-aider', 'claude-code安装']
aliases:
- /zh/posts/claude-code/
---

{{</* resource-info */>}}

## 简介

基于终端的 AI 编程代理正在改变开发者与代码库交互的方式。你不再需要先从浏览器窗口复制代码片段，而是在终端中输入一条命令，然后看着代理自动读取你的代码仓库、规划变更、编辑文件、运行测试并提交到 Git。Anthropic 的 Claude Code 以 125,050 个 GitHub Stars 和 100 万 token 的上下文窗口领先这一类别。本指南涵盖完整的安装配置、生产环境加固，以及与 Aider、OpenHands 和 OpenAI Codex CLI 的横向对比，帮助你为工作流选择正确的工具。

## 什么是 Claude Code？

Claude Code 是 Anthropic 推出的终端编程代理工具，它深入理解你的代码库，并通过自然语言命令执行任务。它于 2025 年 2 月作为研究预览版发布，2025 年 5 月全面上市，现已成为专业工程团队中最广泛采用的 AI 开发工具之一。与只能建议下一行代码的自动补全插件不同，Claude Code 在项目级别运行：读取文件、执行跨文件编辑、运行 shell 命令、管理 Git 工作流，并在测试失败时持续迭代，直到任务完成。

![Claude Code 演示](https://raw.githubusercontent.com/anthropics/claude-code/main/demo.gif)

## Claude Code 的工作原理

### 架构概览

Claude Code 作为 Node.js CLI 进程运行，封装了 Claude API。它保持持久的会话上下文，在启动时读取项目结构并构建代码库的内部模型。该工具使用模型上下文协议（MCP）连接外部服务——数据库、API、文档系统——并可以为复杂的多步骤任务生成并行子代理。

![Claude Code 桌面界面](https://cdn.prod.website-files.com/67ed58c92cfedc451ebbbca1/699cc378d1f485eb812d5db2_Screenshot%202026-02-23%20at%202.15.32%E2%80%AFPM.png)

关键架构组件：

- **上下文引擎**：摄取高达 100 万 token 的项目上下文，使 Claude Code 能够在不截断的情况下对整个代码仓库进行推理
- **工具使用循环**：内置的执行周期，代理自动读取文件、运行命令、观察输出并决定下一步操作
- **子代理编排**：独立任务的并行代理执行，例如在为一个模块编写测试的同时重构另一个模块
- **生命周期钩子**：PreToolUse 和 PostToolUse 事件，允许你拦截和控制工具执行以实现确定性行为

### 核心概念

| 概念 | 描述 |
|---------|-------------|
| `CLAUDE.md` | 项目级配置文件，定义编码标准、约定和自定义指令 |
| 计划模式 (`/plan`) | Claude 在接触磁盘之前概述所有预期变更，让你拥有审批控制权 |
| 斜杠命令 | 可复用的工作流快捷方式，如 `/init`、`/desktop`、`/mcp` 和 `/bug` |
| MCP 集成 | 通过模型上下文协议连接外部工具，用于数据库查询、API 调用等 |

## 安装与配置

Claude Code 在 macOS、Linux 和 Windows（通过 WSL 或 PowerShell）上可在 60 秒内完成安装。不需要 Node.js 或 Docker——原生安装程序会处理一切。

### macOS 和 Linux（推荐安装方式）

```bash
# 通过官方安装程序安装（后台自动更新）
curl -fsSL https://claude.ai/install.sh | bash

# 确认二进制文件在 PATH 中
export PATH="$HOME/.local/bin:$PATH"

# 检查安装
claude --version
```

### Windows PowerShell

```powershell
# 通过 PowerShell 安装程序安装
irm https://claude.ai/install.ps1 | iex

# 验证安装
claude --version
```

### Homebrew（macOS/Linux — 需手动更新）

```bash
# 通过 Homebrew 安装（不会自动更新）
brew install claude-code

# 需要时手动更新
brew upgrade claude-code
```

### VS Code 扩展

```bash
# 从 VS Code 市场安装
# 打开扩展面板 (Cmd+Shift+X / Ctrl+Shift+X)
# 搜索 "Claude Code" 并安装
# 该扩展会连接到终端中运行的同一会话
```

### 身份验证

```bash
# 使用你的 Anthropic 账户登录
claude auth login

# 这会打开浏览器窗口。Claude Code 需要付费订阅：
# - Claude Pro: $20/月
# - Claude Max: $100/月 (5 倍用量)
# - Claude Max 20x: $200/月 (20 倍用量)
```

### 首次会话

```bash
# 导航到你的项目
cd /path/to/your-project

# 启动 Claude Code
claude

# 让它熟悉项目结构
What does this project do? Walk me through the architecture.
```

## 与主流工具集成

### VS Code

Claude Code 扩展将 CLI 会话嵌入到编辑器侧边栏中。从市场安装，一次性完成认证，即可在终端和 IDE 之间切换而不会丢失上下文。

```json
// .vscode/settings.json — Claude Code 推荐配置
{
  "claude.code.enableInlineCompletion": false,
  "claude.code.autoApproveEdits": false,
  "claude.code.defaultModel": "claude-opus-4-6"
}
```

### Cursor

由于 Cursor 是 VS Code 的分支，Claude Code 可以在 Cursor 的集成终端中运行。这两种工具互为补充：Cursor 处理行内自动补全和可视化差异，而 Claude Code 管理多文件重构和自主任务执行。

```bash
# 在 Cursor 的集成终端中，直接运行：
cd your-project
claude

# 两个工具在同一个文件系统上运行，互不冲突
```

### GitHub 集成

在 GitHub Pull Request 或 Issue 中标记 `@claude` 即可触发 Claude Code 分析。代理会读取 PR 差异、留下审查评论并可以建议修复。

```bash
# 启用 GitHub 集成
claude auth login --github

# 在 PR 评论中标记：
@claude please review this change for security issues
```

### GitLab CI/CD 流水线

```yaml
# .gitlab-ci.yml — 运行 Claude Code 进行自动化代码审查
stages:
  - review

claude_review:
  stage: review
  image: node:22
  before_script:
    - curl -fsSL https://claude.ai/install.sh | bash
    - export PATH="$HOME/.local/bin:$PATH"
    - claude auth login --token $CLAUDE_API_TOKEN
  script:
    - claude review --diff HEAD~1 --output review.json
  artifacts:
    reports:
      codequality: review.json
```

### JetBrains IDE

从 JetBrains 市场安装 Claude Code 插件。它支持 WebStorm、IntelliJ、PyCharm、GoLand 和所有其他 JetBrains 产品。

```bash
# 在任何 JetBrains IDE 中：
# 设置 → 插件 → 市场 → 搜索 "Claude Code" → 安装 → 重启
```

## 基准测试 / 实际使用案例

### SWE-bench Verified

SWE-bench Verified 是 AI 编程代理的黄金标准基准测试，衡量解决真实 GitHub 问题的能力。截至 2026 年 3 月：

![Claude Code 实战演示](https://img.youtube.com/vi/iI_zWNunkc4/maxresdefault.jpg)

| 代理 / 模型 | SWE-bench Verified | 日期 | 来源 |
|---------------|-------------------|------|--------|
| Claude Code + Opus 4.6 | **80.8%** | 2026-03 | Anthropic |
| Claude Code + Opus 4.5 | 64.3% | 2025-12 | SWE-bench 排行榜 |
| Codex CLI + GPT-5.5 | 58.6% | 2026-04 | OpenAI |
| OpenHands + Opus 4.5 | 51.9% | 2026-01 | Terminal-Bench |
| Aider + Opus 4.6 | ~55% | 2026-03 | Aider 排行榜 (估算) |

### Terminal-Bench 2.0

Terminal-Bench 衡量真实终端任务完成准确率：

| 代理 | 模型 | 准确率 | 排名 |
|-------|-------|----------|------|
| Codex CLI | GPT-5.5 | **82.0%** | #7 |
| Claude Code | Opus 4.6 | **58.0%** | #51 |
| Claude Code | Opus 4.5 | 52.1% | #62 |
| OpenHands | Opus 4.5 | 51.9% | #63 |

### 实际生产力指标

基于 2026 年第一季度的开发者报告汇总：

| 指标 | Claude Code | Aider | Codex CLI |
|--------|-------------|-------|-----------|
| 首次提交平均时间 | 4.2 分钟 | 6.1 分钟 | 3.8 分钟 |
| 多文件重构成功率 | 78% | 62% | 71% |
| 测试通过率（自主） | 84% | 71% | 79% |
| 每次任务 token 消耗（平均） | 高 | 低 | 中等 |

## 高级用法 / 生产环境加固

### CLAUDE.md 配置

`CLAUDE.md` 文件是 Claude Code 的项目指令手册。将其放在仓库根目录中。

```markdown
# CLAUDE.md — Claude Code 项目配置

## 编码标准
- 使用 TypeScript 严格模式，启用 noImplicitAny
- 遵循现有的 Prettier 配置 (.prettierrc)
- 所有函数必须包含 JSDoc 注释
- 优先使用 async/await，避免 Promise 链

## 测试
- 提交前运行 `npm test`
- 新功能需要单元测试覆盖率 >80%
- 单元测试使用 Vitest，E2E 测试使用 Playwright

## Git 工作流
- 使用约定式提交 (feat:, fix:, docs:, refactor:)
- 每个任务创建新分支，不要直接提交到 main
- 每次提交前运行 `npm run lint`

## 架构
- /src/components — React 组件（PascalCase 文件名）
- /src/lib — 工具函数（camelCase 文件名）
- /src/api — 路由处理器
- /tests — 镜像 src 结构
```

### 安全沙箱

Claude Code 使用你的用户权限执行 shell 命令，这存在固有风险。对于生产环境，请使用沙箱运行：

```bash
# 在 Docker 沙箱中运行 Claude Code
docker run -it --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  --read-only \
  --tmpfs /tmp \
  node:22-slim \
  bash -c "curl -fsSL https://claude.ai/install.sh | bash && /root/.local/bin/claude"
```

### 使用生命周期钩子进行权限控制

```json
// ~/.claude/settings.json — 全局权限规则
{
  "permissions": {
    "file_write": {
      "allowed_paths": ["/home/dev/projects/*"],
      "denied_paths": ["/etc/*", "/usr/local/bin/*"]
    },
    "shell_command": {
      "allowed_commands": ["npm *", "git *", "pytest *", "docker build *"],
      "denied_commands": ["rm -rf /", "curl * | sh", "sudo *"]
    }
  },
  "hooks": {
    "PreToolUse": "/home/dev/.claude/hooks/pre-tool.sh",
    "PostToolUse": "/home/dev/.claude/hooks/post-tool.sh"
  }
}
```

### MCP 服务器配置

```json
// mcp.json — 连接外部工具
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/devdb"]
    },
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github", "--token", "$GITHUB_TOKEN"]
    },
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/dev/projects"]
    }
  }
}
```

### 监控 Token 使用量

```bash
# 检查当前会话的 token 消耗
claude status

# 输出：
# Session: 42m 12s
# Input tokens: 145,230 (cache hit: 67%)
# Output tokens: 28,441
# Estimated cost: $0.42
# Rate limit: 4,200/5,000 requests remaining
```

## 与替代品对比

### 横向功能对比

| 功能 | Claude Code | Aider | OpenHands | Codex CLI |
|---------|-------------|-------|-----------|-----------|
| **GitHub Stars** | 125,050 | 32,800 | 73,913 | 83,000 |
| **许可证** | Anthropic 条款 | Apache-2.0 | MIT | Apache-2.0 |
| **模型支持** | 仅 Claude | 任意 LLM | 任意 LLM | 仅 OpenAI |
| **上下文窗口** | 1,000,000 tokens | ~200,000 tokens | ~200,000 tokens | ~200,000 tokens |
| **SWE-bench Verified** | 80.8% (Opus 4.6) | ~55% | 51.9% | 58.6% (GPT-5.5) |
| **Terminal-Bench 2.0** | 58.0% (Opus 4.6) | N/A | 51.9% | 82.0% (GPT-5.5) |
| **定价模式** | 订阅制 ($20-$200/月) | 仅 API 费用 | 免费（自托管） | 随 ChatGPT+ 捆绑 |
| **Git 集成** | 良好（分支隔离） | 优秀（自动提交） | 良好 | 良好（worktree 隔离） |
| **多代理** | 是（并行子代理） | 否 | 是 | 是（最多 6 个代理） |
| **MCP 支持** | 原生 | 通过插件 | 是 | 原生 |
| **IDE 扩展** | VS Code, JetBrains | 无 | VS Code | VS Code |
| **桌面应用** | 是 (macOS, Windows) | 否 | 否 | 是 (macOS, Windows) |
| **自动审批** | 可配置 | 显式确认 | 可配置 | 可配置 |
| **安装时间** | < 1 分钟 | < 2 分钟 (pip) | 5-10 分钟 (Docker) | < 1 分钟 |
| **开源** | 否 | 是 | 是 | 是 |

### 如何选择

**选择 Claude Code 当：**
- 你需要最高的 SWE-bench 分数（80.8%）用于复杂 Bug 修复
- 你的工作流以终端为主，偶尔使用 IDE
- 你需要 100 万 token 上下文窗口处理大型 monorepo
- 你偏好可预测的订阅定价而非按 token 计费
- 你需要并行子代理执行多步骤自主任务

**选择 Aider 当：**
- 你需要模型灵活性（在 GPT、Claude、Gemini、本地模型间切换）
- Git 自动提交历史对团队审计追踪很重要
- 你偏好每个变更在写入磁盘前都需要显式确认
- 你需要轻量级开源工具，零订阅费用
- 你对预算敏感，希望按任务控制 API 支出

**选择 OpenHands 当：**
- 你需要完全开源、自托管的解决方案
- 数据隐私要求在自己的基础设施上运行所有内容
- 你想要大型社区（73K+ Stars）和活跃开发
- MIT 许可证对商业再分发很重要
- 你需要多代理编排而没有供应商锁定

**选择 Codex CLI 当：**
- 你已有 ChatGPT Plus 或 Pro 订阅
- Terminal-Bench 速度最重要（82.0% 准确率）
- 你想要随现有 AI 订阅捆绑的开源工具
- 你需要交互式结对编程的最低延迟
- 需要最多 6 个并行代理的多代理并发能力

## 局限性 / 客观评估

Claude Code 是一个强大的工具，但并非适合每位开发者或团队。以下是营销材料不会告诉你的内容：

1. **订阅锁定**：Claude Code 需要付费的 Anthropic 订阅。$20/月的 Pro 是入门级别，重度用户需要 $100 或 $200 的 Max 等级。与 Aider 或 OpenHands 不同，你不能自带 API 密钥，按用量付费。

2. **仅限 Claude 模型**：你无法切换到 GPT-5、Gemini 或本地模型。如果 Claude Opus 4.6 在某个特定任务上表现不佳，你在同一工具中没有备选方案。

3. **终端优先的局限**：打字时没有行内自动补全。如果你的工作流依赖于编辑器中的实时代码建议，Cursor 或 GitHub Copilot 更适合。Claude Code 在单独的终端会话中运行。

4. **Token 消耗**：100 万 token 的上下文窗口是一把双刃剑。Claude Code 会积极加载上下文，重度使用可能快速耗尽速率限制。Pro 计划用户报告在使用并行子代理的长会话期间遇到限流。

5. **可视化差异审查**：与 Cursor 的原生并排差异查看器不同，Claude Code 通过终端中的 Git diff 显示变更，或需要切换到桌面应用。终端差异查看功能可用但不够精致。

6. **企业 SSO 缺口**：截至 2026 年 5 月，Claude Code 缺乏原生 OIDC/SCIM 企业 SSO。需要集中身份管理的团队必须使用基于 API 密钥的变通方案。

7. **没有免费版**：没有试用层。你必须先支付 $20 才能试用该工具，而 Cursor（每月 50 次免费高级请求）或 OpenHands（完全免费）都有免费层。

## 常见问题

**Q: Claude Code 是免费的吗？**
A: 不是。Claude Code 需要付费的 Anthropic 订阅，Claude Pro 起价为 $20/月。没有免费层。Pro 计划包含随等级扩展的用量限制；Max 计划每月 $100 和 $200 分别提供 5 倍和 20 倍的容量。团队和企业计划有额外的按席位定价。

**Q: Claude Code 与 GitHub Copilot 有何不同？**
A: GitHub Copilot 在你输入时在 IDE 中提供行内自动补全建议。Claude Code 是基于终端的代理，读取你的整个代码库，规划多文件变更，执行 shell 命令，运行测试，并自主提交到 Git。Copilot 在你打字时辅助；Claude Code 在你审查时工作。它们互为补充而非竞争。

**Q: 我可以不使用终端来运行 Claude Code 吗？**
A: 可以。Anthropic 为 macOS 和 Windows 提供桌面应用，具有完整的 GUI、集成终端、内置差异查看器和对并行代理会话的支持。还有 VS Code 和 JetBrains 扩展可以将 Claude Code 嵌入 IDE 中。但是，终端 CLI 仍然是最功能完整的界面。

**Q: Claude Code 支持哪些编程语言？**
A: Claude Code 是语言无关的，因为它在文件系统和 shell 级别运行。它可以读取和编辑任何基于文本的代码文件。对 Python、JavaScript、TypeScript、Go、Rust、Java、Ruby 和 PHP 有一流支持。小众语言也可以工作，但可能需要在提示中提供更明确的说明。

**Q: 100 万 token 的上下文窗口在实践中如何帮助？**
A: 大上下文窗口允许 Claude Code 加载整个代码仓库（或其大部分）而不截断。这对跨文件重构、理解 monorepo 架构以及调试跨多个模块的问题很重要。实践中，50 万行以下的代码仓库可以舒适地放入上下文窗口。

**Q: Claude Code 对生产代码库安全吗？**
A: Claude Code 使用你的用户权限执行 shell 命令，这存在固有风险。对于生产环境，请在 Docker 沙箱中运行，配置生命周期钩子以拦截危险命令，并始终使用计划模式（`/plan`）在执行前审查变更。切勿在不受信任的仓库上使用 sudo 运行 Claude Code 或没有沙箱保护的情况下运行。

**Q: 我可以同时使用 Claude Code 和 Cursor 或 VS Code 吗？**
A: 可以。许多开发者同时使用两者：Cursor 处理日常编辑循环的行内自动补全，而 Claude Code 在终端窗格中管理大型自主重构。它们在同一个 Git 仓库上运行而不会冲突，尽管并发编辑同一文件可能导致合并冲突。

## 结论

Claude Code 代表了 2026 年最强大的终端原生 AI 编程代理。凭借 125,050 个 GitHub Stars、80.8% 的 SWE-bench Verified 分数和 100 万 token 的上下文窗口，它在推理深度和长时任务完成方面领先。订阅模式为重度用户提供可预测的定价，但缺乏免费层和仅限 Claude 模型的支持是实际的权衡。

对于已标准化使用 Anthropic 模型的团队，Claude Code 是自然的选择。对于需要模型灵活性或零订阅成本的开发者，Aider 和 OpenHands 是强大的开源替代品。对于希望获得最快终端代理的 ChatGPT 订阅者，Codex CLI 以无额外成本提供有竞争力的结果。

**入门行动清单：**
1. 使用 `curl -fsSL https://claude.ai/install.sh | bash` 安装 Claude Code
2. 使用 `claude auth login` 认证并订阅 Claude Pro ($20/月)
3. 在你的主项目中创建包含编码标准的 `CLAUDE.md` 文件
4. 在项目目录中运行 `claude` 并让它梳理架构
5. 加入 [dibi8 Telegram 群组](https://t.me/dibi8channel) 分享技巧并提问



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与扩展阅读

- [Claude Code 官方文档](https://docs.claude.com/en/docs/claude-code/)
- [Claude Code GitHub 仓库](https://github.com/anthropics/claude-code)
- [SWE-bench Verified 排行榜](https://www.swebench.com/)
- [Terminal-Bench 2.0 排行榜](https://www.tbench.ai/leaderboard/terminal-bench/2.0)
- [Claude Code vs Cursor 2026 对比](https://tech-insider.org/claude-code-vs-cursor-2026-2/)
- [Aider vs Claude Code 对比](https://zenvanriel.com/ai-engineer-blog/aider-vs-claude-code/)
- [OpenHands GitHub 仓库](https://github.com/All-Hands-AI/OpenHands)
- [OpenAI Codex CLI 文档](https://github.com/openai/codex)
- [模型上下文协议规范](https://modelcontextprotocol.io/)
- [Anthropic 定价页面](https://www.anthropic.com/pricing)
- [Claude Code 桌面应用下载](https://claude.com/download)

---

*免责声明：本文不含联盟营销链接。所有定价和基准测试数据反映截至 2026 年 5 月的公开信息。在购买决策前，请在官方供应商网站上核实当前定价。*
