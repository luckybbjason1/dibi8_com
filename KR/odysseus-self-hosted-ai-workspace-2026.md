---
title: 'Odysseus: 9일 만에 깃허브 스타 63,000개 달성한 셀프호스팅 AI 워크스페이스 — 2026 설치 가이드'
description: 'Odysseus는 오픈소스 프라이버시 우선 AI 워크스페이스입니다 (9일 63,000 스타, MIT 라이선스). Docker 명령어 하나로 채팅, AI 에이전트, 딥 리서치, 이메일 분류, 캘린더, 메모, 모델 쿡북을 내 서버에서 직접 실행할 수 있습니다. 설치 방법, 주요 기능, ChatGPT Plus 비교를 상세히 정리했습니다.'
date: 2026-06-09 00:00:00+08:00
lastmod: 2026-06-09 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: '1.0'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: 'https://github.com/pewdiepie-archdaemon/odysseus'
backup_url: ''
github_repo: 'pewdiepie-archdaemon/odysseus'
stars: 63159
maintainer: 'pewdiepie-archdaemon'
last_maintained: '2026-06-08'
featureImage: 'https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/main/docs/odysseus.jpg'
draft: false
categories: ['ai-tools']
tags: ['Odysseus', '셀프호스팅 AI', 'AI 워크스페이스', '로컬 LLM', '프라이버시', 'Docker', '오픈소스', 'ChatGPT 대안', 'Ollama', '딥 리서치']
aliases:
- /kr/posts/odysseus-self-hosted-ai-workspace-2026/
faqs:
  - q: 'Odysseus를 실행하려면 GPU가 필요한가요?'
    a: '아니요. Odysseus 자체는 매우 가볍습니다. GPU는 Cookbook 기능으로 로컬 모델을 실행할 때만 필요합니다. OpenAI, Anthropic, OpenRouter 같은 원격 API나 별도 Ollama 인스턴스에 연결하면 로컬 GPU 없이도 모든 기능을 사용할 수 있습니다.'
  - q: 'Odysseus와 Open WebUI의 차이점은 무엇인가요?'
    a: 'Open WebUI는 채팅과 Ollama 기반 RAG에 집중합니다. Odysseus는 여기에 MCP 도구 호출을 지원하는 AI 에이전트, 시각적 보고서를 생성하는 딥 리서치, AI 기반 이메일 클라이언트, CalDAV 캘린더, 알림 기능이 있는 메모, 그리고 VRAM을 자동 감지해 호환 모델을 추천하는 Cookbook을 추가합니다. 단순한 Ollama 프론트엔드라기보다는 셀프호스팅 ChatGPT Plus에 가깝습니다.'
  - q: 'Odysseus가 지원하는 LLM 백엔드는 무엇인가요?'
    a: '기본 지원: vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, GitHub Copilot. 설정에서 서버 URL과 API 키를 입력하면 바로 연결됩니다. Cookbook 기능은 감지된 VRAM에 맞는 GGUF, FP8, AWQ 모델을 자동으로 설치하고 실행합니다.'
  - q: 'Odysseus를 인터넷에 공개해도 안전한가요?'
    a: '기본 Docker Compose는 127.0.0.1에만 바인딩합니다. LAN 접근을 위해서는 .env에 APP_BIND=0.0.0.0을 설정하고 AUTH_ENABLED=true를 유지하세요. 공개 인터넷 노출 시에는 Nginx나 Caddy 같은 리버스 프록시와 TLS를 반드시 사용하세요. 공식 문서는 인증 없이 0.0.0.0으로 바인딩하지 말 것을 명시적으로 권고합니다.'
  - q: '모바일에서도 Odysseus를 사용할 수 있나요?'
    a: '네. Odysseus는 PWA(프로그레시브 웹 앱)로 완전한 반응형 디자인을 지원합니다. iOS나 Android에서 "홈 화면에 추가"하면 네이티브 앱에 가까운 경험을 얻을 수 있습니다. Cookbook과 에이전트 기능도 모바일에서 동작하지만, GPU 집약적인 로컬 모델 서빙은 데스크탑/서버 환경이 필요합니다.'
---

Odysseus는 2026년 5월 31일 깃허브에 공개된 후 6월 8일까지 63,000개의 스타를 달성했습니다. 하루 평균 약 **7,000개의 스타**가 증가한 셈으로, 2026년 가장 빠르게 성장한 오픈소스 AI 프로젝트 중 하나입니다. 핵심 아이디어는 명확합니다: 월 $20의 ChatGPT Plus 구독으로 얻을 수 있는 모든 것을 내 서버에서, 내 데이터로, MIT 라이선스로 실행하는 것입니다.

## Odysseus란 무엇인가

기술적으로 Odysseus는 FastAPI + Uvicorn 백엔드와 바닐라 JS 프론트엔드로 구성된 Python 웹 애플리케이션입니다. 검증된 여러 오픈소스 컴포넌트를 하나의 통합 워크스페이스로 묶었습니다:

- **채팅(Chat)** — 로컬 또는 원격 LLM과 대화. 설정에서 URL과 키를 입력하면 즉시 연결됩니다. 지원 백엔드: vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, GitHub Copilot.
- **에이전트(Agent)** — 목표와 도구(웹, 파일, 쉘, MCP 서버, 메모리)를 지정하면 AI가 작업을 자율적으로 수행합니다. [opencode](https://github.com/anomalyco/opencode) 기반으로 구축되었습니다.
- **쿡북(Cookbook)** — 하드웨어를 스캔하고 사용 가능한 VRAM을 감지해 GGUF / FP8 / AWQ 모델을 추천하고, 클릭 한 번으로 다운로드 및 실행합니다. [llmfit](https://github.com/AlexsJones/llmfit) 기반.
- **딥 리서치(Deep Research)** — 웹 검색, 소스 읽기, 종합 분석을 수행하는 멀티스텝 에이전트 리서치. 알리바바의 [Tongyi DeepResearch](https://github.com/Alibaba-NLP/DeepResearch)에서 포크된 기능.
- **모델 비교(Compare)** — 블라인드 사이드-바이-사이드 비교. 동일한 프롬프트를 여러 모델에 보내고, 어느 모델의 답변인지 모르는 상태에서 평가합니다.
- **문서(Documents)** — 멀티탭 마크다운 / HTML / CSV 에디터. '내가 쓰고, AI가 보조'하는 방식으로 설계되었습니다.
- **메모리 / 스킬(Memory / Skills)** — ChromaDB 벡터 스토어 + fastembed(ONNX)로 에이전트에게 영구 메모리를 제공합니다. 임포트/익스포트 지원.
- **이메일(Email)** — IMAP/SMTP 받은 편지함. AI가 긴급도 감지, 자동 태그, 요약, 답장 초안을 생성합니다.
- **메모 & 할일(Notes & Tasks)** — 알림 메모, 체크리스트, 에이전트가 실행 가능한 크론 스타일 스케줄 작업.
- **캘린더(Calendar)** — 로컬 우선 캘린더. Radicale, Nextcloud, Apple Calendar, Fastmail과 CalDAV 동기화 지원.
- **모바일 PWA** — 반응형 디자인, iOS/Android 홈 화면 설치 가능.

## 빠른 시작 (Docker)

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
cp .env.example .env          # 선택 사항이지만 권장
docker compose up -d --build
```

**http://localhost:7000**을 열면 됩니다. 첫 실행 시 Docker 로그에 임시 관리자 비밀번호가 출력됩니다:

```bash
docker compose logs odysseus | grep "Admin password"
```

로그인 후 설정에서 비밀번호를 변경하고, 첫 번째 모델 서버(로컬 Ollama 또는 OpenAI API 키)를 추가하세요.

## 네이티브 설치 (Linux / macOS)

Apple Silicon에서 GPU 가속 로컬 모델을 사용하려면 Docker 대신 네이티브 설치를 권장합니다(Docker는 Metal GPU에 접근할 수 없음):

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
python setup.py
python -m uvicorn app:app --host 127.0.0.1 --port 7000
```

Apple Silicon 원클릭 시작:

```bash
./start-macos.sh        # 127.0.0.1:7860에 바인딩
```

요구 사항: Python 3.11+. Cookbook의 백그라운드 모델 다운로드에는 `tmux`가 필요합니다.

## 주요 경쟁 제품과 비교

| 기능 | Odysseus | Open WebUI | ChatGPT Plus |
|---|---|---|---|
| 셀프호스팅 | ✅ | ✅ | ❌ |
| 에이전트 + MCP 도구 | ✅ | 부분 지원 | ✅ |
| 딥 리서치 | ✅ | ❌ | ✅ |
| 이메일 AI 분류 | ✅ | ❌ | ❌ |
| 캘린더(CalDAV) | ✅ | ❌ | ❌ |
| 모델 쿡북 | ✅ | ❌ | N/A |
| 블라인드 모델 비교 | ✅ | ❌ | ❌ |
| 월 요금 | 하드웨어 비용만 | 하드웨어 비용만 | $20 |

## 주의 사항

Odysseus는 현재 버전 1.0으로, 출시된 지 2주도 채 되지 않았습니다. Linux에서 Cookbook의 일부 런타임은 백그라운드 작업에 수동 `tmux`가 필요하고, CalDAV 동기화에서 반복 이벤트 처리 관련 알려진 이슈가 있으며, 모바일 PWA 성능은 브라우저마다 다소 차이가 있습니다. 하지만 이슈 트래커가 활발하게 관리되고 있고 메인테이너의 응답 속도가 빠릅니다.

프로덕션급 에이전트 배포에는 LangGraph나 CrewAI처럼 더 검증된 프레임워크가 여전히 유리합니다. Odysseus는 강력하고 유연하며 프라이버시를 보장하는 **개인 AI 워크스페이스**로 포지셔닝하는 것이 적합합니다.

## 결론

월 구독료 없이, 데이터를 클라우드에 올리지 않고, 내 하드웨어에서 ChatGPT 수준의 AI 워크스페이스를 원한다면 Odysseus가 현재 가장 완성도 높은 오픈소스 선택지입니다. 9일 만에 63,000 스타를 달성한 것은 과장된 홍보가 아닌 커뮤니티의 진심 어린 반응입니다. 레포를 클론하고 `docker compose up`을 실행하면 5분 안에 완전한 AI 워크스페이스가 실행됩니다.

**GitHub:** [pewdiepie-archdaemon/odysseus](https://github.com/pewdiepie-archdaemon/odysseus)
