# dibi8 文章标题质量检查脚本

此脚本用于检查 dibi8.com 所有文章的标题质量，防止占位符标题上线。

## 用法

```bash
cd ~/dibi8_com
bash scripts/validate-titles.sh
```

## 检查项目

1. 统计总文章数
2. 检查是否有标题为 "AI Tool Guide" 的占位符文章
3. 检查是否有文章缺少 title 字段
4. 显示最新5篇文章的标题预览

## 常见问题

- **占位符标题**：从模板批量创建的文章可能保留 "AI Tool Guide" 等占位符标题
- **解决方式**：手动修复或重新生成文章，确保 title 字段是真实有意义的标题