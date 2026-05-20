---
title: 'Portkey AI Gateway 2026: 200+ 모델을 관리하는 LLM 게이트웨이와 관찰 가능성 — 프로덕션 설정'
description: ''
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/Portkey-AI/gateway'
stars: 14000
maintainer: 'Portkey-AI'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Portkey AI Gateway']
aliases:
- /kr/posts/portkey-ai-gateway-production/
---

{{</* resource-info */>}}

프로덕션 환경에서 여러 대규모 언어 모델(LLM) 제공업체를 관리하는 것은 악몽과 같습니다. 각 제공업체는 고유한 API 형식, 인증 체계, 속도 제한 및 장애 모드를 가지고 있습니다. 애플리케이션 코드에는 OpenAI, Anthropic, Google, Azure 및 매달 등장하는 수십 개의 새로운 제공업체에 대한 조걸 로직이 가득합니다. **Portkey AI Gateway**를 소개합니다 — 단일 API 뒤에 200개 이상의 모델을 통합하고, 부하 분산, 폴 백 라우팅, 지출 추적, 요청 캐싱 및 엔터프라이즈급 관찰 가능성을 갖춘 오픈소스 LLM 게이트웨이입니다.

이 종합 가이드에서 프로덕션 준비가 된 Portkey AI Gateway 설정을 안내합니다. 여러 제공업체 간에 요청을 라우팅하고, 지능형 폴 백을 구현하고, 지출을 모니터링하고, 응답을 캐싱하고, 가드레일을 적용하는 방법을 배우게 됩니다 — 그 모든 동안 애플리케이션 코드를 깔끔하고 제공업체에 독립적으로 유지합니다.

> **빠른 시작**: Portkey AI Gateway는 MIT 라이선스 하에 오픈소스이며 14,000개 이상의 GitHub 스타를 보유하고 있습니다. 자체 호스팅하거나 관리형 클라우드 옵션을 사용할 수 있습니다. 준비되셨나요? 시작해 봅시다.

---

## Portkey AI Gateway란 무엇인가?

Portkey AI Gateway는 애플리케이션과 LLM 제공업체 사이에 위치하는 오픈소스 AI 게이트웨이입니다. AI 워크로드를 위해 특별히 설계된 스마트 리버스 프록시로 생각하면 됩니다. OpenAI, Anthropic, Google, Azure, Cohere, Mistral 등 20개 이상의 제공업체에서 200개 이상의 모델에 대한 API 표면을 정규화하여 코드가 한 가지 언어만 사용하면 됩니다.

게이트웨이는 LLM 프로덕션 배포의 지저분한 부분을 처리합니다:

- **통합 API**: 20개 이상의 제공업체에 걸쳐 200개 이상의 모델을 위한 하나의 엔드포인트
- **부하 분산**: 여러 API 키 또는 제공업체 간에 트래픽 분산
- **폴 백 라우팅**: 제공업체가 다울 때 자동으로 페일오버
- **요청 캐싱**: 비용과 지연 시간을 줄이기 위해 동일한 요청을 캐싱
- **지출 추적**: AI 지출에 대한 실시간 가시성
- **프롬프트 관리**: 코드와 독립적으로 프롬프트 버전 관리 및 관리
- **가드레일**: 콘텐츠 정책 및 안전 검사 시행
- **관찰 가능성**: 전체 요청/응답 로깅, 메트릭 및 추적

단일 모델을 실행하는 스타트업이든 수십 개의 제공업체를 관리하는 엔터프라이즈든, Portkey는 AI 애플리케이션을 프로덕션화하는 데 필요한 인프라 계층을 제공합니다.

---

## 아키텍처 개요 및 배포 옵션

Portkey AI Gateway는 **클우드(관리형)** 및 **자체 호스팅** 두 가지 배포 모드를 제공합니다. 아키텍처는 LLM 요청을 가로채고, 구성된 정책을 적용하고, 적절한 제공업체에 라우팅하는 경량 고성능 게이트웨이 서버를 중심으로 구축되었습니다.

### 클라우드 배포

가장 빠르게 시작하는 방법은 Portkey의 관리형 클라우드 서비스를 사용하는 것입니다. [Portkey.ai](https://portkey.ai)에서 가입하고 API 키를 생성하면 요청을 라우팅할 준비가 됩니다. 클라우드 옵션은 확장, 업데이트 및 인프라 유지 관리를 처리합니다.

### 자체 호스팅 배포

엄격한 데이터 상주 또는 보안 요구 사항이 있는 조직의 경우 자체 호스팅이 최선의 방법입니다. 게이트웨이는 Docker, Kubernetes 또는 독립형 Node.js 애플리케이션으로 배포할 수 있습니다.

**Docker로 배포:**

```bash
# 저장소 복제
git clone https://github.com/Portkey-AI/gateway.git
cd gateway

# Docker로 실행
docker run -p 8787:8787 -e PORTKEY_GATEWAY_API_KEY=your-gateway-key portkeyai/gateway:latest
```

**Docker Compose로 배포:**

```yaml
version: '3.8'
services:
  portkey-gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - CACHE_ENABLED=true
      - CACHE_TTL=3600
    volumes:
      - ./config:/app/config
    restart: unless-stopped
```

**Kubernetes에 배포:**

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: portkey-gateway
spec:
  replicas: 3
  selector:
    matchLabels:
      app: portkey-gateway
  template:
    metadata:
      labels:
        app: portkey-gateway
    spec:
      containers:
      - name: gateway
        image: portkeyai/gateway:latest
        ports:
        - containerPort: 8787
        env:
        - name: PORTKEY_GATEWAY_API_KEY
          valueFrom:
            secretKeyRef:
              name: portkey-secrets
              key: gateway-api-key
---
apiVersion: v1
kind: Service
metadata:
  name: portkey-gateway-service
spec:
  selector:
    app: portkey-gateway
  ports:
  - port: 80
    targetPort: 8787
  type: ClusterIP
```

프로덕션 배포의 경우 Kubernetes를 사용하고 고가용성을 위해 최소 3개의 복제본을 권장합니다. 클러스터를 호스팅할 수 있는 신뢰할 수 있는 클라우드 플랫폼이 필요한 경우, [DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0)는 Portkey와 완벽하게 어울리는 개발자 친화적인 관리형 Kubernetes 서비스를 제공합니다.

---

## 제공업체 및 API 키 구성

요청을 라우팅하기 전에 LLM 제공업체를 구성해야 합니다. Portkey는 API 키를 안전하게 저장하고 이를 명명된 제공업체 인스턴스에 매핑하는 제공업체 구성 시스템을 사용합니다.

### 제공업체 설정

`providers.yaml` 구성 파일 생성:

```yaml
providers:
  openai-primary:
    type: openai
    api_key: ${OPENAI_API_KEY}
    organization: ${OPENAI_ORG_ID}
    
  anthropic-primary:
    type: anthropic
    api_key: ${ANTHROPIC_API_KEY}
    
  azure-gpt4:
    type: azure-openai
    api_key: ${AZURE_API_KEY}
    resource_name: ${AZURE_RESOURCE_NAME}
    deployment_id: gpt-4
    api_version: 2025-12-01
    
  google-gemini:
    type: google
    api_key: ${GOOGLE_API_KEY}
    
  mistral-local:
    type: mistral
    api_key: ${MISTRAL_API_KEY}
    base_url: http://mistral-service:8000/v1
```

### 구성 로드

```bash
# 환경 변수 설정
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GATEWAY_API_KEY="pk-..."

# 구성과 함께 게이트웨이 시작
docker run -p 8787:8787 \
  -e PORTKEY_GATEWAY_API_KEY=$GATEWAY_API_KEY \
  -v $(pwd)/providers.yaml:/app/config/providers.yaml \
  portkeyai/gateway:latest
```

---

## 통합 API: 200개 이상의 모델을 위한 하나의 엔드포인트

Portkey의 핵심 가치는 통합 API입니다. 어떤 모델이나 제공업체를 호출하든 요청 형식은 동일합니다. 게이트웨이는 정규화된 Portkey 형식과 각 제공업체의 네이티브 형식 간의 변환을 처리합니다.

### 기본 대화 완성 요청

```bash
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-4o",
    "provider": "openai-primary",
    "messages": [
      {"role": "system", "content": "당신은 유용한 어시스턴트입니다."},
      {"role": "user", "content": "양자 컴퓨팅을 간단한 용어로 설명하세요."}
    ]
  }'
```

### 제공업체 즉시 전환

```bash
# 동일한 요청, 다른 제공업체 — model/provider 필드만 변경
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "claude-sonnet-4",
    "provider": "anthropic-primary",
    "messages": [
      {"role": "user", "content": "양자 컴퓨팅을 간단한 용어로 설명하세요."}
    ],
    "max_tokens": 1024
  }'
```

### Python SDK 예제

```python
from portkey_ai import Portkey

# 클라이언트 초기화
portkey = Portkey(
    api_key="your-gateway-api-key",
    virtual_key="openai-primary"  # 구성된 제공업체 참조
)

# 대화 완성
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": "당신은 유용한 어시스턴트입니다."},
        {"role": "user", "content": "피볂치 수를 계산하는 Python 함수를 작성하세요."}
    ]
)
print(response.choices[0].message.content)
```

### 스트리밍 응답

```python
import portkey_ai

portkey = portkey_ai.Portkey(api_key="your-gateway-api-key")

stream = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "AI에 대한 시를 써주세요."}],
    stream=True
)

for chunk in stream:
    if chunk.choices[0].delta.content:
        print(chunk.choices[0].delta.content, end="")
```

---

## 부하 분산 및 폴 백 라우팅

프로덕션 AI 시스템은 제공업체 중단을 용납할 수 없습니다. Portkey의 부하 분산 및 폴 백 라우팅은 제공업체가 실패할 때도 애플리케이션이 온라인 상태를 유지하도록 보장합니다.

### 라운드 로빈 부하 분산

여러 API 키 또는 제공업체 간에 트래픽을 균등하게 분산합니다:

```yaml
# config/load-balance.yaml
strategies:
  gpt4-pool:
    type: load_balance
    providers:
      - provider: openai-primary
        weight: 1
      - provider: azure-gpt4
        weight: 1
      - provider: openai-backup
        weight: 1
```

```python
# 부하 분산 풀 사용
response = portkey.chat.completions.create(
    model="gpt-4o",
    config="gpt4-pool",  # 전략 참조
    messages=[{"role": "user", "content": "안녕하세요!"}]
)
```

### 우선순위 기반 폴 백 라우팅

자동 페일오버를 위한 폴 백 체인을 정의합니다:

```yaml
strategies:
  production-fallback:
    type: fallback
    targets:
      - provider: azure-gpt4
        timeout: 10
        retry: 2
      - provider: openai-primary
        timeout: 15
        retry: 1
      - provider: anthropic-primary
        model: claude-sonnet-4
        timeout: 15
      - provider: google-gemini
        model: gemini-2.5-pro
        timeout: 20
```

```bash
# 게이트웨이는 성공할 때까지 순서대로 각 대상을 시도합니다
curl -X POST http://localhost:8787/v1/chat/completions \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "config": "production-fallback",
    "messages": [{"role": "user", "content": "중요한 비즈니스 질문"}]
  }'
```

### 요청 속성 기반 조걸 라우팅

콘텐츠, 사용자 또는 기타 요청 속성을 기반으로 요청을 라우팅합니다:

```yaml
strategies:
  smart-router:
    type: conditional
    rules:
      - condition: "request.messages[0].content.length > 4000"
        target: 
          provider: anthropic-primary
          model: claude-sonnet-4  # 더 나은 긴 컨텍스트 처리
      - condition: "request.user == 'code-assistant'"
        target:
          provider: openai-primary
          model: gpt-4o
      - condition: "default"
        target:
          provider: azure-gpt4
          model: gpt-4o-mini
```

---

## 요청 캐싱: 비용 및 지연 시간 감소

LLM API 호출은 비용이 많이 들고 느립니다. Portkey의 의미론적 캐싱은 응답을 저장하고 유사한 쿼리에 대해 캐시된 결과를 제공하여 비용과 지연 시간을 크게 줄입니다.

### 캐시 활성화

```yaml
cache:
  enabled: true
  mode: semantic  # 또는 "exact"는 정확한 일치 캐싱용
  ttl: 3600       # 캐시 생존 시간(초)
  max_size: 10000 # 최대 캐시 항목 수
  similarity_threshold: 0.95  # 의미론적 캐싱용
```

```python
# 첫 번째 호출은 제공업체를 타고 결과를 캐싱합니다
response1 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Kubernetes란 무엇인가요?"}],
    cache=True
)

# 유사한 호출은 즉시 캐시된 결과를 반환합니다
response2 = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "Kubernetes에 대해 설명해주세요"}],
    cache=True
)
```

### 캐시 통계 및 무효화

```bash
# 캐시 메트릭 확인
curl http://localhost:8787/v1/admin/cache/stats \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# 특정 캐시 항목 무효화
curl -X POST http://localhost:8787/v1/admin/cache/invalidate \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}" \
  -H "Content-Type: application/json" \
  -d '{
    "pattern": "kubernetes",
    "provider": "openai-primary"
  }'
```

---

## 지출 추적 및 비용 관찰 가능성

제공업체, 모델 및 사용자별 AI 지출을 이해하는 것은 예산 관리에 매우 중요합니다. Portkey는 세분화된 비용 추적을 즉시 제공합니다.

### 비용 추적 설정

```python
import portkey_ai

portkey = portkey_ai.Portkey(
    api_key="your-gateway-api-key",
    metadata={
        "user_id": "user-12345",
        "project": "customer-support-bot",
        "environment": "production",
        "team": "ai-platform"
    }
)

response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "내 주문을 도와주세요"}]
)

# 응답에서 비용 정보에 액세스
print(f"입력 토큰: {response.usage.prompt_tokens}")
print(f"출력 토큰: {response.usage.completion_tokens}")
print(f"총 비용: ${response.usage.estimated_cost}")
```

### 지출 분석 쿼리

```bash
# 제공업첼별 지출 보고서 가져오기
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=provider" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```bash
# 사용자별 지출 보고서 가져오기
curl "http://localhost:8787/v1/admin/analytics/spend?start_date=2026-05-01&end_date=2026-05-19&group_by=user_id" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

### 예산 알림

```yaml
alerts:
  daily-budget:
    type: budget
    threshold: 500  # USD
    period: daily
    channels:
      - type: webhook
        url: https://hooks.slack.com/services/YOUR/WEBHOOK/URL
      - type: email
        address: team@company.com
  
  abnormal-spike:
    type: anomaly
    baseline_multiplier: 3
    window: 1h
    channels:
      - type: pagerduty
        integration_key: your-pd-key
```

---

## 프롬프트 관리 및 버전 관리

프롬프트를 애플리케이션 코드와 별도로 관리하면 기술이 아닌 팀원이 배포 없이 프롬프트를 반복할 수 있습니다. Portkey의 프롬프트 관리 시스템은 버전 관리, A/B 테스트 및 동적 변수 대체를 제공합니다.

### 관리형 프롬프트 생성

```python
from portkey_ai import Portkey

portkey = Portkey(api_key="your-gateway-api-key")

# 프롬프트 버전 배포
prompt = portkey.prompts.deploy(
    name="customer-support-classifier",
    version="1.2.0",
    prompt=[
        {"role": "system", "content": "당신은 지원 티켓 분류기입니다. 티켓을 다음으로 분류하세요: 결제, 기술, 기능 요청 또는 불만."},
        {"role": "user", "content": "티켓: {{ticket_content}}"}
    ],
    model="gpt-4o-mini",
    parameters={
        "temperature": 0.2,
        "max_tokens": 50
    }
)
```

### 변수로 프롬프트 렌더링

```python
# 관리형 프롬프트 렌더링 및 실행
response = portkey.prompts.render(
    name="customer-support-classifier",
    variables={
        "ticket_content": "이번 달에 구독이 두 번 청구되었습니다."
    }
)

print(response.choices[0].message.content)
# 출력: "결제"
```

### 프롬프트 A/B 테스트

```python
# 프롬프트 버전 간 A/B 테스트 실행
response = portkey.prompts.render(
    name="customer-support-classifier",
    version="1.2.0",  # 50% 트래픽
    test_version="1.3.0-beta",  # 50% 트래픽
    variables={"ticket_content": "사진 업로드 시 앱이 충돌합니다"}
)
```

---

## 가드레일 및 콘텐츠 안전

Portkey의 가드레일 시스템을 사용하면 요청과 응답 모두에서 콘텐츠 정책을 시행하여 안전 표준 및 비즈니스 규칙을 준수할 수 있습니다.

### 가드레일 구성

```yaml
guardrails:
  input-validation:
    - type: keyword_filter
      blocklist: ["password", "ssn", "credit_card", "secret_key"]
      action: block
    - type: pii_detector
      entities: ["email", "phone", "ssn"]
      action: mask
    - type: toxicity_check
      threshold: 0.8
      action: block
      
  output-validation:
    - type: content_policy
      categories: ["hate", "violence", "self-harm"]
      action: block
    - type: response_format
      required_schema:
        type: json_object
      action: retry
```

```python
# 요청에 가드레일 적용
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "사용자 입력 내용"}],
    guardrails=["input-validation", "output-validation"]
)
```

### 사용자 정의 가드레일 함수

```python
from portkey_ai import Portkey
import json

portkey = Portkey(api_key="your-gateway-api-key")

def custom_validator(request, response):
    """사용자 정의 비즈니스 로직 검증."""
    try:
        data = json.loads(response.choices[0].message.content)
        if "confidence" not in data or data["confidence"] < 0.7:
            return False, "신뢰도 점수가 너무 낮습니다"
        return True, None
    except json.JSONDecodeError:
        return False, "응답은 유효한 JSON이어야 합니다"

portkey.guardrails.register("confidence-check", custom_validator)
```

---

## 관찰 가능성: 로깅, 메트릭 및 추적

프로덕션 환경에서 AI 시스템의 동작을 이해하는 것은 필수적입니다. Portkey는 요청/응답 로깅, 토큰 사용 메트릭, 지연 시간 히스토그램 및 분산 추적을 통해 포괄적인 관찰 가능성을 제공합니다.

### 요청 로깅

```bash
# 최근 요청 로그 쿼리
curl "http://localhost:8787/v1/admin/logs?limit=100&status=error" \
  -H "Authorization: Bearer ${GATEWAY_API_KEY}"
```

```python
# 요청별 상세 로깅 활성화
response = portkey.chat.completions.create(
    model="gpt-4o",
    messages=[{"role": "user", "content": "안녕하세요"}],
    metadata={
        "trace_id": "trace-abc-123",
        "session_id": "session-xyz-789",
        "user_id": "user-456"
    }
)
```

### OpenTelemetry 통합

```yaml
observability:
  tracing:
    enabled: true
    exporter: otlp
    endpoint: http://jaeger-collector:4317
  metrics:
    enabled: true
    exporter: prometheus
    port: 9090
```

### Prometheus 메트릭

게이트웨이는 `/metrics`에서 Prometheus 호환 메트릭을 노출합니다:

```bash
# 메트릭 스크래핑
curl http://localhost:8787/metrics
```

주요 메트릭:
- `portkey_requests_total` — 제공업체, 모델, 상태별 총 요청 수
- `portkey_request_duration_seconds` — 요청 지연 시간 히스토그램
- `portkey_tokens_total` — 유형(입력/출력) 및 모델별 토큰 사용량
- `portkey_cache_hits_total` — 캐시 적중/미적중 카운트
- `portkey_spend_total` — 추정 지출(USD)

### Grafana 대시보드

Portkey의 공식 Grafana 대시보드(ID: `portkey-ai-gateway`)를 가져와 즉시 사용 가능한 시각화를 얻으세요:

```json
{
  "dashboard": {
    "title": "Portkey AI Gateway 개요",
    "panels": [
      {
        "title": "초당 요청 수",
        "targets": [
          {
            "expr": "rate(portkey_requests_total[5m])"
          }
        ]
      },
      {
        "title": "P95 지연 시간",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, portkey_request_duration_seconds_bucket)"
          }
        ]
      },
      {
        "title": "토큰 사용량",
        "targets": [
          {
            "expr": "sum by (model) (portkey_tokens_total)"
          }
        ]
      }
    ]
  }
}
```

---

## 프로덕션 배포 체크리스트

Portkey AI Gateway를 프로덕션에 도입하기 전에 다음 중요 항목을 확인했는지 확인하세요:

### 인프라

```yaml
# Redis 캐싱 및 PostgreSQL 로그가 있는 프로덕션 docker-compose
version: '3.8'
services:
  gateway:
    image: portkeyai/gateway:latest
    ports:
      - "8787:8787"
    environment:
      - PORTKEY_GATEWAY_API_KEY=${GATEWAY_API_KEY}
      - REDIS_URL=redis://redis:6379
      - DATABASE_URL=postgres://user:pass@postgres:5432/portkey
    depends_on:
      - redis
      - postgres
    deploy:
      replicas: 3
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
  
  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data
  
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: portkey
      POSTGRES_USER: user
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

volumes:
  redis-data:
  postgres-data:
```

### 보안 체크리스트

| 항목 | 상태 | 참고 |
|------|------|------|
| API 키 교체 | 필수 | 월별 게이트웨이 키 교체 |
| TLS 종료 | 필수 | 리버스 프록시 또는 로드 밸런서 사용 |
| 속도 제한 | 필수 | 사용자당 및 IP당 제한 구성 |
| PII 마스킹 | 권장 | 프로덕션 워크로드에 대해 활성화 |
| 감사 로깅 | 필수 | 모든 관리 작업 로깅 |
| 네트워크 격리 | 권장 | 프라이빗 서브넷에 배포 |

### 헬스 체크

```bash
# 게이트웨이 헬스 엔드포인트
curl http://localhost:8787/health

# 예상 응답
{"status": "healthy", "version": "2.5.0", "uptime": 86400}
```

```yaml
# Kubernetes 활성 및 준비 프로브
livenessProbe:
  httpGet:
    path: /health
    port: 8787
  initialDelaySeconds: 10
  periodSeconds: 15

readinessProbe:
  httpGet:
    path: /ready
    port: 8787
  initialDelaySeconds: 5
  periodSeconds: 5
```

---

## FAQ: Portkey AI Gateway

### Portkey AI Gateway는 어떤 모델을 지원하나요?

Portkey는 OpenAI(GPT-4o, GPT-4o-mini, o3), Anthropic(Claude 4, Claude 3.5), Google(Gemini 2.5), Azure OpenAI, Cohere, Mistral, Together AI, Groq, Perplexity 등 20개 이상의 제공업체에서 200개 이상의 모델을 지원합니다. 새로운 제공업체는 정기적으로 추가됩니다.

### Portkey AI Gateway를 물롭이 자체 호스팅할 수 있나요?

네. Portkey AI Gateway는 MIT 라이선스 하에 오픈소스이며 자체 호스팅이 완전히 물롭입니다. 클라우드 버전은 웹 대시보드 및 고급 분석과 같은 추가 관리 기능을 제공하며 사용량 기반 가격 책정을 제공합니다.

### 요청 캐싱은 어떻게 작동하나요?

Portkey는 두 가지 캐싱 모드를 제공합니다: **정확한 일치**(동일한 요청이 캐시된 응답을 반환) 및 **의미론적 일치**(임베딩 유사도 기반의 유사한 요청이 캐시된 응답을 반환). 캐싱은 TTL 및 유사도 임계값 매개변수를 사용하여 요청별로 구성할 수 있습니다.

### Portkey를 사용할 때 내 데이터는 안전한가요?

자체 호스팅 시 모든 요청 데이터는 인프라 내에 유지됩니다. 게이트웨이는 PII 감지 및 마스킹, 암호화된 API 키 저장 및 감사 로깅을 지원합니다. 클라우드 옵션의 경우 Portkey는 SOC 2 Type II 인증을 받았으며 HIPAA 준수를 위한 비즈니스 연관자 계약(BAA)을 제공합니다.

### 폴 백 라우팅은 제공업체 중단을 어떻게 처리하나요?

폴 백 라우팅은 제공업체의 우선순위 목록을 정의하여 작동합니다. 기본 제공업체가 실패하면(시간 초과, 5xx 오류, 속도 제한) 게이트웨이는 체인의 다음 제공업체로 요청을 자동으로 재시도합니다. 각 대상에 대해 재시도 횟수, 시간 초과 및 오류 조건을 구성할 수 있습니다.

### 기존 OpenAI SDK 코드에서 Portkey를 사용할 수 있나요?

네. Portkey는 OpenAI SDK와 드롭인 호환성을 제공합니다. `base_url`을 게이트웨이 엔드포인트로 변경하고 Portkey API 키를 사용하기만 하면 됩니다:

```python
import openai

client = openai.OpenAI(
    api_key="your-portkey-gateway-key",
    base_url="http://localhost:8787/v1"
)

# 기존 코드가 변경 없이 작동합니다
response = client.chat.completions.create(...)
```

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 결론

Portkey AI Gateway는 여러 LLM 제공업체를 관리하는 복잡성을 해결된 인프라 문제로 전환합니다. 통합 API, 지능형 라우팅, 의미론적 캐싱, 지출 추적 및 포괄적인 관찰 가능성을 통해 제공업체 통합과 씨름하는 대신 훌륭한 AI 애플리케이션을 구축하는 데 집중할 수 있습니다.

관리형 클라우드 옵션을 선택하든 자체 인프라에서 자체 호스팅하든([DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 간편한 Kubernetes 배포를 고려하세요), Portkey는 프로덕션급 AI 시스템에 필요한 안정성, 비용 제어 및 가시성을 제공합니다.

Docker 빠른 시작으로 시작하여, 제공업체를 구성하고, 폴 백 경로가 있는 부하 분산을 설정하고, 캐싱을 활성화하고, 관찰 가능성 스택을 연결하세요. 1시간 이내에 200개 이상의 모델을 처리하고 완전한 관찰 가능성을 갖춘 프로덕션급 LLM 게이트웨이를 갖게 될 것입니다.

---

*게시일: 2026-05-19 | Portkey AI Gateway v2.5.0 | [GitHub: Portkey-AI/gateway](https://github.com/Portkey-AI/gateway)*
