# Dibi8.com 项目开发工作流

## 一、本地开发流程

### 1. 环境要求
- Hugo v0.163.3 (extended)
- Node.js (可选，用于 Tailwind CSS)
- Git

### 2. 本地构建与预览
```bash
cd ~/dibi8_com

# 基础构建
hugo --gc --minify

# 开发模式预览（热重载）
hugo server -D

# 指定端口
hugo server -D --bind 127.0.0.1 --baseURL http://127.0.0.1:1313
```

### 3. 验证脚本
```bash
# 快速验证构建
bash scripts/verify-build.sh

# 验证设计一致性
bash scripts/verify-design-consistency.sh

# 验证无障碍访问性
bash scripts/verify-accessibility.sh
```

---

## 二、Git 版本控制工作流

### 1. 分支策略
- `main` - 生产环境分支
- `feature/*` - 功能开发分支
- `bugfix/*` - 修复分支

### 2. 提交规范
```
feat: 新增功能
fix: 修复问题
docs: 文档更新
style: 代码格式调整
refactor: 重构
test: 测试相关
chore: 构建/工具相关
```

### 3. 日常开发流程
```bash
# 1. 创建特性分支
git checkout -b feature/bento-grid-redesign

# 2. 开发过程中阶段性提交
git add .
git commit -m "feat: 实现Bento Grid布局基础结构"

# 3. 合并到主分支
git checkout main
git merge feature/bento-grid-redesign

# 4. 推送到远程
git push origin main
```

### 4. 当前变更状态
```bash
# 查看待提交文件
git status --short

# 输出示例：
# M layouts/_default/baseof.html     # 已修改
# M layouts/_default/list.html       # 已修改
# M layouts/_default/single.html     # 已修改
# M layouts/index.html               # 已修改
# M layouts/partials/footer.html     # 已修改
# M layouts/partials/nav.html        # 已修改
# m themes/PaperMod                  # 子模块更新
# ?? docs/                           # 新增目录
# ?? static/css/bento-design-system.css  # 新增CSS文件
```

---

## 三、部署流程

### 方案A：GitHub Actions 自动部署（推荐）

#### 触发条件
- 推送到 `main` 分支时自动触发
- 手动触发（workflow_dispatch）

#### 工作流配置
```yaml
# .github/workflows/pages.yml
name: Deploy to GitHub Pages

on:
  push:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0
      - uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.163.3'
          extended: true
      - run: hugo --minify
      - uses: actions/upload-pages-artifact@v3
        with:
          path: ./public

  deploy:
    needs: build
    runs-on: ubuntu-latest
    steps:
      - uses: actions/deploy-pages@v4
```

#### 配置 GitHub Pages
1. 进入 GitHub 仓库设置
2. Pages → Source: GitHub Actions
3. 自定义域名（可选）：dibi8.com

---

### 方案B：Cloudflare Pages 部署

#### 方式1：自动部署
```bash
# 在 Cloudflare Dashboard 连接 GitHub 仓库
# 设置构建命令：hugo --minify
# 设置输出目录：public
```

#### 方式2：手动部署脚本
```bash
# 使用 deploy.py 脚本
cd ~/dibi8_com
python3 deploy.py

# 参数说明：
# ACCOUNT_ID: Cloudflare 账户 ID
# TOKEN: API Token
# PROJECT_NAME: 项目名称
```

#### 方式3：Wrangler CLI
```bash
# 安装 Wrangler
npm install -g wrangler

# 登录
wrangler login

# 部署
wrangler pages deploy public --project-name=dibi8-com --branch=main
```

---

### 方案C：直接上传部署

```bash
# 构建项目
hugo --gc --minify

# 打包
zip -r deploy.zip public/

# 通过 Cloudflare Dashboard 上传
# 或调用 API
curl -X POST "https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects/{PROJECT_NAME}/deployments" \
  -H "Authorization: Bearer {TOKEN}" \
  -F "file=@deploy.zip"
```

---

## 四、自动化工作流

### 1. 本地构建后自动提交
```bash
# 一键部署脚本
#!/bin/bash
set -e

echo "Building site..."
hugo --gc --minify

echo "Testing..."
hugo server --test

echo "Committing changes..."
git add .
git commit -m "build: $(date '+%Y-%m-%d %H:%M')"

echo "Pushing to GitHub..."
git push origin main

echo "Deployment complete!"
```

### 2. CI/CD 流程
```
本地开发 → 测试验证 → Git Push → GitHub Actions → 自动部署
                              ↓
                         Cloudflare CDN
                              ↓
                         dibi8.com
```

---

## 五、快速参考命令

### 日常开发
```bash
# 启动本地服务器
hugo server -D

# 构建生产版本
hugo --gc --minify

# 查看站点统计
hugo stats
```

### Git 操作
```bash
# 查看状态
git status

# 暂存修改
git add .

# 提交
git commit -m "feat: 描述"

# 推送
git push origin main
```

### 部署操作
```bash
# GitHub Pages 部署
# 推送到 main 分支即可自动部署

# Cloudflare Pages 部署
python3 deploy.py

# 或手动上传
wrangler pages deploy public
```

---

## 六、故障排查

### 构建失败
```bash
# 清理缓存
rm -rf resources/ public/ .hugo_build.lock

# 重新构建
hugo --gc --minify
```

### 样式丢失
- 检查 Tailwind CDN 是否加载
- 确认 CSS 文件路径正确

### 部署失败
- 检查 GitHub Secrets 配置
- 确认 API Token 有效
- 查看 Actions 运行日志

---

## 七、相关文档

- [DEPLOY.md](./DEPLOY.md) - 部署详细说明
- [OPTIMIZATION_REPORT.md](./OPTIMIZATION_REPORT.md) - 优化报告
- [bento-redesign-spec.md](./docs/bento-redesign-spec.md) - Bento Grid 设计规范
- [DESIGN-CONSISTENCY-REPORT.md](./docs/DESIGN-CONSISTENCY-REPORT.md) - 设计一致性报告
- [ACCESSIBILITY-OPTIMIZATION.md](./docs/ACCESSIBILITY-OPTIMIZATION.md) - 无障碍优化报告
