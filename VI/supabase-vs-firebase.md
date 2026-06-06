---
title: 'Supabase vs Firebase 2026: BaaS nào tốt hơn?'
description: 'So sánh Supabase mã nguồn mở dựa trên Postgres và Firebase NoSQL của Google — database, auth, storage, realtime, edge functions, giá cả, lock-in, self-host. Cập nhật 2026.'
date: 2026-05-22 00:00:00+08:00
draft: false
tags: [supabase, firebase, baas, postgres, firestore, comparison, backend]
categories: [vs]
faqs:
  - q: 'Supabase hay Firebase rẻ hơn?'
    a: 'Với dự án nhỏ, cả hai đều có hạn mức miễn phí hào phóng, nhưng Supabase rẻ hơn về cấu trúc khi mở rộng quy mô vì truy vấn Postgres không tính phí theo từng hàng. Firebase Firestore tính phí theo số document đọc — một truy vấn dashboard kéo 10K document tốn tiền thật trên Firebase nhưng miễn phí trên Supabase nếu nằm trong compute đã bao gồm. Với khối lượng nặng về phân tích, hóa đơn hàng tháng của Supabase rẻ hơn 5-10 lần.'
  - q: 'Cái nào tốt hơn cho dữ liệu quan hệ?'
    a: 'Supabase thắng cách biệt — nó chính là Postgres bên dưới, nên bạn có JOIN, foreign key, transaction, view, CTE ngay từ đầu. Firebase Firestore là NoSQL/document và buộc bạn phải denormalize hoặc JOIN ở client. Nếu dữ liệu có quan hệ (user, order, product), chọn Supabase.'
  - q: 'Có thể self-host Supabase hay Firebase không?'
    a: 'Supabase có, Firebase không. Supabase hoàn toàn mã nguồn mở (Apache 2.0 / PostgreSQL license) và bạn có thể chạy toàn bộ stack trên server của mình bằng Docker Compose. Firebase là dịch vụ đóng của Google — không có tùy chọn self-host, lối thoát duy nhất là di chuyển toàn bộ.'
  - q: 'Cái nào có realtime tốt hơn?'
    a: 'Realtime của Firebase trưởng thành hơn — là tính năng chủ lực từ 2012 và xử lý hàng triệu kết nối đồng thời không cần tinh chỉnh. Realtime của Supabase (logical replication Postgres + Phoenix Channels) mới hơn nhưng đang bắt kịp nhanh và hoạt động tốt dưới 10K client đồng thời. Cho app chat/presence dưới 10K user, cả hai đều ổn; trên ngưỡng đó Firebase có lợi thế.'
  - q: 'Cái nào tốt hơn cho AI / vector search?'
    a: 'Supabase thắng tuyệt đối — nó có pgvector tích hợp sẵn, bạn có thể lưu embedding và chạy truy vấn cosine-similarity trong cùng database với dữ liệu app. Firebase không hỗ trợ vector native và phải gắn thêm Vertex AI hoặc DB vector riêng. Cho app RAG/AI năm 2026, Supabase là lựa chọn hiển nhiên.'
---

## Câu Trả Lời Nhanh

**Supabase** thắng cho developer muốn database Postgres quan hệ, sự linh hoạt của SQL, tự do mã nguồn mở, và vector store tích hợp cho app AI. **Firebase** thắng cho developer muốn đồng bộ realtime đã qua chiến đấu, tích hợp sâu Google Cloud, và tư duy NoSQL.

Chọn **Supabase** nếu: Bạn muốn Postgres + SQL + JOIN, coi trọng mã nguồn mở và tùy chọn self-host, dự định xây tính năng AI/RAG với pgvector, và cần giá có thể dự đoán khi mở rộng.

Chọn **Firebase** nếu: Bạn cần đồng bộ realtime cực ổn ở quy mô lớn, bạn đã đang dùng Google Cloud, bạn thích model document NoSQL, hoặc bạn đang ship app mobile-first hưởng lợi từ Firebase Auth + Crashlytics + Analytics trong một bộ.

---

## So Sánh Trực Diện

| Tính năng | Supabase | Firebase |
|---|---|---|
| **Nhà cung cấp** | Supabase Inc. | Google |
| **Ra mắt** | 2020 | 2011 (Google mua lại 2014) |
| **Database** | PostgreSQL 15+ (quan hệ) | Firestore + Realtime DB (NoSQL) |
| **Ngôn ngữ truy vấn** | SQL + REST/GraphQL tự động sinh | Truy vấn Firestore SDK (hạn chế) |
| **JOIN / transaction** | Native (Postgres) | Không có JOIN, transaction hạn chế |
| **Auth** | Supabase Auth (email, OAuth, magic link, SSO, MFA) | Firebase Auth (email, OAuth, phone, anonymous) |
| **Storage** | Object storage tương thích S3 + RLS | Cloud Storage (nền GCS) |
| **Realtime** | Logical replication Postgres + Phoenix Channels | Firestore listener + Realtime DB |
| **Edge functions** | Dựa trên Deno, triển khai toàn cầu | Cloud Functions (Node.js/Python) |
| **Vector search** | pgvector native | Không có (cần Vertex AI) |
| **Hạn mức miễn phí** | 500 MB DB, 1 GB storage, 50K MAU | 1 GB Firestore, 5 GB storage, auth không giới hạn |
| **Mức trả phí khởi điểm** | Pro $25/tháng, dự đoán được | Blaze trả theo dùng, có thể nổ hóa đơn |
| **Mã nguồn mở** | Có (Apache 2.0 / PostgreSQL) | Không |
| **Self-host** | Có (Docker Compose, full stack) | Không |
| **Vendor lock-in** | Thấp (Postgres + S3 chuẩn) | Cao (model dữ liệu Firestore độc quyền) |
| **Ngôn ngữ SDK** | JS, Dart, Swift, Kotlin, Python, Go | JS, Dart, Swift, Kotlin, Unity, C++ |

---

## Khi Nào Chọn Supabase

### Use case 1: Dữ liệu quan hệ với JOIN
Nếu app của bạn có user, order, product, post, comment — bất cứ thứ gì có quan hệ — Supabase thắng mặc định. Viết SQL có JOIN, foreign key, transaction, materialized view, CTE, window function. Firebase buộc bạn denormalize mọi thứ và JOIN ở client, sẽ sập khi vượt 50 document.

### Use case 2: AI / RAG / vector search
pgvector tích hợp sẵn. Lưu embedding OpenAI/Anthropic trong cùng database với dữ liệu user, chạy truy vấn cosine-similarity bằng một dòng SQL, kết quả dưới 100ms tới vài triệu vector. Firebase không có gì tương đương — bạn cần thêm Pinecone/Weaviate/Vertex AI riêng.

### Use case 3: Mã nguồn mở + self-host
Supabase license Apache 2.0 / PostgreSQL. Bạn có thể clone repo, chạy `docker compose up`, và có toàn bộ stack — Postgres + GoTrue auth + Storage + Realtime + Studio — chạy trên laptop hoặc VPS. Nếu một ngày cần thoát khỏi cloud, lối thoát đã có sẵn. Firebase không có.

### Use case 4: Giá có thể dự đoán
Supabase Pro phẳng $25/tháng có compute bao gồm, cộng phụ phí theo dùng. Bạn có thể lập ngân sách. Firebase Blaze trả theo dùng với phí mỗi document đọc, mỗi lần gọi function, mỗi GB egress — một tweet viral hoặc loop bị bug có thể đẻ ra hóa đơn $400 chỉ trong một đêm. Nhiều chuyện kinh dị về Firebase trên Reddit bắt đầu bằng "Tôi không biết loop có thể đọc 1M document."

---

## Khi Nào Chọn Firebase

### Use case 1: Realtime quy mô khổng lồ
Realtime Firebase đã qua chiến đấu từ 2012. Chat quy mô Slack, state game multiplayer, stream cảm biến IoT — Firebase xử lý hàng triệu kết nối đồng thời không cần tinh chỉnh. Realtime Supabase xuất sắc nhưng mới hơn; trên ~10K client đồng thời bạn bắt đầu tinh chỉnh replication slot Postgres.

### Use case 2: Stack mobile-first
Firebase + Crashlytics + Analytics + Cloud Messaging + Remote Config + A/B Testing là một bộ tích hợp chặt. Nếu bạn ship iOS/Android trước, Firebase tiết kiệm cho bạn 10 lần tích hợp SDK riêng. Supabase có SDK nhưng lớp observability mobile mỏng hơn.

### Use case 3: Tích hợp Google Cloud
Nếu bạn đã sâu trong GCP — BigQuery export, Cloud Run, Vertex AI, IAM — Firebase cắm vào native. Hóa đơn xuyên sản phẩm, single console, IAM thống nhất. Supabase là cloud riêng và không chia sẻ lớp identity của Google.

### Use case 4: Auth ẩn danh + phone ở quy mô lớn
Firebase Auth có auth ẩn danh và SMS phone auth trưởng thành nhất trong giới BaaS. Cho app xã hội nơi user duyệt trước rồi đăng ký sau, Firebase làm nâng cấp anonymous → tài khoản vĩnh viễn cực mượt.

---

## Phân Tích Giá Chuyên Sâu

### Supabase
- **Free**: 500 MB DB, 1 GB storage, 50K MAU, 2 GB băng thông, point-in-time recovery 7 ngày
- **Pro**: $25/tháng, 8 GB DB, 100 GB storage, 100K MAU, backup hàng ngày, không bị tạm dừng project
- **Team**: $599/tháng, SOC 2, SSO, hỗ trợ ưu tiên
- **Enterprise**: tùy chỉnh

→ **Chi phí hàng tháng cho SaaS điển hình 10K MAU**: $25-$50 (Pro + chút egress vượt).

### Firebase
- **Spark (miễn phí)**: 1 GB Firestore, 5 GB storage, auth không giới hạn, 50K reads/ngày
- **Blaze (trả theo dùng)**: $0.06 mỗi 100K reads, $0.18 mỗi 100K writes, $0.026/GB storage, $0.12/GB egress
- **Không có gói Pro phẳng** — trả theo lượng dùng

→ **Chi phí hàng tháng cho SaaS điển hình 10K MAU**: $30-$300+ tùy mẫu đọc. Một truy vấn thiết kế tệ fan-out 100 reads/user × 10K user × 30 ngày = 30M reads = ~$18 chỉ riêng reads, cộng writes, storage, egress.

### Người Thắng Ngân Sách
Hóa đơn dự đoán được: **Supabase Pro $25/tháng** thắng cách xa.
Side project không traffic: **Firebase Spark** kéo lâu hơn vì không có tạm dừng project.
App nặng phân tích hoặc AI/RAG: **Supabase thắng 5-10 lần** về hóa đơn hàng tháng.

---

## Benchmark Hiệu Năng (Chủ quan, từ sử dụng hàng ngày)

| Task | Supabase | Firebase |
|---|---|---|
| App CRUD đơn giản | 9/10 | 9/10 |
| Truy vấn quan hệ phức tạp | 10/10 | 4/10 |
| Chat realtime (1K user) | 9/10 | 10/10 |
| Chat realtime (100K user) | 7/10 | 10/10 |
| Upload file + signed URL | 9/10 | 9/10 |
| Auth (OAuth + email) | 9/10 | 9/10 |
| Auth (anonymous + SMS phone) | 7/10 | 10/10 |
| Vector search / RAG | 10/10 | 3/10 |
| Cold start edge function | 8/10 | 6/10 |
| Self-host / data portability | 10/10 | 2/10 |
| Khả năng dự đoán giá | 10/10 | 5/10 |

→ Supabase thắng quan hệ, AI, giá, lock-in. Firebase thắng realtime quy mô lớn và observability mobile-first.

---

## Mẹo Migration

### Firebase → Supabase
- Export dữ liệu Firestore sang JSON qua `firebase-tools` (`firebase firestore:export`)
- Thiết kế schema Postgres trước — denormalize Firestore thành bảng quan hệ
- Dùng bulk import của Supabase qua `psql` hoặc CSV uploader của Studio
- Thay listener Firestore bằng `supabase.channel().on('postgres_changes', ...)`
- Migrate user Firebase Auth qua API `auth.admin.createUser()` của Supabase (mật khẩu cần re-hash — gửi email reset mật khẩu cho user)
- Chạy song song hai stack một chu kỳ thanh toán để so sánh hóa đơn

### Supabase → Firebase
- Export bảng Postgres sang CSV (`COPY ... TO STDOUT`)
- Làm phẳng dữ liệu quan hệ thành document Firestore denormalize (phần khó nhất — lập kế hoạch 1-2 tuần redesign schema)
- Thay truy vấn SQL bằng gọi Firestore SDK — mất JOIN, xây lại bằng composite index
- Migrate auth user qua `importUsers()` của Firebase Admin SDK với blob passwordHash
- Lập ngân sách cho hóa đơn bất ngờ tháng đầu — bật cảnh báo ngân sách GCP ngày đầu

### Lưu Ý Self-Hosting
Muốn chạy Supabase trên server riêng để thoát hoàn toàn hóa đơn cloud hoặc giữ dữ liệu on-prem để tuân thủ? Bật một {{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean droplet với $200 credit miễn phí" >}} — droplet 4 GB $24/tháng xử lý thoải mái stack Supabase self-host (Postgres + GoTrue + Storage + Realtime + Studio) cho SaaS nhỏ-tới-trung bình. Rẻ hơn Supabase Pro từ tháng 4, và dữ liệu không bao giờ rời cơ sở hạ tầng của bạn. Firebase không có cái tương đương — không có cách self-host ra khỏi cloud của Google.

---

## Phương Án Thay Thế Đáng Thử

Nếu Supabase và Firebase đều không hợp, hãy xem xét:

- **[Appwrite](https://dibi8.com/vi/resources/llm-frameworks/)** — BaaS mã nguồn mở, self-host được, có ý kiến mạnh hơn Supabase
- **PocketBase** — BaaS Go single-binary, hoàn hảo cho project nhỏ
- **Convex** — Backend reactive TypeScript-first, DX tuyệt vời cho team full-stack TS
- **Nhost** — Postgres + Hasura GraphQL + Auth, tương tự Supabase nhưng GraphQL native
- **Neon + Clerk + Cloudflare R2** — Stack DIY composable, linh hoạt tối đa, nhiều dây nối hơn

---

## Quan Điểm dibi8

Năm 2026, thị trường BaaS đã hợp nhất quanh hai người dẫn đầu: Supabase cho developer tư duy SQL và muốn tự do mã nguồn mở, Firebase cho team cần realtime quy mô Google và stack observability mobile sâu.

Nếu bạn bắt đầu một SaaS năm 2026 với dữ liệu quan hệ và tham vọng AI/RAG → **Supabase Pro ($25/tháng)**, không bàn cãi. Combo pgvector + Postgres không thể đánh bại.
Nếu bạn đang ship app social hoặc messaging mobile-first ở quy mô lớn → **Firebase Blaze**, nhưng bật cảnh báo ngân sách GCP ngày đầu.
Nếu bạn muốn cả data portability và realtime quy mô Google → **Supabase self-host trên droplet** + **Cloudflare Durable Objects** cho lớp realtime.

Indie dev ship một SaaS năm 2026? **Supabase Pro $25/tháng** là ROI thô tốt nhất hiện nay trong category BaaS — hóa đơn dự đoán được, linh hoạt SQL, pgvector tích hợp cho tính năng AI, và lối thoát thật qua self-hosting. Firebase vẫn là vua realtime mobile quy mô lớn, nhưng bạn trả giá bằng lock-in và hóa đơn hàng tháng không dự đoán được.

---

## FAQ

(render qua faqs frontmatter — hiển thị inline + JSON-LD cho AIO)

---

## Đọc Thêm

- [So sánh Cursor vs Claude Code 2026](https://dibi8.com/vi/vs/cursor-vs-claude-code/)
- [ChatGPT Pro vs Claude Pro 2026](https://dibi8.com/vi/vs/chatgpt-pro-vs-claude-pro/)
- [Công cụ AI Coding tốt nhất 2026 — Phương án thay thế Cursor](https://dibi8.com/vi/resources/llm-frameworks/ai-coding-tools-cursor-alternatives-2026/)
- [LLM Stack giá rẻ dưới $20/tháng](https://dibi8.com/vi/collections/cheap-llm-stack/)

## Công Cụ Đề Xuất

**Self-host Supabase ở châu Á?** Hong Kong VPS cho bạn Supabase stack với latency thấp nhất cho user ở China và SEA.

- **{{< aff "htstack" "vs-footer" "HTStack" >}}** — Hong Kong VPS, cùng IDC host dibi8.com. Bổ sung DigitalOcean nếu có multi-region user — HTStack cho châu Á, DigitalOcean cho US/EU. Self-host Supabase full stack (Postgres + GoTrue + Storage + Realtime) không bị vendor lock-in.

*Affiliate link — không tốn thêm chi phí và giúp dibi8.com vận hành.*

