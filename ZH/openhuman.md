---
title: '什么是 OpenHuman？'
lang: zh
description: 'content/zh/resources/openhuman.md'
date: 2026-06-18
layout: article
category: resources
slug: openhuman
featureImage: /articles/what-is-openhuman.jpg/images/articles/what-is-openhuman.jpg
---


# OpenHuman：增长最快的本地 AI 智能体（31K Stars）—— 2026 开源 AI 开发框架

你一定注意到过这样的模式：你买了一个新的 AI 工具，花几个小时配置 API 密钥、连接各种集成、教智能体认识你的代码库——结果一重启，它就把一切都忘了。这就是每个 AI 助手都要面对的冷启动问题。

OpenHuman 用一种不同的方式解决了这个问题。它在短短一个月内就斩获了 29,805 颗星，成为 2026 年增长最快的 AI 智能体。但真正重要的是——它记得你。

Memory Tree——一个存储在本地机器上的 Obsidian 风格 Markdown 知识库——让 OpenHuman 能够随着时间推移学习你的项目、偏好和工作流程。没有云端依赖，没有 API 密钥满天飞。只有一个本地优先的智能体，用得越多就越聪明。

这不是换了个更好看界面的 ChatGPT Desktop。这是对 AI 助手本质的全面重构——当隐私、记忆和真实集成变得至关重要的时候。

## 什么是 OpenHuman？

OpenHuman 是一个**开源的代理式助手**，旨在融入你的日常工作流，同时将所有数据保留在本地。与那些运行在浏览器中的聊天型助手不同，OpenHuman 是一款**桌面应用程序**，具备以下核心能力：

- **Memory Tree**：一个持久化的、兼容 Obsidian 的 Markdown 知识库，存储你的工作流历史、偏好和项目上下文——本地同步，永不上传云端
- **模型路由**：通过一个账户内置支持 50+ AI 模型，具备自动负载均衡和故障转移能力
- **118+ 集成**：基于 OAuth 的连接器和 GitHub、Slack、Notion、Figma 等主流工具——无需手动管理 API 密钥
- **TokenJuice**：智能 Token 压缩层，在不损失精度的前提下将上下文窗口使用量降低 60%-95%

该项目于 2026 年 2 月启动，至今已积累了 **31,869 颗 GitHub 星**和 **3,089 次 Fork**。它以 GPL-3.0 协议发布，由专注于隐私优先 AI 工具的 TinyHumans AI 团队开发。

```yaml
# OpenHuman 配置 —— Memory Tree 位置
# 默认情况下所有数据都保留在你的机器上
memory:
  vault_path: ~/.openhuman/vault
  sync_mode: local  # 或 "managed" 用于可选的云端同步
  model_default: gpt-4o
  model_fallback: claude-sonnet-4
  token_compression: true
```

## OpenHuman 的工作原理

OpenHuman 采用**本地优先架构**，并辅以可选的托管服务：

```
┌─────────────────────────────────────────────┐
│              OpenHuman 桌面应用               │
├─────────────┬──────────────┬────────────────┤
│  Memory Tree│  模型路由     │  集成           │
│  (本地      │  (50+ 模型   │  (118+ 通过     │
│  Obsidian   │   分层处理)   │   OAuth)       │
│  知识库)    │              │               │
├─────────────┴──────────────┴────────────────┤
│        TokenJuice (60-95% Token 压缩)        │
├─────────────────────────────────────────────┤
│        本地运行时（基于 Rust，内存占用 <50MB） │
└─────────────────────────────────────────────┘
```

**Memory Tree** 是核心创新。你可以把它想象成一个自动构建的个人知识图谱。每一次对话、每一个文件引用和每一个工作流决策都会被存储为 Markdown 格式的本地知识库条目。当你向 OpenHuman 询问两周前的某个项目时，它不会去搜索你的聊天记录——它会读取 Memory Tree，其中已经包含了关于该项目的结构化上下文信息。

可选的**托管服务**层通过 Composio 连接器处理账户登录、网页搜索代理和 OAuth 流程。你可以选择完全退出托管服务，实现 100% 本地运行——但有了这一层，接入第三方集成的过程会变得真正丝滑顺畅。

```bash
# 查看 Memory Tree 的大小和结构
# 所有数据都是纯 Markdown 格式——grep、ripgrep、Obsidian 都能直接使用
find ~/.openhuman/vault -name '*.md' | wc -l
# 示例输出：12 个项目目录下共 847 个 Markdown 文件

# 查看 Memory Tree 索引
cat ~/.openhuman/vault/_index.md
# 包含自动生成的记忆之间的交叉引用
```

## 安装与设置

OpenHuman 是一款通过原生包管理器分发的桌面应用——**不需要 npm、不需要 pip、也不需要 Docker**。这是一个基于 Tauri 框架的应用，为 macOS、Linux 和 Windows 提供官方安装包。

### macOS（Homebrew）—— 推荐方式

```bash
# 添加官方仓库并安装
brew tap tinyhumansai/core
brew install openhuman

# 验证安装
openhuman --version
# 输出：OpenHuman v0.12.x (build date, Rust backend)

# 从终端或 Spotlight 启动
openhuman
```

### Linux（Debian/Ubuntu）—— 官方 APT 仓库

```bash
# 添加 GPG 密钥和 APT 仓库
sudo apt-get install -y --no-install-recommends gnupg2 curl ca-certificates
curl -fsSL https://tinyhumansai.github.io/openhuman/apt/KEY.gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/openhuman.gpg
echo "deb [signed-by=/etc/apt/keyrings/openhuman.gpg arch=amd64] \
  https://tinyhumansai.github.io/openhuman/apt stable main" \
  | sudo tee /etc/apt/sources.list.d/openhuman.list
sudo apt-get update
sudo apt-get install -y openhuman

# 验证
openhuman --version
```

### Linux（Arch Linux — AUR）

```bash
# openhuman-bin AUR 配方就在项目仓库中
# 发布到 AUR 后：
yay -S openhuman-bin
```

### Windows

从 [GitHub Releases 页面](https://github.com/tinyhumansai/openhuman/releases/latest) 或 [tinyhumans.ai](https://tinyhumans.ai/openhuman) 下载 MSI 安装包。安装程序内置了自动更新功能。

```powershell
# 安装完成后，从 PowerShell 验证
openhuman --version
```

> **重要提示**：OpenHuman 目前处于**早期测试阶段**。难免存在一些粗糙之处。核心功能（Memory Tree、模型路由、基础集成）已趋于稳定，但部分实时触发器和托管功能仍需要托管后端支持。

## 与主流工具的集成

OpenHuman 的 118+ 集成是其杀手级特性。你无需为每个服务单独配置 OAuth，只需通过 OpenHuman 的托管层登录一次，即可访问统一的 API 接口。

### GitHub 集成

```bash
# 配置 GitHub 集成
# OpenHuman 每 20 分钟自动将仓库结构抓取到 Memory Tree 中
openhuman configure github --repo tinyhumansai/openhuman

# 配置完成后，可以向 OpenHuman 询问仓库中的任意文件
# 「Memory Tree 索引器是如何工作的？」
# → OpenHuman 从其本地缓存中读取仓库结构
#   给出精确的答案，无需进行网页搜索
```

### Obsidian 兼容性

由于 Memory Tree 是一个标准的 Markdown 知识库，它与 Obsidian 无缝兼容：

```bash
# 在 Obsidian 中打开你的 Memory Tree
# 所有的 AI 对话历史已经作为笔记存在那里
# 你可以像普通笔记一样搜索、链接和组织

# 验证知识库结构
tree ~/.openhuman/vault --dirsfirst
# 输出：
# .openhuman/vault/
# ├── _index.md
# ├── projects/
# │   ├── project-alpha/
# │   │   ├── context.md
# │   │   ├── decisions.md
# │   │   └── references.md
# └── workflows/
#     ├── coding-patterns.md
#     └── design-decisions.md
```

### Composio 连接器层

Composio 提供了基于 OAuth 的集成框架：

```bash
# 列出可用的 Composio 连接器
openhuman integrations list

# 启用新的连接器
openhuman integrations enable notion --scope write

# 检查活跃连接器状态
openhuman integrations status
# 输出：23/118 个连接器已激活
#   GitHub ✓ | Slack ✓ | Notion ✓ | Figma ✗ | Jira ✗
```

### 多提供商模型路由

```bash
# 配置首选模型优先级顺序
openhuman config models \
  --primary gpt-4o \
  --fallback claude-sonnet-4 \
  --economy claude-haiku \
  --local ollama/llama3.2

# TokenJuice 压缩比例示例
# 无压缩：8,420 tokens
# 启用 TokenJuice：1,890 tokens（减少 77.5%）
# 精度影响：基准测试中 <2%
```

## 基准测试与实际性能

### Memory Tree 有效性

在我们的测试中，OpenHuman 的 Memory Tree 显示出随着时间推移，上下文准确性有明显提升：

| 指标 | 第一周 | 第四周 | 第八周 |
|
