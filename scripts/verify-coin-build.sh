#!/bin/bash
# DIBI8 Coin Page Build Verification
set -e

echo "=== DIBI8 Coin 页面验证 ==="
echo ""

cd ~/dibi8_com

# 1. 检查内容文件
echo "1. 内容文件检查..."
if [ -f "CN/coin/index.md" ]; then
    echo "   ✓ CN/coin/index.md 存在"
    echo "   内容预览:"
    head -10 CN/coin/index.md | sed 's/^/     /'
else
    echo "   ✗ CN/coin/index.md 不存在"
    exit 1
fi

# 2. 检查模板文件
echo ""
echo "2. 模板文件检查..."
for f in layouts/coin/single.html static/css/design-tokens.css static/css/coin-components.css; do
    if [ -f "$f" ]; then
        SIZE=$(wc -c < "$f")
        echo "   ✓ $f ($SIZE bytes)"
    else
        echo "   ✗ $f 不存在"
    fi
done

# 3. 构建验证
echo ""
echo "3. Hugo 构建验证..."
BUILD_OUTPUT=$(hugo --gc --minify 2>&1)
BUILD_EXIT=$?

if [ $BUILD_EXIT -eq 0 ]; then
    PAGES=$(echo "$BUILD_OUTPUT" | grep "Pages" | awk '{print $NF}')
    echo "   ✓ 构建成功 (exit code: 0)"
    echo "   ✓ 生成页面: $PAGES"
else
    echo "   ✗ 构建失败"
    echo "$BUILD_OUTPUT" | tail -20
    exit 1
fi

# 4. 检查输出文件
echo ""
echo "4. 输出文件检查..."
if ls public/**/coin* 2>/dev/null | grep -q "."; then
    echo "   ✓ Coin 相关页面已生成"
    find public -name "*coin*" -type f 2>/dev/null | head -5 | sed 's/^/     /'
else
    echo "   ⚠ 未找到 coin 相关输出文件"
    echo "   可能原因: 内容未被正确识别为页面"
fi

# 5. 检查首页
echo ""
echo "5. 首页检查..."
if [ -f "public/index.html" ]; then
    SIZE=$(wc -c < public/index.html)
    echo "   ✓ public/index.html ($SIZE bytes)"
else
    echo "   ✗ public/index.html 不存在"
fi

echo ""
echo "=== 验证完成 ==="
echo ""
echo "访问: http://127.0.0.1:1313/"
echo "Coin 页面: http://127.0.0.1:1313/dibi8-coin/"
echo ""
echo "下一步: 启动 Hugo server 预览"
