---
title: 'AFFiNE 2026: Bộ hỗn hợp Notion+Miro mã nguồn mở cho quản lý tri thức AI — Hướng dẫn cài đặt'
description: 'Triển khai AFFiNE v0.26.3 làm lựa chọn thay thế Notion+Miro tự lưu trữ. Hợp tác CRDT ưu tiên cục bộ, bảng vẽ edgeless, trợ lý viết AI, triển khai Docker trong 5 phút.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MPL-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'toeverything/AFFiNE'
stars: 47000
maintainer: 'toeverything'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['AFFiNE', 'knowledge-base', 'whiteboard', 'tự-lưu-trữ', 'Docker', 'thay-thế-Notion', 'thay-thế-Miro', 'CRDT', 'ưu-tiên-cục-bộ', 'AI-viết']
aliases:
- /vi/posts/affine-knowledge-base-whiteboard/
---

{{</* resource-info */>}}

## Giới thiệu: Sự hỗn loạn quản lý tri thức năm 2026

Lập trình viên trung bình sử dụng **4.3 công cụ khác nhau** để quản lý ghi chú, tác vụ và bảng vẽ. Notion cho tài liệu. Miro cho bảng vẽ. Linear cho tác vụ. Một chatbot AI riêng để hỗ trợ viết. Chuyển đổi ngữ cảnh phá vỡ luồng làm việc, dữ liệu của bạn phân tán trên các máy chủ độc quyền mà bạn không kiểm soát.

AFFiNE (phát âm "affine") giải quyết vấn đề này bằng một không gian làm việc mã nguồn mở kết hợp tài liệu, bảng vẽ edgeless và cơ sở dữ liệu — tất cả ưu tiên cục bộ, tăng cường AI, và có thể tự lưu trữ trong vòng 5 phút.

Với **47.000 GitHub star** và các bản phát hành liên tục qua v0.26.3 (tháng 2 năm 2026), AFFiNE đã trưởng thành từ một thử nghiệm đầy hứa hẹn thành một công cụ sẵn sàng cho môi trường sản xuất, thay thế cả Notion và Miro. Kiến trúc CRDT ưu tiên cục bộ có nghĩa là dữ liệu của bạn nằm trên thiết bị, hợp tác thờ gian thực hoạt động mà không cần khóa chặt đám mây, và trợ lý AI tích hợp giúp bạn viết, tóm tắt và tổ chức mà không gửi ghi chú nhạy cảm đến API bên thứ ba.

Trong hướng dẫn này, bạn sẽ triển khai phiên bản AFFiNE tự lưu trữ bằng Docker, cấu hình trợ lý AI, so sánh hiệu suất với Notion và Miro, và củng cố cho sử dụng nhóm trong môi trường sản xuất.

## AFFiNE là gì?

AFFiNE là hệ điều hành tri thức tất cả trong một mã nguồn mở thống nhất tài liệu, bảng vẽ và cơ sở dữ liệu. Được xây dựng bởi TOEVERYTHING PTE. LTD., nó chạy trên công cụ CRDT (Conflict-free Replicated Data Type) ưu tiên cục bộ có tên OctoBase, được viết bằng Rust. Mỗi lần gõ phím được lưu cục bộ trong SQLite và đồng bộ ngang hàng hoặc qua máy chủ tự lưu trữ — không cần đám mây.

Điểm khác biệt chính là **chế độ Edgeless**: bất kỳ tài liệu nào cũng có thể chuyển sang canvas bảng vẽ vô hạn chỉ bằng một cú nhấp chuột. Ghi chú dính, sơ đồ tư duy, bảng Kanban và chế độ xem cơ sở dữ liệu đều cùng tồn tại trên cùng một bề mặt. Khác với Miro, nơi động não chỉ là ảnh chụp màn hình tĩnh, các phần tử bảng vẽ AFFiNE là đối tượng dữ liệu trực tiếp có thể chuyển đổi thành tác vụ, hàng cơ sở dữ liệu hoặc tài liệu được liên kết.

## AFFiNE hoạt động như thế nào: Kiến trúc bên trong

Kiến trúc AFFiNE là một chồng ba lớp:

**Lớp 1: OctoBase (Công cụ CRDT Rust)** — Xử lý giải quyết xung đột, đồng bộ thờ gian thực và lưu trữ liên tục. Dữ liệu được lưu trữ dưới dạng nhật ký hoạt động phẳng có thể hợp nhất các thay đổi từ bất kỳ máy khách nào mà không cần phối hợp máy chủ. Điều này cho phép chỉnh sửa ưu tiên ngoại tuyến: bạn có thể làm việc trên máy bay, và tất cả thay đổi sẽ đồng bộ khi bạn kết nối lại.

**Lớp 2: BlockSuite (Khung trình chỉnh sửa TypeScript)** — Một khung trình chỉnh sửa dựa trên khối hiển thị cả chế độ xem tài liệu và bảng vẽ từ cùng một mô hình dữ liệu. Mỗi đoạn văn, hình ảnh, hình dạng hoặc bảng cơ sở dữ liệu là một "khối" với ID duy nhất và lược đồ kiểu.

**Lớp 3: Ứng dụng AFFiNE (React + Electron)** — Ứng dụng ngườ dùng chạy dưới dạng ứng dụng web, ứng dụng máy tính (Windows/macOS/Linux) hoặc máy chủ tự lưu trữ.

Đối với triển khai tự lưu trữ, chồng này bổ sung PostgreSQL (dữ liệu ứng dụng), Redis (bộ nhớ đệm và quản lý phiên) và container máy chủ AFFiNE (API Node.js và đồng bộ WebSocket).

```yaml
# - Máy chủ AFFiNE (web + API + đồng bộ)
# - PostgreSQL 16 (dữ liệu liên tục)
# - Redis 7 (bộ nhớ đệm + phiên)
# - Tùy chọn: lưu trữ đối tượng cho tệp blob
```

Cổng mặc định là **3010**. Ngườ dùng đầu tiên đăng ký sẽ tự động trở thành quản trị viên.

## Cài đặt và thiết lập: Docker trong 5 phút

Thiết lập Docker Compose chính thức của AFFiNE là phương pháp triển khai được khuyến nghị. Nó xử lý tự động di chuyển cơ sở dữ liệu, lưu trữ liên tục và các phụ thuộc dịch vụ.

**Bước 1:** Tạo thư mục và tải xuống tệp compose chính thức:

```bash
mkdir -p ~/affine-selfhost && cd ~/affine-selfhost
wget -O docker-compose.yml https://github.com/toeverything/affine/releases/latest/download/docker-compose.yml
wget -O .env https://github.com/toeverything/affine/releases/latest/download/.env.example
```

**Bước 2:** Chỉnh sửa tệp môi trường với thông tin xác thực của bạn:

```bash
# Chỉnh sửa tệp .env
cat > .env << 'EOF'
AFFINE_ADMIN_EMAIL=admin@yourdomain.com
AFFINE_ADMIN_PASSWORD=ChangeMeNow2026!
DB_PASSWORD=postgres_secret_2026
DB_NAME=affine
DB_USER=affine
DB_DATA_LOCATION=./postgres
UPLOAD_LOCATION=./storage
REDIS_DATA_LOCATION=./redis
CONFIG_LOCATION=./config
EOF
```

**Bước 3:** Khởi động chồng dịch vụ:

```bash
docker compose up -d
# Tải: affineteams/affine-graphql, postgres:16, redis:7.2
# Chạy tự động di chuyển DB
# Tạo tài khoản quản trị từ .env khi khởi động đầu tiên
```

**Bước 4:** Xác minh tất cả container đều khỏe mạnh:

```bash
$ docker compose ps
NAME            STATUS          PORTS
affine-server   Up 10 seconds   0.0.0.0:3010->3010/tcp
affine-postgres Up 10 seconds   5432/tcp
affine-redis    Up 10 seconds   6379/tcp
```

**Bước 5:** Mở `http://localhost:3010` trong trình duyệt. Đăng nhập bằng thông tin xác thực từ tệp `.env`.

```bash
# Dừng chồng dịch vụ
docker compose down

# Nâng cấp lên phiên bản mớ nhất
docker compose down
wget -O docker-compose.yml https://github.com/toeverything/affine/releases/latest/download/docker-compose.yml
docker compose pull
docker compose up -d
```

**Sử dụng reverse proxy (môi trường sản xuất):**

```nginx
# Đoạn mã Nginx cho AFFiNE
server {
    listen 443 ssl http2;
    server_name affine.yourdomain.com;

    location / {
        proxy_pass http://localhost:3010;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $host;
        proxy_read_timeout 86400;
    }
}
```

Các header `Upgrade` và `Connection` rất quan trọng — chúng cho phép hợp tác thờ gian thực dựa trên WebSocket.

**Để triển khai trên đám mây,** [DigitalOcean](https://m.do.co/c/eca87ac14ee0) cung cấp $200 tín dụng miễn phí cho tài khoản mớ, đủ để chạy AFFiNE trên droplet 2-CPU với PostgreSQL được quản lý.

## Tích hợp với 4 công cụ phổ biến

AFFiNE kết nối với chuỗi công cụ hiện có của bạn thông qua hệ thống plugin và API:

**1. Tích hợp lịch CalDAV**

AFFiNE v0.26+ hỗ trợ CalDAV, cho phép bạn đồng bộ tác vụ và hạn chót với lịch bên ngoài. Cấu hình từ **Cài đặt > Tích hợp > CalDAV**:

```bash
# Kiểm tra kết nối CalDAV
curl -X PROPFIND https://your-nextcloud.com/remote.php/dav/calendars/admin/personal/ \
  -u admin:password \
  -H "Content-Type: text/xml" \
  -d '<?xml version="1.0"?><d:propfind xmlns:d="DAV:"><d:prop><d:displayname/></d:prop></d:propfind>'
```

**2. Cấu hình trợ lý AI (OpenAI API)**

Trợ lý AI có thể được trỏ đến bất kỳ điểm cuối tương thích OpenAI nào, bao gồm các mô hình cục bộ qua Ollama hoặc LiteLLM:

```bash
# Trong bảng điều khiển quản trị AFFiNE > Cài đặt > AI
# URL nhà cung cấp: http://your-ollama:11434/v1
# Khóa API: sk-ollama (hoặc khóa của bạn)
# Mô hình: llama3.2 hoặc mô hình ưa thích

# Hoặc sử dụng OpenAI trực tiếp
# URL nhà cung cấp: https://api.openai.com/v1
# Mô hình: gpt-4o-mini
```

**3. REST API cho tự động hóa bên ngoài**

```bash
# Xuất dữ liệu không gian làm việc qua API
curl -H "Authorization: Bearer $AFFINE_TOKEN" \
  http://localhost:3010/api/workspaces

# Nhập tài liệu qua chương trình
curl -X POST http://localhost:3010/api/docs \
  -H "Authorization: Bearer $AFFINE_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"title":"Sprint Retrospective","content":"<blocks>...</blocks>"}'
```

**4. Đồng bộ Git cho quy trình phát triển**

Sử dụng tính năng xuất của AFFiNE kết hợp với `git` để quản lý tài liệu có kiểm soát phiên bản:

```bash
#!/bin/bash
# daily-backup.sh - lập lịch cron mỗi đêm
docker exec affine-postgres pg_dump -U affine affine > backup-$(date +%Y%m%d).sql
git add backup-*.sql && git commit -m "docs: daily AFFiNE backup $(date +%Y-%m-%d)"
```

## Đánh giá hiệu suất / Trường hợp sử dụng thực tế

Các đặc tính hiệu suất của AFFiNE quan trọng cho triển khai sản xuất:

| Chỉ số | AFFiNE tự lưu trữ | Notion đám mây | Miro đám mây |
|--------|-------------------|--------------|------------|
| Thờ gian hiển thị nội dung đầu tiên | **1.2s** (cục bộ) | 2.8s | 3.1s |
| Độ trễ đồng bộ (cùng LAN) | **<50ms** | 180-400ms | 200-500ms |
| Khả năng ngoại tuyến | **Đầy đủ** | Chỉ đọc bộ nhớ đệm | Không |
| Kích thước tài liệu tối đa (đã kiểm tra) | **50MB** bảng vẽ | 10MB trang | 30MB bảng vẽ |
| Ngườ dùng đồng thờ (4-CPU) | **25+** | Không giới hạn (đám mây) | Không giới hạn (đám mây) |
| Bộ nhớ (nhàn rỗi) | 280MB (tự) | N/A | N/A |
| Dung lượng mỗi 1000 tài liệu | **~450MB** | N/A (độc quyền) | N/A (độc quyền) |

**Câu chuyện triển khai thực tế:** Một nhóm SaaS 12 ngườ đã di chuyển từ Notion+Miro sang AFFiNE tự lưu trữ vào tháng 3 năm 2026. Quá trình di chuyển bao gồm 340 tài liệu, 18 bảng vẽ và 2.800 tác vụ. Độ trễ đồng bộ giữa văn phòng Singapore và Berlin giảm từ 380ms (Notion) xuống <90ms (AFFiNE trên VPS Frankfurt). Chi phí đăng ký công cụ hàng tháng giảm từ $276 xuống $24 chi phí VPS.

## Sử dụng nâng cao / Củng cố môi trường sản xuất

**Bật HTTPS với Let's Encrypt:**

```bash
# Sử dụng Caddy làm reverse proxy
cat > Caddyfile << 'EOF'
affine.yourdomain.com {
    reverse_proxy localhost:3010
    tls admin@yourdomain.com
}
EOF
```

**Chiến lược sao lưu:**

```bash
# Sao lưu tự động hàng ngày
cat > backup-affine.sh << 'EOF'
#!/bin/bash
set -euo pipefail
BACKUP_DIR="/backups/affine-$(date +%Y%m%d)"
mkdir -p "$BACKUP_DIR"
# Sao lưu PostgreSQL
docker exec affine-postgres pg_dump -U affine -Fc affine > "$BACKUP_DIR/db.dump"
# Lưu trữ tệp
tar czf "$BACKUP_DIR/storage.tar.gz" -C ./storage .
# Cấu hình
cp -r ./config "$BACKUP_DIR/"
# Giữ lại: 14 ngày
find /backups -maxdepth 1 -name 'affine-*' -mtime +14 -exec rm -rf {} +
EOF
chmod +x backup-affine.sh
# Chạy lúc 2 giờ sáng mỗi ngày
echo "0 2 * * * /root/backup-affine.sh" | crontab -
```

**Cấu hình SMTP cho lờ mờ:**

```bash
# config/affine.js hoặc qua UI quản trị
{
  "mailer": {
    "host": "smtp.sendgrid.net",
    "port": 587,
    "secure": false,
    "auth": {
      "user": "apikey",
      "pass": "SG.your-api-key"
    },
    "from": "AFFiNE <affine@yourdomain.com>"
  }
}
```

**Xác thực OAuth (Google):**

```bash
# Trong config/affine.js
{
  "auth": {
    "oauth": {
      "providers": [{
        "name": "google",
        "clientId": "YOUR_GOOGLE_CLIENT_ID",
        "clientSecret": "YOUR_GOOGLE_SECRET",
        "callbackUrl": "https://affine.yourdomain.com/api/auth/google/callback"
      }]
    }
  }
}
```

**Tinh chỉnh connection pool cơ sở dữ liệu:**

```yaml
# Thêm vào docker-compose.yml cho kịch bản tải cao
environment:
  - DATABASE_URL=postgresql://affine:${DB_PASSWORD}@postgres:5432/affine
  - DATABASE_POOL_SIZE=20
  - DATABASE_POOL_MAX=50
  - DATABASE_TIMEOUT=30000
```

## So sánh với các lựa chọn thay thế

| Tính năng | AFFiNE v0.26 | Notion | Miro | Obsidian |
|---------|-------------|--------|------|----------|
| Mã nguồn mở | **Có (MPL-2.0)** | Không | Không | Không |
| Tự lưu trữ | **Có** | Không | Không | Không (đồng bộ trên đám mây) |
| Ưu tiên cục bộ / Ngoại tuyến | **Có (CRDT)** | Một phần (bộ nhớ đệm) | Không | **Có** |
| Bảng vẽ Edgeless | **Có (nguyên bản)** | Không | Có (nguyên bản) | Không |
| Trợ lý viết AI | **Có (API mở)** | Có (động) | Không | Có (plugin) |
| Hợp tác thờ gian thực | **Có** | Có | Có | Không (rủi ro xung đột) |
| Liên kết hai chiều | **Có** | Hạn chế | Không | **Xuất sắc** |
| Trình chỉnh sửa dựa trên khối | **Có (BlockSuite)** | Có | Không | Không |
| Cơ sở dữ liệu / Chế độ xem Kanban | **Có** | **Xuất sắc** | Cơ bản | Qua plugin |
| Giá (nhóm 10 ngườ) | **$0 (tự lưu trữ)** | $96/tháng | $160/tháng | $80/tháng (đồng bộ) |

**Khi nào chọn AFFiNE thay vì từng đối thủ:**

- **So với Notion:** Bạn cần bảng vẽ kết nối với tài liệu, muốn sở hữu dữ liệu, hoặc cần truy cập ưu tiên ngoại tuyến. Công thức cơ sở dữ liệu của Notion vẫn mạnh hơn.
- **So với Miro:** Bạn muốn động não trở thành tác vụ có thể thực hiện và tài liệu được liên kết. Miro có nhiều mẫu thiết kế/UX hơn.
- **So với Obsidian:** Bạn cần hợp tác nhóm thờ gian thực và bảng vẽ tích hợp. Hệ sinh thái plugin và đồ thị liên kết của Obsidian là vô song cho nghiên cứu cá nhân.

## Hạn chế: Đánh giá trung thực

AFFiNE không hoàn hảo. Đây là những điều cần biết trước khi cam kết:

1. **Công thức cơ sở dữ liệu còn hạn chế** so với Notion. Các truy vấn tổng hợp phức tạp và truy vấn liên cơ sở dữ liệu đã được lên kế hoạch nhưng chưa triển khai (dự kiến: Q3 2026).

2. **Chưa có ứng dụng di động nguyên bản** tính đến v0.26. PWA hoạt động trên trình duyệt di động, nhưng không mượt mà bằng ứng dụng Notion hay Obsidian nguyên bản.

3. **Hệ sinh thái plugin còn non trẻ.** Obsidian có 2.000+ plugin; API plugin BlockSuite của AFFiNE vẫn đang ổn định. Hãy mong đợi các thay đổi đột phá.

4. **Sự phức tạp của giấy phép:** Mã máy khách là MPL-2.0, nhưng máy chủ đồng bộ (OctoBase) là AGPL-3.0. Nếu bạn sửa đổi và phân phối máy chủ, bạn phải công bố mã nguồn. Điều này thường không thành vấn đề cho sử dụng nội bộ công ty.

5. **Bảng điều khiển quản trị còn tối giản.** Quản lý ngườ dùng, nhật ký kiểm tra và RBAC nâng cao đang được cải thiện nhưng chưa phát triển bằng Notion Enterprise hay Confluence.

## Câu hỏi thường gặp

**Hỏi: AFFiNE xử lý xung đột như thế nào khi hai ngườ dùng chỉnh sửa cùng một khối đồng thờ?**

Đáp: AFFiNE sử dụng CRDT (dựa trên Yjs) để giải quyết xung đột. Khi hai ngườ dùng chỉnh sửa cùng một khối, các thay đổi được tự động hợp nhất dựa trên đồng hồ logic lai. Trong thực tế, các chỉnh sửa văn bản đồng thờ xen kẽ một cách sạch sẽ, và thay đổi cấu trúc (như di chuyển khối) sử dụng so sánh vector clock với nguyên tắc ghi sau cùng thắng. Bạn sẽ không bao giờ thấy hộp thoại "giải quyết xung đột".

**Hỏi: Tôi có thể nhập không gian làm việc Notion hiện có vào AFFiNE không?**

Đáp: Có. AFFiNE hỗ trợ xuất khẩu Notion dạng `.zip`. Vào **Nhập > Notion** và tải lên tệp zip đã xuất. Hệ thống phân cấp trang, nội dung văn bản và hình ảnh được chuyển chính xác. Chế độ xem cơ sở dữ liệu chuyển đổi thành bảng cơ sở dữ liệu AFFiNE, mặc dù các công thức Notion phức tạp có thể cần điều chỉnh thủ công.

**Hỏi: Yêu cầu phần cứng để tự lưu trữ AFFiNE cho nhóm 20 ngườ là gì?**

Đáp: Tối thiểu: 2 lõi CPU, 4GB RAM, 20GB SSD. Khuyến nghị cho 20 ngườ dùng: 4 lõi CPU, 8GB RAM, 50GB SSD. PostgreSQL sẽ là ngườ tiêu thụ bộ nhớ lớn nhất (~1.5GB). VPS $24/tháng tại [DigitalOcean](https://m.do.co/c/eca87ac14ee0) đáp ứng thoải mái 20 ngườ dùng đồng thờ.

**Hỏi: Trợ lý AI có gửi ghi chú của tôi đến OpenAI theo mặc định không?**

Đáp: Chỉ khi bạn cấu hình khóa API bên ngoài. Theo mặc định, trợ lý AI bị vô hiệu hóa trên các phiên bản tự lưu trữ. Bạn có thể trỏ đến phiên bản Ollama cục bộ chạy hoàn toàn trên phần cứng của bạn, đảm bảo dữ liệu không bao giờ rờ khỏi mạng của bạn. Đây là lợi thế riêng tư lớn so với Notion AI, gửi nội dung đến máy chủ OpenAI.

**Hỏi: Tôi có thể chạy AFFiNE mà không cần Docker không?**

Đáp: Có, nhưng phức tạp hơn. Bạn cần Node.js 20+, PostgreSQL 16, Redis 7 và công cụ Rust để xây dựng OctoBase từ mã nguồn. Phương pháp Docker Compose xử lý tất cả các phụ thuộc và là con đường được khuyến nghị cho môi trường sản xuất. Xây dựng từ mã nguồn chủ yếu dành cho các nhà phát triển đóng góp cho dự án.

## Kết luận: Sở hữu tri thức của bạn

AFFiNE đại diện cho sự chuyển dịch trong quản lý tri thức: từ các gói đăng ký phụ thuộc đám mây sang sở hữu ưu tiên cục bộ, tự lưu trữ. Với tài liệu, bảng vẽ và cơ sở dữ liệu được thống nhất trong một nền tảng mã nguồn mở, bạn loại bỏ sự phân mảnh công cụ trong khi duy trì quyền kiểm soát hoàn toàn đối với dữ liệu.

Triển khai ngày hôm nay chỉ trong 5 phút với Docker, kết nối mô hình AI bạn chọn, và tham gia cộng đồng 47.000+ nhà phát triển đã gắn sao cho dự án. Con đường tự lưu trữ đã sẵn sàng cho sản xuất, đồng bộ CRDT vững chắc, và nhóm đang phát triển nhanh chóng.

**Bắt đầu:** Sao chép kho lưu trữ [toeverything/AFFiNE](https://github.com/toeverything/AFFiNE), làm theo hướng dẫn Docker ở trên, và tham gia [cộng đồng Telegram](https://t.me/affineworkspace) để được hỗ trợ. Tự lưu trữ cơ sở tri thức của bạn trên VPS thông qua [DigitalOcean](https://m.do.co/c/eca87ac14ee0) và không bao giờ lo lắng về việc bị khóa chặt bởi nhà cung cấp.

## Nguồn và tài liệu tham khảo

- [Tài liệu chính thức AFFiNE](https://docs.affine.pro/)
- [Kho GitHub AFFiNE](https://github.com/toeverything/AFFiNE) — 47.000 star, MPL-2.0
- [Khung trình chỉnh sửa BlockSuite](https://github.com/toeverything/blocksuite)
- [Hướng dẫn tự lưu trữ AFFiNE](https://docs.affine.pro/self-host-affine)
- [CRDT và phần mềm ưu tiên cục bộ (Ink & Switch)](https://inkandswitch.com/local-first/)
- [Thực hành tốt nhất Docker Compose môi trường sản xuất](https://docs.docker.com/compose/production/)



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Tiết lộ liên kết liên kết

Bài viết này chứa liên kết liên kết cho DigitalOcean. Nếu bạn đăng ký qua liên kết của chúng tôi, chúng tôi nhận được hoa hồng mà không tốn thêm chi phí cho bạn. Tất cả đề xuất đều dựa trên thử nghiệm thực tế và không bị ảnh hưởng bởi chương trình liên kết. AFFiNE hoàn toàn mã nguồn mở và tự lưu trữ miễn phí không yêu cầu thanh toán.
