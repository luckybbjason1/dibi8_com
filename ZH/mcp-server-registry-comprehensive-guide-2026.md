---
title: 'MCP Server 全目录指南 2026：19,700+ 服务器、7 个官方款、以及 60 秒挑对那一个'
description: '2026 MCP server 发现完全指南。Anthropic 7 个 reference 服务器、87.3k star 的 awesome list、Smithery vs mcp.so 两大注册中心对比、各类别 top 服务器、以及挑选决策树 —— 不讲 MCP 是什么，只讲市面上有什么可以插进你的 MCP host。'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack:
  - TypeScript
  - Python
  - Docker
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/modelcontextprotocol/servers'
stars: 86000
maintainer: 'dibi8'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['MCP', 'Model Context Protocol', '注册中心', 'Hub文章']
aliases:
  - /posts/mcp-server-registry-comprehensive-guide-2026/
---

2026 年 1 月，所有公开的 MCP server 还能塞进一个 GitHub README。到 2026 年 5 月，[mcp.so](https://mcp.so) 已经列出 **19,700+** 个。瓶颈不再是 "怎么写一个"，而是 "19,700 个里我到底该插哪个进去？"

这篇指南正面回答这个问题。我们**不再解释 MCP 是什么**（要看那个去读我们的 [MCP 深度指南 2026](/zh/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/)）。这篇地图覆盖 **server 生态**：Anthropic 7 个官方款、87.3k star 的社区目录、两个注册中心平台、以及一棵 30 秒就能用的发现决策树。

## 1. 6 个月内 MCP server 数量为何爆涨 100×

三个原因复合：

1. **跨平台采用**：到 2026 年初，Anthropic、OpenAI、Google DeepMind 都支持 MCP。写一次的 server 在 Claude Desktop、ChatGPT、Gemini 里都能用
2. **工具链成熟**：TypeScript / Python / Go / Rust / Swift SDK 都齐了 —— 写一个 server 是下午 50 行代码的活
3. **2026 路线图落地**：传输层水平扩展（server 不再需要持 session 状态）、企业认证（SSO/审计）、MCP Apps（SEP-1865 UI 扩展）让协议变成 production-ready

结果：1 月 500+ 公开 server，3 月 ~5000，5 月 19,700+。**大部分是信号不是噪音** —— 但你需要一张地图。

## 2. 30 秒发现决策树

| 你想要… | 第一站 |
|---|---|
| 用一个久经考验的基础款（文件系统/抓取/git）| **Anthropic 官方款**（第 3 节）|
| 按类别浏览（数据库/浏览器/云）| **awesome-mcp-servers**（第 4 节）|
| 不想手动改 config 就装好 server | **Smithery** 注册中心（第 5 节）|
| 浏览最大的目录 | **mcp.so**（19,700+）（第 5 节）|
| 因合规理由要自托管 | 挑开源 server + 看第 7 节 |
| 自己写一个 | 读我们的 [MCP 深度指南](/zh/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) |

下面每节展开这一行。

## 3. Anthropic 7 个官方款 —— 基线

官方 [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) 仓库（GitHub 86k 星）维护着 7 个 reference 实现。这些是 Anthropic 内部在用 + 盖章"协议正路"的 server：

| Server | 做什么 | 典型用途 |
|---|---|---|
| **Everything** | demo server，把所有 MCP primitive 都展示一遍（tools / resources / prompts）| 协议作者的 reference 阅读材料 |
| **Fetch** | HTTP/HTTPS 抓取 + html→markdown 转换 | LLM 按需读任意 URL |
| **Filesystem** | 沙箱化的本地文件系统读写 | 编程 agent 在项目目录工作 |
| **Git** | Git 仓库 introspection（log / diff / blame / 分支）| 代码感知的 AI 助手 |
| **Memory** | 持久化 KV 内存 + embedding 检索 | 长跑 agent 需要回忆 |
| **Sequential Thinking** | 多步推理 scaffold（把 chain-of-thought 当工具用）| 复杂规划任务 |
| **Time** | 时区感知的日期时间操作 | 排程 agent / 日历 bot |

两个早期 reference server 已经下线：

- **Brave Search** —— 转给 [brave/brave-search-mcp-server](https://github.com/brave/brave-search-mcp-server)，Brave 自己维护
- **Slack** —— 现在由 Zencoder 社区维护

如果今天起步，抄一份含 **Filesystem + Fetch + Memory** 的配置 —— 那是"自主编程 agent 的最小可用集"。

## 4. awesome-mcp-servers —— 87.3k 星的社区索引

[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) 是事实标准的社区目录：**87.3k 星 / 10.5k fork / 1.6k PR**。server 按 ~40 个类别分组。下面是 2026 AI 开发工作流里最重要的几类：

- **Aggregators** —— 把多个 MCP server 组合在一个端点后面（`1mcp/agent` / `a2asearch-mcp`）
- **Browser Automation** —— `playwright-mcp` / `browsermcp/mcp` / `real-browser-mcp`
- **Cloud Platforms** —— `terraform-mcp-server` / `aws-mcp-server` / `k8s-mcp-server` / `localstack-mcp-server`
- **Code Execution** —— `e2b-sandbox-mcp`（云沙箱）/ `piston-mcp`（多语言 runner）/ `pydantic-ai/mcp-run-python`
- **Coding Agents** —— `codemcp` / `claude-concilium` / `any-cli-mcp-server`
- **Databases** —— Postgres / MySQL / MongoDB / Redis / SQLite / ClickHouse / Snowflake 连接器全有开源 MCP server
- **Communication** —— Slack（Zencoder）/ Discord / Teams / Telegram / 邮件（IMAP/SMTP）
- **Knowledge & Memory** —— `mem0-mcp` / `letta-mcp` / 向量库集成（Pinecone / Weaviate / Chroma）
- **Search** —— `brave-search-mcp-server` / `tavily-mcp` / `exa-mcp` / `perplexity-mcp`

**使用方法**：不要顺序读。Ctrl-F 你的问题领域（`postgres` / `kubernetes` / `stripe`），看前 2-3 个结果，核对星数和最后提交日期。**列表不是按星数排序**，是按维护者判断 —— 自己再验证。

## 5. Smithery vs mcp.so —— 两大注册中心平台

2026 年 1 月 awesome-list 超过 500 个 server 时，两个注册中心平台冒头解决 "我想装一个 server 但不想复制粘贴 JSON config" 这个痛点。

### Smithery（[smithery.ai](https://smithery.ai)）

- **模式**：注册中心 + 托管 runtime + CLI 安装器
- **server 数**：~5000（精选，比 mcp.so 少但质量更高）
- **价格**：免费列表、免费浏览、免费安装。托管 server 可能按使用量计费
- **杀手特性**：`npx -y @smithery/cli@latest install <server>` 一行命令装到 Claude Desktop / Cursor / Continue 的配置里，不用手动编辑 JSON
- **缺点**：暂无创作者变现 —— 开发者写热门 server 也赚不到钱

### mcp.so

- **模式**：纯注册中心 / 目录（最大目录）
- **server 数**：**19,700+**（覆盖最全 —— 量胜于精）
- **价格**：免费目录
- **杀手特性**：体量最大，能找到就在这里
- **缺点**：策展质量较低，每一条都得自己评估

### 怎么选

- **想要 CLI 安装 + 精选**：Smithery
- **想要长尾**：mcp.so
- **生产部署**：永远先读 GitHub 源 —— 两个注册中心都会跳到原仓库，自己看维护者活跃度 + open issues + license

## 6. 按类别看 Top MCP Servers（2026 年 5 月）

按社区星数、集成覆盖度、近期提交活跃度评出：

**Filesystem & Code**
- `modelcontextprotocol/server-filesystem`（官方）—— 沙箱文件系统
- `cyanheads/git-mcp-server` —— 超出官方 Git server 范围的 Git 操作
- `tools-mcp/codemap-mcp` —— 语义代码导航

**Browser & Web**
- `microsoft/playwright-mcp` —— E2E 测试场景 + 复杂页面交互最佳
- `browsermcp/mcp` —— 轻量，复用你已经登录的浏览器 session
- `tavily-mcp` —— 给 LLM 消费预格式化好的搜索结果

**Database**
- `postgres-mcp-server` —— schema introspection + 安全查询执行
- `mongodb-mcp` —— MongoDB 官方维护
- `redis-mcp` —— KV + pub/sub 给 agent 协同用

**Memory & Knowledge**
- `mem0-mcp` —— 持久化语义内存层（连接 mem0 SaaS）
- `letta-mcp` —— agent 状态框架
- `pinecone-mcp` —— 向量库

**Cloud Ops**
- `aws-mcp-server` —— IAM 范围内的 AWS API 访问
- `k8s-mcp-server` —— kubectl 等价 + 安全护栏
- `terraform-mcp-server` —— plan/apply 带确认门

**Coding Agents**
- `codemcp` —— 把任意 IDE 变成 MCP host
- `e2b-sandbox-mcp` —— 沙箱化云端代码执行（替代 Code Interpreter）

## 7. 自托管 vs 云托管 MCP server

大多数 MCP server 是 stdio 模式 —— 跑在你机器上。但 2026 年传输层扩展工作让 HTTP/SSE 模式的 MCP server 生产可用，打开了云托管部署模式。

### 何时自托管

- **合规**（医疗 / 金融 / 政务）—— 数据不能出边界
- **延迟** —— server 靠近数据（Postgres 跑在同一个 VPC）
- **成本** —— 规模化时省掉 SaaS per-call 费用

4GB VPS 能舒服跑 10+ 个 stdio-bridge 或 HTTP MCP server。我们把 dibi8 内部 MCP cluster 跑在 {{< aff "htstack" "self-host-vps" "HTStack 的香港 VPS" >}}（对中国大陆延迟 <30ms）。全球分布式部署或更大集群，{{< aff "digitalocean" "self-host-k8s" "DigitalOcean 托管 Kubernetes" >}} 跑 3 副本是生产标配。

### 何时云托管（Smithery / e2b / vendor 托管）

- **原型**：零基础设施，CLI 安装，快速迭代
- **无状态工具**（fetch / search）—— 没有数据本地性问题
- **重计算**（e2b 沙箱 / 浏览器自动化）—— 把 VM 管理外包出去

## 8. 怎么挑 + 自己写

**挑选 checklist（每个候选 30 秒过一遍）**：

1. **星数 > 500** + **最后提交 < 90 天** = 活跃项目（否则换一个）
2. **有 `good first issue` 标签的 open issue** = 维护者欢迎贡献（健康）
3. **License = MIT/Apache 2.0** = 商用安全
4. **README 有 `claude_desktop_config.json` snippet** = 作者测过装机路径
5. **从 npm/PyPI 装时验签** —— 2026 真实威胁：通过 MCP server 的供应链攻击

**没合适的就自己写**。TypeScript 和 Python SDK 能让你用 50 行代码做出可用的 MCP server。Anthropic 团队故意把协议设计得很薄 —— 写 server 几乎无摩擦。

完整"自己写 MCP server"教程（stdio 传输配置 / tools/resources/prompts 实现 / Claude Desktop 调试）见我们的 [MCP 深度指南 2026 权威版](/zh/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/)。

## TL;DR

2026 MCP server 生态有 4 层值得了解：

1. **Anthropic 7 个官方款** —— 你的基线（Filesystem + Fetch + Memory 是最小集）
2. **awesome-mcp-servers（87.3k 星）** —— 公认的社区索引，按类别浏览
3. **Smithery + mcp.so** —— 注册中心平台（Smithery 看 CLI 安装，mcp.so 看广度）
4. **自托管 vs 云托管** —— 合规/延迟选自托管；原型/重计算选云托管

困难不再是"找到一个 server"，而是 **挑对那个** —— 用第 8 节的 30 秒清单 + 第 2 节决策树。没合适就下午自己写一个（50 行 TS 或 Python）。

---

*想自托管 5+ 个 MCP server（postgres + filesystem + git + memory + tavily-search）不烧云账单？开一个 $6/月的 {{< aff "digitalocean" "footer-cta" "DigitalOcean droplet" >}}，用 supervisor（systemd 或 PM2）跑起来，把 Claude Desktop 的 `claude_desktop_config.json` 指过去。一下午搞定。*
