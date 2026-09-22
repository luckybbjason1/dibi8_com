---
title: "ECC (affaan-m/ECC): 2026年最强Agent控制系统"
description: "ECC是拥有265K GitHub stars的agent harness性能优化系统。支持68个agents、286个skills、94个commands。集成AgentShield安全扫描。兼容Claude Code、Codex、Cursor、OpenCode等。"
date: 2026-09-22
lastmod: 2026-09-22
tags: [github, ecc, claude-code, coding-agent, performance]
category: github-tools
image: https://raw.githubusercontent.com/affaan-m/ECC/main/assets/hero.png
related_posts:
  - /zh/archify-diagrams
  - /zh/rag-systems-2026
  - /zh/ai-coding-agents-comparison
toc: true
---

## ECC是什么？

**ECC**（Agent Harness Performance Optimization System）由 `affaan-m` 开发，已获得 **265,039 stars**。这不仅仅是一套技能——它是你的编码agent的操作系统。

![ECC Hero Image](https://raw.githubusercontent.com/affaan-m/ECC/main/assets/hero.png)

> **快速总结：** ECC将AI编码agent从"代码编写工具"转变为"协同工程系统"——先规划再构建，测试后再验证，自动审查，持续学习。

## 为什么ECC特别？

### 1. 数据说明一切

| 组件 | 数量 |
|------|------|
| Agents | 68 |
| Skills | 286 |
| Commands | 94 |
| Hooks/Rules | 运行时支持 |
| AgentShield | 内置集成 |

### 2. 多平台支持

ECC不限于单一agent：

- ✅ **Claude Code** — 原生支持
- ✅ **OpenAI Codex** — 有同步路径
- ✅ **Cursor** — 本地适配器
- ✅ **OpenCode** — 完整插件
- ✅ **Gemini CLI** — 精简安装
- ✅ **Zed** — 本地适配器
- ✅ **Hermes** — 独立设置指南
- ✅ **其他**: Antigravity、Qwen、Kimi、CodeBuddy、JoyCode、GitHub Copilot

### 3. AgentShield — 自动安全检查

一个罕见的特性：**AgentShield** 自动扫描：
- 恶意prompts
- 危险的MCP配置
- 泄露的密钥
- 权限滥用

## 如何安装？

### 使用Claude Code

```bash
# 方法1：安装脚本
./install.sh --profile minimal --target claude

# 方法2：使用插件
claude plugin install ecc@ecc
```

### 使用Codex CLI

```bash
./install.sh --profile minimal --target codex
```

### 使用Cursor

```bash
./install.sh --profile minimal --target cursor
```

### 手动安装（跨平台）

```bash
npm install -g ecc-universal
npm install -g ecc-agentshield
```

## 可用的Agents

### 规划Agents
- `planner` — 分析需求，制定计划
- `tdd-workflow` — 测试先行强制流程
- `spec-analyzer` — 规格分析

### 安全Agents
- `security-reviewer` — 代码安全审查
- `dependency-auditor` — 依赖漏洞扫描
- `prompt-injection-detector` — 检测注入攻击

### 架构Agents
- `architecture-reviewer` — 系统架构审查
- `performance-analyst` — 性能分析与优化
- `code-reviewer` — 代码质量审查

### 领域Agents
- `database-reviewer` — 数据库查询审计
- `api-designer` — REST/GraphQL API设计
- `frontend-developer` — UI/UX实现

## 与 alternatives 比较

| 特性 | ECC | Ponytail | agent-skills |
|------|-----|----------|--------------|
| Agent数量 | 68 | 专注于简洁 | 20+ skills |
| 安全性 | 内置AgentShield | 无 | 基础 |
| 多平台 | 10+ agents | 聚焦Claude Code | 多种 |
| 学习系统 | 持续学习 | 静态规则 | 静态规则 |
| 价格 | 开源（MIT） | 开源 | 开源 |

## 为什么你应该使用ECC？

1. **先规划后编码** — 不再盲目写代码
2. **测试驱动开发** — 先写测试，再写代码
3. **安全优先** — AgentShield自动保护你
4. **持续学习** — 从每次会话中学习
5. **跨平台** — 兼容多种AI工具

## 结论

ECC不仅仅是一套技能——它是**你AI编码agent的操作系统**。凭借265K stars和快速增长的社区，ECC是开发者优化AI工作流的首选。

**链接：** [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC)
**文档：** [ecc.tools](https://ecc.tools)
