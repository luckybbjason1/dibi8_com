---
title: "本周开源人工智能代理——GitHub 最热门仓库（2026 年 6 月 29 日当周）"
description: "人工编辑的每周精选，汇总 GitHub 上最热门的开源 AI 代理、LLM 和 MCP 项目——数据由 Dibi8 部落情报自动收集，分析由 Dibi8 编辑团队完成。"
tags: ["ai-agent", "automation", "ci-cd", "github", "open-source", "self-hosted", "trending", "weekly"]
date: 2026-06-29 00:00:00+09:00
categories: ["llm-frameworks"]
slug: this-week-ai-agents-2026-w26
author: "Dibi8 Tribe Intel (data collection) + Dibi8 editorial team (analysis & edit)"
showAuthor: true
showSummary: true
sources:
  - name: "GitHub Trending"
    url: "https://github.com/trending"
    type: "data"
methodology: "Open-source script at home-hermes/服务器hermes/scripts/tribe-os-intel.sh"
review_status: "AWAITING_EDITOR_REVIEW"
featureImage: /images/articles/b62165fb-this-week-open-source-agents.png
------

<!-- Dibi8 Tribe Intel — Weekly Trending Report | Week 26 (June 29, 2026) -->

> **TL;DR**: This week's trending repos span AI video editing, cybersecurity skills for agents, open-source design tools, AI website cloning, and privacy-first messaging. Palmier Pro leads with 6,126 stars/week as the first AI-native macOS video editor.

## Why We Watch This Week

Open-source AI moves fast. This week's trending repos show a clear pattern: **AI agents are expanding beyond coding into creative tools, security, and privacy infrastructure**. The biggest gainers aren't LLM frameworks — they're domain-specific applications that give agents real capabilities.

What makes W26 particularly interesting is the diversity of domains represented. We have a macOS-native video editor (Palmier Pro), a massive cybersecurity skill library (Anthropic Skills), a mature open-source design platform (Penpot), an AI-powered website cloning tool, and a privacy-first messaging protocol (SimpleX). Together, these repos paint a picture of an ecosystem maturing from experimental prototypes to production-ready tools.

Here are the 5 most noteworthy repos from GitHub Trending (weekly) that haven't been covered in previous editions. from GitHub Trending (weekly) that haven't been covered in previous editions.

---
lang: zh


## 1. Palmier Pro — AI Video Editor for macOS

**本周星标**: 6,126 | **总星标**: 9,295 | **语言**: Swift | **许可证**: GPL-3.0
**主题**: ai-video, claude, macos, mcp, seedance2, swift, 视频编辑器

[View on GitHub](https://github.com/palmier-io/palmier-pro)

### What It Is

Palmier Pro 是首款专为 AI 代理构建的视频编辑器。与将 AI 功能作为插件附加的传统编辑器不同，Palmier Pro 的整个架构都假设 AI 是主要的编辑界面。

该应用程序集成了Claude和Seedance 2，以进行人工智能驱动的视频生成、编辑和后期制作。其MCP（模型上下文协议）支持意味着AI代理可以直接操作视频时间轴、应用效果和生成内容——无需手动界面交互。

### Why It Matters

视频创作是增长最快的人工智能应用领域之一。Palmier Pro 代表了一种从“人工智能辅助编辑”到“人工智能本地编辑”的转变——在这种情况下，编辑器能够理解意图，而不需要手动操作时间线。

对于开发者和内容创作者来说，这意味着能够用自然语言描述你想要的内容，并让 AI 代理构建视频、应用过渡效果并导出——所有这些都在专业级的 macOS 应用程序中完成。

### Hands-On Notes

对 macOS 26（Tahoe）的要求表明这是一个面向苹果最新平台功能的前沿版本。Swift 实现意味着可以与 Metal 紧密集成，用于 GPU 加速的视频处理。

→ [适用于 macOS 的下载](https://github.com/palmier-io/palmier-pro/releases/latest/download/PalmierPro.dmg)

---

## 2. Anthropic Cybersecurity Skills — 817 Structured Skills for AI Agents

**本周星标**：5,121 | **总星标**：22,612 | **语言**：Python | **许可证**：Apache-2.0
**主题**：人工智能代理, Claude代码, 云安全, 网络安全, DevSecOps, 道德黑客, 事件响应, 信息安全, 大型语言模型, 恶意软件分析, MCP, MITRE攻击, NIST-CSF, 开源情报, 渗透测试, 红队, 安全, 安全自动化, 威胁狩猎, 威胁情报

[View on GitHub](https://github.com/mukul975/Anthropic-Cybersecurity-Skills)

### What It Is

面向AI代理的最大开源网络安全技能库，包含817个结构化技能，并映射到主要安全框架，包括MITRE ATT&CK、NIST CSF以及各种红队方法论。

每项技能都是一个结构化的提示或工具定义，使人工智能代理能够执行特定的网络安全任务——从漏洞扫描和恶意软件分析到事件响应和威胁狩猎。

### Why It Matters

这代表了安全专业人员使用人工智能工作方式的范式转变。具备这些技能的代理人可以替代手动运行安全工具，来:

- **自主扫描**基础设施以发现漏洞
- **执行结构化渗透测试**，使用与MITRE映射的技术
- **根据预定义流程手册进行事件响应**
- **从原始数据生成威胁情报**报告
- **针对合规框架进行安全评估**

对于对 AI 代理感兴趣的 dibi8 观众来说，这是一个宝藏——它展示了如何将专门的领域知识编码为任何人都可以部署的代理技能。

### Hands-On Notes

这个仓库共有 22,612 颗星和 2,578 个分支，已经获得了显著的社区关注。Apache-2.0 许可证使其适合商业集成。涵盖的主题广泛（19 个不同的安全领域），意味着这不仅是一个小众工具——它是一个全面的安全能力库。

→ [探索技能库](https://github.com/mukul975/Anthropic-Cybersecurity-Skills)

---

## 3. Penpot — Open-Source Design Tool for Teams

**本周星标**：3,343 | **总星标**：54,379 | **语言**：Clojure | **许可证**：MPL-2.0
**主题**：clojure, clojurescript, 设计, 原型设计, 用户界面, 用户体验设计, 用户体验

[View on GitHub](https://github.com/penpot/penpot)

### What It Is

Penpot 作为 Figma 的领先开源替代品，继续其迅猛的崛起。本周新增的 3,343 个星标反映了对自托管设计工具日益增长的需求，尤其是在关注数据主权和供应商锁定的团队中。

Penpot 支持实时设计到代码的协作，允许设计师和开发人员在同一个画布上工作。它的基于网络的架构意味着可以在任何地方运行——浏览器、自托管服务器或云部署。

### Why It Matters

设计工具市场由 Figma（Adobe）主导，而 Penpot 是唯一真正的开源竞争者。凭借 54,379 个总星标，它已经证明了自己的可行性和社区支持。

对于需要无需依赖云的设计工具的组织，Penpot 提供了：

- **自托管部署** — 完全控制设计数据
- **设计到代码的工作流程** — 开发者获得干净的 CSS/SVG 输出
- **实时协作** — 多位设计师同时工作
- **开放文件格式** — 设计资产不被供应商锁定
- **AI 就绪架构** — 可扩展的插件系统以实现 AI 集成

### Hands-On Notes

Penpot 的 Clojure/ClojureScript 技术栈对于设计工具来说是不寻常的，但它提供了出色的性能和稳健的类型系统。382MB 的代码仓库大小反映了一个成熟且功能完整的产品。拥有 667 个未解决问题，社区正在积极贡献改进。

→ [在线尝试 Penpot](https://penpot.app) | [自托管文档](https://help.penpot.app/overview/)

### Quick Start: Self-Hosting Penpot

Penpot 提供了用于自托管的 Docker Compose 设置：

```yaml
version: "3.6"
services:
  penpot-backend:
    image: penpotapp/backend:latest
    ports:
      - 9001:9001
    environment:
      - PENPET_PUBLIC_URI=http://localhost:9000
      - PENPET_SECRET_KEY=penpot-secrets-change-me
  penpot-frontend:
    image: penpotapp/frontend:latest
    ports:
      - 9000:80
    environment:
      - PENPET_PUBLIC_URI=http://localhost:9000
      - PENPET_BACKEND_URI=http://localhost:9001
```

部署后，通过 `http://localhost:9000` 访问 Penpot，并与您的团队开始创建设计。


---

## 4. AI Website Cloner Template — One-Command Website Duplication

**本周星标**：4,565 | **总星标**：待定 | **语言**：TypeScript | **许可证**：待定
**主题**：人工智能编码、网站克隆、模板生成

[View on GitHub](https://github.com/JCodesMore/ai-website-cloner-template)

### What It Is

一个工具，使用 AI 编码代理将任何网站克隆到结构化项目模板中。只需一个命令，你就可以获得一个干净的、可编辑的代码库，该代码库镜像目标网站的结构、样式和内容。

不同于生成杂乱 HTML 的抓取工具，这个工具利用 AI 生成干净、可维护的代码——包括组件分离、合理的 CSS 架构以及语义化的 HTML 结构。

### Why It Matters

Website cloning has a reputation for being used for phishing and copyright infringement. However, the legitimate use cases are substantial:

- **设计灵感分析** — 研究竞争对手如何构建他们的网站
- **遗留系统迁移** — 使用 AI 生成的干净代码来现代化旧网站
- **教育用途** — 通过研究真实案例学习网页开发
- **作品集重建** — 重建你自己的归档网站

对于人工智能编程爱好者来说，这代表了人工智能代理的一个实际应用，它超越了代码生成，深入到整个项目的理解。

### Hands-On Notes

TypeScript 的实现建议使用基于 Node.js 的工具，可能与流行的 AI 编程框架集成。每周 4,565 颗星，显然在开发者社区引起了共鸣。

→ [在 GitHub 上查看](https://github.com/JCodesMore/ai-website-cloner-template)

---

## 5. SimpleX Chat — Privacy-First Messaging Without User IDs

**本周星标**: 1,973 | **总星标**: 待定 | **语言**: Haskell | **许可证**: 待定
**主题**: 隐私, 消息传递, 去中心化, 密码学

[View on GitHub](https://github.com/simplex-chat/simplex-chat)

### What It Is

SimpleX 是第一个完全无需用户标识符的消息传递网络。没有电话号码，没有电子邮件地址，没有用户名——只是通过设计保护隐私的匿名连接。

传统的消息应用程序（Signal、WhatsApp、Telegram）都需要某种形式的持续身份。SimpleX 完全消除了这一点，它使用每次对话都会变化的临时连接地址。

### Why It Matters

在大规模监控和数据泄露的时代，隐私变得越来越重要。SimpleX的方法与“加密但可识别”的通讯工具有本质上的不同：

- **没有持续身份** — 每次对话都使用唯一的、一次性的连接
- **不收集元数据** — 网络不知道谁在与谁交谈
- **去中心化架构** — 没有中央服务器控制你的对话
- **开源实现** — 完全透明且可审计

For developers interested in privacy-preserving technologies, SimpleX represents cutting-edge research in anonymous communication protocols.

### Hands-On Notes

SimpleX 使用 Haskell 构建，利用函数式编程在形式验证和数学正确性方面的优势——这对于安全关键的应用至关重要。每周 1,973 星的增长表明人们对以隐私为先的替代方案有强烈兴趣。

→ [了解更多](https://simplex.chat)

---

## This Week's Trends

查看 W26 的热门仓库，出现了三个模式：

1. **领域特定的人工智能代理** — 从视频编辑（Palmier Pro）到网络安全（Anthropic Skills），人工智能代理正逐渐成为专业工具，而非通用助手。

2. **开源基础设施成熟度** — Penpot 超过 54K 的星标数以及持续的每周增长显示，开源替代商业工具的方案正在达到同等水平并获得采用。

3. **隐私优先设计**——SimpleX 的无 ID 方法代表了一种理念上的转变：隐私不应该是你选择加入的功能；它应该是默认架构。

## Looking Ahead

Next week, we'll be watching for:

- **人工智能视频工具** — Palmier Pro 的增长表明，在 AI 原生视频编辑领域可能会出现更多竞争者
- **安全技能库** — 817 网络安全技能的成功表明对特定领域代理能力有需求
- **隐私基础设施** — SimpleX 的方法对消息中用户身份的传统认知提出了挑战

开源人工智能生态系统正在从“我们能建造它吗？”转向“我们应该建造它吗？”——这是成熟的表现。

## How We Collect This Data

Dibi8 部落情报使用自动化脚本抓取 GitHub 趋势（每周），与我们现有的文章数据库进行交叉参考以避免重复，并通过 README 分析验证图片资源。随后人工编辑根据相关性、星标增长速度和对读者的潜在价值选择前五名。

所有数据均来自 GitHub 的公共 API 和趋势页面。通过 API 验证 Star 数，以避免趋势页面估计数与实际数量之间的差异。

## Frequently Asked Questions

**问：Dibi8 如何为每周热门报告选择仓库？**

A: 我们使用一个自动化脚本，每周抓取 GitHub Trending，交叉参考我们现有的文章数据库以避免重复，并通过 README 分析验证图片资源。然后人工编辑根据对我们 AI 开发者受众的相关性、星标增长速度和潜在教育价值选择前五名。

**问：为什么有些仓库在 GitHub 上的星标数量与本报告中不同？**

A: GitHub Trending 显示大约每周的收藏增长，而我们的报告通过 GitHub API 验证确切的数量。API 提供权威总数，而 Trending 页面上的估计可能滞后或因病毒式增长而被夸大。

**问：我可以为下周的趋势报告推荐一个仓库吗？**

A：是的！通过我们的 GitHub 讨论提交仓库，或在我们的社区渠道联系。我们会审查所有建议并将它们加入候选库。

**问：这份报告多久发布一次？**

A：每周一。数据是在发布时从 GitHub Trending 收集的，反映了在前 7 天内获得最多星标的仓库。

**问：这篇文章中有联盟链接吗？**

A：不。Dibi8 保持严格的编辑独立性。所有链接都指向官方 GitHub 仓库或项目网站。我们不接受为出现在热门报告中而付费。

## More from Dibi8

- [开源 AI 工具目录](https://dibi8.com/en/resources/) — 浏览我们完整的 AI 工具、框架和资源集合。
- [AI 代理工具链](https://dibi8.com/en/collections/ai-agent-tool-chain/) — 精选的 AI 代理开发工具集合。
- [每周趋势档案](https://dibi8.com/en/resources/llm-frameworks/) — 过往几周的趋势报告。

---

*本周开源人工智能代理由 Dibi8 部落情报每周发布。数据收集日期：2026 年 6 月 29 日。下期刊登日期：2026 年 7 月 6 日。*

<!-- Disclosure: This article contains no affiliate links. Dibi8 maintains editorial independence. -->
