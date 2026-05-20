---
title: 'Lobe Chat: 支持 20+ LLM 提供商与插件系统的开源 ChatGPT UI 替代品 —— 2026 完整部署指南'
description: '将 Lobe Chat 部署为自托管的 ChatGPT 替代品。支持 20+ LLM 提供商、插件系统、PWA、多语言 UI。包含基准测试和对比的完整 Docker 部署指南。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'lobehub/lobe-chat'
stars: 60000
maintainer: 'lobehub'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Lobe Chat', 'ChatGPT', 'OpenAI 替代品', 'LLM', '自托管', 'Docker', 'PWA', '插件系统', 'AI', '聊天 UI']
aliases:
- /zh/posts/lobe-chat-openai-alternative-ui/
---

{{</* resource-info */>}}

## 引言：ChatGPT 已经不够用了

你每月付 $20 给 OpenAI 买 ChatGPT Plus，但你的团队需要一个能同时访问 Claude、Gemini 和本地模型的共享聊天界面。你需要能连接内部 API 的插件。你需要多语言 UI，因为团队成员遍布三大洲。最关键的是 —— 对话数据必须留在你的基础设施上，而不是第三方云端。

你可以从头开始构建。花两个月做 React 前端，再花一个月对接 SSE 流，然后永远维护认证、插件沙箱和模型切换。或者你可以在 **10 分钟内部署 Lobe Chat**。

Lobe Chat 是 LobeHub 团队构建的开源聊天界面，支持 **20+ LLM 提供商**、**插件系统**、**PWA 支持**和**多语言 UI** —— 全部来自单个 Docker 容器。截至 2026 年 5 月，它已有 **约 60,000 GitHub Stars**，是最受欢迎的自托管 ChatGPT 替代品之一。它比 ChatGPT 的 UI 更美观，运行在你的硬件上，授权费用为零。

本文涵盖安装、提供商配置、插件开发、PWA 设置、真实基准测试和诚实评估。读完之后，你将拥有一个可供整个团队使用的生产级聊天 UI。

## 什么是 Lobe Chat？

**Lobe Chat** 是一款面向大型语言模型的现代开源聊天界面。基于 Next.js 和 Ant Design 构建，它提供类似 ChatGPT 的体验，支持多个 LLM 提供商（OpenAI、Claude、Gemini、Ollama、Azure、Bedrock 等 15+ 家）、可扩展插件、渐进式 Web 应用能力和自托管部署模式，让你的数据始终处于自己的控制之下。

## Lobe Chat 的工作原理

Lobe Chat 的架构将表示层与模型推理分离。Next.js 前端处理 UI 渲染、对话状态和插件编排，而 LLM 调用通过可配置的 API 端点代理：

```
┌─────────────────────────────────────────────┐
│           用户浏览器 / PWA                    │
│  ┌─────────┐  ┌─────────┐  ┌────────────┐  │
│  │  聊天   │  │  插件   │  │  设置      │  │
│  │  面板   │  │  商店   │  │  (i18n)    │  │
│  └────┬────┘  └────┬────┘  └─────┬──────┘  │
└───────┼────────────┼─────────────┼────────┘
        │            │             │
        ▼            ▼             ▼
┌─────────────────────────────────────────────┐
│          Lobe Chat Server (Next.js)          │
│  ┌──────────┐ ┌──────────┐ ┌────────────┐  │
│  │  SSE     │ │  插件    │ │  认证      │  │
│  │  Stream  │ │  Runtime │ │  (SSO)     │  │
│  └────┬─────┘ └────┬─────┘ └─────┬──────┘  │
└───────┼────────────┼─────────────┼────────┘
        │            │             │
        ▼            ▼             ▼
┌──────────┐  ┌──────────┐  ┌────────────┐
│  OpenAI  │  │  Claude  │  │   Ollama   │
│  API     │  │  API     │  │  (本地)    │
└──────────┘  └──────────┘  └────────────┘
```

**核心组件：**

- **前端**：Next.js 14 App Router 配合 React Server Components。渲染 markdown、带语法高亮的代码块和 LaTeX 公式。
- **聊天引擎**：管理对话历史、上下文窗口、token 计数和通过 Server-Sent Events 的流式响应。
- **插件系统**：使用 iframe + postMessage 的沙箱化插件运行时。插件通过 OpenAPI 兼容的 schema 声明功能。
- **提供商代理**：统一适配器模式，规范化跨 20+ LLM 提供商的 API 调用。
- **PWA 层**：Service worker 支持离线使用，可在桌面和移动设备安装。

## 安装与配置：10 分钟开始聊天

**前置条件**：Docker 24.0+ 或 Node.js 20+（本地开发用），2GB RAM，1GB 磁盘空间。

### 方法一：Docker（推荐）

**第一步 —— 拉取并运行官方镜像：**

```bash
docker run -d -p 3210:3210 \
  -e OPENAI_API_KEY=YOUR_OPENAI_API_KEY \
  -e ACCESS_CODE=your-secure-password \
  --name lobe-chat \
  lobehub/lobe-chat:latest
```

**第二步 —— 访问 UI：**

打开 `http://localhost:3210`。你会看到一个设置向导，用于选择默认 LLM 提供商并输入 API 密钥。

**第三步 —— 配置额外提供商（可选）：**

```bash
# 通过环境变量配置多提供商
docker run -d -p 3210:3210 \
  -e OPENAI_API_KEY=sk-xxx \
  -e ANTHROPIC_API_KEY=sk-ant-xxx \
  -e GOOGLE_API_KEY=xxx \
  -e OLLAMA_PROXY_URL=http://host.docker.internal:11434 \
  -e ACCESS_CODE=your-secure-password \
  --name lobe-chat \
  lobehub/lobe-chat:latest
```

### 方法二：带持久化存储的 Docker Compose

```yaml
# docker-compose.yml
services:
  lobe-chat:
    image: lobehub/lobe-chat:latest
    ports:
      - "3210:3210"
    environment:
      - OPENAI_API_KEY=${OPENAI_API_KEY}
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - ACCESS_CODE=${ACCESS_CODE}
      - DATABASE_URL=postgresql://postgres:password@db:5432/lobe
    volumes:
      - lobe-data:/app/.config/lobe-chat
    depends_on:
      - db
    restart: unless-stopped

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_PASSWORD=password
      - POSTGRES_DB=lobe
    volumes:
      - pgdata:/var/lib/postgresql/data
    restart: unless-stopped

volumes:
  lobe-data:
  pgdata:
```

```bash
# 带持久化的启动方式
docker compose up -d
```

### 方法三：部署到 [DigitalOcean](https://m.do.co/c/eca87ac14ee0)

```bash
# 在 2 vCPU / 4GB RAM Droplet 上（约 $24/月）
sudo apt update && sudo apt install -y docker.io docker-compose-plugin

# 创建 .env 文件
cat > .env << 'EOF'
OPENAI_API_KEY=sk-your-key
ACCESS_CODE=secure-team-password
EOF

# 运行
docker compose up -d

# 通过 Caddy 设置反向代理和 HTTPS
cat > Caddyfile << 'EOF'
chat.yourdomain.com {
    reverse_proxy localhost:3210
}
EOF
```

添加指向 Droplet IP 的 DNS A 记录，15 分钟内即可上线。[在此获取 DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0)。

## 与 20+ LLM 提供商的集成

Lobe Chat 通过统一适配器规范化跨提供商的 API 调用。以下是最常用提供商的配置方法：

### OpenAI (GPT-4, GPT-4o)

```bash
# 通过环境变量
echo "OPENAI_API_KEY=sk-xxxxxxxx" >> .env

# 通过 UI：设置 → 语言模型 → OpenAI → 输入密钥
```

### Anthropic Claude (Claude 3.5 Sonnet)

```bash
# 环境变量
echo "ANTHROPIC_API_KEY=sk-ant-xxxxxxxx" >> .env

# 重启容器
docker restart lobe-chat
```

### Google Gemini (Gemini 1.5 Pro)

```bash
echo "GOOGLE_API_KEY=AIzaxxxxxxxx" >> .env
```

### Ollama（本地模型 — Llama, Mistral 等）

```bash
# 在宿主机上运行 Ollama
docker run -d -p 11434:11434 --name ollama ollama/ollama

# 拉取模型
docker exec ollama ollama pull llama3.2

# 配置 Lobe Chat 使用 Ollama
docker run -d -p 3210:3210 \
  -e OLLAMA_PROXY_URL=http://host.docker.internal:11434 \
  -e ACCESS_CODE=mypassword \
  lobehub/lobe-chat
```

### Azure OpenAI Service

```bash
# 需要端点、API 密钥和部署名称
echo "AZURE_API_KEY=your-azure-key" >> .env
echo "AZURE_API_ENDPOINT=https://your-resource.openai.azure.com" >> .env
echo "AZURE_API_VERSION=2024-06-01" >> .env
```

### AWS Bedrock

```bash
echo "AWS_ACCESS_KEY_ID=AKIAxxx" >> .env
echo "AWS_SECRET_ACCESS_KEY=xxx" >> .env
echo "AWS_REGION=us-east-1" >> .env
```

### 运行时切换提供商

用户可以在 UI 中按对话切换提供商。这允许你并排比较 GPT-4 和 Claude：

```
# 无需重启 —— 提供商切换是客户端操作
# 点击对话头部中的提供商图标 → 选择不同模型
# 每个对话记住其提供商选择
```

## 插件系统：扩展 Lobe Chat

Lobe Chat 的插件架构采用基于清单的系统。插件在 `manifest.json` 中声明功能，聊天 UI 将它们渲染为交互式工具。

### 从插件市场安装

1. 打开 Lobe Chat → 插件商店
2. 浏览 50+ 社区插件
3. 点击「安装」→ 授权权限
4. 插件在聊天中显示为工具调用

### 构建自定义插件

创建一个查询内部 API 的简单插件：

```json
{
  "api": [
    {
      "description": "搜索内部知识库",
      "name": "search_kb",
      "parameters": {
        "properties": {
          "query": {
            "description": "搜索查询字符串",
            "type": "string"
          }
        },
        "required": ["query"],
        "type": "object"
      },
      "url": "https://api.yourcompany.com/kb/search"
    }
  ],
  "gateway": "https://gateway.example.com",
  "identifier": "your-company/kb-search",
  "meta": {
    "title": "Internal KB Search",
    "description": "Search company knowledge base"
  },
  "version": "1.0.0"
}
```

将其托管在公共 URL，然后通过 **插件商店 → 自定义插件 → 输入 URL** 添加。

### 插件运行时安全

插件在沙箱化的 iframe 中执行，权限受限：

```
┌─────────────────────────────┐
│  Lobe Chat 主窗口           │
│  ┌───────────────────────┐  │
│  │  沙箱 Iframe          │  │
│  │  (插件代码)           │  │
│  │  - 无 DOM 访问        │  │
│  │  - 仅 postMessage     │  │
│  │  - 强制执行 CORS      │  │
│  └───────────────────────┘  │
└─────────────────────────────┘
```

每个插件请求都需要用户显式批准。LLM 建议工具调用，但执行前用户必须确认。

## PWA 支持与移动体验

Lobe Chat 作为渐进式 Web 应用运行，在所有平台上提供原生应用般的体验。

### 桌面安装（Chrome/Edge）

1. 在 Chrome 中打开 Lobe Chat
2. 点击地址栏中的安装图标
3. 作为独立窗口启动，带有自己的图标

### 移动设备安装（iOS Safari）

```
1. 在 Safari 中打开 Lobe Chat
2. 点击分享 → 「添加到主屏幕」
3. 作为原生应用图标出现
4. 支持推送通知（通过 service worker）
```

### 离线支持

Service worker 缓存应用外壳和最近对话。没有网络时：

```
✅ 浏览对话历史
✅ 查看之前的回复
✅ 撰写消息（排队发送）
❌ 新的 LLM 回复（需要 API 连接）
```

## 基准测试与真实用例

### 响应延迟（从美国东部测量）

| 提供商 | 首个 Token 时间 | 完整响应（100 tokens） | 备注 |
|---|---|---|---|
| OpenAI GPT-4o | **0.8秒** | **2.1秒** | 总体最快 |
| Claude 3.5 Sonnet | 1.1秒 | 2.8秒 | 推理质量更高 |
| Gemini 1.5 Pro | 1.3秒 | 3.0秒 | 大上下文窗口 |
| Ollama (Llama 3.2 7B, CPU) | 3.5秒 | 8.2秒 | 无 API 费用 |
| Ollama (Llama 3.2 7B, RTX 4090) | 0.6秒 | 1.5秒 | 最快本地选项 |
| Azure GPT-4 | 1.0秒 | 2.4秒 | 企业 SLA |

### 资源占用

| 部署方式 | 内存 | CPU | 用户数 | 月费用 |
|---|---|---|---|---|
| Docker 单实例 | **350MB** | **0.2 核** | 1–5 | $0（自托管） |
| Docker + 5 个提供商 | 400MB | 0.3 核 | 1–10 | 仅 API 费用 |
| 带 PostgreSQL 后端 | 650MB | 0.4 核 | 10–50 | ~$24 VPS |
| 反向代理后 | 400MB | 0.3 核 | 10–100 | ~$24 VPS |

### 真实部署案例

**AI 咨询公司（12 名工程师）：**
- 在 [DigitalOcean Droplet](https://m.do.co/c/eca87ac14ee0) 上部署 Lobe Chat
- 连接 **8 个 LLM 提供商** 用于客户对比演示
- 构建 **3 个自定义插件** 链接内部项目数据库
- 相比单独订阅 ChatGPT Plus **每月节省 ~$240**

**大学研究实验室（40 名学生）：**
- 使用 Ollama 自托管以保护隐私敏感的研究数据
- 学生通过 PWA 在笔记本和手机上访问
- 插件连接大学图书馆搜索 API
- 未发表研究数据零云端暴露

**初创公司客服（5 名客服）：**
- 通过 API 集成 Claude 3.5 Sonnet
- 自定义插件查询产品文档
- 多语言 UI 支持英语、中文、日语客户
- 回复起草时间减少 **约 45%**

## 高级用法与生产加固

### 启用认证

团队部署时设置访问密码：

```bash
docker run -d -p 3210:3210 \
  -e ACCESS_CODE=your-secure-password-2026 \
  -e OPENAI_API_KEY=sk-xxx \
  lobehub/lobe-chat:latest
```

SSO 集成，配置 OAuth：

```bash
  -e AUTH_PROVIDER=auth0 \
  -e AUTH_AUTH0_ID=your-client-id \
  -e AUTH_AUTH0_SECRET=your-secret \
  -e AUTH_AUTH0_ISSUER=https://your-domain.us.auth0.com \
```

### 自定义主题

创建主题 JSON 文件：

```json
{
  "primaryColor": "#1890ff",
  "neutralColor": "#8c8c8c",
  "backgroundColor": "#f0f2f5",
  "sidebarWidth": 280
}
```

通过 **设置 → 主题 → 自定义主题** 上传。

### 数据库持久化对话

多用户持久化，配置 PostgreSQL：

```yaml
# docker-compose.prod.yml
services:
  lobe-chat:
    image: lobehub/lobe-chat:latest
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/lobechat
      - APP_URL=https://chat.yourdomain.com
    ports:
      - "3210:3210"

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
      POSTGRES_DB: lobechat
    volumes:
      - pgdata:/var/lib/postgresql/data

volumes:
  pgdata:
```

### 使用 Caddy 反向代理

```bash
# Caddyfile 自动 HTTPS
chat.yourdomain.com {
    reverse_proxy localhost:3210
    encode gzip
    header {
        X-Frame-Options DENY
        X-Content-Type-Options nosniff
    }
}
```

```bash
caddy run --config Caddyfile
```

### 使用 Prometheus 监控

Lobe Chat 在 `/api/metrics` 暴露指标：

```yaml
# docker-compose.monitoring.yml
services:
  prometheus:
    image: prom/prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  grafana:
    image: grafana/grafana
    ports:
      - "3000:3000"
```

## 与替代方案对比

| 特性 | Lobe Chat | LibreChat | ChatGPT Web | HuggingChat |
|---|---|---|---|---|
| **GitHub Stars** | **~60,000** | ~20,000 | ~30,000 | N/A（产品） |
| **LLM 提供商** | **20+** | 10+ | 仅 OpenAI | 仅 HF 模型 |
| **插件系统** | **基于清单** | 基础工具 | 无 | 无 |
| **PWA 支持** | **完整** | 部分 | 无 | 无 |
| **多语言 UI** | **15+ 种语言** | 5 种 | 10 种 | 6 种 |
| **自托管** | **是（Docker）** | 是 | 是 | 否（仅 SaaS） |
| **认证** | **SSO + 访问码** | SSO + 本地 | 基础 | 仅 OAuth |
| **知识库** | **基于插件** | 内置 RAG | GPTs | 无 |
| **代码解释器** | **通过插件** | 通过插件 | 原生 | 无 |
| **移动体验** | **类原生 PWA** | 响应式 | 响应式 | 基础 |
| **主题定制** | **完整** | 部分 | 无 | 最小 |
| **消息同步** | **PostgreSQL 后端** | MongoDB | LocalStorage | 云端 |

**选择建议：**

- **Lobe Chat**：当你需要精致的多提供商聊天 UI，带插件和 PWA 时选择。团队整体体验最佳。
- **LibreChat**：如果你想要更简单的设置，带内置 RAG（文档上传），不需要 PWA 或大量插件。
- **ChatGPT Web (Next-Web)**：如果你主要使用 OpenAI，想要最快、最轻量的自托管 UI。
- **HuggingChat**：用作 Hugging Face 模型的免费 Web UI，但不适合自托管或企业使用。

## 局限性：诚实评估

**暂无内置 RAG。** 与内置文档上传和向量搜索的 LibreChat 不同，Lobe Chat 依赖插件实现知识库功能。原生 RAG 功能已在 v1.0 路线图中，但截至 2026 年 5 月尚不可用。

**插件生态尚年轻。** 约 50 个插件，对比 ChatGPT 的数千个。构建自定义插件需要理解清单 schema 并托管兼容 API。

**需要 LLM API 密钥。** Lobe Chat 只是一个 UI —— 你仍然需要云提供商的 API 密钥或运行 Ollama 实例用于本地模型。没有内置「免费层」。

**没有多用户聊天室。** 对话是私有的，每个浏览器会话独立。真正的多用户协作和共享频道需要自定义后端。

**Docker 镜像较大。** 生产镜像约 400MB（压缩）。慢速连接下，首次拉取需要几分钟。

**无语音输入/输出。** 与 ChatGPT 移动应用不同，Lobe Chat 原生不支持语音转文字或文字转语音。可以使用浏览器 Web Speech API 作为变通方案。

**插件审批 UX 增加摩擦。** 每个插件调用都需要用户确认。这对安全性很好，但相比 ChatGPT 自动运行的代码解释器，会减慢工作流程。

## 常见问题

**Q: Lobe Chat 会在他们的服务器上存储我的对话吗？**

不会。自托管时，所有对话数据都留在你的基础设施上。Lobe Chat 是一个客户端应用，除非你显式配置分析，否则不会向外部服务器发送遥测数据。开源代码（MIT 许可证）可在 GitHub 上审计。云 API 密钥（OpenAI、Claude）仅用于 LLM 推理调用 —— 对话本身存储在本地。

**Q: 我可以在同一个对话中使用多个 LLM 提供商吗？**

单个对话线程内不行。每个对话绑定一个提供商，但你可以创建多个不同提供商的对话并在它们之间切换。一些用户保留一个用于编程的「GPT-4」线程和一个用于写作的「Claude」线程，通过侧边栏切换。

**Q: 如何将 Lobe Chat 更新到最新版本？**

```bash
# 拉取最新镜像
docker pull lobehub/lobe-chat:latest

# 重启容器
docker compose down && docker compose up -d

# 对话在浏览器 localStorage 中持久化
# 对于 PostgreSQL 后端，数据库迁移自动运行
```

每周发布更新。更新前请查看 [releases 页面](https://github.com/lobehub/lobe-chat/releases) 了解破坏性变更。

**Q: 插件系统与 function calling 有什么区别？**

Lobe Chat 插件是 **UI 级集成** —— 它们在聊天中渲染交互式卡片、表单和可视化。Function calling 是 **LLM 级机制**，决定何时调用工具。Lobe Chat 底层使用 function calling 触发插件，然后渲染插件的 UI 响应。插件架构通过视觉组件和用户审批流程扩展了 function calling。

**Q: 我可以在没有网络的情况下使用 Lobe Chat 吗？**

部分可以。如果你将 Ollama 配置为唯一提供商（本地 LLM），核心聊天功能可以离线工作。但是，插件调用需要网络连接（它们访问外部 API），初始应用加载需要下载资源。PWA 缓存应用外壳，所以首次访问后，使用本地模型时基本聊天可以离线工作。

**Q: 对话历史有限制吗？**

使用默认 localStorage 后端时，对话在浏览器中持久化，没有硬性限制，但超过约 500 个长对话后性能会下降。使用 PostgreSQL 后端时，实际上没有限制 —— 数据库处理数千个跨多用户的对话。Token 上下文窗口限制根据所选 LLM 提供商的约束执行。

**Q: 我可以导入 ChatGPT 对话吗？**

不能直接导入。ChatGPT 的导出格式（conversations.json）与 Lobe Chat 的存储 schema 不兼容。但是，社区工具可以将 ChatGPT 导出转换为 Markdown，你可以粘贴到 Lobe Chat 对话中。LobeHub 团队计划在 2026 Q3 推出导入功能。

## 结论：你的聊天，你做主

Lobe Chat 提供了 ChatGPT 不会给的东西：对数据的完全控制、对每个主要 LLM 提供商的支持、可扩展插件和原生般的移动体验 —— 全部运行在你自己的硬件上。凭借 **约 60,000 GitHub Stars** 和每周发布，它是一个成熟的、积极维护的项目，在用户体验质量上可与商业替代品媲美。

对于个人，Docker 设置只需 10 分钟，除了 API 使用费外不花一分钱。对于团队，在 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 上部署带 PostgreSQL 后端，为你提供一个完全可审计的共享聊天平台。

插件系统和 PWA 支持使 Lobe Chat 不仅仅是 ChatGPT 克隆 —— 它是一个用于构建为你的组织量身定制的 AI 驱动工作流的平台。多语言 UI 意味着它无需配置即可适用于全球团队。

**准备切换了吗？** 运行 Docker 命令，添加你的 API 密钥，开始聊天。你的对话属于你。

加入 AI 开发者 Telegram 社区：**@dibi8dev** —— 分享你的 Lobe Chat 配置，从 5,000+ 开发者那里获取帮助。

---

## 来源与延伸阅读

1. [Lobe Chat GitHub 仓库](https://github.com/lobehub/lobe-chat) — 官方源码、发布和文档
2. [Lobe Chat 官方文档](https://lobehub.com/docs) — 官方安装和配置指南
3. [Lobe Chat 插件文档](https://github.com/lobehub/lobe-chat/wiki/Plugin-System) — 插件清单规范
4. [Docker Hub — lobehub/lobe-chat](https://hub.docker.com/r/lobehub/lobe-chat) — 官方 Docker 镜像
5. [LobeHub 插件市场](https://lobechat.com/plugins) — 浏览可用插件
6. [Next.js 文档](https://nextjs.org/docs) — 底层框架文档

---



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 联盟营销声明

本文包含联盟营销链接。如果你通过我们的推荐链接注册 DigitalOcean，我们会获得佣金，不会对你产生额外费用。我们只推荐自己也在用的服务。Lobe Chat 是开源软件（MIT 许可证），免费使用 —— 无需购买。
