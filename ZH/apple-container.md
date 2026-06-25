---


lang: zh
title: "Apple 的 Container：Mac 上拥有 37K Stars 的类 Docker 体验"
date: 2026-06-15
tags:
  - apple
  - container
  - macos
  - linux
  - virtualization
  - swift
slug: apple-container-mac-vm-tool-2026
description: "Apple 发布了 container，一款基于 Swift 的工具，可在 Mac 上使用轻量级虚拟机运行 Linux 容器。已获 37K stars，兼容 OCI，需要 macOS 26。"
image: ""
featureImage: /articles/ai-trading-stack.png/images/articles/ai-trading-stack.png
---
# Apple 的容器：Mac 上类似 Docker 的体验，拥有 37K Stars 当苹果于 2025 年 5 月 30 日发布“容器”时，开发者社区陷入了安静。 没有大张旗鼓，没有主题演讲——只是一个 GitHub 存储库，悄悄积累了 **37,130 颗星**，并成为多年来最受关注的 Apple 新开源项目。 这不是 Mac 版 Docker。 这是完全不同的事情。 `container` 是一个 **Swift 构建的工具**，它在 Mac 上将 Linux 容器作为 **轻量级虚拟机** 运行。 它使用 macOS 虚拟化框架，并与 macOS 系统组件（vmnet、XPC、Launchd、Keychain）深度集成。 它生成并使用 **OCI 兼容的映像**，这意味着您的 Docker 映像可以在这里工作，并且使用“容器”构建的映像可以在 Docker 中工作。 但该架构与 Docker Desktop、Colima 或 OrbStack 有着根本的不同。 让我们探讨一下为什么开发人员已经将其称为“Mac 上容器化的未来”。 ## 为什么苹果要打造这个 Apple 一直在 Mac 上的容器化问题上苦苦挣扎。 Mac 本身并不运行 Linux，因此运行 Linux 容器始终需要 Linux 虚拟机，而该虚拟机始终很重。 Mac 版 Docker Desktop 在底层使用了完整的 Ubuntu 虚拟机。 科利马缩小了尺寸。 OrbStack 让它变得很快。 但它们都没有改变基本架构。 “容器”采用不同的方法：**每个容器一个轻量级虚拟机**。 这意味着每个容器都可以获得完全的虚拟机级别隔离，而无需共享虚拟机的开销。 不再有容器到容器的通信问题，不再出现共享内核漏洞，也不再存在来自共享虚拟机管理程序的“容器逃逸”风险。 ### 核心架构 `container` 不在共享 Linux VM 内运行容器。 相反，它使用 Apple 的 **虚拟化框架** 为每个容器创建专用的轻量级 VM。 这在实践中意味着什么： - **安全性**：每个容器都具有完整虚拟机的隔离属性
 - **隐私**：您可以选择性地将必要的数据装载到每个虚拟机中
 - **性能**：启动时间与 Docker 容器相当，但具有虚拟机级别的隔离 该工具使用并生成 [OCI 兼容的容器映像](https://github.com/opencontainers/image-spec)，因此您可以从任何标准容器注册表（Docker Hub、GitHub 容器注册表、Google 容器注册表等）提取并运行映像。 ## 安装和设置 ＃＃＃ 要求 您需要一台配备 Apple Silicon (M1/M2/M3/M4) 和 **macOS 26**（或有限制的 macOS 15）的 Mac。 这是一个硬性要求，因为“容器”使用了 macOS 26 虚拟化和网络框架中的新功能。 ````bash
 # 从 GitHub 版本下载最新的安装程序
 # https://github.com/apple/container/releases # 安装签名的安装包
 # 双击并按照说明进行操作 # 启动系统服务
 容器系统启动
 ```` 安装将文件放置在“/usr/local”下，并将“container”注册为由 Launchd 管理的系统服务。 ### 从源安装 对于想要从源代码构建的开发人员： ````bash
 # 克隆存储库
 git 克隆 https://github.com/apple/container.git
 CD容器 # 按照 BUILDING.md 说明进行操作
 快速构建-c发布
 快速测试
 ```` 该项目使用 Swift Package Manager，并依赖 [Containerization](https://github.com/apple/containerization) Swift 包进行低级容器、镜像和流程管理。 ## 核心特性 ### 1. 运行容器 基本命令与Docker类似： ````bash
 # 拉取并运行容器
 容器运行 --rm docker.io/python:alpine python --version # 使用自定义内存和 CPU 限制运行
 容器运行 --rm --cpus 8 --内存 32g 大 # 交互式外壳
 容器运行-it --rm docker.io/ubuntu bash
 ```` 每个容器都在自己的轻量级虚拟机中运行。 默认分配是 1GB RAM 和 4 个 CPU，但您可以使用 `--memory` 和 `--cpus` 覆盖它。 ### 2. 建立形象 构建镜像使用您已经知道的相同 Dockerfile 语法： ````bash
 # 构建本地镜像
 容器构建 --tag myapp:latest --file Dockerfile 。 # 为多种架构构建
 容器构建--arch arm64 --arch amd64 \ --标签registry.example.com/fido/web-test:最新\ --file Dockerfile 。 # 尝试使用特定架构运行
 容器运行--arch arm64 --rm \ registry.example.com/fido/web-test uname -a
 ```` 输出显示了虚拟机的内核信息： ````
 Linux 7932ce5f-ec10-4fbe-a2dc-f29129a86b64 6.1.68 #1 SMP 3 月 31 日星期一 18:27:51 UTC 2025 aarch64 GNU/Linux
 ```` ### 3. 多平台构建 最强大的功能之一是跨平台图像构建。 您可以创建在 Apple Silicon Mac 和 x86-64 服务器上运行的单个映像： ````bash
 # 构建多平台镜像
 容器构建--arch arm64 --arch amd64 \ --tag myapp:最新的。 # 推送到注册表
 容器推送 myapp：最新
 ```` 生成的映像可在 Docker、Containerd 和任何 OCI 兼容的运行时中运行。 ### 4. 卷管理 使用 `--volume` 或 `--mount` 与容器共享主机文件： ````bash
 # 使用 --volume 挂载文件夹
 容器运行 --volume ${HOME}/Desktop/assets:/content/assets \ docker.io/python:alpine ls -l /content/assets # 使用 --mount 挂载（key=value 语法）
 容器运行 --mount source=${HOME}/Desktop/assets,target=/content/assets \ docker.io/python:alpine ls -l /content/assets
 ```` 与 Docker 的主要区别在于：您只将需要的数据装载到每个虚拟机中，而不是虚拟机可能需要的所有数据。 ### 5. 建造商管理 对于资源密集型构建，您可以自定义构建器 VM： ````bash
 # 使用自定义资源启动构建器
 容器构建器启动 --cpus 8 --内存 32g # 如果需要停止并重新启动
 容器制造商停止
 容器构建器删除
 容器构建器启动 --cpus 8 --内存 32g
 ```` 默认情况下，构建器 VM 具有 2GB RAM 和 2 个 CPU — 对于简单项目来说足够了，但对于繁重的构建来说不够。 ## 高级功能 ### 容器网络 `container` 与 macOS 的 `vmnet` 框架集成以实现虚拟网络： ````bash
 # 列出网络
 容器网络LS # 创建自定义网络
 容器网络创建mynet # 在特定网络上运行容器
 容器运行--network mynet myapp
 ```` 通过虚拟网络的容器到容器通信可在 macOS 26 上运行。 在 macOS 15 上，容器默认是相互隔离的。 ### 系统服务 将容器作为持久服务运行： ````bash
 # 启动系统服务
 容器系统启动 # 停止系统服务
 容器系统停止 # 检查状态
 容器系统状态
 ```` `container-apiserver` 作为 Launchd 代理运行，并通过 XPC 帮助程序管理容器和网络资源。 ### 升级和降级 ````bash
 # 升级到最新
 /usr/local/bin/update-container.sh # 降级到特定版本
 容器系统停止
 /usr/local/bin/uninstall-container.sh -k
 /usr/local/bin/update-container.sh -v 0.3.0
 容器系统启动
 ```` ### 卸载 ````bash
 # Remove without data
 /usr/local/bin/uninstall-container.sh -k # 通过数据擦除删除
 /usr/local/bin/uninstall-container.sh -d
 ```` ## 与替代方案的比较 让我们将“容器”与替代方案进行比较： | 特色 | 苹果容器| Docker 桌面 | 科利马州 | OrbStack |
 |