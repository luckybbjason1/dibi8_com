---
title: "Hello-Agents: Datawhale의 오픈소스 AI 에이전트 튜토리얼이 제로에서 프로덕션급 에이전트 구축을 돕는 방법"
description: "Datawhale Hello-Agents는 GitHub에서 가장 인기 있는 AI 에이전트 오픈소스 튜토리얼로, ReAct, AutoGen, LangGraph, MCP, Agentic RL 등 16장의 완전한 과정을 다루며 45,600+ Stars를 보유하고 있습니다."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - JavaScript
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "197.3 MB"
file_md5: ""
download_url: "https://github.com/datawhalechina/hello-agents"
backup_url: ""
github_repo: "https://github.com/datawhalechina/hello-agents"
stars: 50847
maintainer: "datawhalechina"
last_maintained: "2026-05-14"
featureImage: ""
draft: false
faqs:
  - q: 'Datawhale Hello-Agents란 무엇인가요?'
    a: 'Hello-Agents는 중국 Datawhale 커뮤니티에서 만든 무료 오픈소스 튜토리얼로, AI 에이전트를 처음부터 만드는 법을 가르칩니다. 실행 가능한 코드가 포함된 16개 챕터 커리큘럼을 제공하며, 온라인 도서, 로컬 문서, 다운로드 가능한 PDF 형태로 이용할 수 있습니다.'
  - q: 'Hello-Agents의 16개 챕터 커리큘럼은 어떤 주제를 다루나요?'
    a: '에이전트와 LLM 기초, 고전 패러다임(ReAct, Plan-and-Solve, Reflection), 로우코드 플랫폼(Coze, Dify, n8n), 전문 프레임워크(AutoGen, AgentScope, LangGraph), 메모리와 RAG, 컨텍스트 엔지니어링, 통신 프로토콜(MCP, A2A, ANP), Agentic RL(SFT, RLHF, GRPO), 평가, 그리고 세 가지 종합 캡스톤 사례 연구를 아우릅니다.'
  - q: 'Hello-Agents를 배우려면 어떤 프로그래밍 언어와 환경이 필요한가요?'
    a: '코드는 주로 Python(약 72.5%)과 Jupyter notebooks로 작성되어 있습니다. 권장 환경은 Python 3.9+, OpenAI API key 또는 GitHub Models 액세스이며, 로컬 모델용으로 Ollama, RAG 챕터의 벡터 데이터베이스로 Chroma 또는 Weaviate를 선택적으로 사용할 수 있습니다.'
  - q: 'Hello-Agents는 무료로 사용할 수 있나요? 라이선스는 무엇인가요?'
    a: '네, Hello-Agents는 오픈소스 라이선스 하에 완전히 무료이며, 전체 PDF는 GitHub releases 또는 Datawhale 웹사이트에서 무료로 받을 수 있습니다. 이 PDF에는 상업적 재판매를 방지하기 위한 Datawhale 워터마크가 있지만, 개인 학습용으로는 완전히 사용할 수 있습니다.'
  - q: 'Hello-Agents를 따라 하면 어떤 실전 프로젝트를 만들 수 있나요?'
    a: '이 튜토리얼에는 세 가지 종합 사례 연구가 포함되어 있습니다. MCP 도구 호출을 통해 여러 전문 에이전트를 조율하는 스마트 여행 어시스턴트, 웹 검색 결과를 찾아 보고서로 종합하는 자동화된 딥 리서치 에이전트, 그리고 각기 다른 성격과 일과를 가진 AI 에이전트들로 채워진 사이버 타운 시뮬레이션입니다.'
---
{</* resource-info */>}

## Hello-Agents란?

**Hello-Agents**는 중국의 유명한 오픈소스 AI 교육 커뮤니티 **Datawhale**이 만든 **체계적인 오픈소스 AI 에이전트 튜토리얼**입니다. GitHub에서 **45,600+ Stars**를 획득하여 "LLM 사용자"에서 "Agent 시스템 구축자"로 성장하는 권위 있는 시작점이 되었습니다.

**GitHub**: https://github.com/datawhalechina/hello-agents
**Stars**: 45,600+
**라이선스**: Apache 2.0

---

## 왜 Hello-Agents가 필요한가?

2025년은 "AI 에이전트의 해"로 널리 인정받았습니다. OpenAI의 Operator에서 Google의 A2A 프로토콜까지, Anthropic의 MCP에서 바이트댄스의 UI-TARS까지, 전체 산업은 사용자를 대신해 인식하고 계획하고 행동할 수 있는 자율 지능 시스템으로 전환하고 있습니다.

그러나 대부분의 개발자에게 "챗봇 사용"에서 "진정한 Agent 구축"까지의 간극은 여전히 큽니다. Hello-Agents는 바로 이 공백을 채우는 완전한 솔루션입니다.

---

## 16장 완전한 커리큘럼

### 파트 1: Agent & LLM 기초
- **1장: Agent 첫 만남** — Agent 정의, 진화 역사, 핵심 패러다임
- **2장: Agent 발전 역사** — 기호 AI에서 AlphaGo까지, LLM 기반 자율 시스템까지
- **3장: LLM 기초** — Transformer 아키텍처, 어텐션 메커니즘, 프롬프트 엔지니어링

### 파트 2: 첫 LLM Agent 구축
- **4장: 클래식 Agent 패러다임** — ReAct, Plan-and-Solve, Reflection 제로 구현
- **5장: 로우코드 플랫폼 Agent** — Coze, Dify, n8n 3대 플랫폼 실전
- **6장: 프레임워크 개발 실습** — AutoGen, AgentScope, LangGraph 비교 실전
- **7장: 자체 Agent 프레임워크** — OpenAI API와 표준 라이브러리만으로 최소 Agent 프레임워크 구축

### 파트 3: 고급 지식 확장
- **8장: 메모리 & 검색** — 단기 메모리, 장기 메모리, RAG 벡터 검색 시스템
- **9장: 컨텍스트 엔지니어링** — 윈도우 전략, 요약 기술, 계층적 컨텍스트 구조
- **10장: Agent 통신 프로토콜** — MCP, A2A, ANP 3대 프로토콜 심층 분석
- **11장: Agentic RL** — SFT, RLHF, GRPO 완전 훈련 파이프라인
- **12장: Agent 성능 평가** — AgentBench, SWE-bench 등 벤치마크 테스트

### 파트 4: 종합 사례 연구
- **13장: 스마트 여행 어시스턴트** — 다중 Agent 협업 MCP 도구 호출 실전
- **14장: 자동화 딥 리서치 Agent** — OpenAI DeepResearch 기능 복제
- **15장: 사이버 타운 구축** — 다중 Agent 사회 역학과 emergent behavior 시뮬레이션

### 파트 5: 캡스톤 & 전망
- **16장: 캡스톤 프로젝트** — 제로부터 완전한 지능형 에이전트 애플리케이션 설계 및 구축

---

## 핵심 하이라이트

| 능력 | Hello-Agents | 프레임워크 문서 | 유료 부트캠프 | 동영상 튜토리얼 |
|------|-------------|----------------|--------------|----------------|
| 체계적 커리큘럼 | 16장 점진식 | 파편화 | 편차 큼 | 비구조화 |
| 이론 심도 | Transformer에서 RL까지 | 프레임워크 전용 | 보통 얕음 | 보통 얕음 |
| 실습 코딩 | 매 장마다 | 예시만 | 비용 제한 | 드물게 완전 |
| 로우코드+코드네이티브 | 둘 다 다룸 | 코드만 | 보통 둘 중 하나 | 품질 혼재 |
| 고급 주제 | 전체 장 | 거의 다루지 않음 | 프리미엄 전용 | 거의 없음 |
| 실전 프로젝트 | 3개 종합 사례 | 보통 없음 | 1-2개 프로젝트 | 드물게 프로덕션급 |
| 커뮤니티 업데이트 | 71명 기여자 | 벤더 제어 | N/A | 신뢰할 수 없음 |
| 가격 | 무료 | 무료 | $500-$5000 | 무료 |

---

## 빠른 시작

```bash
# 온라인 읽기
# https://datawhalechina.github.io/hello-agents/

# 로컬 설정
git clone https://github.com/datawhalechina/hello-agents.git
cd hello-agents
# Extra-Chapter/07 참고하여 환경 구성

# 4장 ReAct Agent 실행
python code/chapter4/react_agent.py
```

---

## 코드 예시: 제로에서 ReAct Agent 구축

```python
import openai
import json

tools = [
    {
        "type": "function",
        "function": {
            "name": "search_web",
            "description": "웹에서 정보 검색",
            "parameters": {
                "type": "object",
                "properties": {"query": {"type": "string"}},
                "required": ["query"]
            }
        }
    },
    {
        "type": "function",
        "function": {
            "name": "calculate",
            "description": "수학 계산 수행",
            "parameters": {
                "type": "object",
                "properties": {"expression": {"type": "string"}},
                "required": ["expression"]
            }
        }
    }
]

def search_web(query): return f"검색 결과: {query}"
def calculate(expr): return str(eval(expr))

messages = [
    {"role": "system", "content": "당신은 유용한 어시스턴트입니다. 필요할 때 도구를 사용하세요."},
    {"role": "user", "content": "도쿄 인구를 1000으로 나눈 값은?"}
]

for step in range(5):
    response = openai.chat.completions.create(
        model="gpt-4", messages=messages, tools=tools, tool_choice="auto"
    )
    message = response.choices[0].message
    messages.append(message)
    
    if message.tool_calls:
        for tc in message.tool_calls:
            name = tc.function.name
            args = json.loads(tc.function.arguments)
            result = search_web(**args) if name == "search_web" else calculate(**args)
            messages.append({"role": "tool", "tool_call_id": tc.id, "content": result})
    else:
        print("최종 답변:", message.content)
        break
```

> 이 "생각 → 도구 호출 → 결과 관찰 → 다시 생각"의 루프는 OpenAI Operator와 Claude Computer Use 등 최고의 Agent가 사용하는 핵심 메커니즘입니다.

---

## 대상 독자

| 독자층 | 가치 |
|--------|------|
| **AI 엔지니어 지망생** | Agent 엔지니어링 핵심 능력을 체계적으로 습득, 면접 문제는 대기업 실전 문제에서 직접 추출 |
| **제품 팀** | 로우코드 장으로 빠른 프로토타입 검증, 프레임워크 장으로 개발 팀과 효율적 협업 |
| **연구자/학자** | Agentic RL과 평가 장은 연구 프로젝트의 시작점으로 충분한 깊이 |
| **인디 개발자/창업가** | 캡스톤 구조와 커뮤니티 프로젝트 라이브러리가 제품화에 영감과 참조 구현 제공 |

---

## 요약

Hello-Agents는 오늘날 가장 포괄적이고 이해하기 쉬우며 커뮤니티 지원이 강력한 AI 에이전트 개발 학습 자원입니다. **대학 과정의 깊이**, **부트캠프의 실용성**, **오픈소스 프로젝트의 커뮤니티 활력**, 그리고 **무료 문서의 가격**을 모두 갖추고 있습니다.

에이전트 혁명은 곧 올 것이 아니라 — 이미 여기에 있습니다. Hello-Agents는 당신이 단순한 관찰자가 아닌 건설자가 되도록 보장합니다.

> 💡 더 많은 AI 도구와 오픈소스 프로젝트를 원하시나요? 매주 선별된 추천을 위해 [dibi8.com](https://dibi8.com)을 팔로우하세요.

---

## 자체 호스팅 추천 인프라

24/7 안정 운영을 위해 인프라 선택이 중요하다:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 60일 $200 크레딧, 글로벌 14+ 리전. 오픈소스 AI 도구 자체 호스팅에 적합.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 홍콩 VPS, 중국 본토 접근 시 저지연. dibi8.com 자체가 호스팅된 검증된 IDC.

*추천 링크입니다. 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

