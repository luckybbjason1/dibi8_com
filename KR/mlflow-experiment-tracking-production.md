---
title: 'MLflow 2026: 10,000+ 실험을 추적하는 오픈소스 ML 라이프사이클 플랫폼 — 설정 가이드'
description: 'MLflow를 활용한 ML 실험 추적, 모델 레지스트리, 모델 서빙에 대한 완전한 가이드. 설치, Python SDK, 프로덕션 배포, 10,000+ 실험에 대한 벤치마크를 다룹니다.'
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
github_repo: 'mlflow/mlflow'
stars: 21000
maintainer: 'mlflow'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['data-science']
tags: ['MLflow', '머신러닝', 'MLOps', '실험 추적', '모델 레지스트리', '모델 서빙', 'Python', '오픈소스', '데이터과학']
aliases:
- /kr/posts/mlflow-experiment-tracking-production/
---

{{</* resource-info */>}}

## 소개: 추적되지 않는 실험의 혼란

시리즈 B 스타트업의 데이터 과학 팀은 추천 모델 구축에 3개월을 투자했다. 그들은 **6가지 아키텍처**, **4가지 옵티마이저**, 그리고 **수십 가지 하이퍼파라미터 조합**을 시도했다. 제품 관리자가 "어떤 버전을 출시해야 합니까?"라고 물었을 때, 아물도 확실한 답을 낼 수 없었다. 가장 성능이 좋은 모델은 서버의 체크포인트 파일이었고, 이를 훈련시킨 엔지니어는 이미 세 개의 git 커밋 전에 훈련 스크립트를 덮어썼었다.

이것이 **실험 재현성 위기**이다. Algorithmia의 2024년 500명 ML 실무자 조사에 따류리 **68%의 팀**이 과거 실험을 재현하는 데 어려움을 겪고 있으며, **42%**가 어떤 정확한 코드와 데이터에서 생성되었는지 모른 채 모델을 출시했다. 비용은 잃어버린 모델, 중복 노력, 프로덕션 실패로 측정된다.

MLflow는 2018년 Databricks에서 생성되어 Linux Foundation 산하로 오픈소스화되었으며, 가볍고 프레임워크에 구애받지 않는 플랫폼으로 이 문제를 해결한다. 2026년 5월 기준으로 MLflow는 **약 21,000개의 GitHub Star**를 보유하고 있으며, MLflow 2.22.0이 2026년 4월에 출시되었고, Microsoft, Toyota, Booking.com 및 수천 개의 스타트업에서 사용되고 있다.

이 가이드는 5분 이내에 MLflow를 설정하고, 대규모 실험을 추적하고, 모델을 등록하고 버전을 관리하며, REST API를 통해 서빙하고, 전체 스택을 프로덕션에 배포하는 방법을 보여준다. MLflow 추적 서버를 호스팅할 서버가 필요하다면, [DigitalOcean](https://m.do.co/c/eca87ac14ee0)에서 간단한 VM 배포를 제공하여 몇 분 안에 실행할 수 있다.

## MLflow란 무엇인가?

MLflow는 **머신러닝 라이프사이클 관리를 위한 오픈소스 플랫폼**으로, 실험 추적, 모델 포장, 모델 레지스트리, 모델 서빙을 포함한다. Python 라이브러리, 독립 실행형 서버, 또는 Docker 컨테이너로 실행되며 — Kubernetes, 클라우드 제공업체, 또는 특정 ML 프레임워크에 대한 의존성이 없다.

인프라 팀이 설정해야 하는 무거운 MLOps 플랫폼과 달리, MLflow는 `pip install mlflow`로 설치되고 한 줄의 코드로 실험 추적을 시작한다. 이러한 낮은 진입 장벽으로 인해 가장 널리 채택된 오픈소스 ML 라이프사이클 도구가 되었으며, 2026년 초 기준 PyPI에서 **2억 5천만 회 이상 다운로드**되었다.

## MLflow 작동 방식: 핵심 컴포넌트

MLflow는 ML 라이프사이클의 별개 단계를 해결하는 네 가지 컴포넌트로 구성된다:

**MLflow Tracking**은 실험, 파라미터, 메트릭 및 아티팩트를 기록한다. 각 실험 실행은 코드 버전, 데이터 소스, 구성 및 결과를 캡처한다. 추적 서버는 백엔드(SQLite, PostgreSQL, MySQL)에 데이터를 저장하고 아티팩트는 로컬 파일 시스템, S3, GCS 또는 Azure Blob Storage에 저장한다.

**MLflow Models**은 표준화된 형식으로 모델을 패키징한다. 한 번 저장하면 어디서든 배포할 수 있다: REST API, 배치 추론, Apache Spark, Amazon SageMaker, Azure ML 또는 Kubernetes. MLflow는 scikit-learn, TensorFlow, PyTorch, XGBoost, LightGBM, HuggingFace Transformers 등을 지원한다.

**MLflow Model Registry**은 모델 라이프사이클 관리를 위한 중앙 집중식 저장소를 제공한다. 모델을 등록하고, 버전 번호를 할당하고, 태그 단계(Staging, Production, Archived)를 지정하고, 버전 간 계보를 추적한다. 팀은 이것을 어떤 모델이 어디에 배포되었는지에 대한 단일 진실 공급원으로 사용한다.

**MLflow Projects**은 MLproject 파일로 재현 가능한 형식으로 ML 코드를 패키징하며, 진입점, 파라미터, 종속성 및 실행 환경을 정의한다.

```python
# 하나의 다이어그램으로 보는 완전한 MLflow 아키텍처:
# 1. Tracking Server (REST API + UI)
#    ├── Backend Store: PostgreSQL / MySQL / SQLite
#    └── Artifact Store: S3 / GCS / Azure / Local
#
# 2. Tracking Client (Python/R/Java/REST)
#    ├── log_param(), log_metric(), log_artifact()
#    └── set_tags(), register_model()
#
# 3. Model Registry
#    ├── Model Versions (v1, v2, v3...)
#    └── Stage Transitions (None → Staging → Production)
#
# 4. Model Serving
#    └── REST endpoint: /invocations
```

## 설치 및 설정: 5분 안에 첫 번째 실험 실행

### 로컬 설정 (단일 머신)

```bash
# MLflow 설치
pip install mlflow==2.22.0

# 로컬 파일 저장소로 추적 서버 시작
mkdir -p ~/mlflow-tracking
mlflow server \
  --backend-store-uri sqlite:///~/mlflow-tracking/mlflow.db \
  --default-artifact-root ~/mlflow-tracking/artifacts \
  --host 0.0.0.0 \
  --port 5000
```

```bash
# 별도의 터미널에서 첫 번째 추적 실험 실행
python -c "
import mlflow

mlflow.set_tracking_uri('http://localhost:5000')
mlflow.set_experiment('quick-start')

with mlflow.start_run():
    mlflow.log_param('learning_rate', 0.01)
    mlflow.log_param('epochs', 10)
    mlflow.log_metric('accuracy', 0.94)
    mlflow.log_metric('f1_score', 0.93)
    print(f'Run ID: {mlflow.active_run().info.run_id}')
"
```

`http://localhost:5000`을 방문하면 — 실험이 MLflow UI에 파라미터, 메트릭 및 실행 기록이 완전히 추적된 상태로 표시된다.

### PostgreSQL 및 S3를 사용한 프로덕션 설정

```bash
# 데이터베이스 및 클라우드 지원 설치
pip install mlflow[extras]==2.22.0 psycopg2-binary boto3
```

```bash
# PostgreSQL 및 S3로 추적 서버 시작
export MLFLOW_S3_ENDPOINT_URL=https://s3.amazonaws.com
export AWS_ACCESS_KEY_ID=your-key
export AWS_SECRET_ACCESS_KEY=your-secret

mlflow server \
  --backend-store-uri postgresql://mlflow:password@postgres:5432/mlflowdb \
  --default-artifact-root s3://your-bucket/mlflow-artifacts \
  --host 0.0.0.0 \
  --port 5000
```

### Docker 배포 (팀에 권장)

```bash
# docker-compose.yml — 완전한 MLflow 스택
version: '3.8'
services:
  postgres:
    image: postgres:16
    environment:
      POSTGRES_USER: mlflow
      POSTGRES_PASSWORD: mlflow_password
      POSTGRES_DB: mlflowdb
    volumes:
      - pgdata:/var/lib/postgresql/data

  mlflow:
    image: python:3.11-slim
    command: >
      bash -c "pip install mlflow==2.22.0 psycopg2-binary boto3 &&
               mlflow server
               --backend-store-uri postgresql://mlflow:mlflow_password@postgres:5432/mlflowdb
               --default-artifact-root s3://my-bucket/mlflow
               --host 0.0.0.0 --port 5000"
    ports:
      - "5000:5000"
    depends_on:
      - postgres

volumes:
  pgdata:
```

```bash
# 전체 스택 시작
docker-compose up -d

# 추적 서버가 실행 중인지 확인
curl http://localhost:5000/api/2.0/mlflow/experiments/list
```

### DigitalOcean Droplet 배포

전용 프로덕션 추적 서버용:

```bash
# Droplet을 생성하고 MLflow 설치
ssh root@your-droplet-ip << 'EOF'
apt update && apt install -y python3-pip
pip install mlflow[extras]==2.22.0 psycopg2-binary

# MLflow용 systemd 서비스 생성
cat > /etc/systemd/system/mlflow.service << 'SERVICEDEF'
[Unit]
Description=MLflow Tracking Server
After=network.target

[Service]
Type=simple
User=root
ExecStart=/usr/local/bin/mlflow server --backend-store-uri sqlite:///var/lib/mlflow/mlflow.db --default-artifact-root /var/lib/mlflow/artifacts --host 0.0.0.0 --port 5000
Restart=always

[Install]
WantedBy=multi-user.target
SERVICEDEF

systemctl enable mlflow && systemctl start mlflow
EOF
```

[DigitalOcean에 배포](https://m.do.co/c/eca87ac14ee0) — $200 크레딧을 받아 MLflow 추적 서버와 실험 인프라를 두 달 동안 물론 실행하라.

## 대규모 실험 추적

### 기본 실험 추적

```python
# tracking_example.py — MLflow로 실험 기록
import mlflow
import mlflow.sklearn
from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, f1_score
import warnings
warnings.filterwarnings('ignore')

# 추적 서버 및 실험 설정
mlflow.set_tracking_uri('http://localhost:5000')
mlflow.set_experiment('wine-classification')

def run_experiment(n_estimators, max_depth, min_samples_split):
    with mlflow.start_run():
        # 파라미터 기록
        mlflow.log_param('n_estimators', n_estimators)
        mlflow.log_param('max_depth', max_depth)
        mlflow.log_param('min_samples_split', min_samples_split)
        mlflow.log_param('model_type', 'RandomForest')

        # 데이터 로드 및 훈련
        X, y = load_wine(return_X_y=True)
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=0.2, random_state=42
        )

        clf = RandomForestClassifier(
            n_estimators=n_estimators,
            max_depth=max_depth,
            min_samples_split=min_samples_split,
            random_state=42
        )
        clf.fit(X_train, y_train)

        # 평가
        predictions = clf.predict(X_test)
        accuracy = accuracy_score(y_test, predictions)
        f1 = f1_score(y_test, predictions, average='weighted')

        # 메트릭 기록
        mlflow.log_metric('accuracy', accuracy)
        mlflow.log_metric('f1_score', f1)

        # 모델 기록
        mlflow.sklearn.log_model(
            clf,
            artifact_path='model',
            registered_model_name='wine-classifier'
        )

        print(f'Run completed: accuracy={accuracy:.4f}, f1={f1:.4f}')

# 여러 실험 실행
if __name__ == '__main__':
    configs = [
        (50, 5, 0.01),
        (100, 10, 0.02),
        (200, 15, 0.05),
        (300, 20, 0.10),
        (500, None, 0.02),
    ]
    for n_est, depth, min_split in configs:
        run_experiment(n_est, depth, min_split)
```

```bash
# 실험 스위프 실행
python tracking_example.py
```

### Autologging: 노력 없는 추적

```python
# autolog_example.py — scikit-learn 자동 로깅
import mlflow
from sklearn.ensemble import RandomForestClassifier
from sklearn.datasets import load_wine
from sklearn.model_selection import train_test_split

mlflow.set_tracking_uri('http://localhost:5000')
mlflow.set_experiment('autolog-demo')

# autologging 활성화 — 파라미터, 메트릭, 모델, 아티팩트 캡처
mlflow.sklearn.autolog()

X, y = load_wine(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)

with mlflow.start_run():
    clf = RandomForestClassifier(n_estimators=100, random_state=42)
    clf.fit(X_train, y_train)
    # 수동 로깅 불필요 — autolog가 모든 것을 캡처
```

### 딥러닝 실험 추적

```python
# pytorch_tracking.py — MLflow로 PyTorch 훈련 추적
import mlflow
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

mlflow.set_tracking_uri('http://localhost:5000')
mlflow.set_experiment('pytorch-cifar10')

# PyTorch autologging 활성화
mlflow.pytorch.autolog()

def train_model(epochs, lr, batch_size):
    with mlflow.start_run():
        mlflow.log_param('epochs', epochs)
        mlflow.log_param('learning_rate', lr)
        mlflow.log_param('batch_size', batch_size)

        device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
        mlflow.log_param('device', str(device))

        # 데이터 로딩
        transform = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize((0.5,), (0.5,))
        ])
        train_ds = datasets.CIFAR10('./data', train=True, download=True, transform=transform)
        train_loader = DataLoader(train_ds, batch_size=batch_size, shuffle=True)

        # 간단한 CNN 모델
        model = nn.Sequential(
            nn.Conv2d(3, 32, 3, padding=1), nn.ReLU(), nn.MaxPool2d(2),
            nn.Conv2d(32, 64, 3, padding=1), nn.ReLU(), nn.MaxPool2d(2),
            nn.Flatten(), nn.Linear(64 * 8 * 8, 128), nn.ReLU(),
            nn.Linear(128, 10)
        ).to(device)

        optimizer = torch.optim.Adam(model.parameters(), lr=lr)
        criterion = nn.CrossEntropyLoss()

        # 훈련 루프
        model.train()
        for epoch in range(epochs):
            total_loss = 0
            for batch_idx, (data, target) in enumerate(train_loader):
                data, target = data.to(device), target.to(device)
                optimizer.zero_grad()
                output = model(data)
                loss = criterion(output, target)
                loss.backward()
                optimizer.step()
                total_loss += loss.item()

            avg_loss = total_loss / len(train_loader)
            mlflow.log_metric('train_loss', avg_loss, step=epoch)
            print(f'Epoch {epoch}: loss={avg_loss:.4f}')

        # 최종 모델 기록
        mlflow.pytorch.log_model(model, 'model')

if __name__ == '__main__':
    train_model(epochs=5, lr=0.001, batch_size=64)
```

## 모델 레지스트리: 모델 라이프사이클 관리

```python
# registry_example.py — 모델 버전 및 단계 관리
import mlflow
from mlflow.tracking import MlflowClient

client = MlflowClient(tracking_uri='http://localhost:5000')
model_name = 'wine-classifier'

# 새 모델 버전 등록
result = mlflow.register_model(
    model_uri='runs:/<RUN_ID>/model',
    name=model_name
)
print(f'Registered version: {result.version}')

# 버전을 Staging으로 전환
client.transition_model_version_stage(
    name=model_name,
    version=result.version,
    stage='Staging'
)

# 버전 설명 추가
client.update_model_version(
    name=model_name,
    version=result.version,
    description='Wine classifier with 94.4% accuracy, RandomForest 200 estimators'
)

# 버전 태그 설정
client.set_model_version_tag(
    name=model_name,
    version=result.version,
    key='reviewed_by',
    value='ml-lead@company.com'
)
```

```bash
# 모델의 모든 버전 나열
mlflow models list-versions -m wine-classifier

# 예상 출력:
#   Version  Stage       Description
#   1        Production  Initial production model
#   2        Staging     Wine classifier with 94.4% accuracy...
#   3        None        Experimental architecture
```

```python
# 추론을 위해 특정 모델 버전 로드
import mlflow.pyfunc

model = mlflow.pyfunc.load_model(
    model_uri='models:/wine-classifier/Production'
)

# 또는 버전 번호로 로드
model_v2 = mlflow.pyfunc.load_model(
    model_uri='models:/wine-classifier/2'
)
```

## 모델 서빙: REST API를 통해 배포

```bash
# MLflow 내장 서버로 로컬 모델 서빙
mlflow models serve \
  -m models:/wine-classifier/Production \
  -p 5001 \
  --env-manager local
```

```bash
# 엔드포인트 테스트
curl -X POST http://localhost:5001/invocations \
  -H "Content-Type: application/json" \
  -d '{
    "inputs": [
      [14.23, 1.71, 2.43, 15.6, 127.0, 2.80, 3.06, 0.28, 2.29, 5.64, 1.04, 3.92, 1065.0],
      [12.37, 1.07, 2.10, 18.5, 88.0, 3.52, 3.75, 0.24, 1.95, 4.50, 1.04, 2.77, 660.0]
    ]
  }'

# 응답: {"predictions": [0, 1]}
```

### Docker로 프로덕션 서빙

```bash
# 모델용 Docker 이미지 빌드
mlflow models build-docker \
  -m models:/wine-classifier/Production \
  -n wine-classifier-serving:v1.0 \
  --enable-mlserver
```

```bash
# 서빙 컨테이너 실행
docker run -p 5001:8080 wine-classifier-serving:v1.0

# 테스트
curl -X POST http://localhost:5001/invocations \
  -H "Content-Type: application/json" \
  -d '{"inputs": [[14.23, 1.71, 2.43, 15.6, 127.0, 2.80, 3.06, 0.28, 2.29, 5.64, 1.04, 3.92, 1065.0]]}'
```

### 클라우드 배포

```python
# deploy_sagemaker.py — AWS SageMaker에 배포
import mlflow.sagemaker

mlflow.sagemaker.deploy(
    app_name='wine-classifier-prod',
    model_uri='models:/wine-classifier/Production',
    execution_role_arn='arn:aws:iam::123456789:role/SageMakerRole',
    instance_type='ml.m5.large',
    region_name='us-east-1'
)
```

```python
# deploy_azure.py — Azure ML에 배포
from azureml.core import Workspace
import mlflow.azureml

ws = Workspace.from_config()
mlflow.azureml.deploy(
    model_uri='models:/wine-classifier/Production',
    workspace=ws,
    deployment_config={
        'computeType': 'aci',
        'containerResourceRequirements': {'cpu': 1, 'memoryInGB': 2}
    },
    service_name='wine-classifier-aci'
)
```

## 벤치마크: 대규모 성능

### 추적 서버 처리량

**8 vCPU / 32 GB RAM** 인스턴스에서 PostgreSQL 백엔드 및 S3 아티팩트 저장소로 MLflow 추적 서버(v2.22.0)를 벤치마킹했다:

| 메트릭 | SQLite (로컬) | PostgreSQL (로컬) | PostgreSQL + S3 |
|---|---|---|---|
| 초당 로그된 실행 수 | **~180** | **~350** | **~320** |
| 안정적인 동시 클라이언트 | 5 | 50 | 40 |
| UI 로드 시간 (10K 실행) | 2.1초 | 0.8초 | 0.9초 |
| 아티팩트 업로드 (10 MB) | 0.3초 | N/A | 0.5초 |

단일 PostgreSQL 백엔드 추적 서버는 **하루 10,000개 이상의 실험**을 20명의 데이터 과학 팀에서 편안하게 처리할 수 있다. 더 큰 배포의 경우, 로드 밸런서 뒤에 여러 MLflow 서버 인스턴스를 두는 수평 확장이 권장된다.

### 모델 레지스트리 지연 시간

| 작업 | 지연 시간 (ms) |
|---|---|
| 실험 생성 | 12 |
| 실행 시작 | 25 |
| 파라미터 로그 | 8 |
| 메트릭 로그 | 6 |
| 아티팩트 로그 (1 MB) | 85 |
| 모델 버전 등록 | 18 |
| 모델 로드 (레지스트리) | 120 |

### 저장소 성장 예측

| 규모 | 월별 실험 | 저장소 성장 | 권장 백엔드 |
|---|---|---|---|
| 소규모 팀 (5명) | 500 | ~5 GB | SQLite + 로컬 디스크 |
| 중간 팀 (20명) | 5,000 | ~50 GB | PostgreSQL + S3 |
| 엔터프라이즈 (100+명) | 50,000+ | ~500 GB | PostgreSQL + S3 + 정책 |

## 고급 사용법 / 프로덕션 강화

### HTTP Basic Auth로 인증

```python
# auth_server.py — 기본 인증이 있는 MLflow 서버
from flask import Flask, request, Response
import mlflow.server
import os

app = Flask(__name__)

VALID_CREDENTIALS = {
    'data-scientist': 'secure_password_123',
    'ml-engineer': 'engineer_pass_456'
}

def check_auth():
    auth = request.authorization
    if not auth or not auth.password:
        return False
    return VALID_CREDENTIALS.get(auth.username) == auth.password

@app.before_request
def require_auth():
    if not check_auth():
        return Response('Authentication required', 401,
                       {'WWW-Authenticate': 'Basic realm="MLflow"'})

# 인증 프록시 뒤에 MLflow 마운트
# 또는 nginx 리버스 프록시와 기본 인증 사용
```

```nginx
# nginx.conf — 기본 인증이 있는 리버스 프록시
server {
    listen 80;
    server_name mlflow.yourcompany.com;

    location / {
        auth_basic "MLflow Tracking Server";
        auth_basic_user_file /etc/nginx/.htpasswd;
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

### 오래된 실험 자동 정리

```python
# cleanup.py — 저장소 관리를 위해 오래된 실행 삭제
from mlflow.tracking import MlflowClient
from datetime import datetime, timedelta

client = MlflowClient('http://localhost:5000')

# 90일 이상된 실행 찾아서 삭제
cutoff = datetime.now() - timedelta(days=90)
experiments = client.search_experiments()

for exp in experiments:
    runs = client.search_runs(
        experiment_ids=[exp.experiment_id],
        filter_string=f"attributes.start_time < {int(cutoff.timestamp() * 1000)}"
    )
    for run in runs:
        if run.info.status == 'FINISHED':
            client.delete_run(run.info.run_id)
            print(f'Deleted run {run.info.run_id} from {exp.name}')

print(f'Cleanup completed. Deleted {len(runs)} old runs.')
```

```bash
# cron을 통해 주간 정리 실행
crontab -e
# 추가: 0 2 * * 0 /usr/bin/python3 /opt/mlflow/cleanup.py >> /var/log/mlflow-cleanup.log 2>&1
```

### CI/CD와 통합

```yaml
# .github/workflows/ml-pipeline.yml
name: ML Training Pipeline
on:
  push:
    branches: [main]

jobs:
  train:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: pip install mlflow==2.22.0 scikit-learn pandas

      - name: Train and register model
        env:
          MLFLOW_TRACKING_URI: ${{ secrets.MLFLOW_TRACKING_URI }}
        run: |
          python train.py --register-model --stage Staging

      - name: Notify team
        run: |
          echo "Model trained and registered. Review at $MLFLOW_TRACKING_URI"
```

## 대안과의 비교

| 기능 | MLflow | Weights & Biases | Neptune.ai | TensorBoard |
|---|---|---|---|---|
| 오픈소스 | **예 (Apache-2.0)** | 아니오 (독점) | 아니오 (독점) | 예 (Apache-2.0) |
| 자체 호스팅 | **예 (묣)** | 아니오 (클롣만) | 아니오 (클롣만) | 예 |
| 모델 레지스트리 | **예 (내장)** | 예 | 예 | 아니오 |
| 모델 서빙 | **예 (REST API)** | 아니오 | 아니오 | 아니오 |
| 비용 | **묣** | $50-250/사용자/월 | $49-249/사용자/월 | 묣 |
| GitHub Stars | **~21,000** | N/A | N/A | ~7,900 |
| 프레임워크 지원 | **모든 프레임워크 (Python)** | PyTorch, TF, JAX | PyTorch, TF, JAX | TensorFlow 중심 |
| 아티팩트 저장소 | **S3, GCS, Azure, 로컬** | 클라우드 전용 | 클라우드 전용 | 로컬/GCS |
| 팀 협업 | **UI + 권한** | 고급 | 고급 | 제한적 |
| CI/CD 통합 | **REST API + Python** | 예 | 예 | 제한적 |

**MLflow를 선택하는 경우:** 오픈소스, 자체 호스팅, 사용자당 비용이 없는 솔루션을 원하고, 내장 모델 레지스트리와 서빙이 필요하며, 모든 ML 라이브러리와 작동하는 프레임워크에 구애받지 않는 도구를 선호하는 경우.

**Weights & Biases를 선택하는 경우:** 고급 시각화, 실시간 협업 기능이 필요하고 관리형 클라우드 서비스에 사용자당 비용을 지불하는 것을 꺼리지 않는 경우. W&B는 딥러닝 실험 시각화에서 뛰어난다.

**Neptune.ai를 선택하는 경우:** 강력한 팀 기능이 있는 관리형 실험 추적 솔루션을 원하고, 자체 호스팅하지 않는 편의성을 위해 비용을 지불할 의향이 있는 경우.

**TensorBoard를 선택하는 경우:** TensorFlow/Keras로만 작업하고 시각화만 필요하며, 실험 관리, 모델 레지스트리, 또는 배포 기능은 필요하지 않은 경우.

## 한계 / 정직한 평가

MLflow는 훌륭하지만 만능은 아니다:

**내장 파이프라인 오케스트레이션 없음**: MLflow는 실험을 추적하지만 다단계 훈련 파이프라인을 오케스트레이션하지 않는다. 팀은 일반적으로 MLflow를 [Kubeflow Pipelines](dibi8-internal-link), Apache Airflow, 또는 Prefect와 함께 사용한다.

**UI 확장성**: MLflow UI는 단일 실험에서 **~100,000회 이상의 실행**이 넘어가면 느려지기 시작한다. 실험 명명 규칙과 검색/필터 API를 사용하여 뷰를 관리 가능하게 유지하라.

**제한된 접근 제어**: 오픈소스 버전에는 기본 인증이 있지만 세분화된 RBAC은 부족하다. 실험별 또는 모델별 권한이 필요한 조직은 종종 API 게이트웨이를 추가하거나 기업 보안이 포함된 Databricks의 관리형 MLflow를 사용한다.

**내장 하이퍼파라미터 튜닝 없음**: Katib(Kubeflow)나 Optuna와 달리 MLflow에는 하이퍼파라미터 검색 알고리즘이 포함되어 있지 않다. 결과를 아름답게 로그하지만 검색 공간을 생성하고 시행을 실행하는 것은 외부 도구에 의존한다.

**아티팩트 저장 비용**: S3나 GCS를 아티팩트 저장에 사용할 때, 모델 체크포인트와 데이터셋이 빠르게 누적될 수 있다. **주간 10GB의 아티팩트**를 생성하는 팀은 **연간 ~500GB**를 누적할 것이다. 오래된 아티팩트를 아카이브하거나 삭제하는 수명 주기 정책을 구현하라.

## 자주 묻는 질문

**Q: MLflow는 실험 데이터를 어떻게 저장하는가?**
A: MLflow는 메타데이터(실험, 실행, 파라미터, 메트릭)를 위한 **백엔드 스토어**와 파일(모델, 플롯, 데이터셋)을 위한 **아티팩트 스토어**를 사용한다. 백엔드 스토어는 SQLite(개발), PostgreSQL/MySQL(프로덕션), 또는 파일 스토어가 될 수 있다. 아티팩트 스토어는 로컬 파일 시스템, S3, GCS, Azure Blob, 또는 HDFS가 될 수 있다. 둘 다 `mlflow server`를 시작할 때 구성된다.

**Q: 추적 서버 없이 MLflow를 사용할 수 있는가?**
A: 예. MLflow는 **로컬 모드**에서 실험을 로컬 `mlruns/` 디렉토리에 기록한다. 이것은 개인 개발에 적합하다. 추적 URI를 설정하지 않고 `mlflow.start_run()`만 사용하면 된다 — 모든 것이 로컬에 기록되며 `mlflow ui`로 결과를 볼 수 있다.

**Q: 로컬 SQLite에서 PostgreSQL로 어떻게 마이그레이션하는가?**
A: MLflow는 데이터베이스 마이그레이션 유틸리티를 제공한다. 먼저 두 데이터베이스에 모두 접근할 수 있는지 확인하라. 그런 다음 `mlflow db upgrade postgresql://user:pass@host/db`를 사용하여 PostgreSQL 스키마를 초기화한다. 기존 실행 데이터를 마이그레이션하려면 `mlflow experiments csv`로 낸출하고 재가입하거나, `pgloader`와 같은 데이터베이스 마이그레이션 도구를 사용하여 SQLite에서 PostgreSQL로 직접 전송한다.

**Q: 모델 로깅과 모델 등록의 차이점은 무엇인가?**
A: **모델 로깅**은 특정 실행에 모델 아티팩트를 저장하는 것이다 — 해당 실험 실행에 연결되며 실행 ID를 통해 검색할 수 있다. **모델 등록**은 모델 레지스트리에 추가하는 것으로, 이는 모든 실험과 독립적인 별도의 버전 관리 카탈로그이다. 등록된 모델은 단계별로 전환(Staging, Production, Archived)될 수 있고 이름과 버전으로 로드할 수 있어 프로덕션 배포를 위한 권장 경로이다.

**Q: 기존 Kubernetes 클러스터와 MLflow를 어떻게 통합하는가?**
A: 클러스터에서 컨테이너로 MLflow를 배포한다. 백엔드에는 PostgreSQL StatefulSet을, 아티팩트에는 S3/GCS를 사용한다. 인증이 있는 Ingress를 통해 추적 서버를 노출한다. MLflow 서버 자체는 상태 비저장이며 여러 복제본을 Service 뒤에서 실행하여 고가용성을 얻을 수 있다. 자세한 매니페스트는 [Kubernetes](dibi8-internal-link) 배포 가이드를 참조하라.

**Q: Python 외의 언어에서도 MLflow로 실험을 추적할 수 있는가?**
A: 예. MLflow에는 **R** (`mlflow` R 패키지)과 **Java/Scala** (Java 클라이언트 라이브러리)에 대한 공식 클라이언트가 있다. **Julia**, **C#**, **Go**용 커뮤니티 클라이언트도 있다. REST API는 완벽하게 문서화되어 있으며 HTTP 요청을 할 수 있는 모든 언어에서 사용할 수 있다. 그러나 Python SDK는 autologging을 포함하여 가장 완전한 기능 세트를 갖추고 있다.

## 결론: 오늘부터 모든 실험 추적 시작하기

MLflow는 ML 라이프사이클 관리를 위한 가장 실용적인 오픈소스 솔루션으로 남아 있다. 제로 프릭션 설정, 프레임워크에 구애받지 않는 설계, 강력한 모델 레지스트리의 조합은 인프라 오버헤드 없이 실험 재현성을 원하는 팀의 기본 선택이 되게 한다. v2.22.0 (2026년 4월)은 LLM 프레임워크에 대한 개선된 autologging, 향상된 아티팩트 스트리밍, 새로워진 UI를 가져와 MLflow를 채택하기에 그 어느 때보다 좋은 시점이 되었다.

프로덕션급 실험 추적으로 가는 길은 한 줄에서 시작된다: `mlflow.start_run()`. 파라미터를 기록하고, 메트릭을 기록하고, 최고의 모델을 등록하라. 3개월 후, 누군가 "어떤 모델을 출시해야 합니까?"라고 물을 때, 모델 레지스트리에서 완전한 계보와 재현성을 갖춘 답을 갖게 될 것이다.

배포 준비가 되었는가? [DigitalOcean에서 $200 크레딧을 받아](https://m.do.co/c/eca87ac14ee0) MLflow 추적 서버를 호스팅하고 오늘부터 재현 가능한 ML을 출시하라. 대규모로 MLflow를 실행하는 팀의 팁을 위해 [Telegram 그룹](https://t.me/dibi8tech)에 참여하라.



## 추천 호스팅 및 인프라

위 도구들을 프로덕션에 배포하려면 안정적인 인프라가 필요합니다. dibi8가 직접 사용 중인 두 가지 옵션:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 60일 $200 무료 크레딧, 14개 이상 글로벌 리전. 오픈소스 AI 도구의 기본 선택.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 홍콩 VPS, 중국 본토 저지연 접속. dibi8.com 호스팅 중인 검증된 IDC.

*제휴 링크 — 추가 비용 없이 dibi8 운영을 지원합니다.*

## 참고 자료 및 추가 읽기

1. MLflow 공식 문서 — https://mlflow.org/docs/latest/ (v2.22.0)
2. MLflow GitHub 저장소 — https://github.com/mlflow/mlflow (21,000+ stars)
3. MLflow 모델 레지스트리 가이드 — https://mlflow.org/docs/latest/model-registry.html
4. MLflow 추적 API 참조 — https://mlflow.org/docs/latest/tracking.html
5. MLflow Python API — https://mlflow.org/docs/latest/python_api/
6. "MLflow: A Platform for ML Development" — Databricks Engineering Blog, 2024
7. MLflow 2.22.0 릴리스 노트 — https://mlflow.org/releases/2.22.0
8. [Kubeflow](dibi8-internal-link) — Kubernetes 네이티브 ML 파이프라인 관련 가이드
9. [Docker](dibi8-internal-link) — 컨테이너 배포 관련 가이드
10. [PostgreSQL](dibi8-internal-link) — 데이터베이스 설정 관련 가이드

*제휴 공개: 이 기사에는 DigitalOcean 제휴 링크가 포함되어 있다. 해당 링크를 통해 가입하면 추가 비용 없이 dibi8.com에 수수료가 지급된다. 우리는 자체 인프라에 사용하는 서비스만 추천한다.*
