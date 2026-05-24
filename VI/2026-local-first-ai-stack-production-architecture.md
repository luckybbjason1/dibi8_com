---
title: 'Local-First AI Stack 2026: Kiến trúc tham chiếu cho production (kèm 14 tool open-source)'
description: 'Kiến trúc tham chiếu hoàn chỉnh để build ứng dụng AI cấp production trong năm 2026 mà không bị khóa vào cloud — 7 layer, 14 tool open-source, kèm số liệu hiệu năng thực tế. Bao quát local LLM runtime, symbol-level code intelligence (CodeGraph), unified CLI control (CC Switch), cost-aware proxy (rtk), persistent agent memory (agentmemory/MemPalace), on-device TTS (Supertonic), và phương pháp luận 12-Factor Agents. Toàn bộ stack giúp bạn ship tính năng LLM theo cách scale được về mặt kinh tế.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: LLM Frameworks
source_version: ''
licensing_model: Mixed Open Source
license_type: Various (per-component)
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8 editorial team'
last_maintained: '2026-05-23'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['hub article', 'local-first-ai', 'production-ai', 'self-hosted-ai', 'ai-architecture', 'ai-stack-2026', 'agent-infrastructure', 'codegraph', '12-factor-agents', 'supertonic', 'cc-switch', 'rtk', 'agentmemory', 'mempalace', 'mcp', 'ds4', 'opencode', 'hermes-agent']
aliases:
- /vi/posts/2026-local-first-ai-stack-production-architecture/
---

## Vì sao "cứ gọi OpenAI là xong" không còn work nữa

Suốt hai năm qua, công thức thống trị để build sản phẩm có LLM bên trong vẫn là năm dòng Python quen thuộc: import OpenAI client, paste API key, viết system prompt, ship. Công thức đó vẫn ổn cho prototype. Nhưng nó không còn đủ cho sản phẩm cần scale, sản phẩm ở ngành bị regulated, sản phẩm ở khu vực mà API bị rate-limit hoặc không vào được, hoặc sản phẩm cần unit economics sống sót qua vòng Series A.

Thực tế production năm 2026:

- **Hóa đơn token nhân theo cấp số nhân** khi bạn phục vụ trên ~10K active user mỗi ngày.
- **Privacy và compliance** loại thẳng third-party API ra khỏi healthcare, legal, fintech, government, và danh sách enterprise vertical đang dài ra.
- **Biến động latency** giết chết UX agent real-time một khi bạn phụ thuộc vào cross-border API call.
- **Vendor risk** — mọi nhà cung cấp frontier model lớn đều đã từng có outage nhiều giờ, đổi giá đột ngột, hoặc đổi policy trong 18 tháng gần nhất.

Điều thay đổi trong năm 2026 không phải là local AI đột nhiên giỏi hơn hẳn — nó vẫn đang tiến bộ đều đặn từng tháng. Cái thay đổi là **toàn bộ stack open-source cần để thực sự ship local AI cho khách hàng trả tiền** cuối cùng đã ráp đủ mảnh. Bài này là kiến trúc tham chiếu cho stack đó: 7 layer, 14 tool open-source cụ thể, và cách chúng compose vào nhau.

---

## Học thuyết

Một local-first AI stack được build xoay quanh ba cam kết:

1. **Inference có thể chạy local HAY remote, nhưng ứng dụng tự quyết định mỗi request.** Không phải framework. Không phải SDK. Là app.
2. **Mọi layer đều open-weight và self-host được.** "Free tier" không đồng nghĩa với "open source." Một free tier mà bạn không thể self-host chính là hóa đơn tương lai.
3. **Không layer nào là hard dependency.** Mỗi mảnh đều có thể tháo ra thay mảnh khác mà không phải viết lại agent.

Bảy layer, từ trên xuống dưới, kèm tool open-source đại diện mà bạn nên xét đầu tiên cho mỗi layer:

| Layer | Chức năng | Tool tham chiếu |
|---|---|---|
| 7 — Methodology | Cách tư duy về agent | [12-Factor Agents](https://dibi8.com/vi/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) |
| 6 — Voice / Audio I/O | Speech in/out không cần cloud | [Supertonic](https://dibi8.com/vi/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/) |
| 5 — Memory / State | State bền vững của agent | [agentmemory](https://dibi8.com/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) + [MemPalace](https://dibi8.com/vi/resources/ai-tools/mempalace/) |
| 4 — Cost Control | Routing per-call + chặn budget | [rtk](https://dibi8.com/vi/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/) |
| 3 — Symbol Intelligence | Hiểu code | [CodeGraph](https://dibi8.com/vi/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/) |
| 2 — Agent Runtime / CLI | Tool call + control flow | [OpenCode](https://dibi8.com/vi/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/), [Hermes Agent](https://dibi8.com/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/), [Codex CLI](https://dibi8.com/vi/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/) — gom lại bởi [CC Switch](https://dibi8.com/vi/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) |
| 1 — LLM Runtime | Bản thân model, đang chạy | [So sánh Local LLM Runner](https://dibi8.com/vi/resources/llm-frameworks/local-llm-runner-comparison-2026/) + [ds4](https://dibi8.com/vi/resources/llm-frameworks/ds4-open-source-deepseek-alternative-2026/) |

Cộng thêm mô liên kết xuyên suốt mọi layer: **[MCP — Model Context Protocol](https://dibi8.com/vi/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/)** — chuẩn giao tiếp mà mỗi tool dùng để nói chuyện với tool kế tiếp.

---

## Layer 1 — Local LLM Runtime

Nền móng. Không có một local model dùng được, mọi layer phía trên đều rớt ngược về cloud proxy.

Những ứng viên đạt mức "production usable trong 2026" được phân tích chi tiết trong [bài so sánh local LLM runner](https://dibi8.com/vi/resources/llm-frameworks/local-llm-runner-comparison-2026/) — Ollama, LM Studio, vLLM, TGI, và ngôi sao đang lên [ds4 (DeepSeek-derivative open-source local model)](https://dibi8.com/vi/resources/llm-frameworks/ds4-open-source-deepseek-alternative-2026/).

Cái phân biệt một runtime production với một runtime cho hobby gói gọn trong ba thứ:

- **Concurrent serving** — xử lý hàng chục request đồng thời, không phải từng request một.
- **Quantization không làm tụt accuracy** — Q4/Q5 quantization vẫn giữ được 95%+ hiệu năng của model gốc trên use case của bạn.
- **API surface ổn định** không bị break mỗi lần lên minor version.

Với phần lớn team trong năm 2026, **vLLM cho serving + Ollama cho development** là cách chia thực tế nhất. ds4 là một lựa chọn model thú vị cho team muốn reasoning level DeepSeek mà không bị mập mờ về licensing khi chạy DeepSeek upstream trực tiếp.

---

## Layer 2 — Agent Runtime / CLI

Model đã load. Giờ phải có thứ điều khiển nó — gọi tool, parse response, loop cho tới khi xong.

Năm 2026 bạn có ba lựa chọn open-source đang sống và đã được team production thực sự deploy:

- **[OpenCode](https://dibi8.com/vi/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/)** — đối thủ open-source của Claude Code do cộng đồng dẫn dắt, 162K+ stars, multi-model.
- **[Hermes Agent](https://dibi8.com/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/)** — agent tự cải thiện của Nous Research, có primitive governance mạnh.
- **[Codex CLI](https://dibi8.com/vi/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/)** — viết lại bằng Rust, ba mode autonomy, kỷ luật tool-call sâu nhất.

Phần lớn team có quy mô đáng kể cuối cùng đều chạy *cả ba* — agent khác nhau cho job khác nhau. Điều đó tạo ra mớ config bùng nhùng, và đó là chỗ **[CC Switch](https://dibi8.com/vi/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/)** (74K+ stars) vào cuộc, cho bạn một control center duy nhất bao quát cả ba CLI trên cộng thêm Claude Code và Gemini CLI. Không có CC Switch thì bạn mất một tiếng mỗi tuần để hoà giải 5 file MCP config và API key khác nhau.

---

## Layer 3 — Symbol Intelligence

Khi agent cần hiểu code của bạn, `grep` + `Read` thô đốt rất nhiều token. Rất nhiều. Đây là layer mà phần lớn team chỉ phát hiện ra sau khi đã ship — thường là lúc hoá đơn tháng đầu tiên về tới.

**[CodeGraph](https://dibi8.com/vi/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/)** (20K+ stars) là câu trả lời open-source: một knowledge graph pre-index của symbol, quan hệ gọi hàm và framework route trong codebase, query được qua MCP trong vài mili giây. Số liệu báo cáo: tiết kiệm ~35% token mỗi session, ~70% ít tool call hơn.

Insight kiến trúc từ CodeGraph có thể tổng quát hoá: **bất kỳ dữ liệu nào agent sẽ query đi query lại về domain của bạn nên có một bề mặt query pre-index riêng, đừng tái dẫn xuất lại mỗi session**. Customer record, product catalog, ticket history — tất cả đều đáng có index theo phong cách CodeGraph riêng.

---

## Layer 4 — Cost Control / Routing

Kể cả khi đã có local model và symbol layer, agent vẫn sẽ gọi model bên ngoài vì lý do năng lực — Claude Opus cho reasoning hóc, Gemini Pro cho vision, GPT-4o cho một số tool đặc thù. Cost control layer route từng request: model rẻ trước, leo thang chỉ khi cần, cache mạnh tay.

**[rtk](https://dibi8.com/vi/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/)** là lựa chọn nhẹ nhất — một proxy CLI viết bằng Rust, cắm thẳng trước Claude Code (hoặc bất kỳ client tương thích OpenAI nào) và route request một cách thông minh. Báo cáo thực tế: giảm 60–90% token trên workload coding agent.

Với routing phức tạp hơn (A/B testing, ép budget, fallback chain), những gateway nặng hơn như LiteLLM hay Portkey vẫn work; chúng tôi đã có [bài so sánh LLM Gateway riêng](https://dibi8.com/vi/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/).

---

## Layer 5 — Memory và State

Agent stateless là một trần năng suất. Agent production phải biết nhớ — xuyên session, xuyên user, xuyên cuộc hội thoại.

Bức tranh open-source về agent memory trong 2026 được tổng hợp trong [bài viết về AI Agent Memory Systems](https://dibi8.com/vi/resources/llm-frameworks/ai-agent-memory-systems-2026/). Hai tool chúng tôi recommend hands-on:

- **[agentmemory](https://dibi8.com/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/)** — MCP-native, có benchmark thực tế, là "persistent memory cho AI coding agent" credible đầu tiên.
- **[MemPalace](https://dibi8.com/vi/resources/ai-tools/mempalace/)** — hướng tiếp cận "personal memory" tổng quát hơn, mạnh ở năng lực knowledge graph.

Cả hai đi theo cùng một pattern kiến trúc: vector store cho semantic recall, một lớp key-value có cấu trúc cho fact và quyết định, plus một MCP server để bất kỳ agent runtime nào cũng query được cả hai. Nguyên tắc 12-Factor "own your context window" (factor 3) áp dụng triệt để ở đây — memory là một phần của context mà chính bạn lắp ráp.

---

## Layer 6 — Voice và Audio I/O

Cho những agent giao tiếp với con người bằng giọng nói — không chỉ chatbot, mà còn trợ lý trên xe, công cụ accessibility, kiosk, readout giọng nói ở ngành regulated — TTS trên cloud là default lịch sử và là nút cổ chai cả về cost lẫn privacy.

**[Supertonic](https://dibi8.com/vi/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/)** (công ty Hàn Quốc Supertone Inc., 9.9K+ stars) là tool open-source on-device TTS credible nhất của 2026. 99M parameter, 31 ngôn ngữ bao gồm toàn bộ ngôn ngữ Á chủ lực, chạy trên CPU qua ONNX. License là MIT cho code, OpenRAIL-M cho model.

Cho ASR (speech in), Whisper.cpp vẫn là default open-source bền bỉ. Combo Supertonic + Whisper.cpp + local LLM là stack 2026 đầu tiên đem lại một voice agent hoàn toàn local với latency mức hội thoại.

---

## Layer 7 — Methodology

Stack tool tốt đến đâu cũng không tự nó ship được production agent. Bạn cần một cách *tư duy* về thiết kế — và đó là cái **[12-Factor Agents](https://dibi8.com/vi/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/)** (22K+ stars, do Dex Horthy của HumanLayer viết) đem lại. Mười hai nguyên tắc lấy cảm hứng từ tuyên ngôn 12-Factor App 2011 của Heroku, áp dụng cho phần mềm LLM.

Những factor chi phối trực tiếp các layer phía trên:

- **Factor 2: Own your prompts** → Layer 7 quản lý hành vi của Layer 2.
- **Factor 3: Own your context window** → Layer 5 (memory) phải sinh ra context mà ứng dụng kiểm soát.
- **Factor 4: Tools are structured outputs** → MCP ép buộc điều này xuyên suốt các layer.
- **Factor 8: Own your control flow** → Layer 2 không được là một agent runtime hộp đen.

Chúng tôi đã viết [walkthrough đầy đủ cả mười hai factor](https://dibi8.com/vi/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) — đó là tài liệu chúng tôi ước có được hai năm trước.

---

## Các layer compose như thế nào: Một request thật

Lần theo cái xảy ra khi user hỏi agent "tìm hết những chỗ đang authenticate qua LDAP server cũ và refactor sang module SSO mới":

1. **Layer 2 (Agent runtime)** nhận message của user.
2. **Layer 5 (Memory)** được query — agent có nhớ gì về dự án migration LDAP/SSO không? Inject mọi quyết định trước đó liên quan vào context.
3. **Layer 3 (Symbol intelligence)** được query qua MCP — "symbol nào match `LDAP` hoặc gọi `ldap_authenticate`?" CodeGraph trả lời trong 200ms.
4. **Layer 4 (Cost control)** chọn model — `rtk` route prompt planning qua local model rẻ trước.
5. **Layer 1 (Local LLM runtime)** thực thi plan. Nếu plan vượt khả năng của local model, `rtk` leo thang lên một frontier model.
6. **Layer 2** loop: với mỗi file CodeGraph chỉ ra, chạy một subtask edit. Mỗi subtask là một agent nhỏ, hẹp (Factor 10).
7. **Layer 6** (nếu đang ở voice mode): khi xong, Supertonic đọc lên "Refactor xong, 17 file thay đổi, 0 test fail."
8. **Layer 5** lưu kết quả lại cho session sau.

Mọi layer đều thay được. Mô liên kết — MCP — là chuẩn mà mỗi layer dùng để nói chuyện.

---

## Lộ trình triển khai thực tế

Phần lớn team không thể adopt cả bảy layer cùng lúc. Thứ tự chúng tôi đã thấy work:

### Pha 1 (Tuần 1–2): Cái nêm cost control
- Cắm **rtk** vào trước Claude Code / Cursor đang dùng.
- Cài **CC Switch** để gom config agent về một mối.
- Đọc trọn vẹn tuyên ngôn [12-Factor Agents](https://dibi8.com/vi/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/).

**Kết quả**: giảm 50%+ chi phí API mà không đổi gì về hành vi agent.

### Pha 2 (Tuần 3–4): Symbol Intelligence
- Cài **CodeGraph** trên codebase lớn nhất, đăng ký làm MCP server.
- Audit 5 query agent xuất hiện nhiều nhất — CodeGraph có cover được không?

**Kết quả**: symbol lookup dưới 1 giây, giảm thêm 30% token cho workflow Explore-heavy.

### Pha 3 (Tuần 5–8): Local Runtime
- Dựng **vLLM hoặc ds4** với Q5 quantization của model mục tiêu.
- Cấu hình **rtk** route 30% traffic về local. Đo chất lượng.
- Nếu chất lượng giữ vững, nâng lên 70%.

**Kết quả**: giảm chi phí mạnh; cloud spend chuyển thành ngoại lệ, không còn là default.

### Pha 4 (Quý 2): Memory và Voice
- Thêm **agentmemory** hoặc **MemPalace** để cho agent của bạn tính liên tục.
- Nếu có use case voice, đánh giá **Supertonic** cho TTS.

**Kết quả**: một stack có khả năng chạy hoàn toàn local. Bạn vẫn dùng cloud model cho năng lực frontier — nhưng không còn *phụ thuộc* vào chúng.

---

## Năm 2026 còn thiếu gì

Phải nói thẳng về những khoảng trống:

- **Agent observability open-source vẫn yếu.** Chưa có cái tương đương Datadog cho LLM agent trong thế giới OSS. LangSmith/Langfuse có tồn tại nhưng vẫn đang lớn dần.
- **Chưa có eval framework open-source đủ chín cho production.** "Agent đang work" có nghĩa là gì vẫn là thứ mỗi team phải tự đo bằng tay.
- **Giá GPU cho self-host serving** vẫn đòi hỏi capex hoặc thuê cloud GPU đắt đỏ. Bài toán kinh tế lật ngược ở scale lớn (~50K active user), nhưng team nhỏ vẫn phải trả premium.
- **Chất lượng voice cloning open-source** vẫn chậm hơn các API thương mại top khoảng một năm.
- **Pattern phối hợp multi-agent** còn rất sơ khai. Mỗi team đang tự phát minh lại.

Đây chính là những chỗ mà nhịp open-source kế tiếp đang nhắm tới.

---

## Phán quyết

Local-first AI stack 2026 không phải là "dùng một framework duy nhất" — nó là sự kết hợp có chủ đích của những mảnh open-source độc lập, thay thế được, ràng buộc với nhau qua MCP. Kết quả là một kiến trúc production:

- **Sống sót qua outage cloud** vì không phần nào trên critical path bị khoá vào cloud.
- **Scale theo cách kinh tế** vì chi phí tăng dưới-tuyến tính so với mức sử dụng.
- **Auditable mãi mãi** vì mỗi layer là code mở mà team bạn đọc được.
- **Compose tự nhiên** vì contract của mỗi layer là MCP, không phải một SDK độc quyền.

Mỗi component trong stack đều là một dự án open-source tập trung, được maintain tốt — không phải một startup đang chờ pivot. Học thuyết thì bảo thủ; nhưng nghịch lý là kết quả lại aggressive hơn phương án cloud-first, vì cost không còn là cái rate-limiter cho thứ bạn có thể build.

Nếu bạn bắt đầu hôm nay, cài rtk và CC Switch trong tuần này, đọc 12-Factor Agents, và thêm CodeGraph vào repo bạn dùng nhiều nhất trước cuối tháng. Phần còn lại sẽ tự đến.

---

**Toàn bộ stack trong một bảng** — bookmark cái này:

| # | Layer | Tool | Stars | License |
|---|---|---|---|---|
| 1 | LLM Runtime | [So sánh Local LLM Runner](https://dibi8.com/vi/resources/llm-frameworks/local-llm-runner-comparison-2026/) / [ds4](https://dibi8.com/vi/resources/llm-frameworks/ds4-open-source-deepseek-alternative-2026/) | tuỳ | Mixed OSS |
| 2 | Agent Runtime | [OpenCode](https://dibi8.com/vi/resources/llm-frameworks/opencode-open-source-claude-code-alternative-2026/) / [Hermes](https://dibi8.com/vi/resources/llm-frameworks/hermes-agent-self-improving-ai-agent/) / [Codex CLI](https://dibi8.com/vi/resources/llm-frameworks/openai-codex-cli-terminal-ai-coding-agent-2026/) | 100K+ mỗi cái | OSS |
| 2.5 | CLI Unification | [CC Switch](https://dibi8.com/vi/resources/dev-utils/cc-switch-unified-ai-cli-control-center-2026/) | 74K+ | OSS |
| 3 | Symbol Intelligence | [CodeGraph](https://dibi8.com/vi/resources/dev-utils/codegraph-pre-indexed-knowledge-graph-2026/) | 20K+ | MIT |
| 4 | Cost Control | [rtk](https://dibi8.com/vi/resources/llm-frameworks/rtk-rust-cli-proxy-llm-token-savings-2026/) | 45K+ | OSS |
| 5 | Memory | [agentmemory](https://dibi8.com/vi/resources/llm-frameworks/agentmemory-mcp-persistent-memory-2026/) / [MemPalace](https://dibi8.com/vi/resources/ai-tools/mempalace/) | 6.9K+ | OSS |
| 6 | Voice I/O | [Supertonic](https://dibi8.com/vi/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/) | 9.9K+ | MIT + OpenRAIL-M |
| 7 | Methodology | [12-Factor Agents](https://dibi8.com/vi/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) | 22K+ | Apache + CC BY-SA |
| ∗ | Connective | [MCP — Model Context Protocol](https://dibi8.com/vi/resources/llm-frameworks/mcp-deep-dive-definitive-2026-guide/) | n/a | Anthropic OSS |
