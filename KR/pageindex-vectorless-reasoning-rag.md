---
title: "PageIndex：29K⭐벡터 없는 RAG 시스템, 문서 검색의 혁명"
description: "PageIndex는 VectifyAI가 개발한 오픈소스 벡터 없는 RAG 시스템입니다. 29K+ Stars, 문서 트리 구조를 통해 인간과 같은 검색을 구현하며 FinanceBench에서 98.7% 정확도를 달성했습니다."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "23.7 MB"
file_md5: ""
download_url: "https://github.com/VectifyAI/PageIndex"
backup_url: ""
github_repo: "https://github.com/VectifyAI/PageIndex"
stars: 31643
maintainer: "VectifyAI"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /kr/posts/pageindex-vectorless-reasoning-rag/
faqs:
  - q: 'PageIndex란 무엇이며 기존 RAG와 어떻게 다른가요?'
    a: 'PageIndex는 VectifyAI에서 만든 오픈소스 RAG 시스템으로, 벡터 데이터베이스 없이 정보를 검색합니다. 문서를 임베딩하거나 청킹하는 대신, 각 문서를 계층적 트리 구조로 구축하고 LLM 추론을 사용해 이를 탐색합니다. 이는 인간 전문가가 목차를 보고 관련 섹션을 찾는 방식을 모방한 것입니다.'
  - q: 'PageIndex는 벡터 데이터베이스나 문서 청킹이 필요한가요?'
    a: '아닙니다. PageIndex는 두 가지 모두 없앴습니다. 벡터 임베딩을 저장하지 않아 값비싼 벡터 저장 비용을 피하며, 문서를 청킹하지 않아 문서를 잘라내는 대신 본래의 논리적 구조를 그대로 보존합니다.'
  - q: 'PageIndex는 FinanceBench 벤치마크에서 얼마나 정확한가요?'
    a: 'PageIndex를 GPT-4와 결합하면 FinanceBench에서 98.7%의 정확도를 달성하며, 이는 state-of-the-art 수준의 결과입니다. PageIndex와 Claude-3을 결합하면 97.2%에 도달하는 반면, 기존 벡터 RAG는 같은 벤치마크에서 약 79-82%의 점수를 기록합니다.'
  - q: 'PageIndex를 설치하고 기본 쿼리를 실행하려면 어떻게 하나요?'
    a: '`pip install pageindex`로 설치합니다. 그런 다음 `pi = PageIndex()`로 초기화하고, `pi.load_pdf("file.pdf")`로 문서를 불러온 뒤, `result = pi.query("your question")`으로 쿼리합니다. 결과에는 답변과 함께 페이지 번호, 챕터 등의 인용 출처가 포함됩니다.'
  - q: 'PageIndex는 어떤 종류의 문서에 가장 적합한가요?'
    a: 'PageIndex는 구조가 중요하고 설명 가능한 인용이 필요한 길고 전문적인 문서를 위해 설계되었습니다. 예를 들어 재무 보고서와 사업설명서, 법률 계약서와 판례법, 의학 문헌과 임상시험 보고서, 그리고 API 레퍼런스나 운영 매뉴얼 같은 기술 문서 등이 있습니다.'
---
{</* resource-info */>}

![PageIndex 공식 hero 배너](/images/articles/pageindex-vectorless-reasoning-rag/banner.png)
*출처: [github.com/VectifyAI/PageIndex](https://github.com/VectifyAI/PageIndex) — 공식 배너*

## PageIndex란?

**PageIndex**는 **VectifyAI**가 개발한 오픈소스 RAG(검색 증강 생성) 시스템으로, 전통적인 문서 검색 방식을 완전히 바꿉니다. 전통적인 벡터 데이터베이스와 달리 PageIndex는 **추론 기반** 접근 방식을 사용하여 문서의 **계층적 트리 구조**를 구축함으로써 인간과 같은 검색을 구현합니다.

- 🌲 **트리 구조 인덱스** — 목차처럼 문서를 구성
- 🧠 **추론 기반 검색** — LLM 추론, 벡터 유사도가 아님
- ❌ **벡터 데이터베이스 불필요** — 비싼 벡터 저장 비용 절감
- ❌ **청킹 불필요** — 문서의 자연스러운 구조 유지
- 📊 **98.7% 정확도** — FinanceBench 벤치마크 SOTA

GitHub: https://github.com/VectifyAI/PageIndex  
Stars: **29,202+** | 언어: Python | 라이선스: Apache-2.0

---

## 왜 전통적인 RAG가 충분하지 않은가?

### 전통적인 벡터 RAG의 문제점

| 문제 | 설명 |
|------|------|
| **유사도 ≠ 관련성** | 벡터 검색은 의미적으로 유사한 것을 찾지만, 실제로 관련된 것은 아닐 수 있음 |
| **청킹이 구조를 파괴** | 강제 청킹은 문서의 논리적 구조를 끊음 |
| **블랙박스 검색** | 벡터 검색은 해석 불가능하며, 왜 이 결과가 반환되었는지 추적할 수 없음 |
| **비용이 높음** | 벡터 데이터베이스 유지, 저장 및 계산 비용이 많이 듦 |
| **긴 문서에서 효과가 떨어짐** | 전문적인 긴 문서(재무 보고서, 법적 파일) 검색 정확도가 낮음 |

### PageIndex의 해결책

PageIndex는 **인간 전문가**가 문서를 읽는 방식을 모방합니다:
1. 먼저 목차 구조(트리 인덱스)를 확인
2. 질문에 따라 어떤 장으로 가야 할지 추론
3. 관련 장에서 깊이 찾아보기

---

## 핵심 기술 원리

### 1. 문서 트리 구조 생성

PageIndex는 PDF를 계층적 트리 구조로 변환합니다:

```json
{
  "title": "Financial Stability",
  "node_id": "0006",
  "start_index": 21,
  "end_index": 22,
  "summary": "The Federal Reserve monitors financial vulnerabilities...",
  "nodes": [
    {
      "title": "Monitoring Financial Vulnerabilities",
      "node_id": "0007",
      "start_index": 22,
      "end_index": 28
    }
  ]
}
```

### 2. 추론 기반 트리 검색

사용자가 질문하면 LLM은 다음을 수행합니다:
1. **질문 이해** — 쿼리 의도 분석
2. **트리 구조 탐색** — 어떤 노드에 답이 있을지 추론
3. **관련 노드 심층 탐색** — 후보 노드에서 구체적인 정보 찾기
4. **결과 반환** — 출처 인용(페이지, 장)과 함께

### 3. AlphaGo와 유사한 몬테카를로 트리 검색

PageIndex는 AlphaGo에서 영감을 받아 **트리 검색 알고리즘**을 사용합니다:
- **선택** — 가장 유망한 노드 선택
- **확장** — 하위 노드 펼치기
- **평가** — LLM이 노드 관련성 평가
- **역전파** — 노드 가중치 업데이트

---

## 빠른 시작

### 설치

```bash
# 저장소 클론
git clone https://github.com/VectifyAI/PageIndex.git
cd PageIndex

# 의존성 설치
pip3 install --upgrade -r requirements.txt
```

### API Key 설정

```bash
# .env 파일 생성
echo "OPENAI_API_KEY=your_openai_key_here" > .env
```

### 문서 트리 생성

```bash
# PDF용 PageIndex 트리 구조 생성
python3 run_pageindex.py --pdf_path /path/to/your/document.pdf
```

### 선택적 매개변수

```bash
--model                  # LLM 모델 (기본: gpt-4o-2024-11-20)
--toc-check-pages       # 목차 확인 페이지 (기본: 20)
--max-pages-per-node    # 노드당 최대 페이지 (기본: 10)
--max-tokens-per-node   # 노드당 최대 토큰 (기본: 20000)
--if-add-node-summary   # 노드 요약 추가 (기본: yes)
```

---

## 실전 예시

### 예시 1: 금융 문서 분석

```python
from pageindex import PageIndex

# 문서 트리 로드
pi = PageIndex(tree_path="financial_report.json")

# 쿼리
result = pi.query(
    "Q3 매출 성장률은 얼마였나요?",
    top_k=3
)

print(result.answer)
# "Q3 매출은 전년 동기 대비 23% 성장했으며, 클라우드 서비스가 주도..."

print(result.sources)
# [{"page": 45, "section": "Financial Results", "node_id": "0012"}]
```

### 예시 2: 법률 계약 검토

```python
# 계약 문서 로드
pi = PageIndex(tree_path="contract.pdf.json")

# 특정 조항 쿼리
result = pi.query(
    "7조의 해지 조건은 무엇인가요?"
)

# PageIndex가 자동으로 관련 장을 찾아줍니다
```

### 예시 3: 학술 논문 연구

```python
# 논문 로드
pi = PageIndex(tree_path="paper.pdf.json")

# 장 간 추론 쿼리
result = pi.query(
    "3장의 방법론이 5장의 결과와 어떻게 관련이 있나요?"
)

# PageIndex가 트리 구조를 탐색하여 연관 정보를 찾습니다
```

---

## 경쟁사 비교

| 특성 | PageIndex | 전통 벡터 RAG | LlamaIndex | LangChain |
|------|-----------|---------------|------------|-----------|
| 벡터 데이터베이스 | ❌ 불필요 | ✅ 필수 | ✅ 필수 | ✅ 필수 |
| 청킹 | ❌ 불필요 | ✅ 필수 | ✅ 필수 | ✅ 필수 |
| 추론 기반 | ✅ | ❌ | ❌ | ❌ |
| 해석 가능성 | ✅ 추적 가능 | ❌ 블랙박스 | ⚠️ 부분적 | ⚠️ 부분적 |
| 긴 문서 | ✅ 우수 | ⚠️ 보통 | ⚠️ 보통 | ⚠️ 보통 |
| 전문 문서 | ✅ 우수 | ⚠️ 보통 | ⚠️ 보통 | ⚠️ 보통 |
| 정확도 | ✅ 98.7% | ~75% | ~80% | ~78% |

---

## 비즈니스 모델과 수익 기회

### 1. 엔터프라이즈 문서 분석

PageIndex의 Apache-2.0 라이선스는 상업적 사용을 허용합니다:
- **금융 분석** — 재무 보고서, SEC 파일 자동 분석
- **법률 상담** — 계약 검토, 사례 연구
- **의료 문서** — 병록 분석, 의학 문헄
- **정부 파일** — 정책 분석, 법규 검색

### 2. SaaS 제품 구축

PageIndex 기반으로 다음을 구축:
- **지능형 문서 Q&A 플랫폼**
- **엔터프라이즈 지식 베이스 시스템**
- **자동 보고서 생성기**
- **컴플라이언스 검토 도구**

### 3. 컨설팅 서비스

PageIndex 관련 다음을 제공:
- **기술 컨설팅**
- **맞춤형 개발**
- **교육 서비스**

---

## 성능 벤치마크

### FinanceBench 테스트 결과

| 시스템 | 정확도 |
|--------|--------|
| **PageIndex (Mafin 2.5)** | **98.7%** |
| 전통 벡터 RAG | ~75% |
| 기타 상업 솔루션 | ~80% |

PageIndex는 금융 문서 Q&A에서 **state-of-the-art**를 달성하여 추론 기반 검색의 우수성을 입증했습니다.

---

## 배포 옵션

### 1. 자체 호스팅 (오픈소스)

```bash
git clone https://github.com/VectifyAI/PageIndex.git
pip3 install -r requirements.txt
python3 run_pageindex.py --pdf_path your.pdf
```

적합: 기술 팀, 데이터 민감한 시나리오

### 2. 클라우드 서비스

- **Chat 플랫폼**: https://chat.pageindex.ai
- **API**: https://pageindex.ai/developer
- **MCP 통합**: Claude, Cursor 등 지원

적합: 빠른 시작, 프로덕션 환경

### 3. 엔터프라이즈 버전

- 프라이빗 배포
- 맞춤형 OCR 파이프라인
- 전담 지원

---

## 커뮤니티와 리소스

- **GitHub**: https://github.com/VectifyAI/PageIndex
- **문서**: https://docs.pageindex.ai
- **블로그**: https://pageindex.ai/blog
- **Discord**: https://discord.com/invite/VuXuf29EUj
- **API**: https://pageindex.ai/developer

---

## 요약

PageIndex는 RAG 기술의 차세대 진화입니다:

✅ **29K+ Stars** — 커뮤니티 인정  
✅ **벡터 DB 불필요** — 비싼 인프라 비용 절감  
✅ **추론 기반** — 문서 구조를 진정으로 이해  
✅ **98.7% 정확도** — 업계 최고  
✅ **해석 가능** — 모든 검색이 추적 가능  
✅ **오픈소스** — Apache-2.0, 상업 친화적  

**누구에게 적합한가?**
- 금융 분석가: 재무 보고서, SEC 파일 처리
- 법률 고문: 계약 검토, 법규
- 연구원: 논문, 문헄 분석
- 개발자: 문서 AI 애플리케이션 구축

**시작하기**: https://github.com/VectifyAI/PageIndex

---

## Related Articles

- [Goose AI Agent: 코드와 자동화를 위한 오픈소스 AI 에이전트](/kr/resources/llm-frameworks/goose-ai-agent-open-source-automation/) — 또 다른 오픈소스 AI 도구
- [Free Claude Code: Claude Code CLI를 무료로 사용하는 오픈소스 프록시 도구](/kr/resources/ai-tools/free-claude-code-open-source-proxy/) — AI 코딩 도구
- [Agent Reach: AI 에이전트를 인터넷에 연결하세요](/kr/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — AI를 인터넷에 연결
- [42 Real-World OpenClaw Use Cases: 사람들이 일상에서 AI 에이전트를 사용하는 방법](/kr/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) — AI 에이전트 사용 사례

---


---

## 자체 호스팅 추천 인프라

24/7 안정 운영을 위해 인프라 선택이 중요하다:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 60일 $200 크레딧, 글로벌 14+ 리전. 오픈소스 AI 도구 자체 호스팅에 적합.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 홍콩 VPS, 중국 본토 접근 시 저지연. dibi8.com 자체가 호스팅된 검증된 IDC.

*추천 링크입니다. 추가 비용 없이 dibi8.com 운영에 도움이 됩니다.*

*Last updated: 2026-05-07*
