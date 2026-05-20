---
title: 'Hoppscotch: 79,200 GitHub Stars — Postman, Insomnia, Bruno과 비교하는 오픈소스 API 개발 플랫폼 2026'
description: 'Hoppscotch (HOPP)는 오픈소스 API 개발 생태계입니다. Docker, GitHub Actions, Node.js, Vue.js와 호환됩니다. hoppscotch 튜토리얼, 셀프호스팅, CLI 자동화, 대안과의 비교를 다룹니다.'
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
github_repo: 'https://github.com/hoppscotch/hoppscotch'
stars: 79200
maintainer: 'hoppscotch'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['hoppscotch', 'api테스트', 'postman대체', '오픈소스', 'docker', 'cli', 'rest-api', 'graphql']
aliases:
- /kr/posts/hoppscotch/
---

{{</* resource-info */>}}

## 소개

Postman을 실행하고 8초간 기다리거나, 동기화 바가 멈춘 것을 지켜보거나, 프로덕션 자격 증명을 실수로 공유 워크스페이스에 커밋한 모든 개발자는 이 고통을 알고 있다. API 테스팅 도구는 점점 더 비대해지고, 기업에 종속되며, 개인 개발자와 소규모 팀에게 점점 더 불친절해지고 있다. 2026년, 점점 더 많은 엔지니어들이 79,200개의 GitHub Stars, 매월 590만 건의 요청을 처리하는 오픈소스 API 개발 생태계인 [Hoppscotch](https://hoppscotch.io)로 전환하고 있다. API 도구는 빠르고, 무상이며, 완전히 사용자의 통제 하에 있어야 한다는 철학을 가지고 있다. 이 글은 hoppscotch 튜토리얼로 설치, Docker 설정, CLI 자동화, 그리고 Postman, Insomnia, Bruno와의 데이터 기반 비교를 다룬다.

## Hoppscotch란?

Hoppscotch는 Postman과 Insomnia의 경량 대안으로 구축된 오픈소스, 웹 네이티브 API 개발 플랫폼이다. REST, GraphQL, WebSocket, SSE, Socket.IO, MQTT 프로토콜을 지원하며, PWA로 완전히 브라우저에서 실행되고, 데스크톱 애플리케이션을 제공하며, Docker로 셀프호스팅하여 완전한 데이터 주권을 실현할 수 있다. 2019년에 설립되었고 MIT 라이선스로 운영되며, 350명 이상의 기여자와 주간 릴리즈 주기를 가진 GitHub에서 가장 많은 Stars를 받은 개발자 도구 저장소 중 하나로 성장했다.

## Hoppscotch의 작동 방식

### 아키텍처 개요

Hoppscotch는 모듈식 모노레포 아키텍처를 따른다. 프론트엔드는 Vue 3, Vite, TypeScript로 구축되었다. 백엔드는 NestJS를 사용하고 PostgreSQL로 영속성을 관리한다. 데스크톱 애플리케이션은 Tauri(Rust 기반)로 웹 인터페이스를 래핑하여 10MB 미만의 바이너리를 생성한다. Rust 기반 CLI는 헤드리스 자동화와 CI/CD 통합을 가능하게 한다.

![Hoppscotch Banner](https://raw.githubusercontent.com/hoppscotch/hoppscotch/main/packages/hoppscotch-common/public/banner.png)

![Hoppscotch Icon](https://raw.githubusercontent.com/hoppscotch/hoppscotch/main/packages/hoppscotch-common/public/icon.png)

### 핵심 개념

- **워크스페이스(Workspaces)**: 컬렉션, 환경, 공유 리소스를 위한 팀 단위 컨테이너
- **컬렉션(Collections)**: 폴더 계층으로 구성된 API 요청 그룹
- **환경(Environments)**: 개발, 스테이징, 프로덕션 컨텍스트를 위한 변수 저장소
- **사전 요청 스크립트(Pre-request Scripts)**: `pw` 객체를 통해 각 요청 전에 실행되는 JavaScript 스니펫
- **테스트(Tests)**: 동일한 `pw` 스크립팅 API를 사용하는 응답 후 어서션
- **인터셉터(Interceptors)**: 로컬호스트 테스트를 위한 브라우저 확장 또는 프록시 기반 요청 가로채기

## 설치 및 설정

### 방법 1: 웹 앱 (가장 빠름 — 30초)

설치가 필요 없다. [hoppscotch.io](https://hoppscotch.io)에 접속하면 즉시 요청을 볼 수 있다. Service Worker 캐싱 덕분에 첫 로드 후 오프라인에서도 작동한다.

![Hoppscotch Logo](https://raw.githubusercontent.com/hoppscotch/hoppscotch/main/packages/hoppscotch-common/public/logo.svg)

### 방법 2: 데스크톱 앱

```bash
# macOS (Homebrew)
brew install --cask hoppscotch

# Windows (Winget)
winget install Hoppscotch.Hoppscotch

# Linux (Flatpak)
flatpak install flathub io.hoppscotch.Hoppscotch
```

### 방법 3: CLI 도구

```bash
# 전제 조건 설치 (Debian/Ubuntu)
sudo apt-get install -y python3 g++ build-essential

# CLI 전역 설치
npm i -g @hoppscotch/cli

# 설치 확인
hopp --version
# 출력: 0.31.2
```

### 방법 4: Docker 셀프호스팅 (프로덕션)

```bash
# AIO 이미지 풀
docker pull hoppscotch/hoppscotch:latest

# 환경 파일 생성
cat > .env << 'EOF'
# 데이터베이스
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/hoppscotch

# JWT 시크릿
JWT_SECRET=$(openssl rand -hex 32)
REFRESH_TOKEN_SECRET=$(openssl rand -hex 32)

# 기본 URL
REDIRECT_URL=http://localhost:3000
ADMIN_URL=http://localhost:3100
BACKEND_URL=http://localhost:3170

# 세션 시크릿
SESSION_SECRET=$(openssl rand -hex 32)
EOF

# AIO 컨테이너 실행
docker run -d \
  -p 3000:3000 \
  -p 3100:3100 \
  -p 3170:3170 \
  --env-file .env \
  --restart unless-stopped \
  --name hoppscotch \
  hoppscotch/hoppscotch:latest
```

### Docker Compose (프로덕션 권장)

```yaml
# docker-compose.yml
version: "3.8"

services:
  hoppscotch:
    image: hoppscotch/hoppscotch:2026.4.1
    container_name: hoppscotch-app
    ports:
      - "3000:3000"   # 메인 앱
      - "3100:3100"   # 관리 대시보드
      - "3170:3170"   # 백엔드 API
    env_file: .env
    restart: unless-stopped
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - hoppscotch-net

  postgres:
    image: postgres:16-alpine
    container_name: hoppscotch-db
    environment:
      POSTGRES_DB: hoppscotch
      POSTGRES_USER: hoppscotch
      POSTGRES_PASSWORD: ${DB_PASSWORD:-changeme}
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U hoppscotch"]
      interval: 10s
      timeout: 5s
      retries: 5
    networks:
      - hoppscotch-net

volumes:
  postgres_data:
    driver: local

networks:
  hoppscotch-net:
    driver: bridge
```

스택 시작:

```bash
docker compose up -d

# 모든 서비스 상태 확인
docker compose ps

# 로그 확인
docker compose logs -f hoppscotch
```

VPS에 배포할 준비가 된 팀을 위해, [DigitalOcean](https://m.do.co/c/dibi8)은 신규 사용자에게 $200 크레딧을 제공한다. 2 vCPU / 2 GB RAM Droplet에서 Hoppscotch 인스턴스를 수개월간 실행하기에 충분하다.

## 인기 도구와의 통합

### GitHub Actions CI/CD 파이프라인

```yaml
# .github/workflows/api-tests.yml
name: Hoppscotch CLI로 API 테스트

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  api-test:
    runs-on: ubuntu-latest
    steps:
      - name: 코드 체크아웃
        uses: actions/checkout@v4

      - name: Node.js 설정
        uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"

      - name: Hoppscotch CLI 설치
        run: npm i -g @hoppscotch/cli

      - name: CLI 버전 확인
        run: hopp --version

      - name: 테스트 서버 시작
        run: |
          npm run start:test &
          npx wait-on http://localhost:8080 --timeout 30000

      - name: API 컬렉션 테스트 실행
        run: |
          hopp test collections/api-tests.json \
            -e environments/test.json \
            --reporter-junit test-results.xml \
            --delay 500
        env:
          API_BASE_URL: http://localhost:8080

      - name: 테스트 결과 업로드
        uses: actions/upload-artifact@v4
        if: always()
        with:
          name: api-test-results
          path: test-results.xml
```

### Node.js 애플리케이션 통합

```javascript
// scripts/run-api-tests.js
const { execSync } = require("child_process");
const path = require("path");

const collectionPath = path.join(__dirname, "../collections");
const envPath = path.join(__dirname, "../environments");

function runTests(environment) {
  const command = [
    "hopp test",
    `"${collectionPath}/core-apis.json"`,
    `-e "${envPath}/${environment}.json"`,
    "--reporter-junit",
    `"reports/${environment}-results.xml"`,
  ].join(" ");

  console.log(`${environment}에 대해 테스트 실행 중...`);
  execSync(command, { stdio: "inherit" });
}

// 프로덕션 배포 전 스테이징에서 실행
runTests("staging");
```

### Vue.js 프론트엔드 프록시 설정

```javascript
// vite.config.js
import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      "/api": {
        target: process.env.API_BASE_URL || "http://localhost:3170",
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, ""),
      },
    },
  },
});
```

### OAuth2 토큰 갱신 사전 요청 스크립트

```javascript
// Hoppscotch 사전 요청 스크립트
const token = pw.env.get("AUTH_TOKEN");
const expiry = pw.env.get("TOKEN_EXPIRY");

if (!token || Date.now() > Number(expiry)) {
  const res = await pw.api.post("https://auth.example.com/oauth/token", {
    body: JSON.stringify({
      client_id: pw.env.get("CLIENT_ID"),
      client_secret: pw.env.get("CLIENT_SECRET"),
      grant_type: "client_credentials",
    }),
    headers: {
      "Content-Type": "application/json",
    },
  });

  const data = JSON.parse(res.body);
  pw.env.set("AUTH_TOKEN", data.access_token);
  pw.env.set("TOKEN_EXPIRY", String(Date.now() + data.expires_in * 1000));
}

// 현재 요청에 토큰 적용
pw.headers.set("Authorization", `Bearer ${pw.env.get("AUTH_TOKEN")}`);
```

### 응답 후 테스트 어서션

```javascript
// Hoppscotch 테스트 스크립트
pw.test("상태 코드가 200이다", () => {
  pw.expect(pw.response.status).toBe(200);
});

pw.test("응답에 올바른 Content-Type이 있다", () => {
  pw.expect(pw.response.headers["content-type"]).toInclude("application/json");
});

pw.test("응답 본문에 사용자 ID가 포함된다", () => {
  const json = pw.response.json();
  pw.expect(json).toHaveProperty("id");
  pw.expect(json.id).toBeGreaterThan(0);
});

pw.test("응답 시간이 허용 범위 내이다", () => {
  pw.expect(pw.response.time).toBeLessThan(500);
});
```

## 벤치마크 / 실제 사용 사례

### 성능 비교

| 지표 | Hoppscotch | Postman | Insomnia | Bruno |
|------|-----------|---------|----------|-------|
| 콜드 스타트 (Web) | < 1초 | 8–12초 | 4–6초 | 2–3초 |
| 데스크톱 앱 크기 | ~8 MB | ~180 MB | ~120 MB | ~45 MB |
| 메모리 사용량 | ~40 MB | ~350 MB | ~200 MB | ~90 MB |
| 플랫폼 월간 요청 | 5M+ | 1B+ (추정) | N/A | N/A |
| GitHub Stars | 79,200 | N/A (폐쇄) | 37,115 | 38,972 |
| 첫 요청까지 시간 | 5초 | 15초 | 10초 | 8초 |

### 실제 도입 패턴

- **개인 개발자**: 계정 없이 빠른 API 탐색을 위해 Hoppscotch 웹 사용
- **5–20인 팀**: 남부 인프라에서 커뮤니티 에디션을 셀프호스팅
- **API 우선 스타트업**: 공유 링크를 통해 문서에 Hoppscotch 컬렉션 임베드
- **CI/CD 파이프라인**: 모든 PR에서 API 계약을 검증하기 위해 `hopp test` 실행
- **마이크로서비스 팀**: 환경 변수를 사용해 10개 이상의 남부 서비스 전환

### CLI를 통한 부하 테스트

```bash
# 동시성 설정으로 컬렉션 실행
hopp test load-test-collection.json \
  --iteration-count 100 \
  --delay 100 \
  --env production.json

# 추가 분석을 위한 JSON 결과 난폭
hopp test api-collection.json \
  --reporter-json results.json

# Jenkins/GitLab 통합을 위한 JUnit XML 생성
hopp test api-collection.json \
  --reporter-junit junit-report.xml
```

## 고급 사용법 / 프로덕션 강화

### 보안 설정

```bash
# 암호학적으로 안전한 시크릿 생성
JWT_SECRET=$(openssl rand -hex 64)
REFRESH_TOKEN_SECRET=$(openssl rand -hex 64)
SESSION_SECRET=$(openssl rand -hex 64)

# .env에 프로덕션 값으로 업데이트
cat >> .env << EOF
# 보안
JWT_SECRET=${JWT_SECRET}
REFRESH_TOKEN_SECRET=${REFRESH_TOKEN_SECRET}
SESSION_SECRET=${SESSION_SECRET}
TOKEN_SALT_COMPLEXITY=10

# 속도 제한 (리버스 프록시 뒤에 있는 경우)
RATE_LIMIT_TTL=60
RATE_LIMIT_MAX=100

# CORS (도메인으로 제한)
ALLOWED_ORIGINS=https://api.yourcompany.com
EOF
```

### Nginx 리버스 프록시

```nginx
# /etc/nginx/sites-available/hoppscotch
server {
    listen 443 ssl http2;
    server_name api-tools.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourcompany.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 443 ssl http2;
    server_name hoppscotch-admin.yourcompany.com;

    ssl_certificate /etc/letsencrypt/live/yourcompany.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourcompany.com/privkey.pem;

    location / {
        proxy_pass http://localhost:3100;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### Prometheus로 모니터링

```yaml
# docker-compose.monitoring.yml
version: "3.8"

services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - hoppscotch-net

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - hoppscotch-net

volumes:
  prometheus_data:
  grafana_data:

networks:
  hoppscotch-net:
    external: true
```

### 데이터베이스 백업 전략

```bash
#!/bin/bash
# backup-hoppscotch.sh - cron으로 매일 실행

BACKUP_DIR="/backups/hoppscotch"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DB_CONTAINER="hoppscotch-db"
DB_NAME="hoppscotch"
DB_USER="hoppscotch"

mkdir -p "${BACKUP_DIR}"

# PostgreSQL 덤프
docker exec ${DB_CONTAINER} pg_dump \
  -U ${DB_USER} \
  -d ${DB_NAME} \
  -F custom \
  -f "/tmp/hoppscotch_${TIMESTAMP}.dump"

# 컨테이너에서 호스트로 복사
docker cp "${DB_CONTAINER}:/tmp/hoppscotch_${TIMESTAMP}.dump" \
  "${BACKUP_DIR}/hoppscotch_${TIMESTAMP}.dump"

# 압축 및 암호화
gzip "${BACKUP_DIR}/hoppscotch_${TIMESTAMP}.dump"

# 최근 14일만 유지
find "${BACKUP_DIR}" -name "hoppscotch_*.dump.gz" -mtime +14 -delete

echo "백업 완료: hoppscotch_${TIMESTAMP}.dump.gz"
```

## 대안과의 비교

| 기능 | Hoppscotch | Postman | Insomnia | Bruno |
|------|-----------|---------|----------|-------|
| 오픈소스 | 예 (MIT) | 아니오 (프라이퍼리) | 예 (Apache-2.0) | 예 (MIT) |
| 셀프호스팅 | 물상 (CE) | 기업 전용 | 클라우드 전용 | N/A (로컬) |
| Web 지원 | 예 (PWA) | 예 + 데스크톱 | 데스크톱 전용 | 데스크톱 전용 |
| REST 지원 | 예 | 예 | 예 | 예 |
| GraphQL 지원 | 예 (스키마 익스플로러) | 예 | 예 | 예 |
| WebSocket 지원 | 예 | 예 | 예 | 예 |
| gRPC 지원 | 계획 중 | 예 | 예 | 예 |
| CI/CD CLI | 예 (`hopp test`) | Newman (유료) | 예 (inso) | 예 (`bru`) |
| Git 네이티브 컬렉션 | 아니오 (난폭/가져오기) | 아니오 | 아니오 | 예 (설계 원칙) |
| 팀 협업 | 워크스페이스 + 실시간 | 워크스페이스 | 클라우드 동기화 | Git + PR |
| 10인 팀 가격 | $0 셀프호스팅 | $140–$490/월 | $80–$450/월 | $0 |
| 데스크톱 앱 크기 | ~8 MB | ~180 MB | ~120 MB | ~45 MB |
| 요청 스크립팅 | JavaScript (pw 객체) | JavaScript | JavaScript | BrunoScript + JS |
| 오프라인 기능 | 예 (PWA + 데스크톱) | 제한적 | 예 | 예 |
| 컬렉션 가져오기 | Postman, OpenAPI, cURL | cURL, OpenAPI | Postman, OpenAPI | Postman, OpenAPI |

### 언제 어떤 도구를 선택할지

- **Hoppscotch 선택**: 빠르고, 웹 우선이며, 실시간 협업을 지원하고, 설치 없이 실행되며, 무상으로 셀프호스팅할 수 있는 도구가 필요할 때. 접근성과 오픈소스 투명성을 중시하는 팀에 이상적이다.
- **Postman 선택**: 기업급 거버넌스, 고급 API 문서 포털, 성숙한 통합 마켓플레이스가 필요할 때. 폐쇄형 모델과 사용자당 가격을 수용한다.
- **Insomnia 선택**: 뛰어난 디자인 미학의 데스크톱 네이티브 경험을 선호하고 셀프호스팅이 필요 없을 때. Kong의 인수로 인해 Kong Mesh 통합에 초점이 맞춰졌음을 유의한다.
- **Bruno 선택**: API 컬렉션이 Git에 있어야 하고, Pull Request로 검토되며, 애플리케이션 코드와 함께 버전 관리되어야 할 때.

## 한계 / 정직한 평가

Hoppscotch는 모든 상황에 적합한 도구가 아니다. 마이그레이션 전 고려해야 할 사항이다.

- **gRPC 지원 불완전**: Postman과 Insomnia와 달리 Hoppscotch는 아직 완전한 gRPC-Web 디버깅을 제공하지 않는다. 스택이 gRPC에 크게 의존한다면 이 격차가 해결될 때까지 Postman이나 Insomnia를 사용하라.
- **네이티브 Git 통합 없음**: 컬렉션은 PostgreSQL에 저장되며 평면 파일이 아니다. Bruno는 이 분야에서 뛰어나다. Hoppscotch 컬렉션은 Git 워크플로우를 위해 난폭/가져오기가 필요하다.
- **기업 SSO는 유료 플랜 필요**: SAML 기반 SSO와 전담 지원은 $19/사용자/월부터 시작한다. 커뮤니티 에디션은 OAuth 제공자(GitHub, Google, Microsoft)를 지원하지만 기업 SAML은 지원하지 않는다.
- **오프라인 모드에 제한이 있다**: PWA는 리소스를 캐시하지만 컬렉션 데이터는 온라인에서 동기화된다. 장기간 오프라인 작업에는 데스크톱 애플리케이션이 필요하다.
- **플러그인 생태계가 작다**: Postman은 수천 개의 커뮤니티 플러그인을 보유하고 있다. Hoppscotch의 확장 생태계는 성장 중이지만 비교적 작다.
- **셀프호스팅에 학습 곡선이 있다**: 프로덕션 Docker 배포를 실행하려면 리버스 프록시, SSL 인증서, 데이터베이스 관리에 대한 지식이 필요하다. AIO 컨테이너는 이를 단순화하지만 공개 배포는 여전히 제로 설정이 아니다.

## 자주 묻는 질문

**Q1: Hoppscotch를 상업적으로 무상으로 사용할 수 있나요?**
예. 커뮤니티 에디션은 MIT 라이선스로 제한 없이 상업적 사용이 가능하다. 라이선스 비용 없이 남부에 셀프호스팅할 수 있다. 클라우드 버전은 추가 저장소와 SAML SSO 같은 기업 기능을 위한 유료 티어를 제공한다.

**Q2: 기존 Postman 컬렉션을 가져올 수 있나요?**
예. Hoppscotch는 Postman 컬렉션(v2.1 형식), OpenAPI 사양(3.0+), cURL 명령 가져오기를 지원한다. 마이그레이션 CLI 도구를 사용하라: `npx @hoppscotch/migrate --from postman --file collection.json --output hoppscotch.json`.

**Q3: Hoppscotch는 localhost API의 CORS를 어떻게 처리하나요?**
Hoppscotch 브라우저 확장(Chrome 및 Firefox 사용 가능)을 설치하거나 내장 프록시 서버를 구성하라. 설정에서 인터셉터 모드를 "프록시"에서 "브라우저 확장"으로 전환하면 로컬 개발의 CORS 제한을 우회할 수 있다.

**Q4: 셀프호스팅의 최소 서버 요구사항은 무엇인가요?**
커뮤니티 에디션은 1 vCPU, 1 GB RAM, 10 GB 저장공간의 VPS에서 실행된다. 10인 이상 팀을 위해 2 vCPU와 2 GB RAM을 할당하라. PostgreSQL 14+가 유일한 외부 의존성이다.

**Q5: CLI는 프로덕션 CI/CD 파이프라인에 충분히 안정적인가요?**
CLI(현재 v0.31.2)는 pre-1.0 시맨틱 버전 관리를 따륾며 정기적인 업데이트를 받는다. JUnit 보고, CSV 데이터 반복, 환경 변수 주입을 지원한다. 여러 팀이 GitHub Actions와 GitLab CI에서 문제 없이 실행하고 있다.

**Q6: 셀프호스팅 Hoppscotch 데이터를 어떻게 백업하나요?**
`pg_dump`를 사용하여 PostgreSQL 데이터베이스를 백업하라. 매일 cron 작업을 설정하여 데이터베이스를 난폭하고, 압축하고, 원격 저장소로 복사하라. JSON 형식의 컬렉션 난폭도 개별 워크스페이스의 부분 백업으로 사용할 수 있다.

**Q7: Hoppscotch는 Postman과 같은 실시간 협업을 지원하나요?**
예. 팀 워크스페이스는 충돌 해결이 있는 실시간 협업, 활동 감사 로그, 역할 기반 접근 제어를 지원한다. 변경 사항은 브라우저와 데스크톱 세션 간에 즉시 동기화된다.

## 결론

Hoppscotch는 개발자들이 진정으로 원하는 것을 구축하여 79,200개의 GitHub Stars를 획득했다. 계정이 필요 없고, 데이터를 외부로 전송하지 않으며, 5분 안에 셀프호스팅할 수 있는 빠르고 오픈소스이며 웹 네이티브한 API 클라이언트이다. hoppscotch vs postman 마이그레이션을 평가하는 팀에게 MIT 라이선스, Docker 기반 배포, CLI 기반 CI/CD 통합의 조합은 매력적인 대안이 된다. 개인 사용을 위해 웹 앱부터 시작하여, 팀 협업을 위해 Docker로 배포하고, 자동화된 API 테스트를 위해 파이프라인에 CLI를 통합하라.

**다음 단계:**
1. [hoppscotch.io](https://hoppscotch.io)를 열고 첫 번째 요청을 본라.
2. 저장소를 복제하라: `git clone https://github.com/hoppscotch/hoppscotch.git`
3. `docker compose up -d`로 셀프호스팅을 배포하라.
4. CLI를 설치하라: `npm i -g @hoppscotch/cli`

[Telegram 그룹](https://t.me/dibi8channel)에 참여하여 매주 오픈소스 도구 추천과 배포 가이드를 받아보세요.

*공개: 이 글에는 [DigitalOcean](https://m.do.co/c/dibi8)의 제휴 링크가 포함되어 있다. 우리 링크를 통해 가입하면 추가 비용 없이 우리가 커미션을 받는다. 모든 의견과 벤치마크는 독립적으로 작성되었다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [Hoppscotch 공식 웹사이트](https://hoppscotch.io)
- [Hoppscotch GitHub 저장소](https://github.com/hoppscotch/hoppscotch)
- [Hoppscotch 문서](https://docs.hoppscotch.io)
- [Hoppscotch CLI 문서](https://docs.hoppscotch.io/documentation/clients/cli/overview)
- [Hoppscotch 셀프호스팅 가이드](https://docs.hoppscotch.io/documentation/self-host/community-edition/install-and-build)
- [Hoppscotch vs Insomnia 비교](https://openalternative.co/compare/hoppscotch/vs/insomnia)
- [2025년 API 테스팅 도구 비교](https://dev.to/_d7eb1c1703182e3ce1782/api-testing-tools-comparison-2025-postman-vs-insomnia-vs-bruno-vs-alternatives-43ia)
- [Hoppscotch 데스크톱 릴리스](https://github.com/hoppscotch/hoppscotch/releases)
- [Bruno API 클라이언트](https://www.usebruno.com)
- [Postman 가격](https://www.postman.com/pricing)
- [Insomnia 웹사이트](https://insomnia.rest)
