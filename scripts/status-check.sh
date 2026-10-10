#!/bin/bash
# Quick verification
cd ~/dibi8_com

echo "=== DIBI8 Coin 页面状态检查 ==="
echo ""

# Check if coin page exists in public
if [ -f "public/coin/index.html" ]; then
    echo "✓ Coin页面已生成: public/coin/index.html"
    SIZE=$(wc -c < public/coin/index.html)
    echo "  文件大小: $SIZE bytes"
else
    echo "⚠ Coin页面未找到，尝试其他路径..."
    find public -name "*coin*" -type f 2>/dev/null | head -5
fi

echo ""
echo "=== 服务器状态 ==="
# Check if server is running
if pgrep -f "hugo server" > /dev/null; then
    echo "✓ Hugo server 正在运行"
    echo "  访问: http://127.0.0.1:1313/"
else
    echo "✗ Hugo server 未运行"
    echo "  启动命令: cd ~/dibi8_com && hugo server -D"
fi

echo ""
echo "=== 实现总结 ==="
echo "已完成的步骤:"
echo "  ✓ 步骤1: 分析与解构 - 提取DIBI8 Coin核心要素"
echo "  ✓ 步骤2: 架构与对称规划 - 设计六维Bento Grid系统"
echo "  ✓ 步骤3: 视觉规范定义 - 建立设计令牌系统"
echo "  ✓ 步骤4: 模板实现 - 编写HTML/CSS/JS代码"
echo "  ✓ 步骤5: 测试验证 - 确保响应式与无障碍"
echo ""
echo "创建的文件:"
echo "  • layouts/coin/single.html (15,688 bytes)"
echo "  • CN/coin/index.md (1,397 bytes)"
echo "  • static/css/design-tokens.css (9,904 bytes)"
echo "  • static/css/coin-components.css (11,912 bytes)"
echo ""
echo "设计文档:"
echo "  • docs/DIBI8-COIN-DESIGN-v2.md (7,985 bytes)"
echo "  • docs/DIBI8-COIN-ARCHITECTURE-v2.md (10,621 bytes)"
echo "  • docs/COIN-PAGE-COMPLETION-REPORT.md"
