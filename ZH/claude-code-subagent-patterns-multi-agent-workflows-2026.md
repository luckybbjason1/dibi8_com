---
title: 'Claude Code 子智能体（Subagent）实战：5 个每天省下数小时的多智能体工作流（2026）'
description: '5 个生产环境实测过的 Claude Code subagent 模式 —— 并行调研、worktree 隔离、专家委派、上下文保护、流水线编排，含真实 prompt 和取舍说明。'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Bash']
application_domain: LLM Frameworks
source_version: ''
licensing_model: 商业（Anthropic）
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
tags: ['claude-code', 'subagents', 'multi-agent', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'agent-sdk']
aliases:
- /posts/claude-code-subagent-patterns/
faq:
  - q: "Claude Code 的 subagent 到底是什么？跟另开一个 CLI 进程有什么区别？"
    a: "Subagent 是在当前 Claude 会话里通过 Agent (Task) 工具派生出来的沙箱化 Claude 对话。父会话只看到 subagent 最终的报告 —— 看不到中间的工具调用、文件读取或思考过程。这正是它和另开 CLI 的关键区别：父会话的上下文窗口不会被 subagent 的探索噪音污染。Subagent 适合并行调研、深度代码探索、隔离实验 —— 这些场景里你不想让父的工作记忆被搞乱。"
  - q: "什么时候不应该用 subagent，就在父会话里干就行？"
    a: "琐碎查找（父会话已经把文件打开或上下文已经在了）、需要看到每一步中间状态的串行编辑、需要反复来回交互的紧耦合改动（subagent 是一次性的 —— 只返回单个报告）—— 这些都跳过 subagent。经验法则：如果你从当前状态出发 3 次工具调用以内能完成，就直接做。"
  - q: "怎么安全地并行跑多个 subagent？"
    a: "在一条消息里发起多个 Agent 工具调用，harness 会并发扇出。安全要点：传递不重叠的范围（比如 'subagent A 审计 /auth/，B 审计 /payments/'），避免两个 subagent 写同一个文件，对涉及非平凡编辑且代码有重叠的场景使用 git worktree（每个 worktree 给一个 subagent 独立工作目录避免互扰）。"
  - q: "Subagent 驱动开发要警惕的失败模式是什么？"
    a: "Subagent 返回的是摘要 —— 它描述的是它打算做什么，不一定是它实际做了什么。最常见的失败是把 subagent 的报告当真理而不去验证。永远检查实际的文件改动（git diff）或测试结果，别只看散文摘要。一个 subagent 声称『我重构了 auth 模块』可能只做了浅层编辑 —— 类型检查能过但运行时逻辑坏了。"
  - q: "我能自己造专用 subagent 吗？还是只能用内置的？"
    a: "Claude Code 通过 Agent SDK 和 agent frontmatter 文件支持自定义 agent 定义。你可以把团队专用的 'database-migration-reviewer' 或 'security-auditor' 写成 markdown 文件，包含 description、system prompt 和工具白名单。父 agent 决定委派时可以选你自定义的类型。团队就是用这种方式把审查清单、合规门禁、领域专长编码成可复用的 agent 角色。"
  - q: "Claude Code subagent 怎么计费 —— 每个都单独收费吗？"
    a: "每次 subagent 调用都和其他 Claude 对话一样消耗 token。成本约等于 subagent 的完整上下文（系统 prompt + 工具 schema + 任务 prompt + 思考 + 最终报告）。Pro 和 Max 套餐里，subagent 使用计入父会话同一个用量额度。API 用户就是按 token 直接计费。省钱点在于把会膨胀父上下文的探索工作卸载出去 —— 你付 subagent 的钱，换主会话保持轻快聚焦。"
---

## 引言

2025 年底，单线程 AI 编程撞了墙。你让 Claude "重构支付模块"，它读 30 个文件，把上下文窗口塞满探索内容，然后用一半的工作记忆开始改代码。半年加一次范式转变后，答案竟然简单到尴尬：**别在一个对话里干所有事**。

本文带你过 5 个已在日常生产中证明价值的 Claude Code subagent 模式 —— 横跨个人独立开发者工作流、多人工程团队、AI 辅助研究流水线。每个模式都包含实际 prompt 结构、能避开的失败模式、采用它要接受的取舍。这些都不是理论。这是我们日常用来更快交付且不烧爆上下文窗口的真实模式。

如果你已经在用 Claude Code [官方 CLI](https://docs.anthropic.com/en/docs/claude-code)，想从"一个大对话"毕业到协同多智能体工作流，这就是 playbook。对比 [Superpowers 框架](/zh/resources/llm-frameworks/superpowers/) 和 [Aider 的单 agent 模型](/zh/vs/claude-code-vs-aider/) 看看 subagent 路线在哲学上有什么不同。

## 模式 1：并行调研扇出

**问题。** 你要回答"代码库里哪里处理 X？"、"我们处理 Y 的模式是什么？"、"还有谁在用废弃函数 Z？" —— 3 个独立问题。串行做意味着 3 轮文件读取和 3 次上下文窗口注入。等你拿到 3 个答案，父会话已经塞了 40k token 的 grep 输出，根本没空间做实际工作了。

**模式。** 在并行里派出 3 个 Explore subagent，每个一道问题。每个跑在自己的沙箱上下文里。每个返回简短报告。父看到 3 个简洁段落而不是 3 个 grep 倾倒。

```
单条消息 → 3 个 Agent 工具调用：
  - Agent("查找 auth 处理器", subagent_type="Explore", prompt="...")
  - Agent("映射状态管理", subagent_type="Explore", prompt="...")
  - Agent("查找废弃函数 Z 引用", subagent_type="Explore", prompt="...")
```

**避开的失败模式。** 上下文窗口膨胀。父会话保持轻盈，能继续承载实际的实现对话。

**取舍。** 你为 3 次 subagent 调用付钱，而不是一次父对话。对非平凡搜索来说账面是赢的 —— Explore subagent 在多个工具上扇出，只返回综合后的答案。

## 模式 2：风险编辑的 worktree 隔离

**问题。** 你想让 subagent 尝试一次重构，但如果跑歪了你不想手动 `git reset --hard`。你还想让 subagent 能跑测试，又不干扰你在主 worktree 上的当前改动。

**模式。** 在 Agent 调用上使用 worktree 隔离参数。Subagent 在从你当前状态分出的临时 git worktree 里工作。如果它做了改动，你拿回 worktree 路径，可以随时审查、cherry-pick 或弃用。如果它没做改动，worktree 自动清理。

```
Agent({
  description: "尝试 controller 级别重构",
  isolation: "worktree",
  prompt: "重构 controllers/orders.rb 提取校验逻辑..."
})
```

**避开的失败模式。** 半完成的重构在你来得及评估前污染工作树。

**取舍。** 有些场景 —— 比如加一个父立即要调用的单个函数 —— worktree 隔离没有意义，因为你最终还得 merge 回去。这个模式留给探索性或高风险改动。

## 模式 3：专家委派

**问题。** 代码审查、安全审计、可访问性审计、SQL 查询优化 —— 都受益于聚焦心态，但你同时也在写功能时很难维持这种心态。通用 Claude 这些都能干，但专用 prompt 做得更好。

**模式。** 用 `subagent_type` 参数委派给专家。`code-reviewer` subagent 读 diff 并按置信度报告发现。security-auditor 戴着威胁建模眼镜读同样的 diff。你留在父会话里继续做功能。

```
Agent({
  description: "独立代码审查",
  subagent_type: "code-reviewer",
  prompt: "审查 feat/payment-gateway 分支上的改动。我想要个对重试逻辑的
   第二意见 —— 我已经检查过幂等性但想要独立验证。报告：并发失败
   下这是否安全？"
})
```

**避开的失败模式。** "我写的所以肯定对"的盲点。一个没有你对话上下文的独立 agent 是真正独立的。

**取舍。** 专家的工具集比通用 agent 窄。别让 code-reviewer 顺便生成迁移脚本。

## 模式 4：长会话的上下文窗口保护

**问题。** 你已经调试了 4 小时。父上下文塞满了堆栈、日志倾倒、死胡同假设分支。你需要"去查一下某事"，要读 8 个文件。在线做会把你推入压缩 —— 你会丢掉那个承载调试状态的关键上下文。

**模式。** 把父会话当作战略层，把每次探索性深潜推到 subagent。父说"去搞清楚 X" —— subagent 返回"答案是 Y，证据一行"。你的调试状态保持完整。

这个模式回本最快。一次本来会在 1 小时碰上下文压缩的两小时调试会话，把探索卸载出去后能跑满全程。

**避开的失败模式。** 调试中途的过早上下文压缩 —— 这经常会丢掉原始症状或关键复现步骤。

**取舍。** 你失去"看见"探索过程的能力。如果 subagent 报告不完整，你得用更紧的 prompt 再派一个，而不是追问。

## 模式 5：自定义 agent 的流水线编排

**问题。** 你的团队有写好的 8 步审查清单。初级工程师赶时间时会跳过第 3、5、7 步。你想强制执行清单又不想自己变成 PR 审查警察。

**模式。** 把清单编码成你 repo 里的自定义 subagent。任何装了 Claude Code 的人都可以调用。清单变成可执行的：它针对每个步骤生成结构化报告。

```
.claude/agents/migration-reviewer.md  # 自定义 subagent 定义
.claude/agents/security-gate.md
.claude/agents/perf-budget-checker.md
```

团队成员运行编排器时，它能扇出到全部 3 个：migration-reviewer 审计 SQL，security-gate 审计 auth 触碰点，perf-budget-checker 审计任何碰请求热路径的改动。每个返回结构化报告。编排器聚合。

**避开的失败模式。** "团队审查标准"和"赶时间时实际被检查的内容"之间的漂移。

**取舍。** 自定义 agent 是被版本控制的工件，需要像其他代码一样维护。定个季度审查否则它们会腐烂。

## 底层原则

5 个模式共享一个设计直觉：**父对话是稀缺资源，subagent 是花钱而不耗尽它的方式**。父是模型做重要思考的地方。Subagent 是它在不用工作记忆付费的前提下拿到输入的方式。

这跟 2024-2025 年初主导的"一个超级 agent 干所有事"直觉正相反。那个模型在上下文压力下崩了。2026 年的答案是带严格信息边界的委派化专业分工 —— 小议会而不是单一头脑。

## 搭建生产级 Claude Code

要在规模化跑多 agent 工作流，你需要 3 块基础设施：

1. **长会话的可靠主机。** 如果你在 CI 里跑 Claude Code 或对服务端代码库操作，你需要不会掉 SSH 或被限流的 VPS。**{{< aff "htstack" "footer-cta" "HTStack" >}}** —— 香港 VPS，从中国大陆访问低延迟，BGP 路由稳。这就是 dibi8.com 自己跑的同一个 IDC，我们在它上面跑自己的多 agent 流水线。$5-12/月的扎实档位。

2. **并行实验的云端 playground。** 你扇出 6+ 个 subagent 每个都要自己 worktree 时，你需要富余 CPU。**{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** —— 60 天 $200 免费额度，14+ 全球区域。独立开发者用它把 Claude Code 编排器和主应用放一起跑不会资源争抢。

3. **Skills 套装。** 如果你刚接触 Claude Code subagent，曲线最陡的部分是写不翻车的自定义 agent 定义。我们把 5 个实战 skill 打包成 $19 的 Gumroad 套装 —— 看右下角的浮动 CTA —— 里面有上面模式所用的 orchestrator prompt 模板。

## 延伸阅读

- [OpenAI Codex CLI vs Claude Code](/zh/vs/openai-codex-cli-vs-claude-code/) —— Codex 的单 agent 路线对比 Claude Code 的 subagent 模型。
- [Gemini CLI vs Claude Code](/zh/vs/gemini-cli-vs-claude-code/) —— Gemini 的并行调研策略 vs Claude Code subagent 扇出。
- [Cursor vs Claude Code](/zh/vs/cursor-vs-claude-code/) —— IDE 内嵌 agent vs CLI 驱动 orchestrator。
- [MCP 服务器 2026 排名](/zh/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) —— MCP 服务器如何把 subagent 能力扩展到内置工具集之外。
- [AI 编程 agent 全景](/zh/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) —— 更宏观的生态画像。

## 结论

2026 年，subagent 不再是可选项。如果你还在一个 Claude 对话里干所有任务，你就在花钱买"过早上下文压缩 + 推理状态丢失"的权利。上面 5 个模式 —— 并行扇出、worktree 隔离、专家委派、上下文保护、流水线编排 —— 每个学起来大约 1 小时，每个每周省下几倍时间。

从模式 1（并行调研扇出）开始 —— 这是采用门槛最低、收益最快的点。随着会话变长、任务变重，再加上其他模式。

"就继续在主会话里输入"的本能死得艰难。压制它。派出 subagent。
