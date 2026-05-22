---
title: 'ComfyUI 2026：114k 星节点式 AI 图像/视频/音频工作流引擎完整指南'
description: 'ComfyUI 是 114k 星节点式可视化工作流引擎，支持 SD/SDXL/Flux/Wan/Hunyuan 等。支持图像、视频、音频、3D 生成。2026 完整安装指南：节点基础、workflow JSON 导入、ComfyUI Manager、何时 ComfyUI 胜过 AUTOMATIC1111。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA]
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: GPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/comfyanonymous/ComfyUI'
stars: 114000
maintainer: 'comfyanonymous'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['ComfyUI', '图像生成', '视频生成', '节点式', '工作流', '开源']
aliases:
  - /posts/comfyui-node-based-ai-image-2026/
---

如果 [AUTOMATIC1111](/zh/resources/ai-tools/stable-diffusion-webui-2026/) 是"AI 图像生成的 Photoshop"（打字生图），**ComfyUI** 就是 **"生成式 AI 的 Blender 节点编辑器"** —— 你把工作流当有向图来搭，对每个模型、采样器、条件步、后处理都有显式控制。114k GitHub 星，GPL-3.0，支持 2024-2026 出的几乎所有生成式 AI 模型家族：SD 1.x、SDXL、SD3/3.5、Flux（1 & 2）、Wan、Hunyuan（图/视频/3D）、PixArt、AuraFlow、LTX-Video。

2026 现实：认真做 AI 图像、视频或多模态管线的都跑 ComfyUI。轻度创作者用 A1111。两者都对 —— 是不同心智模型的不同工具。

## TL;DR

- **是什么**：生成式 AI 的节点式可视化工作流编辑器
- **GitHub**：114k 星
- **License**：GPL-3.0
- **模型**：SD/SDXL/SD3.5/Flux/Wan/Hunyuan/PixArt/AuraFlow/LTX-Video —— 基本全部
- **VRAM**：最低 1 GB（智能 offload）；SDXL 8 GB+ 舒服；Flux/视频 16 GB+
- **平台**：NVIDIA / AMD / Intel / Apple Silicon / 纯 CPU

## 1. 复杂工作时节点式胜过线性 UI

A1111 UI 假设一输入 → 一输出。ComfyUI 假设"你可能想"：
- 用不同 sampler 一次生 4 张候选图
- SDXL 输出送进 Flux refiner
- 一个模型做主体，另一个做背景，ControlNet 合成
- 视频生成循环，帧间一致性
- 同一管线里跑音频生成 + 图像生成

每个在 A1111 线性 UI 里都很乱或不可能。ComfyUI 里只是几个额外节点连起来。

代价：ComfyUI 心智模型要个周末才"通"。A1111 5 分钟。

## 2. 硬件（2026 真实数字）

ComfyUI 智能内存管理比 A1111 好得多。同 GPU 在 ComfyUI 干更多事：

| GPU | SDXL | Flux dev | Hunyuan 视频（5s）|
|---|---|---|---|
| 4 GB（带 offload）| ~30 秒 | 可能但慢 | 不行 |
| 8 GB | ~6 秒 | ~25 秒 | ~4 分 |
| 12 GB | ~3 秒 | ~12 秒 | ~2 分 |
| 24 GB（RTX 4090）| ~2 秒 | ~5 秒 | ~45 秒 |
| 48 GB+（A6000/H100）| ~1 秒 | ~2 秒 | ~15 秒 |

云端：Vast.ai 上 H100 $1.50/小时，或 {{< aff "digitalocean" "comfyui-gpu" "DigitalOcean GPU droplet" >}} 24 GB GPU；只按生成时间付费。

## 3. 快装（10 分钟）

```bash
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI
pip install -r requirements.txt
python main.py
# UI 开在 http://localhost:8188
```

或用独立 Windows 便携包（一键启动器）。

装完第一件事：装 **ComfyUI Manager**（最接近"扩展商店"的东西）：
```bash
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager
```

重启 ComfyUI。Manager 处理模型下载、自定义节点安装、工作流管理。

## 4. 80% 时间用的 5 个节点

ComfyUI 有上百种节点类型，但核心 5 个覆盖多数工作流：

1. **Load Checkpoint** —— 加载基础模型（SDXL / Flux 等）
2. **CLIP Text Encode** —— 编码正负 prompt
3. **KSampler** —— 实际扩散采样步（魔法发生处）
4. **VAE Decode** —— 潜在表示转像素图
5. **Save Image** —— 保存输出

接线：Checkpoint → CLIP Text Encode（正 + 负）→ KSampler → VAE Decode → Save Image。这就是图形化的 "txt2img"。

## 5. Workflow JSON —— 杀手特性

每个 ComfyUI 工作流可导出为 JSON。把 JSON 拖到画布上整个工作流加载 —— 节点、接线、参数全有。

这巨大：
- Reddit / Civitai / OpenArt 满是社区分享的工作流可以直接拖
- 别人花 3 天搭的"视频生成管线"或"可控换脸"工作流现在是你的起点
- 可复现性：同 workflow JSON + 同模型文件 = 字节级相同输出

社区工作流事实仓库：**OpenArt Workflows** / **ComfyWorkflows.com** / Civitai workflow 区。

## 6. ComfyUI Manager（缺失的 app store）

单一最重要自定义节点。ComfyUI Manager 提供：
- 500+ 社区自定义节点一键装
- 模型下载器（Civitai / HuggingFace）自动放对文件夹
- 工作流快照和恢复
- ComfyUI 核心 + 所有自定义节点更新检查
- 缺节点检测（加载工作流缺节点时提示）

没 Manager 时 ComfyUI 可用性大降。永远在装完 ComfyUI 后第 2 步装它。

## 7. 视频 / 音频 / 3D 生成（2026 超能力）

ComfyUI 是唯一主流 UI，最新视频和 3D 模型 day-1 就工作：

- **Wan 2.1 / 2.2** —— 开源视频生成（图到视频 / 文到视频）
- **Hunyuan Video** —— 16 GB VRAM 上 720p 5 秒片段
- **LTX-Video** —— 快视频生成，12 GB VRAM 上 720p/24fps ~30 秒
- **Hunyuan3D** —— 从图像生成 3D mesh
- **PixArt Sigma** —— 替代高质量图像模型
- **Stable Audio Open** —— 同图里音频生成

"文 → 图 → 视频 → 音频旁白" 管线，别处要 4 个独立工具，ComfyUI 一个工作流。

## 8. 生产自托管模式

"AI 媒体生成 API" 部署：

```
   GPU 实例（推荐 24 GB VRAM）
            │  在 Vast.ai / RunPod / {{< aff "digitalocean" "comfyui-droplet" "DigitalOcean GPU" >}}
            ▼
   ComfyUI 加 --listen 0.0.0.0（HTTP API 暴露）
            │
            ▼
   你的 wrapper service：
   - POST /run 带 workflow JSON + 覆盖参数
   - 返 job_id，WebSocket 流进度
   - 最终输出存 S3
```

ComfyUI 暴露 `POST /prompt` 端点接 workflow JSON。在上面搭薄 auth + 队列层，你有自托管 Midjourney 替代 API。

## 9. ComfyUI vs A1111 vs SwarmUI

| 挑 | 何时 |
|---|---|
| **ComfyUI** | 复杂工作流、多模型、视频、音频、要精确可复现、要把 AI 媒体作为产品 ship |
| **AUTOMATIC1111** | 单图生成，80% 轻度用例，最大扩展库，最低学习曲线。看我们的 [A1111 指南](/zh/resources/ai-tools/stable-diffusion-webui-2026/) |
| **SwarmUI** | 要 ComfyUI 力量但 A1111 UI —— 自动把简单表单输入转成底层 ComfyUI 工作流 |

诚实路径：新手先用 A1111。需要视频、多模型管线、像素级可复现时迁 ComfyUI。

## 10. 坑

1. **跳过 ComfyUI Manager** —— "怎么找这个节点"问题装了 Manager 都没了
2. **手动放模型文件** —— 模型在特定子目录（`models/checkpoints/` / `models/loras/` 等）。Manager 自动处理；手工易错
3. **加载不懂的工作流** —— Reddit 工作流可能 200+ 节点。从简单开始改
4. **忽略内存管理设置** —— `--lowvram` / `--medvram` 在小 GPU 上是"行"和"OOM"的差距
5. **工作流不版本控制** —— 把 workflow JSON 和代码一起 git。未来你会感谢现在你

## TL;DR

ComfyUI = **节点式 AI 媒体生成工作流引擎，2026 单图 txt2img 之外的默认**。114k 星，支持所有现代模型家族（SD/SDXL/Flux/Wan/Hunyuan 等），4-48 GB GPU 上工作。

装 ComfyUI + ComfyUI Manager（共 ~15 分钟），把 OpenArt 社区工作流拖到画布上，看生成式 AI 作为有向图的方式让 A1111 永远无法呈现。

---

*dibi8 多模态内容 stack 的一部分 —— 配 [Stable Diffusion WebUI 轻度用](/zh/resources/ai-tools/stable-diffusion-webui-2026/) 和 [ChatTTS 做语音](/zh/resources/ai-tools/chattts-dialogue-tts-2026/)。见即将上线的多模态内容 Pipeline 合集拿完整创作者 stack。*
