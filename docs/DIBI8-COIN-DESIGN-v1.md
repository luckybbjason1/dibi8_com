# DIBI8 Coin 页面设计方案 v1.0

## 项目概述
为 dibi8.com 创建 DIBI8 Coin 品牌叙事页面，采用 Bento Grid 布局和 Web3 美学风格。

## 设计目标
1. **品牌强化** - 建立 DIBI8 的社区价值和品牌识别
2. **社区激励** - 传达社区贡献的价值认可
3. **视觉冲击** - 使用现代化的 Bento Grid + Web3 美学
4. **六维对称** - 六个核心维度的平衡布局
5. **用户易用** - 清晰的导航和直观的信息层级

## 六维对称题材定义

### 维度 1: 社区 (Community)
- 核心价值：共建、共享、共治
- 关键元素：社区规模、活跃贡献者、TG频道

### 维度 2: 激励 (Incentives)
- 核心价值：贡献即获得回报
- 关键元素：积分系统、贡献排行榜、奖励机制

### 维度 3: 治理 (Governance)
- 核心价值：社区决策、透明投票
- 关键元素：治理提案、投票机制、DAO愿景

### 维度 4: 技术 (Technology)
- 核心价值：去中心化、安全、可扩展
- 关键元素：技术架构、区块链基础、安全性

### 维度 5: 生态 (Ecosystem)
- 核心价值：工具整合、价值网络
- 关键元素：集成工具、合作伙伴、API生态

### 维度 6: 愿景 (Vision)
- 核心价值：AI民主化、价值回归
- 关键元素：长期愿景、社会影响、可持续发展

## 布局设计 (Bento Grid)

```
┌─────────────────────────────────────────────────────────────┐
│  HERO SECTION (span 3 cols)                                  │
│  • DIBI8 Coin 标题 + 副标题                                   │
│  • 核心叙事：社区驱动的AI工具发现平台                           │
│  • CTA按钮：加入社区 / 了解更多                                │
├──────────────┬──────────────┬────────────────────────────────┤
│ COMMUNITY    │ INCENTIVES   │ GOVERNANCE                     │
│ (统计卡片)    │ (激励卡片)    │ (治理卡片)                      │
│ • 成员数     │ • 积分系统    │ • 提案机制                      │
│ • 活跃度     │ • 贡献排名    │ • 投票透明                      │
├──────────────┴──────────────┼──────────────┬────────────────┤
│ TECHNOLOGY                 │ ECOSYSTEM    │ VISION           │
│ (技术卡片 - 横向大卡)       │ (生态卡片)    │ (愿景卡片)        │
│ • 架构说明                  │ • 工具集成    │ • 长期目标        │
│ • 安全特性                  │ • 合作伙伴    │ • 社会价值        │
├─────────────────────────────────────────────────────────────┤
│ CALL TO ACTION (全宽)                                       │
│ • 加入 Telegram 社区                                         │
│ • 开始贡献                                                   │
│ • 了解更多信息                                                │
└─────────────────────────────────────────────────────────────┘
```

## 设计风格规范

### 色彩系统
| 用途 | 颜色值 | 说明 |
|------|--------|------|
| 背景主色 | #0a0a0f | 深空黑 |
| 背景次色 | #12121a | 深色区域 |
| 主要文字 | #f1f5f9 | 高对比度 |
| 次要文字 | #cbd5e1 | 中层对比度 |
| 霓虹紫 | #8b5cf6 | 主品牌色 |
| 霓虹青 | #22d3ee | 辅助品牌色 |
| 霓虹粉 | #f472b6 | 强调色 |
| 霓虹绿 | #34d399 | 成功/正向 |

### 组件系统
- `.coin-card` - 玻璃态卡片组件
- `.gradient-text` - 渐变文字效果
- `.glow` - 霓虹发光效果
- `.bento-grid` - 响应式网格布局

### 响应式断点
- 桌面 (lg): 4列网格
- 平板 (md): 2列网格
- 手机 (sm): 1列堆叠

## 页面内容规划

### 1. Hero Section
- 大标题：DIBI8 Coin
- 副标题：社区驱动的 AI 工具发现新范式
- 描述：基于社区贡献的去中心化价值网络
- CTA：加入社区 / 探索更多

### 2. 六维卡片内容

#### Community (社区)
- 标题：活跃的创作者社区
- 数据：1000+ 活跃贡献者
- 描述：全球开发者共同构建 AI 工具生态
- 图标：Users / Globe

#### Incentives (激励)
- 标题：贡献即获得回报
- 数据：积分排行榜实时更新
- 描述：你的每一次贡献都被看见和奖励
- 图标：Gift / Award

#### Governance (治理)
- 标题：社区民主决策
- 数据：提案投票透明可追溯
- 描述：每个成员都有平等的发言权
- 图标：Vote / Scale

#### Technology (技术)
- 标题：安全可靠的技术底座
- 数据：去中心化架构
- 描述：基于现代区块链技术创新
- 图标：Shield / Code

#### Ecosystem (生态)
- 标题：整合的 AI 工具生态
- 数据：500+ 工具集成
- 描述：连接工具、用户和价值的网络
- 图标：Puzzle / Network

#### Vision (愿景)
- 标题：AI 民主化的未来
- 数据：让每个工具找到对的用户
- 描述：从中心到去中心化的价值回归
- 图标：Rocket / Target

### 3. Call to Action Section
- 标题：成为社区的一部分
- 三个CTA按钮：
  - 加入 Telegram 社区
  - 开始贡献内容
  - 了解详细路线图

## 技术实现方案

### 文件结构
```
dibi8_com/
├── layouts/
│   ├── coin/
│   │   └── single.html      # DIBI8 Coin 页面模板
│   ├── _default/
│   │   └── baseof.html      # 全局基础模板（已创建）
│   └── partials/
│       ├── nav.html         # 导航组件（已创建）
│       └── footer.html      # 页脚组件（已创建）
├── content/
│   └── coin/
│       └── index.md         # Coin 页面内容
├── static/
│   └── css/
│       └── bento-design-system.css  # 设计系统（已创建）
└── data/
    └── coin.json            # Coin 统计数据
```

### 关键代码片段

#### Hero Section
```html
<section class="hero-section min-h-[60vh] flex items-center justify-center relative overflow-hidden">
  <div class="absolute inset-0 bg-gradient-to-br from-neon-purple/20 via-transparent to-neon-cyan/20"></div>
  <div class="relative z-10 text-center px-4">
    <h1 class="text-5xl md:text-7xl font-black gradient-text mb-6">
      DIBI8 <span class="text-neon-purple">Coin</span>
    </h1>
    <p class="text-xl md:text-2xl text-gray-300 max-w-2xl mx-auto mb-8">
      社区驱动的 AI 工具发现新范式
    </p>
    <div class="flex gap-4 justify-center">
      <a href="#community" class="btn-primary">探索社区</a>
      <a href="#vision" class="btn-secondary">了解愿景</a>
    </div>
  </div>
</section>
```

#### Bento Grid Layout
```html
<div class="bento-grid max-w-7xl mx-auto px-4 py-16">
  <!-- Hero spans 3 columns -->
  <div class="coin-card hero-card span-3">...</div>
  
  <!-- Six dimensions -->
  <div class="coin-card">...</div> <!-- Community -->
  <div class="coin-card">...</div> <!-- Incentives -->
  <div class="coin-card">...</div> <!-- Governance -->
  <div class="coin-card span-2">...</div> <!-- Technology -->
  <div class="coin-card">...</div> <!-- Ecosystem -->
  <div class="coin-card">...</div> <!-- Vision -->
</div>
```

## 后续步骤

1. **用户确认** - 等待用户对设计方案的反馈
2. **规格文档** - 编写详细的实现规格
3. **实现计划** - 创建分步实施计划
4. **开发实现** - 按照计划逐步实现
5. **测试验证** - 确保功能完整性和无障碍访问
6. **部署上线** - 推送到生产环境

---

**状态**: 待用户确认
**版本**: v1.0
**最后更新**: 2026-10-11