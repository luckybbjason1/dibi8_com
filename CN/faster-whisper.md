---
title: 'faster-whisper: 4x Faster Speech-to-Text with 23K+ Stars — Benchmark vs WhisperX, whisper.cpp in 2026'
description: 'faster-whisper (SYSTRAN) reimplements OpenAI Whisper via CTranslate2 for 4x speedup. Covers faster whisper tutorial, benchmark data, Docker setup, Python API, VAD filter, batch processing, and production hardening with WhisperX and whisper.cpp integration.'
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
tags: ['faster-whisper', 'speech-to-text', 'CTranslate2', 'OpenAI Whisper', 'voice recognition', 'Python', 'Docker', 'ASR']
aliases:
- /posts/faster-whisper/
---

{{</* resource-info */>}}

OpenAI's Whisper changed speech-to-text in 2022, but the original Python implementation left significant performance on the table. For a 13-minute audio file, `openai/whisper` with the large-v2 model takes over 4 minutes on a Tesla V100 GPU — unacceptable for production pipelines processing hundreds of hours daily. SYSTRAN's **faster-whisper** reimplements Whisper inference using CTranslate2, delivering up to 4x speedup at identical accuracy while cutting VRAM usage by nearly 70%. With 23,000+ GitHub stars, it has become the de facto runtime for production speech-to-text in Python environments.

This guide provides a production-grade faster whisper tutorial covering installation, benchmarking, Docker deployment, and integration with WhisperX and whisper.cpp. Every command and config is copy-paste ready — a complete speech to text setup you can deploy today.

![faster-whisper GitHub repo](https://opengraph.githubassets.com/1/SYSTRAN/faster-whisper)

*Figure 1: faster-whisper GitHub repository — 23,000+ stars, actively maintained by SYSTRAN.*

## How faster-whisper Works

The architecture replaces PyTorch inference with CTranslate2's optimized runtime:

![CTranslate2 Architecture](https://opennmt.net/CTranslate2/_static/favicon.png)

*Figure 2: CTranslate2 inference engine — the C++ backend powering faster-whisper's speedup through custom CUDA kernels and quantization.*

## What Is faster-whisper?

faster-whisper is a reimplementation of OpenAI's Whisper automatic speech recognition (ASR) model using CTranslate2, a high-performance C++ inference engine for Transformer models. It runs the same model weights as the original Whisper but delivers substantially higher throughput and lower memory usage through custom CUDA kernels, INT8/FP16 quantization, and fused attention operations.

The project started as a community effort by Guillaume Klein and is now maintained by SYSTRAN under the MIT license. It supports all Whisper model sizes (tiny through large-v3) on both CPU and NVIDIA GPU, with automatic model conversion from Hugging Face Hub on first load.

## How faster-whisper Works

The architecture replaces PyTorch inference with CTranslate2's optimized runtime:

```
Audio Input (wav/mp3/flac)
    |
    v
PyAV Audio Decoder (FFmpeg bundled, no external dependency)
    |
    v
Mel Spectrogram Computation
    |
    v
CTranslate2 Whisper Engine (C++ backend)
    |-- Custom CUDA kernels for NVIDIA GPU
    |-- INT8/FP16 quantized weights
    |-- Fused self-attention + cross-attention
    |-- SIMD-optimized CPU path (AVX2/NEON)
    |
    v
Tokenizer (Hugging Face tokenizers)
    |
    v
Transcription Segments (start, end, text, confidence)
```

Key technical decisions that enable the speedup:

- **Weight quantization**: INT8 reduces model memory by ~50% with negligible accuracy loss (< 0.1% WER).
- **Fused kernels**: CTranslate2 merges multiple GPU operations into single kernel launches, reducing dispatch overhead.
- **Flash Attention support**: Available on Ampere GPUs (RTX 30xx+) for additional memory bandwidth savings.
- **Batched inference**: Process multiple audio chunks in parallel on GPU for near-linear throughput scaling.
- **Silero VAD integration**: Built-in voice activity detection skips silent segments, reducing wasted compute.

## Installation & Setup

### Requirements

- Python 3.9+
- For GPU: NVIDIA GPU with CUDA 12.x and cuDNN 9.x
- No FFmpeg installation required (bundled via PyAV)

### pip Install (CPU)

```bash
# Create virtual environment
python -m venv venv-whisper
source venv-whisper/bin/activate  # Linux/Mac
# venv-whisper\Scripts\activate  # Windows

# Install faster-whisper
pip install faster-whisper
```

### pip Install with GPU Support

```bash
# Install cuBLAS and cuDNN via pip (Linux only)
pip install nvidia-cublas-cu12 nvidia-cudnn-cu12==9.*

# Set library path before running
export LD_LIBRARY_PATH=$(python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))')

# Install faster-whisper
pip install faster-whisper
```

### Docker Setup

```bash
# Pull the official NVIDIA CUDA image with cuDNN
docker run -it --rm --gpus all \
  -v $(pwd)/audio:/audio \
  nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04 \
  bash

# Inside container
apt-get update && apt-get install -y python3-pip
pip install faster-whisper
```

### Verification

```python
# verify_setup.py
from faster_whisper import WhisperModel
import torch

print(f"PyTorch CUDA available: {torch.cuda.is_available()}")
print(f"CUDA devices: {torch.cuda.device_count()}")

model = WhisperModel("tiny", device="cuda", compute_type="float16")
print(f"Model loaded on: {model.model.device}")
print("Setup verified successfully")
```

```bash
python verify_setup.py
```

### First Transcription

```python
from faster_whisper import WhisperModel

# Load model (auto-downloads from Hugging Face on first run)
model = WhisperModel("large-v3", device="cuda", compute_type="int8")

# Transcribe audio file
segments, info = model.transcribe("audio.mp3", beam_size=5)

print(f"Detected language: {info.language} "
      f"(probability: {info.language_probability:.2f})")

for segment in segments:
    print(f"[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}")
```

## Integration with Popular Tools

### WhisperX (Speaker Diarization)

WhisperX builds on faster-whisper to add word-level timestamps and speaker diarization. It is the go-to tool for meeting transcription.

```bash
pip install whisperx
```

```python
import whisperx
import torch

device = "cuda" if torch.cuda.is_available() else "cpu"
audio_file = "meeting.mp3"

# 1. Transcribe with faster-whisper backend
model = whisperx.load_model("large-v3", device, compute_type="int8")
audio = whisperx.load_audio(audio_file)
result = model.transcribe(audio, batch_size=8)

# 2. Align for word-level timestamps
model_a, metadata = whisperx.load_align_model(
    language_code=result["language"], device=device
)
result = whisperx.align(result["segments"], model_a, metadata, audio, device)

# 3. Speaker diarization (requires Hugging Face token)
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

### whisper-asr-webservice (OpenAI-Compatible API)

Expose faster-whisper via an OpenAI-compatible HTTP API:

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

### Speaches (Self-Hosted OpenAI-Compatible Server)

Speaches is a modern, OpenAI-compatible server built on faster-whisper:

```bash
docker run -d --gpus all \
  -p 8000:8000 \
  -e WHISPER__MODEL=large-v3 \
  -e WHISPER__COMPUTE_TYPE=int8 \
  fedirz/speaches:latest-gpu
```

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:8000/v1",
    api_key="dummy"
)

with open("audio.mp3", "rb") as f:
    transcript = client.audio.transcriptions.create(
        model="large-v3", file=f
    )
print(transcript.text)
```

### LibreTranslate (Translation Pipeline)

Chain transcription with translation for multilingual workflows:

```python
from faster_whisper import WhisperModel
import requests

# Transcribe non-English audio
model = WhisperModel("large-v3", device="cuda", compute_type="int8")
segments, info = model.transcribe("japanese_audio.mp3", beam_size=5)
japanese_text = " ".join([s.text for s in segments])

# Translate via LibreTranslate
response = requests.post("http://localhost:5000/translate", json={
    "q": japanese_text,
    "source": "ja",
    "target": "en"
})
translation = response.json()["translatedText"]
print(f"JA: {japanese_text}")
print(f"EN: {translation}")
```

## Benchmarks / Real-World Use Cases

All benchmarks below use official numbers from the faster-whisper repository — this is the definitive faster whisper benchmark reference. Two hardware configurations are tested: an NVIDIA RTX 3070 Ti 8GB for GPU benchmarks and an Intel Core i7-12700K for CPU benchmarks.

![Benchmark comparison chart](https://raw.githubusercontent.com/SYSTRAN/faster-whisper/master/benchmark/results.png)

*Figure 3: Official benchmark results — faster-whisper achieves up to 8.9x speedup over openai/whisper with batched INT8 inference on RTX 3070 Ti.*

### GPU Benchmark: 13 Minutes of Audio, large-v2 Model

| Implementation | Precision | Beam Size | Time | VRAM Usage |
|---|---|---|---|---|
| openai/whisper | fp16 | 5 | 2m 23s | 4708 MB |
| whisper.cpp (Flash Attention) | fp16 | 5 | 1m 05s | 4127 MB |
| transformers (SDPA) | fp16 | 5 | 1m 52s | 4960 MB |
| **faster-whisper** | **fp16** | **5** | **1m 03s** | **4525 MB** |
| **faster-whisper (batch_size=8)** | **fp16** | **5** | **17s** | **6090 MB** |
| **faster-whisper** | **int8** | **5** | **59s** | **2926 MB** |
| **faster-whisper (batch_size=8)** | **int8** | **5** | **16s** | **4500 MB** |

*Executed with CUDA 12.4 on NVIDIA RTX 3070 Ti 8GB.*

Key takeaways from the GPU benchmark:

- **Single inference**: faster-whisper fp16 is **2.3x faster** than openai/whisper (1m03s vs 2m23s).
- **Batched inference**: With `batch_size=8`, faster-whisper processes the same audio in **17 seconds** — an **8.4x speedup** over the original.
- **INT8 quantization**: Reduces VRAM from 4525 MB to 2926 MB (35% savings) with a minor 4-second penalty.
- **Best throughput**: INT8 batched inference hits **16 seconds**, or **8.9x faster** than openai/whisper.

### CPU Benchmark: 13 Minutes of Audio, small Model

| Implementation | Precision | Beam Size | Time | RAM Usage |
|---|---|---|---|---|
| openai/whisper | fp32 | 5 | 6m 58s | 2335 MB |
| whisper.cpp | fp32 | 5 | 2m 05s | 1049 MB |
| whisper.cpp (OpenVINO) | fp32 | 5 | 1m 45s | 1642 MB |
| **faster-whisper** | **fp32** | **5** | **2m 37s** | **2257 MB** |
| **faster-whisper (batch_size=8)** | **fp32** | **5** | **1m 06s** | **4230 MB** |
| **faster-whisper** | **int8** | **5** | **1m 42s** | **1477 MB** |
| **faster-whisper (batch_size=8)** | **int8** | **5** | **51s** | **3608 MB** |

*Executed with 8 threads on Intel Core i7-12700K.*

Key takeaways from the CPU benchmark:

- **INT8 on CPU**: faster-whisper int8 is **4.1x faster** than openai/whisper (1m42s vs 6m58s).
- **INT8 batched**: With `batch_size=8`, faster-whisper finishes in **51 seconds** — **8.2x faster** than the original.
- **Memory efficiency**: INT8 uses only 1477 MB RAM vs 2335 MB for openai/whisper (37% reduction).

### distil-whisper-large-v3 Benchmark

| Implementation | Precision | Beam Size | Time | YT Commons WER |
|---|---|---|---|---|
| transformers (SDPA, batch_size=16) | fp16 | 5 | 46m 12s | 14.801 |
| **faster-whisper (batch_size=16)** | **fp16** | **5** | **25m 50s** | **13.527** |

*GPU: NVIDIA RTX 3070 Ti 8GB.*

### Production Use Cases

| Use Case | Model | Hardware | Performance |
|---|---|---|---|
| **Meeting transcription** (1h audio) | large-v3 int8 | RTX 4070 | ~3 min processing |
| **Podcast batch processing** (100 files) | large-v3 int8 batch=8 | A100 40GB | ~20 min for 100h |
| **Real-time captions** | small int8 | RTX 3060 | ~200ms latency |
| **Call center analytics** | medium int8 | CPU 8-core | ~2x real-time |
| **Embedded device** | tiny int8 | ARM Cortex-A78 | ~0.5x real-time |

## Advanced Usage / Production Hardening

### VAD Filter for Pre-Segmentation

Voice Activity Detection removes silent segments before transcription, reducing wasted compute:

```python
from faster_whisper import WhisperModel

model = WhisperModel("large-v3", device="cuda", compute_type="int8")

# Enable VAD filter with custom parameters
segments, info = model.transcribe(
    "audio.mp3",
    vad_filter=True,
    vad_parameters=dict(
        min_silence_duration_ms=500,   # Split on 500ms+ silence
        speech_pad_ms=200,              # 200ms padding around speech
        threshold=0.5                   # VAD confidence threshold
    ),
    beam_size=5
)
```

### Batched Inference for Maximum Throughput

```python
from faster_whisper import WhisperModel
import glob
import time

model = WhisperModel("large-v3", device="cuda", compute_type="int8")

# Process multiple files in a single batch call
audio_files = glob.glob("podcasts/*.mp3")

start = time.time()
for file_path in audio_files:
    segments, _ = model.transcribe(file_path, batch_size=8, beam_size=5)
    text = " ".join([s.text for s in segments])
    print(f"{file_path}: {len(text)} chars")

elapsed = time.time() - start
print(f"Total time: {elapsed:.1f}s for {len(audio_files)} files")
```

### Word-Level Timestamps

```python
segments, _ = model.transcribe("audio.mp3", word_timestamps=True)

for segment in segments:
    for word in segment.words:
        print(f"[{word.start:.2f}s -> {word.end:.2f}s] {word.word}")
```

### Custom Model Conversion

Convert fine-tuned Whisper models for use with faster-whisper:

```bash
# Install conversion dependencies
pip install transformers[torch]>=4.23

# Convert a fine-tuned model
ct2-transformers-converter \
  --model openai/whisper-large-v3 \
  --output_dir whisper-large-v3-ct2 \
  --copy_files tokenizer.json preprocessor_config.json \
  --quantization float16
```

```python
# Load the converted model
model = WhisperModel("whisper-large-v3-ct2", device="cuda")
```

### Monitoring with Prometheus

```python
from faster_whisper import WhisperModel
from prometheus_client import Counter, Histogram, start_http_server
import time

REQUEST_COUNT = Counter("transcription_requests_total", "Total requests")
REQUEST_DURATION = Histogram("transcription_duration_seconds", "Request duration")

model = WhisperModel("large-v3", device="cuda", compute_type="int8")

@REQUEST_DURATION.time()
def transcribe(audio_path):
    REQUEST_COUNT.inc()
    segments, info = model.transcribe(audio_path, beam_size=5)
    return segments, info

# Expose metrics on port 8000
start_http_server(8000)
```

### Graceful Error Handling

```python
from faster_whisper import WhisperModel

def safe_transcribe(audio_path, device="cuda"):
    """Transcribe with fallback on GPU errors."""
    compute_types = ["int8", "int8_float16", "float16", "float32"]
    
    for compute_type in compute_types:
        try:
            model = WhisperModel(
                "large-v3", device=device, compute_type=compute_type
            )
            segments, info = model.transcribe(audio_path, beam_size=5)
            return segments, info, compute_type
        except RuntimeError as e:
            print(f"{compute_type} failed: {e}, retrying...")
            continue
    
    raise RuntimeError("All compute types failed")

segments, info, used_type = safe_transcribe("audio.mp3")
print(f"Used compute type: {used_type}")
```

## Comparison with Alternatives

| Feature | faster-whisper | OpenAI Whisper | WhisperX | whisper.cpp |
|---|---|---|---|---|
| **Speed (large-v3 GPU)** | ~12x real-time | ~3x real-time | ~12x real-time | ~8x real-time |
| **VRAM (large-v3)** | ~2.5 GB (int8) | ~11 GB (fp16) | ~3 GB | ~3 GB |
| **Python API** | Native | Native | Native | Wrapper only |
| **Speaker diarization** | No | No | Built-in | No |
| **Word-level timestamps** | Yes | No | Yes (via wav2vec2) | Yes |
| **Apple Silicon** | CPU only | CPU/GPU | CPU only | Metal (fastest) |
| **NVIDIA GPU** | CUDA (fastest) | CUDA | CUDA | CUDA |
| **AMD GPU** | No | No | No | Vulkan/ROCm |
| **CPU optimization** | int8 SIMD | Basic | int8 SIMD | AVX2/NEON |
| **VAD filter** | Built-in Silero | No | Built-in | Manual tuning |
| **Batch inference** | Yes | No | Yes | Limited |
| **Model quantization** | int8/fp16/fp32 | fp16/fp32 | int8/fp16 | q4/q5/fp16 |
| **License** | MIT | MIT | MIT | MIT |
| **Stars (May 2026)** | 23,000+ | 15,000+ | 12,000+ | 44,000+ |

### When to Choose Which

- **faster-whisper**: Python pipelines on NVIDIA GPU or CPU. Best integration ecosystem. Use for production STT services, batch processing, and real-time Python applications.
- **OpenAI Whisper**: Research and experimentation where you need the reference implementation. Avoid for production workloads.
- **WhisperX**: Meeting transcription, podcasts, and interviews where speaker labels are required. Built on faster-whisper.
- **whisper.cpp**: Apple Silicon, embedded devices, edge deployment, and cross-platform apps. No Python dependency.

## Limitations / Honest Assessment

faster-whisper is not the right tool for every scenario. Here is what it is NOT good for:

1. **Apple Silicon GPU acceleration**: faster-whisper has no Metal backend. On M-series Macs, it runs CPU-only at roughly 3x real-time for large-v3. whisper.cpp with Metal achieves ~10x real-time — 3x faster.

2. **AMD GPU support**: CTranslate2 only supports CUDA on GPU. AMD GPUs are not supported. Use whisper.cpp with Vulkan or ROCm instead.

3. **Extreme edge devices**: While faster-whisper works on CPU, the Python runtime overhead makes it less suitable than whisper.cpp for Raspberry Pi Zero or microcontrollers. whisper.cpp fits in 1 GB RAM and runs without Python.

4. **Speaker diarization**: faster-whisper outputs transcription only. Identifying "who spoke when" requires WhisperX or a separate diarization pipeline.

5. **Long-form audio scaling**: On very long audio (> 30 minutes), whisper.cpp can show better scaling characteristics in some CPU-bound scenarios. Benchmark your specific hardware.

6. **Non-NVIDIA GPU servers**: If your infrastructure runs on AMD Instinct or Intel Arc GPUs, faster-whisper will fall back to CPU. This is a hard limitation of CTranslate2.

## Frequently Asked Questions

### What hardware do I need to run faster-whisper?

For GPU inference, any NVIDIA GPU with CUDA 12.x support works. INT8 quantization runs comfortably on 8 GB VRAM cards (RTX 3060, RTX 4060). For CPU inference, 4+ cores and 8 GB RAM are sufficient for the small model. The large-v3 model needs ~3 GB RAM with INT8 on CPU.

### How do I install faster-whisper in Docker?

Use the official NVIDIA CUDA runtime image with cuDNN 9. A complete faster whisper docker configuration is shown in the Installation & Setup section above. The key requirement is the `nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04` base image. Run with `--gpus all` to expose the GPU.

### Is transcription accuracy identical to OpenAI Whisper?

Yes. faster-whisper uses the same model weights and tokenizer. Word Error Rate (WER) differences are within 0.1% — indistinguishable in practice. Any variation comes from beam search randomness, not the inference engine.

### What is the best compute_type for my GPU?

Use `int8` for maximum VRAM savings (suitable for GTX 10xx cards and 8 GB GPUs). Use `float16` for best speed on modern GPUs (RTX 30xx/40xx/50xx, A100, H100). Use `int8_float16` as a middle ground. Pascal consumer cards (GTX 1060/1070/1080) should use `int8` due to limited fp16 support.

### How does faster-whisper compare to WhisperX?

WhisperX builds on top of faster-whisper and adds speaker diarization + word-level timestamp alignment via wav2vec2. For pure transcription, faster-whisper is sufficient. Use WhisperX when you need "who said what" labels in meetings or interviews.

### Can I use faster-whisper for real-time streaming?

Yes, via integration with Whisper-Streaming or WhisperLive. faster-whisper itself does not stream natively, but its low latency makes it ideal as a backend for streaming servers. Typical end-to-end latency is 200-500 ms for the small model on GPU.

### How do I convert a fine-tuned Whisper model?

Use the `ct2-transformers-converter` CLI tool (shown in Advanced Usage). Any model on Hugging Face Hub or local checkpoint compatible with Transformers can be converted. Both FP16 and INT8 quantization are supported during conversion.

### Does faster-whisper support all Whisper model sizes?

Yes — tiny, base, small, medium, large-v1, large-v2, and large-v3 are all supported. The distil-whisper variants (distil-large-v3) are also supported for even faster inference with a small accuracy trade-off.

## Conclusion

faster-whisper is the production runtime of choice for OpenAI Whisper in Python environments. With 4x speedup over the reference implementation, 70% VRAM reduction via INT8 quantization, and a mature ecosystem of integrations (WhisperX, speaches, whisper-asr-webservice), it handles everything from single-file transcription to batch-processing hundreds of hours of audio.

The data is clear: in any whisper vs faster whisper comparison, the performance advantage goes to the CTranslate2-based runtime. If you run NVIDIA GPUs and Python, faster-whisper is the baseline. Start with the int8 large-v3 model for general use, drop to small for real-time, and integrate WhisperX when you need speaker labels.

**Action items:**

1. `pip install faster-whisper` and run the verification script above.
2. Benchmark your hardware with the 13-minute test audio from the repo.
3. Set up Docker deployment for your production pipeline.
4. Join the [dibi8.com Telegram group](https://t.me/dibi8tech) to share benchmarks and get help with production issues.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- faster-whisper GitHub repository: https://github.com/SYSTRAN/faster-whisper
- CTranslate2 documentation: https://opennmt.net/CTranslate2/
- WhisperX (speaker diarization): https://github.com/m-bain/whisperX
- whisper.cpp (C++ port): https://github.com/ggml-org/whisper.cpp
- OpenAI Whisper (reference implementation): https://github.com/openai/whisper
- Speaches (OpenAI-compatible server): https://github.com/speaches-ai/speaches
- Whisper-Streaming (real-time): https://github.com/ufal/whisper_streaming
- PyAV (audio decoding): https://github.com/PyAV-Org/PyAV
- Silero VAD: https://github.com/snakers4/silero-vad
