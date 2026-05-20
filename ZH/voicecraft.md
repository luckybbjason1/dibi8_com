---
title: 'VoiceCraft: 8.5K+ Stars — 零样本语音编辑对比 GPT-SoVITS、XTTS 2026'
description: 'VoiceCraft 是基于神经编解码器的零样本语音编辑和 TTS 模型，可与 GPT-SoVITS、Coqui TTS 和 RVC 配合使用。涵盖安装教程、基准测试、Docker 部署和对比表。'
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
github_repo: 'https://github.com/jasonppy/VoiceCraft'
stars: 8500
maintainer: 'jasonppy'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['voicecraft', '零样本语音合成', '语音编辑', '神经编解码器', '语音克隆', 'ai音频', 'docker', 'python']
aliases:
- /zh/posts/voicecraft/
---

{{</* resource-info */>}}

## 引言

编辑语音音频曾经意味着要在录音棚里重新录制整段内容。如果播客主播说错了一个词，或者有声书朗读者念错了名字，修复流程需要再预约一次录音、架设麦克风，还要匹配原始语调。这种工作流既昂贵又缓慢。2024年，来自德州大学奥斯汀分校和 Meta FAIR 的研究团队发布了 **VoiceCraft**，一种神经编解码语言模型，仅凭几秒参考音频即可编辑语音和克隆声线。该仓库目前在 GitHub 上拥有 **8,500+ stars** 和 796 个 fork，论文被 ACL 2024 接收。本指南将带你完成 VoiceCraft 的安装配置，与 GPT-SoVITS、XTTS v2 和 Coqui TTS 进行对比，并展示使用 Docker 的生产级部署方案。

## VoiceCraft 是什么？

**VoiceCraft** 是一种基于令牌填充的神经编解码语言模型，执行两项核心任务：(1) 零样本文本转语音（TTS）语音克隆，(2) 在现有录音中进行语音编辑。与传统的 TTS 流程（需要每位说话人提供数小时训练数据）不同，VoiceCraft 只需 3-5 秒的参考音频即可高保真地重现声音。它基于 Transformer 解码器架构，并引入了令牌重排流程，结合因果掩码与延迟堆叠技术，使自回归生成能够以双向上下文为条件。

![VoiceCraft 架构概览](https://raw.githubusercontent.com/jasonppy/VoiceCraft/main/assets/overview.png)
*图 1：VoiceCraft 架构概览 — 用于语音编辑和 TTS 的因果掩码与延迟堆叠令牌填充。*

## VoiceCraft 的工作原理

### 架构概述

模型流水线分为三个阶段：

1. **EnCodec 量化**：原始音频波形通过 Meta 的 EnCodec 神经编解码器量化为离散令牌。每个音频帧表示为 K 个码本索引的向量（残差矢量量化，RVQ）。

2. **令牌重排**：这是 VoiceCraft 的核心创新。两步流程将编辑/填充问题转化为标准的从左到右语言建模任务：
   - **因果掩码**：令牌的随机跨度被掩码并移动到序列末尾，使模型在自回归生成期间能够关注双向上下文。
   - **延迟堆叠**：向量沿对角线移位，使得在预测时间 t 的码本 k 时以码本 k-1 为条件，实现高效的多码本建模。

3. **Transformer 解码器**：重排后的令牌序列由 Transformer 解码器自回归建模。文本音素和语音令牌作为条件输入进行拼接。

### 模型版本

| 模型 | 参数量 | 适用场景 | 最大时长 |
|------|--------|---------|---------|
| giga330M | 3.3亿 | 质量与速度平衡 | 16 秒 |
| giga830M | 8.3亿 | 最高质量 | 30+ 秒 |
| giga330M-TTS增强版 | 3.3亿 | TTS专项微调 | 16 秒 |

### RealEdit 数据集

VoiceCraft 引入了 **RealEdit**，一个包含 310 个真实世界语音编辑示例的基准数据集，来源包括有声书、YouTube 视频和 Spotify 播客。与干净的实验室数据集（LibriTTS、VCTK）不同，RealEdit 包含各种口音、背景噪音、音乐和说话风格 —— 使其成为衡量语音编辑实用性的可靠标准。

![VoiceCraft 语音编辑流程](https://jasonppy.github.io/VoiceCraft_web/static/editing_figure.png)
*图 2：VoiceCraft 语音编辑工作流 — 原始音频、目标转录和合成编辑输出。*

## 安装与配置

### 方案一：Docker（推荐）

Docker 是搭建 VoiceCraft 环境最快的途径。官方 Dockerfile 处理了所有依赖，包括 EnCodec、Montreal Forced Aligner (MFA) 和 CUDA 绑定。

```bash
# 1. 克隆仓库
git clone https://github.com/jasonppy/VoiceCraft.git
cd VoiceCraft

# 2. 构建 Docker 镜像
docker build --tag "voicecraft" .

# 3. 启动容器（Linux）
./start-jupyter.sh
# Windows 用户：
# start-jupyter.bat

# 4. 从日志中获取 Jupyter 访问链接
docker logs jupyter | grep "127.0.0.1:8888"

# 5. 在容器内验证 GPU
docker exec -it jupyter nvidia-smi
```

容器在 8888 端口暴露 Jupyter Lab，在 7860 端口暴露 Gradio UI。打开 `inference_tts.ipynb` 或 `inference_speech_editing.ipynb` 即可运行推理。

### 方案二：Conda 环境（本地开发）

对于模型开发和微调，本地 Conda 环境提供更大的灵活性。

```bash
# 创建并激活环境
conda create -n voicecraft python=3.9.16
conda activate voicecraft

# 安装带 CUDA 11.7 的 PyTorch
pip install torch==2.0.1 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu117

# 安装 audiocraft（EnCodec 依赖）
pip install -e git+https://github.com/facebookresearch/audiocraft.git@c5157b5bf14bf83449c17ea1eeb66c19fb4bc7f0#egg=audiocraft

# 安装 xformers 内存高效注意力
pip install xformers==0.0.22

# 核心依赖
pip install tensorboard==2.16.2
pip install phonemizer==3.2.1
pip install datasets==2.16.0
pip install torchmetrics==0.11.1
pip install huggingface_hub==0.22.2

# 系统依赖
apt-get install -y ffmpeg espeak-ng

# 安装 Montreal Forced Aligner (MFA) 用于文本-音频对齐
conda install -c conda-forge montreal-forced-aligner=2.2.17 openfst=1.8.2 kaldi=5.5.1068

# 下载 MFA 英文模型
mfa model download dictionary english_us_arpa
mfa model download acoustic english_us_arpa

# Jupyter 内核（可选）
conda install -n voicecraft ipykernel --no-deps --force-reinstall
```

### 方案三：Gradio 本地界面

无需 Notebook 的浏览器界面：

```bash
# Gradio 额外系统依赖
apt-get install -y espeak espeak-data libespeak1 libespeak-dev
apt-get install -y festival build-essential flac libasound2-dev libsndfile1-dev

# 安装 Gradio 依赖
pip install -r gradio_requirements.txt

# 启动 Gradio 服务
python gradio_app.py
```

在浏览器中访问 `http://127.0.0.1:7860`。

### 硬件需求

| 配置 | 最低 GPU | 推荐 GPU | 内存 |
|------|---------|---------|------|
| 完整推理 (830M) | 8 GB (kvcache) | 32 GB VRAM | 32 GB |
| 快速推理 (330M) | 8 GB | 16 GB VRAM | 16 GB |
| Gradio 界面 | 8 GB | 16 GB VRAM | 16 GB |

`kvcache` 优化以轻微质量损失换取显著内存降低，使 8 GB GPU 也能运行推理。

## 与流行工具集成

### VoiceCraft + Gradio Web UI

内置的 Gradio 界面是最简单的实验方式：

```bash
# 使用默认设置启动 Gradio
python gradio_app.py --model-name "giga330M" --device "cuda"

# 使用自定义模型路径
python gradio_app.py \
  --model-path "./pretrained_models/giga330M.pth" \
  --codec-model "encodec_16khz" \
  --share  # 创建公网 URL
```

Gradio UI 支持三种模式：**TTS 模式**（零样本语音克隆）、**编辑模式**（语音编辑）和 **长文本 TTS 模式**（长文本分块生成）。

### VoiceCraft + Jupyter Notebook

程序化访问可使用 Jupyter notebook：

```python
# inference_tts.ipynb — 零样本 TTS 示例
from voicecraft import VoiceCraft

# 加载 330M 模型（更快，质量良好）
model = VoiceCraft.from_pretrained("pyp1/VoiceCraft", subfolder="giga330M")

# 提供 3-5 秒参考音频
reference_audio = "demo/pam.wav"  # 你的参考片段
reference_text = "I found the amazing VoiceCraft model"

# 要合成的文本
target_text = "This is a test of zero shot voice cloning with VoiceCraft"

# 生成
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,  # 2025年3月更新：top-k=40 提升质量
    temperature=1.0
)
output.save("output_tts.wav")
```

### VoiceCraft + 命令行

批量处理和脚本化：

```bash
# 通过 CLI 进行 TTS 推理
python tts_demo.py \
  --audio_path "demo/pam.wav" \
  --target_transcript "This is the text to speak" \
  --model_name "giga330M" \
  --top_k 40 \
  --temperature 1.0 \
  --output_path "output.wav"

# 通过 CLI 进行语音编辑
python speech_editing_demo.py \
  --audio_path "demo/pam.wav" \
  --original_transcript "original text here" \
  --edited_transcript "edited text here" \
  --model_name "giga830M" \
  --output_path "edited_output.wav"
```

### VoiceCraft + Docker API

生产部署方案，将 VoiceCraft 包装为 REST API：

```dockerfile
# Dockerfile.api — 生产级 API 封装
FROM voicecraft:latest

WORKDIR /app
COPY api.py ./
COPY requirements-api.txt ./

RUN pip install -r requirements-api.txt

EXPOSE 8000

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
```

```python
# api.py — VoiceCraft 的 FastAPI 封装
from fastapi import FastAPI, UploadFile, File
from voicecraft import VoiceCraft
import torchaudio

app = FastAPI()
model = VoiceCraft.from_pretrained("pyp1/VoiceCraft", subfolder="giga330M")

@app.post("/tts")
async def tts(
    audio: UploadFile = File(...),
    reference_text: str = "",
    target_text: str = ""
):
    """零样本 TTS 端点。"""
    ref_audio, sr = torchaudio.load(audio.file)
    output = model.tts(
        target_text=target_text,
        reference_audio=ref_audio,
        reference_text=reference_text,
        top_k=40
    )
    return {"output": output.serialize()}
```

### VoiceCraft + HuggingFace Hub

直接从 HuggingFace 下载预训练模型：

```python
from huggingface_hub import hf_hub_download

# 下载模型权重
model_path = hf_hub_download(
    repo_id="pyp1/VoiceCraft",
    filename="giga330M.pth",
    subfolder="",
    local_dir="./pretrained_models"
)

# 中国大陆用户也可通过 ModelScope 下载
from modelscope import snapshot_download
model_dir = snapshot_download('AI-ModelScope/VoiceCraft')
```

## 基准测试 / 实际用例

### 零样本 TTS 基准测试

ACL 2024 论文中的人工评估结果，对比了 VoiceCraft 与 VALL-E、XTTS v2、FluentSpeech 和 YourTTS 在 250 条测试语音（LibriTTS + YouTube）上的表现：

| 模型 | WER | SIM | 可懂度 MOS | 自然度 MOS | 说话人相似度 MOS |
|------|-----|-----|-----------|-----------|----------------|
| **VoiceCraft** | **4.5** | **0.55** | **4.23** | **4.17** | **4.34** |
| XTTS v2 | 3.6 | 0.47 | 4.13 | 3.96 | 3.44 |
| VALL-E | 7.1 | 0.50 | 4.00 | 3.86 | 4.07 |
| FluentSpeech | 3.5 | 0.47 | 3.67 | 3.38 | 4.01 |
| YourTTS | 6.6 | 0.41 | 3.14 | 2.79 | 2.79 |
| 真实录音 | 3.8 | 0.76 | 4.39 | 4.48 | 4.44 |

VoiceCraft 在说话人相似度（SIM 0.55）和所有人评 MOS 指标上均取得最高分。在可懂度上仅落后真实录音 0.16，在说话人相似度上仅落后 0.10。

### 语音编辑基准测试

在 RealEdit 数据集（310 个真实世界编辑示例）上，VoiceCraft 超越了 FluentSpeech：

| 模型 | WER | 可懂度 MOS | 自然度 MOS |
|------|-----|-----------|-----------|
| **VoiceCraft** | 6.1 | **4.11** | **4.03** |
| FluentSpeech | 4.5 | 3.97 | 3.81 |
| 原始录音（未编辑） | 5.4 | 4.22 | 4.17 |

值得注意的是，在并排听力测试中，人类听者在 **48% 的情况下** 更偏好 VoiceCraft 编辑后的语音，而非**原始未编辑录音** —— 这意味着模型输出与真实音频几乎无法区分。

### 实际应用场景

| 应用场景 | 参考音频 | 输出质量 | 设置时间 |
|----------|---------|---------|---------|
| 播客编辑 | 5 秒主持人声音 | 自然度 MOS 4.03 | < 2 分钟 |
| 有声书克隆 | 5 秒朗读者声音 | 相似度 SIM 0.55 | < 2 分钟 |
| YouTube 配音 | 5 秒说话者声音 | 自然度 MOS 4.17 | < 2 分钟 |
| 客服语音合成 | 3 秒客服声音 | 相似度 SIM 0.55 | < 1 分钟 |

![VoiceCraft 演示页面](https://jasonppy.github.io/VoiceCraft_web/static/teaser_figure.png)
*图 3：VoiceCraft 演示页面展示语音编辑示例 — 听者在 48% 的情况下无法区分编辑版与原版。*

## 高级用法 / 生产级加固

### 使用 KV Cache 进行内存优化

对于显存有限的 GPU，启用键值缓存：

```python
# 为 8GB GPU 启用 kvcache
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,
    kvcache=True,  # 减少约 60% 显存占用
    batch_size=1
)
```

### Top-k 采样（2025年3月更新）

默认采样策略从 top-p=1.0 更新为 top-k=40，显著提升了输出质量：

```python
# 推荐：top-k=40 获得最佳质量
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,
    temperature=1.0
)
```

### 自定义数据微调

针对特定领域的声线，对预训练模型进行微调：

```bash
# 准备数据集
conda activate voicecraft
cd ./data
python phonemize_encodec_encode_hf.py \
  --dataset_size xs \
  --download_to /path/to/downloads \
  --save_dir /path/to/processed \
  --encodec_model_path /path/to/encodec \
  --mega_batch_size 120 \
  --batch_size 32 \
  --max_len 30000

# 开始微调
cd ../z_scripts
bash e830M_ft.sh  # 微调 830M 模型
```

### 监控与日志

```python
import logging
from torch.utils.tensorboard import SummaryWriter

# 设置日志
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("voicecraft")

# TensorBoard 训练监控
writer = SummaryWriter(log_dir="./runs/voicecraft-ft")
writer.add_scalar("loss/train", loss.item(), global_step)
writer.add_scalar("mos/validation", val_mos, global_step)
```

### 安全与伦理考量

VoiceCraft 的许可证（代码 CC BY-NC-SA 4.0，权重 Coqui Public Model License）包含道德声明，禁止在未经同意的情况下生成或编辑他人语音。对于生产部署：

- 克隆前实施说话人验证
- 记录所有合成请求用于审计追踪
- 添加合成语音水印
- 对 API 端点进行速率限制以防止滥用

## 与替代方案对比

| 特性 | VoiceCraft | GPT-SoVITS | Coqui TTS (XTTS v2) | VALL-E |
|------|-----------|------------|-------------------|--------|
| **GitHub Stars** | 8,500 | 57,000 | 35,000* | N/A（仅论文） |
| **参数量** | 3.3亿 / 8.3亿 | 约 10 亿 | 4.67 亿 | 10 亿 |
| **语音编辑** | 原生支持，SotA | 不支持 | 不支持 | 有限支持 |
| **零样本 TTS** | 3-5 秒参考 | 5 秒参考 | 6 秒参考 | 3 秒参考 |
| **说话人相似度 MOS** | 4.34 | ~4.0 | 3.44 | 4.07 |
| **自然度 MOS** | 4.17 | ~3.8 | 3.96 | 3.86 |
| **语言支持** | 英语 | 英/日/韩/中/粤 | 17 种语言 | 英语 |
| **推理 RTF** | ~0.3x (GPU) | 0.028x (4060Ti) | 0.18x (A100) | ~0.5x |
| **许可证** | CC BY-NC-SA 4.0 | MIT | CPML（非商业） | N/A |
| **Docker 支持** | 官方 | 社区 | 社区 | N/A |
| **Gradio UI** | 内置 | 内置 | CLI/API  only | N/A |
| **微调支持** | 支持 | 支持 | 支持 | N/A |

*Coqui TTS 仓库 stars 包含所有 TTS 模型，不仅限于 XTTS。

**何时选择 VoiceCraft：**
- **语音编辑**是主要需求 —— 开源竞品无法匹敌
- 需要**最高说话人相似度**（MOS 4.34 vs XTTS 3.44）
- 处理**嘈杂的真实环境音频**（播客、YouTube 视频）
- 学术或非商业研究（CC BY-NC-SA 许可证）

**何时选择 GPT-SoVITS：**
- 需要**中文或日语**语音克隆
- 需要商业用途（MIT 许可证）
- 推理速度最重要（RTF 0.028）
- 用 1 分钟数据进行少样本微调

**何时选择 XTTS v2：**
- 需要**多语言**支持（17 种语言）
- 已使用 Coqui TTS 生态系统
- 可接受 Coqui 的商业许可

## 局限性 / 客观评估

VoiceCraft 并非适用于所有音频任务。以下是维护者和论文承认的限制：

1. **仅支持英语**：发布的模型仅支持英语音素。后续 VoiceCraft-X（2024年11月）扩展到 11 种语言，但属于独立模型。

2. **非商业许可证**：代码（CC BY-NC-SA 4.0）和模型权重（Coqui Public Model License）均限制商业用途，需另行签署协议。

3. **硬件需求**：830M 模型完整推理需要 32 GB GPU 显存。即便是 330M 模型，在消费级 GPU 上也需要谨慎管理内存。

4. **生成伪影**：生成的音频偶尔会出现长停顿和刮擦声。变通方法（采样多个输出并选择最短的）增加了计算开销。

5. **不支持流式推理**：VoiceCraft 完整自回归生成序列，实时流式 TTS 不现实，相比 Kokoro 或 MeloTTS 等模型。

6. **配置复杂**：与 pip 直接安装的 TTS 工具相比，VoiceCraft 需要 Docker 或 Conca 配合 MFA、EnCodec 和特定 CUDA 版本 —— 不是 30 秒就能装好的。

## 常见问题

**Q1：VoiceCraft 语音克隆需要多少参考音频？**

VoiceCraft 零样本 TTS 仅需 3-5 秒参考音频。为获得最佳效果，请使用无背景噪音或音乐的干净录音。模型通过 EnCodec RVQ 令牌将参考编码为说话人嵌入，因此更长的参考不一定会提升质量。

**Q2：我可以将 VoiceCraft 用于商业项目吗？**

VoiceCraft 代码使用 CC BY-NC-SA 4.0，模型权重使用 Coqui Public Model License 1.0.0 —— 两者均限制商业用途。如需商业许可的替代方案，请考虑 GPT-SoVITS（MIT 许可证）或从 Coqui 购买 XTTS v2 商业许可。

**Q3：运行 VoiceCraft 需要什么 GPU？**

830M 模型需要 32 GB 显存（A100、V100 或 RTX 4090 + 系统内存共享）。330M 模型可在 16 GB GPU 上运行，开启 `kvcache=True` 后 8 GB 显卡也能推理。纯 CPU 推理在 8 核 Ryzen 上需 7 分钟以上，而 GPU 仅需 35 秒。

**Q4：VoiceCraft 与 GPT-SoVITS 在语音克隆方面如何比较？**

VoiceCraft 在英语音频上实现了更高的说话人相似度（SIM 0.55 vs ~0.50）和自然度（MOS 4.17 vs ~3.8）。然而，GPT-SoVITS 原生支持中文和日语，推理更快（RTF 0.028 vs ~0.3），且使用更宽松的 MIT 许可证。在语音编辑方面，VoiceCraft 没有开源竞品。

**Q5：VoiceCraft 能否在不重新合成整个文件的情况下编辑现有录音？**

是的 —— 语音编辑是 VoiceCraft 的核心差异化能力。你在转录中指定编辑跨度（插入、删除或替换），模型仅填充受影响的音频段，同时保留周围上下文。这比完全重新合成更高效，并保持声学连续性。

**Q6：如何修复生成音频中的"刮擦声"？**

这是自回归编解码模型的已知问题。2025年3月更新（top-k=40 代替 top-p=1.0）显著减少了伪影。其他解决方案：(1) 采样多个输出并选择最短/最干净的，(2) 将温度降至 0.9，(3) 使用专为 TTS 质量微调的 330M-TTS-Enhanced 模型。

**Q7：VoiceCraft 有 REST API 或 Web 服务吗？**

官方仓库提供 Gradio UI 和 Jupyter notebook。社区项目如 VoiceCraft_API 将其包装为 FastAPI 服务。对于生产环境，在 API 网关后面部署 Docker 容器，并配置速率限制和说话人验证。

## 结论

VoiceCraft 填补了大多数 TTS 工具忽视的空白：编辑现有语音，而不仅仅是合成新语音。8,500 个 GitHub stars 和 ACL 2024 接收反映了真正的技术价值 —— 特别是令牌重排流程实现了自回归生成中的双向上下文。基准测试结果很明确：VoiceCraft 在说话人相似度（MOS 4.34）上领先，其编辑音频在 48% 的情况下被听者偏好于原始录音。

对于开发播客编辑器、有声书工具或语音克隆服务的开发者来说，VoiceCraft 值得投入配置时间。从 Docker 快速启动开始，在 Gradio UI 上测试，然后通过 Python API 集成。

加入我们的 [Telegram 群组](https://t.me/dibi8opensource) 讨论 VoiceCraft 部署方案、分享微调配置，并获取生产环境的帮助。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [VoiceCraft GitHub 仓库](https://github.com/jasonppy/VoiceCraft)
- [VoiceCraft 论文 — ACL 2024](https://aclanthology.org/2024.acl-long.673/)
- [VoiceCraft arXiv (v3)](https://arxiv.org/abs/2403.16973)
- [VoiceCraft 演示页面](https://jasonppy.github.io/VoiceCraft_web/)
- [VoiceCraft-X：多语言扩展](https://arxiv.org/abs/2511.12347)
- [HuggingFace 模型权重](https://huggingface.co/pyp1/VoiceCraft)
- [GPT-SoVITS 仓库](https://github.com/RVC-Boss/GPT-SoVITS)
- [Coqui TTS / XTTS v2](https://github.com/coqui-ai/TTS)
- [EnCodec — Meta 神经编解码器](https://github.com/facebookresearch/audiocraft)
- [RealEdit 数据集信息](https://github.com/jasonppy/VoiceCraft/blob/master/RealEdit.txt)
- [VoiceCraft Docker 设置指南](https://github.com/jasonppy/VoiceCraft#quickstart-docker)
- [VoiceCraft_API — FastAPI 封装](https://github.com/GPU-Net/VoiceCraft_API)

*本指南由 dibi8 技术团队独立撰写。VoiceCraft 由 Puyuan Peng、Po-Yao Huang、Shang-Wen Li、Abdelrahman Mohamed 和 David Harwath 开发。dibi8 与 VoiceCraft 项目之间不存在商业关联。*
