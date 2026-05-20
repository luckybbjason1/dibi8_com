---
title: 'HunyuanVideo: 12.1K+ Stars — 2026 프로덕션 배포 가이드'
description: 'HunyuanVideo (HYV)은 텐센트가 개발한 130억 파라미터 오픈소스 비디오 생성 프레임워크. ComfyUI, Diffusers, Gradio API 지원. Docker 설치, FP8 양자화, 다중 GPU 추론, 프로덕션 하드닝 포함.'
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
github_repo: 'https://github.com/Tencent-Hunyuan/HunyuanVideo'
stars: 12100
maintainer: 'Tencent-Hunyuan'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['비디오생성', '디퓨전트랜스포머', '텐센트', 'hunyuanvideo', 'comfyui', 'docker', 'fp8', '멀티모달']
aliases:
- /kr/posts/hunyuan-video/
---

{{</* resource-info */>}}

720p에서 5초짜리 클립을 생성하는데 60GB VRAM이 필요한 비디오 생성 모델은 장난감이 아니라 인프라다. 텐센트의 HunyuanVideo는 130억 파라미터의 디퓨전 트랜스포머 비디오 생성 모델로, GitHub에서 12,100개 이상의 스타를 획득했으며 자체 호스팅 하드웨어에서 영화급 비디오 합성이 필요한 팀들의 필수 선택이 되었다. 이 가이드는 완전한 프로덕션 구축을 다룬다: 작동하는 Docker 배포부터 FP8 양자화, 다중 GPU 병렬 추론, ComfyUI 통합, 그리고 대규모 서비스에 필요한 모니터링까지.

## HunyuanVideo란?

HunyuanVideo는 텐센트가 개발한 대규모 비디오 생성 모델을 위한 체계적 프레임워크이다. 원본 릴리스(2024년 12월)는 130억 파라미터의 디퓨전 트랜스포머(DiT)를 탑재하여 텍스트 프롬프트나 참조 이미지로부터 720p 비디오 클립을 생성한다. 2025년 11월 후속 버전인 HunyuanVideo-1.5는 파라미터 수를 83억으로 줄이면서 SSTA(Selective and Sliding Tile Attention) 메커니즘과 내장 1080p 슈퍼 레졸루션 업스케일러를 도입했다. 두 버전 모두 Apache-2.0 라이선스로 NVIDIA GPU가 장착된 Linux에서 실행된다.

## HunyuanVideo의 작동 원리

아키텍처는 세 가지 주요 컴포넌트를 가진 잠재 디퓨전 파이프라인을 따른다:

![HunyuanVideo 전체 아키텍처](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/backbone.png)

**Causal 3D VAE**는 입력 비디오를 잠재 공간으로 압축하며, 시간 압축비는 4x, 공간 압축비는 8x이다. 이는 트랜스포머로 들어가는 토큰 수를 줄여 동일한 컴퓨팅 성장 없이 더 높은 해상도의 생성을 가능하게 한다.

**MLLM 텍스트 인코더**는 이전 비디오 모델에서 사용된 기존 CLIP + T5-XXL 조합을 대체한다. HunyuanVideo는 양방향 토큰 리파이너와 함께 멀티모달 대형 언어 모델(1.5에서는 미세 조정된 Qwen2.5-VL 변형)을 텍스트 인코더로 사용한다. 이는 복잡한 장면 설명에 대한 더 나은 프롬프트 충족 능력을 제공한다.

![HunyuanVideo 텍스트 인코더 아키텍처](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/text_encoder.png)

**듀얼 스트림에서 싱글 스트림 DiT**는 초기 트랜스포머 블록에서 비디오와 텍스트 토큰을 독립적으로 처리하고(듀얼 스트림), 이후 블록에서 이들을 연결하여 멀티모달 퓨전을 수행한다(싱글 스트림). 이 하이브리드 디자인은 모달리티별 학습과 크로스모달 어텐션 사이의 균형을 맞춘다.

![HunyuanVideo 3D VAE 아키텍처](https://raw.githubusercontent.com/Tencent-Hunyuan/HunyuanVideo/main/assets/3dvae.png)

**SSTA 어텐션(1.5 전용)**은 슬라이딩 타일 윈도우를 사용하여 중복되는 시공간 key/value 블록을 동적으로 가지친다. FlashAttention-3과 비교하여 10초 720p 합성에서 1.87배의 엔드투엔드 스피드업을 제공한다.

## 설치 및 설정

작동하는 HunyuanVideo 인스턴스를 얻는 가장 빠른 경로는 Docker이다. 커스텀 빌드가 필요한 팀을 위해 수동 conda 설치도 제공한다.

### Docker 배포 (권장)

```bash
# 공식 CUDA 12 이미지 Pull
docker pull hunyuanvideo/hunyuanvideo:cuda_12

# GPU 패스스루로 실행
docker run -itd --gpus all --init --net=host --uts=host --ipc=host \
  --name hunyuanvideo \
  --security-opt=seccomp=unconfined \
  --ulimit=stack=67108864 --ulimit=memlock=-1 \
  --privileged \
  -v /mnt/models:/models \
  -p 8081:8081 \
  hunyuanvideo/hunyuanvideo:cuda_12
```

### Ubuntu 수동 설치

```bash
# 저장소 클론
git clone https://github.com/Tencent-Hunyuan/HunyuanVideo.git
cd HunyuanVideo

# conda 환경 생성
conda create -n hunyuan python==3.10.9 -y
conda activate hunyuan

# CUDA 12.4가 포함된 PyTorch 설치
conda install pytorch==2.6.0 torchvision==0.19.0 torchaudio==2.4.0 \
  pytorch-cuda=12.4 -c pytorch -c nvidia -y

# Python 의존성 설치
python -m pip install -r requirements.txt

# Flash Attention v2 설치로 가속
python -m pip install ninja
python -m pip install git+https://github.com/Dao-AILab/flash-attention.git@v2.6.3

# 다중 GPU 병렬 추론을 위한 xDiT 설치
python -m pip install xfuser==0.4.0
```

### 사전학습 모델 가중치 다운로드

```bash
# huggingface-cli 설치
pip install huggingface_hub

# 메인 DiT 가중치 다운로드
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states.pt" \
  --local-dir ./ckpts

# FP8 양자화 가중치 다운로드 (약 10GB VRAM 절약)
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states_fp8.pt" \
  --local-dir ./ckpts

# 텍스트 인코더 모델 다운로드
huggingface-cli download tencent/HunyuanVideo \
  --include "*text_encoder*" \
  --local-dir ./ckpts
```

### 첫 번째 추론 실행

```bash
conda activate hunyuan

python sample_video.py \
    --video-size 720 1280 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A cat walks on the grass, realistic style, golden hour lighting" \
    --flow-reverse \
    --use-cpu-offload \
    --save-path ./results
```

80GB 미만 VRAM의 GPU에서는 `--use-cpu-offload` 플래그가 필수적이다. 사용하지 않을 때 모델 가중치를 시스템 RAM으로 오프로드하여 속도를 희생하며 메모리를 확보한다.

## 인기 도구와의 통합

### ComfyUI (네이티브 노드)

ComfyUI는 2025년 초에 네이티브 HunyuanVideo 지원을 추가했다. Comfy-Org에서 재패키징된 모델 파일을 다운로드하라:

```bash
# 모델 파일을 ComfyUI/models/ 경로에 배치
# - text_encoders/clip_l.safetensors
# - text_encoders/llava_llama3_vision.safetensors
# - diffusion_models/hunyuan_video_720p_bf16.safetensors
# - vae/hunyuan_video_vae_bf16.safetensors
```

공식 워크플로우 JSON을 ComfyUI로 드래그하여 로드하라. 핵심 노드는 `HunyuanVideoSampler`, `HunyuanVideoDecode`, `TextEncodeHunyuanVideo`이다.

### Kijai의 HunyuanVideoWrapper (고급)

FP8 추론, 비디오 투 비디오, 이미지 투 비디오를 위해서는 커뮤니티 래퍼를 사용하라:

```bash
# ComfyUI 관리자 또는 git으로 설치
cd ComfyUI/custom_nodes
git clone https://github.com/kijai/ComfyUI-HunyuanVideoWrapper.git

# 의존성 설치
cd ComfyUI-HunyuanVideoWrapper
pip install -r requirements.txt
```

Hugging Face의 `Kijai/HunyuanVideo_comfy`에서 FP8 가중치를 다운로드하여 `ComfyUI/models/diffusion_models/`에 배치하라.

### Diffusers 파이프라인

```python
from diffusers import HunyuanVideoPipeline
import torch

pipe = HunyuanVideoPipeline.from_pretrained(
    "tencent/HunyuanVideo-1.5",
    torch_dtype=torch.bfloat16,
    variant="fp8"
)
pipe.enable_model_cpu_offload()

video = pipe(
    prompt="A cat playing piano in a jazz club, warm lighting",
    num_frames=121,
    height=720,
    width=1280,
    num_inference_steps=30,
    guidance_scale=6.0
).frames[0]

# 비디오 저장
import numpy as np
from PIL import Image
frames = [(f * 255).astype(np.uint8) for f in video]
frames = [Image.fromarray(f) for f in frames]
frames[0].save(
    "output.mp4",
    save_all=True,
    append_images=frames[1:],
    duration=67,
    loop=0
)
```

### Gradio API 서버

```bash
# Gradio 서버 시작
python gradio_server.py --flow-reverse

# 또는 모든 인터페이스에 바인딩하여 원격 접근 허용
SERVER_NAME=0.0.0.0 SERVER_PORT=8081 \
  python gradio_server.py --flow-reverse --use-cpu-offload
```

Gradio UI는 프롬프트, 해상도, 프레임 수, CFG 스케일, 시드 등의 파라미터를 노출한다. 프로그래매틱 접근을 위해 브라우저에서 `/run/predict` 엔드포인트를 찾아 JSON 페이로드를 복제하라.

### DigitalOcean GPU Droplets

로컬 GPU 하드웨어가 없는 팀을 위해 DigitalOcean GPU Droplets는 온디맨드로 NVIDIA H100 및 A100 인스턴스를 제공한다:

```yaml
#cloud-config
package_update: true
packages:
  - docker.io
  - nvidia-container-toolkit
runcmd:
  - systemctl restart docker
  - docker pull hunyuanvideo/hunyuanvideo:cuda_12
  - docker run -d --gpus all --name hunyuan \
      -p 8081:8081 -v /mnt/models:/models \
      hunyuanvideo/hunyuanvideo:cuda_12 \
      python gradio_server.py --flow-reverse --use-cpu-offload
```

## 벤치마크 / 실제 사용 사례

RTX 4090 및 데이터센터 GPU 테스트의 커뮤니티 벤치마크 (2026년 3월):

| 모델 | 파라미터 | VRAM (720p) | 생성 시간 (5초, RTX 4090) | 미적 품질 |
|---|---|---|---|---|
| HunyuanVideo (오리지널) | 13B | ~60GB | ~5:50 | 8.8/10 |
| HunyuanVideo-1.5 | 8.3B | ~24GB (INT8) | ~3:20 | 8.5/10 |
| Wan 2.2 | 14B | ~48GB | ~4:20 | 8.5/10 |
| LTX-Video 0.9.5 | 13B | ~16GB | ~1:30 | 7.4/10 |
| CogVideoX-5B | 5B | ~12GB | ~8:10 | 6.8/10 |

**실제 프로덕션 사용 사례:**

- **광고 크리에이티브 생성**: 선전의 한 이커머스 팀이 커스텀 LoRA가 적용된 HunyuanVideo로 매일 200개 이상의 제품 쇼케이스 비디오를 생성한다. 영화급 미적 효과로 Wan 출력 대비 후반 작업 시간이 60% 감소했다고 보고했다.

- **소셜 미디어 콘텐츠 팩토리**: 브라질의 한 MCN이 xDiT 병렬 추론으로 4xA100 노드에서 HunyuanVideo를 실행하여 TikTok과 Reels용 5초 세로 클립을 제작한다.

- **영화 프리비주얼라이제이션**: LA의 한 독립 영화 감독이 이미지 투 비디오 파이프라인으로 스토리보드 프레임에 애니메이션을 입혀 프리비즈 반복 시간을 며칠에서 몇 시간으로 단축했다.

## 고급 사용법 / 프로덕션 하드닝

### FP8 양자화로 메모리 절감

FP8 양자화는 FP32 가중치를 8비트 부동소수점 형식으로 변환하여 최소한의 품질 저하로 약 10GB GPU 메모리 사용량을 줄인다.

```bash
# FP8 가중치 및 스케일 파일 다운로드
huggingface-cli download tencent/HunyuanVideo \
  --include "mp_rank_00_model_states_fp8.pt" \
  --include "mp_rank_00_model_states_fp8_map.pt" \
  --local-dir ./ckpts/fp8

# FP8로 추론 실행
python sample_video.py \
    --dit-weight ./ckpts/fp8/mp_rank_00_model_states_fp8.pt \
    --video-size 1280 720 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A golden retriever runs on a beach at sunset" \
    --flow-reverse \
    --use-cpu-offload \
    --use-fp8 \
    --save-path ./results
```

`--use-fp8` 플래그는 `hyvideo/modules/fp8_optimization.py`에서 FP8 파이프라인을 활성화한다. E4M3 형식(지수 4비트, 가수 3비트)은 메모리를 약 40% 절감하면서 추론에 충분한 정밀도를 유지한다.

### xDiT를 활용한 다중 GPU 병렬 추론

프로덕션 워크로드의 경우 xDiT는 여러 GPU에서 확장되는 Unified Sequence Parallelism을 제공한다:

```bash
# 8 GPU 병렬 추론
torchrun --nproc_per_node=8 sample_video.py \
    --video-size 1280 720 \
    --video-length 129 \
    --infer-steps 50 \
    --prompt "A cinematic aerial shot of a mountain valley at dawn" \
    --flow-reverse \
    --seed 42 \
    --ulysses-degree 8 \
    --ring-degree 1 \
    --save-path ./results
```

1280x720, 129 프레임, 50 스텝의 지연 시간 확장:

| GPU 수 | 지연 시간 (초) | 스피드업 |
|---|---|---|
| 1 | 1904 | 1.00x |
| 2 | 934 | 2.04x |
| 4 | 514 | 3.70x |
| 8 | 338 | 5.64x |

`--ulysses-degree`와 `--ring-degree` 파라미터는 병렬 전략을 제어한다. 대부분의 설정에서는 Ulysses를 먼저 최대화하라.

### 리버스 프록시가 있는 프로덕션 Gradio

```bash
# 프로덕션 설정으로 시작
SERVER_NAME=0.0.0.0 \
SERVER_PORT=8081 \
python gradio_server.py \
  --flow-reverse \
  --use-cpu-offload \
  --use-fp8 \
  --max-queue-size 10 \
  --queue-timeout 300
```

속도 제한이 있는 Nginx 리버스 프록시 뒤에서:

```nginx
upstream hunyuan {
    server 127.0.0.1:8081;
    keepalive 32;
}

server {
    listen 443 ssl http2;
    server_name video-api.yourdomain.com;

    client_max_body_size 100M;

    location / {
        proxy_pass http://hunyuan;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        proxy_read_timeout 600s;
    }

    # 속도 제한: IP당 분당 10개 요청
    limit_req_zone $binary_remote_addr zone=video:10m rate=10r/m;
    limit_req zone=video burst=5 nodelay;
}
```

### Prometheus로 모니터링

```python
# gradio_server.py에 추가 또는 추론 호출 래핑
from prometheus_client import Counter, Histogram, start_http_server
import time

inference_count = Counter('hunyuan_inferences_total', '총 추론 횟수')
inference_duration = Histogram('hunyuan_inference_seconds', '추론 지연 시간')
queue_depth = Gauge('hunyuan_queue_depth', '현재 큐 깊이')

@inference_duration.time()
def generate_video(prompt, height, width, frames, steps):
    inference_count.inc()
    # ... 기존 추론 로직
    return video

# 9090 포트에서 메트릭 서버 시작
start_http_server(9090)
```

### 보안 하드닝

- **모델 가중치 무결성**: Hugging Face 모델 카드에 게시된 SHA-256 체크섬으로 다운로드한 가중치를 검증하라.
- **입력 샌티타이제이션**: MLLM 텍스트 인코더로 본격 병하기 전에 프롬프트를 샌티타이즈하라.
- **GPU 격리**: 다중 테넌트 환경에서 NVIDIA MIG를 사용하여 A100/H100 GPU를 분할하라.
- **네트워크 격리**: 낮은 VPC에서 Gradio 컨테이너를 실행하고 인증된 API 게이트웨이를 통해서만 노출하라.

## 대안과의 비교

| 기능 | HunyuanVideo | Wan 2.2 | CogVideoX-5B | Open-Sora |
|---|---|---|---|---|
| 파라미터 | 13B (1.5는 8.3B) | 14B | 5B | 1.1B - 7B |
| 최대 해상도 | 1080p (SR 통해) | 1080p | 720p | 720p |
| 최소 VRAM (720p) | 24GB (INT8) | 24GB | 12GB | 16GB |
| 텍스트 투 비디오 | 예 | 예 | 예 | 예 |
| 이미지 투 비디오 | 예 (1.5) | 예 | 예 | 예 |
| 라이선스 | Apache-2.0 | Apache-2.0 | Apache-2.0 | BSD-3-Clause |
| 영화급 품질 | 8.8/10 | 8.5/10 | 6.8/10 | 7.0/10 |
| 생성 시간 (5초, 4090) | 5:50 (오리지널) | 4:20 | 8:10 | 6:00 |
| 모션 사실감 | 우수 | 우수 | 보통 | 양호 |
| 이중 언어 프롬프트 | 예 (중/영) | 예 (중/영) | 예 (중/영) | 영어 중심 |
| 내장 업스케일러 | 예 (1.5) | 아니오 | 아니오 | 아니오 |
| ComfyUI 지원 | 예 | 예 | 예 | 예 |
| 다중 GPU 병렬 | 예 (xDiT) | 예 (USP) | 제한적 | 아니오 |

HunyuanVideo의 주요 차별화 요소는 영화급 미학과 모션 사실감이다. "하우스 스타일"은 풍부한 색상 그레이딩, 자연스러운 보케, 영화 같은 모션을 기본적으로 생성한다. Wan 2.2는 포토리얼리스틱 인간 얼굴과 미세 디테일에서 약간 앞선다.

## 한계 / 정직한 평가

**속도**: FP8과 SSTA가 있어도 HunyuanVideo는 Wan 2.2보다 느리고 LTX-Video보다 현저히 느리다. 빠른 반복이 필요한 워크플로우에는 LTX-Video나 상업용 API가 더 적합하다.

**VRAM 요구사항**: 오리지널 13B 모델은 720p 생성에 60GB가 필요하다. 1.5 릴리스의 INT8 양자화만이 이를 24GB로 낮춘다. A100, H100, RTX 4090급 하드웨어가 없는 팀은 CogVideoX나 클라우드 추론을 고려해야 한다.

**프롬프트 의존성**: 짧거나 모호한 프롬프트는 일관성 없는 결과를 낳는다. 모델은 30-60 단어의 상세한 구조화된 설명을 기대한다.

**해상도 한계**: 네이티브 생성은 720p로 제한된다. 1.5의 1080p 슈퍼 레졸루션 네트워크는 처리 시간을 추가하고 복잡한 텍스처에서 아티팩트를 도입할 수 있다.

**클립 길이**: 실제 생성은 5-10초로 제한된다. 더 긴 시퀀스는 H100 사양을 초과하는 컴퓨팅 리소스가 필요하다.

**Linux 전용**: 공식 Windows나 macOS 지원이 없다. WSL2가 작동할 수 있지만 문서화되거나 테스트되지 않았다.

## 자주 묻는 질문

**Q: HunyuanVideo를 실행하는데 실제로 얼마나 많은 VRAM이 필요한가?**

A: 오리지널 13B 모델은 720p 생성에 60GB GPU 메모리가 필요하고 540p에는 45GB가 필요하다. HunyuanVideo-1.5는 INT8 양자화로 24GB로 줄이며 CPU 오프로딩을 활성화하면 14GB까지 낮출 수 있다. FP8 가중치는 FP16 대비 약 10GB를 절약한다. 프로덕션에는 NVIDIA A100 80GB 또는 H100을 권장하며, 실험용으로는 RTX 4090 (24GB)로 1.5 모델을 양자화하여 실행할 수 있다.

**Q: Windows에서 HunyuanVideo를 실행할 수 있는가?**

A: 공식적으로는 아니오 — 프로젝트는 Linux만 지원한다. 일부 사용자가 WSL2와 CUDA 패스스루로 성공했다고 보고했지만 텐센트 팀이 문서화하거나 지원하지 않는다. Windows 기반 팀에게 WSL2 백엔드를 사용하는 Docker Desktop이 가장 실현 가능한 경로이다.

**Q: HunyuanVideo는 Sora나 Kling 같은 상업용 API와 어떻게 비교되는가?**

A: 인간 평가에서 HunyuanVideo는 모션 품질과 전체 순위에서 Runway Gen-3과 Luma 1.6을 능가했다. 선도적인 상업 모델과의 격차는 크게 좁혀졌지만 포토리얼리스틱 인간 피사체에서 여전히 측정 가능한 차이가 있다. 트레이드오프는 비용이다: 상업용 API는 초당 $0.10-0.50을 청구하는 반면, 자체 호스팅 HunyuanVideo는 GPU 컴퓨팅 시간만 필요하다 (H200 클라우드 인스턴스에서 약 $0.14-0.21/초).

**Q: HunyuanVideo에 가장 적합한 프롬프트 형식은 무엇인가?**

A: 주제, 동작, 환경을 명확히 분리하는 구조화된 프롬프트를 사용하라. 30-60 단어를 목표로 하라. 프롬프트 재작성 기능을 활성화하여 짧은 프롬프트를 모델이 선호하는 설명으로 자동 확장하라.

**Q: 프로덕션에서 추론 속도를 높이려면 어떻게 해야 하는가?**

A: 여러 최적화를 조합하라: (1) FP8 양자화 가중치 사용. (2) xDiT 다중 GPU 병렬 추론 활성화 — 8x A100은 5.6배 스피드업을 제공한다. (3) CFG-증류 모델 변형으로 약 2배 스피드업. (4) TeaCache 기능 캐싱 활성화. (5) 1.5의 경우 SSTA 어텐션 메커니즘이 자동으로 1.87배 스피드업을 제공한다.

**Q: 도움을 받거나 다른 사용자와 HunyuanVideo에 대해 논의할 수 있는 곳은 어디인가?**

A: 텐센트 팀은 GitHub README에 Discord 서버와 WeChat 그룹 링크를 유지한다. 영어 사용자를 위해서는 Hugging Face 커뮤니티 포럼과 ComfyUI Discord에 활발한 HunyuanVideo 채널이 있다.

## 결론

HunyuanVideo는 폐쇄형 상업용 API와 오픈소스 접근성 사이의 격차를 메우는 프로덕션급 비디오 생성 프레임워크이다. 1.5 릴리스로 83억 파라미터, SSTA 어텐션, 소비자 GPU 호환성을 갖추면서 스튜디오와 독립 크리에이터 모두에게 실용적인 선택이 되었다.

오늘 시작하기 위한 액션 아이템:

1. 저장소를 클론하고 GPU 인스턴스에서 Docker 이미지를 실행하라 — 공식 CUDA 12 이미지가 가장 빠른 경로이다.
2. FP8 가중치를 다운로드하고 `sample_video.py`로 첫 720p 생성을 실행하라.
3. Kijai의 래퍼로 ComfyUI와 통합하여 시각적 워크플로우 편집을 하라.
4. [dibi8 Telegram 그룹](https://t.me/dibi8Channel)에 가입하여 배포 전략을 논의하고 커뮤니티와 생성된 비디오를 공유하라.

*이 기사의 일부 링크는 제휴 링크이다. 서비스를 통해 구매하면 커미션을 받을 수 있다 — 이는 추가 비용 없이 dibi8 오픈소스 프로젝트를 지원하는데 도움이 된다.*



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 참고자료

- 공식 저장소: https://github.com/Tencent-Hunyuan/HunyuanVideo
- HunyuanVideo-1.5 저장소: https://github.com/Tencent-Hunyuan/HunyuanVideo-1.5
- 프로젝트 페이지: https://aivideo.hunyuan.tencent.com
- Hugging Face 모델 카드: https://huggingface.co/tencent/HunyuanVideo
- ComfyUI Wiki 튜토리얼: https://comfyui-wiki.com/en/tutorial/advanced/hunyuan-text-to-video-workflow-guide-and-example
- 기술 보고서 (arXiv): https://arxiv.org/abs/2412.03603
- HunyuanVideo 1.5 기술 보고서: https://arxiv.org/abs/2511.18870
- xDiT 병렬 추론: https://github.com/xdit-project/xDiT
- Kijai ComfyUI 래퍼: https://github.com/kijai/ComfyUI-HunyuanVideoWrapper
- DigitalOcean GPU Droplets: https://www.digitalocean.com/products/gpu-droplets
