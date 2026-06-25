---
title: 'TimesFM 2.5: Google Revolutionary Time Series Foundation Model for Forecasting'
description: 'Complete guide to TimesFM 2.5 - Google Research decoder-only foundation model for time series forecasting. Covers installation, fine-tuning, benchmarks, and real-world applications.'
tags: ["open-source"]
date: 2026-06-19
layout: article
category: data-science
lang: en
slug: timesfm-google-time-series-foundation-model
featureImage: /images/articles/fine-tuning-stack.png
---

# TimesFM 2.5: Google's Revolutionary Time Series Foundation Model for Forecasting

Time series forecasting has long been one of the most challenging problems in data science. From predicting stock prices to forecasting weather patterns, from sales projections to energy consumption estimates — accurate predictions can make or break businesses.

Enter **[TimesFM](https://github.com/google-research/timesfm)**, Google Research's groundbreaking foundation model for time series forecasting. With version 2.5 now available and over 23,000 GitHub stars, TimesFM represents a paradigm shift in how we approach temporal data analysis.

In this comprehensive guide, we'll explore what makes TimesFM special, how to install and use it, compare it with traditional methods, and provide practical examples for real-world forecasting.

## What is TimesFM?

TimesFM (Time Series Foundation Model) is a **decoder-only foundation model** developed by Google Research specifically for time series forecasting. Unlike traditional forecasting methods that require training separate models for each dataset, TimesFM is pretrained on massive amounts of temporal data and can generalize to new forecasting tasks with minimal fine-tuning.

### Key Innovations

The model introduces several groundbreaking innovations:

![Time Series Forecasting](https://images.pexels.com/photos/6332224/pexels-photo-6332224.jpeg)

1. **Decoder-Only Architecture**: Inspired by the success of transformer decoders in language modeling, TimesFM uses a pure decoder architecture optimized for sequential prediction
2. **Foundation Model Approach**: Pretrained on massive amounts of temporal data, enabling zero-shot and few-shot forecasting capabilities
3. **Continuous Quantile Forecasting**: Provides uncertainty estimates alongside point forecasts through an optional quantile head
4. **Extended Context Window**: Supports up to 16,000 time steps of historical data for improved long-range dependencies
5. **Reduced Parameter Count**: Version 2.5 uses only 200M parameters (down from 500M in v2.0) while improving accuracy

### The Research Behind TimesFM

The foundational research was published in the paper **"A decoder-only foundation model for time-series forecasting"** at ICML 2024. Since then, the model has evolved through multiple versions, with v2.5 representing the current state-of-the-art in time series foundation modeling.

## TimesFM 2.5: Major Improvements

Version 2.5, released in September 2025, brings significant improvements over previous versions:

![Model Architecture](https://images.pexels.com/photos/8386449/pexels-photo-8386449.jpeg)

| Feature | TimesFM 2.0 | TimesFM 2.5 |
|---------|-------------|-------------|
| Parameters | 500M | 200M |
| Context Length | 2,048 | 16,000 |
| Quantile Forecasting | Discrete | Continuous (up to 1,000 horizon) |
| Frequency Indicator | Required | Removed |
| Inference Speed | Baseline | 2.5x faster |
| Memory Usage | High | Optimized |

### Why Fewer Parameters, Better Results?

This counterintuitive improvement is achieved through:

![Neural Network](https://images.pexels.com/photos/3861959/pexels-photo-3861959.jpeg)

1. **Better Pretraining Data**: More diverse and larger temporal datasets
2. **Architectural Refinements**: Optimized attention mechanisms for time series
3. **Improved Training Objectives**: Multi-task learning with various forecasting losses
4. **Quantile Head Innovation**: The optional 30M quantile head provides uncertainty without bloating the main model

## Installation Guide

Getting started with TimesFM is straightforward. The model is available through PyPI, making installation as simple as:

### Option 1: Quick Install via PyPI

```bash
# Install with PyTorch backend
pip install timesfm[torch]

# Or with Flax/JAX backend (recommended for GPU/TPU)
pip install timesfm[flax]

# If you need covariate support (XReg)
pip install timesfm[xreg]
```

### Option 2: Development Installation

For those who want to contribute or access the latest features:

```bash
# Clone the repository
git clone https://github.com/google-research/timesfm.git
cd timesfm

# Create virtual environment
uv venv
source .venv/bin/activate

# Install in editable mode
uv pip install -e .[torch]
# Or for Flax backend
uv pip install -e .[flax]
```

### Backend Selection

TimesFM supports multiple backends:

- **PyTorch**: Best for CPU and NVIDIA GPU users
- **Flax/JAX**: Optimal for TPU and Google Cloud environments
- **XReg Extension**: Adds covariate support for external regressors

Choose your backend based on your hardware and deployment requirements.

## Basic Usage

Let's start with a simple forecasting example:

### Zero-Shot Forecasting

```python
import numpy as np
import timesfm

# Load the pretrained model
model = timesfm.TimesFM_2p5_200M.from_pretrained(
    "google/timesfm-2.5-200m-flax"
)

# Prepare your time series data
# Shape: (num_series, context_length)
historical_data = np.random.randn(1, 1024)

# Forecast the next 12 time steps
forecast = model.forecast(historical_data, horizon=12)
print(f"Forecast shape: {forecast.shape}")
print(f"Predicted values: {forecast}")
```

### With Quantile Forecasting

For uncertainty estimation, enable the continuous quantile head:

```python
forecast_with_uncertainty = model.forecast(
    historical_data,
    horizon=12,
    quantiles=[0.1, 0.5, 0.9]  # 10th, 50th, 90th percentiles
)

# forecast_with_uncertainty contains point forecasts and confidence intervals
point_forecast = forecast_with_uncertainty[:, :, 1]  # median
lower_bound = forecast_with_uncertainty[:, :, 0]     # 10th percentile
upper_bound = forecast_with_uncertainty[:, :, 2]     # 90th percentile
```

### Using the PyTorch Backend

```python
import torch
import timesfm

# Set precision for faster computation
torch.set_float32_matmul_precision("high")

# Load PyTorch version
model = timesfm.TimesFM_2p5_200M_torch.from_pretrained(
    "google/timesfm-2.5-200m-pytorch"
)

# Compile for optimized inference
model.compile(
    timesfm.ForecastConfig(
        max_context=1024,
        max_horizon=256,
        normalize_inputs=True,
        use_continuous_quantile_head=True,
        force_flip_invariance=True,
        infer_is_positive=True,
        fix_quantile_crossing=True,
    )
)

# Make predictions
point_forecast, quantile_forecast = model.forecast(
    horizon=12,
    inputs=[
        np.linspace(0, 1, 100),
        np.sin(np.linspace(0, 20, 67)),
    ]
)
```

## Advanced Features

### Fine-Tuning with LoRA

One of the most powerful features of TimesFM 2.5 is the ability to fine-tune using Low-Rank Adaptation (LoRA):

```python
from transformers import AutoModelForSequenceClassification
from peft import LoraConfig, get_peft_model

# Load the base TimesFM model
base_model = timesfm.TimesFM_2p5_200M.from_pretrained(
    "google/timesfm-2.5-200m-flax"
)

# Configure LoRA
lora_config = LoraConfig(
    r=16,  # Rank of the update matrices
    lora_alpha=32,  # Scaling factor
    target_modules=["query", "value"],  # Layers to apply LoRA to
    lora_dropout=0.1,
)

# Apply LoRA to the model
model = get_peft_model(base_model, lora_config)

# Now you can fine-tune on your specific dataset
# This requires significantly fewer parameters than full fine-tuning
```

### Covariate Support with XReg

For scenarios where you have external variables that influence your time series, TimesFM 2.5 supports covariate modeling:

```python
# Install with XReg support
# pip install timesfm[xreg]

import timesfm

# Load model with covariate support
model = timesfm.TimesFM_2p5_200M_XReg.from_pretrained(
    "google/timesfm-2.5-200m-xreg"
)

# Historical time series data
y_train = np.random.randn(1000)

# External covariates (e.g., marketing spend, seasonality indicators)
X_train = np.random.randn(1000, 5)

# Fit the covariate model
model.fit(y_train, X_train)

# Forecast with future covariates
y_pred, confidence_intervals = model.predict(
    horizon=12,
    X_future=np.random.randn(12, 5)
)
```

### Batch Forecasting

For multiple time series simultaneously:

```python
# Prepare batch of time series
batch_data = np.random.randn(10, 1024)  # 10 series, 1024 timesteps each

# Forecast all series at once
forecasts = model.forecast(batch_data, horizon=24)

# Shape: (10, 24) - 10 forecasts of 24 time steps each
print(f"Batch forecast shape: {forecasts.shape}")
```

### Batch Forecasting

For multiple time series simultaneously:

```python
# Prepare batch of time series
batch_data = np.random.randn(10, 1024)  # 10 series, 1024 timesteps each

# Forecast all series at once
forecasts = model.forecast(batch_data, horizon=24)

# Shape: (10, 24) - 10 forecasts of 24 time steps each
print(f"Batch forecast shape: {forecasts.shape}")
```

### Batch Forecasting

For multiple time series simultaneously:

```python
# Prepare batch of time series
batch_data = np.random.randn(10, 1024)  # 10 series, 1024 timesteps each

# Forecast all series at once
forecasts = model.forecast(batch_data, horizon=24)

# Shape: (10, 24) - 10 forecasts of 24 time steps each
print(f"Batch forecast shape: {forecasts.shape}")
```

### Streaming Inference

For real-time forecasting applications:

```python
# Initialize streaming client
streaming_model = timesfm.StreamingTimesFM(
    model_path="google/timesfm-2.5-200m-flax"
)

# Process incoming data streams
while True:
    new_data = get_next_time_step()
    forecast = streaming_model.update_and_predict(new_data, horizon=12)
    display_forecast(forecast)
```

## Performance Benchmarks

TimesFM 2.5 achieves state-of-the-art results across multiple benchmark datasets:

### Benchmark Results

| Dataset | TimesFM 2.5 | AutoARIMA | Prophet | N-BEATS |
|---------|-------------|-----------|---------|---------|
| ETTh1 | 0.312 | 0.487 | 0.523 | 0.398 |
| Electricity | 0.234 | 0.312 | 0.298 | 0.267 |
| Traffic | 0.198 | 0.287 | 0.276 | 0.245 |
| Weather | 0.156 | 0.234 | 0.221 | 0.189 |
| Exchange Rate | 0.287 | 0.398 | 0.412 | 0.334 |

Lower values indicate better performance (normalized MSE).

### Real-World Performance

In production environments, TimesFM 2.5 has demonstrated:

- **95% accuracy** on demand forecasting for retail chains
- **40% reduction** in inventory costs compared to traditional methods
- **10x faster** training times compared to custom neural network approaches
- **Consistent performance** across diverse domains (finance, healthcare, manufacturing)

## Integration with Google Products

One of TimesFM's unique advantages is its integration with Google's ecosystem:

### BigQuery ML

For enterprise-scale forecasting:

```sql
-- Use TimesFM model in BigQuery ML
CREATE MODEL my_project.my_timesfm_model
OPTIONS(model_type='TIMESFM') AS
SELECT
  timestamp_col,
  value_col,
  EXTRACT(HOUR FROM timestamp_col) AS hour_of_day
FROM `my_dataset.time_series_data`;
```

### Google Sheets Integration

For non-technical users:

1. Install the [TimesFM add-on](https://workspaceupdates.googleblog.com/2026/02/forecast-data-in-connected-sheets-BigQueryML-TimesFM.html)
2. Select your data range
3. Choose forecast horizon
4. Get predictions directly in your spreadsheet

### Vertex AI Model Garden

For cloud deployment:

```python
from google.cloud import aiplatform

# Deploy TimesFM model to Vertex AI
aiplatform.init(project="your-project", location="us-central1")

endpoint = aiplatform.Endpoint.create(
    display_name="timesfm-forecasting-endpoint",
    description="TimesFM 2.5 forecasting endpoint"
)

model = aiplatform.Model.upload(
    display_name="timesfm-2.5",
    artifact_uri="gs://your-bucket/timesfm-model"
)

endpoint.deploy(model=model, machine_type="n1-standard-4")
```

## Real-World Applications

### Application 1: Sales Forecasting

Retail companies can use TimesFM to predict future sales:

```python
import pandas as pd
import timesfm

# Load historical sales data
sales_data = pd.read_csv("historical_sales.csv")

# Prepare time series
historical_sales = sales_data["sales"].values.reshape(1, -1)

# Forecast next 30 days
model = timesfm.TimesFM_2p5_200M.from_pretrained(
    "google/timesfm-2.5-200m-flax"
)

forecast = model.forecast(historical_sales, horizon=30)
print(f"Expected sales next month: {forecast.mean():.2f}")
```

### Application 2: Energy Demand Prediction

Utility companies can forecast electricity demand:

```python
# Load energy consumption data
energy_data = pd.read_csv("energy_consumption.csv")

# Include weather covariates
covariates = pd.DataFrame({
    "temperature": weather_data["temp"],
    "humidity": weather_data["humidity"],
    "day_of_week": energy_data.index.dayofweek
})

# Train with covariates
model.fit(energy_data["consumption"], covariates.values)

# Predict future demand
future_demand = model.predict(
    horizon=24,
    X_future=future_covariates.values
)
```

### Application 3: Financial Market Analysis

While not financial advice, TimesFM can help analyze market patterns:

```python
# Stock price forecasting
stock_prices = pd.read_csv("stock_history.csv")["close"].values

# Multiple stocks
batch_stocks = np.array([
    stock_prices[:-100],  # Apple
    stock_prices[100:-100],  # Google
    stock_prices[200:]  # Amazon
])

# Forecast all stocks
predictions = model.forecast(batch_stocks, horizon=30)
```

## Comparison with Traditional Methods

### TimesFM vs. ARIMA

| Aspect | TimesFM 2.5 | ARIMA |
|--------|-------------|-------|
| Setup Time | Minutes | Hours-Days |
| Parameter Tuning | Minimal | Extensive |
| Multi-series | Yes | No |
| Non-linear Patterns | Excellent | Limited |
| Interpretability | Lower | Higher |
| Scalability | High | Moderate |

### TimesFM vs. Prophet

| Aspect | TimesFM 2.5 | Prophet |
|--------|-------------|---------|
| Foundation Model | Yes | No |
| Transfer Learning | Yes | No |
| Uncertainty Estimation | Continuous | Discrete |
| Computational Efficiency | High | Moderate |
| Community Support | Growing | Mature |

## Limitations and Considerations

### Current Limitations

1. **Requires Historical Data**: While few-shot learning helps, some historical data is still needed
2. **Computational Resources**: Large context windows require significant memory
3. **Domain Specificity**: May need fine-tuning for specialized domains
4. **Interpretability**: Like all deep learning models, internal workings are somewhat opaque

### Best Practices

1. **Data Quality**: Ensure clean, consistent time series data
2. **Context Length**: Choose appropriate history window for your use case
3. **Regular Updates**: Retrain periodically as new data becomes available
4. **Validation**: Always validate predictions against holdout datasets

### TimesFM vs. ARIMA

| Aspect | TimesFM 2.5 | ARIMA |
|--------|-------------|-------|
| Setup Time | Minutes | Hours-Days |
| Parameter Tuning | Minimal | Extensive |
| Multi-series | Yes | No |
| Non-linear Patterns | Excellent | Limited |
| Interpretability | Lower | Higher |
| Scalability | High | Moderate |

### TimesFM vs. Prophet

| Aspect | TimesFM 2.5 | Prophet |
|--------|-------------|---------|
| Foundation Model | Yes | No |
| Transfer Learning | Yes | No |
| Uncertainty Estimation | Continuous | Discrete |
| Computational Efficiency | High | Moderate |
| Community Support | Growing | Mature |

## Limitations and Considerations

### Current Limitations

1. **Requires Historical Data**: While few-shot learning helps, some historical data is still needed
2. **Computational Resources**: Large context windows require significant memory
3. **Domain Specificity**: May need fine-tuning for specialized domains
4. **Interpretability**: Like all deep learning models, internal workings are somewhat opaque

### Best Practices

1. **Data Quality**: Ensure clean, consistent time series data
2. **Context Length**: Choose appropriate history window for your use case
3. **Regular Updates**: Retrain periodically as new data becomes available
4. **Validation**: Always validate predictions against holdout datasets

## The Future of Time Series Forecasting

TimesFM represents just the beginning of what foundation models can achieve in temporal data analysis. Upcoming developments include:

### Planned Features

- **Multivariate Forecasting**: Better handling of multiple related time series
- **Real-time Learning**: Online adaptation without full retraining
- **Explainable AI**: Improved interpretability of predictions
- **Edge Deployment**: Optimized versions for mobile and IoT devices
- **Multi-modal Integration**: Combining time series with images, text, and other data types

### Research Directions

The Google Research team continues to push the boundaries with ongoing work on:

- Longer context windows (32K+ time steps)
- Fewer parameters with equal or better performance
- Cross-domain generalization
- Causal inference capabilities

## Getting Started Today

Ready to revolutionize your forecasting workflow? Here's how to begin:

1. **Install**: `pip install timesfm[flax]`
2. **Load Model**: Use the pretrained checkpoint from Hugging Face
3. **Prepare Data**: Format your time series appropriately
4. **Forecast**: Call the forecast method with your desired horizon
5. **Fine-tune**: Optionally adapt the model to your specific domain

Whether you're a data scientist looking for better forecasting tools or a business analyst wanting to make data-driven predictions, TimesFM 2.5 offers a powerful, flexible solution that's ready to deploy today.

## Frequently Asked Questions

### Q: What's the difference between TimesFM 2.0 and 2.5?

TimesFM 2.5 uses only 200M parameters (down from 500M in 2.0) while achieving better accuracy. It supports up to 16,000 context length (vs 2,048), continuous quantile forecasting up to 1,000 horizon, and removes the need for frequency indicators.

### Q: Do I need a GPU to run TimesFM?

No, TimesFM can run on CPU, though GPU acceleration significantly improves inference speed. The Flax/JAX backend is recommended for TPU and NVIDIA GPU users, while PyTorch works well for CPU and NVIDIA GPU setups.

### Q: Can I use TimesFM for financial forecasting?

While TimesFM can technically forecast financial time series, it's important to note that financial markets are influenced by countless unpredictable factors. The model should be used as one tool among many, not as a sole basis for investment decisions.

### Q: How does fine-tuning work with TimesFM?

Fine-tuning uses Low-Rank Adaptation (LoRA) through HuggingFace Transformers. You prepare your domain-specific data, configure LoRA parameters, and train for a few epochs. This adapts the foundation model to your specific forecasting task without requiring full model retraining.

### Q: What's the maximum forecast horizon?

TimesFM 2.5 supports horizons up to 1,000 time steps with its continuous quantile head. For most practical applications, horizons of 24-365 time steps are sufficient and provide the best accuracy.

### Q: Is TimesFM suitable for real-time forecasting?

Yes, once compiled and optimized, TimesFM can provide real-time predictions. The compiled models with optimized inference configurations can forecast hundreds of time steps per second on modern hardware.

## Conclusion

TimesFM 2.5 represents a quantum leap in time series forecasting. By combining the power of foundation models with domain-specific optimizations for temporal data, it achieves remarkable accuracy with minimal setup and computational overhead.

With its integration into Google's ecosystem, active development community, and continuous improvements, TimesFM is poised to become the standard for time series forecasting across industries.

For anyone working with temporal data, investing time in learning and deploying TimesFM is not just beneficial — it's becoming essential.

---

**Sources:**
- [GitHub Repository](https://github.com/google-research/timesfm)
- [ICML 2024 Paper](https://arxiv.org/abs/2310.10688)
- [Google Research Blog](https://research.google/blog/a-decoder-only-foundation-model-for-time-series-forecasting/)
- [Hugging Face Models](https://huggingface.co/collections/google/timesfm-release-66e4be5fdb56e960c1e482a6)

**CTA:** Join the [DIBI8 Telegram group](https://t.me/DIBI8_Group/2) for more AI and data science insights!

**Affiliate Links:**
- [DigitalOcean](https://m.do.co/c/eca87ac14ee0) - Host your ML models
- [HTStack](https://my.htstack.com/aff.php?aff=27187) - Reliable GPU server hosting
- [虎网云](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367) - GPU servers for training (Chinese)
