---
title: 'NVIDIA Cosmos: Open-Source World Models for Physical AI (10K Stars)'
description: 'NVIDIA Cosmos is an open platform of world models, datasets, and tools for building Physical AI — robots, autonomous vehicles, smart infrastructure. Cosmos 3 uses Mixture-of-Transformers for unified language, image, video, audio, and action generation. 16B and 64B models available.'
tags: ["open-source", "self-hosted"]
date: 2026-06-13
slug: 'nvidia-cosmos-world-models-platform-2026'
category: ai-tools
github_repo: 'https://github.com/NVIDIA/cosmos'
license: 'Apache-2.0'
lang: en
featureImage: /articles/nvidia-cosmos-open-source-world-models-for-physical-ai-10k-s.jpg/images/articles/nvidia-cosmos-open-source-world-models-for-physical-ai-10k-s.jpg
---

![NVIDIA Cosmos platform](https://raw.githubusercontent.com/NVIDIA/cosmos/main/cookbooks/cosmos3/cosmos3-model-architecture.png)

# NVIDIA Cosmos: Open-Source World Models for Physical AI (10K Stars)

What if you could predict how the physical world behaves — not by simulating physics equations, but by learning from the world itself?

NVIDIA Cosmos is exactly that: an open-source platform of world models trained to understand and generate the physical world. It doesn't just generate images of a robot moving — it predicts the physics, the timing, the cause-and-effect of that motion.

Cosmos 3 is NVIDIA's latest model family, built on a unified Mixture-of-Transformers (MoT) architecture that handles language, images, video, audio, and action sequences simultaneously. Two runtimes: a **Reasoner** (for world understanding and planning) and a **Generator** (for world simulation and synthetic data creation).

The models range from 16B (Nano) to 64B (Super) parameters, available on HuggingFace. This is infrastructure for the next generation of physical AI — robots, autonomous vehicles, smart infrastructure.

## What Is NVIDIA Cosmos?

NVIDIA Cosmos is an **open platform of world models, datasets, and tools** designed for building Physical AI systems. It goes beyond what traditional AI can do:

```
Traditional AI:         Cosmos:
  Input → Output      →  Input → Reasoning → Output
  (image in,          (understand physics,
   caption out)        predict future,
                       generate actions)
```

Key capabilities:

- **World understanding**: Analyze videos and images for captions, temporal events, next actions, spatial grounding, physical plausibility, and causal outcomes
- **World generation**: Produce images, videos, synchronized sound, and action-conditioned rollouts from text, image, video, or action inputs
- **Action modeling**: Predict policy actions, inverse dynamics, and forward dynamics for robotics, camera motion, egocentric motion, and autonomous driving

The Cosmos 3 model family includes:

| Model | Size | Capability |
|---------|---------|------------|
| Cosmos3-Nano | 16B | Compact omnimodal model for understanding and simulation |
| Cosmos3-Super | 64B | Frontier-scale model for advanced multimodal tasks |
| Cosmos3-Super-Text2Image | 64B | High-fidelity text-to-image generation |
| Cosmos3-Super-Image2Video | 64B | Temporally coherent image-to-video |
| Cosmos3-Nano-Policy-DROID | 16B | Vision-language robot policy for DROID manipulation |

## Model Architecture: Mixture-of-Transformers

Cosmos 3 uses a unified **Mixture-of-Transformers (MoT)** architecture that combines:

1. **Autoregressive (AR) transformer** for reasoning — processes language and visual tokens through causal self-attention for next-token prediction
2. **Diffusion Transformer (DM)** for generation — denoises image, video, audio, and action tokens through full attention

```
┌─────────────────────────────────────────────┐
│         Cosmos 3: Unified MoT               │
├─────────────────┬───────────────────────────┤
│  Reasoner Mode  │    Generator Mode         │
│  (Perception)   │    (Generation)           │
├─────────────────┼───────────────────────────┤
│ Text + Vision   │ Noisy Image/Video/        │
│ → Text          │ Audio/Action              │
│ (understanding) │ → Clean Image/Video/      │
│                 │ Action/Sound              │
├─────────────────┼───────────────────────────┤
│ Shared:         │                          │
│ - Transformer layers                     │
│ - Multimodal attention layers            │
│ - 3D mRoPE (spatial + temporal encoding) │
└─────────────────┴──────────────────────────┘
```

Both modes share the same transformer architecture, multimodal attention layers, and a unified 3D multi-dimensional rotary position embedding (mRoPE) that encodes spatial and temporal structure across modalities.

## Two Runtime Surfaces

Cosmos 3 exposes two distinct runtime surfaces:

### Reasoner (Understanding)

Processes inputs and produces textual output for world understanding tasks:

```
Input: Text + Image + Video + Action
         ↓
    Reasoner (AR Transformer)
         ↓
Output: Text (captions, next actions, physical reasoning, task plans)
```

**Use cases**:
- World understanding from video streams
- Next action prediction for robots
- Physical plausibility checking
- Causal outcome prediction
- Embodied agent reasoning

### Generator (Creation)

Produces non-text outputs conditioned by multimodal inputs:

```
Input: Text + Image + Video + Sound + Action
         ↓
    Generator (Diffusion Transformer)
         ↓
Output: Image + Video + Sound + Action
```

**Use cases**:
- Text-to-image generation
- Image-to-video generation
- World simulation and future prediction
- Synthetic data generation for training robots
- Action-conditioned video generation
- Policy learning from demonstration

## Quickstart: Installation

Cosmos runs on Linux with NVIDIA GPUs (Ampere, Hopper, or Blackwell). Installation uses `uv` (the fast Python package manager):

### System Requirements

- **OS**: Linux
- **GPU**: NVIDIA GPU (Ampere/A100/H100/Blackwell RTX 6000+)
- **CUDA**: 12.8 or 13.0
- **Python**: 3.10+
- **RAM**: 64GB+ (recommended 128GB for 64B models)

### Install with uv

```bash
# Install system dependencies
sudo apt-get install -y --no-install-recommends curl ffmpeg git-lfs \
  libx11-dev tree wget

# Clone the framework
git clone https://github.com/NVIDIA/cosmos-framework.git
cd cosmos-framework

# Install with uv (CUDA 12.8 variant)
uv sync --all-extras --group=cu128-train
source .venv/bin/activate

# Or CUDA 13.0 (recommended):
# uv sync --all-extras --group=cu130-train
```

### Quick Inference

```python
# Single-GPU inference with Diffusers backend
python -m cosmos_framework.scripts.inference \
    --parallelism-preset=latency \
    -i inputs/omni/t2v.json \
    -o outputs/omni_nano \
    --checkpoint-path Cosmos3-Nano \
    --seed=0
```

### HuggingFace Models

```bash
# Download a model from HuggingFace
huggingface-cli download nvidia/Cosmos3-Nano \
    --local-dir ~/cosmos/models/nano
```

## Generator Mode: World Generation

The Generator produces images, videos, audio, and action outputs conditioned by multimodal inputs:

### Text-to-Image

```python
from cosmos_framework.scripts.inference import run_inference

# Generate an image from text
result = run_inference(
    checkpoint="Cosmos3-Super-Text2Image",
    input_type="text",
    input_text="A robot arm assembling a circuit board in a modern lab",
    output_type="image",
    resolution="720p",
    seed=42
)
# Output: High-fidelity image of robot assembling circuit board
```

### Image-to-Video

```python
# Generate temporally coherent video from a single image
result = run_inference(
    checkpoint="Cosmos3-Super-Image2Video",
    input_type="image",
    input_image="robot_lab.jpg",
    output_type="video",
    frame_count=189,  # default: 189 frames (~7.8s at 24fps)
    fps=24,
    resolution="720p"
)
# Output: Video of the robot lab scene in motion
```

### Text-to-Video

```python
# Generate video directly from text prompt
result = run_inference(
    checkpoint="Cosmos3-Nano",
    input_type="text",
    input_text="A self-driving car navigating through heavy rain at night, city lights reflecting on wet pavement",
    output_type="video",
    frame_count=300,
    fps=30,
    resolution="720p"
)
# Output: Video with synchronized audio (AAC stereo at 48kHz)
```

### Supported Generation Settings

| Parameter | Options |
|-----------|---------|
| Resolution | 256p, 480p, 720p (default: 480p) |
| Aspect Ratio | 16:9, 4:3, 1:1, 3:4, 9:16 (default: 16:9) |
| Frame Rate | 10, 16, 24, 30 FPS (default: 24) |
| Frame Count | 5 to 300 frames (default: 189) |
| Precision | BF16 (tested) |

## Reasoner Mode: World Understanding

The Reasoner provides textual output for understanding and planning:

```python
# World understanding from video
result = run_inference(
    checkpoint="Cosmos3-Nano",
    input_type="video",
    input_video="warehouse_robots.mp4",
    output_type="text",
    task="describe_temporal_events"
)
# Output: "At frame 0-30, two robot arms coordinate..."

# Next action prediction for a robot
result = run_inference(
    checkpoint="Cosmos3-Nano-Policy-DROID",
    input_type="image+text",
    input_image="robot_workspace.jpg",
    input_text="What should the robot do next?",
    output_type="text"
)
# Output: "Pick up the red component from the left tray..."

# Physical plausibility check
result = run_inference(
    checkpoint="Cosmos3-Super",
    input_type="video",
    input_video="physics_demo.mp4",
    output_type="text",
    task="check_physical_plausibility"
)
# Output: "The ball trajectory violates gravity..."
```

## Use Cases

### Robot Training with Synthetic Data

Cosmos generates synthetic training data for robots, reducing the need for expensive real-world data collection:

```bash
# Generate 1000 synthetic video clips of warehouse robots
# for training a manipulation policy
cosmos_framework.scripts.training.train \
    --recipe examples/launch_sft_vision_nano.sh \
    --num-samples 1000 \
    --output-dir /data/warehouse_synthetic
```

### Autonomous Vehicle Simulation

```python
# Simulate autonomous driving scenarios
result = run_inference(
    checkpoint="Cosmos3-Nano",
    input_type="text+image",
    input_text="A self-driving car at an intersection with red light",
    input_image="intersection.jpg",
    output_type="video+action",
    task="predict_vehicle_dynamics"
)
# Output: Video of car stopping + action vector (steering, throttle, brake)
```

### Smart Infrastructure Monitoring

```python
# Analyze security camera footage for anomalies
result = run_inference(
    checkpoint="Cosmos3-Super",
    input_type="video",
    input_video="factory_cam_01.mp4",
    output_type="text",
    task="detect_anomalies"
)
# Output: "At 14:32:15, unmarked vehicle entered restricted zone..."
```

## Training: Fine-Tuning Cosmos Models

The Cosmos framework includes training scripts for supervised fine-tuning (SFT) on custom data:

```bash
# Multi-GPU SFT training on 8× H100 80GB
bash examples/launch_sft_vision_nano.sh

# Key configuration options
# - DP/CP/FSDP parallelism strategies
# - Native DCP checkpoints with HuggingFace safetensors
# - JSONL / WebDataset / LeRobot dataset adapters
# - Mixed precision training
# - Checkpoint resume support
```

```python
# Training configuration example
training_config = {
    "model": "Cosmos3-Nano",
    "num_gpus": 8,
    "parallelism": "FSDP",  # Fully Sharded Data Parallel
    "mixed_precision": "bf16",
    "batch_size_per_gpu": 4,
    "dataset": {
        "type": "jsonl",
        "path": "/data/training_samples.jsonl"
    },
    "checkpoint_dir": "/checkpoints/sft_nano"
}
```

## Comparison with Alternatives

| Feature | NVIDIA Cosmos | Runway Gen-3 | Sora | Pika Labs |
|---------|--------------|-------------|------|-----------|
| **Open-source** | ✅ Yes | ❌ Proprietary | ❌ Proprietary | ❌ Proprietary |
| **Reasoning mode** | ✅ Built-in | ❌ | ❌ | ❌ |
| **Action generation** | ✅ Built-in | ❌ | ❌ | ❌ |
| **Robot policy** | ✅ DROID model | ❌ | ❌ | ❌ |
| **Local inference** | ✅ Yes | ❌ API only | ❌ API only | ❌ API only |
| **Synthetic data** | ✅ Built-in | ❌ | ❌ | ❌ |
| **Fine-tuning** | ✅ Supported | ❌ | ❌ | ❌ |
| **Available models** | 5 (Nano + Super variants) | 1 | 1 | 1 |
| **GPU requirement** | H100/A100 recommended | Cloud-only | Cloud-only | Cloud-only |
| **License** | Apache-2.0 | Proprietary | Proprietary | Proprietary |

| Feature | NVIDIA Cosmos | Stable Video Diffusion | Luma Dream Machine |
|---------|--------------|----------------------|------------------|
| **Open-source** | ✅ Yes | ✅ Yes | ❌ Proprietary |
| **Multimodal** | ✅ Text+Image+Video+Audio+Action | ❌ Image→Video only | ❌ Text→Video only |
| **Physical reasoning** | ✅ Built-in | ❌ | ❌ |
| **Robotics support** | ✅ DROID policy model | ❌ | ❌ |

## Benchmarks

### Generation Quality

Cosmos 3 models are evaluated on multiple benchmarks:

| Benchmark | Cosmos3-Nano | Cosmos3-Super | Runway Gen-3 | Sora |
|-----------|-------------|---------------|-------------|------|
| VideoFID (↓) | 8.2 | 5.1 | 6.3 | 4.8 |
| CLIP-I Score (↑) | 0.89 | 0.93 | 0.91 | 0.92 |
| Physical Plausibility (↑) | 0.76 | 0.89 | N/A | N/A |
| Action Accuracy (↑) | 0.71 | 0.84 | N/A | N/A |

**Sources**: NVIDIA internal evaluation, May 2026. VideoFID: lower is better. CLIP-I: higher is better (image-text alignment). Physical Plausibility: human-evaluated score for physical correctness. Action Accuracy: predicted actions vs ground truth.

### Inference Speed

| Model | Resolution | Frame Count | GPU | Time |
|-------|-----------|-------------|-----|------|
| Cosmos3-Nano | 480p | 189 frames | 1× H100 | ~45s |
| Cosmos3-Nano | 720p | 189 frames | 1× H100 | ~90s |
| Cosmos3-Super | 480p | 189 frames | 1× H100 | ~180s |
| Cosmos3-Super | 720p | 189 frames | 2× H100 | ~240s |

## Limitations and Honest Assessment

Cosmos is groundbreaking, but it's important to understand its limitations:

1. **Heavy hardware requirements**: You need at least one H100/A100-level GPU for decent performance. The 64B models may require 2+ GPUs. This is not something you can run on consumer hardware.

2. **Linux only**: The framework runs on Linux only, with CUDA. No macOS support currently.

3. **Very young project**: First committed December 2024. Despite NVIDIA's resources, this is still a rapidly evolving project with potential breaking changes.

4. **No consumer-friendly API**: Unlike Runway, Sora, or Pika, Cosmos requires you to set up the framework yourself. There's no "click and generate" interface (though the website at nvidia.com/en-us/ai/cosmos/ provides a guided experience).

5. **Dataset dependency**: The quality of Cosmos depends heavily on the training data. If you try to fine-tune on your own domain (medical imaging, scientific visualization), you'll need domain-specific training data.

6. **NVIDIA ecosystem lock-in**: While the models are open-source (Apache-2.0), the entire toolchain (Cosmos framework, NGC images, NVIDIA optimizations) is tightly coupled to NVIDIA hardware. Running on AMD or Intel GPUs is not currently supported.

7. **Small community**: 19 open issues, 657 forks. The project is moving fast, but the community is small compared to models like Stable Diffusion or Llama.

## Frequently Asked Questions

**Q: Can I run Cosmos on a consumer GPU?**
Technically, you might be able to run Cosmos3-Nano on a high-end consumer GPU (RTX 4090 with 24GB VRAM) for small generations (256p, short videos), but performance will be limited. The 64B models require A100/H100-class GPUs.

**Q: How does Cosmos differ from Stable Video Diffusion?**
SVD is an image-to-video model only. Cosmos is a unified multimodal platform that handles text-to-image, text-to-video, image-to-video, video-understanding, physical reasoning, and robot policy prediction — all in one framework.

**Q: Can I fine-tune Cosmos on my own data?**
Yes. The framework supports supervised fine-tuning (SFT) with JSONL, WebDataset, and LeRobot dataset formats. You need 8× H100 GPUs for full fine-tuning of the 64B model. For smaller models (Nano), 4 GPUs may suffice.

**Q: Is Cosmos available as an API?**
Not directly. However, NVIDIA offers Cosmos through their NIM (NVIDIA Inference Microservices) platform, which provides an OpenAI-compatible API for Cosmos models.

**Q: What's the license?**
Apache-2.0 for the code, with model weights available under NVIDIA's research license. Commercial use is permitted with proper attribution.

## Conclusion

NVIDIA Cosmos represents a fundamental shift in how we approach AI and the physical world. Instead of treating video generation, image generation, robot policy, and physical reasoning as separate problems, Cosmos unifies them in a single Mixture-of-Transformers architecture.

The combination of Reasoner Mode (understanding) and Generator Mode (creation) — both sharing the same transformer backbone — means you can go from understanding a scene to generating the future of that scene in one pipeline.

For robotics, autonomous driving, and smart infrastructure, Cosmos is not just another AI model. It's infrastructure.

If you're building Physical AI systems, Cosmos should be at the top of your research list.

---

**Sources & Further Reading**:
- Technical report: https://research.nvidia.com/labs/cosmos-lab/cosmos3/technical-report.pdf
- Cosmos 3 models: https://huggingface.co/collections/nvidia/cosmos3
- Cosmos Framework: https://github.com/NVIDIA/cosmos-framework
- Website: https://www.nvidia.com/en-us/ai/cosmos/

---

**Try NVIDIA Cosmos**: Visit [nvidia.com/en-us/ai/cosmos/](https://www.nvidia.com/en-us/ai/cosmos/) for a guided experience, or clone [github.com/NVIDIA/cosmos-framework](https://github.com/NVIDIA/cosmos-framework) for the full framework.

Join the community: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

Internal links: [runway-gen3-review-2026](https://dibi8.com/runway-gen3-review-2026) · [stability-ai-stable-video-diffusion](https://dibi8.com/stability-ai-stable-video-diffusion)

**Disclosure**: This article mentions tools that may have affiliate relationships. We do not accept payment for positive reviews. All benchmarks are self-conducted or sourced from official documentation.
