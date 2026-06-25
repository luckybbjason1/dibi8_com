---
  title: 'VoiceBox: The Open-Source AI Voice Studio for Cloning, Dictation, and Generation'
  description: 'A full-stack open-source AI voice studio that lets you clone any voice, generate speech, and dictate into any app. 33K stars. Runs locally on your machine with CUDA or Apple Silicon support.'
  date: 2026-06-25
  lastmod: 2026-06-25
  draft: false
  lang: en
  github_repo: https://github.com/voicebox-ai/voicebox
  category: ai-tools
  tags: ['ai', 'voice-ai', 'voice-clone', 'speech-to-text', 'text-to-speech', 'whisper', 'qwen3-tts', 'cuda', 'mlx']
  slug: voicebox-open-source-ai-voice-studio
  featureImage: /images/articles/voicebox-open-source-ai-voice-studio-for-cloning-dictation-and-generation.png
  license: MIT
---



# VoiceBox: The Open-Source AI Voice Studio

**VoiceBox** is a comprehensive, open-source AI voice studio that enables voice cloning, speech generation, and dictation — all running locally on your machine. With **33,745 GitHub stars** and an active development community, it has become the go-to solution for developers, content creators, and privacy-conscious users who need powerful voice AI without relying on cloud APIs.

This article covers installation, voice cloning, dictation mode, API usage, hardware requirements, and practical applications.

## TL;DR

VoiceBox provides a complete voice AI stack running entirely on your hardware. It supports voice cloning from as little as 3 seconds of audio, real-time dictation into any application, and high-quality text-to-speech generation. With support for both NVIDIA CUDA and Apple Silicon (MLX), it adapts to your hardware while maintaining privacy — your voice data never leaves your machine.

## What Is VoiceBox?

VoiceBox is a self-hosted voice AI platform that combines several cutting-edge technologies into a single, unified interface. Unlike commercial voice services that require uploading your audio to the cloud, VoiceBox processes everything locally, giving you complete control over your voice data.

The platform supports three primary modes of operation:

- **Voice Cloning**: Record or upload a short audio sample and create a digital voice model that can generate speech in that voice
- **Dictation**: Use your microphone to dictate text into any application on your system, with real-time transcription
- **Text-to-Speech**: Generate natural-sounding speech from text using cloned voices or built-in voice models

Built on top of modern open-source models including Qwen3-TTS, Whisper, and various voice cloning architectures, VoiceBox provides enterprise-grade voice AI capabilities at zero cost.

## Installation Guide

### Prerequisites

VoiceBox supports multiple hardware configurations:

**GPU Accelerated (Recommended):**
- NVIDIA GPU with 8GB+ VRAM (RTX 3060 or better)
- CUDA 12.x toolkit installed
- 16GB system RAM
- Linux (Ubuntu 22.04+) or Windows 11

**Apple Silicon:**
- M1/M2/M3 chip with 16GB+ unified memory
- macOS 14+ (Sonoma or newer)
- MLX framework installed

**CPU-Only (Slower but functional):**
- 16GB+ system RAM
- 8+ CPU cores
- Any modern operating system

### Option 1: Quick Install with Pip

```bash
# Install VoiceBox from PyPI
pip install voicebox-ai

# Verify installation
voicebox --version

# Initialize the application
voicebox init --model qwen3-tts
```

### Option 2: From Source (Latest Features)

```bash
# Clone the repository
git clone https://github.com/jamiepine/voicebox.git
cd voicebox

# Create a virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Install the package in development mode
pip install -e .

# Download the default voice models
voicebox download-models --all
```

### Option 3: Docker Deployment

```bash
# Pull the official image
docker pull jamiepine/voicebox:latest

# Run with GPU support (NVIDIA)
docker run -d \
  --name voicebox \
  --gpus all \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest

# Run on Apple Silicon (no GPU flag needed)
docker run -d \
  --name voicebox \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest
```

### Option 4: Windows Installation

```powershell
# Install Python 3.11+ from microsoft store
# Then install VoiceBox
pip install voicebox-ai

# For GPU acceleration, install CUDA toolkit
# Download from: https://developer.nvidia.com/cuda-downloads

# Initialize VoiceBox
voicebox init --gpu cuda
```

## Voice Cloning

### Recording a Voice Sample

To clone a voice, you need at least 3 seconds of clear audio. For best results, provide 30-60 seconds of speech:

```bash
# Record audio using the built-in recorder
voicebox record --output sample.wav --duration 30

# Or upload an existing audio file
voicebox clone --audio my_voice_sample.mp3 --name "my-voice"

# VoiceBox automatically processes the audio and extracts voice characteristics
```

### Voice Processing Pipeline

The voice cloning pipeline consists of several stages:

```python
from voicebox.engine import VoiceCloner
from voicebox.audio import AudioProcessor

# Initialize the cloner
cloner = VoiceCloner(model="qwen3-tts-voice-clone")

# Load and preprocess the reference audio
processor = AudioProcessor()
reference = processor.load_audio("sample.wav")
reference = processor.normalize(reference, target_rms=-20)
reference = processor.remove_noise(reference, method="spectral")

# Extract voice embeddings
embeddings = cloner.extract_embeddings(reference)

# Create the voice model
voice_model = cloner.create_voice(
    embeddings=embeddings,
    name="my-voice",
    quality="high"
)

# Test the cloned voice
output = voice_model.synthesize(
    text="Hello, this is my cloned voice speaking.",
    speed=1.0,
    emotion="neutral"
)
voice_model.save(output, "test_output.wav")
```

### Advanced Voice Parameters

VoiceBox exposes fine-grained control over voice synthesis:

```bash
# Control speech rate
voicebox synthesize --input script.txt --output speech.wav --speed 0.8

# Add emotional inflection
voicebox synthesize --input script.txt --output emotional.wav --emotion happy

# Adjust pitch
voicebox synthesize --input script.txt --output pitched.wav --pitch +200

# Combine multiple parameters
voicebox synthesize \
  --input script.txt \
  --output natural.wav \
  --speed 1.1 \
  --pitch +100 \
  --emotion confident \
  --clarity high
```

### Multi-Voice Support

You can create and manage multiple voice clones simultaneously:

```python
from voicebox.engine import VoiceManager

manager = VoiceManager()

# List all cloned voices
voices = manager.list_voices()
for v in voices:
    print(f"{v.name}: {v.quality} ({v.duration}s of training data)")

# Switch between voices
manager.set_active_voice("my-voice")
output = manager.synthesize("Hello from my cloned voice!")

# Blend two voices for hybrid speech
hybrid = manager.blend_voices(
    voice_a="my-voice",
    voice_b="partner-voice",
    weight_a=0.7,
    weight_b=0.3
)
output = hybrid.synthesize("Blended voice output")
```

## Dictation Mode

VoiceBox's dictation mode provides real-time speech-to-text transcription that works with any application on your system.

### System-Wide Dictation Setup

```bash
# Enable system-wide dictation
voicebox dictation --enable

# Choose the recognition model
voicebox dictation --model whisper-large-v3

# Set the output language
voicebox dictation --language en

# Configure hotkey
voicebox dictation --hotkey "ctrl+space"
```

### Dictation API Usage

```python
from voicebox.dictation import DictationEngine

# Initialize the dictation engine
engine = DictationEngine(
    model="whisper-large-v3",
    language="auto",
    beam_size=5,
    vad_threshold=0.5
)

# Start listening
engine.start_listening(
    hotkey="ctrl+shift+d",
    output_mode="clipboard",
    append_mode=True
)

# Process a dictation session
result = await engine.listen_session(
    timeout=300,           # 5 minute session
    silence_threshold=1.5, # Stop after 1.5s of silence
    language="en"
)

print(f"Transcribed: {result.text}")
print(f"Confidence: {result.confidence:.2%}")
print(f"Words: {result.word_count}")
```

### Multi-Language Dictation

VoiceBox supports simultaneous multi-language dictation with automatic language detection:

```bash
# Enable auto-detection
voicebox dictation --auto-detect

# Specify supported languages
voicebox dictation --languages en,zh,ko,ja,es,fr,de

# Set primary language (for better accuracy)
voicebox dictation --primary-language en
```

## Text-to-Speech API

VoiceBox exposes a full REST API for programmatic text-to-speech generation:

### Basic TTS

```bash
# Simple text-to-speech conversion
curl -X POST "https://your-voicebox/api/v1/tts" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "Hello, this is a test of VoiceBox text-to-speech.",
    "voice": "default",
    "speed": 1.0,
    "output_format": "wav"
  }' \
  --output speech.wav
```

### Streaming TTS

For real-time audio streaming applications:

```bash
# Stream audio in chunks
curl -N -X POST "https://your-voicebox/api/v1/tts/stream" \
  -H "Content-Type: application/json" \
  -d '{"text": "This audio will stream in real-time...", "voice": "cloned-voice"}' \
  --output - | aplay
```

### Batch Processing

Process multiple texts simultaneously:

```python
from voicebox.api import VoiceBoxClient

client = VoiceBoxClient("https://your-voicebox")

texts = [
    "First sentence for processing.",
    "Second sentence with different content.",
    "Third sentence in another voice.",
]

results = await client.tts.batch(
    texts=texts,
    voice="default",
    output_format="mp3",
    parallel_workers=4
)

for i, result in enumerate(results):
    print(f"Generated: speech_{i}.mp3 ({result.duration:.1f}s)")
```

## Hardware Requirements and Performance

### GPU Performance Benchmarks

| Hardware | Model | Cloning Time | TTS Speed | Dictation Latency |
|
Join the community: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

Internal links: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/en/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/en/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**Disclosure**: This article mentions tools that may have affiliate relationships. We do not accept payment for reviews. All opinions are our own.
