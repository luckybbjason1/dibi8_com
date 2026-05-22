---
title: 'Stable Diffusion WebUI 2026 (AUTOMATIC1111): 163k 별 셀프호스트 이미지 생성 완전 가이드'
description: 'AUTOMATIC1111 stable-diffusion-webui는 163k 별의 SD/SDXL 이미지 생성용 사실상 표준 셀프호스트 UI. 2026 완전 설치 + 프로덕션 가이드: txt2img / img2img / 인페인팅 / 아웃페인팅 / LoRA / ControlNet, 하드웨어 요구, 대안(Forge, SD.Next).'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, Gradio, CUDA]
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/AUTOMATIC1111/stable-diffusion-webui'
stars: 163000
maintainer: 'AUTOMATIC1111'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Stable Diffusion', 'SDXL', '이미지 생성', 'AUTOMATIC1111', '오픈소스']
aliases:
  - /posts/stable-diffusion-webui-2026/
---

지난 3년간 "stable diffusion install"을 Google에서 검색하면 첫 결과는 **AUTOMATIC1111의 stable-diffusion-webui**입니다. 163k GitHub 별 (역사상 가장 많은 별의 AI 프로젝트 중 하나)로 2026년 SD 패밀리 이미지 생성의 기본 셀프호스트 UI — text-to-image, image-to-image, inpainting, outpainting, LoRA, ControlNet, 배치 생성, 모두 4 GB GPU에서 실행되는 Gradio 웹 UI 뒤.

이게 솔로 크리에이터와 dev를 위한 "로컬에서 이미지 생성하고 Midjourney에 $20/월 안 내고 싶다" 답. 더 복잡한 워크플로우 (멀티 모델 파이프라인, 비디오 생성, 오디오)는 [ComfyUI](/kr/resources/ai-tools/comfyui-node-based-ai-image-2026/) 참조 — 둘은 보완적이지 경쟁자 아님.

## TL;DR

- **무엇**: SD 패밀리 모델용 Gradio 웹 UI
- **GitHub**: 163k 별, 7,689+ 커밋, 최신 v1.10.1
- **License**: AGPL-3.0 (SaaS 배포 시 주의)
- **모델**: SD 1.5, SD 2.x, SSD-1B, Alt-Diffusion 네이티브; 확장 통한 SDXL; 포크 통한 SD3 / Flux
- **하드웨어**: 4 GB VRAM 최소 (`--lowvram`으로 2 GB 작동 보고)
- **알아둘 만한 포크**: Forge (더 빠름, SDXL/Flux 초점), SD.Next (롤링 릴리스)

## 1. 왜 A1111이 2026에도 여전히 기본인가

Flux(2024년 9월) 출시 후 이미지 생성 생태계가 강하게 분열, SD 3.5가 뒤따름. ComfyUI가 "복잡 파이프라인" 니치 차지. 그러나 A1111이 기본 유지 이유:

1. **가장 낮은 학습 곡선** — 텍스트 박스, 생성 버튼, 끝
2. **가장 많은 확장** — 500+ 확장이 ControlNet, ADetailer, Regional Prompter, 훈련 등 처리
3. **가장 많은 튜토리얼** — 4년치 Reddit/YouTube 콘텐츠가 A1111 모양
4. **80% 사용 사례에 충분** — "텍스트에서 좋은 이미지"만 원할 때 ComfyUI 그래프 뷰는 과잉

로컬 이미지 생성 초보: 여기서 시작. 벗어나면 ComfyUI로 마이그레이션.

## 2. 하드웨어 현실 수치 (2026)

| GPU | SD 1.5 (512×768) | SDXL (1024×1024) | Flux (1024×1024) |
|---|---|---|---|
| 4 GB (GTX 1650 / 3050) | ~15초/이미지 | ~60초 (`--lowvram`) | 비실용적 |
| 8 GB (RTX 3060 / 4060) | ~5초 | ~12초 | ~30초 (`--medvram`) |
| 12 GB (RTX 3060 12GB / 4070) | ~3초 | ~6초 | ~15초 |
| 16-24 GB (RTX 4080 / 4090) | ~1.5초 | ~3초 | ~6초 |

클라우드 사용: Vast.ai 또는 {{< aff "digitalocean" "sd-gpu" "DigitalOcean GPU droplets" >}}의 $0.30-0.50/시간 GPU 인스턴스가 의미 있는 볼륨에서 Midjourney보다 저렴.

## 3. 빠른 설치 (15분)

**Linux/macOS**:
```bash
git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui
cd stable-diffusion-webui
./webui.sh  # Python 의존성 자동 설치, 기본 모델 다운로드
```

**Windows**: 최신 릴리스 zip 다운로드, 압축 해제, `webui-user.bat` 실행.

첫 실행이 ~4 GB (기본 SD 1.5 모델) + ~2 GB Python 의존성 다운로드. 브라우저로 `http://localhost:7860` 열기.

## 4. 80/20 설정

"좋은 이미지만 만들어줘" 워크플로우:

- **Sampler**: DPM++ 2M Karras 또는 Euler a
- **Steps**: 20-30 (30 이상 = 수익 감소)
- **CFG Scale**: 7 (낮을수록 창의적, 높을수록 문자 그대로)
- **해상도**: SD 1.5는 512×768, SDXL은 1024×1024
- **네거티브 프롬프트 베이스라인**: `bad anatomy, blurry, low quality, watermark, text, signature`

고품질: Hires fix 활성화 (2× 업스케일 + denoise 0.4-0.5), 생성 시간 2× 비용.

## 5. 필수 확장

500+ 확장 탭에서 top pick:

- **ControlNet** — pose / depth / canny / scribble 조건화. 가장 유용한 단일 확장
- **ADetailer** — 얼굴과 손 자동 수정 (SD의 두 실패 모드)
- **Regional Prompter** — 이미지의 다른 부분에 다른 프롬프트
- **Dynamic Prompts** — wildcard 구문 `{red|blue|green} car`
- **Civitai Helper** — Civitai에서 다운로드한 모델 관리
- **sd-webui-prompt-history** — 과거 생성에서 프롬프트 복구

설치: Extensions tab → Install from URL → GitHub URL 붙여넣기 → Apply 재시작.

## 6. LoRA / Embedding / ControlNet 워크플로우

3가지 커스터마이징 메커니즘:

- **LoRA** (Low-Rank Adaptation) — 작은 파일 (~150 MB)로 기본 모델을 특정 스타일이나 주제로 적응. `models/Lora/`에 넣고 프롬프트에서 참조: `<lora:style_name:0.8>`
- **Textual Inversion / Embeddings** — 더 작음 (~30 KB), 단일 개념 추가. `embeddings/`에 넣고 프롬프트에 트리거 단어 입력
- **ControlNet** — pose / depth / line art / 등으로 생성 조건화. 모델은 `models/ControlNet/`로

Civitai가 커뮤니티 LoRA와 체크포인트의 사실상 허브. Civitai Helper 확장이 로컬 파일과 메타데이터 자동 동기화.

## 7. SDXL / SD3 / Flux 지원 (2026 현실)

기본으로 A1111 메인라인은 SD 1.x/2.x 함. 새 모델:

- **SDXL** — v1.6부터 메인라인 작동
- **SDXL Turbo / Lightning** — 작동, 가속된 SDXL로 구성
- **SD 3.5** — Forge 포크 또는 확장 필요, 메인라인 뒤처짐
- **Flux** — Forge 포크 필요; A1111 메인라인이 v1.10 기준 Flux 지원 안 함
- **위 + Wan + Hunyuan 모두?** [ComfyUI](/kr/resources/ai-tools/comfyui-node-based-ai-image-2026/)로 전환

SDXL 일상 사용 2026 셋업: A1111 메인라인 작동. Flux 우선 창의 파이프라인: Forge 포크. 모두 지원: ComfyUI.

## 8. 프로덕션 셀프호스트 패턴

"개인 이미지 API" 배포:

```
   {{< aff "digitalocean" "sd-droplet" "GPU droplet" >}} (RTX 6000 Ada $0.50/시간 또는 Vast.ai)
            │
            ▼
   --api 플래그 활성화된 A1111
            │
            ▼
   내부 FastAPI 래퍼 (auth + rate limit + queue)
            │
            ▼
   당신 앱 / 에이전트가 /sdapi/v1/txt2img 호출
```

비용 예: 하루 8시간 사용 × $0.50/시간 × 30일 = 무제한 생성 $120/월, vs Midjourney $30/월 200 fast 시간. 중간 사용에서 손익분기.

## 9. A1111 vs Forge vs SD.Next vs ComfyUI

| 선택 | 언제 |
|---|---|
| **A1111 메인라인** | 기본, SD 1.x/SDXL 초점, 가장 큰 확장 생태계 |
| **Forge** | A1111과 같은 UI지만 30-75% 더 빠름, SDXL/Flux 준비, 더 작은 VRAM 풋프린트 |
| **SD.Next** | 롤링 릴리스, A1111+Forge 지원하는 거의 모든 것 지원하지만 단일 포크 |
| **ComfyUI** | 복잡 워크플로우, 비디오 생성, 오디오, 최신 모델 day-1, 노드 기반 제어 |

정직한 2026 추천: A1111 메인라인 먼저 시도. Flux나 속도 필요하면 Forge로 전환. 선형 UI 멘탈 모델 벗어나면 ComfyUI 학습.

## TL;DR

AUTOMATIC1111 SD WebUI = **2026년 솔로 크리에이터용 기본 셀프호스트 이미지 생성**. 163k 별, 최소 4 GB VRAM, 박스 밖에서 SD 1.x/SDXL 실행. 커뮤니티 모델용 Civitai와 페어, 고급 제어용 ControlNet/LoRA/ADetailer.

GPU 인스턴스 띄우고, 3절 설치 실행, 15분 후 의미 있는 볼륨에서 Midjourney와 손익분기 맞는 로컬 이미지 생성.

---

*dibi8의 멀티모달 콘텐츠 스택 일부 — [노드 기반 워크플로우용 ComfyUI](/kr/resources/ai-tools/comfyui-node-based-ai-image-2026/)와 다가오는 멀티모달 콘텐츠 파이프라인 컬렉션 참조.*
