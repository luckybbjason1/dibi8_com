---
title: 'RAGFlow: Deploy a Production-Ready RAG Engine with 80K+ Stars — Docker Setup and Benchmarks for 2026'
description: 'RAGFlow is an open-source retrieval-augmented generation (RAG) engine with deep document understanding and built-in agent capabilities. Compatible with Ollama, OpenAI, Qdrant, Elasticsearch, and Redis. Covers Docker deployment, document ingestion, retrieval tuning, and production hardening.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/infiniflow/ragflow'
stars: 80853
maintainer: 'infiniflow'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['ragflow', 'rag-engine', 'document-understanding', 'docker-deployment', 'llm-agent', 'production-rag', 'open-source-ai']
aliases:
- /posts/ragflow/
---

{{</* resource-info */>}}

![RAGFlow Logo](https://raw.githubusercontent.com/infiniflow/ragflow/main/web/public/logo.svg)

## Introduction

Most RAG pipelines fail in production because they treat PDFs and PowerPoints as plain text. Tables get mangled, image captions disappear, and scanned documents become unreadable. The result is a retrieval system that returns garbage context to your LLM — and hallucinated answers follow. RAGFlow, an open-source RAG engine with over 80,000 GitHub stars, was built to solve exactly this. Its DeepDoc engine understands document layouts, and its built-in agent framework lets you build autonomous knowledge workers, not just chatbots. In this guide, you will deploy RAGFlow on a production server, configure document ingestion, tune retrieval quality, and integrate it with your existing LLM stack.

## What Is RAGFlow?

RAGFlow is an open-source retrieval-augmented generation engine that combines deep document understanding with LLM-powered agents to deliver truthful, cited answers from complex enterprise documents. Unlike generic RAG libraries that rely on simple text splitting, RAGFlow analyzes document structure — tables, images, headers, and scanned pages — to preserve semantic meaning during ingestion. It ships as a Docker-based platform with a web UI, REST API, and agent builder, making it suitable for both developers building pipelines and non-technical users managing knowledge bases.

## How RAGFlow Works

![RAGFlow System Architecture](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/ragflow-architecture.png)

RAGFlow's architecture follows a modular pipeline design with six core stages:

### 1. Document Ingestion (DeepDoc)

Documents enter RAGFlow through the **DeepDoc** parsing engine. DeepDoc performs layout analysis on PDFs, Word files, Excel sheets, PowerPoint slides, images, and scanned copies. It identifies tables, figures, headers, paragraphs, and text blocks using a vision-based document layout model. This stage also supports external parsers like MinerU and Docling for specialized formats.

### 2. Knowledge Extraction and Chunking

After parsing, RAGFlow applies template-based chunking strategies. You can choose from multiple chunking modes — naive, manual, Q&A, table, paper, book, laws, presentation, picture, and one — depending on your document type. Each chunk preserves its structural context, and RAGFlow optionally extracts keywords and generates related questions to improve retrieval recall.

### 3. Indexing (Hybrid Search Backend)

Chunks are indexed into either **Elasticsearch** (default) or **Infinity** for hybrid search. Both full-text search and dense vector search are supported. The system computes embeddings using configurable embedding models and stores vectors alongside inverted indices for keyword retrieval.

### 4. Retrieval and Re-ranking

When a query arrives, RAGFlow performs multi-channel retrieval: keyword search, vector similarity search, and knowledge graph traversal (if GraphRAG is enabled). Results are fused and re-ranked using a cross-encoder re-ranker before being passed to the LLM context window.

### 5. Generation with Citations

RAGFlow constructs a prompt that includes retrieved chunks with traceable citations. The LLM generates an answer grounded in the retrieved context, and RAGFlow displays the source chunks alongside the response so users can verify every claim.

### 6. Agent Execution (Optional)

Beyond simple question answering, RAGFlow's agent framework supports multi-step workflows with memory, tool calling, MCP (Model Context Protocol) integration, and code execution in sandboxed environments. Agents can browse the web, query databases, and chain multiple retrieval operations.

### Infrastructure Stack

| Service | Purpose | Default Backend |
|---------|---------|----------------|
| Vector + Full-Text Store | Document indexing and search | Elasticsearch or Infinity |
| Object Storage | File storage for uploaded documents | MinIO |
| Metadata Database | User data, dataset configs, chat history | MySQL |
| Cache & Queue | Task queuing and session caching | Redis |
| Document Parser | Layout analysis and OCR | DeepDoc (built-in) |
| Frontend | Web UI for dataset management | React + TypeScript |
| Backend API | Core orchestration logic | Python + Go |

## Installation & Setup

### Hardware Requirements

| Resource | Minimum | Recommended for Production |
|----------|---------|---------------------------|
| CPU | 4 cores (x86_64) | 8+ cores |
| RAM | 16 GB | 32+ GB |
| Disk | 50 GB SSD | 200+ GB NVMe |
| Docker | 24.0.0+ | Latest stable |
| Docker Compose | v2.26.1+ | Latest stable |

> **Note:** RAGFlow officially supports x86_64 platforms. ARM64 is community-tested but requires building your own Docker image.

### Pre-Deployment: System Tuning

Before starting RAGFlow, ensure your kernel parameters are tuned for Elasticsearch:

```bash
# Check current vm.max_map_count
sysctl vm.max_map_count

# Set to at least 262144 (required by Elasticsearch)
sudo sysctl -w vm.max_map_count=262144

# Persist across reboots
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

### Step 1: Clone the Repository

```bash
git clone https://github.com/infiniflow/ragflow.git
cd ragflow/docker
git checkout -f v0.25.4
```

### Step 2: Configure Environment Variables

```bash
# Edit the environment file
cp .env .env.backup
nano .env
```

Key variables to set:

```bash
# docker/.env
RAGFLOW_IMAGE=infiniflow/ragflow:v0.25.4
SVR_HTTP_PORT=80
MYSQL_PASSWORD=your_secure_mysql_password
MINIO_PASSWORD=your_secure_minio_password
REDIS_PASSWORD=your_secure_redis_password

# Choose your document engine: elasticsearch or infinity
DOC_ENGINE=elasticsearch
```

### Step 3: Launch with Docker Compose

```bash
# CPU-only deployment
docker compose -f docker-compose.yml up -d

# GPU-accelerated document parsing (NVIDIA)
# sed -i '1i DEVICE=gpu' .env
# docker compose -f docker-compose.yml up -d
```

Verify the deployment:

```bash
# Watch the logs until you see the success message
docker logs -f ragflow-server

# Expected output:
#     ____   ___    ______ ______ __
#    / __ \ /   |  / ____// ____// /____  _      __
#   / /_/ // /| | / / __ / /_   / // __ \| | /| / /
#  / _, _// ___ |/ /_/ // __/  / // /_/ /| |/ |/ /
# /_/ |_|/_/  |_|\____//_/    /_/ \____/ |__/|__/
#  * Running on all addresses (0.0.0.0)
```

### Step 4: Configure Your LLM Provider

Edit `service_conf.yaml.template` to add your LLM API keys:

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: OpenAI
  api_key: sk-your-openai-api-key
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

Supported LLM providers include OpenAI, Anthropic, DeepSeek, Gemini, Azure OpenAI, Bedrock, and local models via Ollama or vLLM. Restart the containers after configuration changes:

```bash
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml up -d
```

### Step 5: Access the Web UI

Open your browser and navigate to `http://YOUR_SERVER_IP`. The default login is:

```
Email: admin@ragflow.io
Password: (set during first login)
```

![RAGFlow Web Interface](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/login.png)

## Integration with Popular Tools

### Ollama (Local LLMs)

For air-gapped or privacy-sensitive deployments, connect RAGFlow to Ollama:

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: Ollama
  api_key: ""
  base_url: http://host.docker.internal:11434
  default_model: llama3.2
```

Pull models in Ollama before using them:

```bash
ollama pull llama3.2
ollama pull nomic-embed-text
```

Configure the embedding model in the RAGFlow web UI under **Settings > Model Providers**.

### OpenAI (Cloud API)

```yaml
user_default_llm:
  factory: OpenAI
  api_key: ${OPENAI_API_KEY}
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

Use environment variable substitution to avoid hardcoding secrets:

```bash
# In .env
OPENAI_API_KEY=sk-your-key
```

### Elasticsearch to Infinity Migration

Infinity is RAGFlow's converged context engine optimized for large-scale deployments. To switch:

```bash
# 1. Stop all containers and clear volumes
docker compose -f docker-compose.yml down -v

# 2. Update .env
sed -i 's/DOC_ENGINE=elasticsearch/DOC_ENGINE=infinity/' .env

# 3. Restart
docker compose -f docker-compose.yml up -d
```

> **Warning:** This wipes existing data. Back up your datasets before migrating.

### Redis as External Cache

For production deployments, use an external Redis cluster:

```yaml
# docker-compose.yml (excerpt)
services:
  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    deploy:
      resources:
        limits:
          memory: 2G
```

### Qdrant as Alternative Vector Store

While RAGFlow uses Elasticsearch or Infinity natively, you can integrate Qdrant via the Python SDK for custom retrieval pipelines:

```python
from qdrant_client import QdrantClient
from ragflow_sdk import RAGFlow

# Connect to both systems
ragflow = RAGFlow(api_key="your-key", base_url="http://localhost:9380")
qdrant = QdrantClient(url="http://localhost:6333")

# Custom hybrid retrieval combining RAGFlow chunks with Qdrant vectors
chunks = ragflow.retrieve(dataset_id="ds_123", query="annual revenue 2025")
vectors = qdrant.search(collection="financial_reports", vector=query_embedding, limit=5)
```

## Benchmarks / Real-World Use Cases

### Retrieval Quality Benchmarks

A 2026 benchmark by AI Multiple compared RAGFlow against other frameworks using 100 standardized queries with GPT-4.1-mini as the generation model:

| Metric | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|--------|---------|------------|----------|---------------|
| Answer Accuracy | 97% | 94% | 95% | 91% |
| Avg. Retrieval Latency | 420ms | 380ms | 450ms | 510ms |
| Token Efficiency (per query) | 1,450 | 1,600 | 1,570 | 2,400 |
| Framework Overhead | 8ms | 6ms | 5.9ms | 10ms |
| Citation Grounding Score | 96% | 88% | 90% | 82% |

RAGFlow leads in accuracy and citation grounding due to DeepDoc's layout-aware parsing, which preserves table structures and image captions that other frameworks strip during text splitting.

### Document Parsing Performance

| Document Type | RAGFlow (DeepDoc) | LlamaIndex | Haystack |
|--------------|-------------------|------------|----------|
| PDF with tables | Full structure preserved | Flat text | Flat text |
| Scanned PDF (OCR) | Native support | Requires extension | Requires extension |
| PowerPoint slides | Slide-aware chunking | Per-slide | Per-slide |
| Excel spreadsheets | Cell-level extraction | CSV conversion | CSV conversion |
| Multi-language docs | Cross-language query | Monolingual | Monolingual |

### Production Deployment Profiles

| Profile | Users | Documents | Hardware | Monthly Cloud Cost |
|---------|-------|-----------|----------|-------------------|
| Team (10 users) | 10 | 10,000 | 4 vCPU, 16 GB RAM | ~$80 (DigitalOcean) |
| Department (100 users) | 100 | 100,000 | 8 vCPU, 32 GB RAM | ~$200 (DigitalOcean) |
| Enterprise (1000+ users) | 1000+ | 1M+ | 16 vCPU, 64 GB RAM + GPU | ~$800+ (cloud) |

> Looking for a reliable cloud host for RAGFlow? Deploy on [DigitalOcean](https://www.digitalocean.com/) with one-click Docker setup, or use [HTStack](https://www.htstack.com/) for managed container hosting with built-in monitoring.

## Advanced Usage / Production Hardening

### Enable HTTPS with Reverse Proxy

```nginx
# /etc/nginx/sites-available/ragflow
server {
    listen 443 ssl http2;
    server_name ragflow.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/ragflow.yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ragflow.yourcompany.com/privkey.pem;

    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
    }
}
```

### Enable GraphRAG for Multi-Hop Reasoning

GraphRAG extracts knowledge graphs from documents, enabling cross-document reasoning:

```python
# Via the RAGFlow web UI or API
POST /api/datasets/{dataset_id}/chunks/graph
{
  "method": "ligh",
  "entity_types": ["PERSON", "ORGANIZATION", "PRODUCT", "EVENT"],
  "max_workers": 4
}
```

GraphRAG is especially effective for legal documents, research papers, and financial reports where relationships between entities span multiple pages.

### Configure the Sandbox (Code Execution)

RAGFlow's agent can execute Python and JavaScript code in a sandboxed environment. This requires gVisor:

```bash
# Install gVisor (required for sandbox)
sudo apt-get install -y runsc

# Enable in docker-compose.yml
services:
  ragflow:
    environment:
      - ENABLE_SANDBOX=true
    devices:
      - /dev/kvm
```

### Monitoring with Prometheus

```yaml
# Add to docker-compose.yml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
```

Key metrics to monitor:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'ragflow'
    static_configs:
      - targets: ['ragflow-server:9380']
    metrics_path: /metrics
```

### Backup Strategy

```bash
#!/bin/bash
# /opt/ragflow/backup.sh

BACKUP_DIR="/backups/ragflow/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# Backup MySQL
docker exec ragflow-mysql mysqldump -u root -p$MYSQL_PASSWORD ragflow > $BACKUP_DIR/mysql.sql

# Backup Elasticsearch indices
docker exec ragflow-es curl -sX POST "localhost:9200/_snapshot/backup" \
  -H 'Content-Type: application/json' \
  -d'{"indices": "ragflow_*"}'

# Backup MinIO objects
docker exec ragflow-minio mc mirror /data $BACKUP_DIR/minio

# Sync to remote storage
rclone sync $BACKUP_DIR s3:my-backup-bucket/ragflow/
```

## Comparison with Alternatives

| Feature | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|---------|---------|------------|----------|---------------|
| **GitHub Stars** | 80,853 | 49,500 | 25,300 | 105,000 |
| **License** | Apache-2.0 | MIT | Apache-2.0 | MIT |
| **Deep Document Parsing** | DeepDoc (built-in) | LlamaParse (paid) | Basic | Basic |
| **Visual Workflow Builder** | Yes | No | No | No |
| **Built-in Web UI** | Yes | No | No | No |
| **Agent Framework** | Native (with memory) | External | External | LangGraph |
| **Hybrid Search** | Full-text + Vector | Vector-only | Full-text + Vector | Depends on store |
| **GraphRAG Support** | Yes | Yes | Via extension | Via extension |
| **OCR for Scanned Docs** | Native | Paid addon | Via extension | Via extension |
| **Code Execution Sandbox** | Yes (gVisor) | No | No | No |
| **Self-Hosted Deployment** | Docker Compose | Python package | Python package | Python package |
| **MCP Protocol Support** | Yes | No | No | No |
| **REST API** | Full API | Requires building | Requires building | Requires building |
| **Enterprise SSO** | Yes | Cloud only | Cloud only | Cloud only |

### When to Choose What

- **RAGFlow**: You need a complete self-hosted RAG platform with deep document understanding, a visual UI, and built-in agents. Best for enterprises handling complex documents (PDFs, scans, spreadsheets) that want full data control.
- **LlamaIndex**: You are building a custom Python application with specific indexing needs and prefer a library over a platform. Best for developers who need maximum flexibility and don't mind building their own UI.
- **Haystack**: You need a production-grade pipeline framework with strong evaluation tools and enterprise support from deepset. Best for teams that prioritize pipeline observability and testing.
- **LangChain RAG**: You want the largest ecosystem of integrations and don't mind assembling components yourself. Best for rapid prototyping and startups that need to iterate quickly.

## Limitations / Honest Assessment

**Not a lightweight tool.** RAGFlow requires a minimum of 16 GB RAM and multiple backend services (Elasticsearch, MySQL, Redis, MinIO). This is not a single-binary deployment. If you need a simple RAG setup for a side project, consider lighter alternatives like LightRAG or a direct LlamaIndex implementation.

**x86 only for official images.** ARM64 platforms (including Apple Silicon and AWS Graviton) require building your own Docker image from source. This adds significant time to deployment.

**Learning curve for advanced features.** The visual UI covers 80% of use cases, but enabling GraphRAG, configuring custom embedding pipelines, or building agents requires reading the documentation carefully.

**No native multi-region replication.** While you can back up and restore datasets, RAGFlow does not offer built-in cross-region replication for the underlying storage. You will need to configure MySQL and Elasticsearch replication separately.

**Embedding models are not included in slim images.** Starting with v0.22.0, only slim images are published. You must either download embedding models at runtime or connect to external embedding services.

## Frequently Asked Questions

### What hardware do I need for a production RAGFlow deployment?

For a production deployment serving 50+ users, use a server with at least 8 vCPU cores, 32 GB RAM, and 200 GB NVMe SSD. If you are parsing large scanned PDFs with OCR, add a GPU with at least 8 GB VRAM to accelerate DeepDoc tasks. For small teams of under 10 users, the minimum specs (4 vCPU, 16 GB RAM) are sufficient.

### Can I use RAGFlow with local LLMs only?

Yes. RAGFlow integrates with Ollama, vLLM, Xinference, and LocalAI. Configure the LLM provider in `service_conf.yaml.template` with the base URL of your local inference server. For embeddings, pull an embedding model through Ollama (such as `nomic-embed-text`) and configure it in the web UI under Model Providers.

### How does RAGFlow handle scanned PDFs and images?

RAGFlow's DeepDoc engine includes a built-in OCR pipeline that processes scanned PDFs, PNGs, and JPEGs. It uses a document layout analysis model to identify text regions, tables, and images before applying OCR. The extracted text maintains its structural context — tables are preserved as tables, not flattened into paragraphs.

### Is my data secure when using RAGFlow?

When self-hosted, all data remains on your infrastructure. Documents are stored in MinIO, vectors in Elasticsearch/Infinity, and metadata in MySQL — all within your network. RAGFlow does not send documents to external services unless you configure a cloud LLM provider. For maximum privacy, use local LLMs and embedding models.

### How do I upgrade RAGFlow to a new version?

First, back up your MySQL database and Elasticsearch indices. Then pull the new Docker image, update the `RAGFLOW_IMAGE` variable in `.env`, and restart the containers. Always check the release notes for breaking changes between versions.

```bash
cd ragflow/docker
git fetch --tags
git checkout -f v0.25.4
# Update .env with new image tag
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d
```

### Can I integrate RAGFlow into my existing application?

Yes. RAGFlow exposes a full REST API and provides Python and JavaScript SDKs. You can create datasets, upload documents, start chat sessions, and retrieve answers programmatically. The API documentation is available at `/api/docs` on your RAGFlow instance.

### What document formats does RAGFlow support?

RAGFlow supports Word (DOC, DOCX), PowerPoint (PPT, PPTX), Excel (XLS, XLSX), PDF, TXT, Markdown, images (PNG, JPG, BMP, TIFF), scanned copies, HTML, and CSV. It also supports importing data from Confluence, Notion, Google Drive, Discord, and S3.

### Does RAGFlow support multi-tenancy?

RAGFlow supports multiple users and datasets with role-based access control within a single instance. For true multi-tenancy (isolated tenants with separate data), you currently need to run separate RAGFlow instances or implement tenant filtering at the application layer.

## Conclusion

RAGFlow stands out as the only open-source RAG platform that combines deep document understanding, a production-ready web UI, and built-in agent capabilities in a single deployable system. With 80,853 GitHub stars and an active development cycle, it has proven its value for teams that need more than a basic text-splitting RAG pipeline. The Docker-based deployment takes under 30 minutes, and the hybrid search architecture delivers measurably better retrieval quality than framework-only alternatives.

**Your next steps:**

1. Clone the repository and deploy RAGFlow on your server using Docker Compose
2. Upload a complex PDF with tables and verify the parsing quality in the web UI
3. Configure your preferred LLM provider (OpenAI, DeepSeek, or Ollama)
4. Set up HTTPS and automated backups for production use
5. Join the community for support and feature updates

Join our [Telegram developer community](https://t.me/dibi8opensource) for deployment tips and production RAG discussions. Share your RAGFlow setup — we feature the best configurations in our weekly newsletter.

*Some links in this article are affiliate links. We may earn a commission if you purchase hosting services through these links. This does not affect our editorial recommendations.*



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [RAGFlow GitHub Repository](https://github.com/infiniflow/ragflow)
- [RAGFlow Official Documentation](https://ragflow.io/docs/dev/)
- [RAGFlow Quickstart Guide](https://ragflow.io/docs/dev/)
- [RAGFlow Docker Deployment README](https://github.com/infiniflow/ragflow/blob/main/docker/README.md)
- [DeepDoc Document Understanding](https://github.com/infiniflow/ragflow/tree/main/deepdoc)
- [RAGFlow REST API Reference](https://ragflow.io/docs/dev/category/references)
- [RAGFlow vs Other RAG Frameworks Benchmark](https://aimultiple.com/rag-frameworks)
- [LlamaIndex GitHub Repository](https://github.com/run-llama/llama_index)
- [Haystack GitHub Repository](https://github.com/deepset-ai/haystack)
- [Best Open Source RAG Frameworks 2026 Comparison](https://www.firecrawl.dev/blog/best-open-source-rag-frameworks)
- [RAGFlow Architecture Explained](https://milvus.io/ai-quick-reference/what-is-ragflow-and-how-does-it-work)
- [RAGFlow Production Deployment on VPS](https://zhujibaike.com/2497.html)
