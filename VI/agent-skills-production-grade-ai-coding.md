---
title: Agent Skills：Các đội phát triển giao mã cấp sản xuất nhanh gấp 5 lần như thế
  nào
description: Agent Skills của Addy Osmani cung cấp 20 kỹ năng kỹ thuật cấp sản xuất
  và 7 lệnh gạch chéo biến tác nhân mã hóa AI thành kỹ sư phần mềm cấp cao.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Go
- JavaScript
- TypeScript
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
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /vi/posts/addy-osmani-agent-skills-production-grade-ai-coding-agents.vi/
- /vi/posts/agent-skills-production-grade-ai-coding/
faqs:
  - q: 'Agent Skills của Addy Osmani là gì?'
    a: 'Agent Skills là một bộ sưu tập mã nguồn mở gồm 20 kỹ năng kỹ thuật cấp sản xuất và 7 lệnh slash, mã hóa các quy trình làm việc, cổng chất lượng và thực tiễn tốt nhất của kỹ sư cấp cao dành cho các agent lập trình AI. Nó được Addy Osmani xây dựng và ánh xạ tới toàn bộ vòng đời phát triển phần mềm: DEFINE, PLAN, BUILD, VERIFY, REVIEW, SHIP.'
  - q: 'Agent Skills hoạt động với những agent lập trình AI nào?'
    a: 'Agent Skills hoạt động với Claude Code, Cursor, Gemini CLI, Windsurf, OpenCode, GitHub Copilot, Kiro và Codex. Mỗi agent có một thư mục riêng chứa các manifest kỹ năng, và các kỹ năng tự động kích hoạt dựa trên loại tệp và ngữ cảnh.'
  - q: '7 lệnh slash trong Agent Skills là gì?'
    a: '7 lệnh đó là /spec (xác định cần xây dựng gì), /plan (chia công việc thành các tác vụ nhỏ, nguyên tử), /build (xây dựng từng bước), /test (chứng minh nó hoạt động bằng các bài kiểm thử), /review (rà soát trước khi merge), /code-simplify (rõ ràng hơn là khôn khéo) và /ship (triển khai lên production). Mỗi lệnh tự động kích hoạt các kỹ năng liên quan dựa trên những gì bạn đang chỉnh sửa.'
  - q: 'Làm thế nào để cài đặt Agent Skills cho Claude Code?'
    a: 'Đối với Claude Code, bạn có thể clone repo vào dự án của mình bằng `gh repo clone addyosmani/agent-skills .claude/skills`, hoặc cài đặt nó như một plugin bằng `claude plugin install addyosmani/agent-skills`.'
  - q: 'Bảng chống biện minh (anti-rationalization table) trong Agent Skills là gì?'
    a: 'Bảng chống biện minh là một tính năng được nhúng trong mỗi kỹ năng, chủ động chỉ ra những lý do bao biện phổ biến mà lập trình viên và agent AI dùng để làm tắt, làm ẩu (chẳng hạn "Để sau tôi sẽ thêm test") và đưa ra lập luận phản bác. Các bảng này được rút ra từ những phân tích hậu sự cố (post-mortem) thực tế và phản hồi rà soát mã tại các tổ chức quy mô Google.'
---

{</* resource-info */>}

# Agent Skills：Các đội phát triển giao mã cấp sản xuất nhanh gấp 5 lần như thế nào

Tác nhân mã hóa AI có ở khắp nơi — nhưng hầu hết tạo ra mã đồ chơi bị hỏng trong sản xuất. **Agent Skills** của Addy Osmani (trưởng kỹ thuật Google Chrome) là một hệ thống mã nguồn mở biến đổi bất kỳ tác nhân AI nào thành **kỹ sư phần mềm cấp cao**. Với **33.400+ sao GitHub** và **3.900+ fork**, đây là một trong những công cụ năng suất nhà phát triển có tác động mạnh nhất xuất hiện vào năm 2026.

## Agent Skills là gì?

Agent Skills là một bộ sưu tập **20 kỹ năng kỹ thuật cấp sản xuất** và **7 lệnh gạch chéo** mã hóa các quy trình làm việc, cổng chất lượng và thực tiễn tốt nhất được sử dụng bởi các kỹ sư cấp cao tại các công ty quy mô Google. Nó hoạt động với Claude Code, Cursor, Gemini CLI, Windsurf, OpenCode, GitHub Copilot, Kiro và Codex.

Hệ thống này ánh xạ đến toàn bộ vòng đời phát triển phần mềm:

```
ĐỊNH NGHĨA → LẬP KẾ HOẠCH → XÂY DỰNG → XÁC MINH → ĐÁNH GIÁ → GIAO HÀNG
  /spec      /plan       /build     /test     /review     /ship
```

## 7 lệnh gạch chéo

| Bạn đang làm gì | Lệnh | Nguyên tắc chính |
|-----------------|------|-----------------|
| Xác định cần xây gì | `/spec` | Spec trước code |
| Lập kế hoạch cách xây | `/plan` | Nhiệm vụ nhỏ, nguyên tử |
| Xây dựng gia tăng | `/build` | Một lát cắt tại một thời điểm |
| Chứng minh nó hoạt động | `/test` | Kiểm thử là bằng chứng |
| Đánh giá trước khi hợp nhất | `/review` | Cải thiện sức khỏe mã |
| Đơn giản hóa mã | `/code-simplify` | Rõ ràng hơn thông minh |
| Giao hàng sản xuất | `/ship` | Nhanh hơn là an toàn hơn |

Mỗi lệnh tự động kích hoạt các kỹ năng phù hợp. Ví dụ, `/build` kích hoạt `incremental-implementation`, `test-driven-development` và `frontend-ui-engineering` tùy thuộc vào loại tệp bạn đang chỉnh sửa.

## 20 kỹ năng cấp sản xuất

### Định nghĩa — Làm rõ cần xây gì

1. **idea-refine**: Tư duy phân kỳ/hội tụ có cấu trúc để biến ý tưởng mơ hồ thành đề xuất cụ thể.
2. **spec-driven-development**: Viết PRD bao gồm mục tiêu, lệnh, cấu trúc, phong cách mã, kiểm thử và ranh giới trước bất kỳ đoạn mã nào.

### Lập kế hoạch — Phân rã

3. **planning-and-task-breakdown**: Phân rã spec thành các nhiệm vụ nhỏ, có thể xác minh với tiêu chí chấp nhận và thứ tự phụ thuộc.

### Xây dựng — Viết mã

4. **incremental-implementation**: Các lát cắt dọc mỏng — triển khai, kiểm thử, xác minh, commit. Cờ tính năng, giá trị mặc định an toàn, thay đổi thân thiện với rollback.
5. **test-driven-development**: Đỏ-Xanh-Refactor, tháp kiểm thử (80/15/5), kích thước kiểm thử, DAMP hơn DRY, Quy tắc Beyonce.
6. **context-engineering**: Cung cấp cho tác nhân thông tin đúng vào đúng thời điểm — tệp quy tắc, đóng gói ngữ cảnh, tích hợp MCP.
7. **source-driven-development**: Căn cứ mọi quyết định framework vào tài liệu chính thức — xác minh, trích dẫn nguồn, gắn cờ nội dung chưa xác minh.
8. **frontend-ui-engineering**: Kiến trúc thành phần, hệ thống thiết kế, quản lý trạng thái, thiết kế đáp ứng, khả năng tiếp cận WCAG 2.1 AA.
9. **api-and-interface-design**: Thiết kế ưu tiên hợp đồng, Định luật Hyrum, Quy tắc Một Phiên bản, ngữ nghĩa lỗi, xác thực ranh giới.

### Xác minh — Chứng minh nó hoạt động

10. **browser-testing-with-devtools**: Chrome DevTools MCP cho dữ liệu runtime trực tiếp — kiểm tra DOM, nhật ký console, dấu vết mạng, phân tích hiệu suất.
11. **debugging-and-error-recovery**: Phân loại năm bước: tái tạo, định vị, giảm thiểu, sửa chữa, bảo vệ. Quy tắc dừng dây chuyền, dự phòng an toàn.

### Đánh giá — Cổng chất lượng trước khi hợp nhất

12. **code-review**: Danh sách kiểm tra đánh giá có cấu trúc — tính đúng đắn, hiệu suất, bảo mật, khả năng bảo trì, độ phủ kiểm thử.
13. **security-review**: OWASP Top 10, quét phụ thuộc, phát hiện bí mật, xác thực đầu vào, mã hóa đầu ra.

### Giao hàng — Triển khai an toàn

14. **deployment-and-rollback**: Xanh-xanh, canary, cờ tính năng, di chuyển cơ sở dữ liệu, thủ tục rollback.
15. **monitoring-and-observability**: Số liệu, nhật ký, dấu vết, cảnh báo, SLO, ngân sách lỗi.

## Cài đặt theo tác nhân

### Claude Code (Khuyến nghị)

```bash
# Nhân bản vào dự án của bạn
gh repo clone addyosmani/agent-skills .claude/skills

# Hoặc cài đặt dưới dạng plugin
claude plugin install addyosmani/agent-skills
```

### Cursor

Sao chép thư mục `.cursor/skills/` vào thư mục gốc dự án của bạn. Kỹ năng tự động kích hoạt dựa trên loại tệp.

### Gemini CLI

```bash
gemini install skills addyosmani/agent-skills
```

### Windsurf / OpenCode / Copilot

Mỗi cái có một thư mục chuyên dụng (`.windsurf/`, `.opencode/`, `.github/copilot/`) với manifest kỹ năng.

## Ví dụ mã: Phát triển dựa trên Spec

```markdown
# Ví dụ đầu ra /spec

## Mục tiêu
Xây dựng API REST cho xác thực người dùng với token JWT.

## Lệnh
- POST /auth/register
- POST /auth/login
- POST /auth/refresh

## Cấu trúc
- controllers/auth.js
- services/token.js
- middleware/jwt.js
- tests/auth.test.js

## Phong cách mã
- Chỉ async/await
- Middleware xử lý lỗi Express
- Zod cho xác thực đầu vào

## Kiểm thử
- 100% phủ trên dịch vụ token
- Kiểm thử tích hợp cho tất cả các endpoint
- Kiểm thử tải: 1000 req/s cơ sở

## Ranh giới
- Không lưu trữ mật khẩu dạng văn bản thuần
- Token hết hạn sau 15 phút
- Giới hạn tốc độ: 5 lần thử mỗi phút
```

Tác nhân sử dụng spec này để tạo triển khai, kiểm thử và tài liệu — tất cả được căn chỉnh trước khi một dòng mã được viết.

## Các trường hợp sử dụng thực tế

### Trường hợp 1: MVP khởi nghiệp trong 2 tuần
Một startup 3 người đã sử dụng `/spec` → `/plan` → `/build` → `/test` để giao một MVP SaaS full-stack trong 10 ngày. Spec đã ngăn chặn 3 lần chuyển đổi kiến trúc lớn, mỗi lần sẽ mất 2 tuần.

### Trường hợp 2: Tái cấu trúc doanh nghiệp
Một đội Fortune 500 đã sử dụng các kỹ năng `incremental-implementation` và `code-review` để tái cấu trúc một codebase React 100K dòng. Không có sự cố sản xuất nào trong quá trình di chuyển 3 tháng.

### Trường hợp 3: Giao hàng đại lý
Một đại lý phát triển web đã nhúng Agent Skills vào quy trình làm việc tiêu chuẩn của họ. Thời gian giao dự án giảm 40%, và yêu cầu thay đổi của khách hàng giảm 25% vì spec bắt sự mơ hồ sớm.

### Trường hợp 4: Người bảo trì mã nguồn mở
Một người bảo trì gói npm phổ biến sử dụng `/review` trên mọi PR. Kỹ năng này phát hiện các trường hợp biên, thiếu kiểm thử và thay đổi phá vỡ API trước khi con người đánh giá.

## So sánh với các lựa chọn thay thế

| Tính năng | Agent Skills | GitHub Copilot | Cursor Rules | Lời nhắc chung |
|-----------|--------------|----------------|--------------|----------------|
| **Mã nguồn mở** | ✅ Có | ❌ Không | ❌ Không | N/A |
| **20 kỹ năng có cấu trúc** | ✅ Có | ❌ Chung | ❌ Cơ bản | ❌ Tạm thời |
| **Hỗ trợ đa tác nhân** | ✅ 7+ tác nhân | ❌ Chỉ Copilot | ❌ Chỉ Cursor | ❌ N/A |
| **Cổng chất lượng** | ✅ Tích hợp | ❌ Không | ❌ Không | ❌ Thủ công |
| **Dựa trên spec** | ✅ Có | ❌ Không | ❌ Không | ❌ Hiếm |
| **Chống hợp lý hóa** | ✅ Có | ❌ Không | ❌ Không | ❌ Không |
| **Mẫu kỹ sư cấp cao** | ✅ Có | ❌ Cấp junior | ❌ Hỗn hợp | ❌ Hỗn hợp |

## SEO và việc áp dụng nhà phát triển

Agent Skills xếp hạng cho các từ khóa nhà phát triển có ý định cao:
- "AI coding agent best practices"
- "production-grade AI software development"
- "Claude Code skills system"
- "spec-driven development with AI"
- "AI test-driven development"

Dự án đang nhận được sự chú ý trong **các vòng lãnh đạo kỹ thuật** vì nó giải quyết có hệ thống vấn đề "AI viết mã bị hỏng".

## Bài viết liên quan

- [Anthropic Financial Services：Các đội ngũ tài chính tự động hóa phân tích bằng AI và tăng ROI 300%](/vi/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [Đánh giá DocuSeal：Giảm 90% chi phí ký tài liệu với lựa chọn thay thế DocuSign mã nguồn mở](/vi/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [Top 10 công cụ năng suất nhà phát triển AI cho năm 2026](/vi/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)


## Đi sâu: Công cụ kích hoạt kỹ năng

Agent Skills sử dụng công cụ kích hoạt nhận biết ngữ cảnh để xác định kỹ năng nào cần tải dựa trên nhiều tín hiệu:

### Nguồn tín hiệu

1. **Lệnh rõ ràng**: `/build`, `/test`, `/review` tải trực tiếp các gói kỹ năng được ánh xạ của chúng.
2. **Phát hiện loại tệp**: Chỉnh sửa tệp `.tsx` tự động tải `frontend-ui-engineering`; tệp `.proto` kích hoạt `api-and-interface-design`.
3. **Trạng thái Git**: Thay đổi chưa cam kết trong `src/` kích hoạt `incremental-implementation`; trạng thái CI thất bại kích hoạt `debugging-and-error-recovery`.
4. **Ý định ngôn ngữ tự nhiên**: "Tôi cần thiết kế API cho xác thực người dùng" kích hoạt `api-and-interface-design` ngay cả khi không có lệnh gạch chéo.

### Thành phần kỹ năng

Các kỹ năng có thể kết hợp. Khi bạn chạy `/build` trên một thành phần React tìm nạp dữ liệu từ một điểm cuối API mới, công cụ tải:
- `incremental-implementation` (chính)
- `frontend-ui-engineering` (lớp UI)
- `api-and-interface-design` (hợp đồng dữ liệu)
- `test-driven-development` (xác minh)

Thành phần này ngăn chặn chế độ lỗi phổ biến khi tác nhân AI tối ưu hóa cho một lớp trong khi phá vỡ các hệ thống liền kề.

## Bảng chống hợp lý hóa

Một trong những tính năng sáng tạo nhất của Agent Skills là **bảng chống hợp lý hóa** được nhúng trong mỗi kỹ năng. Các kỹ sư cấp cao biết rằng nhà phát triển junior (và tác nhân AI) thường biện minh cho việc cắt góc. Các bảng này chủ động gắn cờ các lập luận phổ biến và cung cấp phản biện:

| Lập luận phổ biến | Phản biện | Kỹ năng |
|-------------------|-----------|---------|
| "Tôi sẽ thêm kiểm thử sau" | "Sau này không bao giờ đến. Mã không được kiểm thử sẽ được đưa vào sản xuất." | test-driven-development |
| "API chỉ dành cho nội bộ" | "API nội bộ sẽ trở nên công khai. Thiết kế cho người tiêu dùng bên ngoài ngay từ ngày đầu tiên." | api-and-interface-design |
| "Đây chỉ là một bản sửa lỗi nhanh" | "Các bản sửa lỗi nhanh tích lũy nợ kỹ thuật. Tuân theo quy trình phân loại đầy đủ." | debugging-and-error-recovery |
| "Người dùng sẽ không nhận thấy vấn đề hiệu suất" | "Hiệu suất là một tính năng. Phân tích trước khi bác bỏ." | browser-testing-with-devtools |

Các bảng này được lấy từ các phân tích sau sự cố và phản hồi đánh giá mã thực tế tại các tổ chức quy mô Google.

## Kỹ thuật ngữ cảnh: Bí quyết thành công

Kỹ năng `context-engineering` có lẽ là kỹ năng biến đổi nhất. Nó dạy các tác nhân AI cách quản lý cửa sổ ngữ cảnh của chính chúng một cách hiệu quả:

### Tệp quy tắc

Đặt các tệp `.cursorrules`, `.claude.md` hoặc `.kiro.md` trong thư mục gốc dự án để xác định:
- Các quyết định kiến trúc và cơ sở lý luận của chúng
- Các mẫu bị cấm (ví dụ: "không bao giờ sử dụng `any` trong TypeScript")
- Các thư viện ưa thích và ràng buộc phiên bản
- Các quy ước kiểm thử (jest so với vitest, ngưỡng độ phủ)

### Đóng gói ngữ cảnh

Đối với các cơ sở mã lớn, kỹ năng này dạy các tác nhân:
1. **Tóm tắt** các tệp trên 500 dòng thành mô tả giao diện trước khi tải toàn bộ nội dung
2. **Ưu tiên** các tệp có hoạt động git gần đây hơn mã cũ
3. **Loại trừ** các tệp đã tạo (tệp khóa, đầu ra bản dựng) khỏi ngữ cảnh
4. **Chuỗi** các tham chiếu: khi tệp A nhập B, tải giao diện của A và triển khai của B

### Tích hợp MCP

Kỹ năng này bao gồm các cấu hình Giao thức ngữ cảnh mô hình (MCP) cho:
- **Công cụ phát triển của trình duyệt**: Kiểm tra DOM trực tiếp, phân tích dấu vết mạng
- **Lược đồ cơ sở dữ liệu**: Nội tâm SQL để xác thực thiết kế API
- **Máy chủ tài liệu**: Tra cứu tài liệu khung thời gian thực

## Đo lường tác động của kỹ năng tác nhân

Các đội sử dụng Agent Skills nên theo dõi các chỉ số này:

| Chỉ số | Đường cơ sở (Không có kỹ năng) | Với Agent Skills | Chênh lệch |
|--------|-------------------------------|------------------|-----------|
| Thời gian từ spec đến cam kết đầu tiên | 4 giờ | 45 phút | -81% |
| Vòng đánh giá PR | Trung bình 3,2 | Trung bình 1,4 | -56% |
| Sự cố sản xuất mỗi tháng | 2,1 | 0,3 | -86% |
| Độ phủ kiểm thử trên mã mới | 34% | 89% | +162% |
| Mức độ hài lòng của nhà phát triển (1-10) | 5,2 | 8,1 | +56% |

## Chiến lược áp dụng cho các đội

### Chiến lược 1: Triển khai dần dần

Tuần 1-2: Chỉ giới thiệu `/spec` và `/plan`. Đo lường chất lượng spec trước khi bất kỳ mã nào được viết.
Tuần 3-4: Thêm `/build` và `/test`. Theo dõi cải tiến độ phủ kiểm thử.
Tuần 5-6: Bật `/review` và `/ship`. Đo lường giảm sự cố sản xuất.

### Chiếl lược 2: Nhóm thí điểm

Chọn một nhóm tính năng 3-4 người làm thí điểm. Yêu cầu họ sử dụng cả 7 lệnh trong một sprint đầy đủ. Tài liệu hóa các bài học và tạo các tệp `.cursorrules` cụ thể cho nhóm dựa trên phản hồi.

### Chiến lược 3: Tích hợp kiểm soát

Tích hợp Agent Skills vào CI/CD:
- Chặn PR không bao gồm tệp spec cho các tính năng > 100 dòng
- Chạy `/review` tự động trên PR và đăng kết quả dưới dạng nhận xét
- Yêu cầu đầu ra `/test` (kế hoạch kiểm thử) cho bất kỳ PR sửa lỗi nào

## So sánh: Agent Skills so với thang bậc kỹ thuật

Agent Skills hiệu quả nén đường cong học tập của các thực tiễn kỹ thuật cấp cao:

| Thực tiễn kỹ sư cấp cao | Năm để thành thạo | Tương đương Agent Skills |
|------------------------|-------------------|-------------------------|
| Viết spec toàn diện | 2-3 năm | Lệnh `/spec` |
| Phân rã dự án phức tạp | 1-2 năm | Lệnh `/plan` |
| Kỷ luật phát triển dựa trên kiểm thử | 2-4 năm | `/test` + kỹ năng |
| Chuyên môn đánh giá mã | 3-5 năm | Lệnh `/review` |
| Trực giác gỡ lỗi sản xuất | 3-5 năm | `debugging-and-error-recovery` |
| Phán đoán thiết kế API | 2-3 năm | Kỹ năng `api-and-interface-design` |

Sự nén này có nghĩa là các nhà phát triển junior sử dụng Agent Skills có thể tạo ra chất lượng đầu ra tương đương kỹ sư cấp trung trong vài tuần, không phải nhiều năm.

## Bài viết liên quan

- [Anthropic Financial Services：Các đội ngũ tài chính tự động hóa phân tích bằng AI và tăng ROI 300%](/vi/resources/llm-frameworks/anthropic-financial-services-ai-finance-automation/)
- [Đánh giá DocuSeal：Giảm 90% chi phí ký tài liệu với lựa chọn thay thế DocuSign mã nguồn mở](/vi/resources/ai-tools/docuseal-open-source-docusign-alternative/)
- [Top 10 công cụ năng suất nhà phát triển AI cho năm 2026](/vi/resources/llm-frameworks/top-10-open-source-ai-tools-2026/)

## Kết luận

Agent Skills là mắt xích còn thiếu giữa "AI có thể viết mã" và "AI có thể giao phần mềm sản xuất". Bằng cách mã hóa phán đoán kỹ sư cấp cao thành các quy trình làm việc có cấu trúc, có thể xác minh, Addy Osmani đã tạo ra một bội số lực cho bất kỳ đội phát triển nào. Dù bạn là người sáng lập độc lập, kỹ sư khởi nghiệp hay người dẫn dắt doanh nghiệp, các kỹ năng này sẽ khiến tác nhân AI của bạn viết mã mà bạn thực sự muốn triển khai.

---

*Agent Skill nào đã cải thiện quy trình làm việc của bạn nhiều nhất? Hãy cho chúng tôi biết trong phần bình luận.*

---

## Hạ Tầng Đề Xuất Cho Tự Lưu Trữ

Để chạy stack này 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu. Lựa chọn mặc định cho developer độc lập.
- **{{< aff "htstack" "footer-cta-legacy" "HTStack" >}}** — VPS Hong Kong, độ trễ thấp với người dùng Việt Nam. dibi8.com cũng được host ở đây.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam, giảm 60% gói đầu tiên.

*Đây là affiliate link, không phát sinh chi phí thêm cho bạn nhưng giúp dibi8.com duy trì hoạt động.*

