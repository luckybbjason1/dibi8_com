---
title: 'InvokeAI: 27.2K+ Stars — 2026 완벽 설치 가이드'
description: 'InvokeAI(Invoke)는 업계 최고의 WebUI를 갖춘 Stable Diffusion 모델용 크리에이티브 엔진이다. SD 1.5, SDXL, FLUX 및 ControlNet과 호환된다. Docker 설치, 워크플로우 설정, AUTOMATIC1111 및 ComfyUI와의 벤치마크, 프로덕션 강화를 다룬다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/invoke-ai/InvokeAI'
stars: 27200
maintainer: 'invoke-ai'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['InvokeAI', 'Stable Diffusion', 'AI 이미지 생성', 'Docker', 'FLUX', 'SDXL', 'WebUI', '오픈소스']
aliases:
- /kr/posts/invokeai/
---

{{</* resource-info */>}}

![InvokeAI Logo](https://raw.githubusercontent.com/invoke-ai/InvokeAI/main/invokeai/assets/invokeai-logo.png)

## 소개

Stable Diffusion을 로컬에서 실행해 본 모든 개발자는 이 문제를 알고 있다: 의존성 충돌, CUDA 버전 불일치, 누락된 모델 설정 파일, 2003년에 디자인된 것처럼 보이는 WebUI. 2022년 이후 오픈소스 AI 이미지 생성 분야는 상당히 성숙해졌지만, "내 머신에서는 작동"과 프로덕션 레디 배포 사이의 격차는 여전히 크다. GitHub에서 27.2K+ 스타를 보유한 InvokeAI는 2026년 3월 v6.12.0을 릴리스하며 이 격차를 해소했다. 전문가 수준의 WebUI, 노드 기반 워크플로우 엔진, 멀티유저 지원, Docker 배포를 Apache-2.0 라이선스 하에 결합했다. 이 가이드는 Docker 및 베어 메탈을 통한 InvokeAI 설치, Stable Diffusion 및 ControlNet과의 통합, 프로덕션 환경에서의 실행을 다룬다.

## InvokeAI란?

InvokeAI는 Stable Diffusion 모델을 기반으로 한 AI 구동 이미지 생성을 위한 묵료 오픈소스 크리에이티브 엔진이다. 전문가 수준의 캔버스 에디터, 노드 기반 워크플로우 빌더, 모델 관리 시스템을 갖춘 웹 기반 인터페이스를 제공한다. 개인 아티스트와 자체 호스팅 프로덕션 레디 AI 이미지 생성 파이프라인이 필요한 팀 모두를 지원한다.

## InvokeAI의 작동 방식

InvokeAI는 모듈형 클라이언트-서버 아키텍처를 따른다. 백엔드는 모델 로딩, 이미지 생성, 큐 관리를 처리하는 Python 기반 API 서버(`invokeai.app.api_app`)이고, 프론트엔드는 캔버스, 갤러리, 워크플로우 에디터를 제공하는 React 기반 단일 페이지 애플리케이션이다.

**핵심 구성 요소:**

- **웹 서버 및 React UI** — 기본적으로 9090 포트에서 실행되며 전체 생성 인터페이스 제공
- **통합 캔버스(Integrated Canvas)** — 인페인팅, 아웃페인팅, 브러시 도구, 이미지-투-이미지 편집을 위한 레이어 기반 캔버스
- **노드 기반 워크플로우** — 재현 가능하고 공유 가능한 파이프라인을 위한 시각적 파이프라인 빌더
- **모델 매니저** — SD 1.5, SDXL, FLUX, Z-Image 및 커스텀 체크포인트의 내장 다운로드 및 관리
- **갤러리 및 보드** — 메타데이터 보존과 드래그-앤-드롭을 지원하는 구조화된 이미지 저장소
- **큐 시스템** — 일괄 생성 및 워크플로우 실행을 위한 백그라운드 작업 처리

## 설치 및 설정

### 방법 1: Docker (프로덕션 환경 권장)

Docker는 프로덕션 레디 InvokeAI를 설정하는 가장 빠른 경로이다. 공식 이미지는 NVIDIA(CUDA), AMD(ROCm) 및 CPU 전용 모드를 지원한다.

**전제 조건:**
- BuildKit이 활성화된 Docker Engine 24.0+
- Docker Compose 플러그인(V2)
- NVIDIA Container Toolkit(GPU) 또는 ROCm Docker 런타임(AMD)
- 16GB+ RAM, 20GB+ 여유 디스크 공간

**단계 1 — 리포지토리 클론:**

```bash
git clone https://github.com/invoke-ai/InvokeAI.git
cd InvokeAI/docker
```

**단계 2 — 환경 설정:**

```bash
cp .env.sample .env
```

`.env` 파일을 편집한다:

```bash
# 핵심 설정
INVOKEAI_ROOT=/opt/invokeai-data
INVOKEAI_PORT=9090
GPU_DRIVER=cuda
CONTAINER_UID=1000
HUGGINGFACE_TOKEN=hf_your_token_here
```

**단계 3 — 컨테이너 시작:**

```bash
./run.sh
```

또는 직접 실행:

```bash
docker compose up -d
```

브라우저에서 `http://localhost:9090`으로 접속한다.

### 빠른 Docker 실행 (Compose 없이)

데이터 유지 없이 빠르게 테스트하려면:

```bash
# NVIDIA GPU
docker run --runtime=nvidia --gpus=all \
  --publish 9090:9090 \
  ghcr.io/invoke-ai/invokeai:latest

# AMD GPU
docker run --device /dev/kfd --device /dev/dri \
  --publish 9090:9090 \
  ghcr.io/invoke-ai/invokeai:main-rocm

# 데이터 유지
docker run --runtime=nvidia --gpus=all \
  --publish 9090:9090 \
  --volume /mnt/invokeai-data:/invokeai \
  ghcr.io/invoke-ai/invokeai:latest
```

### 방법 2: 베어 메탈 설치 (Linux/macOS)

**단계 1 — 런처 설치:**

```bash
pip install invokeai
```

**단계 2 — 설정 마법사 실행:**

```bash
invokeai-configure
```

이 대화형 마법사는 올바른 PyTorch 버전을 설치하고 기본 모델을 다운로드하며 런타임 디렉토리를 구성한다.

**단계 3 — WebUI 시작:**

```bash
invokeai-web
```

### 방법 3: 클라우드 VPS (DigitalOcean)

로컬 GPU 하드웨어가 없는 팀을 위해 클라우드 GPU 인스턴스가 완전한 InvokeAI 접근을 제공한다. NVIDIA A10G 또는 H100을 갖춘 DigitalOcean GPU Droplets가 적합하다.

```bash
# 새로운 Ubuntu 24.04 GPU Droplet에서
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
sudo systemctl enable --now docker

# NVIDIA Container Toolkit 설치
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update && sudo apt install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker

# InvokeAI 배포
git clone https://github.com/invoke-ai/InvokeAI.git
cd InvokeAI/docker
cp .env.sample .env
# .env 편집: INVOKEAI_ROOT 및 HUGGINGFACE_TOKEN 설정
sudo docker compose up -d
```

### 프로덕션 docker-compose.yml 참조

```yaml
# Copyright (c) 2023 Eugene Brodsky https://github.com/ebr

x-invokeai: &invokeai
    image: "ghcr.io/invoke-ai/invokeai:latest"
    build:
      context: ..
      dockerfile: docker/Dockerfile
    env_file:
      - .env
    environment:
      - INVOKEAI_ROOT=${CONTAINER_INVOKEAI_ROOT:-/invokeai}
      - HF_HOME
    ports:
      - "${INVOKEAI_PORT:-9090}:${INVOKEAI_PORT:-9090}"
    volumes:
      - type: bind
        source: ${HOST_INVOKEAI_ROOT:-${INVOKEAI_ROOT:-~/invokeai}}
        target: ${CONTAINER_INVOKEAI_ROOT:-/invokeai}
        bind:
          create_host_path: true
      - ${HF_HOME:-~/.cache/huggingface}:${HF_HOME:-/invokeai/.cache/huggingface}
    tty: true
    stdin_open: true

services:
  invokeai-cuda:
    <<: *invokeai
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

  invokeai-cpu:
    <<: *invokeai
    profiles:
      - cpu

  invokeai-rocm:
    <<: *invokeai
    environment:
      - AMD_VISIBLE_DEVICES=all
      - RENDER_GROUP_ID=${RENDER_GROUP_ID}
    runtime: amd
    profiles:
      - rocm
```

## Stable Diffusion, ComfyUI 및 ControlNet 통합

### Stable Diffusion 모델 사용

InvokeAI는 다양한 모델 계열을 기본적으로 지원한다:

- **SD 1.5** — 클래식 모델, 방대한 LoRA 생태계
- **SDXL** — 더 높은 해상도, 더 나은 프롬프트 준수
- **FLUX / FLUX.2** — 2025-2026년 최신 기술 수준의 품질
- **Z-Image** — 미세 조정에 최적화된 언디스틸 모델

**모델 매니저를 통한 모델 추가:**

1. WebUI 열기 → 모델 매니저 탭
2. "모델 설치" 클릭 → Hugging Face URL 또는 로컬 경로 붙여넣기
3. 모델이 자동으로 다운로드 및 변환됨

**수동 모델 추가:**

```bash
# .safetensors 또는 .ckpt 파일을 모델 디렉토리에 복사
cp your-model.safetensors /opt/invokeai-data/models/sd-1/main/

# 컨테이너 재시작
docker compose restart
```

### ControlNet 통합

InvokeAI는 노드 워크스페이스를 통해 기본 ControlNet을 지원한다. 사용 가능한 프로세서에는 깊이 맵, Canny 에지, OpenPose, 세그멘테이션 등이 포함된다.

**워크플로우에서 ControlNet 사용:**

1. UI에서 워크플로우 탭 열기
2. 노드 라이브러리에서 ControlNet 노드 추가
3. 기본 모델과 참조 이미지 연결
4. 전처리기 선택 (Canny, Depth, OpenPose 등)
5. 제어 강도 설정 (0.5–1.0 권장)
6. 생성을 큐에 추가

### ComfyUI 워크플로우 가져오기

InvokeAI와 ComfyUI는 서로 다른 워크플로우 형식을 사용하지만, ComfyUI 파이프라인을 InvokeAI의 노드 에디터에서 재현할 수 있다. 노드 라이브러리는 다음을 포함한다:

- KSampler / Sampler 노드
- CLIP Text Encode
- VAELoader / VAEDecode
- Image Scale 노드
- ControlNet 프로세서

```python
# 예시: InvokeAI의 REST API를 통한 프로그래밍 방식 생성 매개변수 설정 (v6.12.0+)
import requests

response = requests.post(
    "http://localhost:9090/api/v1/sessions",
    json={
        "model": "stable-diffusion-xl-base-1.0",
        "width": 1024,
        "height": 1024,
        "steps": 30,
        "cfg_scale": 7.5,
        "scheduler": "euler_a",
        "positive_prompt": "사이버펑크 도시의 야경, 네온 불빛, 매우 상세함",
        "negative_prompt": "흐릿함, 저품질, 왜곡"
    }
)
print(response.json()["session_id"])
```

## 벤치마크 / 실제 사용 사례

### SDXL 생성 속도 (RTX 3060 Ti, 8GB VRAM)

| 플랫폼 | 768×1024 (평균) | 1024×1024 (평균) | 참고 |
|--------|----------------|------------------|------|
| **InvokeAI** | 18.83초 | 24.44초 | 전문 UI, 큐 시스템 |
| **ComfyUI** | 16.16초 | 21.47초 | 원시 생성 속도 최고 |
| **AUTOMATIC1111** | 27.33초 | 36.00초 | VRAM 오버헤드 최대 |
| **Fooocus** | ~22초 | ~28초 | SDXL 전용 최적화 |

*출처: 독립 벤치마크, Ryzen 5800X + RTX 3060 Ti, 30 스텝, Euler ancestral, CFG 7, MBB XL 모델.*

### VRAM 사용량 비교 (FLUX Dev, 1024×1024)

| 플랫폼 | VRAM 사용량 | 참고 |
|--------|------------|------|
| InvokeAI | 14.2 GB | 효율적인 모델 캐싱 |
| ComfyUI | 13.8 GB | 최저 오버헤드 |
| AUTOMATIC1111 | 16.1 GB | 단일체 아키텍처 |
| Fooocus | 12.5 GB | SDXL 워크플로우로 제한 |

## 고급 사용법 / 프로덕션 강화

### 멀티유저 모드 (v6.12.0+)

InvokeAI는 이제 단일 백엔드에서 여러 격리된 계정을 지원한다:

```bash
# .env에서 멀티유저 모드 활성화
INVOKEAI_ENABLE_MULTIUSER=true
```

각 사용자는 다음을 갖는다:
- 별도의 이미지 보드 및 갤러리
- 독립적인 캔버스 상태
- 독립적인 UI 환경 설정
- 역할 기반 접근 (관리자 vs 일반 사용자)

관리자가 모델과 세션 큐를 관리하고, 일반 사용자는 시스템 모델을 추가하거나 삭제할 수 없다.

### 리버스 프록시 및 SSL

```nginx
# 프로덕션용 Nginx 설정
server {
    listen 443 ssl http2;
    server_name invokeai.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:9090;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 86400;
    }
}
```

### systemd 서비스

```ini
# /etc/systemd/system/invokeai.service
[Unit]
Description=InvokeAI Creative Engine
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/InvokeAI/docker
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
```

활성화 및 시작:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now invokeai
```

### Prometheus 모니터링

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus:latest
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9091:9090"

  dcgm-exporter:
    image: nvcr.io/nvidia/k8s/dcgm-exporter:latest
    runtime: nvidia
    ports:
      - "9400:9400"
```

### 자동 백업

```bash
#!/bin/bash
# /opt/invokeai-backup/backup.sh
BACKUP_DIR="/backups/invokeai"
DATE=$(date +%Y%m%d-%H%M%S)

# 생성된 이미지 및 모델 백업
tar czf "$BACKUP_DIR/images-$DATE.tar.gz" /opt/invokeai-data/images
tar czf "$BACKUP_DIR/models-$DATE.tar.gz" /opt/invokeai-data/models

# 최근 7일만 유지
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete
```

crontab에 추가:

```bash
0 2 * * * /opt/invokeai-backup/backup.sh
```

## 대안과의 비교

| 기능 | InvokeAI | AUTOMATIC1111 | ComfyUI | Fooocus |
|------|----------|---------------|---------|---------|
| **WebUI 완성도** | 전문가용, 크리에이티브 중심 설계 | 기능적이지만 구식 | 미니멀, 노드 중심 | 미니멀, 프롬프트 중심 |
| **노드 기반 워크플로우** | 예, 시각적 에디터 | 아니오 (확장 기반) | 예, 네이티브 | 아니오 |
| **캔버스 (인/아웃페인팅)** | 전체 레이어 기반 캔버스 | 기본 인페인팅 | 커스텀 노드 통해 | 제한적 |
| **멀티유저 지원** | 네이티브 (v6.12.0+) | 아니오 | 아니오 | 아니오 |
| **모델 지원** | SD 1.5, SDXL, FLUX, Z-Image | SD 1.5, SDXL, FLUX (확장) | 전체 (커스텀 노드) | SDXL 전용 |
| **첫 실행 설정 시간** | 15분 (Docker) | 10분 | 15분 | 5분 |
| **REST API** | 전체 API | 부분 | 네이티브 API 없음 | 없음 |
| **VRAM 효율성** | 양호 (FLUX 14.2 GB) | 불량 (FLUX 16.1 GB) | 최고 (FLUX 13.8 GB) | 양호 (SDXL 12.5 GB) |
| **갤러리 관리** | 보드, 태그, 메타데이터 | 기본 파일 브라우저 | 없음 | 기본 |
| **라이선스** | Apache-2.0 | AGPL-3.0 | GPL-3.0 | GPL-3.0 |
| **GitHub 스타** | 27.2K | 75K+ | 75K+ | 40K+ |

## 한계 / 솔직한 평가

**InvokeAI가 적합하지 않은 경우:**

1. **원클릭 캐주얼 생성** — 프롬프트를 입력하고 이미지만 얻고 싶다면 Fooocus가 설치와 사용이 더 빠르다. InvokeAI의 강력함에는 러닝 커브가 따른다.

2. **고도로 실험적인 파이프라인** — ComfyUI의 노드 생태계가 더 크고 최신이다. 새로운 연구 구현(예: 비디오 생성, 3D)은 일반적으로 ComfyUI에 먼저 출시된다.

3. **8GB VRAM 이하** — InvokeAI의 전문 UI 기능은 추가 메모리를 소모한다. 6-8GB 카드에서는 ComfyUI나 Forge가 더 나은 성능을 제공한다. InvokeAI는 FLUX 워크플로우에 12GB+ VRAM을 권장한다.

4. **macOS GPU 가속** — macOS의 Docker는 GPU 패스스루를 지원하지 않는다. 네이티브 설치는 작동하지만 CPU 전용으로 현저히 느리다. Apple Silicon 사용자는 DiffusionBee나 네이티브 ComfyUI가 더 적합할 수 있다.

5. **실시간 협업 편집** — 멀티유저 모드는 사용자를 격리하지만 동시 캔버스 협업은 지원하지 않는다. 각 사용자가 독립적으로 작업한다.

## 자주 묻는 질문

### InvokeAI를 실행하려면 어떤 하드웨어가 필요한가?

최소: 8GB VRAM (NVIDIA RTX 3060 이상), 16GB RAM, 50GB 여유 디스크 공간. 권장: 12GB+ VRAM (RTX 3060 Ti / 4060 Ti), 32GB RAM, SSD 스토리지. FLUX 모델: 16GB+ VRAM (RTX 4080 / 4090). InvokeAI는 NVIDIA CUDA, AMD ROCm 및 CPU 전용 폴팩을 지원한다.

### GPU 없이 InvokeAI를 실행할 수 있나?

예, InvokeAI는 CPU 전용 시스템에서 실행되지만 생성 속도가 10-20배 느리다. CPU Docker 프로파일 사용: `docker compose --profile cpu up -d`. 현대적인 8코어 CPU에서 1024×1024 이미지당 2-5분이 소요된다. 테스트에는 적합하지만 프로덕션 사용에는 적합하지 않다.

### InvokeAI는 모델 라이선스를 어떻게 처리하나?

InvokeAI 자체는 Apache-2.0 라이선스이다. 다운로드하는 모델(SD 1.5, SDXL, FLUX)은 각자의 라이선스를 가진다. InvokeAI의 모델 매니저는 다운로드 전 라이선스 정보를 표시한다. 상업적 사용은 특정 모델 라이선스에 따른다. 프로덕션 배포 전 반드시 확인하라.

### AUTOMATIC1111에서 InvokeAI로 마이그레이션할 수 있나?

예. InvokeAI는 A1111 설치의 기존 `.safetensors` 및 `.ckpt` 모델을 사용할 수 있다. `INVOKEAI_ROOT`를 기존 모델 디렉토리로 지정하거나 모델을 InvokeAI 모델 폴터에 복사하라. A1111 확장과 스크립트는 이전되지 않는다. InvokeAI는 자체 노드 기반 워크플로우 시스템을 사용한다.

### InvokeAI를 새 버전으로 업데이트하려면?

Docker 설치의 경우 최신 이미지를 가져오고 재시작한다:

```bash
cd InvokeAI/docker
docker compose pull
docker compose up -d
```

베어 메탈 설치의 경우 런처를 사용한다:

```bash
invokeai-update
```

주요 버전 업데이트 전 항상 `INVOKEAI_ROOT` 디렉토리를 백업하라.

### InvokeAI의 호스팅/클리우드 버전이 있나?

InvokeAI는 주로 자체 호스팅이다. 개발자는 Invoke for Teams(상용 제품)를 제공하며 클라우드 호스팅, 팀 협업 및 엔터프라이즈 지원을 추가한다. 개인 사용자는 일반적으로 로컬 GPU 또는 클라우드 VPS(DigitalOcean, RunPod)에서 자체 호스팅한다.

### v6.12.0의 멀티유저 모드는 어떻게 작동하나?

멀티유저 모드는 독립된 갤러리, 캔버스 상태 및 환경 설정을 가진 별도 계정을 생성한다. 관리자 계정이 모델과 시스템 설정을 관리한다. `INVOKEAI_ENABLE_MULTIUSER=true`로 활성화한다. 각 사용자는 사용자 이름과 비밀번호로 로그인한다. v6.12.0에서 실험적 기능으로 표시된다. 향후 릴리스에서 개선될 예정이다.

## 결론

InvokeAI는 AI 이미지 생성 생태계에서 특정 틈새를 채운다. 전문가 수준의 자체 호스팅 크리에이티브 도구로, Stable Diffusion의 강력함과 세련된 사용자 경험을 결합한다. v6.12.0 릴리스는 멀티유저 지원, 확장된 FLUX 호환성 및 개선된 갤러리 관리를 가져와 소규모 스튜디오와 디자인 팀에 적합하게 만든다. Docker 기반 배포는 간단하고, 노드 워크플로우 시스템은 강력하며, Apache-2.0 라이선스는 상업적 사용에 제한을 두지 않는다.

**다음 단계:**
1. 리포지토리를 클론하고 로컬에서 Docker 설정 실행
2. 모델 매니저를 통해 첫 번째 SDXL 또는 FLUX 모델 설치
3. 특정 사용 사례를 위한 노드 기반 워크플로우 구축
4. 커뮤니티 참여: [InvokeAI Discord](https://discord.gg/ZmtBAhwWhy)

매주 오픈소스 AI 도구 업데이트를 위해 Telegram 채널을 팔로우하라: [dibi8 announcements](https://t.me/dibi8com)



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [InvokeAI GitHub 리포지토리](https://github.com/invoke-ai/InvokeAI)
- [InvokeAI 공식 문서](https://invoke.ai/)
- [InvokeAI v6.12.0 릴리스 노트](https://invoke.ai/releases/version/v6-12-0/)
- [InvokeAI Docker 설정 가이드](https://github.com/invoke-ai/InvokeAI/tree/main/docker)
- [NVIDIA Container Toolkit 설치](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
- [AMD ROCm Docker 문서](https://rocm.docs.amd.com/projects/install-on-linux/en/latest/how-to/docker.html)
- [SDXL 속도 테스트: InvokeAI vs ComfyUI vs A1111](https://lilys.ai/en/notes/comfyui-20260115/sdxl-speed-test-comfyui-invokeai-a1111)
- [ComfyUI vs InvokeAI vs Fooocus 비교](https://toolhalla.ai/blog/comfyui-vs-invokeai-vs-fooocus-2026)
- [InvokeAI PyPI 패키지](https://pypi.org/project/InvokeAI/)

---

*이 기사에는 DigitalOcean 제휴 링크가 포함되어 있다. 이 링크를 통해 가입하면 추가 비용 없이 우리에게 커미션이 지급된다. 이는 사이트와 오픈소스 콘텐츠 지원에 도움이 된다. 모든 의견과 벤치마크는 독립적으로 제작되었다.*
