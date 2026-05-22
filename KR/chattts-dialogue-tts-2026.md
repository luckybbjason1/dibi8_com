---
title: 'ChatTTS 2026: 39.3k 별 오픈소스 대화 TTS, 웃음 / 일시정지 / 토큰 레벨 prosody 제어'
description: 'ChatTTS는 대화(내레이션 아님) 전용 오픈소스 TTS. GitHub 39.3k 별, 4 GB VRAM 최소, RTX 4090에서 RTF 0.3, 웃음과 일시정지 포함 정밀 prosody 제어. 2026 완전 설치 + 프로덕션 셋업 가이드.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - CUDA
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/2noise/ChatTTS'
stars: 39300
maintainer: '2noise'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['ChatTTS', 'TTS', '음성', '대화', '오픈소스']
aliases:
  - /posts/chattts-dialogue-tts-2026/
---

2026년 대부분 오픈소스 TTS는 여전히 "90년대 GPS 내레이터에 리버브 추가" 같습니다. **ChatTTS**는 첫 번째 널리 채택된 예외 — 39.3k 별의 생성형 음성 모델, **대화** 전용 훈련 (내레이션 아님), 웃음 / 일시정지 / 삽입어 / prosody의 토큰 레벨 제어로 마침내 "찡그리지 않게 하는" 임계점 통과.

음성 에이전트, AI 팟캐스트, 게임 멀티 캐릭터 TTS, 또는 평탄한 내레이션이 경험을 죽이는 음성 제품 구축 중이라면 — ChatTTS가 2026년 오픈소스 기본 픽.

## TL;DR

- **무엇**: 2noise의 대화 최적화 오픈소스 TTS (중국어 + 영어)
- **GitHub**: 39.3k 별
- **License**: 코드 AGPL-3.0 + **모델 CC BY-NC 4.0** — 오픈 가중치는 비상업 사용만
- **VRAM**: 30초 클립 최소 4 GB; 8 GB 편안
- **속도**: RTX 4090에서 RTF (실시간 인자) ~0.3 (실시간보다 빠름)
- **훈련 데이터**: 오픈소스 40,000+시간 / 전체 모델 100,000+시간

## 1. 왜 ChatTTS가 대화에서 전통 TTS를 이기는가

레거시 분류:
- **연결형 TTS** (festival 등) — 기계적, prosody 없음, 죽어감
- **신경 TTS** (Tacotron / FastSpeech / VITS) — 유창하지만 단조, 내레이션 최적화
- **상업 API** (ElevenLabs / OpenAI TTS) — 자연스럽지만 $0.18-0.50/1000자, 폐쇄

ChatTTS는 새로운 4번째 카테고리: **명시적 prosody 제어 토큰을 가진 자기회귀 생성 TTS**. 텍스트만 입력 안 하고 — `[laugh]`, `[uv_break]` (음), `[lbreak]` (긴 일시정지) 마크업 가능, 모델은 음성 공연을 만들지 단순 말소리만 만들지 않음.

대화 사용 사례 (음성 에이전트, AI 팟캐스트, 게임 NPC 대화), 이게 "명백한 로봇"과 "나쁜 전화선의 진짜 사람일 수 있음" 사이 차이. 내레이션에는 고전 신경 TTS가 종종 여전히 더 나음.

## 2. 하드웨어 요구 (현실적 수치)

| 하드웨어 | 30초 클립 생성 시간 | 실용 |
|---|---|---|
| 4 GB GPU (GTX 1650 / 3050) | ~25초 | 취미, 단일 클립 |
| 8 GB GPU (RTX 3060 / 4060) | ~10초 | 솔로 dev, 배치 작업 |
| 12 GB GPU (RTX 3060 12GB / 4070) | ~5초 | 프로덕션, 낮은 동시 로드 |
| 24 GB GPU (RTX 4090 / A5000) | ~3초 | 프로덕션, 높은 동시 |
| CPU 전용 | ~3-5분 | 인터랙티브에 비실용적 |

셀프호스트 프로덕션 진입점: $0.30-0.50/시간 GPU 클라우드 (Vast.ai, RunPod, 또는 {{< aff "digitalocean" "chattts-gpu" "DigitalOcean GPU droplet" >}}) — 의미 있는 볼륨에서 ElevenLabs보다 훨씬 저렴.

## 3. 빠른 설치 (GPU 머신 10분)

```bash
git clone https://github.com/2noise/ChatTTS
cd ChatTTS
pip install -r requirements.txt
# 또는 pip:
pip install ChatTTS
```

Hello world:
```python
import ChatTTS
import torchaudio
import torch

chat = ChatTTS.Chat()
chat.load(compile=False)  # 첫 실행 후 True로 ~30% 속도 향상

texts = ["안녕하세요, 대화 TTS 테스트입니다 [uv_break] 자연스럽게 들리나요?"]
wavs = chat.infer(texts)

torchaudio.save("out.wav", torch.from_numpy(wavs[0]), 24000)
```

첫 실행이 ~2 GB 모델 가중치 다운로드. 이후 실행은 즉시.

## 4. Prosody 제어 토큰 (킬러 기능)

ChatTTS가 살아있게 느껴지는 이유 — 이 태그들이 텍스트 중간에 작동:

| 태그 | 효과 |
|---|---|
| `[laugh]` | 웃음 삽입 |
| `[laugh_0]` ~ `[laugh_2]` | 웃음 강도 레벨 |
| `[uv_break]` | 음-스타일 채움 일시정지 |
| `[lbreak]` | 더 긴 일시정지 (문장 스타일) |
| `[oral_0]` ~ `[oral_9]` | 대화 스타일 강도 (높을수록 캐주얼) |
| `[speed_0]` ~ `[speed_9]` | 말 속도 (5 = 보통) |
| `[break_0]` ~ `[break_7]` | 이산 일시정지 지속시간 |

예시:
```python
text = "그래서 그에게 말했어 [uv_break] 그건 진짜일 리 없다고 [laugh] [lbreak] 하지만 그는 우겼지."
wavs = chat.infer([text])
```

이게 "로봇 vs 인간" 갭을 닫는 것. 아껴서 사용; 과도한 태그는 연습한 것처럼 들림.

## 5. 멀티 스피커 — 세션 간 안정 음성

ChatTTS는 기본적으로 호출마다 다른 "스피커" 생성. 일관된 캐릭터 (NPC 음성, 영구 에이전트 인격)를 위해 한 번 시드하고 재사용:

```python
# 안정 스피커 생성 및 저장
rand_spk = chat.sample_random_speaker()
torch.save(rand_spk, "speaker_alice.pt")

# 후속 실행에서 사용
spk = torch.load("speaker_alice.pt")
params_infer_code = ChatTTS.Chat.InferCodeParams(spk_emb=spk)
wavs = chat.infer(texts, params_infer_code=params_infer_code)
```

패턴: 셋업 중 5-10개 다른 스피커 임베딩 사전 생성. 각 캐릭터에 매칭되는 거 선택. 전체 프로덕션에서 음성 안정.

## 6. 라이선스 주의 (프로덕션 전 필독)

**두 라이선스, 두 다른 의무**:
- **코드**: AGPL-3.0 — copyleft, 파생 작품 AGPL로 오픈소스 필수
- **모델 가중치**: CC BY-NC 4.0 — **비상업 사용만**

상업 프로덕션: 상업 모델 라이선스 위해 2noise 연락, 또는 오픈 ChatTTS 아키텍처에서 모델 처음부터 파인튜닝 (상당한 노력이지만 법적으로 깨끗).

취미, 연구, 내부 도구, 대부분 에이전트 프로토타이핑: NC 라이선스 괜찮음.

이게 채택의 유일한 마찰점. 제품이 생성된 음성을 직접 수익화한다면 라이선스 비용 고려 (또는 Coqui XTTS-v2 같은 상업 친화 대안 선택).

## 7. 프로덕션 패턴

에이전트 음성 / 팟캐스트 파이프라인:

```
   텍스트 입력 (LLM 에이전트 / 스크립트 생성기에서)
            │
            ▼
   가벼운 전처리 (규칙으로 prosody 태그 추가)
            │
            ▼
   ChatTTS 추론 (GPU 백엔드 FastAPI 서비스)
            │
            ▼
   출력 오디오 (WAV / Opus / 스트리밍)
            │
            ▼
   선택적 후처리 (음량 정규화, 노이즈 제거)
```

GPU 장착 {{< aff "htstack" "chattts-vps-hk" "HTStack 홍콩 GPU VPS" >}} 또는 Vast.ai 인스턴스에서 띄우고, FastAPI로 노출, 스택이 분당 생성 ~$0.001 (vs ElevenLabs ~$0.30/분).

## 8. ChatTTS vs 대안 사용 시기

| 사용 사례 | 선택 |
|---|---|
| 대화 / 멀티 캐릭터 / 에이전트 음성 | **ChatTTS** |
| 오디오북 내레이션 (단일 음성, 장편) | Coqui XTTS-v2 또는 상업 |
| 30초 샘플에서 음성 클로닝 | OpenVoice 또는 Coqui XTTS-v2 |
| 라이브 에이전트용 최저 가능 레이턴시 (<200ms) | 상업 (Deepgram Aura, ElevenLabs Flash) |
| 비용 상관없이 최고 품질 내레이션 | ElevenLabs |
| 상업 사용, 모델 소유 필수 | 파인튜닝된 Coqui XTTS-v2 |

## 9. 함정

1. **prosody 과태깅** — 어디나 `[laugh]`와 `[uv_break]` 뿌리기 연습한 것처럼 들림. 적을수록 많음
2. **스피커 시드 잊기** — `spk_emb` 없는 모든 호출은 다른 음성. 항상 사전 생성
3. **CPU에서 실행하고 속도 불평** — GPU 없으면 RTF 30-100× 나쁨. 그냥 GPU 빌려
4. **NC 라이선스 무시** — 유료 음성 제품에 ChatTTS 사용은 법적 위험

## TL;DR

ChatTTS = **대화를 설득력 있게 처리하는 첫 오픈소스 TTS**. 39.3k 별, 4 GB VRAM 최소, 제어 토큰 통한 prosody 인식, 임베딩 시드 통한 안정 스피커. 음성 에이전트, AI 팟캐스트, NPC용. 상업 사용 시 CC BY-NC 라이선스 주의.

GPU 인스턴스 띄우고, 3절의 10줄 설치 실행, 5분 안에 왜 이게 대화의 다른 모든 오픈소스 TTS를 대체했는지 듣게 됨.

---

*dibi8의 멀티모달 콘텐츠 스택 일부 — ChatTTS + Whisper + Stable Diffusion + ComfyUI를 전체 오디오/비주얼 크리에이터 파이프라인으로 다루는 다가오는 멀티모달 콘텐츠 파이프라인 컬렉션 참조.*
