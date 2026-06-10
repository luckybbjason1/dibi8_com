---
title: 'Weights & Biases (W&B)：像专业人士一样跟踪每个实验 — ML 实验平台 2026'
description: 'Weights & Biases (wandb/wandb) 是 AI 开发者平台，用于跟踪、比较和部署 ML 实验。支持 PyTorch、TensorFlow、Hugging Face 和 LLM 微调。涵盖实验跟踪、数据集版本控制、模型注册表和生产监控。'
date: 2026-06-09
slug: 'wandb-ml-experiment-tracking-platform-2026'
category: 'data-science'
tags: ['ml-ops', 'experiment-tracking', 'deep-learning', 'pytorch', 'llm', 'model-registry', 'mlops']
github_repo: 'https://github.com/wandb/wandb'
stars: 11114
maintainer: 'wandb'
license: MIT
featureImage: 'https://raw.githubusercontent.com/wandb/wandb/main/assets/screenshots/launch.png'
lang: zh
---

![Weights & Biases Dashboard](https://opengraph.github.com/github/wandb/wandb)

![W&B Sweeps](https://opengraph.github.com/github/wandb/wandb/tree/main/wandb/sweeps)

![W&B Artifacts](https://opengraph.github.com/github/wandb/wandb/tree/main/wandb/sdk)

## 简介

在没有实验跟踪的情况下训练机器学习模型就像蒙着眼睛开车。你最终可能会到达目的地，但你永远不知道哪个转弯是对的。Weights & Biases (W&B) 通过提供一个统一平台来解决这个问题，该平台记录、可视化和比较每个实验——从超参数扫描到 LLM 微调运行。凭借 11,000+ GitHub stars 和对 PyTorch、TensorFlow、Hugging Face 和 200+ 框架的集成，W&B 已成为认真对待实验的 ML 团队的默认标准。

## 什么是 W&B？

Weights & Biases 是一个端到端的 ML 开发平台，覆盖整个实验生命周期。其核心是 logger——一个你添加到训练脚本中的轻量级库，自动跟踪指标、配置、工件甚至模型检查点。除了记录之外，W&B 还提供用于可视化运行、并排比较实验、与团队共享结果以及从训练到部署管理模型的网络仪表板。

```
┌───────────────────────────────────────────────┐
│           W&B Platform Architecture            │
├───────────────────────────────────────────────┤
│                                               │
│  SDK (pip install wandb)                      │
│    ├─ Logger (metrics, params, tables)        │
│    ├─ Artifact Tracker (datasets, models)     │
│    ├─ Sweeps (hyperparameter tuning)          │
│    ├─ Reports (visual dashboards)             │
│    └─ Model Registry (production models)      │
│                                               │
│  Cloud Dashboard                              │
│    ├─ Run comparison (up to 100 runs)         │
│    ├─ Project-level statistics                │
│    ├─ Artifact lineage graph                  │
│    └─ Team collaboration & sharing            │
│                                               │
│  Integrations                                 │
│    ├─ PyTorch, TensorFlow, JAX                │
│    ├─ Hugging Face Transformers               │
│    ├─ PyTorch Lightning, FastAI               │
│    └─ Ray Tune, Optuna, Ax                    │
└───────────────────────────────────────────────┘
```

## W&B 的工作原理

W&B 通过记录你的训练循环来工作。你初始化一个 run，在每一步记录指标，W&B 将数据实时发送到云端仪表板。SDK 设计为开销极小——记录一个指标大约需要 0.1 毫秒，网络调用被批处理和压缩以减少带宽使用。

```python
import wandb

# Initialize a new run with your configuration
wandb.init(
    project="my-nlp-finetune",
    config={
        "learning_rate": 2e-5,
        "batch_size": 32,
        "epochs": 3,
        "model": "bert-base-uncased",
    }
)

for epoch in range(config.epochs):
    for batch in train_dataloader:
        loss = model.train_step(batch)
        # Log metrics — W&B handles the rest
        wandb.log({"train_loss": loss, "lr": config.learning_rate})
```

平台区分三种类型的跟踪数据：**metrics**（随时间记录的标量值如损失和准确性）、**artifacts**（版本化文件如数据集和模型检查点）和 **media**（直接在仪表板中可视化的图像、音频、文本样本）。

## 安装与设置

**选项 1：pip install（标准）**

```bash
pip install wandb
```

**选项 2：使用 W&B 认证**

```bash
wandb login
# Paste your API key from https://wandb.ai/authorize
```

**选项 3：Docker**

```bash
docker pull wandb/launch
docker run -e WANDB_API_KEY=$WANDB_API_KEY \
  -v /path/to/code:/app wandb/launch python train.py
```

**选项 4：Hugging Face 集成**

```bash
pip install wandb transformers
# W&B is pre-configured for Hugging Face Trainer
```

## 与 PyTorch、Hugging Face 和 Ray Tune 的集成

W&B 与几乎所有流行的 ML 框架集成。以下是最常见的设置。

**PyTorch Lightning**

```python
import pytorch_lightning as pl
from pytorch_lightning.callbacks import WandbCallback

class MyModel(pl.LightningModule):
    def training_step(self, batch, batch_idx):
        loss = self.forward(batch)
        self.log("train_loss", loss)
        return loss

# W&B callback auto-logs everything
trainer = pl.Trainer(callbacks=[WandbCallback()])
trainer.fit(model)
```

**Hugging Face Transformers**

```python
from transformers import Trainer, TrainingArguments
import wandb

training_args = TrainingArguments(
    output_dir="./results",
    report_to="wandb",  # Enable W&B reporting
    num_train_epochs=3,
    per_device_train_batch_size=16,
)

trainer = Trainer(
    model=model,
    args=training_args,
    train_dataset=dataset,
)
trainer.train()
```

**用于超参数扫描的 Ray Tune**

```python
import ray
from ray import tune
import wandb

ray.init()

def train_model(config):
    # W&B automatically captures the sweep config
    wandb.init(config=config)
    score = my_training_function(config)
    wandb.log({"score": score})

sweep = tune.run(
    train_model,
    config={
        "learning_rate": tune.choice([1e-4, 2e-5, 5e-5]),
        "batch_size": tune.choice([16, 32, 64]),
    },
    metric="score",
    mode="max",
)
```

## 基准测试 / 实际应用场景

W&B 的日志性能已在各种训练规模下进行了基准测试。在典型的训练工作负载下，开销可以忽略不计：

|| 场景 | 日志开销 | 网络带宽 | 仪表板加载时间 |
|----------|---------|----------|----------|----------|
| 小模型（1 万参数） | 0.5% | <1 MB/run | <1 秒 |
| 中等模型（1 亿参数） | 1.2% | <5 MB/run | <2 秒 |
| 大模型（10 亿参数） | 2.1% | <20 MB/run | <3 秒 |
| LLM 微调（70 亿参数） | 3.5% | <50 MB/run | <5 秒 |
| 分布式训练（8 GPU） | 4.0% | <100 MB/run | <3 秒 |

实际使用示例：

```python
# Log a confusion matrix as a W&B table
import numpy as np
import wandb

conf_matrix = compute_confusion_matrix(y_true, y_pred)
wandb.log({
    "confusion_matrix": wandb.plot.confusion_matrix(
        probs=None,
        preds=conf_matrix,
        class_names=["Cat", "Dog", "Bird"]
    )
})

# Version a dataset as an artifact
artifact = wandb.Artifact("training_data", type="dataset")
artifact.add_file("dataset.csv")
wandb.log_artifact(artifact)
```

## 高级用法 / 生产环境加固

**工件版本控制和血缘**

```python
# Log a model checkpoint as an artifact
model_artifact = wandb.Artifact("best_model", type="model")
model_artifact.add(model, "model.pt")

# Tag it for easy retrieval
wandb.log_artifact(model_artifact, aliases=["best", "v1.0"])

# Later, retrieve the exact version
run = wandb.init()
art = run.use_artifact("project/model:v1", type="model")
path = art.download()
```

**自定义报告与仪表板**

```python
# Create a report with custom panels
report = wandb.Report(
    title="Experiment Results",
    slides=[
        ("Overview", wandb.plot.line_series(
            xs="step", ys="loss", keys=["train_loss", "val_loss"],
            title="Training Loss Curve"
        )),
        ("Comparison", wandb.plot.bar(
            wandb.Table(columns=["run", "accuracy"],
            data=[["run-a", 0.92], ["run-b", 0.89]])
        )),
    ]
)
report.save("experiment-report")
```

**Sweeps 配置**

```yaml
# sweeps.yaml
name: nlp-sweep
program: train.py
metric:
  name: val_accuracy
  goal: maximize
parameters:
  learning_rate:
    values: [1e-5, 2e-5, 5e-5, 1e-4]
  optimizer:
    values: [adamw, adam]
  warmup_ratio:
    min: 0.0
    max: 0.1
command:
  - python
  - train.py
```

运行 sweep：

```bash
wandb sweep sweeps.yaml
wandb agent $SWEEP_ID
```

**用于部署的模型注册表**

```python
# Log model to the registry
run.log_model(
    path="./fine_tuned_model",
    name="my-nlp-model",
    aliases=["staging", "production"]
)

# Transition model to production
api = wandb.Api()
model = api.model("my-nlp-model:staging")
model.change_alias("production")
```

**W&B SDK 用于自定义训练循环**

```python
import wandb
import torch
from torch.optim import AdamW

wandb.init(project="custom-training")
config = wandb.config
config.learning_rate = 1e-4
config.batch_size = 64

model = MyModel()
optimizer = AdamW(model.parameters(), lr=config.learning_rate)

for epoch in range(config.epochs):
    model.train()
    epoch_loss = 0
    for i, (x, y) in enumerate(train_loader):
        optimizer.zero_grad()
        output = model(x)
        loss = criterion(output, y)
        loss.backward()
        optimizer.step()
        epoch_loss += loss.item()
        
        # Log every 100 steps
        if i % 100 == 0:
            wandb.log({
                "train_loss": loss.item(),
                "learning_rate": config.learning_rate,
                "epoch": epoch
            })
    
    # Log epoch summary
    wandb.log({
        "epoch_loss_avg": epoch_loss / len(train_loader),
        "epoch": epoch,
    })
```

**数据集工作流的工件版本控制**

```python
# Create and log a dataset artifact
dataset_artifact = wandb.Artifact(
    name="cleaned_dataset",
    type="dataset",
    description="Cleaned and tokenized training data",
)

# Add files
dataset_artifact.add_file("data/train.csv")
dataset_artifact.add_file("data/val.csv")
dataset_artifact.add_file("data/test.csv")

# Log with alias for versioning
wandb.log_artifact(dataset_artifact, aliases=["latest", "v1.2"])

# Later, use this exact dataset version
run = wandb.init()
clean_data = run.use_artifact("project/cleaned_dataset:v1.2", type="dataset")
data_path = clean_data.download()
```

## 与替代方案的比较

|| 功能 | W&B | MLflow | Weights & Biases | TensorBoard | Neptune.ai |
|-----|--------|------------------|-------------|------------|
| 实验跟踪 | ✓ | ✓ | ✓ | ✓ | ✓ |
| 超参数扫描 | ✓（原生） | ✓ | ✓ | 否 | ✓ |
| 数据集版本控制 | ✓（Artifacts） | ✓（MLflow） | ✓ | 否 | ✓ |
| 模型注册表 | ✓ | ✓ | ✓ | 否 | ✓ |
| LLM 微调支持 | ✓ | ✓ | ✓ | 有限 | ✓ |
| 分布式训练 | ✓ | ✓ | ✓ | ✓ | ✓ |
| 免费层 | 5 用户 | 无限 | 1 用户 | 无限 | 3 用户 |
| 可自托管 | 否（云端） | ✓（开源） | 否 | ✓（本地） | ✓（开源） |
| 自定义报告 | ✓ | 否 | 否 | 否 | ✓ |
| 团队协作 | ✓ | ✓ | ✓ | 否 | ✓ |
| API 质量 | 优秀 | 良好 | 良好 | 基础 | 良好 |
| 活跃 GitHub stars | 11K+ | 20K+ | 2K+ | 10K+ | 1K+ |

## 局限性 / 客观评估

W&B 是最成熟的 ML 跟踪平台，但存在一些权衡：

1. **云端优先模型**：W&B 的免费层要求使用他们的云平台。虽然他们提供自托管的 W&B Enterprise 供需要本地部署的团队使用，但免费层不支持自托管。如果你的组织要求所有数据保留在你的基础设施内，这可能是一个决定性因素。
2. **免费层限制**：免费层限制为 1 个团队成员。对于较大的研究团队，付费计划的起始成本较高，尤其是当你考虑到大型模型工件所需的额外存储时。
3. **高级功能的学习曲线**：基本记录很简单，但扫描、工件版本控制和自定义报告等功能需要理解 W&B 的数据模型。新用户可能需要 1-2 小时才能熟悉平台的完整功能。
4. **有限的离线功能**：如果你的训练环境间歇性连接互联网，W&B 会在连接恢复时同步数据。但是，SDK 支持 `wandb.init(mode="offline")` 用于完全断开连接的环境，稍后手动同步。
5. **供应商锁定风险**：虽然 W&B 以标准格式（JSON、CSV）导出数据，但在数百个实验后提交到 W&B 后构建到其他平台的迁移可能很耗时。

## 常见问题

**Q：W&B 对学术研究免费吗？**

是的。W&B 为个人研究人员和小团队提供慷慨的免费层。学术机构还可以通过 W&B for Academia 计划申请 W&B Pro 积分，免费获得更多团队成员和存储空间。

**Q：我可以在 Jupyter Notebooks 中使用 W&B 吗？**

当然可以。W&B 在 Jupyter Notebooks 中无缝工作。在笔记本单元顶部初始化你的 run 为 `wandb.init()`，后续所有 `wandb.log()` 调用都会流式传输到仪表板。使用 `wandb.jupyter` 与 Jupyter widgets 自动集成。

**Q：W&B 如何处理大型模型工件？**

W&B 增量上传模型工件——在后续上传中只传输更改的字节。对于非常大的模型（多吉字节检查点），W&B 使用可去重上传和恢复中断传输的内容可寻址存储系统。

**Q：我可以跟踪 LLM 微调实验吗？**

可以。W&B 对 LLM 微调工作流有出色的支持。它与 Hugging Face Transformers、PyTorch Lightning 以及 Axolotl 和 Unsloth 等框架集成。你可以记录每次微调运行的训练损失、评估指标、生成的样本甚至基准分数。

**Q：我如何与团队在实验上进行协作？**

W&B 支持团队工作区，其中所有运行、工件和报告默认共享。团队成员可以对特定的运行进行评论，共享实验比较的直接链接，并使用内置聊天功能在不切换到单独通信平台的情况下讨论结果。

## 结论

Weights & Biases 改变了 ML 团队对待实验跟踪的方式。通过结合实时日志、直观的可视化和强大的协作功能，W&B 将模型训练的混乱转变为结构化、可重现的工作流程。无论你是微调 70 亿参数的 LLM 还是运行小型超参数扫描，W&B 都提供你需要的可见性以更快地做出更好的决策。

该平台与 PyTorch、Hugging Face 和 Ray Tune 的深度集成意味着你可以用一行代码开始跟踪实验（`report_to="wandb"`）。对于大规模构建 ML 应用的团队，[DigitalOcean](https://m.do.co/c/oa14d5f0wx4f) 提供与 W&B 跟踪基础设施配合良好的实惠 GPU 实例。

对于部署 ML 流水线的团队：[WebShare](https://webshare.io/?referral_code=oa14d5f0wx4f) 为分布式训练工作流提供可靠的代理基础设施。

对于探索算法策略的 ML 团队：[Binance](https://bsmkweb.cc) 为量化研究和回测提供高级 API 访问。

对于企业数据管道：[HTStack](https://www.htstack.com/) 提供大规模数据传输所需的网络性能。

对于 AI 金融团队：[OKX](https://promoohubly.com) 提供全面的市场数据和交易工具。

探索更多关于 [MLflow 与 W&B 比较](dibi8-internal-link) 和 [LLM 微调最佳实践](dibi8-internal-link) 的指南以进行全面的技术深入分析。

加入 DIBI8 社区 [Telegram](https://t.me/DIBI8_Group) 群组，参与关于 ML 工具、实验跟踪和 MLOps 实践的持续讨论。

---

**来源与延伸阅读**：
- W&B 文档：https://docs.wandb.ai/
- W&B GitHub 仓库：https://github.com/wandb/wandb
- W&B API 参考：https://docs.wandb.ai/ref/python/
- Sweeps 文档：https://docs.wandb.ai/guides/sweeps
- 模型注册表指南：https://docs.wandb.ai/guides/model-registry
- 社区讨论：https://community.wandb.ai/

**披露**：本文包含附属链接。如果您通过我们的链接注册，我们可能会赚取少量佣金，而您无需支付额外费用。这有助于支持独立技术新闻，并使 dibi8.com 等资源保持免费且无广告。
