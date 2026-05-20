---
title: 'VoiceCraft: 8.5K+ Stars — Zero-Shot Speech Editing vs GPT-SoVITS, XTTS in 2026'
description: 'VoiceCraft is a token infilling neural codec language model for zero-shot speech editing and TTS. Compatible with GPT-SoVITS, Coqui TTS, and RVC. Covers setup, benchmarks, Docker deployment, and comparison tables.'
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
github_repo: 'https://github.com/jasonppy/VoiceCraft'
stars: 8500
maintainer: 'jasonppy'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['voicecraft', 'zero-shot-tts', 'speech-editing', 'neural-codec', 'voice-cloning', 'ai-audio', 'docker', 'python']
aliases:
- /posts/voicecraft/
---

{{</* resource-info */>}}

## Introduction

Editing spoken audio used to mean re-recording the entire take in a studio. If a podcaster stumbled over one word or an audiobook narrator mispronounced a name, the fix involved booking another session, setting up the microphone, and matching the original tone. That workflow is expensive and slow. In 2024, a research team from UT Austin and Meta FAIR published **VoiceCraft**, a neural codec language model that edits speech and clones voices from just a few seconds of reference audio. The repository now sits at **8,500+ GitHub stars** with 796 forks, and the paper was accepted at ACL 2024. This guide walks through the VoiceCraft setup, compares it against GPT-SoVITS, XTTS v2, and Coqui TTS, and shows production deployment patterns with Docker.

## What Is VoiceCraft?

VoiceCraft is a **token infilling neural codec language model** that performs two core tasks: (1) zero-shot text-to-speech (TTS) voice cloning and (2) speech editing within existing recordings. Unlike traditional TTS pipelines that require hours of training data per speaker, VoiceCraft needs only 3-5 seconds of reference audio to reproduce a voice with high fidelity. It is built on a Transformer decoder architecture and introduces a novel token rearrangement procedure combining causal masking with delayed stacking, enabling autoregressive generation conditioned on bidirectional context.

![VoiceCraft overview](https://raw.githubusercontent.com/jasonppy/VoiceCraft/main/assets/overview.png)
*Figure 1: VoiceCraft architecture overview — token infilling with causal masking and delayed stacking for speech editing and TTS.*

## How VoiceCraft Works

### Architecture Overview

The model pipeline follows three stages:

1. **Encodec Quantization**: Raw audio waveforms are quantized into discrete tokens using Meta's EnCodec neural codec. Each audio frame is represented as a vector of K codebook indices (residual vector quantization, RVQ).

2. **Token Rearrangement**: This is VoiceCraft's core innovation. A two-step procedure transforms the editing/infilling problem into a standard left-to-right language modeling task:
   - **Causal Masking**: Random spans of tokens are masked and moved to the end of the sequence, allowing the model to attend to bidirectional context during autoregressive generation.
   - **Delayed Stacking**: Vectors are shifted diagonally so that predicting codebook k at time t conditions on codebook k-1, enabling efficient multi-codebook modeling.

3. **Transformer Decoder**: The rearranged token sequence is modeled autoregressively by a Transformer decoder. Text phonemes and speech tokens are concatenated as conditioning input.

### Model Variants

| Model | Parameters | Best For | Max Duration |
|-------|-----------|----------|-------------|
| giga330M | 330M | Balanced quality/speed | 16 seconds |
| giga830M | 830M | Highest quality | 30+ seconds |
| giga330M-TTS-Enhanced | 330M | TTS-specific fine-tune | 16 seconds |

### The RealEdit Dataset

VoiceCraft introduced **RealEdit**, a benchmark dataset of 310 real-world speech editing examples sourced from audiobooks, YouTube videos, and Spotify podcasts. Unlike clean lab datasets (LibriTTS, VCTK), RealEdit contains diverse accents, background noise, music, and speaking styles — making it a practical measure of speech editing quality.

![VoiceCraft speech editing diagram](https://jasonppy.github.io/VoiceCraft_web/static/editing_figure.png)
*Figure 2: VoiceCraft speech editing workflow — original audio, target transcript, and synthesized edited output.*

## Installation & Setup

### Option 1: Docker (Recommended)

Docker is the fastest path to a working VoiceCraft environment. The official Dockerfile handles all dependencies including EnCodec, Montreal Forced Aligner (MFA), and CUDA bindings.

```bash
# 1. Clone the repository
git clone https://github.com/jasonppy/VoiceCraft.git
cd VoiceCraft

# 2. Build the Docker image
docker build --tag "voicecraft" .

# 3. Start the container (Linux)
./start-jupyter.sh
# Or on Windows:
# start-jupyter.bat

# 4. Access Jupyter — copy the URL from logs
docker logs jupyter | grep "127.0.0.1:8888"

# 5. Verify GPU access inside the container
docker exec -it jupyter nvidia-smi
```

The container exposes Jupyter Lab on port 8888 and Gradio UI on port 7860. Open `inference_tts.ipynb` or `inference_speech_editing.ipynb` to run inference.

### Option 2: Conda Environment (Local Development)

For model development and fine-tuning, a local Conda environment provides more flexibility.

```bash
# Create and activate the environment
conda create -n voicecraft python=3.9.16
conda activate voicecraft

# Install PyTorch with CUDA 11.7
pip install torch==2.0.1 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu117

# Install audiocraft (EnCodec dependency)
pip install -e git+https://github.com/facebookresearch/audiocraft.git@c5157b5bf14bf83449c17ea1eeb66c19fb4bc7f0#egg=audiocraft

# Install xformers for memory-efficient attention
pip install xformers==0.0.22

# Core dependencies
pip install tensorboard==2.16.2
pip install phonemizer==3.2.1
pip install datasets==2.16.0
pip install torchmetrics==0.11.1
pip install huggingface_hub==0.22.2

# System dependencies
apt-get install -y ffmpeg espeak-ng

# Install Montreal Forced Aligner (MFA) for text-audio alignment
conda install -c conda-forge montreal-forced-aligner=2.2.17 openfst=1.8.2 kaldi=5.5.1068

# Download MFA English models
mfa model download dictionary english_us_arpa
mfa model download acoustic english_us_arpa

# Jupyter kernel (optional)
conda install -n voicecraft ipykernel --no-deps --force-reinstall
```

### Option 3: Gradio Local UI

For a browser-based interface without notebooks:

```bash
# Additional system dependencies for Gradio
apt-get install -y espeak espeak-data libespeak1 libespeak-dev
apt-get install -y festival build-essential flac libasound2-dev libsndfile1-dev

# Install Gradio requirements
pip install -r gradio_requirements.txt

# Launch the Gradio server
python gradio_app.py
```

Navigate to `http://127.0.0.1:7860` to access the web UI.

### Hardware Requirements

| Configuration | Minimum GPU | Recommended GPU | RAM |
|-------------|------------|----------------|-----|
| Full inference (830M) | 8 GB with kvcache | 32 GB VRAM | 32 GB |
| Fast inference (330M) | 8 GB | 16 GB VRAM | 16 GB |
| Gradio UI | 8 GB | 16 GB VRAM | 16 GB |

The `kvcache` optimization trades a small amount of quality for significant memory reduction, enabling 8 GB GPUs to run inference.

## Integration with Popular Tools

### VoiceCraft + Gradio Web UI

The built-in Gradio interface provides the easiest way to experiment:

```bash
# Launch the Gradio app with default settings
python gradio_app.py --model-name "giga330M" --device "cuda"

# With custom model path
python gradio_app.py   --model-path "./pretrained_models/giga330M.pth"   --codec-model "encodec_16khz"   --share  # Create a public URL
```

The Gradio UI supports three modes: **TTS Mode** (zero-shot voice cloning), **Edit Mode** (speech editing), and **Long TTS Mode** (chunked generation for long texts).

### VoiceCraft + Jupyter Notebooks

For programmatic access, the Jupyter notebooks provide step-by-step inference:

```python
# inference_tts.ipynb — Zero-shot TTS example
from voicecraft import VoiceCraft

# Load the 330M model (faster, good quality)
model = VoiceCraft.from_pretrained("pyp1/VoiceCraft", subfolder="giga330M")

# Provide 3-5 seconds of reference audio
reference_audio = "demo/pam.wav"  # Your reference clip
reference_text = "I found the amazing VoiceCraft model"

# Text to synthesize
target_text = "This is a test of zero shot voice cloning with VoiceCraft"

# Generate
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,  # March 2025 update: top-k=40 improves quality
    temperature=1.0
)
output.save("output_tts.wav")
```

### VoiceCraft + Command Line

For batch processing and scripting:

```bash
# TTS inference via CLI
python tts_demo.py   --audio_path "demo/pam.wav"   --target_transcript "This is the text to speak"   --model_name "giga330M"   --top_k 40   --temperature 1.0   --output_path "output.wav"

# Speech editing via CLI
python speech_editing_demo.py   --audio_path "demo/pam.wav"   --original_transcript "original text here"   --edited_transcript "edited text here"   --model_name "giga830M"   --output_path "edited_output.wav"
```

### VoiceCraft + Docker API

For production deployment, wrap VoiceCraft in a REST API:

```dockerfile
# Dockerfile.api — Production API wrapper
FROM voicecraft:latest

WORKDIR /app
COPY api.py ./
COPY requirements-api.txt ./

RUN pip install -r requirements-api.txt

EXPOSE 8000

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
```

```python
# api.py — FastAPI wrapper for VoiceCraft
from fastapi import FastAPI, UploadFile, File
from voicecraft import VoiceCraft
import torchaudio

app = FastAPI()
model = VoiceCraft.from_pretrained("pyp1/VoiceCraft", subfolder="giga330M")

@app.post("/tts")
async def tts(
    audio: UploadFile = File(...),
    reference_text: str = "",
    target_text: str = ""
):
    """Zero-shot TTS endpoint."""
    ref_audio, sr = torchaudio.load(audio.file)
    output = model.tts(
        target_text=target_text,
        reference_audio=ref_audio,
        reference_text=reference_text,
        top_k=40
    )
    return {"output": output.serialize()}
```

### VoiceCraft + HuggingFace Hub

Download pre-trained models directly from HuggingFace:

```python
from huggingface_hub import hf_hub_download

# Download model weights
model_path = hf_hub_download(
    repo_id="pyp1/VoiceCraft",
    filename="giga330M.pth",
    subfolder="",
    local_dir="./pretrained_models"
)

# Also available via ModelScope (for China region)
from modelscope import snapshot_download
model_dir = snapshot_download('AI-ModelScope/VoiceCraft')
```

## Benchmarks / Real-World Use Cases

### Zero-Shot TTS Benchmarks

Human evaluation results from the ACL 2024 paper compare VoiceCraft against VALL-E, XTTS v2, FluentSpeech, and YourTTS on 250 test utterances (LibriTTS + YouTube):

| Model | WER | SIM | Intelligibility MOS | Naturalness MOS | Speaker Similarity MOS |
|-------|-----|-----|---------------------|-----------------|----------------------|
| **VoiceCraft** | **4.5** | **0.55** | **4.23** | **4.17** | **4.34** |
| XTTS v2 | 3.6 | 0.47 | 4.13 | 3.96 | 3.44 |
| VALL-E | 7.1 | 0.50 | 4.00 | 3.86 | 4.07 |
| FluentSpeech | 3.5 | 0.47 | 3.67 | 3.38 | 4.01 |
| YourTTS | 6.6 | 0.41 | 3.14 | 2.79 | 2.79 |
| Ground Truth | 3.8 | 0.76 | 4.39 | 4.48 | 4.44 |

VoiceCraft achieves the highest speaker similarity (SIM 0.55) and the best human-evaluated MOS scores across all categories. It trails ground truth by only 0.16 on intelligibility and 0.10 on speaker similarity.

### Speech Editing Benchmarks

On the RealEdit dataset (310 real-world editing examples), VoiceCraft outperforms FluentSpeech:

| Model | WER | Intelligibility MOS | Naturalness MOS |
|-------|-----|---------------------|-----------------|
| **VoiceCraft** | 6.1 | **4.11** | **4.03** |
| FluentSpeech | 4.5 | 3.97 | 3.81 |
| Original (unedited) | 5.4 | 4.22 | 4.17 |

Notably, in side-by-side listening tests, human listeners preferred VoiceCraft-edited speech over the **original unedited recording** 48% of the time — meaning the model's output is nearly indistinguishable from real audio.

### Real-World Applications

| Use Case | Reference Audio | Output Quality | Setup Time |
|----------|----------------|---------------|------------|
| Podcast editing | 5 seconds host voice | MOS 4.03 naturalness | < 2 min |
| Audiobook voice cloning | 5 seconds narrator | SIM 0.55 | < 2 min |
| YouTube video dubbing | 5 seconds speaker | MOS 4.17 naturalness | < 2 min |
| Call center voice synthesis | 3 seconds agent voice | SIM 0.55 | < 1 min |

![VoiceCraft demo page](https://jasonppy.github.io/VoiceCraft_web/static/teaser_figure.png)
*Figure 3: VoiceCraft demo page showing speech editing examples — listeners cannot distinguish edited from original 48% of the time.*

## Advanced Usage / Production Hardening

### Memory Optimization with KV Cache

For GPUs with limited VRAM, enable the key-value cache:

```python
# Enable kvcache for 8GB GPU inference
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,
    kvcache=True,  # Reduces VRAM usage by ~60%
    batch_size=1
)
```

### Top-k Sampling (March 2025 Update)

The default sampling strategy was updated from top-p=1.0 to top-k=40, which dramatically improves output quality:

```python
# Recommended: top-k=40 for best quality
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,
    temperature=1.0
)
```

### Fine-tuning on Custom Data

For domain-specific voices, fine-tune the pre-trained model:

```bash
# Prepare your dataset
conda activate voicecraft
cd ./data
python phonemize_encodec_encode_hf.py   --dataset_size xs   --download_to /path/to/downloads   --save_dir /path/to/processed   --encodec_model_path /path/to/encodec   --mega_batch_size 120   --batch_size 32   --max_len 30000

# Start fine-tuning
cd ../z_scripts
bash e830M_ft.sh  # Fine-tune 830M model
```

### Monitoring and Logging

```python
import logging
from torch.utils.tensorboard import SummaryWriter

# Setup logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("voicecraft")

# TensorBoard for training monitoring
writer = SummaryWriter(log_dir="./runs/voicecraft-ft")
writer.add_scalar("loss/train", loss.item(), global_step)
writer.add_scalar("mos/validation", val_mos, global_step)
```

### Security and Safety Considerations

VoiceCraft's license (CC BY-NC-SA 4.0 for code, Coqui Public Model License for weights) includes an ethical disclaimer prohibiting use to generate or edit speech without consent. For production deployments:

- Implement speaker verification before cloning
- Log all synthesis requests for audit trails
- Add synthesized speech watermarking
- Rate-limit API endpoints to prevent abuse

## Comparison with Alternatives

| Feature | VoiceCraft | GPT-SoVITS | Coqui TTS (XTTS v2) | VALL-E |
|---------|-----------|------------|-------------------|--------|
| **GitHub Stars** | 8,500 | 57,000 | 35,000* | N/A (paper only) |
| **Parameters** | 330M / 830M | ~1B combined | 467M | 1B |
| **Speech Editing** | Native, SotA | No | No | Limited |
| **Zero-shot TTS** | 3-5 sec reference | 5 sec reference | 6 sec reference | 3 sec reference |
| **Speaker Similarity MOS** | 4.34 | ~4.0 | 3.44 | 4.07 |
| **Naturalness MOS** | 4.17 | ~3.8 | 3.96 | 3.86 |
| **Languages** | English (EN) | EN, JA, KO, ZH, Yue | 17 languages | English |
| **Inference RTF** | ~0.3x (GPU) | 0.028x (4060Ti) | 0.18x (A100) | ~0.5x |
| **License** | CC BY-NC-SA 4.0 | MIT | CPML (non-commercial) | N/A |
| **Docker Support** | Official | Community | Community | N/A |
| **Gradio UI** | Built-in | Built-in | CLI/API only | N/A |
| **Fine-tuning** | Supported | Supported | Supported | N/A |

*Coqui TTS repository stars include all TTS models, not just XTTS.

**When to choose VoiceCraft:**
- **Speech editing** is your primary use case — no open-source competitor matches it
- You need the **highest speaker similarity** (MOS 4.34 vs 3.44 for XTTS)
- Working with **noisy, in-the-wild audio** (podcasts, YouTube videos)
- Academic or non-commercial research (CC BY-NC-SA license)

**When to choose GPT-SoVITS:**
- You need **Chinese or Japanese** voice cloning
- Commercial use is required (MIT license)
- Fastest inference speed is critical (RTF 0.028)
- Few-shot fine-tuning with 1 minute of data

**When to choose XTTS v2:**
- **Multilingual** support (17 languages) is needed
- You already use the Coqui TTS ecosystem
- Commercial licensing from Coqui is acceptable

## Limitations / Honest Assessment

VoiceCraft is not the right tool for every audio task. Here is what the maintainers and paper acknowledge:

1. **English-only**: The released model supports only English phonemes. The follow-up VoiceCraft-X (November 2024) extends to 11 languages but is a separate model.

2. **Non-commercial license**: Both code (CC BY-NC-SA 4.0) and model weights (Coqui Public Model License) restrict commercial use without additional agreements.

3. **Hardware requirements**: The 830M model requires 32 GB GPU memory for full inference. Even the 330M model needs careful memory management on consumer GPUs.

4. **Generation artifacts**: Occasional long silences and scratching sounds can appear in generated audio. The workaround (sampling multiple outputs and selecting the shortest) adds compute overhead.

5. **No streaming inference**: VoiceCraft generates the full sequence autoregressively, making real-time streaming TTS impractical compared to models like Kokoro or MeloTTS.

6. **Complex setup**: Compared to pip-installable TTS tools, VoiceCraft requires Docker or Conda with MFA, EnCodec, and specific CUDA versions — not a 30-second install.

## Frequently Asked Questions

**Q1: How much reference audio does VoiceCraft need for voice cloning?**

VoiceCraft requires only 3-5 seconds of reference audio for zero-shot TTS. For best results, use a clean recording without background noise or music. The model encodes the reference into speaker embeddings via EnCodec RVQ tokens, so longer references do not necessarily improve quality.

**Q2: Can I use VoiceCraft for commercial projects?**

The VoiceCraft codebase is under CC BY-NC-SA 4.0 and model weights under Coqui Public Model License 1.0.0 — both of which restrict commercial use. If you need a commercially permissive alternative, consider GPT-SoVITS (MIT license) or purchase a commercial license from Coqui for XTTS v2.

**Q3: What GPU do I need to run VoiceCraft?**

The 830M model requires 32 GB VRAM (A100, V100, or RTX 4090 + system RAM sharing). The 330M model runs on 16 GB GPUs, and with `kvcache=True`, inference is possible on 8 GB cards. CPU-only inference is possible but takes 7+ minutes per utterance on an 8-core Ryzen versus 35 seconds on GPU.

**Q4: How does VoiceCraft compare to GPT-SoVITS for voice cloning?**

VoiceCraft achieves higher speaker similarity (SIM 0.55 vs ~0.50) and naturalness (MOS 4.17 vs ~3.8) on English audio. However, GPT-SoVITS supports Chinese and Japanese natively, has faster inference (RTF 0.028 vs ~0.3), and uses a more permissive MIT license. For speech editing specifically, VoiceCraft has no open-source competitor.

**Q5: Can VoiceCraft edit existing recordings without re-synthesizing the whole file?**

Yes — speech editing is VoiceCraft's primary differentiator. You specify the edit span (insertion, deletion, or substitution) in the transcript, and the model infills only the affected audio segment while preserving the surrounding context. This is more efficient than full re-synthesis and maintains acoustic continuity.

**Q6: How do I fix "scratching sounds" in the generated audio?**

This is a known issue with autoregressive codec models. The March 2025 update (top-k=40 instead of top-p=1.0) significantly reduces artifacts. Additional remedies: (1) sample multiple outputs and select the shortest/cleanest, (2) reduce temperature to 0.9, (3) use the 330M-TTS-Enhanced model which was fine-tuned specifically for TTS quality.

**Q7: Is there a REST API or web service for VoiceCraft?**

The official repository provides a Gradio UI and Jupyter notebooks. Community projects like VoiceCraft_API wrap it in a FastAPI server. For production, deploy the Docker container behind an API gateway with rate limiting and speaker verification.

## Conclusion

VoiceCraft fills a gap that most TTS tools ignore: editing existing speech, not just synthesizing new speech. Its 8,500 GitHub stars and ACL 2024 acceptance reflect genuine technical merit — particularly the token rearrangement procedure that enables bidirectional context in autoregressive generation. The benchmarks are clear: VoiceCraft leads in speaker similarity (MOS 4.34) and produces edited audio that listeners prefer over original recordings 48% of the time.

For developers building podcast editors, audiobook tools, or voice cloning services, VoiceCraft is worth the setup effort. Start with the Docker quickstart, test on the Gradio UI, then integrate via the Python API.

Join our [Telegram group](https://t.me/dibi8opensource) to discuss VoiceCraft deployment patterns, share fine-tuning configs, and get help with production setups.



## Recommended Hosting & Infrastructure

Before you deploy any of the tools above into production, you'll need solid infrastructure. Two options dibi8 actually uses and recommends:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 free credit for 60 days across 14+ global regions. The default option for indie devs running open-source AI tools.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — Hong Kong VPS with low-latency access from mainland China. This is the same IDC that hosts dibi8.com — battle-tested in production.

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [VoiceCraft GitHub Repository](https://github.com/jasonppy/VoiceCraft)
- [VoiceCraft Paper — ACL 2024](https://aclanthology.org/2024.acl-long.673/)
- [VoiceCraft arXiv (v3)](https://arxiv.org/abs/2403.16973)
- [VoiceCraft Demo Page](https://jasonppy.github.io/VoiceCraft_web/)
- [VoiceCraft-X: Multilingual Extension](https://arxiv.org/abs/2511.12347)
- [HuggingFace Model Weights](https://huggingface.co/pyp1/VoiceCraft)
- [GPT-SoVITS Repository](https://github.com/RVC-Boss/GPT-SoVITS)
- [Coqui TTS / XTTS v2](https://github.com/coqui-ai/TTS)
- [EnCodec — Meta's Neural Codec](https://github.com/facebookresearch/audiocraft)
- [RealEdit Dataset Information](https://github.com/jasonppy/VoiceCraft/blob/master/RealEdit.txt)
- [VoiceCraft Docker Setup Guide](https://github.com/jasonppy/VoiceCraft#quickstart-docker)
- [VoiceCraft_API — FastAPI Wrapper](https://github.com/GPU-Net/VoiceCraft_API)

*This guide is independently written by the dibi8 technical team. VoiceCraft is developed by Puyuan Peng, Po-Yao Huang, Shang-Wen Li, Abdelrahman Mohamed, and David Harwath. No commercial affiliation exists between dibi8 and the VoiceCraft project.*
