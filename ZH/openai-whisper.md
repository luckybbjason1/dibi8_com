---
title: 'OpenAI Whisper: 99.8K+ Stars — 完整ASR配置教程 vs WhisperX、faster-whisper 2026'
description: 'OpenAI Whisper (ASR) 基于大规模弱监督的鲁棒语音识别。兼容 WhisperX、faster-whisper、LibreTranslate。涵盖 whisper 教程、whisper vs whisperx、语音识别配置、whisper python、whisper docker。'
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
github_repo: 'https://github.com/openai/whisper'
stars: 99800
maintainer: 'openai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['whisper', '语音识别', 'ASR', 'openai', 'faster-whisper', 'whisperx', 'python', 'docker', '机器学习']
aliases:
- /zh/posts/openai-whisper/
---

{{</* resource-info */>}}

## 简介

语音识别是人类对话与机器可读数据之间的桥梁，但大多数开发者都遇到过按分钟收费、无法识别领域术语或在口音语音上完全失效的 API。2022 年底，OpenAI 将 Whisper 作为 MIT 许可的开源替代品发布，采用率立竿见影 — 99,800 个 GitHub stars 之后，它已成为生产环境中最被广泛采用的开源 ASR 系统。本指南将带你完成完整的 Whisper 配置，将其与 WhisperX、faster-whisper 和 DeepSpeech 进行对比，并提供可立即部署的生产级配置。

## 什么是 OpenAI Whisper？

OpenAI Whisper 是一个通用自动语音识别（ASR）模型，基于 68 万小时的多语言多任务监督数据训练。它支持 99 种语言的语音转文本、语音翻译为英语、口语语言识别和时间戳分段对齐。与仅限云端的 API 不同，Whisper 完全在消费级硬件上离线运行，使其成为医疗、媒体、呼叫中心和无障碍工具中转录流水线的核心组件。

## Whisper 的工作原理

Whisper 采用编码器-解码器 Transformer 架构。音频输入被转换为对数 Mel 频谱图，然后通过编码器处理。解码器以自回归方式预测文本 token，并以特殊任务 token 为条件，告诉模型是进行转录、翻译还是检测语言。

![Whisper 架构图](https://raw.githubusercontent.com/openai/whisper/main/approach.png)

**核心设计决策：**

- **大规模弱监督**：使用带噪声标签的多样化网络规模音频进行训练，而非小型纯净数据集
- **多任务训练**：单个模型通过任务 token 处理转录、翻译和语言识别
- **分块处理**：长音频被分割为 30 秒片段，独立处理后重新组装
- **以上下文为条件**：解码器接收前一段落的 token，以保持跨边界格式一致

| 模型 | 参数量 | 英语 WER | 多语言 WER | 显存 (GPU) | 相对速度 |
|------|--------|----------|------------|------------|----------|
| tiny  | 39M    | ~7.6%    | ~12%       | ~1 GB      | ~10x     |
| base  | 74M    | ~5.0%    | ~10%       | ~1 GB      | ~7x      |
| small | 244M   | ~3.4%    | ~7%        | ~2 GB      | ~4x      |
| medium| 769M   | ~2.9%    | ~5%        | ~5 GB      | ~2x      |
| large-v3 | 1.55B | ~2.4%  | ~3.5%      | ~10 GB     | 1x       |
| turbo | 809M   | ~2.5%    | ~3.7%      | ~6 GB      | ~8x      |

## 安装与配置

### Python 安装

```bash
python -m venv whisper-env
source whisper-env/bin/activate  # Linux/macOS
# whisper-env\Scripts\activate  # Windows

# 安装 OpenAI Whisper
pip install -U openai-whisper

# 验证安装
whisper --version
```

### 系统依赖

FFmpeg 是音频预处理必需的：

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install ffmpeg

# macOS
brew install ffmpeg

# 验证
ffmpeg -version | head -1
```

### GPU 加速 (CUDA)

```bash
# 检查 CUDA 可用性
python -c "import torch; print(torch.cuda.is_available())"

# 安装 CUDA 12 支持
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 仅 CPU 推理
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
```

### Docker 部署

```bash
# 拉取并运行官方镜像
docker pull openai/whisper:latest

# 通过 Docker 转录文件
docker run --rm \
  --gpus all \
  -v $(pwd)/audio:/audio \
  openai/whisper:latest \
  /audio/interview.mp3 \
  --model large-v3 \
  --language en \
  --output_format json

# 仅 CPU 的 Docker 运行
docker run --rm \
  -v $(pwd)/audio:/audio \
  openai/whisper:latest \
  /audio/podcast.mp3 \
  --model base \
  --device cpu
```

### 快速首次转录

```python
import whisper

# 加载模型（首次运行时下载）
model = whisper.load_model("base")

# 转录音频文件
result = model.transcribe("audio.mp3")
print(result["text"])

# 获取带时间戳的分段
for segment in result["segments"]:
    print(f"[{segment['start']:.2f}s -> {segment['end']:.2f}s] {segment['text']}")
```

### CLI 使用示例

```bash
# 基本转录
whisper audio.mp3 --model medium --language en

# 输出所有格式 (JSON, SRT, VTT, TXT)
whisper podcast.mp3 --model large-v3 --output_format all

# 将非英语音频翻译为英语文本
whisper french_interview.mp3 --model large-v3 --task translate

# 自动检测语言
whisper unknown.mp3 --model base --task transcribe
```

## 与流行工具集成

### WhisperX（词级时间戳 + 说话人分离）

WhisperX 封装了 faster-whisper，并添加了音素级对齐和说话人分离功能。它是会议记录和访谈处理的首选工具。

```bash
pip install whisperx
```

```python
import whisperx
import torch

device = "cuda" if torch.cuda.is_available() else "cpu"
audio_file = "meeting.mp3"
batch_size = 16
compute_type = "float16"

# 1. 使用 faster-whisper 后端进行转录
model = whisperx.load_model("large-v3", device, compute_type=compute_type)
audio = whisperx.load_audio(audio_file)
result = model.transcribe(audio, batch_size=batch_size)

# 2. 对齐以获取精确的词级时间戳
model_a, metadata = whisperx.load_align_model(
    language_code=result["language"],
    device=device
)
result = whisperx.align(
    result["segments"],
    model_a,
    metadata,
    audio,
    device
)

# 3. 说话人分离
diarize_model = whisperx.DiarizationPipeline(
    use_auth_token="YOUR_HF_TOKEN",
    device=device
)
diarize_segments = diarize_model(audio)
result = whisperx.assign_word_speakers(diarize_segments, result)

# 打印带说话人标签的转录结果
for segment in result["segments"]:
    speaker = segment.get("speaker", "UNKNOWN")
    start = segment["start"]
    end = segment["end"]
    text = segment["text"]
    print(f"[{start:.2f}s - {end:.2f}s] {speaker}: {text}")
```

### faster-whisper（生产推理）

faster-whisper 使用 CTranslate2 重新实现了 Whisper，提供 4-8 倍的速度提升和量化支持。它是生产 API 的默认选择。

```bash
pip install faster-whisper
```

```python
from faster_whisper import WhisperModel

# 使用量化以降低显存
model = WhisperModel(
    "large-v3",
    device="cuda",
    compute_type="float16",   # 选项: int8, int8_float16, float16, float32
    num_workers=4,
    cpu_threads=8
)

# 使用 VAD 过滤进行转录
segments, info = model.transcribe(
    "podcast.mp3",
    beam_size=5,
    vad_filter=True,
    vad_parameters={
        "threshold": 0.5,
        "min_speech_duration_ms": 250,
        "min_silence_duration_ms": 500
    },
    language="en",
    condition_on_previous_text=True
)

print(f"检测到的语言: {info.language} (概率: {info.language_probability:.2f})")

for segment in segments:
    print(f"[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}")
```

### LibreTranslate 集成（翻译流水线）

```python
import whisper
import requests

# 转录非英语音频
model = whisper.load_model("medium")
audio_path = "japanese_podcast.mp3"
result = model.transcribe(audio_path, language="ja")
japanese_text = result["text"]

# 通过 LibreTranslate API 翻译
def translate(text, source="ja", target="en"):
    response = requests.post(
        "http://localhost:5000/translate",
        headers={"Content-Type": "application/json"},
        json={"q": text, "source": source, "target": target}
    )
    return response.json()["translatedText"]

english_text = translate(japanese_text)
print(f"JA: {japanese_text}")
print(f"EN: {english_text}")
```

### FastAPI 实时转录服务器

```python
from fastapi import FastAPI, UploadFile, File
from faster_whisper import WhisperModel
import tempfile
import os

app = FastAPI()
model = WhisperModel("medium", device="cuda", compute_type="float16")

@app.post("/transcribe")
async def transcribe(file: UploadFile = File(...)):
    with tempfile.NamedTemporaryFile(delete=False, suffix=".mp3") as tmp:
        tmp.write(await file.read())
        tmp_path = tmp.name

    segments, info = model.transcribe(
        tmp_path,
        beam_size=5,
        vad_filter=True
    )

    os.unlink(tmp_path)

    results = [
        {
            "start": s.start,
            "end": s.end,
            "text": s.text,
            "confidence": s.words[0].probability if s.words else None
        }
        for s in segments
    ]

    return {
        "language": info.language,
        "language_probability": info.language_probability,
        "segments": results
    }
```

运行命令：`uvicorn main:app --host 0.0.0.0 --port 8000 --workers 2`

### Prometheus 监控集成

```python
from prometheus_client import Counter, Histogram, start_http_server
import time

TRANSCRIPTION_COUNT = Counter(
    "whisper_transcriptions_total",
    "总转录次数",
    ["model", "language"]
)
TRANSCRIPTION_DURATION = Histogram(
    "whisper_transcription_duration_seconds",
    "转录耗时",
    ["model"]
)

def transcribe_with_metrics(audio_path, model_name="medium"):
    start = time.time()
    segments, info = model.transcribe(audio_path)
    duration = time.time() - start

    TRANSCRIPTION_COUNT.labels(model=model_name, language=info.language).inc()
    TRANSCRIPTION_DURATION.labels(model=model_name).observe(duration)

    return segments, info

# 在 9090 端口启动监控服务器
start_http_server(9090)
```

## 基准测试 / 实际用例

![Whisper 语言分布](https://raw.githubusercontent.com/openai/whisper/main/language-breakdown.svg)

### 词错误率对比 (LibriSpeech test-clean)

| 模型 / 引擎 | WER (clean) | WER (other) | 多语言 | 年份 |
|-------------|-------------|-------------|--------|------|
| Whisper tiny | 7.6% | 12.0% | 12.0% | 2022 |
| Whisper base | 5.0% | 8.1% | 10.0% | 2022 |
| Whisper small | 3.4% | 5.8% | 7.0% | 2022 |
| Whisper medium | 2.9% | 5.0% | 5.0% | 2022 |
| Whisper large-v3 | 2.4% | 4.2% | 3.5% | 2024 |
| Whisper turbo | 2.5% | 4.3% | 3.7% | 2024 |
| faster-whisper (large-v3) | 2.4% | 4.2% | 3.5% | 2024 |
| WhisperX (large-v3) | 2.4% | 4.2% | 3.5% | 2024 |
| Mozilla DeepSpeech | 7.3% | 21.5% | N/A (仅英语) | 2020 |

### 推理速度基准 (1 小时音频, NVIDIA RTX 4090)

| 引擎 | 模型 | 时间 | 显存 | 说明 |
|------|------|------|------|------|
| OpenAI Whisper | large-v3 | ~90 分钟 | ~10 GB | 基线 |
| faster-whisper | large-v3 | ~18 分钟 | ~6 GB | float16, 4-8 倍加速 |
| faster-whisper | large-v3 | ~12 分钟 | ~4 GB | int8 量化 |
| WhisperX | large-v3 | ~25 分钟 | ~8 GB | 包含对齐 |
| WhisperX (无分离) | large-v3 | ~18 分钟 | ~6 GB | 仅转录 |
| OpenAI Whisper | turbo | ~12 分钟 | ~6 GB | 蒸馏解码器 |

### 生产部署场景

| 用例 | 推荐模型 | 引擎 | 硬件 | 日处理量 |
|------|----------|------|------|----------|
| 播客转录 | large-v3 | faster-whisper | 1x A100 | 500+ 小时 |
| 实时会议笔记 | turbo | faster-whisper | 1x RTX 4090 | 200+ 小时 |
| 呼叫中心分析 | medium | faster-whisper (int8) | 2x RTX 3080 | 1000+ 小时 |
| 移动端/边缘设备 | tiny.en | whisper.cpp | 8 GB 内存 | 离线 |
| 视频字幕生成 | large-v3 | WhisperX | 1x A100 | 300+ 小时 |

## 高级用法 / 生产环境加固

### 模型量化以降低显存

```python
from faster_whisper import WhisperModel

# INT8 量化 — 2 倍速度，减少 50% 显存
model_int8 = WhisperModel("large-v3", device="cuda", compute_type="int8")

# INT8 配合 float16 激活 — 平衡模式
model_hybrid = WhisperModel("large-v3", device="cuda", compute_type="int8_float16")

# CPU 使用 INT8
model_cpu = WhisperModel("medium", device="cpu", compute_type="int8", cpu_threads=8)
```

### 批处理流水线

```python
import os
from concurrent.futures import ThreadPoolExecutor
from faster_whisper import WhisperModel

model = WhisperModel("medium", device="cuda", compute_type="float16")

def process_file(audio_path):
    segments, info = model.transcribe(
        audio_path,
        vad_filter=True,
        beam_size=5
    )
    text = " ".join([s.text for s in segments])
    output_path = audio_path.replace(".mp3", ".txt")
    with open(output_path, "w") as f:
        f.write(text)
    return output_path

# 处理目录中的音频文件
audio_dir = "/data/audio/"
files = [os.path.join(audio_dir, f) for f in os.listdir(audio_dir) if f.endswith(".mp3")]

with ThreadPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(process_file, files))

print(f"已处理 {len(results)} 个文件")
```

### NGINX 负载均衡 (多 GPU)

```nginx
upstream whisper_backend {
    least_conn;
    server 10.0.1.10:8000 weight=1;  # GPU 0
    server 10.0.1.10:8001 weight=1;  # GPU 1
    server 10.0.1.11:8000 weight=1;  # GPU 2
    server 10.0.1.11:8001 weight=1;  # GPU 3
}

server {
    listen 80;
    location /transcribe {
        proxy_pass http://whisper_backend;
        proxy_read_timeout 300s;
        client_max_body_size 500M;
    }
}
```

### 健康检查端点

```python
from fastapi import FastAPI, HTTPException
from faster_whisper import WhisperModel
import torch

app = FastAPI()
model = WhisperModel("medium", device="cuda", compute_type="float16")

@app.get("/health")
async def health():
    gpu_available = torch.cuda.is_available()
    gpu_memory = torch.cuda.get_device_properties(0).total_memory if gpu_available else 0
    return {
        "status": "healthy",
        "gpu_available": gpu_available,
        "gpu_memory_gb": gpu_memory / (1024**3),
        "model_loaded": model is not None
    }
```

### Redis 队列异步处理

```python
import redis
import json
from faster_whisper import WhisperModel
import time

r = redis.Redis(host='localhost', port=6379, db=0)
model = WhisperModel("medium", device="cuda", compute_type="float16")

def worker():
    while True:
        job = r.blpop("transcription_queue", timeout=5)
        if job:
            _, data = job
            task = json.loads(data)
            segments, info = model.transcribe(task["file_path"])
            result = {
                "job_id": task["job_id"],
                "text": " ".join([s.text for s in segments]),
                "language": info.language
            }
            r.setex(f"result:{task['job_id']}", 3600, json.dumps(result))
        time.sleep(0.1)

if __name__ == "__main__":
    worker()
```

## 与替代品对比

![Whisper 模型变体对比](https://opengraph.githubassets.com/1/openai/whisper)

| 功能 | OpenAI Whisper | WhisperX | faster-whisper | DeepSpeech |
|------|---------------|----------|----------------|------------|
| **GitHub Stars** | 99,800 | 19,700 | 20,400 | 26,700 (已归档) |
| **许可证** | MIT | BSD-2 | MIT | MPL-2.0 |
| **相对基线速度** | 1x (基线) | 0.8-1x | 4-8x | 2x |
| **需要 GPU** | 可选 | 推荐 | 可选 | 可选 |
| **量化支持** | 否 | 否 | 是 (INT8/FP16) | 否 |
| **词级时间戳** | 分段级 | 音素级 | 分段级 | 否 |
| **说话人分离** | 否 | 内置 | 否 | 否 |
| **支持语言** | 99 | 99 | 99 | 仅英语 |
| **WER (LibriSpeech clean)** | 2.4% (large-v3) | 2.4% | 2.4% | 7.3% |
| **活跃开发** | 是 | 是 | 是 | 否 (2025年6月归档) |
| **适用场景** | 研究、参考 | 会议转录 | 生产 API | 仅遗留系统 |

## 局限性 / 诚实评估

Whisper 并非适合所有语音任务。以下是 README 不会告诉你的：

1. **不支持流式处理**：Whisper 处理 30 秒分块；不适合真正的实时（<200ms 延迟）转录。如需流式 ASR，请考虑 NVIDIA Parakeet 或 Moonshine v2。

2. **静音时产生幻觉**：large-v3 偶尔会在静音片段上生成幻觉文本。使用 VAD 过滤（faster-whisper 内置）来缓解。

3. **英语中心化训练**：虽然支持 99 种语言，但在低资源的非洲和南亚语言上性能明显下降。通常需要在目标语言数据上微调。

4. **内存占用**：large-v3 在 FP32 下需要约 10 GB 显存。需要使用量化（faster-whisper）或 CPU 卸载才能在中端 GPU 上运行。

5. **无说话人分离**：基础 Whisper 无法区分说话人。需要 WhisperX 或单独的分离流水线来实现多说话人识别。

6. **翻译限制**：turbo 模型未经过翻译训练。如需翻译为英语，请使用 medium 或 large-v3。

## 常见问题解答

### 1. Whisper 和 faster-whisper 有什么区别？

faster-whisper 使用 CTranslate2（C++ 推理引擎）重新实现了 Whisper。它提供 4-8 倍加速、INT8 量化和内置 VAD 过滤，同时产生相同的转录结果。生产环境使用 faster-whisper；研究和实验使用 OpenAI Whisper。

### 2. 我可以在 CPU 上运行 Whisper 吗？

可以。除 large-v3 外的所有模型都能在现代 CPU 上舒适运行。在笔记本上使用 tiny 模型进行准实时转录，或使用 INT8 量化的 medium 模型进行批处理。相比 GPU 慢 3-5 倍。

### 3. 我应该选择哪个模型大小？

英语快速任务从 `base` 开始，日常多语言使用 `small`，专业精度需求使用 `medium`，最高精度不可妥协时使用 `large-v3`。`turbo` 模型是延迟敏感生产工作负载的最佳平衡点。

### 4. 如何高效处理长音频文件？

使用 faster-whisper 的 `vad_filter=True` 跳过静音片段。超过 1 小时的文件，分块并行处理。WhisperX 原生处理长文件，在 3 小时以上音频上比基础 Whisper 更稳定。

### 5. Whisper 可以免费商用吗？

可以。Whisper 采用 MIT 许可证发布，允许商业使用、修改和分发。没有 API 费用，因为你在自己的硬件上运行。唯一成本是计算资源（GPU/云实例）。

### 6. Whisper 与 Google Speech-to-Text 等云 API 相比如何？

Whisper large-v3 在英语上的 WER 与 Google Speech-to-Text 相当（LibriSpeech 上 2.4% vs 2.1%）。Whisper 在隐私（本地部署）、成本（无每分钟费用）和语言覆盖（99 种语言）上胜出。云 API 在集成生态和托管扩展性上胜出。

### 7. 生产环境需要什么硬件？

单张 NVIDIA A100 (80 GB) 可以运行 4 个 float16 的 large-v3 实例，每天处理约 200 小时音频。预算方案中，RTX 4090 (24 GB) 配合 faster-whisper 可以舒适地运行 medium 和 large-v3 的 float16。

## 结论

OpenAI Whisper 在 2026 年仍然是生产语音识别的务实选择。99,800 个 GitHub stars 不仅反映了其受欢迎程度，更体现了生态系统的成熟度：faster-whisper 提供速度，WhisperX 提供说话人分离，核心模型在 99 种语言上提供高精度。以 `faster-whisper` 和 `medium` 模型起步，需要说话人标签时添加 `WhisperX`，显存紧张时使用 INT8 量化。

**下一步：**
- 克隆仓库：`git clone https://github.com/openai/whisper`
- 加入 dibi8 开发者 Telegram 社区获取部署技巧
- 在自己的音频数据上测试 faster-whisper，再确定模型大小



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [OpenAI Whisper GitHub 仓库](https://github.com/openai/whisper)
- [OpenAI Whisper 论文 (arXiv:2212.04356)](https://arxiv.org/abs/2212.04356)
- [faster-whisper by SYSTRAN](https://github.com/SYSTRAN/faster-whisper)
- [WhisperX by m-bain](https://github.com/m-bain/whisperX)
- [Whisper 模型大小详解](https://openwhispr.com/blog/whisper-model-sizes-explained)
- [Choosing Between Whisper Variants — Modal.com](https://modal.com/blog/choosing-whisper-variants)
- [Comparison: WhisperX vs Faster-Whisper vs OpenAI Whisper](https://gist.github.com/danielrosehill/278b1719598093767126e52105ae076e)
- [Whisper API Blog — Model Comparison](https://whisperapi.com/accuracy-benchmarks-top-free-open-source-speech-to-text-offerings)
