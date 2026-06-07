---
title: 'AI Token Monitor：在Linux桌面实时监控Claude、Gemini、Grok、Kimi配额'
description: '开源Linux桌面小工具，在Conky中以血条进度条实时显示AI Token使用量。支持Claude、Gemini、Grok、Kimi真实API轮询，显示剩余配额和重置倒计时。'
date: 2026-06-06 00:00:00+08:00
lastmod: 2026-06-06 00:00:00+08:00
tech_stack: ['Python', 'Conky', 'Linux']
application_domain: Dev Utils
source_version: '1.0.0'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'luckybbjason1/ai-token-monitor'
stars: 0
maintainer: 'luckybbjason1'
last_maintained: '2026-06-06'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['AI Token监控', 'Claude配额', 'Gemini配额追踪', 'Grok token', 'Kimi API', 'Conky小工具', 'Linux桌面', '开源', 'Python', '开发者工具']
aliases:
- /zh/posts/ai-token-monitor-conky-linux/
faqs:
  - q: 'AI Token Monitor 支持 macOS 或 Windows 吗？'
    a: '目前桌面显示层依赖 Conky，仅支持 Linux。核心 Python 脚本（api_fetcher.py）可在任意操作系统运行，但视觉渲染需要 Conky。仓库中有基于 tkinter 的跨平台版本（monitor.py），但在 GNOME 环境下无边框窗口可能不可见，属实验性功能。'
  - q: '工具如何读取 Claude API 的 Token 余额？'
    a: '通过向 /v1/messages 发送 max_tokens=1 的最小请求，读取响应头中的 anthropic-ratelimit-tokens-remaining 和 anthropic-ratelimit-tokens-limit 字段。每次检查消耗约 10 个输入 token，每 5 分钟一次 cron 全天约消耗 2880 token，对大多数套餐可忽略不计。'
  - q: '把 API key 存在 ~/.config/.ai_monitor_keys 安全吗？'
    a: '文件以 chmod 600 创建，只有当前用户可读。通过 .gitignore 排除在 git 之外。安全性与存放在 .env 文件相同，均依赖文件系统权限。共享机器建议使用 gpg-agent 或密钥管理器加密。'
  - q: '如何添加未列出的 AI 服务（如 Mistral、Together AI）？'
    a: '在 api_fetcher.py 中添加调用对应服务 API 的代码块，向缓存 dict 写入 ok（布尔值）、label（显示字符串）和可选的 pct（0-1 的浮点数）。然后在 conky_ai.py 的 SERVICES 列表中添加该服务名和 reset_h 值即可。'
  - q: '为什么 Grok 显示"耗尽"但我的账户有余额？'
    a: 'Grok 检测调用 GET /v1/models，认证有效且有余额时返回 200，余额耗尽时返回 403。xAI 的 403 特指账户余额为零。如果有余额却显示 403，请确认 ~/.config/.ai_monitor_keys 中的 API key 是否正确。'
---

{{< resource-info >}}

## 痛点：同时管理六个 AI 服务，永远不知道哪个已经耗尽

现代开发者同时使用四到八个 AI 服务——Claude 处理复杂推理，Gemini 做长上下文分析，Grok 获取实时网络数据，Kimi 处理大型文档。每个服务都有独立的配额控制台、重置时间和账单页面。

结果是：在任务中途撞上限流，花五分钟切换浏览器标签，发现 Gemini 的免费配额在 UTC 午夜重置（不是你本地时间的午夜），再浪费十分钟 debug Kimi 为什么返回 429。

**AI Token Monitor** 通过一个始终可见的桌面小工具解决这个问题——无需离开编辑器，一眼看清所有服务状态。

```
● Claude  ░░░░░░░░░  无余额
● Gemini  ░░░░░░░░░  配额用完
● Grok    ░░░░░░░░░  耗尽
● Kimi    █████████  22.4M剩
● Codex   ─────────  18:42:01
● Kilo    ─────────  18:42:01
```

## 工作原理

监控工具由两个组件构成：

**`api_fetcher.py`** — 后台脚本（每 5 分钟 cron 执行），轮询各服务 API 并将结果写入 `~/token-monitor/api_cache.json`。

**`conky_ai.py`** — 每 30 秒读取缓存，输出带内联 `${color}` 标签的 Conky 格式文本，Conky 将其渲染为桌面小工具。

```
api_fetcher.py  →  api_cache.json  →  conky_ai.py  →  Conky 显示
  （cron/5分钟）    （JSON 缓存）      （30秒轮询）     （常驻桌面）
```

这种架构确保 API 故障不会导致桌面卡死——缓存始终保存着最后一次已知状态。

## 血条式进度可视化

核心特色是**血条风格的配额显示**——一排 Unicode 方块字符直观展示剩余配额：

| 颜色 | 状态 |
|------|------|
| `█████████` 绿色 | 配额超过 50% |
| `████░░░░░` 橙色 | 剩余 20-50% |
| `█░░░░░░░░` 红色 | 低于 20% |
| `░░░░░░░░░` 红色 | 已耗尽 / 无余额 |
| `─────────` 灰色 | 未配置 API key |

进度条宽度为 9 个字符，每个 `█` 约代表 11% 的配额。

## 安装步骤

```bash
# 1. 克隆仓库
git clone https://github.com/luckybbjason1/ai-token-monitor
cd ai-token-monitor

# 2. 安装
bash install.sh

# 3. 填写 API keys
nano ~/.config/.ai_monitor_keys

# 4. 重启 Conky
pkill conky && conky --daemonize --pause=1
```

安装脚本自动完成：
- 将脚本复制到 `~/token-monitor/`
- 在 Conky 配置中添加 `${execpi 30 python3 ~/token-monitor/conky_ai.py}`
- 设置 `api_fetcher.py` 的 cron 定时任务

## 各服务支持情况

| 服务 | API 端点 | 检测内容 |
|------|---------|----------|
| **Kimi**（Moonshot） | `GET /v1/users/me` | 精确剩余 Token 配额 |
| **Claude**（Anthropic） | `POST /v1/messages` | 响应头中的速率限制窗口 |
| **Gemini**（Google） | `POST .../generateContent` | 429 = 配额已用完 |
| **Grok**（xAI） | `GET /v1/models` | 403 = 余额耗尽 |
| Codex / Kilo | — | 倒计时至 UTC+8 午夜 |

## 安全设计

API key 存储在 `~/.config/.ai_monitor_keys`，文件权限为 `chmod 600`，并通过 `.gitignore` 排除在 git 之外。key 不会被打印到终端或写入日志——fetcher 在启动时读取一次，仅在 HTTP 请求期间保留在内存中。

## 扩展自定义服务

在 `api_fetcher.py` 末尾添加代码块：

```python
# ── 自定义服务 ────────────────────────────────────
key = keys.get('yourservice')
if key:
    try:
        r = requests.get('https://api.yourservice.com/v1/usage',
                         headers={'Authorization': f'Bearer {key}'}, timeout=8)
        if r.status_code == 200:
            data = r.json()
            remain = data['quota_remaining']
            total  = data['quota_total']
            cache['YourService'] = {
                'ok': True,
                'label': f'{remain//1000}K剩',
                'pct': remain / total
            }
        else:
            cache['YourService'] = {'ok': False, 'label': 'API 错误'}
    except Exception:
        pass
```

然后在 `conky_ai.py` 的 `SERVICES` 列表中添加 `{'name': 'YourService', 'reset_h': 24}`。

## dibi8 相关工具

如果你在管理多个 AI API 的使用成本，还可以参考：

- [2026 Q2 AI 编程横评——Claude Code vs Cursor vs Codex](/zh/resources/dev-utils/ai-coding-2026-q2-claude-code-cursor-codex-gemini-shootout/) — 真实开发工作流成本对比
- [RTK Rust CLI 代理——降低 80% AI 成本](/zh/resources/dev-utils/rtk-rust-cli-proxy-ai-coding-cost-save-80-percent-2026/) — 自动路由提示词，节省高达 80% 的 AI API 费用
- [2026 AI 编程月账单实录](/zh/resources/dev-utils/ai-coding-agent-monthly-bill-2026-real-receipts/) — 六个月生产环境 AI 使用真实账单

## 获取代码

工具完全开源，MIT 许可证。

**GitHub：** [github.com/luckybbjason1/ai-token-monitor](https://github.com/luckybbjason1/ai-token-monitor)

如果这个工具帮你避免了任务中途被限流的困扰，欢迎 Star 支持。也欢迎提 Issue 和 PR——特别期待 macOS 支持和新服务集成的贡献。
