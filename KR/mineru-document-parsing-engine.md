---

lang: kr
title: 'MinerU: 별 70.6K개 — 모든 문서를 LLM 지원 마크다운으로 변환'
description: 'MinerU(70,600개 이상의 GitHub 스타)는 LLM, RAG 및 에이전트 워크플로를 위해 PDF, DOCX, PPTX, XLSX, 이미지 및 웹 페이지를 구조화된 Markdown 및 JSON으로 변환합니다. 109개 언어 OCR, 수식-LaTeX, 테이블-HTML을 지원하고 CPU 또는 GPU에서 실행됩니다.'
tags: ["guide", "open-source", "ai-agents", "rag", "pdf", "ocr", "reference", "tutorial"]
date: 2026-06-27 00:00:00+08:00
slug: 'mineru-document-parsing-engine'
category: ai-tools
github_repo: 'https://github.com/opendatalab/MinerU'
license: MinerU Open Source License (Apache 2.0-based)
lang: kr
featureImage: /images/articles/mineru-docs.png

---


![MinerU logo](https://gcore.jsdelivr.net/gh/opendatalab/MinerU@master/docs/images/MinerU-logo.png)

*MinerU — 단 1년 만에 70,600명의 GitHub 스타를 탄생시킨 오픈 소스 문서 구문 분석 엔진.*

AI 코딩 에이전트와 RAG 파이프라인 시대에 가장 큰 병목 현상은 모델 기능이 아니라 **데이터 품질**입니다. 세계에서 가장 강력한 LLM을 가질 수 있지만, 입력 문서가 깨진 표, 읽을 수 없는 수식, 깨진 헤더가 있는 지저분한 PDF라면 출력은 쓰레기가 될 것입니다.

PDF, DOCX, PPTX, XLSX, 이미지 및 웹 페이지를 **깨끗하고 구조화된 Markdown 및 JSON**으로 변환하는 OpenDataLab(InternLM 팀)의 문서 구문 분석 도구인 **MinerU**를 입력하세요. 이는 특히 다운스트림 LLM, RAG 및 에이전트 워크플로를 위해 설계되었습니다.

**70,600개 이상의 GitHub 별**, **5,900개의 포크** 및 **오늘에만 960개의 별 획득**을 통해 MinerU는 문서에서 LLM 파이프라인으로의 변환을 위한 오픈 소스 솔루션으로 빠르게 자리 잡았습니다.

## What Is MinerU?

MinerU는 중국 대형 언어 모델인 [InternLM](https://github.com/InternLM/InternLM)의 사전 학습 과정에서 탄생했습니다. 팀은 과학 논문과 기술 문서를 기계가 읽을 수 있는 형식으로 변환하는 것이 특히 수식, 표 및 복잡한 레이아웃의 경우 엄청난 어려움을 겪는다는 점을 발견했습니다.

그래서 그들은 MinerU를 만들었습니다.

원시 텍스트만 추출하는 기존 PDF 파서와 달리 MinerU는 문서 구조를 이해합니다.

- 의미론적 일관성을 깨뜨리는 머리글, 바닥글, 각주, 페이지 번호 **제거** 
- 단일 열, 다중 열 및 복잡한 레이아웃에 대한 읽기 순서 **유지** 
- **수식을 LaTeX로, 표를 HTML로 변환** 
- 스캔되고 왜곡된 PDF를 **감지**하고 자동으로 OCR을 활성화합니다. 
- **OCR 인식을 위한 109개 언어 지원** 
- 읽기 순서로 정렬된 **출력** 다중 모드 Markdown, NLP Markdown 및 JSON

그 결과 AI 에이전트와 LLM이 실제로 이해할 수 있는 문서 내용이 탄생합니다.

## Installation and Setup

MinerU는 필요에 따라 다양한 설치 경로를 제공합니다:

### pip (대부분의 사용자에게 권장)

```bash
pip install mineru
```

### 도커

```bash
docker pull mineru/mineru:latest
docker run --gpus all -v $(pwd):/data mineru/mineru:latest
```

### 지역 개발

```bash
git clone https://github.com/opendatalab/MinerU.git
cd MinerU
pip install -e .
```

MinerU는 **CPU 전용** 추론과 **GPU 가속** 추론을 모두 지원합니다. GPU 가속을 위해서는 CUDA 지원과 함께 설치하십시오.

```bash
pip install mineru[cuda]
```

Apple Silicon이 탑재된 macOS에서 MinerU는 가속을 위해 MPS(Metal Performance Shaders)를 활용합니다.

## Three Parsing Engines

MinerU는 각기 다른 시나리오에 최적화된 세 가지 구문 분석 백엔드를 제공합니다.

### 1. 파이프라인 백엔드(빠르고 안정적)

`파이프라인` 백엔드는 대부분의 사용자에게 기본 선택입니다. 빠르고 안정적이며 환각을 일으키지 않습니다. CPU에서 효율적으로 실행되며 일괄 처리에 이상적입니다.

```bash
mineru ./input.pdf -o ./output/
```

**최적의 용도:** 대용량 문서 처리, CI/CD 파이프라인, CPU 전용 환경.

### 2. VLM 엔진(고정확도)

VLM(Vision Language Model) 엔진은 최첨단 구문 분석 정확도를 위해 MinerU의 독점 'MinerU2.5-Pro-2604-1.2B' 모델을 사용합니다. 혼합된 레이아웃, 손으로 쓴 텍스트, 조밀한 수식이 포함된 복잡한 문서에 탁월한 성능을 발휘합니다.

```bash
mineru ./complex.pdf -o ./output/ --engine vlm-engine
```

**최적의 용도:** 복잡한 과학 논문, 스캔한 문서, 필기 콘텐츠, 다국어 OCR.

### 3. 하이브리드 엔진(균형)

'하이브리드' 엔진은 기본 텍스트 추출과 VLM 기반 분석을 결합합니다. 버전 3.3부터 '보통' 및 '높음' 수준의 '노력' 매개변수가 포함됩니다.

- **중간 노력:** 높은 것보다 35-220% 빠르며 OmniDocBench에서 정확도는 0.13포인트만 떨어집니다. 
- **많은 노력:** 이미지 분석 지원으로 정확도 극대화

```bash
mineru ./document.pdf -o ./output/ --engine hybrid-engine --effort medium
```

**최적의 용도:** 속도와 정확성의 균형이 필요한 프로덕션 워크로드.

## Supported Formats

MinerU는 광범위한 입력 형식을 지원합니다:

| Format | Support Level | Notes |
|--------|--------------|-------|
| PDF | Native | Text PDFs, scanned PDFs, garbled PDFs |
| DOCX | Native | Full structural preservation |
| PPTX | Native | Slides, layouts, embedded content |
| XLSX | Native | Tables, formulas, charts |
| Images | OCR | JPEG, PNG, TIFF, BMP, and more |
| Web Pages | Scraping | Full-page conversion to Markdown |

기본 DOCX, PPTX 및 XLSX 지원(버전 3.1.0에 추가됨)은 MinerU가 먼저 PDF로 변환하지 않고도 이러한 형식을 **직접** 구문 분석할 수 있음을 의미합니다. 이는 기존 작업 흐름에 비해 속도가 크게 향상됩니다.

## OCR: 109 Languages

MinerU의 OCR 엔진은 **109개 언어**를 지원하며 버전 3.4에서 PP-OCRv6으로 업그레이드되어 OmniDocBench v1.6 벤치마크에서 정확도가 약 11% 향상되었습니다.

버전 3.4부터 MinerU는 OCR 언어 구성을 단순화했습니다. 개별 언어(일본어, 중국어 번체, 영어, 라틴어)를 선택하는 대신 이제 모든 시나리오가 최적화된 'ch' OCR 모델을 통해 라우팅되므로 구성 복잡성이 줄어들고 정확성이 향상됩니다.

```bash
# Automatic OCR detection (recommended)
mineru ./scanned.pdf -o ./output/

# 특정 문서에 OCR을 강제 적용 
미네루 ./document.pdf -o ./output/ --ocr 
````

## Real-World Use Cases

### RAG 파이프라인 데이터 준비

MinerU는 RAG(Retrieval-Augmented Generation) 워크플로우를 위해 특별히 제작되었습니다. 읽기 순서, 제목, 의미 구조가 보존된 구조화된 마크다운으로 문서를 변환함으로써 RAG 시스템은 문서를 훨씬 더 효과적으로 청크하고 포함할 수 있습니다.

```python
import mineru as mu

결과 = mu.parse("./research_paper.pdf") 
# result.markdown: 삽입을 위한 깔끔한 마크다운 
# result.json: 검색을 위해 구조화된 JSON 
# result.layout: 디버깅을 위한 시각적 레이아웃 
````

### AI 에이전트 기술 자료

문서를 추론해야 하는 AI 에이전트의 경우 MinerU는 가능한 가장 깔끔한 입력을 제공합니다. 머리글, 바닥글, 페이지 번호를 제거하면 상담원이 반복적인 페이지 아티팩트로 인해 혼란을 겪는 일이 없습니다.

### 훈련 데이터 생산

MinerU는 원래 InternLM의 사전 훈련 파이프라인을 지원하기 위해 구축되었습니다. 복잡한 과학 논문을 깨끗한 텍스트로 변환하는 기능은 도메인별 LLM을 위한 고품질 교육 데이터를 생성하는 데 매우 중요합니다.

### 일괄 문서 처리

멀티 스레드 동시 추론 및 디스크에 대한 스트리밍 쓰기 지원을 통해 MinerU는 수동 분할 없이 수천 개의 문서를 처리할 수 있습니다. 슬라이딩 창 메커니즘은 긴 문서 시나리오에서 최대 메모리 사용량을 줄입니다.

## Integration Ecosystem

MinerU는 거의 모든 주요 AI 프레임워크와 통합됩니다.

| Framework | Integration |
|-----------|-------------|
| LangChain | Native document loader |
| LlamaIndex | Document parser integration |
| RAGFlow | Built-in parser |
| RAG-Anything | Pipeline integration |
| Flowise | Visual workflow support |
| Dify | Document processing node |
| FastGPT | Native support |

### MCP 서버

MinerU는 또한 Cursor, Claude Desktop 및 Windsurf와 같은 AI 코딩 도구와의 통합을 위해 **MCP 서버**를 제공합니다. 이를 통해 코딩 에이전트의 워크플로 내에서 문서를 직접 구문 분석할 수 있습니다.

```bash
# Start the MCP server
mineru-mcp-server
```

## Performance Benchmarks

MinerU의 '파이프라인' 백엔드는 이전 세대 VLM 모델 'MinerU2.0-2505-0.9B'의 정확도를 능가하는 **OmniDocBench v1.5**에서 **86.2점**을 달성했습니다.

'노력=중간' 하이브리드 엔진은 다음을 제공합니다.

- Linux에서 텍스트 PDF 시나리오의 경우 **~80% 더 빠름** 
- Windows에서 텍스트 PDF 시나리오의 경우 **~90% 더 빠름** 
- macOS의 텍스트 PDF 시나리오에서 **~220% 더 빠름** 
- `노력=높음`에 비해 **0.13점 정확도 하락**만 있음

## Why MinerU Stands Out

1. **인간이 아닌 AI를 위해 제작되었습니다.** 범용 PDF 변환기와 달리 MinerU의 출력은 LLM 소비에 최적화되어 있어 의미 구조를 보존하는 동시에 AI 모델을 혼란스럽게 하는 노이즈를 제거합니다.

2. **다중 형식 기본 지원.** DOCX, PPTX, XLSX, PDF, 이미지 및 웹 페이지 — 모두 형식 변환 중개자 없이 기본적으로 구문 분석됩니다.

3. **규모에 맞게 제작 가능.** 멀티스레드 동시성, GPU/CPU 유연성, Docker 배포 및 강력한 API/CLI/라우터 아키텍처를 통해 MinerU는 엔터프라이즈 워크로드에 적합합니다.

4. **오픈 라이선스.** AGPLv3에서 버전 3.1.0의 맞춤형 Apache 2.0 기반 라이선스로 이동하여 커뮤니티 및 상업적 사용에 대한 채택 장벽을 크게 줄였습니다.

5. **국내 AI 칩 지원.** Ascend, Cambricon, Enflame, Moore Threads 등을 포함한 10개 이상의 중국 AI 가속기와 호환됩니다.

## Getting Started

MinerU를 사용해 보는 가장 쉬운 방법은 설치가 필요 없이 데스크톱 클라이언트와 동일한 기능을 제공하는 [온라인 웹 애플리케이션](https://mineru.net/OpenSourceTools/Extractor?source=github)을 이용하는 것입니다.

개발자를 위해 [Colab 노트북](https://colab.research.google.com/gist/myhloli/a3cb16570ab3cfeadf9d8f0ac91b4fca/mineru_demo.ipynb)에서는 빠른 대화형 데모를 제공합니다.

```bash
# Install and parse your first document
pip install mineru
mineru ./my-document.pdf -o ./output/ --format markdown
```

## Limitations

- **복잡한 레이아웃:** MinerU는 대부분의 문서 유형을 잘 처리하지만 매우 복잡한 레이아웃(삽입된 그림과 표가 포함된 여러 열의 과학 논문)에는 여전히 수동 검토가 필요할 수 있습니다. 
- **VLM의 GPU 요구 사항:** VLM 엔진은 최적의 성능을 위해 상당한 VRAM(8GB 이상 권장)이 필요합니다. 
- **학습 곡선:** 3개 엔진 아키텍처와 다양한 구성 옵션은 초보자에게 부담스러울 수 있습니다.

## Conclusion

MinerU는 문서에서 LLM으로의 변환에서 중요한 진전을 나타냅니다. 기본 다중 형식 구문 분석, 109개 언어 OCR 및 AI에 최적화된 출력 형식을 결합하여 최신 AI 데이터 파이프라인의 중요한 격차를 메웁니다.

RAG 시스템을 구축하든, 도메인별 LLM을 교육하든, AI 에이전트를 위한 지식 기반을 생성하든 MinerU는 이러한 시스템이 실제로 작동하도록 명확하고 구조화된 입력을 제공합니다.

70,600명 이상의 스타, 활발한 개발 팀, 성장하는 프레임워크 통합을 통해 MinerU는 AI 시대의 오픈 소스 문서 구문 분석을 위한 사실상의 표준이 될 수 있는 위치에 있습니다.

## Resources

- GitHub 저장소: https://github.com/opendatalab/MinerU 
- 문서: https://opendatalab.github.io/MinerU/ 
- 온라인 데모: https://mineru.net/OpenSourceTools/Extractor 
- 기술 보고서(v3.1): https://arxiv.org/abs/2604.04771 
- 기술 보고서(v2.5): https://arxiv.org/abs/2509.22186 
- 기술 보고서(v2.0): https://arxiv.org/abs/2409.18839 
- HuggingFace 데모: https://huggingface.co/spaces/opendatalab/MinerU 
- ModelScope 데모: https://www.modelscope.cn/studios/OpenDataLab/MinerU 
- 디스코드 커뮤니티: https://discord.gg/Tdedn9GTXq

**공개**: 이 기사에는 제휴사 링크가 포함되어 있습니다. 당사 링크를 통해 가입하시면 추가 비용 없이 소액의 커미션을 받으실 수 있습니다. 이는 독립적인 기술 저널리즘을 지원하고 dibi8.com과 같은 리소스를 광고 없이 무료로 유지하는 데 도움이 됩니다.