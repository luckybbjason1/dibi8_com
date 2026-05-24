---
title: 'Đánh giá ViMax: Sinh video đa cảnh theo kiểu agentic từ HKUDS (Đạo diễn · Biên kịch · Nhà sản xuất · Bộ sinh video, 2026)'
description: 'ViMax (7.1K+ stars trên GitHub) của Hong Kong University Data Science Lab là framework agentic video generation mã nguồn mở đầu tiên được cộng đồng đón nhận rộng rãi. Thay vì prompt-to-video một phát ăn ngay như Sora hay Runway, nó điều phối bốn vai AI — Đạo diễn, Biên kịch, Nhà sản xuất, Bộ sinh video — để tạo video đa cảnh dài hơi từ một ý tưởng duy nhất. Phân tích đầy đủ pipeline agentic, các backend hỗ trợ (Gemini Flash, MiniMax, Google Veo), các bước cài đặt, workflow idea-to-video và script-to-video, cùng so sánh thẳng thắn với Sora, OpenSora, Runway.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/HKUDS/ViMax'
stars: 7100
maintainer: 'HKUDS'
last_maintained: '2026-05-20'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['vimax', 'agentic-video', 'ai-video-generation', 'hkuds', 'multi-agent', 'veo', 'long-form-video', 'video-ai', 'open-source-video', 'rag-screenwriting']
aliases:
- /vi/posts/vimax-agentic-video-generation-multi-agent-2026/
---

## Ba giới hạn đã chặn đứng AI video trong 2025

Mọi tool AI video generation lọt vào tầm mắt người tiêu dùng trong 2024–2025 — Sora, Runway Gen-3, Pika, Luma Dream Machine, OpenSora — đều dính chung ba giới hạn:

1. **Chỉ làm được clip ngắn.** 5–10 giây là trần thực tế. Dài hơn là tính nhất quán sụp đổ.
2. **Loạn nhất quán.** Cùng một nhân vật mà mặt thay đổi giữa các shot. Cùng một căn phòng mà đồ đạc xếp lại. Pipeline single-prompt không có khái niệm "con chó này y hệt cảnh 1."
3. **Output chỉ có hình.** Không kịch bản, không cấu trúc câu chuyện, không audio đồng bộ. Bạn nhận được những hình đẹp biết chuyển động; bạn không nhận được một *bộ phim*.

Với clip social media, các giới hạn này còn chịu được. Với bất cứ ai muốn dùng AI để *thật sự kể chuyện* — video giải thích, nội dung giáo dục, narrative thương hiệu — pipeline vỡ ngay khi user muốn cảnh 2 nối logic từ cảnh 1.

**[ViMax](https://github.com/HKUDS/ViMax)** (GitHub: `HKUDS/ViMax`, **7,100+ stars** tính đến tháng 5/2026) của Hong Kong University Data Science Lab là nỗ lực mã nguồn mở được cộng đồng đón nhận đầu tiên phá ba giới hạn đó bằng cách coi việc sinh video là *bài toán điều phối multi-agent*, không phải bài toán sinh một phát ăn ngay.

Tagline của họ nói thẳng: **"Director, Screenwriter, Producer, and Video Generator All-in-One."**

---

## Bốn vai agentic

Cú đặt cược kiến trúc của ViMax: sản xuất video ngoài đời là pipeline đa vai, vậy sản xuất video bằng AI cũng nên thế. Framework định nghĩa bốn vai agent tự chủ, mỗi vai có một tác vụ do LLM dẫn dắt:

### 🎬 Biên kịch (Screenwriter)
Nhận một ý tưởng cấp cao ("một con mèo và một con chó trở thành bạn, rồi gặp một con mèo mới") và tạo ra *kịch bản có cấu trúc đầy đủ* — nhân vật, phân đoạn cảnh, đối thoại, chuyển cảnh. Dùng một **RAG-based long script engine** có thể chia câu chuyện dài thành dạng đa cảnh một cách thông minh. Đây là lớp khiến những video dài hơn một phút trở nên mạch lạc.

### 🎭 Đạo diễn (Director)
Dịch kịch bản thành *storyboard cấp shot*. Quyết định setup nhiều camera, framing, nhịp độ, chuyển cảnh. Output là mô tả shot rõ ràng để bộ sinh phía dưới có thể render.

### 🎯 Nhà sản xuất (Producer)
Bộ máy đảm bảo nhất quán. Chọn ảnh tham chiếu, xác minh cùng một nhân vật trông giống nhau qua các shot, điều phối tài nguyên, chạy kiểm tra nhất quán bằng MLLM (multimodal LLM). Đây là lớp giải quyết bài toán "nhân vật bị xáo trộn."

### 🎥 Bộ sinh video (Video Generator)
Lớp render cuối cùng. Sinh các shot song song, tổng hợp ảnh cho từng frame, ghép frame thành video. Phần sinh pixel thật được giao xuống các model nền (Veo, v.v.).

Mỗi vai là một LLM agent riêng với prompt riêng, context window riêng, và hợp đồng output deterministic riêng — một ứng dụng sách giáo khoa của [12-Factor Agents](https://dibi8.com/vi/resources/llm-frameworks/12-factor-agents-production-llm-software-2026/) factor 10 ("small, focused agents").

---

## Tech Stack

- **Ngôn ngữ**: Python 3.12, quản lý bằng `uv`.
- **Framework multi-agent**: Lớp orchestration tự xây.
- **Chat models hỗ trợ**: Google Gemini 2.5 Flash Lite (qua OpenRouter), MiniMax-M2.7 (1M context), MiniMax-M2.5 (204K context). Context window dài rất quan trọng — agent Biên kịch cần giữ toàn bộ kịch bản trong bộ nhớ làm việc.
- **Sinh ảnh**: Google Nanobana API.
- **Sinh video**: Google Veo qua API.
- **License**: MIT — code thoáng; API model thượng nguồn đi kèm điều khoản thương mại riêng.

Việc giao phần sinh pixel cho các API thương mại (Veo, Nanobana) là quyết định thẳng thắn. Các model video mã nguồn mở chưa đuổi kịp chất lượng hình ảnh của các model thương mại đầu bảng, và giả vờ ngược lại sẽ làm hỏng demo. Đóng góp của ViMax là *phần điều phối* — bring your own pixel engine.

---

## Cài đặt nhanh

```bash
git clone https://github.com/HKUDS/ViMax.git
cd ViMax
uv sync
```

Vậy là xong phần dependency. Bạn cần API key cho ít nhất một chat model (OpenRouter cho Gemini chạy được) và các API Google Veo + Nanobana cho phần sinh video/ảnh.

### Workflow Idea-to-Video

```python
idea = "If a cat and a dog are best friends, what would happen when they meet a new cat?"
user_requirement = "For children, do not exceed 3 scenes."
style = "Cartoon"
# Run: python main_idea2video.py
```

Biên kịch mở rộng ý tưởng thành kịch bản 3 cảnh. Đạo diễn lên kế hoạch shot. Nhà sản xuất chọn ảnh tham chiếu và áp tính nhất quán. Bộ sinh video render từng cảnh và ghép lại.

### Workflow Script-to-Video

Với người dùng đã có sẵn kịch bản, `main_script2video.py` nhận kịch bản trực tiếp và bỏ qua bước Biên kịch. Ba agent còn lại vẫn chạy.

---

## Khác gì so với Sora, Runway, OpenSora

| Khía cạnh | ViMax | Sora / Runway / OpenSora |
|---|---|---|
| **Pipeline** | Multi-agent (Script → Storyboard → Assets → Video) | Prompt thẳng → video |
| **Narrative** | Sinh kịch bản có cấu trúc dựa trên RAG | Single-prompt; không cấu trúc kịch bản |
| **Tính nhất quán** | Agent Producer + check MLLM + chọn ảnh tham chiếu | Frame drift giữa các shot |
| **Độ dài** | Đa cảnh, vài phút+ | Clip dài vài giây |
| **Kiểm soát sáng tạo** | Override theo từng agent (viết lại kịch bản, làm lại storyboard) | Hạn chế; chủ yếu chỉnh sửa hậu kỳ |
| **Audio** | Buộc audio-video đồng bộ | Tập trung chính vào video |
| **Mã nguồn mở** | Có (MIT) | OpenSora có; Sora/Runway không |

Phản biện thẳng thắn: Sora và Runway có chất lượng pixel mỗi shot trông rõ ràng đẹp hơn. ViMax thắng ở *tính mạch lạc giữa các shot*. Nếu bạn cần demo công nghệ 10 giây, Sora thắng. Nếu bạn cần video explainer 90 giây mà con chó vẫn phải y hệt con chó ở cảnh 4, sự điều phối của ViMax mới là thứ bạn cần.

---

## Những điều ViMax KHÔNG phải

Để hiệu chỉnh kỳ vọng:

- **Không phải model video mã nguồn mở hoàn toàn.** Nó điều phối các cuộc gọi tới model video/ảnh thương mại. Self-host end-to-end phải chờ lớp model video mở đuổi kịp.
- **Không phải tool no-code.** Giao diện hiện tại là script Python và file config. Phần agentic tinh vi; UX là "prototype của researcher."
- **Chưa có bản release chính thức.** 329 commit trên main, không có tag release. Hãy chuẩn bị tâm lý API sẽ thay đổi.
- **Không có benchmark hiệu năng trong README.** ViMax quảng bá lợi thế *định tính* (nhất quán, độ dài, narrative); ablation định lượng chưa được công bố.
- **Phụ thuộc Google API.** Veo và Nanobana không miễn phí cũng không mở. Hãy tính trước chi phí.

---

## Use case thực tế

Nơi pipeline agentic của ViMax thực sự tạo khác biệt:

- **Video giáo dục / explainer** — đa cảnh, nhân vật liên tục, cấu trúc narrative. Định dạng kinh điển "giọng giáo viên cộng minh họa hoạt hình."
- **Nội dung cho trẻ em** — truyện ngắn với nhân vật nhất quán qua các cảnh (chính là use case ví dụ trong README).
- **Storyboard marketing** — sinh đầy đủ kịch bản + storyboard từ brief chiến dịch, rồi để team marketing duyệt trước khi tới bước sinh (đắt hơn).
- **Nội dung social dài hơi** — TikTok / Reels 60–90 giây với micro-narrative mạch lạc (so với clip single-shot 5 giây đã bão hòa feed).
- **Pre-visualization cho phim/TV** — previs giá phải chăng nhưng tôn trọng tính nhất quán của nhân vật cho việc lên kế hoạch sản xuất thật.

Với mỗi cái trên, lựa chọn thay thế *không có* ViMax hoặc là sản xuất người tốn kém, hoặc là tool AI short-clip không thể sustain một câu chuyện.

---

## ViMax đứng ở đâu trong bối cảnh AI video 2026

Ghép ViMax với:
- **Image generator** — đã tích hợp sẵn (Nanobana), nhưng bạn có thể đổi sang Stable Diffusion / ComfyUI cho [workflow sinh ảnh self-hosted](https://dibi8.com/vi/resources/ai-tools/comfyui-architecture-node-based-ai-image/).
- **TTS cho voiceover** — [Supertonic](https://dibi8.com/vi/resources/ai-tools/supertonic-on-device-multilingual-tts-2026/) cho giọng đa ngôn ngữ on-device; ghép với ViMax thành video có narration tích hợp đầy đủ.
- **LLM long-context** — context 1M của MiniMax-M2.7 là lựa chọn thực tế cho kịch bản phim đầy đủ. Nguyên lý 12-Factor "own your context window" áp dụng — agent Biên kịch chính là chỗ kỷ luật context có ý nghĩa nhất.

Bộ ba ViMax + Supertonic + sinh ảnh mã nguồn mở là thứ năm 2026 đến gần nhất với pipeline "tả một bộ phim, nhận lại một bộ phim" mà phần lớn nằm trong tầm kiểm soát của người dùng.

---

## Ai nên thử ViMax

**Cài nếu bạn:**
- Cần video mạch lạc về narrative dài hơn 30 giây.
- Chấp nhận trả phí Google API cho bước sinh cuối nhưng muốn phần điều phối nằm trong tầm kiểm soát.
- Đang nghiên cứu workflow sáng tạo multi-agent và muốn một implementation tham chiếu.
- Xây tool nội dung cho khách hàng và muốn pipeline có thể tạo draft trong vài phút để con người review.

**Bỏ qua nếu bạn:**
- Cần video single-shot 10 giây và Sora/Runway vẫn ổn với bạn.
- Không thoải mái với tooling Python cấp researcher.
- Cần self-host end-to-end hoàn toàn (hãy chờ thêm một vòng nữa của các model video mở).

---

## Kết luận

ViMax là bằng chứng đáng tin nhất của 2026 rằng **bước nhảy tiếp theo về chất lượng AI video không phải là model to hơn — mà là điều phối tốt hơn**. Bằng cách coi sản xuất video là bài toán multi-agent với các vai Đạo diễn, Biên kịch, Nhà sản xuất, và Bộ sinh tách biệt, HKUDS mở khoá video dài hơi mạch lạc — thứ mà diffusion model single-prompt về căn bản không thể đem lại.

License MIT, hậu thuẫn học thuật của HKUDS, cùng 7,100 stars chỉ trong vài tháng cho thấy đây là tool mà cộng đồng video mã nguồn mở đã chờ đợi. Còn sớm — chưa có release chính thức, không benchmark, phụ thuộc cứng vào API thương mại — nhưng kiến trúc đi đúng hướng. Hãy chờ pattern này (điều phối agentic các model sinh) lan ra mọi ngành dọc AI sáng tạo trong 12 tháng tới.

Nếu bạn từng sản xuất một video có kịch bản, đây là workflow AI cuối cùng cũng map đúng với cách công việc thực sự diễn ra.

---

**GitHub**: [HKUDS/ViMax](https://github.com/HKUDS/ViMax) · **License**: MIT · **Stars**: 7.1K+ · **Tác giả**: Hong Kong University Data Science Lab · **Trạng thái**: Đang phát triển tích cực, chưa có tag release
