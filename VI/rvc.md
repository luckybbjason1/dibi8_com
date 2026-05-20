---
title: 'RVC: Triển khai AI Chuyển đổi Giọng nói với 35K+ Stars — Hướng dẫn Thiết lập Huấn luyện 10 phút cho 2026'
description: 'RVC (Retrieval-based Voice Conversion) là khung chuyển đổi giọng nói dựa trên VITS, tương thích với GPT-SoVITS, Coqui TTS và demucs. Hướng dẫn này bao gồm triển khai Docker, pipeline huấn luyện, tích hợp API và củng cố production.'
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
github_repo: 'https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI'
stars: 35700
maintainer: 'RVC-Project'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['rvc', 'chuyen-doi-giong-noi', 'ai-voice-clone', 'vits', ' tong-hop-giong-noi', 'docker', 'huong-dan', 'retrieval-vc']
aliases:
- /vi/posts/rvc/
---

{{</* resource-info */>}}

![RVC Logo](https://raw.githubusercontent.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/main/assets/rvc_logo.png)

## Giới thiệu

Bạn cần một pipeline chuyển đổi giọng nói có thể huấn luyện trong 10 phút, chạy trên một GPU duy nhất, và cho đầu ra chất lượng phát sóng. Hệ sinh thái mã nguồn mở đã tạo ra hàng chục công cụ nhân bản giọng nói, nhưng hầu hết đều yêu cầu hàng giờ huấn luyện, bộ dữ liệu khổng lồ, hoặc API đám mây tính phí từng phút. RVC (Retrieval-based Voice Conversion — chuyển đổi giọng nói dựa trên truy xuất), một khung dựa trên VITS với hơn 35,700 Stars trên GitHub, cắt giảm thờ gian huấn luyện xuống dưới 10 phút với chỉ 10 phút âm thanh sạch. Hướng dẫn này đi qua thiết lập RVC sẵn sàng production — triển khai Docker, pipeline huấn luyện, tích hợp API, và các bước củng cố cần thiết trước khi giao cho ngườ dùng.

## RVC là gì?

RVC là một khung chuyển đổi giọng nói mã nguồn mở chuyển đổi giọng của ngườ này thành giọng của ngườ khác trong khi vẫn giữ nội dung lờ nói, ngữ điệu và nhịp điệu. Được xây dựng trên VITS với mô đun khớp đặc trưng dựa trên truy xuất, nó đạt thờ gian huấn luyện dưới 10 phút trên GPU phổ thông và hỗ trợ suy luận thờ gian thực với độ trễ thấp tới 90ms.

## RVC hoạt động như thế nào

Kiến trúc của RVC kết hợp bốn mô đun cốt lõi:

**Trích xuất Đặc trưng Nội dung** — Sử dụng ContentVec (một biến thể tách rồi của HuBERT) để trích xuất các đặc trưng ngôn ngữ và ngôn ngữ học không phụ thuộc vào ngườ nói từ âm thanh nguồn. ContentVec loại bỏ danh tính ngườ nói trong khi vẫn giữ thông tin nội dung, làm cho nó lý tưởng cho các tác vụ chuyển đổi giọng nói.

**Trích xuất Cao độ** — Sử dụng RMVPE (Robust Model for Vocal Pitch Estimation), được trình bày tại Interspeech 2023, để trích xuất tần số cơ bản (F0). RMVPE xử lý âm thanh đa âm và thực hiện chính xác ngay cả khi tách nguồn không hoàn hảo.

**Mô hình Âm học** — Được xây dựng trên VITS (Variational Inference with adversarial learning for end-to-end Text-to-Speech), một VAE có điều kiện được tăng cường với normalizing flows. VITS tạo ra âm thanh chất lượng cao thông qua huấn luyện đối kháng giữa bộ tạo và các bộ phân biệt đa chu kỳ.

**Mô đun Truy xuất** — Đổi mới đặc trưng của RVC. Trong quá trình huấn luyện, các đặc trưng nội dung được lập chỉ mục trong cơ sở dữ liệu vector Faiss. Trong quá trình suy luận, các đặc trưng nguồn được thay thế bằng K láng giềng gần nhất từ tập huấn luyện (K=8 theo mặc định), giảm đáng kể rò rỉ âm sắc từ ngườ nói nguồn. Tham số `index_rate` (α, thường là 0.3) điều khiển tỷ lệ pha trộn giữa các đặc trưng được truy xuất và đặc trưng nguồn.

![Sơ đồ Kiến trúc RVC](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/raw/main/docs/rvc_arch.png)

## Cài đặt & Thiết lập

### Yêu cầu Trước khi Cài đặt

RVC chạy trên Linux, macOS và Windows. Để huấn luyện, cần có GPU NVIDIA với ít nhất 4GB VRAM (khuyến nghị 8GB+). Chỉ để suy luận, CPU hoạt động với độ trễ chấp nhận được.

**Phần cứng tối thiểu:**
- GPU: NVIDIA GTX 1660 6GB / RTX 2060 8GB (huấn luyện); 4GB VRAM (chỉ suy luận)
- CPU: Bộ xử lý 4 nhân Intel/AMD
- RAM: Tối thiểu 8GB, khuyến nghị 16GB
- Lưu trữ: 10GB dung lượng trống cho mô hình và phụ thuộc

### Phương pháp 1: Triển khai Docker (Khuyến nghị cho Production)

Dockerfile chính thức sử dụng CUDA 11.6.2 trên Ubuntu 20.04 với Python 3.9:

```bash
# Clone repository
git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git
cd Retrieval-based-Voice-Conversion-WebUI

# Build Docker image
docker build -t rvc-webui:latest .

# Chạy với hỗ trợ GPU và mount volume
docker run -d --name rvc \
  --gpus all \
  -p 7865:7865 \
  -v $(pwd)/weights:/app/weights \
  -v $(pwd)/opt:/app/opt \
  rvc-webui:latest
```

Ngườ dùng docker-compose:

```yaml
version: '3.8'

services:
  rvc:
    build: .
    container_name: rvc-webui
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - "7865:7865"
    volumes:
      - ./weights:/app/weights
      - ./opt:/app/opt
      - ./assets:/app/assets
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    restart: unless-stopped
```

```bash
# Khởi động với docker-compose
docker-compose up -d

# Kiểm tra log
docker-compose logs -f rvc
```

### Phương pháp 2: Thiết lập Python Cục bộ

```bash
# Clone repository
git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git
cd Retrieval-based-Voice-Conversion-WebUI

# Tạo môi trường ảo
python3 -m venv venv
source venv/bin/activate

# Cài đặt phụ thuộc
pip install -r requirements.txt

# Tải mô hình pretrained
python tools/download_models.py

# Hoặc tải thủ công từ HuggingFace
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/D40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/G40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0D40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0G40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -P assets/hubert/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt -P assets/rmvpe/
```

### Phương pháp 3: Thiết lập GPU AMD (ROCm)

```bash
# Cài đặt phụ thuộc ROCm (Ubuntu/Debian)
sudo apt install rocm-hip-sdk rocm-opencl-sdk

# Thiết lập biến môi trường
export ROCM_PATH=/opt/rocm
export HSA_OVERRIDE_GFX_VERSION=10.3.0

# Thêm user vào nhóm render và video
sudo usermod -aG render $USER
sudo usermod -aG video $USER

# Cài đặt yêu cầu đặc biệt cho AMD
pip install -r requirements-amd.txt
```

### Khởi động WebUI

```bash
# Khởi động giao diện web Gradio
python infer-web.py

# WebUI sẽ có tại http://localhost:7865
```

## Pipeline Huấn luyện

### Bước 1: Chuẩn bị Bộ Dữ liệu

RVC yêu cầu âm thanh sạch, đơn âm. Để có kết quả tốt nhất:

- **Thờ lượng:** 10–30 phút lờ nói sạch (tối thiểu 1 phút vẫn hoạt động)
- **Định dạng:** WAV, 16-bit hoặc 24-bit, tần số lấy mẫu 22050Hz hoặc 40000Hz
- **Nội dung:** Một ngườ nói duy nhất, tiếng ồn nền tối thiểu, không có nhạc hoặc vang
- **Im lặng:** Loại bỏ các đoạn im lặng dài (> 3 giây)

Sử dụng UVR5 (đã tích hợp) để tách nguồn:

```bash
# Tách giọng khỏi nhạc nền
python tools/uvr5/uvr5_cli.py \
  --input_path ./raw_audio/song_with_music.wav \
  --output_path ./dataset/ \
  --model_name "HP2-人声vocals+非人声instrumentals"
```

### Bước 2: Tiền xử lý và Trích xuất Đặc trưng

Trong tab **Train** của WebUI:

1. Đặt **Experiment Name** (ví dụ: `my_voice_v2`)
2. Đặt **Target Sampling Rate** thành 40kHz (khuyến nghị)
3. Đặt **RVC Version** thành v2
4. Đặt **Model Architecture** thành `rmvpe_gpu`
5. Đặt **Dataset Path** đến thư mục âm thanh của bạn
6. Nhấp **One-Click Training**

Hoặc qua dòng lệnh:

```bash
# Bước 1: Tiền xử lý (resample, slice, xóa im lặng)
python trainset_preprocess_pipeline_print.py \
  ./dataset/my_voice \
  40000 \
  8  # số luồng CPU

# Bước 2: Trích xuất đặc trưng với ContentVec
python extract_feature_print.py \
  --model_name my_voice_v2 \
  --sample_rate 40000 \
  --pitch_extractor rmvpe \
  --gpu 0

# Bước 3: Huấn luyện mô hình
python train_nsf_sim_cache_sid_load_pretrain.py \
  --model_name my_voice_v2 \
  --sample_rate 40000 \
  --batch_size 8 \
  --total_epoch 200 \
  --save_every_epoch 5 \
  --pretrained_G assets/pretrained_v2/f0G40k.pth \
  --pretrained_D assets/pretrained_v2/f0D40k.pth \
  --gpu 0
```

### Bước 3: Xây dựng Chỉ mục Đặc trưng

```bash
# Tạo chỉ mục Faiss để truy xuất
python tools/infer/train_index.py \
  --model_name my_voice_v2 \
  --sample_rate 40000
```

Vị trí đầu ra huấn luyện:

```
logs/
└── my_voice_v2/
    ├── added_IVF512_Flat_nprobe_1.index   # Chỉ mục truy xuất Faiss
    ├── G_*.pth                             # Checkpoint Generator
    ├── D_*.pth                             # Checkpoint Discriminator
    └── config.json                         # Cấu hình mô hình
```

![Tab Huấn luyện RVC WebUI](https://raw.githubusercontent.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/main/docs/en/training_tab.png)

### Bảng Benchmark Huấn luyện

| Phần cứng | Kích thước Dữ liệu | Epochs | Thờ gian Huấn luyện | Chất lượng Đầu ra |
|-----------|-------------------|--------|---------------------|-------------------|
| RTX 3090 (24GB) | 10 phút âm thanh | 200 | ~18 phút | Xuất sắc |
| RTX 4090 (24GB) | 10 phút âm thanh | 200 | ~12 phút | Xuất sắc |
| RTX 3060 (12GB) | 10 phút âm thanh | 200 | ~35 phút | Rất tốt |
| GTX 1660 (6GB) | 10 phút âm thanh | 200 | ~90 phút | Tốt |
| Colab T4 (16GB) | 10 phút âm thanh | 200 | ~40 phút | Rất tốt |

## Tích hợp với Các Công cụ Phổ biến

### Tích hợp 1: GPT-SoVITS (Pipeline TTS + RVC)

GPT-SoVITS tạo lờ nói từ văn bản; RVC chuyển đổi thành giọng mục tiêu. Kết hợp lại tạo thành pipeline nhân bản văn bản-thành-giọng nói hoàn chỉnh:

```python
# gpt_sovits_rvc_pipeline.py
import requests

def tts_then_convert(text: str, speaker_wav: str, rvc_model: str):
    """GPT-SoVITS TTS → Pipeline chuyển đổi giọng RVC"""
    
    # Bước 1: Tạo giọng với GPT-SoVITS
    tts_response = requests.post("http://localhost:9880/tts", json={
        "text": text,
        "refer_wav_path": speaker_wav,
        "prompt_text": "Văn bản gợi ý tham khảo",
        "prompt_language": "vi",
        "text_language": "vi"
    })
    
    with open("/tmp/tts_output.wav", "wb") as f:
        f.write(tts_response.content)
    
    # Bước 2: Chuyển đổi giọng với API RVC
    rvc_response = requests.post("http://localhost:7865/voice_conversion", json={
        "input_audio": "/tmp/tts_output.wav",
        "model_name": rvc_model,
        "pitch_shift": 0,
        "index_rate": 0.75,
        "filter_radius": 3,
        "volume_envelope": 0.25
    })
    
    return rvc_response.json()["output_path"]
```

### Tích hợp 2: Coqui TTS

```python
# coqui_rvc_bridge.py
from TTS.api import TTS
import requests

def coqui_to_rvc(text: str, rvc_model: str, output_path: str):
    # Tạo với Coqui XTTS v2
    tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2", gpu=True)
    tts.tts_to_file(
        text=text,
        speaker_wav="reference.wav",
        language="vi",
        file_path="/tmp/coqui_out.wav"
    )
    
    # Chuyển đổi qua RVC
    with open("/tmp/coqui_out.wav", "rb") as f:
        files = {"file": f}
        data = {"model_name": rvc_model, "pitch": 0, "index_rate": 0.5}
        response = requests.post(
            "http://localhost:7865/api/voice_conversion",
            files=files, data=data
        )
    
    with open(output_path, "wb") as f:
        f.write(response.content)
    return output_path
```

### Tích hợp 3: demucs (Tách Nguồn Nâng cao)

Để tách giọng production-grade trước khi huấn luyện:

```bash
# Cài đặt demucs
pip install demucs

# Tách giọng với demucs (chất lượng tốt hơn UVR5 cho mix phức tạp)
demucs --two-stems=vocals --mp3 --mp3-bitrate 320 input_song.mp3

# Sử dụng track giọng đã tách cho huấn luyện RVC
mv separated/htdemucs/input_song/vocals.wav ./dataset/clean_voice.wav
```

### Tích hợp 4: GUI Chuyển đổi Giọng Thờ gian Thực

RVC bao gồm GUI chuyển đổi giọng thờ gian thực cho ứng dụng trực tiếp:

![RVC Real-time GUI](https://raw.githubusercontent.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/main/assets/gui_preview.png)

```bash
# Khởi động GUI thờ gian thực
python gui_v1.py

# Hoặc với DirectML cho GPU AMD/Intel
python gui_v1.py --dml

# Các tham số chính cho độ trễ thấp:
# - Thờ gian khối: 0.25s (thấp hơn = độ trễ thấp hơn, CPU cao hơn)
# - Crossfade: 0.05s
# - Thờ gian thêm: 2.5s
# - Trình trích xuất cao độ: fcpe (nhanh nhất) hoặc rmvpe (chất lượng tốt nhất)
```

Cấu hình streaming (90ms độ trễ end-to-end với ASIO):

```python
# gui_config.py ví dụ
config = {
    "block_time": 0.1,        # Khối 100ms để giảm độ trễ
    "crossfade_time": 0.04,
    "extra_time": 2.0,
    "f0method": "fcpe",       # Trình trích xuất cao độ nhanh nhất
    "rms_mix_rate": 0.25,
    "index_rate": 0.3,
    "pitch": 0,
    "I_noise_reduce": True,
    "O_noise_reduce": False
}
```

### Tích hợp 5: API Server (FastAPI)

RVC cung cấp REST API dựa trên FastAPI cho các triển khai production:

```bash
# Khởi động API server
python api_240604.py

# API sẽ có tại http://localhost:7865
```

```python
# Ví dụ client API cho suy luận
import requests

# Tải mô hình trước
requests.post("http://localhost:7865/load_model", json={
    "pth_path": "./weights/my_voice_v2.pth",
    "index_path": "./logs/my_voice_v2/added_IVF512_Flat_nprobe_1.index"
})

# Thực hiện chuyển đổi giọng
with open("input_audio.wav", "rb") as f:
    response = requests.post(
        "http://localhost:7865/voice_conversion",
        files={"file": f},
        data={
            "pitch": 0,
            "index_rate": 0.75,
            "filter_radius": 3,
            "volume_envelope": 0.25,
            "protect": 0.33
        }
    )

with open("converted_output.wav", "wb") as f:
    f.write(response.content)
```

## Benchmark / Trường hợp Sử dụng Thực tế

### Các Chỉ số Chất lượng Khách quan

| Chỉ số | RVC v2 | So-VITS-SVC 4.1 | GPT-SoVITS (SVC) | DDSP-SVC |
|--------|--------|-----------------|-------------------|----------|
| Độ Tương đồng Ngườ nói (cosine) | 0.85 | 0.79 | 0.82 | 0.71 |
| PESQ (chất lượng, /4.5) | 3.6 | 3.3 | 3.4 | 2.8 |
| UTMOS (tự nhiên, /5) | 4.19 | 3.95 | 4.05 | 3.45 |
| Thờ gian Huấn luyện (10min data, RTX 3090) | ~18 phút | ~2 giờ | ~45 phút | ~15 phút |
| Dữ liệu Huấn luyện Tối thiểu | 1 phút | 10 phút | 1 phút | 5 phút |
| Hệ số Thờ gian Thực (suy luận) | 0.05x | 0.15x | 0.08x | 0.02x |

### Các Trường hợp Sử dụng Production

**AI Music Covers** — Chuyển đổi track giọng để bắt chước giọng nghệ sĩ cụ thể cho nội dung giải trí. Trích xuất cao độ RMVPE của RVC duy trì khả năng tái tạo giai điệu chính xác ngay cả qua các đoạn vocal phức tạp.

**Đổi Giọng Live Streaming** — Thay đổi giọng thờ gian thực cho ngườ sáng tạo nội dung. Với GUI và driver ASIO, độ trễ end-to-end đạt 90ms, hầu hết khán giả không thể nhận biết.

**Bảo vệ Quyền riêng tư** — Ẩn danh danh tính ngườ nói trong bản ghi phỏng vấn, âm thanh tổng đài, và dữ liệu giọng nói nhạy cảm trong khi vẫn giữ nội dung cảm xúc và khả năng hiểu.

**Bản địa hóa Nội dung** — Lồng tiếng video xuyên ngôn ngữ trong khi vẫn giữ đặc điểm giọng nói gốc của ngườ nói khi kết hợp với pipeline TTS.

**Tăng cường Bộ Dữ liệu Giọng nói** — Tạo dữ liệu huấn luyện tổng hợp cho hệ thống ASR ngôn ngữ nguồn thấp, nghiên cứu học thuật cho thấy sau 200 epochs đạt KL divergence loss 0.68.

## Sử dụng Nâng cao / Củng cố Production

### Các Yếu tố Bảo mật

```python
# api_production.py — Trình bao bọc API được củng cố
from fastapi import FastAPI, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import hashlib

security = HTTPBearer()

def verify_token(credentials: HTTPAuthorizationCredentials):
    """Xác minh token API cho triển khai production"""
    expected = hashlib.sha256(TOKEN.encode()).hexdigest()
    if credentials.credentials != expected:
        raise HTTPException(status_code=401, detail="Token không hợp lệ")
    return True

@app.post("/voice_conversion")
async def secure_convert(
    file: UploadFile,
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    verify_token(credentials)
    # ... logic chuyển đổi
    return {"output_url": signed_url}
```

### Quản lý Mô hình

```bash
# Tổ chức nhiều mô hình giọng nói
models/
├── celeb_voice_a/
│   ├── model.pth
│   ├── index.faiss
│   └── config.json
├── celeb_voice_b/
│   ├── model.pth
│   ├── index.faiss
│   └── config.json
└── custom_brand_voice/
    ├── model.pth
    ├── index.faiss
    └── config.json
```

```python
# Bộ tải mô hình động cho triển khai đa tenant
import os
import glob

def list_available_models(models_dir="./models"):
    """Liệt kê tất cả các mô hình giọng nói khả dụng"""
    models = []
    for model_dir in glob.glob(os.path.join(models_dir, "*/")):
        name = os.path.basename(os.path.dirname(model_dir))
        pth_files = glob.glob(os.path.join(model_dir, "*.pth"))
        index_files = glob.glob(os.path.join(model_dir, "*.faiss")) + \
                      glob.glob(os.path.join(model_dir, "*.index"))
        if pth_files and index_files:
            models.append({"name": name, "pth": pth_files[0], "index": index_files[0]})
    return models
```

### Giám sát và Ghi log

```python
# monitoring.py — Metrics tương thích Prometheus
from prometheus_client import Counter, Histogram, start_http_server
import time

conversion_count = Counter('rvc_conversions_total', 'Tổng số lần chuyển đổi')
conversion_duration = Histogram('rvc_conversion_seconds', 'Độ trễ chuyển đổi')
error_count = Counter('rvc_errors_total', 'Tổng số lỗi', ['error_type'])

def monitored_convert(audio_path, model_name):
    start = time.time()
    try:
        result = perform_conversion(audio_path, model_name)
        conversion_count.inc()
        return result
    except Exception as e:
        error_count.labels(error_type=type(e).__name__).inc()
        raise
    finally:
        conversion_duration.observe(time.time() - start)

# Khởi động endpoint metrics
start_http_server(9090)
```

### Xuất ONNX để Suy luận Nhanh hơn

```bash
# Xuất mô hình đã huấn luyện sang ONNX để suy luận độc lập CPU/GPU
python tools/export_onnx.py \
  --checkpoint_path ./logs/my_voice_v2/G_12000.pth \
  --output_path ./models/my_voice_v2/model.onnx \
  --sample_rate 40000
```

## So sánh với Các Lựa chọn Thay thế

| Tính năng | RVC v2 | GPT-SoVITS | So-VITS-SVC 4.1 | DDSP-SVC |
|-----------|--------|------------|-----------------|----------|
| **Mục đích Chính** | Chuyển đổi Giọng nói | TTS + Nhân bản Giọng | Chuyển đổi Giọng Hát | Chuyển đổi Giọng Hát |
| **Thờ gian Huấn luyện** (10 phút dữ liệu) | ~18 phút (RTX 3090) | ~45 phút | ~2 giờ | ~15 phút |
| **GPU VRAM Tối thiểu** (huấn luyện) | 4GB | 8GB | 8GB | 4GB |
| **Dữ liệu Huấn luyện Tối thiểu** | 1 phút | 1 phút | 10 phút | 5 phút |
| **Trình Trích xuất Cao độ** | RMVPE / FCPE | RMVPE | Harvest / Crepe | Harvest / Crepe |
| **Bộ Mã hóa Nội dung** | ContentVec (768-dim) | HuBERT / ContentVec | ContentVec | ContentVec |
| **Mô đun Truy xuất** | Faiss top-K (K=8) | Không có | Faiss top-K (thêm ở 4.1) | Không có |
| **Suy luận Thờ gian Thực** | Có (90ms độ trễ) | Không | Có (w-okada) | Có |
| **Vocoder** | NSF-HiFi-GAN | NSF-HiFi-GAN | NSF-HiFi-GAN | DDSP + HiFi-GAN |
| **Hợp nhất Mô hình** | Có (ckpt merge) | Không | Không | Không |
| **Tích hợp UVR5** | Tích hợp sẵn | Tách biệt | Tách biệt | Tách biệt |
| **Giấy phép** | MIT | MIT | BSD-3-Clause | Apache-2.0 |
| **GitHub Stars** | 35,700+ | 43,000+ | 21,200+ | 2,800+ |
| **Cập nhật Cuối** | 2024-06 | 2025-04 | 2023-12 (lưu trữ) | 2024-03 |

**Khi chọn RVC:** Bạn cần huấn luyện nhanh, chuyển đổi thờ gian thực, hoặc khớp đặc trưng dựa trên truy xuất để giảm thiểu rò rỉ âm sắc. RVC là lựa chọn thực tế cho các pipeline chuyển đổi giọng nói production.

**Khi chọn GPT-SoVITS:** Bạn cần văn bản-thành-giọng nói với nhân bản giọng (không phải chuyển đổi âm thanh-thành-âm thanh). GPT-SoVITS xuất sắc trong việc tạo lờ nói từ văn bản với 1 phút âm thanh tham khảo.

**Khi chọn So-VITS-SVC:** Chuyển đổi giọng hát legacy với xử lý hậu kỳ khuếch tán nông. Lưu ý: dự án đã bị lưu trữ và không còn được duy trì.

**Khi chọn DDSP-SVC:** Chuyển đổi hát nhẹ với mức sử dụng tài nguyên tối thiểu. Chất lượng thấp hơn RVC nhưng chạy trên phần cứng yếu hơn.

## Hạn chế / Đánh giá Trung thực

RVC là một công cụ có khả năng, nhưng không phải lựa chọn phù hợp cho mọi ứng dụng giọng nói:

**Không có Text-to-Speech.** RVC chuyển đổi âm thanh sang âm thanh. Nó không thể tạo lờ nói từ văn bản. Kết hợp với GPT-SoVITS, Coqui TTS, hoặc Edge-TTS để tạo pipeline TTS hoàn chỉnh.

**Giới hạn Độ Tương đồng Ngườ nói.** Mặc dù RVC tạo ra các chuyển đổi thuyết phục, nó không đạt được độ trung thực của các giải pháp thương mại như ElevenLabs Voice Cloning hoặc Microsoft Azure Speech Studio. Đối với nhân bản giọng cấp doanh nghiệp, API trả phí vẫn dẫn đầu.

**Hạn chế Kiểm soát Cảm xúc.** RVC bảo toàn cảm xúc và ngữ điệu của âm thanh nguồn nhưng không thể thao túng biểu hiện cảm xúc một cách độc lập. Các công cụ như CosyVoice 3 hoặc Seed-VC cung cấp kiểm soát ngữ điệu chi tiết hơn.

**Yêu cầu Phần cứng cho Huấn luyện.** Mặc dù hiệu quả hơn các lựa chọn thay thế, huấn luyện vẫn yêu cầu GPU NVIDIA rờ i. Huấn luyện CPU không thực tế (chậm hơn 50x+). Các instance GPU đám mây thêm chi phí vận hành.

**Rủi ro Đạo đứ và Pháp lý.** Công nghệ nhân bản giọng nói có thể bị lạm dụng cho âm thanh deepfake, gian lận, và giả mạo. RVC không bao gồm cơ chế watermark hoặc an toàn tích hợp. Các triển khai production nên triển khai xác minh đồng ý, ghi log kiểm tra, và watermarking âm thanh tổng hợp.

**Khoảng trống Hỗ trợ Ngôn ngữ.** RVC hoạt động tốt cho các ngôn ngữ chính (Anh, Trung, Nhật, Hàn) nhưng chất lượng giảm cho các ngôn ngữ thanh điệu (Thái, Việt) và ngôn ngữ nguồn thấp với phạm vi bao phủ mô hình pretrained hạn chế.

## Câu hỏi Thường gặp

### RVC cần bao nhiêu dữ liệu huấn luyện?
RVC có thể huấn luyện với ít nhất 1 phút âm thanh sạch, nhưng 10–30 phút cho kết quả đáng kể tốt hơn. Yếu tố then chốt là chất lượng âm thanh, không phải số lượng. 10 phút ghi âm phòng thu vượt trội hơn 2 giờ cuộc gọi điện thoại ồn ào. Giữ tiếng ồn nền, nhạc, và vang ở mức tối thiểu.

### RVC có thể chạy chỉ trên CPU không?
Có, chỉ cho suy luận. Huấn luyện yêu cầu GPU hỗ trợ CUDA. Suy luận CPU chậm hơn GPU 10–20 lần nhưng hoạt động cho các tác vụ xử lý hàng loạt mà độ trễ không quan trọng. Để chuyển đổi thờ gian thực, GPU với ít nhất 4GB VRAM được khuyến nghị mạnh mẽ.

### Sự khác biệt giữa RVC v1 và v2 là gì?
RVC v2 thay đổi bộ mã hóa nội dung từ đặc trưng 256 chiều của HuBERT 9 lớp thành đặc trưng 768 chiều của HuBERT 12 lớp, và thêm 3 bộ phân biệt chu kỳ để cải thiện chất lượng âm thanh. Tất cả các dự án mới nên sử dụng độc quyền các mô hình v2. Các mô hình pretrained v2 không tương thích ngược với v1.

### Làm thế nào để giảm rò rỉ âm sắc trong âm thanh đã chuyển đổi?
Điều chỉnh tham số **index_rate**. Giá trị cao hơn (0.7–1.0) tăng sự phụ thuộc vào chỉ mục truy xuất, lấy nhiều đặc trưng hơn từ tập huấn luyện và ít hơn từ nguồn. Bắt đầu với 0.75 và điều chỉnh dựa trên chất lượng đầu ra. Nếu giọng nghe nhân tạo, giảm xuống 0.3–0.5.

### Có thể sử dụng RVC để đổi giọng thờ gian thực trong Discord/Zoom/Game không?
Có, thông qua GUI thờ gian thực của RVC (`gui_v1.py`). Định tuyến micro qua cáp âm thanh ảo (VB-Cable trên Windows, BlackHole trên macOS, hoặc PulseAudio trên Linux), đặt RVC làm thiết bị đầu vào, và cấu hình ứng dụng của bạn để sử dụng đầu ra cáp ảo. Với driver ASIO và GPU hiện đại, độ trễ duy trì dưới 100ms.

### RVC hỗ trợ những định dạng file nào?
RVC hỗ trợ WAV, MP3, FLAC, OGG, và M4A cho đầu vào. Đầu ra luôn là WAV ở tần số lấy mẫu mục tiêu (32kHz, 40kHz, hoặc 48kHz). Để có chất lượng tốt nhất, sử dụng WAV hoặc FLAC không nén cho đầu vào và tránh mã hóa lại file MP3 nhiều lần.

### Làm thế nào để hợp nhất hai mô hình giọng nói?
Sử dụng tab **ckpt merge** trong WebUI. Tải hai file mô hình .pth và đặt tỷ lệ pha trộn (0.0 = 100% mô hình A, 1.0 = 100% mô hình B, 0.5 = pha trộn đều). Mô hình hợp nhất kế thừa các đặc điểm từ cả hai giọng. Điều này hoạt động tốt để tạo giọng lai mà không cần huấn luyện lại.

### Tại sao giọng đã chuyển đổi của tôi nghe cơ khí hoặc méo mó?
Nguyên nhân phổ biến: (1) dữ liệu huấn luyện hoặc epochs không đủ — huấn luyện ít nhất 200 epochs; (2) âm thanh đầu vào có tiếng ồn — sử dụng UVR5 hoặc demucs để tách nguồn; (3) trình trích xuất cao độ không chính xác — sử dụng rmvpe cho lờ nói, harvest cho hát; (4) tần số lấy mẫu không khớp — đảm bảo suy luận khớp với tần số lấy mẫu huấn luyện.

## Kết luận

RVC cung cấp chuyển đổi giọng nói cấp production với thờ gian huấn luyện dưới 20 phút trên phần cứng trung bình. Kiến trúc dựa trên truy xuất của nó tạo ra sự tách biệt giọng nói sạch hơn so với ánh xạ đặc trưng trực tiếp, và máy chủ FastAPI cho phép tích hợp đơn giản vào các pipeline âm thanh hiện có. Đối với các nhà phát triển xây dựng ứng dụng hỗ trợ giọng nói, RVC cung cấp sự cân bằng tốt nhất giữa chất lượng, tốc độ, và tính linh hoạt triển khai trong hệ sinh thái mã nguồn mở.

**Bước tiếp theo:** Clone repository, chạy thiết lập Docker, và huấn luyện mô hình đầu tiên của bạn với 10 phút âm thanh sạch. Tham gia cộng đồng RVC trên Telegram để chia sẻ mô hình và nhận hỗ trợ: [t.me/RVCSpace](https://t.me/RVCSpace).



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu Tham khảo

- [RVC GitHub Repository](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI)
- [RVC Official Documentation](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/blob/main/docs/en/README.en.md)
- [Understanding RVC Architecture](https://gudgud96.github.io/2024/09/26/annotated-rvc/)
- [RVC Docker Setup Guide](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/blob/main/Dockerfile)
- [RVC API Reference (api_240604.py)](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/blob/main/api_240604.py)
- [GPT-SoVITS Repository](https://github.com/RVC-Boss/GPT-SoVITS)
- [ContentVec Paper](https://arxiv.org/abs/2204.09224)
- [RMVPE Pitch Extraction Paper](https://arxiv.org/abs/2306.15412v2)
- [VITS Paper](https://arxiv.org/abs/2106.06103)
- [DDSP-SVC Repository](https://github.com/yxlllc/DDSP-SVC)
- [So-VITS-SVC 4.1 (Archived)](https://github.com/svc-develop-team/so-vits-svc)
- [Custom Data Augmentation for Low-Resource ASR Using RVC](https://arxiv.org/abs/2311.14836)
- [LLVC: Low-Latency Real-Time Voice Conversion on CPU](https://arxiv.org/abs/2311.00873)
- [RVC Inference Settings Reference](https://docs.aihub.gg/rvc/resources/inference-settings/)
- [PetVocalia: Zero-Shot SVC Benchmark (IJCAI 2025)](https://www.ijcai.org/proceedings/2025/1135.pdf)
