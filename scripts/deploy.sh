#!/bin/bash
# Dibi8 Quick Deploy Script
# Usage: bash deploy.sh

set -e

echo "=== Dibi8 Quick Deploy ==="
echo ""

# 1. Build
echo "1. Building site..."
cd ~/dibi8_com
hugo --gc --minify 2>&1 | tail -5
echo "   ✓ Build complete"
echo ""

# 2. Verify
echo "2. Verifying build..."
if [ -f "public/index.html" ]; then
    echo "   ✓ public/index.html exists"
    SIZE=$(wc -c < public/index.html)
    echo "   ✓ File size: $SIZE bytes"
else
    echo "   ✗ Build failed"
    exit 1
fi
echo ""

# 3. Git status
echo "3. Git status..."
git status --short
echo ""

# 4. Commit
echo "4. Creating commit..."
git add .
git commit -m "build: $(date '+%Y-%m-%d %H:%M') - $(hugo version 2>/dev/null | grep -o 'v[0-9.]*' || echo 'Hugo')"
echo "   ✓ Committed"
echo ""

# 5. Push
echo "5. Pushing to GitHub..."
git push origin main
echo "   ✓ Pushed"
echo ""

echo "=== Deployment Complete ==="
echo ""
echo "Check GitHub Actions for deployment status:"
echo "https://github.com/luckybbjason1/dibi8_com/actions"
echo ""
echo "Site will be available at:"
echo "- https://dibi8.com (Cloudflare)"
echo "- https://luckybbjason1.github.io/dibi8_com (GitHub Pages)"
