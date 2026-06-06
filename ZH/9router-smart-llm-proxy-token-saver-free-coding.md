---
title: "9Router：智能AI代理网关——节省60%令牌开销，告别API限流"
description: "发现9Router——开源智能AI代理网关，利用RTK无损压缩引擎节省20-40%输入令牌，通过三层智能回退系统无缝连接40+语言模型提供商，让每位开发者都能以零成本获取世界一流的AI编程体验与效率提升。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - Go
  - JavaScript
  - TypeScript
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "3.2 MB"
file_md5: ""
download_url: "https://github.com/rtk-ai/rtk"
backup_url: ""
github_repo: "https://github.com/rtk-ai/rtk"
stars: 49905
maintainer: "rtk-ai"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /zh/posts/9router-smart-llm-proxy-token-saver-free-coding/
faqs:
  - q: '什么是 9Router，它是如何工作的？'
    a: '9Router 是一款开源、自托管的智能代理，位于你的 AI 编程工具与模型提供商之间，默认运行在 localhost:20128 上。你的工具不再直接调用 Claude 或 OpenAI，而是把请求发送给 9Router，由它通过智能回退逻辑和 token 压缩，将请求路由到 40+ 个提供商之间。'
  - q: '使用 9Router 需要花钱吗？'
    a: '不需要。9Router 软件基于开源 MIT 许可证永久免费，并在你自己的硬件上自托管。它没有任何计费基础设施，永远不会向你收费；你只需直接为自己配置的订阅或 API key 向各提供商付费，免费提供商则始终免费。仪表盘上的费用数字是一个节省追踪器，显示如果使用等量的付费 API 会花费多少。'
  - q: '9Router 能减少多少 AI token 用量？'
    a: '通过内置的 RTK 压缩，9Router 会在 git diff、grep 结果和目录列表等工具输出抵达 LLM 之前先行压缩，每次请求可节省 20-40% 的输入 token。其可选的 Caveman 模式最多可将冗长的模型输出减少 65%，而每日调用量在 500+ 次的开发者反馈称，实际模型消耗下降了 40-60%。'
  - q: '哪些 AI 编程工具和 IDE 可以配合 9Router 使用？'
    a: '任何支持自定义 OpenAI 兼容 API 端点的工具都可以通过 http://localhost:20128/v1 连接到 9Router。受支持的工具包括 Claude Code、OpenAI Codex CLI、Cursor IDE、GitHub Copilot、Cline、Continue、Roo Code、Antigravity、Droid、Kilo Code 和 OpenCode。'
  - q: '我能否以零月费使用 9Router 进行 AI 编程？'
    a: '可以。你可以仅使用免费提供商搭建一个组合，例如 Kiro AI（通过 AWS Builder ID、Google 或 GitHub OAuth 免费无限使用，无需 API key）、OpenCode Free（零认证直通）以及 Vertex AI（$300 免费 Google Cloud 额度）。再结合 RTK 压缩，这套方案能以真正每月 $0 的成本提供生产级质量的响应。'
---
{</* resource-info */>}

AI编程助手革命为开发者带来了前所未有的困境：我们通过Claude Code、OpenAI Codex、Cursor和GitHub Copilot等工具获得了世界级的语言模型访问权限——但同时管理多个平台上的订阅、配额和速率限制正变得日益昂贵和令人沮丧。许多开发者发现自己两周内就耗尽了Claude Pro的月度配额，然后在冲刺截止日期面前只能面对速率限制的墙壁。

**9Router**应运而生——一个开源的智能代理和令牌管理系统，彻底消除了这种痛点。拥有超过**6,900个GitHub星标**、1,200多个Fork和快速社区增长，9Router已成为那些想要获得最大AI能力而不必支付不必要高级版本费用的开发者的首选解决方案。基于Node.js 20+、Next.js 16和React 19构建，它提供了一个统一界面，使用智能回退逻辑和强大的令牌节省压缩技术，将您的AI编程请求路由到40多个提供商。

## 什么是9Router以及它是如何工作的？

9Router是一个本地托管的中间件服务（默认运行在`localhost:20128`），位于您的AI编程工具和底层模型提供商之间。您的工具不再直接向Claude、OpenAI或任何单一提供商发送API请求，而是与9Router通信——然后由它智能决定将请求路由到哪个后端提供商。

这种架构为您带来三大优势：

1. **从一个地方访问多个提供商**：在单个仪表板中配置Claude、Gemini、GLM、MiniMax、Kiro、OpenCode、Vertex AI和40多个其他提供商。您的CLI工具发送到localhost；9Router处理其余部分。
2. **自动回退机制**：当主要提供商达到配额限制或出现故障时，9Router无缝切换到下一个层级——无论是便宜的备用提供商还是完全免费的选项。工作流程零中断。
3. **请求离开机器前的令牌压缩**：通过其内置的[RTK](https://github.com/rtk-ai/rtk)集成（约40K星标），9Router在请求到达LLM之前自动压缩工具输出（git差异、grep结果、目录列表、日志转储）。仅此一项就能在每个请求中节省20-40%的输入令牌。

## 让9Router与众不同的核心功能

### 🚀 RTK令牌压缩引擎

工具输出通常占您总提示预算的30-50%。当Claude Code在大型代码库中运行`git diff`、`ls -R`或`grep`时，它会向模型发送数百万字节的文本——其中大部分是无关噪音。

9Router内置的RTK集成功能自动检测这些工具输出并应用智能的无损压缩过滤器：

- **git-diff**：将差异输出简化为必要的变更行
- **git-status**：将状态压缩为摘要格式
- **grep / find**：修剪无关匹配项，保留上下文丰富的行
- **tree / ls**：以有意义的方式折叠目录结构
- **dedup-log**：删除重复的连续日志条目
- **smart-truncate**：保留首尾部分，同时移除冗余的中间内容

至关重要的是，如果任何过滤器失败或产生比原始文本更差的输出，RTK会静默回退到未修改的文本。错误永远不会破坏您的请求。压缩在任何格式转换**之前**运行，因此它适用于所有支持的格式（OpenAI、Claude、Gem尼、Cursor、Kiro、OpenAI Responses）。

```
不使用RTK：向LLM发送47K令牌
使用RTK：向LLM发送28K令牌（节省40%·相同质量的答案）
```

在实际应用中，开发者报告每个请求都能看到20-40%的令牌节省——有效地将每个订阅的使用寿命延长了数天甚至数周。

### 🪨洞穴人模式（输出压缩）

除了输入优化外，9Router还减少了LLM返回的内容量。通过注入"洞穴人风格"的系统提示（灵感来源于[Caveman](https://github.com/JuliusBrussee/caveman)，约52K星标），9Router指示模型简洁回复——保留所有技术内容，同时消除对话性填充词。

这可以节省高达**65%的输出令牌**。对于复杂的重构任务或长代码生成会话，这些节省在数百次API调用中迅速累积。

### 🎯 智能三层回退系统

这可以说是9Router的核心杀手锏。您可以定义"组合"——不同定价层级的有序模型列表——然后9Router自动相应地路由请求：

```
组合："my-coding-stack"
  1. cc/claude-opus-4-6        → 您的Claude Code Pro订阅
  2. glm/glm-4.7               → 便宜备用（每百万令牌$0.6）
  3. kr/claude-sonnet-4.5      → Kiro AI免费紧急备用
```

当Opus配额耗尽（或发生错误）时，9Router立即过渡到GLM。如果GLM也耗尽，则下降到Kiro的无限免费层级。您永远不会遇到墙。

系统支持五种不同的定价层级：

| 层级 | 提供商 | 典型成本 | 重置模式 |
|------|--------|---------|---------|
| 订阅版 | Claude Code、Codex、Copilot、Cursor | $10-$200/月 | 5小时滚动 + 每周/每月 |
| 廉价版 | GLM-5.1、MiniMax M2.7、Kimi K2.5 | $0.2-$0.6/百万令牌 | 每日/滚动/固定月度 |
| 免费版 | Kiro AI、OpenCode Free、Vertex AI | $0 | 无限 |

### 📊 实时配额跟踪与分析

网页仪表板显示每个提供商的实时令牌消耗、重置倒计时（5小时、每日、每周、每月）和预估成本跟踪。虽然仪表板显示的"成本"仅作为参考比较工具——9Router本身是免费软件，从不收费——但这些分析帮助您了解使用模式并优化支出。

如果您的仪表板在使用Kiro免费层时显示"$290总成本"，那$290代表如果您直接使用那些API本应支付的金额。您实际支付仍然为$0。它本质上是一个节省跟踪器，展示您避免了多少开支。

### 🔄 跨每种主要协议的格式翻译

9Router透明地在OpenAI、Claude、Gemini、Cursor、Kiro、Vertex AI、Antigravity、Ollama和OpenAI Responses格式之间进行翻译。您的CLI工具发送标准的OpenAI兼容负载；9Router将其翻译成每个提供商期望的原生格式。这意味着您可以使用任何支持自定义OpenAI端点的工具，并将其接入任何后端提供商。

### 👥 多账户支持

需要跨账户负载均衡或冗余吗？9Router允许您为每个提供商添加多个账户，支持自动轮询分发或基于优先级的路由。如果一个账户达到其配额，请求会自动转移到下一个可用账户。OAuth令牌自动刷新，消除了手动重新认证周期。

### 💾 云同步

通过加密云存储在整个设备上同步您的完整配置——提供商、组合、别名、设置。在您本机电脑上设置完美的组合，然后在VPS、Docker部署或同事工作站上访问完全相同的配置。

## 支持的编程工具和IDE

9Router充当通用适配器，支持几乎所有流行的AI编程工具：

- **Claude Code**（`~/.claude/config.json`中使用自定义API基本地址）
- **OpenAI Codex CLI**（环境变量覆盖）
- **Cursor IDE**（自定义OpenAI端点设置）
- **GitHub Copilot**
- **OpenClaw**（WhatsApp、Telegram、Slack消息）
- **Cline**
- **Continue**
- **Roo Code**
- **Antigravity**
- **Droid**
- **Kilo Code**
- **OpenCode**

任何支持自定义OpenAI兼容API端点的工具都可以连接到9Router。该服务在`http://localhost:20128/v1`上暴露标准OpenAI兼容接口。

## 入门：安装和设置

### 快速开始：本地主机（大多数用户推荐）

```bash
# 克隆并安装
git clone https://github.com/decolua/9router.git
cd 9router
npm install
npm run build

# 可选环境设置
export JWT_SECRET="your-secure-secret-change-this"
export INITIAL_PASSWORD="your-dashboard-password"
export PORT="20128"
export NODE_ENV="production"

# 启动服务器
npm run start
```

启动后，打开`http://localhost:20128`访问网页仪表板。从此处连接您的第一个提供商。

### Docker部署

对于生产或多设备设置，Docker使部署变得简单：

```bash
docker build -t 9router .

docker run -d \
  --name 9router \
  -p 20128:20128 \
  --env-file ./.env \
  -v 9router-data:/app/data \
  -v 9router-usage:/root/.9router \
  9router
```

### 连接您的第一个提供商

让我们设置一个完整的免费层级组合——无需任何支付方式：

1. **在仪表板中连接Kiro AI**（使用AWS Builder ID、Google或GitHub OAuth——不需要API密钥）
2. **连接OpenCode Free**（零认证、直通代理，模型自动获取）
3. **创建名为`free-dev`的组合**，包含以下模型：
   - `kr/claude-sonnet-4.5`（通过Kiro的Claude Sonnet 4.5——免费无限）
   - `kr/glm-5`（通过Kiro的GLM-5——免费无限）
   - `vertex/gemini-3.1-pro-preview`（Google Cloud——$300免费信用额度）

然后将您首选的工具配置为指向`http://localhost:20128/v1`并使用您的仪表板API密钥：

```json
{
  "anthropic_api_base": "http://localhost:20128/v1",
  "anthropic_api_key": "your-9router-api-key"
}
```

### 配置Cursor IDE

在Cursor设置→模型→高级中：

```
OpenAI API基本地址：http://localhost:20128/v1
OpenAI API密钥：[从9Router仪表板复制]
模型：cc/claude-opus-4-7
```

现在Cursor的每个模型调用都流经9Router的路由智能。

## 真实世界应用场景

### 场景A：最大化现有订阅价值

您每月为Claude Pro支付$20。如果没有9Router，一旦配额耗尽，编码就会停止直到重置。

使用9Router的"maximize-claude"组合：
- 主用：`cc/claude-opus-4-7`（充分利用订阅）
- 备用：`glm/glm-5.1`（$0.6/百万令牌，每天上午10点重置）
- 紧急：`kr/claude-sonnet-4.5`（Kiro免费备用）

结果：由于RTK节省20-40%令牌，您的$20订阅持续更长时间；即使到期，您也有无缝备用方案。 cheap层级的总有效成本仅增加约$5——远低于升级到Claude Max（$200/月）。

### 场景B：完全零月度预算

完全使用免费模型开始：
- `gc/gemini-3-flash`（Google每月180K免费查询）
- `kr/claude-sonnet-4.5`（Kiro免费无限）
- `oc/<auto>`（OpenCode Free，无需认证）

结合RTK压缩，这套配置以真正的零月度成本提供生产级模型响应。

### 场景C：不间断24/7开发

对于截止期限内工作的团队和自由职业者，分层五个回退层级：
1. Claude Opus（优质级别）
2. GPT-5.5 via Codex（第二份订阅）
3. GLM-5.1（便宜的每日重置）
4. MiniMax M2.7（最便宜的$0.2/百万令牌，5小时滚动重置）
5. Kiro Claude Sonnet 4.5（免费无限）

五层保障确保无论配额耗尽还是提供商故障，都不会出现停机。

## 定价透明度：实际花费多少？

评估9Router时的关键问题：**9Router会向您收费吗？** 不会。永远不。

实际的经济运作方式如下：

- **9Router软件 = 永久免费**（开源MIT许可证，在您自己的硬件上自托管）
- **仪表板成本 = 仅用于显示/跟踪**（不是真正的账单）
- **您直接向提供商付费**（订阅、API密钥、无论您配置什么）
- **免费提供商保持免费**（Kiro AI、OpenCode Free、Vertex AI信用额度）

9Router纯粹是在您自己计算机上运行的本地代理路由器。它无法访问您的信用卡，不能生成发票，也没有计费基础设施。它只是转发请求并可选择性地压缩令牌。

仪表板的成本显示作为"节省跟踪器"——向您展示使用付费API直接进行的等效使用本应花费多少。如果您配置了所有免费提供商，显示的成本可能读作"$290"而您的实际银行交易是$0。这$290是您主动节省下来的钱。

## 9Router与其他方案的对比

9Router如何与现有方案相比？

| 功能 | 9Router | 直接提供商访问 | 其他代理工具 |
|------|---------|-------------|-------------|
| 智能回退路由 | ✅ 自动3+层级 | ❌ 单提供商 | 部分支持 |
| 令牌压缩（RTK） | ✅ 内置 | ❌ 无 | 罕见 |
| 多格式翻译 | ✅ 8+协议 | N/A | 有限 |
| 多账户轮换 | ✅ 轮询 | ❌ 手动 | 手动 |
| 免费提供商支持 | ✅ Kiro、OpenCode、Vertex | ❌ 不适用 | 通常不支持 |
| 实时分析 | ✅ 仪表板 + 日志 | ❌ 提供商门户 | 基础 |
| 自托管 | ✅ 完全控制 | N/A | 取决于具体方案 |
| 成本 | 免费软件 + 提供商费用 | 完整提供商价格 | 通常为付费 |

值得注意的主要替代方案是 **[OmniRoute](https://github.com/diegosouzapw/OmniRoute)**，这是9Router的一个TypeScript分支，添加了36+提供商、四层自动回退、多模态API（图像、嵌入、音频、TTS）、熔断模式、语义缓存、LLM评估框架以及带有368+单元测试的精制仪表板。OmniRoute可通过npm和Docker获取，适合希望超越核心9Router功能集的用户。

## 为什么9Router此时很重要

我们正处于AI编程工具的黄金时代，但经济现实尚未跟上。每个主要提供商独立地将访问权限限制在付费墙后面、配额限制和速率帽背后。在Claude、OpenAI、Google、Anthropic、DeepSeek和xAI之间管理六份不同的订阅既造成了财务负担又带来了操作复杂性。

9Router通过将所有这些提供商视为通过单一智能层可互换的商品来解决这个问题。您为每项任务获得最佳模型，为常规任务选择最便宜的路径，并在配额耗尽时保证可用性——同时让您的机器在令牌离开之前就压缩掉浪费。

RTK令牌压缩（节省约20-40%）、洞穴人模式输出减少（节省约65%）和智能多层回退相结合产生了复合效应。报告每天500+次API调用的开发者看到他们有效的模型消耗降低了40-60%，将一个$200/月的AI栈变成了$20-30可管理的水平。

## 技术架构亮点

9Router建立在针对可靠性优化的现代JavaScript栈上：

- **运行时**：Node.js 20+，用于一致、高性能的异步I/O
- **框架**：Next.js 16配合React 19用于网页仪表板
- **数据库**：LowDB（JSON文件-based）——简单、可移植、可版本控制的配置
- **流式传输**：Server-Sent Events (SSE) 用于实时进度反馈
- **认证**：OAuth 2.0加PKCE、JWT会话cookie、HMAC签名API密钥
- **代理**：完整HTTP透传，支持可配置的上游代理

环境变量提供了对部署的细致控制：
- `JWT_SECRET`：生产中请更改
- `REQUIRE_API_KEY`：强制在`/v1/*`路线上使用bearer token认证
- `ENABLE_REQUEST_LOGS`：启用调试级别的请求/响应日志记录
- `AUTH_COOKIE_SECURE`：在HTTPS反向代理后面强制Secure cookie标志
- `HTTP_PROXY` / `HTTPS_PROXY`：通过企业代理路由上游请求

该服务默认监听端口`20128`，除存储在`${DATA_DIR}`中的JSON文件外，不需要外部依赖或数据库。

## 总结

9Router解决了一个真正痛苦的问题，越来越多的开发者正在感受到这一问题。随着AI工具订阅的倍增，我们没有接受不断上涨的费用和任意的速率限制作为AI辅助开发的不可避免代价，9Router改变了游戏规则：使用您已经拥有的任何提供商，用便宜或免费的替代品填补缺口，尽可能压缩一切，并确保无论配额状态如何都维持连续的编码流程。

对于预算紧张的独立开发者，免费-first策略可以以正好$0的成本交付完全功能的AI编程辅助。对于愿意投资于高级订阅的团队，令牌压缩和智能路由通过确保每一分钱花得更远来最大化投资回报率。

它是免费的、开源的，并且几分钟内即可自托管。鉴于当前AI工具定价的走势，将9Router添加到您的开发基础设施中不仅可能有用——它正变得越来越必要。

**仓库**：[github.com/decolua/9router](https://github.com/decolua/9router)
**网站**：[9router.com](https://9router.com)

---

## 相关文章


- [GenericAgent：自我进化AI代理框架](/resources/llm-frameworks/hermes-agent-self-improving-ai-agent.zh/)
- [Anthropic的金融服务：AI驱动的Claude代理](/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation.zh/)

- [Addy Osmani的Agent技能：生产级AI编程代理](/resources/llm-frameworks/agent-skills-production-grade-ai-coding.zh/)

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "footer-cta-legacy" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。一个 key 同时访问多家顶级模型, 价格约官方 30%; 跨模型对比或国内/受限地区直连不通时尤其管用。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

