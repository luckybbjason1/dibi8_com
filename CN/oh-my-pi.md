---
title: "Oh My Pi: Turn Any Raspberry Pi Into a Smart Device — 12K Star Project 2026"
description: "Oh My Pi (12,554 stars) transforms Raspberry Pi devices into smart home hubs, media centers, and development workstations with one-click setup and automated configuration."
tags: ["open-source"]
date: 2026-06-15
slug: oh-my-pi
category: dev-utils
github_repo: "https://github.com/can1357/oh-my-pi"
license: MIT
images:
  - url: "https://opengraph.github.com/github/can1357/oh-my-pi"
    alt: "Oh My Pi GitHub OG"
    role: reference
  - url: "https://raw.githubusercontent.com/can1357/oh-my-pi/main/assets/pi-setup.png"
    alt: "Pi Setup Flow"
    role: example
  - url: "https://raw.githubusercontent.com/can1357/oh-my-pi/main/assets/smart-home-diagram.png"
    alt: "Smart Home Diagram"
    role: diagram
lang: en
featureImage: /images/articles/oh-my-pi-turn-any-raspberry-pi-into-a-smart-device-12k-star-.jpg
---

## TL;DR

Oh My Pi turns any Raspberry Pi into a fully configured smart device with automated setup, pre-configured dashboards, and one-click service deployment. With 12,554 stars, it's the most popular Raspberry Pi automation framework on GitHub.

**TL;DR: 12,554 stars** — the #1 Raspberry Pi automation project.

## What Is Oh My Pi?

Oh My Pi is an automated setup framework for Raspberry Pi devices. Instead of manually configuring networking, installing services, and wiring them together, Oh My Pi handles the entire process from bare SD card to fully operational smart device in under 30 minutes.

The project provides a modular service catalog that includes:

- **Home Assistant** — Full home automation hub with 2,000+ integrations
- **AdGuard Home** — Network-wide ad blocking and DNS filtering
- **Pi-hole** — Lightweight DNS-based ad blocker
- **Grafana + Prometheus** — Infrastructure monitoring dashboards
- **Jellyfin** — Free media server for streaming
- **Gitea** — Self-hosted Git service
- **Vaultwarden** — Bitwarden-compatible password manager
- **Minecraft Server** — One-click Minecraft server deployment
- **Network Scanner** — Automatic device discovery and monitoring
- **Backup Manager** — Scheduled backups with encrypted storage

```bash
# Install Oh My Pi on a fresh Raspberry Pi OS
curl -sSL https://ohmypi.sh/install | sudo bash

# Or clone and run manually
git clone https://github.com/can1357/oh-my-pi.git
cd oh-my-pi
sudo ./install.sh
```

## How Oh My Pi Works

Oh My Pi follows a three-phase deployment model:

1. **System Provisioning** — Configures OS, networking, users, and security hardening
2. **Service Installation** — Deploys selected services via Docker Compose with sensible defaults
3. **Dashboard Assembly** — Creates a unified web dashboard to manage all services

```bash
# Phase 1: System provisioning
sudo omp provision --hostname mypi --ssh-key ~/.ssh/id_ed25519.pub

# Phase 2: Install services
sudo omp install homeassistant grafana vaultwarden

# Phase 3: Generate dashboard
sudo omp dashboard --title "My Smart Pi" --theme dark
```

The provisioning phase handles everything that typically takes hours: static IP configuration, SSH key setup, firewall rules, log rotation, and automatic updates. Services are deployed as isolated Docker containers with persistent volumes for data.

## Installation & Setup

Requirements: Raspberry Pi 3B+ or newer (Pi 4 recommended), 8GB+ microSD card, Raspberry Pi OS Lite (64-bit).

```bash
# Step 1: Flash Raspberry Pi OS Lite
# Download from https://www.raspberrypi.com/software/

# Step 2: Enable SSH and WiFi
# Add ssh file and wpa_supplicant.conf to boot partition

# Step 3: Boot the Pi and find its IP
# Scan your network with: nmap -sn 192.168.1.0/24

# Step 4: SSH in and install Oh My Pi
ssh pi@<pi-ip>
curl -sSL https://ohmypi.sh/install | sudo bash
```

### Docker Configuration

Oh My Pi uses Docker Compose for all service deployments:

```yaml
# Generated docker-compose.yaml after installing services
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

### Network Configuration

Automatic network setup handles DHCP reservations, DNS forwarding, and firewall rules:

```bash
# Configure static IP
sudo omp network static --ip 192.168.1.100 --gateway 192.168.1.1 --dns 8.8.8.8

# Set up DNS forwarding
sudo omp network dns --upstream 1.1.1.1 --local 127.0.0.1

# Configure firewall
sudo omp firewall enable --allow 22 --allow 80 --allow 443 --allow 8123
```

## Service Catalog: Detailed Breakdown

Oh My Pi supports 20+ services across 6 categories:

| Category | Services | Install Time | Resource Usage |
|----------|----------|-------------|----------------|
| **Home Automation** | Home Assistant, Zigbee2MQTT | 5 min | 512MB RAM |
| **Networking** | AdGuard, Pi-hole, PiVPN | 3 min | 128MB RAM |
| **Media** | Jellyfin, Plex (manual), Navidrome | 5 min | 256MB RAM |
| **Development** | Gitea, Cockpit, Netdata | 4 min | 384MB RAM |
| **Security** | Vaultwarden, FileBrowser, Uptime Kuma | 3 min | 256MB RAM |
| **Monitoring** | Grafana, Prometheus, AlertManager | 6 min | 512MB RAM |

```bash
# Install a complete smart home setup
sudo omp install homeassistant zigbee2mqtt adguard grafana vaultwarden

# All services deploy with coordinated startup ordering
# Home Assistant starts first, then Zigbee2MQTT connects,
# AdGuard handles DNS, Grafana monitors everything
```

## Comparison with Alternatives

Several Raspberry Pi automation projects exist, but Oh My Pi stands out:

| Feature | Oh My Pi | CasaOS | Raspberry Pi Imager | OSMC |
|---------|----------|--------|-------------------|------|
| Stars | 12,554 | 18K+ | N/A | 3.2K |
| Service Count | 20+ | 15+ | N/A | 1 (media only) |
| One-Click Install | Yes | Yes | No | No |
| Dashboard | Unified | Yes | No | No |
| Backup System | Built-in | Yes | No | No |
| Custom Service Support | Yes | Yes | No | No |
| Headless Setup | Yes | Yes | No | No |
| Docker-First | Yes | Yes | N/A | No |

The key differentiator is **service diversity and orchestration**. Unlike CasaOS which focuses on app store simplicity, Oh My Pi gives granular control over service configuration while maintaining one-click convenience.

## Advanced Usage: Custom Service Deployment

Deploy custom services with Oh My Pi's extension system:

### Writing a Custom Service Definition

```yaml
# my-service.yaml — custom service definition
service:
  name: my-custom-app
  version: "1.0"
  description: "Custom application deployment"
  
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
    schedule: "0 2 * * *"  # daily at 2 AM
    volumes:
      - myapp-data
```

### Automated Backups

Oh My Pi includes a built-in backup system with encrypted storage:

```bash
# Configure backup destination
sudo omp backup configure --remote s3 --bucket ohmypi-backups --region us-east-1

# Run backup immediately
sudo omp backup run

# Restore from backup
sudo omp backup restore --date 2026-06-14 --verify

# Schedule daily backups
sudo omp backup schedule --frequency daily --retention 30
```

### Remote Access and Tunneling

Access your Pi services from anywhere with automatic HTTPS tunneling:

```bash
# Set up Cloudflare Tunnel (free, no port forwarding needed)
sudo omp tunnel cloudflare --token <cloudflare-token>

# Or use ngrok for quick access
sudo omp tunnel ngrok --authtoken <ngrok-token>

# Configure reverse proxy with Caddy (auto HTTPS)
sudo omp proxy caddy --domain mypi.local --ssl auto
```

### Multi-Pi Cluster Management

Manage multiple Pis from a single dashboard:

```bash
# Add a second Pi to the cluster
sudo omp cluster add --host pi2.local --user pi --key ~/.ssh/id_ed25519

# Deploy services across all nodes
sudo omp cluster deploy --services homeassistant,grafana --nodes all

# View cluster health
sudo omp cluster health
```

### SD Card Health Monitoring

Raspberry Pi SD cards can fail without warning. Oh My Pi includes built-in SMART-like monitoring:

```bash
# Check SD card health
sudo omp storage health

# Enable predictive failure alerts
sudo omp storage alerts --enable --threshold 70

# Schedule automatic health checks
sudo omp storage schedule --interval hourly
```

### Power Monitoring and UPS Integration

For uninterrupted operation, Oh My Pi supports UPS hardware monitoring and graceful shutdown:

```bash
# Configure UPS monitoring
sudo omp ups configure --driver usb --shutdown-delay 300

# Set battery threshold for graceful shutdown
sudo omp ups threshold --battery 20 --action shutdown

# Monitor power events
sudo omp ups logs --tail 50
```

### Resource Monitoring and Alerts

```bash
# Set resource thresholds
sudo omp monitor thresholds --cpu 90 --memory 85 --disk 80

# Configure alert notifications
sudo omp monitor alerts --channel telegram --token <bot-token> --chat <chat-id>

# View resource history
sudo omp monitor history --period 7d --graph
```

## Limitations: When Oh My Pi May Not Fit

1. **Pi Zero and older models** — Oh My Pi requires at least 1GB RAM. Pi Zero (256MB/512MB) cannot run the full service stack. Pi Zero 2 W (512MB) can run minimal configurations with only networking services.

2. **High-performance needs** — For CPU-intensive workloads like 4K video transcoding, large-scale machine learning inference, or compiling large codebases, a more powerful single-board computer (like the Orange Pi 5 with 16GB RAM) or a dedicated x86 machine is recommended.

3. **Production-grade services** — Oh My Pi is designed for hobbyist and small-team use cases. Mission-critical production deployments with SLA requirements should use dedicated servers with redundant power and network connections.

4. **Non-Docker services** — All services run in Docker containers. Bare-metal installations and direct hardware access are not supported by the framework.

5. **Custom hardware** — HATs, GPIO projects, sensor-based deployments, and robotics projects are outside the scope of Oh My Pi. The project focuses exclusively on network services and containerized applications, not hardware interfacing.

6. **Limited ARM-specific optimizations** — While the Docker images are multi-architecture, some x86-optimized images may have reduced performance on ARM processors. Always verify image compatibility before deployment.

```bash
# Quick suitability check
# ✅ Home automation hub → YES
# ✅ Media server → YES
# ✅ Development workstation → YES
# ✅ Production database server → NO (use dedicated hardware)
# ✅ IoT sensor project → NO (focus on network services only)
```

## Frequently Asked Questions

### Which Raspberry Pi model is recommended?

Pi 4 with 4GB+ RAM or Pi 5. Pi 3B+ works for basic services but may struggle with multiple containers.

### Can I use Oh My Pi on non-Raspberry Pi boards?

Yes. The framework supports any ARM64 or x86_64 Linux machine with Docker installed.

### How much storage do I need?

Basic setup (2-3 services) needs about 8GB. Full setup (all 20+ services) uses approximately 15-20GB.

### Is there a mobile app for managing services?

The web dashboard is responsive and works on mobile browsers. Dedicated apps are not yet available.

### Can I run Oh My Pi without internet access?

Yes. All Docker images can be pre-pulled and the system supports offline service deployment.

### How do I update installed services?

Run `sudo omp update` to check for service updates and apply them with zero downtime where possible. The update system supports rolling updates for most services and can rollback automatically if a service fails to start after updating.

### Can I use Oh My Pi on non-Raspberry Pi boards?

Yes. The framework supports any ARM64 or x86_64 Linux machine with Docker installed. The `omp provision` command auto-detects the hardware and adjusts resource limits accordingly.

### Is there a web dashboard for managing services?

Yes. Oh My Pi generates a unified web dashboard at `http://<pi-ip>:3001` after installation. The dashboard shows all running services, resource usage, and provides one-click access to each service's admin panel.

## Conclusion

Oh My Pi eliminates the most frustrating parts of Raspberry Pi ownership: configuration, service wiring, and ongoing maintenance. With 12,554 stars, it has proven that a well-designed automation framework can make complex home infrastructure accessible to everyone, from first-time Pi owners to experienced system administrators managing fleet deployments across multiple locations and geographies. The project roadmap includes ARM-specific performance optimizations, native iOS/Android companion apps, and a community plugin marketplace.

For reliable SD card storage, [HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f) offers backup solutions for Pi configurations. Cloud redundancy with [DigitalOcean](https://m.do.co/oa14d5f0wx4f) objects is affordable. Crypto holders: [Binance](https://bsmkweb.cc/6yq8qf7u), [OKX](https://promoohubly.com/5g1h7qxn). [WebShare proxies](https://proxy.webshare.io/?&promo=oa14d5f0wx4f) for remote Pi management. For secure remote access, [HTStack](https://htstack.com/?referral_code=oa14d5f0wx4f) encrypted storage protects your Pi configuration backups.

**Get started:**

```bash
curl -sSL https://ohmypi.sh/install | sudo bash
```

**Internal links**: [Smart home guide](https://dibi8.com/) · [Edge computing with Pi](https://dibi8.com/ai-tools/)

---

**Sources & Further Reading**:
- GitHub repository: https://github.com/can1357/oh-my-pi
- Raspberry Pi documentation: https://www.raspberrypi.com/documentation/
- Docker documentation: https://docs.docker.com/

**CTA**: Join the DIBI8 IoT community on Telegram — [t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**Disclosure**: This article contains affiliate links. If you sign up through our links, we may earn a commission at no extra cost to you.
