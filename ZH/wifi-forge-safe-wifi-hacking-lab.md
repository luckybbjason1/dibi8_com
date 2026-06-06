---
title: "WiFi-Forge — 一个安全合法的 WiFi 黑客学习沙盒"
description: "WiFi Forge：安全的WiFi黑客实验室，用于安全研究。在受控环境中学习渗透测试、无线安全和道德黑客技术。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "16.4 MB"
file_md5: ""
download_url: "https://github.com/her3ticAVI/MiniNet-framework"
backup_url: ""
github_repo: "https://github.com/her3ticAVI/MiniNet-framework"
stars: 813
maintainer: "blackhillsinfosec"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /zh/posts/wifi-forge-safe-wifi-hacking-lab/
faqs:
  - q: 'WiFi-Forge 是什么？'
    a: 'WiFi-Forge 是 Black Hills InfoSec 推出的开源项目，提供一个安全合法的沙盒环境，供你练习无线攻击技术。它在你的笔记本上运行一个虚拟实验室，无需购买任何硬件，也不存在接触他人网络的风险。'
  - q: '使用 WiFi-Forge 学习 WiFi 攻击，我需要专用 WiFi 网卡吗？'
    a: '不需要。WiFi-Forge 通过软件模拟接入点、站点和无线信道，完全省去了对支持 monitor mode 的 USB 网卡的需求。只有当你想学习物理射频层时才需要真实网卡，而该模拟环境并不涵盖这部分内容。'
  - q: 'WiFi-Forge 基于什么技术构建？'
    a: 'WiFi-Forge 基于 mininet-wifi 构建，后者是一款 802.11 网络模拟器，能在 Linux 网络命名空间内创建虚拟接入点和客户端。每个 AP 和客户端都是真实的 Linux 进程，因此 airodump-ng、tcpdump、Reaver、Hashcat 等工具的行为就如同在操作真实的无线流量。'
  - q: '在 WiFi-Forge 中可以练习哪些 WiFi 攻击？'
    a: '内置实验涵盖：WPA/WPA2 握手包捕获、WPS 攻击（Reaver PIN 爆破和 Pixie-Dust）、evil-twin/Karma 流氓 AP、去认证洪泛、Beacon 洪泛、MAC 地址随机化分析，以及 PMKID 攻击。每个实验会启动一个特定的网络拓扑，并提供一个类 CTF 的小目标。'
  - q: '安装和运行 WiFi-Forge 需要什么？'
    a: '你需要 Linux（Ubuntu 或 Debian 最佳）、Python 3 以及 root 权限，因为 mininet-wifi 依赖内核特性。克隆仓库后，运行 sudo ./install.sh 安装依赖，再运行 sudo python3 wififorge.py 启动。'
---
{</* resource-info */>}

如果你尝试过用传统方式学 WiFi 攻击,流程通常是这样:订一块支持 monitor 模式和包注入的 USB 无线网卡,跟 Linux 驱动斗一晚上,搭一个自己拥有的测试热点,*然后*才开始练你真正想学的攻击。**WiFi-Forge** 把这一整套准备工作直接跳过。

![WiFi-Forge 横幅](https://github.com/her3ticAVI/MiniNet-framework/raw/main/images/WifiForgeVersion2.png)

[WiFi-Forge](https://github.com/blackhillsinfosec/WifiForge) 是 [Black Hills InfoSec](https://www.blackhillsinfosec.com/) Open Source的项目,提供一个**安全合法**的环境给你练习无线攻击。不需要硬件,不会误伤别人的网络,也不会把驱动搞坏。开一个虚拟实验室,你就可以开始动手。

## 为什么需要它 —— WiFi 学习的三个坑

传统 WiFi 实战教学有三件事最劝退人:

1. **硬件不可控。** 不是每张 USB 网卡都干净支持 monitor + injection。靠谱的几款(Alfa AWUS036、Panda PAU09 等)要 30~60 美金,而且一次只能用一张。
2. **法律灰区。** 在大多数国家,接触任何不属于你的网络 —— 哪怕只是被动监听 —— 都是违法行为。"我只是嗅探一下" 不是抗辩理由。
3. **环境难复位。** 真实硬件不能一键回退。搞砸了的配置没办法 `git checkout` 回去。

WiFi-Forge 把这三个问题全部合并到笔记本上的一个沙盒里。

## 底层是什么

WiFi-Forge 建在 [mininet-wifi](https://github.com/intrig-unicamp/mininet-wifi) 之上 —— 一个 802.11 网络模拟器,在 Linux 网络命名空间里创建虚拟接入点、客户端和"无线电波"。每个 AP 和客户端都是真实的 Linux 进程,你可以用 `iwconfig`、`airodump-ng`、`tcpdump`,甚至 Reaver、Hashcat 直接打模拟流量,所有标准工具的行为跟在真实电波上完全一样。

WiFi-Forge 在这个基础上加了:预设好的拓扑、开箱即用的攻击场景、以及一套引导式结构,让你不用每次想练点东西都先去设计一个网络。

## 你能练什么

![WiFi-Forge 运行截图](https://github.com/her3ticAVI/MiniNet-framework/raw/main/images/wififorge-running.png)

自带的实验室覆盖了常见的 WiFi 攻击类别:

- **WPA/WPA2 握手包抓取** —— deauth 一个客户端,抓 4 路握手,用 hashcat 或 aircrack-ng 离线爆破
- **WPS 攻击** —— Reaver PIN 暴力破解、Pixie-Dust 攻击
- **Evil-twin / Karma** —— 起一个伪装目标 SSID 的钓鱼 AP,看客户端自动连过来
- **Deauth 洪泛** —— 把客户端从合法 AP 上踢下来
- **Beacon 洪泛** —— 喷上千个假 AP,把扫描工具搞崩
- **MAC 随机化分析** —— 看看现代设备怎么藏自己身份(以及它们在哪些地方会泄露)
- **PMKID 攻击** —— 不需要客户端连着也能抓握手

每个实验室会启动对应的拓扑,把你扔进 shell,给你一个小型 CTF 风格的目标。

## 怎么开始

```bash
git clone https://github.com/blackhillsinfosec/WifiForge
cd WifiForge
sudo ./install.sh
sudo python3 wififorge.py
```

需要 Linux 环境(Ubuntu/Debian 最稳)、Python 3、root 权限(mininet-wifi 要用内核功能)。安装脚本会自动处理依赖 —— mininet-wifi、aircrack-ng、hashcat、reaver 等。

## 适合谁用

![无线安全实验](https://www.bobology.com/members/images/249.jpg?cb=20250922025150)

- **OSCP / OSWP 备考者** —— 可以练跟考试实验室相似的场景,不用买硬件
- **CTF 出题人** —— 快速搭起无线挑战,不用配真实电台
- **安全讲师** —— 每个学生都有独立沙盒,几秒就能复位
- **好奇的开发者** —— 终于能用调试器一步步看清 4 路握手到底长什么样

> ⚠️ **WiFi-Forge 学不到什么:** 物理层 —— RF、天线选择、真实信号衰减。这部分早晚还是要真卡。但 90% 的实战攻击都发生在协议层 —— 这一层的模拟和真实流量完全无差。

## 关于合法性和职业操守

这种项目必须把话讲在前面:**这些技术只能对你自己拥有的网络、或者拿到书面授权许可的网络使用。** WiFi-Forge 之所以存在,**就是因为**有了模拟环境就没必要去"试一下"咖啡馆隔壁的 WiFi。安全地学习,这才是它的全部意义。

---

- **仓库:** [github.com/blackhillsinfosec/WifiForge](https://github.com/blackhillsinfosec/WifiForge)
- **底层:** [mininet-wifi](https://github.com/intrig-unicamp/mininet-wifi)
- **维护者:** [Black Hills InfoSec](https://www.blackhillsinfosec.com/)

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

