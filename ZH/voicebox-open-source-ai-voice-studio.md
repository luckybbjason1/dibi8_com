---
title: VoiceBox：开源AI语音工作室，用于克隆、听写和生成
description: 一个全栈开源AI语音工作室，让您克隆任意语音、生成语音并听写到任何应用。33K stars。在您的机器上本地运行，支持CUDA或Apple Silicon。
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: ai-tools
tags: ['ai', '语音ai', '语音克隆', '语音转文字', '文字转语音', 'whisper', 'qwen3-tts', 'cuda', 'mlx']
slug: voicebox-open-source-ai-voice-studio
featureImage: /images/articles/voicebox-open-source-ai-voice-studio-for-cloning-dictation-and-generation.png
lang: zh
github_repo: https://github.com/voicebox-ai/voicebox
license: MIT
---



# VoiceBox：开源AI语音工作室

**VoiceBox** 是一个全面的开源AI语音工作室，支持语音克隆、语音生成和听写——全部在您的机器上本地运行。凭借 **33,745 个 GitHub Stars** 和活跃的开发者社区，它已成为开发人员、内容创作者和注重隐私的用户的首选解决方案，无需依赖云API即可获得强大的语音AI能力。

本文涵盖安装、语音克隆、听写模式、API使用、硬件需求和实际应用。

## TL;DR

VoiceBox 提供一个完全在您的硬件上运行的完整语音AI堆栈。它支持从仅3秒音频开始的声音克隆、实时听写到任何应用程序，以及高质量的文本转语音生成。支持NVIDIA CUDA和Apple Silicon（MLX），它根据您的硬件进行调整同时保持隐私——您的语音数据永远不会离开您的机器。

## 什么是VoiceBox？

VoiceBox 是一个自托管的语音AI平台，将几种尖端技术整合到一个统一界面中。与需要将音频上传到云端的商业语音服务不同，VoiceBox 在本地处理所有内容，让您完全控制自己的语音数据。

该平台支持三种主要操作模式：

- **语音克隆**：录制或上传简短音频样本，创建可在该声音中生成语音的数字语音模型
- **听写**：使用麦克风将文本听写到系统中的任何应用程序，支持实时转录
- **文本转语音**：使用克隆语音或内置语音模型从文本生成自然语音

VoiceBox 建立在现代开源模型之上，包括Qwen3-TTS、Whisper和各种语音克隆架构，以零成本提供企业级语音AI能力。

## 安装指南

### 前置条件

VoiceBox 支持多种硬件配置：

**GPU加速（推荐）：**
- 8GB+显存的NVIDIA GPU（RTX 3060或更好）
- 已安装CUDA 12.x工具包
- 16GB系统内存
- Linux（Ubuntu 22.04+）或Windows 11

**Apple Silicon：**
- 16GB+统一内存的M1/M2/M3芯片
- macOS 14+（Sonoma或更新版本）
- 已安装MLX框架

**纯CPU（较慢但可用）：**
- 16GB+系统内存
- 8+ CPU核心
- 任何现代操作系统

### 选项一：使用Pip快速安装

```bash
# 从PyPI安装VoiceBox
pip install voicebox-ai

# 验证安装
voicebox --version

# 初始化应用程序
voicebox init --model qwen3-tts
```

### 选项二：从源代码安装（最新功能）

```bash
# 克隆仓库
git clone https://github.com/jamiepine/voicebox.git
cd voicebox

# 创建虚拟环境
python -m venv .venv
source .venv/bin/activate

# 安装依赖
pip install -r requirements.txt

# 以开发模式安装包
pip install -e .

# 下载默认语音模型
voicebox download-models --all
```

### 选项三：Docker部署

```bash
# 拉取官方镜像
docker pull jamiepine/voicebox:latest

# 使用GPU支持运行（NVIDIA）
docker run -d \
  --name voicebox \
  --gpus all \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest

# 在Apple Silicon上运行（不需要GPU标志）
docker run -d \
  --name voicebox \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest
```

### 选项四：Windows安装

```powershell
# 从Microsoft Store安装Python 3.11+
# 然后安装VoiceBox
pip install voicebox-ai

# 如需GPU加速，安装CUDA工具包
# 从以下地址下载：https://developer.nvidia.com/cuda-downloads

# 初始化VoiceBox
voicebox init --gpu cuda
```

## 语音克隆

### 录制语音样本

要克隆语音，您需要至少3秒的清晰音频。为获得最佳效果，请提供30-60秒的语音：

```bash
# 使用内置录音机录制音频
voicebox record --output sample.wav --duration 30

# 或上传现有音频文件
voicebox clone --audio my_voice_sample.mp3 --name "my-voice"

# VoiceBox自动处理音频并提取语音特征
```

### 语音处理管道

语音克隆管道包含几个阶段：

```python
from voicebox.engine import VoiceCloner
from voicebox.audio import AudioProcessor

# 初始化克隆器
cloner = VoiceCloner(model="qwen3-tts-voice-clone")

# 加载和预处理参考音频
processor = AudioProcessor()
reference = processor.load_audio("sample.wav")
reference = processor.normalize(reference, target_rms=-20)
reference = processor.remove_noise(reference, method="spectral")

# 提取语音嵌入
embeddings = cloner.extract_embeddings(reference)

# 创建语音模型
voice_model = cloner.create_voice(
    embeddings=embeddings,
    name="my-voice",
    quality="high"
)

# 测试克隆语音
output = voice_model.synthesize(
    text="你好，这是我的克隆语音。",
    speed=1.0,
    emotion="neutral"
)
voice_model.save(output, "test_output.wav")
```

### 高级语音参数

VoiceBox 提供对语音合成的细粒度控制：

```bash
# 控制语速
voicebox synthesize --input script.txt --output speech.wav --speed 0.8

# 添加情感语调
voicebox synthesize --input script.txt --output emotional.wav --emotion happy

# 调整音调
voicebox synthesize --input script.txt --output pitched.wav --pitch +200

# 组合多个参数
voicebox synthesize \
  --input script.txt \
  --output natural.wav \
  --speed 1.1 \
  --pitch +100 \
  --emotion confident \
  --clarity high
```

### 多语音支持

您可以同时创建和管理多个语音克隆：

```python
from voicebox.engine import VoiceManager

manager = VoiceManager()

# 列出所有克隆语音
voices = manager.list_voices()
for v in voices:
    print(f"{v.name}: {v.quality}（{v.duration}s训练数据）")

# 切换语音
manager.set_active_voice("my-voice")
output = manager.synthesize("你好，来自我的克隆语音！")

# 混合两个语音生成混合语音
hybrid = manager.blend_voices(
    voice_a="my-voice",
    voice_b="partner-voice",
    weight_a=0.7,
    weight_b=0.3
)
output = hybrid.synthesize("混合语音输出")
```

## 听写模式

VoiceBox的听写模式提供实时语音到文本转录，可与系统中的任何应用程序配合使用。

### 系统级听写设置

```bash
# 启用系统级听写
voicebox dictation --enable

# 选择识别模型
voicebox dictation --model whisper-large-v3

# 设置输出语言
voicebox dictation --language en

# 配置热键
voicebox dictation --hotkey "ctrl+space"
```

### 听写API使用

```python
from voicebox.dictation import DictationEngine

# 初始化听写引擎
engine = DictationEngine(
    model="whisper-large-v3",
    language="auto",
    beam_size=5,
    vad_threshold=0.5
)

# 开始监听
engine.start_listening(
    hotkey="ctrl+shift+d",
    output_mode="clipboard",
    append_mode=True
)

# 处理听写会话
result = await engine.listen_session(
    timeout=300,           # 5分钟会话
    silence_threshold=1.5, # 1.5秒静音后停止
    language="en"
)

print(f"转录: {result.text}")
print(f"置信度: {result.confidence:.2%}")
print(f"字数: {result.word_count}")
```

### 多语言听写

VoiceBox 支持同时多语言听写，具有自动语言检测功能：

```bash
# 启用自动检测
voicebox dictation --auto-detect

# 指定支持的语言
voicebox dictation --languages en,zh,ko,ja,es,fr,de

# 设置首选语言（提高准确性）
voicebox dictation --primary-language en
```

## 文本转语音API

VoiceBox 提供完整的REST API用于程序化文本转语音生成：

### 基本TTS

```bash
# 简单文本转语音转换
curl -X POST "https://your-voicebox/api/v1/tts" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "你好，这是VoiceBox文本转语音测试。",
    "voice": "default",
    "speed": 1.0,
    "output_format": "wav"
  }' \
  --output speech.wav
```

### 流式TTS

用于实时音频流应用：

```bash
# 分块流式传输音频
curl -N -X POST "https://your-voicebox/api/v1/tts/stream" \
  -H "Content-Type: application/json" \
  -d '{"text": "此音频将实时流式传输...", "voice": "cloned-voice"}' \
  --output - | aplay
```

### 批处理

同时处理多个文本：

```python
from voicebox.api import VoiceBoxClient

client = VoiceBoxClient("https://your-voicebox")

texts = [
    "第一条待处理句子。",
    "第二条不同内容句子。",
    "第三条另一语音的句子。",
]

results = await client.tts.batch(
    texts=texts,
    voice="default",
    output_format="mp3",
    parallel_workers=4
)

for i, result in enumerate(results):
    print(f"已生成: speech_{i}.mp3（{result.duration:.1f}秒）")
```

## 硬件需求与性能

### GPU性能基准

| 硬件 | 模型 | 克隆时间 | TTS速度 | 听写延迟 |
|
加入社区: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

内部链接: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/zh/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/zh/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**披露声明**: 本文提及的工具可能存在联盟关系。我们不接受付费评测。所有观点均为我们自己独立撰写。
