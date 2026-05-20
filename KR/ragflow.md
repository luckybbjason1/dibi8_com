---
title: 'RAGFlow: 80K+ Stars를 가진 프로덕션급 RAG 엔진 배포하기 — 2026년 Docker 설정 및 벤치마크'
description: 'RAGFlow는 심층 문서 이해와 내장 에이전트 기능을 갖춘 오픈소스 검색 증강 생성(RAG) 엔진입니다. Ollama, OpenAI, Qdrant, Elasticsearch, Redis와 호환됩니다. Docker 배포, 문서 수집, 검색 튜닝 및 프로덕션 하드닝을 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/infiniflow/ragflow'
stars: 80853
maintainer: 'infiniflow'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['ragflow', 'RAG엔진', '문서이해', 'Docker배포', 'LLM에이전트', '프로덕션RAG', '오픈소스AI']
aliases:
- /kr/posts/ragflow/
---

{{</* resource-info */>}}

![RAGFlow Logo](https://raw.githubusercontent.com/infiniflow/ragflow/main/web/public/logo.svg)

## 소개

대부분의 RAG 파이프라인은 PDF와 PowerPoint를 일반 텍스트로 처리하기 때문에 프로덕션에서 실패합니다. 표가 망가지고, 이미지 캡션이 사라지며, 스캔 문서는 읽을 수 없게 됩니다. 결과는 검색 시스템이 LLM에 쓰레기 컨텍스트를 반환하고 — 환각 답변이 뒤따릅니다. GitHub 80,000개 이상의 스타를 가진 오픈소스 RAG 엔진인 RAGFlow는 바로 이 문제를 해결하기 위해 구축되었습니다. DeepDoc 엔진이 문서 레이아웃을 이해하고, 내장 에이전트 프레임워크를 통해 단순한 챗봇이 아닌 자율 지식 작업자를 구축할 수 있습니다. 이 가이드에서는 프로덕션 서버에 RAGFlow를 배포하고, 문서 수집을 구성하며, 검색 품질을 튜닝하고, 기존 LLM 스택과 통합하는 방법을 알려드립니다.

## RAGFlow란 무엇인가?

RAGFlow는 심층 문서 이해와 LLM 기반 에이전트를 결합하여 복잡한 엔터프라이즈 문서에서 사실적이고 인용된 답변을 제공하는 오픈소스 검색 증강 생성 엔진입니다. 단순한 텍스트 분할에 의존하는 일반 RAG 라이브러리와 달리, RAGFlow는 수집 과정에서 의미적 의미를 보존하기 위해 표, 이미지, 제목 및 스캔 페이지를 포함한 문서 구조를 분석합니다. Docker 기반 플랫폼으로 웹 UI, REST API 및 에이전트 빌더와 함께 제공되어 파이프라인을 구축하는 개발자와 지식 베이스를 관리하는 비기술 사용자 모두에게 적합합니다.

## RAGFlow의 작동 원리

![RAGFlow System Architecture](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/ragflow-architecture.png)

RAGFlow의 아키텍처는 모듈식 파이프라인 디자인을 따륾며, 6개의 핵심 단계가 있습니다:

### 1. 문서 수집 (DeepDoc)

문서는 **DeepDoc** 파싱 엔진을 통해 RAGFlow에 들어옵니다. DeepDoc은 PDF, Word 파일, Excel 시트, PowerPoint 슬라이드, 이미지 및 스캔 복사본에 대해 레이아웃 분석을 수행합니다. 시각 기반 문서 레이아웃 모델을 사용하여 표, 그림, 제목, 단락 및 텍스트 블록을 식별합니다. 이 단계에서는 MinerU 및 Docling과 같은 외부 파서도 지원됩니다.

### 2. 지식 추출 및 청킹

파싱 후 RAGFlow는 템플릿 기반 청킹 전략을 적용합니다. 문서 유형에 따라 여러 청킹 모드 중에서 선택할 수 있습니다 — 단순, 수동, Q&A, 표, 논문, 책, 법률, 프레젠테이션, 사진, 단일 모드. 각 청크는 구조적 컨텍스트를 보존하며, RAGFlow는 선택적으로 키워드를 추출하고 관련 질문을 생성하여 검색 재현율을 높입니다.

### 3. 인덱싱 (하이브리드 검색 백엔드)

청크는 **Elasticsearch** (기본값) 또는 **Infinity**에 하이브리드 검색을 위해 인덱싱됩니다. 전문 검색과 밀집 벡터 검색을 모두 지원합니다. 시스템은 구성 가능한 임베딩 모델을 사용하여 임베딩을 계산하고, 키워드 검색을 위해 역색인과 함께 벡터를 저장합니다.

### 4. 검색 및 재랭킹

쿼리가 도착하면 RAGFlow는 다중 채널 검색을 수행합니다: 키워드 검색, 벡터 유사도 검색 및 지식 그래프 순회 (GraphRAG가 활성화된 경우). 결과는 융합된 후 LLM 컨텍스트 윈도우로 전달되기 전에 크로스 인코더 재랭커를 사용하여 재랭킹됩니다.

### 5. 인용이 포함된 생성

RAGFlow는 추적 가능한 인용이 포함된 검색된 청크로 구성된 프롬프트를 구성합니다. LLM은 검색된 컨텍스트에 기반하여 답변을 생성하고, RAGFlow는 사용자가 모든 주장을 검증할 수 있도록 답변 옆에 소스 청크를 표시합니다.

### 6. 에이전트 실행 (선택 사항)

간단한 질문 답변을 넘어 RAGFlow의 에이전트 프레임워크는 메모리, 도구 호출, MCP(Model Context Protocol) 통합 및 샌드박스 환경의 코드 실행을 갖춘 다단계 워크플로우를 지원합니다. 에이전트는 웹을 탐색하고, 데이터베이스를 쿼리하고, 여러 검색 작업을 연결할 수 있습니다.

### 인프라 스택

| 서비스 | 목적 | 기본 백엔드 |
|--------|------|-------------|
| 벡터 + 전문 검색 저장소 | 문서 인덱싱 및 검색 | Elasticsearch 또는 Infinity |
| 객체 저장소 | 업로드된 문서의 파일 저장 | MinIO |
| 메타데이터 데이터베이스 | 사용자 데이터, 데이터셋 구성, 채팅 기록 | MySQL |
| 캐시 및 큐 | 작업 큐 및 세션 캐싱 | Redis |
| 문서 파서 | 레이아웃 분석 및 OCR | DeepDoc (내장) |
| 프론트엔드 | 데이터셋 관리용 웹 UI | React + TypeScript |
| 백엔드 API | 핵심 오케스트레이션 로직 | Python + Go |

## 설치 및 설정

### 하드웨어 요구사항

| 리소스 | 최소 | 프로덕션 권장 |
|--------|------|--------------|
| CPU | 4 코어 (x86_64) | 8+ 코어 |
| RAM | 16 GB | 32+ GB |
| 디스크 | 50 GB SSD | 200+ GB NVMe |
| Docker | 24.0.0+ | 최신 안정 버전 |
| Docker Compose | v2.26.1+ | 최신 안정 버전 |

> **참고:** RAGFlow는 공식적으로 x86_64 플랫폼을 지원합니다. ARM64는 커뮤니티에서 테스트되었지만 자체 Docker 이미지 빌드가 필요합니다.

### 배포 전: 시스템 튜닝

RAGFlow를 시작하기 전에 커널 매개변수가 Elasticsearch에 맞게 튜닝되었는지 확인하세요:

```bash
# 현재 vm.max_map_count 확인
sysctl vm.max_map_count

# 최소 262144로 설정 (Elasticsearch 필요)
sudo sysctl -w vm.max_map_count=262144

# 재부팅 후에도 유지
echo "vm.max_map_count=262144" | sudo tee -a /etc/sysctl.conf
```

### 1단계: 리포지토리 클론

```bash
git clone https://github.com/infiniflow/ragflow.git
cd ragflow/docker
git checkout -f v0.25.4
```

### 2단계: 환경 변수 구성

```bash
# 환경 파일 편집
cp .env .env.backup
nano .env
```

설정해야 할 핵심 변수:

```bash
# docker/.env
RAGFLOW_IMAGE=infiniflow/ragflow:v0.25.4
SVR_HTTP_PORT=80
MYSQL_PASSWORD=your_secure_mysql_password
MINIO_PASSWORD=your_secure_minio_password
REDIS_PASSWORD=your_secure_redis_password

# 문서 엔진 선택: elasticsearch 또는 infinity
DOC_ENGINE=elasticsearch
```

### 3단계: Docker Compose로 시작

```bash
# CPU 전용 배포
docker compose -f docker-compose.yml up -d

# GPU 가속 문서 파싱 (NVIDIA)
# sed -i '1i DEVICE=gpu' .env
# docker compose -f docker-compose.yml up -d
```

배포 확인:

```bash
# 로그를 확인하여 성공 메시지가 나올 때까지 대기
docker logs -f ragflow-server

# 예상 출력:
#     ____   ___    ______ ______ __
#    / __ \ /   |  / ____// ____// /____  _      __
#   / /_/ // /| | / / __ / /_   / // __ \| | /| / /
#  / _, _// ___ |/ /_/ // __/  / // /_/ /| |/ |/ /
# /_/ |_|/_/  |_|\____//_/    /_/ \____/ |__/|__/
#  * Running on all addresses (0.0.0.0)
```

### 4단계: LLM 공급자 구성

`service_conf.yaml.template`를 편집하여 LLM API 키를 추가하세요:

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: OpenAI
  api_key: sk-your-openai-api-key
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

지원되는 LLM 공급자는 OpenAI, Anthropic, DeepSeek, Gemini, Azure OpenAI, Bedrock, Ollama 또는 vLLM을 통한 로컬 모델을 포함합니다. 구성 변경 후 컨테이너를 재시작하세요:

```bash
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml up -d
```

### 5단계: 웹 UI 접속

브라우저를 열고 `http://YOUR_SERVER_IP`로 이동하세요. 기본 로그인 정보는 다음과 같습니다:

```
이메일: admin@ragflow.io
비밀번호: (첫 로그인 시 설정)
```

![RAGFlow Web Interface](https://raw.githubusercontent.com/infiniflow/ragflow/main/docs/img/login.png)

## 인기 도구와의 통합

### Ollama (로컬 LLM)

에어갭 환경이나 프라이버시에 민감한 배포의 경우 RAGFlow를 Ollama에 연결하세요:

```yaml
# docker/service_conf.yaml.template
user_default_llm:
  factory: Ollama
  api_key: ""
  base_url: http://host.docker.internal:11434
  default_model: llama3.2
```

사용하기 전에 Ollama에서 모델을 가져오세요:

```bash
ollama pull llama3.2
ollama pull nomic-embed-text
```

RAGFlow 웹 UI의 **설정 > 모델 공급자**에서 임베딩 모델을 구성하세요.

### OpenAI (클우드 API)

```yaml
user_default_llm:
  factory: OpenAI
  api_key: ${OPENAI_API_KEY}
  base_url: https://api.openai.com/v1
  default_model: gpt-4.1-mini
```

환경 변수 치환을 사용하여 비밀 하드코딩을 피하세요:

```bash
# .env 에서
OPENAI_API_KEY=sk-your-key
```

### Elasticsearch에서 Infinity로 마이그레이션

Infinity는 대규모 배포에 최적화된 RAGFlow의 융합 컨텍스트 엔진입니다. 전환 방법:

```bash
# 1. 모든 컨테이너 중지 및 볼륨 삭제
docker compose -f docker-compose.yml down -v

# 2. .env 업데이트
sed -i 's/DOC_ENGINE=elasticsearch/DOC_ENGINE=infinity/' .env

# 3. 재시작
docker compose -f docker-compose.yml up -d
```

> **경고:** 기존 데이터가 삭제됩니다. 마이그레이션 전 데이터셋을 백업하세요.

### Redis를 외부 캐시로 사용

프로덕션 배포를 위해 외부 Redis 클러스터를 사용하세요:

```yaml
# docker-compose.yml (발췌)
services:
  redis:
    image: redis:7-alpine
    command: redis-server --requirepass ${REDIS_PASSWORD}
    volumes:
      - redis_data:/data
    deploy:
      resources:
        limits:
          memory: 2G
```

### Qdrant를 대안 벡터 스토어로 사용

RAGFlow가 Elasticsearch 또는 Infinity를 기본으로 사용하지만, Python SDK를 통해 Qdrant를 통합하여 사용자 정의 검색 파이프라인을 구축할 수 있습니다:

```python
from qdrant_client import QdrantClient
from ragflow_sdk import RAGFlow

# 두 시스템에 동시 연결
ragflow = RAGFlow(api_key="your-key", base_url="http://localhost:9380")
qdrant = QdrantClient(url="http://localhost:6333")

# RAGFlow 청크와 Qdrant 벡터를 결합한 사용자 정의 하이브리드 검색
chunks = ragflow.retrieve(dataset_id="ds_123", query="annual revenue 2025")
vectors = qdrant.search(collection="financial_reports", vector=query_embedding, limit=5)
```

## 벤치마크 / 실제 사용 사례

### 검색 품질 벤치마크

AI Multiple의 2026년 벤치마크는 GPT-4.1-mini를 생성 모델로 사용하여 100개의 표준화된 쿼리로 RAGFlow를 다른 프레임워크와 비교했습니다:

| 메트릭 | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|--------|---------|------------|----------|---------------|
| 답변 정확도 | 97% | 94% | 95% | 91% |
| 평균 검색 지연 시간 | 420ms | 380ms | 450ms | 510ms |
| 토큰 효율성 (쿼리당) | 1,450 | 1,600 | 1,570 | 2,400 |
| 프레임워크 오버헤드 | 8ms | 6ms | 5.9ms | 10ms |
| 인용 근거 점수 | 96% | 88% | 90% | 82% |

RAGFlow는 DeepDoc의 레이아웃 인식 파싱으로 인해 정확도와 인용 근거에서 선두를 달리며, 이는 다른 프레임워크가 텍스트 분할 중 제거하는 표 구조와 이미지 캡션을 보존합니다.

### 문서 파싱 성능

| 문서 유형 | RAGFlow (DeepDoc) | LlamaIndex | Haystack |
|----------|-------------------|------------|----------|
| 표가 있는 PDF | 전체 구조 보존 | 플랫 텍스트 | 플랫 텍스트 |
| 스캔 PDF (OCR) | 기본 지원 | 확장 필요 | 확장 필요 |
| PowerPoint 슬라이드 | 슬라이드 인식 청킹 | 슬라이드당 | 슬라이드당 |
| Excel 스프레드시트 | 셀 수준 추출 | CSV 변환 | CSV 변환 |
| 다국어 문서 | 교차 언어 쿼리 | 단일 언어 | 단일 언어 |

### 프로덕션 배포 프로파일

| 프로파일 | 사용자 | 문서 | 하드웨어 | 월간 클라우드 비용 |
|---------|--------|------|----------|-------------------|
| 팀 (10명) | 10 | 10,000 | 4 vCPU, 16 GB RAM | ~$80 (DigitalOcean) |
| 부서 (100명) | 100 | 100,000 | 8 vCPU, 32 GB RAM | ~$200 (DigitalOcean) |
| 엔터프라이즈 (1000+명) | 1000+ | 100만+ | 16 vCPU, 64 GB RAM + GPU | ~$800+ (클우드) |

> RAGFlow를 위한 신뢰할 수 있는 클라우드 호스트를 찾고 있나요? [DigitalOcean](https://www.digitalocean.com/)에서 원클릭 Docker 설정으로 배포하거나, [HTStack](https://www.htstack.com/)에서 내장 모니터링이 포함된 관리형 컨테이너 호스팅을 사용하세요.

## 고급 사용법 / 프로덕션 하드닝

### 리버스 프록시로 HTTPS 활성화

```nginx
# /etc/nginx/sites-available/ragflow
server {
    listen 443 ssl http2;
    server_name ragflow.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/ragflow.yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ragflow.yourcompany.com/privkey.pem;

    location / {
        proxy_pass http://localhost:80;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
    }
}
```

### 다중 홉 추론을 위한 GraphRAG 활성화

GraphRAG은 문서에서 지식 그래프를 추출하여 교차 문서 추론을 가능하게 합니다:

```python
# RAGFlow 웹 UI 또는 API를 통해
POST /api/datasets/{dataset_id}/chunks/graph
{
  "method": "ligh",
  "entity_types": ["PERSON", "ORGANIZATION", "PRODUCT", "EVENT"],
  "max_workers": 4
}
```

GraphRAG은 특히 법률 문서, 연구 논문, 금융 보고서에서 엔터티 간의 관계가 여러 페이지에 걸쳐 있는 경우 효과적입니다.

### 샌드박스 구성 (코드 실행)

RAGFlow의 에이전트는 샌드박스 환경에서 Python 및 JavaScript 코드를 실행할 수 있습니다. 이는 gVisor가 필요합니다:

```bash
# gVisor 설치 (샌드박스에 필요)
sudo apt-get install -y runsc

# docker-compose.yml에서 활성화
services:
  ragflow:
    environment:
      - ENABLE_SANDBOX=true
    devices:
      - /dev/kvm
```

### Prometheus로 모니터링

```yaml
# docker-compose.yml에 추가
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
```

모니터링할 핵심 메트릭:

```yaml
# prometheus.yml
scrape_configs:
  - job_name: 'ragflow'
    static_configs:
      - targets: ['ragflow-server:9380']
    metrics_path: /metrics
```

### 백업 전략

```bash
#!/bin/bash
# /opt/ragflow/backup.sh

BACKUP_DIR="/backups/ragflow/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# MySQL 백업
docker exec ragflow-mysql mysqldump -u root -p$MYSQL_PASSWORD ragflow > $BACKUP_DIR/mysql.sql

# Elasticsearch 인덱스 백업
docker exec ragflow-es curl -sX POST "localhost:9200/_snapshot/backup" \
  -H 'Content-Type: application/json' \
  -d'{"indices": "ragflow_*"}'

# MinIO 객체 백업
docker exec ragflow-minio mc mirror /data $BACKUP_DIR/minio

# 원격 저장소에 동기화
rclone sync $BACKUP_DIR s3:my-backup-bucket/ragflow/
```

## 대안과의 비교

| 기능 | RAGFlow | LlamaIndex | Haystack | LangChain RAG |
|------|---------|------------|----------|---------------|
| **GitHub Stars** | 80,853 | 49,500 | 25,300 | 105,000 |
| **라이선스** | Apache-2.0 | MIT | Apache-2.0 | MIT |
| **심층 문서 파싱** | DeepDoc (내장) | LlamaParse (유료) | 기본 | 기본 |
| **시각적 워크플로우 빌더** | 예 | 아니오 | 아니오 | 아니오 |
| **내장 웹 UI** | 예 | 아니오 | 아니오 | 아니오 |
| **에이전트 프레임워크** | 네이티브 (메모리 포함) | 외부 | 외부 | LangGraph |
| **하이브리드 검색** | 전문 + 벡터 | 벡터 전용 | 전문 + 벡터 | 저장소에 따라 |
| **GraphRAG 지원** | 예 | 예 | 확장 통해 | 확장 통해 |
| **스캔 문서 OCR** | 기본 | 유료 애드온 | 확장 통해 | 확장 통해 |
| **코드 실행 샌드박스** | 예 (gVisor) | 아니오 | 아니오 | 아니오 |
| **셀프 호스팅 배포** | Docker Compose | Python 패키지 | Python 패키지 | Python 패키지 |
| **MCP 프로토콜 지원** | 예 | 아니오 | 아니오 | 아니오 |
| **REST API** | 전체 API | 빌드 필요 | 빌드 필요 | 빌드 필요 |
| **엔터프라이즈 SSO** | 예 | 클라우드 전용 | 클라우드 전용 | 클라우드 전용 |

### 언제 무엇을 선택할 것인가

- **RAGFlow**: 심층 문서 이해, 시각적 UI 및 내장 에이전트 기능을 갖춘 완전한 자체 호스팅 RAG 플랫폼이 필요한 경우. 복잡한 문서(PDF, 스캔, 스프레드시트)를 처리하고 데이터를 완전히 제어하려는 엔터프라이즈에 가장 적합합니다.
- **LlamaIndex**: 특정 인덱싱 요구사항이 있는 커스텀 Python 애플리케이션을 구축하고 있으며, 플랫폼보다 라이브러리를 선호하는 경우. 최대의 유연성이 필요하고 자체 UI를 구축하는 데 문제가 없는 개발자에게 가장 적합합니다.
- **Haystack**: deepset의 강력한 평가 도구와 엔터프라이즈 지원이 있는 프로덕션급 파이프라인 프레임워크가 필요한 경우. 파이프라인 관측 가능성과 테스트를 우선시하는 팀에 가장 적합합니다.
- **LangChain RAG**: 가장 큰 통합 생태계가 필요하고 직접 컴포넌트를 조립하는 데 문제가 없는 경우. 빠르게 프로토타입을 만들고 빠르게 반복해야 하는 스타트업에 가장 적합합니다.

## 한계 / 정직한 평가

**가벼운 도구가 아닙니다.** RAGFlow는 최소 16GB RAM과 여러 백엔드 서비스(Elasticsearch, MySQL, Redis, MinIO)가 필요합니다. 이는 단일 바이너리 배포가 아닙니다. 사이드 프로젝트용 간단한 RAG 설정이 필요한 경우, LightRAG이나 직접 LlamaIndex 구현과 같은 더 가벼운 대안을 고려하세요.

**공식 이미지는 x86 전용입니다.** ARM64 플랫폼(Apple Silicon 및 AWS Graviton 포함)은 소스에서 자체 Docker 이미지를 빌드해야 합니다. 이는 배포 시간을 상당히 늘립니다.

**고급 기능은 학습 곡선이 있습니다.** 시각적 UI는 80%의 사용 사례를 커버하지만, GraphRAG 활성화, 커스텀 임베딩 파이프라인 구성 또는 에이전트 빌드는 문서를 주의 깊게 읽어야 합니다.

**네이티브 다중 리전 복제가 없습니다.** 데이터셋을 백업하고 복원할 수 있지만, RAGFlow는 기본 스토리지에 대한 내장 교차 리전 복제를 제공하지 않습니다. MySQL 및 Elasticsearch 복제를 별도로 구성해야 합니다.

**슬림 이미지에 임베딩 모델이 포함되지 않습니다.** v0.22.0부터 슬림 이미지만 게시됩니다. 임베딩 모델을 런타임에 다운로드하거나 외부 임베딩 서비스에 연결해야 합니다.

## 자주 묻는 질문

### 프로덕션 RAGFlow 배포에 어떤 하드웨어가 필요한가요?

50명 이상의 사용자를 서비스하는 프로덕션 배포의 경우, 최소 8 vCPU 코어, 32GB RAM, 200GB NVMe SSD가 있는 서버를 사용하세요. OCR로 대형 스캔 PDF를 파싱하는 경우, DeepDoc 작업을 가속화하기 위해 최소 8GB VRAM이 있는 GPU를 추가하세요. 10명 미만의 소규모 팀의 경우, 최소 사양(4 vCPU, 16GB RAM)으로 충분합니다.

### RAGFlow를 로컬 LLM만 사용하도록 설정할 수 있나요?

예. RAGFlow는 Ollama, vLLM, Xinference, LocalAI와 통합됩니다. `service_conf.yaml.template`에서 로컬 추론 서버의 base URL로 LLM 공급자를 구성하세요. 임베딩 모델의 경우 Ollama를 통해 임베딩 모델(`nomic-embed-text` 등)을 가져와 웹 UI의 모델 공급자에서 구성하세요.

### RAGFlow는 스캔 PDF와 이미지를 어떻게 처리하나요?

RAGFlow의 DeepDoc 엔진에는 스캔 PDF, PNG, JPEG를 처리하는 내장 OCR 파이프라인이 포함되어 있습니다. 문서 레이아웃 분석 모델을 사용하여 OCR 적용 전에 텍스트 영역, 표 및 이미지를 식별합니다. 추출된 텍스트는 구조적 컨텍스트를 유지합니다 — 표는 표 형태로 보존 되며 단락으로 평탄화되지 않습니다.

### RAGFlow를 사용할 때 내 데이터는 안전한가요?

자체 호스팅 시 모든 데이터는 인프라에 남습니다. 문서는 MinIO에, 벡터는 Elasticsearch/Infinity에, 메타데이터는 MySQL에 저장됩니다 — 모두 네트워크 내에서. 클라우드 LLM 공급자를 구성하지 않는 한 RAGFlow는 문서를 외부 서비스로 전송하지 않습니다. 최대한의 프라이버시를 위해 로컬 LLM과 임베딩 모델을 사용하세요.

### RAGFlow를 새 버전으로 업그레이드하려면 어떻게 하나요?

먼저 MySQL 데이터베이스와 Elasticsearch 인덱스를 백업하세요. 그런 다음 새 Docker 이미지를 가져오고, `.env`의 `RAGFLOW_IMAGE` 변수를 업데이트하고, 컨테이너를 재시작하세요. 버전 간의 주요 변경 사항에 대해 항상 릴리스 노트를 확인하세요.

```bash
cd ragflow/docker
git fetch --tags
git checkout -f v0.25.4
# .env에서 새 이미지 태그 업데이트
docker compose -f docker-compose.yml down
docker compose -f docker-compose.yml pull
docker compose -f docker-compose.yml up -d
```

### RAGFlow를 기존 애플리케이션에 통합할 수 있나요?

예. RAGFlow는 완전한 REST API를 노출하고 Python 및 JavaScript SDK를 제공합니다. 프로그래밍 방식으로 데이터셋을 생성하고, 문서를 업로드하고, 채팅 세션을 시작하고, 답변을 검색할 수 있습니다. API 문서는 RAGFlow 인스턴스의 `/api/docs`에서 확인할 수 있습니다.

### RAGFlow는 어떤 문서 형식을 지원하나요?

RAGFlow는 Word(DOC, DOCX), PowerPoint(PPT, PPTX), Excel(XLS, XLSX), PDF, TXT, Markdown, 이미지(PNG, JPG, BMP, TIFF), 스캔 복사본, HTML, CSV를 지원합니다. 또한 Confluence, Notion, Google Drive, Discord, S3에서 데이터 가져오기를 지원합니다.

### RAGFlow는 멀티 테넌시를 지원하나요?

RAGFlow는 단일 인스턴스 내에서 역할 기반 액세스 제어를 통해 다중 사용자 및 데이터셋을 지원합니다. 진정한 멀티 테넌시(별도 데이터가 있는 격리된 테넌트)의 경우, 현재 별도의 RAGFlow 인스턴스를 실행하거나 애플리케이션 레이어에서 테넌트 필터링을 구현해야 합니다.

## 결론

RAGFlow는 심층 문서 이해, 프로덕션 준비 웹 UI 및 내장 에이전트 기능을 단일 배포 가능 시스템에 결합한 유일한 오픈소스 RAG 플랫폼입니다. 80,853개의 GitHub Star와 활발한 개발 주기를 통해, 기본 텍스트 분할 RAG 파이프라인 이상이 필요한 팀에 그 가치를 입증했습니다. Docker 기반 배포는 30분 이내에 완료되며, 하이브리드 검색 아키텍처는 프레임워크 전용 대안보다 측정 가능하게 더 나은 검색 품질을 제공합니다.

**다음 단계:**

1. 리포지토리를 클론하고 Docker Compose를 사용하여 서버에 RAGFlow를 배포하세요
2. 표가 있는 복잡한 PDF를 업로드하고 웹 UI에서 파싱 품질을 확인하세요
3. 선호하는 LLM 공급자(OpenAI, DeepSeek 또는 Ollama)를 구성하세요
4. 프로덕션 사용을 위해 HTTPS 및 자동 백업을 설정하세요
5. 지원 및 기능 업데이트를 위해 커뮤니티에 가입하세요

[Telegram 개발자 커뮤니티](https://t.me/dibi8opensource)에 참여하여 배포 팁과 프로덕션 RAG 토론을 나누세요. 여러분의 RAGFlow 설정을 공유해 주세요 — 최고의 구성을 주간 뉴스레터에 소개합니다.

*이 기사의 일부 링크는 제휴 링크입니다. 이 링크를 통해 호스팅 서비스를 구매하면 커미션을 받을 수 있습니다. 이는 편집 추천에 영향을 미치지 않습니다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [RAGFlow GitHub 리포지토리](https://github.com/infiniflow/ragflow)
- [RAGFlow 공식 문서](https://ragflow.io/docs/dev/)
- [RAGFlow 빠른 시작 가이드](https://ragflow.io/docs/dev/)
- [RAGFlow Docker 배포 README](https://github.com/infiniflow/ragflow/blob/main/docker/README.md)
- [DeepDoc 문서 이해](https://github.com/infiniflow/ragflow/tree/main/deepdoc)
- [RAGFlow REST API 참조](https://ragflow.io/docs/dev/category/references)
- [RAGFlow vs 다른 RAG 프레임워크 벤치마크](https://aimultiple.com/rag-frameworks)
- [LlamaIndex GitHub 리포지토리](https://github.com/run-llama/llama_index)
- [Haystack GitHub 리포지토리](https://github.com/deepset-ai/haystack)
- [2026년 최고의 오픈소스 RAG 프레임워크 비교](https://www.firecrawl.dev/blog/best-open-source-rag-frameworks)
- [RAGFlow 아키텍처 설명](https://milvus.io/ai-quick-reference/what-is-ragflow-and-how-does-it-work)
- [RAGFlow VPS 프로덕션 배포](https://zhujibaike.com/2497.html)
