---
title: "Oh My Pi：将任何树莓派变成智能设备——12K 星项目 2026"
description: "Oh My Pi（12,554 颗星）通过一键式设置和自动化配置，将树莓派设备转变为智能家居中心、媒体中心和开发工作站。"
date: 2026-06-15
slug: oh-my-pi
category: dev-utils
tags: ['树莓派', '智能家居', '物联网', '边缘计算', '家庭自动化', 'linux', '自动化']
github_repo: "https://github.com/can1357/oh-my-pi"
license: MIT
images:
  - url: "https://opengraph.github.com/github/can1357/oh-my-pi"
    alt: "Oh My Pi GitHub OG"
    role: reference
  - url: "https://raw.githubusercontent.com/can1357/oh-my-pi/main/assets/pi-setup.png"
    alt: "Pi 设置流程"
    role: example
  - url: "https://raw.githubusercontent.com/can1357/oh-my-pi/main/assets/smart-home-diagram.png"
    alt: "智能家居架构图"
    role: diagram
lang: zh
featureImage: /images/articles/oh-my-pi-turn-any-raspberry-pi-into-a-smart-device-12k-star-.jpg
---

## 快速概览

Oh My Pi 将任何树莓派变成一个完全配置好的智能设备，提供自动化设置、预配置仪表板和一键式服务部署。拥有 12,554 颗星，它是 GitHub 上最受欢迎的树莓派自动化框架。

**快速概览：12,554 颗星**——排名第一的树莓派自动化项目。

## Oh My Pi 是什么？

Oh My Pi 是一个面向树莓派设备的自动化设置框架。与其手动配置网络、安装服务并将它们连接在一起，Oh My Pi handles 从空白 SD 卡到完全可用的智能设备的整个过程，耗时不到 30 分钟。

该项目提供了一个模块化服务目录，包括：

- **Home Assistant**——拥有 2,000+ 集成的完整智能家居中枢
- **AdGuard Home**——全网广告拦截和 DNS 过滤
- **Pi-hole**——轻量级 DNS 广告拦截器
- **Grafana + Prometheus**——基础设施监控仪表板
- **Jellyfin**——免费的媒体服务器用于流媒体播放
- **Gitea**——自托管的 Git 服务
- **Vaultwarden**——兼容 Bitwarden 的密码管理器
- **Minecraft 服务器**——一键式 Minecraft 服务器部署
- **网络扫描器**——自动设备发现和监控
- **备份管理器**——带加密存储的计划备份

```bash
# 在全新的 Raspberry Pi OS 上安装 Oh My Pi
curl -sSL https://ohmypi.sh/install | sudo bash

# 或克隆后手动运行
git clone https://github.com/can1357/oh-my-pi.git
cd oh-my-pi
sudo ./install.sh
```

## Oh My Pi 如何工作

Oh My Pi 采用三阶段部署模型：

1. **系统配置**——配置操作系统、网络、用户和安全加固
2. **服务安装**——通过 Docker Compose 部署所选服务，附带合理的默认值
3. **仪表板组装**——创建一个统一的 Web 仪表板来管理所有服务

```bash
# 第一阶段：系统配置
sudo omp provision --hostname mypi --ssh-key ~/.ssh/id_ed25519.pub

# 第二阶段：安装服务
sudo omp install homeassistant grafana vaultwarden

# 第三阶段：生成仪表板
sudo omp dashboard --title "我的智能 Pi" --theme dark
```

配置阶段处理通常需要数小时的所有事情：静态 IP 配置、SSH 密钥设置、防火墙规则、日志轮转和自动更新。服务作为独立的 Docker 容器部署，持久化卷用于数据存储。

## 安装与配置

要求：树莓派 3B+ 或更新型号（推荐 Pi 4）、8GB+ microSD 卡、Raspberry Pi OS Lite（64 位）。

```bash
# 第一步：刷入 Raspberry Pi OS Lite
# 从 https://www.raspberrypi.com/software/ 下载

# 第二步：启用 SSH 和 WiFi
# 在 boot 分区添加 ssh 文件和 wpa_supplicant.conf

# 第三步：启动 Pi 并查找其 IP
# 使用以下命令扫描你的网络：nmap -sn 192.168.1.0/24

# 第四步：SSH 登录并安装 Oh My Pi
ssh pi@<pi-ip>
curl -sSL https://ohmypi.sh/install | sudo bash
```

### Docker 配置

Oh My Pi 对所有服务部署使用 Docker Compose：

```yaml
# 安装服务后生成的 docker-compose.yaml
version: "3.9"
services:
  homeassistant:
    image: ghcr.io/home-assistant/home-assistant:stable
    volumes:
      - ha-data:/config
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "8123:8123"
    restart: unless-stopped

  adguard:
    image: adguard/adguardhome:latest
    volumes:
      - adguard-conf:/opt/adguardhome/conf
      - adguard-work:/opt/adguardhome/work
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "3000:3000"
      - "80:80/tcp"
    restart: unless-stopped

  vaultwarden:
    image: vaultwarden/server:latest
    volumes:
      - vw-data:/data
    environment:
      SIGNUPS_ALLOWED: "false"
    restart: unless-stopped

volumes:
  ha-data:
  adguard-conf:
  adguard-work:
  vw-data:
```

### 网络配置

自动网络设置处理 DHCP 保留、DNS 转发和防火墙规则：

```bash
# 配置静态 IP
sudo omp network static --ip 192.168.1.100 --gateway 192.168.1.1 --dns 8.8.8.8

# 设置 DNS 转发
sudo omp network dns --upstream 1.1.1.1 --local 127.0.0.1

# 配置防火墙
sudo omp firewall enable --allow 22 --allow 80 --allow 443 --allow 8123
```

## 服务目录：详细分解

Oh My Pi 支持跨 6 个类别的 20+ 种服务：

| 类别 | 服务 | 安装时间 | 资源占用 |
|------|------|---------|---------|
| **智能家居** | Home Assistant、Zigbee2MQTT | 5 分钟 | 512MB 内存 |
| **网络** | AdGuard、Pi-hole、PiVPN | 3 分钟 | 128MB 内存 |
| **媒体** | Jellyfin、Plex（手动）、Navidrome | 5 分钟 | 256MB 内存 |
| **开发** | Gitea、Cockpit、Netdata | 4 分钟 | 384MB 内存 |
| **安全** | Vaultwarden、FileBrowser、Uptime Kuma | 3 分钟 | 256MB 内存 |
| **监控** | Grafana、Prometheus、AlertManager | 6 分钟 | 512MB 内存 |

```bash
# 安装完整的智能家居设置
sudo omp install homeassistant zigbee2mqtt adguard grafana vaultwarden

# 所有服务按协调顺序部署
# Home Assistant 首先启动，然后 Zigbee2MQTT 连接，
# AdGuard 处理 DNS，Grafana 监控一切
```

## 与替代方案的比较

市面上存在多个树莓派自动化项目，但 Oh My Pi 脱颖而出：

| 特性 | Oh My Pi | CasaOS | Raspberry Pi Imager | OSMC |
|------|----------|--------|-------------------|------|
| 星标数 | 12,554 | 18K+ | N/A | 3.2K |
| 服务数量 | 20+ | 15+ | N/A | 1（仅媒体） |
| 一键安装 | 是 | 是 | 否 | 否 |
| 仪表板 | 统一 | 是 | 否 | 否 |
| 备份系统 | 内置 | 是 | 否 | 否 |
| 自定义服务支持 | 是 | 是 | 否 | 否 |
| 无头设置 | 是 | 是 | 否 | 否 |
| Docker 优先 | 是 | 是 | N/A | 否 |

关键差异化优势在于**服务多样性和编排**。与专注于应用商店简单性的 CasaOS 不同，Oh My Pi 在保持一键便捷的同时，赋予你对服务配置的细粒度控制。

## 进阶用法：自定义服务部署

通过 Oh My Pi 的扩展系统部署自定义服务：

### 编写自定义服务定义

```yaml
# my-service.yaml — 自定义服务定义
service:
  name: my-custom-app
  version: "1.0"
  description: "自定义应用程序部署"
  
  docker:
    image: "myapp:latest"
    ports:
      - "8080:8080"
    volumes:
      - myapp-data:/data
    environment:
      APP_ENV: production
      LOG_LEVEL: info
  
  health_check:
    url: "http://localhost:8080/health"
    interval: "30s"
    retries: 3
  
  resources:
    cpu_limit: "0.5"
    memory_limit: "256M"
  
  backup:
    enabled: true
    schedule: "0 2 * * *"  # 每天凌晨 2 点
    volumes:
      - myapp-data
```

### 自动备份

Oh My Pi 包含一个内置备份系统，支持加密存储：

```bash
# 配置备份目标
sudo omp backup configure --remote s3 --bucket ohmypi-backups --region us-east-1

# 立即运行备份
sudo omp backup run

# 从备份恢复
sudo omp backup restore --date 2026-06-14 --verify

# 设置每日计划备份
sudo omp backup schedule --frequency daily --retention 30
```

### 远程访问和隧道

通过自动 HTTPS 隧道从任何地方访问你的 Pi 服务：

```bash
# 设置 Cloudflare 隧道（免费，无需端口转发）
sudo omp tunnel cloudflare --token <cloudflare-token>

# 或使用 ngrok 快速访问
sudo omp tunnel ngrok --authtoken <ngrok-token>

# 使用 Caddy 配置反向代理（自动 HTTPS）
sudo omp proxy caddy --domain mypi.local --ssl auto
```

### 多 Pi 集群管理

从单个仪表板管理多台 Pi：

```bash
# 将第二台 Pi 添加到集群
sudo omp cluster add --host pi2.local --user pi --key ~/.ssh/id_ed25519

# 跨所有节点部署服务
sudo omp cluster deploy --services homeassistant,grafana --nodes all

# 查看集群健康状态
sudo omp cluster health
```

### SD 卡健康监控

树莓派的 SD 卡可能在毫无预警的情况下失效。Oh My Pi 包含内置的类似 SMART 的监控：

```bash
# 检查 SD 卡健康状况
sudo omp storage health

# 启用预测性故障警报
sudo omp storage alerts --enable --threshold 70

# 设置自动健康检查
sudo omp storage schedule --interval hourly
```

### 电源监控和 UPS 集成

为了实现不间断运行，Oh My Pi 支持 UPS 硬件监控和优雅关机：

```bash
# 配置 UPS 监控
sudo omp ups configure --driver usb --shutdown-delay 300

# 设置优雅关机的电池阈值
sudo omp ups threshold --battery 20 --action shutdown

# 监控电源事件
sudo omp ups logs --tail 50
```

### 资源监控和告警

```bash
# 设置资源阈值
sudo omp monitor thresholds --cpu 90 --memory 85 --disk 80

# 配置告警通知
sudo omp monitor alerts --channel telegram --token <bot-token> --chat <chat-id>

# 查看资源历史记录
sudo omp monitor history --period 7d --graph
```

## 局限性：Oh My Pi 可能不适合的情况

1. **Pi Zero 和旧型号**——Oh My Pi 至少需要 1GB 内存。Pi Zero（256MB/512MB）无法运行完整的服务堆栈。Pi Zero 2 W（512MB）只能运行最小化配置，仅限网络服务。

2. **高性能需求**——对于 CPU 密集型工作负载，如 4K 视频转码、大规模机器学习推理或编译大型代码库，建议使用性能更强的单板计算机（如配备 16GB 内存的 Orange Pi 5）或专用的 x86 机器。

3. **生产级服务**——Oh My Pi 面向爱好者和小团队使用场景。具有 SLA 要求的任务关键型生产部署应使用具备冗余电源和网络连接的专用服务器。

4. **非 Docker 服务**——所有服务均在 Docker 容器中运行。框架不支持裸机安装和直接硬件访问。

5. **自定义硬件**——HAT、GPIO 项目、传感器部署和机器人项目不在 Oh My Pi 的范围之内。该项目专注于网络服务和容器化应用，而非硬件交互。

6. **有限的 ARM 特定优化**——虽然 Docker 镜像是多架构的，但一些为 x86 优化的镜像在 ARM 处理器上可能性能较低。部署前请始终验证镜像兼容性。

```bash
# 快速适用性检查
# ✅ 智能家居中枢 → 适合
# ✅ 媒体服务器 → 适合
# ✅ 开发工作站 → 适合
# ✅ 生产数据库服务器 → 不适合（使用专用硬件）
# ✅ IoT 传感器项目 → 不适合（仅关注网络服务）
```

## 常见问题

### 推荐哪种树莓派型号？

推荐 Pi 4（4GB+ 内存）或 Pi 5。Pi 3B+ 可用于基本服务，但运行多个容器时可能会有些吃力。

### 我能在非树莓派板上使用 Oh My Pi 吗？

可以。该框架支持任何安装了 Docker 的 ARM64 或 x86_64 Linux 机器。

### 我需要多少存储空间？

基本设置（2-3 个服务）大约需要 8GB。完整设置（全部 20+ 个服务）大约使用 15-20GB。

### 有管理服务的手机应用吗？

Web 仪表板是响应式的，可在移动浏览器上使用。专属应用尚未推出。

### 我能否在无互联网访问的情况下运行 Oh My Pi？

可以。所有 Docker 镜像都可以预先拉取，系统支持离线服务部署。

### 如何更新已安装的服务？

运行 `sudo omp update` 以检查服务更新并在可能的情况下实现零停机应用。更新系统支持大多数服务的滚动更新，并在更新后服务无法启动时自动回滚。

### 我能在非树莓派板上使用 Oh My Pi 吗？

可以。该框架支持任何安装了 Docker 的 ARM64 或 x86_64 Linux 机器。`omp provision` 命令会自动检测硬件并相应地调整资源限制。

### 有管理服务 Web 仪表板吗？

有的。Oh My Pi 在安装后会生成一个统一的 Web 仪表板，地址为 `http://<pi-ip>:3001`。仪表板显示所有正在运行的服务、资源使用情况，并提供对各服务管理面板的一键访问。

## 结语

Oh My Pi 消除了树莓派使用中最令人沮丧的部分：配置、服务连接和持续维护。凭借 12,554 颗星，它证明了精心设计的自动化框架可以让复杂的家庭基础设施对每个人变得触手可及——从初次接触 Pi 的新手到跨多个地点和地理位置管理集群部署的资深系统管理员。项目路线图包括 ARM 特定性能优化、原生 iOS/Android 配套应用以及社区插件市场。

对于可靠的 SD 卡存储，[HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f) 为 Pi 配置提供备份解决方案。[DigitalOcean](https://m.do.co/oa14d5f0wx4f) 的对象存储可实现廉价的云冗余。加密持有者：[Binance](https://bsmkweb.cc/6yq8qf7u)、[OKX](https://promoohubly.com/5g1h7qxn)。[WebShare 代理](https://proxy.webshare.io/?&promo=oa14d5f0wx4f) 用于远程 Pi 管理。对于安全的远程访问，[HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f) 加密存储保护你的 Pi 配置备份。

**立即开始：**

```bash
curl -sSL https://ohmypi.sh/install | sudo bash
```

**相关文章**：[智能家居指南](https://dibi8.com/) · [使用 Pi 进行边缘计算](https://dibi8.com/ai-tools/)

---

**来源与延伸阅读**：
- GitHub 仓库：https://github.com/can1357/oh-my-pi
- 树莓派文档：https://www.raspberrypi.com/documentation/
- Docker 文档：https://docs.docker.com/


**Sources & Further Reading**:
- GitHub仓库: https://github.com/can1357/oh-my-pi
- Raspberry Pi docs: https://www.raspberrypi.com/documentation/
- Docker docs: https://docs.docker.com/
**行动号召**：加入 DIBI8 IoT 社区 Telegram —— [t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**披露**：本文包含联盟链接。如果你通过我们的链接注册，我们可能会获得佣金，这不会给你增加额外费用。
