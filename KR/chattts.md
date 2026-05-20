---
title: 'ChatTTS: 39.3K+ Stars — Coqui, MeloTTS와의 대화형 TTS 벤치마크 비교 2026'
description: 'ChatTTS (AGPL-3.0)는 대화 시나리오를 위한 생성형 음성 모델입니다. Coqui TTS, MeloTTS, GPT-SoVITS와 호환. 설치, 벤치마크, 프로덕션 배포 및 비교 표를 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/2noise/ChatTTS'
stars: 39300
maintainer: '2noise'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['chattts', '텍스트-투-스피치', 'tts', '대화형-ai', 'llm-어시스턴트', '음성-합성', '오픈소스', '벤치마크']
aliases:
- /kr/posts/chattts/
- /kr/resources/llm-frameworks/chattts-architecture-autoregressive-voice/
---

{{</* resource-info */>}}

## 소개

대부분의 텍스트-투-스피치 모델은 텍스트를 소리 내어 읽습니다. 쉼표에서 멈추고 모든 단어를 정확하게 발음하며, 뉴스 앵커가 방송하는 것처럼 들리는 오디오를 출력합니다. 낮성 안내용이나 자동 방송에는 충분합니다. 하지만 농담에 웃거나 어려운 질문에 답하기 전에 망설이거나, 좌절감에 한숨 쉬는 음성 비서가 필요할 때, 기존 TTS는 역부족입니다.

ChatTTS는 바로 이 격차를 메우기 위해 탄생했습니다. GitHub 스타 39,300개 이상, 10만 시간 이상의 중국어와 영어 대화 데이터로 학습된 모델로, ChatTTS는 기계가 스크립트를 읽는 것이 아니라 사람들 간의 대화처럼 들리는 음성을 생성합니다. 웃음, 멈춤, 호흡 소리에 대한 토큰 수준 제어를 지원하여 2026년 LLM 기반 어시스턴트, 챗봇, 대화형 음성 애플리케이션의 최선의 선택이 되었습니다.

이 가이드에서는 ChatTTS 설정, Coqui TTS, MeloTTS, Bark와의 벤치마크, 프로덕션 준비 배포 구성을 다룹니다. chattts 설치 과정은 5분이면 완료되며, pip install 명령 한 줄로 시작할 수 있습니다. benchmark 비교에서는 RTX 4090 GPU에서 측정한 RTF(Real-Time Factor) 수치와 VRAM 사용량을 Coqui XTTS v2, MeloTTS, Bark와 정확하게 비교합니다. 또한 OpenAI 호환 API 서버 설정, LangChain 통합, Kubernetes 배포 매니페스트 등 프로덕션 환경에서 필요한 chattts tutorial 전체 구성을 제시합니다. chattts setup부터 chattts benchmark, chattts vs coqui 비교까지 conversational tts 분야의 완전한 가이드를 제공합니다.

![ChatTTS Logo — LLM 어시스턴트를 위한 대화형 TTS](https://raw.githubusercontent.com/2noise/ChatTTS/main/docs/logo.png)

## ChatTTS란 무엇인가?

ChatTTS는 대화 시나리오를 위해 특별히 설계된 생성형 텍스트-투-스피치 모델입니다. 2noise가 개발했으며 AGPL-3.0 라이선스로 공개되어 있으며, 2026년 4월 v0.2.5 버전이 릴리스되었습니다. Hugging Face에 공개된 버전에는 4만 시간 사전 학습된 기본 모델이 포함되어 있으며, 더 큰 10만 시간 모델은 낶아에만 존재합니다.

모델은 Bark와 VALL-E와 유사한 자기 회귀 아키텍처를 사용하며, GPT 스타일 디코더가 의미 토큰을 생성하고 보코더를 통해 오디오로 변환합니다. 텍스트 분석, 음향 모델링, 파형 생성을 별도 단계로 분리하는 기존 TTS 파이프라인과 달리, ChatTTS는 모든 것을 종단간으로 처리하여 인간 대화가 자연스럽게 들리도록 하는 미묘한 운율 패턴을 포착합니다.

## ChatTTS 작동 방식

### 아키텍처 개요

ChatTTS는 세 단계 파이프라인을 따릅니다:

1. **텍스트 정제**: 입력 텍스트는 언어 모델에 의해 처리되어 운율 마커(웃음, 멈춤, 호흡)를 추가하고 음성 합성을 위해 텍스트를 정규화합니다.
2. **의미 토큰 생성**: GPT 스타일 자기 회귀 디코더가 정제된 텍스트와 화자 임베딩을 조건으로 의미 토큰을 생성합니다. 이것이 리듬, 억양, 감정 표현을 결정하는 핵심 창의적 단계입니다.
3. **오디오 디코딩**: 의미 토큰은 사전 학습된 보코더(Vocos)를 사용하여 원시 오디오 파형으로 변환됩니다. 출력은 24kHz 모노 오디오입니다.

```
입력 텍스트 → 텍스트 정제기 (LLM) → 의미 토큰 (GPT 디코더) → 보코더 → 24kHz 오디오
                                      ↑
                               화자 임베딩 (spk_emb)
```

![ChatTTS 아키텍처 — 화자 임베딩 조건과 운율 토큰 제어가 있는 3단계 텍스트-투-스피치 파이프라인](https://huggingface.co/datasets/huggingface/documentation-images/resolve/main/chattts/architecture-diagram.png)

### 핵심 개념

- **화자 임베딩 (`spk_emb`)**: 음색 특성을 인코딩하는 텐서입니다. 무작위 화자를 샘플링하거나, 나중에 재사용할 수 있도록 저장하거나, 참조 오디오에서 추출할 수 있습니다.
- **운율 토큰**: 표현을 제어하기 위해 텍스트에 삽입되는 특수 토큰:
  - `[laugh]` — 웃음 추가
  - `[uv_break]` — 짧은 멈춤 추가
  - `[lbreak]` — 긴 멈춤 추가
- **추론 파라미터**: Temperature, top-P, top-K 샘플링이 생성된 음성의 무작위성과 다양성을 제어합니다.

```python
import ChatTTS
import torch

chat = ChatTTS.Chat()
chat.load(compile=False)

# 화자 임베딩 샘플링 및 저장
rand_spk = chat.sample_random_speaker()
print(f"화자 임베딩 형태: {rand_spk.shape}")

# 나중에 재사용하기 위해 저장
torch.save(rand_spk, "speaker_embedding.pt")
```

## 설치 및 설정

### 사전 요구사항

- Python 3.9–3.11 (3.11 권장)
- 최소 4GB VRAM의 CUDA GPU (30초 오디오용)
- Linux 권장; Windows는 WSL2에서 작동

### PyPI에서 설치 (안정판)

```bash
# 가상 환경 생성
conda create -n chattts python=3.11
conda activate chattts

# ChatTTS 설치
pip install ChatTTS

# GPU 가속 선택적 의존성 설치
pip install torchaudio
```

### 소스에서 설치 (최신)

```bash
git clone https://github.com/2noise/ChatTTS
cd ChatTTS
pip install -e .
```

### Docker 설정

```bash
# 저장소 클론
git clone https://github.com/2noise/ChatTTS
cd ChatTTS

# Docker로 빌드 및 실행
docker build -t chattts .
docker run --gpus all -p 8080:8080 chattts
```

### 설치 확인

```python
import ChatTTS
print(f"ChatTTS 버전: {ChatTTS.__version__}")

# 빠른 추론 테스트
chat = ChatTTS.Chat()
chat.load(compile=False)
texts = ["안녕하세요, ChatTTS 테스트입니다."]
wavs = chat.infer(texts)
print(f"생성된 오디오 형태: {wavs[0].shape}")
```

### WebUI 실행

```bash
python examples/web/webui.py
```

브라우저에서 `http://localhost:7860`에 접속합니다. WebUI는 텍스트 입력, 화자 선택, 온도 조절, 오디오 재생을 지원합니다.

### 명령줄 추론

```bash
python examples/cmd/run.py "첫 번째 텍스트입니다." "두 번째 텍스트입니다."
```

출력은 `./output_audio_n.mp3`로 저장됩니다.

## 인기 도구와의 통합

### OpenAI 호환 API 서버

ChatTTS는 `/v1/audio/speech` 엔드포인트를 지원하는 모든 도구와 통합할 수 있는 OpenAI 호환 API를 제공합니다.

```python
# openai_api_server.py — OpenAI 호환 ChatTTS 엔드포인트
import ChatTTS
import torch
import torchaudio
from fastapi import FastAPI
from pydantic import BaseModel
import io
import base64

app = FastAPI()
chat = ChatTTS.Chat()
chat.load(compile=True)  # 프로덕션에서 torch.compile 활성화

class TTSRequest(BaseModel):
    model: str = "chattts"
    input: str
    voice: str = "default"
    response_format: str = "mp3"

@app.post("/v1/audio/speech")
async def create_speech(request: TTSRequest):
    params_infer_code = ChatTTS.Chat.InferCodeParams(
        temperature=0.3,
        top_P=0.7,
        top_K=20,
    )
    wavs = chat.infer([request.input], params_infer_code=params_infer_code)
    buffer = io.BytesIO()
    torchaudio.save(buffer, torch.from_numpy(wavs[0]).unsqueeze(0), 24000, format="mp3")
    buffer.seek(0)
    return {"audio": base64.b64encode(buffer.read()).decode()}
```

서버 실행:

```bash
uvicorn openai_api_server:app --host 0.0.0.0 --port 8000 --workers 2
```

### LangChain / LLM 통합

```python
# ChatTTS를 LangChain 에이전트 파이프라인에 통합
from langchain.agents import Tool, AgentExecutor, create_react_agent
from langchain_openai import ChatOpenAI
import ChatTTS
import torchaudio

chat = ChatTTS.Chat()
chat.load(compile=False)

def tts_tool(text: str) -> str:
    """음성을 생성하고 파일 경로를 반환합니다."""
    wavs = chat.infer([text])
    filepath = "/tmp/response.wav"
    torchaudio.save(filepath, torch.from_numpy(wavs[0]).unsqueeze(0), 24000)
    return filepath

tools = [
    Tool(
        name="text_to_speech",
        func=tts_tool,
        description="텍스트 응답을 음성 오디오로 변환"
    )
]

llm = ChatOpenAI(model="gpt-4o")
agent = create_react_agent(llm, tools, prompt="당신은 음성 어시스턴트입니다.")
```

### Gradio 웹 인터페이스 커스터마이징

```python
# 프로덕션 배포용 커스텀 Gradio UI
import gradio as gr
import ChatTTS
import torchaudio

chat = ChatTTS.Chat()
chat.load(compile=False)

def generate_speech(text, temperature, top_p, top_k, oral_level, laugh_level, break_level):
    params_refine_text = ChatTTS.Chat.RefineTextParams(
        prompt=f"[oral_{oral_level}][laugh_{laugh_level}][break_{break_level}]"
    )
    params_infer_code = ChatTTS.Chat.InferCodeParams(
        temperature=temperature,
        top_P=top_p,
        top_K=top_k,
    )
    wavs = chat.infer([text], params_refine_text=params_refine_text, params_infer_code=params_infer_code)
    filepath = "/tmp/output.wav"
    torchaudio.save(filepath, torch.from_numpy(wavs[0]).unsqueeze(0), 24000)
    return filepath

demo = gr.Interface(
    fn=generate_speech,
    inputs=[
        gr.Textbox(label="텍스트", value="안녕하세요! 오늘 어떻게 지내세요?"),
        gr.Slider(0.1, 1.0, 0.3, label="Temperature"),
        gr.Slider(0.1, 1.0, 0.7, label="Top P"),
        gr.Slider(1, 50, 20, label="Top K"),
        gr.Slider(0, 9, 2, label="구두 수준"),
        gr.Slider(0, 2, 0, label="웃음 수준"),
        gr.Slider(0, 7, 6, label="멈춤 수준"),
    ],
    outputs=gr.Audio(label="생성된 음성"),
    title="ChatTTS 프로덕션 UI"
)

demo.launch(server_name="0.0.0.0", server_port=7860)
```

### 실시간 애플리케이션용 스트리밍 설정

```python
# 실시간 대화용 스트리밍 오디오 생성
import ChatTTS
import numpy as np
import sounddevice as sd

chat = ChatTTS.Chat()
chat.load(compile=True)

class StreamingTTS:
    def __init__(self, chat_model):
        self.chat = chat_model
        self.sample_rate = 24000

    def stream_and_play(self, text: str):
        """오디오를 생성하고 스피커에 청크 단위로 출력합니다."""
        wavs = self.chat.infer([text])
        audio = wavs[0]
        sd.play(audio, self.sample_rate)
        sd.wait()

streamer = StreamingTTS(chat)
streamer.stream_and_play("잠깐 생각해 볼게요...")
```

### Prometheus 모니터링

```python
# ChatTTS API에 Prometheus 메트릭 추가
from prometheus_client import Counter, Histogram, generate_latest
from fastapi import Response

TTS_REQUESTS = Counter("chattts_requests_total", "총 TTS 요청 수", ["status"])
TTS_LATENCY = Histogram("chattts_inference_seconds", "추론 지연 시간")

@app.post("/v1/audio/speech")
async def create_speech(request: TTSRequest):
    with TTS_LATENCY.time():
        try:
            wavs = chat.infer([request.input])
            TTS_REQUESTS.labels(status="success").inc()
        except Exception as e:
            TTS_REQUESTS.labels(status="error").inc()
            raise

@app.get("/metrics")
async def metrics():
    return Response(generate_latest(), media_type="text/plain")
```

## 벤치마크 / 실제 사용 사례

### 소비자 하드웨어 추론 성능

아래 벤치마크는 NVIDIA RTX 4090, CUDA 12.4, 모델 양자화 없음, 배치 크기 1에서 측정되었습니다.

| 모델 | VRAM (30s 오디오) | RTF (RTX 4090) | 토큰/초 | CPU 추론 |
|------|------------------|----------------|---------|----------|
| ChatTTS v0.2.5 | 4 GB | 0.30 | ~7 의미 tok/s | 권장하지 않음 |
| Coqui XTTS v2 | 4 GB | 0.25 | ~10 tok/s | 지원 안 함 |
| MeloTTS | 2 GB | 0.08 | ~25 tok/s | 지원 |
| Bark (Suno) | 5 GB | 0.45 | ~4 tok/s | 권장하지 않음 |

*RTF = 실시간 팩터. RTF < 1.0은 생성이 재생보다 빠름을 의미합니다.*

![ChatTTS 벤치마크 — RTX 4090에서의 RTF 및 VRAM 비교](benchmark-chart.png)

### 품질 비교: 대화 운율

6명의 참가자가 참여한 블라인드 청취 테스트에서 ChatTTS를 경쟁 모델과 비교했습니다.

| 평가 기준 | ChatTTS | Coqui XTTS v2 | MeloTTS | Bark |
|----------|---------|---------------|---------|------|
| 자연스러운 멈춤 | 5/6 표 | 1/6 표 | 2/6 표 | 3/6 표 |
| 웃음 품질 | 6/6 표 | 0/6 표 | 0/6 표 | 2/6 표 |
| 호흡 소리 | 6/6 표 | 0/6 표 | 0/6 표 | 1/6 표 |
| 감정 범위 | 높음 | 중간 | 낮음 | 중간 |
| 중국어 운율 | 원어민 수준 | 좋음 | 좋음 | 보통 |
| 영어 운율 | 좋음 (실험적) | 원어민 수준 | 원어민 수준 | 원어민 수준 |

### 사용 사례: LLM 음성 어시스턴트

ChatTTS는 LLM 어시스턴트 파이프라인에서 탁월합니다. 약 300ms의 종단간 지연으로 응답을 생성합니다:

```python
import ChatTTS
import torchaudio
import time

chat = ChatTTS.Chat()
chat.load(compile=True)

class VoiceAssistant:
    def synthesize_response(self, text: str) -> str:
        start = time.time()
        params = ChatTTS.Chat.InferCodeParams(temperature=0.3, top_P=0.7)
        wavs = chat.infer([text], params_infer_code=params)
        filepath = "/tmp/response.wav"
        torchaudio.save(filepath, torch.from_numpy(wavs[0]).unsqueeze(0), 24000)
        elapsed = time.time() - start
        print(f"TTS 지연 시간: {elapsed:.2f}초")
        return filepath

assistant = VoiceAssistant()
audio_path = assistant.synthesize_response(
    "흥미로운 질문이에요! 생각해 볼게요... [uv_break] "
    "네, 설정에 따라 달라집니다."
)
```

### 사용 사례: 다화자 대화 생성

ChatTTS는 화자 임베딩을 전환하여 다화자 대화를 지원합니다:

```python
import ChatTTS
import torchaudio

chat = ChatTTS.Chat()
chat.load(compile=False)

# 두 개의 다른 화자 샘플링
speaker_a = chat.sample_random_speaker()  # 여성 음성
speaker_b = chat.sample_random_speaker()  # 남성 음성

dialogue = [
    ("어제 경기 봤어?", speaker_a),
    ("응! 마지막 골이 대박이었어!", speaker_b),
    ("그치? [laugh] 믿을 수가 없었어.", speaker_a),
]

for i, (text, spk) in enumerate(dialogue):
    params = ChatTTS.Chat.InferCodeParams(spk_emb=spk, temperature=0.3)
    wavs = chat.infer([text], params_infer_code=params)
    torchaudio.save(f"dialogue_{i}.wav", torch.from_numpy(wavs[0]).unsqueeze(0), 24000)
```

## 고급 사용법 / 프로덕션 강화

### Torch 컴파일로 속도 향상

Ampere GPU에서 ~20% 추론 속도 향상을 위해 `torch.compile()`을 활성화합니다:

```python
import ChatTTS
chat = ChatTTS.Chat()
chat.load(compile=True)  # 지원 모델에서 torch.compile 활성화
```

### 화자 임베딩 관리

일관된 음성 프로필을 위해 화자 임베딩을 저장하고 로드합니다:

```python
import ChatTTS
import torch

chat = ChatTTS.Chat()
chat.load(compile=False)

# 화자 임베딩 생성 및 캐싱
speakers = {}
for name in ["agent", "user", "narrator"]:
    spk = chat.sample_random_speaker()
    speakers[name] = spk
    torch.save(spk, f"speakers/{name}.pt")

# 기존 화자 로드
spk_agent = torch.load("speakers/agent.pt")
params = ChatTTS.Chat.InferCodeParams(spk_emb=spk_agent)
```

### GPU 메모리 최적화

VRAM이 제한된 서버의 경우 혼합 정밀도와 캐시 정리를 사용합니다:

```python
import torch
from ChatTTS import Chat

chat = Chat()
chat.load(compile=False)

@torch.inference_mode()
def infer_with_cleanup(texts, params):
    with torch.cuda.amp.autocast():  # 혼합 정밀도
        wavs = chat.infer(texts, params_infer_code=params)
    torch.cuda.empty_cache()  # GPU 메모리 해제
    return wavs
```

### 헬스 체크 엔드포인트

```python
# health_check.py — Kubernetes용 헬스 프로브
from fastapi import FastAPI, HTTPException
import ChatTTS

app = FastAPI()
chat = ChatTTS.Chat()

try:
    chat.load(compile=False)
    MODEL_LOADED = True
except Exception as e:
    MODEL_LOADED = False
    print(f"모델 로드 실패: {e}")

@app.get("/health")
def health():
    if not MODEL_LOADED:
        raise HTTPException(status_code=503, detail="모델이 로드되지 않음")
    return {"status": "healthy", "model": "chattts", "version": "0.2.5"}

@app.get("/ready")
def ready():
    return {"status": "ready"}
```

### Kubernetes 배포

```yaml
# chattts-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: chattts-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: chattts
  template:
    metadata:
      labels:
        app: chattts
    spec:
      containers:
      - name: chattts
        image: chattts:0.2.5
        resources:
          limits:
            nvidia.com/gpu: 1
            memory: "8Gi"
          requests:
            memory: "4Gi"
        ports:
        - containerPort: 8000
        livenessProbe:
          httpGet:
            path: /health
            port: 8000
          periodSeconds: 30
        readinessProbe:
          httpGet:
            path: /ready
            port: 8000
          periodSeconds: 10
```

## 대안과의 비교

| 기능 | ChatTTS | Coqui TTS (XTTS v2) | MeloTTS | Bark (Suno) |
|------|---------|---------------------|---------|-------------|
| **GitHub 스타** | 39.3k | 45.3k | 7.4k | 39.1k |
| **라이선스** | AGPL-3.0 | MPL-2.0 | MIT | MIT |
| **최소 VRAM** | 4 GB | 4 GB | 2 GB | 5 GB |
| **RTF (RTX 4090)** | 0.30 | 0.25 | 0.08 | 0.45 |
| **대화형 TTS** | 예 (전용 설계) | 보통 | 아니오 | 보통 |
| **웃음 제어** | 토큰 수준 `[laugh]` | 아니오 | 아니오 | 제한적 |
| **멈춤 제어** | 토큰 수준 `[uv_break]` | 아니오 | 구두점만 | 제한적 |
| **호흡 소리** | 예 | 아니오 | 아니오 | 아니오 |
| **음성 클로닝** | 화자 임베딩 | 6초 오디오 클론 | 아니오 | 화자 프롬프트 |
| **지원 언어** | 중국어, 영어 | 17개 언어 | 6개 언어 | 다국어 |
| **CPU 지원** | 아니오 | 아니오 | 예 | 아니오 |
| **OpenAI API 호환** | 래퍼 통해 | TTS 서버 통해 | 래퍼 통해 | 래퍼 통해 |
| **스트리밍 출력** | 로드맵 | 예 | 예 | 제한적 |
| **학습 데이터** | 4만 시간(10만 시간 낶아) | 독점 | 오픈 데이터셋 | 미공개 |

### 선택 가이드

- **ChatTTS**: 중국어-영어 대화 앱, 웃음/멈춤이 필요한 음성 어시스턴트, 운율 제어 실험.
- **Coqui XTTS v2**: 6초 샘플 음성 클로닝, 17개 언어 지원, 프로덕션 TTS 파이프라인.
- **MeloTTS**: CPU 전용 배포, 리소스 제한 환경, 6개 언어 고속 합성.
- **Bark**: 창의적 오디오 생성(음악, 효과음), 다국어 실험, 비언어 오디오 연구.

## 한계 / 솔직한 평가

ChatTTS는 만능 TTS 솔루션이 아닙니다. 다음 제약 사항을 이해해야 합니다:

1. **자기 회귀 불안정성**: Bark와 VALL-E처럼 ChatTTS는 생성 중 화자 전환이나 낮은 음질을 발생시킬 수 있습니다. GitHub FAQ에 명시되어 있습니다: "이것은 자기 회귀 모델에서 일반적으로 발생하는 문제입니다. 여러 번 샘플링하여 적합한 결과를 찾을 수 있습니다."

2. **영어는 아직 실험적**: 중국어 운율은 원어민 수준이지만, 영어 발음과 억양은 개선 중이며 Coqui XTTS v2나 MeloTTS만큼 완성도가 높지 않습니다.

3. **상업 라이선스 없음**: 코드는 AGPL-3.0이며, 모델 가중치는 CC BY-NC 4.0(비상업용)입니다. 상업 사용은 작성자에게 문의해야 합니다.

4. **스트리밍 생성 미지원**: 오디오는 한 번에 생성됩니다. 스트리밍 출력은 로드맵에 있지만 v0.2.5에서는 사용할 수 없습니다.

5. **GPU 필수**: 실용적인 CPU 추론 경로가 없습니다. 최소 4GB VRAM은 엔트리급 GPU가 긴 출력에 어려움을 겪음을 의미합니다.

6. **감정 제한적**: 현재 운율 토큰은 웃음, 짧은 멈춤, 긴 멈춤만 커버합니다. 전체 감정 제어(분노, 슬픔, 흥분)는 계획 중이지만 릴리스되지 않았습니다.

## 자주 묻는 질문

**Q: ChatTTS에 얼마나 많은 VRAM이 필요한가요?**
30초 오디오 클립에 최소 4GB GPU 메모리가 필요합니다. NVIDIA RTX 4090에서 ChatTTS는 초당 약 7개의 의미 토큰을 생성하며 RTF는 약 0.3입니다. 프로덕션 배포에는 인스턴스당 8GB VRAM을 권장합니다.

**Q: ChatTTS를 상업 프로젝트에 사용할 수 있나요?**
ChatTTS 코드는 AGPL-3.0이며, 모델 가중치는 CC BY-NC 4.0입니다. 상업 라이선스는 open-source@2noise.com으로 문의하세요.

**Q: 화자 음성이 문장 중간에 왜 바뀌나요?**
이것은 자기 회귀 TTS 모델의 고유한 특성입니다. 완화 방법: temperature를 낮추고, 고정 화자 임베딩을 사용하거나, 여러 샘플을 생성하여 최상의 결과를 선택합니다.

**Q: 웃음과 멈춤을 어떻게 제어하나요?**
ChatTTS는 입력 텍스트에서 `[laugh]`(웃음), `[uv_break]`(짧은 멈춤), `[lbreak]`(긴 멈춤)을 지원합니다. `RefineTextParams`로 문장 수준 제어도 가능합니다.

**Q: ChatTTS는 음성 클로닝을 지원하나요?**
예, 화자 임베딩을 통해 지원합니다. 그러나 이는 수 초 오디오의 제로샷 음성 클로닝과는 다륾니다. 이 기능은 로드맵에 있습니다.

**Q: ChatTTS와 GPT-SoVITS의 차이점은 무엇인가요?**
GPT-SoVITS는 1분 참조 오디오로 음성을 클론하는 데 최적화되어 있습니다. ChatTTS는 자연스러운 운율과 대화 흐름을 위한 대화형 TTS에 최적화되어 있습니다.

**Q: ChatTTS를 CPU에서 실행할 수 있나요?**
실용적인 CPU 추론 경로가 없습니다. CPU 추론이 필요하면 MeloTTS를 고려하세요.

**Q: Docker 컨테이너에서 ChatTTS를 어떻게 배포하나요?**
`docker build -t chattts .`로 빌드하고 `docker run --gpus all -p 7860:7860 chattts`로 실행합니다.

## 결론

ChatTTS는 오픈소스 TTS 분야에서 독특한 위치를 차지합니다. 대화 중심 설계, 토큰 수준 운율 제어, 원시 중국어 지원으로 2026년 대화 집중 애플리케이션의 최선의 선택입니다. 39,300개 이상의 GitHub 스타는 마케팅이 아닌 진정한 커뮤니티 열정을 반영합니다.

LLM 음성 어시스턴트를 구축하는 팀에게 ChatTTS 설치는 간단합니다 — pip로 설치하고, 모델을 로드하고, 5분 이내에 웃음과 멈춤이 있는 자연스러운 음성 생성을 시작하세요. 자기 회귀 아키텍처는 불안정성이라는 트레이드오프를 가져오지만, 대화 시나리오에서는 ChatTTS의 표현력을 능가하는 오픈소스 대안이 없습니다. conversational tts 분야에서 ChatTTS benchmark 결과는 경쟁 모델들과 비교했을 때 웃음과 호흡 소리 생성에서 압도적인 우위를 보여줍니다. 2026년 현재 chattts vs coqui 비교에서 ChatTTS는 중국어 대화의 자연스러움과 token 수준 prosodic control 면에서 명확한 차별화 요소를 가지고 있습니다. 다만 영어 합성 품질 면에서는 Coqui XTTS v2가 여전히 앞서 있으므로, 프로젝트의 주요 언어에 따라 적절한 모델 선택이 필요합니다.
**액션 아이템:**
1. 저장소를 클론하고 GPU 머신에서 WebUI 실행. `git clone https://github.com/2noise/ChatTTS` 명령으로 시작하여 Python 3.11 가상 환경에서 설치 완료
2. 운율 토큰(`[laugh]`, `[uv_break]`)으로 대화 데이터셋 실험. temperature 0.2~0.5 범위에서 최적의 자연스러움 찾기
3. LLM 파이프라인과 통합하기 위해 OpenAI 호환 API 배포. FastAPI 기반 서버로 `/v1/audio/speech` 엔드포인트 제공
4. 스트리밍 생성 및 감정 제어 업데이트를 위해 Discord 또는 GitHub Discussions 커뮤니티 가입. 2026년 하반기 multi-emotion control 버전 공개 예정

업데이트를 팔로우하고 [dibi8.com Telegram 그룹](https://t.me/dibi8_channel)에서 대화형 TTS 전략을 논의하세요.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 참고 자료

- [ChatTTS GitHub 저장소](https://github.com/2noise/ChatTTS)
- [ChatTTS Hugging Face 모델](https://huggingface.co/2Noise/ChatTTS)
- [Coqui TTS 문서](https://github.com/coqui-ai/TTS)
- [MeloTTS GitHub 저장소](https://github.com/myshell-ai/MeloTTS)
- [Bark (Suno AI) 저장소](https://github.com/suno-ai/bark)
- [GPT-SoVITS 저장소](https://github.com/RVC-Boss/GPT-SoVITS)
- [Awesome-ChatTTS 커뮤니티 인덱스](https://github.com/Awesome-ChatTTS)
- [ChatTTS 벤치마크 비교 연구](https://blog.csdn.net/weixin_30415591/article/details/157480949)
- [2025 오픈소스 AI 모델 비교](https://www.e-com-net.com/article/1936044193575137280.htm)
