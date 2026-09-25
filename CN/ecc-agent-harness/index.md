---
title: "ECC (affaan-m/ECC): Hệ Thống Điều Khiển Agent Mạnh Nhất 2026"
description: "AI tool comparison and guide"
date: 2026-09-22
lastmod: 2026-09-22
tags: [github, ecc, claude-code, coding-agent, performance]
category: github-tools
image: https://raw.githubusercontent.com/affaan-m/ECC/main/assets/hero.png
related_posts:
  - /cn/archify-diagrams
  - /cn/rag-systems-2026
  - /cn/ai-coding-agents-comparison
toc: true
---

## ECC là gì?

**ECC** (Agent Harness Performance Optimization System) của `affaan-m` đã đạt **265.039 stars** trên GitHub. Đây không chỉ là một bộ kỹ năng — đây là hệ điều hành cho agent coding của bạn.

![ECC Hero Image](https://raw.githubusercontent.com/affaan-m/ECC/main/assets/hero.png)

> **Tóm tắt nhanh:** ECC biến agent coding từ "công cụ viết code" thành "hệ thống kỹ thuật đồng bộ" — lập kế hoạch trước, kiểm thử trước, xem xét lại, và học hỏi liên tục.

## Tại sao ECC đặc biệt?

### 1. Con số biết nói

| Thành phần | Số lượng |
|------------|----------|
| Agents | 68 |
| Skills | 286 |
| Commands | 94 |
| Hooks/Rules | Hỗ trợ runtime |
| AgentShield | Tích hợp sẵn |

### 2. Hỗ trợ đa nền tảng

ECC không giới hạn ở một agent duy nhất:

- ✅ **Claude Code** — native support
- ✅ **OpenAI Codex** — có sync path
- ✅ **Cursor** — adapter cục bộ
- ✅ **OpenCode** — plugin full
- ✅ **Gemini CLI** — cài đặt tối giản
- ✅ **Zed** — adapter cục bộ
- ✅ **Hermes** — setup guide riêng
- ✅ **Quay số khác**: Antigravity, Qwen, Kimi, CodeBuddy, JoyCode, GitHub Copilot

### 3. AgentShield — Bảo mật tự động

Một trong những tính năng hiếm có: **AgentShield** quét tự động:
- Prompts độc hại
- MCP config nguy hiểm
- Secrets rò rỉ
- Permission abuse

## Cài đặt như thế nào?

### Với Claude Code

```bash
# Cách 1: Install script
./install.sh --profile minimal --target claude

# Cách 2: Sử dụng plugin
claude plugin install ecc@ecc
```

### Với Codex CLI

```bash
./install.sh --profile minimal --target codex
```

### Với Cursor

```bash
./install.sh --profile minimal --target cursor
```

### Manual install (cross-platform)

```bash
npm install -g ecc-universal
npm install -g ecc-agentshield
```

## Agent nào có sẵn?

### Planning Agents
- `planner` — phân tích yêu cầu, tạo kế hoạch
- `tdd-workflow` — test-before-code enforcement
- `spec-analyzer` — phân tích specifications

### Security Agents
- `security-reviewer` — review code security
- `dependency-auditor` — quét lỗ hổng dependencies
- `prompt-injection-detector` — phát hiện injection attacks

### Architecture Agents
- `architecture-reviewer` — review kiến trúc hệ thống
- `performance-analyst` — phân tích và tối ưu performance
- `code-reviewer` — review code quality

### Domain Agents
- `database-reviewer` — audit database queries
- `api-designer` — thiết kế REST/GraphQL APIs
- `frontend-developer` — UI/UX implementation

## So sánh với alternatives

| Tính năng | ECC | Ponytail | agent-skills |
|-----------|-----|----------|--------------|
| Số lượng agents | 68 | Tập trung vào brevity | 20+ skills |
| Bảo mật | AgentShield tích hợp | Không | Có cơ bản |
| Đa platform | 10+ agents | Claude Code focus | Various |
| Learning system | Continuous learning | Static rules | Static rules |
| Pricing | Open source (MIT) | Open source | Open source |

## Tại sao bạn nên dùng ECC?

1. **Lập kế hoạch trước khi code** — Không phải viết code mù quáng
2. **Test-driven development** — Viết test trước, code sau
3. **Security-first** — AgentShield bảo vệ bạn tự động
4. **Continuous learning** — Học hỏi từ mỗi session
5. **Cross-harness** — Dùng được với nhiều AI tools

## Kết luận

ECC không chỉ là một bộ kỹ năng — nó là **hệ điều hành cho agent coding của bạn**. Với 265K stars và cộng đồng đang phát triển nhanh, ECC là lựa chọn hàng đầu cho developer muốn tối ưu hóa workflow với AI.

**Link:** [github.com/affaan-m/ECC](https://github.com/affaan-m/ECC)
**Docs:** [ecc.tools](https://ecc.tools)
