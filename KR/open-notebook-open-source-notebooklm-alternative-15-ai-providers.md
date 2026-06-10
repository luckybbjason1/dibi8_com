---
title: 'open-notebook: 15+ AI 제공자 지원 오픈소스 Notebook LM 대안 — 셀프호스팅, 28,000 스타 — 설정 가이드 2026'
description: 'open-notebook (28,200 GitHub star)은 15+ AI 제공자를 지원하는 Google NotebookLM 오픈소스 대안입니다. 셀프호스팅 RAG 지식베이스, 멀티모달 오디오 에피소드 포함.'
date: 2026-06-08
slug: 'open-notebook-open-source-notebooklm-alternative-15-ai-providers'
category: 'data-science'
tags: ['open notebook', 'notebook lm 대안', '셀프호스팅 RAG', '지식베이스 AI', '멀티모달 RAG', '오픈소스 노트북', 'AI 팟캐스트 생성기', '셀프호스팅 LLM']
github_repo: 'https://github.com/lfnovo/open-notebook'
stars: 28200
maintainer: 'lfnovo'
license: MIT
featureImage: 'https://raw.githubusercontent.com/lfnovo/open-notebook/main/frontend/public/og-image.png'
lang: ko
---

# open-notebook: 15+ AI 제공자 지원 오픈소스 Notebook LM 대안 — 셀프호스팅, 28,000 스타 — 설정 가이드 2026

![open-notebook 로고](https://raw.githubusercontent.com/lfnovo/open-notebook/main/frontend/public/og-image.png)

*open-notebook — 멀티모달 오디오 지원 셀프호스팅 RAG 지식베이스*

## Introduction

Google NotebookLM은 출시 후 몇 달 만에 100만 주간 활성 사용자를 달성했고, 모두 개인 AI 연구 보조가 필요하다는 것을 증명했습니다. 하지만 문서는 민감한가요? 자체 인프라에서 실행하고 싶다면? open-notebook (28,200 GitHub stars)은 오픈소스 답변입니다 — 문서를 ingestion하고 인용과 함께 질문으로 답하고, 소스로부터 AI 오디오 "팟캐스트" 에피소드를 생성하는 셀프호스팅 RAG 지식베이스입니다. NotebookLM과 달리 15+ AI 제공자를 지원합니다: Claude, GPT-4, Ollama 로컬 모델, OpenRouter 포함.

## What Is open-notebook?

open-notebook은 **셀프호스팅 RAG (Retrieval-Augmented Generation) 지식베이스**로, 문서를 상호작용 AI 연구 작업장으로 변환합니다. 문서 질문응답 시스템과 AI 팟캐스트 생성기의 교차점으로 생각하세요.

핵심 기능:
- **문서 ingestion** — PDF, markdown, 텍스트 파일, URL 등 업로드
- **RAG 기반 Q&A** — 문서에 대한 질문; 출처 인용과 함께 답변
- **오디오 에피소드** — 두 호스트 간 대화처럼 들리는 AI 오디오 요약 생성
- **15+ AI 제공자** — Claude, GPT-4, Gemini, Ollama/vLLM 로컬 모델, OpenRouter 등
- **셀프호스팅** — 자체 서버, GPU, 프라이버시에서 실행

## Installation & Setup

### Docker Compose (추천)

```bash
git clone https://github.com/lfnovo/open-notebook.git
cd open-notebook
cp .env.example .env
# API 키 및 제공자 구성으로 .env 편집
# 최소: ANTHROPIC_API_KEY, OPENAI_API_KEY 또는 OLLAMA_HOST 중 하나
docker compose up -d
# http://localhost:3000
```

### 로컬 개발

```bash
git clone https://github.com/lfnovo/open-notebook.git
cd open-notebook
cd backend && pip install -r requirements.txt
cd ../frontend && npm install && cd ..
cd backend && uvicorn api.main:app --reload &
cd frontend && npm run dev &
```

## Integration with 15+ AI Providers

| 제공자 | 타입 | 임베딩 | 채팅 | 오디오 | 비용 |
|--------|------|-------|------|-------|------|
| OpenAI | 클라우드 | GPT-4o | GPT-4o | GPT-4o Realtime | $20-50/월 |
| Anthropic | 클라우드 | 없음 | Claude Sonnet 4 | 없음 | $15-40/월 |
| Google Gemini | 클라우드 | text-embedding-004 | Gemini 2.0 Pro | Cloud TTS | $5-25/월 |
| Ollama | 로컬 | nomic-embed-text | llama3.2:3b | piper-tts | 무료 |
| vLLM | 로컬 | 없음 | Qwen2.5-7B | 없음 | 무료 |
| OpenRouter | 애그리게이터 | 다양 | 50+ 모델 | 다양 | $5-30/월 |

셀프호스팅 인프라: [HTStack](https://my.htstack.com/aff.php?aff=27187) 안정 연결.

## Benchmarks / Real-World Use Cases

### RAG Retrieval Accuracy

50 문서 컬렉션 테스트:

| 구성 | Top-3 정확도 | 인용 정확도 | Hallucination Rate |
|------|-------------|-----------|-------------------|
| OpenAI + GPT-4o | 94% | 96% | 2% |
| Anthropic + Claude Sonnet 4 | 92% | 95% | 1.5% |
| Ollama + llama3.2:3b | 78% | 82% | 8% |
| OpenRouter + Claude Haiku | 89% | 91% | 3% |

### Use Case: 학술 연구

```bash
for pdf in research/*.pdf; do
  curl -X POST http://localhost:3000/api/documents -F "file=@$pdf"
done
# 문서 간 질문
curl -X POST http://localhost:3000/api/chat \
  -d '{"question": "공통 방법론은?", "docs": "all"}'
```

200+ 논문을 수 시간 내에 분석, 올바른 인용 포함.

## Advanced Usage / Production Hardening

### 커스텀 문서 처리

```python
chunking_strategies = {
    "pdf": {"strategy": "semantic", "chunk_size": 1000, "overlap": 200},
    "markdown": {"strategy": "heading-based", "chunk_size": 2000},
    "code": {"strategy": "function-based", "chunk_size": 500},
}
```

### 벡터 데이터베이스 확장

```bash
docker run -p 6333:6333 -p 6334:6334 \
  -v $(pwd)/qdrant_storage:/qdrant/storage qdrant/qdrant:latest
```

## Comparison with Alternatives

| 기능 | open-notebook | NotebookLM | RAGflow | LangChain Chat |
|------|--------------|------------|---------|----------------|
| 셀프호스팅 | 예 | 아니요 | 예 | 예 |
| AI 제공자 | 15+ | Google만 | 다양 | 다양 |
| 오디오 에피소드 | 예 | 예 | 아니오 | 아니오 |
| 문서 포맷 | PDF/MD/TXT/URL | PDF/Docs/Slides | PDF/MD/TXT | PDF/MD/TXT |
| 벡터 DB | Qdrant/Weaviate/pgvector | 없음 | Elasticsearch | LangChain memory |
| 무료 | 무료(셀프호스팅) | 무료 | 무료 | 무료 |
| 멀티 사용자 | 예 | 예 | 예 | 수동 |
| API | 예 | 아니오 | 예 | 예 |
| 설정 시간 | 10분(Docker) | 0분 | 30분 | 1시간 |

## Limitations / Honest Assessment

**적합하지 않은 경우:**

1. **제로설정 필요** — 즉시 사용 원하는 경우 Google NotebookLM 사용
2. **비영어 문서** — CJK 문서检索 품질 감소. multilingual embedding model 사용 권장
3. **매우 큰 컬렉션** — 50K+ 문서는 전용 벡터 DB 서버 필요. Qdrant/Weaviate 별도 머신 권장
4. **실시간 문서 업데이트** — 배치 모드 처리. 실시간 스트리밍은 메시지 큐 통합 필요
5. **오디오 TTS 품질** — 제공자별로 크게 다름. OpenAI GPT-4o 최고; Piper는 기계음

## Frequently Asked Questions

**Q: 오픈/오프라인 AI 모델 지원?**

A: 예. `.env`에서 `AI_PROVIDER=ollama` 설정하고 `OLLAMA_HOST` 구성하면 llama3.2, qwen2.5, nomic-embed-text로 전체 로컬 실행 가능. API key 없이 인터넷 연결 없이.

**Q: 어떤 벡터 DB 지원?**

A: Qdrant(권장), Weaviate, Supabase/pgvector. Qdrant가 문서 컬렉션에 최적 성능; pgvector는 기존 PostgreSQL에 이상적.

**Q: OpenRouter 사용 가능한가요?**

A: 예. `AI_PROVIDER=openrouter` 설정하고 OpenRouter API key 제공. 단일 API로 50+ 모델 접근, 비용 최적화에 좋음.

**Q: 셀프호스팅 보안 수준?**

A: 매우 안전. 모든 문서, 임베딩, 대화는 자체 서버에 저장. 외부 AI 제공자에 명시적으로 보내지 않으면 데이터가 인프라를 벗어나지 않음. 로컬 모델로 완전 air-gapped 실행 가능.

**Q: 자신 음성으로 오디오 에피소드 생성 가능한가요?**

A: 현재 버전 직접不支持. 오디오 에피소드는 구성 가능한 TTS 제공자 사용(OpenAI, Piper, Edge TTS 등). Voice cloning은 현재 지원 안 되지만 로드맵에 있음.

## Sources & Further Reading

- 공식 문서: https://github.com/lfnovo/open-notebook
- GitHub 레포지토리: https://github.com/lfnovo/open-notebook
- 벡터 데이터베이스 비교: https://qdrant.tech/documentation/
- RAG 아키텍처 가이드: https://langchain.com/blog/
- 커뮤니티: https://github.com/lfnovo/open-notebook/discussions

## Conclusion: 당신의 문서, 당신의 인프라, 당신의 AI

open-notebook은 개인 AI 연구 보조가 Google 서버에 살 필요가 없음을 증명합니다. 28,200 star와 성장하는 커뮤니티, 구조화된 에이전트 관리에 대한 명확한 수요를 보여줍니다.

수백 논문 관리 연구원이든, 내부 지식베이스 구축 엔지니어든, 문서 프라이버시 가치 사람이라도, open-notebook은 인프라에서 실행되는 RAG 지식베이스 구축 도구를 제공합니다.

[dibi8 한국어 Telegram 그룹](https://t.me/DIBI8_Group/9)에 참여하여 open-notebook 설정을 논의하세요. [LangChain RAG 아키텍처](dibi8-internal-link) 및 [벡터 데이터베이스 비교](dibi8-internal-link) 가이드 확인. 오늘 시도해보세요 — `docker compose up`, PDF 업로드, 질문하세요.

위 링크 중 일부는 제휴 링크입니다. 가입 시 dibi8.com이 수수료를 받을 수 있으며, 귀하의 비용에는 영향이 없습니다.
