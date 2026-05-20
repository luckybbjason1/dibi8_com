---
title: 'Demucs: 10K+ Stars 的音乐源分离工具 — 2026年对比 UVR、Spleeter'
description: 'Demucs 是 Meta AI 开发的混合频谱图和波形域源分离模型。兼容 Ultimate Vocal Remover、RVC、GPT-SoVITS。涵盖 demucs 教程、demucs vs uvr、demucs Docker 部署和生产环境基准测试。'
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
github_repo: 'https://github.com/facebookresearch/demucs'
stars: 10100
maintainer: 'facebookresearch'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['demucs', '音乐源分离', 'AI音频', '音轨分离', 'pytorch', 'docker', '开源']
aliases:
- /zh/posts/demucs/
---

{{</* resource-info */>}}

将一首混音完成的歌曲分离成独立的人声、鼓、贝斯和其他乐器音轨 —— 过去这需要原始的多轨工程文件。深度学习模型改变了这一切，它们学会了"反混音"成品音频。如今，音乐人、制作人和开发者使用这些工具来制作卡拉OK伴奏、提取采样素材、准备混音工程，以及搭建声音转换流水线。在开源方案中，有一个模型主导了整个领域：**Demucs**，Meta 的混合 Transformer 架构，GitHub 上超过 10,000 星标，在 MUSDB18-HQ 基准测试上达到了业界领先的分离质量。

本指南将介绍 Demucs 的工作原理、本地安装方法、与 Spleeter 和 Ultimate Vocal Remover 的对比，以及如何将其集成到实际的生产工作流中。

## 什么是 Demucs？

**Demucs**（Deep Extractor for Music Sources）是由 Meta AI Research 开发的开源音乐源分离模型。它接收立体声混音作为输入，输出独立的"音轨"（stem）—— 通常包括人声、鼓、贝斯，以及一个包含吉他、键盘和其他剩余乐器的"其他"音轨。

该项目托管在 GitHub 的 `facebookresearch/demucs` 仓库，已获得超过 10,100 星标和 1,500 分支。仓库于 2025 年 1 月 1 日被 Meta 归档为只读状态，但原作者 Alexandre Defossez 在 `adefossez/demucs` 维护着一个活跃的分支。最新的稳定版本是 v4.1.0，整个项目采用 MIT 许可证。

Demucs 与早期工具的核心区别在于其**混合处理方式**：它同时在时域（原始波形）和频域（频谱图）处理音频，然后将两种表示融合。这种双域处理保留了纯频谱方法会丢失的相位信息，从而实现了更干净的分离效果和更少的金属感伪影。

## Demucs 的工作原理

### 架构概览

当前代的 Demucs —— 官方称为 **Hybrid Transformer Demucs (HTDemucs)** —— 建立在 U-Net 卷积骨干网络之上，并增加了 Transformer 层。架构在概念上分为三个阶段：

1. **编码器**：输入波形同时通过一个时域编码器（一维卷积）和一个频域编码器（STFT 后接二维卷积）。这种双重编码同时捕获细粒度的时间细节和谐波频率结构。

2. **Transformer 瓶颈**：U-Net 的最深层使用跨域 Transformer 编码器，在每个域内进行自注意力计算，并在域之间进行交叉注意力计算。这种机制建模长距离依赖关系 —— 对于分离跨越多个小节的人声旋律与音高相近的吉他线至关重要。

3. **解码器**：独立的解码器在两个域中重建每个声源（鼓、贝斯、其他、人声），融合层将输出组合成最终分离的波形。

![Demucs 架构图](https://raw.githubusercontent.com/facebookresearch/demucs/main/demucs.png)

### 可用模型

Demucs 提供多个针对不同速度/质量权衡优化的预训练模型：

| 模型 | 音轨数 | 显存占用 | SDR (MUSDB) | 适用场景 |
|------|--------|----------|-------------|----------|
| `htdemucs` | 4 | ~5.2 GB | 7.1 dB | 默认，速度质量平衡 |
| `htdemucs_ft` | 4 | ~7.8 GB | 7.8 dB | 最高质量，慢约 4 倍 |
| `htdemucs_6s` | 6 | ~6.5 GB | 6.8 dB | 吉他+钢琴分离 |
| `mdx_extra_q` | 4 | ~3.0 GB | 6.5 dB | 低显存设备 |

`htdemucs_ft` 模型在 MUSDB18-HQ 上达到 7.8 dB 的整体 SDR，各声源分别约为：人声 8.5 dB、贝斯 7.5 dB、鼓 8.9 dB、"其他"类别 6.2 dB。作为参考，0 dB 意味着相比原始混音没有任何分离改善。

## 安装与配置

### 前置条件

安装 Demucs 之前，请确认环境满足以下要求：

```bash
# Python 3.8+ 必需
python --version

# 必须安装 FFmpeg
ffmpeg -version

# (可选) NVIDIA GPU + CUDA 11.8+ 用于加速
nvidia-smi
```

### 方案一：pip 安装（最快）

最简单的 Demucs 运行方式：

```bash
# 创建虚拟环境
python -m venv demucs-env
source demucs-env/bin/activate  # Linux/macOS
# demucs-env\Scripts\activate   # Windows

# 安装 Demucs
pip install -U demucs

# 验证安装
demucs --help
```

### 方案二：Conda + GPU 支持（推荐）

用于 GPU 加速推理和训练：

```bash
# 克隆仓库
git clone https://github.com/adefossez/demucs.git
cd demucs

# 从官方配置创建环境
conda env update -f environment-cuda.yml
conda activate demucs

# 开发模式安装
pip install -e .

# 验证 GPU 是否被检测到
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
```

### 方案三：Docker（最干净的隔离）

用于可复现、无依赖冲突的部署：

```bash
# Dockerfile
FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

RUN pip install -U demucs

WORKDIR /audio
ENTRYPOINT ["demucs"]
```

构建并运行：

```bash
docker build -t demucs .
docker run --gpus all -v $(pwd):/audio demucs song.mp3
```

**Docker Compose（用于批量服务）：**

```yaml
version: '3.8'

services:
  demucs:
    build: .
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./input:/audio/input:ro
      - ./output:/audio/output
    command: ["-n", "htdemucs_ft", "--mp3", "-o", "/audio/output", "/audio/input"]
```

### 首次分离运行

安装完成后，分离你的第一首曲目：

```bash
# 使用默认模型的基础 4 音轨分离
demucs song.mp3

# 输出到 ./separated/htdemucs/song/
# 包含：drums.wav、bass.wav、other.wav、vocals.wav

# 使用微调模型获得更好质量
demucs -n htdemucs_ft song.mp3

# 只分离人声和伴奏
demucs --two-stems=vocals song.mp3

# 输出为 MP3（文件更小）
demucs --mp3 --mp3-bitrate 320 song.mp3
```

### 验证模型下载和缓存

模型在首次使用时自动下载。验证缓存：

```bash
# 列出已下载的模型
ls ~/.cache/torch/hub/checkpoints/

# 预期输出包含：
# htdemucs-*.th, htdemucs_ft-*.th

# 检查将使用哪个模型
demucs -n htdemucs_ft --help | grep "name"

# 使用短音频文件快速测试
ffmpeg -f lavfi -i "sine=frequency=1000:duration=5" test_tone.wav
demucs -n htdemucs test_tone.wav
```

## 与流行工具的集成

### Ultimate Vocal Remover (UVR)

Ultimate Vocal Remover 是 Demucs 最流行的 GUI 前端。大多数制作人选择通过 UVR 使用 Demucs，因为它将 Demucs 模型与其他架构捆绑在一起，并增加了集成功能。

在 UVR 中的配置：

1. 从 [官方 GitHub Releases](https://github.com/Anjok07/ultimatevocalremovergui/releases) 下载 UVR5
2. 在界面中选择 **Process Method: "Demucs"**
3. 选择模型：`V4 | htdemucs_ft`
4. 如果可用，启用 **GPU Conversion**
5. 如需最佳效果，使用 **Ensemble Mode** 组合 `htdemucs_ft` + `MDX-Net`

UVR 的 ensemble 模式并行运行多个模型并融合它们的输出，其效果始终优于任何单一模型。代价是处理时间 —— ensemble 运行比单一模型慢约 3–5 倍。

### RVC（检索式声音转换）

RVC 流水线通常使用 Demucs 作为预处理步骤，在声音提取之前隔离人声：

```python
import subprocess
import os

def preprocess_for_rvc(input_song, output_dir):
    """为 RVC 声音转换提取干净的人声。"""
    os.makedirs(output_dir, exist_ok=True)

    # 步骤 1：使用 Demucs 分离
    subprocess.run([
        'demucs', '-n', 'htdemucs_ft',
        '--two-stems=vocals',
        '-o', output_dir,
        input_song
    ], check=True)

    # 步骤 2：返回隔离人声的路径
    base = os.path.splitext(os.path.basename(input_song))[0]
    vocals_path = os.path.join(
        output_dir, 'htdemucs_ft', base, 'vocals.wav'
    )
    return vocals_path

# 使用
vocals = preprocess_for_rvc('input.mp3', './separated')
# 将人声输入 RVC 进行声音转换
```

### GPT-SoVITS

GPT-SoVITS 声音克隆需要干净的参考音频。Demucs 在将采样输入 TTS 流水线之前移除背景音乐：

```python
from demucs.api import Separator
import torchaudio

separator = Separator(model="htdemucs", device="cuda")

# 分离并提取人声
origin, separated = separator.separate_audio_file("reference.mp3")
vocals = separated["vocals"]

# 保存为 24kHz 供 GPT-SoVITS 使用
torchaudio.save("clean_reference.wav", vocals, 24000)
```

### Gradio Web 界面

用于自建分离服务：

```python
import gradio as gr
from demucs.api import Separator

separator = Separator(model="htdemucs_ft")

def separate(audio_file, stem):
    origin, separated = separator.separate_audio_file(audio_file)
    output_path = f"{stem}.wav"
    separator.save_audio(separated[stem], output_path, samplerate=44100)
    return output_path

demo = gr.Interface(
    fn=separate,
    inputs=[
        gr.Audio(type="filepath", label="上传歌曲"),
        gr.Dropdown(
            choices=["vocals", "drums", "bass", "other"],
            value="vocals",
            label="音轨"
        )
    ],
    outputs=gr.Audio(label="分离后的音轨"),
    title="Demucs 源分离",
    description="使用 Meta 的 Demucs 模型分离音乐音轨"
)

demo.launch(server_name="0.0.0.0", server_port=7860)
```

## 基准测试 / 实际用例

### MUSDB18-HQ 基准测试结果

MUSDB18-HQ 是音乐源分离的标准基准数据集，包含 150 首完整歌曲及其对应的独立音轨真值。SDR（信号失真比）越高，表示分离越干净。

| 模型 | 整体 SDR | 人声 | 鼓 | 贝斯 | 其他 | 速度 (RTX 3090) |
|------|----------|------|-----|------|------|-----------------|
| **HTDemucs FT (v4)** | **7.8 dB** | **8.5 dB** | **8.9 dB** | **7.5 dB** | **6.2 dB** | ~4 倍实时 |
| HTDemucs (v4) | 7.1 dB | 7.8 dB | 8.2 dB | 6.9 dB | 5.6 dB | ~16 倍实时 |
| Hybrid Demucs (v3) | 7.7 dB | 8.1 dB | 8.5 dB | 7.2 dB | 5.9 dB | ~12 倍实时 |
| Spleeter 4stems | 5.9 dB | 6.3 dB | 6.8 dB | 5.4 dB | 4.2 dB | ~100 倍实时 |
| Open-Unmix | 5.3 dB | 6.2 dB | 5.9 dB | 4.7 dB | 4.2 dB | ~80 倍实时 |

### 生产环境用例

**卡拉OK伴奏生成**：`--two-stems=vocals` 选项通过混合 drum + bass + other 并丢弃人声轨道来生成伴奏。一首 4 分钟的歌曲在 GPU 上处理时间不到 30 秒。

**制作人采样提取**：从完整混音中隔离鼓点循环、贝斯旋律或其他乐器元素。`htdemucs_6s` 模型增加了吉他和钢琴分离，但这些音轨的质量低于主要四种音轨。

**声音转换预处理**：干净的人声提取是 RVC、GPT-SoVITS 等声音克隆流水线的先决条件。Demucs 在分离人声时 consistently 产生的串音比纯频谱方法更少。

**音频修复**：档案管理员使用 Demucs 分离历史录音，对各音轨分别进行降噪后再重新混音。

### 处理时间参考

一首 4 分钟立体声 44.1 kHz 曲目的处理时间：

| 硬件 | htdemucs | htdemucs_ft | htdemucs_6s |
|------|----------|-------------|-------------|
| RTX 4080 GPU | ~15s | ~55s | ~25s |
| RTX 3080 GPU | ~20s | ~75s | ~35s |
| Apple M3 (MPS) | ~45s | ~3min | ~70s |
| Intel i7-13700 CPU | ~5min | ~18min | ~8min |

## 高级用法 / 生产环境加固

### 用于自定义流水线的 Python API

如需编程控制，绕过 CLI 直接使用 Python API：

```python
import torch
import torchaudio
from demucs.pretrained import get_model
from demucs.apply import apply_model

# 加载模型
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = get_model("htdemucs_ft")
model.to(device)
model.eval()

# 加载音频
wav, sr = torchaudio.load("input.mp3")

# 确保立体声
if wav.shape[0] == 1:
    wav = wav.repeat(2, 1)

# 添加批次维度
mix = wav.unsqueeze(0).to(device)

# 使用优化设置进行分离
with torch.no_grad():
    sources = apply_model(
        model,
        mix,
        shifts=1,       # Shift trick：值越高质量越好，速度越慢
        split=True,     # 分块处理（长音频必需）
        overlap=0.25,   # 块之间的重叠
        segment=10,     # 段长度（秒）
        progress=True,
        device=device
    )[0]

# sources 形状：(num_sources, channels, samples)
source_names = model.sources  # ['drums', 'bass', 'other', 'vocals']

# 保存各音轨
for i, name in enumerate(source_names):
    torchaudio.save(f"{name}.wav", sources[i].cpu(), sr)
```

### 批量处理流水线

```python
from pathlib import Path
import subprocess
import json

def batch_separate(input_dir, output_dir, model="htdemucs"):
    """处理目录中的所有音频文件。"""
    input_dir = Path(input_dir)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    audio_exts = {'.mp3', '.wav', '.flac', '.ogg', '.m4a'}
    files = [f for f in input_dir.iterdir() if f.suffix in audio_exts]

    # 在单次 Demucs 调用中处理所有文件
    subprocess.run([
        'demucs', '-n', model,
        '-o', str(output_dir),
        '--mp3',
        '--mp3-bitrate', '320',
        *[str(f) for f in files]
    ], check=True)

    # 生成元数据清单
    manifest = {}
    for f in files:
        base = f.stem
        stem_dir = output_dir / model / base
        manifest[base] = {
            'drums': str(stem_dir / 'drums.mp3'),
            'bass': str(stem_dir / 'bass.mp3'),
            'other': str(stem_dir / 'other.mp3'),
            'vocals': str(stem_dir / 'vocals.mp3'),
        }

    with open(output_dir / 'manifest.json', 'w') as fp:
        json.dump(manifest, fp, indent=2)

    return manifest

# 使用
batch_separate('./raw_songs/', './stems/', model='htdemucs_ft')
```

### 长文件的内存优化

Demucs 将整个音频文件加载到 GPU 显存中。对于长曲目或显存有限的情况：

```python
# 强制 CPU 卸载大文件
import os
os.environ['PYTORCH_CUDA_ALLOC_CONF'] = 'max_split_size_mb:128'

# 使用更小的分段
sources = apply_model(
    model,
    mix,
    split=True,
    segment=7,      # 从默认 ~10s 减少到 7s
    overlap=0.1,    # 减少重叠
    device=device
)[0]
```

### 监控和日志记录

```python
import logging
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('demucs')

def separate_with_metrics(input_path, output_dir):
    start = time.time()

    separator = Separator(model="htdemucs_ft", device="cuda")
    origin, separated = separator.separate_audio_file(input_path)

    duration = time.time() - start
    logger.info(f"分离 {input_path} 耗时 {duration:.1f} 秒")

    # 记录各音轨电平
    for name, audio in separated.items():
        rms = torch.sqrt(torch.mean(audio ** 2)).item()
        logger.info(f"  {name}: RMS={rms:.4f}")

    return separated
```

## 与替代方案对比

| 特性 | Demucs (v4) | Ultimate Vocal Remover | Spleeter | Open-Unmix |
|------|-------------|------------------------|----------|------------|
| **架构** | 混合波形 + 频谱图 + Transformer | GUI 封装（多后端） | 频谱图 U-Net | 频谱图 LSTM |
| **MUSDB SDR** | 7.8 dB (htdemucs_ft) | N/A（使用 Demucs/MDX） | 5.9 dB | 5.3 dB |
| **最大音轨数** | 6（人声、鼓、贝斯、吉他、钢琴、其他） | 4（取决于模型） | 5（含 sides） | 4 |
| **是否需要 GPU** | 推荐 | 推荐 | 可选 | 可选 |
| **处理速度** | ~4–16 倍实时 (GPU) | ~3–10 倍实时 (ensemble) | ~100 倍实时 | ~80 倍实时 |
| **显存占用** | 5–8 GB | 6–12 GB (ensemble) | <2 GB | <2 GB |
| **活跃开发** | 社区分支 | 活跃 | 已归档 (2021) | 仅维护 |
| **许可证** | MIT | MIT | MIT | MIT |
| **最适合** | 质量优先的分离 | 易用 GUI + ensemble | 快速批量处理 | 轻量级部署 |

**选择建议**：当你需要最大分离质量并构建自动化流水线时直接使用 Demucs。需要 GUI 和 ensemble 处理时使用 UVR。仅在受限硬件上追求最大速度或维护遗留代码时使用 Spleeter。Open-Unmix 仍适用于教育目的和资源受限的边缘部署。

## 局限性 / 诚实评估

Demucs 并非适合所有音频任务。以下是它不太擅长的领域：

**实时分离**：即使最快的 Demucs 模型（`htdemucs`）在 RTX 4080 上也仅能达到约 16 倍实时处理速度。这对于现场演出或实时流媒体应用来说太慢了。Spleeter 或专门的 ONNX 导出更适合对延迟敏感的使用场景。

**吉他和钢琴隔离**：`htdemucs_6s` 模型尝试将吉他和钢琴作为独立音轨分离，但这些声源的 SDR 显著低于主要四种音轨。如果你的主要需求是隔离特定吉他轨道，Basic Pitch 等专业转录工具可能更合适。

**高度压缩的母带**：响度最大化的重限幅音轨（现代 EDM 和流行乐常见）会产生频率掩蔽，使分离模型产生混淆。Demucs 在这些音轨上可能产生伪影 —— 旋转声、跨源串音 —— 在动态范围更大的混音上则不会出现。

**模型大小**：`htdemucs_ft` 约 2 GB，比 Spleeter（~150 MB）大一个数量级。这对边缘部署、移动应用和有冷启动限制的无服务器环境来说是个问题。

**上游仓库已归档**：原始的 `facebookresearch/demucs` 仓库已归档且不再维护。虽然 `adefossez/demucs` 仍然活跃，但长期维护方向不明确。请将此因素纳入依赖规划中。

## 常见问题

**Q: 运行 Demucs 需要什么硬件？**
A: Demucs 可以在 CPU 上运行，但强烈建议使用 6 GB 以上显存的 NVIDIA GPU。`htdemucs` 模型需要 5.2 GB 显存，`htdemucs_ft` 需要 8 GB。纯 CPU 处理可行，但一首 4 分钟的歌曲处理时间约为 5–20 分钟，而 GPU 不到一分钟。

**Q: 我可以将 Demucs 用于商业用途吗？**
A: 可以。Demucs 采用 MIT 许可证，允许无限制的商业使用、修改和分发。分离后的音轨可用于商业发布。请注意 MIT 许可证适用于代码和模型，而不适用于你处理的音乐的版权。

**Q: 为什么 Demucs 听起来比 Spleeter 更好？**
A: Demucs 同时在时域和频域处理音频，保留了纯频谱方法丢弃的相位信息。Transformer 层也比 Spleeter 的 U-Net 更好地建模长距离音乐依赖关系。这转化为更少的伪影和更少的跨源干扰。

**Q: 如何高效处理整张专辑？**
A: 将多个文件传递给单次 Demucs 调用：`demucs -n htdemucs *.mp3`。Demucs 会顺序处理它们，但避免了重复的模型加载开销。如需最大吞吐量，在不同 GPU 上运行多个 Demucs 实例，或使用高级用法部分提供的批量处理脚本。

**Q: Demucs 支持哪些音频格式？**
A: Demucs 使用 FFmpeg 解码和 torchaudio 编码。输入：MP3、WAV、FLAC、OGG、M4A 以及 FFmpeg 支持的任何格式。输出：WAV（默认，16 位）、float32 WAV（`--float32`）、24 位 WAV（`--int24`）或 MP3（`--mp3`，比特率可调）。

**Q: 我可以在自己的数据上微调 Demucs 吗？**
A: 可以，但需要完整的训练流水线。你需要训练歌曲的独立音轨（与 MUSDB18-HQ 格式相同），然后使用 Dora 实验管理器运行 `dora run -d solver=htdemucs dset=your_dataset`。大多数用户不需要这样做 —— 预训练模型跨流派泛化得很好。

**Q: `htdemucs` 和 `htdemucs_ft` 有什么区别？**
A: `htdemucs_ft` 使用额外训练数据按声源进行微调，默认启用 shift trick。它在所有声源上达到约 0.7 dB 更高的 SDR，但运行速度约慢 4 倍，显存占用增加 50%。快速迭代时使用 `htdemucs`，最终生产级输出时使用 `htdemucs_ft`。

## 结论

Demucs 在 2026 年仍然是开源音乐源分离的参考实现。其混合 Transformer 架构在标准基准上比 Spleeter 高出 20–40% 的分离质量，并能与声音转换流水线、卡拉OK生成器和音频制作工具无缝集成。

对于构建音频流水线的开发者，Demucs 提供了文档完善的 Python API、Docker 支持和针对不同速度/质量权衡的多种模型变体。MIT 许可证消除了商业摩擦。主要注意事项是硬件要求（强烈推荐 GPU）、模型大小（~2 GB）以及上游仓库的归档状态。

**行动项**：使用 `pip install -U demucs` 安装 Demucs，用 `demucs -n htdemucs_ft song.mp3` 在测试曲目上运行首次分离，并使用上面 Python API 示例将其集成到你的流水线中。如需 GUI 体验，下载 Ultimate Vocal Remover 并使用其 ensemble 模式。

**加入 dibi8.com Telegram 群组，获取每周开源 AI 工具深度解析：[https://t.me/dibi8channel](https://t.me/dibi8channel)**



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 参考与延伸阅读

- [Demucs GitHub 仓库 (Meta, 已归档)](https://github.com/facebookresearch/demucs)
- [Demucs 活跃分支 (adefossez)](https://github.com/adefossez/demucs)
- [Hybrid Transformers for Music Source Separation (论文)](https://arxiv.org/abs/2211.08553)
- [MUSDB18-HQ 基准数据集](https://zenodo.org/record/3338373)
- [Ultimate Vocal Remover GUI](https://github.com/Anjok07/ultimatevocalremovergui)
- [Spleeter (Deezer, 已归档)](https://github.com/deezer/spleeter)
- [Open-Unmix (Sony)](https://github.com/sigsep/open-unmix-pytorch)
- [MVSEP 质量检测排行榜](https://mvsep.com/quality_checker/)
- [Audio Developers Conference 2025 — Demucs ONNX 导出演讲](https://mixxx.discourse.group/t/gsoc-2025-converting-demucs-v4-hybrid-transformer-ai-model-to-onnx-format/32874)
