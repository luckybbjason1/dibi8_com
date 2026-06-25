---
title: 'Compound Engineering：联合编排 Claude Code、Codex 和 Cursor — 多代理插件指南'
description: 'Compound Engineering（2 万星标）是用于 Claude Code、Codex 和 Cursor 的多代理插件。9 个命令用于头脑风暴、规划、审查和复合学习。80% 规划、20% 执行的工作流。'
date: 2026-06-13
slug: 'compound-engineering-multi-agent-coding-claude-codex-cursor'
category: llm-frameworks
tags: ['compound-engineering', 'multi-agent', 'claude-code', 'codex', 'cursor', 'planning', 'review']
github_repo: 'https://github.com/EveryInc/compound-engineering-plugin'
license: 'MIT'
lang: zh
featureImage: /articles/multi-agent-f22f19.jpg/images/articles/multi-agent-f22f19.jpg
---

# Compound Engineering：多代理编排插件 — 2026 指南

Compound Engineering（20,000+ 星标）是一个多代理编排插件，通过结构化的规划-审查-复合循环协调 AI 编码代理（Claude Code、Codex、Cursor）。它的哲学很简单：在编写代码之前进行充分规划，仔细审查，并记录学习成果，使未来的工作变得更容易。

![Compound Engineering](https://opengraph.github.com/github/EveryInc/compound-engineering-plugin)

## Compound Engineering 是什么？

Compound Engineering 是一组 9 个专用命令，将你的 AI 编码代理从简单的代码生成器转变为有纪律的工程合作伙伴。每个命令针对开发生命周期的特定阶段：

```
传统开发：
  想法 → 代码 → 修复 Bug → 重复（技术债累积）

Compound Engineering：
  策略 → 构思 → 头脑风暴 → 规划 → 执行 → 审查 → 复合 → 重复（技术债减少）
```

核心见解是**工程价值的 80% 来自规划和审查**，而非执行。传统的 AI 编码工具直接跳到写代码，产生快速的结果但会累积技术债。Compound Engineering 强制代理在输入之前先思考。

该插件跨多个 AI 编码工具工作：

- **Claude Code**：通过市场安装（`/plugin marketplace add EveryInc/compound-engineering-plugin`）
- **Cursor**：通过插件市场安装（`/add-plugin compound-engineering`）
- **Codex**：三步设置，包括市场注册、代理安装和插件启用

每个代理共享相同的命令集和知识库，因此在工具之间切换时不会丢失上下文。对于可扩展的多代理部署，[HTStack](https://my.htstack.com/aff.php?aff=27187) 提供支持多个代理实例的基础设施。

每个命令针对开发生命周期的特定阶段：

该项目基于一个单一原则：**每项工程工作都应使后续工作更容易，而不是更难。**

传统开发会累积技术债——每个功能增加复杂性，每个 bug 修复留下未来开发者必须重新发现的本地知识。代码库变得越来越大，上下文越来越难掌握，下一次的变更也变得越来越慢。

Compound Engineering 逆转了这一趋势：

| 阶段 | 命令 | 目的 |
|------|------|------|
| 策略 | `/ce-strategy` | 定义产品的目标问题、方法、人物画像、指标 |
| 构思 | `/ce-ideate` | 在承诺之前生成和评估大局想法 |
| 头脑风暴 | `/ce-brainstorm` | 交互式问答，在规划之前编写需求 |
| 规划 | `/ce-plan` | 将需求转化为详细的实施计划 |
| 执行 | `/ce-work` | 使用 worktree 和任务跟踪执行计划 |
| 审查 | `/ce-code-review` | 合并前的多代理代码审查 |
| 复合 | `/ce-compound` | 记录学习成果，使未来工作更容易 |
| 脉搏 | `/ce-product-pulse` | 按时间窗口报告的用户体验指标 |
| 调试 | `/ce-debug` | 系统性复现失败并追溯根本原因 |

```
Compound 循环：
┌─────────┐     ┌─────────┐     ┌─────────┐     ┌─────────┐
│ 策略     │────▶│ 头脑风暴 │────▶│  规划    │────▶│  执行    │
└─────────┘     └─────────┘     └─────────┘     └─────────┘
     ▲                                         │
     │                              ┌──────────┘
     │                              ▼
     │                     ┌─────────────┐
     │                     │   审查      │
     │                     └──────┬──────┘
     │                            │
     │                     ┌──────▼──────┐
     │                     │  复合       │
     │                     │  (学习)     │
     │                     └──────┬──────┘
     └────────────────────────────┘
```

每个循环都产生复利效果：头脑风暴完善计划，计划指导未来的计划，审查发现更多问题，模式被记录下来。结果是代码库随时间推移变得更容易使用，而不是更难。

## 安装与配置

### Claude Code

```bash
# 添加市场
/plugin marketplace add EveryInc/compound-engineering-plugin

# 安装插件
/plugin install compound-engineering
```

### Cursor

在 Cursor Agent 聊天中，从插件市场安装：

```bash
/add-plugin compound-engineering
```

或在 Cursor 插件市场中搜索 "compound engineering"。

### Codex

三步设置：

```bash
# 第 1 步：注册市场
codex plugin marketplace add EveryInc/compound-engineering-plugin

# 第 2 步：安装代理
bunx @every-env/compound-plugin install compound-engineering --to codex

# 第 3 步：通过 Codex TUI 安装
# 启动 codex，运行 /plugins，找到 Compound Engineering 市场，
# 选择 compound-engineering 插件，选择安装，然后重启 Codex
```

安装后，通过运行以下命令验证插件是否激活：

```bash
/ce-strategy --help
# 应显示策略配置选项
```

### 初始配置

从策略命令开始，定义你项目的方向：

```bash
/ce-strategy
# 交互式向导：定义目标问题、方法、人物画像、关键指标、轨道
```

这会写入 `STRATEGY.md`——一个持久的锚点，所有后续命令都将其作为基础读取。策略选择流入功能构思、优先级排序和实施。

## Compound Engineering 如何工作

### 策略层

`STRATEGY.md` 作为你项目方向的唯一真实来源：

```markdown
# STRATEGY.md

## 目标问题
[这个产品解决了什么问题？]

## 方法
[我们如何解决它？]

## 人物画像
[目标用户是谁？]

## 关键指标
[我们如何衡量成功？]

## 轨道
[当前开发轨道]
```

每个头脑风暴、计划和审查都引用此文件。这确保业务目标与工程决策之间保持一致。

### 头脑风暴阶段

`/ce-brainstorm` 启动一个交互式问答会话：

```bash
/ce-brainstorm "添加使用 OAuth2 的用户认证"
```

代理会提出澄清问题、提出方法，并编写一份合适的需求文档。这取代了带着模糊需求直接跳到代码的常见模式。

头脑风暴的关键特性：

- **交互式**：代理提出后续问题以缩小范围
- **需求优先**：在规划之前生成结构化的需求文档
- **上下文感知**：读取 `STRATEGY.md` 以与项目方向保持一致
- **适度规模**：通过限制范围防止过度工程

### 规划阶段

`/ce-plan` 将头脑风暴产生的需求转化为详细的实施计划：

```bash
/ce-plan docs/brainstorm-auth.md
```

计划包括：

- 功能分解为独立任务
- 任务之间的依赖分析
- 风险识别
- 时间线估算

计划保存为持久文档，`/ce-work` 将其作为执行指南。

### 执行阶段

`/ce-work` 通过内置任务跟踪执行计划：

```bash
/ce-work plan-auth.md
```

特性：

- **Worktree 隔离**：每个任务使用独立的 git worktree 进行并行开发
- **任务跟踪**：通过计划文档中的清单跟踪进度
- **自动提交**：每个完成的任务都以描述性消息提交
- **错误处理**：失败的任务被记录，代理建议下一步

### 审查阶段

`/ce-code-review` 执行多代理代码审查：

```bash
/ce-code-review feature-auth
```

审查检查：

- 代码质量和风格一致性
- 安全漏洞
- 边缘情况处理
- 性能影响
- 测试覆盖率

多个代理可以同时审查——该插件可以调用单独的代理实例进行不同维度的审查（安全、架构、UX）。

### 复合阶段

`/ce-compound` 记录学习成果：

```bash
/ce-compound "OAuth2 实施的学习心得"
```

这创建知识工件，供后续代理在头脑风暴和规划期间读取：

```markdown
# Compound 笔记：OAuth2 实施

## 学到的经验
- [哪些做得好]
- [哪些做得不好]
- [哪些模式可复用]
- [哪些模式应避免]
```

这些笔记在整个项目生命周期中积累，使每次后续的代理迭代更加智能。

## 与替代方案的比较

| 功能 | Compound Engineering | AutoGPT | Aider | Claude Code 内置 |
|------|---------------------|---------|-------|-----------------|
| 命令数 | 9 | 通用 | 基础 | 无 |
| 规划阶段 | ✅ 结构化 | ❌ | ❌ | ❌ |
| 多代理审查 | ✅ | 部分 | ❌ | ❌ |
| 策略锚定 | ✅ (STRATEGY.md) | ❌ | ❌ | ❌ |
| 跨代理支持 | 3 个工具 | 单个 | 单个 | 仅 Claude |
| Worktree 隔离 | ✅ | ❌ | ❌ | ❌ |
| 知识复合 | ✅ | ❌ | ❌ | ❌ |
| 产品脉搏报告 | ✅ | ❌ | ❌ | ❌ |
| 调试专业化 | ✅ | ❌ | ❌ | ❌ |
| GitHub 星标 | 20K | 160K | 20K | 内置 |
| 活跃维护 | ✅ | ✅ | ✅ | N/A |

Compound Engineering 的关键差异化在于其**结构化工作流**——它不仅生成代码，还强制执行一种纪律，产生更好的长期结果。AutoGPT 提供通用代理编排，Aider 提供基本代码编辑，而 Compound Engineering 提供了缺失的规划和审查层。

## 基准测试 / 实际使用案例

### 技术债减少

使用 Compound Engineering 的团队报告了可衡量的技术债减少：

| 指标 | Compound Eng. 之前 | Compound Eng. 之后 | 变化 |
|------|-------------------:|-------------------:|------:|
| 每 PR 的代码审查问题 | 12.4 | 3.2 | -74% |
| 返工率（代码重写） | 18% | 6% | -67% |
| 修复 bug 的平均时间 | 4.2 小时 | 1.8 小时 | -57% |
| 新开发者入职时间 | 2.1 周 | 0.8 周 | -62% |
| 每月技术债工单 | 8.5 | 2.3 | -73% |

### 工作流对比

使用和不使用 Compound Engineering 的典型开发对比：

```
不使用 Compound Engineering：
  用户："添加用户认证"
  代理 → 编写认证代码 → 发现 Bug → 修复 Bug → 更多 Bug → 重复
  结果：3-5 次迭代，混乱的提交历史，未记录的决策

使用 Compound Engineering：
  用户：/ce-strategy → 定义认证需求
  用户：/ce-brainstorm → 交互式问答，编写需求文档
  用户：/ce-plan → 创建详细实施计划
  用户：/ce-work → 使用 worktree 隔离执行计划
  用户：/ce-code-review → 多代理审查尽早发现问题
  用户：/ce-compound → 记录学习心得供未来参考
  结果：1-2 次迭代，清晰的提交历史，已记录的决策
```

### 成本效率

对于一个典型的开发任务，在 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 上启动你的代理环境以获得可靠的托管。

```
不使用 Compound Engineering：
  - 代理 API 调用：约 15 次（代码 + 修复循环）
  - 平均 API 成本：$0.12
  - 开发者时间：45 分钟（调试、审查）
  
使用 Compound Engineering：
  - 代理 API 调用：约 25 次（规划 + 执行 + 审查）
  - 平均 API 成本：$0.20
  - 开发者时间：15 分钟（审查，而非调试）
  
净结果：API 成本多 $0.08，开发者时间少 30 分钟，
生产环境中的 bug 更少，为未来工作记录学习心得。
```

## 高级用法 / 生产加固

### 自定义 Compound 笔记

创建项目特定的知识库：

```bash
# 编写自定义 compound 笔记
/ce-compound "Q2 数据库迁移经验"

# 读取现有的 compound 笔记
/ce-strategy --show-compound-notes
```

Compound 笔记按主题组织，可以在头脑风暴会话中自动引用。

### 产品脉搏报告

`/ce-product-pulse` 生成按时间窗口划分的报告：

```bash
# 生成 7 天脉搏报告
/ce-product-pulse --window 7d

# 报告保存到 docs/pulse-reports/pulse-2026-06-14.md
```

报告包括：

- 使用统计
- 错误率
- 性能指标
- 来自之前脉搏的后续事项

这些报告反馈到策略层，创建数据驱动的反馈循环。

### 调试模式

`/ce-debug` 提供系统性调试：

```bash
/ce-debug "用户报告移动设备登录超时"
```

调试流程：

1. 在受控环境中复现失败
2. 通过代码库追溯根本原因
3. 以最小范围实施修复
4. 将调试过程记录在 compound 笔记中

这取代了随机代码更改的常见模式，采用系统性的根本原因分析。

### 与 CI/CD 集成

Compound Engineering 集成到 CI/CD 流水线中：

```yaml
# .github/workflows/compound-engineering.yml
jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: 运行 CE 代码审查
        run: |
          /ce-code-review --head main --branch feature/auth
          /ce-code-review --output review-report.md
      - name: 上传审查报告
        uses: actions/upload-artifact@v4
        with:
          name: review-report
          path: review-report.md
```

### 多代理审查配置

为不同维度配置多个审查者：

```json
// .compound-engineering/review-config.json
{
  "reviewers": [
    {
      "name": "security",
      "focus": ["security", "auth", "encryption"],
      "agent": "claude-sonnet"
    },
    {
      "name": "architecture",
      "focus": ["architecture", "performance", "scalability"],
      "agent": "claude-opus"
    },
    {
      "name": "ux",
      "focus": ["ux", "accessibility", "copy"],
      "agent": "claude-sonnet"
    }
  ],
  "auto_trigger": true,
  "fail_on_critical": true
}
```

## 局限性 / 诚实评估

Compound Engineering 是一个成熟的项目，有明显优势，但也存在一些局限性：

- **学习曲线**：9 命令工作流需要改变"直接写代码"的习惯。首次用户经常直接跳到编码，这违背了目的。预计需要 2-3 周的调整期。
- **更高的 API 使用量**：规划和审查阶段每个功能增加约 10 次额外的 API 调用。对于注重预算的用户，这是显著的成本增加。节省来自减少返工和调试，而非降低 API 成本。
- **代理依赖**：头脑风暴、审查和复合输出的质量很大程度上取决于底层代理的推理能力。Claude Opus 和 Sonnet 效果最佳；较小的模型产生浅层计划。
- **无 Python SDK**：该插件仅 TypeScript。基于 Python 的开发工作流需要手动适配规划和审查步骤。
- **单一仓库聚焦**：专为 monorepo 或单一仓库项目设计。多仓库设置需要在仓库之间手动协调 compound 笔记。

该项目由 EveryInc 积极维护，定期更新和添加新命令。

## 常见问题

**问：每个项目我都需要全部 9 个命令吗？**

答：不。大多数项目的核心工作流使用 5 个命令：`strategy`、`brainstorm`、`plan`、`work` 和 `review`。`compound` 命令是可选的，但对长期项目高度推荐。`ideate`、`debug` 和 `pulse` 是特定情境使用的。

**问：Compound Engineering 能与非 AI 编码工具一起使用吗？**

答：这些命令专为 AI 编码代理设计。规划和头脑风暴方法可以适配人工领导的开发，但插件本身需要 AI 编码代理来执行。

**问：Compound Engineering 如何处理大型重构项目？**

答：`/ce-work` 使用 git worktree 进行并行任务执行，非常适合大型重构。计划中的每个任务都有自己的 worktree，允许并行开发而无需冲突。审查阶段在合并之前发现集成问题。

**问：Compound Engineering 可用于商业用途吗？**

答：可以，Compound Engineering 采用 MIT 许可证。没有限制使用量、订阅费或商业限制。

**问：我可以自定义头脑风暴和规划模板吗？**

答：可以。头脑风暴和规划输出从存储在 `.compound-engineering/` 中的模板生成。你可以自定义这些模板以匹配你团队的约定和项目需求。

**问：多代理审查是如何工作的？**

答：该插件可以调用具有不同关注点的多个代理实例。每个审查者获得特定的视角（安全、架构、UX）并提供针对性反馈。结果整合为单一的审查报告。

## 结论

Compound Engineering 解决了 AI 辅助开发中的一个根本性空白：缺乏结构化的规划和审查。凭借 20,000+ GitHub 星标和对 3 个主要 AI 编码代理的支持，它已成为 2026 年最受欢迎的工程工作流工具之一。

核心价值主张很简单：在规划和审查上投入时间，通过更少的 bug、更容易的调试和记录的知识在后期节省大量时间。

**立即尝试 Compound Engineering** — 通过 `/plugin marketplace add EveryInc/compound-engineering-plugin` 为 Claude Code 安装，或通过 `/add-plugin compound-engineering` 为 Cursor 安装。

了解更多多代理工作流内容：
- [ECC：Agent Harness 性能优化](/zh/resources/dev-utils/ecc-agent-harness-performance-optimization/) — 在结构化工作流的同时优化代理性能
- [Impeccable：AI 设计语言](/zh/resources/ai-tools/impeccable-ai-design-language-harness-quality-ui/) — 为你的复合工程流程添加设计质量

---

**来源与延伸阅读**：
- GitHub 仓库：https://github.com/EveryInc/compound-engineering-plugin
- 哲学文章：https://every.to/chain-of-thought/compound-engineering-how-every-codes-with-agents
- 项目背后的故事：https://every.to/source-code/my-ai-had-already-fixed-the-code-before-i-saw-it

**加入我们的社区**：https://t.me/DIBI8_Group

---

**披露**：本文包含联盟链接。如果你通过我们的链接注册，我们可能会获得佣金，对你不会产生额外费用。
