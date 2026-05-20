---
title: 'Prometheus: 64,094 GitHub Stars — Docker 部署指南 2026'
description: 'Prometheus（Prom）是一个开源监控系统和时间序列数据库。兼容 Docker、Kubernetes、Grafana 和 Alertmanager。涵盖安装教程、PromQL 查询、生产加固和性能基准测试。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/prometheus/prometheus'
stars: 64094
maintainer: 'prometheus'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['prometheus', '监控', 'docker', 'kubernetes', 'grafana', 'devops', '可观测性', '时间序列']
aliases:
- /zh/posts/prometheus/
---

{{</* resource-info */>}}

## 简介

你的应用又挂了。页面加载缓慢，客户在抱怨，而你的团队完全看不到是数据库卡死了还是 API 层出了问题。这就是监控盲区对生产环境的致命打击。Prometheus —— 云原生计算基金会（CNCF）继 Kubernetes 之后第二个毕业的项目，拥有 **64,094 个 GitHub Stars**，在 DigitalOcean、Uber 和 SoundCloud 等公司经过了实战验证。本文将带你完成一个生产级的 Prometheus Docker 和 Kubernetes 部署，提供真实可用的 PromQL 查询语句和性能数据。

## Prometheus 是什么？

Prometheus 是一个专为云原生环境设计的开源监控系统和时间序列数据库。它于 2012 年在 SoundCloud 创建，灵感来自 Google 的 Borgmon，现已成为容器化和微服务架构中指标收集的事实标准。该项目于 2016 年从 CNCF 毕业，最新稳定版本为 **v3.11.0**（2026 年 4 月），v3.12.0-rc.0 处于预发布状态。

![Prometheus Logo](https://prometheus.io/twitter-image.png?b370f6418ef38b42)

## Prometheus 工作原理

Prometheus 采用**拉取（pull）架构**。不是应用向中央收集器推送指标，而是 Prometheus 按配置间隔主动抓取 HTTP 端点。这种设计简化了服务发现，无需在每个主机上安装代理，并且提供内置的健康检测 —— 如果目标无响应，`up` 指标立即返回 `0`。

核心组件：

| 组件 | 角色 |
|---|---|
| **Prometheus Server** | 抓取指标、存入 TSDB、评估规则 |
| **TSDB** | 自定义时间序列数据库，包含 Head（内存）和 Block（磁盘）层 |
| **Service Discovery** | 通过 Kubernetes API、AWS EC2、Consul、DNS 自动发现目标 |
| **Alertmanager** | 对告警进行去重、分组，并路由到 Slack、PagerDuty、邮件 |
| **Exporters** | 为第三方系统暴露指标的旁路工具 |

![Prometheus 架构](https://storage.ghost.io/c/5f/2f/5f2f4d20-2abf-4534-8d40-7aa233aedd43/content/images/2025/03/image-118-9.png)

数据流：Service Discovery 识别目标，Scraper 通过 HTTP 拉取指标，TSDB 压缩存储样本，Rule Engine 评估告警和记录规则。Alertmanager 处理通知路由，HTTP API 为 Grafana 或内置表达式浏览器提供查询服务。

**关键设计决策：**
- **拉取优于推送**：目标只需暴露 `/metrics`，无需代理配置
- **本地存储**：默认每个 Prometheus 服务器自主运行
- **多维数据模型**：每条指标携带键值标签，支持灵活查询
- **PromQL**：强大的查询语言，支持聚合、速率计算和告警

## 安装与配置

### Docker 部署（单节点，< 5 分钟）

最快启动 Prometheus 的方式是使用 Docker。创建项目目录和两个文件：

**prometheus.yml：**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

**docker-compose.yml：**
```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:v3.11.0
    container_name: prometheus
    ports:
      - "9090:9090"
    volumes:
      - prometheus-data:/prometheus
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'
    restart: unless-stopped

volumes:
  prometheus-data:
```

启动：
```bash
docker compose up -d
```

访问 UI：`http://localhost:9090`。`--web.enable-lifecycle` 标志允许通过 `POST /-/reload` 重载配置而无需重启容器。

### Docker 全栈部署：Prometheus + Grafana + Node Exporter + cAdvisor

完整监控栈配置：

```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:v3.11.0
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus-data:/prometheus
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
      - '--web.enable-lifecycle'
    restart: unless-stopped

  grafana:
    image: grafana/grafana:11.0.0
    ports:
      - "3000:3000"
    volumes:
      - grafana-data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:v1.9.0
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    command:
      - '--path.procfs=/host/proc'
      - '--path.rootfs=/rootfs'
      - '--path.sysfs=/host/sys'
      - '--collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)'
    restart: unless-stopped

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:v0.49.1
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker/:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    ports:
      - "8080:8080"
    restart: unless-stopped

volumes:
  prometheus-data:
  grafana-data:
```

**更新后的 prometheus.yml：**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus:9090']

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']

  - job_name: 'cadvisor'
    static_configs:
      - targets: ['cadvisor:8080']
```

### Kubernetes Helm 部署

生产 Kubernetes 环境使用 `kube-prometheus-stack` Helm 图表：

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

kubectl create namespace monitoring

helm install prometheus prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --set prometheus.prometheusSpec.retention=30d \
  --set prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage=50Gi \
  --set grafana.enabled=true \
  --set grafana.adminPassword='your-secure-password'
```

验证：
```bash
kubectl get pods -n monitoring
```

端口转发：
```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093:9093 -n monitoring
```

### Kubernetes 生产配置

```yaml
prometheus:
  prometheusSpec:
    resources:
      requests:
        memory: 2Gi
        cpu: 500m
      limits:
        memory: 4Gi
        cpu: 2000m
    storageSpec:
      volumeClaimTemplate:
        spec:
          storageClassName: gp3
          accessModes: ["ReadWriteOnce"]
          resources:
            requests:
              storage: 100Gi
    retention: "30d"
    retentionSize: "90GB"
    scrapeInterval: "30s"
    enableAdminAPI: false

alertmanager:
  alertmanagerSpec:
    resources:
      requests:
        memory: 256Mi
        cpu: 100m
      limits:
        memory: 512Mi
        cpu: 500m

grafana:
  enabled: true
  persistence:
    enabled: true
    size: 10Gi
```

应用：
```bash
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring -f values-production.yaml
```

## 与 Docker、Kubernetes、Grafana、Alertmanager 集成

### Prometheus + Grafana 仪表板

Grafana 将 Prometheus 作为数据源连接：

1. 进入 Grafana → Configuration → Data Sources → Add Data Source
2. 选择 **Prometheus**
3. URL：`http://prometheus:9090`（Docker）或 `http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090`（K8s）
4. 点击 **Save & Test**

导入仪表板 ID **1860**（Node Exporter Full）获取完整的主机指标仪表板，或导入 ID **14282** 查看 cAdvisor 容器指标。

![Grafana 仪表板示例](https://prometheus.io/assets/docs/grafana_qps_graph.png)

### Prometheus + Alertmanager 告警规则

创建 `alert-rules.yml`：
```yaml
groups:
  - name: node-alerts
    rules:
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 内存使用率过高"
          description: "内存使用率超过 85%（当前值：{{ $value }}%）"

      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "{{ $labels.instance }} CPU 使用率过高"
          description: "CPU 使用率超过 80%（当前值：{{ $value }}%）"

      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 磁盘空间不足"
          description: "磁盘空间低于 10%（挂载点：{{ $labels.mountpoint }}）"

      - alert: InstanceDown
        expr: up == 0
        for: 3m
        labels:
          severity: critical
        annotations:
          summary: "实例 {{ $labels.instance }} 宕机"
          description: "目标已无法访问超过 3 分钟"

      - alert: HighRequestLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} 请求延迟过高"
          description: "95 分位延迟为 {{ $value }} 秒"
```

### Alertmanager Slack 通知配置

创建 `alertmanager.yml`：
```yaml
global:
  slack_api_url: '你的_SLACK_WEBHOOK_URL'

route:
  receiver: 'slack-notifications'
  group_by: ['alertname', 'severity']
  group_wait: 30s
  group_interval: 5m
  repeat_interval: 4h

receivers:
  - name: 'slack-notifications'
    slack_configs:
      - channel: '#alerts'
        send_resolved: true
        title: '{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'
```

### Kubernetes 服务发现

```yaml
scrape_configs:
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
        namespaces:
          names:
            - default
            - production
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        target_label: __address__
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
```

### PromQL 查询示例

**每秒请求速率：**
```promql
rate(http_requests_total[5m])
```

**95 分位延迟：**
```promql
histogram_quantile(0.95, 
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
)
```

**CPU 使用率百分比：**
```promql
100 - (avg by(instance) (
  irate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100)
```

**内存使用（MB）：**
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / 1024 / 1024
```

**按端点的错误率：**
```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) by (handler) 
/ 
sum(rate(http_requests_total[5m])) by (handler)
```

**磁盘使用预测（7 天内会满吗？）：**
```promql
predict_linear(
  node_filesystem_avail_bytes[1h], 
  7 * 24 * 3600
) < 0
```

## 基准测试 / 实际应用案例

### 摄入性能

| 部署方式 | 每秒样本数 | CPU 核心 | 内存 |
|---|---|---|---|
| Prometheus 单节点 | ~100,000–300,000 | 4 | 2–4 GB |
| Prometheus + Cortex | 1M+ | 集群 | 水平扩展 |
| VictoriaMetrics（单节点） | 最高 1,000,000 | 8 | ~2 GB |
| InfluxDB 3.0 OSS | ~122,000 | 4 | 4–8 GB |
| InfluxDB 1.8 OSS | ~200,000–400,000 | 4 | 4–8 GB |

来源：独立 TSBS 基准测试，2025–2026。Prometheus 以原始摄入吞吐量为代价换取查询灵活性和操作简便性。

### 不同规模资源需求

| 集群规模 | Prometheus CPU | Prometheus 内存 | 存储（30 天） |
|---|---|---|---|
| 小型（< 50 个 pod） | 500m | 1–2 Gi | 20–50 Gi |
| 中型（50–200 个 pod） | 1000m | 2–4 Gi | 50–100 Gi |
| 大型（200–500 个 pod） | 2000m | 4–8 Gi | 100–200 Gi |
| 超大型（500+ 个 pod） | 4000m | 8–16 Gi | 200–500 Gi |

### 实际应用案例

- **DigitalOcean**：使用 Prometheus 联邦模式监控数千台虚拟机和 Kubernetes 集群
- **Uber**：通过 M3DB（Prometheus 兼容）扩展至数十亿时间序列
- **SoundCloud**：Prometheus 的创始者，以最小运营开销监控大规模微服务

## 高级用法 / 生产环境加固

### 安全最佳实践

1. **启用基本认证**（Prometheus v2.24+）：
```yaml
basic_auth_users:
  admin: $2y$10$... # bcrypt 哈希
```

```bash
htpasswd -nBC 10 "" | tr -d ':\n'
```

2. **为抓取目标使用 TLS**：
```yaml
scrape_configs:
  - job_name: 'secure-target'
    scheme: https
    tls_config:
      ca_file: /etc/prometheus/certs/ca.crt
      cert_file: /etc/prometheus/certs/client.crt
      key_file: /etc/prometheus/certs/client.key
      insecure_skip_verify: false
```

3. **网络策略**（Kubernetes）限制哪些 pod 可以访问 Prometheus 的 9090 端口。

4. **以非 root 运行**：官方镜像支持 UID 65534（nobody）。从 v3.10.0 起，distroless 变体使用 UID/GID 65532。

### 扩展策略

- **联邦模式**：全局 Prometheus 从区域 Prometheus 抓取聚合指标
- **远程写入**：将指标流式传输到长期存储（Thanos、Cortex、VictoriaMetrics、Mimir）
- **分片**：按 job 或命名空间将抓取目标拆分到多个 Prometheus 实例
- **高可用**：运行两个相同的 Prometheus 实例抓取相同目标；使用 Thanos Querier 去重

### 监控 Prometheus 自身

```promql
prometheus_tsdb_head_series
prometheus_tsdb_head_chunks
prometheus_rule_evaluation_duration_seconds
prometheus_notifications_dropped_total
```

### Thanos 长期存储

Thanos 通过对象存储（S3、GCS、Azure Blob）扩展 Prometheus 实现长期保留和全局查询：

```yaml
- name: thanos-sidecar
  image: quay.io/thanos/thanos:v0.37.0
  args:
    - sidecar
    - --tsdb.path=/prometheus
    - --objstore.config-file=/etc/thanos/objstore.yml
  volumeMounts:
    - name: prometheus-data
      mountPath: /prometheus
```

## 与替代方案对比

| 特性 | Prometheus | InfluxDB | Datadog | New Relic |
|---|---|---|---|---|
| **许可证** | Apache-2.0 | MIT | 专有 | 专有 |
| **成本** | 免费（自托管） | 免费 OSS / 企业版 $ | $15–$23/主机/月 | $0.25/GB + 用户费 |
| **部署方式** | 自托管、Docker、K8s | 自托管 / 云服务 | 仅 SaaS | 仅 SaaS |
| **数据收集** | 拉取（HTTP 抓取） | 推送（代理/写入 API） | 代理推送 | 代理推送 |
| **查询语言** | PromQL | InfluxQL / Flux / SQL | 自定义 / SQL | NRQL |
| **原生 K8s SD** | 是（内置） | 通过 Telegraf | 是（代理） | 是（代理） |
| **长期存储** | Thanos / Cortex / Mimir | 内置（企业版） | 内置（15 月） | 内置（13 月） |
| **告警功能** | Alertmanager（原生） | Kapacitor / 企业版 | 内置 | 内置 |
| **AI/ML 洞察** | 仅社区插件 | 有限 | 异常检测 | 完整 AI 分析 |
| **单节点摄入** | 100K–300K 样本/秒 | 122K–400K 指标/秒 | N/A（SaaS） | N/A（SaaS） |
| **适用场景** | K8s、基础设施监控、DevOps | IoT、高基数指标 | 企业多云 | APM、AI 驱动运维 |

**选择 Prometheus 的时机**：你运行 Kubernetes，希望完全控制数据，需要避免按主机许可费用，并且有自托管的运维能力。

**选择竞品的时机**：你需要开箱即用的全托管 APM 和分布式追踪（Datadog/New Relic），或者处理高基数 IoT 工作负载。

## 局限性 / 客观评估

Prometheus 并非万能监控方案。提交使用前请注意以下限制：

1. **无原生日志聚合**：Prometheus 处理指标，不处理日志。你需要 Loki、ELK 或 Fluentd 来管理日志。

2. **单节点限制**：单个 Prometheus 服务器每秒可处理约 100,000–300,000 个样本。超出此范围需要联邦或远程写入方案。

3. **无内置长期存储**：默认本地存储受磁盘大小限制。超过数月的保留需要集成外部对象存储。

4. **拉取模式限制**：监控短时批处理作业或无服务器函数需要 Pushgateway 或 OTLP 摄入，增加复杂性。

5. **高基数代价高**：标签组合过多的指标会爆炸内存使用并降低查询性能。

6. **学习曲线**：PromQL 需要投入。熟悉 SQL 的工程师需要时间适应基于向量的查询。

## 常见问题

**Q：Prometheus 和 Grafana 有什么区别？**
A：Prometheus 收集和存储指标；Grafana 将其可视化。它们是互补工具。Prometheus 包含基本表达式浏览器，Grafana 提供仪表板、告警 UI 和多源分析。

**Q：如何用 Prometheus 监控 Python 应用？**
A：使用官方 `prometheus-client` Python 库在应用上暴露 `/metrics` 端点，然后配置 Prometheus 抓取它。Flask 应用使用 `prometheus_flask_exporter`。

**Q：Prometheus 能否实现高可用？**
A：可以，但需要外部方案。运行两个相同的 Prometheus 实例抓取相同目标，使用 Thanos Querier 或 Cortex 去重和全局查询。Prometheus 本身不支持原生集群。

**Q：Prometheus 数据的最大保留期是多少？**
A：本地存储保留可通过 `--storage.tsdb.retention.time` 配置（默认 15 天）。实际限制取决于磁盘大小。多年保留需要使用远程写入到 Thanos、Mimir 或对象存储。

**Q：Prometheus 与 CloudWatch 等云监控方案相比如何？**
A：Prometheus 提供更灵活的查询（PromQL vs CloudWatch Insights）、维度标签且无按指标定价。CloudWatch 与 AWS 服务原生集成且零运维开销。许多团队同时使用两者。

**Q：什么是 recording rules，何时使用？**
A：Recording rules 预计算耗时的 PromQL 表达式并将结果存储为新的时间序列。用于加载缓慢的仪表板或频繁运行的查询。

**Q：Prometheus 适合监控 IoT 设备吗？**
A：仅当设备暴露 HTTP 端点且 Prometheus 服务器可达时。对于间歇连接的边缘/IoT 场景，基于推送的系统如 InfluxDB 更合适。

## 结论

Prometheus 在 2026 年仍是云原生监控的黄金标准。凭借 64,094 个 GitHub Stars、活跃的 CNCF 支持以及持续改进的性能（PromQL 堆分配优化、原生直方图稳定化、Remote Write 2.0），它是基础设施可观测性的安全长期投资。

**行动清单：**
1. 克隆 `kube-prometheus-stack` Helm 图表并部署到测试集群
2. 导入 Grafana 仪表板 1860 获取即时 Node Exporter 可见性
3. 为关键服务编写三个告警规则
4. 加入 [dibi8 Telegram 群组](https://t.me/dibi8) 获取每日开源工具更新和部署技巧

**主机推荐**：在 [DigitalOcean Kubernetes](https://www.digitalocean.com/products/kubernetes)（托管控制平面 $12/月起）上部署 Prometheus，构建经济高效的生产级监控栈。对于专用云资源，查看 [HTStack](https://htstack.com/) 针对容器工作负载优化的托管方案。

*披露：本文包含联盟链接。如果你通过这些链接购买服务，dibi8 可能会获得佣金，不会增加你的额外费用。*



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [Prometheus 官方文档](https://prometheus.io/docs/introduction/overview/)
- [Prometheus GitHub 仓库](https://github.com/prometheus/prometheus)
- [Prometheus 3.0 发布公告](https://prometheus.io/blog/2024/11/14/prometheus-3-0/)
- [kube-prometheus-stack Helm 图表](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Thanos 长期存储](https://thanos.io/)
- [Grafana Prometheus 仪表板](https://grafana.com/grafana/dashboards/?dataSource=prometheus)
- [PromQL 速查表](https://promlabs.com/promql-cheat-sheet/)
- [Prometheus vs InfluxDB 对比](https://uptrace.dev/comparisons/prometheus-vs-influxdb)
- [CNCF Prometheus 项目页面](https://www.cncf.io/projects/prometheus/)
