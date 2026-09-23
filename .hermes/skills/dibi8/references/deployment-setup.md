# Cloudflare Pages 自动部署配置

本文档说明 dibi8.com 的 GitHub Actions + Cloudflare Pages 自动部署配置。

## 架构

```
git push → GitHub Actions → Hugo Build → Cloudflare Pages Deploy
```

## 配置文件

### .github/workflows/deploy.yml

```yaml
name: Deploy to Cloudflare Pages

on:
  push:
    branches: [main]
  workflow_dispatch:  # 允许手动触发

permissions:
  contents: read
  deployments: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4
        with:
          submodules: recursive
          fetch-depth: 0

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.163.3'
          extended: true

      - name: Build
        run: hugo --minify --quiet

      - name: Deploy to Cloudflare Pages
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy public --project-name=dibi8-com --branch=main
```

### wrangler.toml

```toml
name = "dibi8-com"
pages_build_output_dir = "public"

[build]
  command = "hugo --minify"
  publish = "public"

[build.environment]
  HUGO_VERSION = "0.163.3"
```

## 必需凭据

### GitHub PAT（Personal Access Token）
需要 scopes：
- `repo` — 读写仓库
- `workflow` — 管理 GitHub Actions

配置方式：
```bash
git remote set-url origin https://<USERNAME>:<TOKEN>@github.com/<USER>/<REPO>.git
```

### Cloudflare API Token
新格式令牌以 `cfut_` 开头，使用 Bearer 认证：
```bash
curl -H "Authorization: Bearer cfut_xxx" https://api.cloudflare.com/client/v4/user/tokens/verify
```

需要权限：
- Account → Cloudflare Pages → Edit

获取方式：
1. Cloudflare Dashboard → 右上角头像 → "我的账户" → "API 令牌"
2. 点击"创建令牌"
3. 选择"创建自定义令牌"
4. 添加权限：Account → Cloudflare Pages → Edit
5. 账户资源选择具体账户（不是"所有账户"）
6. 复制生成的令牌（只显示一次！）

### Cloudflare Account ID
获取方式：
1. Cloudflare Dashboard → 点击右上角头像 → "我的账户"
2. 右侧边栏显示"账户编号"（32位字母数字）
3. 或查看 URL：dash.cloudflare.com/<ACCOUNT_ID>/...

## 配置 GitHub Secrets

在仓库 Settings → Secrets and variables → Actions 添加：

| Secret | 值 |
|--------|-----|
| CLOUDFLARE_API_TOKEN | `cfut_...` 格式令牌 |
| CLOUDFLARE_ACCOUNT_ID | 32位账户编号 |

**注意**: 也可以通过 API 设置 secrets（需要 RSA 加密），但手动在网页上设置更简单。

## 验证步骤

### 1. 验证本地构建
```bash
cd ~/dibi8_com
hugo --quiet && echo "✅ 构建成功"
grep -c "translation-widget" public/index.html  # 应 >= 1
```

### 2. 验证 Cloudflare API
```bash
curl -s -H "Authorization: Bearer <TOKEN>" \
  "https://api.cloudflare.com/client/v4/accounts/<ACCOUNT_ID>/pages/projects/dibi8-com"
```

### 3. 触发部署
```bash
git commit --allow-empty -m "chore: trigger deploy"
git push origin main
```

### 4. 检查状态
- GitHub Actions: https://github.com/luckybbjason1/dibi8_com/actions
- Cloudflare Pages: https://dash.cloudflare.com/pages/view/dibi8-com

## 常见问题

### 构建成功但部署失败
- 检查 CLOUDFLARE_API_TOKEN 是否包含 Pages Edit 权限
- 检查 CLOUDFLARE_ACCOUNT_ID 是否正确
- 确认 Cloudflare Pages 项目已存在（项目名: dibi8-com）

### GitHub Actions 工作流未触发
- 检查 branch 名称是否为 main
- 检查 secrets 名称是否正确（区分大小写）
- 查看 workflow run 日志定位错误

### Hugo 构建失败
- 检查是否使用了 extended 版本
- 检查 shortcode 是否在主题中存在
- 运行 `hugo` 查看详细错误信息

## Pitfalls

- **不要修改主题子模块**：修改应放在 `layouts/_partials/` 覆盖，避免主题更新时丢失
- **移除废弃字段**：Hugo v0.144+ 废弃 frontmatter 中的 `lang` 字段，需清理
- **检查孤立 markdown 文件**：确保所有 .md 文件都在内容目录中（如 CN/）
- **cfut_ 令牌需要正确认证**：使用 `Authorization: Bearer <token>` 而非 API Key 格式
- **GitHub PAT 需要 workflow scope**：普通 repo scope 无法推送 .github/workflows/ 文件
- **本地构建验证后再推送**：运行 `hugo --quiet` 确认通过，否则 GitHub Actions 也会失败
