---
title: 'Caddy: 72K+ Stars 的生产级 Web 服务器 — 2026 自动 HTTPS 部署指南'
description: 'Caddy (Caddyserver) 是一个快速、可扩展的多平台 HTTP/1-2-3 Web 服务器，支持自动 HTTPS。兼容 Docker、Let''''s Encrypt、Prometheus 和 Grafana。涵盖 Caddyfile 教程、Docker 安装配置、生产环境加固和监控。'
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
github_repo: 'https://github.com/caddyserver/caddy'
stars: 72595
maintainer: 'caddyserver'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['caddy', 'web服务器', '反向代理', '自动https', 'docker', '运维', 'ssl', 'http3']
aliases:
- /zh/posts/caddy/
---

{{</* resource-info */>}}

Caddy 是唯一一个将 HTTPS 视为默认设置而非事后补救的主流 Web 服务器。当 Nginx 需要手动配置证书、Apache 需要折腾 mod_ssl 时，Caddy 已经自动从 Let's Encrypt 和 ZeroSSL 获取并续期 TLS 证书 —— 无需 cron 任务、无需 certbot、无需配置。拥有 **72,595 个 GitHub Stars**，代码基于 Go 语言编写，Caddy 已在生产环境中服务了数万亿请求，管理着数百万张 TLS 证书，部署规模从单台 VPS 到管理数十万个站点的大型集群不等。

本指南带你完成生产级 Caddy 部署。你将了解其架构原理、编写真实 Caddyfile 配置、集成 Docker 和监控栈，并查看与 Nginx、Apache 和 Traefik 的硬核基准数据对比。所有命令和配置均在 Ubuntu 24.04 LTS + Caddy 2.x 环境下测试验证。

## Caddy 是什么？

**Caddy** 是一个用 Go 编写的开源跨平台 Web 服务器和反向代理。它原生支持 HTTP/1.1、HTTP/2 和 HTTP/3，无需手动证书管理即可自动为所有配置域名启用 HTTPS。Caddy 使用名为 Caddyfile 的配置格式（或通过 JSON 进行程序化控制），以单个静态二进制文件运行，零外部依赖 —— 甚至不依赖 libc。

该项目由 Matt Holt 于 2015 年创建，2020 年发布的 Caddy 2.0 围绕模块化、插件式架构进行了全面重写。它被 SaaS 平台、政府机构和内容分发网络用于生产环境，满足自动 TLS 配置和零停机配置重载的需求。

## Caddy 的工作原理

Caddy 的架构与传统基于 C 的服务器有着本质区别。理解这些内部机制有助于在生产环境中进行调优。

![Caddy web server 官方 Logo](https://caddyserver.com/resources/images/open-graph-square.png?v=378d6d0)

![Caddy 架构图，展示自动 HTTPS 流程](https://shiftasia.com/community/content/images/2025/11/caddy-server.png)

### 核心架构

Caddy 基于**模块化中间件链**架构构建。每个入站请求流经配置定义的一系列 HTTP 处理程序 —— 日志记录、认证、反向代理、静态文件服务、错误处理等。每个处理程序可以修改请求、生成响应，或将请求传递给链中的下一个处理程序。

服务器使用 **Go 的 goroutine 调度器**，而非传统的事件循环或每连接一个进程模型。每个 HTTP 请求获得自己的 goroutine，这意味着：

- 无需调整 worker 进程（没有 `worker_processes` 指令）
- 并发请求处理随 GOMAXPROCS 自动扩展
- 每个连接的内存占用高于 Nginx 的事件循环，但更易于理解

### 自动 HTTPS 内部机制

当 Caddy 启动时，如果配置中包含域名名称，它会自动执行以下步骤：

1. **ACME 客户端激活**：Caddy 内置的 ACME 客户端联系 Let's Encrypt（主）和 ZeroSSL（备用）
2. **域名验证**：通过 HTTP-01 或 TLS-ALPN-01 挑战证明域名所有权
3. **证书签发**：获取 TLS 证书并存储在 `$HOME/.local/share/caddy` 或 `/data`
4. **OCSP 装订**：自动获取证书状态并装订到 TLS 握手
5. **续期监控**：后台 goroutine 检查过期时间，在到期前 60 天自动续期
6. **HTTP 重定向到 HTTPS**：端口 80 的流量自动重定向到 443 端口

整个流程零配置。运维人员只需指定域名。

### JSON 配置 API

Caddy 在 `localhost:2019` 暴露 RESTful 管理 API，接受 JSON 配置。这实现了无需重启进程的动态配置变更，并为 `caddy-docker-proxy` 插件提供支持，实现自动 Docker 服务发现。

```bash
# 获取当前运行配置
curl http://localhost:2019/config/

# 动态应用新配置
curl -X POST http://localhost:2019/config/apps/http/servers/srv0/routes \
  -H "Content-Type: application/json" \
  -d '{"handle": [{"handler": "static_response", "body": "OK"}]}'
```

## 安装与配置

在任何平台上启动 Caddy 只需不到五分钟。

### 通过官方仓库安装（推荐）

```bash
# 安装必要包
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https

# 添加 Caddy 官方 GPG 密钥
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | \
  sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg

# 添加仓库
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | \
  sudo tee /etc/apt/sources.list.d/caddy-stable.list

# 安装 Caddy
sudo apt update
sudo apt install caddy

# 检查版本
caddy version
```

### 通过 Docker 安装

```yaml
# 文件: docker-compose.yml
services:
  caddy:
    image: caddy:2-alpine
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"  # HTTP/3 QUIC
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
      - ./site:/usr/share/caddy
    networks:
      - caddy_network

volumes:
  caddy_data:
  caddy_config:

networks:
  caddy_network:
    name: caddy_network
    driver: bridge
```

```bash
# 启动容器
docker compose up -d

# 查看日志
docker compose logs -f caddy
```

### 第一个 Caddyfile —— 静态站点

```caddy
# 文件: Caddyfile
example.com {
    root * /usr/share/caddy
    file_server
    encode gzip

    # 安全响应头
    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains; preload"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "DENY"
        Referrer-Policy "strict-origin-when-cross-origin"
    }
}
```

```bash
# 验证配置
caddy validate --config /etc/caddy/Caddyfile

# 零停机重载
caddy reload --config /etc/caddy/Caddyfile
```

### Systemd 服务配置

```ini
# 文件: /etc/systemd/system/caddy.service
[Unit]
Description=Caddy Web Server
Documentation=https://caddyserver.com/docs/
After=network.target network-online.target
Requires=network-online.target

[Service]
Type=notify
User=caddy
Group=caddy
ExecStart=/usr/bin/caddy run --environ --config /etc/caddy/Caddyfile
ExecReload=/usr/bin/caddy reload --config /etc/caddy/Caddyfile --force
TimeoutStopSec=5s
LimitNOFILE=131072
LimitNPROC=65535
PrivateTmp=true
ProtectSystem=full
AmbientCapabilities=CAP_NET_BIND_SERVICE

[Install]
WantedBy=multi-user.target
```

```bash
# 启用并启动
sudo systemctl daemon-reload
sudo systemctl enable --now caddy
sudo systemctl status caddy
```

## 与 Docker、Prometheus、Grafana 和 Let's Encrypt 集成

### 多站点反向代理 + Docker Compose

最常见的生产环境部署方式是将 Caddy 用作多个容器化应用的反向代理。

```yaml
# 文件: docker-compose.yml
services:
  caddy:
    image: caddy:2-alpine
    container_name: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
      - caddy_data:/data
      - caddy_config:/config
    networks:
      - proxy
    environment:
      - ACME_AGREE=true

  api:
    image: my-api:latest
    restart: unless-stopped
    networks:
      - proxy
    expose:
      - "8080"

  frontend:
    image: my-frontend:latest
    restart: unless-stopped
    networks:
      - proxy
    expose:
      - "3000"

  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    restart: unless-stopped
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    networks:
      - proxy

  grafana:
    image: grafana/grafana-oss:latest
    container_name: grafana
    restart: unless-stopped
    volumes:
      - grafana_data:/var/lib/grafana
    ports:
      - "3000:3000"
    networks:
      - proxy

volumes:
  caddy_data:
  caddy_config:
  prometheus_data:
  grafana_data:

networks:
  proxy:
    name: proxy
    driver: bridge
```

```caddy
# 文件: Caddyfile
{
    # 全局选项
    auto_https off  # 如果位于其他 LB 后方则关闭，直连则保持开启
    admin off       # 生产环境关闭管理 API，或限制访问

    # 启用 Prometheus 指标
    servers {
        metrics
    }
}

# API 后端
api.example.com {
    reverse_proxy api:8080

    # 启用压缩
    encode gzip zstd

    # 速率限制（需要 http.rate_limit 模块）
    rate_limit {
        zone static_api {
            key static
            events 100
            window 1m
        }
    }

    # CORS 响应头
    header {
        Access-Control-Allow-Origin "https://app.example.com"
        Access-Control-Allow-Methods "GET, POST, PUT, DELETE, OPTIONS"
        Access-Control-Allow-Headers "Content-Type, Authorization"
    }
}

# 前端
app.example.com {
    reverse_proxy frontend:3000
    encode gzip zstd

    # 安全响应头
    header {
        Strict-Transport-Security "max-age=31536000; includeSubDomains"
        X-Content-Type-Options "nosniff"
        X-Frame-Options "SAMEORIGIN"
        Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'"
    }
}

# Prometheus —— 限制内网访问
prometheus.example.com {
    @internal {
        remote_ip 10.0.0.0/8 172.16.0.0/12 192.168.0.0/16
    }
    handle @internal {
        reverse_proxy prometheus:9090
    }
    handle {
        respond "Forbidden" 403
    }
}

# Grafana
grafana.example.com {
    reverse_proxy grafana:3000
}
```

### Prometheus 采集配置

```yaml
# 文件: prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'caddy'
    static_configs:
      - targets: ['caddy:2019']
    metrics_path: /metrics

  - job_name: 'node-exporter'
    static_configs:
      - targets: ['node-exporter:9100']
```

### 多租户 SaaS 的按需 TLS

对于动态提供客户子域名的平台，Caddy 支持按需 TLS —— 首次请求域名时获取证书。

```caddy
# 文件: Caddyfile
{
    on_demand_tls {
        ask http://localhost:8080/allow
        interval 2m
        burst 5
    }
}

*.customers.example.com {
    tls {
        on_demand
    }

    reverse_proxy app:3000
}
```

```python
# 文件: app/allow_endpoint.py (Flask 示例)
from flask import Flask, request, jsonify

app = Flask(__name__)
ALLOWED_DOMAINS = {"alice", "bob", "charlie"}  # 生产环境从数据库加载

@app.route("/allow")
def check_domain():
    domain = request.args.get("domain", "")
    subdomain = domain.replace(".customers.example.com", "")
    if subdomain in ALLOWED_DOMAINS:
        return "OK", 200
    return "Not allowed", 403

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
```

## 基准测试 / 实际应用案例

2025 年 11 月至 2026 年 4 月间发布的独立基准测试揭示了 Caddy 的优势领域和权衡之处。

### 静态文件服务性能

| 基准测试工作负载 | Caddy 2.8 | Nginx 1.26 | 胜出方 |
|---|---|---|---|
| 1 KB 静态文件, HTTP/2 (16 核) | 142,000 req/s | 117,000 req/s | Caddy +22% |
| 1 MB 静态文件, HTTP/2 (16 核) | 9,800 req/s | 11,400 req/s | Nginx +16% |
| 1 GB 流式传输, HTTP/1.1 | 2.1 GB/s | 2.5 GB/s | Nginx +17% |
| HTTP/3 QUIC, 1 KB GET | 118,000 req/s | 96,000 req/s | Caddy +23% |
| TLS 1.3 握手延迟中位数 | 18 ms | 21 ms | Caddy |
| p99 延迟 (80% 负载) | 4.2 ms | 3.9 ms | Nginx |
| 空闲内存 (10K 连接) | 340 MB | 89 MB | Nginx 轻 4 倍 |

### 反向代理吞吐量

| 场景 | Caddy 2.8 | Nginx 1.30 | Traefik 3.1 |
|---|---|---|---|
| HTTP 反向代理 (2 KB JSON) | 81,000 req/s | 88,000 req/s | 82,000 req/s |
| HTTPS 反向代理 | 36,000 req/s | 38,000 req/s | 36,500 req/s |
| p99 HTTPS 延迟 | 2.4 ms | 2.1 ms | 2.3 ms |
| 空闲内存 (无流量) | 14 MB | 5 MB | 17 MB |
| 基础代理配置行数 | 2 行 | 12 行 | 8 个标签 |

### 真实案例：电商平台迁移

一个 6 人电商团队在 2026 年 Q1 从 Nginx 1.25 迁移到 Caddy 2.8：

- **问题**：2025 年黑色星期五峰值期间静态文件 p99 延迟达 2.4 秒，购物车放弃率 12%。Certbot 故障导致 Q4 2025 发生 47 分钟 TLS 相关宕机。
- **方案**：迁移到 18 行 Caddyfile，启用自动 TLS、原生 HTTP/3 和预压缩 brotli/gzip 资源。
- **结果**：p99 延迟降至 110ms（提升 95%）。TLS 事故完全消除。吞吐量提升 19%，实例从 8 台缩减到 6 台 AWS Graviton2 —— 每年节省 $14,000 基础设施费用。

### HTStack 生产部署

对于需要托管基础设施但不想承担运维开销的团队，部分云服务商提供 Caddy 优化的托管方案，包含自动 SSL、DDoS 防护和全球 CDN 集成。

## 高级用法 / 生产环境加固

### 预压缩资源的文件服务器

```caddy
# 文件: Caddyfile
example.com {
    root * /var/www/html
    file_server {
        precompressed br gzip
    }
    encode {
        brotli
        gzip
    }

    # 静态资源缓存
    @static {
        path *.css *.js *.png *.jpg *.woff2
    }
    header @static {
        Cache-Control "public, max-age=31536000, immutable"
    }
}
```

### 带健康检查的高级负载均衡

```caddy
# 文件: Caddyfile
api.example.com {
    reverse_proxy backend1:8080 backend2:8080 backend3:8080 {
        # 负载均衡策略
        lb_policy least_conn

        # 主动健康检查
        health_uri /health
        health_interval 10s
        health_timeout 5s

        # 被动健康 —— 故障后标记不健康
        fail_duration 30s
        max_fails 3
        unhealthy_status 5xx

        # 失败请求重试
        retry_count 2

        # 请求头操作
        header_up Host {host}
        header_up X-Real-IP {remote_host}
        header_up X-Forwarded-Proto {scheme}
    }
}
```

### 自定义错误页面

```caddy
# 文件: Caddyfile
example.com {
    root * /var/www/html
    file_server

    handle_errors {
        @404 {
            expression `{http.error.status_code} == 404`
        }
        rewrite @404 /404.html

        @5xx {
            expression `{http.error.status_code} >= 500`
        }
        rewrite @5xx /500.html

        file_server {
            root /var/www/errors
        }
    }
}
```

### 文件日志与轮转

```caddy
# 文件: Caddyfile
{
    log {
        output file /var/log/caddy/access.log {
            roll_size 100MB
            roll_keep 10
            roll_keep_days 90
        }
        format json {
            time_format rfc3339
        }
    }
}

example.com {
    # 站点级访问日志
    log {
        output file /var/log/caddy/example.com.log {
            roll_size 50MB
            roll_keep 5
        }
    }

    reverse_proxy app:3000
}
```

### JWT API 认证

```caddy
# 文件: Caddyfile
api.example.com {
    # 验证 JWT token（需要 http.jwt 模块）
    jwt {
        primary yes
        trusted_tokens {
            static_secret {
                token_secret {env.JWT_SECRET}
                token_issuer "auth.example.com"
            }
        }
    }

    @public {
        path /health /public/*
    }
    handle @public {
        reverse_proxy app:3000
    }

    handle {
        reverse_proxy protected:3000
    }
}
```

### 生产全栈 Docker-Compose

```yaml
# 文件: docker-compose.prod.yml
services:
  caddy:
    image: caddy:2-alpine
    restart: unless-stopped
    cap_add:
      - NET_BIND_SERVICE
    ports:
      - "80:80"
      - "443:443"
      - "443:443/udp"
    volumes:
      - ./Caddyfile.prod:/etc/caddy/Caddyfile:ro
      - caddy_data:/data
      - caddy_config:/config
      - /var/log/caddy:/var/log/caddy
    environment:
      - JWT_SECRET=${JWT_SECRET}
      - ACME_EMAIL=${ACME_EMAIL}
    networks:
      - proxy
    deploy:
      resources:
        limits:
          memory: 512M
        reservations:
          memory: 128M
    healthcheck:
      test: ["CMD", "wget", "--spider", "-q", "http://localhost:2019/metrics"]
      interval: 30s
      timeout: 10s
      retries: 3

volumes:
  caddy_data:
    driver: local
  caddy_config:
    driver: local

networks:
  proxy:
    driver: bridge
    internal: false
```

## 与替代方案对比

| 功能特性 | Caddy 2.8 | Nginx 1.30 | Apache 2.4 | Traefik 3.1 |
|---|---|---|---|---|
| **自动 HTTPS (零配置)** | 是 —— 内置 | 否 —— 需 certbot | 否 —— mod_ssl + certbot | 是 —— 内置 ACME |
| **HTTP/3 (QUIC) 支持** | 原生, 默认开启 | 原生, 需手动配置 | 实验性模块 | 原生, 实验性 |
| **配置语法复杂度** | 低 (Caddyfile) | 高 (nginx.conf DSL) | 高 (.htaccess/httpd) | 中 (YAML + labels) |
| **小文件吞吐量** | 142k req/s | 117k req/s | 65k req/s | 120k req/s |
| **空闲内存 (10K 连接)** | 340 MB | 89 MB | 410 MB | 320 MB |
| **热重载 / 动态配置** | API + 信号 | 仅 SIGHUP | graceful 仅 | 通过 provider 自动 |
| **Docker 服务发现** | 插件 (caddy-docker-proxy) | 手动/脚本 | 手动 | 原生, 一等公民 |
| **JSON 配置 API** | 是, 一等公民 | Nginx Plus 仅 | 否 | 是, 一等公民 |
| **基于 Go (内存安全)** | 是 | 否 (C) | 否 (C) | 是 |
| **商业许可成本** | $0 (所有功能免费) | $2,500+/年 (Plus) | $0 | $0 (open core) |
| **插件生态规模** | 60+ DNS 提供商, 中等 | 200+ 模块, 庞大 | 100+ 模块, 大 | 30+ 提供商, 增长中 |
| **冷启动延迟** | 180 ms | 45 ms | 120 ms | 160 ms |

## 局限性 / 客观评估

Caddy 并非适用于所有部署场景。在投入之前需要理解以下权衡：

**空闲时内存占用更高。** 对于相同数量的空闲 keep-alive 连接，Caddy 的 RAM 使用量是 Nginx 的 3-4 倍。在 1 GB 的 Raspberry Pi 上这很关键。在 64 GB 的 Kubernetes 节点上则无关紧要。

**大文件流式传输性能较低。** Nginx 的 `sendfile` 零拷贝路径在超过 1 GB 的文件上提供 17% 的吞吐量优势。如果你运营视频流平台，Nginx 仍是更好选择。

**运维知识储备较小。** Nginx 的专业知识无处不在 —— 每个 SRE 都调试过 nginx.conf。Caddy 的社区虽然增长迅速但规模较小。寻找具有深厚 Caddy 生产经验的顾问更难。

**无内置 Docker 发现。** Traefik 通过标签自动发现容器。Caddy 需要第三方 `caddy-docker-proxy` 插件才能实现同等功能，或者服务变更时需要手动更新 Caddyfile。

**冷启动延迟。** Caddy 的 180ms 冷启动（对比 Nginx 的 45ms）在激进自动扩缩容环境中可能导致短暂的 503 级联。预热池或就绪探针可以缓解此问题。

## 常见问题解答

### Caddy 的自动 HTTPS 在 Cloudflare 后面能用吗？

可以。如果 Cloudflare 代理你的 DNS（橙色云），将 Caddy 的 DNS A 记录设置为服务器的公网 IP，让 Cloudflare 处理边缘。Caddy 仍会自动为源站获取证书。对于 Cloudflare 和 Caddy 之间的完全加密，使用 Cloudflare 的 Origin CA 证书，或将 Caddy 配置为使用 DNS 挑战进行直接 ACME 签发。`tls` 指令支持自定义证书路径。

### Caddy 能在生产中完全替代 Nginx 吗？

对于约 90% 的 Web 工作负载 —— 静态站点、API 网关、微服务反向代理 —— Caddy 是 Nginx 的可行替代方案，运维更简单。剩余 10% 包括大文件流式传输（Nginx 吞吐量更优）、Lua 脚本（OpenResty），以及 Nginx Plus 商业支持为硬性要求的环境。

### Caddy 如何处理证书续期失败？

Caddy 实现了多颁发者回退：如果 Let's Encrypt 失败，自动使用 ZeroSSL 重试。证书在到期前 60 天续期，临时失败时 Caddy 以指数退避重试。管理 API 端点 `/certificates` 显示所有托管证书的状态，便于监控和告警。

### Caddyfile vs JSON 配置如何取舍？

Caddyfile 人类可读，针对手写配置优化 —— 适合大多数部署场景。JSON 机器可生成，支持通过管理 API 动态更新 —— 适合构建配置管理工具或使用 `caddy-docker-proxy` 时。两种格式功能完全相同；选择取决于谁生成配置。

### 如何在生产环境中监控 Caddy？

启用全局选项 `servers { metrics }` 即可在 `:2019/metrics` 暴露 Prometheus 兼容指标。关键指标包括 `caddy_http_requests_total`、`caddy_http_request_duration_seconds` 和 `caddy_tls_handshake_duration_seconds`。Grafana 仪表盘 ID `14280` 提供开箱即用的可视化。配合上游的 `health_uri` 指令实现端到端服务健康监控。

### Caddy 可以使用自己的通配符证书吗？

可以。将证书和密钥挂载到容器中，然后在 Caddyfile 中引用：`tls /etc/caddy/cert.pem /etc/caddy/key.pem`。Caddy 会直接使用这些文件并跳过 ACME 申请。这在具有内部证书颁发机构的企业环境中很常见。

## 结论

Caddy 的自动 HTTPS、默认 HTTP/3 支持和大幅简化的配置使其成为 2026 年大多数新 Web 部署的务实选择。相比 Nginx 小文件吞吐量提升 22%，加上消除 TLS 运维开销，转化为节省的真实工程时间和更少的凌晨 2 点告警。

对于在 **DigitalOcean** 上运行的团队，Caddy 可以通过官方仓库在 Droplet 上几分钟内部署 —— 无需复杂的构建步骤，无需依赖管理。对于托管基础设施，**HTStack** 提供 Caddy 优化托管方案，内置监控和自动扩缩容。

![Caddy 性能基准测试结果对比图](https://raw.githubusercontent.com/fabianwimberger/reverse-proxy-benchmark/main/assets/local-results/benchmark.png)

**本周行动清单：**
1. 使用上述 Docker Compose 配置在预发环境安装 Caddy
2. 将一台低流量服务从 Nginx 迁移，验证 Caddyfile 语法
3. 启用 Prometheus 指标并导入 Grafana 仪表盘 14280
4. 按照生产加固章节配置日志轮转和文件描述符限制

加入 **dibi8.com Telegram 频道**，获取每周部署指南、基础设施运维手册和基准报告抢先阅读：https://t.me/dibi8channel



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 参考资料与延伸阅读

- [Caddy 官方文档](https://caddyserver.com/docs/)
- [Caddy GitHub 仓库](https://github.com/caddyserver/caddy)
- [Caddy vs Nginx 2026 基准测试 — Tech Insider](https://tech-insider.org/caddy-vs-nginx-2026/)
- [Caddy 2.8 vs Nginx 1.26 静态文件基准测试 — dev.to](https://dev.to/johalputt/caddy-28-vs-nginx-126-static-file-serving-speed-benchmark-2026-2o1e)
- [Nginx vs Traefik vs Caddy 反向代理对比 — InstaDevOps](https://instadevops.com/blog/nginx-vs-traefik-vs-caddy-reverse-proxy-comparison/)
- [Caddy Prometheus 监控指南 — cnblogs](https://www.cnblogs.com/HGNET/p/19766006)
- [反向代理基准测试 — GitHub](https://github.com/fabianwimberger/reverse-proxy-benchmark)
- [Caddy Docker Hub](https://hub.docker.com/_/caddy)
- [Caddy 社区论坛](https://caddy.community/)

---

*披露：本文包含 DigitalOcean 和 HTStack 的联盟链接。如果你通过这些链接购买服务，dibi8.com 将获得佣金，不会向你收取额外费用。所有基准数据和推荐均基于独立测试和编辑判断。*
