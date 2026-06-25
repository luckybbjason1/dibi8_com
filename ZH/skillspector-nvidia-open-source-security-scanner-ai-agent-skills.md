---
title: SkillSpector：NVIDIA 面向 AI Agent 技能的开源安全扫描工具
description: 一款专为 AI Agent 技能设计的安全扫描工具，在安装前即可检测漏洞、恶意模式和安全风险。获得 NVIDIA 社区 10K Star 关注。保护 Claude Code、Codex CLI 及其他 Agent 框架。
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: dev-utils
tags: ['security', 'ai-agents', 'scanner', 'vulnerability-detection', 'claude-code', 'codex', 'mcp', 'agent-skills', 'nvidia']
slug: skillspector-nvidia-open-source-security-scanner-ai-agent-skills
featureImage: /images/articles/skillspector-nvidias-open-source-security-scanner-for-ai-agent-skills.png
lang: zh
github_repo: https://github.com/NVIDIA/SkillSpector
license: Apache-2.0
---



# SkillSpector：NVIDIA 面向 AI Agent 技能的开源安全扫描工具

**SkillSpector** 是一款专为 AI Agent 技能设计的安全扫描工具——这些模块化插件和扩展程序为 Claude Code、GitHub Copilot、Codex CLI 和 Gemini CLI 等框架提供动力。该工具由 NVIDIA 开发，在 GitHub 上已获得 **10,273 个 Star**，旨在解决在生产环境中安装未经审核的 Agent 技能所带来的日益增长的安全隐患。

本文涵盖安装方法、扫描能力、漏洞检测、与 Agent 框架的集成，以及保护 AI Agent 生态系统的安全最佳实践。

## TL;DR

随着 AI Agent 技能越来越流行，安装未经审核的技能所带来的安全风险也在增加。SkillSpector 提供了针对 800 多种网络安全技能的自动扫描功能，能够在这些风险到达您的系统之前检测出漏洞、恶意模式和安全威胁。它支持所有主流 Agent 框架，并提供可操作的修复建议。

## 什么是 SkillSpector？

SkillSpector 源于一个关键的观察：随着 AI Agent 技能在开发者工作流中的普及，安全攻击面也在急剧扩大。与传统软件包需要经过严格的代码审查不同，许多 Agent 技能只是简单的文本文件（SKILL.md），用于指示大语言模型执行任意操作——包括执行 Shell 命令、访问 API 以及修改文件。

该工具提供：

- **AI Agent 技能文件的自动化漏洞扫描**
- **基于模式的恶意行为检测**，包括命令注入、数据外泄和权限提升
- **面向特定框架的分析**，支持 Claude Code、GitHub Copilot、Codex CLI 等
- **修复建议**，针对检测到的漏洞提供具体修复方案
- **CI/CD 集成**，支持在自动化流水线中进行安装前扫描

## 安装指南

### 前置条件

- **Python**：3.12+（异步扫描功能必需）
- **操作系统**：Linux、macOS 或 Windows WSL2
- **磁盘空间**：500MB（含扫描器及技能数据库）
- **网络**：需要下载技能数据库和更新

### 方式一：通过 Pip 安装

```bash
# 从 PyPI 安装 SkillSpector
pip install skillspector

# 验证安装
skillspector --version

# 下载最新的技能数据库
skillspector update-db
```

### 方式二：从源码安装

```bash
# 克隆仓库
git clone https://github.com/NVIDIA/SkillSpector.git
cd SkillSpector

# 创建虚拟环境
python -m venv .venv
source .venv/bin/activate

# 以开发模式安装
pip install -e .

# 初始化扫描器
skillspector init --download-database
```

### 方式三：Docker 部署

```bash
# 拉取官方镜像
docker pull nvcr.io/nvidia/skillspector:latest

# 运行扫描
docker run --rm \
  -v ${PWD}/skills:/app/skills \
  nvcr.io/nvidia/skillspector:latest \
  scan /app/skills

# 定期调度扫描
docker run -d \
  --name skillspector \
  -v ${PWD}/skills:/app/skills \
  -v ${PWD}/reports:/app/reports \
  nvcr.io/nvidia/skillspector:latest \
  daemon --interval 3600
```

## 扫描能力

### 漏洞检测类别

SkillSpector 检测多个类别的漏洞：

| 类别 | 描述 | 严重程度 |
|
加入社区: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

内部链接: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/zh/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/zh/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**披露声明**: 本文提及的工具可能存在联盟关系。我们不接受付费评测。所有观点均为我们自己独立撰写。
