---
title: 'ComfyUI 工作流 2026：新手搭建指南 + 5 套生产级模板'
description: 'ComfyUI 在 2026 年突破 10.6 万 GitHub stars。新手友好的搭建指南、2026 年模型推荐，以及 5 套可直接投产的工作流模板（文生图、局部重绘、放大、视频、角色一致性）。'
date: 2026-05-25 00:00:00+08:00
lastmod: 2026-05-25 00:00:00+08:00
tech_stack: ['ComfyUI', 'Stable Diffusion', 'Python', 'CUDA']
application_domain: AI 工具
source_version: 'ComfyUI 2026.05'
licensing_model: 开源
license_type: 'GPL-3.0'
github_repo: 'https://github.com/comfyanonymous/ComfyUI'
stars: 106000
maintainer: 'comfyanonymous'
last_maintained: '2026-05-25'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['comfyui', 'stable-diffusion', 'image-generation', 'workflows', '2026']
aliases:
- /zh/posts/comfyui-workflow-2026-5-production-templates/
faq:
  - q: "2026 年 ComfyUI 比 Stable Diffusion WebUI 更好用吗？"
    a: "在工作流自动化和生产场景下：是的，毫无悬念。ComfyUI 基于节点图，让复杂的多步流水线（放大 → 局部重绘 → ControlNet → 再次渲染）变得轻而易举。SD WebUI 更适合一次性出图。大多数职业 AI 艺术家两个都用。"
  - q: "需要什么样的硬件？"
    a: "最低配置：8GB 显存（RTX 3060、RTX 4060），可跑中等画质的 SDXL。舒适配置：16GB+ 显存（RTX 4080、4090），可跑 SDXL + Flux 模型 + LoRA 叠加。生产配置：H100 / 多卡，适合批量工作流。"
  - q: "2026 年应该先下载哪些模型？"
    a: "三大优先级：(1) SDXL base + refiner（依然是主力），(2) Flux.1 Schnell（速度更快，适合原型迭代），(3) Stable Diffusion 3.5 Large（最强写实）。再加 2-3 个符合你风格的 LoRA。在没有明确需求前，先别去碰 Civitai 上那几十个角色 LoRA。"
  - q: "从零学 ComfyUI 需要多久？"
    a: "加载一个工作流并出图：30 分钟。自己搭建工作流：1-2 天。精通节点用于生产：2-3 周。学习曲线一开始很陡，但回报丰厚——工作流可复用、可分享、可复现。"
---

{{</* resource-info */>}}

# ComfyUI 工作流 2026：搭建指南 + 5 套生产模板

> **Meta Description**：ComfyUI 在 2026 年突破 10.6 万 stars。搭建指南 + 5 套可投产的工作流模板（文生图、局部重绘、放大、视频、角色一致性）。

2026 年，ComfyUI 已成为严肃 AI 图像生成的默认工具。基于节点、可复现、可自动化。本指南带你在一个下午从零搭出 5 套可用的生产工作流。

## ⚡ TL;DR

> **为什么用 ComfyUI**：工作流可复现、可自动化、支持复杂流水线。2026 年突破 10.6 万 stars。
>
> **硬件门槛**：最低 8GB 显存，16GB+ 才舒适。
>
> **搭建耗时**：1 小时即可首次出图。
>
> **下文 5 套模板**：文生图、局部重绘、放大链、视频、角色一致性。

## 搭建（1 小时）

### 第 1 步：安装（15 分钟）
```bash
# 克隆 + 配置虚拟环境
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI
python -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python main.py
```

浏览器会自动打开 `http://localhost:8188`。

### 第 2 步：下载模型（30 分钟）
放进 `ComfyUI/models/checkpoints/`：
- **SDXL base + refiner**（最通用，总计约 13GB）
- **Flux.1 Schnell**（快速原型，约 24GB）
- **SD 3.5 Large**（最强写实，约 17GB）

可选但实用：
- 2-3 个符合你风格的 LoRA（在 Civitai 搜索 "2026 SDXL trending"）
- ControlNet 模型（OpenPose、Depth、Canny — 每个约 1.5GB）

### 第 3 步：首次出图（15 分钟）
- 从 `ComfyUI/workflows/` 拖入默认工作流
- 加载 SDXL checkpoint
- 输入提示词
- 队列生成

完成。你已经能出图了。真正的难点从现在开始：搭建可复用的工作流。

## 5 套生产级模板

### 模板 1：文生图（SDXL base + refiner）
**用途**：标准生成，日常主力。
**节点**：Load Checkpoint → CLIP Text Encode (prompt) → KSampler (base 70%) → KSampler (refiner 30%) → VAE Decode → Save Image。
**单张耗时**：RTX 4090 上 8-15 秒。

### 模板 2：局部重绘遮罩（精准编辑）
**用途**：只改图中某个区域，不重新生成整张图。
**节点**：Load Image → MaskEditor → CLIP Text Encode（新内容）→ InpaintModelConditioning → KSampler → 合成回原图。
**单次编辑耗时**：5-10 秒。

### 模板 3：4 倍放大链（4K 输出）
**用途**：把 1024×1024 的生成结果放大到 4096×4096 的生产级输出。
**节点**：1024 生成 → Upscale Latent 2x → KSampler 精修 → 再次 Upscale Latent 2x → 最终精修。
**耗时**：4K 出图每张 30-45 秒。

### 模板 4：图生视频（5 秒短片）
**用途**：把静帧动画化为 5 秒动态短片。
**节点**：Load SVD model → Load Image → Image to Video（24 帧 @ 8fps）→ VAE Decode → Save Video。
**耗时**：RTX 4090 上 60-90 秒。
**2026 推荐模型**：Stable Video Diffusion XT 或 LTX Video。

### 模板 5：角色一致性（LoRA + IPAdapter）
**用途**：在多个场景中保持同一角色面部一致。
**节点**：Load LoRA（角色训练版）+ IPAdapter（参考图）→ CLIP Text Encode → KSampler → 输出。
**单张耗时**：12-20 秒。
**诀窍**：用 15-20 张同一角色的源图自训一个 LoRA — 剩下的交给 IPAdapter。

## 工作流分享

上述 5 套模板都可保存为 `.json`。拖到 ComfyUI 画布即可加载。可以通过 git 或 Discord 与团队共享。

社区已公开数千套工作流：
- ComfyUI subreddit
- OpenArt.ai 工作流库
- Civitai（用 "ComfyUI workflow" 过滤器筛选）

引入 2-3 套社区工作流再按自己风格改造。多数职业艺术家就是这么干的 — 不是从零搭建。

## 推荐基础设施

如果你打算认真做 ComfyUI：
- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — 200 美元额度，GPU droplet（H100/L40S/A100）
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 香港 VPS，亚洲低延迟出图首选

*推广链接 — 同价不加价，支持 dibi8.com。*

## 结语

ComfyUI 的学习曲线很真实，但回报同样真实。当你拥有 5 套可复用的工作流后，出活速度会甩开任何一次性生成工具。2026 年的生态（Flux、SD 3.5、IPAdapter、ControlNet 的改进）是迄今为止最强的图像生成栈 — 而 ComfyUI 是唯一能把它们干净编排起来的工具。

从上面 5 套模板开始。改造。分享。可复用工作流的复利效应会在第 2 周后显现 — 那时你会发现，自己组合节点的速度比写代码还快。

---

**相关阅读**：[Stable Diffusion WebUI 搭建](https://dibi8.com/zh/resources/ai-tools/stable-diffusion-webui/) · [2026 年顶级 AI 图像生成工具](https://dibi8.com/zh/resources/ai-tools/ai-image-generation-tools-2025/) · [2026 本地优先 AI 技术栈](https://dibi8.com/zh/resources/llm-frameworks/2026-local-first-ai-stack-production-architecture/)
