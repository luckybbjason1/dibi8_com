---
title: 'GraphRAG: 마이크로소프트의 지식 그래프 기반 RAG로 더 나은 LLM 답변 (33K Stars) — 2026 실전 가이드'
description: 'GraphRAG는 마이크로소프트의 모듈형 지식 그래프 기반 RAG 시스템입니다(GitHub 33,403 스타, MIT 라이선스). 이 가이드는 설치, init/index/query 워크플로, 실제 CLI 예제, 그리고 LangChain·Haystack과의 솔직한 비교를 다룹니다.'
date: 2026-06-02 00:00:00+08:00
lastmod: 2026-06-02 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'microsoft/graphrag'
stars: 33403
maintainer: 'microsoft'
last_maintained: '2026-06-02'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: []
aliases:
- /posts/graphrag-llm-frameworks-2026/
faqs:
  - q: 'graphrag는 어떻게 설치하나요?'
    a: 'PyPI에서 한 줄로 설치합니다(Python 3.10–3.12): ```bash pip install graphrag ```'
  - q: 'graphrag 실행에 필요한 시스템 요건은 무엇인가요?'
    a: 'GraphRAG에는 Python 3.10–3.12와, API 키를 통한 언어 모델 접근(OpenAI, Azure OpenAI 또는 그 밖의 지원 제공자)이 필요합니다. Python을 지원하는 모든 현대 운영체제에서 동작합니다.'
  - q: '프로젝트에 기여할 수 있나요?'
    a: '네. 이 프로젝트는 MIT 라이선스로 오픈소스이며 기여를 환영합니다. 가이드라인은 GitHub의 [CONTRIBUTING.md](https://github.com/microsoft/graphrag/blob/main/CONTRIBUTING.md) 파일을 참고하세요.'
  - q: '문제나 버그는 어떻게 신고하나요?'
    a: '저장소의 GitHub Issues 페이지를 이용하세요. 오류 메시지, 설정, 재현 단계 등 가능한 한 자세한 정보를 포함해 주세요.'
  - q: 'GraphRAG는 일반 벡터 RAG와 무엇이 다른가요?'
    a: '일반 RAG는 유사한 청크 몇 개를 가져와 거기서 답을 만듭니다. GraphRAG는 이에 더해 문서로부터 지식 그래프와 커뮤니티 요약을 구축하므로, 넓고 코퍼스 전체에 걸친 질문(전역 검색)뿐 아니라 엔티티에 집중된 질문(지역 검색)에도 답할 수 있습니다.'
---

{{< resource-info >}}

## 들어가며

전형적인 검색 증강 생성(RAG)은 벡터 유사도로 텍스트 청크 몇 개를 가져와 프롬프트에 끼워 넣습니다. 사실 조회 질문에는 잘 통하지만, 코퍼스 전체에 흩어진 단서를 "이어 붙여야" 하는 질문에는 약합니다. 마이크로소프트의 `graphrag`는 다른 길을 택합니다. LLM을 이용해 문서에서 엔티티와 관계로 이루어진 **지식 그래프**를 추출하고, 그 위에 커뮤니티 요약을 구축한 뒤, 그 구조를 바탕으로 질문에 답합니다. GitHub 스타가 33,403개를 넘고 MIT 라이선스를 따르며, 최근 2년간 가장 주목받은 RAG 프로젝트 중 하나입니다. 이 가이드에서는 GraphRAG를 설치하고 실제 `init` / `index` / `query` 워크플로를 실행해 본 뒤, 여러분의 사용 사례에 맞는지 솔직하게 판단해 봅니다.

## graphrag란?

GraphRAG는 모듈형 그래프 기반 검색 증강 생성 파이프라인입니다. 문서를 그저 평평하게 쌓인 청크 더미로 다루는 대신, 언어 모델로 텍스트를 읽어 엔티티와 엔티티 간의 관계를 뽑아내고 이를 하나의 지식 그래프로 조립합니다. 그런 다음 그 그래프를 커뮤니티로 클러스터링하고 각 커뮤니티에 대한 요약을 생성합니다.

이 프로젝트는 마이크로소프트 리서치(Microsoft Research)가 유지보수하며 Python으로 작성되었습니다. 명령줄 도구이자 Python 라이브러리로 배포되고, `settings.yaml` 파일을 통해 설정합니다. 그 결과, 일반 벡터 RAG가 놓치기 쉬운 넓고 코퍼스 전체에 걸친 질문("이 문서들 전반을 관통하는 주제는 무엇인가?")에도 답할 수 있습니다.

## graphrag의 동작 방식

GraphRAG는 문제를 오프라인 인덱싱 단계와 온라인 질의 단계로 나눕니다.

1. **인덱싱**: GraphRAG는 원본 문서를 청크로 나눈 뒤, LLM에게 각 청크에서 엔티티·관계·주장을 추출하도록 합니다. 이것들은 하나의 지식 그래프로 병합됩니다. 그래프는 (Leiden 알고리즘으로) 커뮤니티로 분할되고, LLM이 각 커뮤니티에 대한 요약 보고서를 작성합니다.

2. **질의 — 전역 검색(Global Search)**: 코퍼스 전체에 대한 넓은 질문에는 GraphRAG가 커뮤니티 요약을 map-reduce 방식으로 활용합니다. 다수의 커뮤니티 보고서를 두고 추론한 다음, 부분 답변들을 최종 응답으로 결합합니다.

3. **질의 — 지역 검색(Local Search)**: 특정 엔티티에 집중된 질문에는 GraphRAG가 해당 엔티티의 이웃, 관계, 관련 원문을 가져온 뒤 초점이 맞춰진 답변을 생성합니다.

이 두 가지 모드 설계가 바로 GraphRAG를 평범한 벡터 스토어와 갈라놓는 지점입니다. 전역 검색은 큰 그림을, 지역 검색은 세부 사항을 줍니다.

## 설치 및 설정

graphrag를 정기적으로 실행되는 프로덕션 작업으로 돌리려면 항상 켜져 있는 서버가 필요합니다. [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 하나 띄우거나(신규 계정 무료 체험 크레딧 제공), dibi8.com을 호스팅하는 곳과 같은 IDC인 [HTStack](https://my.htstack.com/aff.php?aff=27187)의 저지연 홍콩 VPS를 쓰면 됩니다.

GraphRAG는 Python 3.10–3.12가 필요합니다. 권장 설치 방법은 pip입니다:

```bash
pip install graphrag
```

설치한 뒤 워크스페이스를 초기화합니다. 이 단계가 GraphRAG가 기대하는 설정 파일과 폴더 구조를 만들어 줍니다:

```bash
mkdir -p ./ragtest/input
# put your .txt or .csv documents into ./ragtest/input
python -m graphrag init --root ./ragtest
```

`init` 명령은 프로젝트 루트에 `settings.yaml`과 `.env` 파일을 생성합니다. `.env`를 열어 모델 API 키를 설정하세요. 예를 들면:

```bash
GRAPHRAG_API_KEY=<your-openai-or-azure-key>
```

### 자주 겪는 오류와 해결

첫 실행에서 가장 흔한 문제는 API 키가 없거나 비어 있는 경우입니다. 인덱싱이 시작하자마자 인증 오류로 실패한다면, `./ragtest/.env`에 `GRAPHRAG_API_KEY`가 설정되어 있는지, 그리고 `settings.yaml`의 모델 이름이 실제로 여러분의 키로 접근 가능한 모델인지 확인하세요. 설정된 모델을 계정에서 사용 가능한 모델로 바꾸면 대개 해결됩니다.

## 핵심 사용법

`init` 이후의 전형적인 흐름은 이렇습니다. input 폴더에 문서를 넣고, 인덱스를 빌드한 뒤, 질의합니다.

### 1단계: 인덱스 빌드

워크스페이스에 대해 인덱싱 파이프라인을 실행합니다. 그래프를 추출하느라 LLM 호출이 많아지는, 비용이 가장 큰 단계입니다:

```bash
python -m graphrag index --root ./ragtest
```

완료되면 GraphRAG는 엔티티 그래프, 커뮤니티 보고서, 임베딩을 Parquet 파일로 `./ragtest/output` 아래에 기록합니다.

### 2단계: 전역 검색

여러 문서를 종합해야 하는 넓고 코퍼스 전체에 걸친 질문에는 전역 검색을 사용합니다:

```bash
python -m graphrag query \
  --root ./ragtest \
  --method global \
  --query "What are the major themes in these documents?"
```

### 3단계: 지역 검색

질문이 특정 엔티티나 코퍼스의 좁은 부분에 집중될 때는 지역 검색을 사용합니다:

```bash
python -m graphrag query \
  --root ./ragtest \
  --method local \
  --query "What is the relationship between Entity A and Entity B?"
```

`init`, `index`, `query` 이 세 명령이 GraphRAG의 핵심 루프를 모두 포괄합니다. 설정 옵션, 프롬프트 튜닝, 고급 설정은 공식 문서를 참고하세요: [https://microsoft.github.io/graphrag/](https://microsoft.github.io/graphrag/)

## 통합

인덱싱은 일반적인 Parquet 산출물(엔티티, 관계, 커뮤니티 보고서, 텍스트 단위 임베딩)을 만들어 내므로, GraphRAG는 나머지 Python 데이터 생태계와 깔끔하게 통합됩니다.

### 산출물 직접 다루기

생성된 그래프와 보고서를 pandas로 바로 불러와 검사, 맞춤 검색, 다운스트림 분석에 쓸 수 있습니다:

```python
import pandas as pd

entities = pd.read_parquet("./ragtest/output/entities.parquet")
relationships = pd.read_parquet("./ragtest/output/relationships.parquet")
community_reports = pd.read_parquet("./ragtest/output/community_reports.parquet")

print(entities.head())
print(community_reports[["title", "summary"]].head())
```

### settings.yaml로 커스터마이즈

GraphRAG의 동작은 `init`이 만들어 준 `settings.yaml` 파일로 제어합니다. 거기서 채팅·임베딩 모델을 고르고, 청크 크기를 정하고, 동시성을 조절하며, 입력 데이터를 지정합니다. 간략화한 발췌는 다음과 같습니다:

```yaml
models:
  default_chat_model:
    type: openai_chat
    model: gpt-4o-mini
  default_embedding_model:
    type: openai_embedding
    model: text-embedding-3-small

chunks:
  size: 1200
  overlap: 100

input:
  type: file
  file_type: text
  base_dir: "input"
```

이 파일을 편집하는 것이 GraphRAG를 다른 모델 제공자, 다른 문서 유형, 다른 청킹 전략에 맞추는 방법입니다. 코드를 바꿀 필요가 없습니다.

## 실전 활용

GraphRAG는 마이크로소프트 리서치가 개발하고 MIT 라이선스로 배포되며, 단일 문서가 아니라 코퍼스 전체에 걸친 질문을 다루는 지식 베이스·연구·분석 워크로드에 채택되어 왔습니다.

### 빛을 발하는 지점

"그래프 + 커뮤니티 요약" 방식은 방대한 텍스트에 대해 "의미 종합(sensemaking)"이 필요할 때 가장 가치가 큽니다. 예컨대 여러 보고서를 관통하는 주제를 요약하거나, 여러 문서에 걸친 엔티티 간 관계를 추적하거나, 증거가 코퍼스 곳곳에 흩어진 질문에 답하는 경우입니다. 이런 상황에서 GraphRAG의 전역 검색은 상위 k개 청크만 보는 기본 벡터 RAG보다 더 포괄적인 답을 내놓는 경향이 있습니다.

### 비용 인식

인덱싱은 LLM을 많이 씁니다. GraphRAG는 엔티티·관계 추출과 커뮤니티 보고서 작성을 위해 모델을 반복 호출하므로, 비용은 코퍼스 규모와 선택한 모델에 비례해 늘어납니다. 많은 팀이 인덱싱 비용을 통제하려고 더 작고 저렴한 채팅 모델(예: `gpt-4o-mini`)로 시작한 뒤, 자기 데이터에 더 강한 모델이 그만한 값을 하는지 평가합니다.

## 대안과의 비교

[관련 오픈소스 도구](dibi8-internal-link) 정리도 함께 보세요.

GraphRAG, LangChain, Haystack은 겹치지만 초점이 다른 문제를 풉니다. GraphRAG는 집중적이고 뚜렷한 방향성을 가진 그래프 RAG 파이프라인이고, LangChain과 Haystack은 다양한 종류의 LLM 애플리케이션과 RAG 파이프라인을 구축하는 범용 프레임워크입니다. 아래 표는 정면 벤치마크가 아니라 대략적인 방향 잡기용입니다. 스타 수와 이슈 수는 시간에 따라 변하므로 근사치로 봐 주세요.

| 특성 | **GraphRAG** | **LangChain** | **Haystack** |
|---|---|---|---|
| 주요 초점 | 그래프 기반 RAG 파이프라인 | 범용 LLM 앱 프레임워크 | RAG / 검색 프레임워크 |
| 언어 | Python | Python | Python |
| 라이선스 | MIT | MIT | Apache-2.0 |
| 유지보수 | 마이크로소프트 | LangChain, Inc. | deepset |
| 지식 그래프 추출 내장 | 내장 | 통합 통해 | 통합 통해 |
| 전역(코퍼스 전체) 질의 | 지원 | 내장 아님 | 내장 아님 |
| 즉시 쓸 수 있는 범위 | 좁음(그래프 RAG 전용) | 매우 넓음 | 넓음 |
| 문서 | 충실 | 충실 | 충실 |

### GraphRAG를 선택하는 이유

- **코퍼스 전체 질문을 위해 설계됨**: 전역 검색과 커뮤니티 요약은 평범한 벡터 RAG가 잘 못 다루는 "전체에 걸쳐 어떤 주제가 있는가?"류 질문을 겨냥합니다.
- **그래프 추출이 포함됨**: 엔티티·관계 추출이 파이프라인의 일부라서 직접 조립하지 않아도 됩니다.
- **마이크로소프트 리서치의 뒷받침**: 활발한 개발, 탄탄한 문서, 연구 기반 개선이 꾸준합니다.

### 고려할 점

짧은 사실형 답을 위한 상위 k개 검색만 필요하다면, 벡터 스토어를 곁들인 LangChain이나 Haystack 같은 범용 프레임워크가 더 가볍고 운영 비용도 낮습니다. GraphRAG의 추가 인덱싱 비용은 코퍼스의 *구조* 자체가 답에 중요할 때 비로소 값을 합니다.

## 한계와 솔직한 평가

GraphRAG는 적합한 작업에서는 강력하지만, 실질적인 트레이드오프가 있습니다.

1. **인덱싱 비용이 큼**: 그래프 구축에 LLM 호출이 많아, 코퍼스 규모에 따라 비용과 시간이 함께 커집니다. 가장 먼저 예산을 잡아야 할 항목입니다.
2. **설정에 손이 감**: 좋은 결과를 얻으려면 `settings.yaml`에서 청크 크기, 프롬프트, 모델 선택을 조정해야 할 때가 많습니다. 한 줄로 끝나는 드롭인 방식이 아닙니다.
3. **단순 조회에는 과함**: 답이 하나의 청크에 있는 좁은 Q&A라면 고전적 벡터 RAG가 더 빠르고 훨씬 저렴합니다.
4. **운영 부담**: 인덱싱 파이프라인과 Parquet 산출물을 관리해야 하고, 문서가 바뀌면 주기적으로 재인덱싱해야 합니다.
5. **품질은 모델에 달림**: 엔티티·관계 추출 품질은 설정한 채팅 모델의 성능을 따라가므로, 답변 품질이 모델 예산과 곧장 연결됩니다.

GraphRAG가 여러분의 구체적인 사용 사례에 맞는지 판단할 때 바로 이 트레이드오프들을 핵심으로 따져 봐야 합니다.

## 맺음말

GraphRAG는 마이크로소프트 리서치가 만든, 잘 유지보수되는 모듈형 그래프 기반 RAG 시스템으로, GitHub 스타가 33,403개를 넘고 Python으로 작성되었으며 MIT 라이선스를 따릅니다. 강점은 증거가 코퍼스 전체에 흩어진 질문에 답하는 것으로, 이는 평범한 벡터 RAG가 약한 부분입니다. 대가는 인덱싱 비용과 설정 노력입니다. 좋은 다음 단계는 작은 문서 묶음으로 `python -m graphrag init`을 돌려 보고, 전역 검색의 답을 지금 쓰는 RAG 구성과 비교해 보는 것입니다.

- 오픈소스 AI 도구 소식은 [dibi8 영어 Telegram 그룹](https://t.me/DIBI8_Group/2)에서 받아 보세요.
- 다음 읽을거리: [dibi8의 관련 가이드](dibi8-internal-link).

---

**출처 및 더 읽어보기**:
- GitHub 저장소: https://github.com/microsoft/graphrag
- 공식 문서 / README: https://github.com/microsoft/graphrag#readme

*위 링크 중 일부는 제휴(affiliate) 링크입니다. 이를 통해 가입하시면 추가 비용 없이 dibi8.com이 수수료를 받을 수 있습니다. 사이트 운영과 무료 콘텐츠 유지에 도움이 됩니다.*

<!-- internal-link-candidates:
  related open-source tools -> ai-tools-directory
  related guides on dibi8 -> ai-coding-agent-landscape-2026-skills-mcp-opensource
-->
