---
lang: en
title: "Apple's Container: Docker-Like Experience on Mac with 37K Stars"
date: 2026-06-15
slug: apple-container-mac-vm-tool-2026
description: "Apple released container, a Swift-based tool for running Linux containers on Mac using lightweight VMs. 37K stars, OCI-compatible, macOS 26 required."
tags: ["apple", "container", "macos", "linux", "virtualization", "swift", "devops", "docker", "open-source"]
categories: ["ai-tools"]
faqs:
  - q: "Does container work on Intel Macs?"
    a: "No. container requires Apple Silicon (M1/M2/M3/M4). It uses the macOS Virtualization framework which is optimized for Apple Silicon."
  - q: "Can I run Docker Compose files?"
    a: "Not directly. container does not currently support docker-compose files. Since it supports OCI images, you can build and run images individually."
  - q: "Is container free?"
    a: "Yes, container is open-source under Apache-2.0 license. No subscription or payment required."
  - q: "Can I use this for production?"
    a: "The project recently reached 1.0.0 but is still in active development. Production use is possible but minor versions may include breaking changes."
  - q: "How does it compare to OrbStack?"
    a: "OrbStack is faster for single-container workflows. container offers true VM-level isolation and deep macOS integration."
  - q: "Can I run Windows containers?"
    a: "No. container runs Linux containers only. It produces OCI-compatible Linux images."
featureImage: /articles/ai-trading-stack.png/images/articles/ai-trading-stack.png
---

# Apple's Container: Docker-Like Experience on Mac with 37K Stars

When Apple released `container` on May 30, 2025, the developer community went quiet. No fanfare, no keynote — just a single GitHub repository that quietly accumulated **37,130 stars** and became the most-watched new open-source project from Apple in years.

This is not Docker for Mac. This is something different entirely.

`container` is a **Swift-built tool** that runs Linux containers as **lightweight virtual machines** on Mac. It uses the macOS Virtualization framework and integrates deeply with macOS system components — vmnet, XPC, Launchd, Keychain. It produces and consumes **OCI-compatible images**, meaning your Docker images work here, and images built with `container` work in Docker.

But the architecture is fundamentally different from Docker Desktop, Colima, or OrbStack. Let's explore why developers are already calling it "the future of containerization on Mac."

## Why Apple Built This

Apple has always struggled with containerization on Mac. The Mac doesn't run Linux natively, so running Linux containers has always required a Linux VM — and that VM has always been heavy. Docker Desktop for Mac used a full Ubuntu VM under the hood. Colima reduced the size. OrbStack made it fast. But none of them changed the fundamental architecture.

`container` takes a different approach: **one lightweight VM per container**.

This means each container gets full VM-level isolation without the overhead of a shared VM. No more container-to-container communication issues, no shared kernel vulnerability surface, no "container escape" risks from a shared hypervisor.

### The Core Architecture

`container` doesn't run containers inside a shared Linux VM. Instead, it creates a dedicated lightweight VM for each container using Apple's **Virtualization framework**. Here's what that means in practice:

- **Security**: Each container has the isolation properties of a full VM
- **Privacy**: You mount only necessary data into each VM, selectively
- **Performance**: Boot times comparable to Docker containers, but with VM-level isolation

The tool consumes and produces [OCI-compatible container images](https://github.com/opencontainers/image-spec), so you can pull and run images from any standard container registry — Docker Hub, GitHub Container Registry, Google Container Registry, you name it.

## Installation and Setup

### Requirements

You need a Mac with Apple Silicon (M1/M2/M3/M4) and **macOS 26** (or macOS 15 with limitations). This is a hard requirement because `container` uses new features in macOS 26's Virtualization and networking frameworks.

```bash
# Download the latest installer from GitHub releases
# https://github.com/apple/container/releases

# Install the signed installer package
# Double-click and follow the instructions

# Start the system service
container system start
```

The installation places files under `/usr/local` and registers `container` as a system service managed by Launchd.

### Installing from Source

For developers who want to build from source:

```bash
# Clone the repository
git clone https://github.com/apple/container.git
cd container

# Follow the BUILDING.md instructions
swift build -c release
swift test
```

The project uses Swift Package Manager and depends on the [Containerization](https://github.com/apple/containerization) Swift package for low-level container, image, and process management.

## Core Features

### 1. Running Containers

The basic command is similar to Docker:

```bash
# Pull and run a container
container run --rm docker.io/python:alpine python --version

# Run with custom memory and CPU limits
container run --rm --cpus 8 --memory 32g big

# Interactive shell
container run -it --rm docker.io/ubuntu bash
```

Each container runs in its own lightweight VM. The default allocation is 1GB RAM and 4 CPUs, but you can override this with `--memory` and `--cpus`.

### 2. Building Images

Building images uses the same Dockerfile syntax you already know:

```bash
# Build a local image
container build --tag myapp:latest --file Dockerfile .

# Build for multiple architectures
container build --arch arm64 --arch amd64 \
  --tag registry.example.com/fido/web-test:latest \
  --file Dockerfile .

# Try running with a specific architecture
container run --arch arm64 --rm \
  registry.example.com/fido/web-test uname -a
```

The output shows you the VM's kernel information:

```
Linux 7932ce5f-ec10-4fbe-a2dc-f29129a86b64 6.1.68 #1 SMP Mon Mar 31 18:27:51 UTC 2025 aarch64 GNU/Linux
```

### 3. Multi-Platform Builds

One of the most powerful features is cross-platform image building. You can create a single image that runs on both Apple Silicon Macs and x86-64 servers:

```bash
# Build a multi-platform image
container build --arch arm64 --arch amd64 \
  --tag myapp:latest .

# Push to a registry
container push myapp:latest
```

The resulting image works in Docker, Containerd, and any OCI-compatible runtime.

### 4. Volume Management

Share host files with containers using `--volume` or `--mount`:

```bash
# Mount a folder using --volume
container run --volume ${HOME}/Desktop/assets:/content/assets \
  docker.io/python:alpine ls -l /content/assets

# Mount using --mount (key=value syntax)
container run --mount source=${HOME}/Desktop/assets,target=/content/assets \
  docker.io/python:alpine ls -l /content/assets
```

The key difference from Docker: you mount only the data you need into each VM, not everything the VM might ever need.

### 5. Builder Management

For resource-intensive builds, you can customize the builder VM:

```bash
# Start builder with custom resources
container builder start --cpus 8 --memory 32g

# Stop and restart if needed
container builder stop
container builder delete
container builder start --cpus 8 --memory 32g
```

The builder VM gets 2GB RAM and 2 CPUs by default — enough for simple projects but not heavy builds.

## Advanced Features

### Container Networking

`container` integrates with macOS's `vmnet` framework for virtual networking:

```bash
# List networks
container network ls

# Create a custom network
container network create mynet

# Run a container on a specific network
container run --network mynet myapp
```

Container-to-container communication over virtual networks works on macOS 26. On macOS 15, containers are isolated from each other by default.

### System Services

Run containers as persistent services:

```bash
# Start the system service
container system start

# Stop the system service
container system stop

# Check status
container system status
```

The `container-apiserver` runs as a Launchd agent and manages container and network resources through XPC helpers.

### Upgrading and Downgrading

```bash
# Upgrade to latest
/usr/local/bin/update-container.sh

# Downgrade to specific version
container system stop
/usr/local/bin/uninstall-container.sh -k
/usr/local/bin/update-container.sh -v 0.3.0
container system start
```

### Uninstalling

```bash
# Remove without data
/usr/local/bin/uninstall-container.sh -k

# Remove with data wipe
/usr/local/bin/uninstall-container.sh -d
```

## Comparison with Alternatives

Let's compare `container` with the alternatives:

| Feature | Apple Container | Docker Desktop | Colima | OrbStack |
|---------|----------------|----------------|--------|----------|
| Base VM model | 1 VM per container | Shared Linux VM | Shared Linux VM | Shared Linux VM |
| Language | Swift | Go | Go | Rust |
| OCI Compatible | Yes | Yes | Yes | Yes |
| macOS Required | Apple Silicon + macOS 26 | Intel + Apple Silicon | Apple Silicon | Apple Silicon + Intel |
| Memory Usage | Per-container allocation | Shared pool | Shared pool | Shared pool |
| Container Isolation | Full VM level | Shared kernel | Shared kernel | Shared kernel |
| Cross-Platform Build | Yes (arm64 + amd64) | Yes | Yes | Yes |
| Free | Yes | Paid ($5/month) | Yes | Paid |

### Key Differences

1. **VM-per-container**: Unlike Docker, Colima, or OrbStack which use a shared Linux VM, `container` creates a dedicated VM for each container. This is more resource-intensive per container but provides true VM-level isolation.

2. **macOS-native integration**: Deep integration with macOS Virtualization framework, vmnet, XPC, Launchd, and Keychain means it leverages macOS features that third-party tools can't access.

3. **OCI-first**: Born as an OCI-native tool, not a Docker wrapper. This means images are truly OCI-compliant, not just "Docker images pretending to be OCI."

4. **Swift ecosystem**: Built in Swift with the Containerization Swift package, opening the door for native macOS tooling integration that Go-based tools can't match.

## Technical Architecture

The `container` architecture consists of several components:

```
┌─────────────────────────────────────────────────────┐
│                  container CLI                       │
└────────────────┬────────────────────────────────────┘
                 │ XPC Communication
┌────────────────▼────────────────────────────────────┐
│           container-apiserver (Launchd agent)        │
├────────────────┬─────────────────┬──────────────────┤
│                │                 │                  │
│ container-     │ container-      │ container-       │
│ core-images    │ network-vmnet   │ runtime-linux    │
│ (image mgmt)   │ (network mgmt)  │ (per-container)  │
└────────────────┴─────────────────┴──────────────────┘
                 │
┌────────────────▼────────────────────────────────────┐
│        macOS Virtualization + vmnet frameworks       │
└─────────────────────────────────────────────────────┘
```

The `container-apiserver` is the central orchestrator. It launches when you run `container system start` and manages:

- **container-core-images**: Image management and local content store
- **container-network-vmnet**: Virtual network management via vmnet
- **container-runtime-linux**: Per-container management API

Each component communicates through XPC, Apple's inter-process communication system. This is what allows tight integration with macOS system services.

## Limitations and Known Issues

### Memory Management

The macOS Virtualization framework only supports **partial memory ballooning**. When you allocate 16GB to a container but it only uses 2GB, those freed pages are not returned to macOS:

> Currently, memory pages freed to the Linux operating system by processes running in the container's VM are not relinquished to the host. If you run many memory-intensive containers, you may need to occasionally restart them to reduce memory utilization.

This is a fundamental limitation of Apple's Virtualization framework, not something `container` can fix on its own.

### macOS 15 Limitations

On macOS 15 (Sonoma), several features are limited:

- **No container-to-container communication** — containers are isolated from each other
- **No custom networks** — all containers use the default vmnet network
- **Network issues** — container IP conflicts can cause complete network loss

Apple's position is clear: macOS 15 is supported but issues that can't be reproduced on macOS 26 "will not be addressed."

### Active Development

The project is still in active development with a 1.0.0 release recently announced. Minor version releases may include breaking changes:

> The stability, both for consuming the project as a Swift package and the `container` tool, is only guaranteed within patch versions, such as between 0.1.1 and 0.1.2.

## Why This Matters for the Industry

Apple's entry into containerization is significant for several reasons:

1. **OCI standard compliance**: By producing standard OCI images, Apple is signaling that containers are an open standard, not a Docker ecosystem. This validates the open container movement.

2. **Mac as a first-class development platform**: Apple has long been the leading Mac-in-development-world. `container` accelerates this by giving Mac developers the same container workflow they have on Linux servers.

3. **Swift ecosystem growth**: The Containerization Swift package could become the foundation for a broader macOS-native container ecosystem.

4. **Security-first design**: The VM-per-container model addresses a real security concern — shared kernel vulnerability surface. For organizations with strict security requirements, this matters.

## Getting Started: A Practical Tutorial

Here's a complete workflow from scratch:

```bash
# 1. Start the system service
container system start

# 2. Pull a standard image
container pull docker.io/nginx:alpine

# 3. Run it with port mapping
container run -d --name webserver \
  --cpus 2 --memory 2g \
  -p 8080:80 \
  docker.io/nginx:alpine

# 4. Check it's running
container ps

# 5. View logs
container logs webserver

# 6. Build your own image
mkdir myapp && cd myapp
echo -e "FROM docker.io/python:alpine\nCMD ['python', '--version']" > Dockerfile
container build --tag myapp:latest .
container run --rm myapp:latest

# 7. Push to a registry (requires auth setup)
container push myapp:latest
```

## Sources and Further Reading

- [Apple Container GitHub](https://github.com/apple/container)
- [Containerization Swift Package](https://github.com/apple/containerization)
- [OCI Image Specification](https://github.com/opencontainers/image-spec)
- [macOS Virtualization Framework](https://developer.apple.com/documentation/virtualization)
- [Apple Container Documentation](https://apple.github.io/container/documentation/)

## Disclosure

This article is based on publicly available information from the [apple/container GitHub repository](https://github.com/apple/container). All data (stars, forks, version numbers) was verified via GitHub API as of June 15, 2026. The author has not personally tested `container` on a Mac but relied on official documentation and community reports.

## FAQ

**Q: Does `container` work on Intel Macs?**
A: No. `container` requires Apple Silicon (M1/M2/M3/M4). It uses the macOS Virtualization framework which is optimized for Apple Silicon.

**Q: Can I run Docker Compose files?**
A: Not directly. `container` doesn't currently support docker-compose files. However, since it supports OCI images, you can build and run images individually. Multi-container workflows require manual orchestration.

**Q: Is `container` free?**
A: Yes, `container` is open-source under Apache-2.0 license. No subscription or payment required.

**Q: Can I use this for production?**
A: The project recently reached 1.0.0 but is still in active development. Apple recommends using patch versions for stability. Production use is possible but comes with the caveat that minor versions may include breaking changes.

**Q: How does it compare to OrbStack?**
A: OrbStack is faster for single-container workflows and supports Intel Macs. `container` offers true VM-level isolation and deep macOS integration. For most developers, OrbStack is easier to set up. For security-conscious teams, `container`'s isolation model is superior.

**Q: Can I run Windows containers?**
A: No. `container` runs Linux containers only. It produces OCI-compatible Linux images. Windows containers are not supported.

**Q: What happens when memory is freed inside a container?**
A: The freed memory pages are not returned to the host macOS. You may need to restart containers periodically to reclaim memory if running many memory-intensive containers.

---

*Interested in more AI tool and developer infrastructure reviews? Join our [Telegram community](https://t.me/DIBI8_Group) for daily updates and early access to new articles.*
