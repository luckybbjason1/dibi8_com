---
title: 'Polymarket Agents: Polymarket 예측 시장용 AI 자동 거래 봇 구축'
description: Polymarket Agents는 Polymarket 예측 시장에서 AI가 자율적으로 거래하는 에이전트를 구축하기 위한 오픈소스
  개발자 프레임워크입니다.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Python
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "107 KB"
file_md5: ''
download_url: https://github.com/Polymarket/agents
backup_url: ''
github_repo: https://github.com/Polymarket/agents
stars: 3513
maintainer: "Polymarket"
last_maintained: "2024-11-05"
featureImage: ''
draft: false
aliases:
- /ko/posts/polymarket-agents-ai-trading-bot-framework/
faqs:
  - q: 'Polymarket Agents란 무엇인가요?'
    a: 'Polymarket Agents는 Polymarket 예측 시장에서 자율적으로 거래하는 AI 에이전트를 구축하기 위한 오픈소스 MIT 라이선스 개발자 프레임워크입니다. 시장을 분석하는 유틸리티를 제공하며, 실시간 데이터를 위해 Polymarket API와 연동하고 거래를 자동으로 실행합니다.'
  - q: 'Polymarket Agents를 실행하기 전에 무엇을 준비해야 하나요?'
    a: '.env 파일에 설정된 Polygon 지갑 개인 키와 OpenAI API key가 필요하며, requirements.txt에서 의존성을 설치한 Python 3.9 가상 환경도 필요합니다. 또한 Polymarket의 거래는 USDC로 정산되므로 Polygon 지갑에 USDC를 충전해야 합니다.'
  - q: 'Polymarket Agents는 거래 결정에 RAG를 어떻게 활용하나요?'
    a: 'Chroma 벡터 데이터베이스를 사용해 뉴스 기사와 시장 데이터를 저장하고, 시맨틱 검색을 위해 텍스트를 embeddings로 변환하며, 현재 시장 맥락에 기반해 관련 정보를 검색한 뒤, LLM이 검색된 데이터를 종합해 거래 결정을 내리도록 합니다.'
  - q: 'Polymarket Agents는 어떤 거래 전략을 지원하나요?'
    a: '이 프레임워크는 뉴스 기반 거래(LLM의 이벤트 감성 분석), 관련 시장 간 차익거래 탐지, 거래량과 가격 움직임에 기반한 추세 추종, 그리고 RAG를 사용해 과거 데이터를 조회하는 펀더멘털 분석을 지원합니다.'
  - q: 'Polymarket Agents CLI로 거래를 어떻게 실행하나요?'
    a: 'CLI 명령어 ''python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>''를 실행하세요. 또한 ''get-all-markets --sort-by volume''로 시장 목록을 조회하거나 ''get-market --market-id <MARKET_ID>''로 단일 시장을 확인할 수도 있습니다.'
---
{</* resource-info */>}

![Polymarket Agents CLI 명령어 목록](/images/articles/polymarket-agents-ai-trading-bot-framework/cli.png)
*Polymarket Agents CLI — [github.com/Polymarket/agents](https://github.com/Polymarket/agents) 공식 스크린샷*

## Polymarket Agents란?

**Polymarket Agents**는 **Polymarket** — 세계 최대의 예측 시장 플랫폼 — 에서 AI가 자율적으로 거래하는 에이전트를 구축하기 위한 오픈소스 개발자 프레임워크 및 유틸리티 세트입니다.

이 프레임워크는 개발자가 다음을 할 수 있게 합니다:
- 🤖 시장을 분석하고 자동으로 거래를 실행하는 AI 에이전트 구축
- 📊 실시간 시장 데이터를 위한 Polymarket API 통합
- 🔍 정보에 입각한 거래 결정을 위한 RAG(검색 증강 생성) 사용
- 📰 베팅 서비스, 뉴스 제공업체, 웹 검색에서 데이터 소싱
- 🧠 프롬프트 엔지니어링 및 시장 분석을 위한 포괄적인 LLM 도구 활용

🔗 **GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---

## Polymarket이란?

**Polymarket**은 사용자가 실제 세계 이벤트의 결과를 거래할 수 있는 분산형 예측 시장 플랫폼입니다:

- **정치** — 선거 결과, 정책 결정
- **암호화폐** — 비트코인 가격 예측, ETF 승인
- **스포츠** — 경기 결과, 챔피언십 우승자
- **과학** — 연구 돌파구, 우주 임무
- **엔터테인먼트** — 수상자, 박스오피스 결과

거래자는 예측에 따라 "예" 또는 "아니오" 주식을 구매하며, 가격은 시장의 합의 확률을 반영합니다.

---

## 핵심 기능

| 기능 | 설명 |
|------|------|
| **Polymarket API 통합** | 시장 데이터, 주문장, 거래 실행에 대한 전체 액세스 |
| **AI 에이전트 유틸리티** | 자율 거래 에이전트 구축을 위한 도구 |
| **로컬 및 원격 RAG** | 뉴스 및 시장 데이터 검색을 위한 벡터 데이터베이스 지원 |
| **다중 소스 데이터** | 베팅 서비스, 뉴스 API, 웹 검색 통합 |
| **LLM 프롬프트 엔지니어링** | 맥락 인식 추론을 위한 포괄적인 도구 |
| **CLI 인터페이스** | 시장 분석 및 거래를 위한 명령줄 도구 |
| **Docker 지원** | 쉬운 설정을 위한 컨테이너화된 배포 |
| **MIT 라이선스** | 무료 오픈소스 |

---

## 아키텍처

Polymarket Agents는 개별 커뮤니티 멤버가 유지 관리하고 확장할 수 있는 모듈식 구성 요소를 특징으로 합니다:

### 핵심 API

| 구성 요소 | 목적 |
|-----------|------|
| **Chroma.py** | 뉴스 소스 및 API 데이터를 위한 벡터 데이터베이스 |
| **Gamma.py** | 시장 메타데이터를 가져오기 위한 Polymarket Gamma API 클라이언트 |
| **Polymarket.py** | 시장 데이터 및 거래 실행을 위한 주요 API 클래스 |
| **Objects.py** | 거래, 시장, 이벤트를 위한 Pydantic 데이터 모델 |

### CLI 명령

Polymarket과 상호작용하기 위한 주요 사용자 인터페이스:

```bash
# 거래량별로 정렬된 모든 시장 가져오기
python scripts/python/cli.py get-all-markets --limit 10 --sort-by volume

# 특정 시장 세부 정보 가져오기
python scripts/python/cli.py get-market --market-id <MARKET_ID>

# 거래 실행
python scripts/python/cli.py trade --market-id <MARKET_ID> --side buy --size <SIZE>
```

---

## 빠른 시작

### 1. 저장소 클론

```bash
git clone https://github.com/polymarket/agents.git
cd agents
```

### 2. 환경 설정

```bash
# 가상 환경 생성
virtualenv --python=python3.9 .venv
source .venv/bin/activate

# 의존성 설치
pip install -r requirements.txt
```

### 3. API 키 구성

`.env` 파일 생성:

```env
POLYGON_WALLET_PRIVATE_KEY="귀하의 지갑 개인 키"
OPENAI_API_KEY="귀하의 OpenAI API 키"
```

### 4. 지갑에 USDC 충전

거래를 위해 Polygon 지갑으로 USDC를 이체합니다.

### 5. CLI 실행

```bash
# Python 경로 설정
export PYTHONPATH="."

# CLI 실행
python scripts/python/cli.py
```

또는 직접 거래 실행:

```bash
python agents/application/trade.py
```

### 6. Docker 대안

```bash
./scripts/bash/build-docker.sh
./scripts/bash/run-docker-dev.sh
```

---

## 거래 전략

Polymarket Agents는 다양한 AI 기반 거래 전략을 지원합니다:

### 1. 뉴스 기반 거래
- 이벤트 진행 상황을 위한 뉴스 소스 모니터링
- 감정 및 영향 분석을 위한 LLM 사용
- 예측 결과에 기반한 거래 실행

### 2. 차익 거래 감지
- 관련 시장 간 가격 비교
- 잘못定价된 확률 식별
- 무위험 차익 거래 실행

### 3. 추세 추종
- 시장 거래량 및 가격 변동 분석
- 특정 시장의 모멘텀 식별
- 추세를 따라 수익 확보

### 4. 기본적 분석
- 이벤트 배경 및 요인 연구
- RAG를 사용한 역사적 데이터 쿼리
- 정보에 입각한 예측 수행

---

## 데이터 소스

프레임워크는 여러 데이터 소스를 통합합니다:

| 소스 | 유형 | 사용 사례 |
|------|------|----------|
| **뉴스 API** | 실시간 뉴스 | 이벤트 추적 |
| **웹 검색** | 일반 정보 | 배경 연구 |
| **베팅 서비스** | 배당률 비교 | 가격 발견 |
| **소셜 미디어** | 감정 분석 | 트렌드 감지 |
| **온체인 데이터** | 거래 데이터 | 시장 인텔리전스 |

---

## RAG 구현

정보에 입각한 거래를 위한 검색 증강 생성:

1. **벡터 데이터베이스** — Chroma DB가 뉴스 기사 및 시장 데이터 저장
2. **임베딩** — 의미 검색을 위해 텍스트를 벡터로 변환
3. **검색** — 시장 맥락에 기반한 관련 정보 쿼리
4. **생성** — LLM이 검색된 데이터를 거래 결정으로 종합

---

## 리스크 관리

자동 거래에 대한 중요 고려사항:

| 리스크 | 완화 조치 |
|------|-----------|
| **시장 리스크** | 포지션 크기 조정, 손절매 |
| **유동성 리스크** | 높은 거래량 시장에서 거래 |
| **모델 리스크** | 실제 거래 전 전략 백테스트 |
| **운영 리스크** | 봇 성능 정기 모니터링 |
| **규제 리스크** | 현지 규정 준수 |

---

## 다른 도구와 비교

| 기능 | Polymarket Agents | 커스텀 봇 | 수동 거래 |
|------|------------------|----------|----------|
| **오픈소스** | ✅ | 다양함 | 해당 없음 |
| **AI 통합** | ✅ | 선택적 | ❌ |
| **RAG 지원** | ✅ | 드묾 | ❌ |
| **다중 소스 데이터** | ✅ | 선택적 | ❌ |
| **CLI 인터페이스** | ✅ | 다양함 | 해당 없음 |
| **커뮤니티** | ✅ | 다양함 | ❌ |
| **속도** | 빠름 | 빠름 | 느림 |
| **감정 없음** | ✅ | ✅ | ❌ |

---

## 사용 사례

### 1. 정치 이벤트 거래
- 선거 결과
- 정책 결정
- 입법 투표

### 2. 암호화폐 시장 예측
- 비트코인 가격 움직임
- ETF 승인
- 규제 결정

### 3. 스포츠 베팅
- 경기 결과
- 챔피언십 우승자
- 선수 성과

### 4. 엔터테인먼트 시장
- 수상자
- 박스오피스 예측
- 리얼리티 쇼 결과

---

## 관련 저장소

| 저장소 | 목적 |
|--------|------|
| [py-clob-client](https://github.com/Polymarket/py-clob-client) | Polymarket CLOB용 Python 클라이언트 |
| [python-order-utils](https://github.com/Polymarket/python-order-utils) | 주문 생성 및 서명 |
| [clob-client](https://github.com/Polymarket/clob-client) | CLOB용 TypeScript 클라이언트 |
| [Langchain](https://github.com/langchain-ai/langchain) | 맥락 인식 추론 |
| [Chroma](https://docs.trychroma.com) | 벡터 데이터베이스 |

---

## 읽을 자료

- [예측 시장: 병목 현상과 다음 주요 해결책](https://mirror.xyz/1kx.eth/jnQhA56Kx9p3RODKiGzqzHGGEODpbskivUUNdd7hwh0)
- [암호화폐 + AI 애플리케이션](https://vitalik.eth.limo/general/2024/01/30/cryptoai.html) 작성자: Vitalik Buterin
- [슈퍼예측](https://hbr.org/2016/05/superforecasting-how-to-upgrade-your-companys-judgment)

---

## 관련 기사

- [28 Tools Behind a $1M Polymarket Trading Bot: Full Stack Breakdown](/kr/resources/dev-utils/polymarket-trading-bot-stack/) — 완전한 거래 봇 아키텍처
- [Free Claude Code: Claude Code CLI를 무료로 사용할 수 있는 오픈소스 프록시 도구](/kr/resources/ai-tools/free-claude-code-open-source-proxy/) — AI 코딩 어시스턴트

---

## 결론

**Polymarket Agents**는 예측 시장에서 AI 기반 거래 봇을 구축하기 위한 견고한 기반을 제공합니다. 모듈식 아키텍처, 포괄적인 API 통합 및 RAG 기능은 초보자와 경험丰富的 개발자 모두에게 적합합니다.

**가장 적합한 대상**: 알고리즘 거래, 예측 시장, AI 기반 의사결정에 관심 있는 개발자

**GitHub**: [https://github.com/Polymarket/agents](https://github.com/Polymarket/agents)

---


---

## 자체 호스팅 추천 인프라

24/7 안정 운영을 위해 인프라 선택이 중요하다:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 60일 $200 크레딧, 글로벌 14+ 리전. 오픈소스 AI 도구 자체 호스팅에 적합.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 홍콩 VPS, 중국 본토 접근 시 저지연. dibi8.com 자체가 호스팅된 검증된 IDC.

*추천 링크입니다. 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

*마지막 업데이트: 2026-05-06*
