---
title: "HowToCook 程序员做饭指南：297 个开源菜谱让 coding 更香"
description: "探索 HowToCook 程序员做饭指南 — 297 个开源菜谱，像写代码一样精确做饭。从番茄炒蛋到北京烤鸭，难度分级，步骤清晰。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Docker
  - JavaScript
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "455.3 MB"
file_md5: ""
download_url: "https://github.com/Anduin2017/HowToCook"
backup_url: ""
github_repo: "https://github.com/Anduin2017/HowToCook"
stars: 100171
maintainer: "Anduin2017"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /zh/posts/howtocook-programmer-open-source-cookbook/
faqs:
  - q: '什么是 HowToCook？'
    a: 'HowToCook（程序员做饭指南）是由程序员 Anduin2017 创建的开源菜谱项目，收录了 297 道菜谱，以开发者习惯的精确和清晰方式编写，就像阅读技术文档一样。'
  - q: 'HowToCook 与传统菜谱有何不同？'
    a: '传统菜谱常用「少许盐」或「炒至金黄」这类模糊表述，而 HowToCook 每道菜都采用精确用量（如「盐 3g」）、精确时间（如「每面煎 90 秒」）、完整的前置食材清单、必备厨具列表，以及 1-5 星难度评级。'
  - q: 'HowToCook 如何按难度给菜谱评级？'
    a: '菜谱采用 1-5 星评级体系：1 星涵盖番茄炒鸡蛋、泡面等简单菜肴，5 星则包含鱼翅汤、鲍鱼粥等高难度料理。整个合集共有 1 星 45 道、2 星 78 道、3 星 89 道、4 星 56 道、5 星 29 道。'
  - q: '如何用 Docker 在本地运行 HowToCook？'
    a: '拉取并运行镜像：docker pull ghcr.io/anduin2017/how-to-cook:latest，再执行 docker run -d -p 5000:5000 ghcr.io/anduin2017/how-to-cook:latest，然后访问 http://localhost:5000 即可。'
  - q: '如何向 HowToCook 贡献菜谱？'
    a: 'Fork 仓库，复制模板菜谱，按项目规定的结构化格式编写你的菜谱，然后提交 Pull Request。该项目已有 200 多位贡献者，支持中文、英文和日文。'
---
{</* resource-info */>}

## HowToCook 是什么？

**HowToCook**（程序员做饭指南）是由程序员 **Anduin2017** 创建的开源菜谱项目。包含 **297 个菜谱**，用程序员习惯的精确性和清晰度编写。

项目理念：**菜谱应该像代码一样清晰**。没有"少许盐"或"炒至金黄"这种模糊描述，每个菜谱都有精确计量、准确时间和步骤化流程。

**GitHub**: https://github.com/Anduin2017/HowToCook  
**Stars**: 70K+  
**贡献者**: 200+  
**协议**: Unlicense

---

## 为什么程序员需要这个？

### 传统菜谱的问题

| 问题 | 例子 | HowToCook 解决方案 |
|------|------|-------------------|
| 模糊用量 | "少许盐" | "3克盐（1/2茶匙）" |
| 含糊时间 | "炒至金黄" | "每面煎90秒" |
| 步骤缺失 | 中间冒出新材料 | 完整食材清单前置 |
| 无难度分级 | 所有菜看起来一样难 | 1-5星难度系统 |
| 无设备清单 | 假设你什么都有 | 所需工具先列出 |

### 为开发者设计的特性

- **结构化格式**：像带参数的函数
- **难度等级**：1-5星（从泡面到北京烤鸭）
- **设备需求**：食材前列出
- **精确计量**：克、毫升，不是"一撮"
- **时间追踪**：准备时间、烹饪时间、总时间
- **错误处理**：常见错误及避免方法

---

## 菜谱分类

### 按难度

| 星级 | 数量 | 例子 |
|------|------|------|
| ⭐ | 45 | 番茄炒蛋、泡面升级 |
| ⭐⭐ | 78 | 宫保鸡丁、红烧肉 |
| ⭐⭐⭐ | 89 | 糖醋排骨、麻婆豆腐 |
| ⭐⭐⭐⭐ | 56 | 北京烤鸭、火锅底料 |
| ⭐⭐⭐⭐⭐ | 29 | 鱼翅汤、鲍鱼粥 |

### 按类型

- **素菜**: 85 道（炒、烧、蒸）
- **荤菜**: 92 道（猪、牛、鸡、羊）
- **海鲜**: 34 道（鱼、虾、蟹）
- **汤羹**: 46 道（快手汤、慢炖汤）
- **早餐**: 23 道（粥、饼、三明治）
- **甜品**: 17 道（蛋糕、布丁、甜汤）

---

## 示例菜谱：番茄炒蛋

```markdown
# 西红柿炒鸡蛋 ⭐

## 食材
- 鸡蛋 2个（100克）
- 西红柿 2个（300克）
- 盐 3克（1/2茶匙）
- 糖 5克（1茶匙）
- 食用油 10毫升
- 小葱 2克（可选）

## 厨具
- 炒锅
- 锅铲
- 碗

## 时间
- 准备：5 分钟
- 烹饪：5 分钟
- 总计：10 分钟

## 步骤
1. 鸡蛋打入碗中，加 1克盐，搅打均匀
2. 西红柿洗净，切成 2厘米块
3. 中火加热锅至 180°C
4. 倒油，等 10 秒
5. 倒入蛋液，持续翻炒 30 秒
6. 鸡蛋 80%凝固时盛出（略带湿润）
7. 同一锅中放入西红柿，炒 2 分钟
8. 加入剩余盐和糖
9. 倒回鸡蛋，混合翻炒 20 秒
10. 立即出锅

## 技巧
- 不要炒过头 — 鸡蛋出锅后还会继续熟
- 如果西红柿太酸，多加 1克糖
- 想要更嫩口感，蛋液中加 10毫升牛奶
```

---

## 社区与贡献

### 如何贡献

1. **Fork** 仓库
2. **复制** 模板菜谱
3. **编写** 符合格式的菜谱
4. **提交** Pull Request

### 贡献统计

- **200+ 贡献者** 来自全球
- **297 道菜谱** 持续增长
- **多语言支持**：中文、英文、日文
- **Docker 支持**：一条命令本地运行

### 网页部署

```bash
# 本地部署
docker pull ghcr.io/anduin2017/how-to-cook:latest
docker run -d -p 5000:5000 ghcr.io/anduin2017/how-to-cook:latest

# 访问 http://localhost:5000
```

---

## NPM 包

作为 Node.js 包安装：

```bash
npm install how-to-cook
```

编程方式使用：

```javascript
const recipes = require('how-to-cook');

// 搜索菜谱
const tomatoRecipes = recipes.search('西红柿');

// 按难度筛选
const easyRecipes = recipes.filterByStars(1);

// 随机获取
const dinner = recipes.random();
```

---

## 学习路径

### 新手（第 1-2 周）
- 厨房准备
- 基础刀工
- 1星菜谱
- 煮饭

### 进阶（第 3-4 周）
- 2-3星菜谱
- 肉类处理
- 炒菜技巧
- 汤羹基础

### 高级（第 5 周+）
- 4-5星菜谱
- 多菜协调
- 味道平衡
- 摆盘

---

## 为什么这个项目值得关注

**HowToCook** 是以下方面的完美示例：

1. **社区驱动内容**：200+ 贡献者创造真实内容
2. **结构化数据**：菜谱遵循 schema.org 格式
3. **长尾关键词**："程序员做饭指南", "how to cook for developers"
4. **常青内容**：烹饪永远不会过时
5. **多语言**：中文、英文、日文版本

---

## 相关文章

- [Free Claude Code 开源 AI 编码代理](/zh/resources/ai-tools/free-claude-code-open-source-proxy/) — 另一个开发者开源工具
- [Pixelle-Video AI 短视频生成器](/zh/resources/ai-tools/pixelle-video-ai-short-video-generator/) — AI 内容创作工具
- [OpenClaw 42 个用例](/zh/resources/llm-frameworks/awesome-openclaw-usecases-ai-agent-daily-life/) — AI 代理日常任务

---

*免责声明：本文介绍开源项目。所有菜谱内容归 HowToCook 社区所有。烹饪时请遵循食品安全指南。*

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Claude / OpenAI / DeepSeek API 中转。上面的 AI 工具 (chatbot / 代码生成 / 翻译 / 搜索 等) 大多需要 LLM API key — 这个中转给你稳定访问顶级模型, 价格约官方 30%。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

