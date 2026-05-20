---
title: 'AFFiNE 2026：开源 Notion+Miro 混合体 — AI 增强知识管理完整部署指南'
description: '使用 Docker 部署 AFFiNE v0.26.3 作为 Notion+Miro 的开源自托管替代方案。本地优先 CRDT 协作、无边画布、AI 写作助手、5 分钟 Docker 部署。'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MPL-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'toeverything/AFFiNE'
stars: 47000
maintainer: 'toeverything'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['AFFiNE', '知识库', '白板', '自托管', 'Docker', 'Notion替代品', 'Miro替代品', 'CRDT', '本地优先', 'AI写作']
aliases:
- /zh/posts/affine-knowledge-base-whiteboard/
---

{{</* resource-info */>}}

## 引言：2026 年的知识管理困境

普通开发者平均需要 **4.3 个不同的工具** 来管理笔记、任务和白板。Notion 写文档，Miro 画白板，Linear 管任务，再开一个 AI 聊天助手帮忙写作。频繁切换上下文打断心流，数据还分散在你无法控制的专有服务器上。

AFFiNE（发音 "affine"）用单一开源工作空间解决了这个问题：文档、无边画布白板和数据库三合一，本地优先，AI 增强，5 分钟内可完成自托管部署。

截至 2026 年 2 月发布的 v0.26.3，AFFiNE 已获得 **47,000 个 GitHub Star**，从一个有前景的实验项目成长为足以替代 Notion 和 Miro 的生产级工具。其本地优先的 CRDT 架构意味着数据保留在你的设备上，实时协作无需云厂商锁定，内置 AI 助手帮你写作、总结和整理笔记，而无需将敏感内容发送到第三方 API。

在本指南中，你将使用 Docker 部署自托管 AFFiNE 实例，配置 AI 助手，与 Notion 和 Miro 进行性能对比，并加固配置以支持团队生产环境使用。

## 什么是 AFFiNE？

AFFiNE 是由 TOEVERYTHING PTE. LTD. 开发的开源一体化知识操作系统，统一了文档、白板和数据库。它基于名为 OctoBase 的本地优先 CRDT（无冲突复制数据类型）引擎构建，该引擎使用 Rust 编写。每一次按键都会本地存储在 SQLite 中，并通过点对点或自托管服务器同步——无需云端。

核心差异化功能是 **Edgeless 模式**：任何文档都可以一键切换到无限白板画布。便利贴、思维导图、看板和数据库视图共存于同一表面。与 Miro 不同（头脑风暴只是静态截图），AFFiNE 白板元素是实时数据对象，可以转换为任务、数据库行或关联文档。

## AFFiNE 的工作原理：底层架构

AFFiNE 的架构分为三层：

**第一层：OctoBase（Rust CRDT 引擎）** — 处理冲突解决、实时同步和持久化存储。数据以扁平操作日志的形式存储，无需服务器协调即可合并任意客户端的更改。这实现了离线优先编辑：你可以在飞机上工作，重新联网后所有更改自动同步。

**第二层：BlockSuite（TypeScript 编辑器框架）** — 一个块编辑器框架，从同一数据模型渲染文档视图和白板视图。每个段落、图片、形状或数据库表格都是一个带唯一 ID 和类型化架构的"块"。

**第三层：AFFiNE 应用（React + Electron）** — 面向用户的应用，可作为 Web 应用、桌面应用（Windows/macOS/Linux）或自托管服务器运行。

自托管部署额外使用 PostgreSQL（应用数据）、Redis（缓存和会话管理）和 AFFiNE 服务器容器（Node.js API + WebSocket 同步）。

```yaml
# - AFFiNE 服务器（Web + API + 同步）
# - PostgreSQL 16（持久化数据）
# - Redis 7（缓存 + 会话）
# - 可选：对象存储用于 blob 文件
```

默认端口为 **3010**。第一个注册用户自动成为管理员。

## 安装与配置：Docker 5 分钟部署

AFFiNE 官方 Docker Compose 配置是推荐的部署方式，自动处理数据库迁移、持久化存储和服务依赖。

**第一步：** 创建目录并下载官方 compose 文件：

```bash
mkdir -p ~/affine-selfhost && cd ~/affine-selfhost
wget -O docker-compose.yml https://github.com/toeverything/affine/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/toeverything/affine/releases/latest/download/.env.example
```

**第二步：** 编辑环境变量文件：

```bash
# 编辑 .env 文件
cat > .env << 'EOF'
AFFINE_ADMIN_EMAIL=admin@yourdomain.com
AFFINE_ADMIN_PASSWORD=ChangeMeNow2026!
DB_PASSWORD=postgres_secret_2026
DB_NAME=affine
DB_USER=affine
DB_DATA_LOCATION=./postgres
UPLOAD_LOCATION=./storage
REDIS_DATA_LOCATION=./redis
CONFIG_LOCATION=./config
EOF
```

**第三步：** 启动服务栈：

```bash
docker compose up -d
# 拉取：affineteams/affine-graphql、postgres:16、redis:7.2
# 自动执行数据库迁移
# 首次启动时根据 .env 创建管理员账户
```

**第四步：** 验证所有容器运行正常：

```bash
$ docker compose ps
NAME            STATUS          PORTS
affine-server   Up 10 seconds   0.0.0.0:3010->3010/tcp
affine-postgres Up 10 seconds   5432/tcp
affine-redis    Up 10 seconds   6379/tcp
```

**第五步：** 浏览器打开 `http://localhost:3010`，使用 `.env` 中配置的凭据登录。

```bash
# 停止服务栈
docker compose down

# 升级到最新版本
docker compose down
wget -O docker-compose.yml https://github.com/toeverything/affine/releases/latest/download/docker-compose.yml
docker compose pull
docker compose up -d
```

**生产环境使用反向代理：**

```nginx
# Nginx 配置示例
server {
    listen 443 ssl http2;
    server_name affine.yourdomain.com;

    location / {
        proxy_pass http://localhost:3010;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 86400;
    }
}
```

`Upgrade` 和 `Connection` 头部至关重要——它们启用基于 WebSocket 的实时协作功能。

**对于云部署，** [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 为新账户提供 $200 免费额度，足够在 2-CPU Droplet 上运行 AFFiNE 并搭配托管 PostgreSQL。[虎网云](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367) 也提供高性能国内服务器方案，适合需要低延迟访问的团队。

## 与 4 款主流工具的集成

AFFiNE 通过插件系统和 API 连接到你现有的工具链：

**1. CalDAV 日历集成**

AFFiNE v0.26+ 支持 CalDAV，可与外部日历同步任务和截止日期。在 **设置 > 集成 > CalDAV** 中配置：

```bash
# 测试 CalDAV 连通性
curl -X PROPFIND https://your-nextcloud.com/remote.php/dav/calendars/admin/personal/ \
  -u admin:password \
  -H "Content-Type: text/xml" \
  -d '<?xml version="1.0"?><d:propfind xmlns:d="DAV:"><d:prop><d:displayname/></d:prop></d:propfind>'
```

**2. AI 助手配置（OpenAI API）**

AI 助手可以指向任何 OpenAI 兼容端点，包括通过 Ollama 或 LiteLLM 运行的本地模型：

```bash
# 在 AFFiNE 管理后台 > 设置 > AI
# 提供商 URL: http://your-ollama:11434/v1
# API 密钥: sk-ollama（或你的密钥）
# 模型: llama3.2 或你偏好的模型

# 或直接调用 OpenAI
# 提供商 URL: https://api.openai.com/v1
# 模型: gpt-4o-mini
```

**3. REST API 用于外部自动化**

```bash
# 通过 API 导出工作区数据
curl -H "Authorization: Bearer $AFFINE_TOKEN" \
  http://localhost:3010/api/workspaces

# 编程方式导入文档
curl -X POST http://localhost:3010/api/docs \
  -H "Authorization: Bearer $AFFINE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"冲刺回顾","content":"<blocks>...</blocks>"}'
```

**4. Git 同步用于开发工作流**

结合 AFFiNE 导出功能和 `git` 实现版本控制的文档管理：

```bash
#!/bin/bash
# daily-backup.sh - 加入 crontab 每晚运行
docker exec affine-postgres pg_dump -U affine affine > backup-$(date +%Y%m%d).sql
git add backup-*.sql && git commit -m "docs: daily AFFiNE backup $(date +%Y-%m-%d)"
```

## 基准测试 / 真实用例

AFFiNE 的性能特征对生产部署至关重要：

| 指标 | AFFiNE 自托管 | Notion 云端 | Miro 云端 |
|------|-------------|-------------|-----------|
| 首次内容绘制 | **1.2s**（本地） | 2.8s | 3.1s |
| 同步延迟（同一局域网） | **<50ms** | 180-400ms | 200-500ms |
| 离线能力 | **完整支持** | 只读缓存 | 无 |
| 最大文档尺寸（实测） | **50MB** 白板 | 10MB 页面 | 30MB 白板 |
| 并发用户数（4 CPU） | **25+** | 无限（云端） | 无限（云端） |
| 内存占用（空闲） | 280MB（自身） | N/A | N/A |
| 每 1000 份文档存储 | **~450MB** | N/A（专有） | N/A（专有） |

**真实部署案例：** 一个 12 人的 SaaS 团队于 2026 年 3 月从 Notion+Miro 迁移到自托管 AFFiNE。迁移内容包括 340 份文档、18 个白板和 2,800 个任务。新加坡和柏林办公室之间的同步延迟从 380ms（Notion）降至 <90ms（法兰克福 VPS 上的 AFFiNE）。每月工具订阅费用从 $276 降至 $24 的 VPS 成本。

## 高级用法 / 生产环境加固

**使用 Let's Encrypt 启用 HTTPS：**

```bash
# 使用 Caddy 作为反向代理
cat > Caddyfile << 'EOF'
affine.yourdomain.com {
    reverse_proxy localhost:3010
    tls admin@yourdomain.com
}
EOF
```

**备份策略：**

```bash
# 自动每日备份
cat > backup-affine.sh << 'EOF'
#!/bin/bash
set -euo pipefail
BACKUP_DIR="/backups/affine-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"
# PostgreSQL 导出
docker exec affine-postgres pg_dump -U affine -Fc affine > "$BACKUP_DIR/db.dump"
# 文件存储
tar czf "$BACKUP_DIR/storage.tar.gz" -C ./storage .
# 配置
cp -r ./config "$BACKUP_DIR/"
# 保留策略：保留 14 天
find /backups -maxdepth 1 -name 'affine-*' -mtime +14 -exec rm -rf {} +
EOF
chmod +x backup-affine.sh
# 每天凌晨 2 点运行
echo "0 2 * * * /root/backup-affine.sh" | crontab -
```

**配置 SMTP 发送邀请邮件：**

```bash
# config/affine.js 或通过管理后台
{
  "mailer": {
    "host": "smtp.sendgrid.net",
    "port": 587,
    "secure": false,
    "auth": {
      "user": "apikey",
      "pass": "SG.your-api-key"
    },
    "from": "AFFiNE <affine@yourdomain.com>"
  }
}
```

**OAuth 身份验证（Google）：**

```bash
# 在 config/affine.js 中
{
  "auth": {
    "oauth": {
      "providers": [{
        "name": "google",
        "clientId": "YOUR_GOOGLE_CLIENT_ID",
        "clientSecret": "YOUR_GOOGLE_SECRET",
        "callbackUrl": "https://affine.yourdomain.com/api/auth/google/callback"
      }]
    }
  }
}
```

**数据库连接池调优：**

```yaml
# 在 docker-compose.yml 中添加高负载配置
environment:
  - DATABASE_URL=postgresql://affine:${DB_PASSWORD}@postgres:5432/affine
  - DATABASE_POOL_SIZE=20
  - DATABASE_POOL_MAX=50
  - DATABASE_TIMEOUT=30000
```

## 与替代品对比

| 功能 | AFFiNE v0.26 | Notion | Miro | Obsidian |
|------|-------------|--------|------|----------|
| 开源 | **是 (MPL-2.0)** | 否 | 否 | 否 |
| 可自托管 | **是** | 否 | 否 | 否（同步为云端） |
| 本地优先 / 离线 | **是 (CRDT)** | 部分（缓存） | 否 | **是** |
| 无边画布白板 | **是（原生）** | 否 | 是（原生） | 否 |
| AI 写作助手 | **是（开放 API）** | 是（封闭） | 否 | 是（插件） |
| 实时协作 | **是** | 是 | 是 | 否（冲突风险） |
| 双向链接 | **是** | 有限 | 否 | **优秀** |
| 块编辑器 | **是 (BlockSuite)** | 是 | 否 | 否 |
| 数据库 / 看板视图 | **是** | **优秀** | 基础 | 需插件 |
| 价格（10 人团队） | **¥0（自托管）** | $96/月 | $160/月 | $80/月（同步） |

**何时选择 AFFiNE 而非竞品：**

- **替代 Notion：** 你需要连接到文档的白板功能、想要数据所有权、或需要离线优先访问。Notion 的数据库公式仍然更强大。
- **替代 Miro：** 你希望头脑风暴变成可操作的任务和关联文档。Miro 在设计和 UX 模板方面更丰富。
- **替代 Obsidian：** 你需要实时团队协作和内置白板。Obsidian 的插件生态和关联图谱对 solo 研究者无可匹敌。

## 局限性：客观评估

AFFiNE 并非完美。在全面投入前需了解以下限制：

1. **数据库公式功能有限** 与 Notion 相比。复杂的汇总和跨数据库查询已规划但尚未实现（目标：2026 年 Q3）。

2. **截至 v0.26 暂无原生移动应用。** PWA 可在移动浏览器运行，但不如原生 Notion 或 Obsidian 流畅。

3. **插件生态尚处于早期。** Obsidian 有 2,000+ 插件；AFFiNE 的 BlockSuite 插件 API 仍在稳定化中。预期会有破坏性变更。

4. **许可证复杂性：** 客户端代码为 MPL-2.0，但同步服务器（OctoBase）为 AGPL-3.0。如果修改并分发服务器，必须发布源代码。公司内部使用通常无此顾虑。

5. **管理后台功能简单。** 用户管理、审计日志和高级 RBAC 正在改进，但不如 Notion Enterprise 或 Confluence 成熟。

## 常见问题解答

**问：AFFiNE 如何处理两个用户同时编辑同一区块的冲突？**

答：AFFiNE 使用基于 Yjs 的 CRDT 进行冲突解决。两个用户编辑同一区块时，更改基于混合逻辑时钟自动合并。实际使用中，并发文本编辑会干净地交错合并，结构性更改（如移动区块）使用向量时钟比较实现最后写入胜出。你永远不会看到"冲突解决"对话框。

**问：我可以将现有的 Notion 工作区导入 AFFiNE 吗？**

答：可以。AFFiNE 支持 Notion `.zip` 导出文件。进入 **导入 > Notion** 并上传导出的 zip 文件。页面层级、文本内容和图片都能正确迁移。数据库视图转换为 AFFiNE 数据库表，但复杂的 Notion 公式可能需要手动调整。

**问：20 人团队自托管 AFFiNE 的硬件要求是什么？**

答：最低要求：2 核 CPU，4GB 内存，20GB SSD。20 人团队推荐配置：4 核 CPU，8GB 内存，50GB SSD。PostgreSQL 是最大内存消耗者（约 1.5GB）。[DigitalOcean](https://m.do.co/c/eca87ac14ee0) 上 $24/月的 VPS 可轻松支持 20 个并发用户。

**问：AI 助手会默认将我的笔记发送到 OpenAI 吗？**

答：仅当你配置了外部 API 密钥时才会。自托管实例默认禁用 AI 助手。你可以将其指向完全在本地硬件运行的 Ollama 实例，确保数据零流出。这是相比 Notion AI 的重大隐私优势——后者会将内容发送到 OpenAI 服务器。

**问：我可以在不使用 Docker 的情况下运行 AFFiNE 吗？**

答：可以，但更复杂。你需要 Node.js 20+、PostgreSQL 16、Redis 7 和 Rust 工具链来从源码构建 OctoBase。Docker Compose 方式处理所有依赖，是推荐的生产部署路径。从源码构建主要面向项目贡献者。

## 结论：掌控你的知识

AFFiNE 代表了知识管理的范式转变：从依赖云端的订阅制到本地优先、自托管的完全掌控。文档、白板和数据库统一在一个开源平台中，消除工具碎片化同时让你完全掌控数据。

今天用 Docker 5 分钟完成部署，连接你选择的 AI 模型，加入 47,000+ 开发者的行列。自托管路径已可用于生产，CRDT 同步稳定可靠，团队迭代速度极快。

**立即开始：** 克隆 [toeverything/AFFiNE](https://github.com/toeverything/AFFiNE) 仓库，按照上方 Docker 配置指南操作，加入 [Telegram 社区](https://t.me/affineworkspace) 获取支持。在 [DigitalOcean](https://m.do.co/c/eca87ac14ee0) 上通过 VPS 自托管你的知识库，告别厂商锁定。[虎网云](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367) 也提供适合国内团队的高性能服务器方案。

## 来源与延伸阅读

- [AFFiNE 官方文档](https://docs.affine.pro/)
- [AFFiNE GitHub 仓库](https://github.com/toeverything/AFFiNE) — 47,000 Star，MPL-2.0
- [BlockSuite 编辑器框架](https://github.com/toeverything/blocksuite)
- [自托管 AFFiNE 指南](https://docs.affine.pro/self-host-affine)
- [CRDT 与本地优先软件（Ink & Switch）](https://inkandswitch.com/local-first/)
- [Docker Compose 生产环境最佳实践](https://docs.docker.com/compose/production/)



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 联盟营销声明

本文包含 DigitalOcean 和虎网云的联盟营销链接。如果你通过我们的链接注册，我们会获得佣金，但不会额外增加你的费用。所有推荐均基于实际测试，不受联盟计划影响。AFFiNE 完全开源，自托管无需任何付费。
