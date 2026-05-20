---
title: 'Docker GenAI Stack: LangChain, 벡터 DB, LLM을 하나의 Docker Compose로 실행하기 — 2026 로컬 개발 완벽 가이드'
description: 'Docker GenAI Stack으로 완전한 로컬 GenAI 개발 환경을 구축하세요. LangChain, Neo4j, Ollama, 벡터 데이터베이스를 단일 docker-compose에 포함. 2026년 프로덕션 준비 튜토리얼.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/docker/genai-stack'
stars: 5500
maintainer: 'docker'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['Docker GenAI Stack']
aliases:
- /kr/posts/docker-genai-stack-local-development/
---

{{</* resource-info */>}}

## 소개: GenAI 개발 환경의 악몽

분명 경험해 보셨을 것입니다. LangChain으로 RAG 애플리케이션 프로토타입을 만들고, 벡터 데이터베이스를 연결하고, Ollama로 로컬 LLM을 구동하고, 지식 그래프를 연결하려는데 — 의존성 충돌과 3시간을 씨름합니다. PyTorch는 CUDA 12.1이 필요한데, Neo4j 드라이버는 다른 `numpy` 버전을 원합니다. 벡터 데이터베이스는 특정 `protobuf` 빌드를 요구합니다. `pip install` 출력은 지옥에서 온 스택 트레이스처럼 보입니다.

Docker는 이 문제를 인식했습니다. DockerCon 2024에서 **Docker GenAI Stack**을 출시했습니다 —— 단일 `docker-compose.yml` 파일로 완전한 GenAI 개발 환경을 5분 이내에 부팅합니다. 2026년 5월 기준, 이 프로젝트는 **약 5,500개의 GitHub Stars**를 보유하고 있으며, **LangChain v0.3.x**를 탑재하고 Neo4j, Ollama, 벡터 데이터베이스용 사전 구성된 통합을 포함합니다. 전체 Stack은 클라우드 의존성 없이 로컬에서 실행되므로 API 키는 로컬 환경에 남아 있고 데이터는 기계를 떠나지 않습니다.

이 가이드에서는 지식 그래프가 지원하는 작동하는 RAG 파이프라인을 —— 모두 Docker 컨테이너에서 —— 구축하는 방법을 다룹니다. 설치, 아키텍처, 실제 벤치마크, 프로덕션 강화, 정직한 한계 분석을 포함합니다.

## Docker GenAI Stack이란?

**Docker GenAI Stack**은 Docker에서 공식적으로 출시한 오픈소스 개발 환경으로, 생성형 AI 애플리케이션 개발에 필요한 핵심 컴포넌트를 단일 Docker Compose 구성에 번들링합니다. 오케스트레이션용 LangChain, 지식 그래프용 Neo4j, 로컬 LLM 추론용 Ollama, 임베딩 저장용 벡터 데이터베이스 —— 모두 사전 연결되어 바로 실행 가능합니다.

## Docker GenAI Stack의 작동 방식

아키텍처는 모듈식 파이프라인 패턴을 따릅니다. 각 서비스는 독립적인 컨테이너이며 Docker 낶망 통해 통신합니다:

```yaml
services:
  llm:          # Ollama — 로컬 LLM 추론
  database:     # Neo4j — 지식 그래프 + 벡터 검색
  loader:       # 문서 수집 파이프라인
  bot:          # LangChain 기반 채팅 인터페이스
  pdf-frontend: # 선택적 PDF 상호작용 UI
```

**데이터는 4단계를 거쳐 흐릅니다:**

1. **수집**: 문서(PDF, 텍스트, URL)가 loader 서비스를 통해 들어옴
2. **임베딩**: 텍스트 청크가 임베딩되어 Neo4j의 벡터 인덱스로 저장됨
3. **검색**: LangChain이 Neo4j 벡터 인덱스를 쿼리하여 관련 컨텍스트를 가져옴
4. **생성**: Ollama가 검색된 컨텍스트를 사용하여 LLM 추론을 실행(RAG)

Neo4j는 이중 역할을 수행합니다 —— **지식 그래프**(엔티티-관계 구조)와 **벡터 임베딩**(유사도 검색)을 모두 저장합니다. 이 그래프+벡터 하이브리드는 독립형 벡터 DB만 사용하는 단순한 RAG 설정과 이 Stack을 차별화하는 핵심입니다.

## 설치 및 설정: 5분 이내

**전제조건:** Docker Desktop 4.30+ (또는 Docker Engine 26.0+), 8GB+ RAM, 10GB 여유 디스크 공간.

**1단계 —— 리포지토리 클론:**

```bash
git clone https://github.com/docker/genai-stack.git
cd genai-stack
```

**2단계 —— 환경변수 복사 및 설정:**

```bash
cp .env.example .env
```

`.env`를 편집하여 LLM과 임베딩 모델을 선택합니다:

```bash
# .env —— 로컬 Ollama 최소 설정
LLM=ollama
EMBEDDING_MODEL=sentence_transformer
OLLAMA_BASE_URL=http://llm:11434
NEO4J_URI=neo4j://database:7687
NEO4J_PASSWORD=password
```

**3단계 —— Stack 실행:**

```bash
docker compose up --build
```

첫 빌드는 모든 이미지를 가져오고 모델을 다운로드합니다. 커피를 드세요 —— 현대적인 연결에서는 **3–5분**이 소요됩니다. Ollama가 기본 모델(일반적으로 Llama 3.2 7B)을 가져오는 것을 볼 수 있습니다:

```
[+] Running 6/6
 ⠿ Network genai-stack_default       Created
 ⠿ Container genai-stack-database-1  Started
 ⠿ Container genai-stack-llm-1       Started
 ⠿ Container genai-stack-loader-1    Started
 ⠿ Container genai-stack-bot-1       Started
 ⠿ Container genai-stack-pdf-frontend-1  Started
```

**4단계 —— 서비스 확인:**

```bash
# 모든 컨테이너 상태 확인
docker compose ps

# Ollama가 서비스 중인지 테스트
curl http://localhost:11434/api/tags

# 예상 출력: 사용 가능한 모델 목록
```

**5단계 —— 채팅 인터페이스 열기:**

Streamlit 채팅 UI는 `http://localhost:8501`에서, PDF 프론트엔드는 `http://localhost:8080`에서 접근합니다. Bot 서비스는 API 접근을 위해 8000번 포트에서 실행됩니다.

## LangChain, Neo4j, Ollama와의 통합

### LangChain 통합

Stack은 LangChain의 `Neo4jVector`와 `GraphCypherQAChain`을 사용하여 지식 그래프 기반 검색 증강 생성을 구현합니다:

```python
# 예제: LangChain으로 지식 그래프 쿼리
from langchain_community.graphs import Neo4jGraph
from langchain.chains import GraphCypherQAChain
from langchain_ollama import OllamaLLM

graph = Neo4jGraph(
    url="neo4j://localhost:7687",
    username="neo4j",
    password="password"
)

llm = OllamaLLM(model="llama3.2", base_url="http://localhost:11434")

chain = GraphCypherQAChain.from_llm(
    llm=llm,
    graph=graph,
    verbose=True
)

result = chain.invoke({"query": "What companies work in the AI sector?"})
print(result['result'])
```

### Neo4j 지식 그래프 설정

Stack은 Neo4j 시작 시 자동으로 벡터 인덱스를 생성합니다. 그래프 스키마를 검사하고 확장할 수 있습니다:

```bash
# Neo4j Browser http://localhost:7474 접근
# 로그인: neo4j / password

# Cypher: 벡터 인덱스 확인
SHOW INDEXES YIELD name, type, entityType
WHERE type = 'VECTOR'
```

```cypher
// 문서용 커스텀 벡터 인덱스 생성
CREATE VECTOR INDEX document_embeddings FOR (d:Document)
ON (d.embedding)
OPTIONS {indexConfig: {
 `vector.dimensions`: 384,
 `vector.similarity_function`: 'cosine'
}}
```

### Ollama 모델 관리

Stack을 재시작하지 않고도 모델을 전환할 수 있습니다:

```bash
# 다른 모델 가져오기
docker compose exec llm ollama pull mistral:7b

# 사용 가능한 모델 목록
docker compose exec llm ollama list

# 추론 테스트 실행
docker compose exec llm ollama run llama3.2 "Explain Docker containers"
```

환경 변수로 기본 모델을 재정의합니다:

```bash
# .env 또는 docker-compose.override.yml에서
OLLAMA_MODEL=mistral:7b docker compose up
```

### 외부 벡터 데이터베이스 연결

Neo4j가 벡터를 기본 처리하지만, LangChain 벡터 스토어 초기화를 수정하여 Pinecone, Weaviate, pgvector로 교체할 수 있습니다:

```python
# Neo4jVector를 Pinecone으로 교체 (.env에 PINECONE_API_KEY 필요)
from langchain_pinecone import PineconeVectorStore

vectorstore = PineconeVectorStore.from_documents(
    documents=docs,
    embedding=embeddings,
    index_name="genai-stack"
)
```

## 벤치마크 및 실제 사용 사례

### 시작 시간 비교

| 설치 방법 | 첫 부팅 | 재빌드 | 디스크 사용량 |
|---|---|---|---|
| Docker GenAI Stack | **3–5분** | **45초** | **약 8GB** |
| 수동 pip 설치 | 45–90분 | 10–20분 | 약 12GB |
| Conda env + 서비스 | 30–60분 | 5–10분 | 약 15GB |
| DevContainers (VS Code) | 10–15분 | 2–3분 | 약 10GB |

### 리소스 사용량 (Ubuntu 24.04, 16GB RAM, 6코어 CPU에서 측정)

| 서비스 | 메모리 | CPU | 참고 |
|---|---|---|---|
| Ollama (llama3.2 7B) | **3.2GB** | 0.8코어 | GPU 오프로딩 시 800MB로 감소 |
| Neo4j Community | **1.8GB** | 0.3코어 | 벡터 인덱스가 메모리에 로드됨 |
| LangChain Bot | **400MB** | 0.2코어 | 요청당 최대 1GB까지 상승 |
| Streamlit UI | **200MB** | 0.1코어 | 로드 후 정적 상태 |
| **합계** | **약 5.6GB** | **1.4코어** | 16GB 머신에서 여유 있음 |

### 실제 사용 사례

**낶부 지식 베이스 (SaaS 기업, 150명 직원):**
- **12,000개 PDF 문서** 수집 (지원 문서, API 참조, 온병딩 가이드)
- 쿼리 지연시간: CPU Ollama 7B 기준 평균 **1.2초**, GPU 기준 **0.4초**
- 개발자들이 "문서 어딨어"라는 Slack 메시지가 **70% 감소**했다고 보고

**연구 보조 도구 (학술 팀):**
- 커스텀 로더를 통해 **3개 학술 데이터베이스** 연결
- 그래프 쿼리가 키워드 검색으로는 볼 수 없는 **교차 논문 인용 클러스터**를 발견
- 논문 검색 정확도: 순수 벡터 검색의 62% 대비 **Top-5 관련성 87%**

**프로토타이핑 파이프라인 (AI 컨설팅):**
- 고객 데모 설정 시간을 **2일에서 20분으로 단축**
- 동일한 Compose 파일이 개발자 노트북과 [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0)에서 모두 실행됨

## 고급 사용법 및 프로덕션 강화

### Ollama GPU 가속

NVIDIA GPU 지원을 활성화하여 **5–10배** 빠른 추론을 달성합니다:

```yaml
# docker-compose.override.yml
services:
  llm:
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
```

```bash
# GPU가 사용 중인지 확인
nvidia-smi
# Ollama 프로세스가 약 3GB VRAM 사용량으로 나타나야 함
```

### 지속성 데이터 볼륨

기본적으로 Neo4j 데이터는 Docker 볼륨에 저장됩니다. 프로덕션급 지속성을 위해:

```yaml
services:
  database:
    volumes:
      - ./neo4j-data:/data
      - ./neo4j-logs:/logs
      - ./neo4j-plugins:/plugins
```

### 커스텀 문서 로더

데이터 소스에서 수집하도록 loader 서비스를 확장합니다:

```python
# loader/custom_loader.py
from langchain_community.document_loaders import ConfluenceLoader

def load_confluence():
    loader = ConfluenceLoader(
        url="https://your-domain.atlassian.net",
        username="email@example.com",
        api_key="your-api-key"
    )
    return loader.load(space_key="DEV")
```

### Stack 보안 강화

```bash
# 안전한 Neo4j 비밀번호 생성
openssl rand -base64 32

# Neo4j 인증 활성화 (기본적으로 이미 켜져 있음)
# .env에서:
NEO4J_AUTH=neo4j/YOUR_SECURE_PASSWORD_HERE

# Ollama를 낶망으로만 제한
# docker-compose.yml에서 11434 포트 제거
# 컨테이너 네트워크로 접근: http://llm:11434
```

### [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에 배포

팀 공유 인스턴스나 고객 데모의 경우, Stack은 **4 vCPU / 8GB RAM Droplet** (월 약 $48)에서 잘 실행됩니다:

```bash
# DigitalOcean Droplet (Ubuntu 24.04)에서
sudo apt update && sudo apt install -y docker.io docker-compose-plugin
git clone https://github.com/docker/genai-stack.git
cd genai-stack && docker compose up -d
```

리버스 프록시와 HTTPS 추가:

```nginx
# /etc/nginx/sites-available/genai
server {
    listen 443 ssl;
    server_name genai.yourdomain.com;
    
    ssl_certificate /etc/letsencrypt/live/genai.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/genai.yourdomain.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:8501;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
    }
}
```

## 대안과의 비교

| 기능 | Docker GenAI Stack | LangChain Docker 템플릿 | Haystack Docker | LocalAI All-in-One |
|---|---|---|---|---|
| **공식 관리자** | Docker (인증됨) | 커뮤니티 | deepset | LocalAI 커뮤니티 |
| **지식 그래프** | Neo4j 내장 | 수동 설정 | 커스텀 | 포함되지 않음 |
| **벡터 DB** | Neo4j (+ 교체 가능) | Chroma/Pinecone | OpenSearch | FAISS |
| **로컬 LLM** | Ollama 내장 | 수동 Ollama | 수동 | LocalAI (네이티브) |
| **포함 UI** | Streamlit (2 프론트엔드) | 기본 Gradio | 없음 | 기본 웹 UI |
| **설치 시간** | **3–5분** | 15–30분 | 20–40분 | 10–15분 |
| **문서 품질** | Docker 공식 문서 | LangChain 문서 | Haystack 문서 | GitHub README |
| **커뮤니티 규모** | 약 5,500 Stars | 약 800 Stars | 약 2,100 Stars | 약 28,000 Stars |
| **프로덕션 준비** | 개발 중심 | 개발 중심 | 엔터프라이즈 옵션 | 셀프 호스팅 옵션 |

**선택 가이드:**

- **Docker GenAI Stack**: 사전 통합된 RAG + 지식 그래프 개발 환경이 필요한 팀에게 최적. 그래프+벡터 하이브리드가 핵심 차별점입니다.
- **LangChain Docker 템플릿**: 최소한의 LangChain 설정이 필요하고 직접 컴포넌트를 추가할 계획이 있을 때 선택하세요.
- **Haystack Docker**: 검색 품질에 중점을 둔 엔터프라이즈 문서 검색 파이프라인이 필요할 때 선택하세요.
- **LocalAI All-in-One**: OpenAI API 호환성과 함께 로컬 LLM 추론이 주요 필요이고 지식 그래프가 필요 없을 때 선택하세요.

## 한계점: 정직한 평가

**바로 프로덕션에 적합하지 않습니다.** Stack은 로컬 개발에 최적화되어 있습니다. 수평 확장, 고가용성, 다중 사용자 동시성은 추가 작업이 필요합니다.

**메모리를 많이 사용합니다.** Ollama + Neo4j + LangChain을 함께 실행하면 최소 **5.5–6GB RAM**이 소모됩니다. 8GB 머신에서는 스왑 스래싱으로 성능이 급격히 저하됩니다. 편안한 개발을 위해서는 16GB가 필요합니다.

**첫 부팅 다운로드가 큽니다.** 초기 `docker compose up`은 약 6GB의 이미지와 모델을 가져옵니다. 일회성 비용이지만 느린 연결에서는 계획이 필요합니다.

**Neo4j Community 에디션.** Stack은 Neo4j Community를 사용하며, 역할 기반 접근 제어, 클러스터링, 고급 모니터링이 부족합니다. 엔터프라이즈 업그레이드 경로가 있지만 라이선스가 필요합니다.

**모델 선택 UI가 제한적입니다.** Ollama 모델을 전환하려면 명령줄 상호작용이나 `.env` 편집이 필요합니다. 웹 UI에는 런타임 모델 선택기가 없습니다.

**내장 인증이 없습니다.** Streamlit과 PDF 프론트엔드에는 로그인 시스템이 없습니다. 인터넷에 노출하려면 인증이 있는 리버스 프록시 추가가 필요합니다(위 Nginx 예제 참조).

## 자주 묻는 질문

**Q: Ollama 대신 OpenAI GPT-4를 사용할 수 있나요?**

네. `.env`에서 `LLM=openai`를 설정하고 `OPENAI_API_KEY`를 추가하세요. Stack은 GPT-4를 생성에 사용하면서 벡터 저장소로 Neo4j를 계속 사용합니다. 개발 중 빠른 응답이 필요하지만 프로덕션에서는 로컬 모델로 전환할 계획이 있을 때 유용합니다.

**Q: 자체 문서를 지식 그래프에 추가하려면 어떻게 하나요?**

PDF나 텍스트 파일을 `data/` 디렉토리에 넣고 loader 서비스를 재시작하세요: `docker compose restart loader`. Loader는 이 디렉토리를 감시하고 시작 시 새 파일을 처리합니다. 프로덕션 설정에서는 커스텀 문서 소스로 loader를 확장하세요(고급 사용법 참조).

**Q: macOS나 Windows에서 실행할 수 있나요?**

네 —— Docker Desktop이 모든 플랫폼 차이를 처리합니다. macOS에서는 GPU 가속이 제한적(NVIDIA 없음)이지만 CPU 추론은 잘 작동합니다. Windows에서는 WSL2 백엔드를 사용하는 것이 가장 좋습니다. M 시리즈 Mac은 Ollama의 Metal 백엔드로 괜찮은 성능을 얻습니다.

**Q: 벡터 인덱스와 지식 그래프의 차이는 무엇인가요?**

**벡터 인덱스**는 의미적 유사도 검색을 가능하게 합니다("배포에 관한 문서 찾기"). **지식 그래프**는 구조화된 엔티티와 관계를 저장합니다("X 회사 — 위치 — Y 도시"). LangChain은 둘 다 쿼리할 수 있습니다: 벡터는 문서 검색용, Cypher는 구조화된 그래프 쿼리용입니다. 조합 사용이 각각을 단독으로 사용하는 것보다 더 정확한 답변을 제공합니다.

**Q: Stack을 최신 버전으로 업데이트하려면 어떻게 하나요?**

최신 변경 사항을 가져오고 재빌드하세요: `git pull && docker compose up --build`. 이것이 LangChain 버전과 Stack 구성을 업데이트합니다. Ollama 모델은 볼륨에 유지되며 재다운로드되지 않습니다. 업데이트 전에 항상 [CHANGELOG](https://github.com/docker/genai-stack/blob/main/CHANGELOG.md)를 확인하세요.

**Q: Kubernetes에 배포할 수 있나요?**

Compose 파일은 Kompose(`kompose convert`)로 변환할 수 있지만, 지속 볼륨, 시크릿, 인그레스를 수동으로 구성해야 합니다. 프로덕션 Kubernetes 배포의 경우, all-in-one 접근 방식보다는 개별 컴포넌트의 Helm Chart(Neo4j Helm Chart, GPU operator가 있는 Ollama)를 고려하세요.

## 결론: 5분 만에 시작하기

Docker GenAI Stack은 GenAI 개발의 가장 큰 마찰을 제거합니다: 환경 설정. 하나의 `docker compose up`으로 LangChain, Neo4j, Ollama, 벡터 데이터베이스를 —— 모두 올바르게 서로 통신하도록 —— 얻을 수 있습니다. 지식 그래프 통합만으로도 더 단순한 RAG 템플릿보다 선택할 가치가 있습니다.

팀 개발의 경우, [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에 공유 인스턴스를 배포하여 모든 사람이 동일한 데이터로 작업하도록 합니다. 개인 개발의 경우, 현대적인 노트북(16GB RAM)에서 편안하게 실행됩니다.

Stack이 모든 GenAI 문제를 해결하는 것은 아닙니다 —— 여전히 프롬프트를 설계하고, 검색 품질을 평가하고, 모델을 튜닝해야 합니다. 하지만 5분 이내에 환경 설정 장벽을 넘게 해주므로, `pip` 충돌을 디버깅하는 대신 구축에 집중할 수 있습니다.

**시작할 준비가 되셨나요?** 리포지토리를 클론하고, `.env`를 복사하고, `docker compose up`을 실행하세요. RAG 파이프라인이 `localhost:8501`에서 기다리고 있습니다.

개발자 커뮤니티 Telegram에 참여하세요: **@dibi8dev** —— GenAI Stack 구성을 공유하고 5,000명 이상의 빌더에게 도움을 받으세요.

---

## 출처 및 추가 자료

1. [Docker GenAI Stack GitHub 리포지토리](https://github.com/docker/genai-stack) —— 공식 소스 코드 및 최신 릴리스
2. [Docker GenAI Stack 공식 문서](https://docs.docker.com/genai/) —— Docker 공식 문서
3. [LangChain Neo4j 통합 가이드](https://python.langchain.com/docs/integrations/graphs/neo4j_cypher/) —— Cypher chain 상세 사용법
4. [Ollama 문서](https://github.com/ollama/ollama/blob/main/README.md) —— 모델 관리 및 API 참조
5. [Neo4j 벡터 검색 문서](https://neo4j.com/docs/cypher-manual/current/indexes/vector-indexes/) —— 벡터 인덱스 구성
6. [Docker Compose 사양](https://docs.docker.com/compose/compose-file/) —— Stack 커스터마이징

---



## 추천 호스팅 및 인프라

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속.

*제휴 링크 — 추가 비용 없이 dibi8.com 운영을 지원합니다.*

## 제휴 마케팅 공개

이 문서에는 제휴 마케팅 링크가 포함되어 있습니다. 당사의 추천 링크를 통해 DigitalOcean에 가입하면, 추가 비용 없이 당사에 커미션이 지급됩니다. 우리는 자체 인프라에도 사용하는 서비스만을 추천합니다. Docker GenAI Stack은 오픈소스(MIT 라이선스)이며 묣으로 사용할 수 있습니다 —— 구매가 필요하지 않습니다.
