---
title: 'RVC: 35K+ Stars 部署 AI 语音转换 — 2026 年 10 分钟训练指南'
description: 'RVC (Retrieval-based Voice Conversion) 是基于 VITS 的语音转换框架，兼容 GPT-SoVITS、Coqui TTS 和 demucs。本教程涵盖 Docker 部署、训练流程、API 集成和生产级加固。'
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
github_repo: 'https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI'
stars: 35700
maintainer: 'RVC-Project'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['rvc', '语音转换', 'ai语音克隆', 'vits', '语音合成', 'docker', '教程', '检索式语音转换']
aliases:
- /zh/posts/rvc/
---

{{</* resource-info */>}}

![RVC Logo](https://raw.githubusercontent.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/main/assets/rvc_logo.png)

## 引言

你需要一个能在 10 分钟内完成训练、单 GPU 运行、输出广播级质量的语音转换流水线。开源生态已经产出了数十种语音克隆工具，但大多数需要数小时训练、海量数据集，或者按分钟计费的云 API。RVC（Retrieval-based Voice Conversion，检索式语音转换），一个基于 VITS 的框架，在 GitHub 上拥有 35,700+ Stars，仅需 10 分钟干净音频即可将训练时间压缩到 10 分钟以内。本文将带你完成一个生产级的 RVC 搭建 — Docker 部署、训练流水线、API 集成，以及上线前必需的加固步骤。

## 什么是 RVC？

RVC 是一个开源语音转换框架，可以将一个人的声音转换为另一个人的声音，同时保留说话内容、语调和节奏。它基于 VITS 构建，并集成了检索式特征匹配模块，在消费级 GPU 上训练时间低于 10 分钟，支持最低 90ms 延迟的实时推理。

## RVC 的工作原理

RVC 的架构由四个核心模块组成：

**内容特征提取（Content Feature Extraction）** — 使用 ContentVec（HuBERT 的解耦变体）从源音频中提取与说话人无关的语音学和语言学特征。ContentVec 剥离说话人身份信息，同时保留内容信息，使其成为语音转换任务的理想选择。

**音高提取（Pitch Extraction）** — 采用 RMVPE（Robust Model for Vocal Pitch Estimation，鲁棒人声音高估计模型），该模型在 Interspeech 2023 上发布，用于提取基频（F0）。RMVPE 可以处理复调音频，即使在声源分离不完美的情况下也能准确提取音高。

**声学模型（Acoustic Modeling）** — 基于 VITS（Variational Inference with adversarial learning for end-to-end Text-to-Speech），一种条件 VAE，通过标准化流进行增强。VITS 通过生成器与多周期判别器之间的对抗训练生成高保真音频。

**检索模块（Retrieval Module）** — RVC 的标志性创新。训练期间，内容特征被索引到 Faiss 向量数据库中。推理时，源特征被替换为训练集中 Top-K 个最近邻（默认 K=8），显著减少源说话人的音色泄漏。`index_rate` 参数（α，通常为 0.3）控制检索特征与源特征的混合比例。

![RVC 架构图](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/raw/main/docs/rvc_arch.png)

## 安装与配置

### 前置条件

RVC 可在 Linux、macOS 和 Windows 上运行。训练需要至少 4GB 显存的 NVIDIA GPU（推荐 8GB+）。仅推理时，CPU 也能以可接受的延迟运行。

**最低硬件要求：**
- GPU：NVIDIA GTX 1660 6GB / RTX 2060 8GB（训练）；4GB 显存（仅推理）
- CPU：4 核 Intel/AMD 处理器
- 内存：8GB 最低，推荐 16GB
- 存储：10GB 可用空间用于模型和依赖

### 方法一：Docker 部署（生产环境推荐）

官方 Dockerfile 使用 CUDA 11.6.2 + Ubuntu 20.04 + Python 3.9：

```bash
# 克隆仓库
git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git
cd Retrieval-based-Voice-Conversion-WebUI

# 构建 Docker 镜像
docker build -t rvc-webui:latest .

# 使用 GPU 支持和卷挂载运行
docker run -d --name rvc \
  --gpus all \
  -p 7865:7865 \
  -v $(pwd)/weights:/app/weights \
  -v $(pwd)/opt:/app/opt \
  rvc-webui:latest
```

docker-compose 用户：

```yaml
version: '3.8'

services:
  rvc:
    build: .
    container_name: rvc-webui
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    ports:
      - "7865:7865"
    volumes:
      - ./weights:/app/weights
      - ./opt:/app/opt
      - ./assets:/app/assets
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    restart: unless-stopped
```

```bash
# 使用 docker-compose 启动
docker-compose up -d

# 查看日志
docker-compose logs -f rvc
```

### 方法二：本地 Python 安装

```bash
# 克隆仓库
git clone https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI.git
cd Retrieval-based-Voice-Conversion-WebUI

# 创建虚拟环境
python3 -m venv venv
source venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 下载预训练模型
python tools/download_models.py

# 或手动从 HuggingFace 下载
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/D40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/G40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0D40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/pretrained_v2/f0G40k.pth -P assets/pretrained_v2/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/hubert_base.pt -P assets/hubert/
wget https://huggingface.co/lj1995/VoiceConversionWebUI/resolve/main/rmvpe.pt -P assets/rmvpe/
```

### 方法三：AMD GPU 安装（ROCm）

```bash
# 安装 ROCm 依赖（Ubuntu/Debian）
sudo apt install rocm-hip-sdk rocm-opencl-sdk

# 设置环境变量
export ROCM_PATH=/opt/rocm
export HSA_OVERRIDE_GFX_VERSION=10.3.0

# 将用户添加到 render 和 video 组
sudo usermod -aG render $USER
sudo usermod -aG video $USER

# 安装 AMD 专用依赖
pip install -r requirements-amd.txt
```

### 启动 WebUI

```bash
# 启动 Gradio 网页界面
python infer-web.py

# WebUI 将在 http://localhost:7865 可用
```

## 训练流水线

### 第一步：准备数据集

RVC 需要干净、单声道的音频。为获得最佳效果：

- **时长：** 10–30 分钟干净语音（最少 1 分钟也可工作）
- **格式：** WAV，16 位或 24 位，22050Hz 或 40000Hz 采样率
- **内容：** 单一说话人，背景噪音最小，无音乐或混响
- **静音：** 移除长静音片段（> 3 秒）

使用 UVR5（内置）进行声源分离：

```bash
# 从背景音乐中分离人声
python tools/uvr5/uvr5_cli.py \
  --input_path ./raw_audio/song_with_music.wav \
  --output_path ./dataset/ \
  --model_name "HP2-人声vocals+非人声instrumentals"
```

### 第二步：预处理和特征提取

在 WebUI 的 **训练** 标签页中：

1. 设置 **实验名称**（例如 `my_voice_v2`）
2. 设置 **目标采样率** 为 40kHz（推荐）
3. 设置 **RVC 版本** 为 v2
4. 设置 **模型架构** 为 `rmvpe_gpu`
5. 设置 **数据集路径** 为你的音频文件夹
6. 点击 **一键训练**

或通过命令行：

```bash
# 第一步：预处理（重采样、切片、去除静音）
python trainset_preprocess_pipeline_print.py \
  ./dataset/my_voice \
  40000 \
  8  # CPU 线程数

# 第二步：使用 ContentVec 提取特征
python extract_feature_print.py \
  --model_name my_voice_v2 \
  --sample_rate 40000 \
  --pitch_extractor rmvpe \
  --gpu 0

# 第三步：训练模型
python train_nsf_sim_cache_sid_load_pretrain.py \
  --model_name my_voice_v2 \
  --sample_rate 40000 \
  --batch_size 8 \
  --total_epoch 200 \
  --save_every_epoch 5 \
  --pretrained_G assets/pretrained_v2/f0G40k.pth \
  --pretrained_D assets/pretrained_v2/f0D40k.pth \
  --gpu 0
```

### 第三步：构建特征索引

```bash
# 为检索生成 Faiss 索引
python tools/infer/train_index.py \
  --model_name my_voice_v2 \
  --sample_rate 40000
```

训练输出位置：

```
logs/
└── my_voice_v2/
    ├── added_IVF512_Flat_nprobe_1.index   # Faiss 检索索引
    ├── G_*.pth                             # 生成器检查点
    ├── D_*.pth                             # 判别器检查点
    └── config.json                         # 模型配置
```

![RVC WebUI 训练标签页](https://raw.githubusercontent.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/main/docs/en/training_tab.png)

### 训练基准测试

| 硬件 | 数据集大小 | 轮数 | 训练时间 | 输出质量 |
|------|-----------|------|----------|----------|
| RTX 3090 (24GB) | 10 分钟音频 | 200 | ~18 分钟 | 极佳 |
| RTX 4090 (24GB) | 10 分钟音频 | 200 | ~12 分钟 | 极佳 |
| RTX 3060 (12GB) | 10 分钟音频 | 200 | ~35 分钟 | 很好 |
| GTX 1660 (6GB) | 10 分钟音频 | 200 | ~90 分钟 | 良好 |
| Colab T4 (16GB) | 10 分钟音频 | 200 | ~40 分钟 | 很好 |

## 与流行工具集成

### 集成一：GPT-SoVITS（TTS + RVC 流水线）

GPT-SoVITS 从文本生成语音；RVC 将其转换为目标声音。两者结合形成完整的文本到语音克隆流水线：

```python
# gpt_sovits_rvc_pipeline.py
import requests

def tts_then_convert(text: str, speaker_wav: str, rvc_model: str):
    """GPT-SoVITS TTS → RVC 语音转换流水线"""
    
    # 第一步：使用 GPT-SoVITS 生成语音
    tts_response = requests.post("http://localhost:9880/tts", json={
        "text": text,
        "refer_wav_path": speaker_wav,
        "prompt_text": "参考提示文本",
        "prompt_language": "zh",
        "text_language": "zh"
    })
    
    with open("/tmp/tts_output.wav", "wb") as f:
        f.write(tts_response.content)
    
    # 第二步：使用 RVC API 转换语音
    rvc_response = requests.post("http://localhost:7865/voice_conversion", json={
        "input_audio": "/tmp/tts_output.wav",
        "model_name": rvc_model,
        "pitch_shift": 0,
        "index_rate": 0.75,
        "filter_radius": 3,
        "volume_envelope": 0.25
    })
    
    return rvc_response.json()["output_path"]
```

### 集成二：Coqui TTS

```python
# coqui_rvc_bridge.py
from TTS.api import TTS
import requests

def coqui_to_rvc(text: str, rvc_model: str, output_path: str):
    # 使用 Coqui XTTS v2 生成
    tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2", gpu=True)
    tts.tts_to_file(
        text=text,
        speaker_wav="reference.wav",
        language="zh",
        file_path="/tmp/coqui_out.wav"
    )
    
    # 通过 RVC 转换
    with open("/tmp/coqui_out.wav", "rb") as f:
        files = {"file": f}
        data = {"model_name": rvc_model, "pitch": 0, "index_rate": 0.5}
        response = requests.post(
            "http://localhost:7865/api/voice_conversion",
            files=files, data=data
        )
    
    with open(output_path, "wb") as f:
        f.write(response.content)
    return output_path
```

### 集成三：demucs（高级声源分离）

用于训练前的生产级人声隔离：

```bash
# 安装 demucs
pip install demucs

# 使用 demucs 分离人声（复杂混音中比 UVR5 质量更好）
demucs --two-stems=vocals --mp3 --mp3-bitrate 320 input_song.mp3

# 使用分离的人声轨道进行 RVC 训练
mv separated/htdemucs/input_song/vocals.wav ./dataset/clean_voice.wav
```

### 集成四：实时语音转换 GUI

RVC 包含用于直播应用的实时语音转换 GUI：

![RVC 实时 GUI](https://raw.githubusercontent.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/main/assets/gui_preview.png)

```bash
# 启动实时 GUI
python gui_v1.py

# 或使用 DirectML 支持 AMD/Intel GPU
python gui_v1.py --dml

# 低延迟关键参数：
# - 块时间：0.25s（越低延迟越小，CPU 占用越高）
# - 交叉淡入淡出：0.05s
# - 额外时间：2.5s
# - 音高提取器：fcpe（最快）或 rmvpe（质量最好）
```

流式配置（使用 ASIO 实现 90ms 端到端延迟）：

```python
# gui_config.py 示例
config = {
    "block_time": 0.1,        # 100ms 块以降低延迟
    "crossfade_time": 0.04,
    "extra_time": 2.0,
    "f0method": "fcpe",       # 最快的音高提取器
    "rms_mix_rate": 0.25,
    "index_rate": 0.3,
    "pitch": 0,
    "I_noise_reduce": True,
    "O_noise_reduce": False
}
```

### 集成五：API 服务器（FastAPI）

RVC 为生产部署提供基于 FastAPI 的 REST API：

```bash
# 启动 API 服务器
python api_240604.py

# API 将在 http://localhost:7865 可用
```

```python
# API 推理客户端示例
import requests

# 首先加载模型
requests.post("http://localhost:7865/load_model", json={
    "pth_path": "./weights/my_voice_v2.pth",
    "index_path": "./logs/my_voice_v2/added_IVF512_Flat_nprobe_1.index"
})

# 执行语音转换
with open("input_audio.wav", "rb") as f:
    response = requests.post(
        "http://localhost:7865/voice_conversion",
        files={"file": f},
        data={
            "pitch": 0,
            "index_rate": 0.75,
            "filter_radius": 3,
            "volume_envelope": 0.25,
            "protect": 0.33
        }
    )

with open("converted_output.wav", "wb") as f:
    f.write(response.content)
```

## 基准测试 / 实际应用案例

### 客观质量指标

| 指标 | RVC v2 | So-VITS-SVC 4.1 | GPT-SoVITS (SVC) | DDSP-SVC |
|------|--------|-----------------|-------------------|----------|
| 说话人相似度（余弦） | 0.85 | 0.79 | 0.82 | 0.71 |
| PESQ（质量，/4.5） | 3.6 | 3.3 | 3.4 | 2.8 |
| UTMOS（自然度，/5） | 4.19 | 3.95 | 4.05 | 3.45 |
| 训练时间（10分钟数据，RTX 3090） | ~18 分钟 | ~2 小时 | ~45 分钟 | ~15 分钟 |
| 最低训练数据量 | 1 分钟 | 10 分钟 | 1 分钟 | 5 分钟 |
| 实时因子（推理） | 0.05x | 0.15x | 0.08x | 0.02x |

### 生产应用案例

**AI 音乐翻唱** — 将人声轨道转换为模仿特定艺术家声音，用于娱乐内容。RVC 的 RMVPE 音高提取即使在复杂声乐演唱中也能保持准确的旋律再现。

**直播变声** — 为内容创作者提供实时语音变换。配合 GUI 和 ASIO 驱动，端到端延迟低至 90ms，大多数观众无法感知。

**隐私保护** — 在录制的采访、呼叫中心音频和敏感语音数据中匿名化说话人身份，同时保留情感内容和可理解性。

**内容本地化** — 在与 TTS 流水线结合时，在跨语言配音视频内容的同时保持原始说话人的声音特征。

**语音数据集增强** — 为低资源语言的 ASR 系统生成合成训练数据，学术研究表明经过 200 轮训练后 KL 散度损失可达 0.68。

## 高级用法 / 生产加固

### 安全注意事项

```python
# api_production.py — 加固版 API 包装器
from fastapi import FastAPI, HTTPException, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
import hashlib

security = HTTPBearer()

def verify_token(credentials: HTTPAuthorizationCredentials):
    """验证生产部署的 API 令牌"""
    expected = hashlib.sha256(TOKEN.encode()).hexdigest()
    if credentials.credentials != expected:
        raise HTTPException(status_code=401, detail="无效的令牌")
    return True

@app.post("/voice_conversion")
async def secure_convert(
    file: UploadFile,
    credentials: HTTPAuthorizationCredentials = Depends(security)
):
    verify_token(credentials)
    # ... 转换逻辑
    return {"output_url": signed_url}
```

### 模型管理

```bash
# 组织多个语音模型
models/
├── celeb_voice_a/
│   ├── model.pth
│   ├── index.faiss
│   └── config.json
├── celeb_voice_b/
│   ├── model.pth
│   ├── index.faiss
│   └── config.json
└── custom_brand_voice/
    ├── model.pth
    ├── index.faiss
    └── config.json
```

```python
# 多租户部署的动态模型加载器
import os
import glob

def list_available_models(models_dir="./models"):
    """列出所有可用的语音模型"""
    models = []
    for model_dir in glob.glob(os.path.join(models_dir, "*/")):
        name = os.path.basename(os.path.dirname(model_dir))
        pth_files = glob.glob(os.path.join(model_dir, "*.pth"))
        index_files = glob.glob(os.path.join(model_dir, "*.faiss")) + \
                      glob.glob(os.path.join(model_dir, "*.index"))
        if pth_files and index_files:
            models.append({"name": name, "pth": pth_files[0], "index": index_files[0]})
    return models
```

### 监控与日志

```python
# monitoring.py — 兼容 Prometheus 的指标
from prometheus_client import Counter, Histogram, start_http_server
import time

conversion_count = Counter('rvc_conversions_total', '总转换次数')
conversion_duration = Histogram('rvc_conversion_seconds', '转换延迟')
error_count = Counter('rvc_errors_total', '总错误数', ['error_type'])

def monitored_convert(audio_path, model_name):
    start = time.time()
    try:
        result = perform_conversion(audio_path, model_name)
        conversion_count.inc()
        return result
    except Exception as e:
        error_count.labels(error_type=type(e).__name__).inc()
        raise
    finally:
        conversion_duration.observe(time.time() - start)

# 启动指标端点
start_http_server(9090)
```

### 导出 ONNX 加速推理

```bash
# 将训练好的模型导出为 ONNX，实现 CPU/GPU 通用推理
python tools/export_onnx.py \
  --checkpoint_path ./logs/my_voice_v2/G_12000.pth \
  --output_path ./models/my_voice_v2/model.onnx \
  --sample_rate 40000
```

## 与替代方案对比

| 特性 | RVC v2 | GPT-SoVITS | So-VITS-SVC 4.1 | DDSP-SVC |
|------|--------|------------|-----------------|----------|
| **主要用途** | 语音转换 | TTS + 语音克隆 | 歌声转换 | 歌声转换 |
| **训练时间**（10分钟数据） | ~18 分钟 (RTX 3090) | ~45 分钟 | ~2 小时 | ~15 分钟 |
| **最低 GPU 显存**（训练） | 4GB | 8GB | 8GB | 4GB |
| **最低训练数据** | 1 分钟 | 1 分钟 | 10 分钟 | 5 分钟 |
| **音高提取器** | RMVPE / FCPE | RMVPE | Harvest / Crepe | Harvest / Crepe |
| **内容编码器** | ContentVec (768维) | HuBERT / ContentVec | ContentVec | ContentVec |
| **检索模块** | Faiss top-K (K=8) | 无检索 | Faiss top-K (4.1 新增) | 无检索 |
| **实时推理** | 支持 (90ms 延迟) | 不支持 | 支持 (w-okada) | 支持 |
| **声码器** | NSF-HiFi-GAN | NSF-HiFi-GAN | NSF-HiFi-GAN | DDSP + HiFi-GAN |
| **模型融合** | 支持 (ckpt 合并) | 不支持 | 不支持 | 不支持 |
| **UVR5 集成** | 内置 | 单独安装 | 单独安装 | 单独安装 |
| **许可证** | MIT | MIT | BSD-3-Clause | Apache-2.0 |
| **GitHub Stars** | 35,700+ | 43,000+ | 21,200+ | 2,800+ |
| **最后更新** | 2024-06 | 2025-04 | 2023-12 (已归档) | 2024-03 |

**选择 RVC 的场景：** 需要快速训练、实时转换，或检索式特征匹配以最小化音色泄漏。RVC 是生产级语音转换流水线的务实之选。

**选择 GPT-SoVITS 的场景：** 需要文本到语音的语音克隆（非音频到音频转换）。GPT-SoVITS 在使用 1 分钟参考音频从文本生成语音方面表现出色。

**选择 So-VITS-SVC 的场景：** 需要带浅扩散后处理的旧版歌声转换。注意：该项目已归档，不再维护。

**选择 DDSP-SVC 的场景：** 资源使用最少化的轻量级歌声转换。质量低于 RVC，但可在较弱硬件上运行。

## 局限性 / 诚实评估

RVC 是一个能力很强的工具，但并非适用于所有语音应用场景：

**不支持文本转语音。** RVC 是音频到音频的转换，无法从文本生成语音。需要与 GPT-SoVITS、Coqui TTS 或 Edge-TTS 结合才能构成完整的 TTS 流水线。

**说话人相似度上限。** 虽然 RVC 能生成令人信服的转换，但与 ElevenLabs Voice Cloning 或 Microsoft Azure Speech Studio 等商业解决方案相比，保真度仍有差距。对于企业级语音克隆，付费 API 仍然领先。

**情感控制局限。** RVC 保留源音频的情感和韵律，但无法独立操控情感表达。CosyVoice 3 或 Seed-VC 等工具提供更细粒度的韵律控制。

**训练硬件要求。** 尽管比替代方案更高效，训练仍需要独立 NVIDIA GPU。CPU 训练不现实（慢 50 倍以上）。云 GPU 实例会增加运营成本。

**伦理与法律风险。** 语音克隆技术可能被滥用于深度伪造音频、欺诈和冒充。RVC 不包含内置水印或安全机制。生产部署应实施同意验证、审计日志和合成音频水印。

**语言支持缺口。** RVC 对主要语言（英语、中文、日语、韩语）效果很好，但对声调语言（泰语、越南语）和预训练模型覆盖有限的低资源语言，质量会下降。

## 常见问题

### RVC 需要多少训练数据？
RVC 最少可以使用 1 分钟干净音频进行训练，但 10–30 分钟会显著改善效果。关键在于音频质量而非数量。10 分钟的录音室录制优于 2 小时的嘈杂电话录音。尽量降低背景噪音、音乐和混响。

### RVC 可以只用 CPU 运行吗？
仅推理可以。训练需要支持 CUDA 的 GPU。CPU 推理比 GPU 慢 10–20 倍，但对于延迟不敏感的批处理任务可以工作。实时转换强烈建议使用至少 4GB 显存的 GPU。

### RVC v1 和 v2 有什么区别？
RVC v2 将内容编码器从 9 层 HuBERT 的 256 维特征改为 12 层 HuBERT 的 768 维特征，并增加了 3 个周期判别器以改善音频质量。所有新项目应专门使用 v2 模型。v2 预训练模型与 v1 不向后兼容。

### 如何减少转换音频中的音色泄漏？
调整 **index_rate** 参数。较高的值（0.7–1.0）增加对检索索引的依赖，从训练集中获取更多特征，从源音频获取更少。从 0.75 开始，根据输出质量调整。如果声音听起来不自然，降低到 0.3–0.5。

### 可以在 Discord/Zoom/游戏中使用 RVC 实时变声吗？
可以，通过 RVC 实时 GUI（`gui_v1.py`）。将麦克风通过虚拟音频线路由（Windows 用 VB-Cable，macOS 用 BlackHole，Linux 用 PulseAudio），将 RVC 设为输入设备，并配置应用程序使用虚拟音频线输出。使用 ASIO 驱动和现代 GPU，延迟保持在 100ms 以下。

### RVC 支持哪些文件格式？
RVC 支持 WAV、MP3、FLAC、OGG 和 M4A 作为输入。输出始终是目标采样率（32kHz、40kHz 或 48kHz）的 WAV。为获得最佳质量，使用无损 WAV 或 FLAC 作为输入，避免多次重新编码 MP3 文件。

### 如何融合两个语音模型？
在 WebUI 中使用 **ckpt 合并** 标签页。加载两个 .pth 模型文件并设置混合比例（0.0 = 100% 模型 A，1.0 = 100% 模型 B，0.5 = 均等混合）。合并后的模型继承两个声音的特征。这在创建混合声音时效果很好，无需重新训练。

### 为什么转换后的声音听起来机械化或失真？
常见原因：(1) 训练数据或轮数不足 — 至少训练 200 轮；(2) 输入音频有噪音 — 使用 UVR5 或 demucs 进行声源分离；(3) 音高提取器不正确 — 语音用 rmvpe，歌声用 harvest；(4) 采样率不匹配 — 确保推理与训练采样率一致。

## 结论

RVC 在中等硬件上提供训练时间低于 20 分钟的生产级语音转换。其检索式架构比直接特征映射产生更干净的语音分离，FastAPI 服务器支持与现有音频流水线的直接集成。对于构建语音应用的开发者来说，RVC 在开源生态中提供了质量、速度和部署灵活性的最佳平衡。

**下一步：** 克隆仓库，运行 Docker 搭建，用 10 分钟干净音频训练你的第一个模型。加入 Telegram 上的 RVC 社区分享模型并获取支持：[t.me/RVCSpace](https://t.me/RVCSpace)。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [RVC GitHub 仓库](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI)
- [RVC 官方文档](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/blob/main/docs/en/README.en.md)
- [理解 RVC 架构](https://gudgud96.github.io/2024/09/26/annotated-rvc/)
- [RVC Docker 安装指南](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/blob/main/Dockerfile)
- [RVC API 参考 (api_240604.py)](https://github.com/RVC-Project/Retrieval-based-Voice-Conversion-WebUI/blob/main/api_240604.py)
- [GPT-SoVITS 仓库](https://github.com/RVC-Boss/GPT-SoVITS)
- [ContentVec 论文](https://arxiv.org/abs/2204.09224)
- [RMVPE 音高提取论文](https://arxiv.org/abs/2306.15412v2)
- [VITS 论文](https://arxiv.org/abs/2106.06103)
- [DDSP-SVC 仓库](https://github.com/yxlllc/DDSP-SVC)
- [So-VITS-SVC 4.1 (已归档)](https://github.com/svc-develop-team/so-vits-svc)
- [使用 RVC 的低资源 ASR 数据增强](https://arxiv.org/abs/2311.14836)
- [LLVC: CPU 上的低延迟实时语音转换](https://arxiv.org/abs/2311.00873)
- [RVC 推理设置参考](https://docs.aihub.gg/rvc/resources/inference-settings/)
- [PetVocalia: 零样本 SVC 基准测试 (IJCAI 2025)](https://www.ijcai.org/proceedings/2025/1135.pdf)
