---
title: 'Đánh giá CodeGraph: Đồ thị mã được pre-index giúp Claude Code, Cursor, Codex tiết kiệm 35% token (2026)'
description: 'CodeGraph (20.2K+ stars trên GitHub) là công cụ open-source pre-index đồ thị tri thức mã nguồn cho Claude Code, Cursor, Codex CLI, OpenCode và Hermes Agent. Lưu cục bộ SQLite, 19 ngôn ngữ, nhận diện 14 framework routing, không cần API ngoài. Giảm ~35% token và ~70% lượng tool call so với grep/glob/Read thô. Phân tích tính năng, hướng dẫn cài đặt, workflow thực tế, so sánh với LSP và dịch vụ MCP.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: 'v0.9.3'
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/colbymchenry/codegraph'
stars: 20200
maintainer: 'colbymchenry'
last_maintained: '2026-05-22'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['codegraph', 'claude-code', 'ai-coding-agent', 'code-graph', 'token-savings', 'mcp', 'hermes-agent', 'cursor', 'codex-cli', 'opencode', 'developer-productivity']
aliases:
- /vi/posts/codegraph-pre-indexed-knowledge-graph-2026/
---

## Vấn đề: AI coding agent đang đốt token vào `grep`

Nếu bạn đang trả tiền cho Claude Code, Cursor Pro, hay chạy Codex CLI qua OpenAI, bạn đã cảm nhận điều này. Mỗi lần agent cần "hiểu" một codebase, nó khởi động pha Explore: `Glob` để tìm file, `Grep` để tìm symbol, `Read` để load context. Mỗi lần gọi là một vòng tool round-trip. Mỗi round-trip là token — cả payload request và response trả về context.

Trên codebase trung bình (~50K dòng), một câu hỏi "`UserService` được dùng ở đâu?" có thể ăn 8,000–15,000 token chỉ riêng việc quét file, trước khi agent thực sự bắt đầu suy luận. Nhân với một ngày chỉnh sửa thì bạn nhìn thấy hóa đơn thật.

Nguyên nhân gốc: **AI agent không có bộ nhớ bền vững về hình dạng codebase**. Mỗi session đều tái khám phá call graph. Mỗi. Lần. Một.

[**CodeGraph**](https://github.com/colbymchenry/codegraph) (GitHub: `colbymchenry/codegraph`, **20,200+ stars tính đến tháng 5/2026**) là dự án open-source đầu tiên được áp dụng rộng rãi để giải quyết vấn đề này. Nó là đồ thị tri thức pre-index gồm symbol, quan hệ gọi hàm, framework route và cấu trúc file của mã nguồn, query trong vài mili giây — và cắm vào Claude Code, Cursor, Codex CLI, OpenCode, Hermes Agent qua một MCP server duy nhất.

Số liệu công bố: **rẻ hơn ~35% mỗi session, ít hơn ~70% tool call, 100% local, không API ngoài**.

---

## CodeGraph thực sự là gì

Bản chất là ba thứ gộp lại:

1. **Trình index** — đi qua repo, phân tích mọi file được hỗ trợ, trích xuất symbol (function, class, type, export), quan hệ gọi ("function A gọi function B"), framework route ("`/api/users` được xử lý bởi `UserController.list`"). Toàn bộ lưu vào SQLite cục bộ.

2. **CLI query** — `codegraph query`, `codegraph callers`, `codegraph impact`. Trả về JSON cấu trúc trong vài mili giây — không tốn token, không vòng LLM.

3. **Watcher tự động đồng bộ** — dùng file watcher native của hệ điều hành (macOS `fsevents`, Linux `inotify`, Windows `ReadDirectoryChangesW`) để giữ đồ thị tươi khi bạn chỉnh sửa. Không daemon polling chạy nền. Không dữ liệu cũ.

Toàn bộ dự án ~92% TypeScript với lớp shim mỏng cho từng nền tảng, license MIT, `v0.9.3` phát hành ngày 22/5/2026 — ba ngày trước bài viết này.

### Ngôn ngữ và framework được hỗ trợ

- **Hơn 19 ngôn ngữ lập trình**: TypeScript, JavaScript, Python, Go, Rust, Java, C#, C++, Ruby, PHP, Swift, Kotlin, cùng nhiều ngôn ngữ ngách khác.
- **14 router framework được nhận diện**: Next.js, Nest.js, Express, FastAPI, Django, Flask, Rails, Spring Boot, Laravel, v.v. — nghĩa là khi bạn hỏi "`POST /api/login` được xử lý ở đâu?", CodeGraph trả lời bằng controller và method thật, không phải vị trí xuất hiện chuỗi `/api/login`.

---

## Số liệu đằng sau

Các chỉ số headline của CodeGraph đến từ benchmark nội bộ so sánh Claude Code có và không có đồ thị:

| Chỉ số | Không CodeGraph | Có CodeGraph |
|---|---|---|
| Trung bình tool call mỗi câu hỏi "hiểu X" | ~22 | ~6.5 |
| Trung bình token mỗi session (repo trung bình) | 11,400 | 7,400 |
| Độ trễ wall-clock truy vấn symbol | 4–9 giây | 50–200 ms |

Cải thiện wall-clock thậm chí thú vị hơn. Dù bạn không quan tâm chi phí, pha Explore xong trong 200ms thay vì 8 giây thay đổi *cảm giác* về agent — không còn là chờ API từ xa nữa, mà giống công cụ local.

---

## Các AI coding tool được hỗ trợ

CodeGraph tích hợp qua MCP (Model Context Protocol) cho tool đã hỗ trợ MCP, và qua CLI trực tiếp cho tool chưa hỗ trợ:

- **[Claude Code](https://dibi8.com/vi/vs/claude-code-vs-aider/)** — đăng ký MCP server. Sau khi cấu hình, agent Explore của Claude Code tự ưu tiên CodeGraph thay vì `grep`/`glob` thô.
- **[Cursor](https://dibi8.com/vi/vs/claude-code-vs-aider/)** — cùng kiểu MCP server.
- **[Codex CLI](https://dibi8.com/vi/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/)** — tích hợp CLI qua shell alias hoặc wrapper script.
- **[OpenCode](https://dibi8.com/vi/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/)** — tương thích MCP.
- **[Hermes Agent](https://dibi8.com/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)** — tích hợp native qua bộ MCP tool của Hermes.

Trong mọi trường hợp cách tích hợp đại khái giống nhau: index repo một lần, thêm CodeGraph MCP server (hoặc alias) vào config agent, agent có ngay năng lực "truy vấn cấp symbol" như công dân hạng nhất.

---

## Cài đặt nhanh

CodeGraph có ba cách cài đặt, chọn cái phù hợp với stack:

```bash
# macOS / Linux — script cài chính thức
curl -fsSL https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.sh | sh

# Windows PowerShell
irm https://raw.githubusercontent.com/colbymchenry/codegraph/main/install.ps1 | iex

# Hoặc npm (đa nền tảng, không cần cài)
npx @colbymchenry/codegraph
```

Sau khi cài, tại thư mục gốc repo:

```bash
# Index lần đầu — một lần duy nhất, ~10 giây cho repo 50K dòng
codegraph init -i

# Query symbol — tìm UserService và mọi thứ liên quan
codegraph query UserService

# Truy ngược caller — ai gọi loginFunction?
codegraph callers loginFunction

# Phân tích impact — nếu thay đổi cái này, gì sẽ hỏng?
codegraph impact src/auth/session.ts
```

Watcher chạy nền và giữ đồng bộ khi bạn chỉnh sửa. Không daemon nào cần trông.

---

## Cắm vào Claude Code

Workflow phổ biến nhất. Trong `~/.claude/mcp_servers.json`:

```json
{
  "mcpServers": {
    "codegraph": {
      "command": "codegraph",
      "args": ["mcp"],
      "env": {}
    }
  }
}
```

Vậy thôi. Khởi động lại Claude Code, lần tới bạn hỏi "tìm mọi nơi dùng `AuthMiddleware`", Claude sẽ hit CodeGraph thay vì xòe ra 12 `grep` call.

---

## So sánh

Có ba cách tiếp cận hiện có mà CodeGraph cạnh tranh:

### So với `grep`/`glob`/`Read` thô
Đây là hành vi mặc định của Claude Code / Cursor. Cài đặt rẻ (không cần install), nhưng mỗi session đều quét lại. Một khi repo đã được CodeGraph index, nó thắng áp đảo về chi phí và độ trễ.

### So với Language Server (LSP)
LSP (TypeScript Server, gopls, rust-analyzer) cung cấp trí tuệ symbol tương tự. Khác biệt:
- LSP theo ngôn ngữ; CodeGraph là polyglot trong một binary duy nhất.
- LSP thiết kế cho editor, không phải cho headless agent query — gọi từ CLI agent rất vụng.
- CodeGraph lưu đồ thị; LSP tính lại mỗi lần.

Với workflow agent, mô hình pre-index của CodeGraph phù hợp hơn. Với chỉnh sửa tương tác, LSP vẫn là số một.

### So với MCP server như Sourcegraph hay Continue
Sourcegraph và Continue cũng cung cấp MCP server trí tuệ mã, nhưng dựa trên cloud, đòi hỏi tự host cả service hoặc trả tiền plan host. CodeGraph là binary đơn, hoàn toàn local, zero credential. Với developer cá nhân và team nhỏ đây là cam kết nhẹ hơn nhiều.

---

## Điều CodeGraph không làm

Để đặt kỳ vọng đúng:

- **Không tìm kiếm ngữ nghĩa** — đây là cấu trúc, không dựa embedding. "Tìm mã làm X về mặt khái niệm" không phải việc của nó. Nếu cần, kết hợp vector store (`agentmemory` hoặc Qdrant local).
- **Không join đa repo** — index một repo mỗi lần. Polyrepo monorepo cần index riêng từng cái.
- **Phân giải macro/generic giới hạn** — Rust trait dispatch, C++ template, TS conditional types được phân giải một phần. Đôi khi nhận "tham khảo" thay vì câu trả lời dứt khoát.
- **Không lịch sử git** — `codegraph` về cây hiện tại, không phải "function này đổi khi nào". Dùng `git log` hoặc [Sourcegraph](https://about.sourcegraph.com).

---

## Ai nên dùng

**Có, cài, nếu bạn:**
- Làm trong codebase lớn hơn ~20K dòng và chạy Claude Code, Cursor, hay bất kỳ coding agent hỗ trợ MCP nào hàng ngày.
- Đã thấy session đốt hơn $1–$2 token trước khi cho ra output hữu ích.
- Muốn truy vấn symbol dưới một giây trong terminal bất kể context agent.

**Có thể bỏ qua nếu bạn:**
- Chủ yếu làm trong script đơn lẻ hoặc notebook.
- Hài lòng với LSP tích hợp sẵn của IDE và không dùng AI agent.
- Cần trí tuệ đa repo là tính năng chính.

---

## Kết luận

CodeGraph là công cụ developer hiếm của kỷ nguyên 2026 — vừa định nghĩa vấn đề rõ vừa có số liệu kiểm chứng được. 35% giảm token là ước tính bảo thủ — trên workflow Explore lặp đi lặp lại nhiều, chúng tôi thấy Claude Code đạt tiết kiệm 50%+ sau khi index khởi động xong. Kết hợp với cải thiện độ trễ (lợi ích **định tính**), nó là một trong số ít bổ sung miễn phí cho workflow Claude Code có thể tự hoàn vốn ngay session đầu.

License MIT, kiến trúc local-first, không phụ thuộc bên ngoài — no-brainer cho bất kỳ ai chạy coding agent ở quy mô lớn. 20,200 stars trong nửa đầu 2026 phản ánh điều đó — và cadence `v0.9.3` cho thấy `v1.0` không còn xa.

Kết hợp với [trung tâm điều khiển CLI AI hợp nhất như CC Switch](https://dibi8.com/vi/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) và [proxy nhận thức chi phí như rtk](https://dibi8.com/vi/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/), bạn đã lắp ráp xong stack AI coding 2026 thực sự kiểm soát ngân sách của mình.

---

**GitHub**: [colbymchenry/codegraph](https://github.com/colbymchenry/codegraph) · **License**: MIT · **Mới nhất**: v0.9.3 (22/5/2026) · **Stars**: 20.2K+
