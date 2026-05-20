---
title: 'VoiceCraft: 8.5K+ Stars — Zero-Shot Speech Editing so với GPT-SoVITS, XTTS 2026'
description: 'VoiceCraft là mô hình ngôn ngữ codec thần kinh zero-shot speech editing và TTS, tương thích với GPT-SoVITS, Coqui TTS, RVC. Hướng dẫn cài đặt, benchmark, triển khai Docker và bảng so sánh.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/jasonppy/VoiceCraft'
stars: 8500
maintainer: 'jasonppy'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['ai-tools']
tags: ['voicecraft', 'zero-shot-tts', 'chinh-sua-giong-noi', 'neural-codec', 'voice-cloning', 'ai-audio', 'docker', 'python']
aliases:
- /vi/posts/voicecraft/
---

{{</* resource-info */>}}

## Giới thiệu

Chỉnh sửa âm thanh lồng tiếng từng đồng nghĩa với việc thu âm toàn bộ trong phòng thu. Nếu một podcaster vấp váy một từ hoặc ngườii đọc sách nói sai tên, cách sửa là đặt thêm một buổi thu, thiết lập micro và khớp giọng gốc. Quy trình này tốn kém và chậm. Năm 2024, nhóm nghiên cứu từ UT Austin và Meta FAIR công bố **VoiceCraft**, một mô hình ngôn ngữ codec thần kinh chỉnh sửa giọng nói và nhân bản giọng chỉ từ vài giây âm thanh tham khảo. Repository hiện có **8,500+ stars** trên GitHub với 796 forks, bài báo được chấp nhận tại ACL 2024. Hướng dẫn này đi qua thiết lập VoiceCraft, so sánh với GPT-SoVITS, XTTS v2 và Coqui TTS, và trình bày các mẫu triển khai production với Docker.

## VoiceCraft là gì?

**VoiceCraft** là một mô hình ngôn ngữ codec thần kinh token infilling thực hiện hai nhiệm vụ cốt lõi: (1) nhân bản giọng zero-shot text-to-speech (TTS) và (2) chỉnh sửa giọng nói trong bản ghi hiện có. Khác với pipeline TTS truyền thống cần hàng giờ dữ liệu huấn luyện cho mỗi ngườii nói, VoiceCraft chỉ cần 3-5 giây âm thanh tham khảo để tái tạo giọng với độ trung thực cao. Nó được xây dựng trên kiến trúc Transformer decoder và giới thiệu thủ tục token rearrangement kết hợp causal masking với delayed stacking, cho phép tạo sinh tự hồi quy có điều kiện từ ngữ cảnh hai chiều.

![Tổng quan kiến trúc VoiceCraft](https://raw.githubusercontent.com/jasonppy/VoiceCraft/main/assets/overview.png)
*Hình 1: Tổng quan kiến trúc VoiceCraft — token infilling với causal masking và delayed stacking cho chỉnh sửa giọng nói và TTS.*

## VoiceCraft hoạt động như thế nào

### Tổng quan kiến trúc

Pipeline mô hình gồm ba giai đoạn:

1. **EnCodec Quantization**: Sóng âm thanh thô được lượng tử hóa thành token rờii rạc bằng codec thần kinh EnCodec của Meta. Mỗi khung âm thanh được biểu diễn bằng vector K chỉ mục codebook (lượng tử hóa vector residual, RVQ).

2. **Token Rearrangement**: Đây là sáng kiến cốt lõi của VoiceCraft. Thủ tục hai bước biến đổi bài toán chỉnh sửa/infilling thành bài toán mô hình hóa ngôn ngữ từ trái sang phải:
   - **Causal Masking**: Các đoạn token ngẫu nhiên bị che và chuyển về cuối chuỗi, cho phép mô hình chú ý đến ngữ cảnh hai chiều trong quá trình sinh tự hồi quy.
   - **Delayed Stacking**: Các vector được dịch chéo để dự đoán codebook k tại thờii điểm t có điều kiện từ codebook k-1, cho phép mô hình hóa multi-codebook hiệu quả.

3. **Transformer Decoder**: Chuỗi token đã sắp xếp lại được mô hình hóa tự hồi quy bởi Transformer decoder. Các âm vị văn bản và token âm thanh được nối làm đầu vào điều kiện.

### Các phiên bản mô hình

| Mô hình | Tham số | Phù hợp cho | Thờii lượng tối đa |
|---------|---------|------------|-------------------|
| giga330M | 330M | Cân bằng chất lượng/tốc độ | 16 giây |
| giga830M | 830M | Chất lượng cao nhất | 30+ giây |
| giga330M-TTS-Enhanced | 330M | Fine-tune chuyên TTS | 16 giây |

### Bộ dữ liệu RealEdit

VoiceCraft giới thiệu **RealEdit**, bộ dữ liệu benchmark gồm 310 ví dụ chỉnh sửa giọng nói thực tế từ sách nói, video YouTube và podcast Spotify. Khác với bộ dữ liệu phòng thí nghiệm sạch (LibriTTS, VCTK), RealEdit chứa đa dạng giọng vùng miền, tiếng ồn nền, nhạc và phong cách nói — biến nó thành thước đo thực tiễn cho chất lượng chỉnh sửa giọng nói.

![Sơ đồ chỉnh sửa giọng nói VoiceCraft](https://jasonppy.github.io/VoiceCraft_web/static/editing_figure.png)
*Hình 2: Quy trình chỉnh sửa giọng nói VoiceCraft — âm thanh gốc, bản ghi mục tiêu và đầu ra chỉnh sửa đã tổng hợp.*

## Cài đặt & Thiết lập

### Tùy chọn 1: Docker (Khuyến nghị)

Docker là con đường nhanh nhất đến môi trường VoiceCraft hoạt động. Dockerfile chính thức xử lý mọi phụ thuộc bao gồm EnCodec, Montreal Forced Aligner (MFA) và CUDA binding.

```bash
# 1. Clone repository
git clone https://github.com/jasonppy/VoiceCraft.git
cd VoiceCraft

# 2. Build Docker image
docker build --tag "voicecraft" .

# 3. Khởi động container (Linux)
./start-jupyter.sh
# Windows:
# start-jupyter.bat

# 4. Lấy link Jupyter từ logs
docker logs jupyter | grep "127.0.0.1:8888"

# 5. Xác minh GPU trong container
docker exec -it jupyter nvidia-smi
```

Container expose Jupyter Lab trên cổng 8888 và Gradio UI trên cổng 7860. Mở `inference_tts.ipynb` hoặc `inference_speech_editing.ipynb` để chạy inference.

### Tùy chọn 2: Môi trường Conda (Phát triển local)

Để phát triển và fine-tune mô hình, môi trường Conda local cung cấp linh hoạt hơn.

```bash
# Tạo và kích hoạt môi trường
conda create -n voicecraft python=3.9.16
conda activate voicecraft

# Cài PyTorch với CUDA 11.7
pip install torch==2.0.1 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu117

# Cài audiocraft (phụ thuộc EnCodec)
pip install -e git+https://github.com/facebookresearch/audiocraft.git@c5157b5bf14bf83449c17ea1eeb66c19fb4bc7f0#egg=audiocraft

# Cài xformers cho attention tiết kiệm bộ nhớ
pip install xformers==0.0.22

# Phụ thuộc cốt lõi
pip install tensorboard==2.16.2
pip install phonemizer==3.2.1
pip install datasets==2.16.0
pip install torchmetrics==0.11.1
pip install huggingface_hub==0.22.2

# Phụ thuộc hệ thống
apt-get install -y ffmpeg espeak-ng

# Cài Montreal Forced Aligner (MFA) để căn chỉnh text-audio
conda install -c conda-forge montreal-forced-aligner=2.2.17 openfst=1.8.2 kaldi=5.5.1068

# Tải mô hình tiếng Anh của MFA
mfa model download dictionary english_us_arpa
mfa model download acoustic english_us_arpa

# Jupyter kernel (tùy chọn)
conda install -n voicecraft ipykernel --no-deps --force-reinstall
```

### Tùy chọn 3: Gradio Local UI

Để có giao diện trình duyệt mà không cần notebook:

```bash
# Phụ thuộc hệ thống bổ sung cho Gradio
apt-get install -y espeak espeak-data libespeak1 libespeak-dev
apt-get install -y festival build-essential flac libasound2-dev libsndfile1-dev

# Cài Gradio requirements
pip install -r gradio_requirements.txt

# Khởi động Gradio server
python gradio_app.py
```

Truy cập UI web tại `http://127.0.0.1:7860`.

### Yêu cầu phần cứng

| Cấu hình | GPU tối thiểu | GPU khuyến nghị | RAM |
|---------|--------------|----------------|-----|
| Inference đầy đủ (830M) | 8 GB (kvcache) | 32 GB VRAM | 32 GB |
| Inference nhanh (330M) | 8 GB | 16 GB VRAM | 16 GB |
| Gradio UI | 8 GB | 16 GB VRAM | 16 GB |

Tối ưu hóa `kvcache` đánh đổi một chút chất lượng để giảm đáng kể bộ nhớ, cho phép GPU 8 GB chạy inference.

## Tích hợp với các công cụ phổ biến

### VoiceCraft + Gradio Web UI

Giao diện Gradio tích hợp cung cấp cách dễ nhất để thử nghiệm:

```bash
# Khởi động Gradio với cài đặt mặc định
python gradio_app.py --model-name "giga330M" --device "cuda"

# Với đường dẫn mô hình tùy chỉnh
python gradio_app.py \
  --model-path "./pretrained_models/giga330M.pth" \
  --codec-model "encodec_16khz" \
  --share  # Tạo URL công khai
```

Gradio UI hỗ trợ ba chế độ: **Chế độ TTS** (nhân bản giọng zero-shot), **Chế độ Edit** (chỉnh sửa giọng nói), và **Chế độ Long TTS** (tạo chuỗi chunk cho văn bản dài).

### VoiceCraft + Jupyter Notebook

Để truy cập lập trình, sử dụng Jupyter notebook:

```python
# inference_tts.ipynb — Ví dụ zero-shot TTS
from voicecraft import VoiceCraft

# Tải mô hình 330M (nhanh hơn, chất lượng tốt)
model = VoiceCraft.from_pretrained("pyp1/VoiceCraft", subfolder="giga330M")

# Cung cấp 3-5 giây âm thanh tham khảo
reference_audio = "demo/pam.wav"  # Clip tham khảo
reference_text = "I found the amazing VoiceCraft model"

# Văn bản cần tổng hợp
target_text = "This is a test of zero shot voice cloning with VoiceCraft"

# Tạo sinh
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,  # Cập nhật tháng 3/2025: top-k=40 cải thiện chất lượng
    temperature=1.0
)
output.save("output_tts.wav")
```

### VoiceCraft + Dòng lệnh

Cho xử lý hàng loạt và scripting:

```bash
# TTS inference qua CLI
python tts_demo.py \
  --audio_path "demo/pam.wav" \
  --target_transcript "This is the text to speak" \
  --model_name "giga330M" \
  --top_k 40 \
  --temperature 1.0 \
  --output_path "output.wav"

# Chỉnh sửa giọng nói qua CLI
python speech_editing_demo.py \
  --audio_path "demo/pam.wav" \
  --original_transcript "original text here" \
  --edited_transcript "edited text here" \
  --model_name "giga830M" \
  --output_path "edited_output.wav"
```

### VoiceCraft + Docker API

Để triển khai production, gói VoiceCraft trong REST API:

```dockerfile
# Dockerfile.api — Wrapper API production
FROM voicecraft:latest

WORKDIR /app
COPY api.py ./
COPY requirements-api.txt ./

RUN pip install -r requirements-api.txt

EXPOSE 8000

CMD ["uvicorn", "api:app", "--host", "0.0.0.0", "--port", "8000"]
```

```python
# api.py — FastAPI wrapper cho VoiceCraft
from fastapi import FastAPI, UploadFile, File
from voicecraft import VoiceCraft
import torchaudio

app = FastAPI()
model = VoiceCraft.from_pretrained("pyp1/VoiceCraft", subfolder="giga330M")

@app.post("/tts")
async def tts(
    audio: UploadFile = File(...),
    reference_text: str = "",
    target_text: str = ""
):
    """Endpoint zero-shot TTS."""
    ref_audio, sr = torchaudio.load(audio.file)
    output = model.tts(
        target_text=target_text,
        reference_audio=ref_audio,
        reference_text=reference_text,
        top_k=40
    )
    return {"output": output.serialize()}
```

### VoiceCraft + HuggingFace Hub

Tải trực tiếp mô hình pretrained từ HuggingFace:

```python
from huggingface_hub import hf_hub_download

# Tải trọng số mô hình
model_path = hf_hub_download(
    repo_id="pyp1/VoiceCraft",
    filename="giga330M.pth",
    subfolder="",
    local_dir="./pretrained_models"
)

# Cũng có thể tải qua ModelScope (cho khu vực Trung Quốc)
from modelscope import snapshot_download
model_dir = snapshot_download('AI-ModelScope/VoiceCraft')
```

## Benchmark / Use case thực tế

### Benchmark Zero-shot TTS

Kết quả đánh giá con ngườii từ bài báo ACL 2024 so sánh VoiceCraft với VALL-E, XTTS v2, FluentSpeech và YourTTS trên 250 câu kiểm tra (LibriTTS + YouTube):

| Mô hình | WER | SIM | Intelligibility MOS | Naturalness MOS | Speaker Similarity MOS |
|---------|-----|-----|---------------------|-----------------|----------------------|
| **VoiceCraft** | **4.5** | **0.55** | **4.23** | **4.17** | **4.34** |
| XTTS v2 | 3.6 | 0.47 | 4.13 | 3.96 | 3.44 |
| VALL-E | 7.1 | 0.50 | 4.00 | 3.86 | 4.07 |
| FluentSpeech | 3.5 | 0.47 | 3.67 | 3.38 | 4.01 |
| YourTTS | 6.6 | 0.41 | 3.14 | 2.79 | 2.79 |
| Ground Truth | 3.8 | 0.76 | 4.39 | 4.48 | 4.44 |

VoiceCraft đạt độ tương đồng giọng nói cao nhất (SIM 0.55) và điểm MOS đánh giá con ngườii tốt nhất trên mọi hạng mục. Chỉ kém ground truth 0.16 về intelligibility và 0.10 về speaker similarity.

### Benchmark Chỉnh sửa giọng nói

Trên bộ dữ liệu RealEdit (310 ví dụ chỉnh sửa thực tế), VoiceCraft vượt trội hơn FluentSpeech:

| Mô hình | WER | Intelligibility MOS | Naturalness MOS |
|---------|-----|---------------------|-----------------|
| **VoiceCraft** | 6.1 | **4.11** | **4.03** |
| FluentSpeech | 4.5 | 3.97 | 3.81 |
| Original (chưa chỉnh sửa) | 5.4 | 4.22 | 4.17 |

Đáng chú ý, trong bài kiểm tra nghe song song, ngườii nghe thích giọng được chỉnh bởi VoiceCraft hơn **bản ghi gốc chưa chỉnh sửa** 48% thờii gian — nghĩa là đầu ra của mô hình gần như không thể phân biệt được với âm thanh thật.

### Ứng dụng thực tế

| Use case | Âm thanh tham khảo | Chất lượng đầu ra | Thờii gian thiết lập |
|----------|-------------------|-------------------|---------------------|
| Chỉnh sửa podcast | 5 giây giọng host | Naturalness MOS 4.03 | < 2 phút |
| Nhân bản giọng sách nói | 5 giây giọng ngườii đọc | SIM 0.55 | < 2 phút |
| Lồng tiếng video YouTube | 5 giây giọng ngườii nói | Naturalness MOS 4.17 | < 2 phút |
| Tổng hợp giọng tổng đài | 3 giây giọng nhân viên | SIM 0.55 | < 1 phút |

![Trang demo VoiceCraft](https://jasonppy.github.io/VoiceCraft_web/static/teaser_figure.png)
*Hình 3: Trang demo VoiceCraft hiển thị ví dụ chỉnh sửa giọng nói — ngườii nghe không thể phân biệt bản chỉnh sửa và bản gốc trong 48% trường hợp.*

## Sử dụng nâng cao / Củng cố production

### Tối ưu bộ nhớ với KV Cache

Cho GPU VRAM hạn chế, bật key-value cache:

```python
# Bật kvcache cho GPU 8GB
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,
    kvcache=True,  # Giảm VRAM ~60%
    batch_size=1
)
```

### Top-k Sampling (Cập nhật tháng 3/2025)

Chiến lược lấy mẫu mặc định được cập nhật từ top-p=1.0 sang top-k=40, cải thiện đáng kể chất lượng đầu ra:

```python
# Khuyến nghị: top-k=40 cho chất lượng tốt nhất
output = model.tts(
    target_text=target_text,
    reference_audio=reference_audio,
    reference_text=reference_text,
    top_k=40,
    temperature=1.0
)
```

### Fine-tune trên dữ liệu tùy chỉnh

Cho giọng vùng miền cụ thể, fine-tune mô hình pretrained:

```bash
# Chuẩn bị bộ dữ liệu
conda activate voicecraft
cd ./data
python phonemize_encodec_encode_hf.py \
  --dataset_size xs \
  --download_to /path/to/downloads \
  --save_dir /path/to/processed \
  --encodec_model_path /path/to/encodec \
  --mega_batch_size 120 \
  --batch_size 32 \
  --max_len 30000

# Bắt đầu fine-tune
cd ../z_scripts
bash e830M_ft.sh  # Fine-tune mô hình 830M
```

### Giám sát và logging

```python
import logging
from torch.utils.tensorboard import SummaryWriter

# Thiết lập logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("voicecraft")

# TensorBoard cho giám sát huấn luyện
writer = SummaryWriter(log_dir="./runs/voicecraft-ft")
writer.add_scalar("loss/train", loss.item(), global_step)
writer.add_scalar("mos/validation", val_mos, global_step)
```

### Bảo mật và an toàn

Giấy phép VoiceCraft (CC BY-NC-SA 4.0 cho code, Coqui Public Model License cho trọng số) có điều khoản đạo đức cấm sử dụng để tạo hoặc chỉnh sửa giọng nói của ngườii khác mà không có sự đồng ý. Cho triển khai production:

- Xác minh ngườii nói trước khi nhân bản
- Ghi log mọi yêu cầu tổng hợp để kiểm tra
- Thêm watermarking cho giọng tổng hợp
- Giới hạn tốc độ API để ngăn lạm dụng

## So sánh với các phương án thay thế

| Tính năng | VoiceCraft | GPT-SoVITS | Coqui TTS (XTTS v2) | VALL-E |
|-----------|-----------|------------|-------------------|--------|
| **GitHub Stars** | 8.500 | 57.000 | 35.000* | N/A (chỉ bài báo) |
| **Tham số** | 330M / 830M | ~1B | 467M | 1B |
| **Chỉnh sửa giọng** | Native, SotA | Không | Không | Hạn chế |
| **Zero-shot TTS** | 3-5 giây tham khảo | 5 giây tham khảo | 6 giây tham khảo | 3 giây tham khảo |
| **Speaker Similarity MOS** | 4,34 | ~4,0 | 3,44 | 4,07 |
| **Naturalness MOS** | 4,17 | ~3,8 | 3,96 | 3,86 |
| **Ngôn ngữ** | Tiếng Anh | EN, JA, KO, ZH, Yue | 17 ngôn ngữ | Tiếng Anh |
| **RTF Inference** | ~0,3x (GPU) | 0,028x (4060Ti) | 0,18x (A100) | ~0,5x |
| **Giấy phép** | CC BY-NC-SA 4.0 | MIT | CPML (phi thương mại) | N/A |
| **Docker** | Chính thức | Cộng đồng | Cộng đồng | N/A |
| **Gradio UI** | Tích hợp | Tích hợp | CLI/API | N/A |
| **Fine-tune** | Hỗ trợ | Hỗ trợ | Hỗ trợ | N/A |

*Stars của repository Coqui TTS bao gồm tất cả các mô hình TTS, không chỉ XTTS.

**Khi chọn VoiceCraft:**
- **Chỉnh sửa giọng nói** là use case chính — không có đối thủ mã nguồn mở nào sánh bằng
- Cần **độ tương đồng giọng cao nhất** (MOS 4,34 so với 3,44 của XTTS)
- Làm việc với âm thanh **ồn ào, thực tế** (podcast, video YouTube)
- Nghiên cứu học thuật hoặc phi thương mại (giấy phép CC BY-NC-SA)

**Khi chọn GPT-SoVITS:**
- Cần nhân bản giọng **Trung Quốc hoặc Nhật Bản**
- Cần sử dụng thương mại (giấy phép MIT)
- Tốc độ inference nhanh nhất là quan trọng (RTF 0,028)
- Fine-tune few-shot với 1 phút dữ liệu

**Khi chọn XTTS v2:**
- Cần hỗ trợ **đa ngôn ngữ** (17 ngôn ngữ)
- Đã sử dụng hệ sinh thái Coqui TTS
- Chấp nhận giấy phép thương mại của Coqui

## Hạn chế / Đánh giá trung thực

VoiceCraft không phải công cụ phù hợp cho mọi tác vụ âm thanh. Đây là những gì nhóm bảo trì và bài báo thừa nhận:

1. **Chỉ tiếng Anh**: Mô hình phát hành chỉ hỗ trợ âm vị tiếng Anh. VoiceCraft-X (tháng 11/2024) mở rộng sang 11 ngôn ngữ nhưng là một mô hình riêng biệt.

2. **Giấy phép phi thương mại**: Cả code (CC BY-NC-SA 4.0) và trọng số mô hình (Coqui Public Model License) đều hạn chế sử dụng thương mại nếu không có thỏa thuận bổ sung.

3. **Yêu cầu phần cứng**: Mô hình 830M cần 32 GB bộ nhớ GPU cho inference đầy đủ. Ngay cả mô hình 330M cũng cần quản lý bộ nhớ cẩn thận trên GPU phổ thông.

4. **Artifact tạo sinh**: Đôi khi xuất hiện tiếng im lặng kéo dài và tiếng cào trong âm thanh được tạo. Giải pháp (lấy mẫu nhiều đầu ra và chọn cái ngắn nhất) tăng chi phí tính toán.

5. **Không hỗ trợ streaming inference**: VoiceCraft tạo toàn bộ chuỗi tự hồi quy, khiến TTS streaming thờii gian thực không thực tế so với các mô hình như Kokoro hay MeloTTS.

6. **Thiết lập phức tạp**: So với các công cụ TTS có thể cài qua pip, VoiceCraft cần Docker hoặc Conda với MFA, EnCodec và phiên bản CUDA cụ thể — không phải cài đặt 30 giây.

## Câu hỏi thường gặp

**Q1: VoiceCraft cần bao nhiêu âm thanh tham khảo để nhân bản giọng?**

VoiceCraft cần chỉ 3-5 giây âm thanh tham khảo cho zero-shot TTS. Để có kết quả tốt nhất, sử dụng bản ghi sạch không có tiếng ồn nền hay nhạc. Mô hình mã hóa tham khảo thành embedding ngườii nói qua token EnCodec RVQ, nên tham khảo dài hơn không nhất thiết cải thiện chất lượng.

**Q2: Tôi có thể dùng VoiceCraft cho dự án thương mại không?**

Code VoiceCraft theo CC BY-NC-SA 4.0 và trọng số mô hình theo Coqui Public Model License 1.0.0 — cả hai đều hạn chế sử dụng thương mại. Nếu cần lựa chọn có giấy phép thương mại linh hoạt hơn, xem xét GPT-SoVITS (giấy phép MIT) hoặc mua giấy phép thương mại XTTS v2 từ Coqui.

**Q3: Tôi cần GPU gì để chạy VoiceCraft?**

Mô hình 830M cần 32 GB VRAM (A100, V100 hoặc RTX 4090 + chia sẻ RAM hệ thống). Mô hình 330M chạy trên GPU 16 GB, và với `kvcache=True`, inference có thể thực hiện trên card 8 GB. CPU-only inference mất 7+ phút cho mỗi câu trên Ryzen 8 lõi so với 35 giây trên GPU.

**Q4: VoiceCraft so với GPT-SoVITS trong nhân bản giọng như thế nào?**

VoiceCraft đạt độ tương đồng ngườii nói cao hơn (SIM 0,55 so với ~0,50) và tự nhiên hơn (MOS 4,17 so với ~3,8) trên âm thanh tiếng Anh. Tuy nhiên, GPT-SoVITS hỗ trợ tiếng Trung và tiếng Nhật nguyên bản, inference nhanh hơn (RTF 0,028 so với ~0,3), và sử dụng giấy phép MIT linh hoạt hơn. Về chỉnh sửa giọng nói cụ thể, VoiceCraft không có đối thủ mã nguồn mở nào.

**Q5: VoiceCraft có thể chỉnh sửa bản ghi hiện có mà không tổng hợp lại toàn bộ file không?**

Có — chỉnh sửa giọng nói là khả năng khác biệt chính của VoiceCraft. Bạn chỉ định đoạn cần chỉnh (chèn, xóa hoặc thay thế) trong bản ghi chữ, và mô hình chỉ infill các đoạn âm thanh bị ảnh hưởng trong khi bảo toàn ngữ cảnh xung quanh. Điều này hiệu quả hơn tổng hợp toàn bộ và duy trì tính liên tục âm thanh.

**Q6: Làm thế nào sửa tiếng "cào" trong âm thanh được tạo?**

Đây là vấn đề đã biết với các mô hình codec tự hồi quy. Cập nhật tháng 3/2025 (top-k=40 thay vì top-p=1.0) giảm đáng kể artifact. Các biện pháp khác: (1) lấy mẫu nhiều đầu ra và chọn cái ngắn/sạch nhất, (2) giảm nhiệt độ xuống 0.9, (3) sử dụng mô hình 330M-TTS-Enhanced được fine-tune riêng cho chất lượng TTS.

**Q7: VoiceCraft có REST API hay dịch vụ web không?**

Repository chính thức cung cấp giao diện Gradio và notebook Jupyter. Các dự án cộng đồng như VoiceCraft_API gói gọn nó trong server FastAPI. Cho production, triển khai container Docker sau API gateway với rate limiting và xác minh ngườii nói.

## Kết luận

VoiceCraft lấp đầy khoảng trống mà hầu hết công cụ TTS bỏ qua: chỉnh sửa giọng nói hiện có, không chỉ tổng hợp giọng mới. 8.500 stars GitHub và việc được ACL 2024 chấp nhận phản ánh giá trị kỹ thuật thực sự — đặc biệt là thủ tục token rearrangement cho phép ngữ cảnh hai chiều trong tạo sinh tự hồi quy. Các benchmark rõ ràng: VoiceCraft dẫn đầu về độ tương đồng giọng nói (MOS 4,34) và tạo ra âm thanh chỉnh sửa mà ngườii nghe thích hơn bản ghi gốc 48% thờii gian.

Cho lập trình viên xây dựng công cụ chỉnh sửa podcast, sách nói hoặc dịch vụ nhân bản giọng, VoiceCraft xứng đáng với công sức thiết lập. Bắt đầu với Docker quickstart, thử nghiệm trên Gradio UI, sau đó tích hợp qua Python API.

Tham gia [nhóm Telegram](https://t.me/dibi8opensource) của chúng tôi để thảo luận các mẫu triển khai VoiceCraft, chia sẻ cấu hình fine-tune và nhận trợ giúp cho môi trường production.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [VoiceCraft GitHub Repository](https://github.com/jasonppy/VoiceCraft)
- [VoiceCraft Paper — ACL 2024](https://aclanthology.org/2024.acl-long.673/)
- [VoiceCraft arXiv (v3)](https://arxiv.org/abs/2403.16973)
- [VoiceCraft Demo Page](https://jasonppy.github.io/VoiceCraft_web/)
- [VoiceCraft-X: Mở rộng đa ngôn ngữ](https://arxiv.org/abs/2511.12347)
- [HuggingFace Model Weights](https://huggingface.co/pyp1/VoiceCraft)
- [GPT-SoVITS Repository](https://github.com/RVC-Boss/GPT-SoVITS)
- [Coqui TTS / XTTS v2](https://github.com/coqui-ai/TTS)
- [EnCodec — Neural Codec của Meta](https://github.com/facebookresearch/audiocraft)
- [Thông tin bộ dữ liệu RealEdit](https://github.com/jasonppy/VoiceCraft/blob/master/RealEdit.txt)
- [Hướng dẫn thiết lập Docker VoiceCraft](https://github.com/jasonppy/VoiceCraft#quickstart-docker)
- [VoiceCraft_API — FastAPI Wrapper](https://github.com/GPU-Net/VoiceCraft_API)

*Hướng dẫn này được nhóm kỹ thuật dibi8 viết độc lập. VoiceCraft được phát triển bởi Puyuan Peng, Po-Yao Huang, Shang-Wen Li, Abdelrahman Mohamed và David Harwath. Không có mối quan hệ thương mại nào giữa dibi8 và dự án VoiceCraft.*
