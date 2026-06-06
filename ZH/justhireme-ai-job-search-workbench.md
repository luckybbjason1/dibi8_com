---
title: "JustHireMe：AI 帮你自动找工作，从投递到拿到 Offer"
description: "JustHireMe 开源 AI 求职工作台评测。本地优先的求职情报系统，自动抓取职位、AI 匹配度评分、生成定制简历和求职信。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - JavaScript
  - Python
  - TypeScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "50.9 MB"
file_md5: ""
download_url: "https://github.com/vasu-devs/JustHireMe.git"
backup_url: ""
github_repo: "https://github.com/vasu-devs/JustHireMe.git"
stars: 1749
maintainer: "vasu-devs"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /zh/posts/justhireme-ai-job-search-workbench/
faqs:
  - q: 'JustHireMe 是免费开源的吗？'
    a: '是的。JustHireMe 采用 MIT 许可证开源发布，没有订阅费，也没有任何隐藏费用。你的简历和数据完全归你所有，评分算法也是公开透明的。'
  - q: 'JustHireMe 需要 AI API Key，或者会把我的数据上传到云端吗？'
    a: '不需要，也不会。JustHireMe 坚持本地优先原则：所有 AI 计算均在本地完成，无需任何 API Key，你的数据存储在本机的本地 SQLite 数据库中，不会上传到云端。'
  - q: 'JustHireMe 可以从哪些招聘平台抓取职位？'
    a: '它会自动聚合来自 LinkedIn、Indeed、Glassdoor、AngelList、Hacker News、公司招聘页面以及远程工作专区的职位信息。内置去重算法会自动合并同一职位在不同平台上的重复信息。'
  - q: 'JustHireMe 的职位匹配评分是如何工作的？'
    a: '它采用语义理解而非关键词匹配，将你的技能、经验、薪资期望和职业目标与每个职位的要求进行对比分析。每个职位列表都会得到一个 0-100 的评分，让你可以专注于 80 分以上的高匹配度职位。'
  - q: 'JustHireMe 的技术栈是什么？'
    a: '桌面端使用 Tauri 2 搭配 React 19 与 TypeScript；后端运行 Python 3.13，采用 FastAPI 与 WebSockets；数据存储层使用 SQLite、Kuzu 图数据库和 LanceDB 向量数据库；Playwright 负责处理抓取和自动投递的浏览器自动化任务。'
---
{</* resource-info */>}

## 问题：找工作就是一份全职工作

投 100 份简历，收到 2 个面试，0 个 Offer。这不是你的问题，是系统的问题。

每个招聘网站都是孤岛：
- **LinkedIn**：高级搜索要付费
- **Indeed**：重复职位、过期信息
- **Glassdoor**：薪资数据滞后
- **公司官网**：每个都要重新填写
- **招聘邮件**：99% 已读不回

更痛苦的是：每投一份都要**重新写简历**、**重新写求职信**、**重新研究公司**。

## 解决方案：JustHireMe

**JustHireMe** 是一个开源的 AI 求职智能工作台。本地优先、隐私安全、一键自动投递。

**核心理念**：让 AI 做重复工作，你只做决策。

## 核心功能

### 1. 智能职位抓取

自动从多个平台抓取职位：
- LinkedIn、Indeed、Glassdoor
- AngelList、Hacker News
- 公司招聘页面
- 远程工作专区

**去重算法**：同一职位在不同平台出现，自动合并。

### 2. AI 匹配度评分

不是关键词匹配，是真正的**语义理解**：
- 你的技能 vs 职位要求
- 你的经验 vs 职位级别
- 你的薪资期望 vs 预算范围
- 你的职业目标 vs 公司方向

评分 0-100，只看 80 分以上的职位。

### 3. 简历自动定制

根据每个职位**重写简历**：
- 突出相关技能
- 调整项目描述
- 匹配关键词
- 优化排版格式

不是模板填充，是**真正的 AI 重写**。

### 4. 求职信生成

每封求职信都是**独一无二**的：
- 研究公司背景
- 引用具体项目
- 展示相关经验
- 表达真诚兴趣

HR 看得出来是模板还是用心写的。

### 5. 本地 CRM 管理

所有数据存在本地：
- SQLite 数据库
- 职位历史记录
- 投递状态跟踪
- 面试日程管理

**隐私优先**：你的数据不会上传到云端。

## 技术架构

| 层级 | 技术 |
|------|------|
| 桌面端 | Tauri 2 + React 19 + TypeScript |
| 后端 | Python 3.13 + FastAPI + WebSockets |
| 数据库 | SQLite + Kuzu 图数据库 + LanceDB 向量库 |
| AI 模型 | 本地 LLM + 语义搜索 |
| 自动化 | Playwright 浏览器自动化 |

**本地优先**：所有 AI 计算在本地完成，无需 API Key。

## 安装使用

```bash
# 克隆仓库
git clone https://github.com/vasu-devs/JustHireMe.git
cd JustHireMe

# 安装前端依赖
npm install

# 启动开发服务器
npm run dev

# 启动桌面应用
npm run tauri dev
```

## 使用流程

1. **设置 profile**：上传简历，填写技能和目标
2. **配置抓取源**：选择要监控的招聘平台
3. **运行抓取**：AI 自动抓取最新职位
4. **查看匹配**：按匹配度排序，筛选高分配职位
5. **一键申请**：AI 生成定制材料，自动投递
6. **跟踪进度**：CRM 管理所有申请状态

## 为什么开源？

求职不应该被平台垄断：
- **数据所有权**：你的简历、你的数据
- **算法透明**：知道 AI 如何评分
- **免费使用**：没有订阅费、没有隐藏费用
- **社区驱动**：大家一起改进

## 适合谁用？

- **求职者**：想投更多、更好、更快
- **自由职业者**：寻找合同和项目
- **转行人士**：需要针对性定制简历
- **应届生**：不知道从何开始
- **资深人士**：想被动接收高质量机会

## 相关文章

- [Agent Reach：让你的 AI Agent 一键连接互联网](/zh/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code：不花一分钱，让顶级 AI 帮你写代码](/zh/resources/ai-tools/free-claude-code-open-source-proxy/)
- [OpenClaw 42 个真实用例：AI 代理已经这样改变我们的生活](/zh/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

**项目地址**：[github.com/vasu-devs/JustHireMe](https://github.com/vasu-devs/JustHireMe)

**Stars**：471 ⭐ | **Forks**：91 | **语言**：Python 47.3%, TypeScript 27.5%

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

