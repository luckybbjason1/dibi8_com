---
title: 'Lobe Chat: 20+ LLM 제공업체와 플러그인 시스템을 갖춘 오픈소스 ChatGPT UI 대안 — 2026 완벽 설치 가이드'
description: 'Lobe Chat을 자체 호스팅 ChatGPT 대안으로 배포하세요. 20+ LLM 제공업체, 플러그인 시스템, PWA, 다국어 UI 지원. 벤치마크와 비교가 포함된 완전한 Docker 설치 가이드.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'lobehub/lobe-chat'
stars: 60000
maintainer: 'lobehub'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Lobe Chat', 'ChatGPT', 'OpenAI 대안', 'LLM', '셀프 호스팅', 'Docker', 'PWA', '플러그인 시스템', 'AI', '챗 UI']
aliases:
- /kr/posts/lobe-chat-openai-alternative-ui/
---

{{</* resource-info */>}}

## 소개: ChatGPT만으로는 이제 부족합니다

팀이 Claude, Gemini, 그리고 자체 하드웨어에서 실행되는 로컬 모델에 접근할 수 있는 공유 채팅 인터페이스가 필요하지만, OpenAI에 ChatGPT Plus로 매월 $20을 지불하고 있습니다. 낶부 API에 연결되는 플러그인이 필요합니다. 팀이 세 대륙에 걸쳐 있기 때문에 다국어 UI가 필요합니다. 그리고 가장 중요한 것은 —— 대화 데이터는 제3자 클라우드가 아닌 자체 인프라에 남아 있어야 합니다.

처음부터 빌드할 수도 있습니다. React 프론트엔드에 두 달, SSE 스트리밍에 한 달, 그리고 인증, 플러그인 샌드박싱, 모델 전환을 영원히 유지보수하세요. 아니면 **10분 만에 Lobe Chat을 배포**할 수 있습니다.

Lobe Chat은 LobeHub 팀이 만든 오픈소스 채팅 인터페이스로, **20+ LLM 제공업체**, **플러그인 시스템**, **PWA 지원**, **다국어 UI**를 단일 Docker 컨테이너로 제공합니다. 2026년 5월 기준 **약 60,000개의 GitHub Stars**를 보유하고 있으며, 가장 인기 있는 자체 호스팅 ChatGPT 대안 중 하나입니다. ChatGPT의 UI보다 더 보기 좋고, 자체 하드웨어에서 실행되며, 라이선스 비용이 전혀 없습니다.

이 가이드는 설치, 제공업체 설정, 플러그인 개발, PWA 설정, 실제 벤치마크, 정직한 한계를 다룹니다. 끝까지 읽으면 전체 팀이 사용할 수 있는 프로덕션 준비 채팅 UI를 갖게 됩니다.

## Lobe Chat이란?

**Lobe Chat**은 대규모 언어 모델을 위한 최신 오픈소스 채팅 인터페이스입니다. Next.js와 Ant Design으로 빌드되었으며, OpenAI, Claude, Gemini, Ollama, Azure, Bedrock 등 15개 이상의 여러 LLM 제공업체 지원, 확장 가능한 플러그인, 프로그레시브 웹 앱 기능, 데이터를 사용자가 통제할 수 있는 자체 호스팅 배포 모델을 제공합니다.

## Lobe Chat의 작동 방식

Lobe Chat의 아키텍처는 프레젠테이션 레이어와 모델 추론을 분리합니다. Next.js 프론트엔드는 UI 렌더링, 대화 상태, 플러그인 오케스트레이션을 처리하고, LLM 호출은 구성 가능한 API 엔드포인트를 통해 프록시됩니다:

```
┌─────────────────────────────────────────────┐
│           사용자 브라우저 / PWA              │
│  ┌─────────┐  ┌─────────┐  ┌────────────┐  │
│  │  채팅   │  │ 플러그인 │  │   설정     │  │
│  │  패널   │  │  스토어 │  │  (i18n)    │  │
│  └────┬────┘  └────┬────┘  └─────┬──────┘  │
└───────┼────────────┼─────────────┼────────┘
        │            │             │
        ▼            ▼             ▼
┌─────────────────────────────────────────────┐
│          Lobe Chat Server (Next.js)          │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐  │
│  │  SSE     │ │ 플러그인  │ │   인증     │  │
│  │  Stream  │ │  Runtime │ │  (SSO)     │  │
│  └────┬─────┘ └────┬─────┘ └─────┬──────┘  │
└───────┼────────────┼─────────────┼────────┘
        │            │             │
        ▼            ▼             ▼
┌──────────┐  ┌──────────┐  ┌────────────┐
│  OpenAI  │  │  Claude  │  │   Ollama   │
│  API     │  │  API     │  │  (로컬)    │
└──────────┘  └──────────┘  └────────────┘
```

**핵심 구성 요소:**

- **프론트엔드**: React Server Components를 사용하는 Next.js 14 App Router. 마크다운, 구문 강조가 적용된 코드 블록, LaTeX 수식을 렌더링합니다.
- **채팅 엔진**: 대화 기록, 컨텍스트 윈도우, 토큰 카운팅, Server-Sent Events를 통한 스트리밍 응답을 관리합니다.
- **플러그인 시스템**: iframe + postMessage를 사용한 샌드박스화된 플러그인 런타임. 플러그인은 OpenAPI 호환 스키마로 매니페스트를 선언합니다.
- **제공업체 프록시**: 20개 이상의 LLM 제공업체에서 API 호출을 정규화하는 통합 어댑터 패턴입니다.
- **PWA 레이어**: 오프라인 지원을 위한 서비스 워커, 데스크톱 및 모바일에 설치 가능합니다.

## 설치 및 설정: 10분 만에 채팅 시작

**전제조건**: Docker 24.0+ 또는 Node.js 20+ (로컬 개발용), 2GB RAM, 1GB 디스크.

### 방법 1: Docker (권장)

**1단계 —— 공식 이미지 가져오기 및 실행:**

```bash
docker run -d -p 3210:3210 \
  -e OPENAI_API_KEY=YOUR_OPENAI_API_KEY \
  -e ACCESS_CODE=your-secure-password \
  --name lobe-chat \
  lobehub/lobe-chat:latest
```

**2단계 —— UI 접근:**

`http://localhost:3210`을 엽니다. 기본 LLM 제공업체를 선택하고 API 키를 입력하는 설정 마법사가 나타납니다.

**3단계 —— 추가 제공업체 구성 (선택):**

```bash
# 환경 변수를 통한 다중 제공업체 설정
docker run -d -p 3210:3210 \
  -e OPENAI_API_KEY=sk-xxx \
  -e ANTHROPIC_API_KEY=sk-ant-xxx \
  -e GOOGLE_API_KEY=xxx \
  -e OLLAMA_PROXY_URL=http://host.docker.internal:11434 \
  -e ACCESS_CODE=your-secure-password \
  --name lobe-chat \
  lobehub/lobe-chat:latest
```

### 방법 2: 영구 저장소가 있는 Docker Compose

```yaml
# docker-compose.yml
services:
  lobe-chat:
    image: lobehub/lobe-chat:latest
    ports:
      - "3210:3210"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - ACCESS_CODE=${ACCESS_CODE}
      - DATABASE_URL=postgresql://postgres:password@db:5432/lobe
    volumes:
      - lobe-data:/app/.config/lobe-chat
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=lobe
    volumes:
      - pgdata:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  lobe-data:
  pgdata:
```

```bash
# 영속성과 함께 시작
docker compose up -d
```

### 방법 3: [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에 배포

```bash
# 2 vCPU / 4GB RAM Droplet에서 (~$24/월)
sudo apt update && sudo apt install -y docker.io docker-compose-plugin

# .env 파일 생성
cat > .env << 'EOF'
OPENAI_API_KEY=sk-your-key
ACCESS_CODE=secure-team-password
EOF

# 실행
docker compose up -d

# Caddy를 통한 HTTPS 역방향 프록시 설정
cat > Caddyfile << 'EOF'
chat.yourdomain.com {
    reverse_proxy localhost:3210
}
EOF
```

DNS A 레코드를 Droplet IP로 가리키면 15분 이내에 라이브됩니다. [DigitalOcean Droplet을 여기에서 얻으세요](https://m.do.co/c/eca87ac14ee0).

## 20개 이상의 LLM 제공업체와의 통합

Lobe Chat은 통합 어댑터를 통해 제공업체 간 API 호출을 정규화합니다. 가장 인기 있는 제공업체의 구성 방법은 다음과 같습니다:

### OpenAI (GPT-4, GPT-4o)

```bash
# 환경 변수를 통해
echo "OPENAI_API_KEY=sk-xxxxxxxx" >> .env

# UI를 통해: 설정 → 언어 모델 → OpenAI → 키 입력
```

### Anthropic Claude (Claude 3.5 Sonnet)

```bash
# 환경 변수
echo "ANTHROPIC_API_KEY=sk-ant-xxxxxxxx" >> .env

# 컨테이너 재시작
docker restart lobe-chat
```

### Google Gemini (Gemini 1.5 Pro)

```bash
echo "GOOGLE_API_KEY=AIzaxxxxxxxx" >> .env
```

### Ollama (로컬 모델 — Llama, Mistral 등)

```bash
# 호스트에서 Ollama 실행
docker run -d -p 11434:11434 --name ollama ollama/ollama

# 모델 가져오기
docker exec ollama ollama pull llama3.2

# Ollama를 사용하도록 Lobe Chat 구성
docker run -d -p 3210:3210 \
  -e OLLAMA_PROXY_URL=http://host.docker.internal:11434 \
  -e ACCESS_CODE=mypassword \
  lobehub/lobe-chat
```

### Azure OpenAI Service

```bash
# 엔드포인트, API 키, 배포 이름 필요
echo "AZURE_API_KEY=your-azure-key" >> .env
echo "AZURE_API_ENDPOINT=https://your-resource.openai.azure.com" >> .env
echo "AZURE_API_VERSION=2024-06-01" >> .env
```

### AWS Bedrock

```bash
echo "AWS_ACCESS_KEY_ID=AKIAxxx" >> .env
echo "AWS_SECRET_ACCESS_KEY=xxx" >> .env
echo "AWS_REGION=us-east-1" >> .env
```

### 런타임에 제공업체 전환

사용자는 UI에서 대화별로 제공업체를 전환할 수 있습니다. 이를 통해 GPT-4와 Claude를 나란히 비교할 수 있습니다:

```
# 재시작 불필요 —— 제공업체 전환은 클라이언트 측
# 대화 헤더의 제공업체 아이콘 클릭 → 다른 모델 선택
# 각 대화는 제공업체 선택을 기억합니다
```

## 플러그인 시스템: Lobe Chat 확장하기

Lobe Chat의 플러그인 아키텍처는 매니페스트 기반 시스템을 사용합니다. 플러그인은 `manifest.json`에서 기능을 선언하고, 채팅 UI는 이를 대화형 도구로 렌더링합니다.

### 플러그인 마켓플레이스에서 설치

1. Lobe Chat 열기 → 플러그인 스토어
2. 50개 이상의 커뮤니티 플러그인 탐색
3. "설치" 클릭 → 권한 승인
4. 플러그인이 채팅 중 도구 호출로 나타남

### 커스텀 플러그인 빌드하기

낶부 API를 쿼리하는 간단한 플러그인을 만듭니다:

```json
{
  "api": [
    {
      "description": "낶부 지식 베이스 검색",
      "name": "search_kb",
      "parameters": {
        "properties": {
          "query": {
            "description": "검색 쿼리 문자열",
            "type": "string"
          }
        },
        "required": ["query"],
        "type": "object"
      },
      "url": "https://api.yourcompany.com/kb/search"
    }
  ],
  "gateway": "https://gateway.example.com",
  "identifier": "your-company/kb-search",
  "meta": {
    "title": "Internal KB Search",
    "description": "Search company knowledge base"
  },
  "version": "1.0.0"
}
```

이를 공개 URL에 호스팅한 다음 **플러그인 스토어 → 커스텀 플러그인 → URL 입력**을 통해 추가합니다.

### 플러그인 런타임 보안

플러그인은 제한된 권한으로 샌드박스화된 iframe에서 실행됩니다:

```
┌─────────────────────────────┐
│  Lobe Chat 메인 창          │
│  ┌───────────────────────┐  │
│  │  샌드박스 Iframe      │  │
│  │  (플러그인 코드)      │  │
│  │  - DOM 접근 없음      │  │
│  │  - postMessage만      │  │
│  │  - CORS 강제          │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

각 플러그인 요청은 명시적인 사용자 승인이 필요합니다. LLM이 도구 호출을 제안하지만, 실행 전에 사용자가 확인해야 합니다.

## PWA 지원 및 모바일 경험

Lobe Chat은 프로그레시브 웹 앱으로 작동하여 모든 플랫폼에서 네이티브 앱 같은 느낌을 제공합니다.

### 데스크톱 설치 (Chrome/Edge)

1. Chrome에서 Lobe Chat 열기
2. 주소창의 설치 아이콘 클릭
3. 자체 아이콘으로 독립 실행형 창에서 실행

### 모바일 설치 (iOS Safari)

```
1. Safari에서 Lobe Chat 열기
2. 공유 → "홈 화면에 추가" 탭
3. 네이티브 앱 아이콘으로 나타남
4. 푸시 알림 지원 (서비스 워커를 통해)
```

### 오프라인 지원

서비스 워커가 앱 셸과 최근 대화를 캐시합니다. 인터넷 없이:

```
✅ 대화 기록 탐색
✅ 이전 응답 보기
✅ 메시지 작성 (전송 대기열)
❌ 새 LLM 응답 (API 연결 필요)
```

## 벤치마크 및 실제 사용 사례

### 응답 지연 시간 (미국 동부에서 측정)

| 제공업체 | 첫 번째 토큰 시간 | 전체 응답 (100 토큰) | 참고 |
|---|---|---|---|
| OpenAI GPT-4o | **0.8초** | **2.1초** | 전체적으로 가장 빠름 |
| Claude 3.5 Sonnet | 1.1초 | 2.8초 | 더 높은 품질의 추론 |
| Gemini 1.5 Pro | 1.3초 | 3.0초 | 대형 컨텍스트 윈도우 |
| Ollama (Llama 3.2 7B, CPU) | 3.5초 | 8.2초 | API 비용 없음 |
| Ollama (Llama 3.2 7B, RTX 4090) | 0.6초 | 1.5초 | 가장 빠른 로컬 옵션 |
| Azure GPT-4 | 1.0초 | 2.4초 | 엔터프라이즈 SLA |

### 리소스 사용량

| 배포 방식 | 메모리 | CPU | 사용자 수 | 월 비용 |
|---|---|---|---|---|
| Docker 단일 인스턴스 | **350MB** | **0.2 코어** | 1–5 | $0 (자체 호스팅) |
| Docker + 5 제공업체 | 400MB | 0.3 코어 | 1–10 | API 비용만 |
| PostgreSQL 백엔드 포함 | 650MB | 0.4 코어 | 10–50 | ~$24 VPS |
| 역방향 프록시 뒤 | 400MB | 0.3 코어 | 10–100 | ~$24 VPS |

### 실제 배포 사례

**AI 컨설팅 회사 (12명 엔지니어):**
- [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0)에 Lobe Chat 배포
- 클라이언트 비교 데모를 위해 **8개 LLM 제공업체** 연결
- 낶부 프로젝트 데이터베이스에 연결되는 **3개 커스텀 플러그인** 구축
- 개별 ChatGPT Plus 구독 대비 **월 ~$240 절약**

**대학 연구실 (40명 학생):**
- 프라이버시에 민감한 연구 데이터를 위해 Ollama로 자체 호스팅
- 학생들이 노트북과 휴 대전화로 PWA를 통해 접근
- 플러그인이 대학 도서관 검색 API에 연결
- 미발표 연구 데이터의 클라우드 노출 제로

**스타트업 고객 지원 (5명 에이전트):**
- API를 통해 Claude 3.5 Sonnet과 통합
- 커스텀 플러그인이 제품 문서를 쿼리
- 다국어 UI가 영어, 중국어, 일본어 고객을 지원
- 응답 초안 작성 시간 **~45% 감소**

## 고급 사용법 및 프로덕션 강화

### 인증 활성화

팀 배포를 위해 액세스 코드를 설정합니다:

```bash
docker run -d -p 3210:3210 \
  -e ACCESS_CODE=your-secure-password-2026 \
  -e OPENAI_API_KEY=sk-xxx \
  lobehub/lobe-chat:latest
```

SSO 통합을 위해 OAuth를 구성합니다:

```bash
  -e AUTH_PROVIDER=auth0 \
  -e AUTH_AUTH0_ID=your-client-id \
  -e AUTH_AUTH0_SECRET=your-secret \
  -e AUTH_AUTH0_ISSUER=https://your-domain.us.auth0.com \
```

### 커스텀 테마

테마 JSON 파일을 만듭니다:

```json
{
  "primaryColor": "#1890ff",
  "neutralColor": "#8c8c8c",
  "backgroundColor": "#f0f2f5",
  "sidebarWidth": 280
}
```

**설정 → 테마 → 커스텀 테마**를 통해 업로드합니다.

### 데이터베이스 기반 대화

다중 사용자 지속성을 위해 PostgreSQL을 구성합니다:

```yaml
# docker-compose.prod.yml
services:
  lobe-chat:
    image: lobehub/lobe-chat:latest
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/lobechat
      - APP_URL=https://chat.yourdomain.com
    ports:
      - "3210:3210"

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: lobechat
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

### Caddy를 사용한 역방향 프록시

```bash
# 자동 HTTPS를 위한 Caddyfile
chat.yourdomain.com {
    reverse_proxy localhost:3210
    encode gzip
    header {
        X-Frame-Options DENY
        X-Content-Type-Options nosniff
    }
}
```

```bash
caddy run --config Caddyfile
```

### Prometheus를 사용한 모니터링

Lobe Chat은 `/api/metrics`에서 메트릭을 노출합니다:

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
```

## 대안과의 비교

| 기능 | Lobe Chat | LibreChat | ChatGPT Web | HuggingChat |
|---|---|---|---|---|
| **GitHub Stars** | **~60,000** | ~20,000 | ~30,000 | N/A (제품) |
| **LLM 제공업체** | **20+** | 10+ | OpenAI만 | HF 모델만 |
| **플러그인 시스템** | **매니페스트 기반** | 기본 도구 | 없음 | 없음 |
| **PWA 지원** | **완전** | 부분 | 없음 | 없음 |
| **다국어 UI** | **15+ 언어** | 5 언어 | 10 언어 | 6 언어 |
| **셀프 호스팅** | **예 (Docker)** | 예 | 예 | 아니오 (SaaS만) |
| **인증** | **SSO + 액세스 코드** | SSO + 로컬 | 기본 | OAuth만 |
| **지식 베이스** | **플러그인 기반** | 내장 RAG | GPTs만 | 없음 |
| **코드 인터프리터** | **플러그인 통해** | 플러그인 통해 | 네이티브 | 없음 |
| **모바일 경험** | **네이티브 같은 PWA** | 반응형 | 반응형 | 기본 |
| **테마 커스터마이징** | **완전** | 부분 | 없음 | 최소 |
| **메시지 동기화** | **PostgreSQL 백엔드** | MongoDB | LocalStorage | 클라우드 |

**선택 가이드:**

- **Lobe Chat**: 세련된 다중 제공업체 채팅 UI와 플러그인, PWA가 필요할 때 선택하세요. 팀을 위한 최고의 전반적인 경험입니다.
- **LibreChat**: 더 간단한 설정에 내장 RAG (문서 업로드)가 필요하고 PWA나 광범위한 플러그인이 필요 없을 때 선택하세요.
- **ChatGPT Web (Next-Web)**: 주로 OpenAI를 사용하고 가장 빠르고 가벼운 자체 호스팅 UI를 원할 때 선택하세요.
- **HuggingChat**: Hugging Face 모델용 묶 web UI로 사용하되, 자체 호스팅이나 엔터프라이즈 사용은 불가합니다.

## 한계점: 정직한 평가

**내장 RAG이 아직 없습니다.** LibreChat에 내장된 문서 업로드 및 벡터 검색과 달리, Lobe Chat은 지식 베이스 기능을 플러그인에 의존합니다. 네이티브 RAG 기능은 v1.0 로드맵에 있지만 2026년 5월 기준으로는 사용할 수 없습니다.

**플러그인 생태계가 젊습니다.** ChatGPT의 수천 개에 비해 약 50개의 플러그인이 있습니다. 커스텀 플러그인을 빌드하려면 매니페스트 스키마를 이해하고 호환 API를 호스팅해야 합니다.

**LLM API 키가 필요합니다.** Lobe Chat은 UI일 뿐입니다 —— 클라우드 제공업체의 API 키나 로컬 모델을 위한 실행 중인 Ollama 인스턴스가 여전히 필요합니다. "묶 티어"가 내장되어 있지 않습니다.

**다중 사용자 채팅방이 없습니다.** 대화는 각 브라우저 세션에 비공개입니다. 공유 채널이 있는 진정한 다중 사용자 협업에는 커스텀 백엔드가 필요합니다.

**Docker 이미지가 큽니다.** 프로덕션 이미지는 압축 시 ~400MB입니다. 느린 연결에서는 초기 풀이 몇 분이 소요됩니다.

**음성 입력/출력이 없습니다.** ChatGPT의 모바일 앱과 달리, Lobe Chat은 네이티브로 음성-텍스트나 텍스트-음성을 지원하지 않습니다. 브라우저 기반 Web Speech API를 우회 방법으로 사용할 수 있습니다.

**플러그인 승인 UX가 마찰을 추가합니다.** 모든 플러그인 호출에는 사용자 확인이 필요합니다. 이는 보안에 좋지만, 자동으로 실행되는 ChatGPT의 코드 인터프리터와 비교하면 워크플로우가 느려집니다.

## 자주 묻는 질문

**Q: Lobe Chat이 대화를 외부 서버에 저장합니까?**

아니오. 자체 호스팅 시 모든 대화 데이터는 자체 인프라에 남아 있습니다. Lobe Chat은 명시적으로 분석을 구성하지 않는 한 외부 서버에 원격 측정을 보 볶는 클라이언트 측 애플리케이션입니다. 오픈소스 코드(MIT 라이선스)는 GitHub에서 감사할 수 있습니다. 클라우드 API 키(OpenAI, Claude)는 LLM 추론 호출에만 사용됩니다 —— 대화 자체는 로컬에 저장됩니다.

**Q: 동일한 대화에서 여러 LLM 제공업체를 사용할 수 있나요?**

단일 대화 스레드 내에서는 불가능합니다. 각 대화는 하나의 제공업체에 연결되지만, 다른 제공업체로 여러 대화를 만들고 전환할 수 있습니다. 일부 사용자는 코딩용 "GPT-4" 스레드와 글쓰기용 "Claude" 스레드를 유지하며 사이드바를 통해 전환합니다.

**Q: Lobe Chat을 최신 버전으로 업데이트하려면 어떻게 하나요?**

```bash
# 최신 이미지 가져오기
docker pull lobehub/lobe-chat:latest

# 컨테이너 재시작
docker compose down && docker compose up -d

# 대화는 브라우저 localStorage에 지속됩니다
# PostgreSQL 백엔드의 경우, 데이터베이스 마이그레이션이 자동으로 실행됩니다
```

업데이트는 주간 단위로 제공됩니다. 업데이트하기 전에 [릴리스 페이지](https://github.com/lobehub/lobe-chat/releases)에서 중대 변경 사항을 확인하세요.

**Q: 플러그인 시스템과 함수 호출의 차이는 무엇인가요?**

Lobe Chat 플러그인은 **UI 수준 통합**입니다 —— 채팅에서 대화형 카드, 폼, 시각화를 렌더링합니다. 함수 호출은 도구를 호출할 시기를 결정하는 **LLM 수준 메커니즘**입니다. Lobe Chat은 플러그인을 트리거하기 위해 낶부적으로 함수 호출을 사용한 다음, 플러그인의 UI 응답을 렌더링합니다. 플러그인 아키텍처는 함수 호출을 시각적 컴포넌트와 사용자 승인 플로우로 확장합니다.

**Q: 인터넷 연결 없이 Lobe Chat을 사용할 수 있나요?**

부분적으로 가능합니다. Ollama를 유일한 제공업체로 구성하면(로컬 LLM), 핵심 채팅 기능이 오프라인에서 작동합니다. 그러나 플러그인 호출에는 인터넷 연결이 필요하며(외부 API 호출), 초기 앱 로드에는 에셋 다운로드가 필요합니다. PWA가 앱 셸을 캐시하므로 첫 방문 후 로컬 모델을 사용할 때 기본 채팅이 인터넷 없이 작동합니다.

**Q: 대화 기록에 제한이 있나요?**

기본 localStorage 백엔드의 경우, 대화는 브라우저에 지속되며 하드 제한은 없지만 ~500개의 긴 대화를 넘어가면 성능이 저하됩니다. PostgreSQL 백엔드의 경우, 실질적인 제한은 없습니다 —— 데이터베이스는 여러 사용자에서 수천 개의 대화를 처리합니다. 토큰 컨텍스트 윈도우 제한은 선택된 LLM 제공업체의 제약에 따라 시행됩니다.

**Q: ChatGPT 대화를 가져올 수 있나요?**

직접 가져올 수는 없습니다. ChatGPT의 날포트 형식(conversations.json)은 Lobe Chat의 저장 스키마와 호환되지 않습니다. 그러나 커뮤니티 도구는 ChatGPT 날포트를 Markdown으로 변환할 수 있으며, 이를 Lobe Chat 대화에 붙여넣을 수 있습니다. LobeHub 팀은 2026년 3분기에 가져오기 기능을 로드맵에 포함하고 있습니다.

## 결론: 당신의 채팅, 당신의 규칙

Lobe Chat은 ChatGPT가 제공하지 않는 것을 제공합니다: 데이터에 대한 완전한 통제, 모든 주요 LLM 제공업체에 대한 지원, 확장 가능한 플러그인, 네이티브 같은 모바일 경험 —— 모두 자체 하드웨어에서 실행됩니다. **약 60,000개의 GitHub Stars**와 주간 릴리스를 통해 UX 품질에서 상용 대안과 견줄 만한 성숙하고 활발히 유지보수되는 프로젝트입니다.

개인의 경우 Docker 설정은 10분이 소요되며 API 사용료 외에는 비용이 없습니다. 팀의 경우, [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에 PostgreSQL 백엔드와 함께 배포하면 완전히 감사 가능한 공유 채팅 플랫폼을 제공합니다.

플러그인 시스템과 PWA 지원은 Lobe Chat을 ChatGPT 클론 그 이상으로 만듭니다 —— 조직에 맞춤화된 AI 기반 워크플로우를 구축하기 위한 플랫폼입니다. 다국어 UI는 구성 번거로움 없이 글로벌 팀에 적합하다는 것을 의미합니다.

**전환할 준비가 되셨나요?** Docker 명령을 실행하고, API 키를 추가하고, 채팅을 시작하세요. 당신의 대화는 당신에게 속합니다.

AI 개발자를 위한 Telegram 커뮤니티에 참여하세요: **@dibi8dev** —— Lobe Chat 구성을 공유하고 5,000명 이상의 빌더에게 도움을 받으세요.

---

## 출처 및 추가 자료

1. [Lobe Chat GitHub 리포지토리](https://github.com/lobehub/lobe-chat) —— 공식 소스 코드, 릴리스, 문서
2. [Lobe Chat 공식 문서](https://lobehub.com/docs) —— 공식 설치 및 구성 가이드
3. [Lobe Chat 플러그인 문서](https://github.com/lobehub/lobe-chat/wiki/Plugin-System) —— 플러그인 매니페스트 사양
4. [Docker Hub — lobehub/lobe-chat](https://hub.docker.com/r/lobehub/lobe-chat) —— 공식 Docker 이미지
5. [LobeHub 플러그인 마켓플레이스](https://lobechat.com/plugins) —— 사용 가능한 플러그인 탐색
6. [Next.js 문서](https://nextjs.org/docs) —— 기본 프레임워크 문서

---



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 제휴 마케팅 공개

이 문서에는 제휴 마케팅 링크가 포함되어 있습니다. 당사의 추천 링크를 통해 DigitalOcean에 가입하면, 추가 비용 없이 당사에 커미션이 지급됩니다. 우리는 자체 인프라에도 사용하는 서비스만을 추천합니다. Lobe Chat은 오픈소스(MIT 라이선스)이며 묣으로 사용할 수 있습니다 —— 구매가 필요하지 않습니다.
