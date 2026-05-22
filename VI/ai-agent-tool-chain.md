---
title: 'AI Agent Tool Chain 2026: Stack 6 Thành Phần Để Xây Agent Tự Trị Cấp Production'
description: 'Stack AI agent production hoàn chỉnh: LangGraph cho orchestration có trạng thái + MCP servers cho tool + mem0 cho memory + OpenClaw cho phối hợp multi-agent + Hermes Agent cho tự cải thiện + e2b cho thực thi code sandboxed. $20-60/tháng self-host. Lắp ráp thực tế với deep dive đã link nội bộ.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - TypeScript
  - Docker
  - PostgreSQL
application_domain: Collections
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['AI Agent', 'Tool Chain', 'LangGraph', 'MCP', 'Stack', 'Collection']
aliases:
  - /posts/ai-agent-tool-chain/
---

"AI agent" ngừng là chủ đề nghiên cứu năm 2025 và trở thành category kỹ thuật production năm 2026. Các team ship agent tự trị thực sự — bot hỗ trợ khách hàng sống sót restart, coding agent refactor qua trăm file, research agent chạy hàng giờ — hội tụ về một stack nhất quán đáng kinh ngạc. Bộ sưu tập này lắp ráp nó.

**6 thành phần, $20-60/tháng self-host.** Pair với [Workflow AI Coding Self-Host](/vi/collections/self-hosted-ai-coding-workflow/) nếu bạn xây coding agent cụ thể; bộ sưu tập này focus pattern agent tự trị (dài hạn, đa bước, có tool).

## TL;DR — Stack Một Cái Nhìn

| # | Thành phần | Vai trò | Vì sao | Hướng dẫn sâu |
|---|---|---|---|---|
| 1 | **LangGraph** | Orchestration agent có trạng thái (não) | Thực thi bền vững, human-in-loop, sống sót crash | [LangGraph production 2026](/vi/resources/llm-frameworks/langgraph-stateful-agent-orchestration-2026/) |
| 2 | **MCP servers** (filesystem / git / search / chuyên domain) | Layer tool & context (tay và mắt) | Protocol agent-thế-giới chuẩn hóa, 19,700+ có sẵn | [MCP Server Registry 2026](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) |
| 3 | **mem0 + AgentMemory MCP** | Memory ngữ nghĩa bền vững (memory dài hạn) | Recall qua session, trích xuất sự thật, decay | [AgentMemory MCP](/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 4 | **OpenClaw** | Phối hợp multi-agent (team) | Orchestration sub-agent, ủy quyền, thực thi song song | [OpenClaw self-host](/vi/resources/llm-frameworks/openclaw-self-hosted-ai-assistant-setup-guide-2026/) |
| 5 | **Hermes Agent** | Vòng tự cải thiện agent (layer học) | Agent tự cải thiện prompt và sử dụng tool qua các lần chạy | [Hướng dẫn Hermes Agent](/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) |
| 6 | **e2b sandbox** (qua `e2b-sandbox-mcp`) | Sandbox thực thi code (sân chơi an toàn) | Chạy code không tin cậy không sở hữu VM, expose MCP | (xem [MCP Server Registry](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) §6) |

**Tổng chi phí tháng**: Solo agent dev **$20-30/tháng** • Team nhỏ hoặc prototype production **$40-60/tháng** • Scale tới ~$200/tháng ở production với nhiều agent đồng thời

So với pure-SaaS: mỗi nền tảng agent (LangChain Cloud, Vellum, v.v.) bắt đầu ~$99/tháng/dev; bundled với sandbox + memory + sản phẩm multi-agent bạn nhanh chóng đụng $300-500/tháng.

## 1. Vì Sao Tự Xây Stack Agent Năm 2026

Ba lực hội tụ năm nay:

1. **LangGraph đạt 1.x và chứng minh thực thi bền vững ở quy mô** — bug "agent quên mọi thứ sau restart" được giải quyết
2. **MCP chuẩn hóa tích hợp tool** — viết tool một lần làm MCP server, dùng trong Claude / OpenCode / Cursor / agent tự xây
3. **Vòng tự cải thiện trở nên tái lập được** — Hermes Agent và các project tương tự cho thấy agent có thể cải thiện lặp lại prompt của chúng dựa trên dữ liệu kết quả

Kết hợp nghĩa là team nhỏ có thể xây agent mà trước đây cần ngân sách hạ tầng AI $500k/năm — với $30/tháng và một cuối tuần dài.

## 2. Tổng Quan Kiến Trúc

```
                ┌──────────────────────────────────────┐
                │   User / trigger bên ngoài            │
                └─────────────────┬────────────────────┘
                                  │
                                  ▼
        ┌───────────────────────────────────────────────────┐
        │  LangGraph (state machine + checkpointer)         │
        │                                                   │
        │  ┌────────────┐  ┌──────────────┐  ┌──────────┐ │
        │  │ Lập kế hoạch│→ │ Gọi tool    │→ │ Critique │ │
        │  │ node       │  │ node         │  │ node     │ │
        │  └────────────┘  └──────┬───────┘  └─────┬────┘ │
        │                          │                │      │
        └──────────────────────────┼────────────────┼──────┘
                                   │                │
                                   ▼                ▼
                ┌──────────────────────┐  ┌─────────────────┐
                │ MCP servers          │  │ mem0 (memory)   │
                │  - filesystem        │  │  via Agent-     │
                │  - git               │  │  Memory MCP     │
                │  - tavily-search     │  └─────────────────┘
                │  - e2b-sandbox       │
                │  - chuyên domain     │
                └──────────────────────┘

   Layer tùy chọn:
   - OpenClaw orchestrate nhiều agent LangGraph song song
   - Hermes Agent quan sát kết quả và viết lại prompt theo thời gian
```

Mô hình tinh thần: **LangGraph là não quyết định làm gì tiếp. MCP servers là tay làm nó. mem0 là cái não nhớ. OpenClaw scale tới team. Hermes làm team thông minh hơn qua các lần chạy.**

## 3. Thành Phần 1 — LangGraph (Não Orchestration)

**Vai trò**: State machine. Mọi quyết định agent, mọi tool call, mọi chuyển tiếp tồn tại như node và edge trong LangGraph. State persist vào Postgres. Crash resume. Người có thể interrupt bất kỳ node.

**Vì sao chọn**: 32.6k stars, v1.2.1, xây bởi team LangChain. Framework duy nhất được áp dụng rộng rãi nơi "agent sống sót deploy" là mặc định thay vì cái bạn lắp thêm.

**Cài nhanh**:
```bash
pip install -U langgraph langgraph-checkpoint-postgres
```

Định nghĩa agent như graph (lập kế hoạch → tool → critique → loop). Compile với `PostgresSaver`. Chạy với `thread_id`. Runtime xử mọi thứ khác.

**Setup đầy đủ** bao gồm 4 tính năng killer, pattern triển khai production, migration từ LangChain `AgentExecutor`: [LangGraph orchestration agent có trạng thái 2026](/vi/resources/llm-frameworks/langgraph-stateful-agent-orchestration-2026/).

## 4. Thành Phần 2 — MCP Servers (Tool & Context)

**Vai trò**: Mọi action bên ngoài agent thực hiện — đọc file, chạy lệnh shell, search web, query DB — chảy qua MCP server.

**Vì sao quan trọng**: Trước MCP (đầu 2025), mọi framework agent tái triển khai cùng 20 tool (filesystem, search web, thực thi code) và chúng không tương tác. Hôm nay bạn wire up Anthropic 7 reference server + 3-5 chuyên biệt và có siêu sức mạnh agent mà không viết code tool.

**Bộ MCP tối thiểu cho agent tự trị**:
- `modelcontextprotocol/server-filesystem` (đọc file project)
- `modelcontextprotocol/server-git` (kiểm tra state git)
- `tavily-mcp` hoặc `brave-search-mcp-server` (search web)
- `e2b-sandbox-mcp` (thực thi code sandbox — xem thành phần 6)
- 1-2 chuyên domain (Postgres MCP / Slack MCP / Stripe MCP)

**Menu 19,700+ MCP server có sẵn đầy đủ + checklist pick**: [Hướng dẫn MCP Server Registry toàn diện 2026](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/).

## 5. Thành Phần 3 — mem0 + AgentMemory MCP (Memory Dài Hạn)

**Vai trò**: Cái agent nhớ qua các lần chạy. Không có cái này, mọi invocation agent bắt đầu từ context 0. Có cái này, agent nhớ sự thật về user, project, quyết định trước, thất bại trước.

**Pattern 2-tier**:
- **mem0** lưu memory ngữ nghĩa (service Python backed bởi vector DB)
- **AgentMemory MCP** expose mem0 cho bất kỳ host nhận thức MCP (LangGraph node, Claude Desktop, OpenCode)

**Cài nhanh**:
```bash
docker run -d --name mem0 -p 8765:8765 mem0ai/mem0-server:latest
npm install -g @mem0/mem0-mcp
# Sau đó thêm agentmemory vào MCP toolset của LangGraph
```

**Setup đầy đủ**: [AgentMemory MCP memory bền vững 2026](/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/).

## 6. Thành Phần 4 — OpenClaw (Phối Hợp Multi-Agent)

**Vai trò**: Khi một LangGraph agent không đủ — khi bạn cần bộ ba "researcher" + "writer" + "critic" phối hợp — OpenClaw là orchestrator ủy quyền và tổng hợp.

**Vì sao chọn hơn CrewAI**: OpenClaw self-host được, MCP native, tích hợp sạch với LangGraph (mỗi "agent chuyên gia" chính nó có thể là LangGraph). CrewAI tốt nhưng cloud-first và khó compose với state machine tùy biến.

**Cài nhanh**:
```bash
docker run -d --name openclaw \
  -p 7050:7050 \
  -v ~/.openclaw:/data \
  ghcr.io/openclaw/openclaw:latest
```

**Setup đầy đủ** bao gồm pattern ủy quyền sub-agent và thư viện use case: [Hướng dẫn setup OpenClaw self-host AI assistant 2026](/vi/resources/llm-frameworks/openclaw-self-hosted-ai-assistant-setup-guide-2026/) và tham khảo [awesome OpenClaw use cases](/vi/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/).

## 7. Thành Phần 5 — Hermes Agent (Vòng Tự Cải Thiện)

**Vai trò**: Quan sát kết quả agent theo thời gian, xác định prompt và chuỗi tool nào tạo kết quả tốt vs xấu, tự động viết lại prompt. Agent của bạn tốt hơn mà không cần bạn babysit.

**Vì sao quan trọng**: Prompt agent tĩnh decay — cái hoạt động ở v1 ngừng hoạt động khi codebase tiến hóa, domain dịch chuyển, tool mới xuất hiện. Hermes Agent là framework mã nguồn mở được áp dụng rộng rãi duy nhất cụ thể cho vòng tự cải thiện agent.

**Cài nhanh**:
```bash
pip install hermes-agent
# Wire nó như "post-run observer" trên workflow LangGraph
```

Pattern: Hermes xem trace log LangGraph (qua xuất LangSmith), tương quan điểm chất lượng kết quả với phiên bản prompt, sinh prompt candidate mới, test A/B.

**Setup đầy đủ** bao gồm thiết kế hàm thưởng và chiến lược mutation prompt: [Hermes Agent AI agent tự cải thiện](/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/).

## 8. Thành Phần 6 — e2b Sandbox (Thực Thi Code An Toàn)

**Vai trò**: Khi agent quyết định chạy code Python / shell / Node (thường gặp trong phân tích dữ liệu, sinh code, workflow research), e2b cung cấp sandbox cloud cô lập để code không tin cậy không chạm hạ tầng của bạn.

**Vì sao e2b expose MCP thắng SDK e2b raw**: Server `e2b-sandbox-mcp` làm "chạy code trong sandbox" thành một tool call đơn của agent LangGraph — cùng interface như đọc filesystem hoặc search web.

**Cài nhanh** (thêm vào MCP config cùng những cái khác):
```json
{
  "mcpServers": {
    "e2b-sandbox": {
      "command": "npx",
      "args": ["-y", "@e2b/sandbox-mcp"],
      "env": { "E2B_API_KEY": "your-key" }
    }
  }
}
```

**Chi phí**: e2b có free tier (50 sandbox-giờ/tháng). Vượt đó, $0.000014/CPU-giây — rẻ cho workload agent điển hình.

**Tìm cái này và 19,700+ MCP server khác**: [Hướng dẫn MCP Server Registry toàn diện 2026](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) §6.

## 9. Thứ Tự Lắp Ráp Day 1 (3 giờ)

1. **Khởi động VPS + Postgres** (20 phút) — {{< aff "digitalocean" "agent-vps" "DigitalOcean $24/tháng droplet (8 GB)" >}} + Managed Postgres ($15/tháng)
2. **Cài LangGraph + checkpointer** (15 phút) — `pip install`, viết agent có trạng thái hello-world 30 dòng, xác minh nó sống sót `kill -9` và resume
3. **Thêm MCP servers** (30 phút) — filesystem + git + tavily + e2b-sandbox trong MCP config của node LangGraph
4. **Thêm mem0 + AgentMemory MCP** (20 phút) — Docker run mem0, thêm agentmemory vào MCP toolset
5. **Test agent hữu ích đầu tiên** (45 phút) — Pipeline "research → tóm tắt → ghi file" sống sót restart, dùng 3 tool, persist memory
6. **Thêm OpenClaw** (30 phút) — Chỉ nếu thực sự cần multi-agent. Nếu không, bỏ qua
7. **Wire observer Hermes Agent** (20 phút) — Chỉ sau khi có baseline single agent ổn định. Nếu không, bạn đang tối ưu noise

3 giờ từ 0 tới agent có trạng thái multi-tool hoạt động trên hạ tầng bạn sở hữu.

## 10. Phân Tích Chi Phí

| Item | Solo agent dev | Team prototype | Production (3 agent đồng thời) |
|---|---|---|---|
| VPS | $24 (8 GB) | $48 (16 GB) | $120 (32 GB + replica) |
| Managed Postgres | $15 | $30 | $60 |
| LangGraph | $0 (OSS) | $0 | $0 |
| MCP servers | $0 | $0 | $0 |
| mem0 / AgentMemory MCP | $0 | $0 | $0 |
| OpenClaw | $0 | $0 | $0 |
| Hermes Agent | $0 | $0 | $0 |
| e2b sandbox | $0 (free tier) | $5-10 | $30-60 |
| LLM API (DeepSeek chính + Claude fallback) | $5-15 | $15-30 | $80-150 |
| LangSmith (tùy chọn, gisibility) | $0 (free tier) | $39 | $99-499 |
| **Tổng** | **~$45-55/tháng** | **~$140-160/tháng** | **~$390-790/tháng** |

So với nền tảng agent managed: LangChain Cloud $99/user/tháng, Vellum starter $299/tháng, tool agent enterprise $499+.

## 11. Đường Nâng Cấp

Khi vượt stack này:

- **Hơn 10 agent đồng thời** — Di chuyển LangGraph sang cluster Kubernetes chuyên dụng với autoscaling
- **Cần giữ trace cấp audit** — LangSmith Enterprise hoặc gisibility self-host (Grafana + Loki + Tempo)
- **SaaS agent multi-tenant** — Thêm LiteLLM cho virtual-key-per-customer ([hướng dẫn LiteLLM](/vi/resources/llm-frameworks/litellm/))
- **Yêu cầu latency sub-giây** — Di chuyển workload e2b sang Firecracker VM chuyên dụng bạn kiểm soát
- **Ngành được quản lý (sức khỏe, tài chính)** — Đổi MCP server công khai sang fork nội bộ đã vetted; thêm Portkey cho guardrail ([Portkey vs LiteLLM 2026](/vi/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/))

## TL;DR — Recipe

**6 thành phần cho agent tự trị cấp production, solo hoặc team prototype $20-60/tháng**:
1. **LangGraph** — não orchestration có trạng thái
2. **MCP servers** — tool & context (filesystem + git + search + sandbox)
3. **mem0 + AgentMemory MCP** — memory dài hạn
4. **OpenClaw** — phối hợp multi-agent
5. **Hermes Agent** — vòng tự cải thiện
6. **e2b sandbox** — thực thi code an toàn

Bật {{< aff "digitalocean" "footer-cta" "DigitalOcean $24/tháng droplet" >}}, theo mục 9, và bạn có agent sống sót restart, nhớ context, chạy code an toàn, và tự cải thiện theo thời gian — trên hạ tầng bạn sở hữu với chi phí ít hơn một seat Cursor.

---

*Bộ sưu tập đồng hành: [Workflow AI Coding Self-Host](/vi/collections/self-hosted-ai-coding-workflow/) cho stack đặc thù coding agent. [Stack Knowledge Base](/vi/collections/knowledge-base-stack/) cho agent backend RAG tương đương Glean. [Stack LLM Rẻ](/vi/collections/cheap-llm-stack/) cover phía chi phí.*
