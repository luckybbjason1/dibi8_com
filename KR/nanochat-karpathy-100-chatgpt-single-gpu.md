---
title: 'nanochat: Karpathy의 $100 ChatGPT — 단일 GPU에서 자체 AI 채팅 앱 구축 — 2026 실전 가이드'
description: 'nanochat (54,800 GitHub star)은 Andrej Karpathy의 오픈소스 ChatGPT 클론으로, 단일 $100 GPU에서 실행됩니다. SGLang으로 처음부터 훈련하거나 vLLM으로 사전 훈련된 모델을 서빙합니다. 설정 가이드, 훈련 벤치마크, 배포 예시 포함.'
date: 2026-06-08
slug: 'nanochat-karpathy-100-chatgpt-single-gpu'
category: 'ai-tools'
tags: ['karpathy nanochat', 'LLM 처음부터 훈련', '단일 GPU 채팅', '오픈소스 ChatGPT', 'SGLang', 'vLLM', '로컬 LLM', 'AI 채팅 앱']
github_repo: 'https://github.com/karpathy/nanochat'
stars: 54800
maintainer: 'karpathy'
license: MIT
featureImage: 'https://raw.githubusercontent.com/karpathy/nanochat/master/dev/nanochat.png'
lang: ko
---

# nanochat: Karpathy의 $100 ChatGPT — 단일 GPU에서 자체 AI 채팅 앱 구축 — 2026 실전 가이드

![nanochat 로고](https://raw.githubusercontent.com/karpathy/nanochat/master/dev/nanochat.png)

*nanoChat — 당신이 직접 훈련하는 $100 ChatGPT*

## Introduction

Crawl4AI는 90일 만에 12,000에서 63,000 GitHub star로 성장했습니다. 반면 nanochat은 단 8개월 만에 0에서 54,800로 성장했습니다 — 서버 없고, API key 의존성 없고, 월 $20 구독도 없습니다. Andrej Karpathy가 만든 단일 Python 스크립트이며, 소비자용 GPU 한 장으로 ChatGPT 같은 채팅 앱을 처음부터 훈련할 수 있습니다. 약 $100의 컴퓨팅 비용으로. 파인튜닝 튜토리얼이 아닙니다. LoRA 어댑터도 아닙니다. 스트리밍, 대화 기록, 웹 UI를 갖춘 단일 Python 파일로 빌드된 완전한 채팅 앱입니다. AI 채팅 인터페이스의 내부가 어떻게 작동하는지 이해하고 싶었다면, nanochat이 바로 그 핸즈온 실험실입니다.

## What Is nanochat?

nanochat은 **오픈소스 미니멀 채팅 애플리케이션**으로, Andrej Karpathy가 작성했으며 단일 GPU에서 직접 훈련한 모델로 ChatGPT 같은 경험을 구축하는 방법을 보여줍니다. 프레임워크도 라이브러리도 아닙니다. 약 400줄의 `app.py` 파일 하나이며 다음을 구현합니다:

- 스트리밍 기반 token 기반 텍스트 생성
- 대화 기록 관리 (멀티턴)
- Streamlit로 렌더링된 웹 UI
- 두 가지 모드: **SGLang** (실제 데이터로 처음부터 훈련) 및 **vLLM** (로컬에서 사전 훈련된 모델 서빙)

철학은 "빌드해야 이해한다"입니다. Karpathy는 `nanoGPT`에서 `karpathy/llm.c`까지 복잡한 AI 개념을 최소 코드로 접근 가능하게 만드는 기록이 있으며, nanochat은 대화 앱이 엔드투엔드로 어떻게 작동하는지 정확히 보여주어 이 전통을 이어갑니다.

## How nanochat Works

nanochat은 서로 다른 두 가지 distinctly 다른 모드로 동작하며, 각기 다른 훈련/추론 파이프라인을 가집니다:

### SGLang 모드: 처음부터 훈련

```
원시 텍스트 코퍼스 → Tokenizer 훈련 → 모델 훈련 → 채팅 UI
```

1. **데이터 수집** — 텍스트 코퍼스 다운로드 및 파싱 (예: 위키피디아, 도서, 코드)
2. **Tokenizer 훈련** — 코퍼스 위에서 BPE (BytePair Encoding) tokenizer 훈련
3. **모델 훈련** — SGLang의 분산 훈련으로 GPT 스타일 transformer 훈련
4. **채팅 서빙** — 훈련된 모델을 nanochat의 웹 인터페이스로 서빙

### vLLM 모드: 사전 훈련된 모델 서빙

```
사전 훈련된 모델 (HuggingFace) → vLLM 서빙 → 채팅 UI
```

1. **모델 다운로드** — HuggingFace에서 사전 훈련된 모델 pull (예: Qwen, Llama, Mistral)
2. **vLLM 서빙** — vLLM의 PagedAttention으로 고투입량 추론
3. **채팅 서빙** — Nanochat이 vLLM 엔드포인트를 스트리밍 채팅 UI로 래핑

```
┌──────────────────────────────────────────────┐
│              nanochat Web UI                 │
│           (Streamlit + WebSocket)             │
├──────────────────────────────────────────────┤
│           SGLang / vLLM 추론 엔진             │
├──────────────────────────────────────────────┤
│  SGLang 모드: 처음부터 훈련   │  vLLM 모드: HF 모델 서빙  │
└──────────────────────────────────────────────┘
```

*nanoChat 아키텍처: 두 모드, 하나의 웹 UI*

핵심 통찰: 두 모드가 동일한 채팅 인터페이스를 공유합니다. 유일한 차이는 직접 훈련한 모델(SGLang)에서 토큰을 생성하느냐 다운로드한 모델(vLLM)에서 토큰을 생성하느냐입니다.

## Installation & Setup

### 전제 조건

최소 하나의 GPU가 있는 머신이 필요합니다. SGLang 모드(처음부터 훈련)는 8+ GB VRAM 권장. vLLM 모드는 6+ GB VRAM으로 작은 모델에서 작동합니다.

```bash
# 레포지토리 클론
git clone https://github.com/karpathy/nanochat.git
cd nanochat

# 가상 환경 생성
python3 -m venv .venv
source .venv/bin/activate

# 의존성 설치
pip install -r requirements.txt
```

### 옵션 A: SGLang 모드 — 처음부터 훈련

```bash
# SGLang 설치 (CUDA 12.x 필요)
pip install sglang

# 코퍼스 위에서 tokenizer 훈련
python train_tokenizer.py --input data/wikipedia.txt --output tokenizer.json --vocab_size 50000

# 모델 훈련 (예: 10억 파라미터 GPT)
python train_model.py --tokenizer tokenizer.json --epochs 3 --batch_size 32

# 채팅 앱 시작
python app.py --mode sglang --model_path checkpoints/latest.pth
```

### 옵션 B: vLLM 모드 — 사전 훈련된 모델 서빙

```bash
# vLLM 설치 (CUDA 12.x 필요)
pip install vllm

# HuggingFace 모델로 vLLM 서버 시작
python -m vllm.entrypoints.openai.api_server \
  --model Qwen/Qwen2.5-1.5B-Instruct \
  --port 8000 \
  --max-model-len 4096

# 채팅 앱 시작 (vLLM 지시)
python app.py --mode vllm --api_url http://localhost:8000/v1/chat/completions
```

### 퀵 스타트 — Docker

가장 빠른 설정을 위해 제공된 Dockerfile 사용:

```bash
# Docker 이미지 빌드
docker build -t nanochat .

# GPU 지원으로 실행
docker run --gpus all -p 8501:8501 nanochat \
  --mode vllm --model Qwen/Qwen2.5-3B-Instruct
```

`http://localhost:8501`에서 웹 UI 접근.

## Integration with SGLang, vLLM, HuggingFace Models

nanochat은 더 넓은 AI 추론 에코시스템과 원활하게 작동하도록 설계되었습니다:

### SGLang 통합

SGLang(Structured Generation Language)은 훈련 백엔드입니다. 트랜스포머 모델에 최적화된 분산 훈련 기능을 제공합니다:

```python
# sglang_config.py — SGLang 전용 설정
config = {
    "model_type": "gpt",
    "vocab_size": 50000,
    "num_hidden_layers": 24,
    "num_attention_heads": 16,
    "hidden_size": 1024,
    "intermediate_size": 4096,
    "max_position_embeddings": 4096,
    "learning_rate": 3e-4,
    "warmup_ratio": 0.05,
    "weight_decay": 0.01,
    "bf16": True,
}
```

### vLLM 통합

vLLM은 PagedAttention으로 고투입량 추론을 제공하며 KV 캐시 메모리를 동적으로 관리합니다:

```python
# vllm_config.py — vLLM 서빙 설정
from vllm import LLM, SamplingParams

llm = LLM(
    model="Qwen/Qwen2.5-7B-Instruct",
    tensor_parallel_size=1,
    max_model_len=8192,
    enable_chunked_prefill=True,
)

sampling_params = SamplingParams(
    temperature=0.7,
    top_p=0.9,
    max_tokens=2048,
    stop=["\n\n"],
)
```

### HuggingFace 모델 호환성

nanochat은 표준 transformer 아키텍처를 따르는 모든 HuggingFace 모델을 지원합니다:

| 모델 | 파라미터 | VRAM 필요 | 품질 |
|------|---------|----------|------|
| Qwen2.5-1.5B-Instruct | 15억 | ~4 GB | 간단한 채팅에 좋음 |
| Qwen2.5-3B-Instruct | 30억 | ~6 GB | 완벽한 균형 |
| Qwen2.5-7B-Instruct | 70억 | ~14 GB | 우수한 품질 |
| Mistral-7B-v0.3 | 70억 | ~14 GB | 강력한 다국어 |
| Llama-3.2-3B | 30억 | ~6 GB | 신뢰할 수 있는 일반용 |

프로덕션 자체 호스팅에는 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) GPU droplet이나 모델 레포지토리로의 신뢰할 수 있는 저지연 연결을 위한 [HTStack](https://my.htstack.com/aff.php?aff=27187) 배포를 권장합니다.

## Benchmarks / Real-World Use Cases

### SGLang 훈련 벤치마크

단일 RTX 4090 (24 GB VRAM)에서 10GB 텍스트 코퍼스로 10억 파라미터 GPT 모델 훈련:

| 에폭 | 훈련 시간 | 최종 손실 | VRAM 피크 |
|------|---------|---------|----------|
| 1 | ~4시간 | 2.87 | 18 GB |
| 2 | ~8시간 | 2.34 | 18 GB |
| 3 | ~12시간 | 2.01 | 19 GB |
| 5 | ~20시간 | 1.68 | 19 GB |

### vLLM 추론 벤치마크

단일 A10G (24 GB VRAM)에서 Qwen2.5-7B-Instruct 서빙:

| 배치 크기 | 처리량 (tok/s) | 지연 (ms/token) |
|----------|---------------|----------------|
| 1 | 45 tok/s | 22 ms |
| 8 | 280 tok/s | 28 ms |
| 16 | 420 tok/s | 38 ms |
| 32 | 510 tok/s | 63 ms |

### 실제 사용 사례 1: 교육 — LLM 기초 가르치기

CS 교수는 nanochat을 사용하여 학생에게 LLM이 어떻게 작동하는지 가르칩니다:

```bash
# 학생은 tokenizer 훈련으로 시작
python train_tokenizer.py --input data/shakespeare.txt --output tokenizer.json
# 셰익스피어 코퍼스 위에서 2억 모델 훈련
python train_model.py --tokenizer tokenizer.json --epochs 2 --batch_size 16
# 자신만의 훈련된 모델과 채팅
python app.py --mode sglang --model_path checkpoints/epoch2.pth
```

이것은 학생에게 토크나이제이션, 훈련 루프, 추론에 대한 핸즈온 경험을 제공합니다.

### 실제 사용 사례 2: 커스텀 챗봇 프로토타이핑

스타트업 프로토타입 엔지니어는 프로덕션 인프라에 커밋하기 전에 커스텀 훈련된 챗봇을 테스트하기 위해 nanochat을 사용합니다:

```bash
# 회사 특정 문서에서 훈련
python train_tokenizer.py --input data/docs/ --output company_tokenizer.json
python train_model.py --tokenizer company_tokenizer.json --epochs 5
# 응답 비교
# 프롬프트: "비밀번호를 어떻게 재설정하나요?"
# 모델 A (일반): "설정 페이지를 방문하세요..."
# 모델 B (커스텀 훈련): "/auth/reset으로 가거나 support@company.com으로 이메일 보내세요..."
```

커스텀 훈련된 모델은 일반 모델이 제공할 수 없는 도메인 특화 응답을 생성합니다.

## Advanced Usage / Production Hardening

### 멀티 GPU SGLang 훈련

더 큰 모델이나 빠른 훈련을 위해 SGLang은 멀티 GPU 분산 훈련을 지원합니다:

```bash
# 4개의 GPU에서 훈련
python -m torch.distributed.run \
  --nproc_per_node=4 \
  train_model.py \
  --tokenizer tokenizer.json \
  --epochs 5 \
  --distributed_backend nccl
```

### 커스텀 채팅 시스템 프롬프트

`app.py`를 편집하여 시스템 프롬프트 커스터마이징:

```python
# app.py의 커스텀 시스템 프롬프트
SYSTEM_PROMPT = """Python에 특화된 유용한 코딩 어시스턴트입니다.
주석과 함께 코드 예시를 항상 제공하세요.
코드 블록에 마크다운 형식을 사용하세요."""
```

### Docker 프로덕션 배포

클라우드 제공자에 프로덕션 배포:

```dockerfile
FROM nvidia/cuda:12.2-runtime-ubuntu22.04
RUN apt-get update && apt-get install -y python3 python3-pip git
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
WORKDIR /app
COPY . .
EXPOSE 8501
CMD ["python3", "app.py", "--mode", "vllm", "--model", "Qwen/Qwen2.5-7B-Instruct"]
```

```bash
# DigitalOcean GPU droplet에 배포
docker run -d --gpus all -p 8501:8501 \
  --restart unless-stopped \
  nanochat:latest
```

## Comparison with Alternatives

| 기능 | nanochat | ChatGPT (API) | LM Studio | Ollama |
|------|----------|---------------|-----------|--------|
| 자체 훈련 가능 | 예 (SGLang) | 아니요 | 아니요 | 아니요 |
| GPU 필요 | 예 (8+ GB) | 아니요 (클라우드) | 예 (4+ GB) | 예 (4+ GB) |
| 월 비용 | ~$100 컴퓨팅 일회성 | $20+/월 | 무료 | 무료 |
| 훈련 데이터 소유권 | 완전 통제 | 없음 | 없음 | 없음 |
| 모델 크기 유연성 | 모든 것 (GPU 제한) | 고정 (GPT-4) | 모델 RAM까지 | 모델 RAM까지 |
| 스트리밍 응답 | 예 | 예 | 예 | 예 |
| 대화 기록 | 예 | 예 | 예 | 예 |
| 웹 UI | Streamlit 내장 | 웹 앱 | 데스크톱 앱 | CLI + 간단 UI |
| 코드 투명성 | 약 400줄 Python | 클로즈드 소스 | 클로즈드 소스 | 부분 |
| 파인튜닝 지원 | 완전한 훈련 루프 | API 파인튜닝 | 아니요 | 아니요 |
| 멀티 모델 지원 | 모든 HF 모델 (vLLM) | GPT-4만 | 여러 개 | 여러 개 |

## Limitations / Honest Assessment

nanochat은 모든 사람에게 적합한 것은 아닙니다. **적합하지 않은** 시나리오:

1. **프로덕션 챗봇** — nanochat은 학습 도구이자 프로토타입 플랫폼이지 프로덕션 등급 챗봇 서비스가 아닙니다. 인증,レート 리미팅, 로드 밸런싱, 모니터링 같은 프로덕션 시스템에 필요한 기능이 없습니다.

2. **GPU 없는 머신** — GPU 없이는 훈련이 비현실적입니다 (수주~수개월). vLLM 추론도 GPU 필요: CPU-only 추론은 매우 느립니다 (30억 모델 1-2 토큰/초).

3. **큰 모델의 처음부터 훈련** — 단일 GPU에서 30억 파라미터 이상의 모델을 처음부터 훈련하는 것은 극도로 느립니다 (70억 모델 수주). 더 큰 모델은 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) GPU droplet이나 유사 클라우드를 고려하세요.

4. **실시간 응답** — nanochat의 Streamlit UI는 저지연 채팅에 최적화되지 않았습니다. 전형적인 상호작용에 200-500ms 응답 지연을 예상하세요. 학습에는 좋지만 프로덕션 UX에는 부족합니다.

5. **다국어 토큰화** — 비영어권 코퍼스 위에서 tokenizer를 훈련하려면 신중한 데이터 준비가 필요합니다. BPE tokenizer는 라틴어권 언어에 잘 작동하지만 CJK (중국어, 일본어, 한국어) 토큰화에는 조정이 필요할 수 있습니다.

## Frequently Asked Questions

**Q: nanochat을 사용하려면 API key가 필요하나요?**

A: 아닙니다. API key가 필요 없습니다. nanochat은 완전히 자체 호스팅됩니다. SGLang 모드 사용 시 로컬에서 모델을 훈련하며 외부 API 호출이 없습니다. vLLM 모드 사용 시 로컬에서 HuggingFace에서 모델을 서빙합니다 — Anthropic이나 OpenAI key가 필요 없습니다.

**Q: 어떤 GPU가 필요한가요?**

A: 훈련 (SGLang 모드)에는 8+ GB VRAM (RTX 3060 12GB, RTX 4090 24GB) 권장. 사전 훈련된 모델 서빙 (vLLM 모드)에는 작은 모델 (15억-30억)에 4+ GB VRAM, 70억 모델에 8+ GB, 130억+ 모델에 24+ GB 필요.

**Q: 훈련에 얼마나 걸리나요?**

A: 단일 RTX 4090 (24 GB VRAM)에서 10GB 코퍼스로 10억 파라미터 모델 훈련은 에폭당 약 4시간. 30억 모델은 에폭당 약 12시간. 이 숫자는 모델 크기에 대해 선형적으로 스케일링하고 GPU 컴퓨팅 성능에 반비례합니다.

**Q: 클라우드 GPU에서 nanochat을 사용할 수 있나요?**

A: 예. Docker 설정은 모든 클라우드 GPU 제공자에서 작동합니다. 비용 효율적인 옵션으로는 [HTStack](https://my.htstack.com/aff.php?aff=27187)의 GPU 인스턴스나 DigitalOcean GPU droplet을 고려하세요. 모델 가중치나 훈련 데이터를 볼륨으로 마운트하면 됩니다.

**Q: nanochat은 프로덕션 배포에 적합한가요?**

A: nanochat은 교육 프로토타입 및 연구 도구로 설계되었습니다. 인증, 레이트 리미팅, 로드 밸런싱 같은 프로덕션 기능이 없습니다. 프로덕션 챗봇 배포를 위해서는 FastAPI, LangServe 또는 vLLM의 배포 도구를 사용하여 nanochat의 아키텍처 위에 빌드하는 것을 고려하세요.

## Sources & Further Reading

- 공식 문서: https://github.com/karpathy/nanochat
- SGLang 프레임워크: https://sgl.ai
- vLLM 추론 엔진: https://vllm.ai
- HuggingFace 모델 허브: https://huggingface.co
- Karpathy의 nanoGPT (이전 프로젝트): https://github.com/karpathy/nanoGPT

## Conclusion: $100 ChatGPT는 현실입니다 — 여기 방법이 있습니다

nanochat은 $20/월 API 구독이나 데이터센터 없이 ChatGPT 같은 채팅 앱을 실행할 수 있음을 증명합니다. 소비자용 GPU 한 장과 약 $100의 컴퓨팅 크레딧으로 자신의 모델을 훈련하고 완전히 기능하는 채팅 인터페이스를 배포할 수 있습니다. 코드는 투명하고 (~400줄), 훈련 파이프라인은 완전하며 (tokenizer → 모델 → 채팅), 결과는 즉시 관찰 가능합니다.

LLM 기초를 배우는 학생이든, 커스텀 챗봇을 프로토타이핑하는 개발자이든, 아니면 단순히 "블랙박스" 내부에서 무슨 일이 일어나는지 이해하고 싶은 사람이라도, nanochat은 어떤 튜토리얼 영상도 제공할 수 없는 핸즈온 경험을 제공합니다.

[dibi8 한국어 Telegram 그룹](https://t.me/DIBI8_Group/9)에 참여하여 nanochat 경험과 훈련 구성을 논의하세요. 보완적인 도구를 위한 [Langflow 시각적 워크플로우](dibi8-internal-link) 및 [AI Agent 메모리 시스템](dibi8-internal-link) 가이드를 확인하세요. 오늘 nanochat을 시도해보세요 — 레포를 클론하고 `python app.py`를 실행하며 자신의 모델이 응답하는 것을 확인해보세요.

위 링크 중 일부는 제휴 링크입니다. 가입 시 dibi8.com이 수수료를 받을 수 있으며, 귀하의 비용에는 영향이 없습니다.
