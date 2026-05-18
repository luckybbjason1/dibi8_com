---
title: 'Ollama 완벽 가이드 2025: 로컬에서 LLM 실행하기 - 모든 하드웨어 가이드'
description: 'Ollama로 로컬에서 대규모 언어 모델을 실행하는 완벽 가이드. 설치, 모델 관리, REST API, LangChain 통합, 하드웨어 요구사항, Docker 배포까지 상세히 다룬다.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/ollama-local-llm-guide/
---

{</* resource-info */>}

Ollama는 로컬 환경에서 대규모 언어 모델(LLM)을 가장 쉽게 실행할 수 있게 해주는 오픈소스 도구다. 2024년 초 출시 이후 GitHub Star 86,000개 이상을 기록하며, 개발자와 기업 모두에게 사실상의 로컬 LLM 실행 표준으로 자리잡았다. 이 가이드는 macOS, Windows, Linux 전 플랫폼 설치부터 모델 관리, API 통합, 프로덕션 배포까지 전 과정을 담는다.

## Ollama란 무엇인가?

Ollama는 Go 언어로 작성된 경량 실행 환경으로, Llama, Mistral, Qwen 등 주요 오픈소스 LLM을 단일 명령어로 다운로드하고 실행할 수 있게 한다. 복잡한 CUDA 설정이나 Python 의존성 없이도 동작하며, REST API와 OpenAI 호환 엔드포인트를 기본 제공한다.

**왜 로컬 LLM을 실행해야 할까?**

- **데이터 프라이버시**: 민감한 데이터가 외부 서버로 전송되지 않음
- **비용 절감**: API 호출 비용 없이 무제한 사용 가능
- **지연 시간**: 인터넷 왕복 없이 빠른 응답 (10~50ms vs 200~500ms)
- **오프라인 사용**: 인터넷 연결 없이도 AI 기능 사용 가능
- **모델 커스터마이징**: 시스템 프롬프트와 파라미터를 자유롭게 조정

**Ollama vs 클라우드 LLM API:**

| 항목 | Ollama (로컬) | OpenAI API (클우드) |
|------|--------------|-------------------|
| **비용** | 하드웨어 비용만 | 토큰당 과금 |
| **데이터 프라이버시** | 완전 보장 | 서버로 데이터 전송 |
| **응답 속도** | 10~100ms | 200~2000ms |
| **모델 선택** | 100+ 오픈소스 모델 | OpenAI 모델만 |
| **인터넷 필요** | 불필요 | 필수 |
| **유지보수** | 직접 관리 | 제공자가 관리 |

## 전 플랫폼 설치 가이드

### macOS 설치

```bash
# Homebrew로 설치
brew install ollama

# 또는 공식 웹사이트에서 DMG 다운로드
# https://ollama.com/download
```

### Windows 설치

```powershell
# PowerShell 관리자 권한으로 실행
winget install Ollama.Ollama

# 또는 https://ollama.com/download 에서 설치 프로그램 다운로드
```

### Linux 설치

```bash
curl -fsSL https://ollama.com/install.sh | sh

# 수동 설치
sudo curl -L https://ollama.com/download/ollama-linux-amd64 -o /usr/local/bin/ollama
sudo chmod +x /usr/local/bin/ollama
```

### Docker로 실행

```bash
# CPU 전용
docker run -d -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama

# NVIDIA GPU 사용
docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama
```

### 설치 확인

```bash
ollama --version
# ollama version 0.5.4

ollama list
# NAME    ID    SIZE    MODIFIED
```

## 첫 번째 로컬 LLM 실행하기

### 모델 다운로드

```bash
# Llama 3.1 8B 모델 다운로드 (약 4.7GB)
ollama pull llama3.1

# Mistral 7B 모델 다운로드 (약 4.1GB)
ollama pull mistral

# 한국어에 강한 Qwen2.5 7B (약 4.4GB)
ollama pull qwen2.5:7b
```

### 대화형 실행

```bash
ollama run llama3.1
>>> 한국의 역사에 대해 3문장으로 설명해줘
한국은 ...
```

### REST API 사용

```bash
# curl로 API 호출
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.1",
  "prompt": "인공지능의 미래는?"
}'

# 채팅 API
curl http://localhost:11434/api/chat -d '{
  "model": "llama3.1",
  "messages": [{"role": "user", "content": "안녕하세요"}]
}'
```

### 모델 목록 관리

```bash
ollama list          # 설치된 모델 목록
ollama rm mistral    # 모델 삭제
ollama cp llama3.1 my-model  # 모델 복사
```

## 2025년 주요 Ollama 모델

| 모델명 | 제조사 | 파라미터 | VRAM 요구사항 | 특징 |
|--------|--------|---------|--------------|------|
| **Llama 3.1** | Meta | 8B | 6GB | 균형 잡힌 성능, 다국어 |
| **Llama 3.1** | Meta | 70B | 40GB | 고성능, 복잡한 추론 |
| **Mistral 7B** | Mistral AI | 7B | 6GB | 효율적, 코딩 우수 |
| **Mixtral 8x7B** | Mistral AI | 47B | 28GB | MoE 아키텍처 |
| **Qwen 2.5** | Alibaba | 7B | 6GB | 한국어, 중국어 우수 |
| **DeepSeek V3** | DeepSeek | 32B | 20GB | 코딩, 수학 강점 |
| **Gemma 2** | Google | 9B | 7GB | 경량, 효율적 |
| **Phi-4** | Microsoft | 14B | 10GB | 작은 크기, 높은 성능 |
| **CodeLlama** | Meta | 7B | 6GB | 코드 생성 특화 |

## 하드웨어 요구사항과 최적화

### 모델 크기별 RAM 요구사항

| 양자화 레벨 | 7B 모델 | 13B 모델 | 70B 모델 |
|------------|---------|---------|---------|
| **Q4_K_M** | 4.7GB | 8.7GB | 42GB |
| **Q5_K_M** | 5.6GB | 10.3GB | 49GB |
| **Q8_0** | 8.0GB | 14.8GB | 70GB |
| **FP16** | 14GB | 26GB | 140GB |

### GPU 가속 설정

**NVIDIA GPU:**
```bash
# CUDA가 자동으로 감지됨
ollama run llama3.1  # GPU 자동 사용

# 특정 GPU 지정
CUDA_VISIBLE_DEVICES=0 ollama serve
```

**AMD GPU (ROCm):**
```bash
HSA_OVERRIDE_GFX_VERSION=10.3.0 ollama serve
```

**Apple Silicon:**
M1/M2/M3/M4 칩의 통합 메모리와 Neural Engine을 자동으로 활용한다. Unified Memory 아키텍처 덕분에 16GB Mac에서도 70B 모델의 Q4 양자화 버전을 실행할 수 있다.

### CPU 전용 환경 팁

- 8코어 이상의 CPU 권장
- AVX2 명령어 세트 지원 확인
- `OLLAMA_NUM_PARALLEL=1`로 병렬 처리 제한하여 메모리 절약

## 개발자를 위한 Ollama

### REST API 상세

```bash
# 생성 API (스토리밍)
curl -X POST http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3.1",
    "prompt": "Python으로 피변치 수열을",
    "stream": true,
    "options": {
      "temperature": 0.7,
      "num_predict": 256
    }
  }'

# 임베딩 API
curl http://localhost:11434/api/embeddings \
  -H "Content-Type: application/json" \
  -d '{"model": "llama3.1", "prompt": "임베딩할 텍스트"}'
```

### Python 통합

```bash
pip install ollama
```

```python
import ollama

# 텍스트 생성
response = ollama.generate(
    model="llama3.1",
    prompt="Python의 장점을 설명해줘",
    options={"temperature": 0.8}
)
print(response["response"])

# 채팅
chat = ollama.chat(
    model="llama3.1",
    messages=[{"role": "user", "content": "안녕하세요"}]
)

# 임베딩
embedding = ollama.embeddings(
    model="llama3.1",
    prompt="임베딩할 문장"
)["embedding"]
```

### LangChain과 Ollama 연동

```python
from langchain_ollama import ChatOllama, OllamaEmbeddings

llm = ChatOllama(model="llama3.1", temperature=0.7)
embeddings = OllamaEmbeddings(model="llama3.1")

# RAG 체인 구성
response = llm.invoke("LangChain이란 무엇인가?")
```

### OpenAI 호환 API

Ollama는 `/v1/chat/completions` 엔드포인트를 제공하여 OpenAI SDK와 호환된다.

```python
from openai import OpenAI

client = OpenAI(base_url="http://localhost:11434/v1", api_key="ollama")

response = client.chat.completions.create(
    model="llama3.1",
    messages=[{"role": "user", "content": "안녕하세요"}]
)
```

## 고급 Ollama 기능

### 커스텀 Modelfile 생성

```dockerfile
FROM llama3.1

SYSTEM """당신은 전문적인 소프트웨어 엔지니어 어시스턴트입니다.
항상 한국어로 응답하고, 코드 예제를 포함하세요."""

PARAMETER temperature 0.2
PARAMETER top_p 0.9
PARAMETER num_ctx 4096
```

```bash
ollama create my-coder -f Modelfile
ollama run my-coder
```

### 멀티 모델 서빙

```bash
# 터미널 1
ollama serve

# 터미널 2 - 여러 모델 동시 호출 가능
curl http://localhost:11434/api/chat -d '{"model": "llama3.1", ...}'
curl http://localhost:11434/api/chat -d '{"model": "mistral", ...}'
```

### 동시 요청 처리

Ollama 0.4부터 `OLLAMA_NUM_PARALLEL` 환경 변수로 동시 처리 수를 조정할 수 있다.

```bash
OLLAMA_NUM_PARALLEL=4 ollama serve
```

## 프로덕션 환경에서의 Ollama

### Docker Compose 구성

```yaml
version: "3.8"
services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    volumes:
      - ollama-data:/root/.ollama
    ports:
      - "11434:11434"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    environment:
      - OLLAMA_NUM_PARALLEL=4
      - OLLAMA_MAX_LOADED_MODELS=2

volumes:
  ollama-data:
```

### 로드 밸런싱

고가용성을 위해 여러 Ollama 인스턴스를 NGINX 로드 밸런서 뒤에 배치한다.

```nginx
upstream ollama {
    server localhost:11434;
    server localhost:11435;
    server localhost:11436;
}

server {
    listen 80;
    location / {
        proxy_pass http://ollama;
    }
}
```

### 모니터링과 로깅

Ollama는 Prometheus 메트릭 엔드포인트를 기본 제공하지 않는다. 대신 `ollama ps` 명령으로 현재 로드된 모델과 메모리 사용량을 확인할 수 있다. 프로덕션에서는 컨테이너 로그 수집과 메모리/CPU 모니터링을 필수적으로 구성해야 한다.

### 보안 모범 사례

- Ollama API를 외부에 직접 노출하지 않는다
- 리버스 프록시 뒤에 배치하고 HTTPS를 적용한다
- API 키 인증 레이어를 추가한다
- 민감한 모델 파라미터는 환경 변수로 관리한다

## Ollama 대안 비교

| 도구 | 강점 | 약점 | 적합한 사용례 |
|------|------|------|-------------|
| **Ollama** | 설치 간편, API 통합 | 확장성 제한 | 개발, 소규모 배포 |
| **LM Studio** | GUI, 모델 탐색 용이 | GUI 의존 | 초보자, 실험 |
| **llama.cpp** | 최고 성능, 가장 낮은 지연 | CLI 복잡 | 고성능 추론 |
| **vLLM** | 배치 처리, 고성능 | 설정 복잡 | 프로덕션 서버 |
| **GPT4All** | 크로스 플랫폼 GUI | 모델 선택 제한 | 입문자 |

## 일반적인 문제 해결

**추론 속도가 느릴 때:**

- GPU가 올바르게 감지되었는지 `ollama ps`로 확인
- 더 낮은 양자화 레벨의 모델 사용 (Q5 → Q4)
- `num_ctx`를 2048 이하로 줄여 메모리 사용 감소

**모델 다운로드 실패:**

- `~/.ollama` 디렉토리의 남은 용량 확인
- 프록시 환경 시 `HTTP_PROXY`, `HTTPS_PROXY` 환경 변수 설정
- `ollama pull` 명령 재실행

**메모리 부족:**

- 더 작은 모델 선택 (13B → 7B)
- 양자화 레벨 낮추기 (Q8 → Q4)
- `OLLAMA_MAX_LOADED_MODELS=1`로 동시 로드 모델 수 제한

**네트워크/프록시 문제:**

```bash
export HTTP_PROXY=http://proxy:port
export HTTPS_PROXY=http://proxy:port
ollama pull llama3.1
```

---

## 자주 묻는 질문 (FAQ)

**Ollama는 완전 물론인가요?**
네, MIT 라이선스 기반의 오픈소스 소프트웨어입니다. 소프트웨어 자체는 물론이며, 모델 파일은 각 모델의 라이선스를 따릅니다. Llama, Mistral 등 대부분의 오픈소스 모델은 상용 사용이 가능합니다.

**Ollama를 실행하는 데 어떤 하드웨어가 필요한가요?**
최소 8GB RAM과 10GB 디스크 공간이 필요합니다. GPU는 필수는 아니지만 권장됩니다. 7B 모델 기준 NVIDIA GPU 6GB VRAM이면 부드럽게 실행됩니다. Apple Silicon Mac은 Unified Memory 덕분에 효율적으로 실행됩니다.

**GPU 없이 Ollama를 실행할 수 있나요?**
네, CPU 전용 모드로 실행할 수 있습니다. 다만 7B 모델 기준 토큰 생성 속도가 GPU 대비 5~10배 느립니다. AVX2를 지원하는 최신 CPU에서 양호한 성능을 얻을 수 있습니다.

**LangChain과 Ollama를 함께 사용하려면?**
`langchain-ollama` 패키지를 설치하고 `ChatOllama`와 `OllamaEmbeddings` 클래스를 사용합니다. LangChain의 모든 체인과 에이전트 패턴을 로컬 모델로 실행할 수 있습니다. OpenAI 호환 API 엔드포인트도 제공됩니다.

**코딩에 가장 적합한 Ollama 모델은 무엇인가요?**
2025년 기준 CodeLlama, DeepSeek Coder, Qwen 2.5 Coder가 코딩 작업에서 우수한 성능을 보입니다. 7B 크기에서는 Qwen 2.5 Coder가 Python, JavaScript, SQL에서 균형 잡힌 성능을 제공합니다. 13B 이상에서는 DeepSeek V3가 가장 강력합니다.

## 참고 자료

- [Ollama 공식 웹사이트](https://ollama.com)
- [Ollama GitHub 저장소](https://github.com/ollama/ollama)
- [Ollama Python 라이브러리](https://github.com/ollama/ollama-python)
- [LangChain Ollama 통합 문서](https://python.langchain.com)
- [Hugging Face 모델 허브](https://huggingface.co)

---

## 추천 인프라

위 도구들을 24/7 안정 운영하려면 인프라가 중요하다:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연. dibi8.com 자체 호스팅 IDC.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

