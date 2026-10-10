# DIBI8 Coin 六维Bento Grid 实现方案

## 项目概述
基于 dibi8.com 真实数据，创建DIBI8 Coin品牌叙事页面，采用六维对称Bento Grid布局。

## 核心发现
- dibi8.com **没有**真实的DIBI8 Coin代币信息
- 现有内容：493+ AI工具收录，5大分类，14种语言支持
- 策略：将DIBI8 Coin定位为**品牌叙事**和**社区价值象征**

## 设计规格

### 六维架构
```
┌─────────────────────────────────────────────────────────────┐
│  HERO SECTION (span-4)                                      │
│  DIBI8 Coin · 社区驱动的 AI 工具发现新范式                  │
├──────────────┬──────────────┬──────────────┬───────────────┤
│ COMMUNITY    │ INCENTIVES   │ GOVERNANCE   │ VISION        │
│ (span-2)     │ (span-1)     │ (span-1)     │ (span-1,row2) │
│ • 493+工具   │ • 积分系统   │ • 提案透明   │ • AI民主化    │
│ • 5大分类    │ • 排行榜     │ • 投票机制   │ • 价值回归    │
├──────────────┴──────────────┼──────────────┴───────────────┤
│ TECHNOLOGY (span-2)        │ ECOSYSTEM (span-1)           │
│ • Hugo+Tailwind            │ • 493工具集成                │
│ • WCAG 2.1 AA              │ • 14语言支持                 │
├─────────────────────────────────────────────────────────────┤
│ CALL TO ACTION (span-4)                                     │
│ • 加入 Telegram 社区                                        │
│ • 开始贡献                                                  │
│ • 了解路线图                                                │
└─────────────────────────────────────────────────────────────┘
```

### 色彩系统
| 维度 | 颜色 | 值 |
|------|------|-----|
| Community | 绿色 | #34d399 |
| Incentives | 粉色 | #f472b6 |
| Governance | 紫色 | #8b5cf6 |
| Technology | 青色 | #22d3ee |
| Ecosystem | 黄色 | #fbbf24 |
| Vision | 天蓝 | #38bdf8 |

### 设计令牌
- 背景：#0a0a0f (深空黑)
- 主文字：#f1f5f9 (对比度 16.5:1 ✓ AAA)
- 次要文字：#cbd5e1 (对比度 11.2:1 ✓ AAA)
- 玻璃态：backdrop-blur(12px) + border-white/10

## 已实现文件
1. `layouts/coin/single.html` - 完整页面模板
2. `static/css/design-tokens.css` - 设计令牌系统
3. `static/css/coin-components.css` - 组件样式
4. `CN/coin/index.md` - 页面内容

## 下一步
根据用户选择，决定：
- A: 集成到首页
- B: 继续调试
- C: 纯HTML演示
