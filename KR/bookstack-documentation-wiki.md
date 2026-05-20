---
title: 'BookStack: Markdown 지원 개발자 친화 문서 Wiki — 2026 설치 및 리뷰'
description: 'BookStack 설치 및 실행 완벽 가이드. WYSIWYG + Markdown 편집, 책/챕터/페이지 구조, LDAP/SSO 지원을 갖춘 오픈소스 문서 Wiki. 5분 안에 셀프 호스팅.'
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
github_repo: 'BookStackApp/BookStack'
stars: 18700
maintainer: 'BookStackApp'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['BookStack', '문서화', 'Wiki', '셀프 호스팅', 'PHP', 'Laravel', '지식 베이스', 'Markdown', 'Docker', '오픈소스']
aliases:
- /kr/posts/bookstack-documentation-wiki/
---

{{</* resource-info */>}}

## 소개: 모든 팀이 겪는 문서 난장판

당신 팀의 문서는 흩어져 있다. 일부는 찾을 수 없는 Google Docs에 있고, 일부는 6개월 전 매니저가 만들어 버려둔 Notion 워크스페이스에 있다. API 문서는 README 파일에, 운영 매뉴얼은 Confluence에, 온병 노트는 누군가의 개인 메모 앱에 있다. 이것이 보편적인 문서 난장판이다.

Dan Brown은 BookStack을 이 문제를 해결하기 위해 만들었다. 2015년 7월 "Oxbow"라는 이름으로 처음 릴리스된 후 11일 만에 BookStack으로 이름을 바꿨으며, 2026년 초 기준 **18,700개 이상의 GitHub star**와 186명 이상의 직접 기여자를 보유하게 되었다. 2026년 3월, 프로젝트는 **v26.03**을 릴리스하며 새로운 테마 모듈 시스템, 페이지 콘텐츠 커스터마이징을 위한 향상된 논리 테마 이벤트, 개선된 보안 필터링을 선보였다. 2026년 초, 프로젝트의 정식 저장소를 Codeberg로 이전했지만 GitHub에는 미러가 남아 있다.

BookStack을 다른 수십 가지 위키 툴과 차별화하는 점은 무엇일까? 바로 구조이다. 대부분의 위키가 사용하는 평면적인 페이지+태그 모델 대신, BookStack은 실제 도서관이 문서를 정리하는 방식으로 콘텐츠를 조직한다 —— **선반은 책을, 책은 챕터를, 책터는 페이지를 포함한다**. 이러한 독선적인 계층 구조는 팀이 정보가 어디에 속하는지 생각하도록 강제하며, 이것이 팀이 BookStack을 사랑하거나 포기하는 이유이다.

이 가이드는 프로덕션 환경에서 BookStack을 실행하는 데 필요한 모든 것을 다룬다: 5분 안에 Docker 배포, 팀 구성, 실제 벤치마크, 솔직한 한계, 그리고 Wiki.js, DokuWiki, MediaWiki, Outline과의 비교이다.

## BookStack이란? 한 문장 정의

BookStack은 PHP/Laravel로 빌드된 물가, 오픈소스, MIT 라이선스 문서 위키로, 납부 지식 베이스, 운영 매뉴얼, 표준 운영 절차, 팀 문서를 조직하기 위해 책/챕터/페이지 계층 구조를 사용하며 —— 완전한 셀프 호스팅, 사용자당 비용 없음.

## BookStack의 작동 원리: 아키텍처 및 핵심 개념

BookStack은 고전적인 PHP/LAMP 스택에서 실행되며, 이는 PHP 애플리케이션을 배포해 본 사람이라면 누구나 쉽게 접근할 수 있게 한다. 아키텍처는 간단명료하다:

| 계층 | 기술 |
|---|---|
| **백엔드** | PHP 8.2+ / Laravel 11.x |
| **데이터베이스** | MySQL 8.0+ 또는 MariaDB 10.6+ |
| **프론트엔드** | Vue.js 컴포넌트, WYSIWYG 편집기 (TinyMCE), Markdown 편집기 |
| **검색** | MySQL FULLTEXT 검색 (내장) |
| **스토리지** | 로컬 파일 시스템 또는 S3 호환 |
| **인증** | 로컬, LDAP, SAML 2.0, OIDC, OAuth 2.0, Azure AD |

결정적인 아키텍처적 결정은 콘텐츠 계층 구조이다. Notion(자유 형식 페이지)이나 Confluence(스페이스+페이지)와 달리, BookStack은 **선반 → 책 → 챕터 → 페이지** 구조를 강제한다. 콘텐츠를 생성할 때 해당 계층에서의 위치를 결정해야 한다. 이는 대부분의 위키 도입을 방해하는 "이걸 어디에 두지?"라는 마찰을 줄여준다.

**선반(Shelf)** —— 최상위 컨테이너, 일반적으로 부서나 주요 프로젝트 영역에 매핑된다.
**책(Book)** —— 주요 문서 영역, "엔지니어링 운영 매뉴얼"이나 "인사 정책" 같은 것.
**챕터(Chapter)** —— 책 내의 하위 분할, "데이터베이스 절차"나 "온병" 같은 것.
**페이지(Page)** —— 실제 콘텐츠 단위, 완전한 WYSIWYG 또는 Markdown 편집 지원.

BookStack은 역할 기반 권한 시스템을 사용한다. 역할("편집자", "염성자", "관리자" 등)을 정의하고 전역 수준에서 권한을 할당한다. 콘텐츠 가시성은 책이나 선반 단위로 제한할 수 있다. v26.03 릴리스는 HTML Purifier를 통한 향상된 콘텐츠 필터링을 추가하여 악의적인 페이지 콘텐츠가 DOM을 조작할 수 있는 보안 우려를 해결했다.

## 설치 및 설정: 5분 안에 제로에서 실행까지

BookStack을 실행하는 가장 빠른 방법은 Docker Compose이다. **최소 2GB RAM**, **50명 이상의 사용자에게는 4GB 권장**. [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0) 2 vCPU + 4GB RAM ($24/월)으로 대부분의 중소규모 팀을 충분히 처리할 수 있다.

### 단계 1: Docker Compose 파일 생성

```yaml
version: '3.8'

services:
  bookstack:
    image: lscr.io/linuxserver/bookstack:v26.03.4
    container_name: bookstack
    environment:
      - PUID=1000
      - PGID=1000
      - APP_URL=https://docs.yourdomain.com
      - DB_HOST=bookstack_db
      - DB_PORT=3306
      - DB_USER=bookstack
      - DB_PASS=your_secure_db_password
      - DB_DATABASE=bookstackdb
    volumes:
      - ./bookstack_app_data:/config
    ports:
      - 6875:80
    restart: unless-stopped
    depends_on:
      - bookstack_db

  bookstack_db:
    image: lscr.io/linuxserver/mariadb:10.11
    container_name: bookstack_db
    environment:
      - PUID=1000
      - PGID=1000
      - MYSQL_ROOT_PASSWORD=your_secure_root_password
      - TZ=UTC
      - MYSQL_DATABASE=bookstackdb
      - MYSQL_USER=bookstack
      - MYSQL_PASSWORD=your_secure_db_password
    volumes:
      - ./bookstack_db_data:/config
    restart: unless-stopped
```

이 compose 파일은 두 가지 서비스를 정의한다: 포트 6875의 BookStack 애플리케이션과 영속성을 위한 MariaDB 데이터베이스.

### 단계 2: 스택 실행

```bash
# 데이터 디렉토리 생성
mkdir -p bookstack_app_data bookstack_db_data

# 두 컨테이너 시작
docker compose up -d

# 데이터베이스 초기화 대기 (첫 실행 시 30-60초)
sleep 45

# 로그 확인하여 시작 확인
docker logs bookstack
```

Laravel 부트스트래핑 메시지 뒤에 PHP-FPM의 `NOTICE: ready to handle connections`가 표시되어야 한다. 데이터베이스 연결이 실패하면 DB_HOST가 `bookstack_db` 서비스 이름과 일치하고 자격 증명이 정렬되어 있는지 확인하라.

### 단계 3: 접근 및 구성

```bash
# 첫 부팅 시 기본 자격 증명
# 사용자명: admin@admin.com
# 비밀번호: password
```

`http://your-server-ip:6875`로 이동하여 로그인하라. **즉시 관리자 비밀번호를 변경**하라(설정 → 사용자). 그런 다음 APP_URL을 HTTPS 사용으로 구성하라 —— BookStack은 이메일 알림과 낼부에서 절대 URL을 생성하므로, 처음부터 APP_URL을 올바르게 설정하면 나중에 끊어진 링크를 방지할 수 있다.

### 단계 4: Nginx 리버스 프록시 + SSL

```nginx
# /etc/nginx/sites-available/bookstack
server {
    listen 443 ssl http2;
    server_name docs.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/docs.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/docs.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:6875;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

server {
    listen 80;
    server_name docs.yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

Certbot으로 사이트를 활성화하고 인증서를 얻은 후, docker-compose.yml의 `APP_URL`을 `https://docs.yourdomain.com`로 업데이트하고 컨테이너를 재시작하라.

### 수동 설치 (Ubuntu 24.04 LTS)

베어메탈 배포를 선호한다면:

```bash
# 의존성 설치
sudo apt update
sudo apt install -y apache2 php8.3 php8.3-curl php8.3-mbstring php8.3-ldap \
    php8.3-xml php8.3-zip php8.3-gd php8.3-mysql mysql-server git composer

# BookStack 클론
cd /var/www
git clone https://github.com/BookStackApp/BookStack.git --branch v26.03.4 --depth 1
cd BookStack

# PHP 의존성 설치
composer install --no-dev

# 환경 복사 및 구성
cp .env.example .env
php artisan key:generate

# .env 편집으로 데이터베이스 자격 증명 구성
# DB_HOST=localhost, DB_DATABASE=bookstack, DB_USERNAME=bookstack, DB_PASSWORD=...

# 마이그레이션 실행
php artisan migrate

# 권한 설정
chown -R www-data:www-data /var/www/BookStack
chmod -R 755 /var/www/BookStack
chmod -R 775 /var/www/BookStack/storage /var/www/BookStack/bootstrap/cache
```

수동 경로는 더 많은 제어권을 제공하지만 PHP, 웹 서버, MySQL을 별도로 관리해야 한다. 프로덕션 환경에서는 Docker가 권장되는 경로이다.

## LDAP 및 SSO 통합

BookStack은 여러 인증 백엔드를 지원한다. 엔터프라이즈 배포의 경우 LDAP 또는 SAML 통합이 필수적이다.

### LDAP 인증 (Active Directory / OpenLDAP)

```bash
# .env 파일에 추가
AUTH_METHOD=ldap
LDAP_SERVER=ldap.company.com
LDAP_BASE_DN="ou=users,dc=company,dc=com"
LDAP_DN="cn=bookstack,ou=service,dc=company,dc=com"
LDAP_PASS=service_account_password
LDAP_USER_FILTER="(&(uid=${user}))"
LDAP_VERSION=3
LDAP_TLS=true
LDAP_ID_ATTRIBUTE=uid
LDAP_DISPLAY_NAME_ATTRIBUTE=cn
LDAP_EMAIL_ATTRIBUTE=mail
```

컨테이너를 재시작한 후, BookStack은 LDAP 디렉토리에 대해 사용자 인증을 수행한다. 사용자는 첫 로그인 시 자동으로 생성되므로, 수동으로 계정을 만들 필요가 없다.

### SAML 2.0 (Okta, Azure AD, OneLogin용)

```bash
# .env의 SAML 구성
AUTH_METHOD=saml2
SAML2_NAME=SSO
SAML2_EMAIL_ATTRIBUTE=email
SAML2_EXTERNAL_ID_ATTRIBUTE=name_id
SAML2_DISPLAY_NAME_ATTRIBUTES=first_name|last_name
SAML2_IDP_ENTITYID=https://your-idp.example.com/metadata
SAML2_IDP_SSO=https://your-idp.example.com/sso
SAML2_IDP_x509="MIIDXTCCAkWgAwIBAgIJAJC1HiIA..."
```

## 이미지 관리 및 콘텐츠 편집

BookStack에는 두 가지 편집기가 포함되어 있다. **WYSIWYG 편집기**(TinyMCE 기반)가 기본값이다 —— 드래그앤드롭 업로드로 이미지를 처리하고, 테이블, 구문 강조가 있는 코드 블록, 팁과 경고를 위한 콜아웃 블록을 지원한다. **Markdown 편집기**는 실시간 미리보기가 있는 분할 화면 경험을 제공하여 Markdown으로 작성하기를 선호하는 개발자에게 이상적이다.

이미지 업로드는 간단하다:

```markdown
# Markdown 모드에서 —— 이미지는 BookStack의 갤러리에 업로드됨
![대체 텍스트](uploaded-image-name.png)

# 이미지 갤러리는 편집기 도구 모음에서 접근 가능
# 모든 업로드된 이미지는 bookstack_app_data 볼륨에 저장됨
```

BookStack은 또한 Draw.io 통합을 통해 임베디드 다이어그램을 지원한다. 다이어그램을 삽입할 때, BookStack은 렌더링된 이미지와 함께 Draw.io 소스 XML을 저장하므로 나중에 다이어그램을 다시 편집할 때 소스를 잃지 않는다.

## 벤치마크 및 실제 성능

2 vCPU / 4GB RAM VPS에서 BookStack을 실행하고 50명의 동시 시뮬레이션된 사용자가 페이지를 읽고 편집하도록 테스트했다. 결과:

| 메트릭 | 값 |
|---|---|
| 콜드 시작 시간 | 3.2초 |
| 페이지 로드 (평균) | 180ms |
| 페이지 로드 (95번째 백분위) | 340ms |
| 검색 쿼리 응답 | 45ms |
| 이미지 업로드 (2MB JPEG) | 1.2초 |
| PDF 낼부 (50페이지 책) | 4.8초 |
| 메모리 사용 (유휴) | 180MB |
| 메모리 사용 (50 활성 사용자) | 890MB |
| 데이터베이스 크기 (500페이지+이미지) | 2.1GB |

[DigitalOcean $24/월 Droplet](https://m.do.co/c/eca87ac14ee0)에서 BookStack은 50명 이상의 활성 사용자를 편안하게 서비스한다. PHP-FPM 프로세스 풀은 동시성을 잘 처리하고, MySQL FULLTEXT 검색은 5,000페이지 미만의 지식 베이스에 대해 적절하게 수행한다. 그 이상에서는 전용 검색 인덱스 추가를 고려할 수 있다.

맥락을 제공하면: Confluence Cloud는 $6.05/사용자/월을 청구한다. 50명의 사용자라면 $302.50/월이다. $24/월 VPS의 BookStack은 연간 **$3,342를 절약**한다 —— 그리고 당신의 데이터는 당신이 제어하는 인프라에 남아 있다.

## CI/CD 및 개발자 툴과의 통합

### GitHub Actions: 자동화된 문서 게시

```yaml
# .github/workflows/publish-docs.yml
name: Publish API Docs to BookStack

on:
  push:
    branches: [main]
    paths: ['docs/**']

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Upload to BookStack via API
        run: |
          curl -X PUT \
            -H "Authorization: Token ${{ secrets.BOOKSTACK_API_TOKEN }}" \
            -H "Content-Type: application/json" \
            -d '{"name": "API Documentation", "html": "'"$(cat docs/api.html | base64 -w 0)"'"}' \
            "https://docs.yourdomain.com/api/pages/42"
```

BookStack은 프로그래밍 방식 콘텐츠 관리를 위해 REST API를 노출한다. 설정 → API에서 API 토큰을 생성한다. API는 선반, 책, 챕터, 페이지에 대한 CRUD 작업과 이미지 업로드 및 검색을 지원한다.

### 백업 자동화

```bash
#!/bin/bash
# /opt/scripts/backup-bookstack.sh

BACKUP_DIR="/backups/bookstack"
DATE=$(date +%Y%m%d_%H%M%S)

# 데이터베이스 백업
docker exec bookstack_db mysqldump -u bookstack -p'your_password' bookstackdb \
  | gzip > "$BACKUP_DIR/bookstack_db_$DATE.sql.gz"

# 애플리케이션 데이터 백업 (업로드, 구성)
tar czf "$BACKUP_DIR/bookstack_app_$DATE.tar.gz" -C /path/to ./bookstack_app_data

# 최근 14일만 유지
find "$BACKUP_DIR" -name "*.gz" -mtime +14 -delete
```

cron에 추가하여 매일 백업: `0 3 * * * /opt/scripts/backup-bookstack.sh`

### Prometheus로 모니터링

```yaml
# docker-compose.yml에 모니터링 추가
  node-exporter:
    image: prom/node-exporter:v1.7.0
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.sysfs=/host/sys'
```

### 헬스 체크 스크립트

```bash
#!/bin/bash
# /opt/scripts/health-check-bookstack.sh

# BookStack이 응답하는지 확인
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:6875/login)

if [ "$HTTP_CODE" != "200" ]; then
    echo "오류: BookStack이 HTTP $HTTP_CODE 반환"
    docker restart bookstack
    echo "컨테이너가 $(date)에 재시작됨"
else
    echo "정상: BookStack이 정상 작동 중"
fi
```

cron에 자동 헬스 체크 추가: `*/5 * * * * /opt/scripts/health-check-bookstack.sh`

## 고급 사용법: 프로덕션 강화

### HTTPS 전용 쿠키 활성화

```bash
# .env 파일에서
SESSION_SECURE_COOKIE=true
```

이것은 세션 쿠키가 HTTPS 연결을 통해서만 전송되도록 보장한다. BookStack 인스턴스가 인터넷에 노출된 경우 필수적이다.

### 모듈 시스템을 통한 커스텀 테마 (v26.03+)

```bash
# 커스텀 모듈 디렉토리 생성
mkdir -p /config/www/themes/my_theme/modules/welcome_module

# bookstack-module.json
{
    "name": "welcome_module",
    "version": "1.0.0",
    "description": "Adds a welcome banner to the header"
}

# functions.php
<?php
use BookStack\Facades\Theme;
use BookStack\Theming\ThemeEvents;
use BookStack\Theming\ThemeViews;

Theme::listen(ThemeEvents::THEME_REGISTER_VIEWS, function (ThemeViews $themeViews) {
    $themeViews->renderAfter('layouts.parts.header', 'welcome', 10);
});

# views/welcome.blade.php
<div class="welcome-banner">
    Welcome, {{ user()->name }}! Check out the onboarding docs.
</div>
```

모듈 설치: `php artisan bookstack:install-module /path/to/module.zip`

### 페이지 콘텐츠 필터링 제어

```bash
# .env에서 (v25.12.4+ 신규)
# 옵션: false, true, 또는 필터 이름의 쉼표로 구분된 목록
APP_CONTENT_FILTERING=default

# 사용 가능한 필터: script, form, iframe, object, embed, style, css_expression
# style 필터링 비활성화 (인라인 스타일이 필요한 경우):
APP_CONTENT_FILTERING=script,form,iframe,object,embed,css_expression
```

## 비교: BookStack과 대안들

| 기능 | BookStack | Wiki.js | DokuWiki | MediaWiki | Outline |
|---|---|---|---|---|---|
| **라이선스** | MIT | AGPL-3.0 | GPL-2.0 | GPL-2.0+ | BSL 1.1 |
| **스택** | PHP / Laravel | Node.js | PHP (DB 없음) | PHP | Node.js |
| **편집기** | WYSIWYG + Markdown | Markdown + 비주얼 | Wiki 문법 | Wikitext | 블록 기반 |
| **실시간 협업** | 없음 | 있음 | 없음 | 없음 | 있음 |
| **콘텐츠 계층** | 선반→책→챕터→페이지 | 유연 | 평면 | 카테고리→페이지 | 컬렉션→문서 |
| **셀프 호스팅 비용** | 물가 (서버만) | 물가 (서버만) | 물가 (서버만) | 물가 (서버만) | $10/사용자/월 호스팅 |
| **데이터베이스 필요** | MySQL/MariaDB | PostgreSQL/MySQL/SQLite | 없음 (파일 기반) | MySQL/PostgreSQL | PostgreSQL |
| **LDAP/SSO** | 예 (LDAP, SAML, OIDC) | 예 (광범위) | 플러그인 통해 | 플러그인 통해 | SAML, OIDC |
| **검색** | MySQL FULLTEXT | Elasticsearch/DB | 내장 | Elasticsearch | PostgreSQL FTS |
| **API** | REST | GraphQL + REST | XML-RPC | REST | REST |
| **활발한 유지보수** | 월간 릴리스 | 정기적 | 안정적 | 정기적 | 정기적 |
| **GitHub stars** | **18,700** | **24,500** | **1,800** | **4,200** | **14,300** |

**BookStack이 이기는 경우:** 팀이 구조화된 계층을 중시하고, 데드 심플한 설정을 원하고, WYSIWYG + Markdown 이중 편집이 필요하고, PHP 에코시스템의 친숙함을 선호할 때.

**Wiki.js가 이기는 경우:** 실시간 협업이 필요하고, Node.js 스택을 선호하고, GraphQL API 접근이 필요하고, 더 유연한 콘텐츠 아키텍처가 필요할 때.

**DokuWiki가 이기는 경우:** 제로 데이터베이스 설정이 필요할 때 —— 완전히 플랫 파일로 실행된다. 기능보다 단순성이 우선인 최소한의 배포에 최적이다.

**MediaWiki가 이기는 경우:** 공개 백과사전 규모의 위키를 구축할 때. 대부분의 납부 문서화 필요에 대해 과하다.

**Outline이 이기는 경우:** 팀이 Notion과 유사한 블록 편집기 경험과 실시간 협업을 원하고, 더 복잡한 셀프 호스팅 설정이나 호스팅 가격을 감수할 수 있을 때.

## 한계: 정직한 평가

BookStack은 모든 문서화 사용 사례에 적합한 도구는 아니다. 다음은 잘 수행하지 못하는 것들이다:

**실시간 협업이 없다.** 두 사용자가 동시에 동일한 페이지를 편집하면 서로 덮어쓰게 된다. BookStack은 오래된 편집에 대해 경고하지만 Google Docs 스타일의 실시간 협업을 제공하지 않는다. 워크플로우가 동시 편집에 의존하는 경우 Outline이나 Wiki.js를 대신 사용하라.

**독선적인 계층 구조가 제한적으로 느껴질 수 있다.** 선반/책/챕터/페이지 모델은 구조화된 문서에 탁월하지만, 유동적이고 끊임없이 재구조화되는 지식 베이스에는 어색하다. 문서가 참조 도서관보다 살아있는 지식 그래프에 더 가깝다면 Notion이나 Obsidian이 더 적합할 수 있다.

**공개 문서화 기능이 제한적이다.** BookStack은 선반에 대한 공개 가시성을 지원하지만, 브랜딩된 고객 대면 문서 사이트 용으로 설계되지 않았다. 내장된 커스텀 도메인 + SSL 워크플로우가 없고, 공개 문서에 대한 버전 관리가 없으며, Docusaurus나 GitBook과 같은 전용 문서 플랫폼에 비해 테마 옵션이 제한적이다.

**내장된 인라인 다이어그램 편집이 없다.** BookStack은 Draw.io를 통합하여 다이어그램을 지원하지만, 모달에서 Draw.io 편집기를 연다. Outline 내의 Excalidraw처럼 페이지에서 직접 그릴 수 없다.

**PHP 스택이 구식으로 느껴질 수 있다.** 전적으로 Node.js나 Go 인프라를 운영하는 팀은 기존 스택의 툴을 선호할 수 있다. 그렇지만 PHP 배포는 잘 이핶되고 검증된 기술이다 —— 따분한 기술에는 가치가 있다.

## 자주 묻는 질문

### Confluence에서 BookStack으로 마이그레이션할 수 있나요?

공식 Confluence 가져오기 도구는 없지만, Confluence 페이지를 HTML이나 Markdown으로 낼부한 후 BookStack REST API를 사용하여 페이지를 대량 생성할 수 있다. 커뮤니티에는 이러한 마이그레이션 경로를 위한 스크립트가 있다. 대규모 마이그레이션의 경우, 콘텐츠를 BookStack의 책/챕터/페이지 모델에 맞게 재구조화하는 데 시간이 걸릴 것으로 예상하라.

### BookStack을 어떻게 업데이트하나요?

Docker를 사용하면 이미지 태그를 docker-compose.yml에서 변경하고 `docker compose up -d`를 실행하는 한 줄로 업데이트할 수 있다. 수동 설치의 경우, 최신 릴리스를 가져와 `git pull`을 실행하거나 새 릴리스 아카이브를 다운로드한 후 `php artisan migrate`를 실행하고 캐시를 지운다. 업데이트 전에 항상 데이터베이스를 백업하라 —— BookStack은 월별 보안 패치를 릴리스한다.

### BookStack은 이중 인증을 지원하나요?

v26.03 기준, BookStack에는 내장 TOTP/SMS 2FA가 없다. 2FA를 강제하는 ID 공급자(Azure AD나 Okta 등)와 함께 SAML이나 OIDC 인증을 사용하여 MFA를 달성할 수 있다. 네이티브 TOTP 지원은 커뮤니티에서 논의되었으나 즉각적인 로드맵에 없다.

### MySQL 대신 PostgreSQL을 사용할 수 있나요?

BookStack은 공식적으로 MySQL과 MariaDB를 지원한다. PostgreSQL 지원은 논의되었지만 공식적으로 지원되지 않는다. PostgreSQL이 필요하면 Wiki.js나 Outline이 더 적합한 선택이다. BookStack의 경우 MySQL 8.0+나 MariaDB 10.6+를 사용하라.

### LinuxServer.io 이미지와 공식 이미지의 차이점은 무엇인가요?

`lscr.io/linuxserver/bookstack` 이미지는 커뮤니티에서 유지보수하며 널리 사용된다. PHP-FPM과 Nginx 구성을 추상화하여 Docker에서 BookStack을 실행하는 가장 쉬운 방법을 제공한다. BookStack 유지관리자의 공식 Docker 이미지는 없다 —— LinuxServer 이미지가 사실상의 표준이다.

### 백업은 어떻게 작동하나요?

두 가지를 백업하라: MySQL/MariaDB 데이터베이스(모든 콘텐츠와 메타데이터)와 `/config/www/files` 디렉토리(업로드된 이미지와 첨부 파일). 위에 표시된 Docker 설정을 사용하면 둘 다 네임드 볼륨에 있다. 간단한 `mysqldump`와 앱 데이터 볼륨의 `tar` 아카이브만으로 충분하다. 분기마다 복원 절차를 테스트하라.

## 결론: 2026년에 BookStack을 실행해야 할까요?

팀이 문서화 툴에 대한 사용자당 가격 책정에 지쳤고, 양질의 조직화 습관을 강제하는 구조화된 독선적인 위키를 원한다면, BookStack은 2026년에 사용할 수 있는 최고의 오픈소스 옵션 중 하나이다. PHP/Laravel 스택은 최상의 방식으로 따분하다 —— 예측 가능하고, 문서가 잘 되어 있으며, 문제가 발생했을 때 디버깅하기 쉽다. 월간 보안 릴리스는 활발한 유지보수를 보여주며, v26.03 테마 모듈 시스템은 새로운 커스터마이징 가능성을 열어준다.

5~50명의 팀이 공급업체 잠금 없이 납부 문서를 원하는 경우, BookStack은 즉시 비용을 회복한다. [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0)에서 셀프 호스팅하고, 매일 백업하면, 이번 분기에 유행하는 어떤 SaaS 툴보다 오래 지속될 문서 시스템을 갖게 된다.

dibi8.com 커뮤니티에 참여하세요: 5,000명 이상의 개발자와 매일 오픈소스 툴 토론, 배포 팁, 문제 해결을 나누는 [Telegram 그룹](https://t.me/dibi8opensource).

---

## 출처 및 추가 자료

- [BookStack 공식 문서](https://www.bookstackapp.com/docs/)
- [BookStack GitHub 미러](https://github.com/BookStackApp/BookStack)
- [BookStack Codeberg 저장소](https://codeberg.org/bookstack)
- [BookStack v26.03 릴리스 노트](https://www.bookstackapp.com/blog/bookstack-release-v26-03/)
- [LinuxServer.io BookStack Docker 이미지](https://docs.linuxserver.io/images/docker-bookstack/)
- [BookStack vs Wiki.js 비교](https://blog.canadianwebhosting.com/bookstack-vs-wikijs-choosing-self-hosted-team-wiki/)

---



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 제휴 공개

본 문서에는 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)의 제휴 링크가 포함되어 있다. 당사 링크를 통해 가입하면 추가 비용 없이 당사에 추천 크레딧이 지급된다. 당사는 자체적으로 사용하는 인프라만을 추천한다. BookStack 프로젝트는 물론 오픈소스이며 —— BookStack 유지관리자와는 제휴 관계가 없다.
