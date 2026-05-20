---
title: 'OpenAI Whisper: 99.8K+ Stars — 완전한 ASR 설정 튜토리얼 vs WhisperX, faster-whisper 2026'
description: 'OpenAI Whisper (ASR) 대규모 약한 감독 기반의 강건한 음성 인식. WhisperX, faster-whisper, LibreTranslate와 호환. whisper 튜토리얼, whisper vs whisperx, 음성 인식 설정, whisper python, whisper docker 다룸.'
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
tags: ['whisper', '음성-인식', 'ASR', 'openai', 'faster-whisper', 'whisperx', 'python', 'docker', '머신러닝']
aliases:
- /kr/posts/openai-whisper/
---

{{</* resource-info */>}}

## 소개

음성 인식은 인간의 대화와 기계가 읽을 수 있는 데이터 사이의 다리이지만, 대부분의 개발자는 분당 과금되고, 도메인 전문 용어를 놓치며, 억양이 있는 음성에서 완전히 실패하는 API와 싸워본 경험이 있다. 2022년 말, OpenAI는 Whisper를 MIT 라이선스의 오픈소스 대안으로 공개했고, 도입은 즉각적이었다 — 99,800개의 GitHub star를 기록한 지금, Whisper는 프로덕션에서 가장 널리 채택된 오픈소스 ASR 시스템이다. 이 가이드는 완전한 Whisper 설정을 안내하고, WhisperX, faster-whisper, DeepSpeech와 비교하며, 오늘 바로 배포할 수 있는 프로덕션용 구성을 제공한다.

## OpenAI Whisper란?

OpenAI Whisper는 68만 시간의 다국어 다중 작업 감독 데이터로 학습된 범용 자동 음성 인식(ASR) 모델이다. 99개 언어에 대해 음성-텍스트 변환, 영어로의 음성 번역, 구어 언어 식별, 타임스탬프가 있는 세그먼트 정렬을 수행한다. 클라우드 전용 API와 달리 Whisper는 완전히 오프라인으로 소비자용 하드웨어에서 실행되어, 의료, 미디어, 콜센터, 접근성 도구의 전사 파이프라인의 핵심이 되었다.

## Whisper의 작동 원리

Whisper는 인코더-디코더 Transformer 아키텍처를 따른다. 오디오 입력은 로그-멜 스펙트로그램으로 변환된 후 인코더를 통과한다. 디코더는 자동 회귀적으로 텍스트 토큰을 예측하며, 전사, 번역, 언어 감지 여부를 알려주는 특수 작업 토큰을 조건으로 사용한다.

![Whisper 아키텍처 다이어그램](https://raw.githubusercontent.com/openai/whisper/main/approach.png)

**핵심 설계 결정:**

- **대규모 약한 감독**: 작고 정제된 데이터셋이 아닌, 노이즈가 있는 레이블의 다양한 웹 규모 오디오로 학습
- **다중 작업 학습**: 단일 모델이 작업 토큰을 통해 전사, 번역, 언어 식별을 처리
- **청크 기반 처리**: 긴 오디오를 30초 세그먼트로 분할하여 독립적으로 처리 후 재조립
- **이전 텍스트 조건화**: 디코더가 이전 세그먼트 토큰을 받아 경계 간 일관된 서식 유지

| 모델 | 파라미터 | 영어 WER | 다국어 WER | VRAM (GPU) | 상대 속도 |
|------|----------|----------|------------|------------|-----------|
| tiny  | 39M     | ~7.6%    | ~12%      | ~1 GB      | ~10x      |
| base  | 74M     | ~5.0%    | ~10%      | ~1 GB      | ~7x       |
| small | 244M    | ~3.4%    | ~7%       | ~2 GB      | ~4x       |
| medium| 769M    | ~2.9%    | ~5%       | ~5 GB      | ~2x       |
| large-v3 | 1.55B | ~2.4%   | ~3.5%     | ~10 GB     | 1x        |
| turbo | 809M    | ~2.5%    | ~3.7%     | ~6 GB      | ~8x       |

## 설치 및 설정

### Python 설치

```bash
python -m venv whisper-env
source whisper-env/bin/activate  # Linux/macOS
# whisper-env\Scripts\activate  # Windows

# OpenAI Whisper 설치
pip install -U openai-whisper

# 설치 확인
whisper --version
```

### 시스템 의존성

FFmpeg는 오디오 전처리에 필수적이다:

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install ffmpeg

# macOS
brew install ffmpeg

# 확인
ffmpeg -version | head -1
```

### GPU 가속 (CUDA)

```bash
# CUDA 가용성 확인
python -c "import torch; print(torch.cuda.is_available())"

# CUDA 12 지원 설치
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# CPU 전용 추론
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu
```

### Docker 배포

```bash
# 공식 이미지 가져오기 및 실행
docker pull openai/whisper:latest

# Docker를 통한 파일 전사
docker run --rm \
  --gpus all \
  -v $(pwd)/audio:/audio \
  openai/whisper:latest \
  /audio/interview.mp3 \
  --model large-v3 \
  --language en \
  --output_format json

# CPU 전용 Docker 실행
docker run --rm \
  -v $(pwd)/audio:/audio \
  openai/whisper:latest \
  /audio/podcast.mp3 \
  --model base \
  --device cpu
```

### 첫 번째 빠른 전사

```python
import whisper

# 모델 로드 (첫 실행 시 다운로드)
model = whisper.load_model("base")

# 오디오 파일 전사
result = model.transcribe("audio.mp3")
print(result["text"])

# 타임스탬프가 있는 세그먼트 가져오기
for segment in result["segments"]:
    print(f"[{segment['start']:.2f}s -> {segment['end']:.2f}s] {segment['text']}")
```

### CLI 사용 예시

```bash
# 기본 전사
whisper audio.mp3 --model medium --language en

# 모든 형식 출력 (JSON, SRT, VTT, TXT)
whisper podcast.mp3 --model large-v3 --output_format all

# 비영어 오디오를 영어 텍스트로 번역
whisper french_interview.mp3 --model large-v3 --task translate

# 언어 자동 감지
whisper unknown.mp3 --model base --task transcribe
```

## 인기 도구와의 통합

### WhisperX (단어 수준 타임스탬프 + 화자 분리)

WhisperX는 faster-whisper를 감싸며 음소 수준 정렬과 화자 분리 기능을 추가한다. 회의 기록과 인터뷰 처리에 최적의 도구이다.

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

# 1. faster-whisper 백엔드로 전사
model = whisperx.load_model("large-v3", device, compute_type=compute_type)
audio = whisperx.load_audio(audio_file)
result = model.transcribe(audio, batch_size=batch_size)

# 2. 정확한 단어 수준 타임스탬프를 위한 정렬
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

# 3. 화자 분리
diarize_model = whisperx.DiarizationPipeline(
    use_auth_token="YOUR_HF_TOKEN",
    device=device
)
diarize_segments = diarize_model(audio)
result = whisperx.assign_word_speakers(diarize_segments, result)

# 화자 레이블이 있는 전사 결과 출력
for segment in result["segments"]:
    speaker = segment.get("speaker", "UNKNOWN")
    start = segment["start"]
    end = segment["end"]
    text = segment["text"]
    print(f"[{start:.2f}s - {end:.2f}s] {speaker}: {text}")
```

### faster-whisper (프로덕션 추론)

faster-whisper는 CTranslate2를 사용하여 Whisper를 재구현하여 양자화 지원과 함께 4-8배 속도 향상을 제공한다. 프로덕션 API의 기본 선택이다.

```bash
pip install faster-whisper
```

```python
from faster_whisper import WhisperModel

# 더 낮은 메모리를 위한 양자화로 로드
model = WhisperModel(
    "large-v3",
    device="cuda",
    compute_type="float16",   # 옵션: int8, int8_float16, float16, float32
    num_workers=4,
    cpu_threads=8
)

# VAD 필터링으로 전사
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

print(f"감지된 언어: {info.language} (확률: {info.language_probability:.2f})")

for segment in segments:
    print(f"[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}")
```

### LibreTranslate 통합 (번역 파이프라인)

```python
import whisper
import requests

# 비영어 오디오 전사
model = whisper.load_model("medium")
audio_path = "japanese_podcast.mp3"
result = model.transcribe(audio_path, language="ja")
japanese_text = result["text"]

# LibreTranslate API를 통한 번역
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

### FastAPI 실시간 전사 서버

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

실행: `uvicorn main:app --host 0.0.0.0 --port 8000 --workers 2`

### Prometheus 모니터링 통합

```python
from prometheus_client import Counter, Histogram, start_http_server
import time

TRANSCRIPTION_COUNT = Counter(
    "whisper_transcriptions_total",
    "총 전사 횟수",
    ["model", "language"]
)
TRANSCRIPTION_DURATION = Histogram(
    "whisper_transcription_duration_seconds",
    "전사 소요 시간",
    ["model"]
)

def transcribe_with_metrics(audio_path, model_name="medium"):
    start = time.time()
    segments, info = model.transcribe(audio_path)
    duration = time.time() - start

    TRANSCRIPTION_COUNT.labels(model=model_name, language=info.language).inc()
    TRANSCRIPTION_DURATION.labels(model=model_name).observe(duration)

    return segments, info

# 9090 포트에서 메트릭 서버 시작
start_http_server(9090)
```

## 벤치마크 / 실제 사용 사례

![Whisper 언어 분석](https://raw.githubusercontent.com/openai/whisper/main/language-breakdown.svg)

### 단어 오류율 비교 (LibriSpeech test-clean)

| 모델 / 엔진 | WER (clean) | WER (other) | 다국어 | 연도 |
|-------------|-------------|-------------|--------|------|
| Whisper tiny | 7.6% | 12.0% | 12.0% | 2022 |
| Whisper base | 5.0% | 8.1% | 10.0% | 2022 |
| Whisper small | 3.4% | 5.8% | 7.0% | 2022 |
| Whisper medium | 2.9% | 5.0% | 5.0% | 2022 |
| Whisper large-v3 | 2.4% | 4.2% | 3.5% | 2024 |
| Whisper turbo | 2.5% | 4.3% | 3.7% | 2024 |
| faster-whisper (large-v3) | 2.4% | 4.2% | 3.5% | 2024 |
| WhisperX (large-v3) | 2.4% | 4.2% | 3.5% | 2024 |
| Mozilla DeepSpeech | 7.3% | 21.5% | N/A (영어 전용) | 2020 |

### 추론 속도 벤치마크 (1시간 오디오, NVIDIA RTX 4090)

| 엔진 | 모델 | 시간 | VRAM | 참고 |
|------|------|------|------|------|
| OpenAI Whisper | large-v3 | ~90분 | ~10 GB | 기준선 |
| faster-whisper | large-v3 | ~18분 | ~6 GB | float16, 4-8배 가속 |
| faster-whisper | large-v3 | ~12분 | ~4 GB | int8 양자화 |
| WhisperX | large-v3 | ~25분 | ~8 GB | 정렬 포함 |
| WhisperX (분리 없음) | large-v3 | ~18분 | ~6 GB | 전사만 |
| OpenAI Whisper | turbo | ~12분 | ~6 GB | 증류 디코더 |

### 프로덕션 배포 시나리오

| 사용 사례 | 추천 모델 | 엔진 | 하드웨어 | 일일 처리량 |
|-----------|-----------|------|----------|-------------|
| 팟캐스트 전사 | large-v3 | faster-whisper | 1x A100 | 500+ 시간 |
| 실시간 회의 노트 | turbo | faster-whisper | 1x RTX 4090 | 200+ 시간 |
| 콜센터 분석 | medium | faster-whisper (int8) | 2x RTX 3080 | 1000+ 시간 |
| 모바일/엣지 기기 | tiny.en | whisper.cpp | 8 GB RAM | 오프라인 |
| 비디오 자막 생성 | large-v3 | WhisperX | 1x A100 | 300+ 시간 |

## 고급 사용법 / 프로덕션 강화

### 더 낮은 메모리를 위한 모델 양자화

```python
from faster_whisper import WhisperModel

# INT8 양자화 — 2배 속도, VRAM 50% 절감
model_int8 = WhisperModel("large-v3", device="cuda", compute_type="int8")

# INT8 with float16 활성화 — 균형 잡힌
model_hybrid = WhisperModel("large-v3", device="cuda", compute_type="int8_float16")

# CPU에서 INT8 사용
model_cpu = WhisperModel("medium", device="cpu", compute_type="int8", cpu_threads=8)
```

### 배치 처리 파이프라인

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

# 오디오 파일 디렉토리 처리
audio_dir = "/data/audio/"
files = [os.path.join(audio_dir, f) for f in os.listdir(audio_dir) if f.endswith(".mp3")]

with ThreadPoolExecutor(max_workers=4) as executor:
    results = list(executor.map(process_file, files))

print(f"{len(results)}개 파일 처리 완료")
```

### NGINX 로드 밸런싱 (멀티 GPU)

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

### 헬스 체크 엔드포인트

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

### Redis 큐 비동기 처리

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

## 대안과의 비교

![Whisper 모델 변체 비교](https://opengraph.githubassets.com/1/openai/whisper)

| 기능 | OpenAI Whisper | WhisperX | faster-whisper | DeepSpeech |
|------|---------------|----------|----------------|------------|
| **GitHub Stars** | 99,800 | 19,700 | 20,400 | 26,700 (아카이브) |
| **라이선스** | MIT | BSD-2 | MIT | MPL-2.0 |
| **기준선 대비 속도** | 1x (기준) | 0.8-1x | 4-8x | 2x |
| **GPU 필요** | 선택 | 추천 | 선택 | 선택 |
| **양자화 지원** | 없음 | 없음 | 있음 (INT8/FP16) | 없음 |
| **단어 수준 타임스탬프** | 세그먼트 수준 | 음소 수준 | 세그먼트 수준 | 없음 |
| **화자 분리** | 없음 | 내장 | 없음 | 없음 |
| **지원 언어** | 99 | 99 | 99 | 영어 전용 |
| **WER (LibriSpeech clean)** | 2.4% (large-v3) | 2.4% | 2.4% | 7.3% |
| **활발한 개발** | 예 | 예 | 예 | 아니요 (2025년 6월 아카이브) |
| **적합한 용도** | 연구, 참조 | 회의 전사 | 프로덕션 API | 레거시 전용 |

## 한계 / 솔직한 평가

Whisper는 모든 음성 작업에 맞는 도구는 아니다. README에 나오지 않는 내용:

1. **스트리밍 미지원**: Whisper는 30초 청크를 처리하며, 진정한 실시간(<200ms 지연) 전사용으로 설계되지 않았다. 스트리밍 ASR에는 NVIDIA Parakeet이나 Moonshine v2를 고려하라.

2. **무음에서 환각**: large-v3은 가끔 무음 구간에 존재하지 않는 텍스트를 생성한다. faster-whisper의 VAD 필터링을 사용하여 완화하라.

3. **영어 중심 학습**: 99개 언어를 지원하지만, 저자원 아프리카 및 남아시아 언어에서 성능이 눈에 띄게 저하된다. 대상 언어 데이터에 대한 미세 조정이 종종 필요하다.

4. **메모리 사용량**: large-v3은 FP32에서 ~10 GB VRAM이 필요하다. 중급 GPU에는 양자화(faster-whisper)나 CPU 오프로딩이 필요하다.

5. **화자 분리 없음**: 기본 Whisper는 누가 말했는지 알려주지 않는다. 다중 화자 식별에는 WhisperX나 별도의 분리 파이프라인이 필요하다.

6. **번역 제한**: turbo 모델은 번역 작업용으로 학습되지 않았다. 영어로 번역하려면 medium이나 large-v3을 사용하라.

## 자주 묻는 질문

### 1. Whisper와 faster-whisper의 차이점은?

faster-whisper는 CTranslate2(C++ 추론 엔진)를 사용하여 Whisper를 재구현했다. 동일한 전사 결과를 제공하면서 4-8배 속도 향상, INT8 양자화, 내장 VAD 필터링을 제공한다. 프로덕션에는 faster-whisper를, 연구와 실험에는 OpenAI Whisper를 사용하라.

### 2. CPU에서 Whisper를 실행할 수 있나?

예. large-v3을 제외한 모든 모델이 현대 CPU에서 원활하게 실행된다. 노트북에서는 tiny 모델을, 배치 처리에는 INT8 양자화된 medium 모델을 사용하라. GPU 대비 3-5배 느리다.

### 3. 어떤 모델 크기를 선택해야 하나?

영어 전용 빠른 작업은 `base`, 일상적인 다국어 사용은 `small`, 전문가 수준의 정확도는 `medium`, 최대 정확도가 타협 불가능할 때 `large-v3`을 선택하라. `turbo` 모델은 지연 시간에 민감한 프로덕션 워크로드의 스위트 스팟이다.

### 4. 긴 오디오 파일을 효율적으로 처리하려면?

faster-whisper의 `vad_filter=True`를 사용하여 무음 구간을 건드러뛰어라. 1시간 이상 파일은 청크로 분할하여 병렬 처리하라. WhisperX는 긴 파일을 기본적으로 처리하며, 3시간 이상 오디오에서 기본 Whisper보다 안정적이다.

### 5. Whisper는 상업적 사용이 물론 물가?

예. Whisper는 MIT 라이선스로 배포되어 상업적 사용, 수정, 배포를 허용한다. 자체 하드웨어에서 실행하므로 API 비용이 없다. 유일한 비용은 컴퓨팅 자원(GPU/클우드 인스턴스)이다.

### 6. Whisper는 Google Speech-to-Text 같은 클라우드 API와 어떻게 비교되나?

Whisper large-v3은 영어에서 Google Speech-to-Text와 비슷한 WER을 달성한다(LibriSpeech에서 2.4% 대 2.1%). Whisper는 프라이버시(온프레미스), 비용(분당 요금 없음), 언어 커버리지(99개 언어)에서 우위를 차지한다. 클라우드 API는 통합 에코시스템과 관리형 확장성에서 우위를 차지한다.

### 7. 프로덕션에는 어떤 하드웨어가 필요한가?

단일 NVIDIA A100 (80 GB)은 float16으로 4개의 large-v3 인스턴스를 실행하여 하루에 약 200시간의 오디오를 처리할 수 있다. 예산 설정에서는 RTX 4090 (24 GB)이 faster-whisper와 함께 medium과 large-v3을 float16으로 편안하게 처리한다.

## 결론

OpenAI Whisper는 2026년에도 프로덕션 음성 인식의 실용적인 선택으로 남아있다. 99,800개의 GitHub star는 인기를 넘어 생태계의 성숙도를 반영한다: faster-whisper가 속도를, WhisperX가 화자 분리를, 핵심 모델이 99개 언어에서 높은 정확도를 제공한다. `faster-whisper`와 `medium` 모델로 시작하고, 화자 레이블이 필요할 때 `WhisperX`를 추가하며, GPU 메모리가 부족할 때 INT8 양자화를 사용하라.

**다음 단계:**
- 저장소 클론: `git clone https://github.com/openai/whisper`
- 배포 팁을 위해 dibi8 개발자 Telegram 커뮤니티에 참여하라
- 모델 크기를 확정하기 전에 자체 오디오 데이터에서 faster-whisper를 벤치마크하라



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [OpenAI Whisper GitHub 저장소](https://github.com/openai/whisper)
- [OpenAI Whisper 논문 (arXiv:2212.04356)](https://arxiv.org/abs/2212.04356)
- [faster-whisper by SYSTRAN](https://github.com/SYSTRAN/faster-whisper)
- [WhisperX by m-bain](https://github.com/m-bain/whisperX)
- [Whisper 모델 크기 설명](https://openwhispr.com/blog/whisper-model-sizes-explained)
- [Choosing Between Whisper Variants — Modal.com](https://modal.com/blog/choosing-whisper-variants)
- [Comparison: WhisperX vs Faster-Whisper vs OpenAI Whisper](https://gist.github.com/danielrosehill/278b1719598093767126e52105ae076e)
- [Whisper API Blog — 모델 비교](https://whisperapi.com/accuracy-benchmarks-top-free-open-source-speech-to-text-offerings)
