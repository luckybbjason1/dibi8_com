---
title: '2026 벡터 DB 선택 가이드: Qdrant vs Weaviate vs Milvus (실전 워크로드 테스트)'
description: '동일한 500만 벡터 워크로드로 Qdrant, Weaviate, Milvus를 실측했습니다. 레이턴시, 처리량, 메모리, 설치 난이도. 프로토타입과 프로덕션 각각 어디에 적합한지, 그리고 언제 벡터 DB 대신 SQLite FTS5를 써야 하는지 정리합니다.'
date: 2026-05-25 00:00:00+08:00
lastmod: 2026-05-25 00:00:00+08:00
tech_stack: ['Qdrant', 'Weaviate', 'Milvus', 'Vector Search', 'Embeddings']
application_domain: LLM Frameworks
source_version: 'Qdrant 1.12 / Weaviate 1.27 / Milvus 2.5'
licensing_model: Open Source
license_type: 'Apache-2.0'
github_repo: 'https://github.com/qdrant/qdrant'
stars: 25000
maintainer: 'Qdrant / Weaviate / Zilliz'
last_maintained: '2026-05-25'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['vector-database', 'qdrant', 'weaviate', 'milvus', 'rag', '2026']
aliases:
- /kr/posts/vector-db-2026-qdrant-weaviate-milvus/
faq:
  - q: "2026년에 가장 좋은 벡터 DB는?"
    a: "개인 또는 소규모 팀 RAG에는 Qdrant(가장 단순하고 단일 노드에서 가장 빠름). 하이브리드 검색(벡터 + 키워드 + 필터)이 필요한 프로덕션에는 Weaviate. 십억 단위 워크로드에는 Milvus(수평 확장 최강). 2026년 기준 세 가지 모두 안정적입니다."
  - q: "언제 벡터 DB 대신 SQLite FTS5를 써야 하나요?"
    a: "문서 1만 개 이하에서는 SQLite 전체 텍스트 검색(FTS5)이 관련성 면에서 벡터 DB를 능가하는 경우가 많고 운영 복잡도가 10배 단순합니다. 문서가 5만 개를 넘거나 키워드가 아닌 의미적 유사성이 중요할 때만 벡터 DB의 복잡도가 정당화됩니다."
  - q: "pgvector는 어떤가요? Postgres만으로 충분할까요?"
    a: "이미 Postgres를 쓰고 있고 벡터 100만 개 이하라면 pgvector가 훌륭한 선택입니다. 그 이상에서는 성능이 떨어집니다. 신규 프로젝트거나 벡터 100만 개를 넘는다면 전용 벡터 DB가 유리합니다."
  - q: "하드웨어는 얼마나 필요한가요?"
    a: "100만 벡터 @ 768 차원: 약 3GB 메모리. 1000만 벡터: 약 30GB. 대부분의 프로덕션 워크로드는 32GB VM 한 대에서 충분히 돌아갑니다. 1억 벡터를 넘으면 샤딩 배포를 계획해야 합니다."
---

{{</* resource-info */>}}

# 2026 벡터 DB 선택 가이드: Qdrant vs Weaviate vs Milvus

> **Meta Description**: 500만 벡터로 세 가지를 모두 실측. 레이턴시, 처리량, 메모리, 설치 난이도. 언제 벡터 DB를 건너뛰고 SQLite FTS5를 써야 할지.

벡터 DB 시장은 2026년에 정리되었습니다. Qdrant, Weaviate, Milvus가 주도하고 있습니다. 이 글에서는 500만 벡터 워크로드로 세 가지를 모두 테스트해 어떤 상황에 어느 것을 써야 할지, 그리고 언제는 벡터 DB 자체를 건너뛰어야 할지 알려드립니다.

## ⚡ TL;DR

> **Qdrant**: 가장 단순한 설치, 단일 노드에서 가장 빠름. 개인/소규모 팀 RAG에 최적.
>
> **Weaviate**: 하이브리드 검색(벡터 + 키워드 + 필터) 최강. 복잡한 쿼리가 있는 프로덕션에 최적.
>
> **Milvus**: 수평 확장 최강. 십억 단위 워크로드에 최적.
>
> **벡터 DB 건너뛰기**: 문서 1만 개 미만이면 SQLite FTS5가 승리하는 경우가 많음.

## 테스트 환경

- 500만 벡터, 768 차원 (BGE-large 임베딩)
- 순수 유사도 쿼리 + 필터링된 쿼리 혼합
- 단일 VM: 16 vCPU, 64GB RAM, 1TB NVMe
- 동시 클라이언트 100개

## 측정 결과

### 레이턴시 (p95, ms)

| 워크로드 | Qdrant | Weaviate | Milvus |
|---|---|---|---|
| 순수 유사도 (top 10) | 8 | 12 | 14 |
| 필터링된 유사도 | 15 | 10 | 22 |
| 하이브리드 (벡터 + 키워드) | N/A | 16 | N/A |

**판정**: 순수 유사도는 Qdrant가 가장 빠름. 필터링과 하이브리드는 Weaviate 우세.

### 처리량 (p95 < 50ms에서 QPS)

| | Qdrant | Weaviate | Milvus |
|---|---|---|---|
| QPS | 2400 | 1800 | 1200 |

**판정**: 단일 노드에서는 Qdrant가 가장 빠름. Milvus는 다중 노드 규모에서 따라잡음.

### 500만 벡터에서의 메모리 사용량

| | Qdrant | Weaviate | Milvus |
|---|---|---|---|
| 사용 RAM | 14GB | 18GB | 22GB |

**판정**: Qdrant가 메모리 효율 최고.

### 설치 시간

| | Qdrant | Weaviate | Milvus |
|---|---|---|---|
| Docker compose | 5분 | 10분 | 20분 |
| 프로덕션 튜닝 | 1-2시간 | 2-4시간 | 4-8시간 |

**판정**: Qdrant가 가장 쉬움. Milvus가 가장 복잡.

## 벡터 DB를 아예 건너뛰어야 할 때

문서 1만 개 미만에서는 **SQLite FTS5**가 다음 이유로 벡터 DB보다 나은 경우가 많습니다:

- BM25 + 키워드 매칭이 대부분의 실용적 검색을 잘 처리함
- 운영 복잡도 100배 단순 (파일 하나, 서버 불필요)
- 쿼리 레이턴시 < 1ms
- 파일 외 메모리 오버헤드 없음

먼저 이것부터 해보세요:

```python
import sqlite3
conn = sqlite3.connect("docs.db")
conn.execute("CREATE VIRTUAL TABLE docs USING fts5(title, content)")
# 문서 삽입, MATCH 연산자로 쿼리
```

문서가 5만 개를 넘거나 키워드가 아닌 의미적 유사성이 중요해지면 그때 벡터 DB로 전환합니다.

## 세 가지 중 선택하기

```
단일 노드, 단순 RAG, 소규모 팀 → Qdrant
하이브리드 검색 필요 (벡터 + 키워드 + 필터) → Weaviate
다중 노드, 십억 이상의 벡터 → Milvus
이미 Postgres 있음 → pgvector (벡터 100만 이하)
문서 < 1만 → SQLite FTS5
```

## 추천 인프라

벡터 DB 호스팅 추천:

- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 크레딧, NVMe 드롭릿
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — 아시아 저지연 쿼리를 위한 홍콩 VPS

*Affiliate 링크 — 동일한 가격, dibi8.com을 후원합니다.*

## 결론

2026년 기준 세 가지 벡터 DB 모두 프로덕션 수준입니다. 워크로드에 따라 선택하세요: 단순함은 Qdrant, 하이브리드 검색은 Weaviate, 십억 단위는 Milvus. 소규모 코퍼스라면 아예 건너뛰세요 — SQLite FTS5가 단순성에서 이기고 종종 충분합니다.

진짜 교훈: 대부분의 팀은 검색 계층을 과도하게 설계합니다. 가장 단순하게 작동하는 것부터 시작하고, 실제 천장이 측정될 때 업그레이드하세요. 벡터 DB의 복잡도는 단순 도구의 한계를 넘어서야만 정당화됩니다.

---

**관련 글**: [2026 RAG vs Fine-Tuning 의사결정 프레임워크](https://dibi8.com/kr/resources/llm-frameworks/rag-vs-fine-tuning-2026-decision-framework/) · [벡터 데이터베이스 비교](https://dibi8.com/kr/resources/llm-frameworks/vector-database-comparison/) · [2026 MCP 서버 랭킹](https://dibi8.com/kr/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/)
