# Hugo Coin Section调试报告

## 问题诊断

### 当前状态
- CN/coin/index.md 已创建
- layouts/coin/single.html 已创建
- 但Hugo未将coin识别为section

### 可能原因

1. **Section未正确定义**
   - Hugo需要_content/section/_index.md来识别section
   - 或者使用list.html模板自动生成

2. **布局文件命名问题**
   - 可能需要_list.html而非single.html
   - 或者需要单独的_list和_single模板

3. **Content目录结构**
   - contentDir = "CN" 可能导致路径问题

## 解决方案

### 方案A: 使用_list模板
```bash
# 创建 layouts/coin/list.html (用于section列表页)
# 创建 layouts/coin/single.html (用于单个页面)
```

### 方案B: 使用pagebundles
```bash
# 在CN/coin/目录下只保留index.md
# Hugo会自动识别为pagebundle
```

### 方案C: 检查Hugo版本兼容性
```bash
hugo version
# 可能需要调整模板结构
```

## 下一步
1. 创建layouts/coin/list.html
2. 验证Hugo是否正确识别coin section
3. 检查输出目录结构
