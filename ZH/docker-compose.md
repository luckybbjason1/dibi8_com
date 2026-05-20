---
title: 'Docker Compose: 37,393 GitHub Stars — 多容器应用完整配置指南 2026'
description: 'Define and run multi-container applications with Docker using declarative YAML configuration.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/docker/compose'
stars: 37393
maintainer: 'docker'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['docker-compose', '容器编排', 'devops', 'docker', '微服务', '部署', 'yaml', '多容器']
aliases:
- /zh/posts/docker-compose/
---

{{</* resource-info */>}}

![Docker Compose Logo](https://raw.githubusercontent.com/docker/compose/main/logo.png)

## 简介

使用原始的 `docker run` 命令管理多容器应用很快就会变得难以控制。一个典型的 Web 技术栈需要数据库、缓存、反向代理和应用程序本身——这是四个独立的容器，需要配置网络、卷和环境变量。Docker Compose 通过一个声明式的 YAML 文件解决了这个问题。凭借超过 37,000 个 GitHub stars，它仍然是本地开发和单节点生产部署中被最广泛采用的工具。本指南涵盖了从安装到生产加固的所有内容，并提供了可立即部署的真实配置。

## 什么是 Docker Compose？

Docker Compose 是一个使用声明式 YAML 配置文件（通常是 `compose.yaml`）来定义和运行多容器 Docker 应用程序的工具。它自动处理服务发现、网络创建、卷挂载和启动顺序——将一个文件夹中的容器定义转换为可通过一条命令运行的系统。

## Docker Compose 的工作原理

![Docker Compose 架构](https://docs.docker.com/get-started/docker-concepts/running-containers/images/multi-container-apps-compose.png)

其架构简单直观。你编写一个 `compose.yaml` 文件来描述服务、网络和卷。`docker compose` CLI 插件读取该文件并将其转换为 Docker Engine API 调用。底层工作机制如下：

1. **项目隔离**：Compose 创建一个专用的 Docker 网络，名称为 `<project>_<network>`（默认值：目录名 + `_default`）。项目中的所有服务在此隔离的桥接网络上通信。
2. **服务发现**：容器通过服务名相互访问。如果你有一个 `db` 服务，你的 `api` 容器可以通过 `db:5432` 连接，无需任何 DNS 配置。
3. **卷管理**：命名卷在容器重启后持久保存数据。Compose 会在卷名称前加上项目名称以避免冲突。
4. **依赖排序**：`depends_on` 指令控制启动顺序。结合 `condition: service_healthy`，它确保数据库在应用启动前已就绪。
5. **资源生命周期**：`docker compose up` 创建所有资源；`docker compose down` 销毁它们。添加 `--volumes` 可删除持久数据，`--rmi all` 可清理镜像。

现代的 Compose 规范（v2.x+，基于 Go）采用滚动更新规范——不再需要 `version:` 顶层键。规范文件名从 `docker-compose.yml` 更改为 `compose.yaml`，但两者都被接受以保持向后兼容。

## 安装与配置

Docker Compose v2 作为 CLI 插件与 Docker Engine 捆绑发布。基于 Python 的遗留 `docker-compose`（v1）二进制文件已于 2023 年弃用，不再维护。

### Linux（Ubuntu/Debian）

```bash
# 更新软件包索引
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# 添加 Docker 官方 GPG 密钥
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# 添加仓库
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# 安装 Docker Engine + Compose 插件
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# 将用户添加到 docker 组（需要重新登录）
sudo usermod -aG docker $USER
newgrp docker

# 验证
docker compose version
# 预期输出：Docker Compose version v2.36.0+
```

### macOS

从 [docker.com](https://www.docker.com/products/docker-desktop/) 下载 Docker Desktop。Docker Compose 已捆绑在内。在 Apple Silicon 上，Docker Desktop 使用 Virtualization.framework，比旧版 QEMU 后端性能提升 30-40%。

```bash
# 安装后验证
docker compose version
```

### 安装后验证

```bash
# 检查 compose 项目中运行的容器
docker compose ps

# 查看所有服务的日志
docker compose logs --tail 100 -f

# 检查资源使用情况
docker stats --no-stream
```

### Windows（WSL2）

```powershell
# 启用 WSL2
wsl --install
# 重启后安装 Docker Desktop，确保勾选 WSL2 后端
docker compose version
```

### 手动二进制安装

对于没有包管理器的环境：

```bash
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.36.0/docker-compose-linux-x86_64 \
  -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version
```

## 与流行工具集成

### Traefik（反向代理和负载均衡器）

Traefik 自动发现 Docker 容器并根据标签路由流量。这消除了手动配置 nginx 的需要：

```yaml
# compose.yaml — Traefik + Whoami 示例
name: proxy-demo

services:
  traefik:
    image: traefik:v3.3
    command:
      - "--api.insecure=true"
      - "--providers.docker=true"
      - "--providers.docker.exposedbydefault=false"
      - "--entrypoints.web.address=:80"
    ports:
      - "80:80"
      - "8080:8080"
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro

  whoami:
    image: traefik/whoami
    labels:
      - "traefik.enable=true"
      - "traefik.http.routers.whoami.rule=Host(`whoami.localhost`)"
      - "traefik.http.routers.whoami.entrypoints=web"
```

使用 `docker compose up -d` 启动，然后访问 `http://whoami.localhost`。

### Prometheus + Grafana（监控技术栈）

```yaml
# compose.yaml — 监控技术栈
name: monitoring

services:
  prometheus:
    image: prom/prometheus:v3.2.0
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml:ro
      - prometheus_data:/prometheus
    ports:
      - "9090:9090"
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

  grafana:
    image: grafana/grafana:11.5.0
    ports:
      - "3000:3000"
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    depends_on:
      - prometheus

volumes:
  prometheus_data:
  grafana_data:
```

Prometheus 抓取容器指标；Grafana 将其可视化。登录后在 `http://prometheus:9090` 添加 Prometheus 数据源。

### 全栈应用（PostgreSQL + Redis + FastAPI + Nginx）

```yaml
# compose.yaml — 生产级三层应用
name: myapp

services:
  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_USER: appuser
      POSTGRES_PASSWORD: ${DB_PASSWORD}
      POSTGRES_DB: appdb
    volumes:
      - postgres_data:/var/lib/postgresql/data
    health检查:
      test: ["CMD-SHELL", "pg_isready -U appuser -d appdb"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_period: 30s
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    health检查:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 3
    restart: unless-stopped

  api:
    build:
      context: ./api
      dockerfile: Dockerfile
    environment:
      DATABASE_URL: postgresql://appuser:${DB_PASSWORD}@db:5432/appdb
      REDIS_URL: redis://redis:6379/0
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    health检查:
      test: ["CMD", "curl", "-f", "http://localhost:8000/health"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 20s
    restart: unless-stopped

  nginx:
    image: nginx:1.27-alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/conf.d/default.conf:ro
    depends_on:
      api:
        condition: service_healthy
    restart: unless-stopped

volumes:
  postgres_data:
  redis_data:
```

这里展示的关键模式：健康检查依赖、用于持久化的命名卷、用于自定义镜像的构建上下文，以及用于弹性的 `restart: unless-stopped`。

## 基准测试 / 实际用例

Docker Compose 在特定场景中表现出色。以下是生产部署和对比的数据：

| 指标 | Docker Compose | Kubernetes | Podman Compose | Nomad |
|------|---------------|------------|----------------|-------|
| **控制平面内存** | ~50 MB | ~2 GB | 0 MB（无守护进程） | ~100 MB |
| **支持的节点** | 单节点 | 无限 | 单节点 | 无限 |
| **每项目服务数** | 1-50 典型 | 1-10,000+ | 1-50 典型 | 1-1,000+ |
| **首次部署时间** | < 5 分钟 | 2-8 小时 | < 5 分钟 | 30-60 分钟 |
| **三层应用 YAML 行数** | ~40 | ~200+（Deployment + Service） | ~40 | ~80 |
| **自动扩缩容** | 手动（docker compose up --scale） | 原生 HPA | 手动 | 原生 |
| **滚动更新** | 仅重建 | 原生 | 仅重建 | 原生 |

**启动速度**：Docker Compose 在 4 核机器上可在 10 秒内启动一个 5 服务的技术栈。等效的 Kubernetes Helm 部署（包括 Pod 调度）需要 60-120 秒。

**资源效率**：Compose 开销约为 CLI + Docker 守护进程 50 MB RAM。最小化的 Kubernetes 控制平面在运行任何工作负载前就消耗约 2 GB。对于单节点上少于 10 个服务的部署，Compose 的编排开销低 40 倍。

**CI/CD 采用率**：超过 90% 使用容器的 GitHub Actions 工作流依赖 Docker Compose 进行集成测试环境配置。`docker compose up --wait` 命令（等待健康状态）消除了由竞态条件导致的测试管道不稳定问题。

## 高级用法 / 生产加固

### 健康检查和启动顺序

切勿在没有健康检查的情况下部署到生产环境。容器显示 `Up` 状态仅表示进程已启动——不代表应用正常工作：

```yaml
services:
  api:
    image: myapp:v1.2.3
    health检查:
      test: ["CMD", "curl", "-fsS", "http://localhost:8080/ready"]
      interval: 15s
      timeout: 5s
      retries: 3
      start_period: 30s
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
```

### 日志轮转

无限制的 JSON 日志会填满磁盘。使用本地日志驱动配置轮转：

```yaml
services:
  api:
    image: myapp:v1.2.3
    logging:
      driver: "local"
      options:
        max-size: "10m"
        max-file: "3"
        compress: "true"
```

### 资源限制

防止一个失控的容器耗尽其他容器的资源：

```yaml
services:
  worker:
    image: myapp-worker:v1.2.3
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 128M
```

### 用于环境分离的 Profiles

使用 profiles 定义仅开发使用的服务，无需维护多个文件：

```yaml
services:
  api:
    image: myapp:latest
    ports:
      - "8080:8080"

  db:
    image: postgres:16
    environment:
      POSTGRES_PASSWORD: devpass

  pgadmin:
    image: dpage/pgadmin4:latest
    profiles: ["debug"]
    ports:
      - "5050:80"
    environment:
      PGADMIN_DEFAULT_EMAIL: admin@local.dev
      PGADMIN_DEFAULT_PASSWORD: admin
```

仅在需要时运行调试工具：`docker compose --profile debug up -d`。不带此参数时，`pgadmin` 将被跳过。

### 密钥管理

切勿将密码提交到 compose 文件。使用 Docker secrets 或环境文件：

```yaml
services:
  api:
    image: myapp:latest
    secrets:
      - db_password
    environment:
      DB_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

### `include` 指令（Compose v2.20+）

将大型项目拆分为模块化的 compose 文件：

```yaml
# compose.yaml — 根文件
name: platform

include:
  - path: ./infra/postgres.yaml
  - path: ./infra/redis.yaml
  - path: ./apps/api.yaml
  - path: ./apps/worker.yaml
    env_file: ./apps/worker.env
```

每个被包含的文件都是一个有效的 compose 文件，包含自己的服务、网络和卷。这使单个文件保持在 50 行以内，便于代码审查。

### 蓝绿部署

对于无需 Kubernetes 的零停机更新，使用两个 compose 项目和反向代理：

```bash
#!/bin/bash
# deploy.sh
CURRENT=$(cat /tmp/current_slot 2>/dev/null || echo "blue")
NEW=$([ "$CURRENT" = "blue" ] && echo "green" || echo "blue")

# 构建并启动新槽位
docker compose -p "app-${NEW}" -f compose.yaml up -d --build --wait

# 更新 nginx 上游
sed -i "s/app-${CURRENT}/app-${NEW}/g" /etc/nginx/conf.d/upstream.conf
nginx -s reload

# 关闭旧槽位
docker compose -p "app-${CURRENT}" -f compose.yaml down

# 保存活跃槽位
echo "$NEW" > /tmp/current_slot
```

## 与替代品对比

| 特性 | Docker Compose | Kubernetes | Podman + Compose | Nomad |
|------|---------------|------------|------------------|-------|
| **学习曲线** | 低（单一 YAML） | 高（多种资源） | 低（兼容 Docker CLI） | 中等（HCL 配置） |
| **多节点** | 否（单主机） | 是 | 否（单主机） | 是 |
| **需要守护进程** | 是（dockerd） | 是（kubelet + 控制平面） | 否（无守护进程） | 是（Nomad agent） |
| **默认无 root** | 否 | 否 | 是 | 可选 |
| **自动扩缩容** | 仅手动 | 原生 HPA | 仅手动 | 原生 |
| **存储卷** | 仅本地 | CSI 插件（任意后端） | 仅本地 | 主机 + CSI |
| **密钥管理** | 基于文件的环境变量 | 原生 Secrets + Vault | 基于文件的环境变量 | Vault 集成 |
| **社区规模** | 37K+ stars | 110K+ (kubernetes/kubernetes) | 23K+ (containers/podman) | 15K+ (hashicorp/nomad) |
| **最适合** | 开发、CI/CD、小型生产 | 大规模生产 | 安全优先、无 root | 混合工作负载 |
| **许可证** | Apache-2.0 | Apache-2.0 | Apache-2.0 | BUSL（源码可用） |

## 局限性 / 诚实评估

Docker Compose 并非万能解决方案。以下是其不足之处：

**单节点限制**：Compose 在单个主机上运行。如果该主机故障，整个技术栈将停机。对于高可用性需求，你需要 Kubernetes、Nomad 或 Docker Swarm。

**无原生自动扩缩容**：`docker compose up --scale api=3` 有效，但它是手动的。没有像 Kubernetes HPA 那样基于 CPU 或内存的水平 Pod 自动扩缩容功能。

**密钥管理有限**：从文件读取的 Docker secrets 对于单节点设置来说可以接受。但缺乏 Kubernetes Secrets 或 HashiCorp Vault 提供的轮换、静态加密和细粒度 RBAC。

**滚动更新功能基础**：Compose 重建容器。它无法执行金丝雀部署、流量分割或回滚到先前的副本集。对于关键任务的零停机部署，请使用更复杂的编排器。

**网络仅限于本地**：默认桥接网络在单个主机内有效。多主机服务网格、入口控制器和跨区域负载均衡需要 Kubernetes 或 Istio 等服务网格。

**依赖守护进程**：与 Podman 不同，Compose 需要 Docker 守护进程（`dockerd`）运行。该守护进程是单点故障，在受监管环境中也是潜在的安全隐患。

## 常见问题解答

### 我的 compose 文件中还需要 `version: "3.8"` 这一行吗？

不需要。Compose 规范现在是无版本的。`version` 键在 Compose v2.x+ 和 v5.x 中会被忽略。新项目应完全省略它，并使用 `compose.yaml` 作为文件名。遗留的 `docker-compose.yml` 文件中的 version 行仍然有效以保持向后兼容。

### `docker-compose` 和 `docker compose` 有什么区别？

`docker-compose`（带连字符）是基于 Python 的遗留 v1 二进制文件，已于 2023 年弃用，不再维护。`docker compose`（带空格）是基于 Go 的 v2 CLI 插件，积极维护，速度更快，并与 Docker Engine 捆绑。所有新脚本和 CI 管道都应使用 `docker compose`。

### 如何在没有停机的情况下在生产环境中运行 Docker Compose？

Docker Compose 没有内置滚动更新。实用的方法有：(1) 对于内部工具，接受 `docker compose up -d` 期间的短暂停机，(2) 使用高级用法部分展示的蓝绿部署脚本配合两个 compose 项目和反向代理，或 (3) 当零停机是硬性要求时，迁移到 Kubernetes 或 Nomad。

### Docker Compose 可以与 Podman 一起使用吗？

可以，通过 `podman-compose` 提供约 90-95% 的兼容性。Podman 还通过 Docker API 兼容层支持 Docker Compose v2。然而，一些高级功能如带 `condition: service_healthy` 的 `depends_on` 可能表现不同。对于需要无 root 容器的团队，在确定方案前请用 Podman 测试你的特定 compose 文件。

### 如何调试启动失败的服务？

首先使用 `docker compose logs <service>` 查看 stderr/stdout。如果容器立即退出，使用 `docker compose run --rm <service> sh` 获取 shell 并检查环境。对于依赖问题，使用 `docker compose ps` 验证健康状态。添加带 `condition: service_healthy` 的 `depends_on` 来解决服务间的竞态条件。

### Docker Compose 可以免费商用吗？

可以。Docker Compose 基于 Apache-2.0 许可证开源，对个人和商业使用均免费。Docker Desktop（在 macOS 和 Windows 上包含 Compose）对 250 人以上或收入超过 1000 万美元的组织有许可限制，但 Compose CLI 插件本身在 Linux 上没有限制。

## 结论

Docker Compose 在 2026 年仍然是最实用的多容器部署工具。它将复杂的多服务技术栈转换为任何开发者都可以运行、测试和部署的单文件定义。对于开发环境、CI/CD 管道和单节点生产工作负载，37,393 个 GitHub stars 反映了真实的日常实用性——而非炒作。

**行动项：**
1. 将任何剩余的 `docker-compose`（v1）命令替换为 `docker compose`（v2）
2. 从 compose 文件中删除 `version:` 行，并将文件重命名为 `compose.yaml`
3. 为每个生产服务添加健康检查和 `restart: unless-stopped`
4. 在磁盘满之前设置日志轮转
5. 对于托管服务，[DigitalOcean](https://m.do.co/c/eca87ac14ee0) 提供预配置的 Docker droplet，可在 5 分钟内从空环境到 `docker compose up`，[HTStack](https://my.htstack.com/aff.php?aff=27187) 提供针对容器工作负载优化的托管 VPS 实例。

加入我们的 [Telegram 群组](https://t.me/dibi8dev) 分享你的 Docker Compose 配置，并从其他开发者那里获得帮助。

*本文包含联盟链接。如果你通过这些链接购买托管服务，dibi8.com 将获得佣金，不会增加你的额外成本。*



## 推荐工具

我们推荐的、与本文配套使用的工具：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — DigitalOcean
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — HTStack

*Aff 链接 — 不增加你的成本，但能帮 dibi8.com 持续运营。*

## 来源与延伸阅读

- [Docker Compose 官方文档](https://docs.docker.com/compose/)
- [Compose 规范参考](https://docs.docker.com/reference/compose-file/)
- [Docker Compose GitHub 仓库](https://github.com/docker/compose)
- [Traefik Docker 提供程序文档](https://doc.traefik.io/traefik/providers/docker/)
- [Prometheus Docker 监控指南](https://prometheus.io/docs/guides/cadvisor/)
- [Docker Compose vs Kubernetes — distr.sh](https://distr.sh/blog/docker-compose-vs-kubernetes/)
- [Podman vs Docker 2026 对比](https://daily.dev/blog/docker-vs-podman-container-runtime-which-to-use/)
- [Docker Compose 生产最佳实践](https://eastondev.com/blog/en/posts/dev/20260412-docker-compose-production/)
- [Nomad vs Docker Compose — hostmycode.com](https://www.hostmycode.com/blog/container-orchestration-beyond-kubernetes-2026-nomad-docker-swarm-podman-vps)
- [Docker Desktop 定价和许可](https://www.docker.com/pricing/)
