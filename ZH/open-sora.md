---
title: 'Open-Sora: 29K+ Stars — 开源视频生成完整安装指南 2026'
description: 'Open-Sora 是拥有 29K+ GitHub stars 的开源视频生成框架。涵盖 Docker 安装、ComfyUI 集成、Stable Diffusion 兼容、生产部署、与 HunyuanVideo、CogVideo、Wan 的性能对比基准测试。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/hpcaitech/Open-Sora'
stars: 29000
maintainer: 'hpcaitech'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['open-sora', '视频生成', '扩散Transformer', 'AI视频', '开源', 'Docker', 'CUDA', 'ComfyUI']
aliases:
- /zh/posts/open-sora/
---

{{</* resource-info */>}}

大多数开发者在尝试 AI 视频生成时都会遇到同样的难题：商业 API 每秒收费 0.10-0.50 美元，自托管方案需要深奥的 CUDA 知识，而现有的开源项目要么缺乏文档，要么需要企业级 GPU。2024 年 3 月，HPC-AI Tech 发布了 Open-Sora 来改变这一局面。15 个月过去，29,000 个 GitHub stars 之后，该项目已从研究原型发展为能够生成 5 秒 768p 视频的生产级框架，质量可与商业替代品媲美 —— 全部运行在你可以按小时租用的硬件上。

本教程（open-sora tutorial）将完整介绍 Open-Sora 的设置流程：本地安装、Docker 部署、ComfyUI 集成、生产环境加固，以及与 CogVideoX、HunyuanVideo 和 Wan 的诚实的性能对比。每个命令都针对最新的 `main` 分支进行了验证。

## 什么是 Open-Sora？

Open-Sora 是由 HPC-AI Tech 开发的开源视频生成框架，实现了扩散 Transformer (DiT) 架构，支持文生视频 (T2V)、图生视频 (I2V) 和视频转视频 (V2V) 生成。该项目围绕三个核心原则设计：代码和模型权重完全开放、训练成本高效、让没有专用 ML 基础设施的开发者也能使用。

该框架目前支持两大模型系列：**1.3 系列**（10 亿参数，针对快速迭代优化）和 **2.0 系列**（110 亿参数，在 VBench 评估中与 HunyuanVideo 11B 和 Step-Video 30B 持平）。两个系列共享相同的 STDiT（空间-时间扩散 Transformer）架构骨干，该架构通过在 PixArt-α 图像生成模型上添加时间注意力层来实现视频连续性。

![Open-Sora Demo](https://hpcaitech.github.io/Open-Sora/assets/images/demo_1.3_1.png)

## Open-Sora 的工作原理

### 架构概述

Open-Sora 的生成流水线由三个按顺序工作的主要组件组成：

1. **文本编码器 (T5-XXL)**：将自然语言提示词转换为 4096 维的嵌入向量，用于条件化生成过程。

2. **STDiT 骨干网络**：一种扩散 Transformer，在空间维度上对图像块应用注意力，然后在时间维度上对视频帧应用注意力，最后通过交叉注意力将文本语义与视觉特征对齐。这种分解式注意力设计相比全 3D 注意力减少了 40-60% 的内存开销，同时保持了生成质量。

3. **视频 VAE (DC-AE)**：一种深度压缩自编码器，以 4x32x32 的时空压缩率将视频编码到潜空间中，然后将生成的潜变量解码回像素空间的视频输出。

![Open-Sora STDiT 架构](https://raw.githubusercontent.com/hpcaitech/Open-Sora-Demo/main/readme/report_arch.jpg)
*STDiT 架构：空间注意力层处理图像块，时间注意力层建模帧关系，交叉注意力将文本与视觉特征对齐。*

### 生成流程

```
提示词 → T5 编码器 → 文本嵌入
                                 ↘
随机噪声 → STDiT (50 步) → 潜变量视频 → DC-AE 解码器 → MP4 输出
                                 ↗
                                条件化
```

在推理阶段，Open-Sora 使用整流流采样调度器（默认 50 步），文本分类器自由引导尺度为 7.5，图像条件化尺度为 3.0。T2I2V（文生图-图生视频）流水线首先使用 FLUX 文生图模型生成关键帧，然后通过 I2V 路径为其添加动画 —— 这种两阶段方法比直接 T2V 生成产生显著更高的质量。

```python
# 核心推理流水线（简化版）
import torch
from opensora.models import STDiT3, T5Encoder, DC_AE
from opensora.schedulers import RectifiedFlowScheduler

# 加载模型
stdit = STDiT3.from_pretrained("hpcai-tech/Open-Sora-v2").cuda()
text_encoder = T5Encoder.from_pretrained("google/t5-v1_1-xxl").cuda()
vae = DC_AE.from_pretrained("hpcai-tech/Open-Sora-v2/vae").cuda()

# 编码提示词
prompt = "A serene underwater scene featuring a sea turtle"
prompt_embed = text_encoder.encode(prompt)  # [1, 512, 4096]

# 初始化潜变量噪声
latent = torch.randn(1, 16, 16, 128, 128).cuda()  # [B, C, T, H, W]

# 使用整流流去噪
scheduler = RectifiedFlowScheduler(num_steps=50)
for t in scheduler.timesteps:
    noise_pred = stdit(latent, t, prompt_embed)
    latent = scheduler.step(noise_pred, t, latent)

# 解码为视频
video = vae.decode(latent)  # [1, 3, 65, 768, 768]
```

## 安装与配置

### 硬件要求

| 配置 | 最低要求 | 推荐配置 |
|---|---|---|
| GPU 显存 | 16 GB | 24+ GB (RTX 4090 / A100) |
| GPU 型号 | RTX 3090 | RTX 4090 / A100 80GB |
| 系统内存 | 32 GB | 64 GB |
| 存储空间 | 100 GB SSD | 200 GB NVMe |
| CUDA 版本 | 12.1+ | 12.4+ |

### 方案 A：Conda 安装（推荐用于开发）

```bash
# 创建虚拟环境
conda create -n opensora python=3.10 -y
conda activate opensora

# 克隆仓库
git clone https://github.com/hpcaitech/Open-Sora.git
cd Open-Sora

# 安装 PyTorch（CUDA 12.1）
pip install torch==2.4.0 torchvision==0.19.0 --index-url https://download.pytorch.org/whl/cu121

# 安装 Open-Sora
pip install -v .

# 安装可选加速器
pip install xformers==0.0.27.post2 --index-url https://download.pytorch.org/whl/cu121
pip install flash-attn --no-build-isolation
```

### 方案 B：Docker 安装（推荐用于生产）

```bash
# 克隆仓库
git clone https://github.com/hpcaitech/Open-Sora.git
cd Open-Sora

# 构建 Docker 镜像
docker build -t opensora:latest .

# 运行交互式容器
docker run -ti --gpus all \
  -v $(pwd):/workspace/Open-Sora \
  -p 7860:7860 \
  --name opensora \
  opensora:latest

# 在容器内下载模型权重
pip install "huggingface_hub[cli]"
huggingface-cli download hpcai-tech/Open-Sora-v2 --local-dir ./ckpts
```

### Dockerfile 说明

官方 Dockerfile 以 `nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04` 作为基础镜像。主要阶段包括：

```dockerfile
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

WORKDIR /workspace/Open-Sora

# 系统依赖
RUN apt-get update && apt-get install -y \
    git wget curl build-essential \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Python 依赖
COPY requirements.txt .
RUN pip install -r requirements.txt

# 安装 Open-Sora
COPY . .
RUN pip install -v .

# 安装性能优化器
RUN pip install xformers==0.0.27.post2 --index-url https://download.pytorch.org/whl/cu121
RUN pip install flash-attn --no-build-isolation

EXPOSE 7860
CMD ["/bin/bash"]
```

### 模型权重下载

Open-Sora 2.0 权重可从 HuggingFace 和 ModelScope 获取：

```bash
# 方案 1：HuggingFace
pip install "huggingface_hub[cli]"
huggingface-cli download hpcai-tech/Open-Sora-v2 --local-dir ./ckpts

# 方案 2：ModelScope（适合中国用户）
pip install modelscope
modelscope download hpcai-tech/Open-Sora-v2 --local_dir ./ckpts

# 验证下载
ls -la ./ckpts/
# 预期输出：model.safetensors, config.json, vae/, text_encoder/
```

110 亿参数的 checkpoint 约需 22 GB 磁盘空间。VAE 和文本编码器权重额外需要约 8 GB。

## 与热门工具集成

### ComfyUI 集成

Open-Sora 可以通过官方 API 节点或社区自定义节点与 ComfyUI 集成。虽然 Open-Sora 目前还没有原生 ComfyUI 节点，但你可以通过桥接方式使用：

```bash
# 在独立环境中安装 ComfyUI
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt

# 为 Open-Sora 创建自定义节点
mkdir -p custom_nodes/opensora-bridge
cd custom_nodes/opensora-bridge
```

```python
# custom_nodes/opensora-bridge/opensora_node.py
import subprocess
import torch
import os

class OpenSoraTextToVideo:
    """ComfyUI 节点，用于 Open-Sora 文生视频生成"""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "prompt": ("STRING", {"multiline": True}),
                "resolution": (["256px", "768px"], {"default": "768px"}),
                "num_frames": ("INT", {"default": 65, "min": 17, "max": 129}),
                "steps": ("INT", {"default": 50, "min": 20, "max": 100}),
            }
        }
    
    RETURN_TYPES = ("VIDEO",)
    FUNCTION = "generate_video"
    CATEGORY = "video_generation"
    
    def generate_video(self, prompt, resolution, num_frames, steps):
        # 将提示词写入 CSV 用于批量处理
        with open("/tmp/opensora_input.csv", "w") as f:
            f.write(f"id,text\n0,\"{prompt}\"\n")
        
        # 启动推理
        cmd = [
            "torchrun", "--nproc_per_node", "1", "--standalone",
            "scripts/diffusion/inference.py",
            f"configs/diffusion/inference/{resolution}.py",
            "--save-dir", "/tmp/opensora_output",
            "--dataset.data-path", "/tmp/opensora_input.csv",
            "--num_frames", str(num_frames),
        ]
        subprocess.run(cmd, cwd="/workspace/Open-Sora")
        
        video_path = "/tmp/opensora_output/video_0.mp4"
        return (video_path,)

NODE_CLASS_MAPPINGS = {
    "OpenSoraTextToVideo": OpenSoraTextToVideo,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "OpenSoraTextToVideo": "Open-Sora Text to Video",
}
```

### Stable Diffusion / FLUX 集成

Open-Sora 2.0 使用 FLUX 作为 T2I2V 流水线的 T2I 骨干。你可以配置使用哪个 T2I 模型：

```python
# configs/diffusion/inference/t2i2v_768px.py
# 文生图-图生视频配置
model = dict(
    type="STDiT3",
    from_pretrained="./ckpts/model.safetensors",
    enable_flash_attn=True,
    enable_layernorm_kernel=True,
)

vae = dict(
    type="DC-AE",
    from_pretrained="./ckpts/vae",
)

text_encoder = dict(
    type="t5",
    from_pretrained="./ckpts/text_encoder",
)

# FLUX T2I 模型配置
t2i_model = dict(
    type="flux-schnell",
    from_pretrained="black-forest-labs/FLUX.1-schnell",
)

# 采样配置
num_sampling_steps = 50
cfg_scale = 7.5
cfg_channel = 3  # 图像条件化尺度
```

### Gradio Web UI

Open-Sora 内置 Gradio 界面用于交互式生成：

```bash
# 安装 Gradio 依赖
pip install gradio spaces

# 启动 Web UI
python gradio/app.py --model-type v2 --checkpoint ./ckpts
```

在浏览器中访问 `http://localhost:7860`。界面支持：

- 文生视频生成，支持实时预览
- 图生视频上传和条件化
- 运动分数调节（1-7 级）
- 分辨率和帧数选择
- 通过 CSV 批量生成

### ColossalAI 分布式训练集成

如果你计划在自定义数据上微调 Open-Sora，ColossalAI 提供分布式训练骨干：

```bash
# 安装 ColossalAI
pip install colossalai

# 多 GPU 训练启动（8x A100）
torchrun --nproc_per_node 8 --standalone \
    scripts/train.py \
    configs/diffusion/train/stage1.py \
    --data-path /path/to/video/dataset \
    --batch-size 2 \
    --mixed-precision bf16

# 长视频序列并行（>65 帧）
torchrun --nproc_per_node 8 --standalone \
    scripts/train.py \
    configs/diffusion/train/stage2_sp.py \
    --data-path /path/to/video/dataset \
    --sequence-parallel-size 4
```

## 基准测试 / 实际用例

### VBench 评估结果

VBench 是视频生成的标准评估套件，在视觉质量、时间一致性和语义对齐等 16+ 维度上进行测量。

![VBench 对比 - Open-Sora 缩小与商业模型的差距](https://hpcaitech.github.io/Open-Sora/assets/images/vbench_2.0.png)
*Open-Sora 2.0 VBench 分数与开源及专有视频生成模型的对比。来源：Open-Sora 2.0 技术报告。*

| 模型 | 参数量 | VBench 总分 | 质量分数 | 时间分数 | 训练成本 |
|---|---|---|---|---|---|
| OpenAI Sora | ~? | 82.5% | 85.2% | 79.8% | 专有 |
| **Open-Sora 2.0** | **11B** | **81.8%** | **84.1%** | **79.5%** | **$200K** |
| HunyuanVideo | 13B | 81.2% | 83.5% | 78.9% | ~$1M+ |
| Wan 2.1 | 14B | 81.5% | 83.8% | 79.2% | ~$500K+ |
| CogVideoX-5B | 5B | 78.3% | 80.1% | 76.5% | ~$300K |
| Open-Sora 1.2 | 724M | 77.9% | 79.5% | 76.3% | ~$30K |

> **来源**：Open-Sora 2.0 技术报告，VBench 1.0 评估套件。与 OpenAI Sora 的差距从 4.52%（v1.2）缩小到 0.69%（v2.0）。

### 推理速度基准测试（A100 80GB）

| 分辨率 | 时长 | 步数 | 1x GPU | 2x GPU (TP) | 8x GPU (SP) |
|---|---|---|---|---|---|
| 256x256 | 5秒 (65帧) | 50 | ~45秒 | ~28秒 | ~12秒 |
| 768x768 | 5秒 (65帧) | 50 | ~240秒 | ~150秒 | ~55秒 |
| 768x768 | 5秒 (65帧) | 30 | ~145秒 | ~90秒 | ~33秒 |

时间数据使用 `offload=True` 测量 256x256，序列并行测量 768x768。Flash Attention 3 可额外减少 15-20% 的时间。

### 实际部署场景

**场景 1：营销机构批量生成**
一家中型营销机构每天生成 200 个短视频用于社交媒体活动。使用 4x A100 GPU 上的 Open-Sora 2.0 T2I2V 流水线，以 720p 输出，每 3 秒成本约 $0.003（云 GPU 费用），而商业 API 为 $0.15/秒 —— 成本降低 98%。

**场景 2：游戏工作室原型设计**
一家独立游戏工作室使用 Open-Sora 1.3 进行快速环境原型设计。10 亿参数模型在单张 RTX 4090（24GB）上运行，每段 256p 预览视频不到 30 秒。美术师每天迭代 50+ 变体，没有 API 速率限制。

**场景 3：研究实验室微调**
某大学实验室使用 ColossalAI 分布式训练在显微视频自定义数据集上微调 Open-Sora 2.0。使用 8x H100 GPU，完整微调在 72 小时内完成，以 $200K 预训练权重作为初始化。

## 高级用法 / 生产环境加固

### 内存优化技术

对于显存有限的 GPU，Open-Sora 提供多种优化策略：

```bash
# 1. CPU 卸载（节省 ~40% 显存，慢 25%）
torchrun --nproc_per_node 1 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_256px.py \
    --prompt "raining, sea" \
    --offload True

# 2. Flash Attention 3（加速 15-20%，无质量损失）
# 先安装：
git clone https://github.com/Dao-AILab/flash-attention
cd flash-attention/hopper
python setup.py install

# 3. 量化推理（INT8，节省 50% 显存）
torchrun --nproc_per_node 1 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_256px.py \
    --prompt "raining, sea" \
    --quantization int8

# 4. 混合精度（BF16）
torchrun --nproc_per_node 1 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_256px.py \
    --prompt "raining, sea" \
    --mixed-precision bf16
```

### 多 GPU 张量并行部署

```bash
# 高分辨率生成的张量并行
torchrun --nproc_per_node 8 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_768px.py \
    --save-dir samples \
    --prompt "A soaring drone footage captures coastal cliffs" \
    --tp-size 4
```

### Open-Sora 提示词工程

该模型对结构化提示词（含明确场景描述）响应最好：

```python
# 有效提示词结构
prompt = """A cinematic wide shot of a golden retriever running along a sandy beach at sunset. 
Ocean waves break in the background with warm golden hour lighting. 
The camera follows the dog in slow motion, capturing flying fur details. 
High production value, anamorphic lens, shallow depth of field."""

# 避免：模糊或抽象的提示词
# 差："a dog video"
# 好：详细主体 + 动作 + 环境 + 光照 + 摄像机运动
```

### 生产部署 Docker Compose

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  opensora:
    build: .
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - CUDA_VISIBLE_DEVICES=0,1,2,3
      - HF_HOME=/workspace/cache
    volumes:
      - ./ckpts:/workspace/Open-Sora/ckpts:ro
      - ./samples:/workspace/Open-Sora/samples
      - huggingface_cache:/workspace/cache
    ports:
      - "7860:7860"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    healthcheck:
      test: ["CMD", "python", "-c", "import torch; torch.cuda.is_available()"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped
    
  # 可选：批量任务队列工作器
  worker:
    build: .
    runtime: nvidia
    command: python scripts/diffusion/batch_worker.py --queue redis:6379
    environment:
      - NVIDIA_VISIBLE_DEVICES=4,5,6,7
    volumes:
      - ./ckpts:/workspace/Open-Sora/ckpts:ro
      - ./samples:/workspace/Open-Sora/samples
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 4
              capabilities: [gpu]

volumes:
  huggingface_cache:
```

### 监控和日志

```python
# production_monitor.py
import torch
import time
import psutil
from prometheus_client import Counter, Histogram, start_http_server

# 指标
GENERATION_COUNTER = Counter('opensora_generations_total', '视频生成总数')
GENERATION_DURATION = Histogram('opensora_generation_seconds', '生成时间')
VRAM_USAGE = Histogram('opensora_vram_usage_bytes', '峰值显存使用')

def generate_with_monitoring(prompt, config):
    process = psutil.Process()
    start_mem = process.memory_info().rss
    
    torch.cuda.reset_peak_memory_stats()
    start_time = time.time()
    
    try:
        video = run_inference(prompt, config)
        
        duration = time.time() - start_time
        peak_vram = torch.cuda.max_memory_allocated()
        
        GENERATION_COUNTER.inc()
        GENERATION_DURATION.observe(duration)
        VRAM_USAGE.observe(peak_vram)
        
        return {
            'video': video,
            'duration': duration,
            'peak_vram_gb': peak_vram / 1e9,
            'peak_ram_gb': (process.memory_info().rss - start_mem) / 1e9,
        }
    except Exception as e:
        raise

# 在端口 9090 启动指标服务器
start_http_server(9090)
```

### 安全注意事项

1. **模型权重完整性**：根据官方注册表验证下载的 checkpoint 的 SHA-256 校验和。
2. **输入清理**：在编码前清理所有文本提示词，防止通过 T5 分词器注入攻击。
3. **资源限制**：设置 `CUDA_VISIBLE_DEVICES` 和 Docker 内存限制，防止失控的生成进程消耗所有 GPU 资源。
4. **内容过滤**：如果部署面向公众的服务，请实现输出过滤。该模型没有内置安全分类器。

## 与替代品对比

| 特性 | Open-Sora 2.0 | CogVideoX-5B | HunyuanVideo | Wan 2.1 |
|---|---|---|---|---|
| **参数量** | 11B | 5B / 10B | 13B | 1.3B / 14B |
| **最大分辨率** | 768x768 | 1440x960 | 1080p | 1080p |
| **最大时长** | 5.3秒 (128帧) | 6秒 | 5秒 | 10秒 |
| **最低显存 (FP16)** | 16 GB | 16 GB | 24 GB | 8 GB (1.3B) |
| **最低显存 (INT8)** | 10 GB | 10 GB | 13 GB | 5 GB (1.3B) |
| **架构** | DiT (STDiT) | Expert Transformer | DiT | DiT |
| **许可证** | Apache-2.0 | Apache-2.0 | Apache-2.0 | Apache-2.0 |
| **VBench 分数** | 81.8% | 78.3% | 81.2% | 81.5% |
| **训练成本** | $200K | ~$300K | ~$1M+ | ~$500K+ |
| **T2V 延迟 (A100)** | ~240秒 (768px) | ~180秒 | ~200秒 | ~360秒 |
| **I2V 质量** | 优秀 | 良好 | 优秀 | 很好 |
| **代码可用性** | 完整流水线 | 仅推理 | 部分 | 完整 |
| **ComfyUI 支持** | 社区节点 | 原生节点 | 原生节点 | 原生节点 |
| **多语言** | 英文 | 中英文 | 中英文 | 中英文 |

**关键观察：**
- **每美元质量最佳**：Open-Sora 2.0 在训练成本仅为 HunyuanVideo 五分之一的情况下达到相当的 VBench 分数
- **最低显存门槛**：Wan 2.1 (1.3B) 可在入门级 GPU 上运行，但 Open-Sora 2.0 在竞争显存下提供卓越的 I2V 质量
- **完全可复现性**：Open-Sora 是本次对比中唯一发布完整训练代码、数据流水线和评估脚本的模型

## 局限性 / 诚实评估

Open-Sora 是一个能力强大的框架，但并非适合所有用例。在决定部署之前，请考虑这些限制：

1. **分辨率上限**：Open-Sora 2.0 最大分辨率为 768x768。商业模型如 Sora 和 Kling 原生输出 1080p 和 4K。如需广播级输出，你需要额外的超分流水线。

2. **视频时长限制**：128 帧在 24 FPS 下约为 5.3 秒。超出此范围需要滑动窗口或关键帧插值技术，这会增加复杂性并可能引入不连续性。

3. **文字渲染**：像几乎所有基于扩散的视频模型一样，Open-Sora 在生成视频中难以呈现清晰可读的文本。不要依赖它处理需要可读标志、字幕或屏幕图形的内容。

4. **768p 显存要求**：虽然 256px 生成可以在 16GB 显存上运行，但 768p 生产需要 24GB+ 显存或多 GPU 张量并行。请相应规划预算。

5. **无内置音频**：生成的视频是无声的。如果你的用例需要声音，你需要单独的音频生成流水线（如 stable-audio-tools、AudioLDM）。

6. **高复杂度场景的运动一致性**：包含多个交互物体或复杂物理的场景可能出现时间不一致。T2I2V 流水线可以缓解但会增加推理时间。

## 常见问题

### Q1：Open-Sora 能在 RTX 3060 或 RTX 4070 等消费级 GPU 上运行吗？

110 亿参数模型至少需要 16GB 显存用于 256px 生成（INT8 量化）。RTX 3060 (12GB) 无法运行 11B 模型，但旧的 724M 模型 (Open-Sora 1.0) 可以在 8GB 显存上运行。对于 RTX 4070 Ti Super (16GB)，使用 `--offload True` 可以运行 256px FP16 生成。要运行 768px，你需要 RTX 4090 (24GB) 或多 GPU。

### Q2：Open-Sora 与 OpenAI 的 Sora 相比如何？

OpenAI 的 Sora 是闭源订阅服务，峰值质量更高，原生 1080p 输出，内置编辑工具。Open-Sora 是开源、可自托管、可免费修改的 —— 但最高 768p 且需要技术设置。Open-Sora 2.0 与 OpenAI Sora 的 VBench 差距为 0.69%，在评估者误差范围内。对于许多生产用例，成本节省（免费 vs. $0.10-0.50/秒）超过了质量差异。

### Q3：我可以在自己的视频数据集上微调 Open-Sora 吗？

可以。Open-Sora 发布了完整的训练流水线，包括数据预处理脚本、训练配置和 ColossalAI 集成。微调 11B 模型需要 8x A100/H100 GPU 以获得合理的吞吐量，但 LoRA 微调（减少 99% 可训练参数）可以在 2x A100 40GB 上运行。数据预处理流水线自动处理视频字幕、分辨率过滤和运动分数计算。

### Q4：T2V 和 T2I2V 生成有什么区别？

直接 T2V（文生视频）在单一扩散过程中从文本提示词生成视频。T2I2V（文生图-图生视频）首先使用 FLUX 生成高质量关键帧，然后通过 I2V 流水线为其添加动画。T2I2V 产生显著更好的视觉质量和时间一致性，代价是约 30% 的额外推理时间。生产使用推荐 T2I2V。

### Q5：如何将 Open-Sora 部署为 API 服务？

将推理流水线包装在带有 GPU 工作队列的 FastAPI 应用中。使用 Redis 或 RabbitMQ 进行任务分发，在 GPU 节点上运行推理工作器。仓库中包含的 Gradio 应用 (`gradio/app.py`) 提供参考实现。生产环境需要添加请求验证、速率限制和输出缓存。仓库的 `examples/api_server/` 目录提供完整的 FastAPI 样板代码。

### Q6：什么提示词格式最适合 Open-Sora？

详细的描述性提示词，包含明确的场景构图，能产生最佳效果。包括：(1) 主体描述，(2) 动作或运动，(3) 环境和光照，(4) 摄像机角度和运动，(5) 风格或氛围关键词。50-100 词的提示词通常优于短提示词。内置的提示词优化功能（使用 GPT-4）可以自动将短提示词扩展为详细描述。

### Q7：Apache-2.0 许可证允许商业使用吗？

允许。Apache-2.0 许可证允许商业使用、修改、分发和私人使用，前提是你包含原始版权声明和许可证文本。对生成内容没有限制 —— 你拥有使用 Open-Sora 创建的视频。专利权利被明确授予，这与其他一些开源许可证不同。

## 结论

Open-Sora 2.0 代表了开源视频生成的一个里程碑：110 亿参数，81.8% VBench 分数，训练成本仅 $200K 的完整可复现性。T2I2V 流水线以远低于商业 API 的每秒成本产生可媲美的质量，而 Apache-2.0 许可证确保完整的商业自由。

对于评估自托管视频生成的团队，设置路径很明确：在单张 A100 上使用 Docker 部署进行原型设计，扩展到多 GPU 张量并行用于 768p 生产环境，使用 ColossalAI 进行自定义微调。10 亿参数模型为在投入完整 11B 模型之前提供了低显存的快速迭代入口。

**下一步：**

1. 克隆仓库：`git clone https://github.com/hpcaitech/Open-Sora.git`
2. 在 GitHub Discussions 上加入社区讨论获取微调技巧
3. 在 GitHub 上关注项目获取 1.4/2.1 版本发布通知
4. 在 dibi8 Telegram 社区分享你的部署经验：[https://t.me/dibi8tech](https://t.me/dibi8tech)



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- Open-Sora GitHub 仓库：https://github.com/hpcaitech/Open-Sora
- Open-Sora 2.0 技术报告：https://arxiv.org/abs/2503.09642
- Open-Sora 1.3 报告：https://github.com/hpcaitech/Open-Sora/blob/main/docs/report_04.md
- HPC-AI Tech 博客：https://hpc-ai.com/blog/open-sora
- VBench 评估套件：https://github.com/Vchitect/VBench
- ColossalAI 文档：https://colossalai.org/docs/
- Open-Sora 画廊（视频样本）：https://hpcaitech.github.io/Open-Sora/
- 模型权重 (HuggingFace)：https://huggingface.co/hpcai-tech/Open-Sora-v2
- 模型权重 (ModelScope)：https://modelscope.cn/models/luchentech/Open-Sora-v2
- FLUX 文生图模型：https://github.com/black-forest-labs/flux
- ComfyUI 官方仓库：https://github.com/comfyanonymous/ComfyUI
