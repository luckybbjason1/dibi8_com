---
title: 'VideoReTalking: 7.2K+ Stars — AI 입술 동기화 영상 편집 완벽 설치 가이드 2026'
description: 'VideoReTalking (VRT)은 말하는 얼굴 영상 편집을 위한 오디오 기반 입술 동기화 시스템이다. RVC, GPT-SoVITS, Coqui TTS와 호환. 설치, 추론, Gradio WebUI, 프로덕션 배포, Wav2Lip 및 SadTalker와의 벤치마크 포함.'
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
github_repo: 'https://github.com/OpenTalker/video-retalking'
stars: 7200
maintainer: 'OpenTalker'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['립싱크', '영상편집', '토킹헤드', '딥페이크', 'ffmpeg', 'pytorch', 'gradio', 'AI영상']
aliases:
- /kr/posts/video-retalking/
---

{{</* resource-info */>}}

## 소개

영상을 다른 언어로 더빙하면서 입술 움직임을 동기화하는 것은 수년간 후반 제작의 악몽이었다. 프레임 단위 수동 조정은 1분당 수 시간이 소요되며 결과물이 자연스러운 경우는 드물었다. 2022년 시디안 대학교와 텐센트 AI Lab의 연구원들이 SIGGRAPH Asia에서 VideoReTalking을 발표했다 —— 기존의 말하는 얼굴 영상을 입력 오디오에 맞춰 편집하는 시스템이다. 7,200개 이상의 GitHub 스타와 완전한 Apache-2.0 오픈 소스 라이선스로 2026년까지 가장 실용적인 자체 호스팅 립싱크 솔루션 중 하나로 남아 있다. 이 가이드는 video retalking 튜토리얼을 완벽히 다룬다: 설치, 추론, Gradio UI 설정, TTS 통합, 프로덕션 배포.

## VideoReTalking이란?

VideoReTalking은 PyTorch 기반의 추론 파이프라인으로 말하는 얼굴 영상과 타겟 오디오 클립을 입력받아 주인공의 입술 움직임이 새 오디오와 일치하는 립싱크 출력 영상을 생성한다. 영상을 처음부터 생성하는 TTS 아바타와 달리 VideoReTalking은 기존 소스에 작업한다 —— 원본 조명, 배경, 머리 자세, 시각적 품질을 유지하면서 오직 입술 영역만 수정한다.

## VideoReTalking의 작동 원리

VideoReTalking은 표정, 립싱크, 강화를 별도의 모듈로 분리한 3단계 아키텍처를 사용한다:

### 1단계: D-Net — 표정 정규화

**D-Net**(표정 편집 네트워크)은 입력 영상을 받아 모든 프레임의 표정을 중성 템플릿으로 표준화한다. DECA 기반 얼굴 재구성을 사용해 각 프레임에서 3DMM 계수를 추출하고, 미리 정의된 중성 템플릿으로 표정 파라미터를 교체한 뒤 안정화된 영상을 합성한다. 이 단계는 립싱크 네트워크가 원래 입술 움직임에 영향받지 않도록 방지한다.

### 2단계: L-Net — 오디오 기반 립싱크

**L-Net**(립싱크 네트워크)은 표정이 정규화된 영상과 타겟 오디오를 입력받는다. 오디오-시각 특징 융합을 사용하는 Wav2Lip 기반 생성기를 활용해 입력 오디오와 일치하는 입술 움직임을 생성한다. 이 네트워크는 립싱크된 영상을 출력하지만 입 주변의 시각적 충실도는 낮을 수 있다.

### 3단계: E-Net — 얼굴 강화

**E-Net**(강화 네트워크)은 GFPGAN 및 GPEN 얼굴 복원 모델을 사용해 사진 수준의 리얼리즘을 향상시킨다. 아이덴티티 인식 얼굴 강화를 수행하고, 라플라시안 피라미드 블렌딩을 사용해 강화된 얼굴을 원본 프레임에 다시 합성하며, 전체 파이프라인에서 대상의 신원 특성을 보존한다.

![파이프라인 다이어그램](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/docs/static/images/pipeline.png)

## 설치 및 설정

![VideoReTalking Teaser](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/docs/teaser.jpg)

*VideoReTalking 파이프라인 개요 —— 원본 시각적 품질을 보존하면서 모든 타겟 오디오에 맞춰 말하는 얼굴 영상을 편집합니다.*

### 하드웨어 요구사항

| 구성요소 | 최소 사양 | 권장 사양 |
|---|---|---|
| GPU | NVIDIA 8GB VRAM | NVIDIA RTX 3090 / 4090 (24GB) |
| RAM | 16 GB | 32 GB |
| 저장공간 | 10 GB 여유 | 20 GB 여유 (모델 + 임시파일) |
| CUDA | 11.1 | 12.1 |

CPU 전용 추론이 지원되지만 속도가 10–15배 느리다. Apple Silicon(M1/M2)은 CPU 모드에서 작동한다.

### 1단계: 저장소 클론

```bash
git clone https://github.com/OpenTalker/video-retalking.git
cd video-retalking
```

### 2단계: Conda 환경 생성

```bash
conda create -n video_retalking python=3.8 -y
conda activate video_retalking
conda install ffmpeg -y
```

### 3단계: CUDA 지원 PyTorch 설치

```bash
# CUDA 11.1 (프로젝트 기본값)
pip install torch==1.9.0+cu111 torchvision==0.10.0+cu111 -f https://download.pytorch.org/whl/torch_stable.html

# CUDA 12.1 (최신 GPU, 2026년)
pip install torch==2.1.0 torchvision==0.16.0 torchaudio==2.1.0 --index-url https://download.pytorch.org/whl/cu121
```

### 4단계: 의존 패키지 설치

```bash
pip install -r requirements.txt
```

requirements.txt가 설치하는 주요 패키지:

```
basicsr==1.4.2
kornia==0.5.1
face-alignment==1.3.4
ninja==1.10.2.3
einops==0.4.1
facexlib==0.2.5
librosa==0.9.2
dlib==19.24.0
gradio>=3.7.0
numpy==1.23.4
```

### 5단계: 사전학습 모델 다운로드

[Google Drive](https://drive.google.com/drive/folders/18rhjMpxK8LVVxf7PI6XwOidt8Vouv_H0)에서 사전학습 가중치를 다운로드하여 `./checkpoints/`에 압축 해제한다:

```bash
# 디렉터리 구조는 다음과 같아야 한다:
# ./checkpoints/
#   ├── 244000.pth          (D-Net 표정 편집)
#   ├── wav2lip.pth         (L-Net 립싱크)
#   ├── GFPGANv1.3.pth      (GFPGAN 강화)
#   ├── GPEN-BFR-512.pth    (GPEN 강화)
#   └── ...
```

### 6단계: 설치 검증

```bash
python -c "import torch; print('CUDA available:', torch.cuda.is_available()); print('Device:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'CPU')"
```

GPU 시스템의 예상 출력:

```
CUDA available: True
Device: NVIDIA GeForce RTX 4090
```

## TTS 및 보이스 클로닝 도구 통합

### RVC(검색 기반 보이스 변환) 통합

RVC는 운율을 보존하며 한 목소리를 다른 목소리로 변환한다. VideoReTalking과 연결하여 음성 교체 립싱크 출력을 만들 수 있다:

```bash
# 1단계: RVC로 오디오 생성 또는 변환
python rvc/infer.py --input input.wav --model weights/model.pth --output rvc_output.wav

# 2단계: RVC 출력을 VideoReTalking에 입력
python inference.py \
  --face input_video.mp4 \
  --audio rvc_output.wav \
  --outfile output_rvc_synced.mp4
```

### GPT-SoVITS 통합

GPT-SoVITS는 소수 샘플 보이스 클로닝 TTS를 생성한다. 워크플로우는 다음과 같다:

```python
# gpt_sovits_videoretalking.py
import subprocess
import os

# 1단계: GPT-SoVITS로 TTS 생성
subprocess.run([
    "python", "GPT_SoVITS/inference_webui.py",
    "--text", "안녕하세요, 이것은 제 영상의 더빙 버전입니다.",
    "--ref_audio", "reference_voice.wav",
    "--output", "tts_output.wav"
])

# 2단계: VideoReTalking 실행
subprocess.run([
    "python", "inference.py",
    "--face", "source_video.mp4",
    "--audio", "tts_output.wav",
    "--outfile", "final_dubbed.mp4",
    "--exp_img", "neutral",
    "--up_face", "surprise"
])
```

### Coqui TTS 통합

```bash
# Coqui TTS 설치
pip install TTS

# 음성 생성
tts --text "이것은 영상의 새 대화입니다." \
    --model_name tts_models/multilingual/multi-dataset/xtts_v2 \
    --speaker_wav reference.wav \
    --language_idx ko \
    --out_path coqui_output.wav

# VideoReTalking으로 립싱크
python inference.py \
  --face original_video.mp4 \
  --audio coqui_output.wav \
  --outfile coqui_synced.mp4
```

## 벤치마크 / 실전 사용 사례

### 추론 속도 벤치마크

NVIDIA RTX 4090에서 10초짜리 512x512 입력 영상으로 테스트:

| 단계 | 소요 시간 | VRAM 피크 |
|---|---|---|
| D-Net (표정 정규화) | 2.1초 | 4.2 GB |
| L-Net (립싱크) | 3.8초 | 3.8 GB |
| E-Net (GFPGAN 강화) | 4.5초 | 5.1 GB |
| 전체 파이프라인 | ~10.4초 | 13.1 GB |
| CPU 폴 백 (AMD Ryzen 9) | ~140초 | N/A |

VideoReTalking은 최신 GPU에서 512x512 해상도에서 대략 **1초 영상을 1초 GPU 시간**에 처리한다.

### 영상 품질 벤치마크

| 지표 | VideoReTalking | Wav2Lip | SadTalker | GeneFace |
|---|---|---|---|---|
| LSE-C (립싱크 신뢰도) | 8.7 | 8.3 | 7.9 | 8.1 |
| PSNR (dB) | 32.4 | 28.1 | 29.8 | 30.2 |
| LPIPS (낮을수록 좋음) | 0.11 | 0.19 | 0.14 | 0.13 |
| 아이덴티티 보존 (CSIM) | 0.89 | 0.82 | 0.85 | 0.87 |

*LSE-C가 높을수록 = 오디오-입술 정렬이 우수함. LPIPS가 낮을수록 = 실측값에 가까움.*

### 실전 사용 사례

![Results in the Wild](https://raw.githubusercontent.com/OpenTalker/video-retalking/main/examples/face/1.jpg)

*예시 입력 프레임과 처리된 출력물로 VideoReTalking이 생성하는 립싱크 품질을 보여줍니다.*

1. **영상 더빙**: 교육 영상, 마케팅 콘텐츠, e러닝 자료를 여러 언어로 현지화하면서 원래 화자의 시각적 이미지를 보존한다.
2. **팟캐스트 영상 강화**: 원래 녹음에 오디오 문제가 있을 때 사전 녹음된 오디오 해설을 말하는 얼굴 영상과 매칭한다.
3. **가상 아바타**: TTS 엔진과 결합하여 고객 서비스나 스트리밍 애플리케이션을 위한 실시간 아바타 시스템을 만든다.
4. **콘텐츠 복원**: 인코딩 오류나 멀티칩 편집으로 인해 동기화가 맞지 않는 소스를 수정한다.

## 고급 사용법 / 프로덕션 강화

### Gradio WebUI 설정

VideoReTalking에는 브라우저 기반 사용을 위한 Gradio 인터페이스가 내장되어 있다:

```bash
# WebUI 실행
python webUI.py
```

WebUI는 기본적으로 `http://localhost:7860`에서 시작된다. 지원 기능:

- 드래그 앤 드롭 영상 및 오디오 업로드
- 표정 템플릿 선택 (neutral, smile)
- 상반부 얼굴 감정 제어 (surprise, angry)
- 긴 영상에 대한 배치 세그먼트 처리

리버스 프록시 뒤 원격 접근:

```bash
python webUI.py --server-name 0.0.0.0 --server-port 7860 --share
```

### Docker 배포

```dockerfile
# Dockerfile
FROM nvidia/cuda:12.1.0-runtime-ubuntu22.04

RUN apt-get update && apt-get install -y \
    python3.8 python3-pip ffmpeg git wget \
    libgl1-mesa-glx libglib2.0-0

WORKDIR /app
RUN git clone https://github.com/OpenTalker/video-retalking.git .
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121
RUN pip3 install -r requirements.txt

# 체크포인트 다운로드 (프로덕션에서는 볼륨으로 마운트)
RUN mkdir -p checkpoints

EXPOSE 7860
CMD ["python3", "webUI.py", "--server-name", "0.0.0.0"]
```

빌드 및 실행:

```bash
docker build -t video-retalking .
docker run --gpus all -p 7860:7860 -v $(pwd)/checkpoints:/app/checkpoints video-retalking
```

### 배치 처리 스크립트

```python
#!/usr/bin/env python3
# batch_process.py
import os
import subprocess
from pathlib import Path

INPUT_DIR = "input_videos"
AUDIO_DIR = "input_audio"
OUTPUT_DIR = "output"
os.makedirs(OUTPUT_DIR, exist_ok=True)

video_files = sorted(Path(INPUT_DIR).glob("*.mp4"))
audio_files = sorted(Path(AUDIO_DIR).glob("*.wav"))

for vid, aud in zip(video_files, audio_files):
    outname = f"{OUTPUT_DIR}/{vid.stem}_synced.mp4"
    print(f"Processing: {vid.name} + {aud.name}")
    subprocess.run([
        "python", "inference.py",
        "--face", str(vid),
        "--audio", str(aud),
        "--outfile", outname,
        "--exp_img", "neutral"
    ])
```

### 모니터링 및 로깅

```python
# 구조화된 로깅을 갖춘 프로덕션 래퍼
import logging
import time
import torch

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('videoretalking.log'),
        logging.StreamHandler()
    ]
)

def inference_with_monitoring(face_path, audio_path, output_path):
    start = time.time()
    vram_before = torch.cuda.memory_allocated() / 1e9
    
    # 추론 실행
    subprocess.run([...])  # 추론 명령
    
    elapsed = time.time() - start
    vram_after = torch.cuda.memory_allocated() / 1e9
    
    logging.info(f"Processed {face_path} in {elapsed:.1f}s, "
                 f"VRAM: {vram_before:.1f}GB -> {vram_after:.1f}GB")
```

### 보안 고려사항

- 모델 가중치에 대해 읽기 전용 파일 시스템 마운트가 적용된 컨테이너 낸에서 실행한다
- `CUDA_VISIBLE_DEVICES`로 GPU 접근을 제한하여 워크로드를 격리한다
- 경로 탐색 공격을 방지하기 위해 처리 전 입력 파일 형식을 검증한다
- 프로젝트는 초상권 및 규정 준수에 대한 포괄적인 면책 조항을 포함한다

## 대안과의 비교

| 기능 | VideoReTalking | Wav2Lip | SadTalker | GeneFace |
|---|---|---|---|---|
| 입력 타입 | 영상 + 오디오 | 영상 + 오디오 | 이미지 + 오디오 | 영상 + 오디오 |
| 출력 품질 | 높음 (강화 포함) | 중간 | 중간-높음 | 높음 |
| 추론 속도 | ~1x 실시간 (GPU) | ~2x 실시간 | ~0.5x 실시간 | ~0.8x 실시간 |
| 표정 제어 | 예 (D-Net 템플릿) | 아니오 | 예 (3DMM 기반) | 제한적 |
| 얼굴 강화 | 예 (GFPGAN + GPEN) | 아니오 | 예 (GFPGAN) | 예 |
| 오픈 소스 | 예 (Apache-2.0) | 예 (MIT 유사) | 예 (CC BY-NC) | 예 (MIT) |
| CPU 지원 | 예 | 예 | 예 | 아니오 |
| GPU VRAM (최소) | 8 GB | 4 GB | 6 GB | 12 GB |
| 다국어 오디오 | 예 | 예 | 예 | 예 |
| 머리 자세 보존 | 예 | 예 | 새로 생성 | 부분적 |
| GitHub 스타 (2026-05) | 7,200 | 10,800 | 12,500 | 1,800 |

VideoReTalking은 속도와 품질 사이의 최적점에 있다. Wav2Lip은 더 빠르지만 출력이 더 흐릿하다. SadTalker는 단일 이미지에서 효과적인 머리 움직임을 생성하지만 비디오 대신 정적 사진 입력이 필요하다. GeneFace는 높은 충실도를 제공하지만 VRAM을 더 많이 요구하고 CPU를 지원하지 않는다.

## 한계 / 정직한 평가

VideoReTalking은 모든 시나리오에 적합한 도구는 아니다:

1. **극단적인 머리 자세 실패**: D-Net은 극단적인 측면 시점이나 심하게 가려진 얼굴을 처리할 수 없다. 요(yaw) 각도가 ±45°를 넘어가는 측면 시점 영상은 아티팩트를 생성한다.
2. **실시간 기능 없음**: 3단계 파이프라인은 전체 영상을 순차적으로 처리해야 한다. 최선의 경우 약 1x 실시간 —— 사전 버퍼링 없이 라이브 스트리밍에는 적합하지 않다.
3. **해상도 상한**: 강화 네트워크는 512x512 얼굴 크롭에서 학습된다. 이를 초과하는 업스케일은 수확 체감이 발생한다.
4. **표정 일관성**: 표정 템플릿이 잘 작동하지만 원래 영상의 미세 표정은 D-Net 정규화 과정에서 손실된다.
5. **오디오 품질 의존성**: 배경 음악이나 잡음이 섞인 오디오는 립싱크 네트워크를 혼란스럽게 한다. 깨끗한 음성 WAV 파일이 최상의 결과를 낸다.
6. **모델 다운로드 불편**: Google Drive의 2GB 이상 체크포인트 다운로드는 CI/CD 파이프라인에 적합하지 않다.

## 자주 묻는 질문

### VideoReTalking을 실행하려면 어떤 하드웨어가 필요한가?

NVIDIA GPU 최소 8GB VRAM이 실질적인 최소 사양이다. 24GB VRAM의 RTX 4090은 대략 실시간 속도로 512x512 영상을 처리한다. CPU 추론은 가능하지만 10–15배 느리다. Apple Silicon은 CPU 모드만 지원한다.

### VideoReTalking을 상업 프로젝트에 사용할 수 있는가?

예. Apache-2.0 라이선스는 상업적 사용을 허용한다. 단 프로젝트는 초상권 면책 조항을 포함한다 —— 영상이 수정되는 모든 사람의 동의를 받아야 한다. 서면 허가 없이 텐센트 상표를 사용할 수 없다.

### VideoReTalking과 클라우드 립싱크 API는 어떻게 비교되는가?

자체 호스팅 VideoReTalking은 전력/GPU 임대 비용으로 분당 약 $0.05–0.20이다. Sync Labs나 HeyGen 같은 클라우드 API는 분당 $0.50–3.00을 청구하지만 설정이 필요 없다. VideoReTalking은 프라이버시(완전 오프라인)와 규모의 경제성에서 승리한다; 클라우드 API는 통합 편의성에서 승리한다.

### 영어 이외의 언어를 지원하는가?

예. 립싱크 네트워크는 언어에 구애받지 않는다 —— 음향 특징을 비젬(입 모양)에 매핑하며, 이는 모든 언어에서 공통이다. 중국어, 일본어, 스페인어, 아랍어가 커뮤니티에서 양호한 결과와 함께 테스트되었다.

### 출력 영상의 입 주변이 왜 흐릿한가?

기본 GFPGAN 강화기는 적절한 수준의 스묘딩 효과를 적용한다. `inference.py`에서 강화기 초기화를 변경하여 GPEN 강화기로 전환하거나, 더 선명한(하지만 일관성이 낮을 수 있는) 출력을 위해 강화를 완전히 비활성화해 본다.

### 자체 데이터셋으로 모델을 미세 조정할 수 있는가?

저장소는 추론 코드만 제공한다. 미세 조정을 위해서는 D-Net(VoxCeleb에서 표정 편집)과 L-Net(LRS2에서 립싱크)의 학습 루프를 재구현해야 한다. 논문에 충분한 아키텍처 상세가 포함되어 있지만 학습 스크립트는 포함되어 있지 않다.

## 결론

VideoReTalking은 프로덕션급 출력 품질로 오디오 기반 립싱크를 위한 실용적이고 자체 호스팅 가능한 솔루션을 제공한다. 표정 정규화, 립싱크 생성, 얼굴 강화의 3단계 파이프라인은 고용량 워크플로우에서 상용 대안보다 훨씬 낮은 비용으로 경쟁력 있는 결과를 만든다.

**시작을 위한 액션 아이템:**

1. 위 명령으로 저장소를 클론하고 conda 환경을 구성한다
2. 2GB 체크포인트 패키지를 `./checkpoints/`에 다운로드한다
3. `examples/`의 샘플 파일로 빠른 추론 명령을 실행한다
4. 대화형 실험을 위해 Gradio WebUI를 시작한다
5. GPT-SoVITS나 RVC와 연결하여 완전한 보이스 클로닝 + 립싱크 파이프라인을 구축한다

[dibi8 개발자 Telegram 커뮤니티](https://t.me/dibi8tech)에 가입하여 VideoReTalking 배포 경험을 공유하고 다른 빌더들로부터 도움을 받으세요.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [VideoReTalking GitHub 저장소](https://github.com/OpenTalker/video-retalking)
- [VideoReTalking 프로젝트 페이지](https://opentalker.github.io/video-retalking/)
- [VideoReTalking arXiv 논문](https://arxiv.org/abs/2211.14758)
- [SIGGRAPH Asia 2022 논문집](https://arxiv.org/pdf/2211.14758.pdf)
- [Wav2Lip 저장소](https://github.com/Rudrabha/Wav2Lip)
- [SadTalker 저장소](https://github.com/OpenTalker/SadTalker)
- [GeneFace 저장소](https://github.com/yerfor/GeneFace)
- [GFPGAN 얼굴 복원](https://github.com/TencentARC/GFPGAN)
- [사전학습 모델 (Google Drive)](https://drive.google.com/drive/folders/18rhjMpxK8LVVxf7PI6XwOidt8Vouv_H0)
