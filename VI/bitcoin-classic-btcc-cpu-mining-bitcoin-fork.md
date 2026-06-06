---
title: "Bitcoin-Classic (BTCC): Bản Sao Bitcoin Cho Phép Ngườithường Đào Bằng CPU"
description: "Bitcoin-Classic (BTCC) là đồng tiền số phi tập trung được xây dựng lại từ Bitcoin Core v28.1. Hỗ trợ đào bằng CPU với giao diện đồ họa tích hợp, giúp ngườithường trải nghiệm đào coin thờikỳ đầu của Bitcoin."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - C++
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "14.8 MB"
file_md5: ""
download_url: "https://github.com/Marcus-Vane/Bitcoin-Classic"
backup_url: ""
github_repo: "https://github.com/Marcus-Vane/Bitcoin-Classic"
stars: 23
maintainer: "Marcus-Vane"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /vi/posts/bitcoin-classic-btcc-cpu-mining-bitcoin-fork/
faqs:
  - q: 'Bạn có thể đào Bitcoin-Classic (BTCC) bằng CPU thông thường không?'
    a: 'Có. BTCC được thiết kế để CPU của máy tính gia đình thông thường cũng có thể tham gia đào, không cần thiết bị ASIC hay GPU chuyên dụng. Do hashrate mạng lưới rất thấp, CPU thông thường hoàn toàn có thể kiếm được phần thưởng khối.'
  - q: 'Tổng cung và phần thưởng khối của Bitcoin-Classic (BTCC) là bao nhiêu?'
    a: 'BTCC có tổng cung 21,000,000 coin, giống hệt Bitcoin. Phần thưởng khối ban đầu là 50 BTCC, giảm một nửa sau mỗi 210,000 khối (khoảng 4 năm), với thời gian tạo khối là 10 phút.'
  - q: 'Bitcoin-Classic được xây dựng trên nền tảng nào và sử dụng cơ chế đồng thuận gì?'
    a: 'Bitcoin-Classic được xây dựng lại từ Bitcoin Core v28.1 và viết bằng C++. Nó sử dụng cơ chế đồng thuận SHA-256 Proof-of-Work với quy tắc chuỗi dài nhất, hoàn toàn phi tập trung và không có premine.'
  - q: 'Làm thế nào để bắt đầu đào Bitcoin-Classic?'
    a: 'Tải Bitcoin-Classic-Setup.exe từ trang GitHub releases, cài đặt, chờ blockchain đồng bộ hóa lần đầu, tạo ví mới, rồi nhấn «Start Mining» bằng trình đào đồ họa tích hợp. Không cần dùng dòng lệnh.'
  - q: 'Bitcoin-Classic (BTCC) có phải là khoản đầu tư tốt không?'
    a: 'Không. BTCC hiện có vốn hóa thị trường và thanh khoản gần như bằng không, không được hỗ trợ bởi các sàn giao dịch lớn, và cộng đồng rất nhỏ (chỉ khoảng 18-23 GitHub stars). Dự án này phù hợp nhất cho mục đích học tập và thử nghiệm, không nên coi là khoản đầu tư.'
---
{</* resource-info */>}

## Bitcoin-Classic Là Gì?

**Bitcoin-Classic (BTCC)** là đồng tiền số phi tập trung được xây dựng lại từ **Bitcoin Core v28.1**. Đặc điểm nổi bật nhất là **hạ thấp rào cản đào coin** — bạn không cần máy đào ASIC đắt tiền hay thậm chí card đồ họa riêng. **CPU của máy tính gia đình thông thường cũng có thể tham gia đào**.

**GitHub**: https://github.com/Marcus-Vane/Bitcoin-Classic
**Stars**: 18
**Ngôn ngữ**: C++
**Giấy phép**: MIT
**Trình khám phá**: https://explorer.bitcoin-classic.net/

---

## Tầm Nhìn: Ai Cũng Có Thể Đào

> "Ngàynay hầu hết mọi ngườitrên thế giới đều nghe qua Bitcoin, nhưng rất ít ngườithực sự sở hữu Bitcoin thông qua đào coin."

Ý tưởng cốt lõi của Bitcoin-Classic là **khôi phục trải nghiệm đào coin thờikỳ đầu của Bitcoin**. Năm 2009-2010, bất kỳ ai có máy tính gia đình đều có thể đào Bitcoin. Nhưng với sự xuất hiện của máy đào ASIC và các trại đào công nghiệp, đào cá nhân đã không còn sinh lợi.

BTCC cố gắng mang lại trải nghiệm đó thông qua **độ khó thấp, đào thân thiện với CPU và giao diện đồ họa**.

---

## Thông Số Kỹ Thuật Cốt Lõi

### Cơ Chế Đồng Thuận

| Thông số | Mô tả |
|----------|-------|
| **Thuật toán đồng thuận** | SHA-256 Proof-of-Work (PoW) |
| **Phương thức đào** | CPU / GPU (thân thiện với độ khó thấp) |
| **Mô hình bảo mật** | Quy tắc chuỗi dài nhất |
| **Phi tập trung** | Hoàn toàn phi tập trung, không pre-mine |

### Khối & Mô Hình Kinh Tế

| Thông số | Giá trị |
|----------|---------|
| **Tổng cung** | 21.000.000 BTCC |
| **Thờigian khối** | 10 phút / khối |
| **Điều chỉnh độ khó** | 2.016 khối (khoảng 14 ngày) |
| **Phần thưởng khối ban đầu** | 50 BTCC / khối |
| **Đơn vị nhỏ nhất** | 0,00000001 BTCC |
| **Chu kỳ giảm một nửa** | 210.000 khối (khoảng 4 năm) |

### Lịch Giảm Một Nửa

| Chiều cao khối | Phần thưởng |
|----------------|-------------|
| 0 ~ 209.999 | 50 BTCC |
| 210.000 ~ 419.999 | 25 BTCC |
| 420.000 ~ 629.999 | 12,5 BTCC |

---

## Tính Năng Cốt Lõi

### 1. Phần Mềm Đào Đồ Họa Tích Hợp
Không cần dòng lệnh. Tải gói cài đặt về, chạy, nhấp "Bắt đầu đào" là xong.

### 2. Thân Thiện Với CPU
Do tổng sức mạnh tính toán mạng thấp, CPU thông thường cũng có thể tham gia đào hiệu quả và nhận thưởng khối thực sự.

### 3. Ví Nhẹ
Tích hợp chức năng ví, tạo ví tự động bắt đầu đào, hiển thị số dư theo thờigian thực.

### 4. Trình Khám Phá Blockchain
https://explorer.bitcoin-classic.net/ — tra cứu khối, giao dịch, số dư địa chỉ.

---

## Bắt Đầu Nhanh

```
1. Tải Bitcoin-Classic-Setup.exe
   → https://github.com/Marcus-Vane/Bitcoin-Classic/releases

2. Cài đặt vào ổ D hoặc E (khuyến nghị không cài ổ hệ thống)

3. Lần đầu chạy, chờ đồng bộ blockchain hoàn tất

4. Nhấp "Create a new wallet" tạo ví

5. Nhấp "Start Mining" bắt đầu đào

6. Sau khi đào, ví đào tự động tạo, chuyển sang góc trên bên phải để xem số dư
```

---

## Lưu Ý Bảo Mật

⚠️ **Luôn sao lưu tệp ví của bạn (xxx.dat)**
- Tệp .dat = khóa riêng của bạn
- Không bao giờ để lộ trực tuyến
- Không bao giờ gửi cho bất kỳ ai
- Đây là bằng chứng duy nhất về quyền sở hữu tài sản ví

---

## So Sánh Với Bitcoin

| Chiều | Bitcoin (BTC) | Bitcoin-Classic (BTCC) |
|-------|--------------|------------------------|
| Ra mắt | 2009 | 2026 |
| Đồng thuận | SHA-256 PoW | SHA-256 PoW |
| Tổng cung | 21 triệu | 21 triệu |
| Phần thưởng ban đầu | 50 BTC | 50 BTCC |
| Rào cản đào | ASIC + điện rẻ | CPU gia đình |
| Sức mạnh tính toán | Cực cao (EH/s) | Rất thấp (CPU có thể đào) |
| Hệ sinh thái | Trưởng thành (sàn, DeFi) | Sơ khai (ví + trình khám phá) |
| Giá trị đầu tư | Thanh khoản cao | Thử nghiệm |

---

## Tóm Tắt

Bitcoin-Classic là một dự án mang tính **giáo dục và trải nghiệm** rất cao. Ngườidùng không có nền tảng kỹ thuật cũng có thể "đào được một khối" và cảm nhận được thành tựu.

Tuy nhiên nó cũng đối mặt với thách thức thực tế:
- Chỉ 18 GitHub Stars (cộng đồng cực kỳ nhỏ)
- Không có hỗ trợ từ sàn giao dịch lớn
- Tính bền vững dài hạn chưa chắc chắn

**Phù hợp với**:
- Ngườiyêu thích công nghệ muốn tìm hiểu nền tảng blockchain
- Ngườimuốn trải nghiệm không khí đào Bitcoin thờikỳ đầu
- Sinh viên nghiên cứu tiền mã hóa và cơ chế đồng thuận PoW

> ⚠️ BTCC hiện có vốn hóa và thanh khoản gần như bằng không. Không nên đầu tư số tiền lớn hoặc sức mạnh tính toán đáng kể.

> 💡 Muốn biết thêm công cụ blockchain và tiền mã hóa? Theo dõi [dibi8.com](https://dibi8.com) để nhận các dự án mã nguồn mở được chọn lọc hàng tuần.

---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Proxy Anthropic Claude / OpenAI / DeepSeek API. Hầu hết AI tool ở trên (chatbot, code gen, translation, search, v.v.) cần LLM API key — proxy này cho access ổn định top model với ~30% giá chính thức.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

