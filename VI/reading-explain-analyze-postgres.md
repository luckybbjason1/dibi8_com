---
title: Đọc đầu ra EXPLAIN ANALYZE trong Postgres mà không bị lạc
description: PostgreSQL EXPLAIN ANALYZE tutorial. Learn query plan interpretation,
  bottleneck detection, and database performance optimization.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- AI
application_domain: Ai Tools
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: ''
last_maintained: '2026-05-15'
featureImage: ''
draft: false
aliases:
- /vi/posts/reading-explain-analyze-postgres/
faqs:
  - q: 'Dòng đầu tiên trong output EXPLAIN ANALYZE, actual time có nghĩa là gì?'
    a: 'Giá trị actual time thứ hai của node ngoài cùng là thời gian thực tế (tính bằng mili giây) mà toàn bộ truy vấn tiêu tốn cho một lần thực thi node đó. Tất cả các node bên dưới phân tích chi tiết thời gian tổng đó đã được sử dụng ở đâu.'
  - q: 'Làm thế nào để phát hiện query plan có vấn đề qua số lượng hàng trong EXPLAIN ANALYZE?'
    a: 'So sánh rows= ước tính của planner (trong phần cost=) với rows= thực tế (trong phần actual time=). Khi hai giá trị này chênh lệch 10 lần trở lên, planner đã dùng thống kê lỗi thời, và mọi node phía trên đều được chọn dựa trên giả định sai — đây gần như chắc chắn là lỗi cần tìm.'
  - q: 'Làm thế nào để tính thời gian chỉ của riêng một node trong EXPLAIN ANALYZE?'
    a: 'Với các node có loops=1, thời gian tự thân xấp xỉ bằng thời gian hàng cuối của node đó (B) trừ đi tổng thời gian hàng cuối của các node con. Với node có loops=N lớn, thời gian được báo cáo là thời gian mỗi vòng lặp, vì vậy cần nhân với loops để ra tổng thời gian.'
  - q: 'Sự khác biệt giữa shared hit và shared read trong EXPLAIN (ANALYZE, BUFFERS) là gì?'
    a: 'shared hit đếm các trang đã có sẵn trong buffer cache của Postgres, chi phí thấp; còn shared read đếm các trang phải lấy từ OS hoặc đĩa, chi phí cao. Nếu read chiếm ưu thế, dữ liệu đơn giản là chưa được cache — hãy chạy truy vấn hai lần, vì lần chạy thứ hai phản ánh trạng thái ổn định hơn.'
  - q: 'temp written xuất hiện trên node Sort hoặc Hash trong query plan có nghĩa là gì?'
    a: 'Điều đó có nghĩa là thao tác sắp xếp hoặc băm không vừa trong work_mem và đã tràn ra đĩa, khiến thời gian của node đó có thể tăng gấp 10 lần. Cách khắc phục là tăng work_mem cho phiên đó và chạy lại EXPLAIN.'
---

{</* resource-info */>}

Đầu ra EXPLAIN ANALYZE trông đáng sợ cho đến khi bạn biết ba con số thực sự quan trọng. Đây là thứ tự tôi đọc chúng, và các mẫu chỉ ra các lỗi cụ thể.

## Ba con số thực sự quan trọng

### 1. **Tổng thời gian thực thi (Total Execution Time)**
```
Total runtime: 1234.567 ms
```
Đây là chỉ số quan trọng nhất. Nếu truy vấn chậm, nó sẽ cho bạn biết ở đây.

### 2. **Số hàng thực tế vs số hàng ước tính (Actual vs Estimated Rows)**
```
Seq Scan on users  (cost=0.00..123.45 rows=1000 width=32) (actual time=1.234..567.890 rows=50000 loops=1)
```
Sự khác biệt lớn cho thấy trình lập kế hoạch đã đưa ra giả định sai.

### 3. **Tỷ lệ trúng bộ đệm (Buffer Hit Ratio)**
```
Buffers: shared hit=1000 read=50
```
Tỷ lệ trúng cao = sử dụng bộ đệm tốt, tỷ lệ trúng thấp = vấn đề I/O đĩa.

## Thứ tự đọc

1. **Bắt đầu từ dưới** - tổng thời gian thực thi
2. **Làm việc lên trên** - tìm nút có chi phí cao nhất
3. **Kiểm tra ước tính hàng** - thực tế vs ước tính
4. **Xem thống kê bộ đệm** - mẫu I/O

## Mẫu vấn đề phổ biến

### **Quét tuần tự khi nên quét chỉ mục**
```
Seq Scan on large_table (cost=1000.00..2000.00 rows=100000 width=32)
```
**Giải pháp**: Thêm chỉ mục phù hợp

### **Vòng lồng khi nên kết nối băm**
```
Nested Loop (cost=1000.00..100000.00 rows=1000 width=64)
  -> Seq Scan on users
  -> Index Scan on orders
```
**Giải pháp**: Tăng work_mem hoặc viết lại truy vấn

### **Quá nhiều bộ đệm không trúng**
```
Buffers: shared hit=10 read=1000
```
**Giải pháp**: Tăng shared_buffers hoặc cải thiện truy vấn

### **Sắp xếp tràn ra đĩa**
```
Sort Method: external merge  Disk: 16384kB
```
**Giải pháp**: Tăng work_mem

## Ứng dụng thực tế

Những hiểu biết này giúp tôi xác định và sửa chữa:
- Chỉ mục bị thiếu
- Thứ tự kết nối không hiệu quả
- Vấn đề thiếu bộ nhớ
- Bộ đệm không trúng

Hãy nhớ: EXPLAIN ANALYZE là trình gỡ lỗi hiệu suất truy vấn của bạn. Học cách đọc nó sẽ tiết kiệm cho bạn vô số giờ đoán mò.

---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Proxy Anthropic Claude / OpenAI / DeepSeek API. Hầu hết AI tool ở trên (chatbot, code gen, translation, search, v.v.) cần LLM API key — proxy này cho access ổn định top model với ~30% giá chính thức.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

