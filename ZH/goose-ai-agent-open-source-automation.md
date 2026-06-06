---
title: "Goose AI Agent：44K⭐Open Source神器，让 AI 替你写代码、做研究、自动化一切"
description: "Goose 是 Linux 基金会支持的Open Source AI Agent，44K+ Stars，支持 15+ LLM 提供商和 70+ MCP 扩展。桌面应用 + CLI + API 三位一体，用 Rust 构建，性能卓越。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
  - Rust
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "956.2 MB"
file_md5: ""
download_url: "https://github.com/aaif-goose/goose"
backup_url: ""
github_repo: "https://github.com/aaif-goose/goose"
stars: 45476
maintainer: "aaif-goose"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
faqs:
  - q: 'Goose AI agent 是什么？'
    a: 'Goose 是一款通用型开源 AI agent，最初由 Block 开发，后捐赠给 Linux Foundation 旗下的 Agentic AI Foundation (AAIF)。与专门的编程助手不同，它可以处理任何任务，包括编写代码、分析数据、管理文件、运行终端命令以及自动化工作流。'
  - q: 'Goose 支持哪些 LLM 提供商？'
    a: 'Goose 不依赖特定模型，支持 OpenAI GPT-4 和 GPT-3.5、Anthropic Claude、Google Gemini、通过 Ollama 运行的本地模型，以及任何兼容 OpenAI 的 API。'
  - q: '我该如何安装 Goose？'
    a: '在 macOS 上，运行 ''brew install goose''。在 Linux 上，使用 ''curl -fsSL https://github.com/block/goose/releases/latest/download/install.sh | bash'' 从官方 GitHub releases 运行安装脚本。安装完成后，运行 ''goose configure'' 设置你的 API key，再运行 ''goose session'' 启动。'
  - q: 'Goose 是开源的吗？它使用什么许可证？'
    a: '是的，Goose 是开源的，托管在 GitHub 上 github.com/block/goose，拥有 44K+ stars。它基于 Apache 2.0 license 发布。'
  - q: 'Goose 包含哪些安全特性？'
    a: 'Goose 包含一个在执行危险命令前会先询问的审批模式（approval mode），一个在隔离环境中运行命令的沙箱模式（sandbox mode），一个用于追踪所有操作的审计日志（audit log），以及防止 API 滥用的速率限制（rate limiting）。'
---
{</* resource-info */>}

## Goose 是什么？

**Goose** 是一个通用型Open Source AI Agent，由 **Linux 基金会 Agentic AI Foundation (AAIF)** 支持开发。它不是简单的代码补全工具，而是一个能真正**替你执行任务**的 AI 助手。

- 🖥️ **桌面应用** — macOS、Linux、Windows 原生应用
- 💻 **CLI 工具** — 终端工作流，极客最爱
- 🔌 **API 接口** — 嵌入任何应用
- ⚡ **Rust 构建** — 性能卓越，资源占用低

GitHub: https://github.com/aaif-goose/goose  
Stars: **44,261+** | 语言: Rust | 协议: Apache-2.0

---

## 为什么 Goose 与众不同？

### 1. 不只是代码，是一切

Goose 的定位是**通用 AI Agent**，不限于编程：

| 场景 | 能力 |
|------|------|
| 编程开发 | 写代码、调试、测试、重构 |
| 数据分析 | 处理 CSV、生成图表、写报告 |
| 内容创作 | 写文章、翻译、润色 |
| 系统管理 | 执行命令、配置环境、部署服务 |
| 研究调研 | 搜索信息、总结文献、对比分析 |

### 2. 15+ LLM 提供商支持

Goose 不绑定任何一家 AI 公司：

- **Anthropic** (Claude)
- **OpenAI** (GPT-4o)
- **Google** (Gemini)
- **Ollama** (本地模型)
- **OpenRouter** (聚合 API)
- **Azure**、**AWS Bedrock** 等

你可以用 API Key，也可以用现有的 Claude、ChatGPT 订阅（通过 ACP 协议）。

### 3. 70+ MCP 扩展生态

通过 **Model Context Protocol (MCP)** 开放标准，Goose 可以连接：

- 🌐 浏览器控制
- 📁 文件系统操作
- 🗄️ 数据库查询
- 🔍 搜索引擎
- 📧 邮件发送
- 🐙 GitHub 操作
- 📊 数据分析工具
- 以及更多...

---

## 安装与使用

### 桌面应用（推荐）

```bash
# macOS (Homebrew)
brew install goose

# 或直接下载
# https://goose-docs.ai/docs/getting-started/installation
```

### CLI 安装

```bash
# 使用 install script
curl -fsSL https:// goose-docs.ai/install.sh | bash

# 或使用 cargo
cargo install goose-cli
```

### 首次配置

```bash
# 设置 LLM 提供商
goose configure

# 选择 provider: openai / anthropic / ollama 等
# 输入 API Key
# 完成！
```

### 基本使用

```bash
# 启动交互式会话
goose session

# 执行单次任务
goose run "帮我写一个 Python 爬虫，抓取 GitHub Trending"

# 使用特定扩展
goose run --extension browser "搜索最新的 AI 工具"
```

---

## 实战场景

### 场景 1：自动代码审查

```bash
goose run "审查这个 PR 的代码质量，找出潜在 bug 和性能问题"
```

Goose 会：
1. 读取 PR 的 diff
2. 分析代码逻辑
3. 找出潜在问题
4. 生成审查报告

### 场景 2：数据分析报告

```bash
goose run "分析 sales_data.csv，生成月度销售趋势图表"
```

Goose 会：
1. 读取 CSV 文件
2. 用 Python/pandas 处理数据
3. 生成 matplotlib 图表
4. 输出分析报告

### 场景 3：自动化部署

```bash
goose run "部署这个应用到 AWS，配置负载均衡和自动扩缩容"
```

Goose 会：
1. 读取项目配置
2. 生成 Terraform/CloudFormation 配置
3. 执行部署命令
4. 验证部署状态

---

## 与竞品对比

| 特性 | Goose | Claude Code | Cursor | GitHub Copilot |
|------|-------|-------------|--------|----------------|
| Open Source | ✅ | ❌ | ❌ | ❌ |
| 免费 | ✅ | 需 API | 付费 | 付费 |
| 多 LLM | ✅ 15+ | Claude only | 有限 | 有限 |
| MCP 扩展 | ✅ 70+ | 有限 | 有限 | ❌ |
| 桌面应用 | ✅ | ❌ | ✅ | ❌ |
| CLI | ✅ | ✅ | ❌ | ❌ |
| API | ✅ | ❌ | ❌ | ✅ |
| 通用任务 | ✅ | 代码为主 | 代码为主 | 代码为主 |

**Goose 的优势**：Open Source免费、多提供商、可扩展、通用型。

---

## 商业模式与赚钱机会

### 1. 企业级部署

Goose 的 Apache-2.0 协议允许商业使用：
- 内部 AI 工作流平台
- 自动化运维工具
- 智能客服系统

### 2. MCP 扩展开发

开发 Goose 的 MCP 扩展并销售：
- 企业系统集成
- 行业特定工具
- 自动化工作流

### 3. AI Agent 咨询

基于 Goose 提供：
- AI 自动化咨询
- 定制开发服务
- 培训与实施

---

## 社区与生态

- **Discord**: https://discord.gg/goose-oss
- **文档**: https://goose-docs.ai/
- **Linux Foundation**: https://aaif.io/
- **贡献者**: 4,500+ Forks，活跃社区

---

## 总结

Goose 是 2026 年最值得关注的Open Source AI Agent：

✅ **44K+ Stars** — 社区认可度高  
✅ **Linux 基金会** — 长期发展有保障  
✅ **15+ LLM** — 不绑定单一供应商  
✅ **70+ MCP** — 无限扩展可能  
✅ **Rust 构建** — 性能卓越  
✅ **Apache-2.0** — 商业友好  

**适合谁？**
- 开发者：自动化编码任务
- 数据分析师：自动化报告生成
- 运维工程师：自动化部署监控
- 创业者：构建 AI 驱动的产品

**立即开始**：https://goose-docs.ai/docs/getting-started/installation

---

## Related Articles

- [Free Claude Code: Use Claude Code CLI for Free with Any AI Provider](/zh/resources/ai-tools/free-claude-code-open-source-proxy/) — 另一个免费 AI 编码工具
- [Polymarket Agents: Build AI Trading Bots for Prediction Markets](/zh/resources/llm-frameworks/polymarket-agents-ai-trading-bot-framework/) — AI 代理在交易领域的应用
- [Agent Reach: Connect Your AI Agent to the Internet](/zh/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — 让 AI Agent 连接互联网
- [42 Real-World OpenClaw Use Cases](/zh/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) — AI 代理真实用例

---


---

## 推荐自托管基础设施

要 7×24 稳定跑这套，服务器选择很关键：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心。开源 AI 工具自托管首选。
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 香港 VPS，国内访问低延迟。**这就是 dibi8.com 自家所在的 IDC**，生产环境已验证。

*以上为推广链接，不会增加你的成本，但能支持 dibi8.com 持续运营。*

*Last updated: 2026-05-07*
