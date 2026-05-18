---
title: 'AutoGen 멀티 에이전트 프레임워크 튜토리얼 2025: 다중 AI 에이전트 시스템 구축'
description: 'Microsoft AutoGen으로 대화형 멀티 에이전트 시스템을 구축하는 방법. 설치, 에이전트 설정, GroupChat, 코드 실행, 로컬 LLM 통합까지 상세히 설명한다.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/autogen-multi-agent-framework/
---

{</* resource-info */>}

Microsoft Research에서 개발한 AutoGen은 대화형 AI 에이전트를 구성하고 협업시키는 것을 핵심 목표로 하는 오픈소스 프레임워크다. 2023년 8월 첫 릴리스 이후 GitHub Star 36,000개 이상을 확보했으며, 코드 생성과 실행을 에이전트의 기본 능력으로 내장한 점이 가장 큰 차별점이다. 이 글에서는 AutoGen의 핵심 개념부터 실전 멀티 에이전트 시스템 구축까지 전 과정을 다룬다.

## AutoGen이란 무엇인가?

AutoGen은 "대화 가능한 에이전트(Conversable Agents)"라는 개념을 중심으로 설계되었다. 각 에이전트는 독립적으로 메시지를 주고받을 수 있으며, 인간의 개입(Human-in-the-loop)을 자연스럽게 통합할 수 있다. 다른 에이전트 프레임워크와 비교했을 때 AutoGen의 가장 큰 특징은 **에이전트가 직접 코드를 작성하고 실행할 수 있다는 점**이다.

**AutoGen vs 다른 에이전트 프레임워크:**

| 프레임워크 | 개발사 | 핵심 철학 | 코드 실행 | GitHub Star |
|-----------|--------|----------|----------|-------------|
| **AutoGen** | Microsoft | 대화형 에이전트 | 내장 지원 | 36,000+ |
| **CrewAI** | CrewAI Inc | 역할 기반 팀워크 | 외부 도구 | 26,000+ |
| **LangGraph** | LangChain | 상태 기반 그래프 | 외부 도구 | - |
| **MetaGPT** | 오픈소스 | SOP 기반 시뮬레이션 | 내장 지원 | 47,000+ |

## AutoGen 아키텍처와 핵심 개념

AutoGen의 모든 기능은 네 가지 핵심 클래스를 중심으로 구성된다.

**ConversableAgent**: 모든 에이전트의 기본 클래스다. LLM 설정, 휴리스틱 함수, 코드 실행 환경을 구성할 수 있다. `send`와 `receive` 메서드로 메시지를 주고받는다.

**UserProxyAgent**: 인간 사용자를 대신하는 에이전트다. Human-in-the-loop 모드에서 사용자의 승인을 요청하거나, 자동 승인 모드로 모든 코드 실행을 자동화한다. 코드 실행기(Docker 또는 로컬)를 내장하고 있다.

**AssistantAgent**: 코드 작성과 분석을 담당하는 에이전트다. 기본적으로 GPT-4나 Claude와 같은 강력한 LLM을 백엔드로 사용한다. Python 코드 블록을 생성하면 UserProxyAgent가 이를 실행하고 결과를 반환한다.

**GroupChat**: 세 개 이상의 에이전트가 참여하는 다자간 대화를 관리한다. `RoundRobin`, `Random`, `Manual` 등 다양한 스피커 선택 전략을 지원하며, 2025년 기준 `GroupChatManager`가 대화 흐름을 제어한다.

## 설치와 환경 설정

### pip로 설치하기

```bash
pip install pyautogen
```

### LLM 엔드포인트 구성

```python
import autogen

config_list = [
    {
        "model": "gpt-4",
        "api_key": "sk-your-openai-key",
    }
]

# Azure OpenAI 사용 시
config_list_azure = [
    {
        "model": "gpt-4",
        "api_key": "<azure-api-key>",
        "base_url": "https://<your-resource>.openai.azure.com/",
        "api_type": "azure",
        "api_version": "2024-02-01",
    }
]
```

### 첫 번째 에이전트 설정

```python
assistant = autogen.AssistantAgent(
    name="assistant",
    llm_config={"config_list": config_list},
)

user_proxy = autogen.UserProxyAgent(
    name="user_proxy",
    human_input_mode="NEVER",
    max_consecutive_auto_reply=10,
    code_execution_config={"work_dir": "coding", "use_docker": False},
)
```

## 첫 멀티 에이전트 시스템 구축하기

### 두 에이전트 간 단순 대화

```python
# 기본적인 두 에이전트 대화
user_proxy.initiate_chat(
    assistant,
    message="1부터 100까지의 소수를 찾는 Python 코드를 작성하고 실행해줘."
)
```

위 코드를 실행하면 AssistantAgent가 코드를 작성하고, UserProxyAgent가 해당 코드를 실행하여 결과를 반환한다. 이 과정이 자동으로 반복되며 정확한 결과를 얻을 때까지 진행된다.

### 코드 실행 활성화

```python
user_proxy = autogen.UserProxyAgent(
    name="user_proxy",
    code_execution_config={
        "work_dir": "coding",
        "use_docker": True,  # Docker 샌드박스 사용
        "timeout": 60,
    },
)
```

`use_docker=True`로 설정하면 코드 실행이 Docker 컨테이너 낶에서 이루어져 보안이 향상된다. 프로덕션 환경에서는 반드시 Docker 샌드박스를 사용해야 한다.

### 종료 조건 설정

```python
user_proxy = autogen.UserProxyAgent(
    name="user_proxy",
    is_termination_msg=lambda msg: "TERMINATE" in msg["content"],
    max_consecutive_auto_reply=5,
)
```

`max_consecutive_auto_reply`로 최대 대화 턴 수를 제한하고, `is_termination_msg`로 특정 키워드 수신 시 대화를 종료할 수 있다.

## 고급 에이전트 패턴

### GroupChat으로 다중 에이전트 협업 구성

```python
# 여러 전문가 에이전트 생성
pm = autogen.AssistantAgent(name="product_manager", system_message="...")
architect = autogen.AssistantAgent(name="architect", system_message="...")
dev = autogen.AssistantAgent(name="developer", system_message="...")
qa = autogen.AssistantAgent(name="qa_engineer", system_message="...")

user_proxy = autogen.UserProxyAgent(name="user_proxy")

groupchat = autogen.GroupChat(
    agents=[user_proxy, pm, architect, dev, qa],
    messages=[],
    max_round=20,
    speaker_selection_method="auto",
)

manager = autogen.GroupChatManager(
    groupchat=groupchat,
    llm_config={"config_list": config_list},
)

user_proxy.initiate_chat(manager, message="웹 쇼핑몰 회원가입 기능을 설계하고 구현해줘.")
```

### 순차 대화 워크플로우

```python
# 첫 번째 대화 완료 후 결과를 두 번째 대화로 전달
chat_result = user_proxy.initiate_chat(assistant, message="데이터 분석 계획을 세워줘.")

# 이전 대화 맥락을 유지하며 후속 작업
user_proxy.initiate_chat(
    analyst,
    message=f"이전 계획을 바탕으로 분석을 실행해줘: {chat_result.summary}"
)
```

### 중첩 대화 패턴

중첩 대화는 하나의 에이전트가 다른 에이전트와의 하위 대화를 시작하는 패턴이다. 복잡한 문제를 하위 태스크로 분해하여 각각 전문 에이전트에 위임할 때 유용하다.

### Human-in-the-loop와 승인 모드

```python
user_proxy = autogen.UserProxyAgent(
    name="user_proxy",
    human_input_mode="ALWAYS",  # 매번 사용자 승인 요청
    # human_input_mode="TERMINATE",  # 종료 시에만 승인 요청
)
```

`human_input_mode`를 `"ALWAYS"`로 설정하면 코드 실행 전마다 사용자의 승인을 받는다. 민감한 작업에서는 반드시 이 모드를 사용해야 한다.

## 로컬 및 오픈소스 모델과 함께 사용하기

### Ollama와 AutoGen 연동

```python
config_list_ollama = [
    {
        "model": "llama3",
        "base_url": "http://localhost:11434/v1",
        "api_key": "ollama",
    }
]

assistant = autogen.AssistantAgent(
    name="local_assistant",
    llm_config={"config_list": config_list_ollama},
)
```

### vLLM과 LM Studio 통합

vLLM은 고성능 추론 엔진으로, AutoGen의 에이전트 백엔드로 활용하면 API 비용을 대폭 절감할 수 있다. LM Studio는 GUI 기반 로컬 LLM 관리 도구로, 개발 단계에서 빠르게 다양한 모델을 테스트할 수 있다.

**비용 최적화 전략:**

- 복잡한 계획 수립: GPT-4 사용
- 단순 코드 생성: 로컬 Llama-3 사용
- 반복적 테스트: vLLM 배치 처리로 일괄 실행

## 실전 사용례

### 자동화된 데이터 분석 파이프라인

데이터 분석가, 시각화 전문가, 보고서 작성가 세 에이전트가 협업하여 CSV 파일을 분석하고 인사이트를 도출하는 시스템이다. 2025년 기준 판다스, NumPy, Matplotlib, Seaborn을 자동으로 임포트하여 사용한다.

### 멀티 에이전트 코드 리뷰 시스템

개발자, 시큐어코딩 전문가, 성능 최적화 전문가 세 에이전트가 Pull Request를 리뷰하는 시스템이다. 보안 취약점, 성능 병목, 코드 스타일 문제를 각각의 전문 관점에서 검토한다.

### 웹 검색 연구 보조원

연구원 에이전트가 웹 검색 도구를 활용해 최신 논문과 기사를 수집하고, 요약가 에이전트가 핵심 내용을 정리하며, 편집자 에이전트가 최종 보고서를 작성한다.

## AutoGen과 LangGraph: 어떤 것을 선택해야 할까?

| 비교 항목 | AutoGen | LangGraph |
|-----------|---------|-----------|
| **대화 패러다임** | 자연어 대화 기반 | 상태 기반 DAG |
| **코드 실행** | 내장 샌드박스 | 외부 도구 필요 |
| **인간 개입** | 원활한 통합 | 중간 노드로 구현 |
| **에이전트 수** | 2~10개 권장 | 수십~수백개 확장 가능 |
| **적합한 사용례** | 코드 생성, 분석 | 복잡한 비즈니스 워크플로우 |

**AutoGen을 선택하라**는 경우: 에이전트 간 자연스러운 대화가 중요하고, 코드 생성과 실행이 핵심이며, 인간의 중간 개입이 빈번한 경우.

**LangGraph를 선택하라**는 경우: 복잡한 상태 머신이 필요하고, 수십 개 이상의 에이전트가 참여하며, 정형화된 비즈니스 프로세스를 구현하는 경우.

## 프로덕션 환경 모범 사례

### 토큰 비용 관리

- GPT-4와 로컬 모델을 하이브리드로 사용하여 평균 비용 60% 절감
- `max_consecutive_auto_reply`로 무한 루프 방지
- 대화 맥락 압축으로 과도한 히스토리 누적 방지

### 에러 처리와 재시도

```python
from autogen import AssistantAgent

assistant = AssistantAgent(
    name="assistant",
    llm_config={
        "config_list": config_list,
        "timeout": 30,
        "max_retries": 3,
    },
)
```

### 코드 실행 보안

프로덕션 환경에서는 반드시 Docker 샌드박스를 사용한다. 네트워크 격리, 리소스 제한(CPU, 메모리), 볼륨 마운트 제한을 설정하여 악성 코드 실행을 방지한다.

### 에이전트 대화 디버깅

AutoGen 0.2부터는 대화 로그를 구조화된 JSON으로 남길 수 있다. LangSmith나 자체 로깅 파이프라인에 연결하여 각 에이전트의 응답 시간, 토큰 사용량, 코드 실행 성공률을 모니터링한다.

---

## 자주 묻는 질문 (FAQ)

**AutoGen은 무엇에 사용하나요?**
AutoGen은 멀티 에이전트 AI 시스템 구축에 사용됩니다. 코드 자동 생성과 실행, 데이터 분석, 복잡한 문제의 분할 정복, 인간-AI 협업 워크플로우 등에 특화되어 있습니다. Microsoft Research에서 개발했으며, 연구부터 프로덕션까지 다양한 규모에서 활용됩니다.

**AutoGen은 물론이고 오픈소스인가요?**
네, MIT 라이선스 기반의 완전한 오픈소스 프로젝트입니다. Microsoft Research에서 주도적으로 개발하고 있으며,活발한 커뮤니티 기여가 이루어지고 있습니다. 상용 사용에 제한이 없습니다.

**AutoGen과 CrewAI의 차이는 무엇인가요?**
AutoGen은 대화형 에이전트와 코드 실행에 초점을 맞추며, 에이전트 간 자연스러운 협업을 강조합니다. CrewAI는 역할(Role) 기반의 팀워크와 SOP(표준 운영 절차)를 중심으로 설계되었습니다. 코드 생성이 핵심이라면 AutoGen이, 구조화된 업무 할당이 중요하다면 CrewAI가 적합합니다.

**AutoGen을 로컬 LLM으로 실행할 수 있나요?**
네, Ollama, vLLM, LM Studio 등 OpenAI 호환 API를 제공하는 모든 로컬 LLM 서버와 연동할 수 있습니다. `base_url`을 로컬 엔드포인트로 설정하면 됩니다. 단, 복잡한 작업에는 7B 이상의 모델 사용을 권장합니다.

**AutoGen의 코드 실행 보안은 어떻게 보장하나요?**
Docker 컨테이너 샌드박스에서 코드를 실행하여 호스트 시스템과 격리됩니다. 네트워크 접근, 파일 시스템 접근, 리소스 사용량을 제한할 수 있으며, Human-in-the-loop 모드로 모든 코드 실행 전 사용자 승인을 요청할 수도 있습니다.

## 참고 자료

- [AutoGen 공식 문서](https://microsoft.github.io/autogen)
- [AutoGen GitHub 저장소](https://github.com/microsoft/autogen)
- [CrewAI GitHub 저장소](https://github.com/crewAIInc/crewAI)
- [OpenAI API 문서](https://openai.com)
- [Ollama 공식 웹사이트](https://ollama.com)

---

## 추천 인프라

위 도구들을 24/7 안정 운영하려면 인프라가 중요하다:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연. dibi8.com 자체 호스팅 IDC.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

