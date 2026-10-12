#!/bin/bash
# DIBI8 自动检查与修复脚本 v2
# 每小时运行一次，检查并修复常见问题

set -e

PROJECT_DIR="$HOME/dibi8_com"
LOG_FILE="$PROJECT_DIR/dibi8-check.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo "[$TIMESTAMP] $1" | tee -a "$LOG_FILE"
}

cd "$PROJECT_DIR"

log "========== DIBI8 自动检查开始 =========="

# 1. 检查 Hugo 构建
log "检查 Hugo 构建..."
if hugo --gc --minify > /dev/null 2>&1; then
    log "✓ Hugo 构建成功"
else
    log "${RED}✗ Hugo 构建失败${NC}"
    exit 1
fi

# 2. 检查分类标记覆盖率
log "检查分类标记..."
TOTAL_ARTICLES=$(find CN -name "*.md" ! -name "_*" | wc -l)
CAT_MARKED=$(grep -r "^categories:" CN --include="*.md" | wc -l)
COVERAGE=$((CAT_MARKED * 100 / TOTAL_ARTICLES))
log "文章总数: $TOTAL_ARTICLES, 有分类标记: $CAT_MARKED (覆盖率: ${COVERAGE}%)"

if [ "$COVERAGE" -lt 90 ]; then
    log "${YELLOW}⚠ 分类标记覆盖率低于90%，尝试修复...${NC}"
    
    # 为各目录的文章添加对应分类
    for dir in ai-coding-agents llm-frameworks mcp-tools ai-tools dev-utils; do
        if [ -d "CN/$dir" ]; then
            count=0
            for file in CN/$dir/*.md; do
                if [ -f "$file" ] && ! grep -q "^categories:" "$file"; then
                    # 在 frontmatter 的 tags 行后添加 categories
                    sed -i "/^tags:/a categories: [\"$dir\"]" "$file" 2>/dev/null || \
                    sed -i '1s/^---$/---\ncategories: ["'"$dir"'"]/; t' "$file" 2>/dev/null || \
                    log "跳过 $file (格式问题)"
                    count=$((count + 1))
                fi
            done
            log "✓ $dir: 补充 $count 篇文章的分类标记"
        fi
    done
    
    # 重新构建
    log "重新构建站点..."
    hugo --gc --minify
    log "✓ 重新构建完成"
else
    log "✓ 分类标记覆盖率正常 (${COVERAGE}%)"
fi

# 3. 检查首页重复标题
log "检查首页重复标题..."
python3 << 'PYEOF'
import re
from collections import Counter

with open('public/index.html', 'r') as f:
    content = f.read()

titles = re.findall(r'<h3[^>]*>([^<]+)</h3>', content)
title_counts = Counter(titles)
duplicates = {k: v for k, v in title_counts.items() if v > 1}

if duplicates:
    print(f"WARNING: 发现 {len(duplicates)} 个重复标题")
    for title, count in list(duplicates.items())[:3]:
        print(f"  - '{title[:50]}...' 出现 {count} 次")
    exit(1)
else:
    print("OK: 无重复标题")
    exit(0)
PYEOF

if [ $? -eq 0 ]; then
    log "✓ 首页无重复标题"
else
    log "${YELLOW}⚠ 首页存在重复标题，需要手动检查 layouts/index.html${NC}"
fi

# 4. 检查关键页面是否存在
log "检查关键页面..."
KEY_PAGES=("public/index.html" "public/categories/index.html" "public/sitemap.xml" "public/index.xml")
for page in "${KEY_PAGES[@]}"; do
    if [ -f "$page" ]; then
        log "✓ $page 存在"
    else
        log "${RED}✗ $page 缺失${NC}"
    fi
done

# 5. 检查分类页面
log "检查分类页面..."
CATEGORIES=("ai-coding-agents" "llm-frameworks" "mcp-tools" "ai-tools" "dev-utils")
for cat in "${CATEGORIES[@]}"; do
    if [ -f "public/categories/$cat/index.html" ]; then
        log "✓ /categories/$cat/ 存在"
    else
        log "${YELLOW}⚠ /categories/$cat/ 缺失${NC}"
    fi
done

# 6. 检查 Git 状态
log "检查 Git 状态..."
CHANGES=$(git status --porcelain)
if [ -n "$CHANGES" ]; then
    log "发现变更，准备提交..."
    git add -A
    git commit -m "auto-fix: DIBI8 自动检查修复 [$TIMESTAMP]" && \
    git push origin main 2>/dev/null && \
    log "✓ 已提交并推送修复" || \
    log "${YELLOW}⚠ 提交成功但推送失败${NC}"
else
    log "✓ 无需提交"
fi

log "========== DIBI8 自动检查完成 =========="
log ""
