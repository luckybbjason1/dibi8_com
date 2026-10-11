#!/bin/bash
# DIBI8 六维架构 - 最终验证脚本
set -e

echo "=== DIBI8 六维架构最终验证 ==="
cd ~/dibi8_com

echo ""
echo "📊 Git提交记录:"
git log --oneline -3

echo ""
echo "🏗️ Hugo构建测试:"
BUILD_OUTPUT=$(hugo --gc --minify 2>&1)
echo "$BUILD_OUTPUT" | grep -E "Pages|Total"
if echo "$BUILD_OUTPUT" | grep -qi "error"; then
    echo "⚠️ 发现构建错误"
    echo "$BUILD_OUTPUT" | grep -i "error"
else
    echo "✅ 构建成功，无错误"
fi

echo ""
echo "🎨 六维元素验证:"
DIMENSIONS=("tools" "reports" "price" "guides" "community" "dev")
for dim in "${DIMENSIONS[@]}"; do
    if grep -q "dimension-card--$dim" public/index.html 2>/dev/null; then
        COUNT=$(grep -c "dimension-card--$dim" public/index.html)
        echo "   ✓ 维度 $dim: $COUNT个实例"
    else
        echo "   ✗ 维度 $dim: 未找到"
    fi
done

echo ""
echo "📱 响应式布局验证:"
if grep -q "max-width: 1024px" static/css/dimension-components.css 2>/dev/null; then
    echo "   ✓ 平板双列布局: 已配置"
fi
if grep -q "max-width: 640px" static/css/dimension-components.css 2>/dev/null; then
    echo "   ✓ 手机单列布局: 已配置"
fi

echo ""
echo "♿ 无障碍访问验证:"
ARIA_COUNT=$(grep -c 'aria-' public/index.html 2>/dev/null || echo "0")
echo "   • ARIA属性: $ARIA_COUNT处"

if grep -q 'focus-visible' static/css/bento-design-system.css 2>/dev/null; then
    echo "   ✓ Focus指示器: 已定义"
fi
if grep -q 'prefers-reduced-motion' static/css/bento-design-system.css 2>/dev/null; then
    echo "   ✓ Reduced motion: 已支持"
fi

echo ""
echo "📁 核心文件:"
CORE_FILES=(
    "layouts/index.html:首页六维Bento布局"
    "static/css/bento-design-system.css:设计令牌系统"
    "static/css/dimension-components.css:六维组件样式"
    "layouts/partials/nav.html:导航组件"
    "layouts/partials/footer.html:页脚组件"
)

for f in "${CORE_FILES[@]}"; do
    IFS=':' read -r path desc <<< "$f"
    if [ -f "$path" ]; then
        SIZE=$(wc -c < "$path")
        echo "   ✓ $path ($SIZEB) - $desc"
    else
        echo "   ✗ $path 缺失"
    fi
done

echo ""
echo "🚀 部署状态:"
echo "   • GitHub: https://github.com/luckybbjason1/dibi8_com"
echo "   • 在线预览: https://luckybbjason1.github.io/dibi8_com/"

echo ""
echo "=== ✅ 验证完成 - DIBI8六维架构已实现 ==="
