---
title: 'Atuin: 29,794 GitHub Stars — Shell History Sync 完整设置指南 2026'
description: 'Atuin 将 shell 历史记录替换为 SQLite 数据库，记录命令上下文（退出码、工作目录、执行时长），并通过端到端加密在多台机器间同步历史记录。支持 Bash、Zsh、Fish、Nushell。涵盖安装、自托管、配置，以及 Atuin vs mcfly vs fzf vs Hstr 对比。'
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
github_repo: 'https://github.com/atuinsh/atuin'
stars: 29794
maintainer: 'atuinsh'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['atuin', 'shell历史', '命令行工具', 'sqlite', 'rust', '同步', 'bash', 'zsh', 'fish']
aliases:
- /zh/posts/atuin/
---

{{</* resource-info */>}}

![Atuin Shell History](https://raw.githubusercontent.com/atuinsh/atuin/main/docs/static/img/atuin.png)

*Atuin 将现有 shell 历史替换为 SQLite 数据库和全屏模糊搜索界面，通过 Ctrl+R 激活。*

![Atuin Stats](https://docs.atuin.sh/assets/images/stats.png)

*`atuin stats` 命令显示你最常用的命令、总命令数和唯一命令统计。*

## 引言

那个复杂的 `kubectl` 命令你这周至少输入过三次。你知道它肯定在历史记录里的某个地方——可能埋在另外四万条命令下面——但 `Ctrl+R` 反向搜索只能逐个匹配循环，而 `grep ~/.bash_history` 返回的则是一堵噪声之墙。对于活在终端里的开发者来说，shell 历史就是第二记忆。当它失效时，生产力随之下降。

Atuin 通过 SQLite 驱动的历史数据库解决了这个问题，它不仅记录命令本身，还记录围绕命令的上下文：退出码、工作目录、主机名、会话 ID 和执行时长。凭借 29,794 个 GitHub Stars 和基于 Rust 的代码库，Atuin 为每个 shell 会话添加了模糊搜索、加密跨机同步和使用分析功能。本指南将带你完成生产级的 Atuin 安装，从第一条命令到自托管同步服务器。

## Atuin 是什么？

Atuin 是一款用 Rust 编写的 shell 历史替换工具，它将命令存储在带有丰富元数据的本地 SQLite 数据库中，然后通过端到端加密可选地在多台机器间同步历史记录。它由 atuinsh 组织维护，采用 MIT 许可证发布，支持 Bash、Zsh、Fish、Nushell、Xonsh 和 PowerShell（二级支持）。

## Atuin 的工作原理

Atuin 作为客户端历史拦截器和可选的同步客户端运行。理解其架构有助于调试同步问题或规划自托管部署。

### 架构概览

```
+-------------+     preexec/precmd 钩子     +------------------+
|   Shell     |  -------------------------->  |   Atuin Client   |
| (bash/zsh)  |                             |   (Rust binary)  |
+-------------+                             +--------+---------+
                                                     |
                                            +--------v---------+
                                            |   SQLite (本地)   |
                                            |   ~/.local/share |
                                            +--------+---------+
                                                     |
                              +----------------------v----------------------+
                              |              同步协议 V2                      |
                              |   PASETO V4 (XChaCha20-Poly1305 + Blake2b) |
                              +----------------------+----------------------+
                                                     |
                              +----------------------v----------------------+
                              |         Atuin 服务器（自托管或云端）          |
                              |         PostgreSQL 或 SQLite 后端            |
                              +---------------------------------------------+
```

### 核心组件

1. **Shell 钩子层**：Atuin 通过 shell 专用插件注册 `preexec`（命令前）和 `precmd`（命令后）钩子。这些钩子捕获命令字符串、工作目录、开始时间和退出码。
2. **本地 SQLite 数据库**：所有历史记录存储在 `~/.local/share/atuin/history.db` 中，使用 SQLite 配合 WAL 模式以实现并发读写性能。
3. **同步客户端**：可选的后台同步将加密记录推送到 Atuin 服务器。数据在离开机器前使用每条记录独立的内容加密密钥进行信封加密。
4. **TUI 搜索界面**：全屏终端 UI（基于 `ratatui` 构建）替代 `Ctrl+R`，支持模糊/前缀/全文搜索和过滤模式。

### 加密细节

| 协议 | 算法 | 状态 |
|------|------|------|
| V1（旧版） | XSalsa20Poly1305（NaCl secretbox） | 逐步淘汰 |
| V2（当前） | PASETO V4 Local（XChaCha20-Poly1305 + Blake2b） | 活跃 |

V2 使用信封加密：每条记录获得一个随机 CEK，用用户的主密钥包裹。主密钥位于 `~/.local/share/atuin/key`，永远不会离开设备。

## 安装与设置

### 一行命令安装（推荐）

```bash
# Unix/macOS — 交互式安装，带 shell 设置提示
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# 非交互式（CI、Dockerfile）
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
```

安装程序将二进制文件放在 `~/.atuin/bin/atuin`，并将 shell 集成添加到你的 rc 文件。

### 包管理器安装

```bash
# Homebrew（macOS/Linux）
brew install atuin

# Cargo（需要 Rust 工具链）
cargo install atuin

# Arch Linux
sudo pacman -S atuin

# NixOS / nix
nix-env -iA nixpkgs.atuin

# Debian/Ubuntu（从 GitHub releases）
VERSION="18.16.1"
curl -LO "https://github.com/atuinsh/atuin/releases/download/v${VERSION}/atuin_${VERSION}_amd64.deb"
sudo dpkg -i "atuin_${VERSION}_amd64.deb"

# Windows（WinGet）
winget install -e Atuinsh.Atuin
```

### Shell 集成

安装后，将 Atuin 添加到 shell 的 rc 文件：

```bash
# Bash — 添加到 ~/.bashrc
eval "$(atuin init bash)"

# Zsh — 添加到 ~/.zshrc
eval "$(atuin init zsh)"

# Fish — 添加到 ~/.config/fish/config.fish
atuin init fish | source

# Nushell — 添加到 config.nu
atuin init nu | save ~/.config/nushell/atuin.nu
source ~/.config/nushell/atuin.nu
```

重新加载 shell 或运行 `exec $SHELL` 激活。

### 导入现有历史记录

```bash
# 自动检测 shell 并导入
atuin import auto

# 或显式指定
atuin import bash
atuin import zsh
atuin import fish

# 检查导入了多少
atuin stats
```

### 验证安装

```bash
$ atuin --version
atuin 18.16.1

$ atuin doctor
Atuin Doctor
Checking for diagnostics
[✓] Atuin is compiled with sqlite support
[✓] Atuin is compiled with sync support
[✓] Atuin config directory exists
```

## 核心配置

Atuin 的配置文件位于 `~/.config/atuin/config.toml`。在深入设置之前，以下是搜索界面在不同过滤模式下的实际效果：

![Atuin Search UI](https://docs.atuin.sh/assets/images/search.png)

*Atuin 的 TUI 显示内联搜索窗口，支持模糊匹配和目录范围搜索结果。*以下是一份生产级加固配置：

```toml
# ~/.config/atuin/config.toml
[settings]
# 搜索模式：prefix, fulltext, fuzzy, skim
search_mode = "fuzzy"

# 过滤模式：global, host, session, directory
filter_mode = "global"

# UI 样式：compact, full
style = "compact"

# 同步设置
auto_sync = true
sync_frequency = "5m"
sync_address = "https://api.atuin.sh"

# 不记录敏感命令（正则表达式模式）
history_filter = [
    "^export.*KEY",
    "^export.*SECRET",
    "^export.*PASSWORD",
    "^aws configure",
    "^ssh-keygen",
]

# 工作目录过滤器 — 在这些路径下不记录
cwd_filter = [
    "/tmp/secrets",
    "~/.*cred",
]

# Enter 直接执行命令；false = Tab 先编辑
enter_accept = true

# 在搜索 UI 中显示帮助提示
show_help = false

# 结果数量
inline_height = 20
```

### 关键配置选项说明

```bash
# 查看当前配置值
atuin config get search_mode
# fuzzy

# 查看解析后的（有效）值
atuin config get search_mode --resolved
# fuzzy

# 内联设置配置值
atuin config set search_mode fulltext
atuin config set filter_mode directory

# 打印完整配置
atuin config print
```

### 搜索与过滤模式

```bash
# Ctrl+R 可在过滤模式间交互切换
# 默认过滤模式：global -> host -> session -> directory

# 命令行搜索带过滤
atuin search --exit 0 --after "yesterday 3pm" make
atuin search --before "2026-01-01" --cwd /project deploy
atuin search --exit 1 --session       # 本会话中失败的命令

# 删除匹配的条目
atuin search --delete "rm -rf /accident"
```

## 与流行工具集成

### Starship 提示符

Starship 与 Atuin 无冲突地协同工作。两者独立 hook 到 shell 事件：

```toml
# ~/.config/starship.toml — 无需特殊配置
# Atuin 处理历史记录；Starship 处理提示符
# 确保在 rc 文件中 Atuin init 在 Starship init 之前运行
```

```bash
# ~/.zshrc — 顺序很重要
eval "$(atuin init zsh)"       # Atuin 在前
eval "$(starship init zsh)"    # Starship 在后
```

### tmux

Atuin 与 tmux 会话干净集成。每个 tmux 窗口获得独立的会话 ID，支持按窗口历史过滤：

```bash
# ~/.tmux.conf — 绑定按键打开 Atuin 搜索
bind-key r run-shell "tmux send-keys C-r"

# Atuin 通过环境变量自动检测 tmux 会话
# 按会话过滤：按 Ctrl+R 然后切换过滤模式
```

### fzf

一些用户将 Atuin 与 fzf 配对：用 fzf 模糊查找文件，用 Atuin 处理历史：

```bash
# fzf 用于文件，Atuin 用于历史
# 禁用 fzf 历史绑定（在 ~/.bashrc 或 ~/.zshrc 中）
export FZF_DEFAULT_COMMAND='fd --type f --hidden'
# 不要绑定 Ctrl+R — 让 Atuin 处理

# fzf 查找文件
alias ff='fzf --preview "bat --style=numbers --color=always {}"'

# Atuin 处理历史（自动绑定到 Ctrl+R）
```

### Nushell

由于 Nushell 使用不同的配置系统，需要显式设置：

```nushell
# config.nu
source ~/.config/nushell/atuin.nu

# 设置环境变量
$env.ATUIN_NOBIND = true  # 如果需要自定义按键绑定
```

### Docker / Dev Containers

```dockerfile
# Dockerfile.dev
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
COPY config.toml /root/.config/atuin/config.toml
RUN echo 'eval "$(atuin init bash)"' >> /root/.bashrc
```

## 自托管同步服务器

对于团队或注重隐私的用户，Atuin 的同步服务器可以通过 Docker 自托管。

### Docker Compose 设置

```yaml
# docker-compose.yml
version: "3"
services:
  atuin:
    restart: always
    image: ghcr.io/atuinsh/atuin:latest
    command: server start
    volumes:
      - ./config:/config
      - ./atuin-data:/atuin-data
    links:
      - postgresql
    ports:
      - "8888:8888"
    environment:
      ATUIN_HOST: "0.0.0.0"
      ATUIN_PORT: "8888"
      ATUIN_OPEN_REGISTRATION: "true"
      ATUIN_DB_URI: "postgres://atuin:change-me@postgresql/atuin"
      RUST_LOG: "info,atuin_server=debug"
    user: "1000:1000"

  postgresql:
    image: postgres:14
    restart: always
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: atuin
      POSTGRES_PASSWORD: change-me
      POSTGRES_DB: atuin
    user: "1000:1000"

  # 可选：自动备份
  backup:
    image: prodrigestivill/postgres-backup-local
    restart: always
    volumes:
      - ./backups:/backups
    links:
      - postgresql
    environment:
      POSTGRES_HOST: postgresql
      POSTGRES_DB: atuin
      POSTGRES_USER: atuin
      POSTGRES_PASSWORD: change-me
      POSTGRES_EXTRA_OPTS: "-Z6 --schema=public --blobs"
      SCHEDULE: "@daily"
      BACKUP_KEEP_DAYS: "7"
```

### 启动服务器

```bash
# 创建数据目录
mkdir -p atuin-data postgres-data backups

# 启动服务
docker compose up -d

# 检查健康状态
curl http://localhost:8888/health
# {"status":"ok"}
```

### 自托管的客户端配置

```toml
# ~/.config/atuin/config.toml
[settings]
sync_address = "http://your-server:8888"
auto_sync = true
sync_frequency = "5m"
```

```bash
# 在自托管服务器上注册新账户
atuin register -u myuser -e myuser@example.com -p securepassword

# 或在其他机器上登录
atuin login -u myuser -p securepassword

# 获取你的加密密钥（安全备份）
atuin key
# c2e2d6e5a9b1c3f4d7e8a9b0c1d2e3f4...

# 触发同步
atuin sync
```

### Kubernetes 部署

```yaml
# atuin-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: atuin-server
spec:
  replicas: 2
  selector:
    matchLabels:
      app: atuin
  template:
    metadata:
      labels:
        app: atuin
    spec:
      containers:
        - name: atuin
          image: ghcr.io/atuinsh/atuin:18.16.1
          command: ["atuin", "server", "start"]
          ports:
            - containerPort: 8888
          env:
            - name: ATUIN_HOST
              value: "0.0.0.0"
            - name: ATUIN_DB_URI
              valueFrom:
                secretKeyRef:
                  name: atuin-db-secret
                  key: uri
---
apiVersion: v1
kind: Service
metadata:
  name: atuin-service
spec:
  selector:
    app: atuin
  ports:
    - port: 8888
      targetPort: 8888
```

## 基准测试 / 真实用例

### 性能特征

Atuin 的 Rust 实现和 SQLite 后端在大型历史数据集上提供稳定的性能：

| 指标 | 数值 | 说明 |
|------|------|------|
| 历史查询（10万条） | ~15ms | 模糊搜索，冷缓存 |
| 历史查询（50万条） | ~45ms | 模糊搜索，热缓存 |
| 同步初始上传（5万条命令） | ~30秒 | 取决于带宽 |
| 增量同步 | ~1-3秒 | 典型每日增量 |
| 二进制文件大小 | ~12MB | 单静态二进制 |
| 内存占用 | ~15MB | 空闲时驻留 |
| SQLite DB 大小 | ~100MB/10万命令 | 含完整元数据 |

### 生产用例

1. **多设备开发**：一位开发者拥有工作笔记本、个人台式机和云虚拟机，保持所有 shell 历史同步。在一台机器上运行 `docker compose up`，可在另一台机器上搜索到。
2. **团队知识保留**：DevOps 团队自托管 Atuin，以在轮值的 on-call 工程师之间维护可搜索的基础设施命令审计跟踪。
3. **远程环境恢复**：使用临时云工作空间（Gitpod、Coder）的开发者同步历史，工作空间销毁不会擦除命令上下文。

### Stats 命令输出

```bash
$ atuin stats
[▮▮▮▮▮▮▮▮▮▮]  9,607 fg
[▮▮▮▮▮▮▮▮▮ ]  9,458 vim
[▮▮▮       ]  3,144 ag
[▮▮▮       ]  3,095 git status
[▮▮        ]  2,248 git diff
[▮         ]  1,787 curl
[▮         ]  1,571 jq
[▮         ]  1,357 rg
[▮         ]  1,348 cd
[▮         ]  1,322 git log
Total commands:   62,849
Unique commands:  26,908
```

## 高级用法 / 生产环境加固

### 历史隐私过滤器

防止敏感命令进入数据库：

```toml
# ~/.config/atuin/config.toml
[settings]
history_filter = [
    # AWS 凭证
    "^aws configure",
    "^export AWS_SECRET_ACCESS_KEY",
    # 通用密钥
    "^export.*SECRET",
    "^export.*PASSWORD",
    "^export.*TOKEN",
    "^echo.*password",
    # SSH 密钥
    "^ssh-add",
    "^ssh-keygen",
    # 数据库连接字符串
    "^psql.*://.*:",
    "^mysql.*-p",
]
```

### 备份你的历史记录

```bash
# SQLite 备份（安全，无锁问题）
sqlite3 ~/.local/share/atuin/history.db ".backup '/backup/atuin-$(date +%Y%m%d).db'"

# 或通过 WAL 检查点复制
cp ~/.local/share/atuin/history.db ~/backups/atuin-backup.db

# 通过 cron 自动每日备份
0 2 * * * sqlite3 ~/.local/share/atuin/history.db ".backup '/backups/atuin/atuin-$(date +\%Y\%m\%d).db'" && find /backups/atuin -mtime +30 -delete
```

### 监控同步健康

```bash
# 检查上次同步时间
atuin sync --force  # 强制同步并显示状态

# 查看同步信息
atuin info
# Atuin v18.16.1
# Sync interval: 5m
# Sync address: https://api.atuin.sh
# Last sync: 2026-05-20T08:15:32Z
# History count: 47,231

# 检查问题
atuin doctor
```

### TUI 主题

```toml
# ~/.config/atuin/config.toml
[theme]
# 使用终端默认颜色
use_default_colors = true

# 或指定显式颜色
base = "#1e1e2e"
layer1 = "#313244"
text = "#cdd6f4"
accent = "#89b4fa"
```

### 多机器密钥迁移

设置新机器时，安全地传输加密密钥：

```bash
# 在旧机器上 — 复制密钥到剪贴板（或通过安全传输）
cat ~/.local/share/atuin/key

# 在新机器上 — 安装并登录后
mkdir -p ~/.local/share/atuin
echo "YOUR_KEY_HERE" > ~/.local/share/atuin/key
chmod 600 ~/.local/share/atuin/key

# 验证同步正常
atuin sync
atuin stats
```

## 与替代品对比

| 功能 | Atuin | mcfly | fzf + history | Hstr |
|------|-------|-------|---------------|------|
| **数据库** | SQLite | SQLite | 纯文本文件 | 纯文本文件 |
| **跨机同步** | 是（端到端加密） | 否 | 否 | 否 |
| **搜索 UI** | 内置 TUI | 内置 TUI | fzf 集成 | 内置 TUI |
| **上下文记录** | cwd、退出码、时长、主机 | cwd、退出码 | 无 | 无 |
| **统计** | `atuin stats` | 无 | 无 | 无 |
| **Shell 支持** | bash、zsh、fish、nu、xonsh | bash、zsh、fish | 任意 shell | bash、zsh |
| **加密** | PASETO V4 | 无 | 无 | 无 |
| **自托管服务器** | 是（Docker/K8s） | 不适用 | 不适用 | 不适用 |
| **AI 集成** | 是（可选） | 否 | 否 | 否 |
| **历史导入** | bash、zsh、fish、nu | bash、zsh、fish | 不适用 | bash、zsh |
| **GitHub Stars** | 29,794 | 6,800 | 67,000 (fzf) | 3,900 |
| **二进制大小** | ~12MB | ~4MB | ~4MB（仅 fzf） | ~2MB |

### 何时选择哪款工具

- **Atuin**：你需要在多台机器间加密同步、丰富的上下文元数据和全功能搜索 UI。最适合使用 2 台以上机器且重视历史分析的开发者。
- **mcfly**：你需要轻量、完全本地的工具，带智能上下文排序。最适合单机用户，零网络依赖。
- **fzf + history**：你已使用 fzf 查找文件，想要极简的历史方案。最适合希望一个工具搞定所有模糊搜索的用户。
- **Hstr**：你需要简单轻量的历史 TUI，无数据库开销。最适合 bash/zsh 上的极简主义者。

## 限制 / 诚实评估

Atuin 并非适用于所有场景：

1. **无执行者追踪**：Atuin 记录命令，但无法区分是手动输入、脚本执行还是 AI 助手生成。所有来源在数据库中看起来都一样。

2. **本地数据库未加密**：位于 `~/.local/share/atuin/` 的 SQLite 数据库以明文存储以保证搜索性能。同步是加密的，但本地存储未加密。使用文件系统加密（LUKS、FileVault）进行保护。

3. **Bash 集成可能脆弱**：Bash 的 `preexec` 钩子依赖 DEBUG trap，可能与其他工具（pyenv、nodenv、某些 PROMPT_COMMAND 设置）冲突。Zsh 和 Fish 集成更可靠。

4. **同步需要账户**：即使自托管同步也需要用户注册。没有匿名或"直接同步到 S3"模式。

5. **上箭头绑定让新用户困惑**：Atuin 默认替换上箭头键，可能让只想循环最近命令的用户困惑。设置 `filter_mode_shell_up_key = "session"` 或完全禁用该绑定。

6. **PowerShell 支持为二级**：虽然功能正常，但 PowerShell 集成测试较少，可能落后于 Unix shell 功能。

## 常见问题

### 如何禁用上箭头绑定？

在配置中添加 `filter_mode_shell_up_key = "global"` 或 `show_preview = false`。要完全禁用 Atuin 的上箭头，在 init 行前添加 `export ATUIN_NOBIND=1`，然后手动绑定 `Ctrl+R`：

```bash
# ~/.bashrc
export ATUIN_NOBIND=1
eval "$(atuin init bash)"
bind '"\C-r": "\C-aatuin search\C-j"'
```

### 可以完全不使用同步吗？

可以。Atuin 完全作为本地工具工作。跳过注册，忽略所有同步命令。你的历史存储在本地 SQLite 中，所有搜索功能离线可用。

### 我的数据如何加密？

所有同步数据在离开机器前使用 PASETO V4（XChaCha20-Poly1305 + Blake2b）进行客户端加密。同步服务器（无论是自托管还是 atuin.sh）只能看到加密 blob——它无法解密或读取你的命令。本地 SQLite 数据库未加密，以保证搜索性能。

### 如果丢失加密密钥会怎样？

加密密钥是解密同步历史所必需的。如果丢失，无法恢复之前同步的数据。密钥在初始设置时通过 `atuin key` 显示——请备份到密码管理器。本地历史无论密钥是否存在都可访问。

### 两个用户可以共享历史数据库吗？

不能直接共享。Atuin 的同步模型专为同一用户跨多设备设计。对于团队共享历史，每个用户维护自己的数据库和同步账户。自托管服务器支持多个独立账户。

### Atuin 会降低 shell 速度吗？

没有可测量的影响。Rust 二进制文件增加约 5-10ms 的 shell 启动时间（一次性），命令捕获通过 shell 钩子异步进行。SQLite WAL 模式确保写入不会阻塞 shell 提示符。

### 如何从历史记录中删除命令？

```bash
# 按搜索模式删除
atuin search --delete "sensitive-command"

# 或使用 TUI — 找到命令，然后按 Alt+Delete
```

## 结论

Atuin 将 shell 历史从纯文本文件转变为结构化、可搜索、可移植的数据库。凭借 29,794 个 GitHub Stars、端到端加密同步和对所有主流 shell 的支持，它是任何活在终端里的开发者的实用升级。

**后续步骤：**
1. 运行 `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh` 安装
2. 使用 `atuin import auto` 导入现有历史
3. 注册同步或配置自托管服务器
4. 加入 [Telegram 开发者社区](https://t.me/dibi8dev) 获取技巧和故障排除



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [Atuin GitHub 仓库](https://github.com/atuinsh/atuin)
- [Atuin 官方文档](https://docs.atuin.sh/)
- [Atuin 自托管指南](https://docs.atuin.sh/self-hosting/docker/)
- [Atuin 配置参考](https://docs.atuin.sh/cli/reference/config/)
- [PASETO V4 规范](https://paseto.io/)
- [Ellie Huxtable — Atuin 创作者博客](https://ellie.wtf/projects/atuin)
- [mcfly GitHub 仓库](https://github.com/cantino/mcfly)
- [fzf GitHub 仓库](https://github.com/junegunn/fzf)
- [Hstr GitHub 仓库](https://github.com/dvorka/hstr)
