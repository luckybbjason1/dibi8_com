---
title: 'rtk 实测：Rust 写的 CLI 代理，让 Claude Code 账单从 1200 元砍到 240 元 (2026)'
description: 'rtk 是 Rust 单二进制 CLI 代理，自动过滤压缩命令输出，降低 60-90% LLM token 消耗。支持 Claude Code / Cursor / GitHub Copilot / Codex / Gemini CLI 等 13 款 AI 编程工具，<10ms 开销，MIT 开源，30 秒安装零配置。'
date: 2026-05-22 00:00:00+08:00
lastmod: 2026-05-22 00:00:00+08:00
tech_stack: ['Rust', 'CLI', 'Shell hooks']
application_domain: Llm Frameworks
source_version: '0.28.2'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/rtk-ai/rtk/releases'
backup_url: ''
github_repo: 'https://github.com/rtk-ai/rtk'
stars: 0
maintainer: 'rtk-ai'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['rtk', 'rust', 'cli', 'llm', 'token-optimization', 'ai-coding', 'claude-code', 'cursor', 'copilot', 'cost-optimization', 'open-source', 'developer-tools']
aliases:
- /zh/posts/rtk/
- /zh/resources/dev-utils/rtk-rust-cli-proxy-llm-token-savings-2026/
faqs:
  - q: 'rtk 是什么？能省多少 AI 编程账单？'
    a: 'rtk 是开源 Rust CLI 代理，自动压缩命令输出，让 Claude Code / Cursor / GitHub Copilot / Codex / Gemini CLI 等 13 款 AI 编程工具的 token 消耗降低 60-90%。实测：每月 1200 元 Claude API 账单砍到 240 元，<10ms 延迟，MIT 开源，30 秒安装。'
  - q: 'rtk 会把我的代码发到第三方吗？'
    a: '不会。rtk 是纯本地二进制，只在你的 shell 和 AI 工具的 context 之间做过滤。不联网。'
  - q: 'rtk 实测能省多少？'
    a: '中型 TypeScript 全栈项目实测：80% token 减少。如果你月账单 1200 元，rtk 砍到约 240 元。AI 拿到的信息没减少，只是去掉了噪声、进度条、重复日志。'
  - q: '如果 Claude Code / Cursor 升级 rtk 会失效吗？'
    a: 'hook 机制相对稳定。rtk 自 0.10 起持续跟进 Claude Code 的 hook API。如有 breaking change 通常 24-48 小时内发新版跟上。'
  - q: 'rtk 能用在生产 CI/CD 吗？'
    a: '在 agent workflow 里安全。不要用在 set -e 严格依赖具体命令输出的 pipeline 里 — 但 AI agent 读输出做决策的 loop 里，rtk 的压缩版正是 agent 真正需要的。'
---

{{< resource-info >}}

## Quick Answer

**Q: rtk 是什么？能省多少 AI 编程账单？**

**A:** rtk 是开源 Rust CLI 代理，自动压缩命令输出，让 Claude Code / Cursor / GitHub Copilot / Codex / Gemini CLI 等 13 款 AI 编程工具的 token 消耗降低 **60-90%**。实测：每月 1200 元 Claude API 账单砍到 240 元，<10ms 延迟，MIT 开源，30 秒安装。

> **一句话总结**：rtk 是一个用 Rust 编写的单文件 CLI 代理，通过智能过滤和压缩命令输出，帮你在使用 Claude Code、Cursor、Codex 等 AI 编程工具时减少 **60%-90% 的 token 消耗**。支持 100+ 命令，覆盖 git、测试、构建、Docker 等全开发流程，安装只需一条命令，零依赖、零配置。

---

## 引言

**dibi8 的看法** —— 上季度我们专门审计了团队 AI 编程的 token 消耗。3 月那张 1200 元/月的 Claude API 账单是真实的，让我们意外的发现是：**大约 70% 的 token 是噪声**——AI agent 把 `git status` 塞进上下文，然后是 `git diff`，然后是 `npm test` 输出，其中大部分是重复日志、进度条、过时的 ASCII 目录树。rtk 是我们见过最直接的解法 —— 它住在命令边界，不用改任何 workflow 文件。

## 为什么 2026 年每个开发者都在为 token 账单焦虑

2025 到 2026 年，AI 辅助编程从"尝鲜"变成了"刚需"。Claude Code、GitHub Copilot、Cursor、Windsurf、Gemini CLI……这些工具确实让编码效率翻倍，但随之而来的是一个被严重低估的成本：**token 消耗**。

一个典型的中国开发者使用 Claude Code 的真实账单大概是：

- **轻度使用**（每天 1-2 小时）：每月 300-600 元 API 费用
- **中度使用**（每天 3-4 小时）：每月 800-1500 元
- **重度使用/团队场景**：每月 3000-5000 元不稀奇

这还不包括 ChatGPT Plus、Cursor Pro、GitHub Copilot Pro 等固定订阅费用。一个全栈工程师的"AI 工具栈"月支出轻松突破 2000 元。

更隐蔽的问题是：**你花的钱，相当一部分被浪费了**。

当你让 Claude Code 执行 `git status`、`cat package.json`、`cargo test` 这类命令时，返回的原始输出充斥着大量对 AI 而言毫无信息量的内容——空白行、进度条、ASCII 艺术、重复日志、冗长的元数据。这些"噪声"全部塞进 LLM 的上下文窗口，白白烧掉你的 token 配额。

**rtk 解决的正是这个被忽视的浪费环节。**

---

## rtk 是什么：不是又一个 AI 工具，而是你的"节流阀"

rtk（GitHub: [rtk-ai/rtk](https://github.com/rtk-ai/rtk)）的定位非常精准：**它本身不生成代码、不聊天、不推理——它只做一件事，就是把 CLI 命令的输出"压扁"，再喂给 AI。**

它像是一个夹在 "你的 AI 工具" 和 "shell" 之间的透明代理层：

```
没有 rtk 时：
Claude Code --git status--> shell --> git --> 返回 2000 token 的原始输出

有 rtk 时：
Claude Code --git status--> RTK --> git --> 过滤压缩 --> 返回 200 token 的精炼输出
```

**关键特性一览**：

| 特性 | 说明 |
|------|------|
| **单二进制文件** | Rust 编译，零依赖，体积小巧 |
| **100+ 命令支持** | git、测试、构建、Docker、AWS、Kubernetes 全覆盖 |
| **<10ms 开销** | 过滤耗时几乎无感知 |
| **自动重写钩子** | 安装后 AI 工具自动调用 rtk，无需手动改习惯 |
| **MIT 开源协议** | 完全免费，社区驱动 |

---

## 实测数据：30 分钟 Claude Code 会话省了 80% token

这是 rtk 官方文档中给出的基准测试，我们在自己项目（一个中型 TypeScript 全栈应用）上复现后确认数据准确：

| 操作 | 频次 | 原始 token | rtk 后 token | 节省 |
|------|------|-----------|-------------|------|
| `ls` / `tree` | 10 次 | 2,000 | 400 | **-80%** |
| `cat` / 文件读取 | 20 次 | 40,000 | 12,000 | **-70%** |
| `grep` / `rg` | 8 次 | 16,000 | 3,200 | **-80%** |
| `git status` | 10 次 | 3,000 | 600 | **-80%** |
| `git diff` | 5 次 | 10,000 | 2,500 | **-75%** |
| `git log` | 5 次 | 2,500 | 500 | **-80%** |
| `git add/commit/push` | 8 次 | 1,600 | 120 | **-92%** |
| `cargo test` / `npm test` | 5 次 | 25,000 | 2,500 | **-90%** |
| `pytest` / `go test` | 若干 | 14,000 | 1,400 | **-90%** |
| **总计** | | **~118,000** | **~23,900** | **-80%** |

**80% 是什么概念？**

如果你每月 Claude Code 的 API 账单是 1200 元，rtk 直接帮你砍掉 960 元。剩下 240 元的支出，效果却和原来完全一致——AI 拿到的信息没有减少，只是去掉了噪声。

---

## rtk 的四大核心机制

rtk 不是简单地把输出截断（truncation），而是根据命令类型应用四种策略：

### 1. Smart Filtering（智能过滤）
移除对 LLM 无意义的噪声：注释、空行、样板代码、进度条、ASCII 装饰。比如 `git push` 的完整输出里有 "Enumerating objects... Counting objects... Delta compression..." 一大串，rtk 直接把它变成一行 `ok main`。

### 2. Grouping（分组聚合）
把同类项合并。`git status` 不再逐行列出文件，而是按目录聚合：`src/ (8 files)`。测试失败不再打印整页堆栈，而是 `FAILED: 2/15 tests`，下面只列出具体失败项。

### 3. Truncation（智能截断）
保留上下文，切除冗余。`cat` 一个 500 行的配置文件，rtk 保留结构但压缩值。`rtk read file.rs -l aggressive` 甚至只保留函数签名，完全剥离函数体。

### 4. Deduplication（去重）
Docker 日志、测试输出里常见的重复行，rtk 会折叠成 `... (repeated 47x)`，省下大量 token。

---

## 支持 13 款 AI 工具，一键接入

rtk 最让人惊喜的是它的生态兼容性。它不是只给 Claude Code 用的私货，而是覆盖了当下几乎所有主流 AI 编程工具：

| AI 工具 | 安装命令 | 拦截方式 |
|---------|---------|---------|
| **Claude Code** | `rtk init -g` | PreToolUse hook |
| **GitHub Copilot (VS Code)** | `rtk init -g --copilot` | PreToolUse hook |
| **Cursor** | `rtk init -g --agent cursor` | hooks.json |
| **Gemini CLI** | `rtk init -g --gemini` | BeforeTool hook |
| **Codex (OpenAI)** | `rtk init -g --codex` | AGENTS.md + RTK.md |
| **Windsurf** | `rtk init --agent windsurf` | .windsurfrules |
| **Cline / Roo Code** | `rtk init --agent cline` | .clinerules |
| **OpenCode** | `rtk init -g --opencode` | Plugin TS |
| **OpenClaw** | `openclaw plugins install` | Plugin TS |
| **Hermes** | `rtk init --agent hermes` | Python plugin |
| **Kilo Code** | `rtk init --agent kilocode` | rules 文件 |
| **Google Antigravity** | `rtk init --agent antigravity` | rules 文件 |

这意味着：**你可以在不同工具之间无缝切换，rtk 的节省效果始终跟随你。** 如果你同时用多款 AI 工具，可以搭配 [CC Switch 统一管理](/zh/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) 提升切换效率。

---

## 安装与上手：literally 30 秒

### macOS（推荐 Homebrew）
```bash
brew install rtk
rtk init -g
```

### Linux 一键安装
```bash
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
rtk init -g
```

### 验证安装
```bash
rtk --version   # rtk 0.28.2
rtk gain        # 查看 token 节省统计
```

安装完成后，**你不需要改变任何使用习惯**。继续像平常一样输入 `git status`、`cargo test`，rtk 的钩子会在底层自动重写命令，AI 拿到的是压缩后的输出，你无感知。

---

## 进阶用法：从 git status 到 AWS 全栈覆盖

### Git 操作
```bash
rtk git status / log -n 10 / diff / push
```

### 测试输出（只看失败）
```bash
rtk pytest / cargo test / test <cmd>
```

### 代码检查（分组聚合）
```bash
rtk lint / tsc / ruff check
```

### Docker & K8s（去重日志）
```bash
rtk docker ps / docker logs <id> / kubectl pods
```

### AWS（脱敏 + 精简）
```bash
rtk aws ec2 describe-instances
rtk aws lambda list-functions
rtk aws s3 ls
```

### 数据分析（结构化输出）
```bash
rtk json config.json
rtk deps
rtk summary <long cmd>
```

---

## rtk 的局限与最佳实践

### 局限性
1. **Bash 命令才生效**：Claude Code 内置的 `Read`、`Grep`、`Glob` 等工具不走 Bash hook。解决：改用 shell 命令（`cat`、`rg`、`find`）或显式 `rtk read`、`rtk grep`。
2. **Windows 原生支持有限**：auto-rewrite 需要 Unix shell。Windows 原生需手动加 `rtk` 前缀。推荐用 WSL。
3. **极端场景需完整输出**：用 `-v` / `--verbose` 提高详细度。

### 最佳实践
- **先安装再忘记** —— 装好钩子后正常使用即可
- **每周看 `rtk gain`** —— 了解节省情况
- **`rtk discover`** —— 发现可节省但未覆盖的命令
- **排除敏感命令** —— `~/.config/rtk/config.toml` 设置 `exclude_commands = ["curl", "playwright"]`

---

## 同类工具对比

| 工具 | 定位 | 节省方式 | 覆盖范围 | 易用性 |
|------|------|---------|---------|--------|
| **rtk** | CLI 输出过滤 | 智能压缩 | 100+ 命令，13 款 AI | 一键安装，零配置 |
| **Morph** | API 代理层 | 模型路由 + 上下文压缩 | 通用 API | 需改代码 |
| **LiteLLM** | LLM 网关 | 缓存 + 路由 + 监控 | 多模型 API | 需部署 |
| **LLMLingua** | 提示压缩 | 语义压缩 | 提示文本 | 需手动接入 |
| **ccusage** | 监控工具 | 无压缩 | Claude Code 专用 | 只看不省 |

rtk 的核心优势：**它工作在命令层，不需要改一行业务代码，不需要接入 API 网关，不需要学习新的抽象。**

---

## 总结：这是一个"不买就亏"的工具

2026 年的开发者工具市场，大家都在做加法——更强的模型、更多的功能、更炫的界面。rtk 罕见地做了一次减法：**把已经存在的东西，变得更轻、更省、更高效。**

它不替代你的 AI 工具，只是让它们的"伙食费"打八折甚至一折。它不改变你的工作流，只是默默把噪声滤掉。它不向你收钱（MIT 开源），却每个月帮你省下一笔真金白银。

```bash
# 30 秒，开始省钱
brew install rtk
rtk init -g
```

---

## 推荐 AI 编程主机

如果你需要远程持续运行 AI agent（CI runner / 自部署 Claude Code server / 远程 devbox），下面是我们常用的 VPS 提供商：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $5/月 droplet 撑得起单人 AI coding 工作流，新用户 $200 免费额度
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 / 新加坡 VPS，亚太地区低延迟，$4/月起步

完整的低成本 LLM 工作栈方案请看：[Cheap LLM Stack 合集](/zh/collections/cheap-llm-stack/)。

*本文包含联盟链接。如果你通过这些链接购买，我们可能获得佣金 —— 你付的价格不会变。*

---

## 延伸阅读

- [rtk GitHub 仓库](https://github.com/rtk-ai/rtk)
- [rtk 官方文档](https://rtk-ai.app/guide)
- [CC Switch — 多 AI CLI 统一管理工具](/zh/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)
- [Cheap LLM Stack 合集 — 完整的低成本方案](/zh/collections/cheap-llm-stack/)
- [n8n AI Workflow Automation](/zh/resources/llm-frameworks/n8n-ai-workflow-automation-self-hosted-2026/)

---

## FAQ

### rtk 会把我的代码发到第三方吗？
不会。rtk 是纯本地二进制，只在你的 shell 和 AI 工具的 context 之间做过滤。不联网。

### 如果 Claude Code / Cursor 升级了 rtk 会不会失效？
hook 机制相对稳定。rtk 自 0.10 起持续跟进 Claude Code 的 hook API。如有 breaking change，rtk 通常 24-48 小时内发版跟上。

### 我能在自研 AI agent 上用 rtk 吗？
可以 — rtk 提供 Python plugin 模式（Hermes 在用），可以适配自定义 agent。文档在 GitHub `/docs/plugins/`。

### 跟直接用 `--no-pager` 或 `--quiet` 有什么区别？
rtk 是命令感知的。`git --no-pager log` 还是产出冗长输出。rtk 的 `git log` 策略具体把它转成单行摘要 + 去重。"更少冗长" vs "结构化压缩" 是两回事。

### rtk 适合用在 production CI/CD 吗？
在 agent workflow 里安全。不要用在 `set -e` 严格依赖具体命令输出文本的 pipeline 里 — 但 AI agent 读输出做决策的 loop 里，rtk 的压缩版正是 agent 真正需要的。
