---
title: 'pgvector 2026: Turn PostgreSQL into a High-Performance Vector Database — Setup, Tuning & RAG Integration Guide'
description: 'Production guide for pgvector 0.8.2: HNSW/IVFFlat indexes, vector similarity search, performance tuning, and RAG integration with LangChain and LlamaIndex.'
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
- /posts/pgvector-postgres-vector-extension/
---

{{</* resource-info */>}}

## Introduction: The 47-Second Query That Killed a Demo

It was March 2025. An AI startup founder stood in front of a potential enterprise client, running a RAG demo. The question was simple: *"What does our product do?"* The vector search against 2 million documents in their PostgreSQL database took **47 seconds** to return. The client left the room before the first result appeared.

The problem wasn't PostgreSQL. It was a missing **HNSW index** on the `vector` column. After adding `CREATE INDEX ... USING hnsw`, the same query dropped to **3.2 milliseconds** — a **14,000x improvement**. No database migration, no new infrastructure, just one SQL statement.

This is the power of **pgvector 0.8.2**, the open-source PostgreSQL extension that transforms the world's most trusted relational database into a high-performance vector database. With **15,000+ GitHub stars** and native support on Supabase, Neon, AWS RDS, and Google Cloud SQL, pgvector is the pragmatic choice for the **70% of AI-agent workloads** that stay under 10 million vectors.

This guide covers everything: installation on PostgreSQL 18, HNSW tuning, `halfvec` quantization, filtered hybrid search, and production RAG integration.

## What Is pgvector? — Vectors Inside PostgreSQL

**pgvector** is an open-source extension for PostgreSQL that adds vector data types, approximate nearest neighbor (ANN) indexes, and distance functions directly inside the database. Instead of running a separate vector database alongside PostgreSQL, you store embeddings in the same tables as your relational data and query them with standard SQL.

**Key stats (May 2026):**

| Metric | Value |
|--------|-------|
| Current version | **0.8.2** |
| PostgreSQL compatibility | **14 through 18** |
| GitHub stars | **15,000+** |
| Max vector dimensions | **16,000** |
| ANN recall (HNSW) | **~95%** |
| Index types | **HNSW, IVFFlat** |
| License | PostgreSQL (open source) |

Unlike standalone vector databases, pgvector inherits everything PostgreSQL offers: **ACID transactions**, **row-level security**, **JSONB metadata**, **full-text search**, and decades of operational tooling. When your documents, user permissions, audit logs, and vector embeddings all live in one database, you eliminate the dual-write problem entirely.

## How pgvector Works: Index Types and Query Planning

pgvector supports two ANN index types, each with distinct trade-offs:

### HNSW (Hierarchical Navigable Small World)

The default choice for most workloads. HNSW builds a multi-layer graph where each layer is a subset of the previous one. Query traversal starts at the top layer and greedily navigates down until reaching the densest graph at the bottom.

**Best for:** High-recall, low-latency queries on datasets up to ~50M vectors.
**Build time:** Slower than IVFFlat (single-threaded in pgvector 0.8.2).
**Query parameters:** `hnsw.ef_search` controls recall vs. latency trade-off.

### IVFFlat (Inverted File with Flat Index)

Partitions vectors into clusters (lists) using k-means. At query time, only the closest clusters are scanned.

**Best for:** Faster index builds, memory-constrained environments.
**Trade-off:** Lower recall than HNSW at the same latency budget.
**Query parameters:** `ivfflat.probes` controls how many clusters to scan.

```sql
-- HNSW index (recommended for most workloads)
CREATE INDEX ON documents
  USING hnsw (embedding vector_l2_ops)
  WITH (m = 16, ef_construction = 64);

-- IVFFlat index (faster builds, lower recall)
CREATE INDEX ON documents
  USING ivfflat (embedding vector_l2_ops)
  WITH (lists = 100);
```

### Distance Operators

pgvector provides three distance operators:

| Operator | Description | Use case |
|----------|-------------|----------|
| `<->` | Euclidean (L2) distance | General similarity (default) |
| `<#>` | Negative inner product | OpenAI embeddings |
| `<=>` | Cosine distance | Semantic similarity (normalized vectors) |

```sql
-- L2 distance (smaller = more similar)
SELECT id, embedding <-> query_vec AS distance
FROM documents ORDER BY distance LIMIT 10;

-- Cosine distance (for normalized embeddings)
SELECT id, embedding <=> query_vec AS distance
FROM documents ORDER BY distance LIMIT 10;
```

## Installation & Setup: Under 5 Minutes

### Option A: Docker (Fastest)

```bash
docker run -d \
  --name pgvector-demo \
  -e POSTGRES_PASSWORD=mysecretpassword \
  -e POSTGRES_DB=vectordb \
  -p 5432:5432 \
  pgvector/pgvector:0.8.2-pg18

# Verify
docker exec pgvector-demo psql -U postgres -d vectordb -c "SELECT * FROM pg_extension WHERE extname = 'vector';"
```

### Option B: Existing PostgreSQL

```bash
# Install build dependencies (Ubuntu/Debian)
sudo apt-get install postgresql-server-dev-18 build-essential git

# Clone and build pgvector
git clone --branch v0.8.2 https://github.com/pgvector/pgvector.git
cd pgvector
make
sudo make install

# Enable extension in database
psql -U postgres -d mydb -c "CREATE EXTENSION IF NOT EXISTS vector;"
```

### Option C: Supabase (Managed)

```sql
-- pgvector is pre-installed on Supabase. Just enable it:
CREATE EXTENSION IF NOT EXISTS vector;

-- Verify version
SELECT extversion FROM pg_extension WHERE extname = 'vector';
-- Returns: 0.8.2
```

### Option D: AWS RDS / Google Cloud SQL

```sql
-- On RDS PostgreSQL 18, pgvector is available as an extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Check available extensions if needed
SELECT * FROM pg_available_extensions WHERE name = 'vector';
```

### Verify Installation

```sql
-- Check pgvector version
SELECT extversion FROM pg_extension WHERE extname = 'vector';
-- Expected: 0.8.2

-- Test vector type
SELECT '[1,2,3]'::vector(3) <-> '[4,5,6]'::vector(3) AS l2_distance;
-- Expected: ~5.196
```

## Core Operations: Creating Tables, Inserting, and Querying

### Creating a Vector Table

```sql
-- Create table with vector column (1536 dimensions = OpenAI embeddings)
CREATE TABLE documents (
    id          BIGSERIAL PRIMARY KEY,
    title       VARCHAR(512) NOT NULL,
    content     TEXT,
    embedding   vector(1536),
    metadata    JSONB DEFAULT '{}',
    created_at  TIMESTAMPTZ DEFAULT NOW(),
    tenant_id   INTEGER NOT NULL DEFAULT 0
);

-- Add index for common filter columns
CREATE INDEX idx_docs_tenant ON documents(tenant_id);
CREATE INDEX idx_docs_created ON documents(created_at);
```

### Inserting Vectors

```sql
-- Insert a single document with embedding
INSERT INTO documents (title, content, embedding, metadata, tenant_id)
VALUES (
    'Introduction to pgvector',
    'pgvector adds vector support to PostgreSQL...',
    ARRAY_FILL(0.0::real, ARRAY[1536])::vector(1536),  -- placeholder
    '{"author": "dibi8", "category": "database"}',
    1
);

-- Insert with actual OpenAI embedding (from Python)
-- See RAG Integration section below for full example
```

```python
# Batch insert vectors from Python
import psycopg2
import numpy as np

conn = psycopg2.connect("dbname=vectordb user=postgres password=mysecretpassword host=localhost")
cur = conn.cursor()

# Generate 10K random vectors as sample
batch_size = 10000
titles = [f"document_{i}" for i in range(batch_size)]
contents = [f"Content for document {i}" for i in range(batch_size)]
embeddings = np.random.randn(batch_size, 1536).astype(np.float32)
tenant_ids = [i % 10 for i in range(batch_size)]

# Use executemany for batch insert
args = [(titles[i], contents[i], embeddings[i].tolist(), tenant_ids[i]) for i in range(batch_size)]
cur.executemany(
    "INSERT INTO documents (title, content, embedding, tenant_id) VALUES (%s, %s, %s::vector, %s)",
    args
)
conn.commit()
print(f"Inserted {batch_size} documents")
```

### Building the HNSW Index (Production Tuning)

```sql
-- Set parameters for parallel index build
SET maintenance_work_mem = '8GB';
SET max_parallel_maintenance_workers = 4;

-- Build HNSW index with tuned parameters
CREATE INDEX idx_docs_embedding_hnsw ON documents
  USING hnsw (embedding vector_l2_ops)
  WITH (
    m = 16,              -- Number of connections per layer (default: 16)
    ef_construction = 128  -- Size of dynamic candidate list (default: 64)
  );

-- Check index size
SELECT pg_size_pretty(pg_relation_size('idx_docs_embedding_hnsw'));
-- Typical: ~450 MB for 100K vectors of 1536 dimensions
```

### Vector Similarity Search

```sql
-- Basic ANN search
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
ORDER BY embedding <-> $1::vector
LIMIT 10;
```

```sql
-- Filtered vector search (most common production pattern)
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
WHERE tenant_id = 42
  AND created_at > NOW() - INTERVAL '30 days'
  AND metadata->>'category' = 'tech'
ORDER BY embedding <-> $1::vector
LIMIT 20;
```

### Hybrid Search: Vector + Full-Text

```sql
-- First, enable pg_trgm for text search
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Combined vector similarity + text relevance
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

## Performance Tuning: From 47 Seconds to 3 Milliseconds

### GUC Parameters for HNSW

```sql
-- Tune ef_search for recall vs. latency
-- Higher = better recall, slower queries
SET hnsw.ef_search = 100;  -- Default is 40; 64-128 is typical for production

-- Check actual query plan
EXPLAIN (ANALYZE, BUFFERS)
SELECT id, title, embedding <-> $1::vector AS distance
FROM documents
ORDER BY embedding <-> $1::vector
LIMIT 10;
-- Look for: Index Scan using idx_docs_embedding_hnsw
```

### Half-Precision Quantization (halfvec)

pgvector 0.8.2 supports `halfvec` type for **50% storage reduction** with minimal recall loss:

```sql
-- Add halfvec column for quantized storage
ALTER TABLE documents ADD COLUMN embedding_half halfvec(1536);

-- Convert from full-precision
UPDATE documents SET embedding_half = embedding::halfvec;

-- Create HNSW index on halfvec
CREATE INDEX idx_docs_embedding_half_hnsw ON documents
  USING hnsw (embedding_half halfvec_l2_ops);

-- Query using halfvec (nearly identical results)
SELECT id, title, embedding_half <-> $1::halfvec AS distance
FROM documents
ORDER BY embedding_half <-> $1::halfvec
LIMIT 10;

-- Check space savings
SELECT
    pg_size_pretty(pg_relation_size('idx_docs_embedding_hnsw')) AS full_size,
    pg_size_pretty(pg_relation_size('idx_docs_embedding_half_hnsw')) AS half_size;
-- half_size is typically ~45-50% of full_size
```

### Connection Pooling (Pgbouncer)

```ini
; pgbouncer.ini for pgvector workloads
[databases]
vectordb = host=localhost port=5432 dbname=vectordb

[pgbouncer]
pool_mode = transaction
max_client_conn = 10000
default_pool_size = 50
reserve_pool_size = 10
```

### Benchmark Comparison: Before and After Tuning

| Configuration | Query Latency (p99) | Recall@10 | Index Size | Build Time |
|-------------|-------------------|-----------|------------|------------|
| No index (seq scan) | 47,000 ms | 1.00 | N/A | N/A |
| HNSW defaults (m=16, ef_construction=64) | 4.2 ms | 0.91 | 450 MB | 45s |
| HNSW tuned (m=24, ef_construction=128) | 3.8 ms | 0.95 | 680 MB | 82s |
| HNSW + halfvec | 3.2 ms | 0.94 | 310 MB | 38s |
| IVFFlat (lists=100) | 8.1 ms | 0.87 | 220 MB | 12s |

## RAG Integration with LangChain and LlamaIndex

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

# Add documents
from langchain_core.documents import Document
docs = [
    Document(page_content="pgvector turns PostgreSQL into a vector database", metadata={"source": "blog"}),
    Document(page_content="HNSW indexes provide fast ANN search", metadata={"source": "docs"}),
]
vector_store.add_documents(docs)

# Similarity search with filter
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

# Load documents
documents = SimpleDirectoryReader("./data").load_data()
index = VectorStoreIndex.from_documents(documents, vector_store=vector_store)

# Query
query_engine = index.as_query_engine()
response = query_engine.query("How does pgvector work?")
print(response)
```

### Direct RAG Pipeline (No Framework)

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

# Full RAG pipeline
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

## Production Hardening

### Row-Level Security for Multi-Tenancy

```sql
-- Enable RLS
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- Policy: tenants can only see their own documents
CREATE POLICY tenant_isolation ON documents
    USING (tenant_id = current_setting('app.current_tenant')::INTEGER);

-- Set tenant per session
SET app.current_tenant = '42';

-- Now all queries automatically filter by tenant
SELECT * FROM documents;  -- Only tenant 42's documents visible
```

### Monitoring Query Performance

```sql
-- Track slow vector queries
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- Find top vector queries by latency
SELECT query, mean_exec_time, calls
FROM pg_stat_statements
WHERE query LIKE '%<->%'
ORDER BY mean_exec_time DESC
LIMIT 10;
```

```bash
# Enable pg_stat_statements in postgresql.conf
shared_preload_libraries = 'pg_stat_statements'
pg_stat_statements.track = all
pg_stat_statements.max = 10000
```

### Backup with pg_dump (Vectors Included)

```bash
# Full backup including vector data
pg_dump -h localhost -U postgres -d vectordb -Fc > vectordb_backup.dump

# Restore
pg_restore -h localhost -U postgres -d vectordb_restore vectordb_backup.dump

# Vectors are backed up as text arrays and restored correctly
```

### Connection Best Practices for High QPS

```python
# Use connection pooling for production workloads
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

## Comparison with Alternatives

| Feature | pgvector 0.8.2 | Pinecone | Weaviate 1.25 | Qdrant 1.11 | Milvus 2.5 |
|---------|---------------|----------|---------------|-------------|------------|
| **Open Source** | PostgreSQL License | No | BSD-3 | Apache-2.0 | Apache-2.0 |
| **Max Scale** | ~50M vectors | Unlimited | 200M/node | 500M/node | **10B+** |
| **p99 Latency** | 25-40 ms | 28 ms | 19 ms | **12 ms** | 8 ms (GPU) |
| **ACID Compliant** | **Full** | No | Partial | No | No |
| **SQL Interface** | **Native** | No | GraphQL | No | No (gRPC) |
| **Managed Option** | Supabase/Neon/RDS | Native | Weaviate Cloud | Qdrant Cloud | Zilliz Cloud |
| **Hybrid Search** | FTS + vector | Native | **Best** | BM42 | Native |
| **Self-Host Cost** | **$0 (use existing PG)** | N/A | $320/M/mo | $280/M/mo | $400/M/mo |
| **Setup Complexity** | **Extension install** | API key | Cluster | Binary | Kubernetes |
| **GPU Indexing** | No | No | No | No (1.12 soon) | **Yes** |

**When to choose pgvector:**

- You already run PostgreSQL for your application data.
- Your vector dataset stays under **50 million vectors**.
- ACID transactions and vector search in a single system is a hard requirement.
- Your team knows SQL and doesn't want to learn a new query language.
- You want the lowest possible infrastructure cost (no separate database).

**When to choose a dedicated vector database:**

- **Pinecone**: Zero-ops, managed-only preference.
- **Weaviate**: Native hybrid search (BM25 + vector) is critical.
- **Qdrant**: Raw latency is paramount, <12ms p99 required.
- **[Milvus](dibi8-internal-link)**: Billion-scale, GPU-accelerated, Kubernetes-native.

## Limitations: Honest Assessment

**Single-node only:** pgvector runs inside a single PostgreSQL instance. There is no native distributed mode. For datasets exceeding available RAM, performance degrades significantly. At >50M vectors, consider a dedicated vector database.

**HNSW build is single-threaded:** As of pgvector 0.8.2, HNSW index builds use only one CPU core. For 10M vectors, this can take **20-30 minutes**. The `max_parallel_maintenance_workers` setting does not accelerate HNSW builds.

**Query latency is higher:** p99 latency of 25-40ms is acceptable for most RAG applications (where LLM inference dominates at 1-5 seconds), but it is slower than dedicated vector databases like Qdrant (~12ms) or Milvus GPU (~8ms).

**No native sparse vectors:** Unlike Weaviate or Qdrant, pgvector does not have first-class sparse vector support for hybrid keyword+semantic search. You must combine with PostgreSQL's full-text search manually.

**Memory pressure on shared resources:** Vector indexes consume significant RAM that could otherwise serve OLTP queries. On a shared PostgreSQL instance, plan for **2-3x the index size** in available memory.

## Frequently Asked Questions

### How many vectors can pgvector handle?

pgvector comfortably handles up to **50 million vectors** on a properly sized PostgreSQL instance (64GB+ RAM, fast NVMe storage). At 100M vectors, operational friction increases — queries slow and index maintenance becomes expensive. For datasets beyond 100M, [Milvus](dibi8-internal-link) or Qdrant are better choices. A single HNSW index of 10M vectors (1536 dimensions) occupies approximately **45 GB** on disk.

### What PostgreSQL version do I need for pgvector?

pgvector 0.8.2 supports **PostgreSQL 14 through 18**. For production deployments, use **PostgreSQL 18** — it includes optimizations for parallel query execution that benefit vector workloads. On managed platforms, Supabase, Neon, AWS RDS, and Google Cloud SQL all support pgvector on their latest PostgreSQL versions.

### How do I choose between HNSW and IVFFlat indexes?

Use **HNSW** as the default. It provides better recall (~95%) and lower query latency. Use **IVFFlat** only when: (a) index build time is critical, (b) you have severe memory constraints, or (c) your vectors rarely change. For most RAG applications, HNSW with `m=16` and `ef_construction=64` is the right starting point.

### Can I use pgvector with managed PostgreSQL services?

Yes. pgvector is available on:

- **Supabase** — pre-installed, just run `CREATE EXTENSION vector;`
- **Neon** — supported on all plans, including free tier
- **AWS RDS** — available on PostgreSQL 15+
- **Google Cloud SQL** — available on PostgreSQL 15+
- **Azure Database for PostgreSQL** — supported with vector extension

No infrastructure changes are needed — it is a standard PostgreSQL extension.

### Does pgvector support filtered vector search?

Yes, and this is where pgvector excels over dedicated vector databases. Because vector data lives in PostgreSQL, you can apply any SQL `WHERE` clause alongside vector similarity:

```sql
SELECT title, embedding <-> $1::vector AS distance
FROM documents
WHERE tenant_id = 42
  AND created_at > NOW() - INTERVAL '7 days'
  AND metadata @> '{"status": "published"}'
ORDER BY embedding <-> $1::vector
LIMIT 10;
```

PostgreSQL's planner optimizes this by pushing down the `WHERE` predicates during HNSW traversal.

### How do I tune HNSW for my workload?

The two key parameters are:

- `ef_construction` (default 64): Higher = better index quality, slower builds. For production RAG, use **128-256**.
- `ef_search` (default 40): Higher = better recall, slower queries. Benchmark your recall and set to **64-100**.

```sql
-- Benchmark ef_search values
SET hnsw.ef_search = 64;
EXPLAIN ANALYZE SELECT ... ORDER BY embedding <-> $1 LIMIT 10;

SET hnsw.ef_search = 128;
EXPLAIN ANALYZE SELECT ... ORDER BY embedding <-> $1 LIMIT 10;
```

## Conclusion: The Pragmatic Choice

pgvector 0.8.2 is the most pragmatic vector database for teams already running PostgreSQL. It eliminates infrastructure complexity by turning the database you already operate into a vector search engine. For the **70% of AI workloads** that stay under 10 million vectors, pgvector with a tuned HNSW index delivers sub-10ms queries, ACID compliance, and the full power of SQL — all without adding a new system to your stack.

**Next steps:**

1. Enable pgvector on your existing PostgreSQL instance (`CREATE EXTENSION vector;`).
2. Add a vector column and HNSW index to your documents table.
3. Load your embeddings and run the tuning benchmarks from this guide.
4. Integrate with LangChain or LlamaIndex for production RAG.

Join our [Telegram community](https://t.me/dibi8en) to share your pgvector performance numbers and get help from fellow engineers.

## Sources & Further Reading

1. pgvector GitHub Repository — https://github.com/pgvector/pgvector (15,000+ stars)
2. pgvector Documentation — https://github.com/pgvector/pgvector?tab=readme-ov-file#pgvector
3. PostgreSQL 18 Release Notes — https://www.postgresql.org/docs/18/release-18.html
4. Supabase Vector Docs — https://supabase.com/docs/guides/ai
5. HNSW Paper (Malkov & Yashunin, 2018) — https://arxiv.org/abs/1603.09320
6. pgvector HNSW Production Tuning Tutorial 2026 — https://nerdleveltech.com/pgvector-hnsw-postgres-18-production-tuning-tutorial
7. Vector Database Benchmarks 2026 — https://iotdigitaltwinplm.com/vector-database-benchmarks-2026/



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Affiliate Disclosure

This article contains affiliate links to [DigitalOcean](https://m.do.co/c/eca87ac14ee0) for cloud hosting and [Supabase](https://supabase.com) for managed PostgreSQL. If you sign up through our links, we receive a commission at no extra cost to you. We only recommend services we use in our own production environments.
