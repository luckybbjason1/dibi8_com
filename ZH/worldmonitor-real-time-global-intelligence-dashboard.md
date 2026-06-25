---
title: WorldMonitor：面向地缘政治监控的实时全球情报仪表盘
description: 一个实时的AI驱动全球情报仪表盘，聚合新闻、地缘政治事件和基础设施追踪。59K stars。Palantir Gotham的开源替代方案。
date: 2026-06-25
lastmod: 2026-06-25
draft: false
category: ai-tools
tags: ['ai', '仪表盘', '地缘政治', '监控', '新闻', '开源', 'osint', 'palantir', '态势感知']
slug: worldmonitor-real-time-global-intelligence-dashboard
featureImage: /images/articles/worldmonitor-real-time-global-intelligence-dashboard-for-geopolitical-monitoring.png
lang: zh
github_repo: https://github.com/WorldMonitorHQ/worldmonitor
license: MIT
---



# WorldMonitor：实时全球情报仪表盘

**WorldMonitor** 是一个开源的实时全球情报仪表盘，它将新闻、地缘政治事件和基础设施数据聚合到一个统一的态势感知界面中。凭借 **59,524 个 GitHub Stars**，它已成为商业平台（如 Palantir Gotham）在地缘政治监控和 OSINT 分析领域的首选开源替代方案。

本文涵盖安装、配置、数据源、API 使用、部署选项以及面向记者、研究人员和安全分析师的实际应用。

## TL;DR

WorldMonitor 将碎片化的全球数据流转化为单一的可操作情报仪表盘。它从 50 多个来源摄取新闻，实时追踪地缘政治事件，监控全球关键基础设施，并提供 AI 驱动的分析和可定制的警报功能。非常适合那些需要全面了解全球事件而不愿支付企业级价格的任何人。

## 什么是 WorldMonitor？

WorldMonitor 是一个自托管的情报仪表盘，它将多个数据源整合为一个统一的全球事件视图。与仅仅收集标题的传统新闻聚合器不同，WorldMonitor 应用 AI 驱动的分析来关联事件、检测模式并呈现可操作的情报。

该平台专为需要在多个地理区域和数据类别中获取实时态势感知的记者、研究人员、政策分析师和安全专业人员而设计。它支持个人分析师的单实例部署，也支持团队范围操作的分布式架构。

核心功能包括：

- **多源新闻聚合**：从 RSS 订阅源、API 和网络爬虫中聚合来自 50 多个全球新闻来源的内容
- **地缘政治事件追踪**：实时地图和时间线可视化
- **基础设施监控**：监控关键设施，包括电网、电信塔和交通枢纽
- **AI 驱动的相关性引擎**：识别看似无关的事件之间的关系
- **可定制警报**：基于关键词、地区、事件类型或严重程度阈值
- **历史分析**：支持搜索跨数月聚合数据的存档
- **API 访问**：便于与其他情报工具进行程序化集成

## 安装指南

### 前置条件

在安装 WorldMonitor 之前，请确保您的系统满足以下要求：

- **操作系统**：Ubuntu 22.04 LTS、Debian 12 或 macOS 14+
- **CPU**：最低 4 核（生产环境推荐 8 核）
- **内存**：最低 8GB（推荐 16GB）
- **存储**：50GB SSD（随数据保留期限增长）
- **网络**：需要出站互联网访问以进行数据采集
- **依赖项**：Node.js 20+、Python 3.11+、PostgreSQL 15+

### 选项一：Docker Compose 部署（推荐）

最快的入门方式是使用提供的 Docker Compose 配置：

```bash
git clone https://github.com/koala73/worldmonitor.git
cd worldmonitor

# 复制示例配置文件
cp config.example.yaml config.yaml

# 启动所有服务
docker compose up -d
```

这将启动应用服务器、PostgreSQL 数据库、Redis 缓存和 Web 前端。默认凭据设置在 `.env` 文件中——在生产使用前请立即更改它们。

### 选项二：手动安装

对于需要对部署进行精细控制的用户：

```bash
# 克隆仓库
git clone https://github.com/koala73/worldmonitor.git
cd worldmonitor

# 安装后端依赖
pip install -r requirements.txt

# 安装前端依赖
cd frontend && npm install && cd ..

# 设置数据库
createdb worldmonitor
psql worldmonitor < migrations/001_init.sql

# 配置应用程序
cp config.example.yaml config.yaml
# 用你的设置编辑 config.yaml

# 运行数据库迁移
python manage.py migrate

# 启动应用服务器
python manage.py runserver 0.0.0.0:8000

# 启动前端（在单独的终端中）
cd frontend && npm run start
```

### 选项三：Kubernetes 部署

适用于跨多个节点的生产规模部署：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: worldmonitor
spec:
  replicas: 3
  selector:
    matchLabels:
      app: worldmonitor
  template:
    metadata:
      labels:
        app: worldmonitor
    spec:
      containers:
      - name: worldmonitor
        image: ghcr.io/koala73/worldmonitor:latest
        ports:
        - containerPort: 8000
        envFrom:
        - configMapRef:
            name: worldmonitor-config
        resources:
          requests:
            memory: "2Gi"
            cpu: "1000m"
          limits:
            memory: "4Gi"
            cpu: "2000m"
```

## 配置深入解析

### 数据源配置

WorldMonitor 支持多种数据源类型。在 `config.yaml` 中配置它们：

```yaml
data_sources:
  rss_feeds:
    enabled: true
    sources:
      - name: "Reuters"
        url: "https://feeds.reuters.com/reuters/worldNews"
        categories: ["politics", "business"]
        refresh_interval: 300
      - name: "BBC World"
        url: "http://feeds.bbci.co.uk/news/world/rss.xml"
        categories: ["politics", "health"]
        refresh_interval: 300
      - name: "Al Jazeera"
        url: "https://www.aljazeera.com/xml/rss/all.xml"
        categories: ["politics", "conflict"]
        refresh_interval: 600

  api_feeds:
    enabled: true
    sources:
      - name: "GDELT"
        api_key: "${GDELT_API_KEY}"
        endpoint: "https://api.gdeltproject.org/api/v2/event/doc"
        categories: ["conflict", "political"]
        refresh_interval: 900
      - name: "ACLED"
        api_key: "${ACLED_API_KEY}"
        endpoint: "https://api.acled.info/v1/events"
        categories: ["conflict", "protest"]
        refresh_interval: 3600

  web_scrapers:
    enabled: true
    sources:
      - name: "Government Press Releases"
        urls:
          - "https://www.state.gov/latest-releases/"
          - "https://www.un.org/press/en/"
        selectors:
          title: "h2.article-title"
          content: ".article-body"
          date: ".article-date"
        refresh_interval: 1800
```

### AI 分析管道

AI 驱动的分析引擎通过多个阶段处理传入的数据：

```python
from worldmonitor.ai.pipeline import AnalysisPipeline
from worldmonitor.ai.models import EventClassifier, CorrelationEngine

# 初始化分析管道
pipeline = AnalysisPipeline(
    classifier=EventClassifier(model="worldmonitor/classifier-v3"),
    correlation=CorrelationEngine(model="worldmonitor/correlation-v2"),
    embedding_model="worldmonitor/embedding-multilingual"
)

# 处理一批新闻文章
results = await pipeline.process_batch(
    articles=batch_data,
    min_confidence=0.7,
    include_correlations=True
)

# 获取特定区域的关联事件
correlated = await pipeline.get_correlated_events(
    region="east_asia",
    time_window="24h",
    event_types=["political", "economic"]
)
```

### 警报配置

根据你的监控优先级设置自定义警报：

```yaml
alerts:
  rules:
    - name: "重大冲突检测"
      conditions:
        - field: "event_type"
          operator: "eq"
          value: "armed_conflict"
        - field: "severity"
          operator: "gte"
          value: 7
      actions:
        - type: "notification"
          channels: ["email", "telegram"]
          template: "high_severity_conflict"
        - type: "dashboard_highlight"
          duration: "3600"

    - name: "基础设施中断"
      conditions:
        - field: "infrastructure_type"
          operator: "in"
          value: ["power_grid", "telecom", "transport"]
        - field: "status"
          operator: "eq"
          value: "disrupted"
      actions:
        - type: "notification"
          channels: ["email", "slack", "pagerduty"]
          template: "infrastructure_alert"
        - type: "geopoint_map"
          zoom_level: 12

    - name: "关键词激增检测"
      conditions:
        - field: "keywords"
          operator: "contains_any"
          value: ["sanctions", "embargo", "tariff", "trade_war"]
        - field: "volume_change"
          operator: "gte"
          value: 200
      actions:
        - type: "notification"
          channels: ["email"]
          template: "keyword_surge"
          cooldown: "1800"
```

## 核心功能详解

### 全球新闻聚合引擎

WorldMonitor 的新闻聚合引擎从多种语言的 50 多个来源提取数据。系统使用智能去重避免从多个渠道报道同一故事，同时保留对重大事件的地域视角。

```bash
# 使用过滤器查询聚合新闻
curl -X GET "https://your-worldmonitor/api/v1/news" \
  -H "Authorization: Bearer *** \
  -d "region=east_asia&categories=politics,economy&min_severity=5&hours=24"

# 获取去重后的故事
curl -X GET "https://your-worldmonitor/api/v1/news/deduplicated" \
  -H "Authorization: Bearer *** \
  -d "cluster_window=3600&language=en"
```

### 地缘政治事件映射

事件以颜色编码的严重程度级别绘制在交互式世界地图上。用户可以按事件类型、地区、日期范围和来源置信度评分进行过滤。时间线视图显示事件进展并识别级联效应。

### 基础设施追踪模块

基础设施模块维护全球关键设施的数据库，包括：

- 发电厂和电网
- 电信塔和光纤线路
- 交通枢纽（机场、海港、火车站）
- 水处理设施
- 数据中心和云基础设施

每个设施都标记有所有权、容量和风险等级。状态变化会触发自动警报和地图更新。

### AI 相关性引擎

专有相关性引擎识别表面上看似无关的事件之间的关系。例如，它可能检测到某个国家的政治声明与另一个国家的市场波动相关，或者 A 地区的基础设施中断先于 B 地区的类似事件发生。

```python
from worldmonitor.correlation import CorrelationEngine

engine = CorrelationEngine()

# 查找近期事件之间的相关性
correlations = engine.find_correlations(
    events=event_list,
    max_lag_hours=72,
    min_strength=0.6,
    correlation_types=["temporal", "geographic", "thematic"]
)

for corr in correlations:
    print(f"强度: {corr.strength:.2f}")
    print(f"类型: {corr.type}")
    print(f"事件: {corr.event_ids}")
    print(f"解释: {corr.explanation}")
```

## API 参考

WorldMonitor 提供全面的 REST API 用于程序化访问：

### 认证

```bash
# 获取 API 令牌
curl -X POST "https://your-worldmonitor/api/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"username": "admin", "password": "${WM_PASSWORD}"}'
```

### 新闻 API

```bash
# 列出最近的新闻（带分页）
curl "https://your-worldmonitor/api/v1/news?page=1&per_page=50" \
  -H "Authorization: Bearer ***

# 按地区获取新闻
curl "https://your-worldmonitor/api/v1/news?region=south_asia&date_from=2026-06-01" \
  -H "Authorization: Bearer ***

# 按关键词搜索
curl "https://your-worldmonitor/api/v1/news/search?q=trade+sanctions" \
  -H "Authorization: Bearer ***
```

### 事件 API

```bash
# 列用地缘政治事件
curl "https://your-worldmonitor/api/v1/events?type=political&severity_gte=6" \
  -H "Authorization: Bearer ***

# 获取事件详情
curl "https://your-worldmonitor/api/v1/events/EVT-2026-0625-001" \
  -H "Authorization: Bearer ***

# 获取事件时间线
curl "https://your-worldmonitor/api/v1/events/EVT-2026-0625-001/timeline" \
  -H "Authorization: Bearer ***
```

### 警报 API

```bash
# 列出活跃警报
curl "https://your-worldmonitor/api/v1/alerts?status=active" \
  -H "Authorization: Bearer ***

# 确认警报
curl -X PUT "https://your-worldmonitor/api/v1/alerts/ALT-001/acknowledge" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{"acknowledged_by": "analyst@example.com", "notes": "正在调查"}'

# 创建自定义警报规则
curl -X POST "https://your-worldmonitor/api/v1/alerts/rules" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "name": "自定义规则",
    "conditions": {
      "regions": ["east_asia"],
      "event_types": ["political"],
      "severity_min": 5
    },
    "actions": {
      "channels": ["email"],
      "recipients": ["team@example.com"]
    }
  }'
```

## 部署选项

### 单实例（个人分析师）

对于个人记者或研究人员，单个 Docker Compose 部署在 4 核 VPS 上就足够了：

```
服务器：4 vCPU，8GB RAM，100GB SSD
成本：约 $20/月（DigitalOcean / HTStack）
容量：约 1,000 个事件/天，30 天保留
```

### 团队部署

对于 5-20 人的分析师团队，添加 Redis 集群和 PostgreSQL 只读副本：

```
应用服务器：3x 4 vCPU，16GB RAM（位于负载均衡器后面）
数据库：PostgreSQL 主节点 + 2 个只读副本
缓存：Redis 集群（3 个节点）
存储：500GB SSD + S3 归档
成本：约 $200/月
容量：约 10,000 个事件/天，90 天保留
```

### 企业/分布式

适用于政府或大型组织部署：

```
具有数据主权控制的多区域部署
跨 10+ 应用节点的横向扩展
使用 Patroni 的 PostgreSQL 自动故障转移
对象存储用于历史数据归档
与现有 SIEM/SOC 平台集成
成本：定制定价
容量：无限制，支持地理分布式数据采集
```

## 与其他工具的集成

WorldMonitor 可与流行的情报和通信工具无缝集成：

### Slack 集成

```bash
# 安装 Slack 应用
curl -X POST "https://your-worldmonitor/api/v1/integrations/slack" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "channel": "#global-events",
    "alert_rules": ["major_conflict", "infrastructure_disruption"],
    "digest_frequency": "hourly"
  }'
```

### Telegram 机器人

```bash
# 创建 Telegram 机器人集成
curl -X POST "https://your-worldmonitor/api/v1/integrations/telegram" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "bot_token": "${TELEGRAM_BOT_TOKEN}",
    "chat_id": "${TELEGRAM_CHAT_ID}",
    "alert_rules": ["all_high_severity"]
  }'
```

### Grafana 仪表盘

```bash
# 导出指标到 Grafana
curl -X POST "https://your-worldmonitor/api/v1/metrics/grafana" \
  -H "Authorization: Bearer *** \
  -H "Content-Type: application/json" \
  -d '{
    "datasource": "prometheus",
    "dashboard_template": "worldmonitor-overview"
  }'
```

### ELK Stack / Elasticsearch

```yaml
# WorldMonitor Elasticsearch 输出配置
output:
  elasticsearch:
    hosts: ["https://es-cluster.internal:9200"]
    index: "worldmonitor-%{+yyyy.MM.dd}"
    username: "${ES_USER}"
    password: "${ES_PASS}"
    template_overwrite: true
    bulk_size: 500
    flush_interval: 5
```

## 对比：WorldMonitor 与商业替代品

| 功能 | WorldMonitor | Palantir Gotham | Meltwater | Brandwatch |
|
加入社区: [Telegram](https://t.me/DIBI8_Group) · [HuggingFace](https://huggingface.co/collections/nvidia/cosmos3)

内部链接: [nvidia-cosmos-world-models-platform-2026](https://dibi8.com/zh/resources/ai-tools/nvidia-cosmos-world-models-platform-2026) · [bytedance-ui-tars-desktop-ai-agent-guide](https://dibi8.com/zh/resources/ai-tools/bytedance-ui-tars-desktop-ai-agent-guide)

**披露声明**: 本文提及的工具可能存在联盟关系。我们不接受付费评测。所有观点均为我们自己独立撰写。
