---
title: 'LiteLLM: 22,500 Stars — Triển khai Một API cho 100+ LLM, Tích hợp Failover — Cấu hình Gateway Production 2026'
description: 'LiteLLM (litellm) là cổng AI mã nguồn mở cung cấp API thống nhất cho 100+ LLM. Tương thích với OpenAI, Anthropic, Ollama, Cohere, Gemini, Bedrock. Bao gồm triển khai Docker, khóa ảo, cân bằng tải, bộ nhớ đệm và cứng hóa production.'
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
github_repo: 'https://github.com/BerriAI/litellm'
stars: 22500
maintainer: 'BerriAI'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['litellm', 'llm-gateway', 'mã-nguồn-mở', 'docker', 'production', 'hạ-tầng-ai', 'proxy-server', 'đa-mô-hình']
aliases:
- /vi/posts/litellm/
- /vi/resources/llm-frameworks/litellm-unified-api-tutorial/
---

{{</* resource-info */>}}

![LiteLLM Logo](https://raw.githubusercontent.com/BerriAI/litellm/main/docs/my-assets/logo.png)

## Giới thiệu

Bạn đang chạy Claude để suy luận, GPT-4o để lập trình, và Gemini Flash để phân loại chi phí thấp. Mỗi nhà cung cấp có SDK riêng, logic thử lại riêng, header giới hạn tốc độ riêng, và bảng điều khiển thanh toán riêng. Khi API Anthropic gặp sự cố lúc 2 giờ sáng, ai đó phải thức dậy. Khi hóa đơn OpenAI tăng 40% so với tuần trước, không ai biết đội nào gây ra.

Đây là thuế vận hành đa LLM — và nó tăng theo cấp số nhân mỗi khi thêm mô hình mới. LiteLLM loại bỏ thuế đó. Đây là một cổng AI mã nguồn mở, hiển thị một endpoint API tương thích OpenAI duy nhất, chuyển tiếp yêu cầu đến 100+ nhà cung cấp LLM với tính năng tự động chuyển đổi dự phòng, cân bằng tải, khóa ảo, và theo dõi chi phí tích hợp sẵn.

Với **22,500+ sao GitHub** và **1,500+ ngườI đóng góp**, LiteLLM đã trở thành lựa chọn mặc định cho các đội muốn kiểm soát ở cấp gateway mà không bị khóa vào nhà cung cấp. Hướng dẫn này đi qua thiết lập cấp production — từ triển khai Docker đến quản lý khóa ảo và giám sát — trong vòng 30 phút.

---

## LiteLLM là gì?

LiteLLM là một cổng proxy LLM và Python SDK mã nguồn mở, cung cấp giao diện thống nhất để gọi 100+ API LLM — OpenAI, Anthropic, Azure, Google Vertex AI, AWS Bedrock, Cohere, Ollama, v.v. — sử dụng định dạng API tương thích OpenAI duy nhất.

Hai chế độ tồn tại:

- **Python SDK** — `import litellm; completion(...)` trong code, không phụ thuộc nhà cung cấp
- **Proxy Server** — gateway HTTP tự lưu trữ tại `:4000`, bất kỳ client OpenAI SDK nào cũng có thể trỏ đến

Chế độ proxy là những gì hầu hết các đội production sử dụng. Nó thêm khóa ảo, quản lý đội, kiểm soát ngân sách, giới hạn tốc độ, bộ nhớ đệm, và khả năng quan sát — tất cả được cấu hình qua một tệp `config.yaml`.

---

## LiteLLM hoạt động như thế nào

![Sơ đồ kiến trúc LiteLLM](images/litellm-architecture.png)

**Luồng yêu cầu:**

1. Ứng dụng gửi yêu cầu định dạng OpenAI đến `http://litellm-proxy:4000/v1/chat/completions`
2. LiteLLM xác thực khóa ảo, kiểm tra ngân sách và giới hạn tốc độ của đội
3. Bộ định tuyến chọn triển khai mô hình tốt nhất dựa trên chiến lược đã cấu hình (dựa trên độ trễ, dựa trên chi phí, hoặc cân bằng tải đơn giản)
4. Nếu nhà cung cấp chính trả về 429/5xx, tự động chuyển đổi dự phòng kích hoạt trong vài mili giây
5. Phản hồi truyền về ở định dạng OpenAI, bất kể nhà cung cấp nào xử lý
6. Chi phí, độ trễ, và số token được ghi vào PostgreSQL; chỉ số Prometheus được phát ra

**Các thành phần cốt lõi:**

| Thành phần | Mục đích | Phụ thuộc bên ngoài |
|------------|----------|-------------------|
| Proxy Server | HTTP API, định tuyến, xác thực | Không (Python/FastAPI) |
| PostgreSQL | Khóa ảo, log chi phí, dữ liệu đội | Bắt buộc cho production |
| Redis | Điều phối giới hạn tốc độ, bộ nhớ đệm | Khuyến nghị |
| Admin UI | Dashboard web cho khóa/mô hình | Tích hợp sẵn |

---

## Cài đặt & Thiết lập

### Điều kiện tiên quyết

- Docker 24+ và Docker Compose v2
- PostgreSQL 14+ (container cục bộ hoặc dịch vụ quản lý như [DigitalOcean Managed Postgres](https://www.digitalocean.com/products/managed-databases-postgresql))
- Tối thiểu 2 vCPU / 4 GB RAM cho container proxy

### Bước 1: Tải Mẫu Docker Compose

```bash
# Tạo thư mục dự án
mkdir -p litellm-gateway && cd litellm-gateway

# Tải docker-compose.yml chính thức
curl -O https://raw.githubusercontent.com/BerriAI/litellm/main/docker-compose.yml

# Tạo tệp môi trường
cat > .env << 'EOF'
LITELLM_MASTER_KEY="sk-litellm-admin-$(openssl rand -hex 16)"
LITELLM_SALT_KEY="sk-salt-$(openssl rand -hex 32)"
OPENAI_API_KEY="sk-your-openai-key"
ANTHROPIC_API_KEY="sk-your-anthropic-key"
DATABASE_URL="postgresql://llmproxy:dbpassword9090@db:5432/litellm"
EOF
```

### Bước 2: Tạo config.yaml

```yaml
# litellm_config.yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
      rpm: 500
      tpm: 150000

  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY
      rpm: 200
      tpm: 40000

  - model_name: gemini-flash
    litellm_params:
      model: gemini/gemini-2.0-flash
      api_key: os.environ/GEMINI_API_KEY
      rpm: 1000

  - model_name: ollama-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://ollama:11434
    model_info:
      mode: chat

  # Mô hình nhúng
  - model_name: text-embedding
    litellm_params:
      model: openai/text-embedding-3-small
      api_key: os.environ/OPENAI_API_KEY

general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL
  max_budget: 10000.00
  budget_duration: 30d
  alerting:
    - slack
  alerting_threshold: 300
  global_max_parallel_requests: 200

litellm_settings:
  drop_params: true
  num_retries: 3
  request_timeout: 120

  # Tự động chuyển đổi dự phòng
  fallbacks:
    - gpt-4o:
      - claude-sonnet
      - gemini-flash
    - claude-sonnet:
      - gpt-4o
      - gemini-flash

  # Bộ nhớ đệm Redis
  cache: true
  cache_params:
    type: redis
    host: redis
    port: 6379
    ttl: 3600

  # Callback khả năng quan sát
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

### Bước 3: Khởi động Stack

```bash
# Kéo và khởi động tất cả dịch vụ
docker compose up -d

# Xác minh trạng thái dịch vụ
docker compose ps

# Kiểm tra log proxy
docker compose logs -f litellm
```

Proxy hiện đang chạy tại `http://localhost:4000`. Admin UI tại `http://localhost:4000/ui/` — đăng nhập với tên ngườI dùng `admin` và `LITELLM_MASTER_KEY` làm mật khẩu.

### Bước 4: Kiểm tra với Yêu cầu

```bash
# Kiểm tra chat completions
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "LiteLLM là gì?"}]
  }'

# Kiểm tra embeddings
curl http://localhost:4000/v1/embeddings \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding",
    "input": ["LiteLLM là một cổng AI"]
  }'
```

---

## Tích hợp với các Công cụ Phổ biến

### OpenAI SDK (Python)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:4000",
    api_key="sk-your-litellm-virtual-key"
)

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Giải thích cân bằng tải"}]
)
print(response.choices[0].message.content)
```

### LangChain

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    model="claude-sonnet",
    openai_api_key="sk-your-virtual-key",
    openai_api_base="http://localhost:4000"
)

result = llm.invoke("Các loại gateway LLM là gì?")
print(result.content)
```

### Anthropic SDK (Tương thích Gốc)

```python
from anthropic import Anthropic

client = Anthropic(
    base_url="http://localhost:4000/anthropic",
    api_key="sk-your-virtual-key"
)

response = client.messages.create(
    model="claude-sonnet",
    max_tokens=1024,
    messages=[{"role": "user", "content": "So sánh LiteLLM và OpenRouter"}]
)
print(response.content[0].text)
```

### Ollama (Mô hình Cục bộ)

```yaml
# Thêm vào litellm_config.yaml
model_list:
  - model_name: local-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://localhost:11434
    model_info:
      mode: chat
```

```bash
# Kiểm tra mô hình cục bộ qua LiteLLM
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-llama",
    "messages": [{"role": "user", "content": "Xin chào mô hình cục bộ"}]
  }'
```

### Cohere

```yaml
model_list:
  - model_name: cohere-command
    litellm_params:
      model: cohere/command-r-plus
      api_key: os.environ/COHERE_API_KEY
```

```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:4000", api_key="sk-virtual-key")
response = client.chat.completions.create(
    model="cohere-command",
    messages=[{"role": "user", "content": "Tóm tắt điều này"}]
)
```

---

## Benchmark / Trường hợp Sử dụng Thực tế

### Kịch bản: Nền tảng AI Đa Đội (Startup SaaS)

Startup AI 50 ngườI phục vụ 5 đội nội bộ và khách hàng API bên ngoài:

| Chỉ số | Trước LiteLLM | Sau LiteLLM |
|--------|---------------|-------------|
| SDK nhà cung cấp duy trì | 4 (OpenAI, Anthropic, Gemini, Ollama) | 1 (Tương thích OpenAI) |
| Quản lý khóa API | Khóa chung trong biến môi trường | Khóa ảo mỗi đội/khách hàng |
| Phân bổ chi phí | Xuất CSV thủ công | Chi phí theo khóa thờI gian thực |
| Phản ứng sự cố | Gọi ngườI, 15 phút MTTR | Tự động chuyển đổi, <500ms |
| Chi phí LLM hàng tháng | 195 triệu VNĐ (chưa tối ưu) | 142 triệu VNĐ (-27% với định tuyến) |

### Benchmark Hiệu suất (Tự lưu trữ, 4 vCPU / 8 GB RAM)

| Tải | Thông lượng | Độ trễ P50 | Độ trễ P99 |
|-----|------------|-----------|-----------|
| 50 RPS chat (GPT-4o) | Ổn định | 45ms overhead | 120ms overhead |
| 200 RPS embedding | Ổn định | 12ms overhead | 35ms overhead |
| Kích hoạt failover | — | 180ms chuyển đổi | 280ms chuyển đổi |
| Cache hit (Redis) | — | 3ms | 8ms |

**Lưu ý:** Chi phí gateway không bao gồm thờI gian phản hồi API LLM. LiteLLM thêm chi phí độ trễ nhỏ, có thể dự đoán. Đối với các luồng mà mỗi mili giây đều quan trọng, triển khai proxy trong cùng VPC với ứng dụng.

---

## Sử dụng Nâng cao / Cứng hóa Production

### Khóa Ảo và Quản lý Đội

Khóa ảo là xương sống bảo mật của triển khai LiteLLM production. Mỗi khóa có thể có ngân sách, giới hạn tốc độ, danh sách truy cập mô hình, và TTL riêng.

![LiteLLM Admin Dashboard](images/litellm-dashboard.png)

```bash
# Tạo khóa ảo cho "đội frontend"
curl -X POST http://localhost:4000/key/generate \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "key_alias": "frontend-team-key",
    "team_id": "frontend-team",
    "models": ["gpt-4o", "gemini-flash"],
    "max_budget": 500.00,
    "budget_duration": "30d",
    "rpm_limit": 100,
    "tpm_limit": 50000,
    "metadata": {
      "service": "customer-chat-widget",
      "env": "production"
    }
  }'

# Phản hồi:
# {
#   "key": "sk-litellm-abc123...",
#   "expires": null,
#   "max_budget": 500.00,
#   "models": ["gpt-4o", "gemini-flash"]
# }
```

### Giới hạn Ngân sách Cấp Nhà cung cấp

```yaml
general_settings:
  provider_budget_config:
    openai:
      monthly_budget: 5000.00
    anthropic:
      monthly_budget: 3000.00
    gemini:
      monthly_budget: 1000.00
```

### Định tuyến Dựa trên Độ trễ

```yaml
router_settings:
  routing_strategy: latency-based-routing
  routing_strategy_args:
    ttl: 60
  allowed_fails: 3
  cooldown_time: 60
  num_retries: 2
  timeout: 90
  retry_after: 5
```

### Danh sách Kiểm tra Bảo mật

```yaml
# config.yaml được cứng hóa bảo mật
general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL

  # Buộc HTTPS trong production
  # Chạy phía sau Nginx hoặc AWS ALB với TLS termination

  # Vô hiệu hóa ghi log chi tiết
  litellm_settings:
    set_verbose: false

  # Mã hóa khóa khi lưu trữ
  litellm_settings:
    key_generation_algorithm: "rsa"
    allow_user_auth: false
```

### Triển khai Kubernetes / Helm

```bash
# Thêm repo Helm LiteLLM
helm pull oci://docker.litellm.ai/berriai/litellm-helm

# Cài đặt với giá trị tùy chỉnh
helm install litellm-gateway ./litellm-helm \
  --namespace litellm \
  --create-namespace \
  --set replicaCount=3 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=litellm.yourdomain.com \
  --set env.LITELLM_MASTER_KEY="sk-$(openssl rand -hex 16)" \
  --set env.DATABASE_URL="postgresql://user:pass@neon-host/litellm"
```

### Giám sát với Prometheus + Grafana

```yaml
# Thêm vào config.yaml
litellm_settings:
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

Các chỉ số Prometheus chính hiển thị tại `/metrics`:

```promql
# Tốc độ yêu cầu theo mô hình
rate(litellm_request_total_requests[5m])

# Tỷ lệ lỗi
rate(litellm_requests_total_failed[5m])

# Ngân sách còn lại theo khóa
litellm_remaining_requests

# Histogram chi phí gateway
histogram_quantile(0.95, litellm_overhead_latency_ms_bucket)
```

Nhập [dashboard Grafana chính thức](https://github.com/BerriAI/litellm/blob/main/examples/grafana/grafana_dashboard.json) để có các panel đã xây dựng sẵn hiển thị yêu cầu/giây, lượng token, chi phí theo đội, và phân vị độ trễ.

---

## So sánh với Các Giải pháp Thay thế

| Tính năng | LiteLLM | Portkey | OpenRouter | Helicone |
|-----------|---------|---------|------------|----------|
| **Giấy phép** | MIT (Mã nguồn mở) | Lõi đóng + SDK mở | Đóng (Lưu trữ) | Đóng (Lưu trữ + Tự lưu trữ) |
| **Triển khai** | Tự lưu trữ / Docker / K8s | Cloud + Hybrid | Chỉ lưu trữ | Cloud + Tự lưu trữ |
| **Mô hình hỗ trợ** | 100+ nhà cung cấp | 200+ | 300+ | Phụ thuộc nhà cung cấp |
| **Chi phí tự lưu trữ** | 5–20 triệu VNĐ/tháng hạ tầng | N/A (quản lý) | N/A (lưu trữ) | 0–2.5 triệu VNĐ/tháng (tự lưu trữ) |
| **Khóa ảo / Ngân sách** | Theo khóa + Theo đội | Theo khóa + Theo ngườI dùng | Cơ bản theo khóa | Theo tổ chức |
| **Tự động failover** | Chuỗi cấu hình | Circuit breaker | Định tuyến nhà cung cấp | Hạn chế |
| **Bộ nhớ đệm ngữ nghĩa** | Redis + Qdrant | Tích hợp | Không | Không |
| **Khả năng quan sát** | Prometheus + bên ngoài | Tích hợp dò tìm sâu | Thống kê cơ bản | Trọng tâm chính |
| **Tuân thủ** | DIY (SOC2 qua hạ tầng) | SOC 2, ISO 27001, HIPAA | Một phần | SOC 2 |
| **Tốt nhất cho** | Kiểm soát hoàn toàn, không khóa | Quản trị doanh nghiệp | Truy cập mô hình nhanh | Ưu tiên khả năng quan sát |

**Khi nào chọn gì:**

- **LiteLLM** — Bạn có năng lực DevOps, muốn không bị khóa nhà cung cấp, và cần kiểm soát hoàn toàn định tuyến, bộ nhớ đệm, và nơi lưu trữ dữ liệu.
- **Portkey** — Bạn cần quản trị doanh nghiệp (SOC 2, log kiểm tra), UI quản lý prompt, và sẵn sàng trả phí SaaS.
- **OpenRouter** — Bạn muốn truy cập ngay 300+ mô hình với không công việc hạ tầng, và phí tín dụng 5.5% là chấp nhận được.
- **Helicone** — Khả năng quan sát là mối quan tâm chính; bạn cần dò tìm chi tiết và phân bổ chi phí cho các cuộc gọi LLM.

---

## Hạn chế / Đánh giá Trung thực

LiteLLM không phải công cụ phù hợp cho mọi tình huống. Đây là nơi nó còn thiếu:

1. **Chi phí vận hành** — Không giống gateway quản lý, bạn chịu trách nhiệm về thờI gian hoạt động, mở rộng, vá bảo mật, và sao lưu cơ sở dữ liệu. Dự trù 0.5–1 FTE cho bảo trì production.

2. **Không có quản lý prompt tích hợp** — UI phiên bản prompt của Portkey với A/B testing không tồn tại trong LiteLLM. Bạn quản lý template prompt trong ứng dụng hoặc công cụ bên ngoài.

3. **Bộ nhớ đệm ngữ nghĩa cần hạ tầng bổ sung** — Bộ nhớ đệm ngữ nghĩa Redis cần endpoint mô hình embedding. Điều này thêm độ phức tạp và chi phí so với bộ nhớ đệm ngữ nghĩa tích hợp của Portkey.

4. **Không có dự phòng đa vùng gốc** — Bạn tự thiết kế failover đa vùng với DNS hoặc load balancer toàn cầu. LiteLLM theo mặc định là proxy một vùng.

5. **SSO doanh nghiệp có phí** — SAML/SSO, log kiểm tra, và guardrail nâng cao là một phần của LiteLLM Enterprise. Phiên bản OSS chỉ xử lý khóa ảo và ngân sách cơ bản.

---

## Câu hỏi Thường gặp

**Q: LiteLLM so với OpenRouter như thế nào?**

LiteLLM là gateway mã nguồn mở tự lưu trữ; OpenRouter là API đa mô hình được quản lý. LiteLLM cho bạn không phí thêm và kiểm soát hoàn toàn dữ liệu. OpenRouter tính phí 5.5% mua tín dụng nhưng không cần công việc hạ tầng. Với đội có chi tiêu LLM >$5K/tháng và năng lực DevOps, LiteLLM rẻ hơn về lâu dàI. Để prototyping nhanh, OpenRouter triển khai nhanh hơn.

**Q: Tôi có thể dùng LiteLLM với code OpenAI SDK hiện có không?**

Có — chỉ cần đổi hai dòng: đặt `base_url` về proxy LiteLLM và `api_key` về khóa ảo. Mọi thứ khác giữ nguyên. Đây là lý do chính các đội áp dụng LiteLLM; không thay đổi code ngoàI cấu hình.

**Q: LiteLLM cần cơ sở dữ liệu gì?**

PostgreSQL 14+ là bắt buộc cho tính năng production (khóa ảo, theo dõi chi phí, quản lý đội). Proxy có thể chạy không có cơ sở dữ liệu cho định tuyến chuyển tiếp cơ bản, nhưng bạn mất quản lý ngân sách, quản lý khóa, và Admin UI.

**Q: Cơ chế failover hoạt động như thế nào?**

Bạn định nghĩa chuỗi fallback trong `config.yaml`. Nếu mô hình trả về 429, 500, hoặc timeout, LiteLLM thử lại yêu cầu với mô hình tiếp theo trong chuỗi — tất cả trong cùng một yêu cầu client. Client thấy một phản hồi duy nhất; failover xảy ra trong suốt.

**Q: LiteLLM có phù hợp cho production lưu lượng cao không?**

Có — với bộ nhớ đệm Redis và 2+ bản sao phía sau load balancer, LiteLLM xử lý 1,000+ RPS. Connection pool cơ sở dữ liệu và Redis transaction buffer là điểm nghẽn mở rộng, không phải proxy. Dùng Helm Chart với HPA để tự động mở rộng trên Kubernetes.

**Q: Làm thế nào để giám sát LiteLLM trong production?**

Bật callback Prometheus trong `config.yaml`, scrape endpoint `/metrics`, và nhập dashboard Grafana chính thức. Thiết lập cảnh báo trên `litellm_requests_total_failed` (tỷ lệ lỗi) và `litellm_remaining_requests` (cạn kiệt ngân sách). Kết nối `success_callback` với Langfuse để dò tìm theo yêu cầu.

---

## Kết luận

LiteLLM giải quyết thực tế hỗn loạn của việc triển khai đa LLM production: nhiều SDK, khóa API rải rác, chi phí không minh bạch, và failover thủ công. Với một `config.yaml`, bạn có gateway tương thích OpenAI thống nhất, khóa ảo với ngân sách, tự động failover, và theo dõi chi phí thờI gian thực.

Với đội chi tiêu $5,000+/tháng cho API LLM và có năng lực DevOps cơ bản, tự lưu trữ LiteLLM hoàn vốn qua phí markup giảm và độ tin cậy cải thiện. Bắt đầu với thiết lập Docker Compose ở trên, thêm bộ nhớ đệm Redis, rồi mở rộng lên Kubernetes với Helm khi lưu lượng tăng.

**Hành động:**

1. Clone [kho GitHub LiteLLM](https://github.com/BerriAI/litellm) và chạy Docker Compose quick-start
2. Tạo khóa ảo cho mỗi đội và đặt ngân sách theo khóa
3. Bật bộ nhớ đệm Redis và giám sát Prometheus
4. Tham gia [cộng đồng Discord LiteLLM](https://discord.gg/wupm9ySymB) để được hỗ trợ và thảo luận tính năng

*Một số liên kết trong bàI viết này là liên kết tiếp thị. Chúng tôi có thể nhận hoa hồng nếu bạn mua dịch vụ lưu trữ qua chúng — điều này không ảnh hưởng đến giá hoặc khuyến nghị.*

---



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu Tham khảo

- [Kho GitHub LiteLLM](https://github.com/BerriAI/litellm) — Mã nguồn chính thức, 22,500+ sao
- [Tài liệu LiteLLM](https://docs.litellm.ai/docs/) — Tài liệu proxy và SDK đầy đủ
- [Docker Quick Start LiteLLM](https://docs.litellm.ai/docs/proxy/docker_quick_start) — Hướng dẫn thiết lập Docker chính thức
- [Tham chiếu Cấu hình LiteLLM](https://docs.litellm.ai/docs/proxy/configs) — Tất cả tùy chọn config.yaml
- [Triển khai Helm LiteLLM](https://docs.litellm.ai/docs/proxy/deploy) — Biểu đồ Kubernetes và Helm
- [Tài liệu Admin UI LiteLLM](https://docs.litellm.ai/docs/proxy/ui) — Quản lý khóa ảo và đội
- [Hướng dẫn Bộ nhớ đệm LiteLLM](https://docs.litellm.ai/docs/caching/all_caches) — Redis, semantic, và disk caching
- [So sánh Portkey vs LiteLLM](https://portkey.ai/lp/portkey-vs-litellm) — Trang so sánh nhà cung cấp
- [Tài liệu OpenRouter](https://openrouter.ai/docs) — Tài liệu gateway thay thế
- [Tài liệu Helicone](https://docs.helicone.ai) — Giải pháp thay thế tập trung quan sát
