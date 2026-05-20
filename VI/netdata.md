---
title: 'Netdata: Giám Sát Thở Gian Thự 78K+ Star — Hướng Dẫn Tinh Chỉnh Hiệu Suất 2026'
description: 'Netdata (ND) là agent giám sát thở gian thực hiệu suất cao với metrics từng giây và khả năng trực quan hóa. Tương thích với Docker, Kubernetes, Prometheus và Grafana. Bao gồm hướng dẫn netdata, cài đặt netdata, giám sát thở gian thực, netdata vs prometheus, và tinh chỉnh hiệu suất netdata.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: GPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/netdata/netdata'
stars: 78874
maintainer: 'netdata'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['netdata', 'giám-sát', 'khả-năng-quan-sát', 'tinh-chỉnh-hiệu-suất', 'docker', 'kubernetes', 'metrics-thở-gian-thự']
aliases:
- /vi/posts/netdata/
---

{{</* resource-info */>}}

## Giới thiệu

Hầu hết các công cụ giám sát chỉ hiển thị những gì đã xảy ra cách đây 30 giây. Khi đó, cơn bùng phát vi mô (microburst) đã giết chết connection pool của cơ sở dữ liệu đã biến mất — chỉ để lại một dòng log khó hiểu và một pager đang reo. Netdata loại bỏ khoảng trống này bằng metrics từng giây, độ trễ trực quan hóa dưới 2 giây, và một binary duy nhất cài đặt trong vòng 60 giây. Với 78.874 Star trên GitHub và giấy phép GPL-3.0, Netdata là một trong những agent giám sát mã nguồn mở phổ biến nhất trong môi trường production hiện nay. Hướng dẫn này đi qua toàn bộ thiết lập Netdata — từ triển khai Docker một node đến cluster Kubernetes streaming — với các cấu hình tinh chỉnh hiệu suất thực tế có thể áp dụng ngay lập tức.

## Netdata là gì?

Netdata là một agent giám sát thở gian thực phân tán, thu thập, lưu trữ và trực quan hóa metrics hệ thống và ứng dụng với độ chi tiết từng giây. Khác với các hệ thống polling truyền thống lấy mẫu mỗi 15–60 giây, Netdata chạy trực tiếp trên mỗi node, thu thập hàng nghìn metrics cục bộ và stream chúng đến các node trung tâm khi cần. Được viết bằng C (54.2%), Go (29%) và Rust (8.5%), nó được thiết kế để tiêu thụ tài nguyên tối thiểu: dưới 5% CPU và khoảng 150 MB RAM mỗi node trong cấu hình mặc định.

## Netdata hoạt động như thế nào

Kiến trúc của Netdata tuân theo mô hình phân tán ưu tiên edge. Mỗi node chạy một agent độc lập tự động phát hiện 800+ tích hợp mà không cần tệp cấu hình.

![Kiến trúc Netdata](https://raw.githubusercontent.com/netdata/netdata/master/web/gui/images/netdata.svg)

![Tổng quan Dashboard Netdata](https://user-images.githubusercontent.com/24860547/201481889-0cf8e192-683f-4a80-9b96-4f69dd85490f.png)

**Các thành phần cốt lõi:**

- **Lớp Thu Thập Dữ Liệu**: Bộ thu thập tích hợp cho CPU, bộ nhớ, đĩa, mạng, container, cơ sở dữ liệu và ứng dụng. Không cần phụ thuộc bên ngoài như Telegraf hay Exporter.
- **Cơ Sở Dữ Liệu (dbengine)**: Kho lưu trữ time-series hiệu suất cao tùy chỉnh sử dụng ~0.5 byte mỗi mẫu với lưu trữ phân tầng cho việc giữ liệu dài hạn.
- **Phát Hiện Bất Thường ML**: 18 mô hình ML không giám sát trên mỗi metric chạy tại edge, đạt được phát hiện bất thường dựa trên đồng thuận với mức giảm 99% cảnh báo giả.
- **Streaming & Parent-Child**: Bất kỳ agent nào cũng có thể đóng vai trò "parent" để tổng hợp metrics từ các node con, cho phép mở rộng ngang mà không cần điểm nghẽn trung tâm.
- **Web Dashboard**: Máy chủ web tĩnh nhúng phục vụ biểu đồ thở gian thực trực tiếp từ agent trên cổng 19999.

## Cài đặt & Thiết lập

### Cài đặt Một Dòng Lệnh (Linux)

Cách nhanh nhất để chạy Netdata:

```bash
# Cài đặt Netdata với tất cả giá trị mặc định
curl -Ss https://get.netdata.cloud/kickstart.sh | sudo bash
```

Xác minh cài đặt:

```bash
sudo systemctl status netdata
# Active: active (running) since ...
```

Truy cập dashboard cục bộ tại `http://localhost:19999`.

### Triển khai Docker

Cho môi trường container:

```bash
docker run -d --name=netdata \
  -p 19999:19999 \
  -v /proc:/host/proc:ro \
  -v /sys:/host/sys:ro \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  --cap-add SYS_PTRACE \
  --security-opt apparmor=unconfined \
  netdata/netdata:latest
```

### Docker Compose (Sẵn sàng Production)

```yaml
version: '3.8'
services:
  netdata:
    image: netdata/netdata:v2.5.0
    container_name: netdata
    hostname: "netdata-${HOSTNAME}"
    ports:
      - "19999:19999"
    restart: unless-stopped
    cap_add:
      - SYS_PTRACE
      - SYS_ADMIN
    security_opt:
      - apparmor:unconfined
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /etc/os-release:/host/etc/os-release:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - netdata-config:/etc/netdata
      - netdata-lib:/var/lib/netdata
      - netdata-cache:/var/cache/netdata
    environment:
      - NETDATA_CLAIM_TOKEN=${NETDATA_CLAIM_TOKEN}
      - NETDATA_CLAIM_URL=https://app.netdata.cloud
      - NETDATA_CLAIM_ROOMS=${NETDATA_CLAIM_ROOMS}
volumes:
  netdata-config:
  netdata-lib:
  netdata-cache:
```

![Giao diện Giám sát Hệ thống Netdata](https://hackmag.com/wp-content/uploads/2025/07/10244_02-16-39.png)

### Cài đặt Kubernetes Helm

```bash
# Thêm kho lưu trữ Helm của Netdata
helm repo add netdata https://netdata.github.io/helmchart/
helm repo update

# Cài đặt với giá trị mặc định
helm install netdata netdata/netdata \
  --namespace monitoring \
  --create-namespace
```

Xác minh các pod:

```bash
kubectl get pods -n monitoring
# NAME                    READY   STATUS
# netdata-parent-0        1/1     Running
# netdata-child-xxx       1/1     Running
```

### Tạo Cấu hình Hiện tại

Tải xuống cấu hình đang chạy để tùy chỉnh:

```bash
# Tải xuống cấu hình hiện tại đang áp dụng
curl -o /etc/netdata/netdata.conf http://localhost:19999/netdata.conf
# Hoặc sử dụng script edit-config
sudo /etc/netdata/edit-config netdata.conf
```

## Tích hợp với các công cụ phổ biến

### Prometheus Remote Write

Xuất metrics Netdata sang Prometheus để lưu trữ dài hạn và truy vấn PromQL:

```bash
sudo /etc/netdata/edit-config exporting.conf
```

```conf
[prometheus:remote_write]
    enabled = yes
    destination = prometheus:9090
    remote write URL path = /api/v1/write
    data source = average
    prefix = netdata
    send charts matching = *
    send hosts matching = *
```

Khởi động lại Netdata:

```bash
sudo systemctl restart netdata
```

### Grafana Dashboard

Mặc dù Netdata có dashboard tích hợp, nhiều team thích Grafana để trực quan hóa tập trung. Thêm Netdata làm nguồn dữ liệu Prometheus trong Grafana:

```yaml
# datasource.yaml trong Grafana
apiVersion: 1
datasources:
  - name: Netdata-Prometheus
    type: prometheus
    url: http://netdata:19999/api/v1/allmetrics?format=prometheus
    access: proxy
    isDefault: false
    jsonData:
      timeInterval: "1s"
```

### Kubernetes DaemonSet (Nâng cao)

Để có khả năng hiển thị ở cấp host trên mọi node K8s:

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: netdata
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: netdata
  template:
    metadata:
      labels:
        app: netdata
    spec:
      hostNetwork: true
      hostPID: true
      containers:
        - name: netdata
          image: netdata/netdata:v2.5.0
          ports:
            - containerPort: 19999
              hostPort: 19999
          securityContext:
            capabilities:
              add: [SYS_PTRACE, SYS_ADMIN]
          volumeMounts:
            - name: proc
              mountPath: /host/proc
              readOnly: true
            - name: sys
              mountPath: /host/sys
              readOnly: true
            - name: docker-sock
              mountPath: /var/run/docker.sock
              readOnly: true
      volumes:
        - name: proc
          hostPath:
            path: /proc
        - name: sys
          hostPath:
            path: /sys
        - name: docker-sock
          hostPath:
            path: /var/run/docker.sock
```

### Giám sát PostgreSQL

Bật bộ thu thập PostgreSQL trong `go.d/postgres.conf`:

```yaml
jobs:
  - name: local
    dsn: 'postgres://netdata_monitor:password@localhost:5432/postgres'
    collect:
      - database_statistics
      - table_statistics
      - index_statistics
      - replication_statistics
    timeout: 2
```

Kiểm tra bộ thu thập:

```bash
sudo /etc/netdata/edit-config go.d/postgres.conf
# Khởi động lại để áp dụng
sudo systemctl restart netdata
```

### Giám sát Nginx

Giám sát stub_status và access log của Nginx:

```yaml
# /etc/netdata/go.d/nginx.conf
jobs:
  - name: local
    url: http://localhost/stub_status

  - name: access_log
    path: /var/log/nginx/access.log
    parser:
      type: ltsv
```

## Benchmarks / Các trường hợp sử dụng thực tế

### So sánh mức tiêu thụ tài nguyên

Đại học Amsterdam đã công bố một nghiên cứu có bình duyệt (ICSOC 2023), xếp Netdata là công cụ giám sát tiết kiệm năng lượng nhất cho hệ thống dựa trên Docker. Các benchmark độc lập xác nhận:

| Kịch bản | Netdata | Prometheus + Node Exporter | Zabbix Agent |
|----------|---------|---------------------------|--------------|
| Chi phí CPU (%) | 1–5% | 5–15% | 10–20% |
| RAM mỗi Node | 100–150 MB | 200–500 MB | 150–300 MB |
| Khoảng cách thu thập | 1 giây | 15–60 giây | 30–60 giây |
| Thở gian khởi động | < 60 giây | 30–60 phút | 2–4 giờ |
| Số metrics mỗi node | 2.000+ | 500–1.000 | 1.000–2.000 |
| Cấu hình cần thiết | Không | Trung bình | Nhiều |

### Benchmarks mở rộng streaming

Kiến trúc streaming parent-child của Netdata mở rộng theo chiều ngang:

- **Một Parent**: Tiêu thụ 1 triệu+ mẫu/giây, RAM khoảng 3,5 GB
- **10 Node con**: 20k metrics mỗi node, giữ liệu 1 giây trong 7 ngày, đĩa 12 GB
- **Cluster Active-Active**: Mở rộng ngang không giới hạn với sao lưu dữ liệu đầy đủ
- **Node tạm thở**: Stream metrics đến parent, giữ liệu sau khi node bị hủy

### Triển khai thực tế: Cluster K8s 500 Node

Một công ty SaaS cỡ trung chạy 500 node Kubernetes sử dụng:

- 5 Netdata parent (active-active) trên 3 vùng availability
- 500 agent con qua DaemonSet, mỗi node chạy ở chế độ RAM (~50 MB)
- Lưu trữ phân tầng: 1 giây trong 7 ngày, 1 phút trong 1 tháng, 1 giờ trong 1 năm
- Tổng dung lượng parent: 25 GB mỗi parent (125 GB toàn cluster)
- Định tuyến cảnh báo qua Netdata Cloud đến PagerDuty và Slack

## Sử dụng nâng cao / Củng cố production

### Tinh chỉnh hiệu suất: netdata.conf

Cấu hình mặc định được tối ưu cho sử dụng độc lập. Đối với hệ thống production, điều chỉnh cơ sở dữ liệu và vô hiệu hóa các bộ thu thập không cần thiết.

**Dấu chân tối thiểu (node con production):**

```conf
[global]
    # Chạy với mức ưu tiên thấp nhất để tránh ảnh hưởng ứng dụng
    process scheduling policy = batch
    process nice level = 19
    # Giảm số luồng trên các node bị hạn chế
    libuv worker threads = 4

[db]
    # Sử dụng chế độ RAM cho node con streaming đến parent
    mode = ram
    retention = 3600
    # Một tầng là đủ cho bộ đệm cục bộ
    storage tiers = 1

[ml]
    # Vô hiệu hóa ML trên node con — chạy trên parent
    enabled = no

[health]
    # Vô hiệu hóa cảnh báo cục bộ trên node con
    enabled = no

[web]
    # Chỉ bind localhost để bảo mật
    bind to = 127.0.0.1
    allow connections from = localhost

[plugins]
    # Vô hiệu hóa bộ thu thập không dùng để giảm CPU/RAM
    ebpf = no
    perf = no
    nfacct = no
    fping = no
    ioping = no
    tc = no
    idlejitter = no
    debugfs = no
    systemd-journal = no
```

**Node parent với lưu trữ phân tầng (giám sát trung tâm):**

```conf
[db]
    mode = dbengine
    storage tiers = 3
    dbengine page cache size = 1.4GiB

    # Tầng 0: độ phân giải 1 giây, 7 ngày
    update every = 1
    dbengine tier 0 retention size = 12GiB
    dbengine tier 0 retention time = 7d

    # Tầng 1: độ phân giải 1 phút, 1 tháng
    dbengine tier 1 update every iterations = 60
    dbengine tier 1 retention size = 4GiB
    dbengine tier 1 retention time = 1mo

    # Tầng 2: độ phân giải 1 giờ, 1 năm
    dbengine tier 2 update every iterations = 60
    dbengine tier 2 retention size = 2GiB
    dbengine tier 2 retention time = 1y

[ml]
    enabled = yes
    # 18 mô hình ML mỗi metric, huấn luyện mỗi 3 giờ
    train every = 10800
    number of models per dimension = 18

[health]
    enabled = yes
    # Kiểm tra sức khỏe mỗi 10 giây
    run at least every seconds = 10

[web]
    # Mở cho mạng để truy cập dashboard
    bind to = *
    # Hạn chế truy cập mạng nội bộ
    allow connections from = 10.* 192.168.* 172.16.* 172.17.*
```

### Cấu hình Streaming: stream.conf

Trên node con (`/etc/netdata/stream.conf`):

```conf
[stream]
    enabled = yes
    destination = tcp:netdata-parent.monitoring.svc.cluster.local:19999
    api key = YOUR_API_KEY_HERE
    timeout seconds = 60
    default port = 19999
    send charts matching = *
    buffer size bytes = 1048576
    reconnect delay seconds = 5
    initial clock resync iterations = 60
```

Trên parent (`/etc/netdata/stream.conf`):

```conf
[API_KEY]
    enabled = yes
    default memory mode = dbengine
    health enabled by default = yes
```

### Củng cố bảo mật

Bật TLS cho giao diện web:

```conf
[web]
    tls version = 1.3
    ssl key = /etc/netdata/ssl/key.pem
    ssl certificate = /etc/netdata/ssl/cert.pem
    # Yêu cầu TLS cho mọi kết nối
    bind to = *=dashboard|registry|badges|management|streaming|netdata.conf|readable|writable
```

### Giám sát chính Netdata

Theo dõi mức sử dụng tài nguyên của chính agent:

```bash
# Xem metrics nội bộ
curl -s http://localhost:19999/api/v1/info | jq '.version, .hog'

# Kiểm tra thống kê dbengine
curl -s http://localhost:19999/api/v1/data?chart=netdata.dbengine_main_page_stats
```

## So sánh với các giải pháp thay thế

| Tính năng | Netdata | Prometheus | Datadog | Zabbix |
|-----------|---------|------------|---------|--------|
| Khoảng cách thu thập | 1 giây | 15–60 giây | 15 giây | 30–60 giây |
| RAM Agent | 100–150 MB | 200–500 MB | 200–400 MB | 150–300 MB |
| CPU Agent | 1–5% | 5–15% | 3–8% | 10–20% |
| Thở gian thiết lập | < 60 giây | 30–60 phút | 10–20 phút | 2–4 giờ |
| Tự động phát hiện | 800+ tích hợp | Hạn chế | 600+ tích hợp | Dựa trên template |
| Dashboard tích hợp | Có (thở gian thực) | Không (chỉ PromQL) | Có | Có (cũ) |
| Phát hiện bất thường ML | 18 mô hình/metric | Không (cần thêm) | Có | Hạn chế |
| Lưu trữ dài hạn | dbengine phân tầng | Mặc định 15 ngày | Đám mây | DB bên ngoài |
| Giấy phép | GPL-3.0 (miễn phí) | Apache-2.0 (miễn phí) | $15/host/tháng | GPL-2.0 (miễn phí) |
| Định tuyến cảnh báo | Tích hợp + Cloud | Alertmanager | Tích hợp | Tích hợp |
| Hỗ trợ K8s Native | Có (Helm chart) | Có (operator) | Có (operator) | Hạn chế |

**Khi nào chọn cái nào:**

- **Netdata**: Khả năng hiển thị từng node, xử lý sự cố thở gian thực, môi trường hạn chế tài nguyên, các team cần giám sát zero-config.
- **Prometheus**: Tổng hợp metric cloud-native, truy vấn PromQL phức tạp, lưu trữ dài hạn với Thanos/VictoriaMetrics.
- **Datadog**: Khả năng quan sát toàn doanh nghiệp (metrics + log + trace + APM), SaaS được quản lý với tuân thủ SOC 2.
- **Zabbix**: Hạ tầng hỗn hợp (thiết bị mạng + máy chủ + SNMP), tổ chức cần giám sát agent + agentless.

## Hạn chế / Đánh giá khách quan

Netdata không phải công cụ phù hợp cho mọi kịch bản giám sát:

1. **Không có chế độ xem multi-host tập trung nếu không có Netdata Cloud**: Dashboard agent mã nguồn mở là theo từng node. Để xem thống nhất trên 100+ node, bạn cần Netdata Cloud (SaaS) hoặc thiết lập parent streaming với công cụ trực quan hóa bên ngoài.
2. **Lưu trữ dài hạn hạn chế trong cấu hình mặc định**: dbengine mặc định ~256 MB đĩa mỗi tầng. Để giữ liệu nhiều năm ở quy mô lớn, cần cấu hình lưu trữ phân tầng rõ ràng hoặc TSDB bên ngoài như VictoriaMetrics.
3. **Pipeline cảnh báo ít linh hoạt hơn Alertmanager**: Mặc dù Netdata có kiểm tra sức khỏe và thông báo tích hợp, nhưng cây định tuyến phức tạp, tắt tiếng và luân phiên on-call cần Netdata Cloud hoặc tích hợp với PagerDuty/OpsGenie.
4. **Không phải nền tảng quan sát toàn diện**: Netdata tập trung vào metrics. Để tracing phân tán, logging có cấu trúc và APM, hãy kết hợp với Jaeger, Loki hoặc OpenTelemetry.
5. **Hỗ trợ Windows còn mới**: Agent Windows hoạt động được nhưng có ít bộ thu thập hơn Linux. Với môi trường chủ yếu Windows, hãy xác minh phạm vi bộ thu thập trước khi triển khai.

## Các câu hỏi thường gặp

**Q: Netdata thực sự sử dụng bao nhiêu RAM trong production?**

Trên node con streaming đến parent, khoảng 50 MB với cấu hình chế độ RAM ở trên. Trên parent lưu 7 ngày dữ liệu 1 giây cho 10 node, kỳ vọng 2.5–3.5 GB RAM với bộ nhớ cache 1.4 GB. Agent tự động điều chỉnh kích thước cache dựa trên bộ nhớ hệ thống khả dụng.

**Q: Tôi có thể chạy Netdata mà không cần Netdata Cloud không?**

Có. Agent mã nguồn mở hoạt động đầy đủ mà không cần kết nối cloud nào. Sử dụng streaming parent-child để tổng hợp tập trung và truy cập dashboard trực tiếp trên bất kỳ agent nào tại cổng 19999. Netdata Cloud bổ sung dashboard thống nhất, ứng dụng di động và định tuyến cảnh báo nâng cao nhưng không bắt buộc.

**Q: Netdata so với Prometheus + Grafana như thế nào?**

Netdata xuất sắc ở khả năng hiển thị từng node thở gian thực với zero cấu hình. Prometheus xuất sắc ở tổng hợp metrics trên các cluster động, tạm thở với PromQL. Nhiều team chạy cả hai: Netdata trên mọi node để xử lý sự cố thở gian thực, Prometheus để tổng hợp cấp cluster và phân tích xu hướng dài hạn. Netdata có thể xuất metrics sang Prometheus qua định dạng OpenMetrics.

**Q: Netdata có thể xử lý quy mô tối đa bao nhiêu?**

Một node parent duy nhất có thể tiêu thụ 1 triệu+ mẫu/giây. Để mở rộng ngang, hãy triển khai cluster parent active-active. Không có giới hạn lý thuyết — kiến trúc được thiết kế phân tán theo mặc định. Netdata Cloud SaaS xử lý hàng triệu node.

**Q: Làm thế nào để sao lưu cơ sở dữ liệu và cấu hình của Netdata?**

Cấu hình nằm trong `/etc/netdata/` và có thể được quản lý phiên bản (Git, Ansible, Puppet). Cơ sở dữ liệu dbengine trong `/var/cache/netdata/` có khả năng tự phục hồi và không cần sao lưu thủ công — streaming đến nhiều node parent cung cấp sự dự phòng tự nhiên. Với môi trường quan trọng, hãy chạy cặp parent active-active.

**Q: Netdata có hỗ trợ metrics ứng dụng tùy chỉnh không?**

Có. Sử dụng máy chủ StatsD tích hợp (cổng 8125), endpoint OpenMetrics, hoặc viết bộ thu thập tùy chỉnh bằng Python hoặc Go. Framework `go.d.plugin` hỗ trợ xây dựng bộ thu thập mới với mã mẫu tối thiểu.

## Kết luận

Netdata thực hiện đúng lợi hứa mà hầu hết công cụ giám sát không thể: khả năng hiển thị từng giây, tức thở với mức tiêu thụ tài nguyên không đáng kể. Đối với các team vận hành hạ tầng Docker, Kubernetes hoặc bare-metal, đây là con đường nhanh nhất từ "không có gì" đến "giám sát mọi thứ". Kiến trúc streaming mở rộng từ một chiếc Raspberry Pi duy nhất đến cluster Kubernetes đa vùng, và giấy phép GPL-3.0 có nghĩa là chi phí bản quyền bằng không.

**Danh sách hành động:**

1. Chạy lệnh cài đặt một dòng trên máy chủ quan trọng nhất của bạn ngay hôm nay
2. Triển khai Helm chart trên cluster Kubernetes của bạn
3. Cấu hình streaming parent-child để củng cố production
4. Tinh chỉnh `netdata.conf` theo giới hạn tài nguyên của bạn bằng các cấu hình ở trên

Tham gia [cộng đồng Netdata trên Telegram](https://t.me/netdata) để được hỗ trợ thở gian thực và trao đổi với hơn 5.000 kỹ sư.

**Tuyên bố affiliate**: Bài viết này chứa liên kết affiliate cho DigitalOcean và HTStack. Nếu bạn mua dịch vụ hosting qua các liên kết này, dibi8.com có thể nhận được hoa hồng mà không phát sinh chi phí thêm cho bạn.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [Kho lưu trữ GitHub Netdata](https://github.com/netdata/netdata) — 78.874 Stars, GPL-3.0
- [Tài liệu chính thức](https://learn.netdata.cloud/)
- [Tham khảo Helm Chart Netdata](https://learn.netdata.cloud/docs/netdata-agent/installation/kubernetes)
- [Chiến lược triển khai & Streaming Parent-Child](https://github.com/netdata/netdata/blob/master/docs/deployment-guides/deployment-strategies.md)
- [Yêu cầu RAM & Hướng dẫn định cỡ](https://github.com/netdata/netdata/blob/master/docs/netdata-agent/sizing-netdata-agents/ram-requirements.md)
- [Cấu hình Giữ liệu Dữ liệu Dài hạn](https://www.netdata.cloud/blog/long-term-data-retention/)
- [Mở rộng Không Giới hạn — Kiến trúc Ngang](https://www.netdata.cloud/blog/netdata-inifinite-scalability/)
- [Nghiên cứu Hiệu quả Năng lượng Đại học Amsterdam](https://www.ivanomalavolta.com/files/papers/ICSOC_2023.pdf)
- [So sánh Netdata vs Zabbix Chính thức](https://www.netdata.cloud/comparisons/zabbix/)
- [Ghi chú Phát hành & Nhật ký Thay đổi](https://github.com/netdata/netdata/releases)
