---
title: 'Pixelle-Video 리뷰: AI 완전 자동 쇼트 비디오 생성 엔진, 주제 입력으로 완성된 영상'
description: Pixelle-Video는 오픈소스 AI 완전 자동 쇼트 비디오 생성 엔진입니다. 주제를 입력하면 자동으로 스크립트, AI
  이미지, 음성 해설, 배경음악이 포함된 완성된 영상을 생성합니다.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Python
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "27.1 MB"
file_md5: ''
download_url: https://github.com/AIDC-AI/Pixelle-Video
backup_url: ''
github_repo: https://github.com/AIDC-AI/Pixelle-Video
stars: 18065
maintainer: "AIDC-AI"
last_maintained: "2026-05-06"
featureImage: ''
draft: false
aliases:
- /ko/posts/pixelle-video-ai-short-video-generator/
faqs:
  - q: 'Pixelle-Video란 무엇인가요?'
    a: 'Pixelle-Video는 단 하나의 주제를 입력하면 완성된 짧은 동영상을 자동으로 만들어 주는 오픈소스 MIT 라이선스 AI 엔진입니다. 하나의 입력으로 스크립트 작성, 장면에 맞는 AI 이미지 또는 영상 생성, TTS를 이용한 보이스오버 합성, 배경음악 추가까지 자동으로 처리한 뒤 최종 영상을 렌더링합니다.'
  - q: 'Pixelle-Video는 무료이고 오픈소스인가요?'
    a: '네. Pixelle-Video는 AIDC-AI가 MIT 라이선스로 배포하며 직접 서버에 설치해 무료로 사용할 수 있습니다. 로컬 배포 시 GPU만 있으면 별도 비용이 들지 않지만, 로컬 하드웨어가 없을 경우 이미지 생성에 RunningHub 같은 종량제 클라우드 서비스를 선택적으로 활용할 수 있습니다.'
  - q: 'Pixelle-Video는 어떤 AI 모델을 지원하나요?'
    a: '스크립트 생성에는 OpenAI GPT-4o/GPT-4o-mini, 알리바바 통의첸원(Tongyi Qianwen), DeepSeek V3/R1, 그리고 로컬 Ollama 모델을 지원합니다. 이미지 생성에는 FLUX, Stable Diffusion, Qwen, Nano Banana, RunningHub를 지원하고, 음성 합성에는 Edge-TTS, Index-TTS, ChatTTS를 지원합니다.'
  - q: 'Pixelle-Video를 어떻게 설치하고 실행하나요?'
    a: 'git으로 레포지토리를 클론한 뒤 pip install -r requirements.txt를 실행하고, config.json에 API 키를 입력한 다음 python webui.py로 인터페이스를 실행합니다. Gradio Web UI가 http://localhost:7860에서 열리면 주제를 입력하고 음성과 템플릿을 선택한 후 Generate Video를 클릭하면 됩니다.'
  - q: 'Pixelle-Video는 기본 영상 생성 외에 어떤 기능이 있나요?'
    a: '세 가지 확장 모듈이 포함되어 있습니다. 디지털 휴먼 아바타는 사진 한 장을 한국어·중국어·영어 립싱크가 지원되는 토킹헤드 영상으로 변환합니다. Image-to-Video는 정지 이미지를 동영상으로 만들어 줍니다. Motion Transfer는 참조 영상의 움직임을 정지 이미지에 적용합니다.'
---
{</* resource-info */>}

![Pixelle-Video 웹 UI: 스크립트 / TTS / 분할 / 생성 결과](/images/articles/pixelle-video-ai-short-video-generator/webui.png)
*출처: [github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video) — 공식 Web UI*

## Pixelle-Video란?

**Pixelle-Video**는 오픈소스 AI 완전 자동 쇼트 비디오 생성 엔진입니다. **주제**만 입력하면 전체 비디오 제작 과정을 자동으로 완료합니다:

- ✍️ **AI 스마트 스크립트** — 주제에 따라 자동으로 해설词 생성
- 🎨 **AI 이미지/비디오 생성** — 각 장면에 맞는 AI 일러스트 또는 동영상 생성
- 🗣️ **AI 음성 합성** — 스크립트를 자연스러운 음성으로 변환
- 🎵 **배경음악** — 분위기를 높이는 BGM 자동 추가
- 🎬 **원클릭 비디오 합성** — 최종 영상 자동 렌더링

**진입장벽 제로, 영상 편집 경험 불필요** — 비디오 제작이 한 문장만큼 간단해집니다!

🔗 **GitHub**: [https://github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video)

---

## 핵심 기능

| 기능 | 설명 |
|------|------|
| **완전 자동 생성** | 주제 입력 → 완성된 비디오 획득 |
| **AI 스마트 스크립트** | AI가 해설词 작성, 수동 스크립트 불필요 |
| **AI 이미지 생성** | 각 문장에 어울리는 AI 일러스트 생성 |
| **AI 비디오 생성** | WAN 2.1 등 비디오 모델로 동적 콘텐츠 생성 |
| **다중 TTS 지원** | Edge-TTS, Index-TTS 등 다양한 음성 합성 |
| **배경음악** | BGM 추가로 분위기 업 |
| **비주얼 템플릿** | 다양한 템플릿으로 독특한 영상 스타일 |
| **유연한 사이즈** | 세로, 가로 등 다양한 비디오 크기 지원 |
| **다양한 AI 모델** | GPT, 통의천문, DeepSeek, Ollama 등 |
| **ComfyUI 아키텍처** | 모듈식 설계, 모든 기능 커스터마이징 가능 |

---

## 비디오 생성 파이프라인

Pixelle-Video는 모듈식 설계를 채택하여 명확한 워크플로를 제공합니다:

**텍스트 입력 → 스크립트 생성 → 이미지 기획 → 프레임 처리 → 비디오 합성**

각 단계는 유연한 커스터마이징을 지원 — AI 모델, 오디오 엔진, 비주얼 스타일 등을 개인화하여 선택할 수 있습니다.

---

## 확장 모듈

기본 비디오 생성 외에도 Pixelle-Video는 강력한 확장 기능을 제공합니다:

### 👤 디지털 휴먼 아바타
사진을 업로드하여 입 모양 동기화된 말하는 영상 생성. 한국어, 중국어, 영어 등 다국어 지원.

### 🖼️ 이미지를 비디오로
정적 이미지를 AI 비디오 생성 모델로 동적 영상으로 변환.

### 💃 모션 전이
참조 비디오와 이미지를 업로드하여 모션을 이미지에 전이 — 사진 속 인물이 춤추게 만들기.

---

## 지원 AI 모델

### LLM (스크립트 생성)
- OpenAI GPT-4o / GPT-4o-mini
- 알리바바 통의천문
- DeepSeek V3 / R1
- Ollama (로컬 배포)
- 사용자 정의 API 엔드포인트

### 이미지 생성
- FLUX (ComfyUI 통해)
- Stable Diffusion
- 통의천문 이미지 생성
- RunningHub 클라우드 서비스
- Nano Banana 모델

### TTS (음성 합성)
- Edge-TTS (무료, 다국어)
- Index-TTS (음성 클로닝)
- ChatTTS
- 사용자 정의 ComfyUI TTS 워크플로

---

## 빠른 시작

### 1. 저장소 클론

```bash
git clone https://github.com/AIDC-AI/Pixelle-Video.git
cd Pixelle-Video
```

### 2. 의존성 설치

```bash
pip install -r requirements.txt
```

### 3. API 키 구성

`config.json`을 편집하여 API 키 입력:

```json
{
  "llm": {
    "api_key": "당신의 API 키",
    "base_url": "https://api.openai.com/v1",
    "model": "gpt-4o"
  },
  "image": {
    "comfyui_url": "http://127.0.0.1:8188"
  }
}
```

### 4. Web UI 시작

```bash
python webui.py
```

브라우저에서 `http://localhost:7860` 열기

### 5. 첫 번째 비디오 생성

1. 주제 입력, 예: "독서 습관의 중요성"
2. 원하는 TTS 음성 선택
3. 비주얼 템플릿 선택
4. "비디오 생성" 클릭
5. 2-5분 대기 후 완성된 비디오 획득

---

## 사용 시나리오

| 시나리오 | 예시 주제 |
|----------|----------|
| **지식 공유** | "Python 초보자가 알아야 할 10가지 팁" |
| **제품 리뷰** | "iPhone 16 vs 삼성 S24 비교" |
| **스토리텔링** | "스타트업 창업자의 여정" |
| **교육 콘텐츠** | "블록체인은 어떻게 작동하나요?" |
| **뉴스 코멘터리** | "2026년 AI 트렌드" |
| **책/영화 리뷰** | "『아토믹 해빗』의 교훈" |

---

## 비디오 스타일 예시

Pixelle-Video는 다양한 비디오 스타일을 지원합니다:

- 🌄 **다큐멘터리 스타일** — 여행, 자연, 인문 이야기
- 🔍 **문화 분석** — 트렌드와 현상의 심층 분석
- 🔭 **과학 철학** — 복잡한 개념을 쉽게 설명
- 🌱 **개인 성장** — 자기 계발, 생산성 향상
- 🧠 **심층 사고** — 심리학, 철학, 성찰
- 🏯 **역사 문화** — 고인의 지혜, 역사적 사건
- ☀️ **감성** — 따뜻한 이야기, 영감
- 📜 **소설 해설** — 소설 리뷰, 인물 분석
- 🧬 **지식 과학** — 의학 상식, 건강 지식

---

## 기술 아키텍처

Pixelle-Video는 **ComfyUI** 아키텍처 기반:

- **모듈식 워크플로** — 각 구성 요소(LLM, TTS, 이미지 생성)가 독립 노드
- **커스터마이징 파이프라인** — 모델 또는 서비스 쉽게 교체
- **API 우선 설계** — 모든 기능 REST API로 노출
- **Web UI** — Gradio 기반의 사용하기 쉬운 인터페이스
- **배치 처리** — 여러 비디오 동시 생성

---

## 성능 및 비용

| 옵션 | 비용 | 속도 | 품질 |
|------|------|------|------|
| **로컬 배포** | 무료 (GPU 필요) | 빠름 | 높음 |
| **RunningHub 클라우드** | 사용량 기반 과금 | 즉시 | 높음 |
| **혼합 모드** | 유연 | 균형 | 높음 |

초보자 추천 구성:
- LLM: DeepSeek API (저렴, 품질 좋음)
- 이미지: RunningHub (로컬 GPU 불필요)
- TTS: Edge-TTS (무료, 다국어)

---

## 다른 도구와 비교

| 기능 | Pixelle-Video | HeyGen | Synthesia | Pictory |
|------|--------------|--------|-----------|---------|
| **오픈소스** | ✅ | ❌ | ❌ | ❌ |
| **무료 사용** | ✅ | 제한적 | 제한적 | 제한적 |
| **로컬 배포** | ✅ | ❌ | ❌ | ❌ |
| **커스텀 모델** | ✅ | ❌ | ❌ | ❌ |
| **ComfyUI 통합** | ✅ | ❌ | ❌ | ❌ |
| **음성 클로닝** | ✅ | ✅ | ✅ | ❌ |
| **디지털 휴먼** | ✅ | ✅ | ✅ | ❌ |
| **모션 전이** | ✅ | ❌ | ❌ | ❌ |

---

## 최적의 결과를 위한 팁

1. **주제 구체화** — 구체적일수록 더 나은 스크립트 생성
2. **템플릿 매칭** — 콘텐츠 스타일에 맞는 템플릿 선택
3. **프롬프트 프리픽스** — 영어 프롬프트 프리픽스로 이미지 스타일 일관성 유지
4. **음성 미리듣기** — 전체 비디오 생성 전 TTS 미리듣기
5. **배치 생성** — 3-5개 버전 동시 생성 후 최고 선택

---

## 관련 기사

- [Free Claude Code: Claude Code CLI를 무료로 사용할 수 있는 오픈소스 프록시 도구](/kr/resources/ai-tools/free-claude-code-open-source-proxy/) — 무료 AI 코딩 어시스턴트
- [Agent Reach: AI 에이전트에 인터넷 슈퍼파워를 부여하다](/kr/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — AI 에이전트 인터넷 연결 도구

---

## 결론

**Pixelle-Video**는 LLM, 이미지 생성, TTS, 비디오 편집을 단일 자동화 파이프라인으로 통합하여 비디오 제작을 민주화합니다. 콘텐츠 크리에이터, 교육자, 마케터, 개발자 모두에게 이 도구는 많은 비디오 제작 시간을 절약해줍니다.

ComfyUI 기반 아키텍처는 단순한 블랙박스가 아닙니다 — 각 구성 요소를 커스터마이징하고, 모델을 교체하고, 자신만의 비디오 생성 워크플로를 구축할 수 있습니다.

**가장 적합**: 빠른 비디오 제작이 필요한 콘텐츠 크리에이터, 교육자, 마케터, 개발자

**GitHub**: [https://github.com/AIDC-AI/Pixelle-Video](https://github.com/AIDC-AI/Pixelle-Video)

---


---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

*마지막 업데이트: 2026-05-06*
