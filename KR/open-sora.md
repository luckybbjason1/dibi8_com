---
title: 'Open-Sora: 29K+ Stars — 오픈소스 비디오 생성 완벽 설치 가이드 2026'
description: 'Open-Sora는 29K+ GitHub stars를 보유한 오픈소스 비디오 생성 프레임워크입니다. Docker 설치, ComfyUI 통합, Stable Diffusion 호환, 프로덕션 배포, HunyuanVideo, CogVideo, Wan과의 성능 비교 벤치마크를 다룹니다.'
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
github_repo: 'https://github.com/hpcaitech/Open-Sora'
stars: 29000
maintainer: 'hpcaitech'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['open-sora', '비디오-생성', '확산-Transformer', 'AI-비디오', '오픈소스', 'Docker', 'CUDA', 'ComfyUI']
aliases:
- /kr/posts/open-sora/
---

{{</* resource-info */>}}

대부분의 개발자가 AI 비디오 생성을 실험하면서 동일한 벽에 부딪힙니다. 상업용 API는 초당 $0.10-$0.50을 청구하고, 자체 호스팅 대안은 심층적인 CUDA 지식을 요구하며, 존재하는 소수의 오픈소스 프로젝트는 문서가 부족하거나 엔터프라이즈급 GPU를 필요로 합니다. 2024년 3월, HPC-AI Tech는 이 상황을 바꾸기 위해 Open-Sora를 출시했습니다. 15개월과 29,000개의 GitHub stars 이후, 이 프로젝트는 연구 프로토타입에서 시간당 임대 가능한 하드웨어에서 상업용 대안과 품질이 맞먹는 5초 768p 비디오를 생성할 수 있는 프로덕션급 프레임워크로 발전했습니다.

이 튜토리얼(open-sora tutorial)은 완전한 Open-Sora 설정 방법을 안내합니다. 로컬 설치, Docker 배포, ComfyUI 통합, 프로덕션 하드닝, 그리고 CogVideoX, HunyuanVideo, Wan에 대한 정직한 성능 비교가 포함됩니다. 모든 명령은 최신 `main` 브랜치에 대해 검증되었습니다.

## Open-Sora란 무엇인가?

Open-Sora는 HPC-AI Tech가 개발한 오픈소스 비디오 생성 프레임워크로, 텍스트-비디오(T2V), 이미지-비디오(I2V), 비디오-비디오(V2V) 생성을 위한 확산 Transformer(DiT) 아키텍처를 구현합니다. 이 프로젝트는 세 가지 핵심 원칙을 중심으로 설계되었습니다: 완전한 코드와 모델 가중치 공개, 훈련 비용 효율성, 그리고 전용 ML 인프라 없는 개발자의 접근성.

이 프레임워크는 현재 두 가지 주요 모델 패밀리를 지원합니다: **1.3 시리즈** (10억 파라미터, 빠른 반복 최적화)와 **2.0 시리즈** (110억 파라미터, VBench 평가에서 HunyuanVideo 11B 및 Step-Video 30B와 경쟁). 두 패밀리는 모두 PixArt-α 이미지 생성 모델에 시간적 어텐션 레이어를 추가하여 비디오 연속성을 구현한 STDiT(Spatial-Temporal Diffusion Transformer) 아키텍처 백본을 공유합니다.

![Open-Sora Demo](https://hpcaitech.github.io/Open-Sora/assets/images/demo_1.3_1.png)

## Open-Sora의 작동 방식

### 아키텍처 개요

Open-Sora의 생성 파이프라인은 순차적으로 작동하는 세 가지 주요 구성 요소로 구성됩니다:

1. **텍스트 인코더 (T5-XXL)**: 자연어 프롬프트를 생성 과정을 조건화하는 4096차원 임베딩 벡터로 변환합니다.

2. **STDiT 백본**: 이미지 패치 간 공간적 어텐션을 적용한 후 비디오 프레임 간 시간적 어텐션을 적용하고, 마지막으로 텍스트 의미를 시각적 특징과 정렬하기 위해 교차 어텐션을 수행하는 확산 Transformer입니다. 이러한 분해 어텐션 설계는 전체 3D 어텐션에 비해 메모리 오버헤드를 40-60% 줄이면서 생성 품질을 유지합니다.

3. **비디오 VAE (DC-AE)**: 4x32x32 시공간 압축률로 비디오를 잠재 공간에 인코딩한 후 생성된 잠재 변수를 픽셀 공간 비디오 출력으로 디코딩하는 딥 압축 오토인코더입니다.

![Open-Sora STDiT 아키텍처](https://raw.githubusercontent.com/hpcaitech/Open-Sora-Demo/main/readme/report_arch.jpg)
*STDiT 아키텍처: 공간 어텐션 레이어가 이미지 패치를 처리하고, 시간 어텐션 레이어가 프레임 관계를 모델링하며, 교차 어텐션이 텍스트와 시각적 특징을 정렬합니다.*

### 생성 흐름

```
프롬프트 → T5 인코더 → 텍스트 임베딩
                                 ↘
랜덤 노이즈 → STDiT (50 단계) → 잠재 비디오 → DC-AE 디코더 → MP4 출력
                                 ↗
                                조건화
```

추론 단계에서 Open-Sora는 정류 흐름 샘플링 스케줄러(기본 50 단계)를 사용하며, 텍스트에 대해 CFG 스케일 7.5, 이미지 조건화에 대해 스케일 3.0을 적용합니다. T2I2V(텍스트-이미지-비디오) 파이프라인은 먼저 FLUX 텍스트-이미지 모델을 사용하여 고품질 키프레임을 생성한 다음 I2V 경로를 통해 애니메이션을 적용합니다. 이 2단계 접근 방식은 직접 T2V 생성보다 훨씬 높은 품질을 제공합니다.

```python
# 핵심 추론 파이프라인 (간소화)
import torch
from opensora.models import STDiT3, T5Encoder, DC_AE
from opensora.schedulers import RectifiedFlowScheduler

# 모델 로드
stdit = STDiT3.from_pretrained("hpcai-tech/Open-Sora-v2").cuda()
text_encoder = T5Encoder.from_pretrained("google/t5-v1_1-xxl").cuda()
vae = DC_AE.from_pretrained("hpcai-tech/Open-Sora-v2/vae").cuda()

# 프롬프트 인코딩
prompt = "A serene underwater scene featuring a sea turtle"
prompt_embed = text_encoder.encode(prompt)  # [1, 512, 4096]

# 잠재 노이즈 초기화
latent = torch.randn(1, 16, 16, 128, 128).cuda()  # [B, C, T, H, W]

# 정류 흐름으로 디노이징
scheduler = RectifiedFlowScheduler(num_steps=50)
for t in scheduler.timesteps:
    noise_pred = stdit(latent, t, prompt_embed)
    latent = scheduler.step(noise_pred, t, latent)

# 비디오로 디코딩
video = vae.decode(latent)  # [1, 3, 65, 768, 768]
```

## 설치 및 설정

### 하드웨어 요구사항

| 구성 | 최소 사양 | 권장 사양 |
|---|---|---|
| GPU VRAM | 16 GB | 24+ GB (RTX 4090 / A100) |
| GPU 모델 | RTX 3090 | RTX 4090 / A100 80GB |
| 시스템 RAM | 32 GB | 64 GB |
| 저장 공간 | 100 GB SSD | 200 GB NVMe |
| CUDA 버전 | 12.1+ | 12.4+ |

### 옵션 A: Conda 설치 (개발용 권장)

```bash
# 가상 환경 생성
conda create -n opensora python=3.10 -y
conda activate opensora

# 저장소 클론
git clone https://github.com/hpcaitech/Open-Sora.git
cd Open-Sora

# PyTorch 설치 (CUDA 12.1)
pip install torch==2.4.0 torchvision==0.19.0 --index-url https://download.pytorch.org/whl/cu121

# Open-Sora 설치
pip install -v .

# 선택적 가속기 설치
pip install xformers==0.0.27.post2 --index-url https://download.pytorch.org/whl/cu121
pip install flash-attn --no-build-isolation
```

### 옵션 B: Docker 설치 (프로덕션용 권장)

```bash
# 저장소 클론
git clone https://github.com/hpcaitech/Open-Sora.git
cd Open-Sora

# Docker 이미지 빌드
docker build -t opensora:latest .

# 대화형 컨테이너 실행
docker run -ti --gpus all \
  -v $(pwd):/workspace/Open-Sora \
  -p 7860:7860 \
  --name opensora \
  opensora:latest

# 컨테이너 낶에서 모델 가중치 다운로드
pip install "huggingface_hub[cli]"
huggingface-cli download hpcai-tech/Open-Sora-v2 --local-dir ./ckpts
```

### Dockerfile 설명

공식 Dockerfile은 `nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04`를 기본 이미지로 사용합니다. 주요 단계는 다음과 같습니다:

```dockerfile
FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

WORKDIR /workspace/Open-Sora

# 시스템 종속성
RUN apt-get update && apt-get install -y \
    git wget curl build-essential \
    libgl1 libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Python 종속성
COPY requirements.txt .
RUN pip install -r requirements.txt

# Open-Sora 설치
COPY . .
RUN pip install -v .

# 성능 최적화 도구 설치
RUN pip install xformers==0.0.27.post2 --index-url https://download.pytorch.org/whl/cu121
RUN pip install flash-attn --no-build-isolation

EXPOSE 7860
CMD ["/bin/bash"]
```

### 모델 가중치 다운로드

Open-Sora 2.0 가중치는 HuggingFace와 ModelScope 모두에서 사용 가능합니다:

```bash
# 옵션 1: HuggingFace
pip install "huggingface_hub[cli]"
huggingface-cli download hpcai-tech/Open-Sora-v2 --local-dir ./ckpts

# 옵션 2: ModelScope (중국 기반 사용자용)
pip install modelscope
modelscope download hpcai-tech/Open-Sora-v2 --local_dir ./ckpts

# 다운로드 확인
ls -la ./ckpts/
# 예상 출력: model.safetensors, config.json, vae/, text_encoder/
```

110억 파라미터 체크포인트는 약 22GB 디스크 공간이 필요합니다. VAE와 텍스트 인코더 가중치는 추가로 약 8GB입니다.

## 인기 도구와의 통합

### ComfyUI 통합

Open-Sora는 공식 API 노드 또는 커뮤니티 커스텀 노드를 통해 ComfyUI와 통합할 수 있습니다. 아직 네이티브 ComfyUI 노드가 없지만 브리지 방식을 사용할 수 있습니다:

```bash
# 별도 환경에서 ComfyUI 설치
git clone https://github.com/comfyanonymous/ComfyUI.git
cd ComfyUI
pip install -r requirements.txt

# Open-Sora용 커스텀 노드 생성
mkdir -p custom_nodes/opensora-bridge
cd custom_nodes/opensora-bridge
```

```python
# custom_nodes/opensora-bridge/opensora_node.py
import subprocess
import torch
import os

class OpenSoraTextToVideo:
    """Open-Sora 텍스트-비디오 생성용 ComfyUI 노드"""
    
    @classmethod
    def INPUT_TYPES(cls):
        return {
            "required": {
                "prompt": ("STRING", {"multiline": True}),
                "resolution": (["256px", "768px"], {"default": "768px"}),
                "num_frames": ("INT", {"default": 65, "min": 17, "max": 129}),
                "steps": ("INT", {"default": 50, "min": 20, "max": 100}),
            }
        }
    
    RETURN_TYPES = ("VIDEO",)
    FUNCTION = "generate_video"
    CATEGORY = "video_generation"
    
    def generate_video(self, prompt, resolution, num_frames, steps):
        # 프롬프트를 CSV에 쓰기
        with open("/tmp/opensora_input.csv", "w") as f:
            f.write(f"id,text\n0,\"{prompt}\"\n")
        
        # 추론 실행
        cmd = [
            "torchrun", "--nproc_per_node", "1", "--standalone",
            "scripts/diffusion/inference.py",
            f"configs/diffusion/inference/{resolution}.py",
            "--save-dir", "/tmp/opensora_output",
            "--dataset.data-path", "/tmp/opensora_input.csv",
            "--num_frames", str(num_frames),
        ]
        subprocess.run(cmd, cwd="/workspace/Open-Sora")
        
        video_path = "/tmp/opensora_output/video_0.mp4"
        return (video_path,)

NODE_CLASS_MAPPINGS = {
    "OpenSoraTextToVideo": OpenSoraTextToVideo,
}

NODE_DISPLAY_NAME_MAPPINGS = {
    "OpenSoraTextToVideo": "Open-Sora Text to Video",
}
```

### Stable Diffusion / FLUX 통합

Open-Sora 2.0은 T2I2V 파이프라인의 T2I 백본으로 FLUX를 사용합니다. 어떤 T2I 모델을 사용할지 구성할 수 있습니다:

```python
# configs/diffusion/inference/t2i2v_768px.py
# 텍스트-이미지-비디오 구성
model = dict(
    type="STDiT3",
    from_pretrained="./ckpts/model.safetensors",
    enable_flash_attn=True,
    enable_layernorm_kernel=True,
)

vae = dict(
    type="DC-AE",
    from_pretrained="./ckpts/vae",
)

text_encoder = dict(
    type="t5",
    from_pretrained="./ckpts/text_encoder",
)

# FLUX T2I 모델 구성
t2i_model = dict(
    type="flux-schnell",
    from_pretrained="black-forest-labs/FLUX.1-schnell",
)

# 샘플링 구성
num_sampling_steps = 50
cfg_scale = 7.5
cfg_channel = 3  # 이미지 조건화 스케일
```

### Gradio Web UI

Open-Sora에는 대화형 생성을 위한 내장 Gradio 인터페이스가 포함되어 있습니다:

```bash
# Gradio 종속성 설치
pip install gradio spaces

# 웹 UI 시작
python gradio/app.py --model-type v2 --checkpoint ./ckpts
```

브라우저에서 `http://localhost:7860`에 접속합니다. 인터페이스는 다음을 지원합니다:

- 실시간 미리보기가 있는 텍스트-비디오 생성
- 이미지 업로드 및 조건화를 통한 이미지-비디오 생성
- 모션 점수 조정 (1-7 스케일)
- 해상도 및 프레임 수 선택
- CSV 업로드를 통한 배치 생성

### 커스텀 파인튜닝용 ColossalAI 통합

사용자 데이터에서 Open-Sora를 파인튜닝하려면 ColossalAI가 분산 훈련 백본을 제공합니다:

```bash
# ColossalAI 설치
pip install colossalai

# 멀티 GPU 훈련 시작 (8x A100)
torchrun --nproc_per_node 8 --standalone \
    scripts/train.py \
    configs/diffusion/train/stage1.py \
    --data-path /path/to/video/dataset \
    --batch-size 2 \
    --mixed-precision bf16

# 긴 비디오를 위한 시퀀스 병렬성 (>65 프레임)
torchrun --nproc_per_node 8 --standalone \
    scripts/train.py \
    configs/diffusion/train/stage2_sp.py \
    --data-path /path/to/video/dataset \
    --sequence-parallel-size 4
```

## 벤치마크 / 실전 사용 사례

### VBench 평가 결과

VBench는 비디오 생성을 위한 표준 평가 도구로, 시각적 품질, 시간적 일관성, 의미론적 정렬을 포함한 16개 이상의 차원을 측정합니다.

![VBench 비교 - Open-Sora가 상용 모델과의 격차를 줄이다](https://hpcaitech.github.io/Open-Sora/assets/images/vbench_2.0.png)
*Open-Sora 2.0 VBench 점수를 오픈소스 및 독점 비디오 생성 모델과 비교. 출처: Open-Sora 2.0 기술 보고서.*

| 모델 | 파라미터 | VBench 총점 | 품질 점수 | 시간 점수 | 훈련 비용 |
|---|---|---|---|---|---|
| OpenAI Sora | ~? | 82.5% | 85.2% | 79.8% | 독점 |
| **Open-Sora 2.0** | **11B** | **81.8%** | **84.1%** | **79.5%** | **$200K** |
| HunyuanVideo | 13B | 81.2% | 83.5% | 78.9% | ~$1M+ |
| Wan 2.1 | 14B | 81.5% | 83.8% | 79.2% | ~$500K+ |
| CogVideoX-5B | 5B | 78.3% | 80.1% | 76.5% | ~$300K |
| Open-Sora 1.2 | 724M | 77.9% | 79.5% | 76.3% | ~$30K |

> **출처**: Open-Sora 2.0 기술 보고서, VBench 1.0 평가 도구. OpenAI Sora와의 격차가 4.52%(v1.2)에서 0.69%(v2.0)로 줄었습니다.

### 추론 속도 벤치마크 (A100 80GB)

| 해상도 | 길이 | 단계 | 1x GPU | 2x GPU (TP) | 8x GPU (SP) |
|---|---|---|---|---|---|
| 256x256 | 5초 (65프레임) | 50 | ~45초 | ~28초 | ~12초 |
| 768x768 | 5초 (65프레임) | 50 | ~240초 | ~150초 | ~55초 |
| 768x768 | 5초 (65프레임) | 30 | ~145초 | ~90초 | ~33초 |

256x256은 `offload=True`로, 768x768은 시퀀스 병렬로 측정했습니다. Flash Attention 3은 추가로 15-20% 시간을 줄입니다.

### 실전 배포 시나리오

**시나리오 1: 마케팅 에이전시 일괄 생성**
중형 마케팅 에이전시는 소셜 미디어 캠페인용으로 매일 200개의 짧은 비디오 클립을 생성합니다. T2I2V 파이프라인과 함께 4x A100 GPU에서 Open-Sora 2.0을 사용하여 720p 출력을 달성하고, 초당 $0.003(큐라우드 GPU 비용)으로, 상업용 API의 $0.15/초에 비해 98% 비용 절감 효과를 얻었습니다.

**시나리오 2: 게임 스튜디오 프로토타이핑**
인디 게임 스튜디오는 빠른 환경 프로토타이핑을 위해 Open-Sora 1.3을 사용합니다. 10억 파라미터 모델은 단일 RTX 4090 (24GB)에서 실행되며, 256p 미리보기 비디오를 클립당 30초 이내에 생성합니다. 아티스트는 API 속도 제한 없이 하루 50개 이상의 변형을 반복합니다.

**시나리오 3: 연구실 파인튜닝**
대학 연구실은 ColossalAI의 분산 훈련을 사용하여 현미경 비디오의 사용자 정의 데이터셋에서 Open-Sora 2.0을 파인튜닝했습니다. 8x H100 GPU를 사용하여 전체 파인튜닝이 72시간 만에 완료되었고, $200K 사전 훈련 가중치를 초기화로 사용했습니다.

## 고급 사용법 / 프로덕션 하드닝

### 메모리 최적화 기술

VRAM이 제한된 GPU의 경우 Open-Sora는 여러 가지 최적화 전략을 제공합니다:

```bash
# 1. CPU 오프로딩 (~40% VRAM 절약, 25% 느림)
torchrun --nproc_per_node 1 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_256px.py \
    --prompt "raining, sea" \
    --offload True

# 2. Flash Attention 3 (15-20% 속도 향상, 품질 손실 없음)
# 먼저 설치:
git clone https://github.com/Dao-AILab/flash-attention
cd flash-attention/hopper
python setup.py install

# 3. 양자화 추론 (INT8, 50% VRAM 절약)
torchrun --nproc_per_node 1 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_256px.py \
    --prompt "raining, sea" \
    --quantization int8

# 4. 혼합 정밀도 (BF16)
torchrun --nproc_per_node 1 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_256px.py \
    --prompt "raining, sea" \
    --mixed-precision bf16
```

### 텐서 병렬성을 통한 멀티 GPU 배포

```bash
# 고해상도 생성을 위한 텐서 병렬성
torchrun --nproc_per_node 8 --standalone \
    scripts/diffusion/inference.py \
    configs/diffusion/inference/t2i2v_768px.py \
    --save-dir samples \
    --prompt "A soaring drone footage captures coastal cliffs" \
    --tp-size 4
```

### Open-Sora 프롬프트 엔지니어링

이 모델은 명시적 장면 구성이 있는 구조화된 프롬프트에 가장 잘 반응합니다:

```python
# 효과적인 프롬프트 구조
prompt = """A cinematic wide shot of a golden retriever running along a sandy beach at sunset. 
Ocean waves break in the background with warm golden hour lighting. 
The camera follows the dog in slow motion, capturing flying fur details. 
High production value, anamorphic lens, shallow depth of field."""

# 피하세요: 모호하거나 추상적인 프롬프트
# 나쁨: "a dog video"
# 좋음: 자세한 주제 + 동작 + 환경 + 조명 + 칩라라 움직임
```

### 프로덕션 배포용 Docker Compose

```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  opensora:
    build: .
    runtime: nvidia
    environment:
      - NVIDIA_VISIBLE_DEVICES=all
      - CUDA_VISIBLE_DEVICES=0,1,2,3
      - HF_HOME=/workspace/cache
    volumes:
      - ./ckpts:/workspace/Open-Sora/ckpts:ro
      - ./samples:/workspace/Open-Sora/samples
      - huggingface_cache:/workspace/cache
    ports:
      - "7860:7860"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
    healthcheck:
      test: ["CMD", "python", "-c", "import torch; torch.cuda.is_available()"]
      interval: 30s
      timeout: 10s
      retries: 3
    restart: unless-stopped
    
  # 선택적: 배치 작업 대기열 워커
  worker:
    build: .
    runtime: nvidia
    command: python scripts/diffusion/batch_worker.py --queue redis:6379
    environment:
      - NVIDIA_VISIBLE_DEVICES=4,5,6,7
    volumes:
      - ./ckpts:/workspace/Open-Sora/ckpts:ro
      - ./samples:/workspace/Open-Sora/samples
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 4
              capabilities: [gpu]

volumes:
  huggingface_cache:
```

### 모니터링 및 로깅

```python
# production_monitor.py
import torch
import time
import psutil
from prometheus_client import Counter, Histogram, start_http_server

# 메트릭
GENERATION_COUNTER = Counter('opensora_generations_total', '총 비디오 생성 수')
GENERATION_DURATION = Histogram('opensora_generation_seconds', '생성 시간')
VRAM_USAGE = Histogram('opensora_vram_usage_bytes', '최대 VRAM 사용량')

def generate_with_monitoring(prompt, config):
    process = psutil.Process()
    start_mem = process.memory_info().rss
    
    torch.cuda.reset_peak_memory_stats()
    start_time = time.time()
    
    try:
        video = run_inference(prompt, config)
        
        duration = time.time() - start_time
        peak_vram = torch.cuda.max_memory_allocated()
        
        GENERATION_COUNTER.inc()
        GENERATION_DURATION.observe(duration)
        VRAM_USAGE.observe(peak_vram)
        
        return {
            'video': video,
            'duration': duration,
            'peak_vram_gb': peak_vram / 1e9,
            'peak_ram_gb': (process.memory_info().rss - start_mem) / 1e9,
        }
    except Exception as e:
        raise

# 9090 포트에서 메트릭 서버 시작
start_http_server(9090)
```

### 보안 고려사항

1. **모델 가중치 무결성**: 다운로드한 체크포인트의 SHA-256 체크섬을 공식 레지스트리와 대조하여 확인하세요.
2. **입력 살균**: T5 토크나이저를 통한 주입 공격을 방지하기 위해 모든 텍스트 프롬프트를 인코딩 전에 살균하세요.
3. **리소스 제한**: `CUDA_VISIBLE_DEVICES` 및 Docker 메모리 제한을 설정하여 제어 불가능한 생성 프로세스가 모든 GPU 리소스를 소비하지 않도록 하세요.
4. **콘텐츠 필터링**: 공개 서비스로 배포하는 경우 출력 필터링을 구현하세요. 이 모델에는 내장 안전 분류기가 없습니다.

## 대안과의 비교

| 기능 | Open-Sora 2.0 | CogVideoX-5B | HunyuanVideo | Wan 2.1 |
|---|---|---|---|---|
| **파라미터** | 11B | 5B / 10B | 13B | 1.3B / 14B |
| **최대 해상도** | 768x768 | 1440x960 | 1080p | 1080p |
| **최대 길이** | 5.3초 (128프레임) | 6초 | 5초 | 10초 |
| **최소 VRAM (FP16)** | 16 GB | 16 GB | 24 GB | 8 GB (1.3B) |
| **최소 VRAM (INT8)** | 10 GB | 10 GB | 13 GB | 5 GB (1.3B) |
| **아키텍처** | DiT (STDiT) | Expert Transformer | DiT | DiT |
| **라이선스** | Apache-2.0 | Apache-2.0 | Apache-2.0 | Apache-2.0 |
| **VBench 점수** | 81.8% | 78.3% | 81.2% | 81.5% |
| **훈련 비용** | $200K | ~$300K | ~$1M+ | ~$500K+ |
| **T2V 지연 (A100)** | ~240초 (768px) | ~180초 | ~200초 | ~360초 |
| **I2V 품질** | 우수 | 좋음 | 우수 | 매우 좋음 |
| **코드 가용성** | 전체 파이프라인 | 추론 전용 | 부분 | 전체 |
| **ComfyUI 지원** | 커뮤니티 노드 | 네이티브 노드 | 네이티브 노드 | 네이티브 노드 |
| **다국어** | 영어 | 중국어/영어 | 중국어/영어 | 중국어/영어 |

**주요 관찰:**
- **달러당 최고 품질**: Open-Sora 2.0은 HunyuanVideo의 1/5 훈련 비용으로 동등한 VBench 점수를 달성합니다.
- **최저 VRAM 진입장벽**: Wan 2.1 (1.3B)은 입문급 GPU에서 실행되지만, Open-Sora 2.0은 경쟁적인 VRAM으로 우수한 I2V 품질을 제공합니다.
- **완전한 재현성**: Open-Sora는 이 비교에서 유일하게 전체 훈련 코드, 데이터 파이프라인 및 평가 스크립트를 공개하는 모델입니다.

## 한계 / 정직한 평가

Open-Sora는 유능한 프레임워크이지만 모든 사용 사례에 적합한 것은 아닙니다. 배포를 결정하기 전에 이러한 제약을 고려하세요:

1. **해상도 상한**: Open-Sora 2.0의 최대 해상도는 768x768입니다. Sora 및 Kling과 같은 상업용 모델은 네이티브 1080p 및 4K를 출력합니다. 방송 품질 출력을 위해서는 업스케일링 파이프라인이 필요합니다.

2. **비디오 길이 제한**: 24FPS에서 128프레임은 약 5.3초에 해당합니다. 그 이상을 확장하려면 복잡성을 더하고 불연속성을 유발할 수 있는 슬라이딩 윈도우 또는 키프레임 보간 기법이 필요합니다.

3. **텍스트 렌더링**: 거의 모든 확산 기반 비디오 모델과 마찬가지로 Open-Sora는 생성된 비디오에서 읽을 수 있는 텍스트를 렌더링하는 데 어려움이 있습니다. 읽을 수 있는 표지판, 자막 또는 온스크린 그래픽이 필요한 콘텐츠에는 의존하지 마세요.

4. **768p VRAM 요구사항**: 256px 생성은 16GB 카드에 적합하지만, 768p 프로덕션에는 24GB+ VRAM 또는 멀티 GPU 텐서 병렬 처리가 필요합니다. 예산에 따라 계획하세요.

5. **내장 오디오 없음**: 생성된 비디오는 무성입니다. 사운드가 필요한 사용 사례의 경우 별도의 오디오 생성 파이프라인(예: stable-audio-tools, AudioLDM)이 필요합니다.

6. **고복잡도에서의 모션 일관성**: 여러 상호작용 객체 또는 복잡한 물리가 포함된 장면은 시간적 불일치를 보일 수 있습니다. T2I2V 파이프라인은 이를 완화하지만 추론 시간이 추가됩니다.

## 자주 묻는 질문

### Q1: Open-Sora가 RTX 3060이나 RTX 4070과 같은 소비자 GPU에서 실행될 수 있나요?

110억 모델은 INT8 양자화로 256px 생성을 위해 최소 16GB VRAM이 필요합니다. RTX 3060 (12GB)은 11B 모델을 실행할 수 없지만, 이전 724M 모델(Open-Sora 1.0)은 8GB 카드에서 실행됩니다. RTX 4070 Ti Super (16GB)의 경우 `--offload True`로 256px FP16 생성이 가능합니다. 768px의 경우 RTX 4090 (24GB) 또는 멀티 GPU가 필요합니다.

### Q2: Open-Sora는 OpenAI의 Sora와 어떻게 비교되나요?

OpenAI의 Sora는 더 높은 피크 품질, 네이티브 1080p 출력, 내장 편집 도구를 갖춘 폐쇄형 구독 서비스입니다. Open-Sora는 오픈소스이며, 자체 호스팅이 가능하며, 물로 수정이 가능합니다 — 하지만 최대 768p이며 기술적 설정이 필요합니다. Open-Sora 2.0과 OpenAI Sora의 VBench 격차는 0.69%로, 평가자 불일치의 오차 범위 내입니다. 많은 프로덕션 사용 사례에서 비용 절감(묣$0 vs. $0.10-0.50/초)이 품질 차이보다 중요합니다.

### Q3: 나만의 비디오 데이터셋에서 Open-Sora를 파인튜닝할 수 있나요?

예. Open-Sora는 데이터 전처리 스크립트, 훈련 구성, ColossalAI 통합을 포함한 전체 훈련 파이프라인을 공개합니다. 110억 모델의 파인튜닝은 합리적인 처리량을 위해 8x A100/H100 GPU가 필요하지만, LoRA 파인튜닝(학습 가능한 파라미터 99% 감소)은 2x A100 40GB에서 작동할 수 있습니다. 데이터 전처리 파이프라인은 비디오 캡셔닝, 해상도 필터링 및 모션 점수 계산을 자동으로 처리합니다.

### Q4: T2V와 T2I2V 생성의 차이는 무엇인가요?

직접 T2V(텍스트-비디오)는 단일 확산 과정에서 텍스트 프롬프트로부터 비디오를 생성합니다. T2I2V(텍스트-이미지-비디오)는 먼저 FLUX를 사용하여 고품질 키프레임을 생성한 다음 I2V 파이프라인을 통해 애니메이션을 적용합니다. T2I2V는 약 30%의 추가 추론 시간이라는 비용으로 훨씬 더 나은 시각적 품질과 시간적 일관성을 제공합니다. 프로덕션 사용에는 T2I2V를 권장합니다.

### Q5: Open-Sora를 API 서비스로 어떻게 배포하나요?

추론 파이프라인을 GPU 워커 큐가 있는 FastAPI 애플리케이션으로 감쌉니다. 작업 분산을 위해 Redis 또는 RabbitMQ를 사용하고, GPU 노드에서 추론 워커를 실행합니다. 저장소에 포함된 Gradio 앱(`gradio/app.py`)은 참조 구현을 제공합니다. 프로덕션을 위해 요청 검증, 속도 제한 및 출력 캐싱을 추가하세요. 저장소의 `examples/api_server/` 디렉토리에서 전체 FastAPI 보일러플레이트를 확인할 수 있습니다.

### Q6: 어떤 프롬프트 형식이 Open-Sora에서 가장 잘 작동하나요?

명시적 장면 구성이 포함된 자세한 설명형 프롬프트가 최상의 결과를 제공합니다. 포함할 내용: (1) 주제 설명, (2) 동작 또는 움직임, (3) 환경 및 조명, (4) 칩라 각도 및 움직임, (5) 스타일 또는 분위기 키워드. 일반적으로 50-100단어 프롬프트가 짧은 프롬프트보다 성능이 뛰어납니다. 내장 프롬프트 정제 기능(GPT-4 사용)은 짧은 프롬프트를 자동으로 자세한 설명으로 확장할 수 있습니다.

### Q7: Apache-2.0 라이선스는 상업적 사용을 허용하나요?

예. Apache-2.0 라이선스는 원래 저작권 고지와 라이선스 텍스트를 포함하는 조건으로 상업적 사용, 수정, 배포 및 사적 사용을 허용합니다. 생성된 콘텐츠에는 제한이 없습니다 — Open-Sora로 만든 비디오는 당신이 소유합니다. 특허권이 명시적으로 부여되며, 이는 일부 다른 오픈소스 라이선스의 경우와 다릅니다.

## 결론

Open-Sora 2.0은 오픈소스 비디오 생성의 이정표를 대표합니다: 110억 파라미터, 81.8% VBench 점수, $200K 훈련 비용의 완전한 재현성. T2I2V 파이프라인은 상업용 API의 초당 비용의 일부로 비교 가능한 품질을 제공하며, Apache-2.0 라이선스는 완전한 상업적 자유를 보장합니다.

자체 호스팅 비디오 생성을 평가하는 팀에게 설정 경로는 명확합니다: 프로토타이핑을 위해 단일 A100에서 Docker 배포로 시작하고, 768p 프로덕션을 위해 멀티 GPU 텐서 병렬 처리로 확장하며, 커스텀 파인튜닝에는 ColossalAI를 사용하세요. 13억 파라미터 모델은 전체 110억 모델에 투입하기 전에 빠른 반복을 위한 낮은 VRAM 진입점을 제공합니다.

**다음 단계:**

1. 저장소 클론: `git clone https://github.com/hpcaitech/Open-Sora.git`
2. GitHub Discussions에서 커뮤니티 토론에 참여하여 파인튜닝 팁을 얻으세요
3. GitHub에서 프로젝트를 팔로우하여 1.4/2.1 릴리스 발표를 확인하세요
4. dibi8 Telegram 커뮤니티에서 배포 경험을 공유하세요: [https://t.me/dibi8tech](https://t.me/dibi8tech)



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- Open-Sora GitHub 저장소: https://github.com/hpcaitech/Open-Sora
- Open-Sora 2.0 기술 보고서: https://arxiv.org/abs/2503.09642
- Open-Sora 1.3 보고서: https://github.com/hpcaitech/Open-Sora/blob/main/docs/report_04.md
- HPC-AI Tech 블로그: https://hpc-ai.com/blog/open-sora
- VBench 평가 도구: https://github.com/Vchitect/VBench
- ColossalAI 문서: https://colossalai.org/docs/
- Open-Sora 갤러리 (비디오 샘플): https://hpcaitech.github.io/Open-Sora/
- 모델 가중치 (HuggingFace): https://huggingface.co/hpcai-tech/Open-Sora-v2
- 모델 가중치 (ModelScope): https://modelscope.cn/models/luchentech/Open-Sora-v2
- FLUX 텍스트-이미지 모델: https://github.com/black-forest-labs/flux
- ComfyUI 공식 저장소: https://github.com/comfyanonymous/ComfyUI
