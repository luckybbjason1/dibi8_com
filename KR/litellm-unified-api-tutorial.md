---
title: 'LiteLLM 튜토리얼 2025: 하나의 API로 100개 이상의 LLM 사용하기'
description: 'LiteLLM으로 OpenAI, Anthropic, Google, 오픈소스 모델을 하나의 통합 API로 호출하는 방법을 상세히 설명합니다. 프록시 서버 설정, 라우팅, 폴리백 전략까지 실전 가이드.'
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
- /posts/litellm-unified-api-tutorial/
---

{</* resource-info */>}

AI 서비스를 개발하다 별면 여러 LLM 제공자의 API를 각각 연결해야 하는 번거로움을 경험하게 됩니다. LiteLLM은 이런 문제를 해결하는 통합 LLM API 게이트웨이로, 100개 이상의 모델을 하나의 인터페이스로 호출할 수 있게 해줍니다.

## LiteLLM이란 무엇인가?

### 범용 LLM API 게이트웨이

LiteLLM은 BerriAI가 개발한 오픈소스 LLM 프록시 서버로, OpenAI, Anthropic, Google, Azure 등 다양한 제공자의 API를 표준화된 OpenAI 호환 형식으로 변환합니다. 개발자는 `completion()` 함수 하나로 GPT-4, Claude 3, Gemini, Llama 등 어떤 모델이든 동일한 코드로 호출할 수 있습니다.

### 왜 LiteLLM을 사용해야 할까?

- **다중 제공자 관리 간소화**: API 키, 엔드포인트, 요청 형식을 각각 관리할 필요 없음
- **지능형 라우팅**: 비용, 지연 시간, 가용성을 기준으로 최적의 모델로 자동 분배
- **폴리백과 재시도**: 한 제공자에 장애가 발생하면 자동으로 대체 모델로 전환
- **비용 통제**: 팀별 예산 설정과 실시간 비용 모니터링

### 핵심 기능 개요

| 기능 | 설명 |
|------|------|
| 통합 API | 100+ 모델을 OpenAI 호환 형식으로 호출 |
| 프록시 서버 | 가상 키, 속도 제한, 예산 관리 |
| 지능형 라우터 | 비용/지연 시간 기반 모델 선택 |
| 캐싱 | 반복 쿼리에 대한 응답 캐싱으로 비용 절감 |
| 스트리밍 | 모든 제공자에서 실시간 스트리밍 지원 |
| 임베딩 통합 | 텍스트 임베딩도 동일한 인터페이스로 처리 |

## 100개 이상의 제공자와 모델 지원

### 주요 제공자

- **OpenAI**: GPT-4o, GPT-4 Turbo, GPT-3.5-Turbo
- **Anthropic**: Claude 3 Opus, Sonnet, Haiku
- **Google**: Gemini 1.5 Pro, Gemini 1.5 Flash
- **Azure OpenAI**: 엔터프라이즈 환경의 OpenAI 모델
- **AWS Bedrock**: Claude, Llama, Titan 등
- **Vertex AI**: Google Cloud의 Gemini 및 기타 모델

### 오픈소스 및 로컬 모델

- **Ollama**: 로컬에서 실행하는 Llama, Mistral, Gemma
- **vLLM**: 고성능 오픈소스 모델 서빙 엔진
- **Hugging Face**: TGI(Text Generation Inference)로 호스팅되는 모델
- **Groq**: 초저지연 추론을 제공하는 특화 제공자
- **Together AI**: 클라우드 기반 오픈소스 모델 서비스

## 설치와 빠른 시작

### pip로 LiteLLM 설치

```bash
pip install litellm
```

### 첫 번째 통합 API 호출

```python
import litellm

# OpenAI 모델 호출
response = litellm.completion(
    model="gpt-4o",
    messages=[{"role": "user", "content": "안녕하세요!"}]
)

# Claude 모델 호출 (동일한 함수 사용)
response = litellm.completion(
    model="claude-3-sonnet-20240229",
    messages=[{"role": "user", "content": "안녕하세요!"}]
)

# Gemini 모델 호출
response = litellm.completion(
    model="gemini/gemini-1.5-pro",
    messages=[{"role": "user", "content": "안녕하세요!"}]
)
```

모델명 앞에 제공자 접두사(`gemini/`, `anthropic/` 등)를 붙이면 LiteLLM이 자동으로 해당 제공자의 API로 라우팅합니다. 접두사 없이 사용하면 기본 제공자로 해석됩니다.

### 비동기 지원

```python
import litellm

response = await litellm.acompletion(
    model="gpt-4o",
    messages=[{"role": "user", "content": "비동기 호출 예시"}]
)
```

`acompletion()` 함수로 비동기 처리가 가능하며, 고성능 애플리케이션에서 필수적입니다.

## LiteLLM 프록시 서버

### 프록시 서버 설정

```bash
litellm --config config.yaml
```

### config.yaml 상세 구성

```yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY

  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-3-sonnet-20240229
      api_key: os.environ/ANTHROPIC_API_KEY

  - model_name: gemini-pro
    litellm_params:
      model: gemini/gemini-1.5-pro
      api_key: os.environ/GEMINI_API_KEY

router_settings:
  routing_strategy: simple-shuffle
  timeout: 30
  num_retries: 3
```

### 가상 키 관리

```yaml
litellm_settings:
  fallbacks: [{"gpt-4o": ["claude-sonnet", "gemini-pro"]}]
  budget_alerts: True
  max_budget: 100
```

가상 키를 통해 팀별 접근 권한과 예산을 독립적으로 관리할 수 있습니다.

## 고급 기능

### 지능형 라우터

비용 기반 라우팅은 가장 저렴한 사용 가능한 모델을 자동 선택합니다. 지연 시간 기반 라우팅은 응답 속도가 가장 빠른 모델로 요청을 볃납니다.

### 폴리백과 재시도

```yaml
fallbacks:
  - {"gpt-4o": ["claude-3-sonnet", "gemini-1.5-pro"]}
  - {"claude-3-opus": ["gpt-4-turbo"]}
```

1순위 모델이 실패하면 2순위, 3순위 모델로 자동 전환됩니다.

### 응답 캐싱

```yaml
cache: True
cache_params:
  type: redis
  host: localhost
  port: 6379
```

Redis를 백엔드로 사용하면 동일한 질문에 대한 반복 호출을 캐싱하여 API 비용을 최대 40% 절감할 수 있습니다.

## LiteLLM + LangChain/LlamaIndex 연동

### LangChain에서 사용하기

```python
from langchain_community.chat_models import ChatLiteLLM

llm = ChatLiteLLM(model="gpt-4o")
response = llm.predict("LangChain에서 LiteLLM 사용하기")
```

### LlamaIndex에서 사용하기

```python
from llama_index.llms.litellm import LiteLLM

llm = LiteLLM(model="claude-3-sonnet")
```

기존 코드베이스에서 모델 교체가 필요할 때 LiteLLM은 거의 드롭인 방식으로 적용 가능합니다.

## 엔터프라이즈 기능

- **사용자 관리 및 RBAC**: 팀별 역할 기반 접근 통제
- **비용 추적 및 알림**: 실시간 비용 대시보드와 예산 알림
- **로깅 및 관찰 가능성**: LangSmith, Langfuse, OpenTelemetry 연동
- **셀프 호스팅**: 남부 데이터센터에 직접 배포
- **SSO 통합**: OIDC, SAML 기업 로그인

## 비용 최적화 전략

| 전략 | 예상 절감 효과 |
|------|-------------|
| 저렴한 제공자 라우팅 | 30-60% |
| 오픈소스 모델 활용 | 70-90% |
| 캐싱 | 20-40% |
| 스트리밍 | 지연 시간 50% 감소 |

## LiteLLM과 대안 비교

| 항목 | LiteLLM | Portkey | 직접 통합 |
|------|---------|---------|----------|
| 제공자 수 | 100+ | 20+ | 1개씩 |
| 오픈소스 | O | X | - |
| 프록시 서버 | O | O | X |
| 가상 키 | O | O | X |
| 비용 추적 | O | O | 직접 구현 |
| 셀프 호스팅 | O | X | - |

## 프로덕션 배포 가이드

### Docker 배포

```dockerfile
FROM ghcr.io/berriai/litellm:main-latest
COPY config.yaml /app/config.yaml
CMD ["litellm", "--config", "/app/config.yaml", "--port", "4000"]
```

### Kubernetes Helm 차트

```bash
helm repo add litellm https://berriai.github.io/litellm
helm install litellm litellm/litellm -f values.yaml
```

## 자주 묻는 질문

**LiteLLM은 물로 사용할 수 있나요?**

기본 SDK와 프록시 서버는 MIT 라이선스로 완전 물론입니다. 엔터프라이즈 기능(가상 키, RBAC, SSO)이 포함된 LiteLLM Enterprise는 유료 플랜이 있습니다.

**LiteLLM은 어떤 LLM 제공자를 지원하나요?**

2025년 5월 기준 100개 이상의 제공자를 지원합니다. OpenAI, Anthropic, Google, Azure, AWS Bedrock, Vertex AI, Cohere, Groq, Together AI, Ollama, vLLM 등이 포함됩니다.

**LiteLLM이 API 키 관리를 어떻게 처리하나요?**

환경 변수나 `.env` 파일에서 API 키를 읽어옵니다. `config.yaml`에서 `api_key: os.environ/KEY_NAME` 형식으로 참조하여 코드에 민감한 정보를 노출하지 않습니다.

**셀프 호스팅 모델과 LiteLLM을 연동할 수 있나요?**

Ollama나 vLLM으로 로컬에서 실행하는 모델도 LiteLLM에 등록할 수 있습니다. `model: ollama/llama3` 또는 `model: hosted_vllm/llama3` 형식으로 설정합니다.

**LiteLLM SDK와 프록시의 차이점은 무엇인가요?**

SDK는 Python 라이브러리로 코드에서 직접 호출합니다. 프록시 서버는 독립 실행형 서버로, 모든 프로그래밍 언어에서 HTTP 요청으로 접근할 수 있으며 가상 키 관리와 로드 밸런싱 기능이 포함됩니다.

## 참고 자료

- [LiteLLM 공식 문서](https://docs.litellm.ai)
- [LiteLLM GitHub 저장소](https://github.com/BerriAI/litellm)
- [LiteLLM 프록시 문서](https://docs.litellm.ai/docs/proxy)
- [OpenAI API 문서](https://platform.openai.com/docs)
- [Anthropic API 문서](https://docs.anthropic.com)

---

## 추천 인프라

위 도구들을 24/7 안정 운영하려면 인프라가 중요하다:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연. dibi8.com 자체 호스팅 IDC.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

