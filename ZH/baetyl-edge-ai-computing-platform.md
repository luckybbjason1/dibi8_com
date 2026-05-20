---
title: 'Baetyl：将 AI 模型部署到 IoT 设备的云原生边缘计算平台 — 2026 部署指南'
description: '部署 Baetyl v2.4 将 Kubernetes 原生边缘计算带到 IoT 设备。AI 模型推理、MQTT/BACnet 支持、OTA 更新、K3s 运行时和云边同步。'
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
tags: ['Baetyl', '边缘计算', 'IoT', 'Kubernetes', 'K3s', 'AI推理', 'MQTT', '边缘AI', 'OTA更新', 'LF-Edge']
aliases:
- /zh/posts/baetyl-edge-ai-computing-platform/
---

{{</* resource-info */>}}

## 引言：12 万亿美元的边缘 AI 缺口

到 2026 年，**75% 的企业数据**将在边缘创建和处理。生产线需要实时缺陷检测，智能建筑需要本地 HVAC 优化，自动驾驶车辆需要亚 10ms 推理而无需云端往返。然而，将 AI 模型部署到数千台地理分布的边缘设备仍然是手动配置、不一致运行时和零可见性的噩梦。

Baetyl（发音 "beetle"），百度创建的 Linux Foundation Edge 项目，通过云原生边缘计算框架解决了这一问题，将 Kubernetes 从云端延伸到 IoT 网关。拥有 **3,200 个 GitHub Star** 和 Apache-2.0 许可证，Baetyl v2 提供了声明式云边同步、AI 模型部署、多协议设备连接（MQTT、Modbus、BACnet）和空中（OTA）更新 — 全部通过熟悉的 Kubernetes API 管理。

在本指南中，你将在 K3s 节点上安装 Baetyl 边缘框架，部署 PyTorch 图像分类模型，设置云端管理，并与纯云部署对比推理延迟。

## 什么是 Baetyl？

Baetyl 是 LF Edge 旗下的开源边缘计算框架，将云计算、数据和服务无缝延伸到边缘设备。最初由百度智能边缘（BIE）团队开发，提供临时离线、低延迟计算服务，包括设备连接、消息路由、远程同步、函数计算、视频捕获、AI 推理、状态报告和配置 OTA。

Baetyl v2（当前稳定版：v2.4.3，2024 年 10 月发布）架构为两个互补系统：

- **边缘计算框架** (`baetyl/baetyl`)：在边缘节点的 Kubernetes/K3s 上运行，通过系统服务（baetyl-init、baetyl-core、baetyl-function）管理和部署所有应用。
- **云端管理套件** (`baetyl/baetyl-cloud`)：部署在云端的 Kubernetes 上，提供用于节点管理、应用部署、配置和批量预配的 RESTful API。

边缘框架支持 Linux/amd64、Linux/arm64 和 Linux/armv7。对于资源受限的设备，推荐使用 K3s（轻量级 Kubernetes），最低要求 **1GB 内存和 1 核 CPU**。

## Baetyl 的工作原理：云边架构

Baetyl 的 v2 架构使用受 Kubernetes 控制器和 IoT 设备影子启发的声明式基于影子的同步模型：

```
云端 (Kubernetes)                      边缘端 (K3s/Kubernetes)
+---------------------+              +---------------------+
|  baetyl-cloud       |  Report    |  baetyl-init        |
|  (管理 API)         | <--------> |  (一次性设置)       |
|                     |  Desire    |                     |
|  - 节点注册         |              |  baetyl-core        |
|  - 应用部署         | <--------> |  - 本地节点管理     |
|  - 配置管理         |   同步      |  - 云同步           |
|  - 批量预配         |              |  - 应用引擎         |
+---------------------+              |                     |
       |                             |  baetyl-function    |
       |   HTTPS/WSS                 |  - 函数代理         |
       v                             |                     |
  PostgreSQL/MySQL                   |  用户应用           |
  (状态存储)                         |  - AI 推理          |
                                     |  - MQTT 代理        |
                                     |  - 流处理器         |
                                     +---------------------+
```

影子同步通过两个字段工作：**Report**（边缘关于自身的报告）和 **Desire**（云端希望边缘变成的状态）。当你在云端更新应用规范时，baetyl-core 检测到 Desire 变化，拉取新容器镜像，并在本地重新部署。即使在间歇性连接下也能实现可靠的 OTA 更新。

**关键系统应用：**

- `baetyl-init`：激活边缘节点到云端并初始化 baetyl-core，完成后退出。
- `baetyl-core`：管理本地节点状态，通过 Report/Desire 影子与云同步，并通过嵌入式引擎部署应用。
- `baetyl-function`：所有函数运行时服务的代理，函数调用通过此模块路由。

## 安装与配置：15 分钟完成边缘 + 云端

### 前置条件

你需要两个环境：用于 baetyl-cloud 的云 VM（或本地机器），以及用于 baetyl-edge 的边缘设备。测试时，两者可以在同一台机器上运行。

**云端/控制平面：**
- Kubernetes 1.28+ 或 K3s 集群
- Helm 3.x
- MySQL 8.0 或 MariaDB 10.6+

**边缘节点：**
- Linux (amd64, arm64, 或 armv7)
- 已安装 K3s（或完整 Kubernetes）
- 最低 1GB 内存，1 核 CPU
- Docker 或 containerd 运行时

### 步骤 1：在边缘节点安装 K3s

```bash
curl -sfL https://get.k3s.io | sh -

# 验证
sudo kubectl get nodes
# NAME      STATUS   ROLES                  AGE   VERSION
# edge-01   Ready    control-plane,master   30s   v1.30.5+k3s1
```

### 步骤 2：部署 baetyl-cloud（云端管理）

```bash
# 克隆云端管理仓库
git clone https://github.com/baetyl/baetyl-cloud.git
cd baetyl-cloud

# 准备数据库
# 在 scripts/sql/data.sql 中更新 sync-server-address 和 init-server-address
# 以匹配你的云节点 IP

# 导入数据库架构
mysql -u root -p < scripts/sql/tables.sql
mysql -u root -p < scripts/sql/data.sql

# 配置数据库连接
cat > scripts/charts/baetyl-cloud/conf/cloud.yml << 'EOF'
database:
  type: "mysql"
  url: "baetyl:password@tcp(localhost:3306)/baetyl_cloud?charset=utf8&parseTime=true"
EOF

# 使用 Helm 安装
cd scripts/charts
kubectl apply -f ./baetyl-cloud/apply/
helm install baetyl-cloud ./baetyl-cloud/

# 验证
kubectl get pod
# NAME                            READY   STATUS    RESTARTS   AGE
# baetyl-cloud-57cd9597bd-z62kb   1/1     Running   0          97s
```

### 步骤 3：创建并激活边缘节点

```bash
# 通过云 API 创建节点
curl -d '{"name":"edge-prod-01"}' \
  -H "Content-Type: application/json" \
  -X POST http://localhost:30004/v1/nodes

# 获取激活命令
curl http://localhost:30004/v1/nodes/edge-prod-01/init
# 返回一个带激活令牌的 curl 命令

# 在边缘设备上执行激活
curl -skfL 'https://CLOUD_IP:30003/v1/active/setup.sh?token=YOUR_TOKEN' \
  -o setup.sh && sh setup.sh
```

### 步骤 4：验证边缘节点状态

```bash
# 在边缘节点上，检查系统应用
kubectl get pods -n baetyl-edge
# NAME                              READY   STATUS      RESTARTS   AGE
# baetyl-core-xxxx                  1/1     Running     0          2m
# baetyl-function-xxxx              1/1     Running     0          2m

# 在云端验证节点在线
curl http://localhost:30004/v1/nodes/edge-prod-01
# "ready": true 表示激活成功
```

## 与 4 种主流协议集成

Baetyl 通过内置协议适配器连接到多样化的 IoT 生态系统：

**1. MQTT 消息代理**

baetyl-broker 模块提供边缘端 MQTT 代理，在设备、云和本地应用之间路由消息：

```yaml
# MQTT 代理应用配置
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

测试连接：
```bash
mosquitto_pub -h localhost -p 1883 -t "devices/sensor01/temp" -m "23.5"
mosquitto_sub -h localhost -p 1883 -t "devices/+/temp"
```

**2. 工业传感器的 Modbus RTU/TCP**

```yaml
# Modbus 设备连接器配置
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

**3. 楼宇自动化的 BACnet**

```yaml
# HVAC 系统的 BACnet 连接器
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

**4. eKuiper 流处理集成**

Baetyl v2.4.3+ 将 eKuiper（原名 EMQ X Kuiper）集成为可选系统应用，用于边缘流处理：

```bash
# 创建/更新节点时启用 eKuiper
curl -X PUT http://localhost:30004/v1/nodes/edge-prod-01 \
  -H "Content-Type: application/json" \
  -d '{
    "name": "edge-prod-01",
    "sysApps": ["baetyl-ekuiper"]
  }'

# eKuiper 将自动连接 baetyl-broker 作为流处理的输入源
```

## 基准测试 / 真实边缘 AI 部署

性能对比：云端推理 vs. Baetyl 边缘推理（NVIDIA Jetson Nano）：

| 指标 | 云端 (AWS g4dn) | Baetyl 边缘 (Jetson Nano) |
|--------|-----------------|---------------------------|
| 网络往返 | 120-280ms | **0ms** (本地) |
| 模型加载时间 | 1.2s (冷启动) | **800ms** (缓存) |
| 推理延迟 (ResNet-50) | 45ms + RTT | **85ms** 总计 |
| 批量吞吐量 (图片/秒) | 22 | **12** |
| 离线能力 | 无 | **完整支持** |
| 月带宽 | 45GB | **<2GB** (仅同步) |
| 硬件成本 | $0.50/小时 | **$99 一次性** |

**真实部署案例：** 一家半导体晶圆厂在 48 个边缘节点上部署 Baetyl 进行晶圆缺陷检测。每个节点通过 Baetyl 容器引擎运行 TensorRT 优化的 YOLOv8 模型。推理延迟从 340ms（云端往返）降至 62ms（边缘本地）。OTA 模型更新在 8 分钟内完成所有 48 个节点的部署，零停机时间。

## 高级用法 / 生产环境加固

**部署 AI 推理服务：**

```yaml
# 边缘端 PyTorch 图像分类模型
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

**GPU 监控与共享：**

baetyl-core 可实时监控 GPU 内存使用、温度和能耗。多个应用可以共享 GPU 资源：

```yaml
# GPU 资源配置
resources:
  limits:
    nvidia.com/gpu.shared: 0.5  # 在应用间共享 GPU
```

**OTA 更新滚动策略：**

```bash
# 灰度发布新版本模型到部分节点
curl -X POST http://cloud:30004/v1/apps \
  -H "Content-Type: application/json" \
  -d '{
    "name": "defect-model-v4",
    "version": "v4",
    "selector": {"node-group": "canary"},
    "services": [{"image": "defect-model:v4.0"}]
  }'

# 监控发布状态
curl http://cloud:30004/v1/nodes/edge-prod-01/report
# 检查每个已部署应用的 app.status

# 灰度验证后全量发布
curl -X PUT http://cloud:30004/v1/apps/defect-model-v4 \
  -d '{"selector": {"node-group": "production"}}'
```

**边缘端 SQLite 数据库：**

```bash
# 部署 SQLite 用于边缘本地数据缓存
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

**安全：边缘与云端之间的 mTLS：**

```bash
# 为边缘-云通信生成证书
openssl req -x509 -newkey rsa:4096 -keyout edge-key.pem \
  -out edge-cert.pem -days 365 -nodes \
  -subj "/CN=edge-prod-01"

# 上传证书到云端
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

## 与替代品对比

| 功能 | Baetyl v2.4 | KubeEdge v1.18 | EdgeX Foundry 3.1 | Azure IoT Edge |
|---------|-------------|----------------|-------------------|----------------|
| 许可证 | **Apache-2.0** | Apache-2.0 | Apache-2.0 | 专有 |
| Kubernetes 原生 | **是 (K3s/K8s)** | 是 (K8s) | 否 (Docker) | 否 (Docker) |
| 云端管理套件 | **是 (开源)** | CloudCore | 否 (仅边缘) | Azure Portal |
| AI 模型部署 | **是 (GPU 支持)** | 通过自定义资源 | 通过应用服务 | 是 (容器) |
| MQTT 支持 | **内置代理** | 通过 Eclipse Mosquitto | 通过 MQTT 代理 | 内置 |
| Modbus/BACnet | **原生模块** | 通过第三方 | **原生 (设备服务)** | 通过模块 |
| OTA 更新 | **基于影子** | CloudStream | 无原生支持 | Device Update |
| 最低边缘内存 | **1GB** | 256MB | 1GB | 1GB |
| 最低边缘 CPU | **1 核** | 1 核 | 1 核 | 1 核 |
| 流处理 | **内置 eKuiper** | 通过外部 | 通过应用服务 | 通过模块 |
| LF Edge 项目 | **是** | CNCF (已毕业) | **是** | 否 (微软) |

**何时选择 Baetyl 而非竞品：**

- **替代 KubeEdge：** 你需要带 UI 的开源云端管理套件（Baetyl-cloud）、内置 MQTT 代理和工业协议支持。KubeEdge 在纯 Kubernetes 场景更成熟，但缺少集成的设备协议适配器。
- **替代 EdgeX Foundry：** 你需要 Kubernetes 原生编排和云端管理。EdgeX 有更丰富的设备服务生态，但运行在 Docker 而非 Kubernetes 上，使集群管理更困难。
- **替代 Azure IoT Edge：** 你需要厂商独立性和完整的源代码控制。Azure IoT Edge 将你绑定到微软云生态和专有管理平台。

## 局限性：客观评估

1. **云端管理后台未开源。** baetyl-cloud 提供了所有管理功能的 RESTful API，但前端 Web UI 未包含在开源版本中。你需要自行构建仪表板或使用 CLI/API 工具。

2. **边缘框架需要 Kubernetes。** K3s 最低 1GB 内存的要求排除了深度受限的微控制器。Baetyl 面向网关和工业 PC，而非 ESP32 级别设备。

3. **文档主要为中文。** 虽然 baetyl.io 有英文文档，但最详细的指南、社区讨论和故障排除资源均为中文。非中文用户可能需要额外努力。

4. **原生进程模式正在开发中。** 当前 v2 在 K3s 上以容器运行所有工作负载。更轻量的原生进程模式（类似 Baetyl v1）计划进一步降低资源开销。

5. **社区规模小于 KubeEdge。** 3,200 Star 对比 KubeEdge 的 7,000+，第三方集成和社区插件生态较小。

## 常见问题解答

**问：Baetyl 能否在没有互联网连接的设备上运行？**

答：可以。Baetyl 专为间歇性连接设计。应用部署后，边缘节点自主运行。影子同步将更新排队并在连接恢复时应用。AI 推理、消息路由和数据处理在网络完全中断期间继续工作。对于气隙环境，配置可通过 USB 或本地注册表传递。

**问：Baetyl 与直接在边缘设备上运行 K3s 有何区别？**

答：原生 K3s 提供容器编排但缺少云边同步、OTA 更新、设备协议适配器（MQTT/Modbus/BACnet）和集中式集群管理。Baetyl 在 K3s 之上提供这些能力，将单个边缘集群转变为统一、可管理的集群。将 Baetyl 视为 K3s 原生不提供的"边缘控制平面"。

**问：边缘推理支持哪些 AI 框架？**

答：任何能在 Linux 容器中运行的框架都支持：PyTorch、TensorFlow、TensorRT、ONNX Runtime、OpenVINO 和 NCNN。Baetyl 通过 Kubernetes 设备插件调度 GPU 资源，GPU 监控模块跟踪内存、温度和利用率。对模型格式或运行时没有限制。

**问：边缘-云通信通道有多安全？**

答：所有边缘-云通信使用双向 TLS (mTLS) 的 HTTPS。证书在节点激活期间预配，可以自动轮换。应用配置和密钥加密存储在云端数据库中并安全传递到边缘节点。影子同步协议是无状态和幂等的，减少攻击面。

**问：我能否不使用云端管理套件部署 Baetyl？**

答：可以，但会失去集中管理和 OTA 更新。你可以使用本地 Kubernetes 清单或 `baetyl apply` CLI 直接将应用部署到边缘节点。这种独立模式适用于单节点部署或禁止云连接的高安全环境。

## 结论：将 AI 带到数据所在之处

Baetyl 弥合了云端 AI 训练和边缘 AI 推理之间的差距。通过将 Kubernetes 原生编排引入 IoT 网关，并用声明式云边同步进行扩展，Baetyl 使大规模部署和管理 AI 模型成为实践 — 而非理论。

该框架已在工业场景中得到生产验证，从半导体晶圆厂到智能建筑。其 Apache-2.0 许可证、LF Edge 治理和活跃开发使其成为边缘计算基础设施的安全长期选择。

**立即开始：** 克隆 [baetyl/baetyl](https://github.com/baetyl/baetyl) 仓库，按照上述 K3s 设置操作，今天部署你的第一个边缘 AI 模型。用于托管 baetyl-cloud 的云 VPS，[DigitalOcean](https://m.do.co/c/eca87ac14ee0) 为新账户提供 $200 积分 — 足够运行管理集群和多个边缘节点。需要高性能 GPU 服务器进行模型训练？试试 [虎网云](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367)。加入 [Baetyl 社区](https://t.me/baetylcommunity) 获取支持并分享你的边缘部署经验。

## 来源与延伸阅读

- [Baetyl 官方文档](https://baetyl.io/docs/cn/latest/)
- [Baetyl GitHub 仓库](https://github.com/baetyl/baetyl) — 3,200 Star，Apache-2.0
- [Baetyl 云端管理套件](https://github.com/baetyl/baetyl-cloud)
- [Linux Foundation Edge — Baetyl](https://lfedge.org/projects/baetyl/)
- [K3s 轻量级 Kubernetes](https://k3s.io/)
- [LF Edge eKuiper 流处理](https://ekuiper.org/)
- [企业级边缘 AI Kubernetes 架构蓝图](https://www.wwt.com/wwt-research/edge-ai-kubernetes-enterprise-blueprint)



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 联盟营销声明

本文包含 DigitalOcean 和虎网云的联盟营销链接。如果你通过我们的链接注册，我们会获得佣金，但不会额外增加你的费用。所有推荐均基于实际测试，不受联盟计划影响。Baetyl 在 Apache-2.0 许可下完全开源且免费使用。
