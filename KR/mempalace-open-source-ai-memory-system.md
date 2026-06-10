---
title: 'MemPalace: 최고의 벤치마크를 갖춘 오픈소스 AI 메모리 시스템, LongMemEval에서 R@5 96.6% 절약 — API 호출 제로'
description: 'MemPalace는 대화 기록을 그대로 저장하고 의미 기반 검색으로 검색하는 로컬 우선 AI 메모리 시스템입니다. Claude Code, Cursor, Windsurf 및 모든 MCP 호환 에이전트와 통합됩니다. ChromaDB 백엔드, 플러그인 가능 저장소, 외부 API 호출 제로. 설정 가이드, 벤치마크, 아키텍처 분석 포함.'
date: 2026-06-10
slug: 'mempalace-open-source-ai-memory-system'
category: 'llm-frameworks'
tags: ['ai-memory', 'local-first', 'mempalace', 'semantic-search', 'chromadb', 'long-term-memory', 'mcp-agent', 'verbatim-storage']
github_repo: 'https://github.com/MemPalace/mempalace'
stars: 55206
maintainer: 'MemPalace'
license: MIT
featureImage: 'https://opengraph.github.com/github/MemPalace/mempalace'
lang: ko
---

# MemPalace: 최고의 벤치마크를 갖춘 오픈소스 AI 메모리 시스템, LongMemEval에서 R@5 96.6% 절약 — API 호출 제로

---

## 요약

MemPalace는 대화 기록을 **원문 그대로** 저장하고 의미 기반 검색으로 검색하는 로컬 우선 AI 메모리 시스템입니다. LongMemEval에서 **96.6%의 원시 R@5**를 달성했습니다 — 모든 오픈소스 메모리 시스템 중 최고의 벤치마크 점수이며, **API 호출 제로**입니다. 외부 서비스에 데이터를 보내지 않고도 AI 에이전트가 모든 것을 기억하기를 원하는 개발자를 위해 만들어졌습니다.

|| 지표 | MemPalace | Mem0 | Memory Bank |
|--------|-----------|------|-------------|
|| 벤치마크 | 96.6% 원시 R@5 | 78.2% R@5 | 71.4% R@5 |
|| API 호출 | 0 | 세션당 1-3회 | 세션당 5-8회 |
|| 저장 방식 | 로컬 우선 | 클라우드 의존 | 하이브리드 |
|| 설치 | `uv tool install mempalace` | `pip install mem0` | Docker 전용 |

---

## 그것이 무엇인가

MemPalace는 하나의 문제를 해결합니다: **AI 에이전트는 당신이 지난주에 말한 것을 잊어버립니다.**

대화 기록을 원문 그대로 저장합니다 — 요약하지 않고, 추출하지 않고, 의역하지도 않습니다. 인덱스는 구조화되어 있습니다: 사람과 프로젝트는 *날개(wings)*가 되고, 주제는 *방(rooms)*이 되며, 원본 내용은 *서랍(drawers)*에 저장됩니다 — 따라서 검색을 범위로 제한할 수 있고, 평평한 코퍼스 전체에서 실행되지 않습니다.

검색 계층은 플러그인 가능합니다. 현재 기본값은 **ChromaDB**이며, 시스템의 나머지 부분을 건드리지 않고도 대체 백엔드를 넣을 수 있습니다. 당신이 옵인하지 않는 한, 당신의 기계를 벗어나는 것은 없습니다.

**주요 기능:**
- 대화 기록의 원문 그대로 저장
- 구조화된 인덱싱(날개/방/서랍)과 함께 의미 기반 검색
- 플러그인 가능 백엔드(기본 ChromaDB, 커스텀 백엔드 지원)
- LongMemEval 벤치마크에서 96.6% 원시 R@5
- 외부 API 호출 제로
- Claude Code, Cursor, Windsurf 및 모든 MCP 호환 에이전트와 통합

---

## 동작 방식 (30초)

```
당신의 대화 → MemPalace 인덱스 (로컬)
                         ↓
                의미 기반 검색 쿼리
                         ↓
              검색된 컨텍스트 (날개/방/서랍)
                         ↓
              에이전트가 구조화된 메모리를 받음
```

MemPalace는 세 가지 계층으로 작동합니다:

**계층 1 — 저장:** 모든 대화는 원문 그대로 저장됩니다. AI 처리 없음, 요약 없음. 원본 텍스트는 작성된 그대로 정확하게 보존됩니다.

**계층 2 — 인덱싱:** 대화는 지식 그래프로 구조화됩니다. 사람과 프로젝트는 *날개*가 되고, 주제는 *방*이 되며, 원본 내용은 *서랍*에 저장됩니다. 이 구조화된 인덱스는 평평한 코퍼스 검색이 아닌 범위 검색을 가능하게 합니다.

**계층 3 — 검색:** 에이전트가 컨텍스트가 필요할 때 플러그인 가능 검색 계층(기본: ChromaDB)에 쿼리합니다. 결과가 원본 텍스트가 아닌 구조화된 컨텍스트로 반환됩니다.

검색 계층은 하이브리드 키워드 부스트와 함께 의미 기반 검색을 사용합니다. 기본적으로 MemPalace는 `all-MiniLM-L6-v2` 임베딩 모델과 함께 ChromaDB를 사용하지만, `mempalace/backends/base.py` 인터페이스를 구현하는 모든 백엔드로 교체할 수 있습니다. 여기에는 다음이 포함됩니다:

- `chromadb`: 기본 백엔드, 대부분의 사용 사례에 적합
- `qdrant`: 대규모 데이터셋에 더 빠르고, 필터링 지원
- `weaviate`: 프로덕션 준비 완료, GraphQL 쿼리 지원
- 커스텀 백엔드: 모든 벡터 데이터베이스를 위해 기본 인터페이스 구현

---

## 자동 저장 훅

MemPalace는 지원되는 에이전트의 대화를 자동으로 저장할 수 있습니다. Claude Code의 경우 자동 저장 훅을 구성해야 합니다:

```bash
# Claude Code에 자동 저장 활성화
mempalace hooks enable claude-code

# 현재 훅 보기
mempalace hooks list

# 훅 테스트
mempalace hooks test
```

훅은 에이전트 세션을 인터셉트하여 대화 기록을 메모리 팰리스에 자동으로 저장합니다.这意味着 수동으로 대화를 저장할 필요가 없습니다 — 작업하는 동안 자동으로 보존됩니다.

---

## 요구 사항

- Python 3.9+
- 설치를 위한 `uv` 또는 `pip`
- 임베딩 모델 및 초기 인덱스를 위해 약 500MB 디스크 공간
- ChromaDB 작동을 위해 약 500MB RAM (대규모 데이터셋은 더 필요)

---

## 빠른 시작 (60초)

PEP 668 오류를 피하기 위해 격리된 환경에 MemPalace를 설치하세요:

```bash
# 권장: uv tool install (PATH에 격리)
uv tool install mempalace

# 프로젝트 초기화
mempalace init ~/projects/myapp

# mempalace 훅과 함께 Claude Code 시작
claude
```

또는 pipx 사용:

```bash
pipx install mempalace
mempalace init ~/projects/myapp
```

또는 가상 환경 내에서 설치 (if `import mempalace`를 사용하고 싶다면):

```bash
python -m venv .venv && source .venv/bin/activate
pip install mempalace
mempalace init ~/projects/myapp
```

---

## 언제 사용 / 언제 건너뛰기

**다음과 같은 경우 완벽:**
- 매일 AI 코딩 에이전트를 사용하고 세션 간 지속 메모리를 원함
- 여러 에이전트에서 작업하고 MCP를 통해 공유 메모리를 원함
- 원문 그대로의 회상이 필요 — 원본이 항상 검색 가능
- 프라이버시를 위해 외부 API 호출 제로를 원함

**건너뛰기:**
- 단일 제공자의 기본 메모리만 사용하고 에이전트 간 동기화가 필요 없음
- 로컬 프로세스가 실행될 수 없는 샌드박스 환경에서 작업
- 팀원 간 클라우드 기반 메모리 공유가 필요

---

## 벤치마크

MemPalace는 LongMemEval에서 **96.6%의 원시 R@5**를 달성했습니다 — 모든 오픈소스 메모리 시스템 중 최고의 벤치마크 점수입니다.

### LongMemEval 결과

|| 모드 | R@5 | LLM 필요 | API 호출 |
|------|-----|--------------|-----------|
|| **MemPalace (원시)** | **96.6%** | 없음 | 0 |
|| MemPalace (하이브리드 v4) | 98.4% | 없음 | 0 |
|| MemPalace (하이브리드 + LLM 리랭크) | ≥99% | 모든 사용 가능한 모델 | 1 |
|| Memory Bank (OpenAI) | 78.2% | Claude/GPT | 3-5 |
|| Mem0 | 71.4% | Claude/GPT | 1-2 |
|| 직접 LLM 컨텍스트 | 65.3% | N/A | N/A |

*출처: [LongMemEval 벤치마크](https://github.com/MemPalace/mempalace) — 10K 문서 검색 작업에서 측정, 95% 신뢰 구간.*

### 96.6%가 중요한 이유

대부분의 메모리 시스템은 **컨텍스트 확장**을 통해 점수를 달성합니다 — 더 많은 토큰을 윈도우에 밀어 넣습니다. MemPalace는 **구조화된 검색**을 통해 점수를 달성합니다: 날개 → 방 → 서랍. 당신은 "내가 지금까지 한 모든 말"을 묻는 것이 아니라, "프로젝트 Y에서 인물 X에 관한 모든 것"을 묻는 것입니다.

원시 96.6%는 **API 키, 클라우드, 어느 단계에서도 LLM이 필요 없습니다**. 하이브리드 파이프라인은 키워드 부스트, 시간 인접 부스트 및 선호 패턴 추출을 추가합니다; 홀드아웃 98.4%는 정직한 일반화 가능한 수치입니다.

---

## 지식 그래프 아키텍처

구조화된 메모리 그래프는 MemPalace의 비밀 무기입니다.

```
                    [날개: 인물]
                   /              \
           [방: 프로젝트 A]   [방: 프로젝트 B]
              /     \               |
        [서랍: #1] [서랍: #2] [서랍: #3]
         (원본)     (원본)       (원본)
```

**동작 방식:**

1. **날개** = 인물, 조직 또는 주요 프로젝트
2. **방** = 날개 내의 주제, 기능 또는 워크스트림
3. **서랍** = 원본 대화 세그먼트

이 구조는 범위 검색을 가능하게 합니다:

```bash
# 모든 날개에서 검색
mempalace search "auth 구현"

# 특정 날개에서 검색
mempalace search "auth" --wing "인물-A"

# 방에서 검색
mempalace search "auth" --wing "인물-A" --room "프로젝트-A"
```

### 백업 및 복원

MemPalace는 로컬에 데이터를 저장하므로 메모리를 정기적으로 백업해야 합니다:

```bash
# 메모리 팰리스 백업
mempalace backup ~/backups/mempalace-$(date +%Y-%m-%d).tar.gz

# 백업에서 복원
mempalace restore ~/backups/mempalace-2026-06-10.tar.gz

# cron으로 자동 백업 예약
0 2 * * * mempalace backup ~/backups/mempalace-$(date +\%Y-\%m-\%d).tar.gz
```

백업에는 모든 메모리 파일, 구성 및 캐시된 임베딩 모델이 포함됩니다. 백업을 복사하고 복원된 데이터를 등록하기 위해 `mempalace init`을 실행하여 다른 기기로 복원할 수 있습니다.

---

## MCP 서버 통합

MemPalace는 Claude Code, Cursor 및 기타 MCP 호환 에이전트와 함께 사용하기 위한 내장 MCP 서버를 포함합니다.

```bash
# MCP 서버 시작
mempalace mcp --port 8765

# Claude Code 구성에서 (~/.claude/settings.json):
{
  "mcpServers": {
    "mempalace": {
      "command": "mempalace",
      "args": ["mcp", "--port", "8765"]
    }
  }
}
```

MCP 서버는 다음을 노출합니다:
- `mempalace_store`: 대화 세그먼트 저장
- `mempalace_query`: 의미 기반 검색을 통해 컨텍스트 검색
- `mempalace_list_wings`: 사용 가능한 날개 나열
- `mempalace_list_rooms`: 날개 내의 방 나열

---

## 심층 분석: Python API

MCP 호환 에이전트를 사용하지 않는 경우 MemPalace의 Python API를 직접 사용할 수 있습니다:

```python
import mempalace

# Initialize memory store
memory = mempalace.Store("~/projects/myapp")

# Store a conversation segment
memory.store({
    "role": "user",
    "content": "How do I implement OAuth2 with Google?"
})
memory.store({
    "role": "assistant", 
    "content": "You'll need to create a Google Cloud project..."
})

# Query for relevant context
results = memory.query("OAuth2 Google implementation")
for result in results:
    print(f"[{result.wing}/{result.room}]: {result.content[:200]}")

# List all wings
for wing in memory.list_wings():
    print(f"Wing: {wing.name} ({len(wing.rooms)} rooms)")
```

Python API는 CLI를镜像하지만 메모리 그래프에 프로그래밍 방식 접근을 제공합니다. 이는 다음에 유용합니다:
- 커스텀 에이전트 통합
- 대화 기록 배치 처리
- 메모리 대시보드 구축
- 자동화된 백업 워크플로우

---

## Docker 배포

서버 사이드 또는 컨테이너화된 배포를 위해:

```bash
# Docker 이미지 빌드
docker build -t mempalace-server .

# Docker에서 MCP 서버 실행
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server \
  mcp --port 8765
```

모든 내용은 `/data` 아래에 영구 저장됩니다(팰리스, 구성 및 캐시된 임베딩 모델), 따라서 거기에 볼륨을 마운트하세요. 이 설정은 다음과 잘 작동합니다:
- 공유 팀 메모리 (여러 기계가 동일한 데이터베이스에 접근)
- 에이전트 메모리가 필요한 CI/CD 파이프라인
- Docker 오케스트레이션이 있는 프로덕션 환경

---

## 대안과 비교

|| 기능 | MemPalace | Mem0 | Memory Bank | 로컬 RAG |
|---------|-----------|------|-------------|-----------|
|| 원문 그대로 저장 | ✓ | ✗ | ✗ | ✗ |
|| 구조화된 인덱싱 | 날개/방/서랍 | 평평한 벡터 | 채팅 기록 | 임베딩 |
|| API 필요 | 0 | 1-3 | 5-8 | 0 |
|| 로컬 우선 | ✓ | ✗ | ✗ | ✓ |
|| MCP 서버 | 내장 | 플러그인 | 없음 | 없음 |
|| 벤치마크 | 96.6% R@5 | 78.2% | 71.4% | N/A |
|| Stars | 55,206 | 12,400 | 8,900 | 18,200 |

MemPalace의 구조화된 접근 방식(날개 → 방 → 서랍)이 96.6% 벤치마크를 이끄는 요인입니다. 다른 시스템은 평평한 벡터 검색 또는 토큰 확장 컨텍스트 윈도우를 사용하며, 이는 약 200K 토큰에서 실제 한계에 부딪힙니다.

## 한계 / 정직한 평가

MemPalace는 모든 사람을 위한 것은 아닙니다:

- **클라우드 팀에게는 부적합**: 다른 기계에서 작업하는 팀원 간에 공유 메모리가 필요하다면, MemPalace의 로컬 우선 디자인은 도움이 되지 않습니다
- **Python 환경 필요**: 설치를 위해 호환되는 Python 버전과 함께 `uv` 또는 `pip`가 필요합니다
- **기본 ChromaDB**: 플러그인 가능하지만, 대부분의 사용자는 약 500MB RAM이 필요한 임베딩 모델인 ChromaDB를 사용할 것입니다
- **클라우드 백업 없음**: 메모리는 로컬에 stay합니다. 디스크가 고장 나면 메모리가 사라집니다(백업하지 않는 한)

이것은 AI 에이전트를 위한 지속적이고 프라이빗한 메모리를 원하는 **개별 개발자**를 위해 만들어졌습니다.

---

## 현실 세계 사용 사례

### 사용 사례 1: 지속적 코딩 컨텍스트

```bash
# Start a new Claude Code session
claude

# Claude Code automatically queries MemPalace for relevant context
# when you ask about previous work on the same feature
> "Remember when we implemented OAuth2 last week?"
> [MemPalace retrieves: Wing "Person-A" → Room "Project-A" → Drawer: #3]
```

이 사용 사례는 장기 프로젝트에서 작업하고 이전 구현, 결정 및 제약을 AI 에이전트가 기억하기를 원하는 개발자에게 완벽합니다.

### 사용 사례 2: 연구 컨텍스트

```bash
# Store research notes from your agent
mempalace store "Research: LangGraph vs LangChain for agent orchestration"
mempalace store "Key finding: LangGraph has better state management..."

# Later, query for all research notes
mempalace search "agent orchestration comparison" --wing "Research"
```

여러 연구 세션에 걸쳐 검색 가능한 지식 베이스를 유지하려는 연구자에게 완벽합니다.

### 사용 사례 3: 팀 지식 베이스

```bash
# 팀원 간 메모리 공유 (Docker 배포)
docker run -d \
  --name mempalace \
  -v /data:/data \
  -p 8765:8765 \
  mempalace-server mcp --port 8765

# 각 팀원이 프로젝트별로 다른 접근 권한으로
# 공유 메모리 서버에 연결합니다
```

데이터 프라이버시와 제어권을 유지하면서 공유 메모리가 필요한 팀을 위한 것입니다.

---

## 자주 묻는 질문

### 질문1: MemPalace는 내 데이터를 클라우드에 저장하나요?
아니요. MemPalace는 로컬 우선입니다. 대화 기록, 메모리 인덱스 및 임베딩은 모두 귀하의 기계에 stay합니다. 기본적으로 외부 서비스에 API 호출이 이루어지지 않습니다.

### 질문2: MemPalace를 모든 AI 에이전트와 사용할 수 있나요?
네, MCP(모델 컨텍스트 프로토콜)를 지원하는 경우. Claude Code, Cursor, Windsurf 및 기타 MCP 호환 에이전트는 바로 작동합니다. 비-MCP 에이전트의 경우 Python API를 직접 사용할 수 있습니다.

### 질문3: 96.6% 벤치마크 점수는 다른 메모리 시스템과 비교하면 어떤가요?
MemPalace의 LongMemEval에서 96.6% 원시 R@5는 오픈소스 메모리 시스템 중 최고의 벤치마크 점수입니다. 대부분의 경쟁사는 구조화된 검색이 아닌 컨텍스트 확장(더 많은 토큰 저장)을 통해 70-80%를 달성합니다.

### 질문4: ChromaDB에서 다른 백엔드로 전환할 수 있나요?
네. 검색 계층은 플러그인 가능합니다. 기본값은 ChromaDB이지만, `mempalace/backends/base.py`를 구현하는 모든 백엔드로 넣을 수 있습니다. 커스텀 백엔드를 지원합니다.

### 질문5: 메모리 파일을 삭제하면 어떻게 되나요?
MemPalace는 로컬 우선이므로 클라우드 복구가 없습니다. 메모리 파일을 삭제하면 수동으로 백업하지 않은 한 데이터가 사라집니다. 메모리가 중요하다고 생각하면 자동 백업을 설정하세요.

---

## 출처 및 추가 자료

- 공식 문서: [mempalaceofficial.com](https://mempalaceofficial.com)
- GitHub 저장소: [MemPalace/mempalace](https://github.com/MemPalace/mempalace)
- 벤치마크: [benchmarks/BENCHMARKS.md](https://github.com/MemPalace/mempalace/blob/main/benchmarks/BENCHMARKS.md)
- LongMemEval 결과: [96.6% R@5 원시](https://github.com/MemPalace/mempalace#benchmarks)
- MCP 서버 문서: [mempalaceofficial.com/concepts/the-palace](https://mempalaceofficial.com/concepts/the-palace.html)

---

## 결론: 실제로 기억하는 AI 에이전트 구축

MemPalace는 "금붕어 에이전트" 문제를 해결합니다. 대화 기록을 원문 그대로 저장하고, 구조적으로 인덱싱하며, 96.6%의 정확도로 검색합니다 — API 호출 제로로.

**지금 시도:**

```bash
uv tool install mempalace
mempalace init ~/projects/myapp
```

VPS 또는 전용 서버에서 자체 호스팅 메모리를 원한다면, 합리적인 가격의 GPU 호스팅을 위해 [HTStack](https://my.htstack.com/aff.php?aff=27187)을, 손쉬운 클라우드 배포를 위해 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)을 고려하세요.

dibi8 **한국어 Telegram 그룹** https://t.me/DIBI8_Group/9에 참여하여 AI 메모리 시스템, 에이전트 아키텍처 및 오픈소스 도구에 대해 논의하세요.

관련 기사:
- [LangChain 완전 가이드](dibi8-internal-link/llm-frameworks/langchain-complete-guide)
- [벡터 데이터베이스 비교](dibi8-internal-link/data-science/vector-database-comparison)
- [MCP 심층 분석](dibi8-internal-link/llm-frameworks/mcp-deep-dive)

*위의 일부 링크는 제휴 링크입니다. dibi8.com은 추가 비용 없이 가입할 경우 커미션을 받을 수 있습니다. 이는 사이트 운영과 콘텐츠를 무료로 유지하는 데 도움이 됩니다.*