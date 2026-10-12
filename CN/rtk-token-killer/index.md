---


title: "RTK (rtk-ai/rtk): Giảm 90% Token Cost Cho AI Coding"
description: "AI tool comparison and guide"
date: 2026-09-22
lastmod: 2026-09-22
tags: [github, rtk, token-optimization, claude-code, cost-reduction]
category: github-tools
image: https://raw.githubusercontent.com/rtk-ai/rtk/main/assets/hero.png
related_posts:
  - /cn/ecc-agent-harness
  - /cn/mattpocock-skills
  - /cn/rag-systems-2026
toc: true
---



## Vấn đề token cost

Khi dùng AI coding agents (Claude Code, Codex, Cursor), bạn đang trả tiền cho mỗi token input. Một lệnh `git log` hay `ls -la` có thể xuất ra hàng ngàn dòng, và mỗi dòng đó cost money.

**RTK giải quyết vấn đề này.**

![RTK Hero](https://raw.githubusercontent.com/rtk-ai/rtk/main/assets/hero.png)

> **Tóm tắt:** RTK lọc và nén output từ CLI trước khi gửi tới LLM. Giảm 60-90% token usage mà không mất thông tin quan trọng.

## RTK hoạt động thế nào?

### Cơ chế hoạt động

```
Bạn chạy: git status
↓
RTK intercept và filter output
↓
Agent nhận được phiên bản đã nén (90% nhỏ hơn)
↓
Cost giảm, context window được bảo toàn
```

### Supported Commands (100+)

**Git operations:**
- `rtk git status`, `rtk git log`, `rtk git diff`
- `rtk gh pr list`, `rtk gh issue view`

**File operations:**
- `rtk find`, `rtk grep`, `rtk rg`
- `rtk cat`, `rtk head`, `rtk tail`

**Package management:**
- `rtk npm list`, `rtk yarn why`
- `rtk cargo tree`, `rtk pip list`

**Process monitoring:**
- `rtk ps`, `rtk top`, `rtk docker ps`

## Cài đặt

### macOS/Linux (Homebrew - recommended)

```bash
brew install rtk
rtk init -g  # Global hook cho Claude Code/Copilot
```

### Windows (winget)

```powershell
winget install rtk-ai.rtk
rtk init -g
```

### Via Cargo

```bash
cargo install --git https://github.com/rtk-ai/rtk
rtk init -g
```

### Pre-built binaries

[Tải về từ releases](https://github.com/rtk-ai/rtk/releases)

## Kết hợp với agents

### Claude Code / GitHub Copilot
```bash
rtk init -g
# Tự động hook vào bash
```

### Gemini CLI
```bash
rtk init -g --gemini
```

### Codex (OpenAI)
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

## Benchmarks

Theo [rtk-ai.app/benchmarks](https://www.rtk-ai.app/benchmarks):

| Metric | Without RTK | With RTK | Savings |
|