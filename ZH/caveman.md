---
title: "Caveman：让 Claude Code Token 消耗减少 65%，省钱又提速"
description: "Caveman 是一款 Claude Code 技能，通过智能压缩 AI 输出提示词，平均减少 65% Token 消耗，响应速度提升约 3 倍，技术准确性 100% 不变。支持 Claude Code、Cursor、Gemini CLI、Codex 等 30+ AI 编程助手。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - JavaScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "2.4 MB"
file_md5: ""
download_url: "https://github.com/JuliusBrussee/caveman"
backup_url: ""
github_repo: "https://github.com/JuliusBrussee/caveman"
stars: 61775
maintainer: "JuliusBrussee"
last_maintained: "2026-05-12"
featureImage: ""
draft: false
aliases:
- /zh/posts/caveman/
faq:
  - q: "Caveman 会影响 AI 的思考质量吗?"
    a: "**不会。** Caveman 只压缩**输出 Token**（AI 说出来的话），不影响**思考/推理 Token**（AI 内部思考过程）。AI 的\"大脑\"保持不变，只是\"嘴巴\"变小了。"
  - q: "所有任务都能省 65% 吗?"
    a: "**不一定。** 65% 是平均值。代码重构类任务（本身输出就很精简）可能只省 22%，而解释性、架构类任务可能省 87%。"
  - q: "Caveman 支持中文吗?"
    a: "**支持。** 除了英文的 Caveman 模式，还有专门的**文言文模式**，用古典中文实现极致压缩。"
  - q: "安装安全吗?"
    a: "**安全。** 安装脚本只读取已安装的 AI 助手配置，不会修改系统文件。可以安全地重复运行。开源 MIT 协议，代码完全透明。"
  - q: "免费吗?"
    a: "**完全免费。** Caveman 是开源项目，使用 MIT 许可证。 ---"
faqs:
  - q: 'Caveman 是什么？它与 Claude Code 有什么关系？'
    a: 'Caveman 是一个 Claude Code 技能插件，它让 Claude 以压缩、简洁的「原始人」风格回复——去掉废话、冠词和客套开场白。平均可将输出 token 减少 65%，同时不损失任何技术准确性。'
  - q: 'Caveman 能把 token 用量减少多少？'
    a: '根据仓库中可复现的基准测试，Caveman 平均减少了 65% 的输出 token，范围从 22% 到 87% 不等，具体取决于原始任务有多冗长。举个例子，解释一个 React 重渲染 bug 的回复从 1,180 个 token 降到了 159 个（节省 87%）。'
  - q: 'Caveman 会让 Claude 变得不准确或「变笨」吗？'
    a: '不会。Caveman 不会碰模型的思考和推理 token，只压缩最终输出的文本。模型依然以完整能力进行推理，所有技术内容完整保留，被去掉的只是无意义的废话。'
  - q: '如何为 Claude Code 安装 Caveman？'
    a: '用 ''git clone https://github.com/JuliusBrussee/caveman.git ~/.claude/skills/caveman'' 将仓库克隆到全局技能目录，然后重启 Claude Code，技能会自动加载。它同样支持 Cursor、Cline、Windsurf 和 Codex，分别通过各自的规则文件启用。'
  - q: 'Caveman 提供哪些强度等级和命令？'
    a: 'Caveman 共有三个等级：Lite（去除废话，保留语法）、Full（默认模式，省略冠词，使用片段句式）和 Ultra（最大电报式压缩）。此外还附带子命令，如 /caveman-commit、/caveman-review、/caveman-stats，以及 /caveman:compress，用于重写 CLAUDE.md 等记忆文件。'
---
{</* resource-info */>}

# Caveman：让 Claude Code Token 消耗减少 65%，省钱又提速

> 🪨 why use many token when few token do trick

如果你每天用 Claude Code、Cursor 或 Gemini CLI 写代码，你可能没意识到——AI 助手那些冗长、礼貌、充满过渡词的回复，正在悄悄吃掉你的 Token 预算。一个名为 **Caveman** 的开源技能（Skill）正在 GitHub 上爆火：57,000+ Stars，它通过让 AI "像原始人一样说话"，**平均减少 65% 的输出 Token，响应速度提升约 3 倍，同时保持 100% 的技术准确性**。

这不是玩笑。这是经过真实 API 调用基准测试验证的数据。

---

## 一、Caveman 是什么？

**Caveman** 是由 Julius Brussee 开发的一款 Claude Code 技能，核心理念极其简单：

> **"为什么用很多 Token，当少量 Token 就能搞定？"**

它通过智能压缩 AI 的输出内容——去掉填充词、过渡句、冗余修饰，保留全部技术信息——让 AI 的回复变得极简、直接、高效。你可以把它理解为给 AI 装了一个"语言压缩器"。

**项目信息：**
- **GitHub：** [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)
- **Stars：** 57,003
- **官网：** [getcaveman.dev](https://getcaveman.dev/)
- **许可证：** MIT

---

## 二、为什么你需要 Caveman？

### 1. Token 消耗平均减少 65%（实测数据）

Caveman 团队使用 Claude API 进行了真实基准测试，以下是部分结果：

| 任务 | 正常模式 (Tokens) | Caveman 模式 (Tokens) | 节省比例 |
|------|------------------|----------------------|----------|
| 解释 React 重渲染 Bug | 1,180 | 159 | **87%** |
| 修复 Auth 中间件 Token 过期 | 704 | 121 | **83%** |
| 配置 PostgreSQL 连接池 | 2,347 | 380 | **84%** |
| 解释 Git rebase vs merge | 702 | 292 | **58%** |
| Docker 多阶段构建 | 1,042 | 290 | **72%** |
| 实现 React Error Boundary | 3,454 | 456 | **87%** |
| **平均值** | **1,214** | **294** | **65%** |

节省范围从 **22% 到 87%** 不等，取决于任务类型。代码重构类任务节省较少（因为输出本身就很精简），而解释性、架构类任务节省极为可观。

### 2. 响应速度提升约 3 倍

Token 生成量减少意味着 AI 完成回复的时间大幅缩短。在快节奏的编程工作流中，等待 AI 写完一段长篇大论和立刻得到精准答案，体验天差地别。

### 3. 技术准确性 100% 不变

Caveman 只压缩"废话"，不压缩"干货"。所有技术信息、代码逻辑、关键细节完整保留。2026 年 3 月的一篇论文 ["Brevity Constraints Reverse Performance Hierarchies in Language Models"](https://arxiv.org/abs/2604.00025) 甚至发现：**约束大模型生成简短回复，在某些基准测试中提升了 26 个百分点的准确率**。verbose（冗长）不等于更好。

### 4. 更易阅读，更少认知负担

没有大段大段的铺垫和总结，AI 直接给你答案。代码审查、技术解释、调试建议都变得像子弹列表一样清晰。

### 5. 省钱

如果你使用按 Token 计费的 AI 服务（如 Claude API、Cursor Pro 等），输出 Token 减少 65% 直接意味着账单减少。对于重度用户，这每月可能省下数十甚至数百美元。

---

## 三、Caveman 是如何工作的？

Caveman 的核心机制是**输出压缩**（Output Compression）。它不影响 AI 的"思考过程"（thinking/reasoning tokens），只压缩最终说出来的话。

> **Caveman 不会让 AI 变笨，只会让 AI 的"嘴巴"变小。**

它提供三种压缩强度：

| 等级 | 触发指令 | 效果 |
|------|---------|------|
| **Lite** | `/caveman lite` | 去掉填充词，保留语法。专业但无废话 |
| **Full** | `/caveman full` | 默认模式。去掉冠词、碎片化表达，原始人风格 |
| **Ultra** | `/caveman ultra` | 最大压缩。电报式表达，能缩写的全缩写 |

等级一旦设置，会在整个会话中保持，直到你更改或会话结束。

### 特色模式：文言文 (Wenyan) 压缩

Caveman 甚至提供了一个极具创意的**文言文模式**——用人类历史上最精简的书面语言来传递技术信息：

| 等级 | 触发指令 | 效果 |
|------|---------|------|
| **Wenyan-Lite** | `/caveman wenyan-lite` | 半文言。语法完整，填充词消失 |
| **Wenyan-Full** | `/caveman wenyan` | 全文言。极致古典简练 |
| **Wenyan-Ultra** | `/caveman wenyan-ultra` | 极端模式。古代学者省钱版 |

---

## 四、支持哪些 AI 助手？

Caveman 的安装脚本能自动检测 **30+ 款 AI 编程助手**并为其安装对应插件：

- Claude Code
- Gemini CLI
- Codex (OpenAI)
- Cursor
- Windsurf
- Cline
- GitHub Copilot
- Continue
- Kilo
- Roo
- Augment
- Aider Desk
- Amp
- Bob
- Crush
- Devin
- Droid
- ForgeCode
- Goose
- iFlow
- JetBrains Junie
- Kiro CLI
- Mistral Vibe
- OpenHands
- opencode
- Qwen Code
- Qoder
- Rovo Dev
- Tabnine
- Trae
- Warp
- Replit Agent
- Antigravity
- ...以及更多

你不需要手动为每个工具配置，一行命令搞定全部。

---

## 五、安装与使用

### 一键安装

**macOS / Linux / WSL / Git Bash：**
```bash
curl -fsSL https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.sh | bash
```

**Windows (PowerShell)：**
```powershell
irm https://raw.githubusercontent.com/JuliusBrussee/caveman/main/install.ps1 | iex
```

安装脚本默认会：
1. 为检测到的每个 AI 助手安装对应插件
2. 配置 Claude Code 的 hooks + 状态栏 + 统计徽章
3. 注册 `caveman-shrink` MCP 代理

### 安装选项

| 参数 | 效果 |
|------|------|
| `--all` | 完整安装：插件 + hooks + 状态栏 + MCP shrink + 当前目录的 per-repo 规则文件 |
| `--minimal` | 仅安装插件/扩展，跳过 hooks 和 MCP shrink |
| `--with-init` | 在当前仓库中放置常驻规则文件（Cursor / Windsurf / Cline / Copilot / AGENTS.md） |
| `--list` | 打印完整的 AI 助手检测列表 |

### 使用方法

安装后，在任意支持的 AI 助手中输入以下指令即可激活：

- `/caveman` 或 Codex 的 `$caveman`
- "talk like caveman"
- "caveman mode"
- "less tokens please"

关闭 Caveman 模式：
- "stop caveman"
- "normal mode"

---

## 六、Caveman 生态系统

Caveman 其实只是一个更大生态的入口。Julius Brussee 还开发了另外两个配套工具：

| 项目 | 功能 | 一句话描述 |
|------|------|-----------|
| [**caveman**](https://github.com/JuliusBrussee/caveman) | 输出压缩 | 压缩 AI "说"的话 |
| [**cavemem**](https://github.com/JuliusBrussee/cavemem) | 跨助手持久记忆 | 压缩 AI "记住"的话 |
| [**cavekit**](https://github.com/JuliusBrussee/cavekit) | 规范驱动自主构建 | 自然语言 → 套件 → 并行构建 → 验证 |

三者可以组合使用：**cavekit** 编排构建流程，**caveman** 压缩输出，**cavemem** 压缩记忆。每个工具都可以独立使用。

---

## 七、进阶：caveman-shrink MCP 中间件

对于使用 MCP（Model Context Protocol）服务器的用户，Caveman 还提供了一个强大的中间件 `caveman-shrink`：

它是一个 stdio 代理，可以包装任何 MCP 服务器，拦截 `tools/list`、`prompts/list`、`resources/list` 响应，并压缩其中的 `description` 字段。代码、URL、路径、标识符保持字节级完全一致。

```json
{
  "mcpServers": {
    "fs-shrunk": {
      "command": "npx",
      "args": ["caveman-shrink", "npx", "@modelcontextprotocol/server-filesystem", "/path/to/dir"]
    }
  }
}
```

已发布在 npm：[caveman-shrink](https://www.npmjs.com/package/caveman-shrink)。默认由 `install.sh` 自动注册（使用 `--minimal` 可跳过）。

---

## 八、真实场景对比

### 场景 1：解释 React 重渲染 Bug

**正常模式：**
> "好的，让我来详细解释一下 React 重渲染的问题。首先，我们需要理解 React 的渲染机制。当一个组件的状态（state）或属性（props）发生变化时，React 会重新渲染该组件及其子组件。这个过程被称为重渲染（re-render）。在某些情况下，不必要的重渲染会导致性能问题..."

**Caveman 模式：**
> "React re-render happen when state/props change. Unnecessary re-render = performance problem. Fix: use React.memo, useMemo, useCallback. Check dependency array in useEffect."

**结果：** 1,180 Tokens → 159 Tokens，节省 **87%**。

### 场景 2：Docker 多阶段构建

**正常模式：**
> "Docker 多阶段构建（multi-stage builds）是一种优化 Docker 镜像大小的技术。它允许你在一个 Dockerfile 中使用多个 FROM 指令，每个 FROM 指令都可以使用不同的基础镜像..."

**Caveman 模式：**
> "Multi-stage build = smaller image. Multiple FROM in one Dockerfile. Copy only needed artifacts from builder stage to final stage."

**结果：** 1,042 Tokens → 290 Tokens，节省 **72%**。

---

## 九、常见问题

### Q1: Caveman 会影响 AI 的思考质量吗？
**不会。** Caveman 只压缩**输出 Token**（AI 说出来的话），不影响**思考/推理 Token**（AI 内部思考过程）。AI 的"大脑"保持不变，只是"嘴巴"变小了。

### Q2: 所有任务都能省 65% 吗？
**不一定。** 65% 是平均值。代码重构类任务（本身输出就很精简）可能只省 22%，而解释性、架构类任务可能省 87%。

### Q3: Caveman 支持中文吗？
**支持。** 除了英文的 Caveman 模式，还有专门的**文言文模式**，用古典中文实现极致压缩。

### Q4: 安装安全吗？
**安全。** 安装脚本只读取已安装的 AI 助手配置，不会修改系统文件。可以安全地重复运行。开源 MIT 协议，代码完全透明。

### Q5: 免费吗？
**完全免费。** Caveman 是开源项目，使用 MIT 许可证。

---

## 十、总结

Caveman 是 2026 年 AI 编程助手领域最实用、最有趣的效率工具之一。它不改变你的工作流，不降低输出质量，只是让 AI 学会"说人话"——或者说，"说原始人的话"。

**核心价值：**
- ✅ Token 消耗平均减少 **65%**
- ✅ 响应速度提升约 **3 倍**
- ✅ 技术准确性 **100%** 不变
- ✅ 支持 **30+** 款 AI 编程助手
- ✅ 一键安装，零配置
- ✅ 完全免费，开源透明

如果你每天花大量时间与 AI 助手协作编程，Caveman 可能是你今年最值得安装的 5 分钟配置。

---

## 相关链接

- **GitHub 仓库：** [github.com/JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman)
- **官方网站：** [getcaveman.dev](https://getcaveman.dev/)
- **cavemem（记忆压缩）：** [github.com/JuliusBrussee/cavemem](https://github.com/JuliusBrussee/cavemem)
- **cavekit（构建编排）：** [github.com/JuliusBrussee/cavekit](https://github.com/JuliusBrussee/cavekit)
- **科学论文：** [Brevity Constraints Reverse Performance Hierarchies in Language Models](https://arxiv.org/abs/2604.00025)
- **NPM 中间件：** [caveman-shrink](https://www.npmjs.com/package/caveman-shrink)

---

> **"Less token, more speed, same brain."**
>
> 这就是 Caveman 的哲学。

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

