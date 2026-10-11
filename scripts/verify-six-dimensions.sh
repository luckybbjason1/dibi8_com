#!/bin/bash
# DIBI8 六维对称Bento布局 - 验证脚本
set -e

echo "=== DIBI8 六维架构验证 ==="
cd ~/dibi8_com

echo "🏗️ Hugo构建:"
hugo --gc --minify 2>&1 | grep -E "Pages|Total"

echo ""
echo "🎨 六维元素:"
for dim in tools reports price guides community dev; do
    grep -q "dimension-card--$dim" public/index.html && echo "   ✓ 维度: $dim"
done

echo ""
echo "♿ 无障碍:"
echo "   ARIA属性: $(grep -c 'aria-' public/index.html)处"
grep -q "focus-visible" static/css/bento-design-system.css && echo "   ✓ Focus指示器"
grep -q "prefers-reduced-motion" static/css/bento-design-system.css && echo "   ✓ Reduced motion"

echo ""
echo "✅ 验证完成"
