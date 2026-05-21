---
title: '저렴한 LLM 스택 2026: 무료 티어 + 토큰 압축으로 프로덕션 AI를 $0-15/월에 돌리는 법'
description: '실제 AI 워크로드를 $0-15/월로 돌리는 5컴포넌트 스택: Ollama 로컬 + DeepSeek API + Gemini 무료층 + RTK 압축 + 9Router 오케스트레이션. 실제 비용 수학, 작업 유형별 모델 선택, 조립 순서.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - Docker
  - Go
  - Rust
application_domain: Collections
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
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['저렴한 LLM', '무료 티어', '비용 최적화', '스택', '컬렉션']
aliases:
  - /posts/cheap-llm-stack/
---

대부분의 "LLM 비용 최적화" 조언은 "더 싼 모델을 써라"입니다. 이 컬렉션은 더 야심찹니다: **실제 프로덕션 워크로드(코딩 에이전트, 콘텐츠 생성, 검색, 기본 에이전트)를 총 $0-15/월로 처리하는 5컴포넌트 스택.** 취미 셋업이 아니고, "하루 100 요청 정도 괜찮"이 아닙니다. 진짜 매일 쓰는 추론을 SaaS-킬러 가격에.

비결은 단일 도구가 아니라 — 오케스트레이션입니다. 무료 티어는 요청을 캡하지 출력을 캡하지 않습니다. 로컬 모델은 품질을 캡하지 요청을 캡하지 않습니다. 토큰 압축은 청구 지출을 깎습니다. 스마트 라우팅은 각 작업을 가장 저렴한 능력자에 보냅니다. 조합하면, 수학이 우스워집니다.

## TL;DR — 한눈에 보는 스택

| # | 컴포넌트 | 비용 | 역할 | 심층 가이드 |
|---|---|---|---|---|
| 1 | **Ollama**(로컬) | $0 | 무거운/민감한 워크로드 본인 하드웨어 | [Ollama 가이드](/kr/resources/llm-frameworks/ollama/) |
| 2 | **DeepSeek API** | $2-8/월 | 어려운 작업 저렴 추론 ($0.27/M input vs Claude $3) | [DeepSeek vs OpenAI](/kr/resources/llm-frameworks/deepseek-ds4-vs-openai-api/) |
| 3 | **Gemini CLI 무료층** | $0 | 1,000 req/day, 일반 LLM, 무료 | [AI 검색 도구](/kr/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/) |
| 4 | **RTK 프록시** | $0(셀프호스트) | 청구 API 들어가기 전 prompt 20-40% 압축 | [RTK 셋업](/kr/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/) |
| 5 | **9Router** | $0(셀프호스트) | 작업별로 가장 저렴한 능력자에 자동 라우트 | [9Router 가이드](/kr/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |

**월 총 비용**(가볍: 100 calls/day): **$0-3** • **중**(500 calls/day): **$2-8** • **무겁(2000 calls/day): $5-15**

같은 볼륨 순수 API 비교: 각각 $40 / $200 / $800. **프로덕션 스케일에서 20-50× 비용 절감**.

## 1. 왜 "저렴"이 2026에 가능해졌나

지난 12개월에 세 가지 변화:

1. **DeepSeek-V4가 Claude Sonnet 품질을 1/10 가격으로 달성** ($0.27/M vs $3/M input). 80% 작업에서 품질 갭은 문제 안 됨
2. **무료 티어가 진지해짐**: Gemini가 1,000 무료 req/day, GLM-4.6도 무료 티어, OpenRouter가 커뮤니티 후원 무료 모델 로테이션. 합계 예산 ~3,000 무료 콜/day
3. **RTK(Repetition-Token Compression)가 작동**: 순수 중복 토큰 20-40% 제거 (파일 헤더, 시스템 prompt 세션당 10× 반복)

세 개 스택 — 로컬 페일오버 + 저렴 API + 무료 티어 로테이션 + 압축 — 저렴-품질 프런티어가 극적으로 이동.

## 2. 아키텍처 — 스마트 라우터 패턴

```
   당신 앱
       │
       ▼
   9Router (각 콜이 어디 갈지 결정)
       │
       ├─► 로컬 Ollama         (민감 / 오프라인 / 드래프트)
       │
       ├─► RTK 프록시 → DeepSeek (품질 필요 어려운 작업, 압축됨)
       │
       ├─► Gemini 무료 티어     (1k req/day, 쉬운 작업)
       │
       └─► OpenRouter 무료     (로테이션 커뮤니티 모델, 실험)
```

각 프로바이더에 "전문 구역". 9Router(또는 새 서비스 싫으면 10줄 Python 래퍼)가 작업 검사 후 라우팅.

## 3. 컴포넌트 1 — Ollama (로컬, $0)

**역할**: 민감한 것, 청구 싫은 것, 드래프트 품질 — 다 여기.

**소비자 하드웨어 현실** (2026 수치):
- **8 GB RAM** (M1 / 미들 PC): Llama 3.2 3B 20+ tok/s — 자동완성, 분류, 드래프트 작성
- **16 GB RAM** (M2/M3 / 괜찮은 PC): Qwen 3 Coder 14B 15 tok/s — 프로덕션 코딩
- **32 GB RAM** (Mac Studio / 워크스테이션): Llama 3.3 70B Q4 8 tok/s — Claude Sonnet급 품질, 인내심 필요

**무료, 영원, rate limit 없음**. 유일한 비용은 머신 돌리는 전기.

전체 설치 + 모델 선택: [Ollama 프로덕션 가이드](/kr/resources/llm-frameworks/ollama/).

## 4. 컴포넌트 2 — DeepSeek API ($2-8/월)

**역할**: 로컬이 부족할 때 기본 유료 프로바이더.

**가격/품질로 모두를 이기는 이유**:
- DeepSeek-V4 input $0.27/M token vs Claude Sonnet $3/M vs GPT-5 $2.50/M
- 코드 벤치마크 Claude Sonnet과 갭: 평균 ~5%
- 오프피크 추가 50% 할인 (UTC 16:30-00:30)

**솔직한 트레이드오프**: 마이너 토픽에서 약간 더 환각. 콜드 스타트 약간 느림. 벌크 추론에서 11× 비용 절감 가치 있음.

**빠른 시작** — platform.deepseek.com 가입, $10 크레딧으로 솔로 dev 2-3개월.

전체 셋업 + DeepSeek *안* 쓸 때: [DeepSeek-V4 vs OpenAI API 비교](/kr/resources/llm-frameworks/deepseek-ds4-vs-openai-api/).

## 5. 컴포넌트 3 — Gemini CLI 무료 티어 ($0)

**역할**: 일반 작업 (Q&A, 요약, 간단 코딩) 무료 1,000 req/day.

**수학**: 1,000 calls/day × 30 days = 30,000 calls/month 무료. UTC 자정 전 다 쓰면 DeepSeek로 페일오버.

**주의**: 무료 티어에서 Google이 "모델 개선" 위해 prompt 로그 — 독점 코드 / PII 보내지 말 것.

**빠른 설치**:
```bash
npm install -g @google/gemini-cli
gemini auth login  # 브라우저 열림, Google 계정 사용
gemini "이 regex 설명: /^[a-z]+$/i"
```

또는 Gemini REST endpoint 직접 호출 — 같은 1,000/day 예산.

동반 개요: Gemini vs Perplexity vs ChatGPT 무료 티어와 각각 강점: [AI 검색 도구 비교](/kr/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/).

## 6. 컴포넌트 4 — RTK 프록시 ($0, 셀프호스트)

**역할**: 앱과 유료 API 사이에 위치. 각 콜 전에 반복 콘텐츠 (시스템 prompt, 파일 헤더, 문서 스니펫) 압축. **코드 변경 없이 청구 20-40% 적어짐.**

**메커니즘**: 시맨틱 dedup. 같은 2,000 토큰 시스템 prompt를 오늘 50번 보내면 RTK가 콜 #2부터 인식하고 전체 텍스트 대신 포인터를 보냄.

**빠른 설치**:
```bash
docker run -d --name rtk -p 8765:8765 \
  ghcr.io/rtk-ai/rtk:latest
```

API base URL을 `https://api.deepseek.com/v1`에서 `http://localhost:8765/v1/deepseek`로 변경. 끝.

RTK 작동 원리 + 벤치마크 전체: [RTK Rust CLI 프록시 + 토큰 세이버](/kr/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/).

## 7. 컴포넌트 5 — 9Router ($0, 셀프호스트)

**역할**: 오케스트레이터. 작업 유형, 잔여 예산, 프로바이더 가용성 기반으로 각 콜이 누구 갈지 결정.

**필요한 이유**: 9Router 없으면 콜마다 수동으로 프로바이더 픽. 9Router로 규칙 한 번 설정 ("코딩 작업 → DeepSeek via RTK, 간단 Q&A → Gemini 무료, fallback → Ollama") 후 잊으면 됨.

**보너스**: 9Router는 premium 프로바이더용 자체 RTK 압축 레이어 포함, 무료 티어 일일 캡 도달 시 자동 페일오버.

**빠른 설치**:
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=ollama,deepseek,gemini,openrouter \
  ghcr.io/rtk-ai/9router:latest
```

전체 설정 + 무료 티어 코딩 콤보 레시피: [9Router 스마트 프록시 가이드](/kr/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/).

## 8. 라우팅 테이블 — 누가 뭘 처리

솔로 dev용 가능한 기본 라우팅 config:

| 작업 유형 | 프로바이더 | 이유 |
|---|---|---|
| 인라인 코드 완성 | **Ollama** (로컬 Qwen 3 Coder 14B) | 레이턴시가 품질보다 중요 |
| 코드 생성 (함수 스코프) | **DeepSeek-V4 via RTK** | 품질 중요, 압축으로 절약 |
| 멀티 파일 리팩토링 | **DeepSeek-V4 via RTK** 또는 **Claude** fallback | 어려운 작업, DeepSeek 막히면 premium |
| 일반 Q&A / 코드 설명 | **Gemini 무료 티어** | 무료, 빠름, 충분 |
| 웹 검색 + 인용 | **Gemini 무료 티어** (내장 grounding) | 무료 vs $20/월 Perplexity Pro |
| 민감 코드 리뷰 | **Ollama** 로컬 | 머신 절대 안 떠남 |
| 벌크 콘텐츠 생성 (1000+ 글) | **DeepSeek-V4 오프피크** | 저렴 × 50% 오프피크 = $0.135/M |
| 간단 에이전트 (Slack 봇, 스케줄러) | **Gemini 무료 티어** | 쉬운 작업, 1k/day 충분 |

## 9. $0-15/월 수학

**가벼운 사용** (솔로 dev, 평균 100 calls/day):
- Gemini 무료 ~70% 커버 → $0
- DeepSeek 나머지 30% (~900 calls/월, 대부분 소량) → $1-3
- Ollama 민감용 (API 비용 없음) → $0
- **합계: $1-3/월** (순수 API $40+ 대비)

**중간 사용** (500 calls/day, 일부 코딩 포함):
- Gemini 무료: 아직 ~1000 calls/day 남음
- DeepSeek 진지한 코딩: ~3000 calls/월 + RTK 압축 → $3-8
- Ollama fallback → $0
- **합계: $3-8/월** (순수 API $200+ 대비)

**무거운 사용** (2000 calls/day, 에이전트 워크플로우):
- Gemini 오전 10시 소진, fallback 가동
- DeepSeek 무거운 로드, RTK 30% 절감 → $5-12
- 오프피크 배치 작업 → 추가 50% 절감
- Ollama 벌크 분류, 민감 처리 → $0
- **합계: $5-15/월** (순수 API $800+ 대비)

## 10. Day 1 셋업 순서 (60분)

1. **Ollama** (15분) — 설치, Llama 3.2 3B + Qwen 3 Coder 14B 풀
2. **DeepSeek 계정** (5분) — 가입, API key 받기, $10 충전
3. **Gemini CLI** (5분) — `npm i -g @google/gemini-cli`, Google 인증
4. **RTK 프록시** (10분) — Docker run, DeepSeek 가리킴
5. **9Router** (10분) — Docker run, 4 프로바이더 설정
6. **라우팅 테스트** (15분) — 5종 다른 작업 발송, 각각 예상 프로바이더 명중 확인

60분 후 머신에 진짜 프로덕션급 저렴 LLM 라우터.

## 11. 업그레이드 시점 (어디로)

$0-15 스택은 다음 중 하나 부딪힐 때까지:

- **레이턴시 요구 < 500ms** — Claude/GPT-5 핫 패스에 추가 (DeepSeek는 배치용 유지)
- **컴플라이언스가 미국 데이터 프로바이더만 요구** — DeepSeek + Gemini 제거, OpenRouter + 프로바이더 필터링 사용 또는 더 셀프호스트
- **벌크 워크로드가 SLA 필요** — 매니지드 LiteLLM 게이트웨이 + 여러 유료 프로바이더 + 재시도 로직 ([LiteLLM 게이트웨이 2026](/kr/resources/llm-frameworks/litellm/) 참조)
- **완전 가시성 원함** — Portkey 추가 ($1k 지출 시 $49 플랫폼 비용, [Portkey vs LiteLLM 2026](/kr/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) 참조)

요점: 이 스택은 *천장*이 아닙니다. *바닥* — 1일차부터 $200/월 SaaS 번들에 강제되지 않고 의도적으로 지출을 늘릴 수 있는 시작점.

## TL;DR — 레시피

**5 도구, $0-15/월, 60분 셋업**:
1. **Ollama** — 로컬 & 민감
2. **DeepSeek-V4** — 어려운 작업 저렴 API
3. **Gemini CLI 무료 티어** — 1k req/day 무료 일반 LLM
4. **RTK 프록시** — 청구 API 토큰 20-40% 절감
5. **9Router** — 스마트 라우팅 오케스트레이터

현재 AI SaaS에 $30+/월 쓰고 있으면 이 스택이 즉시 본전. 노트북에서 돌리면 됨 (저렴 LLM은 VPS 필수 아님 — 단, 팀 항상 켜기 원하면 {{< aff "digitalocean" "footer-cta" "$6/월 DigitalOcean droplet" >}} 도움).

---

*이 컬렉션을 [셀프호스트 AI 코딩 워크플로우](/kr/collections/self-hosted-ai-coding-workflow/)와 함께 — Ollama + 9Router + RTK 세 기초 컴포넌트 공유.*
