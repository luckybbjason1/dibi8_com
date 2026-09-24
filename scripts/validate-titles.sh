#!/bin/bash
# 检查CN目录下所有文章的标题质量
# 用法: ./scripts/validate-titles.sh

cd "$(dirname "$0")/.."

echo "=== dibi8 文章标题质量检查 ==="
echo ""

# 统计总文章数
total=$(find CN -name '*.md' ! -name '_index.md' | wc -l)
echo "总文章数: $total"

# 检查占位符标题
bad_titles=$(grep -rl 'title: "AI Tool Guide"' CN/ 2>/dev/null | wc -l)
if [ "$bad_titles" -gt 0 ]; then
  echo ""
  echo "❌ 发现 $bad_titles 篇标题为占位符 'AI Tool Guide'"
  echo ""
  echo "这些文章列表页会显示无意义的标题，影响用户体验。"
  echo "请先修复标题后再部署。"
  echo ""
  echo "修复命令示例："
  echo "  # 查找所有有问题的文章"
  echo "  grep -rl 'title: \"AI Tool Guide\"' CN/ | head -20"
  echo ""
  echo "  # 手动修复或重新生成标题"
else
  echo "✅ 所有文章标题正常"
fi

# 检查空标题
empty_titles=$(grep -L '^title:' CN/*.md CN/*/*.md 2>/dev/null | wc -l)
if [ "$empty_titles" -gt 0 ]; then
  echo ""
  echo "⚠️ 发现 $empty_titles 篇缺少 title 字段"
fi

echo ""
echo "=== 最新文章预览 ==="
ls -t CN/*.md | head -5 | while read f; do
  title=$(grep '^title:' "$f" | head -1 | sed 's/title: *//;s/"//g')
  echo "  $(basename $f): $title"
done