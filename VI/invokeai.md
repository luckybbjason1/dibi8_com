---
title: 'InvokeAI: 27.2K+ Stars — Hướng Dẫn Cài Đặt Đầy Đủ 2026'
description: 'InvokeAI (Invoke) là công cụ sáng tạo hàng đầu cho mô hình Stable Diffusion với WebUI dẫn đầu ngành. Tương thích với SD 1.5, SDXL, FLUX và ControlNet. Bao gồm cài đặt Docker, thiết lập workflow, so sánh benchmark với AUTOMATIC1111 và ComfyUI, và hardening production.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/invoke-ai/InvokeAI'
stars: 27200
maintainer: 'invoke-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['InvokeAI', 'Stable Diffusion', 'Tạo ảnh AI', 'Docker', 'FLUX', 'SDXL', 'WebUI', 'mã nguồn mở']
aliases:
- /vi/posts/invokeai/
---

{{</* resource-info */>}}

![InvokeAI Logo](https://raw.githubusercontent.com/invoke-ai/InvokeAI/main/invokeai/assets/invokeai-logo.png)

## Giới thiệu

Mọi lập trình viên đã thử chạy Stable Diffusion locally đều biết điều này: xung đột dependency, phiên bản CUDA không khớp, thiếu file cấu hình model, và các WebUI trông như thể được thiết kế từ năm 2003. Kể từ năm 2022, lĩnh vực tạo ảnh AI mã nguồn mở đã trưởng thành đáng kể, nhưng khoảng cách giữa "chạy được trên máy tôi" và triển khai production-ready vẫn còn lớn. InvokeAI, với 27.2K+ sao trên GitHub và bản phát hành v6.12.0 vào tháng 3/2026, đã thu hẹp khoảng cách đó. Nó kết hợp WebUI chuyên nghiệp với engine workflow dạng node, hỗ trợ đa ngườ dùng, và triển khai Docker — tất cả dưới giấy phép Apache-2.0. Hướng dẫn này đi qua cài đặt InvokeAI qua Docker và bare metal, tích hợp với Stable Diffusion và ControlNet, và chạy trong môi trường production.

## InvokeAI là gì?

InvokeAI là một creative engine mã nguồn mở miễn phí để tạo ảnh bằng AI dựa trên các mô hình Stable Diffusion. Nó cung cấp giao diện web với trình chỉnh sửa canvas chuyên nghiệp, trình xây dựng workflow dạng node, và hệ thống quản lý model — phục vụ cả nghệ sĩ cá nhân lẫn các team cần pipeline tạo ảnh AI tự host, sẵn sàng cho production.

## InvokeAI hoạt động như thế nào?

InvokeAI tuân theo kiến trúc client-server module. Backend là máy chủ API dựa trên Python (`invokeai.app.api_app`) xử lý việc tải model, tạo ảnh, và quản lý hàng đợi. Frontend là ứng dụng single-page dựa trên React cung cấp canvas, gallery, và trình chỉnh sửa workflow.

**Các thành phần cốt lõi:**

- **Web Server & React UI** — Chạy trên cổng 9090 theo mặc định, cung cấp giao diện tạo ảnh đầy đủ
- **Unified Canvas** — Canvas dạng layer với inpainting, outpainting, công cụ brush, và chỉnh sửa image-to-image
- **Node-based Workflows** — Trình xây dựng pipeline trực quan cho các pipeline có thể tái tạo và chia sẻ
- **Model Manager** — Tải và quản lý model tích hợp cho SD 1.5, SDXL, FLUX, Z-Image, và checkpoint tùy chỉnh
- **Gallery & Boards** — Lưu trữ ảnh có tổ chức với bảo toàn metadata và hỗ trợ kéo-thả
- **Queue System** — Xử lý job nền cho tạo ảnh hàng loạt và thực thi workflow

## Cài đặt & Thiết lập

### Phương pháp 1: Docker (Khuyến nghị cho Production)

Docker là con đường nhanh nhất để thiết lập InvokeAI production-grade. Các image chính thức hỗ trợ NVIDIA (CUDA), AMD (ROCm), và chế độ CPU-only.

**Yêu cầu:**
- Docker Engine 24.0+ với BuildKit được bật
- Docker Compose plugin (V2)
- NVIDIA Container Toolkit (cho GPU) hoặc ROCm Docker runtime (cho AMD)
- 16GB+ RAM, 20GB+ dung lượng đĩa trống

**Bước 1 — Clone repository:**

```bash
git clone https://github.com/invoke-ai/InvokeAI.git
cd InvokeAI/docker
```

**Bước 2 — Cấu hình môi trường:**

```bash
cp .env.sample .env
```

Chỉnh sửa file `.env`:

```bash
# Cấu hình cốt lõi
INVOKEAI_ROOT=/opt/invokeai-data
INVOKEAI_PORT=9090
GPU_DRIVER=cuda
CONTAINER_UID=1000
HUGGINGFACE_TOKEN=hf_your_token_here
```

**Bước 3 — Khởi động container:**

```bash
./run.sh
```

Hoặc dùng `docker compose` trực tiếp:

```bash
docker compose up -d
```

Truy cập UI tại `http://localhost:9090`.

### Chạy Docker Nhanh (Không cần Compose)

Để test nhanh không cần lưu trữ dữ liệu:

```bash
# NVIDIA GPU
docker run --runtime=nvidia --gpus=all \
  --publish 9090:9090 \
  ghcr.io/invoke-ai/invokeai:latest

# AMD GPU
docker run --device /dev/kfd --device /dev/dri \
  --publish 9090:9090 \
  ghcr.io/invoke-ai/invokeai:main-rocm

# Có lưu trữ dữ liệu
docker run --runtime=nvidia --gpus=all \
  --publish 9090:9090 \
  --volume /mnt/invokeai-data:/invokeai \
  ghcr.io/invoke-ai/invokeai:latest
```

### Phương pháp 2: Bare Metal (Linux/macOS)

**Bước 1 — Cài đặt launcher:**

```bash
pip install invokeai
```

**Bước 2 — Chạy trình hướng dẫn cấu hình:**

```bash
invokeai-configure
```

Trình hướng dẫn tương tác này cài đặt đúng phiên bản PyTorch, tải model mặc định, và cấu hình thư mục runtime.

**Bước 3 — Khởi động WebUI:**

```bash
invokeai-web
```

### Phương pháp 3: Cloud VPS (DigitalOcean)

Với các team không có phần cứng GPU local, instance cloud GPU cung cấp quyền truy cập InvokeAI đầy đủ. DigitalOcean GPU Droplets với card NVIDIA A10G hoặc H100 hoạt động tốt.

```bash
# Trên Droplet GPU Ubuntu 24.04 mới
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable --now docker

# Cài đặt NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update && sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# Triển khai InvokeAI
git clone https://github.com/invoke-ai/InvokeAI.git
cd InvokeAI/docker
cp .env.sample .env
# Chỉnh sửa .env: đặt INVOKEAI_ROOT và HUGGINGFACE_TOKEN
sudo docker compose up -d
```

*Hướng dẫn này có chứa liên kết liên kết đến DigitalOcean. Đăng ký qua các liên kết này hỗ trợ trang web mà không phát sinh chi phí thêm cho bạn.*

### Tham khảo docker-compose.yml cho Production

```yaml
# Copyright (c) 2023 Eugene Brodsky https://github.com/ebr

x-invokeai: &invokeai
    image: "ghcr.io/invoke-ai/invokeai:latest"
    build:
      context: ..
      dockerfile: docker/Dockerfile
    env_file:
      - .env
    environment:
      - INVOKEAI_ROOT=${CONTAINER_INVOKEAI_ROOT:-/invokeai}
      - HF_HOME
    ports:
      - "${INVOKEAI_PORT:-9090}:${INVOKEAI_PORT:-9090}"
    volumes:
      - type: bind
        source: ${HOST_INVOKEAI_ROOT:-${INVOKEAI_ROOT:-~/invokeai}}
        target: ${CONTAINER_INVOKEAI_ROOT:-/invokeai}
        bind:
          create_host_path: true
      - ${HF_HOME:-~/.cache/huggingface}:${HF_HOME:-/invokeai/.cache/huggingface}
    tty: true
    stdin_open: true

services:
  invokeai-cuda:
    <<: *invokeai
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

  invokeai-cpu:
    <<: *invokeai
    profiles:
      - cpu

  invokeai-rocm:
    <<: *invokeai
    environment:
      - AMD_VISIBLE_DEVICES=all
      - RENDER_GROUP_ID=${RENDER_GROUP_ID}
    runtime: amd
    profiles:
      - rocm
```

## Tích hợp với Stable Diffusion, ComfyUI và ControlNet

### Sử dụng mô hình Stable Diffusion

InvokeAI hỗ trợ nhiều họ mô hình ngay từ đầu:

- **SD 1.5** — Các mô hình cổ điển, hệ sinh thái LoRA rộng lớn
- **SDXL** — Độ phân giải cao hơn, tuân thủ prompt tốt hơn
- **FLUX / FLUX.2** — Chất lượng tiên tiến nhất (2025-2026)
- **Z-Image** — Các mô hình undistilled thân thiện với fine-tuning

**Thêm model qua Model Manager:**

1. Mở WebUI → tab Model Manager
2. Click "Install Model" → dán URL Hugging Face hoặc đường dẫn local
3. Model sẽ tự động tải xuống và chuyển đổi

**Thêm model thủ công:**

```bash
# Sao chép file .safetensors hoặc .ckpt vào thư mục model
cp your-model.safetensors /opt/invokeai-data/models/sd-1/main/

# Khởi động lại container
docker compose restart
```

### Tích hợp ControlNet

InvokeAI có hỗ trợ ControlNet gốc thông qua node workspace. Các bộ xử lý có sẵn bao gồm depth map, Canny edges, OpenPose, segmentation, v.v.

**Sử dụng ControlNet trong workflow:**

1. Mở tab Workflow trong UI
2. Thêm node ControlNet từ thư viện node
3. Kết nối model cơ sở và ảnh tham chiếu
4. Chọn bộ tiền xử lý (Canny, Depth, OpenPose, v.v.)
5. Đặt cường độ điều khiển (khuyến nghị 0.5–1.0)
6. Đưa vào hàng đợi để tạo

### Nhập workflow ComfyUI

Mặc dù InvokeAI và ComfyUI sử dụng định dạng workflow khác nhau, bạn có thể tái tạo các pipeline ComfyUI trong trình chỉnh sửa node của InvokeAI. Thư viện node bao gồm:

- KSampler / Sampler nodes
- CLIP Text Encode
- VAELoader / VAEDecode
- Image Scale nodes
- ControlNet processors

```python
# Ví dụ: Thiết lập tham số tạo ảnh qua REST API của InvokeAI (v6.12.0+)
import requests

response = requests.post(
    "http://localhost:9090/api/v1/sessions",
    json={
        "model": "stable-diffusion-xl-base-1.0",
        "width": 1024,
        "height": 1024,
        "steps": 30,
        "cfg_scale": 7.5,
        "scheduler": "euler_a",
        "positive_prompt": "Thành phố cyberpunk về đêm, đèn neon, chi tiết cao",
        "negative_prompt": "mờ, chất lượng thấp, méo mó"
    }
)
print(response.json()["session_id"])
```

## Benchmark / Các trường hợp sử dụng thực tế

### Tốc độ tạo ảnh SDXL (RTX 3060 Ti, 8GB VRAM)

| Nền tảng | 768×1024 (trung bình) | 1024×1024 (trung bình) | Ghi chú |
|----------|----------------------|------------------------|---------|
| **InvokeAI** | 18.83 giây | 24.44 giây | UI chuyên nghiệp, hệ thống queue |
| **ComfyUI** | 16.16 giây | 21.47 giây | Tạo ảnh thô nhanh nhất |
| **AUTOMATIC1111** | 27.33 giây | 36.00 giây | Overhead VRAM cao nhất |
| **Fooocus** | ~22 giây | ~28 giây | Chỉ tối ưu cho SDXL |

*Nguồn: Benchmark độc lập, Ryzen 5800X + RTX 3060 Ti, 30 bước, Euler ancestral, CFG 7, model MBB XL.*

### So sánh sử dụng VRAM (FLUX Dev, 1024×1024)

| Nền tảng | Sử dụng VRAM | Ghi chú |
|----------|-------------|---------|
| InvokeAI | 14.2 GB | Cache model hiệu quả |
| ComfyUI | 13.8 GB | Overhead thấp nhất |
| AUTOMATIC1111 | 16.1 GB | Kiến trúc monolithic |
| Fooocus | 12.5 GB | Giới hạn workflow SDXL |

### Các trường hợp sử dụng production thực tế

**Trường hợp 1: Studio thiết kế (20 chỗ ngồi)**
- Triển khai InvokeAI v6.12.0 trên workstation RTX 4090 đơn
- Chế độ đa ngườ dùng với gallery riêng cho mỗi designer
- 150+ ảnh/ngày qua workflow SDXL và FLUX
- Hệ thống hàng đợi ngăn xung đột tạo ảnh

**Trường hợp 2: Chụp ảnh sản phẩm thương mại điện tử**
- Xóa phông nền tự động qua Canvas inpainting
- Xử lý hàng loạt 500+ ảnh sản phẩm/tuần
- Workflow tùy chỉnh cho ánh sáng và góc chụp nhất quán
- Model Manager đơn giản hóa việc chuyển đổi giữa danh mục sản phẩm

**Trường hợp 3: Pipeline asset game**
- Workflow dạng node để tạo texture
- ControlNet depth map cho texturing 3D-aware
- Mô hình FLUX cho portrait nhân vật chi tiết cao
- Tích hợp với quản lý asset hiện có qua REST API

## Sử dụng nâng cao / Hardening Production

### Chế độ đa ngườ dùng (v6.12.0+)

InvokeAI hiện hỗ trợ nhiều tài khoản riêng biệt trên một backend:

```bash
# Bật chế độ đa ngườ dùng trong .env
INVOKEAI_ENABLE_MULTIUSER=true
```

Mỗi ngườ dùng có:
- Board ảnh và gallery riêng
- Trạng thái canvas độc lập
- Tùy chỉnh UI riêng
- Phân quyền dựa trên vai trò (admin vs ngườ dùng thường)

Admin quản lý model và session queue; ngườ dùng thường không thể thêm hoặc xóa model hệ thống.

### Reverse Proxy với SSL

```nginx
# Cấu hình Nginx cho production
server {
    listen 443 ssl http2;
    server_name invokeai.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:9090;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 86400;
    }
}
```

### Dịch vụ systemd

```ini
# /etc/systemd/system/invokeai.service
[Unit]
Description=InvokeAI Creative Engine
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/InvokeAI/docker
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

Kích hoạt và khởi động:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now invokeai
```

### Giám sát với Prometheus

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9091:9090"

  dcgm-exporter:
    image: nvcr.io/nvidia/k8s/dcgm-exporter:latest
    runtime: nvidia
    ports:
      - "9400:9400"
```

### Sao lưu tự động

```bash
#!/bin/bash
# /opt/invokeai-backup/backup.sh
BACKUP_DIR="/backups/invokeai"
DATE=$(date +%Y%m%d-%H%M%S)

# Sao lưu ảnh đã tạo và model
tar czf "$BACKUP_DIR/images-$DATE.tar.gz" /opt/invokeai-data/images
tar czf "$BACKUP_DIR/models-$DATE.tar.gz" /opt/invokeai-data/models

# Giữ lại 7 ngày gần nhất
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete
```

Thêm vào crontab:

```bash
0 2 * * * /opt/invokeai-backup/backup.sh
```

## So sánh với các giải pháp thay thế

| Tính năng | InvokeAI | AUTOMATIC1111 | ComfyUI | Fooocus |
|-----------|----------|---------------|---------|---------|
| **Độ hoàn thiện WebUI** | Chuyên nghiệp, thiết kế cho creatives | Đầy đủ chức năng nhưng lỗi thờ | Tối giản, tập trung node | Tối giản, tập trung prompt |
| **Workflow dạng node** | Có, trình chỉnh sửa trực quan | Không (dựa trên extension) | Có, native | Không |
| **Canvas (In/Outpainting)** | Canvas layer đầy đủ | Inpainting cơ bản | Qua custom node | Hạn chế |
| **Hỗ trợ đa ngườ dùng** | Native (v6.12.0+) | Không | Không | Không |
| **Hỗ trợ model** | SD 1.5, SDXL, FLUX, Z-Image | SD 1.5, SDXL, FLUX (qua ext) | Tất cả (qua custom node) | Chỉ SDXL |
| **Thờ gian setup lần đầu** | 15 phút (Docker) | 10 phút | 15 phút | 5 phút |
| **REST API** | API đầy đủ | Một phần | Không có API native | Không |
| **Hiệu quả VRAM** | Tốt (FLUX 14.2 GB) | Kém (FLUX 16.1 GB) | Tốt nhất (FLUX 13.8 GB) | Tốt (SDXL 12.5 GB) |
| **Quản lý Gallery** | Boards, tags, metadata | Trình duyệt file cơ bản | Không | Cơ bản |
| **Giấy phép** | Apache-2.0 | AGPL-3.0 | GPL-3.0 | GPL-3.0 |
| **Sao GitHub** | 27.2K | 75K+ | 75K+ | 40K+ |

## Hạn chế / Đánh giá trung thực

**InvokeAI không phù hợp với:**

1. **Tạo ảnh casual một click** — Nếu bạn chỉ muốn gõ prompt và nhận ảnh, Fooocus thiết lập và sử dụng nhanh hơn. Sức mạnh của InvokeAI đi kèm với đường cong học tập.

2. **Pipeline thử nghiệm cao** — Hệ sinh thái node của ComfyUI lớn hơn và tiên tiến hơn. Các triển khai nghiên cứu mới (ví dụ: tạo video, 3D) thường ra mắt trên ComfyUI trước.

3. **VRAM dưới 8GB** — Các tính năng UI chuyên nghiệp của InvokeAI tiêu tốn thêm bộ nhớ. Với card 6-8GB, ComfyUI hoặc Forge cho hiệu suất tốt hơn. InvokeAI khuyến nghị 12GB+ VRAM cho workflow FLUX thoải mái.

4. **Tăng tốc GPU trên macOS** — Docker trên macOS không hỗ trợ GPU passthrough. Cài đặt native hoạt động nhưng chỉ chạy CPU và chậm đáng kể. Ngườ dùng Apple Silicon có thể thích DiffusionBee hoặc ComfyUI native hơn.

5. **Chỉnh sửa cộng tác real-time** — Chế độ đa ngườ dùng tách biệt ngườ dùng nhưng không hỗ trợ cộng tác canvas đồng thờ. Mỗi ngườ dùng làm việc độc lập.

## Câu hỏi thường gặp

### Chạy InvokeAI cần phần cứng gì?

Tối thiểu: 8GB VRAM (NVIDIA RTX 3060 trở lên), 16GB RAM, 50GB dung lượng đĩa trống. Khuyến nghị: 12GB+ VRAM (RTX 3060 Ti / 4060 Ti), 32GB RAM, lưu trữ SSD. Cho model FLUX: 16GB+ VRAM (RTX 4080 / 4090). InvokeAI hỗ trợ NVIDIA CUDA, AMD ROCm, và fallback CPU-only.

### Chạy InvokeAI không có GPU được không?

Được, InvokeAI chạy trên hệ thống CPU-only nhưng tạo ảnh chậm hơn 10-20 lần. Dùng CPU Docker profile: `docker compose --profile cpu up -d`. Kỳ vọng 2-5 phút cho mỗi ảnh 1024×1024 trên CPU 8 nhân hiện đại. Phù hợp để test nhưng không cho production.

### InvokeAI xử lý giấy phép model như thế nào?

InvokeAI có giấy phép Apache-2.0. Các model bạn tải xuống (SD 1.5, SDXL, FLUX) có giấy phép riêng. Model Manager của InvokeAI hiển thị thông tin giấy phép trước khi tải. Sử dụng thương mại phụ thuộc vào giấy phép model cụ thể — luôn xác minh trước khi triển khai production.

### Có thể migrate từ AUTOMATIC1111 sang InvokeAI không?

Được. InvokeAI có thể sử dụng các model `.safetensors` và `.ckpt` hiện có từ cài đặt A1111. Chỉ `INVOKEAI_ROOT` đến thư mục model hiện có, hoặc sao chép model vào thư mục model của InvokeAI. Lưu ý các extension và script A1111 không chuyển đổi — InvokeAI dùng hệ thống workflow dạng node riêng.

### Làm sao cập nhật InvokeAI lên phiên bản mới?

Với cài đặt Docker, pull image mới nhất và khởi động lại:

```bash
cd InvokeAI/docker
docker compose pull
docker compose up -d
```

Với cài đặt bare metal, dùng launcher:

```bash
invokeai-update
```

Luôn sao lưu thư mục `INVOKEAI_ROOT` trước khi cập nhật phiên bản lớn.

### Có phiên bản hosted/cloud của InvokeAI không?

InvokeAI chủ yếu là tự host. Các nhà phát triển cung cấp Invoke for Teams (sản phẩm thương mại) thêm cloud hosting, cộng tác team, và hỗ trợ doanh nghiệp. Ngườ dùng cá nhân thường tự host trên GPU local hoặc cloud VPS (DigitalOcean, RunPod).

### Chế độ đa ngườ dùng trong v6.12.0 hoạt động thế nào?

Chế độ đa ngườ dùng tạo các tài khoản riêng biệt với gallery, trạng thái canvas, và tùy chọn riêng. Tài khoản admin quản lý model và cài đặt hệ thống. Bật bằng `INVOKEAI_ENABLE_MULTIUSER=true`. Mỗi ngườ dùng đăng nhập bằng tên ngườ dùng và mật khẩu. Được đánh dấu là thử nghiệm trong v6.12.0 — sẽ cải thiện trong các bản phát hành tới.

## Kết luận

InvokeAI lấp đầy một phân khúc cụ thể trong hệ sinh thái tạo ảnh AI: một công cụ sáng tạo chuyên nghiệp, tự host kết hợp sức mạnh của Stable Diffusion với trải nghiệm ngườ dùng tinh tế. Bản phát hành v6.12.0 mang đến hỗ trợ đa ngườ dùng, khả năng tương thích FLUX mở rộng, và quản lý gallery cải tiến — khiến nó phù hợp với các studio nhỏ và team thiết kế. Triển khai dựa trên Docker đơn giản, hệ thống workflow dạng node mạnh mẽ, và giấy phép Apache-2.0 cho phép sử dụng thương mại không hạn chế.

**Các bước tiếp theo:**
1. Clone repository và chạy Docker setup local
2. Cài đặt model SDXL hoặc FLUX đầu tiên qua Model Manager
3. Xây dựng workflow dạng node cho trường hợp sử dụng cụ thể
4. Tham gia cộng đồng: [InvokeAI Discord](https://discord.gg/ZmtBAhwWhy)

Theo dõi kênh Telegram của chúng tôi để cập nhật công cụ AI mã nguồn mở hàng tuần: [dibi8 announcements](https://t.me/dibi8com)



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [InvokeAI GitHub Repository](https://github.com/invoke-ai/InvokeAI)
- [InvokeAI Tài liệu chính thức](https://invoke.ai/)
- [InvokeAI v6.12.0 Release Notes](https://invoke.ai/releases/version/v6-12-0/)
- [InvokeAI Docker Setup Guide](https://github.com/invoke-ai/InvokeAI/tree/main/docker)
- [NVIDIA Container Toolkit Cài đặt](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- [AMD ROCm Docker Tài liệu](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/docker.html)
- [SDXL Speed Test: InvokeAI vs ComfyUI vs A1111](https://lilys.ai/en/notes/comfyui-20260115/sdxl-speed-test-comfyui-invokeai-a1111)
- [ComfyUI vs InvokeAI vs Fooocus So sánh](https://toolhalla.ai/blog/comfyui-vs-invokeai-vs-fooocus-2026)
- [InvokeAI PyPI Package](https://pypi.org/project/InvokeAI/)

---

*Bài viết này chứa liên kết liên kết đến DigitalOcean. Nếu bạn đăng ký qua các liên kết này, chúng tôi nhận được hoa hồng mà không phát sinh chi phí thêm cho bạn. Điều này giúp hỗ trợ trang web và nội dung mã nguồn mở của chúng tôi. Tất cả ý kiến và benchmark đều được sản xuất độc lập.*
