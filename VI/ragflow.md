---
title: 'RAGFlow: Triển khai RAG Engine sản xuất với 80K+ Stars — Hướng dẫn Docker và Benchmark 2026'
description: 'RAGFlow là engine RAG mã nguồn mở với khả năng hiểu sâu tài liệu và tích hợp Agent. Tương thích với Ollama, OpenAI, Qdrant, Elasticsearch, Redis. Bao gồm triển khai Docker, nhập tài liệu, tối ưu tìm kiếm và bảo mật production.'
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
tags: ['ragflow', 'rag-engine', 'hieu-tai-lieu', 'docker-trien-khai', 'llm-agent', 'rag-production', 'ai-ma-nguon-mo']
aliases:
- /vi/posts/ragflow/
---

{{</* resource-info */>}}

![RAGFlow Logo](https://raw.githubusercontent.com/infiniflow/ragflow/main/web/public/logo.svg)

## Giới thiệu

Hầu hết pipeline RAG thất bại trong môi trường production vì chúng xử lý PDF và PowerPoint như văn bản thuần túy. Bảng biểu bị hỏng, chú thích hình ảnh biến mất, tài liệu quét trở nên không đọc được. Kết quả là hệ thống retrieval trả về ngữ cảnh rác cho LLM — và câu trả lởi ảo giác theo sau. RAGFlow, một engine RAG mã nguồn mở với hơn 80.000 sao GitHub, được xây dựng để giải quyết chính xác vấn đề này. Engine DeepDoc của nó hiểu được bố cục tài liệu, và framework agent tích hợp cho phép bạn xây dựng các worker tri thức tự chủ, không chỉ là chatbot. Trong hướng dẫn này, bạn sẽ triển khai RAGFlow trên máy chủ production, cấu hình nhập tài liệu, tối ưu chất lượng retrieval và tích hợp với stack LLM hiện có.

## RAGFlow là gì?

RAGFlow là một engine Retrieval-Augmented Generation mã nguồn mở kết hợp khả năng hiểu sâu tài liệu với các agent dựa trên LLM để cung cấp câu trả lờ chính xác, có trích dẫn từ các tài liệu doanh nghiệp phức tạp. Khác với các thư viện RAG thông thường chỉ dựa vào việc chia văn bản đơn giản, RAGFlow phân tích cấu trúc tài liệu — bảng biểu, hình ảnh, tiêu đề và trang quét — để bảo toàn ý nghĩa ngữ nghĩa trong quá trình nhập liệu. Nó được cung cấp dưới dạng nền tảng dựa trên Docker với giao diện web, REST API và trình xây dựng agent, phù hợp cho cả lập trình viên xây dựng pipeline và ngườ dùng không kỹ thuật quản lý cơ sở tri thức.

## RAGFlow hoạt động như thế nào

![RAGFlow System Architecture](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/ragflow-architecture.png)

Kiến trúc của RAGFlow tuân theo thiết kế pipeline module với sáu giai đoạn cốt lõi:

### 1. Nhập tài liệu (DeepDoc)

Tài liệu đi vào RAGFlow thông qua engine phân tích **DeepDoc**. DeepDoc thực hiện phân tích bố cục trên các tệp PDF, Word, Excel, PowerPoint, hình ảnh và bản sao quét. Nó sử dụng mô hình bố cục tài liệu dựa trên thị giác để nhận diện bảng biểu, hình ảnh, tiêu đề, đoạn văn và khối văn bản. Giai đoạn này cũng hỗ trợ các trình phân tích bên ngo như MinerU và Docling cho các định dạng chuyên biệt.

### 2. Trích xuất tri thức và phân đoạn (Chunking)

Sau khi phân tích, RAGFlow áp dụng các chiến lược phân đoạn dựa trên template. Bạn có thể chọn từ nhiều chế độ phân đoạn — đơn giản, thủ công, Q&A, bảng biểu, bài báo, sách, luật, thuyết trình, hình ảnh và chế độ duy nhất — tùy thuộc vào loại tài liệu. Mỗi đoạn bảo toàn ngữ cảnh cấu trúc của nó, và RAGFlow tùy chọn trích xuất từ khóa và tạo câu hỏi liên quan để cải thiện độ phủ retrieval.

### 3. Lập chỉ mục (Backend tìm kiếm lai)

Các đoạn được lập chỉ mục vào **Elasticsearch** (mặc định) hoặc **Infinity** cho tìm kiếm lai. Hỗ trợ cả tìm kiếm toàn văn và tìm kiếm vector dày đặc. Hệ thống tính toán embedding sử dụng các mô hình embedding có thể cấu hình và lưu trữ vector cùng với chỉ mục ngược cho retrieval từ khóa.

### 4. Retrieval và xếp hạng lại

Khi truy vấn đến, RAGFlow thực hiện retrieval đa kênh: tìm kiếm từ khóa, tìm kiếm tương đồng vector và duyệt đồ thị tri thức (nếu GraphRAG được bật). Kết quả được hợp nhất và xếp hạng lại bằng cross-encoder re-ranker trước khi chuyển đến cửa sổ ngữ cảnh LLM.

### 5. Sinh câu trả lờ với trích dẫn

RAGFlow xây dựng prompt bao gồm các đoạn đã truy xuất với trích dẫn có thể theo dõi. LLM tạo câu trả lờ dựa trên ngữ cảnh đã truy xuất, và RAGFlow hiển thị các đoạn nguồn bên cạnh câu trả lờ để ngườ dùng có thể xác minh mỗi tuyên bố.

### 6. Thực thi Agent (Tùy chọn)

Vượt ra ngoài hỏi đáp đơn giản, framework agent của RAGFlow hỗ trợ workflow đa bước với bộ nhớ, gọi công cụ, tích hợp MCP (Model Context Protocol) và thực thi mã trong môi trường sandbox. Agent có thể duyệt web, truy vấn cơ sở dữ liệu và chuỗi nhiều thao tác retrieval.

### Stack hạ tầng

| Dịch vụ | Mục đích | Backend mặc định |
|---------|----------|-----------------|
| Lưu trữ Vector + Toàn văn | Lập chỉ mục và tìm kiếm tài liệu | Elasticsearch hoặc Infinity |
| Lưu trữ đối tượng | Lưu trữ tệp tài liệu đã tải lên | MinIO |
| CSDL metadata | Dữ liệu ngườ dùng, cấu hình dataset, lịch sử chat | MySQL |
| Cache & Hàng đợi | Hàng đợi tác vụ và cache phiên | Redis |
| Trình phân tích tài liệu | Phân tích bố cục và OCR | DeepDoc (tích hợp) |
| Frontend | Giao diện web quản lý dataset | React + TypeScript |
| Backend API | Logic điều phối cốt lõi | Python + Go |

## Cài đặt và thiết lập

### Yêu cầu phần cứng

| Tài nguyên | Tối thiểu | Khuyến nghị cho Production |
|-----------|-----------|---------------------------|
| CPU | 4 nhân (x86_64) | 8+ nhân |
| RAM | 16 GB | 32+ GB |
| Đĩa | 50 GB SSD | 200+ GB NVMe |
| Docker | 24.0.0+ | Phiên bản ổn định mới nhất |
| Docker Compose | v2.26.1+ | Phiên bản ổn định mới nhất |

> **Lưu ý:** RAGFlow chính thức hỗ trợ nền tảng x86_64. ARM64 được cộng đồng kiểm thử nhưng yêu cầu tự xây dựng Docker image.

### Trước triển khai: Tối ưu hệ thống

Trước khi khởi động RAGFlow, đảm bảo tham số kernel được tối ưu cho Elasticsearch:

```bash
# Kiểm tra giá trị vm.max_map_count hiện tại
sysctl vm.max_map_count

# Đặt ít nhất là 262144 (yêu cầu của Elasticsearch)
sudo sysctl -w vm.max_map_count=262144

# Duy trì sau khởi động lại
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

### Bước 1: Clone kho mã nguồn

```bash
git clone https://github.com/infiniflow/ragflow.git
cd ragflow/docker
git checkout -f v0.25.4
```

### Bước 2: Cấu hình biến môi trường

```bash
# Chỉnh sửa tệp môi trường
cp .env .env.backup
nano .env
```

Các biến quan trọng cần thiết lập:

```bash
# docker/.env
RAGFLOW_IMAGE=infiniflow/ragflow:v0.25.4
SVR_HTTP_PORT=80
MYSQL_PASSWORD=your_secure_mysql_password
MINIO_PASSWORD=your_secure_minio_password
REDIS_PASSWORD=your_secure_redis_password

# Chọn engine tài liệu: elasticsearch hoặc infinity
DOC_ENGINE=elasticsearch
```

### Bước 3: Khởi động với Docker Compose

```bash
# Triển khai CPU-only
docker compose -f docker-compose.yml up -d

# GPU tăng tốc phân tích tài liệu (NVIDIA)
# sed -i '1i DEVICE=gpu' .env
# docker compose -f docker-compose.yml up -d
```

Xác minh triển khai:

```bash
# Theo dõi log cho đến khi thấy thông báo thành công
docker logs -f ragflow-server

# Output mong đợi:
#     ____   ___    ______ ______ __
#    / __ \ /   |  / ____// ____// /____  _      __
#   / /_/ // /| | / / __ / /_   / // __ \| | /| / /
#  / _, _// ___ |/ /_/ // __/  / // /_/ /| |/ |/ /
# /_/ |_|/_/  |_|\____//_/    /_/ \____/ |__/|__/
#  * Running on all addresses (0.0.0.0)
```

### Bước 4: Cấu hình nhà cung cấp LLM

Chỉnh sửa `service_conf.yaml.template` để thêm API key LLM:

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: OpenAI
  api_key: sk-your-openai-api-key
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

Các nhà cung cấp LLM được hỗ trợ bao gồm OpenAI, Anthropic, DeepSeek, Gemini, Azure OpenAI, Bedrock, và các mô hình local qua Ollama hoặc vLLM. Khởi động lại container sau khi thay đổi cấu hình:

```bash
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml up -d
```

### Bước 5: Truy cập giao diện Web

Mở trình duyệt và điều hướng đến `http://YOUR_SERVER_IP`. Thông tin đăng nhập mặc định:

```
Email: admin@ragflow.io
Mật khẩu: (thiết lập lần đầu đăng nhập)
```

![RAGFlow Web Interface](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/login.png)

## Tích hợp với các công cụ phổ biến

### Ollama (LLM cục bộ)

Đối với triển khai air-gapped hoặc nhạy cảm về quyền riêng tư, kết nối RAGFlow với Ollama:

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: Ollama
  api_key: ""
  base_url: http://host.docker.internal:11434
  default_model: llama3.2
```

Pull model trong Ollama trước khi sử dụng:

```bash
ollama pull llama3.2
ollama pull nomic-embed-text
```

Cấu hình mô hình embedding trong giao diện web RAGFlow tại **Cài đặt > Nhà cung cấp mô hình**.

### OpenAI (API đám mây)

```yaml
user_default_llm:
  factory: OpenAI
  api_key: ${OPENAI_API_KEY}
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

Sử dụng thay thế biến môi trường để tránh hardcode bí mật:

```bash
# Trong .env
OPENAI_API_KEY=sk-your-key
```

### Chuyển từ Elasticsearch sang Infinity

Infinity là engine ngữ cảnh hội tụ của RAGFlow, được tối ưu cho triển khai quy mô lớn. Để chuyển đổi:

```bash
# 1. Dừng tất cả container và xóa volume
docker compose -f docker-compose.yml down -v

# 2. Cập nhật .env
sed -i 's/DOC_ENGINE=elasticsearch/DOC_ENGINE=infinity/' .env

# 3. Khởi động lại
docker compose -f docker-compose.yml up -d
```

> **Cảnh báo:** Thao tác này sẽ xóa dữ liệu hiện có. Sao lưu dataset trước khi di chuyển.

### Redis làm cache bên ngoài

Đối với triển khai production, sử dụng Redis cluster bên ngoài:

```yaml
# docker-compose.yml (trích)
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

### Qdrant làm kho lưu trữ vector thay thế

Mặc dù RAGFlow sử dụng Elasticsearch hoặc Infinity một cách tự nhiên, bạn có thể tích hợp Qdrant qua Python SDK cho các pipeline retrieval tùy chỉnh:

```python
from qdrant_client import QdrantClient
from ragflow_sdk import RAGFlow

# Kết nối với cả hai hệ thống
ragflow = RAGFlow(api_key="your-key", base_url="http://localhost:9380")
qdrant = QdrantClient(url="http://localhost:6333")

# Hybrid retrieval tùy chỉnh kết hợp chunk RAGFlow với vector Qdrant
chunks = ragflow.retrieve(dataset_id="ds_123", query="doanh thu hàng năm 2025")
vectors = qdrant.search(collection="financial_reports", vector=query_embedding, limit=5)
```

## Benchmark / Trường hợp sử dụng thực tế

### Benchmark chất lượng Retrieval

Một bài benchmark năm 2026 của AI Multiple đã so sánh RAGFlow với các framework khác sử dụng 100 truy vấn chuẩn hóa với GPT-4.1-mini làm mô hình sinh:

| Chỉ số | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|--------|---------|------------|----------|---------------|
| Độ chính xác câu trả lờ | 97% | 94% | 95% | 91% |
| Độ trễ retrieval trung bình | 420ms | 380ms | 450ms | 510ms |
| Hiệu quả token (mỗi truy vấn) | 1.450 | 1.600 | 1.570 | 2.400 |
| Overhead framework | 8ms | 6ms | 5,9ms | 10ms |
| Điểm căn cứ trích dẫn | 96% | 88% | 90% | 82% |

RAGFlow dẫn đầu về độ chính xác và căn cứ trích dẫn nhờ phân tích DeepDoc nhận biết bố cục, bảo toàn cấu trúc bảng và chú thích hình ảnh mà các framework khác loại bỏ trong quá trình chia văn bản.

### Hiệu suất phân tích tài liệu

| Loại tài liệu | RAGFlow (DeepDoc) | LlamaIndex | Haystack |
|--------------|-------------------|------------|----------|
| PDF có bảng | Bảo toàn cấu trúc đầy đủ | Văn bản phẳng | Văn bản phẳng |
| PDF quét (OCR) | Hỗ trợ tích hợp | Yêu cầu mở rộng | Yêu cầu mở rộng |
| Slide PowerPoint | Chunking nhận biết slide | Theo từng slide | Theo từng slide |
| Bảng tính Excel | Trích xuất mức ô | Chuyển đổi CSV | Chuyển đổi CSV |
| Tài liệu đa ngôn ngữ | Truy vấn xuyên ngôn ngữ | Đơn ngữ | Đơn ngữ |

### Cấu hình triển khai Production

| Cấu hình | Ngườ dùng | Tài liệu | Phần cứng | Chi phí đám mây hàng tháng |
|----------|-----------|----------|-----------|---------------------------|
| Nhóm (10 ngườ) | 10 | 10.000 | 4 vCPU, 16 GB RAM | ~$80 (DigitalOcean) |
| Phòng ban (100 ngườ) | 100 | 100.000 | 8 vCPU, 32 GB RAM | ~$200 (DigitalOcean) |
| Doanh nghiệp (1000+ ngườ) | 1000+ | 1 triệu+ | 16 vCPU, 64 GB RAM + GPU | ~$800+ (đám mây) |

> Tìm kiếm máy chủ đám mây đáng tin cậy cho RAGFlow? Triển khai trên [DigitalOcean](https://www.digitalocean.com/) với thiết lập Docker một cú nhấp chuột, hoặc sử dụng [HTStack](https://www.htstack.com/) cho dịch vụ hosting container được quản lý với giám sát tích hợp.

## Sử dụng nâng cao / Củng cố Production

### Bật HTTPS với Reverse Proxy

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

### Bật GraphRAG cho suy luận đa bước

GraphRAG trích xuất đồ thị tri thức từ tài liệu, cho phép suy luận xuyên tài liệu:

```python
# Qua giao diện web RAGFlow hoặc API
POST /api/datasets/{dataset_id}/chunks/graph
{
  "method": "ligh",
  "entity_types": ["NGUOI", "TO_CHUC", "SAN_PHAM", "SU_KIEN"],
  "max_workers": 4
}
```

GraphRAG đặc biệt hiệu quả cho tài liệu pháp lý, bài báo nghiên cứu và báo cáo tài chính nơi mối quan hệ giữa các thực thể trải dài nhiều trang.

### Cấu hình Sandbox (Thực thi mã)

Agent của RAGFlow có thể thực thi mã Python và JavaScript trong môi trường sandbox. Điều này yêu cầu gVisor:

```bash
# Cài đặt gVisor (bắt buộc cho sandbox)
sudo apt-get install -y runsc

# Bật trong docker-compose.yml
services:
  ragflow:
    environment:
      - ENABLE_SANDBOX=true
    devices:
      - /dev/kvm
```

### Giám sát với Prometheus

```yaml
# Thêm vào docker-compose.yml
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

Các chỉ số chính cần giám sát:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'ragflow'
    static_configs:
      - targets: ['ragflow-server:9380']
    metrics_path: /metrics
```

### Chiến lược sao lưu

```bash
#!/bin/bash
# /opt/ragflow/backup.sh

BACKUP_DIR="/backups/ragflow/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# Sao lưu MySQL
docker exec ragflow-mysql mysqldump -u root -p$MYSQL_PASSWORD ragflow > $BACKUP_DIR/mysql.sql

# Sao lưu chỉ mục Elasticsearch
docker exec ragflow-es curl -sX POST "localhost:9200/_snapshot/backup" \
  -H 'Content-Type: application/json' \
  -d'{"indices": "ragflow_*"}'

# Sao lưu đối tượng MinIO
docker exec ragflow-minio mc mirror /data $BACKUP_DIR/minio

# Đồng bộ lên lưu trữ từ xa
rclone sync $BACKUP_DIR s3:my-backup-bucket/ragflow/
```

## So sánh với các lựa chọn thay thế

| Tính năng | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|-----------|---------|------------|----------|---------------|
| **GitHub Stars** | 80.853 | 49.500 | 25.300 | 105.000 |
| **Giấy phép** | Apache-2.0 | MIT | Apache-2.0 | MIT |
| **Phân tích tài liệu sâu** | DeepDoc (tích hợp) | LlamaParse (trả phí) | Cơ bản | Cơ bản |
| **Trình xây dựng workflow trực quan** | Có | Không | Không | Không |
| **Giao diện Web tích hợp** | Có | Không | Không | Không |
| **Framework Agent** | Tích hợp (có bộ nhớ) | Bên ngoài | Bên ngoài | LangGraph |
| **Tìm kiếm lai** | Toàn văn + Vector | Chỉ Vector | Toàn văn + Vector | Phụ thuộc kho |
| **Hỗ trợ GraphRAG** | Có | Có | Qua mở rộng | Qua mở rộng |
| **OCR cho tài liệu quét** | Tích hợp | Addon trả phí | Qua mở rộng | Qua mở rộng |
| **Sandbox thực thi mã** | Có (gVisor) | Không | Không | Không |
| **Triển khai tự lưu trữ** | Docker Compose | Gói Python | Gói Python | Gói Python |
| **Hỗ trợ giao thức MCP** | Có | Không | Không | Không |
| **REST API** | API đầy đủ | Yêu cầu xây dựng | Yêu cầu xây dựng | Yêu cầu xây dựng |
| **SSO Doanh nghiệp** | Có | Chỉ đám mây | Chỉ đám mây | Chỉ đám mây |

### Khi nào chọn cái nào

- **RAGFlow**: Bạn cần nền tảng RAG tự lưu trữ hoàn chỉnh với khả năng hiểu tài liệu sâu, giao diện UI trực quan và agent tích hợp. Tốt nhất cho doanh nghiệp xử lý tài liệu phức tạp (PDF, scan, bảng tính) muốn kiểm soát hoàn toàn dữ liệu.
- **LlamaIndex**: Bạn đang xây dựng ứng dụng Python tùy chỉnh với nhu cầu lập chỉ mục cụ thể và thích thư viện hơn nền tảng. Tốt nhất cho lập trình viên cần linh hoạt tối đa và không ngại tự xây giao diện.
- **Haystack**: Bạn cần framework pipeline chất lượng production với công cụ đánh giá mạnh và hỗ trợ doanh nghiệp từ deepset. Tốt nhất cho đội ưu tiên khả năng quan sát pipeline và kiểm thử.
- **LangChain RAG**: Bạn muốn hệ sinh thái tích hợp lớn nhất và không ngại tự lắp ráp các thành phần. Tốt nhất cho prototype nhanh và startup cần lặp lại nhanh chóng.

## Hạn chế / Đánh giá trung thực

**Không phải công cụ nhẹ.** RAGFlow yêu cầu tối thiểu 16 GB RAM và nhiều dịch vụ backend (Elasticsearch, MySQL, Redis, MinIO). Đây không phải triển khai binary đơn lẻ. Nếu bạn cần cấu hình RAG đơn giản cho dự án phụ, hãy xem xét các lựa chọn nhẹ hơn như LightRAG hoặc triển khai LlamaIndex trực tiếp.

**Chỉ hỗ trợ x86 cho image chính thức.** Nền tảng ARM64 (bao gồm Apple Silicon và AWS Graviton) yêu cầu tự xây dựng Docker image từ mã nguồn. Điều này làm tăng đáng kể thờ gian triển khai.

**Đường cong học tập cho tính năng nâng cao.** Giao diện UI trực quan bao phủ 80% trường hợp sử dụng, nhưng bật GraphRAG, cấu hình pipeline embedding tùy chỉnh hoặc xây dựng agent đòi hỏi đọc tài liệu cẩn thận.

**Không có replication đa vùng tích hợp.** Mặc dù có thể sao lưu và phục hồi dataset, RAGFlow không cung cấp replication xuyên vùng tích hợp cho lưu trữ backend. Bạn cần cấu hình replication MySQL và Elasticsearch riêng biệt.

**Image slim không bao gồm embedding model.** Từ v0.22.0, chỉ image slim được phát hành. Bạn phải tải xuống embedding model tại runtime hoặc kết nối với dịch vụ embedding bên ngoài.

## Câu hỏi thường gặp

### Triển khai RAGFlow production cần phần cứng gì?

Đối với triển khai production phục vụ 50+ ngườ dùng, sử dụng máy chủ có ít nhất 8 nhân vCPU, 32 GB RAM và 200 GB NVMe SSD. Nếu phân tích PDF quét lớn với OCR, hãy thêm GPU có ít nhất 8 GB VRAM để tăng tốc DeepDoc. Đội nhóm nhỏ dưới 10 ngườ, cấu hình tối thiểu (4 vCPU, 16 GB RAM) là đủ.

### RAGFlow có thể chỉ dùng LLM cục bộ không?

Có. RAGFlow tích hợp với Ollama, vLLM, Xinference và LocalAI. Cấu hình nhà cung cấp LLM trong `service_conf.yaml.template` với base URL của máy chủ inference cục bộ. Cho embedding, pull model embedding qua Ollama (như `nomic-embed-text`) và cấu hình trong giao diện web tại Nhà cung cấp mô hình.

### RAGFlow xử lý PDF quét và hình ảnh như thế nào?

Engine DeepDoc của RAGFlow bao gồm pipeline OCR tích hợp xử lý PDF quét, PNG và JPEG. Nó sử dụng mô hình phân tích bố cục tài liệu để nhận diện vùng văn bản, bảng biểu và hình ảnh trước khi áp dụng OCR. Văn bản trích xuất duy trì ngữ cảnh cấu trúc — bảng được giữ nguyên dạng bảng, không bị phẳng thành đoạn văn.

### Dữ liệu của tôi có an toàn khi dùng RAGFlow không?

Khi tự lưu trữ, tất cả dữ liệu ở lại trên cơ sở hạ tầng của bạn. Tài liệu lưu trong MinIO, vector trong Elasticsearch/Infinity, metadata trong MySQL — tất cả trong mạng của bạn. RAGFlow không gửi tài liệu đến dịch vụ bên ngoài trừ khi bạn cấu hình nhà cung cấp LLM đám mây. Cho quyền riêng tư tối đa, hãy dùng LLM và embedding model cục bộ.

### Nâng cấp RAGFlow lên phiên bản mới như thế nào?

Đầu tiên, sao lưu CSDL MySQL và chỉ mục Elasticsearch. Sau đó pull image Docker mới, cập nhật biến `RAGFLOW_IMAGE` trong `.env`, và khởi động lại container. Luôn kiểm tra release notes cho các thay đổi phá vỡ giữa các phiên bản.

```bash
cd ragflow/docker
git fetch --tags
git checkout -f v0.25.4
# Cập nhật tag image mới trong .env
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d
```

### Có thể tích hợp RAGFlow vào ứng dụng hiện có không?

Có. RAGFlow expose REST API đầy đủ và cung cấp SDK Python và JavaScript. Bạn có thể tạo dataset, tải lên tài liệu, bắt đầu phiên chat và truy xuất câu trả lờ lập trình. Tài liệu API có tại `/api/docs` trên instance RAGFlow của bạn.

### RAGFlow hỗ trợ những định dạng tài liệu nào?

RAGFlow hỗ trợ Word (DOC, DOCX), PowerPoint (PPT, PPTX), Excel (XLS, XLSX), PDF, TXT, Markdown, hình ảnh (PNG, JPG, BMP, TIFF), bản sao quét, HTML và CSV. Nó cũng hỗ trợ nhập dữ liệu từ Confluence, Notion, Google Drive, Discord và S3.

### RAGFlow có hỗ trợ multi-tenancy không?

RAGFlow hỗ trợ nhiều ngườ dùng và dataset với kiểm soát truy cập dựa trên vai trò trong một instance. Cho multi-tenancy thực sự (tenant cô lập với dữ liệu riêng biệt), bạn hiện cần chạy các instance RAGFlow riêng biệt hoặc triển khai lọc tenant tại lớp ứng dụng.

## Kết luận

RAGFlow nổi bật như nền tảng RAG mã nguồn mở duy nhất kết hợp khả năng hiểu tài liệu sâu, giao diện web sẵn sàng production và khả năng agent tích hợp trong một hệ thống có thể triển khai. Với 80.853 sao GitHub và chu kỳ phát triển tích cực, nó đã chứng minh giá trị cho các đội cần nhiều hơn một pipeline RAG chia văn bản cơ bản. Triển khai dựa trên Docker hoàn tất trong vòng 30 phút, và kiến trúc tìm kiếm lai mang lại chất lượng retrieval đo đạc được tốt hơn rõ rệt so với các lựa chọn chỉ là framework.

**Các bước tiếp theo của bạn:**

1. Clone kho mã nguồn và triển khai RAGFlow trên máy chủ bằng Docker Compose
2. Tải lên PDF phức tạp có bảng biểu và xác minh chất lượng phân tích trong giao diện web
3. Cấu hình nhà cung cấp LLM ưa thích (OpenAI, DeepSeek hoặc Ollama)
4. Thiết lập HTTPS và sao lưu tự động cho production
5. Tham gia cộng đồng để nhận hỗ trợ và cập nhật tính năng

Tham gia [cộng đồng lập trình viên Telegram](https://t.me/dibi8opensource) của chúng tôi để chia sẻ mẹo triển khai và thảo luận về RAG production. Chia sẻ cấu hình RAGFlow của bạn — chúng tôi giớ thiệu các cấu hình tốt nhất trong bản tin hàng tuần.

*Một số liên kết trong bài viết này là liên kết tiếp thị liên kết. Chúng tôi có thể nhận hoa hồng nếu bạn mua dịch vụ lưu trữ qua các liên kết này. Điều này không ảnh hưởng đến các khuyến nghị biên tập của chúng tôi.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn và tài liệu tham khảo

- [Kho GitHub RAGFlow](https://github.com/infiniflow/ragflow)
- [Tài liệu chính thức RAGFlow](https://ragflow.io/docs/dev/)
- [Hướng dẫn bắt đầu nhanh RAGFlow](https://ragflow.io/docs/dev/)
- [README Triển khai Docker RAGFlow](https://github.com/infiniflow/ragflow/blob/main/docker/README.md)
- [Hiểu tài liệu DeepDoc](https://github.com/infiniflow/ragflow/tree/main/deepdoc)
- [Tài liệu tham khảo REST API RAGFlow](https://ragflow.io/docs/dev/category/references)
- [Benchmark RAGFlow vs các framework RAG khác](https://aimultiple.com/rag-frameworks)
- [Kho GitHub LlamaIndex](https://github.com/run-llama/llama_index)
- [Kho GitHub Haystack](https://github.com/deepset-ai/haystack)
- [So sánh các framework RAG mã nguồn mở tốt nhất 2026](https://www.firecrawl.dev/blog/best-open-source-rag-frameworks)
- [Giải thích kiến trúc RAGFlow](https://milvus.io/ai-quick-reference/what-is-ragflow-and-how-does-it-work)
- [Triển khai Production RAGFlow trên VPS](https://zhujibaike.com/2497.html)
