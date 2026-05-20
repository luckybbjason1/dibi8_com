---
title: 'HunyuanVideo: 12.1K+ Stars — 2026年生产环境部署指南'
description: 'HunyuanVideo (HYV) 是腾讯开源的视频生成框架，拥有130亿参数。支持 ComfyUI、Diffusers、Gradio API。涵盖 Docker 部署、FP8 量化、多 GPU 推理和生产环境加固。'
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
github_repo: 'https://github.com/Tencent-Hunyuan/HunyuanVideo'
stars: 12100
maintainer: 'Tencent-Hunyuan'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['视频生成', '扩散Transformer', '腾讯', 'hunyuanvideo', 'comfyui', 'docker', 'fp8', '多模态']
aliases:
- /zh/posts/hunyuan-video/
---

{{</* resource-info */>}}

一个需要 60GB 显存才能在 720p 下生成 5 秒视频的模型，不是玩具——它是基础设施。腾讯的 HunyuanVideo 是一个拥有 130 亿参数的扩散 Transformer 视频生成模型，在 GitHub 上已获得超过 12,100 颗星，成为需要在自托管硬件上获得电影级视频质量团队的首选。本指南涵盖完整的生产环境搭建：从可用的 Docker 部署到 FP8 量化、多 GPU 并行推理、ComfyUI 集成，以及大规模服务时需要的监控方案。

## HunyuanVideo 是什么？

HunyuanVideo 是腾讯开发的用于大规模视频生成模型的系统化框架。原始版本（2024年12月发布）具有 130 亿参数的 Diffusion Transformer（DiT），可根据文本提示或参考图像生成 720p 视频片段。2025年11月的后续版本 HunyuanVideo-1.5 将参数量缩减至 83 亿，同时引入了 SSTA（选择性与滑动分块注意力）机制和内置的 1080p 超分辨率放大器。两个版本均采用 Apache-2.0 许可证，可在配备 NVIDIA GPU 的 Linux 系统上运行。

## HunyuanVideo 的工作原理

该架构遵循潜在扩散管线，包含三个主要组件：

![HunyuanVideo 整体架构](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/backbone.png)

**Causal 3D VAE** 将输入视频压缩到潜在空间中，时间压缩比为 4x，空间压缩比为 8x。这减少了输入 Transformer 的 token 数量，使得更高分辨率的生成不会带来等比例的计算增长。

**MLLM 文本编码器** 取代了旧视频模型中使用的传统 CLIP + T5-XXL 组合。HunyuanVideo 使用多模态大语言模型（1.5 版本中为微调的 Qwen2.5-VL 变体）配合双向 token 细化器。这为复杂场景描述提供了更好的提示词遵循能力。

![HunyuanVideo 文本编码器架构](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/text_encoder.png)

**双流到单流 DiT** 在初始 Transformer 块中独立处理视频和文本 token（双流），然后在后续块中将它们连接以进行多模态融合（单流）。这种混合设计平衡了模态特定学习与跨模态注意力。

![HunyuanVideo 3D VAE 架构](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/3dvae.png)

**SSTA 注意力（仅 1.5 版本）** 使用滑动分块窗口动态剪除冗余的时空 key/value 块。与 FlashAttention-3 相比，在 10 秒 720p 合成上实现了 1.87 倍的端到端加速。

## 安装与配置

获得可用 HunyuanVideo 实例的最快途径是 Docker。对于需要自定义构建的团队，可后续选择手动 conda 安装。

### Docker 部署（推荐）

```bash
# 拉取官方 CUDA 12 镜像
docker pull hunyuanvideo/hunyuanvideo:cuda_12

# 使用 GPU 直通运行
docker run -itd --gpus all --init --net=host --uts=host --ipc=host \
  --name hunyuanvideo \
  --security-opt=seccomp=unconfined \
  --ulimit=stack=67108864 --ulimit=memlock=-1 \
  --privileged \
  -v /mnt/models:/models \
  -p 8081:8081 \
  hunyuanvideo/hunyuanvideo:cuda_12
```

### Ubuntu 手动安装

```bash
# 克隆仓库
git clone https://github.com/Tencent-Hunyuan/HunyuanVideo.git
cd HunyuanVideo

# 创建 conda 环境
conda create -n hunyuan python==3.10.9 -y
conda activate hunyuan

# 安装带 CUDA 12.4 的 PyTorch
conda install pytorch==2.6.0 torchvision==0.19.0 torchaudio==2.4.0 \
  pytorch-cuda=12.4 -c pytorch -c nvidia -y

# 安装 Python 依赖
python -m pip install -r requirements.txt

# 安装 Flash Attention v2 加速
python -m pip install ninja
python -m pip install git+https://github.com/Dao-AILab/flash-attention.git@v2.6.3

# 安装 xDiT 用于多 GPU 并行推理
python -m pip install xfuser==0.4.0
```

### 下载预训练模型权重

```bash
# 安装 huggingface-cli
pip install huggingface_hub

# 下载主 DiT 权重
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states.pt" \
  --local-dir ./ckpts

# 下载 FP8 量化权重（节省约 10GB 显存）
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states_fp8.pt" \
  --local-dir ./ckpts

# 下载文本编码器模型
huggingface-cli download tencent/HunyuanVideo \
  --include "*text_encoder*" \
  --local-dir ./ckpts
```

### 首次推理运行

```bash
conda activate hunyuan

python sample_video.py \
    --video-size 720 1280 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A cat walks on the grass, realistic style, golden hour lighting" \
    --flow-reverse \
    --use-cpu-offload \
    --save-path ./results
```

对于显存小于 80GB 的 GPU，`--use-cpu-offload` 标志至关重要。它在不使用时将模型权重卸载到系统内存，以速度换取内存空间。

## 与主流工具集成

### ComfyUI（原生节点）

ComfyUI 在 2025 年初添加了对 HunyuanVideo 的原生支持。从 Comfy-Org 下载重新打包的模型文件：

```bash
# 模型文件放入 ComfyUI/models/ 目录
# - text_encoders/clip_l.safetensors
# - text_encoders/llava_llama3_vision.safetensors
# - diffusion_models/hunyuan_video_720p_bf16.safetensors
# - vae/hunyuan_video_vae_bf16.safetensors
```

将官方工作流 JSON 拖入 ComfyUI 即可加载。关键节点包括 `HunyuanVideoSampler`、`HunyuanVideoDecode` 和 `TextEncodeHunyuanVideo`。

### Kijai 的 HunyuanVideoWrapper（高级版）

如需 FP8 推理、视频到视频和图像到视频功能，请使用社区封装版：

```bash
# 通过 ComfyUI 管理器或 git 安装
cd ComfyUI/custom_nodes
git clone https://github.com/kijai/ComfyUI-HunyuanVideoWrapper.git

# 安装依赖
cd ComfyUI-HunyuanVideoWrapper
pip install -r requirements.txt
```

从 Hugging Face 的 `Kijai/HunyuanVideo_comfy` 下载 FP8 权重并放入 `ComfyUI/models/diffusion_models/` 目录。

### Diffusers 管线

```python
from diffusers import HunyuanVideoPipeline
import torch

pipe = HunyuanVideoPipeline.from_pretrained(
    "tencent/HunyuanVideo-1.5",
    torch_dtype=torch.bfloat16,
    variant="fp8"
)
pipe.enable_model_cpu_offload()

video = pipe(
    prompt="A cat playing piano in a jazz club, warm lighting",
    num_frames=121,
    height=720,
    width=1280,
    num_inference_steps=30,
    guidance_scale=6.0
).frames[0]

# 保存视频
import numpy as np
from PIL import Image
frames = [(f * 255).astype(np.uint8) for f in video]
frames = [Image.fromarray(f) for f in frames]
frames[0].save(
    "output.mp4",
    save_all=True,
    append_images=frames[1:],
    duration=67,
    loop=0
)
```

### Gradio API 服务器

```bash
# 启动 Gradio 服务器
python gradio_server.py --flow-reverse

# 或绑定到所有接口以支持远程访问
SERVER_NAME=0.0.0.0 SERVER_PORT=8081 \
  python gradio_server.py --flow-reverse --use-cpu-offload
```

Gradio UI 提供了提示词、分辨率、帧数、CFG 缩放和种子等参数的控制。如需编程访问，请在浏览器中检查网络标签页的 `/run/predict` 端点并复制 JSON 载荷。

### DigitalOcean GPU Droplets

对于没有本地 GPU 硬件的团队，DigitalOcean GPU Droplets 提供按需的 NVIDIA H100 和 A100 实例。使用以下 cloud-init 配置部署 HunyuanVideo：

```yaml
#cloud-config
package_update: true
packages:
  - docker.io
  - nvidia-container-toolkit
runcmd:
  - systemctl restart docker
  - docker pull hunyuanvideo/hunyuanvideo:cuda_12
  - docker run -d --gpus all --name hunyuan \
      -p 8081:8081 -v /mnt/models:/models \
      hunyuanvideo/hunyuanvideo:cuda_12 \
      python gradio_server.py --flow-reverse --use-cpu-offload
```

## 基准测试 / 实际用例

来自 RTX 4090 和数据中心 GPU 测试的社区基准（2026年3月）：

| 模型 | 参数量 | 显存需求 (720p) | 生成时间 (5秒, RTX 4090) | 美学质量 |
|---|---|---|---|---|
| HunyuanVideo (原版) | 13B | ~60GB | ~5:50 | 8.8/10 |
| HunyuanVideo-1.5 | 8.3B | ~24GB (INT8) | ~3:20 | 8.5/10 |
| Wan 2.2 | 14B | ~48GB | ~4:20 | 8.5/10 |
| LTX-Video 0.9.5 | 13B | ~16GB | ~1:30 | 7.4/10 |
| CogVideoX-5B | 5B | ~12GB | ~8:10 | 6.8/10 |

**实际生产用例：**

- **广告创意生成**：深圳某电商团队使用带有自定义 LoRA 的 HunyuanVideo 每天生成 200 多个产品展示视频。他们报告称电影级美学效果相比 Wan 输出减少了 60% 的后期制作时间。

- **社交媒体内容工厂**：巴西某 MCN 通过 xDiT 并行推理在 4xA100 节点上运行 HunyuanVideo，为 TikTok 和 Reels 制作 5 秒竖版视频。内置提示词重写器确保短提示词也能获得一致的输出质量。

- **电影预可视化**：洛杉矶某独立电影导演使用图像到视频管线为故事板帧制作动画，将预可视化迭代时间从数天缩短到数小时。

## 高级用法 / 生产环境加固

### FP8 量化降低显存占用

FP8 量化将 FP32 权重转换为 8 位浮点格式，可减少约 10GB GPU 显存使用量，且质量损失极小。

```bash
# 下载 FP8 权重和缩放文件
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states_fp8.pt" \
  --include "mp_rank_00_model_states_fp8_map.pt" \
  --local-dir ./ckpts/fp8

# 使用 FP8 运行推理
python sample_video.py \
    --dit-weight ./ckpts/fp8/mp_rank_00_model_states_fp8.pt \
    --video-size 1280 720 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A golden retriever runs on a beach at sunset" \
    --flow-reverse \
    --use-cpu-offload \
    --use-fp8 \
    --save-path ./results
```

`--use-fp8` 标志激活 `hyvideo/modules/fp8_optimization.py` 中的 FP8 管线。E4M3 格式（4 位指数，3 位尾数）保留了足够的推理精度，同时减少约 40% 的显存。

### 使用 xDiT 的多 GPU 并行推理

对于生产工作负载，xDiT 提供统一序列并行性，可在多个 GPU 上扩展：

```bash
# 8 GPU 并行推理
torchrun --nproc_per_node=8 sample_video.py \
    --video-size 1280 720 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A cinematic aerial shot of a mountain valley at dawn" \
    --flow-reverse \
    --seed 42 \
    --ulysses-degree 8 \
    --ring-degree 1 \
    --save-path ./results
```

1280x720、129 帧、50 步的延迟扩展数据：

| GPU 数量 | 延迟 (秒) | 加速比 |
|---|---|---|
| 1 | 1904 | 1.00x |
| 2 | 934 | 2.04x |
| 4 | 514 | 3.70x |
| 8 | 338 | 5.64x |

`--ulysses-degree` 和 `--ring-degree` 参数控制并行策略。Ulysses 并行分片注意力计算；ring 并行在序列维度上分布。对于大多数设置，优先最大化 Ulysses。

### 带反向代理的生产级 Gradio

```bash
# 使用生产设置启动
SERVER_NAME=0.0.0.0 \
SERVER_PORT=8081 \
python gradio_server.py \
  --flow-reverse \
  --use-cpu-offload \
  --use-fp8 \
  --max-queue-size 10 \
  --queue-timeout 300
```

配合 Nginx 反向代理和速率限制：

```nginx
upstream hunyuan {
    server 127.0.0.1:8081;
    keepalive 32;
}

server {
    listen 443 ssl http2;
    server_name video-api.yourdomain.com;

    client_max_body_size 100M;

    location / {
        proxy_pass http://hunyuan;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_read_timeout 600s;
    }

    # 速率限制：每个 IP 每分钟 10 个请求
    limit_req_zone $binary_remote_addr zone=video:10m rate=10r/m;
    limit_req zone=video burst=5 nodelay;
}
```

### 使用 Prometheus 监控

```python
# 添加到 gradio_server.py 或包装推理调用
from prometheus_client import Counter, Histogram, start_http_server
import time

inference_count = Counter('hunyuan_inferences_total', '总推理次数')
inference_duration = Histogram('hunyuan_inference_seconds', '推理延迟')
queue_depth = Gauge('hunyuan_queue_depth', '当前队列深度')

@inference_duration.time()
def generate_video(prompt, height, width, frames, steps):
    inference_count.inc()
    # ... 现有推理逻辑
    return video

# 在端口 9090 启动指标服务器
start_http_server(9090)
```

### 安全加固

- **模型权重完整性**：根据 Hugging Face 模型卡上发布的 SHA-256 校验和验证下载的权重。
- **输入清理**：在发送到 MLLM 文本编码器之前清理提示词。提示词注入可能导致文本编码器生成对抗性嵌入。
- **GPU 隔离**：在多租户环境中，使用 NVIDIA MIG（多实例 GPU）划分 A100/H100 GPU，防止一个用户的生成耗尽其他用户所需的显存。
- **网络隔离**：在内部 VPC 上运行 Gradio 容器。仅通过带有身份验证的 API 网关对外暴露。

## 与替代方案对比

| 特性 | HunyuanVideo | Wan 2.2 | CogVideoX-5B | Open-Sora |
|---|---|---|---|---|
| 参数量 | 13B (1.5版 8.3B) | 14B | 5B | 1.1B - 7B |
| 最大分辨率 | 1080p (超分) | 1080p | 720p | 720p |
| 最低显存 (720p) | 24GB (INT8) | 24GB | 12GB | 16GB |
| 文生视频 | 支持 | 支持 | 支持 | 支持 |
| 图生视频 | 支持 (1.5) | 支持 | 支持 | 支持 |
| 许可证 | Apache-2.0 | Apache-2.0 | Apache-2.0 | BSD-3-Clause |
| 电影级质量 | 8.8/10 | 8.5/10 | 6.8/10 | 7.0/10 |
| 生成时间 (5秒, 4090) | 5:50 (原版) | 4:20 | 8:10 | 6:00 |
| 运动真实度 | 优秀 | 优秀 | 中等 | 良好 |
| 双语提示词 | 支持 (中/英) | 支持 (中/英) | 支持 (中/英) | 主要英文 |
| 内置放大器 | 支持 (1.5) | 不支持 | 不支持 | 不支持 |
| ComfyUI 支持 | 支持 | 支持 | 支持 | 支持 |
| 多 GPU 并行 | 支持 (xDiT) | 支持 (USP) | 有限 | 不支持 |

HunyuanVideo 的主要差异化优势在于其电影级美学和运动真实度。其"家族风格"可产生丰富的色彩分级、自然的散景和电影般的运动效果。Wan 2.2 在照片级真实的人物面部和精细细节方面略有优势。CogVideoX-5B 仍然是 12GB 显存 GPU 的可及性冠军，尽管质量落后。Open-Sora 为希望从头训练的研究人员提供了最灵活的训练管线。

## 局限性 / 客观评估

HunyuanVideo 并非适合所有视频生成任务。以下是它的不足之处：

**速度**：即使使用 FP8 和 SSTA，HunyuanVideo 仍比 Wan 2.2 慢，比 LTX-Video 慢得多。如果您的工作流需要快速迭代（每小时数百个片段），LTX-Video 或商业 API 更合适。

**显存需求**：原版 13B 模型需要 60GB 显存进行 720p 生成。只有 1.5 版本的 INT8 量化将其降至 24GB。没有 A100、H100 或 RTX 4090 级别硬件的团队应考虑 CogVideoX 或云端推理。

**提示词依赖**：简短或模糊的提示词产生不一致的结果。模型需要详细的结构化描述（30-60 个词），将主体、动作和环境分开。内置提示词重写器有帮助但会增加延迟。

**分辨率上限**：原生生成最高 720p。1.5 中的 1080p 超分辨率网络增加了处理时间，可能在复杂纹理上引入伪影。对于原生 1080p 生成，Sora 或 Kling 等商业模型仍然领先。

**片段长度**：实际生成长度限制在 5-10 秒。更长的序列需要超出 H100 规格的计算资源，且 10 秒后时间一致性会下降。

**仅支持 Linux**：没有官方的 Windows 或 macOS 支持。WSL2 可能可用但未被维护者记录或测试。

## 常见问题解答

**Q: 运行 HunyuanVideo 实际需要多少显存？**

A: 原版 13B 模型需要 60GB GPU 显存进行 720p 生成，540p 需要 45GB。HunyuanVideo-1.5 通过 INT8 量化将此降至 24GB，如果启用 CPU 卸载则降至 14GB。FP8 权重相比 FP16 节省约 10GB。对于生产环境，建议使用 NVIDIA A100 80GB 或 H100；对于实验，单张 RTX 4090 (24GB) 可通过量化运行 1.5 模型。

**Q: 我可以在 Windows 上运行 HunyuanVideo 吗？**

A: 官方不支持——该项目仅支持 Linux。部分用户报告使用 WSL2（Windows Subsystem for Linux）和 CUDA 直通成功运行，但腾讯团队未对此进行记录或支持。对于基于 Windows 的团队，带有 WSL2 后端的 Docker Desktop 是最可行的路径，但预计需要排查 CUDA 兼容性问题。

**Q: HunyuanVideo 与 Sora 或 Kling 等商业 API 相比如何？**

A: 在人类评估中，HunyuanVideo 在运动质量和整体排名上超越了 Runway Gen-3 和 Luma 1.6。与领先商业模型（Sora 2、Kling 2.5）的差距已大幅缩小，但在照片级真实人物和复杂多物体场景方面仍存在可测量的差距。权衡在于成本：商业 API 每秒视频收费 $0.10-0.50，而自托管 HunyuanVideo 仅需 GPU 计算时间（H200 云实例约 $0.14-0.21/秒，自有硬件几乎为零成本）。

**Q: HunyuanVideo 的最佳提示词格式是什么？**

A: 使用将主体、动作和环境明确分开的结构化提示词。目标 30-60 个词。示例："A golden retriever runs along a sandy beach at sunset. Ocean waves break in the background. The dog's fur blows in the wind. Warm golden hour lighting. Wide angle shot, cinematic color grading." 启用提示词重写功能（Normal 模式追求准确性，Master 模式追求视觉美感）自动将短提示词扩展为模型偏好的描述。

**Q: 如何在生产环境中加速推理？**

A: 组合多种优化方式：(1) 使用 FP8 量化权重减少内存并提高批次吞吐量。(2) 启用 xDiT 多 GPU 并行推理——8x A100 可实现单 GPU 5.6 倍加速。(3) 使用 CFG 蒸馏模型变体以小幅质量代价获得约 2 倍加速。(4) 启用特征缓存（TeaCache）跳过步骤间的冗余计算。(5) 对于 1.5 版本，SSTA 注意力机制自动提供 1.87 倍加速且无损质量。

**Q: 在哪里可以获得帮助或与其他用户讨论 HunyuanVideo？**

A: 腾讯团队在 GitHub README 中链接了 Discord 服务器和微信群。对于英语开发者，Hugging Face 社区论坛和 ComfyUI Discord 有活跃的 HunyuanVideo 频道。对于错误报告和功能请求，请使用官方仓库的 GitHub Issues。

## 结论

HunyuanVideo 是一个生产级视频生成框架，架起了闭源商业 API 和开源可及性之间的桥梁。随着 1.5 版本带来 83 亿参数、SSTA 注意力和消费级 GPU 兼容性，它已成为工作室和独立创作者的实际选择。

今日开始行动：

1. 克隆仓库并在 GPU 实例上运行 Docker 镜像——官方 CUDA 12 镜像是最快的路径。
2. 下载 FP8 权重并使用 `sample_video.py` 运行首次 720p 生成。
3. 使用 Kijai 的封装版与 ComfyUI 集成，进行可视化工作流编辑。
4. 加入 [dibi8 Telegram 群组](https://t.me/dibi8Channel) 讨论部署策略并与社区分享您的生成视频。

*本文中的部分链接是联盟链接。如果您通过它们购买服务，我们可能会获得佣金——这有助于支持 dibi8 开源项目，且不会给您带来额外费用。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- 官方仓库: https://github.com/Tencent-Hunyuan/HunyuanVideo
- HunyuanVideo-1.5 仓库: https://github.com/Tencent-Hunyuan/HunyuanVideo-1.5
- 项目主页: https://aivideo.hunyuan.tencent.com
- Hugging Face 模型卡: https://huggingface.co/tencent/HunyuanVideo
- ComfyUI Wiki 教程: https://comfyui-wiki.com/en/tutorial/advanced/hunyuan-text-to-video-workflow-guide-and-example
- 技术报告 (arXiv): https://arxiv.org/abs/2412.03603
- HunyuanVideo 1.5 技术报告: https://arxiv.org/abs/2511.18870
- xDiT 并行推理: https://github.com/xdit-project/xDiT
- Kijai ComfyUI 封装版: https://github.com/kijai/ComfyUI-HunyuanVideoWrapper
- DigitalOcean GPU Droplets: https://www.digitalocean.com/products/gpu-droplets
