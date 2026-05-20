---
title: 'LlamaIndex: 49K+ Stars — Hướng Dẫn Triển Khai RAG Production 2026'
description: 'LlamaIndex là framework dữ liệu để xây dựng hệ thống RAG production với LLM. Hỗ trợ OpenAI, Anthropic, Ollama, Qdrant, Weaviate, Chroma. Bao gồm triển khai Docker, query engine, agent, và benchmark so với LangChain/Haystack/RAGFlow.'
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
github_repo: 'https://github.com/run-llama/llama_index'
stars: 49517
maintainer: 'run-llama'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['llamaindex', 'rag', 'llm', 'vector-database', 'retrieval-augmented-generation', 'openai', 'ollama', 'qdrant', 'python', 'docker']
aliases:
- /vi/posts/llamaindex/
---

{{</* resource-info */>}}

![LlamaIndex Logo](https://raw.githubusercontent.com/run-llama/llama_index/main/docs/docs/_static/assets/LlamaSquareBlack.svg)

## Giới Thiệu

Hầu hết các tutorial RAG dừng lại ở Jupyter Notebook. Bạn tải một file PDF, gọi `VectorStoreIndex.from_documents()`, nhận được câu trả lởi hay, và nghĩ rằng xong việc. Rồi bạn thử triển khai nó——bước embedding mất 40 phút khi khởi động, container crash vì index không được persist, và bạn không biết tài liệu nào thực sự được truy xuất cho câu trả lởi mà ngườ dùng phàn nàn.

LlamaIndex đã âm thầm trở thành framework dữ liệu được lựa chọn cho các team xây dựng hệ thống RAG production. Với **49,517 GitHub stars**, **1,866 contributors**, và tốc độ release đạt phiên bản 0.14.22 vào tháng 5/2026, dự án phát triển rất nhanh. Hướng dẫn này đi qua việc xây dựng pipeline RAG cấp production với LlamaIndex: từ triển khai Docker đến định tuyến query, giám sát và củng cố hệ thống. Dù bạn đang đánh giá **llamaindex vs langchain** hay cần một **llamaindex tutorial** bao gồm các vấn đề triển khai thực tế, bài viết này cung cấp đầy đủ.

## LlamaIndex Là Gì?

**LlamaIndex** là một framework dữ liệu mã nguồn mở kết nối các mô hình ngôn ngữ lớn (LLM) với nguồn dữ liệu bên ngoài thông qua các pipeline Retrieval-Augmented Generation (RAG). Nó cung cấp công cụ cho việc tải dữ liệu, lập chỉ mục, truy vấn và điều phối agent, với hơn 160 data connector và tích hợp native với các vector database và LLM provider chính.

Ban đầu tập trung vào indexing (như tên gọi), LlamaIndex đã mở rộng thành một nền tảng đầy đủ để xây dựng ứng dụng agentic. Framework xử lý ingestion pipeline, nhiều loại index, query engine với routing, và event-driven workflow. Tất cả các thành phần đều được cấp phép MIT và có sẵn trên PyPI.

## LlamaIndex Hoạt Động Như Thế Nào

### Kiến Trúc Cốt Lõi

LlamaIndex phân tách trách nhiệm thành bốn lớp:

1. **Tải Dữ Liệu** — `SimpleDirectoryReader` và 160+ LlamaHub connector phân tích PDF, database, API, và cloud storage thành các đối tượng `Document`.
2. **Lập Chỉ Mục** — Documents được chia thành `Node`. Embeddings được đưa vào các index (`VectorStoreIndex`, `SummaryIndex`, `TreeIndex`, `KnowledgeGraphIndex`).
3. **Truy Vấn** — `QueryEngine`, `ChatEngine`, và `RouterQueryEngine` xử lý retrieval, post-processing, và response synthesis.
4. **Agent & Workflow** — Các lớp `Workflow` dựa trên sự kiện và agent tools cho phép suy luận đa bước với hỗ trợ human-in-the-loop.

![RAG Architecture](https://cdn.hashnode.com/res/hashnode/image/upload/v1724944925051/e525c6cb-6a99-4eec-8b47-3dc827ddff25.png)

### Các Quyết Định Thiết Kế Chính

- **Node thay vì raw documents**: Chunking xảy ra trước khi indexing, cho phép điều chỉnh overlap và size theo từng use case.
- **StorageContext abstraction**: Index có thể persist sang disk, S3, hoặc bất kỳ vector store nào mà không cần thay đổi code.
- **Composable retrievers**: Vector + keyword + graph retrievers kết hợp qua `RouterQueryEngine`.
- **Async-first**: `.aquery()` và async ingestion là native, không phải gắn thêm.

## Cài Đặt & Thiết Lập

### Cài Đặt Cơ Bản

```bash
# Tạo môi trường ảo
python -m venv venv && source venv/bin/activate

# Cài đặt framework core
pip install llama-index

# Cài đặt các tích hợp cụ thể
pip install llama-index-vector-stores-qdrant
pip install llama-index-llms-openai
pip install llama-index-embeddings-openai
```

### Thiết Lập Môi Trường

```bash
# File .env
export OPENAI_API_KEY="sk-..."
export OPENAI_EMBEDDING_MODEL="text-embedding-3-large"

# Cho LLM local
export OLLAMA_BASE_URL="http://localhost:11434"
```

### Pipeline RAG Đầu Tiên

```python
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader

# Tải documents
documents = SimpleDirectoryReader("./data").load_data()

# Xây dựng vector index
index = VectorStoreIndex.from_documents(documents)

# Tạo query engine
query_engine = index.as_query_engine()

# Truy vấn
response = query_engine.query("What are the key takeaways?")
print(response)
```

### Persist Index

```python
import os
from llama_index.core import StorageContext, load_index_from_storage

PERSIST_DIR = "./storage"

if not os.path.exists(PERSIST_DIR):
    documents = SimpleDirectoryReader("./data").load_data()
    index = VectorStoreIndex.from_documents(documents)
    index.storage_context.persist(persist_dir=PERSIST_DIR)
else:
    storage_context = StorageContext.from_defaults(persist_dir=PERSIST_DIR)
    index = load_index_from_storage(storage_context)
```

Pattern này tránh việc tính toán lại embeddings mỗi khi restart. Với corpus 10,000 documents, điều này tiết kiệm 6+ phút và chi phí API mỗi lần deploy.

## Tích Hợp Với Các Công Phổ Biến

### OpenAI / Anthropic

```python
from llama_index.llms.openai import OpenAI
from llama_index.embeddings.openai import OpenAIEmbedding
from llama_index.core import Settings

Settings.llm = OpenAI(model="gpt-4o-mini")
Settings.embed_model = OpenAIEmbedding(model="text-embedding-3-large")

index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()
```

### Ollama (LLM Local)

```python
from llama_index.llms.ollama import Ollama
from llama_index.embeddings.ollama import OllamaEmbedding
from llama_index.core import Settings

Settings.llm = Ollama(model="llama3.2", request_timeout=60.0)
Settings.embed_model = OllamaEmbedding(model_name="nomic-embed-text")

index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()
```

### Qdrant (Vector Database)

```python
from llama_index.vector_stores.qdrant import QdrantVectorStore
from llama_index.core import StorageContext
import qdrant_client

client = qdrant_client.QdrantClient(url="http://localhost:6333")
vector_store = QdrantVectorStore(client=client, collection_name="my_docs")
storage_context = StorageContext.from_defaults(vector_store=vector_store)

index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

### Weaviate

```python
from llama_index.vector_stores.weaviate import WeaviateVectorStore
import weaviate

client = weaviate.Client(url="http://localhost:8080")
vector_store = WeaviateVectorStore(weaviate_client=client, index_name="Documents")
storage_context = StorageContext.from_defaults(vector_store=vector_store)

index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

### Chroma

```python
from llama_index.vector_stores.chroma import ChromaVectorStore
import chromadb

chroma_client = chromadb.PersistentClient(path="./chroma_db")
chroma_collection = chroma_client.get_or_create_collection("docs")
vector_store = ChromaVectorStore(chroma_collection=chroma_collection)
storage_context = StorageContext.from_defaults(vector_store=vector_store)

index = VectorStoreIndex.from_documents(documents, storage_context=storage_context)
```

## Benchmark / Use Case Thực Tế

### Benchmark Hiệu Suất RAG

Các benchmark độc lập từ 2025-2026 trên corpus 10,000 documents với GPT-4o-mini:

| Chỉ Số | LlamaIndex | LangChain | Haystack | RAGFlow |
|---|---|---|---|---|
| Độ Chính Xác RAG (RAGAS) | 0.81 | 0.72 | 0.79 | 0.77 |
| Độ Trễ Truy Vấn TB | 0.9s | 1.2s | 1.1s | 1.4s |
| Thởi Gian Xây Index (10k docs) | 6 phút | 8 phút | 7 phút | 9 phút |
| Mức Sử Dụng Bộ Nhớ | Thấp | Trung bình | Trung bình | Cao |
| Tận Dụng Context Window | 78% | 65% | 72% | 68% |

Nguồn: Tổng hợp từ community benchmark và báo cáo kiểm tra độc lập (2025-2026). Kết quả thực tế khác nhau tùy cấu hình.

### Use Case Production

- **Knowledge Base Doanh Nghiệp**: Một công ty fintech index 500k PDF quy định với `VectorStoreIndex` + Qdrant, đạt độ trễ truy vấn dưới 1 giây.
- **Q&A Đa Tài Liệu**: Các team pháp lý dùng `RouterQueryEngine` để định tuyến truy vấn giữa vector search (cho case law) và keyword search (cho trích dẫn điều luật chính xác).
- **Trợ Lý Nghiên Cứu Agentic**: Các lớp `Workflow` với tool-calling agents thực hiện nghiên cứu đa bước, tìm kiếm web, và tạo trích dẫn.
- **Chatbot Có Memory**: `ChatEngine` với `CondensePlusContextMode` xử lý đối thoại đa lượt trên tài liệu độc quyền.

### Khi Nào Chọn LlamaIndex

| Kịch Bản | Cách Tiếp Cận Đề Xuất |
|---|---|
| Q&A dựa trên documents | `VectorStoreIndex` + query engine |
| Nhiều nguồn dữ liệu | `RouterQueryEngine` + nhiều index |
| Đối thoại đa lượt | `ChatEngine` với memory |
| Suy luận phức tạp | `Workflow` với agent tools |
| Trích xuất có cấu trúc | `PydanticProgram` response models |

## Sử Dụng Nâng Cao / Củng Cố Production

### Router Query Engine

Định tuyến query đến các index khác nhau dựa trên ý định:

```python
from llama_index.core.tools import QueryEngineTool, ToolMetadata
from llama_index.core.query_engine import RouterQueryEngine
from llama_index.core.selectors import PydanticSingleSelector

# Tạo nhiều index
vector_index = VectorStoreIndex(nodes)
summary_index = SummaryIndex(nodes)

# Xây dựng query engines
vector_engine = vector_index.as_query_engine()
summary_engine = summary_index.as_query_engine()

# Định nghĩa tools với mô tả
query_engine_tools = [
    QueryEngineTool(
        query_engine=vector_engine,
        metadata=ToolMetadata(
            name="semantic_search",
            description="Useful for finding specific facts and details"
        ),
    ),
    QueryEngineTool(
        query_engine=summary_engine,
        metadata=ToolMetadata(
            name="summarization",
            description="Useful for getting high-level summaries"
        ),
    ),
]

# Router chọn engine tốt nhất cho mỗi query
router_engine = RouterQueryEngine(
    selector=PydanticSingleSelector.from_defaults(),
    query_engine_tools=query_engine_tools,
)

response = router_engine.query("Summarize the main points")
```

### Custom Node Post-Processor

```python
from llama_index.core.postprocessor import BaseNodePostprocessor
from llama_index.core.schema import NodeWithScore, QueryBundle

class ScoreThresholdPostprocessor(BaseNodePostprocessor):
    def __init__(self, threshold: float = 0.7):
        self.threshold = threshold
        super().__init__()

    def _postprocess_nodes(
        self, nodes: list[NodeWithScore], query_bundle: QueryBundle | None = None
    ) -> list[NodeWithScore]:
        return [n for n in nodes if n.score >= self.threshold]

# Sử dụng trong query engine
query_engine = index.as_query_engine(
    node_postprocessors=[ScoreThresholdPostprocessor(threshold=0.75)]
)
```

### Async Query Pipeline

```python
import asyncio

async def batch_queries(queries: list[str]) -> list[str]:
    tasks = [query_engine.aquery(q) for q in queries]
    responses = await asyncio.gather(*tasks)
    return [str(r) for r in responses]

queries = [
    "What is the refund policy?",
    "How do I reset my password?",
    "What are the SLA terms?",
]

results = asyncio.run(batch_queries(queries))
for q, r in zip(queries, results):
    print(f"Q: {q}\nA: {r}\n")
```

### Triển Khai Docker

```dockerfile
# Dockerfile
FROM python:3.12-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
EXPOSE 8000

CMD ["python", "app.py"]
```

```python
# app.py - FastAPI service
from fastapi import FastAPI
from llama_index.core import StorageContext, load_index_from_storage
from pydantic import BaseModel
import os

app = FastAPI()

PERSIST_DIR = os.environ.get("PERSIST_DIR", "./storage")
storage_context = StorageContext.from_defaults(persist_dir=PERSIST_DIR)
index = load_index_from_storage(storage_context)
query_engine = index.as_query_engine()

class QueryRequest(BaseModel):
    query: str

@app.post("/query")
async def query_docs(request: QueryRequest):
    response = query_engine.query(request.query)
    return {
        "answer": str(response),
        "sources": [n.metadata for n in response.source_nodes],
    }
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  app:
    build: .
    ports:
      - "8000:8000"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - PERSIST_DIR=/app/storage
    volumes:
      - ./storage:/app/storage:ro

  qdrant:
    image: qdrant/qdrant:latest
    ports:
      - "6333:6333"
    volumes:
      - qdrant_data:/qdrant/storage

volumes:
  qdrant_data:
```

### Triển Khai DigitalOcean

Để triển khai production trên cloud infrastructure, **DigitalOcean** cung cấp con đường đơn giản. App Platform của họ hỗ trợ container Docker với HTTPS tự động, và managed databases có thể host backend vector store.

Triển khai Docker Compose stack lên DigitalOcean Droplet:

```bash
# Trên Droplet
docker-compose up -d

# Hoặc dùng doctl
doctl apps create --spec .do/app.yaml
```

*Bài viết này chứa liên kết affiliate đến DigitalOcean. Chúng tôi có thể nhận hoa hồng nếu bạn đăng ký qua liên kết giới thiệu của chúng tôi mà không phát sinh chi phí thêm cho bạn.*

### Giám Sát Với Callbacks

```python
from llama_index.core.callbacks import CallbackManager, TokenCountingHandler
import tiktoken

token_counter = TokenCountingHandler(
    tokenizer=tiktoken.encoding_for_model("gpt-4o-mini").encode,
    verbose=True,
)
Settings.callback_manager = CallbackManager([token_counter])

# Sau queries
print(f"LLM Tokens: {token_counter.total_llm_token_count}")
print(f"Embedding Tokens: {token_counter.total_embedding_token_count}")
```

### Checklist Production

| Vấn Đề | Cách Triển Khai |
|---|---|
| Persist index | Gọi `storage_context.persist()` khi build |
| Hot reload | Load từ storage khi khởi động |
| API rate limiting | Thêm FastAPI middleware |
| Input validation | Pydantic schemas trên tất cả endpoints |
| Source citations | Trả về `source_nodes` metadata |
| Token budget | `TokenCountingHandler` monitoring |
| Async support | Dùng `.aquery()` cho tải đồng thởi |
| Secrets management | Biến môi trường, không hardcode |

## So Sánh Với Các Lựa Chọn Khác

| Tính Năng | LlamaIndex | LangChain | Haystack | RAGFlow |
|---|---|---|---|---|
| **Trọng Tâm Chính** | Indexing & retrieval dữ liệu | Orchestration agent & chain | Pipeline RAG production | Builder RAG trực quan |
| **GitHub Stars** | 49.5k | 95k | 25.3k | 80.9k |
| **Giấy Phép** | MIT | MIT | Apache-2.0 | Apache-2.0 |
| **Data Connectors** | 160+ | 100+ | 30+ | 50+ |
| **Loại Index** | 8+ (Vector, Tree, Graph, v.v.) | Cơ bản (FAISS, Chroma) | Tùy chỉnh (Document Stores) | Vector + Full-text |
| **Query Routing** | Native `RouterQueryEngine` | LangGraph / manual | Pipeline-based | Workflow-based |
| **Tốc Độ Retrieval** | Nhanh hơn LangChain 40% | Baseline | Cạnh tranh | Chậm hơn (visual overhead) |
| **Hỗ Trợ Agent** | Workflows + Tools | LangGraph Agents | Custom Agents | Built-in agent templates |
| **Độ Khó Học** | Dễ cho RAG | Cao (highly modular) | Trung bình | Thấp (visual UI) |
| **Phù Hợp Nhất** | Document Q&A, RAG | Hệ thống multi-agent phức tạp | Enterprise production | RAG zero-code |

**Cách chọn**: Dùng LlamaIndex khi nhu cầu chính là truy xuất tài liệu nhanh và chính xác. Dùng LangChain khi xây dựng workflow agent phức tạp với nhiều tool. Dùng Haystack khi monitoring enterprise và khả năng audit quan trọng nhất. Dùng RAGFlow khi team muốn cách tiếp cận trực quan, low-code.

## Hạn Chế / Đánh Giá Trung Thực

**LlamaIndex không phù hợp cho**:

1. **Orchestration multi-agent phức tạp**: LangGraph cung cấp abstraction tốt hơn cho agent với rẽ nhánh có điều kiện, vòng lặp, và thực thi song song.
2. **Ngườ dùng no-code**: Builder trực quan của RAGFlow phù hợp hơn với team thích giao diện kéo-thả.
3. **Parsing tài liệu phức tạp**: Trong khi LlamaParse tồn tại như một dịch vụ trả phí, parser DeepDoc của RAGFlow xử lý PDF phức tạp (bảng, layout) hiệu quả hơn ngay từ đầu.
4. **Stack không phải Python**: Hỗ trợ TypeScript tồn tại (npm package `llamaindex`) nhưng tụt hậu về Python về tính năng.
5. **Môi trường tài nguyên nhỏ**: Framework import nhiều module. Cho deployment edge hạn chế, các lựa chọn thay thế nhẹ nhàng hơn như `txtai` hoặc gọi API trực tiếp có thể phù hợp hơn.

## Câu Hởi Thường Gặp

**Q1: LlamaIndex khác LangChain như thế nào?**

LlamaIndex tập trung vào data ingestion, indexing, và retrieval optimization. LangChain là framework orchestration đa năng để chain các phép toán LLM. Các team thường kết hợp cả hai: LlamaIndex xử lý retrieval layer, LangChain quản lý logic agent. Nếu bạn đang quyết định **llamaindex vs langchain** cho dự án RAG, LlamaIndex cung cấp thiết lập nhanh hơn và hiệu suất retrieval tốt hơn.

**Q2: Tôi có thể dùng LlamaIndex chỉ với local models không?**

Có. Tích hợp Ollama hỗ trợ bất kỳ model nào có sẵn qua Ollama, bao gồm Llama 3.2, Mistral, và CodeLlama. Thiết lập `OLLAMA_BASE_URL` và dùng `Ollama` làm LLM và `OllamaEmbedding` cho embeddings. Điều này loại bỏ mọi phụ thuộc API bên ngoài.

**Q3: Làm sao scale LlamaIndex lên hàng triệu documents?**

Dùng vector database production (Qdrant, Weaviate, hoặc Pinecone) thay vì in-memory storage. Chạy ingestion như một batch job tách biệt với query service. Cân nhắc `IngestionPipeline` với parallel node parsing và batched embedding generation.

**Q4: LlamaIndex có hỗ trợ streaming responses không?**

Có. Truyền `streaming=True` cho `as_query_engine()` và lặp qua response:

```python
query_engine = index.as_query_engine(streaming=True)
response = query_engine.query("Explain the architecture")
for token in response.response_gen:
    print(token, end="")
```

**Q5: Làm sao đánh giá chất lượng pipeline RAG?**

LlamaIndex cung cấp các module evaluation tích hợp:

```python
from llama_index.core.evaluation import FaithfulnessEvaluator, RelevancyEvaluator

faith_eval = FaithfulnessEvaluator()
relevancy_eval = RelevancyEvaluator()

response = query_engine.query("What is the refund policy?")
faith_result = faith_eval.evaluate(response=response)
relevancy_result = relevancy_eval.evaluate(response=response, query="What is the refund policy?")

print(f"Faithful: {faith_result.passing}")
print(f"Relevant: {relevancy_result.passing}")
```

**Q6: LlamaIndex có miễn phí cho thương mại không?**

Có. Framework core được cấp phép MIT và miễn phí cho sử dụng thương mại. Công ty LlamaIndex cung cấp các dịch vụ trả phí như LlamaParse (document parsing) và LlamaCloud (managed hosting), nhưng framework mã nguồn mở không có hạn chế sử dụng.

## Kết Luận

LlamaIndex chiếm một vị thế cụ thể và có giá trị: nó làm việc xây dựng hệ thống RAG production trở nên đơn giản mà không che giấu các thành phần bên trong mà bạn cần tinh chỉnh. **49K+ stars** và cộng đồng năng động phản ánh sự trưởng thành của nó. Nếu ứng dụng của bạn xoay quanh document retrieval, semantic search, hoặc knowledge-base Q&A, LlamaIndex cung cấp sự cân bằng đúng đắn giữa cấu trúc và linh hoạt.

![Kiến Trúc Production LlamaIndex](https://cdn.sanity.io/images/7m9jw85w/production/fc2fb39d84bcf6ae0ca2e4130844c076bc9a20a0-2464x1210.png)

**Bước tiếp theo**: Clone repo, chạy đoạn quickstart 5 dòng, rồi deploy thiết lập Docker lên infrastructure của bạn. Để được hỗ trợ và tham gia cộng đồng, hãy tham gia [nhóm Telegram dibi8](https://t.me/dibi8community) để kết nối với các developer khác đang xây dựng hệ thống RAG production, hoặc theo dõi thảo luận trên [LlamaIndex Discord](https://discord.com/invite/eN6D2HQ4aX) và [GitHub repository](https://github.com/run-llama/llama_index).

*Công Bố Liên Kết Affiliate: Bài viết này chứa liên kết đến DigitalOcean. Chúng tôi có thể nhận được hoa hồng nếu bạn mua dịch vụ qua các liên kết này. Điều này không ảnh hưởng đến độc lập biên tập hoặc khuyến nghị của chúng tôi.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài Liệu Tham Khảo

- [LlamaIndex Official Documentation](https://developers.llamaindex.ai/python/framework/)
- [LlamaIndex GitHub Repository](https://github.com/run-llama/llama_index)
- [LlamaHub — Data Connectors](https://llamahub.ai)
- [LlamaIndex vs LangChain: So Sánh 2025](https://latenode.com/blog/langchain-vs-llamaindex-2025-complete-rag-framework-comparison)
- [RAG Frameworks Benchmark 2025](https://langcopilot.com/posts/2025-09-18-top-rag-frameworks-2024-complete-guide)
- [Real Python: LlamaIndex Guide](https://realpython.com/llamaindex-examples/)
- [Haystack GitHub](https://github.com/deepset-ai/haystack)
- [RAGFlow GitHub](https://github.com/infiniflow/ragflow)
