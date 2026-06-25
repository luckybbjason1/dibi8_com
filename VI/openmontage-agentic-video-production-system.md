---
lang: vi
slug: openmontage-agentic-video-production-system
title: "Đánh giá OpenMontage: Hệ thống Sản xuất Video Tự chủ Mã Nguồn Mở Đầu tiên trên Thế giới (52 Công cụ, 12 Quy trình, Hơn 500 Kỹ năng)"
description: "OpenMontage (8.3K+ GitHub stars) is the world's first open-source, agentic video production system. 12 production pipelines, 52 tools, 500+ agent skills. Turn any AI coding assistant into a full video studio — from animated explainers to cinematic trailers to real-footage documentaries. Zero API keys needed for basic output."
date: "2026-06-22 00:00:00+08:00"
lastmod: "2026-06-22 00:00:00+08:00"
tech_stack:
  - Python 3.10+
  - FFmpeg
  - Node.js 18+
  - Remotion
  - HyperFrames
  - Piper TTS
application_domain: AI Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/calesthio/OpenMontage'
last_maintained: '2026-06-21'
draft: false
categories: ['ai-tools']
tags: ["mởmontage", "video có tính chủ động", "sản xuất video bằng AI", "sự di chuyển", "khung siêu", "tạo video", "mã nguồn mở", "claude-code", "con trỏ", "đa tác nhân", "phim tài liệu", "hoạt hình"]
aliases:
- /posts/openmontage-agentic-video-production-system/
faqs:
  - q: 'OpenMontage là gì?'
    a: 'OpenMontage là hệ thống sản xuất video tác nhân nguồn mở đầu tiên trên thế giới với 12 quy trình sản xuất, 52 công cụ sản xuất và hơn 500 kỹ năng tác nhân. Nó biến bất kỳ trợ lý lập trình AI nào (Claude Code, Cursor, Copilot, Windsurf hoặc Codex) thành một studio sản xuất video hoàn chỉnh. Khác với các bộ tạo video chỉ bằng một lệnh như Sora hay Runway, OpenMontage điều phối một quy trình sản xuất đầy đủ — nghiên cứu, viết kịch bản, tạo tài sản, chỉnh sửa và tổng hợp cuối cùng — thông qua các bản khai quạt quy trình có cấu trúc và các kỹ năng đạo diễn giai đoạn.'
  - q: 'OpenMontage khác Sora, Runway và Pika như thế nào?'
    a: 'Sora, Runway và Pika là các trình tạo video từ một lệnh đơn, tạo ra các clip ngắn (5-30 giây) không có cấu trúc câu chuyện, không có kịch bản và không có âm thanh. OpenMontage là một hệ thống điều phối sản xuất: nó thực hiện nghiên cứu trực tuyến trực tiếp, viết kịch bản, tạo hoặc tìm kiếm tài sản (hình ảnh, video, nhạc, lồng tiếng), biên tập mọi thứ thành một dòng thời gian mạch lạc, thêm phụ đề từng từ, và thực hiện kiểm tra chất lượng nhiều điểm. Nó sản xuất các video hoàn chỉnh với bất kỳ độ dài nào, không chỉ các clip riêng lẻ.'
  - q: 'Tôi có cần khóa API trả phí để sử dụng OpenMontage không?'
    a: 'Không. Ngay khi cài đặt xong, `make setup` cung cấp cho bạn Piper TTS (chuyển văn bản thành giọng nói miễn phí ngoại tuyến), tư liệu từ Archive.org/NASA/Wikimedia Commons, thành phần Remotion, hậu kỳ FFmpeg và phụ đề tự động tạo. Bạn có thể sản xuất các video có lồng tiếng thực sự mà không tốn chi phí. Các khóa API trả phí (FLUX, Kling, Google Veo, ElevenLabs, Suno) mở khóa các tài nguyên chất lượng cao hơn nhưng hoàn toàn tùy chọn. Hệ thống đánh giá từng nhà cung cấp theo 7 khía cạnh và chọn nhà cung cấp phù hợp nhất với ngân sách của bạn.'
  - q: '12 quy trình sản xuất là gì?'
    a: '12 quy trình là: Giải thích Hoạt hình, Hoạt hình, Người phát ngôn Avatar, Điện ảnh, Nhà máy Clip, Phim Tài liệu, Hỗn hợp, Bản địa hóa & Lồng tiếng, Tái sử dụng Podcast, Trình diễn Màn hình, Đầu nói chuyện, và Hoạt hình Nhân vật. Mỗi quy trình đều theo cùng một luồng cấu trúc: nghiên cứu → đề xuất → kịch bản → kế hoạch cảnh → tài sản → chỉnh sửa → biên soạn. Mỗi giai đoạn đều có một kỹ năng đạo diễn riêng (tệp hướng dẫn Markdown) dạy cho tác nhân chính xác cách thực hiện.'
  - q: 'OpenMontage có thể làm video từ cảnh quay thực, chứ không chỉ từ hình ảnh AI không?'
    a: 'Vâng. Quy trình Documentary Montage xây dựng một tập hợp dữ liệu có thể tìm kiếm bằng CLIP từ các nguồn miễn phí và mở (Archive.org, NASA, Wikimedia Commons, Pexels, Unsplash), xếp hạng các đoạn phim theo ngữ nghĩa, và cắt ghép các đoạn phim chuyển động thực sự thành một video hoàn chỉnh. Điều này khác với phương pháp “Ken Burns trên hình ảnh tĩnh” được hầu hết các công cụ video AI sử dụng. Bạn cũng có thể chỉnh sửa đoạn phim quay nói của riêng mình, kết hợp cảnh quay gốc với hình ảnh hỗ trợ do AI tạo ra, hoặc chuyển các podcast thành các đoạn clip cho mạng xã hội.'
  - q: 'OpenMontage hỗ trợ những trợ lý lập trình AI nào?'
    a: 'OpenMontage hỗ trợ Claude Code, Cursor, GitHub Copilot, Codex và Windsurf. Mỗi nền tảng có một tệp cấu hình riêng (CLAUDE.md, CURSOR.md, COPILOT.md, CODEX.md, .windsurfrules) liên kết tới các tệp chia sẻ AGENT_GUIDE.md và PROJECT_CONTEXT.md. Hệ thống ưu tiên đại lý: không có bộ điều phối mã — trợ lý AI lập trình của bạn LÀ bộ điều phối, đọc các bản mô tả pipeline YAML và tệp kỹ năng Markdown để thực hiện sản xuất.'
  - q: 'Hệ thống kiểm soát chất lượng là gì?'
    a: 'OpenMontage triển khai các cổng chất lượng cấp sản xuất: xác thực trước khi ghép (chặn các bản render vi phạm cam kết giao hàng hoặc có rủi ro slideshow nghiêm trọng), tự đánh giá sau khi render (xác thực ffprobe, trích xuất khung hình tại 4 vị trí để phát hiện khung hình đen, phân tích mức âm thanh để phát hiện im lặng/clip, kiểm tra cam kết giao hàng), và hệ thống đánh giá rủi ro slideshow 6 chiều. Mọi lựa chọn nhà cung cấp đều được ghi lại với các phương án thay thế đã xem xét, điểm số độ tin cậy và lý do. Kiểm soát ngân sách bao gồm ước tính chi phí trước khi thực hiện, ngưỡng phê duyệt theo hành động và giới hạn chi tiêu có thể cấu hình.'
featureImage: /articles/agentic-video-production-3a8f21.png/images/articles/agentic-video-production-3a8f21.png
---



## The Problem With Current AI Video Tools

Mọi công cụ video AI mà được đông đảo công chúng biết đến vào năm 2025 — Sora, Runway Gen-4, Pika, Luma Dream Machine, Kling — đều chia sẻ một hạn chế cơ bản giống nhau: chúng là **công cụ tạo video từ một lệnh duy nhất**. Bạn gõ một mô tả, chờ 60 giây, và nhận được một đoạn video dài 5 đến 30 giây mà không có kịch bản, không có cấu trúc kể chuyện, không có âm thanh đồng bộ, và không có kiểm duyệt chất lượng.

Đối với việc tạo các đoạn clip hình ảnh tách rời, điều này hoạt động tốt. Đối với việc sản xuất các video thực sự — nội dung giải thích, demo sản phẩm, bộ sưu tập tư liệu, phim hoạt hình ngắn — quy trình làm việc sụp đổ ngay khi bạn cần nhiều hơn một cảnh mạch lạc.

Khoảng cách giữa "tạo một đoạn clip" và "sản xuất một video" là rất lớn. Nó đòi hỏi:

- **Nghiên cứu** — thu thập dữ liệu chính xác, xu hướng nổi bật và hình ảnh tham khảo
- **Viết kịch bản** — tổ chức thông tin thành một câu chuyện mạch lạc với nhịp điệu phù hợp
- **Tạo tài nguyên** — tạo hoặc tìm kiếm hình ảnh, clip video, nhạc và lồng tiếng
- **Chỉnh sửa** — lắp ráp các tài nguyên vào dòng thời gian với các chuyển cảnh, phụ đề và hiệu ứng
- **Kiểm tra chất lượng** — đảm bảo sản phẩm cuối cùng phù hợp với bản tóm tắt sáng tạo

Không có một mô hình AI nào làm tất cả những việc này. Nhưng một hệ thống điều phối nhiều công cụ chuyên biệt thông qua một quy trình sản xuất có cấu trúc thì có thể.

**[OpenMontage](https://github.com/calesthio/OpenMontage)** (GitHub: `calesthio/OpenMontage`, **hơn 8.273 sao** tính đến tháng 6 năm 2026) là hệ thống sản xuất video tác nhân mã nguồn mở đầu tiên trên thế giới được thiết kế để lấp đầy chính khoảng trống này. Nó cung cấp 12 quy trình sản xuất, 52 công cụ và hơn 500 kỹ năng tác nhân biến bất kỳ trợ lý viết mã AI nào thành một studio sản xuất video toàn diện.

## How OpenMontage Works

OpenMontage sử dụng **kiến trúc ưu tiên tác nhân**. Không có chương trình điều phối trung tâm. Trợ lý lập trình AI của bạn — Claude Code, Cursor, Copilot, Windsurf hoặc Codex — CHÍNH LÀ bộ điều phối.

Hệ thống hoạt động thông qua ba lớp kiến thức:

```
Layer 1: tools/ + pipeline_defs/     "What exists" — executable capabilities + orchestration
Layer 2: skills/                      "How to use it" — OpenMontage conventions and quality bars
Layer 3: .agents/skills/              "How it works" — external technology knowledge packs
```

Bạn mô tả những gì bạn muốn bằng ngôn ngữ đơn giản. Đại lý đọc bản khai pipeline (YAML) để hiểu các giai đoạn, công cụ và tiêu chí đánh giá có sẵn. Nó đọc kỹ năng của giám đốc giai đoạn (Markdown) để học cách thực hiện từng giai đoạn. Nó gọi các công cụ Python để chọn nhà cung cấp có điểm số, tự đánh giá bằng kỹ năng người đánh giá, ghi lại trạng thái ở JSON và trình bày các quyết định sáng tạo để bạn phê duyệt ở mỗi giai đoạn.

Quy trình sản xuất hoàn chỉnh:

```
research → proposal → script → scene_plan → assets → edit → compose
```

Mỗi giai đoạn đều có một kỹ năng giám đốc riêng — một tệp hướng dẫn Markdown dạy cho tác nhân chính xác cách thực hiện giai đoạn đó. Tác nhân đọc kỹ năng, sử dụng các công cụ, tự đánh giá, kiểm tra trạng thái và yêu cầu sự phê duyệt của con người tại các điểm quyết định sáng tạo.

Nghiên cứu trên web là một giai đoạn hạng nhất. Trước khi viết một từ kịch bản nào, tác nhân sẽ tìm kiếm trên YouTube, Reddit, Hacker News, các trang tin tức và các nguồn học thuật. Nó thu thập các điểm dữ liệu, câu hỏi của khán giả, các góc xu hướng và tài liệu tham khảo hình ảnh — sau đó trích dẫn tất cả trong một bản tóm tắt nghiên cứu có cấu trúc. Các video được dựa trên thông tin thực tế, hiện tại, chứ không phải các sự thật tưởng tượng.

## The 12 Production Pipelines

Mỗi đường ống là một quy trình sản xuất hoàn chỉnh từ ý tưởng đến video hoàn chỉnh:

| Pipeline | What It Produces | Best For |
|----------|-----------------|----------|
| **Animated Explainer** | AI-generated explainer with research, narration, visuals, music | Educational content, tutorials, topic breakdowns |
| **Animation** | Motion graphics, kinetic typography, animated sequences | Social media, product demos, abstract concepts |
| **Avatar Spokesperson** | Avatar-driven presenter videos | Corporate comms, training, announcements |
| **Cinematic** | Trailer, teaser, and mood-driven edits | Brand films, teasers, promotional content |
| **Clip Factory** | Batch of ranked short-form clips from one long source | Repurposing long content for social media |
| **Documentary Montage** | Thematic montage from CLIP-indexed corpus of free stock footage | Video essays, mood pieces, real-footage documentaries |
| **Hybrid** | Source footage + AI-generated support visuals | Enhancing existing footage with graphics |
| **Localization & Dub** | Subtitle, dub, and translate existing video | Multi-language distribution |
| **Podcast Repurpose** | Podcast highlights to video | Podcast marketing, audiogram videos |
| **Screen Demo** | Polished software screen recordings and walkthroughs | Product demos, tutorials, documentation |
| **Talking Head** | Footage-led speaker videos | Presentations, vlogs, interviews |
| **Character Animation** | Rigged SVG character animation with GSAP timelines | Cartoon characters, animated storytelling |

Mỗi quy trình làm việc đều tuân theo cùng một luồng cấu trúc: nghiên cứu → đề xuất → kịch bản → kế hoạch cảnh → tài nguyên → biên tập → soạn nhạc. Tác nhân chọn quy trình phù hợp trước, đọc bản khai, đọc kỹ năng giai đoạn và sử dụng công cụ.

## Zero-API-Key Production

Bạn không cần các khóa API trả phí để tạo video thực. Ngay khi cài đặt, `make setup` sẽ cung cấp cho bạn:

| Capability | Free Tool | What It Does |
|-----------|-----------|-------------|
| **Narration** | Piper TTS | Free offline text-to-speech — real human-sounding narration |
| **Open footage** | Archive.org + NASA + Wikimedia Commons | Free/open archival footage, educational media, documentary texture |
| **Extra stock** | Pexels + Unsplash + Pixabay | Free stock footage/images (developer keys are free to get) |
| **Composition (React)** | Remotion | React-based rendering — spring-animated image scenes, text cards, stat cards, charts, TikTok-style word-level captions |
| **Composition (HTML/GSAP)** | HyperFrames | HTML/CSS/GSAP rendering — kinetic typography, product promos, launch reels, rigged SVG character animation |
| **Post-production** | FFmpeg | Encoding, subtitle burn-in, audio mixing, color grading |
| **Subtitles** | Built-in | Auto-generated captions with word-level timing |

Hai con đường sản xuất miễn phí có sẵn ngay lập tức:

1. **Video dựa trên hình ảnh:** Piper kể lại kịch bản của bạn, hình ảnh cung cấp phần hình ảnh, và Remotion hoạt hình chúng thành một bản chỉnh sửa hoàn chỉnh.
2. **Phim tài liệu với cảnh quay thực tế:** Hệ thống xây dựng một kho dữ liệu có thể tìm kiếm bằng CLIP từ Archive.org, NASA, Wikimedia Commons, và các nguồn miễn phí tùy chọn như Pexels và Unsplash, sau đó cắt ghép các cảnh quay thực tế thành một video hoàn chỉnh.

Đối với đường dẫn cảnh quay thực, hãy yêu cầu một **tập hợp phim tài liệu**, **bản nhạc theo chủ đề**, hoặc **collage cảnh quay có sẵn**, và nói rõ **chỉ sử dụng cảnh quay thực**.

Ví dụ về các lệnh nhắc hoạt động mà không cần khóa API:

```
"Make a 45-second animated explainer about why the sky is blue"
"Create a 60-second video about the history of the internet, with narration and captions"
"Make a data-driven explainer about coffee consumption around the world"
```

## With Paid API Keys: Expanded Capabilities

Thêm khóa API sẽ mở khóa các tài sản chất lượng cao hơn. Đây là cảnh quan nhà cung cấp:

### Video Generation — 14 providers

| Provider | Type | Notes |
|----------|------|-------|
| **Kling** | Cloud API | High quality, fast |
| **Runway Gen-4** | Cloud API | Cinematic quality, Gen-3 Alpha Turbo / Gen-4 Turbo / Gen-4 Aleph |
| **Google Veo 3** | Cloud API | Long-form, cinematic. Via fal.ai or HeyGen. |
| **Grok Imagine Video** | Cloud API | Strong reference-image video and xAI-native short-form generation |
| **Higgsfield** | Cloud API | Multi-model orchestrator with Soul ID for character consistency |
| **MiniMax** | Cloud API | Cost-effective |
| **HeyGen** | Cloud API | Multi-model gateway |
| **WAN 2.1** | Local GPU | Free, 1.3B and 14B variants |
| **Hunyuan** | Local GPU | Free, high quality |
| **CogVideo** | Local GPU | Free, 2B and 5B variants |
| **LTX-Video** | Local GPU / Modal | Free locally, or self-hosted cloud |

### Image Generation — 10 tools/providers

| Provider | Type | Notes |
|----------|------|-------|
| **FLUX** | Cloud API | State-of-the-art quality |
| **Google Imagen** | Cloud API | Imagen 4 — high-quality, multiple aspect ratios |
| **Grok Imagine Image** | Cloud API | Strong image edits, style transfer, and multi-image compositing |
| **DALL-E 3** | Cloud API | OpenAI\'s image model |
| **Recraft** | Cloud API | Design-focused generation |
| **Local Diffusion** | Local GPU | Stable Diffusion, free |

### Text-to-Speech — 4 providers

| Provider | Type | Notes |
|----------|------|-------|
| **ElevenLabs** | Cloud API | Premium voice quality |
| **Google TTS** | Cloud API | 700+ voices, 50+ languages — best for localization |
| **OpenAI TTS** | Cloud API | Fast, affordable |
| **Piper** | Local | Completely free, offline |

### Music & Sound

| Provider | Type | Notes |
|----------|------|-------|
| **Suno AI** | Cloud API | Full song generation with vocals, lyrics, any genre. Up to 8 minutes. |
| **ElevenLabs Music** | Cloud API | AI music generation |
| **ElevenLabs SFX** | Cloud API | Sound effect generation |

## Production Governance and Quality Gates

OpenMontage coi sản xuất video như kỹ thuật thực sự — với các cổng chất lượng, dấu vết kiểm toán và thực thi ở mọi giai đoạn.

### Pre-Compose Validation

Chặn việc kết xuất nếu cam kết giao hàng bị vi phạm (ví dụ: video 'dẫn động bằng chuyển động' với 80% hình ảnh tĩnh), điểm rủi ro trình chiếu là nghiêm trọng, hoặc thiếu họ trình kết xuất. Phát hiện kế hoạch bị hỏng trước khi lãng phí thời gian GPU.

### Post-Render Self-Review

Sau mỗi lần kết xuất, thời gian chạy thực hiện kiểm tra ffprobe, trích xuất các khung hình tại 4 vị trí để kiểm tra các khung hình đen và lớp phủ bị hỏng, phân tích mức âm thanh để kiểm tra sự im lặng và quá tải âm thanh, xác minh rằng cam kết giao hàng đã được thực hiện, và kiểm tra sự hiện diện của phụ đề. Nếu việc đánh giá thất bại, video sẽ không được trình bày cho người dùng.

### Slideshow Risk Scoring

Phân tích 6 chiều — lặp lại, hình ảnh trang trí, chuyển động yếu, ý định cảnh quay, phụ thuộc quá mức vào kiểu chữ, các tuyên bố điện ảnh không được hỗ trợ — ngăn chặn các sản phẩm 'PowerPoint hoạt hình'.

### Scored Provider Selection

Mỗi lựa chọn công cụ (tạo video, tạo hình ảnh, TTS, âm nhạc) đều chạy qua một bộ máy chấm điểm 7 chiều:

| Dimension | Weight |
|-----------|--------|
| Task Fit | 30% |
| Output Quality | 20% |
| Control Features | 15% |
| Reliability | 15% |
| Cost Efficiency | 10% |
| Latency | 5% |
| Continuity | 5% |

Nhà cung cấp chiến thắng và điểm số của nó được ghi lại trong đường dẫn quyết định cùng với tất cả các phương án đã được xem xét. Các bộ chọn chuẩn hóa bối cảnh ngắn gọn lỏng lẻo trước khi chấm điểm — nếu đại lý chỉ biết "phim ngắn hoạt hình kiểu Pixar với tính nhất quán của nhân vật," bộ chọn sẽ mở rộng điều đó thành các tín hiệu ý định và phong cách dễ chấm điểm hơn cho người chấm điểm.

### Budget Controls

- **Ước tính** trước khi thực hiện — xem chi phí sẽ là bao nhiêu
- **Dự trữ** ngân sách — khóa quỹ trước khi gọi
- **Đối chiếu** sau — ghi lại chi tiêu thực tế
- **Chế độ có thể cấu hình** — `observe` (chỉ theo dõi), `warn` (ghi nhật ký vượt quá), `cap` (giới hạn cứng)
- **Phê duyệt theo hành động** — tạm dừng để xác nhận vượt ngưỡng (mặc định: $0.50)
- **Giới hạn tổng ngân sách** — mặc định $10, có thể cấu hình hoàn toàn

Không có hóa đơn bất ngờ. Đại lý sẽ cho bạn biết chi phí trước khi chi tiêu.

## Architecture Overview

```
OpenMontage/
├── tools/              # 48 Python tools (the agent\'s hands)
│   ├── video/          # 13 video gen tools + compose, stitch, trim
│   ├── audio/          # 4 TTS providers + Suno/ElevenLabs music, mixing, enhancement
│   ├── graphics/       # 9 image/graphics generation tools + diagrams, code snippets, math
│   ├── enhancement/    # Upscale, bg remove, face enhance, color grade
│   ├── analysis/       # Transcription, scene detect, frame sampling
│   ├── avatar/         # Talking head, lip sync
│   └── subtitle/       # SRT/VTT generation
│
├── pipeline_defs/      # YAML pipeline manifests (the agent\'s playbook)
├── skills/             # Markdown skill files (the agent\'s knowledge)
│   ├── pipelines/      # Per-pipeline stage director skills
│   ├── creative/       # Creative technique skills
│   ├── core/           # Core tool skills
│   └── meta/           # Reviewer, checkpoint protocol
│
├── schemas/            # 15 JSON Schemas (contract validation)
├── styles/             # Visual style playbooks (YAML)
├── remotion-composer/  # React/Remotion video composition engine
├── lib/                # Core infrastructure (config, checkpoints, pipeline loader)
└── tests/              # Contract tests, QA integration tests, eval harness
```

Hệ thống sử dụng ba lớp kiến thức. Lớp 1 (`tools/` + `pipeline_defs/`) cho tác nhân biết những gì tồn tại. Lớp 2 (`skills/`) cho nó biết cách sử dụng các quy ước và tiêu chuẩn chất lượng của OpenMontage. Lớp 3 (`.agents/skills/`) cung cấp kiến thức công nghệ sâu về các công cụ và nhà cung cấp bên ngoài.

## Agent Compatibility

OpenMontage hoạt động với bất kỳ trợ lý lập trình AI nào có thể đọc tệp và thực thi Python. Các tệp hướng dẫn chuyên dụng được bao gồm cho:

| Platform | Config File |
|----------|------------|
| **Claude Code** | `CLAUDE.md` |
| **Cursor** | `CURSOR.md` + `.cursor/rules/` |
| **GitHub Copilot** | `COPILOT.md` + `.github/copilot-instructions.md` |
| **Codex** | `CODEX.md` |
| **Windsurf** | `.windsurfrules` |

Tất cả các tệp nền tảng đều trỏ đến `AGENT_GUIDE.md` chung (hướng dẫn vận hành và hợp đồng đại lý) và `PROJECT_CONTEXT.md` (tham chiếu kiến trúc).

Hỗ trợ LLM cục bộ qua Ollama và LM Studio sẽ sớm ra mắt, điều này sẽ cho phép chạy toàn bộ quy trình sản xuất mà không cần bất kỳ LLM đám mây nào.

## Installation and Setup

### Prerequisites

- **Python 3.10+** — [python.org](https://www.python.org/downloads/)
- **FFmpeg** — `brew install ffmpeg` / `sudo apt install ffmpeg`
- **Node.js 18+** — [nodejs.org](https://nodejs.org/)
- **Một trợ lý lập trình AI** — Claude Code, Cursor, Copilot, Windsurf hoặc Codex

### Install

```bash
git clone https://github.com/calesthio/OpenMontage.git
cd OpenMontage
make setup
```

Mở dự án trong trợ lý lập trình AI của bạn và nói với nó những gì bạn muốn:

```
"Make a 60-second animated explainer about how neural networks learn"
```

Hoặc đối với đường dẫn hình ảnh thực:

```
"Make a 75-second documentary montage about city life in the rain. Use real footage only, no narration, elegiac tone, with music."
```

Đại lý nghiên cứu chủ đề của bạn bằng tìm kiếm web trực tiếp, tạo hình ảnh AI, viết và thuyết minh kịch bản với hướng dẫn giọng nói, tự động tìm nhạc nền không bản quyền, chèn phụ đề ở cấp độ từ, và xuất video cuối cùng. Trước khi bạn thấy bất cứ điều gì, hệ thống thực hiện một cuộc tự kiểm tra đa điểm — xác thực ffprobe, lấy mẫu khung hình, phân tích mức âm thanh, xác minh cam kết giao hàng và kiểm tra phụ đề.

Nếu bạn có GPU, bạn có thể mở khóa tạo video cục bộ miễn phí:

```bash
make install-gpu
# Then add to .env:
# VIDEO_GEN_LOCAL_ENABLED=true
# VIDEO_GEN_LOCAL_MODEL=wan2.1-1.3b  # or wan2.1-14b, hunyuan-1.5, ltx2-local, cogvideo-5b
```

### Optional API Keys

Mỗi khóa API đều là tùy chọn. Thêm những gì bạn có:

```bash
# Image + video gateway:
FAL_KEY=your-key               # FLUX images + Google Veo, Kling, MiniMax video + Recraft

# Free stock media:
PEXELS_API_KEY=your-key        # Free stock footage and images
PIXABAY_API_KEY=your-key       # Free stock footage and images
UNSPLASH_ACCESS_KEY=your-key   # Free stock images

# Music:
SUNO_API_KEY=your-key          # Full songs, instrumentals, any genre

# Voice & images:
ELEVENLABS_API_KEY=your-key    # Premium TTS, AI music, sound effects
OPENAI_API_KEY=your-key        # OpenAI TTS, DALL-E 3 images
GOOGLE_API_KEY=your-key        # Google Imagen images, Google TTS (700+ voices)
```

## Comparison: OpenMontage vs. Competitors

| Feature | OpenMontage | Sora | Runway | Pika |
|---------|------------|------|--------|------|
| **Full production pipeline** | Yes (12 pipelines) | No | No | No |
| **Script writing** | Automated with web research | Manual | Manual | Manual |
| **Narration/TTS** | Built-in (Piper, ElevenLabs, Google) | Limited | Manual | Manual |
| **Music generation** | Suno, ElevenLabs Music | No | No | No |
| **Subtitle burning** | Auto word-level | Manual | Manual | Manual |
| **Quality gates** | Pre/post-compose validation | None | None | None |
| **Budget controls** | Cost estimation + caps | N/A | N/A | N/A |
| **Free tier** | Full pipeline at zero cost | Paid only | Paid only | Paid only |
| **Real footage docs** | Documentary Montage pipeline | No | No | No |
| **Agent compatible** | Claude, Cursor, Copilot, Codex, Windsurf | Web UI | Web UI | Web UI |

OpenMontage không phải là một mô hình tạo video. Đây là một hệ thống điều phối sản xuất có thể sử dụng bất kỳ mô hình tạo video nào như một trong nhiều công cụ trong quy trình của nó. Điều này khiến nó khác biệt cơ bản so với Sora, Runway và Pika, vốn tự thân là các mô hình tạo.

## Prompt Gallery

Dưới đây là các câu lệnh đã được kiểm nghiệm, được sắp xếp theo độ phức tạp và loại đầu ra. Mỗi câu lệnh sẽ kích hoạt toàn bộ quy trình sản xuất thông qua trợ lý lập trình AI của bạn:

```text
# Beginner — zero keys needed
"Make a 45-second animated explainer about why the sky is blue"
"Create a 60-second video about the history of the internet, with narration and captions"
"Make a data-driven explainer about coffee consumption around the world"
```

```text
# Intermediate — needs one image provider (~$0.15-$0.50)
"Create a 30-second Ghibli-style animated video of a magical floating library in the clouds at golden hour"
"Make a 30-second anime-style animation of an underwater temple with bioluminescent coral"
"Create an animated explainer about how CRISPR gene editing works, using AI-generated visuals"
```

```text
# Advanced — full setup (~$1-$3)
"Create a cinematic 30-second trailer for a sci-fi concept: humanity receives a warning from 1000 years in the future"
"Make a 90-second animated explainer about quantum computing for middle school students, with a fun narrator voice and custom soundtrack"
```

```text
# Reference-driven — start from an existing video
"Here\'s a YouTube Short I love. Make me something like this, but about CRISPR for high school students."
"Analyze this Reel and give me 3 original variants I could make for my own product launch."
"I like the pacing and hook in this video. Keep that energy, but turn it into a 45-second explainer about black holes."
```

```text
# Real-footage documentary path
"Make a 90-second documentary montage about what a city feels like at 4am. Use real footage only, no narration, elegiac tone."
"Create a 60-second Adam-Curtis-style archival collage about 1950s consumer optimism. Prefer Archive.org and Wikimedia footage."
"Cut together a dreamlike montage about coming home in the rain using real stock footage only. Music yes, narration no."
```

Để xem thêm các lời nhắc đã được kiểm tra với chi phí dự kiến và ví dụ đầu ra, hãy xem Thư viện Lời nhắc trong kho lưu trữ, hoặc chạy `make demo` để tạo video demo không cần khóa ngay lập tức.

## Use Cases

### Educational Content

Tạo các video giải thích hoạt hình với kịch bản dựa trên nghiên cứu, phần thuyết minh tự nhiên và các phương tiện trực quan. Tác nhân tìm kiếm dữ liệu hiện tại, viết kịch bản có cấu trúc, tạo các hình ảnh minh họa phù hợp và kết hợp mọi thứ bằng Remotion hoặc HyperFrames.

### Social Media Clips

Tái sử dụng nội dung dài thành các clip ngắn bằng quy trình Clip Factory. Xếp hạng các clip theo tiềm năng tương tác và tự động định dạng cho YouTube Shorts, TikTok và Instagram Reels với tỷ lệ khung hình riêng cho từng nền tảng.

### Product Demos

Tạo các bản ghi màn hình chất lượng cao với phần thuyết minh, chú thích và kiểu dáng thương hiệu. Quy trình Screen Demo xử lý các hướng dẫn phần mềm với nhận diện hình ảnh nhất quán.

### Documentary Production

Xây dựng các montages chủ đề từ các nguồn tư liệu miễn phí và mở. Quy trình Documentary Montage lập chỉ mục Archive.org, NASA và Wikimedia Commons bằng các nhúng CLIP, tìm kiếm các clip có liên quan về mặt ngữ nghĩa, và chỉnh sửa chúng thành một câu chuyện liền mạch với nhạc và phụ đề.

### Multi-Language Distribution

Sử dụng quy trình Localization & Dub để dịch và lồng tiếng các video hiện có sang hơn 10 ngôn ngữ với Google TTS (hơn 700 giọng nói) hoặc nhân bản giọng nói bằng ElevenLabs.

## Limitations and Honest Assessment

OpenMontage ấn tượng nhưng không phải là phép màu. Một số hạn chế đáng để hiểu rõ:

1. **Phụ thuộc vào tác nhân.** Hệ thống yêu cầu một trợ lý lập trình AI có thể đọc tập tin, thực thi Python và tuân theo các hướng dẫn có cấu trúc. Nó không có giao diện web độc lập. Bạn cần quen thuộc với các công cụ như Claude Code, Cursor, hoặc Codex.

2. **Chất lượng thay đổi theo nhà cung cấp.** Gói miễn phí (Piper TTS + Remotion + hình ảnh có sẵn) tạo ra sản phẩm có thể sử dụng nhưng không cao cấp. Để đạt chất lượng Sora/Runway, cần sử dụng các API tạo video trả phí (Kling, Veo, Runway Gen-4), chi phí thêm từ $0,15 đến $3,00 mỗi video tùy vào độ phức tạp.

3. **Thời gian sản xuất lâu.** Một quá trình chạy đầy đủ của pipeline (nghiên cứu → đề xuất → kịch bản → tài nguyên → tổng hợp → kiểm tra) thường mất 10-30 phút tùy vào độ phức tạp của pipeline và tốc độ API. Đây không phải là tạo ngay lập tức.

4. **Yêu cầu GPU cho các mô hình cài đặt cục bộ.** Chạy WAN 2.1, Hunyuan, hoặc CogVideo cục bộ đòi hỏi VRAM đáng kể (8GB+ cho các mô hình 1.3B, 24GB+ cho các mô hình 14B). Nếu không có GPU, bạn phải sử dụng các nhà cung cấp dịch vụ đám mây.

5. **Giấy phép AGPL-3.0.** OpenMontage được cấp phép theo AGPL-3.0, yêu cầu các tác phẩm phái sinh phải được công khai mã nguồn. Đối với các sản phẩm thương mại đóng nguồn, bạn cần xem xét cẩn thận các tác động về giấy phép hoặc liên hệ với các tác giả.

6. **Không có ứng dụng di động gốc.** Hệ thống chạy trên máy tính để bàn với Python + Node.js. Không có khả năng chỉnh sửa hoặc sản xuất trên thiết bị di động.

## Quality Gate Configuration

Hệ thống chất lượng của OpenMontage có thể được tùy chỉnh thông qua các biến môi trường và tệp cấu hình:

```bash
# .env quality gate settings
SLIDESHOW_RISK_THRESHOLD=0.7
PRE_COMPOSE_VALIDATION=true
POST_RENDER_SELF_REVIEW=true
AUDIO_LEVEL_MIN=-30
AUDIO_LEVEL_MAX=-3
MAX_STILL_IMAGE_RATIO=0.3
MIN_VIDEO_DURATION_SECONDS=10
```

```json
// .openmontage/config.json — pipeline quality overrides
{
  "quality_gates": {
    "slideshow_risk": { "enabled": true, "threshold": 0.7 },
    "pre_compose_validation": { "enabled": true },
    "post_render_review": { "enabled": true, "frame_positions": [0.25, 0.5, 0.75] },
    "audio_analysis": { "min_level_db": -30, "max_level_db": -3, "silence_threshold_ms": 500 }
  },
  "budget": {
    "mode": "cap",
    "total_cap_usd": 10,
    "per_action_approval_threshold": 0.50
  }
}
```

Các cài đặt này kiểm soát khi nào hệ thống chặn các bản render, đánh dấu các rủi ro và yêu cầu sự phê duyệt của con người. Điều chỉnh các ngưỡng dựa trên yêu cầu chất lượng và giới hạn ngân sách của bạn.

## Getting Started

Cách nhanh nhất để thử OpenMontage:

1. Sao chép kho lưu trữ: `git clone https://github.com/calesthio/OpenMontage && cd OpenMontage && make setup`
2. Mở trong Claude Code hoặc Cursor
3. Nhắc lệnh: `"Tạo một video giải thích hoạt hình dài 45 giây về lý do tại sao bầu trời có màu xanh"`
4. Xem tác nhân nghiên cứu, viết kịch bản, tạo tài nguyên, biên tập và xác thực
5. Xem lại kết quả — mọi quyết định sáng tạo đều được ghi lại cùng một lý do

Đối với việc tạo nội dung dựa trên tham chiếu, hãy dán một video mà bạn yêu thích và yêu cầu tác nhân tạo ra điều gì đó tương tự trên một chủ đề khác. Tác nhân sẽ phân tích bản ghi, nhịp độ, cảnh và khung hình chính của tham chiếu, sau đó tạo ra một kế hoạch sản xuất khác biệt.

## Conclusion

OpenMontage đại diện cho một sự thay đổi về mô hình trong sản xuất video AI. Thay vì cạnh tranh với Sora và Runway ở cấp độ mô hình, nó hoạt động ở **cấp độ điều phối sản xuất** — cung cấp cấu trúc, các cổng kiểm soát chất lượng, khả năng nghiên cứu và lựa chọn nhiều nhà cung cấp, biến một API tạo video thô thành một quy trình sản xuất hoàn chỉnh.

Với 12 đường ống, 52 công cụ, hơn 500 kỹ năng tác nhân và khả năng sản xuất không tốn chi phí ngay khi sử dụng, đây là hệ thống sản xuất video mã nguồn mở toàn diện nhất hiện có. Dù bạn đang tạo các video giải thích giáo dục, montage tài liệu, demo sản phẩm hay clip cho mạng xã hội, OpenMontage cung cấp cho trợ lý lập trình AI của bạn mọi thứ cần thiết để sản xuất video chất lượng chuyên nghiệp.

Đối với hạ tầng tự lưu trữ, hãy xem xét [DigitalOcean](https://m.do.co/c/eca87ac14ee0) hoặc [HTStack](https://my.htstack.com/aff.php?aff=27187) cho việc lưu trữ hỗ trợ GPU đáng tin cậy. Đối với nhu cầu web scraping và proxy, [WebShare.io](https://www.webshare.io/?referral_code=oa14d5f0wx4f) cung cấp lớp hạ tầng. Tìm kiếm các ưu đãi cho công cụ AI và dịch vụ tiền điện tử? Hãy xem [Bitget Web3](https://web3.bitget.com/share/3Wla0s?inviteCode=irBqLe) và [Crypto.com](https://www.bsmkweb.cc/register?aff=dibi8) để có các ưu đãi độc quyền. Đối với tiếp thị liên kết và công cụ xây dựng phễu, [PromoOhLy](https://www.promoohubly.com/join/12190433) cung cấp tự động hóa.

---

**Nguồn:** [OpenMontage GitHub](https://github.com/calesthio/OpenMontage) · [Hướng dẫn Agent](https://github.com/calesthio/OpenMontage/blob/main/AGENT_GUIDE.md) · [Tài liệu Nhà cung cấp](https://github.com/calesthio/OpenMontage/blob/main/docs/PROVIDERS.md)

**Tham gia cộng đồng:** [Thảo luận trên GitHub](https://github.com/calesthio/OpenMontage/discussions) · [YouTube](https://www.youtube.com/@OpenMontage) · [X](https://x.com/calesthioailabs)

📢 **Cập nhật thông tin:** Tham gia [nhóm Telegram của chúng tôi](https://t.me/DIBI8_Group/2) để nhận đánh giá công cụ AI hàng ngày và truy cập sớm nội dung mới.
