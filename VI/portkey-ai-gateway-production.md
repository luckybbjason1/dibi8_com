---
title: 'Portkey AI Gateway 2026: Cổng LLM Quản lý 200+ Mô hình với Khả năng Quan sát — Thiết lập Production'
description: ''
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/Portkey-AI/gateway'
stars: 14000
maintainer: 'Portkey-AI'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Portkey AI Gateway']
aliases:
- /vi/posts/portkey-ai-gateway-production/
---

{{</* resource-info */>}}

Quản lý nhiều nhà cung cấp Mô hình Ngôn ngữ Lớn (LLM) trong môi trường production là một cơn ác mộng. Mỗi nhà cung cấp có định dạng API, lược đồ xác thực, giới hạn tốc độ và chế độ lỗi riêng. Mã ứng dụng của bạn trở nên lộn xộn với logic điều kiện cho OpenAI, Anthropic, Google, Azure và hàng chục nhà cung cấp mới xuất hiện mỗi tháng. Hãy đến với **Portkey AI Gateway** — cổng LLM mã nguồn mở thống nhất 200+ mô hình phía sau một API duy nhất, với khả năng cân bằng tải, định tuyến dự phòng, theo dõi chi tiêu, lưu đệm yêu cầu và khả năng quan sát cấp doanh nghiệp.

Trong hướng dẫn toàn diện này, chúng tôi sẽ hướng dẫn thiết lập Portkey AI Gateway sẵn sàng cho production. Bạn sẽ học cách định tuyến yêu cầu qua nhiều nhà cung cấp, triển khai dự phòng thông minh, giám sát chi tiêu, lưu đệm phản hồi và thực thi các rào chắn bảo vệ — tất cả trong khi giữ mã ứng dụng của bạn sạch sẽ và độc lập với nhà cung cấp.

> **Bắt đầu Nhanh**: Portkey AI Gateway là mã nguồn mở theo giấy phép MIT với hơn 14.000 sao GitHub. Bạn có thể tự lưu trữ hoặc sử dụng tùy chọn đám mây được quản lý. Sẵn sàng chưa? Hãy bắt đầu.

---

## Portkey AI Gateway là gì?

Portkey AI Gateway là một cổng AI mã nguồn mở nằm giữa ứng dụng và các nhà cung cấp LLM. Hãy nghĩ về nó như một proxy ngược thông minh được thiết kế đặc biệt cho khối lượng công việc AI. Nó chuẩn hóa bề mặt API trên 200+ mô hình từ các nhà cung cấp như OpenAI, Anthropic, Google, Azure, Cohere, Mistral và nhiều hơn nữa, để mã của bạn chỉ cần sử dụng một ngôn ngữ.

Cổng xử lý các phần khó khăn của việc triển khai LLM production:

- **API Thống nhất**: Một điểm cuối cho 200+ mô hình từ 20+ nhà cung cấp
- **Cân bằng tải**: Phân phối lưu lượng qua nhiều khóa API hoặc nhà cung cấp
- **Định tuyến dự phòng**: Tự động chuyển đổi khi nhà cung cấp gặp sự cố
- **Lưu đệm yêu cầu**: Lưu các yêu cầu giống hệt nhau để giảm chi phí và độ trễ
- **Theo dõi chi tiêu**: Khả năng hiển thị thởi gian thực vào chi tiêu AI của bạn
- **Quản lý Prompt**: Quản lý và phien bản hóa prompt độc lập với mã
- **Rào chắn bảo vệ**: Thực thi các chính sách nội dung và kiểm tra an toàn
- **Khả năng quan sát**: Ghi log yêu cầu/phản hồi đầy đủ, số liệu và theo dõi

Dù bạn là startup chạy một mô hình hay doanh nghiệp quản lý hàng chục nhà cung cấp, Portkey cung cấp lớp hạ tầng bạn cần để đưa ứng dụng AI vào production.

---

## Tổng quan Kiến trúc và Tùy chọn Triển khai

Portkey AI Gateway cung cấp hai chế độ triển khai: **Cloud (được quản lý)** và **Tự lưu trữ**. Kiến trúc được xây dựng xung quanh máy chủ cổng nhẹ, hiệu suất cao chặn các yêu cầu LLM, áp dụng các chính sách đã cấu hình và định tuyến chúng đến nhà cung cấp phù hợp.

### Triển khai Cloud

Cách nhanh nhất để bắt đầu là sử dụng dịch vụ cloud được quản lý của Portkey. Đăng ký tại [Portkey.ai](https://portkey.ai), tạo khóa API và bạn đã sẵn sàng định tuyến yêu cầu. Tùy chọn cloud xử lý mở rộng, cập nhật và bảo trì hạ tầng cho bạn.

### Triển khai Tự lưu trữ

Đối với các tổ chức có yêu cầu nghiêm ngặt về lưu trữ dữ liệu hoặc bảo mật, tự lưu trữ là cách đi tốt nhất. Cổng có thể được triển khai qua Docker, Kubernetes hoặc như một ứng dụng Node.js độc lập.

**Triển khai với Docker:**

```bash
# Sao chép repository
git clone https://github.com/Portkey-AI/gateway.git
cd gateway

# Chạy với Docker
docker run -p 8787:8787 -e PORTKEY_GATEWAY_API_KEY=your-gateway-key portkeyai/gateway:latest
```

**Triển khai với Docker Compose:**

```yaml
version: '3.8'
services:
  portkey-gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - CACHE_ENABLED=true
      - CACHE_TTL=3600
    volumes:
      - ./config:/app/config
    restart: unless-stopped
```

**Triển khai lên Kubernetes:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: portkey-gateway
spec:
  replicas: 3
  selector:
    matchLabels:
      app: portkey-gateway
  template:
    metadata:
      labels:
        app: portkey-gateway
    spec:
      containers:
      - name: gateway
        image: portkeyai/gateway:latest
        ports:
        - containerPort: 8787
        env:
        - name: PORTKEY_GATEWAY_API_KEY
          valueFrom:
            secretKeyRef:
              name: portkey-secrets
              key: gateway-api-key
---
apiVersion: v1
kind: Service
metadata:
  name: portkey-gateway-service
spec:
  selector:
    app: portkey-gateway
  ports:
  - port: 80
    targetPort: 8787
  type: ClusterIP
```

Đối với triển khai production, chúng tôi khuyến nghị Kubernetes với ít nhất 3 bản sao để đảm bảo tính sẵn sàng cao. Nếu bạn cần một nền tảng đám mây đáng tin cậy để lưu trữ cluster, [DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0) cung cấp dịch vụ Kubernetes được quản lý thân thiện với nhà phát triển, kết hợp hoàn hảo với Portkey.

---

## Cấu hình Nhà cung cấp và Khóa API

Trước khi định tuyến yêu cầu, bạn cần cấu hình các nhà cung cấp LLM của mình. Portkey sử dụng hệ thống cấu hình nhà cung cấp để lưu trữ an toàn các khóa API và ánh xạ chúng đến các phiên bản nhà cung cấp đã đặt tên.

### Thiết lập Nhà cung cấp

Tạo tệp cấu hình `providers.yaml`:

```yaml
providers:
  openai-primary:
    type: openai
    api_key: ${OPENAI_API_KEY}
    organization: ${OPENAI_ORG_ID}
    
  anthropic-primary:
    type: anthropic
    api_key: ${ANTHROPIC_API_KEY}
    
  azure-gpt4:
    type: azure-openai
    api_key: ${AZURE_API_KEY}
    resource_name: ${AZURE_RESOURCE_NAME}
    deployment_id: gpt-4
    api_version: 2025-12-01
    
  google-gemini:
    type: google
    api_key: ${GOOGLE_API_KEY}
    
  mistral-local:
    type: mistral
    api_key: ${MISTRAL_API_KEY}
    base_url: http://mistral-service:8000/v1
```

### Tải Cấu hình

```bash
# Đặt biến môi trường
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GATEWAY_API_KEY="pk-..."

# Khởi động cổng với cấu hình
docker run -p 8787:8787 \
  -e PORTKEY_GATEWAY_API_KEY=$GATEWAY_API_KEY \
  -v $(pwd)/providers.yaml:/app/config/providers.yaml \
  portkeyai/gateway:latest
```

---

## API Thống nhất: Một Điểm cuối cho 200+ Mô hình

Giá trị cốt lõi của Portkey là API thống nhất của nó. Bất kể bạn đang gọi mô hình hay nhà cung cấp nào, định dạng yêu cầu vẫn giữ nguyên. Cổng xử lý việc dịch giữa định dạng Portkey chuẩn hóa và định dạng gốc của mỗi nhà cung cấp.

### Yêu cầu Hoàn thành Trò chuyện Cơ bản

```bash
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "provider": "openai-primary",
    "messages": [
      {"role": "system", "content": "Bạn là một trợ lý hữu ích."},
      {"role": "user", "content": "Giải thích điện toán lượng tử bằng thuật ngữ đơn giản."}
    ]
  }'
```

### Chuyển đổi Nhà cung cấp Ngay lập tức

```bash
# Yêu cầu giống hệt, nhà cung cấp khác — chỉ cần thay đổi trường model/provider
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4",
    "provider": "anthropic-primary",
    "messages": [
      {"role": "user", "content": "Giải thích điện toán lượng tử bằng thuật ngữ đơn giản."}
    ],
    "max_tokens": 1024
  }'
```

### Ví dụ SDK Python

```python
from portkey_ai import Portkey

# Khởi tạo client
portkey = Portkey(
    api_key="your-gateway-api-key",
    virtual_key="openai-primary"  # Tham chiếu nhà cung cấp đã cấu hình
)

# Hoàn thành trò chuyện
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "Bạn là một trợ lý hữu ích."},
        {"role": "user", "content": "Viết hàm Python để tính số fibonacci."}
    ]
)
print(response.choices[0].message.content)
```

### Phản hồi Truyền trực tiếp

```python
import portkey_ai

portkey = portkey_ai.Portkey(api_key="your-gateway-api-key")

stream = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Viết một bài thơ về AI."}],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

---

## Cân bằng Tải và Định tuyến Dự phòng

Hệ thống AI production không thể chấp nhận sự cố nhà cung cấp. Cân bằng tải và định tuyến dự phòng của Portkey đảm bảo ứng dụng của bạn luôn trực tuyến ngay cả khi nhà cung cấp gặp sự cố.

### Cân bằng Tải Vòng tròn

Phân phối đều lưu lượng qua nhiều khóa API hoặc nhà cung cấp:

```yaml
# config/load-balance.yaml
strategies:
  gpt4-pool:
    type: load_balance
    providers:
      - provider: openai-primary
        weight: 1
      - provider: azure-gpt4
        weight: 1
      - provider: openai-backup
        weight: 1
```

```python
# Sử dụng pool cân bằng tải
response = portkey.chat.completions.create(
    model="gpt-4o",
    config="gpt4-pool",  # Tham chiếu chiến lược
    messages=[{"role": "user", "content": "Xin chào!"}]
)
```

### Định tuyến Dự phòng Dựa trên Mức độ ưu tiên

Xác định chuỗi dự phòng để chuyển đổi dự phòng tự động:

```yaml
strategies:
  production-fallback:
    type: fallback
    targets:
      - provider: azure-gpt4
        timeout: 10
        retry: 2
      - provider: openai-primary
        timeout: 15
        retry: 1
      - provider: anthropic-primary
        model: claude-sonnet-4
        timeout: 15
      - provider: google-gemini
        model: gemini-2.5-pro
        timeout: 20
```

```bash
# Cổng thử từng mục tiêu theo thứ tự cho đến khi một cái thành công
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "config": "production-fallback",
    "messages": [{"role": "user", "content": "Truy vấn kinh doanh quan trọng"}]
  }'
```

### Định tuyến Có điều kiện Dựa trên Thuộc tính Yêu cầu

Định tuyến yêu cầu dựa trên nội dung, ngưởi dùng hoặc các thuộc tính yêu cầu khác:

```yaml
strategies:
  smart-router:
    type: conditional
    rules:
      - condition: "request.messages[0].content.length > 4000"
        target: 
          provider: anthropic-primary
          model: claude-sonnet-4  # Xử lý ngữ cảnh dài tốt hơn
      - condition: "request.user == 'code-assistant'"
        target:
          provider: openai-primary
          model: gpt-4o
      - condition: "default"
        target:
          provider: azure-gpt4
          model: gpt-4o-mini
```

---

## Lưu đệm Yêu cầu: Giảm Chi phí và Độ trễ

Các lệnh gọi API LLM đắt đỏ và chậm. Bộ nhớ đệm ngữ nghĩa của Portkey lưu trữ các phản hồi và phục vụ các kết quả được lưu đệm cho các truy vấn tương tự, giảm đáng kể cả chi phí và độ trễ.

### Bật Bộ nhớ đệm

```yaml
cache:
  enabled: true
  mode: semantic  # hoặc "exact" cho lưu đệm khớp chính xác
  ttl: 3600       # Thờ gian sống của bộ nhớ đệm tính bằng giây
  max_size: 10000 # Số lượng mục được lưu đệm tối đa
  similarity_threshold: 0.95  # Cho lưu đệm ngữ nghĩa
```

```python
# Lần gọi đầu tiên truy cập nhà cung cấp và lưu đệm kết quả
response1 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Kubernetes là gì?"}],
    cache=True
)

# Lần gọi tương tự trả về kết quả được lưu đệm ngay lập tức với chi phí thấp hơn
response2 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Giải thích Kubernetes cho tôi"}],
    cache=True
)
```

### Thống kê Bộ nhớ đệm và Làm mất hiệu lực

```bash
# Kiểm tra chỉ số bộ nhớ đệm
curl http://localhost:8787/v1/admin/cache/stats \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# Làm mất hiệu lực các mục bộ nhớ đệm cụ thể
curl -X POST http://localhost:8787/v1/admin/cache/invalidate \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "pattern": "kubernetes",
    "provider": "openai-primary"
  }'
```

---

## Theo dõi Chi tiêu và Khả năng Quan sát Chi phí

Hiểu rõ chi tiêu AI của bạn trên các nhà cung cấp, mô hình và ngưởi dùng là rất quan trọng cho việc quản lý ngân sách. Portkey cung cấp khả năng theo dõi chi phí chi tiết ngay từ đầu.

### Thiết lập Theo dõi Chi phí

```python
import portkey_ai

portkey = portkey_ai.Portkey(
    api_key="your-gateway-api-key",
    metadata={
        "user_id": "user-12345",
        "project": "customer-support-bot",
        "environment": "production",
        "team": "ai-platform"
    }
)

response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Giúp với đơn hàng của tôi"}]
)

# Truy cập thông tin chi phí từ phản hồi
print(f"Token đầu vào: {response.usage.prompt_tokens}")
print(f"Token đầu ra: {response.usage.completion_tokens}")
print(f"Tổng chi phí: ${response.usage.estimated_cost}")
```

### Truy vấn Phân tích Chi tiêu

```bash
# Nhận báo cáo chi tiêu theo nhà cung cấp
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=provider" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# Nhận báo cáo chi tiêu theo ngưởi dùng
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=user_id" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

### Cảnh báo Ngân sách

```yaml
alerts:
  daily-budget:
    type: budget
    threshold: 500  # USD
    period: daily
    channels:
      - type: webhook
        url: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
      - type: email
        address: team@company.com
  
  abnormal-spike:
    type: anomaly
    baseline_multiplier: 3
    window: 1h
    channels:
      - type: pagerduty
        integration_key: your-pd-key
```

---

## Quản lý Prompt và Phiên bản hóa

Quản lý prompt tách biệt với mã ứng dụng cho phép các thành viên nhóm không chuyên về kỹ thuật lặp lại prompt mà không cần triển khai. Hệ thống quản lý prompt của Portkey cung cấp phiên bản hóa, A/B testing và thay thế biến động.

### Tạo Prompt được Quản lý

```python
from portkey_ai import Portkey

portkey = Portkey(api_key="your-gateway-api-key")

# Triển khai phiên bản prompt
prompt = portkey.prompts.deploy(
    name="customer-support-classifier",
    version="1.2.0",
    prompt=[
        {"role": "system", "content": "Bạn là bộ phân loại phiếu hỗ trợ. Phân loại phiếu vào: Thanh toán, Kỹ thuật, Yêu cầu Tính năng, hoặc Khiếu nại."},
        {"role": "user", "content": "Phiếu: {{ticket_content}}"}
    ],
    model="gpt-4o-mini",
    parameters={
        "temperature": 0.2,
        "max_tokens": 50
    }
)
```

### Kết xuất Prompt với Biến

```python
# Kết xuất và thực thi prompt được quản lý
response = portkey.prompts.render(
    name="customer-support-classifier",
    variables={
        "ticket_content": "Tôi đã bị tính phí hai lần cho đăng ký tháng này."
    }
)

print(response.choices[0].message.content)
# Kết quả: "Thanh toán"
```

### A/B Testing Prompt

```python
# Chạy A/B test giữa các phiên bản prompt
response = portkey.prompts.render(
    name="customer-support-classifier",
    version="1.2.0",  # 50% lưu lượng
    test_version="1.3.0-beta",  # 50% lưu lượng
    variables={"ticket_content": "Ứng dụng gặp sự cố khi tải ảnh lên"}
)
```

---

## Rào chắn Bảo vệ và An toàn Nội dung

Hệ thống rào chắn bảo vệ của Portkey cho phép bạn thực thi các chính sách nội dung trên cả yêu cầu và phản hồi, đảm bảo tuân thủ các tiêu chuẩn an toàn và quy tắc kinh doanh.

### Cấu hình Rào chắn Bảo vệ

```yaml
guardrails:
  input-validation:
    - type: keyword_filter
      blocklist: ["password", "ssn", "credit_card", "secret_key"]
      action: block
    - type: pii_detector
      entities: ["email", "phone", "ssn"]
      action: mask
    - type: toxicity_check
      threshold: 0.8
      action: block
      
  output-validation:
    - type: content_policy
      categories: ["hate", "violence", "self-harm"]
      action: block
    - type: response_format
      required_schema:
        type: json_object
      action: retry
```

```python
# Áp dụng rào chắn bảo vệ cho yêu cầu
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Nội dung nhập của ngưởi dùng"}],
    guardrails=["input-validation", "output-validation"]
)
```

### Hàm Rào chắn Bảo vệ Tùy chỉnh

```python
from portkey_ai import Portkey
import json

portkey = Portkey(api_key="your-gateway-api-key")

def custom_validator(request, response):
    """Xác thực logic kinh doanh tùy chỉnh."""
    try:
        data = json.loads(response.choices[0].message.content)
        if "confidence" not in data or data["confidence"] < 0.7:
            return False, "Điểm tin cậy quá thấp"
        return True, None
    except json.JSONDecodeError:
        return False, "Phản hồi phải là JSON hợp lệ"

portkey.guardrails.register("confidence-check", custom_validator)
```

---

## Khả năng Quan sát: Ghi log, Số liệu và Theo dõi

Hiểu rõ hệ thống AI của bạn hoạt động như thế nào trong production là không thể thương lượng. Portkey cung cấp khả năng quan sát toàn diện với ghi log yêu cầu/phản hồi, số liệu sử dụng token, biểu đồ độ trễ và theo dõi phân tán.

### Ghi log Yêu cầu

```bash
# Truy vấn nhật ký yêu cầu gần đây
curl "http://localhost:8787/v1/admin/logs?limit=100&status=error" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```python
# Bật ghi log chi tiết cho mỗi yêu cầu
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Xin chào"}],
    metadata={
        "trace_id": "trace-abc-123",
        "session_id": "session-xyz-789",
        "user_id": "user-456"
    }
)
```

### Tích hợp OpenTelemetry

```yaml
observability:
  tracing:
    enabled: true
    exporter: otlp
    endpoint: http://jaeger-collector:4317
  metrics:
    enabled: true
    exporter: prometheus
    port: 9090
```

### Số liệu Prometheus

Cổng sẽ hiển thị các số liệu tương thích với Prometheus tại `/metrics`:

```bash
# Thu thập số liệu
curl http://localhost:8787/metrics
```

Các số liệu chính bao gồm:
- `portkey_requests_total` — Tổng số yêu cầu theo nhà cung cấp, mô hình, trạng thái
- `portkey_request_duration_seconds` — Biểu đồ độ trễ yêu cầu
- `portkey_tokens_total` — Sử dụng token theo loại (đầu vào/đầu ra) và mô hình
- `portkey_cache_hits_total` — Số lượt truy cập bộ nhớ đệm hit/miss
- `portkey_spend_total` — Chi tiêu ước tính bằng USD

### Bảng điều khiển Grafana

Nhập bảng điều khiển Grafana chính thức của Portkey (ID: `portkey-ai-gateway`) để có trực quan hóa sẵn có:

```json
{
  "dashboard": {
    "title": "Tổng quan Portkey AI Gateway",
    "panels": [
      {
        "title": "Yêu cầu mỗi Giây",
        "targets": [
          {
            "expr": "rate(portkey_requests_total[5m])"
          }
        ]
      },
      {
        "title": "Độ trễ P95",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, portkey_request_duration_seconds_bucket)"
          }
        ]
      },
      {
        "title": "Sử dụng Token",
        "targets": [
          {
            "expr": "sum by (model) (portkey_tokens_total)"
          }
        ]
      }
    ]
  }
}
```

---

## Danh sách Kiểm tra Triển khai Production

Trước khi đưa Portkey AI Gateway vào production, hãy đảm bảo bạn đã hoàn thành các mục quan trọng sau:

### Hạ tầng

```yaml
# docker-compose production với Redis để lưu đệm và PostgreSQL để ghi log
version: '3.8'
services:
  gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - REDIS_URL=redis://redis:6379
      - DATABASE_URL=postgres://user:pass@postgres:5432/portkey
    depends_on:
      - redis
      - postgres
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
  
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
  
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: portkey
      POSTGRES_USER: user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  redis-data:
  postgres-data:
```

### Danh sách Kiểm tra Bảo mật

| Mục | Trạng thái | Ghi chú |
|------|--------|------|
| Xoay vòng khóa API | Bắt buộc | Xoay khóa gateway hàng tháng |
| Chấm dứt TLS | Bắt buộc | Sử dụng proxy ngược hoặc cân bằng tải |
| Giới hạn tốc độ | Bắt buộc | Cấu hình giới hạn mỗi ngưởi dùng và mỗi IP |
| Che PII | Khuyến nghị | Bật cho khối lượng công việc production |
| Ghi log kiểm toán | Bắt buộc | Ghi lại mọi hành động quản trị |
| Cách ly mạng | Khuyến nghị | Triển khai trong mạng con riêng |

### Kiểm tra Sức khỏe

```bash
# Điểm cuối sức khỏe gateway
curl http://localhost:8787/health

# Phản hồi mong đợi
{"status": "healthy", "version": "2.5.0", "uptime": 86400}
```

```yaml
# Probe liveness và readiness Kubernetes
livenessProbe:
  httpGet:
    path: /health
    port: 8787
  initialDelaySeconds: 10
  periodSeconds: 15

readinessProbe:
  httpGet:
    path: /ready
    port: 8787
  initialDelaySeconds: 5
  periodSeconds: 5
```

---

## FAQ: Portkey AI Gateway

### Portkey AI Gateway hỗ trợ những mô hình nào?

Portkey hỗ trợ 200+ mô hình từ 20+ nhà cung cấp bao gồm OpenAI (GPT-4o, GPT-4o-mini, o3), Anthropic (Claude 4, Claude 3.5), Google (Gemini 2.5), Azure OpenAI, Cohere, Mistral, Together AI, Groq, Perplexity và nhiều hơn nữa. Các nhà cung cấp mới được thêm thường xuyên.

### Tôi có thể tự lưu trữ Portkey AI Gateway miễn phí không?

Có. Portkey AI Gateway là mã nguồn mở theo giấy phép MIT và hoàn toàn miễn phí để tự lưu trữ. Phiên bản cloud cung cấp các tính năng được quản lý bổ sung như bảng điều khiển web và phân tích nâng cao với định giá dựa trên mức sử dụng.

### Bộ nhớ đệm yêu cầu hoạt động như thế nào?

Portkey cung cấp hai chế độ lưu đệm: **khớp chính xác** (các yêu cầu giống hệt nhau trả về phản hồi được lưu đệm) và **khớp ngữ nghĩa** (các yêu cầu tương tự dựa trên độ tương đồng embedding trả về phản hồi được lưu đệm). Lưu đệm có thể được cấu hình cho mỗi yêu cầu với các tham số TTL và ngưởng độ tương đồng.

### Dữ liệu của tôi có an toàn khi sử dụng Portkey không?

Khi tự lưu trữ, tất cả dữ liệu yêu cầu vẫn ở trong hạ tầng của bạn. Cổng hỗ trợ phát hiện và che PII, lưu trữ khóa API được mã hóa và ghi log kiểm toán. Đối với tùy chọn cloud, Portkey đã đạt chứng nhận SOC 2 Type II và cung cấp Thỏa thuận Liên kết Kinh doanh (BAA) để tuân thủ HIPAA.

### Định tuyến dự phòng xử lý sự cố nhà cung cấp như thế nào?

Định tuyến dự phòng hoạt động bằng cách xác định danh sách ưu tiên các nhà cung cấp. Nếu nhà cung cấp chính gặp sự cố (hết thờ gian, lỗi 5xx, giới hạn tốc độ), cổng sẽ tự động thử lại yêu cầu với nhà cung cấp tiếp theo trong chuỗi. Bạn có thể cấu hình số lần thử lại, thờ gian chờ và điều kiện lỗi cho mỗi mục tiêu.

### Tôi có thể sử dụng Portkey với mã SDK OpenAI hiện có không?

Có. Portkey cung cấp khả năng tương thích thả vào với OpenAI SDK. Đơn giản là thay đổi `base_url` thành điểm cuối gateway của bạn và sử dụng khóa API Portkey:

```python
import openai

client = openai.OpenAI(
    api_key="your-portkey-gateway-key",
    base_url="http://localhost:8787/v1"
)

# Mã hiện có của bạn hoạt động không thay đổi
response = client.chat.completions.create(...)
```

---



## Hosting Và Hạ Tầng Được Đề Xuất

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit $200 trong 60 ngày.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Kết luận

Portkey AI Gateway biến đổi sự phức tạp của việc quản lý nhiều nhà cung cấp LLM thành một vấn đề hạ tầng đã được giải quyết. Với API thống nhất, định tuyến thông minh, lưu đệm ngữ nghĩa, theo dõi chi tiêu và khả năng quan sát toàn diện, bạn có thể tập trung vào xây dựng các ứng dụng AI tuyệt vờ thay vì vật lộn với tích hợp nhà cung cấp.

Dù bạn chọn tùy chọn cloud được quản lý hay tự lưu trữ trên hạ tầng của riêng mình (hãy cân nhắc [DigitalOcean](https://m.do.co/c/eca87ac14ee0) cho việc triển khai Kubernetes đơn giản), Portkey cung cấp độ tin cậy, kiểm soát chi phí và khả năng hiển thị mà các hệ thống AI production đòi hỏi.

Bắt đầu với Docker nhanh chóng, cấu hình các nhà cung cấp của bạn, thiết lập cân bằng tải với các tuyến đường dự phòng, bật lưu đệm và kết nối ngăn xếp quan sát của bạn. Trong vòng chưa đầy một giờ, bạn sẽ có một cổng LLM cấp production xử lý 200+ mô hình với khả năng quan sát đầy đủ.

---

*Xuất bản: 2026-05-19 | Portkey AI Gateway v2.5.0 | [GitHub: Portkey-AI/gateway](https://github.com/Portkey-AI/gateway)*
