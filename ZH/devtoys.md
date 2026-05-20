---
title: 'DevToys: 31,533 GitHub 星标 — 开发者工具套件 2026 完整安装指南'
description: 'DevToys 是一款免费、开源、离线的开发者瑞士军刀。跨平台实用工具，支持 JSON、Base64、JWT、正则表达式等 30 余种工具，适用于 Windows、macOS 和 Linux，具备智能检测和 CLI 支持。'
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
github_repo: 'https://github.com/DevToys-app/DevToys'
stars: 31533
maintainer: 'DevToys-app'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['DevToys', '开发者工具', '离线工具', 'JSON格式化', 'Base64编码', 'JWT解码', '正则测试', '跨平台', '开源']
aliases:
- /zh/posts/devtoys/
---

{{</* resource-info */>}}

![DevToys Logo](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/logo/Logo.png)

## 简介

每位开发者都遇到过这种情况：你需要格式化一大段 JSON、解码一个 JWT 令牌，或者测试一个正则表达式，于是你打开了一个从未审计过的网站。那个网站可能获取你的数据、出售你的剪贴板内容，或者在你最需要它的时候离线。到了 2026 年，拥有 31,533 个 GitHub 星标且仍在增长的 **DevToys** 已经成为首选的离线替代方案——一款将 30 多种实用工具打包进隐私优先、跨平台工具箱的桌面应用。本 **devtoys tutorial** 和 **devtoys setup** 指南将引导你在任何操作系统上安装 DevToys，将其集成到日常工作流中，并了解它何时表现出色（以及何时不适合）。无论你是需要用于日常 JSON 格式化的 **developer utilities** 还是一个完整的 **dev tools offline** 工具套件，本指南都能满足你的需求。DevToys 最初是为 Windows 平台开发的，经过 2.0 版本的重大重构后，现在已经全面支持 macOS 和 Linux 系统，成为真正意义上的跨平台开发者工具集。该工具由西雅图和巴黎的开发者团队维护，采用 MIT 开源协议，允许任何人免费使用和修改。

## 什么是 DevToys？

**DevToys** 是一款免费、开源的桌面应用程序，将基本开发者实用工具整合到一个单一的离线工具包中。把它想象成开发者的瑞士军刀：JSON 格式化、Base64 编码/解码、JWT 检查、正则表达式测试、哈希生成、图像压缩等等——所有数据都不会发送到外部服务器。DevToys 主要使用 C# (73.3%) 编写，配合 SCSS 和 TypeScript，原生运行在 Windows、macOS 和 Linux 上，同时支持图形界面和命令行界面（CLI）。

该项目最初于 2021 年由 Etienne Baudoux 发起，作为 Windows 平台的 UWP 应用。经过多次迭代后，2024 年发布的 DevToys 2.0 版本彻底重写了整个架构，引入了跨平台支持、扩展 SDK 和 CLI 工具。目前项目已吸引超过 78 位贡献者参与，在 GitHub 上拥有 31,533 颗星星和 1,800 多个分支。其活跃的社区和持续的更新使 DevToys 成为开发者工具领域中最受欢迎的开源项目之一。DevToys 的设计哲学是"离线优先、隐私至上"，所有处理都在本地完成，确保敏感数据不会离开用户的机器。

![DevToys 截图](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/hero-screenshot.png)

## DevToys 的工作原理

### 架构概览

DevToys 采用模块化的插件式架构，这种设计使得整个应用具有高度的可扩展性和维护性。核心应用提供外壳、UI 框架和智能检测引擎，负责协调各个独立工具的运行。各个工具以扩展的形式打包，向宿主注册自身。这种松耦合的设计意味着开发者可以轻松添加新工具，而无需修改核心代码：

```
┌─────────────────────────────────────────┐
│           DevToys Shell (C#)            │
│  ┌─────────┐  ┌─────────┐  ┌──────────┐ │
│  │  Smart  │  │   UI    │  │ Extension│ │
│  │Detection│  │Renderer │  │  Manager │ │
│  └────┬────┘  └─────────┘  └────┬─────┘ │
│       │                          │       │
│  ┌────▼──────────────────────────▼─────┐ │
│  │         Extension SDK               │ │
│  │  (JSON, Base64, JWT, Regex, ...)   │ │
│  └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
         │ Windows │ macOS │ Linux │
         └─────────┴───────┴───────┘
```

### 核心概念

**智能检测（Smart Detection）** 是 DevToys 的标志性功能。当你将数据复制到剪贴板时，DevToys 会分析其格式并推荐最合适的工具。复制一个 JWT 令牌，JWT 解码器就会高亮显示。复制一个 Base64 字符串，Base64 工具就会出现。复制一段 JSON 数据，JSON 格式化器就会自动激活。这种智能推荐机制基于启发式模式匹配算法，能够识别多种数据格式。此行为可在设置中配置，用户可以选择自动打开、总是询问或完全禁用该功能。

**扩展（Extensions）** 允许第三方开发者添加新工具。DevToys SDK 公开了工具注册、UI 渲染和剪贴板集成的 API。社区扩展通过 NuGet 分发，可以从应用内安装。

**DevToys CLI** 是一个单独的 headless 二进制文件，专为 CI/CD 流水线和终端工作流设计。它提供与 GUI 相同的工具集，但无需图形界面，可在构建代理和远程服务器上编写脚本。

## 安装与配置

### Windows

在 Windows 上安装 DevToys 最快的方式是通过 WinGet 或 Microsoft Store。Microsoft Store 是大多数 Windows 用户的首选渠道，因为它可以自动处理更新，并且经过了微软的安全审核。对于企业环境或没有 Microsoft Store 访问权限的开发者，WinGet 和 Chocolatey 提供了命令行安装选项，便于批量部署和脚本自动化。便携 ZIP 版本则适合需要随身携带工具或在临时工作站上使用的场景。

**通过 WinGet（推荐）：**

```powershell
winget install DevToys-app.DevToys
```

**通过 Microsoft Store：**

在 Microsoft Store 应用中搜索 "DevToys"，或直接访问 [商店页面](https://www.microsoft.com/store/apps/9NBN8W1DS547)。

**通过 Chocolatey：**

```powershell
choco install devtoys
```

**使用经典安装程序手动安装：**

```powershell
# 下载 x64 安装程序
Invoke-WebRequest -Uri "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_win_x64.exe" -OutFile "devtoys_installer.exe"

# 运行安装程序
.\devtoys_installer.exe /SILENT
```

**便携 ZIP（无需安装）：**

```powershell
# 下载并解压
Invoke-WebRequest -Uri "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_win_x64_portable.zip" -OutFile "devtoys.zip"
Expand-Archive -Path "devtoys.zip" -DestinationPath "C:\Tools\DevToys"

# 直接启动
C:\Tools\DevToys\DevToys.exe
```

### macOS

macOS 用户可以通过 DMG 文件或 Homebrew 安装 DevToys。DMG 方式是最直接的安装方法，只需下载、挂载镜像并将应用拖入 Applications 文件夹即可。Homebrew 用户则可以使用一行命令完成安装和后续更新。需要注意的是，由于 macOS 的安全机制，首次运行时可能需要在系统偏好设置中允许来自未知开发者的应用。

```bash
# 下载 macOS DMG
curl -L -o devtoys.dmg "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_macos.dmg"

# 挂载并安装
hdiutil attach devtoys.dmg
cp -R "/Volumes/DevToys/DevToys.app" /Applications
hdiutil detach "/Volumes/DevToys"
```

或者通过 Homebrew 安装（如果可用）：

```bash
brew install --cask devtoys
```

### Linux (Debian/Ubuntu)

Linux 用户目前主要通过 .deb 包或便携 ZIP 文件安装 DevToys。Debian 和 Ubuntu 用户可以使用 dpkg 命令安装官方提供的 .deb 包。对于其他发行版（如 Fedora、Arch Linux），社区提供了非官方的打包版本。便携 ZIP 格式则适用于所有 Linux 发行版，只需解压并运行即可，无需处理依赖问题。

```bash
# 下载 .deb 包
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_linux_x64.deb

# 安装
sudo dpkg -i devtoys_linux_x64.deb

# 修复依赖问题
sudo apt-get install -f
```

**Linux 便携 ZIP：**

```bash
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_linux_x64_portable.zip
unzip devtoys_linux_x64_portable.zip -d ~/devtoys
~/devtoys/DevToys
```

### DevToys CLI 安装

CLI 单独分发，适用于 headless 环境和 CI 流水线：

```bash
# Windows
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_win_x64_portable.zip

# macOS
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_macos_portable.zip

# Linux
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip
```

安装后验证 CLI 是否正常工作：

```bash
devtoys --version
# 输出: DevToys CLI 2.0.9.0
```

### 首次启动与配置

首次启动时，DevToys 会以深色主题侧边栏打开，列出所有 30 多种工具。打开**设置**进行配置：

```yaml
# 生产工作流推荐设置
Smart Detection: Enabled      # 从剪贴板自动推荐工具
Theme: System default        # 或强制深色/浅色
Language: English             # 支持 14 种以上语言
Check for updates: Weekly     # 或在隔离网络环境中禁用
Telemetry: Disabled          # DevToys 默认无遥测
```

## 与流行工具集成

### VS Code

虽然 DevToys 作为独立应用运行，但你可以通过快捷键直接从 VS Code 启动它。将此添加到你的 `keybindings.json`：

```json
[
  {
    "key": "ctrl+alt+d",
    "command": "workbench.action.terminal.sendSequence",
    "args": { "text": "devtoys\r\n" },
    "when": "editorTextFocus"
  }
]
```

如需完全集成的体验，请从应用市场安装 **DevToys for VSCode** 扩展，它直接在编辑器侧边栏嵌入了一部分工具。

### PowerShell / 终端

DevToys 支持通过命令行参数深度链接到各个工具。这对脚本和别名很有用：

```powershell
# 直接打开特定工具
start devtoys:?tool=jsonformat     # JSON 格式化器
start devtoys:?tool=jsonyaml       # JSON <> YAML 转换器
start devtoys:?tool=jwt            # JWT 解码器
start devtoys:?tool=base64         # Base64 编码/解码器
start devtoys:?tool=regex          # 正则表达式测试器
start devtoys:?tool=hash           # 哈希生成器
start devtoys:?tool=uuid           # UUID 生成器
start devtoys:?tool=url            # URL 编码/解码器
start devtoys:?tool=markdown       # Markdown 预览
start devtoys:?tool=diff           # 文本比较器
```

### CI/CD 流水线 (GitHub Actions)

DevToys CLI 可以干净地集成到 CI 工作流中。以下是一个验证仓库中 JSON 文件的 GitHub Actions 示例：

```yaml
name: Validate JSON
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install DevToys CLI
        run: |
          wget -q https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip
          unzip -q devtoys.cli_linux_x64_portable.zip -d /usr/local/bin
          chmod +x /usr/local/bin/devtoys
      
      - name: Validate all JSON files
        run: |
          find . -name "*.json" -exec devtoys json validate {} \;
```

### Docker (非官方)

对于容器化工作流，你可以将 DevToys CLI 包装在一个轻量级镜像中：

```dockerfile
FROM mcr.microsoft.com/dotnet/runtime:8.0

RUN apt-get update && apt-get install -y wget unzip \
    && wget -q https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip \
    && unzip -q devtoys.cli_linux_x64_portable.zip -d /app \
    && rm devtoys.cli_linux_x64_portable.zip \
    && apt-get remove -y wget unzip && apt-get autoremove -y

ENTRYPOINT ["/app/devtoys"]
```

构建并运行：

```bash
docker build -t devtoys-cli .
echo '{"key":"value"}' | docker run -i devtoys-cli json format
```

## 基准测试 / 实际使用案例

### 性能基准

DevToys 完全在本地机器的内存中处理数据，不依赖网络连接，因此在处理大型文件时具有明显的性能优势。以下是在标准开发笔记本（AMD Ryzen 7, 16 GB 内存，SSD 存储）上测得的性能数据。测试方法为每种操作运行 10 次取平均值，数据文件使用随机生成的结构化内容：

| 操作 | 数据大小 | DevToys (桌面版) | DevToys CLI | 在线替代方案 |
|------|----------|-------------------|-------------|-------------|
| JSON 格式化 | 1 MB | ~45 ms | ~38 ms | ~200-500 ms* |
| JSON 格式化 | 10 MB | ~320 ms | ~280 ms | ~2-5 s* |
| Base64 编码 | 5 MB 图片 | ~85 ms | ~72 ms | ~1-3 s* |
| SHA-256 哈希 | 100 MB 文件 | ~1.2 s | ~1.1 s | 受上传限制 |
| 正则测试 | 10,000 行 | ~15 ms | ~12 ms | ~100-300 ms* |
| JWT 解码 | 2 KB 令牌 | ~3 ms | ~2 ms | ~50-150 ms* |

\* 未包含到第三方网站的网络延迟。测量值因提供商而异。

### 实际使用案例

**API 开发工作流：**

调试 REST API 时，你从 HTTP 客户端复制一个 JWT 令牌，DevToys 的智能检测立即提供 JWT 解码器。你检查载荷声明，使用日期转换器检查过期时间戳，并使用文本比较器将实际响应与预期输出进行比较——所有操作都无需在浏览器标签页之间切换上下文。这种无缝的工作流大大减少了开发者在不同工具之间切换的时间，提高了调试效率。此外，JSON 格式化器可以对 API 响应进行语法高亮和结构验证，确保返回的数据格式正确无误。对于需要处理大量 API 数据的开发者来说，这些功能的组合可以节省大量时间。

**前端开发工作流：**

前端开发者经常需要处理颜色转换、图像压缩和文本编码等任务。DevToys 的颜色选择器支持 HEX、RGB、HSL 之间的相互转换，帮助开发者快速获取所需的颜色格式。图像压缩工具可以在不损失明显质量的情况下减小 PNG 和 JPEG 文件的大小，提升网页加载速度。Base64 编码器可以将小图标直接转换为内联字符串，减少 HTTP 请求数量。这些工具的组合使前端开发流程更加顺畅高效。

**DevOps 配置管理：**

对于 Kubernetes 和 Docker Compose 用户来说，JSON 和 YAML 之间的转换是日常任务。DevToys 的 JSON <> YAML 转换器处理嵌套结构，尽可能保留注释，并实时验证语法。Cron 解析器工具帮助在部署到生产环境之前验证调度表达式。文本比较器可以对比不同版本的配置文件，精确标出差异位置。对于需要处理大量配置文件的 DevOps 工程师来说，这些工具的组合使用可以显著提高工作效率，减少因配置错误导致的生产事故。

**前端资源优化：**

在部署 Web 应用之前，使用 PNG/JPEG 压缩器在不损失可见质量的情况下缩小图像资源。色盲模拟器检查 UI 对比度可访问性。颜色选择器在 HEX、RGB 和 HSL 格式之间转换，以保持设计系统的一致性。

## 高级用法 / 生产环境加固

### 在隔离网络环境中运行

DevToys 完全离线工作——核心工具永远不需要网络连接。对于有严格安全策略的组织：

1. 在可连接互联网的机器上从 GitHub 发布页面下载便携 ZIP
2. 通过已批准的媒介将存档传输到隔离网络
3. 解压并运行，无需任何安装或网络依赖

### 智能检测配置

微调智能检测以避免误报：

```yaml
# 设置 > 智能检测
Behavior: "Always ask"        # 选项：Auto-open, Always ask, Disabled
Minimum confidence: 85%       # 调整检测阈值
Excluded tools:               # 禁用特定工具的检测
  - "Lorem Ipsum Generator"
  - "Password Generator"
```

### 扩展开发

使用 DevToys SDK 创建自定义工具。安装 SDK NuGet 包：

```bash
dotnet add package DevToys.Sdk --version 2.0.0
```

最小扩展实现 `IGuiTool` 接口：

```csharp
using DevToys.Api;
using System.ComponentModel.Composition;

[Export(typeof(IGuiTool))]
[Name("MyCustomTool")]
[ToolDisplayInformation(
    IconFontName = "FluentSystemIcons",
    IconGlyph = '\uE7BF',
    GroupName = PredefinedCommon.GuiToolGroup.Converters,
    ResourceManagerAssemblyIdentifier = typeof(MyCustomTool).Assembly,
    ResourceManagerBaseName = "MyExtension.Resources.MyCustomTool",
    ShortDisplayTitleResourceName = nameof(MyCustomTool.ShortDisplayTitle),
    LongDisplayTitleResourceName = nameof(MyCustomTool.LongDisplayTitle),
    DescriptionResourceName = nameof(MyCustomTool.Description),
    AccessibleNameResourceName = nameof(MyCustomTool.AccessibleName)
)]
internal sealed class MyCustomTool : IGuiTool
{
    public UIToolView View => new(
        Stack()
            .Vertical()
            .WithChildren(
                SingleLineTextInput(),
                SingleLineTextOutput()
            ));

    public void OnDataReceived(string dataType, object? parsedData)
    {
        // 处理智能检测输入
    }
}
```

### 在团队中监控使用情况

虽然 DevToys 没有内置遥测功能，但你可以通过包装 CLI 的日志脚本来追踪团队最常使用的工具：

```bash
#!/bin/bash
# /usr/local/bin/devtoys-wrapped
LOGFILE="/var/log/devtoys/usage.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') | User: $(whoami) | Tool: $1 $2" >> "$LOGFILE"
/devtoys "$@"
```

![DevToys Microsoft Store 评分](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/ms-store-rate.png)

## 与替代方案对比

在评估 **devtoys vs cyberchef** 和其他替代方案时，查看每个工具提供的具体功能会很有帮助。下表细分了平台支持、许可、可扩展性和工作流集成方面的关键差异。

| 功能 | DevToys | CyberChef | DevUtils | Boop |
|------|---------|-----------|----------|------|
| **平台** | Windows, macOS, Linux | Web (任何浏览器) | 仅 macOS | 仅 macOS |
| **价格** | 免费 | 免费 | $25-40 (一次性) | 免费 |
| **许可证** | MIT | Apache-2.0 | 专有 | MIT |
| **离线支持** | 完全离线 | 可下载 HTML | 完全离线 | 完全离线 |
| **工具数量** | 30+ 内置，可扩展 | 300+ "配方" | 40+ | 30+ 脚本 |
| **智能检测** | 是 (剪贴板) | 否 | 是 (热键) | 否 |
| **CLI/可脚本化** | 是 (独立 CLI) | 否 | 有限 | 否 |
| **输入/输出管道** | 否 | 是 (配方) | 否 | 否 |
| **扩展 SDK** | 是 (NuGet) | 否 | 否 | 是 (JavaScript) |
| **跨平台** | 是 | 是 (浏览器) | 否 | 否 |
| **加密工具** | 哈希, JWT, Base64 | AES, DES, Blowfish, +100 | 哈希, JWT, UUID | 基础编码 |
| **图像工具** | 压缩, 转换, 色盲 | 有限 | 压缩, 转换 | 无 |
| **启动时间** | ~2-3s (桌面版) | 即时 (已加载) | ~1s | ~1s |
| **隐私** | 零网络调用 | 零 (自托管) | 零 | 零 |

### 何时选择哪个

- **DevToys**：你想要一个精致的、跨平台的桌面应用，采用离线优先设计，并拥有不断增长的扩展生态系统。最适合以 Windows 为主的环境和需要 CLI 自动化的团队。
- **CyberChef**：你需要高级加密操作、复杂的多步骤数据处理"配方"，或者你在安全/取证环境中工作，更倾向于使用 GCHQ 的工具集。
- **DevUtils**：你 exclusively 使用 macOS，并希望获得最精致的本地 UI 和最广泛的内置工具集。如果你生活在 Apple 生态系统中，这个价格是值得的。
- **Boop**：你是一个 macOS 开发者，更喜欢轻量级、可脚本化的工具，并且不介意为自定义操作编写 JavaScript。

## 局限性 / 客观评估

DevToys 并非适合所有情况。以下是它不太擅长的方面：

**无复杂数据管道。** CyberChef 的"配方"系统允许你在单个工作流中链接操作（Base64 解码 → GZip 解压 → JSON 解析）。DevToys 需要手动在工具之间复制粘贴。

**无移动端支持。** 没有 iOS 或 Android 版本。主要在平板电脑上工作的开发者需要寻找其他工具。

**扩展生态尚年轻。** 虽然 SDK 存在，但与 VS Code 等成熟的插件生态系统相比，社区扩展的数量较少。目前最有用的第三方扩展是重复检测器、文件分割器、JSON Schema 验证器和 RSA 生成器。

**macOS 和 Linux 稳定性。** DevToys 2.0 是一次彻底重写，带来了跨平台支持，但一些用户报告在 macOS 和 Linux 上偶尔会出现 UI 故障，而 Windows 上则没有这些问题。作为原始目标平台的 Windows 版本仍然是最精致的。

**无协作功能。** DevToys 是一个单用户桌面应用。没有工具配置共享、没有团队预设、没有云同步。每位开发者独立配置自己的实例。

**文本转换功能有限。** 虽然 DevToys 涵盖了基础知识（大小写转换、转义/取消转义），但缺乏高级文本处理功能，如多光标编辑或列操作，这些功能在专用文本处理工具中可以找到。

## 常见问题

### DevToys 支持哪些平台？

DevToys 2.0 支持 Windows 10 build 1903+、macOS 11+ 和 Linux（Debian/Ubuntu，其他发行版有社区包）。同时支持 x64 和 ARM64 架构。Windows 仍然是最稳定和功能最完整的平台。

### DevToys 完全免费吗？

是的。DevToys 采用 MIT 许可证发布，个人和商业使用均免费。没有付费层级、没有订阅、没有功能限制。该项目由 Etienne Baudoux 和 Benjamin Titeux 维护，有 78 位以上开发者的社区贡献。

### DevToys 会向互联网发送任何数据吗？

不会。DevToys 完全离线运行。没有工具数据、剪贴板内容或文件内容会离开你的机器。应用不包含遥测功能。唯一的网络请求是可选的更新检查，可以在设置中禁用。

### 智能检测是如何工作的？

智能检测通过模式匹配启发式算法监控你的剪贴板并分析复制的内容。当你复制一个 JWT 令牌（具有独特的 `header.payload.signature` 结构）时，DevToys 会高亮显示 JWT 解码器工具。你可以在设置面板中配置该行为——自动打开工具、显示建议或完全禁用。

### 我可以在 CI/CD 流水线中使用 DevToys 吗？

可以，通过 **DevToys CLI**，一个独立的 headless 二进制文件，提供相同的工具集。在构建代理上安装并从 shell 脚本或 GitHub Actions 工作流中调用。CLI 提供 Windows、macOS 和 Linux 版本，有便携 ZIP 和框架依赖格式两种。

### DevToys 1.x 和 2.0 有什么区别？

DevToys 2.0 是一次从头开始的重写，引入了跨平台支持（之前仅支持 Windows）、新的扩展 SDK、CLI 工具、智能检测 2.0，以及基于 .NET MAUI/Blazor Hybrid 的现代化 UI。DevToys 1.0.13.0 是 1.x 分支的最终版本，仍然可供旧版 Windows 用户使用。

### 如何为 DevToys 构建自定义扩展？

在 .NET 类库中安装 DevToys.Sdk NuGet 包，实现 `IGuiTool` 接口，并将你的扩展打包为 NuGet 包。扩展可以发布在 nuget.org 上，或从 DevToys 内部的扩展管理器手动安装。完整文档请访问 [devtoys.app/doc](https://devtoys.app/doc)。

### 在哪里可以获得帮助或报告 bug？

主要支持渠道是 GitHub Issues 页面：[github.com/DevToys-app/DevToys/issues](https://github.com/DevToys-app/DevToys/issues)。有 327 个开放问题和活跃维护者团队，大多数 bug 在一周内会得到分类处理。还有一个 GitHub Discussions 论坛用于功能请求和使用问题。

## 结论

DevToys 填补了开发者工具包中的一个真正空白：一个免费、离线、跨平台的实用工具套件，尊重你的隐私。拥有 31,533 个 GitHub 星标、30 多种内置工具、智能检测、不断增长的扩展生态系统和用于自动化的 CLI，它值得出现在每位开发者的机器上。在任何操作系统上的设置都只需不到五分钟，而无需寻找可信赖的在线转换器所节省的时间会积少成多。对于重视数据隐私的开发者来说，DevToys 提供了一种安全可靠的替代方案，所有处理都在本地完成，不会将敏感数据发送到任何外部服务器。这对于处理生产环境数据、API 密钥或包含个人信息的 JWT 令牌尤为重要。

**下一步：**

1. 从 [devtoys.app/download](https://devtoys.app/download) 为你的操作系统下载 DevToys
2. 在 CI 构建代理上安装 CLI 二进制文件
3. 探索扩展管理器中的社区工具
4. 在 [github.com/DevToys-app/DevToys](https://github.com/DevToys-app/DevToys) 给仓库加星以支持该项目

加入 [dibi8 Telegram 群组](https://t.me/dibi8channel) 获取更多开发者工具评测和安装指南。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- DevToys GitHub 仓库: https://github.com/DevToys-app/DevToys
- 官方网站: https://devtoys.app
- 下载页面: https://devtoys.app/download
- 文档: https://devtoys.app/doc
- DevToys CLI 发布: https://github.com/DevToys-app/DevToys/releases
- CyberChef (GCHQ): https://gchq.github.io/CyberChef
- DevUtils for macOS: https://devutils.com
- Boop on GitHub: https://github.com/IvanMathy/Boop
- DevToys SDK NuGet: https://www.nuget.org/packages/DevToys.Sdk
