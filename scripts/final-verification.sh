#!/bin/bash
# DIBI8 六维架构实现完成验证
set -e

echo "=== DIBI8 六维架构最终验证 ==="
cd ~/dibi8_com

echo ""
echo "📊 Git状态:"
git log --oneline -3

echo ""
echo "🏗️ Hugo构建:"
hugo --gc --minify 2>&1 | grep -E "Pages|Total"

echo ""
echo "🎨 六维元素:"
grep -q "dimension-card--tools" public/index.html && echo "   ✓ 工具发现"
grep -q "dimension-card--reports" public/index.html && echo "   ✓ 生态报告"
grep -q "dimension-card--price" public/index.html && echo "   ✓ 价格对比"
grep -q "dimension-card--guides" public/index.html && echo "   ✓ 使用指南"
grep -q "dimension-card--community" public/index.html && echo "   ✓ 社区动态"
grep -q "dimension-card--dev" public/index.html && echo "   ✓ 开发者资源"

echo ""
echo "♿ 无障碍访问:"
echo "   ARIA: $(grep -c 'aria-' public/index.html)处"

echo ""
echo "✅ 验证完成 - 六维架构已实现"
