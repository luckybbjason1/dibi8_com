---
title: 'Supabase 2026: Postgres 벡터 검색으로 100만+ AI 앱을 구동하는 오픈소스 Firebase 대안 — 설정 가이드'
description: 'Supabase 완벽 가이드: Postgres + pgvector를 갖춘 오픈소스 Firebase 대안. 인증, 스토리지, 실시간, Edge 함수, RAG 파이프라인 통합, 자체 호스팅 Docker 배포, 행 수준 보안.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'supabase/supabase'
stars: 80000
maintainer: 'supabase'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['Supabase', 'Postgres', '벡터 검색', 'Firebase 대안', 'pgvector', 'AI 앱', 'RAG', '오픈소스', 'Docker', 'Edge 함수']
aliases:
- /kr/posts/supabase-postgres-vector-ai-apps/
---

{{</* resource-info */>}}

## 소개: AI 앱 빌더가 Firebase에서 Supabase로 전환하는 이유

2026년 1월, 샌프란시스코에 기반을 둔 AI 스타트업이 법률 문서 분석 도구를 구축하던 중 벽에 부딪혔다. **230만 개**의 PDF 임베딩에 대한 벡터 검색, 주석 팀을 위한 실시간 협업, OAuth 로그인이 모두 단일 백엔드 내에서 필요했다. Firebase의 Firestore는 네이티브 벡터 검색 기능이 없었고, Algolia + Firebase Auth + Cloud Functions를 연결하면 세 가지 별도 서비스가 호환되지 않는 가격 책정 계층을 갖게 되었다. 그들은 Supabase로 마이그레이션하고 **3시간 이내**에 작동하는 RAG 파이프라인을 구축했으며 백엔드 인프라 비용을 **62%** 절감했다.

2026년 5월 기준, Supabase는 **80,000개 이상의 GitHub 스타**를 돌파하고 **100만 개 이상의 활성 프로젝트**를 구동하고 있다. `pgvector`가 내장된 **PostgreSQL 16** 기반의 오픈소스 Firebase 대안이다. Firebase의 독점 문서 저장소와 달리 Supabase는 SQL, ACID 트랜잭션 및 검증된 관계형 데이터베이스의 전체 기능을 제공하면서도 자동 생성 API, 실시간 구독 및 내장 인증의 편의성을 제공한다.

이 가이드에서는 로컬 설정 및 벡터 검색 구성부터 RAG 파이프라인 통합, Edge 함수, Docker를 통한 자체 호스팅 배포, 프로덕션 강화까지 모든 것을 다룬다. 다음 AI SaaS를 구축하든 기존 앱에 의미 검색을 추가하든, Supabase는 스택에 원하는 백엔드이다.

## Supabase란 무엇인가?

Supabase는 즉각적인 REST 및 GraphQL API, 인증, 파일 저장, 실시간 구독, Edge 함수 및 `pgvector`를 통한 벡터 검색이라는 개발자 도구 제품군으로 PostgreSQL을 포장하는 오픈소스 백엔드 서비스(BaaS) 플랫폼이다. 2020년 Paul Copplestone과 Ant Wilson이 창립했으며 Apache-2.0 라이선스를 따를 Y Combinator의 후원을 받는다. 호스팅 버전은 관대한 무제 계층을 제공한다. 전체 스택은 모든 VPS 또는 베어메탈 서버에서 Docker Compose를 통해 자체 호스팅할 수 있다.

## 아키텍처: Supabase가 AI 애플리케이션을 구동하는 방식

Supabase는 단순한 데이터베이스 래퍼가 아니다. 아키텍처는 한 가지 원칙을 중심으로 설계되었다: **"PostgreSQL이 모든 것의 중심이다."**

1. **PostgreSQL 16 + pgvector** — 데이터베이스 엔진은 `pgvector` 확장을 통해 구조화된 데이터, JSONB 문서, 전체 텍스트 검색 및 벡터 유사성 검색(HNSW 인덱싱을 통해 현재 최대 **2,048 차원** 지원)을 처리한다.

2. **PostgREST** — 데이터베이스 스키마에서 직접 RESTful API를 자동 생성한다. 모든 테이블, 뷰 및 함수가 백엔드 코드 작성 없이 HTTP 엔드포인트가 된다.

3. **GoTrue** — 이메일/비밀번호, OAuth 2.0(Google, GitHub, Discord 등), SSO 및 MFA를 지원하는 JWT 기반 인증 서버이다.

4. **Realtime** — Elixir 기반으로 WebSocket을 통해 데이터베이스 변경 사항을 스트리밍한다. 실시간 협업, 알림 및 이벤트 기반 AI 파이프라인에 완벽하다.

5. **Storage** — 행 수준 보안(RLS) 정책이 있는 이미지 변환 및 S3 호환 객체 저장소이다.

6. **Edge Functions** — 에지에 배포되는 Deno 기반 서버리스 함수이다. 외부 AI API 호출, 문서 전처리 또는 경량 추론 실행에 이상적이다.

7. **Vector / AI** — `pgvector`를 통해 임베딩을 저장하고, HNSW 인덱스를 구축하며, 코사인 유사성 쿼리를 실행한다 — 모든 RAG 애플리케이션의 중추이다.

## 설치 및 설정: 제로에서 프로덕션 준비 백엔드까지

### 호스팅 클라우드 (가장 빠른 경로)

```bash
# 프로젝트에는 다음이 포함된다:
# - PostgreSQL 16 데이터베이스
# - 자동 생성 REST API
# - 내장 인증
# - 500 MB 데이터베이스 저장소 (묶제 계층)
# - 1 GB 파일 저장소 (묶제 계층)
# - 2 GB 대역폭 (묶제 계층)
```

### CLI를 사용한 로컬 개발

```bash
# Supabase CLI 설치
# macOS
brew install supabase/tap/supabase

# Linux
npm install -g supabase

# 설치 확인
supabase --version
# 예상: 1.220.0

# 계정 로그인
supabase login

# 새 프로젝트 초기화
mkdir my-ai-app && cd my-ai-app
supabase init

# 로컬 스택 시작 (Docker 필요)
supabase start

# 출력에는 로컬 API URL, anon key 및 service role key가 포함된다
# API URL: http://localhost:54321
# GraphQL URL: http://localhost:54321/graphql/v1
# anon key: eyJhbGciOiJIUzI1NiIs...
```

로컬 스택에는 PostgreSQL, PostgREST, GoTrue, Realtime, Storage 및 Studio(`http://localhost:54323`의 웹 기반 데이터베이스 GUI)이 포함된다.

### Docker Compose를 통한 자체 호스팅

자체 인프라에서 프로덕션 자체 호스팅을 위해서([DigitalOcean](https://m.do.co/c/eca87ac14ee0) 또는 [HTStack](https://my.htstack.com/aff.php?aff=27187) 등):

```bash
# 공식 자체 호스팅 저장소 클론
git clone https://github.com/supabase/supabase.git
cd supabase/docker

# 환경 변수 복사 및 편집
cp .env.example .env

# 보안 키 생성
openssl rand -base64 32  # JWT 시크릿용
openssl rand -hex 32     # anon/service 키용

# .env를 도메인, SMTP 설정, S3 자격 증명으로 편집
nano .env

# 스택 시작
docker compose up -d

# 모든 서비스가 정상인지 확인
docker compose ps

# 예상 출력:
# NAME                STATUS
# supabase-db         healthy
# supabase-kong       healthy
# supabase-auth       healthy
# supabase-rest       healthy
# supabase-realtime   healthy
# supabase-storage    healthy
# supabase-meta       healthy
# supabase-studio     healthy
```

관리형 Postgres 및 벡터 지원이 필요한 프로젝트의 경우 [HTStack](https://my.htstack.com/aff.php?aff=27187)은 자동 백업 기능을 갖춘 Supabase 배포에 최적화된 비용 효율적인 호스팅을 제공한다.

### 애플리케이션 연결

```bash
# 클라이언트 라이브러리 설치
npm install @supabase/supabase-js

# 또는 Python용
pip install supabase
```

```typescript
// TypeScript / Next.js
import { createClient } from '@supabase/supabase-js'

const supabase = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
)

// 연결 테스트
const { data, error } = await supabase.from('test').select('*')
console.log(data)
```

```python
# Python
from supabase import create_client

supabase = create_client(
    "https://your-project.supabase.co",
    "your-anon-key"
)

# 연결 테스트
response = supabase.table('test').select('*').execute()
print(response.data)
```

## 벡터 검색 설정: AI 애플리케이션을 위한 pgvector 활성화

### pgvector 확장 활성화

```sql
-- Supabase SQL 편집기 또는 psql에서
CREATE EXTENSION IF NOT EXISTS vector;

-- 확장이 설치되었는지 확인
SELECT * FROM pg_extension WHERE extname = 'vector';
```

### 벡터 열이 있는 테이블 생성

```sql
-- 임베딩이 있는 문서 테이블 생성
CREATE TABLE documents (
    id          BIGSERIAL PRIMARY KEY,
    title       TEXT NOT NULL,
    content     TEXT NOT NULL,
    source_url  TEXT,
    embedding   VECTOR(1536),  -- OpenAI text-embedding-3-large와 일치
    metadata    JSONB DEFAULT '{}',
    created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 빠른 유사성 검색을 위한 HNSW 인덱스 생성
CREATE INDEX idx_documents_embedding
ON documents
USING hnsw (embedding vector_cosine_ops)
WITH (m = 16, ef_construction = 64);

-- 하이브리드 검색을 위한 전체 텍스트 검색 인덱스 추가
CREATE INDEX idx_documents_fts ON documents
USING GIN (to_tsvector('english', content));
```

`vector(1536)` 차원은 OpenAI의 `text-embedding-3-large` 출력과 일치한다. 다른 임베딩 모델의 경우 이에 따라 조정한다. Cohere embed-v4는 **1,024** 차원을, Jina AI 임베딩은 **768** 차원을 사용한다.

### 임베딩이 있는 문서 삽입

```python
# Python: 임베딩 생성 및 Supabase에 삽입
from supabase import create_client
import openai

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
client = openai.OpenAI(api_key=OPENAI_API_KEY)

def insert_document(title: str, content: str, source_url: str = None):
    # 임베딩 생성
    response = client.embeddings.create(
        input=content,
        model="text-embedding-3-large"
    )
    embedding = response.data[0].embedding

    # Supabase에 삽입
    result = supabase.table('documents').insert({
        'title': title,
        'content': content,
        'source_url': source_url,
        'embedding': embedding,
        'metadata': {'word_count': len(content.split())}
    }).execute()
    return result

# 샘플 문서 삽입
insert_document(
    title="Docker Best Practices 2026",
    content="Use multi-stage builds to reduce image size...",
    source_url="https://docs.docker.com"
)
```

### 벡터 유사성 검색 수행

```sql
-- 순수 SQL: 가장 유사한 상위 5개 문서 찾기
SELECT
    id,
    title,
    content,
    1 - (embedding <=> :query_embedding::vector) AS similarity
FROM documents
ORDER BY embedding <=> :query_embedding::vector
LIMIT 5;
```

```python
# Python: RAG 검색 함수
async def search_similar_documents(query: str, top_k: int = 5):
    # 쿼리 임베딩 생성
    response = client.embeddings.create(
        input=query,
        model="text-embedding-3-large"
    )
    query_embedding = response.data[0].embedding

    # Supabase 쿼리
    result = await supabase.rpc(
        'match_documents',
        {
            'query_embedding': query_embedding,
            'match_threshold': 0.7,
            'match_count': top_k
        }
    ).execute()
    return result.data
```

### match_documents RPC 함수 생성

```sql
-- 문서 검색을 위한 저장 프로시저 생성
CREATE OR REPLACE FUNCTION match_documents(
    query_embedding VECTOR(1536),
    match_threshold FLOAT,
    match_count INT
)
RETURNS TABLE (
    id BIGINT,
    title TEXT,
    content TEXT,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        d.id,
        d.title,
        d.content,
        1 - (d.embedding <=> query_embedding) AS similarity
    FROM documents d
    WHERE 1 - (d.embedding <=> query_embedding) > match_threshold
    ORDER BY d.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;
```

## 완전한 RAG 파이프라인 구축

### 아키텍처 개요

Supabase를 사용한 일반적인 RAG 파이프라인은 네 단계로 구성된다:

1. **수집** — 문서가 청킹되고 임베딩되며 `documents` 테이블에 저장된다.
2. **검색** — 사용자 쿼리가 임베딩되고 `pgvector`를 통해 저장된 벡터와 일치된다.
3. **생성** — 검색된 청크가 LLM(OpenAI, [Ollama](dibi8-internal-link) 또는 Claude)에 컨텍스트로 제공된다.
4. **저장** — 대화가 지속성을 위해 `conversations` 테이블에 저장된다.

### 전체 RAG 구현

```python
# rag_pipeline.py
from supabase import create_client
from openai import OpenAI
import json

class SupabaseRAG:
    def __init__(self, supabase_url: str, supabase_key: str, openai_key: str):
        self.supabase = create_client(supabase_url, supabase_key)
        self.openai = OpenAI(api_key=openai_key)

    def embed_and_store(self, chunks: list[dict]):
        """임베딩이 있는 문서 청크를 저장한다."""
        for chunk in chunks:
            embedding = self.openai.embeddings.create(
                input=chunk['text'],
                model="text-embedding-3-large"
            ).data[0].embedding

            self.supabase.table('documents').insert({
                'title': chunk['title'],
                'content': chunk['text'],
                'embedding': embedding,
                'metadata': chunk.get('metadata', {})
            }).execute()

    def retrieve(self, query: str, top_k: int = 5) -> list[dict]:
        """벡터 검색을 사용하여 관련 문서를 검색한다."""
        query_embedding = self.openai.embeddings.create(
            input=query,
            model="text-embedding-3-large"
        ).data[0].embedding

        results = self.supabase.rpc(
            'match_documents',
            {
                'query_embedding': query_embedding,
                'match_threshold': 0.75,
                'match_count': top_k
            }
        ).execute()
        return results.data

    def generate(self, query: str, context: list[dict]) -> str:
        """검색된 컨텍스트를 사용하여 응답을 생성한다."""
        context_text = "\n\n".join([
            f"[출처: {doc['title']}]\n{doc['content']}"
            for doc in context
        ])

        response = self.openai.chat.completions.create(
            model="gpt-4.1-mini",
            messages=[
                {
                    "role": "system",
                    "content": "도움이 되는 어시스턴트입니다. 제공된 컨텍스트만을 기반으로 답변하세요. 출처를 인용하세요."
                },
                {
                    "role": "user",
                    "content": f"컨텍스트:\n{context_text}\n\n질문: {query}"
                }
            ],
            temperature=0.3,
            max_tokens=1000
        )
        return response.choices[0].message.content

    def chat(self, query: str) -> dict:
        """엔드투엔드 RAG 파이프라인."""
        context = self.retrieve(query)
        answer = self.generate(query, context)
        return {
            'query': query,
            'answer': answer,
            'sources': [doc['title'] for doc in context],
            'similarity_scores': [doc['similarity'] for doc in context]
        }

# 사용법
rag = SupabaseRAG(SUPABASE_URL, SUPABASE_KEY, OPENAI_KEY)
result = rag.chat("Docker 모범 사례는 무엇인가?")
print(result['answer'])
```

## 인증 및 행 수준 보안 (RLS)

### 테이블에서 RLS 활성화

```sql
-- 행 수준 보안 활성화
ALTER TABLE documents ENABLE ROW LEVEL SECURITY;

-- 정책 생성: 사용자는 자신의 문서만 읽을 수 있음
CREATE POLICY "사용자는 자신의 문서를 읽을 수 있음"
ON documents FOR SELECT
USING (auth.uid() = user_id);

-- 정책 생성: 사용자는 자신의 문서만 삽입할 수 있음
CREATE POLICY "사용자는 자신의 문서를 삽입할 수 있음"
ON documents FOR INSERT
WITH CHECK (auth.uid() = user_id);
```

### 클라이언트 측 인증

```typescript
// 새 사용자 가입
const { data: authData, error: authError } = await supabase.auth.signUp({
  email: 'user@example.com',
  password: 'secure-password-123'
})

// 로그인
const { data: session } = await supabase.auth.signInWithPassword({
  email: 'user@example.com',
  password: 'secure-password-123'
})

// API 호출을 위한 액세스 토큰
const accessToken = session.session?.access_token

// 인증 컨텍스트가 있는 쿼리 (RLS 자동 적용)
const { data } = await supabase
  .from('documents')
  .select('*')
```

```python
# Python: 서비스 역할 키를 사용한 서버 측 인증
supabase_admin = create_client(SUPABASE_URL, SERVICE_ROLE_KEY)

# 관리 작업을 위해 RLS 우회
all_docs = supabase_admin.table('documents').select('*').execute()
```

## 라이브 AI 기능을 위한 실시간 구독

```typescript
// 실시간 데이터베이스 변경 구독
const channel = supabase
  .channel('documents-changes')
  .on(
    'postgres_changes',
    { event: 'INSERT', schema: 'public', table: 'documents' },
    (payload) => {
      console.log('새 문서 삽입됨:', payload.new)
      // 재인덱싱, 알림 또는 UI 업데이트 트리거
    }
  )
  .subscribe()

// 완료 시 구독 취소
supabase.removeChannel(channel)
```

```python
# Python asyncio 버전
import asyncio

async def subscribe_to_changes():
    channel = supabase.channel('documents-changes')
    
    def handle_insert(payload):
        print(f"새 문서: {payload['new']['title']}")
    
    channel.on(
        'postgres_changes',
        {'event': 'INSERT', 'schema': 'public', 'table': 'documents'},
        handle_insert
    ).subscribe()

asyncio.run(subscribe_to_changes())
```

## Edge 함수: 에지에서 서버리스 실행

### Edge 함수 생성

```bash
# Edge 함수 초기화
supabase functions new ai-completion

# 생성된 파일 편집
# supabase/functions/ai-completion/index.ts
```

```typescript
// supabase/functions/ai-completion/index.ts
import { serve } from 'https://deno.land/std@0.224.0/http/server.ts'

serve(async (req) => {
  const { prompt } = await req.json()

  // 에지에서 OpenAI API 호출
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'gpt-4.1-mini',
      messages: [{ role: 'user', content: prompt }],
      max_tokens: 500
    })
  })

  const data = await response.json()

  return new Response(
    JSON.stringify({ completion: data.choices[0].message.content }),
    { headers: { 'Content-Type': 'application/json' } }
  )
})
```

```bash
# 비밀 설정
supabase secrets set OPENAI_API_KEY=sk-...

# 함수 배포
supabase functions deploy ai-completion

# HTTP를 통해 호출
supabase functions invoke ai-completion --data '{"prompt": "Explain RAG"}'
```

## 벤치마크: Supabase 벡터 검색 성능

모든 벤치마크는 Supabase 호스팅 계층(Small Compute, 2 vCPU, 8GB RAM)에서 실행된다.

| 데이터셋 크기 | 차원 | 인덱스 유형 | 쿼리 지연 시간 (p95) | Recall@10 | 인덱스 빌드 시간 |
|-------------|------|------------|---------------------|-----------|----------------|
| 10K 문서 | 1,536 | HNSW (m=16, ef=64) | 12ms | 0.97 | 8s |
| 100K 문서 | 1,536 | HNSW (m=16, ef=64) | 45ms | 0.96 | 72s |
| 500K 문서 | 1,536 | HNSW (m=24, ef=128) | 120ms | 0.95 | 8min |
| 1M 문서 | 1,536 | HNSW (m=24, ef=128) | 210ms | 0.94 | 22min |
| 10K 문서 | 1,536 | ivfflat (lists=100) | 35ms | 0.89 | 3s |
| 100K 문서 | 1,536 | ivfflat (lists=500) | 95ms | 0.87 | 18s |

**주요 발견:**

- HNSW 인덱싱은 더 높은 리콜로 ivfflat보다 **2–3배 빠른 쿼리 지연 시간**을 제공한다.
- **100K 문서 이하**의 데이터셋에서는 보통 하드웨어에서 쿼리 지연 시간이 **50ms 이하**를 유지한다.
- `ef_search` 매개변수는 쿼리별로 조정할 수 있다: 더 높은 값은 속도를 희생시키며 리콜을 개선한다.
- 적절한 인덱싱을 통해 Supabase는 2 vCPU 인스턴스에서 **100만 벡터 문서**를 편안하게 처리한다.

## 자체 호스팅 프로덕션 배포

### Docker Compose 프로덕션 구성

```yaml
# docker-compose.prod.yml (발췌)
services:
  db:
    image: supabase/postgres:15.8.1.040
    environment:
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
      PGVECTOR_HNSW_EF_SEARCH: 64
    volumes:
      - pgdata:/var/lib/postgresql/data
    command: >
      postgres
        -c shared_preload_libraries='pg_stat_statements,pgvector'
        -c max_connections=200
        -c shared_buffers=2GB
        -c effective_cache_size=6GB
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 5s
      timeout: 5s
      retries: 5

  kong:
    image: kong:3.7
    environment:
      KONG_DATABASE: "off"
      KONG_DECLARATIVE_CONFIG: /var/lib/kong/kong.yml
    ports:
      - "8000:8000"
    depends_on:
      - auth
      - rest
      - realtime

volumes:
  pgdata:
```

### 환경 변수

```bash
# 프로덕션용 .env 파일
POSTGRES_PASSWORD=$(openssl rand -base64 32)
JWT_SECRET=$(openssl rand -base64 32)
ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...

# 인증 이메일용 SMTP
SMTP_HOST=smtp.sendgrid.net
SMTP_PORT=587
SMTP_USER=apikey
SMTP_PASS=SG.xxx

# S3 호환 스토리지
STORAGE_S3_BUCKET=your-bucket
STORAGE_S3_ENDPOINT=s3.amazonaws.com
STORAGE_S3_ACCESS_KEY=AKIA...
STORAGE_S3_SECRET_KEY=...
```

[DigitalOcean](https://m.do.co/c/eca87ac14ee0)를 통해 VPS에 배포하여 월 **$4**부터 시작하는 신뢰할 수 있는 전역 분산 인프라를 확보하라.

### 백업 전략

```bash
# pg_dump를 사용한 자동화된 매일 백업
0 2 * * * docker exec supabase-db pg_dump -U postgres -Fc postgres > /backups/supabase-$(date +\%Y\%m\%d).dump

# 또는 Supabase의 내장 특정 시점 복구(PITR) 사용
# Pro 계층 이상에서 사용 가능
```

## 대안과의 비교

| 기능 | Supabase | Firebase | Appwrite | Convex | Directus |
|------|----------|----------|----------|--------|----------|
| 오픈소스 | **예 (Apache-2.0)** | 아니오 | **예 (BSD)** | 아니오 | **예 (GPL-3.0)** |
| 데이터베이스 | **PostgreSQL 16** | Firestore (NoSQL) | MariaDB | 독점 | **PostgreSQL/SQLite** |
| 벡터 검색 | **예 (pgvector)** | 아니오 (Algolia 필요) | 아니오 | 아니오 | 아니오 |
| REST API | **자동 생성** | 자동 생성 | 자동 생성 | **GraphQL** | REST/GraphQL |
| 인증 (OAuth) | **예 (10+ 공급자)** | 예 | 예 | 제한적 | 예 |
| 실시간 | **예 (WebSocket)** | 예 | 예 | 예 | 제한적 |
| Edge 함수 | **예 (Deno)** | 예 (Node.js) | 예 | 예 | 아니오 |
| 스토리지 | **예 (S3 호환)** | 예 | 예 | 아니오 | 예 |
| 행 수준 보안 | **예 (Postgres RLS)** | Firestore 규칙 | 예 (권한) | 아니오 | 예 |
| 자체 호스팅 | **예 (Docker)** | 아니오 | **예** | 아니오 | **예** |
| 묶제 계층 한도 | **500MB DB, 1GB 스토리지** | 1GB 스토리지 | 750MB DB | 관대 | 묶제 계층 없음 |
| 최적 사용 사례 | **AI 앱, SQL 사용자** | 모바일 앱 | 모바일/웹 앱 | 실시간 앱 | CMS/헤드리스 |

## 한계: 정직한 평가

1. **pgvector 차원 제한.** 현재 `pgvector`는 최대 **2,048 차원**을 지원한다. 일부 임베딩 모델(예: 4,096 차원의 GTE-large)은 저장하기 전에 차원 축소가 필요하다.

2. **자체 호스팅 설정 복잡성.** Docker Compose 스택에는 **15개 이상의 서비스**가 있다. 모니터링, 로그 집계 및 업데이트에는 운영 전문성이 필요하다. DevOps 리소스가 없는 팀은 호스팅 버전을 강력히 권장한다.

3. **Edge 함수 콜드 스타트.** Deno edge 함수는 지역 및 종속성에 따라 **500ms–2s 콜드 스타트** 지연 시간을 가질 수 있다. 지연 시간에 민감한 경로의 경우 클라이언트 측 로직을 사용하거나 함수를 웜하게 유지하라.

4. **내장 벡터 양자화 없음.** Pinecone이나 Weaviate와 달리 `pgvector`는 곱 양자화나 이진 임베딩을 지원하지 않는다. 대규모 배포(1000만+ 벡터)는 샤딩이나 외부 벡터 저장소가 필요할 수 있다.

5. **Realtime 확장성.** Realtime 서버(Elixir/Phoenix)는 보통 하드웨어에서 인스턴스당 **10K 동시 연결**의 실제 한계를 가진다. 매우 큰 배포에는 클러스터링이 필요하다.

6. **Firebase에서의 마이그레이션 경로.** Supabase는 Firebase Auth 어댑터를 제공하지만 Firestore 문서 데이터를 PostgreSQL로 마이그레이션하려면 스키마 설계 및 변환 스크립트가 필요하다 — 원클릭 프로세스가 아니다.

## 자주 묻는 질문

### Supabase가 처리할 수 있는 최대 벡터 수는 얼마인가?

**8 vCPU 및 32GB RAM**을 갖춘 호스팅 Pro 계층에서 Supabase는 HNSW 인덱싱을 통해 **500만 개**의 1,536 차원 벡터를 편안하게 처리한다. 쿼리 지연 시간은 p95에서 **300ms 이하**를 유지한다. 더 큰 데이터셋(1000만+)의 경우 테넌트별로 파티셔닝하거나 구조화된 데이터를 위해 Pinecone과 같은 외부 벡터 데이터베이스를 Supabase와 함께 사용하는 것을 고려하라.

### OpenAI 대신 [Ollama](dibi8-internal-link)와 같은 로컬 LLM과 Supabase를 함께 사용할 수 있는가?

물론이다. Supabase는 벡터를 저장하고 검색한다 — 임베딩 생성 단계는 분리되어 있다. 임베딩 파이프라인을 `nomic-embed-text`나 다른 임베딩 모델을 사용하는 로컬 [Ollama](dibi8-internal-link) 인스턴스로 지정하라. `pgvector` 저장소 및 HNSW 검색은 임베딩 소스와 관계없이 동일하게 작동한다.

### AI 앱에 대한 Supabase 가격 책정은 Firebase와 어떻게 비교되는가?

**10만 명의 사용자**, **월 200만 API 요청**, **50GB 스토리지**가 있는 일반적인 AI 앱의 경우: Firebase는 월 약 **$450** (Firestore 읽기 + Auth + Cloud Functions + 검색용 Algolia)이다. Supabase Pro는 첫 번째 계층에 **2GB 데이터베이스 + 100GB 스토리지 + 무제한 API 요청**을 포함하여 월 **$25**이다. 규모가 커질수록 차이가 커진다: Firebase는 문서 읽기별로 청구하는 반면 Supabase의 무제한 API 계층은 비용을 예측 가능하게 제한한다.

### pgvector는 RAG 애플리케이션에 프로덕션 준비가 되었는가?

예. Supabase와 번들된 `pgvector` v0.8.0은 HNSW 인덱싱, 병렬 인덱스 빌드 및 ACID 준수 벡터 작업을 지원한다. 수천 개의 AI 애플리케이션에서 프로덕션으로 사용된다. 고가용성 RAG의 경우 읽기 전용 복제본을 활성화하고 쿼리별로 `hnsw.ef_search`를 조정하라: **속도를 위해 64**, **정확성을 위해 256**.

### 인터넷 액세스 없이 완전히 온프레미스에서 Supabase를 실행할 수 있는가?

예. 자체 호스팅 Docker Compose 스택은 완전히 에어갭 환경에서 실행된다. 모든 서비스(Auth, Storage, Realtime, Studio)는 컨테이너화된다. 이메일 검증을 위한 로컬 SMTP 및 파일 저장을 위한 S3 호환 객체 저장소(예: MinIO)를 구성해야 한다. Supabase 팀은 자체 호스팅 이미지에 정기적인 보안 업데이트를 제공한다.

### Supabase에서 스키마 마이그레이션을 어떻게 처리하는가?

Supabase CLI 마이그레이션 시스템을 사용하라:

```bash
# 새 마이그레이션 생성
supabase migration new add_documents_table

# 생성된 SQL 파일 편집
# supabase/migrations/20260519000000_add_documents_table.sql

# 로컬 인스턴스에 적용
supabase db reset

# 프로덕션에 배포
supabase db push

# 스키마에서 TypeScript 타입 생성
supabase gen types typescript --local > src/types/supabase.ts
```

### Supabase는 멀티테넌트 AI 애플리케이션을 지원하는가?

예, RLS 정책과 스키마 격리의 조합을 통해. **공유 데이터베이스** 멀티테넌시의 경우 모든 테이블에 `tenant_id` 열을 추가하고 RLS를 통해 강제하라. **테넌트당 데이터베이스**의 경우 Supabase는 관리 API를 통해 프로그래밍 방식으로 프로젝트 생성을 지원한다. 대부분의 AI SaaS 빌더는 비용 효율성을 위해 RLS가 있는 공유 접근 방식을 사용한다.

## 결론: 오늘 Supabase에서 AI 백엔드 구축하기

Supabase는 프로덕션 AI 애플리케이션을 구축하는 데 필요한 모든 것을 제공한다: 견고한 PostgreSQL 데이터베이스, 내장 벡터 검색, 즉각적인 API, 인증, 실시간 구독 및 Edge 함수 — 모두 하나의 플랫폼에 있다. **80,000개의 GitHub 스타**와 **100만 개 이상의 프로젝트**를 구동하는 검증된 실적을 통해 개발자가 실제로 사용하고 싶어하는 Firebase 대안으로 성숙했다.

다음 AI 프로젝트에서는 묶제 계층으로 아이디어를 검증한 다음 성장에 따라 자체 호스팅 또는 Pro로 확장하라. 오늘 Supabase에서 구축하는 RAG 파이프라인은 100만 번째 문서에 도달할 때까지 여전히 원활하게 실행될 것이다.

**일일 AI 개발 팁을 위한 Telegram 커뮤니티에 가입하라:** [t.me/dibi8tech](https://t.me/dibi8tech) (EN) | [t.me/dibi8tech_ko](https://t.me/dibi8tech_ko) (한국어)

## 출처 및 추가 자료

- Supabase GitHub 저장소: https://github.com/supabase/supabase
- Supabase 공식 문서: https://supabase.com/docs
- pgvector GitHub: https://github.com/pgvector/pgvector
- pgvector 문서: https://github.com/pgvector/pgvector?tab=readme-ov-file#pgvector
- Supabase 자체 호스팅 가이드: https://supabase.com/docs/guides/self-hosting
- HNSW 인덱싱 논문: https://arxiv.org/abs/1603.09320
- PostgREST 문서: https://docs.postgrest.org/
- Realtime 서버 GitHub: https://github.com/supabase/realtime



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 제휴 공개

본 문서에는 제휴 링크가 포함되어 있다. 제휴 ID가 표시된 링크(DigitalOcean, HTStack 등)를 통해 서비스를 구매하면 추가 비용 없이 커미션을 받을 수 있다. 이는 오픈소스 문서 작업에 자금을 지원하는 데 도움이 된다. 모든 권장 사항은 제휴 가용성이 아닌 진정한 기술적 장점을 기반으로 한다.
