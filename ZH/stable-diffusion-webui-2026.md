---
title: 'Stable Diffusion WebUI 2026（AUTOMATIC1111）：163k 星自托管图像生成完整指南'
description: 'AUTOMATIC1111 stable-diffusion-webui 是 163k 星的自托管 SD/SDXL 图像生成事实标准 UI。2026 完整安装+生产指南：txt2img / img2img / 修复 / 扩展 / LoRA / ControlNet、硬件要求、替代品（Forge / SD.Next）。'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, Gradio, CUDA]
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
tags: ['Stable Diffusion', 'SDXL', '图像生成', 'AUTOMATIC1111', '开源']
aliases:
  - /posts/stable-diffusion-webui-2026/
---

过去 3 年 Google "stable diffusion install" 第一个结果一直是 **AUTOMATIC1111 stable-diffusion-webui**。163k GitHub 星（史上最多星 AI 项目之一），是 2026 SD 家族图像生成的自托管默认 UI —— txt2img / img2img / 修复 / 扩展 / LoRA / ControlNet / 批量生成，全在 Gradio web UI 后面，4 GB GPU 就能跑。

这是个人创作者和 dev "想本地生图不付 $20/月给 Midjourney" 的答案。复杂工作流（多模型管线 / 视频生成 / 音频）见 [ComfyUI](/zh/resources/ai-tools/comfyui-node-based-ai-image-2026/) —— 两者互补，不是竞争。

## TL;DR

- **是什么**：SD 家族模型的 Gradio web UI
- **GitHub**：163k 星，7689+ commits，最新 v1.10.1
- **License**：AGPL-3.0（SaaS 部署注意）
- **模型**：原生 SD 1.5 / 2.x / SSD-1B / Alt-Diffusion；扩展支持 SDXL；fork 支持 SD3 / Flux
- **硬件**：最低 4 GB VRAM（有 2 GB 报告 `--lowvram` 能跑）
- **值得知道的 fork**：Forge（更快，SDXL/Flux 重点）/ SD.Next（rolling release）

## 1. 为什么 A1111 在 2026 还是默认

Flux（2024 年 9 月）和 SD 3.5 后图像生成生态严重碎片化。ComfyUI 占据"复杂管线"niche。但 A1111 仍是默认因为：

1. **学习曲线最低** —— 文本框、生成按钮、完事
2. **扩展最多** —— 500+ 扩展处理 ControlNet / ADetailer / Regional Prompter / 训练等
3. **教程最多** —— 4 年 Reddit/YouTube 内容都是 A1111 形状
4. **够 80% 用例** —— 只要"文字到好图"，ComfyUI 图形视图杀鸡用牛刀

新手本地图像生成：从这里开始。outgrow 它时迁 ComfyUI。

## 2. 硬件真实数字（2026）

| GPU | SD 1.5（512×768）| SDXL（1024×1024）| Flux（1024×1024）|
|---|---|---|---|
| 4 GB（GTX 1650 / 3050）| ~15 秒/图 | ~60 秒（`--lowvram`）| 不实用 |
| 8 GB（RTX 3060 / 4060）| ~5 秒 | ~12 秒 | ~30 秒（`--medvram`）|
| 12 GB（RTX 3060 12GB / 4070）| ~3 秒 | ~6 秒 | ~15 秒 |
| 16-24 GB（RTX 4080 / 4090）| ~1.5 秒 | ~3 秒 | ~6 秒 |

云端用：Vast.ai 或 {{< aff "digitalocean" "sd-gpu" "DigitalOcean GPU droplet" >}} $0.30-0.50/小时 GPU 实例，任何有意义量上比 Midjourney 便宜。

## 3. 快装（15 分钟）

**Linux/macOS**：
```bash
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
./webui.sh  # 自动装 Python 依赖，下默认模型
```

**Windows**：下最新 release zip，解压，跑 `webui-user.bat`。

首次运行下 ~4 GB（默认 SD 1.5 模型）+ ~2 GB Python 依赖。浏览器打开 `http://localhost:7860`。

## 4. 80/20 设置

"给我生张好图" 工作流：

- **Sampler**：DPM++ 2M Karras 或 Euler a
- **Steps**：20-30（30 以上收益递减）
- **CFG Scale**：7（越低越创意，越高越死板）
- **分辨率**：SD 1.5 用 512×768，SDXL 用 1024×1024
- **Negative prompt 基线**：`bad anatomy, blurry, low quality, watermark, text, signature`

高质量：开 Hires fix（2× 上采样 + denoise 0.4-0.5），代价是 2× 生成时间。

## 5. 必装扩展

500+ 扩展里 top picks：

- **ControlNet** —— pose / depth / canny / scribble 条件控制。最有用单一扩展
- **ADetailer** —— 自动修脸和手（SD 两个失败模式）
- **Regional Prompter** —— 不同区域不同 prompt
- **Dynamic Prompts** —— wildcard 语法 `{red|blue|green} car`
- **Civitai Helper** —— 管理 Civitai 下载的模型
- **sd-webui-prompt-history** —— 找回过去生成的 prompt

装：Extensions tab → Install from URL → 贴 GitHub URL → Apply 重启。

## 6. LoRA / Embedding / ControlNet 工作流

三种定制机制：

- **LoRA**（Low-Rank Adaptation）—— 小文件（~150 MB），把基础模型适配到特定风格或主题。丢 `models/Lora/`，prompt 里引用：`<lora:style_name:0.8>`
- **Textual Inversion / Embeddings** —— 更小（~30 KB），单概念添加。丢 `embeddings/`，prompt 里打触发词
- **ControlNet** —— pose / depth / 线稿等条件生成。模型进 `models/ControlNet/`

Civitai 是社区 LoRA 和 checkpoint 的事实 hub。Civitai Helper 扩展自动同步你本地文件和元数据。

## 7. SDXL / SD3 / Flux 支持（2026 现状）

开箱 A1111 主线做 SD 1.x/2.x。新模型：

- **SDXL** —— v1.6 起主线工作
- **SDXL Turbo / Lightning** —— 工作，配置为加速 SDXL
- **SD 3.5** —— 需 Forge fork 或扩展，主线落后
- **Flux** —— 需 Forge fork；A1111 主线到 v1.10 不支持 Flux
- **要以上 + Wan + Hunyuan 全部？** 切 [ComfyUI](/zh/resources/ai-tools/comfyui-node-based-ai-image-2026/)

2026 日用 SDXL：A1111 主线行。Flux-first 创意管线：Forge fork。全支持：ComfyUI。

## 8. 生产自托管模式

"个人图像 API" 部署：

```
   {{< aff "digitalocean" "sd-droplet" "GPU droplet" >}}（RTX 6000 Ada $0.50/小时 或 Vast.ai）
            │
            ▼
   A1111 开 --api flag
            │
            ▼
   内部 FastAPI wrapper（auth + 限流 + 队列）
            │
            ▼
   你的 app / agent 调 /sdapi/v1/txt2img
```

成本例：8 小时/天 × $0.50/小时 × 30 天 = $120/月无限生成，vs Midjourney $30/月 200 fast 小时。中等用量打平。

## 9. A1111 vs Forge vs SD.Next vs ComfyUI

| 挑 | 何时 |
|---|---|
| **A1111 主线** | 默认，SD 1.x/SDXL 焦点，最大扩展生态 |
| **Forge** | 同 A1111 UI 但快 30-75%，SDXL/Flux 就绪，VRAM 占用更小 |
| **SD.Next** | Rolling release，几乎支持 A1111+Forge 所有但单 fork |
| **ComfyUI** | 复杂工作流，视频生成，音频，最新模型 day-1，节点式控制 |

2026 诚实推荐：先试 A1111 主线。要 Flux 或速度，切 Forge。线性 UI 心智模型不够用了，学 ComfyUI。

## TL;DR

AUTOMATIC1111 SD WebUI = **2026 个人创作者自托管图像生成默认**。163k 星，最低 4 GB VRAM，开箱跑 SD 1.x/SDXL。配 Civitai 社区模型，ControlNet/LoRA/ADetailer 做高级控制。

开 GPU 实例，跑第 3 节安装，15 分钟后你有本地图像生成，任何有意义量上和 Midjourney 打平。

---

*dibi8 多模态内容 stack 的一部分 —— 见 [ComfyUI 节点式工作流](/zh/resources/ai-tools/comfyui-node-based-ai-image-2026/) 和即将上线的多模态内容 Pipeline 合集。*
