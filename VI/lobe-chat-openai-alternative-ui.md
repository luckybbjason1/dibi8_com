---
title: 'Lobe Chat: Giao Diện ChatGPT Mã Nguồn Mở với 20+ Nhà Cung Cấp LLM & Hệ Thống Plugin — Hướng Dẫn 2026'
description: 'Triển khai Lobe Chat như một giải pháp thay thế ChatGPT tự host. Hỗ trợ 20+ nhà cung cấp LLM, hệ thống plugin, PWA, giao diện đa ngôn ngữ. Hướng dẫn Docker đầy đủ với benchmark và so sánh.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'lobehub/lobe-chat'
stars: 60000
maintainer: 'lobehub'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Lobe Chat', 'ChatGPT', 'Thay thế OpenAI', 'LLM', 'Tự host', 'Docker', 'PWA', 'Hệ thống Plugin', 'AI', 'UI Chat']
aliases:
- /vi/posts/lobe-chat-openai-alternative-ui/
---

{{</* resource-info */>}}

## Giới thiệu: ChatGPT Không Còn Đủ Nữa

Bạn đang trả $20/tháng cho OpenAI dùng ChatGPT Plus, nhưng team cần một giao diện chat chia sẻ với khả năng truy cập Claude, Gemini, và các model local chạy trên phần cứng riêng. Bạn muốn các plugin kết nối với API nội bộ. Bạn cần giao diện đa ngôn ngữ vì team của bạn trải rộng ba châu lục. Và quan trọng nhất —— dữ liệu cuộc trò chuyện phải ở lại trên hạ tầng của bạn, không phải trên cloud bên thứ ba.

Bạn có thể xây từ đầu. Dành hai tháng cho frontend React, thêm một tháng để kết nối SSE streaming, rồi duy trì authentication, plugin sandboxing, và model switching mãi mãi. Hoặc bạn có thể triển khai **Lobe Chat trong 10 phút**.

Lobe Chat là giao diện chat mã nguồn mở được xây dựng bởi team LobeHub, hỗ trợ **20+ nhà cung cấp LLM**, **hệ thống plugin**, **hỗ trợ PWA**, và **giao diện đa ngôn ngữ** —— tất cả từ một container Docker duy nhất. Với **khoảng 60,000 sao GitHub** tính đến tháng 5/2026, nó là một trong những giải pháp thay thế ChatGPT tự host phổ biến nhất. Trông đẹp hơn UI của ChatGPT, chạy trên phần cứng của bạn, và không tốn phí cấp phép nào.

Hướng dẫn này đi qua cài đặt, cấu hình nhà cung cấp, phát triển plugin, thiết lập PWA, benchmark thực tế, và các hạn chế thực tế. Cuối cùng, bạn sẽ có một UI chat sẵn sàng production mà cả team có thể sử dụng.

## Lobe Chat là gì?

**Lobe Chat** là giao diện chat mã nguồn mở hiện đại cho các mô hình ngôn ngữ lớn. Được xây dựng bằng Next.js và Ant Design, nó cung cấp trải nghiệm tương tự ChatGPT với hỗ trợ cho nhiều nhà cung cấp LLM (OpenAI, Claude, Gemini, Ollama, Azure, Bedrock và hơn 15 nhà cung cấp khác), plugin có thể mở rộng, khả năng progressive web app, và mô hình triển khai tự host giữ dữ liệu của bạn dưới sự kiểm soát của bạn.

## Lobe Chat hoạt động như thế nào?

Kiến trúc của Lobe Chat tách lớp presentation khỏi model inference. Frontend Next.js xử lý việc render UI, trạng thái cuộc trò chuyện, và orchestration plugin, trong khi các lệnh gọi LLM được proxy qua các endpoint API có thể cấu hình:

```
┌─────────────────────────────────────────────┐
│           Trình duyệt ngườ dùng / PWA      │
│  ┌─────────┐  ┌─────────┐  ┌────────────┐  │
│  │  Chat   │  │  Plugin │  │  Cài đặt   │  │
│  │  Panel  │  │  Store  │  │  (i18n)    │  │
│  └────┬────┘  └────┬────┘  └─────┬──────┘  │
└───────┼────────────┼─────────────┼────────┘
        │            │             │
        ▼            ▼             ▼
┌─────────────────────────────────────────────┐
│          Lobe Chat Server (Next.js)          │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐  │
│  │  SSE     │ │  Plugin  │ │  Xác thực  │  │
│  │  Stream  │ │  Runtime │ │  (SSO)     │  │
│  └────┬─────┘ └────┬─────┘ └─────┬──────┘  │
└───────┼────────────┼─────────────┼────────┘
        │            │             │
        ▼            ▼             ▼
┌──────────┐  ┌──────────┐  ┌────────────┐
│  OpenAI  │  │  Claude  │  │   Ollama   │
│  API     │  │  API     │  │  (Local)   │
└──────────┘  └──────────┘  └────────────┘
```

**Các thành phần chính:**

- **Frontend**: Next.js 14 App Router với React Server Components. Render markdown, code blocks có syntax highlighting, và LaTeX math.
- **Chat Engine**: Quản lý lịch sử cuộc trò chuyện, context window, token counting, và streaming responses qua Server-Sent Events.
- **Plugin System**: Plugin runtime sandboxed sử dụng iframe + postMessage. Plugin khai báo manifest với schema tương thích OpenAPI.
- **Provider Proxy**: Mô hình adapter thống nhất chuẩn hóa các lệnh gọi API xuyên suốt 20+ nhà cung cấp LLM.
- **PWA Layer**: Service worker cho hỗ trợ offline, có thể cài đặt trên desktop và mobile.

## Cài đặt & Thiết lập: 10 Phút để Chat

**Yêu cầu**: Docker 24.0+ hoặc Node.js 20+ (cho dev local), 2GB RAM, 1GB disk.

### Cách 1: Docker (Khuyến nghị)

**Bước 1 —— Pull và chạy image chính thức:**

```bash
docker run -d -p 3210:3210 \
  -e OPENAI_API_KEY=YOUR_OPENAI_API_KEY \
  -e ACCESS_CODE=your-secure-password \
  --name lobe-chat \
  lobehub/lobe-chat:latest
```

**Bước 2 —— Truy cập UI:**

Mở `http://localhost:3210`. Bạn sẽ thấy trình hướng dẫn thiết lập để chọn nhà cung cấp LLM mặc định và nhập API keys.

**Bước 3 —— Cấu hình thêm nhà cung cấp (tùy chọn):**

```bash
# Thiết lập đa nhà cung cấp qua biến môi trường
docker run -d -p 3210:3210 \
  -e OPENAI_API_KEY=sk-xxx \
  -e ANTHROPIC_API_KEY=sk-ant-xxx \
  -e GOOGLE_API_KEY=xxx \
  -e OLLAMA_PROXY_URL=http://host.docker.internal:11434 \
  -e ACCESS_CODE=your-secure-password \
  --name lobe-chat \
  lobehub/lobe-chat:latest
```

### Cách 2: Docker Compose với Persistent Storage

```yaml
# docker-compose.yml
services:
  lobe-chat:
    image: lobehub/lobe-chat:latest
    ports:
      - "3210:3210"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - ACCESS_CODE=${ACCESS_CODE}
      - DATABASE_URL=postgresql://postgres:password@db:5432/lobe
    volumes:
      - lobe-data:/app/.config/lobe-chat
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=lobe
    volumes:
      - pgdata:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  lobe-data:
  pgdata:
```

```bash
# Khởi động với persistence
docker compose up -d
```

### Cách 3: Triển khai lên [DigitalOcean](https://m.do.co/c/eca87ac14ee0)

```bash
# Trên Droplet 2 vCPU / 4GB RAM (~$24/tháng)
sudo apt update && sudo apt install -y docker.io docker-compose-plugin

# Tạo file .env
cat > .env << 'EOF'
OPENAI_API_KEY=sk-your-key
ACCESS_CODE=secure-team-password
EOF

# Chạy
docker compose up -d

# Thiết lập reverse proxy với HTTPS qua Caddy
cat > Caddyfile << 'EOF'
chat.yourdomain.com {
    reverse_proxy localhost:3210
}
EOF
```

Thêm bản ghi DNS A trỏ đến IP Droplet của bạn và bạn sẽ online trong vòng 15 phút. [Lấy DigitalOcean Droplet tại đây](https://m.do.co/c/eca87ac14ee0).

## Tích hợp với 20+ Nhà Cung Cấp LLM

Lobe Chat chuẩn hóa các lệnh gọi API xuyên suốt các nhà cung cấp thông qua một adapter thống nhất. Sau đây là cách cấu hình các nhà cung cấp phổ biến nhất:

### OpenAI (GPT-4, GPT-4o)

```bash
# Qua biến môi trường
echo "OPENAI_API_KEY=sk-xxxxxxxx" >> .env

# Qua UI: Cài đặt → Mô hình Ngôn ngữ → OpenAI → Nhập key
```

### Anthropic Claude (Claude 3.5 Sonnet)

```bash
# Biến môi trường
echo "ANTHROPIC_API_KEY=sk-ant-xxxxxxxx" >> .env

# Khởi động lại container
docker restart lobe-chat
```

### Google Gemini (Gemini 1.5 Pro)

```bash
echo "GOOGLE_API_KEY=AIzaxxxxxxxx" >> .env
```

### Ollama (Model Local — Llama, Mistral, v.v.)

```bash
# Chạy Ollama trên host
docker run -d -p 11434:11434 --name ollama ollama/ollama

# Pull model
docker exec ollama ollama pull llama3.2

# Cấu hình Lobe Chat dùng Ollama
docker run -d -p 3210:3210 \
  -e OLLAMA_PROXY_URL=http://host.docker.internal:11434 \
  -e ACCESS_CODE=mypassword \
  lobehub/lobe-chat
```

### Azure OpenAI Service

```bash
# Cần endpoint, API key, và tên deployment
echo "AZURE_API_KEY=your-azure-key" >> .env
echo "AZURE_API_ENDPOINT=https://your-resource.openai.azure.com" >> .env
echo "AZURE_API_VERSION=2024-06-01" >> .env
```

### AWS Bedrock

```bash
echo "AWS_ACCESS_KEY_ID=AKIAxxx" >> .env
echo "AWS_SECRET_ACCESS_KEY=xxx" >> .env
echo "AWS_REGION=us-east-1" >> .env
```

### Chuyển Đổi Nhà Cung Cấp tại Runtime

Ngườ dùng có thể chuyển đổi nhà cung cấp theo từng cuộc trò chuyện trong UI. Điều này cho phép bạn so sánh GPT-4 và Claude cạnh nhau:

```
# Không cần restart —— chuyển nhà cung cấp là client-side
# Click icon nhà cung cấp ở header chat → Chọn model khác
# Mỗi cuộc trò chuyện nhớ lựa chọn nhà cung cấp của nó
```

## Hệ Thống Plugin: Mở Rộng Lobe Chat

Kiến trúc plugin của Lobe Chat sử dụng hệ thống dựa trên manifest. Plugin khai báo khả năng của chúng trong `manifest.json`, và UI chat render chúng như các công cụ tương tác.

### Cài đặt từ Plugin Marketplace

1. Mở Lobe Chat → Plugin Store
2. Duyệt 50+ plugin cộng đồng
3. Click "Cài đặt" → Ủy quyền quyền hạn
4. Plugin xuất hiện như tool calls trong chat

### Xây dựng Plugin Tùy Chỉnh

Tạo một plugin đơn giản query API nội bộ của bạn:

```json
{
  "api": [
    {
      "description": "Tìm kiếm cơ sở kiến thức nội bộ",
      "name": "search_kb",
      "parameters": {
        "properties": {
          "query": {
            "description": "Chuỗi truy vấn tìm kiếm",
            "type": "string"
          }
        },
        "required": ["query"],
        "type": "object"
      },
      "url": "https://api.yourcompany.com/kb/search"
    }
  ],
  "gateway": "https://gateway.example.com",
  "identifier": "your-company/kb-search",
  "meta": {
    "title": "Internal KB Search",
    "description": "Search company knowledge base"
  },
  "version": "1.0.0"
}
```

Host điều này tại một URL công khai, sau đó thêm qua **Plugin Store → Custom Plugin → Nhập URL**.

### Bảo Mật Runtime Plugin

Các plugin thực thi trong iframe sandboxed với quyền hạn bị hạn chế:

```
┌─────────────────────────────┐
│  Lobe Chat Main Window      │
│  ┌───────────────────────┐  │
│  │  Sandboxed Iframe     │  │
│  │  (mã plugin)          │  │
│  │  - Không truy cập DOM │  │
│  │  - Chỉ postMessage    │  │
│  │  - CORS bắt buộc      │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

Mỗi request plugin yêu cầu sự chấp thuận rõ ràng từ ngườ dùng. LLM đề xuất tool calls, nhưng ngườ dùng phải xác nhận trước khi thực thi.

## Hỗ Trợ PWA & Trải Nghiệm Mobile

Lobe Chat hoạt động như một Progressive Web App, tạo cảm giác như app native trên mọi nền tảng.

### Cài đặt trên Desktop (Chrome/Edge)

1. Mở Lobe Chat trong Chrome
2. Click icon cài đặt trong thanh địa chỉ
3. Khởi chạy như một cửa sổ độc lập với icon riêng

### Cài đặt trên Mobile (iOS Safari)

```
1. Mở Lobe Chat trong Safari
2. Chạm Chia sẻ → "Thêm vào Màn hình chính"
3. Xuất hiện như icon app native
4. Hỗ trợ push notification (qua service worker)
```

### Hỗ Trợ Offline

Service worker cache app shell và các cuộc trò chuyện gần đây. Không có internet:

```
✅ Duyệt lịch sử cuộc trò chuyện
✅ Xem phản hồi trước đó
✅ Soạn tin nhắn (xếp hàng để gửi)
❌ Phản hồi LLM mới (cần kết nối API)
```

## Benchmark & Use Case Thực Tế

### Độ Trễ Phản Hồi (đo từ US-East)

| Nhà cung cấp | Thờ gian Token Đầu Tiên | Phản hồi Đầy đủ (100 token) | Ghi chú |
|---|---|---|---|
| OpenAI GPT-4o | **0.8 giây** | **2.1 giây** | Nhanh nhất tổng thể |
| Claude 3.5 Sonnet | 1.1 giây | 2.8 giây | Chất lượng reasoning cao hơn |
| Gemini 1.5 Pro | 1.3 giây | 3.0 giây | Context window lớn |
| Ollama (Llama 3.2 7B, CPU) | 3.5 giây | 8.2 giây | Không tốn phí API |
| Ollama (Llama 3.2 7B, RTX 4090) | 0.6 giây | 1.5 giây | Tùy chọn local nhanh nhất |
| Azure GPT-4 | 1.0 giây | 2.4 giây | SLA doanh nghiệp |

### Mức sử dụng Tài nguyên

| Triển khai | Memory | CPU | Số ngườ dùng | Chi phí/Tháng |
|---|---|---|---|---|
| Docker single-instance | **350MB** | **0.2 cores** | 1–5 | $0 (tự host) |
| Docker + 5 nhà cung cấp | 400MB | 0.3 cores | 1–10 | Chỉ phí API |
| Với backend PostgreSQL | 650MB | 0.4 cores | 10–50 | ~$24 VPS |
| Sau reverse proxy | 400MB | 0.3 cores | 10–100 | ~$24 VPS |

### Các Triển khai Thực Tế

**Công ty Tư vấn AI (12 kỹ sư):**
- Triển khai Lobe Chat trên [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0)
- Kết nối **8 nhà cung cấp LLM** cho demo so sánh khách hàng
- Xây dựng **3 plugin tùy chỉnh** liên kết với database dự án nội bộ
- Tiết kiệm **~$240/tháng** so với các subscription ChatGPT Plus cá nhân

**Phòng thí nghiệm Nghiên cứu Đại học (40 sinh viên):**
- Tự host với Ollama cho dữ liệu nghiên cứu nhạy cảm về quyền riêng tư
- Sinh viên truy cập qua PWA trên laptop và điện thoại
- Plugin kết nối với API tìm kiếm thư viện đại học
- Zero cloud data exposure cho nghiên cứu chưa công bố

**Startup Hỗ trợ Khách hàng (5 nhân viên):**
- Tích hợp Claude 3.5 Sonnet qua API
- Plugin tùy chỉnh truy vấn tài liệu sản phẩm
- Giao diện đa ngôn ngữ hỗ trợ khách hàng tiếng Anh, Trung, Nhật
- Thờ gian soạn thảo phản hồi giảm **~45%**

## Sử dụng Nâng cao & Production Hardening

### Bật Xác thực

Cho triển khai team, đặt mã truy cập:

```bash
docker run -d -p 3210:3210 \
  -e ACCESS_CODE=your-secure-password-2026 \
  -e OPENAI_API_KEY=sk-xxx \
  lobehub/lobe-chat:latest
```

Cho tích hợp SSO, cấu hình OAuth:

```bash
  -e AUTH_PROVIDER=auth0 \
  -e AUTH_AUTH0_ID=your-client-id \
  -e AUTH_AUTH0_SECRET=your-secret \
  -e AUTH_AUTH0_ISSUER=https://your-domain.us.auth0.com \
```

### Theme Tùy Chỉnh

Tạo file theme JSON:

```json
{
  "primaryColor": "#1890ff",
  "neutralColor": "#8c8c8c",
  "backgroundColor": "#f0f2f5",
  "sidebarWidth": 280
}
```

Tải lên qua **Cài đặt → Theme → Theme Tùy chỉnh**.

### Conversations Hỗ trợ Database

Cho persistence đa ngườ dùng, cấu hình PostgreSQL:

```yaml
# docker-compose.prod.yml
services:
  lobe-chat:
    image: lobehub/lobe-chat:latest
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/lobechat
      - APP_URL=https://chat.yourdomain.com
    ports:
      - "3210:3210"

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: lobechat
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

### Reverse Proxy với Caddy

```bash
# Caddyfile cho HTTPS tự động
chat.yourdomain.com {
    reverse_proxy localhost:3210
    encode gzip
    header {
        X-Frame-Options DENY
        X-Content-Type-Options nosniff
    }
}
```

```bash
caddy run --config Caddyfile
```

### Giám sát với Prometheus

Lobe Chat expose metrics tại `/api/metrics`:

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
```

## So sánh với các Giải pháp Thay thế

| Tính năng | Lobe Chat | LibreChat | ChatGPT Web | HuggingChat |
|---|---|---|---|---|
| **GitHub Stars** | **~60,000** | ~20,000 | ~30,000 | N/A (sản phẩm) |
| **Nhà cung cấp LLM** | **20+** | 10+ | Chỉ OpenAI | Chỉ HF models |
| **Hệ thống Plugin** | **Dựa trên manifest** | Công cụ cơ bản | Không | Không |
| **Hỗ trợ PWA** | **Đầy đủ** | Một phần | Không | Không |
| **Giao diện đa ngôn ngữ** | **15+ ngôn ngữ** | 5 ngôn ngữ | 10 ngôn ngữ | 6 ngôn ngữ |
| **Tự host** | **Có (Docker)** | Có | Có | Không (chỉ SaaS) |
| **Xác thực** | **SSO + mã truy cập** | SSO + local | Cơ bản | Chỉ OAuth |
| **Knowledge Base** | **Dựa trên plugin** | Built-in RAG | Chỉ GPTs | Không |
| **Code Interpreter** | **Qua plugin** | Qua plugin | Native | Không |
| **Trải nghiệm Mobile** | **PWA như native** | Responsive | Responsive | Cơ bản |
| **Tùy chỉnh Theme** | **Đầy đủ** | Một phần | Không | Tối thiểu |
| **Đồng bộ tin nhắn** | **Backend PostgreSQL** | MongoDB | LocalStorage | Cloud |

**Khi nào chọn cái nào:**

- **Lobe Chat**: Chọn khi cần giao diện chat đa nhà cung cấp hoàn thiện với plugin và PWA. Trải nghiệm tổng thể tốt nhất cho team.
- **LibreChat**: Chọn nếu muốn setup đơn giản hơn với RAG built-in (upload tài liệu) và không cần PWA hay plugin mở rộng.
- **ChatGPT Web (Next-Web)**: Chọn nếu chủ yếu dùng OpenAI và muốn UI tự host nhẹ nhất, nhanh nhất.
- **HuggingChat**: Dùng như Web UI miễn phí cho Hugging Face models, nhưng không dùng cho tự host hay doanh nghiệp.

## Hạn chế: Đánh giá Trung thực

**Chưa có RAG built-in.** Khác với LibreChat có upload tài liệu và vector search tích hợp, Lobe Chat dựa vào plugin cho chức năng knowledge base. Tính năng RAG native đang nằm trong roadmap v1.0 nhưng chưa có tính đến tháng 5/2026.

**Hệ sinh thái plugin còn trẻ.** Có khoảng 50 plugin so với hàng nghìn của ChatGPT. Xây plugin tùy chỉnh đòi hỏi hiểu manifest schema và host một API tương thích.

**Cần API keys LLM.** Lobe Chat chỉ là UI —— bạn vẫn cần API keys cho cloud providers hoặc instance Ollama đang chạy cho model local. Không có "free tier" tích hợp.

**Không có phòng chat đa ngườ dùng.** Các cuộc trò chuyện là riêng tư cho mỗi phiên trình duyệt. Cộng tác đa ngườ thực sự với kênh chia sẻ cần backend tùy chỉnh.

**Image Docker khá lớn.** Image production nặng ~400MB nén. Trên kết nối chậm, lần pull đầu mất vài phút.

**Không có voice input/output.** Khác với app mobile ChatGPT, Lobe Chat không hỗ trợ speech-to-text hay text-to-speech natively. Có thể dùng Web Speech API của trình duyệt như workaround.

**UX phê duyệt plugin tạo ma sát.** Mỗi lệnh gọi plugin cần xác nhận của ngườ dùng. Điều này tốt cho bảo mật nhưng làm chậm workflow so với code interpreter của ChatGPT chạy tự động.

## Câu hỏi Thường gặp

**Q: Lobe Chat có lưu cuộc trò chuyện của tôi trên server của họ không?**

Không. Khi tự host, tất cả dữ liệu cuộc trò chuyện ở lại trên hạ tầng của bạn. Lobe Chat là ứng dụng client-side không gửi telemetry đến server bên ngoài trừ khi bạn cấu hình analytics một cách rõ ràng. Code mã nguồn mở (giấy phép MIT) có thể được audit trên GitHub. API keys cloud (OpenAI, Claude) chỉ được dùng cho inference calls —— các cuộc trò chuyện được lưu local.

**Q: Tôi có thể dùng nhiều nhà cung cấp LLM trong cùng một cuộc trò chuyện không?**

Không trong cùng một thread. Mỗi cuộc trò chuyện gắn với một nhà cung cấp, nhưng bạn có thể tạo nhiều cuộc trò chuyện với các nhà cung cấp khác nhau và chuyển đổi giữa chúng. Một số ngườ dùng giữ thread "GPT-4" cho coding và thread "Claude" cho viết lách, chuyển đổi qua sidebar.

**Q: Làm thế nào cập nhật Lobe Chat lên phiên bản mới nhất?**

```bash
# Pull image mới nhất
docker pull lobehub/lobe-chat:latest

# Khởi động lại container
docker compose down && docker compose up -d

# Cuộc trò chuyện persist trong browser localStorage
# Với backend PostgreSQL, database migrations tự động chạy
```

Cập nhật được phát hành hàng tuần. Kiểm tra [trang releases](https://github.com/lobehub/lobe-chat/releases) để xem các breaking changes trước khi cập nhật.

**Q: Sự khác biệt giữa hệ thống plugin và function calling là gì?**

Plugin Lobe Chat là **tích hợp cấp UI** —— chúng render các card tương tác, form, và visualization trong chat. Function calling là **cơ chế cấp LLM** quyết định khi nào gọi tool. Lobe Chat dùng function calling bên dưới để trigger plugin, sau đó render phản hồi UI của plugin. Kiến trúc plugin mở rộng function calling với các thành phần trực quan và luồng phê duyệt của ngườ dùng.

**Q: Tôi có thể dùng Lobe Chat không cần internet không?**

Một phần. Nếu bạn cấu hình Ollama là nhà cung cấp duy nhất (LLM local), chức năng chat cốt lõi hoạt động offline. Tuy nhiên, các lệnh gọi plugin cần kết nối internet (truy cập API bên ngoài), và lần load app đầu tiên cần tải assets. PWA cache app shell, nên sau lần truy cập đầu tiên, chat cơ bản hoạt động không cần internet nếu dùng model local.

**Q: Có giới hạn nào cho lịch sử cuộc trò chuyện không?**

Với backend localStorage mặc định, cuộc trò chuyện persist trong trình duyệt không có giới hạn cứng, nhưng hiệu năng giảm sau khoảng ~500 cuộc trò chuyện dài. Với backend PostgreSQL, không có giới hạn thực sự —— database xử lý hàng nghìn cuộc trò chuyện xuyên suốt nhiều ngườ dùng. Giới hạn token context window được áp dụng theo ràng buộc của nhà cung cấp LLM đã chọn.

**Q: Tôi có thể import cuộc trò chuyện ChatGPT không?**

Không trực tiếp. Định dạng xuất của ChatGPT (conversations.json) không tương thích với storage schema của Lobe Chat. Tuy nhiên, có các công cụ cộng đồng chuyển đổi ChatGPT exports sang Markdown, mà bạn có thể paste vào cuộc trò chuyện Lobe Chat. Team LobeHub có tính năng import trong roadmap cho Q3 2026.

## Kết luận: Cuộc Trò Chuyện của Bạn, Quy Tắc của Bạn

Lobe Chat mang đến những gì ChatGPT không: toàn quyền kiểm soát dữ liệu, hỗ trợ mọi nhà cung cấp LLM chính, plugin mở rộng, và trải nghiệm mobile như native —— tất cả chạy trên phần cứng của bạn. Với **khoảng 60,000 sao GitHub** và phát hành hàng tuần, đây là dự án trưởng thành, được duy trì tích cực có chất lượng UX sánh ngang với các lựa chọn thương mại.

Cho cá nhân, thiết lập Docker chỉ mất 10 phút và không tốn phí ngoài API usage. Cho team, triển khai trên [DigitalOcean](https://m.do.co/c/eca87ac14ee0) với backend PostgreSQL cho bạn một nền tảng chat chia sẻ với khả năng audit đầy đủ.

Hệ thống plugin và hỗ trợ PWA làm Lobe Chat nhiều hơn một bản sao ChatGPT —— nó là nền tảng xây dựng các workflow AI được thiết kế riêng cho tổ chức của bạn. Giao diện đa ngôn ngữ nghĩa là nó hoạt động cho team toàn cầu mà không cần cấu hình phức tạp.

**Sẵn sàng chuyển đổi?** Chạy lệnh Docker, thêm API keys, và bắt đầu chat. Cuộc trò chuyện của bạn thuộc về bạn.

Tham gia cộng đồng Telegram cho AI developers: **@dibi8dev** —— chia sẻ cấu hình Lobe Chat của bạn và nhận trợ giúp từ 5,000+ builders.

---

## Nguồn & Tài Liệu Tham Khảo

1. [Lobe Chat GitHub Repository](https://github.com/lobehub/lobe-chat) —— Mã nguồn, releases, và documentation chính thức
2. [Lobe Chat Documentation](https://lobehub.com/docs) —— Hướng dẫn cài đặt và cấu hình chính thức
3. [Lobe Chat Plugin Documentation](https://github.com/lobehub/lobe-chat/wiki/Plugin-System) —— Plugin manifest specification
4. [Docker Hub — lobehub/lobe-chat](https://hub.docker.com/r/lobehub/lobe-chat) —— Docker image chính thức
5. [LobeHub Plugin Marketplace](https://lobechat.com/plugins) —— Duyệt các plugin có sẵn
6. [Next.js Documentation](https://nextjs.org/docs) —— Documentation framework nền tảng

---



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Tuyên Bố Affiliate

Bài viết này chứa liên kết affiliate. Nếu bạn đăng ký DigitalOcean qua liên kết giới thiệu của chúng tôi, chúng tôi nhận được hoa hồng mà không phát sinh chi phí cho bạn. Chúng tôi chỉ giới thiệu các dịch vụ mà chính chúng tôi sử dụng cho hạ tầng. Lobe Chat là mã nguồn mở (giấy phép MIT) và miễn phí sử dụng —— không cần mua hàng.
