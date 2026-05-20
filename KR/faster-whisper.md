---
title: 'faster-whisper: 23K+ Stars로 4배 빠른 음성-텍스트 변환 — 2026년 WhisperX, whisper.cpp과 벤치마크 비교'
description: 'faster-whisper(SYSTRAN)는 CTranslate2로 OpenAI Whisper를 재구현하여 4배 속도 향상을 달성합니다. faster whisper 튜토리얼, 벤치마크 데이터, Docker 설정, Python API, VAD 필터, 배치 처리, WhisperX 및 whisper.cpp과의 프로덕션 통합을 다룹니다.'
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
github_repo: 'https://github.com/SYSTRAN/faster-whisper'
stars: 23000
maintainer: 'SYSTRAN'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['faster-whisper', '음성-텍스트변환', 'CTranslate2', 'OpenAI-Whisper', '음성인식', 'Python', 'Docker', 'ASR']
aliases:
- /kr/posts/faster-whisper/
---

{{</* resource-info */>}}

OpenAI의 Whisper는 2022년 음성-텍스트(STT) 분야를 바꿨지만, 원본 Python 구현은 하드웨어 성능을 충분히 활용하지 못했다. 13분짜리 오디오 파일의 경우 `openai/whisper` large-v2 모델을 Tesla V100 GPU에서 실행하면 4분 이상 소요된다 — 매일 수백 시간의 오디오를 처리하는 프로덕션 파이프라인에서는 받아들일 수 없는 수준이다. SYSTRAN의 **faster-whisper**는 CTranslate2를 활용해 Whisper 추론을 재구현하여 동일한 정확도로 최대 4배의 속도 향상을 달성하고 VRAM 사용량을 거의 70% 줄였다. GitHub 23,000+ stars를 보유한 faster-whisper는 Python 환경의 프로덕션 음성-텍스트 변환을 위한 사실상 표준 런타임이 되었다.

이 가이드에서는 설치, 벤치마크, Docker 배포, WhisperX 및 whisper.cpp과의 통합을 포함하는 프로덕션급 faster whisper 튜토리얼을 제공한다. 모든 명령과 설정은 복사-붙여넣기로 즉시 사용 가능하다.

![faster-whisper GitHub 저장소](https://opengraph.githubassets.com/1/SYSTRAN/faster-whisper)

*그림 1: faster-whisper GitHub 저장소 — 23,000+ stars, SYSTRAN이 적극적으로 유지보수.*

## faster-whisper란?

faster-whisper는 OpenAI의 Whisper 자동 음성 인식(ASR) 모델을 CTranslate2(Transformer 모델용 고성능 C++ 추론 엔진)로 재구현한 프로젝트이다. 원본 Whisper와 동일한 모델 가중치를 사용하지만 커스텀 CUDA 커널, INT8/FP16 양자화, 퓨즈드 어텐션 연산을 통해 훨씬 높은 처리량과 더 낮은 메모리 사용량을 제공한다.

Guillaume Klein이 시작한 이 프로젝트는 현재 SYSTRAN이 MIT 라이선스 하에 유지보수하고 있다. tiny부터 large-v3까지 모든 Whisper 모델 크기를 CPU와 NVIDIA GPU 모두에서 지원하며, 첫 로드 시 Hugging Face Hub에서 자동으로 모델을 변환한다.

## faster-whisper 작동 방식

PyTorch 추론을 CTranslate2의 최적화된 런타임으로 교체하는 아키텍처이다:

![CTranslate2 아키텍처](https://opennmt.net/CTranslate2/_static/favicon.png)

*그림 2: CTranslate2 추론 엔진 — 커스텀 CUDA 커널과 양자화를 통해 faster-whisper의 속도 향상을 제공하는 C++ 백엔드.*

속도 향상을 가능하게 하는 핵심 기술 결정:

- **가중치 양자화**: INT8은 모델 메모리를 ~50% 줄이면서 무시할 수 있는 수준의 정확도 손실(< 0.1% WER)만 발생시킨다.
- **퓨즈드 커널**: CTranslate2는 여러 GPU 연산을 단일 커널 실행으로 병합하여 디스패치 오버헤드를 줄인다.
- **Flash Attention 지원**: Ampere GPU(RTX 30xx+)에서 추가 메모리 대역폭 절약을 제공한다.
- **배치 추론**: GPU에서 여러 오디오 청크를 병렬 처리하여 거의 선형적인 처리량 확장을 달성한다.
- **Silero VAD 통합**: 내장 음성 활동 감지가 무음 구간을 걸러내 불필요한 연산을 줄인다.

## 설치 및 설정

### 요구사항

- Python 3.9+
- GPU: CUDA 12.x와 cuDNN 9.x를 지원하는 NVIDIA GPU
- FFmpeg 설치 불필요(PyAV를 통해 내장)

### pip 설치(CPU)

```bash
# 가상 환경 생성
python -m venv venv-whisper
source venv-whisper/bin/activate  # Linux/Mac
# venv-whisper\Scripts\activate  # Windows

# faster-whisper 설치
pip install faster-whisper
```

### pip 설치(GPU 지원)

```bash
# pip로 cuBLAS 및 cuDNN 설치(Linux 전용)
pip install nvidia-cublas-cu12 nvidia-cudnn-cu12==9.*

# 라이브러리 경로 설정
export LD_LIBRARY_PATH=$(python3 -c 'import os; import nvidia.cublas.lib; import nvidia.cudnn.lib; print(os.path.dirname(nvidia.cublas.lib.__file__) + ":" + os.path.dirname(nvidia.cudnn.lib.__file__))')

# faster-whisper 설치
pip install faster-whisper
```

### Docker 설정

```bash
# 공식 NVIDIA CUDA 이미지 가져오기
docker run -it --rm --gpus all \
  -v $(pwd)/audio:/audio \
  nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04 \
  bash

# 컨테이너 내에서
apt-get update && apt-get install -y python3-pip
pip install faster-whisper
```

### 설치 확인

```python
# verify_setup.py
from faster_whisper import WhisperModel
import torch

print(f"PyTorch CUDA 사용 가능: {torch.cuda.is_available()}")
print(f"CUDA 장치 수: {torch.cuda.device_count()}")

model = WhisperModel("tiny", device="cuda", compute_type="float16")
print(f"모델 로드 장치: {model.model.device}")
print("설치 확인 성공")
```

### 첫 번째 전사

```python
from faster_whisper import WhisperModel

# 모델 로드(첫 실행 시 Hugging Face에서 자동 다운로드)
model = WhisperModel("large-v3", device="cuda", compute_type="int8")

# 오디오 전사
segments, info = model.transcribe("audio.mp3", beam_size=5)

print(f"감지된 언어: {info.language} "
      f"(확률: {info.language_probability:.2f})")

for segment in segments:
    print(f"[{segment.start:.2f}s -> {segment.end:.2f}s] {segment.text}")
```

## 인기 도구와의 통합

### WhisperX(화자 분리)

WhisperX는 faster-whisper 위에 구축되어 단어 수준 타임스탬프와 화자 분리를 추가한다. 회의 전사를 위한 필수 도구이다.

```bash
pip install whisperx
```

```python
import whisperx
import torch

device = "cuda" if torch.cuda.is_available() else "cpu"
audio_file = "meeting.mp3"

# 1. faster-whisper 백엔드로 전사
model = whisperx.load_model("large-v3", device, compute_type="int8")
audio = whisperx.load_audio(audio_file)
result = model.transcribe(audio, batch_size=8)

# 2. 단어 수준 타임스탬프 정렬
model_a, metadata = whisperx.load_align_model(
    language_code=result["language"], device=device
)
result = whisperx.align(result["segments"], model_a, metadata, audio, device)

# 3. 화자 분리(Hugging Face 토큰 필요)
diarize_model = whisperx.DiarizationPipeline(
    use_auth_token="your_hf_token", device=device
)
diarize_segments = diarize_model(audio)
result = whisperx.assign_word_speakers(diarize_segments, result)

for segment in result["segments"]:
    speaker = segment.get("speaker", "UNKNOWN")
    print(f"[{segment['start']:.2f}s -> {segment['end']:.2f}s] "
          f"{speaker}: {segment['text']}")
```

### whisper-asr-webservice(OpenAI 호환 API)

OpenAI 호환 HTTP API로 faster-whisper를 노출한다:

```bash
docker run -d --gpus all \
  -p 9000:9000 \
  -e ASR_MODEL=large-v3 \
  -e ASR_ENGINE=faster_whisper \
  -e COMPUTE_TYPE=int8 \
  onerahming/openai-whisper-asr
```

```python
import requests

with open("audio.mp3", "rb") as f:
    response = requests.post(
        "http://localhost:9000/asr",
        files={"audio_file": f},
        data={"language": "en", "output": "json"}
    )
print(response.json())
```

### Speaches(자체 호스팅 OpenAI 호환 서버)

```bash
docker run -d --gpus all \
  -p 8000:8000 \
  -e WHISPER__MODEL=large-v3 \
  -e WHISPER__COMPUTE_TYPE=int8 \
  fedirz/speaches:latest-gpu
```

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:8000/v1", api_key="dummy")

with open("audio.mp3", "rb") as f:
    transcript = client.audio.transcriptions.create(model="large-v3", file=f)
print(transcript.text)
```

### LibreTranslate(번역 파이프라인)

```python
from faster_whisper import WhisperModel
import requests

model = WhisperModel("large-v3", device="cuda", compute_type="int8")
segments, info = model.transcribe("japanese_audio.mp3", beam_size=5)
japanese_text = " ".join([s.text for s in segments])

response = requests.post("http://localhost:5000/translate", json={
    "q": japanese_text, "source": "ja", "target": "en"
})
print(response.json()["translatedText"])
```

## 벤치마크 / 실제 사용 사례

![벤치마크 비교 차트](https://raw.githubusercontent.com/SYSTRAN/faster-whisper/master/benchmark/results.png)

*그림 3: 공식 벤치마크 결과 — faster-whisper가 RTX 3070 Ti에서 배치 INT8 추론으로 openai/whisper보다 최대 8.9배 빠르다.*

### GPU 벤치마크: 13분 오디오, large-v2 모델

| 구현체 | 정밀도 | Beam Size | 소요 시간 | VRAM 사용량 |
|---|---|---|---|---|
| openai/whisper | fp16 | 5 | 2분 23초 | 4708 MB |
| whisper.cpp (Flash Attention) | fp16 | 5 | 1분 05초 | 4127 MB |
| transformers (SDPA) | fp16 | 5 | 1분 52초 | 4960 MB |
| **faster-whisper** | **fp16** | **5** | **1분 03초** | **4525 MB** |
| **faster-whisper (batch_size=8)** | **fp16** | **5** | **17초** | **6090 MB** |
| **faster-whisper** | **int8** | **5** | **59초** | **2926 MB** |
| **faster-whisper (batch_size=8)** | **int8** | **5** | **16초** | **4500 MB** |

*NVIDIA RTX 3070 Ti 8GB, CUDA 12.4에서 실행.*

### CPU 벤치마크: 13분 오디오, small 모델

| 구현체 | 정밀도 | Beam Size | 소요 시간 | RAM 사용량 |
|---|---|---|---|---|
| openai/whisper | fp32 | 5 | 6분 58초 | 2335 MB |
| whisper.cpp | fp32 | 5 | 2분 05초 | 1049 MB |
| whisper.cpp (OpenVINO) | fp32 | 5 | 1분 45초 | 1642 MB |
| **faster-whisper** | **int8** | **5** | **1분 42초** | **1477 MB** |
| **faster-whisper (batch_size=8)** | **int8** | **5** | **51초** | **3608 MB** |

*Intel Core i7-12700K, 8 스레드에서 실행.*

### 프로덕션 사용 사례

| 사용 사례 | 모델 | 하드웨어 | 성능 |
|---|---|---|---|
| **회의 전사**(1시간 오디오) | large-v3 int8 | RTX 4070 | ~3분 처리 |
| **팟캐스트 일괄 처리**(100파일) | large-v3 int8 batch=8 | A100 40GB | 100시간 기준 ~20분 |
| **실시간 자막** | small int8 | RTX 3060 | ~200ms 지연 |
| **콜센터 분석** | medium int8 | CPU 8코어 | ~2배 실시간 |

## 고급 사용법 / 프로덕션 강화

### VAD 필터 사전 분할

```python
from faster_whisper import WhisperModel

model = WhisperModel("large-v3", device="cuda", compute_type="int8")

segments, info = model.transcribe(
    "audio.mp3",
    vad_filter=True,
    vad_parameters=dict(
        min_silence_duration_ms=500,
        speech_pad_ms=200,
        threshold=0.5
    ),
    beam_size=5
)
```

### 배치 추론으로 처리량 최대화

```python
from faster_whisper import WhisperModel
import glob, time

model = WhisperModel("large-v3", device="cuda", compute_type="int8")
audio_files = glob.glob("podcasts/*.mp3")

start = time.time()
for file_path in audio_files:
    segments, _ = model.transcribe(file_path, batch_size=8, beam_size=5)
    text = " ".join([s.text for s in segments])
    print(f"{file_path}: {len(text)} 문자")
print(f"총 소요: {time.time() - start:.1f}초, {len(audio_files)}개 파일")
```

### 단어 수준 타임스탬프

```python
segments, _ = model.transcribe("audio.mp3", word_timestamps=True)
for segment in segments:
    for word in segment.words:
        print(f"[{word.start:.2f}s -> {word.end:.2f}s] {word.word}")
```

### 커스텀 모델 변환

```bash
pip install transformers[torch]>=4.23

ct2-transformers-converter \
  --model openai/whisper-large-v3 \
  --output_dir whisper-large-v3-ct2 \
  --copy_files tokenizer.json preprocessor_config.json \
  --quantization float16
```

### Prometheus로 모니터링

```python
from faster_whisper import WhisperModel
from prometheus_client import Counter, Histogram, start_http_server

REQUEST_COUNT = Counter("transcription_requests_total", "총 요청 수")
REQUEST_DURATION = Histogram("transcription_duration_seconds", "요청 소요 시간")

model = WhisperModel("large-v3", device="cuda", compute_type="int8")

@REQUEST_DURATION.time()
def transcribe(audio_path):
    REQUEST_COUNT.inc()
    return model.transcribe(audio_path, beam_size=5)

start_http_server(8000)
```

### 우아한 오류 처리

```python
from faster_whisper import WhisperModel

def safe_transcribe(audio_path, device="cuda"):
    compute_types = ["int8", "int8_float16", "float16", "float32"]
    for ct in compute_types:
        try:
            model = WhisperModel("large-v3", device=device, compute_type=ct)
            segments, info = model.transcribe(audio_path, beam_size=5)
            return segments, info, ct
        except RuntimeError as e:
            print(f"{ct} 실패: {e}, 재시도...")
            continue
    raise RuntimeError("모든 컴퓨트 타입 실패")
```

## 대안과의 비교

| 기능 | faster-whisper | OpenAI Whisper | WhisperX | whisper.cpp |
|---|---|---|---|---|
| **GPU 속도 (large-v3)** | ~12배 실시간 | ~3배 실시간 | ~12배 실시간 | ~8배 실시간 |
| **VRAM (large-v3)** | ~2.5 GB (int8) | ~11 GB (fp16) | ~3 GB | ~3 GB |
| **Python API** | 네이티브 | 네이티브 | 네이티브 | 래퍼만 |
| **화자 분리** | 없음 | 없음 | 내장 | 없음 |
| **단어 수준 타임스탬프** | 있음 | 없음 | 있음 (wav2vec2) | 있음 |
| **Apple Silicon** | CPU만 | CPU/GPU | CPU만 | Metal (가장 빠름) |
| **NVIDIA GPU** | CUDA (가장 빠름) | CUDA | CUDA | CUDA |
| **AMD GPU** | 미지원 | 미지원 | 미지원 | Vulkan/ROCm |
| **CPU 최적화** | int8 SIMD | 기본 | int8 SIMD | AVX2/NEON |
| **VAD 필터** | 내장 Silero | 없음 | 내장 | 수동 조정 |
| **배치 추론** | 지원 | 미지원 | 지원 | 제한적 |
| **모델 양자화** | int8/fp16/fp32 | fp16/fp32 | int8/fp16 | q4/q5/fp16 |
| **라이선스** | MIT | MIT | MIT | MIT |
| **Stars (2026년 5월)** | 23,000+ | 15,000+ | 12,000+ | 44,000+ |

### 선택 가이드

- **faster-whisper**: NVIDIA GPU 또는 CPU의 Python 파이프라인. 최고의 통합 생태계. 프로덕션 STT 서비스, 배치 처리, 실시간 Python 애플리케이션에 사용.
- **OpenAI Whisper**: 참조 구현이 필요한 연구 및 실험. 프로덕션 워크로드에는 피할 것.
- **WhisperX**: 화자 레이블이 필요한 회의 전사, 팟캐스트, 인터뷰. faster-whisper 기반.
- **whisper.cpp**: Apple Silicon, 임베디드 장치, 엣지 배포, 크로스 플랫폼 앱. Python 의존성 없음.

## 한계 / 솔직한 평가

faster-whisper는 모든 시나리오에 적합하지 않다. 다음은 사용하지 말아야 할 경우이다:

1. **Apple Silicon GPU 가속**: faster-whisper는 Metal 백엔드가 없다. M 시리즈 Mac에서는 large-v3를 약 3배 실시간으로 CPU만 실행한다. whisper.cpp의 Metal은 ~10배 실시간 — 3배 더 빠르다.

2. **AMD GPU 지원**: CTranslate2는 GPU에서 CUDA만 지원한다. AMD GPU는 지원하지 않는다. Vulkan이나 ROCm을 지원하는 whisper.cpp를 대신 사용하라.

3. **극한의 엣지 장치**: faster-whisper는 CPU에서 작동하지만 Python 런타임 오버헤드로 인해 라즈베리 파이 Zero나 마이크로컨트롤러에는 덜 적합하다. whisper.cpp는 1GB RAM 내에서 Python 없이 실행된다.

4. **화자 분리**: faster-whisper는 전사만 출력한다. "누가 언제 말했는지" 식별은 WhisperX나 별도의 분리 파이프라인이 필요하다.

5. **초장시간 오디오 확장성**: 30분 이상의 매우 긴 오디오의 경우 일부 CPU 제한 시나리오에서 whisper.cpp가 더 나은 확장 특성을 보일 수 있다. 특정 하드웨어에서 벤치마크하라.

6. **비 NVIDIA GPU 서버**: AMD Instinct나 Intel Arc GPU를 사용하는 인프라의 경우 faster-whisper는 CPU로 폰백된다. 이는 CTranslate2의 하드웨어적 제한이다.

## 자주 묻는 질문

### faster-whisper를 실행하려면 어떤 하드웨어가 필요한가?

GPU 추론에는 CUDA 12.x를 지원하는 NVIDIA GPU가 필요하다. INT8 양자화는 8GB VRAM 카드(RTX 3060, RTX 4060)에서도 원활히 실행된다. CPU 추론의 경우 small 모델 기준 4코어 이상과 8GB RAM이면 충분하다. CPU에서 large-v3는 INT8 기준 약 3GB RAM이 필요하다.

### Docker에서 faster-whisper를 어떻게 설치하나?

cuDNN 9이 포함된 공식 NVIDIA CUDA 런타임 이미지를 사용하라. 위의 설치 및 설정 섹션에 전체 Dockerfile이 나와 있다. 핵심 요구사항은 `nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04` 베이스 이미지이다. `--gpus all`로 GPU를 노출하라.

### 전사 정확도는 OpenAI Whisper와 동일한가?

그렇다. faster-whisper는 동일한 모델 가중치와 토크나이저를 사용한다. WER 차이는 0.1% 이내 — 실제로 구분 불가능하다. 모든 변화는 빔 서치 무작위성에서 비롯되지 추론 엔진 자체가 아니다.

### 내 GPU에 최적인 compute_type은 무엇인가?

8GB GPU와 GTX 10xx 카드에는 `int8`을, 최신 GPU(RTX 30xx/40xx/50xx, A100, H100)에는 `float16`을 사용하라. Pascal 소비자 카드(GTX 1060/1070/1080)는 fp16 지원이 제한되어 `int8`을 사용해야 한다.

### faster-whisper와 WhisperX의 차이점은 무엇인가?

WhisperX는 faster-whisper 위에 구축되어 wav2vec2를 통한 화자 분리와 단어 수준 타임스탬프 정렬을 추가한다. 순수 전사에는 faster-whisper만으로 충분하다. 회의나 인터뷰에서 "누가 뭘 말했는지"가 필요할 때 WhisperX를 사용하라.

### faster-whisper를 실시간 스트리밍에 사용할 수 있나?

Whisper-Streaming이나 WhisperLive와 통합하면 가능하다. faster-whisper 자체는 네이티브 스트리밍을 지원하지 않지만 낮은 지연 시간으로 스트리밍 서버의 백엔드로 이상적이다. GPU의 small 모델 기준 일반적인 종단 간 지연은 200-500ms이다.

### 미세 조정된 Whisper 모델을 어떻게 변환하나?

고급 사용법 섹션에 표시된 `ct2-transformers-converter` CLI 도구를 사용하라. Hugging Face Hub의 모든 모델이나 Transformers와 호환되는 로컬 체크포인트를 변환할 수 있다. 변환 중 FP16과 INT8 양자화를 모두 지원한다.

### faster-whisper는 모든 Whisper 모델 크기를 지원하나?

그렇다 — tiny, base, small, medium, large-v1, large-v2, large-v3를 모두 지원한다. distil-whisper 변형(distil-large-v3)도 지원되어 미미한 정확도 희생으로 훨씬 빠른 추론이 가능하다.

## 결론

faster-whisper는 Python 환경에서 OpenAI Whisper의 프로덕션 런타임 선택이다. 참조 구현 대비 4배의 속도 향상, INT8 양자화를 통한 70% VRAM 절감, 그리고 WhisperX, speaches, whisper-asr-webservice를 포함한 성숙한 통합 생태계로 단일 파일 전사부터 수백 시간의 오디오 일괄 처리까지 모든 것을 처리한다.

데이터가 분명하다: NVIDIA GPU와 Python을 사용한다면 faster-whisper가 기준선이다. 일반 용도는 int8 large-v3 모델로 시작하고, 실시간에는 small로 낮추고, 화자 레이블이 필요할 때 WhisperX를 통합하라.

**액션 아이템:**

1. `pip install faster-whisper`를 실행하고 위의 확인 스크립트를 실행하라.
2. 저장소의 13분 테스트 오디오로 하드웨어를 벤치마크하라.
3. 프로덕션 파이프라인을 위해 Docker 배포를 설정하라.
4. [dibi8.com Telegram 그룹](https://t.me/dibi8tech)에 가입하여 벤치마크 결과를 공유하고 프로덕션 지원을 받아라.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- faster-whisper GitHub 저장소: https://github.com/SYSTRAN/faster-whisper
- CTranslate2 문서: https://opennmt.net/CTranslate2/
- WhisperX(화자 분리): https://github.com/m-bain/whisperX
- whisper.cpp(C++ 포트): https://github.com/ggml-org/whisper.cpp
- OpenAI Whisper(참조 구현): https://github.com/openai/whisper
- Speaches(OpenAI 호환 서버): https://github.com/speaches-ai/speaches
- Whisper-Streaming(실시간): https://github.com/ufal/whisper_streaming
- PyAV(오디오 디코딩): https://github.com/PyAV-Org/PyAV
- Silero VAD: https://github.com/snakers4/silero-vad
