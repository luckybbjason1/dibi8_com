---
title: 'LiteLLM: 22,500 Stars — 100개 이상의 LLM을 하나의 API로 배포, 내장 폴오버 — 2026 프로덕션 게이트웨이 설정'
description: 'LiteLLM (litellm)은 100개 이상의 LLM을 단일 API로 호출하는 오픈소스 AI 게이트웨이입니다. OpenAI, Anthropic, Ollama, Cohere, Gemini, Bedrock과 호환. Docker 배포, 가상 키, 로드 밸런싱, 캐싱, 프로덕션 하드닝을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/BerriAI/litellm'
stars: 22500
maintainer: 'BerriAI'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['litellm', 'llm-게이트웨이', '오픈소스', 'docker', '프로덕션', 'ai-인프라', '프록시-서버', '멀티-모델']
aliases:
- /kr/posts/litellm/
- /kr/resources/llm-frameworks/litellm-unified-api-tutorial/
---

{{</* resource-info */>}}

![LiteLLM Logo](https://raw.githubusercontent.com/BerriAI/litellm/main/docs/my-assets/logo.png)

## 소개

Claude로 추론하고, GPT-4o로 코딩하고, Gemini Flash로 저비용 분류를 수행한다. 각 공급자마다 고유한 SDK, 재시도 로직, 속도 제한 헤더, 결제 대시보드가 있다. Anthropic API가 새벽 2시에 문제가 발생하면 누군가가 깨어나야 한다. OpenAI 요금이 주간으로 40% 급등하면 어느 팀이 원인인지 아묏도 모른다.

이것이 멀티 LLM 운영 비용이며 — 새로운 모델을 추가할 때마다 가중된다. LiteLLM은 이 비용을 없앤다. 단일 OpenAI 호환 API 엔드포인트를 노출하는 오픈소스 AI 게이트웨이로, 100개 이상의 LLM 공급자에게 요청을 프록시하고 자동 폴오버, 로드 밸런싱, 가상 키, 비용 추적이 내장되어 있다.

**22,500개 이상의 GitHub 스타**와 **1,500명 이상의 기여자**를 보유한 LiteLLM은 게이트웨이 수준의 제어와 제로 벤더 종속성을 원하는 팀의 기본 선택이 되었다. 이 가이드는 30분 이내에 프로덕션급 설정 — Docker 배포부터 가상 키 관리, 모니터링까지 — 안내한다.

---

## LiteLLM이란?

LiteLLM은 100개 이상의 LLM API — OpenAI, Anthropic, Azure, Google Vertex AI, AWS Bedrock, Cohere, Ollama 등 — 을 단일 OpenAI 호환 API 형식으로 호출하는 통합 인터페이스를 제공하는 오픈소스 LLM 프록시 게이트웨이이자 Python SDK이다.

두 가지 모드가 있다:

- **Python SDK** — 코드에서 `import litellm; completion(...)`으로 공급자와 무관하게 사용
- **프록시 서버** — `:4000`에서 실행되는 자체 호스팅 HTTP 게이트웨이, 모든 OpenAI SDK 클라이언트가 가리킬 수 있음

대부분의 프로덕션 팀이 사용하는 프록시 모드는 가상 키, 팀 관리, 예산 제어, 속도 제한, 캐싱, 관찰 가능성을 추가한다 — 모두 단일 `config.yaml` 파일로 구성된다.

---

## LiteLLM 작동 방식

![LiteLLM 아키텍처 다이어그램](images/litellm-architecture.png)

**요청 흐름:**

1. 애플리케이션이 `http://litellm-proxy:4000/v1/chat/completions`에 OpenAI 형식 요청을 전송
2. LiteLLM은 가상 키를 검증하고 팀 예산과 속도 제한을 확인
3. 라우터가 구성된 전략(지연 시간 기반, 비용 기반, 또는 단순 로드 밸런싱)에 따라 최적의 모델 배포를 선택
4. 기본 공급자가 429/5xx를 반환하면 밀리초 내에 자동 폴오버가 트리거됨
5. 어떤 공급자가 처리했는지와 관계없이 응답이 OpenAI 형식으로 스트리밍됨
6. 소비, 지연 시간, 토큰 수가 PostgreSQL에 기록되고 Prometheus 메트릭이 발행됨

**핵심 구성 요소:**

| 구성 요소 | 목적 | 외부 의존성 |
|-----------|------|-------------|
| 프록시 서버 | HTTP API, 라우팅, 인증 | 없음 (Python/FastAPI) |
| PostgreSQL | 가상 키, 소비 로그, 팀 데이터 | 프로덕션 필수 |
| Redis | 속도 제한 조정, 캐싱 | 권장 |
| 관리 UI | 키/모델용 웹 대시보드 | 내장 |

---

## 설치 및 설정

### 전제 조건

- Docker 24+ 및 Docker Compose v2
- PostgreSQL 14+ (로컬 컨테이너 또는 [DigitalOcean Managed Postgres](https://www.digitalocean.com/products/managed-databases-postgresql) 같은 관리형 서비스)
- 프록시 컨테이너 최소 2 vCPU / 4 GB RAM

### 1단계: Docker Compose 템플릿 다운로드

```bash
# 프로젝트 디렉토리 생성
mkdir -p litellm-gateway && cd litellm-gateway

# 공식 docker-compose.yml 다운로드
curl -O https://raw.githubusercontent.com/BerriAI/litellm/main/docker-compose.yml

# 환경 파일 생성
cat > .env << 'EOF'
LITELLM_MASTER_KEY="sk-litellm-admin-$(openssl rand -hex 16)"
LITELLM_SALT_KEY="sk-salt-$(openssl rand -hex 32)"
OPENAI_API_KEY="sk-your-openai-key"
ANTHROPIC_API_KEY="sk-your-anthropic-key"
DATABASE_URL="postgresql://llmproxy:dbpassword9090@db:5432/litellm"
EOF
```

### 2단계: config.yaml 생성

```yaml
# litellm_config.yaml
model_list:
  - model_name: gpt-4o
    litellm_params:
      model: openai/gpt-4o
      api_key: os.environ/OPENAI_API_KEY
      rpm: 500
      tpm: 150000

  - model_name: claude-sonnet
    litellm_params:
      model: anthropic/claude-sonnet-4-20250514
      api_key: os.environ/ANTHROPIC_API_KEY
      rpm: 200
      tpm: 40000

  - model_name: gemini-flash
    litellm_params:
      model: gemini/gemini-2.0-flash
      api_key: os.environ/GEMINI_API_KEY
      rpm: 1000

  - model_name: ollama-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://ollama:11434
    model_info:
      mode: chat

  # 임베딩 모델
  - model_name: text-embedding
    litellm_params:
      model: openai/text-embedding-3-small
      api_key: os.environ/OPENAI_API_KEY

general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL
  max_budget: 10000.00
  budget_duration: 30d
  alerting:
    - slack
  alerting_threshold: 300
  global_max_parallel_requests: 200

litellm_settings:
  drop_params: true
  num_retries: 3
  request_timeout: 120

  # 자동 폴오버
  fallbacks:
    - gpt-4o:
      - claude-sonnet
      - gemini-flash
    - claude-sonnet:
      - gpt-4o
      - gemini-flash

  # Redis 캐싱
  cache: true
  cache_params:
    type: redis
    host: redis
    port: 6379
    ttl: 3600

  # 관찰 가능성 콜백
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

### 3단계: 서비스 스택 시작

```bash
# 모든 서비스 가져오기 및 시작
docker compose up -d

# 서비스 상태 확인
docker compose ps

# 프록시 로그 확인
docker compose logs -f litellm
```

프록시가 이제 `http://localhost:4000`에서 실행 중이다. 관리 UI는 `http://localhost:4000/ui/` — 사용자 이름 `admin`과 `LITELLM_MASTER_KEY`를 비밀번호로 사용하여 로그인한다.

### 4단계: 요청으로 테스트

```bash
# 채팅 완성 테스트
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "messages": [{"role": "user", "content": "LiteLLM이란 무엇인가?"}]
  }'

# 임베딩 테스트
curl http://localhost:4000/v1/embeddings \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "text-embedding",
    "input": ["LiteLLM은 AI 게이트웨이입니다"]
  }'
```

---

## 인기 도구와의 통합

### OpenAI SDK (Python)

```python
from openai import OpenAI

client = OpenAI(
    base_url="http://localhost:4000",
    api_key="sk-your-litellm-virtual-key"
)

response = client.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "로드 밸런싱 설명"}]
)
print(response.choices[0].message.content)
```

### LangChain

```python
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    model="claude-sonnet",
    openai_api_key="sk-your-virtual-key",
    openai_api_base="http://localhost:4000"
)

result = llm.invoke("LLM 게이트웨이 유형은 무엇인가?")
print(result.content)
```

### Anthropic SDK (네이티브 호환)

```python
from anthropic import Anthropic

client = Anthropic(
    base_url="http://localhost:4000/anthropic",
    api_key="sk-your-virtual-key"
)

response = client.messages.create(
    model="claude-sonnet",
    max_tokens=1024,
    messages=[{"role": "user", "content": "LiteLLM과 OpenRouter 비교"}]
)
print(response.content[0].text)
```

### Ollama (로컬 모델)

```yaml
# litellm_config.yaml에 추가
model_list:
  - model_name: local-llama
    litellm_params:
      model: ollama/llama3.3
      api_base: http://localhost:11434
    model_info:
      mode: chat
```

```bash
# LiteLLM을 통해 로컬 모델 테스트
curl http://localhost:4000/v1/chat/completions \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-llama",
    "messages": [{"role": "user", "content": "안녕 로컬 모델"}]
  }'
```

### Cohere

```yaml
model_list:
  - model_name: cohere-command
    litellm_params:
      model: cohere/command-r-plus
      api_key: os.environ/COHERE_API_KEY
```

```python
from openai import OpenAI
client = OpenAI(base_url="http://localhost:4000", api_key="sk-virtual-key")
response = client.chat.completions.create(
    model="cohere-command",
    messages=[{"role": "user", "content": "요약하라"}]
)
```

---

## 벤치마크 / 실제 사용 사례

### 시나리오: 멀티 팀 AI 플랫폼 (SaaS 스타트업)

5개의 난부 팀과 외부 API 고객을 서비스하는 50인 AI 스타트업:

| 지표 | LiteLLM 사용 전 | LiteLLM 사용 후 |
|------|----------------|----------------|
| 유지 중인 공급자 SDK | 4 (OpenAI, Anthropic, Gemini, Ollama) | 1 (OpenAI 호환) |
| API 키 관리 | 환경 변수의 공유 키 | 팀/고객별 가상 키 |
| 비용 귀속 | 수동 CSV 낯로 | 실시간 UI의 키별 소비 |
| 장애 응답 | 인간 호출, 15분 MTTR | 자동 폴오버, <500ms |
| 월간 LLM 비용 | ₩1,020만 (미최적화) | ₩745만 (라우팅 후 -27%) |

### 성능 벤치마크 (자체 호스팅, 4 vCPU / 8 GB RAM)

| 부하 | 처리량 | P50 지연 시간 | P99 지연 시간 |
|------|--------|--------------|--------------|
| 50 RPS 채팅 (GPT-4o) | 안정적 | 45ms 오버헤드 | 120ms 오버헤드 |
| 200 RPS 임베딩 | 안정적 | 12ms 오버헤드 | 35ms 오버헤드 |
| 폴오버 트리거 | — | 180ms 전환 | 280ms 전환 |
| 캐시 히트 (Redis) | — | 3ms | 8ms |

**참고:** 게이트웨이 오버헤드는 LLM API 응답 시간을 제외한다. LiteLLM은 작고 예측 가능한 지연 시간 페널티를 추가한다. 매 밀리초가 중요한 흐름의 경우 애플리케이션과 동일한 VPC에 프록시를 배포한다.

---

## 고급 사용법 / 프로덕션 하드닝

### 가상 키 및 팀 관리

가상 키는 프로덕션 LiteLLM 배포의 보안 중추이다. 각 키는 자체 예산, 속도 제한, 모델 접근 목록, TTL을 가질 수 있다.

![LiteLLM 관리 대시보드](images/litellm-dashboard.png)

```bash
# "프론트엔드 팀"용 가상 키 생성
curl -X POST http://localhost:4000/key/generate \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "key_alias": "frontend-team-key",
    "team_id": "frontend-team",
    "models": ["gpt-4o", "gemini-flash"],
    "max_budget": 500.00,
    "budget_duration": "30d",
    "rpm_limit": 100,
    "tpm_limit": 50000,
    "metadata": {
      "service": "customer-chat-widget",
      "env": "production"
    }
  }'

# 응답:
# {
#   "key": "sk-litellm-abc123...",
#   "expires": null,
#   "max_budget": 500.00,
#   "models": ["gpt-4o", "gemini-flash"]
# }
```

### 공급자 수준 예산 상한

```yaml
general_settings:
  provider_budget_config:
    openai:
      monthly_budget: 5000.00
    anthropic:
      monthly_budget: 3000.00
    gemini:
      monthly_budget: 1000.00
```

### 지연 시간 기반 라우팅

```yaml
router_settings:
  routing_strategy: latency-based-routing
  routing_strategy_args:
    ttl: 60
  allowed_fails: 3
  cooldown_time: 60
  num_retries: 2
  timeout: 90
  retry_after: 5
```

### 보안 체크리스트

```yaml
# 보안 강화된 config.yaml
general_settings:
  master_key: os.environ/LITELLM_MASTER_KEY
  database_url: os.environ/DATABASE_URL

  # 프로덕션에서 HTTPS 강제
  # Nginx 또는 AWS ALB 뒤에서 TLS 종료로 실행

  # 상세 로깅 비활성화
  litellm_settings:
    set_verbose: false

  # 저장 시 키 암호화
  litellm_settings:
    key_generation_algorithm: "rsa"
    allow_user_auth: false
```

### Kubernetes / Helm 배포

```bash
# LiteLLM Helm 저장소 추가
helm pull oci://docker.litellm.ai/berriai/litellm-helm

# 사용자 정의 값으로 설치
helm install litellm-gateway ./litellm-helm \
  --namespace litellm \
  --create-namespace \
  --set replicaCount=3 \
  --set ingress.enabled=true \
  --set ingress.hosts[0].host=litellm.yourdomain.com \
  --set env.LITELLM_MASTER_KEY="sk-$(openssl rand -hex 16)" \
  --set env.DATABASE_URL="postgresql://user:pass@neon-host/litellm"
```

### Prometheus + Grafana 모니터링

```yaml
# config.yaml에 추가
litellm_settings:
  success_callback: ["prometheus"]
  failure_callback: ["prometheus"]
```

`/metrics`에서 노출되는 주요 Prometheus 메트릭:

```promql
# 모델별 요청 속도
rate(litellm_request_total_requests[5m])

# 오류율
rate(litellm_requests_total_failed[5m])

# 키별 남은 예산
litellm_remaining_requests

# 게이트웨이 오버헤드 히스토그램
histogram_quantile(0.95, litellm_overhead_latency_ms_bucket)
```

요청/초, 토큰 사용량, 팀별 비용, 지연 시간 백분위수를 보여주는 사전 구축된 패널을 위해 [공식 Grafana 대시보드](https://github.com/BerriAI/litellm/blob/main/examples/grafana/grafana_dashboard.json)를 가져온다.

---

## 대안과의 비교

| 기능 | LiteLLM | Portkey | OpenRouter | Helicone |
|------|---------|---------|------------|----------|
| **라이선스** | MIT (오픈소스) | 폐쇄형 코어 + 오픈 SDK | 폐쇄형 (호스팅) | 폐쇄형 (호스팅 + 자체 호스팅) |
| **배포 방식** | 자체 호스팅 / Docker / K8s | 클라우드 + 하이브리드 | 호스팅 전용 | 클라우드 + 자체 호스팅 |
| **지원 모델** | 100+ 공급자 | 200+ | 300+ | 공급자 의존 |
| **자체 호스팅 비용** | $200–800/월 인프라 | N/A (관리형) | N/A (호스팅) | $0–100/월 (자체 호스팅) |
| **가상 키/예산** | 키별 + 팀별 | 키별 + 사용자별 | 기본 키별 | 조직별 |
| **자동 폴오버** | 구성 가능한 체인 | 서킷 브레이커 | 공급자 라우팅 | 제한적 |
| **시맨틱 캐싱** | Redis + Qdrant | 내장 | 없음 | 없음 |
| **관찰 가능성** | Prometheus + 외부 | 내장 심층 추적 | 기본 사용량 통계 | 핵심 초점 |
| **규정 준수** | DIY (인프라로 SOC2) | SOC 2, ISO 27001, HIPAA | 부분 | SOC 2 |
| **최적 사용** | 완전한 제어, 제로 종속 | 엔터프라이즈 거버넌스 | 빠른 모델 접근 | 관찰 가능성 우선 |

**선택 가이드:**

- **LiteLLM** — DevOps 역량이 있고, 제로 벤더 종속을 원하며, 라우팅, 캐싱, 데이터 상주에 대한 완전한 제어가 필요한 경우.
- **Portkey** — 엔터프라이즈 거버넌스(SOC 2, 감사 로그), 프롬프트 관리 UI가 필요하고 SaaS 요금을 지불할 의향이 있는 경우.
- **OpenRouter** — 제로 인프라 작업으로 300+ 모델에 즉시 접근하고, 5.5% 크레딧 수수료가 허용 가능한 경우.
- **Helicone** — 관찰 가능성이 1차 우선순위이고, LLM 호출에 대한 상세한 추적과 비용 귀속이 필요한 경우.

---

## 한계 / 솔직한 평가

LiteLLM은 모든 상황에 적합한 도구가 아니다. 다음은 부족한 점이다:

1. **운영 오버헤드** — 관리형 게이트웨이와 달리, 가동 시간, 스케일링, 보안 패치, 데이터베이스 백업을 직접 관리한다. 프로덕션 유지보수를 위해 0.5–1 FTE를 예산에 잡는다.

2. **내장 프롬프트 관리 없음** — Portkey의 A/B 테스트가 포함된 프롬프트 버전 UI는 LiteLLM에 존재하지 않는다. 프롬프트 템플릿은 애플리케이션이나 외부 도구에서 관리한다.

3. **시맨틱 캐싱에 추가 인프라 필요** — Redis 시맨틱 캐시는 임베딩 모델 엔드포인트가 필요하다. 이는 Portkey의 내장 시맨틱 캐싱과 비교하여 복잡성과 비용을 추가한다.

4. **네이티브 다중 리전 중복 없음** — DNS 또는 글로벌 로드 밸런서를 사용한 다중 리전 페일오버를 직접 설계한다. LiteLLM은 기본적으로 단일 리전 프록시이다.

5. **엔터프라이즈 SSO 유료** — SAML/SSO, 감사 로그, 고급 가드레일은 LiteLLM Enterprise의 일부이다. OSS 버전은 가상 키와 기본 예산만 처리한다.

---

## 자주 묻는 질문

**Q: LiteLLM과 OpenRouter는 어떻게 비교되나요?**

LiteLLM은 자체 호스팅 오픈소스 게이트웨이이다; OpenRouter는 관리형 멀티 모델 API이다. LiteLLM은 제로 마크업과 데이터에 대한 완전한 제어를 제공한다. OpenRouter는 5.5% 크레딧 구매 수수료를 부과하지만 인프라 작업이 전혀 필요 없다. 월 LLM 소비 $5,000 이상이고 DevOps 역량이 있는 팀에게 LiteLLM이 장기적으로 더 저렴하다. 빠른 프로토타이핑에는 OpenRouter가 더 빠르게 배포된다.

**Q: 기존 OpenAI SDK 코드와 LiteLLM을 함께 사용할 수 있나요?**

예 — 두 줄만 변경하면 된다: `base_url`을 LiteLLM 프록시로 설정하고, `api_key`를 가상 키로 설정한다. 나머지는 그대로 유지된다. 이것이 팀이 LiteLLM을 채택하는 주된 이유이다; 구성 외에는 코드 변경이 전혀 없다.

**Q: LiteLLM에 어떤 데이터베이스가 필요한가요?**

프로덕션 기능(가상 키, 소비 추적, 팀 관리)에 PostgreSQL 14+가 필요하다. 기본 통과 라우팅을 위해 데이터베이스 없이 프록시를 실행할 수 있지만, 예산 관리, 키 관리, 관리 UI를 잃게 된다.

**Q: 폴오버 메커니즘은 어떻게 작동하나요?**

`config.yaml`에서 폴오버 체인을 정의한다. 모델이 429, 500 또는 타임아웃을 반환하면, LiteLLM이 동일한 클라이언트 요청 내에서 체인의 다음 모델에 대해 요청을 재시도한다. 클라이언트는 단일 응답을 본다; 페일오버는 투명하게 발생한다.

**Q: LiteLLM은 고트래픽 프로덕션 사용에 적합한가요?**

예 — Redis 캐싱과 로드 밸런서 뒤의 2개 이상 복제본을 갖추고, LiteLLM은 1,000+ RPS를 처리한다. 데이터베이스 연결 풀과 Redis 트랜잭션 버퍼가 확장 병목이다, 프록시 자체가 아니다. Kubernetes에서는 HPA가 있는 Helm Chart를 사용하여 자동 확장한다.

**Q: 프로덕션에서 LiteLLM을 어떻게 모니터링하나요?**

`config.yaml`에서 Prometheus 콜백을 활성화하고, `/metrics` 엔드포인트를 스크래핑하고, 공식 Grafana 대시보드를 가져온다. `litellm_requests_total_failed`(오류율)과 `litellm_remaining_requests`(예산 소진)에서 알림을 설정한다. 요청별 추적을 위해 `success_callback`을 Langfuse에 연결한다.

---

## 결론

LiteLLM은 프로덕션 멀티 LLM 배포의 지저분한 현실을 해결한다: 여러 SDK, 흩어진 API 키, 불투명한 비용, 수동 페일오버. 단일 `config.yaml`로 통합된 OpenAI 호환 게이트웨이, 예산이 있는 가상 키, 자동 페일오버, 실시간 소비 추적을 얻는다.

월 LLM API 소비 $5,000+이고 기본 DevOps 역량이 있는 팀에게, 자체 호스팅 LiteLLM은 낮은 마크업 수수료와 향상된 신뢰성으로 비용을 회수한다. 위의 Docker Compose 설정으로 시작하고, Redis 캐싱을 추가한 다음, 트래픽 증가에 따라 Helm을 사용하여 Kubernetes로 확장한다.

**실행 항목:**

1. [LiteLLM GitHub 저장소](https://github.com/BerriAI/litellm)를 클론하고 Docker Compose 퀵스타트 실행
2. 각 팀에 대한 가상 키 생성 및 키별 예산 설정
3. Redis 캐싱 및 Prometheus 모니터링 활성화
4. 지원 및 기능 논의를 위해 [LiteLLM Discord 커뮤니티](https://discord.gg/wupm9ySymB)에 참여

*일부 링크는 제휴 링크입니다. 호스팅 서비스를 통해 구매하면 커미션을 받을 수 있습니다 — 이는 가격이나 추천에 영향을 미치지 않습니다.*

---



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 참고 자료

- [LiteLLM GitHub 저장소](https://github.com/BerriAI/litellm) — 공식 소스 코드, 22,500+ 스타
- [LiteLLM 문서](https://docs.litellm.ai/docs/) — 완전한 프록시 및 SDK 참조
- [LiteLLM Docker 퀵스타트](https://docs.litellm.ai/docs/proxy/docker_quick_start) — 공식 Docker 설정 가이드
- [LiteLLM 설정 참조](https://docs.litellm.ai/docs/proxy/configs) — 모든 config.yaml 옵션
- [LiteLLM Helm 배포](https://docs.litellm.ai/docs/proxy/deploy) — Kubernetes 및 Helm 차트
- [LiteLLM 관리 UI 문서](https://docs.litellm.ai/docs/proxy/ui) — 가상 키 및 팀 관리
- [LiteLLM 캐싱 가이드](https://docs.litellm.ai/docs/caching/all_caches) — Redis, 시맨틱, 디스크 캐싱
- [Portkey vs LiteLLM 비교](https://portkey.ai/lp/portkey-vs-litellm) — 벤더 비교 페이지
- [OpenRouter 문서](https://openrouter.ai/docs) — 대안 게이트웨이 참조
- [Helicone 문서](https://docs.helicone.ai) — 관찰 가능성 중심 대안
