---
title: 'Bumblebee 2026：Perplexity AI 开源内部供应链扫描器，覆盖 MCP 配置与编辑器扩展'
description: 'Bumblebee 是 Perplexity AI 的开源只读供应链扫描器，检查 npm、PyPI、Go 模块、MCP 配置、编辑器扩展和浏览器扩展中的已知受损包——不会执行您代码的任何一行。'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Go', 'Security', 'CLI']
application_domain: Dev Utils
source_version: '0.1.1'
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: 'https://github.com/perplexityai/bumblebee'
backup_url: ''
github_repo: 'perplexityai/bumblebee'
stars: 1500
maintainer: 'perplexityai'
last_maintained: '2026-05-22'
featureImage: '/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['bumblebee', '供应链安全', 'MCP', 'security', 'Go', 'npm', 'PyPI', 'perplexity-ai']
aliases:
- /zh/posts/bumblebee-supply-chain-scanner-perplexity-2026/
faqs:
  - q: 'Bumblebee 是什么？它能扫描哪些内容？'
    a: 'Bumblebee 是 Perplexity AI 开源的只读开发者端点扫描器。它扫描 npm、pnpm、Yarn、Bun、PyPI、Go 模块、RubyGems、Composer、MCP 配置、编辑器扩展（VS Code、Cursor、Windsurf、Zed）和浏览器扩展的磁盘元数据。它永远不会执行安装脚本或调用包管理器——只读取磁盘上已有的内容。'
  - q: '为什么 AI 开发者需要特别关注 MCP 扫描？'
    a: 'MCP（模型上下文协议）服务器以较高权限运行在开发者机器上。受损的 MCP 包可能泄露数据或执行任意代码。Bumblebee 是首个公开扫描 MCP 配置文件（claude_desktop_config.json、mcp_settings.json 等）的工具，对使用 Claude Desktop、Cursor 或任何 MCP 工具的开发者来说至关重要。'
  - q: '三种扫描模式有什么区别？'
    a: 'baseline 模式扫描全局包、工具链、编辑器扩展和 MCP 配置，适合日常例行检查。project 模式在 baseline 基础上加入配置的开发目录（如 ~/code）。deep 模式扫描指定根目录（通常是整个 home 目录），专为发生安全事件时的彻查设计。'
  - q: '如何安装和使用 Bumblebee？'
    a: '运行 go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1 安装。日常检查运行 bumblebee scan --profile baseline > inventory.ndjson。针对特定漏洞快速排查运行 bumblebee scan --profile deep --root "$HOME" --exposure-catalog ./catalog.json --findings-only --max-duration 10m。'
---

![Bumblebee 2026: Perplexity AI 供应链扫描器 — dibi8.com](/images/articles/bumblebee-supply-chain-scanner-perplexity-2026/cover.jpg)

2026年5月22日，Perplexity AI 开源了 [Bumblebee](https://github.com/perplexityai/bumblebee)——这是他们安全团队内部用于审计开发者笔记本电脑供应链风险的工具。不到一周就获得了 1,500+ GitHub Star 和 112 个 Fork。核心问题只有一个：**当某个漏洞通报点名了受损的包、版本或扩展，你的机器上有没有它？**

## 为什么供应链攻击首先打开发者？

2024–2026 年的供应链事件（xz、polyfill.io、多个针对 AI 工具的恶意 npm 包）有一个共同模式：先落地在开发者的机器上，数月后才在生产环境造成危害。开发者笔记本是高价值目标，因为它存着 API 密钥、SSH 凭证、源代码，以及——越来越重要的——MCP 服务器配置，这些配置让 AI 模型有权访问文件、数据库和浏览器。

传统 SCA 工具（Snyk、Dependabot）检查代码声明的依赖。它们遗漏了：全局安装的 CLI、编辑器扩展、浏览器扩展、MCP 配置文件。Bumblebee 正是为填补这些空白而生。

## 只读保证

这个工具的核心约束是**永远不执行任何命令**。没有 `npm ls`，没有 `pip check`，没有 `go list`。供应链攻击越来越多地针对检查阶段本身——恶意的 `postinstall` 或投毒的元数据端点能把一次例行审计变成利用。Bumblebee 完全绕开这个风险，只读取磁盘上的元数据文件：`package.json`、`package-lock.json`、`go.sum`、`requirements.txt`、`Gemfile.lock`、扩展清单和 MCP 配置 JSON。

## 三种扫描模式

```bash
# 日常全局检查
bumblebee scan --profile baseline > inventory.ndjson

# 项目范围扫描
bumblebee scan --profile project --project-root ~/code

# 事件响应——全盘扫描
bumblebee scan --profile deep \
  --root "$HOME" \
  --exposure-catalog ./catalog.json \
  --findings-only \
  --max-duration 10m
```

## MCP 配置支持

这是 2026 年 AI 开发者最关心的特性。Bumblebee 扫描以下配置路径：

| 文件 | 工具 |
|------|------|
| `~/.claude.json` | Claude CLI |
| `claude_desktop_config.json` | Claude Desktop |
| `mcp_settings.json` | Cline / Roo Code |
| `.mcp.json` / `mcp.json` | 通用 MCP |
| `~/.gemini/settings.json` | Gemini CLI |

对每个 MCP 服务器条目，Bumblebee 记录包名、版本和来源注册表。执行暴露扫描时，MCP 包与普通依赖一并检查——目前没有其他工具做到这一点。

## 零依赖设计

Bumblebee 用 Go 1.25 编写，**不引入任何标准库以外的依赖**。最终产物是单个静态链接二进制，无 glibc 依赖，可通过 MDM 分发到整个开发者机队，无需管理运行时环境。

```bash
go install github.com/perplexityai/bumblebee/cmd/bumblebee@v0.1.1
```

## 关联工具

如果 Bumblebee 在 npm 包中发现问题，[socket.dev](https://socket.dev) 提供更深入的静态分析。Python 方面，[pip-audit](https://pypi.org/project/pip-audit/) 与 Bumblebee 互补——Bumblebee 找到包，pip-audit 解释漏洞。

> **部署安全的 AI 基础设施：** 如果你在 VPS 上运行 MCP 服务器，主机 OS 的加固是第一道防线。[$6/月的 DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0) 提供完整的 root 访问权，让你配置自己的防火墙和审计日志。新用户享有 **$200 免费额度**。

## 总结

如果你使用 Claude Desktop、Cursor 或任何 MCP 工具，定期运行 `bumblebee scan --profile baseline` 应该成为你的习惯。它是迄今为止唯一一个同时覆盖全局包、编辑器扩展和 MCP 配置的供应链扫描器。

**GitHub：** [perplexityai/bumblebee](https://github.com/perplexityai/bumblebee) · v0.1.1 · Apache-2.0
