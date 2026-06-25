---
title: 'VoiceBox: 음성 복제, 녹취 및 생성을 위한 오픈소스 AI 음성 스튜디오'
description: 어떤 음성이라도 복제하고, 음성을 생성하며, 어떤 앱에도 녹취할 수 있는 풀스택 오픈소스 AI 음성 스튜디오. 33K 스타. CUDA 또는 Apple Silicon 지원을 lokale에서 실행됩니다.
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: ai-tools
tags: ['ai', '음성ai', '음성복제', '음성인식', '텍스트음성변환', 'whisper', 'qwen3-tts', 'cuda', 'mlx']
slug: voicebox-open-source-ai-voice-studio
featureImage: /images/articles/voicebox-open-source-ai-voice-studio-for-cloning-dictation-and-generation.png
lang: kr
github_repo: https://github.com/voicebox-ai/voicebox
license: MIT
---



# VoiceBox: 오픈소스 AI 음성 스튜디오

**VoiceBox**는 음성 복제, 음성 생성 및 녹취를 위한 포괄적인 오픈소스 AI 음성 스튜디오로, 모든 것이 머신에서 로컬로 실행됩니다. **33,745개의 GitHub 스타**와 활발한 개발 커뮤니티를 바탕으로, 클라우드 API에 의존하지 않고 강력한 음성 AI가 필요한 개발자, 콘텐츠 제작자 및 프라이버시 중심 사용자를 위한 필수 솔루션이 되었습니다.

이 글은 설치, 음성 복제, 녹취 모드, API 사용, 하드웨어 요구사항 및 실용적 적용 방법을 다룹니다.

## TL;DR

VoiceBox는 하드웨어 전체에서 완전히 실행되는 완성된 음성 AI 스택을 제공합니다. 3초의 오디오만으로 음성 복제, 시스템의 모든 앱에 대한 실시간 녹취, 고품질 텍스트-음성 변환 생성을 지원합니다. NVIDIA CUDA와 Apple Silicon(MLX) 모두 지원하여 하드웨어에 적응하면서 프라이버시를 유지합니다 — 음성 데이터는 머신을 떠나지 않습니다.

## VoiceBox란?

VoiceBox는 몇 가지 최첨단 기술을 단일 통합 인터페이스로 결합하는 자체 호스팅 음성 AI 플랫폼입니다. 오디오를 클라우드에 업로드해야 하는 상업용 음성 서비스와 달리, VoiceBox는 모든 것을 로컬에서 처리하여 음성 데이터에 대한 완전한 제어를 제공합니다.

플랫폼은 세 가지 주요 작동 모드를 지원합니다:

- **음성 복제**: 짧은 오디오 샘플을 녹음하거나 업로드하여 해당 음성으로 음성을 생성할 수 있는 디지털 음성 모델 생성
- **녹취**: 마이크를 사용하여 시스템의 모든 앱에 텍스트를 실시간으로 변환하여 입력
- **텍스트-음성 변환**: 복제된 음성 또는 내장 음성 모델을 사용하여 자연스러운 음성을 텍스트에서 생성

Qwen3-TTS, Whisper 및 다양한 음성 복제 아키텍처를 기반으로 하는 VoiceBox는 제로 비용으로 엔터프라이즈급 음성 AI 기능을 제공합니다.

## 설치 가이드

### 사전 요구사항

VoiceBox는 여러 하드웨어 구성을 지원합니다:

**GPU 가속 (권장):**
- 8GB+ VRAM이 있는 NVIDIA GPU (RTX 3060 이상)
- CUDA 12.x 툴킷 설치됨
- 16GB 시스템 RAM
- Linux (Ubuntu 22.04+) 또는 Windows 11

**Apple Silicon:**
- 16GB+ 통합 메모리가 있는 M1/M2/M3 칩
- macOS 14+ (Sonoma 이상)
- MLX 프레임워크 설치됨

**CPU 전용 (느리지만 기능적):**
- 16GB+ 시스템 RAM
- 8+ CPU 코어
- 모든 현대 운영체제

### 옵션 1: Pip로 빠른 설치

```bash
# PyPI에서 VoiceBox 설치
pip install voicebox-ai

# 설치 확인
voicebox --version

# 애플리케이션 초기화
voicebox init --model qwen3-tts
```

### 옵션 2: 소스에서 설치 (최신 기능)

```bash
# 저장소 복제
git clone https://github.com/jamiepine/voicebox.git
cd voicebox

# 가상 환경 생성
python -m venv .venv
source .venv/bin/activate

# 종속성 설치
pip install -r requirements.txt

# 개발 모드에서 패키지 설치
pip install -e .

# 기본 음성 모델 다운로드
voicebox download-models --all
```

### 옵션 3: Docker 배포

```bash
# 공식 이미지 가져오기
docker pull jamiepine/voicebox:latest

# GPU 지원으로 실행 (NVIDIA)
docker run -d \
  --name voicebox \
  --gpus all \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest

# Apple Silicon에서 실행 (GPU 플래그 불필요)
docker run -d \
  --name voicebox \
  -p 8000:8000 \
  -v ${HOME}/voicebox-data:/data \
  -e VOICEBOX_MODEL=qwen3-tts \
  jamiepine/voicebox:latest
```

### 옵션 4: Windows 설치

```powershell
# Microsoft Store에서 Python 3.11+ 설치
# 그런 다음 VoiceBox 설치
pip install voicebox-ai

# GPU 가속을 위해 CUDA 툴킷 설치
# 다운로드: https://developer.nvidia.com/cuda-downloads

# VoiceBox 초기화
voicebox init --gpu cuda
```

## 음성 복제

### 오디오 샘플 녹음

음성을 복제하려면 최소 3초의 명확한 오디오가 필요합니다. 최상의 결과를 위해 30-60초의 음성을 제공하세요:

```bash
# 내장 레코더로 오디오 녹음
voicebox record --output sample.wav --duration 30

# 기존 오디오 파일 업로드
voicebox clone --audio my_voice_sample.mp3 --name "my-voice"

# VoiceBox가 자동으로 오디오를 처리하고 음성 특징 추출
```

### 음성 처리 파이프라인

음성 복제 파이프라인은 여러 단계로 구성됩니다:

```python
from voicebox.engine import VoiceCloner
from voicebox.audio import AudioProcessor

# 클로너 초기화
cloner = VoiceCloner(model="qwen3-tts-voice-clone")

# 참조 오디오 로드 및 전처리
processor = AudioProcessor()
reference = processor.load_audio("sample.wav")
reference = processor.normalize(reference, target_rms=-20)
reference = processor.remove_noise(reference, method="spectral")

# 음성 임베딩 추출
embeddings = cloner.extract_embeddings(reference)

# 음성 모델 생성
voice_model = cloner.create_voice(
    embeddings=embeddings,
    name="my-voice",
    quality="high"
)

# 복제된 음성 테스트
output = voice_model.synthesize(
    text="안녕하세요, 복제된 음성입니다.",
    speed=1.0,
    emotion="neutral"
)
voice_model.save(output, "test_output.wav")
```

### 고급 음성 매개변수

VoiceBox는 음성 합성에 세밀한 제어를 제공합니다:

```bash
# 발화 속도 조절
voicebox synthesize --input script.txt --output speech.wav --speed 0.8

# 감정 억양 추가
voicebox synthesize --input script.txt --output emotional.wav --emotion happy

# 피치 조절
voicebox synthesize --input script.txt --output pitched.wav --pitch +200

# 여러 매개변수 조합
voicebox synthesize \
  --input script.txt \
  --output natural.wav \
  --speed 1.1 \
  --pitch +100 \
  --emotion confident \
  --clarity high
```

### 다중 음성 지원

여러 음성 복제를 동시에 생성하고 관리할 수 있습니다:

```python
from voicebox.engine import VoiceManager

manager = VoiceManager()

# 모든 복제된 음성 나열
voices = manager.list_voices()
for v in voices:
    print(f"{v.name}: {v.quality} (학습 데이터 {v.duration}s)")

# 음성 간 전환
manager.set_active_voice("my-voice")
output = manager.synthesize("복제된 음성에서 안녕하세요!")

# 두 음성을 혼합하여 하이브리드 음성 생성
hybrid = manager.blend_voices(
    voice_a="my-voice",
    voice_b="partner-voice",
    weight_a=0.7,
    weight_b=0.3
)
output = hybrid.synthesize("혼합 음성 출력")
```

## 녹취 모드

VoiceBox의 녹취 모드는 시스템의 모든 앱에서 작동하는 실시간 음성-텍스트 변환을 제공합니다.

### 시스템 전체 녹취 설정

```bash
# 시스템 전체 녹취 활성화
voicebox dictation --enable

# 인식 모델 선택
voicebox dictation --model whisper-large-v3

# 출력 언어 설정
voicebox dictation --language en

# 핫키 구성
voicebox dictation --hotkey "ctrl+space"
```

### 녹취 API 사용

```python
from voicebox.dictation import DictationEngine

# 녹취 엔진 초기화
engine = DictationEngine(
    model="whisper-large-v3",
    language="auto",
    beam_size=5,
    vad_threshold=0.5
)

# 듣기 시작
engine.start_listening(
    hotkey="ctrl+shift+d",
    output_mode="clipboard",
    append_mode=True
)

# 녹취 세션 처리
result = await engine.listen_session(
    timeout=300,           # 5분 세션
    silence_threshold=1.5, # 1.5초 침묵 후 중지
    language="en"
)

print(f"변역: {result.text}")
print(f"신뢰도: {result.confidence:.2%}")
print(f"단어 수: {result.word_count}")
```

### 다국어 녹취

VoiceBox는 자동 언어 감지와 함께 동시 다국어 녹취를 지원합니다:

```bash
# 자동 감지 활성화
voicebox dictation --auto-detect

# 지원 언어 지정
voicebox dictation --languages en,zh,ko,ja,es,fr,de

# 주요 언어 설정 (더 나은 정확도)
voicebox dictation --primary-language en
```

## 텍스트-음성 변환 API

VoiceBox는 프로그램matic 텍스트-음성 변환을 위한 완전한 REST API를 제공합니다:

### 기본 TTS

```bash
# 간단한 텍스트-음성 변환
curl -X POST "https://your-voicebox/api/v1/tts" \
  -H "Content-Type: application/json" \
  -d '{
    "text": "안녕하세요, VoiceBox 텍스트-음성 변환 테스트입니다.",
    "voice": "default",
    "speed": 1.0,
    "output_format": "wav"
  }' \
  --output speech.wav
```

### 스트리밍 TTS

실시간 오디오 스트리밍 애플리케이션용:

```bash
# 청크로 오디오 스트리밍
curl -N -X POST "https://your-voicebox/api/v1/tts/stream" \
  -H "Content-Type: application/json" \
  -d '{"text": "이 오디오는 실시간으로 스트리밍됩니다...", "voice": "cloned-voice"}' \
  --output - | aplay
```

### 배치 처리

여러 텍스트를 동시에 처리:

```python
from voicebox.api import VoiceBoxClient

client = VoiceBoxClient("https://your-voicebox")

texts = [
    "처리로 할 첫 문장.",
    "다른 내용이 포함된 두 번째 문장.",
    "다른 음성으로 세 번째 문장.",
]

results = await client.tts.batch(
    texts=texts,
    voice="default",
    output_format="mp3",
    parallel_workers=4
)

for i, result in enumerate(results):
    print(f"생성됨: speech_{i}.mp3 ({result.duration:.1f}s)")
```

## 하드웨어 요구사항 및 성능

### GPU 성능 벤치마크

| 하드웨어 | 모델 | 복제 시간 | TTS 속도 | 녹취 지연 |
|
내부 링크: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/kr/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/kr/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**고지 사항**: 본 기사는 제휴 관계가 있을 수 있는 도구를 언급합니다. 우리는 리뷰에 대한 대가를 받지 않습니다. 모든 의견은 우리 자신의 것입니다.
