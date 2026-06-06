---
title: "DS4 vs Ollama vs llama.cpp: 128GB Mac에서 딥시크 V4 Flash 로컬 추론 벤치마크"
description: "Redis 창시자 antirez가 개발한 DS4 추론 엔진을 알아보세요. DeepSeek V4 Flash 로컬 배포, macOS/Linux 설치 튜토리얼, Ollama/llama.cpp 성능 비교, 코드 예제, 100만 토큰 장문 맥락 활용 사례를 상세히 설명합니다."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - C++
  - Go
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: ""
backup_url: ""
github_repo: ""
stars: 0
maintainer: ""
last_maintained: "2026-05-15"
featureImage: ""
draft: false
faqs:
  - q: 'DS4(DwarfStar 4)란 무엇이며, 누가 만들었나요?'
    a: 'DS4(DwarfStar 4)는 Apple Metal 및 NVIDIA CUDA 하드웨어에서 DeepSeek V4 Flash 모델을 로컬로 실행하기 위해 특별히 제작된 소형 네이티브 추론 엔진입니다. Redis를 만든 것으로 유명한 이탈리아 프로그래머 Salvatore Sanfilippo(antirez)가 개발했습니다.'
  - q: 'DS4로 DeepSeek V4 Flash를 실행하려면 RAM이 얼마나 필요한가요?'
    a: '2-bit(q2) 가중치를 실행하려면 최소 96GB RAM이 필요하며, 128GB를 권장합니다. 4-bit(q4) 가중치는 256GB 이상이 필요하므로 일반 소비자용 노트북에서는 대부분 사용이 불가능합니다.'
  - q: 'DeepSeek V4 Flash 실행 시 DS4는 Ollama 및 llama.cpp와 어떻게 다른가요?'
    a: 'DS4는 단일 모델에 집중하기 때문에 비대칭 양자화, 압축 KV 캐시, 커스텀 Metal 커널을 통해 동일한 Apple Silicon 하드웨어에서 Ollama보다 보통 20–40% 더 높은 프리필 처리량을 제공합니다. Ollama와 달리 KV 캐시를 디스크에 영속적으로 저장하는 반면, Ollama는 종료 시 컨텍스트를 삭제합니다. DS4는 llama.cpp와 GGML을 기반으로 구축되었음을 공개적으로 인정하지만, 범용 GGUF 지원은 생략하고 최적화된 레이아웃을 하드코딩합니다.'
  - q: 'DS4의 디스크 KV 캐시란 무엇이며, 왜 중요한가요?'
    a: 'DS4는 KV 캐시를 일급 디스크 시민으로 취급하여, 모든 상태를 RAM에 유지하는 대신 빠른 SSD에 체크포인트를 기록합니다. 이를 통해 RAM이 제한된 머신에서도 100K–1M 토큰 컨텍스트 윈도우를 지원하고, 에이전트 워크플로우가 프롬프트를 재처리하지 않고도 긴 대화를 즉시 재개할 수 있습니다.'
  - q: 'DS4는 OpenAI 호환 API 서버를 제공하나요?'
    a: '네. DS4를 빌드하면 http://127.0.0.1:8000 에서 OpenAI 및 Anthropic 호환 HTTP API를 노출하는 ds4-server 바이너리가 생성됩니다. /v1/chat/completions, /v1/completions, /v1/messages 등의 엔드포인트를 포함하며, OpenAI 스타일의 함수 호출을 지원하고 OpenCode, Pi, Claude Code 등의 에이전트 프레임워크와 연동됩니다.'
---

{</* resource-info */>}

# DS4 (DwarfStar 4): DeepSeek V4 Flash 로컬 추론 완벽 가이드

**Salvatore Sanfilippo** — 전설적인 **Redis 창시자** — 가 로컬 대형 언어 모델 추론에 관심을 돌렸을 때, 전 세계 개발자 커뮤니티는 주목했습니다. 그의 최신 오픈소스 프로젝트인 **DS4**(DwarfStar 4)는 이미 GitHub에서 **8,318개의 Star**를 획득했으며, 고급 소비자 하드웨어에서 **DeepSeek V4 Flash**를 로컬로 실행하기 위한 필수 추론 엔진으로 빠르게 자리 잡고 있습니다.

범용 GGUF 실행기나 다른 런타임을 감싸는 래퍼와 달리, DS4는 의도적으로 좁은 접근 방식을 취합니다. 이것은 **특정 모델을 위해 처음부터 구축된 추론 엔진**으로, **Apple Metal** 및 **NVIDIA CUDA**에서 DeepSeek V4 Flash의 모든 성능을 끌어내는 것을 목표로 합니다. 128GB 통합 메모리를 탑재한 MacBook Pro나 강력한 GPU를 장착한 Linux 워크스테이션이 있다면, DS4는 올해 접하게 될 가장 흥미로운 로컬 LLM 프로젝트가 될 수 있습니다.

이 포괄적인 가이드에서는 DS4의 특별한 점, 기술 아키텍처가 Ollama와 llama.cpp 같은 대안과 어떻게 다른지, 그리고 단계별 설치 방법, 성능 벤치마크, 코드 예제, 실제 사용 사례를 살펴보겠습니다.

---

## 로컬 추론 벤치마크: DS4 vs Ollama vs llama.cpp
DeepSeek V4 Flash 같은 괴물 모델을 돌리려면 하드코어한 최적화가 필수입니다. M-시리즈 Mac에서 DS4가 경쟁자들을 어떻게 박살내는지 보십시오:

| 프레임워크 | 2-bit 양자화(Quantization) 속도 | KV Cache 영구 보존 | 하드웨어 가속 최적화 | 설치 난이도 |
| :--- | :--- | :--- | :--- | :--- |
| **DwarfStar 4 (DS4)** | **초고속 (35+ t/s)** | **지원 (SSD 디스크에 저장)** | Metal / CUDA 네이티브 지원 | 보통 |
| **Ollama** | 느림 | 미지원 (종료 시 RAM 초기화)| 범용 호환성에만 집중 | 매우 쉬움 |
| **llama.cpp** | 보통 | 부분 지원 | 수동 컴파일 환경 세팅 필요 | 극악무도 |


## DS4란 무엇이며, 누가 만들었나?

**DS4**는 **DwarfStar 4**의 약자로, **DeepSeek V4 Flash** 전용으로 설계된 경량 네이티브 추론 엔진입니다. 이 프로젝트는 전 세계에서 가장 널리 사용되는 인메모리 데이터 저장소 중 하나인 **Redis**를 창시한 이탈리아 프로그래머 **Salvatore Sanfilippo**(GitHub: [antirez](https://github.com/antirez))가 개발했습니다.

Sanfilippo의 DS4 접근 방식은 그의 특징 그대로 선명한 의견을 담고 있습니다. 또 다른 범용 모델 로더를 만드는 대신, 그는 **하나의 모델** — DeepSeek V4 Flash — 만을 로컬 하드웨어에서 예외적으로 잘 실행되도록 전념하기로 선택했습니다. 이 프로젝트는 프레임워크도, 래퍼도, 범용 GGUF 실행기도 아닙니다. 이것은 **DeepSeek V4 Flash 전용 Metal 및 CUDA 그래프 실행 엔진**으로, 사용자 정의 모델 로딩, 프롬프트 렌더링, KV 상태 관리, 서버 API 접착층을 통합했습니다.

> "llama.cpp와 GGML이 없었다면 이 프로젝트는 존재하지 않았을 것입니다." Sanfilippo는 Georgi Gerganov와 llama.cpp 커뮤니티에 대한 깊은 감사를 표하며 인정했습니다. DS4는 해당 프로젝트에서 양자화 형식, 커널 아이디어, GGUF 생태계 지식을 차용했지만, 자체 최적화된 실행 경로를 구현했습니다.

### 왜 DeepSeek V4 Flash인가?

Sanfilippo는 DeepSeek V4 Flash가 로컬 배포를 위해 독특하게 매력적인 모델이라고 믿습니다. 그 이유는 다음과 같습니다.

1. **효율성으로 얻는 속도**: 추론 시 활성화되는 파라미터가 적어, 많은 작은 Dense 모델보다 원시 처리량이 뛰어납니다.
2. **비례적 사고 깊이**: 사고 모드에서 추론 과정의 길이는 문제 복잡도에 비례하여 조정됩니다 — 종종 비슷한 모델의 1/5에 불과한 사고 토큰만 사용합니다. 이는 다른 모델이 실질적으로 사용 불가능한 조건에서도 DeepSeek V4 Flash를 활용할 수 있게 합니다.
3. **100만 토큰 맥락 윈도우**: 오픈 가중치 모델 중 가장 큰 맥락 윈도우 중 하나로, 전체 코드베이스, 책 전권, 긴 대화 기록을 단일 프롬프트에 담을 수 있습니다.
4. **깊은 지식**: 284B 파라미터는 지식의 경계에서 27B나 35B 모델보다 훨씬 더 많은 것을 알고 있습니다.
5. **뛰어난 작성 품질**: 사용자들은 영어와 이탈리아어 등에서 "거의 프론티어 수준의 모델처럼 느껴진다"고 보고합니다.
6. **압축된 KV 캐시**: 로컬 컴퓨터에서 장문 맥락 추론을 가능하게 하고 **디스크 KV 캐시 지속성**을 지원합니다 — 이는 에이전트 워크플로우에 게임 체인저입니다.
7. **2-bit 양자화 실현 가능성**: 비대칭 양자화(라우팅된 전문가 계층만 양자화)를 사용할 때, 2-bit 가중치는 놀라울 정도로 잘 작동하여 96-128GB 메모리의 MacBook에서 실행됩니다.

---

## 기술 아키텍처: Metal 대 CUDA 최적화

DS4의 아키텍처는 명확한 설계 철학을 반영합니다: **목표 하드웨어의 성능을 극대화**하되, 그것이 범용성을 희생하는 것을 의미하더라도 말입니다. 이 프로젝트는 세 가지 빌드 타겟을 유지합니다.

| 빌드 타겟 | 플랫폼 | 용도 |
|---------|--------|------|
| `make` | macOS | Metal 최적화 프로덕션 빌드 |
| `make cuda-spark` | Linux (DGX Spark / GB10) | NVIDIA GB10 시스템용 CUDA |
| `make cuda-generic` | Linux (기타 CUDA GPU) | 일반 CUDA GPU 지원 |
| `make cpu` | 모든 플랫폼 | 참조/디버그 전용 |

### macOS의 Metal 백엔드

Metal 백엔드는 DS4의 macOS **주요 최적화 타겟**입니다. 이는 Apple의 통합 메모리 아키텍처를 활용하여, 독립형 GPU 설정을 괴롭히는 PCIe 전송 병목 현상을 제거합니다. 512GB RAM을 탑재한 Mac Studio M3 Ultra에서 DS4는 다음을 달성합니다.

- **468 토큰/초 프리필 속도** (긴 프롬프트, 11,709 토큰)
- **36.86 토큰/초 생성 속도** (q2 양자화)
- **448 토큰/초 프리필** 및 **35.5 토큰/초 생성** (q4 양자화)

이 수치는 동등한 하드웨어에서 llama.cpp나 Ollama를 사용하는 사용자가 얻는 성능과 경쟁하며 — 경우에 따라서는 초과합니다 — 특히 DS4의 압축 KV 캐시와 청크 프리필이 빛을 발하는 장문 맥락 워크로드에서 그렇습니다.

### Linux의 CUDA 백엔드

Linux 워크스테이션용으로 DS4는 두 가지 CUDA 빌드 경로를 제공합니다. `cuda-spark` 타겟은 NVIDIA의 DGX Spark(GB10) 플랫폼에 최적화되어 있고, `cuda-generic`은 더 넓은 범위의 로컬 CUDA GPU를 지원합니다. 128GB RAM을 탑재한 DGX Spark GB10에서 엔진은 q2 가중치로 **343 토큰/초 프리필** 및 **13.75 토큰/초 생성**에 도달합니다.

CUDA 경로는 Metal 빌드와 동일한 그래프 실행 엔진, KV 캐시 압축, API 서버를 공유하여 플랫폼 간 일관된 동작을 보장합니다.

### CPU 경로: 진단 전용

DS4에는 CPU 백엔드가 포함되어 있지만, Sanfilippo는 명확히 합니다: **"CPU 경로를 프로덕션 타겟으로 취급하지 마십시오."** 이는 정확성 검증, 토크나이저 진단, 회귀 테스트를 위해서만 존재합니다. 사실, 현재 macOS 버전에서 CPU 경로는 가상 메모리 구현의 커널 버그를 트리거하여 시스템 충돌을 일으킬 수 있습니다 — 이것은 여전히 알파 품질 소프트웨어라는 뚜렷한 경고입니다.

### 핵심 아키텍처 혁신

1. **비대칭 2-bit 양자화**: 모든 계층의 품질을 균일하게 저하시키는 양자화와 달리, DS4의 q2 양자화는 라우팅된 MoE의 up/gate 프로젝션에 `IQ2_XXS`를, down 프로젝션에 `Q2_K`를 적용하고, 공유 전문가, 프로젝션, 라우팅 계층은 그대로 둡니다. 이는 가장 중요한 곳에서 품질을 보존합니다.

2. **디스크 지속성이 있는 압축 KV 캐시**: DS4는 KV 캐시를 "일급 디스크 시민"으로 취급합니다. KV 상태가 반드시 RAM에 상주해야 한다고 가정하지 않고, 체크포인트를 고속 SSD에 기록합니다. 이는 메모리가 제한된 기계에서 10만~30만(심지어 100만) 토큰 맥락 윈도우를 가능하게 합니다.

3. **정확한 DSML 도구 호출 재생**: 에이전트 통합을 위해, DS4는 각 도구 호출에 대해 모델이 생성한 정확한 DSML 텍스트를 추측할 수 없는 ID를 키로 기억합니다. 상태 비저장 클라이언트가 도구 결과를 다시 보낼 때, 서버는 정확한 바이트를 재생하여 접두사 불일치와 비싼 재계산을 피합니다.

4. **모델 전용 그래프 실행기**: 모든 GGUF 파일을 지원하려고 하지 않음으로써, DS4는 범용 텐서 디스패치 오버헤드를 제거하고, DeepSeek V4 Flash의 MoE 아키텍처에 대해 최적의 메모리 레이아웃과 커널 퓨전 전략을 하드코딩할 수 있습니다.

---

## macOS 및 Linux 설치 가이드

### 시스템 요구사항

**macOS:**
- macOS 14+ (Sonoma 이상)
- Apple Silicon Mac (M1/M2/M3/M4 또는 Ultra 변형)
- q2 가중치 실행을 위한 **최소 96GB 메모리**; **128GB 권장**
- q4 가중치 실행을 위한 **256GB+ 메모리**
- Xcode Command Line Tools

**Linux (CUDA):**
- Ubuntu 22.04+ 또는 호환 배포판
- CUDA 지원 NVIDIA GPU
- CUDA Toolkit 12.x+
- q2 실행을 위한 **96GB+ 시스템 메모리**; q4는 **256GB+**
- `build-essential`, `curl`, `git`

### 1단계: 저장소 클론

```bash
git clone https://github.com/antirez/ds4.git
cd ds4
```

### 2단계: 모델 가중치 다운로드

DS4는 이 프로젝트 전용으로 제작된 GGUF 파일에서만 작동합니다. 제공된 다운로드 스크립트를 사용하세요.

```bash
# 96-128GB 메모리 머신용 (권장)
./download_model.sh q2-imatrix

# 256GB+ 메모리 머신용
./download_model.sh q4-imatrix

# 선택: 투기적 디코딩 지원
./download_model.sh mtp
```

스크립트는 Hugging Face(`antirez/deepseek-v4-gguf`)에서 가져와 `./gguf/`에 파일을 저장하고 `./ds4flash.gguf`에 심볼릭 링크를 생성합니다.

### 3단계: 엔진 빌드

**macOS (Metal):**
```bash
make
```

**Linux (CUDA — DGX Spark / GB10):**
```bash
make cuda-spark
```

**Linux (CUDA — 일반 GPU):**
```bash
make cuda-generic
```

**CPU 전용 (진단 전용):**
```bash
make cpu
```

빌드는 두 개의 바이너리를 생성합니다.
- `./ds4` — 대화형 CLI
- `./ds4-server` — OpenAI/Anthropic 호환 HTTP API 서버

### 4단계: 설치 확인

```bash
# 빠른 일회성 테스트
./ds4 -p "CAP 정리를 한 문단으로 설명하세요."

# 모든 옵션 확인
./ds4 --help
./ds4-server --help
```

---

## 성능 벤치마크: DS4 대 Ollama 대 llama.cpp

LLM 추론 벤치마킹은 notoriously 까다롭습니다 — 수치는 프롬프트 길이, 양자화, 배치 크기, 하드웨어에 따라 달라집니다. 그럼에도 불구하고 DS4의 공개된 수치는 인상적인 성능, 특히 **장문 맥락 프리필**에서 그렇습니다.

### DS4 공식 벤치마크 (Metal, `--ctx 32768`, 탐욕 디코딩, `-n 256`)

| 머신 구성 | 양자화 | 프롬프트 | 프리필 속도 | 생성 속도 |
|---------|--------|---------|-----------|----------|
| MacBook Pro M3 Max, 128GB | q2 | 짧은 프롬프트 | 58.52 t/s | 26.68 t/s |
| MacBook Pro M3 Max, 128GB | q2 | 11,709 토큰 | **250.11 t/s** | 21.47 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | 짧은 프롬프트 | 84.43 t/s | 36.86 t/s |
| Mac Studio M3 Ultra, 512GB | q2 | 11,709 토큰 | **468.03 t/s** | 27.39 t/s |
| Mac Studio M3 Ultra, 512GB | q4 | 짧은 프롬프트 | 78.95 t/s | 35.50 t/s |
| DGX Spark GB10, 128GB | q2 | 7,047 토큰 | 343.81 t/s | 13.75 t/s |

### DS4와 다른 솔루션 비교

**Ollama 대비:**
Ollama는 빠른 시작과 수백 개 모델 지원에서 탁월합니다. 그러나 범용 실행기로서 DS4가 사용하는 모델별 최적화를 적용할 수 없습니다. DeepSeek V4 Flash 특화로 DS4의 비대칭 양자화 조합, 압축 KV 캐시, 사용자 정의 Metal 커널은 일반적으로 동등한 Apple Silicon 하드웨어에서 **20-40% 더 빠른 프리필 처리량**을 제공합니다.

**llama.cpp 대비:**
llama.cpp는 로컬 LLM 추론을 가능하게 한 기초 프로젝트입니다. DS4는 llama.cpp와 GGML에 대한 빚을 공개적으로 인정합니다. DS4가 차별화되는 점은 **단일 모델 집중**입니다: 임의의 GGUF 파일을 지원하지 않음으로써, DS4는 텐서 레이아웃을 하드코딩하고, 범용 디스패치 오버헤드를 제거하며, 공식 DeepSeek API logits에 대해 정확성을 검증할 수 있습니다. DeepSeek V4 Flash만 신경 쓰는 사용자에게 DS4는 내장 서버 API, 디스크 KV 캐싱, 에이전트 통합이 포함된 더 "완성도 높은" 경험을 제공합니다.

**결론:** 다양한 모델을 지원하는 스위스 아미 나이프를 원한다면 Ollama나 llama.cpp가 더 나은 선택입니다. Mac Studio나 CUDA 워크스테이션에서 DeepSeek V4 Flash를 가능한 한 가장 빠르고 안정적으로 실행하고 싶다면, DS4는 정확히 그 목적을 위해 설계되었습니다.

---

## 추론 코드 예제

### 일회성 CLI 프롬프트

```bash
./ds4 -p "병합 정렬을 구현하는 Python 함수를 작성하세요."
```

### 대화형 채팅 세션

```bash
./ds4
```

이는 지속적인 KV 상태를 가진 다중 턴 대화를 시작합니다. 유용한 명령어:
- `/help` — 사용 가능한 명령어 표시
- `/think` — 사고 모드 활성화 (기본값)
- `/think-max` — 최대 추론 노력
- `/nothink` — 더 빠른 응답을 위해 사고 비활성화
- `/ctx 100000` — 맥락 윈도우 크기 설정
- `/read FILE` — 파일 내용을 맥락에 포함
- `/quit` — 종료

### 서버 모드 및 OpenAI 호환 API

```bash
./ds4-server \
  --ctx 100000 \
  --kv-disk-dir /tmp/ds4-kv \
  --kv-disk-space-mb 8192
```

서버는 `http://127.0.0.1:8000`에서 시작하며 다음 엔드포인트를 제공합니다.
- `GET /v1/models`
- `POST /v1/chat/completions`
- `POST /v1/completions`
- `POST /v1/messages` (Anthropic 호환)

### cURL 예제 (채팅 완성)

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [
      {"role": "user", "content": "Redis의 세 가지 설계 원칙을 나열하세요."}
    ],
    "stream": true
  }'
```

### Python 클라이언트 예제

```python
import openai

client = openai.OpenAI(
    base_url="http://127.0.0.1:8000/v1",
    api_key="dsv4-local"
)

response = client.chat.completions.create(
    model="deepseek-v4-flash",
    messages=[
        {"role": "system", "content": "당신은 유용한 프로그래밍 도우미입니다."},
        {"role": "user", "content": "이 함수를 리스트 컴프리헨션을 사용하도록 리팩토링하세요."}
    ],
    stream=True,
    temperature=0.7
)

for chunk in response:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

### 도구 사용 예제

DS4는 OpenAI 스타일 함수 호출을 지원합니다. 서버는 도구 스키마를 DeepSeek의 DSML 형식으로 자동 변환하고 결과를 매핑합니다.

```bash
curl http://127.0.0.1:8000/v1/chat/completions \
  -H 'Content-Type: application/json' \
  -d '{
    "model": "deepseek-v4-flash",
    "messages": [{"role": "user", "content": "도쿄의 날씨는 어떤가요?"}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "get_weather",
        "parameters": {
          "type": "object",
          "properties": {
            "location": {"type": "string"}
          },
          "required": ["location"]
        }
      }
    }],
    "tool_choice": "auto"
  }'
```

---

## 사용 사례: DS4가 빛나는 분야

### 1. 로컬 AI 개발 및 코딩 에이전트

DS4는 **코딩 에이전트 워크플로우**를 위해 명시적으로 설계되었습니다. OpenAI 호환 서버 API는 **OpenCode**, **Pi**, **Claude Code**와 같은 인기 있는 에이전트 프레임워크와 작동합니다. 디스크 KV 캐시는 비싼 초기 프리필(에이전트 설정의 경우 종종 25K+ 토큰) 이후, 후속 턴이 처음부터 다시 계산하는 대신 캐시된 접두사를 재사용하도록 합니다.

### 2. 프라이버시 우선 LLM 배포

민감한 데이터를 다루는 조직 — 법률 문서, 의료 기록, 독점 소스 코드 — 에게 DS4로 DeepSeek V4 Flash를 로컬에서 실행하는 것은 **데이터가 당신의 머신을 절대 떠나지 않음**을 보장합니다. API 키를 관리할 필요도, 속도 제한도, 공급업체 종속도 없습니다.

### 3. 엣지 배포

2-bit 양자화가 96GB 시스템에서 실행 가능하게 하고, 디스크로 오버플로우되는 압축 KV 캐시를 통해 DS4는 **엣지 하드웨어**에 프론티어급 LLM 기능을 제공합니다. 이전에는 클라우드 API가 필요했던 기능을 이제 안전한 시설의 Mac Studio가 인터넷 연결 없이 처리할 수 있습니다.

### 4. 장문 맥락 연구 및 분석

100만 토큰 맥락 윈도우는 이전에는 실용적이지 않았던 가능성을 엽니다.
- 전체 법률 사건 파일을 한 번에 분석
- 전체 diff 맥락이 포함된 Git 저장소 기록 검토
- 책, 연구 논문, 다중 문서 코퍼스 처리
- 월간 이상의 대화 기록을 잘라내지 않고 유지

### 5. 비용 최적화

토큰당 0달러의 비용으로, DS4를 사용한 로컬 추론은 고처리량 워크플로우의 API 비용을 제거합니다. 사전 하드웨어 투자(고급 Mac이나 워크스테이션)는 매월 수백만 토큰을 처리할 때 빠르게 상환됩니다.

---

## 알아야 할 한계점

DS4는 강력하지만, 그 제약을 이해하는 것이 중요합니다.

1. **알파 품질**: Sanfilippo는 코드가 알파 품질임을 명확히 했습니다. 존재 기간이 짧고 안정화까지 수 개월이 걸릴 것입니다. 버그와 거친 부분을 예상하세요.

2. **단일 모델 지원**: DS4는 이 프로젝트를 위해 특별히 생성된 DeepSeek V4 Flash GGUF에서만 실행됩니다. 임의의 GGUF 파일이나 다른 모델은 로드할 수 없습니다.

3. **높은 메모리 요구사항**: q2 가중치 실행에 96-128GB 메모리, q4에 256GB+가 필요합니다. 이는 대부분의 소비자용 노트북을 제외합니다.

4. **macOS에서 CPU 경로 불가**: macOS 커널 VM 버그가 CPU 추론 실행 시 충돌을 일으킵니다. Metal이 macOS에서 유일하게 실행 가능한 경로입니다.

5. **요청 배치 없음**: 서버는 한 번에 하나의 추론 요청만 처리합니다. 동시 요청은 대기열에 들어갑니다.

6. **MTP 투기적 디코딩은 실험적**: 선택적 MTP 경로는 현재 의미 있는 생성 속도 향상이 아닌, 최대한 약간의 속도 향상만 제공합니다.

7. **AI 보조 개발**: 코드베이스는 GPT-5.5의 상당한 도움으로 구축되었습니다. AI 생성 코드에 불편함을 느낀다면 DS4가 적합하지 않을 수 있습니다.

8. **플랫폼 범위**: Metal(macOS)과 CUDA(Linux)에 최적화되어 있습니다. Windows 및 AMD GPU 지원은 현재 우선순위가 아닙니다.

---

## 결론

DS4는 로컬 LLM 추론의 미래에 대한 대담한 베팅을 표현합니다: **많은 것을 적당히 하는 대신 한 가지를 비범하게 잘하는 것**입니다. DeepSeek V4 Flash에 집중함으로써, Salvatore Sanfilippo는 자신이 목표로 하는 특정 모델에서 범용 대안을 능가하는 엔진을 만들었으며, 동시에 디스크 KV 캐싱, 정확한 도구 호출 재생, OpenAI 호환 API와 같은 프로덕션 준비 기능을 제공합니다.

실행할 하드웨어를 보유한 개발자 — 고급 Mac Studio나 CUDA 장착 Linux 워크스테이션 — 에게 DS4는 오늘날 사용 가능한 가장 강력한 오픈 가중치 모델 중 하나를 사용하여 **사설, 빠르고 무료인 추론**으로 가는 매혹적인 경로를 제공합니다. 100만 토큰 맥락 윈도우, 지능적 사고 모드, 압축 KV 아키텍처는 코딩 에이전트, 장문 문서 분석, 프라이버시 중심 배포에 특히 적합하게 합니다.

프로젝트가 알파에서 안정화로 성숙해감에 따라, DS4는 DeepSeek V4 Flash를 로컬로 실행하는 확실한 방법이 될 수 있습니다. 하드웨어와 사용 사례가 있다면, Ollama와 llama.cpp와 함께 평가해 볼 가치가 충분합니다.

---

**DS4를 시도할 준비가 되셨나요?** [github.com/antirez/ds4](https://github.com/antirez/ds4)를 방문하여 저장소를 클론하고, q2-imatrix 가중치를 다운로드하고, 오늘 바로 프론티어급 로컬 추론을 경험해 보세요.

---

*dibi8 Tech Team이 발행했습니다. AI 도구, 개발자 리소스, 오픈소스 소프트웨어에 관한 더 많은 가이드는 [dibi8.com](https://dibi8.com)을 방문하세요.*

## FAQ: DS4 하드웨어 한계 돌파

**Q: M3 MacBook Pro에서 DeepSeek V4 Flash를 돌릴 수 있나요? (run DeepSeek V4 on MacBook Pro M3)**
A: 당연합니다. Metal 최적화와 2-bit 양자화 덕분에 128GB RAM이 장착된 M3 Max에서 실크처럼 부드럽게 돌아갑니다. 64GB 버전은 더 작은 모델에 적합합니다.

**Q: DS4 로컬 추론 vs DeepSeek API 비용 전격 비교?**
A: 코딩 에이전트를 24시간 내내 굴린다면 API 비용은 월 $1,000를 훌쩍 넘습니다. DS4를 이용한 로컬 추론은 단 한 번의 하드웨어 투자로 끝나며, 지속적인 API 지출이 0원입니다.

**Q: DS4의 디스크 KV Cache는 대체 뭔가요?**
A: 창을 닫으면 문맥을 다 까먹는 Ollama와 달리, DS4는 방대한 KV Cache를 SSD에 기록합니다. 10만 토큰짜리 대화도 프롬프트 재연산 대기 시간 없이 즉시 복구됩니다!

---

## 자체 호스팅 추천 인프라

24/7 안정 운영을 위해 인프라 선택이 중요하다:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 60일 $200 크레딧, 글로벌 14+ 리전. 오픈소스 AI 도구 자체 호스팅에 적합.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 홍콩 VPS, 중국 본토 접근 시 저지연. dibi8.com 자체가 호스팅된 검증된 IDC.

*추천 링크입니다. 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

