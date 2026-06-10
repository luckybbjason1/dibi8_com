---
title: 'Nuwa-Skill：將任何人的思維模型提煉為 AI Agent 技能 — 23,000 顆星 — 2026 指南'
description: 'Nuwa-Skill（23,508 顆 GitHub 星）將歷史人物、專家和影響者的思維模型提煉為可複用的 AI Agent 技能。相容 Claude Code、Codex、Cursor、Hermes 等 50+ 執行環境。透過 npx skills add 安裝。'
date: 2026-06-09
slug: 'nuwa-skill-distill-thinking-model-ai-agent-skills'
category: 'llm-frameworks'
tags: ['nuwa-skill', 'Agent 技能', '思維模型', 'COT 提煉', 'AI Agent 框架', 'Claude Code 技能', 'Codex 技能', 'MCP 替代方案', 'Agent 記憶體']
github_repo: 'https://github.com/alchaincyf/nuwa-skill'
stars: 23508
maintainer: 'alchaincyf'
license: MIT
featureImage: 'https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/assets/hero.gif'
lang: zh
---

# Nuwa-Skill：將任何人的思維模型提煉為 AI Agent 技能 — 23,000 顆星 — 2026 指南

```
┌──────────────────────────────────────────────┐
│          Nuwa-Skill Pipeline                   │
│                                                │
│  Input: "Distill Steve Jobs"                   │
│          │                                     │
│          ▼                                     │
│  ┌─────────────────────────┐                   │
│  │  Step 1: Research        │                   │
│  │  - Gather public content │                   │
│  │  - Speeches, interviews, │                   │
│  │    books, tweets         │                   │
│  └─────────┬───────────────┘                   │
│            ▼                                   │
│  ┌─────────────────────────┐                   │
│  │  Step 2: Analyze 5 L4s  │                   │
│  │  1. How they speak      │                   │
│  │  2. How they think      │                   │
│  │  3. How they decide     │                   │
│  │  4. What they avoid     │                   │
│  │  5. Their limitations   │                   │
│  └─────────┬───────────────┘                   │
│            ▼                                   │
│  ┌─────────────────────────┐                   │
│  │  Step 3: Generate SKILL │                   │
│  │  .md with YAML front-   │                   │
│  │  matter + instructions  │                   │
│  └─────────┬───────────────┘                   │
│            ▼                                   │
│  ┌─────────────────────────┐                   │
│  │  Step 4: Deploy to any  │                   │
│  │  Agent Runtime          │                   │
│  │  (50+ compatible)       │                   │
│  └─────────────────────────┘                   │
└──────────────────────────────────────────────┘
```

Nuwa-Skill（女媧）是一套開創性的 AI Agent 技能框架，讓你將任何人的思維模型——從史蒂夫·賈伯斯到華倫·巴菲特，再到你最喜歡的政治節目主持人——提煉為可複用、可部署的 Agent 技能。擁有 23,500+ 顆 GitHub 星，它已成為 Agent Skills 生態系中最受歡迎的專案之一。

核心洞察簡單卻深刻：與其要求 LLM「扮演 X」，Nuwa-Skill 會提取五層深度的認知操作系統——他們如何說話、如何思考、如何決策、他們避開什麼，以及他們誠實的局限——並將這些編碼為結構化的 SKILL.md 檔案，任何相容的 Agent 執行環境都能使用。

## 什麼是 Nuwa-Skill？

Nuwa-Skill 建立在開放的 [Agent Skills 協議](https://agentskills.io) 之上，與 50+ 相容的 AI Agent 執行環境配合運作，包括 Claude Code、Codex CLI、Cursor、OpenClaw、Hermes Agent、CodeBuddy、Gemini CLI 和 OpenCode。

與只會產生表面模仿的傳統角色扮演提示不同，Nuwa-Skill 提取五個截然不同的認知層：

|| 層 | 捕捉內容 | 範例 |
||-------|-----------------|---------|
|| **1. 表達 DNA** | 語調、節奏、用字偏好 | 賈伯斯的「 insane really great」、Naval 豐富的寓言風格 |
|| **2. 心智模型** | 認知框架與思考模式 | Musk 的「第一原理」、Buffett 的「能力圈」 |
|| **3. 決策經驗法則** | 在不確定性下做出選擇的規則 | Bezos 的「單向門 vs 雙向門」 |
|| **4. 反模式** | 他們明確拒絕做的事情 | 賈伯斯的「專注意味著說不」 |
|| **5. 誠實邊界** | 他們明確無法做的事情 | Musk 的承認：「我不懂生物學」 |

這種五層方法確保提煉超越表面模仿，進入真正的認知框架轉移。

### 輸出範例

以下是提煉 Naval Ravikant 的結果：

```
User      ❯ 我想同時做自媒體、寫書和創業

Naval     ❯ 你列出了三個願望。每個願望都是你與不快樂簽下的契約。
            不是你缺乏精力——是你簽了太多契約。

            問問自己：哪一件事讓你忘卻時間？
            那就是你的獨特知識所在。

            不要從三選一。先成為一個，然後再成為另一個。
            串行複利，而非並行摩擦。
```

以及 Musk 談 SaaS 客戶獲取：

```
User      ❯ 我們的 SaaS 客戶獲取成本太高

Musk      ❯ 別急著想如何降低。先算出物理極限。
            使用者發現你並付費，最少必要動作是什麼？
            資訊傳輸的理論最短路徑是什麼？

            現在——你實際的路徑比理論極限長多少倍？
            如果超過 3 倍，中間就有應該被刪掉的步驟。
            別優化漏斗。質疑漏斗是否應該存在。
```

![Nuwa-Skill Hero](https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/assets/hero.gif)

![Nuwa Distillation Pipeline](https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/6-agents-parallel.png)

![Nuwa Advisory Board](https://raw.githubusercontent.com/alchaincyf/nuwa-skill/main/advisory-board.png)

## 運作原理

提煉過程完全自動化。你提供一個名字，Nuwa-Skill 會處理研究、分析、生成和部署流程。

### 第一步：研究階段

系統會收集目標人物的公開內容：書籍、演講、訪談、 Podcast、推文和文章。這五層分析將以此作為原始材料。

### 第二步：五層分析

每一層獨立分析：

```yaml
# Nuwa 生成的範例 SKILL.md 結構
name: "Steve Jobs"
description: "Steve Jobs 思維模型——專注、簡潔、現實扭曲"
cognitive_layers:
  expression:
    tone: "直接、自信、有時尖銳"
    patterns: ["隱喻", "二元框架", "重複"]
    signature_phrases:
      - "insanely great"
      - "the only way to do great work"
      - "stay hungry, stay foolish"
  mental_models:
    - "connect the dots looking backward"
    - "focus and simplify"
    - "reality distortion field (convince others of possibility)"
    - "端到端控制 (end-to-end control)"
  decision_heuristics:
    - "say no to 1000 things to focus on 3"
    - "people think focus means saying yes to the thing you've got to focus on"
    - "simplicity is the ultimate sophistication"
  anti_patterns:
    - "never compromise on quality for speed"
    - "avoid feature creep"
    - "don't design for committees"
  limitations:
    - "not suited for collaborative team-building contexts"
    - "decisions made with incomplete data"
    - "highly personality-dependent, hard to scale"
```

### 第三步：SKILL.md 生成

分析結果會被編譯為 `SKILL.md` 檔案，遵循 Agent Skills 協議規範。該檔案包含 YAML frontmatter 元資料和供 Agent 執行環境使用的結構化指令。

### 第四步：部署

生成的技能會被部署到你選擇的 Agent 執行環境——Claude Code、Codex、Cursor，或 50+ 相容平台中的任何一個。

## 安裝與設定

### 方法一：一鍵安裝（推薦）

開啟任何相容的 Agent（Claude Code、Codex、Cursor、OpenClaw、Hermes、CodeBuddy、Workbuddy、Gemini CLI、OpenCode 等），然後告訴它：

```
Help me install this skill: https://github.com/alchaincyf/nuwa-skill
```

Agent 會自動偵測你的執行環境並將技能安裝到正確的目錄。

### 方法二：通用 CLI 安裝器

使用 [vercel-labs/skills](https://github.com/vercel-labs/skills) 通用 CLI 工具，支援 55+ 執行環境：

```bash
# 將 Nuwa-Skill 安裝到預設執行環境
npx skills add alchaincyf/nuwa-skill

# 指定特定執行環境
npx skills add alchaincyf/nuwa-skill -a claude-code
npx skills add alchaincyf/nuwa-skill -a codex
npx skills add alchaincyf/nuwa-skill -a cursor
npx skills add alchaincyf/nuwa-skill -a openclaw
```

### 方法三：手動安裝

適合想要自訂安裝的進階使用者：

```bash
# 複製到適當的執行環境技能目錄
git clone https://github.com/alchaincyf/nuwa-skill ~/.claude/skills/nuwa-skill/
git clone https://github.com/alchaincyf/nuwa-skill ~/.codex/skills/nuwa-skill/
git clone https://github.com/alchaincyf/nuwa-skill ~/.cursor/skills/nuwa-skill/
git clone https://github.com/alchaincyf/nuwa-skill ~/.openclaw/workspace/skills/nuwa-skill/
```

各執行環境的技能目錄：

|| 執行環境 | 安裝路徑 |
||---------|------------------|
|| Claude Code | `~/.claude/skills/nuwa-skill/` |
|| Codex CLI | `~/.codex/skills/nuwa-skill/` |
|| Cursor | `~/.cursor/skills/nuwa-skill/` |
|| OpenClaw | `~/.openclaw/workspace/skills/nuwa-skill/` |
|| Hermes Agent | 執行 `tools/install_hermes_skill.py` |
|| 其他執行環境 | 複製到其 `skills/` 目錄 |

### 方法四：僅參考使用

即使你的執行環境不支援自動 Agent Skills 載入，你也可以將 `SKILL.md` 內容直接貼入對話中——它本質上只是帶有 YAML frontmatter 的 Markdown。

## 使用方法

安裝完成後，你可以使用自然語言指令來使用 Nuwa-Skill：

```
# 建立提煉
> Distill Paul Graham
> Create a Zhang Xiaolong perspective Skill
> Help me make a Daniel Okun (段永平) Skill

# 建立後，呼叫提煉
> Analyze this investment decision from Munger's perspective
> How would Feynman explain quantum computing?
> Switch to Naval, I'm纠结 about three things
```

### 建立自訂提煉

你可以透過提供人名和可選的額外脈絡，為任何人物建立技能：

```yaml
# 範例：自訂提煉提示
> Distill Linus Torvalds
> Context: Focus on his technical decision-making and Linux development philosophy
> Output: Include his anti-patterns (about religious coding and BDFL debates)

> Distill my manager
> Context: She's great at prioritization and stakeholder management
> Output: Capture her email writing patterns and meeting facilitation approach
```

## 與 Agent 執行環境整合

### Claude Code

```bash
# 安裝完成後，Claude Code 會自動載入技能
# 不需要額外的設定
claude
> distill Elon Musk
> use Musk's framework to analyze this product decision
```

### Codex CLI

```bash
# Codex 會自動偵測並載入技能
# 若未自動偵測，請明確指定
codex --skill nuwa-skill
> distill Naval Ravikant
> analyze my startup strategy from Naval's perspective
```

### Cursor

```
# 在 Cursor 中，技能會作為斜線指令出現
/distill [person name]

# 或在對話中直接使用技能
> Switch to the Steve Jobs thinking model
```

### OpenClaw

```bash
# OpenClaw 會從其工作區目錄載入技能
# Nuwa-Skill 會自動部署到那裡
> Create a Jobs distillation
> Apply it to this code review
```

## 效能指標與應用場景

### 提煉品質比較

|| 面向 | 傳統角色扮演 | Nuwa-Skill 五層 |
||--------|---------------------|-------------------|
|| 語調匹配 | 好 | 優秀 |
|| 決策框架 | 差 | 優秀 |
|| 局限意識 | 無 | 完整五層 |
|| 一致性 | 不穩定 | 高 |
|| 適應性 | 低 | 高（可結合脈絡重新提問） |

### 實際應用場景

#### 1. 產品策略

```
User: "我們應該在生產力應用程式中加入社交功能嗎？"

Jobs 模型: "你問錯了問題。真正的问题是：
如果你除了其中一個功能外，移除所有功能，會發生什麼事？"
```

#### 2. 投資分析

```
User: "這個加密貨幣專案值得投資嗎？"

Munger 模型: "讓我重新框架：創辦人的誘因是什麼？
他們與股東利益一致嗎？讓我看看他們的實際投入。"
```

#### 3. 技術架構

```
User: "我們應該建構單體還是微服務？"

Torvalds 模型: "我不在乎架構。我在乎的是
程式碼能不能運作。從可行的開始。如果真的出問題了再重構。"
```

## 進階用法

### 自訂提煉

你可以透過添加特定指令來優化提煉：

```
> Distill Tim Cook but focus specifically on supply chain management
> and operational excellence, not his public speaking style

> Distill my PhD advisor with emphasis on their experimental design
> methodology and paper review patterns
```

### 組合多個提煉

```
> First, analyze this from Buffett's perspective on risk
> Then, from Musk's perspective on first principles
> Finally, synthesize both viewpoints
```

### 匯出與分享

生成的技能可以匯出和分享：

```bash
# 匯出技能
cat ~/.claude/skills/nuwa-skill/SKILL.md > jobs-distilled.md

# 與團隊成員分享
scp jobs-distilled.md team@example.com:~/skills/

# 他們透過指向你的 URL 來安裝
npx skills add https://your-server.com/jobs-distilled.md
```

### 為個人用途建立技能

除了知名人士，Nuwa-Skill 也可以捕捉任何你想保留思維模式的人：

```
> Distill my mentor Sarah — she's great at system design
> and always asks "what breaks first?" when reviewing architecture

> Distill the engineering team's decision-making patterns
> from our last 10 architecture review meetings
```

## 與替代方案比較

|| 功能 | Nuwa-Skill | 傳統角色扮演提示 | 自訂微調 | 角色卡 |
||---------|-----------|---------------------------|-------------------|----------------|
|| 設定時間 | 1 個指令 | 5 分鐘撰寫 | 2-4 小時 | 10-30 分鐘 |
|| 認知深度 | 5 層 | 表面語調 | 深但靜態 | 不穩定 |
|| 多執行環境 | 50+ 執行環境 | 僅聊天介面 | 模型特定 | 平台特定 |
|| 更新能力 | 隨時重新提煉 | 重寫提示 | 需要重新訓練 | 編輯 JSON |
|| 局限意識 | 內建（第 5 層） | 無 | 無 | 罕見 |
|| Agent 整合 | 原生（SKILL.md） | 僅聊天訊息 | 僅 API 呼叫 | 聊天訊息 |

## 局限性 / 誠實評估

Nuwa-Skill 雖然創新，但有重要的局限性：

1. **僅限公開資訊** — 提煉受限於該人物已公開表達的內容。私密想法和未言明的框架無法被捕捉。

2. **時間快照** — 提煉捕捉的是人物在特定時間點的思維。人們會演變，除非重新提煉，否則技能不會反映這種演變。

3. **無法轉移直覺** — 正如 README 所述：「提煉無法捕捉直覺——框架可以被提取，靈感則不行。」技能提供認知模式，而非創意火花。

4. **執行環境依賴** — 輸出的品質取決於底層 LLM。較弱的模型可能無法忠實遵循五層指令。

5. **研究品質參差不齊** — 提煉的品質取決於目標人物公開內容的質量和數量。公眾記錄有限的冷門人物會產生較薄的提煉結果。

6. **不是該人物的替代品** — 技能捕捉思維模式，而非人類認知的全部複雜性。它是決策輔助工具，而非通靈媒介。

## 常見問題

**Q：Nuwa-Skill 與單純使用角色扮演提示有何不同？**

A：傳統角色扮演提示僅捕捉表面語調和詞彙。Nuwa-Skill 的五層提取會捕捉決策經驗法則、反模式和誠實聲明的局限性——產生更實用的認知框架。

**Q：我可以提煉自己嗎？**

A：可以，這是最實用的應用場景之一。系統會分析你的公開內容（部落格文章、推文、GitHub 提交、訪談記錄）並將你的獨特思維模式提煉為一個技能，你可以在所有 Agent 執行環境中使用。

**Q：Nuwa-Skill 會儲存我的資料嗎？**

A：Nuwa-Skill 是一個本機優先的框架。SKILL.md 檔案儲存在你本機 Agent 執行環境的技能目錄中。提煉過程中不會向外部伺服器發送任何資料。

**Q：我可以建立多少提煉？**

A：沒有硬性限制。你可以建立任意數量的技能。[colleague-skill](https://github.com/titanwings/colleague-skill) 專案證明了提煉同事是可行的——但為何只停在同事？

**Q：Nuwa-Skill 與 MCP 有什麼區別？**

A：Nuwa-Skill 使用 Agent Skills 協議（agentskills.io），這是一個與 MCP 不同的標準。它專門為可複用的認知框架設計，而非工具介面。它與 MCP 並存運作，而非取代 MCP。

**Q：我可以將 Nuwa-Skill 用於 OpenAI 的 ChatGPT 嗎？**

A：不能直接使用，因為 ChatGPT 不支援 Agent Skills 協議。不過，你可以將 SKILL.md 內容直接貼入 ChatGPT 對話中，或使用 ChatGPT 的自訂指示功能來達到類似效果。

## 結論

Nuwa-Skill 代表了 AI Agent 增強的新範式——它不問「我應該使用哪種模型」，而是問「我應該借用誰的思維」。透過將專家、歷史人物和導師的認知操作系統提煉為可複用、可部署的技能，它賦予你一項超能力：即時存取世界上最佳思維者的決策框架。

Nuwa-Skill 的美在於它的簡潔：一個指令、50+ 執行環境、無限的提煉可能性。從史蒂夫·賈伯斯的产品哲學、華倫·巴菲特的投資經驗法則，到你經理的電子郵件模式，你需要的認知框架只需一個 `npx skills add` 就能取得。

**嘗試 Nuwa-Skill：** [github.com/alchaincyf/nuwa-skill](https://github.com/alchaincyf/nuwa-skill)

**相關文章：**
- [Headroom](https://dibi8.com/headroom-token-compression-proxy-library-mcp-server) — 將 LLM 輸入壓縮 60-95%
- [Matt Pocock 的技能](https://dibi8.com/mattpocock-skills-ai-agent-framework-guide) — AI Agent 超級能力的 CLI 框架

**來源與延伸閱讀：**
- Agent Skills 協議：https://agentskills.io
- 通用技能安裝器：https://github.com/vercel-labs/skills
- Colleague-skill（前身為）：https://github.com/titanwings/colleague-skill
- GitHub 儲存庫：https://github.com/alchaincyf/nuwa-skill

---

加入我們的社群，取得更多 AI 工具深度解析：[t.me/DIBI8_Group](https://t.me/DIBI8_Group)

**免責聲明：** 本文僅供資訊用途。提煉基於公開可用的資訊，不代表所描述人物的真實想法。請獨立驗證所有聲明。附屬披露：上述部分連結可能包含附屬代碼。我們可能會獲得佣金，不會為你帶來額外成本。
