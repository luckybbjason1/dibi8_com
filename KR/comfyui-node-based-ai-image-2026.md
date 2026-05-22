---
title: 'ComfyUI 2026: 114k 별 노드 기반 AI 이미지/비디오/오디오 워크플로우 엔진 완전 가이드'
description: 'ComfyUI는 SD/SDXL/Flux/Wan/Hunyuan 등을 지원하는 114k 별 노드 기반 시각 워크플로우 엔진. 이미지, 비디오, 오디오, 3D 생성 지원. 2026 완전 설치 가이드: 노드 기초, workflow JSON 임포트, ComfyUI Manager, ComfyUI가 AUTOMATIC1111을 이기는 때.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, PyTorch, CUDA]
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: GPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/comfyanonymous/ComfyUI'
stars: 114000
maintainer: 'comfyanonymous'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['ComfyUI', '이미지 생성', '비디오 생성', '노드 기반', '워크플로우', '오픈소스']
aliases:
  - /posts/comfyui-node-based-ai-image-2026/
---

[AUTOMATIC1111](/kr/resources/ai-tools/stable-diffusion-webui-2026/)이 "AI 이미지 생성의 Photoshop"이라면 (타이핑하면 이미지 나옴), **ComfyUI**는 **"생성형 AI를 위한 Blender 노드 에디터"** — 워크플로우를 노드의 방향성 그래프로 구축, 모든 모델, 샘플러, 조건화 단계, 후처리에 명시적 제어. 114k GitHub 별, GPL-3.0, 2024-2026 출시된 거의 모든 생성형 AI 모델 패밀리 지원: SD 1.x, SDXL, SD3/3.5, Flux (1 & 2), Wan, Hunyuan (이미지/비디오/3D), PixArt, AuraFlow, LTX-Video.

2026 현실: AI 이미지, 비디오, 멀티모달 파이프라인 진지한 모두가 ComfyUI 실행. 캐주얼 크리에이터는 A1111. 둘 다 맞음 — 다른 멘탈 모델용 다른 도구.

## TL;DR

- **무엇**: 생성형 AI용 노드 기반 시각 워크플로우 에디터
- **GitHub**: 114k 별
- **License**: GPL-3.0
- **모델**: SD/SDXL/SD3.5/Flux/Wan/Hunyuan/PixArt/AuraFlow/LTX-Video — 기본적으로 모두
- **VRAM**: 최소 1 GB (스마트 offload); SDXL에 8 GB+ 편안; Flux/비디오에 16 GB+
- **플랫폼**: NVIDIA, AMD, Intel, Apple Silicon, CPU 전용

## 1. 복잡 작업에서 왜 노드 기반이 선형 UI를 이기는가

A1111 UI는 입력 1개 → 출력 1개 가정. ComfyUI는 "원할 수 있는 것" 가정:
- 다른 sampler로 한 번에 후보 이미지 4장 생성
- SDXL 출력을 Flux refiner로 파이프
- 한 모델을 subject에, 다른 모델을 배경에, ControlNet으로 composite
- 비디오 생성 루프와 프레임 간 일관성
- 같은 파이프라인에서 오디오 생성과 이미지 생성

각각이 A1111의 선형 UI에서 지저분하거나 불가능. ComfyUI에서는 몇 개 추가 노드 연결.

트레이드오프: ComfyUI는 멘탈 클릭에 주말 걸림. A1111은 5분.

## 2. 하드웨어 (현실적 2026 수치)

ComfyUI의 스마트 메모리 관리가 A1111보다 훨씬 좋음. 같은 GPU로 ComfyUI에서 더 많은 일:

| GPU | SDXL | Flux dev | Hunyuan 비디오 (5s) |
|---|---|---|---|
| 4 GB (offload 포함) | ~30초 | 가능하지만 느림 | 아니오 |
| 8 GB | ~6초 | ~25초 | ~4분 |
| 12 GB | ~3초 | ~12초 | ~2분 |
| 24 GB (RTX 4090) | ~2초 | ~5초 | ~45초 |
| 48 GB+ (A6000/H100) | ~1초 | ~2초 | ~15초 |

클라우드 옵션: Vast.ai에 H100을 시간당 $1.50로, 또는 {{< aff "digitalocean" "comfyui-gpu" "DigitalOcean GPU droplet" >}}에 24 GB GPU; 생성 시간만 지불.

## 3. 빠른 설치 (10분)

```bash
git clone https://github.com/comfyanonymous/ComfyUI
cd ComfyUI
pip install -r requirements.txt
python main.py
# UI가 http://localhost:8188에서 열림
```

또는 단독 Windows 휴대용 빌드 사용 (원클릭 런처).

설치 후 첫 작업: **ComfyUI Manager** 설치 ("확장 스토어"에 가장 가까운 것):
```bash
cd custom_nodes
git clone https://github.com/ltdrdata/ComfyUI-Manager
```

ComfyUI 재시작. Manager가 모델 다운로드, 커스텀 노드 설치, 워크플로우 관리 처리.

## 4. 80% 시간 사용하는 5 노드

ComfyUI는 수백 노드 타입 있지만 핵심 5개가 대부분 워크플로우 커버:

1. **Load Checkpoint** — 기본 모델 (SDXL, Flux 등) 로드
2. **CLIP Text Encode** — 긍정과 부정 프롬프트 인코딩
3. **KSampler** — 실제 디퓨전 샘플링 단계 (마법 일어나는 곳)
4. **VAE Decode** — 잠재 표현을 픽셀 이미지로 변환
5. **Save Image** — 출력 저장

연결: Checkpoint → CLIP Text Encode (긍정 + 부정) → KSampler → VAE Decode → Save Image. 그게 그래프로서의 "txt2img".

## 5. Workflow JSON — 킬러 기능

모든 ComfyUI 워크플로우는 JSON으로 export 가능. JSON을 캔버스에 떨어뜨리면 전체 워크플로우 로드 — 노드, 와이어링, 파라미터 모두.

이건 거대:
- Reddit / Civitai / OpenArt는 떨어뜨려 사용 가능한 커뮤니티 공유 워크플로우 가득
- 누군가 3일 걸려 구축한 "비디오 생성 파이프라인" 또는 "제어 가능 얼굴 스왑" 워크플로우가 이제 당신 시작점
- 재현성: 같은 워크플로우 JSON + 같은 모델 파일 = 비트 단위 동일 출력

커뮤니티 워크플로우의 사실상 저장소: **OpenArt Workflows**, **ComfyWorkflows.com**, Civitai 워크플로우 섹션.

## 6. ComfyUI Manager (누락된 앱 스토어)

가장 중요한 커스텀 노드 1개. ComfyUI Manager 제공:
- 500+ 커뮤니티 커스텀 노드 원클릭 설치
- 모델 다운로더 (Civitai / HuggingFace), 올바른 폴더에 자동 배치
- 워크플로우 스냅샷과 복원
- ComfyUI 코어 + 모든 커스텀 노드 업데이트 체크
- 누락 노드 감지 (없는 노드 필요한 워크플로우 로드 시)

Manager 없으면 ComfyUI 유용성 크게 감소. 항상 ComfyUI 자체 후 단계 2로 설치.

## 7. 비디오 / 오디오 / 3D 생성 (2026 슈퍼파워)

ComfyUI는 최신 비디오와 3D 모델이 day-1 작동하는 유일한 주류 UI:

- **Wan 2.1 / 2.2** — 오픈소스 비디오 생성 (이미지-비디오, 텍스트-비디오)
- **Hunyuan Video** — 16 GB VRAM에서 720p 5초 클립
- **LTX-Video** — 빠른 비디오 생성, 12 GB VRAM에서 720p/24fps ~30초
- **Hunyuan3D** — 이미지에서 3D 메시 생성
- **PixArt Sigma** — 대체 고품질 이미지 모델
- **Stable Audio Open** — 같은 그래프에서 오디오 생성

"텍스트 → 이미지 → 비디오 → 오디오 내레이션" 파이프라인이 다른 곳에서 4개 별도 도구 필요한 게 ComfyUI 워크플로우 1개.

## 8. 프로덕션 셀프호스트 패턴

"AI 미디어 생성 API" 배포:

```
   GPU 인스턴스 (24 GB VRAM 권장)
            │  Vast.ai / RunPod / {{< aff "digitalocean" "comfyui-droplet" "DigitalOcean GPU" >}}에
            ▼
   --listen 0.0.0.0 있는 ComfyUI (HTTP API 노출)
            │
            ▼
   래퍼 서비스:
   - POST /run로 워크플로우 JSON + 오버라이드 params
   - job_id 반환, WebSocket으로 진행 스트림
   - 최종 출력 S3에 저장
```

ComfyUI가 워크플로우 JSON 받는 `POST /prompt` 엔드포인트 노출. 위에 얇은 auth + queue 레이어 구축하면 셀프호스트 Midjourney 대체 API.

## 9. ComfyUI vs A1111 vs SwarmUI

| 선택 | 언제 |
|---|---|
| **ComfyUI** | 복잡 워크플로우, 멀티 모델, 비디오, 오디오, 정확 재현성 원함, AI 미디어를 제품으로 출시 |
| **AUTOMATIC1111** | 단일 이미지 생성, 80% 캐주얼 사용 사례, 가장 큰 확장 라이브러리, 가장 낮은 학습 곡선. [A1111 가이드](/kr/resources/ai-tools/stable-diffusion-webui-2026/) 참조 |
| **SwarmUI** | ComfyUI의 힘 원하지만 A1111의 UI — 단순 폼 입력을 후드 아래 ComfyUI 워크플로우로 자동 변환 |

정직한 경로: 신규면 A1111로 시작. 비디오, 멀티 모델 파이프라인, 픽셀 정확 재현성 필요할 때 ComfyUI로 마이그레이션.

## 10. 함정

1. **ComfyUI Manager 건너뛰기** — "이 노드 어떻게 찾지" 모든 문제가 Manager 설치로 사라짐
2. **수동 모델 파일 배치** — 모델은 특정 서브디렉토리에 (`models/checkpoints/`, `models/loras/` 등). Manager가 자동 처리; 수동은 오류 prone
3. **이해 못 하는 워크플로우 로드** — Reddit 워크플로우는 200+ 노드 가능. 간단한 것 시작하고 수정
4. **메모리 관리 설정 무시** — 작은 GPU에서 `--lowvram` / `--medvram`이 "작동"과 "OOM" 차이
5. **워크플로우에 버전 관리 없음** — 코드와 함께 워크플로우 JSON git. 미래의 당신이 현재의 당신에 감사

## TL;DR

ComfyUI = **노드 기반 AI 미디어 생성 워크플로우 엔진, 단일 이미지 txt2img 이상 모든 것에 대한 2026 기본**. 114k 별, 모든 현대 모델 패밀리 지원 (SD/SDXL/Flux/Wan/Hunyuan/등), 4-48 GB GPU에서 작동.

ComfyUI + ComfyUI Manager 설치 (총 ~15분), OpenArt 커뮤니티 워크플로우를 캔버스에 떨어뜨리고, 생성형 AI를 방향성 그래프로 A1111이 결코 할 수 없는 방식으로 이해.

---

*dibi8의 멀티모달 콘텐츠 스택 일부 — [캐주얼 사용용 Stable Diffusion WebUI](/kr/resources/ai-tools/stable-diffusion-webui-2026/)와 [음성용 ChatTTS](/kr/resources/ai-tools/chattts-dialogue-tts-2026/) 페어. 전체 크리에이터 스택은 다가오는 멀티모달 콘텐츠 파이프라인 컬렉션 참조.*
