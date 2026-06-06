---
title: "Bitcoin-Classic (BTCC): 让普通人也能 CPU 挖矿的比特币复刻版"
description: "Bitcoin-Classic (BTCC) 是一个基于 Bitcoin Core v28.1 重建的去中心化数字货币，支持 CPU 挖矿，自带图形界面和内置矿机，让普通人也能体验早期比特币挖矿的乐趣。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - C++
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "14.8 MB"
file_md5: ""
download_url: "https://github.com/Marcus-Vane/Bitcoin-Classic"
backup_url: ""
github_repo: "https://github.com/Marcus-Vane/Bitcoin-Classic"
stars: 23
maintainer: "Marcus-Vane"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /zh/posts/bitcoin-classic-btcc-cpu-mining-bitcoin-fork/
faqs:
  - q: '普通 CPU 可以挖 Bitcoin-Classic（BTCC）吗？'
    a: '可以。BTCC 的设计初衷就是让普通家用电脑的 CPU 也能参与挖矿，无需 ASIC 矿机或专用 GPU。由于网络算力极低，普通 CPU 确实可以赚取区块奖励。'
  - q: 'Bitcoin-Classic（BTCC）的总供应量和区块奖励是多少？'
    a: 'BTCC 总供应量为 21,000,000 枚，与比特币完全相同。初始区块奖励为 50 BTCC，每 210,000 个区块（约 4 年）减半一次，出块时间为 10 分钟。'
  - q: 'Bitcoin-Classic 基于什么构建，使用何种共识机制？'
    a: 'Bitcoin-Classic 基于 Bitcoin Core v28.1 重新构建，使用 C++ 编写。它采用 SHA-256 工作量证明（Proof-of-Work）共识机制，遵循最长链规则，完全去中心化，无预挖。'
  - q: '如何开始挖 Bitcoin-Classic？'
    a: '从 GitHub releases 页面下载 Bitcoin-Classic-Setup.exe 并安装，首次启动时等待区块链同步完成，创建新钱包，然后点击「Start Mining」使用内置图形化矿工即可。无需命令行操作。'
  - q: 'Bitcoin-Classic（BTCC）是个好的投资标的吗？'
    a: '不是。BTCC 目前市值和流动性几乎为零，没有主流交易所支持，社区规模极小（GitHub 仅约 18-23 个 star）。它最适合作为教育和实验性项目，而非投资标的。'
---
{</* resource-info */>}

## Bitcoin-Classic 是什么？

**Bitcoin-Classic (BTCC)** 是一个基于 **Bitcoin Core v28.1** 重建的去中心化数字货币项目。它最大的特色是**降低了挖矿门槛** —— 你不需要昂贵的 ASIC 矿机，甚至不需要独立显卡，**普通家用电脑的 CPU 就能参与挖矿**。

**GitHub**: https://github.com/Marcus-Vane/Bitcoin-Classic
**Stars**: 18
**语言**: C++
**协议**: MIT
**官网/浏览器**: https://explorer.bitcoin-classic.net/

---

## 项目愿景：让每个人都能挖矿

> "今天几乎所有人都听说过比特币，但真正通过挖矿获得比特币的人却寥寥无几。"

Bitcoin-Classic 的核心理念是**还原早期比特币的挖矿体验**。在 2009-2010 年，任何人用家用电脑就能挖到比特币。但随着 ASIC 矿机的出现和专业矿场的崛起，个人挖矿早已无利可图。

BTCC 试图通过**降低难度、支持 CPU 挖矿、提供图形化界面**，让普通人重新体验挖矿的乐趣和成就感。

---

## 核心技术参数

### 共识机制

| 参数 | 说明 |
|------|------|
| **共识算法** | SHA-256 工作量证明 (PoW) |
| **挖矿方式** | CPU / GPU（低难度友好） |
| **安全模型** | 最长链规则 |
| **去中心化** | 完全去中心化，无预挖 |

### 区块与经济模型

| 参数 | 数值 |
|------|------|
| **总量** | 21,000,000 BTCC |
| **区块时间** | 10 分钟 / 区块 |
| **难度调整** | 每 2016 个区块（约 14 天） |
| **初始区块奖励** | 50 BTCC / 区块 |
| **最小单位** | 0.00000001 BTCC |
| **减半周期** | 每 210,000 个区块（约 4 年） |

### 减半时间表

| 区块高度 | 区块奖励 |
|---------|---------|
| 0 ~ 209,999 | 50 BTCC |
| 210,000 ~ 419,999 | 25 BTCC |
| 420,000 ~ 629,999 | 12.5 BTCC |
| ... | ... |

> 这与比特币的减半机制完全一致。

---

## 核心功能

### 1. 内置图形矿机
不需要命令行，不需要复杂配置。下载安装包后直接运行，点击"开始挖矿"即可。

### 2. CPU 友好
由于网络总算力较低，普通 CPU 也能有效参与挖矿并实际获得区块奖励。

### 3. 轻量级钱包
内置钱包功能，创建钱包后自动开始挖矿，余额实时显示。

### 4. 区块链浏览器
官方提供在线浏览器 https://explorer.bitcoin-classic.net/，可查询区块、交易、地址余额。

---

## 快速开始

```
1. 下载 Bitcoin-Classic-Setup.exe
   → https://github.com/Marcus-Vane/Bitcoin-Classic/releases

2. 安装到 D 盘或 E 盘（建议非系统盘）

3. 首次启动时等待区块链同步完成

4. 点击"Create a new wallet"创建钱包

5. 点击"Start Mining"开始挖矿

6. 挖矿开始后自动创建矿机钱包，右上角切换即可查看余额
```

---

## 安全注意事项

⚠️ **务必备份钱包文件（xxx.dat）**
- .dat 文件 = 你的私钥
- 不要在网上泄露 .dat 文件
- 不要发送给任何人
- 这是钱包资产的唯一所有权证明

---

## 与比特币对比

| 维度 | Bitcoin (BTC) | Bitcoin-Classic (BTCC) |
|------|--------------|------------------------|
| 发布时间 | 2009 | 2026 |
| 共识算法 | SHA-256 PoW | SHA-256 PoW |
| 总量 | 2100 万 | 2100 万 |
| 初始奖励 | 50 BTC | 50 BTCC |
| 挖矿门槛 | ASIC 矿机 + 低廉电费 | 家用 CPU |
| 网络算力 | 极高（EH/s 级别） | 极低（CPU 可挖） |
| 生态成熟度 | 成熟（交易所、支付、DeFi） | 早期（仅钱包+浏览器） |
| 投资价值 | 高流动性 | 实验性质 |

---

## 总结

Bitcoin-Classic 是一个**教育性质和体验性质**很强的项目。它让完全没有技术背景的用户也能亲手体验到"挖出一个区块"的成就感。

但它也面临现实挑战：
- 18 Stars 的社区规模非常小
- 没有主流交易所支持
- 项目长期可持续性存疑

**适合人群**：
- 想了解区块链底层原理的技术爱好者
- 想体验早期比特币挖矿氛围的怀旧玩家
- 学习加密货币和 PoW 共识机制的学生

> ⚠️ 请注意：BTCC 目前市值和流动性极低，请勿投入大量资金或算力。

> 💡 想了解更多区块链和加密工具？关注 [dibi8.com](https://dibi8.com) 获取每周精选开源项目。

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

