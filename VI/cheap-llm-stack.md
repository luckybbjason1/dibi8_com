---
title: 'Stack LLM Giá Rẻ 2026: Chạy AI Production $0-15/Tháng Bằng Free Tier + Nén Token'
description: 'Stack 5 thành phần chạy workload AI thực tế $0-15/tháng: Ollama local + DeepSeek API + Gemini free tier + nén RTK + orchestration 9Router. Toán chi phí thực, lựa model theo loại task, thứ tự lắp ráp.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - Docker
  - Go
  - Rust
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
tags: ['LLM Rẻ', 'Free Tier', 'Tối ưu chi phí', 'Stack', 'Collection']
aliases:
  - /posts/cheap-llm-stack/
---

Hầu hết lời khuyên "tối ưu chi phí LLM" chỉ là "dùng model rẻ hơn." Bộ sưu tập này tham vọng hơn: **stack 5 thành phần xử lý workload production thực tế (coding agent, sinh content, search, agent cơ bản) tổng $0-15/tháng.** Không phải setup chơi. Không phải "ổn cho 100 request/ngày." Suy luận daily-driver thực sự ở giá giết SaaS.

Bí quyết không phải công cụ đơn lẻ — mà là orchestration. Free tier cap request, không cap output. Model local cap chất lượng, không cap request. Nén token cắt chi tiêu có phí. Routing thông minh gửi mỗi task tới provider rẻ nhất đủ năng lực. Kết hợp, toán học trở nên buồn cười.

## TL;DR — Stack Một Cái Nhìn

| # | Thành phần | Chi phí | Vai trò | Hướng dẫn sâu |
|---|---|---|---|---|
| 1 | **Ollama** (local) | $0 | Workload nặng/nhạy cảm trên phần cứng bạn | [Hướng dẫn Ollama](/vi/resources/llm-frameworks/ollama/) |
| 2 | **DeepSeek API** | $2-8/tháng | Suy luận rẻ cho task khó ($0.27/M input vs Claude $3) | [DeepSeek vs OpenAI](/vi/resources/llm-frameworks/deepseek-ds4-vs-openai-api/) |
| 3 | **Gemini CLI free tier** | $0 | 1,000 req/ngày cho task LLM chung, miễn phí | [Công cụ AI Search](/vi/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/) |
| 4 | **Proxy RTK** | $0 (self-host) | Nén prompt 20-40% trước khi đi API có phí | [Setup RTK](/vi/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/) |
| 5 | **9Router** | $0 (self-host) | Auto-route mỗi task tới provider rẻ nhất đủ năng lực | [Hướng dẫn 9Router](/vi/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/) |

**Tổng chi phí tháng** (nhẹ: 100 calls/ngày): **$0-3** • **Trung** (500 calls/ngày): **$2-8** • **Nặng** (2000 calls/ngày): **$5-15**

So với pure API cùng volume: $40 / $200 / $800 tương ứng. **Giảm 20-50× chi phí ở quy mô production**.

## 1. Vì Sao "Rẻ" Khả Thi Năm 2026

Ba điều thay đổi trong 12 tháng qua:

1. **DeepSeek-V4 đạt chất lượng Claude Sonnet với 1/10 giá** ($0.27/M vs $3/M input). Cho 80% task khoảng cách chất lượng không quan trọng
2. **Free tier nghiêm túc**: Gemini cho 1,000 request free/ngày, GLM-4.6 ra free tier, OpenRouter rotate model free tài trợ cộng đồng. Ngân sách kết hợp ~3,000 free call/ngày
3. **RTK (Repetition-Token Compression) hoạt động**: loại bỏ 20-40% token thuần dư thừa (file header, system prompt lặp 10× mỗi session)

Stack ba cái — fallback local + API rẻ + xoay free tier + nén — biên giới rẻ-chất-lượng dịch chuyển đáng kể.

## 2. Kiến Trúc — Pattern Smart Router

```
   App bạn
       │
       ▼
   9Router (quyết mỗi call đi đâu)
       │
       ├─► Ollama Local         (nhạy cảm / offline / draft)
       │
       ├─► Proxy RTK → DeepSeek (task khó cần chất lượng, nén)
       │
       ├─► Gemini free tier     (1k req/ngày, task dễ)
       │
       └─► OpenRouter free      (model cộng đồng rotation, thử nghiệm)
```

Mỗi provider có "vùng chuyên môn." 9Router (hoặc wrapper Python 10 dòng nếu không muốn thêm service) kiểm tra task rồi route.

## 3. Thành Phần 1 — Ollama (Local, $0)

**Vai trò**: Bất cứ gì nhạy cảm, không muốn bị tính phí, chất lượng draft.

**Thực tế trên phần cứng tiêu dùng** (số liệu 2026):
- **8 GB RAM** (M1 / PC tầm trung): Llama 3.2 3B ở 20+ tok/s — ổn cho autocomplete, phân loại, viết draft
- **16 GB RAM** (M2/M3 / PC khá): Qwen 3 Coder 14B ở 15 tok/s — coding production
- **32 GB RAM** (Mac Studio / workstation): Llama 3.3 70B Q4 ở 8 tok/s — chất lượng Claude Sonnet, cho người kiên nhẫn

**Miễn phí, mãi mãi, không rate limit**. Chi phí duy nhất là điện chạy máy.

Cài đặt đầy đủ + lựa model: [Hướng dẫn Ollama production](/vi/resources/llm-frameworks/ollama/).

## 4. Thành Phần 2 — DeepSeek API ($2-8/Tháng)

**Vai trò**: Khi local không đủ tốt, đây là provider trả phí mặc định.

**Vì sao đánh bại mọi người về giá/chất lượng**:
- DeepSeek-V4 input $0.27/M token vs Claude Sonnet $3/M vs GPT-5 $2.50/M
- Khoảng cách benchmark code với Claude Sonnet: ~5% trung bình
- Off-peak giảm thêm 50% (UTC 16:30-00:30)

**Trade-off thành thật**: Ảo giác nhiều hơn chút trên chủ đề niche. Cold start chậm chút. Đáng cho tiết kiệm 11× ở suy luận bulk.

**Bắt đầu nhanh** — đăng ký platform.deepseek.com, $10 credit cho solo dev 2-3 tháng.

Setup đầy đủ + khi nào *không* dùng DeepSeek: [So sánh DeepSeek-V4 vs OpenAI API](/vi/resources/llm-frameworks/deepseek-ds4-vs-openai-api/).

## 5. Thành Phần 3 — Gemini CLI Free Tier ($0)

**Vai trò**: 1,000 request/ngày miễn phí cho task chung (Q&A, tóm tắt, coding đơn giản).

**Toán**: 1,000 call/ngày × 30 ngày = 30,000 call/tháng miễn phí. Hết trước nửa đêm UTC, fallback DeepSeek cho phần còn lại.

**Lưu ý**: Google log prompt cho "cải thiện model" ở free tier — đừng gửi code độc quyền hoặc PII.

**Cài nhanh**:
```bash
npm install -g @google/gemini-cli
gemini auth login  # mở trình duyệt, dùng tài khoản Google
gemini "giải thích regex này: /^[a-z]+$/i"
```

Hoặc gọi trực tiếp endpoint Gemini REST — cùng ngân sách 1,000/ngày.

Tổng quan đi kèm về Gemini vs Perplexity vs ChatGPT free tier và mỗi cái mạnh ở đâu: [So sánh công cụ AI Search](/vi/resources/ai-tools/ai-search-tools-perplexity-gemini-chatgpt/).

## 6. Thành Phần 4 — Proxy RTK ($0, Self-Host)

**Vai trò**: Ngồi giữa app và bất kỳ API trả phí nào. Nén nội dung lặp (system prompt, file header, snippet doc) trước mỗi call. **Hóa đơn ít 20-40% mà không đổi code.**

**Cơ chế**: Dedup ngữ nghĩa. Nếu bạn gửi cùng system prompt 2,000 token 50 lần hôm nay, RTK nhận biết từ call #2 và gửi pointer thay vì full text.

**Cài nhanh**:
```bash
docker run -d --name rtk -p 8765:8765 \
  ghcr.io/rtk-ai/rtk:latest
```

Sau đó đổi API base URL từ `https://api.deepseek.com/v1` thành `http://localhost:8765/v1/deepseek`. Xong.

Đào sâu cách RTK hoạt động + benchmark: [Proxy RTK Rust CLI + token saver](/vi/resources/llm-frameworks/rtk-rust-cli-proxy-ai-token-saver/).

## 7. Thành Phần 5 — 9Router ($0, Self-Host)

**Vai trò**: Orchestrator. Quyết provider nào nhận mỗi call dựa trên loại task, ngân sách còn lại, sẵn có của provider.

**Vì sao cần**: Không có 9Router bạn phải pick provider thủ công mỗi call. Có 9Router bạn set rule một lần ("task coding → DeepSeek via RTK, Q&A đơn giản → Gemini free, fallback → Ollama") rồi quên.

**Bonus**: 9Router gồm layer nén RTK riêng cho premium provider, cộng auto-fallback khi free tier đụng cap hàng ngày.

**Cài nhanh**:
```bash
docker run -d --name 9router -p 9999:9999 \
  -e PROVIDERS=ollama,deepseek,gemini,openrouter \
  ghcr.io/rtk-ai/9router:latest
```

Cấu hình đầy đủ + công thức combo coding free tier: [Hướng dẫn 9Router smart proxy](/vi/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/).

## 8. Bảng Routing — Ai Xử Lý Cái Gì

Config routing mặc định khả thi cho solo dev:

| Loại task | Provider | Vì sao |
|---|---|---|
| Inline code completion | **Ollama** (Qwen 3 Coder 14B local) | Latency quan trọng hơn chất lượng |
| Code generation (scope hàm) | **DeepSeek-V4 via RTK** | Chất lượng quan trọng, nén tiết kiệm |
| Refactor nhiều file | **DeepSeek-V4 via RTK** hoặc **Claude** fallback | Task khó, fallback premium nếu DeepSeek bí |
| Q&A chung / giải thích code | **Gemini free tier** | Free, nhanh, đủ tốt |
| Web search + trích dẫn | **Gemini free tier** (grounding built-in) | Free vs $20/tháng Perplexity Pro |
| Code review nhạy cảm | **Ollama** local | Không bao giờ rời máy bạn |
| Sinh content bulk (1000+ bài) | **DeepSeek-V4 off-peak** | Rẻ × off-peak giảm 50% = $0.135/M |
| Agent đơn giản (Slack bot, scheduler) | **Gemini free tier** | Task dễ, 1k/ngày dư |

## 9. Toán $0-15/Tháng

**Dùng nhẹ** (solo dev, trung bình 100 calls/ngày):
- Gemini free phủ ~70% calls → $0
- DeepSeek cho 30% còn lại (~900 calls/tháng, chủ yếu nhỏ) → $1-3
- Ollama cho nhạy cảm (không API cost) → $0
- **Tổng: $1-3/tháng** (so với pure API $40+)

**Dùng trung bình** (500 calls/ngày, gồm coding):
- Gemini free: vẫn còn ~1000 calls/ngày
- DeepSeek cho coding nghiêm túc: ~3000 calls/tháng với nén RTK → $3-8
- Ollama fallback → $0
- **Tổng: $3-8/tháng** (so với pure API $200+)

**Dùng nặng** (2000 calls/ngày, workflow agent):
- Gemini cạn 10am, fallback kicks in
- DeepSeek tải nặng, RTK giảm ~30% → $5-12
- Job batch off-peak → giảm thêm 50%
- Ollama xử lý phân loại bulk, nhạy cảm → $0
- **Tổng: $5-15/tháng** (so với pure API $800+)

## 10. Thứ Tự Setup Day 1 (60 phút)

1. **Ollama** (15 phút) — Cài, pull Llama 3.2 3B + Qwen 3 Coder 14B
2. **Tài khoản DeepSeek** (5 phút) — Đăng ký, nhận API key, nạp $10
3. **Gemini CLI** (5 phút) — `npm i -g @google/gemini-cli`, auth Google
4. **Proxy RTK** (10 phút) — Docker run, trỏ DeepSeek
5. **9Router** (10 phút) — Docker run, cấu hình 4 provider
6. **Test routing** (15 phút) — Gửi 5 loại task khác nhau, xác minh mỗi cái đi đúng provider

Sau 60 phút bạn có router LLM rẻ cấp production thực sự trên máy mình.

## 11. Khi Nào Upgrade (và lên gì)

Stack $0-15 hoạt động đến khi đụng bất kỳ điều nào:

- **Yêu cầu latency < 500ms** — Thêm Claude/GPT-5 cho hot path (vẫn giữ DeepSeek cho batch)
- **Tuân thủ yêu cầu provider chỉ dữ liệu Mỹ** — Bỏ DeepSeek + Gemini, dùng OpenRouter với provider filtering hoặc self-host thêm
- **Workload bulk yêu cầu SLA** — Thêm gateway LiteLLM managed với nhiều provider trả phí + logic retry ([LiteLLM gateway 2026](/vi/resources/llm-frameworks/litellm/) xem)
- **Muốn observability đầy đủ** — Thêm Portkey ($49 phí platform ở $1k chi tiêu, [Portkey vs LiteLLM 2026](/vi/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) xem)

Điểm chính: stack này *không* phải trần. Là sàn — cho phép scale chi tiêu có chủ đích thay vì bị ép vào bundle SaaS $200/tháng từ ngày đầu.

## TL;DR — Recipe

**5 công cụ, $0-15/tháng, setup 60 phút**:
1. **Ollama** — local & nhạy cảm
2. **DeepSeek-V4** — API rẻ cho task khó
3. **Gemini CLI free tier** — 1k req/ngày free LLM chung
4. **Proxy RTK** — tiết kiệm 20-40% token trên API có phí
5. **9Router** — orchestrator routing thông minh

Stack tự hoàn vốn nếu bạn hiện tiêu $30+/tháng cho AI SaaS bất kỳ. Chạy trên laptop được (LLM rẻ không cần VPS cụ thể — nhưng {{< aff "digitalocean" "footer-cta" "droplet DigitalOcean $6/tháng" >}} giúp nếu muốn always-on cho team).

---

*Ghép bộ sưu tập này với [Workflow AI Coding Self-Host](/vi/collections/self-hosted-ai-coding-workflow/) cho stack coding đầy đủ — chúng chia sẻ Ollama + 9Router + RTK làm nền tảng.*
