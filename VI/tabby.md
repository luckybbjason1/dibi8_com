---
title: 'Tabby: Trợ lý Lập trình AI Tự lưu trữ 33K+ Stars — Hướng dẫn Cài đặt Ưu tiên Riêng tư 2026'
description: 'Tabby là trợ lý lập trình AI tự lưu trữ. Hỗ trợ VS Code, JetBrains, Vim, Neovim, Ollama, DeepSeek. Cài đặt Docker, tích hợp IDE, benchmark, và hardening production.'
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
github_repo: 'https://github.com/TabbyML/tabby'
stars: 33530
maintainer: 'TabbyML'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['tabby', 'tro-ly-lap-trinh-ai', 'tu-luu-tru', 'thay-the-github-copilot', 'hoan-thanh-code', 'docker', 'ma-nguon-mo']
aliases:
- /vi/posts/tabby/
---

{{</* resource-info */>}}

GitHub Copilot gửi code độc quyền của bạn lên cloud của Microsoft. Với các team xử lý IP nhạy cảm — fintech, chăm sóc sức khỏe, quốc phòng, doanh nghiệp SaaS — điều đó là không thể chấp nhận được. Tabby là câu trả lờ từ mã nguồn mở: một trợ lý lập trình AI tự lưu trữ chạy hoàn toàn trên phần cứng của chính bạn, không có rò rỉ dữ liệu bên ngoài. Với hơn 33.530 sao GitHub và chu kỳ phát hành tích cực (v0.32.0 ra mắt tháng 1/2026), Tabby đã trưởng thành từ dự án thử nghiệm thành giải pháp thay thế Copilot cấp production. Hướng dẫn này đi qua cài đặt Tabby hoàn chỉnh, từ triển khai Docker đến tích hợp IDE và hardening production.

## Tabby là gì?

Tabby là trợ lý lập trình AI tự lưu trữ và giải pháp thay thế GitHub Copilot mã nguồn mở. Nó cung cấp hoàn thành code real-time, công cụ trả lờ câu hỏi code, và chat inline — tất cả chạy trên cơ sở hạ tầng do bạn kiểm soát. Được viết bằng Rust (92.9% code), Tabby được thiết kế cho tốc độ và có thể chạy trên GPU consumer, Apple Silicon, hoặc thậm chí máy chủ chỉ có CPU.

## Tabby hoạt động như thế nào?

Tabby gồm ba thành phần cốt lõi:

1. **Inference Server**: HTTP server dựa trên Rust tải các LLM chuyên code và phục vụ completion qua endpoint tương thích OpenAPI. Xử lý inference model, prompt templating, và streaming responses.

2. **IDE Extensions**: Extensions native cho VS Code, JetBrains IDE, Vim/Neovim, và Emacs bắt context trình soạn thảo và chuyển yêu cầu completion đến inference server.

3. **Admin Dashboard**: Web UI tích hợp cho quản lý ngườ dùng, tạo token API, indexing repository, và phân tích sử dụng. Không cần database bên ngoài — Tabby dùng SQLite embedded.

![Kiến trúc Tabby](https://raw.githubusercontent.com/TabbyML/tabby/main/website/static/img/tabby-logo.png)

Luồng dữ liệu đơn giản: IDE extension bắt context prefix/suffix quanh con trỏ, gửi đến server Tabby local, server chạy inference với model đã tải (ví dụ: StarCoder-2-3B hoặc Qwen2.5-Coder-7B), và trả về completion dưới 500ms trên GPU.

![Tabby Admin Dashboard](https://tabby.tabbyml.com/img/screenshot-dashboard.png)

## Cài đặt và Thiết lập

### Yêu cầu trước

- **Docker** (khuyên dùng) hoặc **Docker Compose**
- **NVIDIA Container Toolkit** (cho GPU support trên hệ thống CUDA)
- 4GB+ RAM cho model nhỏ (1.5B params), 16GB+ cho model trung bình (7B params)
- 10GB+ disk space cho model weights

### Cài đặt Docker (5 phút)

Cách nhanh nhất chạy Tabby là qua Docker. Các lệnh dưới đây hỗ trợ ba backend tính toán chính.

#### NVIDIA GPU (CUDA)

```bash
# Chạy Tabby với CUDA acceleration
docker run -d \
  --name tabby \
  --gpus all \
  -p 8080:8080 \
  -v $HOME/.tabby:/data \
  registry.tabbyml.com/tabbyml/tabby \
  serve \
  --model StarCoder-1B \
  --chat-model Qwen2-1.5B-Instruct \
  --device cuda
```

Với hệ thống bật SELinux, thêm cờ `:Z` vào volume mount:

```bash
docker run -d \
  --name tabby \
  --gpus all \
  -p 8080:8080 \
  -v $HOME/.tabby:/data:Z \
  registry.tabbyml.com/tabbyml/tabby \
  serve \
  --model StarCoder-1B \
  --chat-model Qwen2-1.5B-Instruct \
  --device cuda
```

#### Apple Silicon (Metal)

```bash
docker run -d \
  --name tabby \
  -p 8080:8080 \
  -v $HOME/.tabby:/data \
  registry.tabbyml.com/tabbyml/tabby \
  serve \
  --model StarCoder-1B \
  --chat-model Qwen2-1.5B-Instruct \
  --device metal
```

#### AMD GPU (ROCm)

```bash
docker run -d \
  --name tabby \
  --device /dev/kfd --device /dev/dri \
  --group-add video \
  -p 8080:8080 \
  -v $HOME/.tabby:/data \
  registry.tabbyml.com/tabbyml/tabby-rocm \
  serve \
  --model StarCoder-1B \
  --device rocm
```

#### Chỉ CPU (dự phòng)

```bash
docker run -d \
  --name tabby \
  -p 8080:8080 \
  -v $HOME/.tabby:/data \
  registry.tabbyml.com/tabbyml/tabby \
  serve \
  --model Qwen2.5-Coder-0.5B \
  --device cpu
```

### Kiểm tra cài đặt

```bash
# Kiểm tra health server
curl http://localhost:8080/v1/health

# Xem logs
docker logs -f tabby

# Mở admin dashboard
open http://localhost:8080
```

Lần khởi động đầu, Tabby tải model weights đã chỉ định về `$HOME/.tabby`. Tùy bandwidth, quá trình này mất 2–10 phút. Admin dashboard sẽ yêu cầu tạo tài khoản admin.

### Docker Compose (Production-Ready)

Cho triển khai lâu dài, dùng Docker Compose:

```yaml
version: '3.8'
services:
  tabby:
    image: registry.tabbyml.com/tabbyml/tabby
    container_name: tabby
    restart: unless-stopped
    ports:
      - "8080:8080"
    volumes:
      - $HOME/.tabby:/data
    environment:
      - TABBY_WEBSERVER_JWT_TOKEN_SECRET=CHANGE_ME_TO_RANDOM_STRING
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    command: >
      serve
      --model StarCoder2-3B
      --chat-model Qwen2.5-Coder-7B-Instruct
      --device cuda
      --parallelism 4
```

Tạo JWT secret an toàn:

```bash
openssl rand -hex 32
```

Triển khai:

```bash
docker compose up -d
```

### Homebrew (macOS Native)

Nếu không muốn dùng Docker trên macOS:

```bash
# Cài qua Homebrew
brew install tabbyml/tabby/tabby

# Chạy với Metal acceleration
tabby serve \
  --model StarCoder2-3B \
  --chat-model Qwen2-1.5B-Instruct \
  --device metal

# Kiểm tra
curl http://localhost:8080/v1/health
```

## Tích hợp VS Code, JetBrains, Vim và Ollama

![Tabby IDE tích hợp](https://tabby.tabbyml.com/img/screenshot-vscode.png)

### VS Code

1. Mở Extensions marketplace, tìm **"Tabby"**, cài extension của TabbyML.
2. Mở Settings (Ctrl+,), tìm **"Tabby"**, đặt Server Endpoint thành `http://localhost:8080`.
3. Thanh trạng thái hiển thị icon Tabby khi đã kết nối. Bắt đầu gõ để nhận completion.

### JetBrains IDE (IntelliJ, PyCharm, GoLand)

1. Mở **Settings → Plugins → Marketplace**, tìm **"Tabby"** và cài.
2. Khởi động lại IDE.
3. Vào **Settings → Tools → Tabby** và nhập server endpoint URL (ví dụ: `http://localhost:8080`).
4. Tạo API token từ Tabby admin dashboard và dán vào IDE settings.

### Vim / Neovim

Cho Neovim với `nvim-cmp` và `cmp-tabby`:

```lua
-- Trong config Neovim (ví dụ: init.lua)
require('cmp').setup({
  sources = {
    { name = 'tabby' },
  },
})

-- Cấu hình URL server Tabby
vim.g.tabby_server_url = 'http://localhost:8080'
```

### Dùng Ollama làm Backend

Tabby có thể ủy thác inference cho Ollama, cho phép chuyển đổi model động và quản lý nhiều model:

```toml
# ~/.tabby/config.toml
[model.completion.http]
kind = "ollama/completion"
model_name = "deepseek-coder:6.7b"
api_endpoint = "http://localhost:11434"
prompt_template = "<PRE> {prefix} <SUF>{suffix} <MID>"

[model.chat.http]
kind = "openai/chat"
model_name = "qwen2.5-coder:7b"
api_endpoint = "http://localhost:11434/v1"
```

Khởi động Ollama với các model cần thiết:

```bash
ollama pull deepseek-coder:6.7b
ollama pull qwen2.5-coder:7b
ollama serve
```

Sau đó khởi động Tabby không chỉ định `--model` (đọc từ config.toml):

```bash
tabby serve --device cuda
```

Thiết lập này lý tưởng khi muốn chạy nhiều model trên một GPU VRAM hạn chế — Ollama xử lý tải và giải phóng model động.

## Benchmark / Use Case Thực tế

Hiệu suất Tabby phụ thuộc nhiều vào kích thước model và phần cứng. Các số liệu dưới đây từ benchmark cộng đồng và thử nghiệm nội bộ:

| Model | Kích thước | GPU VRAM | Độ trễ TB | Tỷ lệ chấp nhận | Phù hợp cho |
|---|---|---|---|---|---|
| Qwen2.5-Coder-0.5B | 0.5B | 2 GB | ~200ms | 18% | Chỉ CPU, test nhanh |
| StarCoder-1B | 1B | 3 GB | ~180ms | 22% | Triển khai tài nguyên thấp |
| StarCoder2-3B | 3B | 6 GB | ~250ms | 28% | Cân bằng chất lượng/tốc độ |
| Qwen2.5-Coder-7B | 7B | 14 GB | ~350ms | 35% | Completion chất lượng cao |
| DeepSeekCoder-6.7B | 6.7B | 13 GB | ~380ms | 33% | Dự án Python/JS |

**Tỷ lệ chấp nhận** đo tần suất developer chấp nhận đề xuất Tabby so với bỏ qua hoặc sửa đổi. So sánh, tỷ lệ chấp nhận của GitHub Copilot khoảng 30–40% tùy ngôn ngữ.

### Kịch bản Triển khai

| Kịch bản | Phần cứng | Model khuyến nghị | Chi phí/tháng |
|---|---|---|---|
| Lập trình viên cá nhân, laptop | M2/M3 MacBook 16GB | StarCoder2-3B | $0 |
| Team nhỏ (5–10 dev) | RTX 4070 Ti, 16GB VRAM | Qwen2.5-Coder-7B | ~$50 (điện) |
| Doanh nghiệp (50+ dev) | 2× A100 80GB | Qwen2.5-Coder-7B + chat | ~$500 (hosting) |
| CI/CD batch | Instance cloud chỉ CPU | Qwen2.5-Coder-0.5B | ~$30 |

Cho hosting cơ sở hạ tầng server, cân nhắc [Hostinger](https://www.hostinger.com/) cho triển khai đơn giản không GPU hoặc [HTStack](https://www.htstack.com/) cho instance cloud GPU-accelerated. Cả hai đều tương thích với cài đặt Docker được mô tả ở trên.

## Sử dụng Nâng cao / Production Hardening

### Indexing Context Repository

Tính năng killer của Tabby cho team là indexing context cấp repository. Nó clone và index Git repository của bạn, sau đó dùng RAG (Retrieval-Augmented Generation) để trích xuất code snippets nội bộ liên quan trong quá trình completion.

Thêm repository qua admin dashboard:

```bash
# Điều hướng đến Repositories → Thêm Git URL
# Hỗ trợ GitHub, GitLab, và self-hosted Git
```

Hoặc cấu hình qua scheduler CLI:

```bash
docker exec tabby /opt/tabby/bin/tabby-cpu scheduler --now
```

### Security Hardening

1. **Thay đổi JWT secret mặc định**: Đặt `TABBY_WEBSERVER_JWT_TOKEN_SECRET` thành chuỗi hex 32-byte ngẫu nhiên mật mã học.

2. **Chạy sau reverse proxy** với TLS termination:

```nginx
# Ví dụ Nginx
server {
    listen 443 ssl;
    server_name tabby.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/tabby.yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/tabby.yourcompany.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

3. **Bật LDAP/SSO authentication** (Enterprise feature) cho kiểm soát truy cập team.

4. **Đặt giới hạn tài nguyên** trên container Docker:

```bash
docker run -d \
  --memory=24g \
  --cpus=8 \
  # ... các flag khác
```

### Tuning Hiệu suất

```bash
# Tăng parallelism cho request đồng thợi của team
tabby serve \
  --model StarCoder2-3B \
  --device cuda \
  --parallelism 4

# Dùng half-precision (FP16) để giảm VRAM usage
tabby serve \
  --model StarCoder2-3B \
  --device cuda \
  --dtype float16
```

### Giám sát

```bash
# Kiểm tra API health
curl http://localhost:8080/v1/health

# Docker stats
docker stats tabby

# Xem logs lỗi
docker logs tabby 2>&1 | grep ERROR
```

## So sánh với Giải pháp Thay thế

| Tính năng | Tabby | GitHub Copilot | Cursor | Codeium |
|---|---|---|---|---|
| **Tự lưu trữ** | Có | Không | Không | Một phần (Enterprise) |
| **Giấy phép** | Apache-2.0 | Độc quyền | Độc quyền | Độc quyền |
| **Giá (cá nhân)** | Miễn phí | $10/tháng | $20/tháng | Miễn phí tier |
| **Code giữ local** | Có | Không | Không | Không |
| **Linh hoạt model** | Model tương thích OpenAI | Chỉ GPT-4 | Chỉ Claude/GPT | Chỉ Codeium |
| **Indexing context repo** | Có (RAG tích hợp) | Hạn chế | Có | Có |
| **Quản lý team** | Có (admin dashboard) | Có (Enterprise) | Có (Team) | Có (Teams) |
| **Hỗ trợ IDE** | VS Code, JetBrains, Vim, Emacs, Eclipse | VS Code, JetBrains, Vim, Neovim | Chỉ VS Code | VS Code, JetBrains, Vim |
| **Độ phức tạp cài đặt** | Docker / 1 lệnh | Cài extension | Cài ứng dụng | Cài extension |
| **Offline được** | Có | Không | Không | Không |
| **Stars GitHub** | 33.530+ | N/A (Microsoft) | N/A (private) | N/A (private) |

Tabby là lựa chọn duy nhất trong nhóm này giữ 100% code on-premises. Điểm khác biệt này quan trọng nếu bạn tuân thủ SOC 2, HIPAA, ITAR, hoặc framework tuân thủ tương tự.

## Hạn chế / Đánh giá Trung thực

Tabby không phải giải pháp thay thế cho mọi trường hợp Copilot. Lưu ý các trade-off sau:

- **Model nhỏ kém hơn trong lý luận phức tạp**: Model 3B params không thể sánh với GPT-4 trong refactor đa file hoặc đề xuất kiến trúc. Cho những task đó, bạn vẫn cần tool chat dựa trên cloud.
- **Gánh nặng hạ tầng**: Bạn chịu trách nhiệm bảo trì GPU, cập nhật model, và uptime server. Không có fallback SaaS khi server down.
- **Không có chat trong cài đặt cơ bản**: Chat/answer engine cần model chat riêng và VRAM bổ sung. Hãy plan sizing GPU phù hợp.
- **Chi phí SSO doanh nghiệp**: LDAP và SSO nâng cao thuộc tier trả phí của Tabby, không có trong core mã nguồn mở.
- **Hỗ trợ mobile hạn chế**: Không có phiên bản iOS/Android tương đương tính năng review code mobile của Copilot.

## Câu hỏi Thường gặp

### Cần phần cứng gì để chạy Tabby?

Cho sử dụng cá nhân, laptop 16GB RAM với MacBook M-series hoặc GPU NVIDIA 8GB+ VRAM xử lý model StarCoder2-3B thoải mái. Cho team deployment, quy tắc là 4GB VRAM mỗi user đồng thờ. Model 7B trên RTX 4090 (24GB) hỗ trợ 4–6 developer đồng thờ.

### Tabby có thể dùng hoàn toàn offline không?

Có. Sau lần tải model đầu tiên, Tabby hoạt động hoàn toàn không cần internet. Inference server, IDE extensions, và admin dashboard đều chạy trên mạng local. Đây là một trong những lợi thế chính của Tabby cho môi trường air-gapped.

### Tabby so với GitHub Copilot về độ chính xác như thế nào?

Với completion đơn file bằng model 7B, Tabby đạt tỷ lệ chấp nhận trong khoảng 5–10% so với Copilot. Copilot vượt trội ở context đa file và refactor phức tạp — những task hưởng lợi từ model quy mô GPT-4. Cho completion từng dòng thông thường, khoảng cách không đáng kể.

### Có thể dùng model fine-tuned của riêng mình không?

Có. Tabby hỗ trợ model ở định dạng Hugging Face Transformers với API tương thích OpenAI. Bạn có thể trỏ Tabby đến local model path hoặc tự host model server. Xem [MODEL_SPEC.md](https://github.com/TabbyML/tabby/blob/main/MODEL_SPEC.md) cho yêu cầu định dạng chính xác.

### Tabby có phù hợp cho team doanh nghiệp lớn không?

Tabby scale đến 50+ users với phần cứng phù hợp (server đa GPU) và flag `--parallelism`. Admin dashboard hỗ trợ quản lý ngườ dùng, xoay vòng token API, và phân tích sử dụng. Cho tích hợp SSO/LDAP, bạn cần enterprise license.

### Làm thế nào cập nhật Tabby lên phiên bản mới?

```bash
# Pull image mới nhất
docker pull registry.tabbyml.com/tabbyml/tabby

# Khởi động lại container
docker compose down
docker compose up -d

# Xác minh phiên bản mới
curl http://localhost:8080/v1/health
```

## Kết luận

Tabby lấp đầy khoảng trống quan trọng trong thị trường trợ lý lập trình AI: một công cụ hoàn toàn mã nguồn mở, tự lưu trữ giữ code bên trong perimeter của bạn. Với 33.530+ sao, phát triển Rust tích cực, và hỗ trợ các model code mới nhất (Qwen2.5-Coder, DeepSeek, StarCoder2), Tabby đã sẵn sàng cho production trong các team coi trọng quyền riêng tư.

**Hành động để bắt đầu:**

1. Chạy lệnh Docker ở Phần 4 để khởi động Tabby trên máy local.
2. Cài IDE extension cho trình soạn thảo và kết nối đến `http://localhost:8080`.
3. Index một test repository từ admin dashboard để trải nghiệm completion hỗ trợ bở RAG.
4. Tham gia [cộng đồng Telegram](https://t.me/dibi8_ai_hub) để nhận mẹo triển khai và khuyến nghị model.

*Bài viết này chứa link affiliate đến nhà cung cấp hosting. Các khuyến nghị dựa trên tính phù hợp kỹ thuật cho workload AI tự lưu trữ, không phải quan hệ đối tác thương mại.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn và Tài liệu Tham khảo

- [Tabby GitHub Repository](https://github.com/TabbyML/tabby) — 33.530+ sao, Apache-2.0
- [Tabby Tài liệu Chính thức](https://tabby.tabbyml.com/docs/welcome/)
- [Tabby Hướng dẫn Cài đặt Docker](https://tabby.tabbyml.com/docs/quick-start/installation/docker/)
- [Tabby Models Registry](https://tabby.tabbyml.com/docs/models/)
- [Tabby VS Code Extension](https://marketplace.visualstudio.com/items?itemName=TabbyML.vscode-tabby)
- [Tabby JetBrains Plugin](https://plugins.jetbrains.com/plugin/22379-tabby)
- [MODEL_SPEC.md — Định dạng Model Tùy chỉnh](https://github.com/TabbyML/tabby/blob/main/MODEL_SPEC.md)
- [So sánh Trợ lý Lập trình AI Tự lưu trữ 2026](https://scopir.com/posts/self-hosted-ai-coding-assistants-tabby-continue-void/)
- [Tabby với Backend Ollama](https://github.com/TabbyML/tabby/discussions/3285)
- [Hostinger Cloud Hosting](https://www.hostinger.com/)
- [HTStack GPU Cloud](https://www.htstack.com/)
