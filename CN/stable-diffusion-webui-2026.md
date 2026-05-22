---
title: 'Stable Diffusion WebUI 2026 (AUTOMATIC1111): 163k-Star Self-Hosted Image Generation — Complete Guide'
description: 'AUTOMATIC1111 stable-diffusion-webui is the 163k-star de-facto standard self-hosted UI for SD/SDXL image generation. Complete 2026 install + production guide covering txt2img / img2img / inpainting / outpainting / LoRA / ControlNet, hardware requirements, alternatives (Forge, SD.Next).'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - Gradio
  - CUDA
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/AUTOMATIC1111/stable-diffusion-webui'
stars: 163000
maintainer: 'AUTOMATIC1111'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Stable Diffusion', 'SDXL', 'image generation', 'AUTOMATIC1111', 'open-source']
aliases:
  - /posts/stable-diffusion-webui-2026/
---

If you've ever Googled "stable diffusion install" the first result has been **AUTOMATIC1111's stable-diffusion-webui** for three years running. At 163k GitHub stars (one of the most-starred AI projects ever), it's the default self-hosted UI for SD-family image generation in 2026 — text-to-image, image-to-image, inpainting, outpainting, LoRA, ControlNet, batch generation, all behind a Gradio web UI you can run on a 4 GB GPU.

This is the "I want to generate images locally without paying $20/mo to Midjourney" answer for solo creators and devs. For more complex workflows (multi-model pipelines, video generation, audio), see [ComfyUI](/resources/ai-tools/comfyui-node-based-ai-image-2026/) — the two are complementary, not competitors.

## TL;DR

- **What**: Gradio web UI for Stable Diffusion family models
- **GitHub**: 163k stars, 7,689+ commits, latest v1.10.1
- **License**: AGPL-3.0 (be aware for SaaS deployments)
- **Models**: SD 1.5, SD 2.x, SSD-1B, Alt-Diffusion natively; SDXL via extensions; SD3 / Flux via forks
- **Hardware**: 4 GB VRAM minimum (reports of 2 GB working with `--lowvram`)
- **Forks worth knowing**: Forge (faster, SDXL/Flux focus), SD.Next (rolling release)

## 1. Why A1111 Is Still the Default in 2026

The image-generation ecosystem fragmented hard after Flux dropped (Sept 2024) and SD 3.5 followed. ComfyUI took the "complex pipeline" niche. Yet A1111 stays the default because:

1. **Lowest learning curve** — text box, generate button, done
2. **Most extensions** — 500+ extensions handle ControlNet, ADetailer, Regional Prompter, training, you name it
3. **Most tutorials** — 4 years of Reddit/YouTube content is A1111-shaped
4. **Sufficient for 80% of use cases** — when you just want "good image from text," ComfyUI's graph view is overkill

If you're new to local image generation: start here. Migrate to ComfyUI when you outgrow it.

## 2. Hardware Realistic Numbers (2026)

| GPU | SD 1.5 (512×768) | SDXL (1024×1024) | Flux (1024×1024) |
|---|---|---|---|
| 4 GB (GTX 1650 / 3050) | ~15s/image | ~60s (with --lowvram) | Not practical |
| 8 GB (RTX 3060 / 4060) | ~5s | ~12s | ~30s (--medvram) |
| 12 GB (RTX 3060 12GB / 4070) | ~3s | ~6s | ~15s |
| 16-24 GB (RTX 4080 / 4090) | ~1.5s | ~3s | ~6s |

For cloud usage, $0.30-0.50/hr GPU instances on Vast.ai or {{< aff "digitalocean" "sd-gpu" "DigitalOcean GPU droplets" >}} are cheaper than Midjourney at any meaningful volume.

## 3. Quick Install (15 minutes)

**Linux/macOS**:
```bash
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
./webui.sh  # auto-installs Python deps, downloads default model
```

**Windows**: Download the latest release zip, extract, run `webui-user.bat`.

First run downloads ~4 GB (default SD 1.5 model) + ~2 GB Python deps. Open browser to `http://localhost:7860`.

## 4. The 80/20 Settings

For "just make me a good image" workflow:

- **Sampler**: DPM++ 2M Karras or Euler a
- **Steps**: 20-30 (above 30 = diminishing returns)
- **CFG Scale**: 7 (lower = more creative, higher = more literal)
- **Resolution**: 512×768 for SD 1.5, 1024×1024 for SDXL
- **Negative prompt baseline**: `bad anatomy, blurry, low quality, watermark, text, signature`

For high quality: enable Hires fix (2× upscale + denoise 0.4-0.5) at the cost of 2× generation time.

## 5. Essential Extensions

Top picks from the 500+ Extensions tab:

- **ControlNet** — pose / depth / canny / scribble conditioning. Single most useful extension
- **ADetailer** — auto-fix faces and hands (the two failure modes of base SD)
- **Regional Prompter** — different prompts for different parts of the image
- **Dynamic Prompts** — wildcard syntax `{red|blue|green} car`
- **Civitai Helper** — manage models downloaded from Civitai
- **sd-webui-prompt-history** — recover prompts from past generations

Install via Extensions tab → Install from URL → paste GitHub URL → Apply and restart.

## 6. LoRA / Embedding / ControlNet Workflow

The three customization mechanisms:

- **LoRA** (Low-Rank Adaptation) — small files (~150 MB) that adapt the base model toward a specific style or subject. Drop into `models/Lora/`, reference in prompt: `<lora:style_name:0.8>`
- **Textual Inversion / Embeddings** — even smaller (~30 KB), single-concept additions. Drop in `embeddings/`, just type the trigger word in prompt
- **ControlNet** — condition generation on pose / depth / line art / etc. Models go in `models/ControlNet/`

Civitai is the de-facto hub for community LoRAs and checkpoints. The Civitai Helper extension auto-syncs your local files with their metadata.

## 7. SDXL / SD3 / Flux Support (the 2026 reality)

Out of the box, A1111 mainline does SD 1.x/2.x. For newer models:

- **SDXL** — works mainline since v1.6
- **SDXL Turbo / Lightning** — works, configure as accelerated SDXL
- **SD 3.5** — needs Forge fork or extension, mainline lagging
- **Flux** — needs Forge fork; A1111 mainline doesn't support Flux as of v1.10
- **Want all of the above + Wan + Hunyuan?** Switch to [ComfyUI](/resources/ai-tools/comfyui-node-based-ai-image-2026/)

For a 2026 setup that uses SDXL day-to-day: A1111 mainline works. For Flux-first creative pipelines: Forge fork. For everything-supported: ComfyUI.

## 8. Production Self-Host Pattern

For a "personal image API" deploy:

```
   {{< aff "digitalocean" "sd-droplet" "GPU droplet" >}} (RTX 6000 Ada at $0.50/hr or rent on Vast.ai)
            │
            ▼
   A1111 with --api flag enabled
            │
            ▼
   Internal FastAPI wrapper (auth + rate limit + queue)
            │
            ▼
   Your app / agent calls /sdapi/v1/txt2img
```

Cost example: 8 hours/day usage × $0.50/hr × 30 days = $120/mo for unlimited generation, vs Midjourney at $30/mo for 200 fast hours. Break-even at ~moderate usage.

## 9. A1111 vs Forge vs SD.Next vs ComfyUI

| Pick | When |
|---|---|
| **A1111 mainline** | Default, SD 1.x/SDXL focus, biggest extension ecosystem |
| **Forge** | Same UI as A1111 but 30-75% faster, SDXL/Flux ready, smaller VRAM footprint |
| **SD.Next** | Rolling release, supports nearly everything A1111+Forge support but a single fork |
| **ComfyUI** | Complex workflows, video gen, audio, latest models day-1, node-based control |

The honest 2026 recommendation: try A1111 mainline first. If you need Flux or speed, switch to Forge. If you outgrow the linear UI mental model, learn ComfyUI.

## TL;DR

AUTOMATIC1111 SD WebUI = **default self-hosted image generation for solo creators in 2026**. 163k stars, 4 GB VRAM minimum, runs SD 1.x/SDXL out of box. Pair with Civitai for community models, ControlNet/LoRA/ADetailer for advanced control.

Spin up a GPU instance, run section 3's install, and 15 minutes later you have local image generation that breaks even with Midjourney at any meaningful volume.

---

*Part of dibi8's multi-modal content stack — see also [ComfyUI for node-based workflows](/resources/ai-tools/comfyui-node-based-ai-image-2026/) and the upcoming Multi-Modal Content Pipeline collection.*
