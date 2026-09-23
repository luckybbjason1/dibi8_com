# dibi8_com 全自动部署指南

## 状态
- ✅ Hugo构建成功 (908个文件)
- ✅ GitHub Actions工作流已配置
- ⚠️ 需要设置Cloudflare Secrets

## 部署流程

当代码推送到main分支时，GitHub Actions会自动：
1. Checkout代码
2. 安装Hugo
3. 构建网站
4. 部署到Cloudflare Pages

## 需要设置的GitHub Secrets

在GitHub仓库设置中添加以下Secrets：

### 步骤1: 获取Cloudflare Account ID
1. 登录 https://dash.cloudflare.com
2. 点击右上角头像 → "我的账户"
3. 复制"账户编号"（32位字母数字）

### 步骤2: 创建Cloudflare API Token
1. 在Cloudflare仪表板 → "我的账户" → "API令牌"
2. 点击"创建令牌"
3. 使用模板 **"Edit Cloudflare Pages"**
4. 或者创建自定义令牌：
   - 权限: Account → Cloudflare Pages → Edit
   - 资源范围: 选择你的账户
5. 复制生成的令牌

### 步骤3: 在GitHub设置Secrets
1. 打开 https://github.com/luckybbjason1/dibi8_com/settings/secrets/actions
2. 点击"New repository secret"
3. 添加：
   - 名称: `CLOUDFLARE_API_TOKEN`，值: 你的Cloudflare API令牌
   - 名称: `CLOUDFLARE_ACCOUNT_ID`，值: 你的Cloudflare账户编号

## 验证部署

设置完secrets后，推送一个commit触发部署：
```bash
cd ~/dibi8_com
git commit --allow-empty -m "chore: trigger deploy"
git push origin main
```

查看部署状态：
- GitHub Actions: https://github.com/luckybbjason1/dibi8_com/actions
- Cloudflare Pages: https://dash.cloudflare.com/pages/view/dibi8-com

## 部署URL
- 生产: https://dibi8.com
- 预览: https://<commit-hash>.dibi8-com.pages.dev (PR部署)
