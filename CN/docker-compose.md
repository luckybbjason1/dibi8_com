---
title: 'Docker Compose: 37,393 GitHub Stars — Multi-Container Setup Guide 2026'
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
tags: ['docker-compose', 'container-orchestration', 'devops', 'docker', 'microservices', 'deployment', 'yaml', 'multi-container']
aliases:
- /posts/docker-compose/
---

{{</* resource-info */>}}

![Docker Compose Logo](https://raw.githubusercontent.com/docker/compose/main/logo.png)

## Introduction

Managing multi-container applications with raw `docker run` commands breaks down fast. A typical web stack needs a database, a cache, a reverse proxy, and the application itself — that's four separate containers with networks, volumes, and environment variables to wire together. Docker Compose solves this with a single declarative YAML file. With over 37,000 GitHub stars, it remains the most widely adopted tool for local development and single-node production deployments. This guide covers everything from installation to production hardening, with real configurations you can deploy today.

## What Is Docker Compose?

Docker Compose is a tool that defines and runs multi-container Docker applications using a declarative YAML configuration file (typically `compose.yaml`). It handles service discovery, network creation, volume mounting, and startup order automatically — turning a folder of container definitions into a runnable system with one command.

## How Docker Compose Works

![Docker Compose Architecture](https://docs.docker.com/get-started/docker-concepts/running-containers/images/multi-container-apps-compose.png)

The architecture is straightforward. You write a `compose.yaml` file describing your services, networks, and volumes. The `docker compose` CLI plugin reads this file and translates it into Docker Engine API calls. Here's what happens under the hood:

1. **Project isolation**: Compose creates a dedicated Docker network named `<project>_<network>` (default: directory name + `_default`). All services in the project communicate over this isolated bridge network.
2. **Service discovery**: Containers reach each other by service name. If you have a `db` service, your `api` container connects to `db:5432` without any DNS configuration.
3. **Volume management**: Named volumes persist data across container restarts. Compose prefixes volume names with the project name to avoid collisions.
4. **Dependency ordering**: The `depends_on` directive controls startup sequence. Combined with `condition: service_healthy`, it ensures your database is ready before the application starts.
5. **Resource lifecycle**: `docker compose up` creates everything; `docker compose down` tears it down. Add `--volumes` to remove persistent data, or `--rmi all` to clean up images.

The modern Compose specification (v2.x+, Go-based) is a rolling specification — the `version:` top-level key is no longer required. The canonical filename shifted from `docker-compose.yml` to `compose.yaml`, though both are accepted for backward compatibility.

## Installation & Setup

Docker Compose v2 ships as a CLI plugin bundled with Docker Engine. The legacy Python-based `docker-compose` (v1) binary was deprecated in 2023 and is no longer maintained.

### Linux (Ubuntu/Debian)

```bash
# Update package index
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg

# Add Docker's official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine + Compose plugin
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# Add user to docker group (logout required)
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker compose version
# Expected: Docker Compose version v2.36.0+
```

### macOS

Download Docker Desktop from [docker.com](https://www.docker.com/products/docker-desktop/). Docker Compose is bundled. On Apple Silicon, Docker Desktop uses Virtualization.framework for 30-40% better performance than the legacy QEMU backend.

```bash
# Verify after installation
docker compose version
```

### Post-Install Verification

```bash
# Check running containers in your compose project
docker compose ps

# View logs for all services
docker compose logs --tail 100 -f

# Check resource usage
docker stats --no-stream
```

### Windows (WSL2)

```powershell
# Enable WSL2
wsl --install
# Restart, then install Docker Desktop with WSL2 backend checked
docker compose version
```

### Manual Binary Install

For environments without package managers:

```bash
DOCKER_CONFIG=${DOCKER_CONFIG:-$HOME/.docker}
mkdir -p $DOCKER_CONFIG/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.36.0/docker-compose-linux-x86_64 \
  -o $DOCKER_CONFIG/cli-plugins/docker-compose
chmod +x $DOCKER_CONFIG/cli-plugins/docker-compose
docker compose version
```

## Integration with Popular Tools

### Traefik (Reverse Proxy & Load Balancer)

Traefik automatically discovers Docker containers and routes traffic based on labels. This eliminates manual nginx configuration:

```yaml
# compose.yaml — Traefik + Whoami example
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

Start with `docker compose up -d` and visit `http://whoami.localhost`.

### Prometheus + Grafana (Monitoring Stack)

```yaml
# compose.yaml — Monitoring stack
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

Prometheus scrapes container metrics; Grafana visualizes them. Add the Prometheus data source at `http://prometheus:9090` after login.

### Full-Stack Application (PostgreSQL + Redis + FastAPI + Nginx)

```yaml
# compose.yaml — Production-ready 3-tier app
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
    healthcheck:
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
    healthcheck:
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
    healthcheck:
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

Key patterns demonstrated: health-checked dependencies, named volumes for persistence, build contexts for custom images, and `restart: unless-stopped` for resilience.

## Benchmarks / Real-World Use Cases

Docker Compose excels in specific scenarios. Here are numbers from production deployments and comparisons:

| Metric | Docker Compose | Kubernetes | Podman Compose | Nomad |
|--------|---------------|------------|----------------|-------|
| **Control Plane RAM** | ~50 MB | ~2 GB | 0 MB (daemonless) | ~100 MB |
| **Nodes Supported** | Single node | Unlimited | Single node | Unlimited |
| **Services per Project** | 1-50 typical | 1-10,000+ | 1-50 typical | 1-1,000+ |
| **Time to First Deploy** | < 5 min | 2-8 hours | < 5 min | 30-60 min |
| **YAML Lines for 3-Tier App** | ~40 | ~200+ (Deployments + Services) | ~40 | ~80 |
| **Auto-Scaling** | Manual (docker compose up --scale) | Native HPA | Manual | Native |
| **Rolling Updates** | Recreate only | Native | Recreate only | Native |

**Startup speed**: Docker Compose brings up a 5-service stack in under 10 seconds on a 4-core machine. The equivalent Kubernetes deployment with Helm takes 60-120 seconds including pod scheduling.

**Resource efficiency**: Compose overhead is roughly 50 MB of RAM for the CLI + Docker daemon. A minimal Kubernetes control plane consumes ~2 GB before running any workloads. For deployments under 10 services on a single node, Compose uses 40x less orchestration overhead.

**CI/CD adoption**: Over 90% of GitHub Actions workflows that use containers rely on Docker Compose for integration test environments. The `docker compose up --wait` command (waits for healthy status) eliminates flaky test pipelines caused by race conditions.

## Advanced Usage / Production Hardening

### Health Checks and Startup Ordering

Never deploy to production without health checks. A container showing `Up` status only means the process started — not that your application works:

```yaml
services:
  api:
    image: myapp:v1.2.3
    healthcheck:
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

### Log Rotation

Unlimited JSON logs fill disks. Configure the local logging driver with rotation:

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

### Resource Limits

Prevent one runaway container from starving others:

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

### Profiles for Environment Separation

Use profiles to define dev-only services without maintaining multiple files:

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

Run debug tools only when needed: `docker compose --profile debug up -d`. Without the flag, `pgadmin` is skipped.

### Secrets Management

Never commit passwords to your compose file. Use Docker secrets or environment files:

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

### The `include` Directive (Compose v2.20+)

Split large projects into modular compose files:

```yaml
# compose.yaml — root file
name: platform

include:
  - path: ./infra/postgres.yaml
  - path: ./infra/redis.yaml
  - path: ./apps/api.yaml
  - path: ./apps/worker.yaml
    env_file: ./apps/worker.env
```

Each included file is a valid compose file with its own services, networks, and volumes. This keeps individual files under 50 lines and makes code review manageable.

### Blue/Green Deployments

For zero-downtime updates without Kubernetes, use two compose projects and a reverse proxy:

```bash
#!/bin/bash
# deploy.sh
CURRENT=$(cat /tmp/current_slot 2>/dev/null || echo "blue")
NEW=$([ "$CURRENT" = "blue" ] && echo "green" || echo "blue")

# Build and start new slot
docker compose -p "app-${NEW}" -f compose.yaml up -d --build --wait

# Update nginx upstream
sed -i "s/app-${CURRENT}/app-${NEW}/g" /etc/nginx/conf.d/upstream.conf
nginx -s reload

# Tear down old slot
docker compose -p "app-${CURRENT}" -f compose.yaml down

# Persist active slot
echo "$NEW" > /tmp/current_slot
```

## Comparison with Alternatives

| Feature | Docker Compose | Kubernetes | Podman + Compose | Nomad |
|---------|---------------|------------|------------------|-------|
| **Learning Curve** | Low (single YAML) | High (many resources) | Low (Docker CLI compatible) | Medium (HCL configs) |
| **Multi-Node** | No (single host) | Yes | No (single host) | Yes |
| **Daemon Required** | Yes (dockerd) | Yes (kubelet + control plane) | No (daemonless) | Yes (Nomad agent) |
| **Rootless by Default** | No | No | Yes | Optional |
| **Auto-Scaling** | Manual only | Native HPA | Manual only | Native |
| **Storage Volumes** | Local only | CSI plugins (any backend) | Local only | Host + CSI |
| **Secrets Management** | File-based env | Native Secrets + Vault | File-based env | Vault integration |
| **Community Size** | 37K+ stars | 110K+ (kubernetes/kubernetes) | 23K+ (containers/podman) | 15K+ (hashicorp/nomad) |
| **Best For** | Dev, CI/CD, small prod | Large-scale production | Security-focused, rootless | Mixed workloads |
| **License** | Apache-2.0 | Apache-2.0 | Apache-2.0 | BUSL (source available) |

## Limitations / Honest Assessment

Docker Compose is not a universal solution. Here is where it falls short:

**Single-node constraint**: Compose runs on one host. If that host fails, your entire stack goes down. For high-availability requirements, you need Kubernetes, Nomad, or Docker Swarm.

**No native auto-scaling**: `docker compose up --scale api=3` works, but it is manual. There is no CPU-based or memory-based horizontal pod autoscaling like Kubernetes HPA.

**Limited secrets management**: Docker secrets read from files are acceptable for single-node setups. They lack rotation, encryption at rest, and fine-grained RBAC that Kubernetes Secrets or HashiCorp Vault provide.

**Rolling updates are basic**: Compose recreates containers. It cannot do canary deployments, traffic splitting, or rollback to a previous replica set. For mission-critical zero-downtime deployments, use a more sophisticated orchestrator.

**Networking is local-only**: The default bridge network works within one host. Multi-host service mesh, ingress controllers, and cross-region load balancing require Kubernetes or a service mesh like Istio.

**Daemon dependency**: Unlike Podman, Compose requires the Docker daemon (`dockerd`) to run. The daemon is a single point of failure and a potential security concern in regulated environments.

## Frequently Asked Questions

### Do I still need the `version: "3.8"` line in my compose file?

No. The Compose specification is now versionless. The `version` key is ignored in Compose v2.x+ and v5.x. New projects should omit it entirely and use `compose.yaml` as the filename. Legacy `docker-compose.yml` files with a version line still work for backward compatibility.

### What is the difference between `docker-compose` and `docker compose`?

`docker-compose` (with a hyphen) is the legacy Python-based v1 binary, deprecated in 2023 and no longer maintained. `docker compose` (with a space) is the v2 CLI plugin written in Go, actively maintained, faster, and bundled with Docker Engine. All new scripts and CI pipelines should use `docker compose`.

### How do I run Docker Compose in production without downtime?

Docker Compose does not have built-in rolling updates. The pragmatic approaches are: (1) accept brief downtime during `docker compose up -d` for internal tools, (2) use the blue/green deployment script shown in the Advanced Usage section with two compose projects and a reverse proxy, or (3) migrate to Kubernetes or Nomad when zero-downtime is a hard requirement.

### Can I use Docker Compose with Podman?

Yes, via `podman-compose` which provides approximately 90-95% compatibility. Podman also supports Docker Compose v2 through the Docker API compatibility layer. However, some advanced features like `depends_on` with `condition: service_healthy` may behave differently. For teams requiring rootless containers, test your specific compose file with Podman before committing to it.

### How do I debug a service that fails to start?

Start with `docker compose logs <service>` to see stderr/stdout. If the container exits immediately, use `docker compose run --rm <service> sh` to get a shell and inspect the environment. For dependency issues, check `docker compose ps` to verify health statuses. Add `depends_on` with `condition: service_healthy` to fix race conditions between services.

### Is Docker Compose free for commercial use?

Yes. Docker Compose is open source under the Apache-2.0 license and free for both personal and commercial use. Docker Desktop (which includes Compose on macOS and Windows) has licensing restrictions for organizations with 250+ employees or $10M+ revenue, but the Compose CLI plugin itself has no restrictions on Linux.

## Conclusion

Docker Compose remains the most practical tool for multi-container deployments in 2026. It turns complex multi-service stacks into single-file definitions that any developer can run, test, and deploy. For development environments, CI/CD pipelines, and production workloads on a single node, the 37,393 GitHub stars reflect real daily utility — not hype.

**Action items:**
1. Replace any remaining `docker-compose` (v1) commands with `docker compose` (v2)
2. Remove the `version:` line from your compose files and rename them to `compose.yaml`
3. Add health checks and `restart: unless-stopped` to every production service
4. Set up log rotation before your disk fills up
5. For hosting, [DigitalOcean](https://m.do.co/c/eca87ac14ee0) offers pre-built Docker droplets that get you from zero to `docker compose up` in under 5 minutes, and [HTStack](https://my.htstack.com/aff.php?aff=27187) provides managed VPS instances optimized for container workloads.

Join our [Telegram group](https://t.me/dibi8dev) to share your Docker Compose configs and get help from other developers.

*This article contains affiliate links. If you purchase hosting through these links, dibi8.com receives a commission at no extra cost to you.*



## Recommended Tools

Products we recommend that complement this guide:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — DigitalOcean
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — HTStack

*Affiliate links — they don't cost you extra and they help keep dibi8.com running.*

## Sources & Further Reading

- [Docker Compose Official Documentation](https://docs.docker.com/compose/)
- [Compose Specification Reference](https://docs.docker.com/reference/compose-file/)
- [Docker Compose GitHub Repository](https://github.com/docker/compose)
- [Traefik Docker Provider Docs](https://doc.traefik.io/traefik/providers/docker/)
- [Prometheus Docker Monitoring Guide](https://prometheus.io/docs/guides/cadvisor/)
- [Docker Compose vs Kubernetes — distr.sh](https://distr.sh/blog/docker-compose-vs-kubernetes/)
- [Podman vs Docker 2026 Comparison](https://daily.dev/blog/docker-vs-podman-container-runtime-which-to-use/)
- [Docker Compose Production Best Practices](https://eastondev.com/blog/en/posts/dev/20260412-docker-compose-production/)
- [Nomad vs Docker Compose — hostmycode.com](https://www.hostmycode.com/blog/container-orchestration-beyond-kubernetes-2026-nomad-docker-swarm-podman-vps)
- [Docker Desktop Pricing and Licensing](https://www.docker.com/pricing/)
