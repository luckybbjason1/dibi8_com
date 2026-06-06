---
title: "MemPalace vs Mem0: 96.6% 리콜 벤치마크 및 2026년 최강 AI 메모리 프레임워크"
description: "GitHub 51,745 Star를 받은 MemPalace는 무료 오픈소스 AI 메모리 시스템입니다. AI 어시스턴트가 장기 대화 기록, 사용자 취향, 문맥을 기억하도록 구현하는 방법을 코드와 함께 상세히 설명합니다."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - JavaScript
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: ""
file_md5: ""
download_url: "https://github.com/MemPalace/mempalace.git"
backup_url: ""
github_repo: "https://github.com/MemPalace/mempalace.git"
stars: 0
maintainer: ""
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/mempalace/
faqs:
  - q: 'MemPalace란 무엇이며, AI에게 어떻게 기억 기능을 부여하나요?'
    a: 'MemPalace는 무료 오픈소스 로컬 우선 AI 메모리 시스템으로, 대화와 프로젝트 이력을 원문 그대로 저장하고 시맨틱 검색으로 불러옵니다. 모델 외부에 구조화된 메모리 레이어를 만들어, AI 어시스턴트가 매번 새 대화를 처음부터 시작하는 대신 과거의 정확한 맥락을 기억할 수 있게 합니다.'
  - q: 'MemPalace는 어떻게 설치하나요?'
    a: 'MemPalace는 Python 도구로, uv（uv tool install mempalace）또는 pip（pip install mempalace）를 통해 설치할 수 있습니다. 설치 후 mempalace init ~/projects/myapp 명령을 실행하면 프로젝트에 대한 초기화가 완료됩니다.'
  - q: 'MemPalace와 Mem0의 리콜 정확도는 어떻게 다른가요?'
    a: 'LongMemEval 벤치마크에서 MemPalace는 96.6%의 리콜률을 기록한 반면, Mem0는 89.2%였습니다. MemPalace는 API 호출 없이 완전히 로컬에서 실행되지만, Mem0는 유료 OpenAI API가 필요합니다.'
  - q: 'MemPalace는 저장된 메모리를 어떻게 구성하나요?'
    a: 'MemPalace는 궁전 은유를 사용해 세 단계로 메모리를 구성합니다. Wings는 사람과 프로젝트, Rooms는 해당 프로젝트 내의 주제, Drawers는 원문 그대로 저장된 실제 내용을 담습니다. 이 구조 덕분에 평평한 벡터 데이터베이스 전체를 조회하는 대신, 특정 프로젝트 윙이나 주제 룸으로 검색 범위를 정밀하게 좁힐 수 있습니다.'
  - q: 'MemPalace는 Claude Code 및 다른 AI 도구와 함께 사용할 수 있나요?'
    a: '네. MemPalace는 Claude Code를 위한 .claude-plugin 디렉터리, OpenAI Codex를 위한 .codex-plugin 디렉터리, MCP 호환 도구를 위한 .agents/plugins 디렉터리, 그리고 Gemini CLI 및 로컬 모델 지원을 포함한 네이티브 플러그인을 기본 제공합니다. 기본적으로 MCP 호환 엔드포인트를 노출해 지속적인 코딩 에이전트 메모리를 지원합니다.'
---

{</* resource-info */>}

## 벤치마크 비교: MemPalace vs Mem0 vs Mastra
AI 메모리 시스템을 평가할 때 성능과 리소스 소비는 핵심입니다. **LongMemEval** 벤치마크에서 MemPalace가 경쟁자들을 어떻게 압살하는지 확인하십시오:

| 주요 기능/지표 | MemPalace | Mem0 | Mastra | Hindsight |
| :--- | :--- | :--- | :--- | :--- |
| **컨텍스트 리콜(Recall)** | **96.6%** | 89.2% | 85.5% | 91.0% |
| **API 호출 요구사항**| **없음 (완전 로컬)** | OpenAI API (유료) | Anthropic API | 없음 |
| **스토리지 아키텍처**| 원문 보존 + 벡터 검색 | 벡터 단일 검색 | 그래프 + 벡터 | 벡터 단일 검색 |
| **Claude Code 지원**| 네이티브 지원 (MCP) | 수동 통합 필요 | 지원됨 | 미지원 |


## AI가 당신을 기억하게 만드는 방법 — MemPalace 오픈소스 메모리 시스템 완벽 가이드

AI 어시스턴트와 대화할 때 매번 "내 이름이 뭐라고 했지?"라고 묻는 경험, 다들 한 번쯤 해보셨을 겁니다. 매 세션이 처음부터 시작되는 AI는 사실상 "기억력 제로"의 존재입니다. 이런 문제를 해결한 것이 바로 **MemPalace** — GitHub에서 **51,745개의 Star**를 받은, 가장 검증된 오픈소스 AI 메모리 시스템입니다.

> "The best-benchmarked open-source AI memory system. And it's free."
> — MemPalace GitHub

이 글에서는 MemPalace가 어떻게 AI에게 **장기 기억**을 부여하는지, 그리고 여러분의 프로젝트에 어떻게 적용하는지 코드 중심으로 설명합니다.

---

## 왜 AI에게 메모리가 필요한가?

현대 LLM(Large Language Model)의 가장 큰 한계는 **상태 비저장(stateless)** 설계입니다. 각 API 호출은 독립적이며, 이전 대화 맥락을 전달하지 않으면 AI는 전혀 다른 사람처럼 행동합니다.

이로 인해 발생하는 문제들:

- **사용자 취향 반복 설명**: "나는 간결한 답변을 선호해"를 매번 입력
- **장기 프로젝트 맥락 상실**: 3일 전에 기획한 내용을 AI가 기억 못 함
- **개인화 실패**: 사용자별 맞춤 응답 불가능

MemPalace는 이 문제를 **벡터 기반 의미 검색 + 계층적 메모리 관리**로 해결합니다.

---

## MemPalace의 핵심 아키텍처

MemPalace는 세 가지 메모리 계층으로 구성됩니다:

| 계층 | 역할 | 저장 위치 |
|------|------|----------|
| **Working Memory** | 현재 세션의 단기 대화 맥락 | 인메모리 / Redis |
| **Short-term Memory** | 최근 N턴의 대요약 | SQLite / PostgreSQL |
| **Long-term Memory** | 사용자 취향, 사실, 중요 정보 | 벡터 DB (Chroma, Qdrant, Weaviate) |

### 메모리 흐름도

```
User Input → Working Memory (현재 대화)
                ↓
         [의미 분석 + 중요도 평가]
                ↓
    중요도 높음 → Long-term Memory (벡터 DB 저장)
    중요도 중간 → Short-term Memory (요약 저장)
    중요도 낮음 → Working Memory (세션 종료 시 폐기)
```

---

## 설치 및 기본 사용법

### 1. 설치

```bash
pip install mempalace
```

### 2. 기본 설정

```python
from mempalace import MemoryPalace, ChromaBackend

# 벡터 DB 백엔드 설정 (Chroma, Qdrant, Weaviate 지원)
backend = ChromaBackend(
    collection_name="user_memories",
    persist_directory="./memory_store"
)

# 메모리 시스템 초기화
memory = MemoryPalace(
    backend=backend,
    user_id="user_12345",      # 사용자별 격리
    max_working_tokens=4000,   # Working Memory 최대 토큰
    summary_threshold=10       # 10턴 후 자동 요약
)
```

### 3. 대화 중 메모리 저장

```python
# 사용자 정보 저장 (자동으로 벡터 임베딩되어 Long-term Memory에 저장)
memory.remember(
    content="사용자는 Python과 React를 주로 사용하며, 
             코드 예제를 포함한 상세한 설명을 선호함",
    category="preference",     # 카테고리 분류
    importance=0.9             # 중요도 0~1
)

# 사실 저장
memory.remember(
    content="사용자의 회사는 '디비에이트'이며 SaaS 분야에 종사함",
    category="fact",
    importance=0.85
)
```

### 4. 대화 시 메모리 검색 (자동 RAG)

```python
# 현재 질문과 관련된 과거 메모리를 자동 검색
relevant_memories = memory.recall(
    query="프로젝트 기술 스택 추천해줘",
    top_k=5,                   # 상위 5개 관련 메모리
    min_relevance=0.75           # 유사도 임계값
)

# 검색된 메모리를 프롬프트에 주입
context = memory.build_context(
    current_message="새 프로젝트 시작하려는데 뭐가 좋을까?",
    memories=relevant_memories
)

print(context)
# 출력 예시:
# [과거 기억]
# - 사용자는 Python과 React를 주로 사용함
# - 사용자의 회사는 '디비에이트'이며 SaaS 분야에 종사함
# [현재 대화]
# 사용자: 새 프로젝트 시작하려는데 뭐가 좋을까?
```

### 5. LLM 통합 예시 (OpenAI)

```python
from openai import OpenAI

client = OpenAI()

def chat_with_memory(user_message: str) -> str:
    # 1. 관련 메모리 검색
    memories = memory.recall(user_message, top_k=5)
    
    # 2. 컨텍스트 구성
    system_prompt = f"""당신은 사용자의 개인 AI 어시스턴트입니다.
다음은 사용자에 대해 알고 있는 정보입니다:
{memory.format_memories(memories)}

이 정보를 참고하여 개인화된 답변을 제공하세요."""
    
    # 3. LLM 호출
    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_message}
        ]
    )
    
    # 4. AI 응답도 메모리에 저장 (선택)
    memory.remember(
        content=f"AI: {response.choices[0].message.content}",
        category="conversation",
        importance=0.5
    )
    
    return response.choices[0].message.content

# 사용
reply = chat_with_memory("내가 좋아하는 기술 스택 기억나?")
print(reply)
# → "네! Python과 React를 주로 사용하시는 것으로 기억합니다. 
#    SaaS 프로젝트에 적합한 조합이에요."
```

---

## 고급 기능: 자동 요약 & 망각

MemPalace는 인간의 기억 메커니즘을 모방한 **자동 요약**과 **망각** 기능을 제공합니다.

```python
# 자동 요약 설정
memory = MemoryPalace(
    backend=backend,
    auto_summarize=True,
    summary_model="gpt-4o-mini",    # 요약용 경량 모델
    compression_ratio=0.3          # 원본의 30% 길이로 압축
)

# 망각 곡선 설정 (중요도에 따른 보존 기간)
memory.set_forgetting_curve(
    high_importance_ttl_days=365,   # 중요: 1년
    medium_importance_ttl_days=30,  # 보통: 30일
    low_importance_ttl_days=7       # 낮음: 7일
)
```

---

## MemPalace vs 다른 메모리 솔루션

| 기능 | MemPalace | LangChain Memory | 단순 DB 저장 |
|------|-----------|------------------|------------|
| 의미 기반 검색 | ✅ 벡터 임베딩 | ⚠️ 제한적 | ❌ 키워드만 |
| 계층적 메모리 | ✅ 3계층 | ⚠️ 2계층 | ❌ 단일 |
| 자동 요약/망각 | ✅ 내장 | ❌ 수동 구현 필요 | ❌ 없음 |
| 멀티 사용자 | ✅ 기본 지원 | ⚠️ 추가 설정 | ✅ 가능 |
| 무료/오픈소스 | ✅ 완전 무료 | ✅ 무료 | - |
| 벤치마크 검증 | ✅ 공개됨 | ❌ 없음 | - |

---

## 실제 적용 사례

### 1. 고객 지원 챗봇
- 이전 문의 내용 기억 → "지난번 배송 문제, 해결되셨나요?"
- 제품 취향 학습 → 관련 제품 자동 추천

### 2. 코딩 어시스턴트
- 프로젝트 구조 기억 → "`utils.py`에 추가하시죠"
- 코드 스타일 학습 → 사용자 스타일에 맞춘 코드 생성

### 3. 교육/코칭 AI
- 학습 진도 추적 → "지난번 못 푼 미분 방정식, 다시 도전해볼까요?"
- 약점 분석 → 취약 영역 집중 복습

---

## 시작하기

```bash
# 저장소 클론
git clone https://github.com/MemPalace/mempalace.git

# 예제 실행
cd mempalace/examples
python basic_chatbot.py

# 문서 확인
open https://mempalace.github.io/docs
```

---

## 결론

MemPalace는 단순한 "대화 저장소"가 아닙니다. **AI에게 진정한 기억을 부여하는 인프라**입니다. 51,745개의 GitHub Star는 이 시스템이 이미 수만 명의 개발자에게 검증되었음을 증명합니다.

무료이며 오픈소스인 MemPalace로, 여러분의 AI 프로젝트에도 "잊지 않는 지능"을 더해보세요.

> 🔗 **GitHub**: [github.com/MemPalace/mempalace](https://github.com/MemPalace/mempalace)  
> ⭐ **Stars**: 51,745  
> 💰 **가격**: 완전 무료 (MIT 라이선스)

---

## Related Articles





---

*이 글은 2026년 5월 10일에 작성되었습니다. MemPalace의 최신 정보는 공식 GitHub 저장소를 참고하세요.*

## FAQ: MemPalace 프로덕션 배포 가이드

**Q: MemPalace를 돌리려면 RAM이 얼마나 필요한가요? (how much RAM for MemPalace)**
A: 극도로 최적화되어 있습니다. 8GB RAM에서도 부드럽게 돌아가지만, 수천 개의 장기 세션을 유지해야 하는 프로덕션 환경이라면 16GB를 권장합니다.

**Q: Claude Code에 MemPalace를 연동할 수 있나요?**
A: 네! MCP 호환 엔드포인트를 기본 제공하므로, 코딩 에이전트(Claude Code)에 영구적인 메모리를 완벽하게 주입할 수 있습니다.

**Q: 로컬 메모리용으로 ChromaDB와 Pinecone 중 무엇이 좋나요?**
A: MemPalace는 로컬 ChromaDB를 사용하여 지연 시간(Latency) 0, API 비용 0을 달성합니다. 프라이버시가 생명인 로컬 에이전트 워크플로우에서는 Pinecone을 압도합니다.

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

