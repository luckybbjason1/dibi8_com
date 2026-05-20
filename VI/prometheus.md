---
title: 'Prometheus: 64,094 GitHub Stars — Hướng Dẫn Triển Khai Docker 2026'
description: 'Prometheus (Prom) là hệ thống giám sát và cơ sở dữ liệu chuỗi thờ gian mã nguồn mở. Tương thích với Docker, Kubernetes, Grafana và Alertmanager. Bao gồm hướng dẫn cài đặt, truy vấn PromQL, cung cố hóa sản xuất và điểm chuẩn hiệu suất.'
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
tags: ['prometheus', 'giám sát', 'docker', 'kubernetes', 'grafana', 'devops', 'khả năng quan sát', 'chuỗi thờ gian']
aliases:
- /vi/posts/prometheus/
---

{{</* resource-info */>}}

## Giới thiệu

Ứng dụng của bạn lại sập. Trang tải chậm, khách hàng phàn nàn, và nhóm của bạn không có cách nào xác định được là database bị nghẽn hay tầng API đang gặp sự cố. Đây chính là khoảng trống giám sát giết chết sự tự tin vào môi trường production. Prometheus —— dự án thứ hai tốt nghiệp CNCF (sau Kubernetes), với **64,094 sao GitHub** và đã được kiểm chứng tại các công ty như DigitalOcean, Uber và SoundCloud. Hướng dẫn này sẽ đi qua cách thiết lập Prometheus production-grade với Docker và Kubernetes, các truy vấn PromQL thực tế, và các con số cụ thể bạn có thể dùng để bảo vệ lựa chọn công cụ này trước nhóm.

## Prometheus là gì?

Prometheus là hệ thống giám sát mã nguồn mở và cơ sở dữ liệu chuỗi thờ gian được thiết kế cho môi trường cloud-native. Ban đầu được xây dựng tại SoundCloud năm 2012, lấy cảm hứng từ Borgmon của Google, Prometheus đã trở thành tiêu chuẩn de facto cho việc thu thập metrics trong kiến trúc container hóa và microservices. Dự án tốt nghiệp CNCF năm 2016 và tiếp tục phát hành các phiên bản chính —— phiên bản ổn định mới nhất là **v3.11.0** (tháng 4/2026), với v3.12.0-rc.0 đang ở trạng thái pre-release.

![Prometheus Logo](https://prometheus.io/twitter-image.png?b370f6418ef38b42)

## Prometheus hoạt động như thế nào?

Prometheus sử dụng **kiến trúc pull-based**. Thay vì các ứng dụng đẩy metrics đến bộ thu thập trung tâm, Prometheus chủ động scrape các HTTP endpoint theo khoảng thờ gian đã cấu hình. Thiết kế này đơn giản hóa service discovery, loại bỏ nhu cầu cài agent trên mọi host, và cung cấp khả năng phát hiện sức khỏe tích hợp —— nếu một target không phản hồi, metric `up` ngay lập tức báo cáo `0`.

Các thành phần cốt lõi:

| Thành phần | Vai trò |
|---|---|
| **Prometheus Server** | Scrape metrics, lưu trữ vào TSDB, đánh giá rules |
| **TSDB** | Cơ sở dữ liệu chuỗi thờ gian tùy chỉnh với lớp Head (bộ nhớ) và Block (đĩa) |
| **Service Discovery** | Tự động phát hiện target qua Kubernetes API, AWS EC2, Consul, DNS |
| **Alertmanager** | Loại bỏ trùng lặp, nhóm và định tuyến cảnh báo đến Slack, PagerDuty, email |
| **Exporters** | Tiện ích sidecar xuất metrics cho các hệ thống bên thứ ba |

![Kiến trúc Prometheus](https://storage.ghost.io/c/5f/2f/5f2f4d20-2abf-4534-8d40-7aa233aedd43/content/images/2025/03/image-118-9.png)

Luồng dữ liệu: Service Discovery nhận diện target, Scraper pull metrics qua HTTP, TSDB lưu trữ mẫu với nén, và Rule Engine đánh giá alerting và recording rules. Alertmanager xử lý định tuyến thông báo, trong khi HTTP API phục vụ truy vấn cho Grafana hoặc expression browser tích hợp.

**Các quyết định thiết kế chính:**
- **Pull thay vì push**: Target chỉ cần expose `/metrics`; không cần cấu hình agent
- **Lưu trữ cục bộ**: Mỗi Prometheus server hoạt động độc lập theo mặc định
- **Mô hình dữ liệu đa chiều**: Mỗi metric mang nhãn key-value cho phép truy vấn linh hoạt
- **PromQL**: Ngôn ngữ truy vấn mạnh mẽ cho tổng hợp, tính tốc độ, và cảnh báo

## Cài đặt & Thiết lập

### Thiết lập Docker (Single Node, < 5 phút)

Cách nhanh nhất để chạy Prometheus là Docker. Tạo thư mục dự án và hai file:

**prometheus.yml:**
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
```

**docker-compose.yml:**
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

Khởi động stack:
```bash
docker compose up -d
```

Truy cập UI tại `http://localhost:9090`. Flag `--web.enable-lifecycle` cho phép reload cấu hình qua `POST /-/reload` mà không cần khởi động lại container.

### Docker Full Stack: Prometheus + Grafana + Node Exporter + cAdvisor

Để có stack giám sát đầy đủ, thêm Grafana để trực quan hóa và exporters cho metrics host/container:

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

**prometheus.yml cập nhật cho full stack:**
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

### Triển khai Kubernetes với Helm

Cho môi trường Kubernetes production, sử dụng Helm chart `kube-prometheus-stack`:

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

Xác minh triển khai:
```bash
kubectl get pods -n monitoring
```

Port-forward để truy cập cục bộ:
```bash
kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
kubectl port-forward svc/prometheus-grafana 3000:80 -n monitoring
kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093:9093 -n monitoring
```

### Giá trị Production cho Kubernetes

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

Áp dụng:
```bash
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
  -n monitoring -f values-production.yaml
```

## Tích hợp với Docker, Kubernetes, Grafana và Alertmanager

### Prometheus + Grafana Dashboard

Grafana kết nối với Prometheus như một data source:

1. Vào Grafana → Configuration → Data Sources → Add Data Source
2. Chọn **Prometheus**
3. URL: `http://prometheus:9090` (Docker) hoặc `http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090` (K8s)
4. Nhấn **Save & Test**

Import dashboard ID **1860** (Node Exporter Full) cho dashboard metrics host đầy đủ, hoặc ID **14282** cho metrics container cAdvisor.

![Ví dụ Grafana Dashboard](https://prometheus.io/assets/docs/grafana_qps_graph.png)

### Prometheus + Alertmanager Alerting Rules

Tạo `alert-rules.yml`:
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
          summary: "{{ $labels.instance }} sử dụng bộ nhớ cao"
          description: "Mức sử dụng bộ nhớ trên 85% (giá trị hiện tại: {{ $value }}%)"

      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "{{ $labels.instance }} sử dụng CPU cao"
          description: "Mức sử dụng CPU trên 80% (giá trị hiện tại: {{ $value }}%)"

      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes / node_filesystem_size_bytes) * 100 < 10
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} dung lượng đĩa thấp"
          description: "Dung lượng đĩa dưới 10% (mountpoint: {{ $labels.mountpoint }})"

      - alert: InstanceDown
        expr: up == 0
        for: 3m
        labels:
          severity: critical
        annotations:
          summary: "Instance {{ $labels.instance }} đã down"
          description: "Target không thể truy cập trong hơn 3 phút"

      - alert: HighRequestLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 0.5
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "{{ $labels.instance }} độ trễ yêu cầu cao"
          description: "Phân vị 95 độ trễ là {{ $value }} giây"
```

### Cấu hình Alertmanager cho Slack

Tạo `alertmanager.yml`:
```yaml
global:
  slack_api_url: 'YOUR_SLACK_WEBHOOK_URL'

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

### Prometheus + Kubernetes Service Discovery

Prometheus tự động phát hiện target Kubernetes:
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

### Ví dụ truy vấn PromQL

**Tính tốc độ yêu cầu mỗi giây:**
```promql
rate(http_requests_total[5m])
```

**Độ trễ phân vị 95:**
```promql
histogram_quantile(0.95, 
  sum(rate(http_request_duration_seconds_bucket[5m])) by (le)
)
```

**Tỷ lệ sử dụng CPU:**
```promql
100 - (avg by(instance) (
  irate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100)
```

**Sử dụng bộ nhớ (MB):**
```promql
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / 1024 / 1024
```

**Tỷ lệ lỗi theo endpoint:**
```promql
sum(rate(http_requests_total{status=~"5.."}[5m])) by (handler) 
/ 
sum(rate(http_requests_total[5m])) by (handler)
```

**Dự đoán đĩa đầy (trong 7 ngày?):**
```promql
predict_linear(
  node_filesystem_avail_bytes[1h], 
  7 * 24 * 3600
) < 0
```

## Điểm chuẩn / Trường hợp sử dụng thực tế

### Hiệu suất ingestion

| Thiết lập | Samples/giây | CPU Cores | Bộ nhớ |
|---|---|---|---|
| Prometheus single-node | ~100,000–300,000 | 4 | 2–4 GB |
| Prometheus + Cortex | 1M+ | Cluster | Mở rộng ngang |
| VictoriaMetrics (single) | Lên đến 1,000,000 | 8 | ~2 GB |
| InfluxDB 3.0 OSS | ~122,000 | 4 | 4–8 GB |
| InfluxDB 1.8 OSS | ~200,000–400,000 | 4 | 4–8 GB |

Nguồn: Benchmark TSBS độc lập, 2025–2026. Prometheus đánh đổi thông lượng ingestion thô để lấy tính linh hoạt truy vấn và sự đơn giản vận hành.

### Nhu cầu tài nguyên theo quy mô

| Quy mô Cluster | Prometheus CPU | Prometheus RAM | Lưu trữ (30 ngày) |
|---|---|---|---|
| Nhỏ (< 50 pod) | 500m | 1–2 Gi | 20–50 Gi |
| Vừa (50–200 pod) | 1000m | 2–4 Gi | 50–100 Gi |
| Lớn (200–500 pod) | 2000m | 4–8 Gi | 100–200 Gi |
| Rất lớn (500+ pod) | 4000m | 8–16 Gi | 200–500 Gi |

### Trường hợp sử dụng thực tế

- **DigitalOcean**: Giám sát hàng nghìn VM và cluster Kubernetes bằng federation Prometheus
- **Uber**: Mở rộng đến hàng tỷ chuỗi thờ gian với M3DB (tương thích Prometheus)
- **SoundCloud**: Ngườ tạo ra Prometheus; giám sát microservices quy mô lớn với overhead vận hành tối thiểu

## Sử dụng nâng cao / Cung cố hóa Production

### Thực hành bảo mật tốt nhất

1. **Bật Basic Authentication** (Prometheus v2.24+):
```yaml
basic_auth_users:
  admin: $2y$10$... # bcrypt hash
```

```bash
htpasswd -nBC 10 "" | tr -d ':\n'
```

2. **Sử dụng TLS cho target scrape:**
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

3. **Network policies** (Kubernetes) hạn chế pod nào có thể truy cập port 9090 của Prometheus.

4. **Chạy non-root**: Image chính thức hỗ trợ UID 65534 (nobody). Từ v3.10.0, biến thể distroless sử dụng UID/GID 65532.

### Chiến lược mở rộng

- **Federation**: Prometheus global scrape metrics tổng hợp từ các Prometheus regional
- **Remote Write**: Stream metrics đến lưu trữ dài hạn (Thanos, Cortex, VictoriaMetrics, Mimir)
- **Sharding**: Chia target scrape qua nhiều instance Prometheus theo job hoặc namespace
- **High Availability**: Chạy hai Prometheus instance giống hệt nhau scrape cùng target; dùng Thanos Querier để loại bỏ trùng lặp

### Tự giám sát Prometheus

```promql
prometheus_tsdb_head_series
prometheus_tsdb_head_chunks
prometheus_rule_evaluation_duration_seconds
prometheus_notifications_dropped_total
```

### Lưu trữ dài hạn với Thanos

Thanos mở rộng Prometheus với object storage (S3, GCS, Azure Blob) cho retention dài hạn và querying toàn cục:

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

## So sánh với các lựa chọn thay thế

| Tính năng | Prometheus | InfluxDB | Datadog | New Relic |
|---|---|---|---|---|
| **Giấy phép** | Apache-2.0 | MIT | Độc quyền | Độc quyền |
| **Chi phí** | Miễn phí (tự host) | Miễn phí OSS / Enterprise $ | $15–$23/host/tháng | $0.25/GB + phí user |
| **Triển khai** | Tự host, Docker, K8s | Tự host / Cloud | Chỉ SaaS | Chỉ SaaS |
| **Thu thập dữ liệu** | Pull (HTTP scrape) | Push (agent/write API) | Agent-based push | Agent-based push |
| **Ngôn ngữ truy vấn** | PromQL | InfluxQL / Flux / SQL | Custom / SQL | NRQL |
| **Native K8s SD** | Có (built-in) | Qua Telegraf | Có (agent) | Có (agent) |
| **Lưu trữ dài hạn** | Thanos / Cortex / Mimir | Built-in (Enterprise) | Built-in (15 tháng) | Built-in (13 tháng) |
| **Cảnh báo** | Alertmanager (native) | Kapacitor / Enterprise | Built-in | Built-in |
| **AI/ML Insights** | Chỉ community plugins | Hạn chế | Phát hiện bất thường | Phân tích AI đầy đủ |
| **Ingestion (1 node)** | 100K–300K samples/giây | 122K–400K metrics/giây | N/A (SaaS) | N/A (SaaS) |
| **Phù hợp cho** | K8s, giám sát hạ tầng, DevOps | IoT, high-cardinality metrics | Enterprise multi-cloud | APM, AI-driven ops |

**Khi chọn Prometheus**: Bạn chạy Kubernetes, muốn kiểm soát hoàn toàn dữ liệu, cần tránh chi phí license theo host, và có năng lực vận hành tự host.

**Khi chọn đối thủ cạnh tranh**: Bạn cần APM fully-managed với distributed tracing out-of-the-box (Datadog/New Relic), hoặc xử lý workload IoT high-cardinality.

## Hạn chế / Đánh giá trung thực

Prometheus không phải giải pháp giám sát vạn năng. Hãy lưu ý các ràng buộc sau:

1. **Không có log aggregation native**: Prometheus xử lý metrics, không phải logs. Bạn cần Loki, ELK hoặc Fluentd cho quản lý log.

2. **Hạn chế single-node**: Một Prometheus server có thể xử lý khoảng 100,000–300,000 samples/giây tùy phần cứng. Vượt quá cần federation hoặc remote-write.

3. **Không có long-term storage built-in**: Lưu trữ cục bộ mặc định bị giới hạn bởi kích thước đĩa. Để giữ quá vài tháng, phải tích hợp object storage bên ngoài.

4. **Hạn chế pull model**: Giám sát batch jobs ngắn hạn hoặc serverless functions cần Pushgateway hoặc OTLP ingestion —— tăng độ phức tạp.

5. **High cardinality đắt đỏ**: Metrics với quá nhiều label combination có thể làm bùng nổ bộ nhớ và giảm hiệu suất truy vấn.

6. **Đường cong học tập**: PromQL đòi hỏi đầu tư. Kỹ sư quen với SQL cần thờ gian để thích nghi với truy vấn vector-based.

## Câu hỏi thường gặp

**Q: Sự khác biệt giữa Prometheus và Grafana là gì?**
A: Prometheus thu thập và lưu trữ metrics; Grafana trực quan hóa chúng. Chúng là công cụ bổ sung, không phải đối thủ cạnh tranh.

**Q: Làm thế nào để giám sát ứng dụng Python với Prometheus?**
A: Sử dụng thư viện `prometheus-client` Python chính thức để expose endpoint `/metrics`, sau đó cấu hình Prometheus scrape nó.

**Q: Prometheus có thể xử lý high availability không?**
A: Có, nhưng cần giải pháp bên ngoài. Chạy hai Prometheus instance giống hệt nhau scrape cùng target, dùng Thanos Querier hoặc Cortex để loại bỏ trùng lặp.

**Q: Thờ gian retention tối đa cho dữ liệu Prometheus là bao nhiêu?**
A: Cấu hình qua `--storage.tsdb.retention.time` (mặc định 15 ngày). Để giữ nhiều năm, dùng remote write đến Thanos, Mimir hoặc object storage.

**Q: Prometheus so với giải pháp giám sát cloud như CloudWatch?**
A: Prometheus cung cấp truy vấn linh hoạt hơn (PromQL vs CloudWatch Insights), dimensional labels, và không tính phí theo metric. CloudWatch tích hợp native với AWS và zero operational overhead.

**Q: Recording rules là gì và khi nào nên dùng?**
A: Recording rules tính toán trước các biểu thức PromQL tốn kém và lưu kết quả như time series mới. Dùng cho dashboard tải chậm hoặc truy vấn chạy thường xuyên.

**Q: Prometheus có phù hợp giám sát thiết bị IoT không?**
A: Chỉ khi thiết bị expose HTTP endpoint và Prometheus server có thể truy cập. Cho edge/IoT với kết nối không ổn định, hệ thống push-based như InfluxDB phù hợp hơn.

## Kết luận

Prometheus vẫn là tiêu chuẩn vàng cho giám sát cloud-native năm 2026. Với 64,094 sao GitHub, sự hỗ trợ CNCF tích cực, và chu kỳ phát hành liên tục cải thiện hiệu suất, đây là khoản đầu tư an toàn dài hạn cho khả năng quan sát hạ tầng.

**Các hành động:**
1. Clone Helm chart `kube-prometheus-stack` và triển khai lên cluster staging
2. Import Grafana dashboard 1860 cho tầm nhìn Node Exporter tức thì
3. Viết ba alerting rule cho các dịch vụ quan trọng
4. Tham gia [nhóm Telegram dibi8](https://t.me/dibi8) để cập nhật công cụ mã nguồn mở và mẹo triển khai

**Khuyến nghị hosting**: Triển khai Prometheus trên [DigitalOcean Kubernetes](https://www.digitalocean.com/products/kubernetes) ($12/tháng cho control plane được quản lý) để có monitoring stack production-grade tiết kiệm chi phí. Để tìm cloud server giá rẻ, hãy xem [虎网云](https://www.虎网云.com/) với các gói hosting tối ưu cho workload container.

*Tiết lộ: Bài viết này chứa liên kết liên kết. Nếu bạn mua dịch vụ qua các liên kết này, dibi8 có thể nhận được hoa hồng mà không phát sinh chi phí thêm cho bạn.*



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [Prometheus Documentation chính thức](https://prometheus.io/docs/introduction/overview/)
- [Prometheus GitHub Repository](https://github.com/prometheus/prometheus)
- [Prometheus 3.0 Release Announcement](https://prometheus.io/blog/2024/11/14/prometheus-3-0/)
- [kube-prometheus-stack Helm Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Thanos Long-term Storage](https://thanos.io/)
- [Grafana Dashboards cho Prometheus](https://grafana.com/grafana/dashboards/?dataSource=prometheus)
- [PromQL Cheat Sheet](https://promlabs.com/promql-cheat-sheet/)
- [Prometheus vs InfluxDB So sánh](https://uptrace.dev/comparisons/prometheus-vs-influxdb)
- [CNCF Prometheus Project Page](https://www.cncf.io/projects/prometheus/)
