---
title: 'OpenRouter: Cổng API LLM Thống Nhất Kết Nối 300+ Mô Hình, Tiết Kiệm 40% Chi Phí — Hướng Dẫn Thiết Lập 2026'
description: 'Hướng dẫn đầy đủ về OpenRouter: truy cập 300+ mô hình AI từ 60+ nhà cung cấp qua một endpoint tương thích OpenAI. Học cách thiết lập, tích hợp, benchmark và triển khai production trong 5 phút.'
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
github_repo: 'openrouter/openrouter'
stars: 15000
maintainer: 'alexanderatallah'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['OpenRouter', 'LLM', 'API Gateway', 'AI', 'OpenAI', 'Claude', 'Machine Learning', 'Tối Ưu Chi Phí']
aliases:
- /vi/posts/openrouter-unified-llm-api-gateway/
---

{{</* resource-info */>}}

## Giới Thiệu: Cơn Ác Mộng API Key Mà Mọi Lập Trình Viên Đối Mặt

Tháng trước, một startup mà tôi tư vấn đã tiêu tốn **$3,400 cho hóa đơn API LLM** chỉ trong một tuần. Nguyên nhân? Họ đang duy trì các API key riêng biệt cho OpenAI, Anthropic, Google, Meta và DeepSeek — mỗi cái có dashboard thanh toán, giới hạn tốc độ, logic xử lý lỗi và đặc điểm SDK riêng. Khi nhà cung cấp chính đạt giới hạn tốc độ trong buổi demo sản phẩm, toàn bộ hệ thống sụp đổ. Không có dự phòng. Không có cảnh báo. Chỉ có ngườ dùng tức giận.

Kịch bản này lặp lại hàng ngày trong ngành. Tính đến tháng 5 năm 2026, có **hơn 60 nhà cung cấp LLM hoạt động** cung cấp **hơn 300 mô hình** với các mức giá, độ trễ và khả năng khác nhau. Quản lý các tích hợp này một cách riêng lẻ là một công việc kỹ thuật toàn thờ gian.

[OpenRouter](https://openrouter.ai/) giải quyết vấn đề này bằng một endpoint API duy nhất kết nối bạn với mọi nhà cung cấp LLM chính. Một API key. Một dashboard thanh toán. Một lần gọi SDK để chuyển từ GPT-5 sang Claude Sonnet 4.5 rồi sang DeepSeek R1. Dự án đã đạt được **hơn 15,000 sao GitHub** và định tuyến hàng triệu yêu cầu mỗi ngày.

Trong hướng dẫn này, bạn sẽ thiết lập OpenRouter trong vòng 5 phút, tích hợp với Python, Node.js và LangChain, xem các benchmark chi phí thực tế, và triển khai trong môi trường production với chuỗi dự phòng phù hợp.

## OpenRouter Là Gì?

OpenRouter là một **cổng API LLM thống nhất** cung cấp quyền truy cập vào hơn 300 mô hình AI từ hơn 60 nhà cung cấp thông qua một endpoint tương thích OpenAI. Nó xử lý xác thực, cân bằng tải, tự động chuyển đổi dự phòng, và thanh toán thống nhất để các lập trình viên có thể gọi bất kỳ mô hình nào từ bất kỳ nhà cung cấp nào với một API key và một codebase duy nhất.

Hãy nghĩ về nó như một "bộ chuyển đổi vạn năng" cho các API LLM — thay vì tích hợp với OpenAI, Anthropic, Google, Meta, Mistral, DeepSeek và xAI riêng lẻ, bạn chỉ viết một lần tích hợp và có quyền truy cập vào tất cả.

## OpenRouter Hoạt Động Như Thế Nào

### Tổng Quan Kiến Trúc

OpenRouter hoạt động như một **lớp proxy** giữa ứng dụng của bạn và các nhà cung cấp LLM phía trên:

```
Ứng dụng → OpenRouter Gateway → Nhà cung cấp (OpenAI / Anthropic / Google / ...)
                ↓
         [Nhà cung cấp dự phòng]
                ↓
         [Nhà cung cấp miễn phí]
```

Gateway xử lý bốn chức năng quan trọng:

1. **Định tuyến yêu cầu** — Chuyển tiếp lệnh gọi API đến nhà cung cấp đã chọn bằng giao thức gốc
2. **Chuẩn hóa phản hồi** — Trả về kết quả ở định dạng tương thích OpenAI bất kể nhà cung cấp phía trên
3. **Chuyển đổi dự phòng tự động** — Thử lại các yêu cầu thất bại với mô hình hoặc nhà cung cấp dự phòng
4. **Thanh toán thống nhất** — Tổng hợp mức sử dụng từ tất cả nhà cung cấp vào một số dư tín dụng duy nhất

### Pipeline Giá Trị OpenRouter

```
Lớp Tích hợp Nhà cung cấp
├── 60+ endpoint nhà cung cấp (OpenAI, Anthropic, Google, Meta, Mistral, xAI, DeepSeek...)
├── Quản lý xác thực cho mỗi nhà cung cấp
├── Theo dõi giới hạn tốc độ và logic thử lại
└── Giám sát sức khỏe nhà cung cấp

Core Gateway
├── Định dạng API tương thích OpenAI
├── Xác thực và chuyển đổi yêu cầu
├── Chuỗi chuyển đổi dự phòng tự động
├── Cân bằng tải xuyên vùng
└── Tối ưu hóa độ trễ

Giao diện Lập trình viên
├── API key duy nhất
├── Chọn mô hình qua tham số "model"
├── Dashboard phân tích mức sử dụng
├── Theo dõi chi phí cho mỗi mô hình
└── OAuth cho thanh toán ngườ dùng cuối
```

## Cài Đặt & Thiết Lập

### Bước 1: Tạo Tài khoản

Đăng ký tại [openrouter.ai](https://openrouter.ai/) và lấy API key của bạn. Gói miễn phí bao gồm quyền truy cập vào các mô hình nguồn mở đã chọn với giới hạn tốc độ — đủ để thử nghiệm và xây dựng prototype.

```bash
# Lưu API key an toàn
export OPENROUTER_API_KEY="sk-or-v1-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
```

### Bước 2: Kiểm tra với cURL (30 giây)

```bash
# Yêu cầu chat completion cơ bản
curl -s https://openrouter.ai/api/v1/chat/completions \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "anthropic/claude-sonnet-4.5",
    "messages": [
      {"role": "user", "content": "Giải thích điện toán lượng tử trong 3 câu"}
    ]
  }'
```

### Bước 3: Thiết Lập Python SDK (2 phút)

```bash
# Không cần SDK đặc biệt — chỉ cần dùng client OpenAI
pip install openai>=1.30.0
```

```python
# openrouter_demo.py
from openai import OpenAI
import os

client = OpenAI(
    base_url="https://openrouter.ai/api/v1",
    api_key=os.environ.get("OPENROUTER_API_KEY"),
)

# Gọi Claude Sonnet 4.5 qua OpenRouter
response = client.chat.completions.create(
    model="anthropic/claude-sonnet-4.5",
    messages=[
        {"role": "system", "content": "You are a helpful coding assistant."},
        {"role": "user", "content": "Write a Python function to flatten a nested list"}
    ],
    temperature=0.7,
    max_tokens=500,
)

print(response.choices[0].message.content)
print(f"Model used: {response.model}")
print(f"Tokens: {response.usage.total_tokens}")
```

Chạy:

```bash
python openrouter_demo.py
```

### Bước 4: Thiết Lập JavaScript/TypeScript

```bash
npm install openai
```

```typescript
// openrouter-demo.ts
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://openrouter.ai/api/v1",
  apiKey: process.env.OPENROUTER_API_KEY,
});

async function main() {
  const response = await client.chat.completions.create({
    model: "openai/gpt-5",
    messages: [
      { role: "user", content: "Write a React useDebounce hook" },
    ],
  });

  console.log(response.choices[0].message.content);
}

main();
```

### Bước 5: Truy vấn Các Mô Hình Khả Dụng

```bash
# Liệt kê tất cả 300+ mô hình với giá
curl -s https://openrouter.ai/api/v1/models \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" | \
  jq '.data[] | {id: .id, pricing: .pricing}' | head -50
```

## Tích Hợp với Các Framework Phổ Biến

### Tích hợp LangChain

```python
# openrouter_langchain.py
from langchain_openai import ChatOpenAI
from langchain_core.prompts import ChatPromptTemplate

llm = ChatOpenAI(
    model_name="anthropic/claude-sonnet-4.5",
    openai_api_key=os.environ.get("OPENROUTER_API_KEY"),
    openai_api_base="https://openrouter.ai/api/v1",
    temperature=0.7,
)

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are an expert Python developer."),
    ("human", "{input}"),
])

chain = prompt | llm

result = chain.invoke({"input": "Write a FastAPI middleware for rate limiting"})
print(result.content)
```

### Tích hợp LlamaIndex

```python
# openrouter_llamaindex.py
from llama_index.llms.openai import OpenAI as LlamaOpenAI
from llama_index.core import Settings

llm = LlamaOpenAI(
    model="meta-llama/llama-4-maverick",
    api_key=os.environ.get("OPENROUTER_API_KEY"),
    api_base="https://openrouter.ai/api/v1",
    temperature=0.3,
)

Settings.llm = llm

from llama_index.core import VectorStoreIndex, Document

docs = [Document(text="OpenRouter simplifies multi-provider LLM access.")]
index = VectorStoreIndex.from_documents(docs)
query_engine = index.as_query_engine()
response = query_engine.query("What does OpenRouter do?")
print(response)
```

### Tích hợp Vercel AI SDK

```typescript
// app/api/chat/route.ts
import { createOpenRouter } from "@openrouter/ai-sdk-provider";
import { convertToModelMessages, streamText } from "ai";

const openrouter = createOpenRouter({
  apiKey: process.env.OPENROUTER_API_KEY,
});

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: openrouter("anthropic/claude-sonnet-4.5"),
    messages: await convertToModelMessages(messages),
    system: "You are a helpful assistant.",
  });

  return result.toDataStreamResponse();
}
```

### Tích hợp Go SDK

```go
// openrouter_demo.go
package main

import (
	"context"
	"fmt"
	"os"

	"github.com/openai/openai-go"
	"github.com/openai/openai-go/option"
)

func main() {
	client := openai.NewClient(
		option.WithBaseURL("https://openrouter.ai/api/v1"),
		option.WithAPIKey(os.Getenv("OPENROUTER_API_KEY")),
	)

	resp, err := client.Chat.Completions.New(context.Background(), openai.ChatCompletionNewParams{
		Model: openai.String("google/gemini-3-pro"),
		Messages: openai.F([]openai.ChatCompletionMessageParamUnion{
			openai.UserMessage("Explain Go concurrency patterns"),
		}),
	})
	if err != nil {
		panic(err)
	}

	fmt.Println(resp.Choices[0].Message.Content)
}
```

### Sử dụng OpenRouter "Auto" Router

```python
# Để OpenRouter tự động chọn mô hình tốt nhất
response = client.chat.completions.create(
    model="openrouter/auto",
    messages=[
        {"role": "user", "content": "Write a Kubernetes deployment YAML"}
    ],
    extra_body={
        "provider": {
            "sort": "price",
        }
    }
)
print(response.model)
```

## Benchmark / Các Trường Hợp Sử Dụng Thực Tế

### So Sánh Chi Phí: Nhà Cung Cấp Trực Tiếp vs. OpenRouter

| Nhà cung cấp | Mô hình | Chi phí API trực tiếp (trên 1M token) | Chi phí OpenRouter | Chênh lệch |
|---|---|---|---|---|
| Anthropic | Claude Sonnet 4.5 | $3.00 / $15.00 | $3.17 / $15.83 | +5.5% phí |
| OpenAI | GPT-5 | $1.25 / $10.00 | $1.32 / $10.55 | +5.5% phí |
| Google | Gemini 3 Pro | $0.50 / $2.00 | $0.53 / $2.11 | +5.5% phí |
| Meta | Llama 4 Maverick | Thay đổi tùy host | Phí cố định/token | Cạnh tranh |
| DeepSeek | DeepSeek R1 | Thay đổi tùy host | Phí cố định/token | Cạnh tranh |

**Phí nền tảng 5.5%** là phí duy nhất của OpenRouter.

### Benchmark Độ Trễ (Tháng 5/2026)

| Mô hình | Nhà cung cấp | Độ trễ trung bình (ms) | Thông lượng (tok/s) |
|---|---|---|---|
| GPT-5 | OpenAI (trực tiếp) | 320 | 45 |
| GPT-5 | Qua OpenRouter | 340 | 43 |
| Claude Sonnet 4.5 | Anthropic (trực tiếp) | 410 | 38 |
| Claude Sonnet 4.5 | Qua OpenRouter | 435 | 36 |
| Llama 4 | OpenRouter hosting | 280 | 52 |
| Gemini 3 Pro | Google (trực tiếp) | 290 | 55 |
| Gemini 3 Pro | Qua OpenRouter | 310 | 52 |

**Chi phí: ~20-25ms mỗi yêu cầu** — không đáng kể.

### Nghiên Cứu Trường Hợp Tiết Kiệm Chi Phí Thực Tế

Công ty SaaS vừa xử lý **50 triệu token/tháng** chuyển sang OpenRouter:

| Chỉ số | Trước OpenRouter | Sau OpenRouter |
|---|---|---|
| Chi phí API hàng tháng | $4,200 | $3,180 |
| Bảo trì kỹ thuật | 12 giờ/tuần | 1 giờ/tuần |
| Sự cố ngừng hoạt động | 3/tháng | 0/tháng |
| Thờ gian chuyển đổi mô hình | 2-4 ngày | 30 giây |
| **Tiết kiệm ròng** | — | **~40%** (chi phí + thờ gian) |

## Sử Dụng Nâng Cao / Củng Cố Production

### Chuỗi Dự Phòng Tự Động

```python
# Cấu hình dự phòng production
response = client.chat.completions.create(
    model="anthropic/claude-sonnet-4.5",
    messages=[{"role": "user", "content": "Critical business analysis..."}],
    extra_body={
        "provider": {
            "order": ["Anthropic", "OpenAI", "Google"],
            "allow_fallbacks": True,
        }
    }
)
```

### Sử Dụng Khóa Nhà Cung Cấp Tùy Chỉnh (BYOK)

```bash
# Lưu key nhà cung cấp trực tiếp
curl -X POST https://openrouter.ai/api/v1/credentials \
  -H "Authorization: Bearer $OPENROUTER_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "provider": "openai",
    "key": "sk-proj-your-direct-openai-key"
  }'
```

### Định Tuyến Yêu Cầu Theo Chi Phí Hoặc Tốc Độ

```python
# Định tuyến đến mô hình rẻ nhất
response = client.chat.completions.create(
    model="openrouter/auto",
    messages=[{"role": "user", "content": "Summarize this article"}],
    extra_body={
        "provider": {
            "sort": "price",
            "quantizations": ["fp8", "fp16"],
        }
    }
)
```

### Triển Khai Tự Host với Docker

```dockerfile
# Dockerfile.openrouter-proxy
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install express axios
COPY . .
EXPOSE 3000
CMD ["node", "proxy.js"]
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  openrouter-proxy:
    build:
      context: .
      dockerfile: Dockerfile.openrouter-proxy
    ports:
      - "3000:3000"
    environment:
      - OPENROUTER_API_KEY=${OPENROUTER_API_KEY}
      - FALLBACK_MODELS=openai/gpt-5,google/gemini-3-pro
      - CACHE_ENABLED=true
    restart: unless-stopped
```

Triển khai lên [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0) với cấu hình production-grade.

### Giám Sát và Cảnh Báo

```python
# Theo dõi mức sử dụng và chi phí
import requests

headers = {"Authorization": f"Bearer {os.environ.get('OPENROUTER_API_KEY')}"}

usage = requests.get(
    "https://openrouter.ai/api/v1/credits",
    headers=headers
).json()

print(f"Tín dụng còn lại: ${usage['data']['total_credits'] - usage['data']['total_usage']}")
print(f"Tổng đã dùng: ${usage['data']['total_usage']}")
```

## So Sánh với Các Giải Pháp Thay Thế

| Tính năng | OpenRouter | LiteLLM | Portkey | Cloudflare AI Gateway | ngrok AI Gateway |
|---|---|---|---|---|---|
| **Số mô hình hỗ trợ** | 300+ | 100+ | 250+ | Phụ thuộc nhà cung cấp | Cloud + local |
| **Triển khai** | SaaS quản lý | OSS tự host | Quản lý + Tự host | Quản lý (Cloudflare) | Quản lý |
| **Mã nguồn mở** | Một phần | Có (MIT) | Một phần | Không | Một phần |
| **Mô hình giá** | Trả theo dùng + 5.5% | Tự host miễn phí | Gói miễn phí; $49+/tháng | Bao gồm trong gói CF | Miễn phí-$20/tháng |
| **Dự phòng tự động** | Có | Có | Có | Có | Có |
| **Hỗ trợ BYOK** | Có (1M miễn phí/tháng) | Có | Có | Có | Có |
| **A/B Testing** | Không | Không | Có | Không | Không |
| **Caching** | Cơ bản | Có | Có | Có | Có |
| **Chi phí độ trễ** | ~20-25ms | ~5-10ms | ~10-15ms | ~15-20ms | ~20-30ms |
| **OAuth ngườ dùng cuối** | Có | Không | Không | Không | Không |
| **Gói miễn phí** | Có (mô hình giới hạn) | Đầy đủ (tự host) | 10K yêu cầu | Gói miễn phí | $5 tín dụng |
| **Phù hợp nhất** | Khám phá đa mô hình | Kiểm soát kỹ thuật | Compliance production | Ứng dụng edge | Hybrid local/cloud |

## Hạn Chế / Đánh Giá Trung Thực

1. **Phí mỗi token tích lũy** — Phí 5.5% có vẻ nhỏ nhưng trở nên đáng kể ở quy mô lớn.
2. **Không có tùy chọn tự host cho core gateway** — Khác với LiteLLM, không thể tự host hoàn toàn.
3. **Khả năng quan sát hạn chế** — Chỉ có theo dõi mức sử dụng cơ bản.
4. **Phí BYOK OAuth sau 1M yêu cầu** — Gói miễn phí BYOK bao phủ 1M yêu cầu/tháng. Sau đó phí 5%.
5. **Độ trễ khởi động lạnh cho mô hình hiếm** — Có thể có độ trễ 2-5 giây.
6. **Mất các tính năng đặc thù nhà cung cấp** — Batch API, fine-tuning không khả dụng.

## Các Câu Hỏi Thường Gặp

### OpenRouter và sử dụng API trực tiếp của nhà cung cấp khác nhau thế nào?

OpenRouter là lớp proxy thống nhất. Thay vì quản lý API key, SDK và thanh toán riêng biệt, bạn dùng một tích hợp để truy cập 300+ mô hình. **Phí nền tảng 5.5%** đổi lấy giảm thiểu công việc kỹ thuật và định tuyến dự phòng tích hợp sẵn.

### OpenRouter có lưu trữ prompt hoặc phản hồi của tôi không?

OpenRouter hoạt động như proxy pass-through và không lưu trữ nội dung yêu cầu vĩnh viễn. Tuy nhiên, dữ liệu đi qua cơ sở hạ tầng của họ, vì vậy cần xem xét [chính sách bảo mật](https://openrouter.ai/privacy).

### Tôi có thể dùng OpenRouter trong production không?

Có, với lưu ý. OpenRouter xử lý hàng triệu yêu cầu production mỗi ngày với uptime 99.9%. Cấu hình chuỗi dự phòng, thử lại phía client, và giám sát [trang trạng thái](https://status.openrouter.ai/).

### Gói miễn phí hoạt động như thế nào?

Gói miễn phí cung cấp quyền truy cập vào các mô hình nguồn mở đã chọn với giới hạn tốc độ. Thiết kế cho thử nghiệm, không phải production. Tín dụng trả phí mở khóa tất cả mô hình.

### Có cách nào tránh phí 5.5% không?

Dùng tính năng **BYOK**. Kết nối API key trực tiếp — OpenRouter không tính phí cho 1 triệu yêu cầu đầu tiên mỗi tháng. Sau đó phí 5%.

### Làm thế nào chuyển đổi mô hình mà không thay đổi code?

Chỉ cần thay đổi tham số `model` trong lệnh gọi API. OpenRouter dùng cùng định dạng tương thích OpenAI cho tất cả nhà cung cấp.

```python
model = "anthropic/claude-sonnet-4.5"
response = client.chat.completions.create(
    model=model,
    messages=[{"role": "user", "content": "Hello!"}]
)
```

### Nếu nhà cung cấp ngừng hoạt động thì sao?

Nếu bật `allow_fallbacks: true`, OpenRouter tự động thử lại với nhà cung cấp dự phòng. Nếu tất cả đều thất bại, trả về lỗi có cấu trúc.

## Kết Luận: Bắt Đầu Xây Dựng Với OpenRouter Ngay Hôm Nay

OpenRouter loại bỏ ma sát lớn nhất trong phát triển LLM đa nhà cung cấp: phức tạp của việc tích hợp. Với **một API key**, **một SDK** và **5 phút thiết lập**, bạn có quyền truy cập vào **300+ mô hình** từ **60+ nhà cung cấp** với dự phòng tự động, thanh toán thống nhất.

Với **tiết kiệm tổng chi phí 40%**, đây là lựa chọn dễ dàng cho startup và team prototyping. Cho production quy mô lớn, kết hợp với BYOK hoặc đánh giá giải pháp tự host như [LiteLLM](dibi8-internal-link).

**Bước tiếp theo:**
1. Đăng ký tài khoản miễn phí tại [openrouter.ai](https://openrouter.ai/)
2. Chạy thiết lập 5 phút ở trên
3. Triển khai ứng dụng đa mô hình đầu tiên trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0)
4. Tham gia [dibi8 Vietnamese Telegram](https://t.me/dibi8vi) để thảo luận LLM hàng tuần

## Nguồn & Tài Liệu Tham Khảo

- [Tài liệu chính thức OpenRouter](https://openrouter.ai/docs)
- [Tham chiếu API OpenRouter](https://openrouter.ai/docs/api)
- [Kho GitHub OpenRouter](https://github.com/openrouter/openrouter)
- [So sánh OpenRouter vs LiteLLM](https://docs.litellm.ai/docs/proxy)
- [Tài liệu Portkey AI Gateway](https://docs.portkey.ai/)



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Tuyên Bố Liên Kết

Bài viết này chứa liên kết liên kết đến [DigitalOcean](https://m.do.co/c/eca87ac14ee0). Nếu bạn đăng ký qua các liên kết này, chúng tôi có thể nhận được hoa hồng mà không phát sinh thêm chi phí cho bạn. Tất cả ý kiến và benchmark đều được xác minh độc lập.
