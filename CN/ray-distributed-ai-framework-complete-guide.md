---
title: Ray — The Unified Framework for Scaling AI and Python Applications
description: Complete guide to Ray, the open-source framework for scaling Python and AI workloads. Build distributed ML training, large-scale inference, and parallel computing pipelines.
category: llm-frameworks
tags: ['ray', 'distributed-computing', 'ai-scaling', 'machine-learning', 'python', 'parallel-processing']
slug: ray-distributed-ai-framework-complete-guide
date: 2026-07-17 00:00:00+00:00
featureImage: /images/articles/ray-distributed-computing-ai.jpg
---

## TL;DR

Ray is the industry-standard framework for scaling Python and AI workloads across single machines to thousands of nodes. This comprehensive guide covers Ray Core, Ray Serve, Ray Train, and Ray Data for building production-grade distributed applications from startup to enterprise scale.

## What Is Ray?

Ray is a unified framework that provides a simple, universal API for building and running distributed applications. Originally developed at UC Berkeley's RISELab, Ray has become the backbone of many leading AI companies, powering everything from LLM fine-tuning to real-time recommendation systems.

### Why Choose Ray Over Alternatives?

| Feature | Ray | Apache Spark | Dask | Celery |
|---------|-----|-------------|------|--------|
| Python Native | ✅ | Partial | ✅ | ✅ |
| ML Training | ✅ (Ray Train) | ❌ | Basic | ❌ |
| Model Serving | ✅ (Ray Serve) | ❌ | ❌ | ❌ |
| Hyperparameter Tuning | ✅ (Ray Tune) | ❌ | ❌ | ❌ |
| Real-Time Inference | ✅ | ❌ | Limited | ✅ |
| Fault Tolerance | ✅ | ✅ | ✅ | Basic |
| Cloud Deployment | ✅ (Ray Cloud) | ✅ | ✅ | ✅ |

#### Ray Core: The Foundation

Ray Core provides two fundamental abstractions:

1. **Remote Functions**: Regular Python functions that execute on remote workers
2. **Actors**: Stateful worker processes that maintain internal state across calls

```python
import ray
import time

# Initialize Ray cluster
ray.init(
    num_cpus=8,
    num_gpus=2,
    object_store_memory=5 * 1024 * 1024 * 1024  # 5 GB
)

@ray.remote
def compute_heavy_task(x):
    time.sleep(1)
    return x ** 2

# Execute tasks in parallel across available CPUs
futures = [compute_heavy_task.remote(i) for i in range(10)]
results = ray.get(futures)

print(results)  # [0, 1, 4, 9, 16, 25, 36, 49, 64, 81]
```

#### Ray Serve: Model Serving Infrastructure

Ray Serve provides production-grade model serving with features like:

- Automatic batching for improved throughput
- Multi-model deployment with shared resources
- A/B testing and canary deployments
- HTTP/gRPC endpoints with OpenAPI specification
- Autoscaling based on request queue depth

```python
from ray import serve
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification

@serve.deployment(num_replicas=3, ray_actor_options={"num_cpus": 2})
class SentimentClassifier:
    def __init__(self):
        self.tokenizer = AutoTokenizer.from_pretrained(
            "distilbert-base-uncased-finetuned-sst-2-english"
        )
        self.model = AutoModelForSequenceClassification.from_pretrained(
            "distilbert-base-uncased-finetuned-sst-2-english"
        )
    
    async def __call__(self, request):
        data = await request.json()
        text = data["text"]
        
        inputs = self.tokenizer(text, return_tensors="pt")
        outputs = self.model(**inputs)
        prediction = torch.argmax(outputs.logits).item()
        
        return {"label": "positive" if prediction == 1 else "negative"}

# Deploy with configuration
SentimentClassifier.deploy()
```

#### Ray Train: Distributed Training

Ray Train provides a scalable interface for distributed deep learning:

```python
from ray.train import scaling_config, RunConfig
from ray.train.torch import TorchTrainer

def training_func(config):
    import torch
    from torch.utils.data import DataLoader
    
    backend = "gloo"
    torch.distributed.init_process_group(backend=backend)
    
    model = torch.nn.Linear(10, 1)
    model = torch.nn.parallel.DistributedDataParallel(model)
    
    optimizer = torch.optim.Adam(model.parameters(), lr=config["lr"])
    for epoch in range(config["epochs"]):
        for batch_x, batch_y in dataloader:
            optimizer.zero_grad()
            output = model(batch_x)
            loss = torch.nn.functional.mse_loss(output, batch_y)
            loss.backward()
            optimizer.step()

trainer = TorchTrainer(
    training_func,
    scaling_config=scaling_config(num_workers=4, use_gpu=True),
    run_config=RunConfig(name="my_training_run")
)

result = trainer.fit()
print(result.metrics)
```

#### Ray Data: Scalable Data Loading

Ray Data handles petabyte-scale data processing:

```python
import ray.data

# Load from cloud storage
dataset = ray.data.read_csv("s3://my-bucket/data/*.csv")
dataset = ray.data.read_parquet("gs://my-bucket/data/*.parquet")

# Apply transformations
processed = dataset.map_batches(
    lambda batch: preprocess_batch(batch),
    batch_size=10000
)

# Write results
processed.write_parquet("output/")
```

## Installation Guide

### Basic Installation

```bash
pip install ray[default]
```

For GPU support:

```bash
pip install ray[default] pytorch
```

Verify installation:

```python
import ray

# Initialize Ray
ray.init()

@ray.remote
def hello():
    return "Hello from Ray!"

result = ray.get(hello.remote())
print(result)  # Hello from Ray!
```

### Docker Deployment

```dockerfile
FROM python:3.11-slim

RUN pip install ray[serve] torch transformers

WORKDIR /app
COPY . .

CMD ["ray", "start", "--head", "--port=6379"]
```

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: ray-cluster
spec:
  replicas: 3
  selector:
    matchLabels:
      app: ray
  template:
    spec:
      containers:
      - name: ray
        image: rayproject/ray:latest
        command: ["bash", "-c", "ray start --head --node-ip-address=$MY_POD_IP && python app.py"]
        env:
        - name: MY_POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
```

## Ray Core Deep Dive

### Remote Functions for Parallel Processing

```python
import ray
import time

ray.init()

@ray.remote
def slow_computation(x):
    time.sleep(1)
    return x * 2

# Run in parallel
futures = [slow_computation.remote(i) for i in range(10)]
results = ray.get(futures)  # All run concurrently
print(results)  # [0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
```

### Actors for Stateful Computation

```python
@ray.remote
class Counter:
    def __init__(self):
        self.value = 0
    
    def increment(self):
        self.value += 1
        return self.value
    
    def get_value(self):
        return self.value

# Create actor instance
counter = Counter.remote()

# Call methods remotely
for _ in range(5):
    ray.get(counter.increment.remote())

print(ray.get(counter.get_value.remote()))  # 5
```

### Dependency Graphs

```python
@ray.remote
def step_1():
    return [1, 2, 3]

@ray.remote
def step_2(data):
    return sum(data)

@ray.remote
def step_3(value):
    return value ** 2

# Chain dependencies
data = ray.get(step_1.remote())
sum_result = ray.get(step_2.remote(data))
final = ray.get(step_3.remote(sum_result))
print(final)  # 36
```

### Actor Batching for High Throughput

```python
@ray.remote(num_cpus=1)
class BatchProcessor:
    def __init__(self):
        self.buffer = []
        self.batch_size = 10
    
    async def add_item(self, item):
        self.buffer.append(item)
        if len(self.buffer) >= self.batch_size:
            result = self.process_batch(self.buffer)
            self.buffer = []
            return result
        return None
    
    def process_batch(self, items):
        # Process batch of items
        return [item * 2 for item in items]

processor = BatchProcessor.remote()

# Add items concurrently
futures = [processor.add_item.remote(i) for i in range(100)]
results = ray.get(futures)
```

## Ray Serve: Production Model Serving

### Basic Text Classification Service

```python
from ray import serve
import torch
from transformers import AutoTokenizer, AutoModelForSequenceClassification

@serve.deployment()
class TextClassifier:
    def __init__(self):
        self.model = AutoModelForSequenceClassification.from_pretrained(
            "distilbert-base-uncased-finetuned-sst-2-english"
        )
        self.tokenizer = AutoTokenizer.from_pretrained(
            "distilbert-base-uncased-finetuned-sst-2-english"
        )
    
    @torch.no_grad()
    def predict(self, text: str) -> dict:
        inputs = self.tokenizer(text, return_tensors="pt")
        outputs = self.model(**inputs)
        prediction = torch.argmax(outputs.logits).item()
        return {"label": "positive" if prediction == 1 else "negative"}

# Deploy
TextClassifier.deploy()

# Query via HTTP
import requests
response = requests.post(
    "http://localhost:8000/",
    json={"text": "This product is amazing!"}
)
print(response.json())  # {"label": "positive"}
```

### Multi-Model Routing

```python
@serve.deployment()
class Router:
    def __init__(self):
        self.classifier = TextClassifier.bind()
        self.summarizer = Summarizer.bind()
    
    async def __call__(self, request: Request) -> dict:
        data = await request.json()
        
        if "summary" in data.get("task", ""):
            return await self.summarizer.call.remote(data["text"])
        else:
            return await self.classifier.call.remote(data["text"])

Router.deploy()
```

### Autoscaling Configuration

```python
@serve.deployment(
    num_replicas=3,
    ray_actor_options={"num_cpus": 2, "num_gpus": 1},
    autoscaling_config={"min_replicas": 1, "max_replicas": 20}
)
class ImageGenerator:
    def __init__(self):
        from diffusers import StableDiffusionPipeline
        self.pipeline = StableDiffusionPipeline.from_pretrained(
            "stabilityai/stable-diffusion-xl-base-1.0"
        )
        self.pipeline.to("cuda")
    
    async def generate(self, prompt: str) -> bytes:
        image = self.pipeline(prompt).images[0]
        import io
        buf = io.BytesIO()
        image.save(buf, format="PNG")
        return buf.getvalue()

ImageGenerator.deploy()
```

### A/B Testing with Traffic Splitting

```python
@serve.deployment(route_prefix="/v1/")
class ModelV1:
    async def __call__(self, request):
        data = await request.json()
        return {"version": "v1", "prediction": predict_v1(data["input"])}

@serve.deployment(route_prefix="/v2/")
class ModelV2:
    async def __call__(self, request):
        data = await request.json()
        return {"version": "v2", "prediction": predict_v2(data["input"])}

# Deploy with traffic split
ModelV1.deploy()
ModelV2.deploy()

# Route 90% to v1, 10% to v2
serve.set_traffic(
    "MyApp:ModelV1",
    {"v1": 0.9, "v2": 0.1}
)
```

## Ray Train: Distributed Model Training

### PyTorch Distributed Training

```python
from ray.train import scaling_config, RunConfig
from ray.train.torch import TorchTrainer

def training_func(config):
    import torch
    from torch.utils.data import DataLoader
    
    # Setup distributed training
    backend = "gloo"  # or "nccl" for GPU
    torch.distributed.init_process_group(backend=backend)
    
    model = torch.nn.Linear(10, 1)
    model = torch.nn.parallel.DistributedDataParallel(model)
    
    # Train loop
    optimizer = torch.optim.Adam(model.parameters(), lr=config["lr"])
    for epoch in range(config["epochs"]):
        for batch_x, batch_y in dataloader:
            optimizer.zero_grad()
            output = model(batch_x)
            loss = torch.nn.functional.mse_loss(output, batch_y)
            loss.backward()
            optimizer.step()

trainer = TorchTrainer(
    training_func,
    scaling_config=scaling_config(num_workers=4, use_gpu=True),
    run_config=RunConfig(name="my_training_run")
)

result = trainer.fit()
print(result.metrics)
```

### Hyperparameter Tuning with Ray Tune

```python
from ray import tune
from ray.tune.schedulers import ASHAScheduler

def train_model(config):
    import torch
    import numpy as np
    
    # Simulate training with config hyperparameters
    accuracy = np.random.normal(
        loc=config["accuracy_base"],
        scale=config["noise"]
    )
    
    # Report metrics
    from ray.train import report
    report({"accuracy": accuracy, "loss": 1 - accuracy})

search_space = {
    "accuracy_base": tune.choice([0.7, 0.8, 0.9]),
    "noise": tune.loguniform(0.01, 0.1),
}

scheduler = ASHAScheduler(
    max_t=10,
    grace_period=1,
)

tuner = tune.Tuner(
    train_model,
    param_space=search_space,
    tune_config=tune.TuneConfig(
        scheduler=scheduler,
        num_samples=10,
    ),
)

results = tuner.fit()
best_result = results.get_best_result("accuracy", "max")
print(f"Best config: {best_result.config}")
```

### Hugging Face Integration

```python
from ray.train.huggingface.transformers import TrainerCallback

class RayTrainCallback(TrainerCallback):
    def on_step_end(self, args, state, control, **kwargs):
        # Report progress to Ray
        from ray.train import report
        report({
            "step": state.global_step,
            "loss": state.loss,
            "learning_rate": state.learning_rate
        })

# Use with Hugging Face Trainer
trainer = Trainer(
    model=model,
    train_dataset=train_dataset,
    callbacks=[RayTrainCallback()]
)
```

## Ray Data: Scalable Data Processing

### Loading Large Datasets

```python
import ray.data

# Load from various sources
dataset = ray.data.read_csv("s3://my-bucket/data/*.csv")
dataset = ray.data.read_parquet("gs://my-bucket/data/*.parquet")
dataset = ray.data.read_json("local://data/*.json")

# Inspect data
print(dataset.schema())
print(dataset.count())

# Apply transformations
dataset = dataset.map(lambda row: {
    **row,
    "processed_text": row["text"].strip().lower()
})

# Write results
dataset.write_parquet("output/")
```

### Streaming Data Pipeline

```python
@ray.remote
def generate_data_batch(batch_id):
    import numpy as np
    return {
        "batch_id": batch_id,
        "features": np.random.rand(100, 10).tolist(),
        "labels": np.random.randint(0, 2, 100).tolist()
    }

# Create streaming pipeline
stream = ray.data.from_items(
    [generate_data_batch.remote(i) for i in range(100)]
)

# Process stream
processed = stream.map_batches(
    lambda batch: preprocess_batch(batch),
    batch_size=1000
)

# Write to destination
processed.write_parquet("processed_output/")
```

### Data Preprocessing at Scale

```python
import ray.data
from PIL import Image
import numpy as np

def preprocess_image(row):
    img = Image.open(row["image_path"]).convert("RGB")
    img = img.resize((224, 224))
    return {
        "image": np.array(img).tobytes(),
        "label": row["label"],
        "width": img.width,
        "height": img.height
    }

dataset = ray.data.read_images("s3://my-bucket/images/*.jpg")
preprocessed = dataset.map(preprocess_image)
preprocessed.write_parquet("preprocessed/")
```

## Performance Optimization

### Resource Management

```python
@ray.remote(num_cpus=2, num_gpus=0.5)
def gpu_light_task():
    pass

@ray.remote(num_cpus=4, num_gpus=1)
def gpu_heavy_task():
    pass

# Ray automatically schedules based on resource availability
ray.get(gpu_light_task.remote())
ray.get(gpu_heavy_task.remote())
```

### Memory Management

```python
import ray

# Configure object store memory
ray.init(object_store_memory=10**9)  # 1 GB

# Store large objects efficiently
large_array = np.random.rand(10000, 10000)
ref = ray.put(large_array)

# Access without copying
result = ray.get(ref)
```

### Profiling and Debugging

```python
import ray

# Enable detailed logging
ray.init(logging_level="DEBUG")

# Profile a remote function
@ray.remote
def profiled_function():
    import time
    time.sleep(1)
    return "done"

# Get profiling information
profile = ray.util.inspect_profiler()
print(profile)
```

### GPU Memory Optimization

```python
@ray.remote(num_gpus=1)
class GpuWorker:
    def __init__(self):
        import torch
        self.device = torch.device("cuda:0")
        self.model = load_model().to(self.device)
    
    def predict(self, data):
        with torch.no_grad():
            return self.model(data.to(self.device))
```

## Production Checklist

- [ ] Set up monitoring with Ray Dashboard
- [ ] Configure autoscaling for variable workloads
- [ ] Implement retry logic for transient failures
- [ ] Use Ray Data for efficient I/O-bound tasks
- [ ] Monitor GPU utilization and memory usage
- [ ] Set up alerts for cluster health
- [ ] Document resource requirements for each deployment

### GPU-Aware Scheduling

Ray automatically detects and schedules tasks based on GPU availability:

```python
import ray

ray.init(num_gpus=4)

@ray.remote(num_gpus=1)
def gpu_task():
    import torch
    return torch.cuda.get_device_name(0)

# Each task gets its own GPU
results = ray.get([gpu_task.remote() for _ in range(4)])
print(results)  # [A100, A100, A100, A100]
```

### Distributed Data Parallel Training

Train models across multiple GPUs efficiently:

```python
import ray.train.torch
import torch
import torch.nn as nn
from torch.utils.data import DataLoader

def train_func(config):
    from ray.train import get_context
    backend = get_context().get_backend()
    
    model = nn.Linear(100, 10)
    model = backend.prepare_model(model)
    
    optimizer = torch.optim.Adam(model.parameters(), lr=config["lr"])
    
    for epoch in range(config["epochs"]):
        for batch_x, batch_y in dataloader:
            optimizer.zero_grad()
            output = model(batch_x)
            loss = nn.functional.cross_entropy(output, batch_y)
            loss.backward()
            optimizer.step()
            
            from ray.train import report
            report({"loss": loss.item(), "epoch": epoch})

trainer = ray.train.torch.TorchTrainer(
    train_func,
    scaling_config=ray.train.ScalingConfig(
        num_workers=4,
        use_gpu=True
    )
)

result = trainer.fit()
```

### Ray Client for Remote Clusters

Connect to a remote Ray cluster from your local machine:

```python
import ray

# Connect to remote cluster
ray.init(address="auto", runtime_env={"py_modules": ["./my_module"]})

@ray.remote
def remote_function(x):
    return x ** 2

# Runs on remote cluster, returns results locally
result = ray.get(remote_function.remote(5))
print(result)  # 25
```

## Ray Serve: Advanced Serving Patterns

### Dynamic Model Loading

Load and swap models at runtime without restarting:

```python
from ray import serve

@serve.deployment()
class DynamicClassifier:
    def __init__(self):
        self.models = {}
        self.current_model = None
    
    async def load_model(self, model_name: str):
        from transformers import AutoModelForSequenceClassification
        self.models[model_name] = AutoModelForSequenceClassification.from_pretrained(
            f"model/{model_name}"
        )
        self.current_model = model_name
    
    async def predict(self, text: str) -> dict:
        model = self.models[self.current_model]
        # ... inference logic
        return {"prediction": result}

DynamicClassifier.deploy()
```

### Health Checks and Readiness Probes

Configure health checks for production deployments:

```python
@serve.deployment(
    ray_actor_options={"num_cpus": 2, "num_gpus": 1},
    max_concurrent_queries=100
)
class RobustService:
    def __init__(self):
        self.ready = False
        self.load_model()
        self.ready = True
    
    async def health_check(self):
        if not self.ready:
            raise RuntimeError("Service not ready")
        return {"status": "healthy"}
    
    async def __call__(self, request):
        await self.health_check()
        data = await request.json()
        return {"result": self.predict(data["input"])}
```

### Request Batching for Throughput

Automatically batch incoming requests for efficient GPU utilization:

```python
@serve.deployment(
    ray_actor_options={"num_cpus": 1, "num_gpus": 1},
    autoscaling_config={"min_replicas": 1, "max_replicas": 10}
)
class Batcher:
    def __init__(self):
        self.buffer = []
        self.batch_size = 16
    
    async def add_request(self, request_data):
        self.buffer.append(request_data)
        
        if len(self.buffer) >= self.batch_size:
            results = self.process_batch(self.buffer)
            self.buffer = []
            return results
        
        # Wait for more requests
        await asyncio.sleep(0.1)
        return self.process_batch(self.buffer)
    
    def process_batch(self, batch):
        # Process entire batch at once
        inputs = preprocess_batch(batch)
        outputs = self.model(inputs)
        return postprocess_outputs(outputs)
```

## Ray Data: Advanced Workflows

### Image Processing Pipeline

Process millions of images efficiently:

```python
import ray.data
from PIL import Image
import numpy as np

def resize_and_normalize(row):
    img = Image.open(row["path"]).convert("RGB")
    img = img.resize((224, 224))
    arr = np.array(img).astype(np.float32) / 255.0
    return {"image": arr.tobytes(), "label": row["label"]}

dataset = ray.data.read_images("s3://bucket/images/*.jpg")
processed = dataset.map(resize_and_normalize).repartition(100)
processed.write_parquet("s3://bucket/processed/")
```

### Streaming Transformations

Apply transformations in a streaming fashion for real-time data:

```python
@ray.remote
def stream_processor():
    import ray.data
    
    stream = ray.data.from_items(
        [generate_data.remote(i) for i in range(1000)]
    )
    
    processed = stream.map_batches(
        lambda batch: transform_batch(batch),
        batch_size=500
    )
    
    processed.write_csv("output/stream_")
```

## Monitoring and Observability

### Ray Dashboard

Access the built-in dashboard for real-time monitoring:

```bash
# Start Ray with dashboard enabled
ray start --head --dashboard-port=8265

# Access at http://localhost:8265
```

The dashboard provides:

- CPU/GPU/memory utilization per node
- Task scheduling and execution timelines
- Actor lifecycle management
- Object store usage and eviction
- Cluster configuration and health status

### Prometheus Metrics Integration

Export Ray metrics to Prometheus for custom dashboards:

```python
import ray
from prometheus_client import start_http_server, Counter, Histogram

# Enable metrics collection
ray.init(metrics_export_port=8080)

# Custom metrics
REQUEST_COUNT = Counter("ray_requests_total", "Total requests")
REQUEST_LATENCY = Histogram("ray_request_latency_seconds", "Request latency")

@ray.remote
def tracked_function(data):
    REQUEST_COUNT.inc()
    start = time.time()
    result = process(data)
    REQUEST_LATENCY.observe(time.time() - start)
    return result
```

## Production Checklist

- [ ] Set up monitoring with Ray Dashboard
- [ ] Configure autoscaling for variable workloads
- [ ] Implement retry logic for transient failures
- [ ] Use Ray Data for efficient I/O-bound tasks
- [ ] Monitor GPU utilization and memory usage
- [ ] Set up alerts for cluster health
- [ ] Document resource requirements for each deployment
- [ ] Configure health checks and readiness probes
- [ ] Set up Prometheus metrics integration
- [ ] Test failover scenarios with node failures

## FAQ

### Q1: How does Ray compare to Apache Spark?

Ray is more Python-native and better suited for machine learning workloads, while Spark excels at batch data processing. Ray actor model provides finer-grained control over stateful computations, making it ideal for interactive ML training and serving.

### Q2: Can Ray run on cloud providers?

Yes, Ray runs on AWS, GCP, Azure, and any Kubernetes cluster. Ray Cluster Launcher simplifies setup on major cloud platforms with automatic provisioning of compute resources.

### Q3: What is the maximum cluster size Ray supports?

Ray clusters have been tested with 10,000+ nodes. The limiting factor is typically network bandwidth between nodes rather than Ray internal architecture.

### Q4: Does Ray support mixed CPU/GPU workloads?

Yes, Ray scheduler can mix CPU and GPU workers on the same cluster, optimizing resource utilization by assigning the right worker type to each task.

### Q5: How do I handle node failures in production?

Ray automatically detects failed nodes and reschedules their tasks. You can configure fault tolerance settings like max_restarts and retry_delay to control recovery behavior.

### Q6: What is the difference between Ray and Dask?

Dask is primarily focused on parallel data processing, while Ray provides a broader ecosystem including model serving (Serve), training (Train), and tuning (Tune). Ray actor model is also more flexible for stateful workloads.

### Q7: How do I monitor a Ray cluster?

Access the Ray Dashboard at http://head-node:8265 for real-time metrics on CPU, GPU, memory, and task scheduling. Integrate with Prometheus and Grafana for custom dashboards and alerting.

### Q8: Can I use Ray with Jupyter notebooks?

Yes, Ray integrates seamlessly with Jupyter notebooks. Use ray.init() at the start of your notebook session and all remote functions will execute on the cluster. For distributed Jupyter environments, use JupyterHub with Ray integration.


## FAQ

### Q1: How does Ray compare to Apache Spark?

Ray is more Python-native and better suited for machine learning workloads, while Spark excels at batch data processing. Ray's actor model provides finer-grained control over stateful computations, making it ideal for interactive ML training and serving.

### Q2: Can Ray run on cloud providers?

Yes, Ray runs on AWS, GCP, Azure, and any Kubernetes cluster. Ray Cluster Launcher simplifies setup on major cloud platforms with automatic provisioning of compute resources.

### Q3: What's the maximum cluster size Ray supports?

Ray clusters have been tested with 10,000+ nodes. The limiting factor is typically network bandwidth between nodes rather than Ray's internal architecture.

### Q4: Does Ray support mixed CPU/GPU workloads?

Yes, Ray's scheduler can mix CPU and GPU workers on the same cluster, optimizing resource utilization by assigning the right worker type to each task.

### Q5: How do I handle node failures in production?

Ray automatically detects failed nodes and reschedules their tasks. You can configure fault tolerance settings like `max_restarts` and `retry_delay` to control recovery behavior.

### Q6: What's the difference between Ray and Dask?

Dask is primarily focused on parallel data processing, while Ray provides a broader ecosystem including model serving (Serve), training (Train), and tuning (Tune). Ray's actor model is also more flexible for stateful workloads.

### Q7: How do I monitor a Ray cluster?

Access the Ray Dashboard at `http://<head-node>:8265` for real-time metrics on CPU, GPU, memory, and task scheduling. Integrate with Prometheus and Grafana for custom dashboards and alerting.

## Sources

- [Ray Documentation](https://docs.ray.io/)
- [Ray GitHub Repository](https://github.com/ray-project/ray)
- [Ray Serve Documentation](https://docs.ray.io/en/latest/serve/index.html)
- [Ray Train Documentation](https://docs.ray.io/en/latest/train/index.html)
- [Ray Data Documentation](https://docs.ray.io/en/latest/data/index.html)

## Call to Action

Scale your AI workloads with Ray's unified framework. [Start building](https://dibi8.com/auth/) today with our comprehensive tutorials and production-ready templates.
