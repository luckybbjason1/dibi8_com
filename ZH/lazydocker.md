---
title: 'LazyDocker: 51,092 GitHub Stars — 完整终端 Docker UI 设置指南 2026'
description: 'LazyDocker (LD) 是一个用于管理 Docker 容器、镜像、卷和日志的终端 UI。兼容 Docker、Docker Compose、Go 和 Terminal。涵盖安装、快捷键、配置和生产环境加固。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/jesseduffield/lazydocker'
stars: 51092
maintainer: 'jesseduffield'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['lazydocker', 'docker', '终端界面', 'devops', '容器', '命令行工具', 'docker-compose', 'tui']
aliases:
- /zh/posts/lazydocker/
---

{{</* resource-info */>}}

从命令行管理 Docker 意味着需要记住几十个参数、通过 `grep` 过滤输出，并且不断在 `docker ps`、`docker logs` 和 `docker exec` 之间切换。对于在终端中花费数小时的开发者来说，这种摩擦会累积。LazyDocker 通过一个二进制文件解决了这个问题，它将你的 Docker 工作流包装到一个键盘驱动的终端界面中 —— 无需浏览器、无需守护进程、无需设置开销。凭借超过 51,000 个 GitHub stars 和蓬勃发展的生态系统，它已成为 2026 年 Docker 管理的首选 TUI 工具。

![LazyDocker Banner](https://raw.githubusercontent.com/jesseduffield/lazydocker/master/docs/resources/split_assets/banner.png)

## 什么是 LazyDocker？

LazyDocker 是一个用于 Docker 和 Docker Compose 的终端用户界面（TUI），使用 Go 语言编写，基于 `gocui` 框架。它提供了一个可通过键盘导航的界面，用于查看容器、镜像、卷、网络和日志 —— 全部在终端内的分栏布局中。单个二进制文件通过 Docker CLI 使用的相同 API 直接连接到 Docker 守护进程。没有后台服务，没有开放端口，没有额外的攻击面。

LazyDocker 由 Jesse Duffield 创建（也是 LazyGit 的作者），面向那些希望在不离开终端的情况下获得即时视觉反馈的开发者。它采用 MIT 许可证，积极维护，在 GitHub 上已积累 51,092 个 stars 和 1,600+ 个 forks。

## LazyDocker 的工作原理

LazyDocker 遵循简单的架构：二进制文件通过本地 Unix socket（`/var/run/docker.sock`）或 Windows 上的命名管道读取和写入 Docker Engine API。所有渲染都通过基于字符的 UI 框架在终端内完成。

```
┌─────────────────────────────────────────┐
│              终端                       │
│  ┌──────────────────────────────────┐   │
│  │        LazyDocker TUI            │   │
│  │  ┌────────┐  ┌────────────────┐  │   │
│  │  │容器     │  │  日志 / 统计   │  │   │
│  │  ├────────┤  │                │  │   │
│  │  │镜像     │  │  实时          │  │   │
│  │  ├────────┤  │  Docker API    │  │   │
│  │  │卷       │  │  输出          │  │   │
│  │  ├────────┤  │                │  │   │
│  │  │网络     │  │                │  │   │
│  │  └────────┘  └────────────────┘  │   │
│  └──────────────────────────────────┘   │
│                   │                      │
│         ┌─────────▼──────────┐           │
│         │ /var/run/docker.sock│           │
│         └─────────┬──────────┘           │
│                   │                      │
│         ┌─────────▼──────────┐           │
│         │   Docker 守护进程  │           │
│         └────────────────────┘           │
└─────────────────────────────────────────┘
```

你需要了解的核心概念：

- **面板（Panels）**：左侧显示分类列表（容器、服务、镜像、卷、网络）。右侧显示所选项目的详细信息、日志或统计信息。
- **上下文感知操作**：同一个按键根据聚焦的面板执行不同的操作。在容器上按 `d` 会移除容器；在镜像上按 `d` 会移除镜像。
- **Docker Compose 集成**：当在有 `docker-compose.yml` 文件的目录中启动时，LazyDocker 按项目对服务进行分组，并添加 Compose 专用操作，如 `up` 和 `down`。

## 安装与设置

LazyDocker 可以在任何平台上在 60 秒内完成安装。你需要安装 Docker 并将你的用户添加到 `docker` 组（或具有对 Docker socket 的等效访问权限）。

### 前置要求

```bash
# 验证 Docker 已安装并正在运行
docker --version
docker ps

# 将你的用户添加到 docker 组（Linux）
sudo usermod -aG docker $USER
# 注销并重新登录以使组更改生效
```

### 方法 1：Homebrew（macOS 和 Linux）

```bash
# 使用官方 formula 获取频繁更新
brew install jesseduffield/lazydocker/lazydocker

# 验证安装
lazydocker --version
# 输出：Version: v0.24.5, Build date: 2026-04-15, Commit: abc1234
```

### 方法 2：官方安装脚本（Linux）

```bash
# 自动安装到 ~/.local/bin
curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash

# 如果需要，添加到 PATH
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.bashrc
source ~/.bashrc
```

### 方法 3：二进制下载（全平台）

```bash
# 获取最新版本号
LAZYDOCKER_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazydocker/releases/latest" | grep '"tag_name":' | sed 's/.*"v\([^"]*\)".*/\1/')

# 下载 Linux x86_64 二进制文件
curl -Lo lazydocker.tar.gz "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_x86_64.tar.gz"

# 解压并系统级安装
tar xf lazydocker.tar.gz lazydocker
sudo install lazydocker /usr/local/bin/
rm lazydocker lazydocker.tar.gz
```

### 方法 4：Go 安装

```bash
# 需要 Go >= 1.19
go install github.com/jesseduffield/lazydocker@latest

# 二进制文件位于 ~/go/bin
export PATH=$PATH:$HOME/go/bin
```

### 方法 5：Docker（沙箱模式）

```bash
# 无需安装即可运行 —— 挂载 Docker socket 获取完整访问权限
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock \
  -v ~/.config/lazydocker:/.config/jesseduffield/lazydocker \
  lazyteam/lazydocker:latest

# 创建 shell 别名以便使用
echo "alias lzd='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock -v ~/.config/lazydocker:/.config/jesseduffield/lazydocker lazyteam/lazydocker'" >> ~/.bashrc
```

### 首次启动

```bash
# 启动 LazyDocker
lazydocker

# 使用调试输出启动以进行故障排除
lazydocker --debug
```

首次启动时，LazyDocker 会自动检测正在运行的容器并显示主界面。布局分为左侧导航面板和右侧内容面板，显示所选项目的日志或统计信息。

![LazyDocker 界面演示](https://raw.githubusercontent.com/jesseduffield/lazydocker/master/assets/demo.gif)

![LazyDocker 截图](https://raw.githubusercontent.com/jesseduffield/lazydocker/master/docs/resources/split_assets/screenshot.png)

## 基本快捷键

LazyDocker 的效率来自其类似 vim 的快捷键。导航使用方向键或 `hjkl`，操作是单键触发。

### 全局导航

| 按键 | 操作 |
|------|------|
| `Tab` / `Shift+Tab` | 在左侧面板之间循环 |
| `↑` `↓` / `k` `j` | 在面板中导航项目 |
| `Enter` | 聚焦主面板 / 选择 |
| `Escape` / `q` | 返回 / 退出 |
| `[` / `]` | 上一个 / 下一个标签页 |
| `?` | 显示帮助覆盖层 |
| `/` | 过滤当前列表 |

### 容器操作

| 按键 | 操作 |
|------|------|
| `r` | 重启容器 |
| `s` | 停止容器 |
| `d` | 移除容器（带确认） |
| `p` | 暂停 / 恢复容器 |
| `e` | 隐藏/显示已停止的容器 |
| `E` | 进入容器（打开 shell） |
| `a` | 附加到容器 |
| `m` | 查看日志 |
| `u` | 查看 CPU/内存统计 |
| `w` | 在浏览器中打开暴露的端口 |
| `b` | 查看批量命令 |
| `c` | 运行自定义预定义命令 |

### Docker Compose 服务操作

| 按键 | 操作 |
|------|------|
| `u` | 启动服务 |
| `U` | 启动整个项目 |
| `d` | 移除服务容器 |
| `D` | 关闭整个项目 |
| `s` | 停止服务 |
| `S` | 启动服务 |
| `r` | 重启服务 |
| `R` | 查看重启选项 |
| `E` | 在服务容器中执行 shell |

### 镜像和卷操作

| 按键 | 操作（镜像） | 操作（卷） |
|------|-------------|-----------|
| `d` | 移除镜像 | 移除卷 |
| `p` | 拉取最新镜像 | — |
| `Enter` | 检查镜像详情 | 检查卷 |

### 日志导航

| 按键 | 操作 |
|------|------|
| `PageUp` / `PageDown` | 滚动日志 |
| `g` | 跳到日志开头 |
| `G` | 跳到日志末尾 |
| `/` | 在日志中搜索 |
| `n` | 下一个搜索结果 |
| `[` / `]` | 上一页 / 下一页日志 |

## 配置与自定义

LazyDocker 将配置存储在平台特定的路径中。在项目面板中按 `o`（或按 `e` 在默认编辑器中编辑）可直接从 TUI 打开配置文件。

### 配置文件位置

| 操作系统 | 路径 |
|---------|------|
| Linux | `~/.config/lazydocker/config.yml` |
| macOS | `~/Library/Application Support/jesseduffield/lazydocker/config.yml` |
| Windows | `C:\Users\<User>\AppData\Roaming\lazydocker\config.yml` |

### 自定义主题配置

```yaml
# ~/.config/lazydocker/config.yml
gui:
  language: "zh"  # auto | en | fr | de | es | pl | nl | tr | zh
  border: "rounded"  # rounded | single | double | hidden
  theme:
    activeBorderColor:
      - cyan
      - bold
    inactiveBorderColor:
      - white
    selectedLineBgColor:
      - black
    selectedLineFgColor:
      - yellow
    optionsTextColor:
      - blue
  scrollHeight: 2
  sidePanelWidth: 0.333
  screenMode: "normal"  # normal | half | fullscreen
```

### 日志显示设置

```yaml
logs:
  timestamps: true
  since: "60m"    # 显示最近 60 分钟的日志；'' = 全部时间
  tail: "200"     # 显示的行数
```

### 自定义命令

添加通过 `c` 键访问的自定义命令：

```yaml
customCommands:
  containers:
    - name: bash
      attach: true
      command: "docker exec -it {{ .Container.ID }} bash"
      serviceNames: []
    - name: debug-network
      attach: false
      command: "docker inspect {{ .Container.ID }} --format='{{range $k, $v := .NetworkSettings.Networks}}{{$k}}: {{.IPAddress}}\n{{end}}'"
```

可用的模板变量：`{{ .Container.ID }}`、`{{ .Container.Name }}`、`{{ .Service.Name }}`、`{{ .DockerCompose }}`。

### Podman 支持

通过交换命令模板，LazyDocker 可与 Podman 配合使用：

```yaml
commandTemplates:
  docker: "podman"
  dockerCompose: "podman-compose"
  containerInspect: "podman inspect {{ .Container.ID }}"
```

## 与流行工具集成

### Docker Compose 项目

LazyDocker 自动检测当前目录中的 `docker-compose.yml` 或 `compose.yml`。服务在服务面板中按项目分组显示，并带有项目级操作。这种集成对于本地微服务开发特别有价值，因为它消除了记住每个项目的 Compose 命令的需要。

```bash
# 导航到你的 Compose 项目
cd ~/projects/my-app

# 启动 —— 服务面板自动填充
lazydocker
```

在服务面板中：
- 按 `u` 启动单个服务
- 按 `U` 启动整个项目
- 按 `D` 拆除整个堆栈
- 按 `E` 进入服务容器
- 按 `R` 查看重启选项（包括重启计数和策略）
- 按 `w` 在浏览器中打开服务暴露的第一个端口

对于具有多个 Compose 文件的复杂项目，你可以在启动前设置 `COMPOSE_FILE` 环境变量：

```bash
# 使用多个 Compose 文件
export COMPOSE_FILE=docker-compose.yml:docker-compose.override.yml:docker-compose.prod.yml
lazydocker
```

### Tmux 集成

对于 tmux 用户，添加按键绑定以在弹出窗口或分割中启动 LazyDocker：

```bash
# ~/.tmux.conf
# 在弹出窗口中打开 LazyDocker
bind D display-popup -E -w 90% -h 90% "lazydocker"

# 或在新垂直分割中打开
bind d split-window -h "lazydocker"
```

重新加载并使用 `Ctrl+b D` 打开：

```bash
tmux source-file ~/.tmux.conf
```

### Zsh / Bash 别名

```bash
# ~/.bashrc 或 ~/.zshrc
alias lzd="lazydocker"
alias lzd-logs="lazydocker --logs"

# 快速跳转到项目并启动
alias lzd-here="cd $PWD && lazydocker"

# 重新加载 shell 配置
source ~/.bashrc
```

### VS Code 集成

添加 VS Code 任务以在集成终端中启动 LazyDocker：

```json
// .vscode/tasks.json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "LazyDocker",
      "type": "shell",
      "command": "lazydocker",
      "problemMatcher": [],
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": true,
        "panel": "new"
      }
    }
  ]
}
```

### CI/CD 流水线集成

LazyDocker 在 GitHub Actions 中表现良好，用于调试构建期间的容器状态。虽然 LazyDocker 的 TUI 在 CI 环境中不是交互式的，但其底层命令可以与 Docker API 通信以提取结构化的容器信息。

```yaml
# .github/workflows/debug.yml
name: Debug Containers
on: workflow_dispatch
jobs:
  debug:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Install LazyDocker
        run: |
          curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
          sudo mv ~/.local/bin/lazydocker /usr/local/bin/

      - name: Start services
        run: docker compose up -d

      - name: Inspect with LazyDocker
        run: |
          lazydocker --version
          # 导出容器列表用于日志
          docker ps --format "table {{.Names}}\t{{.Status}}"

      - name: Capture container logs on failure
        if: failure()
        run: |
          docker compose logs --tail=500 > container-logs.txt
          docker stats --no-stream > container-stats.txt
```

### SSH 环境下的远程服务器管理

LazyDocker 在仅 SSH 访问的无头服务器上表现出色。与需要开放端口和运行 Web 服务的 Portainer 不同，LazyDocker 通过 SSH 隧道提供完整的 Docker 管理功能，不会在服务器上留下任何运行中的进程。

```bash
# 通过 SSH 在远程服务器上启动 LazyDocker
ssh -t user@remote-server "lazydocker"

# 或者使用本地转发的 socket
ssh -nNT -L /tmp/docker.sock:/var/run/docker.sock user@remote-server &
DOCKER_HOST=unix:///tmp/docker.sock lazydocker
```

## 基准测试与真实用例

LazyDocker 的设计理念是零开销：它是一个客户端工具，运行时不驻留内存，退出后立即释放所有资源。这一点与需要长期运行后台服务的其他 Docker 管理工具有本质区别。

### 资源开销对比

LazyDocker 几乎没有资源开销，因为它作为临时客户端进程运行 —— 而不是持久守护进程。

| 场景 | 二进制大小 | 运行时内存 | 启动时间 | 后台进程 |
|------|----------|-----------|---------|---------|
| LazyDocker | ~15 MB | ~20 MB | <200 ms | 无 |
| Docker Desktop | ~1.5 GB | ~400-800 MB | 10-30 s | 是（虚拟机） |
| Portainer CE | ~80 MB 镜像 | ~100-200 MB | 5-10 s | 是（容器） |
| Rancher | ~300 MB 镜像 | ~500 MB+ | 30-60 s | 是（集群） |

### 真实场景

**场景 1：家庭实验室服务器（20 个容器）**
开发者在无头 Ubuntu 服务器上管理媒体堆栈（Plex、Sonarr、Radarr、Traefik、Authelia）。LazyDocker 通过 SSH 提供即时容器状态、实时日志跟踪和快速重启，无需运行 Web 服务。资源占用：不运行时为零。这种模式特别适合树莓派或旧硬件等低功耗设备。

**场景 2：微服务开发（8 个服务）**
团队本地运行 8 个 Docker Compose 服务。LazyDocker 按项目对服务进行分组，显示哪些容器正在重启，并让开发者通过单次按键进入故障服务。平均调试工作流从 45 秒的 CLI 输入减少到 5 秒的键盘导航。对于频繁重启和调试服务的开发者来说，这种效率提升在一天内可以节省大量时间。

**场景 3：CI/CD 调试**
DevOps 工程师在 GitHub Actions 中使用 LazyDocker 捕获失败测试运行结束时的容器状态和日志。CI 中的 TUI 不是交互式的，但 `--logs` 导出和容器列表命令提供结构化的调试输出。

## 高级用法与生产环境加固

### 通过 SSH 在远程主机上运行

LazyDocker 原生不支持远程 Docker 主机，但你可以通过 SSH 转发 Docker socket：

```bash
# 将远程 Docker socket 转发到本地机器
ssh -nNT -L /tmp/docker_remote.sock:/var/run/docker.sock user@remote-server &

# 让 LazyDocker 指向转发的 socket
export DOCKER_HOST=unix:///tmp/docker_remote.sock
lazydocker

# 完成后清理
kill %1
rm /tmp/docker_remote.sock
```

或者直接使用 SSH context：

```bash
# 为远程主机创建 Docker context
docker context create remote --docker "host=ssh://user@remote-server"
docker context use remote

# LazyDocker 自动使用活动 context
lazydocker
```

### 非 Root 用户设置

```bash
# 如果 docker 组不存在则创建
sudo groupadd -f docker

# 添加当前用户
sudo usermod -aG docker $USER

# 不注销即可应用（仅 Linux）
newgrp docker

# 验证
lazydocker
```

### 批量操作技巧

LazyDocker 的批量命令（按 `b` 键）允许你对多个容器或镜像同时执行操作。这在需要清理过期资源时特别有用：

```bash
# 在 LazyDocker 中选择一个面板后按 b 键
# 可用的批量操作包括：
# - 删除所有已停止的容器
# - 删除所有悬空镜像
# - 删除所有未使用的卷
# - 重启所有服务
```

### 自动化清理工作流

```bash
#!/bin/bash
# ~/bin/docker-cleanup.sh
# 与 LazyDocker 集成的一键清理脚本

echo "移除已停止的容器..."
docker container prune -f

echo "移除悬空镜像..."
docker image prune -f

echo "移除未使用的卷..."
docker volume prune -f

echo "移除未使用的网络..."
docker network prune -f

echo "清理完成。剩余资源："
docker system df
```

通过 LazyDocker 中的自定义命令绑定此脚本，实现一键访问。

### 监控集成

通过将 `docker stats` 管道传输到 Prometheus Node Exporter textfile 收集器，将 LazyDocker 统计信息导出到外部监控：

```bash
#!/bin/bash
# 每 60 秒的 cron 任务
while true; do
  docker stats --no-stream --format \
    "container_cpu_usage{name=\"{{.Name}}\"} {{.CPUPerc}}\ncontainer_memory_usage{name=\"{{.Name}}\"} {{.MemUsage}}" \
    > /var/lib/node_exporter/textfile_collector/docker_stats.prom
  sleep 60
done
```

## 与替代品对比

| 功能 | LazyDocker | Docker Desktop | Portainer CE | Rancher |
|------|-----------|----------------|--------------|---------|
| 界面 | 终端 TUI | 原生桌面 GUI | Web GUI | Web GUI |
| 安装大小 | ~15 MB | ~1.5 GB | ~80 MB 镜像 | ~300 MB 镜像 |
| 内存开销 | ~20 MB（临时） | ~400-800 MB | ~100-200 MB | ~500 MB+ |
| 多主机 | 否（SSH 变通方案） | 有限 | 是（agents） | 是（集群） |
| Kubernetes | 否 | 是（本地） | 是 | 是（主要） |
| Docker Compose | 完整支持 | 完整支持 | 基于 Stack | 有限 |
| 多用户 / RBAC | 否 | 否 | 是（BE 版） | 是 |
| 通过 SSH 工作 | 是 | 否 | 通过浏览器 | 通过浏览器 |
| 离线可用 | 是 | 是（本地） | UI 需要网络 | 需要网络 |
| 开源协议 | MIT | 专有 | AGPL / SSPL | Apache-2.0 |
| 启动时间 | <200 ms | 10-30 s | 5-10 s | 30-60 s |
| 最适合 | 终端用户 | 本地开发 | 团队管理 | 企业 K8s |

## 局限性 / 诚实评估

LazyDocker 并不适合所有情况。以下是限制条件：

- **无多主机管理**：你无法从单个 LazyDocker 实例管理多个 Docker 主机。对此，请使用带有 agents 的 Portainer 或 Rancher。
- **无 Web 界面**：LazyDocker 需要终端访问。如果你需要通过手机或平板管理容器，Portainer 的响应式 Web UI 是更好的选择。
- **无 RBAC 或用户管理**：LazyDocker 继承你的 OS 用户的 Docker 权限。没有团队、角色或审计追踪的概念。
- **不支持 Kubernetes**：LazyDocker 仅处理 Docker 和 Docker Compose。对于 Kubernetes 工作负载，请直接使用 `k9s`、Rancher 或 `kubectl`。
- **仅单用户**：两个工程师不能同时使用同一个 LazyDocker 会话。每个用户运行自己的实例。
- **TUI 学习曲线**：不熟悉键盘驱动界面（vim、tmux）的工程师可能会发现初始学习曲线比点击 Web UI 更陡峭。
- **偏读取，谨慎写入**：虽然 LazyDocker 支持破坏性操作（移除、停止），但它会添加确认提示，与脚本化的 CLI 工作流相比，这些提示会降低批量操作的速度。

## 常见问题

**Q: LazyDocker 会替代 Docker CLI 吗？**

不会。LazyDocker 通过提供视觉概览和快速操作来补充 CLI。对于脚本编写、自动化和 CI/CD 流水线，Docker CLI 仍然是正确的工具。许多开发者两者都用：LazyDocker 用于交互式探索，`docker` 命令用于可重现的工作流。

**Q: 我可以将 LazyDocker 与 Podman 一起使用吗？**

可以。通过配置覆盖，LazyDocker 支持 Podman。在 `config.yml` 中将 `commandTemplates.docker` 设置为 `podman`，将 `commandTemplates.dockerCompose` 设置为 `podman-compose`。一个名为 `lazypodman` 的社区包装器也可用于无缝的 Podman 集成。

**Q: 如何查看已崩溃容器的日志？**

导航到容器面板，按 `e` 切换已停止容器的可见性，选择已崩溃的容器，然后按 `m` 查看其日志。使用 `g` 跳到日志流的开头，`G` 跳到末尾。

**Q: 在生产环境中使用 LazyDocker 安全吗？**

LazyDocker 是安全的，因为它是一个没有后台服务的客户端工具。它使用你的用户具有的权限连接到 Docker socket。在生产环境中，限制 Docker socket 访问给授权用户，除非必要避免在生产主机上运行 LazyDocker，并优先选择只读操作（查看日志和统计信息）而非破坏性操作。

**Q: 我可以在 Docker 容器内运行 LazyDocker 吗？**

可以。将主机的 Docker socket 挂载到容器中，使用 `-v /var/run/docker.sock:/var/run/docker.sock`。这使 LazyDocker 可以完全查看主机容器。官方镜像是 `lazyteam/lazydocker:latest`。这种模式在隔离环境或快速测试中效果很好。

**Q: 为什么 LazyDocker 显示 "Cannot connect to Docker daemon"？**

当你的用户无法访问 `/var/run/docker.sock` 时会发生此错误。确保你的用户在 `docker` 组中，Docker 守护进程正在运行（`sudo systemctl status docker`），并且 `DOCKER_HOST` 环境变量未设置为无效值。在 macOS 上，验证 Docker Desktop 是否正在运行。

**Q: 如何自定义快捷键？**

LazyDocker 不完全支持通过配置进行按键重新映射，但你可以通过 `config.yml` 中的 `customCommands` 块添加自定义命令。对于与终端模拟器的冲突快捷键，配置你的终端以将原始按键传递给 TUI。

## 结论

LazyDocker 填补了一个特定的细分市场：快速、轻量、终端原生的 Docker 管理。凭借 51,092 个 GitHub stars、单二进制分发和低于 200 毫秒的启动时间，它消除了浏览器标签页之间切换或记忆 CLI 参数的摩擦。对于个人开发者、家庭实验室操作员以及任何生活在终端中的人来说，它是工具集的一个实用补充。

**入门行动项：**

1. 通过 Homebrew 或官方脚本安装 LazyDocker（60 秒内）
2. 在有运行容器的项目中启动 `lazydocker`
3. 记忆 5 个基本键：`r`（重启）、`s`（停止）、`d`（移除）、`m`（日志）、`E`（执行 shell）
4. 按 `o` 打开配置并自定义主题和日志设置
5. 为 `lzd` 添加 shell 别名并与 tmux 集成以实现弹出访问

加入 [dibi8 Telegram 社区](https://t.me/dibi8_chat) 分享你的 LazyDocker 工作流技巧，并从其他大规模管理容器的开发者那里获得帮助。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [LazyDocker GitHub 仓库](https://github.com/jesseduffield/lazydocker)
- [官方快捷键参考](https://github.com/jesseduffield/lazydocker/blob/master/docs/keybindings/Keybindings_en.md)
- [配置文档](https://github.com/jesseduffield/lazydocker/blob/master/docs/Config.md)
- [LazyDocker 安装指南](https://github.com/jesseduffield/lazydocker#installation)
- [LazyDocker 官方网站](https://lazydocker.com)
- [Portainer vs LazyDocker 对比（OneUptime）](https://oneuptime.com/blog/post/2026-03-20-portainer-vs-lazydocker-terminal/view)
- [DataCamp LazyDocker 教程](https://www.datacamp.com/tutorial/lazydocker)
- [LazyDocker Podman 扩展](https://github.com/szchan/lazydocker-podman)
