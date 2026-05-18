---
title: 'DVC vs LakeFS vs Delta Lake: ML을 위한 데이터 버전 관리 도구 선택 완벽 가이드'
description: 'DVC, LakeFS, Delta Lake을 비교하여 ML 데이터 버전 관리 도구를 선택하는 방법을 설명합니다. Git 기반 워크플로우부터 데이터 레이크 ACID 트랜잭션까지, 각 도구의 특징과 적합한 사용场景을 분석합니다.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Data Science
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
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/data-version-control-dvc-lakefs-delta-lake/
---

{</* resource-info */>}

머신러닝 프로젝트에서 재현성을 확보하려면 코드뿐 아니라 데이터와 모델 아티팩트까지 일관되게 관리해야 합니다. Git은 코드 버전 관리에 탁월하지만, 수 GB에서 TB 단위의 데이터셋이나 바이너리 모델 파일을 직접 추적하는 데는 한계가 있습니다. 이 글에서는 DVC, LakeFS, Delta Lake 세 가지 대표적인 데이터 버전 관리 도구의 설계 철학과 적합한 사용 사례를 비교합니다.

## 왜 Git만으로는 ML 데이터 버전 관리가 어려울까?

Git은 텍스트 기반 소스 코드 관리에 최적화되어 있습니다. 그러나 ML 워크플로우에서는 코드, 데이터, 모델 아티팩트가 서로 독립적으로 변경됩니다. Git의 `git diff`는 CSV나 Parquet 같은 바이너리 파일의 변화 내용을 제대로 보여주지 못합니다. 100GB 데이터셋을 Git 저장소에 직접 커밋하는 것도 비효율적입니다.

이런 이유로 **"Git for Data"** 개념이 등장했습니다. 데이터에 특화된 버전 관리 메커니즘은 다음 기능을 제공해야 합니다:

- 대용량 파일의 효율적 추적
- 파이프라인 실행 이력 관리
- 코드-데이터-모델의 3자 연동 잠금
- 분산 팀 간의 협업 지원

DVC, LakeFS, Delta Lake은 이 문제를 각기 다른 접근 방식으로 해결합니다.

## DVC (Data Version Control): 데이터에 Git을 더하다

[DVC](https://dvc.org)는 Git 확장 도구로, Git 명령어와 유사한 CLI를 제공합니다. `dvc add`, `dvc push`, `dvc pull` 같은 명령어는 Git 사용자에게 즉각적인 친숙함을 줍니다.

**핵심 특징:**

- **콘텐츠 주소 저장소(Content-Addressable Storage)**: 파일 내용의 해시값을 키로 사용해 중복 제거
- **파이프라인 코드화**: `dvc.yaml`로 데이터 처리 단계를 정의하고 의존성을 추적
- **원격 저장소 지원**: S3, GCS, Azure Blob Storage, SSH, HDFS 등 연동
- **실험 관리 통합**: `dvc exp` 명령어로 실험 분기와 메트릭 비교

### DVC 파이프라인과 재현성

DVC는 `dvc.yaml` 파일로 파이프라인을 정의합니다. 각 단계의 입력 데이터, 실행 스크립트, 출력 모델을 명시하면 DVC는 의존성 그래프를 자동으로 구성합니다.

```yaml
# dvc.yaml 예시
stages:
  prepare:
    cmd: python prepare.py data/raw.csv data/prepared.csv
    deps:
      - prepare.py
      - data/raw.csv
    outs:
      - data/prepared.csv
  train:
    cmd: python train.py data/prepared.csv model.pkl
    deps:
      - train.py
      - data/prepared.csv
    outs:
      - model.pkl
```

`dvc repro` 명령어는 변경된 단계만 선택적으로 재실행합니다. 이전 실행 결과는 캐시에 저장되어 동일한 입력에 대해 불필요한 재계산을 방지합니다.

**DVC에 적합한 팀:** Git을 일상적으로 사용하는 소규모-중규모 팀, 파일 기반 ML 실험, 가벼운 도구를 선호하는 환경

## LakeFS: 데이터 레이크를 위한 Git 브랜칭

[LakeFS](https://lakefs.io)는 S3 기반 데이터 레이크 위에 Git과 유사한 브랜칭과 버전 관리를 제공하는 오픈소스 플랫폼입니다. 데이터를 복사하지 않고도 제로 카피 브랜치를 생성할 수 있습니다.

**핵심 특징:**

- **제로 카피 브랜칭**: S3 객체 메타데이터 수준에서 분기 생성, 실제 데이터 복사 없음
- **ACID 보장**: 객체 저장소 레벨에서 원자적 트랜잭션 지원
- **S3 API 호환**: 기존 Spark, Pandas, Trino 코드 수정 없이 연동
- **프리커밋 훅**: 데이터 품질 검증을 병합 전에 자동 실행

### LakeFS 브랜칭과 데이터 병합

LakeFS는 `lakefs://repo/main` 같은 URI 체계로 데이터에 접근합니다. `main` 브랜치에서 `experiment-2024` 브랜치를 생성하면, 팀원들은 격리된 환경에서 데이터를 자유롭게 실험할 수 있습니다.

```python
# LakeFS 브랜치 생성 예시
import lakefs

repo = lakefs.Repository("ml-datasets")
main = repo.branch("main")
experiment = repo.branch("experiment-2024").create(
    source_reference=main
)
# experiment 브랜치에서 독립적으로 데이터 수정
```

병합 시 충돌이 발생하면 LakeFS가 제공하는 UI나 API로 해결할 수 있습니다. Spark, Pandas, Trino와의 통합은 표준 S3 API를 그대로 사용하기 때문에 별도 어댑터가 필요 없습니다.

**LakeFS에 적합한 팀:** 대규모 데이터 레이크 운영, 다수의 소비자가 동일 데이터를 사용하는 환경, 데이터 CI/CD 파이프라인이 필요한 조직

## Delta Lake: 데이터 레이크에 ACID 트랜잭션을

[Delta Lake](https://delta.io)는 Apache Spark를 위해 개발된 오픈소스 스토리지 레이어입니다. Parquet 파일 위에 트랜잭션 로그를 추가하여 데이터 레이크를 데이터 웨어하우스 수준의 신뢰성으로 격상시킵니다.

**핵심 특징:**

- **ACID 트랜잭션**: 다중 테이블 동시 쓰기, 원자적 커밋 보장
- **타임 트래블**: `AS OF VERSION` 쿼리로 과거 데이터 상태 조회
- **스키마 강제 및 진화**: 쓰기 시 스키마 검증, 안전한 컬럼 추가
- **Z-오더링**: 데이터 클러스터링으로 쿼리 성능 최적화
- **통합 배치/스트리밍**: Structured Streaming과 원활한 통합

### Delta Lake 타임 트래블과 최적화

Delta Lake의 타임 트래블 기능은 실수로 데이터를 삭제하거나 덮어쓴 경우에도 과거 버전으로 복구할 수 있게 해줍니다. 기본적으로 최근 30일간의 버전 히스토리를 유지합니다.

```sql
-- Delta Lake 타임 트래블 예시
SELECT * FROM my_table VERSION AS OF 5;
SELECT * FROM my_table TIMESTAMP AS OF '2024-01-01T00:00:00Z';

-- 오래된 버전 정리 (VACUUM)
VACUUM my_table RETAIN 168 HOURS;

-- Z-오더링으로 성능 최적화
OPTIMIZE my_table ZORDER BY (user_id);
```

**Delta Lake에 적합한 팀:** Spark 기반 워크플로우, Lakehouse 아키텍처 구축, 분석과 ML을 결합하는 환경

## 아키텍처와 설계 철학 비교

세 도구의 근본적인 차이는 설계 철학에서 비롯됩니다.

| 비교 항목 | DVC | LakeFS | Delta Lake |
|-----------|-----|--------|------------|
| **버전 관리 모델** | Git 확장 (파일 단위) | Git-like 서버 (객체 단위) | 스토리지 레이어 (테이블 단위) |
| **브랜칭** | Git 브랜치와 연동 | 네이티브 제로 카피 브랜칭 | 타임 트래블로 대체 |
| **쿼리 통합** | 간접 (파일 경로 추적) | S3 API 호환 (직접) | Spark SQL, Delta Rust |
| **스토리지 모델** | 원격 저장소 (S3/GCS 등) | S3/GCS 위 메타데이터 레이어 | Parquet + 트랜잭션 로그 |
| **설정 복잡도** | 낮음 (pip 설치) | 중간 (서버 구축 필요) | 중간 (Spark 통합) |
| **인프라 요구사항** | 최소 | LakeFS 서버 | Spark/Delta Lake 호환 엔진 |
| **적합한 규모** | 소규모-중규모 팀 | 대규모 데이터 레이크 | 중대규모 Spark 환경 |

## 어떤 도구를 선택해야 할까?

도구 선택은 기존 기술 스택과 요구사항에 따라 달라집니다.

**DVC를 선택하는 경우:**

- Git을 일상적으로 사용하는 팀
- 실험 중심의 ML 워크플로우
- 가벼운 설정과 빠른 도입을 원함
- 파일 기반 데이터셋 (CSV, 이미지 디렉토리 등)

**LakeFS를 선택하는 경우:**

- S3 기반 데이터 레이크 운영
- 다수 팀이 동일 데이터에 접근
- 데이터 브랜칭과 CI/CD 파이프라인 필요
- 객체 스토리지 수준의 버전 관리 요구

**Delta Lake를 선택하는 경우:**

- Apache Spark 메인 워크플로우
- ACID 트랜잭션이 필수적인 환경
- 타임 트래블 쿼리가 필요
- Lakehouse 아키텍처 구축 계획

## MLOps 생태계와의 통합

데이터 버전 관리는 MLOps 파이프라인의 한 축입니다. MLflow나 Weights & Biases 같은 실험 추적 도구와 연동하면 코드-데이터-모델의 3방향 버전 잠금을 구현할 수 있습니다.

**통합 아키텍처 예시:**

1. DVC로 데이터 버전 관리
2. MLflow로 모델 실험 추적
3. [Feast](https://docs.feast.dev/)로 피처 저장소 운영
4. CI/CD 파이프라인에서 `dvc repro`와 `mlflow run` 연동
5. 모델 모니터링에서 데이터 드리프트 감지 시 자동 재학습 트리거

## 재현 가능한 ML 파이프라인 구축하기

완전한 재현성을 위한 엔드투엔드 워크플로우는 다음 단계로 구성됩니다:

1. **데이터 버저닝**: DVC로 원본 데이터 버전 커밋
2. **전처리 실행**: `dvc.yaml`에 정의된 파이프라인 실행
3. **모델 학습**: 학습 스크립트 실행 후 모델 아티팩트 추적
4. **모델 등록**: MLflow에 메트릭과 함께 모델 버전 등록
5. **결과 재현**: `git checkout` + `dvc checkout`으로 과거 상태 복원

이 워크플로우는 6개월 전의 실험 결과도 동일하게 재현할 수 있게 해줍니다.

## 자주 묻는 질문

### DVC와 LakeFS를 함께 사용할 수 있나요?

네, 두 도구는 서로 보완적입니다. LakeFS로 대규모 데이터 레이크의 브랜치 관리를 하고, DVC로 ML 실험 파이프라인과 모델 아티팩트를 추적할 수 있습니다. LakeFS의 `s3://` 경로를 DVC 원격 저장소로 설정하는 방식으로 통합합니다.

### Delta Lake는 Apache Spark 없이 사용할 수 있나요?

Delta Lake의 네이티브 API는 Spark에 최적화되어 있지만, [Delta Rust](https://github.com/delta-io/delta-rs) 프로젝트를 통해 Python(polars, pandas)이나 Rust 환경에서 Spark 없이도 사용할 수 있습니다. 2024년 기준 Delta Rust는 대부분의 읽기/쓰기 작업을 지원합니다.

### 데이터 버전 관리는 얼마나 많은 추가 저장소를 소모하나요?

DVC는 변경된 파일만 저장하므로, 불변 데이터셋의 경우 원본 크기와 유사한 수준입니다. LakeFS는 제로 카피 브랜칭으로 브랜치당 거의 추가 공간을 사용하지 않습니다. Delta Lake는 Parquet 파일 변경 시 새 버전 파일이 생성되며, VACUUM 명령어로 오래된 버전을 정리할 수 있습니다.

### 소규모 팀이 시작하기에 가장 좋은 도구는 무엇인가요?

DVC가 가장 진입장벽이 낮습니다. pip로 설치하고, 기존 Git 워크플로우에 `dvc add` 명령어 하나만 추가하면 시작할 수 있습니다. LakeFS나 Delta Lake는 서버 구축이나 Spark 환경 설정이 필요해 초기 진입장벽이 상대적으로 높습니다.

### LakeFS는 S3 외 다른 스토리지도 지원하나요?

네, LakeFS는 GCS, Azure Blob Storage와도 연동할 수 있습니다. 다만 S3 API 호환성이 가장 완성도가 높고, [Spark 통합](https://docs.lakefs.io/integrations/spark.html) 문서도 S3 기준으로 작성되어 있습니다.

---

**참고 자료:**

- [DVC 공식 문서](https://dvc.org/doc)
- [LakeFS GitHub 저장소](https://github.com/treeverse/lakeFS)
- [Delta Lake 공식 사이트](https://delta.io)
- [MLflow Documentation](https://mlflow.org/docs/latest/index.html)
- [Apache Spark 공식 문서](https://spark.apache.org/docs/latest/)

---

## 추천 인프라

위 도구들을 24/7 안정 운영하려면 인프라가 중요하다:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 신규 가입 시 $200 크레딧 60일, 글로벌 14+ 리전.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연. dibi8.com 자체 호스팅 IDC.

*추천 링크 — 추가 비용 없이 dibi8.com을 지원합니다.*

