---
title: 'Docker Compose: 37,393 GitHub Stars — 멀티 컨테이너 앱 완벽 설정 가이드 2026'
description: 'Define and run multi-container applications with Docker using declarative YAML configuration.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/docker/compose'
stars: 37393
maintainer: 'docker'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['docker-compose', '컨테이너-오케스트레이션', 'devops', 'docker', '마이크로서비스', '배포', 'yaml', '멀티-컨테이너']
aliases:
- /kr/posts/docker-compose/
---

{{</* resource-info */>}}

![Docker Compose Logo](https://raw.githubusercontent.com/docker/compose/main/logo.png)

## 소개

원시 `docker run` 명령으로 멀티 컨테이너 애플리케이션을 관리하면 금방 제어가 어려워집니다. 일반적인 웹 스택에는 데이터베이스, 캐시, 리버스 프록시, 애플리케이션 자체가 필요합니다——네트워크, 볼륨, 환경 변수를 모두 연결해야 하는 네 개의 독립된 컨테이너입니다. Docker Compose는 단일 선언형 YAML 파일로 이 문제를 해결합니다. 37,000개 이상의 GitHub stars를 보유한 이 도구는 여전히 로컬 개발과 단일 노드 프로덕션 배포에서 가장 널리 채택된 도구입니다. 이 가이드는 설치부터 프로덕션 강화까지 모든 것을 다루며, 오늘 바로 배포할 수 있는 실제 구성을 제공합니다.

## Docker Compose란?

Docker Compose는 선언형 YAML 구성 파일(일반적으로 `compose.yaml`)을 사용하여 멀티 컨테이너 Docker 애플리케이션을 정의하고 실행하는 도구입니다. 서비스 검색, 네트워크 생성, 볼륨 마운트, 시작 순서를 자동으로 처리하여——컨테이너 정의가 있는 평범한 폴드를 하나의 명령으로 실행 가능한 시스템으로 변환합니다.

## Docker Compose의 작동 방식

![Docker Compose 아키텍처](https://docs.docker.com/get-started/docker-concepts/running-containers/images/multi-container-apps-compose.png)

아키텍처는 간단합니다. `compose.yaml` 파일을 작성하여 서비스, 네트워크, 볼륨을 설명합니다. `docker compose` CLI 플러그인이 이 파일을 읽고 Docker Engine API 호출로 변환합니다. 낮은 수준에서 일어나는 작업은 다음과 같습니다:

1. **프로젝트 격리**: Compose는 `<project>_<network>`라는 전용 Docker 네트워크를 생성합니다(기본값: 디렉터리 이름 + `_default`). 프로젝트의 모든 서비스는 이 격리된 브리지 네트워크를 통해 통신합니다.
2. **서비스 검색**: 컨테이너는 서비스 이름으로 서로에 도달합니다. `db` 서비스가 있다면 `api` 컨테이너는 `db:5432`로 연결하며 DNS 구성이 필요 없습니다.
3. **볼륨 관리**: 명명된 볼륨은 컨테이너 재시작 후에도 데이터를 유지합니다. Compose는 충돌을 피하기 위해 볼륨 이름 앞에 프로젝트 이름을 붙입니다.
4. **의존성 순서**: `depends_on` 지시문이 시작 순서를 제어합니다. `condition: service_healthy`와 결합하면 애플리케이션이 시작되기 전에 데이터베이스가 준비되었는지 확인합니다.
5. **리소스 수명 주기**: `docker compose up`으로 모든 것을 생성하고, `docker compose down`으로 해체합니다. `--volumes`를 추가하여 영구 데이터를 제거하거나, `--rmi all`로 이미지를 정리합니다.

현대의 Compose 사양(v2.x+, Go 기반)은 롤링 사양입니다——`version:` 최상위 키가 더 이상 필요하지 않습니다. 표준 파일명은 `docker-compose.yml`에서 `compose.yaml`로 변경되었으나, 이전 버전과의 호환성을 위해 둘 다 허용됩니다.

## 설치 및 설정

Docker Compose v2는 Docker Engine과 번들로 제공되는 CLI 플러그인입니다. 레거시 Python 기반 `docker-compose`(v1) 바이너리는 2023년에 폐기되어 더 이상 유지관리되지 않습니다.

### Linux (Ubuntu/Debian)

```bash
# 패키지 인덱스 업데이트
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Docker 공식 GPG 키 추가
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 저장소 추가
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker Engine + Compose 플러그인 설치
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# 사용자를 docker 그룹에 추가 (로그아웃 후 재로그인 필요)
sudo usermod -aG docker $USER
newgrp docker

# 확인
docker compose version
# 예상 출력: Docker Compose version v2.36.0+
```

### macOS

[docker.com](https://www.docker.com/products/docker-desktop/)에서 Docker Desktop을 다운로드하세요. Docker Compose가 번들로 포함되어 있습니다. Apple Silicon에서는 Docker Desktop이 Virtualization.framework를 사용하여 레거시 QEMU 백엔드보다 30-40% 향상된 성능을 제공합니다.

```bash
# 설치 후 확인
docker compose version
```

### 설치 후 확인

```bash
# compose 프로젝트에서 실행 중인 컨테이너 확인
docker compose ps

# 모든 서비스의 로그 보기
docker compose logs --tail 100 -f

# 리소스 사용량 확인
docker stats --no-stream
```

### Windows (WSL2)

```powershell
# WSL2 활성화
wsl --install
# 재부팅 후 Docker Desktop 설치, WSL2 백엔드가 선택되어 있는지 확인
docker compose version
```

### 수동 바이너리 설치

패키지 관리자가 없는 환경의 경우:

```bash
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.36.0/docker-compose-linux-x86_64 \
  -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version
```

## 인기 도구와의 통합

### Traefik (리버스 프록시 및 로드 밸런서)

Traefik은 Docker 컨테이너를 자동으로 발견하고 라벨을 기반으로 트래픽을 라우팅합니다. 이를 통해 수동 nginx 구성이 불필요해집니다:

```yaml
# compose.yaml — Traefik + Whoami 예제
name: proxy-demo

services:
  traefik:
    image: traefik:v3.3
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  whoami:
    image: traefik/whoami
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
      - "traefik.http.routers.whoami.entrypoints=web"
```

`docker compose up -d`로 시작하고 `http://whoami.localhost`를 방문하세요.

### Prometheus + Grafana (모니터링 스택)

```yaml
# compose.yaml — 모니터링 스택
name: monitoring

services:
  prometheus:
    image: prom/prometheus:v3.2.0
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  grafana:
    image: grafana/grafana:11.5.0
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

Prometheus가 컨테이너 메트릭을 수집하고, Grafana가 이를 시각화합니다. 로그 후 `http://prometheus:9090`에 Prometheus 데이터 소스를 추가하세요.

### 풀스택 애플리케이션 (PostgreSQL + Redis + FastAPI + Nginx)

```yaml
# compose.yaml — 프로덕션 준비 3계층 앱
name: myapp

services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: appdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3
    restart: unless-stopped

  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    environment:
      DATABASE_URL: postgresql://appuser:${DB_PASSWORD}@db:5432/appdb
      REDIS_URL: redis://redis:6379/0
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s
    restart: unless-stopped

  nginx:
    image: nginx:1.27-alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      api:
        condition: service_healthy
    restart: unless-stopped

volumes:
  postgres_data:
  redis_data:
```

여기서 보여주는 핵심 패턴: 헬스 체크된 의존성, 데이터 지속을 위한 명명 볼륨, 커스텀 이미지용 빌드 컨텍스트, 복원력을 위한 `restart: unless-stopped`입니다.

## 벤치마크 / 실제 사용 사례

Docker Compose는 특정 시나리오에서 뛰어납니다. 프로덕션 배포 및 비교의 데이터는 다음과 같습니다:

| 지표 | Docker Compose | Kubernetes | Podman Compose | Nomad |
|------|---------------|------------|----------------|-------|
| **컨트롤 플레인 RAM** | ~50 MB | ~2 GB | 0 MB (데몬 없음) | ~100 MB |
| **지원 노드** | 단일 노드 | 무제한 | 단일 노드 | 무제한 |
| **프로젝트당 서비스 수** | 1-50 일반 | 1-10,000+ | 1-50 일반 | 1-1,000+ |
| **첫 배포 시간** | < 5분 | 2-8시간 | < 5분 | 30-60분 |
| **3계층 앱 YAML 줄 수** | ~40 | ~200+ (Deployment + Service) | ~40 | ~80 |
| **자동 확장** | 수동 (docker compose up --scale) | 네이티브 HPA | 수동 | 네이티브 |
| **롤링 업데이트** | 재생성만 | 네이티브 | 재생성만 | 네이티브 |

**시작 속도**: Docker Compose는 4코어 머신에서 5개 서비스 스택을 10초 이내에 가동합니다. 동등한 Kubernetes Helm 배포(Pod 스케줄링 포함)는 60-120초가 걸립니다.

**리소스 효율성**: Compose 오버헤드는 CLI + Docker 데몬 기준 약 50MB RAM입니다. 최소한의 Kubernetes 컨트롤 플레인은 워크로드를 실행하기 전에 약 2GB를 소비합니다. 단일 노드에서 10개 미만의 서비스 배포 시, Compose는 오케스트레이션 오버헤드가 40배 적습니다.

**CI/CD 채택**: 컨테이너를 사용하는 GitHub Actions 워크플로우의 90% 이상이 통합 테스트 환경을 위해 Docker Compose에 의존합니다. `docker compose up --wait` 명령(헬스 상태 대기)은 경쟁 상태로 인한 불안정한 테스트 파이프라인을 제거합니다.

## 고급 사용법 / 프로덕션 강화

### 헬스 체크 및 시작 순서

헬스 체크 없이는 프로덕션에 배포하지 마세요. 컨테이너가 `Up` 상태를 표시한다는 것은 프로세스가 시작되었다는 의미일 뿐——애플리케이션이 작동한다는 뜻은 아닙니다:

```yaml
services:
  api:
    image: myapp:v1.2.3
    healthcheck:
      test: ["CMD", "curl", "-fsS", "http://localhost:8080/ready"]
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 30s
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
```

### 로그 순환

무제한 JSON 로그는 디스크를 채웁니다. 로컬 로깅 드라이버로 순환을 구성하세요:

```yaml
services:
  api:
    image: myapp:v1.2.3
    logging:
      driver: "local"
      options:
        max-size: "10m"
        max-file: "3"
        compress: "true"
```

### 리소스 제한

하나의 비정상적 컨테이너가 다른 컨테이너의 리소스를 고갈시키지 않도록 방지하세요:

```yaml
services:
  worker:
    image: myapp-worker:v1.2.3
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 128M
```

### 환경 분리용 Profiles

여러 파일을 유지 관리하지 않고도 개발 전용 서비스를 정의하려면 프로파일을 사용하세요:

```yaml
services:
  api:
    image: myapp:latest
    ports:
      - "8080:8080"

  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: devpass

  pgadmin:
    image: dpage/pgadmin4:latest
    profiles: ["debug"]
    ports:
      - "5050:80"
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@local.dev
      PGADMIN_DEFAULT_PASSWORD: admin
```

디버그 도구는 필요할 때만 실행하세요: `docker compose --profile debug up -d`. 플래그 없이는 `pgadmin`이 건초과됩니다.

### 시크릿 관리

비밀번호를 컴포즈 파일에 커밋하지 마세요. Docker secrets나 환경 파일을 사용하세요:

```yaml
services:
  api:
    image: myapp:latest
    secrets:
      - db_password
    environment:
      DB_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### `include` 지시문 (Compose v2.20+)

대형 프로젝트를 모듈식 컴포즈 파일로 분할하세요:

```yaml
# compose.yaml — 루트 파일
name: platform

include:
  - path: ./infra/postgres.yaml
  - path: ./infra/redis.yaml
  - path: ./apps/api.yaml
  - path: ./apps/worker.yaml
    env_file: ./apps/worker.env
```

각 포함된 파일은 자체 서비스, 네트워크, 볼륨을 가진 유효한 컴포즈 파일입니다. 이를 통해 개별 파일을 50줄 미만으로 유지하고 코드 검토를 관리 가능하게 합니다.

### 블루/그린 배포

Kubernetes 없이 무중단 업데이트를 하려면 두 개의 컴포즈 프로젝트와 리버스 프록시를 사용하세요:

```bash
#!/bin/bash
# deploy.sh
CURRENT=$(cat /tmp/current_slot 2>/dev/null || echo "blue")
NEW=$([ "$CURRENT" = "blue" ] && echo "green" || echo "blue")

# 새 슬롯 빌드 및 시작
docker compose -p "app-${NEW}" -f compose.yaml up -d --build --wait

# nginx 업스트림 업데이트
sed -i "s/app-${CURRENT}/app-${NEW}/g" /etc/nginx/conf.d/upstream.conf
nginx -s reload

# 이전 슬롯 해체
docker compose -p "app-${CURRENT}" -f compose.yaml down

# 활성 슬롯 저장
echo "$NEW" > /tmp/current_slot
```

## 대안과의 비교

| 기능 | Docker Compose | Kubernetes | Podman + Compose | Nomad |
|------|---------------|------------|------------------|-------|
| **학습 곡선** | 낮음 (단일 YAML) | 높음 (많은 리소스) | 낮음 (Docker CLI 호환) | 중간 (HCL 구성) |
| **멀티 노드** | 아니오 (단일 호스트) | 예 | 아니오 (단일 호스트) | 예 |
| **데몬 필요** | 예 (dockerd) | 예 (kubelet + 컨트롤 플레인) | 아니오 (데몬 없음) | 예 (Nomad agent) |
| **기본 루트리스** | 아니오 | 아니오 | 예 | 선택적 |
| **자동 확장** | 수동만 | 네이티브 HPA | 수동만 | 네이티브 |
| **스토리지 볼륨** | 로컬만 | CSI 플러그인 (모든 백엔드) | 로컬만 | 호스트 + CSI |
| **시크릿 관리** | 파일 기반 환경 | 네이티브 Secrets + Vault | 파일 기반 환경 | Vault 통합 |
| **커뮤니티 규모** | 37K+ stars | 110K+ (kubernetes/kubernetes) | 23K+ (containers/podman) | 15K+ (hashicorp/nomad) |
| **최적 사용처** | 개발, CI/CD, 소규모 프로덕션 | 대규모 프로덕션 | 보안 중심, 루트리스 | 혼합 워크로드 |
| **라이선스** | Apache-2.0 | Apache-2.0 | Apache-2.0 | BUSL (소스 사용 가능) |

## 한계 / 정직한 평가

Docker Compose는 만능 솔루션이 아닙니다. 다음은 부족한 부분입니다:

**단일 노드 제약**: Compose는 한 호스트에서 실행됩니다. 해당 호스트에 장애가 발생하면 전체 스택이 다울됩니다. 고가용성 요구사항에는 Kubernetes, Nomad 또는 Docker Swarm이 필요합니다.

**네이티브 자동 확장 없음**: `docker compose up --scale api=3`은 작동하지만 수동입니다. Kubernetes HPA와 같은 CPU 기반 또는 메모리 기반 수평 Pod 자동 확장 기능이 없습니다.

**제한적인 시크릿 관리**: 파일에서 읽는 Docker secrets는 단일 노드 설정에는 적합합니다. 그러나 Kubernetes Secrets나 HashiCorp Vault가 제공하는 순환, 미사용 암호화, 세분화된 RBAC이 부족합니다.

**롤링 업데이트가 기본적**: Compose는 컨테이너를 재생성합니다. 칠리 배포, 트래픽 분할, 이전 레플리카 세트로의 롤백을 수행할 수 없습니다. 미션 크리티컬 무중단 배포에는 더 정교한 오케스트레이터를 사용하세요.

**네트워크가 로컬 전용**: 기본 브리지 네트워크는 한 호스트 내에서만 작동합니다. 멀티 호스트 서비스 메시, 수신 컨트롤러, 교차 지역 로드 밸런싱에는 Kubernetes나 Istio와 같은 서비스 메시가 필요합니다.

**데몬 의존성**: Podman과 달리 Compose는 Docker 데몬(`dockerd`)이 실행 중이어야 합니다. 이 데몬은 단일 장애 지점이며 규제 환경에서 잠재적인 보안 우려입니다.

## 자주 묻는 질문

### compose 파일에 `version: "3.8"` 줄이 여전히 필요한가요?

아니요. Compose 사양은 이제 버전이 없습니다. `version` 키는 Compose v2.x+ 및 v5.x에서 무시됩니다. 새 프로젝트는 완전히 생략하고 `compose.yaml`을 파일명으로 사용해야 합니다. `version` 줄이 있는 레거시 `docker-compose.yml` 파일은 이전 버전과의 호환성을 위해 여전히 작동합니다.

### `docker-compose`와 `docker compose`의 차이점은 무엇인가요?

`docker-compose`(하이픈 포함)는 Python 기반 레거시 v1 바이너리로, 2023년에 폐기되어 더 이상 유지 관리되지 않습니다. `docker compose`(공백 포함)는 Go로 작성된 v2 CLI 플러그인으로, 적극적으로 유지 관리되며 더 빠르고 Docker Engine과 번들되어 있습니다. 모든 새 스크립트와 CI 파이프라인은 `docker compose`를 사용해야 합니다.

### 다운타임 없이 프로덕션에서 Docker Compose를 어떻게 실행하나요?

Docker Compose에는 내장 롤링 업데이트 기능이 없습니다. 실용적인 접근 방식: (1) 낮은 도구용 `docker compose up -d` 중 짧은 다운타임을 수용, (2) 두 개의 컴포즈 프로젝트와 리버스 프록시를 사용한 고급 사용법 섹션에 표시된 블루/그린 배포 스크립트 사용, 또는 (3) 무중단이 필수 요구사항일 때 Kubernetes나 Nomad로 마이그레이션.

### Docker Compose를 Podman과 함께 사용할 수 있나요?

예, `podman-compose`를 통해 약 90-95% 호환성을 제공합니다. Podman은 Docker API 호환성 레이어도 통해 Docker Compose v2를 지원합니다. 그러나 `condition: service_healthy`가 있는 `depends_on`과 같은 일부 고급 기능은 다르게 동작할 수 있습니다. 루트리스 컨테이너가 필요한 팀은 확정 전에 Podman으로 특정 컴포즈 파일을 테스트하세요.

### 시작 실패한 서비스를 어떻게 디버깅하나요?

먼저 `docker compose logs <service>`로 stderr/stdout을 확인하세요. 컨테이너가 즉시 종료되면 `docker compose run --rm <service> sh`로 셸을 얻어 환경을 검사하세요. 의존성 문제의 경우 `docker compose ps`로 헬스 상태를 확인하세요. 서비스 간 경쟁 상태를 해결하려면 `condition: service_healthy`가 있는 `depends_on`을 추가하세요.

### Docker Compose는 상업적 용도로 물론인가요?

예. Docker Compose는 Apache-2.0 라이선스로 오픈 소스이며 개인 및 상업적 사용 모두 물론입니다. Docker Desktop(macOS 및 Windows에서 Compose 포함)은 250명 이상의 직원이 있거나 수익이 1000만 달러 이상인 조직에 대해 라이선스 제한이 있지만, Linux의 Compose CLI 플러그인 자체에는 제한이 없습니다.

## 결론

Docker Compose는 2026년에도 멀티 컨테이너 배포를 위한 가장 실용적인 도구로 남아 있습니다. 복잡한 멀티 서비스 스택을 모든 개발자가 실행, 테스트, 배포할 수 있는 단일 파일 정의로 변환합니다. 개발 환경, CI/CD 파이프라인, 단일 노드 프로덕션 워크로드에 대해 37,393개의 GitHub stars는 과장이 아닌 실제 매일의 실용성을 반영합니다.

**액션 아이템:**
1. 남아 있는 `docker-compose`(v1) 명령을 `docker compose`(v2)로 교체
2. 컴포즈 파일에서 `version:` 줄을 제거하고 `compose.yaml`로 이름 변경
3. 모든 프로덕션 서비스에 헬스 체크와 `restart: unless-stopped` 추가
4. 디스크가 가득 차기 전에 로그 순환 설정
5. 호스팅의 경우 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)은 빈 환경에서 `docker compose up`까지 5분 이내에 구성할 수 있는 사전 구성된 Docker droplet을 제공하며, [HTStack](https://my.htstack.com/aff.php?aff=27187)은 컨테이너 워크로드에 최적화된 관리형 VPS 인스턴스를 제공합니다.

[Telegram 그룹](https://t.me/dibi8dev)에 가입하여 Docker Compose 구성을 공유하고 다른 개발자로부터 도움을 받으세요.

*이 기사에는 제휴 링크가 포함되어 있습니다. 이 링크를 통해 호스팅을 구매하면 추가 비용 없이 dibi8.com에 커미션이 지급됩니다.*



## 추천 도구

이 가이드와 함께 사용하기를 추천하는 제품:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — DigitalOcean
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — HTStack

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 출처 및 추가 참고 자료

- [Docker Compose 공식 문서](https://docs.docker.com/compose/)
- [Compose 사양 참조](https://docs.docker.com/reference/compose-file/)
- [Docker Compose GitHub 저장소](https://github.com/docker/compose)
- [Traefik Docker 공급자 문서](https://doc.traefik.io/traefik/providers/docker/)
- [Prometheus Docker 모니터링 가이드](https://prometheus.io/docs/guides/cadvisor/)
- [Docker Compose vs Kubernetes — distr.sh](https://distr.sh/blog/docker-compose-vs-kubernetes/)
- [Podman vs Docker 2026 비교](https://daily.dev/blog/docker-vs-podman-container-runtime-which-to-use/)
- [Docker Compose 프로덕션 모범 사례](https://eastondev.com/blog/en/posts/dev/20260412-docker-compose-production/)
- [Nomad vs Docker Compose — hostmycode.com](https://www.hostmycode.com/blog/container-orchestration-beyond-kubernetes-2026-nomad-docker-swarm-podman-vps)
- [Docker Desktop 가격 및 라이선스](https://www.docker.com/pricing/)
