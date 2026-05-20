---
title: 'Stable Diffusion WebUI: 159K+ Stars — Hướng Dẫn Cài Đặt Đầy Đủ 2026'
description: 'Stable Diffusion WebUI (AUTOMATIC1111) là giao diện web tạo ảnh AI cục bộ phổ biến nhất. Tương thích với ControlNet, LoRA, ComfyUI. Bao gồm cài đặt Windows, Linux, Docker, cấu hình mở rộng, tối ưu production và benchmark GPU.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/AUTOMATIC1111/stable-diffusion-webui'
stars: 159000
maintainer: 'AUTOMATIC1111'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['stable-diffusion', 'automatic1111', 'tạo-ảnh', 'ai-webui', 'controlnet', 'lora', 'docker', 'gpu']
aliases:
- /vi/posts/stable-diffusion-webui/
---

{{</* resource-info */>}}

Stable Diffusion WebUI do AUTOMATIC1111 phát triển vẫn là giao diện mã nguồn mở được sử dụng rộng rãi nhất cho việc tạo ảnh AI cục bộ. Với **159,000+ GitHub stars**, nó tích lũy được cộng đồng lớn hơn bất kỳ giao diện cạnh tranh nào. Nếu bạn đang xây dựng pipeline tạo ảnh AI cục bộ, việc hiểu cách cài đặt, cấu hình và mở rộng công cụ này là kỹ năng thiết yếu.

Hướng dẫn này sẽ đi qua toàn bộ quá trình cài đặt Stable Diffusion WebUI trên Windows, Linux và Docker. Bạn sẽ tìm thấy lệnh thực tế cho từng nền tảng, cấu hình mở rộng cho ControlNet và LoRA, mẹo tối ưu production và benchmark hiệu suất trên GPU phổ thông.

![Giao diện Stable Diffusion WebUI](https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/screenshot.png)
*Giao diện txt2img mặc định của Stable Diffusion WebUI v1.10.1*

## Stable Diffusion WebUI Là Gì?

Stable Diffusion WebUI là giao diện dựa trên trình duyệt để chạy các mô hình Stable Diffusion cục bộ. Nó bao bọc pipeline suy luận bên dưới trong ứng dụng web dạng tab có thể truy cập tại `http://localhost:7860`, cung cấp điều khiển cho txt2img, img2img, inpainting, upscaling, model merging và training LoRA/DreamBooth —— tất cả mà không cần viết code.

Dự án được duy trì bởi AUTOMATIC1111 theo giấy phép AGPL-3.0. Phiên bản v1.10.1 (phát hành đầu 2025) đã cải thiện quá trình tinh chỉnh SDXL, tối ưu quản lý bộ nhớ cho GPU 8GB và thêm hỗ trợ native cho suy luận SD3 Medium. Hệ sinh thái mở rộng bao gồm hơn 1,000 plugin cộng đồng.

## Stable Diffusion WebUI Hoạt Động Như Thế Nào?

Kiến trúc theo mẫu Python backend module hóa + Gradio frontend:

![WebUI Architecture Flow](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/images/webui_arch.png)
*Kiến trúc: Gradio frontend giao tiếp với Python backend module qua HTTP cục bộ*

```
Trình duyệt ngườI dùng (Gradio UI)
    |
    v
Gradio Server (cổng 7860) --- API Endpoints (/sdapi/v1/)
    |
    v
Python Backend (modules/)
    |-- Model Loader (safetensors/ckpt)
    |-- Sampling (Euler, DPM++, etc.)
    |-- VAE Encode/Decode
    |-- Post-processing (GFPGAN, CodeFormer)
    |
    v
PyTorch + CUDA --- GPU (VRAM: 4-24GB)
```

Các khái niệm quan trọng cần hiểu trước khi cài đặt:

- **Checkpoint**: File mô hình chính (`.safetensors` hoặc `.ckpt`) chứa trọng số diffusion đã huấn luyện. Mô hình SD 1.5 khoảng 4GB; SDXL khoảng 6-7GB.
- **VAE**: Xử lý bước encode/decode giữa không gian pixel và latent. VAE không khớp sẽ tạo ra đầu ra mờ hoặc xỉn màu.
- **Sampler**: Thuật toán khử nhiễu dần dần. DPM++ 2M Karras là lựa chọn được khuyến nghị nhiều nhất.
- **CFG Scale**: Điều khiển mức độ tuân thủ prompt. Giá trị 7-9 phù hợp với hầu hết trường hợp.
- **Extensions**: Plugin Python được tải tại runtime. ControlNet và Adetailer là phổ biến nhất.

## Cài Đặt & Thiết Lập

### Yêu Cầu Hệ Thống

| Thành phần | Tối thiểu | Khuyến nghị |
|-----------|-----------|-------------|
| GPU | NVIDIA 4GB VRAM | NVIDIA RTX 3060 12GB+ |
| RAM | 8GB | 16GB |
| Lưu trữ | 20GB SSD | 100GB SSD (cho models) |
| OS | Windows 10 / Ubuntu 20.04 | Windows 11 / Ubuntu 22.04 |
| Python | 3.10.6 | 3.10.11 |

### Cài Đặt Windows (Tự động)

```batch
:: Tải sd.webui.zip từ trang releases
:: Giải nén tại C:\stable-diffusion-webui
:: Chạy updater trước
cd C:\stable-diffusion-webui
update.bat

:: KhởI chạy WebUI
run.bat
```

### Tham số dòng lệnh Windows

Chỉnh sửa `webui-user.bat`:

```batch
@echo off

set PYTHON=python
set GIT=git
set VENV_DIR=venv
set COMMANDLINE_ARGS=--xformers --autolaunch --update-check

:: Tùy chọn tối ưu VRAM (chọn MỘT):
:: set COMMANDLINE_ARGS=--medvram    &:: GPU 8GB
:: set COMMANDLINE_ARGS=--lowvram    &:: GPU 4GB  
:: set COMMANDLINE_ARGS=--normalvram &:: GPU 12GB+

:: RTX 40-series thêm --xformers để tăng 20-30% tốc độ

call webui.bat
```

### Cài Đặt Linux (Thủ công)

```bash
# Cài dependencies (Ubuntu/Debian)
sudo apt update && sudo apt install -y wget git python3 python3-venv libgl1 libglib2.0-0

# Clone repository
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

# Tạo môi trường ảo và cài đặt
python3 -m venv venv
source venv/bin/activate
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt

# KhởI chạy
./webui.sh --xformers --listen
```

### Cài Đặt Docker (Khuyến nghị cho Production)

```dockerfile
# Dockerfile.stable-diffusion-webui
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv git wget \
    libgl1 libglib2.0-0 libsm6 libxext6 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash sduser
WORKDIR /home/sduser

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /home/sduser/stable-diffusion-webui

RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121 && \
    pip install -r requirements.txt

RUN chown -R sduser:sduser /home/sduser
USER sduser

EXPOSE 7860

ENTRYPOINT ["bash", "-c", \". venv/bin/activate && python3 launch.py --listen --api --xformers"]
```

Build và chạy:

```bash
# Build image
docker build -f Dockerfile.stable-diffusion-webui -t sd-webui:latest .

# Chạy với GPU và persistent model
docker run -d \
  --name stable-diffusion-webui \
  --gpus all \
  -p 7860:7860 \
  -v $(pwd)/models:/home/sduser/stable-diffusion-webui/models/Stable-diffusion \
  -v $(pwd)/outputs:/home/sduser/stable-diffusion-webui/outputs \
  -v $(pwd)/extensions:/home/sduser/stable-diffusion-webui/extensions \
  -e NVIDIA_VISIBLE_DEVICES=all \
  sd-webui:latest
```

Docker Compose:

```yaml
# docker-compose.yml
version: '3.8'

services:
  stable-diffusion-webui:
    build:
      context: .
      dockerfile: Dockerfile.stable-diffusion-webui
    container_name: sd-webui
    runtime: nvidia
    ports:
      - "7860:7860"
    volumes:
      - ./models:/home/sduser/stable-diffusion-webui/models/Stable-diffusion
      - ./outputs:/home/sduser/stable-diffusion-webui/outputs
      - ./extensions:/home/sduser/stable-diffusion-webui/extensions
      - ./vae:/home/sduser/stable-diffusion-webui/models/VAE
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    restart: unless-stopped
```

Triển khai:

```bash
docker-compose up -d
```

### Cài Đặt trên Cloud GPU với Hostinger

Nếu phần cứng cục bộ không đủ mạnh, [Hostinger VPS](https://www.hostinger.vn/vps-hosting) cung cấp máy chủ ảo với hiệu suất cao phù hợp cho việc chạy Stable Diffusion WebUI. Hostinger có giá cả cạnh tranh và hỗ trợ khách hàng bằng tiếng Việt.

```bash
# Trên Hostinger VPS (Ubuntu 22.04)
sudo apt update && sudo apt install -y git wget

# Clone và cấu hình
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

# Cài đặt với CUDA 12
python3 -m venv venv
source venv/bin/activate
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt

# KhởI chạy
python3 launch.py --listen --port 7860 --xformers --gradio-auth admin:matkhau123
```

*Tuyên bố: Liên kết Hostinger là liên kết affiliate. Chúng tôi có thể nhận hoa hồng nếu bạn đăng ký qua các liên kết này —— không phát sinh chi phí thêm cho bạn và giúp hỗ trợ nội dung mã nguồn mở của chúng tôi.*

## Tích Hợp với ControlNet, LoRA và Công Cụ Phổ Biến

### Cài Đặt ControlNet

ControlNet cho phép tạo ảnh có kiểm soát cấu trúc:

![Giao diện ControlNet](https://github.com/Mikubill/sd-webui-controlnet/wiki/images/controlnet_ui.png)
*Panel mở rộng ControlNet trong tab txt2img của WebUI*

```bash
# Cài qua tab Extensions (khuyến nghị)
# 1. Mở WebUI → Extensions → Available
# 2. Click "Load from"
# 3. Tìm "ControlNet"
# 4. Click Install
# 5. Restart UI

# Hoặc cài thủ công:
cd extensions
git clone https://github.com/Mikubill/sd-webui-controlnet.git
```

Tải models ControlNet:

```bash
# Models ControlNet cơ bản (SD 1.5)
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth

# Models ControlNet SDXL
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_canny_mid.safetensors
```

### Tích Hợp LoRA

```bash
# Tải LoRA vào thư mục models/Lora/
wget -P models/Lora/ "https://civitai.com/api/download/models/12345"
```

Sử dụng LoRA trong prompt:

```
<lora:add-detail-xl:1.0>, masterpiece, best quality, portrait of a warrior
<lora:epiCRealismHelper:0.6>, photorealistic, 8k uhd
```

Cú pháp: `<lora:filename:weight>`, weight từ 0.0 đến 1.0.

### Cầu Nối ComfyUI

```bash
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt

# Chia sẻ thư mục models
ln -s /path/to/stable-diffusion-webui/models/Stable-diffusion models/checkpoints
ln -s /path/to/stable-diffusion-webui/models/Lora models/loras

python main.py --port 8188
```

### Danh Sách Extensions Thiết Yếu

```bash
cd extensions

# Adetailer - sửa mặt/tay tự động
git clone https://github.com/Bing-su/adetailer.git

# Ultimate SD Upscale
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git

# Tiled VAE - giảm VRAM
git clone https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111.git

# Tag Autocomplete
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git

# System Info + Benchmark
git clone https://github.com/vladmandic/sd-extension-system-info.git
```

## Benchmark / Use Case Thực Tế

### So Sánh Hiệu Suất GPU

| GPU | VRAM | SD 1.5 512x512 | SDXL 1024x1024 | SDXL + ControlNet |
|-----|------|----------------|----------------|-------------------|
| RTX 4060 Ti 16GB | 16 GB | ~4.2s | ~12.0s | ~16.5s |
| RTX 3090 | 24 GB | ~2.4s | ~5.6s | ~9.2s |
| RTX 4090 | 24 GB | ~1.1s | ~3.2s | ~4.8s |
| RTX 5090 | 32 GB | ~0.8s | ~2.2s | ~3.5s |

### VRAM Theo Workflow

| Workflow | VRAM (RTX 4090) | Ghi chú |
|----------|----------------|---------|
| txt2img SD 1.5 @ 512x512 | ~4.5 GB | Chạy được trên mọi GPU hiện đại |
| txt2img SDXL @ 1024x1024 | ~8.0 GB | Cần 8GB+ VRAM |
| SDXL + 1x ControlNet | ~12.5 GB | Dùng `--medvram` cho card 8GB |
| SDXL + Hi-Res Fix 2x | ~14.0 GB | Khuyến nghị Tiled VAE |

### Tham Số Tối Ưu Bộ Nhớ

```bash
# GPU 4GB:
python3 launch.py --lowvram --precision full --no-half --xformers

# GPU 6-8GB:
python3 launch.py --medvram --xformers --opt-split-attention

# GPU 12GB+:
python3 launch.py --xformers --opt-sdp-attention

# GPU 24GB:
python3 launch.py --xformers --opt-sdp-attention --no-half-vae
```

## Sử Dụng Nâng Cao / Tối Ưu Production

### Tích Hợp API

```python
import requests
import base64

url = "http://localhost:7860/sdapi/v1/txt2img"

payload = {
    "prompt": "masterpiece, best quality, portrait of a cyberpunk samurai",
    "negative_prompt": "blurry, low quality, deformed",
    "steps": 25,
    "cfg_scale": 7.0,
    "width": 1024,
    "height": 1024,
    "sampler_name": "DPM++ 2M Karras",
    "batch_size": 1,
    "seed": -1
}

response = requests.post(url, json=payload)
result = response.json()

for i, img_data in enumerate(result['images']):
    with open(f"output_{i}.png", "wb") as f:
        f.write(base64.b64decode(img_data))
```

### Script Xử Lý Hàng Loạt

```python
import requests
import csv
import base64

API_URL = "http://localhost:7860/sdapi/v1/txt2img"

def generate_image(prompt, filename, width=1024, height=1024):
    payload = {
        "prompt": prompt,
        "negative_prompt": "blurry, low quality",
        "steps": 25,
        "cfg_scale": 7.0,
        "width": width,
        "height": height,
        "sampler_name": "DPM++ 2M Karras"
    }
    response = requests.post(API_URL, json=payload)
    result = response.json()
    with open(filename, "wb") as f:
        f.write(base64.b64decode(result['images'][0]))
    return filename

with open("prompts.csv", "r") as f:
    reader = csv.DictReader(f)
    for i, row in enumerate(reader):
        generate_image(row['prompt'], f"output_{i:04d}.png")
```

### Bảo Mật Production

```bash
# 1. Bật xác thực
python3 launch.py --listen --gradio-auth admin:matkhau_manh

# 2. Nginx reverse proxy + HTTPS
server {
    listen 443 ssl http2;
    server_name sd.example.com;
    ssl_certificate /etc/letsencrypt/live/sd.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/sd.example.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:7860;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

# 3. Firewall
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow 443/tcp
sudo ufw enable
```

## So Sánh với Các Lựa Chọn Khác

| Tính năng | Stable Diffusion WebUI | ComfyUI | InvokeAI | Fooocus |
|-----------|----------------------|---------|----------|---------|
| **Loại UI** | Tab-based web | Node-based graph | Web app + canvas | Single-page |
| **GitHub Stars** | 159,000+ | 75,000+ | 25,000+ | 42,000+ |
| **Hệ sinh thái** | 1,000+ extensions | 1,500+ nodes | ~100 nodes | Limited |
| **Độ khó học** | Trung bình | Cao | Trung bình | Thấp |
| **ControlNet** | Xuất sắc | Rộng rãi | Built-in | Cơ bản |
| **LoRA** | Đầy đủ | Đầy đủ | Built-in | Cơ bản |
| **VRAM tối thiểu (SDXL)** | 4GB | 4GB | 6GB | 4GB |
| **Xử lý hàng loạt** | Built-in | Queue | Queue | Thủ công |
| **API** | REST đầy đủ | REST + WebSocket | REST | Không |
| **Phù hợp cho** | Đa dụng | Power user | Nghệ sĩ | NgườI mới |

## Hạn Chế / Đánh Giá Trung Thực

Stable Diffusion WebUI không phải công cụ phù hợp với mọi trường hợp:

1. **VRAM cao hơn đối thủ**: Giao diện Gradio thêm ~500MB-1GB VRAM so với ComfyUI.

2. **Không phải lựa chọn nhanh nhất**: ComfyUI nhanh hơn 10-20% trên cùng phần cứng.

3. **Hỗ trợ Flux hạn chế**: Chạy Flux cần fork Forge hoặc cấu hình thủ công.

4. **Xung đột extensions**: Với 1,000+ extensions, tình trạng không tương thích là phổ biến.

5. **Không lý tưởng cho video**: Dù có AnimateDiff, WebUI về cơ bản được thiết kế cho ảnh tĩnh.

6. **Thiết kế single-user**: Không có hỗ trợ multi-user tích hợp.

## Câu Hỏi Thường Gặp

### Cần GPU gì để chạy Stable Diffusion WebUI?

GPU NVIDIA tối thiểu 4GB VRAM cho SD 1.5 ở 512x512. SDXL 1024x1024 cần 8GB VRAM thực tế. 12GB VRAM (RTX 3060, RTX 4060 Ti) thoải mái cho SDXL. Chuyên nghiệp với ControlNet khuyến nghị 24GB (RTX 3090/4090).

### Cách cập nhật Stable Diffusion WebUI?

Chạy `git pull` trong thư mục cài đặt, sau đó restart. Windows: double-click `update.bat`. Nếu extensions bị lỗi sau update, xóa thư mục `venv` để buộc cài lại dependencies.

### Có thể chạy không có GPU NVIDIA không?

Có, nhưng hạn chế. GPU AMD hoạt động trên Linux qua ROCm. Apple Silicon Mac chạy qua MPS backend nhưng chậm hơn 3-5 lần. Chế độ CPU-only với `--use-cpu all` mất 5-10 phút cho một ảnh 512x512.

### Tại sao ảnh tạo ra lại đen hoặc xanh lá?

Vấn đề half-precision trên một số GPU/driver. Thêm `--precision full --no-half`. Riêng lỗi NaN ở VAE dùng `--no-half-vae`.

### Cách khắc phục lỗi "CUDA out of memory"?

Bật xFormers `--xformers` (giảm 20-30% VRAM). GPU 8GB dùng `--medvram`, 4-6GB dùng `--lowvram`. Cài Tiled VAE. Dùng model FP8/NF4 quantized giảm 50% VRAM.

### Expose WebUI ra internet có an toàn không?

Không —— nếu không có bảo mật bổ sung. `--listen` expose UI không cần auth. Luôn kết hợp `--gradio-auth` với HTTPS reverse proxy và firewall.

## Kết Luận

Stable Diffusion WebUI của AUTOMATIC1111 vẫn là điểm khởi đầu thực tế nhất cho việc tạo ảnh AI cục bộ vào 2026. 159,000+ GitHub stars không chỉ là độ phổ biến —— nó đại diện cho hệ sinh thái mở rộng, cơ sở kiến thức và cơ sở hạ tầng hỗ trợ cộng đồng mà không đối thủ nào sánh bằng.

**Các bước hành động:**

1. Xác nhận GPU có 8GB+ VRAM, cài WebUI bằng installer tự động hoặc Docker
2. Cài ControlNet + 4 models cốt lõi
3. Tải 2-3 checkpoint SDXL chất lượng và 5-10 LoRA adapter
4. Cấu hình `--xformers` và flag VRAM phù hợp
5. Thiết lập nginx reverse proxy nếu deploy ngoài localhost

**Thảo luận hoặc nhận trợ giúp trong nhóm Telegram:** [t.me/dibi8opensource](https://t.me/dibi8opensource)

*Tuyên bố: Bài viết chứa liên kết affiliate Hostinger. Chúng tôi có thể nhận hoa hồng khi bạn đăng ký —— không phát sinh chi phí thêm. Mọi đề xuất đều dựa trên thử nghiệm thực tế.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài Liệu Tham Khảo

- [AUTOMATIC1111/stable-diffusion-webui GitHub](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
- [Wiki Chính Thức — Cài trên NVIDIA GPU](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Install-and-Run-on-NVidia-GPUs)
- [ControlNet Extension](https://github.com/Mikubill/sd-webui-controlnet)
- [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
- [InvokeAI](https://github.com/invoke-ai/InvokeAI)
- [Hostinger VPS](https://www.hostinger.vn/vps-hosting)
- [Civitai — Model & LoRA](https://civitai.com)
- [Hugging Face](https://huggingface.co/models?pipeline_tag=text-to-image)
