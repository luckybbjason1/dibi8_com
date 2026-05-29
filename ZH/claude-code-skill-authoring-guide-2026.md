---
title: 'Claude Code Skill 编写指南：如何把流程打包成 Claude 只在相关时才加载的能力（2026）'
description: '一份完整的 Claude Code skill 编写指南——SKILL.md 结构、决定加载时机的触发 description、渐进式披露，以及何时该用 skill 而非 CLAUDE.md 或子代理。附实战范例与应避免的坑。'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'Markdown', 'YAML']
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
tags: ['claude-code', 'skills', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'prompt-engineering']
aliases:
- /posts/claude-code-skill-authoring/
faq:
  - q: "skill 放在哪里？一个 SKILL.md 最少需要什么？"
    a: "一个 skill 是位于 .claude/skills/<name>/（项目级）或 ~/.claude/skills/<name>/（用户级）下的一个目录，里面包含一个 SKILL.md 文件。最低要求是一段带 name 和 description 的 YAML frontmatter，后面跟正文里的指令。该目录还可以存放 skill 所引用的支持文件——参考文档、脚本、模板——但带这两个 frontmatter 字段的 SKILL.md 才是不可再简化的核心。"
  - q: "skill 跟直接把指令写进 CLAUDE.md 有什么区别？"
    a: "CLAUDE.md 在每一次交互中都会加载——它适合放常驻、项目级的规则。而 skill 只在它的 description 匹配当前任务时才加载。CLAUDE.md 用来放『一律用 tab 缩进，绝不直接提交到 main』这类规则；skill 用来放『如何发布一个版本』或『如何排查不稳定测试』这类情境性流程——这些知识你不希望让每个 prompt 都背上，只在真正做那件事时才出现。skill 让你的基础上下文保持精简。"
  - q: "description 字段如何控制 skill 的加载时机？"
    a: "description 就是触发信号。Claude 读取各个 skill 的 description 来判断哪个 skill 与当前任务相关，然后把那个 skill 的完整正文加载进上下文。所以 description 必须用具体线索描述『何时』使用这个 skill——『在发布版本、打 tag 或准备发布说明时使用』——而不只是说它是什么。一个含糊的 description（比如『发布助手』）意味着 skill 虽然存在，却永远不会在该出手的时刻触发。"
  - q: "什么是渐进式披露？它对 skill 为什么重要？"
    a: "渐进式披露指的是 skill 先加载轻量的 SKILL.md，只在任务真正需要时才拉入更重的支持文件（详细参考、大型模板、脚本）。你把 SKILL.md 写得很短，并指向 references/big-spec.md 去存放深层细节。这能保护上下文：触发信号和概览加载成本低，便于路由判断，而昂贵的细节只在 skill 真正被启用后才进入对话。"
  - q: "skill 能包含脚本吗，还是只能放指令？"
    a: "两者都行。一个 skill 目录可以在 SKILL.md 旁边捆绑脚本（一个 Python 辅助脚本、一个 shell 脚本）、模板和参考文档。正文可以指示 Claude 运行某个捆绑脚本或读取某个捆绑参考。这正是 skill 超越一段 prompt 的地方——它是一个打包好的能力，把指令、参考资料和可执行辅助脚本全部版本化地放在一个目录里。"
  - q: "我什么时候该写子代理而不是 skill？"
    a: "当你需要教会一个在当前对话中运行的流程时，写 skill。当工作需要自己独立的上下文窗口时——大量探索、并行研究、或会拖垮父代理的独立审查——写子代理。两者可以组合：一个子代理可以在隔离运行时加载某个 skill 来遵循你的方法论。扩展决策框架里的经验法则是——skill 改变行为，子代理保护上下文，MCP server 增加能力。"
---

## 引言

在 [子代理 vs MCP vs Skill](/zh/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/) 一文中，我们画出了三轴地图：skill 拨动**知识**轴，子代理拨动**上下文**轴，MCP server 拨动**能力**轴。此后我们针对子代理这条轴发布了深度指南——[编写自定义代理](/zh/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) 和 [编排的失败模式](/zh/resources/llm-frameworks/multi-agent-pipeline-postmortem-5-failures-2026/)。本指南补齐这套三件套：如何编写 **skill** 本身。

skill 是三者中最被低估的，因为它看起来太简单了——"不就是一个 markdown 文件吗"。但一个编写精良的 skill，决定了知识究竟是*在你需要时就在那里*，还是塞进一个臃肿到每个 prompt 都要拖着 4000 个 token 规则（而当前任务根本用不上）的 `CLAUDE.md`。我们将讲解 SKILL.md 结构、决定一切的触发 description、用来保持轻量的渐进式披露、两个实战范例，以及那些让 skill 永远不触发的坑。

## Skill 到底是什么

一个 skill 是一个**目录**，而不只是一个文件：

```
.claude/skills/cut-release/
  SKILL.md            # frontmatter + instructions
  references/
    versioning.md     # heavy detail, loaded on demand
  scripts/
    bump-version.sh    # an executable the skill can run
```

`SKILL.md` 是入口点。它的 frontmatter 声明了 skill 的身份，并且——关键在于——*何时该加载*。正文存放流程。支持文件（参考、模板、脚本）放在旁边，只在需要时才被拉入。skill 放在 `.claude/skills/`（项目级，与团队共享）或 `~/.claude/skills/`（用户级，作用于你机器上的每个项目）。

## Skill vs CLAUDE.md：加载时机的问题

这是最容易让人栽跟头的抉择。两者都装指令；区别在于*何时加载*。

- **CLAUDE.md** 在**每一次**交互中加载。它适合常驻、项目级的不变量："用 tab 缩进"、"绝不强推 main"、"我们的 API 基址是 X"。
- **skill** 只在**它的 description 匹配**当前任务时加载。它适合情境性流程："如何发布版本"、"如何接入一个新服务"、"我们的事故处置手册"。

判断标准：*这条指令是否适用于关于任何主题的随机 prompt？* 如果是 → CLAUDE.md。如果它只在某种特定任务中才重要 → skill。把情境性手册硬塞进 CLAUDE.md，是头号上下文臃肿错误；每个 prompt 都在为它用不上的知识买单。

## Frontmatter：name 和 description

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a new version, tagging a build, or preparing release notes. Walks through version bump, changelog, tag, and publish steps.
---

You are helping cut a release. Follow these steps in order...
```

### `name`

kebab-case，要有描述性。这是 skill 的身份标识。

### `description`——决定一切的触发信号

Claude 读取各个 skill 的 description 来做路由：它扫描这些 description，判断哪个 skill 匹配当前任务，然后加载那个 skill 的正文。所以 description 不是一个标签——它是一个**何时触发的条件**。把它塞满具体的触发词：

> ❌ `description: Release helper.`
> ✅ `description: Use when cutting a release, publishing a version, tagging a build, or writing release notes. Covers version bump, changelog generation, git tag, and publish.`

第一个永远不会触发，因为真实任务里没有任何东西匹配 "release helper"。第二个则在用户一说出 "let's ship 2.4.0" 的瞬间就触发。如果你的 skill 存在却从不激活，元凶必定是 description——每一次都是。

## 编写正文：是流程，不是论文

正文是 skill 加载后 Claude 要遵循的指令。三条规则：

1. **要写成流程，而非散文。** 让模型按顺序执行的编号步骤，胜过一段段铺陈背景的文字。"1. 在 package.json 里提升版本号。2. 从上一个 tag 以来的提交重新生成 changelog。3. ……"
2. **把前置条件和坑就地写明。** "打 tag 之前，确认 main 上的 CI 是绿的"——就是这类人类会知道该检查的事。
3. **指向重型细节，别内联它。** 如果版本控制策略有 800 字，把它放进 `references/versioning.md`，然后写"版本提升规则见 references/versioning.md"。这就是渐进式披露，下一节讲。

## 渐进式披露：让 SKILL.md 保持轻量

这是 skill 编写中的杀手锏。SKILL.md 应该**很小**——触发信号加概览加指针。重型材料放在支持文件里，只在任务触及它们时才加载。

为什么重要：description 和概览必须加载成本低，因为它们要被扫描以做路由。那份长达 2000 字的详细规格，只有在 skill 真正被启用、任务确实需要那种深度时，才该进入上下文。一个把所有内容都内联的 skill 就背离了初衷——你又回到了 CLAUDE.md 式的臃肿，只不过换了种触发方式而已。

```markdown
## Steps
1. Bump version (see references/versioning.md for the semver rules)
2. Run scripts/changelog.sh to generate the draft
3. ...
```

Claude 只在真正需要这些规则时才读取 `references/versioning.md`，而非每次加载都读。

## 实战范例：一个发布清单 skill

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a version, or tagging a build. Covers version bump, changelog, tag, publish, and the green-CI precondition.
---

You are cutting a release. Do NOT skip the precondition check.

PRECONDITION: confirm CI is green on main. If not, stop and report.

Steps:
1. Determine the new version (semver; see references/versioning.md).
2. Bump it in package.json and any version constants.
3. Generate the changelog from commits since the last tag.
4. Open a release PR; wait for review.
5. After merge: tag, push the tag, publish.

Report which step you stopped at if anything blocks.
```

前置条件和那句"报告你停在哪一步"，正是让它达到生产级水准的东西——不只是步骤，而是一个细心的人会施加的护栏。

## 实战范例：一个领域手册 skill

```markdown
---
name: debug-flaky-test
description: Use when a test passes sometimes and fails other times, or when investigating CI flakiness, intermittent failures, or race conditions in the suite.
---

You are diagnosing a flaky test. Flakiness is almost always one of:
shared state, timing/async, test-order dependence, or external resources.

1. Reproduce: run the test 20x in isolation and 20x with the full suite.
   Different results = test-order or shared-state dependence.
2. Check for unawaited async, real timers, and fixed sleeps.
3. Check for shared mutable state between tests.
4. Only after locating the cause, propose the fix. Do not "add a retry."
```

注意其中嵌入的领域知识（四种常见成因）——那是机构经验，被打包好，让任何人都能触发那位资深工程师的思维清单。

## 常见的编写错误

- **含糊的 description。** skill 存在却从不触发。加入具体的触发短语——用户在需要它时实际会打出来的词。
- **什么都往 CLAUDE.md 塞。** 情境性流程把每个 prompt 都撑臃肿了。把它们挪进 skill。
- **内联重型细节。** 一个 2000 字的 SKILL.md。用渐进式披露——指向 `references/`。
- **写成散文而非流程。** 一个读起来像论文的 skill。把步骤编号。
- **没有护栏。** 步骤没有前置条件或停止条件。加入一个细心的人会做的检查。

## 原则

skill 是**即时调用的专业知识**。CLAUDE.md 是永远成立的东西；skill 是*当你在做这件具体的事时*才成立的东西。门道在于 description（让它在恰当时刻触发）和渐进式披露（让它在被需要前都保持低成本）。把这两点做对，你团队的流程就不再躺在没人打开的 wiki 里——它们会满载着出现，恰好在任务需要的时候，其余时候安静地待在一边。

## 搭建生产级的 Claude Code 环境

skill 在一个稳定、共享的环境里最能发光：

1. **一台可靠的主机，承载团队共享、CI 调用的工作流。** skill 是版本化的，也会在 CI 里运行。**{{< aff "htstack" "footer-cta" "HTStack" >}}**——香港 VPS，中国大陆低延迟访问，稳定 BGP。与托管 dibi8.com 的是同一个 IDC。每月 5-12 美元。

2. **应对并行运行的云端余量。** **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}**——200 美元免费额度，有效期 60 天，14+ 个区域。

3. **一份 skill 合集。** 写出好 skill 最快的办法，是去读好的 skill。我们把五个经过实战检验的 skill 打包成了 Gumroad 上 19 美元的合集——见角落里的浮动 CTA——其中的 description、渐进式披露结构、捆绑脚本都已经做对了。

## 延伸阅读

- [子代理 vs MCP vs Skill](/zh/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/)——本文补齐的那套三轴框架。
- [编写自定义代理](/zh/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/)——本指南在子代理轴上的姊妹篇。
- [AI Agent Skills 2026 开发者指南](/zh/resources/llm-frameworks/ai-agent-skills-2026-developer-guide/)——更广阔的 skill 生态。
- [子代理模式](/zh/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)——skill 如何与委派的工作者组合。

## 结论

skill 是最便宜、最被低估的扩展点——一个带 markdown 文件的目录，把情境性专业知识变成即时调用的上下文。整门手艺归结为两件事：一个塞满真实触发短语的 **description**，让它在恰当时刻触发；以及**渐进式披露**，让它在任务需要其深度之前都保持轻量。把这两点写好，你就打包出了一个流程，你的整个团队——以及每一次 CI 运行——都能免费获得它，恰好在它相关的时候出现。这便补齐了三件套：skill 管知识，子代理管上下文，MCP server 管能力。
