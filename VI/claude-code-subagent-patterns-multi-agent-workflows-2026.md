---
title: 'Mẫu Subagent Claude Code: 5 Quy Trình Multi-Agent Tiết Kiệm Hàng Giờ Mỗi Ngày (2026)'
description: '5 mẫu Claude Code subagent đã kiểm chứng trong production — nghiên cứu song song, cô lập worktree, ủy thác chuyên gia, bảo vệ context, điều phối pipeline. Kèm prompt thực và đánh đổi.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Bash']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Thương mại (Anthropic)
license_type: 'Proprietary'
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/anthropics/claude-code'
stars: 0
maintainer: 'Anthropic'
last_maintained: '2026-05-28'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['claude-code', 'subagents', 'multi-agent', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'agent-sdk']
aliases:
- /posts/claude-code-subagent-patterns/
faq:
  - q: "Subagent trong Claude Code chính xác là gì, và khác gì với việc chạy thêm một phiên CLI khác?"
    a: "Subagent là một cuộc trò chuyện Claude được sandbox-hóa, được khởi tạo từ bên trong một phiên Claude đang hoạt động thông qua công cụ Agent (Task). Phiên cha chỉ thấy báo cáo cuối cùng của subagent — không thấy các lời gọi công cụ trung gian, file reads hay quá trình suy nghĩ. Đây là khác biệt then chốt so với việc khởi chạy CLI thứ hai: cửa sổ context của phiên cha được bảo vệ khỏi tiếng ồn khám phá của subagent. Subagent được tạo ra cho nghiên cứu song song, khám phá sâu mã nguồn và thử nghiệm cô lập — những nơi bạn không muốn bộ nhớ làm việc của cha bị nhiễm bẩn."
  - q: "Khi nào KHÔNG nên dùng subagent và cứ làm việc trong phiên cha?"
    a: "Bỏ qua subagent cho các tra cứu vặt mà phiên cha đã có file mở hoặc context đã nạp, cho các chỉnh sửa tuần tự cần thấy từng trạng thái trung gian, và cho các thay đổi gắn kết chặt mà subagent cần giao tiếp qua lại (subagent là một-lần — chúng trả về một báo cáo duy nhất). Quy tắc kinh nghiệm: nếu bạn có thể trả lời nó trong ba lời gọi công cụ trở xuống từ trạng thái hiện tại, làm inline đi."
  - q: "Làm sao chạy nhiều subagent song song một cách an toàn?"
    a: "Gọi chúng trong một thông điệp với nhiều lời gọi Agent. Harness fan out chúng đồng thời. Lưu ý an toàn: truyền các phạm vi không trùng nhau (ví dụ 'subagent A audit /auth/, B audit /payments/'), tránh để hai subagent ghi cùng một file, và dùng git worktree khi subagent cần thực hiện chỉnh sửa không tầm thường lên code chồng lấp (mỗi worktree cho subagent một working tree riêng để tránh nhiễu)."
  - q: "Mode thất bại nào tôi cần đề phòng trong phát triển dựa trên subagent?"
    a: "Subagent trả về tóm tắt — chúng mô tả điều chúng định làm, không nhất thiết là điều chúng đã làm. Thất bại phổ biến nhất là coi báo cáo subagent là sự thật mà không xác minh. Luôn kiểm tra các thay đổi file thực tế (git diff) hoặc kết quả test, không phải tóm tắt văn xuôi. Một subagent tuyên bố 'tôi đã refactor module auth' có thể chỉ làm các chỉnh sửa nông pass type check nhưng phá hoạt động runtime."
  - q: "Tôi có thể tự xây dựng subagent chuyên biệt, hay phải bám vào các loại có sẵn?"
    a: "Claude Code hỗ trợ định nghĩa agent tùy chỉnh thông qua Agent SDK và file frontmatter agent. Bạn có thể ship một 'database-migration-reviewer' hay 'security-auditor' đặc thù cho team dưới dạng file markdown với description, system prompt và whitelist công cụ. Khi agent cha quyết định ủy thác, nó có thể chọn loại tùy chỉnh của bạn. Đây là cách team mã hóa các checklist review, cổng tuân thủ và chuyên môn lĩnh vực thành các persona agent tái sử dụng."
  - q: "Giá cả của Claude Code subagent hoạt động ra sao — tôi có trả riêng cho mỗi cái không?"
    a: "Mỗi lần gọi subagent tiêu thụ token như bất kỳ cuộc trò chuyện Claude nào khác. Chi phí xấp xỉ context đầy đủ của subagent (system prompt + schema công cụ + task prompt + suy nghĩ + báo cáo cuối). Trên gói Pro và Max, sử dụng subagent tính vào cùng quota sử dụng với phiên cha. Với người dùng API, chi phí là tính phí trực tiếp theo token. Tiết kiệm đến từ việc chuyển bớt khám phá đáng lẽ làm phình context cha — bạn trả cho subagent, nhưng phiên chính giữ được nhanh và tập trung."
---

## Giới thiệu

Cuối năm 2025, lập trình AI đơn luồng đụng tường. Bạn yêu cầu Claude "refactor module thanh toán", nó đọc 30 file, lấp đầy cửa sổ context bằng khám phá, rồi bắt đầu chỉnh sửa với một nửa bộ nhớ làm việc cần thiết. Nửa năm và một thay đổi paradigm sau, câu trả lời đơn giản đến đáng xấu hổ: **đừng làm mọi thứ trong một cuộc trò chuyện**.

Bài viết này điểm qua 5 mẫu Claude Code subagent đã chứng minh giá trị trong sử dụng production hàng ngày — từ quy trình của developer indie solo, đến team kỹ thuật nhiều người, đến pipeline nghiên cứu được AI hỗ trợ. Mỗi mẫu kèm hình dạng prompt thực tế, mode thất bại nó tránh, và đánh đổi bạn chấp nhận khi áp dụng. Không có gì lý thuyết. Đây là những mẫu chúng tôi dùng hàng ngày để ship nhanh hơn mà không đốt cháy cửa sổ context.

Nếu bạn đã dùng Claude Code qua [CLI chính thức](https://docs.anthropic.com/en/docs/claude-code) và muốn tốt nghiệp từ "một cuộc trò chuyện lớn" lên quy trình multi-agent có điều phối, đây là playbook. So sánh với [framework Superpowers](/vi/resources/llm-frameworks/superpowers/) và [mô hình solo-agent của Aider](/vi/vs/claude-code-vs-aider/) để xem cách tiếp cận subagent khác biệt về triết lý ra sao.

## Mẫu 1: Fan-Out Nghiên Cứu Song Song

**Vấn đề.** Bạn cần trả lời "trong codebase, X được xử lý ở đâu?", "mẫu của chúng ta cho Y là gì?", và "có ai đang dùng hàm Z đã deprecated không?" — ba câu hỏi độc lập. Làm tuần tự trong phiên cha nghĩa là ba vòng đọc file và ba lần inject vào cửa sổ context. Lúc bạn có cả ba câu trả lời, cha đã có 40k token output grep và không còn chỗ cho công việc thực.

**Mẫu.** Khởi tạo ba subagent Explore song song, mỗi câu hỏi một cái. Mỗi cái chạy trong context sandbox riêng. Mỗi cái trả về báo cáo ngắn. Cha thấy ba đoạn ngắn gọn thay vì ba đống grep.

```
Một thông điệp → 3 lời gọi Agent:
  - Agent("Tìm handler auth", subagent_type="Explore", prompt="...")
  - Agent("Map state management", subagent_type="Explore", prompt="...")
  - Agent("Tìm sử dụng fn Z deprecated", subagent_type="Explore", prompt="...")
```

**Mode thất bại tránh được.** Phình cửa sổ context. Phiên cha vẫn nhẹ và có thể chứa cuộc trò chuyện triển khai thực.

**Đánh đổi.** Bạn trả cho ba lần gọi subagent thay vì một cuộc trò chuyện cha. Đối với tìm kiếm không tầm thường, toán học thắng — subagent Explore fan out qua nhiều công cụ và chỉ trả về câu trả lời đã tổng hợp.

## Mẫu 2: Cô Lập Worktree Cho Chỉnh Sửa Rủi Ro

**Vấn đề.** Bạn muốn subagent thử một refactor, nhưng nếu nó đi lệch, bạn không muốn `git reset --hard` thủ công. Bạn cũng muốn subagent có thể chạy test mà không gây nhiễu với các thay đổi đang làm trong worktree chính.

**Mẫu.** Dùng tham số cô lập worktree trong lời gọi Agent. Subagent hoạt động trong một git worktree tạm thời rẽ nhánh từ trạng thái hiện tại. Nếu nó tạo thay đổi, bạn nhận lại đường dẫn worktree và có thể review, cherry-pick, hoặc loại bỏ thoải mái. Nếu không thay đổi gì, worktree tự dọn.

```
Agent({
  description: "Thử refactor cấp controller",
  isolation: "worktree",
  prompt: "Refactor controllers/orders.rb để trích logic xác thực..."
})
```

**Mode thất bại tránh được.** Refactor làm dở dang làm ô nhiễm working tree trước khi bạn có cơ hội đánh giá.

**Đánh đổi.** Một số kịch bản — như thêm một hàm đơn lẻ mà cha cần gọi ngay — không hưởng lợi từ cô lập worktree vì cuối cùng vẫn phải merge lại. Dành mẫu này cho thay đổi mang tính thăm dò hoặc rủi ro.

## Mẫu 3: Ủy Thác Chuyên Gia

**Vấn đề.** Code review, security audit, kiểm toán accessibility, và tối ưu SQL query — tất cả hưởng lợi từ tư duy tập trung khó duy trì khi bạn cũng đang viết feature. Claude tổng quát giỏi mọi việc này, nhưng prompt chuyên biệt làm tốt hơn.

**Mẫu.** Dùng tham số `subagent_type` để ủy thác cho chuyên gia. Subagent `code-reviewer` đọc diff và báo cáo phát hiện kèm mức độ tin cậy. security-auditor đọc cùng diff với kính threat-modeling. Bạn ở trong phiên cha tiếp tục xây feature.

```
Agent({
  description: "Code review độc lập",
  subagent_type: "code-reviewer",
  prompt: "Review thay đổi trên branch feat/payment-gateway. Muốn ý kiến
   thứ hai về logic retry — đã check idempotency nhưng muốn xác minh
   độc lập. Báo cáo: có an toàn dưới failure đồng thời không?"
})
```

**Mode thất bại tránh được.** Mù điểm "tôi viết nó nên chắc đúng". Một agent riêng không có context cuộc trò chuyện của bạn là thực sự độc lập.

**Đánh đổi.** Chuyên gia có toolkit hẹp hơn agent tổng quát. Đừng yêu cầu code-reviewer cũng tạo script migration.

## Mẫu 4: Bảo Vệ Cửa Sổ Context Cho Phiên Dài

**Vấn đề.** Bạn đã debug bốn giờ. Context cha nặng với stack trace, dump log, các nhánh giả thuyết ngõ cụt. Bạn cần "đi check cái gì đó" yêu cầu đọc 8 file. Làm inline sẽ đẩy bạn vào compression và bạn sẽ mất context tải-trọng giữ trạng thái debug lại với nhau.

**Mẫu.** Coi phiên cha như tầng chiến lược và đẩy mọi lặn thăm dò sang subagent. Cha nói "đi tìm ra X" — subagent trả về "câu trả lời là Y, bằng chứng một dòng đây". Trạng thái debug của bạn nguyên vẹn.

Đây là mẫu hồi vốn nhanh nhất. Một phiên debug hai giờ lẽ ra phải gặp compression context ở giờ 1 có thể chạy sạch suốt thời gian khi khám phá được offload.

**Mode thất bại tránh được.** Compression context sớm giữa debug, thường rơi mất triệu chứng gốc hoặc bước tái tạo then chốt.

**Đánh đổi.** Bạn mất khả năng "thấy" quá trình khám phá. Nếu báo cáo subagent không đầy đủ, bạn phải khởi tạo cái khác với prompt chặt hơn thay vì hỏi follow-up.

## Mẫu 5: Điều Phối Pipeline Với Agent Tùy Chỉnh

**Vấn đề.** Team bạn có checklist review 8 bước đã ghi tài liệu. Engineer junior bỏ qua bước 3, 5, 7 khi vội. Bạn muốn checklist được thực thi mà không trở thành cảnh sát PR review.

**Mẫu.** Mã hóa checklist thành subagent tùy chỉnh trong repo của bạn. Ai cài Claude Code đều gọi được. Checklist trở thành thực thi được: nó sinh báo cáo cấu trúc đối với từng bước.

```
.claude/agents/migration-reviewer.md  # định nghĩa subagent tùy chỉnh
.claude/agents/security-gate.md
.claude/agents/perf-budget-checker.md
```

Khi một thành viên team chạy orchestrator, nó có thể fan out cả ba: migration-reviewer audit SQL, security-gate audit auth touch, perf-budget-checker audit bất cứ gì chạm hot path request. Mỗi cái trả báo cáo cấu trúc. Orchestrator tổng hợp.

**Mode thất bại tránh được.** Trôi giữa "tiêu chuẩn review của team" và "cái thực sự được kiểm tra khi có ai vội".

**Đánh đổi.** Agent tùy chỉnh là tạo phẩm được version-control. Cần bảo trì như code khác. Lên lịch review quý hoặc chúng sẽ thối.

## Nguyên Tắc Nền Tảng

Cả năm mẫu chia sẻ một trực giác thiết kế: **cuộc trò chuyện cha là tài nguyên khan hiếm, và subagent là cách tiêu mà không kiệt nó**. Cha là nơi model làm suy nghĩ quan trọng. Subagent là cách nó nhận input mà không trả giá từ bộ nhớ làm việc.

Đây là đối lập với trực giác "một super-agent làm mọi thứ" thống trị 2024-đầu 2025. Mô hình đó sụp đổ dưới áp lực context. Câu trả lời 2026 là chuyên môn hóa được ủy thác với ranh giới thông tin nghiêm ngặt — một hội đồng nhỏ thay vì một đầu óc duy nhất.

## Thiết Lập Claude Code Sẵn Sàng Production

Để chạy quy trình multi-agent ở quy mô, bạn cần ba phần hạ tầng:

1. **Host đáng tin cậy cho phiên dài.** Nếu chạy Claude Code trong CI hoặc với codebase phía server, bạn cần VPS không drop SSH session hoặc bị throttle. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — VPS Hồng Kông với truy cập độ trễ thấp từ Trung Quốc đại lục và định tuyến BGP ổn định. Cùng IDC host dibi8.com, vậy chúng tôi chạy pipeline multi-agent riêng trên nó. Mức giá vững $5-12/tháng.

2. **Sân chơi cloud cho thử nghiệm song song.** Khi fan out 6+ subagent mỗi cái cần worktree riêng, bạn cần CPU dự phòng. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 tín dụng miễn phí 60 ngày qua 14+ region toàn cầu. Developer indie dùng cái này để host Claude Code orchestrator cùng app chính mà không tranh chấp tài nguyên.

3. **Skills bundle.** Nếu mới với Claude Code subagent, phần dốc nhất của đường cong là viết định nghĩa agent tùy chỉnh không đổ. Chúng tôi đóng gói năm skill đã được kiểm chứng thành bundle $19 trên Gumroad — xem CTA nổi ở góc — bao gồm các orchestrator prompt ship các mẫu trên.

## Đọc Liên Quan

- [OpenAI Codex CLI vs Claude Code](/vi/vs/openai-codex-cli-vs-claude-code/) — Cách tiếp cận solo-agent của Codex so với mô hình subagent của Claude Code.
- [Gemini CLI vs Claude Code](/vi/vs/gemini-cli-vs-claude-code/) — Chiến lược nghiên cứu song song của Gemini vs Claude Code subagent fan out.
- [Cursor vs Claude Code](/vi/vs/cursor-vs-claude-code/) — Agent nhúng IDE vs orchestrator chạy CLI.
- [Xếp Hạng MCP Servers 2026](/vi/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — Cách MCP server mở rộng năng lực subagent vượt tập công cụ đóng gói.
- [Bức Tranh AI Coding Agent](/vi/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) — Bức tranh hệ sinh thái rộng hơn.

## Kết Luận

Năm 2026, subagent không còn là tùy chọn. Nếu vẫn làm mọi tác vụ trong một cuộc trò chuyện Claude duy nhất, bạn đang trả tiền cho đặc quyền compression context sớm và mất trạng thái suy luận. Năm mẫu trên — fan out song song, cô lập worktree, ủy thác chuyên gia, bảo vệ context, điều phối pipeline — mỗi mẫu mất khoảng một giờ học, mỗi mẫu tiết kiệm bội số thời gian đó mỗi tuần.

Bắt đầu với Mẫu 1 (fan-out nghiên cứu song song) — đây là điểm áp dụng ít ma sát nhất và lợi ích đến ngay. Xếp lớp các mẫu khác khi phiên dài hơn và task nặng hơn.

Trực giác "cứ gõ tiếp vào phiên chính" chết khó. Đè nén nó. Khởi tạo subagent.
