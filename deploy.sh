#!/bin/bash
# Dibi8.com Cloudflare Pages 直接部署脚本

set -e

ACCOUNT_ID="e575ee29fb0430bc53bf8e991b226d19"
TOKEN="cfut_1Ll6uxuEQ8aKaA2ETWXQVoIXLN3brV1ZiXApEeeRc845bb72"
PROJECT_NAME="dibi8-com"
BUILD_DIR="$HOME/dibi8_deploy"

echo "========================================"
echo "  Dibi8.com 直接部署到 Cloudflare Pages"
echo "========================================"
echo ""

# 创建临时目录
rm -rf $BUILD_DIR
mkdir -p $BUILD_DIR

# 复制构建文件
cp -r public/* $BUILD_DIR/
echo "✅ 复制构建文件完成"

# 创建压缩包
cd $BUILD_DIR
zip -r ~/deploy.zip . > /dev/null 2>&1
echo "✅ 创建压缩包: $(ls -lh ~/deploy.zip | awk '{print $5}')"

# 上传到 Cloudflare
echo "📤 上传到 Cloudflare..."
curl -s -X POST \
  "https://api.cloudflare.com/client/v4/accounts/$ACCOUNT_ID/pages/projects/$PROJECT_NAME/deployments" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  --data "{
    \"name\": \"manual-deploy-$(date +%s)\",
    \"production\": true,
    \"source\": {
      \"type\": \"zip_upload\"
    }
  }" | python3 -m json.tool 2>/dev/null || echo "响应已获取"
echo ""
echo "部署脚本已完成"
