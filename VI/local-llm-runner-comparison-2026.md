---
title: 'Ollama vs LM Studio vs llama.cpp vs vLLM 2026: Hướng Dẫn Chọn Local LLM Runner Thành Thật'
description: 'So sánh trực tiếp 4 local LLM runner quan trọng năm 2026. Số liệu thực: Ollama (137k sao) dễ nhất, LM Studio UI đẹp nhất, llama.cpp (112k) engine bên dưới, vLLM (80.7k) vua throughput production. Cây quyết định 30 giây theo use case.'
date: 2026-05-21 00:00:00+08:00
lastmod: 2026-05-21 00:00:00+08:00
tech_stack: [Python, C++, CUDA, Metal]
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
maintainer: 'dibi8'
last_maintained: '2026-05-21'
featureImage: ''
draft: false
categories: ['llm-frameworks']
tags: ['Local LLM', 'Ollama', 'vLLM', 'llama.cpp', 'LM Studio', 'So sánh', 'Hub article']
aliases:
  - /posts/local-llm-runner-comparison-2026/
---

Câu trả lời "chạy LLM cục bộ" năm 2026 đã phân mảnh thành 4 lựa chọn nghiêm túc, mỗi cái có sweet spot rõ. Đây là bài hub chúng tôi ước có sớm — đối đầu giữa **Ollama** (137k sao, mặc định), **LM Studio** (UI đẹp nhất, dễ nhất cho non-coder), **llama.cpp** (112k sao, engine C/C++ bên dưới hầu hết tool khác), và **vLLM** (80.7k sao, vua throughput production).

Chỉ 60 giây: đọc mục 2 và chọn theo dòng của bạn. Phần còn lại cho khi team hỏi "tại sao cái này?"

## 1. Vì Sao 4 Tool Tồn Tại Cho "Cùng Việc"

Trông như làm cùng việc — load model, sinh token — nhưng mục tiêu cơ bản khác:

- **Ollama** tối ưu "5 phút từ cài đến token đầu"
- **LM Studio** tối ưu "non-developer có thể dùng cái này"
- **llama.cpp** tối ưu "chạy trên bất kỳ thiết bị có CPU"
- **vLLM** tối ưu "100 user đồng thời, max throughput trên GPU lớn"

Có thể dùng sai cái và vẫn hoạt động — nhưng sẽ cảm thấy ma sát (vLLM cho chat local casual) hoặc đụng tường (Ollama cố serve 50 user đồng thời). Pick cái match dòng bạn ở mục 2.

## 2. Cây Quyết Định 30 Giây

| Tình huống bạn | Pick |
|---|---|
| Dev solo, muốn LLM local trong 5 phút, CLI ok | **Ollama** |
| Non-coder muốn app desktop để chat với LLM local | **LM Studio** |
| Chạy trên Raspberry Pi / phần cứng lạ / muốn max control | **llama.cpp** trực tiếp |
| Production phục vụ 10+ user đồng thời trên GPU thực | **vLLM** |
| Apple Silicon Mac, muốn hiệu suất M-series tốt nhất | **llama.cpp** (Metal tốt nhất) hoặc **LM Studio** (dùng llama.cpp bên dưới) |
| API LLM multi-tenant self-host cho app | **vLLM** sau [LiteLLM gateway](/vi/resources/llm-frameworks/litellm/) |

Đã pick? Phần còn lại bài chứng minh quyết định.

## 3. Ollama — Mặc Định Cho Dev Solo

**Tóm tắt**: Một lệnh cài. `ollama run llama3.2`. Bạn đang chat trong 5 phút. Nội bộ xây trên llama.cpp — Ollama là "llama.cpp với UX tốt và catalog mô hình".

**Số liệu thực**:
- **GitHub sao**: 137k (nhiều nhất trong 4)
- **License**: MIT
- **Throughput**: ~20-25 tok/s cho mô hình 7B trên M2 / RTX 3060 (chat single-user tốt, không cho serving)
- **Phần cứng**: NVIDIA, AMD (ROCm), Apple Silicon (Metal). CPU fallback ok
- **Tính năng killer**: Catalog mô hình khổng lồ tại `ollama.com/library` — pull mô hình GGUF lượng tử với một lệnh

**Khi nào Ollama thắng**: Solo dev coding agent (pair với Continue / OpenCode), chat single-user, prototyping. Mặc định cho bộ sưu tập [Stack LLM Rẻ](/vi/collections/cheap-llm-stack/) và [Workflow AI Coding Self-Host](/vi/collections/self-hosted-ai-coding-workflow/) chính xác vì đường cong setup 5 phút.

**Khi nào không thắng**: Serving multi-user (Ollama queue request tuần tự mặc định). Cho 10+ user đồng thời, chuyển vLLM.

```bash
# Cài + chạy mô hình trong 30 giây
curl -fsSL https://ollama.com/install.sh | sh
ollama run qwen3-coder:14b
```

## 4. LM Studio — App Desktop Cho Non-Coder

**Tóm tắt**: App desktop kéo-thả (Windows / macOS / Linux). Duyệt catalog mô hình built-in, click "Tải", click "Chat". 0 phơi nhiễm CLI.

**Thực tế thực**:
- **License**: Freeware closed-source (cá nhân miễn phí; thương mại cần license)
- **Engine**: Dùng llama.cpp bên dưới (cùng định dạng mô hình GGUF)
- **Tính năng killer**: Trình duyệt mô hình trực quan, UI chat với lịch sử hội thoại, RAG trên file local qua drag-drop, server API tương thích OpenAI (một-click "start server" → expose `http://localhost:1234/v1`)
- **Phần cứng**: Cùng coverage llama.cpp — NVIDIA, AMD, Apple Silicon (Metal-tối ưu), CPU fallback

**Khi nào LM Studio thắng**: Analyst dữ liệu / PM / executive muốn chat với mô hình local mà không học terminal. Hoặc bạn muốn UI desktop bóng bẩy để test mô hình trước khi tích hợp qua Ollama / vLLM vào app.

**Khi nào không thắng**: Triển khai server (đó là app desktop), sử dụng thương mại (chi phí license), workflow version-controlled (không config thân thiện Git).

**Pairing đề xuất**: LM Studio cho khám phá → Ollama cho daily-driver server → vLLM cho production scale.

## 5. llama.cpp — Engine Bên Dưới

**Tóm tắt**: Engine suy luận C/C++ mà Ollama, LM Studio, và hàng chục project khác sử dụng nội bộ. Bằng chạy trực tiếp bạn có max control + bộ tính năng tiên tiến trước 1-2 phiên bản so với expose trong wrapper.

**Số liệu thực**:
- **GitHub sao**: 112k
- **License**: MIT
- **Phần cứng**: Theo đúng nghĩa mọi thứ — Apple Metal (hỗ trợ M-series tốt nhất, tối ưu qua NEON/Accelerate), NVIDIA CUDA, AMD HIP, Intel/AMD CPU (AVX/AVX2/AVX512), Vulkan, SYCL, thậm chí WebGPU trong trình duyệt, RISC-V, ARM
- **Lượng tử hóa**: Định dạng GGUF, 1.5-bit đến 8-bit, lựa chọn lượng tử rộng nhất có sẵn
- **Tính năng killer**: Suy luận CPU+GPU hybrid (chia mô hình lớn hơn VRAM giữa GPU và system RAM), output ràng buộc ngữ pháp, API tương thích OpenAI `llama-server`

**Khi nào llama.cpp thắng**:
- Phần cứng lạ (Raspberry Pi 5, RISC-V SBC, browser qua WebGPU)
- Mô hình lớn hơn VRAM của bạn (chia CPU+GPU)
- Cần lượng tử hóa tiên tiến (1.5-bit, 2-bit định dạng thực nghiệm)
- Muốn 0 dependency (single C++ binary, ~10 MB)

**Khi nào không thắng**: Bạn không thích đọc cờ compile C++. Hầu hết user muốn wrapper Ollama / LM Studio.

```bash
# Compile và chạy
git clone https://github.com/ggml-org/llama.cpp
cd llama.cpp && make -j
./llama-cli -m model.gguf -p "Hello"
```

## 6. vLLM — Vua Throughput Production

**Tóm tắt**: Khi cần serve 10-1000 user đồng thời trên GPU thực, **PagedAttention** + **continuous batching** + **prefix caching** của vLLM nghiền nát mọi lựa chọn thay thế về throughput. Lựa chọn de-facto cho "Tôi chạy API LLM multi-tenant trong production".

**Số liệu thực**:
- **GitHub sao**: 80.7k
- **License**: Apache-2.0
- **Phần cứng**: NVIDIA (tốt nhất), AMD ROCm, Apple Silicon, Intel Gaudi, Google TPU, Huawei Ascend, IBM Spyre, thậm chí ARM/RISC-V CPU
- **Tính năng killer**: PagedAttention (cải thiện throughput 2-24× so với serving ngây thơ), continuous batching, prefix caching, speculative decoding, multi-LoRA hot-swap, API tương thích OpenAI
- **Lượng tử hóa**: FP8, INT8, INT4, GPTQ, AWQ, GGUF — hỗ trợ lượng tử production rộng nhất

**Khi nào vLLM thắng**: Serving multi-tenant production. API LLM thương mại self-host. Bất kỳ workload "Tôi cần xử lý 50+ request/giây trên 4090 này". Pair với [Stack LLM Rẻ](/vi/collections/cheap-llm-stack/) khi vượt mô hình single-user của Ollama.

**Khi nào không thắng**: Chat local dev solo (Ollama nhanh hơn để setup). Phần cứng chỉ CPU (vLLM hoạt động trên CPU nhưng không tối ưu cho nó như llama.cpp).

```bash
# Cài nhanh + serve
pip install vllm
vllm serve meta-llama/Llama-3.2-3B-Instruct --port 8000
# Giờ hit http://localhost:8000/v1 với OpenAI SDK
```

## 7. Đối Đầu Trực Diện — Bảng Số Liệu

| Metric | Ollama | LM Studio | llama.cpp | vLLM |
|---|---|---|---|---|
| GitHub sao | **137k** | N/A (closed) | 112k | 80.7k |
| License | MIT | Closed freeware | MIT | Apache-2.0 |
| Độ khó cài | ⭐ (một lệnh) | ⭐ (tải app) | ⭐⭐⭐ (compile) | ⭐⭐ (pip install) |
| Throughput single-user (7B, RTX 3060) | ~20 tok/s | ~20 tok/s | ~22 tok/s | ~25 tok/s |
| **Throughput multi-user (10 đồng thời)** | ~25 tok/s tổng | N/A (desktop) | ~30 tok/s | **~200 tok/s** ⭐ |
| Độ rộng phần cứng | NVIDIA/AMD/Apple | Cùng | **Mọi thứ** | NVIDIA/AMD/TPU/v.v. |
| Suy luận CPU+GPU hybrid | ✅ (qua llama.cpp) | ✅ | **✅ (tốt nhất)** | ⚠️ Hạn chế |
| Hiệu suất Apple Silicon tốt nhất | Tốt | Tốt | **Tốt nhất** | Tốt |
| Multi-tenancy production | ⚠️ Hạn chế | ❌ (desktop) | ⚠️ Thủ công | **✅** ⭐ |
| Tốt nhất cho | Dev solo CLI | Non-coder GUI | Phần cứng lạ / max control | Production serving |

Đọc theo dòng, pick theo ràng buộc áp đảo.

## 8. Kịch Bản Thực Tế

**Kịch bản A — Founder solo code với AI**: Ollama trên laptop bạn. Xong. Kết nối tới OpenCode / Continue / Cursor qua API tương thích OpenAI. Xem [Workflow AI Coding Self-Host](/vi/collections/self-hosted-ai-coding-workflow/) cho stack đầy đủ.

**Kịch bản B — Chatbot công ty nội bộ cho 50 nhân viên**: vLLM trên GPU chuyên dụng 24 GB (RTX 4090 hoặc A5000) trên {{< aff "htstack" "vllm-vps-hk" "HTStack VPS Hong Kong" >}} hoặc {{< aff "digitalocean" "vllm-droplet" "DigitalOcean GPU droplet" >}}. Fronted bởi [LiteLLM gateway](/vi/resources/llm-frameworks/litellm/) cho auth + theo dõi chi tiêu per-user.

**Kịch bản C — VP Marketing muốn chat với tài liệu**: LM Studio. Họ drag and drop PDF vào giao diện RAG. Cần training 0. Tiết kiệm thời gian engineering cho use case thực sự cần engineering.

**Kịch bản D — Chạy Qwen 3 14B trên Raspberry Pi 5**: llama.cpp trực tiếp. Ollama có thể hoạt động, nhưng tối ưu ARM của llama.cpp và `--n-gpu-layers 0` cho CPU thuần cho bạn squeeze nhiều nhất.

**Kịch bản E — Pipeline nội dung AI đa phương thức**: Dùng Ollama cho fallback local trong [Pipeline Nội Dung Đa Phương Thức](/vi/collections/multi-modal-content-pipeline/). Thăng cấp lên vLLM khi job sinh đồng thời vượt queue tuần tự của Ollama.

## 9. Mặc Định "Chỉ Dùng Ollama" Thường Đúng

Ollama xây trên llama.cpp. LM Studio xây trên llama.cpp. Vậy câu hỏi cho 80% user không phải "engine suy luận nào" — mà "UX wrapper nào tôi thích".

- **Thích CLI + catalog mô hình**: Ollama
- **Thích GUI desktop + 0 phơi nhiễm CLI**: LM Studio
- **Cả hai bên dưới như nhau. Cả hai tạo output giống nhau.**

Người duy nhất thực sự cần lựa chọn thực:
- Người thích nghịch phần cứng (llama.cpp trực tiếp)
- Production serving (vLLM)
- Mọi người khác: dùng Ollama hoặc LM Studio dựa trên sở thích UI

## 10. Đường Migration Nhanh

Có thể mix và chuyển. Tiến hóa thông thường:

1. **Ngày 1**: Cài Ollama. Chạy được một mô hình
2. **Tuần 1-4**: Dùng Ollama với editor / agent. Nhận ra muốn UI chat desktop cho task không-coding. Thêm LM Studio
3. **Tháng 3+**: Xây sản phẩm thực. Nhận ra Ollama queue request tuần tự. Thêm vLLM sau LiteLLM cho tier production; giữ Ollama cho phát triển
4. **Năm 1+**: Đụng phần cứng lạ (RISC-V SBC, triển khai trình duyệt) hoặc muốn lượng tử tiên tiến. Tụt xuống llama.cpp trực tiếp cho workload cụ thể đó

Không bao giờ phải "chọn một và stick với nó". Các lớp khác nhau của cùng stack vui vẻ cùng tồn tại.

## TL;DR

Bốn local LLM runner, bốn sweet spot:

- **Ollama** (137k sao) — mặc định dev solo CLI
- **LM Studio** — GUI desktop non-coder
- **llama.cpp** (112k sao) — phần cứng lạ + max control + engine bên dưới các cái khác
- **vLLM** (80.7k sao) — serving multi-tenant production

Không có local LLM runner "tốt nhất phổ quát". Có cái match dòng bạn ở mục 2. Pick cái đó, ship, và đánh giá lại khi số user đồng thời vượt 10 (đó là tín hiệu Ollama → vLLM).

---

*Nội dung đồng hành: [Bộ sưu tập Stack LLM Rẻ](/vi/collections/cheap-llm-stack/) dùng Ollama làm runner local mặc định. [Workflow AI Coding Self-Host](/vi/collections/self-hosted-ai-coding-workflow/) và [Stack Knowledge Base](/vi/collections/knowledge-base-stack/) đều cưỡi Ollama cho suy luận local. [Portkey vs LiteLLM vs OpenRouter](/vi/resources/llm-frameworks/llm-gateway-portkey-litellm-openrouter-comparison-2026/) cho layer gateway phía trước nhiều runner.*
