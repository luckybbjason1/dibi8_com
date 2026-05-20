---
title: 'Grafana: 73,876 GitHub Stars — Docker 部署指南 2026'
description: 'Grafana 是开源的可视化与分析平台，用于监控和可观测性。支持 Prometheus、Loki、InfluxDB、Elasticsearch 集成。包含 Docker 部署、生产环境加固、与 Datadog、Kibana、New Relic 的对比。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/grafana/grafana'
stars: 73876
maintainer: 'grafana'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['grafana', 'docker', '监控', 'prometheus', '可观测性', '仪表盘', '运维']
aliases:
- /zh/posts/grafana/
---

{{</* resource-info */>}}

每一次生产事故都始于一个问题："什么变了？"如果没有一个集中化的指标、日志和追踪视图，回答这个问题可能需要几分钟 —— 有时甚至几小时。Grafana，这个拥有 73,876 个 GitHub Star 的开源可视化平台，将这个问题变成了一眼可见的仪表盘。本指南将带你完成生产级 Docker 部署、数据源集成，以及区分概念验证和生产就绪监控栈的加固决策。

## 什么是 Grafana？

Grafana 是一个开源的监控和可观测性平台，可以从 100 多个数据源（时序数据库、日志聚合器、追踪后端和云 API）中可视化数据，构建统一、可共享的仪表盘。Grafana 最初由 Torkel Ödegaard 于 2014 年作为 Graphite 的前端推出，现已发展成为 LGTM 技术栈（Loki、Grafana、Tempo、Mimir）和更广泛的云原生可观测性生态系统中的首选可视化层。

## Grafana 的工作原理

Grafana 作为一个无状态的可视化层，介于数据源和运维团队之间。它本身不存储指标或日志；相反，它通过原生 API 查询外部数据源，并将结果渲染为面板、仪表盘和告警。

![Grafana LGTM 技术栈架构](https://blog.tarazevits.io/content/images/size/w1200/2025/06/85145BFE-09CC-4120-82A7-A8C671FE1CEA.png)

**核心架构组件：**

- **数据源** — Prometheus、Loki、InfluxDB、Elasticsearch、CloudWatch、Azure Monitor 等 100 多个原生插件
- **查询引擎** — 每个面板使用其数据源的原生语言执行查询（PromQL、LogQL、InfluxQL、Lucene）
- **告警引擎** — 针对查询结果评估告警规则，并将通知路由到 Slack、PagerDuty、邮件、Webhook
- **仪表盘模型** — 基于 JSON 的仪表盘定义，可以进行版本控制、从 Git 预配置，或从社区库导入
- **认证层** — 支持多租户部署的 OAuth、LDAP、SAML 和 API 密钥访问

典型的数据流如下：Prometheus 从应用程序和 Node Exporter 抓取指标，Loki 从 Promtail 或 Fluentd 聚合日志，Grafana 查询两者以渲染关联仪表盘 —— CPU 峰值（指标）和错误激增（日志）并排显示。

![Grafana 生产仪表盘](https://www.lineate.com/uploads/grafana_dashboard_a9dfa70210.png)

典型的生产 Grafana 仪表盘组合了多种面板类型 —— 用于 CPU/内存的时序图、用于当前值的统计面板、用于实时错误的日志流，以及用于事件关联的告警注释 —— 所有这些都查询不同数据源的单一视图。

## 安装与配置

### Docker CLI — 单容器（30 秒）

启动 Grafana 的最快方式用于本地探索：

```bash
# 创建持久化卷用于 Grafana 数据
docker volume create grafana-storage

# 运行最新的稳定版 Grafana Enterprise 镜像
docker run -d \
  -p 3000:3000 \
  --name=grafana \
  --volume grafana-storage:/var/lib/grafana \
  grafana/grafana-enterprise
```

访问 `http://localhost:3000`。默认凭据是 `admin` / `admin`。首次登录时系统会提示你更改密码。

### Docker Compose — 生产就绪技术栈

对于生产级监控栈，将 Grafana 与 Prometheus 和 Loki 结合使用。创建以下目录结构：

```bash
mkdir -p ~/grafana-stack/{prometheus,loki,grafana/provisioning/datasources,grafana/provisioning/dashboards,grafana/dashboards}
cd ~/grafana-stack
```

**docker-compose.yml：**

```yaml
version: "3.8"

services:
  grafana:
    image: grafana/grafana-enterprise:11.6.0
    container_name: grafana
    restart: unless-stopped
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_USER=${GRAFANA_ADMIN_USER:-admin}
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_ADMIN_PASSWORD:-admin}
      - GF_USERS_ALLOW_SIGN_UP=false
      - GF_SERVER_ROOT_URL=https://grafana.yourdomain.com
      - GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-piechart-panel
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana/provisioning:/etc/grafana/provisioning
      - ./grafana/dashboards:/var/lib/grafana/dashboards
    networks:
      - monitoring
    depends_on:
      - prometheus
      - loki

  prometheus:
    image: prom/prometheus:v3.2.0
    container_name: prometheus
    restart: unless-stopped
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'
    networks:
      - monitoring

  loki:
    image: grafana/loki:3.4.0
    container_name: loki
    restart: unless-stopped
    ports:
      - "3100:3100"
    volumes:
      - ./loki/loki-config.yml:/etc/loki/local-config.yaml
      - loki-data:/loki
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - monitoring

  promtail:
    image: grafana/promtail:3.4.0
    container_name: promtail
    restart: unless-stopped
    volumes:
      - /var/log:/var/log:ro
      - ./loki/promtail-config.yml:/etc/promtail/config.yml
    command: -config.file=/etc/promtail/config.yml
    networks:
      - monitoring

volumes:
  grafana-data:
  prometheus-data:
  loki-data:

networks:
  monitoring:
    driver: bridge
```

**prometheus/prometheus.yml：**

```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'grafana'
    static_configs:
      - targets: ['grafana:3000']
```

**loki/loki-config.yml：**

```yaml
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

ingester:
  wal:
    enabled: true
    dir: /loki/wal
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2020-05-15
      store: tsdb
      object_store: filesystem
      schema: v13
      index:
        prefix: index_
        period: 24h

storage_config:
  tsdb_shipper:
    active_index_directory: /loki/index
    cache_location: /loki/cache
  filesystem:
    directory: /loki/chunks

compactor:
  working_directory: /loki/compactor
  retention_enabled: true
  retention_delete_delay: 2h

limits_config:
  retention_period: 720h
```

**loki/promtail-config.yml：**

```yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system-logs
    static_configs:
      - targets:
          - localhost
        labels:
          job: system-logs
          __path__: /var/log/*.log
```

启动技术栈：

```bash
docker compose up -d
```

在 `http://your-server-ip:3000` 访问 Grafana。Prometheus 在 9090 端口，Loki 在 3100 端口。

### 自动预配置数据源

无需手动点击 UI 添加数据源，使用 Grafana 的预配置系统。创建 `grafana/provisioning/datasources/datasources.yml`：

```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: false

  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    editable: false

  - name: Tempo
    type: tempo
    access: proxy
    url: http://tempo:3200
    editable: false
```

重启 Grafana，数据源将自动出现：

```bash
docker compose restart grafana
```

## 与 Prometheus、Loki、InfluxDB 和 Elasticsearch 集成

### Prometheus — 指标仪表盘

Prometheus 是 Grafana 的事实标准指标源。典型的 CPU 监控面板使用 PromQL：

```promql
# CPU 使用率百分比
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)

# 内存使用率
100 * (1 - ((node_memory_MemAvailable_bytes or node_memory_Buffers_bytes) / node_memory_MemTotal_bytes))

# 磁盘使用率
100 - ((node_filesystem_avail_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"})
```

从 Grafana 仪表盘库导入官方 Node Exporter Full 仪表盘（ID: `1860`），获取 115 多个预构建的系统指标面板。

### Loki — 日志聚合

Loki 将日志行与指标并排显示在同一个仪表盘中。用于查找错误行的 LogQL 查询：

```logql
# 统计每个应用的错误日志数量
sum by(app) (rate({job="system-logs"} |= "ERROR" [5m]))

# 搜索特定错误模式
{job="system-logs"} |~ "(?i)error|exception|fatal" | json | line_format "{{.message}}"
```

### InfluxDB — 时序数据

对于物联网和高基数指标工作负载，InfluxDB 与 Grafana 配合良好：

```sql
-- InfluxQL 示例：每个传感器的平均温度
SELECT mean("temperature") FROM "sensors" WHERE $timeFilter GROUP BY "sensor_id", time($__interval) fill(null)
```

### Elasticsearch — 日志搜索

对于已投资 Elastic 技术栈的团队，Grafana 可以直接查询 Elasticsearch 索引：

```json
{
  "query": {
    "bool": {
      "must": [
        { "match": { "level": "ERROR" } },
        { "range": { "@timestamp": { "gte": "now-1h" } } }
      ]
    }
  }
}
```

## 基准测试 / 实际用例

**规模化性能特征：**

| 指标 | 单实例 (Docker) | HA 对 (K8s) |
|------|----------------|-------------|
| 仪表盘加载时间 | 50-200ms | 30-100ms |
| 并发用户数 | 50-100 | 500+ |
| 每面板最大数据点数 | 10,000-50,000 | 100,000+ |
| 告警规则评估 | 1-10s | <5s |
| 内存使用 | 256-512MB | 512MB-1GB 每 Pod |

**Netflix** 在数千个微服务上大规模运行 Grafana，使用自定义数据源插件关联来自多个内部系统的指标。**PayPal** 使用 Grafana 配合 Prometheus 监控 200,000 多个容器。**eBay** 用 Grafana 替代了传统的商业监控工具，将仪表盘创建时间从几天缩短到几小时。

一个中型电商平台（50 台主机，200 万个活跃序列）运行自托管 Grafana 配合 Prometheus 和 Loki，通常看到：

- 月度基础设施成本：$200-500（计算 + 存储）
- 等效 Datadog 成本：$9,500+/月
- 仪表盘创建时间：30 分钟 vs. 自定义 UI 的 2 小时以上
- 平均检测时间 (MTTD)：采用 Grafana 后减少 40-60%

## 高级用法 / 生产环境加固

![Grafana 告警时间线仪表盘](https://grafana.com/mw/_next/image/?url=https%3A%2F%2Fs3.amazonaws.com%2Fa-us.storyblok.com%2Ff%2F1022730%2F2c26adbc90%2Fgrafana-dashboards-alerts-analysis.png&w=3840&q=75)

Grafana 的告警时间线仪表盘随时间可视化告警触发模式，帮助团队识别嘈杂告警以及在事件响应期间不同告警规则之间的关联。

### SSL/TLS 终止与反向代理

切勿将 Grafana 直接暴露在互联网上。使用 Traefik 或 Nginx 作为反向代理：

```yaml
# docker-compose.yml 附加配置
  traefik:
    image: traefik:v3.3
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--entrypoints.websecure.address=:443"
      - "--certificatesresolvers.letsencrypt.acme.tlschallenge=true"
      - "--certificatesresolvers.letsencrypt.acme.email=admin@yourdomain.com"
      - "--certificatesresolvers.letsencrypt.acme.storage=/letsencrypt/acme.json"
    ports:
      - "443:443"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./letsencrypt:/letsencrypt
    networks:
      - monitoring
```

### 高可用性设置

对于需要零停机的生产环境：

```yaml
# Grafana HA 需要共享数据库（PostgreSQL 或 MySQL）
# 以及负载均衡器后的多个 Grafana 实例

  postgres:
    image: postgres:17-alpine
    environment:
      POSTGRES_DB: grafana
      POSTGRES_USER: grafana
      POSTGRES_PASSWORD: ${DB_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data

  grafana-1:
    image: grafana/grafana-enterprise:11.6.0
    environment:
      - GF_DATABASE_TYPE=postgres
      - GF_DATABASE_HOST=postgres:5432
      - GF_DATABASE_NAME=grafana
      - GF_DATABASE_USER=grafana
      - GF_DATABASE_PASSWORD=${DB_PASSWORD}
      - GF_REMOTE_CACHE_TYPE=redis
      - GF_REMOTE_CACHE_CONNSTR=redis:6379
    depends_on:
      - postgres
```

### 告警即代码配置

通过预配置定义告警规则：

```yaml
# grafana/provisioning/alerting/alert-rules.yml
apiVersion: 1
groups:
  - orgId: 1
    name: infrastructure
    folder: Infrastructure
    interval: 60s
    rules:
      - uid: high-cpu-usage
        title: CPU 使用率超过 80%
        condition: B
        data:
          - refId: A
            relativeTimeRange:
              from: 300
              to: 0
            datasourceUid: prometheus
            model:
              expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        noDataState: NoData
        execErrState: Error
        for: 5m
        annotations:
          summary: "{{ $labels.instance }} 上 CPU 使用率过高"
```

### 从 Git 预配置仪表盘

将仪表盘作为 JSON 存储在代码仓库中并自动预配置：

```yaml
# grafana/provisioning/dashboards/dashboards.yml
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    disableDeletion: false
    editable: false
    updateIntervalSeconds: 30
    options:
      path: /var/lib/grafana/dashboards
      foldersFromFilesStructure: true
```

### 安全检查清单

- 立即更改默认管理员密码
- 禁用用户注册：`GF_USERS_ALLOW_SIGN_UP=false`
- 使用有效证书启用 HTTPS
- 在团队环境中使用 OAuth 2.0 或 LDAP 进行认证
- 将数据源代理访问权限限制为管理员角色
- 启用审计日志：`GF_AUDIT_ENABLED=true`
- 在容器中以非 root 用户运行 Grafana
- 保持插件更新 —— 有漏洞的插件是常见的攻击媒介

## 与替代品对比

| 特性 | Grafana | Datadog | Kibana | New Relic |
|------|---------|---------|--------|-----------|
| **开源** | 是 (AGPL-3.0) | 否 | 是 (SSPL) | 否 |
| **自托管选项** | 是，免费 | 否 | 是 | 否 |
| **数据源** | 100+ 原生 | 750+ 集成 | 仅限 Elasticsearch | 100+ |
| **指标 (时序)** | 优秀 (Prometheus) | 优秀 | 良好 | 良好 |
| **日志分析** | 良好 (通过 Loki) | 优秀 | 优秀 (Lucene) | 良好 |
| **APM / 分布式追踪** | 通过 Tempo/Jaeger 插件 | 优秀 (内置) | 通过 Elastic APM | 优秀 |
| **仪表盘灵活性** | 优秀 | 良好 | 良好 | 良好 |
| **告警功能** | 良好 | 优秀 | 基础 | 良好 |
| **部署复杂度** | 中等 | 低 | 中高 | 低 |
| **成本 (50 台主机/月)** | $0-500 自托管 | $9,500-20,000 | $500-1,500 自托管 | $7,500-15,000 |
| **社区 / 生态** | 庞大 (73K+ Stars) | 大型 | 大型 (Elastic) | 中等 |

**何时选择什么：**

- **Grafana** — 成本敏感的团队、Kubernetes 原生环境、多源可观测性需求、平台工程成熟度
- **Datadog** — 优先考虑上市时间的企业团队、没有专职平台工程师的团队、合规要求严格的行业
- **Kibana** — 深度日志分析需求、SIEM 用例、已有 Elasticsearch 投资
- **New Relic** — 具有慷慨免费层 (100GB/月) 的全栈 APM，基于用户的定价模式

## 局限性 / 诚实评估

Grafana 不是银弹。在投入之前了解这些局限性：

1. **没有内置数据收集功能** —— Grafana 可视化数据，但不收集数据。你仍然需要 Prometheus、Loki 或其他后端。与一体化 SaaS 平台相比，这增加了运维开销。

2. **日志搜索不是 Lucene** —— Loki 使用基于标签的过滤和正则表达式，而不是像 Elasticsearch 那样的全文搜索。复杂的日志查询可能更慢且不够直观。

3. **告警成熟度** —— Grafana 的统一告警（在 v8 中引入）已显著改进，但仍缺乏 PagerDuty 原生事件管理或 Datadog AI 驱动异常检测的复杂性。

4. **插件维护风险** —— 社区插件的质量和维护节奏参差不齐。插件被作者放弃可能会阻止 Grafana 升级。

5. **部署需要专业知识** —— LGTM 技术栈需要理解 PromQL、LogQL、Alertmanager 路由，以及在集群中运行时的 Kubernetes。这不是一个点击即部署的解决方案。

## 常见问题

**Q1: Grafana 在商业用途上完全免费吗？**

是的。开源 Grafana (AGPL-3.0) 对商业用途免费。Grafana Enterprise 增加了高级 RBAC、数据源权限和企业支持等功能，需要付费。对于大多数团队来说，OSS 版本已经足够。

**Q2: Grafana 能完全替代 Datadog 吗？**

视情况而定。对于指标、日志和追踪可视化，Grafana 配合 LGTM 技术栈可以以极低的成本覆盖 Datadog 80-90% 的功能。然而，Datadog 的 APM 深度、AI 驱动异常检测和开箱即用集成，对于优先考虑速度而非成本的团队来说仍然更胜一筹。

**Q3: 如何备份我的 Grafana 仪表盘？**

仪表盘以 JSON 格式存储在 Grafana 的数据库中。使用 API 导出它们：`curl -H "Authorization: Bearer $API_KEY" http://grafana:3000/api/dashboards/uid/<uid>`。对于 GitOps 工作流，从版本控制中的 JSON 文件预配置仪表盘。

**Q4: Grafana OSS 和 Grafana Enterprise 有什么区别？**

Grafana Enterprise 增加了企业数据源插件 (Snowflake、SAP HANA、ServiceNow)、具有细粒度访问控制的高级 RBAC、报告和高级支持。核心仪表盘和可视化功能是相同的。

**Q5: Grafana 如何为大型组织扩展？**

Grafana 通过在负载均衡器后运行多个实例并共享 PostgreSQL 或 MySQL 数据库来实现水平扩展。对于 500 多个用户，使用官方 Helm 图表部署在 Kubernetes 上，使用 Redis 进行会话缓存，并考虑 Grafana Mimir 进行长期指标存储。

**Q6: 我可以从其他工具导入仪表盘吗？**

可以。Grafana 支持通过社区转换器从 Datadog、Kibana 和其他工具导入。原生 JSON 仪表盘格式文档完善，Grafana 仪表盘库包含 5,000 多个社区贡献的仪表盘，可以通过 ID 导入。

**Q7: Grafana 支持实时仪表盘吗？**

支持，通过 Grafana Live（基于 WebSocket 的流式传输）和新的 Scenes 框架。刷新间隔可以设置为低至 5 秒，实现近实时监控。对于真正的实时场景，请使用流式数据源。

## 结论

Grafana 凭借解决了一个具体问题而赢得了 73,876 个 GitHub Star —— 将来自不同来源的可观测性数据统一到团队真正喜欢使用的仪表盘中。本指南涵盖的基于 Docker 的部署可以在 30 分钟内让生产级监控栈运行起来。对于愿意投资运维专业知识的团队，与 SaaS 替代品相比，成本节省是显著的。

**下一步：**

1. 克隆 [Grafana GitHub 仓库](https://github.com/grafana/grafana) 并探索代码库
2. 在你自己的基础设施上部署本指南中的 Docker Compose 技术栈
3. 导入仪表盘 ID `1860` (Node Exporter Full) 获取即时系统可见性
4. 加入 [Grafana 社区论坛](https://community.grafana.com/) 获取支持
5. 关注 [dibi8 Telegram 群组](https://t.me/dibi8hub) 获取每周开发工具深度解析

*本文包含联盟链接。如果你通过 DigitalOcean 或 HTStack 使用我们的链接购买主机，我们将获得佣金，但不会额外增加你的费用。这有助于资助我们的开源工具评测。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [Grafana 官方 Docker 文档](https://grafana.com/docs/grafana/latest/setup-grafana/installation/docker/)
- [Grafana 预配置指南](https://grafana.com/docs/grafana/latest/administration/provisioning/)
- [Grafana GitHub 仓库](https://github.com/grafana/grafana)
- [LGTM 技术栈架构](https://grafana.com/blog/2024/08/01/lgtm-stack/)
- [Prometheus Node Exporter 仪表盘 #1860](https://grafana.com/grafana/dashboards/1860)
- [Grafana vs Datadog 定价分析 2026](https://tech-insider.org/grafana-vs-datadog-2026/)
- [Datadog 官方定价](https://www.datadoghq.com/pricing/)
- [New Relic 定价](https://newrelic.com/pricing)
- [DigitalOcean — 云 VPS 主机](https://www.digitalocean.com/)
- [HTStack — 托管云服务器](https://htstack.com/)
