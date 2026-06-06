---
title: Agent Skills：开发团队如何以5倍速度交付生产级代码
description: Addy Osmani的Agent Skills提供20个生产级工程技能和7个斜杠命令，将AI编码智能体转变为高级软件工程师。
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
- JavaScript
- TypeScript
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /zh/posts/addy-osmani-agent-skills-production-grade-ai-coding-agents.zh/
- /zh/posts/agent-skills-production-grade-ai-coding/
faqs:
  - q: 'Addy Osmani 开发的 Agent Skills 是什么？'
    a: 'Agent Skills 是一个开源合集，包含 20 项生产级工程技能和 7 个斜杠命令，把资深工程师的工作流、质量门禁和最佳实践编码固化下来，供 AI 编码智能体使用。它由 Addy Osmani 打造，覆盖完整的软件开发生命周期：DEFINE、PLAN、BUILD、VERIFY、REVIEW、SHIP。'
  - q: 'Agent Skills 能配合哪些 AI 编码智能体使用？'
    a: 'Agent Skills 可配合 Claude Code、Cursor、Gemini CLI、Windsurf、OpenCode、GitHub Copilot、Kiro 和 Codex 使用。每个智能体都有专属目录存放技能清单（manifest），技能会根据文件类型和上下文自动激活。'
  - q: 'Agent Skills 中的 7 个斜杠命令是什么？'
    a: '这 7 个命令是 /spec（定义要构建什么）、/plan（把工作拆分成小而原子化的任务）、/build（增量构建）、/test（用测试证明它能正常工作）、/review（合并前评审）、/code-simplify（清晰胜过炫技）和 /ship（部署到生产环境）。每个命令都会根据你正在编辑的内容自动激活相关技能。'
  - q: '如何为 Claude Code 安装 Agent Skills？'
    a: '对于 Claude Code，你可以用 `gh repo clone addyosmani/agent-skills .claude/skills` 把仓库克隆到你的项目中，或者用 `claude plugin install addyosmani/agent-skills` 作为插件安装。'
  - q: 'Agent Skills 中的反合理化表（anti-rationalization table）是什么？'
    a: '反合理化表是嵌入每项技能中的一个功能，它会提前标记开发者和 AI 智能体用来偷工减料的常见借口（例如"我稍后再加测试"），并给出对应的反驳论据。这些表格源自 Google 规模组织中真实的事后复盘（post-mortem）和代码评审反馈。'
---

{</* resource-info */>}

# Agent Skills：开发团队如何以5倍速度交付生产级代码

AI编码智能体无处不在——但大多数生成的玩具代码在生产环境中会崩溃。**Agent Skills** 由Addy Osmani（Google Chrome工程负责人）创建，是一个开源系统，可将任何AI智能体转变为**高级软件工程师**。拥有 **33,400+ GitHub stars** 和 **3,900+ forks**，它是2026年出现的最具影响力的开发者生产力工具之一。

## 什么是Agent Skills？

Agent Skills 是一套**20个生产级工程技能**和**7个斜杠命令**，编码了Google规模公司高级工程师使用的工作流、质量门限和最佳实践。它适用于Claude Code、Cursor、Gemini CLI、Windsurf、OpenCode、GitHub Copilot、Kiro和Codex。

该系统映射到完整的软件开发生命周期：

```
定义 → 规划 → 构建 → 验证 → 审查 → 交付
  /spec   /plan  /build  /test   /review  /ship
```

## 7个斜杠命令

| 你在做什么 | 命令 | 核心原则 |
|-----------|------|---------|
| 定义要构建的内容 | `/spec` | 规范先于代码 |
| 规划如何构建 | `/plan` | 小而原子的任务 |
| 增量构建 | `/build` | 一次一个切片 |
| 证明它有效 | `/test` | 测试即证明 |
| 合并前审查 | `/review` | 改善代码健康度 |
| 简化代码 | `/code-simplify` | 清晰优于巧妙 |
| 交付生产 | `/ship` | 更快更安全 |

每个命令自动激活正确的技能。例如，`/build` 会根据您编辑的文件类型触发 `incremental-implementation`、`test-driven-development` 和 `frontend-ui-engineering`。

## 20个生产级技能

### 定义——明确要构建的内容

1. **idea-refine**：结构化发散/收敛思维，将模糊想法转化为具体提案。
2. **spec-driven-development**：在编写任何代码之前，编写涵盖目标、命令、结构、代码风格、测试和边界的PRD。

### 规划——分解任务

3. **planning-and-task-breakdown**：将规范分解为带有验收标准和依赖排序的小型可验证任务。

### 构建——编写代码

4. **incremental-implementation**：薄垂直切片——实现、测试、验证、提交。功能标志、安全默认值、回滚友好变更。
5. **test-driven-development**：红-绿-重构，测试金字塔（80/15/5），测试大小，DAMP优于DRY，Beyonce规则。
6. **context-engineering**：在正确的时间向智能体提供正确的信息——规则文件、上下文打包、MCP集成。
7. **source-driven-development**：将每个框架决策建立在官方文档基础上——验证、引用来源、标记未验证内容。
8. **frontend-ui-engineering**：组件架构、设计系统、状态管理、响应式设计、WCAG 2.1 AA无障碍。
9. **api-and-interface-design**：契约优先设计、Hyrum定律、单版本规则、错误语义、边界验证。

### 验证——证明它有效

10. **browser-testing-with-devtools**：Chrome DevTools MCP用于实时运行时数据——DOM检查、控制台日志、网络跟踪、性能分析。
11. **debugging-and-error-recovery**：五步分类：重现、定位、减少、修复、防护。停线规则、安全回退。

### 审查——合并前的质量门限

12. **code-review**：结构化审查清单——正确性、性能、安全性、可维护性、测试覆盖率。
13. **security-review**：OWASP Top 10、依赖扫描、密钥检测、输入验证、输出编码。

### 交付——安全部署

14. **deployment-and-rollback**：蓝绿、金丝雀、功能标志、数据库迁移、回滚程序。
15. **monitoring-and-observability**：指标、日志、跟踪、警报、SLO、错误预算。

## 按智能体安装

### Claude Code（推荐）

```bash
# 克隆到您的项目中
gh repo clone addyosmani/agent-skills .claude/skills

# 或作为插件安装
claude plugin install addyosmani/agent-skills
```

### Cursor

将 `.cursor/skills/` 目录复制到项目根目录。技能根据文件类型自动激活。

### Gemini CLI

```bash
gemini install skills addyosmani/agent-skills
```

### Windsurf / OpenCode / Copilot

每个都有专用目录（`.windsurf/`、`.opencode/`、`.github/copilot/`）包含技能清单。

## 代码示例：规范驱动开发

```markdown
# /spec 输出示例

## 目标
构建一个使用JWT令牌的用户认证REST API。

## 命令
- POST /auth/register
- POST /auth/login
- POST /auth/refresh

## 结构
- controllers/auth.js
- services/token.js
- middleware/jwt.js
- tests/auth.test.js

## 代码风格
- 仅使用async/await
- Express错误处理中间件
- Zod用于输入验证

## 测试
- 令牌服务100%覆盖率
- 所有端点的集成测试
- 负载测试：1000 req/s基线

## 边界
- 不存储明文密码
- 令牌15分钟过期
- 速率限制：每分钟5次尝试
```

智能体使用此规范生成实现、测试和文档——在编写任何代码之前全部对齐。

## 实际应用场景

### 案例1：2周内完成创业MVP
一个3人创业团队使用 `/spec` → `/plan` → `/build` → `/test` 在10天内交付了一个全栈SaaS MVP。规范防止了3次重大架构转向，每次转向原本会耗费2周。

### 案例2：企业重构
一家财富500强团队使用 `incremental-implementation` 和 `code-review` 技能重构了一个10万行的React代码库。在3个月的迁移期间零生产事故。

### 案例3：代理交付
一家Web开发代理公司将Agent Skills嵌入其标准工作流。项目交付时间下降了40%，客户变更请求减少了25%，因为规范及早发现了歧义。

### 案例4：开源维护者
一位流行的npm包维护者在每个PR上使用 `/review`。该技能在人类审查之前捕获边缘情况、缺失测试和API破坏性变更。

## 与竞品对比

| 功能 | Agent Skills | GitHub Copilot | Cursor Rules | 通用提示 |
|------|--------------|----------------|--------------|---------|
| **开源** | ✅ 是 | ❌ 否 | ❌ 否 | N/A |
| **20个结构化技能** | ✅ 是 | ❌ 通用 | ❌ 基础 | ❌ 临时 |
| **多智能体支持** | ✅ 7+智能体 | ❌ 仅Copilot | ❌ 仅Cursor | ❌ N/A |
| **质量门限** | ✅ 内置 | ❌ 无 | ❌ 无 | ❌ 手动 |
| **规范驱动** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 罕见 |
| **反合理化** | ✅ 是 | ❌ 否 | ❌ 否 | ❌ 否 |
| **高级工程师模式** | ✅ 是 | ❌ 初级水平 | ❌ 混合 | ❌ 混合 |

## SEO与开发者采用

Agent Skills在高意向开发者关键词上排名：
- "AI coding agent best practices"
- "production-grade AI software development"
- "Claude Code skills system"
- "spec-driven development with AI"
- "AI test-driven development"

该项目在**工程领导圈**中获得关注，因为它系统地解决了"AI编写损坏代码"的问题。

## 相关文章

- [Anthropic Financial Services：金融团队如何用AI自动化分析并将ROI提升300%](/zh/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [DocuSeal评测：用这款开源DocuSign替代品将文档签署成本降低90%](/zh/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [2026年十大AI开发者生产力工具](/zh/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)


## 深入解析：技能激活引擎

Agent Skills 使用上下文感知激活引擎，根据多个信号确定加载哪些技能：

### 信号来源

1. **显式命令**：`/build`、`/test`、`/review` 直接加载其映射的技能包。
2. **文件类型检测**：编辑 `.tsx` 文件自动加载 `frontend-ui-engineering`；`.proto` 文件触发 `api-and-interface-design`。
3. **Git 状态**：`src/` 中未提交的更改触发 `incremental-implementation`；失败的 CI 状态触发 `debugging-and-error-recovery`。
4. **自然语言意图**："我需要为用户认证设计一个 API" 即使没有斜杠命令也会激活 `api-and-interface-design`。

### 技能组合

技能是可组合的。当您在一个从新的 API 端点获取数据的 React 组件上运行 `/build` 时，引擎会加载：
- `incremental-implementation`（主要）
- `frontend-ui-engineering`（UI 层）
- `api-and-interface-design`（数据契约）
- `test-driven-development`（验证）

这种组合防止了 AI 智能体针对一层进行优化而破坏相邻系统的常见失败模式。

## 反合理化表

Agent Skills 最具创新性的功能之一是嵌入在每个技能中的**反合理化表**。高级工程师知道初级开发人员（和 AI 智能体）经常为走捷径辩护。这些表先发制人地标记常见的合理化并提供反驳：

| 常见合理化 | 反驳 | 技能 |
|-----------|------|------|
| "我稍后添加测试" | "稍后永远不会到来。未经测试的代码会进入生产环境。" | test-driven-development |
| "API 仅供内部使用" | "内部 API 会变成公共的。从第一天起就为外部使用者设计。" | api-and-interface-design |
| "这只是一个快速修复" | "快速修复会积累技术债务。遵循完整的分类流程。" | debugging-and-error-recovery |
| "用户不会注意到性能问题" | "性能是一项功能。在否定之前先进行性能分析。" | browser-testing-with-devtools |

这些表源自 Google 规模组织的真实事后分析和代码审查反馈。

## 上下文工程：秘诀

`context-engineering` 技能可以说是最具变革性的。它教会 AI 智能体如何有效地管理自己的上下文窗口：

### 规则文件

在项目根目录中放置 `.cursorrules`、`.claude.md` 或 `.kiro.md` 文件以定义：
- 架构决策及其原理
- 禁止的模式（例如，"永远不要在 TypeScript 中使用 `any`"）
- 首选库和版本约束
- 测试约定（jest 与 vitest，覆盖率阈值）

### 上下文打包

对于大型代码库，该技能教会智能体：
1. **总结**：在加载完整内容之前，将超过 500 行的文件总结为接口描述
2. **优先**：优先加载近期 git 活动的文件，而非陈旧代码
3. **排除**：从上下文中排除生成的文件（锁文件、构建输出）
4. **链式引用**：当文件 A 导入 B 时，加载 A 的接口和 B 的实现

### MCP 集成

该技能包括用于以下内容的模型上下文协议 (MCP) 配置：
- **浏览器 DevTools**：实时 DOM 检查、网络跟踪分析
- **数据库模式**：用于 API 设计验证的 SQL 内省
- **文档服务器**：实时框架文档查找

## 衡量 Agent Skill 影响

使用 Agent Skills 的团队应跟踪以下指标：

| 指标 | 基线（无技能） | 使用 Agent Skills | 变化 |
|------|--------------|-------------------|------|
| 从规范到首次提交的时间 | 4 小时 | 45 分钟 | -81% |
| PR 审查轮次 | 平均 3.2 | 平均 1.4 | -56% |
| 每月生产事故 | 2.1 | 0.3 | -86% |
| 新代码测试覆盖率 | 34% | 89% | +162% |
| 开发者满意度（1-10） | 5.2 | 8.1 | +56% |

## 团队采用策略

### 策略 1：逐步推广

第 1-2 周：仅引入 `/spec` 和 `/plan`。在编写任何代码之前衡量规范质量。
第 3-4 周：添加 `/build` 和 `/test`。跟踪测试覆盖率改进。
第 5-6 周：启用 `/review` 和 `/ship`。衡量生产事故减少。

### 策略 2：试点小组

选择一个 3-4 人的功能小组作为试点。让他们在一个完整的冲刺中使用所有 7 个命令。记录经验教训，并根据反馈创建团队特定的 `.cursorrules` 文件。

### 策略 3：门控集成

将 Agent Skills 集成到 CI/CD 中：
- 阻止不包含功能 > 100 行的规范文件的 PR
- 在 PR 上自动运行 `/review` 并将结果作为评论发布
- 要求任何错误修复 PR 的 `/test` 输出（测试计划）

## 对比：Agent Skills 与工程阶梯

Agent Skills 有效地压缩了高级工程实践的学习曲线：

| 高级工程实践 | 掌握所需年限 | Agent Skills 等效 |
|-------------|-------------|------------------|
| 编写全面的规范 | 2-3 年 | `/spec` 命令 |
| 分解复杂项目 | 1-2 年 | `/plan` 命令 |
| 测试驱动开发纪律 | 2-4 年 | `/test` + 技能 |
| 代码审查专业知识 | 3-5 年 | `/review` 命令 |
| 生产调试直觉 | 3-5 年 | `debugging-and-error-recovery` |
| API 设计判断 | 2-3 年 | `api-and-interface-design` 技能 |

这种压缩意味着使用 Agent Skills 的初级开发人员可以在几周内（而不是几年内）生产出与中级工程师相当的质量输出。

## 相关文章

- [Anthropic Financial Services：金融团队如何用AI自动化分析并将ROI提升300%](/zh/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [DocuSeal评测：用这款开源DocuSign替代品将文档签署成本降低90%](/zh/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [2026年十大AI开发者生产力工具](/zh/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)

## 结论

Agent Skills 是"AI能编码"和"AI能交付生产软件"之间缺失的环节。通过将高级工程判断编码为结构化、可验证的工作流，Addy Osmani 为任何开发团队创造了一个力量倍增器。无论您是独立创始人、创业工程师还是企业负责人，这些技能都将使您的 AI 智能体编写您实际想要部署的代码。

---

*哪个 Agent Skill 对您的工作流改善最大？在评论中告诉我们。*

---

## 推荐自托管基础设施

要 7×24 稳定跑这套，服务器选择很关键：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心。开源 AI 工具自托管首选。
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — 香港 VPS，国内访问低延迟。**这就是 dibi8.com 自家所在的 IDC**，生产环境已验证。

*以上为推广链接，不会增加你的成本，但能支持 dibi8.com 持续运营。*

