---
title: 'Hướng Dẫn LiteLLM 2025: Một API Để Truy Cập 100+ LLM'
description: 'Hướng dẫn chi tiết LiteLLM 2025 — cách dùng một API thống nhất để kết nối 100+ mô hình LLM từ OpenAI, Anthropic, Google, Azure và nguồn mở.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/litellm-unified-api-tutorial/
---

{</* resource-info */>}

Khi doanh nghiệp tích hợp AI vào hệ thống production, một thách thức lớn nảy sinh: mỗi nhà cung cấp LLM — từ OpenAI, Anthropic đến Google hay các mô hình nguồn mở — đều có API riêng, cú pháp riêng, cách xác thực riêng. Việc quản lý hàng chục endpoint khác nhau không chỉ tốn thởi gian phát triển mà còn tạo ra nợ kỹ thuật nghiêm trọng. LiteLLM ra đờii để giải quyết chính vấn đề này. Đây là một gateway mã nguồn mở cho phép bạn gọi hơn 100 mô hình LLM khác nhau thông qua một giao diện API thống nhất — hoàn toàn tương thích với định dạng OpenAI.

## LiteLLM Là Gì Và Tại Sao Nên Sử Dụng?

### Gateway API Đa Năng Cho Mọi LLM

LiteLLM hoạt động như một lớp trung gian giữa ứng dụng của bạn và các nhà cung cấp LLM. Thay vì viết code tích hợp riêng cho từng API, bạn chỉ cần gọi một hàm duy nhất — `completion()` — và LiteLLM sẽ tự động định tuyến request đến đúng provider. Từ góc độ kiến trúc, LiteLLM có hai chế độ hoạt động chính:

- **SDK Mode**: Import thư viện Python và gọi trực tiếp trong code
- **Proxy Server**: Triển khai như một server độc lập với khả năng quản lý key, rate limit, và load balancing

Dự án được phát triển bởi BerriAI, hiện có hơn 12.000 stars trên GitHub và được sử dụng bởi hàng nghìn tổ chức từ startup đến doanh nghiệp lớn [^1^](https://github.com/BerriAI/litellm).

### Những Tính Năng Cốt Lõi

LiteLLM cung cấp bộ tính năng toàn diện giúp đơn giản hóa việc quản lý LLM ở quy mô production:

- **Hơn 100 providers được hỗ trợ** với cùng một định dạng API
- **Router thông minh** tự động chọn model phù hợp dựa trên độ trễ, chi phí, hoặc tính khả dụng
- **Fallback và retry** tự động chuyển sang provider dự phòng khi lỗi
- **Caching tích hợp** giảm chi phí và độ trễ cho các truy vấn lặp lại
- **Streaming support** cho cả SDK và proxy server
- **Function calling** đồng nhất qua nhiều providers khác nhau
- **Unified embedding API** cho các mô hình embedding
- **Quản lý chi tiêu** theo thờii gian thực với dashboard trực quan

## LiteLLM Hỗ Trợ Những Nhà Cung Cấp Nào?

### Các Provider LLM Hàng Đầu

LiteLLM hỗ trợ hầu hết các nhà cung cấp LLM phổ biến trên thị trường:

| Provider | Các Model Tiêu Biểu | Yêu Cầu API Key |
|----------|---------------------|-----------------|
| OpenAI | GPT-4o, GPT-4 Turbo, GPT-3.5 Turbo | `OPENAI_API_KEY` |
| Anthropic | Claude 3.5 Sonnet, Claude 3 Opus | `ANTHROPIC_API_KEY` |
| Google | Gemini 1.5 Pro, Gemini 1.5 Flash | `GEMINI_API_KEY` |
| Azure OpenAI | GPT-4, GPT-4o, Embedding | `AZURE_API_KEY` |
| AWS Bedrock | Claude, Llama, Titan | AWS Credentials |
| Vertex AI | Gemini, Claude trên GCP | GCP Credentials |
| Cohere | Command R+, Embed | `COHERE_API_KEY` |
| Groq | Llama 3, Mixtral (tốc độ cao) | `GROQ_API_KEY` |
| Together AI | Hơn 100 model nguồn mở | `TOGETHER_API_KEY` |

### Mô Hình Nguồn Mở Và Local

Ngoài các dịch vụ cloud, LiteLLM còn hỗ trợ triển khai mô hình local thông qua:

- **Ollama**: Chạy model trên máy cá nhân với API tương thích OpenAI
- **vLLM**: Engine suy luận hiệu suất cao cho mô hình nguồn mở
- **Hugging Face TGI**: Text Generation Inference cho deployment production
- **llama.cpp**: Chạy model quantized trên CPU

## Cài Đặt Và Bắt Đầu Nhanh

### Cài Đặt LiteLLM

Cài đặt LiteLLM cực kỳ đơn giản với pip:

```bash
pip install litellm
```

Với proxy server, bạn cần thêm một số dependencies:

```bash
pip install "litellm[proxy]"
```

### Gọi API Đầu Tiên

Dưới đây là ví dụ gọi Claude 3.5 Sonnet qua LiteLLM với cú pháp OpenAI:

```python
import litellm

response = litellm.completion(
    model="anthropic/claude-3-5-sonnet-20241022",
    messages=[{"role": "user", "content": "Giải thích LiteLLM là gì?"}]
)
print(response.choices[0].message.content)
```

Để chuyển sang GPT-4o, bạn chỉ cần thay đổi một dòng:

```python
model="gpt-4o"  # Thay vì anthropic/claude-3-5-sonnet
```

### Hỗ Trợ Bất Đồng Bộ

LiteLLM cung cấp hàm `acompletion()` cho các ứng dụng async:

```python
import asyncio

async def chat_with_llm():
    response = await litellm.acompletion(
        model="gpt-4o",
        messages=[{"role": "user", "content": "Hello!"}]
    )
    return response
```

## LiteLLM Proxy Server

### Thiết Lập Proxy Server

Proxy server là thành phần mạnh mẽ nhất của LiteLLM, biến nó thành một LLM gateway hoàn chỉnh. Để khởi động proxy [^2^](https://docs.litellm.ai/docs/proxy):

```bash
litellm --config config.yaml
```

### File Cấu Hình Chi Tiết

File `config.yaml` là trái tim của proxy server:

```yaml
model_list:
  - model_name: gpt-4
    litellm_params:
      model: gpt-4
      api_key: os.environ/OPENAI_API_KEY
  
  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-3-5-sonnet-20241022
      api_key: os.environ/ANTHROPIC_API_KEY
  
  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-1.5-pro
      api_key: os.environ/GEMINI_API_KEY

router_settings:
  routing_strategy: simple-shuffle
  num_retries: 3
  timeout: 30

general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL
```

### Quản Lý Virtual Key

LiteLLM proxy cho phép tạo virtual keys — những API key nội bộ có quyền hạn và ngân sách riêng:

```bash
curl -X POST 'http://localhost:4000/key/generate' \
  -H 'Authorization: Bearer sk-master-123' \
  -H 'Content-Type: application/json' \
  -d '{
    "models": ["gpt-4", "claude-sonnet"],
    "max_budget": 50.00,
    "duration": "30d"
  }'
```

### Rate Limiting Và Kiểm Soát Ngân Sách

Bạn có thể đặt giới hạn cho từng key hoặc từng team:

- **Rate limits**: TPM (tokens per minute), RPM (requests per minute)
- **Budget controls**: Giới hạn chi tiêu hàng ngày, hàng tháng
- **Model access**: Giới hạn model nào mỗi key có thể gọi

### Load Balancing Giữa Các Providers

LiteLLM hỗ trợ nhiều chiến lược routing:

- **Simple Shuffle**: Phân phối đều giữa các model
- **Least Busy**: Gửi đến model có ít request nhất
- **Lowest Latency**: Tự động chọn model phản hồi nhanh nhất
- **Lowest Cost**: Ưu tiên model có giá rẻ nhất

## Tính Năng Nâng Cao

### Router Thông Minh

Router của LiteLLM có khả năng tự động chọn model dựa trên nhiều tiêu chí. Ví dụ cấu hình routing theo chi phí:

```yaml
router_settings:
  routing_strategy: lowest-cost
  fallback_strategy: ["gpt-3.5-turbo", "claude-haiku"]
```

### Fallback Và Retry Tự Động

Khi một provider gặp lỗi hoặc quá tải, LiteLLM tự động chuyển sang provider dự phòng:

```yaml
model_list:
  - model_name: production-llm
    litellm_params:
      model: gpt-4
    fallback: ["anthropic/claude-3-opus", "gemini/gemini-1.5-pro"]
```

### Caching Phản Hồi

LiteLLM hỗ trợ caching qua Redis hoặc in-memory để giảm chi phí cho các truy vấn lặp lại [^3^](https://docs.litellm.ai):

```yaml
cache: true
cache_params:
  type: redis
  host: localhost
  port: 6379
```

### Function Calling Đồng Nhất

Một trong những thách thức lớn nhất khi làm việc với nhiều LLM là mỗi model có cú pháp function calling khác nhau. LiteLLM tự động chuyển đổi giữa các định dạng, cho phép bạn viết một lần và chạy ở mọi nơi.

### Unified Embedding API

```python
response = litellm.embedding(
    model="text-embedding-3-large",
    input=["LiteLLM là một công cụ tuyệt vời"]
)
```

Chỉ cần thay đổi tên model để chuyển sang Cohere, Azure, hoặc bất kỳ provider embedding nào.

## Tích Hợp Với LangChain Và LlamaIndex

### Sử Dụng LiteLLM Với LangChain

LiteLLM có thể hoạt động như một drop-in replacement cho model trong LangChain [^4^](https://python.langchain.com):

```python
from langchain_community.chat_models import ChatLiteLLM

llm = ChatLiteLLM(model="gpt-4o")
result = llm.predict("Giải thích khái niệm RAG")
```

### Sử Dụng LiteLLM Với LlamaIndex

```python
from llama_index.llms.litellm import LiteLLM

llm = LiteLLM(model="anthropic/claude-3-5-sonnet")
```

### Mẫu Thay Thế Drop-in

Điểm mạnh của LiteLLM là bạn có thể thay đổi model mà không cần sửa code ứng dụng. Chỉ cần cập nhật file config hoặc biến môi trường, toàn bộ hệ thống sẽ tự động chuyển sang model mới.

## Tính Năng Doanh Nghiệp

### Quản Lý Ngườii Dùng Và RBAC

LiteLLM cung cấp hệ thống phân quyền chi tiết:

- **Internal users**: Ngườii dùng nội bộ với các quyền khác nhau
- **Teams**: Nhóm ngườii dùng với ngân sách chung
- **RBAC**: Role-based access control cho từng tính năng

### Theo Dõi Chi Tiêu

Dashboard của LiteLLM cho phép theo dõi chi tiêu theo thờii gian thực:

- Chi tiêu theo key, theo team, theo model
- Cảnh báo khi vượt ngân sách
- Dự đoán chi phí dựa trên lịch sử sử dụng

### Logging Và Observability

LiteLLM tích hợp với nhiều dịch vụ logging:

- **LangSmith**: Theo dõi request/response
- **Langfuse**: Open-source observability
- **Helicone**: Logging và analytics
- **PromptLayer**: Quản lý prompt

### Triển Khai Tự Chủ

LiteLLM có thể được triển khai on-premises hoặc trên private cloud, đảm bảo dữ liệu không rờii khỏi hệ thống của bạn. Hỗ trợ SSO thông qua OAuth2, SAML, và OIDC.

## Chiến Lược Tối Ưu Chi Phí

### Định Tuyến Đến Provider Rẻ Nhất

Với chiến lược `lowest-cost`, LiteLLM tự động chọn provider có giá tốt nhất cho mỗi request:

| Model | OpenAI | Azure | Groq | Tiết Kiệm |
|-------|--------|-------|------|-----------|
| GPT-4o | $5.00/M | $5.00/M | — | — |
| Llama 3 70B | — | — | $0.89/M | ~82% |
| Mixtral 8x7B | — | — | $0.90/M | vs $2.00/M |

### Sử Dụng Mô Hình Nguồn Mở

LiteLLM giúp chuyển đổi sang mô hình nguồn mở dễ dàng hơn bao giờ hết. Bạn có thể bắt đầu với GPT-4 cho prototyping, sau đó chuyển sang Llama 3 hoặc Mixtral cho production mà không cần sửa code.

### Caching Các Truy Vấn Thường Gặp

Theo số liệu từ LiteLLM, caching có thể giảm 30-50% chi phí cho các ứng dụng có nhiều truy vấn lặp lại như FAQ chatbot.

## So Sánh LiteLLM Với Các Giải Pháp Khác

### LiteLLM So Với Tích Hợp Trực Tiếp

| Tiêu Chí | Tích Hợp Trực Tiếp | LiteLLM |
|----------|---------------------|---------|
| Số dòng code | N × providers | 1 × providers |
| Chuyển đổi model | Sửa code | Thay config |
| Fallback | Tự xây dựng | Tích hợp sẵn |
| Monitoring | Tự xây dựng | Dashboard có sẵn |
| Quản lý chi phí | Tự tính toán | Theo dõi real-time |

### LiteLLM So Với Portkey

Portkey là một LLM gateway khác nhưng tập trung nhiều hơn vào reliability và observability. LiteLLM có lợi thế ở số lượng provider hỗ trợ (100+ so với ~20) và khả năng tự chủ hoàn toàn (mã nguồn mở).

### LiteLLM So Với LangChain Model Abstraction

LangChain cung cấp abstraction cho model nhưng không có proxy server với rate limit, budget control, và virtual key management như LiteLLM. Thực tế, nhiều team sử dụng cả hai: LiteLLM làm gateway và LangChain làm framework phát triển.

## Hướng Dẫn Triển Khai Production

### Triển Khai Docker

```dockerfile
FROM ghcr.io/berriai/litellm:main-latest
COPY config.yaml /app/config.yaml
CMD ["--config", "/app/config.yaml", "--port", "4000"]
```

### Kubernetes Helm Chart

LiteLLM cung cấp Helm chart chính thức cho triển khai Kubernetes:

```bash
helm repo add litellm https://berriai.github.io/litellm
helm install litellm litellm/litellm -f values.yaml
```

### Giám Sát Và Cảnh Báo

Nên tích hợp Prometheus và Grafana để giám sát:

- Request rate và latency
- Error rate theo provider
- Chi phí theo thờii gian thực
- Token usage patterns

### Các Phương Pháp Bảo Mật Tốt Nhất

- Không bao giờ lưu API key trong code, sử dụng biến môi trường
- Sử dụng virtual keys thay vì master key trực tiếp
- Bật audit logging cho mọi request
- Giới hạn model access theo từng key
- Thiết lập budget alerts để phát hiện sử dụng bất thường

## Kết Luận

LiteLLM đã trở thành một thành phần không thể thiếu trong hệ sinh thái AI hiện đại. Với khả năng thống nhất hơn 100 providers LLM qua một API duy nhất, LiteLLM giúp team phát triển tiết kiệm hàng trăm giờ làm việc, đồng thờii cung cấp các tính năng enterprise như rate limiting, budget control, và observability [^5^](https://platform.openai.com).

Cho dù bạn đang xây dựng prototype hay vận hành hệ thống production xử lý hàng triệu request mỗi ngày, LiteLLM đều có thể đáp ứng. Bắt đầu với SDK mode cho development, sau đó chuyển sang proxy server khi cần quản lý nhiều team và môi trường.

## Câu Hỏi Thường Gặp

### LiteLLM Có Miễn Phí Không?

LiteLLM có phiên bản mã nguồn mở hoàn toàn miễn phí với đầy đủ tính năng SDK và proxy cơ bản. LiteLLM Enterprise cung cấp thêm SSO, RBAC nâng cao, và hỗ trợ chuyên nghiệp với giá từ $250/tháng.

### LiteLLM Hỗ Trợ Những Nhà Cung Cấp LLM Nào?

LiteLLM hỗ trợ hơn 100 nhà cung cấp bao gồm OpenAI, Anthropic, Google (Gemini), Azure OpenAI, AWS Bedrock, Vertex AI, Cohere, Groq, Together AI, cùng với các mô hình local qua Ollama, vLLM, và Hugging Face.

### LiteLLM Quản Lý API Key Như Thế Nào?

LiteLLM proxy cho phép tạo virtual keys với quyền hạn riêng. Bạn lưu API key của providers trong config hoặc biến môi trường, sau đó cấp virtual key cho ngườii dùng cuối. Mỗi virtual key có thể có giới hạn model, rate limit, và ngân sách riêng.

### LiteLLm Có Làm Việc Với Mô Hình Tự Host Không?

Hoàn toàn có. LiteLLM hỗ trợ Ollama, vLLM, llama.cpp, Hugging Face TGI và bất kỳ server nào cung cấp API tương thích OpenAI. Bạn chỉ cần cấu hình base URL trong file config.

### Sự Khác Biệt Giữa LiteLLM SDK Và Proxy Là Gì?

**SDK** là thư viện Python import vào code ứng dụng, phù hợp cho development và ứng dụng đơn giản. **Proxy Server** là một server độc lập cung cấp API endpoint, phù hợp cho production với khả năng quản lý nhiều keys, rate limiting, load balancing, và monitoring tập trung.

---

## Hạ Tầng Đề Xuất

Để chạy các công cụ trên 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp. dibi8.com cũng host ở đây.
- **[Hostinger](https://www.hostinger.com/vn?REFERRALCODE=22RPIAOJIYJN)** — VPS giá tốt cho thị trường Việt Nam.

*Đây là affiliate link, không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

