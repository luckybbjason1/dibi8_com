---
title: "Browser Harness：让 LLM 自主操控浏览器的自愈型神器"
description: "Browser Harness는 LLM이 인간처럼 웹을 탐색하고 양식을 작성하고 버튼을 클릭하며 실패한 작업을 자동으로 복구하여 복잡한 작업을 완료할 수 있는 자가 치유형 브라우저 제어 프레임워크입니다."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "1.2 MB"
file_md5: ""
download_url: "https://github.com/browser-use/browser-harness"
backup_url: ""
github_repo: "https://github.com/browser-use/browser-harness"
stars: 13142
maintainer: "browser-use"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
faqs:
  - q: 'Browser Harness란 무엇인가요?'
    a: 'Browser Harness는 대규모 언어 모델(LLM)이 사람이 하는 것처럼 웹 작업을 자율적으로 완료할 수 있게 해주는 자가 치유(self-healing) 브라우저 제어 프레임워크입니다. Python으로 작성되었으며 Playwright와 Selenium을 모두 지원하고, browser-use 팀이 유지 관리합니다.'
  - q: 'Browser Harness의 자가 치유 메커니즘은 어떻게 작동하나요?'
    a: '어떤 작업이 실패하면 Browser Harness는 스크린샷을 찍고, LLM이 문제를 진단하도록 한 뒤, 새로운 전략을 생성하여 재시도합니다. 이 ''감지-분석-재생성-재시도'' 주기를 작업이 성공하거나 완료할 수 없다고 확인될 때까지 반복합니다.'
  - q: 'Browser Harness는 Playwright 및 Selenium과 어떻게 다른가요?'
    a: 'Playwright와 Selenium은 페이지가 바뀌면 깨지고 수동 유지 관리가 필요한 고정된 CSS 선택자나 XPath에 의존합니다. 반면 Browser Harness는 LLM을 사용해 페이지의 의미를 이해하고, 여러 단계의 작업을 자동으로 계획하며, 선택자가 실패하면 스스로 복구합니다. 따라서 각 단계를 코딩하는 대신 목표를 자연어로 기술하면 됩니다.'
  - q: 'Browser Harness는 CAPTCHA와 동적 콘텐츠를 처리할 수 있나요?'
    a: 'Browser Harness는 LLM을 활용해 일부 CAPTCHA를 해결할 수 있고 동적 콘텐츠를 자동으로 기다리지만, 일부 복잡한 CAPTCHA는 여전히 사람의 개입이 필요하다고 글에서 언급하고 있습니다.'
  - q: 'Browser Harness의 주요 한계는 무엇인가요?'
    a: '주요 한계는 비용(LLM API 호출에는 요금이 발생하지만 로컬 모델을 사용할 수 있음), 속도(모델이 추론하는 데 시간이 필요하기 때문에 기존 자동화보다 느림), 안전성(오작동을 방지하기 위해 엄격한 가드레일이 필요함), 그리고 여전히 사람이 필요할 수 있는 복잡한 CAPTCHA입니다.'
---
{</* resource-info */>}

## 문제: 전통적인 크롤러는 죽었고, AI 시대에는 새로운 패러다임이 필요하다

멋진 크롤러 스크립트를 작성했는데 다음 날 웹사이트가 개편되어 모두 작동하지 않습니다. 선택기를 수정했는데 일주일 후 CDN 경로가 바뀌어 또 작동하지 않습니다. 예외 처리를 추가했지만 캡차가 나타나 완전히 멈춰 버립니다.

**전통적인 웹 자동화에는 세 가지 치명적인 약점이 있습니다:**

1. **취약성** — 페이지 구조가 조금만 바뀌어도 스크립트가 모두 중단됩니다
2. **정적성** — 예측된 흐름만 실행할 수 있고 예상치 못한 상황에 대응할 수 없습니다
3. **수동성** — 캡차, 팝업, 로딩 실패에 막히면 속수무책입니다

**인간처럼 웹을 탐색하는** 자동화 방식이 필요합니다 — 페이지를 보고 의도를 이해하고 스스로 복구할 수 있는 방식입니다.

## Browser Harness란 무엇인가?

[Browser Harness](https://github.com/browser-use/browser-harness)는 **자가 치유형 브라우저 제어 프레임워크**로, LLM(대규모 언어 모델)이 인간처럼 자율적으로 모든 웹 작업을 완료할 수 있게 합니다.

- GitHub에서 **11,251+ Stars**
- **1,019+ Forks**
- **Python**으로 작성
- **Playwright** 및 **Selenium** 지원
- **browser-use** 팀이 유지 관리

핵심 슬로건: **"Self-healing harness that enables LLMs to complete any task."**

## 핵심 기능

### 1. 자가 치유(Self-Healing)

전통적인 자동화:
```python
# 취약한 선택기, 페이지가 변경되면 작동하지 않음
button = driver.find_element(By.CSS_SELECTOR, "#submit-btn")
button.click()
```

Browser Harness:
```python
# LLM이 페이지 의미를 이해하고 올바른 버튼을 자동으로 찾음
# ID가 변경되어도 맥락을 통해 이해 가능
result = harness.execute("제출 버튼 클릭")
# 버튼을 찾을 수 없으면 LLM이 페이지를 분석하고 대안을 제시
```

**자가 치유 메커니즘**:
- 작업 실패 → 스크린샷 분석 → LLM 진단 → 새 전략 생성 → 재시도
- 성공하거나 완료할 수 없음을 확인할 때까지 반복

### 2. 의미론적 이해(Semantic Understanding)

Browser Harness는 CSS 선택기에 의존하지 않고 LLM이 **페이지 콘텐츠를 이해**하도록 합니다:

```python
# LLM에 목표를 알려주고 단계는 알려주지 않음
harness.execute("Amazon에서 무선 이어폰을 검색하고, 평점순으로 정렬한 후 첫 번째 결과를 장바구니에 담아줘")

# LLM이 자동으로:
# 1. 검색 상자 찾기
# 2. "wireless headphones" 입력
# 3. 정렬 드롭다운 메뉴 찾기
# 4. "Customer Reviews" 선택
# 5. 첫 번째 상품 찾기
# 6. "Add to Cart" 클릭
```

### 3. 다단계 작업 계획

```python
from browser_harness import Harness

harness = Harness(model="gpt-4o")

# 복잡한 다단계 작업
task = """
다음 주 수요일 베이징에서 상하이로 가는 항공권을 예약해줘,
요구사항:
- 오전 출발
- 가격 1000위안 미만
- 중국동방항공 또는 중국국제항공
- 수하물 불필요
"""

result = harness.execute(task)
# LLM이 단계를 계획:
# 1. Ctrip/Qu哪儿 열기
# 2. 편도 선택
# 3. 베이징 → 상하이 입력
# 4. 다음 주 수요일 날짜 선택
# 5. 오전 항공편 필터링
# 6. 가격순 정렬
# 7. 중국동방항공/중국국제항공 필터링
# 8. 수하물 없는 운임 선택
# 9. 승객 정보 입력
# 10. 주문 제출
```

### 4. 시각적 인식(Visual Perception)

Browser Harness는 LLM에 페이지 스크린샷을 보내 웹페이지를 "보게" 합니다:

```python
# 스크린샷 분석
screenshot = harness.screenshot()
analysis = harness.llm.analyze_image(screenshot, 
    "이 페이지에 어떤 양식이 있나요? 각 입력 상자의 레이블과 유형을 설명해주세요")

# LLM 반환:
# "페이지에 로그인 양식이 있습니다:
#  - 사용자 이름 입력 상자(type=text)
#  - 비밀번호 입력 상자(type=password)
#  - 나를 기억하기 체크박스
#  - 로그인 버튼"
```

### 5. 기존 도구와의 비교

| 기능 | Browser Harness | Playwright | Selenium | Scrapy |
|------|----------------|-----------|----------|--------|
| **자가 치유** | ✅ 자동 복구 | ❌ 수동 유지보수 | ❌ 수동 유지보수 | ❌ 수동 유지보수 |
| **의미론적 이해** | ✅ LLM 기반 | ❌ 선택기 | ❌ 선택기 | ❌ XPath |
| **다단계 계획** | ✅ 자동 계획 | ⚠️ 코딩 필요 | ⚠️ 코딩 필요 | ⚠️ 코딩 필요 |
| **캡차 처리** | ✅ LLM으로 해결 | ❌ 타사 필요 | ❌ 타사 필요 | ❌ 타사 필요 |
| **동적 콘텐츠** | ✅ 자동 대기 | ⚠️ 구성 필요 | ⚠️ 구성 필요 | ⚠️ 구성 필요 |
| **학습 곡선** | 낮음(자연어) | 중간 | 중간 | 높음 |

## 아키텍처 설계

```
Browser Harness
├── LLM Core (GPT-4o / Claude / Local LLM)
├── Browser Controller (Playwright / Selenium)
├── Self-Healing Engine
│   ├── Error Detection
│   ├── Screenshot Analysis
│   ├── Strategy Regeneration
│   └── Retry Logic
├── Task Planner
│   ├── Goal Decomposition
│   ├── Step Sequencing
│   └── Dependency Resolution
└── Safety Guardrails
    ├── URL Whitelist
    ├── Action Limits
    └── Human-in-the-Loop
```

## 설치 및 사용

### 설치

```bash
pip install browser-harness

# 브라우저 의존성 설치
playwright install
```

### 기본 사용법

```python
from browser_harness import Harness

# 초기화
harness = Harness(
    model="gpt-4o",  # 또는 "claude-3-5-sonnet"
    browser="chromium",
    headless=False   # 디버깅을 위해 가시 모드
)

# 간단한 작업 실행
result = harness.execute("Google을 열어 'Python tutorial' 검색")

# 복잡한 작업 실행
task = """
1. github.com 방문
2. 'browser-use/browser-harness' 검색
3. Star 버튼 클릭
4. star 수 반환
"""
result = harness.execute(task)
print(result)  # "현재 Stars: 11251"
```

### 고급 구성

```python
from browser_harness import Harness, Config

config = Config(
    max_retries=3,           # 최대 재시도 횟수
    retry_delay=2,           # 재시도 간격(초)
    screenshot_on_error=True, # 오류 시 스크린샷
    human_in_the_loop=True,   # 중요 작업은 사람 확인
    url_whitelist=[           # URL 화이트리스트
        "*.github.com",
        "*.google.com"
    ]
)

harness = Harness(model="gpt-4o", config=config)
```

## 실제 응용 시나리오

### 시나리오 1: 자동화 테스트

```python
# LLM이 웹사이트를 테스트하도록 하기
test_cases = [
    "새 사용자를 등록하고 확인 이메일을 수신했는지 검증",
    "상품을 장바구니에 추가하고 총액 계산이 정확한지 확인",
    "필수 항목을 비워두고 양식을 제출하면 오류 메시지가 표시되는지 검증"
]

for test in test_cases:
    result = harness.execute(test)
    assert result.success, f"테스트 실패: {test}"
```

### 시나리오 2: 데이터 수집

```python
# 지능형 크롤러, 웹사이트 변경에 자동 적응
data = harness.execute("""
example.com/products를 방문하여
모든 제품의 다음 정보를 추출:
- 이름
- 가격
- 평점
- 재고 상태
JSON으로 저장
""")
```

### 시나리오 3: 업무 자동화

```python
# 일상적인 웹 작업 자동 처리
harness.execute("""
1. 회사 비용 처리 시스템에 로그인
2. 지난달 출장 비용 신청서 제출
3. 영수증 PDF 업로드
4. 승인자 입력
5. 신청 제출
""")
```

### 시나리오 4: 경쟁사 모니터링

```python
# 매일 경쟁사 가격 확인
harness.execute("""
amazon.com을 방문하여 우리 핵심 제품 키워드를 검색하고,
상위 10개 결과의 가격과 평점을 기록하고,
비교 보고서를 생성
""")
```

## 유사 프로젝트 비교

| 프로젝트 | Stars | 특징 | 적용 시나리오 |
|------|-------|------|---------|
| **Browser Harness** | 11K+ | 자가 치유, LLM 기반 | 일반 웹 작업 |
| **Playwright** | 66K+ | 고성능, 다중 브라우저 | 자동화 테스트 |
| **Selenium** | 30K+ | 성숙하고 안정적 | 전통적 자동화 |
| **Scrapy** | 52K+ | 대규모 크롤링 | 데이터 수집 |
| **Crawl4AI** | 8K+ | AI 크롤러 | 콘텐츠 추출 |

## 한계

- **비용** — LLM API 호출에 비용이 발생합니다(로컬 모델 사용 가능)
- **속도** — 전통적인 자동화보다 느립니다(생각하는 데 시간이 필요)
- **보안** — 오동작을 방지하기 위해 엄격한 보안 정책이 필요합니다
- **복잡한 캡차** — 일부 캡차는 여전히 사람의 개입이 필요합니다

## 결론

Browser Harness는 **웹 자동화의 새로운 패러다임**을 대표합니다 — "하드코딩된 선택기"에서 "이해하는 에이전트"로.

- 자가 치유 기능으로 유지보수 비용을 크게 절감합니다
- 자연어 인터페이스로 사용 문턱을 낮춥니다
- LLM의 추론 능력으로 복잡한 흐름을 처리합니다
- 시각적 인식으로 전통적 자동화의 사각지대를 해결합니다

매주 충돌하는 크롤러 스크립트를 수정하는 것에 지쳤다면 Browser Harness를 시도해 볼 가치가 있습니다.

**GitHub**: [browser-use/browser-harness](https://github.com/browser-use/browser-harness)  
**Stars**: 11,251+ | **언어**: Python | **라이선스**: 오픈소스

## 관련 기사

- [Hermes Agent: 자기 개선하는 AI 에이전트](/kr/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)
- [Agent Reach: AI 에이전트에 인터넷 슈퍼파워 부여하기](/kr/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

## 추천 도구

**안정적인 Claude / OpenAI API 액세스가 필요?** 이 분야 프로젝트는 결국 Anthropic / OpenAI 레이트 리밋이나 가격 벽에 부딪힙니다.

- **{{< aff "shiyunapi" "llm-footer" "Shiyunapi" >}}** — Claude / OpenAI / DeepSeek API 프록시. 키 하나로 여러 최상위 모델 액세스, 공식 가격의 ~30%; 에이전트 프롬프트 이터레이션이나 직접 API 액세스 제한 지역에서 특히 유용.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

