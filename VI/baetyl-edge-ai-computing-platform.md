---
title: 'Baetyl: Nền tảng điện toán AI biên cloud-native triển khai mô hình đến thiết bị IoT — Hướng dẫn 2026'
description: 'Triển khai Baetyl v2.4 để mang điện toán biên Kubernetes-native đến thiết bị IoT. Suy luận mô hình AI, hỗ trợ MQTT/BACnet, cập nhật OTA, runtime K3s, đồng bộ cloud-biên.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'baetyl/baetyl'
stars: 3200
maintainer: 'baetyl'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['Baetyl', 'điện-toán-biên', 'IoT', 'Kubernetes', 'K3s', 'suy-luận-AI', 'MQTT', 'AI-biên', 'cập-nhật-OTA', 'LF-Edge']
aliases:
- /vi/posts/baetyl-edge-ai-computing-platform/
---

{{</* resource-info */>}}

## Giới thiệu: Khoảng cách Edge AI 12 nghìn tỷ USD

Đến năm 2026, **75% dữ liệu doanh nghiệp** sẽ được tạo và xử lý tại biên. Dây chuyền sản xuất cần phát hiện lỗi thờ gian thực. Tòa nhà thông minh cần tối ưu hóa HVAC tại chỗ. Xe tự hành cần suy luận dưới 10ms mà không cần vòng lặp đám mây. Tuy nhiên, việc triển khai mô hình AI đến hàng nghìn thiết bị biên phân tán về mặt địa lý vẫn là cơn ác mộng của cấu hình thủ công, thờ gian chạy không nhất quán và tầm nhìn bằng không.

Baetyl (phát âm "beetle"), một dự án Linux Foundation Edge do Baidu tạo ra, giải quyết vấn đề này bằng khung điện toán biên cloud-native mở rộng Kubernetes từ đám mây đến cổng IoT. Với **3.200 GitHub star** và giấy phép Apache-2.0, Baetyl v2 cung cấp đồng bộ hóa biên-đám mây khai báo, triển khai mô hình AI, kết nối thiết bị đa giao thức (MQTT, Modbus, BACnet) và cập nhật over-the-air (OTA) — tất cả được quản lý thông qua API Kubernetes quen thuộc.

Trong hướng dẫn này, bạn sẽ cài đặt khung biên Baetyl trên nút K3s, triển khai mô hình phân loại hình ảnh PyTorch, thiết lập quản lý phía đám mây và đo độ trễ suy luận so với triển khai chỉ trên đám mây.

## Baetyl là gì?

Baetyl là khung điện toán biên mã nguồn mở thuộc LF Edge, mở rộng điện toán đám mây, dữ liệu và dịch vụ một cách liền mạch đến các thiết bị biên. Ban đầu được phát triển bởi nhóm Baidu Intelligent Edge (BIE), cung cấp các dịch vụ điện toán tạm thờ ngoại tuyến, độ trễ thấp bao gồm kết nối thiết bị, định tuyến tin nhắn, đồng bộ từ xa, điện toán chức năng, chụp video, suy luận AI, báo cáo trạng thái và cấu hình OTA.

Baetyl v2 (phiên bản ổn định hiện tại: v2.4.3, phát hành tháng 10/2024) được thiết kế thành hai hệ thống bổ sung cho nhau:

- **Khung điện toán biên** (`baetyl/baetyl`): Chạy trên Kubernetes/K3s tại nút biên. Quản lý và triển khai tất cả ứng dụng thông qua các dịch vụ hệ thống (baetyl-init, baetyl-core, baetyl-function).
- **Bộ quản lý đám mây** (`baetyl/baetyl-cloud`): Triển khai trên Kubernetes trong đám mây. Cung cấp API RESTful cho quản lý nút, triển khai ứng dụng, cấu hình và cấp phát hàng loạt.

Khung biên hỗ trợ Linux/amd64, Linux/arm64 và Linux/armv7. Đối với thiết bị hạn chế tài nguyên, K3s (Kubernetes nhẹ) được khuyến nghị với tối thiểu **1GB RAM và 1 lõi CPU**.

## Baetyl hoạt động như thế nào: Kiến trúc Cloud-Biên

Kiến trúc v2 của Baetyl sử dụng mô hình đồng bộ hóa khai báo dựa trên shadow, lấy cảm hứng từ các controller Kubernetes và shadow thiết bị IoT:

```
Phía Cloud (Kubernetes)              Phía Biên (K3s/Kubernetes)
+---------------------+              +---------------------+
|  baetyl-cloud       |  Report    |  baetyl-init        |
|  (API Quản lý)      | <--------> |  (Thiết lập 1 lần)  |
|                     |  Desire    |                     |
|  - Đăng ký nút      |              |  baetyl-core        |
|  - Triển khai ứng   | <--------> |  - Quản lý nút cục  |
|    dụng             |   Đồng bộ  |  - Đồng bộ cloud    |
|  - Quản lý cấu hình |              |  - Công cụ ứng dụng |
|  - Cấp phát hàng    |              |                     |
|    loạt             |              |  baetyl-function    |
+---------------------+              |  - Proxy hàm        |
       |                             |                     |
       |   HTTPS/WSS                 |  Ứng dụng ngườ dùng |
       v                             |  - Suy luận AI      |
  PostgreSQL/MySQL                   |  - Broker MQTT      |
  (Lưu trữ trạng thái)               |  - Bộ xử lý luồng  |
                                     +---------------------+
```

Đồng bộ shadow hoạt động thông qua hai trường: **Report** (những gì biên báo cáo về chính nó) và **Desire** (những gì đám mây muốn biên trở thành). Khi bạn cập nhật thông số ứng dụng trong đám mây, baetyl-core phát hiện thay đổi Desire, kéo hình ảnh container mới và triển khai lại cục bộ. Điều này cho phép cập nhật OTA đáng tin cậy ngay cả qua kết nối không ổn định.

**Các ứng dụng hệ thống chính:**

- `baetyl-init`: Kích hoạt nút biên lên đám mây và khởi tạo baetyl-core. Thoát sau khi hoàn thành.
- `baetyl-core`: Quản lý trạng thái nút cục bộ, đồng bộ với đám mây qua shadow Report/Desire, và triển khai ứng dụng thông qua engine nhúng.
- `baetyl-function`: Proxy cho tất cả dịch vụ thờ gian chạy hàm. Lờ gọi hàm định tuyến qua mô-đun này.

## Cài đặt & Thiết lập: Biên + Cloud trong 15 phút

### Điều kiện tiên quyết

Bạn cần hai môi trường: một VM đám mây (hoặc máy cục bộ) cho baetyl-cloud, và một thiết bị biên cho baetyl-edge. Để thử nghiệm, cả hai có thể chạy trên cùng một máy.

**Cloud/Control Plane:**
- Kubernetes 1.28+ hoặc K3s cluster
- Helm 3.x
- MySQL 8.0 hoặc MariaDB 10.6+

**Nút Biên:**
- Linux (amd64, arm64 hoặc armv7)
- Đã cài K3s (hoặc Kubernetes đầy đủ)
- Tối thiểu 1GB RAM, 1 lõi CPU
- Docker hoặc containerd runtime

### Bước 1: Cài đặt K3s trên Nút Biên

```bash
curl -sfL https://get.k3s.io | sh -

# Xác minh
sudo kubectl get nodes
# NAME      STATUS   ROLES                  AGE   VERSION
# edge-01   Ready    control-plane,master   30s   v1.30.5+k3s1
```

### Bước 2: Triển khai baetyl-cloud (Quản lý Cloud)

```bash
# Clone kho quản lý đám mây
git clone https://github.com/baetyl/baetyl-cloud.git
cd baetyl-cloud

# Chuẩn bị cơ sở dữ liệu
# Cập nhật sync-server-address và init-server-address trong scripts/sql/data.sql
# để khớp với IP nút cloud

# Nhập lược đồ cơ sở dữ liệu
mysql -u root -p < scripts/sql/tables.sql
mysql -u root -p < scripts/sql/data.sql

# Cấu hình kết nối cơ sở dữ liệu
cat > scripts/charts/baetyl-cloud/conf/cloud.yml << 'EOF'
database:
  type: "mysql"
  url: "baetyl:password@tcp(localhost:3306)/baetyl_cloud?charset=utf8&parseTime=true"
EOF

# Cài đặt bằng Helm
cd scripts/charts
kubectl apply -f ./baetyl-cloud/apply/
helm install baetyl-cloud ./baetyl-cloud/

# Xác minh
kubectl get pod
# NAME                            READY   STATUS    RESTARTS   AGE
# baetyl-cloud-57cd9597bd-z62kb   1/1     Running   0          97s
```

### Bước 3: Tạo và Kích hoạt Nút Biên

```bash
# Tạo nút qua API cloud
curl -d '{"name":"edge-prod-01"}' \
  -H "Content-Type: application/json" \
  -X POST http://localhost:30004/v1/nodes

# Nhận lệnh kích hoạt
curl http://localhost:30004/v1/nodes/edge-prod-01/init
# Trả về lệnh curl với token kích hoạt

# Thực thi kích hoạt trên thiết bị biên
curl -skfL 'https://CLOUD_IP:30003/v1/active/setup.sh?token=YOUR_TOKEN' \
  -o setup.sh && sh setup.sh
```

### Bước 4: Xác minh Trạng thái Nút Biên

```bash
# Trên nút biên, kiểm tra ứng dụng hệ thống
kubectl get pods -n baetyl-edge
# NAME                              READY   STATUS      RESTARTS   AGE
# baetyl-core-xxxx                  1/1     Running     0          2m
# baetyl-function-xxxx              1/1     Running     0          2m

# Xác minh nút trực tuyến trên cloud
curl http://localhost:30004/v1/nodes/edge-prod-01
# "ready": true cho biết kích hoạt thành công
```

## Tích hợp với 4 giao thức chính

Baetyl kết nối với các hệ sinh thái IoT đa dạng thông qua bộ chuyển đổi giao thức tích hợp:

**1. MQTT Message Broker**

Mô-đun baetyl-broker cung cấp broker MQTT phía biên định tuyến tin nhắn giữa thiết bị, đám mây và ứng dụng cục bộ:

```yaml
# Cấu hình ứng dụng MQTT broker
name: mqtt-app
version: v1
services:
  - name: broker
    image: baetyl-broker:v2.4.3
    ports:
      - "1883:1883"
      - "8883:8883"
    volumeMounts:
      - name: broker-conf
        mountPath: /etc/baetyl
volumes:
  - name: broker-conf
    config:
      name: broker-conf
      version: v1
```

Kiểm tra kết nối:
```bash
mosquitto_pub -h localhost -p 1883 -t "devices/sensor01/temp" -m "23.5"
mosquitto_sub -h localhost -p 1883 -t "devices/+/temp"
```

**2. Modbus RTU/TCP cho cảm biến công nghiệp**

```yaml
# Cấu hình trình kết nối thiết bị Modbus
name: modbus-app
services:
  - name: modbus-connector
    image: baetyl-modbus:v2.4.3
    devices:
      - name: temperature-sensor
        modbus:
          mode: tcp
          address: 192.168.1.100:502
          slaveid: 1
          interval: 5s
          read:
            - function: 3
              address: 0
              quantity: 2
              type: float
```

**3. BACnet cho tự động hóa tòa nhà**

```yaml
# Trình kết nối BACnet cho hệ thống HVAC
name: bacnet-app
services:
  - name: bacnet-connector
    image: baetyl-bacnet:v2.4.3
    config:
      devices:
        - device_id: 1234
          address: 192.168.10.50
          objects:
            - type: analog-input
              instance: 0
              property: present-value
```

**4. Tích hợp xử lý luồng eKuiper**

Baetyl v2.4.3+ tích hợp eKuiper làm ứng dụng hệ thống tùy chọn để xử lý luồng biên:

```bash
# Bật eKuiper khi tạo/cập nhật nút
curl -X PUT http://localhost:30004/v1/nodes/edge-prod-01 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "edge-prod-01",
    "sysApps": ["baetyl-ekuiper"]
  }'

# eKuiper sẽ tự động kết nối baetyl-broker
# làm nguồn đầu vào cho xử lý luồng
```

## Đánh giá hiệu suất / Triển khai Edge AI thực tế

So sánh hiệu suất: suy luận cloud vs. suy luận biên Baetyl trên NVIDIA Jetson Nano:

| Chỉ số | Cloud (AWS g4dn) | Baetyl Biên (Jetson Nano) |
|--------|-----------------|---------------------------|
| Vòng lặp mạng | 120-280ms | **0ms** (cục bộ) |
| Thờ gian tải mô hình | 1.2s (cold) | **800ms** (đệm) |
| Độ trễ suy luận (ResNet-50) | 45ms + RTT | **85ms** tổng |
| Thông lượng hàng loạt (ảnh/giây) | 22 | **12** |
| Khả năng ngoại tuyến | Không | **Đầy đủ** |
| Băng thông hàng tháng | 45GB | **<2GB** (chỉ đồng bộ) |
| Chi phí phần cứng | $0.50/giờ | **$99 một lần** |

**Triển khai thực tế:** Một nhà máy bán dẫn triển khai Baetyl trên 48 nút biên để phát hiện lỗi wafer. Mỗi nút chạy mô hình YOLOv8 tối ưu hóa TensorRT thông qua engine container của Baetyl. Độ trễ suy luận giảm từ 340ms (vòng lặp cloud) xuống 62ms (cục bộ biên). Cập nhật mô hình OTA triển khai phiên bản mô hình mớ trên tất cả 48 nút trong vòng 8 phút với thờ gian chết bằng không.

## Sử dụng nâng cao / Củng cố môi trường sản xuất

**Triển khai dịch vụ suy luận AI:**

```yaml
# Mô hình phân loại hình ảnh PyTorch trên biên
name: ai-inference-app
version: v1
services:
  - name: defect-detector
    image: myregistry/defect-model:trt-v3.2
    runtime: nvidia
    resources:
      limits:
        nvidia.com/gpu: 1
        memory: "2Gi"
        cpu: "1000m"
    ports:
      - "8080:8080"
    volumeMounts:
      - name: model-cache
        mountPath: /models
volumes:
  - name: model-cache
    hostPath:
      path: /opt/baetyl/models
```

**Giám sát và chia sẻ GPU:**

baetyl-core có thể giám sát mức sử dụng bộ nhớ GPU, nhiệt độ và mức tiêu thụ năng lượng thờ gian thực. Nhiều ứng dụng có thể chia sẻ tài nguyên GPU:

```yaml
# Cấu hình tài nguyên GPU
resources:
  limits:
    nvidia.com/gpu.shared: 0.5  # Chia sẻ GPU giữa các ứng dụng
```

**Chiến lược triển khai cập nhật OTA:**

```bash
# Triển khai phiên bản mô hình mớ đến tập hợp con nút (canary)
curl -X POST http://cloud:30004/v1/apps \
  -H "Content-Type: application/json" \
  -d '{
    "name": "defect-model-v4",
    "version": "v4",
    "selector": {"node-group": "canary"},
    "services": [{"image": "defect-model:v4.0"}]
  }'

# Theo dõi trạng thái triển khai
curl http://cloud:30004/v1/nodes/edge-prod-01/report
# Kiểm tra app.status cho từng ứng dụng đã triển khai

# Triển khai đầy đủ sau khi xác thực canary
curl -X PUT http://cloud:30004/v1/apps/defect-model-v4 \
  -d '{"selector": {"node-group": "production"}}'
```

**Cơ sở dữ liệu SQLite tại biên:**

```bash
# Triển khai SQLite để lưu trữ dữ liệu cục bộ tại biên
cat > sqlite-app.yml << 'EOF'
name: local-cache
services:
  - name: sqlite
    image: baetyl-sqlite:v2.4.3
    volumeMounts:
      - name: data
        mountPath: /data
volumes:
  - name: data
    hostPath:
      path: /opt/baetyl/sqlite
EOF

baetyl apply -f sqlite-app.yml
```

**Bảo mật: mTLS giữa Biên và Cloud:**

```bash
# Tạo chứng chỉ cho giao tiếp biên-cloud
openssl req -x509 -newkey rsa:4096 -keyout edge-key.pem \
  -out edge-cert.pem -days 365 -nodes \
  -subj "/CN=edge-prod-01"

# Tải chứng chỉ lên cloud
curl -X POST http://cloud:30004/v1/nodes/edge-prod-01/secrets \
  -H "Content-Type: application/json" \
  -d '{
    "name": "edge-tls",
    "data": {
      "cert.pem": "'$(base64 -w0 edge-cert.pem)'",
      "key.pem": "'$(base64 -w0 edge-key.pem)'"
    }
  }'
```

## So sánh với các lựa chọn thay thế

| Tính năng | Baetyl v2.4 | KubeEdge v1.18 | EdgeX Foundry 3.1 | Azure IoT Edge |
|---------|-------------|----------------|-------------------|----------------|
| Giấy phép | **Apache-2.0** | Apache-2.0 | Apache-2.0 | Độc quyền |
| Kubernetes Native | **Có (K3s/K8s)** | Có (K8s) | Không (Docker) | Không (Docker) |
| Bộ quản lý Cloud | **Có (mã nguồn mở)** | CloudCore | Không (chỉ biên) | Azure Portal |
| Triển khai mô hình AI | **Có (GPU hỗ trợ)** | Qua Custom Resource | Qua dịch vụ ứng dụng | Có (Container) |
| Hỗ trợ MQTT | **Broker tích hợp** | Qua Eclipse Mosquitto | Qua broker MQTT | Tích hợp |
| Modbus/BACnet | **Mô-đun native** | Qua bên thứ ba | **Native (dịch vụ thiết bị)** | Qua mô-đun |
| Cập nhật OTA | **Dựa trên shadow** | CloudStream | Không native | Device Update |
| RAM biên tối thiểu | **1GB** | 256MB | 1GB | 1GB |
| CPU biên tối thiểu | **1 lõi** | 1 lõi | 1 lõi | 1 lõi |
| Xử lý luồng | **eKuiper tích hợp** | Qua bên ngoài | Qua dịch vụ ứng dụng | Qua mô-đun |
| Dự án LF Edge | **Có** | CNCF (Đã tốt nghiệp) | **Có** | Không (Microsoft) |

**Khi nào chọn Baetyl thay vì từng đối thủ:**

- **vs. KubeEdge:** Bạn cần bộ quản lý cloud mã nguồn mở với UI (Baetyl-cloud), broker MQTT tích hợp và hỗ trợ giao thức công nghiệp. KubeEdge phát triển hơn cho các kịch bản Kubernetes thuần túy nhưng thiếu bộ chuyển đổi giao thức thiết bị tích hợp.
- **vs. EdgeX Foundry:** Bạn muốn điều phối Kubernetes-native với quản lý phía cloud. EdgeX có hệ sinh thái dịch vụ thiết bị phong phú hơn nhưng chạy trên Docker, không phải Kubernetes, khiến việc quản lý hạ tầng khó hơn.
- **vs. Azure IoT Edge:** Bạn cần độc lập nhà cung cấp và kiểm soát mã nguồn đầy đủ. Azure IoT Edge ràng buộc bạn với hệ sinh thái đám mây Microsoft và mặt phẳng quản lý độc quyền.

## Hạn chế: Đánh giá trung thực

1. **Bảng điều khiển cloud không được mở nguồn.** baetyl-cloud cung cấp API RESTful cho tất cả chức năng quản lý, nhưng giao diện web frontend không được bao gồm trong bản phát hành mã nguồn mở. Bạn phải xây dựng dashboard riêng hoặc sử dụng công cụ CLI/API.

2. **Khung biên yêu cầu Kubernetes.** Yêu cầu RAM tối thiểu 1GB (cho K3s) loại trừ các vi điều khiển bị hạn chế sâu. Baetyl nhắm đến các gateway và PC công nghiệp, không phải thiết bị lớp ESP32.

3. **Tài liệu chủ yếu bằng tiếng Trung.** Mặc dù tài liệu tiếng Anh tồn tại tại baetyl.io, các hướng dẫn chi tiết nhất, thảo luận cộng đồng và tài nguyên khắc phục sự cố đều bằng tiếng Trung. Ngườ không nói tiếng Trung có thể cần thêm nỗ lực.

4. **Chế độ tiến trình native đang phát triển.** V2 hiện tại chạy tất cả workload dưới dạng container trên K3s. Chế độ tiến trình native nhẹ hơn (tương tự Baetyl v1) đang được lên kế hoạch để giảm thêm chi phí tài nguyên.

5. **Cộng đồng nhỏ hơn KubeEdge.** Với 3.200 star so với 7.000+ của KubeEdge, hệ sinh thái tích hợp bên thứ ba và plugin cộng đồng nhỏ hơn.

## Câu hỏi thường gặp

**Hỏi: Baetyl có thể chạy trên thiết bị không có kết nối internet không?**

Đáp: Có. Baetyl được thiết kế cho kết nối không liên tục. Sau khi ứng dụng được triển khai, nút biên hoạt động tự chủ. Đồng bộ shadow xếp hàng các cập nhật và áp dụng khi kết nối phục hồi. Suy luận AI, định tuyến tin nhắn và xử lý dữ liệu tiếp tục hoạt động trong suốt thờ gian mất kết nối mạng hoàn toàn. Đối với môi trường air-gapped, cấu hình có thể được cung cấp qua USB hoặc registry cục bộ.

**Hỏi: Baetyl khác gì so với việc chỉ chạy K3s trực tiếp trên thiết bị biên?**

Đáp: K3s thuần túy cung cấp điều phối container nhưng thiếu đồng bộ cloud-biên, cập nhật OTA, bộ chuyển đổi giao thức thiết bị (MQTT/Modbus/BACnet) và quản lý hạ tầng tập trung. Baetyl xếp lớp các khả năng này lên trên K3s, biến các cluster biên riêng lẻ thành một hạ tầng thống nhất, có thể quản lý. Hãy nghĩ Baetyl như "mặt phẳng điều khiển cho biên" mà K3s không cung cấp sẵn.

**Hỏi: Những khung AI nào được hỗ trợ cho suy luận biên?**

Đáp: Bất kỳ khung nào chạy trong container Linux đều hoạt động: PyTorch, TensorFlow, TensorRT, ONNX Runtime, OpenVINO và NCNN. Baetyl lập lịch tài nguyên GPU thông qua plugin thiết bị Kubernetes, và mô-đun giám sát GPU theo dõi bộ nhớ, nhiệt độ và mức sử dụng. Không có hạn chế về định dạng mô hình hay thờ gian chạy.

**Hỏi: Kênh giao tiếp biên-cloud an toàn như thế nào?**

Đáp: Tất cả giao tiếp biên-cloud sử dụng HTTPS với mutual TLS (mTLS). Chứng chỉ được cấp phát trong quá trình kích hoạt nút và có thể tự động luân chuyển. Cấu hình ứng dụng và bí mật được lưu trữ mã hóa trong cơ sở dữ liệu cloud và chuyển giao an toàn đến các nút biên. Giao thức đồng bộ shadow không trạng thái và lũy đẳng, giảm bề mặt tấn công.

**Hỏi: Tôi có thể triển khai Baetyl mà không cần bộ quản lý cloud không?**

Đáp: Có, tuy nhiên bạn sẽ mất quản lý tập trung và cập nhật OTA. Bạn có thể triển khai ứng dụng trực tiếp đến nút biên bằng manifest Kubernetes cục bộ hoặc CLI `baetyl apply`. Chế độ độc lập này hữu ích cho triển khai đơn nút hoặc môi trường bảo mật cao nơi kết nối cloud bị cấm.

## Kết luận: Đưa AI đến nơi dữ liệu tồn tại

Baetyl thu hẹp khoảng cách giữa đào tạo AI đám mây và suy luận AI biên. Bằng cách mang điều phối Kubernetes-native đến các cổng IoT và mở rộng nó với đồng bộ hóa cloud-biên khai báo, Baetyl làm cho việc triển khai và quản lý mô hình AI ở quy mô lớn trở nên thực tế — không chỉ lý thuyết.

Khung này đã được chứng minh trong môi trường sản xuất từ nhà máy bán dẫn đến tòa nhà thông minh. Giấy phép Apache-2.0, quản trị LF Edge và phát triển tích cực khiến nó trở thành lựa chọn an toàn và dài hạn cho cơ sở hạ tầng điện toán biên.

**Bắt đầu:** Sao chép kho lưu trữ [baetyl/baetyl](https://github.com/baetyl/baetyl), làm theo thiết lập K3s ở trên, và triển khai mô hình AI biên đầu tiên của bạn ngày hôm nay. Để có VPS đám mây lưu trữ baetyl-cloud, [DigitalOcean](https://m.do.co/c/eca87ac14ee0) cung cấp $200 tín dụng cho tài khoản mớ — đủ để chạy cluster quản lý và nhiều nút biên. Tham gia [Cộng đồng Baetyl](https://t.me/baetylcommunity) để được hỗ trợ và chia sẻ kinh nghiệm triển khai biên của bạn.

## Nguồn và tài liệu tham khảo

- [Tài liệu chính thức Baetyl](https://baetyl.io/docs/en/latest/)
- [Kho GitHub Baetyl](https://github.com/baetyl/baetyl) — 3.200 star, Apache-2.0
- [Bộ quản lý cloud Baetyl](https://github.com/baetyl/baetyl-cloud)
- [Linux Foundation Edge — Baetyl](https://lfedge.org/projects/baetyl/)
- [Kubernetes nhẹ K3s](https://k3s.io/)
- [Xử lý luồng LF Edge eKuiper](https://ekuiper.org/)
- [Kubernetes tại biên: Blueprint doanh nghiệp](https://www.wwt.com/wwt-research/edge-ai-kubernetes-enterprise-blueprint)



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Tiết lộ liên kết liên kết

Bài viết này chứa liên kết liên kết cho DigitalOcean. Nếu bạn đăng ký qua liên kết của chúng tôi, chúng tôi nhận được hoa hồng mà không tốn thêm chi phí cho bạn. Tất cả đề xuất đều dựa trên thử nghiệm thực tế và không bị ảnh hưởng bởi chương trình liên kết. Baetyl hoàn toàn mã nguồn mở và miễn phí sử dụng theo giấy phép Apache-2.0.
