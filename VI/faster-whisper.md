---
title: 'faster-whisper: Chuyển Giọng Nói Thành Văn Bản Nhanh Gấp 4x với 23K+ Stars — Benchmark vs WhisperX, whisper.cpp 2026'
description: 'faster-whisper (SYSTRAN) tái triển khai OpenAI Whisper qua CTranslate2 để đạt tốc độ nhanh gấp 4x. Hướng dẫn cài đặt faster whisper, benchmark, thiết lập Docker, API Python, bộ lọc VAD, xử lý hàng loạt, và tích hợp production với WhisperX và whisper.cpp.'
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
github_repo: 'https://github.com/SYSTRAN/faster-whisper'
stars: 23000
maintainer: 'SYSTRAN'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['faster-whisper', 'chuyen-giong-noi-thanh-van-ban', 'CTranslate2', 'OpenAI-Whisper', 'nhan-dang-giong-noi', 'Python', 'Docker', 'ASR']
aliases:
- /vi/posts/faster-whisper/
---

{{</* resource-info */>}}

OpenAI Whisper đã thay đổi lĩnh vực chuyển giọng nói thành văn bản (speech-to-text) vào năm 2022, nhưng bản triển khai Python gốc không tận dụng được hiệu năng phần cứng. Với file audio 13 phút, `openai/whisper` cùng mô hình large-v2 cần hơn 4 phút trên GPU Tesla V100 — không thể chấp nhận được cho các pipeline production xử lý hàng trăm giờ mỗi ngày. **faster-whisper** của SYSTRAN tái triển khai Whisper inference bằng CTranslate2, đạt tốc độ nhanh gấp 4x với độ chính xác tương đương trong khi giảm VRAM gần 70%. Với hơn 23,000 stars trên GitHub, nó đã trở thành runtime mặc định cho speech-to-text production trong môi trường Python.

Hướng dẫn này cung cấp faster whisper tutorial cấp production, bao gồm cài đặt, benchmark, triển khai Docker, và tích hợp với WhisperX và whisper.cpp. Mọi lệnh và cấu hình đều sẵn sàng để copy-paste.

![faster-whisper GitHub repo](https://opengraph.githubassets.com/1/SYSTRAN/faster-whisper)

*Hình 1: Kho GitHub faster-whisper — 23,000+ stars, được SYSTRAN duy trì tích cực.*

## faster-whisper là gì?

faster-whisper là bản tái triển khai mô hình nhận dạng giọng nói tự động (ASR) Whisper của OpenAI sử dụng CTranslate2, một engine inference C++ hiệu năng cao cho mô hình Transformer. Nó chạy cùng trọng số mô hình như Whisper gốc nhưng đạt thông lượng cao hơn đáng kể và sử dụng bộ nhớ thấp hơn thông qua CUDA kernel tùy chỉnh, lượng tử hóa INT8/FP16, và attention tích hợp (fused).

Dự án được Guillaume Klein khởi xướng và hiện do SYSTRAN duy trì theo giấy phép MIT. Hỗ trợ mọi kích thước mô hình Whisper (từ tiny đến large-v3) trên cả CPU và GPU NVIDIA, với chuyển đổi mô hình tự động từ Hugging Face Hub khi lần đầu tải.

## faster-whisper hoạt động như thế nào?

Kiến trúc thay thế inference PyTorch bằng runtime tối ưu hóa của CTranslate2:

![Kiến trúc CTranslate2](https://opennmt.net/CTranslate2/_static/favicon.png)

*Hình 2: Engine inference CTranslate2 — backend C++ cung cấp tốc độ faster-whisper thông qua CUDA kernel tùy chỉnh và lượng tử hóa.*

Các quyết định kỹ thuật chính tạo nên tốc độ:

- **Lượng tử hóa trọng số**: INT8 giảm bộ nhớ mô hình ~50% với tổn thất độ chính xác không đáng kể (< 0.1% WER).
- **Fused kernels**: CTranslate2 hợp nhất nhiều phép toán GPU thành lần gọi kernel duy nhất, giảm overhead dispatch.
- **Hỗ trợ Flash Attention**: Có trên GPU Ampere (RTX 30xx+) để tiết kiệm băng thông bộ nhớ.
- **Inference theo batch**: Xử lý song song nhiềi chunk audio trên GPU để mở rộng thông lượng gần như tuyến tính.
- **Tích hợp Silero VAD**: Voice Activity Detection tích hợp bỏ qua đoạn im lặng, giảm tính toán lãng phí.

## Cài đặt & Thiết lập

### Yêu cầu

- Python 3.9+
- GPU: NVIDIA GPU hỗ trợ CUDA 12.x và cuDNN 9.x
- Không cần cài FFmpeg (đã tích hợp qua PyAV)

### Cài đặt pip (CPU)

```bash
# Tạo môi trường ảo
python -m venv venv-whisper
source venv-whisper/bin/activate  # Linux/Mac
# venv-whisper\Scripts\activate  # Windows

# Cài đặt faster-whisper
pip install faster-whisper
```

### Cài đặt pip với hỗ trợ GPU

```bash
# Cài cuBLAS và cuDNN qua pip (chỉ Linux)
pip install nvidia-cublas-cu12 nvidia-cudnn-cu12==9.*

# Thiết lập đường dẫn thư viện
export LD_LIBRARY_PATH=$(python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))')

# Cài đặt faster-whisper
pip install faster-whisper
```

### Thiết lập Docker

```bash
# Pull image NVIDIA CUDA chính thức
docker run -it --rm --gpus all \
  -v $(pwd)/audio:/audio \
  nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04 \
  bash

# Bên trong container
apt-get update && apt-get install -y python3-pip
pip install faster-whisper
```

### Xác minh cài đặt

```python
# verify_setup.py
from faster_whisper import WhisperModel
import torch

print(f"PyTorch CUDA khả dụng: {torch.cuda.is_available()}")
print(f"Số thiết bị CUDA: {torch.cuda.device_count()}")

model = WhisperModel("tiny", device="cuda", compute_type="float16")
print(f"Mô hình tải trên: {model.model.device}")
print("Xác minh cài đặt thành công")
```

### Phiên âm đầu tiên

```python
from faster_whisper import WhisperModel

# Tải mô hình (tự động tải từ Hugging Face lần đầu)
model = WhisperModel("large-v3", device="cuda", compute_type="int8")

# Phiên âm file audio
segments, info = model.transcribe("audio.mp3", beam_size=5)

print(f"Ngôn ngữ phát hiện: {info.language} "
      f"(xác suất: {info.language_probability:.2f})")

for segment in segments:
    print(f"[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}")
```

## Tích hợp với các công cụ phổ biến

### WhisperX (Phân tách ngưới nói)

WhisperX xây dựng trên faster-whisper để thêm timestamp cấp từ và phân tách ngưới nói. Công cụ đầu tiên cho phiên âm cuộc họp.

```bash
pip install whisperx
```

```python
import whisperx
import torch

device = "cuda" if torch.cuda.is_available() else "cpu"
audio_file = "meeting.mp3"

# 1. Phiên âm bằng backend faster-whisper
model = whisperx.load_model("large-v3", device, compute_type="int8")
audio = whisperx.load_audio(audio_file)
result = model.transcribe(audio, batch_size=8)

# 2. Căn chỉnh timestamp cấp từ
model_a, metadata = whisperx.load_align_model(
    language_code=result["language"], device=device
)
result = whisperx.align(result["segments"], model_a, metadata, audio, device)

# 3. Phân tách ngưới nói (cần token Hugging Face)
diarize_model = whisperx.DiarizationPipeline(
    use_auth_token="your_hf_token", device=device
)
diarize_segments = diarize_model(audio)
result = whisperx.assign_word_speakers(diarize_segments, result)

for segment in result["segments"]:
    speaker = segment.get("speaker", "UNKNOWN")
    print(f"[{segment['start']:.2f}s -> {segment['end']:.2f}s] "
          f"{speaker}: {segment['text']}")
```

### whisper-asr-webservice (API tương thích OpenAI)

```bash
docker run -d --gpus all \
  -p 9000:9000 \
  -e ASR_MODEL=large-v3 \
  -e ASR_ENGINE=faster_whisper \
  -e COMPUTE_TYPE=int8 \
  onerahming/openai-whisper-asr
```

```python
import requests

with open("audio.mp3", "rb") as f:
    response = requests.post(
        "http://localhost:9000/asr",
        files={"audio_file": f},
        data={"language": "en", "output": "json"}
    )
print(response.json())
```

### Speaches (Máy chủ tự host tương thích OpenAI)

```bash
docker run -d --gpus all \
  -p 8000:8000 \
  -e WHISPER__MODEL=large-v3 \
  -e WHISPER__COMPUTE_TYPE=int8 \
  fedirz/speaches:latest-gpu
```

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:8000/v1", api_key="dummy")

with open("audio.mp3", "rb") as f:
    transcript = client.audio.transcriptions.create(model="large-v3", file=f)
print(transcript.text)
```

### LibreTranslate (Pipeline dịch thuật)

```python
from faster_whisper import WhisperModel
import requests

model = WhisperModel("large-v3", device="cuda", compute_type="int8")
segments, info = model.transcribe("japanese_audio.mp3", beam_size=5)
japanese_text = " ".join([s.text for s in segments])

response = requests.post("http://localhost:5000/translate", json={
    "q": japanese_text, "source": "ja", "target": "en"
})
print(response.json()["translatedText"])
```

## Benchmark / Use case thực tế

![Biểu đồ so sánh benchmark](https://raw.githubusercontent.com/SYSTRAN/faster-whisper/master/benchmark/results.png)

*Hình 3: Kết quả benchmark chính thức — faster-whisper đạt tốc độ nhanh gấp 8.9x so với openai/whisper với batch INT8 inference trên RTX 3070 Ti.*

### Benchmark GPU: Audio 13 phút, mô hình large-v2

| Triển khai | Độ chính xác | Beam Size | Thờ gian | VRAM |
|---|---|---|---|---|
| openai/whisper | fp16 | 5 | 2p 23s | 4708 MB |
| whisper.cpp (Flash Attention) | fp16 | 5 | 1p 05s | 4127 MB |
| transformers (SDPA) | fp16 | 5 | 1p 52s | 4960 MB |
| **faster-whisper** | **fp16** | **5** | **1p 03s** | **4525 MB** |
| **faster-whisper (batch_size=8)** | **fp16** | **5** | **17s** | **6090 MB** |
| **faster-whisper** | **int8** | **5** | **59s** | **2926 MB** |
| **faster-whisper (batch_size=8)** | **int8** | **5** | **16s** | **4500 MB** |

*Chạy trên NVIDIA RTX 3070 Ti 8GB, CUDA 12.4.*

### Benchmark CPU: Audio 13 phút, mô hình small

| Triển khai | Độ chính xác | Beam Size | Thờ gian | RAM |
|---|---|---|---|---|
| openai/whisper | fp32 | 5 | 6p 58s | 2335 MB |
| whisper.cpp | fp32 | 5 | 2p 05s | 1049 MB |
| whisper.cpp (OpenVINO) | fp32 | 5 | 1p 45s | 1642 MB |
| **faster-whisper** | **int8** | **5** | **1p 42s** | **1477 MB** |
| **faster-whisper (batch_size=8)** | **int8** | **5** | **51s** | **3608 MB** |

*Chạy trên Intel Core i7-12700K, 8 luồng.*

### Use case production

| Use case | Mô hình | Phần cứng | Hiệu năng |
|---|---|---|---|
| **Phiên âm cuộc họp** (1h audio) | large-v3 int8 | RTX 4070 | ~3 phút xử lý |
| **Xử lý batch podcast** (100 file) | large-v3 int8 batch=8 | A100 40GB | ~20 phút cho 100h |
| **Phụ đề real-time** | small int8 | RTX 3060 | ~200ms độ trễ |
| **Phân tích tổng đài** | medium int8 | CPU 8 nhân | ~2x real-time |

## Sử dụng nâng cao / Củng cố production

### Bộ lọc VAD phân đoạn trước

```python
from faster_whisper import WhisperModel

model = WhisperModel("large-v3", device="cuda", compute_type="int8")

segments, info = model.transcribe(
    "audio.mp3",
    vad_filter=True,
    vad_parameters=dict(
        min_silence_duration_ms=500,
        speech_pad_ms=200,
        threshold=0.5
    ),
    beam_size=5
)
```

### Batch inference tối đa hóa thông lượng

```python
from faster_whisper import WhisperModel
import glob, time

model = WhisperModel("large-v3", device="cuda", compute_type="int8")
audio_files = glob.glob("podcasts/*.mp3")

start = time.time()
for file_path in audio_files:
    segments, _ = model.transcribe(file_path, batch_size=8, beam_size=5)
    text = " ".join([s.text for s in segments])
    print(f"{file_path}: {len(text)} ký tự")
print(f"Tổng thờ gian: {time.time() - start:.1f}s cho {len(audio_files)} file")
```

### Timestamp cấp từ

```python
segments, _ = model.transcribe("audio.mp3", word_timestamps=True)
for segment in segments:
    for word in segment.words:
        print(f"[{word.start:.2f}s -> {word.end:.2f}s] {word.word}")
```

### Chuyển đổi mô hình tùy chỉnh

```bash
pip install transformers[torch]>=4.23

ct2-transformers-converter \
  --model openai/whisper-large-v3 \
  --output_dir whisper-large-v3-ct2 \
  --copy_files tokenizer.json preprocessor_config.json \
  --quantization float16
```

### Giám sát bằng Prometheus

```python
from faster_whisper import WhisperModel
from prometheus_client import Counter, Histogram, start_http_server

REQUEST_COUNT = Counter("transcription_requests_total", "Tổng số yêu cầu")
REQUEST_DURATION = Histogram("transcription_duration_seconds", "Thờ gian yêu cầu")

model = WhisperModel("large-v3", device="cuda", compute_type="int8")

@REQUEST_DURATION.time()
def transcribe(audio_path):
    REQUEST_COUNT.inc()
    return model.transcribe(audio_path, beam_size=5)

start_http_server(8000)
```

### Xử lý lỗi linh hoạt

```python
from faster_whisper import WhisperModel

def safe_transcribe(audio_path, device="cuda"):
    compute_types = ["int8", "int8_float16", "float16", "float32"]
    for ct in compute_types:
        try:
            model = WhisperModel("large-v3", device=device, compute_type=ct)
            segments, info = model.transcribe(audio_path, beam_size=5)
            return segments, info, ct
        except RuntimeError as e:
            print(f"{ct} thất bại: {e}, thử lại...")
            continue
    raise RuntimeError("Tất cả compute type đều thất bại")
```

## So sánh với các lựa chọn thay thế

| Tính năng | faster-whisper | OpenAI Whisper | WhisperX | whisper.cpp |
|---|---|---|---|---|
| **Tốc độ GPU (large-v3)** | ~12x real-time | ~3x real-time | ~12x real-time | ~8x real-time |
| **VRAM (large-v3)** | ~2.5 GB (int8) | ~11 GB (fp16) | ~3 GB | ~3 GB |
| **Python API** | Native | Native | Native | Chỉ wrapper |
| **Phân tách ngưới nói** | Không | Không | Tích hợp | Không |
| **Timestamp cấp từ** | Có | Không | Có (wav2vec2) | Có |
| **Apple Silicon** | Chỉ CPU | CPU/GPU | Chỉ CPU | Metal (nhanh nhất) |
| **NVIDIA GPU** | CUDA (nhanh nhất) | CUDA | CUDA | CUDA |
| **AMD GPU** | Không | Không | Không | Vulkan/ROCm |
| **Tối ưu CPU** | int8 SIMD | Cơ bản | int8 SIMD | AVX2/NEON |
| **Bộ lọc VAD** | Silero tích hợp | Không | Tích hợp | Điều chỉnh thủ công |
| **Batch inference** | Có | Không | Có | Hạn chế |
| **Lượng tử hóa** | int8/fp16/fp32 | fp16/fp32 | int8/fp16 | q4/q5/fp16 |
| **Giấy phép** | MIT | MIT | MIT | MIT |
| **Stars (Tháng 5/2026)** | 23,000+ | 15,000+ | 12,000+ | 44,000+ |

### Khi nào chọn cái nào

- **faster-whisper**: Pipeline Python trên GPU NVIDIA hoặc CPU. Hệ sinh thái tích hợp tốt nhất. Dùng cho dịch vụ STT production, xử lý batch, ứng dụng real-time Python.
- **OpenAI Whisper**: Nghiên cứu và thử nghiệm cần triển khai tham chiếu. Tránh dùng cho workload production.
- **WhisperX**: Phiên âm cuộc họp, podcast, phỏng vấn cần nhãn ngưới nói. Xây dựng trên faster-whisper.
- **whisper.cpp**: Apple Silicon, thiết bị nhúng, triển khai edge, ứng dụng đa nền tảng. Không phụ thuộc Python.

## Hạn chế / Đánh giá trung thực

faster-whisper không phải công cụ phù hợp mọi tình huống. Đây là những gì nó KHÔNG giỏi:

1. **Tăng tốc GPU Apple Silicon**: faster-whisper không có backend Metal. Trên Mac M-series, nó chỉ chạy CPU với tốc độ ~3x real-time cho large-v3. whisper.cpp với Metal đạt ~10x real-time — nhanh gấp 3 lần.

2. **Hỗ trợ AMD GPU**: CTranslate2 chỉ hỗ trợ CUDA trên GPU. AMD GPU không được hỗ trợ. Dùng whisper.cpp với Vulkan hoặc ROCm thay thế.

3. **Thiết bị edge cực nhỏ**: faster-whisper hoạt động trên CPU nhưng overhead runtime Python khiến nó kém phù hợp hơn whisper.cpp cho Raspberry Pi Zero hoặc vi điều khiển. whisper.cpp vừa trong 1 GB RAM và chạy không cần Python.

4. **Phân tách ngưới nói**: faster-whisper chỉ xuất bản phiên âm. Xác định "ai nói gì" cần WhisperX hoặc pipeline phân tách riêng.

5. **Mở rộng audio dài**: Với audio rất dài (>30 phút), whisper.cpp có thể cho đặc tính mở rộng tốt hơn trong một số tình huống CPU-bound. Benchmark phần cứng cụ thể của bạn.

6. **Máy chủ GPU không phải NVIDIA**: Nếu hạ tầng dùng AMD Instinct hoặc Intel Arc GPU, faster-whisper sẽ fallback về CPU. Đây là giới hạn cứng của CTranslate2.

## Câu hỏi thường gặp

### Cần phần cứng gì để chạy faster-whisper?

GPU inference cần NVIDIA GPU hỗ trợ CUDA 12.x. Lượng tử hóa INT8 chạy thoải mái trên card 8GB VRAM (RTX 3060, RTX 4060). CPU inference cần 4+ nhân và 8GB RAM cho mô hình small. Mô hình large-v3 cần ~3GB RAM với INT8 trên CPU.

### Cách cài faster-whisper trong Docker?

Dùng image NVIDIA CUDA runtime chính thức với cuDNN 9. Phần Cài đặt & Thiết lập bên trên có Dockerfile đầy đủ. Yêu cầu cốt lõi là image nền `nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04`. Chạy với `--gpus all` để expose GPU.

### Độ chính xác phiên âm có giống OpenAI Whisper không?

Có. faster-whisper dùng cùng trọng số mô hình và tokenizer. Chênh lệch WER trong khoảng 0.1% — không phân biệt được trong thực tế. Mọi sai khác đến từ ngẫu nhiên beam search, không phải engine inference.

### Compute_type tốt nhất cho GPU của tôi?

Dùng `int8` để tiết kiệm VRAM tối đa (phù hợp card GTX 10xx và 8GB). Dùng `float16` để tốc độ tốt nhất trên GPU hiện đại (RTX 30xx/40xx/50xx, A100, H100). Card Pascal tiêu dùng (GTX 1060/1070/1080) nên dùng `int8` do hỗ trợ fp16 hạn chế.

### faster-whisper so với WhisperX?

WhisperX xây dựng trên faster-whisper và thêm phân tách ngưới nói + căn chỉnh timestamp cấp từ qua wav2vec2. Cho phiên âm thuần túy, faster-whisper đã đủ. Dùng WhisperX khi cần nhãn "ai nói gì" trong cuộc họp hoặc phỏng vấn.

### Có thể dùng faster-whisper cho streaming real-time?

Có, thông qua tích hợp với Whisper-Streaming hoặc WhisperLive. faster-whisper không hỗ trợ streaming native nhưng độ trễ thấp khiến nó lý tưởng làm backend cho server streaming. Độ trễ end-to-end điển hình cho mô hình small trên GPU là 200-500ms.

### Cách chuyển đổi mô hình Whisper fine-tune?

Dùng công cụ CLI `ct2-transformers-converter` (được trình bày trong phần Sử dụng nâng cao). Mọi mô hình trên Hugging Face Hub hoặc checkpoint local tương thích Transformers đều có thể chuyển đổi. Hỗ trợ cả lượng tử hóa FP16 và INT8 trong quá trình chuyển đổi.

### faster-whisper có hỗ trợ mọi kích thước mô hình Whisper?

Có — hỗ trợ tiny, base, small, medium, large-v1, large-v2, large-v3. Các biến thể distil-whisper (distil-large-v3) cũng được hỗ trợ để inference nhanh hơn với đánh đổi độ chính xác nhỏ.

## Kết luận

faster-whisper là lựa chọn runtime production cho OpenAI Whisper trong môi trường Python. Với tốc độ nhanh gấp 4x so với triển khai tham chiếu, giảm 70% VRAM nhờ lượng tử hóa INT8, và hệ sinh thái tích hợp phát triển (WhisperX, speaches, whisper-asr-webservice), nó xử lý mọi thứ từ phiên âm file đơn đến xử lý hàng loạt hàng trăm giờ audio.

Dữ liệu rõ ràng: nếu bạn dùng GPU NVIDIA và Python, faster-whisper là baseline. Bắt đầu với mô hình int8 large-v3 cho mục đích chung, giảm xuống small cho real-time, và tích hợp WhisperX khi cần nhãn ngưới nói.

**Danh sách hành động:**

1. Chạy `pip install faster-whisper` và chạy script xác minh bên trên.
2. Benchmark phần cứng của bạn với file test audio 13 phút từ repo.
3. Thiết lập triển khai Docker cho pipeline production.
4. Tham gia [nhóm Telegram dibi8.com](https://t.me/dibi8tech) để chia sẻ benchmark và nhận hỗ trợ production.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- Kho GitHub faster-whisper: https://github.com/SYSTRAN/faster-whisper
- Tài liệu CTranslate2: https://opennmt.net/CTranslate2/
- WhisperX (phân tách ngưới nói): https://github.com/m-bain/whisperX
- whisper.cpp (bản C++): https://github.com/ggml-org/whisper.cpp
- OpenAI Whisper (triển khai tham chiếu): https://github.com/openai/whisper
- Speaches (máy chủ tương thích OpenAI): https://github.com/speaches-ai/speaches
- Whisper-Streaming (real-time): https://github.com/ufal/whisper_streaming
- PyAV (giải mã audio): https://github.com/PyAV-Org/PyAV
- Silero VAD: https://github.com/snakers4/silero-vad
