---
title: 'perplexity-api-rag-search'
description: '{''en'': ''Learn how to build RAG-enhanced search applications using the Perplexity API. Covers Sonar models, real-time web citations, streaming, and production integration patterns.'', ''zh'': ''学习如何使用Perplexity API构建RAG增强搜索应用。涵盖Sonar模型、实时网络引用、流式传输和生产集成模式。'', ''ko'': ''Perplexity API를 사용하여 RAG 강화 검색 애플리케이션을构建하는 방법을 알아보세요. Sonar 모델, 실시간 웹 인용, 스트리밍 및 프로덕션 통합 패턴을 다룹니다.'', ''vi'': ''Tìm hiểu cách xây dựng ứng dụng tìm kiếm tăng cường RAG bằng Perplexity API. Bao gồm mô hình Sonar, trích dẫn web thờigian thực, streaming và các mẫu tích hợp sản xuất.''}'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: Proprietary
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/perplexity'
stars: 0
maintainer: 'perplexity'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Perplexity API']
aliases:
- /kr/posts/perplexity-api-rag-search/
---

{{</* resource-info */>}}

Perplexity API의 출시로 지능적이고 사실에 기반한 애플리케이션 구축 경쟁은 중요한 이정표에 도달했습니다. 이 API는 대규모 언어 모델과 실시간 웹 인덱싱을 융합한 전문 RAG(검색 증강 생성) 검색 서비스입니다. 정적 학습 데이터에만 의존하는 기존 LLM API와 달리 Perplexity의 Sonar 모델은 실시간으로 인터넷을 쿼리하고, 권위 있는 소스를 검색하며, 인라인 인용이 포함된 구조화된 답변을 반환합니다. 챗봇, 연구 도구, 지식 어시스턴트, 콘텐츠 검증 파이프라인을 구축하는 개발자에게 이는 패러다임의 전환을 의미합니다. 단순히 텍스트를 생성하는 것이 아니라 모든 주장을 검증 가능한 현실에 기반을 두는 애플리케이션입니다.

이 가이드는 2026년 Perplexity API에 대한 포괄적인 통합 로드맵을 제공합니다. RAG 검색 아키텍처의 작동 방식, 사용 사례에 적합한 Sonar 모델, 스트리밍 챗 완성 구현 방법, 프로그래밍 방식으로 인용 처리, 속도 제한 관리, 정확하고 출처가 있는 답변을 제공하는 프로덕션급 검색 애플리케이션 배포 방법을 알아보겠습니다.

---

## Perplexity API란 무엇이며 RAG가 중요한 이유는?

Perplexity AI는 기존 언어 모델의 근본적인 한계인 환각과 지식 차단을 해결하기 위해 API를 출시했습니다. 표준 LLM은 시간에 얼어붙어 특정 날짜에 데이터 학습이 중단됩니다. 어제의 시장 변동, 속보 뉴스, 최근 출시된 소프트웨어 버전에 대해 물어보면 환각을 일으키거나 무지함을 인정합니다.

Perplexity API는 내장 RAG를 통해 이 제약을 제거합니다. 쿼리를 본 볼 때 Perplexity의 백엔드는 실시간 웹 검색을 수행하고, 관련 문서를 검색하고, 권위에 따라 순위를 매기고, 언어 모델에 컨텍스트 기반으로 제공합니다. 그런 다음 모델은 특정 URL을 인용하는 답변을 종합하여 사용자가 모든 정보를 검증할 수 있도록 합니다.

이 아키텍처가 중요한 이유는 LLM을 폐쇄형 시험 응시자에서 개방형 연구자로 근본적으로 변환하기 때문입니다. 검색 계층은 사실적 정확성을 보장합니다. 생성 계층은 가독성과 종합성을 보장합니다. 인용 계층은 신뢰를 보장합니다. 함께 전통적인 검색 엔진에 필적하는 검색 경험을 만들면서도 사용자가 AI 기술을 기대하는 대화적 유창성을 제공합니다.

개발자에게 실질적인 의미는 심오합니다. 더 이상 자체 검색 파이프라인을 구축하거나, 벡터 데이터베이스를 관리하거나, 청킹 전략을 조정할 필요가 없습니다. Perplexity는 문서 검색, 관련성 평점 및 컨텍스트 주입을 자동으로 처리하여 OpenAI API를 사용핳 본 사람이라면 누구나 친숙하게 느낄 수 있는 깔끔한 챗 완성 인터페이스를 제공합니다.

---

## Sonar 모델군 이해: 선택 방법

Perplexity는 Sonar 브랜드 아래 계층화된 모델 라인업을 제공하며, 각각은 지연 시간, 정확성 및 비용 요구 사항에 최적화되어 있습니다. 올바른 모델을 선택하는 것은 개발자가 내리는 첫 번째 아키텍처 결정입니다.

### Sonar (표준)

기본 Sonar 모델은 가장 빠른 응답 시간과 가장 낮은 쿼리당 비용을 제공합니다. 쉽게 접근할 수 있는 웹 콘텐츠에서 답변을 찾을 수 있는 간단한 정보 쿼리에 탁월합니다. 챗봇, FAQ 시스템 및 사용자 경험에서 빠른 회신을 요구하는 애플리케이션에 Sonar를 사용하세요.

### Sonar Pro

Sonar Pro는 일부 대기 시간을 희생하여 상당히 더 깊은 추론 및 다단계 연구 기능을 제공합니다. 여러 검색 반복을 수행하고, 사고 연쇄 추론을 따륾며, 다양한 소스에서 복잡한 답변을 종합합니다. 연구 어시스턴트, 콘텐츠 분석 도구 및 답변 품질이 속도보다 중요한 모든 애플리케이션에 Sonar Pro를 선택하세요.

### Sonar Reasoning

추론 변형은 응답을 생성하기 전에 명시적인 단계별 분석을 적용합니다. 쿼리를 하위 질문으로 분해하고, 각 구성 요소에 대해 검색하고, 논리적으로 엄격한 답변을 구성합니다. 이 모델은 분석 작업, 팩트 체크 워크플로우 및 교육 애플리케이션에 이상적입니다.

### Sonar Deep Research

엔터프라이즈급 연구 및 포괄적인 주제 탐색을 위해 Sonar Deep Research는 광범위한 다중 소스 조사를 수행하여 수십 개의 문서를 평가하여 상세하고 잘 구조화된 보고서를 생성합니다. 대기 시간과 토큰 사용량이 더 높을 것으로 예상하지만, 비교할 수 없는 철저함을 제공합니다.

```python
# 다양한 사용 사례를 위한 모델 선택 매핑
MODEL_MAP = {
    "fast_chat": "sonar",           # 빠른 Q&A, 낮은 지연 시간
    "deep_research": "sonar-pro",   # 철저한 조사
    "analytical": "sonar-reasoning", # 단계별 추론
    "enterprise": "sonar-deep-research"  # 포괄적인 보고서
}
```

---

## 시작하기: API 키 및 인증

통합 코드를 작성하기 전에 Perplexity API 키가 필요합니다. Perplexity 개발자 포털을 방문하여 계정을 만들고 대시보드에서 API 키를 생성하세요. Perplexity는 HTTPS를 통한 표준 Bearer 토큰 인증을 사용합니다.

```bash
# API 키를 안전하게 저장
export PERPLEXITY_API_KEY="pplx-your-api-key-here"
```

모든 API 요청에는 `Authorization: Bearer <token>` 헤더가 필요합니다. 챗 완성을 위한 기본 엔드포인트는 `https://api.perplexity.ai/chat/completions`입니다.

```python
import os

API_KEY = os.environ.get("PERPLEXITY_API_KEY")
BASE_URL = "https://api.perplexity.ai"
HEADERS = {
    "Authorization": f"Bearer {API_KEY}",
    "Content-Type": "application/json"
}
```

Perplexity는 실험을 위해 관대한 묶음 티어를 제공하며, 유료 티어는 쿼리 볼륨 및 모델 선택에 따라 확장됩니다. 가격 구조는 더 간단한 과금을 위해 토큰 기반이 아닌 쿼리 기반이지만, 토큰 소비는 사용량 분석을 위해 추적됩니다.

---

## 기본 챗 완성: 첫 번째 RAG 쿼리

Perplexity API는 OpenAI 호환 챗 완성 인터페이스를 구현하여 이미 GPT 기반 모델을 사용 중인 경우 마이그레이션이 간단합니다. 중요한 차이점은 백그라운드에서 자동으로 발생하는 웹 검색 및 인용 주입입니다.

```python
import requests
import json

def perplexity_query(query: str, model: str = "sonar-pro") -> dict:
    """Perplexity API에 단일 RAG 강화 쿼리를 본 볼니다."""
    url = f"{BASE_URL}/chat/completions"
    
    payload = {
        "model": model,
        "messages": [
            {
                "role": "system",
                "content": "당신은 유용한 연구 어시스턴트입니다. 정확하고 잘 출처가 있는 답변을 제공하세요."
            },
            {
                "role": "user",
                "content": query
            }
        ],
        "max_tokens": 1024,
        "temperature": 0.2
    }
    
    response = requests.post(url, headers=HEADERS, json=payload)
    response.raise_for_status()
    return response.json()

# 첫 번째 RAG 검색 실행
result = perplexity_query(
    "2026년 핵융합 에너지의 최신 발전은 무엇인가요?"
)
print(result["choices"][0]["message"]["content"])
```

검색 매개변수, 문서 ID 또는 검색 구성이 필요하지 않습니다. Perplexity는 웹 검색이 필요한지 자동으로 결정하고, 검색을 실행하고, 출처가 있는 자료에 응답을 기반을 둡니다.

응답에는 생성된 텍스트뿐만 아니라 인용 메타데이터도 포함됩니다:

```python
# 응답에서 인용 추출
message = result["choices"][0]["message"]
answer_text = message["content"]
citations = message.get("citations", [])

print(f"답변: {answer_text[:200]}...")
print(f"\n인용된 출처: {len(citations)}")
for i, citation in enumerate(citations[:5], 1):
    print(f"  [{i}] {citation}")
```

---

## 인용 작업: 투명성을 통한 신뢰 구축

인용은 Perplexity의 RAG 구현의 결정적 특징입니다. 응답의 모든 사실적 주장은 특정 웹 소스로 추적할 수 있어 사용자가 정보를 검증하고 주제를 깊이 있게 탐색할 수 있습니다.

### 인용 형식 이해

Perplexity는 어시스턴트 메시지의 `citations` 필드에서 URL 목록 형태로 인용을 반환합니다. 콘텐츠 텍스트에서 인용은 괄호 안의 색인 `[1]`, `[2]` 등으로 참조되며, 이는 인용 배열의 순서와 일치합니다.

```python
def format_response_with_citations(result: dict) -> str:
    """클릭 가능한 인용 링크가 있는 Perplexity 응답을 형식화합니다."""
    message = result["choices"][0]["message"]
    content = message["content"]
    citations = message.get("citations", [])
    
    formatted = f"{content}\n\n---\n**출처:**\n"
    for i, url in enumerate(citations, 1):
        formatted += f"\n[{i}] [{url}]({url})"
    
    return formatted

print(format_response_with_citations(result))
```

### 웹 애플리케이션에서 인용 렌더링

웹 인터페이스를 구축할 때 인용을 대화형 각주 또는 사이드바 참조로 렌더링하세요:

```html
<!-- 인용이 있는 응답을 위한 React 컴포넌트 -->
function CitedResponse({ content, citations }) {
  // 콘텐츠에서 [1], [2] 마커 파싱
  const parts = content.split(/(\[\d+\])/g);
  
  return (
    <div className="cited-response">
      <div className="answer-text">
        {parts.map((part, i) => {
          const match = part.match(/\[(\d+)\]/);
          if (match) {
            const idx = parseInt(match[1]) - 1;
            return (
              <sup key={i} className="citation-ref">
                <a href={citations[idx]} target="_blank" rel="noopener">
                  {part}
                </a>
              </sup>
            );
          }
          return <span key={i}>{part}</span>;
        })}
      </div>
      <CitationList citations={citations} />
    </div>
  );
}
```

---

## 실시간 사용자 경험을 위한 스트리밍 응답

대화형 애플리케이션의 경우 Perplexity는 서버 전송 이벤트(SSE) 스트리밍을 지원하여 완전한 응답을 기다리는 대신 생성될 때 토큰을 전달합니다. 이는 속도 인식을 만들고 점진적 인용 표시를 가능하게 합니다.

```python
import sseclient
import io

def perplexity_stream(query: str, model: str = "sonar-pro"):
    """토큰별로 RAG 쿼리 응답을 스트리밍합니다."""
    url = f"{BASE_URL}/chat/completions"
    
    payload = {
        "model": model,
        "messages": [
            {"role": "system", "content": "간결하고 정확하게."},
            {"role": "user", "content": query}
        ],
        "stream": True,
        "max_tokens": 1024
    }
    
    response = requests.post(url, headers=HEADERS, json=payload, stream=True)
    response.raise_for_status()
    
    client = sseclient.SSEClient(response)
    full_content = []
    citations = []
    
    for event in client.events():
        if event.data == "[DONE]":
            break
        
        chunk = json.loads(event.data)
        delta = chunk["choices"][0].get("delta", {})
        
        # 콘텐츠 토큰 누적
        if "content" in delta:
            token = delta["content"]
            full_content.append(token)
            print(token, end="", flush=True)
        
        # 마지막 청크에서 인용 캡처
        if "citations" in delta:
            citations.extend(delta["citations"])
    
    print(f"\n\n출처: {citations}")
    return "".join(full_content), citations

# 실시간 쿼리 스트리밍
answer, sources = perplexity_stream(
    "최근 UN 기후 정상회의의 결과는 무엇인가요?"
)
```

```javascript
// fetch를 사용한 Node.js 스트리밍 예제
async function streamPerplexity(query) {
  const response = await fetch('https://api.perplexity.ai/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${process.env.PERPLEXITY_API_KEY}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'sonar-pro',
      messages: [{ role: 'user', content: query }],
      stream: true
    })
  });

  const reader = response.body.getReader();
  const decoder = new TextDecoder();

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    
    const chunk = decoder.decode(value);
    const lines = chunk.split('\n').filter(line => line.startsWith('data: '));
    
    for (const line of lines) {
      const data = line.slice(6);
      if (data === '[DONE]') return;
      
      const parsed = JSON.parse(data);
      const token = parsed.choices[0]?.delta?.content || '';
      process.stdout.write(token);
    }
  }
}
```

---

## 컨텍스트 검색이 있는 다중 턴 대화

Perplexity는 여러 턴에 걸쳐 대화 컨텍스트를 유지하여 이전 교환을 참조하는 후속 질문을 가능하게 합니다. 검색 시스템은 대화 흐름에 적응하여 누적된 컨텍스트를 기반으로 검색을 개선합니다.

```python
class PerplexityConversation:
    """RAG 검색 메모리가 있는 상태 저장 대화 처리기."""
    
    def __init__(self, model: str = "sonar-pro", system_prompt: str = None):
        self.model = model
        self.messages = []
        if system_prompt:
            self.messages.append({"role": "system", "content": system_prompt})
        self.citation_history = []
    
    def ask(self, query: str) -> dict:
        """메시지를 본 볼하고 대화 기록을 유지합니다."""
        self.messages.append({"role": "user", "content": query})
        
        payload = {
            "model": self.model,
            "messages": self.messages,
            "max_tokens": 1024,
            "temperature": 0.2,
            "return_citations": True
        }
        
        response = requests.post(
            f"{BASE_URL}/chat/completions",
            headers=HEADERS,
            json=payload
        )
        response.raise_for_status()
        result = response.json()
        
        assistant_msg = result["choices"][0]["message"]
        self.messages.append({
            "role": "assistant",
            "content": assistant_msg["content"]
        })
        self.citation_history.extend(assistant_msg.get("citations", []))
        
        return result
    
    def get_conversation_summary(self) -> str:
        """대화 및 사용된 출처의 요약을 생성합니다."""
        unique_sources = list(set(self.citation_history))
        return f"턴: {len(self.messages)//2}, 고유 출처: {len(unique_sources)}"

# 사용법: 다중 턴 연구 세션
conv = PerplexityConversation(
    model="sonar-pro",
    system_prompt="당신은 기술 동향을 전문으로 하는 시장 연구 분석가입니다."
)

# 턴 1: 초기 연구
r1 = conv.ask("2026년 시가총액 기준 상위 5대 AI 칩 회사는 어디인가요?")

# 턴 2: 컨텍스트 후속
r2 = conv.ask("이 중에서 R&D에 가장 많이 투자하는 곳은 어디인가요?")

# 턴 3: 심층 분석
r3 = conv.ask("올해 출시하는 구체적인 제품은 무엇인가요?")

print(conv.get_conversation_summary())
```

---

## 고급 쿼리 패턴: 구조화된 데이터 및 도메인 필터링

기본 Q&A를 넘어 Perplexity API는 개발자가 검색 및 생성 과정을 세밀하게 제어할 수 있는 고급 쿼리 패턴을 지원합니다.

### 검색 도메인 타겟팅

전문 분야에서 권위 있는 소싱을 위해 특정 도메인으로 검색을 제한하세요:

```python
def targeted_search(query: str, domains: list[str]) -> dict:
    """지정된 도메인 내에서 권위 있는 결과를 검색합니다."""
    payload = {
        "model": "sonar-pro",
        "messages": [
            {
                "role": "system",
                "content": f"다음 출처를 우선시합니다: {', '.join(domains)}. 이들을 우선적으로 인용하세요."
            },
            {"role": "user", "content": query}
        ],
        "search_domain_filter": domains,
        "return_citations": True
    }
    
    response = requests.post(
        f"{BASE_URL}/chat/completions",
        headers=HEADERS,
        json=payload
    )
    return response.json()

# 권위 있는 의료 도메인으로 제한된 의료 쿼리
medical_result = targeted_search(
    "최신 mRNA 백신 개발은 무엇인가요?",
    domains=["who.int", "cdc.gov", "nejm.org", " Lancet.com"]
)
```

### 최신성 필터링

웹 검색의 시간적 범위를 제어하여 최신성을 보장하세요:

```python
def recent_search(query: str, recency_days: int = 7) -> dict:
    """최근 정볼만 검색합니다."""
    payload = {
        "model": "sonar-pro",
        "messages": [{"role": "user", "content": query}],
        "search_recency_filter": f"{recency_days}d",
        "return_citations": True
    }
    
    response = requests.post(
        f"{BASE_URL}/chat/completions",
        headers=HEADERS,
        json=payload
    )
    return response.json()

# 최근 24시간의 뉴스만 가져오기
breaking = recent_search("오늘의 주요 기술 인수", recency_days=1)
```

### 자동 파싱을 위한 JSON 모드

데이터 파이프라인을 구축할 때 구조화된 출력을 요청하세요:

```python
import json

def structured_search(query: str, schema: dict) -> dict:
    """검색하고 스키마와 일치하는 구조화된 JSON을 반환합니다."""
    payload = {
        "model": "sonar-pro",
        "messages": [
            {
                "role": "system",
                "content": f"이 스키마와 일치하는 유효한 JSON으로 응답하세요: {json.dumps(schema)}"
            },
            {"role": "user", "content": query}
        ],
        "response_format": {"type": "json_object"},
        "return_citations": True
    }
    
    response = requests.post(
        f"{BASE_URL}/chat/completions",
        headers=HEADERS,
        json=payload
    )
    result = response.json()
    
    # JSON 콘텐츠 파싱
    content = result["choices"][0]["message"]["content"]
    result["structured"] = json.loads(content)
    return result

# 구조화된 회사 데이터 추출
company_schema = {
    "company_name": "string",
    "founded_year": "integer",
    "headquarters": "string",
    "key_products": ["string"],
    "market_cap_usd": "string"
}

structured = structured_search(
    "Perplexity AI 회사에 대한 세부 정보를 제공하세요",
    company_schema
)
print(json.dumps(structured["structured"], indent=2))
```

---

## 프로덕션 배포: 속도 제한, 오류 처리 및 재시도 로직

프로덕션 통합에는 API 제한과 일시적 오류에 대한 강력한 처리가 필요합니다. Perplexity는 구독 티어에 따라 속도 제한을 시행하며, 일반적인 제한은 분당 20~1000개 요청입니다.

```python
import time
from functools import wraps

class PerplexityClient:
    """재시도 및 속도 제한이 있는 프로덕션 준비 Perplexity API 클라이언트."""
    
    def __init__(self, api_key: str, model: str = "sonar-pro", max_retries: int = 3):
        self.api_key = api_key
        self.model = model
        self.max_retries = max_retries
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json"
        }
        self.request_count = 0
        self.last_reset = time.time()
    
    def _rate_limit_check(self, rpm_limit: int = 50):
        """티어 제한 내에서 유지하기 위한 기본 속도 제한."""
        now = time.time()
        if now - self.last_reset >= 60:
            self.request_count = 0
            self.last_reset = now
        
        if self.request_count >= rpm_limit:
            sleep_time = 60 - (now - self.last_reset)
            if sleep_time > 0:
                print(f"속도 제한에 도달했습니다. {sleep_time:.1f}초 대기")
                time.sleep(sleep_time)
            self.request_count = 0
            self.last_reset = time.time()
    
    def query(self, user_query: str, temperature: float = 0.2, **kwargs) -> dict:
        """오류 발생 시 자동 재시도로 쿼리를 실행합니다."""
        self._rate_limit_check()
        
        payload = {
            "model": self.model,
            "messages": [{"role": "user", "content": user_query}],
            "temperature": temperature,
            "return_citations": True,
            **kwargs
        }
        
        for attempt in range(self.max_retries):
            try:
                response = requests.post(
                    f"{BASE_URL}/chat/completions",
                    headers=self.headers,
                    json=payload,
                    timeout=30
                )
                
                if response.status_code == 429:
                    retry_after = int(response.headers.get("Retry-After", 2 ** attempt))
                    print(f"속도 제한됨. {retry_after}초 후 재시도")
                    time.sleep(retry_after)
                    continue
                
                response.raise_for_status()
                self.request_count += 1
                return response.json()
                
            except requests.exceptions.Timeout:
                print(f"시도 {attempt + 1}에서 시간 초과")
                time.sleep(2 ** attempt)
            except requests.exceptions.HTTPError as e:
                print(f"HTTP 오류: {e}")
                if attempt < self.max_retries - 1:
                    time.sleep(2 ** attempt)
        
        raise Exception("최대 재시도 횟수 초과")

# 프로덕션 사용법
client = PerplexityClient(api_key=os.environ["PERPLEXITY_API_KEY"])

# 속도 제한이 있는 일괄 처리
queries = [
    "양자 컴퓨팅 최신 혁신",
    "2026년 재생 에너지 투자",
    "새로운 우주 망원경 발견"
]

results = []
for q in queries:
    try:
        result = client.query(q)
        results.append(result)
        print(f"✓ 쿼리 완료: {q[:50]}...")
    except Exception as e:
        print(f"✗ 쿼리 실패: {q[:50]}... - {e}")
```

---

## 완전한 RAG 검색 애플리케이션 구축

모든 것을 RAG 기반 검색 서비스의 프로덕션 패턴을 보여주는 완전한 Flask 애플리케이션으로 종합해 보겠습니다.

```python
# app.py - 완전한 RAG 검색 API
from flask import Flask, request, jsonify, Response
from flask_cors import CORS
import os
import json
import requests

app = Flask(__name__)
CORS(app)

PERPLEXITY_KEY = os.environ["PERPLEXITY_API_KEY"]
BASE_URL = "https://api.perplexity.ai"

class RAGSearchService:
    def __init__(self):
        self.headers = {
            "Authorization": f"Bearer {PERPLEXITY_KEY}",
            "Content-Type": "application/json"
        }
    
    def search(self, query: str, model: str = "sonar-pro", stream: bool = False):
        """선택적 스트리밍이 있는 RAG 검색을 실행합니다."""
        payload = {
            "model": model,
            "messages": [
                {
                    "role": "system",
                    "content": "정확하고 출처가 있는 답변과 인용을 제공하세요."
                },
                {"role": "user", "content": query}
            ],
            "stream": stream,
            "return_citations": True,
            "max_tokens": 2048
        }
        
        response = requests.post(
            f"{BASE_URL}/chat/completions",
            headers=self.headers,
            json=payload,
            stream=stream
        )
        response.raise_for_status()
        return response

service = RAGSearchService()

@app.route("/search", methods=["POST"])
def search():
    """동기 RAG 검색 엔드포인트."""
    data = request.get_json()
    query = data.get("query", "")
    model = data.get("model", "sonar-pro")
    
    if not query:
        return jsonify({"error": "쿼리가 필요합니다"}), 400
    
    try:
        result = service.search(query, model=model)
        data = result.json()
        
        message = data["choices"][0]["message"]
        return jsonify({
            "answer": message["content"],
            "citations": message.get("citations", []),
            "model": model,
            "usage": data.get("usage", {})
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/search/stream", methods=["POST"])
def search_stream():
    """서버 전송 이벤트를 사용한 스트리밍 RAG 검색 엔드포인트."""
    data = request.get_json()
    query = data.get("query", "")
    model = data.get("model", "sonar-pro")
    
    if not query:
        return jsonify({"error": "쿼리가 필요합니다"}), 400
    
    def generate():
        response = service.search(query, model=model, stream=True)
        for line in response.iter_lines():
            if line:
                decoded = line.decode("utf-8")
                if decoded.startswith("data: "):
                    yield f"{decoded}\n\n"
    
    return Response(
        generate(),
        mimetype="text/event-stream",
        headers={"Cache-Control": "no-cache"}
    )

@app.route("/health", methods=["GET"])
def health():
    """상태 확인 엔드포인트."""
    return jsonify({"status": "healthy", "service": "rag-search"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
```

```bash
# 컨테이너화된 배포를 위한 Dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
ENV PERPLEXITY_API_KEY=""
ENV FLASK_ENV=production

EXPOSE 5000
CMD ["gunicorn", "-w", "4", "-b", "0.0.0.0:5000", "app:app"]
```

```yaml
# docker-compose.yml
version: "3.8"
services:
  rag-search:
    build: .
    ports:
      - "5000:5000"
    environment:
      - PERPLEXITY_API_KEY=${PERPLEXITY_API_KEY}
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:5000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
```

---

## FAQ

### Perplexity API는 OpenAI의 GPT API와 어떻게 다릅니까?

Perplexity API는 자동으로 실시간 웹 검색과 인용 주입을 수행하는 반면, OpenAI의 API는 외부 벡터 데이터베이스를 사용하여 RAG를 수동으로 구현하지 않는 한 훈련 데이터에 의존합니다. Perplexity는 일체형 RAG 솔루션을 제공하며 검색, 순위 및 기반을 낮부에서 처리합니다.

### Perplexity API의 속도 제한은 무엇입니까?

속도 제한은 구독 티어별로 다릅니다. 묶음 티어는 일반적으로 분당 20개 요청을 허용하고, Pro 및 엔터프라이즈 티어는 100-1000+ RPM으로 확장됩니다. 정확한 제한은 개발자 대시보드에서 확인하세요.

### Perplexity API를 자체 문서와 함께 사용할 수 있습니까?

현재 Perplexity API는 사설 문서 수집이 아닌 웹 검색 RAG에 중점을 둡니다. 사용자 지정 문서 RAG의 경우 Perplexity의 웹 검색을 벡터 데이터베이스 솔루션과 결합하거나 전문 RAG 플랫폼을 사용해야 합니다.

### Perplexity가 제공하는 인용의 정확도는 어느 정도입니까?

Perplexity의 인용 시스템은 매우 정확하며, 출처는 검색 단계에서 검색된 URL에 직접 연결됩니다. 응답의 `[1]`, `[2]` 마커는 인용 배열과 정확히 일치합니다. 그러나 중요한 정보는 반드시 1차 출처 대해 검증하세요.

### 스트리밍은 모든 Sonar 모델에서 지원됩니까?

네, 서버 전송 이벤트를 통한 스트리밍은 모든 Sonar 모델 변형에서 지원됩니다. 스트리밍 구현은 OpenAI 호환 형식을 따륾므로 기존 스트리밍 클라이언트를 쉽게 적용할 수 있습니다.

### Perplexity API의 가격 책정 모델은 무엇입니까?

Perplexity는 쿼리 볼륨과 토큰 소비를 기반으로 하는 결합 가격 책정 모델을 사용합니다. 기본 Sonar가 가장 경제적이고, Sonar Deep Research는 광범위한 다단계 검색으로 인해 더 높은 비용이 발생합니다. 현재 요금은 Perplexity 가격 페이지를 참조하세요.

### 검색을 특정 도메인이나 날짜 범위로 필터링할 수 있습니까?

네, API는 `search_domain_filter`를 지원하여 특정 도메인으로 쿼리를 제한하고, `search_recency_filter`는 결과를 최신성으로 제한합니다(예: 지난 7일은 "7d"). 이러한 매개변수는 권위 있고 시기적절한 소싱에 도움이 됩니다.

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 결론

Perplexity API는 개발자가 접근할 수 있는 RAG 기술의 중요한 발전을 나타냅니다. 실시간 웹 인덱싱, 여러 전문 Sonar 모델, 투명한 인용, OpenAI 호환 인터페이스를 결합함으로써 벡터 데이터베이스, 임베딩 파이프라인 또는 관련성 조정을 관리할 필요 없이 프로덕션급 RAG로의 직접적인 경로를 제공합니다.

연구 어시스턴트, 팩트 체크 도구, 동적 지식 베이스, 콘텐츠 검증 시스템을 포함한 차세대 지능형 애플리케이션을 구축하는 개발자에게 Perplexity는 이 기대를 충족할 수 있는 애플리케이션을 배치하여 사용자가 신뢰할 수 있는 경험을 제공합니다. 모든 답변은 실제이며 인용 가능한 출처의 기반 위에 서 있기 때문입니다.
