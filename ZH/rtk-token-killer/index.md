---
title: "RTK（rtk-ai/rtk）：减少AI编码90% Token成本"
description: "RTK是用Rust编写的CLI代理，可将agent读取终端输出时的token消耗减少60-90%。支持100+命令，<10ms延迟。获得81K GitHub stars。"
date: 2026-09-22
lastmod: 2026-09-22
tags: [github, rtk, token-optimization, claude-code, cost-reduction]
category: github-tools
image: https://raw.githubusercontent.com/rtk-ai/rtk/main/assets/hero.png
related_posts:
  - /zh/ecc-agent-harness
  - /zh/mattpocock-skills
  - /zh/rag-systems-2026
toc: true
---

## Token成本问题

当你使用AI编码agent（Claude Code、Codex、Cursor）时，你需要为每个输入token付费。一条 `git log` 或 `ls -la` 命令可能输出数千行，每行都花钱。

**RTK解决这个问题。**

![RTK Hero](https://raw.githubusercontent.com/rtk-ai/rtk/main/assets/hero.png)

> **总结：** RTK在将CLI输出发送给LLM之前进行过滤和压缩。减少60-90% token使用，不丢失关键信息。

## RTK如何工作？

### 工作机制

```
你运行：git status
↓
RTK拦截并过滤输出
↓
Agent收到压缩版本（小90%）
↓
成本降低，context窗口得以保留
```

### 支持的命令（100+）

**Git操作：**
- `rtk git status`、`rtk git log`、`rtk git diff`
- `rtk gh pr list`、`rtk gh issue view`

**文件操作：**
- `rtk find`、`rtk grep`、`rtk rg`
- `rtk cat`、`rtk head`、`rtk tail`

**包管理：**
- `rtk npm list`、`rtk yarn why`
- `rtk cargo tree`、`rtk pip list`

**进程监控：**
- `rtk ps`、`rtk top`、`rtk docker ps`

## 安装

### macOS/Linux（Homebrew - 推荐）
```bash
brew install rtk
rtk init -g  # 全局hook用于Claude Code/Copilot
```

### Windows（winget）
```powershell
winget install rtk-ai.rtk
rtk init -g
```

### 通过Cargo
```bash
cargo install --git https://github.com/rtk-ai/rtk
rtk init -g
```

### 预构建二进制文件

[从releases下载](https://github.com/rtk-ai/rtk/releases)

## 与agents集成

### Claude Code / GitHub Copilot
```bash
rtk init -g
# 自动hook到bash
```

### Gemini CLI
```bash
rtk init -g --gemini
```

### Codex（OpenAI）
```bash
rtk init -g --codex
```

### Cursor / Windsurf
```bash
rtk init -g --agent cursor
rtk init -g --agent windsurf
```

### Hermes
```bash
rtk init -g --agent hermes
```

## 基准测试结果

根据 [rtk-ai.app/benchmarks](https://www.rtk-ai.app/benchmarks)：

| 指标 | 无RTK | 有RTK | 节省 |
|------|-------|-------|------|
| 平均token使用 | 100% | 10-40% | **60-90%** |
| 每次会话成本 | $1.00 | $0.10-$0.40 | **60-90%** |
| Context窗口使用 | 100% | 15-50% | **50-85%** |

### 实际案例

任务：审查包含500行更改的PR
- 无RTK：Agent读取完整 `git diff` → ~15,000 tokens
- 有RTK：RTK过滤只保留重要更改 → ~2,500 tokens
- **节省：12,500 tokens（~$0.05）**

## 为什么应该使用RTK？

1. **显著降低成本** — 60-90% token节省
2. **提高速度** — 更小的输出 = 更快的处理
3. **保留上下文** — 不会超出token限制
4. **零配置** — 安装即可运行
5. **跨平台** — macOS、Linux、Windows
6. **开源** — Apache 2.0许可证

## 与 alternatives 比较

| 工具 | 价格 | Token节省 | 复杂度 |
|------|------|-----------|--------|
| RTK | 免费 | 60-90% | 低 |
| Caveman | 免费 | ~30% | 中 |
| Ponytail | 免费 | ~54%代码 | 低 |
| 手动过滤器 | 免费 | 可变 | 高 |

## 重要注意事项

> ⚠️ **RTK不会减少你90%的账单** — 它减少90%的输出tokens。来自prompt、system prompt和对话历史的input tokens仍然全额计算。

然而，由于input tokens通常占总成本的很大一部分，实际节省仍然非常可观。

## 结论

RTK是频繁使用AI编码agent的开发者的**必备工具**。1分钟安装，每月节省数小时和数十美元。

**链接：** [github.com/rtk-ai/rtk](https://github.com/rtk-ai/rtk)
**网站：** [rtk-ai.app](https://www.rtk-ai.app)
