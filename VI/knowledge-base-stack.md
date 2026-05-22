---
title: 'Stack Knowledge Base 2026: Xây "Bộ Não Thứ Hai" Với AnythingLLM + RAGFlow + mem0 ($10-25/Tháng)'
description: 'Stack knowledge base self-host 5 thành phần cho cá nhân hoặc team. AnythingLLM (UI + RAG) + RAGFlow (phân tích doc sâu) + mem0 (memory agent) + AgentMemory MCP (expose MCP) + pick vector DB. Thay $50-200/tháng SaaS (Notion AI + Mem + Glean) bằng $10-25/tháng self-host.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - PostgreSQL
  - Redis
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
tags: ['Knowledge Base', 'RAG', 'Bộ não thứ hai', 'Stack', 'Collection']
aliases:
  - /posts/knowledge-base-stack/
---

Bạn có 500 PDF, 2,000 ghi chú, 10 năm email, và AI trong editor không biết chúng tồn tại. Notion AI tốn $10/seat/tháng và không thấy file local. Glean tốn tối thiểu $30k/năm. Mem.ai tuyệt nhưng là SaaS — "bộ não thứ hai" của bạn sống trên phần cứng người khác.

Bộ sưu tập này lắp ráp **stack knowledge base self-host 5 thành phần** ingest tất cả (PDF, notes, web page, code), embed local, cho phép bạn query qua chat + API, và expose nó cho AI coding agent qua MCP — tổng **$10-25/tháng** chi phí hạ tầng.

## TL;DR — Stack Một Cái Nhìn

| # | Thành phần | Vai trò | Vì sao | Hướng dẫn sâu |
|---|---|---|---|---|
| 1 | **AnythingLLM** | UI RAG all-in-one + quản lý doc + giao diện chat | "Cửa trước" — nơi bạn và team thực sự click vào | [Kiến trúc AnythingLLM local RAG](/vi/resources/llm-frameworks/anythingllm-architecture-local-rag/) |
| 2 | **RAGFlow** | Phân tích doc sâu (bảng, công thức, PDF nhiều cột) | Khi AnythingLLM dừng ở phân tích "đủ tốt", RAGFlow xử doc khó | [Hướng dẫn RAGFlow](/vi/resources/llm-frameworks/ragflow/) |
| 3 | **mem0** | Layer memory ngữ nghĩa bền vững cho agent | "Nhớ sự thật về user" dài hạn qua session | [Setup mem0](/vi/resources/llm-frameworks/mem0/) |
| 4 | **AgentMemory MCP** | Expose mem0 cho bất kỳ MCP host (Claude Desktop, OpenCode, Cursor) | Cho phép coding agent chia sẻ knowledge base qua MCP protocol | [AgentMemory MCP](/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 5 | **Vector DB** (Chroma / Qdrant / Weaviate) | Backend lưu embedding + tìm tương đồng | Pick tùy — xem [So sánh Vector DB](/vi/resources/llm-frameworks/vector-database-comparison/) | [So sánh Vector DB 2026](/vi/resources/llm-frameworks/vector-database-comparison/) |

**Tổng chi phí tháng** (solo, 10 GB doc): **$10-15** • **Team nhỏ (10 GB, 5 user)**: **$15-25** • **Org (100 GB, 50 user)**: **$60-150**

So với SaaS tương đương: Notion AI + Mem + Glean Lite = $50-200/tháng cho coverage solo đến team nhỏ.

## 1. Vì Sao Self-Host Knowledge Base Năm 2026

Ba điều hội tụ:

1. **Model embedding local đạt chất lượng production** — `nomic-embed-text` và `bge-large` chạy trên VPS 4GB, embed ở 200 doc/phút, retrieve sub-100ms. Không còn "gửi dữ liệu sang OpenAI để embed"
2. **MCP chuẩn hóa tích hợp agent-knowledge** — khi knowledge base nói MCP, mọi AI coding agent (Claude Desktop, OpenCode, Cursor, Continue) đều query được mà không cần code tích hợp tùy biến. Xem [hướng dẫn MCP server registry](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) cho chi tiết protocol
3. **RAGFlow ship phân tích doc cấp doanh nghiệp mã nguồn mở** — PDF nhiều cột, bảng có cell hợp nhất, công thức nhúng. Cái mọi stack "DIY RAG" đều thất bại, giờ giải quyết

Stack ba — embedding local + expose MCP + phân tích cấp RAGFlow — quyết định "tôi chỉ dùng Notion AI" lật cho ai có lo ngại privacy hoặc > 5 GB doc nguồn.

## 2. Tổng Quan Kiến Trúc

```
   ┌────────────────────────────────────────────────────┐
   │ VPS ($10-25/tháng)                                 │
   │                                                    │
   │  ┌────────────────────────────────────────────┐   │
   │  │ AnythingLLM (web UI)                       │   │
   │  │   ↕                                         │   │
   │  │   Doc → pipeline embedding                 │   │
   │  └────────────┬───────────────────────────────┘   │
   │               │                                    │
   │   "PDF khó"   │  "doc dễ"                          │
   │       ↓       │       ↓                            │
   │  ┌─────────┐  │  ┌──────────────┐                  │
   │  │ RAGFlow │  │  │ (AnythingLLM │                  │
   │  │ parser  │  │  │  tích hợp)   │                  │
   │  └────┬────┘  │  └──────┬───────┘                  │
   │       └───────┴─────────┘                          │
   │               ↓                                    │
   │      ┌────────────────┐                            │
   │      │ Vector DB      │                            │
   │      │ (Chroma local) │                            │
   │      └────────┬───────┘                            │
   │               ↓                                    │
   │  ┌─────────────────────────────────┐               │
   │  │ Routing query                    │               │
   │  │   ├─► AnythingLLM chat UI       │               │
   │  │   ├─► mem0 (memory agent)        │               │
   │  │   └─► AgentMemory MCP server    │               │
   │  │         ↓                        │               │
   │  │    (Claude / Cursor / OpenCode)  │               │
   │  └─────────────────────────────────┘               │
   └────────────────────────────────────────────────────┘
```

Phân chia: AnythingLLM là cửa trước cho user, RAGFlow xử doc AnythingLLM parser vấp, vector DB là backend retrieval chia sẻ, mem0 + AgentMemory MCP expose cùng kiến thức cho AI coding agent.

## 3. Thành Phần 1 — AnythingLLM (Cửa Trước)

**Vai trò**: Cái bạn và team thực sự click vào. Upload doc, tổ chức workspace, chat với doc, quản lý user — tất cả trong một app self-host.

**Vì sao chọn**: 28k+ stars, container Docker đơn deploy 10 phút, có web UI tinh tế nhất trong các tool RAG mã nguồn mở. Hỗ trợ 40+ LLM provider làm chat backend (Ollama / DeepSeek / Claude / GPT-5 / OpenRouter) nên giữ linh hoạt chi phí.

**Cài nhanh**:
```bash
docker run -d --name anythingllm \
  -p 3001:3001 \
  -v anythingllm-storage:/app/server/storage \
  -e LLM_PROVIDER=ollama \
  -e EMBEDDING_ENGINE=native \
  mintplexlabs/anythingllm:latest
```

Mở `http://your-vps:3001`, tạo workspace, kéo PDF vào. Parser tích hợp xử 80% doc. Cho 20% còn lại, route sang RAGFlow (thành phần tiếp).

**Setup đầy đủ** bao gồm auth team, cấu trúc workspace, routing LLM provider: [Kiến trúc AnythingLLM local RAG](/vi/resources/llm-frameworks/anythingllm-architecture-local-rag/).

## 4. Thành Phần 2 — RAGFlow (Phân Tích Doc Sâu)

**Vai trò**: Khi parser tích hợp của AnythingLLM tạo rác cho doc cụ thể — PDF nhiều cột, paper scan, bảng phức tạp, paper học thuật nhiều công thức — RAGFlow vào.

**Vì sao chọn**: Parser "DeepDoc" của RAGFlow dùng vision model trên mỗi page, bảo toàn cấu trúc bảng (cell hợp nhất, hàng lồng), chunk doc theo khối ngữ nghĩa thay vì count token. Kết quả retrieval chính xác hơn 3-5× cho doc khó.

**Cài nhanh**:
```bash
docker compose -f https://github.com/infiniflow/ragflow/raw/main/docker/docker-compose.yml up -d
# Web UI :80, API :9380
```

**Pattern workflow**: AnythingLLM là daily driver. Khi chất lượng retrieval giảm cho doc cụ thể, xử lại qua RAGFlow, lưu chunk đã parse về vector DB chia sẻ.

**Setup RAGFlow đầy đủ** bao gồm tuning DeepDoc + tích hợp pipeline: [Hướng dẫn RAGFlow](/vi/resources/llm-frameworks/ragflow/).

## 5. Thành Phần 3 — mem0 (Layer Memory Agent)

**Vai trò**: Memory ngữ nghĩa bền vững sống qua các phiên chat và qua các agent. "Nhớ user đang dùng Tailwind v4 và auth ở `src/lib/auth.ts`" — và bất kỳ agent nào nói chuyện với mem0 đều có sự thật đó phiên sau, tháng sau, năm sau.

**Vì sao chọn**: 30k+ stars. Xây riêng cho memory agent (không phải vector DB tổng quát). Tự trích xuất sự thật từ hội thoại, dedupe, sự thật cũ tự nhiên suy giảm.

**Cài nhanh**:
```bash
pip install mem0ai
# Hoặc chạy như service:
docker run -d --name mem0 -p 8765:8765 \
  -e VECTOR_DB=chroma \
  mem0ai/mem0-server:latest
```

**Use case**: Kết nối mem0 làm layer writeback tới workspace AnythingLLM. Mỗi hội thoại chat tự chưng cất thành sự thật mem0. AI coding agent (thành phần tiếp) sau đó có cả corpus doc VÀ sự thật trích xuất từ hội thoại.

**Setup mem0 đầy đủ** bao gồm pick model embedding + tuning chính sách decay: [Hướng dẫn setup mem0](/vi/resources/llm-frameworks/mem0/).

## 6. Thành Phần 4 — AgentMemory MCP (Cầu Tới Coding Agent)

**Vai trò**: Expose mem0 (và tùy chọn vector DB AnythingLLM) tới bất kỳ MCP host — Claude Desktop, OpenCode, Cursor, Continue, Hermes Agent. Knowledge base bây giờ nói protocol mọi AI coding agent hiện đại hiểu.

**Vì sao quan trọng**: Không có MCP, tích hợp knowledge base tùy biến với từng AI coding tool yêu cầu code tùy biến per tool. Với AgentMemory MCP, bạn thêm một lần vào `claude_desktop_config.json` và mọi agent nhận thức MCP đều có.

**Cài nhanh**:
```bash
npm install -g @mem0/mem0-mcp
# Thêm vào OpenCode / Claude Desktop MCP config:
# { "agentmemory": { "command": "mem0-mcp", "env": { "MEM0_URL": "http://localhost:8765" } } }
```

**Kết quả**: Coding agent giờ có thể trả lời "dựa trên doc project và hội thoại quá khứ, tôi nên cấu trúc luồng auth mới thế nào?" — với trích dẫn từ cả PDF và quyết định trước.

**Setup đầy đủ** bao gồm cách chia sẻ AgentMemory MCP qua team: [Hướng dẫn AgentMemory MCP](/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/).

## 7. Thành Phần 5 — Pick Vector DB

**Vai trò**: Backend lưu embedding chia sẻ phía sau AnythingLLM, RAGFlow, và mem0.

**Ba pick khả thi** (so sánh đầy đủ: [So sánh Vector DB 2026](/vi/resources/llm-frameworks/vector-database-comparison/)):

- **Chroma** — Tốt nhất cho solo / team nhỏ. Đơn giản kiểu SQLite single-file. Chế độ embed = service phụ 0. Mặc định cho AnythingLLM
- **Qdrant** — Tốt nhất cho team production. Dựa Rust, latency sub-10ms, scale ngang. Docker compose xử
- **Weaviate** — Tốt nhất khi cần tìm kiếm hybrid (vector + keyword). Ops nặng hơn nhưng chế độ retrieval mạnh hơn

**Khuyến nghị mặc định**: Bắt đầu Chroma (đã bên trong AnythingLLM). Migrate tới Qdrant khi corpus > 100 GB hoặc latency query > 200ms.

```bash
# Qdrant khi vượt Chroma:
docker run -d --name qdrant -p 6333:6333 -p 6334:6334 \
  -v qdrant-storage:/qdrant/storage \
  qdrant/qdrant:latest
```

## 8. Thứ Tự Setup Day 1 (90 phút)

1. **Khởi động VPS** (10 phút) — Đặt {{< aff "digitalocean" "kb-vps" "DigitalOcean $12/tháng droplet" >}} (tier 8 GB; 4 GB quá chật cho parse + embed + LLM), cài Docker
2. **AnythingLLM trước** (15 phút) — Docker run đơn, browse tới :3001, tạo tài khoản admin + workspace đầu
3. **Upload 10 doc test** (10 phút) — PDF, .md note, .docx hỗn hợp — xem parser tích hợp AnythingLLM xử cái nào
4. **RAGFlow thứ hai** (20 phút) — docker compose, browse tới :80, xử lại 2-3 doc AnythingLLM vấp
5. **mem0 thứ ba** (10 phút) — pip install + chạy như service, trỏ vào instance Chroma AnythingLLM dùng
6. **AgentMemory MCP thứ tư** (10 phút) — npm install, thêm vào Claude Desktop / OpenCode config
7. **Test toàn pipeline** (15 phút) — Upload doc tới AnythingLLM → chat → mem0 bắt sự thật → hỏi cùng câu trong Claude Desktop qua MCP → trích dẫn cả hai nguồn

Sau 90 phút bạn có Glean tương đương cá nhân chạy trên droplet $12/tháng.

## 9. Phân Tích Chi Phí

| Item | Solo (10 GB doc) | Team nhỏ (10 GB, 5 user) | Org (100 GB, 50 user) |
|---|---|---|---|
| VPS | $12 (8 GB) | $24 (16 GB) | $120 (64 GB + replica) |
| AnythingLLM | $0 (self-host) | $0 | $0 |
| RAGFlow | $0 (self-host) | $0 | $0 |
| mem0 / AgentMemory MCP | $0 (self-host) | $0 | $0 |
| Vector DB (Chroma → Qdrant) | $0 | $0 | $0 (Qdrant self-host) |
| Embedding (Ollama bge-large local) | $0 | $0 | $0 |
| Chat LLM (DeepSeek rẻ, Claude khó) | $0-5 | $0-10 | $20-30 |
| Lưu trữ backup | $1 | $2 | $20 |
| **Tổng** | **~$13-18/tháng** | **~$26-36/tháng** | **~$160-170/tháng** |

So với SaaS tương đương:
- Solo: Notion AI ($10) + Mem.ai ($15) = $25/tháng, không thấy file local
- Team nhỏ: cùng × 5 user = $125/tháng
- Org: Glean Lite ~$30/user/tháng × 50 = $1,500/tháng

## 10. Đường Nâng Cấp

Khi vượt stack này:

- **Corpus > 1 TB hoặc > 10M doc** — Di chuyển Qdrant sang box 32 GB chuyên dụng, thêm sharding
- **Team đa khu vực** — Replicate AnythingLLM read replica ở nhiều khu vực, single write master trên {{< aff "htstack" "upgrade-hk-vps" "HTStack HK" >}} cho latency thân thiện Trung Quốc
- **Cần fulltext + vector hybrid** — Migrate vector DB từ Chroma sang Weaviate
- **Tuân thủ audit / SOC2** — Pair với Portkey cho gisibility cuộc gọi LLM (xem [So sánh LLM Gateway 2026](/vi/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/))
- **SaaS multi-tenant** — Thêm LiteLLM cho virtual-key-per-customer ([hướng dẫn LiteLLM](/vi/resources/llm-frameworks/litellm/))

## TL;DR — Recipe

**5 thành phần, $10-25/tháng cho solo-to-team-nhỏ**:
1. **AnythingLLM** — cửa trước + chat UI
2. **RAGFlow** — parser doc sâu (PDF khó)
3. **mem0** — layer memory agent
4. **AgentMemory MCP** — cầu tới coding agent
5. **Vector DB** (Chroma → Qdrant ở scale)

Thay $50-200/tháng SaaS (Notion AI + Mem + Glean Lite) bằng self-host bạn sở hữu. Setup 90 phút, native MCP nên mọi coding agent hưởng lợi.

Bật {{< aff "digitalocean" "footer-cta" "DigitalOcean $12/tháng droplet" >}} cho tier khởi đầu, theo mục 8, và knowledge base của bạn có thể query từ Claude Desktop / Cursor / OpenCode vào ngày mai.

---

*Bộ sưu tập đồng hành: [Workflow AI Coding Self-Host](/vi/collections/self-hosted-ai-coding-workflow/) cắm knowledge base này vào stack coding agent. [Stack LLM Rẻ](/vi/collections/cheap-llm-stack/) cover phía chi phí chat-LLM. [Stack Marketing AI Xuyên Biên Giới](/vi/collections/cross-border-ai-marketing-stack/) cho team Trung Quốc cần host thân thiện Trung Quốc.*
