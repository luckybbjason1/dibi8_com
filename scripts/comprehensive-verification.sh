#!/bin/bash
# DIBI8 六维架构 - 综合验证脚本
set -e

echo "=== DIBI8 六维架构实现验证 ==="
cd ~/dibi8_com

# Hugo构建
echo ""
echo "🏗️ Hugo构建测试:"
BUILD=$(hugo --gc --minify 2>&1)
echo "$BUILD" | grep -E "Pages|Total|Error" || echo "$BUILD" | tail -5

# 六维元素统计
echo ""
echo "🎨 六维元素验证:"
for dim in tools reports price guides community dev; do
    COUNT=$(grep -c "dimension-card--$dim" public/index.html 2>/dev/null || echo "0")
    if [ "$COUNT" -gt "0" ]; then
        echo "   ✓ 维度 $dim: $COUNT个实例"
    fi
done

# 检查关键类
echo ""
echo "📊 关键CSS类统计:"
echo "   • glass-card: $(grep -c 'glass-card' public/index.html 2>/dev/null || echo '0')处"
echo "   • gradient-text: $(grep -c 'gradient-text' public/index.html 2>/dev/null || echo '0')处"
echo "   • bento-grid: $(grep -c 'bento-grid\|dimension-grid' public/index.html 2>/dev/null || echo '0')处"
echo "   • ARIA: $(grep -c 'aria-' public/index.html 2>/dev/null || echo '0')处"

# 检查CSS文件
echo ""
echo "📁 CSS文件:"
ls -la static/css/*.css 2>/dev/null | awk '{print "   ✓ " $9 " (" $5 " bytes)"}'

echo ""
echo "✅ 验证完成"
