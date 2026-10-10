# DIBI8 Bento Grid 首页重构方案

## 项目背景
dibi8.com 现有站点已完成 SEO/GEO 基础优化（2026-09-29），但品牌叙事薄弱，视觉体验同质化。本次重构目标：打造专业 AI 工具发现平台的品牌认知，采用现代 Bento Grid 布局提升视觉冲击力。

## 核心设计原则
1. **严格基于真实数据** - 不使用虚构内容
2. **科技感优先** - 深色主题 + 霓虹光效
3. **Bento 模块化** - 非对称网格布局
4. **开发者友好** - 代码友好、技术深度展示

## 新增组件

### 1. Hero Section
- 大标题：「发现 · 比较 · 选择」AI工具
- 副标题：基于真实测试的权威评测
- 搜索框：⌘K 快捷键，支持模糊搜索
- 动态背景：浮动粒子 + 渐变流光

### 2. Stats Panel
- 3列网格展示真实数据：
  - 493+ 评测文章
  - 5 大分类
  - 100+ 标签
  - 每日更新

### 3. Featured Tools Grid
- 从 stats.json 读取真实数据
- 显示 GitHub Stars
- 卡片含：图标、名称、stars、简介、链接

### 4. Categories Bento
- 响应式网格：桌面4列 → 平板2列 → 手机1列
- 每卡片含：图标、名称、文章数
- 悬停渐变边框效果

### 5. Trending Section
- 最新3篇文章卡片
- 阅读时间 + 发布日期
- 分类标签

### 6. Community CTA
- 三栏布局：Telegram | GitHub | RSS
- 统一按钮样式
- 社交证明（用户数展示）

## 技术实现
- 纯 Tailwind CSS（CDN）
- 无外部框架依赖
- Hugo Template 语法集成
- 响应式断点：sm/md/lg/xl

## 文件变更
1. `layouts/index.html` - 全新首页模板
2. `layouts/partials/bento-hero.html` - Hero组件
3. `layouts/partials/bento-stats.html` - Stats组件
4. `layouts/partials/bento-featured.html` - Featured工具
5. `layouts/partials/bento-categories.html` - 分类网格
6. `layouts/partials/bento-trending.html` - 最新文章

## 验证标准
- [ ] Hugo build 成功（0 errors）
- [ ] 所有真实数据正确显示
- [ ] 移动端响应式正常
- [ ] 暗色主题默认启用
- [ ] 搜索功能可用
