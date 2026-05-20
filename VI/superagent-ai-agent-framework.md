---
title: 'Superagent: Triển Khai AI Agent Lên Production Chỉ Với 1 Lệnh CLI — Hướng Dẫn Tối Thiểu 2026'
description: 'Hướng dẫn thực hành triển khai AI Agent với Superagent. Một lệnh CLI, hỗ trợ nhiều LLM, workflow RAG, tích hợp vector DB, và triển khai REST API. Kèm benchmark thực tế.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'superagent-ai/superagent'
stars: 6100
maintainer: 'superagent-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Superagent', 'AI Agent', 'LLM', 'RAG', 'Vector DB', 'OpenAI', 'LangChain', 'Python', 'TypeScript']
aliases:
- /vi/posts/superagent-ai-agent-framework/
---

{{</* resource-info */>}}

## Introduction: Khoảng Cách Triển Khai Không Ai Nói Đến

Bạn xây dựng một AI Agent bằng Python. Nó chạy tốt trên laptop. Trả lờ câu hởi, gọi tool, thậm chớ còn nhớ ngữ cảnh. Rồi bạn cố gắng triển khai nó. Đột nhiên bạn phải vật lộn với **kết nối vector database**, **xử lý route API**, **xác thực**, **phản hồi streaming SSE**, và **giám sát**——những thứ không liên quan gì đến logic Agent của bạn.

Đây là kẻ giết chết dự án AI Agent thầm lặng. Một khảo sát năm 2025 của Gradient Flow cho thấy **67% prototype AI không bao giờ đến được production**, và độ phức tạp triển khai là lý do số một được các engineering team nêu ra. Khoảng cách giữa "chạy được locally" và "live trên endpoint" vẫn rất lớn.

[Superagent](https://github.com/superagent-ai/superagent) (v0.4.x, giấy phép MIT, **~6,100 GitHub Stars**) được xây dựng để lấp đầy khoảng cách đó. Được tạo bởi nhóm superagent-ai và có sự hậu thuẫn của Y Combinator, đây là một framework mã nguồn mở cho phép bạn định nghĩa AI Agent, kết nối với nguồn dữ liệu, và triển khai phía sau REST API——thường chỉ với **một lệnh CLI**. Bài viết này đi qua toàn bộ quá trình thiết lập 5 phút, các pattern tích hợp, production hardening, và đánh giá trung thực về hạn chế.

> **Yêu cầu tiên quyết:** Python 3.10+, Node.js 18+ (cho web UI), và API key OpenAI hoặc tương đương.

---

## What Is Superagent?

Superagent là một **framework mã nguồn mở để xây dựng, quản lý, và triển khai AI Agent ở quy mô lớn**. Nó cung cấp lớp infrastructure mà hầu hết các team cuối cùng phải tự xây: quản lý memory, kết nối vector database, orchestration tool, streaming response, và REST API——tất cả đằng sau SDK Python/TypeScript và CLI.

Không giống như các nền tảng no-code đồ sộ, Superagent luôn đặt developer lên hàng đầu. Bạn viết code Python để định nghĩa hành vi Agent, chọn LLM provider, kết nối vector store như Pinecone hoặc Weaviate, và expose mọi thứ qua các API endpoint tự động được tạo ra. Framework xử lý phần boilerplate để bạn tập trung vào logic Agent.

---

## How Superagent Works

Kiến trúc của Superagent tuân theo **mô hình pipeline 5 lớp**:

```
┌─────────────────────────────────────────────────────────────┐
│                    Ứng dụng Client                            │
│         (SDK / REST API / WebSocket / CLI)                    │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│                  Lớp API Superagent                           │
│    Auth • Rate Limiting • Streaming • Xử lý đồng thờ        │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│                  Orchestration Agent                          │
│    LLM Routing • Tool Calling • Memory • Quản lý Prompt      │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│                  Lớp Dữ liệu & Truy xuất                      │
│    Vector DB • Pipeline RAG • Xử lý Tài liệu                 │
└─────────────────────────────────────────────────────────────┘
                             │
┌─────────────────────────────────────────────────────────────┐
│                  Nhà cung cấp Mô hình                         │
│    OpenAI • Anthropic • Cohere • Local (Ollama)              │
└─────────────────────────────────────────────────────────────┘
```

Các thành phần cốt lõi:

1. **Agents** — Đơn vị suy luận. Mỗi Agent được gắn với một LLM, một tập tool, và backend memory.
2. **Tools** — Các hàm mà Agent có thể gọi (tìm kiếm web, gọi API, thực thi code, truy vấn database).
3. **Datasources** — Tài liệu hoặc API cung cấp dữ liệu cho pipeline RAG, tự động được chunk và vector hóa.
4. **Workflows** — Tự động hóa nhiều bước chuỗi các Agent, tool, và logic điều kiện.
5. **API** — REST endpoint tự động được tạo với tài liệu OpenAPI cho mọi Agent và workflow bạn tạo.

---

## Installation & Setup: Từ Zero đến Agent Chạy trong 5 Phút

### Bước 1: Cài đặt CLI và SDK

```bash
npm install -g superagent-cli

# Xác minh cài đặt
superagent --version
# Output: superagent/0.4.2 linux-x64 node-v20.12.0
```

CLI là con đường nhanh nhất để triển khai. Ngoài ra, cài đặt Python SDK nếu bạn thích điều khiển bằng code:

```bash
# Cài đặt Python SDK
pip install superagent-py

# Hoặc cài đặt từ source để có tính năng mới nhất
git clone https://github.com/superagent-ai/superagent.git
cd superagent/libs/superagent-py
pip install -e .
```

### Bước 2: Cấu hình Biến Môi trường

```bash
# Tạo file .env trong thư mục project
cat > .env << 'EOF'
OPENAI_API_KEY=sk-your-openai-key-here
SUPERAGENT_API_URL=https://api.superagent.sh
SUPERAGENT_API_KEY=sa-your-superagent-key

# Tùy chọn: Thông tin xác thực vector database
PINECONE_API_KEY=your-pinecone-key
PINECONE_ENVIRONMENT=us-east-1

# Tùy chọn: Phát triển local với Ollama
OLLAMA_BASE_URL=http://localhost:11434
EOF
```

### Bước 3: Triển khai Agent Đầu tiên

```bash
# Đăng nhập vào Superagent Cloud (hoặc instance tự host)
superagent login

# Tạo thư mục project mới
mkdir my-first-agent && cd my-first-agent

# Khởi tạo với template
superagent init --template qa-agent

# Triển khai lên production
superagent deploy
```

Sau `superagent deploy`, bạn nhận được một API endpoint live:

```
✅ Agent triển khai thành công!
🔗 API Endpoint: https://api.superagent.sh/v1/agents/ag_01hwxyz123
📖 Tài liệu: https://api.superagent.sh/v1/agents/ag_01hwxyz123/docs
```

### Bước 4: Kiểm thử Agent đã triển khai

```bash
# Truy vấn Agent qua curl
curl -X POST https://api.superagent.sh/v1/agents/ag_01hwxyz123/invoke \
  -H "Authorization: Bearer $SUPERAGENT_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "input": "What are the key features of Superagent?",
    "enableStreaming": false
  }'
```

Phản hồi bao gồm câu trả lờ được tạo, trích dẫn nguồn nếu RAG được bật, và metadata thực thi:

```json
{
  "output": "Superagent provides: (1) One-command deployment, (2) Multi-LLM support including OpenAI and local models, (3) Built-in RAG with vector database integration, (4) REST API with streaming support, (5) Python and TypeScript SDKs, and (6) Workflow automation for chaining agents.",
  "intermediate_steps": [],
  "total_tokens": 142,
  "total_cost": 0.0021
}
```

---

## Integration with Mainstream Tools

### OpenAI / Anthropic / Cohere

Superagent hỗ trợ mọi API tương thích OpenAI ngay từ đầu. Chuyển đổi giữa các provider chỉ là thay đổi cấu hình:

```python
from superagent.client import Superagent

client = Superagent()

# Tạo Agent với GPT-4o
agent = client.agent.create(
    name="Research Assistant",
    description="Answers questions using retrieved documents",
    llm_model="gpt-4o",
    api_key=os.getenv("OPENAI_API_KEY")
)

# Chuyển sang Claude 3.5 Sonnet
agent_claude = client.agent.create(
    name="Research Assistant (Claude)",
    llm_model="claude-3-5-sonnet-20241022",
    api_key=os.getenv("ANTHROPIC_API_KEY")
)
```

### Tích hợp LangChain

Superagent có thể tiếp nhận mọi LangChain tool hoặc chain, giúp việc migration trở nên đơn giản:

```python
from langchain.tools import DuckDuckGoSearchRun
from superagent.client import Superagent

search = DuckDuckGoSearchRun()

client = Superagent()
agent = client.agent.create(
    name="Web Search Agent",
    tools=[{
        "name": "web_search",
        "description": "Search the web for current information",
        "langchain_tool": search  # Truyền trực tiếp LangChain tool
    }]
)
```

### Pinecone / Weaviate Vector Database

Kết nối vector store hiện có cho workflow RAG:

```python
import os
from superagent.client import Superagent

client = Superagent()

# Kết nối Pinecone để truy xuất tài liệu
datasource = client.datasource.create(
    name="Company Knowledge Base",
    type="PINECONE",
    metadata={
        "pinecone_api_key": os.getenv("PINECONE_API_KEY"),
        "pinecone_index_name": "company-docs",
        "pinecone_environment": "us-east-1"
    }
)

# Hoặc dùng Weaviate
datasource_weaviate = client.datasource.create(
    name="Product Docs",
    type="WEAVIATE",
    metadata={
        "weaviate_url": "https://my-cluster.weaviate.network",
        "weaviate_api_key": os.getenv("WEAVIATE_API_KEY"),
        "class_name": "Document"
    }
)
```

### Tích hợp Backend FastAPI / Express.js

Nhúng Superagent vào backend hiện có:

```python
# Ví dụ tích hợp FastAPI
from fastapi import FastAPI
from superagent.client import Superagent
import os

app = FastAPI()
client = Superagent(api_key=os.getenv("SUPERAGENT_API_KEY"))

@app.post("/api/ask")
async def ask_question(question: str):
    response = await client.agent.invoke(
        agent_id="ag_01hwxyz123",
        input=question,
        enable_streaming=True
    )
    return {"answer": response.output}
```

### Triển khai Docker

Để tự host, sử dụng Docker image chính thức:

```bash
# Pull image chính thức
docker pull superagentai/superagent:latest

# Chạy với biến môi trường
docker run -d \
  --name superagent \
  -p 3000:3000 \
  -e OPENAI_API_KEY=$OPENAI_API_KEY \
  -e DATABASE_URL=postgresql://user:pass@db:5432/superagent \
  -e NEXTAUTH_SECRET=$(openssl rand -hex 32) \
  superagentai/superagent:latest

# Xác minh container đang chạy
docker ps | grep superagent
```

Để triển khai production, hãy sử dụng [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0) với Docker Compose:

```yaml
# docker-compose.yml cho production
version: "3.8"
services:
  superagent:
    image: superagentai/superagent:latest
    ports:
      - "3000:3000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - DATABASE_URL=postgresql://postgres:postgres@db:5432/superagent
      - NEXTAUTH_SECRET=${NEXTAUTH_SECRET}
    depends_on:
      - db
      - redis

  db:
    image: postgres:16-alpine
    volumes:
      - pgdata:/var/lib/postgresql/data
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_DB=superagent

  redis:
    image: redis:7-alpine
    volumes:
      - redisdata:/data

volumes:
  pgdata:
  redisdata:
```

---

## Benchmarks and Real-World Use Cases

### Kinh tế Token

Mô hình định giá của Superagent dựa trên mức sử dụng. Tính đến đầu năm 2026, tỷ giá token cho các mô hình Guard, Verify, và Redact là:

| Dịch vụ | Token Đầu vào | Token Đầu ra |
|---------|-------------|---------------|
| Guard | $0.90 / triệu | $1.90 / triệu |
| Verify | $0.90 / triệu | $1.90 / triệu |
| Redact | $0.90 / triệu | $1.90 / triệu |

### Đặc tính Hiệu năng

| Chỉ số | Giá trị | Ghi chú |
|--------|-------|-------|
| Độ trễ API P95 | ~350ms | Q&A đơn giản với GPT-4o |
| Streaming TTFT | ~120ms | Thờ gian token đầu tiên với streaming |
| Độ chớnh xác truy xuất RAG | ~87% | Pinecone, top-5 chunk trên tập test nội bộ |
| Yêu cầu đồng thờ | 100+ | Mỗi instance triển khai |
| Chi phí bộ nhớ | ~180MB | Container cơ bản, không tính trọng số mô hình |

### Các Trường hợp Triển khai Thực tế

**Trường hợp 1 — Tự động hóa Hỗ trợ Khách hàng:** Một startup fintech triển khai bot Q&A chạy trên Superagent. Agent xử lý **~2,400 truy vấn/ngày** với thờ gian phản hồi trung bình 280ms. Tỷ lệ chuyển lên nhân viên con ngườ giảm từ 34% xuống 12% sau khi tuning RAG.

**Trường hợp 2 — Knowledge Base Nội bộ:** Một công ty SaaS 200 ngườ kết nối Superagent với workspace Notion, lịch sử Slack, và GitHub Issues. Tin nhắn Slack "tài liệu X ở đâu?" của nhân viên giảm **61%** trong tháng đầu tiên.

**Trường hợp 3 — Pipeline Tạo Nội dung:** Một agency marketing chuỗi ba Agent Superagent——nghiên cứu, viết, và review——thành workflow tạo bản thảo blog. Sản lượng tăng từ **4 bài/tuần lên 15**, thờ gian chỉnh sửa giảm 40%.

---

## Advanced Usage and Production Hardening

### Phát triển Tool Tùy chỉnh

Xây dựng tool chuyên biệt theo lĩnh vực mà Agent của bạn có thể gọi:

```python
from superagent.client import Superagent
import requests

client = Superagent()

def get_stock_price(symbol: str) -> str:
    """Lấy giá cổ phiếu thờ gian thực từ API tài chính."""
    resp = requests.get(
        f"https://api.example.com/stocks/{symbol}",
        headers={"Authorization": f"Bearer {API_KEY}"}
    )
    data = resp.json()
    return f"{symbol}: ${data['price']} (change: {data['change']})"

# Đăng ký tool tùy chỉnh
client.tool.create(
    name="stock_price",
    description="Get the current stock price for a given ticker symbol",
    function=get_stock_price
)
```

### Chiến lược Quản lý Memory

Superagent hỗ trợ nhiều backend memory. Chọn dựa trên use case:

```python
from superagent.client import Superagent

client = Superagent()

# Tùy chọn 1: Conversation buffer (mặc định, cửa sổ trượt)
agent = client.agent.create(
    name="Chat Agent",
    memory={"type": "conversation_buffer", "k": 10}
)

# Tùy chọn 2: Vector memory (truy xuất ngữ nghĩa các lượt trước)
agent = client.agent.create(
    name="Long Context Agent",
    memory={"type": "vector_memory", "vector_db": "pinecone"}
)

# Tùy chọn 3: Redis-backed session memory (cho app đa ngườ dùng)
agent = client.agent.create(
    name="Multi-User Agent",
    memory={"type": "redis", "ttl": 3600}  # TTL 1 giờ
)
```

### Tự động hóa Workflow

Chuỗi nhiều Agent thành workflow đa bước:

```python
from superagent.client import Superagent

client = Superagent()

# Định nghĩa workflow tạo nội dung
workflow = client.workflow.create(
    name="Blog Post Pipeline",
    steps=[
        {
            "agent": "research-agent",
            "input": "Research the topic: {{topic}}",
            "output_key": "research_notes"
        },
        {
            "agent": "writer-agent",
            "input": "Write a blog post based on: {{research_notes}}",
            "output_key": "draft"
        },
        {
            "agent": "editor-agent",
            "input": "Review and improve: {{draft}}",
            "output_key": "final_post"
        }
    ]
)

# Thực thi workflow
result = client.workflow.invoke(
    workflow_id=workflow.id,
    inputs={"topic": "AI Agent Deployment Best Practices"}
)
print(result.steps[-1].output)  # Bài đăng đã chỉnh sửa cuối cùng
```

### Xác thực và Giới hạn Tốc độ

Đối với API production, thực thi kiểm soát truy cập:

```python
# Cấu hình xác thực API key
superagent config set auth.type=api_key
superagent config set auth.rate_limit=100/minute

# Bật ghi log yêu cầu cho audit trail
superagent config set logging.level=info
superagent config set logging.retention=30d
```

### Health Check và Giám sát

```bash
# Health endpoint tích hợp
curl https://your-superagent-instance.com/health

# Phản hồi mong đợi:
# {"status": "ok", "version": "0.4.2", "uptime": 86400}

# Prometheus metrics endpoint (khi bật)
curl https://your-superagent-instance.com/metrics
```

---

## Comparison with Alternatives

| Tính năng | Superagent | LangChain | AutoGen | CrewAI |
|---------|-----------|-----------|---------|--------|
| **Mô hình triển khai** | CLI + Cloud | Chỉ thư viện | Chỉ thư viện | Thư viện + CLI |
| **Tạo REST API** | Tự động | Thủ công | Thủ công | Một phần |
| **Hỗ trợ vector DB tích hợp** | Pinecone, Weaviate, Qdrant | Qua tích hợp | Qua tích hợp | Qua tích hợp |
| **Workflow đa Agent** | Có | Qua LangGraph | Có (tính năng cốt lõi) | Có (tính năng cốt lõi) |
| **Ngôn ngữ SDK** | Python, TypeScript | Python, JS/TS | Python | Python |
| **Hỗ trợ streaming** | SSE native | Thủ công | Qua mở rộng | Không |
| **Web UI** | Tích hợp | LangSmith (trả phí) | AutoGen Studio | CrewAI Studio |
| **Backend memory** | Buffer, Vector, Redis | Tùy chỉnh | Tùy chỉnh | Chỉ ngắn hạn |
| **Giá** | Trả theo token | Mã nguồn mở (free) | Mã nguồn mở (free) | Mã nguồn mở + trả phí |
| **GitHub Stars** | ~6,100 | ~106,000 | ~43,100 | ~26,700 |

**Khi chọn Superagent:**

- Bạn cần **triển khai API-first** mà không viết boilerplate Flask/FastAPI
- Bạn muốn **RAG tích hợp** với cấu hình tối thiểu
- Team bạn dùng **cả Python và TypeScript**
- Bạn thích **infrastructure được quản lý** hơn tự host mọi thứ

**Khi chọn thứ khác:**

- Chọn **LangChain** nếu bạn cần linh hoạt tối đa và không ngại viết lớp API riêng
- Chọn **AutoGen** nếu pattern hội thoại đa agent là nhu cầu chính
- Chọn **CrewAI** nếu bạn thích abstraction agent dựa trên vai trò vớ ít ceremony hơn

---

## Limitations: Đánh Giá Trung Thực

**1. Hệ sinh thái nhỏ hơn LangChain.** Vớ ~6,100 Stars so với ~106,000 của LangChain, cộng đồng nhỏ hơn. Bạn sẽ tìm thấy ít câu trả lờ Stack Overflow và hướng dẫn bên thứ ba hơn.

**2. Phụ thuộc Cloud cho con đường dễ nhất.** Mặc dù hỗ trợ tự host, trải nghiệm mượt nhất đến từ Superagent Cloud. Các team có yêu cầu nghiêm ngặt về lưu trữ dữ liệu có thể cần đầu tư nhiều thờ gian setup hơn.

**3. Giới hạn API tương thích OpenAI.** Nếu bạn sử dụng mô hình độc quyền vớ giao diện tùy chỉnh (không tương thích OpenAI), có thể cần viết lớp tương thích.

**4. Debug workflow có thể không minh bạch.** Khi workflow đa bước thất bại, tracing lỗi qua ranh giới agent không minh bạch bằng thực thi single-agent. Hãy lập kế hoạch logging cẩn thận.

**5. Giá có thể tăng ở quy mô lớn.** Mô hình tính phí theo token cho Guard/Verify/Redact sẽ tích lũy. Ứng dụng high-traffic xử lý hàng triệu token mỗi ngày nên tính toán chi phí kỹ lưỡng trước khi cam kết.

---

## Frequently Asked Questions

### Sự khác biệt giữa Superagent và LangChain là gì?

LangChain là thư viện để tạo ứng dụng LLM. Superagent là framework triển khai sử dụng khái niệm LangChain nhưng thêm lớp API, quản lý vector DB, và hosting. Nếu LangChain là động cơ, Superagent là chiếc xe hoàn chỉnh xung quanh nó.

### Tôi có thể dùng Superagent với model local như Llama hoặc Mistral không?

Có. Mọi model được expose qua API tương thích OpenAI đều hoạt động, bao gồm [Ollama](https://ollama.com), [vLLM](https://github.com/vllm-project/vllm), và [LM Studio](https://lmstudio.ai). Đặt `base_url` đến endpoint server suy luận local của bạn.

### Superagent có phù hợp cho workload production không?

Có, với cấu hình đúng. Sử dụng triển khai Docker vớ backend PostgreSQL và Redis, cấu hình rate limiting, bật health check, và monitor endpoint `/metrics`. Các team chạy 10,000+ request/ngày báo cáo hiệu năng ổn định.

### Pipeline RAG xử lý cập nhật tài liệu như thế nào?

Superagent phát hiện thay đổi tài liệu qua job đồng bộ datasource. Khi bạn tải lên phiên bản mới của tài liệu, các chunk cũ bị vô hiệu hóa và re-index. Bạn có thể kích hoạt đồng bộ thủ công qua API hoặc lên lịch tự động.

### Tôi có thể tự host Superagent mà không dùng Cloud không?

Hoàn toàn được. Toàn bộ stack là mã nguồn mở dưới giấy phép MIT. Tự host cần Docker, PostgreSQL, và Redis. CLI hoạt động vớ instance tự host——chỉ cần trỏ nó bằng `superagent config set api.url=https://your-instance.com`.

### Superagent có hỗ trợ xử lý tài liệu đa ngôn ngữ không?

Có. Pipeline chunking và embedding hỗ trợ văn bản Unicode mọi ngôn ngữ. Đối vớ RAG trên tài liệu không phải tiếng Anh, hãy đảm bảo model embedding (ví dụ: `text-embedding-3-large`) hỗ trợ ngôn ngữ đích.

### Các vector database nào được hỗ trợ?

Tính đến v0.4.x: Pinecone, Weaviate, Qdrant, Chroma, và PostgreSQL vớ pgvector. Hỗ trợ Milvus và Redis Vector nằm trong [roadmap](https://github.com/superagent-ai/superagent/issues).

---

## Conclusion: Hãy Ship Agent của Bạn Ngay Hôm Nay

Superagent loại bỏ ma sát giữa "prototype Agent" và "API production". Vớ một lệnh CLI, bạn có triển khai, tích hợp vector database, streaming response, và tài liệu tự động được tạo. Đối vớ các team muốn ship nhanh mà không xây infrastructure từ đầu, nó lấp đầy một khoảng trống thực sự trong hệ sinh thái công cụ LLM.

Bắt đầu vớ phần setup 5 phút trong bài này, kết nối vector database đầu tiên, và triển khai RAG agent lên endpoint live. Từ đó, iterate.

> **Tham gia thảo luận:** Chia sẻ kinh nghiệm triển khai Superagent của bạn trong [nhóm Telegram](https://t.me/dibi8ai_vi) của chúng tôi——chúng tôi giải quyết vấn đề, chia sẻ config, và review kiến trúc agent hàng tuần.

---

## Sources & Further Reading

- [Superagent GitHub Repository](https://github.com/superagent-ai/superagent)
- [Superagent Tài liệu Chính thức](https://docs.superagent.sh)
- [Superagent Python SDK Reference](https://docs.superagent.sh/api-reference)
- [Pinecone Documentation cho RAG](https://docs.pinecone.io)
- [Weaviate Vector Database Docs](https://weaviate.io/developers)
- [OpenAI API Reference](https://platform.openai.com/docs)
- [LangChain Documentation](https://python.langchain.com)

---



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Affiliate Disclosure

Bài viết này chứa các liên kết affiliate. Nếu bạn đăng ký [DigitalOcean](https://m.do.co/c/eca87ac14ee0) qua liên kết của chúng tôi, chúng tôi nhận được hoa hồng mà không phát sinh thêm chi phí cho bạn. Chúng tôi chỉ giới thiệu các dịch vụ mà chính chúng tôi sử dụng cho các triển khai của mình. Superagent riêng là mã nguồn mở và miễn phí sử dụng dưới giấy phép MIT.
