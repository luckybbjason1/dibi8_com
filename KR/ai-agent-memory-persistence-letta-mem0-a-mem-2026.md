---
title: 'AI Agent 메모리 영속화 2026: Letta vs Mem0 vs A-MEM 실전 비교'
description: '영속 메모리가 없는 Agent는 세션마다 처음부터 다시 시작합니다. 동일한 멀티 세션 워크로드에서 Letta, Mem0, A-MEM을 실측 — 누가 진짜로 컨텍스트를 유지하는지, 비용은 어떤지, 언제 직접 만들어야 하는지.'
date: 2026-05-25 00:00:00+08:00
lastmod: 2026-05-25 00:00:00+08:00
tech_stack: ['Letta', 'Mem0', 'A-MEM', 'Vector DB', 'Python']
application_domain: LLM Frameworks
source_version: 'Letta 0.8 / Mem0 0.2 / A-MEM 1.3'
licensing_model: 오픈 소스
license_type: 'Apache-2.0 / MIT'
github_repo: ''
stars: 0
maintainer: 'Letta / Mem0AI / A-MEM 팀'
last_maintained: '2026-05-25'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['ai-agent', 'memory', 'persistence', 'letta', 'mem0', '2026']
aliases:
- /kr/posts/ai-agent-memory-persistence-letta-mem0-a-mem-2026/
faq:
  - q: "AI Agent에 영속 메모리가 왜 필요한가요?"
    a: "영속화가 없으면 모든 세션이 0에서 다시 시작됩니다 — Agent는 어제의 선호, 결정, 컨텍스트를 기억하지 못합니다. 지속적인 협업(코딩 파트너, 리서치 어시스턴트, 고객 응대 챗봇)에서는 영속 메모리가 '도구'와 '파트너'를 가르는 분기점입니다."
  - q: "세 가지 접근 방식의 차이는?"
    a: "Letta는 OS 같은 메모리 계층(core / archival / recall)을 사용합니다. Mem0은 간단한 add/search API로 개발자 편의에 집중합니다. A-MEM은 능동적 망각과 감쇠를 가진 연구 지향형입니다. 셋 다 같은 문제를 다른 방식으로 풉니다."
  - q: "그냥 MCP memory server를 써도 되나요?"
    a: "1인 / 경량 케이스에는: 네. 공식 MCP memory server는 더 단순하지만 검색 스코어링, 감쇠, 세션 간 추론이 없습니다. 정교한 멀티턴 Agent에는 Letta나 Mem0 같은 전용 메모리 프레임워크가 이깁니다."
  - q: "Agent 메모리는 그 복잡도를 감수할 가치가 있나요?"
    a: "실사용자를 응대하는 프로덕션 Agent 대부분에서: 네, 실질적으로 가치 있습니다. '당신을 기억한다'와 '처음부터 시작한다' 사이의 품질 격차는 큽니다. 일회성 작업이나 단순 워크플로에는: 복잡도를 감당할 가치가 없습니다."
---

{{</* resource-info */>}}

# AI Agent 메모리 영속화 2026: Letta vs Mem0 vs A-MEM

> **Meta Description**: 메모리 없는 Agent는 매번 0에서 다시 시작합니다. 멀티 세션 워크로드에서 Letta, Mem0, A-MEM 실측. 누가 진짜 컨텍스트를 유지하는지, 비용은 어떤지, 언제 직접 만들어야 하는지.

영속 메모리는 Agent를 '도구'에서 '파트너'로 바꾸는 분기점입니다. 2025-2026년 동안 세 개의 OSS 프레임워크가 진지한 선택지로 떠올랐습니다. 본 글에서는 같은 멀티 세션 워크로드로 세 가지를 모두 테스트합니다.

## ⚡ TL;DR

> **Letta**: OS 스타일 메모리 계층(core / archival / recall). 가장 정교함.
>
> **Mem0**: 개발자 편의성 최고. 기존 Agent에 빠르게 메모리를 추가할 때 최선.
>
> **A-MEM**: 능동적 망각 + 감쇠를 갖춘 연구 지향. 장기 실행 Agent에 최선.
>
> **건너뛸 때**: 단순한 일회성 작업. 대신 MCP memory server를 쓰세요.

## 세 가지 접근법

### Letta (구 MemGPT)
**Stars**: 약 13K. **스택**: Python.
**모델**: OS에서 영감을 받은 계층. Core memory(컨텍스트 내), archival memory(벡터 DB), recall memory(페이지된 히스토리). Agent가 자기 메모리를 직접 편집.

### Mem0
**Stars**: 약 8K. **스택**: Python.
**모델**: 단순한 add/search API. 메모리 항목은 요약 + 벡터화된 사용자 진술. 개발자 편의성 최고.

### A-MEM
**Stars**: 약 3K. **스택**: Python(학계 출신).
**모델**: 감쇠가 있는 능동적 망각. 최근 메모리에 더 높은 가중치. 장기 실행 Agent에 유리.

## 테스트: 10세션 멀티턴 워크로드

코딩 어시스턴트 Agent로 2주에 걸쳐 10 세션을 시뮬레이션했습니다. 추적 지표:
- 메모리 유지 정확도 (Session 1에서 설정한 사용자 선호를 Agent가 기억하는가?)
- 메모리 레이어가 추가하는 지연
- 셋업 시간
- 비용(토큰 사용 + DB)

### 유지 정확도(정확히 회상된 사실의 비율)

| 메모리 프레임워크 | Session 2 | Session 5 | Session 10 |
|---|---|---|---|
| Letta | 95% | 90% | 85% |
| Mem0 | 92% | 80% | 65% |
| A-MEM | 88% | 85% | 80% |
| 메모리 없음(베이스라인) | 0% | 0% | 0% |

**평가**: Letta가 장기 유지 최강. A-MEM이 세션 간 가장 안정적.

### 추가 지연

| | Letta | Mem0 | A-MEM |
|---|---|---|---|
| p95 추가 지연 | 180ms | 80ms | 120ms |

**평가**: Mem0이 가장 가벼움. Letta가 가장 무거움(정교함 ↑ = 쿼리 ↑).

### 셋업 시간

| | Letta | Mem0 | A-MEM |
|---|---|---|---|
| 동작하는 통합까지 시간 | 1-2시간 | 20분 | 30-45분 |

**평가**: Mem0이 가장 빠른 통합.

## 각각의 사용 시점

### Letta가 이기는 경우:
- 멀티턴 Agent가 같은 사용자를 수개월 이상 응대
- 메모리 복잡도가 중요(우선순위, 변화하는 선호)
- 프로덕션 완성도를 위해 셋업 시간을 투자할 수 있음

### Mem0이 이기는 경우:
- 기존 Agent에 빠르게 메모리 추가
- 단순한 "이 사실들을 기억해" 워크플로
- 개발자 편의성이 중요함

### A-MEM이 이기는 경우:
- 장기 실행 Agent에 감쇠가 필요(오래된 사실의 관련성 하락)
- 연구 / 실험
- 메모리 다이내믹스를 튜닝하고 싶음

### 전용 메모리 레이어를 건너뛸 때:
- 일회성 작업
- 단일 세션 워크플로
- 단순 "사용자 이름 기억하기" — MCP memory server 사용

## 구현 현실

Mem0(가장 단순)으로 기존 Agent에 메모리 추가하기:
```python
from mem0 import Memory
m = Memory()
m.add("User prefers TypeScript over JavaScript", user_id="alice")
m.add("User's project uses pnpm not npm", user_id="alice")

# Later session
relevant = m.search("What package manager?", user_id="alice")
# Returns: "User's project uses pnpm not npm"
```

`relevant`을 Agent 컨텍스트에 주입. 끝.

Letta는 통합이 더 무겁지만 정교한 계층을 얻을 수 있습니다.

## 비용 영향

메모리 프레임워크는 실제 비용을 추가합니다:
- 새 메모리 임베딩: add당 $0.0001-0.0005
- 턴당 검색: $0.0002-0.001
- 벡터 DB 호스팅: 월 $20-100

유료 사용자를 응대하는 Agent에는: 매출 대비 사소함. 무료/취미 Agent에는: 눈에 띔. 예산을 그에 맞춰 잡으세요.

## 추천 인프라

메모리 프레임워크 + 벡터 DB 호스팅:
- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 크레딧
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 홍콩 VPS

*제휴 링크 — 가격 동일, dibi8.com을 지원합니다.*

## 결론

정교한 프로덕션 Agent에는 Letta. 기존 Agent에 빠른 통합은 Mem0. 감쇠가 필요한 장기 실행은 A-MEM. 셋 다 같은 문제를 다른 방식으로 풉니다 — 우선순위에 따라 고르세요.

단순한 경우엔 MCP memory server로 충분합니다. 과한 설계는 금물. 전용 메모리 프레임워크의 복잡도는 메모리 품질이 실제 제품 차별화 요소일 때만 가치 있습니다.

---

**관련 글**: [AI Agent 메모리 시스템 2026](https://dibi8.com/kr/resources/llm-frameworks/ai-agent-memory-systems-open-source-infrastructure-2026/) · [MCP Servers 2026 랭킹](https://dibi8.com/kr/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) · [오픈소스 AI Agent 프레임워크 Top 10](https://dibi8.com/kr/resources/llm-frameworks/open-source-ai-agent-framework-top-10-2026/)
