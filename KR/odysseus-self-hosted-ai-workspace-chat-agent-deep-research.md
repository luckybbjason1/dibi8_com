---
title: 'Odysseus: 내장 도구 10+ 개의 자체 호스팅 AI 워크스페이스 — 65,000 스타 — 2026 완전 설정 가이드'
description: 'Odysseus(65,243개 GitHub 스타)는 채팅, 에이전트 자동화, 딥 리서치, 문서 편집, 이메일 분류, 캘린더 등을 결합한 자체 호스팅 AI 워크스페이스입니다. vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, GitHub Copilot을 지원합니다. Docker 및 네이티브 Linux/macOS 설치가 가능합니다.'
date: 2026-06-09
slug: odysseus-self-hosted-ai-workspace-chat-agent-deep-research
category: ai-tools
tags: ['odysseus', '자체 호스팅 AI', 'AI 워크스페이스', '로컬 AI', '딥 리서치', 'AI 에이전트', '채팅 인터페이스', '오픈소스 AI', '홈랩 AI']
github_repo: https://github.com/pewdiepie-archdaemon/odysseus
stars: 65243
maintainer: pewdiepie-archdaemon
license: MIT
featureImage: https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/odysseus.jpg
lang: ko
---


# Odysseus: Self-Hosted AI Workspace with 10+ Built-in Tools — 65,000 Stars — Full Setup Guide 2026

```
┌──────────────────────────────────────────────────┐
│              Odysseus Architecture                 │
│                                                   │
│  ┌─────────┐  ┌──────────┐  ┌─────────────────┐  │
│  │  Chat   │  │  Agent   │  │    Cookbook     │  │
│  │ (API)   │  │ (Tools)  │  │ (Model Server)│  │
│  └────┬────┘  └────┬─────┘  └────────┬────────┘  │
│       │             │                  │           │
│       ▼             ▼                  ▼           │
│  ┌───────────────────────────────────────────────┐ │
│  │           Python Backend (FastAPI)             │ │
│  │  ChromaDB │ SearXNG │ ntfy │ .env config    │ │
│  └───────────────────────────────────────────────┘ │
│       │             │                  │           │
│       ▼             ▼                  ▼           │
│  ┌───────────────────────────────────────────────┐ │
│         Docker Compose Stack                     │ │
│  ┌────────┐ ┌──────────┐ ┌────────┐ ┌─────────┐ │
│  │ Odysseus│ │ChromaDB  │ │SearXNG │ │ ntfy    │ │
│  └────────┘ └──────────┘ └────────┘ └─────────┘ │
│                                                   │
│  ┌───────────────────────────────────────────────┐ │
│  │        Frontend: Responsive Web UI (PWA)      │ │
│  └───────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────┘
```

Odysseus는 10개 이상의 통합 도구를 단일하고 프라이버시 중심 인터페이스로 통합하는 자체 호스팅 AI 워크스페이스입니다.

ChatGPT나 Claude와 달리 데이터를 넘겨야 하는 것과 달리, Odysseus는 완전히 귀하의 하드웨어에서 실행됩니다.

이 가이드는 모든 것을 다룹니다: 아키텍처 분석, Docker 및 네이티브 설치, 모델 구성, 에이전트 설정, 딥 리서치, 그리고 프로덕션 보안 강화.

## Odysseus란 무엇인가요?

Odysseus는 Python(FastAPI 백엔드, 반응형 웹 프론트엔드)으로 구축된 풀스택 AI 워크스페이스입니다.

이 프로젝트는 단일 웹 애플리케이션에 다음 기능을 통합합니다:

| Feature | Description | Built On |
|---------|-------------|----------|
| Chat | Multi-model conversations | vLLM, llama.cpp, Ollama, OpenRouter, OpenAI, GitHub Copilot |
| Agent | Tool-using autonomous agent | OpenCode, MCP, web, files, shell, skills, memory |
| Cookbook | Hardware-aware model downloader and server | llmfit, VRAM-aware, GGUF/FP8/AWQ |
| Deep Research | Multi-step research with source synthesis | Adapted from Alibaba's Tongyi DeepResearch |
| Compare | Blind multi-model comparison tests | Multi-model synthesis |
| Documents | Multi-tab text editor with AI assistance | Markdown, HTML, CSV, syntax highlighting |
| Memory/Skills | Persistent memory with vector + keyword retrieval | ChromaDB, fastembed (ONNX) |
| Email | IMAP/SMTP inbox with AI triage | IMAP, SMTP, CalDAV-aware |
| Notes & Tasks | Todo list, reminders, cron-style tasks | ntfy, browser, email channels |
| Calendar | Local-first calendar with CalDAV sync | CalDAV, .ics import/export |
| Extras | Image editor, theme editor, file uploads, 2FA | Vision + PDF support |

![Odysseus Chat & Agents](https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/chat.gif)

![Odysseus Deep Research](https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/research.gif)

![Odysseus Compare](https://raw.githubusercontent.com/pewdiepie-archdaemon/odysseus/dev/docs/compare.gif)

## Odysseus는 어떻게 작동하나요?

Odysseus는 계층형 아키텍처로 작동합니다.

```
Client (Browser/PWA)
    │
    ▼
┌─────────────────────────┐
│     Web UI (Frontend)    │
│  Chat / Agent / Docs /   │
│  Email / Calendar / etc. │
└─────────┬───────────────┘
          │ WebSocket / REST API
          ▼
┌─────────────────────────┐
│   FastAPI Backend        │
│  • Chat handler          │
│  • Agent executor        │
│  • Cookbook manager      │
│  • Deep research engine  │
└─────────┬───────────────┘
          │
    ┌─────┼──────────┬──────────┐
    ▼     ▼          ▼          ▼
  vLLM  Ollama    SearXNG   ChromaDB
 (GPU)  (CPU)    (Search)  (Memory)
```

**쿡북(Cookbook)** 컴포넌트는 특히 주목할 만합니다 — 하드웨어를 스캔하여 사용 가능한 GPU를 감지한 후 GGUF, FP8 또는 AWQ 형식의 호환 모델을 추천하고 다운로드합니다.

에이전트를 위해 Odysseus는 [OpenCode](https://github.com/anomalyco/opencode)를 기반으로 구축되었으며, 도구 통합을 위한 MCP(모델 컨텍스트 프로토콜)를 지원합니다.

## 설치 및 설정

### Docker(권장)

Docker는 Odysseus를 실행하는 가장 쉽고 가장 신뢰할 수 있는 방법입니다.

```bash
# Clone the repository (use dev branch for latest features)
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus

# Copy the example environment file (recommended)
cp .env.example .env

# Optional: configure explicit defaults
# APP_BIND=127.0.0.1
# APP_PORT=7000
# AUTH_ENABLED=true

# Start the stack
docker compose up -d --build
```

시작 후 `http://localhost:7000`을 엽니다.

선택적 기능(PDF 뷰어, AGPL PyMuPDF를 사용한 Office 추출)을 포함하려면:

```bash
docker compose build --build-arg INSTALL_OPTIONAL=true
docker compose up -d --build
```

NVIDIA GPU에 대한 GPU 패스스루를 활성화하려면:

```bash
# Diagnose GPU passthrough
scripts/check-docker-gpu.sh

# Install NVIDIA Container Toolkit if needed
scripts/check-docker-gpu.sh --install-nvidia-toolkit

# Enable GPU overlay
scripts.check-docker-gpu.sh --enable-nvidia-overlay
```

AMD/ROCm의 경우:

```bash
scripts/check-docker-amd-gpu.sh
```

그런 다음 `.env`를 편집하여 오버레이와 호스트의 렌더링 그룹 ID를 추가합니다.

### 네이티브 Linux/macOS 설치

Docker를 사용하지 않으려는 경우:

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus

# Create Python virtual environment
python3 -m venv venv
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Run initial setup
python setup.py

# Start the server
python -m uvicorn app:app --host 127.0.0.1 --port 7000
```

요구 사항: Python 3.11+입니다.

### Apple Silicon(macOS GPU 탑재)

macOS의 Docker는 Metal GPU를 사용할 수 없습니다.

```bash
git clone https://github.com/pewdiepie-archdaemon/odysseus.git
cd odysseus

# The bundled script handles venv + dependencies + startup
./start-macos.sh
```

`http://127.0.0.1:7860`에서 시작됩니다.

```bash
ODYSSEUS_HOST=0.0.0.0 ./start-macos.sh
```

### 데스크톱 앱 빌드

Odysseus를 네이티브 데스크톱 앱 래퍼로 패키징할 수 있습니다:

```bash
./build-macos-app.sh
```

## 구성 및 모델 설정

설치 후 웹 UI의 **설정** 패널을 통해 AI 모델을 구성할 수 있습니다.

```yaml
# Example .env configuration for multi-provider setup
APP_BIND=127.0.0.1
APP_PORT=7000
AUTH_ENABLED=true
DATABASE_URL=sqlite:///./odysseus.db

# OpenAI-compatible API
OPENAI_API_KEY=sk-your-key-here
OPENAI_BASE_URL=https://api.openai.com/v1

# Anthropic
ANTHROPIC_API_KEY=sk-ant-your-key-here

# Ollama (local)
OLLAMA_BASE_URL=http://localhost:11434

# OpenRouter
OPENROUTER_API_KEY=sk-or-your-key-here
```

쿡북은 모델 다운로드 및 서빙을 위한 GUI 지원 방법을 제공합니다.

### 사용자 지정 모델 추가

```bash
# List available models in Cookbook
odysseus cookbook list

# Download a model (auto-detects best format for your hardware)
odysseus cookbook download mistral-7b

# Start serving a local model
odysseus cookbook serve llama-3.1-8b
```

## 다른 도구와의 통합

### OpenCode 에이전트 프레임워크

Odysseus 에이전트는 [OpenCode](https://github.com/anomalyco/opencode)를 기반으로 구축되어 도구를 자율적으로 사용할 수 있는 기능을 제공합니다.

```bash
# Configure MCP in .env
MCP_SERVERS=http://localhost:3000,mcp://your-server

# Your agent can then use:
# - File tools (read/write/search)
# - Shell execution
# - Web search
# - Custom skills
```

### 영구 메모리를 위한 ChromaDB

Odysseus는 벡터 기반 영구 메모리를 위해 ChromaDB를 포함합니다.

```bash
# Memory import/export
odysseus memory export --output memory.json
odysseus memory import --input memory.json

# The memory system uses:
# - ChromaDB for vector storage
# - fastembed (ONNX) for embeddings
# - Combined vector + keyword retrieval
```

### SearXNG 웹 검색

웹 연구가 필요한 에이전트를 위해 Odysseus는 SearXNG(프라이버시 존중 메타검색 엔진)을 번들로 제공합니다.

```bash
# SearXNG is included in the Docker stack
# Access it at: http://localhost:8888 (inside Docker network)
# Agent web search uses it automatically
```

### 이메일 통합

Odysseus에는 AI 기반 분류가 있는 전체 IMAP/SMTP 수신함이 포함되어 있습니다:

```yaml
# Email config in .env
EMAIL_IMAP_SERVER=imap.gmail.com
EMAIL_IMAP_PORT=993
EMAIL_SMTP_SERVER=smtp.gmail.com
EMAIL_SMTP_PORT=587
EMAIL_USERNAME=your@email.com
EMAIL_PASSWORD=app-password
```

AI는 자동으로 다음을 수행할 수 있습니다: 이메일 요약, 긴급도 표시, 답장 초안 작성, 자동 태그 지정, 스팸 필터링.

## 벤치마크 및 실제 사용 사례

### 리소스 사용 비교

| Component | Docker | Native (no models) |
|-----------|--------|---------------------|
| RAM | ~200 MB | ~50 MB |
| Disk | ~500 MB (base) | ~100 MB |
| Startup | ~5 sec | ~1 sec |
| GPU passthrough | Supported | Native only (Metal) |

### 딥 리서치 성능

Odysseus의 딥 리서치 기능(알리바바의 퉁이 딥리서치에서 적응)은 다단계 연구 워크플로우를 수행합니다:

```
Research Task: "Compare RAG vs. fine-tuning for enterprise QA"

Step 1: Web search (SearXNG) → 15 sources
Step 2: Read & extract key points → 8 documents
Step 3: Synthesize into report → 5-page summary
Step 4: Visualize with charts → auto-generated
```

이는 여러 출처의 정보를 구조화된 보고서로 통합해야 하는 연구자, 분석가 및 해당 필요가 있는 모든 사람에게 특히 유용합니다.

### 모델 비교 모드

비교 기능을 사용하여 서로 다른 모델을 병렬로 맹점 A/B 테스트할 수 있습니다:

```
Prompt: "Write a Python binary search implementation"

Model A: [hidden] → Response
Model B: [hidden] → Response

User selects best response → rankings updated
```

이는 사용 사례에 가장 적합한 모델을 평가할 때 브랜드 편향을 제거합니다.

## 고급 사용 / 프로덕션 보안 강화

### 다중 사용자 설정

```bash
# Enable authentication (default)
AUTH_ENABLED=true

# Set custom admin user
ODYSSEUS_ADMIN_USER=yourusername

# Set admin password via .env
ODYSSEUS_ADMIN_PASSWORD=secure-password

# After first login, disable temporary password requirement
# via Settings panel
```

### 리버스 프록시 구성

For production deployment behind a reverse proxy:

```nginx
server {
    listen 443 ssl;
    server_name ai.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/ai.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ai.yourdomain.com/remote.key;

    location / {
        proxy_pass http://127.0.0.1:7000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

### 프로덕션을 위한 Docker Compose

```yaml
# docker-compose.prod.yml
services:
  odysseus:
    image: pewdiepie-archdaemon/odysseus:latest
    restart: unless-stopped
    ports:
      - "127.0.0.1:7000:7000"
    volumes:
      - ./data:/app/data
      - ./config:/app/config
    env_file: .env
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

### 백업 전략

```bash
# Backup ChromaDB (memory) and configuration
tar czf odysseus-backup-$(date +%Y%m%d).tar.gz \
  data/ \
  config/ \
  .env \

# ChromaDB data persists in: ./data/chroma/
# SQLite database: ./odysseus.db
```

## 대안과의 비교

| Feature | Odysseus | ChatGPT | Claude | NotebookLM | Open WebUI |
|---------|----------|---------|--------|------------|------------|
| Self-hosted | ✅ Full | ❌ Cloud only | ❌ Cloud only | ❌ Cloud only | ✅ Partial |
| Built-in agent | ✅ OpenCode/MCP | ✅ GPTs | ✅ Computer Use | ❌ No | ✅ Limited |
| Deep research | ✅ Built-in | ✅ Plus only | ✅ | ✅ Built-in | ❌ No |
| Email integration | ✅ IMAP/SMTP | ❌ No | ❌ No | ❌ No | ❌ No |
| Calendar sync | ✅ CalDAV | ❌ No | ❌ No | ❌ No | ❌ No |
| Local models | ✅ vLLM/llama.cpp | ❌ No | ❌ No | ❌ No | ✅ Partial |
| Memory persistence | ✅ ChromaDB | ✅ Plus only | ❌ No | ❌ No | ✅ Partial |
| Mobile PWA | ✅ Full | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| Cost | Free (self-hosted) | $20/mo | $20/mo | Free | Free |

## 제한사항 / 정직한 평가

Odysseus는 인상적이지만 알아야 할 몇 가지 제한사항이 있습니다:

1. **새로운 프로젝트(2026년 5월 31일 생성)** — 65,000개 이상의 스타를 보유하고 있지만, Odysseus는 매우 젊습니다. 버그, 변경 사항 및 불완전한 문서를 예상해야 합니다. `dev` 브랜치가 기본이지만 "불안정할 수 있습니다."

2. **GPU 지원은 Docker/NVIDIA 중심** — AMD ROCm 지원은 존재하지만 수동 `.env` 구성이 필요합니다. Apple Silicon은 네이티브 설치가 필요합니다(Docker GPU 없음).

3. **공식 컨테이너 이미지가 아직 없음** — 소스에서 빌드해야 합니다(`git clone` + `docker compose build`). 공식 Docker Hub 이미지가 배포를 단순화할 것입니다.

4. **쿡북 모델 선택이 제한적** — VRAM 인식에도 불구하고 쿡북은 HuggingFace에서 다운로드하므로 대형 모델의 경우 느릴 수 있습니다. 큐레이션된 품질 점수가 있는 내장 모델 레지스트리가 없습니다.

5. **에이전트 기능이 여전히 발전 중** — OpenCode를 기반으로 구축된 에이전트는 도구를 사용할 수 있지만 더 성숙한 프레임워크의 광범위한 플러그인 생태계가 부족합니다.

6. **모바일 경험은 "반응형"** — 프로젝트는 "휴대전화에서 보기 좋고 잘 작동한다"고 주장하지만, 웹 우선 앱으로서 진정한 네이티브 모바일 경험이 아닙니다.

## 자주 묻는 질문

Q：Odysseus를 라즈베리 파이에서 실행할 수 있나요?

A: 기술적으로는 앱 자체는 가능하지만, 로컬 모델 서빙은 실용적이지 않을 것입니다. 원격 API 제공자(OpenAI, Anthropic, OpenRouter) 또는 원격 모델 서버에 연결할 수 있습니다. Chromium 기반 프론트엔드는 RAM이 제한된 ARM에서도 성능 문제가 있을 수 있습니다.

Q：Odysseus는 팀 사용을 위해 프로덕션 준비가 되었나요?

A: 2026년 6월 기준, 이 프로젝트는 1.0 이전 버전이며 활발히 개발 중입니다. 개인 사용과 테스트에 좋지만, 팀 배포는 occasional 변경 사항을 예상해야 합니다. 다중 사용자 인증 시스템은 존재하지만 기본적입니다(RBAC 또는 SSO 없음).

Q：쿡북 없이 내 own 로컬 모델을 연결하는 방법은?

A: Ollama 또는 vLLM을 모델 제공자로 사용하고 Odysseus 설정에서 API 엔드포인트를 구성할 수 있습니다. 쿡북은 선택적입니다 — 주로 VRAM 인식 추천으로 모델을 다운로드하고 서빙하기 위한 편의 도구입니다.

Q：Odysseus는 스트리밍 응답을 지원하나요?

A: 네, 모든 채팅 및 에이전트 응답은 WebSocket 연결을 통해 실시간으로 스트리밍됩니다. 프론트엔드는 ChatGPT와 유사한 경험을 위한 스트리밍 UI 애니메이션을 지원합니다.

Q：API 키 없이 Odysseus를 사용할 수 있나요?

A: 예 — GPU가 있다면 vLLM 또는 llama.cpp(쿡북을 통해)를 통해 로컬에서 모델을 서빙할 수 있습니다. CPU 전용 사용자의 경우 Ollama가 무료 로컬 모델을 제공합니다. API 전용 사용에는 OpenAI, Anthropic 또는 OpenRouter와 같은 제공자의 키가 필요합니다.

Q：Gmail에서 이메일 기능은 어떻게 작동하나요?

A: Google 계정 설정(보안 > 2단계 인증 > 앱 비밀번호)에서 "앱 비밀번호"를 생성해야 합니다. IMAP 구성에서 일반 Gmail 비밀번호 대신 이 16자 비밀번호를 사용하세요.

## 결론

Odysseus는 GitHub에서 가장 야심 찬 자체 호스팅 AI 프로젝트 중 하나를 대표합니다 — 채팅, 에이전트 자동화, 딥 리서치, 문서 편집, 이메일 분류, 캘린더 관리, 로컬 모델 서빙을 단일하고 프라이버시 중심 워크스페이스로 통합합니다. 출시 후 몇 주 만에 65,000개 이상의 스타를 기록하며, 데이터 타협 없이 ChatGPT 인터페이스의 편의성을 원하는 사용자에게 분명히 공명하고 있습니다.

Docker 기반 설치는 깊은 Linux 전문 지식이 없는 사용자도 접근할 수 있게 해주는 반면, 네이티브 설치 및 Apple Silicon 지원은 하드웨어에서 직접 실행하는 것을 선호하는 사용자를 위한 옵션을 제공합니다.

**Try Odysseus yourself:** [github.com/pewdiepie-archdaemon/odysseus](https://github.com/pewdiepie-archdaemon/odysseus)

**Related articles:**
- [AgentMemory](https://dibi8.com/agentmemory-persistent-memory-ai-coding-agents) — Persistent memory for AI coding agents
- [Open Notebook](https://dibi8.com/open-notebook-open-source-notebooklm-alternative-15-ai-providers) — Open-source NotebookLM alternative with 15+ AI providers

**Sources & Further Reading:**
- Official docs: https://pewdiepie-archdaemon.github.io/odysseus/
- GitHub repository: https://github.com/pewdiepie-archdaemon/odysseus
- Cookbook (model selection): https://github.com/AlexsJones/llmfit
- Deep Research (adapted from): https://github.com/Alibaba-NLP/DeepResearch
- Agent framework (OpenCode): https://github.com/anomalyco/opencode

---

더 많은 AI 도구 심층 분석을 위해 커뮤니티에 가입하세요:[t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**면책 조항:** 이 글은 정보 목적으로만 작성되었습니다.
