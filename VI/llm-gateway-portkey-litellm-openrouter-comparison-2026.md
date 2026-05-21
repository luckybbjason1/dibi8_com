---
title: 'Portkey vs LiteLLM vs OpenRouter 2026: Hướng Dẫn Chọn LLM Gateway Thành Thật (Độ Trễ, Chi Phí, Tự Host)'
description: 'So sánh trực tiếp 3 LLM gateway lớn nhất năm 2026. Số liệu thực: Portkey thêm <1ms độ trễ, LiteLLM 8ms P95, OpenRouter 100-150ms. Cây quyết định 30 giây theo use case, phân tích chi phí $1000/tháng, và khi nào 9Router đè bẹp cả ba.'
date: 2026-05-20 00:00:00+08:00
lastmod: 2026-05-20 00:00:00+08:00
tech_stack:
  - Python
  - TypeScript
  - Docker
  - Kubernetes
application_domain: Llm Frameworks
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
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['LLM Gateway', 'Portkey', 'LiteLLM', 'OpenRouter', 'So sánh']
aliases:
  - /posts/llm-gateway-portkey-litellm-openrouter-comparison-2026/
---

Đọc 3 bài blog về "LLM gateway tốt nhất" bạn sẽ có 3 câu trả lời khác nhau và 0 con số để so sánh. Bài này giải quyết vấn đề đó. Đây là cuộc đối đầu trực diện giữa **Portkey**, **LiteLLM**, và **OpenRouter** — ba gateway thực sự đang chạy traffic AI production năm 2026 — với số liệu độ trễ thực tế, phân tích chi phí ở mức $1,000/tháng, và cây quyết định bạn có thể áp dụng trong 30 giây.

Nếu chỉ có 60 giây, đọc bảng ở mục 2 và chọn theo dòng phù hợp với bạn. Phần còn lại dành cho lúc CFO hỏi "tại sao chọn cái này?"

## 1. Vì Sao Bạn Cần LLM Gateway

Ba lý do ứng dụng "vượt qua" SDK trực tiếp của provider sau khoảng 3 tháng:

1. **Đau khổ vendor lock-in** — code của bạn có hình dạng OpenAI và Claude 4.7 vừa ra mắt. Giờ sao?
2. **Độ tin cậy** — mỗi provider có SLA 99.5%. Chạy ba song song không failover thì bạn cộng dồn lỗi, không phải cộng dồn dự phòng.
3. **Chi phí & quan sát** — team tài chính muốn theo dõi chi tiêu theo team. SDK không làm được.

LLM gateway ngồi giữa app và N provider, expose một API thống nhất (gần như luôn tương thích OpenAI), xử lý retry, failover, cache, rate limit, và log chi tiêu. Chọn sai, bạn ăn thêm 100ms+ mỗi request. Chọn đúng, bạn quên luôn nó tồn tại.

## 2. Cây Quyết Định 30 Giây

| Tình huống của bạn | Chọn |
|---|---|
| Doanh nghiệp, nặng tuân thủ, cần SOC2/HIPAA | **Portkey** |
| Ưu tiên tự host, không markup từ vendor, có team hạ tầng | **LiteLLM** |
| Dev solo / startup, muốn truy cập tức thì 300+ model | **OpenRouter** |
| Coding agent workflow, chi phí token áp đảo | **9Router** (xem mục 8) |
| Bạn muốn cả ba thứ trên | Stack chúng — LiteLLM phía trước, OpenRouter là một trong các provider của nó, Portkey bọc ngoài cho observability |

Phần còn lại của bài biện minh cho từng ô trong bảng trên.

## 3. Portkey: Gateway Cấp Doanh Nghiệp

**Lời chào**: Một control plane cho 1,600+ LLM với độ trễ gateway <1ms và 50+ guardrail tích hợp. SOC2, HIPAA, GDPR, CCPA tuân thủ ngay từ đầu.

**Số liệu thực**:

- **GitHub stars**: 11.8k (license MIT, lõi mã nguồn mở)
- **Độ trễ gateway**: Thêm <1ms (footprint runtime 122kb)
- **Giá**: Mã nguồn mở miễn phí. Phí cloud platform ≈ $49/tháng ở mức $1K/tháng chi tiêu API
- **Tuân thủ**: SOC2 Type II, HIPAA, GDPR, CCPA
- **Tính năng nổi bật**: Cache ngữ nghĩa (không chỉ key-based), 50+ AI guardrail, sản phẩm MCP Gateway riêng, tích hợp native với Autogen/CrewAI/LangChain/Phidata

**Khi nào Portkey thắng**: Bạn đẩy AI vào ngành được quản lý (health, finance, gov) và cần câu chuyện observability + guardrail có thể audit. Hoặc bạn đã xây trên Autogen/CrewAI và muốn một file config điều khiển routing, cache, và limit trên mọi agent.

**Khi nào không**: Team 2 người chỉ muốn gọi Claude *và* GPT-5 mà không viết 2 SDK. Quá dư thừa.

Hướng dẫn sâu Portkey đầy đủ — triển khai production, cấu hình guardrail, tour dashboard observability — xem [thiết lập production Portkey AI Gateway 2026](/vi/resources/llm-frameworks/portkey-ai-gateway-production/) của chúng tôi.

## 4. LiteLLM: Tiêu Chuẩn Tự Host

**Lời chào**: Một proxy server mã nguồn mở expose 100+ LLM provider sau một API tương thích OpenAI. Tự host, không markup từ vendor.

**Số liệu thực**:

- **GitHub stars**: 47.8k (nhiều nhất trong 3, bỏ xa các đối thủ)
- **Độ trễ gateway**: 8ms P95 ở 1,000 RPS (benchmark công khai) — thực tế proxy thêm 10–20ms
- **Giá**: Miễn phí nếu tự host. Tier doanh nghiệp (SSO, hỗ trợ chuyên nghiệp) báo giá riêng
- **Stack tự host**: Python proxy + PostgreSQL theo dõi chi tiêu + Redis cache
- **Tính năng nổi bật**: Virtual API key per project/user, hỗ trợ native A2A protocol cho agent-to-agent communication, tích hợp MCP tool, multi-tenant auth

**Khi nào LiteLLM thắng**: Bạn có function DevOps. Muốn sở hữu gateway, thấy từng byte, không bao giờ chia sẻ key với bên thứ ba. Markup 0% không thể cưỡng lại ở quy mô — ở $50K/tháng chi tiêu API, 5.5% OpenRouter charge = $2,750/tháng bay mất.

**Khi nào không**: Bạn solo và "Python proxy + PostgreSQL + Redis" là ba thứ phải chăm sóc thêm. Bỏ qua, dùng OpenRouter.

**Hosting đề xuất**: VPS 4GB thừa sức xử lý 1k RPS. LiteLLM proxy nội bộ của chúng tôi chạy trên [VPS Hong Kong của HTStack](https://my.htstack.com/aff.php?aff=27187) (cũng là nơi dibi8.com chạy) cho độ trễ sub-30ms tới user Trung Quốc đại lục. Để deploy phân tán toàn cầu, [DigitalOcean Kubernetes](https://m.do.co/c/eca87ac14ee0) với 3 replica là pattern production tiêu chuẩn.

Hướng dẫn LiteLLM đầy đủ (kèm Docker compose, virtual key, dashboard chi tiêu) xem [thiết lập gateway production LiteLLM 2026](/vi/resources/llm-frameworks/litellm/).

## 5. OpenRouter: Aggregator Không Cần Setup

**Lời chào**: Một API key. 300+ model. Không hạ tầng. Bạn trả per-token qua OpenRouter ở giá list provider + 5.5% phí mua credit.

**Số liệu thực**:

- **Model**: 300+ bao gồm model frontier open-weight (DeepSeek-V4, Llama 4, Qwen 3) và proprietary (GPT-5, Claude 4.7, Gemini 2 Pro)
- **Độ trễ gateway**: Thêm 100–150ms trong test của chúng tôi (đây là chi phí thực — họ là dịch vụ host trước API provider)
- **Giá**: Giá list provider + **phí 5.5% trên mua credit bằng thẻ** (top-up crypto bỏ qua phí này)
- **Không có SLA công khai** — cộng đồng báo cáo 5xx tập trung khi provider gặp sự cố
- **Model miễn phí**: Một số endpoint miễn phí cộng đồng tài trợ (biến thể Llama, Mistral) tốt cho test

**Khi nào OpenRouter thắng**: Bạn đang prototype. Là hobbyist. Cần model chưa lên Bedrock/Azure (thường gặp với open-weight mới — OpenRouter thường là host đầu tiên). Không muốn quản lý bất kỳ hạ tầng nào.

**Khi nào không**: Bạn tiêu hơn $2K/tháng cho inference. Phí 5.5% ở mức đó = $110+/tháng cho giá trị 0. Lúc đó LiteLLM + key provider trực tiếp trở thành phép toán hiển nhiên.

Hướng dẫn OpenRouter đầy đủ (mẹo routing model miễn phí), xem [hướng dẫn thiết lập OpenRouter unified LLM API gateway 2026](/vi/resources/llm-frameworks/openrouter-unified-llm-api-gateway/).

## 6. Đối Đầu Trực Diện: Bảng Số Liệu

| Chỉ số | Portkey | LiteLLM | OpenRouter |
|---|---|---|---|
| GitHub stars | 11.8k | **47.8k** | N/A (dịch vụ closed-source) |
| License | MIT | OSS core (enterprise custom) | Proprietary |
| Model hỗ trợ | 1,600+ | 100+ provider | 300+ model cụ thể |
| Độ trễ thêm | **<1ms** | 8ms P95 (tuyên bố) / 10–20ms thực | 100–150ms |
| Chi phí ở $1K/tháng | $1,049 ($49 platform) | $1,000 + ~$20–50 VPS | **$1,055** ($55 phí) |
| Chi phí ở $50K/tháng | $1,049 phí platform | $1,000–2,500 hạ tầng | **$52,750** (5.5% phí) |
| Tùy chọn tự host | ✅ (lõi mã nguồn mở) | ✅ (thiết kế cho điều này) | ❌ |
| Tuân thủ (SOC2/HIPAA) | ✅ | Chỉ tier enterprise | ⚠️ qua provider |
| Thời gian setup | 1 ngày | 1–3 ngày | **5 phút** |
| Phù hợp nhất | Enterprise được quản lý | Quy mô tiết kiệm chi phí | Prototype & độ rộng |

Đọc từng dòng. Chọn theo ràng buộc áp đảo của bạn.

## 7. Kịch Bản Thực Tế

**Kịch bản A — Solo founder build coding agent**: OpenRouter cho v0, chuyển sang LiteLLM tháng thứ 6 khi inference hàng tháng vượt $1K và 5.5% bắt đầu đau.

**Kịch bản B — Startup Series B có team DevOps**: LiteLLM tự host từ ngày 1. Dùng OpenRouter làm một trong các upstream provider của LiteLLM để truy cập model mới chưa lên Bedrock.

**Kịch bản C — Sản phẩm AI healthcare qua audit HIPAA**: Portkey, không tranh cãi. Riêng câu chuyện tuân thủ đã đáng phí platform, 50+ guardrail là checkbox trên security review.

**Kịch bản D — Indie hacker test 10 ý tưởng model trong cuối tuần**: OpenRouter. 5 phút setup, một API key, tất cả model. Lo về chi phí sau khi đã ship được gì đó.

**Kịch bản E — Codebase OpenAI hiện có, muốn thêm fallback Claude**: Thả LiteLLM vào như đổi base URL một dòng. Cấu hình rule fallback trong YAML. Ship trong một buổi chiều.

## 8. Ngoài Ba Ông Lớn: Khi 9Router Đè Bẹp Cả Ba

Cho một workload cụ thể — **coding agent** — không có Portkey/LiteLLM/OpenRouter nào tối ưu cho driver chi phí áp đảo: **số lượng token**. Coding agent gửi *toàn bộ codebase* mỗi turn, làm nổ tung context window và token.

**9Router** là smart proxy được xây quanh **RTK (Repetition-Token Compression)** cắt token thực gửi đến provider 20–40% qua dedupe ngữ nghĩa nội dung lặp (file header, import, system prompt). Nó cũng auto-fallback qua 40+ provider và orchestrate combo coding tier miễn phí (Gemini 1k req/day + DeepSeek free + GLM-4.6 free).

Nếu 60%+ chi tiêu LLM hàng tháng là coding agent, 9Router có khả năng tiết kiệm nhiều hơn lựa chọn rẻ nhất khác ở đây. Setup xem [hướng dẫn smart LLM proxy + token saver 9Router](/vi/resources/llm-frameworks/9router-smart-llm-proxy-token-saver-free-coding/).

## TL;DR

Ba gateway. Ba mặc định thành thật:

- **Bạn là enterprise** → Portkey
- **Bạn nhạy cảm chi phí ở quy mô** → LiteLLM
- **Bạn đi nhanh và muốn tất cả** → OpenRouter
- **Bạn đốt token cho coding agent** → 9Router

Không có LLM gateway "tốt nhất phổ quát". Chỉ có cái khớp với dòng của bạn trong cây quyết định mục 2. Chọn cái đó, ship, và đánh giá lại khi hóa đơn inference hàng tháng vượt $5,000.

---

*Muốn test 3 cái này ở production mà không cam kết? Bật một [DigitalOcean droplet](https://m.do.co/c/eca87ac14ee0) $6/tháng với LiteLLM, trỏ OpenAI SDK hiện có vào đó, và xem các tùy chọn fallback mở rộng mà không động vào code ứng dụng.*
