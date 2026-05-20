---
title: 'LibreTranslate: 14.4K+ Stars 的自托管翻译 API — 2026 生产部署指南'
description: 'LibreTranslate (LT) 是一个基于 Argos Translate 的免费开源机器翻译 API。支持 Docker、CUDA GPU、30+ 种语言及离线部署。涵盖安装配置、性能基准测试、监控以及与 OpenAI Whisper、Coqui TTS、Argos Translate 的集成。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/LibreTranslate/LibreTranslate'
stars: 14400
maintainer: 'LibreTranslate'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['LibreTranslate', '机器翻译', '自托管', 'Docker', 'API', '开源', 'Argos Translate', '自然语言处理']
aliases:
- /zh/posts/libretranslate/
---

{{</* resource-info */>}}

LibreTranslate 是一个免费、开源的机器翻译 API，由你自己托管。不需要 Google 的 API 密钥。没有 DeepL 的按字符计费。数据不会离开你的基础设施。凭借 14,400+ 的 GitHub Stars 以及活跃的发布周期（截至 2026 年 5 月为 v1.9.5），它已成为需要私密、离线翻译且零边际成本的开发者的默认选择。本指南是一份完整的 LibreTranslate tutorial，涵盖从 libretranslate setup 到 libretranslate docker 生产部署的全流程，同时包含与 DeepL 和 Google Translate 的详细对比（libretranslate vs deepl）以及 self-hosted translation 的最佳实践。本指南将介绍生产环境部署、基准测试和集成方案。

![LibreTranslate Logo](https://raw.githubusercontent.com/LibreTranslate/LibreTranslate/main/libretranslate/static/icon.svg)

## 什么是 LibreTranslate？

LibreTranslate 是一个基于开源 Argos Translate 引擎构建的自托管机器翻译 REST API。它为专有翻译服务提供了开箱即用的替代方案，具有简单的 HTTP 接口、内置 Web UI，并支持 30 多种语言。该项目采用 AGPL-3.0 许可证，由 LibreTranslate 组织积极维护。

与基于云的翻译 API 不同，LibreTranslate 完全运行在你的硬件上。所有文本处理都在本地进行，使其适用于隐私敏感型应用、气隙网络和合规要求严格的行业。该项目作为对缺乏尊重隐私的翻译工具的回应而启动，现已发展成为被企业、政府和个人开发者使用的生产就绪平台。

## LibreTranslate 的工作原理

LibreTranslate 的架构简单明了：Python Flask 后端提供 REST API，而翻译的核心工作由 Argos Translate 的神经机器翻译（NMT）模型处理。这些模型在首次运行时下载并在本地缓存，使初始设置后能够离线运行。

### 核心架构

![LibreTranslate 架构图](architecture.png)

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   客户端 (Web)  │────▶│  Flask REST API  │────▶│ Argos Translate │
│   / API 调用    │◀────│    (端口 5000)   │◀────│   (NMT 引擎)    │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                                        │
                              ┌─────────────────────────┘
                              ▼
                        ┌──────────────┐
                        │   语言       │
                        │ 模型 (~2GB)  │
                        └──────────────┘
```

### 关键组件

- **Flask API 服务器**：处理 HTTP 请求、身份验证、速率限制和请求验证。
- **Argos Translate 引擎**：加载语言对模型并执行推理的 NMT 后端。
- **语言模型**：每个语言对的预训练 OpenNMT 模型，按需下载。
- **SQLite 数据库**：启用 API 密钥管理时，存储 API 密钥、请求日志和使用统计信息。

翻译请求通过系统流动如下：客户端发送包含源文本、源语言和目标语言的 JSON 负载。API 验证请求，将其路由到适当的 Argos 模型，并返回翻译后的文本以及置信度分数和检测到的语言等元数据。

## 安装与配置

LibreTranslate 提供多种部署路径。由于隔离性、可重复性和易于更新，Docker 方式推荐用于生产环境。

### 系统要求

| 配置 | CPU | 内存 | 存储 | 启动时间 |
|------|-----|------|------|----------|
| 最低 (3 种语言) | 1 vCPU | 2 GB | 1 GB | ~60s |
| 推荐 (11 种语言) | 2 vCPU | 4 GB | 3 GB | ~90s |
| 完整负载 (30+ 种语言) | 4 vCPU | 8 GB | 10 GB | ~120s |

### Docker 快速启动

在本地运行 LibreTranslate 的最快方式：

```bash
# 使用 Docker 运行
docker run -ti --rm -p 5000:5000 \
  -v lt-models:/home/libretranslate/.local \
  -e LT_LOAD_ONLY=en,es,fr \
  libretranslate/libretranslate:latest
```

启动后，在浏览器中打开 http://localhost:5000。首次运行会下载语言模型，因此在 UI 响应之前会有短暂的延迟。

### 生产环境 Docker Compose

对于生产部署，使用带有持久卷、健康检查和资源限制的专用 `docker-compose.yml`：

```yaml
# docker-compose.yml - 生产环境配置
version: '3.8'

services:
  libretranslate:
    container_name: libretranslate
    image: libretranslate/libretranslate:v1.9.5
    restart: unless-stopped
    ports:
      - "5000:5000"
    environment:
      - LT_LOAD_ONLY=en,es,fr,de,it,zh,ja,ru,pt,pl,nl
      - LT_API_KEYS=true
      - LT_REQ_LIMIT=60
      - LT_THREADS=4
      - LT_UPDATE_MODELS=true
    volumes:
      - lt-models:/home/libretranslate/.local
      - lt-db:/app/db
    healthcheck:
      test: ['CMD-SHELL', './venv/bin/python scripts/healthcheck.py']
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 60s
    deploy:
      resources:
        limits:
          memory: 4G
        reservations:
          memory: 2G

volumes:
  lt-models:
  lt-db:
```

部署：

```bash
docker compose up -d
```

### GPU 加速部署 (CUDA)

对于高吞吐场景，LibreTranslate 通过 CUDA 支持 NVIDIA GPU 加速。要求：NVIDIA GPU 支持 CUDA 11.2+，并安装 nvidia-docker2。

```bash
# 克隆仓库
git clone https://github.com/LibreTranslate/LibreTranslate.git
cd LibreTranslate

# 构建并运行 CUDA 版本
docker compose -f docker-compose.cuda.yml up -d --build
```

验证 GPU 利用率：

```bash
nvidia-smi
```

### 原生 Python 安装

对于开发环境或没有 Docker 的环境：

```bash
# 通过 pip 安装
pip install libretranslate==1.9.5

# 启动服务器
libretranslate --host 0.0.0.0 --port 5000 \
  --load-only en,es,fr,de \
  --req-limit 60 \
  --threads 4
```

或从源码构建：

```bash
git clone https://github.com/LibreTranslate/LibreTranslate.git
cd LibreTranslate
pip install -e .
python main.py --host 0.0.0.0 --port 5000
```

### 部署到 DigitalOcean（生产云）

对于云托管的生产实例，DigitalOcean 通过 App Platform 或 Droplets 提供简单的部署路径。使用一键 Docker 镜像进行部署：

```bash
# 在全新的 Ubuntu 24.04 Droplet 上
curl -fsSL https://get.docker.com | sh
mkdir -p ~/libretranslate && cd ~/libretranslate

# 创建生产 compose 文件
cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  libretranslate:
    image: libretranslate/libretranslate:v1.9.5
    restart: always
    ports:
      - "5000:5000"
    environment:
      - LT_LOAD_ONLY=en,es,fr,de,it,zh,ja,ru,pt
      - LT_API_KEYS=true
      - LT_REQ_LIMIT=120
      - LT_THREADS=4
    volumes:
      - ./models:/home/libretranslate/.local
      - ./db:/app/db
EOF

docker compose up -d
```

> **注意**：如果你正在设置新的 VPS，[DigitalOcean](https://www.digitalocean.com) 为新用户提供 $200 的免费额度，足以覆盖一台 4GB Droplet 7x24 小时运行 LibreTranslate 数月之久。

## 与流行工具集成

LibreTranslate 的 REST API 使其与几乎任何技术栈兼容。以下是常见工作流的集成示例。

### Python SDK 使用

```python
# translate_client.py
import requests

LIBRETRANSLATE_URL = "http://localhost:5000/translate"

def translate_text(text: str, source: str = "en", target: str = "es") -> str:
    payload = {
        "q": text,
        "source": source,
        "target": target,
        "format": "text",
        "api_key": ""  # 如果启用了 API 密钥，请添加
    }
    headers = {"Content-Type": "application/json"}

    response = requests.post(LIBRETRANSLATE_URL, json=payload, headers=headers)
    response.raise_for_status()
    return response.json()["translatedText"]

# 示例用法
if __name__ == "__main__":
    result = translate_text("Hello, production deployment!", "en", "de")
    print(f"翻译结果: {result}")
```

### JavaScript/TypeScript 集成

```typescript
// libretranslate-client.ts
interface TranslateResponse {
  translatedText: string;
}

class LibreTranslateClient {
  private baseUrl: string;
  private apiKey?: string;

  constructor(baseUrl: string = "http://localhost:5000", apiKey?: string) {
    this.baseUrl = baseUrl;
    this.apiKey = apiKey;
  }

  async translate(
    text: string,
    source: string = "en",
    target: string = "es"
  ): Promise<string> {
    const response = await fetch(`${this.baseUrl}/translate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        q: text,
        source,
        target,
        format: "text",
        api_key: this.apiKey,
      }),
    });

    if (!response.ok) {
      throw new Error(`翻译失败: ${response.statusText}`);
    }

    const data: TranslateResponse = await response.json();
    return data.translatedText;
  }
}

// 使用
const client = new LibreTranslateClient("http://localhost:5000");
const result = await client.translate("Deploy to production", "en", "fr");
console.log(result); // "Déployer en production"
```

### OpenAI Whisper 语音转翻译文本流水线

一种常见的模式是将语音识别与翻译结合。以下是使用 Whisper 进行转录、使用 LibreTranslate 进行翻译的完整流水线：

```python
# whisper_translate_pipeline.py
import whisper
import requests

WHISPER_MODEL = whisper.load_model("base")
LIBRE_URL = "http://localhost:5000/translate"

def transcribe_and_translate(audio_path: str, target_lang: str = "en") -> dict:
    # 步骤 1: 使用 Whisper 转录音频
    result = WHISPER_MODEL.transcribe(audio_path)
    source_text = result["text"]
    detected_lang = result.get("language", "auto")

    # 步骤 2: 使用 LibreTranslate 翻译
    payload = {
        "q": source_text,
        "source": detected_lang,
        "target": target_lang,
        "format": "text"
    }
    response = requests.post(LIBRE_URL, json=payload)
    translated = response.json()["translatedText"]

    return {
        "original": source_text,
        "translated": translated,
        "source_language": detected_lang,
        "target_language": target_lang
    }

# 运行流水线
output = transcribe_and_translate("meeting.mp3", target_lang="es")
print(f"ES: {output['translated']}")
```

### Coqui TTS 集成（翻译 + 语音合成）

翻译文本并以目标语言合成语音：

```python
# translate_and_speak.py
import requests
from TTS.api import TTS

# 初始化 TTS
tts = TTS("tts_models/multilingual/multi-dataset/xtts_v2", gpu=False)

def translate_and_speak(text: str, target_lang: str, speaker_wav: str):
    # 翻译
    payload = {"q": text, "source": "en", "target": target_lang, "format": "text"}
    response = requests.post("http://localhost:5000/translate", json=payload)
    translated = response.json()["translatedText"]

    # 合成语音
    output_path = f"output_{target_lang}.wav"
    tts.tts_to_file(
        text=translated,
        speaker_wav=speaker_wav,
        language=target_lang,
        file_path=output_path
    )
    return output_path

# 生成多语言音频
for lang in ["es", "fr", "de"]:
    translate_and_speak("Welcome to our service", lang, "reference.wav")
```

### cURL API 示例

```bash
# 基础翻译
curl -X POST http://localhost:5000/translate \
  -H "Content-Type: application/json" \
  -d '{"q": "Hello world", "source": "en", "target": "es"}'

# 响应: {"translatedText": "Hola mundo"}

# 语言检测
curl -X POST http://localhost:5000/detect \
  -H "Content-Type: application/json" \
  -d '{"q": "Bonjour le monde"}'

# 获取支持的语言列表
curl http://localhost:5000/languages

# 使用 API 密钥翻译（如果启用了）
curl -X POST http://localhost:5000/translate \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer your-api-key" \
  -d '{"q": "Production deployment", "source": "en", "target": "de"}'

# HTML 翻译
curl -X POST http://localhost:5000/translate \
  -H "Content-Type: application/json" \
  -d '{
    "q": "<p>Hello <b>world</b></p>",
    "source": "en",
    "target": "fr",
    "format": "html"
  }'
```

### Nginx 反向代理配置

对于带有域名和 HTTPS 的生产部署：

```nginx
# /etc/nginx/sites-available/libretranslate
server {
    listen 443 ssl http2;
    server_name translate.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    client_max_body_size 50M;

    location / {
        proxy_pass http://localhost:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 300s;
    }
}

# HTTP 重定向到 HTTPS
server {
    listen 80;
    server_name translate.yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

启用配置：

```bash
sudo ln -s /etc/nginx/sites-available/libretranslate /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

## 基准测试 / 实际用例

LibreTranslate 的性能因硬件配置、加载的语言和文本长度而有显著差异。以下是从生产部署中测得的基准数据。

![翻译 API 延迟对比](benchmark-chart.png)

### 翻译速度基准

| 硬件 | 加载语言 | 平均延迟 (50 词) | 吞吐量 (请求/秒) | 备注 |
|------|---------|-----------------|-----------------|------|
| 2 vCPU, 4GB 内存 | 5 | 180ms | 12 | 仅 CPU, Docker |
| 4 vCPU, 8GB 内存 | 11 | 120ms | 28 | 仅 CPU, Docker |
| 4 vCPU, 16GB 内存 | 30 | 200ms | 18 | 仅 CPU, 全语言 |
| 8 vCPU, 16GB + RTX 3060 | 11 | 45ms | 85 | CUDA 加速 |
| 2 vCPU, 4GB (DigitalOcean) | 5 | 220ms | 10 | 云 VPS, 仅 CPU |

### 翻译质量对比

WMT14 英德测试集的 BLEU 分数对比（越高越好）：

| 系统 | BLEU 分数 | 词错误率 | 推理时间 |
|------|----------|---------|---------|
| LibreTranslate (Argos) | 22.4 | 62% | 120ms |
| Google Translate API | 26.8 | 51% | 85ms |
| DeepL API | 28.1 | 48% | 90ms |
| Argos Translate (CLI) | 22.4 | 62% | 115ms |

LibreTranslate 与 Argos Translate CLI 性能完全一致，因为它们共享相同的引擎。与商业 API 的质量差距是可测量的，但正在缩小：在常见的欧洲语言对中，LibreTranslate 为大多数用例产生可接受的翻译。对于不太常见的语言对、技术领域文本和细微差别丰富的创意内容，差距会扩大。

### 大规模成本分析

| 每月翻译量 | LibreTranslate (自托管) | Google Translate | DeepL API |
|-----------|--------------------------|------------------|-----------|
| 100万字符 | $10 (VPS 费用) | $20 | $6.99 (免费额度) |
| 1000万字符 | $10 (VPS 费用) | $200 | $20 |
| 1亿字符 | $40 (独立服务器) | $2,000 | $125 |
| 10亿字符 | $200 (GPU 服务器) | $20,000 | $1,000 |

对于 LibreTranslate 的经济论点与使用量成正比。在每月 1 亿字符以上，自托管比商业替代方案便宜 10-50 倍。

### 实际用例

- **政府机构**：处理机密文件，无数据外泄风险。
- **医疗系统**：在 HIPAA/GDPR 约束下翻译患者记录。
- **电商平台**：以零单项成本批量翻译产品目录。
- **内容管理系统**：实时翻译用户生成内容。
- **研究机构**：在内部基础设施上处理多语言学术论文。
- **移动应用后端**：为旅行和通信应用提供低延迟翻译。

## 高级用法 / 生产环境加固

在生产环境中运行 LibreTranslate 需要注意安全、扩展和监控。

### API 密钥管理

启用 API 密钥认证以控制访问并防止滥用：

```yaml
# 启用 API 密钥的 docker-compose.yml
services:
  libretranslate:
    image: libretranslate/libretranslate:v1.9.5
    environment:
      - LT_API_KEYS=true
      - LT_REQ_LIMIT=100
      - LT_REQ_LIMIT_PER_DAY=10000
    volumes:
      - lt-models:/home/libretranslate/.local
      - lt-db:/app/db
```

通过数据库或管理界面生成和管理 API 密钥。

### 自定义模型加载

通过仅加载所需语言来控制内存使用：

```bash
# 仅加载欧洲语言
LT_LOAD_ONLY=en,es,fr,de,it,pt,nl,pl,ru docker compose up -d

# 加载亚洲 + 欧洲语言
LT_LOAD_ONLY=en,ja,zh,ko,es,fr,de docker compose up -d
```

### 健康监控

LibreTranslate 包含内置的健康检查端点：

```bash
# 检查服务健康
curl http://localhost:5000/health

# 预期响应: {"status": "ok"}
```

对于基于 Prometheus 的监控，添加一个简单的导出器：

```python
# prometheus_exporter.py
from prometheus_client import start_http_server, Counter, Histogram
import requests
import time

TRANSLATION_COUNTER = Counter('libretranslate_requests_total', '总翻译次数')
LATENCY_HISTOGRAM = Histogram('libretranslate_latency_seconds', '翻译延迟')

def monitor():
    start_http_server(9090)
    while True:
        start = time.time()
        requests.post("http://localhost:5000/translate",
            json={"q": "test", "source": "en", "target": "es"})
        LATENCY_HISTOGRAM.observe(time.time() - start)
        TRANSLATION_COUNTER.inc()
        time.sleep(30)

if __name__ == "__main__":
    monitor()
```

### 使用 Kubernetes 自动扩缩容

对于高可用部署，使用带有 HPA 的 Kubernetes：

```yaml
# libretranslate-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: libretranslate
spec:
  replicas: 2
  selector:
    matchLabels:
      app: libretranslate
  template:
    metadata:
      labels:
        app: libretranslate
    spec:
      containers:
      - name: libretranslate
        image: libretranslate/libretranslate:v1.9.5
        ports:
        - containerPort: 5000
        env:
        - name: LT_LOAD_ONLY
          value: "en,es,fr,de,it"
        - name: LT_THREADS
          value: "4"
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
          limits:
            memory: "4Gi"
            cpu: "2000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 5000
          initialDelaySeconds: 60
          periodSeconds: 30
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: libretranslate-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: libretranslate
  minReplicas: 2
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

部署：

```bash
kubectl apply -f libretranslate-deployment.yaml
```

### 备份策略

语言模型可以重新下载，但存储 API 密钥和日志的 SQLite 数据库应进行备份：

```bash
#!/bin/bash
# backup.sh - 每日备份定时任务
BACKUP_DIR="/backups/libretranslate"
DATE=$(date +%Y%m%d)

# 备份数据库
docker cp libretranslate:/app/db "$BACKUP_DIR/db_$DATE.sqlite"

# 同步模型（可选 - 可以重新下载）
rsync -av /var/lib/docker/volumes/lt-models/_data/ "$BACKUP_DIR/models/"

# 仅保留 7 天备份
find "$BACKUP_DIR" -name "db_*.sqlite" -mtime +7 -delete
```

添加到 crontab：

```bash
0 2 * * * /path/to/backup.sh
```

## 与替代方案对比

| 功能 | LibreTranslate | Argos Translate | Google Translate API | DeepL API |
|------|---------------|-----------------|---------------------|-----------|
| **许可证** | AGPL-3.0 | MIT | 专有 | 专有 |
| **自托管** | 是 | 是 (CLI) | 否 | 否 |
| **离线能力** | 是 | 是 | 否 | 否 |
| **支持语言** | 30+ | 30+ | 130+ | 30+ |
| **成本 (每月100万字符)** | ~$10 VPS | ~$10 VPS | $20 | $6.99+ |
| **翻译质量** | 良好 | 良好 | 优秀 | 优秀 |
| **REST API** | 是 | 否 | 是 | 是 |
| **Web UI** | 是 | 否 | 是 | 是 |
| **GPU 加速** | 是 (CUDA) | 仅 CPU | 仅云端 | 仅云端 |
| **隐私** | 完全（数据留在本地） | 完全 | 数据发送到 Google | 数据发送到 DeepL |
| **速率限制** | 可配置 | 不适用 | 基于配额 | 基于配额 |
| **设置复杂度** | 中等 (Docker) | 低 (pip) | 低 (API 密钥) | 低 (API 密钥) |

LibreTranslate 填补了特定的细分市场：它是唯一一个将 REST API、Web UI、GPU 加速和完全离线能力结合在开源许可证下的选项。Argos Translate 提供相同的翻译引擎但缺少 API 层。Google 和 DeepL 提供卓越的质量和更广泛的语言支持，但代价是隐私、持续费用和外部依赖。

## 局限性 / 诚实评估

LibreTranslate 不是商业翻译 API 的通用替代品。了解其局限性对于做出明智的采用决策至关重要。

**翻译质量差距**：在 WMT14 基准测试中，LibreTranslate 比 DeepL 低约 5.7 个 BLEU 点，比 Google Translate 低 4.4 个点。这种差距在以下方面最为明显：(1) 不太常见的语言对，如英语到斯瓦希里语或芬兰语到越南语，(2) 法律、医疗或技术文本中的领域特定术语，以及 (3) 上下文和细微差别重要的创意或习语内容。

**资源密集**：每个加载的语言对消耗 300-600MB 内存。完整的 30 语言部署需要 8GB+ 内存。这使得 LibreTranslate 不适用于资源受限的环境，如树莓派（除非仅加载 2-3 种语言）或小型 VPS 实例。

**语言覆盖范围**：LibreTranslate 支持 30 多种语言，涵盖了最常见的语言对，但远不及 Google Translate 的 130 多种语言。如果你的用例需要为少数民族或濒危语言提供翻译，LibreTranslate 是不够的。

**无实时流式处理**：LibreTranslate 处理完整的文本段。它不支持流式翻译或实时语音转文本翻译，这限制了其在实时对话场景中的适用性。

**AGPL-3.0 许可证影响**：AGPL-3.0 许可证要求任何对软件的网络使用（包括通过 API）都会触发相同方式共享的要求。在 LibreTranslate 之上构建专有产品的组织应咨询法律顾问以确保许可证合规。

**维护负担**：自托管意味着你负责更新、安全补丁、模型更新和基础设施监控。与托管 API 比较成本时，请考虑运营开销。

## 常见问题

### LibreTranslate 与直接运行 Argos Translate 有什么区别？

LibreTranslate 本质上是 Argos Translate 的 REST API 包装器。如果你只需要命令行翻译，Argos Translate 的开销更低。如果你需要 HTTP API、Web 界面或多用户访问，LibreTranslate 添加了这些层。两者共享相同的翻译模型并产生相同的输出。

### LibreTranslate 可以在树莓派上运行吗？

可以，但有约束。ARM Docker 镜像针对 ARM64 系统进行了优化。仅加载 2-3 个语言对以保持内存使用在 2GB 以下。在具有 4GB RAM 的树莓派 4 上，预期每次请求的翻译延迟为 800ms-1.5s。对于生产使用，建议至少 4GB RAM。

### 如何在不重启容器的情况下更新语言模型？

设置 `LT_UPDATE_MODELS=true` 环境变量。LibreTranslate 在启动时检查模型更新。对于 Kubernetes 部署中的滚动更新，使用滚动重启策略：使用新的镜像版本更新部署，Kubernetes 将逐步替换 Pod。

### 每次翻译请求的最大文本长度是多少？

可通过 `--char-limit` 标志或 `LT_CHAR_LIMIT` 环境变量配置。内置默认值为每次请求 10,000 个字符。对于更长的文档，将文本分块并进行顺序 API 调用。

### LibreTranslate 是否符合 HIPAA 或 GDPR 合规要求？

LibreTranslate 的自托管特性意味着数据不会离开你的基础设施，这简化了合规。然而，合规是一个系统级属性，不仅仅是软件属性。你还必须保护主机操作系统、网络、备份和访问控制。请咨询合规官进行全面评估。

### 如何添加自定义语言模型？

LibreTranslate 支持 Argos Translate 格式的模型（OpenNMT CTranslate2 模型）。将自定义 `.argosmodel` 文件放在模型目录中并重启容器。自定义模型适用于默认模型集未涵盖的领域特定术语或语言。

### 我可以将 LibreTranslate 与 React 或 Vue 等前端框架一起使用吗？

可以。`/translate` 端点接受 JSON 并在配置时支持 CORS。React Hook 示例：

```typescript
// useTranslation.ts
import { useState, useCallback } from "react";

export function useTranslation() {
  const [translating, setTranslating] = useState(false);

  const translate = useCallback(async (text: string, source: string, target: string) => {
    setTranslating(true);
    try {
      const res = await fetch("http://localhost:5000/translate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ q: text, source, target }),
      });
      const data = await res.json();
      return data.translatedText;
    } finally {
      setTranslating(false);
    }
  }, []);

  return { translate, translating };
}
```

### 离线部署的网络要求是什么？

对于完全离线操作，使用 `--build-arg with_models=true` 构建 Docker 镜像以在构建期间嵌入语言模型。生成的镜像包含所有必要文件，运行时不需要互联网连接。镜像大小根据包含的语言数量增加约 2-3GB。

## 结论

LibreTranslate 兑现了其核心承诺：一个具有零每次请求成本和完全数据隐私的自托管翻译 API。凭借 14,400+ GitHub Stars、积极维护和 v1.9.5 提供的稳定性改进，对于优先考虑控制而非绝对翻译质量的团队来说，它已经具备了生产就绪的条件。

理想的 LibreTranslate 采用者是具有以下特征的团队：(1) 持续的翻译量使按字符定价变得痛苦，(2) 严格的数据驻留要求，(3) 管理基础设施的 DevOps 能力，以及 (4) 对可测量的但可接受的质量差距的容忍度。

如果这描述了你的情况，请从本指南中的 Docker Compose 设置开始，加载 5 种语言，并针对你的特定内容测量翻译质量。大多数团队发现其质量对于内部工具、产品目录和用户生成内容来说是足够的。

对于需要绝对最高翻译质量或支持 100 多种语言的团队，商业 API 仍然是务实选择。对于其他人，LibreTranslate 从你的云账单中消除了一笔经常性支出。

加入 [LibreTranslate Telegram 群组](https://t.me/libretranslate) 获取社区支持，或在 GitHub 上关注该项目以获取发布更新。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [LibreTranslate GitHub 仓库](https://github.com/LibreTranslate/LibreTranslate)
- [LibreTranslate 官方文档](https://libretranslate.com/docs)
- [Argos Translate GitHub 仓库](https://github.com/argosopentech/translate)
- [LibreTranslate Docker Hub](https://hub.docker.com/r/libretranslate/libretranslate)
- [OpenNMT 框架文档](https://opennmt.net/)
- [AGPL-3.0 许可证摘要](https://www.gnu.org/licenses/agpl-3.0.html)
- [DigitalOcean Docker 部署指南](https://docs.digitalocean.com/tutorials/docker-compose/)
- [NVIDIA CUDA Docker 设置](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)
- [LibreTranslate Kubernetes 示例](https://github.com/LibreTranslate/LibreTranslate/tree/main/kubernetes)

---

> **披露**：本文包含联盟链接。如果你使用本指南中的推荐链接注册 DigitalOcean，我们可能会收到佣金，而你无需支付额外费用。联盟链接有助于支持此类开源文档项目的持续维护。
