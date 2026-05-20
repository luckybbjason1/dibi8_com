---
title: 'Demucs: Tách Nguồn Nhạc 10K+ Stars — So Sánh với UVR, Spleeter 2026'
description: 'Demucs là mô hình tách nguồn nhạc hybrid spectrogram và waveform từ Meta AI. Tương thích với Ultimate Vocal Remover, RVC, GPT-SoVITS. Hướng dẫn demucs, demucs vs uvr, cài đặt docker demucs, và benchmark production.'
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
github_repo: 'https://github.com/facebookresearch/demucs'
stars: 10100
maintainer: 'facebookresearch'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['demucs', 'tach-nguon-nhac', 'ai-audio', 'tach-stem', 'pytorch', 'docker', 'ma-nguon-mo']
aliases:
- /vi/posts/demucs/
---

{{</* resource-info */>}}

Việc tách một bản phối hoàn chỉnh thành các track nhạc cụ riêng lẻ — vocal, trống, bass, và các nhạc cụ khác — từng đòi hỏi file đa track gốc từ phòng thu. Điều đó đã thay đổi khi các mô hình học sâu học được cách "unmix" audio đã hoàn thiện. Ngày nay, nhạc sĩ, producer và developer sử dụng các công cụ này để tạo track karaoke, tách sample, chuẩn bị remix, và xây dựng pipeline chuyển đổi giọng nói. Trong các lựa chọn mã nguồn mở, một mô hình thống trị cuộc trò chuyện: **Demucs**, kiến trúc hybrid transformer của Meta với hơn 10,000 sao trên GitHub và benchmark hàng đầu trên tập dữ liệu MUSDB18-HQ.

Hướng dẫn này trình bày cách Demucs hoạt động, cách cài đặt cục bộ, cách so sánh với Spleeter và Ultimate Vocal Remover, và cách tích hợp vào quy trình production thực tế.

## Demucs là gì?

**Demucs** (Deep Extractor for Music Sources) là mô hình tách nguồn nhạc mã nguồn mở được phát triển bởi Meta AI Research. Nó nhận đầu vào là một bản phối stereo và xuất ra các "stem" — thường là vocal, trống, bass, và một track "other" chứa guitar, keyboard và các nhạc cụ còn lại.

Dự án nằm trên repository `facebookresearch/demucs` trên GitHub, đã tích lũy hơn 10,100 sao và 1,500 fork. Repository đã bị Meta archive vào ngày 1 tháng 1 năm 2025, nhưng tác giả gốc Alexandre Defossez duy trì một fork hoạt động tại `adefossez/demucs`. Phiên bản ổn định mới nhất là v4.1.0 và toàn bộ dự án sử dụng giấy phép MIT.

Điều làm Demucs khác biệt với các công cụ trước đó là **phương pháp hybrid**: nó xử lý audio đồng thởi trong miền thờ gian (waveform thô) và miền tần số (spectrogram), sau đó kết hợp cả hai biểu diễn. Quá trình xử lý hai miền này bảo toàn thông tin pha mà các phương pháp spectrogram thuần túy mất đi, mang lại kết quả tách sạch hơn với ít artifact kim loại hơn.

## Demucs hoạt động như thế nào

### Tổng quan kiến trúc

Thế hệ Demucs hiện tại — chính thức gọi là **Hybrid Transformer Demucs (HTDemucs)** — xây dựng trên backbone convolutional U-Net với các lớp transformer. Kiến trúc hoạt động theo ba giai đoạn khái niệm:

1. **Encoder**: Waveform đầu vào đi qua cả encoder miền thờ gian (convolution 1D) và encoder miền tần số (STFT theo sau là convolution 2D). Việc mã hóa kép này nắm bắt cả chi tiết thờ gian tinh vi và cấu trúc tần số hài.

2. **Transformer bottleneck**: Các lớp sâu nhất của U-Net sử dụng encoder transformer cross-domain với self-attention trong từng miền và cross-attention giữa các miền. Cơ chế này mô hình các phụ thuộc dài hạn — rất quan trọng để tách, ví dụ, một giai điệu vocal trải dài nhiều ô nhịp khỏi một đường guitar có cao độ tương tự.

3. **Decoder**: Các decoder riêng biệt tái tạo từng nguồn (trống, bass, other, vocal) trong cả hai miền, và một lớp fusion kết hợp các đầu ra thành các waveform đã tách cuối cùng.

![Sơ đồ kiến trúc Demucs](https://raw.githubusercontent.com/facebookresearch/demucs/main/demucs.png)

### Các mô hình có sẵn

Demucs đi kèm với nhiều mô hình pretrained được tối ưu cho các đánh đổi tốc độ/chất lượng khác nhau:

| Mô hình | Số stem | VRAM | SDR (MUSDB) | Trường hợp sử dụng |
|---------|---------|------|-------------|-------------------|
| `htdemucs` | 4 | ~5.2 GB | 7.1 dB | Mặc định, cân bằng tốc độ/chất lượng |
| `htdemucs_ft` | 4 | ~7.8 GB | 7.8 dB | Chất lượng tối đa, chậm hơn ~4 lần |
| `htdemucs_6s` | 6 | ~6.5 GB | 6.8 dB | Tách guitar + piano |
| `mdx_extra_q` | 4 | ~3.0 GB | 6.5 dB | Hệ thống VRAM thấp |

Mô hình `htdemucs_ft` đạt SDR tổng thể 7.8 dB trên MUSDB18-HQ, với chi tiết từng nguồn khoảng 8.5 dB cho vocal, 7.5 dB cho bass, 8.9 dB cho trống, và 6.2 dB cho danh mục "other". Để tham khảo, 0 dB có nghĩa là không có cải thiện tách so với bản phối gốc.

## Cài đặt & Thiết lập

### Yêu cầu tiên quyết

Trước khi cài đặt Demucs, xác minh môi trường:

```bash
# Python 3.8+ bắt buộc
python --version

# Phải cài đặt FFmpeg
ffmpeg -version

# (Tùy chọn) NVIDIA GPU với CUDA 11.8+ để tăng tốc
nvidia-smi
```

### Tùy chọn 1: pip Install (Nhanh nhất)

Cách đơn giản nhất để chạy Demucs:

```bash
# Tạo môi trường ảo
python -m venv demucs-env
source demucs-env/bin/activate  # Linux/macOS
# demucs-env\Scripts\activate   # Windows

# Cài đặt Demucs
pip install -U demucs

# Xác minh cài đặt
demucs --help
```

### Tùy chọn 2: Conda với GPU Support (Khuyến nghị)

Để suy luận tăng tốc GPU và training:

```bash
# Clone repository
git clone https://github.com/adefossez/demucs.git
cd demucs

# Tạo môi trường từ spec chính thức
conda env update -f environment-cuda.yml
conda activate demucs

# Cài đặt ở chế độ development
pip install -e .

# Xác minh GPU được phát hiện
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
```

### Tùy chọn 3: Docker (Cách ly sạch nhất)

Để triển khai có thể tái tạo, không phụ thuộc:

```bash
# Dockerfile
FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

RUN pip install -U demucs

WORKDIR /audio
ENTRYPOINT ["demucs"]
```

Build và chạy:

```bash
docker build -t demucs .
docker run --gpus all -v $(pwd):/audio demucs song.mp3
```

**Docker Compose (cho dịch vụ batch):**

```yaml
version: '3.8'

services:
  demucs:
    build: .
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./input:/audio/input:ro
      - ./output:/audio/output
    command: ["-n", "htdemucs_ft", "--mp3", "-o", "/audio/output", "/audio/input"]
```

### Chạy tách đầu tiên

Sau khi cài đặt, tách track đầu tiên:

```bash
# Tách 4-stem cơ bản với mô hình mặc định
demucs song.mp3

# Output vào ./separated/htdemucs/song/
# Chứa: drums.wav, bass.wav, other.wav, vocals.wav

# Dùng mô hình fine-tuned cho chất lượng tốt hơn
demucs -n htdemucs_ft song.mp3

# Chỉ tách vocal khỏi nhạc nền
demucs --two-stems=vocals song.mp3

# Xuất dạng MP3 (file nhỏ hơn)
demucs --mp3 --mp3-bitrate 320 song.mp3
```

### Xác minh Model Download và Cache

Các model tải xuống tự động khi sử dụng lần đầu. Xác minh cache:

```bash
# Liệt kê model đã tải
ls ~/.cache/torch/hub/checkpoints/

# Output dự kiến:
# htdemucs-*.th, htdemucs_ft-*.th

# Kiểm tra model sẽ được sử dụng
demucs -n htdemucs_ft --help | grep "name"

# Test nhanh với file audio ngắn
ffmpeg -f lavfi -i "sine=frequency=1000:duration=5" test_tone.wav
demucs -n htdemucs test_tone.wav
```

## Tích hợp với các công cụ phổ biến

### Ultimate Vocal Remover (UVR)

Ultimate Vocal Remover là frontend GUI phổ biến nhất cho Demucs. Thay vì sử dụng Demucs trực tiếp qua command line, hầu hết producer sử dụng UVR vì nó bundle các mô hình Demucs với kiến trúc khác và thêm xử lý ensemble.

Cấu hình trong UVR:

1. Tải UVR5 từ [GitHub Releases chính thức](https://github.com/Anjok07/ultimatevocalremovergui/releases)
2. Trong UI, chọn **Process Method: "Demucs"**
3. Chọn mô hình: `V4 | htdemucs_ft`
4. Bật **GPU Conversion** nếu có
5. Để có kết quả tốt nhất, dùng **Ensemble Mode** với `htdemucs_ft` + `MDX-Net`

Chế độ ensemble của UVR chạy song song nhiều mô hình và pha trộn đầu ra, liên tục tạo ra kết quả tách sạch hơn bất kỳ mô hình đơn lẻ nào. Chi phí là thờ gian xử lý — chế độ ensemble chậm hơn khoảng 3–5 lần so với một lần chạy mô hình đơn.

### RVC (Retrieval-based Voice Conversion)

Các pipeline RVC thường sử dụng Demucs như một bước tiền xử lý để tách vocal trước khi trích xuất giọng:

```python
import subprocess
import os

def preprocess_for_rvc(input_song, output_dir):
    """Trích xuất vocal sạch cho chuyển đổi giọng RVC."""
    os.makedirs(output_dir, exist_ok=True)

    # Bước 1: Tách bằng Demucs
    subprocess.run([
        'demucs', '-n', 'htdemucs_ft',
        '--two-stems=vocals',
        '-o', output_dir,
        input_song
    ], check=True)

    # Bước 2: Trả về đường dẫn vocal đã tách
    base = os.path.splitext(os.path.basename(input_song))[0]
    vocals_path = os.path.join(
        output_dir, 'htdemucs_ft', base, 'vocals.wav'
    )
    return vocals_path

# Sử dụng
vocals = preprocess_for_rvc('input.mp3', './separated')
# Đưa vocal vào RVC để chuyển đổi giọng
```

### GPT-SoVITS

Voice cloning GPT-SoVITS yêu cầu audio tham chiếu sạch. Demucs loại bỏ nhạc nền trước khi đưa mẫu vào pipeline TTS:

```python
from demucs.api import Separator
import torchaudio

separator = Separator(model="htdemucs", device="cuda")

# Tách và trích xuất vocal
origin, separated = separator.separate_audio_file("reference.mp3")
vocals = separated["vocals"]

# Lưu ở 24kHz cho GPT-SoVITS
torchaudio.save("clean_reference.wav", vocals, 24000)
```

### Giao diện Web Gradio

Để tự host dịch vụ tách nhạc:

```python
import gradio as gr
from demucs.api import Separator

separator = Separator(model="htdemucs_ft")

def separate(audio_file, stem):
    origin, separated = separator.separate_audio_file(audio_file)
    output_path = f"{stem}.wav"
    separator.save_audio(separated[stem], output_path, samplerate=44100)
    return output_path

demo = gr.Interface(
    fn=separate,
    inputs=[
        gr.Audio(type="filepath", label="Tải lên bài hát"),
        gr.Dropdown(
            choices=["vocals", "drums", "bass", "other"],
            value="vocals",
            label="Stem"
        )
    ],
    outputs=gr.Audio(label="Stem đã tách"),
    title="Demucs Source Separation",
    description="Tách nhạc thành stem bằng mô hình Demucs của Meta"
)

demo.launch(server_name="0.0.0.0", server_port=7860)
```

## Benchmark / Use case thực tế

### Kết quả Benchmark MUSDB18-HQ

MUSDB18-HQ là bộ benchmark chuẩn cho tách nguồn nhạc, chứa 150 bài hát đầy đủ với ground-truth stem. SDR càng cao nghĩa là tách càng sạch.

| Mô hình | SDR Tổng thể | Vocal | Trống | Bass | Other | Tốc độ (RTX 3090) |
|---------|-------------|-------|-------|------|-------|-------------------|
| **HTDemucs FT (v4)** | **7.8 dB** | **8.5 dB** | **8.9 dB** | **7.5 dB** | **6.2 dB** | ~4x real-time |
| HTDemucs (v4) | 7.1 dB | 7.8 dB | 8.2 dB | 6.9 dB | 5.6 dB | ~16x real-time |
| Hybrid Demucs (v3) | 7.7 dB | 8.1 dB | 8.5 dB | 7.2 dB | 5.9 dB | ~12x real-time |
| Spleeter 4stems | 5.9 dB | 6.3 dB | 6.8 dB | 5.4 dB | 4.2 dB | ~100x real-time |
| Open-Unmix | 5.3 dB | 6.2 dB | 5.9 dB | 4.7 dB | 4.2 dB | ~80x real-time |

### Use case Production

**Tạo track karaoke**: Tùy chọn `--two-stems=vocals` tạo ra instrumental bằng cách trộn drums + bass + other, loại bỏ track vocal. Một bài 4 phút xử lý dưới 30 giây trên GPU.

**Tách sample cho producer**: Tách drum break, bassline, hoặc các yếu tố giai điệu từ bản phối hoàn chỉnh. Mô hình `htdemucs_6s` thêm tách guitar và piano, mặc dù chất lượng trên các stem này thấp hơn 4 stem chính.

**Tiền xử lý chuyển đổi giọng**: Việc trích xuất vocal sạch là điều kiện tiên quyết cho các pipeline clone giọng như RVC, GPT-SoVITS. Demucs liên tục tạo ra stem vocal với ít bleed hơn các phương pháp spectrogram-only.

**Phục hồi audio**: Các chuyên gia lưu trữ sử dụng Demucs để tách các bản ghi lịch sử để giảm nhiễu trên từng stem riêng lẻ, sau đó remix.

### Tham chiếu thờ gian xử lý

Cho track stereo 4 phút ở 44.1 kHz:

| Phần cứng | htdemucs | htdemucs_ft | htdemucs_6s |
|-----------|----------|-------------|-------------|
| RTX 4080 GPU | ~15 giây | ~55 giây | ~25 giây |
| RTX 3080 GPU | ~20 giây | ~75 giây | ~35 giây |
| Apple M3 (MPS) | ~45 giây | ~3 phút | ~70 giây |
| Intel i7-13700 CPU | ~5 phút | ~18 phút | ~8 phút |

## Sử dụng nâng cao / Production Hardening

### Python API cho pipeline tùy chỉnh

Để kiểm soát lập trình, bỏ qua CLI và sử dụng Python API trực tiếp:

```python
import torch
import torchaudio
from demucs.pretrained import get_model
from demucs.apply import apply_model

# Tải mô hình
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = get_model("htdemucs_ft")
model.to(device)
model.eval()

# Tải audio
wav, sr = torchaudio.load("input.mp3")

# Đảm bảo stereo
if wav.shape[0] == 1:
    wav = wav.repeat(2, 1)

# Thêm chiều batch
mix = wav.unsqueeze(0).to(device)

# Tách với cài đặt tối ưu
with torch.no_grad():
    sources = apply_model(
        model,
        mix,
        shifts=1,       # Shift trick: cao hơn = tốt hơn, chậm hơn
        split=True,     # Xử lý theo chunk (bắt buộc cho audio dài)
        overlap=0.25,   # Chồng chéo giữa các chunk
        segment=10,     # Độ dài đoạn (giây)
        progress=True,
        device=device
    )[0]

# sources shape: (num_sources, channels, samples)
source_names = model.sources  # ['drums', 'bass', 'other', 'vocals']

# Lưu từng stem riêng lẻ
for i, name in enumerate(source_names):
    torchaudio.save(f"{name}.wav", sources[i].cpu(), sr)
```

### Pipeline xử lý hàng loạt

```python
from pathlib import Path
import subprocess
import json

def batch_separate(input_dir, output_dir, model="htdemucs"):
    """Xử lý tất cả file audio trong thư mục."""
    input_dir = Path(input_dir)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    audio_exts = {'.mp3', '.wav', '.flac', '.ogg', '.m4a'}
    files = [f for f in input_dir.iterdir() if f.suffix in audio_exts]

    # Xử lý tất cả file trong một lần gọi Demucs
    subprocess.run([
        'demucs', '-n', model,
        '-o', str(output_dir),
        '--mp3',
        '--mp3-bitrate', '320',
        *[str(f) for f in files]
    ], check=True)

    # Tạo manifest metadata
    manifest = {}
    for f in files:
        base = f.stem
        stem_dir = output_dir / model / base
        manifest[base] = {
            'drums': str(stem_dir / 'drums.mp3'),
            'bass': str(stem_dir / 'bass.mp3'),
            'other': str(stem_dir / 'other.mp3'),
            'vocals': str(stem_dir / 'vocals.mp3'),
        }

    with open(output_dir / 'manifest.json', 'w') as fp:
        json.dump(manifest, fp, indent=2)

    return manifest

# Sử dụng
batch_separate('./raw_songs/', './stems/', model='htdemucs_ft')
```

### Tối ưu bộ nhớ cho file dài

Demucs tải toàn bộ file audio vào bộ nhớ GPU. Cho track dài hoặc VRAM hạn chế:

```python
# Ép offload CPU cho file lớn
import os
os.environ['PYTORCH_CUDA_ALLOC_CONF'] = 'max_split_size_mb:128'

# Dùng segment nhỏ hơn
sources = apply_model(
    model,
    mix,
    split=True,
    segment=7,      # Giảm từ mặc định ~10s xuống 7s
    overlap=0.1,    # Giảm overlap
    device=device
)[0]
```

### Giám sát và Ghi log

```python
import logging
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('demucs')

def separate_with_metrics(input_path, output_dir):
    start = time.time()

    separator = Separator(model="htdemucs_ft", device="cuda")
    origin, separated = separator.separate_audio_file(input_path)

    duration = time.time() - start
    logger.info(f"Đã tách {input_path} trong {duration:.1f} giây")

    # Log mức từng stem
    for name, audio in separated.items():
        rms = torch.sqrt(torch.mean(audio ** 2)).item()
        logger.info(f"  {name}: RMS={rms:.4f}")

    return separated
```

## So sánh với các lựa chọn thay thế

| Tính năng | Demucs (v4) | Ultimate Vocal Remover | Spleeter | Open-Unmix |
|-----------|-------------|------------------------|----------|------------|
| **Kiến trúc** | Hybrid waveform + spectrogram + Transformer | GUI wrapper (đa backend) | Spectrogram U-Net | Spectrogram LSTM |
| **MUSDB SDR** | 7.8 dB (htdemucs_ft) | N/A (dùng Demucs/MDX) | 5.9 dB | 5.3 dB |
| **Số stem tối đa** | 6 (vocal, trống, bass, guitar, piano, other) | 4 (tùy model) | 5 (có sides) | 4 |
| **Cần GPU** | Khuyến nghị | Khuyến nghị | Tùy chọn | Tùy chọn |
| **Tốc độ xử lý** | ~4–16x real-time (GPU) | ~3–10x real-time (ensemble) | ~100x real-time | ~80x real-time |
| **VRAM sử dụng** | 5–8 GB | 6–12 GB (ensemble) | <2 GB | <2 GB |
| **Phát triển** | Community fork | Đang hoạt động | Archived (2021) | Maintenance mode |
| **Giấy phép** | MIT | MIT | MIT | MIT |
| **Phù hợp nhất** | Tách ưu tiên chất lượng | Dễ dùng GUI + ensemble | Xử lý batch nhanh | Triển khai nhẹ |

**Khi nào chọn gì**: Sử dụng Demucs trực tiếp khi cần chất lượng tách tối đa và xây dựng pipeline tự động. Dùng UVR khi muốn GUI, xử lý ensemble, và không ngại overhead thiết lập. Chỉ dùng Spleeter khi cần tốc độ tối đa trên phần cứng hạn chế hoặc đang duy trì code cũ. Open-Unmix vẫn phù hợp cho mục đích giáo dục và triển khai edge có tài nguyên hạn chế.

## Hạn chế / Đánh giá trung thực

Demucs không phải công cụ phù hợp cho mọi tác vụ audio. Đây là những gì nó không làm tốt:

**Tách real-time**: Ngay cả mô hình Demucs nhanh nhất (`htdemucs`) cũng chỉ xử lý ở tốc độ khoảng 16x real-time trên RTX 4080. Điều này quá chậm cho biểu diễn trực tiếp hoặc ứng dụng streaming real-time. Các công cụ như Spleeter hoặc bản export ONNX chuyên dụng phù hợp hơn cho các use case nhạy cảm với độ trễ.

**Tách guitar và piano**: Mô hình `htdemucs_6s` cố gắng tách guitar và piano thành các stem riêng biệt, nhưng SDR trên các nguồn này thấp hơn đáng kể so với 4 stem chính. Nếu nhu cầu chính là tách track guitar cụ thể, các công cụ chuyển phổ chuyên dụng như Basic Pitch có thể phù hợp hơn.

**Master được nén mạnh**: Các track được maximize loudness với limiting nặng (phổ biến trong EDM và pop hiện đại) tạo ra frequency masking làm các mô hình tách nhầm lẫn. Demucs có thể tạo ra artifact — âm xoáy, bleed chéo nguồn — trên các track này mà không xuất hiện trên các bản phối dynamic hơn.

**Kích thước mô hình**: Ở ~2 GB cho `htdemucs_ft`, các mô hình Demucs lớn hơn một bậc so với Spleeter (~150 MB). Điều này quan trọng đối với triển khai edge, ứng dụng di động, và môi trường serverless với ràng buộc cold-start.

**Upstream đã archived**: Repository gốc `facebookresearch/demucs` đã được archived và không còn được duy trì. Mặc dù `adefossez/demucs` đang hoạt động, quỹ đạo duy trì dài hạn chưa rõ ràng. Cân nhắc yếu tố này trong kế hoạch dependency của bạn.

## Câu hỏi thường gặp

**Q: Cần phần cứng gì để chạy Demucs?**
A: Demucs chạy trên CPU, nhưng GPU NVIDIA với 6+ GB VRAM được khuyến nghị mạnh mẽ. Mô hình `htdemucs` cần 5.2 GB VRAM. Mô hình `htdemucs_ft` cần 8 GB. Xử lý CPU-only hoạt động được nhưng thờ gian xử lý một bài 4 phút là 5–20 phút so với dưới một phút trên GPU.

**Q: Có thể dùng Demucs thương mại không?**
A: Có. Demucs được cấp phép MIT, cho phép sử dụng thương mại, sửa đổi, và phân phối không hạn chế. Các stem đã tách có thể được sử dụng trong sản xuất thương mại. Lưu ý rằng giấy phép MIT áp dụng cho code và mô hình, không áp dụng cho bản quyền của nhạc bạn xử lý.

**Q: Tại sao Demucs nghe hay hơn Spleeter?**
A: Demucs xử lý audio đồng thởi trong cả miền thờ gian và miền tần số, bảo toàn thông tin pha mà các phương pháp spectrogram thuần túy loại bỏ. Các lớp transformer cũng mô hình các phụ thuộc âm nhạc dài hạn tốt hơn U-Net của Spleeter. Điều này dẫn đến ít artifact hơn và ít nhiễu chéo nguồn hơn.

**Q: Làm sao xử lý cả album hiệu quả?**
A: Truyền nhiều file trong một lần gọi Demucs: `demucs -n htdemucs *.mp3`. Demucs xử lý tuần tự nhưng tránh overhead tải mô hình lặp lại. Để đạt thông lượng tối đa, chạy nhiều instance Demucs trên các GPU khác nhau hoặc dùng script xử lý batch trong phần Sử dụng nâng cao.

**Q: Demucs hỗ trợ định dạng audio nào?**
A: Demucs sử dụng FFmpeg để giải mã và torchaudio để mã hóa. Đầu vào: MP3, WAV, FLAC, OGG, M4A, và mọi định dạng FFmpeg hỗ trợ. Đầu ra: WAV (mặc định, 16-bit), float32 WAV (`--float32`), 24-bit WAV (`--int24`), hoặc MP3 (`--mp3` với bitrate điều chỉnh được).

**Q: Có thể fine-tune Demucs trên dữ liệu riêng không?**
A: Có, nhưng cần pipeline training đầy đủ. Bạn cần các stem tách rồi cho bài hát training (cùng định dạng MUSDB18-HQ), sau đó dùng trình quản lý thử nghiệm Dora với `dora run -d solver=htdemucs dset=your_dataset`. Hầu hết ngườ dùng không cần điều này — các mô hình pretrained khái quát hóa tốt qua nhiều thể loại.

**Q: Sự khác biệt giữa `htdemucs` và `htdemucs_ft` là gì?**
A: `htdemucs_ft` được fine-tune theo từng nguồn với dữ liệu training bổ sung và shift trick được bật mặc định. Nó đạt ~0.7 dB SDR cao hơn trên tất cả nguồn nhưng chạy chậm hơn ~4 lần và sử dụng nhiều VRAM hơn 50%. Dùng `htdemucs` cho lặp nhanh và `htdemucs_ft` cho output production cuối cùng.

## Kết luận

Demucs vẫn là triển khai tham chiếu cho tách nguồn nhạc mã nguồn mở trong năm 2026. Kiến trúc hybrid transformer mang lại chất lượng tách vượt trội Spleeter từ 20–40% trên các benchmark chuẩn, và tích hợp sạch sẽ với các pipeline chuyển đổi giọng nói, trình tạo karaoke, và công cụ sản xuất audio.

Đối với developer xây dựng pipeline audio, Demucs cung cấp Python API có tài liệu tốt, hỗ trợ Docker, và nhiều biến thể mô hình cho các đánh đổi tốc độ/chất lượng khác nhau. Giấy phép MIT loại bỏ ma sát thương mại. Các cảnh báo chính là yêu cầu phần cứng (GPU được khuyến nghị mạnh mẽ), kích thước mô hình (~2 GB), và trạng thái archived của repository upstream.

**Hành động**: Cài đặt Demucs bằng `pip install -U demucs`, chạy lần tách đầu tiên trên track thử nghiệm bằng `demucs -n htdemucs_ft song.mp3`, và tích hợp vào pipeline bằng các ví dụ Python API ở trên. Để có trải nghiệm GUI, tải Ultimate Vocal Remover và dùng chế độ ensemble.

**Tham gia nhóm Telegram dibi8.com để nhận phân tích chuyên sâu hàng tuần về công cụ AI mã nguồn mở: [https://t.me/dibi8channel](https://t.me/dibi8channel)**



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [Demucs GitHub Repository (Meta, archived)](https://github.com/facebookresearch/demucs)
- [Demucs Fork đang hoạt động (adefossez)](https://github.com/adefossez/demucs)
- [Hybrid Transformers for Music Source Separation (bài báo)](https://arxiv.org/abs/2211.08553)
- [MUSDB18-HQ Benchmark Dataset](https://zenodo.org/record/3338373)
- [Ultimate Vocal Remover GUI](https://github.com/Anjok07/ultimatevocalremovergui)
- [Spleeter (Deezer, archived)](https://github.com/deezer/spleeter)
- [Open-Unmix (Sony)](https://github.com/sigsep/open-unmix-pytorch)
- [MVSEP Quality Checker Leaderboard](https://mvsep.com/quality_checker/)
- [Audio Developers Conference 2025 — Bài thuyết trình ONNX Export Demucs](https://mixxx.discourse.group/t/gsoc-2025-converting-demucs-v4-hybrid-transformer-ai-model-to-onnx-format/32874)
