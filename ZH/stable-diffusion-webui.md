---
title: 'Stable Diffusion WebUI: 159K+ Stars — 2026 完整安装配置指南'
description: 'Stable Diffusion WebUI (AUTOMATIC1111) 是最流行的本地 AI 图像生成 Web 界面。兼容 ControlNet、LoRA、ComfyUI 工作流。涵盖 Windows、Linux、Docker 安装、扩展配置、生产环境加固和 GPU 基准测试。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/AUTOMATIC1111/stable-diffusion-webui'
stars: 159000
maintainer: 'AUTOMATIC1111'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['stable-diffusion', 'automatic1111', '图像生成', 'ai-webui', 'controlnet', 'lora', 'docker', 'gpu']
aliases:
- /zh/posts/stable-diffusion-webui/
---

{{</* resource-info */>}}

AUTOMATIC1111 开发的 Stable Diffusion WebUI 依然是本地 AI 图像生成领域使用最广泛的开源界面。凭借 **159,000+ GitHub stars**，它的社区规模超过了所有竞争对手的总和。如果你正在搭建本地 AI 图像管线，掌握这个工具的安装、配置和扩展方法是一项实际的必需技能。

本指南将详细介绍 Stable Diffusion WebUI 在 Windows、Linux 和 Docker 上的完整安装过程。你会找到每个平台的真实命令、ControlNet 和 LoRA 的扩展配置、生产环境加固技巧，以及消费级 GPU 的性能基准测试。

![Stable Diffusion WebUI 界面](https://raw.githubusercontent.com/AUTOMATIC1111/stable-diffusion-webui/master/screenshot.png)
*Stable Diffusion WebUI v1.10.1 的默认 txt2img 界面*

## Stable Diffusion WebUI 是什么？

Stable Diffusion WebUI 是一个基于浏览器的界面，用于在本地运行 Stable Diffusion 模型。它将底层推理管线封装在一个标签页式的 Web 应用中，通过 `http://localhost:7860` 访问，提供文生图、图生图、局部重绘、超分辨率、模型融合和 LoRA/DreamBooth 训练等功能 —— 全部无需编写代码。

该项目由 AUTOMATIC1111 在 AGPL-3.0 许可证下维护。v1.10.1 版本（2025 年初发布）改进了 SDXL 精修流程、优化了 8GB 显卡的内存管理，并增加了对 SD3 Medium 推理的原生支持。扩展生态包含超过 1,000 个社区插件，涵盖从提示词自动补全到批量处理管线的各种功能。

## Stable Diffusion WebUI 的工作原理

其架构采用模块化 Python 后端 + Gradio 前端的设计模式：

![WebUI 架构流程](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/images/webui_arch.png)
*架构：Gradio 前端通过本地 HTTP 与模块化 Python 后端通信*

```
用户浏览器 (Gradio UI)
    |
    v
Gradio 服务器 (端口 7860) --- API 端点 (/sdapi/v1/)
    |
    v
Python 后端 (modules/)
    |-- 模型加载器 (safetensors/ckpt)
    |-- 采样器 (Euler, DPM++ 等)
    |-- VAE 编解码
    |-- 后处理 (GFPGAN, CodeFormer)
    |
    v
PyTorch + CUDA --- GPU (显存: 4-24GB)
```

安装前需要理解的核心概念：

- **Checkpoint**: 主模型文件（`.safetensors` 或 `.ckpt`），包含训练好的扩散权重。SD 1.5 模型约 4GB；SDXL 模型约 6-7GB。
- **VAE (变分自编码器)**: 负责像素空间和潜空间之间的编解码。不匹配的 VAE 会导致图像色彩暗淡或模糊。
- **采样器 (Sampler)**: 逐步将潜空间噪声去噪为图像的算法。DPM++ 2M Karras 是最推荐的平衡点。
- **CFG Scale**: 控制模型遵循提示词的程度。7-9 适合大多数场景；过高会增加对比度但可能产生伪影。
- **扩展 (Extensions)**: 运行时加载的 Python 插件，可添加 UI 标签页、API 端点或修改推理管线。ControlNet 和 Adetailer 是使用最广泛的扩展。

## 安装与配置

Stable Diffusion WebUI 支持 Windows、Linux 和 macOS。所有平台上最快的安装方式是使用官方安装脚本。

### 系统要求

| 组件 | 最低配置 | 推荐配置 |
|------|---------|---------|
| GPU | NVIDIA 4GB 显存 | NVIDIA RTX 3060 12GB+ |
| 内存 | 8GB | 16GB |
| 存储 | 20GB SSD | 100GB SSD (存放模型) |
| 操作系统 | Windows 10 / Ubuntu 20.04 | Windows 11 / Ubuntu 22.04 |
| Python | 3.10.6 | 3.10.11 |

### Windows 安装（自动安装）

自动安装器会处理 Git、Python 和依赖的安装：

```batch
:: 从发布页面下载 sd.webui.zip
:: 解压到 C:\stable-diffusion-webui
:: 先运行更新器
cd C:\stable-diffusion-webui
update.bat

:: 启动 WebUI
run.bat
```

首次启动时，脚本会下载 PyTorch、transformers 和默认的 SD 1.5 模型（约 4GB）。后续启动只需 15-30 秒。UI 将在 `http://127.0.0.1:7860` 可用。

### Windows 命令行参数

对于显存有限或有特定优化需求的 GPU，编辑 `webui-user.bat`：

```batch
@echo off

set PYTHON=python
set GIT=git
set VENV_DIR=venv
set COMMANDLINE_ARGS=--xformers --autolaunch --update-check

:: 显存优化选项（选择一个）:
:: set COMMANDLINE_ARGS=--medvram    &:: 8GB 显卡
:: set COMMANDLINE_ARGS=--lowvram    &:: 4GB 显卡  
:: set COMMANDLINE_ARGS=--normalvram &:: 12GB+ 显卡

:: RTX 40 系列添加 --xformers 可获得 20-30% 加速
:: 出现黑图/绿图时，添加 --precision full --no-half

call webui.bat
```

### Linux 安装（手动）

手动安装可完全控制 Python 环境：

```bash
# 安装依赖 (Ubuntu/Debian)
sudo apt update && sudo apt install -y wget git python3 python3-venv libgl1 libglib2.0-0

# 克隆仓库
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

# 创建虚拟环境并安装
python3 -m venv venv
source venv/bin/activate
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt

# 启动
./webui.sh --xformers --listen
```

对于无显示器的系统（无头服务器），添加 `--listen` 可在所有接口暴露 UI，并使用 `--gradio-auth 用户名:密码` 添加基础认证。

### Docker 安装（推荐用于生产环境）

Docker 提供最可复现的安装方式，尤其适合服务器部署：

```dockerfile
# Dockerfile.stable-diffusion-webui
FROM nvidia/cuda:12.1.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv git wget \
    libgl1 libglib2.0-0 libsm6 libxext6 \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash sduser
WORKDIR /home/sduser

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
WORKDIR /home/sduser/stable-diffusion-webui

RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir torch torchvision torchaudio \
    --index-url https://download.pytorch.org/whl/cu121 && \
    pip install -r requirements.txt

RUN chown -R sduser:sduser /home/sduser
USER sduser

EXPOSE 7860

ENTRYPOINT ["bash", "-c", \". venv/bin/activate && python3 launch.py --listen --api --xformers"]
```

构建并运行：

```bash
# 构建镜像
docker build -f Dockerfile.stable-diffusion-webui -t sd-webui:latest .

# 运行，启用 GPU 访问和模型持久化
docker run -d \
  --name stable-diffusion-webui \
  --gpus all \
  -p 7860:7860 \
  -v $(pwd)/models:/home/sduser/stable-diffusion-webui/models/Stable-diffusion \
  -v $(pwd)/outputs:/home/sduser/stable-diffusion-webui/outputs \
  -v $(pwd)/extensions:/home/sduser/stable-diffusion-webui/extensions \
  -e NVIDIA_VISIBLE_DEVICES=all \
  sd-webui:latest
```

docker-compose 配置：

```yaml
# docker-compose.yml
version: '3.8'

services:
  stable-diffusion-webui:
    build:
      context: .
      dockerfile: Dockerfile.stable-diffusion-webui
    container_name: sd-webui
    runtime: nvidia
    ports:
      - "7860:7860"
    volumes:
      - ./models:/home/sduser/stable-diffusion-webui/models/Stable-diffusion
      - ./outputs:/home/sduser/stable-diffusion-webui/outputs
      - ./extensions:/home/sduser/stable-diffusion-webui/extensions
      - ./vae:/home/sduser/stable-diffusion-webui/models/VAE
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    restart: unless-stopped
```

一键部署：

```bash
docker-compose up -d
```

### 使用 虎网云 GPU 云服务器部署

如果本地硬件不足，虎网云 GPU 云服务器提供按量计费的 NVIDIA GPU 实例，适合短期训练或推理任务。虎网云支持分钟级开通，并提供预装 CUDA 和 PyTorch 的镜像，可大幅简化部署流程。

```bash
# 在虎网云 GPU 实例上 (Ubuntu 22.04 预配置)
sudo apt update && sudo apt install -y git wget

# 克隆并配置
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git
cd stable-diffusion-webui

# 使用 CUDA 12 支持安装
python3 -m venv venv
source venv/bin/activate
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121
pip install -r requirements.txt

# 启动公开访问 (配置防火墙规则)
python3 launch.py --listen --port 7860 --xformers --gradio-auth admin:securepassword123
```

*虎网云提供灵活的 GPU 实例规格和稳定的中文技术支持，是国内部署 Stable Diffusion 的实用选择。*

## 与 ControlNet、LoRA 及常用工具的集成

### ControlNet 扩展配置

ControlNet 支持结构引导生成 —— 姿势迁移、深度感知构图、边缘控制：

![ControlNet 界面](https://github.com/Mikubill/sd-webui-controlnet/wiki/images/controlnet_ui.png)
*ControlNet 扩展面板在 WebUI txt2img 标签页中的样子*

```bash
# 通过扩展标签页安装（推荐）
# 1. 打开 WebUI → 扩展 → 可用
# 2. 点击"加载自"
# 3. 搜索"ControlNet"
# 4. 点击安装"sd-webui-controlnet"
# 5. 重启 UI

# 或手动安装：
cd extensions
git clone https://github.com/Mikubill/sd-webui-controlnet.git
```

下载 ControlNet 模型到 `models/ControlNet/`：

```bash
# 核心 ControlNet 模型 (SD 1.5)
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_openpose.pth
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1p_sd15_depth.pth
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_canny.pth
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11p_sd15_lineart.pth

# SDXL ControlNet 模型
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_canny_mid.safetensors
wget -P models/ControlNet/ https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_depth_mid.safetensors
```

UI 中的 ControlNet 配置：

```json
// settings.json - ControlNet 配置
{
  "control_net_max_models_num": 3,
  "control_net_model_cache_size": 2,
  "control_net_control_transfer": false,
  "control_net_detectedmap_dir": "extensions/sd-webui-controlnet/detected_maps",
  "control_net_models_path": "models/ControlNet",
  "control_net_modules_path": "extensions/sd-webui-controlnet/annotator",
  "control_net_unit_mode": false,
  "control_net_sync_field_args": true
}
```

### LoRA (低秩适配) 集成

LoRA 文件是轻量级适配器（约 10-200MB），可在不替换基础模型的情况下微调模型行为：

```bash
# 下载 LoRA 模型到专用目录
# 将 .safetensors LoRA 文件放入：
# models/Lora/

# 示例：下载热门风格 LoRA
wget -P models/Lora/ "https://civitai.com/api/download/models/12345"
```

在提示词中使用 LoRA：

```
<lora:add-detail-xl:1.0>, masterpiece, best quality, portrait of a warrior
<lora:epiCRealismHelper:0.6>, photorealistic, 8k uhd
```

语法为 `<lora:文件名:权重>`，权重范围 0.0 到 1.0。单个提示词中可堆叠多个 LoRA。

### ComfyUI 工作流桥接

对于需要节点式工作流的场景，将 ComfyUI 作为辅助工具安装：

```bash
# 将 ComfyUI 安装为独立工具（推荐而非迁移）
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt

# 共享模型目录避免重复
ln -s /path/to/stable-diffusion-webui/models/Stable-diffusion models/checkpoints
ln -s /path/to/stable-diffusion-webui/models/Lora models/loras
ln -s /path/to/stable-diffusion-webui/models/ControlNet models/controlnet

# 在不同端口启动
python main.py --port 8188
```

这种配置让你可以同时使用 Stable Diffusion WebUI 进行快速原型设计和 ComfyUI 进行复杂多阶段管线，共享同一套模型库。

### 必备扩展清单

```bash
# 安装以下扩展以获得生产级体验
cd extensions

# Adetailer - 自动面部/手部/细节修复
git clone https://github.com/Bing-su/adetailer.git

# Ultimate SD Upscale - 高分辨率放大
git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git

# Tiled VAE - 降低大图显存占用
git clone https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111.git

# Tag Autocomplete - 提示词补全
git clone https://github.com/DominikDoom/a1111-sd-webui-tagcomplete.git

# System Info + Benchmark - 系统信息和基准测试
git clone https://github.com/vladmandic/sd-extension-system-info.git

# Inpaint Anything - 万物分割 + 重绘
git clone https://github.com/Uminosachi/sd-webui-inpaint-anything.git

# 安装扩展后重启 WebUI
```

## 基准测试 / 实际使用场景

### GPU 性能对比

所有基准测试使用 Stable Diffusion WebUI v1.10.1，DPM++ 2M Karras 采样器，20 步，批次大小 1：

| GPU | 显存 | SD 1.5 512x512 | SDXL 1024x1024 | SDXL + ControlNet |
|-----|------|----------------|----------------|-------------------|
| RTX 4060 Ti 16GB | 16 GB | ~4.2秒 | ~12.0秒 | ~16.5秒 |
| RTX 3090 | 24 GB | ~2.4秒 | ~5.6秒 | ~9.2秒 |
| RTX 4090 | 24 GB | ~1.1秒 | ~3.2秒 | ~4.8秒 |
| RTX 5090 | 32 GB | ~0.8秒 | ~2.2秒 | ~3.5秒 |

数据来源：sd-extension-system-info 社区基准测试，10 次运行平均值。

### 各工作流显存占用

| 工作流 | 显存占用 (RTX 4090) | 说明 |
|--------|-------------------|------|
| txt2img SD 1.5 @ 512x512 | ~4.5 GB | 任何现代显卡都能运行 |
| txt2img SDXL @ 1024x1024 | ~8.0 GB | 需要 8GB+ 显存 |
| SDXL + 1x ControlNet | ~12.5 GB | 8GB 显卡需使用 `--medvram` |
| SDXL + Hi-Res Fix 2x | ~14.0 GB | 推荐使用 Tiled VAE |
| SDXL + 2x ControlNet + Adetailer | ~20.0 GB | 推荐 RTX 3090/4090 |

### 内存优化参数

```bash
# 4GB 显存 GPU (入门级):
python3 launch.py --lowvram --precision full --no-half --xformers

# 6-8GB 显存 GPU (主流级):
python3 launch.py --medvram --xformers --opt-split-attention

# 12GB+ 显存 GPU (高端):
python3 launch.py --xformers --opt-sdp-attention

# 24GB 显存 GPU (发烧级):
python3 launch.py --xformers --opt-sdp-attention --no-half-vae
```

## 高级用法 / 生产环境加固

### API 集成

Stable Diffusion WebUI 在 `/sdapi/v1/` 提供完整的 REST API：

```python
# txt2img API 的 Python 客户端
import requests
import json

url = "http://localhost:7860/sdapi/v1/txt2img"

payload = {
    "prompt": "masterpiece, best quality, portrait of a cyberpunk samurai, neon city background, 8k uhd",
    "negative_prompt": "blurry, low quality, deformed, ugly, duplicate",
    "steps": 25,
    "cfg_scale": 7.0,
    "width": 1024,
    "height": 1024,
    "sampler_name": "DPM++ 2M Karras",
    "batch_size": 1,
    "seed": -1,
    "override_settings": {
        "sd_model_checkpoint": "sd_xl_base_1.0.safetensors"
    }
}

response = requests.post(url, json=payload)
result = response.json()

# 保存生成的图像
import base64
for i, img_data in enumerate(result['images']):
    with open(f"output_{i}.png", "wb") as f:
        f.write(base64.b64decode(img_data))
```

### 批处理脚本

```python
# batch_generate.py - 处理多个提示词
import requests
import csv
import base64

API_URL = "http://localhost:7860/sdapi/v1/txt2img"

def generate_image(prompt, filename, width=1024, height=1024):
    payload = {
        "prompt": prompt,
        "negative_prompt": "blurry, low quality, deformed",
        "steps": 25,
        "cfg_scale": 7.0,
        "width": width,
        "height": height,
        "sampler_name": "DPM++ 2M Karras"
    }
    
    response = requests.post(API_URL, json=payload)
    result = response.json()
    
    with open(filename, "wb") as f:
        f.write(base64.b64decode(result['images'][0]))
    
    return filename

# 从 CSV 处理提示词列表
with open("prompts.csv", "r") as f:
    reader = csv.DictReader(f)
    for i, row in enumerate(reader):
        filename = f"output_{i:04d}.png"
        generate_image(row['prompt'], filename)
        print(f"已生成: {filename}")
```

### 公开部署的安全加固

```bash
# 1. 启用认证
python3 launch.py --listen --gradio-auth admin:强密码

# 2. 使用 HTTPS 反向代理 (nginx)
# /etc/nginx/sites-available/sd-webui
server {
    listen 443 ssl http2;
    server_name sd.example.com;

    ssl_certificate /etc/letsencrypt/live/sd.example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/sd.example.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:7860;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # WebSocket 支持 Gradio
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}

# 3. 防火墙规则 (ufw)
sudo ufw default deny incoming
sudo ufw allow ssh
sudo ufw allow 443/tcp
sudo ufw enable
```

### 监控和日志

```bash
# 创建简单的健康检查脚本
#!/bin/bash
# health_check.sh

STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:7860/)
if [ "$STATUS" != "200" ]; then
    echo "$(date): WebUI 宕机 (HTTP $STATUS)，正在重启..." >> /var/log/sd-webui.log
    systemctl restart sd-webui
fi
```

```ini
# 自动启动的 systemd 服务
# /etc/systemd/system/sd-webui.service
[Unit]
Description=Stable Diffusion WebUI
After=network.target

[Service]
Type=simple
User=sduser
WorkingDirectory=/home/sduser/stable-diffusion-webui
ExecStart=/home/sduser/stable-diffusion-webui/venv/bin/python launch.py --xformers --listen --port 7860
Restart=on-failure
RestartSec=30
Environment="PYTHONUNBUFFERED=1"

[Install]
WantedBy=multi-user.target
```

启用自动启动：

```bash
sudo systemctl daemon-reload
sudo systemctl enable sd-webui
sudo systemctl start sd-webui
```

## 与替代方案对比

| 功能 | Stable Diffusion WebUI | ComfyUI | InvokeAI | Fooocus |
|------|----------------------|---------|----------|---------|
| **UI 类型** | 标签页式 Web 界面 | 节点图编辑器 | 带画布的 Web 应用 | 极简单页 |
| **GitHub Stars** | 159,000+ | 75,000+ | 25,000+ | 42,000+ |
| **扩展生态** | 1,000+ 扩展 | 1,500+ 自定义节点 | ~100 社区节点 | 有限（预设） |
| **学习曲线** | 中等 | 陡峭 | 中等 | 极简 |
| **ControlNet 支持** | 优秀（全范围） | 广泛（所有模型） | 内置 | 基础 |
| **LoRA 支持** | 完整（可堆叠） | 完整 | 内置管理器 | 基础 |
| **SDXL 最低显存** | 4GB (--lowvram) | 4GB | 6GB | 4GB |
| **批处理** | 内置 | 队列工作流 | 队列系统 | 仅手动 |
| **API** | 完整 REST API | REST + WebSocket | 完整 REST | 无 |
| **适用场景** | 通用、扩展丰富 | 高级用户、自动化 | 艺术家、画布编辑 | 新手、快速生成 |

### 如何选择

- **Stable Diffusion WebUI**: 需要最大扩展生态、成熟社区支持，以及易用性和灵活性平衡时选择。159K stars 意味着更多教程、更多扩展、更快的 bug 修复。
- **ComfyUI**: 构建自动化管线、视频生成工作流或多阶段处理时选择。节点系统强大但需要 2-4 小时学习。ComfyUI 在相同硬件上比 WebUI 快 10-20%。
- **InvokeAI**: 以画布为基础的内绘和专业艺术家工作流为优先时选择。
- **Fooocus**: 追求最简单设置时选择 —— 下载、解压、运行。无需配置。但因缺乏 API 和自动化功能，不适合生产管线。

## 局限性 / 客观评估

Stable Diffusion WebUI 并非适用于所有图像生成场景。以下是具体局限：

1. **显存占用高于替代品**: Gradio UI 增加约 500MB-1GB 显存开销，ComfyUI 的前端更轻量。在 4-6GB 显卡上，这个差距很显著。

2. **速度不是最快**: 基准测试一致显示 ComfyUI 比 WebUI 快 10-20%。差距在批处理时进一步扩大。

3. **Flux 模型支持有限**: 运行 Flux 模型需要 Forge 分支或手动配置。ComfyUI 对新架构的 day-0 支持更好。

4. **扩展冲突**: 1,000+ 扩展中，不兼容情况时有发生。更新可能破坏现有工作流。

5. **不适合视频生成**: WebUI  fundamentally 为静态图像设计。ComfyUI 的节点系统更适合视频和动画工作流。

6. **单用户设计**: WebUI 没有内置多用户支持。运行共享实例需要外部认证和会话管理。

## 常见问题

### 需要什么 GPU 才能运行 Stable Diffusion WebUI？

NVIDIA 显卡至少需要 4GB 显存才能运行 SD 1.5（512x512）。SDXL（1024x1024）实际需要 8GB 显存（使用 `--medvram` 优化）。12GB 显存（RTX 3060、RTX 4060 Ti）可无妥协运行 SDXL。专业用途配合 ControlNet 和 Hi-Res Fix 推荐 24GB（RTX 3090/4090）。

### 如何更新 Stable Diffusion WebUI？

在安装目录运行 `git pull` 获取最新代码，然后重启 WebUI。Windows 上双击 `update.bat`。如果扩展在更新后损坏，删除 `venv` 文件夹强制重新安装依赖。对于 RTX 50 系列显卡，更新前运行 `git checkout dev` 切换到开发分支。

### 没有 NVIDIA GPU 能运行吗？

可以，但有明显限制。AMD GPU 在 Linux 上通过 ROCm 工作（添加 `--precision full --no-half`）。Apple Silicon Mac 可通过 `./webui.sh` 以 MPS 后端运行，速度比同档 NVIDIA 硬件慢 3-5 倍。纯 CPU 模式使用 `--use-cpu all`，但生成一张 512x512 图像需 5-10 分钟（GPU 仅需 2-4 秒）。

### 为什么生成的图像是黑色或绿色的？

这是某些 GPU/驱动组合上的半精度问题。添加 `--precision full --no-half`。如果 VAE 中出现 NaN 错误，使用 `--no-half-vae`。RTX 16 系列和部分 GTX 显卡更容易出现此问题。

### 如何解决 "CUDA out of memory" 错误？

首先启用 xFormers `--xformers`（减少 20-30% 显存）。8GB 显卡添加 `--medvram`，4-6GB 显卡使用 `--lowvram`。高分辨率生成安装 Tiled VAE 扩展。考虑使用 FP8 或 NF4 量化模型，显存减少 50% 且质量损失很小。最后可降低图像分辨率或批次大小。

### 将 Stable Diffusion WebUI 暴露到互联网安全吗？

不安全 —— 除非增加额外安全措施。`--listen` 标志在无认证情况下暴露 UI。必须配合 `--gradio-auth 用户名:密码` 和 HTTPS 反向代理（nginx/Caddy）及防火墙规则。WebUI 设计用于本地使用；公开部署需要将其视为生产服务并进行适当访问控制。

## 结论

AUTOMATIC1111 的 Stable Diffusion WebUI 在 2026 年依然是本地 AI 图像生成最实用的起点。159,000+ GitHub stars 不仅代表流行度 —— 它们代表了一个扩展生态、知识库和社区支持基础设施，没有任何竞争对手能与之匹敌。对于构建图像生成管线的开发者，这个工具在功能、文档和已验证稳定性之间提供了最佳平衡。

**入门行动清单：**

1. 确认你的 GPU 有 8GB+ 显存，使用自动安装器（Windows）或 Docker（Linux/服务器）安装 WebUI
2. 安装 ControlNet + 4 个核心模型（openpose、depth、canny、lineart）实现结构引导生成
3. 下载 2-3 个高质量 SDXL 基础模型和 5-10 个适合你场景的 LoRA 适配器
4. 根据你的硬件配置 `--xformers` 和适当的显存优化参数
5. 如果部署在 localhost 之外，设置 nginx 反向代理并启用认证

**在 Telegram 群组中讨论本指南或获取帮助：** [t.me/dibi8opensource](https://t.me/dibi8opensource)

*免责声明：本文包含虎网云的推广链接。如果你通过这些链接注册，我们可能会获得佣金 —— 这不会增加你的额外费用，并帮助我们支持开源内容。所有推荐均基于实际测试，而非联盟合作关系。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [AUTOMATIC1111/stable-diffusion-webui GitHub 仓库](https://github.com/AUTOMATIC1111/stable-diffusion-webui)
- [官方 Wiki — NVIDIA GPU 安装指南](https://github.com/AUTOMATIC1111/stable-diffusion-webui/wiki/Install-and-Run-on-NVidia-GPUs)
- [ControlNet 扩展仓库](https://github.com/Mikubill/sd-webui-controlnet)
- [Stable Diffusion WebUI Docker 配置](https://github.com/AbdBarho/stable-diffusion-webui-docker)
- [ComfyUI — 节点式替代方案](https://github.com/comfyanonymous/ComfyUI)
- [InvokeAI — 面向艺术家的替代方案](https://github.com/invoke-ai/InvokeAI)
- [虎网云 GPU 云服务器](https://www.huwww.com/)
- [Civitai — 模型和 LoRA 平台](https://civitai.com)
- [Hugging Face — 模型下载](https://huggingface.co/models?pipeline_tag=text-to-image)
