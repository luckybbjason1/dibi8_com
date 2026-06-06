---
title: Scanners-Box：200+ 网络安全工具合集 — 安全从业人员必备
description: 探索 Scanners-Box — 200+ 开源网络安全工具合集，涵盖渗透测试、漏洞扫描、安全研究等领域。
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Go
- JavaScript
- Python
- Rust
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "236 KB"
file_md5: ''
download_url: https://github.com/luckybbjason1/Scanners-Box
backup_url: ''
github_repo: https://github.com/luckybbjason1/Scanners-Box
stars: 0
maintainer: "luckybbjason1"
last_maintained: "2023-09-21"
featureImage: ''
draft: false
aliases:
- /zh/posts/scanners-box-cybersecurity-tools-collection/
faqs:
  - q: '什么是 Scanners-Box?'
    a: 'Scanners-Box 是一个精选的开源网络安全工具集合，收录了 200+ 款工具，覆盖 15+ 个类别，涵盖子域名枚举、SQL 注入、模糊测试、端口扫描、社会工程等多个方面。它最初是为中国安全社区（t00ls）打造的，主要面向渗透测试人员和安全研究人员。'
  - q: 'Scanners-Box 推荐哪些工具用于 SQL 注入测试?'
    a: '它首推 sqlmap，能够自动检测并利用 SQL 注入，支持 6 种数据库类型，并内置用于绕过 WAF 的 tamper 脚本。该集合还列出了 jsql-injection、SQLiScanner 和 NoSQLAttack。'
  - q: '在端口扫描方面，Nmap 和 masscan 有什么区别?'
    a: 'Nmap 是标准的网络扫描器，提供服务/版本检测和脚本功能（例如通过 --script=vuln 运行漏洞脚本），而 masscan 是最快的互联网端口扫描器，借助异步传输能在约 6 分钟内扫描整个互联网。masscan 兼容 Nmap，因此两者常常配合使用。'
  - q: 'Scanners-Box 包含哪些模糊测试工具?'
    a: '它列出了 20+ 款 fuzzer，包括 AFL（American Fuzzy Lop）、honggfuzz、syzkaller 和 libFuzzer。AFL 是覆盖率引导的，已在真实软件中发现了数千个 bug；而 syzkaller 是 Linux 内核 fuzzer，已发现 3000 多个内核 bug，被 Google 和 Microsoft 使用。'
  - q: '像 Scanners-Box 里这样的渗透测试工具，使用是否合法?'
    a: '这些工具仅在获得授权的安全测试中才合法；在没有明确书面许可的情况下对系统使用它们是违法且不道德的。相关法律包括美国《计算机欺诈和滥用法》（CFAA）、英国《计算机滥用法》、中国《网络安全法》以及欧盟 GDPR，因此在测试前务必取得书面授权并界定测试范围。'
---
{</* resource-info */>}

## Scanners-Box 是什么？

**Scanners-Box** 是一个精心整理的 **200+ 开源网络安全工具** 合集，面向安全从业人员、渗透测试人员和道德黑客。最初为中国安全社区（t00ls）创建，涵盖从侦察到利用的网络安全各个方面。

**GitHub**: https://github.com/luckybbjason1/Scanners-Box  
**协议**: 开源合集  
**工具数量**: 200+  
**分类**: 15+

---

## 工具分类概览

| 分类 | 工具数量 | 示例 |
|------|---------|------|
| **子域名枚举** | 15+ | subDomainsBrute, amass, subfinder, OneForAll |
| **数据库 & SQL注入** | 10+ | sqlmap, jsql-injection, SQLiScanner, NoSQLAttack |
| **模糊测试工具** | 20+ | AFL, honggfuzz, syzkaller, libFuzzer |
| **端口扫描 & 指纹识别** | 25+ | Nmap, masscan, whatweb, wafw00f |
| **弱口令 & 信息泄露** | 15+ | htpwdScan, BBScan, GitHack, truffleHog |
| **IoT设备扫描** | 5+ | IoTSeeker, RouterSploit, routersploit |
| **XSS利用** | 10+ | BruteXSS, XSS-Radar, XSSTracer, easyXssPayload |
| **社会工程学** | 15+ | SET, gophish, evilginx2, blackeye |
| **WebShell检测** | 10+ | findWebshell, HaboMalHunter, PHP-Shell-Detector |
| **企业网络审计** | 5+ | theHarvester, xunfeng, LNScan |
| **漏洞扫描器** | 15+ | vulfocus, vulhub, VulApps, upload-labs |
| **无线安全** | 5+ | fern-wifi-cracker, aircrack-ng |
| **资产发现** | 5+ | linglong, H, nemo_go, NextScan |
| **威胁情报** | 3+ | threat-intelligence, VirusTotal, ThreatBook |
| **学习资源** | 20+ | sec-wiki, FreeBuf, Web Hacking 101 |

---

## 精选工具深度解析

### 1. 子域名枚举

**OneForAll** — 最全面的子域名收集工具
- 集成 20+ 数据源
- 支持 API 密钥获取更好结果
- 导出多种格式

**amass** — Go 语言子域名枚举
- 快速高效
- DNS、爬取和证书透明度
- 图形可视化输出

### 2. SQL 注入

**sqlmap** — SQL 注入工具之王
- 自动检测和利用
- 支持 6 种数据库类型
- 篡改脚本绕过 WAF

```bash
# 基本用法
sqlmap -u "http://target.com/page.php?id=1" --dbs

# 导出特定表
sqlmap -u "http://target.com/page.php?id=1" -D database -T users --dump
```

### 3. 模糊测试框架

**AFL (American Fuzzy Lop)** — 覆盖率引导模糊测试
- 自动发现漏洞
- 生成测试用例
- 在真实软件中发现 1000+ 漏洞

**syzkaller** — Linux 内核模糊测试器
- 发现 3000+ Linux 内核漏洞
- Google、Microsoft 使用
- 支持多种操作系统

### 4. 端口扫描

**Nmap** — 网络扫描器之王
```bash
# 基本扫描
nmap -sV -sC target.com

# 全端口扫描带脚本
nmap -p- -sV --script=vuln target.com

# 激进扫描
nmap -A target.com
```

**masscan** — 最快的互联网端口扫描器
- 6 分钟扫描整个互联网
- 兼容 Nmap
- 异步传输

### 5. 社会工程学工具包

**SET (Social-Engineer Toolkit)** — 完整钓鱼框架
- 网站克隆
- 邮件鱼叉式钓鱼
- 凭证收集
- 多攻击向量

**evilginx2** — 绕过 2FA 钓鱼框架
- 中间人攻击
- 会话 Cookie 捕获
- 绕过双因素认证

---

## 安全学习资源

### 入门
- **sec-wiki** — 安全维基百科
- **FreeBuf** — 黑客与极客新闻
- **Web Hacking 101** — Web 安全基础
- **Kali Linux Web 渗透测试秘籍**

### 进阶
- **Burpsuite 实战指南** — Web 渗透测试
- **API-Security-Checklist** — API 安全最佳实践
- **Web-Security-Learning** — 综合 Web 安全
- **应急响应实战笔记** — 应急响应

### 高级主题
- **Linux 漏洞开发教程**
- **Android 渗透测试**
- **Node.js Web 安全问题**
- **Python 安全系列**

---

## 漏洞靶场练习

| 平台 | 描述 | 链接 |
|------|------|------|
| **vulfocus** | Docker 漏洞平台 | GitHub |
| **vulhub** | 预构建漏洞环境 | GitHub |
| **VulApps** | 漏洞应用合集 | GitHub |
| **upload-labs** | 文件上传漏洞练习 | GitHub |
| **bWAPP** | 有漏洞的 Web 应用 | SourceForge |
| **DVWA** | 该死的漏洞 Web 应用 | GitHub |
| **WebGoat** | OWASP Web 安全练习 | GitHub |

---

## 负责任的披露

> **⚠️ 警告**：此处列出的所有工具仅供授权安全测试使用。未经明确许可对系统使用这些工具是非法和不道德的。

### 法律框架
- **CFAA** (计算机欺诈和滥用法) — 美国
- **计算机滥用法** — 英国
- **网络安全法** — 中国
- **GDPR** — 欧盟数据保护

### 最佳实践
1. 始终获得书面授权
2. 明确界定范围
3. 尊重工作时间
4. 及时报告发现
5. 测试后销毁数据

---

## 工具选择指南

### Web 应用测试
```
侦察: amass, subfinder, theHarvester
扫描: Nmap, masscan, whatweb
漏洞: sqlmap, XSS 扫描器, dirsearch
利用: Burp Suite, 自定义脚本
报告: Dradis, Faraday
```

### 网络渗透测试
```
发现: Nmap, masscan, nbtscan
枚举: enum4linux, snmp-check
漏洞: OpenVAS, Nessus
利用: Metasploit, Cobalt Strike
后渗透: PowerShell Empire, Mimikatz
```

### 红队行动
```
初始访问: SET, gophish, evilginx2
持久化: 自定义植入, 计划任务
权限提升: PowerUp, BeRoot
横向移动: Pass-the-hash, Kerberoasting
数据渗出: DNS 隧道, HTTPS C2
```

---

## 相关文章

- [Agent Reach：AI 代理互联网访问](/zh/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — AI 驱动的安全自动化
- [Free Claude Code：开源 AI 编码](/zh/resources/ai-tools/free-claude-code-open-source-proxy/) — 安全编码实践

---

*免责声明：本文仅供教育目的。所有工具应负责任地使用，仅用于您拥有或获得明确许可测试的系统。作者和 dibi8.com 不对所提供信息的任何滥用负责。*

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "htstack" "category-footer" "HTStack" >}}** — 香港 VPS, dibi8.com 自己跑在这个 IDC。自托管 security scanner 独立 VPS, 亚洲低延迟覆盖, 无共享租户噪音。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

