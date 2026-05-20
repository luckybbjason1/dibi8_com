---
title: 'Ollama: 137K+ Stars — 一条命令本地运行大模型，2026 完整配置指南'
description: 'Ollama 是在本地运行 Llama、DeepSeek、Mistral 等 LLM 的最简单方式。兼容 LangChain、OpenWebUI、Continue.dev 和 Dify。涵盖 Docker 部署、Modelfile 自定义、REST API、生产加固和性能基准测试。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/ollama/ollama'
stars: 137000
maintainer: 'ollama'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['ollama', '本地大模型', 'llama.cpp', 'deepseek', 'mistral', 'docker', 'modelfile', '开源']
aliases:
- /zh/posts/ollama/
- /zh/resources/llm-frameworks/ollama-local-llm-guide/
---

{{</* resource-info */>}}

运行大语言模型过去意味着与 Python 环境、CUDA 驱动和数 GB 的依赖项搏斗。到了 2026 年，这种摩擦已经消失。[Ollama](https://ollama.com) 让你可以用一条命令拉取、配置并提供生产级 LLM —— 无需安装 PyTorch，无需手动调整 GPU，甚至不需要 Docker。凭借 137,000+ GitHub Stars 和繁荣的集成生态，Ollama 已成为开发者在本地运行推理而不想承受运维负担的默认运行时。

本指南将完整 walkthrough Ollama 的配置流程：安装、Docker 部署、Modelfile 自定义、与流行框架的 API 集成、生产加固、以及与替代方案的诚实基准对比。无论你是在构建编程助手、RAG 流水线，还是自托管的 ChatGPT 替代品，本教程都能让你在五分钟内从零开始运行模型。

![Ollama 本地运行](https://ollama.com/public/assets/case.png)

*本 Ollama 教程涵盖从安装到生产部署的完整设置指南。*

## Ollama 是什么？

**Ollama** 是一个在本地运行大语言模型的开源运行时。它将推理引擎（CPU/GPU 用 llama.cpp、Apple Silicon 用 MLX、AMD 用 ROCm）包装在简单的 CLI 和 REST API 之后，让开发者可以专注于构建应用，而不是管理模型权重、量化格式和硬件加速。把它想象成 LLM 界的 Docker：拉取模型，运行，搞定。

Ollama 由 Jeffrey Morgan 和团队在 2023 年创建，截至 2026 年中已在 GitHub 上获得 137,000+ Stars。它支持数百种模型，包括 Llama 3、DeepSeek R1、Mistral、Qwen、Gemma 和 CodeLlama —— 全部可通过 [Ollama 模型库](https://ollama.com/search) 获取。

![Ollama 官方 Logo](https://raw.githubusercontent.com/ollama/ollama/main/docs/ollama.png)

## Ollama 的工作原理

Ollama 的架构采用客户端-服务器模式。后台守护进程 (`ollama serve`) 管理模型下载、内存分配和推理。CLI 和 REST API 是通过 HTTP 端口 11434 与该守护进程通信的轻量级客户端。

### 核心架构

```
┌─────────────┐     ┌──────────────┐     ┌─────────────────┐
│   客户端     │────▶│ ollama serve │────▶│  llama.cpp/MLX  │
│  (CLI/API)  │     │   (端口      │     │  (推理后端)      │
│             │◄────│   11434)     │◄────│                 │
└─────────────┘     └──────────────┘     └─────────────────┘
                           │
                    ┌──────┴──────┐
                    │  ~/.ollama/ │
                    │  (模型,      │
                    │   数据块)    │
                    └─────────────┘
```

**关键组件：**

- **模型中心 (Model Hub)**：从 `ollama.com` 拉取的精选 GGUF 模型。每个模型通过 `name:tag` 标识（例如 `llama3.2:8b`）。
- **Modelfile**：声明式配置（类似 Dockerfile），指定基础模型、系统提示词、参数和聊天模板。
- **推理后端**：根据可用硬件自动选择 llama.cpp（CUDA/ROCm/CPU）、MLX（Apple Silicon）或 Metal。
- **REST API**：兼容 OpenAI 的端点，包括 `/api/generate`、`/api/chat`、`/api/embed` 和 `/v1/chat/completions`。

### 模型存储

模型以内容寻址的数据块（SHA-256 摘要）形式存储在 `~/.ollama/models/` 中。清单文件跟踪哪些数据块属于哪个模型标签。这种去重意味着两个共享相同基础权重的模型在磁盘上只存储一份副本。

## 安装与配置

### macOS

```bash
# 使用 Homebrew（推荐）
brew install ollama

# 或从 ollama.com/download 下载原生应用
```

### Linux（一行命令安装）

```bash
curl -fsSL https://ollama.com/install.sh | sh
```

这会安装二进制文件、注册 systemd 服务，并自动检测 GPU 能力（NVIDIA CUDA、AMD ROCm 或仅 CPU）。

### Windows

从 [ollama.com/download](https://ollama.com/download) 下载安装程序。推荐使用带 WSL2 的 Windows 11/12 以获得完整兼容性。

### 验证安装

```bash
ollama --version
# ollama version 0.6.7

# 启动守护进程（如果尚未运行）
ollama serve

# 拉取并运行你的第一个模型
ollama run llama3.2:8b
```

第一次运行模型时，Ollama 会下载它。像 `llama3.2:8b` 这样的 8B 参数量化模型需要约 4.9 GB 磁盘空间，在 8 GB VRAM 上可流畅运行。

### 按硬件快速选择模型

| 硬件配置 | 推荐模型 | 命令 |
|----------|----------|------|
| 6–8 GB VRAM | Qwen3 8B | `ollama run qwen3:8b` |
| 10–12 GB VRAM | Llama 3.1 8B Q4 | `ollama run llama3.1:8b` |
| 16+ GB VRAM | DeepSeek-R1 14B | `ollama run deepseek-r1:14b` |
| 仅 CPU, 16 GB RAM | Phi-4 Mini 3.8B | `ollama run phi4-mini` |
| Apple M3/M4 36 GB | Llama 3.1 70B Q4 | `ollama run llama3.1:70b` |

## 与流行工具集成

### Open WebUI（类 ChatGPT 界面）

[Open WebUI](https://github.com/open-webui/open-webui) 是 Ollama 最流行的前端，提供类 ChatGPT 的网页界面，支持 RAG、语音输入和多用户。

```bash
# 使用 Docker 运行 Open WebUI
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main
```

在 `http://localhost:3000` 访问。Open WebUI 会自动发现你在 `http://host.docker.internal:11434` 的 Ollama 实例。

### LangChain（Python）

```python
# 安装
pip install langchain-ollama

# 聊天模型
from langchain_ollama import ChatOllama

llm = ChatOllama(
    model="llama3.2:8b",
    temperature=0.7,
    base_url="http://localhost:11434"
)

response = llm.invoke("用一段话解释量子计算。")
print(response.content)

# 嵌入向量
from langchain_ollama import OllamaEmbeddings

embeddings = OllamaEmbeddings(model="nomic-embed-text")
vector = embeddings.embed_query("Hello world")
# 返回 768 维浮点向量
```

### Continue.dev（VS Code/Cursor AI 编程助手）

添加到 `~/.continue/config.json`：

```json
{
  "models": [
    {
      "title": "Llama 3.2",
      "provider": "ollama",
      "model": "llama3.2:8b",
      "apiBase": "http://localhost:11434"
    }
  ],
  "tabAutocompleteModel": {
    "title": "CodeQwen",
    "provider": "ollama",
    "model": "codeqwen:7b-code"
  }
}
```

### Dify（自托管 AI 工作流平台）

在 Dify 的 **设置 > 模型提供商 > Ollama** 中配置：

```
模型名称: llama3.2:8b
基础 URL: http://host.docker.internal:11434
上下文窗口: 8192
```

### cURL / REST API 直接使用

```bash
# 生成文本
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2:8b",
  "prompt": "天空为什么是蓝色的？",
  "stream": false
}'

# 聊天补全（兼容 OpenAI）
curl http://localhost:11434/v1/chat/completions -H "Content-Type: application/json" -d '{
  "model": "llama3.2:8b",
  "messages": [{"role": "user", "content": "你好！"}],
  "temperature": 0.7
}'

# 生成嵌入向量
curl http://localhost:11434/api/embed -d '{
  "model": "nomic-embed-text",
  "input": ["天空是蓝色的", "草地是绿色的"]
}'
```

## Docker 生产环境部署

![Ollama Docker 部署](https://raw.githubusercontent.com/ollama/ollama/main/docs/images/logo.png)

### 基础 Docker Compose

```yaml
# docker-compose.yml
version: "3.8"

services:
  ollama:
    image: ollama/ollama:0.6.7
    container_name: ollama
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    environment:
      - OLLAMA_KEEP_ALIVE=24h
      - OLLAMA_NUM_PARALLEL=4
      - OLLAMA_MAX_LOADED_MODELS=2
    restart: unless-stopped
    # NVIDIA GPU 支持
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]

  open-webui:
    image: ghcr.io/open-webui/open-webui:main
    container_name: open-webui
    ports:
      - "3000:8080"
    environment:
      - OLLAMA_BASE_URL=http://ollama:11434
    volumes:
      - openwebui_data:/app/backend/data
    depends_on:
      - ollama
    restart: unless-stopped

volumes:
  ollama_data:
  openwebui_data:
```

使用 `docker compose up -d` 启动。

### NVIDIA GPU 配置

```bash
# 安装 NVIDIA Container Toolkit
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey \
  | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg

curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list \
  | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' \
  | sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

sudo apt-get update
sudo apt-get install -y nvidia-container-toolkit
sudo nvidia-ctk runtime configure --runtime=docker
sudo systemctl restart docker
```

### AMD ROCm GPU 配置

使用 ROCm 专用镜像标签：

```yaml
services:
  ollama:
    image: ollama/ollama:rocm
    devices:
      - /dev/kfd
      - /dev/dri
    group_add:
      - video
    environment:
      - HSA_OVERRIDE_GFX_VERSION=11.0.0
```

### 多模型并发服务

```yaml
services:
  ollama:
    image: ollama/ollama:0.6.7
    environment:
      - OLLAMA_NUM_PARALLEL=4      # 4 个并发请求
      - OLLAMA_MAX_LOADED_MODELS=2  # VRAM 中保持 2 个模型
      - OLLAMA_KEEP_ALIVE=30m      # 空闲 30 分钟后卸载
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: all
              capabilities: [gpu]
```

## Modelfile：自定义模型行为

Modelfile 是 Ollama 的声明式配置格式。它定义了模型的行为方式：系统提示词、采样参数、上下文窗口和聊天模板。

### 基础 Modelfile 示例

```dockerfile
# Modelfile
FROM llama3.2:8b

# 系统提示词定义人格
SYSTEM """你是一位资深软件工程师。回答要简洁、实用，
并且始终包含可运行的代码示例。"""

# 参数调优
PARAMETER temperature 0.3
PARAMETER num_ctx 16384
PARAMETER top_p 0.9
PARAMETER repeat_penalty 1.1
PARAMETER stop "<|eot_id|>"

# 自定义模板（可选 —— 省略则继承基础模型）
TEMPLATE """{{ if .System }}<|start_header_id|>system<|end_header_id|>

{{ .System }}<|eot_id|>{{ end }}{{ if .Prompt }}<|start_header_id|>user<|end_header_id|>

{{ .Prompt }}<|eot_id|>{{ end }}<|start_header_id|>assistant<|end_header_id|>

{{ .Response }}<|eot_id|>"""
```

构建并运行：

```bash
# 创建自定义模型
ollama create senior-dev -f Modelfile

# 运行
ollama run senior-dev

# 查看生效的 Modelfile
ollama show senior-dev --modelfile
```

### 高级：代码审查助手

```dockerfile
# Modelfile.code-review
FROM codellama:7b-code

SYSTEM """你是一个代码审查助手。分析提供的代码，检查：
1. Bug 和逻辑错误
2. 安全漏洞（SQL 注入、XSS、缓冲区溢出）
3. 性能问题（N+1 查询、不必要的内存分配）
4. 风格和可读性

按以下格式回复：
- [CRITICAL] 用于 Bug/安全问题
- [WARN] 用于性能问题
- [INFO] 用于风格建议

始终为 [CRITICAL] 和 [WARN] 项提供修复建议。"""

PARAMETER temperature 0.1
PARAMETER num_ctx 8192
PARAMETER num_predict 2048
```

```bash
ollama create code-reviewer -f Modelfile.code-review
```

### 从本地 GGUF 文件创建

```dockerfile
# Modelfile.local
FROM ./my-fine-tuned-model-q4_k_m.gguf

PARAMETER temperature 0.7
PARAMETER num_ctx 4096

SYSTEM "你是一个专注于医学术语的有用助手。"
```

```bash
ollama create med-assistant -f Modelfile.local
```

### 查看现有模型

```bash
# 显示模型详情和 Modelfile
ollama show llama3.2:8b --modelfile

# 仅显示参数
ollama show llama3.2:8b --parameters

# 显示系统提示词
ollama show llama3.2:8b --system

# 列出所有本地模型
ollama list

# 显示运行中的模型
ollama ps
```

## 基准测试 / 实际用例

### 单用户吞吐量（RTX 4090, Llama 3.1 8B）

| 工具 | 格式 | tok/s | 配置时间 |
|------|------|-------|----------|
| Ollama | Q4_K_M | ~62 tok/s | < 2 分钟 |
| vLLM | FP16 | ~71 tok/s | ~10 分钟 |
| llama.cpp (CLI) | Q4_K_M | ~65 tok/s | ~5 分钟 |
| LocalAI | Q4_K_M | ~38 tok/s | ~15 分钟 |

*来源：SitePoint 基准测试，2026 年 3 月。单流生成，256 token 输出。*

### 并发负载（50 用户，RTX 4090）

| 工具 | 总 tok/s | p99 延迟 | 架构 |
|------|----------|----------|------|
| Ollama | ~155 tok/s | ~24.7秒 | FIFO 队列 |
| vLLM | ~920 tok/s | ~2.8秒 | 连续批处理 |
| llama.cpp server | ~140 tok/s | ~26秒 | FIFO 队列 |
| LocalAI | ~130 tok/s | ~28秒 | FIFO 队列 |

*Ollama 按顺序处理请求；vLLM 的连续批处理在并发下提供 6 倍吞吐量。单用户开发场景下差距仅约 13%。*

### 内存占用（7B 参数模型）

| 工具 | 空闲 RAM | 加载后 RAM | 冷启动 |
|------|----------|-----------|--------|
| Ollama | 150 MB | 5.2 GB | 2秒 |
| vLLM | 400 MB | 5.5 GB | 5秒 |
| LocalAI | 400 MB | 5.5 GB | 8秒 |
| LM Studio | 800 MB | 5.8 GB | 5秒 |

### 实际部署模式

1. **个人开发者**：Ollama + Continue.dev 用于 AI 辅助编程。自动补全延迟 < 50ms。
2. **小团队（5–10 人）**：共享 GPU 工作站上的 Ollama + Open WebUI。每小时可舒适处理约 50 个请求。
3. **边缘/Raspberry Pi 5**：仅 CPU 的 Ollama + Phi-4 Mini (3.8B)。约 8 tok/s，完全离线运行。
4. **CI/CD 流水线**：Docker 中的 Ollama 用于自动代码审查。拉取 `code-reviewer` 模型，通过 API 处理 PR diff。

## 高级用法 / 生产环境加固

### 环境变量

```bash
# 核心设置
OLLAMA_HOST=0.0.0.0:11434          # 绑定到所有接口
OLLAMA_KEEP_ALIVE=24h               # 模型保持加载 24 小时
OLLAMA_NUM_PARALLEL=4               # 最大并发请求数
OLLAMA_MAX_LOADED_MODELS=2          # VRAM 中同时加载的最大模型数
OLLAMA_FLASH_ATTENTION=1            # 启用 Flash Attention（更快推理）

# 性能调优
OLLAMA_GPU_OVERHEAD=200MB           # 预留 VRAM 余量
OLLAMA_DEBUG=1                      # 详细日志
```

### Nginx 反向代理

```nginx
server {
    listen 443 ssl http2;
    server_name ollama.yourdomain.com;

    ssl_certificate /etc/letsencrypt/live/ollama.yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/ollama.yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://localhost:11434;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # 流式传输的 WebSocket 支持
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        
        # 长时间推理的超时设置
        proxy_read_timeout 600s;
        proxy_send_timeout 600s;
    }
}
```

### API 密钥认证（无原生支持）

Ollama 不包含内置的 API 密钥认证。通过反向代理添加：

```python
# ollama-auth-proxy.py（Flask 示例）
from flask import Flask, request, Response
import requests

app = Flask(__name__)
OLLAMA_URL = "http://localhost:11434"
VALID_KEYS = {"sk-your-api-key-here"}

@app.route('/', defaults={'path': ''}, methods=['GET', 'POST', 'PUT', 'DELETE'])
@app.route('/<path:path>', methods=['GET', 'POST', 'PUT', 'DELETE'])
def proxy(path):
    api_key = request.headers.get('Authorization', '').replace('Bearer ', '')
    if api_key not in VALID_KEYS:
        return {"error": "无效的 API 密钥"}, 401
    
    resp = requests.request(
        method=request.method,
        url=f"{OLLAMA_URL}/{path}",
        headers={k: v for k, v in request.headers if k != 'Host'},
        data=request.get_data(),
        stream=True
    )
    return Response(resp.iter_content(chunk_size=1024), status=resp.status_code,
                   content_type=resp.headers.get('Content-Type'))

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=11435)
```

### 使用 Prometheus 监控

Ollama 通过 API 暴露基本指标：

```bash
# 列出运行中的模型及其内存使用情况
curl http://localhost:11434/api/ps
```

对于生产监控，使用 Prometheus 导出器包装 `api/ps` 端点，或使用内置指标的 [ollamaMQ](https://github.com/Chleba/ollamaMQ) 代理。

### Systemd 服务（Linux）

```ini
# /etc/systemd/system/ollama.service
[Unit]
Description=Ollama LLM 服务
After=network-online.target

[Service]
ExecStart=/usr/local/bin/ollama serve
User=ollama
Group=ollama
Restart=always
RestartSec=3
Environment="OLLAMA_HOST=0.0.0.0:11434"
Environment="OLLAMA_NUM_PARALLEL=4"
Environment="OLLAMA_KEEP_ALIVE=24h"

[Install]
WantedBy=default.target
```

```bash
sudo systemctl daemon-reload
sudo systemctl enable ollama
sudo systemctl start ollama
```

## 与替代方案对比

| 功能 | Ollama | llama.cpp | vLLM | LocalAI |
|------|--------|-----------|------|---------|
| **GitHub Stars** | 137K+ | 75K+ | 45K+ | 35K+ |
| **配置时间** | < 2 分钟 | ~5 分钟 | ~10 分钟 | ~15 分钟 |
| **单用户 tok/s** | ~62 (Q4) | ~65 (Q4) | ~71 (FP16) | ~38 (Q4) |
| **多用户批处理** | FIFO 队列 | FIFO 队列 | 连续批处理 | FIFO 队列 |
| **50 用户总吞吐** | ~155 tok/s | ~140 tok/s | ~920 tok/s | ~130 tok/s |
| **Apple Silicon** | 原生 (MLX) | 原生 | 不支持 | 通过 Docker |
| **Modelfile/Dockerfile** | 支持 | 不支持 | 不支持 | 不支持 |
| **兼容 OpenAI API** | 部分兼容 | 不兼容 | 完全兼容 | 完全兼容 |
| **嵌入向量 API** | 支持 | 不支持 | 支持 | 支持 |
| **图像生成** | 不支持 | 不支持 | 不支持 | 支持 (Stable Diffusion) |
| **适用场景** | 开发/原型 | 高级用户 | 生产服务 | 多模态 API |

*基准测试：RTX 4090 上的 Llama 3.1 8B，2026 年 3 月。来源：SitePoint、TowardsAI、LocalAI Master。*

### 选择建议

- **Ollama**：从这里开始。最佳开发者体验、最快配置、出色的单用户性能。适用于本地开发、小团队部署和边缘设备。
- **llama.cpp**：需要完全控制推理参数、自定义内核或低级优化时选择。适合从源码编译的嵌入式系统。
- **vLLM**：服务 5+ 并发用户且有 SLA 要求时选择。连续批处理和 PagedAttention 提供 Ollama 无法匹敌的生产级吞吐量。
- **LocalAI**：需要支持图像生成（Stable Diffusion）、语音转文字（Whisper）和完整 API 兼容性的 OpenAI 替代方案时选择。

## 局限性 / 诚实评估

**无内置认证。** Ollama 假设处于受信任的本地网络中。面向互联网的部署必须添加认证层（反向代理、API 网关或 VPN）。这是最常见的生产环境疏忽。

**无连续批处理。** 在并发负载下，Ollama 按顺序处理请求。50 个并发用户时，p99 延迟达到约 25 秒，而 vLLM 约为 3 秒。未经负载测试，不要将 Ollama 用作多用户生产服务器。

**仅支持 GGUF 格式。** Ollama 只支持 GGUF 量化模型。如果需要 FP16 推理、AWQ 或 GPTQ 格式，请直接使用 vLLM 或 Transformers。

**无内置模型量化。** 无法在 Ollama 内量化模型。需要在外部将模型转换为 GGUF 格式（使用 `llama.cpp/convert_hf_to_gguf.py` 等），然后通过 `ollama create` 导入。

**内存管理是静态的。** `OLLAMA_MAX_LOADED_MODELS` 控制常驻模型数量，但没有动态 VRAM 平衡。在 12 GB GPU 上加载 70B 模型（即使是 Q4）会导致 OOM —— Ollama 不会自动将层卸载到 CPU。

**工具调用支持有限。** 虽然兼容模型（Llama 3.1+、Mistral）支持工具调用，但实现不如 OpenAI 的函数调用稳健。复杂的多步工具工作流可能需要降级处理。

## 常见问题

**Q: 运行 7B 参数模型需要多少 VRAM？**
A: Q4_K_M 量化的 7B 模型约需 4.5–5 GB VRAM。Q8 量化请预留 7–8 GB。仅 CPU 推理在 16 GB 系统内存下可以工作，但 token 生成速度约慢 3–5 倍。

**Q: 没有 GPU 可以运行 Ollama 吗？**
A: 可以。Ollama 会通过 llama.cpp 自动回退到 CPU 推理。性能取决于 CPU：Intel i7-13700K 使用 7B Q4 模型可达约 8–12 tok/s。Apple Silicon M3 Pro 在 CPU/神经引擎上可达约 25 tok/s。

**Q: 如何将 Ollama 更新到最新版本？**
A: macOS 上运行 `brew upgrade ollama`。Linux 上重新运行安装脚本：`curl -fsSL https://ollama.com/install.sh | sh`。该脚本会保留你在 `~/.ollama/models/` 中已下载的模型。

**Q: Ollama 适合生产环境使用吗？**
A: 对于单一用途的部署（一个模型、一个用户、可预测的负载），是的。对于多用户生产服务，考虑添加队列代理或切换到 vLLM。面向网络暴露前务必添加认证和监控。

**Q: 可以在 Ollama 中使用自己微调过的模型吗？**
A: 可以。将模型转换为 GGUF 格式，然后创建指向它的 Modelfile，使用 `FROM ./your-model.gguf`。运行 `ollama create my-model -f Modelfile`，它就可通过标准 API 访问。

**Q: Ollama 与 OpenAI API 在输出质量方面相比如何？**
A: 对于同等基础模型（Llama 3.1 vs GPT-3.5），在编程和推理任务上输出质量具有竞争力。在创意写作和多步推理方面差距更大，GPT-4 和 Claude 3.5 Sonnet 仍然领先。本地推理消除了网络往返的延迟。

**Q: Ollama 支持用于图像分析的视觉模型吗？**
A: 支持。LLaVA 1.7、Qwen2-VL 和 InternVL2.5 等视觉模型已受支持。在聊天 API 请求中以 base64 格式传递图像数据。注意视觉模型需要更多 VRAM（额外约 2–4 GB）。

## 结论

Ollama 消除了本地 LLM 部署的摩擦。一条命令安装，一条命令拉取模型，一条命令运行。Modelfile 系统提供了可复现的模型定制。兼容 OpenAI 的 API 意味着你现有的 LangChain、Open WebUI 和 Continue.dev 集成只需更改一个 URL 即可工作。

对于个人开发者和小团队，Ollama 是务实的起点。当并发负载超过约 5 个用户时，评估 vLLM。当需要文本之外的多模态支持时，评估 LocalAI。但从 Ollama 开始 —— 137,000+ Stars 反映了一个真正兑现承诺的工具。

**下一步：**
1. 安装 Ollama：`curl -fsSL https://ollama.com/install.sh | sh`
2. 运行你的第一个模型：`ollama run llama3.2:8b`
3. 部署 Open WebUI 作为团队聊天界面
4. 加入 [dibi8 开发者 Telegram 群组](https://t.me/dibi8dev) 获取本地 LLM 部署技巧和故障排除

*本地硬件不足时，[DigitalOcean GPU Droplets](https://www.digitalocean.com) 提供与 Ollama Docker 部署配合良好的 NVIDIA A100/H100 实例。专用裸金属 GPU 服务器可考虑 [HTStack](https://htstack.com)，提供具有竞争力的 RTX 4090 和 A100 节点价格。*

*联盟营销披露：本文包含 DigitalOcean 和 HTStack 的联盟链接。如果你通过这些链接购买服务，dibi8 可能会获得佣金，不会额外增加你的费用。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- Ollama 官方文档：https://docs.ollama.com
- Ollama GitHub 仓库：https://github.com/ollama/ollama
- Ollama 模型库：https://ollama.com/search
- Ollama REST API 参考：https://docs.ollama.com/api
- Modelfile 参考文档：https://docs.ollama.com/modelfile
- SitePoint — Ollama vs vLLM 基准测试 2026：https://www.sitepoint.com/ollama-vs-vllm-performance-benchmark-2026/
- TowardsAI — Ollama vs vLLM vs llama.cpp：https://pub.towardsai.net/i-tested-ollama-vs-vllm-vs-llama-cpp-the-easiest-one-collapses-at-5-concurrent-users-d4f8e0e84886
- LocalAI Master — Ollama vs LocalAI：https://zenvanriel.com/ai-engineer-blog/ollama-vs-localai-comparison-local-model-deployment/
- Open WebUI GitHub：https://github.com/open-webui/open-webui
- LangChain Ollama 集成：https://python.langchain.com/docs/integrations/chat/ollama
- Continue.dev 文档：https://docs.continue.dev
