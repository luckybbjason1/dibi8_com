---
title: PostgreSQL에서 EXPLAIN ANALYZE 출력 읽기 - 길을 잃지 않게
description: PostgreSQL EXPLAIN ANALYZE tutorial. Learn query plan interpretation,
  bottleneck detection, and database performance optimization.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- AI
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /ko/posts/reading-explain-analyze-postgres/
faqs:
  - q: 'EXPLAIN ANALYZE 출력에서 상단 줄의 actual time은 무엇을 의미하나요?'
    a: '가장 바깥쪽 노드의 두 번째 actual time 값은 해당 노드가 한 번 실행되는 동안 전체 쿼리에 소요된 실제 벽시계 시간(밀리초 단위)입니다. 그 아래의 모든 노드는 그 총 시간이 어디에 쓰였는지를 세분화해서 보여줍니다.'
  - q: 'EXPLAIN ANALYZE 의 행 수로 잘못된 쿼리 플랜을 어떻게 찾나요?'
    a: 'cost= 섹션의 rows=(플래너 추정값)와 actual time= 섹션의 rows=(실제값)을 비교하세요. 두 값이 10배 이상 차이가 나면 플래너가 오래된 통계를 사용한 것이며, 그 위의 모든 노드가 잘못된 가정을 바탕으로 선택된 것입니다. 이것이 거의 항상 버그의 원인입니다.'
  - q: 'EXPLAIN ANALYZE 에서 특정 노드 하나에만 소요된 시간을 어떻게 계산하나요?'
    a: 'loops=1인 노드의 경우, 자체 소요 시간은 대략 해당 노드의 마지막 행 시간(B)에서 자식 노드들의 마지막 행 시간의 합을 뺀 값입니다. loops=N이 큰 노드는 보고된 시간이 루프당 시간이므로, loops를 곱해야 총 소요 시간이 됩니다.'
  - q: 'EXPLAIN (ANALYZE, BUFFERS)에서 shared hit과 shared read의 차이는 무엇인가요?'
    a: 'shared hit은 이미 Postgres 버퍼 캐시에 있는 페이지 수로 비용이 낮고, shared read는 OS나 디스크에서 가져온 페이지 수로 비용이 높습니다. read가 지배적이라면 데이터가 캐시에 없다는 의미입니다. 쿼리를 두 번 실행해보세요. 두 번째 실행 결과가 정상 상태를 더 잘 반영합니다.'
  - q: '쿼리 플랜의 Sort 또는 Hash 노드에 temp written이 나타나면 무슨 뜻인가요?'
    a: '정렬 또는 해시 작업이 work_mem에 맞지 않아 디스크로 스필된 것을 의미하며, 이로 인해 해당 노드의 시간이 쉽게 10배까지 늘어날 수 있습니다. 해결 방법은 해당 세션의 work_mem을 늘리고 EXPLAIN을 다시 실행하는 것입니다.'
---

{</* resource-info */>}

EXPLAIN ANALYZE 출력은 실제로 중요한 세 숫자를 알기 전까지는 위협적으로 보입니다. 여기 내가 그것들을 읽는 순서와 특정 버그를 가리키는 패턴이 있습니다.

## 실제로 중요한 세 숫자

### 1. **총 실행 시간 (Total Execution Time)**
```
Total runtime: 1234.567 ms
```
가장 중요한 지표입니다. 쿼리가 느리면 여기에서 알려줍니다.

### 2. **실제 행 수 vs 예상 행 수 (Actual vs Estimated Rows)**
```
Seq Scan on users  (cost=0.00..123.45 rows=1000 width=32) (actual time=1.234..567.890 rows=50000 loops=1)
```
거대한 차이는 플래너가 잘못된 가정을 했다는 것을 나타냅니다.

### 3. **버퍼 히트 비율 (Buffer Hit Ratio)**
```
Buffers: shared hit=1000 read=50
```
높은 히트율 = 좋은 캐시 사용, 낮은 히트율 = 디스크 I/O 문제.

## 읽는 순서

1. **아래에서 시작** - 총 실행 시간
2. **위쪽으로 작업** - 가장 비용이 많이 드는 노드 찾기
3. **행 수 추정 확인** - 실제 vs 추정
4. **버퍼 통계 보기** - I/O 패턴

## 일반적인 문제 패턴

### **인덱스 스캔이어야 할 때 순차 스캔**
```
Seq Scan on large_table (cost=1000.00..2000.00 rows=100000 width=32)
```
**해결책**: 적절한 인덱스 추가

### **해시 조인이어야 할 때 중첩 루프**
```
Nested Loop (cost=1000.00..100000.00 rows=1000 width=64)
  -> Seq Scan on users
  -> Index Scan on orders
```
**해결책**: work_mem 증가 또는 쿼리 재작성

### **너무 많은 버퍼 미스**
```
Buffers: shared hit=10 read=1000
```
**해결책**: shared_buffers 증가 또는 쿼리 개선

### **디스크로 정렬 오버플로**
```
Sort Method: external merge  Disk: 16384kB
```
**해결책**: work_mem 증가

## 실제 적용

이러한 통찰은 내가 식별하고 수정하는 데 도움이 되었습니다:
- 누락된 인덱스
- 비효율적인 조인 순서
- 메모리 부족 문제
- 캐시 미스

기억하세요: EXPLAIN ANALYZE는 쿼리 성능 디버거입니다. 그것을 읽는 법을 배우면 추측에 수많은 시간을 절약할 수 있습니다.

---

## 추천 도구

오픈소스 AI 도구 개발/배포 시 권장:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전, AI 워크로드용 원클릭 droplet.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API 프록시. 위의 AI 도구 대부분 (챗봇, 코드 생성, 번역, 검색 등) LLM API 키 필요 — 이 프록시로 안정적인 톱 모델 액세스, 공식 가격의 ~30%.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

