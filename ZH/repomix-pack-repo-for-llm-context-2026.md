---
title: 'repomix 2026：一条命令把整个代码库打包成 LLM 可用的单文件'
description: 'repomix（前身 repopack）将 Git 仓库整体打包为结构化纯文本，适配 Claude、ChatGPT、Gemini 的上下文窗口。14k+ Star，零配置，npx 秒跑。'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: ['Node.js', 'TypeScript', 'CLI']
application_domain: Dev Utils
source_version: 'v0.3'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/yamadashy/repomix'
backup_url: ''
github_repo: 'yamadashy/repomix'
stars: 14200
maintainer: 'yamadashy'
last_maintained: '2026-06-01'
featureImage: '/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg'
draft: false
categories: ['dev-utils']
tags: ['repomix', 'repopack', 'AI编程', 'LLM上下文', '代码库打包', 'Claude', 'ChatGPT', '开发者工具', '开源']
aliases:
- /zh/posts/repomix-pack-repo-for-llm-context-2026/
faqs:
  - q: 'repomix 是什么，前身叫什么？'
    a: 'repomix（前身 repopack）是开源 CLI 工具，把整个 Git 仓库打包为单一结构化文本，适配 LLM 上下文窗口。2025 年因与 npm repack 命令重名而更名为 repomix。由 yamadashy 开发，MIT 协议。'
  - q: 'repomix 支持哪些输出格式？'
    a: 'repomix 支持三种输出格式：纯文本（默认，适合 ChatGPT 等通用 LLM）、XML（适合 Claude，Claude 原生使用 XML）、Markdown（适合文档工作流和 GitHub Copilot）。用 --style plain|xml|markdown 切换。'
  - q: 'repomix 能处理多大的代码库？'
    a: 'repomix 对约 10 万–20 万 token（大约 5000–10000 个文件）以内的项目效果最佳。更大的仓库建议用 --include 模式只打包相关子系统，减少 token 消耗。'
---

![repomix 2026: 代码库打包为 LLM 上下文 — dibi8.com](/images/articles/repomix-pack-repo-for-llm-context-2026/cover.jpg)

当你让 Claude 或 ChatGPT 调试跨文件 bug 时，一段一段粘贴代码很快就会失去上下文。[repomix](https://github.com/yamadashy/repomix) 的解决方案是：把整个代码库打包成一个结构化文件，几秒内放入任意 LLM 的上下文窗口。

## repomix 做了什么

repomix 扫描仓库，排除 `.gitignore` 中的文件，输出包含以下内容的单一文本：

1. **仓库摘要** — 文件数、token 估算、语言分布
2. **目录树** — 完整文件夹结构
3. **所有源文件** — 每个文件前加路径标题和可选行号

输出结果可直接用于 Claude、ChatGPT、Gemini、Cursor，或任何接受文件上传的 LLM。

## 零配置快速开始

```bash
# 无需安装，用 npx 直接运行
npx repomix

# 全局安装
npm install -g repomix

# 打包指定目录
repomix ./src

# 直接打包远程 GitHub 仓库（无需 git clone）
npx repomix --remote https://github.com/user/repo
```

## 输出格式

| 格式 | 参数 | 最适合 |
|------|------|--------|
| 纯文本 | `--style plain`（默认）| ChatGPT、通用 LLM |
| XML | `--style xml` | Claude（原生 XML）、结构化解析 |
| Markdown | `--style markdown` | Copilot、文档工作流 |

## 过滤输出（大项目用）

```bash
# 只包含 src/ 下的 TypeScript 文件
repomix --include "src/**/*.ts"

# 排除测试和构建产物
repomix --ignore "**/*.test.ts,dist/**"

# 显示行号（方便 LLM 给出精确编辑位置）
repomix --output-show-line-numbers
```

## 典型工作流

```bash
# 全仓库 code review
repomix --style xml --output review.xml
# → 上传到 Claude Project
# → "请帮我审查这段代码的安全问题和架构设计"

# 远程仓库分析（无需 clone）
npx repomix --remote https://github.com/some-org/some-project
# → "总结这个项目的架构，用了哪些设计模式？"
```

## 安全提示：`.repomixignore`

repomix 默认遵守 `.gitignore`，但未被 gitignore 的敏感文件（如本地 `.env`）可能进入输出。在项目根目录创建 `.repomixignore` 显式排除：

```
.env
.env.local
config/credentials.json
```

> **需要服务器来构建 AI 开发工具？** [DigitalOcean 新用户享 $200 免费额度](https://m.do.co/c/eca87ac14ee0)，足够运行开发服务器或部署 AI 辅助代码库。

**GitHub：** [yamadashy/repomix](https://github.com/yamadashy/repomix) · 14.2k ⭐ · MIT
