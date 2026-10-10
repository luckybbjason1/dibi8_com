---
name: dibi8-workflow
description: Dibi8.com项目开发工作流 - Hugo构建、Git版本控制、GitHub Actions/Cloudflare部署、Bento Grid设计系统、WCAG 2.1 AA无障碍标准
tags: [hugo, workflow, deployment, a11y, bento-grid]
category: devops
---

# Dibi8.com 项目开发工作流

## 项目概览
- **位置**: ~/dibi8_com/
- **类型**: Hugo静态网站 (AI工具目录)
- **内容**: 493+篇文章，755页面
- **设计**: Bento Grid + 深空黑主题 + WCAG 2.1 AA无障碍

## 本地开发

### 构建与预览
```bash
cd ~/dibi8_com

# 开发模式（热重载）
hugo server -D

# 生产构建
hugo --gc --minify

# 验证脚本
bash scripts/verify-build.sh
bash scripts/verify-design-consistency.sh
bash scripts/verify-accessibility.sh
```

### Git工作流程
```bash
# 查看状态
git status --short

# 当前待提交文件
# M layouts/_default/baseof.html
# M layouts/_default/list.html
# M layouts/_default/single.html
# M layouts/index.html
# M layouts/partials/footer.html
# M layouts/partials/nav.html
# m themes/PaperMod (子模块)
# ?? docs/
# ?? static/css/bento-design-system.css

# 提交
git add .
git commit -m "feat: Bento Grid全站重构 + WCAG 2.1 AA无障碍优化"
git push origin main
```

## 部署方式

### GitHub Actions 自动部署（推荐）
- 触发：推送到 main 分支
- 配置：.github/workflows/pages.yml
- 输出：GitHub Pages

### Cloudflare Pages 部署
```bash
# 方式1: Python脚本
python3 deploy.py

# 方式2: Wrangler CLI
wrangler pages deploy public --project-name=dibi8-com
```

### 一键部署脚本
```bash
bash scripts/deploy.sh
```

## 设计系统

### 色彩规范
| 用途 | 颜色值 | 对比度 |
|------|--------|--------|
| 背景 | #0a0a0f | - |
| 主要文字 | #f1f5f9 | 16.5:1 ✓ |
| 次要文字 | #cbd5e1 | 11.2:1 ✓ |
| 霓虹紫 | #8b5cf6 | 5.8:1 ✓ |
| 霓虹青 | #22d3ee | 4.6:1 ✓ |

### 核心组件
- `.glass-card` - 玻璃态卡片
- `.gradient-text` - 渐变文字动画
- `.bento-grid` - 响应式网格布局
- `.prose-dibi` - 文章排版样式

## 无障碍访问 (WCAG 2.1 AA)

### 已实现功能
- ✓ ARIA 属性（71处）
- ✓ 焦点可见指示器
- ✓ 跳过链接 (Skip Link)
- ✓ 减少动画支持
- ✓ 键盘导航快捷键 (⌘K)
- ✓ 语义化HTML结构

### 验证命令
```bash
bash /data/data/com.termux/files/usr/tmp/hermes-verify-dibi8-bento.sh
```

## 关键文件

| 文件 | 说明 |
|------|------|
| layouts/index.html | 首页Bento Grid布局 |
| layouts/_default/baseof.html | 全站基础模板 |
| layouts/_default/single.html | 文章页模板 |
| layouts/_default/list.html | 列表页模板 |
| layouts/partials/nav.html | 导航组件 |
| layouts/partials/footer.html | 页脚组件 |
| static/css/bento-design-system.css | 设计系统CSS |
| data/stats.json | 站点统计数据 |

## 故障排查

### 构建失败
```bash
rm -rf resources/ public/ .hugo_build.lock
hugo --gc --minify
```

### 样式丢失
- 检查 Tailwind CDN 加载
- 确认CSS文件路径

### 部署失败
- 检查 GitHub Secrets 配置
- 确认 API Token 有效
- 查看 Actions 运行日志

## 相关文档
- WORKFLOWS.md - 完整工作流文档
- DESIGN-CONSISTENCY-REPORT.md - 设计一致性报告
- ACCESSIBILITY-OPTIMIZATION.md - 无障碍优化报告
- bento-redesign-spec.md - Bento Grid设计规范
