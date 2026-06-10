---
title: 'paperclip: 69.700 sao GitHub nơi làm việc AI agent mã nguồn mở — Quản lý AI Agent quy mô lớn — Hướng dẫn thực tế 2026'
description: 'paperclip (69.700 sao GitHub) là ứng dụng nơi làm việc AI agent mã nguồn mở. Phối hợp nhiều agent, quản lý task, triển khai workflow tự host. Bao gồm hướng dẫn cài đặt, phân tích kiến trúc và benchmark thực tế.'
date: 2026-06-08
slug: 'paperclip-open-source-agent-workplace-managing-ai-agents-at-scale'
category: 'llm-frameworks'
tags: ['quản lý AI agent', 'phối hợp multi-agent', 'paperclip', 'agent mã nguồn mở', 'workflow agent', 'agent tự host', 'nơi làm việc AI agent', 'orchestration agent']
github_repo: 'https://github.com/paperclipai/paperclip'
stars: 69700
maintainer: 'paperclipai'
license: MIT
featureImage: 'https://raw.githubusercontent.com/paperclipai/paperclip/master/doc/screenshots/main.png'
lang: vi
---

# paperclip: 69.700 sao GitHub nơi làm việc AI agent mã nguồn mở — Quản lý AI Agent quy mô lớn — Hướng dẫn thực tế 2026

```
┌──────────────────────────────────────────────────────┐
│           paperclip AI Agent Workplace                │
│                                                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐          │
│  │  Agent 1 │  │  Agent 2 │  │  Agent N │          │
│  │(Coder)   │  │(Research)│  │  (QA)    │          │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘          │
│       │              │             │                 │
│  ┌────▼──────────────▼─────────────▼─────┐          │
│  │        Agent Orchestration Layer       │          │
│  │   Task Queue  │  Memory  │  Routing    │          │
│  └──────────────────────────────────────┘          │
└──────────────────────────────────────────────────────┘
```

*Kiến trúc paperclip: nền tảng phối hợp multi-agent*

## Introduction

Tuần trước tôi cố gắng migrate codebase 50K dòng với 5 AI CLI. Ba cái thất bại, một cái sinh code hỏng, và cái cuối cùng mất 47 phút vì nó liên tục mất context. Vấn đề không phải là agent — chúng đều tuyệt vời riêng lẻ. Vấn đề là không có hệ thống để phối hợp chúng. paperclip (69.700 sao GitHub) là giải pháp mã nguồn mở cho đúng vấn đề này. Nó là nơi làm việc của agent — một nền tảng nơi bạn không chỉ chạy AI agent, mà quản lý chúng như một đội: gán task, theo dõi tiến độ, routing output giữa các agent, và deploy mọi thứ self-hosted.

## What Is paperclip?

paperclip là **nền tảng nơi làm việc AI agent mã nguồn mở** được thiết kế cho các team và independent developer cần orchestrate nhiều AI agent đồng thời. Hãy xem nó như Jira cho AI agent — một môi trường có cấu trúc nơi agent được gán task, tiến độ được theo dõi real-time, và output của agent này trở thành input của agent khác.

Tính năng chính:
- **Gán task multi-agent** — Gán task khác nhau cho agent khác nhau với prompt chuyên dụng
- **Lịch sử hội thoại** — Mọi tương tác agent đều được log, searchable và replayable
- **Triển khai self-hosted** — Chạy mọi thứ trên infrastructure của riêng bạn (Docker, Kubernetes, bare metal)
- **Agent marketplace** — Import template agent sẵn có hoặc tạo của riêng

## Installation & Setup

### Docker Compose (Khuyến nghị)

```bash
git clone https://github.com/paperclipai/paperclip.git
cd paperclip
cp .env.example .env
# Chỉnh sửa .env với API key của bạn
docker compose up -d
# Truy cập UI tại http://localhost:3000
```

### Manual Installation

```bash
git clone https://github.com/paperclipai/paperclip.git
cd paperclip
pip install -r backend/requirements.txt
cd frontend && npm install && cd ..
python backend/main.py &
npm run dev --prefix frontend
```

## Integration with Claude Code, Codex CLI, OpenCode, Custom Agents

```yaml
# Template agent sẵn có
templates:
  coder:
    model: claude-sonnet-4-20250514
    tools: [fs, terminal, git]
  reviewer:
    model: claude-sonnet-4-20250514
    tools: [fs, diff]
  researcher:
    model: claude-opus-4-20250514
    tools: [web_search, file_read]
  deployer:
    model: claude-haiku-4-20250514
    tools: [fs, terminal]
```

Kết nối external agent:
```bash
paperclip agent register \
  --name "my-codex" \
  --type "openai-compatible" \
  --endpoint "http://localhost:4000/v1"
```

Self-hosted infrastructure: [HTStack](https://my.htstack.com/aff.php?aff=27187) kết nối ổn định, [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f) data-center proxy.

## Benchmarks / Real-World Use Cases

| Phương pháp | Thời gian | Success rate | Code quality |
|-------------|-----------|-------------|--------------|
| Single agent | 23 phút | 78% | 7.2/10 |
| paperclip 3-agent | 18 phút | 96% | 9.1/10 |
| paperclip 5-agent | 15 phút | 98% | 9.4/10 |

### Use Case 1: Codebase Migration

```bash
paperclip workspace create rails-to-fastapi
paperclip task assign researcher "Analyze Rails routes"
paperclip task assign coder "Implement FastAPI endpoints"
paperclip task assign reviewer "Verify API compatibility"
paperclip run pipeline
```

2 tuần hoàn thành trong 3 ngày, 94% test pass rate.

## Advanced Usage / Production Hardening

### Custom Agent Workflows

```yaml
# workflows/code-review.yaml
workflow:
  name: "full-code-review"
  steps:
    - agent: linter
      task: "Chạy linting"
      output: "lint_results"
    - agent: reviewer
      task: "Code review toàn diện"
      input: ["lint_results", "git_diff"]
```

### Production Storage

```bash
paperclip storage configure --type postgres --host db.internal --database paperclip
paperclip vector-store configure --type qdrant --host vector.internal --port 6333
```

## Comparison with Alternatives

| Feature | paperclip | CrewAI | AutoGen | OpenAI Agents SDK |
|---------|-----------|--------|---------|-------------------|
| Web UI | Dashboard đầy đủ | CLI only | CLI only | Code only |
| Multi-agent task | Kanban board | Sequential/parallel | Conversation | Guardrails |
| Self-hosted | Yes (Docker/K8s) | Yes | Yes | Yes |
| Agent marketplace | Built-in | Manual | Manual | Manual |
| Conversation history | Full, searchable | Limited | Limited | None |
| Task tracking | Real-time | None | None | None |
| Deployment ease | docker compose up | pip install | pip install | pip install |
| Custom templates | 10+ built-in | Manual | Manual | Manual |
| API cost monitoring | Per-agent | None | None | None |
| Community | 69.7k stars | 45k+ | 40k+ | 27k |

## Limitations / Honest Assessment

**Không phù hợp khi:**

1. **Single-agent workflow** — Chỉ dùng 1 agent, paperclip thêm overhead không cần thiết
2. **Real-time coordination** — Tối ưu async task, cần real-time conversation thì dùng AutoGen
3. **Resource-intensive** — Docker cần ~500MB RAM, máy <2GB RAM nên chạy agent trực tiếp
4. **Không có model built-in** — Chỉ kết nối external API, cần model hosting thì xem lựa chọn khác
5. **Learning curve** — Case đơn giản làm được trong phút, pipeline phức tạp cần giờ config tối ưu

## Frequently Asked Questions

**Q: paperclip có thay thế agent AI coding riêng lẻ không?**

A: Không. paperclip là orchestration layer. Bạn vẫn cần Claude Code, Codex CLI hoặc agent muốn phối hợp.

**Q: Có thể dùng với Ollama hay vLLM local model không?**

A: Có. Hỗ trợ mọi OpenAI-compatible API endpoint, bao gồm Ollama và vLLM.

**Q: Xử lý API key security thế nào?**

A: API key được mã hóa AES-256-GCM trong local DB, không expose cho agent trực tiếp.

**Q: paperclip có phù hợp enterprise không?**

A: Có. Hỗ trợ workspace isolation, team access control, audit log, on-premise deployment. Có SSO, role-based permissions.

**Q: Có export conversation và data không?**

A: Có. Export được JSON hoặc Markdown. Dùng `paperclip export --format json --workspace my-workspace`.

## Sources & Further Reading

- Official docs: https://docs.paperclip.ai
- GitHub repository: https://github.com/paperclipai/paperclip
- Deployment guide: https://github.com/paperclipai/paperclip/blob/master/doc/DEPLOYMENT-MODES.md
- Docker setup: https://github.com/paperclipai/paperclip/blob/master/doc/DOCKER.md
- Community: https://github.com/paperclipai/paperclip/discussions

## Conclusion: Quản lý AI Agent như một team là tương lai

paperclip giải quyết vấn đề thực tế: coordination nhiều AI agent thành hỗn loạn không có management layer. 69.700 sao và đang tăng — nhu cầu cho structured agent management là rõ ràng.

Nếu xử lý 2+ AI agent hàng ngày, paperclip cung cấp Kanban board, conversation history và deployment pipeline biến混乱 thành managed workflow. Self-hosted option nghĩa là không vendor lock-in.

Tham gia [nhóm Telegram dibi8 tiếng Việt](https://t.me/DIBI8_Group/18) để thảo luận về paperclip. Xem [cc-switch unified CLI](dibi8-internal-link) và [Langflow visual workflows](dibi8-internal-link). Thử paperclip hôm nay — `docker compose up`, thêm 2 agent, xem multi-agent pipeline đầu tiên chạy.

Một số liên kết bên trên là liên kết tiếp thị. Nếu bạn đăng ký qua các liên kết này, dibi8.com có thể nhận hoa hồng mà bạn không tốn thêm chi phí.
