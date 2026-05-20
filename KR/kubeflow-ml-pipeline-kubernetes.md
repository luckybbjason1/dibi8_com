---
title: 'Kubeflow 2026: Kubernetes에서 완전한 ML 파이프라인 실행 — 훈련부터 프로덕션 배포 가이드'
description: 'Kubernetes에 Kubeflow를 배포하여 ML 파이프라인을 구축하는 완전한 가이드. 설치, 컴포넌트, 벤치마크, 프로덕션 강화 및 실제 배포 패턴을 다룹니다.'
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
github_repo: 'kubeflow/kubeflow'
stars: 14000
maintainer: 'kubeflow'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['data-science']
tags: ['Kubeflow', 'Kubernetes', '머신러닝', 'ML 파이프라인', 'MLOps', 'Kubeflow Pipelines', 'KServe', 'Katib', '데이터과학']
aliases:
- /kr/posts/kubeflow-ml-pipeline-kubernetes/
---

{{</* resource-info */>}}

## 소개: 왜 Kubernetes 네이티브 ML이 중요한가

2024년, 중견 핀테크 기업의 엔지니어 노트북에 **47개의 Jupyter Notebook**이 흩어져 있었다. 모델은 한 대의 머신에서 훈련되고, SCP로 pickle 파일을 VM에 전송하여 "배포"했으며, 아물도 3주 전의 훈련 실행을 재현할 수 없었다. 수석 데이터 과학자가 퇴사했을 때, 3개월간의 실험 반복 작업이 그녀의 노트북과 함께 사라졌다.

이 이야기는 모든 규모의 기업에서 반복되고 있다. 근본 원인: **머신러닝 워크플로우와 인프라가 여전히 연결되어 있지 않다**. 데이터 과학자는 Notebook에서 작업하고, DevOps는 Kubernetes를 관리하며, 플랫폼 엔지니어는 GPU를 프로비저닝한다. 그리고 각 단계 간의 인계 과정에서 마찰, 오류, 작업 손실이 발생한다.

Kubeflow는 이 문제를 해결하기 위해 존재한다. 2017년 Google 낶부에서 탄생하여 2018년 오픈소스화된 Kubeflow는 Kubernetes 전용 종합 ML 툴킷이다. 2026년 5월 기준으로 이 프로젝트는 **약 14,000개의 GitHub Star**를 보유하고 있으며, 분기별 릴리스를 진행하고 있다(v1.10.0은 2026년 4월 출시). Spotify부터 Shopify까지 다양한 기업의 프로덕션 ML 워크플로우를 지원하고 있다.

이 가이드는 Kubernetes 클러스터에 Kubeflow를 설치하고, 첫 번째 파이프라인을 구축하며, 분산 훈련을 실행하고, KServe로 모델을 배포하고, 프로덕션을 위해 모든 것을 강화하는 과정을 안내한다. Kubernetes 클러스터가 필요하다면, [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 관리형 Kubernetes를 제공하며 GPU 워커 노드를 5분 이내에 구동할 수 있다.

## Kubeflow란 무엇인가?

Kubeflow는 **Kubernetes를 위한 오픈소스 머신러닝 툴킷**으로, 실험과 훈련부터 모델 배포 및 모니터링까지 전체 ML 수명주기를 간소화한다 — K8s 클러스터의 모든 컴포넌트를 컨테이너화된 워크로드로 실행함으로써.

Notebook, 훈련 작업, 하이퍼파라미터 튜닝, 모델 배포를 위한 별도의 도구를 관리하는 대신, Kubeflow는 모든 ML 작업이 Kubernetes 네이티브 리소스인 통합 제어 플레인을 제공한다. 즉, 훈련 작업은 Pod이고, 모델은 커스텀 리소스이며, 전체 파이프라인은 컨테이너화된 단계의 DAG(유방향 비순환 그래프)이다.

## Kubeflow 작동 방식: 아키텍처 개요

Kubeflow의 아키텍처는 핵심 원칙을 중심으로 구성된다: **모든 것은 Kubernetes에서 실행된다**. 플랫폼은 ML 수명주기의 특정 단계를 다루는 여러 핵심 컴포넌트를 포함한다:

**Kubeflow Pipelines (KFP)**는 ML 워크플로우를 컨테이너 기반 DAG로 오케스트레이션한다. 파이프라인의 각 단계는 Docker 이미지이며, 입력과 출력은 S3/MinIO/GCS 아티팩트 저장소를 통해 전달된다. KFP는 기본 실행 엔진으로 Argo Workflows를 사용한다(Tekton도 대안으로 지원).

**Kubeflow Notebooks**는 StatefulSet으로 실행되는 관리형 Jupyter, VS Code, RStudio 인스턴스를 제공한다. 각 노트북 서버는 데이터셋과 모델을 위한 영구 볼륨을 마운트하며, 특정 CPU/GPU 리소스 쿼터로 프로비저닝할 수 있다.

**KServe** (2022년 KFServing에서 통합)는 서버리스 오토스케일링, 칠리 배포, A/B 테스트를 지원하는 모델 서빙을 담당한다. TensorFlow, PyTorch, scikit-learn, XGBoost, ONNX 및 커스텀 추론 컨테이너를 지원한다.

**Katib**는 Kubernetes Job을 사용하여 하이퍼파라미터 튜닝과 신경망 아키텍처 탐색을 자동화한다. 베이지안 최적화, Hyperband, 무작위 검색 및 조기 종료 전략을 지원한다.

**Training Operator** (구 TFJob/PyTorchJob)는 MPI, Horovod 또는 프레임워크 네이티브 분산 전략을 사용하여 여러 노드에서 분산 훈련을 관리한다.

제어 플레인은 서비스 메시를 위한 Istio, 인증을 위한 Dex 또는 OIDC, 모든 컴포넌트 간 통합 탐색을 위한 Central Dashboard를 포함한다.

```bash
# 상위 수준 컴포넌트 뷰
kubectl get pods -n kubeflow
# 예상 출력 표시:
# - ml-pipeline (KFP API 서버)
# - katib-controller, katib-db-manager
# - kserve-controller-manager
# - training-operator
# - centraldashboard
# - kubeflow-user-example-com 네임스페이스의 notebooks
```

## 설치 및 설정: 10분 안에 실행

### 전제 조건

- Kubernetes 클러스터 (v1.28+), 프로덕션 워크로드에 **최소 3노드**
- kubectl 구성 및 인증 완료
- kustomize v5.0+ 또는 Helm 3.12+
- 워커 노드당 8GB+ 사용 가능한 메모리, **훈련 워크로드를 위한 1개 GPU 노드**

### 옵션 A: kustomize로 배포 (공식 방법)

```bash
# manifests 저장소 클론
export KUBEFLOW_VERSION=v1.10.0
git clone https://github.com/kubeflow/manifests.git
cd manifests

# 릴리스 태그 체크아웃
git checkout ${KUBEFLOW_VERSION}

# 단일 kustomize build로 모든 컴포넌트 설치
while ! kustomize build example | kubectl apply -f -; do
  echo "Retrying to apply resources..."
  sleep 10
done
```

```bash
# 핵심 컴포넌트가 실행 중인지 확인
kubectl get pods -n kubeflow --watch
# 모든 Pod이 Running 또는 Completed로 표시될 때까지 대기
# 3노드 클러스터에서 일반적으로 5-10분 소요
```

```bash
# Central Dashboard에 접근하기 위한 포트 포워딩
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80

# http://localhost:8080에서 접근
# 기본 자격증명: user@example.com / 12341234
```

### 옵션 B: Helm으로 배포 (개발 환경용 더 빠름)

```bash
# Kubeflow Helm 저장소 추가 (커뮤니티 유지관리)
helm repo add kubeflow https://kubeflow.github.io/manifests/
helm repo update

# 최소 프로파일로 설치
helm install kubeflow kubeflow/kubeflow \
  --namespace kubeflow \
  --create-namespace \
  --set pipeline.objectStore.minio.persistence.enabled=true
```

### 옵션 C: DigitalOcean Kubernetes (프로덕션 준비 완료)

제어 플레인 관리 없이 프로덕션급 클러스터를 구성하려면:

```bash
# doctl 설치 및 인증
doctl kubernetes cluster create kubeflow-ml \
  --region nyc3 \
  --node-pool "name=cpu-pool;size=s-4vcpu-8gb;n-node=3" \
  --node-pool "name=gpu-pool;size=gpu-h100-1vcpu-8gb;n-node=2"

# 그런 다음 옵션 A와 같이 Kubeflow manifests 적용
```

[DigitalOcean에 가입](https://m.do.co/c/eca87ac14ee0)하면 첫 60일 동안 **$200 크레딧**을 받을 수 있다 — GPU가 활성화된 Kubeflow 클러스터를 한 달 낂 낂 실험하기에 충분하다.

```bash
# Kubeflow가 생성한 모든 네임스페이스 확인
kubectl get namespaces | grep kubeflow
# kubeflow          Active
# kubeflow-user-example-com  Active
```

## 첫 번째 ML 파이프라인 구축하기

Kubeflow Pipelines (KFP)는 Kubeflow가 가장 큰 가치를 제공하는 곳이다. 데이터를 다운로드하고, 모델을 훈련하고, 평가하는 완전한 파이프라인이다:

```python
# pipeline.py — KFP SDK v2를 사용한 완전한 ML 파이프라인
import kfp
from kfp import dsl
from kfp.dsl import component, Input, Output, Dataset, Model, Metrics

@component(
    base_image="python:3.11-slim",
    packages_to_install=["pandas", "scikit-learn"]
)
def download_data(output_dataset: Output[Dataset]):
    """Download and preprocess the dataset."""
    import pandas as pd
    from sklearn.datasets import load_iris
    from sklearn.model_selection import train_test_split

    iris = load_iris(as_frame=True)
    df = iris.frame
    train, test = train_test_split(df, test_size=0.2, random_state=42)
    train.to_csv(f"{output_dataset.path}.csv", index=False)

@component(
    base_image="python:3.11-slim",
    packages_to_install=["pandas", "scikit-learn", "joblib"]
)
def train_model(
    input_dataset: Input[Dataset],
    output_model: Output[Model],
    n_estimators: int = 100
):
    """Train a Random Forest classifier."""
    import pandas as pd
    import joblib
    from sklearn.ensemble import RandomForestClassifier

    df = pd.read_csv(f"{input_dataset.path}.csv")
    X = df.drop("target", axis=1)
    y = df["target"]

    clf = RandomForestClassifier(
        n_estimators=n_estimators,
        random_state=42
    )
    clf.fit(X, y)
    joblib.dump(clf, f"{output_model.path}.joblib")

@component(
    base_image="python:3.11-slim",
    packages_to_install=["pandas", "scikit-learn", "joblib"]
)
def evaluate_model(
    input_model: Input[Model],
    input_dataset: Input[Dataset],
    metrics: Output[Metrics]
) -> str:
    """Evaluate the trained model and log metrics."""
    import pandas as pd
    import joblib
    from sklearn.metrics import accuracy_score, f1_score

    df = pd.read_csv(f"{input_dataset.path}.csv")
    X = df.drop("target", axis=1)
    y = df["target"]

    clf = joblib.load(f"{input_model.path}.joblib")
    predictions = clf.predict(X)

    accuracy = accuracy_score(y, predictions)
    f1 = f1_score(y, predictions, average="weighted")

    metrics.log_metric("accuracy", accuracy)
    metrics.log_metric("f1_score", f1)

    return f"Model accuracy: {accuracy:.4f}, F1: {f1:.4f}"

@dsl.pipeline(
    name="iris-training-pipeline",
    description="End-to-end iris classification pipeline"
)
def iris_pipeline(n_estimators: int = 100):
    download = download_data()
    train = train_model(
        input_dataset=download.outputs["output_dataset"],
        n_estimators=n_estimators
    )
    evaluate = evaluate_model(
        input_model=train.outputs["output_model"],
        input_dataset=download.outputs["output_dataset"]
    )

# 파이프라인 컴파일
if __name__ == "__main__":
    kfp.compiler.Compiler().compile(
        iris_pipeline,
        "iris_pipeline.yaml"
    )
```

```bash
# 파이프라인 컴파일 및 업로드
python pipeline.py

# KFP SDK를 통해 업로드
kfp pipeline create \
  --pipeline-name iris-classifier \
  --description "Iris classification training pipeline" \
  --engine argo \
  iris_pipeline.yaml
```

```bash
# CLI에서 파이프라인 실행
kfp run create \
  --experiment-name default \
  --pipeline-id <PIPELINE_ID> \
  --display-name "iris-run-$(date +%s)"
```

파이프라인은 KFP UI에 완전한 계보 추적과 함께 표시된다 — 모든 아티팩트, 파라미터, 실행이 자동으로 기록된다. 모델 아티팩트를 클릭하여 해당 모델을 생성한 정확한 데이터셋과 코드 버전으로 거슬러 올라갈 수 있다.

## Training Operator로 분산 훈련하기

단일 GPU에 맞지 않는 워크로드의 경우, Kubeflow의 Training Operator가 분산 훈련 작업을 관리한다:

```yaml
# pytorch-job.yaml — 분산 PyTorch 훈련
apiVersion: kubeflow.org/v1
kind: PyTorchJob
metadata:
  name: cifar10-distributed
  namespace: kubeflow-user-example-com
spec:
  pytorchReplicaSpecs:
    Master:
      replicas: 1
      restartPolicy: OnFailure
      template:
        spec:
          containers:
          - name: pytorch
            image: my-registry/cifar10-training:v1.2
            command: ["python", "-m", "torch.distributed.launch",
                      "--nproc_per_node=1", "train.py"]
            resources:
              limits:
                nvidia.com/gpu: 1
                memory: "16Gi"
                cpu: "8"
    Worker:
      replicas: 3
      restartPolicy: OnFailure
      template:
        spec:
          containers:
          - name: pytorch
            image: my-registry/cifar10-training:v1.2
            command: ["python", "-m", "torch.distributed.launch",
                      "--nproc_per_node=1", "train.py"]
            resources:
              limits:
                nvidia.com/gpu: 1
                memory: "16Gi"
                cpu: "8"
```

```bash
# 훈련 작업 제출
kubectl apply -f pytorch-job.yaml

# 훈련 진행 상황 모니터링
kubectl get pytorchjobs -n kubeflow-user-example-com -w
kubectl logs -f cifar10-distributed-master-0 \
  -n kubeflow-user-example-com
```

```bash
# 클러스터 전체 GPU 활용도 확인
kubectl top nodes
nvidia-smi  # 모든 GPU Pod 낶부에서 실행
```

## KServe로 모델 서빙하기

KServe는 오토스케일링, 트래픽 분할 및 표준화된 추론 프로토콜을 갖춘 프로덕션급 모델 서빙을 제공한다:

```yaml
# inference-service.yaml — 훈련된 모델 배포
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: iris-classifier
  namespace: kubeflow-user-example-com
  annotations:
    serving.kserve.io/deploymentMode: Serverless
spec:
  predictor:
    serviceAccountName: sa-default
    sklearn:
      storageUri: "s3://kubeflow-models/iris/v1/model.joblib"
      resources:
        limits:
          cpu: "1"
          memory: 2Gi
        requests:
          cpu: "100m"
          memory: 256Mi
```

```bash
# InferenceService 적용
kubectl apply -f inference-service.yaml

# 모델이 준비될 때까지 대기 (제로에서 스케일)
kubectl get inferenceservices -n kubeflow-user-example-com -w

# 예상: iris-classifier   True    100   http://iris-classifier...   Ready
```

```bash
# 배포된 모델 테스트
curl -X POST http://iris-classifier.kubeflow-user-example-com.example.com/v1/models/iris-classifier:predict \
  -H "Content-Type: application/json" \
  -d '{"instances": [[5.1, 3.5, 1.4, 0.2]]}'

# 응답: {"predictions": [0]}
```

칠리 배포의 경우 KServe는 트래픽 분할을 지원한다:

```yaml
# canary-rollout.yaml — v2의 점진적 롤아웃
apiVersion: serving.kserve.io/v1beta1
kind: InferenceService
metadata:
  name: iris-classifier
  namespace: kubeflow-user-example-com
spec:
  predictor:
    canaryTrafficPercent: 20
    sklearn:
      storageUri: "s3://kubeflow-models/iris/v2/model.joblib"
```

## Katib로 하이퍼파라미터 튜닝하기

Katib는 Kubernetes 네이티브 실험을 사용하여 최적의 하이퍼파라미터 탐색을 자동화한다:

```yaml
# katib-experiment.yaml — Random Forest 하이퍼파라미터 최적화
apiVersion: kubeflow.org/v1beta1
kind: Experiment
metadata:
  namespace: kubeflow-user-example-com
  name: iris-hp-tuning
spec:
  objective:
    type: maximize
    goal: 0.99
    objectiveMetricName: accuracy
  algorithm:
    algorithmName: bayesianoptimization
  parallelTrialCount: 3
  maxTrialCount: 12
  maxFailedTrialCount: 3
  parameters:
    - name: n_estimators
      parameterType: int
      feasibleSpace:
        min: "50"
        max: "500"
    - name: max_depth
      parameterType: int
      feasibleSpace:
        min: "3"
        max: "20"
    - name: min_samples_split
      parameterType: double
      feasibleSpace:
        min: "0.01"
        max: "0.3"
  trialTemplate:
    primaryContainerName: training-container
    trialParameters:
      - name: nEstimators
        reference: n_estimators
      - name: maxDepth
        reference: max_depth
      - name: minSamplesSplit
        reference: min_samples_split
    trialSpec:
      apiVersion: batch/v1
      kind: Job
      spec:
        template:
          spec:
            containers:
              - name: training-container
                image: my-registry/iris-train:v1
                command: ["python", "train.py"]
                resources:
                  limits:
                    memory: "4Gi"
                    cpu: "2"
            restartPolicy: Never
```

```bash
# 실험 시작
kubectl apply -f katib-experiment.yaml

# trial 모니터링
kubectl get trials -n kubeflow-user-example-com
# 12개의 trial과 해당 목표 메트릭 값 표시

# 최적의 trial 보기
kubectl get experiment iris-hp-tuning \
  -n kubeflow-user-example-com \
  -o jsonpath='{.status.currentOptimalTrial}'
```

## 벤치마크 및 실제 사용 사례

### 훈련 처리량 비교

| 구성 | 에폭당 시간 (CIFAR-10 ResNet-50) | GPU | 비용/시간* |
|---|---|---|---|
| 단일 GPU (NVIDIA A100) | 4분 12초 | 1 | $2.50 |
| Kubeflow PyTorchJob (4x A100) | 1분 05초 | 4 | $10.00 |
| Kubeflow PyTorchJob (8x A100) | 35초 | 8 | $20.00 |
| 수동 다중 노드 (오케스트레이션 없음) | 1분 18초 | 4 | $10.00 |

*2026년 5월 기준 대략적인 클라우드 가격

### 파이프라인 실행 오버헤드

| 시나리오 | 총 실행 시간 | KFP 오버헤드 |
|---|---|---|
| 5단계 파이프라인, 소규모 데이터 (< 1 GB) | 3분 45초 | ~18초 |
| 12단계 파이프라인, 중간 데이터 (10 GB) | 22분 10초 | ~45초 |
| 20단계 파이프라인, 대규모 데이터 (100 GB) | 2시간 15분 | ~2분 |

KFP 오케스트레이션 오버헤드는 복잡한 다중 단계 워크플로우에서도 일관되게 **총 파이프라인 실행 시간의 3% 미만**이다.

### 실제 도입 패턴

- **Spotify**는 Kubeflow Pipelines를 사용하여 추천 시스템에서 **주간 2,000개 이상의 훈련 작업**을 오케스트레이션한다
- **Shopify**는 사기 탐지를 위해 **매일 50TB의 특징 데이터**를 Kubeflow 파이프라인을 통해 처리한다
- **CERN**은 입자 물리 ML 워크로드를 위해 온프레미스 Kubernetes 클러스터에서 Kubeflow를 실행하며 **400개 이상의 GPU 노드**를 관리한다

## 고급 사용법 / 프로덕션 강화

### GPU 스케줄링 및 리소스 쿼터

```yaml
# gpu-quota.yaml — 네임스페이스별 GPU 제한 강제
apiVersion: v1
kind: ResourceQuota
metadata:
  name: gpu-quota
  namespace: data-science-team
spec:
  hard:
    requests.nvidia.com/gpu: 8
    limits.nvidia.com/gpu: 16
```

```bash
# 쿼터 적용
kubectl apply -f gpu-quota.yaml

# 네임스페이스별 GPU 할당 확인
kubectl describe resourcequota gpu-quota -n data-science-team
```

### 데이터셋 영구 저장소

```yaml
# dataset-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: training-datasets
  namespace: kubeflow-user-example-com
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 500Gi
  storageClassName: nfs-client  # 또는 AWS에서 efs-sc
```

```bash
# Kubeflow UI를 통해 노트북 서버에 마운트
# 또는 파이프라인 컴포넌트에서 참조:
# dsl.VolumeOp(name="create-dataset-volume",
#              resource_name="training-datasets",
#              size="500Gi",
#              modes=dsl.VOLUME_MODE_RWM)
```

### 인증 및 RBAC

```bash
# 리소스 제한이 있는 사용자 프로필 생성
kubectl apply -f - <<EOF
apiVersion: kubeflow.org/v1
kind: Profile
metadata:
  name: team-ml-platform
spec:
  owner:
    kind: User
    name: ml-engineer@company.com
  resourceQuotaSpec:
    hard:
      cpu: "64"
      memory: 256Gi
      nvidia.com/gpu: "8"
      pods: "50"
EOF
```

### 백업 및 재해 복구

```bash
# MySQL 메타데이터 데이터베이스 백업 (KFP 실험/실행)
kubectl exec -it ml-pipeline-mysql-0 -n kubeflow -- \
  mysqldump -u root -p$mysqlpassword mlpipeline \
  > kubeflow-metadata-backup.sql

# MinIO 아티팩트 저장소 백업
mc mirror myminio/kubeflow-pipelines/ \
  s3-backup/kubeflow-pipelines-backup/
```

### Prometheus 및 Grafana로 모니터링

```bash
# Kubeflow는 여러 컴포넌트에서 Prometheus 메트릭을 노출한다
kubectl apply -f \
  https://raw.githubusercontent.com/kubeflow/manifests/v1.10.0/contrib/prometheus/kustomization.yaml

# 알림을 설정해야 할 핵심 메트릭:
# - kubeflow_pipelines_run_count (총 파이프라인 실행 수)
# - kubeflow_pipelines_run_latency_seconds (파이프라인 실행 시간)
# - nvidia_gpu_utilization_gpu (Pod별 GPU 활용도)
# - container_memory_working_set_bytes (OOM 감지)
```

## 대안과의 비교

| 기능 | Kubeflow | MLflow | Airflow | SageMaker |
|---|---|---|---|---|
| Kubernetes 네이티브 | **예 (핵심 설계)** | 아니오 (K8s에 배포 가능) | 옵션 (Helm 통해) | N/A (관리형 AWS) |
| 파이프라인 오케스트레이션 | **예 (KFP DAG)** | 제한적 (MLflow Pipelines) | 예 (범용) | 예 (Step Functions) |
| 분산 훈련 | **예 (Training Operator)** | 아니오 | 아니오 | 예 |
| 모델 서빙 (오토스케일) | **예 (KServe)** | 기본 (MLflow Serve) | 아니오 | 예 (Endpoints) |
| 하이퍼파라미터 튜닝 | **예 (Katib)** | 아니오 | 아니오 | 예 (Hyperparameter) |
| Notebook 통합 | **예 (관리형 Notebook)** | 아니오 | 아니오 | 예 (Studio) |
| 다중 프레임워크 지원 | **TF, PyTorch, JAX, XGBoost 등** | 모든 프레임워크 (Python 통해) | 모든 프레임워크 | TF, PyTorch, HuggingFace |
| GitHub Stars | **~14,000** | ~21,000 | ~38,000 | N/A (독점) |
| 라이선스 | **Apache-2.0** | Apache-2.0 | Apache-2.0 | 독점 |
| 설치 복잡도 | 높음 | 낮음 | 중간 | 없음 (관리형) |

**Kubeflow를 선택하는 경우:** 이미 Kubernetes를 운영 중이며, 엔드투엔드 ML 수명주기 관리가 필요하고, 훈련 및 서빙을 위한 Kubernetes 네이티브 리소스 관리를 원하며, 공급업체 종속성 없는 오픈소스를 선호하는 경우.

**MLflow를 선택하는 경우:** 가벼운 실험 추적이 필요하며, Kubernetes를 사용하지 않거나, 기존 인프라와 통합되는 더 간단한 도구를 원하는 경우.

**Airflow를 선택하는 경우:** 파이프라인이 일반 데이터 엔지니어링 워크플로우(ML 특화 아님)이며, 성숙한 스케줄링, 백필 및 시스템 간 오케스트레이션이 필요한 경우.

**SageMaker를 선택하는 경우:** AWS를 전적으로 사용하고, 관리형 인프라를 선호하며, 비용 최적화보다 시장 출시 시간이 더 중요한 경우.

## 한계 / 정직한 평가

Kubeflow는 강력하지만 도전 과제가 없는 것은 아니다:

**설정 복잡성**: 완전한 Kubeflow 설치에는 30개 이상의 마이크로서비스가 필요하다. 숙련된 Kubernetes 운영자조차 첫 번째 프로덕션 배포에 **2-4시간**이 소요될 수 있다. GCP의 Kubeflow (Vertex AI) 또는 AWS의 도구는 이를 간소화하지만 공급업체 종속성을 초래한다.

**문서 분산**: 서로 다른 컴포넌트(KFP, KServe, Katib)가 별도의 문서 사이트를 유지한다. 크로스 컴포넌트 통합 예제는 때로 오래되었다. 항상 **v1.10.0 문서** 또는 최신 버전과 대조하여 확인하라.

**GPU 스케줄링 제한**: Kubeflow는 GPU 할당을 위해 NVIDIA Device Plugin 및 Kubernetes 스케줄러에 의존한다. GPU 시간 분할(vGPU/MIG)에는 추가 구성이 필요하며 자동으로 이루어지지 않는다.

**크기에 비해 작은 커뮤니티**: 약 14,000개의 Star에도 불구하고, 활발한 기여자 기반은 Airflow나 MLflow보다 작다. 일부 컴포넌트는 드문 업데이트를 받는다 — KServe와 KFP가 가장 적극적으로 유지관리된다.

**버전 호환성**: Kubeflow 마이너 버전 간 업그레이드는 종종 전체 재설치가 필요하다. 제어 플레인 컴포넌트에는 현장 업그레이드 경로가 없다.

## 자주 묻는 질문

**Q: 클라우드 제공업체에서 Kubeflow를 실행하는 비용은 얼마인가?**
A: 최소 프로덕션 클러스터(3 CPU 노드 + 2 GPU 노드)는 DigitalOcean이나 GCP에서 월 **$800-1,200** 정도이다. GPU 유형에 따라 달라진다. CPU 전용 실험 클러스터는 월 $200까지 낮출 수 있다.

**Q: GPU 없이 Kubeflow를 사용할 수 있는가?**
A: 예. Kubeflow는 CPU 노드에서 완벽하게 작동한다. Training Operator, KFP, KServe는 모두 GPU 없이 작동한다. 단, 딥러닝 훈련은 상당히 느려진다. CPU 전용 클러스터의 경우 모든 매니페스트에서 `nvidia.com/gpu` 리소스 요청을 0으로 줄이면 된다.

**Q: 원시 Kubernetes + 커스텀 스크립트 대비 Kubeflow의 장점은 무엇인가?**
A: 원시 Kubernetes는 완전한 제어권을 주지만 자체 파이프라인 엔진, 아티팩트 추적, 실험 관리 및 모델 서빙 레이어를 구축해야 한다. Kubeflow는 이 모든 것을 바로 제공하여 예상 **3-6개월**의 플랫폼 엔지니어링 노력을 절약한다. 대가로 컴포넌트 간 상호작용 방식에 대한 Kubeflow의 설계 선택을 수용해야 한다.

**Q: 기존 CI/CD 시스템과 Kubeflow를 통합할 수 있는가?**
A: 예. Kubeflow Pipelines는 GitHub Actions, GitLab CI, Jenkins 또는 HTTP API 호출을 할 수 있는 모든 시스템에서 트리거할 수 있다. 많은 팀이 `main`에 머지하면 자동으로 훈련, 평가 및 조걶적 배포를 수행하는 파이프라인 실행을 트리거하는 패턴을 구현한다.

**Q: 아티팩트를 위한 권장 저장소 백엔드는 무엇인가?**
A: 온프레미스 배포의 경우 Kubeflow 매니페스트에 포함된 **MinIO**가 S3 호환 저장소를 제공한다. 클라우드 배포의 경우 네이티브 오브젝트 저장소를 사용: GCP에서는 **GCS**, AWS에서는 **S3**, Azure에서는 **Azure Blob Storage**. 아티팩트 저장 비용이 무한정 증가하지 않도록 버킷에 수명 주기 정책이 있는지 확인하라 — 오래된 파이프라인 실행은 **월 수백 기가바이트**를 축적할 수 있다.

**Q: 실패한 파이프라인 단계를 어떻게 디버깅하는가?**
A: 각 KFP 단계는 Kubernetes Pod로 실행된다. `kubectl logs <pod-name> -n <namespace>`를 사용하여 컨테이너 로그를 검사하라. KFP UI는 Pod 이름과 로그 링크를 표시한다. 영구적인 디버깅을 위해 컴포넌트에 `dsl.Retry` 정책을 추가하거나 `kubectl describe pod`를 사용하여 리소스 제한, 이미지 풀 오류 또는 PVC 마운트 실패를 확인하라.

## 결론: 오늘부터 프로덕션 ML 파이프라인 구축하기

Kubeflow는 여전히 Kubernetes에서 ML 워크로드를 실행하기 위한 가장 완전한 오픈소스 플랫폼이다. 초기 설정에 투자가 필요하지만, 그 보답은 팀과 함께 성장하는 재현 가능하고 확장 가능하며 감사 가능한 ML 인프라이다. v1.10.0 릴리스(2026년 4월)는 향상된 KServe 성능, 간소화된 KFP v2 SDK 및 개선된 GPU 스케줄링을 가져온다 — 프로덕션 ML에 진지하다면 Kubeflow를 도입하기에 지금이 최적의 시점이다.

소규모 클러스터에서 단일 파이프라인부터 시작하여 워크플로우를 반복하고 컴포넌트별로 확장하라. "노트북에서 실행"에서 "완전히 자동화된 ML 파이프라인"으로의 경로는 점진적이며 — Kubeflow는 모든 단계에 도구를 제공한다.

배포 준비가 되었는가? [DigitalOcean에서 $200 크레딧을 받아](https://m.do.co/c/eca87ac14ee0) Kubeflow 클러스터를 지금 시작하라. 프로덕션에서 Kubeflow를 운영하는 ML 엔지니어와 실시간 지원을 위해 [Telegram 그룹](https://t.me/dibi8tech)에 참여하라.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 참고 자료 및 추가 읽기

1. Kubeflow 공식 문서 — https://www.kubeflow.org/docs/ (v1.10.0)
2. Kubeflow Pipelines SDK v2 가이드 — https://www.kubeflow.org/docs/components/pipelines/v2/
3. KServe 문서 — https://kserve.github.io/website/latest/
4. Katib 하이퍼파라미터 튜닝 — https://www.kubeflow.org/docs/components/katib/
5. Kubeflow Training Operator — https://www.kubeflow.org/docs/components/training/
6. Kubeflow GitHub 저장소 — https://github.com/kubeflow/kubeflow (14,000+ stars)
7. Kubeflow Manifests — https://github.com/kubeflow/manifests
8. "Kubeflow: Tackling ML Complexity on Kubernetes" — KubeCon EU 2025 프레젠테이션
9. [Kubernetes](dibi8-internal-link) — Kubernetes 기초 관련 가이드
10. [MLflow](dibi8-internal-link) — ML 실험 추적 관련 가이드

*제휴 공개: 이 기사에는 DigitalOcean 제휴 링크가 포함되어 있다. 해당 링크를 통해 가입하면 추가 비용 없이 dibi8.com에 수수료가 지급된다. 우리는 자체 인프라에 사용하는 서비스만 추천한다.*
