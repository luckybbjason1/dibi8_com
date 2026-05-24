---
title: '12-Factor Agents 解读：构建生产级 LLM 软件的 12 条原则（2026 完整指南）'
description: 'HumanLayer 出品的 12-Factor Agents（22K+ GitHub stars）定义了 demo 级 LLM 原型与真实用户依赖的生产级 agent 之间的设计模式分水岭。完整拆解 12 条原则——拥有自己的 prompt、拥有自己的上下文窗口、stateless reducer 模型、控制流自主、人在环 via tool call、紧凑错误、聚焦小 agent 等。附 Claude Code / Codex / OpenCode / MCP 栈实战应用指引。'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: LLM Frameworks
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/humanlayer/12-factor-agents'
stars: 22000
maintainer: 'humanlayer'
last_maintained: '2026-05-22'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['12-factor-agents', 'production-ai', 'llm-engineering', 'agent-architecture', 'humanlayer', 'agent-design-patterns', 'context-window', 'prompt-engineering', 'tool-calls', 'developer-productivity']
aliases:
- /zh/posts/12-factor-agents-production-llm-software-2026/
---

## 为什么"用 LangChain 就行"已经不灵了

每个把 LLM 功能上线给真实用户的工程师都撞过同一面墙：原型在 notebook 里跑得漂亮，付费用户第一次从不同角度发请求时立刻崩盘。Agent 幻觉出一个工具调用，上下文窗口在 session 中段爆炸，错误悄悄被吞掉，重试无限自旋，事后剖析才发现——连写这玩意儿的工程师自己都搞不清 agent 失败时到底在干什么。

2025–2026 的 agent AI 生态产生了十几个号称"让 agent 生产可用"的框架——LangChain、LangGraph、CrewAI、AutoGen、OpenAI Agents SDK、Pydantic AI，名单越来越长。每一个都解决了 *demo 问题*（组合工具调用、子 agent 路由）。几乎没有一个解决了 *生产问题*（意料外输入下的可预测行为、可观察的失败模式、可恢复的 session）。

[**12-Factor Agents**](https://github.com/humanlayer/12-factor-agents)（GitHub：`humanlayer/12-factor-agents`，**截至 2026 年 5 月已 22,000+ stars**）是 Dex Horthy 和 HumanLayer 团队给这个 gap 的答案。模仿 Heroku 2011 年那份 12-Factor App 方法论，它是一份 *方法论*——不是框架，不是 runtime，不是 SaaS——用来思考"真实客户会用的"LLM 软件。

代码 Apache 2.0，文档 CC BY-SA 4.0。273 次 commit 还在涨，主要 TypeScript 配 Python 和 Jupyter 示例方便上手。

---

## 核心洞察

框架抽象掉了 agent 出错时最重要的四件事：

1. **当时发出的 prompt**。
2. **当时活跃的上下文窗口**。
3. **决定下一步该做什么的控制流**。
4. **需要在崩溃后存活的执行 state**。

12-Factor Agents 论证：*这四件事每一件* 都应该是你拥有的代码——不是框架隐藏的魔法。结果是你 repo 里多一些代码、半夜 3 点出事故时少祈祷几次。

下面是全部 12 条因子，以及每一条在实战中的含义。

---

## 12 条因子

### 1. 自然语言到工具调用

LLM 的工作是把用户意图翻译成结构化的工具调用——仅此而已。不要让 LLM "做那件事"，让它产出 *描述* 那件事的 JSON，然后用确定性代码去执行。这一条约束消除了一整类幻觉驱动的事故。

### 2. 拥有你自己的 prompts

Prompt 是 *代码*。它属于你的 repo、属于版本控制、属于代码审查。藏在框架 prompt 库里的模板是技术债，等你升级框架那一天悄悄改变行为。如果 agent 的行为取决于一个字符串，那个字符串归你管。

### 3. 拥有你自己的上下文窗口

当前在模型上下文里的消息集合，是决定行为的最大单一因素。自动摘要、自动剪枝、自动注入记忆的框架——好用，直到不好用。自己写上下文组装逻辑。你应该能打印出送进每一次 LLM 调用的精确消息数组。

### 4. 工具就是结构化输出

"工具"不是一个魔法 Function 对象——它是一个 JSON Schema，约束 LLM 的输出形状。一旦内化这个观点，你就能造出 LLM 并不真正"执行"的"工具"：状态转换、决策分支、escalation 请求。任何需要 LLM 承诺一种 shape 的东西都能是工具。

### 5. 统一执行 state 和业务 state

你的 agent 有两个状态机：一个"我在对话哪一步"，一个"用户的订单/工单/项目处于什么阶段"。12-Factor 论证这两个应该是 *同一个* 状态机。把它们分开是"agent 以为做完了但订单还 pending"这类 bug 的最大来源。

### 6. Launch / Pause / Resume 用简单 API

你的 agent 必须能在跑到中途被暂停、之后被恢复——可能在另一台机器、可能在人工审批之后。这意味着整个 session state 必须可序列化。不能依赖 local 变量闭包魔法。不能"LLM client 对象在内存里持续保活对话"。纯数据，写到持久层。

### 7. 通过工具调用联系人类

当 agent 需要人类输入——审批、补充信息、escalation——它应该 *emit 一个 tool call*，不要原地停住。Tool call 进入人类监控的同一个队列/UI/收件箱。和因子 4 同模式，应用到人在环场景。HumanLayer 的产品就是这条原则的产品化。

### 8. 拥有你自己的控制流

"调 LLM → 跑工具 → 再调 LLM → 看是否完成 → 再调 LLM" 的 for 循环是每个 agent 的心脏。隐藏它的框架（"你只要 yield 就好，循环我们帮你管"）剥夺了你在关键点注入自定义逻辑的能力——限流、预算上限、人工 checkpoint、重试。自己写循环，二十行的事。

### 9. 把错误紧凑回上下文窗口

工具调用失败时，正确做法是把 *简短的结构化* 错误信息塞回 LLM 下一轮，让它做反应。不是 crash。不是悄悄重试。不是 log-and-pray。一条 200 字符 "TOOL_FAILED: HTTP 503 from /api/orders, payload too large" 已经足够让 LLM 做出合理的下一步——退避、试小 payload、escalate 给人类。

### 10. 小而聚焦的 agent

一个"什么都做"的巨型 agent 是 debug 噩梦。十二个小 agent，每个三个工具一个职责，可测试可恢复。这跟微服务同 pattern，同样的 trade-off：协调开销大一些，故障隔离好得多。

### 11. 哪都能触发，用户在哪你就在哪

Agent 的输入不该跟单一渠道耦合。Slack 消息、邮件、表单、GitHub issue、Telegram 机器人、cron 任务——同一个 agent。这需要因子 2（拥有 prompts）和因子 5（统一 state）先打牢，但回报是加新输入源不用重写 agent。

### 12. 让你的 agent 成为无状态 reducer

Agent 是一个纯函数：`state, event → new state, output`。无隐藏 mutation。没有"agent 因为有 self.history 属性所以记得"。所有影响输出的都在输入里。这一条让其他一切成为可能——没有这条，因子 5、6、10 都是空想。

---

## 应用到真实栈

### 应用到 [Claude Code](https://dibi8.com/zh/vs/claude-code-vs-aider/) 工作流

Claude Code 设计上已经实现了因子 1、4、7——tool call 是结构化输出，MCP server 提供人在环，工具目录归你（你项目的 MCP 配置）。需要你关注的是因子 2（system prompt 通过 CLAUDE.md 自定义）、因子 3（上下文窗口部分由 Claude 组装，但 pagefind/[CodeGraph](https://dibi8.com/zh/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/) 集成让你能塑形）、因子 9（工具返回错误时确保紧凑且结构化）。

### 应用到 [MCP 为基础](https://dibi8.com/zh/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) 的 agent 栈

MCP 把因子 4 做到极致（工具就是标准化协议上的结构化输出），并辅助因子 11（任何 MCP 客户端都能驱动任何 MCP server）。MCP 自身对因子 5、6、8、12 沉默——这些你得在 MCP 之上自己造。

### 应用到 [Hermes Agent](https://dibi8.com/zh/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) / [OpenCode](https://dibi8.com/zh/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) / 自定义栈

它们让你在因子 1、4、8 上有起步领先（内置 agent loop、结构化 tool call）。你仍需自己带因子 2（prompts）、因子 3（上下文塑形）、因子 5–6（state 持久化）、因子 12（无状态化）。

---

## 12-Factor Agents 与主流框架营销的分歧

宣言里有几条原则跟"用我们框架就忘掉细节"的话术正面对撞：

- **因子 2 vs prompt 库**：多数 agent 框架自带 prompt 库。12-Factor 说：把 prompt 复制进你 repo，然后它们归你。
- **因子 3 vs 自动记忆**：框架喜欢提供自动记忆（"开箱 RAG"）。12-Factor 说：那是"为什么 agent 在做这事"的最大单一谜团源。自己写组装逻辑。
- **因子 8 vs 隐藏循环的 runtime**：托管 runtime 隐藏循环很方便，直到你需要注入自定义逻辑。12-Factor 说：自己写循环，它很小。

这不是反框架，是反"隐藏太多"的框架。把框架当库用，不要当黑箱。

---

## 12-Factor Agents 不是什么

把期待校准好：

- **不是 runtime**。没有 `pip install twelve-factor-agents`。是文字、示例、模式。
- **不是单语言的东西**。示例是 TypeScript 和 Python，但原则语言无关。
- **不是宗教**。有些因子（特别是因子 10——小而聚焦）涉及真实 trade-off。宣言本身对此诚实。
- **未完工**。273 commit 还在涨，issue 和讨论持续迭代措辞。

---

## 谁该读

**是的，从头读到尾，如果你：**
- 在上线（或即将上线）LLM 功能给付费客户。
- 过去 60 天调过"demo 时是好的"那种 agent 事故。
- 在手撸 agent 循环和采用 LangGraph/CrewAI/Agents SDK 之间纠结。
- 在做 [Cursor 对比 Claude Code](https://dibi8.com/zh/vs/claude-code-vs-aider/) 之类的厂商对比，想要一个"生产可用"到底意味着什么的 checklist。

**可以略读，如果你：**
- 还在"第一个 agent"demo 阶段（读因子 1 和 2，以后再回来）。
- 只用托管无代码平台（n8n、Zapier），自己不写 agent 循环。

---

## 结论

12-Factor Agents 是 2026 年被引用最多的 LLM 软件宣言，原因充分：它把"过去两年里上线生产 agent 的工程师独立汇聚到的模式"用词语固化下来了。Heroku 12-Factor 的类比不是装腔——两份文档都编纂了 *真实用户依赖之后什么不再可选*。

宣言推动的最大单一思想转变：**agent 是软件，软件需要被运营它的团队理解**。隐藏这个契约的框架是技术债，不是生产力。

把 12 条因子 + [像 CodeGraph 一样的 token 效率符号层](https://dibi8.com/zh/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/) + [像 rtk 一样的成本感知 LLM 代理](https://dibi8.com/zh/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/) + [像 CC Switch 一样的统一 CLI 控制面](https://dibi8.com/zh/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) 组合起来，你就有了 2026 年生产 AI 栈的架构骨架。

---

**GitHub**：[humanlayer/12-factor-agents](https://github.com/humanlayer/12-factor-agents) · **协议**：Apache 2.0（代码）/ CC BY-SA 4.0（内容）· **Stars**：22K+ · **作者**：Dex Horthy / HumanLayer
