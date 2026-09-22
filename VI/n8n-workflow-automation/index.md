---
title: "n8n: Nền Tảng Tự Động Hóa Workflow 2026 (205K Stars)"
description: "n8n là nền tảng tự động hóa workflow fair-code với khả năng AI native. 400+ tích hợp, self-hostable, hỗ trợ visual building + custom code. Đạt 205K GitHub stars."
date: 2026-09-22
lastmod: 2026-09-22
tags: [github, n8n, workflow, automation, ai-agent]
category: github-tools
image: https://raw.githubusercontent.com/n8n-io/n8n/main/assets/hero.png
related_posts:
  - /vi/ecc-agent-harness
  - /vi/ponytail-lazy-dev
  - /vi/voicestudio-voice-cloning
toc: true
---

## n8n là gì?

**n8n** là nền tảng tự động hóa workflow mã nguồn mở, đạt **205.668 stars**. Khác với Zapier hay Make, n8n có thể **self-host** hoàn toàn — dữ liệu của bạn ở lại server của bạn.

![n8n Hero](https://raw.githubusercontent.com/n8n-io/n8n/main/assets/hero.png)

> **Fair-code license:** Miễn phí cho commercial use với điều kiện không bán lại platform.

## Tại sao n8n khác biệt?

### 1. Self-hosted
- Dữ liệu không ra khỏi server của bạn
- Không lệ thuộc third-party
- Control hoàn toàn

### 2. Native AI Capabilities
- AI agent nodes
- LLM integration (OpenAI, Anthropic, local models)
- RAG workflows
- Vector database connections

### 3. 400+ Integrations
- Google Workspace
- Slack, Discord, Telegram
- GitHub, GitLab
- databases (PostgreSQL, MongoDB, MySQL)
- APIs khắp nơi

### 4. Visual + Code
- Drag-and-drop workflow builder
- JavaScript/Python nodes cho custom logic
- Debug trực quan

## Use cases phổ biến

### AI Agent Workflows
```
Trigger (webhook) → AI Process → Database → Notification
```

Ví dụ: tự động xử lý email, classify, lưu vào DB, alert khi cần.

### Data Pipeline
```
API → Transform → Store → Dashboard
```

Ví dụ: scrape data từ multiple sources, clean, lưu vào warehouse.

### Automation
```
Schedule → Check conditions → Act → Report
```

Ví dụ: daily check inventory, auto-order khi low stock.

## Cài đặt

### Docker (recommended)
```bash
docker run -d \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n:/home/node/.n8n \
  n8nio/n8n
```

### npm
```bash
npm install -g n8n
n8n start
```

### Kubernetes
```bash
helm repo add n8n https://n8n.io/charts
helm install n8n n8n/n8n
```

## AI-Native Workflows

### LLM Agent
```json
{
  "nodes": [
    {"type": "chatTrigger", "name": "Chat Input"},
    {"type": "llmChain", "name": "GPT-4", "params": {"model": "gpt-4"}},
    {"type": "code", "name": "Process", "params": {"functionCode": "return items"}},
    {"type": "chatRespond", "name": "Chat Output"}
  ]
}
```

### RAG Pipeline
```
Document → Split → Embed → Vector Store → Retrieve → LLM → Answer
```

### Multi-Agent System
```
Orchestrator Agent → Specialist Agents → Merge → Output
```

## So sánh alternatives

| Feature | n8n | Zapier | Make | Airflow |
|---------|-----|--------|------|---------|
| Self-host | ✅ | ❌ | ❌ | ✅ |
| Price | Free* | Expensive | Expensive | Free |
| AI native | ✅ | Basic | Basic | ❌ |
| Visual builder | ✅ | ✅ | ✅ | ❌ |
| Code flexibility | ✅ | Limited | Limited | ✅ |
| Community | 200K+ | Large | Medium | Large |

*Fair-code: free cho commercial use, trừ khi bán lại platform.

## Tích hợp với AI Agents

n8n có thể kết hợp với:
- **ECC** — orchestrate agent workflows
- **Claude Code** — generate code từ workflow
- **Hermes** — trigger agents from events
- **Custom agents** — build your own

## Limitations

⚠️ **Cần lưu ý:**
- Self-hosting cần运维 knowledge
- Complex workflows cần JavaScript skills
- Community nodes có thể chưa stable
- Enterprise features cần paid plan

## Kết luận

n8n là **sweet spot** giữa power và ease-of-use. Cho người muốn automation mạnh mẽ mà không muốn trả giá đắt cho SaaS.

**Link:** [github.com/n8n-io/n8n](https://github.com/n8n-io/n8n)
**Website:** [n8n.io](https://n8n.io)
