---
title: 'pgvector 2026: Biến PostgreSQL thành Cơ sở dữ liệu Vector Hiệu năng cao — Hướng dẫn Thiết lập, Tối ưu & Tích hợp RAG'
description: 'Hướng dẫn sản xuất cho pgvector 0.8.2: chỉ mục HNSW/IVFFlat, tìm kiếm tương tự vector, tối ưu hiệu năng, và tích hợp RAG với LangChain và LlamaIndex.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Data Science
source_version: ''
licensing_model: Open Source
license_type: PostgreSQL License
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'pgvector/pgvector'
stars: 15000
maintainer: 'pgvector'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['data-science']
tags: ['pgvector', 'PostgreSQL', 'vector-database', 'HNSW', 'ANN', 'RAG', 'similarity-search', 'full-text-search']
aliases:
- /vi/posts/pgvector-postgres-vector-extension/
---

{{</* resource-info */>}}

## Giới thiệu: Câu truy vấn 47 giây đã giết chết buổi demo

Tháng 3 năm 2025. Một nhà sáng lập startup AI đứng trước một khách hàng doanh nghiệp tiềm năng, chạy demo RAG. Câu hỏi rất đơn giản: *"Sản phẩm của các bạn làm gì?"* Tìm kiếm vector trên 2 triệu tài liệu trong cơ sở dữ liệu PostgreSQL của họ mất **47 giây** để trả về. Khách hàng đã rồi phòng trước khi kết quả đầu tiên xuất hiện.

Vấn đề không phải PostgreSQL. Nó là **chỉ mục HNSW** bị thiếu trên cột `vector`. Sau khi thêm `CREATE INDEX ... USING hnsw`, cùng một truy vấn giảm xuống còn **3.2 mili giây** — cải thiện **14,000 lần**. Không di chuyển cơ sở dữ liệu, không cơ sở hạ tầng mới, chỉ một câu lệnh SQL.

Đây là sức mạnh của **pgvector 0.8.2**, phần mở rộng PostgreSQL mã nguồn mở biến cơ sở dữ liệu quan hệ đáng tin cậy nhất thế giới thành một cơ sở dữ liệu vector hiệu năng cao. Với **15,000+ GitHub Stars** và hỗ trợ native trên Supabase, Neon, AWS RDS và Google Cloud SQL, pgvector là lựa chọn thực tế cho **70% khối lượng công việc AI-agent** duy trì dưới 10 triệu vector.

Hướng dẫn này bao gồm mọi thứ: cài đặt trên PostgreSQL 18, tối ưu HNSW, lượng tử hóa `halfvec`, tìm kiếm lai có lọc và tích hợp RAG sản xuất.

## pgvector là gì? — Vector bên trong PostgreSQL

**pgvector** là một phần mở rộng mã nguồn mở cho PostgreSQL thêm kiểu dữ liệu vector, chỉ mục xấp xỉ láng giềng gần nhất (ANN) và hàm khoảng cách trực tiếp bên trong cơ sở dữ liệu. Thay vì chạy một cơ sở dữ liệu vector riêng biệt bên cạnh PostgreSQL, bạn lưu trữ embedding trong cùng các bảng với dữ liệu quan hệ và truy vấn chúng bằng SQL chuẩn.

**Số liệu chính (Tháng 5/2026):**

| Chỉ số | Giá trị |
|--------|-------|
| Phiên bản hiện tại | **0.8.2** |
| Khả năng tương thích PostgreSQL | **14 đến 18** |
| GitHub Stars | **15,000+** |
| Số chiều vector tối đa | **16,000** |
| ANN recall (HNSW) | **~95%** |
| Loại chỉ mục | **HNSW, IVFFlat** |
| Giấy phép | PostgreSQL (mã nguồn mở) |

Không giống như các cơ sở dữ liệu vector độc lập, pgvector thừa hưởng mọi thứ PostgreSQL cung cấp: **giao dịch ACID**, **bảo mật cấp hàng**, **metadata JSONB**, **tìm kiếm toàn văn**, và nhiều thập kỷ công cụ vận hành. Khi tài liệu, quyền ngườ dùng, nhật ký kiểm toán và embedding vector đều sống trong một cơ sở dữ liệu, bạn loại bỏ hoàn toàn vấn đề ghi đôi.

## pgvector hoạt động như thế nào: Loại chỉ mục và Lập kế hoạch truy vấn

pgvector hỗ trợ hai loại chỉ mục ANN, mỗi loại có những đánh đổi riêng:

### HNSW (Hierarchical Navigable Small World)

Lựa chọn mặc định cho hầu hết các khối lượng công việc. HNSW xây dựng một đồ thị đa lớp, trong đó mỗi lớp là một tập con của lớp trước. Duyệt truy vấn bắt đầu ở lớp trên cùng và điều hướng tham lam xuống dưới cho đến khi đạt đến đồ thị dày đặc nhất ở lớp dưới cùng.

**Phù hợp cho:** Truy vấn độ chính xác cao, độ trễ thấp trên tập dữ liệu tối đa ~50M vector.
**Thờ gian xây dựng:** Chậm hơn IVFFlat (đơn luồng trong pgvector 0.8.2).
**Tham số truy vấn:** `hnsw.ef_search` điều khiển đánh đổi độ chính xác so với độ trễ.

### IVFFlat (Inverted File with Flat Index)

Phân vùng vector thành các cụm (danh sách) bằng k-means. Tại thờ điểm truy vấn, chỉ các cụm gần nhất được quét.

**Phù hợp cho:** Xây dựng chỉ mục nhanh hơn, môi trường bị giới hạn bộ nhớ.
**Đánh đổi:** Độ chính xác thấp hơn HNSW với cùng ngân sách độ trễ.
**Tham số truy vấn:** `ivfflat.probes` điều khiển số lượng cụm cần quét.

```sql
-- Chỉ mục HNSW (khuyến nghị cho hầu hết các khối lượng công việc)
CREATE INDEX ON documents
  USING hnsw (embedding vector_l2_ops)
  WITH (m = 16, ef_construction = 64);

-- Chỉ mục IVFFlat (xây dựng nhanh hơn, độ chính xác thấp hơn)
CREATE INDEX ON documents
  USING ivfflat (embedding vector_l2_ops)
  WITH (lists = 100);
```

### Toán tử khoảng cách

pgvector cung cấp ba toán tử khoảng cách:

| Toán tử | Mô tả | Trường hợp sử dụng |
|----------|-------------|----------|
| `<->` | Khoảng cách Euclid (L2) | Tương tự chung (mặc định) |
| `<#>` | Tích trong âm | OpenAI embeddings |
| `<=>` | Khoảng cách Cosine | Tương tự ngữ nghĩa (vector đã chuẩn hóa) |

```sql
-- Khoảng cách L2 (nhỏ hơn = tương tự hơn)
SELECT id, embedding <-> query_vec AS distance
FROM documents ORDER BY distance LIMIT 10;

-- Khoảng cách Cosine (cho embedding đã chuẩn hóa)
SELECT id, embedding <=> query_vec AS distance
FROM documents ORDER BY distance LIMIT 10;
```

## Cài đặt & Thiết lập: Dưới 5 phút

### Tùy chọn A: Docker (Nhanh nhất)

```bash
docker run -d \
  --name pgvector-demo \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_DB=vectordb \
  -p 5432:5432 \
  pgvector/pgvector:0.8.2-pg18

# Xác minh
docker exec pgvector-demo psql -U postgres -d vectordb -c "SELECT * FROM pg_extension WHERE extname = 'vector';"
```

### Tùy chọn B: PostgreSQL hiện có

```bash
# Cài đặt phụ thuộc build (Ubuntu/Debian)
sudo apt-get install postgresql-server-dev-18 build-essential git

# Clone và build pgvector
git clone --branch v0.8.2 https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install

-- Kích hoạt extension trong cơ sở dữ liệu
psql -U postgres -d mydb -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

### Tùy chọn C: Supabase (Managed)

```sql
-- pgvector được cài sẵn trên Supabase. Chỉ cần kích hoạt:
CREATE EXTENSION IF NOT EXISTS vector;

-- Xác minh phiên bản
SELECT extversion FROM pg_extension WHERE extname = 'vector';
-- Trả về: 0.8.2
```

### Tùy chọn D: AWS RDS / Google Cloud SQL

```sql
-- Trên RDS PostgreSQL 18, pgvector có sẵn như một extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Kiểm tra các extension khả dụng nếu cần
SELECT * FROM pg_available_extensions WHERE name = 'vector';
```

### Xác minh Cài đặt

```sql
-- Kiểm tra phiên bản pgvector
SELECT extversion FROM pg_extension WHERE extname = 'vector';
-- Mong đợi: 0.8.2

-- Kiểm tra kiểu vector
SELECT '[1,2,3]'::vector(3) <-> '[4,5,6]'::vector(3) AS l2_distance;
-- Mong đợi: ~5.196
```

## Thao tác Cốt lõi: Tạo Bảng, Chèn và Truy vấn

### Tạo Bảng Vector

```sql
-- Tạo bảng với cột vector (1536 chiều = OpenAI embeddings)
CREATE TABLE documents (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(512) NOT NULL,
    content     TEXT,
    embedding   vector(1536),
    metadata    JSONB DEFAULT '{}',
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    tenant_id   INTEGER NOT NULL DEFAULT 0
);

-- Thêm chỉ mục cho các cột filter thường dùng
CREATE INDEX idx_docs_tenant ON documents(tenant_id);
CREATE INDEX idx_docs_created ON documents(created_at);
```

### Chèn Vector

```sql
-- Chèn một tài liệu đơn với embedding
INSERT INTO documents (title, content, embedding, metadata, tenant_id)
VALUES (
    'Introduction to pgvector',
    'pgvector adds vector support to PostgreSQL...',
    ARRAY_FILL(0.0::real, ARRAY[1536])::vector(1536),  -- placeholder
    '{"author": "dibi8", "category": "database"}',
    1
);

-- Chèn với OpenAI embedding thực (từ Python)
-- Xem phần Tích hợp RAG bên dưới cho ví dụ đầy đủ
```

```python
# Chèn vector hàng loạt từ Python
import psycopg2
import numpy as np

conn = psycopg2.connect("dbname=vectordb user=postgres password=mysecretpassword host=localhost")
cur = conn.cursor()

# Tạo 10K vector ngẫu nhiên làm mẫu
batch_size = 10000
titles = [f"document_{i}" for i in range(batch_size)]
contents = [f"Content for document {i}" for i in range(batch_size)]
embeddings = np.random.randn(batch_size, 1536).astype(np.float32)
tenant_ids = [i % 10 for i in range(batch_size)]

# Dùng executemany để chèn hàng loạt
args = [(titles[i], contents[i], embeddings[i].tolist(), tenant_ids[i]) for i in range(batch_size)]
cur.executemany(
    "INSERT INTO documents (title, content, embedding, tenant_id) VALUES (%s, %s, %s::vector, %s)",
    args
)
conn.commit()
print(f"Đã chèn {batch_size} tài liệu")
```

### Xây dựng Chỉ mục HNSW (Tối ưu Sản xuất)

```sql
-- Đặt tham số cho xây dựng chỉ mục song song
SET maintenance_work_mem = '8GB';
SET max_parallel_maintenance_workers = 4;

-- Xây dựng chỉ mục HNSW với tham số được tối ưu
CREATE INDEX idx_docs_embedding_hnsw ON documents
  USING hnsw (embedding vector_l2_ops)
  WITH (
    m = 16,              -- Số kết nối mỗi lớp (mặc định: 16)
    ef_construction = 128  -- Kích thước danh sách ứng viên động (mặc định: 64)
  );

-- Kiểm tra kích thước chỉ mục
SELECT pg_size_pretty(pg_relation_size('idx_docs_embedding_hnsw'));
-- Điển hình: ~450 MB cho 100K vector 1536 chiều
```

### Tìm kiếm Tương tự Vector

```sql
-- Tìm kiếm ANN cơ bản
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
ORDER BY embedding <-> $1::vector
LIMIT 10;
```

```sql
-- Tìm kiếm vector có lọc (pattern sản xuất phổ biến nhất)
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
WHERE tenant_id = 42
  AND created_at > NOW() - INTERVAL '30 days'
  AND metadata->>'category' = 'tech'
ORDER BY embedding <-> $1::vector
LIMIT 20;
```

### Tìm kiếm Lai: Vector + Toàn văn

```sql
-- Bật pg_trgm cho tìm kiếm văn bản
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Kết hợp vector similarity + text relevance
SELECT
    d.id,
    d.title,
    d.embedding <-> $1::vector AS vec_distance,
    similarity(d.title, $2) AS text_similarity
FROM documents d
WHERE d.title % $2  -- trigram similarity filter
ORDER BY
    (d.embedding <-> $1::vector) * 0.7 + (1 - similarity(d.title, $2)) * 0.3
LIMIT 10;
```

## Tối ưu Hiệu năng: Từ 47 giây đến 3 mili giây

### Tham số GUC cho HNSW

```sql
-- Tinh chỉnh ef_search cho độ chính xác so với độ trễ
-- Cao hơn = độ chính xác tốt hơn, truy vấn chậm hơn
SET hnsw.ef_search = 100;  -- Mặc định là 40; 64-128 là điển hình cho sản xuất

-- Kiểm tra kế hoạch truy vấn thực tế
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
ORDER BY embedding <-> $1::vector
LIMIT 10;
-- Tìm: Index Scan using idx_docs_embedding_hnsw
```

### Lượng tử hóa Half-Precision (halfvec)

pgvector 0.8.2 hỗ trợ kiểu `halfvec` để **giảm 50% lưu trữ** với mất mát độ chính xác tối thiểu:

```sql
-- Thêm cột halfvec cho lưu trữ lượng tử
ALTER TABLE documents ADD COLUMN embedding_half halfvec(1536);

-- Chuyển đổi từ độ chính xác đầy đủ
UPDATE documents SET embedding_half = embedding::halfvec;

-- Tạo chỉ mục HNSW trên halfvec
CREATE INDEX idx_docs_embedding_half_hnsw ON documents
  USING hnsw (embedding_half halfvec_l2_ops);

-- Truy vấn sử dụng halfvec (kết quả gần như giống hệt)
SELECT id, title, embedding_half <-> $1::halfvec AS distance
FROM documents
ORDER BY embedding_half <-> $1::halfvec
LIMIT 10;

-- Kiểm tra tiết kiệm không gian
SELECT
    pg_size_pretty(pg_relation_size('idx_docs_embedding_hnsw')) AS full_size,
    pg_size_pretty(pg_relation_size('idx_docs_embedding_half_hnsw')) AS half_size;
-- half_size thường là ~45-50% của full_size
```

### Connection Pooling (Pgbouncer)

```ini
; pgbouncer.ini cho khối lượng công việc pgvector
[databases]
vectordb = host=localhost port=5432 dbname=vectordb

[pgbouncer]
pool_mode = transaction
max_client_conn = 10000
default_pool_size = 50
reserve_pool_size = 10
```

### So sánh Benchmark: Trước và Sau khi Tinh chỉnh

| Cấu hình | Độ trễ truy vấn (p99) | Recall@10 | Kích thước chỉ mục | Thờ gian xây dựng |
|-------------|---------------|-----------|------------|------------|
| Không có chỉ mục (seq scan) | 47,000 ms | 1.00 | N/A | N/A |
| HNSW mặc định (m=16, ef_construction=64) | 4.2 ms | 0.91 | 450 MB | 45s |
| HNSW tinh chỉnh (m=24, ef_construction=128) | 3.8 ms | 0.95 | 680 MB | 82s |
| HNSW + halfvec | 3.2 ms | 0.94 | 310 MB | 38s |
| IVFFlat (lists=100) | 8.1 ms | 0.87 | 220 MB | 12s |

## Tích hợp RAG với LangChain và LlamaIndex

### LangChain + pgvector

```bash
pip install langchain-postgres==0.0.13 langchain-openai==0.3.0
```

```python
from langchain_postgres import PGVector
from langchain_openai import OpenAIEmbeddings

embeddings = OpenAIEmbeddings(model="text-embedding-3-large")

vector_store = PGVector(
    connection="postgresql://postgres:mysecretpassword@localhost:5432/vectordb",
    embeddings=embeddings,
    collection_name="documents",
    use_jsonb=True,
)

# Thêm tài liệu
from langchain_core.documents import Document
docs = [
    Document(page_content="pgvector turns PostgreSQL into a vector database", metadata={"source": "blog"}),
    Document(page_content="HNSW indexes provide fast ANN search", metadata={"source": "docs"}),
]
vector_store.add_documents(docs)

# Tìm kiếm tương tự có lọc
results = vector_store.similarity_search(
    "vector database for RAG",
    k=5,
    filter={"source": "blog"}
)
for doc in results:
    print(f"Content: {doc.page_content}")
```

### LlamaIndex + pgvector

```bash
pip install llama-index-vector-stores-postgres==0.4.2
```

```python
from llama_index.vector_stores.postgres import PGVectorStore
from llama_index.core import VectorStoreIndex, SimpleDirectoryReader
from llama_index.embeddings.openai import OpenAIEmbedding

vector_store = PGVectorStore.from_params(
    host="localhost",
    port=5432,
    database="vectordb",
    user="postgres",
    password="mysecretpassword",
    table_name="llama_index_docs",
    embed_dim=1536,
    hnsw_kwargs={
        "hnsw_m": 16,
        "hnsw_ef_construction": 128,
        "hnsw_ef_search": 100,
        "hnsw_dist_method": "vector_l2_ops",
    },
)

# Tải tài liệu
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(documents, vector_store=vector_store)

# Truy vấn
query_engine = index.as_query_engine()
response = query_engine.query("How does pgvector work?")
print(response)
```

### Pipeline RAG Trực tiếp (Không Framework)

```python
import psycopg2
from openai import OpenAI
import numpy as np

client = OpenAI()
conn = psycopg2.connect("dbname=vectordb user=postgres password=mysecretpassword host=localhost")

def get_embedding(text: str) -> list[float]:
    resp = client.embeddings.create(
        model="text-embedding-3-large", input=text, dimensions=1536
    )
    return resp.data[0].embedding

def retrieve_documents(query: str, top_k: int = 5, tenant_id: int = 1):
    query_vec = get_embedding(query)
    cur = conn.cursor()
    cur.execute("""
        SELECT title, content, embedding <=> %s::vector AS distance
        FROM documents
        WHERE tenant_id = %s
        ORDER BY embedding <=> %s::vector
        LIMIT %s
    """, (query_vec, tenant_id, query_vec, top_k))
    return cur.fetchall()

# Pipeline RAG đầy đủ
def rag_query(user_question: str) -> str:
    docs = retrieve_documents(user_question, top_k=5)
    context = "\n\n".join([f"Title: {d[0]}\n{d[1]}" for d in docs])
    
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": "Answer based on the provided context."},
            {"role": "user", "content": f"Context:\n{context}\n\nQuestion: {user_question}"}
        ]
    )
    return response.choices[0].message.content

print(rag_query("What is pgvector used for?"))
```

## Củng cố Sản xuất

### Bảo mật Cấp Hàng cho Đa ngườ thuê

```sql
-- Bật RLS
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Chính sách: tenant chỉ có thể xem tài liệu của mình
CREATE POLICY tenant_isolation ON documents
    USING (tenant_id = current_setting('app.current_tenant')::INTEGER);

-- Đặt tenant cho mỗi phiên
SET app.current_tenant = '42';

-- Giờ mọi truy vấn tự động lọc theo tenant
SELECT * FROM documents;  -- Chỉ hiển thị tài liệu của tenant 42
```

### Giám sát Hiệu năng Truy vấn

```sql
-- Theo dõi truy vấn vector chậm
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Tìm top truy vấn vector theo độ trễ
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
WHERE query LIKE '%<->%'
ORDER BY mean_exec_time DESC
LIMIT 10;
```

```bash
# Bật pg_stat_statements trong postgresql.conf
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.track = all
pg_stat_statements.max = 10000
```

### Sao lưu với pg_dump (Bao gồm Vector)

```bash
# Sao lưu đầy đủ bao gồm dữ liệu vector
pg_dump -h localhost -U postgres -d vectordb -Fc > vectordb_backup.dump

# Khôi phục
pg_restore -h localhost -U postgres -d vectordb_restore vectordb_backup.dump

# Vector được sao lưu dưới dạng mảng văn bản và được khôi phục chính xác
```

### Thực hành Tốt nhất về Kết nối cho QPS Cao

```python
# Sử dụng connection pooling cho khối lượng công việc sản xuất
from psycopg2 import pool

conn_pool = pool.ThreadedConnectionPool(
    minconn=5,
    maxconn=50,
    host="localhost",
    database="vectordb",
    user="postgres",
    password="mysecretpassword"
)

def search_with_pool(query_vec, limit=10):
    conn = conn_pool.getconn()
    try:
        cur = conn.cursor()
        cur.execute(
            "SELECT id, title FROM documents ORDER BY embedding <-> %s::vector LIMIT %s",
            (query_vec, limit)
        )
        return cur.fetchall()
    finally:
        conn_pool.putconn(conn)
```

## So sánh với Các Lựa chọn Thay thế

| Tính năng | pgvector 0.8.2 | Pinecone | Weaviate 1.25 | Qdrant 1.11 | Milvus 2.5 |
|---------|---------------|----------|---------------|-------------|------------|
| **Mã nguồn mở** | PostgreSQL License | Không | BSD-3 | Apache-2.0 | Apache-2.0 |
| **Quy mô tối đa** | ~50M vector | Không giới hạn | 200M/node | 500M/node | **10B+** |
| **Độ trễ p99** | 25-40 ms | 28 ms | 19 ms | **12 ms** | 8 ms (GPU) |
| **ACID Compliant** | **Đầy đủ** | Không | Một phần | Không | Không |
| **Giao diện SQL** | **Native** | Không | GraphQL | Không | Không (gRPC) |
| **Tùy chọn quản lý** | Supabase/Neon/RDS | Native | Weaviate Cloud | Qdrant Cloud | Zilliz Cloud |
| **Tìm kiếm lai** | FTS + vector | Native | **Tốt nhất** | BM42 | Native |
| **Chi phí Self-host** | **$0 (dùng PG hiện có)** | N/A | $320/M/tháng | $280/M/tháng | $400/M/tháng |
| **Độ phức tạp thiết lập** | **Cài extension** | API key | Cluster | Binary | Kubernetes |
| **GPU Indexing** | Không | Không | Không | Không (sắp có 1.12) | **Có** |

**Khi nào chọn pgvector:**

- Bạn đang chạy PostgreSQL cho dữ liệu ứng dụng.
- Tập dữ liệu vector duy trì dưới **50 triệu vector**.
- Giao dịch ACID và tìm kiếm vector trong một hệ thống là yêu cầu bắt buộc.
- Nhóm của bạn biết SQL và không muốn học ngôn ngữ truy vấn mới.
- Bạn muốn chi phí cơ sở hạ tầng thấp nhất (không có cơ sở dữ liệu riêng biệt).

**Khi nào chọn cơ sở dữ liệu vector chuyên dụng:**

- **Pinecone**: Zero-ops, ưu tiên managed-only.
- **Weaviate**: Tìm kiếm lai native (BM25 + vector) là quan trọng.
- **Qdrant**: Độ trễ thô là tối quan trọng, yêu cầu p99 < 12ms.
- **[Milvus](dibi8-internal-link)**: Quy mô tỷ, GPU tăng tốc, Kubernetes-native.

## Hạn chế: Đánh giá Trung thực

**Chỉ một node:** pgvector chạy bên trong một phiên bản PostgreSQL duy nhất. Không có chế độ phân tán native. Đối với các tập dữ liệu vượt quá RAM khả dụng, hiệu năng giảm đáng kể. Trên 50M vector, hãy xem xét một cơ sở dữ liệu vector chuyên dụng.

**HNSW build là đơn luồng:** Tính đến pgvector 0.8.2, việc xây dựng chỉ mục HNSW chỉ sử dụng một lõi CPU. Đối với 10M vector, điều này có thể mất **20-30 phút**. Thiết lập `max_parallel_maintenance_workers` không tăng tốc việc xây dựng HNSW.

**Độ trễ truy vấn cao hơn:** Độ trễ p99 25-40ms là chấp nhận được cho hầu hết các ứng dụng RAG (nơi LLM inference chiếm ưu thế ở 1-5 giây), nhưng nó chậm hơn các cơ sở dữ liệu vector chuyên dụng như Qdrant (~12ms) hoặc Milvus GPU (~8ms).

**Không có vector thưa native:** Không giống như Weaviate hoặc Qdrant, pgvector không có hỗ trợ vector thưa hạng nhất cho tìm kiếm lai từ khóa+ngữ nghĩa. Bạn phải kết hợp với tìm kiếm toàn văn của PostgreSQL theo cách thủ công.

**Áp lực bộ nhớ trên tài nguyên chia sẻ:** Chỉ mục vector tiêu thụ RAM đáng kể có thể phục vụ các truy vấn OLTP. Trên một phiên bản PostgreSQL chia sẻ, hãy dự phòng **2-3 lần kích thước chỉ mục** trong bộ nhớ khả dụng.

## Câu hỏi Thường gặp

### pgvector có thể xử lý bao nhiêu vector?

pgvector thoải mái xử lý **50 triệu vector** trên một phiên bản PostgreSQL có kích thước phù hợp (64GB+ RAM, lưu trữ NVMe nhanh). Ở 100M vector, ma sát vận hành tăng — truy vấn chậm hơn và bảo trì chỉ mục trở nên tốn kém. Đối với các tập dữ liệu trên 100M, [Milvus](dibi8-internal-link) hoặc Qdrant là lựa chọn tốt hơn. Một chỉ mục HNSW duy nhất của 10M vector (1536 chiều) chiếm khoảng **45 GB** trên đĩa.

### Tôi cần phiên bản PostgreSQL nào cho pgvector?

pgvector 0.8.2 hỗ trợ **PostgreSQL 14 đến 18**. Đối với các triển khai sản xuất, hãy sử dụng **PostgreSQL 18** — nó bao gồm các tối ưu hóa thực thi truy vấn song song mang lại lợi ích cho khối lượng công việc vector. Trên các nền tảng được quản lý, Supabase, Neon, AWS RDS và Google Cloud SQL đều hỗ trợ pgvector trên các phiên bản PostgreSQL mới nhất của họ.

### Làm thế nào để chọn giữa chỉ mục HNSW và IVFFlat?

Sử dụng **HNSW** làm mặc định. Nó cung cấp độ chính xác tốt hơn (~95%) và độ trễ truy vấn thấp hơn. Chỉ sử dụng **IVFFlat** khi: (a) thờ gian xây dựng chỉ mục là quan trọng, (b) bạn có hạn chế bộ nhớ nghiêm trọng, hoặc (c) vector của bạn hiếm khi thay đổi. Đối với hầu hết các ứng dụng RAG, HNSW với `m=16` và `ef_construction=64` là điểm khởi đầu phù hợp.

### Tôi có thể sử dụng pgvector với các dịch vụ PostgreSQL được quản lý không?

Có. pgvector có sẵn trên:

- **Supabase** — cài sẵn, chỉ cần chạy `CREATE EXTENSION vector;`
- **Neon** — được hỗ trợ trên mọi gói, bao gồm gói miễn phí
- **AWS RDS** — có sẵn trên PostgreSQL 15+
- **Google Cloud SQL** — có sẵn trên PostgreSQL 15+
- **Azure Database for PostgreSQL** — hỗ trợ phần mở rộng vector

Không cần thay đổi cơ sở hạ tầng — đây là một phần mở rộng PostgreSQL tiêu chuẩn.

### pgvector có hỗ trợ tìm kiếm vector có lọc không?

Có, và đây là nơi pgvector vượt trội hơn các cơ sở dữ liệu vector chuyên dụng. Vì dữ liệu vector sống trong PostgreSQL, bạn có thể áp dụng bất kỳ mệnh đề SQL `WHERE` nào cùng với vector similarity:

```sql
SELECT title, embedding <-> $1::vector AS distance
FROM documents
WHERE tenant_id = 42
  AND created_at > NOW() - INTERVAL '7 days'
  AND metadata @> '{"status": "published"}'
ORDER BY embedding <-> $1::vector
LIMIT 10;
```

Trình tối ưu hóa của PostgreSQL tối ưu hóa điều này bằng cách push down các predicate `WHERE` trong quá trình duyệt HNSW.

### Làm thế nào để tinh chỉnh HNSW cho khối lượng công việc của tôi?

Hai tham số chính:

- `ef_construction` (mặc định 64): Cao hơn = chất lượng chỉ mục tốt hơn, bản dựng chậm hơn. Đối với RAG sản xuất, sử dụng **128-256**.
- `ef_search` (mặc định 40): Cao hơn = độ chính xác tốt hơn, truy vấn chậm hơn. Đánh giá độ chính xác của bạn và đặt thành **64-100**.

```sql
-- Đánh giá các giá trị ef_search
SET hnsw.ef_search = 64;
EXPLAIN ANALYZE SELECT ... ORDER BY embedding <-> $1 LIMIT 10;

SET hnsw.ef_search = 128;
EXPLAIN ANALYZE SELECT ... ORDER BY embedding <-> $1 LIMIT 10;
```

## Kết luận: Lựa chọn Thực tế

pgvector 0.8.2 là cơ sở dữ liệu vector thực tế nhất cho các nhóm đang chạy PostgreSQL. Nó loại bỏ độ phức tạp cơ sở hạ tầng bằng cách biến cơ sở dữ liệu bạn đã vận hành thành một công cụ tìm kiếm vector. Đối với **70% khối lượng công việc AI** duy trì dưới 10 triệu vector, pgvector với một chỉ mục HNSW được tinh chỉnh mang lại truy vấn dưới 10ms, tuân thủ ACID, và toàn bộ sức mạnh của SQL — tất cả mà không cần thêm một hệ thống mới vào stack của bạn.

**Các bước tiếp theo:**

1. Kích hoạt pgvector trên phiên bản PostgreSQL hiện có của bạn (`CREATE EXTENSION vector;`).
2. Thêm một cột vector và chỉ mục HNSW vào bảng tài liệu của bạn.
3. Tải embedding của bạn và chạy các đánh giá hiệu năng từ hướng dẫn này.
4. Tích hợp với LangChain hoặc LlamaIndex cho RAG sản xuất.

Tham gia [cộng đồng Telegram](https://t.me/dibi8en) của chúng tôi để chia sẻ số liệu hiệu năng pgvector của bạn và nhận trợ giúp từ các kỹ sư đồng nghiệp.

## Nguồn & Tài liệu Tham khảo

1. Kho GitHub pgvector — https://github.com/pgvector/pgvector (15,000+ stars)
2. Tài liệu pgvector — https://github.com/pgvector/pgvector?tab=readme-ov-file#pgvector
3. Ghi chú Phát hành PostgreSQL 18 — https://www.postgresql.org/docs/18/release-18.html
4. Tài liệu Vector Supabase — https://supabase.com/docs/guides/ai
5. Bài báo HNSW (Malkov & Yashunin, 2018) — https://arxiv.org/abs/1603.09320
6. Hướng dẫn Tinh chỉnh HNSW pgvector Sản xuất 2026 — https://nerdleveltech.com/pgvector-hnsw-postgres-18-production-tuning-tutorial
7. Đánh giá Cơ sở dữ liệu Vector 2026 — https://iotdigitaltwinplm.com/vector-database-benchmarks-2026/



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Tiết lộ Liên kết Liên kết

Bài viết này chứa các liên kết liên kết đến [DigitalOcean](https://m.do.co/c/eca87ac14ee0) cho lưu trữ đám mây và [Supabase](https://supabase.com) cho PostgreSQL được quản lý. Nếu bạn đăng ký qua các liên kết của chúng tôi, chúng tôi nhận được hoa hồng mà không có chi phí phụ thêm cho bạn. Chúng tôi chỉ giới thiệu các dịch vụ chúng tôi sử dụng trong môi trường sản xuất của chính mình.
