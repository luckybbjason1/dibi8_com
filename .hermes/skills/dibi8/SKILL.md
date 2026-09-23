---
name: dibi8
description: dibi8.com 多语言技术文章项目 — 中文源内容 + 翻译工具实现多语言支持
tags: [dibi8, content, seo, hugo, translation, deployment]
---

# dibi8 内容项目工作流

dibi8.com 是一个 AI 工具目录网站，采用 Hugo 静态站点生成。
**当前语言策略：单语言（中文 CN）+ 翻译工具**

## 项目结构

```
~/dibi8_com/                  # Hugo 站点根目录
├── CN/                       # 中文内容（唯一源语言）
│   ├── ai-coding-agents/
│   ├── llm-frameworks/
│   ├── mcp-tools/
│   └── tools/
├── layouts/
│   └── partials/
│       └── translation-widget.html  # 翻译工具组件
├── public/                   # 构建输出
└── config.toml              # 站点配置（仅 zh 语言）
```

## 多语言支持

**策略变更（2026-09-23）**:
- ❌ 删除了 ZH/KR/VI/KO 四个语言目录
- ✅ 只保留 CN（中文）作为源内容
- ✅ 使用翻译工具实现访客多语言浏览

**翻译工具**:
- 右下角固定位置显示翻译按钮
- 支持14种语言：中/英/韩/越/日/法/德/西/阿/葡/俄/印/泰/印尼
- 点击下拉菜单 → 新标签页打开 Google 翻译版本
- 无需 API 密钥，免费使用

## 核心工作流

### 1. 关键词预研（写文章前必须）

使用 `dibi8-keyword-research` 技能：
- 确定主题的核心搜索词
- 找 3-5 个长尾词机会
- 验证已有内容不重复
- 规划文章结构（H2 标题、FAQ）

**原则**: 关键词匹配 > 写得漂亮。被搜到 > 写得长。

### 2. 文章生产

遵循 `dibi8-article-writing` 技能：
- 用中文写作，保持高质量
- 拉近放远叙事节奏：具体感受 → 方法论 → 个人故事 → 数据 → 坦白
- 代码块必须是真实观察，不是泛教程
- 结尾要有意外洞察，不是总结

### 3. 部署到 Hugo

```bash
cd ~/dibi8_com
hugo --quiet && echo "✅ 构建成功"
git add -A
git commit -m "feat: add new article"
git push origin main
```

## 关键规则

### 语言配置（必须遵守）
```toml
[languages]
  [languages.zh]
    weight = 1
    title = "Dibi8"
    languageName = "中文"
    contentDir = "CN"
```
**不要**添加其他语言到 config.toml，翻译通过工具实现。

### 文件操作规范
- **不要直接编辑线上文件**：先在本地或 Termux 编辑，测试后再推送
- **关键词研究是第一步**：跳过这步会写出不被搜索到的文章
- **保持中文内容质量**：所有内容用中文写作，确保准确性和可读性

## Pitfalls

- 不要创建 ZH/KR/VI 等语言目录 — 翻译工具已提供多语言支持
- 不要在 config.toml 中添加多个语言配置 — 只会增加复杂度
- 翻译工具打开新标签页，不是站内跳转 — 这是预期行为
- Google Translate Widget 已于 2026年10月1日废弃 — 使用自定义按钮 + URL 参数方案
- **GitHub Actions 部署失败通常是因为 Secrets 未设置** — 必须手动在仓库 Settings → Secrets → Actions 中添加
- **cfut_ 格式的 Cloudflare 令牌使用 Bearer 认证** — `Authorization: Bearer <token>` 而非旧格式
- **本地构建验证后再推送** — 运行 `hugo --quiet` 确认通过，否则 GitHub Actions 也会失败
- **GitHub PAT 需要 workflow scope** — 普通 repo scope 无法推送 .github/workflows/ 文件

## 参考文件

- `references/project-access.md` — 项目访问方法、内容统计、常见错误解决方案
- `references/translation-widget-integration.md` — 翻译工具集成指南
- `references/deployment-setup.md` — Cloudflare Pages 自动部署配置
