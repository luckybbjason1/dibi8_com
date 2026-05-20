---
title: 'HunyuanVideo: 12.1K+ Stars — Hướng Dẫn Triển Khai Production 2026'
description: 'HunyuanVideo (HYV) là framework tạo video nguồn mở 13B tham số do Tencent phát triển. Hỗ trợ ComfyUI, Diffusers, Gradio API. Bao gồm Docker, FP8 quantization, đa GPU, và production hardening.'
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
github_repo: 'https://github.com/Tencent-Hunyuan/HunyuanVideo'
stars: 12100
maintainer: 'Tencent-Hunyuan'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['tạo-video', 'diffusion-transformer', 'tencent', 'hunyuanvideo', 'comfyui', 'docker', 'fp8', 'đa-phương-thức']
aliases:
- /vi/posts/hunyuan-video/
---

{{</* resource-info */>}}

Một mô hình tạo video cần 60GB VRAM để tạo ra clip 5 giây ở 720p không phải là đồ chơi — nó là hạ tầng. HunyuanVideo của Tencent, một mô hình Diffusion Transformer 13 tỷ tham số để tạo video, đã tích lũy hơn 12.100 sao trên GitHub và trở thành lựa chọn hàng đầu cho các team cần tổng hợp video chất lượng điện ảnh trên phần cứng tự quản lý. Hướng dẫn này đi qua toàn bộ thiết lập production: từ triển khai Docker hoạt động được đến quantization FP8, suy luận song song đa GPU, tích hợp ComfyUI, và giám sát cần thiết khi phục vụ ở quy mô lớn.

## HunyuanVideo là gì?

HunyuanVideo là một framework hệ thống cho các mô hình tạo video quy mô lớn được phát triển bởi Tencent. Bản phát hành gốc (tháng 12/2024) có một Diffusion Transformer (DiT) 13 tỷ tham số tạo ra các clip video 720p từ prompt văn bản hoặc hình ảnh tham chiếu. Bản tiếp theo tháng 11/2025, HunyuanVideo-1.5, giảm số tham số xuống 8.3 tỷ trong khi giới thiệu cơ chế SSTA (Selective and Sliding Tile Attention) và bộ nâng độ phân giải siêu nét built-in lên 1080p. Cả hai phiên bản đều có giấy phép Apache-2.0 và chạy trên Linux với GPU NVIDIA.

## HunyuanVideo hoạt động như thế nào?

Kiến trúc theo một pipeline latent diffusion với ba thành phần chính:

![Kiến trúc tổng thể HunyuanVideo](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/backbone.png)

**Causal 3D VAE** nén video đầu vào vào không gian latent với tỷ lệ nén thờ gian 4x và không gian 8x. Điều này giảm số lượng token đưa vào transformer, cho phép tạo ở độ phân giải cao hơn mà không cần tăng tính toán tỷ lệ thuận.

**MLLM Text Encoder** thay thế bộ đôi CLIP + T5-XXL truyền thống. HunyuanVideo sử dụng Mô hình Ngôn ngữ Đa phương thức Lớn (biến thể Qwen2.5-VL fine-tuned trong 1.5) với bộ tinh chỉnh token hai chiều. Điều này tạo ra sự tuân thủ prompt tốt hơn cho các mô tả cảnh phức tạp.

![Kiến trúc Text Encoder HunyuanVideo](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/text_encoder.png)

**Dual-stream to Single-stream DiT** xử lý token video và văn bản độc lập qua các khối transformer ban đầu (dual-stream), sau đó nối chúng để tạo sự hợp nhất đa phương thức ở các khối sau (single-stream). Thiết kế hybrid này cân bằng học tập theo từng phương thức với attention đa phương thức.

![Kiến trúc 3D VAE HunyuanVideo](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/3dvae.png)

**SSTA Attention (chỉ 1.5)** cắt bỏ động các khối key/value thờ gian dư thừa bằng cửa sổ tile trượt. So với FlashAttention-3, điều này mang lại tốc độ end-to-end nhanh hơn 1.87x khi tổng hợp 10 giây 720p.

## Cài đặt & Thiết lập

Con đường nhanh nhất đến instance HunyuanVideo hoạt động là Docker. Cho các team cần build tùy chỉnh, cài đặt conda thủ công theo sau.

### Triển khai Docker (Khuyến nghị)

```bash
# Pull image CUDA 12 chính thức
docker pull hunyuanvideo/hunyuanvideo:cuda_12

# Chạy với GPU passthrough
docker run -itd --gpus all --init --net=host --uts=host --ipc=host \
  --name hunyuanvideo \
  --security-opt=seccomp=unconfined \
  --ulimit=stack=67108864 --ulimit=memlock=-1 \
  --privileged \
  -v /mnt/models:/models \
  -p 8081:8081 \
  hunyuanvideo/hunyuanvideo:cuda_12
```

### Cài đặt thủ công trên Ubuntu

```bash
# Clone repository
git clone https://github.com/Tencent-Hunyuan/HunyuanVideo.git
cd HunyuanVideo

# Tạo môi trường conda
conda create -n hunyuan python==3.10.9 -y
conda activate hunyuan

# Cài PyTorch với CUDA 12.4
conda install pytorch==2.6.0 torchvision==0.19.0 torchaudio==2.4.0 \
  pytorch-cuda=12.4 -c pytorch -c nvidia -y

# Cài dependencies Python
python -m pip install -r requirements.txt

# Cài Flash Attention v2 để tăng tốc
python -m pip install ninja
python -m pip install git+https://github.com/Dao-AILab/flash-attention.git@v2.6.3

# Cài xDiT cho suy luận song song đa GPU
python -m pip install xfuser==0.4.0
```

### Tải trọng số Mô hình Pretrained

```bash
# Cài huggingface-cli
pip install huggingface_hub

# Tải trọng số DiT chính
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states.pt" \
  --local-dir ./ckpts

# Tải trọng số quantized FP8 (tiết kiệm ~10GB VRAM)
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states_fp8.pt" \
  --local-dir ./ckpts

# Tải mô hình text encoder
huggingface-cli download tencent/HunyuanVideo \
  --include "*text_encoder*" \
  --local-dir ./ckpts
```

### Chạy Suy luận đầu tiên

```bash
conda activate hunyuan

python sample_video.py \
    --video-size 720 1280 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A cat walks on the grass, realistic style, golden hour lighting" \
    --flow-reverse \
    --use-cpu-offload \
    --save-path ./results
```

Flag `--use-cpu-offload` là bắt buộc cho GPU có dưới 80GB VRAM. Nó offload trọng số mô hình sang RAM hệ thống khi không sử dụng, đánh đổi tốc độ lấy bộ nhớ.

## Tích hợp với Các Công cụ Phổ biến

### ComfyUI (Node Gốc)

ComfyUI đã thêm hỗ trợ HunyuanVideo gốc vào đầu 2025. Tải các tệp mô hình repackaged từ Comfy-Org:

```bash
# Tệp mô hình đặt vào ComfyUI/models/
# - text_encoders/clip_l.safetensors
# - text_encoders/llava_llama3_vision.safetensors
# - diffusion_models/hunyuan_video_720p_bf16.safetensors
# - vae/hunyuan_video_vae_bf16.safetensors
```

Tải workflow chính thức bằng cách kéo JSON vào ComfyUI. Các node chính là `HunyuanVideoSampler`, `HunyuanVideoDecode`, và `TextEncodeHunyuanVideo`.

### HunyuanVideoWrapper của Kijai (Nâng cao)

Cho suy luận FP8, video-to-video, và image-to-video, sử dụng wrapper cộng đồng:

```bash
# Cài qua ComfyUI Manager hoặc git
cd ComfyUI/custom_nodes
git clone https://github.com/kijai/ComfyUI-HunyuanVideoWrapper.git

# Cài dependencies
cd ComfyUI-HunyuanVideoWrapper
pip install -r requirements.txt
```

Tải trọng số FP8 từ `Kijai/HunyuanVideo_comfy` trên Hugging Face và đặt vào `ComfyUI/models/diffusion_models/`.

### Pipeline Diffusers

```python
from diffusers import HunyuanVideoPipeline
import torch

pipe = HunyuanVideoPipeline.from_pretrained(
    "tencent/HunyuanVideo-1.5",
    torch_dtype=torch.bfloat16,
    variant="fp8"
)
pipe.enable_model_cpu_offload()

video = pipe(
    prompt="A cat playing piano in a jazz club, warm lighting",
    num_frames=121,
    height=720,
    width=1280,
    num_inference_steps=30,
    guidance_scale=6.0
).frames[0]

# Lưu video
import numpy as np
from PIL import Image
frames = [(f * 255).astype(np.uint8) for f in video]
frames = [Image.fromarray(f) for f in frames]
frames[0].save(
    "output.mp4",
    save_all=True,
    append_images=frames[1:],
    duration=67,
    loop=0
)
```

### Máy chủ Gradio API

```bash
# Khởi động máy chủ Gradio
python gradio_server.py --flow-reverse

# Hoặc bind tới tất cả interface cho truy cập từ xa
SERVER_NAME=0.0.0.0 SERVER_PORT=8081 \
  python gradio_server.py --flow-reverse --use-cpu-offload
```

Giao diện Gradio expose các tham số cho prompt, độ phân giải, số khung hình, tỷ lệ CFG, và seed. Cho truy cập lập trình, kiểm tra tab network trong trình duyệt để tìm endpoint `/run/predict` và sao chép JSON payload.

### DigitalOcean GPU Droplets

Cho các team không có phần cứng GPU tại chỗ, DigitalOcean GPU Droplets cung cấp instance NVIDIA H100 và A100 theo nhu cầu:

```yaml
#cloud-config
package_update: true
packages:
  - docker.io
  - nvidia-container-toolkit
runcmd:
  - systemctl restart docker
  - docker pull hunyuanvideo/hunyuanvideo:cuda_12
  - docker run -d --gpus all --name hunyuan \
      -p 8081:8081 -v /mnt/models:/models \
      hunyuanvideo/hunyuanvideo:cuda_12 \
      python gradio_server.py --flow-reverse --use-cpu-offload
```

## Benchmark / Trường hợp Sử dụng Thực tế

Benchmark cộng đồng từ thử nghiệm RTX 4090 và GPU datacenter (tháng 3/2026):

| Mô hình | Tham số | VRAM (720p) | Thờ gian Tạo (5s, RTX 4090) | Chất lượng Thẩm mỹ |
|---|---|---|---|---|
| HunyuanVideo (gốc) | 13B | ~60GB | ~5:50 | 8.8/10 |
| HunyuanVideo-1.5 | 8.3B | ~24GB (INT8) | ~3:20 | 8.5/10 |
| Wan 2.2 | 14B | ~48GB | ~4:20 | 8.5/10 |
| LTX-Video 0.9.5 | 13B | ~16GB | ~1:30 | 7.4/10 |
| CogVideoX-5B | 5B | ~12GB | ~8:10 | 6.8/10 |

**Trường hợp sử dụng production quan sát được:**

- **Tạo quảng cáo sáng tạo**: Một team thương mại điện tử ở Thâm Quyến tạo 200+ video giới thiệu sản phẩm mỗi ngày bằng HunyuanVideo với LoRA tùy chỉnh. Họ báo cáo thẩm mỹ điện ảnh giảm 60% thờ gian hậu kỳ so với output Wan.

- **Xưởng nội dung mạng xã hội**: Một MCN ở Brazil chạy HunyuanVideo trên node 4xA100 qua suy luận song song xDiT, sản xuất clip dọc 5 giây cho TikTok và Reels.

- **Dựng phim pre-visualization**: Một đạo diễn phim độc lập ở LA sử dụng pipeline image-to-video để tạo hoạt hình cho khung storyboard.

## Sử dụng Nâng cao / Hardening Production

### Quantization FP8 để Giảm Bộ nhớ

Quantization FP8 chuyển đổi trọng số FP32 sang định dạng dấu phẩy động 8-bit, giảm sử dụng bộ nhớ GPU khoảng 10GB với tác động chất lượng tối thiểu.

```bash
# Tải trọng số FP8 và tệp scale
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states_fp8.pt" \
  --include "mp_rank_00_model_states_fp8_map.pt" \
  --local-dir ./ckpts/fp8

# Chạy suy luận với FP8
python sample_video.py \
    --dit-weight ./ckpts/fp8/mp_rank_00_model_states_fp8.pt \
    --video-size 1280 720 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A golden retriever runs on a beach at sunset" \
    --flow-reverse \
    --use-cpu-offload \
    --use-fp8 \
    --save-path ./results
```

Flag `--use-fp8` kích hoạt pipeline FP8 trong `hyvideo/modules/fp8_optimization.py`. Định dạng E4M3 (4 bit exponent, 3 bit mantissa) duy trì đủ độ chính xác cho suy luận trong khi cắt giảm ~40% bộ nhớ.

### Suy luận Song song Đa GPU với xDiT

Cho workload production, xDiT cung cấp Unified Sequence Parallelism mở rộng trên nhiều GPU:

```bash
# Suy luận song song 8 GPU
torchrun --nproc_per_node=8 sample_video.py \
    --video-size 1280 720 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A cinematic aerial shot of a mountain valley at dawn" \
    --flow-reverse \
    --seed 42 \
    --ulysses-degree 8 \
    --ring-degree 1 \
    --save-path ./results
```

Độ trễ mở rộng trên 1280x720, 129 khung hình, 50 bước:

| GPU | Độ trễ (giây) | Tăng tốc |
|---|---|---|
| 1 | 1904 | 1.00x |
| 2 | 934 | 2.04x |
| 4 | 514 | 3.70x |
| 8 | 338 | 5.64x |

Các tham số `--ulysses-degree` và `--ring-degree` điều khiển chiến lược song song.

### Gradio Production với Reverse Proxy

```bash
# Khởi động với cài đặt production
SERVER_NAME=0.0.0.0 \
SERVER_PORT=8081 \
python gradio_server.py \
  --flow-reverse \
  --use-cpu-offload \
  --use-fp8 \
  --max-queue-size 10 \
  --queue-timeout 300
```

Sau reverse proxy Nginx với giới hạn tốc độ:

```nginx
upstream hunyuan {
    server 127.0.0.1:8081;
    keepalive 32;
}

server {
    listen 443 ssl http2;
    server_name video-api.yourdomain.com;

    client_max_body_size 100M;

    location / {
        proxy_pass http://hunyuan;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_read_timeout 600s;
    }

    # Giới hạn tốc độ: 10 yêu cầu/phút mỗi IP
    limit_req_zone $binary_remote_addr zone=video:10m rate=10r/m;
    limit_req zone=video burst=5 nodelay;
}
```

### Giám sát với Prometheus

```python
# Thêm vào gradio_server.py hoặc wrap lờ gọi suy luận
from prometheus_client import Counter, Histogram, start_http_server
import time

inference_count = Counter('hunyuan_inferences_total', 'Tổng số suy luận')
inference_duration = Histogram('hunyuan_inference_seconds', 'Độ trễ suy luận')
queue_depth = Gauge('hunyuan_queue_depth', 'Độ sâu hàng đợi hiện tại')

@inference_duration.time()
def generate_video(prompt, height, width, frames, steps):
    inference_count.inc()
    # ... logic suy luận hiện có
    return video

# Khởi động máy chủ metrics trên cổng 9090
start_http_server(9090)
```

### Hardening Bảo mật

- **Toàn vẹn trọng số mô hình**: Xác minh trọng số đã tải với checksum SHA-256 từ thẻ mô hình Hugging Face.
- **Làm sạch đầu vào**: Làm sạch prompt trước khi gửi đến text encoder MLLM.
- **Cô lập GPU**: Trong môi trường đa tenant, sử dụng NVIDIA MIG để phân vùng GPU A100/H100.
- **Cô lập mạng**: Chạy container Gradio trên VPC nội bộ. Chỉ expose qua API gateway với xác thực.

## So Sánh với Các Giải pháp Thay thế

| Tính năng | HunyuanVideo | Wan 2.2 | CogVideoX-5B | Open-Sora |
|---|---|---|---|---|
| Tham số | 13B (8.3B ở 1.5) | 14B | 5B | 1.1B - 7B |
| Độ phân giải tối đa | 1080p (qua SR) | 1080p | 720p | 720p |
| VRAM tối thiểu (720p) | 24GB (INT8) | 24GB | 12GB | 16GB |
| Văn bản sang Video | Có | Có | Có | Có |
| Hình ảnh sang Video | Có (1.5) | Có | Có | Có |
| Giấy phép | Apache-2.0 | Apache-2.0 | Apache-2.0 | BSD-3-Clause |
| Chất lượng điện ảnh | 8.8/10 | 8.5/10 | 6.8/10 | 7.0/10 |
| Thờ gian tạo (5s, 4090) | 5:50 (gốc) | 4:20 | 8:10 | 6:00 |
| Chân thực chuyển động | Xuất sắc | Xuất sắc | Trung bình | Tốt |
| Prompt song ngữ | Có (CN/EN) | Có (CN/EN) | Có (CN/EN) | Tập trung EN |
| Upscaler tích hợp | Có (1.5) | Không | Không | Không |
| Hỗ trợ ComfyUI | Có | Có | Có | Có |
| Song song Đa GPU | Có (xDiT) | Có (USP) | Hạn chế | Không |

Điểm khác biệt chính của HunyuanVideo là thẩm mỹ điện ảnh và chân thực chuyển động. "House style" tạo ra color grading phong phú, bokeh tự nhiên, và chuyển động phim ảnh ngay từ đầu. Wan 2.2 nhỉnh hơn về khuôn mặt ngườ photorealistic và chi tiết tinh xảo. CogVideoX-5B vẫn là nhà vô địch tiếp cận cho GPU 12GB.

## Hạn chế / Đánh giá Trung thực

**Tốc độ**: Ngay cả với FP8 và SSTA, HunyuanVideo chậm hơn Wan 2.2 và chậm hơn đáng kể LTX-Video. Nếu workflow của bạn cần lặp lại nhanh, LTX-Video hoặc API thương mại phù hợp hơn.

**Yêu cầu VRAM**: Mô hình gốc 13B cần 60GB cho tạo 720p. Chỉ bản 1.5 với INT8 quantization mới giảm xuống 24GB. Các team không có phần cứng A100, H100, hoặc RTX 4090 nên xem xét CogVideoX hoặc suy luận đám mây.

**Phụ thuộc prompt**: Prompt ngắn hoặc mơ hồ tạo ra kết quả không nhất quán. Mô hình cần mô tả chi tiết, có cấu trúc (30-60 từ).

**Giới hạn độ phân giải**: Tạo native tối đa 720p. Mạng SR 1080p trong 1.5 tăng thờ gian xử lý và có thể tạo artifact trên texture phức tạp.

**Độ dài clip**: Tạo thực tế giới hạn ở 5-10 giây. Các chuỗi dài hơn yêu cầu tài nguyên vượt quá cả thông số H100.

**Chỉ Linux**: Không có hỗ trợ Windows hoặc macOS chính thức. WSL2 có thể hoạt động nhưng không được tài liệu hóa hoặc kiểm tra.

## Các Câu hỏi Thường gặp

**Q: Tôi thực sự cần bao nhiêu VRAM để chạy HunyuanVideo?**

A: Mô hình gốc 13B cần 60GB bộ nhớ GPU cho tạo 720p và 45GB cho 540p. HunyuanVideo-1.5 giảm xuống 24GB với quantization INT8, hoặc 14GB nếu bật CPU offloading. Trọng số FP8 tiết kiệm khoảng 10GB so với FP16. Cho production, khuyến nghị NVIDIA A100 80GB hoặc H100; cho thử nghiệm, RTX 4090 (24GB) có thể chạy mô hình 1.5 với quantization.

**Q: Tôi có thể chạy HunyuanVideo trên Windows không?**

A: Chính thức thì không — dự án chỉ hỗ trợ Linux. Một số ngườ dùng báo cáo thành công với WSL2 và CUDA passthrough, nhưng đội Tencent không tài liệu hóa hoặc hỗ trợ điều này. Cho các team Windows, Docker Desktop với backend WSL2 là con đường khả thi nhất.

**Q: HunyuanVideo so với API thương mại như Sora hoặc Kling như thế nào?**

A: Trong đánh giá con ngườ, HunyuanVideo vượt trội Runway Gen-3 và Luma 1.6 về chất lượng chuyển động và xếp hạng tổng thể. Khoảng cách với các mô hình thương mại hàng đầu đã thu hẹp đáng kể nhưng vẫn còn đo lường được ở chủ thể ngườ photorealistic. Sự đánh đổi là chi phí: API thương mại tính $0.10-0.50/giây video, trong khi HunyuanVideo tự quản chỉ cần thờ gian tính toán GPU (khoảng $0.14-0.21/giây trên instance H200).

**Q: Định dạng prompt tốt nhất cho HunyuanVideo là gì?**

A: Sử dụng prompt có cấu trúc phân tách rõ chủ thể, hành động, và môi trường. Mục tiêu 30-60 từ. Bật tính năng viết lại prompt (Normal cho độ chính xác, Master cho polish hình ảnh) để tự động mở rộng.

**Q: Làm thế nào để tăng tốc suy luận trong production?**

A: Kết hợp nhiều tối ưu: (1) Sử dụng trọng số quantized FP8. (2) Bật suy luận song song đa GPU xDiT — 8x A100 đạt tốc độ nhanh gấp 5.6x. (3) Dùng biến thể CFG-distilled ~2x nhanh hơn. (4) Bật caching đặc trưng TeaCache. (5) Với 1.5, SSTA tự động cung cấp tốc độ nhanh hơn 1.87x.

**Q: Tôi có thể nhận trợ giúp hoặc thảo luận HunyuanVideo ở đâu?**

A: Đội Tencent duy trì máy chủ Discord và nhóm WeChat được liên kết từ README GitHub. Cho lập trình viên nói tiếng Anh, diễn đàn cộng đồng Hugging Face và ComfyUI Discord có các kênh HunyuanVideo hoạt động.

## Kết luận

HunyuanVideo là một framework tạo video đẳng cấp production bắc nhịp giữa API thương mại đóng và khả năng tiếp cận nguồn mở. Với bản 1.5 mang 8.3 tỷ tham số, attention SSTA, và khả năng tương thích GPU ngườ dùng, nó đã trở thành lựa chọn thực tế cho cả studio và ngườ sáng tạo độc lập.

Các hành động để bắt đầu ngay hôm nay:

1. Clone repository và chạy Docker image trên instance GPU — image CUDA 12 chính thức là con đường nhanh nhất.
2. Tải trọng số FP8 và chạy tạo 720p đầu tiên với `sample_video.py`.
3. Tích hợp với ComfyUI bằng wrapper của Kijai để chỉnh sửa workflow trực quan.
4. Tham gia [nhóm Telegram dibi8](https://t.me/dibi8Channel) để thảo luận chiến lược triển khai và chia sẻ video đã tạo.

*Một số liên kết trong bài viết này là liên kết affiliate. Chúng tôi có thể nhận hoa hồng nếu bạn mua dịch vụ qua chúng — điều này giúp hỗ trợ dự án nguồn mở dibi8 mà không phát sinh thêm chi phí cho bạn.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu Tham khảo

- Repository Chính thức: https://github.com/Tencent-Hunyuan/HunyuanVideo
- Repository HunyuanVideo-1.5: https://github.com/Tencent-Hunyuan/HunyuanVideo-1.5
- Trang Dự án: https://aivideo.hunyuan.tencent.com
- Thẻ Mô hình Hugging Face: https://huggingface.co/tencent/HunyuanVideo
- Hướng dẫn ComfyUI Wiki: https://comfyui-wiki.com/en/tutorial/advanced/hunyuan-text-to-video-workflow-guide-and-example
- Báo cáo Kỹ thuật (arXiv): https://arxiv.org/abs/2412.03603
- Báo cáo Kỹ thuật HunyuanVideo 1.5: https://arxiv.org/abs/2511.18870
- Suy luận Song song xDiT: https://github.com/xdit-project/xDiT
- Wrapper ComfyUI của Kijai: https://github.com/kijai/ComfyUI-HunyuanVideoWrapper
- DigitalOcean GPU Droplets: https://www.digitalocean.com/products/gpu-droplets
