---
title: 'Workflow AI Coding Self-Host: Stack Hoàn Chỉnh $6/Tháng Cho 2026'
description: 'Stack AI coding self-host 7 thành phần thay thế $290/tháng đăng ký SaaS (Cursor + Claude Code Pro + Copilot + Replit) bằng $6/tháng hạ tầng. Số liệu thực, config thực, hướng dẫn lắp ráp từng bước đầy đủ.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Docker
  - Python
  - TypeScript
  - PostgreSQL
application_domain: Collections
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['collections']
tags: ['Self-Host', 'AI Coding', 'Stack', 'Workflow', 'Collection']
aliases:
  - /posts/self-hosted-ai-coding-workflow/
---

Nếu bạn đang trả $20/tháng cho Cursor + $80/tháng cho Claude Code Pro + $19/tháng cho Copilot + $50/tháng cho Replit credits + $120/tháng cho OpenAI API top-up, chi tiêu AI coding hàng tháng của bạn là **$289/tháng**. 12 tháng là **$3,468** — cho công cụ bạn không sở hữu, không audit được, có thể bị rate-limit hoặc tắt mà không báo trước.

Bộ sưu tập này lắp ráp **giải pháp self-host 7 thành phần** chạy trên **VPS $6/tháng** và match 90%+ tính năng SaaS. Chúng tôi đã xuất bản hướng dẫn sâu cho từng thành phần trong 90 ngày qua. Trang này là **hướng dẫn lắp ráp stack hoàn chỉnh** — cài gì, theo thứ tự nào, với config nào, cộng đường nâng cấp khi vượt tier $6.

## TL;DR — Stack Một Cái Nhìn

| # | Thành phần | Công cụ | Vì sao | Hướng dẫn sâu |
|---|---|---|---|---|
| 1 | Editor / Agent | **OpenCode** | Mã nguồn mở thay Claude Code, DeepSeek-V4 chạy $0.007/task vs $0.14 | [OpenCode setup](/vi/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) |
| 2 | Local LLM Runner | **Ollama** | 137k star, cài 1 dòng, 22 tok/sec trên M1 5 tuổi | [Hướng dẫn Ollama](/vi/resources/llm-frameworks/ollama/) |
| 3 | LLM Gateway | **LiteLLM** | 47.8k star, API thống nhất cho 100+ model, self-host | [LiteLLM gateway](/vi/resources/llm-frameworks/litellm/) |
| 4 | Proxy Tiết Kiệm Token | **9Router** | RTK nén cắt token coding agent 20-40% | [9Router setup](/vi/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |
| 5 | Lớp Memory | **mem0 + AgentMemory MCP** | Memory ngữ nghĩa bền vững qua session | [AgentMemory MCP](/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) |
| 6 | Code Context MCP | **filesystem + git + tavily search** | Anthropic reference + cộng đồng + tìm kiếm | [MCP server registry](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) |
| 7 | Multi-CLI Switcher | **CC Switch** | 1-click giữa Claude / Codex / Gemini CLI / OpenCode | [Hướng dẫn CC Switch](/vi/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) |

**Tổng chi phí hàng tháng** (VPS 4GB + lưu trữ): tier khởi đầu **$6**. tier "team 5 người" + Postgres + Redis + LiteLLM nhiều replica khoảng **~$30/tháng**.

## 1. Vì Sao Stack Này Khả Thi Năm 2026

Ba điều thay đổi giữa 2024 và 2026 làm AI coding self-host cuối cùng khả thi:

1. **Model open-weight đuổi kịp**: DeepSeek-V4, Qwen 3 Coder, GLM-4.6 Coder trong 5% so với Claude/GPT-5 ở benchmark coding, miễn phí hoặc gần miễn phí
2. **MCP chuẩn hóa tích hợp công cụ**: thay vì mỗi editor tự phát minh cách gọi file/git/search tool, protocol giờ là cổng USB-C — xem [hướng dẫn MCP Server Registry](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) cho 19,700+ server hiện có
3. **Local LLM runner sẵn sàng production**: Ollama, vLLM, llama.cpp chạy ở tốc độ chấp nhận được trên phần cứng tiêu dùng

2024 toán học cũng đúng, nhưng trải nghiệm đau đớn. 2026 khoảng cách thu hẹp.

## 2. Tổng Quan Kiến Trúc

```
                  ┌─────────────────────────────┐
                  │   Máy bạn / VPS ($6)        │
                  │                             │
   Bạn gõ  →      │  OpenCode (editor/agent)    │
                  │           │                 │
                  │           ▼                 │
                  │  CC Switch (CLI 1-click)    │
                  │           │                 │
                  │           ▼                 │
                  │  LiteLLM Gateway :4000      │
                  │           │                 │
                  │     ┌─────┴─────┐           │
                  │     │           │           │
                  │     ▼           ▼           │
                  │  9Router    Direct          │
                  │  (RTK nén)   (premium)     │
                  │     │           │           │
                  └─────┼───────────┼───────────┘
                        │           │
              ┌─────────┴───┐  ┌────┴──────┐
              ▼             ▼  ▼           ▼
          Ollama       DeepSeek API   Claude API
          (local)      (suy luận rẻ) (premium)

      MCP servers (filesystem + git + memory + tavily-search)
      gắn vào OpenCode qua claude_desktop_config.json
```

Pattern: **OpenCode là não editor, LiteLLM là cảnh sát giao thông, 9Router nén, MCP servers expose thế giới.** Hoán đổi thành phần bất kỳ không động vào cái khác.

## 3. Thành Phần 1 — OpenCode (Editor / Agent)

**Vai trò**: Cái bạn thực sự gõ vào. Thay Cursor + Claude Code Pro.

**Vì sao chọn**: Agent mã nguồn mở nói MCP native. Trên cùng task refactor (component React 400 dòng), OpenCode + DeepSeek-V4 = 18 giây, $0.007. Claude Code (Sonnet) = 12 giây, $0.14. Rẻ 20×, chậm 5%.

**Cài nhanh**:
```bash
npm install -g @opencode-ai/opencode
opencode --version  # 1.x
```

Trỏ nó vào LiteLLM gateway (thành phần tiếp) qua config là xong.

**Setup đầy đủ** bao gồm rule routing provider, kết nối MCP server, tích hợp editor — xem [hướng dẫn OpenCode đầy đủ](/vi/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/).

## 4. Thành Phần 2 — Ollama (Local LLM Runner)

**Vai trò**: Chạy model nhỏ hoàn toàn trên phần cứng của bạn. Tùy chọn 100% offline cho code nhạy cảm.

**Vì sao chọn**: 137k star. Cài single-binary. Llama 3.2 3B chạy 22 tok/sec trên M1 MacBook 5 tuổi 8GB RAM. Qwen 3 Coder 14B chạy thoải mái trên Mac M-series 16GB hoặc bất kỳ Linux 32GB nào.

**Cài nhanh**:
```bash
curl -fsSL https://ollama.com/install.sh | sh
ollama pull qwen3-coder:14b
ollama serve  # expose :11434 API tương thích OpenAI
```

LiteLLM tự pick Ollama làm provider.

**Setup đầy đủ** với chọn model theo tier phần cứng và trade-off quantization — xem [hướng dẫn Ollama production](/vi/resources/llm-frameworks/ollama/).

## 5. Thành Phần 3 — LiteLLM (Gateway Thống Nhất)

**Vai trò**: Một API tương thích OpenAI đứng trước mọi model — Ollama (local), DeepSeek (rẻ), Claude (premium), Gemini (tier miễn phí). Editor chỉ nói chuyện với LiteLLM; LiteLLM route theo config của bạn.

**Vì sao chọn**: 47.8k star, gateway LLM nhiều star nhất. Latency P95 8ms ở 1k RPS. Miễn phí nếu self-host. So sánh chi tiết trong [hướng dẫn Portkey vs LiteLLM vs OpenRouter 2026](/vi/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/).

**Triển khai nhanh trên VPS 4GB** (đề xuất {{< aff "htstack" "stack-vps" "VPS Hong Kong của HTStack" >}} cho sub-30ms latency tới user Trung Quốc đại lục, hoặc {{< aff "digitalocean" "stack-droplet" "droplet DigitalOcean $6" >}} cho nơi khác):

```bash
docker run -d --name litellm -p 4000:4000 \
  -e LITELLM_MASTER_KEY=sk-your-secret \
  -e OLLAMA_API_BASE=http://host.docker.internal:11434 \
  -e DEEPSEEK_API_KEY=$DEEPSEEK_KEY \
  -e ANTHROPIC_API_KEY=$CLAUDE_KEY \
  ghcr.io/berriai/litellm:main-stable
```

**Setup đầy đủ** với virtual key, theo dõi chi tiêu, rule fallback — xem [LiteLLM production gateway 2026](/vi/resources/llm-frameworks/litellm/).

## 6. Thành Phần 4 — 9Router (Proxy Tiết Kiệm Token)

**Vai trò**: Ngồi giữa LiteLLM và provider "premium" của bạn (Claude / GPT-5). Nén nội dung lặp (file header, system prompt, codebase context) trước khi gửi. **Cắt token có phí 20-40% cho coding agent.**

**Vì sao điều này quan trọng**: Coding agent là kẻ tiêu thụ token bệnh hoạn — gửi toàn bộ codebase context mỗi turn. Ở $3/M input token trên Claude Sonnet, cộng dồn nhanh. RTK (Repetition-Token Compression) của 9Router là proxy duy nhất thiết kế đặc biệt cho workload này.

**Cài nhanh**:
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=anthropic,openai,gemini,deepseek \
  ghcr.io/rtk-ai/9router:latest
```

Trỏ endpoint premium provider của LiteLLM tới `localhost:9999` thay vì direct.

**Setup đầy đủ**: [hướng dẫn 9Router smart proxy](/vi/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/).

## 7. Thành Phần 5 — Memory Layer (mem0 + AgentMemory MCP)

**Vai trò**: Memory ngữ nghĩa bền vững qua session coding. "Nhớ là chúng ta dùng Tailwind v4 và auth ở `src/lib/auth.ts`" — và agent thực sự nhớ thứ Hai tuần sau.

**Vì sao chọn**: mem0 là layer memory ngữ nghĩa mã nguồn mở 30k+ star. AgentMemory là MCP server expose nó tới bất kỳ MCP host nào (OpenCode / Claude Desktop / Cursor).

**Cài nhanh**:
```bash
npm install -g @mem0/mem0-mcp
# Thêm vào MCP config của OpenCode:
# { "agentmemory": { "command": "mem0-mcp", "args": [] } }
```

**Setup đầy đủ** với chọn model embedding và lựa chọn vector DB — xem [hướng dẫn AgentMemory MCP](/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/).

## 8. Thành Phần 6 — Code Context MCP (filesystem + git + tavily-search)

**Vai trò**: Cho agent mắt và tay. Đọc file project, kiểm tra lịch sử git, tìm web — tất cả qua protocol MCP.

**Bộ tối thiểu**:
- `modelcontextprotocol/server-filesystem` (Anthropic reference)
- `modelcontextprotocol/server-git` (Anthropic reference)
- `tavily-mcp` (kết quả tìm kiếm web đã format cho LLM)

**Cài nhanh** (cả 3 thêm vào `claude_desktop_config.json` của OpenCode):
```json
{
  "mcpServers": {
    "filesystem": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-filesystem", "/home/user/projects"]
    },
    "git": {
      "command": "uvx",
      "args": ["mcp-server-git", "--repository", "/home/user/projects/your-repo"]
    },
    "tavily": {
      "command": "npx",
      "args": ["-y", "@tavily/mcp"],
      "env": {"TAVILY_API_KEY": "tvly-xxx"}
    }
  }
}
```

Tavily có tier miễn phí hào phóng (1,000 lượt tìm/tháng) đủ trong ngân sách $6.

**Menu đầy đủ 19,700+ MCP server có sẵn và cách chọn thêm**: xem [hướng dẫn MCP Server Registry toàn diện 2026](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/).

## 9. Thành Phần 7 — CC Switch (Multi-CLI Orchestrator)

**Vai trò**: Khi bạn muốn dùng Claude Code native (không qua OpenCode) cho task cụ thể — hoặc nhảy sang Codex cho tốc độ Rust — CC Switch là swap 1-click. Một config, tất cả AI CLI chia sẻ MCP server.

**Vì sao chọn**: App desktop Rust + Tauri 75k star nghĩa là bạn ngừng duy trì 5 file `~/.claude_desktop_config.json` riêng cho 5 CLI khác nhau.

**Cài nhanh**: Tải từ [farion1231/cc-switch releases](https://github.com/farion1231/cc-switch/releases). Cấu hình từng CLI với một click.

**Hướng dẫn đầy đủ**: [CC Switch unified AI CLI control center](/vi/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/).

## 10. Thứ Tự Lắp Ráp — Setup Day 1 (90 phút)

Nếu bắt đầu từ đầu, làm theo thứ tự này:

1. **Khởi động hạ tầng** (15 phút) — Đặt {{< aff "digitalocean" "assembly-vps" "droplet DigitalOcean $6" >}}, cài Docker, mở port 4000 (LiteLLM) + 9999 (9Router) + 11434 (Ollama)
2. **Ollama trước** (10 phút) — Cài + pull `qwen3-coder:14b` (~9 GB). Xác nhận `curl localhost:11434/api/tags` hoạt động
3. **LiteLLM thứ hai** (15 phút) — Docker run với env vars từ sec. 5. Xác nhận `curl localhost:4000/v1/models -H "Authorization: Bearer sk-your-secret"` liệt kê model Ollama
4. **9Router thứ ba** (10 phút) — Tùy chọn nhưng khuyến nghị. Thêm vào config premium provider của LiteLLM
5. **OpenCode thứ tư** (15 phút) — Cài local, trỏ vào LiteLLM tại `https://your-vps:4000/v1`, test prompt cơ bản
6. **MCP servers thứ năm** (15 phút) — filesystem + git + tavily thêm vào config OpenCode. Test bằng cách hỏi "liệt kê file trong repo này"
7. **mem0 + AgentMemory thứ sáu** (10 phút) — `npm i -g mem0-mcp`, thêm vào config, test bằng cách nói "nhớ là chúng ta dùng Tailwind v4"
8. **CC Switch cuối** (tùy chọn) — Chỉ khi muốn Claude Code / Codex native song song

Bạn giờ có stack AI coding $6/tháng match 90% bundle SaaS $289/tháng.

## 11. Phân Tích Chi Phí Hàng Tháng

| Mục | Tier khởi đầu | Tier team 5 người |
|---|---|---|
| VPS (4 GB → 16 GB) | $6 | $24 |
| Model Ollama | $0 (bạn sở hữu đĩa) | $0 |
| LiteLLM | $0 (self-host) | $0 |
| 9Router | $0 (self-host) | $0 |
| Tavily search | $0 (1k req miễn phí) | $5 (có phí) |
| mem0 / AgentMemory | $0 (self-host) | $0 |
| DeepSeek API (suy luận rẻ task khó) | ~$2-5 | ~$10-15 |
| Claude API (hiếm, fallback premium) | ~$1-3 | ~$5-10 |
| **Tổng** | **~$6-14** | **~$30-50** |

So với $289/tháng cho Cursor + Claude Code Pro + Copilot + Replit + OpenAI top-up.

## 12. Đường Nâng Cấp

Khi stack vượt tier $6 (hơn 1 dev, hơn 1 project, state bền vững quan trọng):

- **Thêm Postgres** cho LiteLLM theo dõi chi tiêu + virtual key per project ({{< aff "digitalocean" "upgrade-postgres" "DigitalOcean Managed Postgres" >}} $15/tháng)
- **Thêm Redis** cho LiteLLM caching (1 GB managed Redis $10/tháng)
- **Di chuyển LiteLLM sau load balancer** với 3 replica — xem [hướng dẫn Portkey vs LiteLLM 2026](/vi/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) sec. 4 cho pattern Kubernetes
- **Thêm Grafana + Loki** cho observability đầy đủ — log mọi prompt, mọi fallback, mọi cost spike
- **Thêm RBAC level team** qua LiteLLM enterprise tier (giá custom)

Điểm chính: bạn bắt đầu với $6/tháng và *sở hữu toàn bộ stack*. Mọi nâng cấp là quyết định chi phí có chủ đích gắn với nhu cầu cụ thể — không phải bẫy SaaS lock-in.

## TL;DR — Recipe 7 Thành Phần

1. **OpenCode** — não editor
2. **Ollama** — fallback local
3. **LiteLLM** — gateway thống nhất
4. **9Router** — nén token
5. **mem0 + AgentMemory** — memory bền vững
6. **MCP servers** (filesystem + git + tavily) — context + tool
7. **CC Switch** — orchestration multi-CLI

Tổng: $6/tháng. Tổng: 90 phút lắp ráp. Tổng: vendor lock-in 0.

Nếu bạn tiêu $200+/tháng cho AI coding SaaS, stack này lấy lại vốn trong tuần 1. Khởi động {{< aff "digitalocean" "footer-cta" "droplet DigitalOcean $6" >}}, làm theo sec. 10, báo lại tuần sau.

---

*Đánh dấu trang này — chúng tôi cập nhật lựa chọn thành phần hàng quý khi có bản release mã nguồn mở mới. Cập nhật cuối: 2026-05-21.*
