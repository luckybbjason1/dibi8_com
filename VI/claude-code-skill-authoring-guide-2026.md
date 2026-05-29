---
title: 'Viết Skill cho Claude Code: Cách Đóng Gói Quy Trình Mà Claude Chỉ Nạp Khi Cần (2026)'
description: 'Hướng dẫn đầy đủ về việc viết skill cho Claude Code — cấu trúc SKILL.md, trường description điều khiển việc nạp, tiết lộ tăng dần (progressive disclosure), và khi nào một skill vượt trội hơn CLAUDE.md hay một subagent. Kèm ví dụ thực tế và những sai lầm cần tránh.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'Markdown', 'YAML']
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
tags: ['claude-code', 'skills', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools', 'prompt-engineering']
aliases:
- /posts/claude-code-skill-authoring/
faq:
  - q: "Skill nằm ở đâu và một SKILL.md tối thiểu cần những gì?"
    a: "Một skill là một thư mục nằm dưới .claude/skills/<name>/ (phạm vi dự án) hoặc ~/.claude/skills/<name>/ (phạm vi người dùng), chứa một file SKILL.md. Mức tối thiểu là phần frontmatter YAML với một name và một description, theo sau là các chỉ dẫn trong phần thân. Thư mục cũng có thể chứa các file hỗ trợ — tài liệu tham khảo, script, template — mà skill trỏ tới, nhưng SKILL.md với hai trường frontmatter đó chính là phần lõi không thể giản lược."
  - q: "Khác biệt giữa một skill và việc chỉ đưa chỉ dẫn vào CLAUDE.md là gì?"
    a: "CLAUDE.md được nạp trong từng lượt tương tác — nó dành cho các quy tắc luôn-bật, áp dụng toàn dự án. Một skill chỉ nạp khi description của nó khớp với nhiệm vụ trước mắt. Hãy dùng CLAUDE.md cho «luôn dùng tab, không bao giờ commit trực tiếp lên main». Hãy dùng một skill cho các quy trình tình huống như «cách phát hành một bản release» hay «cách gỡ lỗi một test chập chờn» — kiến thức bạn không muốn nó làm phình mọi prompt, mà chỉ hiện diện khi bạn thực sự làm việc đó. Skill giữ cho context nền của bạn gọn nhẹ."
  - q: "Trường description điều khiển thời điểm nạp một skill như thế nào?"
    a: "Description chính là tín hiệu kích hoạt. Claude đọc các description của skill để quyết định skill nào phù hợp với nhiệm vụ hiện tại, rồi nạp toàn bộ phần thân của skill đó vào context. Vì vậy description phải mô tả KHI NÀO dùng skill bằng những gợi ý cụ thể — «Dùng khi phát hành release, xuất bản một phiên bản, hay gắn tag một bản build» — chứ không chỉ nói nó là gì. Một description mơ hồ («trợ thủ release») nghĩa là skill tồn tại nhưng không bao giờ kích hoạt đúng thời điểm."
  - q: "Tiết lộ tăng dần (progressive disclosure) là gì và tại sao nó quan trọng với skill?"
    a: "Tiết lộ tăng dần nghĩa là skill nạp file SKILL.md nhẹ nhàng trước, và chỉ kéo vào các file hỗ trợ nặng hơn (tài liệu tham khảo chi tiết, template lớn, script) khi nhiệm vụ thực sự cần đến. Bạn giữ SKILL.md ngắn gọn và trỏ tới references/big-spec.md để lấy chi tiết sâu. Cách này bảo vệ context: phần kích hoạt và tổng quan rẻ để nạp khi định tuyến, còn chi tiết tốn kém chỉ đi vào cuộc trò chuyện khi skill đã thực sự được kích hoạt."
  - q: "Một skill có thể bao gồm script hay chỉ chỉ dẫn?"
    a: "Cả hai. Một thư mục skill có thể đóng gói kèm script (một helper Python, một shell script), template, và tài liệu tham khảo bên cạnh SKILL.md. Phần thân có thể chỉ dẫn Claude chạy một script đi kèm hoặc đọc một tài liệu tham khảo đi kèm. Đây chính là cách một skill trở thành nhiều hơn một prompt — nó là một năng lực được đóng gói với chỉ dẫn, tài liệu tham khảo, và các helper thực thi được, tất cả cùng được quản lý phiên bản trong một thư mục."
  - q: "Khi nào tôi nên viết một subagent thay vì một skill?"
    a: "Hãy viết một skill khi bạn cần dạy một quy trình chạy trong cuộc trò chuyện hiện tại. Hãy viết một subagent khi công việc cần cửa sổ context riêng của nó — khám phá nặng, nghiên cứu song song, hay đánh giá độc lập mà nếu không sẽ làm phình context cha. Chúng kết hợp được với nhau: một subagent có thể nạp một skill để tuân theo phương pháp của bạn trong khi chạy biệt lập. Quy tắc kinh nghiệm từ khung quyết định mở rộng — skill thay đổi hành vi, subagent bảo vệ context, MCP server thêm năng lực."
---

## Giới thiệu

Trong [Subagent vs MCP vs Skill](/vi/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/) chúng tôi đã vẽ ra tấm bản đồ ba trục: skill dịch chuyển trục **kiến thức**, subagent dịch chuyển trục **context**, MCP server dịch chuyển trục **năng lực**. Từ đó chúng tôi đã xuất bản các hướng dẫn chuyên sâu về trục subagent — [viết custom agent](/vi/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) và [các kiểu thất bại khi điều phối](/vi/resources/llm-frameworks/multi-agent-pipeline-postmortem-5-failures-2026/). Hướng dẫn này hoàn thiện bộ ba: cách viết chính bản thân **skill**.

Skill là thứ bị đánh giá thấp nhất trong bộ ba bởi vì nó trông có vẻ tầm thường — "nó chỉ là một file markdown thôi mà." Nhưng một skill được viết tốt là khác biệt giữa kiến thức *có sẵn đúng lúc bạn cần* và một `CLAUDE.md` phình to đến mức mọi prompt phải kéo theo 4.000 token quy tắc mà chẳng nhiệm vụ nào hiện cần. Chúng ta sẽ bàn về cấu trúc SKILL.md, trường description quyết định tất cả, tiết lộ tăng dần để giữ nó nhẹ nhàng, hai ví dụ thực tế, và những sai lầm khiến skill không bao giờ kích hoạt.

## Một Skill Thực Chất Là Gì

Một skill là một **thư mục**, không chỉ là một file:

```
.claude/skills/cut-release/
  SKILL.md            # frontmatter + instructions
  references/
    versioning.md     # heavy detail, loaded on demand
  scripts/
    bump-version.sh    # an executable the skill can run
```

`SKILL.md` là điểm vào. Phần frontmatter của nó khai báo danh tính của skill và — quan trọng nhất — *khi nào nó nên nạp*. Phần thân giữ quy trình. Các file hỗ trợ (tài liệu tham khảo, template, script) nằm bên cạnh và chỉ được kéo vào khi cần. Skill nằm trong `.claude/skills/` (dự án, chia sẻ với cả nhóm) hoặc `~/.claude/skills/` (người dùng, áp dụng cho mọi dự án trên máy của bạn).

## Skill vs CLAUDE.md: Câu Hỏi Về Thời Điểm Nạp

Đây là quyết định khiến nhiều người vấp ngã. Cả hai đều giữ chỉ dẫn; khác biệt nằm ở *khi nào chúng nạp*.

- **CLAUDE.md** nạp trong **mọi** lượt tương tác. Nó dành cho các bất biến luôn-bật, áp dụng toàn dự án: "dùng tab," "không bao giờ force-push main," "API base của chúng ta là X."
- **Một skill** chỉ nạp **khi description của nó khớp** với nhiệm vụ hiện tại. Nó dành cho các quy trình tình huống: "cách phát hành release," "cách khởi tạo một service mới," "runbook xử lý sự cố của chúng ta."

Phép thử: *chỉ dẫn này có áp dụng cho một prompt ngẫu nhiên về bất cứ thứ gì không?* Nếu có → CLAUDE.md. Nếu nó chỉ quan trọng trong một loại nhiệm vụ cụ thể → skill. Nhồi các playbook tình huống vào CLAUDE.md là sai lầm gây phình context số một; mọi prompt phải trả giá cho kiến thức nó không cần.

## Phần Frontmatter: Name và Description

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a new version, tagging a build, or preparing release notes. Walks through version bump, changelog, tag, and publish steps.
---

You are helping cut a release. Follow these steps in order...
```

### `name`

Kebab-case, mang tính mô tả. Đây là danh tính của skill.

### `description` — tín hiệu kích hoạt quyết định tất cả

Claude đọc các description của skill để định tuyến: nó quét chúng, quyết định skill nào hợp với nhiệm vụ hiện tại, rồi nạp phần thân của skill đó. Vậy nên description không phải là một cái nhãn — nó là một **điều kiện khi-nào-kích-hoạt**. Hãy nhồi vào đó những trigger cụ thể:

> ❌ `description: Release helper.`
> ✅ `description: Use when cutting a release, publishing a version, tagging a build, or writing release notes. Covers version bump, changelog generation, git tag, and publish.`

Cái đầu tiên không bao giờ kích hoạt vì chẳng có gì trong một nhiệm vụ thực tế khớp với "release helper." Cái thứ hai kích hoạt ngay khoảnh khắc người dùng nói "let's ship 2.4.0." Nếu skill của bạn tồn tại nhưng không bao giờ kích hoạt, thủ phạm chính là description — lần nào cũng vậy.

## Viết Phần Thân: Một Quy Trình, Không Phải Một Bài Luận

Phần thân là các chỉ dẫn mà Claude tuân theo một khi skill được nạp. Ba quy tắc:

1. **Hãy là một quy trình, không phải văn xuôi.** Các bước được đánh số để mô hình thực thi theo thứ tự sẽ hơn hẳn những đoạn văn chứa context. "1. Bump version trong package.json. 2. Tái tạo changelog từ các commit kể từ tag gần nhất. 3. ..."
2. **Nêu các điều kiện tiên quyết và cạm bẫy ngay tại chỗ.** "Trước khi gắn tag, hãy xác nhận CI đã xanh trên main" — đúng kiểu điều mà một con người sẽ biết phải kiểm tra.
3. **Trỏ tới chi tiết nặng, đừng đưa nó vào trực tiếp.** Nếu chính sách versioning dài 800 từ, hãy đặt nó trong `references/versioning.md` và viết "để biết quy tắc bump version, đọc references/versioning.md." Đó chính là tiết lộ tăng dần, phần kế tiếp.

## Tiết Lộ Tăng Dần: Giữ SKILL.md Nhẹ Nhàng

Nước đi đỉnh cao trong việc viết skill. SKILL.md nên **nhỏ** — phần kích hoạt cộng với tổng quan cộng với các con trỏ. Phần nội dung nặng nằm trong các file hỗ trợ chỉ nạp khi nhiệm vụ chạm tới chúng.

Tại sao điều này quan trọng: description và tổng quan cần phải rẻ, vì chúng được quét để định tuyến. Bản đặc tả chi tiết 2.000 từ chỉ nên thuộc về context một khi skill đã thực sự được kích hoạt và nhiệm vụ cần độ sâu đó. Một skill nhồi mọi thứ vào trong sẽ đi ngược lại mục đích — bạn lại quay về kiểu phình như CLAUDE.md, chỉ là được kích hoạt theo cách khác.

```markdown
## Steps
1. Bump version (see references/versioning.md for the semver rules)
2. Run scripts/changelog.sh to generate the draft
3. ...
```

Claude chỉ đọc `references/versioning.md` khi nó thực sự cần các quy tắc đó, chứ không phải trong mọi lần nạp.

## Ví Dụ Thực Tế: Một Skill Checklist Phát Hành

```markdown
---
name: cut-release
description: Use when cutting a release, publishing a version, or tagging a build. Covers version bump, changelog, tag, publish, and the green-CI precondition.
---

You are cutting a release. Do NOT skip the precondition check.

PRECONDITION: confirm CI is green on main. If not, stop and report.

Steps:
1. Determine the new version (semver; see references/versioning.md).
2. Bump it in package.json and any version constants.
3. Generate the changelog from commits since the last tag.
4. Open a release PR; wait for review.
5. After merge: tag, push the tag, publish.

Report which step you stopped at if anything blocks.
```

Điều kiện tiên quyết và dòng "báo cáo bạn đã dừng ở đâu" chính là thứ làm cho nó đạt chuẩn sản xuất — không chỉ là các bước, mà là những lan can an toàn mà một con người cẩn trọng sẽ áp dụng.

## Ví Dụ Thực Tế: Một Skill Playbook Theo Lĩnh Vực

```markdown
---
name: debug-flaky-test
description: Use when a test passes sometimes and fails other times, or when investigating CI flakiness, intermittent failures, or race conditions in the suite.
---

You are diagnosing a flaky test. Flakiness is almost always one of:
shared state, timing/async, test-order dependence, or external resources.

1. Reproduce: run the test 20x in isolation and 20x with the full suite.
   Different results = test-order or shared-state dependence.
2. Check for unawaited async, real timers, and fixed sleeps.
3. Check for shared mutable state between tests.
4. Only after locating the cause, propose the fix. Do not "add a retry."
```

Hãy lưu ý kiến thức lĩnh vực được nhúng vào (bốn nguyên nhân thường gặp) — đó là chuyên môn tích lũy của tổ chức, được đóng gói sao cho bất cứ ai cũng có thể kích hoạt danh sách kiểm tra trong đầu của một kỹ sư kỳ cựu.

## Những Sai Lầm Thường Gặp Khi Viết Skill

- **Description mơ hồ.** Skill tồn tại nhưng không bao giờ kích hoạt. Hãy thêm các cụm trigger cụ thể — chính những từ mà người dùng thực sự gõ khi họ cần nó.
- **Đổ mọi thứ vào CLAUDE.md.** Các quy trình tình huống làm phình mọi prompt. Hãy chuyển chúng sang skill.
- **Đưa chi tiết nặng vào trực tiếp.** Một SKILL.md dài 2.000 từ. Hãy dùng tiết lộ tăng dần — trỏ tới `references/`.
- **Văn xuôi thay vì quy trình.** Một skill đọc như một bài luận. Hãy đánh số các bước.
- **Không có lan can an toàn.** Các bước không có điều kiện tiên quyết hay điều kiện dừng. Hãy thêm những kiểm tra mà một con người cẩn trọng sẽ làm.

## Nguyên Lý

Một skill là **chuyên môn đúng lúc (just-in-time)**. CLAUDE.md là những gì luôn đúng; một skill là những gì đúng *khi bạn đang làm chính việc cụ thể này*. Nghệ thuật nằm ở description (để nó kích hoạt đúng thời điểm) và ở tiết lộ tăng dần (để nó vẫn rẻ cho tới khi cần đến). Làm đúng hai điều đó và các quy trình của nhóm bạn sẽ thôi nằm trong những wiki chẳng ai mở — chúng hiện ra, nạp đầy đủ, đúng lúc nhiệm vụ cần đến, và lui ra khỏi đường khi không cần.

## Thiết Lập Một Môi Trường Claude Code Sẵn Sàng Cho Sản Xuất

Skill tỏa sáng nhất trong một môi trường ổn định, được chia sẻ:

1. **Một host đáng tin cậy cho các luồng công việc chia sẻ trong nhóm, được gọi từ CI.** Skill được quản lý phiên bản và cũng chạy trong CI. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — VPS Hồng Kông, truy cập độ trễ thấp vào đại lục Trung Quốc, BGP ổn định. Cùng IDC đang host dibi8.com. 5-12 USD/tháng.

2. **Dư địa đám mây cho các lượt chạy song song.** **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — 200 USD tín dụng miễn phí trong 60 ngày, hơn 14 khu vực.

3. **Một bộ skill (skills bundle).** Cách nhanh nhất để viết skill hay là đọc những skill hay. Chúng tôi đã đóng gói năm skill đã được kiểm chứng thực chiến thành một bundle 19 USD trên Gumroad — xem nút CTA nổi ở góc màn hình — với phần description, cấu trúc tiết lộ tăng dần, và các script đi kèm đã được làm chuẩn xác.

## Bài Đọc Liên Quan

- [Subagent vs MCP vs Skill](/vi/resources/llm-frameworks/claude-code-subagent-vs-mcp-server-skill-agent-2026/) — khung ba trục mà bài này hoàn thiện.
- [Viết Custom Agent](/vi/resources/llm-frameworks/claude-code-custom-agent-authoring-guide-2026/) — bài chị em theo trục subagent của hướng dẫn này.
- [Hướng Dẫn Nhà Phát Triển về AI Agent Skills 2026](/vi/resources/llm-frameworks/ai-agent-skills-2026-developer-guide/) — hệ sinh thái skill rộng hơn.
- [Các Kiểu Mẫu Subagent](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — cách skill kết hợp với các worker được ủy thác.

## Kết Luận

Skill là điểm mở rộng rẻ nhất, bị đánh giá thấp nhất — một thư mục với một file markdown biến chuyên môn tình huống thành context đúng lúc. Toàn bộ kỹ nghệ này thu gọn về hai điều: một **description** được nhồi đầy những cụm trigger thực tế để nó kích hoạt đúng thời điểm, và **tiết lộ tăng dần** để nó vẫn nhẹ nhàng cho tới khi nhiệm vụ cần đến độ sâu của nó. Viết tốt hai điều đó và bạn đã đóng gói được một quy trình mà cả nhóm bạn — cùng mọi lượt chạy CI — đều nhận được miễn phí, đúng lúc nó phù hợp. Điều đó hoàn thiện bộ ba: skill cho kiến thức, subagent cho context, MCP server cho năng lực.
