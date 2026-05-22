---
title: 'ChatTTS 2026: TTS Hội Thoại Mã Nguồn Mở 39.3k Sao Với Cười, Tạm Dừng, Điều Khiển Prosody Cấp Token'
description: 'ChatTTS là TTS mã nguồn mở được xây riêng cho hội thoại (không phải thuyết minh). GitHub 39.3k sao, tối thiểu 4 GB VRAM, RTF 0.3 trên RTX 4090, điều khiển prosody tinh tế bao gồm cười và tạm dừng. Hướng dẫn cài đặt + thiết lập production 2026 đầy đủ.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack:
  - Python
  - PyTorch
  - CUDA
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: AGPL-3.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/2noise/ChatTTS'
stars: 39300
maintainer: '2noise'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['ChatTTS', 'TTS', 'giọng nói', 'hội thoại', 'mã nguồn mở']
aliases:
  - /posts/chattts-dialogue-tts-2026/
---

Hầu hết TTS mã nguồn mở năm 2026 vẫn nghe như "người dẫn GPS thập niên 1990 với reverb thêm." **ChatTTS** là ngoại lệ đầu tiên được áp dụng rộng rãi — mô hình tiếng nói tạo sinh 39.3k sao GitHub, được huấn luyện đặc biệt cho **hội thoại** (không phải thuyết minh), với điều khiển token cấp về cười, tạm dừng, từ chêm, và prosody cuối cùng vượt ngưỡng "không làm bạn nhăn mặt".

Nếu bạn đang xây agent giọng nói, podcast AI, TTS đa nhân vật cho game, hoặc bất kỳ sản phẩm giọng nói nào mà thuyết minh phẳng giết chết trải nghiệm — ChatTTS là lựa chọn mặc định mã nguồn mở năm 2026.

## TL;DR

- **Là gì**: TTS tối ưu hội thoại mã nguồn mở của 2noise (tiếng Trung + Anh)
- **GitHub**: 39.3k sao
- **License**: code AGPL-3.0 + **model CC BY-NC 4.0** — chỉ phi thương mại trên trọng số mở
- **VRAM**: tối thiểu 4 GB cho clip 30 giây; thoải mái ở 8 GB
- **Tốc độ**: RTF (Hệ Số Thời Gian Thực) ~0.3 trên RTX 4090 (nhanh hơn thời gian thực)
- **Dữ liệu huấn luyện**: 40,000+ giờ mã nguồn mở / 100,000+ giờ mô hình đầy đủ

## 1. Vì Sao ChatTTS Thắng TTS Truyền Thống Cho Hội Thoại

Phân chia cũ:
- **TTS ghép nối** (festival, v.v.) — máy móc, không prosody, đang chết
- **TTS thần kinh** (Tacotron / FastSpeech / VITS) — trôi chảy nhưng đơn điệu, tối ưu cho thuyết minh
- **API thương mại** (ElevenLabs / OpenAI TTS) — tự nhiên nhưng $0.18-0.50/1000 ký tự và đóng nguồn

ChatTTS nằm ở category thứ 4 mới: **TTS tạo sinh tự hồi quy với token điều khiển prosody rõ ràng**. Bạn không chỉ gõ text — bạn có thể đánh dấu `[laugh]`, `[uv_break]` (ừm), `[lbreak]` (tạm dừng dài), và mô hình tạo ra biểu diễn giọng nói, không chỉ giọng nói.

Cho các trường hợp sử dụng hội thoại (agent giọng nói, podcast AI, đối thoại NPC trong game), đây là khác biệt giữa "rõ ràng robot" và "có thể là người thật trên đường dây điện thoại xấu". Cho thuyết minh, TTS thần kinh cổ điển thường vẫn tốt hơn.

## 2. Yêu Cầu Phần Cứng (Số Liệu Thực Tế)

| Phần cứng | Thời gian sinh clip 30s | Sử dụng thực tế |
|---|---|---|
| GPU 4 GB (GTX 1650 / 3050) | ~25 giây | Sở thích, clip đơn |
| GPU 8 GB (RTX 3060 / 4060) | ~10 giây | Dev solo, batch job |
| GPU 12 GB (RTX 3060 12GB / 4070) | ~5 giây | Production, tải đồng thời thấp |
| GPU 24 GB (RTX 4090 / A5000) | ~3 giây | Production, đồng thời cao |
| Chỉ CPU | ~3-5 phút | Không thực tế cho sử dụng tương tác |

Điểm vào production self-host: GPU cloud $0.30-0.50/giờ (Vast.ai, RunPod, hoặc {{< aff "digitalocean" "chattts-gpu" "DigitalOcean GPU droplet" >}}) — rẻ hơn nhiều ElevenLabs ở bất kỳ volume có ý nghĩa.

## 3. Cài Nhanh (10 phút trên máy GPU)

```bash
git clone https://github.com/2noise/ChatTTS
cd ChatTTS
pip install -r requirements.txt
# Hoặc qua pip:
pip install ChatTTS
```

Hello world:
```python
import ChatTTS
import torchaudio
import torch

chat = ChatTTS.Chat()
chat.load(compile=False)  # Đặt True cho tăng tốc ~30% sau lần chạy đầu

texts = ["Xin chào, đây là test TTS hội thoại [uv_break] nghe tự nhiên không?"]
wavs = chat.infer(texts)

torchaudio.save("out.wav", torch.from_numpy(wavs[0]), 24000)
```

Lần chạy đầu tải xuống ~2 GB trọng số mô hình. Lần chạy sau tức thời.

## 4. Token Điều Khiển Prosody (Tính Năng Killer)

Lý do ChatTTS cảm thấy sống động — các tag này hoạt động giữa văn bản:

| Tag | Hiệu ứng |
|---|---|
| `[laugh]` | Chèn tiếng cười |
| `[laugh_0]` đến `[laugh_2]` | Mức độ tiếng cười |
| `[uv_break]` | Tạm dừng kiểu ừm |
| `[lbreak]` | Tạm dừng dài hơn (kiểu câu) |
| `[oral_0]` đến `[oral_9]` | Cường độ phong cách hội thoại (cao hơn = thường hơn) |
| `[speed_0]` đến `[speed_9]` | Tốc độ nói (5 = bình thường) |
| `[break_0]` đến `[break_7]` | Thời gian tạm dừng rời rạc |

Ví dụ:
```python
text = "Tôi đã nói với anh ấy [uv_break] không thể nào là sự thật [laugh] [lbreak] nhưng anh ấy cứ khăng khăng."
wavs = chat.infer([text])
```

Đây là cái đóng khoảng cách "robot vs người". Dùng tiết kiệm; gắn tag quá nhiều nghe như đã tập dượt.

## 5. Multi-Speaker — Giọng Ổn Định Qua Phiên

ChatTTS tạo "speaker" khác nhau mỗi lần gọi mặc định. Cho nhân vật nhất quán (giọng NPC, nhân cách agent bền vững), seed speaker một lần và tái sử dụng:

```python
# Tạo và lưu speaker ổn định
rand_spk = chat.sample_random_speaker()
torch.save(rand_spk, "speaker_alice.pt")

# Sử dụng trong các lần chạy sau
spk = torch.load("speaker_alice.pt")
params_infer_code = ChatTTS.Chat.InferCodeParams(spk_emb=spk)
wavs = chat.infer(texts, params_infer_code=params_infer_code)
```

Pattern: pre-tạo 5-10 embedding speaker khác biệt trong quá trình setup. Chọn cái khớp mỗi nhân vật. Giọng ổn định qua toàn production.

## 6. Lưu Ý Licensing (Đọc Trước Production)

**Hai license, hai nghĩa vụ khác nhau**:
- **Code**: AGPL-3.0 — copyleft, tác phẩm phái sinh phải mã nguồn mở dưới AGPL
- **Trọng số mô hình**: CC BY-NC 4.0 — **chỉ sử dụng phi thương mại**

Cho production thương mại: liên hệ 2noise cho cấp phép mô hình thương mại, HOẶC fine-tune mô hình của bạn từ đầu trên kiến trúc ChatTTS mở (nỗ lực đáng kể nhưng pháp lý sạch).

Cho sở thích, nghiên cứu, công cụ nội bộ, và hầu hết prototype agent: license NC ổn.

Đây là điểm ma sát duy nhất về việc áp dụng. Nếu sản phẩm của bạn trực tiếp kiếm tiền từ giọng nói sinh ra, tính chi phí licensing vào (hoặc chọn lựa chọn thay thế thân thiện thương mại như Coqui XTTS-v2).

## 7. Pattern Production

Cho pipeline agent giọng nói / podcast:

```
   Đầu vào văn bản (từ agent LLM / bộ tạo script)
            │
            ▼
   Tiền xử lý nhẹ (thêm prosody tag qua quy tắc)
            │
            ▼
   Suy luận ChatTTS (service FastAPI backed GPU)
            │
            ▼
   Audio đầu ra (WAV / Opus / streaming)
            │
            ▼
   Hậu xử lý tùy chọn (chuẩn hóa loudness, khử nhiễu)
```

Đứng nó trên {{< aff "htstack" "chattts-vps-hk" "VPS GPU HTStack Hong Kong" >}} hoặc instance Vast.ai có GPU, expose qua FastAPI, và stack của bạn có giọng nói ~$0.001 mỗi phút tạo (vs ElevenLabs ~$0.30/phút).

## 8. Khi Dùng ChatTTS vs Lựa Chọn Khác

| Trường hợp sử dụng | Chọn |
|---|---|
| Hội thoại / đa nhân vật / giọng agent | **ChatTTS** |
| Thuyết minh sách nói (giọng đơn, dài) | Coqui XTTS-v2 hoặc thương mại |
| Clone giọng từ mẫu 30 giây | OpenVoice hoặc Coqui XTTS-v2 |
| Latency thấp nhất có thể (<200ms) cho agent live | Thương mại (Deepgram Aura, ElevenLabs Flash) |
| Chất lượng cao nhất bất kể chi phí | ElevenLabs |
| Sử dụng thương mại, phải sở hữu mô hình | Coqui XTTS-v2 đã fine-tune |

## 9. Cạm Bẫy

1. **Gắn tag prosody quá nhiều** — rắc `[laugh]` và `[uv_break]` khắp nơi nghe như đã tập dượt. Ít là nhiều
2. **Quên seed speaker** — mọi cuộc gọi không `spk_emb` là giọng khác. Luôn pre-tạo
3. **Chạy trên CPU và phàn nàn về tốc độ** — RTF tệ hơn 30-100× không có GPU. Chỉ thuê GPU
4. **Bỏ qua license NC** — sử dụng ChatTTS cho sản phẩm giọng nói trả phí là rủi ro pháp lý

## TL;DR

ChatTTS = **TTS mã nguồn mở đầu tiên xử lý hội thoại thuyết phục**. 39.3k sao, tối thiểu 4 GB VRAM, prosody-aware qua token điều khiển, speaker ổn định qua seed embedding. Sử dụng cho agent giọng nói, podcast AI, NPC. Để ý license CC BY-NC cho sử dụng thương mại.

Bật instance GPU, chạy cài đặt 10 dòng ở mục 3, và bạn sẽ nghe trong 5 phút vì sao điều này thay thế mọi TTS mã nguồn mở khác trong cuộc thảo luận.

---

*Một phần của stack nội dung đa phương thức dibi8 — xem bộ sưu tập Multi-Modal Content Pipeline sắp tới cho ChatTTS + Whisper + Stable Diffusion + ComfyUI như pipeline sáng tạo audio/visual đầy đủ.*
