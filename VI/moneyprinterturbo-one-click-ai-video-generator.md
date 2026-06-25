---
title: 'MoneyPrinterTurbo: Trình Tạo Video AI Chỉ Với Một Nhấp Chuột với Hơn 90K Sao'
description: 'Đưa cho MoneyPrinterTurbo một chủ đề video hoặc từ khóa và nó tự động tạo kịch bản, video có sẵn, phụ đề, nhạc nền và video ngắn HD. Hỗ trợ TikTok, YouTube Shorts, Instagram Reels. Hơn 90.000 sao trên GitHub.'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'Video Generation', 'Short Videos', 'Automation', 'Self-Hosted', 'Docker']
categories: ['ai-tools']
slug: moneyprinterturbo-one-click-ai-video-generator
featureImage: 'https://images.pexels.com/photos/3184291/pexels-photo-3184291.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'
aliases: ['/moneyprinterturbo']
sources:
  - name: 'GitHub'
    url: 'https://github.com/harry0703/MoneyPrinterTurbo'
  - name: 'Demo Videos'
    url: 'https://github.com/harry0703/MoneyPrinterTurbo#video-demo'
lang: vi
---
title: 'MoneyPrinterTurbo: One-Click AI Video Generator with 90K+ Stars'
description: 'Give MoneyPrinterTurbo a video topic or keyword and it auto-generates scripts, stock footage, subtitles, background music, and HD short videos. Supports TikTok, YouTube Shorts, Instagram Reels. 90K+ GitHub stars.'
date: 2026-06-22
lastmod: 2026-06-22
draft: false
tags: ['AI Tools', 'Video Generation', 'Short Videos', 'Automation', 'Self-Hosted', 'Docker']
categories: ['ai-tools']
slug: moneyprinterturbo-one-click-ai-video-generator

aliases: ['/moneyprinterturbo']
sources:
  - name: 'GitHub'
    url: 'https://github.com/harry0703/MoneyPrinterTurbo'
  - name: 'Demo Videos'
    url: 'https://github.com/harry0703/MoneyPrinterTurbo#video-demo'
---

# MoneyPrinterTurbo: One-Click AI Video Generator with 90K+ Stars

TL;DR — **MoneyPrinterTurbo** is an open-source Python tool that turns a video topic or keyword into a complete HD short video — auto-generating the script, sourcing copyright-free stock footage, creating subtitles, adding background music, and composing everything into a vertical 9:16 or horizontal 16:9 video. With 90,000+ GitHub stars, it supports dozens of LLM providers, multiple TTS engines, and one-click publishing to TikTok, YouTube Shorts, and Instagram Reels.

## What Is MoneyPrinterTurbo?

MoneyPrinterTurbo takes a single input — a **video topic** or **keyword** — and produces a finished short video in minutes. The pipeline is fully automated:

1. **Script generation** — AI writes a compelling video script in Chinese or English
2. **Stock footage sourcing** — Downloads copyright-free clips from Pexels, Pixabay, and Coverr
3. **Voice synthesis** — Generates narration using Edge TTS (free) or Azure TTS V2 (premium)
4. **Subtitle creation** — Produces synchronized subtitles with customizable fonts, colors, and positions
5. **Background music** — Adds royalty-free background music with adjustable volume
6. **Video composition** — Uses MoviePy 2.x to stitch everything together into HD video

The result is a production-ready short video suitable for TikTok, YouTube Shorts, Instagram Reels, or any social platform.

**GitHub:** [harry0703/MoneyPrinterTurbo](https://github.com/harry0703/MoneyPrinterTurbo) · **Stars:** 90,884+ · **License:** MIT · **Language:** Python

## Key Features

- **MVC Architecture** — Clean code structure with both API and Web UI interfaces
- **AI Script Generation** — Auto-generate video scripts or use custom ones
- **Multiple HD Sizes** — Portrait 9:16 (1080x1920) and Landscape 16:9 (1920x1080)
- **Batch Generation** — Generate multiple videos at once and pick the best one
- **Multi-Language Support** — Chinese and English video scripts
- **Multiple Voice Options** — Real-time voice preview with Edge TTS and Azure TTS V2
- **Customizable Subtitles** — Adjust font, position, color, size, and stroke
- **Background Music** — Random or specified music files with volume control
- **HD Copyright-Free Footage** — Sourced from Pexels, Pixabay, and Coverr
- **Cross-Platform Publishing** — Auto-upload to TikTok, Instagram, and YouTube Shorts via Upload-Post
- **16+ LLM Providers** — OpenAI, Google Gemini, Anthropic, Ollama, DeepSeek, and more

## Supported LLM Providers

MoneyPrinterTurbo integrates with a wide range of language models for script generation:

| Provider | Models | Cost |
|----------|--------|------|
| OpenAI | GPT-4, GPT-4o, GPT-3.5 | Paid |
| Google Gemini | Gemini Pro, Gemini 1.5 | Freemium |
| Anthropic | Claude Sonnet, Haiku | Paid |
| Ollama | Local Llama, Mistral, Qwen | Free |
| DeepSeek | DeepSeek V3, V4 | Freemium |
| Moonshot | Kimi series | Paid |
| Azure OpenAI | GPT-4, GPT-3.5 | Paid |
| Zhipu AI | GLM-4 | Freemium |
| Bailian (Alibaba) | Qwen series | Freemium |
| MiniMax | MiniMax-01 | Freemium |
| Wenxin Yiyan (Baidu) | ERNIE Bot | Paid |
| Pollinations | Various open models | Free |
| ModelScope | Chinese models | Freemium |
| AIHubMix | 700+ models aggregated | Freemium |
| GPT4Free | Unofficial endpoints | Free |
| One-API | China proxy gateway | Paid |

## Supported TTS Engines

| Engine | Quality | Cost | Voices |
|--------|---------|------|--------|
| Edge TTS (V1) | Good | Free | 100+ |
| Azure TTS V2 | Excellent | Paid | 50+ neural |
| OpenAI TTS | Very Good | Paid | 6 voices |
| Fish Audio | Good | Freemium | Custom |

Edge TTS is the default and requires no API key. For higher quality voices, configure Azure Speech Services credentials.

## Installation Methods

### Method 1: Docker (Recommended for Isolation)

```bash
git clone https://github.com/harry0703/MoneyPrinterTurbo.git
cd MoneyPrinterTurbo

# Copy config example
cp config.example.toml config.toml

# Edit config.toml with your API keys
# Then start with release image
docker compose -f docker-compose.release.yml up
```

Access the Web UI at `http://127.0.0.1:8501` and the API docs at `http://127.0.0.1:8080/docs`.

### Method 2: uv (Recommended for Local Python)

```bash
git clone https://github.com/harry0703/MoneyPrinterTurbo.git
cd MoneyPrinterTurbo

# Install Python 3.11 and dependencies
uv python install 3.11
uv sync --frozen

# Start Web UI
uv run streamlit run ./webui/Main.py --browser.gatherUsageStats=False --server.showEmailPrompt=False

# Or start API service
uv run python main.py
```

### Method 3: Traditional pip

```bash
git clone https://github.com/harry0703/MoneyPrinterTurbo.git
cd MoneyPrinterTurbo

python3.11 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Start Web UI
python webui/Main.py
```

### Method 4: Windows One-Click Package

1. Download the latest release from [GitHub Releases](https://github.com/harry0703/MoneyPrinterTurbo/releases/latest)
2. Extract (avoid Chinese characters or special characters in path)
3. Run `update.bat` to get the latest code
4. Run `start.bat` to launch

### Method 5: Google Colab

No local setup required. Click the badge below to run MoneyPrinterTurbo directly in Google Colab:

[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/harry0703/MoneyPrinterTurbo/blob/main/docs/MoneyPrinterTurbo.ipynb)

## Configuration

After cloning, copy `config.example.toml` to `config.toml` and configure your settings:

```toml
[app]
# Video output settings
video_width = 1080
video_height = 1920  # 9:16 portrait mode
fps = 30

# Subtitle settings
subtitle_enabled = true
subtitle_font = "Arial"
subtitle_color = "white"

[basic_tts]
# Edge TTS is free, no API key needed
provider = "edge-tts"
voice_name = "en-US-GuyNeural"

[azure]
# Optional: for Azure TTS V2 premium voices
speech_key = "your-azure-speech-key"
speech_region = "eastus"

[llm]
# Choose your LLM provider
provider = "openai"  # or gemini, ollama, deepseek, etc.
api_key = "your-api-key"
model = "gpt-4o"

[pexels]
# Stock footage sources (free API keys)
api_keys = ["your-pexels-api-key"]

[pixabay]
api_keys = ["your-pixabay-api-key"]

[coverr]
# Alternative stock footage
api_keys = ["your-coverr-api-key"]
```

## Usage Examples

### Web UI

Launch the Streamlit web interface and enter a video topic:

```bash
uv run streamlit run ./webui/Main.py
```

Open `http://localhost:8501` in your browser. Enter a topic like "The importance of exercise" and the tool will:

1. Generate a script using your configured LLM
2. Search for relevant stock footage
3. Create voiceover narration
4. Generate synchronized subtitles
5. Assemble everything into a finished video

### Command Line Interface

For headless operation or automation:

```bash
# Generate video from a topic
uv run python cli.py --video-subject "The importance of exercise"

# Specify local video materials
uv run python cli.py \
  --video-subject "Exercise benefits" \
  --video-source local \
  --video-materials "clip1.mp4,clip2.mp4" \
  --stop-at video

# Generate only the script (for review)
uv run python cli.py \
  --video-subject "Healthy eating" \
  --stop-at script

# Generate script and voiceover only
uv run python cli.py \
  --video-subject "Healthy eating" \
  --stop-at audio
```

### API Endpoint

MoneyPrinterTurbo exposes a REST API for programmatic access:

```bash
# Start the API service
uv run python main.py

# Then access Swagger docs at http://localhost:8080/docs
```

## Subtitle Generation

Two subtitle generation modes are available:

### Edge Mode (Fast)
- Uses Edge TTS timing stamps
- Fast, no GPU required
- Works on any machine
- Occasionally inaccurate timestamps for complex sentences

### Whisper Mode (Accurate)
- Uses local `faster-whisper` for audio transcription
- More granular timestamps
- Requires downloading model files (~250MB for turbo, ~3GB for large-v3)
- Better subtitle accuracy overall

Switch modes in `config.toml`:

```toml
[subtitle]
provider = "edge"  # or "whisper"
```

For Whisper mode, download the model from HuggingFace. If you're in China and can't access HuggingFace directly:

- **Baidu Pan:** https://pan.baidu.com/s/11h3Q6tsDtjQKTjUu3sc5cA?pwd=xjs9
- **Quark Pan:** https://pan.quark.cn/s/3ee3d991d64b

Extract and place in `MoneyPrinterTurbo/models/whisper-large-v3/`:

```
MoneyPrinterTurbo/
  models/
    whisper-large-v3/
      config.json
      model.bin
      preprocessor_config.json
      tokenizer.json
      vocabulary.json
```

## Cross-Platform Publishing

MoneyPrinterTurbo can automatically publish generated videos to social platforms via [Upload-Post](https://upload-post.com):

```toml
[upload]
enabled = true
platforms = ["tiktok", "youtube_shorts", "instagram_reels"]
youtube_privacy_status = "private"  # or "public", "unlisted"
```

YouTube publishing automatically marks AI-generated content as required by platform policies.

## System Requirements

| Component | Minimum | Recommended | Ideal |
|-----------|---------|-------------|-------|
| CPU | 4 cores | 6-8 cores | 8+ cores |
| RAM | 4 GB | 8 GB | 16+ GB |
| GPU | Not required | 4 GB VRAM | 8 GB VRAM |
| Disk | 2 GB | 5 GB | 10 GB |

GPU is optional but helps with:
- Local Whisper transcription
- Faster video processing
- Smoother batch generation

If you rely mainly on cloud LLMs, cloud TTS, and online footage sources, CPU and RAM matter more than GPU.

## Troubleshooting

### No ffmpeg Found

```
RuntimeError: No ffmpeg exe could be found.
```

Download ffmpeg from https://www.gyan.dev/ffmpeg/builds/ and set the path:

```toml
[app]
ffmpeg_path = "C:\\Users\\YourName\\Downloads\\ffmpeg.exe"
```

### Too Many Open Files

```
OSError: [Errno 24] Too many open files
```

Increase the limit:

```bash
ulimit -n 10240
```

### Whisper Model Download Failure

If you see `LocalEntryNotFoundError`, download the model manually (see Subtitle Generation section above).

### ImageMagick Errors

The current version no longer requires ImageMagick — it uses Pillow for subtitle rendering after upgrading to MoviePy 2.x. If you still see errors, update your code:

```bash
git pull
# Windows: run update.bat
```

## Architecture Overview

```
┌──────────────────────────────────────────────────────┐
│                   MoneyPrinterTurbo                    │
├──────────────────────────────────────────────────────┤
│  Web UI (Streamlit)    │    API (FastAPI)             │
├────────────────────────┼──────────────────────────────┤
│  Script Generator      │  ← LLM (OpenAI/Gemini/Ollama)│
│  Stock Footage Fetcher │  ← Pexels/Pixabay/Coverr     │
│  TTS Engine            │  ← Edge/Azure/OpenAI         │
│  Subtitle Generator    │  ← Edge/Whisper              │
│  Music Mixer           │  ← Local resource files      │
│  Video Composer        │  ← MoviePy 2.x               │
│  Publisher             │  ← Upload-Post API           │
└────────────────────────┴──────────────────────────────┘
```

## Who Should Use MoneyPrinterTurbo?

- **Content creators** who want to produce videos at scale without filming themselves
- **Social media managers** who need consistent video output for TikTok, Reels, and Shorts
- **Educators** creating explainer videos from topics
- **Marketers** producing promotional content quickly
- **Developers** who want to integrate AI video generation into their own apps via the REST API

## Alternatives Compared

| Feature | MoneyPrinterTurbo | InVideo AI | Pictory | Fliki |
|---------|------------------|------------|---------|-------|
| Open source | ✅ MIT | ❌ Proprietary | ❌ SaaS | ❌ SaaS |
| Self-hosted | ✅ Docker/Local | ❌ Cloud only | ❌ Cloud only | ❌ Cloud only |
| Free tier | ✅ Fully free | ❌ Watermark | ❌ Trial only | ❌ Limited |
| LLM flexibility | ✅ 16+ providers | ❌ Fixed | ❌ Fixed | ❌ Fixed |
| TTS options | ✅ Edge/Azure/OpenAI | ❌ Fixed | ❌ Fixed | ✅ Limited |
| Stock footage | ✅ 3 sources | ✅ Proprietary | ✅ Proprietary | ✅ Limited |
| Custom subtitles | ✅ Full control | ❌ Auto only | ❌ Auto only | ❌ Auto only |
| API access | ✅ FastAPI | ❌ No | ❌ No | ❌ No |
| Batch generation | ✅ Yes | ❌ No | ❌ No | ❌ No |

## Getting Started Checklist

1. Clone the repository: `git clone https://github.com/harry0703/MoneyPrinterTurbo.git`
2. Copy config: `cp config.example.toml config.toml`
3. Add your API keys (at minimum, a Pexels API key for footage)
4. Choose your LLM provider (Ollama for free local, or OpenAI for best quality)
5. Start Docker: `docker compose -f docker-compose.release.yml up`
6. Open Web UI at http://localhost:8501
7. Enter a video topic and watch it generate a complete video
8. Review, tweak, and regenerate if needed

## Frequently Asked Questions

### Q: Do I need API keys for everything?

No. Edge TTS is completely free and requires no key. For stock footage, Pexels and Pixabay offer free API keys. The LLM provider is optional — you can use local Ollama models for free, or skip script generation and use custom scripts.

### Q: Can I use my own video素材 (materials)?

Yes. Set `video_source` to `local` and provide a comma-separated list of video file paths. The tool will use your local files instead of fetching from stock sources.

### Q: How long does video generation take?

Typically 2-10 minutes depending on video length, LLM response time, and whether Whisper transcription is enabled. Docker deployment tends to be faster than local Python installs due to optimized dependencies.

### Q: Can I generate videos in languages other than Chinese and English?

The default script generation supports Chinese and English. For other languages, you can write custom scripts and use the appropriate TTS voice. The stock footage and music are language-agnostic.

### Q: Does it work on Raspberry Pi?

Yes, though slowly. The Docker image supports ARM64. For best results on Pi, use Edge TTS (no heavy model downloads) and skip Whisper subtitle generation.

### Q: How do I change the output aspect ratio?

Edit `config.toml`:

```toml
[app]
video_width = 1080
video_height = 1920  # 9:16 portrait (TikTok/Shorts)
# OR
video_width = 1920
video_height = 1080  # 16:9 landscape (YouTube)
```

## Sources

- [MoneyPrinterTurbo on GitHub](https://github.com/harry0703/MoneyPrinterTurbo)
- [Demo Videos](https://github.com/harry0703/MoneyPrinterTurbo#video-demo)
- [Configuration Example](https://github.com/harry0703/MoneyPrinterTurbo/blob/main/config.example.toml)
- [Upload-Post Cross-Platform Publishing](https://upload-post.com)

---

**Want to generate videos at scale?** MoneyPrinterTurbo is free, open-source, and runs on any machine with Python or Docker.

**Join the Dibi8 community:** [Telegram Group](https://t.me/DIBI8_Group/2)
