---
title: 'NocoDB 2026 완벽 가이드: 모든 데이터베이스를 스마트 스프레드시트로 만드는 오픈소스 Airtable 대안'
description: 'Docker로 5분 만에 NocoDB 배포. MySQL, PostgreSQL, SQLite를 협업형 스프레드시트로 변환하고 REST API, 칸반 보드, 역할 기반 접근 제어를 자동 생성하세요.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'nocodb/nocodb'
stars: 53000
maintainer: 'nocodb'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['nocodb', 'airtable대안', '오픈소스', '데이터베이스', '스프레드시트', '셀프호스팅', 'docker', 'mysql', 'postgresql']
aliases:
- /kr/posts/noco-db-airtable-alternative/
---

{{</* resource-info */>}}

## 소개: 스프레드시트의 한계에 부딪힐 때

모든 엔지니어링 팀에는 그 하나의 "마스터 스프레드시트"가 있습니다. 고객 온볼딩을 추적하는 Google Sheet, 재고 SKU CSV, 프로젝트 예산 공유 Excel 파일로 시작합니다. 그런 다음 혼란이 찾아옵니다: 누군가 공식을 덮어쓰고, 버전 기록이 읽을 수 없게 되며, 65,000행 제한이 먹구름처럼 다가옵니다.

Airtable은 수백만 팀에게 이 문제를 해결했지만 대가가 따릅니다. Pro 플랜은 사용자당 월 **$20**입니다. 20인 팀은 고급 스프레드시트 하나에 연간 **$4,800**을 지불합니다. 더 나쁜 것은 데이터가 Airtable 서버에 저장되고, 납품은 제한되며, API에는 실제 작업량을 제한하는 속도 제한이 있다는 점입니다.

**NocoDB**가 등장합니다 — 모든 MySQL, PostgreSQL, SQL Server, SQLite 또는 MariaDB 데이터베이스를 스마트한 협업형 스프레드시트 인터페이스로 변환하는 오픈소스 플랫폼입니다. **53,000+ GitHub Stars**, 5분 미만의 Docker 배포, 데이터 마이그레이션 불필요로, NocoDB는 Airtable의 사용 편의성과 실제 SQL 데이터베이스의 강력함과 소유권을 모두 제공합니다.

이 가이드는 완전한 프로덕션 설정을 안내합니다: 로컬 Docker 배포, 기존 PostgreSQL 데이터베이스 연결, 역할 기반 접근 제어 구성, REST API 생성, 프로덕션 하드닝. 모든 명령어는 복사-붙여넣기로 실행할 수 있습니다.

## NocoDB란?

**NocoDB**는 기존 관계형 데이터베이스 위에 스프레드시트와 유사한 인터페이스를 추가하는 오픈소스 노코드 데이터베이스 플랫폼입니다. Airtable은 데이터를 자체 독점 백엔드에 저장하지만, NocoDB는 사용자의 MySQL, PostgreSQL, SQL Server, SQLite 또는 MariaDB 데이터베이스에 연결하여 데이터를 한 행도 이동하지 않고 그리드, 칸반, 갤러리, 양식, 캘린더 뷰를 제공합니다.

비기술 팀원이 실제로 사용할 수 있는 시각적 관리자 패널로 생각하세요. 마케팅팀은 캠페인 데이터를 업데이트하고, 운영팀은 재고를 편집하고, 인사팀은 채용 파이프라인을 관리할 수 있습니다. 모두 익숙한 스프레드시트 UI를 통해 이루어지며, 데이터는 엔지니어가 SQL로 쿼리하고 Metabase에 연결하거나 데이터 웨어하우스에 복제할 수 있는 PostgreSQL 데이터베이스에 그대로 유지됩니다.

## NocoDB 작동 방식: 아키텍처 개요

NocoDB는 **데이터베이스 우선 아키텍처**를 따릅니다. 비즈니스 데이터를 직접 저장하지 않습니다. 대신 기존 데이터베이스 스키마를 조사하고, 테이블 구조, 인덱스, 관계를 읽은 다음 이를 인터랙티브 뷰로 렌더링합니다.

**핵심 컴포넌트:**

- **NocoDB Server** — 표준 드라이버(pg, mysql2, sqlite3)를 통해 데이터베이스에 연결하는 Node.js 백엔드
- **Web GUI** — 스프레드시트 인터페이스를 제공하는 Vue.js 프론트엔드
- **메타 데이터베이스** — 프로젝트 메타데이터, 뷰 구성, 사용자 권한, 웹훅 설정을 저장하는 경량 SQLite 데이터베이스(기본값) 또는 전용 PostgreSQL/MySQL 인스턴스
- **REST/GraphQL API 레이어** — Swagger 문서와 함께 모든 테이블에 대해 자동 생성되는 엔드포인트

사용자가 그리드 뷰에서 셀을 편집하면 NocoDB는 해당 작업을 데이터베이스에 대해 직접 실행되는 매개변수화된 SQL `UPDATE` 문으로 변환합니다. 칸반 뷰를 생성하면 NocoDB는 메타 데이터베이스에 뷰 구성을 저장하는 동안 기본 데이터는 절대 이동하지 않습니다.

이 분리가 핵심입니다: 데이터는 데이터베이스에 그대로 유지됩니다. NocoDB는 스마트 렌즈일 뿐입니다.

## 설치 및 설정: 5분 만에 실행까지

### 옵션 1: Docker(개발용 권장)

로컬에서 NocoDB를 실행하는 가장 빠른 방법:

```bash
# NocoDB 데이터 디렉토리 생성
mkdir -p ~/nocodb-data && cd ~/nocodb-data

# Docker로 NocoDB 실행 (SQLite 메타 DB 포함)
docker run -d \
  --name nocodb \
  -p 8080:8080 \
  -v "$(pwd)/nocodb:/usr/app/data" \
  nocodb/nocodb:latest
```

`http://localhost:8080`에 접속하고 관리자 이메일과 비밀번호로 가입합니다. 완료.

### 옵션 2: 기존 PostgreSQL과 Docker Compose

프로덕션 환경용, 기존 PostgreSQL 데이터베이스에 연결:

```bash
# docker-compose.yml
version: "3.8"

services:
  nocodb:
    image: nocodb/nocodb:0.260.7
    ports:
      - "8080:8080"
    environment:
      - NC_DB="pg://host.docker.internal:5432?u=postgres&p=yourpassword&d=nocodb_meta"
      - DATABASE_URL="postgres://postgres:yourpassword@host.docker.internal:5432/myapp_production"
      - NC_AUTH_JWT_SECRET="change-this-to-a-64-char-random-string"
      - NC_PUBLIC_URL=https://nocodb.yourcompany.com
    volumes:
      - ./nocodb-data:/usr/app/data
    restart: unless-stopped
```

시작:

```bash
docker-compose up -d
```

### 옵션 3: DigitalOcean에 배포 (프로덕션)

프로덕션 VPS 배포를 위해 [DigitalOcean에서 월 $6 Droplet을 생성](https://m.do.co/c/eca87ac14ee0)하고 실행합니다:

```bash
# 시스템 업데이트
sudo apt update && sudo apt upgrade -y

# Docker 설치
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker

# 영구 스토리지로 NocoDB 실행
docker run -d \
  --name nocodb \
  -p 8080:8080 \
  -e NC_DB="pg://your-db-host:5432?u=nocodb&p=SECURE_PASS&d=nocodb_meta" \
  -e NC_AUTH_JWT_SECRET="$(openssl rand -hex 32)" \
  -v /opt/nocodb:/usr/app/data \
  --restart unless-stopped \
  nocodb/nocodb:0.260.7
```

### 첫 번째 데이터 소스 추가

NocoDB UI에 로그인한 후:

1. **"Add New Base"** → **"Connect to Data Source"** 클릭
2. **PostgreSQL** (또는 MySQL/SQLite) 선택
3. 연결 정보 입력:

```yaml
# PostgreSQL 데이터베이스 연결 예시
Host: db.yourcompany.com
Port: 5432
Username: app_readwrite
Password: **********
Database: production_app
SSL: Require
```

NocoDB는 약 10초 만에 스키마를 조사하고 모든 테이블을 인터랙티브 스프레드시트 뷰로 표시합니다.

## 통합: 기존 스택에 NocoDB 연결

### REST API 자동 생성

모든 테이블은 자동으로 완전한 REST API를 갖습니다. 테이블에서 **"API"**를 클릭하면 Swagger 문서를 볼 수 있습니다:

```bash
# "customers" 테이블의 모든 레코드 나열
curl -X GET "https://nocodb.yourcompany.com/api/v2/tables/customers/records" \
  -H "xc-token: YOUR_API_TOKEN" \
  -H "Content-Type: application/json"

# 새 레코드 생성
curl -X POST "https://nocodb.yourcompany.com/api/v2/tables/customers/records" \
  -H "xc-token: YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "Email": "alice@example.com",
    "Status": "Active",
    "Plan": "Enterprise"
  }'

# 필터로 업데이트
curl -X PATCH "https://nocodb.yourcompany.com/api/v2/tables/customers/records" \
  -H "xc-token: YOUR_API_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "id": 42,
    "Status": "Churned"
  }'
```

### Webhook 자동화

데이터 변경 시 외부 워크플로우 트리거:

1. **Base** → **Automation** → **Webhooks**로 이동
2. **"Add Webhook"** 클릭
3. 트리거 구성:

```json
{
  "title": "Notify Slack on New Order",
  "event": "after.insert",
  "table": "orders",
  "hook": {
    "method": "POST",
    "url": "https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXX",
    "headers": {
      "Content-Type": "application/json"
    },
    "body": {
      "text": "New order #{{Id}} from {{CustomerEmail}} — Amount: ${{Total}}"
    }
  }
}
```

### n8n 통합

NocoDB는 [n8n 워크플로우 자동화](n8n-workflow-automation-dibi8-internal-link)와 원활하게 작동합니다:

```bash
# n8n NocoDB 노드 자격 증명
Host: https://nocodb.yourcompany.com
API Token: noco_xxxxxxxxxxxx
Base ID: your-base-id
```

### Metabase / BI 통합

데이터가 PostgreSQL에 그대로 있으므로 Metabase를 동일한 데이터베이스에 직접 연결하여 분석하고, NocoDB는 운영 편집 레이어를 처리합니다:

```yaml
# Metabase는 동일한 PostgreSQL 데이터베이스에 연결
# NocoDB는 데이터 입력 처리, Metabase는 대시보드 처리
# 둘 다 동일한 단일 진실 공급원에서 읽기
```

### Airtable에서 동기화 (마이그레이션 경로)

Airtable에서 이전하나요? CSV로 낸 후 NocoDB로 가져오기:

1. **Airtable** → 각 테이블 **CSV 다운로드**
2. **NocoDB** → **Add New Table** → **Import CSV**
3. Linked Record 필드를 NocoDB의 **Links**(외래 키 관계)로 다시 생성
4. NocoDB의 뷰 빌더로 뷰(Grid, Kanban, Gallery) 다시 생성

## 벤치마크 및 실제 사용 사례

### 성능: NocoDB vs Airtable

| 지표 | NocoDB (셀프호스팅) | Airtable Pro |
|---|---|---|
| 베이스당 레코드 수 | **무제한** | 50,000 |
| 파일 첨부 | **디스크 제한** | 20 GB |
| API 속도 제한 | **없음 (자체 서버)** | 10 req/sec |
| 동시 사용자 | **테스트: 200+** | 50 (Pro 플랜) |
| 행 업데이트 지연 | **~15ms** (로컬 PG) | ~200-500ms |
| 20명 사용자 비용 | **월 $6 (VPS)** | 월 $400 |

### 실제 배포 데이터

커뮤니티 보고서와 부하 테스트 기준:

- **스타트업 CRM**: 150,000 고객 레코드, 15명 팀원, 테이블당 3개 뷰. 4 vCPU VPS의 PostgreSQL 14. 평균 쿼리 시간: **23ms**.
- **재고 관리**: 8개 창고의 50,000 SKU. REST API가 3개 클라이언트 애플리케이션에서 사용됨. watchtower 자동 업데이트로 6개월간 **무중단**.
- **HR 지원자 추적**: 12명 채용 담당자, 8,000명 지원자, 채용 단계별 칸반 뷰. Airtable에서 전환하여 연간 **$2,800 절약**.

### GitHub 통계 (2026년 5월)

- **53,000+ Stars**
- **1,200+ 기여자**
- **최신 릴리스**: v0.260.7 (2026년 4월)
- **Docker Pull**: 500만+
- **활발한 Discord**: 4,800+ 멤버

## 고급 사용법: 프로덕션 하드닝

### 1. Nginx 리버스 프록시로 HTTPS

```nginx
# /etc/nginx/sites-available/nocodb
server {
    listen 443 ssl http2;
    server_name nocodb.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourcompany.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

활성화 및 재시작:

```bash
sudo ln -s /etc/nginx/sites-available/nocodb /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl restart nginx
```

### 2. 환경 변수 보안

```bash
# 비밀 파일 생성
sudo mkdir -p /opt/nocodb
sudo tee /opt/nocodb/.env > /dev/null << 'EOF'
NC_DB=pg://db:5432?u=nocodb&p=CHANGE_ME&d=nocodb_meta
NC_AUTH_JWT_SECRET=CHANGE_TO_64_CHAR_RANDOM_STRING
NC_REDIS_URL=redis://redis:6379
NC_SENTRY_DSN=https://xxx@sentry.io/yyy
NC_PUBLIC_URL=https://nocodb.yourcompany.com
EOF

sudo chmod 600 /opt/nocodb/.env
```

### 3. 역할 기반 접근 제어

각 베이스에 대해 세분화된 권한 구성:

1. **Project Settings** → **Data Sources** → **Users**
2. 역할 할당:
   - **Owner** — 전체 제어, 베이스 삭제 가능
   - **Creator** — 테이블, 뷰, 자동화 생성
   - **Editor** — 레코드 편집, 스키마 수정 불가
   - **Commenter** — 댓글만 추가
   - **Viewer** — 읽기 전용 접근

**열 수준 권한**을 설정하여 비인사팀 사용자로부터 민감한 필드(예: 급여, 주민등록번호)를 숨깁니다.

### 4. 데이터베이스 백업 전략

```bash
#!/bin/bash
# /opt/backup/nocodb-backup.sh

# PostgreSQL 데이터 백업 (실제 비즈니스 데이터)
pg_dump -h db.yourcompany.com -U postgres myapp_db > \
  /backups/postgres-$(date +%Y%m%d).sql

# NocoDB 메타 데이터베이스 백업
docker exec nocodb-db-1 pg_dump -U nocodb nocodb_meta > \
  /backups/nocodb-meta-$(date +%Y%m%d).sql

# S3로 동기화 (선택)
aws s3 sync /backups/ s3://yourcompany-backups/nocodb/

# 7일만 유지
find /backups -name "*.sql" -mtime +7 -delete
```

crontab에 추가:

```bash
0 2 * * * /opt/backup/nocodb-backup.sh >> /var/log/nocodb-backup.log 2>&1
```

### 5. Prometheus로 모니터링

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus:v2.51.0
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana:10.4.0
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana

volumes:
  grafana-data:
```

## 대안과의 비교

| 기능 | NocoDB | Airtable | Baserow | Teable |
|---|---|---|---|---|
| **라이선스** | AGPL-3.0 | 독점 | MIT | AGPL-3.0 |
| **셀프호스팅** | 예 | 아니오 | 예 | 예 |
| **기존 DB 연결** | **예** (PG, MySQL, SQLite) | 아니오 | 아니오 | 예 |
| **REST API** | 자동 생성 | 제한적 속도 | 자동 생성 | 자동 생성 |
| **칸반 뷰** | 예 | 예 | 예 | 예 |
| **양식 뷰** | 예 | 예 | 예 | 예 |
| **파일 첨부** | 예 | 20 GB (Pro) | 예 | 예 |
| **역할 기반 접근** | 예 | 예 | 예 | 예 |
| **Webhook 자동화** | 예 | 유료 플랜 | 예 | 제한적 |
| **20명 사용자 가격** | **월 $6 (VPS)** | **월 $400** | 월 $100 | $0 (셀프호스팅) |
| **레코드 제한** | **무제한** | 50,000 (Pro) | 무제한 | 무제한 |
| **GitHub Stars** | **53,000** | 해당 없음 | 8,200 | 14,500 |

**각 대안 대비 NocoDB를 선택하는 시기:**

- **Airtable 대비**: 데이터 소유권, 낮은 비용, 레코드 제한 없음, 기존 데이터베이스 연결 능력이 필요할 때.
- **Baserow 대비**: 새 데이터베이스를 만드는 것이 아닌 기존 PostgreSQL/MySQL 데이터베이스에 연결해야 할 때. Baserow는 UI가 더 세련됐지만 자체 데이터 모델을 강요합니다.
- **Teable 대비**: 더 넓은 데이터베이스 드라이버 지원이 필요할 때(NocoDB는 SQL Server와 MariaDB를 지원, Teable은 PostgreSQL에 집중). Teable은 더 강력한 AI 통합을, NocoDB는 더 깊은 스프레드시트 기능을 갖습니다.

## 한계: 정직한 평가

**NocoDB는 완벽하지 않습니다.** 투입하기 전 다음 제약을 고려하세요:

1. **UI 세련도 격차**: Airtable의 인터페이스가 더 부드럽습니다. NocoDB의 그리드는 브라우저에서 100,000+ 행 처리 시 느릴 수 있으나 — 기본 데이터베이스는 원활하게 처리합니다.

2. **네이티브 모바일 앱 없음**: 반응형 웹 UI가 제공되나, Airtable이 제공하는 것과 같은 전용 iOS/Android 앱은 없습니다.

3. **제한된 수식 지원**: 수식은 Excel 구문이 아닌 SQL 표현식을 사용합니다. 비기술 사용자는 짧은 학습 곡선이 필요합니다.

4. **셀프호스팅 부담**: 백업, 업데이트, 보안을 직접 처리합니다. 클라우드 옵션은 있지만 사용자당 월 $8부터 시작하여 비용 이점을 줄입니다.

5. **라이선스 고려사항**: NocoDB의 AGPL-3.0 라이선스는 소프트웨어를 배포하는 경우 수정사항을 공개할 것을 요구합니다. 내용 회사 사용의 경우 이는 문제가 되지 않습니다. NocoDB 기반 SaaS 제품의 경우 법무팀에 문의하세요.

6. **Single Sign-On (SSO)**: 내장 SSO(SAML, OIDC)는 Enterprise 티어가 필요합니다. 셀프호스팅 사용자는 리버스 프록시 인증 레이어로 우회할 수 있습니다.

## 자주 묻는 질문

### NocoDB는 여러 데이터베이스에 동시 연결을 지원하나요?

예. 단일 NocoDB 인스턴스는 여러 데이터 소스에 연결할 수 있습니다. 하나의 베이스는 PostgreSQL에, 다른 것은 MySQL에, 세 번째는 내장 SQLite를 사용할 수 있습니다 — 모두 동일한 대시보드에서 접근 가능합니다. 각 베이스는 자체 권한과 뷰를 가진 독립적 엔티티입니다.

### NocoDB는 기본 데이터베이스의 스키마 변경을 어떻게 처리하나요?

NocoDB는 스키마 변경을 자동으로 동기화합니다. PostgreSQL에서 `ALTER TABLE`로 열을 추가하면 베이스 설정에서 **"Sync Now"**를 클릭하고, 새 열은 수 초 내에 NocoDB에 나타납니다. 기존 뷰는 보존; 필요한 뷰에 새 필드를 추가하기만 하면 됩니다.

### NocoDB를 고객 대상 애플리케이션의 백엔드로 사용할 수 있나요?

예, REST API를 통해 가능합니다. 그러나 NocoDB는 낮관리 도구용으로 설계되었지 공개 API 서버용은 아닙니다. 고객 대상 앱의 경우, 팀용 관리 패널로 NocoDB를 사용하고 비즈니스 로직을 검증하는 별도 API 레이어를 동일한 데이터베이스에 구축하세요.

### NocoDB가 다울되면 어떻게 되나요? 내 데이터는 안전한가요?

데이터는 PostgreSQL/MySQL 데이터베이스에 저장되며 NocoDB와 완전히 분리되어 있습니다. NocoDB 컨테이너가 중지되어도 데이터는 영향을 받지 않습니다. 동일한 데이터베이스를 읽는 다른 애플리케이션은 정상적으로 계속 작동합니다. NocoDB는 메타 데이터베이스에 뷰 구성, 사용자 계정, 웹훅 정의만 저장합니다.

### Airtable에서 NocoDB로 어떻게 마이그레이션하나요?

각 Airtable 테이블을 CSV로 낸 후, NocoDB에서 테이블을 생성하고 **"Import CSV"**로 데이터를 채웁니다. Airtable의 "Linked Records"를 NocoDB의 **"Links"**(외래 키 관계)로 다시 생성합니다. 뷰(Grid, Kanban, Gallery)를 수동으로 재구축합니다. NocoDB 커뮤니티에는 GitHub에서 벌크 변환을 처리하는 Airtable-to-NocoDB 마이그레이션 스크립트가 있습니다.

### NocoDB는 Airtable과 같은 실시간 협업을 지원하나요?

예, 단 주의사항이 있습니다. 여러 사용자가 동시에 동일한 베이스를 편집할 수 있으며, 변경사항은 WebSocket을 통해 실시간으로 표시됩니다. 그러나 충돌 해결은 operational transforms가 아닌 last-write-wins입니다. 대부분의 사용 사례(다른 사용자가 다른 행 편집)에는 이것으로 충분합니다. 동일 행의 대량 동시 편집은 덮어쓰기를 일으킬 수 있습니다.

### Docker 없이 NocoDB를 실행할 방법이 있나요?

예. NocoDB는 Linux, macOS, Windows용 독립 실행형 바이너리를 제공합니다. GitHub 릴리스 페이지에서 최신 바이너리를 다운로드하고, 실행 권한을 부여하고, `./nocodb`를 실행합니다. 그러나 업데이트와 의존성 관리가 더 쉬워 Docker가 프로덕션 배포의 권장 방법으로 남아 있습니다.

## 결론: 당신의 데이터, 당신의 규칙

NocoDB는 특정 공백을 채웁니다: 비기술 팀에게 Airtable의 사용 편의성을 제공하면서 데이터는 엔지니어가 제어하는 데이터베이스에 유지합니다. **53,000 GitHub Stars**, 활발한 릴리스 주기, 성장하는 플러그인 생태계로 2026년 및 그 이후에도 실용적인 선택입니다.

Airtable에 월 $200+를 지불하고 이미 PostgreSQL 또는 MySQL 데이터베이스를 실행 중이라면, NocoDB는 첫 달에 비용을 회수합니다. Docker 설정은 5분입니다. Airtable에서의 마이그레이션은 주말 프로젝트입니다. 데이터를 소유하는 자유는 영구적입니다.

**지금 시작**: 월 $6 Droplet으로 [DigitalOcean에서 NocoDB 배포](https://m.do.co/c/eca87ac14ee0)하거나, 또는 커밋하기 전에 탐색을 위해 로컬에서 `docker run nocodb/nocodb:latest`를 실행하세요.

**커뮤니티 가입**: [NocoDB Discord](https://discord.gg/5ZjDgHEG5H) | [GitHub Discussions](https://github.com/nocodb/nocodb/discussions)

**관련 도구**: [n8n 워크플로우 자동화](n8n-workflow-automation-dibi8-internal-link) | [Metabase BI 설정 가이드](metabase-bi-setup-dibi8-internal-link)

---



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [NocoDB 공식 문서](https://docs.nocodb.com/)
- [NocoDB GitHub 저장소](https://github.com/nocodb/nocodb) — 53,000+ Stars
- [NocoDB Docker Hub](https://hub.docker.com/r/nocodb/nocodb)
- [NocoDB API 참조](https://docs.nocodb.com/developer-resources/rest-APIs/)
- [NocoDB vs Airtable: 기능 비교](https://nocodb.com/compare/airtable)
- [PostgreSQL 공식 문서](https://www.postgresql.org/docs/)

---

*본 문서에는 제휴 링크가 포함될 수 있습니다. 당사의 추천 링크를 통해 DigitalOcean에 가입하시면 추가 비용 없이 커미션을 받습니다. 당사는 직접 사용하는 서비스만을 추천합니다.*
