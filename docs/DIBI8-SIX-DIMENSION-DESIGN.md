# DIBI8 六维对称题材网站架构设计方案

**角色**: DIBI8 六维对称题材网站架构与UI/UX顶尖设计师  
**日期**: 2026-10-11  
**项目**: dibi8.com 品牌升级  
**状态**: 设计方案 v1.0

---

## 📋 项目概述

### 现状分析
- **规模**: 755页静态站点, 493+工具, 482篇文章, 5大分类, 14语言
- **设计**: 深空黑(#0a0a0f) + 霓虹紫/青 + Glass-card + Bento Grid
- **合规**: WCAG 2.1 AA无障碍标准
- **部署**: GitHub Pages, Hugo静态生成

### 核心问题
1. **品牌叙事缺失** - 缺乏宏大故事线
2. **六维架构不完整** - 仅Coin Section，缺其他维度
3. **设计风格断层** - 子页面仍用传统模板
4. **用户分层不清** - 未区分技术开发者/Web3爱好者/普通用户

### 设计目标
打造具有**宏大叙事感、正规大站气场、Bento模块化、对称美学**的六维全新数字平台。

---

## 🎨 六维内容架构设计

### 维度定义

```
┌─────────────────────────────────────────────────────────────┐
│                    DIBI8 六维对称架构                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   ┌─────────────┐  ┌─────────────┐  ┌─────────────┐       │
│   │  1.工具发现  │  │  2.生态报告  │  │  3.价格对比  │       │
│   │ Tools       │  │ Reports     │  │ Compare     │       │
│   │ Discovery   │  │ 生态        │  │ 对比        │       │
│   └─────────────┘  └─────────────┘  └─────────────┘       │
│           ↓                ↓                ↓             │
│   ┌──────────────────────────────────────────────────┐    │
│   │              4.使用指南 (Guides)                 │    │
│   │              教程+配置+最佳实践                   │    │
│   └──────────────────────────────────────────────────┘    │
│                          ↓                               │
│   ┌──────────────────────────────────────────────────┐    │
│   │              5.社区动态 (Community)              │    │
│   │              Telegram+讨论+事件                   │    │
│   └──────────────────────────────────────────────────┘    │
│                          ↓                               │
│   ┌──────────────────────────────────────────────────┐    │
│   │              6.开发者资源 (Developer)            │    │
│   │              API+开源+贡献指南                    │    │
│   └──────────────────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 六维详细规格

#### 1️⃣ 工具发现 (Tools Discovery)
- **核心功能**: 493+ AI工具收录，多维度分类
- **用户分层**:
  - 普通用户: 一键推荐、场景化筛选
  - 技术开发者: 代码示例、API文档、性能数据
  - Web3爱好者: Tokenomics、路线图、白皮书
- **Bento卡片规格**:
  - 尺寸: span-2 (桌面), span-1 (平板), 100% (手机)
  - 色彩: 霓虹青 (#22d3ee)
  - 图标: `fas fa-tools`
  - 动效: hover时边框发光

#### 2️⃣ 生态报告 (Ecosystem Reports)
- **核心功能**: 482篇深度评测文章
- **内容分类**:
  - AI编程代理评测 (401篇)
  - LLM框架对比 (53篇)
  - MCP工具生态 (14篇)
  - 开发工具指南 (2篇)
  - AI应用工具 (2篇)
- **Bento卡片规格**:
  - 尺寸: span-2
  - 色彩: 霓虹紫 (#8b5cf6)
  - 图标: `fas fa-chart-line`

#### 3️⃣ 价格对比 (Price Comparison)
- **核心功能**: 免费版 vs 付费版对比，性价比分析
- **数据维度**:
  - 月费价格
  - 免费额度
  - 功能差异
  - 适用场景
- **Bento卡片规格**:
  - 尺寸: span-2
  - 色彩: 霓虹粉 (#f472b6)
  - 图标: `fas fa-coins`

#### 4️⃣ 使用指南 (Usage Guides)
- **核心功能**: 配置教程、最佳实践、常见问题
- **内容类型**:
  - 快速开始指南
  - 高级配置教程
  - 性能优化技巧
  - 故障排查手册
- **Bento卡片规格**:
  - 尺寸: span-4 (全宽)
  - 色彩: 霓虹绿 (#34d399)
  - 图标: `fas fa-book-open`

#### 5️⃣ 社区动态 (Community Hub)
- **核心功能**: Telegram频道、讨论区、活动事件
- **互动维度**:
  - 实时动态 (最新工具推荐)
  - 用户讨论 (热门话题)
  - 贡献者排行 (积分系统)
  - 活动预告 (线上研讨会)
- **Bento卡片规格**:
  - 尺寸: span-4 (全宽)
  - 色彩: 霓虹黄 (#fbbf24)
  - 图标: `fas fa-comments`

#### 6️⃣ 开发者资源 (Developer Hub)
- **核心功能**: API文档、开源项目、贡献指南
- **资源类型**:
  - GitHub仓库 (dibi8_com)
  - API接口文档
  - 贡献者指南
  - 插件开发教程
- **Bento卡片规格**:
  - 尺寸: span-4 (全宽)
  - 色彩: 天蓝 (#38bdf8)
  - 图标: `fas fa-code`

---

## 🏗️ 架构层级设计

### 首页 (Landing Page)
```
┌─────────────────────────────────────────────────────────────┐
│  [导航栏] Logo | 分类 | 合集 | 关于 | 搜索 | Telegram      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ╔═══════════════════════════════════════════════════════╗  │
│  ║  HERO SECTION (span-4)                                ║  │
│  ║  DIBI8 · 六维AI工具发现平台                            ║  │
│  ║  让AI工具触手可及                                      ║  │
│  ╚═══════════════════════════════════════════════════════╝  │
│                                                             │
│  ┌──────────────┬──────────────┬──────────────┬──────────┐ │
│  │  1.工具发现   │  2.生态报告   │  3.价格对比   │ 4.使用指南│ │
│  │  (span-2)    │  (span-2)    │  (span-2)    │(span-2)  │ │
│  └──────────────┴──────────────┴──────────────┴──────────┘ │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  5.社区动态 (span-4)                                  │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  6.开发者资源 (span-4)                                 │  │
│  └──────────────────────────────────────────────────────┘  │
│                                                             │
│  [页脚] 品牌 | 链接 | 社交媒体 | 法律声明                   │
└─────────────────────────────────────────────────────────────┘
```

### 子页面架构

#### /categories/ (分类页)
- 五维度分类导航
- 分类筛选器
- 工具卡片网格

#### /collections/ (合集页)
- 主题合集展示
- 用户创建合集
- 合集收藏功能

#### /about/ (关于页)
- 品牌故事
- 团队介绍
- 联系方式

#### /dibi8-coin/ (Coin页 - 待实现)
- 六维对称Bento Grid
- Tokenomics信息
- 路线图展示

---

## 🎨 视觉设计系统

### 色彩体系
```css
:root {
  /* 背景色 */
  --bg-primary: #0a0a0f;      /* 深空黑 */
  --bg-secondary: #12121a;    /* 次级背景 */
  --bg-tertiary: #1e1e2e;     /* 三级背景 */
  
  /* 六维主色 */
  --dim-1-tools: #22d3ee;     /* 工具发现 - 霓虹青 */
  --dim-2-reports: #8b5cf6;   /* 生态报告 - 霓虹紫 */
  --dim-3-price: #f472b6;     /* 价格对比 - 霓虹粉 */
  --dim-4-guides: #34d399;    /* 使用指南 - 霓虹绿 */
  --dim-5-community: #fbbf24; /* 社区动态 - 霓虹黄 */
  --dim-6-dev: #38bdf8;       /* 开发者资源 - 天蓝 */
  
  /* 文字色 */
  --text-primary: #f1f5f9;    /* 主文字 - 对比度16.5:1 ✓ */
  --text-secondary: #cbd5e1;  /* 次级文字 - 对比度11.2:1 ✓ */
  --text-muted: #94a3b8;      /* 暗示文字 - 对比度7.5:1 ✓ */
  
  /* 渐变 */
  --gradient-hero: linear-gradient(135deg, #8b5cf6 0%, #22d3ee 50%, #f472b6 100%);
}
```

### Bento Grid规格
```css
.bento-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.5rem;
}

/* 尺寸变体 */
.span-1 { grid-column: span 1; }
.span-2 { grid-column: span 2; }
.span-3 { grid-column: span 3; }
.span-4 { grid-column: span 4; }

/* 响应式 */
@media (max-width: 1024px) {
  .bento-grid { grid-template-columns: repeat(2, 1fr); }
}
@media (max-width: 640px) {
  .bento-grid { grid-template-columns: 1fr; }
}
```

### Glass Card组件
```css
.glass-card {
  background: rgba(255, 255, 255, 0.05);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.12);
  border-radius: 1rem;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.glass-card:hover {
  background: rgba(255, 255, 255, 0.08);
  border-color: var(--border-hover);
  transform: translateY(-2px);
  box-shadow: var(--shadow-card);
}
```

---

## ♿ 无障碍访问规范

### WCAG 2.1 AA 合规
- ✅ 文字对比度 ≥ 4.5:1
- ✅ 键盘导航支持 (Tab顺序合理)
- ✅ ARIA属性完整
- ✅ Focus可见指示器
- ✅ Reduced motion支持

### 具体实现
```html
<!-- Skip Link -->
<a href="#main-content" class="skip-link">跳转到主要内容</a>

<!-- ARIA Labels -->
<section aria-labelledby="tools-heading">
  <h2 id="tools-heading">工具发现</h2>
</section>

<!-- Focus Indicators -->
:focus-visible {
  outline: 2px solid var(--neon-purple);
  outline-offset: 2px;
}

<!-- Reduced Motion -->
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 📱 响应式策略

### 断点设计
```css
/* 手机 (320px-640px) */
/* 单列布局，汉堡菜单，触摸优化 */

/* 平板 (641px-1024px) */
/* 双列Bento Grid，顶部固定导航 */

/* 桌面 (1025px+) */
/* 四列Bento Grid，侧边导航可选 */
```

### 触摸优化
- 最小触摸目标: 44x44px
- 触摸反馈: active状态样式
- 手势支持: 滑动切换Tab（未来）

---

## 🔧 技术实现方案

### 文件结构
```
dibi8_com/
├── layouts/
│   ├── index.html                    # 首页 (Bento Grid六维)
│   ├── _default/
│   │   ├── baseof.html               # 基础模板
│   │   ├── single.html               # 文章页
│   │   └── list.html                 # 列表页
│   ├── coin/
│   │   ├── single.html               # Coin单页
│   │   └── list.html                 # Coin列表
│   ├── categories/
│   │   └── list.html                 # 分类列表
│   └── collections/
│       └── list.html                 # 合集列表
├── static/css/
│   ├── bento-design-system.css       # 设计令牌系统
│   └── coin-components.css           # Coin组件样式
├── CN/
│   ├── about/index.md                # 关于页
│   ├── dibi8-coin.md                 # Coin介绍
│   └── ... (482篇文章)
└── docs/
    └── DIBI8-SIX-DIMENSION-DESIGN.md # 本文档
```

### Hugo配置优化
```toml
# config.toml
[params]
  # 六维架构配置
  six_dimensions = true
  dim_tools = "Tools Discovery"
  dim_reports = "Ecosystem Reports"
  dim_price = "Price Comparison"
  dim_guides = "Usage Guides"
  dim_community = "Community Hub"
  dim_dev = "Developer Resource"
  
  # 用户分层配置
  user_tiers = ["beginner", "developer", "web3"]
  
  # 动画配置
  enable_animations = true
  reduced_motion = true
```

---

## 📝 文案规范

### Hero Section
```
主标题: DIBI8 · 六维AI工具发现平台
副标题: 让AI工具触手可及
描述: 基于六维对称架构的权威AI工具导航，涵盖工具发现、生态报告、价格对比、使用指南、社区动态、开发者资源六大维度。
```

### 六维标题
```
1. 工具发现 - 发现最佳AI工具
2. 生态报告 - 深度评测AI生态
3. 价格对比 - 找到最优性价比
4. 使用指南 - 掌握高效用法
5. 社区动态 - 连接全球开发者
6. 开发者资源 - 共建开放生态
```

---

## ✅ 设计验证清单

### 视觉验证
- [ ] Bento Grid对称布局
- [ ] 六维色彩区分明显
- [ ] Glass-card效果正确
- [ ] 渐变文字可读性

### 功能验证
- [ ] 导航链接可访问
- [ ] 搜索功能正常
- [ ] 响应式布局正确
- [ ] 动画效果流畅

### 无障碍验证
- [ ] ARIA属性完整
- [ ] 键盘导航支持
- [ ] 对比度达标
- [ ] Reduced motion支持

### 性能验证
- [ ] 首屏加载 < 2秒
- [ ] 核心Web Vital达标
- [ ] 图片懒加载
- [ ] 代码分割

---

## 🚀 实施优先级

### Phase 1: 核心架构 (P0)
1. 更新首页Bento Grid布局
2. 完善六维卡片组件
3. 统一设计令牌系统

### Phase 2: 子页面升级 (P1)
1. 更新single.html模板
2. 更新list.html模板
3. 统一导航和页脚

### Phase 3: 功能增强 (P2)
1. 添加DIBI8 Coin页面
2. 实现用户分层推荐
3. 添加高级筛选功能

### Phase 4: 性能优化 (P3)
1. 图片懒加载
2. 关键CSS内联
3. 字体优化

---

## 📌 重要声明

**本设计方案为品牌叙事型设计，非真实代币发行。**

DIBI8 Coin是平台社区价值的象征性表达，用于：
- 强化社区参与感
- 传达价值共享理念
- 展示未来治理愿景

**不包含：**
- ❌ 真实代币发行
- ❌ 智能合约
- ❌ 实际供应量
- ❌ 交易功能

---

**设计版本**: v1.0  
**状态**: 待用户审查  
**下次更新**: 根据反馈迭代
