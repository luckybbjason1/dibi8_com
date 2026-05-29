---
title: 'Viết Custom Agent cho Claude Code: Tạo Subagent Tái Sử Dụng Để Thực Thi Tiêu Chuẩn Của Bạn (2026)'
description: 'Hướng dẫn đầy đủ về cách viết custom subagent cho Claude Code — các trường frontmatter, thiết kế system prompt, danh sách công cụ được phép, và hai ví dụ sẵn sàng đưa vào sản xuất (trình duyệt migration, cổng bảo mật) cùng những lỗi cần tránh.'
date: 2026-05-28 00:00:00+08:00
lastmod: 2026-05-29 00:00:00+08:00
tech_stack: ['Claude Code', 'Agent SDK', 'CLI', 'Markdown', 'YAML']
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
tags: ['claude-code', 'subagents', 'custom-agents', 'agent-sdk', 'ai-coding-agents', 'llm-frameworks', 'developer-tools']
aliases:
- /posts/claude-code-custom-agent-authoring/
faq:
  - q: "Các tệp định nghĩa custom agent nằm ở đâu, và chúng có định dạng gì?"
    a: "Custom agent là các tệp Markdown có YAML frontmatter, được lưu trong .claude/agents/ ở dự án của bạn (hoặc ~/.claude/agents/ cho những agent bạn muốn dùng được trên mọi dự án). Tên tệp bỏ phần đuôi .md không phải là danh tính của agent — trường name trong frontmatter mới là. Frontmatter khai báo name, description, một danh sách tools tùy chọn, và một model tùy chọn; mọi thứ bên dưới dấu --- kết thúc chính là system prompt của agent."
  - q: "Sự khác biệt giữa trường description và phần thân system prompt là gì?"
    a: "Description là tín hiệu định tuyến: đó là thứ mà agent cha đọc khi quyết định có giao việc cho subagent này hay không, nên nó phải nói rõ KHI NÀO dùng agent, chứ không chỉ là nó là gì. Phần thân system prompt là tập chỉ dẫn mà subagent chạy theo một khi được gọi — vai trò, phương pháp, và hợp đồng đầu ra của nó. Một description xuất sắc đi kèm phần thân mơ hồ sẽ được gọi đúng lúc nhưng làm việc tầm thường; một phần thân xuất sắc đi kèm description mơ hồ sẽ làm việc tuyệt vời nhưng không bao giờ được kích hoạt."
  - q: "Tôi nên cho custom agent truy cập tất cả công cụ hay nên hạn chế chúng?"
    a: "Hạn chế chúng. Bỏ trống trường tools sẽ cấp toàn bộ tập công cụ kế thừa, tiện lợi nhưng nguy hiểm cho những agent lẽ ra không bao giờ được ghi hay thực thi — một code-reviewer có quyền Write và Bash có thể «nhiệt tình» áp dụng chính các đề xuất của nó, làm hỏng mục đích của một lần rà soát độc lập. Hãy khai báo mức tối thiểu: một reviewer dùng Read, Grep, Glob; một trình kiểm toán migration thêm vào đó một công cụ truy vấn cơ sở dữ liệu chỉ-đọc nếu bạn có. Đặc quyền tối thiểu giúp hành vi của agent có thể dự đoán được."
  - q: "Làm sao tôi kiểm thử một custom agent mà không làm bẩn dự án thật?"
    a: "Tạo một nhánh dùng-một-lần hoặc một git worktree với một ví dụ cố tình sai (một migration thiếu index, một thay đổi xác thực có lỗ hổng logic) rồi gọi agent vào đó. Bạn đang kiểm tra hai điều: nó có được kích hoạt bởi một yêu cầu tự nhiên không (chất lượng description), và nó có bắt được vấn đề đã cài cắm không (chất lượng system prompt). Hãy lặp tinh chỉnh frontmatter và phần thân riêng rẽ — chúng thất bại vì những lý do khác nhau."
  - q: "Một custom agent có thể gọi các subagent khác, hay tự sinh ra subagent của riêng nó không?"
    a: "Không. Subagent chỉ sâu một cấp — một subagent không thể sinh thêm subagent nữa. Đây là một rào chắn cố ý chống lại việc bùng nổ phân nhánh mất kiểm soát. Nếu bạn cần dàn dựng nhiều giai đoạn, agent cha (cấp cao nhất) sẽ điều phối: nó gọi agent A, đọc kết quả, rồi gọi agent B. Hãy thiết kế các custom agent của bạn thành những công nhân mục-đích-đơn trả về một báo cáo có cấu trúc, và để bộ điều phối ở trên cùng sắp xếp trình tự cho chúng."
  - q: "Custom agent có hoạt động trong CI và các lần chạy không-giao-diện không, hay chỉ tương tác?"
    a: "Chúng hoạt động ở cả hai. Cùng những định nghĩa trong .claude/agents/ sẽ được nhận diện khi bạn chạy Claude Code phi-tương-tác (chế độ -p / print dùng trong CI). Vì chúng là các tệp được quản lý phiên bản trong repo của bạn, mọi đồng nghiệp và mọi tác vụ CI đều thấy những định nghĩa agent y hệt nhau — đó chính là toàn bộ ý nghĩa của việc mã hóa một danh sách rà soát thành agent thay vì một trang wiki mà chẳng ai buồn mở."
---

## Giới thiệu

Trong bài [Các Mẫu Subagent của Claude Code](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) chúng ta đã trình bày năm quy trình để tiêu xài cửa sổ ngữ cảnh một cách khôn ngoan — và mẫu thứ năm, **dàn dựng pipeline với custom agent**, là mẫu mà các đội hỏi nhiều nhất. "Mã hóa danh sách rà soát của bạn thành một subagent" nghe rất hay, cho đến khi bạn mở một tệp `.claude/agents/migration-reviewer.md` trống trơn và một con trỏ nhấp nháy.

Hướng dẫn này chính là cuốn cẩm nang còn thiếu đó. Chúng ta sẽ đi qua cấu tạo giải phẫu của một định nghĩa custom agent, mỗi trường frontmatter thực sự điều khiển điều gì, cách viết một system prompt tạo ra báo cáo có cấu trúc thay vì lan man dài dòng, vì sao danh sách công cụ quan trọng hơn vẻ ngoài của chúng, và hai ví dụ hoàn chỉnh, sẵn sàng đưa vào sản xuất mà bạn có thể sao chép ngay hôm nay. Rồi đến những cái bẫy — vì các kiểu thất bại ở đây rất tinh vi, và chúng khiến bạn mất lòng tin vào agent ngay lần đầu nó bỏ sót một điều hiển nhiên.

Nếu bạn chưa từng giao việc cho một subagent, hãy đọc [bài về các mẫu](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) trước. Nếu bạn đã đọc rồi và sẵn sàng tự tay làm ra agent của riêng mình, đây chính là cuốn cẩm nang thực hành.

## Cấu Tạo Giải Phẫu Của Một Custom Agent

Một custom agent chỉ là một tệp Markdown duy nhất có YAML frontmatter. Nó nằm ở một trong hai nơi:

- `.claude/agents/<name>.md` — phạm vi dự án, được quản lý phiên bản, chia sẻ với cả đội của bạn
- `~/.claude/agents/<name>.md` — phạm vi người dùng, dùng được trên mọi dự án trên máy bạn

Cấu trúc cực kỳ đơn giản:

```markdown
---
name: migration-reviewer
description: Reviews database migrations for safety. Use when a PR touches db/migrate/, schema files, or any SQL DDL.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. Your job is to catch unsafe
migrations before they reach production...
```

Mọi thứ phía trên dấu `---` kết thúc đều là cấu hình. Mọi thứ phía dưới nó là **system prompt** — nhân cách và tập chỉ dẫn mà subagent chạy theo. Đó là toàn bộ hợp đồng. Không có bước build, không có đăng ký, không có manifest plugin. Thả tệp vào, chạy `/agents` để xác nhận Claude Code đã nhận ra nó, và nó đã có thể được gọi.

## Các Trường Frontmatter

Bốn trường làm hết mọi việc. Ba trong số đó là tùy chọn, nhưng các giá trị mặc định hiếm khi là điều bạn muốn cho một agent nghiêm túc.

### `name` (bắt buộc)

Danh tính của agent — đây là chuỗi mà agent cha truyền vào dưới dạng `subagent_type`. Hãy giữ nó ở dạng kebab-case và mang tính mô tả: dùng `security-auditor`, đừng dùng `agent2`. Tên tệp chỉ là bề mặt; trường `name` mới là nguồn chuẩn.

### `description` (bắt buộc — và là trường người ta đánh giá thấp)

Đây là **tín hiệu định tuyến**. Khi agent cha quyết định có giao việc hay không, nó đọc các description, chứ không phải system prompt. Vậy nên một description phải mã hóa *khi nào* nên tìm đến agent này, với các điều kiện kích hoạt cụ thể:

> ❌ `description: A code reviewer.`
> ✅ `description: Reviews code changes for correctness and security. Use proactively after writing a non-trivial diff, before committing, especially for auth, payments, or concurrency-sensitive code.`

Từ "proactively" (chủ động) là chịu lực — nó thúc agent cha gọi mà không cần được yêu cầu rõ ràng. Nếu agent của bạn dường như chẳng bao giờ khởi động, gần như luôn là vì description.

### `tools` (tùy chọn — nhưng cứ khai báo đi)

Một danh sách cho phép, phân tách bằng dấu phẩy. Bỏ qua nó và agent sẽ kế thừa mọi công cụ mà agent cha có. Chúng ta sẽ dành hẳn một mục để nói vì sao điều đó thường là sai.

### `model` (tùy chọn)

Ghim một bậc: `haiku` cho các lượt xử lý cơ học rẻ tiền, `sonnet` cho công việc rà soát cân bằng, `opus` cho suy luận sâu. Một agent kiểu linter chạy với khối lượng lớn đặt ở `haiku` sẽ giữ chi phí ở mức hợp lý; một trình kiểm toán bảo mật mà chỉ một lần bỏ sót đã đắt giá thì xứng đáng dùng `opus`.

## Viết System Prompt

Phần thân là nơi phần lớn agent thắng hay thua. Ba quy tắc tạo ra những công nhân đáng tin cậy:

**1. Nêu vai trò và ranh giới ngay câu đầu tiên.** "You are a migration reviewer. You do not write code or apply fixes — you report findings." Nói cho agent biết nó *không* được làm gì cũng quan trọng như chính công việc.

**2. Quy định hợp đồng đầu ra.** Prompt mơ hồ tạo ra văn xuôi; bạn muốn cấu trúc. Hãy viết nó ra rõ ràng:

```markdown
Report your findings as a list. For each issue:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM: one sentence
- FIX: the concrete change
End with a one-line VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

**3. Cho nó một danh sách kiểm tra, không phải một cảm giác.** "Rà soát về an toàn" là một điều ước. Hãy liệt kê chính xác từng thứ cần kiểm tra — agent sẽ đi qua danh sách của bạn một cách xác định, và đó chính là toàn bộ giá trị của việc mã hóa nó.

## Danh Sách Công Cụ: Đặc Quyền Tối Thiểu Cho Agent

Đây là cái bẫy. Để trống `tools`, và "reviewer" của bạn kế thừa `Write`, `Edit`, và `Bash`. Lần đầu tiên nó tìm thấy một vấn đề, nó có thể "nhiệt tình" sửa luôn — làm biến đổi cây làm việc của bạn, chạy lệnh, và phá hủy chính sự độc lập đã khiến lần rà soát này đáng để yêu cầu.

Giải pháp là đặc quyền tối thiểu. Hãy khớp công cụ với công việc:

| Loại agent | Công cụ |
| --- | --- |
| Reviewer / kiểm toán | `Read, Grep, Glob` |
| Nghiên cứu / thám hiểm | `Read, Grep, Glob, WebSearch, WebFetch` |
| Trình chạy test | `Read, Grep, Glob, Bash` |
| Trình sửa lỗi (hiếm, có chủ đích) | `Read, Edit, Bash` |

Một reviewer chỉ-đọc theo đúng nghĩa đen *không thể* nổi loạn. Chính sự dự đoán được đó là điều cho phép bạn tin báo cáo của nó mà không phải kiểm tra lại tất cả những gì nó chạm vào. (Nếu sau này bạn nối vào các hệ thống ngoài qua [MCP server](/vi/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/), kỷ luật tương tự cũng áp dụng — chỉ cấp những công cụ MCP mà agent thực sự cần.)

## Ví Dụ Thực Tế: Một Trình Duyệt Migration

```markdown
---
name: migration-reviewer
description: Reviews database migrations for production safety. Use proactively when a change touches db/migrate/, schema.rb, or any SQL DDL file.
tools: Read, Grep, Glob
model: sonnet
---

You are a database migration reviewer. You do NOT edit files or run
migrations — you read the proposed migration and report risks.

Check every migration against this list:
1. Adding a column with a NOT NULL constraint and no default on a large table (locks).
2. Adding an index without CONCURRENTLY (blocks writes).
3. Renaming or dropping a column still referenced by application code.
4. A data backfill running inside the same transaction as the schema change.
5. Missing a corresponding rollback / down path.

Report findings as:
- SEVERITY: blocker | warning | nit
- LOCATION: file:line
- PROBLEM / FIX
End with VERDICT: SAFE TO MERGE or NEEDS CHANGES.
```

Hãy gọi nó từ agent cha bằng một yêu cầu tự nhiên — "rà soát migration trên nhánh này" — và vì description nêu đích danh `db/migrate/`, agent cha sẽ tự định tuyến tới đó.

## Ví Dụ Thực Tế: Một Cổng Bảo Mật

```markdown
---
name: security-gate
description: Threat-models diffs that touch authentication, authorization, secrets, or user input. Use proactively before merging any auth or payments change.
tools: Read, Grep, Glob
model: opus
---

You are a security reviewer with a threat-modeling mindset. Assume the
input is hostile. You report only — you never modify code.

For the diff, check:
- Authn/authz: can this path be reached without the expected check?
- Injection: is user input concatenated into SQL, shell, or HTML?
- Secrets: any key, token, or password added to code or logs?
- IDOR: are object references scoped to the authenticated user?

For each finding give an EXPLOIT SKETCH (how an attacker triggers it),
then the FIX. Default to flagging when uncertain — false positives are
cheap, a missed auth hole is not.
```

Lưu ý bậc model `opus` và chỉ dẫn "default to flagging when uncertain" (khi không chắc chắn thì mặc định gắn cờ) — đối với một cổng bảo mật, bạn tinh chỉnh theo hướng hoang tưởng.

## Kiểm Thử Và Lặp Tinh Chỉnh Agent

Đừng đưa lên một agent mà bạn chưa thử lừa nó. Dựng một [git worktree](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) hoặc một nhánh dùng-một-lần với một vấn đề *được cài cắm* — một migration thiếu `CONCURRENTLY`, một endpoint thiếu kiểm tra quyền sở hữu — rồi gọi agent.

Bạn đang kiểm thử hai điều độc lập với nhau:

- **Nó có được kích hoạt** bởi một yêu cầu tự nhiên không? Nếu không, hãy sửa `description`.
- **Nó có bắt được con bug cài cắm không?** Nếu không, hãy sửa danh sách kiểm tra trong system prompt.

Hai điều này thất bại vì những lý do khác nhau, nên hãy lặp tinh chỉnh chúng riêng rẽ. Một bất ngờ thường gặp: agent hoạt động hoàn hảo khi bạn gọi đích danh nó nhưng chẳng bao giờ tự khởi động — đó luôn là vấn đề description, không bao giờ là vấn đề phần thân.

## Những Lỗi Viết Agent Thường Gặp

- **Description mơ hồ.** Agent làm việc tuyệt vời mà chẳng ai kích hoạt. Hãy thêm các đường dẫn tệp cụ thể và từ "proactively".
- **Không có danh sách công cụ.** Reviewer của bạn sửa luôn đoạn code mà lẽ ra nó phải rà soát. Hãy khai báo `Read, Grep, Glob`.
- **Đầu ra văn xuôi, không có hợp đồng.** Bạn nhận về ba đoạn ý kiến thay vì một danh sách phân loại theo mức độ. Hãy chỉ định chính xác định dạng báo cáo.
- **Một siêu-agent khổng lồ.** Một agent "làm tất cả mọi thứ" chẳng qua chỉ là agent cha kèm thêm vài bước thừa. Hãy chia tách theo mối quan tâm — đó chính là [mẫu giao việc cho chuyên gia](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) đang làm việc cho bạn.
- **Tạo xong rồi quên.** Agent là code. Một danh sách kiểm tra không được bảo trì sẽ mục rữa khi tech stack của bạn thay đổi. Hãy rà soát chúng mỗi quý.

## Nguyên Lý Cốt Lõi

Một custom agent chính là **tri thức tổ chức có thể thực thi được**. Cái tiêu chuẩn rà soát từng nằm trong một trang wiki không ai mở, hoặc trong đầu vị kỹ sư cấp cao duy nhất luôn bắt được bug — bạn mã hóa nó một lần, đưa vào quản lý phiên bản, và mọi đồng nghiệp cộng với mọi lần chạy CI đều có được cùng một reviewer y hệt, không biết mệt mỏi. Agent này sẽ không vì sát deadline mà vội vàng bỏ qua bước 3, 5, và 7. Chính sự nhất quán đó, chứ không phải trí thông minh thô, mới là chiến thắng.

## Thiết Lập Claude Code Cấp Sản Xuất

Để chạy các pipeline custom agent ở quy mô lớn, bạn cần hạ tầng ổn định:

1. **Một máy chủ đáng tin cậy cho các phiên chạy lâu dài và CI.** Custom agent tỏa sáng trong CI, nơi chúng làm cổng kiểm cho mọi PR. Bạn cần một cỗ máy không làm rớt tác vụ. **{{< aff "htstack" "footer-cta" "HTStack" >}}** — VPS Hong Kong, truy cập độ trễ thấp từ Trung Quốc đại lục và định tuyến BGP ổn định. Đó cũng chính là IDC đang lưu trữ dibi8.com, nên chúng tôi chạy các pipeline agent của mình ngay trên nó. Bậc giá hời chạy từ $5-12/tháng.

2. **Dư địa đám mây cho các cổng kiểm song song.** Khi một bộ điều phối phân nhánh ra migration-reviewer + security-gate + perf-checker cùng lúc, bạn muốn có CPU dự phòng. **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — $200 tín dụng miễn phí trong 60 ngày trải khắp 14+ khu vực, rất hợp để đặt các CI runner ngay cạnh ứng dụng của bạn.

3. **Một bộ kỹ năng (skills bundle).** Đoạn dốc nhất của đường cong là viết ra những định nghĩa agent không bị đổ vỡ. Chúng tôi đã đóng gói năm kỹ năng đã được thử lửa thành một bundle $19 trên Gumroad — xem nút CTA nổi ở góc màn hình — bao gồm các prompt cho bộ điều phối, cộng thêm ba định nghĩa agent nữa sẵn sàng đưa lên.

## Đọc Thêm

- [Các Mẫu Subagent của Claude Code](/vi/resources/llm-frameworks/claude-code-subagent-patterns-multi-agent-workflows-2026/) — năm quy trình; hướng dẫn này đào sâu vào mẫu số 5.
- [Khung Superpowers](/vi/resources/llm-frameworks/superpowers/) — một thư viện kỹ năng/agent được tuyển chọn để học hỏi.
- [Bảng Xếp Hạng MCP Server 2026](/vi/resources/llm-frameworks/mcp-servers-2026-rankings-selection-guide/) — mở rộng năng lực agent vượt ra ngoài các công cụ đi kèm.
- [Toàn Cảnh AI Coding Agent](/vi/resources/llm-frameworks/ai-coding-agent-landscape-2026-skills-mcp-opensource/) — vị trí của custom agent trong hệ sinh thái rộng lớn hơn.

## Kết Luận

Custom agent biến các thực hành tốt nhất của đội bạn từ tài liệu không ai đọc thành những lần kiểm tra chạy trên mọi thay đổi. Công thức là: một **description** sắc bén để nó được kích hoạt, một **danh sách công cụ đặc quyền tối thiểu** để nó ở yên trong phần việc của mình, và một **system prompt với danh sách kiểm tra rõ ràng cùng hợp đồng đầu ra** để nó tạo ra một báo cáo bạn có thể hành động dựa trên đó.

Hãy bắt đầu với một cái — trình duyệt migration ở trên là agent đầu tiên có đòn bẩy cao nhất cho phần lớn các đội. Cài một con bug vào, xác nhận nó bắt được, rồi commit tệp đó. Từ giây phút ấy, mọi đồng nghiệp đều có một reviewer không bao giờ mệt mỏi và không bao giờ bỏ qua một bước nào.
