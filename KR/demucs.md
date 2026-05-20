---
title: 'Demucs: 10K+ Stars 음악 소스 분리 — UVR, Spleeter 2026 비교'
description: 'Demucs는 Meta AI가 개발한 하이브리드 스펙트로그램 및 파형 소스 분리 모델입니다. Ultimate Vocal Remover, RVC, GPT-SoVITS와 호환됩니다. demucs 튜토리얼, demucs vs uvr, demucs Docker 설치, 프로덕션 벤치마크를 다룹니다.'
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
github_repo: 'https://github.com/facebookresearch/demucs'
stars: 10100
maintainer: 'facebookresearch'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['demucs', '음악소스분리', 'AI오디오', '스템분리', 'pytorch', 'docker', '오픈소스']
aliases:
- /kr/posts/demucs/
---

{{</* resource-info */>}}

믹스된 곡을 보컬, 드럼, 베이스, 기타 등 개별 악기 트랙으로 분리하는 것은 원래 원본 멀티트랙 스튜디오 파일이 필요했다. 딥러닝 모델이 완성된 오디오를 "언믹스(unmix)"하는 방법을 학습하면서 이 상황은 바뀌었다. 오늘날 음악가, 프로듀서, 개발자들은 노래방 트랙 제작, 샘플 추출, 리믹스 준비, 보이스 컨버전 파이프라인을 위해 이러한 도구를 사용한다. 오픈 소스 옵션 중 하나가 대화를 지배하는 모델이 있다: **Demucs** — Meta의 하이브리드 트랜스포머 아키텍처로 GitHub에서 10,000개 이상의 스타를 보유하고 MUSDB18-HQ 데이터셋에서 최고 수준의 벤치마크를 달성한 모델.

이 가이드에서는 Demucs의 작동 원리, 로컬 설치 방법, Spleeter 및 Ultimate Vocal Remover와의 비교, 실제 프로덕션 워크플로우에 통합하는 방법을 소개한다.

## Demucs란?**

**Demucs**(Deep Extractor for Music Sources)는 Meta AI Research에서 개발한 오픈 소스 음악 소스 분리 모델이다. 스테레오 오디오 믹스를 입력으로 받아 분리된 "스템(stem)" — 일반적으로 보컬, 드럼, 베이스, 기타와 키보드 등 나머지 악기가 포함된 "기타(other)" 트랙 — 을 출력한다.

프로젝트는 GitHub의 `facebookresearch/demucs` 저장소에 있으며 10,100개 이상의 스타와 1,500개의 포크를 달성했다. 저장소는 2025년 1월 1일에 Meta에 의해 아카이브되었지만, 원작자 Alexandre Defossez가 `adefossez/demucs`에서 활발한 포크를 유지하고 있다. 최신 안정 버전은 v4.1.0이며 전체 프로젝트는 MIT 라이선스를 따른다.

Demucs를 이전 도구와 차별화하는 핵심은 **하이브리드 접근 방식**이다: 동시에 시간 영역(원본 파형)과 주파수 영역(스펙트로그램)에서 오디오를 처리한 뒤 두 표현을 융합한다. 이러한 이중 영역 처리는 순수 스펙트럼 방식이 손실시키는 위상 정보를 보존하여 더 깨끗한 분리와 더 적은 금속성 아티팩트를 제공한다.

## Demucs 작동 방식

### 아키텍처 개요

Demucs의 현재 세대 — 공식명 **Hybrid Transformer Demucs (HTDemucs)** — 트랜스포머 레이어가 추가된 U-Net 컨볼루션 백본을 기반으로 한다. 아키텍처는 개념적으로 세 단계로 구성된다:

1. **인코더**: 입력 파형이 시간 영역 인코더(1D 컨볼루션)와 주파수 영역 인코더(STFT 후 2D 컨볼루션)를 동시에 통과한다. 이러한 이중 인코딩은 미세한 시간적 세부 정보와 고조파 주파수 구조를 모두 포착한다.

2. **트랜스포머 병목**: U-Net의 가장 깊은 레이어는 각 영역 내에서 자기 주의를, 영역 간에는 교차 주의를 수행하는 교차 영역 트랜스포머 인코더를 사용한다. 이 메커니즘은 장거리 종속성을 모델링한다 — 예를 들어 유사한 음역의 기타 선율과 여러 마디에 걸친 보컬 멜로디를 분리하는 데 매우 중요하다.

3. **디코더**: 별도의 디코더가 두 영역에서 각 소스(드럼, 베이스, 기타, 보컬)를 재구성하고, 융합 레이어가 최종 분리된 파형으로 결합한다.

![Demucs 아키텍처 다이어그램](https://raw.githubusercontent.com/facebookresearch/demucs/main/demucs.png)

### 사용 가능한 모델

Demucs는 다양한 속도/품질 트레이드오프에 최적화된 여러 사전 학습 모델을 제공한다:

| 모델 | 스템 수 | VRAM | SDR (MUSDB) | 사용 사례 |
|------|---------|------|-------------|-----------|
| `htdemucs` | 4 | ~5.2 GB | 7.1 dB | 기본값, 속도/품질 최적 균형 |
| `htdemucs_ft` | 4 | ~7.8 GB | 7.8 dB | 최대 품질, ~4배 느림 |
| `htdemucs_6s` | 6 | ~6.5 GB | 6.8 dB | 기타+피아노 분리 |
| `mdx_extra_q` | 4 | ~3.0 GB | 6.5 dB | 저VRAM 시스템 |

`htdemucs_ft` 모델은 MUSDB18-HQ에서 7.8 dB의 전체 SDR을 달성하며, 소스별로는 보컬 8.5 dB, 베이스 7.5 dB, 드럼 8.9 dB, "기타" 카테고리 6.2 dB를 기록한다. 참고로 0 dB는 원본 믹스 대비 분리 개선이 없음을 의미한다.

## 설치 및 설정

### 사전 요구사항

Demucs를 설치하기 전에 환경을 확인한다:

```bash
# Python 3.8+ 필수
python --version

# FFmpeg 설치 필요
ffmpeg -version

# (선택) NVIDIA GPU + CUDA 11.8+ (가속용)
nvidia-smi
```

### 옵션 1: pip 설치 (가장 빠름)

Demucs를 실행하는 가장 간단한 방법:

```bash
# 가상 환경 생성
python -m venv demucs-env
source demucs-env/bin/activate  # Linux/macOS
# demucs-env\Scripts\activate   # Windows

# Demucs 설치
pip install -U demucs

# 설치 확인
demucs --help
```

### 옵션 2: Conda + GPU 지원 (권장)

GPU 가속 추론 및 훈련을 위해:

```bash
# 저장소 클론
git clone https://github.com/adefossez/demucs.git
cd demucs

# 공식 명세로 환경 생성
conda env update -f environment-cuda.yml
conda activate demucs

# 개발 모드 설치
pip install -e .

# GPU 감지 확인
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"
```

### 옵션 3: Docker (가장 깔끔한 격리)

재현 가능한, 의존성 없는 배포를 위해:

```bash
# Dockerfile
FROM pytorch/pytorch:2.5.1-cuda12.4-cudnn9-runtime

RUN pip install -U demucs

WORKDIR /audio
ENTRYPOINT ["demucs"]
```

빌드 및 실행:

```bash
docker build -t demucs .
docker run --gpus all -v $(pwd):/audio demucs song.mp3
```

**Docker Compose (배치 서비스용):**

```yaml
version: '3.8'

services:
  demucs:
    build: .
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
    volumes:
      - ./input:/audio/input:ro
      - ./output:/audio/output
    command: ["-n", "htdemucs_ft", "--mp3", "-o", "/audio/output", "/audio/input"]
```

### 첫 번째 분리 실행

설치 후 첫 번째 트랙을 분리한다:

```bash
# 기본 모델로 4스템 분리
demucs song.mp3

# 출력 위치: ./separated/htdemucs/song/
# 포함: drums.wav, bass.wav, other.wav, vocals.wav

# 미세 조정 모델로 더 나은 품질
demucs -n htdemucs_ft song.mp3

# 보컬만 분리
demucs --two-stems=vocals song.mp3

# MP3로 출력 (더 작은 파일)
demucs --mp3 --mp3-bitrate 320 song.mp3
```

### 모델 다운로드 및 캐시 확인

모델은 처음 사용 시 자동으로 다운로드된다. 캐시를 확인하려면:

```bash
# 다운로드된 모델 목록
ls ~/.cache/torch/hub/checkpoints/

# 예상 출력:
# htdemucs-*.th, htdemucs_ft-*.th

# 어떤 모델이 사용될지 확인
demucs -n htdemucs_ft --help | grep "name"

# 짧은 오디오 파일로 빠른 테스트
ffmpeg -f lavfi -i "sine=frequency=1000:duration=5" test_tone.wav
demucs -n htdemucs test_tone.wav
```

## 인기 도구와의 통합

### Ultimate Vocal Remover (UVR)

Ultimate Vocal Remover는 Demucs의 가장 인기 있는 GUI 프론트엔드이다. 대부분의 프로듀서는 Demucs를 명령줄이 아닌 UVR을 통해 사용하는데, UVR은 Demucs 모델을 다른 아키텍처와 번들링하고 앙상블 처리를 추가하기 때문이다.

UVR에서의 구성:

1. [공식 GitHub Releases](https://github.com/Anjok07/ultimatevocalremovergui/releases)에서 UVR5 다운로드
2. UI에서 **Process Method: "Demucs"** 선택
3. 모델 선택: `V4 | htdemucs_ft`
4. 가능한 경우 **GPU Conversion** 활성화
5. 최상의 결과를 위해 **Ensemble Mode**에서 `htdemucs_ft` + `MDX-Net` 조합 사용

UVR의 앙상블 모드는 여러 모델을 병렬로 실행하고 출력을 혼합하며, 어떤 단일 모델보다 일관되게 더 깨끗한 분리 결과를 생성한다. 비용은 처리 시간이다 — 앙상블 실행은 단일 모델보다 대략 3–5배 느리다.

### RVC (Retrieval-based Voice Conversion)

RVC 파이프라인은 보이스 추출 전 보컬을 분리하는 전처리 단계로 일반적으로 Demucs를 사용한다:

```python
import subprocess
import os

def preprocess_for_rvc(input_song, output_dir):
    """RVC 보이스 컨버전을 위해 깨끗한 보컬 추출."""
    os.makedirs(output_dir, exist_ok=True)

    # 단계 1: Demucs로 분리
    subprocess.run([
        'demucs', '-n', 'htdemucs_ft',
        '--two-stems=vocals',
        '-o', output_dir,
        input_song
    ], check=True)

    # 단계 2: 분리된 보컬 경로 반환
    base = os.path.splitext(os.path.basename(input_song))[0]
    vocals_path = os.path.join(
        output_dir, 'htdemucs_ft', base, 'vocals.wav'
    )
    return vocals_path

# 사용
vocals = preprocess_for_rvc('input.mp3', './separated')
# 보컬을 RVC에 입력하여 보이스 컨버전 수행
```

### GPT-SoVITS

GPT-SoVITS 보이스 클로닝에는 깨끗한 레퍼런스 오디오가 필요하다. Demucs는 샘플을 TTS 파이프라인에 입력하기 전에 배경 음악을 제거한다:

```python
from demucs.api import Separator
import torchaudio

separator = Separator(model="htdemucs", device="cuda")

# 분리 및 보컬 추출
origin, separated = separator.separate_audio_file("reference.mp3")
vocals = separated["vocals"]

# GPT-SoVITS용 24kHz로 저장
torchaudio.save("clean_reference.wav", vocals, 24000)
```

### Gradio 웹 인터페이스

자체 호스팅 분리 서비스를 위해:

```python
import gradio as gr
from demucs.api import Separator

separator = Separator(model="htdemucs_ft")

def separate(audio_file, stem):
    origin, separated = separator.separate_audio_file(audio_file)
    output_path = f"{stem}.wav"
    separator.save_audio(separated[stem], output_path, samplerate=44100)
    return output_path

demo = gr.Interface(
    fn=separate,
    inputs=[
        gr.Audio(type="filepath", label="곡 업로드"),
        gr.Dropdown(
            choices=["vocals", "drums", "bass", "other"],
            value="vocals",
            label="스템"
        )
    ],
    outputs=gr.Audio(label="분리된 스템"),
    title="Demucs 소스 분리",
    description="Meta의 Demucs 모델로 음악을 스템으로 분리"
)

demo.launch(server_name="0.0.0.0", server_port=7860)
```

## 벤치마크 / 실제 사용 사례

### MUSDB18-HQ 벤치마크 결과

MUSDB18-HQ는 150개의 전체 길이 곡과 분리된 스템 정답을 포함하는 음악 소스 분리의 표준 벤치마크 데이터셋이다. 더 높은 SDR(신호 왜곡 비율)은 더 깨끗한 분리를 의미한다.

| 모델 | 전체 SDR | 보컬 | 드럼 | 베이스 | 기타 | 속도 (RTX 3090) |
|------|----------|------|------|--------|------|-----------------|
| **HTDemucs FT (v4)** | **7.8 dB** | **8.5 dB** | **8.9 dB** | **7.5 dB** | **6.2 dB** | ~4배 실시간 |
| HTDemucs (v4) | 7.1 dB | 7.8 dB | 8.2 dB | 6.9 dB | 5.6 dB | ~16배 실시간 |
| Hybrid Demucs (v3) | 7.7 dB | 8.1 dB | 8.5 dB | 7.2 dB | 5.9 dB | ~12배 실시간 |
| Spleeter 4stems | 5.9 dB | 6.3 dB | 6.8 dB | 5.4 dB | 4.2 dB | ~100배 실시간 |
| Open-Unmix | 5.3 dB | 6.2 dB | 5.9 dB | 4.7 dB | 4.2 dB | ~80배 실시간 |

### 프로덕션 사용 사례

**노래방 트랙 생성**: `--two-stems=vocals` 옵션은 drums + bass + other를 혼합하고 보컬 트랙을 버려서 인스트루멘탈을 생성한다. 4분짜리 곡을 GPU에서 30초 이내에 처리한다.

**프로듀서 샘플 추출**: 풀 믹스에서 드럼 브레이크, 베이스라인, 멜로딕 엘리먼트를 분리한다. `htdemucs_6s` 모델은 기타와 피아노 분리를 추가하지만, 이러한 스템의 품질은 주요 4스템보다 낮다.

**보이스 컨버전 전처리**: 깨끗한 보컬 추출은 RVC, GPT-SoVITS 등 보이스 클로닝 파이프라인의 필수 전제조건이다. Demucs는 일관되게 순수 스펙트럼 방식보다 적은 블리드를 생성한다.

**오디오 복원**: 기록 보관 전문가는 역사적 녹음을 분리하여 개별 스템에서 노이즈 감소를 수행한 뒤 재믹싱한다.

### 처리 시간 참고

44.1kHz 스테레오 4분 트랙 기준:

| 하드웨어 | htdemucs | htdemucs_ft | htdemucs_6s |
|----------|----------|-------------|-------------|
| RTX 4080 GPU | ~15초 | ~55초 | ~25초 |
| RTX 3080 GPU | ~20초 | ~75초 | ~35초 |
| Apple M3 (MPS) | ~45초 | ~3분 | ~70초 |
| Intel i7-13700 CPU | ~5분 | ~18분 | ~8분 |

## 고급 사용법 / 프로덕션 하드닝

### 커스텀 파이프라인을 위한 Python API

프로그래밍 제어를 위해 CLI를 우회하고 Python API를 직접 사용한다:

```python
import torch
import torchaudio
from demucs.pretrained import get_model
from demucs.apply import apply_model

# 모델 로드
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = get_model("htdemucs_ft")
model.to(device)
model.eval()

# 오디오 로드
wav, sr = torchaudio.load("input.mp3")

# 스테레오 확인
if wav.shape[0] == 1:
    wav = wav.repeat(2, 1)

# 배치 차원 추가
mix = wav.unsqueeze(0).to(device)

# 최적화된 설정으로 분리
with torch.no_grad():
    sources = apply_model(
        model,
        mix,
        shifts=1,       # Shift trick: 높을수록 품질 ↑, 속도 ↓
        split=True,     # 청크 단위 처리 (긴 오디오 필수)
        overlap=0.25,   # 청크 간 오버랩
        segment=10,     # 세그먼트 길이(초)
        progress=True,
        device=device
    )[0]

# sources 형태: (num_sources, channels, samples)
source_names = model.sources  # ['drums', 'bass', 'other', 'vocals']

# 개별 스템 저장
for i, name in enumerate(source_names):
    torchaudio.save(f"{name}.wav", sources[i].cpu(), sr)
```

### 배치 처리 파이프라인

```python
from pathlib import Path
import subprocess
import json

def batch_separate(input_dir, output_dir, model="htdemucs"):
    """디렉토리의 모든 오디오 파일 처리."""
    input_dir = Path(input_dir)
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    audio_exts = {'.mp3', '.wav', '.flac', '.ogg', '.m4a'}
    files = [f for f in input_dir.iterdir() if f.suffix in audio_exts]

    # 단일 Demucs 호출로 모든 파일 처리
    subprocess.run([
        'demucs', '-n', model,
        '-o', str(output_dir),
        '--mp3',
        '--mp3-bitrate', '320',
        *[str(f) for f in files]
    ], check=True)

    # 메타데이터 매니페스트 생성
    manifest = {}
    for f in files:
        base = f.stem
        stem_dir = output_dir / model / base
        manifest[base] = {
            'drums': str(stem_dir / 'drums.mp3'),
            'bass': str(stem_dir / 'bass.mp3'),
            'other': str(stem_dir / 'other.mp3'),
            'vocals': str(stem_dir / 'vocals.mp3'),
        }

    with open(output_dir / 'manifest.json', 'w') as fp:
        json.dump(manifest, fp, indent=2)

    return manifest

# 사용
batch_separate('./raw_songs/', './stems/', model='htdemucs_ft')
```

### 긴 파일의 메모리 최적화

Demucs는 전체 오디오 파일을 GPU 메모리에 로드한다. 긴 트랙이나 제한된 VRAM의 경우:

```python
# 대용량 파일을 위한 CPU 오프로드 강제
import os
os.environ['PYTORCH_CUDA_ALLOC_CONF'] = 'max_split_size_mb:128'

# 더 작은 세그먼트 사용
sources = apply_model(
    model,
    mix,
    split=True,
    segment=7,      # 기본 ~10초에서 7초로 감소
    overlap=0.1,    # 오버랩 감소
    device=device
)[0]
```

### 모니터링 및 로깅

```python
import logging
import time

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger('demucs')

def separate_with_metrics(input_path, output_dir):
    start = time.time()

    separator = Separator(model="htdemucs_ft", device="cuda")
    origin, separated = separator.separate_audio_file(input_path)

    duration = time.time() - start
    logger.info(f"{input_path} 분리 완료: {duration:.1f}초")

    # 스템별 레벨 로깅
    for name, audio in separated.items():
        rms = torch.sqrt(torch.mean(audio ** 2)).item()
        logger.info(f"  {name}: RMS={rms:.4f}")

    return separated
```

## 대안과의 비교

| 기능 | Demucs (v4) | Ultimate Vocal Remover | Spleeter | Open-Unmix |
|------|-------------|------------------------|----------|------------|
| **아키텍처** | 하이브리드 파형 + 스펙트럼 + Transformer | GUI 래퍼 (다중 백엔드) | 스펙트럼 U-Net | 스펙트럼 LSTM |
| **MUSDB SDR** | 7.8 dB (htdemucs_ft) | N/A (Demucs/MDX 사용) | 5.9 dB | 5.3 dB |
| **최대 스템 수** | 6 (보컬, 드럼, 베이스, 기타, 피아노, 기타) | 4 (모델에 따라 다름) | 5 (sides 포함) | 4 |
| **GPU 필요 여부** | 권장 | 권장 | 선택 | 선택 |
| **처리 속도** | ~4–16배 실시간 (GPU) | ~3–10배 실시간 (앙상블) | ~100배 실시간 | ~80배 실시간 |
| **VRAM 사용량** | 5–8 GB | 6–12 GB (앙상블) | <2 GB | <2 GB |
| **활발한 개발** | 커뮤니티 포크 | 활발 | 아카이브 (2021) | 유지보수 모드 |
| **라이선스** | MIT | MIT | MIT | MIT |
| **최적 사용처** | 품질 우선 분리 | 쉬운 GUI + 앙상블 | 빠른 배치 처리 | 경량 배포 |

**선택 가이드**: 최대 분리 품질이 필요하고 자동화된 파이프라인을 구축할 때는 Demucs를 직접 사용한다. GUI와 앙상블 처리를 원할 때는 UVR을 사용한다. 제한된 하드웨어에서 최대 속도가 필요하거나 레거시 코드를 유지할 때만 Spleeter를 사용한다. Open-Unmix는 교육 목적과 자원이 제한된 엣지 배포에 여전히 적합하다.

## 한계 / 정직한 평가

Demucs는 모든 오디오 작업에 적합한 도구가 아니다. 다음은 잘 수행하지 못하는 영역이다:

**실시간 분리**: 가장 빠른 Demucs 모델(`htdemucs`)도 RTX 4080에서 약 16배 실시간으로 처리한다. 이는 라이브 공연이나 실시간 스트리밍 애플리케이션에는 너무 느리다. Spleeter나 전문화된 ONNX 익스포트와 같은 지연 시간에 민감한 사용 사례에 더 적합하다.

**기타 및 피아노 분리**: `htdemucs_6s` 모델은 기타와 피아노를 별도의 스템으로 분리하려 시도하지만, 이러한 소스의 SDR은 주요 4스템보다 현저히 낮다. 특정 기타 트랙 분리가 주요 필요라면 Basic Pitch와 같은 전문화된 전사 도구가 더 적합할 수 있다.

**고도로 압축된 마스터링**: 무거운 리미팅이 적용된 음량 극대화 트랙(현대 EDM과 팝에서 흔함)은 주파수 마스킹을 생성하여 분리 모델을 혼란스럽게 한다. Demucs는 이러한 트랙에서 더 넓은 다이낙믹 믹스에서는 나타나지 않는 소용돌이 소리나 교차 소스 블리드와 같은 아티팩트를 생성할 수 있다.

**모델 크기**: `htdemucs_ft`는 ~2 GB로 Spleeter(~150 MB)보다 한 차례 더 크다. 이는 엣지 배포, 모바일 앱, 콜드 스타트 제약이 있는 서버리스 환경에서 중요한 요소이다.

**업스트림 아카이브**: 원본 `facebookresearch/demucs` 저장소는 아카이브되어 더 이상 유지되지 않는다. `adefossez/demucs`가 활발하지만 장기적인 유지보수 방향은 불확실하다. 이를 의존성 계획에 고려하라.

## 자주 묻는 질문

**Q: Demucs를 실행하려면 어떤 하드웨어가 필요한가?**
A: Demucs는 CPU에서 실행되지만 6GB 이상 VRAM의 NVIDIA GPU를 강력히 권장한다. `htdemucs` 모델에는 5.2GB VRAM이면 충분하고 `htdemucs_ft`에는 8GB가 필요하다. CPU 전용 처리는 가능하지만 4분짜리 곡을 처리하는 데 GPU의 5–20분이 소요된다.

**Q: Demucs를 상업적으로 사용할 수 있나?**
A: 예. Demucs는 MIT 라이선스로 상업적 사용, 수정, 배포를 제한 없이 허용한다. 분리된 스템은 상업적 릴리스에 사용할 수 있다. MIT 라이선스는 코드와 모델에 적용되며, 처리하는 음악의 저작권에는 적용되지 않는다.

**Q: 왜 Demucs가 Spleeter보다 더 좋게 들리나?**
A: Demucs는 시간 영역과 주파수 영역에서 동시에 오디오를 처리하여 순수 스펙트럼 방식이 버리는 위상 정보를 보존한다. 트랜스포머 레이어도 Spleeter의 U-Net보다 장거리 음악적 종속성을 더 잘 모델링한다. 이는 더 적은 아티팩트와 더 적은 교차 소스 간섭으로 이어진다.

**Q: 전체 앨범을 효율적으로 처리하려면?**
A: 여러 파일을 단일 Demucs 호출에 전달한다: `demucs -n htdemucs *.mp3`. Demucs는 순차적으로 처리하지만 반복적인 모델 로딩 오버헤드를 피한다. 최대 처리량을 위해 서로 다른 GPU에서 여러 Demucs 인스턴스를 실행하거나 고급 사용법 섹션의 배치 처리 스크립트를 사용한다.

**Q: Demucs는 어떤 오디오 형식을 지원하나?**
A: Demucs는 디코딩용 FFmpeg와 인코딩용 torchaudio를 사용한다. 입력: MP3, WAV, FLAC, OGG, M4A 및 FFmpeg가 지원하는 모든 형식. 출력: WAV(기본, 16비트), float32 WAV(`--float32`), 24비트 WAV(`--int24`) 또는 MP3(`--mp3`, 비트레이트 조절 가능).

**Q: 자체 데이터로 Demucs를 미세 조정할 수 있나?**
A: 예, 하지만 전체 훈련 파이프라인이 필요하다. 훈련 노래의 분리된 스템(MUSDB18-HQ와 동일한 형식)이 필요하며, Dora 실험 관리자를 사용하여 `dora run -d solver=htdemucs dset=your_dataset`를 실행한다. 대부분의 사용자는 이것이 필요 없다 — 사전 학습된 모델은 장르 간에 잘 일반화된다.

**Q: `htdemucs`와 `htdemucs_ft`의 차이는?**
A: `htdemucs_ft`는 추가 훈련 데이터로 소스별로 미세 조정되고 기본적으로 shift trick이 활성화되어 있다. 모든 소스에서 약 0.7 dB 더 높은 SDR을 달성하지만 약 4배 더 느리고 VRAM을 50% 더 사용한다. 빠른 반복에는 `htdemucs`를, 최종 프로덕션 품질 출력에는 `htdemucs_ft`를 사용한다.

## 결론

Demucs는 2026년 현재 오픈 소스 음악 소스 분리의 기준 구현체로 남아 있다. 하이브리드 트랜스포머 아키텍처는 표준 벤치마크에서 Spleeter보다 20–40% 높은 분리 품질을 제공하며, 보이스 컨버전 파이프라인, 노래방 생성기, 오디오 제작 도구와 깔끔하게 통합된다.

오디오 파이프라인을 구축하는 개발자에게 Demucs는 문서화된 Python API, Docker 지원, 다양한 속도/품질 트레이드오프를 위한 여러 모델 변형을 제공한다. MIT 라이선스는 상업적 마찰을 제거한다. 주의사항은 하드웨어 요구사항(GPU 강력 권장), 모델 크기(~2 GB), 업스트림 저장소의 아카이브 상태이다.

**실행 항목**: `pip install -U demucs`로 Demucs를 설치하고 `demucs -n htdemucs_ft song.mp3`로 테스트 트랙에서 첫 분리를 실행한 뒤, 위의 Python API 예제를 사용하여 파이프라인에 통합하라. GUI 환경을 원한다면 Ultimate Vocal Remover를 다운로드하여 앙상블 모드를 사용하라.

**dibi8.com Telegram 그룹에 가입하여 매주 오픈 소스 AI 도구 심층 분석을 받아보세요: [https://t.me/dibi8channel](https://t.me/dibi8channel)**



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 참고 및 추가 자료

- [Demucs GitHub 저장소 (Meta, 아카이브됨)](https://github.com/facebookresearch/demucs)
- [Demucs 활발한 포크 (adefossez)](https://github.com/adefossez/demucs)
- [Hybrid Transformers for Music Source Separation (논문)](https://arxiv.org/abs/2211.08553)
- [MUSDB18-HQ 벤치마크 데이터셋](https://zenodo.org/record/3338373)
- [Ultimate Vocal Remover GUI](https://github.com/Anjok07/ultimatevocalremovergui)
- [Spleeter (Deezer, 아카이브됨)](https://github.com/deezer/spleeter)
- [Open-Unmix (Sony)](https://github.com/sigsep/open-unmix-pytorch)
- [MVSEP 품질 체커 리더보드](https://mvsep.com/quality_checker/)
- [Audio Developers Conference 2025 — Demucs ONNX 익스포트 발표](https://mixxx.discourse.group/t/gsoc-2025-converting-demucs-v4-hybrid-transformer-ai-model-to-onnx-format/32874)
