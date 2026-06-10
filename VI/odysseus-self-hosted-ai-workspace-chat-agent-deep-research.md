---
title: 'Odysseus: Không gian AI tự lưu trữ với 10+ Công cụ Tích hợp — 65.000 Sao — Hướng dẫn Thiết lập Đầy đủ 2026'
description: 'Odysseus (65.243 sao GitHub) là một không gian AI tự lưu trữ kết hợp trò chuyện, tự động hóa tác nhân, nghiên cứu chuyên sâu, chỉnh sửa tài liệu, phân loại email, lịch và hơn nữa. Hỗ trợ vLLM, llama.cpp, Ollama, OpenRouter, OpenAI và GitHub Copilot. Có sẵn cài đặt Docker và native Linux/macOS.'
date: 2026-06-09
slug: odysseus-self-hosted-ai-workspace-chat-agent-deep-research
category: ai-tools
tags: ['odysseus', 'AI tự lưu trữ', 'Không gian AI', 'AI cục bộ', 'nghiên cứu chuyên sâu', 'tác nhân AI', 'giao diện trò chuyện', 'AI mã nguồn mở', 'AI lab tại gia']
github_repo: https://github.com/pewdiepie-archdaemon/odysseus
stars: 65243
maintainer: pewdiepie-archdaemon
license: MIT
featureImage: https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/odysseus.jpg
lang: vi
---


# Odysseus: Self-Hosted AI Workspace with 10+ Built-in Tools — 65,000 Stars — Full Setup Guide 2026

```
┌──────────────────────────────────────────────────┐
│              Odysseus Architecture                 │
│                                                   │
│  ┌─────────┐  ┌──────────┐  ┌─────────────────┐  │
│  │  Chat   │  │  Agent   │  │    Cookbook     │  │
│  │ (API)   │  │ (Tools)  │  │ (Model Server)│  │
│  └────┬────┘  └────┬─────┘  └────────┬────────┘  │
│       │             │                  │           │
│       ▼             ▼                  ▼           │
│  ┌───────────────────────────────────────────────┐ │
│  │           Python Backend (FastAPI)             │ │
│  │  ChromaDB │ SearXNG │ ntfy │ .env config    │ │
│  └───────────────────────────────────────────────┘ │
│       │             │                  │           │
│       ▼             ▼                  ▼           │
│  ┌───────────────────────────────────────────────┐ │
│         Docker Compose Stack                     │ │
│  ┌────────┐ ┌──────────┐ ┌────────┐ ┌─────────┐ │
│  │ Odysseus│ │ChromaDB  │ │SearXNG │ │ ntfy    │ │
│  └────────┘ └──────────┘ └────────┘ └─────────┘ │
│                                                   │
│  ┌───────────────────────────────────────────────┐ │
│  │        Frontend: Responsive Web UI (PWA)      │ │
│  └───────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────┘
```

Odysseus là một không gian AI tự lưu trữ, tích hợp hơn 10 công cụ vào một giao diện ưu tiên quyền riêng tư.

Không như ChatGPT hay Claude yêu cầu bạn chuyển giao dữ liệu, Odysseus chạy hoàn toàn trên phần cứng của chính bạn.

Hướng dẫn này bao gồm mọi thứ: phân tích kiến trúc, cài đặt Docker và native, cấu hình mô hình, thiết lập tác nhân, nghiên cứu chuyên sâu và tăng cường sản xuất.

## Odysseus là gì?

Odysseus là một không gian AI full-stack được xây dựng trên Python (backend FastAPI, frontend web phản hồi).

Dự án tích hợp các khả năng sau trong một ứng dụng web duy nhất:

| Feature | Description | Built On |
|---------|-------------|----------|
| Chat | Multi-model conversations | vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, GitHub Copilot |
| Agent | Tool-using autonomous agent | OpenCode, MCP, web, files, shell, skills, memory |
| Cookbook | Hardware-aware model downloader and server | llmfit, VRAM-aware, GGUF/FP8/AWQ |
| Deep Research | Multi-step research with source synthesis | Adapted from Alibaba's Tongyi DeepResearch |
| Compare | Blind multi-model comparison tests | Multi-model synthesis |
| Documents | Multi-tab text editor with AI assistance | Markdown, HTML, CSV, syntax highlighting |
| Memory/Skills | Persistent memory with vector + keyword retrieval | ChromaDB, fastembed (ONNX) |
| Email | IMAP/SMTP inbox with AI triage | IMAP, SMTP, CalDAV-aware |
| Notes & Tasks | Todo list, reminders, cron-style tasks | ntfy, browser, email channels |
| Calendar | Local-first calendar with CalDAV sync | CalDAV, .ics import/export |
| Extras | Image editor, theme editor, file uploads, 2FA | Vision + PDF support |

![Odysseus Chat & Agents](https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/chat.gif)

![Odysseus Deep Research](https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/research.gif)

![Odysseus Compare](https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/compare.gif)

## Odysseus hoạt động như thế nào?

Odysseus hoạt động như một kiến trúc phân tầng.

```
Client (Browser/PWA)
    │
    ▼
┌─────────────────────────┐
│     Web UI (Frontend)    │
│  Chat / Agent / Docs /   │
│  Email / Calendar / etc. │
└─────────┬───────────────┘
          │ WebSocket / REST API
          ▼
┌─────────────────────────┐
│   FastAPI Backend        │
│  • Chat handler          │
│  • Agent executor        │
│  • Cookbook manager      │
│  • Deep research engine  │
└─────────┬───────────────┘
          │
    ┌─────┼──────────┬──────────┐
    ▼     ▼          ▼          ▼
  vLLM  Ollama    SearXNG   ChromaDB
 (GPU)  (CPU)    (Search)  (Memory)
```

Thành phần **Cookbook** đặc biệt đáng chú ý — nó quét phần cứng của bạn để phát hiện GPU khả dụng, sau đó đề xuất và tải xuống các mô hình tương thích ở định dạng GGUF, FP8 hoặc AWQ.

Đối với tác nhân, Odysseus được xây dựng trên [OpenCode](https://github.com/anomalyco/opencode) và hỗ trợ MCP (Model Context Protocol) để tích hợp công cụ.

## Cài đặt và Thiết lập

### Docker (Được khuyến nghị)

Docker là cách đơn giản và đáng tin cậy nhất để chạy Odysseus.

```bash
# Clone the repository (use dev branch for latest features)
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus

# Copy the example environment file (recommended)
cp .env.example .env

# Optional: configure explicit defaults
# APP_BIND=127.0.0.1
# APP_PORT=7000
# AUTH_ENABLED=true

# Start the stack
docker compose up -d --build
```

Sau khi khởi động, mở `http://localhost:7000`.

Để bao gồm các tính năng bổ sung tùy chọn (trình xem PDF, trích xuất Office với AGPL PyMuPDF):

```bash
docker compose build --build-arg INSTALL_OPTIONAL=true
docker compose up -d --build
```

Để bật GPU passthrough cho GPU NVIDIA:

```bash
# Diagnose GPU passthrough
scripts/check-docker-gpu.sh

# Install NVIDIA Container Toolkit if needed
scripts/check-docker-gpu.sh --install-nvidia-toolkit

# Enable GPU overlay
scripts.check-docker-gpu.sh --enable-nvidia-overlay
```

Đối với AMD/ROCm:

```bash
scripts/check-docker-amd-gpu.sh
```

Sau đó chỉnh sửa `.env` để thêm overlay và ID nhóm render của host.

### Cài đặt Native Linux/macOS

Nếu bạn không muốn sử dụng Docker:

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus

# Create Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run initial setup
python setup.py

# Start the server
python -m uvicorn app:app --host 127.0.0.1 --port 7000
```

Yêu cầu: Python 3.11+.

### Apple Silicon (macOS có GPU)

Docker trên macOS không thể sử dụng Metal GPU.

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus

# The bundled script handles venv + dependencies + startup
./start-macos.sh
```

Nó khởi động tại `http://127.0.0.1:7860`.

```bash
ODYSSEUS_HOST=0.0.0.0 ./start-macos.sh
```

### Xây dựng Ứng dụng Desktop

Bạn có thể gói Odysseus dưới dạng wrapper ứng dụng desktop native:

```bash
./build-macos-app.sh
```

## Cấu hình và Thiết lập Mô hình

Sau khi cài đặt, cấu hình mô hình AI của bạn qua bảng **Cài đặt** của giao diện web.

```yaml
# Example .env configuration for multi-provider setup
APP_BIND=127.0.0.1
APP_PORT=7000
AUTH_ENABLED=true
DATABASE_URL=sqlite:///./odysseus.db

# OpenAI-compatible API
OPENAI_API_KEY=sk-your-key-here
OPENAI_BASE_URL=https://api.openai.com/v1

# Anthropic
ANTHROPIC_API_KEY=sk-ant-your-key-here

# Ollama (local)
OLLAMA_BASE_URL=http://localhost:11434

# OpenRouter
OPENROUTER_API_KEY=sk-or-your-key-here
```

Cookbook cung cấp cách thức hỗ trợ GUI để tải xuống và phục vụ mô hình.

### Thêm Mô hình Tùy chỉnh

```bash
# List available models in Cookbook
odysseus cookbook list

# Download a model (auto-detects best format for your hardware)
odysseus cookbook download mistral-7b

# Start serving a local model
odysseus cookbook serve llama-3.1-8b
```

## Tích hợp với Các công cụ Khác

### Khung Tác nhân OpenCode

Tác nhân Odysseus được xây dựng trên [OpenCode](https://github.com/anomalyco/opencode), cho phép chúng sử dụng công cụ một cách tự động.

```bash
# Configure MCP in .env
MCP_SERVERS=http://localhost:3000,mcp://your-server

# Your agent can then use:
# - File tools (read/write/search)
# - Shell execution
# - Web search
# - Custom skills
```

### ChromaDB cho Bộ nhớ Bền vững

Odysseus bao gồm ChromaDB cho bộ nhớ dựa trên vector bền vững.

```bash
# Memory import/export
odysseus memory export --output memory.json
odysseus memory import --input memory.json

# The memory system uses:
# - ChromaDB for vector storage
# - fastembed (ONNX) for embeddings
# - Combined vector + keyword retrieval
```

### Tìm kiếm Web SearXNG

Đối với các tác nhân cần nghiên cứu web, Odysseus tích hợp SearXNG (một công cụ tìm kiếm siêu dữ tôn trọng quyền riêng tư).

```bash
# SearXNG is included in the Docker stack
# Access it at: http://localhost:8888 (inside Docker network)
# Agent web search uses it automatically
```

### Tích hợp Email

Odysseus bao gồm hòm thư IMAP/SMTP đầy đủ với phân loại được hỗ trợ AI:

```yaml
# Email config in .env
EMAIL_IMAP_SERVER=imap.gmail.com
EMAIL_IMAP_PORT=993
EMAIL_SMTP_SERVER=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_USERNAME=your@email.com
EMAIL_PASSWORD=app-password
```

AI có thể tự động: tóm tắt email, đánh dấu mức độ khẩn cấp, soạn phản hồi, gắn thẻ tự động và lọc thư rác.

## Benchmark và Trường hợp Sử dụng Thực tế

### So sánh Sử dụng Tài nguyên

| Component | Docker | Native (no models) |
|-----------|--------|---------------------|
| RAM | ~200 MB | ~50 MB |
| Disk | ~500 MB (base) | ~100 MB |
| Startup | ~5 sec | ~1 sec |
| GPU passthrough | Supported | Native only (Metal) |

### Hiệu suất Nghiên cứu Chuyên sâu

Tính năng nghiên cứu chuyên sâu của Odysseus (được điều chỉnh từ DeepResearch của Alibaba) thực hiện các quy trình nghiên cứu nhiều bước:

```
Research Task: "Compare RAG vs. fine-tuning for enterprise QA"

Step 1: Web search (SearXNG) → 15 sources
Step 2: Read & extract key points → 8 documents
Step 3: Synthesize into report → 5-page summary
Step 4: Visualize with charts → auto-generated
```

Điều này đặc biệt hữu ích cho nhà nghiên cứu, nhà phân tích và bất kỳ ai cần tổng hợp thông tin từ nhiều nguồn thành báo cáo có cấu trúc.

### Chế độ So sánh Mô hình

Tính năng Compare cho phép kiểm tra A/B mù các mô hình khác nhau bên cạnh nhau:

```
Prompt: "Write a Python binary search implementation"

Model A: [hidden] → Response
Model B: [hidden] → Response

User selects best response → rankings updated
```

Điều này loại bỏ thiên kiến thương hiệu khi đánh giá mô hình nào hoạt động tốt nhất cho trường hợp sử dụng của bạn.

## Sử dụng Nâng cao / Tăng cường Sản xuất

### Thiết lập Đa người dùng

```bash
# Enable authentication (default)
AUTH_ENABLED=true

# Set custom admin user
ODYSSEUS_ADMIN_USER=yourusername

# Set admin password via .env
ODYSSEUS_ADMIN_PASSWORD=secure-password

# After first login, disable temporary password requirement
# via Settings panel
```

### Cấu hình Proxy ngược

For production deployment behind a reverse proxy:

```nginx
server {
    listen 443 ssl;
    server_name ai.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/ai.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ai.yourdomain.com/remote.key;

    location / {
        proxy_pass http://127.0.0.1:7000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### Docker Compose cho Sản xuất

```yaml
# docker-compose.prod.yml
services:
  odysseus:
    image: pewdiepie-archdaemon/odysseus:latest
    restart: unless-stopped
    ports:
      - "127.0.0.1:7000:7000"
    volumes:
      - ./data:/app/data
      - ./config:/app/config
    env_file: .env
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

### Chiến lược Sao lưu

```bash
# Backup ChromaDB (memory) and configuration
tar czf odysseus-backup-$(date +%Y%m%d).tar.gz \
  data/ \
  config/ \
  .env \

# ChromaDB data persists in: ./data/chroma/
# SQLite database: ./odysseus.db
```

## So sánh với Các Giải pháp Thay thế

| Feature | Odysseus | ChatGPT | Claude | NotebookLM | Open WebUI |
|---------|----------|---------|--------|------------|------------|
| Self-hosted | ✅ Full | ❌ Cloud only | ❌ Cloud only | ❌ Cloud only | ✅ Partial |
| Built-in agent | ✅ OpenCode/MCP | ✅ GPTs | ✅ Computer Use | ❌ No | ✅ Limited |
| Deep research | ✅ Built-in | ✅ Plus only | ✅ | ✅ Built-in | ❌ No |
| Email integration | ✅ IMAP/SMTP | ❌ No | ❌ No | ❌ No | ❌ No |
| Calendar sync | ✅ CalDAV | ❌ No | ❌ No | ❌ No | ❌ No |
| Local models | ✅ vLLM/llama.cpp | ❌ No | ❌ No | ❌ No | ✅ Partial |
| Memory persistence | ✅ ChromaDB | ✅ Plus only | ❌ No | ❌ No | ✅ Partial |
| Mobile PWA | ✅ Full | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| Cost | Free (self-hosted) | $20/mo | $20/mo | Free | Free |

## Hạn chế / Đánh giá Trung thực

Mặc dù Odysseus đáng ấn tượng, nhưng nó có một số hạn chế cần lưu ý:

1. **Dự án mới (tạo ngày 31 tháng 5 năm 2026)** — Dù có hơn 65.000 sao, Odysseus vẫn rất non trẻ. Hãy mong đợi lỗi, thay đổi phá vỡ và tài liệu không đầy đủ. Nhánh `dev` là mặc định nhưng "có thể không ổn định."

2. **Hỗ trợ GPU tập trung vào Docker/NVIDIA** — Hỗ trợ AMD ROCm tồn tại nhưng yêu cầu cấu hình `.env` thủ công. Apple Silicon yêu cầu cài đặt native (không có Docker GPU).

3. **Chưa có hình ảnh container chính thức** — Bạn phải xây dựng từ nguồn (`git clone` + `docker compose build`). Hình ảnh Docker Hub chính thức sẽ đơn giản hóa việc triển khai.

4. **Lựa chọn mô hình Cookbook bị hạn chế** — Mặc dù nhận thức VRAM, Cookbook tải từ HuggingFace có thể chậm với mô hình lớn. Không có đăng ký mô hình tích hợp với điểm chất lượng được tuyển chọn.

5. **Khả năng tác nhân vẫn đang phát triển** — Được xây dựng trên OpenCode, tác nhân có thể sử dụng công cụ nhưng thiếu hệ sinh thái plugin rộng rãi của các khung thành thạo hơn.

6. **Trải nghiệm di động là "phản hồi"** — Dự án tuyên bố "nhìn và chạy rất tốt trên điện thoại của bạn" nhưng là ứng dụng web-first, nó không phải là trải nghiệm di động native thực sự.

## Câu hỏi Thường gặp

Q：Tôi có thể chạy Odysseus trên Raspberry Pi không?

A: Về mặt kỹ thuật thì ứng dụng本身 có thể, nhưng việc phục vụ mô hình cục bộ sẽ không thực tế. Bạn có thể kết nối với nhà cung cấp API từ xa (OpenAI, Anthropic, OpenRouter) hoặc máy chủ mô hình từ xa. Frontend dựa trên Chromium cũng có thể có vấn đề hiệu suất trên ARM với RAM hạn chế.

Q：Odysseus đã sẵn sàng cho sản xuất để sử dụng nhóm chưa?

A: Tính đến tháng 6 năm 2026, dự án vẫn ở phiên bản tiền 1.0 và đang được phát triển tích cực. Nó rất tốt cho cá nhân và thử nghiệm, nhưng triển khai nhóm nên mong đợi các thay đổi phá vỡ đôi khi. Hệ thống xác thực đa người dùng đã tồn tại nhưng cơ bản (không có RBAC hoặc SSO).

Q：Tôi kết nối các mô hình cục bộ của riêng mình mà không cần Cookbook như thế nào?

A: Bạn có thể sử dụng Ollama hoặc vLLM làm nhà cung cấp mô hình và cấu hình điểm cuối API trong Cài đặt Odysseus. Cookbook là tùy chọn — nó chủ yếu là công cụ tiện lợi để tải xuống và phục vụ mô hình với đề xuất nhận thức VRAM.

Q：Odysseus có hỗ trợ phản hồi phát trực tiếp không?

A: Có, tất cả phản hồi trò chuyện và tác nhân được phát trực tiếp thời gian thực qua kết nối WebSocket. Frontend hỗ trợ hoạt ảnh UI phát trực tiếp cho trải nghiệm giống ChatGPT.

Q：Tôi có thể sử dụng Odysseus mà không cần bất kỳ khóa API nào không?

A: Có — nếu bạn có GPU, bạn có thể phục vụ mô hình cục bộ qua vLLM hoặc llama.cpp (thông qua Cookbook). Đối với người dùng chỉ CPU, Ollama cung cấp mô hình cục bộ miễn phí. Việc sử dụng chỉ API yêu cầu khóa từ các nhà cung cấp như OpenAI, Anthropic hoặc OpenRouter.

Q：Tính năng email hoạt động với Gmail như thế nào?

A: Bạn cần tạo "Mật khẩu ứng dụng" trong cài đặt Tài khoản Google (Bảo mật > Xác minh 2 bước > Mật khẩu ứng dụng). Sử dụng mật khẩu 16 ký tự này thay vì mật khẩu Gmail thông thường của bạn trong cấu hình IMAP.

## Kết luận

Odysseus đại diện cho một trong những dự án AI tự lưu trữ tham vọng nhất trên GitHub — kết hợp trò chuyện, tự động hóa tác nhân, nghiên cứu chuyên sâu, chỉnh sửa tài liệu, phân loại email, quản lý lịch và phục vụ mô hình cục bộ vào một không gian làm việc ưu tiên quyền riêng tư. Với hơn 65.000 sao chỉ sau vài tuần kể từ khi ra mắt, rõ ràng nó đang tạo được sự cộng hưởng với người dùng muốn có sự tiện lợi của giao diện ChatGPT mà không cần đánh đổi dữ liệu.

Việc cài đặt dựa trên Docker khiến nó dễ tiếp cận ngay cả với người dùng không có chuyên môn Linux sâu, trong khi cài đặt native và hỗ trợ Apple Silicon cung cấp tùy chọn cho những người thích chạy trực tiếp trên phần cứng của họ.

**Try Odysseus yourself:** [github.com/pewdiepie-archdaemon/odysseus](https://github.com/pewdiepie-archdaemon/odysseus)

**Related articles:**
- [AgentMemory](https://dibi8.com/agentmemory-persistent-memory-ai-coding-agents) — Persistent memory for AI coding agents
- [Open Notebook](https://dibi8.com/open-notebook-open-source-notebooklm-alternative-15-ai-providers) — Open-source NotebookLM alternative with 15+ AI providers

**Sources & Further Reading:**
- Official docs: https://pewdiepie-archdaemon.github.io/odysseus/
- GitHub repository: https://github.com/pewdiepie-archdaemon/odysseus
- Cookbook (model selection): https://github.com/AlexsJones/llmfit
- Deep Research (adapted from): https://github.com/Alibaba-NLP/DeepResearch
- Agent framework (OpenCode): https://github.com/anomalyco/opencode

---

Tham gia cộng đồng của chúng tôi để tìm hiểu sâu hơn về các công cụ AI:[t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**Tuyên bố miễn trừ trách nhiệm:** Bài viết này chỉ nhằm mục đích thông tin.
