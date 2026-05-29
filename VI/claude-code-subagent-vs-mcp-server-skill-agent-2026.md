---
title: 'Subagent vs MCP Server vs Skill: Khi nào nên xây từng loại tiện ích mở rộng Claude Code (2026)'
description: 'Claude Code có ba điểm mở rộng — skill, subagent và MCP server — và chúng giải quyết những bài toán khác nhau. Một khung quyết định để chọn đúng loại, kèm các kịch bản thực tế và những anti-pattern khiến bạn mất thời gian vô ích.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'MCP', 'CLI']
application_domain: LLM Frameworks
source_version: ''
licensing_model: Commercial (Anthropic)
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
tags: ['claude-code', 'mcp', 'subagents', 'skills', 'agent-sdk', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/claude-code-subagent-vs-mcp-vs-skill/
faq:
  - q: "Khác biệt một câu giữa skill, subagent và MCP server là gì?"
    a: "Một skill dạy Claude CÁCH làm một việc (các chỉ dẫn và kiến thức được đóng gói, nạp vào ngữ cảnh), một subagent là AI làm việc đó (một công nhân được ủy thác với cửa sổ ngữ cảnh riêng), còn một MCP server là CÁI mà nó có thể chạm tới (một kết nối tới công cụ và dữ liệu bên ngoài). Skill thay đổi hành vi, subagent bảo vệ ngữ cảnh, MCP server bổ sung năng lực — ba trục khác nhau, không phải ba lựa chọn cạnh tranh nhau."
  - q: "Nếu tôi cần Claude truy vấn cơ sở dữ liệu nội bộ của công ty, thì đó là skill, subagent hay MCP server?"
    a: "Một MCP server. Bất cứ thứ gì nối Claude với một hệ thống bên ngoài — một cơ sở dữ liệu, một API nội bộ, một nền tảng SaaS, một hệ thống ticket — đều là một tích hợp, và tích hợp chính là lý do MCP server tồn tại. Một skill có thể ghi lại CÁCH diễn đạt các truy vấn tốt, và một subagent có thể là công nhân chạy phân tích trong môi trường cô lập, nhưng kết nối thực sự tới cơ sở dữ liệu là việc của MCP server. Bạn thường dùng cả ba cùng lúc."
  - q: "Khi nào nên viết một skill thay vì chỉ đặt chỉ dẫn vào CLAUDE.md?"
    a: "Dùng CLAUDE.md cho các quy tắc luôn bật, áp dụng toàn dự án, có hiệu lực với mọi tương tác. Viết một skill khi hướng dẫn mang tính tình huống — một quy trình nhiều bước, một playbook chuyên ngành, một checklist — mà bạn chỉ muốn nạp khi nó liên quan. Skill giữ cho ngữ cảnh nền của bạn gọn nhẹ: các chỉ dẫn chi tiết về «cách phát hành một bản release» chỉ đi vào cuộc hội thoại khi bạn thực sự đang phát hành, thay vì làm phình mọi prompt."
  - q: "Một subagent có thể dùng MCP server và skill không?"
    a: "Có. Một subagent chạy như một cuộc hội thoại Claude đầy đủ, nên nó thừa hưởng quyền truy cập các MCP server đã kết nối với phiên làm việc và có thể nạp các skill liên quan tới nhiệm vụ của nó. Đây là cách kết hợp phổ biến: một MCP server phơi bày cơ sở dữ liệu, một skill mã hóa phương pháp phân tích, và một subagent chạy toàn bộ trong ngữ cảnh cô lập để đầu ra truy vấn nặng nề không bao giờ làm ô nhiễm tiến trình cha. Ba lớp xếp chồng lên nhau."
  - q: "Tại sao không xây mọi thứ thành MCP server, vì chúng mạnh nhất?"
    a: "Vì MCP server là loại nặng nhất để xây và bảo trì — chúng là các tiến trình riêng với triển khai, xác thực và phiên bản riêng. Nếu nhu cầu của bạn là «Claude nên tuân theo checklist này» thì đó là một skill (một tệp markdown). Nếu là «hãy khám phá điều này mà không làm phình ngữ cảnh của tôi» thì đó là một subagent (một tệp markdown). Vớ lấy một MCP server khi một skill là đủ chính là over-engineering: bạn đã giao một dịch vụ để giải quyết một bài toán tài liệu."
  - q: "Skill, subagent và MCP server có hoạt động trong chế độ CI / headless không?"
    a: "Có, cả ba. Skill và subagent là các tệp được quản lý phiên bản trong repo của bạn, nên CI tự động nhận chúng. MCP server cần được cấu hình và truy cập được từ môi trường CI (thông tin xác thực trong CI secrets, quyền truy cập mạng tới dịch vụ). Chế độ headless -p tôn trọng cả ba; điểm vướng thực tế duy nhất là đảm bảo phần xác thực của MCP server hoạt động được mà không cần đăng nhập tương tác khi chạy không giám sát."
---

## Giới thiệu

Đến năm 2026, Claude Code có ba cách riêng biệt để mở rộng — **skill**, **subagent** và **MCP server** — và câu hỏi phổ biến nhất chúng tôi nhận được là «tôi nên xây cái nào?». Sự nhầm lẫn là dễ hiểu: cả ba đều là «cách giúp Claude làm được nhiều hơn», và marketing làm chúng nhòe vào nhau. Nhưng chúng nằm trên ba trục hoàn toàn khác nhau, và chọn sai loại đồng nghĩa với việc hoặc over-engineering (cả một server cho thứ chỉ cần một tệp markdown) hoặc đâm vào tường (một skill không thể thực sự chạm tới cơ sở dữ liệu của bạn).

Bài viết này trao cho bạn một khung quyết định. Chúng ta sẽ định nghĩa từng điểm mở rộng trong một dòng, đi qua trục mà mỗi loại tác động, chạy ba kịch bản thực tế từ đầu đến cuối, và chỉ ra những anti-pattern khiến bạn mất cả một cuối tuần. Nếu bạn đã đọc [Hướng dẫn viết Custom Agent](/vi/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) và [Bảng xếp hạng MCP Servers 2026](/vi/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/), thì đây là bài gắn kết tất cả lại với nhau.

## Ba điểm mở rộng, mỗi loại một dòng

- **Skill** — dạy Claude *cách* làm một việc. Các chỉ dẫn đóng gói, một playbook, một checklist, chỉ nạp vào ngữ cảnh khi liên quan.
- **Subagent** — *ai* làm việc đó. Một công nhân được ủy thác với cửa sổ ngữ cảnh riêng, được sinh ra để giữ cho cuộc hội thoại cha gọn nhẹ (xem [các mẫu subagent](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/)).
- **MCP server** — *cái* mà nó có thể chạm tới. Một kết nối tới hệ thống bên ngoài: một cơ sở dữ liệu, một API, một công cụ SaaS, một nguồn dữ liệu.

Nói thành một câu là sự nhầm lẫn tan biến: **một skill thay đổi hành vi, một subagent bảo vệ ngữ cảnh, một MCP server bổ sung năng lực.** Chúng không phải ba câu trả lời cho một câu hỏi. Chúng là câu trả lời cho ba câu hỏi khác nhau.

## Trục mà mỗi loại tác động

### Skill tác động trục «kiến thức»

Một skill là câu trả lời cho *«Claude không biết quy trình cụ thể của chúng ta.»* Quy trình phát hành của bạn, bộ tiêu chí review code của bạn, runbook xử lý sự cố của bạn — kiến thức mang tính tình huống. Bạn không muốn nó nằm trong `CLAUDE.md` (vì nó nạp ở mọi tương tác và làm phình ngữ cảnh nền); bạn muốn nó chỉ được nạp khi nhiệm vụ cần. Một skill là một tệp markdown với một mô tả trigger; khi công việc khớp, các chỉ dẫn chi tiết đi vào cuộc hội thoại, còn nếu không thì chúng đứng ngoài, không vướng víu.

### Subagent tác động trục «ngữ cảnh»

Một subagent là câu trả lời cho *«công việc này sẽ làm nổ cửa sổ ngữ cảnh của tôi.»* Kiến thức có thể đã sẵn ở đó; vấn đề là làm việc đó ngay tại chỗ — đọc 30 tệp, chạy một phiên khám phá dài — sẽ chèn lấn phần suy luận mà bạn thực sự quan tâm. Một subagent chạy nó trong một ngữ cảnh riêng và chỉ trả về kết luận. Không có gì về *năng lực* thay đổi; cái thay đổi là *bộ nhớ làm việc của ai* phải trả giá cho việc khám phá.

### MCP server tác động trục «năng lực»

Một MCP server là câu trả lời cho *«Claude theo nghĩa đen là không thể chạm tới hệ thống này.»* Cơ sở dữ liệu Postgres của bạn, API số liệu nội bộ của bạn, tài khoản Stripe của bạn, bảng Linear của bạn. Không lượng skill hay subagent nào triệu hồi nổi một kết nối cơ sở dữ liệu — đó là một năng lực mới thực sự, và năng lực đến từ MCP server. Đây cũng là loại nặng nhất trong ba: một tiến trình riêng với việc triển khai, xác thực và quản lý phiên bản phải tự gánh.

## Một khung quyết định

Hãy hỏi những câu sau theo thứ tự:

1. **«Claude có cần chạm tới một hệ thống mà hiện nó không thể không?»** → **MCP server.** (Cơ sở dữ liệu, API, SaaS, dữ liệu bên ngoài.)
2. **«Claude đã có năng lực rồi, nhưng công việc sẽ làm phình ngữ cảnh của tôi?»** → **Subagent.** (Khám phá quy mô lớn, nghiên cứu song song, thí nghiệm cô lập.)
3. **«Claude có năng lực và có ngữ cảnh, nhưng không biết cách làm cụ thể của chúng ta?»** → **Skill.** (Playbook, checklist, quy trình.)

| Nếu vấn đề là... | Hãy xây một... | Vì sao |
| --- | --- | --- |
| Không chạm được tới hệ thống | MCP server | Năng lực mới |
| Ngữ cảnh sẽ nổ tung | Subagent | Bảo vệ bộ nhớ làm việc |
| Không biết quy trình của ta | Skill | Kiến thức tình huống |
| Tiêu chuẩn không bao giờ được thực thi | Subagent (custom agent) | Review thực thi được, quản lý phiên bản |

Lựa chọn rẻ nhất giải quyết được vấn đề của bạn gần như luôn là lựa chọn đúng. Một tệp markdown (skill hoặc subagent) thắng một dịch vụ đã triển khai (MCP server) mỗi khi nó có thể làm được việc.

## Kịch bản thực tế 1: «Rà soát codebase của chúng ta tìm SQL injection»

- **Năng lực?** Đọc code — Claude đã có. Không cần MCP server.
- **Ngữ cảnh?** Rà soát toàn bộ codebase nghĩa là đọc hàng chục tệp. Việc đó *sẽ* làm phình tiến trình cha. → **Subagent.**
- **Quy trình?** Bạn muốn cuộc rà soát tuân theo checklist cụ thể của OWASP. → **Skill** (hoặc nướng checklist đó vào system prompt của một custom agent `security-auditor`).

**Đáp án:** một subagent `security-auditor` có system prompt mã hóa checklist. Một tạo phẩm, bao trùm hai trục. Không cần server.

## Kịch bản thực tế 2: «Cho tôi xem khách hàng nào đã rời bỏ tháng trước»

- **Năng lực?** Dữ liệu đó nằm trong warehouse của bạn. Claude không chạm tới được. → **MCP server** (một MCP warehouse/SQL).
- **Ngữ cảnh?** Một tập kết quả lớn có thể nhiễu. → chạy truy vấn bên trong một **subagent** chỉ trả về phần tóm tắt.
- **Quy trình?** «Rời bỏ» có một định nghĩa cụ thể ở công ty bạn. → một **skill** ghi lại logic truy vấn churn.

**Đáp án:** cả ba, kết hợp lại. MCP server kết nối, skill định nghĩa «rời bỏ», subagent chạy nó gọn gàng. Đây là trường hợp full-stack kinh điển.

## Kịch bản thực tế 3: «Đảm bảo mọi bản release đều theo đúng checklist của chúng ta»

- **Năng lực?** Git, đọc tệp — đã sẵn. Không cần server.
- **Ngữ cảnh?** Nhẹ. Không nhất thiết cần subagent để bảo vệ.
- **Quy trình?** Đây chính là toàn bộ vấn đề — các bước release của đội bạn. → **Skill**, hoặc một custom agent nếu bạn muốn nó *thực thi* và xuất ra một báo cáo.

**Đáp án:** một skill (hoặc một custom agent kiểm soát release). Xây một MCP server ở đây sẽ là over-engineering thuần túy.

## Anti-pattern

- **Cái bẫy MCP-server-cho-mọi-thứ.** Giao một dịch vụ để giải quyết một bài toán tài liệu. Nếu bạn không kết nối với hệ thống bên ngoài, có lẽ bạn không cần một server. (Duyệt [sổ đăng ký MCP server](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) để xem cái gì thực sự đáng làm server.)
- **CLAUDE.md phình to.** Nhồi mọi quy trình vào ngữ cảnh luôn bật. Hãy chuyển các playbook tình huống vào skill để ngữ cảnh nền của bạn luôn sắc bén.
- **Mega-subagent.** Một subagent «làm mọi thứ» chỉ là tiến trình cha với một bộ nhớ tệ hơn. Hãy chia theo mối quan tâm.
- **Skill mà thật ra cần một năng lực.** Viết một skill đẹp đẽ cho «phân tích số liệu của chúng ta» trong khi Claude không thể chạm tới số liệu. Không chỉ dẫn nào thay thế được kết nối MCP còn thiếu.

## Nguyên tắc

Ba điểm mở rộng ánh xạ tới ba tài nguyên: **kiến thức** (skill), **ngữ cảnh** (subagent) và **năng lực** (MCP server). Hãy chẩn đoán xem bạn thực sự đang thiếu tài nguyên nào, và lựa chọn sẽ tự lộ ra. Phần lớn các đội với tay quá đà tới MCP server vì chúng nghe có vẻ mạnh, trong khi một tệp markdown đã có thể giao cùng kết quả trước giờ ăn trưa. Hãy xây thứ nhẹ nhất tác động được vào cái trục mà bạn đang mắc kẹt.

## Thiết lập Claude Code sẵn sàng cho môi trường production

Chạy cả ba lớp — đặc biệt là MCP server — ở quy mô lớn đòi hỏi hạ tầng ổn định:

1. **Một host đáng tin cậy cho MCP server và CI.** MCP server là các tiến trình chạy lâu dài; bạn cần một máy luôn hoạt động. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — VPS Hồng Kông với truy cập độ trễ thấp tới Trung Quốc đại lục và BGP ổn định. Cùng IDC đang host dibi8.com, nơi chúng tôi chạy chính các MCP server và pipeline agent của mình. Gói giá trị $5-12/tháng.

2. **Dư địa cloud cho các lớp song song.** Khi subagent tỏa ra và MCP server chạy song hành, bạn cần CPU dự phòng. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 tín dụng miễn phí trong 60 ngày trên 14+ khu vực.

3. **Một bộ skill.** Cách nhanh nhất để thấm nhuần sự phân tách skill/subagent/server là nghiên cứu các ví dụ thực chiến. Chúng tôi đã đóng gói năm skill đã được kiểm chứng thành một bộ $19 trên Gumroad — xem nút CTA nổi ở góc — bao gồm các định nghĩa custom agent và các orchestrator prompt kết hợp cả ba lớp.

## Đọc thêm

- [Hướng dẫn viết Custom Agent](/vi/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) — cách thực sự xây nửa subagent.
- [Các mẫu Subagent](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — năm workflow cho trục ngữ cảnh.
- [Bảng xếp hạng MCP Servers 2026](/vi/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — chọn lớp năng lực.
- [Hướng dẫn sổ đăng ký MCP Server](/vi/resources/llm-frameworks/mcp-server-registry-comprehensive-guide-2026/) — danh mục những gì đáng kết nối.

## Kết luận

Hãy thôi hỏi «skill, subagent, hay MCP server?» như thể chúng cạnh tranh nhau. Thay vào đó hãy hỏi: tôi đang thiếu **kiến thức**, **ngữ cảnh**, hay **năng lực**? Kiến thức → skill. Ngữ cảnh → subagent. Năng lực → MCP server. Các trường hợp full-stack dùng cả ba, xếp chồng lên nhau. Và khi còn phân vân, hãy xây tạo phẩm rẻ nhất tác động được vào trục của bạn — một tệp markdown thắng một dịch vụ đã triển khai mỗi khi nó làm được việc.
