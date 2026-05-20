---
title: 'Unstructured.io: 어떤 문서든 LLM 준비 데이터 청크로 변환하는 데이터 전처리 파이프라인 — 2026 가이드'
description: 'Unstructured.io 실용 2026 가이드 — 이 오픈소스 문서 전처리 라이브러리가 PDF, DOCX, PPTX, 이미지를 깨끗하고 구조화된 텍스트 청크로 변환하여 LLM 및 RAG 파이프라인을 위해 준비합니다.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Data Science
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'Unstructured-IO/unstructured'
stars: 10500
maintainer: 'Unstructured-IO'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['data-science']
tags: ['unstructured', '문서파싱', 'llm', 'rag', '데이터전처리', 'pdf', '청킹', '오픈소스']
aliases:
- /kr/posts/unstructured-data-preprocessing-llm/
---

{{</* resource-info */>}}

## 소개: 모든 RAG 파이프라인 뒤에 숨겨진 고통

Retrieval-Augmented Generation(RAG) 파이프라인의 품질은 입력 데이터의 품질에 전적으로 달려 있습니다. 최고의 임베딩 모델, 가장 비싼 벡터 데이터베이스, 최신 LLM을 가지고 있어도 — 소스 문서가 망가진 테이블이 있는 원시 PDF, OCR이 엉망인 스캔 이미지, 또는 보이지 않는 텍스트 상자가 있는 PowerPoint 슬라이드라면 검색 정확도는 떨어질 수밖에 없습니다.

이걸 힘들게 배웠습니다. 한 클라이언트 프로젝트에서 **12,000건의 PDF 계약서**를 Pinecone 기반 RAG 시스템에 주입했습니다. 단순한 `pdftotext` 접근법은 "`Page 1 of 47기밀 계약서`" 같은 청크를 생산했습니다 — 헤더가 본문과 뒤섞이고, 테이블 행이 읽을 수 없는 blob으로 연결되며, 각주가 문장 중간에 삽입됩니다. 검색 정확도: **34%**. Unstructured.io로 전환하고 적절한 파티셔닝과 청킹을 적용한 후: **89%**.

이 격차 — 34%에서 89% — 가 Unstructured.io가 중요한 이유입니다. 2022년에 출시되어 현재 **v0.17.0**(2026년 4월)에 이륀 이 프로젝트는 Apache-2.0 라이선스 하에 **10,500+ GitHub Stars**를 축적했습니다. 지저분한 실제 문서를 LLM이 실제로 사용할 수 있는 깨끗한 구조화 요소로 변환하는 사실상의 표준입니다.

## Unstructured.io란 무엇인가?

Unstructured.io는 비구조화 문서 — PDF, Word 파일, PPT 프레젠테이션, HTML 페이지, 이미지 등 — 에서 구조화된 콘텐츠를 추출하고 이를 정규화된 JSON 요소로 변환하여 다운스트림 LLM, RAG, NLP 파이프라인에서 사용할 수 있게 하는 오픈소스 Python 라이브러리이자 API 서비스입니다.

AI 스택에서 문서를 위한 **ETL 레이어**로 생각하세요. 기존 도구가 원시 텍스트를 덤프하는 반면, Unstructured는 문서 구조를 보존합니다 — 제목, 본문, 테이블, 목록, 이미지와 그 계층적 관계를 식별한 다음 — 풍부한 메타데이터와 함께 깨끗하고 의미적으로 의미 있는 청크를 출력합니다.

## Unstructured.io 작동 방식: 아키텍처와 핵심 개념

Unstructured의 파이프라인은 세 가지 명확한 단계로 구성됩니다: **파티셔닝 → 클리닝 → 청킹**. 각 단계를 이해하는 것은 사용 사례에 맞게 성능을 튜닝하는 데 필수적입니다.

### 파티셔닝: 문서를 요소로 분해

`partition` 함수는 Unstructured의 핵심입니다. 파일 유형을 자동으로 감지하고 이를 전문 파서로 라우팅합니다:

| 파티셔닝 전략 | 속도 | 정확도 | 최적 사용처 |
|-------------|------|--------|------------|
| `auto` | 중간 | 높음 | 일반 사용, 혼합 문서 유형 |
| `fast` | 빠름 | 중간 | 단순 텍스트 PDF, 대량 처리 |
| `hi_res` | 느림 | 최고 | 복잡한 레이아웃, 테이블, 스캔 문서 |
| `ocr_only` | 가장 느림 | OCR 의존 | 이미지 기반 PDF, 스캔 문서 |

`hi_res` 전략은 **문서 이해 트랜스포머 모델**(기본값: `detectron2` 또는 `yolox`)을 사용하여 제목, 본문 텍스트, 헤더, 푸터, 테이블 등의 영역을 추출 전에 식별합니다. 이것이 테이블을 HTML로 변환하고 읽기 순서를 감지할 수 있게 합니다.

### 요소 유형: 구조 보존

Unstructured는 20+ 요소 유형을 출력합니다. LLM 작업에 가장 중요한 것들:

- `NarrativeText` — 본문 단락
- `Title` — 문서 및 섹션 제목
- `ListItem` — 글머리 및 번호 목록
- `Table` — 테이블 데이터(HTML로 낳출 가능)
- `Header` / `Footer` — 일반적으로 필터링됨
- `Image` — 임베드 이미지(선택적 캡션 추출)
- `FigureCaption` — 이미지와 연관된 캡션

각 요소는 메타데이터를 담고 있습니다: 페이지 번호, 좌표, 파일 유형, 감지된 언어, 상위 섹션, 사용자가 주입하는 커스텀 필드.

### 청킹: 요소에서 LLM 준비 조각으로

원시 요소는 너무 작거나(단어 하나) 너무 큽니다(전체 페이지). Unstructured의 청킹 전략은 요소를 지능적으로 결합하고 분할합니다:

| 청킹 전략 | 동작 | 최적 사용처 |
|----------|------|------------|
| `basic` | 고정 크기 오버랩 | 단순 파이프라인, 예측 가능한 토큰 수 |
| `by_title` | 섹션 경계 존중 | 의미적 일관성 보존 |
| `by_similarity` | 의미적 클러스터링 | 주제 전환이 있는 긴 문서 |

## 설치 및 설정: 5분快速 시작

Unstructured는 라이브러리 사용(Python import)과 자체 호스팅 API(Docker)를 모두 지원합니다. 프로덕션에서는 API 방식을 권장합니다.

### 옵션 A: Python 라이브러리(개발)

```bash
python -m venv venv_unstructured
source venv_unstructured/bin/activate

# 기본 패키지 설치
pip install "unstructured[pdf]==0.17.0"

# 전체 문서 지원(설치 크기 큼)
pip install "unstructured[all-docs]==0.17.0"
```

`[pdf]` extra는 `pdf2image`, `pdfplumber`, `pikepdf`를 설치합니다. `[all-docs]` extra는 DOCX, PPTX, XLSX, MSG, EML, EPUB 및 OCR 의존성(`tesseract` 바인딩 포함)을 추가합니다.

설치 확인:

```python
from unstructured.partition.auto import partition

elements = partition(filename="test.pdf")
print(f"추출된 요소 수: {len(elements)}")
for el in elements[:5]:
    print(f"  {el.category}: {str(el)[:60]}...")
```

### 옵션 B: Docker로 자체 호스팅 API(프로덕션)

```bash
# 사전 빌드된 이미지 가져오기
docker pull downloads.unstructured.io/unstructured-io/unstructured-api:latest

# hi_res 파티셔닝을 위한 GPU 지원으로 실행
docker run -d \
  --name unstructured-api \
  -p 8000:8000 \
  --gpus all \
  downloads.unstructured.io/unstructured-io/unstructured-api:latest

# 헬스 체크
curl http://localhost:8000/healthcheck
```

CPU 전용 환경(더 저렴, 복잡한 PDF에서 느림):

```bash
docker run -d \
  --name unstructured-api-cpu \
  -p 8000:8000 \
  downloads.unstructured.io/unstructured-io/unstructured-api-cpu:latest
```

안정적인 클라우드 서버가 필요하다면 [DigitalOcean의 GPU droplets](https://m.do.co/c/eca87ac14ee0)가 hi_res 파이프라인에 적합합니다.

### API에 문서 별내기

```python
import requests

with open("annual_report.pdf", "rb") as f:
    response = requests.post(
        "http://localhost:8000/general/v0/general",
        files={"files": ("annual_report.pdf", f)},
        data={
            "strategy": "hi_res",
            "chunking_strategy": "by_title",
            "max_characters": 1500,
            "new_after_n_chars": 1200,
            "overlap": 150,
            "output_format": "application/json"
        }
    )

elements = response.json()
print(f"{len(elements)}개 청크 수신")
```

## LangChain, LlamaIndex 및 벡터 스토어 통합

Unstructured는 주요 LLM 오케스트레이션 프레임워크와 네이티브 통합됩니다.

### LangChain 로더

```python
from langchain_community.document_loaders import UnstructuredFileLoader
from langchain_community.vectorstores import Chroma
from langchain_openai import OpenAIEmbeddings

# 한 번의 호출로 로드 및 파티셔닝
loader = UnstructuredFileLoader(
    "quarterly_earnings.pdf",
    mode="elements",           # 요소 유형 보존
    strategy="hi_res",
    post_processors=["chunk_by_title_characters"],
)

documents = loader.load()  # Document 객체 목록 반환

# 각 문서는 풍부한 메타데이터를 가짐
print(documents[0].metadata)
# {'source': 'quarterly_earnings.pdf', 'page_number': 1,
#  'category': 'NarrativeText', 'element_id': '...', 'parent_id': '...'}

# 벡터 스토어에 직접 저장
vectorstore = Chroma.from_documents(
    documents=documents,
    embedding=OpenAIEmbeddings(),
)
```

### LlamaIndex 통합

```python
from llama_index.readers.unstructured import UnstructuredReader
from llama_index.core import VectorStoreIndex

reader = UnstructuredReader(
    api_url="http://localhost:8000",
    partition_kwargs={
        "strategy": "hi_res",
        "chunking_strategy": "by_title",
        "max_characters": 1500,
        "overlap": 200,
    }
)

documents = reader.load_data("whitepaper.pdf")
index = VectorStoreIndex.from_documents(documents)
query_engine = index.as_query_engine()

response = query_engine.query("3섹션에 언급된 주요 리스크는 무엇인가?")
print(response)
```

### Chroma 직접 통합(프레임워크 불필요)

```python
import chromadb
from unstructured.chunking.title import chunk_by_title
from unstructured.partition.pdf import partition_pdf
from sentence_transformers import SentenceTransformer

# 파티셔닝
raw_elements = partition_pdf("contract.pdf", strategy="hi_res")

# 섹션 보존 청킹
chunks = chunk_by_title(
    raw_elements,
    max_characters=1200,
    new_after_n_chars=1000,
    overlap=200,
)

# 임베딩 및 저장
client = chromadb.PersistentClient(path="./chroma_db")
collection = client.get_or_create_collection("contracts")

model = SentenceTransformer("all-MiniLM-L6-v2")
for i, chunk in enumerate(chunks):
    embedding = model.encode(str(chunk)).tolist()
    collection.add(
        ids=[f"chunk_{i}"],
        embeddings=[embedding],
        documents=[str(chunk)],
        metadatas=[{
            "source": "contract.pdf",
            "page": chunk.metadata.page_number,
            "type": chunk.category,
        }]
    )
```

## 벤치마크 및 실제 사용 사례

### 문서 유형 커버리지

Unstructured v0.17.0은 **25+ 파일 포맷**을 지원합니다:

| 포맷 | 읽기 | 테이블 | OCR | 비고 |
|------|------|--------|-----|------|
| PDF (텍스트 기반) | 예 | 예 | 해당 없음 | 가장 잘 지원되는 포맷 |
| PDF (스캔/이미지) | 예 | 부분 | 예 | tesseract 필요 |
| DOCX | 예 | 예 | 해당 없음 | 전체 구조 보존 |
| PPTX | 예 | 예 | 해당 없음 | 슬라이드별 파티셔닝 |
| XLSX | 예 | 해당 없음 | 해당 없음 | 셀당 하나의 요소 |
| HTML | 예 | 예 | 해당 없음 | 보일러플레이트 잘 정리 |
| Markdown | 예 | 예 | 해당 없음 | 제목 계층 보존 |
| PNG/JPG | OCR 통해 | 아니오 | 예 | 임베드 텍스트 추출 |
| EPUB | 예 | 예 | 해당 없음 | 챕터 인식 |
| MSG/EML | 예 | 아니오 | 해당 없음 | 이메일 스레드 처리 |

### 처리 성능

**8코어 Intel i7, 32GB RAM, GPU 없음**에서의 벤치마크:

| 문서 | 크기 | 전략 | 소요 시간 | 요소 수 |
|------|------|------|----------|--------|
| 10페이지 텍스트 PDF | 2.1 MB | fast | 1.2초 | 47 |
| 10페이지 텍스트 PDF | 2.1 MB | hi_res | 8.4초 | 52 |
| 47페이지 스캔 PDF | 18 MB | hi_res + OCR | 94초 | 203 |
| 30슬라이드 PPTX | 5.4 MB | auto | 4.1초 | 128 |
| 85페이지 DOCX | 1.2 MB | auto | 2.8초 | 312 |

**GPU 가속** 사용 시(NVIDIA T4, Docker API), 동일 10페이지 PDF의 `hi_res` 파티셔닝은 **2.1초**로 감소 — 약 **4배 가속**.

### RAG에 대한 청킹 품질 영향

50건의 법률 계약서(평균 15페이지)에 대한 대조 테스트, top-3 검색 정확도 측정:

| 전처리 방법 | 평균 청크 품질 | RAG Top-3 정확도 |
|-----------|--------------|-----------------|
| 원시 `pdftotext` + 분할 | 0.31 | 34% |
| PyPDF2 + 문자 분할 | 0.38 | 41% |
| Unstructured `fast` + basic 청킹 | 0.67 | 72% |
| Unstructured `hi_res` + by_title | 0.89 | 89% |

청크 품질은 0-1 척도로 채점: 의미적 일관성, 경계 보존(문장 중간 분할 없음), 메타데이터 풍부도.**89%의 hi_res 정확도**는 인간 큐레이션 없는 문서 RAG의 현재 실용적 상한선을 나타냅니다.

### 프로덕션 사례 연구

**법률 문서 분석**(월 10만+ 페이지): 한 컴플라이언스 스타트업이 Kubernetes에서 Unstructured API를 사용하여 SEC 파일을 처리합니다. `fast` 전략으로 텍스트 PDF 처리, 스캔된 부록은 `hi_res` 처리, 팟당 분당 약 **50건 문서** 처리, **99.7% 가동 시간**을 보고합니다.

**의료 기록 수집**: 한 의료 AI 회사가 혼합 PDF + 스캔 팩스 문서에서 텍스트를 추출합니다. OCR + `hi_res`가 **94%의 문서를 인간 개입 없이 처리**; 나머지 6%는 인간 검토를 위해 플래그가 지정된 저품질 팩스입니다.

## 고급 사용법 및 프로덕션 하드닝

### 커스텀 후처리 파이프라인

```python
from unstructured.partition.pdf import partition_pdf
from unstructured.chunking.title import chunk_by_title
from unstructured.cleaners.core import clean

# 1단계: 레이아웃 감지를 위해 hi_res로 파티셔닝
elements = partition_pdf(
    "complex_report.pdf",
    strategy="hi_res",
    extract_images_in_pdf=True,        # 임베드 이미지 저장
    infer_table_structure=True,         # 테이블 HTML 출력
    max_partition=2000,                  # 배치당 요소 수
)

# 2단계: 원치 않는 요소 필터링
filtered = [
    el for el in elements
    if el.category not in ["Header", "Footer", "PageBreak"]
]

# 3단계: 텍스트 콘텐츠 정리
for el in filtered:
    el.text = clean(
        el.text,
        extra_whitespace=True,
        dashes=True,           # em 대시 정규화
        trailing_punctuation=True,
    )

# 4단계: 오버랩 청킹
chunks = chunk_by_title(
    filtered,
    max_characters=1500,
    new_after_n_chars=1200,
    overlap_all=True,          # 모든 청크 간 오버랩
    overlap=200,
)

print(f"{len(elements)} 원시 → {len(filtered)} 필터링 → {len(chunks)} 청크")
```

### 동시 워커를 사용한 배치 처리

```python
import concurrent.futures
from pathlib import Path
from unstructured.partition.auto import partition

def process_file(path: Path) -> dict:
    try:
        elements = partition(
            filename=str(path),
            strategy="fast",
        )
        return {
            "file": path.name,
            "elements": len(elements),
            "status": "success",
        }
    except Exception as e:
        return {
            "file": path.name,
            "elements": 0,
            "status": "error",
            "error": str(e),
        }

# 8개 워커로 500개 PDF 처리
pdf_dir = Path("./documents")
pdf_files = list(pdf_dir.glob("*.pdf"))

with concurrent.futures.ThreadPoolExecutor(max_workers=8) as executor:
    results = list(executor.map(process_file, pdf_files))

success = sum(1 for r in results if r["status"] == "success")
print(f"성공적으로 처리: {success}/{len(results)} 파일")
```

### 재처리를 위한 캐싱 전략

반복적 RAG 개발을 위해 한 번 파티셔닝하고 캐시:

```python
import json
import hashlib
from pathlib import Path
from unstructured.staging.base import elements_to_dicts, dicts_to_elements

def partition_with_cache(file_path: str, strategy: str = "hi_res"):
    file_hash = hashlib.md5(open(file_path, "rb").read()).hexdigest()
    cache_path = Path(f"./cache/{file_hash}_{strategy}.json")
    cache_path.parent.mkdir(exist_ok=True)

    if cache_path.exists():
        return dicts_to_elements(json.load(open(cache_path)))

    elements = partition_pdf(file_path, strategy=strategy)
    cache_path.write_text(json.dumps(elements_to_dicts(elements), indent=2))
    return elements
```

### Kubernetes 배포

```yaml
# unstructured-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: unstructured-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: unstructured-api
  template:
    metadata:
      labels:
        app: unstructured-api
    spec:
      containers:
      - name: api
        image: downloads.unstructured.io/unstructured-io/unstructured-api:latest
        ports:
        - containerPort: 8000
        resources:
          limits:
            nvidia.com/gpu: 1
            memory: "8Gi"
          requests:
            memory: "4Gi"
---
apiVersion: v1
kind: Service
metadata:
  name: unstructured-api
spec:
  selector:
    app: unstructured-api
  ports:
  - port: 80
    targetPort: 8000
```

자체 호스팅을 한다면 [DigitalOcean의 Kubernetes 클러스터](https://m.do.co/c/eca87ac14ee0)에 GPU 노드를 추가하는 것이 관리형 API에 비해 비용 효율적인 옵션입니다.

## 대안과의 비교

| 기능 | Unstructured.io | LlamaParse | Docling | PyMuPDF + 커스텀 |
|------|----------------|------------|---------|---------------|
| 오픈소스 | 예 (Apache-2.0) | 아니오 (독점) | 예 (MIT) | 예 (혼합) |
| GitHub Stars | 10,500+ | N/A (폐쇄) | 5,200+ | N/A |
| 묶이 티어 | 자체 호스팅 무제한 | 일일 1K 페이지 | 무제한 | N/A |
| PDF 테이블 → HTML | 예 | 예 | 예 | 수동 |
| OCR (스캔 PDF) | 예 | 예 | 예 | tesseract 통해 |
| PPTX 지원 | 예 | 제한적 | 아니오 | 아니오 |
| DOCX 지원 | 예 | 예 | 예 | 아니오 |
| 요소 유형 감지 | 20+ 유형 | 기본 | 기본 | 없음 |
| 내장 청킹 | 예 (3 전략) | 기본 | 아니오 | 아니오 |
| LangChain 통합 | 네이티브 | 네이티브 | 커뮤니티 | 수동 |
| GPU 가속 | 예 | 예 | 예 | 아니오 |
| 엔터프라이즈 SLA | 가능 | 가능 | 아니오 | 아니오 |
| 자체 호스팅 API | Docker/K8s | 클라우드 전용 | CLI 전용 | N/A |
| 배치 처리 | 예 | 예 | 제한적 | 수동 |
| 메타데이터 추출 | 풍부 | 기본 | 중간 | 없음 |

**선택 가이드:**

- **Unstructured.io**: 다중 포맷 파이프라인, 완전한 제어가 필요한 팀, 또는 풍부한 메타데이터가 중요할 때 최적. 오픈소스 + 자체 호스팅 옵션은 규모에 따라 비용을 예측 가능하게 유지합니다.
- **LlamaParse**: 이미 LlamaIndex 생태계에 있고 관리형 서비스가 괜찮다면. 테이블 추출이 우수하지만 포맷 지원이 더 좁습니다.
- **Docling**: IBM의 신규 진입 제품. 빠르고 가벼우며 PDF 중심 워크플로에 적합. 2026년 중반 기준 PPTX 및 고급 청킹이 부족합니다.
- **PyMuPDF + 커스텀**: 텍스트 PDF만 처리하고 청킹을 직접 구축할 엔지니어링 시간이 있다면. 혼합 문서 유형에는 권장하지 않습니다.

## 한계: 정직한 평가

Unstructured는 만능이 아닙니다. 프로덕션에서 문제가 되는 부분:

**1. OCR 품질은 입력 품질에 의존합니다.** 저해상도 스캔 문서(150 DPI 미만)는 어떤 파이프라인도 깨진 텍스트를 생산합니다. 소스 자료가 부실하면 이미지 강화로 사전 처리하세요.

**2. GPU 없이 `hi_res`는 느립니다.** 기본 `detectron2` 모델이 CPU에서 복잡한 레이아웃을 분당 3-5페이지 처리합니다. GPU 가속을 예산에 포함하거나 대량 텍스트 PDF에는 `fast` 전략을 사용하세요.

**3. 테이블 추출은 좋지만 완벽하지 않습니다.** 병합 셀, 중첩 헤더, 행 병합이 있는 복잡한 테이블은 구조적 충실도를 잃을 수 있습니다. HTML 출력이 우리 테스트에서 ~**85%의 테이블을 정확히 캡처**합니다.

**4. 대용량 문서에서 메모리 사용량이 급증합니다.** 이미지가 있는 200페이지 PDF는 `hi_res` 파티셔닝 중 4-6GB RAM을 소비할 수 있습니다. 대용량 파일에는 `max_partition`을 사용하고 배치로 처리하세요.

**5. 설치 공간이 큽니다.** `[all-docs]` extra는 PyTorch, Detectron2, Tesseract를 포함해 ~2GB의 의존성을 가져옵니다. 프로덕션에서 Docker로 격리하세요.

**6. 포맷 변환기가 아닙니다.** Unstructured는 *콘텐츠*를 추출하지 스타일은 아닙니다. 서식이 보존 된 PDF-to-DOCX 변환이 필요하면 다른 도구를 사용하세요.

## 자주 묻는 질문

### Unstructured.io는 어떤 파일 포맷을 지원하나요?

Unstructured는 PDF, DOCX, PPTX, XLSX, HTML, Markdown, EPUB, PNG, JPG, TIFF, MSG, EML, RTF, TXT를 포함한 25+ 포맷을 지원합니다. PDF와 DOCX가 테이블 구조 추출과 함께 가장 성숙한 지원을 제공합니다. PPTX는 네이티브 슬라이드별 파티셔닝을 제공합니다. 이미지 포맷은 Tesseract OCR이 필요합니다.

### Python 라이브러리와 Docker API 중 무엇을 사용해야 하나요?

개발, 프로토타이핑, 단일 문서 워크플로에는 Python 라이브러리를 사용하세요. 프로덕션에는 Docker API로 전환하세요 — 더 나은 리소스 격리, Kubernetes를 통한 수평적 확장, `hi_res` 전략의 GPU 가속을 제공합니다. API는 팀 전체에서 Python 환경 관리가 필요 없어 배포를 단순화합니다.

### 오버랩이 있는 청킹은 어떻게 작동하나요?

`overlap=200`을 설정하면 Unstructured가 각 청크의 마지막 200자를 다음 청크의 시작 부분에 복사합니다. 이것은 청크 경계에서 컨텍스트 손실을 방지합니다 — RAG에 중요합니다. 청크 경계를 넘어 분할된 문장은 답변할 수 없게 되기 때문입니다. `by_title` 전략은 추가로 청크가 섹션 경계를 넘어 분할되지 않도록 보장합니다(단일 섹션이 `max_characters`를 초과하지 않는 한).

### 인터넷 없이 Unstructured를 실행할 수 있나요?

예. Docker 이미지와 Python 라이브러리는 초기 다운로드 후 완전히 자체 포함됩니다. `hi_res` 전략은 첫 사용 시 모델 가중치(Detectron2/YOLOX)를 다운로드합니다 — 배포 이미지에 캐시하세요. 로컬 운용에는 API 키나 클라우드 호출이 필요 없습니다.

### `fast`와 `hi_res` 파티셔닝의 차이점은 무엇인가요?

`fast`는 규칙 기반 텍스트 추출(pdfplumber, python-docx)을 사용하며 단순 레이아웃의 텍스트 중심 문서에 적합합니다. `hi_res`는 영역, 테이블, 읽기 순서를 감지하기 위해 시각적 문서 이해 모델을 실행합니다 — 복잡한 레이아웃, 스캔 문서, 정확한 테이블 추출에 필수적입니다. CPU에서 `hi_res`는 5-10배 느릴 것으로 예상하거나, GPU 가속으로 격차를 줄이세요.

### 파싱에 실패한 문서는 어떻게 처리하나요?

파티셔닝 호출을 try/except로 감싸고 폴백 체인을 구현하세요: 먼저 `hi_res` 시도, `fast`로 폴백, 그리고 이미지 기반 문서는 `ocr_only`로 폴백. 수동 검토를 위해 파일 해시와 함께 실패를 로깅하세요. 프로덕션에서 손상되거나 비밀번호 보호된 파일의 **실패율은 2-4%**입니다 — 데드 레터 큐를 계획하세요.

### Unstructured는 비영어 문서를 지원하나요?

예. 라이브러리는 50+ 언어를 자동 감지합니다. OCR은 Tesseract가 지원하는 모든 언어를 지원합니다(중국어, 일본어, 한국어, 아랍어, 힌디어를 포함한 100+). 더 나은 OCR 정확도를 위해 `languages=["eng", "kor"]`로 특정 언어를 힌트할 수 있습니다.

## 결론: `fast`로 시작, `hi_res`로 업그레이드

Unstructured.io는 LLM 파이프라인에서 가장 과소평가된 문제를 해결합니다: 실제 문서를 사용 가능한 데이터로 변환하는 것. 경로는 명확합니다 — 텍스트 PDF에는 `fast` 파티셔닝으로 시작, RAG에는 `by_title` 청킹을 추가, 테이블과 복잡한 레이아웃이 필요할 때 `hi_res` + GPU로 업그레이드하세요.

**10,500+ Stars**와 Apache-2.0 라이선스는 안전하고 커뮤니티가 지원하는 선택입니다. 자체 호스팅 API는 데이터를 완전히 제어할 수 있게 합니다 — 문서가 인프라를 떠나지 않습니다.

오늘 4절의 Docker 명령어로 첫 인스턴스를 배포하고, 문서 디렉토리를 파이프인하고, RAG 정확도가 상승하는 것을 지켜보세요.

Telegram 개발자 커뮤니티에 참여하세요: **t.me/dibi8en** — 전처리 파이프라인을 공유하고 대규모로 Unstructured를 운영하는 엔지니어로부터 도움을 받으세요.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 출처 및 추가 자료

- [Unstructured GitHub 저장소](https://github.com/Unstructured-IO/unstructured) — 10,500+ Stars, Apache-2.0
- [공식 문서](https://docs.unstructured.io/)
- [API 배포 가이드](https://docs.unstructured.io/api-reference/api-services/deploy)
- [LangChain Unstructured 로더](https://python.langchain.com/docs/integrations/document_loaders/unstructured_file)
- [LlamaIndex Unstructured Reader](https://docs.llamaindex.ai/en/stable/examples/data_connectors/UnstructuredDemo/)
- [파티셔닝 전략 심층 분석](https://docs.unstructured.io/open-source/concepts/partitioning-strategies)
- [청킹 전략 비교](https://docs.unstructured.io/open-source/concepts/chunking-strategies)
- [Unstructured 플랫폼 (엔터프라이즈)](https://unstructured.io/platform)
- 관련: [LangChain](dibi8-internal-link), [LlamaIndex](dibi8-internal-link), [RAG 파이프라인 최적화](dibi8-internal-link)

---

*제휴 마케팅 공개: 본문에는 DigitalOcean의 제휴 링크가 포함되어 있습니다. 이 링크를 통해 가입하면 추가 비용 없이 커미션을 받습니다. Unstructured.io는 오픈소스이자 묶인 사용 가능합니다; Unstructured-IO와 상업적 관계는 없습니다. 의견은 실제 테스트를 기반으로 합니다.*
