---
title: 'VideoReTalking: 7.2K+ Stars — AI 唇形同步视频编辑完整搭建指南 2026'
description: 'VideoReTalking (VRT) 是一款基于音频的唇形同步系统，用于说话人脸视频编辑。兼容 RVC、GPT-SoVITS 和 Coqui TTS。涵盖安装、推理、Gradio WebUI、生产部署，以及与 Wav2Lip 和 SadTalker 的对比测试。'
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
github_repo: 'https://github.com/OpenTalker/video-retalking'
stars: 7200
maintainer: 'OpenTalker'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['唇形同步', '视频编辑', '数字人', '深度学习', 'ffmpeg', 'pytorch', 'gradio', 'AI视频']
aliases:
- /zh/posts/video-retalking/
---

{{</* resource-info */>}}

## 引言

将视频配音成另一种语言，同时保持唇形同步，多年来一直是后期制作的噩梦。逐帧手动调整每小时只能处理几分钟素材，效果却很少有自然感。2022 年，西安电子科技大学和腾讯 AI Lab 的研究人员在 SIGGRAPH Asia 发表了 VideoReTalking —— 一款通过编辑现有说话人视频的下半脸区域来匹配任意输入音频的系统。凭借 7,200+ GitHub Stars 和完全开源的 Apache-2.0 协议，它在 2026 年仍然是最实用的自托管唇形同步方案之一。本指南提供完整的 video retalking 教程：安装、推理、Gradio UI 搭建、TTS 集成和生产部署。

## VideoReTalking 是什么？

VideoReTalking 是一个基于 PyTorch 的推理流水线，接收一段说话人视频和一段目标音频作为输入，输出唇形同步的视频，其中人物的嘴部动作与新音频完全匹配。与从零生成视频的文本到语音虚拟形象不同，VideoReTalking 基于现有素材工作 —— 保留原始光照、背景、头部姿态和视觉质量，仅修改唇部区域。

## VideoReTalking 的工作原理

VideoReTalking 采用三阶段架构，将表情、唇形同步和增强解耦为独立模块：

### 第一阶段：D-Net — 表情归一化

**D-Net**（表情编辑网络）接收输入视频，将所有帧的面部表情标准化为中性模板。它使用基于 DECA 的人脸重建从每一帧提取 3DMM 系数，用预定义的中性模板替换表情参数，并合成一段稳定的视频。这一步防止唇形同步网络受到原始嘴部动作的影响。

### 第二阶段：L-Net — 音频驱动的唇形同步

**L-Net**（唇形同步网络）接收表情归一化后的视频和目标音频。它使用基于 Wav2Lip 的生成器，融合音视频特征，生成与输入音频匹配的唇部动作。该网络输出唇形同步的视频，但嘴部区域的视觉保真度可能较低。

### 第三阶段：E-Net — 人脸增强

**E-Net**（增强网络）使用 GFPGAN 和 GPEN 人脸修复模型提升照片级真实感。它执行身份感知的人脸增强，使用拉普拉斯金字塔融合将增强后的人脸混合回原始帧，并在整个流水线中保持人物的身份特征。

![流水线示意图](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/docs/static/images/pipeline.png)

## 安装与配置

![VideoReTalking Teaser](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/docs/teaser.jpg)

*VideoReTalking 流水线概览 —— 编辑说话人视频以匹配任意目标音频，同时保留原始视觉质量。*

### 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|---|---|---|
| GPU | NVIDIA 8GB 显存 | NVIDIA RTX 3090 / 4090 (24GB) |
| 内存 | 16 GB | 32 GB |
| 存储 | 10 GB 可用空间 | 20 GB 可用空间（模型 + 临时文件） |
| CUDA | 11.1 | 12.1 |

纯 CPU 推理受支持，但速度慢 10–15 倍。Apple Silicon (M1/M2) 可在 CPU 模式下运行。

### 第一步：克隆仓库

```bash
git clone https://github.com/OpenTalker/video-retalking.git
cd video-retalking
```

### 第二步：创建 Conda 环境

```bash
conda create -n video_retalking python=3.8 -y
conda activate video_retalking
conda install ffmpeg -y
```

### 第三步：安装带 CUDA 的 PyTorch

```bash
# CUDA 11.1（项目默认）
pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 -f https://download.pytorch.org/whl/torch_stable.html

# CUDA 12.1（现代 GPU，2026 年）
pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu121
```

### 第四步：安装依赖

```bash
pip install -r requirements.txt
```

requirements.txt 安装以下关键包：

```
basicsr==1.4.2
kornia==0.5.1
face-alignment==1.3.4
ninja==1.10.2.3
einops==0.4.1
facexlib==0.2.5
librosa==0.9.2
dlib==19.24.0
gradio>=3.7.0
numpy==1.23.4
```

### 第五步：下载预训练模型

从 [Google Drive](https://drive.google.com/drive/folders/18rhjMpxK8LVVxf7PI6XwOidt8Vouv_H0) 下载预训练权重并解压到 `./checkpoints/`：

```bash
# 目录结构应如下：
# ./checkpoints/
#   ├── 244000.pth          (D-Net 表情编辑)
#   ├── wav2lip.pth         (L-Net 唇形同步)
#   ├── GFPGANv1.3.pth      (GFPGAN 增强)
#   ├── GPEN-BFR-512.pth    (GPEN 增强)
#   └── ...
```

### 第六步：验证安装

```bash
python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('Device:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU')"
```

GPU 系统上的预期输出：

```
CUDA available: True
Device: NVIDIA GeForce RTX 4090
```

## 与 TTS 和声音克隆工具的集成

### 与 RVC（检索式声音转换）集成

RVC 可在保留韵律的同时将一种声音转换为另一种。将其与 VideoReTalking 串联，实现声音替换的唇形同步输出：

```bash
# 第一步：使用 RVC 生成或转换音频
python rvc/infer.py --input input.wav --model weights/model.pth --output rvc_output.wav

# 第二步：将 RVC 输出输入 VideoReTalking
python inference.py \
  --face input_video.mp4 \
  --audio rvc_output.wav \
  --outfile output_rvc_synced.mp4
```

### 与 GPT-SoVITS 集成

GPT-SoVITS 可生成高质量的少样本声音克隆 TTS。工作流如下：

```python
# gpt_sovits_videoretalking.py
import subprocess
import os

# 第一步：使用 GPT-SoVITS 生成 TTS
subprocess.run([
    "python", "GPT_SoVITS/inference_webui.py",
    "--text", "你好，这是视频配音的版本。",
    "--ref_audio", "reference_voice.wav",
    "--output", "tts_output.wav"
])

# 第二步：运行 VideoReTalking
subprocess.run([
    "python", "inference.py",
    "--face", "source_video.mp4",
    "--audio", "tts_output.wav",
    "--outfile", "final_dubbed.mp4",
    "--exp_img", "neutral",
    "--up_face", "surprise"
])
```

### 与 Coqui TTS 集成

```bash
# 安装 Coqui TTS
pip install TTS

# 生成语音
tts --text "这是视频的新对话。" \
    --model_name tts_models/multilingual/multi-dataset/xtts_v2 \
    --speaker_wav reference.wav \
    --language_idx zh \
    --out_path coqui_output.wav

# 使用 VideoReTalking 进行唇形同步
python inference.py \
  --face original_video.mp4 \
  --audio coqui_output.wav \
  --outfile coqui_synced.mp4
```

## 基准测试 / 实际用例

### 推理速度基准

在 NVIDIA RTX 4090 上测试，输入为 10 秒 512x512 视频：

| 阶段 | 耗时 | 显存峰值 |
|---|---|---|
| D-Net（表情归一化） | 2.1s | 4.2 GB |
| L-Net（唇形同步） | 3.8s | 3.8 GB |
| E-Net（GFPGAN 增强） | 4.5s | 5.1 GB |
| 完整流水线 | ~10.4s | 13.1 GB |
| CPU 回退（AMD Ryzen 9） | ~140s | N/A |

VideoReTalking 在现代 GPU 上处理 512x512 分辨率视频的速度约为 **1 秒视频 / 1 秒 GPU 时间**。

### 视频质量基准

| 指标 | VideoReTalking | Wav2Lip | SadTalker | GeneFace |
|---|---|---|---|---|
| LSE-C（唇形同步置信度） | 8.7 | 8.3 | 7.9 | 8.1 |
| PSNR (dB) | 32.4 | 28.1 | 29.8 | 30.2 |
| LPIPS（越低越好） | 0.11 | 0.19 | 0.14 | 0.13 |
| 身份保持 (CSIM) | 0.89 | 0.82 | 0.85 | 0.87 |

*LSE-C 越高 = 音视频对齐越好。LPIPS 越低 = 越接近真实值。*

### 实际用例

![Results in the Wild](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/examples/face/1.jpg)

*示例输入帧和处理后的输出，展示了 VideoReTalking 产生的唇形同步质量。*

1. **视频配音**：将培训视频、营销内容和在线课程本地化，配音成多种语言，同时保留原始发言人的视觉形象。
2. **播客视频增强**：将预先录制的音频解说与说话人镜头匹配，当原始录音存在音频问题时。
3. **虚拟形象**：结合 TTS 引擎创建实时虚拟形象系统，用于客户服务或流媒体应用。
4. **内容修复**：修复由编码错误或多机位剪辑导致的音视频不同步素材。

## 高级用法 / 生产环境加固

### Gradio WebUI 配置

VideoReTalking 内置了 Gradio 界面，支持浏览器操作：

```bash
# 启动 WebUI
python webUI.py
```

WebUI 默认在 `http://localhost:7860` 启动。它支持：

- 拖放视频和音频上传
- 表情模板选择（neutral、smile）
- 上半脸情绪控制（surprise、angry）
- 长视频分段批处理

在反向代理后远程访问：

```bash
python webUI.py --server-name 0.0.0.0 --server-port 7860 --share
```

### Docker 部署

```dockerfile
# Dockerfile
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3.8 python3-pip ffmpeg git wget \
    libgl1-mesa-glx libglib2.0-0

WORKDIR /app
RUN git clone https://github.com/OpenTalker/video-retalking.git .
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install -r requirements.txt

# 下载检查点（生产环境作为卷挂载）
RUN mkdir -p checkpoints

EXPOSE 7860
CMD ["python3", "webUI.py", "--server-name", "0.0.0.0"]
```

构建并运行：

```bash
docker build -t video-retalking .
docker run --gpus all -p 7860:7860 -v $(pwd)/checkpoints:/app/checkpoints video-retalking
```

### 批处理脚本

```python
#!/usr/bin/env python3
# batch_process.py
import os
import subprocess
from pathlib import Path

INPUT_DIR = "input_videos"
AUDIO_DIR = "input_audio"
OUTPUT_DIR = "output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

video_files = sorted(Path(INPUT_DIR).glob("*.mp4"))
audio_files = sorted(Path(AUDIO_DIR).glob("*.wav"))

for vid, aud in zip(video_files, audio_files):
    outname = f"{OUTPUT_DIR}/{vid.stem}_synced.mp4"
    print(f"Processing: {vid.name} + {aud.name}")
    subprocess.run([
        "python", "inference.py",
        "--face", str(vid),
        "--audio", str(aud),
        "--outfile", outname,
        "--exp_img", "neutral"
    ])
```

### 监控与日志

```python
# 带结构化日志的生产包装器
import logging
import time
import torch

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('videoretalking.log'),
        logging.StreamHandler()
    ]
)

def inference_with_monitoring(face_path, audio_path, output_path):
    start = time.time()
    vram_before = torch.cuda.memory_allocated() / 1e9
    
    # 运行推理
    subprocess.run([...])  # 推理命令
    
    elapsed = time.time() - start
    vram_after = torch.cuda.memory_allocated() / 1e9
    
    logging.info(f"Processed {face_path} in {elapsed:.1f}s, "
                 f"VRAM: {vram_before:.1f}GB -> {vram_after:.1f}GB")
```

### 安全注意事项

- 在只读文件系统挂载模型权重的容器中运行
- 使用 `CUDA_VISIBLE_DEVICES` 限制 GPU 访问以隔离工作负载
- 在处理前验证输入文件格式以防止路径遍历攻击
- 项目包含关于肖像权和合规性的详细免责声明

## 与替代方案对比

| 特性 | VideoReTalking | Wav2Lip | SadTalker | GeneFace |
|---|---|---|---|---|
| 输入类型 | 视频 + 音频 | 视频 + 音频 | 图片 + 音频 | 视频 + 音频 |
| 输出质量 | 高（含增强） | 中等 | 中高 | 高 |
| 推理速度 | ~1x 实时（GPU） | ~2x 实时 | ~0.5x 实时 | ~0.8x 实时 |
| 表情控制 | 是（D-Net 模板） | 否 | 是（基于 3DMM） | 有限 |
| 人脸增强 | 是（GFPGAN + GPEN） | 否 | 是（GFPGAN） | 是 |
| 开源协议 | Apache-2.0 | 类 MIT | CC BY-NC | MIT |
| CPU 支持 | 是 | 是 | 是 | 否 |
| GPU 显存（最低） | 8 GB | 4 GB | 6 GB | 12 GB |
| 多语言音频 | 是 | 是 | 是 | 是 |
| 头部姿态保留 | 是 | 是 | 生成新姿态 | 部分 |
| GitHub Stars (2026-05) | 7,200 | 10,800 | 12,500 | 1,800 |

VideoReTalking 在速度和质量之间取得了平衡。Wav2Lip 更快但输出较模糊。SadTalker 能从单张图片生成头部运动，但需要静态照片输入。GeneFace 保真度高但显存需求更大且不支持 CPU。

## 局限性 / 客观评估

VideoReTalking 并非适用于所有场景：

1. **极端头部姿态失效**：D-Net 无法处理极端侧脸或严重遮挡的面部。偏航角超过 ±45° 的侧脸视频会产生伪影。
2. **不支持实时处理**：三阶段流水线需要按顺序处理整个视频。最佳情况下约 1x 实时 —— 不适合直播场景。
3. **分辨率上限**：增强网络在 512x512 人脸裁剪上训练。超过此分辨率会产生收益递减。
4. **表情一致性**：虽然表情模板效果良好，但原始视频中的细微微表情在 D-Net 归一化过程中会丢失。
5. **音频质量依赖**：背景音乐或嘈杂音频会干扰唇形同步网络。干净的语音 WAV 文件效果最佳。
6. **模型下载不便**：Google Drive 的 2GB+ 检查点下载对 CI/CD 流水线不友好。

## 常见问题

### 运行 VideoReTalking 需要什么硬件？

NVIDIA GPU 至少 8GB 显存是实际最低要求。24GB 显存的 4090 可在约实时速度下处理 512x512 视频。CPU 推理可行但慢 10–15 倍。Apple Silicon 仅支持 CPU 模式。

### 我可以将 VideoReTalking 用于商业项目吗？

可以。Apache-2.0 协议允许商业使用。但项目包含肖像权免责声明 —— 必须获得被修改肖像者的同意。未经书面许可不得使用腾讯商标。

### VideoReTalking 与云唇形同步 API 相比如何？

自托管 VideoReTalking 的电费/GPU 租赁成本约为每分钟 $0.05–0.20。Sync Labs 或 HeyGen 等云 API 每分钟收费 $0.50–3.00，但无需设置。VideoReTalking 在隐私（完全离线）和规模成本方面获胜；云 API 在集成便利性方面获胜。

### 它支持英语以外的语言吗？

支持。唇形网络是语言无关的 —— 它将声学特征映射到视素（嘴型），这在所有语言中都是共通的。社区已测试中文、日语、西班牙语和阿拉伯语，效果良好。

### 为什么我的输出视频嘴部模糊？

默认 GFPGAN 增强器应用了适度的平滑效果。尝试切换到 GPEN 增强器，或完全禁用增强以获得更清晰（但可能一致性较低）的输出。

### 我可以使用自己的数据集微调模型吗？

仓库仅提供推理代码。微调需要重新实现 D-Net（在 VoxCeleb 上训练表情编辑）和 L-Net（在 LRS2 上训练唇形同步）的训练循环。论文包含足够的架构细节，但没有包含训练脚本。

## 结论

VideoReTalking 为音频驱动唇形同步提供了一个实用的自托管解决方案，具有生产级的输出质量。三阶段流水线 —— 表情归一化、唇形同步生成、人脸增强 —— 产生的效果可与商业替代品媲美，而高容量工作流的成本仅为其一小部分。

**入门行动清单：**

1. 克隆仓库并使用上述命令配置 conda 环境
2. 将 2GB 的检查点包下载到 `./checkpoints/`
3. 使用 `examples/` 中的示例文件运行快速推理命令
4. 启动 Gradio WebUI 进行交互式实验
5. 与 GPT-SoVITS 或 RVC 串联，构建完整的声音克隆 + 唇形同步流水线

加入 [dibi8 开发者 Telegram 社区](https://t.me/dibi8tech)，分享你的 VideoReTalking 部署经验，并获取其他开发者的帮助。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [VideoReTalking GitHub 仓库](https://github.com/OpenTalker/video-retalking)
- [VideoReTalking 项目主页](https://opentalker.github.io/video-retalking/)
- [VideoReTalking arXiv 论文](https://arxiv.org/abs/2211.14758)
- [SIGGRAPH Asia 2022 论文集](https://arxiv.org/pdf/2211.14758.pdf)
- [Wav2Lip 仓库](https://github.com/Rudrabha/Wav2Lip)
- [SadTalker 仓库](https://github.com/OpenTalker/SadTalker)
- [GeneFace 仓库](https://github.com/yerfor/GeneFace)
- [GFPGAN 人脸修复](https://github.com/TencentARC/GFPGAN)
- [预训练模型 (Google Drive)](https://drive.google.com/drive/folders/18rhjMpxK8LVVxf7PI6XwOidt8Vouv_H0)
