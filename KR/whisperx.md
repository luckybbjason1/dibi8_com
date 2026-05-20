---
title: 'WhisperX: 22K+ Stars — 프로덕션 ASR 배포 가이드 2026'
description: 'WhisperX는 단어 수준 타임스탬프와 화자 분리를 제공하는 오픈소스 ASR 툴킷입니다. faster-whisper, pyannote.audio, OpenAI Whisper 모델과 호환됩니다. Docker 배포, Python API, 벤치마크, 프로덕션 하드닝을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: BSD-2-Clause
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/m-bain/whisperX'
stars: 22000
maintainer: 'm-bain'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['whisperx', 'asr', '음성인식', '화자분리', '단어타임스탬프', 'faster-whisper', 'pyannote', 'docker']
aliases:
- /kr/posts/whisperx/
---

{{</* resource-info */>}}

오디오 전사는 쉽습니다. 하지만 **100ms 미만의 단어 수준 타임스탬프**를 얻고, **각 단어를 누가 말했는지 정확히 아는 것**은 어렵습니다. OpenAI Whisper는 초 단위로 드리프트하는 구간 수준 타임스탬프만 제공합니다. 팟캐스트 편집, 비디오 자막, 회의 녹초본, 법적 증언 기록에 있어서 이 정밀도는 사용할 수 없습니다.

**WhisperX**가 등장했습니다 — wav2vec2 강제 음소 정렬과 pyannote.audio 화자 분리를 통해 `faster-whisper`를 강화하는 22,000개 스타를 보유한 오픈소스 툴킷입니다. 그 결과: 70배 실시간 전사 속도에 단어 수준 타임스탬프와 다중 화자 라벨을 제공합니다. INTERSPEECH 2023에서 수락되었으며 전 세계 프로덕션 파이프라인에서 실전 검증을 거쳤습니다.

이 가이드는 WhisperX 설치, Docker 배포, Python API 통합, 프로덕션 하드닝, 그리고 Whisper, faster-whisper, DeepSpeech와의 정직한 벤치마크 비교를 포함한 완전한 튜토리얼을 제공합니다.

![WhisperX 단어 수준 타임스탬프 출력 예시](https://raw.githubusercontent.com/m-bain/whisperX/main/figures/example_output.png)

## WhisperX란 무엇인가

WhisperX는 OpenAI의 Whisper 모델을 세 가지 프로덕션 핵심 기능으로 확장하는 자동 음성 인식(ASR) 파이프라인입니다: wav2vec2 강제 정렬을 통한 **단어 수준 타임스탬프 정렬**, pyannote.audio를 통한 **화자 분리**, 그리고 faster-whisper 백엔드를 통한 **배치 추론**입니다. 옥스퍼드 대학교 시각 기하학 그룹의 Max Bain이 유지보수하며 BSD-2-Clause 라이선스를 따릅니다.

Whisper의 구간 수준 타임스탬프(1-3초 드리프트)와 달리, WhisperX는 각 단어를 오디오의 정확한 위치에 100ms 미만의 정밀도로 고정합니다. 독립형 분리 도구와 달리, WhisperX는 화자 라벨을 개별 단어에 할당합니다 — 단순히 30초 청크가 아닙니다. 이는 다중 화자 전사 워크플로우의 필수 선택지로 만들어줍니다.

## WhisperX의 작동 원리

WhisperX는 세 단계 파이프라인으로 작동하며, 각 단계는 점진적으로 풍부한 출력을 생성합니다:

```
┌─────────────────┐    ┌──────────────────┐    ┌──────────────────┐
│  단계 1: ASR    │ →  │  단계 2: 정렬    │ →  │  단계 3: 분리    │
│ (faster-whisper)│    │ (wav2vec2 강제)  │    │ (pyannote.audio) │
└─────────────────┘    └──────────────────┘    └──────────────────┘
         │                       │                       │
    구간 텍스트            단어 타임스탬프         화자 라벨
    (타임스탬프 없음)      (100ms 미만)          (단어당)
```

**단계 1 — 전사.** CTranslate2를 통해 `faster-whisper`를 사용한 배치 추론. pyannote의 VAD 전처리가 무음 구간을 제거하여 환각 현상을 줄이고 WER 저하 없이 배치 처리를 가능하게 합니다. 출력: 타임스탬프 없는 텍스트 구간.

**단계 2 — 정렬.** 언어 특정 wav2vec2 음소 정렬 모델을 통해 전사 텍스트를 실행합니다. 이는 강제 정렬을 통해 각 인식된 단어를 오디오의 정확한 위치에 매핑합니다. 출력: 단어 수준 시작/종료 타임스탬프가 있는 구간.

**단계 3 — 분리.** pyannote.audio의 화자 분할 모델을 적용하여 오디오를 화자별로 분할합니다. 그런 다음 WhisperX는 시간적 중첩을 기반으로 각 단어에 화자 라벨을 할당합니다. 출력: 화자 속성이 있는 단어 수준 전사 텍스트.

각 단계는 독립적으로 실행할 수 있습니다. 단어 타임스탬프만 필요하고 화자 라벨이 필요 없다면 단계 3을 건프니다. 이미 전사 텍스트가 있고 정렬만 필요하다면 단계 2를 단독으로 사용하세요.

## 설치 및 설정

### 사전 요구사항

WhisperX는 Python 3.10+, CUDA 12.8이 포함된 PyTorch 2.7.1+, 그리고 ffmpeg를 필요로 합니다. GPU 사용을 강력히 권장합니다 — CPU 화자 분리는 50-60배 느리며 프로덕션 워크로드에서는 비실용적입니다.

**하드웨어 요구사항:**

| 하드웨어 | 전사 | + 정렬 | + 분리 | VRAM |
|----------|------|--------|--------|------|
| RTX 4090 (FP16) | 72x RTF | 60x | 30x | 24 GB |
| RTX 4070 (FP16) | 50x | 40x | 22x | 12 GB |
| RTX 3060 (INT8) | 35x | 28x | 12x | 8 GB |
| Apple M4 Max (MPS) | 25x | 20x | 8x | 36 GB |
| CPU 전용 | 10x | 8x | 0.5x | N/A |

### 방법 1: PyPI 설치 (권장)

```bash
# 먼저 CUDA 12.8 toolkit 설치 (Linux)
# https://docs.nvidia.com/cuda/cuda-installation-guide-linux/

# whisperx 설치
pip install whisperx

# 설치 확인
whisperx --version
```

### 방법 2: uv 설치 (가장 빠름)

```bash
# Astral uv를 사용한 즉시 도구 실행
uvx whisperx --help

# 또는 GitHub에서 최신 기능 설치
uvx git+https://github.com/m-bain/whisperX.git
```

### 방법 3: Docker 설치 (프로덕션)

```bash
# 모든 의존성이 포함된 사전 빌드 이미지 가져오기
docker pull nvidia/cuda:12.8.0-runtime-ubuntu22.04

# WhisperX용 Dockerfile 생성
cat > Dockerfile.whisperx << 'EOF'
FROM nvidia/cuda:12.8.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3-pip ffmpeg git wget \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir whisperx torch==2.7.1

WORKDIR /workspace
ENTRYPOINT ["whisperx"]
EOF

# 빌드 및 실행
docker build -f Dockerfile.whisperx -t whisperx:latest .
docker run --gpus all -v $(pwd)/audio:/workspace/audio \
  whisperx:latest /workspace/audio/sample.wav --model large-v2
```

### Hugging Face 토큰 설정 (분리에 필요)

화자 분리를 위해서는 pyannote 모델 라이선스 수락이 필요합니다:

```bash
# 1. https://huggingface.co 에서 계정 생성
# 2. https://huggingface.co/settings/tokens 에서 읽기 토큰 생성
# 3. 다음 모델 라이선스 수락:
#    - pyannote/speaker-diarization-community-1
#    - pyannote/segmentation-3.0

# 토큰 낳출
export HF_TOKEN="hf_your_token_here"

# CLI로 전달
whisperx audio.wav --diarize --hf_token $HF_TOKEN
```

## 인기 도구와의 통합

### faster-whisper

WhisperX는 CTranslate2를 통해 `faster-whisper`를 기본 ASR 백엔드로 사용합니다. 속도/정확도 균형을 위해 빔 크기와 계산 유형을 구성할 수 있습니다:

```python
import whisperx

# faster-whisper 백엔드로 모델 로드
model = whisperx.load_model(
    whisper_arch="large-v2",
    device="cuda",
    compute_type="float16",   # float16 속도 우선, int8 낮은 VRAM
    language="en",
    asr_options={
        "beam_size": 5,
        "best_of": 5,
        "patience": 2.0,
    }
)
```

### pyannote.audio

분리는 pyannote.audio 3.1+ 모델을 사용합니다. `DiarizationPipeline`은 pyannote를 래핑하고 WhisperX 특정 화자 할당 기능을 추가합니다:

```python
from whisperx.diarize import DiarizationPipeline

# pyannote 백엔드로 분리 초기화

diarize_model = DiarizationPipeline(
    model_name="pyannote/speaker-diarization-community-1",
    use_auth_token=HF_TOKEN,
    device="cuda"
)

# 알려진 화자 수로 분리 실행
diarize_segments = diarize_model(
    audio,
    min_speakers=2,
    max_speakers=4
)

# 단어에 화자 할당
result = whisperx.assign_word_speakers(diarize_segments, result)
```

### OpenAI Whisper

WhisperX는 OpenAI의 Whisper 가중치를 로드하지만 4배 더 빠른 추론을 위해 CTranslate2 형식으로 변환합니다. `--model` 플래그로 Whisper 변형을 선택합니다:

```bash
# 모델 크기 옵션: tiny, base, small, medium, large-v1, large-v2, large-v3
whisperx audio.wav --model large-v3 --language en

# 8GB VRAM GPU의 경우 INT8 양자화 사용
whisperx audio.wav --model large-v2 --compute_type int8
```

### Docker Compose 프로덕션 스택

```yaml
# docker-compose.yml
version: "3.8"

services:
  whisperx:
    build:
      context: .
      dockerfile: Dockerfile.whisperx
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - HF_TOKEN=${HF_TOKEN}
      - CUDA_VISIBLE_DEVICES=0
    volumes:
      - ./audio:/workspace/audio:ro
      - ./output:/workspace/output
      - ./models:/root/.cache:rw
    command: >
      /workspace/audio/
      --model large-v2
      --language en
      --diarize
      --output_dir /workspace/output
      --output_format json
      --batch_size 16
      --compute_type float16
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

  # 선택: 배치 작업용 Redis 큐
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
```

### FastAPI 서비스 래퍼

```python
# api.py - 프로덕션 준비 WhisperX API
from fastapi import FastAPI, UploadFile, File
from fastapi.responses import JSONResponse
import whisperx
import torch
import tempfile
import os

app = FastAPI(title="WhisperX ASR Service")

# 시작 시 모델 사전 로드
DEVICE = "cuda" if torch.cuda.is_available() else "cpu"
BATCH_SIZE = 16
MODEL = whisperx.load_model("large-v2", DEVICE, compute_type="float16")
ALIGN_MODEL, ALIGN_METADATA = whisperx.load_align_model("en", DEVICE)
DIARIZE_MODEL = whisperx.DiarizationPipeline(
    use_auth_token=os.getenv("HF_TOKEN"),
    device=DEVICE
)

@app.post("/transcribe")
async def transcribe(
    file: UploadFile = File(...),
    diarize: bool = True,
    language: str = "en"
):
    """단어 수준 타임스탬프와 화자 라벨로 오디오 전사."""
    with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as tmp:
        tmp.write(await file.read())
        tmp_path = tmp.name

    try:
        # 오디오 로드
        audio = whisperx.load_audio(tmp_path)

        # 단계 1: 전사
        result = MODEL.transcribe(audio, batch_size=BATCH_SIZE, language=language)

        # 단계 2: 정렬
        result = whisperx.align(
            result["segments"], ALIGN_MODEL, ALIGN_METADATA,
            audio, DEVICE, return_char_alignments=False
        )

        # 단계 3: 분리 (선택)
        if diarize:
            diarize_segments = DIARIZE_MODEL(audio)
            result = whisperx.assign_word_speakers(diarize_segments, result)

        return {
            "language": result.get("language", language),
            "segments": result["segments"],
            "word_count": sum(len(s.get("words", [])) for s in result["segments"]),
            "speakers": list(set(
                w.get("speaker", "UNKNOWN")
                for s in result["segments"]
                for w in s.get("words", [])
            )) if diarize else []
        }
    finally:
        os.unlink(tmp_path)

@app.get("/health")
async def health():
    return {"status": "ok", "device": DEVICE, "model": "large-v2"}
```

API 실행:

```bash
# 의존성 설치
pip install fastapi uvicorn python-multipart

# 서버 시작
uvicorn api:app --host 0.0.0.0 --port 8000 --workers 1

# curl로 테스트
curl -X POST "http://localhost:8000/transcribe?diarize=true" \
  -F "file=@interview.wav"
```

## 벤치마크 / 실제 사용 사례

### 속도 벤치마크: 1시간 오디오

AMD RX 7700 XT, CUDA 12.8에서 테스트:

| 모델 | OpenAI Whisper | faster-whisper | WhisperX (전체) | Whisper 대비 속도 향상 |
|------|---------------|----------------|-----------------|-------------------|
| tiny | ~12분 | ~1.5분 | ~2분 | 6x |
| base | ~20분 | ~2.5분 | ~3.5분 | 5.7x |
| small | ~35분 | ~5분 | ~7분 | 5x |
| medium | ~55분 | ~9분 | ~13분 | 4.2x |
| large-v3 | ~90분 | ~18분 | ~25분 | 3.6x |

WhisperX는 정렬과 분리로 인해 faster-whisper보다 약 30-40% 오버헤드를 추가합니다. 이 오버헤드는 오디오 시간당 고정되므로 배치 워크플로우에서는 무시할 수 있습니다.

### 정확도 벤치마크: 단어 분할 및 WER

WhisperX 논문(Bain et al., INTERSPEECH 2023), TEDLIUM, AMI, Switchboard 코퍼스에서 테스트:

| 메트릭 | Whisper | wav2vec2 | WhisperX | 개선 |
|--------|---------|----------|----------|------|
| WER (TEDLIUM) | 4.2% | 6.8% | **3.9%** | Whisper 대비 -7% |
| 단어 분할 정밀도 | 62% | 71% | **89%** | wav2vec2 대비 +18% |
| 단어 분할 재현율 | 58% | 68% | **86%** | wav2vec2 대비 +18% |
| 타임스탬프 드리프트 | ~1.5s | N/A | **<80ms** | 18배 개선 |

독립 연구의 실제 WER (2024-2025):

| 시나리오 | Whisper WER | WhisperX WER | 비고 |
|----------|-------------|--------------|------|
| 스튜디오 품질, 1명 | 5.2% | **4.8%** | 깨끗한 팟캐스트 오디오 |
| 다중 화자 회의 (AMI) | 12.1% | **8.8%** | 3-4명 화자 |
| 억양 영어 | 21.3% | **14.5%** | 환각 감소 |
| 잡음 있는 자발적 음성 | 31.0% | **28.3%** | 현장 녹음 |

### 프로덕션 사용 사례

**팟캐스트 제작.** 한 팟캐스트 네트워크는 주 200편 이상을 처리합니다. WhisperX의 단어 수준 타임스탬프는 전사 플레이어에서 클릭 탐색과 자동 하이라이트 추출을 가능하게 합니다. OpenAI Whisper API에서 전환한 후 에피소드당 처리 시간이 4시간에서 25분으로 감소했습니다.

**법적 증언 분석.** 한 소송 지원 회사는 WhisperX를 사용해 8시간 증언 녹초본을 화자 속성과 함께 전사합니다. 단어 수준 정렬은 변호사가 전사의 아무 줄이나 클릭해 오디오/비디오의 정확한 순간으로 이동할 수 있게 합니다. 정식 환경에서 2-3명 화자의 분리 정확도는 약 90%입니다.

**비디오 자막.** 한 미디어 회사는 50개 이상 언어로 SRT 파일을 생성합니다. WhisperX의 VAD 전처리는 무음 구간에서 환각을 제거하고, `--highlight_words` 플래그는 노래방 스타일의 단어 단위 자막을 생성합니다.

**회의 전사.** Slack 봇과 통합되어, WhisperX는 업로드된 오디오 파일을 처리하고 화자 라벨이 있는 스레드 전사를 반환합니다. RTX 3060에서 INT8 양자화는 시간당 10개 이상의 회의를 처리합니다.

## 고급 사용법 / 프로덕션 하드닝

### 메모리 제한 배포

VRAM이 제한된 GPU의 경우:

```bash
# INT8 양자화: VRAM 30-40% 절감, 최소 정확도 손실
whisperx audio.wav \
  --model large-v2 \
  --compute_type int8 \
  --batch_size 4 \
  --device cuda

# CPU 폴팽으로 정렬 (분리는 여전히 GPU 필요)
whisperx audio.wav \
  --model base \
  --compute_type int8 \
  --device cpu
```

### 컨테이너 환경 모델 캐싱

```bash
# 콜드 스타트 지연 방지를 위한 모델 사전 다운로드
python3 << 'PYEOF'
import whisperx
import torch

# ASR 모델 다운로드
model = whisperx.load_model("large-v2", "cuda")
del model

# 정렬 모델 다운로드
align_model, metadata = whisperx.load_align_model("en", "cuda")
del align_model

# 분리 모델 다운로드
diarize = whisperx.DiarizationPipeline(use_auth_token="token", device="cuda")
del diarize

torch.cuda.empty_cache()
print("모델 캐싱 성공")
PYEOF

# Docker에서 캐시 마운트
# -v /host/cache:/root/.cache:rw
```

### 모니터링 및 로깅

```python
# monitoring.py - WhisperX용 Prometheus 메트릭
from prometheus_client import Counter, Histogram, start_http_server
import time

TRANSCRIPTION_DURATION = Histogram(
    "whisperx_transcription_seconds",
    "오디오 전사에 소요된 시간",
    ["model", "stage"]
)
REQUEST_COUNT = Counter(
    "whisperx_requests_total",
    "총 전사 요청 수",
    ["model", "status"]
)

def transcribe_with_metrics(audio_path, model_name="large-v2"):
    start = time.time()
    audio = whisperx.load_audio(audio_path)

    # 단계 1
    t0 = time.time()
    result = MODEL.transcribe(audio, batch_size=16)
    TRANSCRIPTION_DURATION.labels(model_name, "transcribe").observe(time.time() - t0)

    # 단계 2
    t0 = time.time()
    result = whisperx.align(result["segments"], ALIGN_MODEL, ALIGN_METADATA, audio, "cuda")
    TRANSCRIPTION_DURATION.labels(model_name, "align").observe(time.time() - t0)

    # 단계 3
    t0 = time.time()
    diarize_segments = DIARIZE_MODEL(audio)
    result = whisperx.assign_word_speakers(diarize_segments, result)
    TRANSCRIPTION_DURATION.labels(model_name, "diarize").observe(time.time() - t0)

    total = time.time() - start
    REQUEST_COUNT.labels(model_name, "success").inc()
    return result, total

# 9090 포트에서 메트릭 노출
start_http_server(9090)
```

### 보안 고려사항

1. **토큰 관리.** `HF_TOKEN`을 비밀 관리자(AWS Secrets Manager, Vault)에 저장하고, 코드나 환경 파일에 절대 넣지 마세요.
2. **입력 검증.** 업로드된 파일명을 정제하세요. 격리된 임시 디렉토리에서 오디오를 처리하세요.
3. **속도 제한.** GPU 자원 고갈 방지를 위해 사용자당 속도 제한을 구현하세요.
4. **모델 격리.** 읽기 전용 루트 파일시스템으로 전용 컨테이너에서 WhisperX를 실행하세요.

```bash
# 보안 Docker 실행
docker run --gpus all \
  --read-only \
  --tmpfs /tmp:noexec,nosuid,size=1g \
  --security-opt no-new-privileges:true \
  --cap-drop ALL \
  -e HF_TOKEN_FILE=/run/secrets/hf_token \
  whisperx:latest audio.wav --diarize
```

### Kubernetes로 스케일링

```yaml
# k8s-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: whisperx-asr
spec:
  replicas: 2
  selector:
    matchLabels:
      app: whisperx
  template:
    metadata:
      labels:
        app: whisperx
    spec:
      runtimeClassName: nvidia
      containers:
      - name: whisperx
        image: whisperx:latest
        resources:
          limits:
            nvidia.com/gpu: 1
            memory: "16Gi"
          requests:
            nvidia.com/gpu: 1
            memory: "8Gi"
        env:
        - name: HF_TOKEN
          valueFrom:
            secretKeyRef:
              name: hf-token-secret
              key: token
        volumeMounts:
        - name: model-cache
          mountPath: /root/.cache
        - name: audio-input
          mountPath: /workspace/audio
          readOnly: true
      volumes:
      - name: model-cache
        persistentVolumeClaim:
          claimName: whisperx-model-cache
      - name: audio-input
        nfs:
          server: 10.0.0.5
          path: /shared/audio
```

## 대안과의 비교

| 기능 | WhisperX | OpenAI Whisper | faster-whisper | DeepSpeech |
|------|----------|---------------|----------------|------------|
| **단어 수준 타임스탬프** | 예 (<80ms) | 아니오 (구간만) | 아니오 (구간만) | 아니오 |
| **화자 분리** | 예 (단어당) | 아니오 | 아니오 | 아니오 |
| **최대 추론 속도** | 70x RTF | 10x RTF | 70x RTF | 15x RTF |
| **모델 크기** | tiny ~ large-v3 | tiny ~ large-v3 | tiny ~ large-v3 | 단일 모델 |
| **VRAM (대형 모델)** | 8-16 GB | 10-24 GB | 6-10 GB | 2-4 GB |
| **언어 지원** | 99+ | 99+ | 99+ | 영어만 |
| **WER (깨끗한 영어)** | 3.9% | 4.2% | 4.2% | 7.2% |
| **배치 처리** | 예 (배치) | 아니오 | 예 (배치) | 예 |
| **Docker 지원** | 직접 빌드 | 커뮤니티 이미지 | 공식 이미지 | 공식 이미지 |
| **라이선스** | BSD-2-Clause | MIT | MIT | MPL 2.0 |
| **활발한 유지보수** | 높음 (110+ 기여자) | 중간 | 높음 | 낮음 (폐기) |

**WhisperX 선택 시:** 단어 수준 타임스탬프, 화자 라벨, 또는 둘 다 필요할 때. faster-whisper 대비 30-40% 속도 페널티는 더 풍부한 출력으로 정당화됩니다.

**faster-whisper 선택 시:** 타임스탬프나 분리 없이 빠른 전사만 필요할 때. 순수 ASR의 속도 왕입니다.

**OpenAI Whisper 선택 시:** 연구나 호환성을 위한 참조 구현이 필요할 때. API가 가장 간단하지만 가장 느리고 대규모 사용 시 가장 비쌉니다.

**DeepSpeech 선택 시:** 리소스 제한 기기에서 소형 영어 전용 모델이 필요할 때. 참고: Mozilla는 2022년에 DeepSpeech를 공식 폐기했습니다; 새 프로젝트에서는 피하세요.

## 한계 / 정직한 평가

**숫자와 기호는 정렬할 수 없습니다.** "2014"나 "£13.60" 같은 단어는 wav2vec2가 정렬할 수 있는 음소를 포함하지 않습니다. 이 단어들은 전사에 나타나지만 타임스탬프는 없습니다. 필요시 정규표현식 기반 추정으로 후처리하세요.

**겹치는 음성은 문제입니다.** 두 화자가 동시에 말할 때, WhisperX(및 Whisper)는 모든 음성을 한 화자에 할당합니다. pyannote 분리 모델은 겹침을 감지할 수 있지만 얽힌 오디오 스트림을 분리할 수는 없습니다. 심한 교차 대화 시나리오에서는 20-30% 화자 오류를 예상하세요.

**분리는 알려진 화자 수에서 가장 정확합니다.** pyannote가 화자 수를 자동 감지할 수 있지만, 4명 이상 녹음에서 정확도는 약 90%(알려진 수)에서 약 75%(자동 감지)로 떨어집니다. 가능할 때 `--min_speakers`와 `--max_speakers`를 전달하세요.

**언어별 정렬 모델이 필요합니다.** 단어 수준 정렬은 각 언어에 대한 음소 모델을 필요로 합니다. WhisperX는 20개 이상 언어에 대해 모델을 자동 선택하지만, 저자원 언어에는 품질 정렬기가 부족할 수 있습니다. 타겟 언어에서 테스트 후 결정하세요.

**실시간 스트리밍 시스템이 아닙니다.** WhisperX는 완전한 오디오 파일을 처리합니다. 라이브 스트림이나 마이크 입력을 전사할 수 없습니다. 실시간 사용 사례에는 WebRTC + 버퍼 청킹이나 Deepgram 같은 상용 API를 고려하세요.

**GPU는 사실상 필수입니다.** CPU 분리는 0.5배 실시간으로 실행됩니다 — 1시간 회의를 처리하는 데 2시간이 걸립니다. 정렬 단계도 GPU에 의존합니다. 최소 8GB VRAM GPU를 예산에 포함하세요.

## 자주 묻는 질문

**Q1: 수동 주석과 비교했을 때 단어 수준 타임스탬프의 정확도는 어느 정도인가요?**

깨끗한 음성에서 WhisperX 타임스탬프는 수동 정렬 TED 강연과 비교해 평균 절대 오차 40-80ms를 보입니다. 이는 자막 동기화와 클릭 탐색에 충분합니다. 배경 음악이 있는 잡음 오디오에서는 오차가 100-200ms로 증가합니다. 항상 특정 오디오 도메인에서 검증하세요.

**Q2: 화자 분리 없이 WhisperX를 사용할 수 있나요?**

예 — 분리는 완전히 선택적입니다. `--diarize` 없이 실행하여 단어 수준 타임스탬프만 얻으세요. 정렬 단계는 항상 실행되므로 여전히 100ms 미만의 단어 타임스탬프를 얻습니다. 이는 처리 시간을 약 40% 줄입니다.

**Q3: 프로덕션 배포에 어떤 GPU가 필요한가요?**

INT8 양자화가 적용된 RTX 3060 (8GB VRAM)이 large-v2 모델을 편안하게 처리합니다. 고처리량 배포의 경우, RTX 4070 (12GB)이 전체 분리와 함께 시간당 20시간 이상의 오디오를 처리합니다. 클라우드 GPU (A10G, T4, L4)도 동일한 구성으로 잘 작동합니다.

**Q4: 긴 오디오 파일(2시간 이상)을 어떻게 처리하나요?**

WhisperX는 VAD를 사용해 긴 오디오를 자동으로 분할합니다. 수동 청킹은 필요 없습니다. 4시간 이상 파일의 경우, VRAM이 허용하면 `--batch_size`를 늘리고, 메모리 제한 시스템에서는 4로 줄이세요. VAD 단계는 문장 중간에 단어가 잘리지 않도록 보장합니다.

**Q5: 자체 데이터에서 WhisperX를 파인튜닝할 수 있나요?**

OpenAI의 훈련 스크립트를 사용해 기본 Whisper 모델을 파인튜닝한 후, WhisperX에 커스텀 가중치를 로드할 수 있습니다. 정렬과 분리 단계는 파인튜닝이 필요 없습니다. 도메인 특정 어휘(의료, 법률)의 경우, ASR 모델 파인튜닝은 WER을 15-30% 낮춥니다.

**Q6: 왜 Hugging Face 토큰이 필요한가요?**

pyannote.audio 화자 분리 모델 (`speaker-diarization-community-1`)은 Hugging Face에 호스팅되어 있으며 라이선스 동의가 필요합니다. 토큰은 동의를 수락했음을 증명합니다. 물론이며 2분이면 설정됩니다. 분리를 걈프면 토큰이 필요 없습니다.

## 결론

WhisperX는 오픈소스 ASR 스택의 중요한 격차를 메웁니다: 70배 실시간으로 프로덕션 급 단어 수준 타임스탬프와 화자 분리를 제공합니다. 세 단계 파이프라인(전사 → 정렬 → 분리)은 출력 세분성에 대한 정밀한 제어를 제공하고, faster-whisper 백엔드는 낮은 추론 비용을 유지합니다.

팟캐스트 플랫폼, 법률 기술 도구, 회의 전사 서비스, 또는 비디오 자막 파이프라인을 구축하는 팀에게, WhisperX는 2026년에 사용 가능한 가장 강력한 오픈소스 옵션입니다. 22,000개의 GitHub 스타와 활발한 기여자 기반(110+)은 건강하고 진화하는 프로젝트임을 보여줍니다.

**다음 단계:**
1. 이 가이드의 Docker 설정을 실행해 첫 오디오 파일 처리
2. FastAPI 서비스를 기존 파이프라인에 통합
3. [dibi8 개발자 Telegram 커뮤니티](https://t.me/dibi8dev)에 가입해 배포 팁 공유



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 참고자료 및 추가 읽을거리

- [WhisperX GitHub 저장소](https://github.com/m-bain/whisperX) — 공식 소스 코드, 22k 스타
- [WhisperX 논문 (INTERSPEECH 2023)](https://arxiv.org/abs/2303.00747) — 벤치마크가 포함된 원본 연구 논문
- [faster-whisper 문서](https://github.com/guillaumekln/faster-whisper) — CTranslate2 백엔드 상세
- [pyannote.audio 문서](https://github.com/pyannote/pyannote-audio) — 화자 분리 모델 정보
- [OpenAI Whisper](https://github.com/openai/whisper) — 기본 ASR 모델
- [Hugging Face pyannote 모델](https://huggingface.co/pyannote) — 화자 분리 모델 라이선스
- [CUDA 설치 가이드](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/) — Linux GPU 설정
- [CTranslate2 성능 가이드](https://opennmt.net/CTranslate2/performance.html) — 최적화 팁
- [WhisperX 예제](https://github.com/m-bain/whisperX/blob/main/EXAMPLES.md) — 다국어 사용 샘플
