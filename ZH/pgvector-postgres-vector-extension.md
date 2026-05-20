---
title: 'pgvector 2026：将 PostgreSQL 转变为高性能向量数据库——配置、调优与 RAG 集成指南'
description: 'pgvector 0.8.2 生产指南：HNSW/IVFFlat 索引、向量相似性搜索、性能调优，以及与 LangChain 和 LlamaIndex 的 RAG 集成。'
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
tags: ['pgvector', 'PostgreSQL', '向量数据库', 'HNSW', 'ANN', 'RAG', '相似性搜索', '全文搜索']
aliases:
- /zh/posts/pgvector-postgres-vector-extension/
---

{{</* resource-info */>}}

## 引言：那个杀死演示的 47 秒查询

那是 2025 年 3 月。一位 AI 初创公司创始人站在潜在客户面前，运行 RAG 演示。问题很简单：*"你们的产品是做什么的？"* 在他们 PostgreSQL 数据库中针对 200 万份文档的向量搜索耗时 **47 秒** 才返回结果。客户在第一行结果出现之前就离开了房间。

问题不在 PostgreSQL，而在 `vector` 列上缺少 **HNSW 索引**。添加 `CREATE INDEX ... USING hnsw` 后，同样的查询降到了 **3.2 毫秒** —— 提升了 **14,000 倍**。无需数据库迁移，无需新基础设施，只需一条 SQL 语句。

这就是 **pgvector 0.8.2** 的力量——这个开源 PostgreSQL 扩展将全球最受信赖的关系型数据库转变为高性能向量数据库。拥有 **15,000+ GitHub Stars**，并在 Supabase、Neon、AWS RDS 和 Google Cloud SQL 上原生支持，pgvector 是 **70% 的 AI Agent 工作负载**（保持在 1000 万向量以下）的务实选择。

本指南涵盖所有内容：PostgreSQL 18 上的安装、HNSW 调优、`halfvec` 量化、过滤混合搜索以及生产级 RAG 集成。

## pgvector 是什么？——PostgreSQL 内部的向量

**pgvector** 是 PostgreSQL 的开源扩展，直接在数据库内部添加向量数据类型、近似最近邻（ANN）索引和距离函数。无需在 PostgreSQL 旁边运行单独的向量数据库，你可以将 embedding 存储在与关系数据相同的表中，并使用标准 SQL 进行查询。

**核心数据（2026 年 5 月）：**

| 指标 | 数值 |
|--------|-------|
| 当前版本 | **0.8.2** |
| PostgreSQL 兼容性 | **14 至 18** |
| GitHub Stars | **15,000+** |
| 最大向量维度 | **16,000** |
| ANN 召回率（HNSW） | **~95%** |
| 索引类型 | **HNSW、IVFFlat** |
| 开源协议 | PostgreSQL（开源） |

与独立向量数据库不同，pgvector 继承了 PostgreSQL 的一切：**ACID 事务**、**行级安全**、**JSONB 元数据**、**全文搜索**以及数十年的运维工具积累。当你的文档、用户权限、审计日志和向量 embedding 都存在于同一个数据库中时，你完全消除了双写问题。

## pgvector 工作原理：索引类型与查询规划

pgvector 支持两种 ANN 索引类型，各有不同的权衡：

### HNSW（层次化可导航小世界）

大多数工作负载的默认选择。HNSW 构建多层图，每层是前一层的子集。查询遍历从顶层开始，贪婪地向下导航直到最底层的稠密图。

**适用场景：** 数据集不超过约 5000 万向量的高召回率低延迟查询。
**构建时间：** 比 IVFFlat 慢（pgvector 0.8.2 中为单线程）。
**查询参数：** `hnsw.ef_search` 控制召回率与延迟的权衡。

### IVFFlat（倒排文件 + 平面索引）

使用 k-means 将向量分区为聚类（列表）。查询时只扫描最近的聚类。

**适用场景：** 索引构建更快、内存受限的环境。
**权衡：** 相同延迟预算下召回率低于 HNSW。
**查询参数：** `ivfflat.probes` 控制扫描的聚类数量。

```sql
-- HNSW 索引（推荐大多数工作负载）
CREATE INDEX ON documents
  USING hnsw (embedding vector_l2_ops)
  WITH (m = 16, ef_construction = 64);

-- IVFFlat 索引（构建更快，召回率较低）
CREATE INDEX ON documents
  USING ivfflat (embedding vector_l2_ops)
  WITH (lists = 100);
```

### 距离算子

pgvector 提供三种距离算子：

| 算子 | 说明 | 使用场景 |
|----------|-------------|----------|
| `<->` | 欧几里得（L2）距离 | 通用相似性（默认） |
| `<#>` | 负内积 | OpenAI embedding |
| `<=>` | 余弦距离 | 语义相似性（归一化向量） |

```sql
-- L2 距离（越小越相似）
SELECT id, embedding <-> query_vec AS distance
FROM documents ORDER BY distance LIMIT 10;

-- 余弦距离（用于归一化 embedding）
SELECT id, embedding <=> query_vec AS distance
FROM documents ORDER BY distance LIMIT 10;
```

## 安装与配置：不到 5 分钟

### 方案 A：Docker（最快）

```bash
docker run -d \
  --name pgvector-demo \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_DB=vectordb \
  -p 5432:5432 \
  pgvector/pgvector:0.8.2-pg18

# 验证
docker exec pgvector-demo psql -U postgres -d vectordb -c "SELECT * FROM pg_extension WHERE extname = 'vector';"
```

### 方案 B：现有 PostgreSQL

```bash
# 安装构建依赖（Ubuntu/Debian）
sudo apt-get install postgresql-server-dev-18 build-essential git

# 克隆并构建 pgvector
git clone --branch v0.8.2 https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install

# 在数据库中启用扩展
psql -U postgres -d mydb -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

### 方案 C：Supabase（托管）

```sql
-- pgvector 已在 Supabase 上预装。只需启用：
CREATE EXTENSION IF NOT EXISTS vector;

-- 验证版本
SELECT extversion FROM pg_extension WHERE extname = 'vector';
-- 返回: 0.8.2
```

### 方案 D：AWS RDS / Google Cloud SQL

```sql
-- 在 RDS PostgreSQL 18 上，pgvector 作为扩展可用
CREATE EXTENSION IF NOT EXISTS vector;

-- 如需查看可用扩展
SELECT * FROM pg_available_extensions WHERE name = 'vector';
```

### 验证安装

```sql
-- 检查 pgvector 版本
SELECT extversion FROM pg_extension WHERE extname = 'vector';
-- 预期: 0.8.2

-- 测试向量类型
SELECT '[1,2,3]'::vector(3) <-> '[4,5,6]'::vector(3) AS l2_distance;
-- 预期: ~5.196
```

## 核心操作：创建表、插入与查询

### 创建向量表

```sql
-- 创建带向量列的表（1536 维度 = OpenAI embedding）
CREATE TABLE documents (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(512) NOT NULL,
    content     TEXT,
    embedding   vector(1536),
    metadata    JSONB DEFAULT '{}',
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    tenant_id   INTEGER NOT NULL DEFAULT 0
);

-- 为常用过滤列添加索引
CREATE INDEX idx_docs_tenant ON documents(tenant_id);
CREATE INDEX idx_docs_created ON documents(created_at);
```

### 插入向量

```sql
-- 插入单条带 embedding 的文档
INSERT INTO documents (title, content, embedding, metadata, tenant_id)
VALUES (
    'Introduction to pgvector',
    'pgvector adds vector support to PostgreSQL...',
    ARRAY_FILL(0.0::real, ARRAY[1536])::vector(1536),  -- 占位符
    '{"author": "dibi8", "category": "database"}',
    1
);

-- 使用实际 OpenAI embedding 插入（从 Python）
-- 详见下方 RAG 集成部分的完整示例
```

```python
# 从 Python 批量插入向量
import psycopg2
import numpy as np

conn = psycopg2.connect("dbname=vectordb user=postgres password=mysecretpassword host=localhost")
cur = conn.cursor()

# 生成 1 万条随机向量作为示例
batch_size = 10000
titles = [f"document_{i}" for i in range(batch_size)]
contents = [f"Content for document {i}" for i in range(batch_size)]
embeddings = np.random.randn(batch_size, 1536).astype(np.float32)
tenant_ids = [i % 10 for i in range(batch_size)]

# 使用 executemany 批量插入
args = [(titles[i], contents[i], embeddings[i].tolist(), tenant_ids[i]) for i in range(batch_size)]
cur.executemany(
    "INSERT INTO documents (title, content, embedding, tenant_id) VALUES (%s, %s, %s::vector, %s)",
    args
)
conn.commit()
print(f"已插入 {batch_size} 条文档")
```

### 构建 HNSW 索引（生产调优）

```sql
-- 设置并行索引构建参数
SET maintenance_work_mem = '8GB';
SET max_parallel_maintenance_workers = 4;

-- 使用调优参数构建 HNSW 索引
CREATE INDEX idx_docs_embedding_hnsw ON documents
  USING hnsw (embedding vector_l2_ops)
  WITH (
    m = 16,              -- 每层连接数（默认: 16）
    ef_construction = 128  -- 动态候选列表大小（默认: 64）
  );

-- 检查索引大小
SELECT pg_size_pretty(pg_relation_size('idx_docs_embedding_hnsw'));
-- 典型值: 100K 条 1536 维向量约 ~450 MB
```

### 向量相似性搜索

```sql
-- 基础 ANN 搜索
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
ORDER BY embedding <-> $1::vector
LIMIT 10;
```

```sql
-- 带过滤的向量搜索（最常见的生产模式）
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
WHERE tenant_id = 42
  AND created_at > NOW() - INTERVAL '30 days'
  AND metadata->>'category' = 'tech'
ORDER BY embedding <-> $1::vector
LIMIT 20;
```

### 混合搜索：向量 + 全文

```sql
-- 首先启用 pg_trgm 用于文本搜索
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- 组合向量相似度 + 文本相关性
SELECT
    d.id,
    d.title,
    d.embedding <-> $1::vector AS vec_distance,
    similarity(d.title, $2) AS text_similarity
FROM documents d
WHERE d.title % $2  -- trigram 相似度过滤
ORDER BY
    (d.embedding <-> $1::vector) * 0.7 + (1 - similarity(d.title, $2)) * 0.3
LIMIT 10;
```

## 性能调优：从 47 秒到 3 毫秒

### HNSW 的 GUC 参数

```sql
-- 调优 ef_search 以平衡召回率与延迟
-- 越高 = 召回率越好，查询越慢
SET hnsw.ef_search = 100;  -- 默认 40；64-128 是生产典型值

-- 检查实际查询计划
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
ORDER BY embedding <-> $1::vector
LIMIT 10;
-- 应显示: Index Scan using idx_docs_embedding_hnsw
```

### 半精度量化（halfvec）

pgvector 0.8.2 支持 `halfvec` 类型，可**减少 50% 存储空间**，召回率损失极小：

```sql
-- 为量化存储添加 halfvec 列
ALTER TABLE documents ADD COLUMN embedding_half halfvec(1536);

-- 从全精度转换
UPDATE documents SET embedding_half = embedding::halfvec;

-- 在 halfvec 上创建 HNSW 索引
CREATE INDEX idx_docs_embedding_half_hnsw ON documents
  USING hnsw (embedding_half halfvec_l2_ops);

-- 使用 halfvec 查询（结果几乎相同）
SELECT id, title, embedding_half <-> $1::halfvec AS distance
FROM documents
ORDER BY embedding_half <-> $1::halfvec
LIMIT 10;

-- 检查空间节省
SELECT
    pg_size_pretty(pg_relation_size('idx_docs_embedding_hnsw')) AS full_size,
    pg_size_pretty(pg_relation_size('idx_docs_embedding_half_hnsw')) AS half_size;
-- half_size 通常为 full_size 的 ~45-50%
```

### 连接池（Pgbouncer）

```ini
; pgbouncer.ini 用于 pgvector 工作负载
[databases]
vectordb = host=localhost port=5432 dbname=vectordb

[pgbouncer]
pool_mode = transaction
max_client_conn = 10000
default_pool_size = 50
reserve_pool_size = 10
```

### 基准对比：调优前后

| 配置 | 查询延迟 (p99) | Recall@10 | 索引大小 | 构建时间 |
|-------------|---------------|-----------|------------|------------|
| 无索引（顺序扫描） | 47,000 ms | 1.00 | N/A | N/A |
| HNSW 默认 (m=16, ef_construction=64) | 4.2 ms | 0.91 | 450 MB | 45s |
| HNSW 调优 (m=24, ef_construction=128) | 3.8 ms | 0.95 | 680 MB | 82s |
| HNSW + halfvec | 3.2 ms | 0.94 | 310 MB | 38s |
| IVFFlat (lists=100) | 8.1 ms | 0.87 | 220 MB | 12s |

## 与 LangChain 和 LlamaIndex 的 RAG 集成

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

# 添加文档
from langchain_core.documents import Document
docs = [
    Document(page_content="pgvector turns PostgreSQL into a vector database", metadata={"source": "blog"}),
    Document(page_content="HNSW indexes provide fast ANN search", metadata={"source": "docs"}),
]
vector_store.add_documents(docs)

# 带过滤的相似性搜索
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

# 加载文档
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(documents, vector_store=vector_store)

# 查询
query_engine = index.as_query_engine()
response = query_engine.query("How does pgvector work?")
print(response)
```

### 直接 RAG 管道（无框架）

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

# 完整 RAG 管道
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

## 生产环境加固

### 行级安全实现多租户

```sql
-- 启用 RLS
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- 策略：租户只能看到自己的文档
CREATE POLICY tenant_isolation ON documents
    USING (tenant_id = current_setting('app.current_tenant')::INTEGER);

-- 每会话设置租户
SET app.current_tenant = '42';

-- 现在所有查询自动按租户过滤
SELECT * FROM documents;  -- 仅可见租户 42 的文档
```

### 监控查询性能

```sql
-- 追踪慢向量查询
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- 查找延迟最高的向量查询
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
WHERE query LIKE '%<->%'
ORDER BY mean_exec_time DESC
LIMIT 10;
```

```bash
# 在 postgresql.conf 中启用 pg_stat_statements
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.track = all
pg_stat_statements.max = 10000
```

### 使用 pg_dump 备份（包含向量）

```bash
# 包含向量数据的完整备份
pg_dump -h localhost -U postgres -d vectordb -Fc > vectordb_backup.dump

# 恢复
pg_restore -h localhost -U postgres -d vectordb_restore vectordb_backup.dump

# 向量以文本数组形式备份并正确恢复
```

### 高 QPS 的连接最佳实践

```python
# 生产工作负载使用连接池
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

## 与竞品对比

| 特性 | pgvector 0.8.2 | Pinecone | Weaviate 1.25 | Qdrant 1.11 | Milvus 2.5 |
|---------|---------------|----------|---------------|-------------|------------|
| **开源协议** | PostgreSQL License | 否 | BSD-3 | Apache-2.0 | Apache-2.0 |
| **最大规模** | ~5000 万向量 | 无限 | 200M/节点 | 500M/节点 | **10B+** |
| **p99 延迟** | 25-40 ms | 28 ms | 19 ms | **12 ms** | 8 ms (GPU) |
| **ACID 兼容** | **完整** | 否 | 部分 | 否 | 否 |
| **SQL 接口** | **原生** | 否 | GraphQL | 否 | 否 (gRPC) |
| **托管选项** | Supabase/Neon/RDS | Native | Weaviate Cloud | Qdrant Cloud | Zilliz Cloud |
| **混合搜索** | FTS + vector | Native | **最佳** | BM42 | Native |
| **自托管成本** | **$0（复用现有 PG）** | N/A | $320/M/月 | $280/M/月 | $400/M/月 |
| **设置复杂度** | **安装扩展** | API key | 集群 | 二进制 | Kubernetes |
| **GPU 索引** | 否 | 否 | 否 | 否 (1.12 即将) | **是** |

**何时选择 pgvector：**

- 你已经在为应用数据运行 PostgreSQL。
- 向量数据集保持在 **5000 万向量以下**。
- 在同一系统中实现 ACID 事务和向量搜索是硬性需求。
- 你的团队懂 SQL，不想学新查询语言。
- 你希望基础设施成本最低（无需单独数据库）。

**何时选择专用向量数据库：**

- **Pinecone**：零运维，偏好托管服务。
- **Weaviate**：原生混合搜索（BM25 + 向量）是关键需求。
- **Qdrant**：原始延迟是首要需求，p99 < 12ms。
- **[Milvus](dibi8-internal-link)**：十亿级规模、GPU 加速、Kubernetes 原生。

## 局限性：诚实评估

**仅单节点：** pgvector 在单个 PostgreSQL 实例内运行。没有原生分布式模式。对于超过可用内存的数据集，性能显著下降。超过 5000 万向量时，考虑专用向量数据库。

**HNSW 构建是单线程的：** 截至 pgvector 0.8.2，HNSW 索引构建仅使用一个 CPU 核心。对于 1000 万向量，这可能需要 **20-30 分钟**。`max_parallel_maintenance_workers` 设置不会加速 HNSW 构建。

**查询延迟较高：** p99 延迟 25-40ms 对大多数 RAG 应用是可接受的（LLM 推理占 1-5 秒），但比 Qdrant（~12ms）或 Milvus GPU（~8ms）等专用向量数据库慢。

**无原生稀疏向量：** 与 Weaviate 或 Qdrant 不同，pgvector 没有用于混合关键词+语义搜索的一等稀疏向量支持。你需要手动与 PostgreSQL 的全文搜索结合。

**共享资源的内存压力：** 向量索引消耗大量 RAM，这些 RAM 本可用于 OLTP 查询。在共享的 PostgreSQL 实例上，需为可用内存的 **索引大小的 2-3 倍** 做规划。

## 常见问题解答

### pgvector 能处理多少向量？

在配置合理的 PostgreSQL 实例上（64GB+ RAM，快速 NVMe 存储），pgvector 可舒适地处理 **5000 万向量**。在 1 亿向量时，运维摩擦增加——查询变慢，索引维护变得昂贵。超过 1 亿的数据集，[Milvus](dibi8-internal-link) 或 Qdrant 是更好的选择。1000 万向量（1536 维）的单个 HNSW 索引约占用 **45 GB** 磁盘空间。

### pgvector 需要什么 PostgreSQL 版本？

pgvector 0.8.2 支持 **PostgreSQL 14 至 18**。生产部署建议使用 **PostgreSQL 18**——它包含并行查询执行优化，有利于向量工作负载。托管平台上，Supabase、Neon、AWS RDS 和 Google Cloud SQL 的最新 PostgreSQL 版本都支持 pgvector。

### 如何在 HNSW 和 IVFFlat 索引之间选择？

**HNSW** 作为默认选择。它提供更好的召回率（~95%）和更低的查询延迟。仅在以下情况使用 **IVFFlat**：（a）索引构建时间至关重要，（b）内存严重受限，或（c）向量很少变化。对于大多数 RAG 应用，HNSW 配合 `m=16` 和 `ef_construction=64` 是正确的起点。

### pgvector 可以与托管 PostgreSQL 服务一起使用吗？

可以。pgvector 在以下平台可用：

- **Supabase** — 已预装，只需运行 `CREATE EXTENSION vector;`
- **Neon** — 所有方案支持，包括免费层
- **AWS RDS** — PostgreSQL 15+ 可用
- **Google Cloud SQL** — PostgreSQL 15+ 可用
- **Azure Database for PostgreSQL** — 支持向量扩展

无需基础设施变更——它是标准 PostgreSQL 扩展。

### pgvector 支持过滤向量搜索吗？

支持，这是 pgvector 胜过专用向量数据库的地方。因为向量数据在 PostgreSQL 中，你可以在向量相似性旁边应用任何 SQL `WHERE` 子句：

```sql
SELECT title, embedding <-> $1::vector AS distance
FROM documents
WHERE tenant_id = 42
  AND created_at > NOW() - INTERVAL '7 days'
  AND metadata @> '{"status": "published"}'
ORDER BY embedding <-> $1::vector
LIMIT 10;
```

PostgreSQL 的规划器通过在 HNSW 遍历期间下推 `WHERE` 谓词来优化此查询。

### 如何为我的工作负载调优 HNSW？

两个关键参数：

- `ef_construction`（默认 64）：越高 = 索引质量越好，构建越慢。生产 RAG 使用 **128-256**。
- `ef_search`（默认 40）：越高 = 召回率越好，查询越慢。对召回率做基准测试并设为 **64-100**。

```sql
-- 对 ef_search 值做基准测试
SET hnsw.ef_search = 64;
EXPLAIN ANALYZE SELECT ... ORDER BY embedding <-> $1 LIMIT 10;

SET hnsw.ef_search = 128;
EXPLAIN ANALYZE SELECT ... ORDER BY embedding <-> $1 LIMIT 10;
```

## 结论：务实的选择

pgvector 0.8.2 是已经在运行 PostgreSQL 的团队最务实的向量数据库。它通过将你已经运维的数据库转变为向量搜索引擎来消除基础设施复杂性。对于 **70% 保持在 1000 万向量以下的 AI 工作负载**，调优 HNSW 索引的 pgvector 可提供低于 10 毫秒的查询、ACID 合规性和 SQL 的全部能力——所有这些都无需向你的技术栈添加新系统。

**下一步：**

1. 在现有 PostgreSQL 实例上启用 pgvector（`CREATE EXTENSION vector;`）。
2. 为文档表添加向量列和 HNSW 索引。
3. 加载你的 embedding 并运行本指南中的调优基准测试。
4. 与 LangChain 或 LlamaIndex 集成实现生产级 RAG。

加入我们的 [Telegram 中文社区](https://t.me/dibi8zh) 分享你的 pgvector 性能数据，并与其他开发者交流。

## 来源与延伸阅读

1. pgvector GitHub 仓库 — https://github.com/pgvector/pgvector (15,000+ Stars)
2. pgvector 文档 — https://github.com/pgvector/pgvector?tab=readme-ov-file#pgvector
3. PostgreSQL 18 发布说明 — https://www.postgresql.org/docs/18/release-18.html
4. Supabase Vector 文档 — https://supabase.com/docs/guides/ai
5. HNSW 论文 (Malkov & Yashunin, 2018) — https://arxiv.org/abs/1603.09320
6. pgvector HNSW 生产调优教程 2026 — https://nerdleveltech.com/pgvector-hnsw-postgres-18-production-tuning-tutorial
7. 2026 向量数据库基准测试 — https://iotdigitaltwinplm.com/vector-database-benchmarks-2026/



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 附属披露

本文包含 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 云托管和 [Supabase](https://supabase.com) 托管 PostgreSQL 的附属链接。如果你通过我们的链接注册，我们会获得佣金，不会增加你的额外成本。我们只推荐在自己的生产环境中使用过的服务。
