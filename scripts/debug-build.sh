#!/bin/bash
# Debug Hugo build for coin page
set -e

echo "=== Hugo Build Debug ==="
cd ~/dibi8_com

echo ""
echo "1. Content files check:"
find CN -name "coin*" -o -name "*coin*" 2>/dev/null | head -10

echo ""
echo "2. Layout files check:"
find layouts -name "*coin*" 2>/dev/null

echo ""
echo "3. Build with verbose output:"
hugo --gc --minify 2>&1 | grep -i "coin\|warn\|error" || echo "No warnings/errors found"

echo ""
echo "4. Output check:"
find public -name "*coin*" -type f 2>/dev/null
find public -path "*coin*" -type d 2>/dev/null

echo ""
echo "5. Check if section is recognized:"
hugo --gc --minify 2>&1 | tail -10
