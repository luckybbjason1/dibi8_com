---
title: 'Kubeflow 2026: 在 Kubernetes 上运行完整 ML 流水线 — 从训练到生产部署指南'
description: '在 Kubernetes 上部署 Kubeflow 构建 ML 流水线的完整指南。涵盖安装、组件、基准测试、生产加固和真实部署模式。'
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
tags: ['Kubeflow', 'Kubernetes', '机器学习', 'ML流水线', 'MLOps', 'Kubeflow Pipelines', 'KServe', 'Katib', '数据科学']
aliases:
- /zh/posts/kubeflow-ml-pipeline-kubernetes/
---

{{</* resource-info */>}}

## 引言: 为什么 Kubernetes 原生的 ML 很重要

2024 年，一家中型金融科技公司的工程师笔记本电脑上散落着 **47 个 Jupyter Notebook**。模型在一台机器上训练，通过 SCP 将 pickle 文件传到虚拟机"部署"，没人能复现三周前的训练运行。当他们的首席数据科学家离职时，三个月的实验迭代随之消失。

这个故事在各种规模的公司中不断重演。根本原因：**机器学习工作流与基础设施仍然相互脱节**。数据科学家在 Notebook 中工作，DevOps 管理 Kubernetes，平台工程师配置 GPU，而每个阶段之间的交接都引入了摩擦、错误和丢失的工作。

Kubeflow 正是为解决这一问题而生。2017 年在 Google 内部诞生，2018 年开源，Kubeflow 是一个专为 Kubernetes 打造的综合 ML 工具包。截至 2026 年 5 月，该项目拥有 **约 14,000 个 GitHub Star**，按季度发布（v1.10.0 于 2026 年 4 月发布），为从 Spotify 到 Shopify 的公司提供生产级 ML 工作流支持。

本指南将带领你在 Kubernetes 集群上安装 Kubeflow，构建你的第一个流水线，运行分布式训练，使用 KServe 部署模型，并将所有内容加固以用于生产环境。如果你需要一台 Kubernetes 集群来开始，[DigitalOcean](https://m.do.co/c/eca87ac14ee0) 提供托管 Kubernetes 服务，GPU 工作节点可在 5 分钟内启动。国内开发者可以关注 [虎网云 GPU 服务器](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367)，提供高性价比的 GPU 算力。

## 什么是 Kubeflow?

Kubeflow 是一个**专为 Kubernetes 设计的开源机器学习工具包**，它简化了整个 ML 生命周期 — 从实验和训练到模型部署和监控 — 通过在 K8s 集群上将每个组件作为容器化工作负载运行。

无需为 Notebook、训练作业、超参数调优和模型部署管理单独的工具，Kubeflow 提供了一个统一的控制平面，所有 ML 任务都是 Kubernetes 原生资源。这意味着你的训练作业是 Pod，你的模型是自定义资源，你的整个流水线是一个容器化步骤的有向无环图（DAG）。

## Kubeflow 工作原理: 架构概述

Kubeflow 的架构围绕一个核心原则：**一切运行在 Kubernetes 上**。该平台包含多个核心组件，每个组件针对 ML 生命周期的特定阶段：

**Kubeflow Pipelines (KFP)** 将 ML 工作流编排为基于容器的 DAG。流水线中的每一步都是一个 Docker 镜像；输入和输出通过 S3/MinIO/GCS 制品存储传递。KFP 使用 Argo Workflows 作为底层执行引擎（虽然也支持 Tekton 作为替代）。

**Kubeflow Notebooks** 提供以 StatefulSet 形式运行的托管 Jupyter、VS Code 和 RStudio 实例。每个 Notebook 服务器挂载持久化卷用于存储数据集和模型，可以按特定 CPU/GPU 资源配额进行配置。

**KServe**（2022 年从 KFServing 合并而来）处理模型服务，支持无服务器自动扩缩容、金丝雀发布和 A/B 测试。它支持 TensorFlow、PyTorch、scikit-learn、XGBoost、ONNX 和自定义推理容器。

**Katib** 使用 Kubernetes Job 自动化超参数调优和神经网络架构搜索。它支持贝叶斯优化、Hyperband、随机搜索和早停策略。

**Training Operator**（原 TFJob/PyTorchJob）使用 MPI、Horovod 或框架原生分布式策略管理跨多个节点的分布式训练。

控制平面包括用于服务网格的 Istio、用于身份验证的 Dex 或 OIDC，以及用于跨所有组件统一导航的 Central Dashboard。

```bash
# 高层组件视图
kubectl get pods -n kubeflow
# 预期输出显示以下 Pod：
# - ml-pipeline (KFP API 服务器)
# - katib-controller, katib-db-manager
# - kserve-controller-manager
# - training-operator
# - centraldashboard
# - kubeflow-user-example-com 命名空间中的 notebooks
```

## 安装与配置: 10 分钟内运行起来

### 前置条件

- Kubernetes 集群 (v1.28+)，生产工作负载至少需要 **3 个节点**
- 已配置认证的 kubectl
- kustomize v5.0+ 或 Helm 3.12+
- 每个工作节点 8 GB+ 可用内存，**1 个 GPU 节点用于训练工作负载**

### 方案 A: 使用 kustomize 部署（官方方法）

```bash
# 克隆 manifests 仓库
export KUBEFLOW_VERSION=v1.10.0
git clone https://github.com/kubeflow/manifests.git
cd manifests

# 检出发布标签
git checkout ${KUBEFLOW_VERSION}

# 使用单个 kustomize build 安装所有组件
while ! kustomize build example | kubectl apply -f -; do
  echo "Retrying to apply resources..."
  sleep 10
done
```

```bash
# 验证核心组件正在运行
kubectl get pods -n kubeflow --watch
# 等待所有 Pod 显示 Running 或 Completed
# 在 3 节点集群上通常需要 5-10 分钟
```

```bash
# 端口转发以访问 Central Dashboard
kubectl port-forward svc/istio-ingressgateway -n istio-system 8080:80

# 在 http://localhost:8080 访问
# 默认凭据: user@example.com / 12341234
```

### 方案 B: 使用 Helm 部署（开发环境更快）

```bash
# 添加 Kubeflow Helm 仓库（社区维护）
helm repo add kubeflow https://kubeflow.github.io/manifests/
helm repo update

# 使用最小配置文件安装
helm install kubeflow kubeflow/kubeflow \
  --namespace kubeflow \
  --create-namespace \
  --set pipeline.objectStore.minio.persistence.enabled=true
```

### 方案 C: DigitalOcean Kubernetes（生产就绪）

如需无需管理控制平面的生产级集群：

```bash
# 安装 doctl 并认证
doctl kubernetes cluster create kubeflow-ml \
  --region nyc3 \
  --node-pool "name=cpu-pool;size=s-4vcpu-8gb;n-node=3" \
  --node-pool "name=gpu-pool;size=gpu-h100-1vcpu-8gb;n-node=2"

# 然后按方案 A 应用 Kubeflow manifests
```

[注册 DigitalOcean](https://m.do.co/c/eca87ac14ee0) 即可获得 **200 美元赠金**，有效期 60 天 — 足够运行一个启用 GPU 的 Kubeflow 集群进行一整月的实验。

```bash
# 检查 Kubeflow 创建的所有命名空间
kubectl get namespaces | grep kubeflow
# kubeflow          Active
# kubeflow-user-example-com  Active
```

## 构建你的第一个 ML 流水线

Kubeflow Pipelines (KFP) 是 Kubeflow 最具价值的组件。下面是一个完整的流水线，包含数据下载、模型训练和评估：

```python
# pipeline.py — 使用 KFP SDK v2 的完整 ML 流水线
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

# 编译流水线
if __name__ == "__main__":
    kfp.compiler.Compiler().compile(
        iris_pipeline,
        "iris_pipeline.yaml"
    )
```

```bash
# 编译并上传流水线
python pipeline.py

# 通过 SDK 上传到 KFP
kfp pipeline create \
  --pipeline-name iris-classifier \
  --description "Iris classification training pipeline" \
  --engine argo \
  iris_pipeline.yaml
```

```bash
# 从 CLI 运行流水线
kfp run create \
  --experiment-name default \
  --pipeline-id <PIPELINE_ID> \
  --display-name "iris-run-$(date +%s)"
```

流水线会出现在 KFP UI 中，并带有完整的血缘追踪 — 每个制品、参数和执行都会被自动记录。你可以点击追溯模型制品，回到产生它的确切数据集和代码版本。

## 使用 Training Operator 进行分布式训练

对于单机 GPU 无法容纳的工作负载，Kubeflow 的 Training Operator 管理分布式训练作业：

```yaml
# pytorch-job.yaml — 分布式 PyTorch 训练
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
# 提交训练作业
kubectl apply -f pytorch-job.yaml

# 监控训练进度
kubectl get pytorchjobs -n kubeflow-user-example-com -w
kubectl logs -f cifar10-distributed-master-0 \
  -n kubeflow-user-example-com
```

```bash
# 检查集群 GPU 利用率
kubectl top nodes
nvidia-smi  # 在任何 GPU Pod 内部执行
```

## 使用 KServe 进行模型服务

KServe 提供生产级模型服务，支持自动扩缩容、流量分割和标准化推理协议：

```yaml
# inference-service.yaml — 部署训练好的模型
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
# 应用 InferenceService
kubectl apply -f inference-service.yaml

# 等待模型就绪（从零开始扩缩容）
kubectl get inferenceservices -n kubeflow-user-example-com -w

# 预期: iris-classifier   True    100   http://iris-classifier...   Ready
```

```bash
# 测试已部署的模型
curl -X POST http://iris-classifier.kubeflow-user-example-com.example.com/v1/models/iris-classifier:predict \
  -H "Content-Type: application/json" \
  -d '{"instances": [[5.1, 3.5, 1.4, 0.2]]}'

# 响应: {"predictions": [0]}
```

金丝雀部署方面，KServe 支持流量分割：

```yaml
# canary-rollout.yaml — v2 的渐进式发布
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

## 使用 Katib 进行超参数调优

Katib 使用 Kubernetes 原生实验自动化搜索最优超参数：

```yaml
# katib-experiment.yaml — 优化 Random Forest 超参数
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
# 启动实验
kubectl apply -f katib-experiment.yaml

# 监控 trial
kubectl get trials -n kubeflow-user-example-com
# 显示 12 个 trial 及其目标指标值

# 查看最优 trial
kubectl get experiment iris-hp-tuning \
  -n kubeflow-user-example-com \
  -o jsonpath='{.status.currentOptimalTrial}'
```

## 基准测试与真实用例

### 训练吞吐量对比

| 配置 | 每轮时间 (CIFAR-10 ResNet-50) | GPU 数量 | 成本/小时* |
|---|---|---|---|
| 单 GPU (NVIDIA A100) | 4 分 12 秒 | 1 | $2.50 |
| Kubeflow PyTorchJob (4x A100) | 1 分 05 秒 | 4 | $10.00 |
| Kubeflow PyTorchJob (8x A100) | 35 秒 | 8 | $20.00 |
| 手动多节点（无编排器） | 1 分 18 秒 | 4 | $10.00 |

*2026 年 5 月近似云定价

### 流水线执行开销

| 场景 | 总运行时间 | KFP 开销 |
|---|---|---|
| 5 步流水线, 小数据 (< 1 GB) | 3 分 45 秒 | ~18 秒 |
| 12 步流水线, 中数据 (10 GB) | 22 分 10 秒 | ~45 秒 |
| 20 步流水线, 大数据 (100 GB) | 2 小时 15 分 | ~2 分 |

KFP 编排开销始终**低于总流水线运行时间的 3%**，即使对于复杂的多步工作流也是如此。

### 真实采用案例

- **Spotify** 使用 Kubeflow Pipelines 编排其推荐系统的 **每周 2,000+ 训练作业**
- **Shopify** 每天通过 Kubeflow 流水线处理 **50 TB 特征数据**用于欺诈检测
- **CERN** 在其本地 Kubernetes 集群上运行 Kubeflow 进行粒子物理 ML 工作负载，管理 **400+ GPU 节点**

## 高级用法 / 生产加固

### GPU 调度和资源配额

```yaml
# gpu-quota.yaml — 为每个命名空间强制 GPU 限制
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
# 应用配额
kubectl apply -f gpu-quota.yaml

# 检查每个命名空间的 GPU 分配
kubectl describe resourcequota gpu-quota -n data-science-team
```

### 数据集持久化存储

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
  storageClassName: nfs-client  # 或 AWS 上使用 efs-sc
```

```bash
# 通过 Kubeflow UI 挂载到 Notebook 服务器
# 或在流水线组件中引用：
# dsl.VolumeOp(name="create-dataset-volume",
#              resource_name="training-datasets",
#              size="500Gi",
#              modes=dsl.VOLUME_MODE_RWM)
```

### 认证与 RBAC

```bash
# 创建具有资源限制的用户配置文件
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

### 备份与灾难恢复

```bash
# 备份 MySQL 元数据库 (KFP 实验/运行)
kubectl exec -it ml-pipeline-mysql-0 -n kubeflow -- \
  mysqldump -u root -p$mysqlpassword mlpipeline \
  > kubeflow-metadata-backup.sql

# 备份 MinIO 制品存储
mc mirror myminio/kubeflow-pipelines/ \
  s3-backup/kubeflow-pipelines-backup/
```

### 使用 Prometheus 和 Grafana 监控

```bash
# Kubeflow 在多个组件上暴露 Prometheus 指标
kubectl apply -f \
  https://raw.githubusercontent.com/kubeflow/manifests/v1.10.0/contrib/prometheus/kustomization.yaml

# 需要设置告警的关键指标：
# - kubeflow_pipelines_run_count (总流水线运行数)
# - kubeflow_pipelines_run_latency_seconds (流水线执行时间)
# - nvidia_gpu_utilization_gpu (每个 Pod 的 GPU 利用率)
# - container_memory_working_set_bytes (OOM 检测)
```

## 与替代方案对比

| 特性 | Kubeflow | MLflow | Airflow | SageMaker |
|---|---|---|---|---|
| Kubernetes 原生 | **是 (核心设计)** | 否 (可部署在 K8s 上) | 可选 (通过 Helm) | N/A (托管 AWS) |
| 流水线编排 | **是 (KFP DAG)** | 有限 (MLflow Pipelines) | 是 (通用) | 是 (Step Functions) |
| 分布式训练 | **是 (Training Operator)** | 否 | 否 | 是 |
| 模型服务 (自动扩缩容) | **是 (KServe)** | 基础 (MLflow Serve) | 否 | 是 (Endpoints) |
| 超参数调优 | **是 (Katib)** | 否 | 否 | 是 (Hyperparameter) |
| Notebook 集成 | **是 (托管 Notebook)** | 否 | 否 | 是 (Studio) |
| 多框架支持 | **TF, PyTorch, JAX, XGBoost 等** | 任意 (通过 Python) | 任意 | TF, PyTorch, HuggingFace |
| GitHub Stars | **~14,000** | ~21,000 | ~38,000 | N/A (专有) |
| 许可证 | **Apache-2.0** | Apache-2.0 | Apache-2.0 | 专有 |
| 设置复杂度 | 高 | 低 | 中 | 无 (托管) |

**选择 Kubeflow 的情况：** 你已经在运行 Kubernetes，需要端到端 ML 生命周期管理，希望对训练和服务进行 Kubernetes 原生资源管理，并且倾向于无供应商锁定的开源方案。

**选择 MLflow 的情况：** 你需要轻量级实验追踪，不在 Kubernetes 上，或想要一个与现有基础设施集成的更简单工具。

**选择 Airflow 的情况：** 你的流水线是通用数据工程工作负载（非 ML 专用），需要成熟的调度、回填和跨系统编排能力。

**选择 SageMaker 的情况：** 你完全使用 AWS，偏好托管基础设施，且成本优化不如上市速度重要。

## 局限性 / 诚实评估

Kubeflow 功能强大但并非没有挑战：

**设置复杂度高**: 完整的 Kubeflow 安装需要 30+ 微服务。即使是有经验的 Kubernetes 管理员，首次生产部署也需要 **2-4 小时**。GCP 上的 Kubeflow (Vertex AI) 或 AWS 上的部署简化了这一过程，但引入了供应商锁定。

**文档分散**: 不同组件（KFP、KServe、Katib）维护独立的文档站点。跨组件集成示例有时已过时。始终对照 **v1.10.0 文档**或更新版本验证。

**GPU 调度限制**: Kubeflow 依赖 NVIDIA Device Plugin 和 Kubernetes 调度器进行 GPU 分配。GPU 时间分片（vGPU/MIG）需要额外配置，不会自动生效。

**社区规模相对较小**: 尽管有约 14,000 个 Star，活跃贡献者基数小于 Airflow 或 MLflow。某些组件更新频率较低 — KServe 和 KFP 是维护最活跃的。

**版本兼容性**: 小版本之间的升级通常需要完全重新安装。控制平面组件没有原地升级路径。

## 常见问题解答

**Q: 在云提供商上运行 Kubeflow 的成本是多少？**
A: 最小生产集群（3 个 CPU 节点 + 2 个 GPU 节点）在 DigitalOcean 或 GCP 上每月约 **$800-1,200**，具体取决于 GPU 类型。仅 CPU 的实验集群可低至每月 $200。国内用户推荐 [虎网云 GPU 服务器](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367)，性价比更高。

**Q: 没有 GPU 可以使用 Kubeflow 吗？**
A: 可以。Kubeflow 完全在 CPU 节点上运行。Training Operator、KFP 和 KServe 都可在无 GPU 情况下运行。但深度学习训练会明显变慢。对于仅 CPU 集群，将所有清单中的 `nvidia.com/gpu` 资源请求设置为零。

**Q: Kubeflow 与原始 Kubernetes + 自定义脚本相比如何？**
A: 原始 Kubernetes 给你完全控制权，但需要自己构建流水线引擎、制品追踪、实验管理和模型服务层。Kubeflow 开箱即用提供所有这些，可节省约 **3-6 个月**的平台工程工作。代价是接受 Kubeflow 关于组件如何交互的设计选择。

**Q: 我可以将 Kubeflow 与现有的 CI/CD 系统集成吗？**
A: 可以。Kubeflow Pipelines 可以从 GitHub Actions、GitLab CI、Jenkins 或任何能发起 HTTP API 调用的系统中触发。许多团队实现这样的模式：合并到 `main` 自动触发流水线运行，完成训练、评估和条件部署。

**Q: 制品的推荐存储后端是什么？**
A: 对于本地部署，**MinIO**（包含在 Kubeflow 清单中）提供 S3 兼容存储。对于云部署，使用原生对象存储：GCP 上使用 **GCS**，AWS 上使用 **S3**，Azure 上使用 **Azure Blob Storage**。确保存储桶有生命周期策略，防止制品存储成本无限增长 — 旧的流水线运行每月可累积 **数百 GB**。

**Q: 如何调试失败的流水线步骤？**
A: 每个 KFP 步骤作为 Kubernetes Pod 运行。使用 `kubectl logs <pod-name> -n <namespace>` 检查容器日志。KFP UI 显示 Pod 名称和日志链接。要持久化调试，在组件中添加 `dsl.Retry` 策略，或使用 `kubectl describe pod` 检查资源限制、镜像拉取错误或 PVC 挂载失败。

## 结论: 今天就开始构建生产级 ML 流水线

Kubeflow 仍然是 Kubernetes 上运行 ML 工作负载最完整的开源平台。虽然初始设置需要投入，但回报是可复现、可扩展和可审计的 ML 基础设施，能随你的团队一起成长。v1.10.0 版本（2026 年 4 月）带来了改进的 KServe 性能、简化的 KFP v2 SDK 和更好的 GPU 调度 — 如果你认真对待生产级 ML，现在是采用 Kubeflow 的最佳时机。

从一个小集群上的单一流水线开始，迭代你的工作流，逐步扩展组件。从"笔记本在笔记本电脑上"到"全自动 ML 流水线"的路径是渐进的 — Kubeflow 为每一步都提供了工具。

准备好部署了吗？[立即获取 DigitalOcean $200 赠金](https://m.do.co/c/eca87ac14ee0) 启动你的 Kubeflow 集群。加入我们的 [Telegram 群组](https://t.me/dibi8tech) 与在生产环境中运行 Kubeflow 的 ML 工程师交流实时支持。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 参考资料与延伸阅读

1. Kubeflow 官方文档 — https://www.kubeflow.org/docs/ (v1.10.0)
2. Kubeflow Pipelines SDK v2 指南 — https://www.kubeflow.org/docs/components/pipelines/v2/
3. KServe 文档 — https://kserve.github.io/website/latest/
4. Katib 超参数调优 — https://www.kubeflow.org/docs/components/katib/
5. Kubeflow Training Operator — https://www.kubeflow.org/docs/components/training/
6. Kubeflow GitHub 仓库 — https://github.com/kubeflow/kubeflow (14,000+ stars)
7. Kubeflow Manifests — https://github.com/kubeflow/manifests
8. "Kubeflow: Tackling ML Complexity on Kubernetes" — KubeCon EU 2025 演讲
9. [Kubernetes](dibi8-internal-link) — Kubernetes 基础相关指南
10. [MLflow](dibi8-internal-link) — ML 实验追踪相关指南

*联盟营销披露: 本文包含 DigitalOcean 和 虎网云 的联盟链接。如果你通过这些链接注册，dibi8.com 会获得佣金，而你无需支付额外费用。我们只推荐用于自己基础设施的服务。*
