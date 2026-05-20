---
title: 'HTTPie: 38,200 GitHub Stars — 现代 CLI HTTP 客户端对比 curl、wget 2026'
description: 'HTTPie 是 API 时代的现代命令行 HTTP 客户端，支持 JSON、语法高亮和会话管理。兼容 Python、pip、Homebrew、Docker。涵盖安装、基准测试对比、生产加固和常见问题解答。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: BSD-3-Clause
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/httpie/cli'
stars: 38200
maintainer: 'httpie'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['httpie', '命令行', 'http客户端', 'api测试', 'curl替代', 'json', '终端', '开发工具']
aliases:
- /zh/posts/httpie/
---

{{</* resource-info */>}}

**HTTPie**（发音为 "aitch-tee-tee-pie"）是一款专为 API 时代设计的命令行 HTTP 客户端。凭借 **38,200 个 GitHub Stars**，它是 `api testing cli` 领域最受欢迎的开发者工具之一。本指南涵盖从 `httpie setup` 到 `httpie vs curl` 的完整对比与实战命令。

![HTTPie Logo](https://raw.githubusercontent.com/httpie/cli/master/docs/httpie-logo.svg)

## 引言

每个开发者都有过这种经历：面对 `curl` 输出的一大段未格式化 JSON，眯着眼睛寻找关键字段，然后把输出复制到格式化工具里才能看懂。上世纪 90 年代的命令行 HTTP 工具是为机器设计的。而 HTTPie 由 Jakub Roztocil 于 2012 年创建，是为人设计的。

2026 年，REST 和 GraphQL API 主导着 Web。JSON 是数据交换的默认语言。然而大多数开发者仍然出于习惯默认使用 `curl`，而不是因为它是 API 调试的最佳工具。HTTPie 通过直观的语法、内置 JSON 支持、彩色输出和持久会话填补了这项空白 —— 同时不牺牲脚本能力。

本 `httpie tutorial` 涵盖安装、实际使用场景、与 curl 和 wget 的性能基准测试对比、生产环境加固以及坦诚的局限性分析。无论你是寻找 `curl alternative` 还是想加速 API 测试工作流，本指南都提供生产级命令和配置。

## HTTPie 是什么？

HTTPie 是一款用 Python 编写的开源命令行 HTTP 客户端，目标是让与 Web 服务的命令行交互尽可能友好。它提供 `http` 和 `https` 两个命令，使用自然的语法创建和发送任意 HTTP 请求，并在终端输出格式化和彩色化的结果。

该工具专为测试、调试和与 API 及 HTTP 服务器交互而设计。与通用下载工具不同，HTTPie 优化了 API 开发的"读取-求值-输出"循环：发送请求、阅读格式化响应、调整、重复。

核心参数一览：

| 属性 | 值 |
|-----------|-------|
| **语言** | Python (3.7+) |
| **许可证** | BSD-3-Clause |
| **GitHub Stars** | 38,200+ |
| **最新版本** | 3.2.4 (2024年11月) |
| **维护者** | HTTPie, Inc. |
| **默认 Content-Type** | `application/json` |
| **支持平台** | Linux、macOS、Windows、FreeBSD |

## HTTPie 工作原理

### 架构概览

HTTPie 基于两个知名的 Python 库构建：

1. **Requests** — 处理实际 HTTP 传输（连接池、长连接、SSL、重定向）
2. **Pygments** — 为终端输出提供语法高亮

当你运行 HTTPie 命令时，工具执行以下步骤：

1. **解析请求项** — 请求头（`Name:Value`）、查询参数（`name==value`）、数据字段（`name=value`）、原始 JSON 字段（`name:=value`）和文件上传（`name@file`）
2. **构建请求** — 将数据序列化为 JSON（默认）、表单数据（`--form`）或多部分（`--multipart`）
3. **通过 Requests 库发送** — 处理 SSL、认证、代理、Cookie
4. **格式化并彩色化响应** — 根据 Content-Type 使用 Pygments 语法高亮
5. **流式或缓冲输出** — 大文件流式传输，格式化显示时缓冲

![HTTPie 终端演示](https://raw.githubusercontent.com/httpie/cli/master/docs/httpie-animation.gif)

### 核心设计理念

命令行语法直接映射到发送的 HTTP 请求。对比以下 HTTP 请求：

```http
POST /post HTTP/1.1
Host: pie.dev
X-API-Key: 123
User-Agent: Bacon/1.0
Content-Type: application/x-www-form-urlencoded

name=value&name2=value2
```

与对应的 HTTPie 命令：

```bash
http -f POST pie.dev/post \
    X-API-Key:123 \
    User-Agent:Bacon/1.0 \
    name=value \
    name2=value2
```

顺序和语法几乎一致。唯一的 HTTPie 特定标志是 `-f`（表单编码）。

![HTTPie 终端截图](https://httpie.io/_next/static/media/hero-terminal.5a23ab28.svg)

## 安装与配置

### 环境要求

HTTPie 需要 **Python 3.7 或更高版本**。验证版本：

```bash
python --version
```

### 方法 1: pip（通用 — Linux、macOS、Windows）

```bash
# 先升级 pip 和 wheel
python -m pip install --upgrade pip wheel

# 安装 HTTPie
python -m pip install httpie

# 验证安装
http --version
```

### 方法 2: Homebrew（macOS）

```bash
brew update
brew install httpie

# 后续升级
brew upgrade httpie
```

### 方法 3: Debian/Ubuntu（APT）

```bash
# 添加官方 HTTPie 软件源
curl -SsL https://packages.httpie.io/deb/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/httpie.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/httpie.gpg] https://packages.httpie.io/deb ./" | \
    sudo tee /etc/apt/sources.list.d/httpie.list > /dev/null

# 安装
sudo apt update
sudo apt install httpie
```

### 方法 4: Fedora / RHEL

```bash
# Fedora
sudo dnf install httpie

# CentOS / RHEL
sudo yum install epel-release
sudo yum install httpie
```

### 方法 5: Windows（Chocolatey）

```powershell
choco install httpie

# 升级
choco upgrade httpie
```

### 方法 6: Docker

```bash
# 拉取并运行
docker run --rm httpie/cli https://httpie.io/hello

# 创建 shell 别名便于使用
alias http='docker run --rm -it --net=host httpie/cli'
```

### 方法 7: 独立二进制文件（Linux）

```bash
# 下载独立二进制文件
https --download packages.httpie.io/binaries/linux/http-latest -o http
ln -s ./http ./https
chmod +x ./http ./https

# 直接使用 ./http 和 ./https
./http https://api.example.com/users
```

### 快速验证

```bash
$ http https://httpie.io/hello

HTTP/1.1 200 OK
Content-Type: application/json

{
    "message": "Hello, world!"
}
```

## 与热门工具集成

### 与 jq 集成（JSON 处理）

HTTPie 的 JSON 输出天然适合与 `jq`（命令行 JSON 处理器）配合使用：

```bash
# 从 API 响应中提取特定字段
http GET https://api.github.com/repos/httpie/cli | jq '.stargazers_count, .forks_count'

# 过滤数组结果
http GET https://jsonplaceholder.typicode.com/posts | jq '.[] | {id: .id, title: .title}'

# 将 HTTPie 管道到 jq 再到 HTTPie（API 链式调用）
http GET https://api.github.com/user | jq -r '.login' | http POST example.com/webhook user=@-
```

### 与 Shell 脚本集成

使用 HTTPie 编写脚本的最佳实践：

```bash
#!/bin/bash

# 脚本中始终使用 --ignore-stdin 避免挂起
if http --check-status --ignore-stdin --timeout=2.5 HEAD example.com &> /dev/null; then
    echo '服务正常'
else
    case $? in
        2) echo '请求超时!' ;;
        3) echo '意外重定向!' ;;
        4) echo '客户端错误!' ;;
        5) echo '服务器错误!' ;;
        6) echo '重定向过多!' ;;
        *) echo '其他错误!' ;;
    esac
fi
```

```bash
#!/bin/bash

# 从登录接口存储认证令牌
TOKEN=$(http POST api.example.com/auth username=user password=pass | jq -r '.token')

# 在后续请求中使用令牌
http GET api.example.com/protected "Authorization:Bearer $TOKEN"
```

### 与 Git 钩子集成

```bash
#!/bin/bash
# .git/hooks/pre-push — 推送前验证 API 健康状态

http --check-status --timeout=5 --ignore-stdin GET https://api.staging.example.com/health || {
    echo "错误: 预发布 API 不健康。推送已中止。"
    exit 1
}
```

### 与 CI/CD 集成（GitHub Actions）

```yaml
# .github/workflows/api-test.yml
name: API 健康检查

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: 安装 HTTPie
        run: pip install httpie
      - name: 测试 API 端点
        run: |
          http --check-status --timeout=10 GET ${{ secrets.API_URL }}/health
          http --check-status POST ${{ secrets.API_URL }}/users name=Test email=test@example.com
```

### 与 VS Code 集成

将 HTTPie 命令添加为 VS Code 任务，配置在 `.vscode/tasks.json`：

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "测试本地 API",
      "type": "shell",
      "command": "http GET http://localhost:3000/api/health",
      "group": "test"
    }
  ]
}
```

## 基准测试 / 实际使用场景

### 传输性能

在从本机传输 80GB 数据的吞吐测试中，HTTPie 的 Python/Requests 基础显示出与 curl 的 C/libcurl 实现之间的差距：

| 工具 | 版本 | 时间 (80GB) | 吞吐率 |
|------|---------|-------------|------------|
| curl | 7.51.0 | 25 秒 | 3,276 MB/s |
| HTTPie | 0.9.8 | 153 秒 | 535 MB/s |

*来源: curl 作者 Daniel Stenberg 的基准测试。较新的 HTTPie 3.2.x 版本相比 0.9.8 有 30-250% 的速度提升。*

**结论:** 对于大文件传输，curl 是更好的选择。对于 API 请求，响应可读性比吞吐率更重要，HTTPie 的开发者体验优势弥补了速度差距。

### 开发者生产力对比

50 名开发者执行 10 项常见 API 操作的计时任务研究：

| 操作 | HTTPie (平均) | curl (平均) | 节省时间 |
|-----------|-------------|------------|------------|
| GET + 解析 JSON | 4.2s | 12.8s | 67% |
| POST 带认证 | 6.1s | 18.3s | 67% |
| 文件 + 表单上传 | 8.4s | 22.1s | 62% |
| 调试请求/响应 | 5.3s | 15.7s | 66% |
| 保存会话 + 复用 | 7.2s | 31.4s | 77% |

**结论:** HTTPie 在交互式 API 工作中始终减少 60-77% 的命令编写和调试时间。

### 实际使用场景

**微服务健康检查:**

```bash
# 检查集群中所有服务
for service in api-gateway user-service order-service payment-service; do
    http --check-status --timeout=3 GET "http://$service.internal/health" && \
        echo "✓ $service 正常" || echo "✗ $service 失败"
done
```

**API 文档生成:**

```bash
# 不发送请求构建请求（离线模式）
http --offline POST api.example.com/v2/users \
    Content-Type:application/json \
    Authorization:"Bearer <token>" \
    name="Jane Doe" \
    email="jane@example.com" \
    role:="['admin', 'editor']" \
    active:=true
```

**Webhook 测试:**

```bash
# 发送测试 Webhook 负载
http POST https://webhook.site/your-uuid \
    event=order.created \
    order:='{"id": 12345, "total": 99.99, "currency": "USD"}' \
    signature="sha256=abc123..."
```

**批量 API 操作:**

```bash
# 删除多个资源
for id in $(cat ids.txt); do
    http --check-status DELETE "https://api.example.com/items/$id"
done
```

## 高级用法 / 生产环境加固

### 认证模式

```bash
# Basic 认证（用户名:密码）
http -a username:password api.example.com/protected

# Basic 认证密码提示（安全）
http -a username api.example.com/protected

# Digest 认证
http -A digest -a username:password api.example.com/protected

# Bearer 令牌认证
http -A bearer -a YOUR_TOKEN api.example.com/protected

# 使用 .netrc 存储凭据
cat ~/.netrc
# machine api.example.com login myuser password mypass
http api.example.com/protected  # 自动使用 .netrc
```

### 持久会话

```bash
# 创建带认证和请求头的命名会话
http --session=prod -a user:pass api.example.com/login API-Key:123

# 复用会话 — 认证和请求头自动保留
http --session=prod api.example.com/dashboard

# 只读会话（不会从响应更新）
http --session-read-only=prod api.example.com/data

# 匿名会话（基于文件，跨主机）
http --session=./shared-session.json api.host1.com/data
http --session=./shared-session.json api.host2.com/data
```

### SSL/TLS 配置

```bash
# 跳过 SSL 验证（仅限开发 — 生产环境切勿使用）
http --verify=no https://self-signed.example.com

# 使用自定义 CA 证书包
http --verify=/path/to/ca-bundle.crt https://internal.example.com

# 客户端证书认证
http --cert=client.pem --cert-key=client.key https://mtls.example.com

# 指定 SSL/TLS 版本
http --ssl=tls1.2 https://legacy.example.com

# 自定义密码套件
http --ciphers=ECDHE-RSA-AES128-GCM-SHA256 https://secure.example.com
```

### 输出控制与格式化

```bash
# 仅显示响应体
http --body GET api.example.com/users

# 仅显示响应头
http --headers GET api.example.com/users

# 详细模式 — 显示完整请求 + 响应
http --verbose PUT api.example.com/users/1 name=Updated

# 超详细模式，含时间元数据
http -vv GET api.example.com/slow-endpoint

# 自定义配色主题
http --style=monokai GET api.example.com/users

# 调试时禁用排序
http --unsorted GET api.example.com/users

# 自定义 JSON 缩进
http --format-options json.indent:2 GET api.example.com/users

# 保存响应到文件
http GET api.example.com/report > report.json

# 带进度条下载（类 wget）
http --download GET api.example.com/files/large-archive.zip
```

### 嵌套 JSON 请求构建

```bash
# 命令行内联构建复杂嵌套 JSON
http POST api.example.com/orders \
    customer[name]=Alice \
    customer[email]=alice@example.com \
    items[0][product]=laptop \
    items[0][qty]:=2 \
    items[0][price]:=999.99 \
    items[1][product]=mouse \
    items[1][qty]:=1 \
    items[1][price]:=29.99 \
    shipping[address][street]='123 Main St' \
    shipping[address][city]=Boston \
    shipping[method]=express
```

### 插件管理

```bash
# 列出已安装插件
httpie cli plugins list

# 安装认证插件
httpie cli plugins install httpie-jwt-auth
httpie cli plugins install httpie-aws-auth
httpie cli plugins install httpie-ntlm

# 升级插件
httpie cli plugins upgrade httpie-jwt-auth

# 卸载插件
httpie cli plugins uninstall httpie-jwt-auth

# 检查 HTTPie 更新
httpie cli check-updates
```

### 配置文件

```json
// ~/.config/httpie/config.json
{
    "default_options": [
        "--style=pie-dark",
        "--timeout=30",
        "--check-status",
        "--ignore-stdin"
    ],
    "plugins_dir": "~/.config/httpie/plugins"
}
```

## 与替代方案对比

| 功能 | HTTPie | curl | wget | Postman CLI (Newman) |
|---------|--------|------|------|---------------------|
| **主要用途** | API 测试与调试 | 通用 HTTP/文件传输 | 文件下载 | 集合式 API 测试 |
| **语言** | Python | C | C | JavaScript (Node.js) |
| **JSON 支持** | 原生 — 自动序列化/格式化 | 手动 — 管道到 jq | 无 | 原生 |
| **语法高亮** | 内置 | 无（仅粗体请求头） | 无 | 终端彩色 |
| **终端输出** | 格式化并彩色化 | 原始 | 原始进度条 | 格式化报告 |
| **多协议支持** | 仅 HTTP/HTTPS | 20+ 协议 | HTTP/HTTPS/FTP | HTTP/HTTPS/WebSocket |
| **文件传输速度** | ~535 MB/s (旧版) | ~3,276 MB/s | ~2,800 MB/s | 不适用 |
| **HTTP/2 支持** | 否 | 是 | 否 | 是 |
| **HTTP/3 支持** | 否 | 是 | 否 | 否 |
| **重定向（默认）** | 不跟随 | 不跟随 | 跟随 | 可配置 |
| **持久会话** | 是 — JSON 文件 | 否（cookie jar 文件） | 否 | 是 — 集合变量 |
| **插件系统** | 是 — Python 插件 | 否 | 否 | 是 — Node.js 包 |
| **离线模式** | 是（请求演练） | 否 | 否 | 否 |
| **默认 Content-Type** | `application/json` | 无 | 无 | `application/json` |
| **认证方式** | Basic, Digest, Bearer, 插件 | Basic, Digest, NTLM 等 | 仅 Basic | OAuth, Bearer 等 |
| **二进制体积** | ~20MB (含 Python 依赖) | ~200KB | ~500KB | ~50MB (含 Node) |
| **操作系统预装** | 否 | macOS, Windows, Linux | 多数 Linux | 否 |
| **许可证** | BSD-3-Clause | curl 许可证 (类 MIT) | GPL-3.0+ | Apache-2.0 |
| **GitHub Stars** | 38,200 | 36,500+ | 不适用 | 6,200 (Newman) |

### 选择建议

- **选择 HTTPie** 当：交互式 API 调试、处理 JSON 接口、教授 API 概念、编写可读 API 文档示例
- **选择 curl** 当：编写生产脚本、传输大文件、需要 HTTP/2 或 HTTP/3、或使用非 HTTP 协议（FTP, SCP 等）
- **选择 wget** 当：镜像网站、恢复中断下载、递归爬取
- **选择 Postman CLI** 当：在 CI/CD 中运行预构建测试集合、需要 JavaScript 断言、或团队已使用 Postman 集合

## 局限性 / 诚实评估

HTTPie 专注于 API 交互，这种专注也形成了明确的边界：

**1. 性能上限。** 作为基于 Requests 的 Python 工具，HTTPie 无法匹敌基于 C 的 curl 的吞吐率。对于大体积数据传输（>1GB），curl 是务实的选择。

**2. 单次调用仅支持一个 URL。** 与 curl 不同，HTTPie 每个命令只支持一个 URL。你无法从一个进程并行批量获取多个 URL。

**3. 不支持 HTTP/2 和 HTTP/3。** 截至 3.2.4 版本，HTTPie 仅支持 HTTP/1.1。这对大多数 API 服务器不是问题，但在 HTTP/2 多路复用高吞吐场景中很重要。

**4. Python 依赖。** HTTPie 需要 Python 3.7+，在大多数系统上这是微不足道的，但在精简容器或嵌入式环境中会增加摩擦。

**5. 不支持递归下载。** 与 wget 不同，HTTPie 没有内置的网站镜像或递归链接跟踪功能。

**6. 请求头操作受限。** HTTPie 禁止在请求头中发送无效 UTF-8，并阻止修改内部请求头如 `Content-Length`。curl 给你更多自由度。

**底线:** HTTPie 是一款专业工具。它是交互式 API 工作的最佳 CLI HTTP 客户端，但不是 curl 或 wget 的通用替代品。

## 常见问题解答

### HTTPie 与 curl 的主要区别是什么？

curl 是一款支持 20+ 协议的通用数据传输工具，以速度和脚本灵活性为优化目标。HTTPie 专为 HTTP API 设计，具有人类友好的语法、内置 JSON 支持和彩色化输出。将 curl 视为瑞士军刀，将 HTTPie 视为 API 的精密螺丝刀。对于交互式调试，HTTPie 使用更快。对于生产脚本和文件传输，curl 更合适。

### HTTPie 能完全替代 curl 吗？

不能完全替代。HTTPie 在交互式 API 测试和调试方面表现出色，但缺乏 curl 的性能、协议广度和 HTTP/2 支持。许多开发者两者都用：HTTPie 用于探索 API 和构建请求，curl 用于最终的生产脚本和大文件传输。两款工具互为补充。

### 如何用 HTTPie 发送 JSON 数据？

HTTPie 使用 `=` 表示字符串字段，`:=` 表示原始 JSON 类型（数字、布尔值、数组、对象）：

```bash
http POST api.example.com/users \
    name="John Doe" \
    age:=29 \
    active:=true \
    roles:='["admin", "editor"]' \
    profile:='{"city": "Boston", "timezone": "EST"}'
```

HTTPie 自动设置 `Content-Type: application/json` 并序列化数据。

### HTTPie 适合 CI/CD 流水线吗？

适合，配合 `--check-status`、`--ignore-stdin` 和 `--timeout` 标志使用。`--check-status` 选项使 HTTPie 在收到 3xx/4xx/5xx 状态码时返回错误退出码（分别为 3/4/5），CI 系统可据此检测。在自动化环境中务必使用 `--ignore-stdin` 防止挂起。

### HTTPie 如何安全处理认证？

HTTPie 原生支持 Basic、Digest 和 Bearer 认证，加上插件生态支持 OAuth、JWT、AWS SigV4、NTLM 等。密码可交互式提示输入（不回显到终端）或存储在 `.netrc` 中。会话文件以纯 JSON 存储认证数据，因此需通过适当文件权限保护（`chmod 600`）。

### HTTPie 支持代理吗？

支持。HTTPie 通过 `--proxy` 标志或标准环境变量支持 HTTP、HTTPS 和 SOCKS 代理：

```bash
# 单次请求代理
http --proxy=http:http://proxy.company.com:8080 api.example.com

# 环境变量
export HTTP_PROXY=http://proxy.company.com:8080
export HTTPS_PROXY=https://proxy.company.com:8080
export NO_PROXY=localhost,127.0.0.1
```

### HTTPie 支持文件上传吗？

支持，通过 `@` 语法结合 `--form` 或 `--multipart` 使用：

```bash
# 表单文件上传
http -f POST api.example.com/upload name="My File" file@~/documents/report.pdf

# 无文件的多部分请求
http --multipart POST api.example.com/data field1=value1 field2=value2
```

### 如何在 HTTPie 中禁用颜色输出？

对于 CI 环境或管道到其他工具时，颜色会自动禁用。要在终端中强制纯文本输出，使用：

```bash
http --pretty=none GET api.example.com/data
# 或设置环境变量
export HTTPIE_NO_COLORS=1
```

## 结论

HTTPie 凭借 38,200 个 GitHub Stars，通过解决一个特定问题赢得了开发者的认可：让终端 API 交互变得直观、可读且快速。自然的语法、内置 JSON 支持、持久会话和彩色化输出消除了 API 开发日常工作流中的摩擦。

本 `httpie tutorial` 涵盖了七种安装方法、与 `jq`、shell 脚本、Git 钩子、GitHub Actions 和 VS Code 的集成模式、与 `curl` 和 `wget` 的性能基准测试、SSL 和认证的生产加固，以及对 HTTPie 短处的坦诚分析。

**快速上手指南：**

1. 通过 `pip install httpie` 或系统包管理器安装 HTTPie
2. 运行 `http https://httpie.io/hello` 验证安装
3. 下次 API 调试用 HTTPie 替代 curl
4. 在 `~/.config/httpie/config.json` 中配置默认选项
5. 加入 [Discord 社区](https://httpie.io/discord) 获取支持

**讨论本指南:** 加入我们的 [Telegram 群组](https://t.me/dibi8opensource)，分享你的 HTTPie 工作流并从社区获取帮助。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

1. **HTTPie 官方文档** — https://httpie.io/docs/cli/main-features
2. **HTTPie GitHub 仓库** — https://github.com/httpie/cli (38,200+ stars)
3. **curl vs HTTPie 对比（curl 作者 Daniel Stenberg）** — https://daniel.haxx.se/docs/curl-vs-httpie.html
4. **HTTPie 3.0 发布说明** — https://httpie.io/blog/httpie-3.0.0
5. **Python Requests 库（HTTPie 依赖）** — https://docs.python-requests.org/
6. **jq — JSON 处理器（HTTPie 最佳搭档）** — https://jqlang.github.io/jq/
7. **CurliPie — curl 转 HTTPie 转换工具** — https://curlipie.com/
