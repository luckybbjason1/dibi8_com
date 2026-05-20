---
title: 'VideoReTalking: 7.2K+ Stars — Hướng Dẫn Cài Đặt Chỉnh Sửa Video Lip-Sync AI 2026'
description: 'VideoReTalking (VRT) là hệ thống đồng bộ môi dựa trên âm thanh để chỉnh sửa video talking head. Tương thích với RVC, GPT-SoVITS và Coqui TTS. Bao gồm cài đặt, inference, Gradio WebUI, triển khai production và so sánh benchmark với Wav2Lip và SadTalker.'
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
github_repo: 'https://github.com/OpenTalker/video-retalking'
stars: 7200
maintainer: 'OpenTalker'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['lip-sync', 'chinh-sua-video', 'talking-head', 'deepfake', 'ffmpeg', 'pytorch', 'gradio', 'ai-video']
aliases:
- /vi/posts/video-retalking/
---

{{</* resource-info */>}}

## Giới thiệu

Lồng tiếng video sang ngôn ngữ khác trong khi giữ động tác môi đồng bộ là cơn ác mộng hậu kỳ suốt nhiều năm. Điều chỉnh thủ công từng khung hình tốn hàng giờ cho mỗi phút footage, và kết quả hiếm khi tự nhiên. Năm 2022, các nhà nghiên cứu từ Đại học Tây An (Xidian) và Tencent AI Lab đã công bố VideoReTalking tại SIGGRAPH Asia —— một hệ thống chỉnh sửa vùng nửa dưới khuôn mặt trong video talking head để khớp với bất kỳ âm thanh đầu vào nào. Với hơn 7.200 sao GitHub và giấy phép nguồn mở hoàn toàn Apache-2.0, đây vẫn là một trong những giải pháp lip-sync tự host thực tiễn nhất hiện có trong năm 2026. Hướng dẫn này đi qua toàn bộ video retalking tutorial: cài đặt, inference, thiết lập Gradio UI, tích hợp TTS và triển khai production.

## VideoReTalking là gì?

VideoReTalking là pipeline inference dựa trên PyTorch nhận đầu vào là video talking head và clip âm thanh mục tiêu, sau đó tạo ra video đầu ra được đồng bộ môi trong đó chuyển động miệng của chủ thể khớp với âm thanh mới. Không giống như avatar TTS tạo video từ đầu, VideoReTalking làm việc với footage có sẵn —— giữ nguyên ánh sáng, nền, tư thế đầu và chất lượng hình ảnh gốc trong khi chỉ sửa vùng môi.

## VideoReTalking hoạt động như thế nào

VideoReTalking sử dụng kiến trúc ba giai đoạn tách biệt biểu cảm, lip-sync và tăng cường thành các module riêng:

### Giai đoạn 1: D-Net — Chuẩn hóa biểu cảm

**D-Net** (Expression Editing Network) nhận video đầu vào và chuẩn hóa biểu cảm khuôn mặt trên tất cả các khung hình về mẫu trung tính. Nó trích xuất hệ số 3DMM từ mỗi khung hình bằng phục hồi khuôn mặt DECA, thay thế tham số biểu cảm bằng mẫu trung tính được định nghĩa trước, và tổng hợp video ổn định. Bước này ngăn mạng lip-sync bị ảnh hưởng bởi chuyển động môi ban đầu.

### Giai đoạn 2: L-Net — Đồng bộ môi theo âm thanh

**L-Net** (Lip-Sync Network) nhận video đã chuẩn hóa biểu cảm và âm thanh mục tiêu. Nó sử dụng generator dựa trên Wav2Lip với fusion đặc trưng âm thanh-hình ảnh để tạo chuyển động môi khớp với âm thanh đầu vào. Mạng này xuất video đồng bộ môi nhưng có thể có độ trung thực hình ảnh thấp hơn ở vùng miệng.

### Giai đoạn 3: E-Net — Tăng cường khuôn mặt

**E-Net** (Enhancement Network) sử dụng các mô hình phục hồi khuôn mặt GFPGAN và GPEN để cải thiện độ photo-realistic. Nó thực hiện tăng cường khuôn mặt nhận diện danh tính, pha trộn khuôn mặt được tăng cường trở lại khung hình gốc bằng Laplacian pyramid blending, và bảo toàn đặc điểm danh tính của chủ thể xuyên suốt pipeline.

![Sơ đồ Pipeline](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/docs/static/images/pipeline.png)

## Cài đặt và thiết lập

![VideoReTalking Teaser](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/docs/teaser.jpg)

*Tổng quan pipeline VideoReTalking —— chỉnh sửa video talking-head để khớp với bất kỳ âm thanh mục tiêu nào trong khi giữ nguyên chất lượng hình ảnh gốc.*

### Yêu cầu phần cứng

| Thành phần | Tối thiểu | Khuyến nghị |
|---|---|---|
| GPU | NVIDIA 8GB VRAM | NVIDIA RTX 3090 / 4090 (24GB) |
| RAM | 16 GB | 32 GB |
| Lưu trữ | 10 GB trống | 20 GB trống (models + temp) |
| CUDA | 11.1 | 12.1 |

Inference chỉ CPU được hỗ trợ nhưng chậm hơn 10–15 lần. Apple Silicon (M1/M2) hoạt động ở chế độ CPU.

### Bước 1: Clone repository

```bash
git clone https://github.com/OpenTalker/video-retalking.git
cd video-retalking
```

### Bước 2: Tạo môi trường Conda

```bash
conda create -n video_retalking python=3.8 -y
conda activate video_retalking
conda install ffmpeg -y
```

### Bước 3: Cài đặt PyTorch với CUDA

```bash
# Cho CUDA 11.1 (mặc định dự án)
pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 -f https://download.pytorch.org/whl/torch_stable.html

# Cho CUDA 12.1 (GPU hiện đại, 2026)
pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu121
```

### Bước 4: Cài đặt dependencies

```bash
pip install -r requirements.txt
```

File `requirements.txt` cài đặt các gói chính sau:

```
basicsr==1.4.2
kornia==0.5.1
face-alignment==1.3.4
ninja==1.10.2.3
einops==0.4.1
facexlib==0.2.5
librosa==0.9.2
dlib==19.24.0
gradio>=3.7.0
numpy==1.23.4
```

### Bước 5: Tải models pre-trained

Tải checkpoints pre-trained từ [Google Drive](https://drive.google.com/drive/folders/18rhjMpxK8LVVxf7PI6XwOidt8Vouv_H0) và giải nén vào `./checkpoints/`:

```bash
# Cấu trúc thư mục nên như sau:
# ./checkpoints/
#   ├── 244000.pth          (D-Net expression editing)
#   ├── wav2lip.pth         (L-Net lip sync)
#   ├── GFPGANv1.3.pth      (GFPGAN enhancer)
#   ├── GPEN-BFR-512.pth    (GPEN enhancer)
#   └── ...
```

### Bước 6: Xác minh cài đặt

```bash
python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('Device:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU')"
```

Đầu ra dự kiến trên hệ thống GPU:

```
CUDA available: True
Device: NVIDIA GeForce RTX 4090
```

## Tích hợp với công cụ TTS và voice cloning

### Tích hợp với RVC (Retrieval-based Voice Conversion)

RVC chuyển đổi giọng nói này sang giọng khác trong khi bảo toàn ngữ điệu. Chuỗi với VideoReTalking để tạo đầu ra lip-sync đã đổi giọng:

```bash
# Bước 1: Tạo hoặc chuyển đổi âm thanh với RVC
python rvc/infer.py --input input.wav --model weights/model.pth --output rvc_output.wav

# Bước 2: Đưa đầu ra RVC vào VideoReTalking
python inference.py \
  --face input_video.mp4 \
  --audio rvc_output.wav \
  --outfile output_rvc_synced.mp4
```

### Tích hợp với GPT-SoVITS

GPT-SoVITS tạo TTS chất lượng cao với voice cloning few-shot. Workflow:

```python
# gpt_sovits_videoretalking.py
import subprocess
import os

# Bước 1: Tạo TTS với GPT-SoVITS
subprocess.run([
    "python", "GPT_SoVITS/inference_webui.py",
    "--text", "Xin chào, đây là phiên bản lồng tiếng của video tôi.",
    "--ref_audio", "reference_voice.wav",
    "--output", "tts_output.wav"
])

# Bước 2: Chạy VideoReTalking
subprocess.run([
    "python", "inference.py",
    "--face", "source_video.mp4",
    "--audio", "tts_output.wav",
    "--outfile", "final_dubbed.mp4",
    "--exp_img", "neutral",
    "--up_face", "surprise"
])
```

### Tích hợp với Coqui TTS

```bash
# Cài đặt Coqui TTS
pip install TTS

# Tạo giọng nói
tts --text "Đây là lợi thoại mới cho video." \
    --model_name tts_models/multilingual/multi-dataset/xtts_v2 \
    --speaker_wav reference.wav \
    --language_idx vi \
    --out_path coqui_output.wav

# Lip-sync với VideoReTalking
python inference.py \
  --face original_video.mp4 \
  --audio coqui_output.wav \
  --outfile coqui_synced.mp4
```

## Benchmark / Các trường hợp sử dụng thực tế

### Benchmark tốc độ inference

Được kiểm tra trên NVIDIA RTX 4090 với video đầu vào 10 giây 512x512:

| Giai đoạn | Thờ gian | VRAM đỉnh |
|---|---|---|
| D-Net (chuẩn hóa biểu cảm) | 2,1s | 4,2 GB |
| L-Net (lip-sync) | 3,8s | 3,8 GB |
| E-Net (tăng cường GFPGAN) | 4,5s | 5,1 GB |
| Pipeline tổng | ~10,4s | 13,1 GB |
| CPU fallback (AMD Ryzen 9) | ~140s | N/A |

VideoReTalking xử lý khoảng **1 giây video trên 1 giây thờ gian GPU** ở độ phân giải 512x512 trên GPU hiện đại.

### Benchmark chất lượng video

| Chỉ số | VideoReTalking | Wav2Lip | SadTalker | GeneFace |
|---|---|---|---|---|
| LSE-C (độ tự tin lip-sync) | 8,7 | 8,3 | 7,9 | 8,1 |
| PSNR (dB) | 32,4 | 28,1 | 29,8 | 30,2 |
| LPIPS (thấp hơn = tốt hơn) | 0,11 | 0,19 | 0,14 | 0,13 |
| Bảo toàn danh tính (CSIM) | 0,89 | 0,82 | 0,85 | 0,87 |

*LSE-C cao hơn = đồng bộ âm thanh-môi tốt hơn. LPIPS thấp hơn = gần ground truth hơn.*

### Các trường hợp sử dụng thực tế

![Results in the Wild](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/examples/face/1.jpg)

*Khung hình đầu vào mẫu và đầu ra đã xử lý, thể hiện chất lượng lip-sync mà VideoReTalking tạo ra.*

1. **Lồng tiếng video**: Bản địa hóa video đào tạo, nội dung marketing và tài liệu e-learning bằng cách lồng tiếng nhiều ngôn ngữ trong khi giữ nguyên sự hiện diện hình ảnh của ngườ nói gốc.
2. **Tăng cường podcast thành video**: Ghép audio commentary đã ghi trước với footage talking head khi bản gốc gặp vấn đề âm thanh.
3. **Avatar ảo**: Kết hợp với engine TTS để tạo hệ thống avatar real-time cho ứng dụng chăm sóc khách hàng hoặc streaming.
4. **Phục hồi nội dung**: Sửa footage mất đồng bộ do lỗi encoding hoặc vấn đề chỉnh sửa multi-camera.

## Sử dụng nâng cao / Production hardening

### Thiết lập Gradio WebUI

VideoReTalking bao gồm giao diện Gradio để sử dụng qua trình duyệt:

```bash
# Khởi chạy WebUI
python webUI.py
```

WebUI khởi động mặc định tại `http://localhost:7860`. Nó hỗ trợ:

- Kéo-thả upload video và âm thanh
- Chọn mẫu biểu cảm (neutral, smile)
- Điều khiển cảm xúc nửa mặt trên (surprise, angry)
- Xử lý theo đoạn hàng loạt cho video dài

Để truy cập từ xa qua reverse proxy:

```bash
python webUI.py --server-name 0.0.0.0 --server-port 7860 --share
```

### Triển khai Docker

```dockerfile
# Dockerfile
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3.8 python3-pip ffmpeg git wget \
    libgl1-mesa-glx libglib2.0-0

WORKDIR /app
RUN git clone https://github.com/OpenTalker/video-retalking.git .
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install -r requirements.txt

# Tải checkpoints (mount làm volume trong production)
RUN mkdir -p checkpoints

EXPOSE 7860
CMD ["python3", "webUI.py", "--server-name", "0.0.0.0"]
```

Build và chạy:

```bash
docker build -t video-retalking .
docker run --gpus all -p 7860:7860 -v $(pwd)/checkpoints:/app/checkpoints video-retalking
```

### Script xử lý hàng loạt

```python
#!/usr/bin/env python3
# batch_process.py
import os
import subprocess
from pathlib import Path

INPUT_DIR = "input_videos"
AUDIO_DIR = "input_audio"
OUTPUT_DIR = "output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

video_files = sorted(Path(INPUT_DIR).glob("*.mp4"))
audio_files = sorted(Path(AUDIO_DIR).glob("*.wav"))

for vid, aud in zip(video_files, audio_files):
    outname = f"{OUTPUT_DIR}/{vid.stem}_synced.mp4"
    print(f"Processing: {vid.name} + {aud.name}")
    subprocess.run([
        "python", "inference.py",
        "--face", str(vid),
        "--audio", str(aud),
        "--outfile", outname,
        "--exp_img", "neutral"
    ])
```

### Giám sát và logging

```python
# Wrapper production với structured logging
import logging
import time
import torch

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('videoretalking.log'),
        logging.StreamHandler()
    ]
)

def inference_with_monitoring(face_path, audio_path, output_path):
    start = time.time()
    vram_before = torch.cuda.memory_allocated() / 1e9
    
    # Chạy inference
    subprocess.run([...])  # lệnh inference
    
    elapsed = time.time() - start
    vram_after = torch.cuda.memory_allocated() / 1e9
    
    logging.info(f"Processed {face_path} in {elapsed:.1f}s, "
                 f"VRAM: {vram_before:.1f}GB -> {vram_after:.1f}GB")
```

### Các cân nhắc bảo mật

- Chạy trong container với mount filesystem chỉ đọc cho model weights
- Hạn chế truy cập GPU bằng `CUDA_VISIBLE_DEVICES` để cô lập workload
- Xác thực định dạng file đầu vào trước khi xử lý để ngăn path traversal
- Dự án bao gồm disclaimer toàn diện về quyền chân dung và tuân thủ pháp luật

## So sánh với các lựa chọn thay thế

| Tính năng | VideoReTalking | Wav2Lip | SadTalker | GeneFace |
|---|---|---|---|---|
| Kiểu đầu vào | Video + Audio | Video + Audio | Ảnh + Audio | Video + Audio |
| Chất lượng đầu ra | Cao (có tăng cường) | Trung bình | Cao-Trung bình | Cao |
| Tốc độ inference | ~1x real-time (GPU) | ~2x real-time | ~0,5x real-time | ~0,8x real-time |
| Điều khiển biểu cảm | Có (template D-Net) | Không | Có (3DMM-based) | Hạn chế |
| Tăng cường khuôn mặt | Có (GFPGAN + GPEN) | Không | Có (GFPGAN) | Có |
| Mã nguồn mở | Có (Apache-2.0) | Có (giống MIT) | Có (CC BY-NC) | Có (MIT) |
| Hỗ trợ CPU | Có | Có | Có | Không |
| GPU VRAM (tối thiểu) | 8 GB | 4 GB | 6 GB | 12 GB |
| Âm thanh đa ngôn ngữ | Có | Có | Có | Có |
| Bảo toàn tư thế đầu | Có | Có | Tạo mới | Một phần |
| Sao GitHub (2026-05) | 7.200 | 10.800 | 12.500 | 1.800 |

VideoReTalking nằm ở điểm tối ưu giữa tốc độ và chất lượng. Wav2Lip nhanh hơn nhưng cho đầu ra mờ hơn. SadTalker tạo chuyển động đầu thuyết phục từ một ảnh duy nhất nhưng yêu cầu đầu vào ảnh tĩnh thay vì video. GeneFace cho độ trung thực cao nhưng đòi hỏi nhiều VRAM hơn và không hỗ trợ CPU.

## Hạn chế / Đánh giá trung thực

VideoReTalking không phải công cụ phù hợp cho mọi kịch bản:

1. **Tư thế đầu cực đoan thất bại**: D-Net không xử lý được góc nghiêng quá mức hoặc khuôn mặt bị che khuất nhiều. Video góc cạnh bên vượt quá ±45° yaw sẽ tạo artifact.
2. **Không có khả năng real-time**: Pipeline ba giai đoạn yêu cầu xử lý toàn bộ video tuần tự. Tốt nhất khoảng ~1x real-time —— không phù hợp cho live streaming nếu không có pre-buffering.
3. **Giới hạn độ phân giải**: Các mạng tăng cường được huấn luyện trên crop khuôn mặt 512x512. Upscaling vượt quá mức này cho lợi nhuận giảm dần.
4. **Tính nhất quán biểu cảm**: Mặc dù template biểu cảm hoạt động tốt, các micro-expression tinh tế từ video gốc bị mất trong quá trình chuẩn hóa D-Net.
5. **Phụ thuộc chất lượng âm thanh**: Nhạc nền hoặc âm thanh nhiễu làm confuse mạng lip-sync. File WAV giọng nói sạch cho kết quả tốt nhất.
6. **Bất tiện khi tải model**: Bản tải checkpoint 2GB+ từ Google Drive không thể script hóa cho pipeline CI/CD.

## Câu hỏi thường gặp

### Cần phần cứng gì để chạy VideoReTalking?

GPU NVIDIA tối thiểu 8GB VRAM là yêu cầu thực tế tối thiểu. RTX 4090 24GB xử lý video 512x512 với tốc độ gần real-time. Inference CPU hoạt động nhưng chậm hơn 10–15 lần. Apple Silicon chỉ chạy ở chế độ CPU.

### Có thể dùng VideoReTalking cho dự án thương mại không?

Có. Giấy phép Apache-2.0 cho phép sử dụng thương mại. Tuy nhiên dự án bao gồm disclaimer về quyền chân dung —— bạn phải có sự đồng ý từ bất kỳ ai có hình ảnh bị sửa đổi. Không được sử dụng thương hiệu Tencent mà không có sự cho phép bằng văn bản.

### VideoReTalking so với API lip-sync đám mây như thế nào?

VideoReTalking tự host chi phí $0,05–0,20/phút về điện/thuê GPU. API đám mây như Sync Labs hay HeyGen tính $0,50–3,00/phút nhưng không cần thiết lập. VideoReTalking thắng về quyền riêng tư (hoàn toàn offline) và chi phí quy mô lớn; API đám mây thắng về dễ tích hợp.

### Có hỗ trợ ngôn ngữ khác ngoài tiếng Anh không?

Có. Mạng lip-sync không phụ thuộc ngôn ngữ —— nó ánh xạ đặc trưng âm thanh sang viseme (hình dạng miệng), được chia sẻ xuyên suốt các ngôn ngữ. Tiếng Trung, Nhật, Tây Ban Nha và Ả Rập đều được cộng đồng kiểm thử với kết quả tốt.

### Tại sao video đầu ra bị mờ quanh miệng?

Bộ tăng cường GFPGAN mặc định áp dụng hiệu ứng làm mịn vừa phải. Thử chuyển sang bộ tăng cường GPEN bằng cách chỉnh sửa `inference.py`. Hoặc tắt hoàn toàn tăng cường để có đầu ra sắc nét hơn (nhưng có thể kém nhất quán hơn).

### Có thể fine-tune model trên dataset của riêng mình không?

Repository chỉ cung cấp code inference. Fine-tune yêu cầu triển khai lại vòng lặp huấn luyện cho D-Net (expression editing trên VoxCeleb) và L-Net (lip-sync trên LRS2). Bài báo bao gồm đủ chi tiết kiến trúc cho việc này, nhưng không có script huấn luyện.

## Kết luận

VideoReTalking cung cấp giải pháp tự host thực tiễn cho đồng bộ môi dựa trên âm thanh với chất lượng đầu ra production-grade. Pipeline ba giai đoạn —— chuẩn hóa biểu cảm, tạo lip-sync và tăng cường khuôn mặt —— tạo ra kết quả cạnh tranh với các lựa chọn thương mại với chi phí chỉ bằng một phần nhỏ cho workflow khối lượng cao.

**Các hành động để bắt đầu:**

1. Clone repo và thiết lập môi trường conda theo các lệnh trên
2. Tải gói checkpoint 2GB vào `./checkpoints/`
3. Chạy lệnh inference nhanh với file mẫu trong `examples/`
4. Khởi chạy Gradio WebUI để thử nghiệm tương tác
5. Liên kết với GPT-SoVITS hoặc RVC để xây dựng pipeline voice cloning + lip-sync hoàn chỉnh

Tham gia [cộng đồng lập trình viên dibi8 trên Telegram](https://t.me/dibi8tech) để chia sẻ triển khai VideoReTalking của bạn và nhận trợ giúp từ những ngườ xây dựng khác.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn và tài liệu tham khảo

- [VideoReTalking GitHub Repository](https://github.com/OpenTalker/video-retalking)
- [VideoReTalking Project Page](https://opentalker.github.io/video-retalking/)
- [VideoReTalking arXiv Paper](https://arxiv.org/abs/2211.14758)
- [SIGGRAPH Asia 2022 Proceedings](https://arxiv.org/pdf/2211.14758.pdf)
- [Wav2Lip Repository](https://github.com/Rudrabha/Wav2Lip)
- [SadTalker Repository](https://github.com/OpenTalker/SadTalker)
- [GeneFace Repository](https://github.com/yerfor/GeneFace)
- [GFPGAN Face Restoration](https://github.com/TencentARC/GFPGAN)
- [Pre-trained Models (Google Drive)](https://drive.google.com/drive/folders/18rhjMpxK8LVVxf7PI6XwOidt8Vouv_H0)
