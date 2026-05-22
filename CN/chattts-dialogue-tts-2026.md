---
title: 'ChatTTS 2026: 39.3k-Star Open-Source Dialogue TTS with Laughter, Pauses, and Token-Level Prosody Control'
description: 'ChatTTS is the open-source TTS purpose-built for dialogue (not narration). 39.3k GitHub stars, 4 GB VRAM minimum, RTF 0.3 on RTX 4090, fine-grained prosodic control including laughter and pauses. Complete 2026 install + production setup guide.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - CUDA
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/2noise/ChatTTS'
stars: 39300
maintainer: '2noise'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['ChatTTS', 'TTS', 'voice', 'dialogue', 'open-source']
aliases:
  - /posts/chattts-dialogue-tts-2026/
---

Most open-source TTS in 2026 still sounds like "1990s GPS narrator with extra reverb." **ChatTTS** is the first widely-adopted exception — a 39.3k-star generative speech model specifically trained for **dialogue**, not narration, with token-level control over laughter, pauses, interjections, and prosody that finally crosses the "doesn't make you wince" threshold.

If you're building voice agents, AI podcasts, multi-character TTS for games, or any voice product where flat narration kills the experience — ChatTTS is the default open-source pick in 2026.

## TL;DR

- **What**: Open-source dialogue-optimized TTS by 2noise (Chinese + English)
- **GitHub**: 39.3k stars
- **License**: AGPL-3.0 (code) + **CC BY-NC 4.0 (model)** — non-commercial use only on the open weights
- **VRAM**: 4 GB minimum for 30-second clips; comfortable at 8 GB
- **Speed**: RTF (Real-Time Factor) ~0.3 on RTX 4090 (faster than real-time)
- **Training data**: 40,000+ hours open-source / 100,000+ hours full model

## 1. Why ChatTTS Beats Traditional TTS for Dialogue

The legacy split:
- **Concatenative TTS** (festival, etc.) — mechanical, no prosody, dying
- **Neural TTS** (Tacotron / FastSpeech / VITS) — fluid but monotone, optimized for narration
- **Commercial APIs** (ElevenLabs / OpenAI TTS) — natural but $0.18-0.50/1000 chars and closed

ChatTTS sits in a new fourth category: **autoregressive generative TTS with explicit prosodic control tokens**. You don't just type text — you can mark up `[laugh]`, `[uv_break]` (umm), `[lbreak]` (long pause), and the model produces a vocal performance, not just speech.

For dialogue use cases (voice agents, AI podcasts, NPC dialogue in games), this is the difference between "obvious robot" and "could be a real person on a bad phone line." For narration, classical neural TTS is still often better.

## 2. Hardware Requirements (Realistic Numbers)

| Hardware | 30s clip generation time | Practical use |
|---|---|---|
| 4 GB GPU (GTX 1650 / 3050) | ~25 sec | Hobby, single-clip |
| 8 GB GPU (RTX 3060 / 4060) | ~10 sec | Solo dev, batch jobs |
| 12 GB GPU (RTX 3060 12GB / 4070) | ~5 sec | Production, low concurrent load |
| 24 GB GPU (RTX 4090 / A5000) | ~3 sec | Production, high concurrent |
| CPU-only | ~3-5 min | Not practical for interactive use |

For self-hosted production, the entry point is a $0.30-0.50/hr GPU cloud (Vast.ai, RunPod, or a {{< aff "digitalocean" "chattts-gpu" "DigitalOcean GPU droplet" >}}) — much cheaper than ElevenLabs at any meaningful volume.

## 3. Quick Install (10 minutes on a GPU machine)

```bash
git clone https://github.com/2noise/ChatTTS
cd ChatTTS
pip install -r requirements.txt
# Or via pip:
pip install ChatTTS
```

Hello world:
```python
import ChatTTS
import torchaudio
import torch

chat = ChatTTS.Chat()
chat.load(compile=False)  # Set True for ~30% speedup after first run

texts = ["Hello, this is a dialogue TTS test [uv_break] does it sound natural?"]
wavs = chat.infer(texts)

torchaudio.save("out.wav", torch.from_numpy(wavs[0]), 24000)
```

First run downloads ~2 GB of model weights. Subsequent runs are instant.

## 4. The Prosody Control Tokens (the killer feature)

The reason ChatTTS feels alive — these tags work mid-text:

| Tag | Effect |
|---|---|
| `[laugh]` | Inserts laughter |
| `[laugh_0]` to `[laugh_2]` | Laughter intensity levels |
| `[uv_break]` | Umm-style filler pause |
| `[lbreak]` | Longer pause (sentence-style) |
| `[oral_0]` to `[oral_9]` | Conversational style intensity (higher = more casual) |
| `[speed_0]` to `[speed_9]` | Speech speed (5 = normal) |
| `[break_0]` to `[break_7]` | Discrete pause durations |

Example:
```python
text = "So I told him [uv_break] there's no way that's true [laugh] [lbreak] but he kept insisting."
wavs = chat.infer([text])
```

This is what closes the "robot vs human" gap. Use sparingly; over-tagging sounds rehearsed.

## 5. Multi-Speaker — Stable Voices Across Sessions

ChatTTS generates a different "speaker" each invocation by default. For consistent characters (NPC voice, persistent agent personality), seed a speaker once and reuse:

```python
# Generate and save a stable speaker
rand_spk = chat.sample_random_speaker()
torch.save(rand_spk, "speaker_alice.pt")

# Use in subsequent runs
spk = torch.load("speaker_alice.pt")
params_infer_code = ChatTTS.Chat.InferCodeParams(spk_emb=spk)
wavs = chat.infer(texts, params_infer_code=params_infer_code)
```

Pattern: pre-generate 5-10 distinct speaker embeddings during setup. Pick the one matching each character. Voice stays stable across the entire production.

## 6. Licensing Caveat (Read This Before Production)

**Two licenses, two different obligations**:
- **Code**: AGPL-3.0 — copyleft, derivative works must open-source under AGPL
- **Model weights**: CC BY-NC 4.0 — **non-commercial use only**

For commercial production: contact 2noise for commercial model licensing, OR fine-tune your own model from scratch on the open ChatTTS architecture (significant effort but legally clean).

For hobby, research, internal tooling, and most agent prototyping: the NC license is fine.

This is the only friction point on adoption. If your product directly monetizes generated voices, factor in licensing cost (or pick commercial-friendly alternatives like Coqui XTTS-v2).

## 7. Production Pattern

For agent voice / podcast pipeline:

```
   Text input (from LLM agent / script generator)
            │
            ▼
   Light preprocessing (add prosody tags via rules)
            │
            ▼
   ChatTTS inference (GPU-backed FastAPI service)
            │
            ▼
   Output audio (WAV / Opus / streaming)
            │
            ▼
   Optional post-processing (loudness normalize, denoise)
```

Stand it up on a GPU-equipped {{< aff "htstack" "chattts-vps-hk" "HTStack Hong Kong VPS with GPU" >}} or a Vast.ai instance, expose via FastAPI, and your stack has voice for ~$0.001 per minute generated (vs ElevenLabs at ~$0.30/min).

## 8. When to Use ChatTTS vs Alternatives

| Use case | Pick |
|---|---|
| Dialogue / multi-character / agent voice | **ChatTTS** |
| Audiobook narration (single voice, long-form) | Coqui XTTS-v2 or commercial |
| Voice cloning from a 30-second sample | OpenVoice or Coqui XTTS-v2 |
| Lowest possible latency (<200ms) for live agents | Commercial (Deepgram Aura, ElevenLabs Flash) |
| Highest quality narration regardless of cost | ElevenLabs |
| Commercial use, must own the model | Fine-tuned Coqui XTTS-v2 |

## 9. Pitfalls

1. **Over-tagging prosody** — sprinkling `[laugh]` and `[uv_break]` everywhere sounds rehearsed. Less is more
2. **Forgetting to seed speakers** — every call without `spk_emb` is a different voice. Always pre-generate
3. **Running on CPU and complaining about speed** — RTF is 30-100× worse without GPU. Just rent a GPU
4. **Ignoring the NC license** — using ChatTTS for paid voice products is a legal risk

## TL;DR

ChatTTS = **first open-source TTS that handles dialogue convincingly**. 39.3k stars, 4 GB VRAM minimum, prosody-aware via control tokens, stable speakers via embedding seeds. Use for voice agents, AI podcasts, NPCs. Watch the CC BY-NC license for commercial use.

Spin up a GPU instance, run the 10-line install in section 3, and you'll hear in 5 minutes why this displaced every other open-source TTS in the discussion.

---

*Part of dibi8's multi-modal content stack — see the upcoming Multi-Modal Content Pipeline collection for ChatTTS + Whisper + Stable Diffusion + ComfyUI as a full audio/visual creator pipeline.*
