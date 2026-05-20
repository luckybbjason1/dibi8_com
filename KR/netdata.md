---
title: 'Netdata: 78K+ Star 실시간 모니터링 — 2026 성능 튜닝 가이드'
description: 'Netdata (ND)는 초당 메트릭과 시각화를 제공하는 고성능 실시간 모니터링 에이전트입니다. Docker, Kubernetes, Prometheus, Grafana와 호환됩니다. netdata 튜토리얼, netdata 설치, 실시간 모니터링, netdata vs prometheus, netdata 성능 튜닝을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: GPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/netdata/netdata'
stars: 78874
maintainer: 'netdata'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['netdata', '모니터링', '관측 가능성', '성능 튜닝', 'docker', 'kubernetes', '실시간-메트릭']
aliases:
- /kr/posts/netdata/
---

{{</* resource-info */>}}

## 소개

대부분의 모니터링 도구는 30초 전에 발생한 일을 보여줍니다. 그 사이에 데이터베이스 연결 풀을 죽인 마이크로버스트는 이미 사라지고 — 의미 불명의 로그 항목과 화난 호출기만 남깁니다. Netdata는 초당 메트릭, 2초 미만의 시각화 지연, 60초 이내에 완료되는 단일 바이너리 설치로 이 간극을 해소합니다. GitHub에서 78,874개의 Star와 GPL-3.0 라이선스를 보유한 Netdata는 오늘날 프로덕션에서 가장 인기 있는 오픈소스 모니터링 에이전트 중 하나입니다. 이 가이드는 단일 노드 Docker 배포부터 스트리밍 Kubernetes 클러스터까지 완전한 Netdata 설정을 다루며, 즉시 적용할 수 있는 실제 성능 튜닝 설정을 포함합니다.

## Netdata란?

Netdata는 초당 세분성으로 시스템 및 애플리케이션 메트릭을 수집, 저장, 시각화하는 분산 실시간 모니터링 에이전트입니다. 기존의 15–60초마다 샘플링하는 폴 기반 시스템과 달리 Netdata는 각 노드에서 직접 실행되어 수천 개의 메트릭을 로컬로 캡처하고 필요할 때 중앙 Parent 노드로 스트리밍합니다. C (54.2%), Go (29%), Rust (8.5%)로 작성되었으며 기본 설정에서 노드당 CPU 점유율 5% 미만, 메모리 약 150MB의 최소 리소스 오버헤드를 자랑합니다.

## Netdata 작동 방식

Netdata의 아키텍처는 에지 우선 분산 모델을 따릅니다. 각 노드는 독립적인 에이전트를 실행하며 별도의 설정 파일 없이 800개 이상의 통합을 자동으로 발견합니다.

![Netdata 아키텍처](https://raw.githubusercontent.com/netdata/netdata/master/web/gui/images/netdata.svg)

![Netdata 대시보드 개요](https://user-images.githubusercontent.com/24860547/201481889-0cf8e192-683f-4a80-9b96-4f69dd85490f.png)

**핵심 구성 요소:**

- **데이터 수집 레이어**: CPU, 메모리, 디스크, 네트워크, 컨테이너, 데이터베이스 및 애플리케이션을 위한 내장 수집기. Telegraf나 Exporter 같은 외부 의존성이 필요 없습니다.
- **데이터베이스 엔진 (dbengine)**: 샘플당 약 0.5바이트의 사용자 정의 고성능 시계열 저장소이며 장기 보존을 위한 계층화된 저장을 지원합니다.
- **ML 이상 탐지**: 각 메트릭에서 엣지에서 18개의 비지도 ML 모델을 실행하여 합의 기반 이상 탐지로 오탐률을 99% 감소시킵니다.
- **스트리밍 및 부모-자식**: 모든 에이전트가 다른 자식 노드의 "Parent" 역할을 할 수 있어 중앙 병목 없이 수평 확장이 가능합니다.
- **Web 대시보드**: 임베디드 정적 스레드 웹 서버가 에이전트의 19999 포트에서 직접 실시간 차트를 제공합니다.

## 설치 및 설정

### 원라인 설치 (Linux)

가장 빠른 설치 방법:

```bash
# 모든 기본값으로 Netdata 설치
curl -Ss https://get.netdata.cloud/kickstart.sh | sudo bash
```

설치 확인:

```bash
sudo systemctl status netdata
# Active: active (running) since ...
```

`http://localhost:19999`에서 로컬 대시보드에 접속하세요.

### Docker 배포

컨테이너 환경을 위한 배포:

```bash
docker run -d --name=netdata \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata:latest
```

### Docker Compose (프로덕션용)

```yaml
version: '3.8'
services:
  netdata:
    image: netdata/netdata:v2.5.0
    container_name: netdata
    hostname: "netdata-${HOSTNAME}"
    ports:
      - "19999:19999"
    restart: unless-stopped
    cap_add:
      - SYS_PTRACE
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - netdata-config:/etc/netdata
      - netdata-lib:/var/lib/netdata
      - netdata-cache:/var/cache/netdata
    environment:
      - NETDATA_CLAIM_TOKEN=${NETDATA_CLAIM_TOKEN}
      - NETDATA_CLAIM_URL=https://app.netdata.cloud
      - NETDATA_CLAIM_ROOMS=${NETDATA_CLAIM_ROOMS}
volumes:
  netdata-config:
  netdata-lib:
  netdata-cache:
```

![Netdata 시스템 모니터링](https://hackmag.com/wp-content/uploads/2025/07/10244_02-16-39.png)

### Kubernetes Helm 설치

```bash
# Netdata Helm 저장소 추가
helm repo add netdata https://netdata.github.io/helmchart/
helm repo update

# 기본값으로 설치
helm install netdata netdata/netdata \
  --namespace monitoring \
  --create-namespace
```

Pod 확인:

```bash
kubectl get pods -n monitoring
# NAME                    READY   STATUS
# netdata-parent-0        1/1     Running
# netdata-child-xxx       1/1     Running
```

### 현재 설정 생성

실행 중인 설정을 다운로드하여 사용자 정의:

```bash
# 현재 적용 중인 설정 다운로드
curl -o /etc/netdata/netdata.conf http://localhost:19999/netdata.conf
# 또는 edit-config 스크립트 사용
sudo /etc/netdata/edit-config netdata.conf
```

## 인기 도구와의 통합

### Prometheus Remote Write

장기 저장 및 PromQL 쿼리를 위해 Netdata 메트릭을 Prometheus로 낸볷:

```bash
sudo /etc/netdata/edit-config exporting.conf
```

```conf
[prometheus:remote_write]
    enabled = yes
    destination = prometheus:9090
    remote write URL path = /api/v1/write
    data source = average
    prefix = netdata
    send charts matching = *
    send hosts matching = *
```

Netdata 재시작:

```bash
sudo systemctl restart netdata
```

### Grafana 대시보드

Netdata에 내장된 대시보드가 있지만, 많은 팀이 중앙 집중식 시각화를 위해 Grafana를 선호합니다. Grafana에서 Prometheus 데이터 소스로 Netdata를 추가:

```yaml
# Grafana의 datasource.yaml
apiVersion: 1
datasources:
  - name: Netdata-Prometheus
    type: prometheus
    url: http://netdata:19999/api/v1/allmetrics?format=prometheus
    access: proxy
    isDefault: false
    jsonData:
      timeInterval: "1s"
```

### Kubernetes DaemonSet (고급)

모든 K8s 노드에서 전체 호스트 수준 가시성 확보:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: netdata
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: netdata
  template:
    metadata:
      labels:
        app: netdata
    spec:
      hostNetwork: true
      hostPID: true
      containers:
        - name: netdata
          image: netdata/netdata:v2.5.0
          ports:
            - containerPort: 19999
              hostPort: 19999
          securityContext:
            capabilities:
              add: [SYS_PTRACE, SYS_ADMIN]
          volumeMounts:
            - name: proc
              mountPath: /host/proc
              readOnly: true
            - name: sys
              mountPath: /host/sys
              readOnly: true
            - name: docker-sock
              mountPath: /var/run/docker.sock
              readOnly: true
      volumes:
        - name: proc
          hostPath:
            path: /proc
        - name: sys
          hostPath:
            path: /sys
        - name: docker-sock
          hostPath:
            path: /var/run/docker.sock
```

### PostgreSQL 모니터링

`go.d/postgres.conf`에서 PostgreSQL 수집기 활성화:

```yaml
jobs:
  - name: local
    dsn: 'postgres://netdata_monitor:password@localhost:5432/postgres'
    collect:
      - database_statistics
      - table_statistics
      - index_statistics
      - replication_statistics
    timeout: 2
```

수집기 테스트:

```bash
sudo /etc/netdata/edit-config go.d/postgres.conf
# 적용을 위해 재시작
sudo systemctl restart netdata
```

### Nginx 모니터링

Nginx stub_status 및 액세스 로그 모니터링:

```yaml
# /etc/netdata/go.d/nginx.conf
jobs:
  - name: local
    url: http://localhost/stub_status

  - name: access_log
    path: /var/log/nginx/access.log
    parser:
      type: ltsv
```

## 벤치마크 / 실제 사용 사례

### 리소스 사용량 비교

암스테르담 대학교가 Docker 기반 시스템에서 Netdata를 가장 에너지 효율적인 모니터링 도구로 평가한 동행 심사 연구(ICSOC 2023)를 발표했습니다. 독립 벤치마크 결과:

| 시나리오 | Netdata | Prometheus + Node Exporter | Zabbix Agent |
|----------|---------|---------------------------|--------------|
| CPU 오버헤드 (%) | 1–5% | 5–15% | 10–20% |
| 노드당 메모리 | 100–150 MB | 200–500 MB | 150–300 MB |
| 수집 간격 | 1초 | 15–60초 | 30–60초 |
| 시작 시간 | < 60초 | 30–60분 | 2–4시간 |
| 노드당 메트릭 수 | 2,000+ | 500–1,000 | 1,000–2,000 |
| 설정 필요 여부 | 없음 | 중간 | 많음 |

### 스트리밍 확장 벤치마크

Netdata의 부모-자식 스트리밍 아키텍처는 수평으로 확장됩니다:

- **단일 Parent**: 초당 100만+ 샘플 수집, 메모리 약 3.5 GB
- **10개 자식 노드**: 노드당 20k 메트릭, 1초 보존 7일, 디스크 12 GB
- **Active-Active 클러스터**: 완전한 데이터 복제로 무제한 수평 확장
- **임시 노드**: Parent로 메트릭 스트리밍, 노드 종료 후에도 데이터 유지

### 실제 배포 사례: 500노드 K8s 클러스터

중형 SaaS 회사가 500개의 Kubernetes 노드를 다음과 같이 운영:

- 3개 가용 영역에 5개의 Netdata Parent (active-active) 배포
- DaemonSet을 통해 500개의 자식 에이전트 실행, 노드당 RAM 모드 (~50 MB)
- 계층화된 저장: 1초 해상도 7일, 1분 해상도 1개월, 1시간 해상도 1년
- Parent당 총 저장: 25 GB (클릭스터 전체 125 GB)
- Netdata Cloud를 통해 PagerDuty 및 Slack으로 알림 라우팅

## 고급 사용법 / 프로덕션 강화

### 성능 튜닝: netdata.conf

기본 설정은 독립 실행형 사용에 최적화되어 있습니다. 프로덕션 시스템에서는 데이터베이스 엔진을 튜닝하고 불필요한 수집기를 비활성화합니다.

**최소 공간 점유 (프로덕션 자식 노드):**

```conf
[global]
    # 애플리케이션에 영향을 주지 않도록 최저 우선순위로 실행
    process scheduling policy = batch
    process nice level = 19
    # 제한된 노드에서 스레드 수 감소
    libuv worker threads = 4

[db]
    # 자식 노드가 Parent로 스트리밍할 때 RAM 전용 모드 사용
    mode = ram
    retention = 3600
    # 로컬 버퍼링에는 단일 계층으로 충분
    storage tiers = 1

[ml]
    # 자식 노드에서 ML 비활성화 — Parent에서 실행
    enabled = no

[health]
    # 자식 노드에서 로컬 알림 비활성화
    enabled = no

[web]
    # 보안을 위해 localhost에만 바인딩
    bind to = 127.0.0.1
    allow connections from = localhost

[plugins]
    # CPU/메모리를 줄이기 위해 사용하지 않는 수집기 비활성화
    ebpf = no
    perf = no
    nfacct = no
    fping = no
    ioping = no
    tc = no
    idlejitter = no
    debugfs = no
    systemd-journal = no
```

**계층화된 저장이 있는 Parent 노드 (중앙 모니터링):**

```conf
[db]
    mode = dbengine
    storage tiers = 3
    dbengine page cache size = 1.4GiB

    # 계층 0: 1초 해상도, 7일
    update every = 1
    dbengine tier 0 retention size = 12GiB
    dbengine tier 0 retention time = 7d

    # 계층 1: 1분 해상도, 1개월
    dbengine tier 1 update every iterations = 60
    dbengine tier 1 retention size = 4GiB
    dbengine tier 1 retention time = 1mo

    # 계층 2: 1시간 해상도, 1년
    dbengine tier 2 update every iterations = 60
    dbengine tier 2 retention size = 2GiB
    dbengine tier 2 retention time = 1y

[ml]
    enabled = yes
    # 메트릭당 18개 ML 모델, 3시간마다 학습
    train every = 10800
    number of models per dimension = 18

[health]
    enabled = yes
    # 10초마다 상태 확인 실행
    run at least every seconds = 10

[web]
    # 대시보드 접근을 위해 네트워크에 노출
    bind to = *
    # 낶부 네트워크 접근 제한
    allow connections from = 10.* 192.168.* 172.16.* 172.17.*
```

### 스트리밍 설정: stream.conf

자식 노드 설정 (`/etc/netdata/stream.conf`):

```conf
[stream]
    enabled = yes
    destination = tcp:netdata-parent.monitoring.svc.cluster.local:19999
    api key = YOUR_API_KEY_HERE
    timeout seconds = 60
    default port = 19999
    send charts matching = *
    buffer size bytes = 1048576
    reconnect delay seconds = 5
    initial clock resync iterations = 60
```

Parent 노드 설정 (`/etc/netdata/stream.conf`):

```conf
[API_KEY]
    enabled = yes
    default memory mode = dbengine
    health enabled by default = yes
```

### 보안 강화

Web 인터페이스에 TLS 활성화:

```conf
[web]
    tls version = 1.3
    ssl key = /etc/netdata/ssl/key.pem
    ssl certificate = /etc/netdata/ssl/cert.pem
    # 모든 연결에 TLS 필요
    bind to = *=dashboard|registry|badges|management|streaming|netdata.conf|readable|writable
```

### Netdata 자체 모니터링

에이전트 자체의 리소스 사용량 추적:

```bash
# 낶부 메트릭 보기
curl -s http://localhost:19999/api/v1/info | jq '.version, .hog'

# dbengine 통계 확인
curl -s http://localhost:19999/api/v1/data?chart=netdata.dbengine_main_page_stats
```

## 대안과의 비교

| 기능 | Netdata | Prometheus | Datadog | Zabbix |
|------|---------|------------|---------|--------|
| 수집 간격 | 1초 | 15–60초 | 15초 | 30–60초 |
| 에이전트 메모리 | 100–150 MB | 200–500 MB | 200–400 MB | 150–300 MB |
| 에이전트 CPU | 1–5% | 5–15% | 3–8% | 10–20% |
| 설정 시간 | < 60초 | 30–60분 | 10–20분 | 2–4시간 |
| 자동 발견 | 800+ 통합 | 제한적 | 600+ 통합 | 템플릿 기반 |
| 내장 대시보드 | 예 (실시간) | 아니오 (PromQL만) | 예 | 예 (구식) |
| ML 이상 탐지 | 메트릭당 18개 모델 | 아니오 (추가 필요) | 예 | 제한적 |
| 장기 저장 | 계층형 dbengine | 기본 15일 | 클라우드 | 외부 DB |
| 라이선스 | GPL-3.0 (묶) | Apache-2.0 (묶) | $15/호스트/월 | GPL-2.0 (묶) |
| 알림 라우팅 | 내장 + Cloud | Alertmanager | 내장 | 내장 |
| K8s 네이티브 | 예 (Helm chart) | 예 (operator) | 예 (operator) | 제한적 |

**선택 가이드:**

- **Netdata**: 단일 노드 가시성, 실시간 문제 해결, 리소스 제한 환경, 제로 설정 모니터링이 필요한 팀.
- **Prometheus**: 클라우드 네이티브 메트릭 집계, 복잡한 PromQL 쿼리, Thanos/VictoriaMetrics와의 장기 저장.
- **Datadog**: 엔터프라이즈 전체 관측 가능성 (메트릭 + 로그 + 추적 + APM), 관리형 SaaS, SOC 2 규정 준수.
- **Zabbix**: 혼합 인프라 (네트워크 장비 + 서버 + SNMP), 에이전트 + 에이전트리스 모니터링이 필요한 조직.

## 한계 / 솔직한 평가

Netdata는 모든 모니터링 시나리오에 적합한 도구가 아닙니다:

1. **Netdata Cloud 없이는 중앙 집중식 다중 호스트 뷰가 없음**: 오픈소스 에이전트 대시보드는 노드별입니다. 100개 이상 노드의 통합 뷰를 볼려면 Netdata Cloud (SaaS) 또는 외부 시각화와 함께하는 Parent 스트리밍 설정이 필요합니다.
2. **기본 설정의 장기 저장이 제한적**: dbengine은 기본적으로 계층당 약 256 MB 디스크를 사용합니다. 규모에 맞게 수년간의 데이터를 보존하려면 명시적인 계층화된 저장 설정 또는 VictoriaMetrics 같은 외부 시계열 DB가 필요합니다.
3. **알림 파이프라인이 Alertmanager만큼 유연하지 않음**: Netdata에는 내장 상태 확인과 알림이 있지만, 복잡한 라우팅 트리, 무음 설정, 담당자 로테이션은 Netdata Cloud 또는 PagerDuty/OpsGenie와의 통합이 필요합니다.
4. **완전한 관측 가능성 플랫폼은 아님**: Netdata는 메트릭에 중점을 둡니다. 분산 추적, 구조화된 로깅, APM을 위해서는 Jaeger, Loki 또는 OpenTelemetry와 페어링하세요.
5. **Windows 지원은 상대적으로 새로움**: Windows 에이전트는 작동하지만 Linux보다 수집기가 적습니다. Windows 중심 환경에서는 배포 전 수집기 적용 범위를 확인하세요.

## 자주 묻는 질문

**Q: 프로덕션에서 Netdata가 실제로 얼마나 많은 메모리를 사용하나요?**

Parent로 스트리밍하는 자식 노드에서는 위에 표시된 RAM 모드 설정으로 약 50MB입니다. 10개 노드의 7일간 1초 데이터를 저장하는 Parent 노드는 1.4GB 페이지 캐시로 2.5–3.5GB 메모리를 사용합니다. 에이전트는 사용 가능한 시스템 메모리에 따라 캐시 크기를 자동으로 조정합니다.

**Q: Netdata Cloud 없이 Netdata를 실행할 수 있나요?**

예. 오픈소스 에이전트는 클라우드 연결 없이도 완벽하게 작동합니다. 중앙 집계를 위한 부모-자식 스트리밍을 사용하고 모든 에이전트의 19999 포트에서 직접 대시보드에 접속하세요. Netdata Cloud는 통합 대시보드, 모바일 앱 및 고급 알림 라우팅을 추가하지만 필수는 아닙니다.

**Q: Netdata와 Prometheus + Grafana를 비교하면 어떻습니까?**

Netdata는 실시간 노드별 가시성과 제로 설정에서 뛰어납니다. Prometheus는 동적 임시 클러스터의 메트릭 집계와 PromQL에서 뛰어납니다. 많은 팀이 둘 다 실행합니다: 실시간 문제 해결을 위해 각 노드에 Netdata, 클러스터 수준 집계와 장기 추세 분석을 위해 Prometheus. Netdata는 OpenMetrics 형식으로 Prometheus에 메트릭을 낸볃할 수 있습니다.

**Q: Netdata는 최대 어느 정도 규모까지 처리할 수 있나요?**

단일 Parent 노드는 초당 100만 개 이상의 샘플을 수집할 수 있습니다. 수평 확장을 위해 active-active Parent 클러스터를 배포하세요. 이론상 한계는 없습니다 — 아키텍처 자체가 분산형으로 설계되었습니다. Netdata Cloud SaaS는 수백만 개의 노드를 처리합니다.

**Q: Netdata의 데이터베이스와 설정을 어떻게 백업하나요?**

설정은 `/etc/netdata/`에 있으며 Git, Ansible, Puppet 등으로 버전 관리할 수 있습니다. `/var/cache/netdata/`의 dbengine 데이터베이스는 자가 복구 기능이 있어 수동 백업이 필요 없습니다 — 여러 Parent 노드로의 스트리밍이 자연스러운 중복성을 제공합니다. 중요한 환경에서는 active-active Parent 쌍을 실행하세요.

**Q: Netdata는 사용자 정의 애플리케이션 메트릭을 지원하나요?**

예. 내장 StatsD 서버 (8125 포트), OpenMetrics 엔드포인트를 사용하거나 Python 또는 Go로 사용자 정의 수집기를 작성하세요. `go.d.plugin` 프레임워크는 최소한의 상용구 코드로 새 수집기를 구축하는 것을 지원합니다.

## 결론

Netdata는 대부분의 모니터링 도구가 지키지 못하는 약속을 이행합니다: 무시할 수 있는 리소스 오버헤드로 즉각적인 초당 가시성을 제공합니다. Docker, Kubernetes 또는 베어 메탈 인프라를 실행하는 팀에게는 "아무것도 없음"에서 "모든 것을 모니터링"까지의 가장 빠른 경로입니다. 스트리밍 아키텍처는 단일 Raspberry Pi에서 다중 지역 Kubernetes 클러스터까지 확장되며, GPL-3.0 라이선스는 라이선스 비용이 전혀 없음을 의미합니다.

**실행 목록:**

1. 오늘 가장 중요한 서버에서 원라인 설치 명령 실행
2. Kubernetes 클러스터에 Helm chart 배포
3. 프로덕션 강화를 위해 부모-자식 스트리밍 설정
4. 위의 설정을 사용하여 리소스 제한에 맞게 `netdata.conf` 튜닝

[Netdata Telegram 커뮤니티](https://t.me/netdata)에 가입하여 5,000명 이상의 엔지니어와 실시간 지원 및 토론을 나눠보세요.

**Affiliate 제휴 공개**: 본 문서에는 DigitalOcean 및 HTStack의 제휴(affiliate) 링크가 포함되어 있습니다. 이 링크를 통해 호스팅 서비스를 구매하면 dibi8.com에서 추가 비용 없이 커미션을 받을 수 있습니다.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 참고 자료

- [Netdata GitHub 저장소](https://github.com/netdata/netdata) — 78,874 Stars, GPL-3.0
- [공식 문서](https://learn.netdata.cloud/)
- [Netdata Helm Chart 참조](https://learn.netdata.cloud/docs/netdata-agent/installation/kubernetes)
- [배포 전략 및 부모-자식 스트리밍](https://github.com/netdata/netdata/blob/master/docs/deployment-guides/deployment-strategies.md)
- [메모리 요구사항 및 사이징 가이드](https://github.com/netdata/netdata/blob/master/docs/netdata-agent/sizing-netdata-agents/ram-requirements.md)
- [장기 데이터 보존 설정](https://www.netdata.cloud/blog/long-term-data-retention/)
- [무한 확장 — 수평 아키텍처](https://www.netdata.cloud/blog/netdata-inifinite-scalability/)
- [암스테르담 대학 에너지 효율성 연구](https://www.ivanomalavolta.com/files/papers/ICSOC_2023.pdf)
- [Netdata vs Zabbix 공식 비교](https://www.netdata.cloud/comparisons/zabbix/)
- [릴리스 노트 및 변경 로그](https://github.com/netdata/netdata/releases)
