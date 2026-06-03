---
title: 'GPT Researcher: 심층 리서치 보고서를 만드는 자율 에이전트 — 2026 실전 가이드'
description: 'GPT Researcher는 어떤 작업이든 웹·로컬 리서치를 수행해 인용이 포함된 보고서를 작성하는 오픈소스 심층 리서치 에이전트입니다. GitHub 스타 27,473개, Apache-2.0 라이선스. 설치, 비동기 Python API, Docker, 실제 코드 예제를 다룹니다.'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'assafelovic/gpt-researcher'
stars: 27473
maintainer: 'assafelovic'
last_maintained: '2026-06-02'
featureImage: 'https://contrib.rocks/image?repo=assafelovic/gpt-researcher&max=1000'
draft: false
categories: ['llm-frameworks']
tags: []
aliases:
- /posts/gpt-researcher-llm-frameworks-2026/
faqs:
  - q: 'gpt-researcher는 어떻게 설치하나요?'
    a: 'pip로 Python 패키지를 설치합니다. ```bash pip install gpt-researcher ```'
  - q: '어떤 LLM 제공자와 검색 엔진을 쓸 수 있나요?'
    a: '기본 LLM은 OpenAI, 기본 리트리버는 Tavily이지만, 둘 다 환경 변수와 설정 파일로 교체할 수 있으며, 에이전트는 MCP 기반 출처를 포함한 추가 리트리버도 지원합니다.'
  - q: '실행하려면 API 키가 필요한가요?'
    a: '네. 최소한 프로젝트 루트의 `.env` 파일에 `OPENAI_API_KEY`와 `TAVILY_API_KEY`를 설정해야 합니다. OpenAI 호환 엔드포인트를 쓴다면 `OPENAI_BASE_URL`도 추가하세요.'
  - q: '웹 UI가 포함된 전체 앱은 어떻게 실행하나요?'
    a: '저장소를 클론하고 `docker-compose up --build`를 실행하세요. FastAPI 서버는 `localhost:8000`에서, 프런트엔드는 `localhost:3000`에서 시작됩니다. 서버만 띄우려면 `python -m uvicorn main:app --reload`를 쓰면 됩니다.'
  - q: 'conduct_research()와 write_report()는 동기 방식인가요?'
    a: '아니요. 둘 다 비동기 메서드입니다. async 함수 안에서 `await`로 호출하고, 그 함수를 `asyncio.run()`으로 실행하세요.'
---

{{< resource-info >}}

## 들어가며

대규모 언어 모델(LLM)로 개발해 본 사람이라면 같은 벽에 부딪힌 적이 있을 것입니다. 하나의 질문을 출처가 탄탄하고 사실에 근거한 보고서로 바꾸는 일은 느리고 손이 많이 가는 작업이죠. `assafelovic/gpt-researcher`는 바로 이 과정을 자동화합니다. 웹을 검색하고(로컬 파일도 읽을 수 있습니다) 출처를 모은 뒤, 단 하나의 질의로부터 인용이 달린 리서치 보고서를 작성하는 자율 에이전트입니다. 이 가이드에서는 설치 방법, Python에서 실행하는 법, 그리고 실제 워크플로에 연결하는 법을 살펴봅니다.

![gpt-researcher 개요, via dibi8.com](https://contrib.rocks/image?repo=assafelovic/gpt-researcher&max=1000)

*gpt-researcher 기여자 (출처: assafelovic/gpt-researcher 저장소, dibi8 분석)*

## GPT Researcher란?

GPT Researcher는 스스로를 "어떤 작업이든 웹 및 로컬 리서치를 위해 설계된 최초의 오픈 심층 리서치 에이전트"라고 소개합니다. 질의를 주면 리서치 경로를 계획하고, 여러 차례 검색을 실행하며, 결과를 읽고 걸러낸 뒤, 인용이 포함된 보고서로 종합합니다.

이 프로젝트는 GitHub 스타 2만 7천 개 이상을 보유하고 있으며, `assafelovic`이 Apache-2.0 라이선스로 유지보수하고 있습니다. 기본 브랜치는 `master`입니다.

## GPT Researcher의 동작 방식

내부적으로는 단일 프롬프트가 아니라 '계획-실행' 루프로 작동합니다.

1. **계획**: 질의를 바탕으로 에이전트가 주제를 여러 각도에서 다룰 리서치 하위 질문 집합을 생성합니다.

2. **검색 및 수집**: 각 하위 질문에 대해 리트리버(기본값은 Tavily)에 질의하고 결과 페이지를 스크래핑하여, 관련 있는 단락만 컨텍스트로 보관합니다.

3. **작성**: 취합한 컨텍스트를 다시 LLM에 전달해 보고서를 생성합니다. 리서치 보고서, 자료 목록, 개요는 물론 분량이 더 긴 상세 보고서까지 지원하며, 주제 트리를 탐색하는 심층 리서치(Deep Research) 모드도 있습니다.

설정은 코드에 하드코딩하는 대신 환경 변수와 설정 파일로 이루어지므로, 스크립트를 건드리지 않고도 LLM과 리트리버를 바꿀 수 있습니다.

![gpt-researcher 스타 히스토리, via dibi8.com](https://api.star-history.com/svg?repos=assafelovic/gpt-researcher&type=Date)

*gpt-researcher 스타 히스토리 (출처: assafelovic/gpt-researcher 저장소, dibi8 분석)*

## 설치 및 설정

gpt-researcher를 예약된 프로덕션 작업으로 돌리려면 항상 켜져 있는 서버가 필요합니다. [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 하나 띄우거나(신규 계정은 무료 체험 크레딧 제공), 저지연 홍콩 VPS인 [HTStack](https://my.htstack.com/aff.php?aff=27187)을 선택하세요(dibi8.com을 호스팅하는 것과 같은 IDC입니다).

GPT Researcher를 실행하는 일반적인 방법은 두 가지입니다. 직접 작성한 코드 안에 Python 패키지로 넣는 방식, 또는 Docker로 전체 앱(Python API 서버 + 웹 프런트엔드)을 돌리는 방식입니다.

### pip 사용 (Python 패키지)

먼저 Python이 설치되어 있는지 확인합니다.

```sh
python3 --version
```

그런 다음 패키지를 설치합니다.

```sh
pip install gpt-researcher
```

### .env로 API 키 설정

GPT Researcher는 LLM(기본값 OpenAI)과 검색 리트리버(기본값 Tavily)를 사용합니다. 프로젝트 루트에 `.env` 파일을 만들고 두 키를 모두 넣으세요.

```plaintext
OPENAI_API_KEY=your_openai_key_here
TAVILY_API_KEY=your_tavily_key_here
```

OpenAI 호환 커스텀 엔드포인트를 가리킨다면 `OPENAI_BASE_URL`도 설정합니다. 첫 실행에서 가장 흔한 오류는 키 누락입니다. 인증 오류나 "API key not found" 같은 오류가 보이면, `.env` 파일이 존재하는지, 그리고 researcher를 호출하기 전에 제대로 로드되는지 확인하세요.

### Docker 사용 (프런트엔드 포함 전체 앱)

전체 애플리케이션(FastAPI 서버 + 웹 UI)을 실행하려면 저장소를 클론하고 Docker Compose를 사용합니다.

```sh
git clone https://github.com/assafelovic/gpt-researcher.git
cd gpt-researcher
docker-compose up --build
```

기본적으로 Python 서버는 `localhost:8000`에서, 프런트엔드는 `localhost:3000`에서 시작됩니다.

### Docker 없이 서버 실행

FastAPI 서버를 직접 띄울 수도 있습니다.

```sh
python -m uvicorn main:app --reload
```

그런 다음 브라우저에서 `http://localhost:8000`을 엽니다.

## 핵심 사용법

Python API는 `GPTResearcher` 클래스를 중심으로 구성됩니다. 리서치와 보고서 작성은 모두 **비동기**이므로, async 함수 안에서 `await`로 호출합니다.

### 예제 1: 기본 리서치 보고서

```python
import asyncio
from gpt_researcher import GPTResearcher

async def main():
    query = "why is Nvidia stock going up?"
    researcher = GPTResearcher(query=query)
    # Conduct research: plan, search, scrape, and gather context
    research_result = await researcher.conduct_research()
    # Write the cited report from the gathered context
    report = await researcher.write_report()
    print(report)

asyncio.run(main())
```

### 예제 2: 보고서 유형 선택

`GPTResearcher`는 `report_type` 인자를 받습니다. 덕분에 기본 리서치 보고서 대신 짧은 요약, 자료 목록, 또는 분량이 더 긴 상세 보고서를 요청할 수 있습니다.

```python
import asyncio
from gpt_researcher import GPTResearcher

async def main():
    researcher = GPTResearcher(
        query="What are the latest advancements in natural language processing?",
        report_type="detailed_report",
    )
    await researcher.conduct_research()
    report = await researcher.write_report()
    print(report)

asyncio.run(main())
```

### 예제 3: 수집된 출처 확인

리서치가 끝나면 에이전트가 사용한 기반 컨텍스트와 출처 URL을 꺼낼 수 있습니다. 검수하거나 직접 인용 목록을 만들 때 유용합니다.

```python
import asyncio
from gpt_researcher import GPTResearcher

async def main():
    researcher = GPTResearcher(query="How does AI impact society?")
    await researcher.conduct_research()
    report = await researcher.write_report()

    # Access the sources and context behind the report
    sources = researcher.get_research_sources()
    context = researcher.get_research_context()
    print(f"Used {len(sources)} sources")
    print(report)

asyncio.run(main())
```

이 예제들은 출발점일 뿐입니다. LLM과 리트리버는 설정으로 지정되므로, 같은 코드를 그대로 다른 제공자에서도 실행할 수 있습니다.

## 통합

GPT Researcher는 순수 비동기 라이브러리에 선택적 HTTP 서비스가 더해진 형태이므로, 기존 Python 워크플로에 자연스럽게 들어갑니다.

### LLM 제공자와 리트리버 교체

OpenAI나 Tavily에만 묶이지 않습니다. 기본 LLM은 OpenAI, 기본 리트리버는 Tavily이지만, 둘 다 환경 변수와 설정 파일로 바꿀 수 있습니다. 예를 들어 기본 웹 검색과 MCP 기반 출처를 함께 쓰려면 리트리버 목록을 설정합니다.

```sh
export RETRIEVER=tavily,mcp
```

이 하이브리드 구성은 에이전트가 일반 웹 검색과, 모델 컨텍스트 프로토콜(MCP)을 통한 전문 데이터 소스 양쪽에서 자료를 끌어오게 합니다.

### 노트북이나 서비스 안에서 사용

API가 await 두 번 호출로 끝나기 때문에, GPT Researcher를 Jupyter 노트북, 백그라운드 작업, 또는 FastAPI 엔드포인트에 그대로 넣을 수 있습니다.

```python
import asyncio
from gpt_researcher import GPTResearcher

async def research(topic: str) -> str:
    researcher = GPTResearcher(query=topic)
    await researcher.conduct_research()
    return await researcher.write_report()

report = asyncio.run(research("current trends in AI ethics"))
print(report)
```

더 복잡한 파이프라인을 위해, 저장소에는 LangGraph와 AG2로 구축한 멀티 에이전트 구성도 함께 제공됩니다. 여러 전문 에이전트가 협력해 더 긴 보고서를 만들어 냅니다.

## 벤치마크와 실사용

### 실제 사용 사례

GPT Researcher는 리서치와 보고서 작성에서 가장 느린 부분을 자동화하는 데 쓰입니다.

1. **자동화된 리서치 브리프**: 주제나 제품 아이디어에 대한 초안 보고서를 출처와 함께 생성하여, 손으로 웹을 검색하는 작업을 대체합니다.

2. **문헌·시장 스캔**: 수많은 페이지에 걸쳐 자료를 빠르게 모으고 요약해, 사람이 모든 출처를 읽는 대신 종합 결과를 검토하게 합니다.

3. **사내 도구**: 비동기 API를 사내 서비스로 감싸, 비기술 동료도 질의 하나로 출처가 달린 보고서를 요청할 수 있게 합니다.

### 커뮤니티 신호

README에는 공식 정확도 벤치마크가 공개되어 있지 않으므로, 성능에 관한 어떤 주장이든 직접 자신의 작업에 대고 검증하는 것이 좋습니다. 검증 가능한 것은 커뮤니티의 호응입니다. 2만 7,473개 이상의 GitHub 스타와 활발한 이슈 트래커는 꾸준한 채택과 유지보수를 보여 줍니다. 프로덕션에 의존하기 전에 대표적인 질의로 한 번 돌려 보세요.

## 대안과의 비교

[관련 오픈소스 도구](dibi8-internal-link) 정리도 함께 참고하세요.

GPT Researcher는 '자율 리서치 에이전트' 범주에 속합니다. 경쟁 제품의 수치를 지어내기보다는, 다음과 같이 정직하게 정리해 보겠습니다.

| 항목 | GPT Researcher |
|----------------------|----------------------------------------|
| **스타** | 27,473 |
| **언어** | Python |
| **라이선스** | Apache-2.0 |
| **유지보수자** | Assaf Elovic (`assafelovic`) |
| **초점** | 인용 보고서를 출력하는 웹 + 로컬 심층 리서치 |
| **기본 브랜치** | master |
| **LLM 제공자** | 기본값 OpenAI; 환경 변수/설정으로 교체 가능 |
| **리트리버** | 기본값 Tavily; MCP 및 기타 리트리버 지원 |
| **프런트엔드** | 있음 — 경량 FastAPI UI 및 Next.js + Tailwind 앱 |
| **멀티 에이전트** | 있음 — LangGraph / AG2 멀티 에이전트 파이프라인 |

### 왜 GPT Researcher인가?

- **단순한 답변이 아닌, 엔드 투 엔드 보고서**: 한 줄 채팅 응답이 아니라, 구조화되고 인용이 달린 보고서를 반환합니다.
- **설정 가능한 스택**: LLM과 리트리버를 코드 재작성 없이 교체할 수 있습니다.
- **라이브러리이자 앱**: 직접 작성한 코드에서 비동기 API를 쓰거나, 번들된 서버와 웹 UI를 실행할 수 있습니다.

## 한계와 솔직한 평가

GPT Researcher는 유능하지만, 다음 트레이드오프를 알아 두어야 합니다.

1. **API 비용과 지연**: 실행마다 여러 LLM 호출과 페이지 스크래핑으로 퍼져 나가므로, 심층 또는 상세 보고서는 느릴 수 있고 토큰과 검색 API 비용이 늘어날 수 있습니다.
2. **넓은 설정 범위**: 기본값이 아닌 LLM, 리트리버, 멀티 에이전트 파이프라인을 작동시키려면 문서를 읽고 설정을 조정하는 데 시간이 듭니다.
3. **인터넷 의존성**: 웹 리서치에는 네트워크 접근과 동작하는 검색 API가 필요합니다. 오프라인 사용은 로컬 문서 모드로 제한됩니다.
4. **품질은 모델과 출처에 좌우됨**: 출력은 기반 LLM과 가져온 페이지만큼만 좋으므로, 보고서는 의존하기 전에 여전히 사람의 사실 확인이 필요합니다.
5. **학습 곡선**: 비동기 API 자체는 단순하지만, 보고서 유형, 리트리버, 멀티 에이전트 흐름을 이해하려면 약간의 적응 기간이 필요합니다.

많은 LLM과 검색 호출을 조율하는 에이전트로서는 이 모두가 정상적인 트레이드오프입니다. 프로덕션 파이프라인에 연결하기 전에 알아 둘 만합니다.

## 맺음말

`assafelovic/gpt-researcher`는 계획, 웹 검색, 스크래핑, LLM 작성을 조율하여 하나의 질의를 출처와 구조를 갖춘 보고서로 바꿔 줍니다. 이 모든 것이 작고 단순한 비동기 API 뒤에 숨어 있죠. 2만 7천 개 이상의 스타, Apache-2.0 라이선스, 설정 가능한 LLM/리트리버 스택, 그리고 번들된 웹 앱까지 갖춰, 리서치 자동화의 실용적인 빌딩 블록입니다. 다음 단계: 두 개의 API 키를 설정하고, 실제 질문으로 기본 Python 예제를 돌려 본 뒤, 규모를 키우기 전에 출처를 먼저 확인하세요.

대규모 스크래핑에는 회전 프록시가 필요합니다 — [WebShare](https://www.webshare.io/?referral_code=oa14d5f0wx4f)가 표준적인 선택지입니다.

- 오픈소스 AI 도구 소식을 받아보려면 [dibi8 영어 Telegram 그룹](https://t.me/DIBI8_Group/2)에 참여하세요.
- 다음 읽을거리: [dibi8의 관련 가이드](dibi8-internal-link).

---

**출처 및 더 읽어보기**:
- GitHub 저장소: https://github.com/assafelovic/gpt-researcher
- 공식 문서 / README: https://github.com/assafelovic/gpt-researcher#readme

*위 링크 중 일부는 제휴 링크입니다. 가입하시면 dibi8.com이 수수료를 받을 수 있으며, 추가 비용은 발생하지 않습니다. 사이트 운영과 무료 콘텐츠 유지에 도움이 됩니다.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
