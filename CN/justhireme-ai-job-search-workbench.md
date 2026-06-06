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
- /posts/justhireme-ai-job-search-workbench/
faqs:
  - q: 'Is JustHireMe free and open source?'
    a: 'Yes. JustHireMe is open source under the MIT license, with no subscription fees or hidden costs. You own your resume and data, and the scoring algorithm is transparent.'
  - q: 'Does JustHireMe require an AI API key or send my data to the cloud?'
    a: 'No. JustHireMe is local-first: all AI computation runs locally with no API key required, and your data is stored on your machine in a local SQLite database rather than uploaded to the cloud.'
  - q: 'Which job platforms can JustHireMe scrape listings from?'
    a: 'It automatically aggregates jobs from LinkedIn, Indeed, Glassdoor, AngelList, Hacker News, company career pages, and remote-work sections. A deduplication algorithm merges the same role when it appears across multiple platforms.'
  - q: 'How does JustHireMe''s job matching score work?'
    a: 'It uses semantic understanding rather than keyword matching, comparing your skills, experience, salary expectations, and career goals against each job''s requirements. Each listing receives a 0-100 score so you can focus on roles above 80.'
  - q: 'What technology stack is JustHireMe built on?'
    a: 'The desktop app uses Tauri 2 with React 19 and TypeScript; the backend runs Python 3.13 with FastAPI and WebSockets; data is stored in SQLite plus a Kuzu graph database and LanceDB vector store; and Playwright handles browser automation for scraping and applying.'
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

- [Agent Reach：让你的 AI Agent 一键连接互联网](/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)
- [Free Claude Code：不花一分钱，让顶级 AI 帮你写代码](/resources/ai-tools/free-claude-code-open-source-proxy/)
- [OpenClaw 42 个真实用例：AI 代理已经这样改变我们的生活](/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/)

---

**项目地址**：[github.com/vasu-devs/JustHireMe](https://github.com/vasu-devs/JustHireMe)

**Stars**：471 ⭐ | **Forks**：91 | **语言**：Python 47.3%, TypeScript 27.5%

---

## Recommended Tools

For developers building or deploying open-source AI tools, we recommend:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 free credit for new users, 14+ global regions, one-click GPU/CPU droplets ideal for AI workloads.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Anthropic Claude / OpenAI / DeepSeek API proxy. Most AI tools above (chatbots, code gen, translation, search, etc) need an LLM API key — this proxy delivers stable access to top models at ~30% of official pricing.

*Affiliate link — supports dibi8.com at no cost to you.*

<!--auto-references-->
## References & Sources

- [JustHireMe](https://github.com/vasu-devs/JustHireMe)
- [Tauri](https://github.com/tauri-apps/tauri)
- [React](https://github.com/facebook/react)
- [FastAPI](https://github.com/fastapi/fastapi)
- [Playwright](https://github.com/microsoft/playwright)
- [Kuzu](https://github.com/kuzudb/kuzu)
- [LanceDB](https://github.com/lancedb/lancedb)
- [SQLite](https://www.sqlite.org/)
