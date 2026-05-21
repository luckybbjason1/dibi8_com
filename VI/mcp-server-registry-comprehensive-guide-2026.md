---
title: 'Hướng Dẫn MCP Server Registry 2026: 19,700+ Server, 7 Cái Chính Thức, Tìm Đúng Cái Trong 60 Giây'
description: 'Hướng dẫn toàn diện khám phá MCP server 2026. 7 server reference Anthropic, awesome list 87.3k star, so sánh registry Smithery vs mcp.so, top server từng category, và cây quyết định lựa chọn — không phải MCP là gì, mà là cái gì bạn có thể cắm vào MCP host của mình.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack:
  - TypeScript
  - Python
  - Docker
application_domain: Llm Frameworks
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/modelcontextprotocol/servers'
stars: 86000
maintainer: 'dibi8'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['MCP', 'Model Context Protocol', 'Registry', 'Hub article']
aliases:
  - /posts/mcp-server-registry-comprehensive-guide-2026/
---

Tháng 1/2026, bạn có thể nhét toàn bộ MCP server công khai vào một README GitHub. Tháng 5/2026, [mcp.so](https://mcp.so) liệt kê **19,700+** cái. Nút thắt cổ chai không còn là "làm thế nào để xây một cái" — mà là "trong 19,700 cái, tôi thực sự cắm cái nào?"

Hướng dẫn này trả lời chính xác câu đó. Chúng tôi **không giải thích lại MCP là gì** (đọc [hướng dẫn MCP chuyên sâu 2026](/vi/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) cho điều đó). Bài này map **hệ sinh thái server** — 7 lựa chọn reference Anthropic, danh sách cộng đồng 87.3k star, hai nền tảng registry, và cây quyết định 30 giây để tìm server phù hợp cho nhu cầu cụ thể của bạn.

## 1. Vì Sao Số MCP Server Bùng Nổ 100× Trong 6 Tháng

Ba điều kết hợp:

1. **Áp dụng đa nền tảng**: Đầu 2026, Anthropic, OpenAI, Google DeepMind đều hỗ trợ MCP. Server bạn viết một lần chạy được trong Claude Desktop, ChatGPT, Gemini
2. **Tooling trưởng thành**: SDK TypeScript, Python, Go, Rust, Swift — xây server là dự án 50 dòng một buổi chiều
3. **Roadmap 2026 đáp đất**: Khả năng mở rộng transport (server scale ngang không giữ state session), auth doanh nghiệp (SSO/audit trail), MCP Apps (extension UI qua SEP-1865) làm protocol sẵn sàng production

Kết quả: 500+ server công khai tháng 1, ~5,000 tháng 3, 19,700+ tháng 5. **Phần lớn là tín hiệu chứ không phải nhiễu** — nhưng bạn cần một bản đồ.

## 2. Cây Quyết Định Khám Phá 30 Giây

| Bạn muốn… | Tìm trước ở đây |
|---|---|
| Dùng basic được kiểm chứng (filesystem, fetch, git) | **Server reference Anthropic** (sec. 3) |
| Duyệt theo category (DB, browser, cloud) | **awesome-mcp-servers** (sec. 4) |
| Cài + quản lý server không động vào config | Registry **Smithery** (sec. 5) |
| Duyệt catalog lớn nhất có thể | **mcp.so** (19.7k+) (sec. 5) |
| Self-host server vì lý do tuân thủ | Chọn OSS server + xem sec. 7 |
| Tự xây | Đọc [hướng dẫn MCP chuyên sâu](/vi/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) |

Phần còn lại bài này mở từng dòng.

## 3. 7 Server Reference Của Anthropic — Đường Cơ Sở

Repo chính thức [modelcontextprotocol/servers](https://github.com/modelcontextprotocol/servers) (86k GitHub star) ship 7 implementation reference được bảo trì. Đây là các server Anthropic dùng nội bộ và đóng dấu "đường vui" của protocol:

| Server | Làm gì | Use case điển hình |
|---|---|---|
| **Everything** | Server demo expose mọi MCP primitive (tools, resources, prompts) | Đọc reference cho tác giả protocol |
| **Fetch** | HTTP/HTTPS fetcher + html→markdown | LLM đọc URL bất kỳ on demand |
| **Filesystem** | Read/write/list FS local sandboxed | Coding agent làm việc trong project dir |
| **Git** | Introspection repo Git (log, diff, blame, branch) | AI assistant nhận biết code |
| **Memory** | Memory KV persistent + tìm kiếm embedding | Agent chạy dài cần ghi nhớ |
| **Sequential Thinking** | Scaffold reasoning đa bước (chain-of-thought như tool) | Task lên kế hoạch phức tạp |
| **Time** | Thao tác date/time nhận thức timezone | Agent lên lịch, bot lịch |

Hai server reference cũ đã nghỉ hưu:

- **Brave Search** — chuyển sang [brave/brave-search-mcp-server](https://github.com/brave/brave-search-mcp-server), Brave tự bảo trì
- **Slack** — giờ do Zencoder cộng đồng bảo trì

Nếu bắt đầu hôm nay, copy config bao gồm **Filesystem + Fetch + Memory** — đó là "bộ tối thiểu hữu ích" cho coding agent tự trị.

## 4. awesome-mcp-servers — Chỉ Mục Cộng Đồng 87.3k Star

[punkpeye/awesome-mcp-servers](https://github.com/punkpeye/awesome-mcp-servers) là catalog cộng đồng de facto: **87.3k star, 10.5k fork, 1.6k PR**. Server nhóm thành ~40 category. Đây là các category quan trọng nhất cho workflow AI dev 2026:

- **Aggregators** — Compose nhiều MCP server đằng sau một endpoint (`1mcp/agent`, `a2asearch-mcp`)
- **Browser Automation** — `playwright-mcp`, `browsermcp/mcp`, `real-browser-mcp`
- **Cloud Platforms** — `terraform-mcp-server`, `aws-mcp-server`, `k8s-mcp-server`, `localstack-mcp-server`
- **Code Execution** — `e2b-sandbox-mcp` (sandbox cloud), `piston-mcp` (multi-lang runner), `pydantic-ai/mcp-run-python`
- **Coding Agents** — `codemcp`, `claude-concilium`, `any-cli-mcp-server`
- **Databases** — connector Postgres, MySQL, MongoDB, Redis, SQLite, ClickHouse, Snowflake đều có MCP server OSS
- **Communication** — Slack (Zencoder), Discord, Teams, Telegram, email (IMAP/SMTP)
- **Knowledge & Memory** — `mem0-mcp`, `letta-mcp`, tích hợp vector DB (Pinecone, Weaviate, Chroma)
- **Search** — `brave-search-mcp-server`, `tavily-mcp`, `exa-mcp`, `perplexity-mcp`

**Cách dùng awesome list**: đừng duyệt tuyến tính. Ctrl-F domain vấn đề ("postgres", "kubernetes", "stripe"), pick top 2-3, check star count và ngày commit cuối. **List sắp theo judgment người duy trì chứ không phải star** — tự verify.

## 5. Smithery vs mcp.so — Hai Nền Tảng Registry

Khi awesome list vượt 500 server tháng 1/2026, hai nền tảng registry xuất hiện giải quyết "tôi muốn cài cái này mà không copy-paste config JSON."

### Smithery ([smithery.ai](https://smithery.ai))

- **Mô hình**: Registry + runtime hosted + CLI installer
- **Số server**: ~5,000 curated (nhỏ hơn mcp.so, chuẩn chất lượng cao hơn)
- **Giá**: Liệt kê miễn phí, duyệt miễn phí, cài miễn phí. Server hosted có thể có giá theo usage
- **Tính năng killer**: `npx -y @smithery/cli@latest install <server>` thêm vào config Claude Desktop / Cursor / Continue không cần edit JSON tay
- **Trade-off**: Chưa có monetization cho creator — dev không kiếm được từ server phổ biến

### mcp.so

- **Mô hình**: Registry/directory thuần (catalog lớn nhất)
- **Số server**: **19,700+** (lựa chọn toàn diện — số lượng hơn curation)
- **Giá**: Directory miễn phí
- **Tính năng killer**: Catalog lớn nhất rõ ràng; nếu tồn tại, nó ở đây
- **Trade-off**: Chất lượng curation thấp hơn; bạn phải đánh giá từng entry

### Dùng cái nào

- **Muốn CLI install + curated**: Smithery
- **Muốn long tail**: mcp.so
- **Triển khai production**: Luôn đọc source GitHub trước khi cài — cả hai registry đều link tới repo gốc, verify hoạt động maintainer + open issue + license

## 6. Top MCP Server Theo Category (Tháng 5/2026)

Dựa trên star cộng đồng, độ phủ tích hợp, hoạt động commit gần đây:

**Filesystem & Code**
- `modelcontextprotocol/server-filesystem` (chính thức) — FS sandboxed
- `cyanheads/git-mcp-server` — thao tác Git vượt scope server Git reference
- `tools-mcp/codemap-mcp` — điều hướng code ngữ nghĩa

**Browser & Web**
- `microsoft/playwright-mcp` — tốt nhất cho scenario test E2E + tương tác page phức tạp
- `browsermcp/mcp` — nhẹ, dùng session browser đã đăng nhập
- `tavily-mcp` — kết quả search pre-format cho LLM tiêu thụ

**Database**
- `postgres-mcp-server` — introspection schema + thực thi query an toàn
- `mongodb-mcp` — MongoDB tự bảo trì
- `redis-mcp` — kv + pub/sub cho phối hợp agent

**Memory & Knowledge**
- `mem0-mcp` — lớp memory ngữ nghĩa persistent (link mem0 SaaS)
- `letta-mcp` — framework state agent
- `pinecone-mcp` — vector store

**Cloud Ops**
- `aws-mcp-server` — truy cập API AWS theo scope IAM
- `k8s-mcp-server` — tương đương kubectl + safety guardrails
- `terraform-mcp-server` — plan/apply với cổng xác nhận

**Coding Agents**
- `codemcp` — biến IDE bất kỳ thành MCP host
- `e2b-sandbox-mcp` — thực thi code cloud sandbox (thay Code Interpreter)

## 7. Self-Host vs Cloud-Host MCP Server

Phần lớn MCP server dựa stdio — chạy trên máy bạn. Nhưng công việc khả năng mở rộng transport 2026 nghĩa là server MCP HTTP/SSE giờ khả thi production, mở pattern triển khai cloud-hosted.

### Khi nào self-host

- **Tuân thủ** (healthcare, finance, gov) — data không ra khỏi perimeter
- **Latency** — server gần data (postgres cùng VPC)
- **Chi phí** — loại bỏ phí SaaS per-call ở scale

VPS 4GB thoải mái chạy 10+ MCP server stdio-bridged hoặc HTTP song song. Chúng tôi host cluster MCP nội bộ dibi8 trên {{< aff "htstack" "self-host-vps" "VPS Hong Kong của HTStack" >}} (sub-30ms latency tới Trung Quốc đại lục). Cho triển khai phân tán toàn cầu hoặc fleet lớn, {{< aff "digitalocean" "self-host-k8s" "Kubernetes quản lý của DigitalOcean" >}} với 3 replica là pattern production tiêu chuẩn.

### Khi nào cloud-host (Smithery / e2b / vendor-hosted)

- **Prototype** — hạ tầng 0, cài qua CLI, iterate nhanh
- **Tiện ích stateless** (fetch, search) — không lo locality data
- **Compute-heavy** (sandbox e2b, browser automation) — outsource quản lý VM

## 8. Cách Chọn + Nơi Tự Xây

**Checklist chọn (30 giây mỗi candidate)**:

1. **Star > 500** + **commit cuối < 90 ngày** = project hoạt động (không thì tìm chỗ khác)
2. **Open issue có label "good first issue"** = maintainer kỳ vọng đóng góp (khỏe)
3. **License = MIT/Apache 2.0** = an toàn dùng thương mại
4. **README có snippet `claude_desktop_config.json`** = tác giả test path cài
5. **Verify chữ ký binary** nếu cài từ npm/PyPI — tấn công chuỗi cung qua MCP server là vector mối đe dọa 2026 thực

**Nếu không có gì phù hợp**: tự viết. SDK TypeScript và Python cho phép bạn ship MCP server hoạt động trong ~50 dòng. Team Anthropic chủ đích giữ protocol mỏng để xây server không có ma sát.

Walkthrough "tự xây MCP server" đầy đủ — bao gồm setup transport stdio, implementation tools/resources/prompts, debug Claude Desktop — xem [hướng dẫn MCP chuyên sâu phiên bản chính 2026](/vi/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) của chúng tôi.

## TL;DR

Hệ sinh thái MCP server 2026 có 4 layer đáng biết:

1. **7 server reference Anthropic** — đường cơ sở (Filesystem + Fetch + Memory tối thiểu)
2. **awesome-mcp-servers (87.3k star)** — index cộng đồng kinh điển, duyệt theo category
3. **Smithery + mcp.so** — nền tảng registry (Smithery cho CLI install, mcp.so cho độ rộng)
4. **Self-host vs cloud-host** — tuân thủ/latency thiên self-host; prototype/compute-heavy thiên cloud

Phần khó không còn là tìm server. Mà là **chọn đúng cái** — dùng checklist 30 giây mục 8 và cây khám phá mục 2. Nếu không có gì phù hợp, tự viết trong một buổi chiều (50 dòng TS hoặc Python).

---

*Muốn self-host 5+ MCP server (postgres + filesystem + git + memory + tavily-search) mà không đốt bill cloud? Bật một {{< aff "digitalocean" "footer-cta" "DigitalOcean droplet" >}} $6/tháng, chạy chúng dưới một supervisor duy nhất (systemd hoặc PM2), và trỏ `claude_desktop_config.json` của Claude Desktop vào host. Xong trong một buổi chiều.*
