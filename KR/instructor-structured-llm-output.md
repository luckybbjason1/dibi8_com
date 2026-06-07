---
title: 'Instructor: LLM이 100% 유효한 JSON을 출력하도록 강제하는 Python 라이브러리 —— 2026 가이드'
description: '일관성 없는 LLM 출력과의 투쟁을 멈추세요. Instructor가 Pydantic 모델을 사용하여 유효하고 타입 안전한 JSON 응답을 보장하기 위해 OpenAI 클라이언트를 패치하는 방법을 알아보세요. 재시도 로직, 다중 공급자 지원 및 스트리밍 기능을 갖추고 있습니다.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/jxnl/instructor'
stars: 11000
maintainer: 'jxnl'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Instructor']
aliases:
- /kr/posts/instructor-structured-llm-output/
---

{{</* resource-info */>}}

*최종 업데이트: 2026년 5월 19일*

대형 언어 모델(LLM)에게 일관되게 유효한 JSON을 출력하도록 시도해 본 적이 있다면, 그 고통을 알 것입니다. 첫 번째 응답은 완벽합니다. 두 번째는 닫는 중괄호가 빠져 있습니다. 세 번째는 JSON 앞에 설명 텍스트가 포함됩니다. 네 번째는 유효한 JSON을 반환하지만 스키마가 잘못되었습니다. 이러한 불일치로 인해 구조화된 데이터가 필요한 프로덕션 애플리케이션에 LLM을 사용하는 것이 신뢰할 수 없게 만들었습니다——**Instructor**가 등장하기 전까지는요.

Instructor는 OpenAI 클라이언트(및 기타 10개 이상의 LLM 제공자)를 패치하여 **Pydantic 모델**을 사용하여 구조화되고 타입 안전하며 검증된 출력을 보장하는 Python 라이브러리입니다. LLM 텍스트 생성의 묵묵한 서부를 예측 가능한 소프트웨어 엔지니어링 프로세스로 변환합니다. 11,000개 이상의 GitHub 스타, MIT 라이선스 및 번성하는 커뮤니티를 보유한 Instructor는 Python에서 구조화된 LLM 출력의 사실상 표준이 되었습니다. 이 가이드는 2026년 기본 설정부터 고급 멀티 제공자 패턴까지 모든 것을 다룹니다.

---

## Instructor란 무엇이며 왜 중요한가?

**Jason Liu**(`jxnl`)가 생성한 Instructor는 기존 LLM 클라이언트 위에 위치하여 Pydantic 모델 검증을 통해 구조화된 출력을 강제하는 경량 Python 라이브러리입니다. LLM으로부터 원시 텍스트를 받아서 제대로 파싱되기를 기도하는 대신, Pydantic 스키마를 정의하고 Instructor가 모든 응답이 해당 스키마를 준수하도록 보장합니다——또는 수정된 프롬프트로 자동 재시행합니다.

Instructor가 해결하는 문제는 근본적인 것입니다: LLM은 텍스트를 생성하지만 애플리케이션은 데이터가 필요합니다. LLM 기능을 프로덕션 환경에 배포한 모든 개발자는 모델이 JSON 객체 앞에 "Here's your result:"를 추가하여 `json.loads()`가 충돌했을 때 새벽 2시에 경보를 받은 경험이 있습니다. Instructor는 이러한 전체 범주의 오류를 제거합니다.

```bash
# Instructor 설치
pip install instructor

# 선호하는 LLM 클라이언트 설치(OpenAI 예시)
pip install openai
```

---

## 핵심 개념: OpenAI 클라이언트 패치

Instructor의 마법은 **클리이언트 패치**를 통해 이루어집니다. OpenAI의 API를 직접 호출하는 대신, 응답을 가로채고 Pydantic 모델에 대해 검증하며 실패를 자동으로 처리하는 패치된 클라이언트를 만듭니다.

```python
import instructor
from openai import OpenAI
from pydantic import BaseModel

# OpenAI 클라이언트를 Instructor로 패치
client = instructor.from_openai(OpenAI())

# 출력 스키마를 Pydantic 모델로 정의
class UserProfile(BaseModel):
    name: str
    age: int
    email: str
    interests: list[str]

# 자연어에서 구조화된 데이터 추출
def extract_profile(user_description: str) -> UserProfile:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=UserProfile,
        messages=[
            {
                "role": "user",
                "content": f"이 설명에서 사용자 프로필을 추출: {user_description}"
            }
        ]
    )

# 사용법
profile = extract_profile(
    "Sarah는 시애틀 출신의 28세 소프트웨어 엔지니어입니다. "
    "그녀는 하이킹, 사진 촬영, 공상과학 소설 읽기를 좋아합니다. "
    "이메일은 sarah.chen@example.com입니다"
)

print(profile)
# UserProfile(name='Sarah', age=28, email='sarah.chen@example.com', 
#             interests=['hiking', 'photography', 'reading sci-fi novels'])

# 타입이 지정된 필드에 직접 접근
print(f"이름: {profile.name}, 나이: {profile.age}")
print(f"이메일 유효: {'@' in profile.email}")
```

`response_model=UserProfile`가 Instructor에게 정의한 스키마에 대해 LLM의 출력을 검증하도록 지시하는 방식에 주목하세요. 결과는 완전히 타입이 지정된 Pydantic 객체입니다——원시 문자열이나 비타입화된 딕셔너리가 아닙니다.

---

## 자동 재시도를 통한 검증 실패 처리

LLM이 잘못된 출력을 생성하면 어떻게 될까요? Instructor의 기본 동작은 무엇이 잘못되었는지에 대한 피드백과 함께 모델에 **재질문**하여 자기 수정 루프를 만드는 것입니다.

```python
from pydantic import BaseModel, Field, field_validator

class ValidatedProduct(BaseModel):
    name: str = Field(description="제품 이름, 최대 50자")
    price: float = Field(description="USD 가격, 양수여야 함")
    category: str = Field(description="다음 중 하나: electronics, clothing, food, books")
    
    @field_validator('category')
    @classmethod
    def validate_category(cls, v):
        allowed = {'electronics', 'clothing', 'food', 'books'}
        if v.lower() not in allowed:
            raise ValueError(f"카테고리는 다음 중 하나여야 함: {allowed}")
        return v.lower()
    
    @field_validator('price')
    @classmethod
    def validate_price(cls, v):
        if v <= 0:
            raise ValueError("가격은 양수여야 함")
        return round(v, 2)

# 검증 실패 시 Instructor가 자동 재시도
def parse_product(description: str) -> ValidatedProduct:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=ValidatedProduct,
        max_retries=3,  # 피드백과 함께 최대 3회 재시도
        messages=[
            {"role": "user", "content": f"이 제품을 파싱: {description}"}
        ]
    )

# 첫 시도에 문제가 있어도 정상 작동
product = parse_product(
    "무선 블루투스 노이즈 캔슬링 헤드폰, $79.99. "
    "전자제품 카테고리."
)
print(product)
# ValidatedProduct(name='무선 블루투스 헤드폰', 
#                  price=79.99, category='electronics')
```

---

## 중첩 모델 및 복잡한 스키마

실제 애플리케이션에는 단순한 구조 이상이 필요합니다. Instructor는 임의로 중첩된 Pydantic 모델을 쉽게 처리합니다.

```python
from typing import Optional, List
from pydantic import BaseModel, Field

class Address(BaseModel):
    street: str
    city: str
    state: str = Field(description="2글자 주 코드")
    zip_code: str
    country: str = "US"

class OrderItem(BaseModel):
    product_name: str
    quantity: int = Field(ge=1, description="1 이상이어야 함")
    unit_price: float = Field(gt=0)
    
    @property
    def total(self) -> float:
        return self.quantity * self.unit_price

class CustomerOrder(BaseModel):
    customer_name: str
    customer_email: str
    shipping_address: Address
    billing_address: Optional[Address] = None
    items: List[OrderItem]
    order_notes: Optional[str] = None
    
    @property
    def grand_total(self) -> float:
        return sum(item.total for item in self.items)

def extract_order(email_text: str) -> CustomerOrder:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=CustomerOrder,
        messages=[
            {"role": "user", "content": f"이메일에서 주문 추출:\n\n{email_text}"}
        ]
    )

order = extract_order("""
안녕하세요, 주문을 하고 싶습니다.

고객: John Smith (john.smith@email.com)
배송지: 123 Oak Street, San Francisco, CA 94102

상품:
- MacBook Pro M3, 수량 1, $1999
- USB-C 허브, 수량 2, 각 $49

노트북은 선물 포장해 주세요.
""")

print(f"고객: {order.customer_name}")
print(f"배송 도시: {order.shipping_address.city}")
print(f"주문 총액: ${order.grand_total:.2f}")
```

---

## 멀티 프로바이더 지원: OpenAI를 넘어서

Instructor는 OpenAI에 잠기지 않습니다. 동일한 API로 10개 이상의 LLM 제공자를 지원하여 공급자 전환이 수월합니다.

```python
# --- Anthropic Claude ---
import anthropic
import instructor

anthropic_client = instructor.from_anthropic(anthropic.Anthropic())

result = anthropic_client.messages.create(
    model="claude-sonnet-4-20250514",
    response_model=UserProfile,
    max_tokens=1024,
    messages=[{"role": "user", "content": "추출: Mike 35세, 테니스 좋아함"}]
)
print(result)

# --- Google Gemini ---
import google.generativeai as genai
import instructor

gemini_client = instructor.from_gemini(
    genai.GenerativeModel("gemini-2.5-pro")
)

result = gemini_client.generate_content(
    response_model=UserProfile,
    contents=["추출: Lisa 29세, 요리와 요가 좋아함"]
)
print(result)

# --- Cohere ---
import cohere
import instructor

cohere_client = instructor.from_cohere(cohere.Client())

result = cohere_client.chat(
    response_model=UserProfile,
    message="추출: David 42세, 골프와 낚시 좋아함"
)
print(result)
```

---

## 대용량 애플리케이션을 위한 배치 처리

수천 개의 항목을 처리할 때 개별 API 호출은 너무 느립니다. Instructor는 동시 실행을 위한 asyncio를 지원하는 배치 처리를 제공합니다.

```python
import asyncio
import instructor
from openai import AsyncOpenAI
from pydantic import BaseModel

# 배치 처리를 위한 비동기 클라이언트 사용
async_client = instructor.from_openai(AsyncOpenAI())

class SentimentResult(BaseModel):
    text: str
    sentiment: str  # "positive", "negative", "neutral"
    confidence: float
    key_phrases: list[str]

async def analyze_single(text: str) -> SentimentResult:
    return await async_client.chat.completions.create(
        model="gpt-4o-mini",
        response_model=SentimentResult,
        messages=[
            {"role": "user", "content": f"감정 분석: {text}"}
        ]
    )

async def analyze_batch(texts: list[str]) -> list[SentimentResult]:
    """여러 텍스트를 동시에 처리."""
    tasks = [analyze_single(text) for text in texts]
    results = await asyncio.gather(*tasks)
    return results

# 100개 리뷰를 동시에 처리
texts = [
    "이 제품은 기대를 뛰어넘었어요!",
    "품질이 너무 안 좋아서 하루 만에 고장났어요.",
    "그냥 그래요. 특별한 건 없지만 쓸 만해요.",
    # ... 97개 더 추가
]

results = asyncio.run(analyze_batch(texts))
positive = sum(1 for r in results if r.sentiment == "positive")
print(f"긍정: {positive}/{len(results)}")
```

---

## 스트리밍 구조화된 출력

실시간 애플리케이션을 위해 Instructor는 LLM에서 결과가 도착하는 대로 부분 결과를 스트리밍하는 것을 지원합니다.

```python
from typing import Iterable
from pydantic import BaseModel

class PartialArticle(BaseModel):
    title: str
    sections: list[str]
    key_points: list[str]

# 생성되는 대로 구조화된 데이터 스트리밍
def stream_article(topic: str) -> Iterable[PartialArticle]:
    return client.chat.completions.create_partial(
        model="gpt-4o",
        response_model=PartialArticle,
        stream=True,
        messages=[
            {"role": "user", "content": f"다음 주제에 대한 기사 개요를 작성: {topic}"}
        ]
    )

# 부분 결과가 도착하는 대로 소비
for partial in stream_article("2026년 재생 에너지 트렌드"):
    print(f"제목: {partial.title}")
    print(f"현재까지의 섹션 수: {len(partial.sections)}")
    print("---")
```

---

## 내장 재시도 및 재질문

Instructor의 재시도 시스템은 단순히 요청을 반복하는 것이 아닙니다——검증이 실패한 내용에 대한 구체적인 피드백을 LLM에 제공하여 자가 수정을 가능하게 합니다.

```python
from pydantic import BaseModel, field_validator

class StrictDateRange(BaseModel):
    start_date: str = Field(description="YYYY-MM-DD 형식")
    end_date: str = Field(description="YYYY-MM-DD 형식, 시작일 이후여야 함")
    
    @field_validator('start_date', 'end_date')
    @classmethod
    def validate_date_format(cls, v):
        from datetime import datetime
        datetime.strptime(v, "%Y-%m-%d")
        return v
    
    @field_validator('end_date')
    @classmethod
    def validate_order(cls, end, info):
        start = info.data.get('start_date')
        if start and end <= start:
            raise ValueError("end_date는 start_date 이후여야 함")
        return end

# Instructor가 특정 검증 오류 피드백으로 재시도
def extract_date_range(text: str) -> StrictDateRange:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=StrictDateRange,
        max_retries=3,
        messages=[
            {"role": "user", "content": f"날짜 범위 추출: {text}"}
        ]
    )

# 모델이 처음에 날짜를 바꾸거나 잘못된 형식을 사용하더라도,
# Instructor가 구체적인 오류 메시지로 재질문
try:
    result = extract_date_range(
        "프로젝트는 2026년 3월 15일부터 2026년 1월 10일까지 진행되었습니다"
    )
    print(result)
except Exception as e:
    print(f"최대 재시도 횟수 후 실패: {e}")
```

---

## 제한된 분류를 위한 Literal 사용

분류 작업의 경우 Python의 `Literal` 타입을 사용하여 출력을 특정 값으로 제한합니다.

```python
from typing import Literal

class SupportTicket(BaseModel):
    customer_query: str
    category: Literal[
        "billing", 
        "technical_support", 
        "account_access",
        "feature_request",
        "refund",
        "general_inquiry"
    ]
    priority: Literal["low", "medium", "high", "urgent"]
    suggested_response: str

def classify_ticket(ticket_text: str) -> SupportTicket:
    return client.chat.completions.create(
        model="gpt-4o-mini",
        response_model=SupportTicket,
        messages=[
            {
                "role": "system",
                "content": "당신은 고객 지원 분류 전문가입니다."
            },
            {"role": "user", "content": f"이 티켓을 분류:\n\n{ticket_text}"}
        ]
    )

# 분류 결과는 항상 허용된 값 중 하나
ticket = classify_ticket(
    "이번 달 구독이 두 번 청구되었습니다. "
    "중복 청구를 즉시 환불해 주세요."
)
print(f"카테고리: {ticket.category}")  # 항상 "billing"
print(f"우선순위: {ticket.priority}")  # 항상 4개 값 중 하나
```

---

## FastAPI와의 통합으로 프로덕션 API 구축

Instructor는 API 개발에서 빛을 발합니다. 다음은 구조화된 LLM 출력을 갖춘 완전한 FastAPI 엔드포인트입니다:

```python
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import instructor
from openai import OpenAI

app = FastAPI(title="구조화된 LLM API")
client = instructor.from_openai(OpenAI())

# 요청 스키마
class ExtractionRequest(BaseModel):
    text: str
    extract_fields: list[str]

# 응답 스키마
class ExtractedData(BaseModel):
    entities: list[dict]
    relationships: list[dict]
    summary: str

@app.post("/extract", response_model=ExtractedData)
async def extract_entities(request: ExtractionRequest):
    """비구조화된 텍스트에서 구조화된 엔티티를 추출."""
    try:
        result = client.chat.completions.create(
            model="gpt-4o",
            response_model=ExtractedData,
            messages=[
                {
                    "role": "user",
                    "content": (
                        f"이 텍스트에서 엔티티를 추출. "
                        f"포커스: {', '.join(request.extract_fields)}\n\n"
                        f"텍스트: {request.text}"
                    )
                }
            ]
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# 실행: uvicorn main:app --reload
```

---

## 고급: 함수 호출 대안

Instructor는 더 강력한 Pydantic 기반 스키마로 OpenAI의 함수 호출을 대체할 수 있습니다.

```python
from typing import Type

class SearchQuery(BaseModel):
    """매개변수가 있는 생성된 검색 쿼리"""
    keywords: list[str]
    filters: dict[str, str]
    sort_by: Literal["relevance", "date", "price_asc", "price_desc"]
    
def generate_search(user_request: str) -> SearchQuery:
    return client.chat.completions.create(
        model="gpt-4o",
        response_model=SearchQuery,
        messages=[
            {
                "role": "user",
                "content": f"다음 요청에 대해 최적화된 검색 쿼리를 생성: {user_request}"
            }
        ]
    )

query = generate_search(
    "배터리 수명이 좋은 $100 이하 무선 이어폰을 찾아, 최신순"
)
print(query.keywords)  # ['wireless earbuds', 'bluetooth']
print(query.filters)   # {'max_price': '100'}
print(query.sort_by)   # 'date'
```

---

## 오류 처리 및 로깅

프로덕션 시스템은 Instructor의 재시도 동작에 대한 가시성이 필요합니다. 디버깅을 위해 로깅을 구성합니다.

```python
import logging
import instructor

# 상세 로깅 활성화
instructor.enable_logging()
logging.basicConfig(level=logging.DEBUG)

# 또는 특정 로거 구성
logger = logging.getLogger("instructor")
logger.setLevel(logging.INFO)

# 프로덕션용 파일 핸들러 추가
handler = logging.FileHandler("instructor.log")
handler.setFormatter(logging.Formatter(
    '%(asctime)s - %(name)s - %(levelname)s - %(message)s'
))
logger.addHandler(handler)

# 모든 재시도 시도와 검증 오류가 기록됨
result = client.chat.completions.create(
    model="gpt-4o",
    response_model=UserProfile,
    max_retries=3,
    messages=[{"role": "user", "content": "추출: Jane, 25세, 예술 좋아함"}]
)
```

---

## 자주 묻는 질문

### Instructor는 어떤 LLM 제공자를 지원하나요?

Instructor는 **OpenAI**(GPT-4, GPT-4o, GPT-3.5), **Anthropic**(Claude 3/3.5/4 Sonnet, Opus, Haiku), **Google**(Gemini 1.5/2.0/2.5 Pro, Flash), **Cohere**, **Mistral**, **Groq**, **Ollama**(로컬 모델), **Azure OpenAI**, **AWS Bedrock**, **Fireworks AI**, **Together AI**를 지원합니다. 동일한 `response_model` API가 모든 제공자에서 동일하게 작동합니다.

### Instructor는 OpenAI의 JSON 모드와 어떻게 다른가요?

OpenAI의 JSON 모드는 유효한 JSON 구문을 보장하지만 **스키마 검증은 제공하지 않습니다**. 모델은 여전히 잘못된 필드 이름, 잘못된 타입, 누락된 필수 필드 또는 예상 범위를 벗어난 값이 있는 JSON을 반환할 수 있습니다. Instructor는 이러한 모든 문제를 포착하고 수정 피드백으로 자동 재시도를 트리거하는 Pydantic 검증 레이어를 추가합니다. JSON 모드는 구문 보장입니다. Instructor는 의미론적 보장입니다.

### Instructor는 로컬/오픈소스 모델과 작동하나요?

네. Instructor는 지원되는 클라이언트 라이브러리를 통해 액세스할 수 있는 모든 모델과 작동합니다. 로컬 모델의 경우 **Ollama** 또는 **llama-cpp-python** 통합을 사용합니다. vLLM 또는 TGI에 호스팅된 모델의 경우 OpenAI 호환 API를 사용합니다. 핵심 요구사항은 모델이 JSON에 매핑되는 구조화된 텍스트를 생성할 수 있는 충분한 지시 따르기 능력을 갖추는 것입니다.

### Instructor의 성능 오버헤드는 얼마인가요?

Instructor는 최소한의 오버헤드만 추가합니다——일반적으로 Pydantic 검증에 대해 **호출당 10-50ms**입니다. 재시도 메커니즘은 검증이 실패할 때만 지연을 추가합니다(이는 유능한 모델에서는 호출의 5% 미만이어야 합니다). 고처리량 애플리케이션의 경우 `gpt-4o-mini` 또는 비동기 배치 처리가 있는 로컬 모델을 사용하세요. 오버헤드는 LLM API 지연 자체(일반적으로 500ms-5s)와 비교하면 무시할 수 있습니다.

### 재시도/재질문 메커니즘은 어떻게 작동하나요?

검증이 실패하면 Instructor는 Pydantic `ValidationError`를 포착하고 특정 오류 메시지(예: "age must be a positive integer")를 추출하며, 다음을 포함하는 새 요청을 LLM에 볃니다: 원래 프롬프트, 잘못된 응답, 검증 오류 세부 정보. 이는 대부분의 문제를 1-2회 재시도 내에 해결하는 자기 수정 루프를 만듭니다. 최대 재시도 횟수는 `max_retries` 매개변수로 제어합니다.

### async/await 패턴에서 Instructor를 사용할 수 있나요?

네. Instructor는 `AsyncOpenAI`, `AsyncAnthropic` 및 기타 비동기 클라이언트를 통해 완전히 비동기를 지원합니다. 단일 호출에는 `await client.chat.completions.create()`를 사용하고, 동시 배치 처리에는 `asyncio.gather()`를 사용합니다. 스트리밍도 `create_partial()`을 통해 비동기 모드에서 지원됩니다.

### Instructor는 엔터프라이즈 프로덕션 배포에 적합한가요?

물론입니다. Instructor의 11,000개 이상의 GitHub 스타, MIT 라이선스, 활발한 유지 관리, Pydantic 기반 아키텍처로 인해 엔터프라이즈 준비가 되었습니다. FastAPI, 모니터링 시스템(Datadog, Prometheus), 구조화된 로깅과 깔끔하게 통합됩니다. 검증 레이어는 원시 LLM API가 일치시킬 수 없는 신뢰성을 추가합니다. 많은 포춘 500대 기업이 프로덕션 데이터 파이프라인에서 Instructor를 사용합니다.

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 결론

Instructor는 LLM을 예측 불가능한 텍스트 생성기에서 신뢰할 수 있는 구조화된 데이터 소스로 변환합니다. Pydantic 검증의 강력함과 지능형 재시도 로직을 결합하여 프로덕션 LLM 배포가 직면한 #1 문제인 출력 일관성을 해결합니다. 문서에서 엔티티를 추출하든, 지원 티켓을 분류하든, 복잡한 다중 단계 에이전트 시스템을 구축하든, Instructor는 전문 애플리케이션이 요구하는 타입 안전성과 신뢰성을 제공합니다.

라이브러리의 멀티 프로바이더 지원은 단일 LLM 공급자에 잠기지 않음을 의미합니다. FastAPI, 비동기 패턴 및 스트리밍과의 원활한 통합으로 백그라운드 배치 작업부터 실시간 API까지 모든 것에 적합합니다. 11,000개 이상의 스타와 활발한 커뮤니티를 보유한 Instructor는 현대 AI 개발자의 도구 키트에서 필수 도구로서의 지위를 확보했습니다.

여전히 원시 LLM 출력을 `json.loads()`로 파싱하고 제대로 작동하기를 기도하고 있다면, 업그레이드할 때입니다. 오늘 Instructor를 설치하고 **100% 유효한 JSON, 100%의 시간**을 경험해 보세요.
