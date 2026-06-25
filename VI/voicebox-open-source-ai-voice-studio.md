---
title: 'VoiceBox: Studio Giọng Nói AI Mã Nguồn Mở Để Nhân Bản, Chép Và Tạo Giọng'
description: 'Một studio giọng nói AI mã nguồn mở toàndiện cho phép bạn nhân bản mọi giọng, tạo giọng nói và chép vào bất kỳ ứng dụng nào. 33K sao. Chạy cục bộ trên máy của bạn với hỗ trợ CUDA hoặc Apple Silicon.'
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: ai-tools
tags: ['ai', 'giọng-ai', 'nhân-bản-giọng', 'chuyển-âm-thành-chữ', 'chuyển-chữ-thành-âm', 'whisper', 'qwen3-tts', 'cuda', 'mlx']
slug: voicebox-open-source-ai-voice-studio
featureImage: /images/articles/voicebox-open-source-ai-voice-studio-for-cloning-dictation-and-generation.png
lang: vi
github_repo: https://github.com/voicebox-ai/voicebox
license: MIT
---



# VoiceBox: Studio Giọng Nói AI Mã Nguồn Mở

**VoiceBox** là một studio giọng nói AI mã nguồn mở toàn diện, cho phép nhân bản giọng nói, tạo giọng nói và chép văn bản — tất cả chạy cục bộ trên máy của bạn. Với **33.745 sao GitHub** và cộng đồng phát triển sôi động, nó đã trở thành giải pháp được ưa chuộng cho nhà phát triển, người sáng tạo nội dung và người dùng chú trọng quyền riêng tư cần AI giọng nói mạnh mẽ mà không dựa vào API đám mây.

Bài viết này bao gồm hướng dẫn cài đặt, nhân bản giọng, chế độ chép, sử dụng API, yêu cầu phần cứng và ứng dụng thực tế.

## TL;DR

VoiceBox cung cấp một stack AI giọng nói hoàn chỉnh chạy hoàn toàn trên phần cứng của bạn. Nó hỗ trợ nhân bản giọng từ chỉ 3 giây âm thanh, chép văn bản thời gian thực vào bất kỳ ứng dụng nào, và tạo giọng nói chất lượng cao từ văn bản. Với hỗ trợ cả NVIDIA CUDA và Apple Silicon (MLX), nó thích nghi với phần cứng của bạn trong khi vẫn đảm bảo quyền riêng tư — dữ liệu giọng nói của bạn không bao giờ rời khỏi máy.

## VoiceBox Là Gì?

VoiceBox là một nền tảng AI giọng nói tự lưu trữ, kết hợp nhiều công nghệ tiên tiến vào một giao diện thống nhất. Khác với các dịch vụ giọng nói thương mại yêu cầu tải âm thanh lên đám mây, VoiceBox xử lý mọi thứ cục bộ, cho bạn kiểm soát hoàn toàn dữ liệu giọng nói của mình.

Nền tảng hỗ trợ ba chế độ hoạt động chính:

- **Nhân bản giọng**: Ghi lại hoặc tải lên một mẫu âm thanh ngắn và tạo mô hình giọng nói kỹ thuật số có thể tạo giọng nói bằng giọng đó
- **Chép văn bản**: Sử dụng microphone của bạn để chép văn bản vào bất kỳ ứng dụng nào trên hệ thống, với phiên âm thời gian thực
- **Chuyển văn bản thành giọng (TTS)**: Tạo giọng nói tự nhiên từ văn bản bằng giọng đã nhân bản hoặc mô hình giọng tích hợp

Được xây dựng dựa trên các mô hình mã nguồn mở hiện đại bao gồm Qwen3-TTS, Whisper và nhiều kiến trúc nhân bản giọng khác, VoiceBox cung cấp khả năng AI giọng nói cấp doanh nghiệp với chi phí bằng không.

## Hướng Dẫn Cài Đặt

### Yêu Cầu Tiên Quyết

VoiceBox hỗ trợ nhiều cấu hình phần cứng:

**Tăng tốc GPU (Khuyến Nghị):**
- GPU NVIDIA với 8GB+ VRAM (RTX 3060 hoặc tốt hơn)
- Đã cài đặt bộ công cụ CUDA 12.x
- 16GB RAM hệ thống
- Linux (Ubuntu 22.04+) hoặc Windows 11

**Apple Silicon:**
- Chip M1/M2/M3 với 16GB+ bộ nhớ thống nhất
- macOS 14+ (Sonoma hoặc mới hơn)
- Đã cài đặt framework MLX

**Chỉ CPU (Chậm hơn nhưng hoạt động):**
- 16GB+ RAM hệ thống
- 8+ nhân CPU
- Bất kỳ hệ điều hành hiện đại nào

### Tùy Chọn 1: Cài Đặt Nhanh Với Pip

```bash
# Cài đặt VoiceBox từ PyPI
pip install voicebox-ai

# Xác minh cài đặt
voicebox --version

# Khởi tạo ứng dụng
voicebox init --model qwen3-tts
```

### Tùy Chọn 2: Từ Mã Nguồn (Tính Năng Mới Nhất)

```bash
# Sao chép kho lưu trữ
git clone https://github.com/jamiepine/voicebox.git
cd voicebox

# Tạo môi trường ảo
python -m venv .venv
source .venv/bin/activate

# Cài đặt phụ thuộc
pip install -r requirements.txt

# Cài đặt gói ở chế độ phát triển
pip install -e .

# Tải xuống mô hình giọng nói mặc định
voicebox download-models --all
```

### Tùy Chọn 3: Triển Khai Docker

```bash
# Kéo hình ảnh chính thức
docker pull jamiepine/voicebox:latest

# Chạy với hỗ trợ GPU (NVIDIA)
docker run -d \
  --name voicebox \
  --gpus all \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest

# Chạy trên Apple Silicon (không cần cờ GPU)
docker run -d \
  --name voicebox \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest
```

### Tùy Chọn 4: Cài Đặt Windows

```powershell
# Cài đặt Python 3.11+ từ Microsoft Store
# Sau đó cài đặt VoiceBox
pip install voicebox-ai

# Để tăng tốc GPU, cài đặt bộ công cụ CUDA
# Tải xuống tại: https://developer.nvidia.com/cuda-downloads

# Khởi tạo VoiceBox
voicebox init --gpu cuda
```

## Nhân Bản Giọng Nói

### Ghi Mẫu Âm Thanh

Để nhân bản giọng, bạn cần ít nhất 3 giây âm thanh rõ ràng. Để có kết quả tốt nhất, hãy cung cấp 30-60 giây giọng nói:

```bash
# Ghi âm thanh bằng trình ghi âm tích hợp
voicebox record --output sample.wav --duration 30

# Hoặc tải lên tệp âm thanh hiện có
voicebox clone --audio my_voice_sample.mp3 --name "my-voice"

# VoiceBox tự động xử lý âm thanh và trích xuất đặc điểm giọng
```

### Pipeline Xử Lý Giọng Nói

Pipeline nhân bản giọng bao gồm nhiều giai đoạn:

```python
from voicebox.engine import VoiceCloner
from voicebox.audio import AudioProcessor

# Khởi tạo bộ nhân bản
cloner = VoiceCloner(model="qwen3-tts-voice-clone")

# Tải và tiền xử lý âm thanh tham chiếu
processor = AudioProcessor()
reference = processor.load_audio("sample.wav")
reference = processor.normalize(reference, target_rms=-20)
reference = processor.remove_noise(reference, method="spectral")

# Trích xuất embedding giọng
embeddings = cloner.extract_embeddings(reference)

# Tạo mô hình giọng
voice_model = cloner.create_voice(
    embeddings=embeddings,
    name="my-voice",
    quality="high"
)

# Kiểm tra giọng đã nhân bản
output = voice_model.synthesize(
    text="Xin chào, đây là giọng nói đã nhân bản của tôi.",
    speed=1.0,
    emotion="neutral"
)
voice_model.save(output, "test_output.wav")
```

### Tham Số Giọng Nói Nâng Cao

VoiceBox cung cấp kiểm soát chi tiết عن tổng hợp giọng nói:

```bash
# Kiểm soát tốc độ nói
voicebox synthesize --input script.txt --output speech.wav --speed 0.8

# Thêm sắc thái cảm xúc
voicebox synthesize --input script.txt --output emotional.wav --emotion happy

# Điều chỉnh pitch
voicebox synthesize --input script.txt --output pitched.wav --pitch +200

# Kết hợp nhiều tham số
voicebox synthesize \
  --input script.txt \
  --output natural.wav \
  --speed 1.1 \
  --pitch +100 \
  --emotion confident \
  --clarity high
```

### Hỗ Trợ Đa Giọng

Bạn có thể tạo và quản lý nhiều bản nhân bản giọng đồng thời:

```python
from voicebox.engine import VoiceManager

manager = VoiceManager()

# Liệt kê tất cả giọng đã nhân bản
voices = manager.list_voices()
for v in voices:
    print(f"{v.name}: {v.quality} ({v.duration}s dữ liệu huấn luyện)")

# Chuyển đổi giữa các giọng
manager.set_active_voice("my-voice")
output = manager.synthesize("Xin chào từ giọng nhân bản của tôi!")

# Trộn hai giọng để tạo giọng lai
hybrid = manager.blend_voices(
    voice_a="my-voice",
    voice_b="partner-voice",
    weight_a=0.7,
    weight_b=0.3
)
output = hybrid.synthesize("Đầu ra giọng trộn")
```

## Chế Độ Chép Văn Bản

Chế độ chép của VoiceBox cung cấp phiên âm giọng-nói-thành-chữ thời gian thực hoạt động với mọi ứng dụng trên hệ thống của bạn.

### Thiết Lập Chép Toàn Hệ Thống

```bash
# Kích hoạt chép toàn hệ thống
voicebox dictation --enable

# Chọn mô hình nhận diện
voicebox dictation --model whisper-large-v3

# Đặt ngôn ngữ đầu ra
voicebox dictation --language en

# Cấu hình phím nóng
voicebox dictation --hotkey "ctrl+space"
```

### Sử Dụng API Chép

```python
from voicebox.dictation import DictationEngine

# Khởi tạo engine chép
engine = DictationEngine(
    model="whisper-large-v3",
    language="auto",
    beam_size=5,
    vad_threshold=0.5
)

# Bắt đầu nghe
engine.start_listening(
    hotkey="ctrl+shift+d",
    output_mode="clipboard",
    append_mode=True
)

# Xử lý phiên chép
result = await engine.listen_session(
    timeout=300,           # Phiên 5 phút
    silence_threshold=1.5, # Dừng sau 1.5s im lặng
    language="en"
)

print(f"Đã phiên âm: {result.text}")
print(f"Độ tin cậy: {result.confidence:.2%}")
print(f"Số từ: {result.word_count}")
```

### Chép Đa Ngôn Ngữ

VoiceBox hỗ trợ chép đa ngôn ngữ đồng thời với phát hiện ngôn ngữ tự động:

```bash
# Kích hoạt phát hiện tự động
voicebox dictation --auto-detect

# Chỉ định ngôn ngữ hỗ trợ
voicebox dictation --languages en,zh,ko,ja,es,fr,de

# Đặt ngôn ngữ chính (để chính xác hơn)
voicebox dictation --primary-language en
```

## API Chuyển Văn Bản Thành Giọng

VoiceBox cung cấp REST API đầy đủ cho việc tạo chuyển văn bản thành giọng programmatically:

### TTS Cơ Bản

```bash
# Chuyển đổi văn bản thành giọng đơn giản
curl -X POST "https://your-voicebox/api/v1/tts" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Xin chào, đây là thử nghiệm chuyển văn bản thành giọng của VoiceBox.",
    "voice": "default",
    "speed": 1.0,
    "output_format": "wav"
  }' \
  --output speech.wav
```

### TTS Trực Tiếp

Dành cho ứng dụng phát âm thanh thời gian thực:

```bash
# Phát âm thanh theo chunk
curl -N -X POST "https://your-voicebox/api/v1/tts/stream" \
  -H "Content-Type: application/json" \
  -d '{"text": "Âm thanh này sẽ được phát trực tiếp...", "voice": "cloned-voice"}' \
  --output - | aplay
```

### Xử Lý Hàng Loạt

Xử lý nhiều văn bản đồng thời:

```python
from voicebox.api import VoiceBoxClient

client = VoiceBoxClient("https://your-voicebox")

texts = [
    "Câu đầu tiên để xử lý.",
    "Câu thứ hai với nội dung khác.",
    "Câu thứ ba bằng giọng khác.",
]

results = await client.tts.batch(
    texts=texts,
    voice="default",
    output_format="mp3",
    parallel_workers=4
)

for i, result in enumerate(results):
    print(f"Đã tạo: speech_{i}.mp3 ({result.duration:.1f}s)")
```

## Yêu Cầu Phần Cứng Và Hiệu Suất

### Benchmark Hiệu Suất GPU

| Phần Cứng | Mô Hình | Thời Gian Nhân Bản | Tốc Độ TTS | Độ Trễ Chép |
|
Tham gia cộng đồng: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

Liên kết nội bộ: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/vi/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/vi/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**Tiết lộ**: Bài viết này đề cập đến các công cụ có thể có quan hệ liên kết. Chúng tôi không chấp nhận thanh toán cho đánh giá. Tất cả ý kiến đều là của riêng chúng tôi.
