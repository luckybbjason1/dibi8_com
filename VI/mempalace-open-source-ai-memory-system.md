---
title: 'MemPalace: Hệ thống bộ nhớ AI mã nguồn mở được benchmark tốt nhất, tiết kiệm 96.6% R@5 trên LongMemEval — Không gọi API'
description: 'MemPalace là hệ thống bộ nhớ AI ưu tiên cục bộ, lưu trữ lịch sử cuộc trò chuyện dưới dạng văn bản nguyên bản và truy xuất bằng tìm kiếm ngữ nghĩa. Tích hợp với Claude Code, Cursor, Windsurf và bất kỳ agent tương thích MCP. Backend ChromaDB, lưu trữ có thể tháo rời, không gọi API ngoài. Bao gồm hướng dẫn cài đặt, benchmark và phân tích kiến trúc.'
date: 2026-06-10
slug: 'mempalace-open-source-ai-memory-system'
category: 'llm-frameworks'
tags: ['ai-memory', 'local-first', 'mempalace', 'semantic-search', 'chromadb', 'long-term-memory', 'mcp-agent', 'verbatim-storage']
github_repo: 'https://github.com/MemPalace/mempalace'
stars: 55206
maintainer: 'MemPalace'
license: MIT
featureImage: 'https://opengraph.github.com/github/MemPalace/mempalace'
lang: vi
---

# MemPalace: Hệ thống bộ nhớ AI mã nguồn mở được benchmark tốt nhất, tiết kiệm 96.6% R@5 trên LongMemEval — Không gọi API

---

## Tóm tắt

MemPalace là hệ thống bộ nhớ AI ưu tiên cục bộ, lưu trữ lịch sử cuộc trò chuyện dưới dạng **văn bản nguyên bản** và truy xuất bằng tìm kiếm ngữ nghĩa. Nó đạt **96.6% R@5 raw** trên LongMemEval — điểm benchmark tốt nhất cho bất kỳ hệ thống bộ nhớ mã nguồn mở nào — với **không gọi API**. Nó được xây dựng cho các nhà phát triển muốn agent AI của họ nhớ mọi thứ mà không gửi dữ liệu đến bất kỳ dịch vụ bên ngoài nào.

|| Chỉ số | MemPalace | Mem0 | Memory Bank |
|--------|-----------|------|-------------|
|| Benchmark | 96.6% R@5 raw | 78.2% R@5 | 71.4% R@5 |
|| API Calls | 0 | 1-3 mỗi session | 5-8 mỗi session |
|| Lưu trữ | Ưu tiên cục bộ | Phụ thuộc cloud | Hybrid |
|| Cài đặt | `uv tool install mempalace` | `pip install mem0` | Chỉ Docker |

---

## Nó là gì

MemPalace giải quyết một vấn đề: **Agent AI quên những gì bạn đã nói với chúng vào tuần trước.**

Nó lưu trữ lịch sử cuộc trò chuyện của bạn dưới dạng văn bản nguyên bản — không tóm tắt, không trích xuất, không diễn giải. Index được cấu trúc: người và dự án trở thành *cánh (wings)*, chủ đề trở thành *phòng (rooms)*, và nội dung gốc sống trong *ngăn kéo (drawers)* — vì vậy tìm kiếm có thể được giới hạn phạm vi thay vì chạy trên một corpus phẳng.

Lớp truy xuất có thể thay thế. Mặc định hiện tại là **ChromaDB**; các backend khác có thể được thay thế mà không chạm vào phần còn lại của hệ thống. Không có gì rời khỏi máy của bạn trừ khi bạn chọn tham gia.

**Khả năng chính:**
- Lưu trữ nguyên bản lịch sử cuộc trò chuyện
- Tìm kiếm ngữ nghĩa với index cấu trúc (wings/rooms/drawers)
- Backend có thể thay thế (mặc định ChromaDB, hỗ trợ backend tùy chỉnh)
- 96.6% R@5 raw trên benchmark LongMemEval
- Không gọi API bên ngoài
- Tích hợp với Claude Code, Cursor, Windsurf và bất kỳ agent tương thích MCP nào

---

## Cách hoạt động (30 giây)

```
Cuộc trò chuyện của bạn → Index MemPalace (Local)
                         ↓
                Truy vấn tìm kiếm ngữ nghĩa
                         ↓
              Ngữ cảnh được truy xuất (Wings/Rooms/Drawers)
                         ↓
              Agent nhận được Bộ nhớ Cấu trúc
```

MemPalace hoạt động trên ba lớp:

**Lớp 1 — Lưu trữ:** Mọi cuộc trò chuyện được lưu trữ nguyên bản. Không xử lý AI, không tóm tắt. Văn bản gốc được giữ nguyên chính xác như khi viết.

**Lớp 2 — Index:** Cuộc trò chuyện được cấu trúc thành một knowledge graph. Người và dự án trở thành *cánh*, chủ đề trở thành *phòng*, và nội dung gốc sống trong *ngăn kéo*. Index cấu trúc này cho phép tìm kiếm theo phạm vi thay vì tìm kiếm trên corpus phẳng.

**Lớp 3 — Truy xuất:** Khi agent cần ngữ cảnh, nó truy vấn lớp truy xuất có thể thay thế (mặc định: ChromaDB). Kết quả được trả về dưới dạng ngữ cảnh cấu trúc, không phải văn bản thô.

Lớp truy xuất sử dụng tìm kiếm ngữ nghĩa với hybrid keyword boosting. Mặc định, MemPalace sử dụng ChromaDB với mô hình embedding `all-MiniLM-L6-v2`, nhưng bạn có thể thay thế bất kỳ backend nào triển khai giao diện `mempalace/backends/base.py`. Điều này bao gồm:

- `chromadb`: Backend mặc định, tốt cho hầu hết các trường hợp sử dụng
- `qdrant`: Nhanh hơn cho tập dữ liệu lớn, hỗ trợ lọc
- `weaviate`: Sẵn sàng sản xuất, hỗ trợ truy vấn GraphQL
- Backend tùy chỉnh: Triển khai giao diện cơ sở cho bất kỳ vector database nào

---

## Auto-Save Hooks

MemPalace có thể tự động lưu các cuộc trò chuyện từ các agent được hỗ trợ. Đối với Claude Code, bạn cần cấu hình auto-save hooks:

```bash
# Bật auto-save cho Claude Code
mempalace hooks enable claude-code

# Xem các hooks hiện tại
mempalace hooks list

# Test các hooks
mempalace hooks test
```

Các hooks hoạt động bằng cách intercept các session của agent và tự động lưu chúng vào memory palace của bạn. Điều này có nghĩa là bạn không cần phải lưu thủ công các cuộc trò chuyện — chúng được persist khi bạn làm việc.

---

## Yêu cầu

- Python 3.9+
- `uv` hoặc `pip` để cài đặt
- ~500MB dung lượng disk cho embedding model và index ban đầu
- ~500MB RAM cho hoạt động ChromaDB (nhiều hơn cho tập dữ liệu lớn)

---

## Quickstart (60 giây)

Cài đặt MemPalace trong môi trường biệt lập để tránh lỗi PEP 668:

```bash
# Khuyến nghị: uv tool install (biệt lập trên PATH của bạn)
uv tool install mempalace

# Khởi tạo cho dự án của bạn
mempalace init ~/projects/myapp

# Bắt đầu Claude Code với mempalace hooks
claude
```

Hoặc sử dụng pipx:

```bash
pipx install mempalace
mempalace init ~/projects/myapp
```

Hoặc trong virtualenv (nếu bạn muốn `import mempalace` khả dụng):

```bash
python -m venv .venv && source .venv/bin/activate
pip install mempalace
mempalace init ~/projects/myapp
```

---

## Khi nào sử dụng / Khi nào bỏ qua

**Phù hợp nếu bạn…**
- Chạy AI coding agents hàng ngày và muốn bộ nhớ bền bỉ giữa các session
- Làm việc trên nhiều agent và muốn chia sẻ bộ nhớ qua MCP
- Cần truy xuất nguyên bản — bản gốc luôn có thể truy xuất
- Muốn không gọi API bên ngoài để bảo mật

**Bỏ qua nếu bạn…**
- Chỉ sử dụng native memory của một provider và không cần cross-agent sync
- Làm việc trong môi trường sandboxed nơi không thể chạy local processes
- Cần chia sẻ bộ nhớ dựa trên cloud giữa các thành viên trong team

---

## Benchmarks

MemPalace đạt **96.6% R@5 raw** trên LongMemEval — điểm benchmark tốt nhất cho bất kỳ hệ thống bộ nhớ mã nguồn mở nào.

### Kết quả LongMemEval

|| Mode | R@5 | LLM Required | API Calls |
|------|-----|--------------|-----------|
|| **MemPalace (Raw)** | **96.6%** | None | 0 |
|| MemPalace (Hybrid v4) | 98.4% | None | 0 |
|| MemPalace (Hybrid + LLM Rerank) | ≥99% | Any capable model | 1 |
|| Memory Bank (OpenAI) | 78.2% | Claude/GPT | 3-5 |
|| Mem0 | 71.4% | Claude/GPT | 1-2 |
|| Direct LLM Context | 65.3% | N/A | N/A |

*Nguồn: [LongMemEval benchmark](https://github.com/MemPalace/mempalace) — measured trên task retrieval tài liệu 10K, khoảng tin cậy 95%.*

### Tại sao 96.6% quan trọng

Hầu hết các hệ thống bộ nhớ đạt điểm thông qua **context expansion** — nhồi nhét nhiều token hơn vào window. MemPalace đạt điểm thông qua **structured retrieval**: wings → rooms → drawers. Bạn không hỏi "tất cả những gì tôi từng nói", bạn hỏi "tất cả về person X trong project Y".

96.6% raw yêu cầu **không cần API key, không cloud, và không LLM ở bất kỳ giai đoạn nào**. Pipeline hybrid thêm keyword boosting, temporal-proximity boosting, và preference-pattern extraction; con số 98.4% được giữ lại là hình ảnh tổng quát hóa trung thực.

---

## Knowledge Graph Architecture

Structured memory graph là bí mật của MemPalace.

```
                    [Wing: Person]
                   /              \
           [Room: Project A]   [Room: Project B]
              /     \               |
        [Drawer: #1] [Drawer: #2] [Drawer: #3]
         (original)  (original)   (original)
```

**Cách hoạt động:**

1. **Wings** = Người, tổ chức, hoặc dự án lớn
2. **Rooms** = Chủ đề, tính năng, hoặc workstreams trong một wing
3. **Drawers** = Đoạn hội thoại gốc

Cấu trúc này cho phép tìm kiếm theo phạm vi:

```bash
# Tìm kiếm trên tất cả wings
mempalace search "auth implementation"

# Tìm kiếm trong một wing cụ thể
mempalace search "auth" --wing "Person-A"

# Tìm kiếm trong một room
mempalace search "auth" --wing "Person-A" --room "Project-A"
```

### Backup và Restore

Vì MemPalace lưu trữ dữ liệu cục bộ, bạn nên backup memory thường xuyên:

```bash
# Backup memory palace của bạn
mempalace backup ~/backups/mempalace-$(date +%Y-%m-%d).tar.gz

# Restore từ backup
mempalace restore ~/backups/mempalace-2026-06-10.tar.gz

# Tự động backup với cron
0 2 * * * mempalace backup ~/backups/mempalace-$(date +\%Y-\%m-\%d).tar.gz
```

Backup bao gồm tất cả các file memory, cấu hình, và cached embedding model. Bạn có thể restore sang máy khác bằng cách sao chép backup và chạy `mempalace init` để đăng ký dữ liệu đã restore.

---

## MCP Server Integration

MemPalace bao gồm một MCP server tích hợp để sử dụng với Claude Code, Cursor, và các agent tương thích MCP khác.

```bash
# Bắt đầu MCP server
mempalace mcp --port 8765

# Trong Claude Code config (~/.claude/settings.json):
{
  "mcpServers": {
    "mempalace": {
      "command": "mempalace",
      "args": ["mcp", "--port", "8765"]
    }
  }
}
```

MCP server expose:
- `mempalace_store`: Lưu segment hội thoại
- `mempalace_query`: Truy xuất ngữ cảnh qua tìm kiếm ngữ nghĩa
- `mempalace_list_wings`: Liệt kê các wing khả dụng
- `mempalace_list_rooms`: Liệt kê các room trong một wing

---

## Sâu hơn: Python API

Nếu bạn không sử dụng các agent tương thích MCP, bạn có thể sử dụng Python API của MemPalace trực tiếp:

```python
import mempalace

# Initialize memory store
memory = mempalace.Store("~/projects/myapp")

# Store a conversation segment
memory.store({
    "role": "user",
    "content": "How do I implement OAuth2 with Google?"
})
memory.store({
    "role": "assistant", 
    "content": "You'll need to create a Google Cloud project..."
})

# Query for relevant context
results = memory.query("OAuth2 Google implementation")
for result in results:
    print(f"[{result.wing}/{result.room}]: {result.content[:200]}")

# List all wings
for wing in memory.list_wings():
    print(f"Wing: {wing.name} ({len(wing.rooms)} rooms)")
```

Python API mirror CLI nhưng cho bạn access lập trình đến memory graph. Điều này hữu ích cho:
- Tích hợp agent tùy chỉnh
- Batch processing lịch sử hội thoại
- Xây dựng dashboards trên memory của bạn
- Auto backup workflows

---

## Docker Deployment

Cho server-side hoặc containerized deployments:

```bash
# Build Docker image
docker build -t mempalace-server .

# Chạy MCP server trong Docker
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server \
  mcp --port 8765
```

Mọi thứ persist dưới `/data` (palace, config, và cached embedding model), vì vậy mount một volume ở đó. Setup này hoạt động tốt cho:
- Chia sẻ bộ nhớ team (nhiều machine truy cập cùng database)
- CI/CD pipelines cần agent memory
- Môi trường production với Docker orchestration

---

## So sánh với các lựa chọn thay thế

|| Tính năng | MemPalace | Mem0 | Memory Bank | Local RAG |
|---------|-----------|------|-------------|-----------|
|| Verbatim Storage | ✓ | ✗ | ✗ | ✗ |
|| Structured Index | Wings/Rooms/Drawers | Flat vector | Chat history | Embeddings |
|| API Required | 0 | 1-3 | 5-8 | 0 |
|| Local First | ✓ | ✗ | ✗ | ✓ |
|| MCP Server | Built-in | Plugin | No | No |
|| Benchmark | 96.6% R@5 | 78.2% | 71.4% | N/A |
|| Stars | 55,206 | 12,400 | 8,900 | 18,200 |

Cách tiếp cận có cấu trúc của MemPalace (wings → rooms → drawers) là yếu tố thúc đẩy benchmark 96.6%. Các hệ thống khác sử dụng flat vector search hoặc token-expanding context windows, vốn chạm giới hạn thực tế ở ~200K tokens.

## Giới hạn / Đánh giá trung thực

MemPalace không phải dành cho mọi người:

- **Không dành cho cloud teams**: Nếu bạn cần chia sẻ bộ nhớ giữa các thành viên team làm việc trên các máy khác nhau, thiết kế local-first của MemPalace không giúp được
- **Yêu cầu môi trường Python**: Cài đặt cần `uv` hoặc `pip` với phiên bản Python tương thích
- **ChromaDB mặc định**: Mặc dù có thể thay thế, nhưng hầu hết người dùng sẽ dùng ChromaDB yêu cầu ~500MB RAM cho embedding model
- **Không backup cloud**: Memory của bạn ở lại local. Nếu disk hỏng, memory của bạn mất (trừ khi bạn đã backup)

Nó được xây dựng cho **các nhà phát triển cá nhân** muốn có bộ nhớ bền bỉ, riêng tư cho AI agents của họ.

---

## Các trường hợp sử dụng thực tế

### Trường hợp 1: Persistent Coding Context

```bash
# Start a new Claude Code session
claude

# Claude Code automatically queries MemPalace for relevant context
# when you ask about previous work on the same feature
> "Remember when we implemented OAuth2 last week?"
> [MemPalace retrieves: Wing "Person-A" → Room "Project-A" → Drawer: #3]
```

Trường hợp sử dụng này hoàn hảo cho các nhà phát triển làm việc trên các dự án dài hạn và cần AI agent của họ nhớ các implement trước đó, quyết định, và constraints.

### Trường hợp 2: Research Context

```bash
# Store research notes from your agent
mempalace store "Research: LangGraph vs LangChain for agent orchestration"
mempalace store "Key finding: LangGraph has better state management..."

# Later, query for all research notes
mempalace search "agent orchestration comparison" --wing "Research"
```

Hoàn hảo cho các nhà nghiên cứu muốn duy trì một knowledge base có thể search được giữa nhiều session nghiên cứu.

### Trường hợp 3: Team Knowledge Base

```bash
# Chia sẻ memory giữa các thành viên team (Docker deployment)
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server mcp --port 8765

# Mỗi thành viên team kết nối đến shared memory server
# với các mức truy cập khác nhau cho mỗi project
```

Dành cho các team cần chia sẻ bộ nhớ nhưng muốn duy trì data privacy và control.

---

## Câu hỏi thường gặp

### Câu hỏi 1: MemPalace có lưu dữ liệu của tôi trên cloud không?
Không. MemPalace là local-first. Lịch sử cuộc trò chuyện, memory index, và embeddings của bạn đều ở lại trên máy của bạn. Không có API calls nào được thực hiện đến các dịch vụ bên ngoài theo mặc định.

### Câu hỏi 2: Tôi có thể sử dụng MemPalace với bất kỳ AI agent nào không?
Có, nếu nó hỗ trợ MCP (Model Context Protocol). Claude Code, Cursor, Windsurf, và các agent tương thích MCP khác hoạt động ngay lập tức. Đối với các agent không MCP, bạn có thể sử dụng Python API trực tiếp.

### Câu hỏi 3: Benchmark 96.6% so với các hệ thống bộ nhớ khác như thế nào?
96.6% R@5 raw của MemPalace trên LongMemEval là điểm benchmark tốt nhất cho các hệ thống bộ nhớ mã nguồn mở. Hầu hết các đối thủ cạnh tranh đạt 70-80% thông qua context expansion (lưu nhiều token hơn), không phải structured retrieval.

### Câu hỏi 4: Tôi có thể chuyển backend từ ChromaDB không?
Có. Lớp truy xuất có thể thay thế. Mặc định là ChromaDB, nhưng bạn có thể thay thế bất kỳ backend nào triển khai `mempalace/backends/base.py`. Hỗ trợ custom backends.

### Câu hỏi 5: Xảy ra gì nếu tôi xóa các file memory của mình?
Vì MemPalace là local-first, không có cloud recovery nào. Nếu bạn xóa các file memory của mình, dữ liệu bị mất trừ khi bạn đã backup thủ công. Cân nhắc thiết lập auto backup nếu memory của bạn có giá trị.

---

## Nguồn & Đọc thêm

- Tài liệu chính thức: [mempalaceofficial.com](https://mempalaceofficial.com)
- GitHub repository: [MemPalace/mempalace](https://github.com/MemPalace/mempalace)
- Benchmarks: [benchmarks/BENCHMARKS.md](https://github.com/MemPalace/mempalace/blob/main/benchmarks/BENCHMARKS.md)
- Kết quả LongMemEval: [96.6% R@5 raw](https://github.com/MemPalace/mempalace#benchmarks)
- MCP server docs: [mempalaceofficial.com/concepts/the-palace](https://mempalaceofficial.com/concepts/the-palace.html)

---

## Kết luận: Xây dựng AI Agents thực sự có bộ nhớ

MemPalace giải quyết vấn đề "goldfish agent". Nó lưu trữ lịch sử cuộc trò chuyện của bạn nguyên bản, index nó có cấu trúc, và truy xuất nó với độ chính xác 96.6% — với không gọi API.

**Thử ngay:**

```bash
uv tool install mempalace
mempalace init ~/projects/myapp
```

Cho self-hosted memory trên VPS hoặc dedicated server, hãy xem xét sử dụng [HTStack](https://my.htstack.com/aff.php?aff=27187) cho GPU hosting giá cả phải chăng, hoặc [DigitalOcean](https://m.do.co/c/eca87ac14ee0) cho cloud deployment dễ dàng.

Tham gia **nhóm Telegram tiếng Việt dibi8** https://t.me/DIBI8_Group/18 để thảo luận về các hệ thống bộ nhớ AI, kiến trúc agent, và các công cụ mã nguồn mở.

Các bài viết liên quan:
- [LangChain Complete Guide](dibi8-internal-link/llm-frameworks/langchain-complete-guide)
- [Vector Database Comparison](dibi8-internal-link/data-science/vector-database-comparison)
- [MCP Deep Dive](dibi8-internal-link/llm-frameworks/mcp-deep-dive)

*Một số liên kết trên là affiliate links. dibi8.com có thể nhận hoa hồng nếu bạn đăng ký, không tốn thêm chi phí cho bạn. Điều này giúp duy trì website và nội dung miễn phí.*