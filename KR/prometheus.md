---
title: 'Prometheus: 64,094 GitHub Stars — Docker 배포 가이드 2026'
description: 'Prometheus(Prom)는 오픈소스 모니터링 시스템 및 시계열 데이터베이스입니다. Docker, Kubernetes, Grafana, Alertmanager와 호환됩니다. 설치 튜토리얼, PromQL 쿼리, 프로덕션 하드닝, 성능 벤치마크를 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/prometheus/prometheus'
stars: 64094
maintainer: 'prometheus'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['prometheus', '모니터링', 'docker', 'kubernetes', 'grafana', 'devops', '관측가능성', '시계열']
aliases:
- /kr/posts/prometheus/
---

{{</* resource-info */>}}

## 소개

애플리케이션이 또 중단되었다. 페이지 로딩이 느리고 고객이 불만을 제기하는데, 팀은 데이터베이스가 멈춘 것인지 API 레이어에 문제가 있는지 전혀 파악할 수 없다. 이것이 모니터링 공백이 프로덕션 신뢰성을 해치는 방식이다. Prometheus —— Cloud Native Computing Foundation(CNCF)에서 Kubernetes에 이어 두 번째로 졸업한 프로젝트로 **64,094개의 GitHub Stars**를 보유하고 있으며, DigitalOcean, Uber, SoundCloud 등에서 실전 검증된 모니터링 시스템이다. 이 가이드에서는 Docker와 Kubernetes를 활용한 프로덕션급 Prometheus 설정, 실제 PromQL 쿼리, 팀에 도구 선택을 정당화할 수 있는 구체적인 수치를 제공한다.

## Prometheus란?

Prometheus는 클라우드 네이티브 환경을 위해 설계된 오픈소스 모니터링 시스템 및 시계열 데이터베이스이다. 2012년 SoundCloud에서 Google의 Borgmon에서 영감을 받아 개발되었으며, 현재는 컨테이너화 및 마이크로서비스 아키텍처에서 지표 수집의 사실상 표준(de facto standard)이 되었다. 2016년 CNCF에서 졸업했으며, 최신 안정 버전은 **v3.11.0**(2026년 4월)이고 v3.12.0-rc.0은 프리릴리스 상태이다.

![Prometheus Logo](https://prometheus.io/twitter-image.png?b370f6418ef38b42)

## Prometheus 작동 방식

Prometheus는 **풀(pull) 기반 아키텍처**를 사용한다. 에이전트가 중앙 수집기에 지표를 푸시하는 대신, Prometheus는 구성된 간격으로 HTTP 엔드포인트를 스크랩한다. 이 설계는 서비스 디스커버리를 단순화하고, 모든 호스트에 에이전트를 설치할 필요가 없으며, 내장된 상태 감지 기능을 제공한다 —— 타겟이 응답하지 않으면 `up` 지표가 즉시 `0`을 반환한다.

핵심 구성 요소:

| 구성 요소 | 역할 |
|---|---|
| **Prometheus Server** | 지표 스크랩, TSDB 저장, 규칙 평가 |
| **TSDB** | Head(메모리)와 Block(디스크) 레이어를 갖춘 커스텀 시계열 데이터베이스 |
| **Service Discovery** | Kubernetes API, AWS EC2, Consul, DNS를 통해 타겟 자동 발견 |
| **Alertmanager** | 알림 중복 제거, 그룹화, Slack/PagerDuty/이메일 라우팅 |
| **Exporters** | 서드파티 시스템의 지표를 노출하는 사이드카 유틸리티 |

![Prometheus 아키텍처](https://storage.ghost.io/c/5f/2f/5f2f4d20-2abf-4534-8d40-7aa233aedd43/content/images/2025/03/image-118-9.png)

데이터 흐름: Service Discovery가 타겟을 식별하면, Scraper가 HTTP로 지표를 가져오고, TSDB가 압축하여 저장하며, Rule Engine이 알림 및 기록 규칙을 평가한다. Alertmanager가 알림 라우팅을 처리하고, HTTP API가 Grafana 또는 내장 표현식 브라우저에 쿼리를 제공한다.

**핵심 설계 결정:**
- **풀 오버 푸시**: 타겟은 `/metrics`만 노출하면 되며 에이전트 구성이 불필요
- **로컬 저장소**: 기본적으로 각 Prometheus 서버가 자율적으로 운영
- **다차원 데이터 모델**: 모든 지표에 키-값 레이블이 부여되어 유연한 쿼리 가능
- **PromQL**: 집계, 속도 계산, 알림을 위한 강력한 쿼리 언어

## 설치 및 설정

### Docker 설정 (단일 노드, 5분 이내)

가장 빠르게 Prometheus를 실행하는 방법은 Docker이다. 프로젝트 디렉토리를 생성하고 두 개의 파일을 만든다:

**prometheus.yml:**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

**docker-compose.yml:**
```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:v3.11.0
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - prometheus-data:/prometheus
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'
    restart: unless-stopped

volumes:
  prometheus-data:
```

시작:
```bash
docker compose up -d
```

UI 접속: `http://localhost:9090`. `--web.enable-lifecycle` 플래그는 `POST /-/reload`를 통해 컨테이너 재시작 없이 구성을 다시 로드할 수 있게 한다.

### Docker 풀 스택: Prometheus + Grafana + Node Exporter + cAdvisor

완전한 모니터링 스택을 위해 Grafana 시각화 및 호스트/컨테이너 지표를 위한 익스포터를 추가한다:

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:v3.11.0
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:11.0.0
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:v1.9.0
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.49.1
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    ports:
      - "8080:8080"
    restart: unless-stopped

volumes:
  prometheus-data:
  grafana-data:
```

**풀 스택용 prometheus.yml:**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

### Kubernetes Helm 배포

프로덕션 Kubernetes 환경에서는 `kube-prometheus-stack` Helm 차트를 사용한다:

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.retention=30d \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=50Gi \
  --set grafana.enabled=true \
  --set grafana.adminPassword='your-secure-password'
```

배포 확인:
```bash
kubectl get pods -n monitoring
```

로컬 접속용 포트 포워딩:
```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093:9093 -n monitoring
```

### Kubernetes 프로덕션 설정

```yaml
prometheus:
  prometheusSpec:
    resources:
      requests:
        memory: 2Gi
        cpu: 500m
      limits:
        memory: 4Gi
        cpu: 2000m
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: gp3
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 100Gi
    retention: "30d"
    retentionSize: "90GB"
    scrapeInterval: "30s"
    enableAdminAPI: false

alertmanager:
  alertmanagerSpec:
    resources:
      requests:
        memory: 256Mi
        cpu: 100m
      limits:
        memory: 512Mi
        cpu: 500m

grafana:
  enabled: true
  persistence:
    enabled: true
    size: 10Gi
```

적용:
```bash
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring -f values-production.yaml
```

## Docker, Kubernetes, Grafana, Alertmanager 통합

### Prometheus + Grafana 대시보드

Grafana에 Prometheus를 데이터 소스로 추가:

1. Grafana → Configuration → Data Sources → Add Data Source
2. **Prometheus** 선택
3. URL: `http://prometheus:9090` (Docker) 또는 `http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090` (K8s)
4. **Save & Test** 클릭

대시보드 ID **1860** (Node Exporter Full)을 임포트하여 완전한 호스트 지표 대시보드를 얻거나, ID **14282**로 cAdvisor 컨테이너 지표를 확인한다.

![Grafana 대시보드 예시](https://prometheus.io/assets/docs/grafana_qps_graph.png)

### Prometheus + Alertmanager 알림 규칙

`alert-rules.yml` 생성:
```yaml
groups:
  - name: node-alerts
    rules:
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 메모리 사용률 과다"
          description: "메모리 사용률이 85%를 초과함 (현재값: {{ $value }}%)"

      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "{{ $labels.instance }} CPU 사용률 과다"
          description: "CPU 사용률이 80%를 초과함 (현재값: {{ $value }}%)"

      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 디스크 공간 부족"
          description: "디스크 공간이 10% 미만 (마운트 포인트: {{ $labels.mountpoint }})"

      - alert: InstanceDown
        expr: up == 0
        for: 3m
        labels:
          severity: critical
        annotations:
          summary: "인스턴스 {{ $labels.instance }} 다운"
          description: "대상에 3분 이상 접근 불가"

      - alert: HighRequestLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 요청 지연 과다"
          description: "95번째 백분위 지연이 {{ $value }}초"
```

### Alertmanager Slack 설정

`alertmanager.yml` 생성:
```yaml
global:
  slack_api_url: 'YOUR_SLACK_WEBHOOK_URL'

route:
  receiver: 'slack-notifications'
  group_by: ['alertname', 'severity']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h

receivers:
  - name: 'slack-notifications'
    slack_configs:
      - channel: '#alerts'
        send_resolved: true
        title: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

### Kubernetes 서비스 디스커버리

```yaml
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names:
            - default
            - production
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        target_label: __address__
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
```

### PromQL 쿼리 예시

**초당 요청율:**
```promql
rate(http_requests_total[5m])
```

**95번째 백분위 지연 시간:**
```promql
histogram_quantile(0.95, 
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
)
```

**CPU 사용률 백분율:**
```promql
100 - (avg by(instance) (
  irate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100)
```

**메모리 사용량 (MB):**
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / 1024 / 1024
```

**엔드포인트별 오류율:**
```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) by (handler) 
/ 
sum(rate(http_requests_total[5m])) by (handler)
```

**디스크 사용 예측 (7일 내 가득 참?):**
```promql
predict_linear(
  node_filesystem_avail_bytes[1h], 
  7 * 24 * 3600
) < 0
```

## 벤치마크 / 실제 사용 사례

### 수집 성능

| 배포 방식 | 초당 샘플 | CPU 코어 | 메모리 |
|---|---|---|---|
| Prometheus 단일 노드 | ~100,000–300,000 | 4 | 2–4 GB |
| Prometheus + Cortex | 1M+ | 클러스터 | 수평 확장 |
| VictoriaMetrics (단일) | 최대 1,000,000 | 8 | ~2 GB |
| InfluxDB 3.0 OSS | ~122,000 | 4 | 4–8 GB |
| InfluxDB 1.8 OSS | ~200,000–400,000 | 4 | 4–8 GB |

출처: 독립 TSBS 벤치마크, 2025–2026. Prometheus는 원시 수집 처리량 대신 쿼리 유연성과 운영 단순성을 선택한다.

### 규모별 리소스 요구사항

| 클러스터 규모 | Prometheus CPU | Prometheus 메모리 | 저장소 (30일) |
|---|---|---|---|
| 소형 (< 50 pod) | 500m | 1–2 Gi | 20–50 Gi |
| 중형 (50–200 pod) | 1000m | 2–4 Gi | 50–100 Gi |
| 대형 (200–500 pod) | 2000m | 4–8 Gi | 100–200 Gi |
| 초대형 (500+ pod) | 4000m | 8–16 Gi | 200–500 Gi |

### 실제 사용 사례

- **DigitalOcean**: Prometheus 페더레이션으로 수천 개의 VM과 Kubernetes 클러스터 모니터링
- **Uber**: M3DB(Prometheus 호환)로 수십억 개의 시계열 확장
- **SoundCloud**: 창시자로서 최소 운영 오버헤드로 대규모 마이크로서비스 모니터링

## 고급 사용법 / 프로덕션 하드닝

### 보안 모범 사례

1. **기본 인증 활성화** (Prometheus v2.24+):
```yaml
basic_auth_users:
  admin: $2y$10$... # bcrypt 해시
```

```bash
htpasswd -nBC 10 "" | tr -d ':\n'
```

2. **스크랩 타겟에 TLS 사용**:
```yaml
scrape_configs:
  - job_name: 'secure-target'
    scheme: https
    tls_config:
      ca_file: /etc/prometheus/certs/ca.crt
      cert_file: /etc/prometheus/certs/client.crt
      key_file: /etc/prometheus/certs/client.key
      insecure_skip_verify: false
```

3. **네트워크 정책** (Kubernetes)으로 Prometheus 9090 포트 접근을 제한한다.

4. **non-root 실행**: 공식 이미지는 UID 65534(nobody)를 지원한다. v3.10.0부터 distroless 변형은 UID/GID 65532를 사용한다.

### 확장 전략

- **페더레이션**: 글로벌 Prometheus가 리전별 Prometheus에서 집계 지표를 수집
- **리모트 라이트**: Thanos, Cortex, VictoriaMetrics, Mimir로 장기 저장소에 지표 스트리밍
- **샤딩**: job 또는 네임스페이스별로 여러 Prometheus 인스턴스에 타겟 분할
- **고가용성**: 동일한 타겟을 스크랩하는 두 개의 동일한 Prometheus 인스턴스 실행; Thanos Querier로 중복 제거

### Prometheus 자체 모니터링

```promql
prometheus_tsdb_head_series
prometheus_tsdb_head_chunks
prometheus_rule_evaluation_duration_seconds
prometheus_notifications_dropped_total
```

### Thanos 장기 저장소

Thanos는 객체 저장소(S3, GCS, Azure Blob)를 통해 Prometheus를 확장하여 장기 보관 및 글로벌 쿼리를 가능하게 한다:

```yaml
- name: thanos-sidecar
  image: quay.io/thanos/thanos:v0.37.0
  args:
    - sidecar
    - --tsdb.path=/prometheus
    - --objstore.config-file=/etc/thanos/objstore.yml
  volumeMounts:
    - name: prometheus-data
      mountPath: /prometheus
```

## 대안과의 비교

| 기능 | Prometheus | InfluxDB | Datadog | New Relic |
|---|---|---|---|---|
| **라이선스** | Apache-2.0 | MIT | 독점 | 독점 |
| **비용** | 무상 (셀프 호스팅) | 무상 OSS / 엔터프라이즈 $ | $15–$23/호스트/월 | $0.25/GB + 사용자 비용 |
| **배포 방식** | 셀프 호스팅, Docker, K8s | 셀프 호스팅 / 클라우드 | SaaS 전용 | SaaS 전용 |
| **데이터 수집** | 풀(HTTP 스크랩) | 푸시(에이전트/쓰기 API) | 에이전트 기반 푸시 | 에이전트 기반 푸시 |
| **쿼리 언어** | PromQL | InfluxQL / Flux / SQL | 커스텀 / SQL | NRQL |
| **네이티브 K8s SD** | 예 (내장) | Telegraf 통해 | 예 (에이전트) | 예 (에이전트) |
| **장기 저장소** | Thanos / Cortex / Mimir | 내장 (엔터프라이즈) | 내장 (15개월) | 내장 (13개월) |
| **알림 기능** | Alertmanager (네이티브) | Kapacitor / 엔터프라이즈 | 내장 | 내장 |
| **AI/ML 인사이트** | 커뮤니티 플러그인만 | 제한적 | 이상 감지 | 전체 AI 분석 |
| **단일 노드 수집** | 100K–300K 샘플/초 | 122K–400K 지표/초 | N/A (SaaS) | N/A (SaaS) |
| **적합한 경우** | K8s, 인프라 모니터링, DevOps | IoT, 고친inality 지표 | 엔터프라이즈 멀티 클라우드 | APM, AI 기반 운영 |

**Prometheus를 선택하는 경우**: Kubernetes를 운영하고, 데이터를 완전히 제어하려 하며, 호스트당 라이선스 비용을 피하고, 셀프 호스팅 운영 역량이 있는 경우.

**경쟁사를 선택하는 경우**: 턴키 APM과 분산 추적이 필요하거나(Datadog/New Relic), InfluxDB의 칼럼형 엔진이 더 적합한 고친inality IoT 워크로드를 처리하는 경우.

## 한계 / 정직한 평가

Prometheus는 만능 모니터링 솔루션이 아니다. 다음 제약 사항에 유의하라:

1. **네이티브 로그 집계 없음**: Prometheus는 지표를 처리하지만 로그는 처리하지 않는다. 로그 관리에는 Loki, ELK 또는 Fluentd가 필요하다.

2. **단일 노드 제한**: 단일 Prometheus 서버는 하드웨어에 따라 약 100,000–300,000 샘플/초를 처리할 수 있다. 그 이상은 페더레이션 또는 리모트 라이트 솔루션이 필요하다.

3. **네이티브 장기 저장소 없음**: 기본 로컬 저장소는 디스크 크기로 제한된다. 월 단위 이상의 보관을 위해서는 외부 객체 저장소 통합이 필수이다.

4. **풀 모델 제약**: 수명이 짧은 배치 작업이나 서버리스 함수를 모니터링하려면 Pushgateway 또는 OTLP 수집이 필요하며 복잡성이 추가된다.

5. **고친inality 비용**: 고유한 레이블 조합이 너무 많은 지표는 메모리 사용량을 폭발시키고 쿼리 성능을 저하시킬 수 있다.

6. **학습 곡선**: PromQL은 투자가 필요하다. SQL에 익숙한 엔지니어는 벡터 기반 쿼리에 적응하는 데 시간이 필요하다.

## 자주 묻는 질문

**Q: Prometheus와 Grafana의 차이점은?**
A: Prometheus가 지표를 수집하고 저장하면, Grafana가 이를 시각화한다. 이들은 경쟁자가 아닌 상호 보완적인 도구이다.

**Q: Python 애플리케이션을 Prometheus로 모니터링하려면?**
A: 공식 `prometheus-client` Python 라이브러리를 사용하여 `/metrics` 엔드포인트를 노출한 후, Prometheus가 이를 스크랩하도록 구성한다.

**Q: Prometheus로 고가용성을 구현할 수 있나?**
A: 가능하지만 외부 솔루션이 필요하다. 동일한 타겟을 스크랩하는 두 개의 동일한 Prometheus 인스턴스를 실행하고, Thanos Querier 또는 Cortex로 중복 제거 및 글로벌 쿼리를 수행한다.

**Q: Prometheus 데이터의 최대 보관 기간은?**
A: `--storage.tsdb.retention.time`으로 구성 가능(기본 15일). 수년간의 보관을 위해서는 Thanos, Mimir 또는 객체 저장소로의 리모트 라이트가 필요하다.

**Q: Prometheus와 CloudWatch 같은 클라우드 모니터링을 비교하면?**
A: Prometheus는 더 유연한 쿼리(PromQL vs CloudWatch Insights), 차원 레이블, 지표당 과금이 없는 장점이 있다. CloudWatch는 AWS 서비스와 네이티브 통합되며 운영 오버헤드가 없다.

**Q: Recording rules란 무엇이며 언제 사용하나?**
A: Recording rules는 비용이 많이 드는 PromQL 표현식을 사전 계산하고 결과를 새로운 시계열로 저장한다. 로딩이 느린 대시보드나 자주 실행되는 쿼리에 사용한다.

**Q: Prometheus가 IoT 장치 모니터링에 적합한가?**
A: 장치가 HTTP 엔드포인트를 노출하고 Prometheus 서버가 접근 가능한 경우에만. 간헐적 연결의 에지/IoT 시나리오에서는 InfluxDB 같은 푸시 기반 시스템이 더 적합하다.

## 결론

Prometheus는 2026년에도 클라우드 네이티브 모니터링의 표준으로 남아있다. 64,094개의 GitHub Stars, 활발한 CNCF 지원, 그리고 지속적인 성능 개선(PromQL 힙 할당 감소, 네이티브 히스토그램 안정화, Remote Write 2.0)을 통해 인프라 관찰 가능성을 위한 안전한 장기 투자 대상이다.

**액션 아이템:**
1. `kube-prometheus-stack` Helm 차트를 클론하여 스테이징 클러스터에 배포
2. Grafana 대시보드 1860을 임포트하여 즉각적인 Node Exporter 가시성 확보
3. 중요 서비스에 대한 세 가지 알림 규칙 작성
4. [dibi8 Telegram 그룹](https://t.me/dibi8)에 가입하여 일일 오픈소스 도구 업데이트와 배포 팁을 받아보세요

**호스팅 추천**: [DigitalOcean Kubernetes](https://www.digitalocean.com/products/kubernetes)(관리형 컨트롤 플레인 $12/월부터)에 Prometheus를 배포하여 비용 효율적인 프로덕션급 모니터링 스택을 구축하세요. 전용 클라우드 리소스는 컨테이너 워크로드에 최적화된 [HTStack](https://htstack.com/) 호스팅 솔루션을 확인하세요.

*공개: 본 문서에는 제휴 링크가 포함되어 있습니다. 해당 링크를 통해 서비스를 구매할 경우 dibi8에 커미션이 지급될 수 있으며, 이는 추가 비용 없이 제공됩니다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [Prometheus 공식 문서](https://prometheus.io/docs/introduction/overview/)
- [Prometheus GitHub 저장소](https://github.com/prometheus/prometheus)
- [Prometheus 3.0 릴리스 공지](https://prometheus.io/blog/2024/11/14/prometheus-3-0/)
- [kube-prometheus-stack Helm 차트](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Thanos 장기 저장소](https://thanos.io/)
- [Grafana Prometheus 대시보드](https://grafana.com/grafana/dashboards/?dataSource=prometheus)
- [PromQL 치트 시트](https://promlabs.com/promql-cheat-sheet/)
- [Prometheus vs InfluxDB 비교](https://uptrace.dev/comparisons/prometheus-vs-influxdb)
- [CNCF Prometheus 프로젝트 페이지](https://www.cncf.io/projects/prometheus/)
