---
title: "Browser Harness：让 LLM 自主操控浏览器的自愈型神器"
description: "Browser Harness 是一个自愈合型浏览器控制框架，让 LLM 能够自主完成任何网页任务。11K+ Stars，Python 编写，支持 Playwright 和 Selenium。"
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Go
  - Python
application_domain: "Llm Frameworks"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "1.2 MB"
file_md5: ""
download_url: "https://github.com/browser-use/browser-harness"
backup_url: ""
github_repo: "https://github.com/browser-use/browser-harness"
stars: 13142
maintainer: "browser-use"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
faqs:
  - q: 'Browser Harness 是什么？'
    a: 'Browser Harness 是一个自愈型浏览器控制框架，让大语言模型能够像人类一样自主完成网页任务。它用 Python 编写，同时支持 Playwright 和 Selenium，由 browser-use 团队维护。'
  - q: 'Browser Harness 的自愈机制是如何工作的？'
    a: '当某个操作失败时，Browser Harness 会截取屏幕截图，让 LLM 诊断问题，生成新的策略并重试。它会循环执行这个「检测—分析—重新生成—重试」的过程，直到任务成功，或确认任务无法完成。'
  - q: 'Browser Harness 与 Playwright 和 Selenium 有什么不同？'
    a: 'Playwright 和 Selenium 依赖固定的 CSS 选择器或 XPath，页面一变就会失效，需要手动维护。而 Browser Harness 则借助 LLM 理解页面语义、自动规划多步骤任务，并在选择器失效时自我修复，因此你只需用自然语言描述目标，而不必为每一步编写代码。'
  - q: 'Browser Harness 能处理验证码（CAPTCHA）和动态内容吗？'
    a: 'Browser Harness 可以借助 LLM 解决部分验证码（CAPTCHA），并会自动等待动态内容加载，但文章指出，某些复杂的验证码仍然需要人工介入。'
  - q: 'Browser Harness 的主要局限有哪些？'
    a: '它的局限包括：成本（LLM API 调用会产生费用，不过可以改用本地模型）、速度（由于模型需要时间进行推理，它比传统自动化更慢）、安全性（需要严格的防护措施来防止误操作），以及复杂的验证码（CAPTCHA）可能仍然需要人工处理。'
---
{</* resource-info */>}

## 问题：传统爬虫已死，AI 时代需要新范式

你写了一个精美的爬虫脚本，第二天网站改版，全部失效。你修复了选择器，一周后 CDN 路径变了，又失效了。你加了异常处理，但验证码弹出来了，彻底卡死。

**传统网页自动化有三个致命弱点：**

1. **脆弱性** — 页面结构一变，脚本全挂
2. **静态性** — 只能执行预设流程，无法应对意外
3. **被动性** — 遇到验证码、弹窗、加载失败就束手无策

我们需要一种**像人类一样浏览网页**的自动化方式 —— 看得懂页面、能理解意图、会自我修复。

## Browser Harness 是什么？

[Browser Harness](https://github.com/browser-use/browser-harness) 是一个**自愈合型浏览器控制框架**，让 LLM（大语言模型）能够像人类一样自主完成任何网页任务。

- **11,251+ Stars** on GitHub
- **1,019+ Forks**
- 用 **Python** 编写
- 支持 **Playwright** 和 **Selenium**
- 由 **browser-use** 团队维护

核心口号：**"Self-healing harness that enables LLMs to complete any task."**

## 核心能力

### 1. 自愈合（Self-Healing）

传统自动化：
```python
# 脆弱的选择器，页面一改就失效
button = driver.find_element(By.CSS_SELECTOR, "#submit-btn")
button.click()
```

Browser Harness：
```python
# LLM 理解页面语义，自动找到正确的按钮
# 即使 id 变了，也能通过上下文理解
result = harness.execute("点击提交按钮")
# 如果按钮找不到，LLM 会分析页面并提出替代方案
```

**自愈机制**：
- 操作失败 → 截图分析 → LLM 诊断 → 生成新策略 → 重试
- 循环直到成功或确认无法完成

### 2. 语义理解（Semantic Understanding）

Browser Harness 不依赖 CSS 选择器，而是让 LLM **理解页面内容**：

```python
# 告诉 LLM 目标，而不是步骤
harness.execute("在亚马逊搜索无线耳机，按评分排序，选择第一个结果加入购物车")

# LLM 会自动：
# 1. 找到搜索框
# 2. 输入 "wireless headphones"
# 3. 找到排序下拉菜单
# 4. 选择 "Customer Reviews"
# 5. 找到第一个商品
# 6. 点击 "Add to Cart"
```

### 3. 多步骤任务规划

```python
from browser_harness import Harness

harness = Harness(model="gpt-4o")

# 复杂多步骤任务
task = """
帮我订一张下周三从北京到上海的机票，
要求：
- 上午出发
- 价格低于 1000 元
- 东航或国航
- 不需要托运
"""

result = harness.execute(task)
# LLM 会规划步骤：
# 1. 打开携程/去哪儿
# 2. 选择单程
# 3. 输入北京 → 上海
# 4. 选择下周三日期
# 5. 筛选上午航班
# 6. 按价格排序
# 7. 筛选东航/国航
# 8. 选择无托运票价
# 9. 填写乘客信息
# 10. 提交订单
```

### 4. 视觉感知（Visual Perception）

Browser Harness 可以给 LLM 发送页面截图，让模型"看到"网页：

```python
# 截图分析
screenshot = harness.screenshot()
analysis = harness.llm.analyze_image(screenshot, 
    "这个页面上有什么表单？请描述每个输入框的标签和类型")

# LLM 返回：
# "页面有一个登录表单：
#  - 用户名输入框（type=text）
#  - 密码输入框（type=password）
#  - 记住我复选框
#  - 登录按钮"
```

### 5. 与现有工具对比

| 特性 | Browser Harness | Playwright | Selenium | Scrapy |
|------|----------------|-----------|----------|--------|
| **自愈合** | ✅ 自动修复 | ❌ 手动维护 | ❌ 手动维护 | ❌ 手动维护 |
| **语义理解** | ✅ LLM 驱动 | ❌ 选择器 | ❌ 选择器 | ❌ XPath |
| **多步骤规划** | ✅ 自动规划 | ⚠️ 需编码 | ⚠️ 需编码 | ⚠️ 需编码 |
| **验证码处理** | ✅ LLM 可解 | ❌ 需第三方 | ❌ 需第三方 | ❌ 需第三方 |
| **动态内容** | ✅ 自动等待 | ⚠️ 需配置 | ⚠️ 需配置 | ⚠️ 需配置 |
| **学习成本** | 低（自然语言） | 中 | 中 | 高 |

## 架构设计

```
Browser Harness
├── LLM Core (GPT-4o / Claude / Local LLM)
├── Browser Controller (Playwright / Selenium)
├── Self-Healing Engine
│   ├── Error Detection
│   ├── Screenshot Analysis
│   ├── Strategy Regeneration
│   └── Retry Logic
├── Task Planner
│   ├── Goal Decomposition
│   ├── Step Sequencing
│   └── Dependency Resolution
└── Safety Guardrails
    ├── URL Whitelist
    ├── Action Limits
    └── Human-in-the-Loop
```

## 安装与使用

### 安装

```bash
pip install browser-harness

# 安装浏览器依赖
playwright install
```

### 基本用法

```python
from browser_harness import Harness

# 初始化
harness = Harness(
    model="gpt-4o",  # 或 "claude-3-5-sonnet"
    browser="chromium",
    headless=False   # 可见模式便于调试
)

# 执行简单任务
result = harness.execute("打开 Google 搜索 'Python tutorial'")

# 执行复杂任务
task = """
1. 访问 github.com
2. 搜索 'browser-use/browser-harness'
3. 点击 Star 按钮
4. 返回 star 数量
"""
result = harness.execute(task)
print(result)  # "当前 Stars: 11251"
```

### 高级配置

```python
from browser_harness import Harness, Config

config = Config(
    max_retries=3,           # 最大重试次数
    retry_delay=2,           # 重试间隔（秒）
    screenshot_on_error=True, # 出错时截图
    human_in_the_loop=True,   # 关键操作人工确认
    url_whitelist=[           # URL 白名单
        "*.github.com",
        "*.google.com"
    ]
)

harness = Harness(model="gpt-4o", config=config)
```

## 实际应用场景

### 场景 1：自动化测试

```python
# 让 LLM 测试你的网站
test_cases = [
    "注册一个新用户，验证收到确认邮件",
    "添加商品到购物车，检查总价计算正确",
    "提交表单时留空必填项，验证错误提示"
]

for test in test_cases:
    result = harness.execute(test)
    assert result.success, f"测试失败: {test}"
```

### 场景 2：数据采集

```python
# 智能爬虫，自动适应网站变化
data = harness.execute("""
访问 example.com/products，
提取所有产品的：
- 名称
- 价格
- 评分
- 库存状态
保存为 JSON
""")
```

### 场景 3：自动化办公

```python
# 自动处理日常网页任务
harness.execute("""
1. 登录公司报销系统
2. 提交上月的差旅报销单
3. 上传发票 PDF
4. 填写审批人
5. 提交申请
""")
```

### 场景 4：竞品监控

```python
# 每天检查竞品价格
harness.execute("""
访问 amazon.com，搜索我们的核心产品关键词，
记录前 10 个结果的价格和评分，
生成对比报告
""")
```

## 与类似项目对比

| 项目 | Stars | 特点 | 适用场景 |
|------|-------|------|---------|
| **Browser Harness** | 11K+ | 自愈合、LLM 驱动 | 通用网页任务 |
| **Playwright** | 66K+ | 高性能、多浏览器 | 自动化测试 |
| **Selenium** | 30K+ | 成熟稳定 | 传统自动化 |
| **Scrapy** | 52K+ | 大规模爬取 | 数据采集 |
| **Crawl4AI** | 8K+ | AI 爬虫 | 内容提取 |

## 局限性

- **成本** — LLM API 调用有费用（但可用本地模型）
- **速度** — 比传统自动化慢（思考需要时间）
- **安全** — 需要严格的安全策略防止误操作
- **复杂验证码** — 某些验证码仍需要人工介入

## 结论

Browser Harness 代表了**网页自动化的新范式** —— 从"写死的选择器"到"理解的智能体"。

- 自愈合能力大幅降低维护成本
- 自然语言接口降低使用门槛
- LLM 的推理能力处理复杂流程
- 视觉感知解决传统自动化的盲区

如果你厌倦了每周修复崩溃的爬虫脚本，Browser Harness 值得一试。

**GitHub**: [browser-use/browser-harness](https://github.com/browser-use/browser-harness)  
**Stars**: 11,251+ | **Language**: Python | **License**: Open Source

## Related Articles

- [Hermes Agent: Self-Improving AI Agent](/zh/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)
- [Agent Reach: Give Your AI Agent Internet Superpowers](/zh/resources/llm-frameworks/agent-reach-ai-agent-internet-access/)

---

## 推荐工具

跑或部署开源 AI 工具时，推荐：

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — 新用户 $200 试用 60 天，全球 14+ 数据中心，AI 工作流 droplet 一键部署。

*推广链接 — 不增加你的成本，能支持 dibi8.com 持续运营。*

## 推荐工具

**需要稳定的 Claude / OpenAI API 访问？** 这个领域的项目最终都会撞 Anthropic / OpenAI 限流或价格墙。

- **{{< aff "shiyunapi" "llm-footer" "Shiyunapi" >}}** — Claude / OpenAI / DeepSeek API 中转。一个 key 同时访问多家顶级模型, 价格约官方 30%; 迭代 agent prompt 或国内/受限地区直连不通时尤其管用。

*推广链接 — 不增加你的成本, 帮助 dibi8.com 持续运营。*

