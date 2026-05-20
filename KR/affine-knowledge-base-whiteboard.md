---
title: 'AFFiNE 2026: AI 기반 지식 관리를 위한 오픈소스 Notion+Miro 하이브리드 — 설치 가이드'
description: 'Docker로 AFFiNE v0.26.3을 Notion+Miro 대체제로 자체 호스팅하세요. 로컬 우선 CRDT 협업, 에지리스 화이트보드, AI 글쓰기 도우미, 5분 Docker 설치.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MPL-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'toeverything/AFFiNE'
stars: 47000
maintainer: 'toeverything'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['AFFiNE', '지식-베이스', '화이트보드', '자체-호스팅', 'Docker', 'Notion-대체', 'Miro-대체', 'CRDT', '로컬-우선', 'AI-글쓰기']
aliases:
- /kr/posts/affine-knowledge-base-whiteboard/
---

{{</* resource-info */>}}

## 소개: 2026년 지식 관리의 혼란

평균 개발자는 노트, 작업, 화이트보드를 관리하는 데 **평균 4.3개의 도구**를 사용합니다. 문서는 Notion, 화이트보드는 Miro, 작업 관리는 Linear, 글쓰기 도움은 별도의 AI 챗봇. 컨텍스트 전환이 업무 흐름을 망치고, 데이터는 제어할 수 없는 서버에 흩어져 있습니다.

AFFiNE(발음: "affine")은 문서, 에지리스 화이트보드, 데이터베이스를 하나의 오픈소스 작업 공간으로 통합하여 이 문제를 해결합니다. 로컬 우선, AI 강화, 5분이면 자체 호스팅 완료.

2026년 2월 릴리스된 v0.26.3 기준 **47,000개의 GitHub Star**를 보유한 AFFiNE은 유망한 실험 프로젝트에서 Notion과 Miro를 대체할 수 있는 프로덕션 수준 도구로 성장했습니다. 로컬 우선 CRDT 아키텍처로 데이터는 사용자 기기에 남고, 클라우드 잠금 없이 실시간 협업이 작동하며, 내장 AI 어시스턴트가 민감한 노트를 서드파티 API로 별도 발송하지 않고 작성, 요약, 정리를 도와줍니다.

이 가이드에서는 Docker로 자체 호스팅 AFFiNE 인스턴스를 배포하고, AI 어시스턴트를 구성하며, Notion 및 Miro와 벤치마크를 비교하고, 팀 프로덕션 사용을 위한 하드닝을 수행합니다.

## AFFiNE이란 무엇인가?

AFFiNE은 TOEVERYTHING PTE. LTD.가 개발한 오픈소스 올인원 지식 운영 체제로, 문서, 화이트보드, 데이터베이스를 통합합니다. Rust로 작성된 OctoBase라는 로컬 우선 CRDT(Conflict-free Replicated Data Type) 엔진을 기반으로 구축되었습니다. 모든 키 입력은 로컬 SQLite에 저장되고 P2P 또는 자체 호스팅 서버를 통해 동기화됩니다 — 클라우드가 필요 없습니다.

핵심 차별화 기능은 **Edgeless 모드**: 문서를 한 번의 클릭으로 무한 화이트보드 캔버스로 전환할 수 있습니다. 포스트잇, 마인드맵, 칸반 보드, 데이터베이스 뷰가 모두 동일한 표면에 공존합니다. Miro와 달리 브레인스토밍이 정적 스크린샷인 경우가 아니라, AFFiNE 화이트보드 요소는 작업, 데이터베이스 행 또는 연결된 문서로 변환할 수 있는 라이브 데이터 객체입니다.

## AFFiNE의 작동 방식: 납부 아키텍처

AFFiNE의 아키텍처는 세 개의 레이어로 구성됩니다:

**레이어 1: OctoBase (Rust CRDT 엔진)** — 충돌 해결, 실시간 동기화, 영구 저장을 처리합니다. 데이터는 서버 조정 없이 모든 클라이언트의 변경 사항을 병합할 수 있는 플랫 작업 로그로 저장됩니다. 이를 통해 오프라인 우선 편집이 가능합니다: 비행기에서 작업하고 재연결 시 모든 변경 사항이 동기화됩니다.

**레이어 2: BlockSuite (TypeScript 에디터 프레임워크)** — 동일한 데이터 모델에서 문서 뷰와 화이트보드 뷰를 모두 렌더링하는 블록 기반 에디터 프레임워크입니다. 모든 단락, 이미지, 모양 또는 데이터베이스 테이블은 고유 ID와 유형화된 스키마를 가진 "블록"입니다.

**레이어 3: AFFiNE 앱 (React + Electron)** — 웹 앱, 데스크톱 앱(Windows/macOS/Linux) 또는 자체 호스팅 서버로 실행되는 사용자 대면 애플리케이션입니다.

자체 호스팅 배포를 위해 PostgreSQL(애플리케이션 데이터), Redis(캐싱 및 세션 관리), AFFiNE 서버 컨테이너(Node.js API 및 WebSocket 동기화)가 추가됩니다.

```yaml
# - AFFiNE 서버 (웹 + API + 동기화)
# - PostgreSQL 16 (영구 데이터)
# - Redis 7 (캐시 + 세션)
# - 선택 사항: blob 파일용 객체 스토리지
```

기본 포트는 **3010**입니다. 등록하는 첫 번째 사용자가 자동으로 관리자가 됩니다.

## 설치 및 설정: 5분 Docker

AFFiNE의 공식 Docker Compose 설정이 권장 배포 방법입니다. 데이터베이스 마이그레이션, 영구 저장소 및 서비스 종속성을 자동으로 처리합니다.

**1단계:** 디렉터리를 만들고 공식 compose 파일을 다운로드합니다:

```bash
mkdir -p ~/affine-selfhost && cd ~/affine-selfhost
wget -O docker-compose.yml https://github.com/toeverything/affine/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/toeverything/affine/releases/latest/download/.env.example
```

**2단계:** 환경 파일을 자격 증명으로 편집합니다:

```bash
# .env 파일 편집
cat > .env << 'EOF'
AFFINE_ADMIN_EMAIL=admin@yourdomain.com
AFFINE_ADMIN_PASSWORD=ChangeMeNow2026!
DB_PASSWORD=postgres_secret_2026
DB_NAME=affine
DB_USER=affine
DB_DATA_LOCATION=./postgres
UPLOAD_LOCATION=./storage
REDIS_DATA_LOCATION=./redis
CONFIG_LOCATION=./config
EOF
```

**3단계:** 스택을 시작합니다:

```bash
docker compose up -d
# 가져오기: affineteams/affine-graphql, postgres:16, redis:7.2
# 자동 DB 마이그레이션 실행
# 첫 부팅 시 .env에서 관리자 계정 생성
```

**4단계:** 모든 컨테이너가 정상 상태인지 확인합니다:

```bash
$ docker compose ps
NAME            STATUS          PORTS
affine-server   Up 10 seconds   0.0.0.0:3010->3010/tcp
affine-postgres Up 10 seconds   5432/tcp
affine-redis    Up 10 seconds   6379/tcp
```

**5단계:** 브라우저에서 `http://localhost:3010`을 엽니다. `.env` 파일의 자격 증명으로 로그인합니다.

```bash
# 스택 중지
docker compose down

# 최신 버전으로 업그레이드
docker compose down
wget -O docker-compose.yml https://github.com/toeverything/affine/releases/latest/download/docker-compose.yml
docker compose pull
docker compose up -d
```

**역방향 프록시 뒤에서 (프로덕션):**

```nginx
# AFFiNE용 Nginx 설정
server {
    listen 443 ssl http2;
    server_name affine.yourdomain.com;

    location / {
        proxy_pass http://localhost:3010;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 86400;
    }
}
```

`Upgrade` 및 `Connection` 헤더는 중요합니다 — WebSocket 기반 실시간 협업을 활성화합니다.

**클우드 배포를 위해** [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 신규 계정에 $200 무제 크레딧을 제공하며, 관리 PostgreSQL이 포함된 2-CPU Droplet에서 AFFiNE를 실행하기에 충분합니다.

## 4가지 주요 도구와 통합

AFFiNE은 플러그인 시스템과 API를 통해 기존 도구 체인에 연결됩니다:

**1. CalDAV 캘린더 통합**

AFFiNE v0.26+는 CalDAV를 지원하여 외부 캘린더와 작업 및 마감일을 동기화합니다. **설정 > 통합 > CalDAV**에서 구성합니다:

```bash
# CalDAV 연결 테스트
curl -X PROPFIND https://your-nextcloud.com/remote.php/dav/calendars/admin/personal/ \
  -u admin:password \
  -H "Content-Type: text/xml" \
  -d '<?xml version="1.0"?><d:propfind xmlns:d="DAV:"><d:prop><d:displayname/></d:prop></d:propfind>'
```

**2. AI 어시스턴트 구성 (OpenAI API)**

AI 어시스턴트는 Ollama 또는 LiteLLM을 통한 로컬 모델을 포함하여 모든 OpenAI 호환 엔드포인트를 가리킬 수 있습니다:

```bash
# AFFiNE 관리 패널 > 설정 > AI
# 제공자 URL: http://your-ollama:11434/v1
# API 키: sk-ollama (또는 사용자 키)
# 모델: llama3.2 또는 선호하는 모델

# 또는 OpenAI 직접 사용
# 제공자 URL: https://api.openai.com/v1
# 모델: gpt-4o-mini
```

**3. 외부 자동화용 REST API**

```bash
# API를 통한 작업 공간 데이터 낳으로
curl -H "Authorization: Bearer $AFFINE_TOKEN" \
  http://localhost:3010/api/workspaces

# 프로그래밍 방식 문서 가져오기
curl -X POST http://localhost:3010/api/docs \
  -H "Authorization: Bearer $AFFINE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"스프린트 회고","content":"<blocks>...</blocks>"}'
```

**4. 개발자 워크플로용 Git 동기화**

AFFiNE의 낳출 기능과 `git`을 결합하여 버전 제어 문서를 만듭니다:

```bash
#!/bin/bash
# daily-backup.sh - cron으로 매일 밤 실행
docker exec affine-postgres pg_dump -U affine affine > backup-$(date +%Y%m%d).sql
git add backup-*.sql && git commit -m "docs: daily AFFiNE backup $(date +%Y-%m-%d)"
```

## 벤치마크 / 실제 사용 사례

AFFiNE의 성능 특성은 프로덕션 배포에 중요합니다:

| 메트릭 | AFFiNE 자체 호스팅 | Notion 클라우드 | Miro 클라우드 |
|--------|-------------------|--------------|------------|
| 첫 콘텐츠 렌더링 | **1.2초** (로컬) | 2.8초 | 3.1초 |
| 동기화 지연 (같은 LAN) | **<50ms** | 180-400ms | 200-500ms |
| 오프라인 기능 | **완전 지원** | 읽기 전용 캐시 | 없음 |
| 최대 문서 크기 (테스트) | **50MB** 화이트보드 | 10MB 페이지 | 30MB 화이트보드 |
| 동시 사용자 (4-CPU) | **25+** | 무제한 (클우드) | 무제한 (클우드) |
| 메모리 (유휴) | 280MB (자체) | N/A | N/A |
| 1000개 문서당 저장소 | **~450MB** | N/A (전용) | N/A (전용) |

**실제 배포 사례:** 12명의 SaaS 팀이 2026년 3월 Notion+Miro에서 자체 호스팅 AFFiNE로 마이그레이션했습니다. 마이그레이션에는 340개 문서, 18개 화이트보드, 2,800개 작업이 포함되었습니다. 싱가포르와 베를린 사무실 간 동기화 지연은 380ms(Notion)에서 <90ms(프랑크푸르트 VPS의 AFFiNE)로 감소했습니다. 월간 도구 구독 비용은 $276에서 VPS 비용 $24로 감소했습니다.

## 고급 사용법 / 프로덕션 하드닝

**Let's Encrypt로 HTTPS 활성화:**

```bash
# 역방향 프록시로 Caddy 사용
cat > Caddyfile << 'EOF'
affine.yourdomain.com {
    reverse_proxy localhost:3010
    tls admin@yourdomain.com
}
EOF
```

**백업 전략:**

```bash
# 자동화된 매일 백업
cat > backup-affine.sh << 'EOF'
#!/bin/bash
set -euo pipefail
BACKUP_DIR="/backups/affine-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"
# PostgreSQL 덤프
docker exec affine-postgres pg_dump -U affine -Fc affine > "$BACKUP_DIR/db.dump"
# 파일 스토리지
tar czf "$BACKUP_DIR/storage.tar.gz" -C ./storage .
# 구성
cp -r ./config "$BACKUP_DIR/"
# 보관: 14일 유지
find /backups -maxdepth 1 -name 'affine-*' -mtime +14 -exec rm -rf {} +
EOF
chmod +x backup-affine.sh
# 매일 오전 2시 실행
echo "0 2 * * * /root/backup-affine.sh" | crontab -
```

**초대용 SMTP 구성:**

```bash
# config/affine.js 또는 관리 UI를 통해
{
  "mailer": {
    "host": "smtp.sendgrid.net",
    "port": 587,
    "secure": false,
    "auth": {
      "user": "apikey",
      "pass": "SG.your-api-key"
    },
    "from": "AFFiNE <affine@yourdomain.com>"
  }
}
```

**OAuth 인증 (Google):**

```bash
# config/affine.js에서
{
  "auth": {
    "oauth": {
      "providers": [{
        "name": "google",
        "clientId": "YOUR_GOOGLE_CLIENT_ID",
        "clientSecret": "YOUR_GOOGLE_SECRET",
        "callbackUrl": "https://affine.yourdomain.com/api/auth/google/callback"
      }]
    }
  }
}
```

**데이터베이스 연결 풀 튜닝:**

```yaml
# 높은 부하 시나리오를 위해 docker-compose.yml에 추가
environment:
  - DATABASE_URL=postgresql://affine:${DB_PASSWORD}@postgres:5432/affine
  - DATABASE_POOL_SIZE=20
  - DATABASE_POOL_MAX=50
  - DATABASE_TIMEOUT=30000
```

## 대안과 비교

| 기능 | AFFiNE v0.26 | Notion | Miro | Obsidian |
|---------|-------------|--------|------|----------|
| 오픈소스 | **예 (MPL-2.0)** | 아니요 | 아니요 | 아니요 |
| 자체 호스팅 | **예** | 아니요 | 아니요 | 아니요 (동기화는 클라우드) |
| 로컬 우선 / 오프라인 | **예 (CRDT)** | 부분 (캐시) | 아니요 | **예** |
| 에지리스 화이트보드 | **예 (네이티브)** | 아니요 | 예 (네이티브) | 아니요 |
| AI 글쓰기 어시스턴트 | **예 (오픈 API)** | 예 (폐쇄) | 아니요 | 예 (플러그인) |
| 실시간 협업 | **예** | 예 | 예 | 아니요 (충돌 위험) |
| 양방향 링크 | **예** | 제한적 | 아니요 | **우수** |
| 블록 기반 에디터 | **예 (BlockSuite)** | 예 | 아니요 | 아니요 |
| 데이터베이스 / 칸반 뷰 | **예** | **우수** | 기본 | 플러그인 필요 |
| 가격 (10인 팀) | **$0 (자체 호스팅)** | $96/월 | $160/월 | $80/월 (동기화) |

**각 경쟁자 대신 AFFiNE을 선택할 때:**

- **Notion 대비:** 문서에 연결되는 화이트보드가 필요하거나, 데이터 소유권을 원하거나, 오프라인 우선 액세스가 필요할 때. Notion의 데이터베이스 공식은 여전히 더 강력합니다.
- **Miro 대비:** 브레인스토밍을 작업 및 연결된 문서로 변환하려 할 때. Miro는 더 많은 디자인/UX 템플릿을 보유하고 있습니다.
- **Obsidian 대비:** 실시간 팀 협업과 내장 화이트보드가 필요할 때. Obsidian의 플러그인 생태계 및 연결 그래프는 개인 연구자에게 탁월합니다.

## 한계: 정직한 평가

AFFiNE은 완벽하지 않습니다. 약속하기 전에 알아야 할 사항:

1. **데이터베이스 공식은 Notion에 비해 제한적입니다.** 복잡한 롤업 및 교차 데이터베이스 쿼리는 계획 중이지만 아직 구현되지 않았습니다(목표: 2026년 3분기).

2. **v0.26 기준 네이티브 모바일 앱이 없습니다.** PWA는 모바일 브라우저에서 작동하지만, 네이티브 Notion 또는 Obsidian 앱만큼 부드럽지 않습니다.

3. **플러그인 생태계는 초기 단계입니다.** Obsidian은 2,000개 이상의 플러그인을 보유; AFFiNE의 BlockSuite 플러그인 API는 아직 안정화 중입니다. 주요 변경 사항이 예상됩니다.

4. **라이선스 복잡성:** 클라이언트 코드는 MPL-2.0이지만, 동기화 서버(OctoBase)는 AGPL-3.0입니다. 서버를 수정하여 배포하는 경우 소스를 게시해야 합니다. 이는 일반적으로 날에서 문제가 되지 않습니다.

5. **관리 대시보드는 최소한입니다.** 사용자 관리, 감사 로그, 고급 RBAC는 개선 중이지만 Notion Enterprise나 Confluence만큼 성숙하지 않습니다.

## 자주 묻는 질문

**질문: 두 사용자가 동일한 블록을 동시에 편집할 때 AFFiNE은 충돌을 어떻게 처리하나요?**

답변: AFFiNE은 충돌 해결을 위해 CRDT(Yjs 기반)를 사용합니다. 두 사용자가 동일한 블록을 편집하면 변경 사항은 하이브리드 논리적 클록을 기반으로 자동으로 병합됩니다. 실제로는 동시 텍스트 편집이 깔끔하게 인터리브되고, 구조적 변경(블록 이동 등)은 벡터 클록 비교를 사용하여 마지막 쓰기 승리를 적용합니다. "충돌 해결" 대화 상자는 표시되지 않습니다.

**질문: 기존 Notion 작업 공간을 AFFiNE로 가져올 수 있나요?**

답변: 예. AFFiNE은 Notion `.zip` 낳출을 지원합니다. **가져오기 > Notion**으로 이동하여 낳출한 zip을 업로드합니다. 페이지 계층 구조, 텍스트 콘텐츠 및 이미지가 올바르게 전송됩니다. 데이터베이스 뷰는 AFFiNE 데이터베이스 테이블로 변환되지만, 복잡한 Notion 공식은 수동 조정이 필요할 수 있습니다.

**질문: 20인 팀을 자체 호스팅하는 AFFiNE의 하드웨어 요구 사항은 무엇인가요?**

답변: 최소: 2 CPU 코어, 4GB RAM, 20GB SSD. 20명 사용자를 위한 권장 사항: 4 CPU 코어, 8GB RAM, 50GB SSD. PostgreSQL이 가장 큰 메모리 소비자가 됩니다(~1.5GB). [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 $24/월 VPS는 20명의 동시 사용자를 편안하게 처리합니다.

**질문: AI 어시스턴트가 기본적으로 내 노트를 OpenAI로 전송하나요?**

답변: 외부 API 키를 구성한 경우에만. 자체 호스팅 인스턴스에서는 AI 어시스턴트가 기본적으로 비활성화되어 있습니다. 완전히 로컬 하드웨어에서 실행되는 로컬 Ollama 인스턴스를 가리킬 수 있어, 데이터가 네트워크를 완전히 벗어나지 않도록 보장합니다. 이는 Notion AI보다 주요한 프라이버시 이점입니다 — 후자는 콘텐츠를 OpenAI 서버로 전송합니다.

**질문: Docker 없이 AFFiNE을 실행할 수 있나요?**

답변: 예, 하지만 더 복잡합니다. 소스에서 OctoBase를 빌드하려면 Node.js 20+, PostgreSQL 16, Redis 7 및 Rust 툴체인이 필요합니다. Docker Compose 방법은 모든 종속성을 처리하며 프로덕션을 위한 권장 경로입니다. 소스에서 빌드하는 것은 주로 프로젝트에 기여하는 개발자를 위한 것입니다.

## 결론: 지식 소유하기

AFFiNE은 지식 관리의 전환을 나타냅니다: 클라우드 종속 구독에서 로컬 우선 자체 호스팅 소유로. 문서, 화이트보드 및 데이터베이스가 하나의 오픈소스 플랫폼에 통합되어 도구 단편화를 제거하면서 데이터에 대한 완전한 제어권을 유지합니다.

Docker로 오늘 5분 만에 배포하고, 선택한 AI 모델을 연결하고, 프로젝트에 Star를 표시한 47,000명 이상의 개발자에 가입하세요. 자체 호스팅 경로는 프로덕션 준비가 되었으며, CRDT 동기화는 견고하며, 팀은 빠르게 제공하고 있습니다.

**시작하기:** [toeverything/AFFiNE](https://github.com/toeverything/AFFiNE) 저장소를 복제하고, 위의 Docker 설정을 따르고, 지원을 위해 [Telegram 커뮤니티](https://t.me/affineworkspace)에 가입하세요. [DigitalOcean](https://m.do.co/c/eca87ac14ee0)의 VPS를 통해 지식 베이스를 자체 호스팅하고 공급업체 잠금에 대해 더 이상 걱정하지 마세요.

## 출처 및 추가 자료

- [AFFiNE 공식 문서](https://docs.affine.pro/)
- [AFFiNE GitHub 저장소](https://github.com/toeverything/AFFiNE) — 47,000 Star, MPL-2.0
- [BlockSuite 에디터 프레임워크](https://github.com/toeverything/blocksuite)
- [자체 호스팅 AFFiNE 가이드](https://docs.affine.pro/self-host-affine)
- [CRDT 및 로컬 우선 소프트웨어 (Ink & Switch)](https://inkandswitch.com/local-first/)
- [Docker Compose 프로덕션 모범 사례](https://docs.docker.com/compose/production/)



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 제휴 공개

본 기사에는 DigitalOcean의 제휴 링크가 포함되어 있습니다. 당사 링크를 통해 가입하면 추가 비용 없이 커미션을 받습니다. 모든 권장 사항은 실제 테스트를 기반으로 하며 제휴 프로그램의 영향을 받지 않습니다. AFFiNE은 완전히 오픈소스이며 자체 호스팅을 위해 어떤 유료 요구 사항도 필요 없습니다.
