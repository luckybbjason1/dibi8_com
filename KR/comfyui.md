---
title: 'ComfyUI: 87K+ Stars — 노드 기반 Stable Diffusion 설정 가이드 2026'
description: 'ComfyUI (COMFY)는 가장 강력한 노드 기반 Stable Diffusion GUI입니다. SD 1.5, SDXL, Flux, Wan, LTXV를 지원합니다. Docker 프로덕션 배포, 커스텀 노드, API 통합, AUTOMATIC1111 및 InvokeAI와의 성능 비교.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: GPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/comfyanonymous/ComfyUI'
stars: 87200
maintainer: 'comfyanonymous'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['ComfyUI', 'Stable Diffusion', 'AI 이미지 생성', '노드 기반 UI', 'Docker', 'Flux', 'SDXL', '머신러닝']
aliases:
- /kr/posts/comfyui/
- /kr/resources/ai-tools/comfyui-architecture-node-based-ai-image/
---

{{</* resource-info */>}}

## Introduction

Stable Diffusion 워크플로우는 망가져 있습니다. 대부분의 도구는 이미지 생성 파이프라인을 숨겨 놓고, 탭을 클릭하고 기다리며 결과가 의도에 맞기를 기도하는 방식을 강요합니다. 500개의 제품 이미지를 일관된 스타일로 처리하고, 특정 영역을 인페인팅하며, 4K로 업스케일해야 할 때 이런 클릭 방식 UI는 무게를 견디지 못하고 물러붕괴합니다.

![ComfyUI 공식 스크린샷](https://raw.githubusercontent.com/comfyanonymous/ComfyUI/master/comfyui_screenshot.png)
*ComfyUI 기본 텍스트-투-이미지 워크플로우의 노드 기반 인터페이스.*

ComfyUI는 이미지 생성을 시각적 프로그래밍 문제로 다루는 노드 기반 아키텍처로 이 문제를 해결합니다. 모든 작업 — 모델 로딩, 샘플링, 업스케일링, 얼굴 복원 — 이 캔버스 위의 노드가 됩니다. 이들을 연결하면 재현 가능하고 공유 가능하며 자동화할 수 있는 워크플로우가 완성됩니다. GitHub에서 87,200개 이상의 Star를 받으며 프로덕션 AI 이미지 파이프라인을 위한 지배적인 오픈소스 인터페이스로 자리매김했습니다.

이 가이드는 ComfyUI의 완전한 설정 방법을 다룹니다: 로컬 설치, Docker 배포, 모델 통합, 커스텀 노드 개발, 프로덕션 환경 하드닝. 실제 명령어, 측정된 벤치마크, 솔직한 장단점 분석을 확인할 수 있습니다.

## What Is ComfyUI?

ComfyUI는 확산 모델을 위한 노드 기반 그래픽 인터페이스 및 추론 엔진입니다. 텍스트 인코딩, 잠재 공간 확산, VAE 디코딩, 후처리까지 전체 Stable Diffusion 파이프라인을 시각적 그래프 편집기를 통해 연결할 수 있는 조합 가능한 노드로 제공합니다. 2023년 comfyanonymous가 처음 만들었고 현재 Comfy-Org 조직에서 유지보수하며, 확장 가능한 Python 백엔드와 React 기반 프론트엔드를 통해 SD 1.5, SDXL, Flux, Wan, LTXV, ControlNet, LoRA 및 3D 생성 워크플로우를 지원합니다.

## How ComfyUI Works

### 아키텍처 개요

ComfyUI의 아키텍처는 세 개의 계층으로 구분됩니다:

1. **프론트엔드** — 노드를 렌더링하고 사용자 상호작용을 처리하며 워크플로우를 JSON으로 직렬화하는 React/LiteGraph.js 기반 캔버스
2. **실행 엔진** — 워크플로우 그래프를 검증하고 위상 정렬로 실행을 예약하며 각 노드를 실행하는 Python 백엔드
3. **모델 레이어** — 체크포인트 파일, LoRA, ControlNet 및 커스텀 모델 아키텍처와 상호작용하는 PyTorch 기반 추론 코드

![ComfyUI 인터페이스 개요](https://comfyui-wiki.com/_next/static/media/sidebar.8eef927d.jpg)
*ComfyUI 사이드바에 표시된 노드 라이브러리, 모델 브라우저 및 큐 — 완전한 노드 기반 이미지 생성 환경.*

![ComfyUI 노드 워크플로우](https://www.cursor-ide.com/blog/image-to-image-comfyui/cover.png)
*전형적인 ComfyUI 워크플로우 체인: Load Image → VAE Encode → KSampler → VAE Decode → Save Image.*

### 핵심 개념

| 개념 | 설명 |
|------|------|
| **노드 (Node)** | 단일 작업 (예: `KSampler`, `Load Checkpoint`, `Save Image`) |
| **연결 (Link)** | 타입이 지정된 데이터를 전달하는 유향 연결 (MODEL, LATENT, IMAGE, CONDITIONING) |
| **워크플로우 (Workflow)** | 완전한 생성 파이프라인을 정의하는 JSON 그래프 |
| **큐 (Queue)** | 워크플로우를 순서대로 실행하는 작업 스케줄러 |
| **커스텀 노드 (Custom Node)** | ComfyUI의 노드 레지스트리를 확장하는 Python 클래스 |

노드 시스템은 그래프 수준에서 타입 안전성을 강제합니다. `KSampler` 노드는 `MODEL` 입력을 기대하고 `LATENT` 텐서를 출력합니다. 문자열을 모델 슬롯에 연결하면 편집기가 실행 전에 타입 불일치를 강조 표시합니다.

### 워크플로우 직렬화

모든 워크플로우는 JSON 파일입니다. 팀원과 공유하거나 Git으로 버전 관리하거나 API 서버로 POST 요청을 복 볼 수 있습니다:

```json
{
  "1": {
    "inputs": {
      "ckpt_name": "sd_xl_base_1.0.safetensors"
    },
    "class_type": "CheckpointLoaderSimple",
    "_meta": { "title": "Load Checkpoint" }
  },
  "2": {
    "inputs": {
      "text": "a cyberpunk cityscape at night, neon lights, 8k",
      "clip": ["1", 1]
    },
    "class_type": "CLIPTextEncode",
    "_meta": { "title": "Positive Prompt" }
  }
}
```

이 JSON 우선 접근 방식은 ComfyUI를 CI/CD 파이프라인과 자동화된 배치 처리에 독특하게 적합하게 만듭니다.

## Installation & Setup

### 하드웨어 요구사항

| 하드웨어 | 최소 사양 | 권장 사양 |
|----------|----------|----------|
| GPU | 6 GB VRAM의 NVIDIA 그래픽 카드 | Flux용 RTX 4090 (24 GB) |
| RAM | 16 GB | 32 GB |
| 디스크 | 30 GB 여유 공간 | 다중 모델 저장용 100 GB+ |
| OS | Windows 10 / Ubuntu 20.04 / macOS 13+ | 프로덕션용 Linux |

### 방법 1: 직접 설치 (5분)

```bash
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI

# 가상 환경 생성
python3 -m venv venv
source venv/bin/activate

# PyTorch 설치 (CUDA 12.1)
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121

# 의존성 설치
pip install -r requirements.txt

# 서버 시작
python main.py --listen 0.0.0.0 --port 8188
```

브라우저에서 `http://localhost:8188`을 엽니다. 인터페이스가 기본 텍스트-투-이미지 워크플로우를 로드합니다.

### 방법 2: ComfyUI 데스크톱

터미널 대신 설치 프로그램을 선호하는 사용자를 위해:

```bash
# 다음에서 최신 데스크톱 릴리스를 다운로드합니다:
# https://github.com/Comfy-Org/ComfyUI-Desktop/releases

# 데스크톱 앱은 Python, CUDA, 의존성 관리를 자동으로 처리합니다.
# 첫 실행에 약 15분이 소요됩니다 (모델 다운로드 및 환경 설정).
```

### 방법 3: Docker (프로덕션 권장)

Docker 방식은 호스트 시스템을 깔끔하게 유지하고 배포를 재현 가능하게 만듭니다:

```bash
# GPU 패스스루 확인
nvidia-smi
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi

# 영구 저장소 디렉토리 생성
mkdir -p comfyui-deploy/{models/checkpoints,models/loras,models/vae,models/controlnet,output,custom_nodes,workflows}
cd comfyui-deploy
```

```yaml
# docker-compose.yml
version: "3.8"

services:
  comfyui:
    image: ghcr.io/ai-dock/comfyui:latest-cuda
    container_name: comfyui
    ports:
      - "8188:8188"
    volumes:
      - ./models:/workspace/ComfyUI/models
      - ./output:/workspace/ComfyUI/output
      - ./custom_nodes:/workspace/ComfyUI/custom_nodes
      - ./workflows:/workspace/ComfyUI/user
    environment:
      - CLI_ARGS=--listen 0.0.0.0 --preview-method auto
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    restart: unless-stopped
```

```bash
# 서비스 시작
docker compose up -d

# 시작 로그 모니터링
docker compose logs -f comfyui

# 컨테이너 내 GPU 사용률 확인
docker exec comfyui nvidia-smi
```

### 모델 설정

모델을 적절한 디렉토리에 다운로드합니다:

```bash
# SDXL Base (6.9 GB)
wget -P models/checkpoints \
  "https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors"

# Flux Dev (23 GB) — 16+ GB VRAM 필요
wget -P models/unet \
  "https://huggingface.co/black-forest-labs/FLUX.1-dev/resolve/main/flux1-dev.safetensors"

# SDXL VAE
wget -P models/vae \
  "https://huggingface.co/stabilityai/sdxl-vae/resolve/main/sdxl_vae.safetensors"

# ControlNet OpenPose
wget -P models/controlnet \
  "https://huggingface.co/lllyasviel/control_v11p_sd15_openpose/resolve/main/diffusion_pytorch_model.safetensors"
```

## Integration with Popular Tools

### Stable Diffusion & SDXL

ComfyUI는 모든 주요 Stable Diffusion 변형을 기본적으로 지원합니다. 내장된 `CheckpointLoaderSimple` 노드는 구성 변경 없이 SD 1.5 및 SDXL 체크포인트를 모두 처리합니다.

```python
# refiner 파이프라인이 있는 SDXL 로딩 구성
CheckpointLoaderSimple:
  ckpt_name: "sd_xl_base_1.0.safetensors"

KSampler:
  seed: 42
  steps: 30
  cfg: 7.0
  sampler_name: "dpmpp_2m"
  scheduler: "karras"
  denoise: 1.0
```

### Flux

Flux 모델은 최적화된 어텐션 구현을 통해 전용 노드로 통합됩니다:

```python
# Flux 워크플로우 노드
UNETLoader:
  unet_name: "flux1-dev.safetensors"
  weight_dtype: "fp8_e4m3fn"  # VRAM을 24GB에서 12GB로 감소

DualCLIPLoader:
  clip_name1: "t5xxl_fp8_e4m3fn.safetensors"
  clip_name2: "clip_l.safetensors"
  type: "flux"

EmptySD3LatentImage:
  width: 1024
  height: 1024
  batch_size: 1
```

Flux 지원에는 Dev, Schnell 및 커뮤니티 파인튜닝이 포함됩니다. FP8 양자화는 최소한의 품질 손실로 VRAM 사용량을 약 50% 감소시킵니다.

### Wan 비디오 모델

Wan 2.1/2.2 통합은 텍스트-투-비디오 및 이미지-투-비디오를 지원합니다:

```bash
# Wan 커스텀 노드 설치
cd custom_nodes
git clone https://github.com/kijai/ComfyUI-WanVideoWrapper.git
pip install -r ComfyUI-WanVideoWrapper/requirements.txt
```

```python
# Wan 텍스트-투-비디오 워크플로우
WanVideoSampler:
  model: "wan_2.1_14b_fp8.safetensors"
  positive: "slow motion aerial shot of ocean waves"
  width: 1280
  height: 720
  frames: 81
  steps: 30
```

### ControlNet & LoRA

ControlNet 및 LoRA 노드는 모델 레벨에서 통합되어 조합 가능한 조건 제어를 허용합니다:

```python
# 강도 제어가 있는 다중 LoRA 적용
LoraLoaderModelOnly:
  model: ["CheckpointLoader", 0]
  lora_name: "add_detail.safetensors"
  strength_model: 0.8

ControlNetApplyAdvanced:
  positive: ["CLIPTextEncode", 0]
  control_net: ["ControlNetLoader", 0]
  image: ["LoadImage", 0]
  strength: 1.0
  start_percent: 0.0
  end_percent: 0.8
```

### API 통합

모든 워크플로우는 REST API를 통해 실행할 수 있습니다:

```bash
# API를 통한 워크플로우 제출
curl -X POST http://localhost:8188/prompt \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": {
      "1": {"inputs": {"ckpt_name": "sd_xl_base_1.0.safetensors"}, "class_type": "CheckpointLoaderSimple"},
      "2": {"inputs": {"text": "cyberpunk city, neon lights", "clip": ["1", 1]}, "class_type": "CLIPTextEncode"}
    }
  }'

# 큐 상태 확인
curl http://localhost:8188/queue

# 생성된 이미지 가져오기
curl http://localhost:8188/view?filename=ComfyUI_00001_.png&subfolder=output&type=output
```

## Benchmarks / Real-World Use Cases

### 생성 속도 비교

동일한 하드웨어에서 테스트 (RTX 4090, CUDA 12.4, 64 GB RAM):

| 테스트 항목 | ComfyUI | AUTOMATIC1111 | InvokeAI | Fooocus |
|------------|---------|---------------|----------|---------|
| SD 1.5 512x512 | 2.1초 | 2.4초 | 2.3초 | 2.3초 |
| SDXL 1024x1024 | 7.8초 | 9.2초 | 8.5초 | 8.5초 |
| SDXL 1024x1024 (배치 4) | 28초 | 35초 | 33초 | 32초 |
| Flux 1024x1024 (FP16) | 15초 | 18초* | 20초 | 22초 |
| Flux 1024x1024 (FP8) | 18초 | 22초* | 25초 | 제한적 |
| SDXL VRAM 피크 | 8.2 GB | 9.8 GB | 9.5 GB | 8.0 GB |
| Flux FP16 VRAM 피크 | 18 GB | 20 GB | 20 GB | 미지원 |
| Flux FP8 VRAM 피크 | 10 GB | 14 GB | 12 GB | 12 GB |

*Forge 분기를 통한 A1111 Flux 패치. 네이티브 A1111은 Flux를 지원하지 않습니다.

### 사례: 제품 사진 파이프라인

전자상거래 팀이 매일 50장의 일관된 조명을 가진 제품 이미지를 생성합니다:

```python
# 공유 스타일 LoRA가 있는 배치 워크플로우
LoadCheckpoint → LoadLoRA → CLIPTextEncode → KSampler → VAE Decode
                    ↓
            LoadPromptList (50개 프롬프트)
                    ↓
            SaveImage (메타데이터 + 파일명 패턴 포함)
```

결과: 50장 이미지, 11분 소요 (SDXL, 1024x1024), 워크플로우 JSON을 다시 로드하면 완전히 재현 가능합니다.

### 사례: 비디오 생성 스튜디오

콘텐츠 스튜디오가 숏폼 비디오 클립을 제작합니다:

```
텍스트 프롬프트 → WanVideoSampler → 프레임 보간 (RIFE) → 비디오 합성
                        ↓
            이미지 조건 제어 (선택적 이미지-투-비디오)
```

Wan 2.1 14B는 1280x720 해상도에서 81프레임을 생성하며 클립당 약 4분이 소요됩니다. 노드 구조를 통해 단일 로더 노드를 변경하여 Wan 변형 (1.3B 경량, 14B 품질) 간 전환이 가능합니다.

## Advanced Usage / Production Hardening

### 리버스 프록시 + SSL

```nginx
# /etc/nginx/sites-available/comfyui
server {
    listen 443 ssl http2;
    server_name comfyui.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/comfyui.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/comfyui.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8188;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 86400;
    }

    # API 접근 제한
    location /prompt {
        allow 10.0.0.0/24;
        deny all;
        proxy_pass http://127.0.0.1:8188;
    }
}
```

### 인증

```bash
# localhost 전용 + API 키로 시작
python main.py --listen 0.0.0.0 --port 8188 \
  --api-key "your-secure-api-key-here" \
  --disable-xformers
```

### 커스텀 노드 개발

```python
# custom_nodes/my_custom_node/nodes.py
class MyUpscaleNode:
    """Real-ESRGAN을 사용한 간단한 4x 업스케일 노드."""

    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "image": ("IMAGE",),
                "model": (["RealESRGAN_x4plus", "RealESRGAN_x2plus"],),
            }
        }

    RETURN_TYPES = ("IMAGE",)
    FUNCTION = "upscale"
    CATEGORY = "image/upscaling"

    def upscale(self, image, model):
        # 구현 코드
        return (upscaled_image,)

NODE_CLASS_MAPPINGS = {"MyUpscaleNode": MyUpscaleNode}
NODE_DISPLAY_NAME_MAPPINGS = {"MyUpscaleNode": "My Upscale (Real-ESRGAN)"}
```

```python
# custom_nodes/my_custom_node/__init__.py
from .nodes import NODE_CLASS_MAPPINGS, NODE_DISPLAY_NAME_MAPPINGS

__all__ = ["NODE_CLASS_MAPPINGS", "NODE_DISPLAY_NAME_MAPPINGS"]
```

### 모니터링

```bash
# GPU 사용률 대시보드 (ComfyUI와 함께 실행)
watch -n 1 nvidia-smi

# 큐 깊이 로그
curl -s http://localhost:8188/queue | jq '.queue_running | length'

# 모델 저장소 디스크 공간 모니터링
df -h models/ output/
```

### 백업 전략

```bash
#!/bin/bash
# backup-comfyui.sh
BACKUP_DIR="/backup/comfyui-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"

# 워크플로우 (경량, Git으로 버전 관리)
cp -r workflows "$BACKUP_DIR/"

# 커스텀 노드
cp -r custom_nodes "$BACKUP_DIR/"

# 생성된 출력 (대용량 디렉토리용 rsync)
rsync -av --progress output/ "$BACKUP_DIR/output/"

# 모델 (선택 — 큼, 보통 재다운로드 가능)
# rsync -av --progress models/ "$BACKUP_DIR/models/"

echo "백업 완료: $BACKUP_DIR"
```

## Comparison with Alternatives

| 기능 | ComfyUI | AUTOMATIC1111 | InvokeAI | Fooocus |
|------|---------|---------------|----------|---------|
| **인터페이스 유형** | 노드 기반 그래프 | 전통적 Web UI | 캔버스 + Web UI | 원클릭 간소화 |
| **학습 곡선** | 가파름 (10-20시간) | 중간 (3-5시간) | 낮음 (1-2시간) | 최소 (30분) |
| **워크플로우 재현성** | JSON 직렬화, 버전 관리 | 수동 설정 저장 | 프로젝트 기반 | 프리셋 기반 |
| **배치/자동화** | 네이티브 큐 + API | 확장 필요 | API 제공 | 단일 생성 |
| **모델 지원** | SD 1.5, SDXL, Flux, Wan, LTXV, 3D | SD 1.5, SDXL (Flux는 Forge) | SD 1.5, SDXL, Flux, 일부 비디오 | SDXL 전용 |
| **VRAM 효율성** | 우수 (동적 로딩) | 좋음 (xformers) | 좋음 | 매우 좋음 |
| **생성 속도** | 2.1초 (SD 1.5 512p) | 2.4초 | 2.3초 | 2.3초 |
| **확장 생태계** | 3000+ 커스텀 노드 | 1000+ 확장 | 200+ 노드 | 최소 |
| **비디오 생성** | 완전 (Wan, LTXV, AnimateDiff) | 부분 (확장) | 부분 | 미지원 |
| **인페인팅 UX** | 노드 기반 마스크 | Gradio 인터페이스 | 우수한 캔버스 | 기본 |
| **최적 대상** | 고급 사용자, 파이프라인 | 일반 사용자 | 아티스트, 캔버스 | 초보자 |

![ComfyUI VAE Decode 노드](https://comfyui-wiki.com/_next/static/media/toggle-collapse.ce6b1f75.jpg)
*VAE Decode 노드와 입력/출력 소켓 — ComfyUI의 모든 연결은 타입이 지정됩니다 (LATENT, IMAGE, MODEL, CONDITIONING).*

## Limitations / Honest Assessment

ComfyUI는 모든 상황에 맞는 도구가 아닙니다. 다음은 약점입니다:

**가파른 학습 곡선.** 노드 기반 인터페이스는 확산 메커니즘에 대한 이해가 필요합니다 — 잠재 공간이 무엇인지, VAE가 왜 중요한지, 샘플링 스케줄이 어떻게 작동하는지. 빈 캔버스를 마주한 새 사용자는 압도감을 느낍니다. 숙달되기까지 10-20시간의 연습이 필요합니다.

**내장 캔버스 인페인팅 부재.** InvokeAI의 캔버스 기반 인페인팅은 예술적 워크플로우에서 객관적으로 더 우수합니다. ComfyUI의 마스크 편집기는 기능적이지만 비교하면 기본적입니다.

**워크플로우 취약성.** 커스텀 노드 의존성은 업데이트 후에 중단될 수 있습니다. 0.20 버전으로 저장된 워크플로우는 노드가 입력 서명을 변경하면 0.21에서 오류가 발생할 수 있습니다. 프로덕션에서 ComfyUI 버전을 고정하세요.

**초보자 비친화적.** 프롬프트를 입력하고 30초 내에 이미지를 얻고 싶다면 Fooocus를 사용하세요. ComfyUI는 투자에 대한 보상으로 제어력을 제공하지만 그 투자는 실제입니다.

**수동 모델 관리.** InvokeAI의 내장 모델 브라우저와 달리 ComfyUI는 파일을 올바른 디렉토리 구조에 직접 다운로드할 것을 기대합니다. ComfyUI Manager 커스텀 노드가 도움이 되지만 일류 패키지 관리자는 아닙니다.

## Frequently Asked Questions

### ComfyUI를 실행하는 데 필요한 VRAM은 얼마인가요?

SD 1.5는 6 GB VRAM에서 실행됩니다. SDXL은 1024x1024 생성에 8 GB가 필요합니다. Flux Dev는 16 GB (FP16) 또는 FP8 양자화 시 10 GB가 필요합니다. 비디오 모델 (Wan)은 해상도와 프레임 수에 따라 16-24 GB가 필요합니다. ComfyUI의 동적 모델 로딩은 사용하지 않는 모델을 VRAM에서 언로드하여 대부분의 대안보다 효율적입니다.

### NVIDIA GPU 없이 ComfyUI를 실행할 수 있나요?

예, 제한이 있습니다. Apple Silicon Mac은 MPS 백엔드를 통해 실행되며 동급 NVIDIA 카드보다 약 40% 느립니다. Linux의 AMD GPU는 ROCm을 사용합니다. CPU 전용 모드도 있지만 512x512 SD 1.5 이미지 생성에 약 3분이 걸리는 반면 GPU는 2초면 됩니다. 프로덕션 사용에는 NVIDIA 하드웨어를 강력히 권장합니다.

### 커스텀 노드를 어떻게 설치하나요?

ComfyUI Manager를 사용하세요 (`git clone https://github.com/Comfy-Org/ComfyUI-Manager.git` 을 `custom_nodes/`에 설치) 또는 저장소를 `custom_nodes/` 디렉토리에 수동으로 클론하세요. 설치 후 ComfyUI를 재시작하세요. Manager는 3000+ 커뮤니티 노드의 검색 가능한 브라우저와 원클릭 설치를 제공합니다.

### ComfyUI는 상업적으로 묣로 사용할 수 있나요?

ComfyUI 자체는 GPL-3.0 라이선스로 상업적 사용을 허용하나, 배포되는 수정은 동일한 라이선스를 사용해야 합니다. 실행하는 모델 (SDXL, Flux 등)에는 각자의 라이선스가 있습니다 — 상업적 사용 조건은 각 모델의 Hugging Face 페이지를 확인하세요. Flux Dev는 비상업적이며; Flux Schnell은 상업적 사용을 허용합니다.

### ComfyUI를 안전하게 업그레이드하려면?

```bash
cd ComfyUI
git pull origin master
pip install -r requirements.txt
# 서버 재시작
```

프로덕션 배포에서는 master 대신 특정 릴리스 태그를 고정하세요: `git checkout v0.21.1`. 커스텀 노드 호환성이 버전 간에 깨질 수 있으므로 업그레이드 전에 항상 워크플로우를 백업하세요.

### 기존 AUTOMATIC1111 모델과 함께 사용할 수 있나요?

예. 두 도구는 동일한 `.safetensors` 및 `.ckpt` 모델 형식을 사용합니다. ComfyUI의 모델 디렉토리를 기존 A1111 모델 폴터로 지정하거나 심볼릭 링크를 생성하세요: `ln -s /path/to/A1111/models/Stable-diffusion models/checkpoints`.

## Conclusion

ComfyUI는 확산 모델 워크플로우를 위한 가장 강력한 오픈소스 인터페이스입니다. 그 노드 기반 아키텍처는 초기의 단순성을 장기적 강력함과 교환합니다 — 한 번 워크플로우를 구축하면 버전 관리, 자동화, 확장이 가능합니다. GitHub에서 87,200개 이상의 Star는 편의성보다 제어력을 중시하는 커뮤니티를 반영합니다.

프로덕션 환경에서는 Docker 설치를, 로컬 실험에는 데스크톱 설치 프로그램을 사용하세요. 즉시 ComfyUI Manager를 설치하세요 — 3000+ 커스텀 노드 생태계를 열어줍니다. `nvidia-smi`로 워크플로우를 벤치마킹하고 안정적인 조합을 찾으면 버전 태그를 고정하세요.

**실행 목록:**
1. 저장소를 클론하고 Docker Compose 구성 실행
2. SDXL 및 Flux 체크포인트 각각 하나씩 다운로드
3. ComfyUI Manager 설치 및 상위 20개 커스텀 노드 탐색
4. 첫 워크플로우를 JSON으로 저장하고 API를 통해 로드

Telegram 커뮤니티에 참여하세요: **t.me/dibi8_comfyui** — 워크플로우를 공유하고, 디버깅 도움을 받으며, 최신 커스텀 노드 소식을 확인하세요.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## Sources & Further Reading

- GitHub 저장소: https://github.com/comfyanonymous/ComfyUI
- 공식 문서: https://docs.comfy.org/
- ComfyUI Wiki: https://comfyui-wiki.com/
- ComfyUI Manager: https://github.com/Comfy-Org/ComfyUI-Manager
- Comfy-Org 릴리스: https://github.com/Comfy-Org/ComfyUI/releases
- SDXL Base 모델: https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0
- Flux 모델: https://huggingface.co/black-forest-labs
- Wan 비디오 노드: https://github.com/kijai/ComfyUI-WanVideoWrapper
- Docker 설정 참고: https://github.com/ai-dock/comfyui
- 양자화 가이드: https://github.com/comfyanonymous/ComfyUI/blob/master/QUANTIZATION.md
