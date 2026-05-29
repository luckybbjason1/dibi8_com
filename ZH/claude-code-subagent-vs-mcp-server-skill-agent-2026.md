---
title: 'Subagent、MCP Server 与 Skill 对比：何时该为 Claude Code 构建哪种扩展（2026）'
description: 'Claude Code 有三个扩展点——skill、subagent 和 MCP server——它们解决的是不同的问题。本文给出选型决策框架，配有完整的实战场景，以及那些会浪费你时间的反模式。'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'MCP', 'CLI']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Commercial (Anthropic)
license_type: 'Proprietary'
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/anthropics/claude-code'
stars: 0
maintainer: 'Anthropic'
last_maintained: '2026-05-28'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['claude-code', 'mcp', 'subagents', 'skills', 'agent-sdk', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/claude-code-subagent-vs-mcp-vs-skill/
faq:
  - q: "skill、subagent 和 MCP server 之间一句话的区别是什么？"
    a: "skill 教 Claude 『怎么做』某件事（打包好的指令与知识，按需载入上下文），subagent 决定『谁来做』（一个拥有独立上下文窗口的委派工人），而 MCP server 决定『能触达什么』（连接外部工具与数据的通道）。skill 改变行为，subagent 保护上下文，MCP server 增加能力——这是三条不同的轴，而不是三个互相竞争的选项。"
  - q: "如果我需要 Claude 查询我们的内部数据库，那是 skill、subagent 还是 MCP server？"
    a: "是 MCP server。任何把 Claude 连接到外部系统的东西——数据库、内部 API、SaaS 平台、工单系统——都属于集成，而集成正是 MCP server 存在的意义。skill 可以记录『怎样写出好的查询语句』，subagent 可以作为在隔离环境里跑分析的工人，但真正连上数据库这件事是 MCP server 的职责。你常常会三者一起用。"
  - q: "什么时候该写一个 skill，而不是直接把指令放进 CLAUDE.md？"
    a: "CLAUDE.md 用于始终生效、适用于每一次交互的项目级规则。当指引是情境化的——一套多步流程、一份领域操作手册、一张检查清单——只想在相关时才载入，那就写成 skill。skill 让你的基础上下文保持精简：『如何发布一个版本』的详细指令只有在你真正发版时才进入对话，而不是给每一条 prompt 都增重。"
  - q: "subagent 能用 MCP server 和 skill 吗？"
    a: "能。subagent 作为一段完整的 Claude 对话运行，因此它继承了对会话中已连接的 MCP server 的访问权，也能载入与其任务相关的 skill。这是常见的组合：MCP server 暴露数据库，skill 编码分析方法，subagent 在隔离上下文里跑完整个流程，这样沉重的查询输出永远不会污染父对话。这三层是可以叠起来的。"
  - q: "既然 MCP server 最强大，为什么不把一切都做成 MCP server？"
    a: "因为 MCP server 是这三者中构建和维护成本最高的——它们是独立进程，有自己的部署、鉴权和版本管理。如果你的需求是『Claude 应当遵循这张检查清单』，那是 skill（一个 markdown 文件）。如果是『做这次探索但别撑爆我的上下文』，那是 subagent（一个 markdown 文件）。在 skill 就够用时却伸手去做 MCP server，那是过度工程：你为一个文档问题交付了一项服务。"
  - q: "skill、subagent 和 MCP server 都能在 CI／无头（headless）模式下工作吗？"
    a: "都能，三者皆可。skill 和 subagent 是仓库里受版本控制的文件，所以 CI 会自动接管它们。MCP server 需要在 CI 环境中完成配置并可达（凭证放在 CI secrets 中、对服务有网络访问权）。无头的 -p 模式三者都支持；唯一实际的坑是确保你的 MCP server 鉴权在无人值守运行时无需交互式登录也能正常工作。"
---

## 引言

到了 2026 年，Claude Code 有三种各不相同的扩展方式——**skill**、**subagent** 和 **MCP server**——我们被问得最多的一个问题就是「我该做哪一个？」这种困惑可以理解：三者都是「让 Claude 做更多事的方式」，而宣传话术又把它们混为一谈。但它们处在三条完全不同的轴上，选错那一个，要么意味着过度工程（用一整个服务去做一个 markdown 文件就能搞定的事），要么意味着撞墙（一个 skill 根本触达不了你的数据库）。

本文给你一个决策框架。我们会用一句话定义每个扩展点，讲清楚每个扩展点移动的是哪条轴，端到端跑三个真实场景，并指出那些会浪费你一个周末的反模式。如果你已经读过[自定义 agent 编写指南](/zh/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/)和 [2026 MCP Server 排行榜](/zh/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/)，这篇就是把它们串起来的那一篇。

## 三个扩展点，各用一句话

- **Skill**——教 Claude *怎么*做某件事。打包好的指令、一份操作手册、一张检查清单，只在相关时才载入上下文。
- **Subagent**——*谁*来做。一个拥有独立上下文窗口的委派工人，被派生出来以保持父对话的精简（见[subagent 模式](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)）。
- **MCP server**——*能触达什么*。连接到外部系统的通道：数据库、API、SaaS 工具、数据源。

把它说成一句话，困惑就消散了：**skill 改变行为，subagent 保护上下文，MCP server 增加能力。**它们不是同一个问题的三个答案，而是三个不同问题的答案。

## 每个扩展点移动的那条轴

### Skill 移动「知识」轴

skill 回答的是*「Claude 不了解我们具体的流程」*。你的发布流程、你的代码评审评分标准、你的事故响应手册——这些都是情境化的知识。你不想把它放进 `CLAUDE.md`（那会在每次交互时都载入，把基础上下文撑大）；你想让它只在任务需要时才载入。skill 就是一个带触发描述的 markdown 文件；当工作匹配上时，详细指令进入对话，否则就乖乖待在一边不碍事。

### Subagent 移动「上下文」轴

subagent 回答的是*「这项工作会撑爆我的上下文窗口」*。知识可能已经具备；问题在于把这项工作内联去做——读 30 个文件、跑一次漫长的探索——会挤掉你真正在意的推理。subagent 在一个独立的上下文里把它跑完，只把结论交回来。*能力*上什么都没变；变的是*由谁的工作记忆*为这次探索买单。

### MCP server 移动「能力」轴

MCP server 回答的是*「Claude 根本触达不了这个系统」*。你的 Postgres 数据库、你的内部指标 API、你的 Stripe 账户、你的 Linear 看板。再怎么写 skill、再怎么派生 subagent，都变不出一个数据库连接来——那是一项实打实的新能力，而能力来自 MCP server。它也是三者中最重的：一个独立进程，需要你自己负责部署、鉴权和版本管理。

## 决策框架

按顺序问这几个问题：

1. **「Claude 是否需要触达一个它当前触达不了的系统？」** → **MCP server。**（数据库、API、SaaS、外部数据。）
2. **「Claude 是否已经具备这项能力，但这项工作会把我的上下文撑大？」** → **Subagent。**（大型探索、并行研究、隔离实验。）
3. **「Claude 既有能力又有上下文，只是不了解我们具体的做法？」** → **Skill。**（操作手册、检查清单、流程。）

| 如果问题是…… | 就构建一个…… | 为什么 |
| --- | --- | --- |
| 触达不了系统 | MCP server | 新能力 |
| 上下文会爆 | Subagent | 保护工作记忆 |
| 不了解我们的流程 | Skill | 情境化知识 |
| 标准从来落不了地 | Subagent（自定义 agent） | 可执行、受版本控制的评审 |

能解决你问题的最廉价选项，几乎总是正确的那个。只要一个 markdown 文件（skill 或 subagent）能干这活，它就胜过一项已部署的服务（MCP server）。

## 实战场景 1：「审计我们的代码库有没有 SQL 注入」

- **能力？** 读代码——Claude 本来就会。不需要 MCP server。
- **上下文？** 审计整个代码库意味着要读几十个文件。那*会*把父上下文撑大。 → **Subagent。**
- **流程？** 你想让审计遵循 OWASP 的具体检查清单。 → **Skill**（或者把检查清单烤进一个 `security-auditor` 自定义 agent 的系统提示里）。

**答案：**一个 `security-auditor` subagent，它的系统提示里编码了那张检查清单。一个产物，覆盖两条轴。不需要服务。

## 实战场景 2：「告诉我上个月哪些客户流失了」

- **能力？** 那些数据存在你的数仓里。Claude 触达不了。 → **MCP server**（一个数仓／SQL MCP）。
- **上下文？** 一个庞大的结果集可能很嘈杂。 → 在一个**subagent**里跑查询，只返回摘要。
- **流程？** 「流失」在你公司有个具体的定义。 → 一个记录流失查询逻辑的 **skill**。

**答案：**三者组合使用。MCP server 负责连接，skill 定义「流失」，subagent 干净利落地跑完。这是教科书级的全栈案例。

## 实战场景 3：「确保每次发布都遵循我们的检查清单」

- **能力？** Git、读文件——本来就有。不需要服务。
- **上下文？** 很轻。严格说不需要 subagent 来做保护。
- **流程？** 这恰恰是重点——你团队的发布步骤。 → **Skill**，或者一个自定义 agent，如果你想让它*强制执行*并产出一份报告。

**答案：**一个 skill（或一个发布闸门式的自定义 agent）。在这里去构建 MCP server 纯属过度工程。

## 反模式

- **「凡事都做成 MCP server」的陷阱。** 用一项服务去解决一个文档问题。如果你不是在连接外部系统，那你多半不需要服务。（浏览 [MCP server 注册表](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/)，看看什么才真正值得做成服务。）
- **臃肿的 CLAUDE.md。** 把每一条流程都塞进始终生效的上下文里。把情境化的操作手册挪进 skill，让你的基础上下文保持锐利。
- **巨无霸 subagent。** 一个「什么都干」的 subagent，不过是个记性更差的父对话。按关注点拆分。
- **本该用能力的 skill。** 在 Claude 根本触达不了指标时，给「分析我们的指标」写了一个漂亮的 skill。再多的指令也替代不了那条缺失的 MCP 连接。

## 原则

这三个扩展点对应三种资源：**知识**（skill）、**上下文**（subagent）和**能力**（MCP server）。诊断出你真正短缺的是哪种资源，选择就自然浮现了。大多数团队过度伸向 MCP server，是因为它听起来强大，可一个 markdown 文件本来午饭前就能交付同样的结果。构建那个能移动你卡住的那条轴的、最轻量的东西。

## 搭建生产级的 Claude Code

把这三层都跑起来——尤其是 MCP server——并做到规模化，需要稳定的基础设施：

1. **一台可靠的主机来跑 MCP server 和 CI。** MCP server 是长时运行的进程；你需要一台一直在线的机器。**{{< aff "htstack" "footer-cta" "HTStack" >}}**——香港 VPS，对中国大陆低延迟访问，BGP 稳定。和托管 dibi8.com 的是同一个 IDC，我们自己的 MCP server 和 agent 流水线就跑在上面。$5-12/月的高性价比档位。

2. **给并行各层留出云端余量。** 当 subagent 扇出、MCP server 同时运行时，你需要富余的 CPU。**{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}**——14+ 个区域，$200 免费额度，60 天有效。

3. **一份 skills 礼包。** 内化 skill／subagent／server 这套划分最快的方式，就是研究可运行的范例。我们把五个久经实战的 skill 打包成了 Gumroad 上的一份 $19 礼包——见角落里那个浮动的 CTA——其中包含自定义 agent 定义，以及把这三层组合起来的编排（orchestrator）提示词。

## 延伸阅读

- [自定义 agent 编写指南](/zh/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/)——如何真正动手构建 subagent 这一半。
- [Subagent 模式](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)——上下文轴上的五种工作流。
- [2026 MCP Server 排行榜](/zh/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/)——挑选能力层。
- [MCP Server 注册表指南](/zh/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/)——值得连接的目录大全。

## 结论

别再把「skill、subagent 还是 MCP server？」当成三选一来问。换个问法：我短缺的是**知识**、**上下文**还是**能力**？知识 → skill。上下文 → subagent。能力 → MCP server。全栈案例会把三者分层叠用。拿不准的时候，就构建那个能移动你那条轴的、最廉价的产物——只要 markdown 文件能行，它每次都胜过一项已部署的服务。
