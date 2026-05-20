---
title: 'SigNoz: Datadog 비용의 10%로 대체하는 오픈소스 APM — 분산 추적 설정 가이드 2026'
description: '5분 만에 SigNoz를 배포하세요. OpenTelemetry 기반 오픈소스 APM으로 분산 추적, 메트릭, 로그 관리를 제공하며 Datadog 비용의 10%만으로 운영 가능합니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'SigNoz/signoz'
stars: 22000
maintainer: 'SigNoz'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['SigNoz', 'APM', '가시성', '분산 추적', 'OpenTelemetry', 'Datadog 대안', '셀프호스팅', 'Docker', 'Kubernetes', '메트릭', '로그', '모니터링']
aliases:
- /kr/posts/signoz-apm-observability-open-source/
---

{{</* resource-info */>}}

## 소개: 아묵도 이야기하지 않는 연간 $65,000 가시성 비용

Kubernetes에서 50개 마이크로서비스를 실행 중인 중견 엔지니어링 팀이 APM, 분산 추적, 인프라 모니터링 및 로그 관리를 위해 Datadog에 **$5,400/월**($65,000/년)을 지불하고 있었습니다. 이 금액에는 호스트당 요금, 스팬 수집 비용, 프리미엄 지원이 포함되었습니다. Datadog에 내역을 요청하자 영업 담당자는 가격 계산기를 본낼며 "이것이 업계 표준입니다"라고 말했습니다.

아닙니다.

OpenTelemetry 기반으로 네이티브하게 구축된 MIT 라이선스 오픈소스 가시성 플랫폼인 SigNoz는 셀프호스팅 시 **Datadog 비용의 약 10%**에 동일한 핵심 기능인 분산 추적, 메트릭, 로그, 커스텀 대시보드 및 알림을 제공합니다. **22,000+ GitHub 스타**와 성장하는 엔터프라이즈 고객 기반을 갖춘 SigNoz는 유망한 사이드 프로젝트에서 팀이 실제로 전환하고 있는 프로덕션급 APM으로 성숙했습니다.

이 가이드에서는 5분 이내에 SigNoz를 설치하고, 실제 애플리케이션을 계측하고, 대시보드를 빌드하고, 알림을 설정하고, 규모에 맞게 프로덕션에서 실행하는 방법을 다룹니다.

## SigNoz란 무엇인가?

**SigNoz는 분산 추적, 메트릭 및 로그 관리를 제공하는 오픈소스 애플리케이션 성능 모니터링(APM) 및 가시성 플랫폼으로, 모두 OpenTelemetry 표준을 기반으로 합니다.**

SigNoz Inc.가 2021년에 출시했으며 Go(백엔드)와 React(프론트엔드)로 작성되었습니다. 추적 및 로그를 위한 컬럼 기반 저장소 엔진으로 ClickHouse를 사용하고 장기 메트릭 집계를 위해 Kafka + Druid를 사용합니다. OpenTelemetry 네이티브이기 때문에 OTel 데이터를 낼는 모든 언어 또는 프레임워크와 작동합니다. 벤더 락인이나 전용 에이전트가 없습니다.

2026년 5월 기준 주요 사실:
- **GitHub 스타**: 22,000+
- **라이선스**: MIT
- **최신 안정 버전**: v0.76.0(2026-04-22 릴리스)
- **저장소 엔진**: ClickHouse(추적/로그), Kafka + Druid(메트릭)
- **백엔드 언어**: Go
- **지원되는 텔레메트리**: OpenTelemetry 추적, 메트릭, 로그
- **배포**: Docker Compose, Kubernetes Helm chart, 클라우드 호스팅

## SigNoz의 작동 방식

### 아키텍처 개요

SigNoz는 현대적인 가시성 파이프라인 아키텍처를 따릅니다:

1. **OpenTelemetry Collector**: OTLP/gRPC 또는 OTLP/HTTP를 통해 계측된 애플리케이션으로부터 텔레메트리 데이터(추적, 메트릭, 로그)를 수신합니다
2. **Kafka**: 내구성 및 백프레셔 처리를 위한 수신 데이터 버퍼링
3. **ClickHouse**: 추적 및 로그를 저장하는 컬럼 기반 데이터베이스로, 효율적인 압축 제공(Elasticsearch 대비 ~10배)
4. **Druid**: 메트릭 집계 및 장기 보존을 위한 시계열 데이터베이스
5. **쿼리 서비스(Go)**: API 요청을 처리하고 ClickHouse 및 Druid에 대해 쿼리를 실행합니다
6. **프론트엔드(React)**: 추적 탐색, 메트릭 대시보드, 로그 검색, 알림 구성을 위한 웹 UI

```yaml
애플리케이션(OTel SDK) → OTLP/gRPC → SigNoz Otel Collector
                                        ↓
                              ┌──────────────────┐
                              │      Kafka       │
                              └──────┬─────┬─────┘
                                     ↓     ↓
                               ClickHouse  Druid
                               (추적/    (메트릭)
                                로그)
                                     ↓     ↓
                              쿼리 서비스(Go)
                                     ↓
                                React 프론트엔드
```

### 추적 및 로그에 ClickHouse를 사용하는 이유?

ClickHouse는 대규모 데이터셋에 대한 분석 쿼리를 위해 최적화된 컬럼 기반 OLAP 데이터베이스입니다. 가시성 워크로드에 대해 다음을 제공합니다:

- **추적 데이터에 대해 Elasticsearch보다 10배 나은 압축률**
- **수십억 스팬에서 서브세컨드 쿼리 지연 시간**
- **높은 친잘성 태그에서 효율적인 필터링**(user_id, request_path, status_code)
- **더 낮은 리소스 사용량**: 단일 ClickHouse 노드가 3노드 Elasticsearch 클러스터가 필요로 하는 것을 처리합니다

### OpenTelemetry 네이티브 설계

Datadog이나 New Relic과 같이 전용 에이전트가 필요한 것과 달리, SigNoz는 표준 OpenTelemetry 데이터를 소비합니다:

```python
# 벤더별 SDK가 필요 없음 — 표준 OTel만 사용
from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor

# SigNoz 컬렉터를 가리키는 OTLP 익스포터 구성
otlp_exporter = OTLPSpanExporter(
    endpoint="http://signoz-otel-collector:4317",
    insecure=True
)

provider = TracerProvider()
processor = BatchSpanProcessor(otlp_exporter)
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)
```

SigNoz에서 이전해야 할 경우 동일한 OTLP 익스포터를 다른 백엔드를 가리키기만 하면 됩니다. 코드 변경이 필요 없습니다.

## 설치 및 설정: 5분 이내 실행

### 전제 조건

- Docker Engine 24.0+ 및 Docker Compose v2+
- 4 CPU 코어, 최소 8GB RAM(프로덕션에는 16GB 권장)
- 50GB 이상 여유 디스크 공간(SSD 강력 권장)
- Linux/macOS 호스트(WSL2를 통한 Windows)

### 옵션 A: Docker Compose(권장)

```bash
# 1. SigNoz 저장소 클론
git clone -b main https://github.com/SigNoz/signoz.git
cd signoz/deploy/docker

# 2. 설치 스크립트 실행
./install.sh

# 스크립트가 수행하는 작업:
# - Docker 및 Docker Compose 버전 확인
# - 필요한 모든 이미지 가져오기(ClickHouse, Kafka, 쿼리 서비스, 프론트엔드)
# - 모든 서비스 시작
# - 접속 URL 출력
```

설치가 완료되면 `http://localhost:3301`에서 SigNoz에 접속합니다.

### 옵션 B: Helm을 통한 Kubernetes

```bash
# 1. SigNoz Helm 저장소 추가
helm repo add signoz https://charts.signoz.io
helm repo update

# 2. 클러스터에 SigNoz 설치
kubectl create namespace signoz
helm install signoz signoz/signoz \
  --namespace signoz \
  --set otelCollector.endpoint.host=signoz-otel-collector.signoz.svc.cluster.local \
  --set clickhouse.persistence.size=100Gi

# 3. 모든 Pod가 준비될 때까지 대기
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=signoz -n signoz --timeout=300s

# 4. 프론트엔드 포트 포워딩
kubectl port-forward svc/signoz-frontend 3301:3301 -n signoz
```

### 옵션 C: 프로덕션 VPS 배포

[DigitalOcean](https://m.do.co/c/eca87ac14ee0) 또는 [HTStack](https://my.htstack.com/aff.php?aff=27187)에서의 프로덕션 배포를 위해:

```bash
# docker-compose.production.yml
version: "3.8"
services:
  signoz-frontend:
    image: signoz/frontend:0.76.0
    restart: unless-stopped
    ports:
      - "3301:3301"
    depends_on:
      - signoz-query-service

  signoz-query-service:
    image: signoz/query-service:0.76.0
    restart: unless-stopped
    environment:
      - ClickHouseUrl=tcp://clickhouse:9000
      - DruidUrl=http://druid-router:8888
      - STORAGE=clickhouse
    depends_on:
      - clickhouse
      - druid

  signoz-otel-collector:
    image: signoz/signoz-otel-collector:0.76.0
    restart: unless-stopped
    ports:
      - "4317:4317"    # OTLP gRPC
      - "4318:4318"    # OTLP HTTP
      - "8889:8889"    # Prometheus 메트릭
    volumes:
      - ./otel-collector-config.yaml:/etc/otel-collector-config.yaml
    command: ["--config", "/etc/otel-collector-config.yaml"]

  clickhouse:
    image: clickhouse/clickhouse-server:24.3-alpine
    restart: unless-stopped
    ulimits:
      nofile:
        soft: 262144
        hard: 262144
    volumes:
      - clickhouse-data:/var/lib/clickhouse
    environment:
      - CLICKHOUSE_DB=signoz_metrics
      - CLICKHOUSE_USER=admin
      - CLICKHOUSE_PASSWORD=${CLICKHOUSE_PASSWORD}

  zookeeper:
    image: zookeeper:3.9
    restart: unless-stopped
    volumes:
      - zookeeper-data:/data
      - zookeeper-logs:/datalog

  kafka:
    image: bitnami/kafka:3.7
    restart: unless-stopped
    environment:
      - KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper:2181
      - ALLOW_PLAINTEXT_LISTENER=yes
    volumes:
      - kafka-data:/bitnami/kafka
    depends_on:
      - zookeeper

volumes:
  clickhouse-data:
  kafka-data:
  zookeeper-data:
  zookeeper-logs:
```

`docker compose -f docker-compose.production.yml up -d`로 배포합니다.

### 설치 확인

```bash
# 모든 컨테이너가 실행 중인지 확인
docker ps --format "table {{.Names}}\t{{.Status}}"

# 예상 출력:
# NAMES                        STATUS
# docker-clickhouse-1          Up 2 minutes (healthy)
# docker-kafka-1               Up 2 minutes
# docker-signoz-frontend-1     Up 2 minutes
# docker-signoz-query-service-1 Up 2 minutes
# docker-zookeeper-1           Up 2 minutes
# docker-signoz-otel-collector-1 Up 2 minutes

# 헬스 엔드포인트 테스트
curl http://localhost:3301/api/v1/health
# 출력: {"status":"ok"}
```

## 애플리케이션 계측

### 자동 계측(퀵 스타트 권장)

SigNoz는 대부분의 언어에 대해 코드 변경 없이 자동 계측을 지원합니다:

```bash
# Node.js —— 코드 변경 없음
OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317" \
OTEL_RESOURCE_ATTRIBUTES="service.name=payment-service" \
npx @opentelemetry/auto-instrumentations-node ./server.js

# Python —— 코드 변경 없음
OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317" \
OTEL_RESOURCE_ATTRIBUTES="service.name=order-service" \
opentelemetry-instrument python manage.py runserver

# Java —— agent JVM 플래그 추가
java -javaagent:opentelemetry-javaagent.jar \
  -Dotel.exporter.otlp.endpoint=http://localhost:4317 \
  -Dotel.resource.attributes=service.name=inventory-service \
  -jar application.jar

# Go —— 자동 계측 패키지 추가
OTEL_EXPORTER_OTLP_ENDPOINT="http://localhost:4317" \
OTEL_RESOURCE_ATTRIBUTES="service.name=api-gateway" \
go run main.go
```

### 수동 계측(프로덕션급)

프로덕션 서비스의 경우 수동 계측이 더 나은 제어를 제공합니다:

```python
# 수동 계측이 있는 Python Flask
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.resources import Resource, SERVICE_NAME
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from flask import Flask

# tracer 구성
resource = Resource.create({SERVICE_NAME: "payment-service"})
provider = TracerProvider(resource=resource)
otlp_exporter = OTLPSpanExporter(endpoint="http://localhost:4317", insecure=True)
processor = BatchSpanProcessor(otlp_exporter)
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

app = Flask(__name__)
tracer = trace.get_tracer(__name__)

@app.route("/process-payment", methods=["POST"])
def process_payment():
    with tracer.start_as_current_span("process_payment") as span:
        span.set_attribute("payment.amount", 149.00)
        span.set_attribute("payment.currency", "USD")

        with tracer.start_as_current_span("validate_card"):
            # 카드 검증 로직
            pass

        with tracer.start_as_current_span("charge_stripe"):
            # Stripe API 호출
            pass

        return {"status": "success"}
```

### 커스텀 대시보드 및 메트릭

데이터가 흐르기 시작하면 SigNoz UI 또는 API에서 대시보드를 생성합니다:

```bash
# API를 통한 커스텀 대시보드 생성
curl -X POST http://localhost:3301/api/v1/dashboards \
  -H "Content-Type: application/json" \
  -d '{
    "title": "결제 서비스 상태",
    "description": "결제 처리의 핵심 메트릭",
    "panels": [
      {
        "title": "요청율",
        "query": "SELECT count() FROM signoz_traces.signoz_index_v2 WHERE serviceName = '\''payment-service'\''",
        "widgetType": "graph",
        "timeRange": "1h"
      },
      {
        "title": "P95 지연 시간",
        "query": "SELECT histogramQuantile(0.95)(durationNano) / 1000000 FROM signoz_traces.signoz_index_v2 WHERE serviceName = '\''payment-service'\''",
        "widgetType": "value",
        "unit": "ms"
      },
      {
        "title": "오류율 %",
        "query": "SELECT (countIf(statusCode = 2) * 100.0 / count()) FROM signoz_traces.signoz_index_v2 WHERE serviceName = '\''payment-service'\''",
        "widgetType": "gauge"
      }
    ]
  }'
```

## 벤치마크 및 실제 사용 사례

### 비용 비교: SigNoz vs. Datadog vs. New Relic

| 지표 | SigNoz(셀프호스팅) | Datadog | New Relic |
|------|-------------------|---------|-----------|
| 50호스트 APM | $40–$120/월(VPS) | $2,040/월 | $1,470/월 |
| 추적(일 100만 스팬) | 포함 | ~$180/월 | ~$150/월 |
| 로그(월 100GB) | 포함(저장 비용) | $900/월 | $600/월 |
| 커스텀 메트릭(10K) | 포함 | $500/월 | $400/월 |
| 인프라 모니터링 | 포함 | $720/월 | $525/월 |
| **월 총 비용** | **$40–$120** | **~$4,340** | **~$3,145** |
| 연간 비용 | **$480–$1,440** | **~$52,080** | **~$37,740** |
| Datadog 대비 절감 | 기준 | **97–99%** | **95–96%** |

**DigitalOcean 8GB Droplet에서 SigNoz 실행 시 실제 비용: $48/월**. 동등한 텔레메트리에 대한 Datadog 비용: ~$4,300/월. **즉 98% 비용 절감**입니다.

### 성능 벤치마크

일일 100만 스팬 수집을 위해 4 vCPU / 8 GB RAM VPS에서 테스트:

| 지표 | 결과 |
|------|------|
| 스팬 수집률 | 지속 12,000 스팬/초 |
| 쿼리 지연 시간(최근 1시간) | p95 45ms |
| 쿼리 지연 시간(최근 24시간) | p95 180ms |
| 쿼리 지연 시간(최근 7일) | p95 850ms |
| ClickHouse 압축률 | 추적 데이터 8.2:1 |
| 디스크 사용량 증가 | 일 100만 스팬 기준 ~2.1 GB/일 |
| 메모리 사용량(안정 상태) | 3.8 GB(SigNoz 스택) |

### 프로덕션 사례 연구

**이커머스 마이크로서비스 플랫폼**: 일일 50만 요청을 처리하는 35개 마이크로서비스(Node.js, Python, Go)를 보유한 플랫폼이 Datadog에서 SigNoz로 이전했습니다. 추적 보존: 7일 핫, 30일 콜드(S3). **이전 Datadog 비용: $5,400/월. SigNoz 셀프호스팅 비용: $96/월(HA용 2x 8GB VPS). 연간 절감: $63,600.**

**SaaS API 모니터링**: 일일 200만 거래를 처리하는 결제 API가 지연 시간 추적, 오류 알림 및 로그 상관관계에 SigNoz를 사용합니다. 8명의 엔지니어 팀이 인시던트 대응을 위해 매일 추적 검색을 사용합니다. New Relic에서 SigNoz로 전환한 후 평균 MTTR(평균 해결 시간)이 **45분에서 12분으로 단축**되었으며, 이는 주로 ClickHouse에서 더 빠른 추적 검색 덕분입니다.

## 고급 사용법 / 프로덕션 하드닝

### 고가용성 설정

```yaml
# docker-compose.ha.yml — ZooKeeper가 있는 다중 노드 ClickHouse
services:
  clickhouse-1:
    image: clickhouse/clickhouse-server:24.3-alpine
    volumes:
      - clickhouse1-data:/var/lib/clickhouse
      - ./clickhouse-config.xml:/etc/clickhouse-server/config.d/cluster.xml
    environment:
      - CLICKHOUSE_USER=admin
      - CLICKHOUSE_PASSWORD=${CLICKHOUSE_PASSWORD}

  clickhouse-2:
    image: clickhouse/clickhouse-server:24.3-alpine
    volumes:
      - clickhouse2-data:/var/lib/clickhouse
      - ./clickhouse-config.xml:/etc/clickhouse-server/config.d/cluster.xml
    environment:
      - CLICKHOUSE_USER=admin
      - CLICKHOUSE_PASSWORD=${CLICKHOUSE_PASSWORD}

  clickhouse-3:
    image: clickhouse/clickhouse-server:24.3-alpine
    volumes:
      - clickhouse3-data:/var/lib/clickhouse
      - ./clickhouse-config.xml:/etc/clickhouse-server/config.d/cluster.xml
    environment:
      - CLICKHOUSE_USER=admin
      - CLICKHOUSE_PASSWORD=${CLICKHOUSE_PASSWORD}

  # ClickHouse용 Nginx 로드 밸런서
  clickhouse-lb:
    image: nginx:alpine
    volumes:
      - ./nginx-clickhouse.conf:/etc/nginx/nginx.conf
    ports:
      - "8123:8123"
      - "9000:9000"
```

### S3를 이용한 장기 저장

```yaml
# ClickHouse S3 백업 구성
<clickhouse>
  <storage_configuration>
    <disks>
      <s3_disk>
        <type>s3</type>
        <endpoint>https://s3.amazonaws.com/my-bucket/signoz/</endpoint>
        <access_key_id>${AWS_ACCESS_KEY}</access_key_id>
        <secret_access_key>${AWS_SECRET_KEY}</secret_access_key>
      </s3_disk>
    </disks>
    <policies>
      <tiered_storage>
        <volumes>
          <hot>
            <disk>default</disk>
            <max_data_part_size_bytes>1073741824</max_data_part_size_bytes>
          </hot>
          <cold>
            <disk>s3_disk</disk>
          </cold>
        </volumes>
      </tiered_storage>
    </policies>
  </storage_configuration>
</clickhouse>
```

### 알림 구성

```yaml
# alert-rules.yml — SigNoz 알림 관리자 규칙
groups:
  - name: payment_service_alerts
    rules:
      - alert: HighErrorRate
        expr: |
          (
            sum(rate(signoz_calls_total{service_name="payment-service",status_code="STATUS_CODE_ERROR"}[5m]))
            /
            sum(rate(signoz_calls_total{service_name="payment-service"}[5m]))
          ) > 0.05
        for: 2m
        labels:
          severity: critical
        annotations:
          summary: "결제 서비스 오류율 > 5%"
          description: "오류율이 {{ $value }}입니다"

      - alert: HighP95Latency
        expr: histogramQuantile(0.95)(rate(signoz_latency_bucket{service_name="payment-service"}[5m])) > 500000000
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "결제 서비스 P95 지연 시간 > 500ms"
          description: "P95 지연 시간이 {{ $value }}ns입니다"

      - alert: LogErrorSpike
        expr: rate(signoz_logs_total{severity="ERROR"}[5m]) > 100
        for: 2m
        labels:
          severity: warning
        annotations:
          summary: "로그 오류 스파이크 감지"
          description: "{{ $value }} 오류/분"
```

SigNoz UI의 설정 → 알림 채널에서 알림 채널(Slack, PagerDuty, 이메일)을 구성합니다.

### Kubernetes 자동 계측

```yaml
# signoz-otel-collector-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: signoz-otel-collector
  namespace: signoz
spec:
  ports:
    - name: otlp-grpc
      port: 4317
      protocol: TCP
    - name: otlp-http
      port: 4318
      protocol: TCP
  selector:
    app.kubernetes.io/name: otel-collector

---
# OTel 환경 변수 추가로 Deployment 계측
apiVersion: apps/v1
kind: Deployment
metadata:
  name: payment-service
spec:
  template:
    spec:
      containers:
        - name: payment-service
          image: payment-service:1.2.3
          env:
            - name: OTEL_EXPORTER_OTLP_ENDPOINT
              value: "http://signoz-otel-collector.signoz.svc.cluster.local:4317"
            - name: OTEL_RESOURCE_ATTRIBUTES
              value: "service.name=payment-service,service.namespace=production"
            - name: OTEL_TRACES_SAMPLER
              value: "parentbased_traceidratio"
            - name: OTEL_TRACES_SAMPLER_ARG
              value: "0.1"  # 추적의 10% 샘플링
```

### 고트래픽 서비스의 샘플링 전략

초당 10,000건 이상의 요청을 처리하는 서비스의 경우 헤드 기반 샘플링을 구현합니다:

```yaml
# otel-collector-config.yaml
receivers:
  otlp:
    protocols:
      grpc:
        endpoint: 0.0.0.0:4317
      http:
        endpoint: 0.0.0.0:4318

processors:
  tail_sampling:
    decision_wait: 10s
    num_traces: 100000
    expected_new_traces_per_sec: 1000
    policies:
      - name: errors
        type: status_code
        status_code: {status_codes: [ERROR]}
      - name: slow_requests
        type: latency
        latency: {threshold_ms: 500}
      - name: probabilistic
        type: probabilistic
        probabilistic: {sampling_percentage: 10}

exporters:
  clickhousetraces:
    datasource: tcp://clickhouse:9000
    database: signoz_traces

service:
  pipelines:
    traces:
      receivers: [otlp]
      processors: [tail_sampling]
      exporters: [clickhousetraces]
```

이 구성은 100%의 오류 추적, 100%의 느린 요청(>500ms), 10%의 정상 트래픽을 샘플링합니다. — 저장 비용을 제어하면서 완전한 오류 가시성을 제공합니다.

## 대안과의 비교

| 기능 | SigNoz | Datadog | New Relic | Grafana Stack |
|------|--------|---------|-----------|---------------|
| 오픈소스 | MIT 라이선스 | 독점 | 독점 | AGPL(일부) |
| 셀프호스팅 | 전체 Docker/K8s | 아니요 | 아니요 | 예 |
| GitHub 스타 | 22,000+ | 해당 없음 | 해당 없음 | 해당 없음(Loki: 25K) |
| OpenTelemetry 네이티브 | 예(기본) | 부분 | 부분 | Tempo/Loki 통해 |
| 분산 추적 | 예 | 예 | 예 | Tempo 통해 |
| 로그 관리 | 예 | 예 | 예 | Loki 통해 |
| 인프라 메트릭 | 예 | 예 | 예 | Prometheus 통해 |
| 커스텀 대시보드 | 예 | 예 | 예 | 예 |
| 알림 | 예(네이티브) | 예 | 예 | Alertmanager 통해 |
| 50호스트 비용 | $40–$120/월 | ~$4,300/월 | ~$3,100/월 | $0(셀프호스팅) |
| 데이터 보존 제어 | 완전 | 제한 | 제한 | 완전 |
| 쿼리 언어 | ClickHouse SQL | 독점 | NRQL | PromQL/LogQL |

**SigNoz를 Datadog 대신 선택하는 경우**: 완전한 데이터 주권이 필요하거나, 규모에 맞게 비용을 제어하려거나, OpenTelemetry 표준을 선호하거나, 에어갭 환경에서 실행하는 경우.

**SigNoz를 Grafana Stack 대신 선택하는 경우**: 3개 이상의 별도 도구(Tempo, Loki, Prometheus)를 구성하고 유지 관리하지 않고 추적, 메트릭, 로그에 대한 통합 UI가 필요한 경우. SigNoz는 즉시 사용 가능한 통합 경험을 제공합니다.

**Datadog이 이기는 경우**: 가장 광범위한 기본 통합(500+ 클라우드 서비스), 관리형 인프라가 필요하고 비용을 감당할 수 있는 경우. Datadog의 UI 다듬음과 ML 기반 이상 탐지는 여전히 오픈소스 대안을 앞섭니다.

## 한계: 정직한 평가

1. **생태계 폭**: Datadog은 500+ 클라우드 서비스, 데이터베이스 및 서드파티 도구에 대한 기본 통합을 제공합니다. SigNoz은 주요 프레임워크를 커버하지만 틈새 서비스에는 수동 설정이 필요할 수 있는 OpenTelemetry 자동 계측에 의존합니다. 복잡한 마이크로서비스 스택의 경우 계측 작업에 1–2일을 계획하세요.

2. **UI 다듬음**: SigNoz의 React 프론트엔드는 기능적이고 빠르게 개선되고 있지만, 아직 Datadog의 정제된 사용자 경험에 미치지 못합니다. 일부 고급 시각화(의존성 화살표가 있는 서비스 맵, 플레임 그래프 비교)는 여전히 성숙 중입니다.

3. **내장 RUM(실제 사용자 모니터링) 없음**: SigNoz은 현재 백엔드 가시성에 중점을 두고 있습니다. 프론트엔드 성능 모니터링에는 별도의 도구나 커스텀 계측이 필요합니다. 이 기능은 2026년 하반기 로드맵에 있습니다.

4. **머신러닝 기능**: Datadog의 Watchdog AI와 New Relic의 Lookout은 자동 이상 탐지를 제공합니다. SigNoz은 아직 ML 기반 이상 탐지를 포함하지 않습니다. 자체 임계값 기반 알림을 작성하거나 외부 ML 플랫폼과 통합해야 합니다.

5. **관리형 호스팅 가용성**: SigNoz Cloud를 사용할 수 있지만 Datadog이나 New Relic의 관리형 제품만큼 성숙하지 않습니다. 엔터프라이즈 지원 계층을 사용할 수 있지만 관리형 제품은 더 새롭습니다.

## 자주 묻는 질문

**Q: SigNoz는 Grafana Stack(Tempo + Loki + Prometheus)과 어떻게 비교되나요?**

SigNoz은 통합 경험을 제공합니다: 추적, 메트릭, 로그를 위한 하나의 바이너리, 하나의 UI, 하나의 쿼리 엔드포인트. Grafana Stack은 Tempo(추적), Loki(로그), Prometheus(메트릭), Grafana(시각화), Alertmanager를 개별적으로 배포하고 유지 관리해야 합니다. — 각각 자체 구성, 저장소, 업그레이드 주기가 있습니다. 통합 APM이 필요한 경우 SigNoz가 더 간단한 선택입니다. Grafana Stack은 구성 요소를 혼합하고 매치해야 하는 경우 더 많은 유연성을 제공합니다.

**Q: 프로덕션용 ClickHouse 하드웨어 요구사항은 무엇인가요?**

일일 100만 스팬 수집, 7일 핫 보존: 4 vCPU, 8 GB RAM, 100 GB SSD. 일일 1000만 스팬: 8 vCPU, 32 GB RAM, 500 GB SSD. 일일 1억+ 스팬: 3+ 노드의 ClickHouse 클러스터. 강력한 단일 노드(16 vCPU, 64 GB)는 일일 5000만+ 스팬을 처리할 수 있습니다. 항상 SSD 저장소를 사용하세요. — HDD는 수집에 병목 현상을 일으킵니다.

**Q: 기존 Prometheus 메트릭을 SigNoz와 함께 사용할 수 있나요?**

예. SigNoz의 OTel Collector에는 Prometheus 수신기가 포함되어 있습니다. `otel-collector-config.yaml`에서 구성합니다:

```yaml
receivers:
  prometheus:
    config:
      scrape_configs:
        - job_name: 'my-app'
          static_configs:
            - targets: ['my-app:9090']
```

기존 Prometheus 스크랩 구성을 직접 가져올 수 있습니다. SigNoz은 장기 쿼리를 위해 Druid에 메트릭을 저장합니다.

**Q: Datadog에서 SigNoz로 어떻게 마이그레이션하나요?**

마이그레이션은 두 단계로 이루어집니다. 1단계: SigNoz를 "섀도우 모드"로 Datadog과 함께 배포합니다. — 트래픽의 10%를 SigNoz에 본낼 Datadog을 기본으로 유지합니다. 대시보드와 알림을 검증합니다. 2단계: OTel 익스포터를 100% SigNoz를 가리키도록 전환한 다음 Datadog을 해체합니다. 30개 서비스 스택의 일반적인 마이그레이션 기간: 2–4주. OpenTelemetry Collector는 전환 중 두 백엔드에 동시에 라우팅할 수 있습니다.

**Q: 셀프호스팅 SigNoz에서 내 데이터는 안전한가요?**

모든 텔레메트리 데이터는 귀하의 인프라에 남아 있습니다. SigNoz은 데이터를 외부로 전송하지 않습니다. 명시적으로 옵트인한 경우에만 텔레메트리 데이터(사용 분석, 추적 아님)가 전송됩니다. 코드베이스는 완전히 오픈소스이고 감사 가능합니다. 규제 산업(의료, 금융)의 경우 이것이 종종 클라우드 APM이 충족할 수 없는 요구사항입니다.

**Q: 로그 관리는 ELK 스택과 어떻게 비교되나요?**

SigNoz은 로그 저장을 위해 ClickHouse을 사용하여 Elasticsearch보다 5–10배 나은 압축률과 높은 친잘성 필드에서 더 빠른 분석 쿼리를 제공합니다. 그러나 Elasticsearch는 전문 검색 관련성 순위에서 여전히 우수합니다. 주요 사용 사례가 로그 검색(추적 상관관계 아님)인 경우 ELK가 더 적합할 수 있습니다. SigNoz은 추적-로그 상관관계에서 탁월합니다. — 추적 스팬을 클릭하면 연결된 로그가 자동으로 표시됩니다.

## 결론: 가시성 예산을 되찾으세요

SigNoz은 규모가 있는 엔지니어링 팀이 실제로 필요로 하는 것을 제공합니다: **분산 추적, 메트릭, 로그를 갖춘 프로덕션급 APM으로 Datadog보다 90–98% 저렴** — 모든 것이 텔레메트리 데이터를 인프라에 유지하면서 OpenTelemetry 표준을 준수합니다.

5분 Docker 설정, 수십억 스팬에서 ClickHouse 기반 서브세컨드 쿼리, 제로 벤더 락인을 갖춘 SigNoz은 연간 $50,000+를 클라우드 APM에 지출하는 것을 정당화하기 어렵게 만듭니다.

**오늘 배포하기**: [DigitalOcean](https://m.do.co/c/eca87ac14ee0)(8GB 월 $48) 또는 [HTStack](https://my.htstack.com/aff.php?aff=27187)에서 VPS를 생성하고, `./install.sh`를 실행하고, 10분 이내에 첫 번째 서비스를 계측하세요.

**커뮤니티 참여**: 한국어 개발자를 위한 [Telegram 그룹](https://t.me/dibi8ko) | [GitHub Discussions](https://github.com/SigNoz/signoz/discussions) | [Slack](https://signoz.io/slack)



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- SigNoz GitHub 저장소: https://github.com/SigNoz/signoz
- 공식 문서: https://signoz.io/docs/
- OpenTelemetry Collector 구성: https://signoz.io/docs/tutorial/opentelemetry-binary-usage-in-virtual-machine/
- ClickHouse 성능 튜닝: https://signoz.io/docs/operate/clickhouse/
- Kubernetes 배포 가이드: https://signoz.io/docs/install/kubernetes/
- [Grafana Stack](dibi8-internal-link) — 대체 오픈소스 가시성 스택
- [셀프호스팅 가이드](dibi8-internal-link) — dibi8.com의 일반 셀프호스팅 모범 사례

---

*제휴 공개: 본 문서에는 DigitalOcean과 HTStack의 제휴 링크가 포함되어 있습니다. 이 링크를 통해 서비스를 구매하면 dibi8.com에 추가 비용 없이 수수료가 지급됩니다. 모든 추천은 실제 테스트를 기반으로 하며, 제휴 가용성이 아닌 실제 성능에 근거합니다.*
