---
title: 'Ollama: 137K+ Stars — Chạy LLM Local bằng Một Lệnh, Hướng Dẫn Cấu Hình Đầy Đủ 2026'
description: 'Ollama là cách đơn giản nhất để chạy Llama, DeepSeek, Mistral và các LLM khác trên local. Tương thích với LangChain, OpenWebUI, Continue.dev và Dify. Bao gồm thiết lập Docker, tùy chỉnh Modelfile, REST API, production hardening và benchmark hiệu năng.'
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
github_repo: 'https://github.com/ollama/ollama'
stars: 137000
maintainer: 'ollama'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['ollama', 'llm-local', 'llama.cpp', 'deepseek', 'mistral', 'docker', 'modelfile', 'open-source']
aliases:
- /vi/posts/ollama/
- /vi/resources/llm-frameworks/ollama-local-llm-guide/
---

{{</* resource-info */>}}

Chạy các mô hình ngôn ngữ lớn từng đồng nghĩa với việc vật lộn với môi trường Python, driver CUDA và hàng gigabyte dependency. Đến năm 2026, ma sát đó đã biến mất. [Ollama](https://ollama.com) cho phép bạn pull, cấu hình và serve các LLM production-grade chỉ bằng một lệnh — không cần cài PyTorch, không cần tune GPU thủ công, thậm chí không bắt buộc Docker. Với 137.000+ sao GitHub và hệ sinh thái tích hợp phát triển mạnh, Ollama đã trở thành runtime mặc định cho developer muốn chạy inference local mà không gánh nặng vận hành.

Hướng dẫn này đi qua toàn bộ quy trình thiết lập Ollama: cài đặt, triển khai Docker, tùy chỉnh Modelfile, tích hợp API với các framework phổ biến, production hardening, và benchmark trung thực so với các alternative. Dù bạn đang xây coding assistant, pipeline RAG, hay alternative ChatGPT self-hosted, tutorial này cung cấp lệnh và config để bạn đi từ zero đến model đang chạy trong vòng năm phút.

![Ollama chạy local](https://ollama.com/public/assets/case.png)

*Hướng dẫn Ollama này bao gồm thiết lập đầy đủ từ cài đặt đến triển khai production.*

## Ollama là gì?

**Ollama** là runtime open-source để chạy large language models trên local. Nó wrap các inference engine (llama.cpp cho CPU/GPU, MLX trên Apple Silicon, ROCm trên AMD) sau một CLI và REST API đơn giản, giúp developer tập trung xây dựng ứng dụng thay vì quản lý model weights, quantization formats và hardware acceleration. Hãy nghĩ Ollama như Docker cho LLM: pull model, chạy, xong.

Được tạo bởi Jeffrey Morgan và team Ollama vào năm 2023, dự án đạt 137.000+ sao trên GitHub vào giữa năm 2026. Nó hỗ trợ hàng trăm models bao gồm Llama 3, DeepSeek R1, Mistral, Qwen, Gemma và CodeLlama — tất cả đều có sẵn qua [thư viện model Ollama](https://ollama.com/search).

![Logo chính thức Ollama](https://raw.githubusercontent.com/ollama/ollama/main/docs/ollama.png)

## Ollama hoạt động như thế nào?

Kiến trúc Ollama theo mô hình client-server. Một daemon chạy nền (`ollama serve`) quản lý việc tải model, phân bổ bộ nhớ và inference. CLI và REST API là các client mỏng giao tiếp với daemon này qua HTTP trên cổng 11434.

### Kiến trúc cốt lõi

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│   Client    │────▶│ ollama serve │────▶│  llama.cpp/MLX  │
│  (CLI/API)  │     │   (cổng      │     │  (backend       │
│             │◄────│   11434)     │◄────│   inference)    │
└─────────────┘     └──────────────┘     └─────────────────┘
                           │
                    ┌──────┴──────┐
                    │  ~/.ollama/ │
                    │  (models,   │
                    │   blobs)    │
                    └─────────────┘
```

**Các thành phần chính:**

- **Model Hub**: Các model GGUF được curate từ `ollama.com`. Mỗi model được xác định bằng cặp `name:tag` (ví dụ: `llama3.2:8b`).
- **Modelfile**: Một config khai báo (tương tự Dockerfile) chỉ định base model, system prompt, parameters và chat templates.
- **Inference Backends**: Tự động chọn llama.cpp (CUDA/ROCm/CPU), MLX (Apple Silicon), hoặc Metal dựa trên phần cứng khả dụng.
- **REST API**: Các endpoint tương thích OpenAI tại `/api/generate`, `/api/chat`, `/api/embed`, và `/v1/chat/completions`.

### Lưu trữ Model

Các model được lưu trong `~/.ollama/models/` dưới dạng content-addressable blobs (SHA-256 digests). Một file manifest theo dõi blobs nào thuộc về tag model nào. Cơ chế deduplication này có nghĩa là hai model chia sẻ cùng base weights chỉ lưu một bản sao trên đĩa.

## Cài đặt và Thiết lập

### macOS

```bash
# Dùng Homebrew (khuyến nghị)
brew install ollama

# Hoặc tải app native từ ollama.com/download
```

### Linux (Cài đặt một dòng)

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

Lệnh này cài binary, đăng ký systemd service, và tự động phát hiện khả năng GPU (NVIDIA CUDA, AMD ROCm, hoặc chỉ CPU).

### Windows

Tải installer từ [ollama.com/download](https://ollama.com/download). Khuyến nghị Windows 11/12 với WSL2 để có đầy đủ tính tương thích.

### Xác minh cài đặt

```bash
ollama --version
# ollama version 0.6.7

# Khởi động daemon (nếu chưa chạy)
ollama serve

# Pull và chạy model đầu tiên
ollama run llama3.2:8b
```

Lần đầu chạy một model, Ollama sẽ tải về. Một model 8B parameters quantized như `llama3.2:8b` cần khoảng 4.9 GB dung lượng đĩa và chạy thoải mái trên 8 GB VRAM.

### Chọn model nhanh theo phần cứng

| Phần cứng | Model khuyến nghị | Lệnh |
|----------|------------------|------|
| 6–8 GB VRAM | Qwen3 8B | `ollama run qwen3:8b` |
| 10–12 GB VRAM | Llama 3.1 8B Q4 | `ollama run llama3.1:8b` |
| 16+ GB VRAM | DeepSeek-R1 14B | `ollama run deepseek-r1:14b` |
| Chỉ CPU, 16 GB RAM | Phi-4 Mini 3.8B | `ollama run phi4-mini` |
| Apple M3/M4 36 GB | Llama 3.1 70B Q4 | `ollama run llama3.1:70b` |

## Tích hợp với các công cụ phổ biến

### Open WebUI (Giao diện kiểu ChatGPT)

[Open WebUI](https://github.com/open-webui/open-webui) là frontend phổ biến nhất cho Ollama, cung cấp giao diện web tương tự ChatGPT với RAG, voice input và multi-user.

```bash
# Chạy Open WebUI với Docker
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

Truy cập tại `http://localhost:3000`. Open WebUI tự động phát hiện instance Ollama của bạn tại `http://host.docker.internal:11434`.

### LangChain (Python)

```python
# Cài đặt
pip install langchain-ollama

# Chat model
from langchain_ollama import ChatOllama

llm = ChatOllama(
    model="llama3.2:8b",
    temperature=0.7,
    base_url="http://localhost:11434"
)

response = llm.invoke("Giải thích máy tính lượng tử trong một đoạn văn.")
print(response.content)

# Embeddings
from langchain_ollama import OllamaEmbeddings

embeddings = OllamaEmbeddings(model="nomic-embed-text")
vector = embeddings.embed_query("Hello world")
# Trả về vector float 768 chiều
```

### Continue.dev (Trợ lý lập trình AI cho VS Code/Cursor)

Thêm vào `~/.continue/config.json`:

```json
{
  "models": [
    {
      "title": "Llama 3.2",
      "provider": "ollama",
      "model": "llama3.2:8b",
      "apiBase": "http://localhost:11434"
    }
  ],
  "tabAutocompleteModel": {
    "title": "CodeQwen",
    "provider": "ollama",
    "model": "codeqwen:7b-code"
  }
}
```

### Dify (Nền tảng workflow AI tự host)

Trong **Cài đặt > Nhà cung cấp Model > Ollama** của Dify, cấu hình:

```
Tên model: llama3.2:8b
URL cơ sở: http://host.docker.internal:11434
Cửa sổ ngữ cảnh: 8192
```

### cURL / Sử dụng trực tiếp REST API

```bash
# Sinh văn bản
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:8b",
  "prompt": "Tại sao bầu trờ có màu xanh?",
  "stream": false
}'

# Chat completion (tương thích OpenAI)
curl http://localhost:11434/v1/chat/completions -H "Content-Type: application/json" -d '{
  "model": "llama3.2:8b",
  "messages": [{"role": "user", "content": "Xin chào!"}],
  "temperature": 0.7
}'

# Sinh embeddings
curl http://localhost:11434/api/embed -d '{
  "model": "nomic-embed-text",
  "input": ["Bầu trờ xanh", "Cỏ xanh"]
}'
```

## Thiết lập Docker cho Production

![Triển khai Ollama Docker](https://raw.githubusercontent.com/ollama/ollama/main/docs/images/logo.png)

### Docker Compose cơ bản

```yaml
# docker-compose.yml
version: "3.8"

services:
  ollama:
    image: ollama/ollama:0.6.7
    container_name: ollama
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    environment:
      - OLLAMA_KEEP_ALIVE=24h
      - OLLAMA_NUM_PARALLEL=4
      - OLLAMA_MAX_LOADED_MODELS=2
    restart: unless-stopped
    # Hỗ trợ GPU NVIDIA
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    volumes:
      - openwebui_data:/app/backend/data
    depends_on:
      - ollama
    restart: unless-stopped

volumes:
  ollama_data:
  openwebui_data:
```

Khởi động bằng `docker compose up -d`.

### Thiết lập GPU NVIDIA

```bash
# Cài đặt NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
  | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### Thiết lập GPU AMD ROCm

Dùng image tag dành riêng cho ROCm:

```yaml
services:
  ollama:
    image: ollama/ollama:rocm
    devices:
      - /dev/kfd
      - /dev/dri
    group_add:
      - video
    environment:
      - HSA_OVERRIDE_GFX_VERSION=11.0.0
```

### Serve đồng thờ nhiều model

```yaml
services:
  ollama:
    image: ollama/ollama:0.6.7
    environment:
      - OLLAMA_NUM_PARALLEL=4      # 4 request đồng thờ
      - OLLAMA_MAX_LOADED_MODELS=2  # Giữ 2 model trong VRAM
      - OLLAMA_KEEP_ALIVE=30m      # Unload sau 30 phút idle
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```

## Modelfile: Tùy chỉnh model

Modelfile là định dạng config khai báo của Ollama. Nó định nghĩa model hoạt động như thế nào: system prompt, sampling parameters, context window và chat template.

### Ví dụ Modelfile cơ bản

```dockerfile
# Modelfile
FROM llama3.2:8b

# System prompt định nghĩa tính cách
SYSTEM """Bạn là một kỹ sư phần mềm cao cấp. Hãy ngắn gọn,
thực tế, và luôn bao gồm code examples hoạt động được."""

# Tune parameters
PARAMETER temperature 0.3
PARAMETER num_ctx 16384
PARAMETER top_p 0.9
PARAMETER repeat_penalty 1.1
PARAMETER stop "<|eot_id|>"

# Template tùy chỉnh (tùy chọn — bỏ qua sẽ kế thừa từ base model)
TEMPLATE """{{ if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>{{ end }}{{ if .Prompt }}<|start_header_id|>user<|end_header_id|>

{{ .Prompt }}<|eot_id|>{{ end }}<|start_header_id|>assistant<|end_header_id|>

{{ .Response }}<|eot_id|>"""
```

Build và chạy:

```bash
# Tạo model tùy chỉnh
ollama create senior-dev -f Modelfile

# Chạy
ollama run senior-dev

# Xem Modelfile hiệu lực
ollama show senior-dev --modelfile
```

### Nâng cao: Trợ lý code review

```dockerfile
# Modelfile.code-review
FROM codellama:7b-code

SYSTEM """Bạn là trợ lý review code. Phân tích code được cung cấp để tìm:
1. Bug và lỗi logic
2. Lỗ hổng bảo mật (SQL injection, XSS, buffer overflow)
3. Vấn đề hiệu năng (truy vấn N+1, cấp phát không cần thiết)
4. Phong cách và khả năng đọc

Định dạng phản hồi:
- [CRITICAL] cho bug/bảo mật
- [WARN] cho hiệu năng
- [INFO] cho gợi ý phong cách

Luôn đề xuất fix cho các mục [CRITICAL] và [WARN]."""

PARAMETER temperature 0.1
PARAMETER num_ctx 8192
PARAMETER num_predict 2048
```

```bash
ollama create code-reviewer -f Modelfile.code-review
```

### Tạo từ file GGUF local

```dockerfile
# Modelfile.local
FROM ./my-fine-tuned-model-q4_k_m.gguf

PARAMETER temperature 0.7
PARAMETER num_ctx 4096

SYSTEM "Bạn là trợ lý hữu ích chuyên về thuật ngữ y tế."
```

```bash
ollama create med-assistant -f Modelfile.local
```

### Kiểm tra các model hiện có

```bash
# Hiển thị chi tiết model và Modelfile
ollama show llama3.2:8b --modelfile

# Chỉ hiển thị parameters
ollama show llama3.2:8b --parameters

# Hiển thị system prompt
ollama show llama3.2:8b --system

# Liệt kê tất cả model local
ollama list

# Hiển thị model đang chạy
ollama ps
```

## Benchmark / Use case thực tế

### Thông lượng một ngườ dùng (RTX 4090, Llama 3.1 8B)

| Công cụ | Format | Tokens/giây | Thờ gian thiết lập |
|------|--------|-----------|------------|
| Ollama | Q4_K_M | ~62 tok/s | < 2 phút |
| vLLM | FP16 | ~71 tok/s | ~10 phút |
| llama.cpp (CLI) | Q4_K_M | ~65 tok/s | ~5 phút |
| LocalAI | Q4_K_M | ~38 tok/s | ~15 phút |

*Nguồn: SitePoint benchmark, tháng 3/2026. Sinh một luồng, output 256 token.*

### Tải đồng thờ (50 ngườ dùng, RTX 4090)

| Công cụ | Tổng tok/s | p99 độ trễ | Kiến trúc |
|------|-----------|-------------|----------|
| Ollama | ~155 tok/s | ~24,7 giây | Hàng đợi FIFO |
| vLLM | ~920 tok/s | ~2,8 giây | Continuous batching |
| llama.cpp server | ~140 tok/s | ~26 giây | Hàng đợi FIFO |
| LocalAI | ~130 tok/s | ~28 giây | Hàng đợi FIFO |

*Ollama xử lý request tuần tự; continuous batching của vLLM mang lại thông lượng gấp 6 lần khi tải đồng thờ. Với một ngườ dùng, khoảng cách chỉ ~13%.*

### Bộ nhớ (Model 7B parameters)

| Công cụ | RAM nhàn rỗi | RAM khi load | Khởi động lạnh |
|------|----------|------------|------------|
| Ollama | 150 MB | 5,2 GB | 2 giây |
| vLLM | 400 MB | 5,5 GB | 5 giây |
| LocalAI | 400 MB | 5,5 GB | 8 giây |
| LM Studio | 800 MB | 5,8 GB | 5 giây |

### Các mẫu triển khai thực tế

1. **Developer cá nhân**: Ollama + Continue.dev cho lập trình AI-assisted. Độ trễ autocomplete < 50ms.
2. **Nhóm nhỏ (5–10 ngườ)**: Ollama trên workstation GPU chia sẻ + Open WebUI. Xử lý thoải mái ~50 request/giờ.
3. **Edge/Raspberry Pi 5**: Ollama chỉ CPU với Phi-4 Mini (3.8B). ~8 tok/s, chạy hoàn toàn offline.
4. **Pipeline CI/CD**: Ollama trong Docker cho code review tự động. Pull model `code-reviewer`, xử lý PR diff qua API.

## Sử dụng nâng cao / Production hardening

### Biến môi trường

```bash
# Cài đặt cốt lõi
OLLAMA_HOST=0.0.0.0:11434          # Bind tất cả interfaces
OLLAMA_KEEP_ALIVE=24h               # Giữ model loaded trong 24 giờ
OLLAMA_NUM_PARALLEL=4               # Request đồng thờ tối đa
OLLAMA_MAX_LOADED_MODELS=2          # Số model tối đa trong VRAM
OLLAMA_FLASH_ATTENTION=1            # Bật Flash Attention (inference nhanh hơn)

# Tune hiệu năng
OLLAMA_GPU_OVERHEAD=200MB           # Dự trữ VRAM
OLLAMA_DEBUG=1                      # Logging chi tiết
```

### Reverse proxy với Nginx

```nginx
server {
    listen 443 ssl http2;
    server_name ollama.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/ollama.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ollama.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:11434;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Hỗ trợ WebSocket cho streaming
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # Timeout cho inference chạy lâu
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
    }
}
```

### Xác thực API Key (không hỗ trợ native)

Ollama không có xác thực API key tích hợp. Thêm qua reverse proxy:

```python
# ollama-auth-proxy.py (Ví dụ Flask)
from flask import Flask, request, Response
import requests

app = Flask(__name__)
OLLAMA_URL = "http://localhost:11434"
VALID_KEYS = {"sk-your-api-key-here"}

@app.route('/', defaults={'path': ''}, methods=['GET', 'POST', 'PUT', 'DELETE'])
@app.route('/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def proxy(path):
    api_key = request.headers.get('Authorization', '').replace('Bearer ', '')
    if api_key not in VALID_KEYS:
        return {"error": "API key không hợp lệ"}, 401
    
    resp = requests.request(
        method=request.method,
        url=f"{OLLAMA_URL}/{path}",
        headers={k: v for k, v in request.headers if k != 'Host'},
        data=request.get_data(),
        stream=True
    )
    return Response(resp.iter_content(chunk_size=1024), status=resp.status_code,
                   content_type=resp.headers.get('Content-Type'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=11435)
```

### Giám sát với Prometheus

Ollama expose các metric cơ bản qua API:

```bash
# Liệt kê model đang chạy kèm mức sử dụng bộ nhớ
curl http://localhost:11434/api/ps
```

Cho production monitoring, wrap endpoint `api/ps` với Prometheus exporter hoặc dùng proxy [ollamaMQ](https://github.com/Chleba/ollamaMQ) có built-in metrics.

### Dịch vụ Systemd (Linux)

```ini
# /etc/systemd/system/ollama.service
[Unit]
Description=Dịch vụ Ollama LLM
After=network-online.target

[Service]
ExecStart=/usr/local/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_NUM_PARALLEL=4"
Environment="OLLAMA_KEEP_ALIVE=24h"

[Install]
WantedBy=default.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable ollama
sudo systemctl start ollama
```

## So sánh với các lựa chọn thay thế

| Tính năng | Ollama | llama.cpp | vLLM | LocalAI |
|---------|--------|-----------|------|---------|
| **GitHub Stars** | 137K+ | 75K+ | 45K+ | 35K+ |
| **Thờ gian thiết lập** | < 2 phút | ~5 phút | ~10 phút | ~15 phút |
| **tok/s một ngườ dùng** | ~62 (Q4) | ~65 (Q4) | ~71 (FP16) | ~38 (Q4) |
| **Batching đa ngườ dùng** | Hàng đợi FIFO | Hàng đợi FIFO | Continuous batching | Hàng đợi FIFO |
| **Thông lượng 50 ngườ dùng** | ~155 tok/s | ~140 tok/s | ~920 tok/s | ~130 tok/s |
| **Apple Silicon** | Native (MLX) | Native | Không | Qua Docker |
| **Modelfile/Dockerfile** | Có | Không | Không | Không |
| **Tương thích OpenAI API** | Một phần | Không | Đầy đủ | Đầy đủ |
| **API Embeddings** | Có | Không | Có | Có |
| **Tạo ảnh** | Không | Không | Không | Có (Stable Diffusion) |
| **Phù hợp nhất cho** | Dev/Prototype | Power users | Production serving | Multi-modal APIs |

*Benchmark: Llama 3.1 8B trên RTX 4090, tháng 3/2026. Nguồn: SitePoint, TowardsAI, LocalAI Master.*

### Khi nào chọn công cụ nào

- **Ollama**: Bắt đầu ở đây. Trải nghiệm developer tốt nhất, thiết lập nhanh nhất, hiệu năng một ngườ dùng xuất sắc. Dùng cho phát triển local, triển khai nhóm nhỏ, và thiết bị edge.
- **llama.cpp**: Chọn khi cần kiểm soát hoàn toàn parameters inference, custom kernels, hoặc tối ưu low-level. Phù hợp cho hệ thống nhúng compile từ source.
- **vLLM**: Chọn khi serve 5+ ngườ dùng đồng thờ với yêu cầu SLA. Continuous batching và PagedAttention mang lại thông lượng production-grade mà Ollama không thể đạt được ở quy mô lớn.
- **LocalAI**: Chọn khi cần replacement OpenAI hỗ trợ tạo ảnh (Stable Diffusion), speech-to-text (Whisper), và full API parity trong container.

## Hạn chế / Đánh giá trung thực

**Không có xác thực tích hợp.** Ollama giả định mạng local đáng tin cậy. Khi triển khai hướng internet, bạn phải thêm lớp xác thực (reverse proxy, API gateway, hoặc VPN). Đây là lỗi production phổ biến nhất.

**Không có continuous batching.** Dưới tải đồng thờ, Ollama xử lý request tuần tự. Với 50 ngườ dùng đồng thờ, p99 độ trễ đạt ~25 giây so với ~3 giây của vLLM. Không dùng Ollama làm production server đa ngườ dùng nếu chưa load test.

**Chỉ hỗ trợ format GGUF.** Ollama chỉ hỗ trợ model quantized GGUF. Nếu cần inference FP16, AWQ, hoặc GPTQ, hãy dùng vLLM hoặc Transformers trực tiếp.

**Không có quantization tích hợp.** Bạn không thể quantize model trong Ollama. Chuyển đổi model sang GGUF bên ngoài (dùng `llama.cpp/convert_hf_to_gguf.py` hoặc tương tự), rồi import qua `ollama create`.

**Quản lý bộ nhớ tĩnh.** `OLLAMA_MAX_LOADED_MODELS` kiểm soát số model resident, nhưng không có cân bằng VRAM động. Trên GPU 12 GB, load model 70B (kể cả Q4) sẽ gây OOM — Ollama không tự động offload layers sang CPU.

**Hỗ trợ tool calling hạn chế.** Dù tool calling có sẵn cho model tương thích (Llama 3.1+, Mistral), triển khai kém robust hơn function calling của OpenAI. Workflow tool phức tạp nhiều bước có thể cần xử lý fallback.

## Câu hỏi thường gặp

**Q: Cần bao nhiêu VRAM để chạy model 7B parameters?**
A: Model 7B quantized Q4_K_M cần khoảng 4,5–5 GB VRAM. Với quantization Q8, dự trù 7–8 GB. Inference chỉ CPU hoạt động với 16 GB RAM hệ thống nhưng chậm hơn khoảng 3–5 lần.

**Q: Có thể chạy Ollama không có GPU không?**
A: Có. Ollama tự động fallback sang CPU inference qua llama.cpp. Hiệu năng phụ thuộc vào CPU: Intel i7-13700K đạt ~8–12 tok/s với model 7B Q4. Apple Silicon M3 Pro đạt ~25 tok/s trên CPU/Neural Engine.

**Q: Làm sao cập nhật Ollama lên phiên bản mới nhất?**
A: Trên macOS, chạy `brew upgrade ollama`. Trên Linux, chạy lại script cài đặt: `curl -fsSL https://ollama.com/install.sh | sh`. Script sẽ giữ nguyên các model đã tải trong `~/.ollama/models/`.

**Q: Ollama có phù hợp cho production không?**
A: Với triển khai đơn mục đích (một model, một ngườ dùng, tải dự đoán được), có. Với production serving đa ngườ dùng, hãy cân nhắc thêm queuing proxy hoặc chuyển sang vLLM. Luôn thêm xác thực và monitoring trước khi expose ra mạng.

**Q: Có thể dùng model fine-tuned của riêng mình với Ollama không?**
A: Có. Chuyển model sang format GGUF, rồi tạo Modelfile trỏ đến nó bằng `FROM ./your-model.gguf`. Chạy `ollama create my-model -f Modelfile` và nó sẽ khả dụng qua API chuẩn.

**Q: Ollama so với OpenAI API về chất lượng output thì sao?**
A: Với base model tương đương (Llama 3.1 vs GPT-3.5), chất lượng output cạnh tranh trên các tác vụ coding và reasoning. Khoảng cách lớn hơn ở creative writing và reasoning nhiều bước, nơi GPT-4 và Claude 3.5 Sonnet vẫn dẫn đầu. Inference local loại bỏ độ trễ từ vòng lặp mạng.

**Q: Ollama có hỗ trợ vision model cho phân tích ảnh không?**
A: Có. Các vision model như LLaVA 1.7, Qwen2-VL và InternVL2.5 đã được hỗ trợ. Truyền dữ liệu ảnh dạng base64 trong request API chat. Lưu ý vision model cần nhiều VRAM hơn đáng kể (thêm ~2–4 GB).

## Kết luận

Ollama loại bỏ ma sát từ việc triển khai LLM local. Một lệnh để cài đặt, một lệnh để pull model, một lệnh để chạy. Hệ thống Modelfile cung cấp khả năng customize model có thể tái tạo. API tương thích OpenAI nghĩa là các tích hợp LangChain, Open WebUI và Continue.dev hiện có của bạn hoạt động chỉ với một thay đổi URL.

Với developer cá nhân và nhóm nhỏ, Ollama là điểm khởi đầu thực tế. Khi tải đồng thờ vượt quá ~5 ngườ dùng, hãy đánh giá vLLM. Khi cần hỗ trợ multi-modal vượt ra ngoài text, hãy đánh giá LocalAI. Nhưng hãy bắt đầu với Ollama — 137.000+ Stars phản ánh một công cụ thực sự thực hiện đúng lờ hứa của nó.

**Các bước tiếp theo:**
1. Cài đặt Ollama: `curl -fsSL https://ollama.com/install.sh | sh`
2. Chạy model đầu tiên: `ollama run llama3.2:8b`
3. Triển khai Open WebUI làm giao diện chat cho team
4. Tham gia [cộng đồng developer dibi8 trên Telegram](https://t.me/dibi8dev) để nhận mẹo triển khai LLM local và xử lý lỗi

*Khi phần cứng local không đủ, [DigitalOcean GPU Droplets](https://www.digitalocean.com) cung cấp các instance NVIDIA A100/H100 phù hợp tốt với triển khai Docker Ollama. Cho server bare-metal GPU chuyên dụng, [HTStack](https://htstack.com) có giá cạnh tranh cho node RTX 4090 và A100.*

*Công bố liên kết tiếp thị: Bài viết này chứa liên kết tiếp thị đến DigitalOcean và HTStack. Nếu bạn mua dịch vụ qua các liên kết này, dibi8 có thể nhận được hoa hồng mà không phát sinh thêm chi phí cho bạn.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn và Tài liệu tham khảo

- Tài liệu chính thức Ollama: https://docs.ollama.com
- Kho GitHub Ollama: https://github.com/ollama/ollama
- Thư viện model Ollama: https://ollama.com/search
- Tài liệu tham khảo REST API Ollama: https://docs.ollama.com/api
- Tài liệu tham khảo Modelfile: https://docs.ollama.com/modelfile
- SitePoint — Benchmark Ollama vs vLLM 2026: https://www.sitepoint.com/ollama-vs-vllm-performance-benchmark-2026/
- TowardsAI — Ollama vs vLLM vs llama.cpp: https://pub.towardsai.net/i-tested-ollama-vs-vllm-vs-llama-cpp-the-easiest-one-collapses-at-5-concurrent-users-d4f8e0e84886
- LocalAI Master — Ollama vs LocalAI: https://zenvanriel.com/ai-engineer-blog/ollama-vs-localai-comparison-local-model-deployment/
- Open WebUI GitHub: https://github.com/open-webui/open-webui
- Tích hợp LangChain Ollama: https://python.langchain.com/docs/integrations/chat/ollama
- Tài liệu Continue.dev: https://docs.continue.dev
