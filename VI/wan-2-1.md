---
title: 'Wan 2.1: 16.1K+ Stars — Phân tích sâu tạo video mở so với HunyuanVideo, CogVideo 2026'
description: 'Wan 2.1 là bộ mô hình video nền mở của Alibaba với hiệu suất SOTA. Hỗ trợ ComfyUI, Diffusers và Gradio. Bao gồm T2V, I2V, chỉnh sửa video và tạo văn bản với các biến thể 1.3B và 14B.'
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
github_repo: 'https://github.com/Wan-Video/Wan2.1'
stars: 16100
maintainer: 'Wan-Video'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['wan-2-1', 'tạo-video', 'diffusion-transformer', 'ai-video', 'mã-nguồn-mở', 'alibaba', 'comfyui', 'diffusers']
aliases:
- /vi/posts/wan-2-1/
---

{{</* resource-info */>}}

![Ảnh bìa Wan 2.1](https://raw.githubusercontent.com/dibi8/articles/main/wan-2-1/feature.jpg)

## Giới thiệu

Mọi lập trình viên đã thử tạo video cục bộ đều biết cùng một nỗi đau: hoặc mô hình yêu cầu phần cứng GPU đắt hơn cả xe hơi, hoặc đầu ra trông như trình chiếu từ những năm 1990. Đầu năm 2025, nhóm Wan của Alibaba phát hành Wan 2.1 — một bộ công cụ tạo video hoàn toàn mã nguồn mở đã thay đổi phương trình. Với 16.100+ sao GitHub và mô hình 1,3B tham số chạy trên RTX 4090, Wan 2.1 là mô hình tạo video chất lượng cao dễ tiếp cận nhất hiện nay. Hướng dẫn này sẽ đi sâu vào Wan 2.1 là gì, cách hoạt động, cách cài đặt, so sánh với HunyuanVideo, CogVideo và Open-Sora, và cách triển khai trong môi trường production.

## Wan 2.1 là gì?

Wan 2.1 là bộ mô hình tạo video nền quy mô lớn nâng cao và mở được nhóm Wan của Alibaba phát hành vào tháng 2 năm 2025. Nó cung cấp khả năng tạo video từ văn bản (T2V), từ hình ảnh (I2V), chỉnh sửa video, tạo hình ảnh từ văn bản, tạo video từ khung đầu/cuối (FLF2V) và tạo âm thanh từ video. Bộ công cụ có hai kích thước tham số — mô hình 14B cho chất lượng tối đa và mô hình 1,3B được tối ưu hóa cho GPU phổ thông. Wan 2.1 là mô hình video mã nguồn mở đầu tiên có khả năng tạo văn bản tiếng Trung và tiếng Anh trong khung hình video.

![Wan 2.1 Logo](https://raw.githubusercontent.com/Wan-Video/Wan2.1/main/assets/logo.png)

## Wan 2.1 hoạt động như thế nào

### Tổng quan kiến trúc

Wan 2.1 được xây dựng trên nền tảng Diffusion Transformer (DiT) với Flow Matching, cùng họ kiến trúc với Stable Diffusion 3. Kiến trúc có ba thành phần cốt lõi:

**Wan-VAE (Bộ mã hóa tự động biến phân video):** Một VAE nhân quả 3D thực hiện nén không-thờ gian 256x. Không giống các VAE hình ảnh tiêu chuẩn, Wan-VAE bảo toàn tính nhân quả thờ gian — nghĩa là mỗi khung chỉ quan sát các khung trước đó, không phải khung tương lai. Điều này loại bỏ hiện tượng nhấp nháy phổ biến ở các mô hình tạo video đầu tiên. Wan-VAE có thể mã hóa video 1080P với độ dài bất kỳ mà không mất thông tin thờ gian.

**Diffusion Transformer (DiT):** Xương sống tạo sinh sử dụng transformer tiêu chuẩn với cross-attention để điều khiển theo văn bản. Mỗi khối transformer xử lý các patch không-thờ gian và áp dụng hướng dẫn văn bản thông qua embedding T5. Phép điều chế MLP sử dụng MLP được chia sẻ trên tất cả các khối, mỗi khối học một bộ bias riêng.

**Bộ mã hóa văn bản T5:** Wan 2.1 sử dụng bộ mã hóa văn bản UMT5-XXL để hiểu prompt đa ngôn ngữ. Bộ mã hóa này được đào tạo trên cả văn bản tiếng Anh và tiếng Trung, mang lại khả năng hiểu song ngữ gốc.

### Thông số kỹ thuật mô hình

| Mô hình | Tham số | Độ phân giải | VRAM (GPU đơn) | Thờ gian tạo điển hình |
|---|---|---|---|---|
| T2V-1.3B | 1.3B | 480P | 8.19 GB | ~4 phút trên RTX 4090 |
| T2V-14B | 14B | 480P / 720P | 40–48 GB (480P fp8) | ~4 phút trên H100 (480P) |
| I2V-14B | 14B | 480P / 720P | 65–80 GB (720P) | ~10–12 phút trên H100 (720P) |
| FLF2V-14B | 14B | 720P | 65–80 GB | ~10–15 phút trên H100 |

Mô hình 14B sử dụng chiều 5120, 40 đầu attention và 40 lớp transformer. Mô hình 1,3B giảm xuống chiều 1536, 12 đầu và 30 lớp.

## Cài đặt và thiết lập

### Yêu cầu tiên quyết

- GPU NVIDIA hỗ trợ CUDA (8GB+ cho 1.3B, 40GB+ cho 14B)
- Python 3.10+
- CUDA 12.1+

### Cài đặt cơ bản

```bash
# Clone repository
git clone https://github.com/Wan-Video/Wan2.1.git
cd Wan2.1

# Tạo môi trường ảo
python -m venv venv
source venv/bin/activate

# Cài đặt dependencies (yêu cầu torch >= 2.4.0)
pip install -r requirements.txt
```

Nội dung requirements.txt:

```
torch>=2.4.0
torchvision>=0.19.0
opencv-python>=4.9.0.80
diffusers>=0.31.0
transformers>=4.49.0
accelerate>=1.1.1
flash_attn
gradio>=5.0.0
numpy>=1.23.5,<2
```

### Cài đặt bằng Poetry (thay thế)

```bash
# Cài đặt dependencies
poetry install

# Nếu flash-attn xây dựng thất bại
poetry run pip install --upgrade pip setuptools wheel
poetry run pip install flash-attn --no-build-isolation
poetry install
```

### Tải mô hình

Tải mô hình bằng HuggingFace CLI:

```bash
# Cài đặt huggingface-cli
pip install "huggingface_hub[cli]"

# Tải mô hình T2V 14B
huggingface-cli download Wan-AI/Wan2.1-T2V-14B --local-dir ./Wan2.1-T2V-14B

# Tải mô hình 1.3B cho GPU phổ thông
huggingface-cli download Wan-AI/Wan2.1-T2V-1.3B --local-dir ./Wan2.1-T2V-1.3B

# Tải VAE
huggingface-cli download Wan-AI/Wan2.1-VAE --local-dir ./Wan2.1-VAE

# Tải bộ mã hóa văn bản
huggingface-cli download Wan-AI/Wan2.1-T5 --local-dir ./Wan2.1-T5
```

Hoặc dùng ModelScope để tải nhanh hơn từ Trung Quốc:

```bash
pip install modelscope
modelscope download Wan-AI/Wan2.1-T2V-14B --local_dir ./Wan2.1-T2V-14B
```

### Tạo video đầu tiên (T2V-1.3B)

```bash
python generate.py \
  --task t2v-1.3B \
  --size 832*480 \
  --ckpt_dir ./Wan2.1-T2V-1.3B \
  --prompt "Hồ núi yên bìn lúc bình minh, sương mù bốc lên từ mặt nước, camera di chuyển chậm sang phải"
```

### Tạo video đầu tiên (T2V-14B)

```bash
python generate.py \
  --task t2v-14B \
  --size 1280*720 \
  --ckpt_dir ./Wan2.1-T2V-14B \
  --prompt "Hai chú mèo nhân hóa mặc đồ boxing thoải mái và găng tay sáng màu đấu nhau kịch liệt trên sân khấu được chiếu đèn."
```

### Chạy Gradio Web UI

```bash
cd gradio

# Chạy T2V 14B với GPU đơn
python t2v_14B_singleGPU.py \
  --prompt_extend_method 'dashscope' \
  --ckpt_dir ./Wan2.1-T2V-14B

# Chạy T2V 1.3B (nhẹ hơn, cho GPU phổ thông)
python t2v_1.3B_singleGPU.py \
  --ckpt_dir ./Wan2.1-T2V-1.3B
```

## Tích hợp với ComfyUI, Diffusers và các công cụ khác

### Tích hợp ComfyUI

Wan 2.1 có tích hợp ComfyUI gốc. Cách tiếp cận được đề xuất sử dụng các node tùy chỉnh ComfyUI-WanVideoWrapper của Kijai:

```bash
# Cài đặt node tùy chỉnh
cd ComfyUI/custom_nodes
git clone https://github.com/Kijai/ComfyUI-WanVideoWrapper.git
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git
git clone https://github.com/kijai/ComfyUI-KJNodes.git

# Cài đặt dependencies cho node
cd ComfyUI-WanVideoWrapper
pip install -r requirements.txt
```

Tải file mô hình và đặt vào thư mục ComfyUI phù hợp:

```bash
# Diffusion models -> ComfyUI/models/diffusion_models
# Wan2_1-T2V-14B_fp8_e4m3fn.safetensors
# Wan2_1-T2V-1_3B_fp32.safetensors

# Text encoders -> ComfyUI/models/text_encoders
# umt5-xxl-enc-bf16.safetensors

# VAE -> ComfyUI/models/vae
# Wan2_1_VAE_fp32.safetensors
```

![Workflow Wan 2.1 ComfyUI](https://raw.githubusercontent.com/Wan-Video/Wan2.1/main/assets/vben_vs_sota.png)

### Tích hợp Diffusers

```python
import torch
from diffusers.utils import export_to_video
from diffusers import AutoencoderKLWan, WanPipeline
from diffusers.schedulers.scheduling_unipc_multistep import UniPCMultistepScheduler

# Tải mô hình
model_id = "Wan-AI/Wan2.1-T2V-14B-Diffusers"
vae = AutoencoderKLWan.from_pretrained(
    model_id, subfolder="vae", torch_dtype=torch.float32
)

# Cấu hình scheduler
flow_shift = 5.0  # 5.0 cho 720P, 3.0 cho 480P
scheduler = UniPCMultistepScheduler(
    prediction_type='flow_prediction',
    use_flow_sigmas=True,
    num_train_timesteps=1000,
    flow_shift=flow_shift
)

# Xây dựng pipeline
pipe = WanPipeline.from_pretrained(
    model_id, vae=vae, torch_dtype=torch.bfloat16
)
pipe.scheduler = scheduler
pipe.to("cuda")

# Tạo video
prompt = (
    "Một con mèo và một con chó cùng nướng bánh trong bếp. "
    "Con mèo đang cẩn thận đong bột mì, con chó khuấy bột bằng thìa gỗ. "
    "Căn bếp ấm cúng, ánh nắng chiếu qua cửa sổ."
)

negative_prompt = (
    "Tông màu sáng, cháy sáng, tĩnh, chi tiết mờ, phụ đề, "
    "phong cách, tác phẩm, tranh vẽ, hình ảnh, tĩnh, "
    "chất lượng kém, nét xấu, không đầy đủ"
)

output = pipe(
    prompt=prompt,
    negative_prompt=negative_prompt,
    height=720,
    width=1280,
    num_frames=81,
    guidance_scale=5.0,
).frames[0]

export_to_video(output, "output.mp4", fps=16)
```

### Suy luận đa GPU với FSDP + xDiT

```bash
# Cài đặt xDiT
pip install "xfuser>=0.4.1"

# Chạy trên 8 GPU
torchrun --nproc_per_node=8 generate.py \
  --task t2v-14B \
  --size 1280*720 \
  --ckpt_dir ./Wan2.1-T2V-14B \
  --dit_fsdp --t5_fsdp \
  --ulysses_size 8 \
  --prompt "Nhập prompt của bạn"
```

### Tạo video từ hình ảnh (I2V)

```bash
python generate.py \
  --task i2v-14B \
  --size 1280*720 \
  --ckpt_dir ./Wan2.1-I2V-14B-720P \
  --image examples/i2v_input.JPG \
  --prompt "Phong cách kỳ nghỉ bãi biển mùa hè, một chú mèo trắng đeo kính râm ngồi trên ván lướt sóng."
```

### Tạo video từ khung đầu/cuối (FLF2V)

```bash
python generate.py \
  --task flf2v-14B \
  --size 1280*720 \
  --ckpt_dir ./Wan2.1-FLF2V-14B-720P \
  --first_frame examples/flf2v_input_first_frame.png \
  --last_frame examples/flf2v_input_last_frame.png \
  --prompt "Phong cách hoạt hình CG, một chú chim xanh nhỏ cất cánh từ mặt đất, vỗ cánh bay lên."
```

### Mở rộng prompt

```bash
# Sử dụng mô hình Qwen cục bộ
python generate.py \
  --task t2v-14B \
  --size 1280*720 \
  --ckpt_dir ./Wan2.1-T2V-14B \
  --prompt "Một con mèo chơi piano" \
  --use_prompt_extend \
  --prompt_extend_model Qwen/Qwen2.5-7B-Instruct

# Sử dụng API DashScope
DASH_API_KEY=your_key python generate.py \
  --task t2v-14B \
  --size 1280*720 \
  --ckpt_dir ./Wan2.1-T2V-14B \
  --prompt "Một con mèo chơi piano" \
  --use_prompt_extend \
  --prompt_extend_method 'dashscope'
```

## Benchmark / Các trường hợp sử dụng thực tế

### Hiệu suất VBench

Wan 2.1 được đánh giá trên 14 chiều chính và 26 chiều phụ với 1.035 prompt nội bộ. Mô hình 14B đạt điểm VBench có trọng số là 0,724, vượt qua cả đối thủ mã nguồn mở và độc quyền.

![VBench Wan 2.1](https://raw.githubusercontent.com/Wan-Video/Wan2.1/main/assets/vben_vs_sota.png)

### Benchmark hiệu suất GPU

Hiệu suất trên các GPU khác nhau (tổng thờ gian giây / bộ nhớ GPU đỉnh GB):

| GPU | 1.3B 480P | 14B 480P | 14B 720P |
|---|---|---|---|
| RTX 4090 (24GB) | 281s / 8,2GB | Không hỗ trợ | Không hỗ trợ |
| A5000 (24GB) | 462s / 8,2GB | Không hỗ trợ | Không hỗ trợ |
| A40 (48GB) | 350s / 8,2GB | 1083s / 42GB | Không hỗ trợ |
| A100 (80GB) | 170s / 8,2GB | 523s / 48GB | ~850s / 72GB |
| L40 (48GB) | 290s / 8,2GB | 859s / 42GB | Không hỗ trợ |
| H100 (80GB) | 85s / 8,2GB | 284s / 48GB | ~580s / 72GB |

### Chi phí production thực tế

Chi phí GPU cloud cho tạo video đầu năm 2026:

| Mô hình | Độ phân giải | Thờ lượng | Thờ gian tạo | Chi phí GPU | Chi phí/clip |
|---|---|---|---|---|---|
| Wan 2.1 1.3B | 480P | 5s | ~4 phút | RTX 4090 local | ~$0,02 |
| Wan 2.1 14B | 480P | 5s | ~4 phút | $2,50/giờ (H100) | ~$0,17 |
| Wan 2.1 14B | 720P | 5s | ~10 phút | $2,50/giờ (H100) | ~$0,42 |
| HunyuanVideo | 720P | 5s | ~20 phút | $3,49/giờ (H200) | ~$0,70 |

### Các trường hợp sử dụng production

**Pipeline nội dung mạng xã hội:** Clip 5 giây 480P tốn khoảng $0,17 trên H100. Với 100 clip/tháng, chi phí cloud dưới $20 — so với $30–80/tháng cho dịch vụ API độc quyền.

**Nguyên mẫu quảng cáo sáng tạo:** Khả năng tạo văn bản song ngữ của Wan 2.1 rất lý tưởng cho thị trường Đông Á, nơi cần phủ lớp văn bản tiếng Trung hoặc tiếng Nhật lên video.

**Tiền trực quan hóa phim:** Tác vụ FLF2V cho phép nghệ sĩ storyboard tạo hoạt hình giữa hai keyframe để lập kế hoạch cảnh quay.

## Sử dụng nâng cao / Củng cố production

### Lượng tử hóa FP8 để giảm VRAM

```bash
# Lượng tử hóa FP8 giảm ~20% VRAM
python generate.py \
  --task t2v-14B \
  --size 832*480 \
  --ckpt_dir ./Wan2.1-T2V-14B \
  --offload_model True \
  --t5_cpu \
  --prompt "Nhập prompt của bạn"
```

### Cờ tối ưu VRAM

| Cờ | Mô tả | Tác động VRAM |
|---|---|---|
| `--offload_model True` | Chuyển transformer sang CPU giữa các bước | -15–20GB |
| `--t5_cpu` | Chạy encoder T5 trên CPU | -2–3GB |
| `--dit_fsdp` | Chia DiT qua nhiều GPU | Chia theo số GPU |
| `--ulysses_size N` | Sử dụng song song chuỗi | Giảm tuyến tính |

### Triển khai Docker

```dockerfile
FROM nvidia/cuda:12.1.0-devel-ubuntu22.04

WORKDIR /app
RUN apt-get update && apt-get install -y python3-pip git

COPY requirements.txt .
RUN pip install -r requirements.txt

COPY . .
RUN huggingface-cli download Wan-AI/Wan2.1-T2V-14B \
    --local-dir ./Wan2.1-T2V-14B

EXPOSE 7860
CMD ["python", "gradio/t2v_14B_singleGPU.py", "--ckpt_dir", "./Wan2.1-T2V-14B"]
```

Build và chạy:

```bash
docker build -t wan2.1 .
docker run --gpus all -p 7860:7860 wan2.1
```

### Giám sát tác vụ tạo sinh

```python
import time
import psutil
import torch

def generate_with_monitoring(prompt, **kwargs):
    process = psutil.Process()
    start_mem = process.memory_info().rss / 1024**3
    start_time = time.time()
    
    result = generate_video(prompt, **kwargs)
    
    elapsed = time.time() - start_time
    peak_mem = process.memory_info().rss / 1024**3
    gpu_mem = torch.cuda.max_memory_allocated() / 1024**3
    
    print(f"Hoàn thành sau {elapsed:.1f}s")
    print(f"VRAM GPU đỉnh: {gpu_mem:.1f} GB")
    print(f"Tăng RAM: {peak_mem - start_mem:.1f} GB")
    
    return result
```

### Fine-tuning LoRA

```bash
# Cài đặt DiffSynth-Studio
pip install diffsynth-studio

# Huấn luyện LoRA phong cách
python -m diffsynth.train \
  --model_name wan2.1-t2v-14b \
  --dataset_path ./my_style_videos \
  --output_path ./wan_lora_output \
  --learning_rate 1e-4 \
  --num_train_steps 1000
```

## So sánh với các lựa chọn thay thế

| Tính năng | Wan 2.1 | HunyuanVideo | CogVideoX-1.5-5B | Open-Sora 2.0 |
|---|---|---|---|---|
| **Tham số** | 1.3B / 14B | ~13B | 5B | 7B |
| **VRAM tối thiểu (T2V)** | 8,19GB (1.3B) | 12GB (lượng tử) | 5GB (diffusers) | 24GB |
| **Độ phân giải tối đa** | 720P | 1080P | 1360x768 | 768P |
| **Thờ lượng tối đa** | ~5s (81 khung) | ~5s | 10s | ~5s |
| **Tốc độ tạo** (H100, 720P) | ~10 phút | ~20 phút | ~9 phút | ~15 phút |
| **Văn bản song ngữ** | Có (Trung+Anh) | Không | Không | Không |
| **Hỗ trợ I2V** | Có (14B) | Có | Có | Có (T2I2V) |
| **Chỉnh sửa video** | Có (VACE) | Không | Không | Không |
| **Giấy phép** | Apache-2.0 | Apache-2.0 | Apache-2.0 | Apache-2.0 |
| **Điểm VBench** | 0,724 | 0,71 | 0,68 | 0,73 |
| **Tính liền mạch chuyển động** | 8/10 | 9/10 | 7,5/10 | 8/10 |
| **Hỗ trợ GPU phổ thông** | Có (1.3B) | Một phần (lượng tử) | Có (diffusers) | Không |
| **Hỗ trợ ComfyUI** | Gốc | Cộng đồng | Cộng đồng | Cộng đồng |
| **Chi phí huấn luyện** | Không công bố | Không công bố | Không công bố | $200K |

### Khi nào chọn mỗi mô hình

- **Wan 2.1:** Cân bằng tốt nhất giữa chất lượng, tốc độ và khả năng tiếp cận. Chọn khi cần văn bản song ngữ, hỗ trợ GPU phổ thông (1.3B) hoặc tích hợp ComfyUI gốc.
- **HunyuanVideo:** Chọn khi cần tính chân thực chuyển động và độ trung thực hình ảnh tối đa, với phần cứng H200.
- **CogVideoX-1.5-5B:** Chọn khi cần VRAM thấp nhất hoặc tạo clip 10 giây.
- **Open-Sora 2.0:** Chọn khi cần pipeline hiệu quả về huấn luyện ($200K chi phí đã ghi nhận) hoặc workflow T2I2V tích hợp FLUX.

## Hạn chế / Đánh giá trung thực

Wan 2.1 không phải đũa thần. Đây là những gì bảng thông số không nói cho bạn biết:

**Độ dài clip bị giới hạn cứng ở ~5 giây.** Mô hình được đào tạo trên 81 khung 16 FPS. Cố gắng tạo clip dài hơn qua cửa sổ trượt hoặc tiếp cận tự hồi quy sẽ gây suy giảm chất lượng sau khung 81.

**720P trên mô hình 14B chỉ dành cho H100.** README chính thức ghi hỗ trợ 720P nhưng thực tế cần 65–80GB VRAM. RTX 4090 (24GB) không thể chạy 720P ngay cả khi lượng tử hóa.

**Mô phỏng vật lý hạn chế.** Các tương tác vật lý phức tạp (chất lỏng, vải, va chạm vật rắn) xuất hiện artifact. Các mô hình như Kling 2.1 xử lý cảnh vật lý thuyết phục hơn.

**Mô hình 1.3B có đánh đổi chất lượng.** Nó nhanh và dễ tiếp cận nhưng tuân thủ prompt yếu hơn đáng kể so với 14B.

**Mở rộng prompt tăng độ trễ.** Tính năng mở rộng Qwen cải thiện chất lượng nhưng thêm 30–60 giây mỗi lần tạo.

**Thờ gian khởi động lần đầu.** Tải và biên dịch mô hình lần đầu có thể mất 5–10 phút. Các lần sau bắt đầu ngay lập tức.

## Câu hỏi thường gặp

**Q: Wan 2.1 có chạy trên RTX 3060 12GB không?**

Mô hình 1.3B cần 8,19GB VRAM, vì vậy RTX 3060 12GB có thể chạy ở 480P với FP16. Mô hình 14B không chạy được. Sử dụng phiên bản GGUF hoặc FP8 từ cộng đồng nếu cần thêm dung lượng.

**Q: Wan 2.1 so với Sora hay Kling như thế nào?**

Các mô hình độc quyền như Sora và Kling vẫn dẫn đầu về tính nhất quán thờ gian, hiểu biết vật lý và độ dài clip tối đa (60+ giây). Lợi thế của Wan 2.1 là trọng số mở, chạy cục bộ và chi phí API bằng không. Với clip 5 giây, khoảng cách đã thu hẹp đáng kể.

**Q: Sự khác biệt giữa mô hình 1.3B và 14B là gì?**

Mô hình 1.3B được chưng cất từ 14B và tối ưu cho tốc độ. Nó chạy trên GPU phổ thông nhưng chi tiết mềm hơn và tuân thủ prompt yếu hơn. Mô hình 14B là phiên bản chất lượng đầy đủ với động học chuyển động và kết xuất văn bản vượt trội.

**Q: Wan 2.1 có hỗ trợ chỉnh sửa video không?**

Có, thông qua tiện ích mở rộng VACE (Video Auto Content Editing). VACE hỗ trợ tạo video từ tham chiếu, chỉnh sửa video-to-video và chỉnh sửa video có mặt nạ. Cả hai mô hình VACE 1.3B và 14B đều có sẵn.

**Q: Wan 2.1 có thể sử dụng thương mại không?**

Có. Wan 2.1 được cấp phép Apache 2.0, cho phép sử dụng thương mại, sửa đổi và phân phối. Bạn giữ toàn quyền đối với nội dung được tạo.

**Q: Làm thế nào để giảm VRAM cho mô hình 14B?**

Sử dụng `--offload_model True`, `--t5_cpu`, và lượng tử hóa FP8 để giảm xuống còn ~35GB VRAM.

**Q: Video tạo ra bị nhấp nháy hoặc chuyển động không nhất quán?**

Đảm bảo sử dụng Wan 2.1 VAE chính hãng. Sử dụng chính xác 81 khung cho mô hình 14B. Tham số flow_shift nên là 5.0 cho 720P và 3.0 cho 480P.

**Q: Wan 2.1 có hoạt động trên AMD GPU hoặc Apple Silicon không?**

Hỗ trợ chính thức chỉ dành cho CUDA. Các bản port cộng đồng cho ROCm (AMD) tồn tại nhưng hiệu suất khác nhau. Apple Silicon không được khuyến nghị do hạn chế băng thông bộ nhớ.

## Kết luận

Wan 2.1 thực hiện lờ hứa mà ít mô hình video mã nguồn mở làm được: đầu ra chất lượng production trên phần cứng dễ tiếp cận. Mô hình 1.3B dân chủ hóa tạo video cho ngườ dùng cá nhân, trong khi 14B cạnh tranh với dịch vụ độc quyền cho workflow chuyên nghiệp. Với 16.100+ sao GitHub, đóng góp cộng đồng tích cực và giấy phép Apache-2.0, Wan 2.1 là lựa chọn thực tiễn cho các nhóm xây dựng pipeline tạo video vào năm 2026.

**Danh sách hành động:**

1. Clone repository và chạy mô hình 1.3B trên GPU cục bộ ngay hôm nay
2. Benchmark mô hình 14B trên phần cứng H100 cloud
3. Tham gia Wan Discord hoặc GitHub Discussions để được hỗ trợ
4. Đánh giá tích hợp ComfyUI cho phát triển workflow trực quan

Tham gia [nhóm Telegram dibi8](https://t.me/dibi8channel) để nhận phân tích sâu công cụ AI hàng tuần và mẹo triển khai production.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn và Tài liệu tham khảo

- [Kho GitHub Wan 2.1](https://github.com/Wan-Video/Wan2.1)
- [Báo cáo kỹ thuật Wan 2.1 (arXiv:2503.20314)](https://arxiv.org/abs/2503.20314)
- [Mô hình HuggingFace Wan 2.1](https://huggingface.co/Wan-AI)
- [ComfyUI WanVideoWrapper bởi Kijai](https://github.com/Kijai/ComfyUI-WanVideoWrapper)
- [Tài liệu Diffusers Wan 2.1](https://huggingface.co/docs/diffusers/main/en/api/pipelines/wan)
- [Tăng tốc TeaCache Wan 2.1](https://github.com/ali-vilab/TeaCache)
- [Hướng dẫn chỉnh sửa video VACE](https://github.com/ali-vilab/VACE/blob/main/UserGuide.md)
- [Hướng dẫn GPU Cloud cho Video AI (Spheron)](https://www.spheron.network/blog/gpu-cloud-video-ai-2026/)
- [Báo cáo kỹ thuật Open-Sora 2.0](https://arxiv.org/abs/2503.09642)
