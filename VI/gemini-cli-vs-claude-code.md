---
title: 'Gemini CLI vs Claude Code 2026: Agent AI coding nào tốt hơn?'
description: 'So sánh trực tiếp Google Gemini CLI và Anthropic Claude Code — gói miễn phí, cửa sổ context, phong cách agent, đa phương thức, sử dụng tool, mẹo chuyển đổi. Cập nhật 2026.'
date: 2026-05-22 00:00:00+08:00
draft: false
tags: [gemini-cli, claude-code, google, anthropic, ai-coding, comparison, dev-tools]
categories: [vs]
faqs:
  - q: 'Gemini CLI có thực sự miễn phí không?'
    a: 'Có — Gemini CLI đi kèm gói miễn phí hào phóng nhất trong các agent AI coding hiện nay: 60 request mỗi phút và 1.000 request mỗi ngày dùng gemini-2.0-flash-thinking, không cần thẻ tín dụng, chỉ cần tài khoản Google. Claude Code không có gói miễn phí — phải trả theo token qua Anthropic API hoặc qua gói Claude Pro $20/tháng với dung lượng Claude Code hạn chế.'
  - q: 'Cái nào có cửa sổ context lớn hơn?'
    a: 'Gemini CLI dùng gemini-2.0-flash-thinking với tối đa 1M token context ở gói miễn phí, mở rộng tới 2M trên Vertex AI trả phí. Claude Code dùng claude-opus-4.7 với 200K chuẩn hoặc 1M context (1M ở dạng beta, trả theo dùng). Về context thuần ở gói miễn phí Gemini CLI thắng; về chất lượng suy luận long-context ở 1M hai bên ngang.'
  - q: 'Cái nào tốt hơn cho công việc agent đa file?'
    a: 'Claude Code chín muồi hơn với tư cách agent — đi kèm vòng tool-use tinh chỉnh (Read/Edit/Bash/Glob/Grep), checkpoint-và-resume, và system prompt đã được tinh chỉnh cho kỹ thuật phần mềm. Gemini CLI bắt kịp nhanh trong 2026 với tool use kiểu ReAct và tích hợp shell, nhưng Claude Code vẫn thắng ở refactor đa file và vòng agent dài.'
  - q: 'Tôi có thể chạy cả Gemini CLI và Claude Code trên cùng dự án không?'
    a: 'Có — chúng không xung đột. Nhiều developer dùng Gemini CLI cho công việc khám phá miễn phí (đọc codebase, tạo docs, prompt nháp) và Claude Code cho việc nặng có trả phí (refactor đa file, code production, vòng agent). Combo cho bạn trinh sát gần miễn phí + thực thi cao cấp với tổng chi phí thấp hơn so với chỉ dùng Claude Code.'
  - q: 'Hỗ trợ đa phương thức bên nào tốt hơn?'
    a: 'Gemini CLI thắng đa phương thức trong terminal — nhận hình ảnh, PDF, khung video gốc thông qua flag (ví dụ `--image screenshot.png`). Claude Code hỗ trợ ảnh qua hội thoại nhưng thiên về text trước. Với luồng kiểu "nhìn screenshot UI này và viết component React", Gemini CLI nhanh hơn ngay khi mở hộp.'
---

## Câu trả lời nhanh

**Gemini CLI** thắng với developer muốn agent AI coding miễn phí hào phóng nhất, đầu vào đa phương thức native, và 1M context mà không trả tiền. **Claude Code** thắng với developer muốn vòng agent chín muồi nhất, chất lượng refactor đa file tốt nhất, và code generation đẳng cấp Anthropic.

Dùng **Gemini CLI** nếu: Muốn AI coding chi phí zero (1.000 request/ngày miễn phí), làm việc với hình ảnh/PDF/screenshot thường xuyên, không phiền vòng agent hơi kém bóng bẩy, làm dự án hobby/indie với ngân sách $0 nghiêm ngặt.

Dùng **Claude Code** nếu: Muốn trải nghiệm agent tinh chỉnh nhất, cần chất lượng refactor đa file cao cấp, ship code production nơi mọi edit đều quan trọng, sẵn sàng trả $20-$200/tháng cho output đẳng cấp Anthropic.

---

## So sánh trực tiếp

| Đặc điểm | Gemini CLI | Claude Code |
|---|---|---|
| **Nhà cung cấp** | Google | Anthropic |
| **Ra mắt** | 2025 (mã nguồn mở) | 2025 (đóng) |
| **Giấy phép** | Apache 2.0 (CLI), model độc quyền | Độc quyền |
| **Mô hình mặc định** | gemini-2.0-flash-thinking | claude-opus-4.7 |
| **Cửa sổ context (miễn phí)** | 1M token | Không có (không có gói miễn phí) |
| **Cửa sổ context (trả phí)** | 2M token (Vertex AI) | 200K chuẩn, 1M beta |
| **Gói miễn phí** | 60 req/phút, 1.000 req/ngày | Không |
| **Giá trả phí vào cửa** | Trả theo dùng qua Vertex AI | $20/tháng Pro (hạn chế) |
| **Giá trả phí nặng** | ~$1-3 mỗi 1M token | $200/tháng Max plan |
| **Phong cách agent** | ReAct + tích hợp shell | Vòng tool-use tinh chỉnh |
| **Đầu vào đa phương thức** | Native (hình ảnh, PDF, khung video) | Hình ảnh qua hội thoại |
| **Sử dụng tool** | Sẵn có (Read, Write, Shell, WebFetch) | Sẵn có (Read, Edit, Bash, Glob, Grep) |
| **Checkpoint/resume** | Resume session cơ bản | Checkpoint hội thoại đầy đủ |
| **Hỗ trợ MCP** | Có (2025+) | Có (native, hạng nhất) |
| **Sandbox / an toàn** | Prompt xác nhận | Phân quyền cấu hình được |
| **Mã nguồn mở** | Có (chỉ CLI) | Không |
| **Kích cỡ codebase tối ưu** | < 500K LOC (1M context) | < 500K LOC (1M context) |
| **Cài đặt** | `npm i -g @google/gemini-cli` | `npm i -g @anthropic-ai/claude-code` |

---

## Khi nào chọn Gemini CLI

### Tình huống 1: AI coding ngân sách zero
Gói miễn phí của Gemini CLI là hào phóng nhất trên thị trường agent AI coding: 60 request mỗi phút và 1.000 mỗi ngày. Đó là khoảng **30.000 request coding miễn phí mỗi tháng** nếu bạn đẩy hết. Với indie dev, hobbyist, sinh viên, đây là agent AI duy nhất có thể chạy công việc hàng ngày ở $0/tháng.

### Tình huống 2: Luồng làm việc đa phương thức
Cần "nhìn screenshot thiết kế này và viết component tương ứng"? Gemini CLI nhận hình ảnh, PDF, khung video native từ command line. Claude Code cũng xử lý được ảnh, nhưng UX flag của Gemini CLI nhanh hơn cho các luồng nặng screenshot (triển khai UI, QA thiết kế, các tác vụ kiểu OCR).

### Tình huống 3: Long context giá rẻ
Gemini CLI cho bạn 1M token context **ở gói miễn phí**. Muốn dump 200 file vào một prompt cho phân tích xuyên file? Miễn phí với Gemini CLI; cần subscribe Claude Code Max (~$200/tháng) để có dung lượng tương tự.

---

## Khi nào chọn Claude Code

### Tình huống 1: Refactor đa file cấp production
Vòng agent của Claude Code là tinh chỉnh nhất trên thị trường 2026. Refactor đa file đáp xuống sạch hơn — ít path bịa hơn, kỷ luật diff tốt hơn, bảo toàn style nhất quán hơn. Nếu bạn đang sửa code production thật ship cho user, chất lượng edit của Claude Code đáng $20-$200/tháng.

### Tình huống 2: Vòng agent dài với checkpoint
Checkpoint-resume của Claude Code thực sự hữu ích — bạn có thể pause một refactor 30 phút ở bước 7, xem lại, resume từ bước 8. Gemini CLI có resume session cơ bản nhưng không được rèn luyện cho vòng agent dài với context phân nhánh.

### Tình huống 3: Hệ sinh thái MCP hạng nhất
Claude Code ra mắt với hỗ trợ MCP (Model Context Protocol) native và có hệ sinh thái MCP server lớn nhất trong 2026 — databases, trình duyệt, monitor, CRM. Gemini CLI đã thêm MCP nhưng hệ sinh thái mỏng hơn. Nếu luồng làm việc cắm vào 5+ MCP server, Claude Code là con đường mượt hơn.

---

## Phân tích giá chi tiết

### Gemini CLI
- **Gói miễn phí (tài khoản Google)**: 60 req/phút, 1.000 req/ngày, gemini-2.0-flash-thinking, 1M context
- **Vertex AI trả theo dùng**: ~$0.30 mỗi 1M token đầu vào, ~$1.20 mỗi 1M đầu ra (Flash)
- **Model Pro Vertex AI**: ~$1.25 mỗi 1M đầu vào, ~$5 mỗi 1M đầu ra (gemini-2.0-pro)
- **Google Workspace Code Assist**: $19-$45/user/tháng cho doanh nghiệp

→ **Chi phí tháng cho indie dev**: **$0** hoàn toàn khả thi nếu bạn ở trong gói miễn phí. User nặng trên Vertex AI thường rơi vào $5-$20/tháng.

### Claude Code
- **Gói miễn phí**: Không
- **Claude Pro**: $20/tháng, bao gồm dung lượng Claude Code hạn chế (Sonnet, ~50 message mỗi 5 giờ)
- **Claude Max 5x**: $100/tháng, ~5x dung lượng, có Opus
- **Claude Max 20x**: $200/tháng, ~20x dung lượng, Opus + 1M context beta
- **API trả theo dùng**: ~$3 mỗi 1M đầu vào, ~$15 mỗi 1M đầu ra (Sonnet); ~$15/$75 cho Opus

→ **Chi phí tháng cho power user**: $20 (Pro nhẹ), $100 (Max 5x hàng ngày), $200 (Max 20x nặng).

### Người thắng về ngân sách
Sinh viên/hobbyist: **Gemini CLI miễn phí > Claude Pro $20**. Riêng gói miễn phí đã đủ cho coding hàng ngày.
Freelancer ship việc cho client: combo **Claude Pro $20 + Gemini CLI miễn phí** — Gemini cho khám phá, Claude cho thực thi.
Full-time builder: **Claude Max 5x $100 + Gemini CLI miễn phí** — Claude làm chính, Gemini cho đa phương thức và tràn lưu lượng.

---

## Benchmark hiệu năng (chủ quan, từ trải nghiệm hàng ngày)

| Tác vụ | Gemini CLI | Claude Code |
|---|---|---|
| Sửa bug đơn file | 7/10 | 9/10 |
| Refactor đa file | 7/10 | 9/10 |
| Tính năng mới từ spec | 8/10 | 9/10 |
| Sinh test | 7/10 | 8/10 |
| Đọc codebase lạ | 9/10 | 9/10 |
| Ảnh ra code (UI screenshot) | 9/10 | 7/10 |
| Phân tích PDF/docs | 9/10 | 7/10 |
| Vòng agent dài | 6/10 | 9/10 |
| Kỷ luật sử dụng tool | 7/10 | 9/10 |
| Độ hào phóng gói miễn phí | 10/10 | 0/10 |

→ Gemini CLI thắng ở gói miễn phí, đa phương thức, hấp thụ PDF/docs. Claude Code thắng ở chất lượng vòng agent, refactor đa file, kỷ luật edit cấp production.

---

## Mẹo chuyển đổi

### Claude Code → Gemini CLI
- Cài bằng `npm install -g @google/gemini-cli`
- Chạy `gemini` một lần để xác thực qua tài khoản Google (không cần API key cho gói miễn phí)
- Map lệnh: `/clear` → `/clear`, `/compact` → `/compress`, `/cost` → `/stats`
- Sandbox mặc định của Gemini CLI dễ dãi hơn — đặt `--sandbox-mode strict` nếu muốn prompt xác nhận kiểu Claude Code
- Dùng gói miễn phí trước — chỉ chuyển sang billing Vertex AI khi chạm trần 1.000 req/ngày
- Mong đợi edit đa file yếu hơn chút; bù bằng prompt rõ ràng hơn ("chỉ chạm 3 file này")

### Gemini CLI → Claude Code
- Cài bằng `npm install -g @anthropic-ai/claude-code`
- Chạy `claude` và xác thực qua subscription Claude Pro/Max hoặc API key
- Vòng agent của Claude Code tự chủ hơn — mong đợi ít prompt xác nhận hơn, edit trực tiếp nhiều hơn
- Dùng `/permissions` để siết sandbox nếu muốn kiểu Gemini CLI "hỏi trước mỗi hành động"
- Tận dụng MCP server — hệ sinh thái MCP của Claude Code phong phú hơn nhiều
- Ngân sách thực tế: user Claude Code nặng thường rơi vào $100/tháng (Max 5x) khi cảm giác lạ với gói miễn phí trôi đi

### Mẹo Self-Hosting
Muốn sandbox đám mây để chạy cả hai agent trên codebase thật mà không đốt tài nguyên cục bộ? Bật {{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean droplet với $200 credit miễn phí" >}} — đủ cho 2 tháng luồng AI agent hàng ngày trên droplet $12/tháng. Rẻ hơn việc giao máy dev cục bộ cho agent chạy quá hung hăng, và bạn có thể SSH từ bất cứ đâu.

---

## Lựa chọn thay thế đáng thử

Nếu cả Gemini CLI và Claude Code đều không hợp:

- **[Cursor](https://dibi8.com/vi/vs/cursor-vs-claude-code/)** — VS Code fork, autocomplete inline tốt nhất, $20/tháng
- **[Aider](https://dibi8.com/resources/llm-frameworks/aider/)** — Mã nguồn mở, terminal, BYO API key (hoạt động với Gemini, Claude, OpenAI)
- **[Continue.dev](https://dibi8.com/resources/llm-frameworks/continue/)** — Extension VS Code miễn phí, BYO model
- **[cc-switch](https://dibi8.com/resources/dev-utils/cc-switch-claude-code-api-router/)** — Định tuyến Claude Code qua nhà cung cấp rẻ hơn, cắt giảm 60-80% chi phí

---

## Góc nhìn dibi8

Năm 2026, thị trường AI coding CLI đang hợp nhất quanh hai phe: **phe mở và hào phóng (Gemini CLI)** và **phe đánh bóng cao cấp (Claude Code)**. Lựa chọn đúng phụ thuộc ví của bạn và độ kiên nhẫn với các cạnh thô.

Hạn chế ngân sách hoặc chỉ đang khám phá → **gói miễn phí Gemini CLI**, không tranh cãi. 1.000 request/ngày ở $0 là vô đối.
Ship code production hàng ngày → **Claude Code Max 5x ($100/tháng)**, chỉ chất lượng vòng agent đã đủ hoàn vốn.
Muốn cả hai → combo **Gemini CLI miễn phí + Claude Pro $20**. Gemini cho trinh sát (đọc code, scan PR, OCR screenshot), Claude cho thực thi (refactor, ship, review). Tổng cộng: $20/tháng cho AI coding đẳng cấp.

Với indie dev đang ship SaaS một mình trên **ngân sách cuối cùng**? **Gemini CLI gói miễn phí** là lựa chọn ROI dương nhất trong AI coding hiện nay — đúng nghĩa không có cách nào rẻ hơn để ship code với trợ giúp AI. Lý do duy nhất để nâng cấp lên Claude Code là khi bạn bắt đầu mất giờ vì chất lượng refactor đa file yếu hơn của Gemini. Đến lúc đó, miễn phí vẫn là miễn phí.

---

## FAQ

(render qua faqs frontmatter — hiển thị inline + JSON-LD cho AIO)

---

## Đọc thêm

- [So sánh Cursor vs Claude Code 2026](https://dibi8.com/vi/vs/cursor-vs-claude-code/)
- [So sánh Cursor vs Windsurf 2026](https://dibi8.com/vi/vs/cursor-vs-windsurf/)
- [Công cụ AI lập trình tốt nhất 2026 — Lựa chọn thay thế Cursor](https://dibi8.com/resources/llm-frameworks/ai-coding-tools-cursor-alternatives-2026/)
- [Stack LLM dưới $20/tháng](https://dibi8.com/collections/cheap-llm-stack/)

## Công Cụ Đề Xuất

**Cần access Claude hoặc OpenAI API ổn định?** Hầu hết người chọn giữa các tool này cuối cùng đều cần API key.

- **{{< aff "shiyunapi" "vs-footer" "Shiyunapi" >}}** — Proxy Claude / OpenAI / DeepSeek API. Một key cho phép access nhiều top model với ~30% giá chính thức; đặc biệt hữu ích khi compare model hoặc bị rate-limit Anthropic/OpenAI direct trong region.

*Affiliate link — không tốn thêm chi phí và giúp dibi8.com vận hành.*

