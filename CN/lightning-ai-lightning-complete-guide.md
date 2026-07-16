---
title: Lightning AI — The PyTorch Lightweight Toolkit for Production ML
description: Complete guide to Lightning AI, the PyTorch lightweight toolkit for scaling training, inference, and deployment. Build production-ready ML pipelines with PyTorch Lightning.
category: data-science
tags: ['lightning', 'pytorch-lightning', 'production-ml', 'model-training', 'inference', 'deployment']
slug: lightning-ai-pytorch-lightning-complete-guide
date: 2026-07-17 00:00:00+00:00
featureImage: /images/articles/lightning-ai-pytorch.jpg
---

## TL;DR

Lightning AI is the leading open-source framework for production machine learning in 2026, with 25k+ stars on GitHub. This comprehensive guide covers installation, model training, distributed computing, inference optimization, and production deployment for building scalable ML systems.

## What Is Lightning AI?

Lightning AI (formerly PyTorch Lightning) is a lightweight PyTorch wrapper that structures code into predictable components, making research code production-ready. It handles the engineering overhead of training loops, mixed precision, multi-GPU, and TPU training so you can focus on the model architecture.

### Key Features

- **Structured Code**: Separate training logic from model definition
- **Multi-GPU/TPU**: One-line distributed training support
- **Mixed Precision**: Automatic FP16/BF16 training
- **Callbacks**: Extensive callback system for custom logic
- **Production Ready**: Built-in support for export and deployment
- **Framework Agnostic**: Works with any PyTorch model
- **Community Driven**: 25k+ GitHub stars and active ecosystem

### How Lightning Differs from Raw PyTorch

| Feature | Raw PyTorch | PyTorch Lightning |
|---------|-------------|-------------------|
| Training Loop | Manual | Automated |
| Multi-GPU | Complex setup | One line |
| Mixed Precision | Manual | Automatic |
| Code Organization | Monolithic | Modular |
| Experiment Tracking | External tools | Built-in |
| Deployment | Custom | Export tools |
| Learning Curve | Moderate | Steep initially |

## Installation Guide

### Basic Installation

```bash
pip install pytorch-lightning
# For full features
pip install "pytorch-lightning[extra]"
```

### Verify Installation

```python
import pytorch_lightning as pl
import torch

print(f"PyTorch Lightning version: {pl.__version__}")
print(f"PyTorch version: {torch.__version__}")
print(f"CUDA available: {torch.cuda.is_available()}")
```

### Docker Setup

```dockerfile
FROM nvidia/cuda:12.1-base-ubuntu22.04

RUN pip install pytorch-lightning torch torchvision

WORKDIR /app
COPY . .

CMD ["python", "train.py"]
```

## Building Your First Lightning Module

### Basic Model Structure

```python
import pytorch_lightning as pl
import torch
import torch.nn as nn
import torch.nn.functional as F

class SimpleClassifier(pl.LightningModule):
    def __init__(self, input_dim=784, hidden_dim=128, num_classes=10):
        super().__init__()
        self.layer1 = nn.Linear(input_dim, hidden_dim)
        self.layer2 = nn.Linear(hidden_dim, num_classes)
        self.loss_fn = nn.CrossEntropyLoss()
        
    def forward(self, x):
        x = torch.relu(self.layer1(x))
        return self.layer2(x)
    
    def training_step(self, batch, batch_idx):
        x, y = batch
        logits = self(x)
        loss = self.loss_fn(logits, y)
        self.log('train_loss', loss)
        return loss
    
    def validation_step(self, batch, batch_idx):
        x, y = batch
        logits = self(x)
        loss = self.loss_fn(logits, y)
        accuracy = (logits.argmax(dim=1) == y).float().mean()
        self.log('val_loss', loss)
        self.log('val_accuracy', accuracy)
        return loss
    
    def configure_optimizers(self):
        return torch.optim.Adam(self.parameters(), lr=0.001)
```

### Advanced Training Loop

```python
class AdvancedClassifier(pl.LightningModule):
    def __init__(self, config):
        super().__init__()
        self.save_hyperparameters()
        self.model = self.build_model()
        self.metrics = {
            'accuracy': torchmetrics.Accuracy(task='multiclass', 
                                            num_classes=config['num_classes']),
            'f1': torchmetrics.F1Score(task='multiclass', 
                                      num_classes=config['num_classes'],
                                      average='macro'),
        }
        
    def build_model(self):
        layers = []
        for in_features, out_features in zip(
            self.hp.input_dims, self.hp.hidden_dims
        ):
            layers.append(nn.Linear(in_features, out_features))
            layers.append(nn.ReLU())
            layers.append(nn.Dropout(self.hp.dropout_rate))
        layers.append(nn.Linear(self.hp.hidden_dims[-1], self.hp.num_classes))
        return nn.Sequential(*layers)
    
    def forward(self, x):
        return self.model(x)
    
    def training_step(self, batch, batch_idx):
        x, y = batch
        logits = self(x)
        loss = F.cross_entropy(logits, y)
        
        # Log additional metrics
        probs = F.softmax(logits, dim=1)
        preds = probs.argmax(dim=1)
        acc = (preds == y).float().mean()
        
        self.log('train_loss', loss, prog_bar=True)
        self.log('train_acc', acc, prog_bar=True)
        return loss
    
    def validation_epoch_end(self, outputs):
        avg_loss = torch.stack([x['loss'] for x in outputs]).mean()
        self.log('val_loss_avg', avg_loss, sync_dist=True)
```

## Distributed Training

### Multi-GPU Training

```python
# train_multi_gpu.py
import pytorch_lightning as pl
from pytorch_lightning.strategies import DDPStrategy

trainer = pl.Trainer(
    accelerator='gpu',
    devices=4,
    strategy=DDPStrategy(find_unused_parameters=False),
    max_epochs=50,
    precision='16-mixed'
)

model = AdvancedClassifier(config)
trainer.fit(model, train_dataloader, val_dataloader)
```

### Multi-Node Training

```python
trainer = pl.Trainer(
    accelerator='gpu',
    devices=8,
    num_nodes=4,
    strategy='ddp_find_unused_parameters_true',
    plugins=[
        pl.plugins.environment_variables.EnvironmentVariablesPlugin()
    ]
)
```

### TPU Training

```python
trainer = pl.Trainer(
    accelerator='tpu',
    devices=8,  # 8 cores per TPU pod
    strategy='tpu_spawn'
)
```

## Callbacks and Hooks

### Custom Callbacks

```python
class EarlyStoppingByLoss(pl.callbacks.EarlyStopping):
    def __init__(self, patience=10, min_delta=0.001):
        super().__init__(
            monitor='val_loss',
            patience=patience,
            min_delta=min_delta,
            mode='min'
        )
    
    def on_validation_epoch_end(self, trainer, pl_module):
        current_loss = trainer.callback_metrics['val_loss']
        if current_loss < self.best_score - self.min_delta:
            self.best_score = current_loss
            self.wait_count = 0
        else:
            self.wait_count += 1
            
        if self.wait_count >= self.patience:
            print(f"Early stopping triggered at epoch {trainer.current_epoch}")
            trainer.should_stop = True

# Use the callback
early_stop = EarlyStoppingByLoss(patience=15)
trainer = pl.Trainer(callbacks=[early_stop])
```

### Model Checkpointing

```python
checkpoint_callback = pl.callbacks.ModelCheckpoint(
    dirpath='checkpoints/',
    filename='model-{epoch:02d}-{val_loss:.2f}',
    save_top_k=3,
    monitor='val_loss',
    mode='min',
    save_last=True
)

trainer = pl.Trainer(callbacks=[checkpoint_callback])
```

## Data Pipelines

### LightningDataModule

```python
from pytorch_lightning import LightningDataModule
from torch.utils.data import DataLoader, Dataset

class MNISTDataModule(LightningDataModule):
    def __init__(self, batch_size=64):
        super().__init__()
        self.batch_size = batch_size
        
    def prepare_data(self):
        """Download data once per node"""
        from torchvision import datasets, transforms
        datasets.MNIST('./data', train=True, download=True)
        datasets.MNIST('./data', train=False, download=True)
    
    def setup(self, stage=None):
        """Load data for each rank"""
        transform = transforms.Compose([
            transforms.ToTensor(),
            transforms.Normalize((0.1307,), (0.3081,))
        ])
        
        self.train_dataset = datasets.MNIST(
            './data', train=True, transform=transform, download=False
        )
        self.val_dataset = datasets.MNIST(
            './data', train=False, transform=transform, download=False
        )
    
    def train_dataloader(self):
        return DataLoader(
            self.train_dataset,
            batch_size=self.batch_size,
            shuffle=True,
            num_workers=4
        )
    
    def val_dataloader(self):
        return DataLoader(
            self.val_dataset,
            batch_size=self.batch_size,
            shuffle=False,
            num_workers=4
        )
```

## Inference and Deployment

### Exporting Models

```python
# Export to TorchScript
model = AdvancedClassifier.load_from_checkpoint('best_model.ckpt')
model.eval()

example_input = torch.randn(1, 784)
traced_script_module = torch.jit.trace(model, example_input)
traced_script_module.save('model.pt')

# Export to ONNX
torch.onnx.export(
    model,
    example_input,
    'model.onnx',
    input_names=['input'],
    output_names=['output'],
    dynamic_axes={
        'input': {0: 'batch_size'},
        'output': {0: 'batch_size'}
    }
)
```

### Serving with FastAPI

```python
from fastapi import FastAPI
import torch
import torch.nn.functional as F

app = FastAPI()

# Load model
model = AdvancedClassifier.load_from_checkpoint('best_model.ckpt')
model.eval()

@app.post("/predict")
async def predict(data: dict):
    input_tensor = torch.tensor(data['features'])
    with torch.no_grad():
        output = model(input_tensor)
        probabilities = F.softmax(output, dim=1)
    
    return {
        'predictions': probabilities.tolist(),
        'confidence': float(probabilities.max())
    }
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: inference-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: inference
  template:
    spec:
      containers:
      - name: inference
        image: inference-model:v1
        resources:
          limits:
            nvidia.com/gpu: 1
        ports:
        - containerPort: 8000
```

## Comparison with Alternatives

| Feature | Lightning | Hugging Face | Weights & Biases | ClearML |
|---------|-----------|--------------|------------------|---------|
| Training Automation | ✅ | ✅ | ❌ | ❌ |
| Experiment Tracking | ✅ | ❌ | ✅ | ✅ |
| Multi-GPU | ✅ | ✅ | ❌ | ❌ |
| Model Export | ✅ | ✅ | ❌ | ✅ |
| Cost | Free | Free | Freemium | Freemium |
| Community Size | Large | Very Large | Medium | Small |

### Advanced Lightning Patterns

#### Gradient Clipping and Norms

```python
def training_step(self, batch, batch_idx):
    x, y = batch
    logits = self(x)
    loss = F.cross_entropy(logits, y)
    
    # Manual gradient clipping
    self.manual_backward(loss)
    self.clip_gradients(
        self.optimizers(),
        gradient_clip_val=1.0,
        gradient_clip_algorithm='norm'
    )
    self.optimizers().step()
    self.optimizers().zero_grad()
    
    self.log('train_loss', loss)
    return loss
```

#### Learning Rate Schedulers

```python
def configure_optimizers(self):
    optimizer = torch.optim.AdamW(
        self.parameters(),
        lr=1e-3,
        weight_decay=0.01
    )
    
    scheduler = {
        'scheduler': torch.optim.lr_scheduler.CosineAnnealingWarmRestarts(
            optimizer, T_0=10, T_mult=2
        ),
        'interval': 'epoch',
        'frequency': 1
    }
    
    return [optimizer], [scheduler]
```

#### Mixed Precision Training

```python
trainer = pl.Trainer(
    accelerator='gpu',
    devices=1,
    precision='bf16-mixed',  # Use BF16 for better stability
    strategy='auto'
)

# Or manually in training step
def training_step(self, batch, batch_idx):
    with torch.autocast(device_type='cuda', dtype=torch.float16):
        outputs = self(batch['inputs'])
        loss = self.loss_fn(outputs, batch['targets'])
    
    self.log('loss', loss)
    return loss
```

### Experiment Tracking Integration

#### Weights & Biases

```python
import pytorch_lightning as pl
from pytorch_lightning.callbacks import RichProgressBar

trainer = pl.Trainer(
    callbacks=[
        RichProgressBar(),
        pl.callbacks.LearningRateMonitor(logging_interval='step')
    ],
    logger=[
        pl.loggers.WandbLogger(
            project='my-experiment',
            config={'learning_rate': 0.001, 'batch_size': 64}
        )
    ]
)
```

#### MLflow

```python
from pytorch_lightning.loggers import MLFlowLogger

logger = MLFlowLogger(
    experiment_name='production-training',
    tracking_uri='http://mlflow-server:5000'
)

trainer = pl.Trainer(logger=logger)
```

### Data Augmentation Strategies

```python
import albumentations as A

class AugmentedDataModule(LightningDataModule):
    def __init__(self, img_size=224):
        super().__init__()
        self.train_transform = A.Compose([
            A.RandomResizedCrop(img_size, img_size),
            A.HorizontalFlip(p=0.5),
            A.ColorJitter(brightness=0.2, contrast=0.2),
            A.Normalize(mean=[0.485, 0.456, 0.406], 
                       std=[0.229, 0.224, 0.225])
        ])
    
    def train_dataloader(self):
        dataset = AugmentedDataset(
            transform=self.train_transform,
            data_path='data/train/'
        )
        return DataLoader(dataset, batch_size=64, shuffle=True)
```

### Model Export Formats

| Format | Best For | Tools |
|--------|----------|-------|
| TorchScript | Python services | torch.jit.script |
| ONNX | Cross-framework | onnxruntime |
| TensorRT | NVIDIA GPUs | tensorrt |
| OpenVINO | Intel CPUs | openvino |
| CoreML | iOS devices | coremltools |
| TFLite | Mobile | tflite_converter |

### Hyperparameter Optimization with Optuna

Automate hyperparameter tuning for optimal model performance:

```python
import optuna
from pytorch_lightning import Trainer, LightningModule

def objective(trial):
    # Define search space
    lr = trial.suggest_float('lr', 1e-5, 1e-2, log=True)
    batch_size = trial.suggest_categorical('batch_size', [16, 32, 64, 128])
    hidden_dim = trial.suggest_int('hidden_dim', 64, 512, step=64)
    weight_decay = trial.suggest_float('weight_decay', 1e-6, 1e-2, log=True)
    
    # Create model with trial parameters
    model = AdvancedClassifier(
        input_dim=784,
        hidden_dim=hidden_dim,
        num_classes=10
    )
    
    # Configure trainer
    trainer = Trainer(
        max_epochs=10,
        accelerator='gpu',
        devices=1,
        callbacks=[
            pl.callbacks.EarlyStopping(monitor='val_loss', patience=3),
            pl.callbacks.ModelCheckpoint(monitor='val_loss')
        ]
    )
    
    # Train and evaluate
    trainer.fit(model, train_dataloader, val_dataloader)
    
    return trainer.callback_metrics['val_loss'].item()

# Run optimization study
study = optuna.create_study(direction='minimize')
study.optimize(objective, n_trials=50)

print(f"Best params: {study.best_params}")
print(f"Best validation loss: {study.best_value}")
```

### Production Model Serving Patterns

#### TorchServe Deployment

Deploy models with TorchServe for production inference:

```python
# handler.py
import torch
import json
from ts.torch_handler.base_handler import BaseHandler

class ClassifierHandler(BaseHandler):
    def initialize(self, context):
        self.manifest = context.manifest
        properties = context.system_properties
        model_dir = properties.get('model_dir')
        
        # Load model
        self.model = torch.load(f'{model_dir}/model.pt')
        self.model.eval()
        
        # Set device
        self.device = torch.device('cpu')
        if properties.get('gpu_id') is not None:
            self.device = torch.device(f'cuda:{properties["gpu_id"]}')
            self.model.to(self.device)
    
    def preprocess(self, data):
        inputs = []
        for row in data:
            features = row.get('features', row.get('data'))
            inputs.append(torch.tensor(features, dtype=torch.float32))
        return torch.stack(inputs)
    
    def inference(self, inputs):
        with torch.no_grad():
            outputs = self.model(inputs.to(self.device))
            probabilities = torch.softmax(outputs, dim=1)
        return probabilities.cpu().numpy()
    
    def postprocess(self, data):
        results = []
        for probs in data:
            results.append({
                'predictions': probs.tolist(),
                'confidence': float(max(probs)),
                'class_id': int(probs.argmax())
            })
        return results

handler = ClassifierHandler()
```

#### Docker Compose for Full Stack

```yaml
version: '3.8'
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - MODEL_PATH=/models/classifier.pt
      - DEVICE=cuda
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
  
  monitoring:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
  
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

volumes:
  grafana-data:
```

### Monitoring and Observability

Track model performance in production:

```python
import prometheus_client
from prometheus_client import Counter, Histogram, Gauge

# Define metrics
REQUEST_COUNT = Counter('model_requests_total', 'Total requests')
REQUEST_LATENCY = Histogram('model_request_latency_seconds', 'Request latency')
PREDICTION_CONFIDENCE = Gauge('prediction_confidence', 'Average confidence')

class MonitoringCallback(pl.Callback):
    def on_validation_epoch_end(self, trainer, pl_module):
        REQUEST_COUNT.inc()
        PREDICTION_CONFIDENCE.set(pl_module.callback_metrics['val_accuracy'].item())
```

### A/B Testing Framework

Compare model versions in production:

```python
class ABTestRouter:
    def __init__(self):
        self.models = {
            'A': load_model('baseline_v1'),
            'B': load_model('improved_v2')
        }
        self.traffic_split = {'A': 0.8, 'B': 0.2}
    
    def predict(self, input_data):
        import random
        variant = random.choices(
            list(self.traffic_split.keys()),
            weights=list(self.traffic_split.values())
        )[0]
        
        result = self.models[variant].predict(input_data)
        log_variant(variant, input_data, result)
        return result
```

## FAQ

### Q1: How does Lightning differ from raw PyTorch?

Lightning adds structure to your PyTorch code without changing the underlying framework. You write standard PyTorch models but get automatic training loops, distributed training, and experiment tracking.

### Q2: Can I use Lightning with pre-trained models?

Yes, Lightning works with any PyTorch model including Hugging Face transformers, torchvision models, and custom architectures. Simply wrap your model in a LightningModule.

### Q3: How do I handle large datasets that don't fit in memory?

Use Lightning's built-in support for streaming datasets with IterableDataset. You can also use distributed data loading with num_workers and memory mapping.

### Q4: What's the best way to tune hyperparameters?

Use Lightning's integration with Optuna or Ray Tune for automated hyperparameter search. Define your search space in the LightningModule and let the tuner optimize.

### Q5: Can I deploy Lightning models to edge devices?

Yes, export to ONNX or TorchScript for deployment. Lightning models are compatible with TensorRT, OpenVINO, and other edge inference engines.

### Q6: How do I monitor training in real-time?

Integrate with Weights & Biases, MLflow, or Comet.ml for real-time monitoring. Lightning has built-in callbacks for these services.

### Q7: What about model interpretability?

Use Integrated Gradients, SHAP, or LIME with Lightning models. The modular structure makes it easy to hook into gradients and activations.

### Q8: How do I handle class imbalance?

Use weighted loss functions, oversampling techniques, or focal loss. Lightning makes it easy to implement custom loss functions and sampling strategies.

### Q9: What is the difference between Lightning and Keras?

Keras is higher-level and simpler but less flexible. Lightning provides more control while still abstracting away boilerplate. For research and complex architectures, Lightning is preferred.

### Q10: How do I resume training from a checkpoint?

Lightning automatically saves checkpoints during training. Use `trainer.fit(model, ckpt_path='path/to/checkpoint.ckpt')` to resume from any saved checkpoint.

## Sources

- [PyTorch Lightning Documentation](https://lightning.ai/docs/pytorch/stable/)
- [PyTorch Lightning GitHub](https://github.com/Lightning-AI/lightning)
- [Lightning AI Platform](https://lightning.ai/)
- [PyTorch Documentation](https://pytorch.org/docs/)

## Call to Action

Build production-ready ML systems with Lightning AI. [Get started](https://dibi8.com/auth/) with our tutorials and deployment guides.


## FAQ

### Q1: How does Lightning differ from raw PyTorch?

Lightning adds structure to your PyTorch code without changing the underlying framework. You write standard PyTorch models but get automatic training loops, distributed training, and experiment tracking.

### Q2: Can I use Lightning with pre-trained models?

Yes, Lightning works with any PyTorch model including Hugging Face transformers, torchvision models, and custom architectures. Simply wrap your model in a LightningModule.

### Q3: How do I handle large datasets that don't fit in memory?

Use Lightning's built-in support for streaming datasets with IterableDataset. You can also use distributed data loading with num_workers and memory mapping.

### Q4: What's the best way to tune hyperparameters?

Use Lightning's integration with Optuna or Ray Tune for automated hyperparameter search. Define your search space in the LightningModule and let the tuner optimize.

### Q5: Can I deploy Lightning models to edge devices?

Yes, export to ONNX or TorchScript for deployment. Lightning models are compatible with TensorRT, OpenVINO, and other edge inference engines.

### Q6: How do I monitor training in real-time?

Integrate with Weights & Biases, MLflow, or Comet.ml for real-time monitoring. Lightning has built-in callbacks for these services.

### Q7: What about model interpretability?

Use Integrated Gradients, SHAP, or LIME with Lightning models. The modular structure makes it easy to hook into gradients and activations.

### Q8: How do I handle class imbalance?

Use weighted loss functions, oversampling techniques, or focal loss. Lightning makes it easy to implement custom loss functions and sampling strategies.

## Sources

- [PyTorch Lightning Documentation](https://lightning.ai/docs/pytorch/stable/)
- [PyTorch Lightning GitHub](https://github.com/Lightning-AI/lightning)
- [Lightning AI Platform](https://lightning.ai/)
- [PyTorch Documentation](https://pytorch.org/docs/)

## Call to Action

Build production-ready ML systems with Lightning AI. [Get started](https://dibi8.com/auth/) with our tutorials and deployment guides.


### Hyperparameter Optimization with Optuna

Automate hyperparameter tuning for optimal model performance:

```python
import optuna
from pytorch_lightning import Trainer, LightningModule

def objective(trial):
    # Define search space
    lr = trial.suggest_float('lr', 1e-5, 1e-2, log=True)
    batch_size = trial.suggest_categorical('batch_size', [16, 32, 64, 128])
    hidden_dim = trial.suggest_int('hidden_dim', 64, 512, step=64)
    weight_decay = trial.suggest_float('weight_decay', 1e-6, 1e-2, log=True)
    
    # Create model with trial parameters
    model = AdvancedClassifier(
        input_dim=784,
        hidden_dim=hidden_dim,
        num_classes=10
    )
    
    # Configure trainer
    trainer = Trainer(
        max_epochs=10,
        accelerator='gpu',
        devices=1,
        callbacks=[
            pl.callbacks.EarlyStopping(monitor='val_loss', patience=3),
            pl.callbacks.ModelCheckpoint(monitor='val_loss')
        ]
    )
    
    # Train and evaluate
    trainer.fit(model, train_dataloader, val_dataloader)
    
    return trainer.callback_metrics['val_loss'].item()

# Run optimization study
study = optuna.create_study(direction='minimize')
study.optimize(objective, n_trials=50)

print(f"Best params: {study.best_params}")
print(f"Best validation loss: {study.best_value}")
```

### Production Model Serving Patterns

#### TorchServe Deployment

Deploy models with TorchServe for production inference:

```python
# handler.py
import torch
import json
from ts.torch_handler.base_handler import BaseHandler

class ClassifierHandler(BaseHandler):
    def initialize(self, context):
        self.manifest = context.manifest
        properties = context.system_properties
        model_dir = properties.get('model_dir')
        
        # Load model
        self.model = torch.load(f'{model_dir}/model.pt')
        self.model.eval()
        
        # Set device
        self.device = torch.device('cpu')
        if properties.get('gpu_id') is not None:
            self.device = torch.device(f'cuda:{properties["gpu_id"]}')
            self.model.to(self.device)
    
    def preprocess(self, data):
        inputs = []
        for row in data:
            features = row.get('features', row.get('data'))
            inputs.append(torch.tensor(features, dtype=torch.float32))
        return torch.stack(inputs)
    
    def inference(self, inputs):
        with torch.no_grad():
            outputs = self.model(inputs.to(self.device))
            probabilities = torch.softmax(outputs, dim=1)
        return probabilities.cpu().numpy()
    
    def postprocess(self, data):
        results = []
        for probs in data:
            results.append({
                'predictions': probs.tolist(),
                'confidence': float(max(probs)),
                'class_id': int(probs.argmax())
            })
        return results

handler = ClassifierHandler()
```

#### Docker Compose for Full Stack

```yaml
version: '3.8'
services:
  api:
    build: .
    ports:
      - "8000:8000"
    environment:
      - MODEL_PATH=/models/classifier.pt
      - DEVICE=cuda
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
  
  monitoring:
    image: grafana/grafana:latest
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
  
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml

volumes:
  grafana-data:
```

### Monitoring and Observability

Track model performance in production:

```python
import prometheus_client
from prometheus_client import Counter, Histogram, Gauge

# Define metrics
REQUEST_COUNT = Counter('model_requests_total', 'Total requests')
REQUEST_LATENCY = Histogram('model_request_latency_seconds', 'Request latency')
PREDICTION_CONFIDENCE = Gauge('prediction_confidence', 'Average confidence')

class MonitoringCallback(pl.Callback):
    def on_validation_epoch_end(self, trainer, pl_module):
        REQUEST_COUNT.inc()
        PREDICTION_CONFIDENCE.set(pl_module.callback_metrics['val_accuracy'].item())
```

### A/B Testing Framework

Compare model versions in production:

```python
class ABTestRouter:
    def __init__(self):
        self.models = {
            'A': load_model('baseline_v1'),
            'B': load_model('improved_v2')
        }
        self.traffic_split = {'A': 0.8, 'B': 0.2}
    
    def predict(self, input_data):
        import random
        variant = random.choices(
            list(self.traffic_split.keys()),
            weights=list(self.traffic_split.values())
        )[0]
        
        result = self.models[variant].predict(input_data)
        log_variant(variant, input_data, result)
        return result
```

## FAQ

### Q1: How does Lightning differ from raw PyTorch?

Lightning adds structure to your PyTorch code without changing the underlying framework. You write standard PyTorch models but get automatic training loops, distributed training, and experiment tracking.

### Q2: Can I use Lightning with pre-trained models?

Yes, Lightning works with any PyTorch model including Hugging Face transformers, torchvision models, and custom architectures. Simply wrap your model in a LightningModule.

### Q3: How do I handle large datasets that don't fit in memory?

Use Lightning's built-in support for streaming datasets with IterableDataset. You can also use distributed data loading with num_workers and memory mapping.

### Q4: What's the best way to tune hyperparameters?

Use Lightning's integration with Optuna or Ray Tune for automated hyperparameter search. Define your search space in the LightningModule and let the tuner optimize.

### Q5: Can I deploy Lightning models to edge devices?

Yes, export to ONNX or TorchScript for deployment. Lightning models are compatible with TensorRT, OpenVINO, and other edge inference engines.

### Q6: How do I monitor training in real-time?

Integrate with Weights & Biases, MLflow, or Comet.ml for real-time monitoring. Lightning has built-in callbacks for these services.

### Q7: What about model interpretability?

Use Integrated Gradients, SHAP, or LIME with Lightning models. The modular structure makes it easy to hook into gradients and activations.

### Q8: How do I handle class imbalance?

Use weighted loss functions, oversampling techniques, or focal loss. Lightning makes it easy to implement custom loss functions and sampling strategies.

### Q9: What is the difference between Lightning and Keras?

Keras is higher-level and simpler but less flexible. Lightning provides more control while still abstracting away boilerplate. For research and complex architectures, Lightning is preferred.

### Q10: How do I resume training from a checkpoint?

Lightning automatically saves checkpoints during training. Use `trainer.fit(model, ckpt_path='path/to/checkpoint.ckpt')` to resume from any saved checkpoint.

## Sources

- [PyTorch Lightning Documentation](https://lightning.ai/docs/pytorch/stable/)
- [PyTorch Lightning GitHub](https://github.com/Lightning-AI/lightning)
- [Lightning AI Platform](https://lightning.ai/)
- [PyTorch Documentation](https://pytorch.org/docs/)

## Call to Action

Build production-ready ML systems with Lightning AI. [Get started](https://dibi8.com/auth/) with our tutorials and deployment guides.


## FAQ

### Q1: How does Lightning differ from raw PyTorch?

Lightning adds structure to your PyTorch code without changing the underlying framework. You write standard PyTorch models but get automatic training loops, distributed training, and experiment tracking.

### Q2: Can I use Lightning with pre-trained models?

Yes, Lightning works with any PyTorch model including Hugging Face transformers, torchvision models, and custom architectures. Simply wrap your model in a LightningModule.

### Q3: How do I handle large datasets that don't fit in memory?

Use Lightning's built-in support for streaming datasets with `IterableDataset`. You can also use distributed data loading with `num_workers` and memory mapping.

### Q4: What's the best way to tune hyperparameters?

Use Lightning's integration with Optuna or Ray Tune for automated hyperparameter search. Define your search space in the LightningModule and let the tuner optimize.

### Q5: Can I deploy Lightning models to edge devices?

Yes, export to ONNX or TorchScript for deployment. Lightning models are compatible with TensorRT, OpenVINO, and other edge inference engines.

### Q6: How do I monitor training in real-time?

Integrate with Weights & Biases, MLflow, or Comet.ml for real-time monitoring. Lightning has built-in callbacks for these services.

### Q7: What about model interpretability?

Use Integrated Gradients, SHAP, or LIME with Lightning models. The modular structure makes it easy to hook into gradients and activations.

## Sources

- [PyTorch Lightning Documentation](https://lightning.ai/docs/pytorch/stable/)
- [PyTorch Lightning GitHub](https://github.com/Lightning-AI/lightning)
- [Lightning AI Platform](https://lightning.ai/)
- [PyTorch Documentation](https://pytorch.org/docs/)

## Call to Action

Build production-ready ML systems with Lightning AI. [Get started](https://dibi8.com/auth/) with our tutorials and deployment guides.
