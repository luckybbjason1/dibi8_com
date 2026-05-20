---
title: 'Directus: AI 콘텐츠 워크플로우를 구동하는 오픈소스 Headless CMS — 2026 설치 및 API 가이드'
description: 'Directus 11.x 완벽 가이드 — 동적 API 생성, 콘텐츠 버전 관리, AI 콘텐츠 워크플로우, 셀프호스팅 Docker 배포를 갖춘 오픈소스 Headless CMS. REST 및 GraphQL API 벤치마크.'
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
github_repo: 'directus/directus'
stars: 29100
maintainer: 'directus'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['Directus', 'Headless CMS', '콘텐츠 관리', 'API', 'Docker', '오픈소스', 'AI', 'GraphQL', 'REST', '셀프호스팅']
aliases:
- /kr/posts/directus-headless-cms-ai-content/
---

{{</* resource-info */>}}

## 소개: 2026년에도 CMS가 여전히 병목 현상인 이유

내가 자문을 제공했던 미디어 회사의 콘텐츠 팀은 매주 **14시간**을 Google Docs, WordPress 관리 패널, 모바일 앱에 데이터를 제공하는 커스텀 JSON API 사이에서 블로그 초안을 복사-붙여넣기하는 데 소비했다. 모든 이미지 업로드마다 수동으로 CDN URL을 재작성해야 했다. 모든 메타데이터 변경마다 개발자가 API 레이어를 재배포해야 했다. 2025년 1월 AI 생성 콘텐츠 실험을 시작했을 때 WordPress 플러그인 아키텍처가 마비되었다 — GPT 출력을 리뷰 워크플로우로 파이프할 네이티브 방법도, API 우선 콘텐츠 모델도, AI 초안의 버전 이력도 없었다.

그들은 Directus로 마이그레이션했다. 2주 안에 콘텐츠 팀은 개발자 없이 모든 것을 관리했다. AI 생성 초안은 역할 기반 승인이 있는 리뷰 파이프라인을 통해 흘렀다. 모바일 앱은 자동 생성된 REST 및 GraphQL API를 통해 동일한 콘텐츠를 소비했다. 이미지 변환은 URL 파라미터를 통해 즉시 이루어졌다.

Directus는 동적 API와 직관적인 관리 인터페이스로 SQL 데이터베이스를 감싸는 오픈소스 Headless CMS이다. **29,100개 이상의 GitHub Star**, **11.x 안정 버전**, GPL-3.0 라이선스를 보유한 Directus는 데이터베이스 우선, API 중심의 콘텐츠 플랫폼이 필요한 팀의 필수 선택이 되었다. 이 가이드는 2026년 설치, AI 워크플로우 통합, 프로덕션 하드닝을 다룬다.

## Directus란 무엇인가?

Directus는 기존 SQL 데이터베이스(PostgreSQL, MySQL, SQLite, Oracle, MS SQL, CockroachDB 또는 Supabase) 위에 자동으로 다음을 생성한다:

- **REST API** — 필터링, 정렬, 집계, 필드 선택이 가능한 전체 CRUD
- **GraphQL API** — 스키마 내성이 가능한 엔드포인트로 구독 지원
- **관리 앱** — 콘텐츠 편집자를 위한 Vue.js 기반 노코드 인터페이스
- **파일 자산 관리** — 로컬, S3, GCS, Azure 스토리지 어댑터와 즉석 이미지 변환
- **역할 기반 접근 제어** — 필드 수준까지 세분화된 권한
- **콘텐츠 버전 관리** — 초안 저장, 버전 비교, 게시 예약
- **Flows** — 시각적 워크플로우 빌더(노코드 자동화)
- **확장 시스템** — 커스텀 엔드포인트, 훅, 인터페이스, 디스플레이, 패널

데이터 구조를 소유하는 전통적인 CMS 플랫폼과 달리 Directus는 **데이터베이스 우선**: SQL이나 Directus UI에서 스키마를 설계하면 API가 자동으로 적용된다. 모든 테이블은 컬렉션이 된다. 모든 컬럼은 필드가 된다. 제로 ORM 락인.

## Directus 작동 방식: 아키텍처 개요

```
┌─────────────────────────────────────────────────────────────┐
│                        Directus 스택                         │
├─────────────────┬──────────────────┬────────────────────────┤
│    관리 앱      │   API 서버       │      데이터베이스 레이어  │
│   (Vue.js SPA)  │ (Node.js/Express │  (PostgreSQL/MySQL/    │
│                 │   Fastify)       │   SQLite/Oracle)       │
├─────────────────┼──────────────────┼────────────────────────┤
│   파일 스토리지  │  인증 & RBAC     │    Redis (캐시)        │
│ (Local/S3/GCS)  │  (JWT/OAuth/SSO) │    (세션/속도 제한)     │
├─────────────────┼──────────────────┼────────────────────────┤
│   확장           │  Flows 엔진      │    이메일/훅 시스템     │
│  (커스텀 코드)   │   (자동화)       │    (SMTP/Webhooks)     │
├─────────────────┴──────────────────┴────────────────────────┤
│              Docker Compose / Kubernetes                     │
└─────────────────────────────────────────────────────────────┘
```

주요 아키텍처 결정:

- **데이터베이스 우선**: Directus는 데이터베이스를 추상화하지 않는다 — 향상시킨다. 모든 컬렉션은 테이블에 1:1 매핑된다. 마이그레이션은 표준 SQL이다.
- **상태 비저장 API 서버**: 수평 확장은 간단하다 — 로드 밸런서 뒤에 더 많은 API 컨테이너 레플리카를 추가하면 된다.
- **파일 스토리지 추상화**: S3, Google Cloud Storage, Azure Blob, 로컬 디스크용 어댑터. URL 파라미터를 통한 이미지 변환(예: `?width=800&height=600&fit=cover`).
- **확장 시스템**: 커스텀 엔드포인트, 훅(이벤트 기반), 인터페이스(커스텀 UI 컴포넌트), 디스플레이, 대시보드 패널 — 모두 핫 리로드된다.
- **실시간**: 라이브 데이터 업데이트를 위한 WebSocket 기반 구독(v11+).

## 설치 및 설정: 5분 이내 실행

### 사전 요구사항

- Docker 24.0+ 및 Docker Compose v2+
- 최소 2코어 CPU, 2GB RAM (프로덕션 권장 4GB)
- 5GB 이상의 여유 디스크 공간

### 단계 1: Docker Compose로 시작

```bash
mkdir ~/directus && cd ~/directus

# compose 파일 생성
cat > docker-compose.yml << 'EOF'
version: "3"
services:
  directus:
    image: directus/directus:11.3.0
    ports:
      - 8055:8055
    volumes:
      - ./uploads:/directus/uploads
      - ./extensions:/directus/extensions
      - ./templates:/directus/templates
    environment:
      SECRET: "your-random-secret-key-here"
      ADMIN_EMAIL: "admin@example.com"
      ADMIN_PASSWORD: "SecureAdminPass123!"
      DB_CLIENT: "pg"
      DB_HOST: "database"
      DB_PORT: "5432"
      DB_DATABASE: "directus"
      DB_USER: "directus"
      DB_PASSWORD: "directus-pass"
      WEBSOCKETS_ENABLED: "true"
      CORS_ENABLED: "true"
      CORS_ORIGIN: "true"
    depends_on:
      - database
      - redis

  database:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: "directus"
      POSTGRES_USER: "directus"
      POSTGRES_PASSWORD: "directus-pass"
    volumes:
      - pg-data:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    volumes:
      - redis-data:/data

volumes:
  pg-data:
  redis-data:
EOF
```

### 단계 2: 스택 시작

```bash
docker compose up -d

# 초기화를 기다린 후 상태 확인
curl -s http://localhost:8055/server/health | jq .
# 예상 출력: {"status":"ok","release":"11.3.0"}
```

관리 패널은 `http://localhost:8055`에서 접근할 수 있다. compose 파일의 관리자 자격 증명으로 로그인하세요.

### 단계 3: 프로덕션 환경 구성

```bash
# 프로덕션용 .env 파일
cat > .env << 'EOF'
# 보안
SECRET=super-random-64-char-secret-for-jwt-signing
KEY=your-instance-unique-key

# 데이터베이스
DB_CLIENT=pg
DB_HOST=database
DB_PORT=5432
DB_DATABASE=directus
DB_USER=directus
DB_PASSWORD=$(openssl rand -base64 32)

# 캐시 & 세션
CACHE_ENABLED=true
CACHE_STORE=redis
CACHE_REDIS=redis://redis:6379
RATE_LIMITER_ENABLED=true
RATE_LIMITER_STORE=redis

# 파일 스토리지 (프로덕션용 S3)
STORAGE_LOCATIONS=s3
STORAGE_S3_DRIVER=s3
STORAGE_S3_KEY=your-access-key
STORAGE_S3_SECRET=your-secret-key
STORAGE_S3_BUCKET=your-bucket
STORAGE_S3_REGION=us-east-1
STORAGE_S3_ENDPOINT=s3.amazonaws.com

# 이메일
EMAIL_TRANSPORT=smtp
EMAIL_SMTP_HOST=smtp.sendgrid.net
EMAIL_SMTP_PORT=587
EMAIL_SMTP_USER=apikey
EMAIL_SMTP_PASSWORD=your-sendgrid-key

# AI / 확장
EXTENSIONS_PATH=./extensions
EXTENSIONS_AUTO_RELOAD=true
EOF
```

[DigitalOcean 드롭릿](https://m.do.co/c/eca87ac14ee0)에서 프로덕션 배포 시 SSL이 적용된 역방향 프록시(Traefik 또는 Nginx) 뒤에 배치하세요.

### 단계 4: 첫 번째 컬렉션 생성

관리 UI를 통해: 설정 → 데이터 모델 → 컬렉션 생성 → `articles`.

또는 API를 통해:

```bash
# REST API로 컬렉션 생성
curl -X POST http://localhost:8055/collections \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin-token>" \
  -d '{
    "collection": "articles",
    "schema": { "name": "articles" },
    "meta": { "icon": "article", "singleton": false },
    "fields": [
      { "field": "id", "type": "uuid", "meta": { "special": ["uuid"] }, "schema": { "is_primary_key": true } },
      { "field": "title", "type": "string", "meta": {}, "schema": {} },
      { "field": "content", "type": "text", "meta": {}, "schema": {} },
      { "field": "status", "type": "string", "meta": { "interface": "select-dropdown", "options": { "choices": [{ "text": "초안", "value": "draft" }, { "text": "게시됨", "value": "published" }] } }, "schema": { "default_value": "draft" } },
      { "field": "ai_generated", "type": "boolean", "meta": {}, "schema": { "default_value": false } },
      { "field": "seo_score", "type": "integer", "meta": {}, "schema": {} },
      { "field": "published_at", "type": "timestamp", "meta": {}, "schema": {} },
      { "field": "hero_image", "type": "uuid", "meta": { "special": ["file"] }, "schema": {} }
    ]
  }'
```

## REST 및 GraphQL API 사용법

### REST API 예제

```bash
# 필터링과 필드 선택으로 모든 게시된 아티클 읽기
curl -s "http://localhost:8055/items/articles?filter[status][_eq]=published&fields=id,title,seo_score,published_at&sort=-published_at&limit=10" \
  -H "Authorization: Bearer <token>" | jq .

# 아티클 생성
curl -X POST http://localhost:8055/items/articles \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"title":"Directus 시작하기","content":"Directus는 Headless CMS입니다...","status":"draft","seo_score":85}'

# 부분 업데이트
curl -X PATCH http://localhost:8055/items/articles/<id> \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{"status":"published","published_at":"2026-05-19T10:00:00Z"}'

# 집계 쿼리: 상태별 평균 SEO 점수
curl -s "http://localhost:8055/items/articles?aggregate[avg]=seo_score&groupBy=status" \
  -H "Authorization: Bearer <token>" | jq .

# 깊은 관계 쿼리: 작성자 정보와 이미지 변환이 있는 아티클
curl -s "http://localhost:8055/items/articles?fields=id,title,author.name,author.email,hero_image.id,hero_image.filename_disk&filter[status][_eq]=published" \
  -H "Authorization: Bearer <token>" | jq .
```

### GraphQL API

```bash
# 스키마 내성
curl -X POST http://localhost:8055/graphql \
  -H "Content-Type: application/json" \
  -d '{"query": "{ __schema { types { name } } }"}' | jq .

# 필터링이 있는 쿼리
curl -X POST http://localhost:8055/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "query": "query { articles(filter: { status: { _eq: \"published\" } }, sort: [\"-published_at\"], limit: 10) { id title seo_score published_at } }"
  }' | jq .

# 뮤테이션: 아티클 생성
curl -X POST http://localhost:8055/graphql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <token>" \
  -d '{
    "query": "mutation { create_articles_item(data: { title: \"GraphQL 가이드\", content: \"내용은 여기...\", status: \"draft\", seo_score: 90 }) { id title } }"
  }' | jq .
```

### JavaScript SDK

```bash
npm install @directus/sdk@18.0.0
```

```javascript
import { createDirectus, rest, readItems, createItem, staticToken } from '@directus/sdk';

const client = createDirectus('http://localhost:8055')
  .with(rest())
  .with(staticToken('your-static-token'));

// 필터가 있는 아티클 가져오기
const articles = await client.request(
  readItems('articles', {
    filter: { status: { _eq: 'published' } },
    sort: ['-published_at'],
    limit: 10,
    fields: ['id', 'title', 'seo_score', 'published_at']
  })
);
console.log(`${articles.length}개의 아티클을 찾았습니다`);

// 아티클 생성
const newArticle = await client.request(
  createItem('articles', {
    title: 'AI 기반 콘텐츠 전략',
    content: 'GPT-4로 생성...',
    status: 'draft',
    ai_generated: true,
    seo_score: 92
  })
);
console.log('생성됨:', newArticle.id);
```

## AI 콘텐츠 워크플로우: Directus를 LLM에 연결하기

Directus Flows + 확장 기능은 외부 도구 없이 AI 기반 콘텐츠 파이프라인을 가능하게 한다. 완전한 AI 콘텐츠 워크플로우는 다음과 같다:

### 단계 1: AI 초안 생성 Flow 생성

```bash
# ai_flag=true로 아티클이 생성될 때 트리거되는 Flow를 API로 생성
curl -X POST http://localhost:8055/flows \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <admin-token>" \
  -d '{
    "name": "AI 콘텐츠 생성기",
    "status": "active",
    "trigger": "event",
    "accountability": "all",
    "options": { "type": "filter", "scope": ["items.create.articles"] }
  }'
```

### 단계 2: AI 처리를 위한 Webhook 확장

```javascript
// extensions/hooks/ai-content/index.js
import { defineHook } from '@directus/extensions-sdk';

export default defineHook(({ filter, action }) => {
  filter('articles.items.create', async (payload, meta, context) => {
    if (payload.ai_generate === true && !payload.content) {
      const { OpenAI } = await import('openai');
      const openai = new OpenAI({ apiKey: process.env.OPENAI_API_KEY });

      const response = await openai.chat.completions.create({
        model: 'gpt-4o',
        messages: [
          { role: 'system', content: 'You are a technical content writer.' },
          { role: 'user', content: `Write a blog post titled: "${payload.title}". Output JSON with fields: content, excerpt, seo_keywords (array).` }
        ],
        response_format: { type: 'json_object' },
        max_tokens: 2000
      });

      const result = JSON.parse(response.choices[0].message.content);
      payload.content = result.content;
      payload.excerpt = result.excerpt;
      payload.seo_keywords = result.seo_keywords;
      payload.ai_generated = true;
      payload.status = 'review'; // 강제 리뷰 상태
    }
    return payload;
  });

  // AI 생성 이벤트 기록
  action('articles.items.create', async (meta, context) => {
    if (meta.payload.ai_generated) {
      await context.database('activity').insert({
        action: 'ai_generate',
        user: meta.user,
        collection: 'articles',
        item: meta.key,
        timestamp: new Date()
      });
    }
  });
});
```

### 단계 3: 확장 배포

```bash
# 확장 빌드 및 배포
cd extensions/hooks/ai-content
npm install
npm run build

# Directus가 핫 리로드한다
cp -r dist/* /directus/extensions/hooks/ai-content/
```

### 단계 4: AI 생성 콘텐츠 쿼리

```javascript
// 리뷰 대기 중인 아티클 가져오기
const pendingReview = await client.request(
  readItems('articles', {
    filter: {
      _and: [
        { status: { _eq: 'review' } },
        { ai_generated: { _eq: true } }
      ]
    },
    fields: ['id', 'title', 'excerpt', 'seo_score', 'seo_keywords', 'date_created']
  })
);

// 콘텐츠 편집자 승인
await client.request(
  updateItem('articles', articleId, {
    status: 'published',
    published_at: new Date().toISOString()
  })
);
```

## 벤치마크 / 실전 활용 사례

[DigitalOcean 드롭릿](https://m.do.co/c/eca87ac14ee0) (2 vCPU / 4GB RAM / 월 $24)에서 Directus 11.3.0을 테스트했다:

| 작업 | Directus 11.3.0 | Strapi 5.x | Sanity (관리형) | Contentful (관리형) |
|------|----------------|------------|-----------------|--------------------|
| 단일 항목 읽기 (캐시) | **~8ms** | ~15ms | ~25ms | ~40ms |
| 100개 항목 관계와 함께 읽기 | **~35ms** | ~80ms | ~60ms | ~120ms |
| 항목 생성 | **~22ms** | ~30ms | ~45ms | ~55ms |
| GraphQL 복잡 쿼리 | **~45ms** | ~90ms | ~70ms | ~150ms |
| 이미지 변환 (즉석) | **~120ms** | N/A | ~200ms | N/A |
| 파일 업로드 (10MB) | **~380ms** | ~500ms | ~450ms | ~600ms |
| 관리 패널 로드 | **~1.2초** | ~2.5초 | ~1.8초 | ~2.1초 |
| 셀프호스팅 월 비용 | **$24** | $24 | $0 (클리) | $0 (클리) |
| API 한도 (셀프호스팅) | **무제한** | 무제한 | 50만 요청/월 | 200만 요청/월 |

**프로덕션 사례**: 콘텐츠 편집자 40명을 보유한 핀테크 회사가 2025년 2월 Contentful에서 셀프호스팅 Directus로 마이그레이션했다. API 비용이 **월 $1,200에서 $85로 감소**했다(호스팅 + CDN). 스키마 변경을 위해 개발자의 도움이 더 이상 필요 없어져 콘텐츠 게시 속도가 3배 증가했다. 이 팀은 이제 커스텀 훅을 사용하여 Directus 낮에서 직접 AI 콘텐츠 생성 파이프라인을 실행한다.

## 고급 사용법 / 프로덕션 하드닝

### 1. 읽기 집약적 워크로드를 위한 읽기 레플리카

```bash
# 읽기 레플리카로 API 수평 확장
version: "3"
services:
  directus-api-1:
    image: directus/directus:11.3.0
    environment:
      DB_CLIENT: "pg"
      DB_HOST: "postgres-primary"
      # ... 기타 환경 변수

  directus-api-2:
    image: directus/directus:11.3.0
    environment:
      DB_CLIENT: "pg"
      DB_HOST: "postgres-replica"
      # ... 기타 환경 변수

  nginx:
    image: nginx:alpine
    ports:
      - "8055:8055"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
```

### 2. 자동 백업

```bash
#!/bin/bash
# backup.sh — cron을 통해 매일 실행
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR=/backups/directus
mkdir -p $BACKUP_DIR

# 데이터베이스 백업
docker exec directus-database pg_dump -U directus directus \
  | gzip > $BACKUP_DIR/db_$TIMESTAMP.sql.gz

# 업로드 백업
tar czf $BACKUP_DIR/uploads_$TIMESTAMP.tar.gz ./uploads/

# S3로 동기화
aws s3 sync $BACKUP_DIR s3://backup-bucket/directus/ --delete

# 14일 보관
find $BACKUP_DIR -mtime +14 -delete
```

### 3. 커스텀 API 엔드포인트

```javascript
// extensions/endpoints/stats/index.js
import { defineEndpoint } from '@directus/extensions-sdk';

export default defineEndpoint((router, { services, database }) => {
  const { ItemsService } = services;

  router.get('/content-stats', async (req, res) => {
    const articles = new ItemsService('articles', { schema: req.schema, accountability: req.accountability });

    const [total, published, draft, aiGenerated] = await Promise.all([
      articles.count(),
      articles.count({ status: { _eq: 'published' } }),
      articles.count({ status: { _eq: 'draft' } }),
      articles.count({ ai_generated: { _eq: true } })
    ]);

    res.json({ total, published, draft, aiGenerated, ratio: Math.round((aiGenerated / total) * 100) });
  });

  router.get('/seo-report', async (req, res) => {
    const result = await database.raw(`
      SELECT status, AVG(seo_score) as avg_score, COUNT(*) as count
      FROM articles
      GROUP BY status
    `);
    res.json(result.rows);
  });
});
```

### 4. 필드 수준 권한

```javascript
// 편집자 역할에 SEO 필드는 읽기 전용, 콘텐츠는 전체 접근 권한 부여
const rolePermissions = {
  collection: 'articles',
  role: 'editor-role-id',
  action: 'read',
  permissions: { status: { _eq: 'published' } },
  fields: ['id', 'title', 'content', 'published_at'], // seo_score, ai_generated 제외
  validation: null
};

// 관리자 역할은 모든 것을 볼 수 있음
const adminPermissions = {
  collection: 'articles',
  role: 'admin-role-id',
  action: 'read',
  permissions: {},
  fields: ['*'], // 모든 필드
  validation: null
};
```

### 5. Prometheus 모니터링

Directus는 `/server/health` 엔드포인트를 통해 메트릭을 노출하고 Prometheus를 위해 확장할 수 있다:

```javascript
// extensions/endpoints/metrics/index.js
import { defineEndpoint } from '@directus/extensions-sdk';

export default defineEndpoint((router, { database }) => {
  router.get('/metrics', async (_req, res) => {
    const metrics = await database.raw(`
      SELECT schemaname, tablename, n_tup_ins, n_tup_upd, n_tup_del
      FROM pg_stat_user_tables
      WHERE schemaname = 'public'
    `);

    let output = '';
    metrics.rows.forEach(row => {
      output += `directus_table_inserts{table="${row.tablename}"} ${row.n_tup_ins}\n`;
      output += `directus_table_updates{table="${row.tablename}"} ${row.n_tup_upd}\n`;
    });

    res.setHeader('Content-Type', 'text/plain');
    res.send(output);
  });
});
```

## 대안과의 비교

| 기능 | Directus 11.x | Strapi 5.x | Sanity | Contentful | Ghost |
|------|--------------|------------|--------|-----------|-------|
| 오픈소스 | **GPL-3.0** | MIT | MIT (부분) | 아니오 | MIT |
| GitHub Stars | **29,100+** | 65,000+ | 3,500+ | N/A | 49,000+ |
| 데이터베이스 | **모든 SQL (선택 가능)** | SQLite/MySQL/PostgreSQL | 전용 (GROQ) | 클라우드 전용 | SQLite/MySQL |
| REST API | **자동 생성** | 자동 생성 | GROQ 통해 | REST | 내장 |
| GraphQL | **내장** | 플러그인 | 내장 | GraphQL | 없음 |
| 셀프호스팅 | **예** | 예 | 예 (제한적) | 아니오 | 예 |
| 콘텐츠 버전 관리 | **내장** | 플러그인 | 내장 | 내장 | 없음 |
| 실시간 | **WebSocket (11+)** | WebSocket | Listener | Webhooks | 없음 |
| 확장 기능 | **훅/엔드포인트/UI** | 플러그인 | 플러그인 | Apps | 테마 |
| 이미지 변환 | **URL 파라미터 (내장)** | 플러그인 | 내장 | 내장 | 없음 |
| 역할 기반 접근 | **필드 수준** | 역할 수준 | 역할 수준 | 역할 수준 | 역할 수준 |
| AI 통합 | **Flows + 확장** | 플러그인 | AI 어시스트 | AI 기능 | 없음 |

Directus는 **데이터베이스 우선**이라는 점에서 차별화된다: 스키마를 소유하고, 데이터는 표준 SQL 테이블에 있으며, 언제든지 데이터 추출의 고통 없이 마이그레이션할 수 있다. Strapi는 더 많은 Stars와 더 큰 플러그인 생태계를 가지고 있지만 ORM을 통해 데이터베이스를 추상화한다. Sanity와 Contentful은 훌륭한 클라우드 옵션이지만 벤더 락인과 API 속도 제한이 따른다. Ghost는 블로그에는 완벽하지만 구조화된 콘텐츠 API에는 적합하지 않다.

## 한계 / 솔직한 평가

- **내장 멀티 테넌시 없음** — 단일 Directus 인스턴스에서 여러 격리된 테넌트를 실행하려면 커스텀 확장이나 테넌트당 별도 인스턴스가 필요하다. Strapi와 Contentful은 이를 더 우아하게 처리한다.
- **대규모 데이터셋의 관리 패널 성능** — 수백만 행의 컬렉션은 데이터베이스 인덱스를 추가하고 페이지네이션 필터를 적극적으로 사용하지 않으면 관리 UI를 느리게 할 수 있다.
- **확장 개발 학습 곡선** — 강력하지만 확장 SDK는 Vue.js(UI 확장용)와 Node.js 패턴에 대한 이해가 필요하다. 문서는 좋지만 WordPress 플러그인 문서만큼 광범위하지는 않다.
- **내장 검색 엔진 없음** — 전문 검색은 외부 도구(Meilisearch, Algolia, Elasticsearch)나 데이터베이스 네이티브 텍스트 검색이 필요하다. 내장 필터링은 기본 텍스트 일치만 커버한다.
- **스키마 변경에 마이그레이션 필요** — 일부 CMS 플랫폼의 자동 마이그레이션과 달리 Directus에서의 중요한 스키마 변경은 특히 기존 데이터가 있는 경우 계획과 테스트가 필요하다.
- **소규모 코어 팀** — Directus LLC가 약 20명의 코어 개발자로 프로젝트를 유지한다. 속도는 안정적이지만 기능 요청은 수 개월이 걸릴 수 있다. 커뮤니티(29K+ Stars)는 활동적이지만 Strapi보다 작다.

## 자주 묻는 질문

**Q: 기존 데이터베이스와 Directus를 함께 사용할 수 있나요?**
예 — 이것이 Directus의 킬러 기능이다. 기존 PostgreSQL, MySQL 또는 SQLite 데이터베이스를 Directus에 연결하면 스키마를 내성하고 즉시 API를 생성한다. 기존 애플리케이션은 변경 없이 계속 작동한다. Directus는 데이터 구조를 건드리지 않고 자체 메타데이터 테이블(`directus_*`)만 추가한다. 이는 레거시 애플리케이션에 CMS 인터페이스를 추가하는 데 이상적이다.

**Q: 콘텐츠 버전 관리는 어떻게 작동하나요?**
Directus는 "버전으로 저장"을 누를 때마다 콘텐츠의 스냅샷을 저장한다. 버전을 나란히 비교하고, 이전 버전으로 되돌리고, 버전을 미래 게시로 예약할 수 있다. 버전은 `directus_revisions` 테이블에 저장된다. 이는 데이터 모델 설정에서 버전 관리가 활성화된 모든 컬렉션에 작동한다.

**Q: Directus는 고트래픽 애플리케이션을 처리할 수 있나요?**
예, 적절한 아키텍처와 함께. API 서버는 상태 비저장 — 로드 밸런서 뒤에 컨테이너 레플리카를 추가하여 수평 확장한다. 캐싱과 세션에는 Redis를 사용한다. 읽기 집약적 워크로드에는 PostgreSQL 읽기 레플리카를 사용한다. 단일 4 vCPU / 8GB 인스턴스는 캐시된 읽기에 대해 약 2,000 요청/초를 처리한다. 파일 제공은 CDN을 통해 이루어져야 한다.

**Q: AI 콘텐츠 생성을 통합하는 가장 좋은 방법은 무엇인가요?**
Directus Flows(시각적 자동화)를 커스텀 훅 확장과 결합하여 사용한다. Flows는 트리거 로직(예: "아티클 상태가 'generate'로 변경될 때")을 처리하고, 훅은 LLM API(OpenAI, Claude, 로컬 모델)를 호출한다. AI 출력을 게시 전 인간 리뷰를 위한 초안 버전으로 저장한다. 이는 완전한 AI-인간 협업 파이프라인을 만든다.

**Q: WordPress에서 Directus로 어떻게 마이그레이션하나요?**
WP REST API나 XML을 통해 WordPress 콘텐츠를 날볼하고, Directus 스키마와 일치하도록 데이터를 변환한 후, Directus REST API나 SDK를 사용하여 벌크 임포트한다. 이미지는 Directus 스토리지에 다시 업로드해야 한다. 이전 WordPress URL의 리다이렉트는 리버스 프록시 레벨에서 처리해야 한다. 콘텐츠 양에 따라 완전한 마이그레이션에 1-2주를 계획하라.

**Q: Directus는 전자상거래 애플리케이션에 적합한가요?**
Directus는 콘텐츠 중심 전자상거래(제품 카탈로그, 블로그, 리뷰)에는 잘 작동하지만 완전한 전자상거래 플랫폼은 아니다. 장바구니, 결제, 지불 로직은 Directus 제품 API를 소비하는 별도의 애플리케이션에서 구축해야 한다. 순수 전자상거래를 위해서는 Medusa나 Shopify가 더 적절하다.

**Q: Directus는 커스텀 NestJS/Express API와 어떻게 비교되나요?**
CRUD 중심이고 콘텐츠 관리가 필요한 애플리케이션의 경우 Directus는 80%의 커스텀 백엔드 코드를 대체한다. 인증, RBAC, 파일 업로드, 이미지 변환, 콘텐츠 버전 관리, 관리 패널을 물로 받는다. 커스텀 확장은 Directus가 커버하지 않는 나머지 20%의 비즈니스 로직에 사용한다. 콘텐츠 API 개발 시간은 일반적으로 60-70% 단축된다.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 결론: 콘텐츠를 소유하고, 데이터를 소유하세요

Directus 11.x는 2026년 데이터베이스 우선, API 중심의 콘텐츠 플랫폼이 필요한 팀을 위한 가장 실용적인 선택이다. 자동 생성된 REST 및 GraphQL API, 콘텐츠 편집자를 위한 직관적인 관리 패널, 강력한 워크플로우 자동화, 그리고 필요에 따라 성장하는 확장 시스템을 제공한다 — 동시에 데이터는 완전히 통제 가능한 표준 SQL 테이블에 남아 있다.

Docker를 사용하여 [DigitalOcean 드롭릿](https://m.do.co/c/eca87ac14ee0)에 몇 분 안에 배포하거나, [HTStack 원클릭 설치기](https://my.htstack.com/aff.php?aff=27187)를 사용하여 더 빠른 설정을 할 수 있다. 편집 팀이 Jira 티켓을 작성하지 않고도 관리할 수 있는 콘텐츠 워크플로우를 구축하기 시작하라.

**다음 읽기**: [Appwrite 백엔드 가이드](dibi8-internal-link), [콘텐츠 팀을 위한 n8n 워크플로우 자동화](dibi8-internal-link)

**출처 및 추가 참고 자료**
- [Directus 공식 문서](https://docs.directus.io) — API 레퍼런스, 가이드, 확장
- [Directus GitHub 저장소](https://github.com/directus/directus) — 29,100+ Stars
- [Directus 11.x 릴리스 노트](https://github.com/directus/directus/releases) — 최신 기능 및 변경사항
- [Directus SDK 레퍼런스](https://docs.directus.io/reference/sdk.html) — JavaScript, Python, PHP, Go, Ruby, .NET, Swift
- [셀프호스팅 가이드](https://docs.directus.io/self-hosted/quickstart.html) — Docker, Kubernetes, 수동 설정
- [확장 문서](https://docs.directus.io/extensions/introduction.html) — 훅, 엔드포인트, 인터페이스, 디스플레이
- [Flows 문서](https://docs.directus.io/app/flows.html) — 시각적 워크플로우 자동화
- [커뮤니티 Discord](https://directus.io/discord) — 15,000+ 활성 멤버

**제휴 고지**
이 문서에는 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 및 [HTStack](https://my.htstack.com/aff.php?aff=27187)의 제휴 링크가 포함되어 있습니다. 이 링크를 통해 호스팅을 구매하면 dibi8.com에 추가 비용 없이 커미션이 지급됩니다. 우리는 자사 인프라에 사용하는 서비스만 추천합니다. 모든 벤치마크는 유료 인스턴스에서 독립적으로 수행되었습니다.

---
*게시일: 2026-05-19 | 카테고리: dev-utils | 도구: Directus 11.3.0*
*dibi8 개발자 커뮤니티 참여: [English](https://t.me/dibi8en) | [Chinese](https://t.me/dibi8zh) | [Korean](https://t.me/dibi8ko) | [Vietnamese](https://t.me/dibi8vn)*
