---
title: 'Browser Use: 94K+ Stars — 2026년 AI 브라우저 자동화 벤치마크 및 실전 가이드'
description: 'Browser Use는 Playwright를 통해 LLM을 실제 브라우저에 연결하는 오픈소스 Python 프레임워크입니다. OpenAI, Anthropic, Gemini 및 로컬 모델을 지원합니다. 설치, WebVoyager 벤치마크, Selenium 비교, 프로덕션 하드닝, Docker 배포를 다룹니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/browser-use/browser-use'
stars: 94731
maintainer: 'browser-use'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['browser-use', 'ai-에이전트', 'playwright', '브라우저-자동화', '웹-크롤링', '대형언어모델', 'python', '오픈소스']
aliases:
- /kr/posts/browser-use/
---

{{</* resource-info */>}}

![Browser Use Logo](https://raw.githubusercontent.com/browser-use/browser-use/main/docs/static/img/browser-use-logo.png)

> **GitHub**: [browser-use/browser-use](https://github.com/browser-use/browser-use) | **Stars**: 94,731 | **License**: MIT | **Version**: 0.12.7

---

## 소개

현대 웹 자동화를 위해 Selenium 스크립트를 작성하고 유지보수하는 것은 수천 개의 셀렉터에 의해 천천히 죽어가는 것과 같습니다. 클래스명이 바뀌고, 버튼 위치가 이동하면, 새벽 3시에 전체 파이프라인이 붕괴합니다. 2024년 말 Magnus Müller와 Gregor Žunič이 출시한 Browser Use는 완전히 다른 접근법을 취합니다: 브라우저 제어권을 대규모 언어 모델에 넘기고, AI가 무엇을 클릭하고, 입력하고, 읽을지 스스로 판단하게 합니다. 94,731개의 GitHub Star, 319명의 기여자, WebVoyager 벤치마크 89.1% 성공률을 기록하며 Browser Use는 AI 기반 브라우저 자동화의 사실상 오픈소스 표준이 되었습니다. 본 튜토리얼에서는 설치 방법, 실제 벤치마크 데이터, 주요 LLM과의 연동, 그리고 Selenium, Puppeteer, Scrapy와의 직접 비교를 다룹니다.

---

## Browser Use란?

Browser Use는 Python 3.11 이상에서 LangChain 호환 LLM을 Playwright를 통해 실제 브라우저에 연결하는 라이브러리입니다. CSS 셀렉터나 XPath 표현식을 하드코딩하는 대신 자연어로 작업을 설명합니다 — "다음 주 금요일 NYC에서 SFO로 가장 저렴한 항공편 찾기" — 그러면 에이전트가 자율적으로 탐색, 양식 작성, 클릭, 데이터 추출을 수행합니다.

### 핵심 설계 원칙

- **모델 무관성**: OpenAI GPT-4o/5.1, Anthropic Claude Sonnet 4, Google Gemini 3 Flash, LiteLLM을 통한 로컬 모델 지원.
- **DOM 정제**: 페이지를 LLM에 전송하기 전에 필수 상호작용 요소만 남겨 토큰 소비를 최대 60% 절감.
- **다중 탭 지원**: 에이전트가 동시에 여러 브라우저 탭에서 작업 가능.
- **지속적 메모리**: 탐색 단계 간 컨텍스트와 대화 기록 유지.
- **Playwright 기반**: 스텔스 모드, 프록시 지원, 네트워크 가로채기, 비디오 녹화 등 Playwright의 모든 기능 상속.

---

## Browser Use 작동 방식

Browser Use는 **관찰 → 계획 → 실행 → 검증** 루프를 지속적으로 실행합니다:

### 아키텍처 개요

```
┌─────────────┐    DOM + 스크린샷      ┌─────────────┐
│   브라우저   │ ─────────────────────> │     LLM     │
│ (Playwright)│                        │(Claude/GPT/)│
│             │ <───────────────────── │   Gemini    │
└─────────────┘     동작 (클릭/입력)    └─────────────┘
      ↑                                       │
      └────────── 페이지 상태 변경 ────────────┘
```

![Browser Use Agent Loop Architecture](https://raw.githubusercontent.com/browser-use/browser-use/main/docs/static/img/agent-loop-diagram.png)

### 에이전트 루프 상세

1. **캡처**: Browser Use가 현재 페이지의 DOM 스냅샷과 스크린샷을 촬영합니다.
2. **정제**: DOM에서 상호작용 요소(버튼, 입력창, 링크)만 필터링하여 노이즈를 제거합니다.
3. **추론**: LLM이 정제된 페이지 상태와 사용자 목표를 받아 다음 동작을 계획합니다.
4. **실행**: Browser Use가 LLM의 결정을 Playwright API 호출(`page.click()`, `page.fill()`)로 변환합니다.
5. **검증**: 작업이 완료되거나 `max_steps`에 도달할 때까지 루프가 반복됩니다.

```python
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI
import asyncio

async def main():
    browser = Browser()
    agent = Agent(
        task="Find the number of stars of the browser-use repo",
        llm=ChatOpenAI(model="gpt-4.1"),
        browser=browser,
    )
    result = await agent.run()
    print(result)

if __name__ == "__main__":
    asyncio.run(main())
```

---

## 설치 및 설정

### 사전 요구사항

- Python 3.11 이상
- Playwright 호환 브라우저 (Chromium 권장)
- 선택한 LLM 공급자의 API 키

### 1단계: Browser Use 설치

```bash
# uv 사용 (권장)
uv init
uv add browser-use
uv sync

# pip 사용
pip install browser-use

# Chromium 설치 (미설치 시)
playwright install chromium
```

### 2단계: 환경 변수 설정

```bash
# .env 파일
OPENAI_API_KEY=sk-your-openai-key
ANTHROPIC_API_KEY=sk-ant-your-anthropic-key
GOOGLE_API_KEY=your-google-api-key

# 선택: Browser Use Cloud 스텔스 브라우저
BROWSER_USE_API_KEY=your-cloud-key
```

### 3단계: 첫 에이전트 실행

```python
import asyncio
from browser_use import Agent, Browser, ChatBrowserUse

async def main():
    browser = Browser()
    agent = Agent(
        task="List the top 20 posts on Hacker News today with their points",
        llm=ChatBrowserUse(),
        browser=browser,
    )
    result = await agent.run()
    print(result.output)

if __name__ == "__main__":
    asyncio.run(main())
```

![Browser Use Quick Start Interface](https://docs.browser-use.com/assets/images/quickstart-browser-use-cloud.png)

### Docker 배포 (프로덕션)

```dockerfile
# Dockerfile
FROM python:3.11-slim

WORKDIR /app
RUN pip install browser-use playwright
RUN playwright install chromium
RUN playwright install-deps

COPY . .
CMD ["python", "agent.py"]
```

```yaml
# docker-compose.yml
version: '3.8'
services:
  browser-use:
    build: .
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
    volumes:
      - ./scripts:/app
    command: python agent.py
```

---

## 인기 도구와의 연동

### OpenAI GPT-4o / GPT-5.1

```python
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI
import asyncio

async def search_flights():
    agent = Agent(
        task="Find the cheapest flight from NYC to London next week",
        llm=ChatOpenAI(model="gpt-4o", temperature=0),
        browser=Browser(),
    )
    return await agent.run()

asyncio.run(search_flights())
```

### Anthropic Claude Sonnet 4

```python
from browser_use import Agent, Browser
from langchain_anthropic import ChatAnthropic
import asyncio

async def extract_data():
    agent = Agent(
        task="Extract all pricing plans from example.com/pricing",
        llm=ChatAnthropic(model="claude-sonnet-4-6"),
        browser=Browser(),
    )
    result = await agent.run()
    print(result.output)

asyncio.run(extract_data())
```

### Google Gemini 3 Flash

```python
from browser_use import Agent, Browser
from langchain_google_genai import ChatGoogleGenerativeAI
import asyncio

async def research_topic():
    agent = Agent(
        task="Research the latest AI news and summarize top 5 stories",
        llm=ChatGoogleGenerativeAI(model="gemini-3-flash-preview"),
        browser=Browser(),
    )
    return await agent.run()

asyncio.run(research_topic())
```

### Ollama (로컬 모델)

```python
from browser_use import Agent, Browser
from langchain_ollama import ChatOllama
import asyncio

async def local_automation():
    agent = Agent(
        task="Fill out the contact form on example.com/contact",
        llm=ChatOllama(model="qwen2.5:72b"),
        browser=Browser(),
    )
    return await agent.run()

asyncio.run(local_automation())
```

### Playwright 직접 연동

```python
from playwright.async_api import async_playwright
from browser_use import Agent
from langchain_openai import ChatOpenAI

async def hybrid_automation():
    async with async_playwright() as p:
        browser = await p.chromium.launch(headless=True)
        page = await browser.new_page()
        
        # 결정적 Playwright 단계
        await page.goto("https://example.com")
        
        # 복잡한 작업을 Browser Use 에이전트에 위임
        agent = Agent(
            task="Navigate to pricing and extract all plan details",
            llm=ChatOpenAI(model="gpt-4o"),
            browser=browser,
        )
        result = await agent.run()
        await browser.close()
        return result
```

---

## 벤치마크 / 실전 활용 사례

### WebVoyager 벤치마크 결과

WebVoyager 벤치마크는 586개의 실제 웹 작업으로 브라우저 에이전트를 평가합니다. Browser Use는 89.1% 성공률로 전체 리더보드 7위 — 완전 오픈소스 프레임워크 중 최고 순위입니다.

![WebVoyager Leaderboard showing Browser Use at 89.1%](https://docs.browser-use.com/assets/images/webvoyager-benchmark-2026.png)

| 순위 | 시스템 | 점수 | 조직 |
|------|--------|------|------|
| 1 | Alumnium | 98.6% | Alumnium |
| 2 | Surfer 2 | 97.1% | H Company |
| 3 | Magnitude | 93.9% | Magnitude |
| 4 | AIME Browser-Use | 92.34% | Aime |
| 6 | Browserable | 90.4% | Browserable |
| **7** | **Browser Use** | **89.1%** | **Browser Use** |
| 8 | GLM-5V-Turbo | 88.5% | Z.ai |
| 9 | Agent Kura | 87.0% | Kura |
| 9 | OpenAI Operator | 87% | OpenAI |
| 11 | Skyvern 2.0 | 85.85% | Skyvern |
| 12 | Project Mariner | 83.5% | Google |

### 성능 지표 (기존 도구와 비교)

| 지표 | Browser Use (AI) | Playwright | Puppeteer | Selenium |
|------|-----------------|-----------|-----------|----------|
| 첫 탐색까지 콜드 스타트 | ~0.5–0.8s | ~0.4–0.7s | ~0.3–0.5s | ~1.2–2.5s |
| 유휴 메모리 (인스턴스당) | ~100–150MB | ~90–130MB | ~60–100MB | ~180–280MB |
| 정적 페이지/분 | ~8–15 (AI 루프) | ~35–55 | ~40–60 | ~18–35 |
| 새로운 사이트 성공률 | 89.1% | N/A | N/A | N/A |
| 셀렉터 유지비용 | 없음 | 높음 | 높음 | 높음 |
| LLM 비용 (10단계 작업당) | $0.02–$0.30 | $0 | $0 | $0 |

### 실제 비용 분석

| LLM 공급자 | 작업당 비용 (평균 10단계) | 적합한 시나리오 |
|-----------|------------------------|---------------|
| GPT-4o | ~$0.15–$0.30 | 복잡한 추론 작업 |
| Claude Sonnet 4 | ~$0.10–$0.20 | 프로덕션 안정성 |
| Gemini 3 Flash | ~$0.02–$0.05 | 비용 민감 배치 작업 |
| 로컬 (Qwen2.5-72B) | ~$0.005 (GPU 비용) | 프라이버시 우선 배포 |

### 활용 사례: 자동화 가격 모니터링

```python
import asyncio
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI

async def monitor_prices():
    urls = [
        "https://amazon.com/dp/B0DHTYW7P5",
        "https://bestbuy.com/site/xyz",
        "https://newegg.com/product/abc",
    ]
    
    results = []
    for url in urls:
        agent = Agent(
            task=f"Go to {url} and extract the current price, availability, and seller name",
            llm=ChatOpenAI(model="gpt-4o-mini"),
            browser=Browser(),
        )
        result = await agent.run()
        results.append({"url": url, "data": result.output})
    
    return results

# cron 또는 예약 작업으로 매일 실행
prices = asyncio.run(monitor_prices())
```

---

## 고급 사용법 / 프로덕션 하드닝

### 병렬 에이전트 실행

```python
import asyncio
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI

async def run_parallel_agents(tasks):
    browser = Browser()
    agents = [
        Agent(task=task, llm=ChatOpenAI(model="gpt-4o-mini"), browser=browser)
        for task in tasks
    ]
    results = await asyncio.gather(*[agent.run() for agent in agents])
    return results

tasks = [
    "Find iPhone 16 price on Amazon",
    "Find iPhone 16 price on Best Buy",
    "Find iPhone 16 price on Apple Store",
]

results = asyncio.run(run_parallel_agents(tasks))
```

### 스크래핑용 프록시 구성

```python
from browser_use import Browser, BrowserConfig
from browser_use import Agent
from langchain_openai import ChatOpenAI

config = BrowserConfig(
    proxy={
        "server": "http://proxy.example.com:8080",
        "username": "user",
        "password": "pass",
    },
    headless=True,
)

browser = Browser(config=config)
agent = Agent(
    task="Extract data from a geo-restricted site",
    llm=ChatOpenAI(model="gpt-4o"),
    browser=browser,
)
```

### 세션 지속성 및 인증

```python
from browser_use import Browser, BrowserConfig, Agent
from langchain_openai import ChatOpenAI

# 영구 브라우저 프로필을 사용하여 Cookie와 로그인 상태 유지
config = BrowserConfig(
    user_data_dir="./browser_profile",
    headless=False,  # 초기 로그인에 헤드 모드 사용
)

async def authenticated_task():
    browser = Browser(config=config)
    agent = Agent(
        task="Download my monthly invoice from the billing page",
        llm=ChatOpenAI(model="gpt-4o"),
        browser=browser,
    )
    return await agent.run()
```

### 오류 처리 및 재시도

```python
import asyncio
from browser_use import Agent, Browser
from langchain_openai import ChatOpenAI

async def robust_agent(task, max_retries=3):
    for attempt in range(max_retries):
        try:
            agent = Agent(
                task=task,
                llm=ChatOpenAI(model="gpt-4o"),
                browser=Browser(),
                max_steps=25,  # 무한 루프 방지를 위한 단계 제한
            )
            result = await agent.run()
            if result.success:
                return result
        except Exception as e:
            print(f"Attempt {attempt + 1} failed: {e}")
            await asyncio.sleep(2 ** attempt)  # 지수 백오프
    raise Exception(f"Task failed after {max_retries} attempts")
```

### Prometheus 모니터링 통합

```python
from prometheus_client import Counter, Histogram, start_http_server
from browser_use import Agent, Browser

agent_runs = Counter("browseruse_agent_runs_total", "Total agent runs")
agent_failures = Counter("browseruse_agent_failures_total", "Total agent failures")
agent_duration = Histogram("browseruse_agent_duration_seconds", "Agent run duration")

start_http_server(8000)

async def monitored_agent(task):
    agent_runs.inc()
    with agent_duration.time():
        try:
            agent = Agent(task=task, llm=llm, browser=Browser())
            result = await agent.run()
            return result
        except Exception:
            agent_failures.inc()
            raise
```

---

## 대안과의 비교

| 기능 | Browser Use | Scrapy | Puppeteer | Selenium |
|------|-------------|--------|-----------|----------|
| **프로그래밍 언어** | Python | Python | JavaScript/TypeScript | Python, Java, C#, JS |
| **AI 네이티브** | 예 (LLM 기반) | 아니오 | 아니오 | 아니오 |
| **JavaScript 렌더링** | 예 (Playwright 통해) | 아니오 (Splash/Playwright 필요) | 예 (Chromium) | 예 (모든 브라우저) |
| **셀렉터 유지보수** | 없음 (AI 시각) | 높음 (XPath/CSS) | 높음 (CSS) | 높음 (XPath/CSS) |
| **다중 브라우저 지원** | Chromium, Firefox, WebKit | N/A | Chromium만 | Chrome, Firefox, Safari, Edge |
| **WebVoyager 성공률** | 89.1% | N/A | N/A | N/A |
| **속도 (페이지/분)** | ~8–15 | ~200+ (정적) | ~40–60 | ~18–35 |
| **설정 복잡도** | 낮음 (pip install) | 중간 | 낮음 (npm) | 높음 (WebDriver) |
| **1K 작업당 비용** | $20–$300 (LLM) | 물음 (인프라만) | 물음 (인프라만) | 물음 (인프라만) |
| **적합한 시나리오** | AI 에이전트, 복잡한 작업 | 대규모 정적 페이지 크롤링 | Chrome 자동화, 테스트 | 크로스 브라우저 테스트, 레거시 |
| **GitHub Stars** | 94,731 | 54,200 | 90,800 | 25,400 |

### 선택 가이드

- **Browser Use**: 셀렉터 작성이 비실용적인 동적 사이트에서 복잡한 다단계 작업. UI 변경에 적응해야 하는 AI 에이전트.
- **Scrapy**: 대규모 정적 HTML 페이지 추출. 구조화된 크롤링에 최적.
- **Puppeteer**: 속도가 중요하고 대상 사이트를 제어하는 Chrome 전용 자동화. PDF 생성 및 스크린샷에 이상적.
- **Selenium**: 엄격한 브라우저 커버리지가 필요한 엔터프라이즈 애플리케이션의 크로스 브라우저 테스트.

---

## 한계 / 객관적 평가

Browser Use는 전통적인 브라우저 자동화의 만능 대체재가 아닙니다. 다음 시나리오에는 적합하지 않습니다:

1. **고용량 저비용 크롤링**: LLM 비용이 작업당 $0.02–$0.30이므로 10만 페이지 크롤링에 $2,000–$30,000 소요. Scrapy + HTTP 요청은 정적 사이트에서 동일한 볼륨에 몇 센트만 소요.

2. **결정적 테스트**: AI 에이전트는 비결정적입니다. 동일한 작업도 실행마다 다른 경로를 탈 수 있습니다. 100% 재현성이 필요한 CI/CD 테스트에는 Playwright나 Selenium을 사용하세요.

3. **실시간 애플리케이션**: 각 동작에 LLM 추론 호출이 필요합니다(2–5초). 현재 에이전트 루프 아키텍처로는 1초 미만 응답 요구사항을 충족할 수 없습니다.

4. **단순하고 안정적인 사이트**: 대상 사이트가 절대 변경되지 않고 셀렉터가 명확하다면, 기존 자동화가 더 빠르고 저렴하고 안정적입니다.

5. **LLM 의존성**: 서드파티 LLM API의 가용성과 가격에 의존합니다. 속도 제한이 프로덕션 워크로드의 병목이 될 수 있습니다.

---

## 자주 묻는 질문

### Browser Use는 무엇에 사용되나요?
Browser Use는 Playwright를 통해 LLM이 브라우저를 제어하는 Python 프레임워크입니다. 양식 작성, 데이터 추출, 가격 모니터링, 다단계 웹 워크플로우 등 기존 셀렉터 기반 자동화가 취약하거나 비실용한 AI 기반 웹 자동화에 사용됩니다.

### Browser Use와 Selenium을 어떻게 비교하나요?
Browser Use는 셀렉터 유지보수가 필요 없고(AI가 페이지를 읽음), 동적 UI를 네이티브로 처리하며, WebVoyager에서 89.1% 성공률을 기록합니다. Selenium은 단순 작업에서 더 빠르고(~18–35 페이지/분 vs ~8–15), 더 많은 브라우저를 지원하며, 작업당 LLM 비용이 없습니다. 크로스 브라우저 테스트에는 Selenium을, 복잡한 AI 작업에는 Browser Use를 사용하세요.

### Browser Use는 어떤 LLM을 지원하나요?
LangChain 호환 LLM 모두: OpenAI GPT-4o/5.1, Anthropic Claude Sonnet 4, Google Gemini 3 Flash, Ollama를 통한 로컬 모델(Qwen2.5, Llama 3, Mistral). 프레임워크는 LiteLLM을 통해 모델 무관입니다.

### Browser Use의 비용은 얼마인가요?
프레임워크 자체는 물음(MIT 라이선스). LLM API 사용료가 작업당 약 $0.02–$0.30입니다. Browser Use Cloud는 관리형 스텔스 브라우저를 월 $29부터 제공합니다.

### Docker에서 Browser Use를 실행할 수 있나요?
예. Python 3.11+ 컨테이너에 `browser-use`와 `playwright`를 설치하고, `playwright install chromium`을 실행한 후 환경 변수로 API 키를 설정하세요. 위 설치 섹션에 Dockerfile 예제가 제공됩니다.

### Browser Use는 CAPTCHA를 해결하나요?
Browser Use는 기본적으로 CAPTCHA를 해결하지 않습니다. 보호된 사이트에는 Browser Use Cloud(내장 CAPTCHA 해결)를 사용하거나, 2Captcha나 CapSolver 같은 전용 CAPTCHA 서비스를 통합하세요.

### Browser Use에서 인증은 어떻게 처리하나요?
영구 브라우저 프로필(`BrowserConfig`의 `user_data_dir`)을 사용하여 세션 간 Cookie와 로그인 상태를 유지합니다. OAuth나 2FA 흐름은 초기 로그인에 헤드 모드를 사용하고, 이후 작업은 헤드리스로 전환합니다.

### Browser Use와 Stagehand의 차이점은 무엇인가요?
Browser Use는 완전히 자율적인 에이전트 프레임워크 — LLM이 모든 탐색 결정을 제어합니다. Stagehand(Browserbase 개발)는 Playwright 위에 AI 원시 함수(`act()`, `extract()`, `observe()`)를 추가하여 결정적 단계와 AI 기반 단계가 공존하는 하이브리드 워크플로우에 적합합니다. 완전 자율에는 Browser Use를, 기존 Playwright 스크립트의 정밀 AI 강화에는 Stagehand를 선택하세요.

---

## 결론

Browser Use는 94,731개의 GitHub Star를 통해 진정한 문제를 해결했습니다: 현대적이고 끊임없이 변화하는 웹사이트에서 브라우저 자동화 스크립트를 유지보수하는 어려움입니다. 89.1%의 WebVoyager 성공률, 모델 무관 설계, Playwright 기반으로 Browser Use는 2026년 AI 기반 웹 자동화의 최고 오픈소스 선택지입니다.

이 프레임워크에는 트레이드오프가 있습니다 — 대규모에서 LLM 비용이 누적되며, 결정적 테스트는 Selenium과 Playwright의 영역입니다. 그러나 임의의 웹사이트를 탐색하고, 양식을 작성하고, 데이터를 추출하고, 인간의 개입 없이 UI 변경에 적응해야 하는 AI 에이전트를 구축하는 팀에게 Browser Use는 현재 가장 성숙한 오픈소스 옵션입니다.

> **더 많은 AI 자동화 튜토리얼이 필요하신가요?** [Telegram 그룹](https://t.me/dibi8opensource)에 참여하여 오픈소스 AI 도구 주간 심층 분석, 프로덕션 배포 팁 및 벤치마크 데이터를 받아보세요.

**실행 목록**:
1. [browser-use/browser-use](https://github.com/browser-use/browser-use) 저장소 클론
2. `pip install browser-use` 실행 후 위 예제로 첫 에이전트 구성
3. 자신의 사용 사례에 맞게 WebVoyager 벤치마크 평가
4. [Browser Use Discord](https://link.browser-use.com/discord)에 참여하여 커뮤니티 지원과 프로덕션 팁 얻기

---



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 확장 읽기

- [Browser Use GitHub 저장소](https://github.com/browser-use/browser-use)
- [Browser Use 공식 문서](https://docs.browser-use.com)
- [Browser Use Cloud 플랫폼](https://cloud.browser-use.com)
- [WebVoyager 벤치마크 리더보드](https://leaderboard.steel.dev/)
- [Playwright vs Puppeteer vs Selenium 2026 벤치마크](https://use-apify.com/blog/playwright-vs-puppeteer-vs-selenium-2026)
- [2026 AI 브라우저 자동화 도구 비교](https://awesomeagents.ai/tools/best-ai-browser-automation-tools-2026/)
- [Browser Use 프록시 설정 가이드](https://www.coronium.io/blog/browser-use-proxy-setup)
- [Stagehand vs Browser Use vs Playwright 비교](https://www.nxcode.io/resources/news/stagehand-vs-browser-use-vs-playwright-ai-browser-automation-2026)

---

*본 문서는 프로덕션급 브라우저 자동화가 필요한 개발자를 대상으로 합니다. 모든 벤치마크 데이터는 공개 리더보드와 2026년 5월 독립 테스트에서 가져왔습니다.*
