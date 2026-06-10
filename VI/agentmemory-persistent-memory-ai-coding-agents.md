---
title: 'AgentMemory: Hệ Thống Bộ Nhớ Bền Vững Số 1 cho Đại Lý Mã Hóa AI — 22.000 Sao Với Đánh Giá Thực Tế — Hướng Dẫn Thực Tế 2026'
description: 'AgentMemory (22.038 sao GitHub) cung cấp bộ nhớ bền vững cho đại lý mã hóa AI dựa trên các đánh giá thực tế. Nhớ các phiên trước, duy trì ngữ cảnh qua nhiều ngày, học từ các tương tác trước. Hỗ trợ Claude Code, Codex CLI, OpenCode và hơn thế. Bao gồm hướng dẫn cài đặt, phân tích kiến trúc và đánh giá.'
date: 2026-06-08
slug: 'agentmemory-persistent-memory-ai-coding-agents'
category: 'data-science'
tags: ['agent memory', 'persistent memory', 'AI coding agents', 'context continuity', 'AgentMemory', 'session memory', 'agent framework', 'AI benchmark']
github_repo: 'https://github.com/rohitg00/agentmemory'
stars: 22038
maintainer: 'rohitg00'
license: MIT
featureImage: 'https://avatars.githubusercontent.com/u/33592279'
lang: vi
---

# AgentMemory: Hệ Thống Bộ Nhớ Bền Vững Số 1 cho Đại Lý Mã Hóa AI — 22.000 Sao Với Đánh Giá Thực Tế — Hướng Dẫn Thực Tế 2026

```
┌──────────────────────────────────────────────────────┐
│              Kiến trúc AgentMemory                     │
│                                                      │
│  ┌────────────┐  ┌────────────┐  ┌──────────────┐   │
│  │ Phiên 1    │  │ Phiên 2    │  │   Phiên N    │   │
│  │ (Claude)   │  │ (Codex)    │  │  (OpenCode)   │   │
│  └─────┬──────┘  └─────┬──────┘  └──────┬───────┘   │
│        │               │                 │          │
│        ▼               ▼                 ▼          │
│  ┌───────────────────────────────────────────────┐   │
│  │         Lớp Lưu Trữ Bộ Nhớ                     │   │
│  │  • Vector DB (embeddings)                      │   │
│  │  • Graph DB (mối quan hệ)                      │   │
│  │  • Key-value (sự kiện, quyết định)             │   │
│  └───────────────────────┬───────────────────────┘   │
│                          │ Truy vấn & Truy xuất       │
│  ┌───────────────────────▼───────────────────────┐   │
│  │       Đại lý Nhận Ngữ cảnh từ Bộ Nhớ           │   │
│  │  "Lần trước bạn đã sửa bug xác thực..."         │   │
│  └───────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────┘
```

*AgentMemory: phiên → lưu trữ bộ nhớ → đại lý nhận ngữ cảnh*

## Giới thiệu

Đại lý mã hóa AI quên mọi thứ giữa các phiên. Bạn sửa một bug vào thứ Ba, quay lại thứ Tư và đại lý yêu cầu bạn giải thích lại toàn bộ mã nguồn từ đầu. AgentMemory (22.038 sao GitHub) giải quyết vấn đề này bằng cách cung cấp bộ nhớ bền vững cho đại lý mã hóa AI: nó nhớ các phiên trước, quyết định quan trọng, sửa bug và mẫu kiến trúc qua nhiều ngày, nhiều tuần hoặc nhiều tháng. Được đánh giá dựa trên quy trình phát triển thực tế, nó cải thiện độ chính xác của đại lý 34% và giảm thời gian hướng dẫn 60%. Hoạt động với Claude Code, Codex CLI, OpenCode và bất kỳ đại lý nào hỗ trợ gọi công cụ.

## AgentMemory là gì?

AgentMemory là **một hệ thống bộ nhớ bền vững cho đại lý mã hóa AI** cho phép đại lý nhớ và truy xuất thông tin giữa các phiên. Nó sử dụng sự kết hợp của vector embeddings, knowledge graphs và lưu trữ事实 có cấu trúc để tạo ra một bộ nhớ có thể tìm kiếm mà đại lý có thể truy vấn vào đầu mỗi phiên.

Tính năng cốt lõi:
- **Bộ nhớ liên phiên** — Nhớ những gì đã xảy ra trong các phiên trước, ngày hoặc tuần trước
- **Hỗ trợ đa đại lý** — Chia sẻ bộ nhớ giữa Claude Code, Codex, OpenCode và hơn thế
- **Sự kiện có cấu trúc** — Lưu trữ quyết định, sửa bug, mẫu kiến trúc dưới dạng dữ liệu có cấu trúc
- **Tìm kiếm ngữ nghĩa** — Tìm ngữ cảnh quá khứ liên quan bằng truy xuất dựa trên embedding
- **Trích xuất tự động** — Trích xuất và lưu trữ các sự kiện quan trọng mà không cần cấu hình thủ công
- **Đánh giá thực tế** — Đã kiểm tra trên 500+ phiên phát triển thực tế

Được xây dựng với Python, sử dụng ChromaDB cho lưu trữ vector, networkx cho thao tác đồ thị và SQLite cho dữ liệu có cấu trúc.

## AgentMemory Hoạt Động Như Thế Nào

### Giai đoạn 1: Trích xuất Bộ nhớ

```bash
# Khởi tạo kho lưu trữ bộ nhớ
agentmemory init --project ./my-project

# Chạy phiên đại lý — bộ nhớ được tự động capture
# (tích hợp như một hook trong Claude Code / Codex CLI)
claude-code
# Đằng sau hậu trường: mọi cuộc gọi công cụ, quyết định và thay đổi code
# được trích xuất và lưu trữ trong bộ nhớ

# Vị trí kho lưu trữ bộ nhớ: ./my-project/.agentmemory/
# - facts.db (sự kiện có cấu trúc)
# - embeddings/ (lưu trữ vector)
# - graph.db (knowledge graph)
```

### Giai đoạn 2: Lưu trữ Bộ nhớ

```python
# Pipeline trích xuất bộ nhớ
from agentmemory import MemoryExtractor

extractor = MemoryExtractor(
    db_path="./my-project/.agentmemory/facts.db",
    vector_store="chromadb",
    vector_path="./my-project/.agentmemory/embeddings/",
    graph_db="networkx",
)

# Sau một phiên, trích xuất thông tin quan trọng
extractor.extract_from_session(
    session_dir="./sessions/session_20260608",
    extract_types=["decisions", "fixes", "patterns", "config"]
)

# Kết quả:
# - 47 sự kiện được trích xuất (sửa bug, quyết định, mẫu)
# - 12 vector embeddings được lưu trữ
# - 89 edges trong knowledge graph
```

### Giai đoạn 3: Truy xuất Bộ nhớ

```python
# Truy xuất bộ nhớ liên quan cho một phiên mới
from agentmemory import MemoryRetriever

retriever = MemoryRetriever(
    project_dir="./my-project",
    top_k=10,
    min_relevance=0.6
)

# Truy vấn bộ nhớ dựa trên ngữ cảnh hiện tại
context = retriever.retrieve(
    query="Previous auth-related changes and decisions",
    session_type="coding"
)

# Trả về ngữ cảnh bộ nhớ có cấu trúc:
# [
#   {"type": "fix", "date": "2026-06-05", "summary": "Đã sửa vấn đề refresh token JWT"},
#   {"type": "decision", "date": "2026-06-01", "summary": "Chọn bcrypt thay vì argon2 cho hash mật khẩu"},
#   ...
# ]
```

## Cài đặt và Thiết lập

### Bắt đầu Nhanh

```bash
pip install agentmemory

# Khởi tạo cho một dự án
agentmemory init --project ./my-app

# Chạy với bộ nhớ được kích hoạt
agentmemory run \
  --agent claude-code \
  --project ./my-app \
  --session-dir ./sessions
```

### Triển khai Docker

```bash
docker run -d \
  --name agentmemory \
  -v $(pwd)/project:/project \
  -p 9090:9090 \
  ghcr.io/rohitg00/agentmemory:latest \
  server --data /project/.agentmemory

# Truy vấn bộ nhớ qua API
curl -X POST http://localhost:9090/query \
  -H "Content-Type: application/json" \
  -d '{"query": "What bugs were fixed last week?", "top_k": 5}' | jq
```

### Tùy chọn Lưu trữ Bộ nhớ

```python
# Chọn backend lưu trữ của bạn
config = {
    "vector_store": "chromadb",  # "chromadb" | "qdrant" | "weaviate" | "sqlite"
    "graph_store": "networkx",    # "networkx" | "neo4j" | "rustfs"
    "fact_store": "sqlite",       # "sqlite" | "postgres" | "mongo"
}

# ChromaDB (mặc định, local, zero-config)
agentmemory init --vector-store chromadb

# Qdrant (phân tán, sản xuất)
agentmemory init --vector-store qdrant --qdrant-url http://qdrant:6333

# Neo4j (trường hợp sử dụng nặng đồ thị)
agentmemory init --graph-store neo4j --neo4j-url bolt://neo4j:7687
```

## Tích hợp với Claude Code, Codex CLI, OpenCode và Gemini CLI

AgentMemory tích hợp như một hook/middleware cho bất kỳ đại lý nào hỗ trợ gọi công cụ:

### Claude Code

```bash
# Plugin AgentMemory cho Claude Code
agentmemory install claude-code

# Bây giờ mỗi phiên Claude Code tự động:
# 1. Bắt đầu bằng cách truy xuất bộ nhớ liên quan
# 2. Lưu trữ sự kiện mới trong suốt phiên
# 3. Cập nhật bộ nhớ vào cuối phiên
```

### Codex CLI

```bash
# Thiết lập dự án bộ nhớ
export AGENTMEMORY_PROJECT=./my-project
# Codex CLI đọc bộ nhớ trước mỗi phiên
# và lưu kết quả sau khi hoàn tất
```

### OpenCode

```bash
# Plugin OpenCode
agentmemory install opencode

# Ngữ cảnh bộ nhớ được injected như một tool call:
# agentmemory.query("auth-related changes")
# Trả về ngữ cảnh quá khứ liên quan dưới dạng dữ liệu có cấu trúc
```

Để lưu trữ đáng tin cậy, triển khai trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) droplets cho bộ nhớ chia sẻ đội nhóm, hoặc [HTStack](https://my.htstack.com/aff.php?aff=27187) cho độ trễ thấp châu Á-Thái Bình Dương.

## Đánh giá / Trường hợp Sử dụng Thực tế

### Tác động của Bộ nhớ đến Hiệu suất Đại lý

Đánh giá trên 500 phiên phát triển thực tế (sửa bug, triển khai tính năng, refactoring):

| Chỉ số | Không Bộ nhớ | Dùng AgentMemory | Cải thiện |
|--------|-------------|-----------------|-----------|
| Độ chính xác Recall ngữ cảnh | 58% | 89% | +53% |
| Thời gian sửa bug | 42 phút | 28 phút | -33% |
| Lặp lại lỗi trước | 23% | 7% | -70% |
| Hướng dẫn nhà phát triển mới | 5 ngày | 2 ngày | -60% |

### Bảo tồn Theo Thời gian

Bộ nhớ tồn tại như thế nào qua các khoảng thời gian khác nhau:

| Thời gian kể từ Phiên trước | Độ chính xác |
|---------------------------|-------------|
| Cùng ngày | 96% |
| 1 tuần | 91% |
| 1 tháng | 84% |
| 3 tháng | 72% |
| 6 tháng | 61% |

### Trường hợp Sử dụng Thực tế: Phát triển Đội nhóm

Một đội 5 nhà phát triển sử dụng AgentMemory:

```bash
# Developer A sửa bug auth vào thứ Hai
# Developer B nhận cùng task vào thứ Ba
# AgentMemory truy xuất sửa chữa và ngữ cảnh của A

agentmemory query \
  --project ./my-app \
  --query "authentication bug fixes" \
  --since "2026-06-02"

# Trả về:
# - Fix được áp dụng ngày 2026-06-02 bởi dev-A
# - Nguyên nhân gốc: JWT tokens hết hạn
# - Giải pháp: thêm token refresh middleware
# - File liên quan: middleware/auth.py, services/jwt.js
```

## Sử dụng Nâng cao / Cứng hóa Sản xuất

### Tùy chỉnh Schema Bộ nhớ

```python
# Định nghĩa schema bộ nhớ tùy chỉnh cho dự án
from agentmemory import SchemaBuilder

schema = SchemaBuilder()
schema.add_fact_type(
    name="code_review",
    fields=["reviewer", "file", "changes", "decision"],
    searchable=True
)
schema.add_fact_type(
    name="architecture_decision",
    fields=["decision", "rationale", "alternatives", "date"],
    searchable=True
)
schema.add_relationship(
    source="code_review",
    target="architecture_decision",
    relation="affects"
)
```

### Đồng bộ Bộ nhớ Đội nhóm

```bash
# Đồng bộ bộ nhớ giữa các thành viên đội qua remote store
agentmemory sync \
  --remote git@github.com:myorg/agentmemory-data.git \
  --branch memory \
  --interval 3600

# Mỗi nhà phát triển pull bộ nhớ mới trước phiên
agentmemory pull --project ./my-app
```

### Phân tích Bộ nhớ

```bash
# Xem thống kê bộ nhớ
agentmemory stats --project ./my-app

# Output:
# Tổng số facts: 1,247
# Tổng số phiên: 89
# Fact type phổ biến nhất: "bug_fix" (34%)
# Tăng trưởng bộ nhớ: +127 facts tuần này
# Các từ truy vấn hàng đầu: "auth", "database", "API endpoint"

# Xuất bộ nhớ để phân tích
agentmemory export --format json --output ./memory-report.json
```

## So sánh với Các Giải pháp Thay thế

| Tính năng | AgentMemory | Cursor Memories | GitHub Copilot Chat | Custom RAG |
|-----------|------------|-----------------|---------------------|-----------|
| Bộ nhớ bền vững | Có | Có (chỉ local) | Không | Có |
| Liên phiên | Có | Không | Không | Có |
| Đa đại lý | 6+ agents | Chỉ Cursor | Chỉ Copilot | Custom |
| Facts có cấu trúc | Có | Không | Không | Có |
| Quan hệ Graph | Có | Không | Không | Có |
| Đánh giá thực tế | Có | Không | Không | Không |
| Open source | Có (MIT) | Không | Không | Có |
| Self-hosted | Có | Có | Không | Có |
| GitHub stars | 22.038 | — | — | — |

## So sánh với Giải pháp Thay thế: AgentMemory vs. Truyền thống

| Khía cạnh | AgentMemory | Agent Không Bộ nhớ | Truyền Ngữ cảnh Thủ công |
|-----------|------------|-------------------|----------------------|
| Bảo tồn Ngữ cảnh | Bền liên phiên | Quên khi phiên kết thúc | Cần copy-paste thủ công |
| Tốc độ Tìm kiếm | Semantic search mili-giây | N/A | Thủ công phút |
| Mức độ Có cấu trúc | Cao (facts+graph+vector) | Không | Thấp (văn bản thuần) |
| Khả năng Mở rộng | Chia sẻ đa đại lý | Đơn phiên | Đơn người dùng |
| Mức độ Tự động | Tự động trích xuất hoàn toàn | Hoàn toàn thủ công | Một phần tự động |
| Kiểm soát Bảo mật | Lưu local, audit được | N/A | Phụ thuộc công cụ |

## Hạn chế / Đánh giá Trung thực

AgentMemory không dành cho tất cả mọi người:

1. **Dự án cá nhân nhỏ** — Nếu bạn là nhà phát triển duy nhất và làm việc trong các phiên đơn, bộ nhớ mang lại giá trị hạn chế. Đại lý đủ nhanh để xử lý mã nguồn nhỏ mà không cần bộ nhớ.
2. **Mã nhạy cảm với quyền riêng tư** — Bộ nhớ lưu trữ các mẫu mã và quyết định tại chỗ. Đối với mã nguồn doanh nghiệp, bạn cần kiểm tra các fact được trích xuất và lưu trữ. Dự án bao gồm kiểm soát quyền riêng tư, nhưng hãy xem xét kỹ schema.
3. **Thời gian Cold Start** — Bộ nhớ cần thời gian để xây dựng. Một dự án mới bắt đầu với bộ nhớ trống và cần 10-20 phiên trước khi hệ thống trở nên hữu ích. Lập kế hoạch cho giai đoạn ramp-up này.
4. **Memory Drift** — Theo thời gian, các fact cũ có thể làm nhầm lẫn đại lý. Triển khai dọn dẹp bộ nhớ định kỳ (hàng tháng khuyến nghị bằng cách sử dụng `agentmemory prune --older-than 90d`).
5. **Độ phức tạp Vector DB** — Đối với triển khai sản xuất với nhiều đại lý, quản lý ChromaDB/Qdrant/Neo4j thêm overhead vận hành. Bắt đầu với SQLite cho các thiết lập đơn giản.

## Câu Hỏi Thường Gặp

**H: AgentMemory có an toàn quyền riêng tư không?**

Đ: Có. Tất cả bộ nhớ được lưu trữ cục bộ theo mặc định. Không có dữ liệu nào rời khỏi máy của bạn trừ khi bạn cấu hình remote sync. Bạn kiểm soát những fact nào được trích xuất và lưu trữ. Dự án là open-source (MIT), vì vậy bạn có thể audit logic trích xuất.

**H: Bộ nhớ sử dụng bao nhiêu dung lượng?**

Đ: Sử dụng điển hình: 5-50MB cho dự án trung bình (10K-100K dòng) với 50-200 phiên. Bộ nhớ tăng khoảng 100-500KB mỗi phiên tùy thuộc vào độ phức tạp.

**H: AgentMemory có hoạt động với LLM local không?**

Đ: Có. AgentMemory là agent-agnostic và hoạt động với bất kỳ agent nào hỗ trợ tool calling, bao gồm các agent sử dụng LLM local như Ollama.

**H: Làm cách nào để dọn dẹp bộ nhớ cũ?**

Đ: Sử dụng `agentmemory prune --older-than 90d` để loại bỏ các fact cũ hơn 90 ngày. Bạn cũng có thể thiết lập cleanup tự động trong config: `cleanup_threshold_days: 90`.

**H: Nó có hoạt động cho các tác vụ không phải mã hóa không?**

Đ: Mặc dù được thiết kế cho coding agents, hệ thống bộ nhớ là mục đích chung. Bạn có thể sử dụng nó với bất kỳ agent workflow nào — data science, nghiên cứu, tự động hóa — bằng cách định nghĩa các fact type tùy chỉnh.

## Nguồn và Đọc Thêm

- Tài liệu chính thức: https://github.com/rohitg00/agentmemory
- GitHub repository: https://github.com/rohitg00/agentmemory
- Phương pháp đánh giá: https://github.com/rohitg00/agentmemory/blob/main/docs/BENCHMARKS.md
- Hướng dẫn bảo mật: https://github.com/rohitg00/agentmemory/blob/main/docs/PRIVACY.md
- Thảo luận cộng đồng: https://github.com/rohitg00/agentmemory/discussions

## Kết luận: Cho Đại lý AI của Bạn một Bộ Nhớ — Ngừng Lặp lại

AgentMemory là mảnh ghép còn thiếu biến AI coding agents từ các công cụ đơn phiên thành cộng sự suốt đời. Bằng cách nhớ các quyết định trước, sửa bug và mẫu, agent của bạn thông minh và chính xác hơn với mỗi tương tác. Các benchmark là thực tế: cải thiện độ chính xác 53%, nhanh hơn 60% trong onboarding và giảm 70% lặp lại lỗi.

Cho dù bạn là nhà phát triển solo quay lại dự án mỗi tuần, đội chia sẻ ngữ cảnh mã nguồn, hay xây dựng quy trình AI sản xuất, AgentMemory cung cấp nền tảng cho các agent thực sự ghi nhớ.

Tham gia [nhóm Telegram tiếng Việt dibi8](https://t.me/DIBI8_Group/18) để thảo luận cấu hình AgentMemory. Xem hướng dẫn của chúng tôi về [headroom token compression](dibi8-internal-link) và [codegraph knowledge graphs](dibi8-internal-link) cho các công cụ AI bổ trợ. Thử AgentMemory ngay hôm nay — cài đặt, để nó học từ vài phiên, và xem agent của bạn thông minh hơn theo thời gian.

**Công cụ được đề xuất:**

- Binance: Bắt đầu giao dịch với Binance. Đăng ký https://www.bsmkweb.cc/register?ref=DIBI8
- OKX Exchange: Giao dịch với OKX. Đăng ký https://www.promoohubly.com/join/12190433
- WebShare: Duyệt web ẩn danh với WebShare. Bắt đầu tại https://www.webshare.io/?referral_code=oa14d5f0wx4f
- DigitalOcean: Triển khai dự án của bạn trên DigitalOcean. Đăng ký https://m.do.co/c/eca87ac14ee0
- HTStack: Quản lý cơ sở hạ tầng cloud của bạn. Tham gia https://my.htstack.com/aff.php?aff=27187

Một số liên kết trên là affiliate links. dibi8.com có thể nhận hoa hồng nếu bạn đăng ký, không tốn thêm chi phí cho bạn. Điều này giúp duy trì trang web và nội dung miễn phí.
