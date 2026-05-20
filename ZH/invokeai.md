---
title: 'InvokeAI: 27.2K+ Stars — 2026 完整安装配置指南'
description: 'InvokeAI（Invoke）是 Stable Diffusion 模型的领先创意引擎，拥有业界领先的 WebUI。兼容 SD 1.5、SDXL、FLUX 和 ControlNet。涵盖 Docker 安装、工作流配置、与 AUTOMATIC1111 和 ComfyUI 的性能对比，以及生产环境加固。'
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
github_repo: 'https://github.com/invoke-ai/InvokeAI'
stars: 27200
maintainer: 'invoke-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['InvokeAI', 'Stable Diffusion', 'AI图像生成', 'Docker', 'FLUX', 'SDXL', 'WebUI', '开源']
aliases:
- /zh/posts/invokeai/
---

{{</* resource-info */>}}

![InvokeAI Logo](https://raw.githubusercontent.com/invoke-ai/InvokeAI/main/invokeai/assets/invokeai-logo.png)

## 引言

每个尝试在本地运行 Stable Diffusion 的开发者都知道其中的痛点：依赖冲突、CUDA 版本不匹配、缺失的模型配置文件，以及看起来像 2003 年设计的 WebUI。自 2022 年以来，开源 AI 图像生成领域已经显著成熟，但"在我机器上能跑"和生产级部署之间的差距仍然很大。InvokeAI 在 GitHub 上拥有 27.2K+ 星标，截至 2026 年 3 月已发布 v6.12.0，填补了这一空白。它在 Apache-2.0 许可下将专业级 WebUI 与节点式工作流引擎、多用户支持和 Docker 部署结合在一起。本指南将介绍如何通过 Docker 和裸机安装 InvokeAI，将其与 Stable Diffusion 和 ControlNet 集成，并在生产环境中运行。

## InvokeAI 是什么？

InvokeAI 是一个免费的开源创意引擎，用于基于 Stable Diffusion 模型的 AI 驱动图像生成。它提供了一个基于 Web 的界面，包含专业画布编辑器、节点式工作流构建器和模型管理系统 —— 既服务于个人艺术家，也服务于需要自托管、生产就绪 AI 图像生成管道的团队。

## InvokeAI 的工作原理

InvokeAI 采用模块化客户端-服务器架构。后端是基于 Python 的 API 服务器（`invokeai.app.api_app`），负责处理模型加载、图像生成和队列管理。前端是基于 React 的单页应用，提供画布、画廊和工作流编辑器。

**核心组件：**

- **Web 服务器与 React UI** —— 默认运行在 9090 端口，提供完整的生成界面
- **统一画布（Unified Canvas）** —— 支持内绘、外绘、画笔工具和图生图编辑的图层画布
- **节点式工作流** —— 用于可复现、可共享管道的可视化管道构建器
- **模型管理器** —— 内置 SD 1.5、SDXL、FLUX、Z-Image 和自定义 checkpoint 的下载和管理
- **画廊与画板** —— 带有元数据保留和拖放支持的有序图像存储
- **队列系统** —— 用于批量生成和工作流执行的后台作业处理

## 安装与配置

### 方法一：Docker（生产环境推荐）

Docker 是部署生产级 InvokeAI 的最快路径。官方镜像支持 NVIDIA（CUDA）、AMD（ROCm）和仅 CPU 模式。

**前置条件：**
- Docker Engine 24.0+ 并启用 BuildKit
- Docker Compose 插件（V2）
- NVIDIA Container Toolkit（GPU）或 ROCm Docker 运行时（AMD）
- 16GB+ 内存，20GB+ 可用磁盘空间

**步骤 1 — 克隆仓库：**

```bash
git clone https://github.com/invoke-ai/InvokeAI.git
cd InvokeAI/docker
```

**步骤 2 — 配置环境：**

```bash
cp .env.sample .env
```

编辑 `.env` 文件：

```bash
# 核心配置
INVOKEAI_ROOT=/opt/invokeai-data
INVOKEAI_PORT=9090
GPU_DRIVER=cuda
CONTAINER_UID=1000
HUGGINGFACE_TOKEN=hf_your_token_here
```

**步骤 3 — 启动容器：**

```bash
./run.sh
```

或直接运行：

```bash
docker compose up -d
```

在浏览器中访问 `http://localhost:9090`。

### 快速 Docker 运行（无需 Compose）

如需快速测试而不持久化数据：

```bash
# NVIDIA GPU
docker run --runtime=nvidia --gpus=all \
  --publish 9090:9090 \
  ghcr.io/invoke-ai/invokeai:latest

# AMD GPU
docker run --device /dev/kfd --device /dev/dri \
  --publish 9090:9090 \
  ghcr.io/invoke-ai/invokeai:main-rocm

# 带数据持久化
docker run --runtime=nvidia --gpus=all \
  --publish 9090:9090 \
  --volume /mnt/invokeai-data:/invokeai \
  ghcr.io/invoke-ai/invokeai:latest
```

### 方法二：裸机安装（Linux/macOS）

**步骤 1 — 安装启动器：**

```bash
pip install invokeai
```

**步骤 2 — 运行配置向导：**

```bash
invokeai-configure
```

此交互式向导会安装正确的 PyTorch 版本、下载默认模型并配置运行时目录。

**步骤 3 — 启动 WebUI：**

```bash
invokeai-web
```

### 方法三：云 VPS（DigitalOcean）

对于没有本地 GPU 硬件的团队，云 GPU 实例可以提供完整的 InvokeAI 访问。配备 NVIDIA A10G 或 H100 的 DigitalOcean GPU Droplets 表现良好。

```bash
# 在全新的 Ubuntu 24.04 GPU droplet 上
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable --now docker

# 安装 NVIDIA Container Toolkit
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update && sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# 部署 InvokeAI
git clone https://github.com/invoke-ai/InvokeAI.git
cd InvokeAI/docker
cp .env.sample .env
# 编辑 .env：设置 INVOKEAI_ROOT 和 HUGGINGFACE_TOKEN
sudo docker compose up -d
```

### 生产环境 docker-compose.yml 参考

```yaml
# Copyright (c) 2023 Eugene Brodsky https://github.com/ebr

x-invokeai: &invokeai
    image: "ghcr.io/invoke-ai/invokeai:latest"
    build:
      context: ..
      dockerfile: docker/Dockerfile
    env_file:
      - .env
    environment:
      - INVOKEAI_ROOT=${CONTAINER_INVOKEAI_ROOT:-/invokeai}
      - HF_HOME
    ports:
      - "${INVOKEAI_PORT:-9090}:${INVOKEAI_PORT:-9090}"
    volumes:
      - type: bind
        source: ${HOST_INVOKEAI_ROOT:-${INVOKEAI_ROOT:-~/invokeai}}
        target: ${CONTAINER_INVOKEAI_ROOT:-/invokeai}
        bind:
          create_host_path: true
      - ${HF_HOME:-~/.cache/huggingface}:${HF_HOME:-/invokeai/.cache/huggingface}
    tty: true
    stdin_open: true

services:
  invokeai-cuda:
    <<: *invokeai
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

  invokeai-cpu:
    <<: *invokeai
    profiles:
      - cpu

  invokeai-rocm:
    <<: *invokeai
    environment:
      - AMD_VISIBLE_DEVICES=all
      - RENDER_GROUP_ID=${RENDER_GROUP_ID}
    runtime: amd
    profiles:
      - rocm
```

## 与 Stable Diffusion、ComfyUI 和 ControlNet 集成

### 使用 Stable Diffusion 模型

InvokeAI 开箱即用支持多种模型系列：

- **SD 1.5** — 经典模型，庞大的 LoRA 生态
- **SDXL** — 更高分辨率，更好的提示词遵循
- **FLUX / FLUX.2** — 2025-2026 年最先进的质量
- **Z-Image** — 适合微调的未蒸馏模型

**通过模型管理器添加模型：**

1. 打开 WebUI → 模型管理器标签
2. 点击"安装模型" → 粘贴 Hugging Face URL 或本地路径
3. 模型将自动下载和转换

**手动添加模型：**

```bash
# 将 .safetensors 或 .ckpt 文件放入模型目录
cp your-model.safetensors /opt/invokeai-data/models/sd-1/main/

# 重启容器
docker compose restart
```

### ControlNet 集成

InvokeAI 通过其节点工作区原生支持 ControlNet。可用的处理器包括深度图、Canny 边缘、OpenPose、分割等。

**在工作流中使用 ControlNet：**

1. 在 UI 中打开工作流标签
2. 从节点库添加 ControlNet 节点
3. 连接基础模型和参考图像
4. 选择预处理器（Canny、Depth、OpenPose 等）
5. 设置控制强度（推荐 0.5–1.0）
6. 将生成任务加入队列

### ComfyUI 工作流导入

虽然 InvokeAI 和 ComfyUI 使用不同的工作流格式，但你可以在 InvokeAI 的节点编辑器中重现 ComfyUI 管道。节点库涵盖：

- KSampler / Sampler 节点
- CLIP Text Encode
- VAELoader / VAEDecode
- Image Scale 节点
- ControlNet 处理器

```python
# 示例：通过 InvokeAI 的 REST API 编程设置生成参数（v6.12.0+）
import requests

response = requests.post(
    "http://localhost:9090/api/v1/sessions",
    json={
        "model": "stable-diffusion-xl-base-1.0",
        "width": 1024,
        "height": 1024,
        "steps": 30,
        "cfg_scale": 7.5,
        "scheduler": "euler_a",
        "positive_prompt": "赛博朋克城市夜景，霓虹灯光，高度细致",
        "negative_prompt": "模糊，低质量，变形"
    }
)
print(response.json()["session_id"])
```

## 性能基准测试 / 实际用例

### SDXL 生成速度（RTX 3060 Ti，8GB VRAM）

| 平台 | 768×1024（平均） | 1024×1024（平均） | 说明 |
|------|-----------------|-------------------|------|
| **InvokeAI** | 18.83秒 | 24.44秒 | 专业 UI，队列系统 |
| **ComfyUI** | 16.16秒 | 21.47秒 | 原始生成速度最快 |
| **AUTOMATIC1111** | 27.33秒 | 36.00秒 | VRAM 开销最大 |
| **Fooocus** | ~22秒 | ~28秒 | 仅针对 SDXL 优化 |

*来源：独立基准测试，Ryzen 5800X + RTX 3060 Ti，30 步，Euler ancestral，CFG 7，MBB XL 模型。*

### VRAM 使用对比（FLUX Dev，1024×1024）

| 平台 | VRAM 使用 | 说明 |
|------|----------|------|
| InvokeAI | 14.2 GB | 高效的模型缓存 |
| ComfyUI | 13.8 GB | 最低开销 |
| AUTOMATIC1111 | 16.1 GB | 单体架构 |
| Fooocus | 12.5 GB | 仅限于 SDXL 工作流 |

## 高级用法 / 生产环境加固

### 多用户模式（v6.12.0+）

InvokeAI 现在支持在单个后端上运行多个隔离账户：

```bash
# 在 .env 中启用多用户模式
INVOKEAI_ENABLE_MULTIUSER=true
```

每个用户拥有：
- 独立的图像画板和画廊
- 独立的画布状态
- 独立的 UI 偏好设置
- 基于角色的访问（管理员与普通用户）

管理员管理模型和会话队列；普通用户无法添加或删除系统模型。

### 反向代理与 SSL

```nginx
# 生产环境 Nginx 配置
server {
    listen 443 ssl http2;
    server_name invokeai.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:9090;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 86400;
    }
}
```

### 使用 systemd 管理服务

```ini
# /etc/systemd/system/invokeai.service
[Unit]
Description=InvokeAI Creative Engine
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/InvokeAI/docker
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

启用并启动：

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now invokeai
```

### 使用 Prometheus 监控

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9091:9090"

  dcgm-exporter:
    image: nvcr.io/nvidia/k8s/dcgm-exporter:latest
    runtime: nvidia
    ports:
      - "9400:9400"
```

### 自动备份

```bash
#!/bin/bash
# /opt/invokeai-backup/backup.sh
BACKUP_DIR="/backups/invokeai"
DATE=$(date +%Y%m%d-%H%M%S)

# 备份生成的图像和模型
tar czf "$BACKUP_DIR/images-$DATE.tar.gz" /opt/invokeai-data/images
tar czf "$BACKUP_DIR/models-$DATE.tar.gz" /opt/invokeai-data/models

# 只保留最近 7 天
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete
```

添加到 crontab：

```bash
0 2 * * * /opt/invokeai-backup/backup.sh
```

## 与替代方案对比

| 功能 | InvokeAI | AUTOMATIC1111 | ComfyUI | Fooocus |
|------|----------|---------------|---------|---------|
| **WebUI 完善度** | 专业，为创意人员设计 | 功能齐全但较旧 | 极简，节点为主 | 极简，提示词为主 |
| **节点式工作流** | 是，可视化编辑器 | 否（基于扩展） | 是，原生支持 | 否 |
| **画布（内/外绘）** | 完整图层画布 | 基础内绘 | 通过自定义节点 | 有限 |
| **多用户支持** | 原生（v6.12.0+） | 否 | 否 | 否 |
| **模型支持** | SD 1.5, SDXL, FLUX, Z-Image | SD 1.5, SDXL, FLUX（通过扩展） | 全部（通过自定义节点） | 仅 SDXL |
| **首次运行配置时间** | 15 分钟（Docker） | 10 分钟 | 15 分钟 | 5 分钟 |
| **REST API** | 完整 API | 部分 | 无原生 API | 无 |
| **VRAM 效率** | 良好（FLUX 14.2 GB） | 较差（FLUX 16.1 GB） | 最佳（FLUX 13.8 GB） | 良好（SDXL 12.5 GB） |
| **画廊管理** | 画板、标签、元数据 | 基础文件浏览器 | 无 | 基础 |
| **许可证** | Apache-2.0 | AGPL-3.0 | GPL-3.0 | GPL-3.0 |
| **GitHub 星标** | 27.2K | 75K+ | 75K+ | 40K+ |

## 局限性 / 诚实评估

**InvokeAI 不适合的场景：**

1. **一键休闲生成** — 如果你只想输入提示词并获得图像，Fooocus 的设置和使用更快捷。InvokeAI 的强大功能伴随着学习曲线。

2. **高度实验性管道** — ComfyUI 的节点生态系统更大、更前沿。新的研究实现（如视频生成、3D）通常先在 ComfyUI 中发布。

3. **低于 8GB VRAM** — InvokeAI 的专业 UI 功能消耗额外内存。在 6-8GB 显卡上，ComfyUI 或 Forge 提供更好的性能。InvokeAI 建议 FLUX 工作流至少 12GB+ VRAM。

4. **macOS GPU 加速** — macOS 上的 Docker 不支持 GPU 透传。原生安装可以运行，但生成仅限 CPU，速度明显较慢。Apple Silicon 用户可能更喜欢 DiffusionBee 或原生 ComfyUI。

5. **实时协作编辑** — 多用户模式隔离用户但不支持同时画布协作。每个用户独立工作。

## 常见问题

### 运行 InvokeAI 需要什么硬件？

最低：8GB VRAM（NVIDIA RTX 3060 或更高），16GB RAM，50GB 可用磁盘空间。推荐：12GB+ VRAM（RTX 3060 Ti / 4060 Ti），32GB RAM，SSD 存储。FLUX 模型：16GB+ VRAM（RTX 4080 / 4090）。InvokeAI 支持 NVIDIA CUDA、AMD ROCm 和仅 CPU 回退。

### 没有 GPU 可以运行 InvokeAI 吗？

可以，InvokeAI 支持仅 CPU 系统，但生成速度慢 10-20 倍。使用 CPU Docker 配置文件：`docker compose --profile cpu up -d`。在现代 8 核 CPU 上，1024×1024 图像约需 2-5 分钟。这适合测试但不适合生产使用。

### InvokeAI 如何处理模型许可？

InvokeAI 本身是 Apache-2.0 许可。你下载的模型（SD 1.5、SDXL、FLUX）有自己的许可。InvokeAI 的模型管理器在下载前显示许可信息。商业使用取决于具体模型许可 —— 生产部署前务必核实。

### 可以从 AUTOMATIC1111 迁移到 InvokeAI 吗？

可以。InvokeAI 可以使用 A1111 安装中的现有 `.safetensors` 和 `.ckpt` 模型。将 `INVOKEAI_ROOT` 指向你现有的模型目录，或将模型复制到 InvokeAI 模型文件夹。注意 A1111 扩展和脚本不会转移 —— InvokeAI 使用自己的节点式工作流系统。

### 如何更新 InvokeAI 到新版本？

Docker 安装：拉取最新镜像并重启：

```bash
cd InvokeAI/docker
docker compose pull
docker compose up -d
```

裸机安装：使用启动器：

```bash
invokeai-update
```

主要版本更新前务必备份你的 `INVOKEAI_ROOT` 目录。

### InvokeAI 有托管/云版本吗？

InvokeAI 主要是自托管的。开发者提供 Invoke for Teams（商业产品），增加了云托管、团队协作和企业支持。个人用户通常在本地 GPU 或云 VPS（DigitalOcean、RunPod）上自托管。

### v6.12.0 中的多用户模式如何工作？

多用户模式创建具有独立画廊、画布状态和偏好的独立账户。管理员账户管理模型和系统设置。通过 `INVOKEAI_ENABLE_MULTIUSER=true` 启用。每个用户使用用户名和密码登录。在 v6.12.0 中标记为实验性功能 —— 未来版本将持续改进。

## 总结

InvokeAI 在 AI 图像生成生态中填补了特定空白：一款专业级、自托管的创意工具，将 Stable Diffusion 的强大功能与精致的用户体验相结合。v6.12.0 版本带来了多用户支持、扩展的 FLUX 兼容性和改进的画廊管理 —— 使其适合小型工作室和设计团队。基于 Docker 的部署简单直接，节点工作流系统功能强大，Apache-2.0 许可允许无限制商业使用。

**下一步：**
1. 克隆仓库并在本地运行 Docker 配置
2. 通过模型管理器安装你的第一个 SDXL 或 FLUX 模型
3. 为你的特定用例构建节点式工作流
4. 加入社区：[InvokeAI Discord](https://discord.gg/ZmtBAhwWhy)

关注我们的 Telegram 频道获取每周开源 AI 工具更新：[dibi8 announcements](https://t.me/dibi8com)



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [InvokeAI GitHub 仓库](https://github.com/invoke-ai/InvokeAI)
- [InvokeAI 官方文档](https://invoke.ai/)
- [InvokeAI v6.12.0 发布说明](https://invoke.ai/releases/version/v6-12-0/)
- [InvokeAI Docker 配置指南](https://github.com/invoke-ai/InvokeAI/tree/main/docker)
- [NVIDIA Container Toolkit 安装](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- [AMD ROCm Docker 文档](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/docker.html)
- [SDXL 速度测试：InvokeAI vs ComfyUI vs A1111](https://lilys.ai/en/notes/comfyui-20260115/sdxl-speed-test-comfyui-invokeai-a1111)
- [ComfyUI vs InvokeAI vs Fooocus 对比](https://toolhalla.ai/blog/comfyui-vs-invokeai-vs-fooocus-2026)
- [InvokeAI PyPI 包](https://pypi.org/project/InvokeAI/)

---

*本文包含 DigitalOcean 联盟链接。通过此链接注册，我们会在不向你额外收费的情况下获得佣金。这有助于支持网站和我们的开源内容。所有观点和基准测试均为独立制作。*
