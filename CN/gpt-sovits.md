---
title: 'GPT-SoVITS: 57.5K+ Stars — Deploy AI Voice Cloning Production Setup Guide 2026'
description: 'GPT-SoVITS (GSV) is a few-shot voice cloning and TTS tool with zero-shot capabilities. Supports ComfyUI, RVC, and MeloTTS integration. Covers Docker deployment, voice training, API setup, and production hardening.'
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
github_repo: 'https://github.com/RVC-Boss/GPT-SoVITS'
stars: 57500
maintainer: 'RVC-Boss'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['voice-cloning', 'text-to-speech', 'gpt-sovits', 'tts', 'ai-voice', 'docker', 'rvc', 'python']
aliases:
- /posts/gpt-sovits/
---

{{</* resource-info */>}}

> Clone any voice with 5 seconds of audio. Fine-tune with 1 minute. Deploy in production under 20 minutes. This guide walks you through the full setup.

## Introduction

Building a voice cloning pipeline used to require recording studios, weeks of data collection, and six-figure budgets. In 2026, a single open-source repository with 57,500+ GitHub stars changed that equation. **GPT-SoVITS** lets developers clone voices from 5-second samples and fine-tune production-quality TTS models with just 1 minute of training data. Whether you are building audiobook tools, game character voices, or real-time voice agents, this guide covers the full production deployment path — from first install to hardened API serving. If you are searching for a **gpt-sovits tutorial** or a **voice cloning setup** that works at scale, this is the reference. We also cover **ai voice synthesis** at length and provide a detailed **gpt-sovits vs coqui** comparison table below.

## What Is GPT-SoVITS?

**GPT-SoVITS** is a few-shot voice conversion and text-to-speech (TTS) framework that combines a GPT-based semantic token predictor with a SoVITS (Speech Synthesis via VITS) neural vocoder. Released under the MIT license by maintainer **RVC-Boss**, it has attracted 96+ contributors and supports zero-shot inference (5-second reference), few-shot fine-tuning (1 minute), and cross-lingual synthesis across English, Japanese, Korean, Cantonese, and Chinese. The latest v4 release fixes metallic artifacts and outputs native 48kHz audio.

## How GPT-SoVITS Works

### Architecture Overview

GPT-SoVITS uses a two-stage pipeline that separates linguistic understanding from audio waveform generation:

```
Text Input → BERT Text Encoder → GPT Model (330M params) → Semantic Tokens
                                                          ↓
Reference Audio → HuBERT Encoder → SoVITS Model (77M params) → Vocoder → 48kHz Audio
```

**Stage 1 — GPT (Text-to-Semantic):** A 330M-parameter GPT model converts phoneme sequences into discrete semantic tokens. BERT embeddings provide linguistic context for accurate pronunciation and prosody prediction.

**Stage 2 — SoVITS (Semantic-to-Voice):** A 77M-parameter SoVITS module transforms semantic tokens into audio waveforms. It uses a GAN-based generator with a flow network for bidirectional latent mapping, conditioned on reference audio embeddings extracted via HuBERT.

### Core Components

| Component | Purpose | Parameters |
|-----------|---------|------------|
| GPT Model | Semantic token prediction | 330M |
| SoVITS Generator | Waveform synthesis | 77M |
| BERT Text Encoder | Linguistic feature extraction | Shared with GPT |
| HuBERT Encoder | Reference audio feature extraction | Pre-trained |
| Residual Vector Quantizer | Token discretization | Part of SoVITS |
| BigVGAN Vocoder | Final audio upsampling | Pre-trained |

### Version Evolution

| Version | Key Improvement | Training Data |
|---------|----------------|---------------|
| V1 | Initial release | 2,000 hours |
| V2 | +Korean, +Cantonese, optimized frontend | 5,000 hours |
| V3 | Higher timbre similarity, LoRA support | 7,000 hours |
| V4 | Fixed metallic artifacts, native 48kHz output | 7,000 hours |
| V2Pro | Best speed/quality tradeoff (0.014 RTF on RTX 4090) | 5,000+ hours |

![GPT-SoVITS Architecture](https://raw.githubusercontent.com/RVC-Boss/GPT-SoVITS/main/docs/intro.png)

### Pipeline Data Flow

The complete training and inference pipeline follows this flow:

```
Raw Audio → UVR5 Separation → Audio Slicer → ASR Transcription → Text Labeling
                                                                                ↓
Pretrained GPT + SoVITS ← Fine-tuning (1 min data) ← Formatted Dataset
                                                                                ↓
Inference: Reference Audio + Text → GPT (Semantic Tokens) → SoVITS → 48kHz Audio
```

![GPT-SoVITS WebUI Interface](https://www.nite07.com/en/posts/gpt-sovits/webui.png)

## Installation & Setup

### Hardware Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| GPU | NVIDIA GTX 1060 (6GB) | RTX 4060 Ti or better |
| VRAM | 6 GB | 8+ GB (fp16) |
| RAM | 16 GB | 32 GB |
| Storage | 20 GB SSD | 50 GB NVMe |

### Option A: Conda Installation (Linux / macOS)

```bash
# Step 1: Create and activate environment
conda create -n GPTSoVits python=3.10 -y
conda activate GPTSoVits

# Step 2: Install FFmpeg
conda install ffmpeg -y

# Step 3: Clone repository
git clone https://github.com/RVC-Boss/GPT-SoVITS.git
cd GPT-SoVITS

# Step 4: Install dependencies
pip install -r extra-req.txt --no-deps
pip install -r requirements.txt
```

### Option B: Windows Integrated Package

```powershell
# Download the integrated package from HuggingFace
# Extract and run:
conda create -n GPTSoVits python=3.10
conda activate GPTSoVits
pwsh -F install.ps1 -Device CU126 -Source HF
```

### Option C: Docker Deployment (Recommended for Production)

```bash
# Clone and enter project directory
git clone https://github.com/RVC-Boss/GPT-SoVITS.git
cd GPT-SoVITS

# Pull latest code before building
git pull origin main

# Build Docker image (CUDA 12.8, full version)
bash docker_build.sh --cuda 12.8

# Or use pre-built images from Docker Hub
docker compose run --service-ports GPT-SoVITS-CU128
```

### Docker Compose Configuration

```yaml
# docker-compose.override.yaml for production
services:
  GPT-SoVITS-CU128:
    shm_size: '16g'
    environment:
      - is_half=true
    ports:
      - "9874:9874"
      - "9880:9880"
    volumes:
      - ./models:/workspace/models
      - ./outputs:/workspace/outputs
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

### Pretrained Model Setup

```bash
# Download pretrained models (run once)
mkdir -p GPT_SoVITS/pretrained_models

# Download from HuggingFace (auto-download via install.sh)
# Or manually for v4:
# s2v4.pth, vocoder.pth → GPT_SoVITS/pretrained_models/gsv-v4-pretrained/

# Download G2PW model for Chinese TTS
# Unzip G2PWModel.zip and place in: GPT_SoVITS/text/G2PWModel/

# Download UVR5 weights for voice separation
# Place in: tools/uvr5/uvr5_weights/
```

### Launch the WebUI

```bash
# Standard launch (defaults to port 9874)
python webui.py

# Specify language explicitly
python webui.py en

# Launch inference-only API server
python api_v2.py
```

## Integration with Popular Tools

### Integration with ComfyUI

ComfyUI nodes for GPT-SoVITS enable voice generation inside visual workflows:

```bash
# Install ComfyUI-GPT-SoVITS nodes
cd ComfyUI/custom_nodes
git clone https://github.com/yaolidi/ComfyUI-GPT-SoVITS.git

# Install dependencies
pip install -r ComfyUI-GPT-SoVITS/requirements.txt

# Place your trained .pth and .ckpt models in:
# ComfyUI/models/GPT-SoVITS/
```

The node exposes GPT-SoVITS inference as a ComfyUI node with inputs for reference audio, text, and model selection.

### Integration with RVC (Retrieval-based Voice Conversion)

RVC and GPT-SoVITS share the same ecosystem. Use RVC for real-time voice conversion and GPT-SoVITS for high-quality TTS:

```python
# Pipeline: GPT-SoVITS TTS → RVC Voice Conversion
import requests
import subprocess

# Step 1: Generate speech with GPT-SoVITS API
tts_payload = {
    "text": "Hello, this is a cloned voice speaking.",
    "text_lang": "en",
    "ref_audio_path": "/path/to/reference.wav",
    "prompt_text": "Reference transcript text",
    "prompt_lang": "en",
    "media_type": "wav"
}

response = requests.post("http://localhost:9880/tts", json=tts_payload)
with open("tts_output.wav", "wb") as f:
    f.write(response.content)

# Step 2: Convert through RVC (optional real-time VC)
rvc_cmd = [
    "python", "RVC/infer_cli.py",
    "--input", "tts_output.wav",
    "--model", "models/rvc_model.pth",
    "--output", "final_output.wav"
]
subprocess.run(rvc_cmd)
```

### Integration with MeloTTS

MeloTTS handles multilingual text preprocessing before GPT-SoVITS synthesis:

```python
from melo.api import TTS
import requests

# Step 1: Preprocess text with MeloTTS for phonemes
tts_model = TTS(language="EN", device="auto")
phonemes = tts_model.text_to_phone("Hello world")

# Step 2: Feed processed text to GPT-SoVITS
response = requests.post("http://localhost:9880/tts", json={
    "text": phonemes,
    "text_lang": "en",
    "ref_audio_path": "/path/to/ref.wav",
    "prompt_text": "Original prompt",
    "prompt_lang": "en"
})
```

### REST API Integration

The built-in `api_v2.py` provides a full REST API for production use:

```bash
# Start the API server
python api_v2.py -a 0.0.0.0 -p 9880

# Check API documentation at http://localhost:9880/docs
```

```python
# Python client example
import requests

def synthesize(text, ref_audio, prompt_text, output_path):
    payload = {
        "text": text,
        "text_lang": "en",
        "ref_audio_path": ref_audio,
        "prompt_text": prompt_text,
        "prompt_lang": "en",
        "top_k": 15,
        "top_p": 1.0,
        "temperature": 1.0,
        "speed_factor": 1.0,
        "media_type": "wav"
    }
    
    response = requests.post(
        "http://localhost:9880/tts",
        json=payload,
        timeout=60
    )
    
    if response.status_code == 200:
        with open(output_path, "wb") as f:
            f.write(response.content)
        return True
    return False

# Usage
synthesize(
    "Deploying voice cloning at production scale is now trivial.",
    "/voices/speaker_ref.wav",
    "This is the reference transcription.",
    "/output/cloned.wav"
)
```

### OpenAI-Compatible API Wrapper

```bash
# Use the community OpenAI-compatible wrapper
git clone https://github.com/enihsyou/GPT-SoVITS-2-OpenAI.git
cd GPT-SoVITS-2-OpenAI
cp .env.example .env
cp config.yaml.example config.yaml

# Set BACKEND_URL to your GPT-SoVITS API
# BACKEND_URL=http://host.docker.internal:9880

docker compose up -d
# Now serves at http://localhost:5000/v1/audio/speech
```

## Benchmarks / Real-World Use Cases

### Inference Speed Benchmarks

| Hardware | Version | RTF (Real-Time Factor) | 1400 Words Inference Time |
|----------|---------|----------------------|--------------------------|
| RTX 4090 | V2 ProPlus | 0.014 | 3.36s |
| RTX 4060 Ti | V2 ProPlus | 0.028 | ~7s |
| Apple M4 (CPU) | V2 ProPlus | 0.526 | ~120s |
| NVIDIA H200 (half) | V2 ProPlus | <0.01 | <2s |
| RTX 4090 | XTTS v2 | 0.18 | ~40s |
| RTX 4090 | Bark | 0.85 | ~200s |

RTF < 1 means faster than real-time generation. GPT-SoVITS V2 ProPlus on an RTX 4090 generates 4 minutes of speech in 3.36 seconds — **over 70x faster than real-time**.

### Voice Quality Benchmarks

| Model | MOS (Mean Opinion Score) | Training Data Required | Parameters |
|-------|------------------------|----------------------|------------|
| Human Speech | 4.5+ | N/A | N/A |
| GPT-SoVITS V4 | ~4.0 (estimated) | 5s zero-shot / 1min fine-tune | 407M total |
| XTTS v2 | 4.0 | 6s reference | 467M |
| Bark | 3.7 | Speaker prompt | 900M |
| F5-TTS | 4.1 | 5-15s reference | 336M |

### Production Use Cases

1. **Audiobook Platforms**: Clone narrator voices from 1-minute samples. Generate 10-hour audiobooks in under 30 minutes on a single GPU.

2. **Game Development**: Localize character voices into 5 languages using the same voice reference. Cross-lingual support preserves speaker identity across languages.

3. **Voice Agents**: Deploy real-time voice responses for customer service bots. The 0.014 RTF on consumer GPUs means sub-second latency for short responses.

4. **Accessibility Tools**: Generate screen-reader voices personalized to users. MIT license allows commercial deployment without restrictions.

5. **Content Creation**: Batch-produce voiceovers for video content. API integration enables pipeline automation with ffmpeg post-processing.

### Training Time Benchmarks

| Dataset Size | GPU | Steps | Training Time (SoVITS) | Training Time (GPT) |
|-------------|-----|-------|----------------------|-------------------|
| 1 minute | RTX 4090 | 300 | ~5 min | ~10 min |
| 5 minutes | RTX 4090 | 300 | ~8 min | ~15 min |
| 10 minutes | RTX 4090 | 300 | ~12 min | ~20 min |
| 1 minute | RTX 4060 Ti | 300 | ~12 min | ~25 min |

![GPT-SoVITS HuggingFace Demo Space showing the live inference interface for testing voice cloning online](https://huggingface.co/spaces/lj1995/GPT-SoVITS-pro/resolve/main/space-screenshot.png)

## Advanced Usage / Production Hardening

### GPU Memory Optimization

```bash
# Enable half-precision (fp16) for 50% VRAM reduction
export is_half=true

# For 6GB VRAM cards, use CPU offloading for text encoder
python webui.py --device cuda --half_precision --offload_text_encoder

# Use CPU inference version for low-VRAM setups
git clone https://github.com/baicai-1145/GPT-SoVITS-CPUFast.git
```

### Model Quantization for Edge Deployment

```python
# Export to ONNX for faster inference
python GPT_SoVITS/onnx_export.py \
    --gpt_model GPT_SoVITS/GPT_weights/your_model.ckpt \
    --sovits_model GPT_SoVITS/SoVITS_weights/your_model.pth \
    --output_dir ./onnx_models/

# TensorRT optimization for NVIDIA deployment
/usr/src/tensorrt/bin/trtexec \
    --onnx=./onnx_models/gpt_model.onnx \
    --saveEngine=./trt_models/gpt_model.trt \
    --fp16
```

### API Rate Limiting and Monitoring

```python
# api_v2.py production wrapper with rate limiting
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import asyncio
from collections import defaultdict
import time

app = FastAPI()
rate_limits = defaultdict(list)

@app.middleware("http")
async def rate_limit(request, call_next):
    client = request.client.host
    now = time.time()
    rate_limits[client] = [t for t in rate_limits[client] if now - t < 60]
    
    if len(rate_limits[client]) >= 10:  # 10 req/min
        raise HTTPException(429, "Rate limit exceeded")
    
    rate_limits[client].append(now)
    return await call_next(request)

# Add CORS for web clients
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com"],
    allow_methods=["POST"],
    allow_headers=["*"],
)
```

### Batch Processing Pipeline

```bash
#!/bin/bash
# batch_synthesize.sh — process text files in bulk

INPUT_DIR="./texts/"
REF_AUDIO="./references/narrator.wav"
REF_TEXT="The quick brown fox jumps over the lazy dog."
OUTPUT_DIR="./outputs/"
mkdir -p "$OUTPUT_DIR"

for txt_file in "$INPUT_DIR"/*.txt; do
    filename=$(basename "$txt_file" .txt)
    
    curl -X POST http://localhost:9880/tts \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": $(jq -Rs . < "$txt_file"),
            \"text_lang\": \"en\",
            \"ref_audio_path\": \"$REF_AUDIO\",
            \"prompt_text\": \"$REF_TEXT\",
            \"prompt_lang\": \"en\",
            \"media_type\": \"wav\"
        }" \
        --output "$OUTPUT_DIR/${filename}.wav"
    
    echo "Generated: $OUTPUT_DIR/${filename}.wav"
done
```

### Security Checklist for Production

1. **API Authentication**: The built-in API has no auth. Place behind an nginx reverse proxy with API key validation.
2. **Input Sanitization**: Validate `ref_audio_path` to prevent path traversal attacks.
3. **Resource Limits**: Set `ulimit` and Docker memory constraints to prevent OOM crashes.
4. **Model Access Control**: Store trained models in a separate volume with restricted permissions.
5. **HTTPS Termination**: Use a reverse proxy for TLS — never expose the API server directly to the internet.

```nginx
# nginx reverse proxy configuration
server {
    listen 443 ssl;
    server_name tts.yourdomain.com;
    
    ssl_certificate /etc/ssl/certs/tts.crt;
    ssl_certificate_key /etc/ssl/private/tts.key;
    
    location / {
        auth_request /auth;
        proxy_pass http://127.0.0.1:9880;
        proxy_set_header Host $host;
        client_max_body_size 50M;
    }
    
    location = /auth {
        internal;
        proxy_pass http://127.0.0.1:5000/verify;
        proxy_pass_request_body off;
    }
}
```

## Comparison with Alternatives

| Feature | GPT-SoVITS | Coqui XTTS v2 | Bark | F5-TTS |
|---------|-----------|--------------|------|--------|
| **License** | MIT (commercial OK) | CPML (non-commercial) | MIT (commercial OK) | CC-BY-NC 4.0 |
| **Stars** | 57,500+ | 4,200+ | 37,000+ | 10,800+ |
| **Parameters** | 407M (GPT+SoVITS) | 467M | 900M | 336M |
| **Zero-shot Cloning** | 5-second reference | 6-second reference | Speaker prompt | 5-15s reference |
| **Few-shot Fine-tuning** | 1 minute | 3-10 minutes | Not supported | Limited |
| **RTF (RTX 4090)** | **0.014** | 0.18 | 0.85 | 0.14 |
| **MOS Score** | ~4.0 | 4.0 | 3.7 | 4.1 |
| **Languages** | EN, JA, KO, ZH, Cantonese | 17 languages | ~20 languages | EN, ZH |
| **VRAM Required** | 6-8 GB | ~4 GB | ~6 GB | ~4 GB |
| **Cross-lingual** | Yes | Yes | Limited | Yes |
| **WebUI Tools** | Full pipeline (UVR5, ASR, slicing) | Minimal | None | Minimal |
| **Community Size** | Very large (96+ contributors) | Medium | Large | Growing |

**When to choose what:**
- **GPT-SoVITS**: Best overall package for voice cloning with minimal data. MIT license allows commercial use. Full WebUI toolchain included.
- **XTTS v2**: Good for quick prototyping, but CPML license blocks commercial deployment.
- **Bark**: Choose for creative audio (music, sound effects, laughter). Slower but more expressive range.
- **F5-TTS**: Strong academic results, but non-commercial license limits production use.

## Limitations / Honest Assessment

**What GPT-SoVITS is NOT good for:**

1. **Real-time streaming under 100ms**: The model requires processing reference audio through HuBERT and generating semantic tokens before vocoding. Sub-100ms streaming is not achievable on consumer hardware.

2. **Singing synthesis without RVC**: While GPT-SoVITS handles spoken text, high-quality singing voice cloning requires pairing with RVC or using specialized models like DiffSinger.

3. **Accurate word-level timing control**: Unlike some commercial TTS APIs, GPT-SoVITS does not expose SSML or phoneme-level timing controls for precise synchronization.

4. **GPU-less production inference**: CPU inference (RTF 0.526 on M4) is usable for prototyping but too slow for production workloads. A GPU is effectively required.

5. **Emotional range without data**: The base model captures moderate emotional variation, but dramatic emotional acting (whispering, shouting, crying) requires training data exhibiting those emotions.

6. **Windows path handling edge cases**: The codebase is Linux-first. Windows users occasionally hit path encoding issues with non-ASCII characters in file paths.

## Frequently Asked Questions

**Q1: How much training data do I actually need for decent voice cloning?**
For zero-shot inference (no training), a clean 5-second reference clip is sufficient. For personalized fine-tuning, 1 minute of diverse speech yields strong results. More data (5-10 minutes) improves consistency on longer generations but with diminishing returns.

**Q2: Can I use GPT-SoVITS commercially?**
Yes. GPT-SoVITS is released under the MIT license, which permits commercial use, modification, and distribution. However, note that some pretrained models (e.g., BigVGAN) may have their own license terms. Always verify the specific model weights you use.

**Q3: What is the best GPU for running GPT-SoVITS?**
The RTX 4060 Ti (8GB) is the sweet spot for most users — it runs inference at 0.028 RTF and handles fine-tuning with fp16. For production serving, RTX 4090 (0.014 RTF) or server GPUs like A100/H100 maximize throughput. Avoid cards with less than 6GB VRAM.

**Q4: How do I switch between model versions (V2, V3, V4)?**
Versions are selected via the WebUI dropdown or API configuration. To use a newer version, update the codebase with `git pull`, download the corresponding pretrained models from HuggingFace, and place them in `GPT_SoVITS/pretrained_models/`. The `tts_infer.yaml` file controls version selection.

**Q5: Why does my generated voice sound metallic or muffled?**
This was a known issue in V3 caused by non-integer multiple upsampling. Upgrade to V4, which fixes metallic artifacts and outputs native 48kHz audio. Also verify your reference audio is clean — background noise and compression artifacts propagate to the output.

**Q6: How do I deploy GPT-SoVITS behind a load balancer?**
Run multiple API instances behind nginx or HAProxy. Each instance should bind to a different port. Use a shared network volume for models. For auto-scaling, containerize with Kubernetes and use GPU node pools.

**Q7: Can I run GPT-SoVITS without Docker?**
Yes. The Conda installation path is fully supported. Ensure FFmpeg is installed and all Python dependencies from `requirements.txt` are satisfied. The WebUI and API work identically outside Docker.

## Conclusion

GPT-SoVITS delivers production-grade voice cloning with minimal data requirements, MIT licensing, and a mature deployment ecosystem. The 0.014 RTF on consumer GPUs makes real-time applications viable, while the full WebUI toolchain lowers the barrier for beginners. For teams building voice products in 2026, this is the most practical open-source foundation available.

**Action items to deploy today:**
1. Clone `https://github.com/RVC-Boss/GPT-SoVITS` and run the Docker setup
2. Download a pretrained model (start with V2 ProPlus for best speed)
3. Record a 5-second reference clip and test zero-shot inference via the WebUI
4. Wrap the `api_v2.py` endpoint with your authentication layer
5. Join the [dibi8.com Telegram group](https://t.me/dibi8tech) for deployment support and community discussion



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [GPT-SoVITS GitHub Repository](https://github.com/RVC-Boss/GPT-SoVITS)
- [GPT-SoVITS Docker Hub Images](https://hub.docker.com/r/xxxxrt666/gpt-sovits)
- [GPT-SoVITS HuggingFace Demo](https://lj1995-gpt-sovits-proplus.hf.space/)
- [GPT-SoVITS User Guide (English)](https://rentry.co/GPT-SoVITS-guide#/)
- [Coqui XTTS v2 Repository](https://github.com/coqui-ai/TTS)
- [Bark (Suno) Repository](https://github.com/suno-ai/bark)
- [F5-TTS Repository](https://github.com/SWivid/F5-TTS)
- [Open Source TTS Comparison Guide](https://www.codesota.com/guides/tts-models)
- [GPT-SoVITS DeepWiki Architecture Guide](https://deepwiki.com/RVC-Boss/GPT-SoVITS)
- [GPT-SoVITS v3 Technical Paper Reference](https://arxiv.org/pdf/2504.19146)
