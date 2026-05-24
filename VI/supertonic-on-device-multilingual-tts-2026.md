---
title: 'Đánh giá Supertonic: TTS đa ngôn ngữ chạy on-device 99M tham số qua ONNX, hỗ trợ 31 ngôn ngữ (2026)'
description: 'Supertonic (9.9K+ stars trên GitHub) của Supertone Inc. là model text-to-speech đa ngôn ngữ siêu nhanh chạy local trên CPU qua ONNX Runtime — không cloud, không API, không cần GPU. 99M tham số, 31 ngôn ngữ bao gồm tiếng Hàn/Nhật/Việt/Trung, audio chất lượng studio 44.1kHz, 10 expression tag, runtime cho Python, Node.js, browser (WebGPU/WASM), iOS, Android, Rust, Flutter. Phân tích đầy đủ tính năng, hướng dẫn cài đặt, ví dụ code và so sánh bối cảnh TTS on-device 2026.'
date: 2026-05-23 00:00:00+08:00
lastmod: 2026-05-23 00:00:00+08:00
tech_stack: []
application_domain: AI Tools
source_version: 'v2.0.0'
licensing_model: Open Source
license_type: MIT (code) / OpenRAIL-M (model)
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/supertone-inc/supertonic'
stars: 9900
maintainer: 'supertone-inc'
last_maintained: '2026-01-06'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['supertonic', 'text-to-speech', 'tts', 'on-device-ai', 'onnx', 'multilingual', 'open-source-tts', 'edge-ai', 'korean-tts', 'japanese-tts']
aliases:
- /vi/posts/supertonic-on-device-multilingual-tts-2026/
---

## Vấn đề của TTS on-device

Suốt nhiều năm qua, "text-to-speech đa ngôn ngữ chất lượng" đồng nghĩa với việc gọi API cloud của ai đó — Google Cloud TTS, Amazon Polly, ElevenLabs, OpenAI Voice. Giọng tự nhiên, độ trễ chấp nhận được trên băng thông rộng, và chi phí mỗi ký tự đủ rẻ để không ai để ý — cho đến ngày nhận hóa đơn.

Vết nứt lộ ra ở ba chỗ. **Quyền riêng tư** — gửi từng script cho bên thứ ba không phải lựa chọn cho ngành y tế, pháp lý hay bất cứ thứ gì bị quản lý. **Biến động độ trễ** — mạng chập một cái là giọng lắp bắp. **Chi phí khi scale** — một khi bạn tổng hợp hơn ~100 giờ audio mỗi tháng, hóa đơn theo ký tự đội lên đáng kể. Và **dùng offline** — bất cứ thứ gì trong xe hơi, trên máy bay, ở cơ sở xa xôi hay kiosk đều cần inference local, không bàn cãi.

TTS on-device open-source đang đuổi kịp, nhưng đánh đổi rất gắt: hoặc là model tí hon chỉ có tiếng Anh (Piper, các biến thể nhỏ của Coqui), hoặc model đa ngôn ngữ khổng lồ cần GPU mới chạy được thực tế (XTTS-v2, Bark). Chưa có cái nào đạt điểm ngọt "nhanh, đa ngôn ngữ, nhẹ, weight open thật sự".

[**Supertonic**](https://github.com/supertone-inc/supertonic) (GitHub: `supertone-inc/supertonic`, **9,900+ stars**) của công ty speech-AI Hàn Quốc Supertone Inc. là ứng viên 2026 đáng tin nhất để lấp khoảng trống đó. 99M tham số, 31 ngôn ngữ, runtime ONNX, chạy thoải mái trên CPU — bao gồm, theo lời README, real-time factor 0.3× trên một máy đọc sách điện tử ở chế độ máy bay.

---

## Supertonic là gì

Một module flow-matching text-to-latent kết hợp với speech autoencoder, được export sang ONNX. Cụ thể:

- **99M tham số tổng cộng** — đủ nhỏ để load trong vài giây và chạy real-time trên một CPU bình thường. Để so sánh, XTTS-v2 khoảng ~1.5B và Bark ~900M.
- **31 ngôn ngữ sẵn dùng**: Ả Rập, Bulgaria, Croatia, Séc, Đan Mạch, Hà Lan, Anh, Estonia, Phần Lan, Pháp, Đức, Hy Lạp, Hindi, Hungary, Indonesia, Ý, **Nhật**, **Hàn**, Latvia, Litva, Ba Lan, Bồ Đào Nha, Romania, Nga, Slovakia, Slovenia, Tây Ban Nha, Thụy Điển, Thổ Nhĩ Kỳ, Ukraine, **Việt**.
- **Output audio 44.1kHz** — sample rate chuẩn studio thực sự, không phải mức 22kHz mà đa số TTS "đủ dùng" đành chấp nhận.
- **10 expression tag** — `<laugh>`, `<breath>`, `<sigh>`, v.v. Nhúng inline trong text để dẫn dụ kiểu đọc tự nhiên hơn mà không cần retrain voice clone.
- **Chế độ `lang="na"`** — sinh giọng không phụ thuộc ngôn ngữ khi bạn không muốn chọn mã ngôn ngữ.

License: **MIT cho code, OpenRAIL-M cho weight model**. Sự phân tách này quan trọng: OpenRAIL-M là license "responsible AI" hạn chế một số mục đích gây hại, nhưng cho phép deploy thương mại bình thường. Đọc model card trước khi ship sản phẩm.

---

## Số liệu hiệu năng công bố

Các con số Supertone Inc. trích trong benchmark và README:

| Chỉ số | Supertonic | Baseline thông thường |
|---|---|---|
| Số tham số | 99M | 0.7B–2B |
| Độ chính xác đọc (WER/CER trên Minimax-MLS-test) | Cạnh tranh với model lớn hơn nhiều | — |
| Memory runtime | Ít hơn đáng kể so với GPU baseline | — |
| RTF trên máy đọc Onyx Boox Go 6 (chế độ máy bay) | 0.3× | n/a (không chạy được) |
| Độ trễ (CPU) | Cạnh tranh với baseline GPU A100 | — |

Benchmark trên e-reader là con số headline — kiểu số liệu báo hiệu "đúng vậy, cái này chạy được mọi nơi". Một CPU điện thoại hiện đại lẽ ra phải chạy nhẹ tênh.

---

## Phạm vi runtime

Supertonic là một trong số ít dự án TTS open ship SDK binding thật chứ không chỉ "chắc bạn có thể tự wrap được". Tính đến v2.0.0:

- **Python** (`pip install supertonic`) — tích hợp chính
- **Node.js** — cho server và app Electron
- **Browser** — WebGPU khi có sẵn, WebAssembly làm fallback
- **Java** — backend Android và JVM
- **C++**, **C#**, **Go**, **Rust** — tích hợp systems
- **Swift / iOS** — binding native first-party
- **Flutter** — cross-platform mobile

Phủ gần hết mọi chỗ mà một developer ứng dụng năm 2026 có thể muốn nhúng TTS. ONNX runtime gánh phần nặng; Supertonic thêm phần keo gắn riêng cho model.

---

## Cài đặt nhanh (Python)

```bash
pip install supertonic
```

Chỉ vậy là xong phần dependency. Model tự download lần đầu gọi:

```python
from supertonic import TTS

tts = TTS(auto_download=True)
style = tts.get_voice_style(voice_name="M1")

text = "Supertonic is a lightning fast, on-device TTS system."

wav, duration = tts.synthesize(
    text=text,
    lang="en",
    voice_style=style,
    total_steps=8,
    speed=1.05,
)
tts.save_audio(wav, "output.wav")
```

Với tiếng Hàn, đổi `lang="en"` → `lang="ko"`. Tương tự với `ja`, `vi`, `zh`. Voice style (`M1` ở đây) nhất quán giữa các ngôn ngữ — hữu ích nếu bạn đang xây giọng nhân vật đa ngôn ngữ.

Với expression tag:

```python
text = "I can't believe it. <laugh> That's incredible. <breath> Let me explain."
```

Model diễn giải tag inline và tạo biểu cảm tương ứng trong audio.

---

## So sánh

Bối cảnh TTS on-device 2026, xếp hạng theo những gì thực sự mang lại:

### So với Piper (40K+ stars)
Piper là cái tên kỳ cựu được ưa chuộng cho on-device. **Piper thắng**: model nhỏ hơn cho mỗi giọng (vài MB), deploy đơn giản hơn cho use case chỉ tiếng Anh. **Supertonic thắng**: nhiều ngôn ngữ hơn hẳn, kiểm soát biểu cảm tốt hơn nhiều, sample rate cao hơn, một model duy nhất xử lý mọi ngôn ngữ thay vì một model một ngôn ngữ.

### So với XTTS-v2 (Coqui)
XTTS-v2 có voice cloning, Supertonic thì không quảng bá. **XTTS-v2 thắng**: chất lượng voice cloning. **Supertonic thắng**: tính thực tế trên CPU, SDK đa runtime, kích thước model, độ rõ ràng của license.

### So với Bark (Suno)
Bark ấn tượng ở mảng audio phi-giọng-nói (nhạc, hiệu ứng âm thanh). **Bark thắng**: dải phong cách vượt ra ngoài giọng nói. **Supertonic thắng**: tốc độ, khả năng deploy, và 31 ngôn ngữ so với Bark chỉ tập trung tiếng Anh.

### So với ElevenLabs / OpenAI / Google Cloud
Cloud TTS vẫn thắng về độ trung thực của voice cloning và độ tự nhiên thuần túy của các giọng top. **Supertonic thắng**: không API key, không hóa đơn theo ký tự, không phụ thuộc mạng, riêng tư toàn diện.

---

## Điều Supertonic không làm

Để đặt kỳ vọng đúng:

- **Không voice cloning từ một mẫu giọng.** Bạn chọn từ các voice style có sẵn. Nếu cần cloning, xem XTTS-v2 hoặc API thương mại.
- **Không streaming synthesis từng token** ở bản release public — synthesis ở mức segment.
- **Tooling fine-tuning hạn chế.** Model weight open theo OpenRAIL-M, nhưng pipeline training chưa public hoàn toàn.
- **Không có fallback 22kHz.** Luôn output 44.1kHz. Cần bandwidth thấp hơn thì tự resample.

---

## Các use case Supertonic tỏa sáng

- **App mobile có tính năng giọng nói** — onboarding narration, đọc accessibility, học ngôn ngữ. Ship duy nhất một file ONNX, hỗ trợ 31 ngôn ngữ, không API key nằm trong binary.
- **Tool y tế và pháp lý** — đọc thành tiếng tài liệu nhạy cảm mà không có gì rời khỏi thiết bị.
- **Hệ thống trong xe và trên máy bay** — hỗ trợ offline đầy đủ, không cần graceful degradation.
- **Localization tiếng Hàn / Nhật / Việt / Trung** — khoảng trống TTS open-source cho các ngôn ngữ châu Á lâu nay rất nhức nhối; Supertonic lấp một mảng lớn trong một model.
- **Thiết bị edge IoT** — kiosk, biển hiệu, loa thông minh không kết nối cloud.

---

## Ai nên dùng

**Cài Supertonic nếu bạn:**
- Ship app cần output giọng nói và không muốn hóa đơn cloud scale theo lượng dùng.
- Cần quyền riêng tư (ngành bị quản lý) hoặc offline (mobile, trên máy bay, edge).
- Localize cho thị trường không phải tiếng Anh và muốn một model thay vì ba mươi.
- Muốn audio chất lượng studio 44.1kHz mà không cần GPU.

**Cứ dùng cloud TTS nếu bạn:**
- Cần voice cloning từ một mẫu giọng 30 giây.
- Sản xuất nội dung một giọng siêu chân thực, nơi dòng cao cấp nhất của ElevenLabs vẫn dẫn đầu.
- Cần streaming audio từng phần (release Supertonic public chưa expose cái này).

---

## Kết luận

Supertonic là ứng viên TTS open "một model dùng mọi nơi" đáng tin nhất phát hành trong 2026. Sự kết hợp giữa footprint 99M tham số, 31 ngôn ngữ, SDK đa runtime, và RTF 0.3× trên máy đọc sách điện tử đặt nó vững vàng vào hạng "đúng, bạn có thể ship cái này trong app mobile" — hạng mà gần như chưa TTS open nào trước đây chạm tới.

Với developer ở Việt Nam, Hàn Quốc, Nhật Bản, hay bất kỳ thị trường ngôn ngữ TTS nào lâu nay thiếu thốn, câu chuyện lớn hơn là khoảng cách chất lượng giữa TTS open-source và cloud API đã thu hẹp đáng kể. Năm năm trước, tiếng Anh là ngôn ngữ duy nhất mà TTS open có thể đưa vào production. Năm 2026, với Supertonic, danh sách đó thực sự đã bao gồm phần lớn thế giới.

Ghép nó với [một runtime LLM on-device](https://dibi8.com/vi/resources/llm-frameworks/local-llm-runner-comparison-2026/) cho phía prompt, bạn có ngay một stack voice agent hoàn toàn local, không phụ thuộc cloud một mảy may.

---

**GitHub**: [supertone-inc/supertonic](https://github.com/supertone-inc/supertonic) · **License**: MIT (code) / OpenRAIL-M (weight) · **Mới nhất**: v2.0.0 (6/1/2026) · **Stars**: 9.9K+ · **Maintainer**: Supertone Inc.
