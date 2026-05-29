---
title: 'Claude Code 自定义 Agent 编写指南：打造强制执行团队规范的可复用子智能体（2026）'
description: '完整的 Claude Code 自定义子智能体编写指南——frontmatter 字段、系统提示词设计、工具白名单，以及两个可直接投产的范例（迁移审查器、安全闸门），附带要避开的坑。'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Markdown', 'YAML']
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
tags: ['claude-code', 'subagents', 'custom-agents', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/claude-code-custom-agent-authoring/
faq:
  - q: "自定义 agent 的定义文件放在哪里？是什么格式？"
    a: "自定义 agent 是带 YAML frontmatter 的 Markdown 文件，存放在项目里的 .claude/agents/ 目录（或 ~/.claude/agents/ 用于希望在所有项目中都可用的 agent）。文件名去掉 .md 后缀并不是 agent 的身份——frontmatter 里的 name 字段才是。frontmatter 声明 name、description、可选的 tools 白名单和可选的 model；结尾 --- 之下的全部内容就是 agent 的系统提示词。"
  - q: "description 字段和系统提示词正文有什么区别？"
    a: "description 是路由信号：父 agent 在决定是否委派时读的就是它，所以它必须说清楚『何时』使用该 agent，而不只是它是什么。系统提示词正文则是 agent 被调用后运行的指令集——它的角色、方法、输出契约。description 出色但正文含糊，会在对的时机被触发却干出平庸的活；正文出色但 description 含糊，会干出色的活却永远不被触发。"
  - q: "我该给自定义 agent 开放所有工具，还是限制它们？"
    a: "限制它们。省略 tools 字段会授予继承来的全部工具集，方便但对那些本不该写入或执行的 agent 很危险——一个拥有 Write 和 Bash 权限的 code-reviewer 会『热心地』把自己的建议直接应用上去，独立审查的意义就没了。声明最小集：审查器给 Read、Grep、Glob；迁移审计器再加一个只读数据库查询工具（如果你有）。最小权限让 agent 的行为可预测。"
  - q: "怎么在不污染真实项目的情况下测试自定义 agent？"
    a: "建一个临时分支或 git worktree，里面放一个已知有问题的样例（缺索引的迁移、有逻辑漏洞的鉴权改动），然后对它调用 agent。你在验证两件事：自然语言请求能否触发它（description 质量），以及它能否抓到你埋的问题（系统提示词质量）。frontmatter 和正文要分开迭代——它们出问题的原因不同。"
  - q: "自定义 agent 能调用其他子智能体，或派生自己的子智能体吗？"
    a: "不能。子智能体只有一层深——子智能体无法再派生更深的子智能体。这是防止失控扇出的刻意护栏。如果你需要多阶段编排，由父（顶层）agent 协调：它调用 agent A、读取结果、再调用 agent B。把你的自定义 agent 设计成单一职责的工作者、返回结构化报告，让顶层的编排者去给它们排序。"
  - q: "自定义 agent 在 CI 和无头运行里能用吗，还是只能交互式？"
    a: "两者都能用。同一份 .claude/agents/ 定义在你非交互运行 Claude Code 时（CI 里用的 -p / print 模式）也会被识别。因为它们是仓库里受版本控制的文件，每个队友、每个 CI 任务看到的都是完全相同的 agent 定义——这正是把审查清单编码成 agent、而不是写成一个没人会打开的 wiki 页面的全部意义。"
---

## 引言

在 [Claude Code 子智能体五大模式](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) 一文里，我们讲了五种善用上下文窗口的工作流——其中第五个，**用自定义 agent 做流水线编排**，是团队问得最多的。"把你的审查清单编码成子智能体"听起来很美，直到你打开一个空白的 `.claude/agents/migration-reviewer.md`，面对一个闪烁的光标。

这篇指南就是那本缺失的手册。我们会走一遍自定义 agent 定义的解剖结构、每个 frontmatter 字段到底控制什么、怎么写出能产出结构化报告而非啰嗦闲聊的系统提示词、为什么工具白名单比看起来重要、以及两个完整、可直接投产、今天就能抄走的范例。然后讲坑——因为这里的失败模式很微妙，而且第一次漏掉明显问题时，你对这个 agent 的信任就崩了。

如果你从没委派过子智能体，先读 [模式篇](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)。如果读过、准备好做自己的了，这就是你的实操手册。

## 自定义 Agent 的解剖结构

一个自定义 agent 就是一个带 YAML frontmatter 的 Markdown 文件。它住在两个位置之一：

- `.claude/agents/<name>.md` —— 项目级、受版本控制、与全团队共享
- `~/.claude/agents/<name>.md` —— 用户级、在你机器上的每个项目里都可用

结构极其简单：

```markdown
---
name: migration-reviewer
description: Reviews database migrations for safety. Use when a PR touches db/migrate/, schema files, or any SQL DDL.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. Your job is to catch unsafe
migrations before they reach production...
```

结尾 `---` 之上的全是配置，之下的全是**系统提示词**——子智能体运行时的人设与指令集。这就是全部契约。没有构建步骤、没有注册、没有插件清单。把文件放进去，运行 `/agents` 确认 Claude Code 识别到了，就能调用。

## Frontmatter 字段

四个字段完成全部工作。其中三个是可选的，但默认值很少是你认真做一个 agent 时想要的。

### `name`（必填）

agent 的身份——这是父 agent 作为 `subagent_type` 传入的字符串。保持 kebab-case 且有描述性：用 `security-auditor`，别用 `agent2`。文件名是表面的；`name` 字段才是规范来源。

### `description`（必填——也是最被低估的）

这是**路由信号**。父 agent 决定是否委派时，读的是 description，不是系统提示词。所以 description 必须用具体的触发条件编码出『何时』该找这个 agent：

> ❌ `description: A code reviewer.`
> ✅ `description: Reviews code changes for correctness and security. Use proactively after writing a non-trivial diff, before committing, especially for auth, payments, or concurrency-sensitive code.`

"proactively"（主动地）这个词是承重的——它推动父 agent 不必被明确要求就主动调用。如果你的 agent 似乎从不触发，几乎总是 description 的问题。

### `tools`（可选——但还是声明上）

逗号分隔的白名单。省略它，agent 就继承父 agent 拥有的每一个工具。我们会用一整节讲为什么这通常是错的。

### `model`（可选）

钉死一个档位：`haiku` 用于便宜的机械化处理，`sonnet` 用于均衡的审查工作，`opus` 用于深度推理。一个高频的 linter 式 agent 用 `haiku` 能把成本压住；一个漏掉就代价高昂的安全审计器配 `opus`。

## 编写系统提示词

正文是大多数 agent 成败的地方。三条规则能产出可靠的工作者：

**1. 第一句就说明角色和边界。**"You are a migration reviewer. You do not write code or apply fixes — you report findings."告诉 agent 什么『不』该做，和告诉它工作本身一样重要。

**2. 明确输出契约。**含糊的提示词产出散文；你要的是结构。把它写死：

```markdown
Report your findings as a list. For each issue:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM: one sentence
- FIX: the concrete change
End with a one-line VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

**3. 给它清单，不是感觉。**"审查安全性"是个愿望。把要检查的内容逐条列出——agent 会确定性地走完你的清单，这正是把它编码下来的全部价值。

## 工具白名单：给 Agent 立最小权限

这里有个陷阱。把 `tools` 留空，你的"审查器"就继承了 `Write`、`Edit`、`Bash`。它第一次发现问题时，可能就"热心地"修了——改动你的工作树、运行命令，毁掉了让这次审查有价值的那份独立性。

解法是最小权限。让工具匹配职责：

| Agent 类型 | 工具 |
| --- | --- |
| 审查器 / 审计器 | `Read, Grep, Glob` |
| 调研器 / 探索器 | `Read, Grep, Glob, WebSearch, WebFetch` |
| 测试运行器 | `Read, Grep, Glob, Bash` |
| 修复器（罕见、刻意） | `Read, Edit, Bash` |

一个只读的审查器字面上『无法』乱来。这份可预测性，正是让你不必复查它碰过的一切就敢信它报告的原因。（如果你之后通过 [MCP 服务器](/zh/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) 接入外部系统，同样的纪律适用——只授予 agent 真正需要的 MCP 工具。）

## 实战范例：迁移审查器

```markdown
---
name: migration-reviewer
description: Reviews database migrations for production safety. Use proactively when a change touches db/migrate/, schema.rb, or any SQL DDL file.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. You do NOT edit files or run
migrations — you read the proposed migration and report risks.

Check every migration against this list:
1. Adding a column with a NOT NULL constraint and no default on a large table (locks).
2. Adding an index without CONCURRENTLY (blocks writes).
3. Renaming or dropping a column still referenced by application code.
4. A data backfill running inside the same transaction as the schema change.
5. Missing a corresponding rollback / down path.

Report findings as:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM / FIX
End with VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

用自然语言请求从父 agent 调用它——"审查这个分支上的迁移"——因为 description 点名了 `db/migrate/`，父 agent 会自己路由过去。

## 实战范例：安全闸门

```markdown
---
name: security-gate
description: Threat-models diffs that touch authentication, authorization, secrets, or user input. Use proactively before merging any auth or payments change.
tools: Read, Grep, Glob
model: opus
---

You are a security reviewer with a threat-modeling mindset. Assume the
input is hostile. You report only — you never modify code.

For the diff, check:
- Authn/authz: can this path be reached without the expected check?
- Injection: is user input concatenated into SQL, shell, or HTML?
- Secrets: any key, token, or password added to code or logs?
- IDOR: are object references scoped to the authenticated user?

For each finding give an EXPLOIT SKETCH (how an attacker triggers it),
then the FIX. Default to flagging when uncertain — false positives are
cheap, a missed auth hole is not.
```

注意 `opus` 档位和"不确定时默认标记"的指令——对安全闸门，你要往偏执方向调。

## 测试与迭代 Agent

别上线一个你没试图骗过的 agent。开一个 [git worktree](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) 或临时分支，里面放一个『埋好』的问题——缺 `CONCURRENTLY` 的迁移、缺所有权检查的接口——然后调用 agent。

你在测两件互相独立的事：

- **它被自然请求触发了吗？**没有就改 `description`。
- **它抓到你埋的 bug 了吗？**没有就改系统提示词的清单。

这俩出问题的原因不同，所以分开迭代。一个常见的意外：你显式点名时 agent 工作完美，但从不自己触发——那永远是 description 问题，不是正文问题。

## 常见编写错误

- **description 含糊。**agent 干着没人触发的好活。加上具体文件路径和"proactively"。
- **没有工具白名单。**你的审查器把本该审查的代码改了。声明 `Read, Grep, Glob`。
- **散文输出、无契约。**你拿到三段意见而非分级清单。明确指定报告格式。
- **一个巨型 agent。**单个"啥都干"的 agent 不过是带额外步骤的父 agent。按关注点拆分——那就是 [专家委派模式](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) 在为你工作。
- **建完即忘。**agent 是代码。无人维护的清单会随着技术栈变化而腐烂。每季度审一次。

## 底层原则

一个自定义 agent 就是**可执行的组织知识**。那个曾经躺在没人打开的 wiki 页里、或装在那位总能抓到 bug 的资深工程师脑子里的审查标准——你把它编码一次、纳入版本控制，于是每个队友加每次 CI 运行，都得到完全相同、不知疲倦的审查器。这个 agent 不会因为 deadline 临近就赶工跳过第 3、5、7 步。是这份一致性，而不是原始智能，才是真正的胜利。

## 搭建生产级 Claude Code

要大规模运行自定义 agent 流水线，你需要稳定的基础设施：

1. **一台跑长会话和 CI 的可靠主机。**自定义 agent 在 CI 里最闪光，它在那儿为每个 PR 把关。你需要一台不会掉任务的机器。**{{< aff "htstack" "footer-cta" "HTStack" >}}** —— 香港 VPS，从中国大陆低延迟接入、BGP 路由稳定。它就是托管 dibi8.com 的同一个 IDC，我们自己的 agent 流水线就跑在上面。性价比档位 $5-12/月。

2. **跑并行闸门的云端余量。**当编排者同时扇出 migration-reviewer + security-gate + perf-checker 时，你想要富余的 CPU。**{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** —— 60 天 $200 免费额度、覆盖 14+ 区域，很适合把 CI runner 放在你的应用旁边。

3. **一个技能包。**最陡的那段曲线，是写出不会翻车的 agent 定义。我们把五个实测过的技能打包成 Gumroad 上的 $19 bundle——见角落的浮动 CTA——里面含编排者提示词，外加另外三个可直接上线的 agent 定义。

## 延伸阅读

- [Claude Code 子智能体五大模式](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) —— 五大工作流；本指南深挖第 5 个。
- [Superpowers 框架](/zh/resources/llm-frameworks/superpowers/) —— 一个可供学习的技能/agent 精选库。
- [MCP 服务器 2026 榜单](/zh/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) —— 把 agent 能力扩展到自带工具之外。
- [AI 编程 Agent 全景](/zh/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) —— 自定义 agent 在更大生态里的位置。

## 结论

自定义 agent 把团队的最佳实践，从没人读的文档，变成在每次改动上都运行的检查。配方是：一个犀利的 **description** 让它触发、一个最小权限的**工具白名单**让它待在本分内、一个带显式清单和输出契约的**系统提示词**让它产出你能据以行动的报告。

从一个开始——上面那个迁移审查器，对多数团队是杠杆最高的第一个 agent。埋一个 bug、确认它能抓到、然后提交文件。从那一刻起，每个队友都有了一个永不疲倦、永不跳步的审查器。
