---
title: 'WorldMonitor: 지리적 감시를 위한 실시간 글로벌 인텔리전스 대시보드'
description: 뉴스, 지정학적 사건, 인프라 추적을 집계하는 실시간 AI 기반 글로벌 인텔리전스 대시보드. 59K 스타. 팔란티어 고담의 오픈소스 대안.
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: ai-tools
tags: ['ai', '대시보드', '지정학', '모니터링', '뉴스', '오픈소스', 'osint', 'palantir', '상황인식']
slug: worldmonitor-real-time-global-intelligence-dashboard
featureImage: /images/articles/worldmonitor-real-time-global-intelligence-dashboard-for-geopolitical-monitoring.png
lang: kr
github_repo: https://github.com/WorldMonitorHQ/worldmonitor
license: MIT
---



# WorldMonitor: 실시간 글로벌 인텔리전스 대시보드

**WorldMonitor**는 뉴스, 지정학적 사건 및 인프라 데이터를 통합된 상황 인식 인터페이스로 집계하는 오픈소스 실시간 글로벌 인텔리전스 대시보드입니다. **59,524개의 GitHub 스타**를 달성하며, 팔란티어 고담과 같은 상업용 플랫폼에 대한 지정학적 모니터링 및 OSINT 분석 분야의 선두 오픈소스 대안이 되었습니다.

이 글은 설치, 구성, 데이터 소스, API 사용, 배포 옵션 및 저널리스트, 연구원, 보안 분석가를 위한 실용적 적용 방법을 다룹니다.

## TL;DR

WorldMonitor는 단편화된 글로벌 데이터 스트림을 단일하고 실행 가능한 인텔리전스 대시보드로 변환합니다. 50개 이상의 소스에서 뉴스를 수집하고, 지정학적 사건을 실시간으로 추적하며, 전 세계 주요 인프라를 모니터링하고, AI 기반 분석과 사용자 정의 알림을 제공합니다. 기업 가격을 지불하지 않고도 글로벌 사건에 대한 포괄적이고 실시간적인 시각화가 필요한 모든 사람에게 완벽합니다.

## WorldMonitor란?

WorldMonitor는 여러 데이터 소스를 하나의 글로벌 사건 통합 뷰로 결합하는 자체 호스팅 인텔리전스 대시보드입니다. 단순히 헤드라인을 수집하는 전통적인 뉴스 집계기와 달리, WorldMonitor는 AI 기반 분석을 적용하여 사건을 연관시키고, 패턴을 감지하며, 실행 가능한 인텔리전스를 제공합니다.

이 플랫폼은 여러 지리적 지역과 데이터 카테고리 전반에서 실시간 상황 인식이 필요한 저널리스트, 연구원, 정책 분석가 및 보안 전문가를 위해 설계되었습니다. 개인 분석가를 위한 단일 인스턴스 배포와 팀 전체 운영을 위한 분산 아키텍처 모두 지원합니다.

주요 기능:

- **다중 소스 뉴스 집계**: 50개 이상의 글로벌 뉴스 소스를 커버하는 RSS 피드, API 및 웹 크롤러에서
- **지정학적 사건 추적**: 실시간 매핑 및 타임라인 시각화
- **인프라 모니터링**: 발전소, 통신 타워, 교통 허브 등 주요 시설 모니터링
- **AI 기반 상관관계 엔진**: 겉보기에 관련 없는 사건 간 관계 식별
- **사용자 정의 알림**: 키워드, 지역, 사건 유형 또는 심각도 기준
- **역사 분석**: 집계 데이터 수개월을 아우르는 검색 가능한 아카이브
- **API 접근**: 다른 인텔리전스 도구와의 프로그램matic 통합 지원

## 설치 가이드

### 사전 요구사항

WorldMonitor를 설치하기 전에 시스템이 다음 요구사항을 충족하는지 확인하세요:

- **운영체제**: Ubuntu 22.04 LTS, Debian 12 또는 macOS 14+
- **CPU**: 최소 4코어 (생산 환경에는 8코어 권장)
- **RAM**: 최소 8GB (16GB 권장)
- **저장소**: 50GB SSD (데이터 유지 기간에 따라 증가)
- **네트워크**: 데이터 수집을 위한 외부 인터넷 액세스
- **종속성**: Node.js 20+, Python 3.11+, PostgreSQL 15+

### 옵션 1: Docker Compose 배포 (권장)

가장 빠른 시작 방법은 제공된 Docker Compose 구성을 사용하는 것입니다:

```bash
git clone https://github.com/koala73/worldmonitor.git
cd worldmonitor

# 예제 구성 복사
cp config.example.yaml config.yaml

# 모든 서비스 시작
docker compose up -d
```

이는 애플리케이션 서버, PostgreSQL 데이터베이스, Redis 캐시 및 웹 프론트엔드를 실행합니다. 기본 자격 증명은 `.env` 파일에 설정되어 있습니다 — 생산 환경에서는 즉시 변경하세요.

### 옵션 2: 수동 설치

배포에 세밀한 제어가 필요한 사용자를 위한 방법:

```bash
# 저장소 복제
git clone https://github.com/koala73/worldmonitor.git
cd worldmonitor

# 백엔드 종속성 설치
pip install -r requirements.txt

# 프론트엔드 종속성 설치
cd frontend && npm install && cd ..

# 데이터베이스 설정
createdb worldmonitor
psql worldmonitor < migrations/001_init.sql

# 애플리케이션 구성
cp config.example.yaml config.yaml
# config.yaml을 설정으로 편집

# 데이터베이스 마이그레이션 실행
python manage.py migrate

# 애플리케이션 서버 시작
python manage.py runserver 0.0.0.0:8000

# 프론트엔드 시작 (별도 터미널에서)
cd frontend && npm run start
```

### 옵션 3: Kubernetes 배포

여러 노드에 걸친 생산 규모 배포용:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worldmonitor
spec:
  replicas: 3
  selector:
    matchLabels:
      app: worldmonitor
  template:
    metadata:
      labels:
        app: worldmonitor
    spec:
      containers:
      - name: worldmonitor
        image: ghcr.io/koala73/worldmonitor:latest
        ports:
        - containerPort: 8000
        envFrom:
        - configMapRef:
            name: worldmonitor-config
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
          limits:
            memory: "4Gi"
            cpu: "2000m"
```

## 구성 심층 분석

### 데이터 소스 구성

WorldMonitor는 여러 데이터 소스 유형을 지원합니다. `config.yaml`에서 구성하세요:

```yaml
data_sources:
  rss_feeds:
    enabled: true
    sources:
      - name: "Reuters"
        url: "https://feeds.reuters.com/reuters/worldNews"
        categories: ["politics", "business"]
        refresh_interval: 300
      - name: "BBC World"
        url: "http://feeds.bbci.co.uk/news/world/rss.xml"
        categories: ["politics", "health"]
        refresh_interval: 300
      - name: "Al Jazeera"
        url: "https://www.aljazeera.com/xml/rss/all.xml"
        categories: ["politics", "conflict"]
        refresh_interval: 600

  api_feeds:
    enabled: true
    sources:
      - name: "GDELT"
        api_key: "${GDELT_API_KEY}"
        endpoint: "https://api.gdeltproject.org/api/v2/event/doc"
        categories: ["conflict", "political"]
        refresh_interval: 900
      - name: "ACLED"
        api_key: "${ACLED_API_KEY}"
        endpoint: "https://api.acled.info/v1/events"
        categories: ["conflict", "protest"]
        refresh_interval: 3600

  web_scrapers:
    enabled: true
    sources:
      - name: "Government Press Releases"
        urls:
          - "https://www.state.gov/latest-releases/"
          - "https://www.un.org/press/en/"
        selectors:
          title: "h2.article-title"
          content: ".article-body"
          date: ".article-date"
        refresh_interval: 1800
```

### AI 분석 파이프라인

AI 기반 분석 엔진은 여러 단계를 거쳐 들어오는 데이터를 처리합니다:

```python
from worldmonitor.ai.pipeline import AnalysisPipeline
from worldmonitor.ai.models import EventClassifier, CorrelationEngine

# 분석 파이프라인 초기화
pipeline = AnalysisPipeline(
    classifier=EventClassifier(model="worldmonitor/classifier-v3"),
    correlation=CorrelationEngine(model="worldmonitor/correlation-v2"),
    embedding_model="worldmonitor/embedding-multilingual"
)

# 뉴스 기사 배치 처리
results = await pipeline.process_batch(
    articles=batch_data,
    min_confidence=0.7,
    include_correlations=True
)

# 특정 지역의 연관 사건 가져오기
correlated = await pipeline.get_correlated_events(
    region="east_asia",
    time_window="24h",
    event_types=["political", "economic"]
)
```

### 알림 구성

모니터링 우선순위에 따라 사용자 정의 알림을 설정하세요:

```yaml
alerts:
  rules:
    - name: "주요 충돌 감지"
      conditions:
        - field: "event_type"
          operator: "eq"
          value: "armed_conflict"
        - field: "severity"
          operator: "gte"
          value: 7
      actions:
        - type: "notification"
          channels: ["email", "telegram"]
          template: "high_severity_conflict"
        - type: "dashboard_highlight"
          duration: "3600"

    - name: "인프라 중단"
      conditions:
        - field: "infrastructure_type"
          operator: "in"
          value: ["power_grid", "telecom", "transport"]
        - field: "status"
          operator: "eq"
          value: "disrupted"
      actions:
        - type: "notification"
          channels: ["email", "slack", "pagerduty"]
          template: "infrastructure_alert"
        - type: "geopoint_map"
          zoom_level: 12

    - name: "키워드 급증 감지"
      conditions:
        - field: "keywords"
          operator: "contains_any"
          value: ["sanctions", "embargo", "tariff", "trade_war"]
        - field: "volume_change"
          operator: "gte"
          value: 200
      actions:
        - type: "notification"
          channels: ["email"]
          template: "keyword_surge"
          cooldown: "1800"
```

## 핵심 기능 상세

### 글로벌 뉴스 집계 엔진

WorldMonitor의 뉴스 집계 엔진은 여러 언어의 50개 이상의 소스에서 데이터를 가져옵니다. 시스템은 스마트 중복 제거를 통해 여러 채널에서 동일한 이야기를 보고하는 것을 방지하면서도 주요 사건에 대한 지역적 관점을 보존합니다.

```bash
# 필터로 집계된 뉴스 쿼리
curl -X GET "https://your-worldmonitor/api/v1/news" \
  -H "Authorization: Bearer *** \
  -d "region=east_asia&categories=politics,economy&min_severity=5&hours=24"

# 중복 제거된 스토리 가져오기
curl -X GET "https://your-worldmonitor/api/v1/news/deduplicated" \
  -H "Authorization: Bearer *** \
  -d "cluster_window=3600&language=en"
```

### 지정학적 사건 매핑

사건은 색상 코딩된 심각도 수준으로 대화형 세계 지도에 표시됩니다. 사용자는 사건 유형, 지역, 날짜 범위 및 소스 신뢰도 점수로 필터링할 수 있습니다. 타임라인 뷰는 사건 진행 상황을 표시하고 연쇄 효과를 식별합니다.

### 인프라 추적 모듈

인프라 모듈은 전 세계 주요 시설의 데이터베이스를 유지합니다:

- 발전소 및 전력 그리드
- 통신 타워 및 광케이블 경로
- 교통 허브 (공항, 항구, 철도역)
- 상수도 처리 시설
- 데이터 센터 및 클라우드 인프라

각 시설은 소유주, 용량 및 위험 수준으로 태그됩니다. 상태 변경 시 자동 알림과 지도 업데이트가 트리거됩니다.

### AI 상관관계 엔진

고유 상관관계 엔진은 겉보기에 관련 없는 사건 간 관계를 식별합니다. 예를 들어, 한 국가의 정치적 발언이 다른 국가의 시장 변동과 상관관계가 있거나, A 지역의 인프라 중단이 B 지역의 유사 사건에 선행했을 수 있음을 감지합니다.

```python
from worldmonitor.correlation import CorrelationEngine

engine = CorrelationEngine()

# 최근 사건 간 상관관계 찾기
correlations = engine.find_correlations(
    events=event_list,
    max_lag_hours=72,
    min_strength=0.6,
    correlation_types=["temporal", "geographic", "thematic"]
)

for corr in correlations:
    print(f"강도: {corr.strength:.2f}")
    print(f"유형: {corr.type}")
    print(f"사건: {corr.event_ids}")
    print(f"설명: {corr.explanation}")
```

## API 참조

WorldMonitor는 프로그램matic 접근을 위한 포괄적인 REST API를 제공합니다:

### 인증

```bash
# API 토큰 발급
curl -X POST "https://your-worldmonitor/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "${WM_PASSWORD}"}'
```

### 뉴스 API

```bash
# 페이지네이션과 함께 최근 뉴스 목록
curl "https://your-worldmonitor/api/v1/news?page=1&per_page=50" \
  -H "Authorization: Bearer ***

# 지역별 뉴스 가져오기
curl "https://your-worldmonitor/api/v1/news?region=south_asia&date_from=2026-06-01" \
  -H "Authorization: Bearer ***

# 키워드 검색
curl "https://your-worldmonitor/api/v1/news/search?q=trade+sanctions" \
  -H "Authorization: Bearer ***
```

### 이벤트 API

```bash
# 지정학적 사건 목록
curl "https://your-worldmonitor/api/v1/events?type=political&severity_gte=6" \
  -H "Authorization: Bearer ***

# 사건 상세 정보
curl "https://your-worldmonitor/api/v1/events/EVT-2026-0625-001" \
  -H "Authorization: Bearer ***

# 사건 타임라인
curl "https://your-worldmonitor/api/v1/events/EVT-2026-0625-001/timeline" \
  -H "Authorization: Bearer ***
```

### 알림 API

```bash
# 활성 알림 목록
curl "https://your-worldmonitor/api/v1/alerts?status=active" \
  -H "Authorization: Bearer ***

# 알림 확인
curl -X PUT "https://your-worldmonitor/api/v1/alerts/ALT-001/acknowledge" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{"acknowledged_by": "analyst@example.com", "notes": "조사 중"}'

# 사용자 정의 알림 규칙 생성
curl -X POST "https://your-worldmonitor/api/v1/alerts/rules" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "name": "사용자 정의 규칙",
    "conditions": {
      "regions": ["east_asia"],
      "event_types": ["political"],
      "severity_min": 5
    },
    "actions": {
      "channels": ["email"],
      "recipients": ["team@example.com"]
    }
  }'
```

## 배포 옵션

### 단일 인스턴스 (개인 분석가)

개인 저널리스트나 연구원에게는 4코어 VPS에서의 단일 Docker Compose 배포로 충분합니다:

```
서버: 4 vCPU, 8GB RAM, 100GB SSD
비용: 약 $20/월 (DigitalOcean / HTStack)
용량: 약 1,000 사건/일, 30일 유지
```

### 팀 배포

5-20명 분석가 팀을 위해서는 Redis 클러스터와 PostgreSQL 읽기 복제본을 추가하세요:

```
애플리케이션 서버: 3x 4 vCPU, 16GB RAM (로드 밸런서 뒤)
데이터베이스: PostgreSQL 기본 + 2개 읽기 복제본
캐시: Redis Cluster (3개 노드)
저장소: 500GB SSD + S3 아카이브
비용: 약 $200/월
용량: 약 10,000 사건/일, 90일 유지
```

### 기업/분산

정부 또는 대규모 조직 배포용:

```
데이터 주권 제어와 함께 다중 지역 배포
10개 이상 애플리케이션 노드에 대한 수평 확장
자동 장애 조정을 위한 Patroni 기반 PostgreSQL
역사적 데이터 아카이브를 위한 오브젝트 스토리지
기존 SIEM/SOC 플랫폼과의 통합
비용: 맞춤형 가격
용량: 무제한, 지리 분산 데이터 수집 지원
```

## 기타 도구와의 통합

WorldMonitor는 인기 있는 인텔리전스 및 통신 도구와 원활하게 통합됩니다:

### Slack 통합

```bash
# Slack 앱 설치
curl -X POST "https://your-worldmonitor/api/v1/integrations/slack" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "#global-events",
    "alert_rules": ["major_conflict", "infrastructure_disruption"],
    "digest_frequency": "hourly"
  }'
```

### Telegram 봇

```bash
# Telegram 봇 통합 생성
curl -X POST "https://your-worldmonitor/api/v1/integrations/telegram" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "bot_token": "${TELEGRAM_BOT_TOKEN}",
    "chat_id": "${TELEGRAM_CHAT_ID}",
    "alert_rules": ["all_high_severity"]
  }'
```

### Grafana 대시보드

```bash
# Grafana용 메트릭 내보내기
curl -X POST "https://your-worldmonitor/api/v1/metrics/grafana" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "datasource": "prometheus",
    "dashboard_template": "worldmonitor-overview"
  }'
```

### ELK Stack / Elasticsearch

```yaml
# WorldMonitor Elasticsearch 출력 구성
output:
  elasticsearch:
    hosts: ["https://es-cluster.internal:9200"]
    index: "worldmonitor-%{+yyyy.MM.dd}"
    username: "${ES_USER}"
    password: "${ES_PASS}"
    template_overwrite: true
    bulk_size: 500
    flush_interval: 5
```

## 비교: WorldMonitor vs 상업용 대안

| 기능 | WorldMonitor | Palantir Gotham | Meltwater | Brandwatch |
|
커뮤니티 가입: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

내부 링크: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/kr/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/kr/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**고지 사항**: 본 기사는 제휴 관계가 있을 수 있는 도구를 언급합니다. 우리는 리뷰에 대한 대가를 받지 않습니다. 모든 의견은 우리 자신의 것입니다.
