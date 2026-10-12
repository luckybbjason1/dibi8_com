#!/bin/bash
# DIBI8 自动检查与修复脚本
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

log "========== DIBI8 自动检查开始 =========="

cd "$PROJECT_DIR"

# 1. 检查 Hugo 构建
log "检查 Hugo 构建..."
if hugo --gc --minify > /dev/null 2>&1; then
    log "✓ Hugo 构建成功"
else
    log "${RED}✗ Hugo 构建失败${NC}"
    exit 1
fi

# 2. 检查分类标记
log "检查分类标记..."
TOTAL_ARTICLES=$(find CN -name "*.md" ! -name "_*" | wc -l)
CAT_MARKED=$(grep -r "^categories:" CN --include="*.md" | wc -l)
log "文章总数: $TOTAL_ARTICLES, 有分类标记: $CAT_MARKED"

if [ "$CAT_MARKED" -lt "$((TOTAL_ARTICLES * 90 / 100))" ]; then
    log "${YELLOW}⚠ 分类标记覆盖率低于90%，尝试修复...${NC}"
    
    # 为 ai-coding-agents 目录的文章添加分类
    if [ -d "CN/ai-coding-agents" ]; then
        AI_Coding_COUNT=$(find CN/ai-coding-agents -name "*.md" ! -name "_*" | wc -l)
        log "处理 ai-coding-agents 目录: $AI_Coding_COUNT 篇文章"
        
        for file in CN/ai-coding-agents/*.md; do
            if ! grep -q "^categories:" "$file"; then
                # 在 frontmatter 中添加 categories
                sed -i '/^tags:/a categories: ["ai-coding-agents"]' "$file" 2>/dev/null || \
                sed -i 's/^---$/---\ncategories: ["ai-coding-agents"]/' "$file" 2>/dev/null || \
                log "跳过 $file (格式问题)"
            fi
        done
        log "✓ 已为 ai-coding-agents 添加分类标记"
    fi
    
    # 为 llm-frameworks 目录的文章添加分类
    if [ -d "CN/llm-frameworks" ]; then
        LLM_COUNT=$(find CN/llm-frameworks -name "*.md" ! -name "_*" | wc -l)
        log "处理 llm-frameworks 目录: $LLM_COUNT 篇文章"
        
        for file in CN/llm-frameworks/*.md; do
            if ! grep -q "^categories:" "$file"; then
                sed -i '/^tags:/a categories: ["llm-frameworks"]' "$file" 2>/dev/null || \
                sed -i 's/^---$/---\ncategories: ["llm-frameworks"]/' "$file" 2>/dev/null || \
                log "跳过 $file (格式问题)"
            fi
        done
        log "✓ 已为 llm-frameworks 添加分类标记"
    fi
    
    # 重新构建
    log "重新构建站点..."
    hugo --gc --minify > /dev/null 2>&1
fi

# 3. 检查分类页面是否存在
log "检查分类页面..."
if [ -f "public/categories/ai-coding-agents/index.html" ]; then
    log "✓ /categories/ai-coding-agents/ 存在"
else
    log "${YELLOW}⚠ /categories/ai-coding-agents/ 缺失${NC}"
fi

# 4. 检查首页重复标题
log "检查首页重复标题..."
DUPLICATE_COUNT=$(grep -o '<h3[^>]*>[^<]*</h3>' public/index.html | sort | uniq -d | wc -l)
if [ "$DUPLICATE_COUNT" -gt 0 ]; then
    log "${YELLOW}⚠ 发现 $DUPLICATE_COUNT 个重复标题${NC}"
else
    log "✓ 无重复标题"
fi

# 5. 检查链接格式
log "检查链接格式..."
NOQUOTE_LINKS=$(grep -o 'href=[^"^\s>]*' public/index.html | wc -l)
if [ "$NOQUOTE_LINKS" -gt 0 ]; then
    log "${YELLOW}⚠ 发现 $NOQUOTE_LINKS 个无引号链接${NC}"
else
    log "✓ 链接格式正确"
fi

# 6. 检查 sitemap 和 RSS
log "检查 Sitemap 和 RSS..."
SITEMAP_URLS=$(grep -c '<loc>' public/sitemap.xml 2>/dev/null || echo "0")
RSS_ITEMS=$(grep -c '<item>' public/index.xml 2>/dev/null || echo "0")
log "Sitemap URLs: $SITEMAP_URLS, RSS Items: $RSS_ITEMS"

# 7. 提交修复
log "检查 Git 状态..."
CHANGES=$(git status --porcelain)
if [ -n "$CHANGES" ]; then
    log "发现变更，准备提交..."
    git add -A
    git commit -m "fix: 自动修复 dibi8 分类标记问题 [$TIMESTAMP]" && \
    git push origin main 2>/dev/null && \
    log "✓ 已提交并推送修复" || \
    log "⚠ 提交成功但推送失败"
else
    log "✓ 无需提交"
fi

log "========== DIBI8 自动检查完成 =========="
log ""
