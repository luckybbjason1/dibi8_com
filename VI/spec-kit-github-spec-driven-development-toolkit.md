---
title: "Bộ công cụ đặc biệt: GitHub"
description: "Hướng dẫn đầy đủ về Spec Kit của GitHub - bộ công cụ nguồn mở thay đổi cách các nhà phát triển xây dựng phần mềm thông qua phát triển theo đặc tả. Cài đặt, quy trình làm việc và các ví dụ thực tế."
date: 2026-06-20
tags: [ai-tools, coding-agents, desktop-app, tauri, rust]
category: "dev-utils"
lang: vi
slug: spec-kit-github-spec-driven-development-toolkit
featureImage: /images/articles/spec-kit-github-spec-driven-development-toolkit-80967985.png
---

# Spec Kit: Bộ công cụ phát triển dựa trên thông số kỹ thuật mang tính cách mạng của GitHub 

Việc phát triển phần mềm luôn gặp trở ngại bởi sự mất kết nối cơ bản: **những gì chúng tôi chỉ định** hiếm khi khớp với **những gì chúng tôi xây dựng**. Các tài liệu yêu cầu bám đầy bụi, PRD trở nên lỗi thời trong vòng vài ngày và sản phẩm cuối cùng thường khác xa đáng kể so với tầm nhìn ban đầu. 

Nhập **[Spec Kit](https://github.com/github/spec-kit)** - Bộ công cụ nguồn mở đột phá của GitHub giúp lật ngược hoàn toàn tập lệnh này. Với **114.000+ sao GitHub** và khả năng áp dụng nhanh chóng, Spec Kit giới thiệu **Phát triển theo hướng đặc tả (SDD)**, một mô hình trong đó các thông số kỹ thuật trở thành các tạo phẩm có thể thực thi được trực tiếp tạo ra các hoạt động triển khai. 

Trong hướng dẫn toàn diện này, chúng ta sẽ khám phá cách hoạt động của Spec Kit, lý do tại sao nó quan trọng, cách bắt đầu và các ví dụ thực tế chứng minh tiềm năng biến đổi của nó. 

## Bộ thông số kỹ thuật là gì? 

Spec Kit là **bộ công cụ nguồn mở** do GitHub phát triển cho phép **Phát triển theo hướng đặc tả** - một phương pháp trong đó các thông số kỹ thuật không chỉ là tài liệu mà còn là các tạo phẩm thực thi hướng dẫn và tạo mã. 

Quy trình phát triển truyền thống trông như thế này: 

``` 
Yêu cầu → Thiết kế → Thực hiện → Kiểm tra → Triển khai 
(tài liệu) (tài liệu) (mã) (kiểm tra) (prod) 
``` 

Spec Kit thay đổi nó thành: 

``` 
Thông số kỹ thuật → Triển khai → Kiểm tra → Triển khai 
(có thể thực thi) (mã) (kiểm tra) (prod) 
``` 

Thông số kỹ thuật trở thành **nguồn của sự thật** - sống, thở và được kết nối trực tiếp với cơ sở mã. 

## Triết lý cốt lõi 

### Thông số kỹ thuật như các tạo phẩm có thể thực thi 

Không giống như các tài liệu yêu cầu truyền thống, thông số kỹ thuật của Spec Kit là: 

![Cấu trúc bộ công cụ cụ thể](https://images.pexels.com/photos/3184287/pexels-photo-3184287.jpeg) 

- **Kiểm soát phiên bản** cùng với mã 
- **Có thể đọc được bằng máy** dành cho tác nhân AI 
- **Tự động xác thực** khi triển khai 
- **Được theo dõi về độ lệch** giữa thông số kỹ thuật và mã 

### Phát triển AI-Native 

Spec Kit được thiết kế cho thời đại AIđại lý mã hóa. Nó cung cấp các lời nhắc và mẫu có cấu trúc mà các tác nhân AI có thể sử dụng trực tiếp, đảm bảo: 

- Sản lượng nhất quán giữa các đại lý 
- Các quyết định có thể theo dõi được từ thông số kỹ thuật đến mã 
- Cổng chất lượng tự động 
- Hỗ trợ cộng tác đa tác nhân 

### Kết quả có thể dự đoán được qua mã hóa Vibe 

Thay vì "viết mã rung cảm" - đưa ra lời nhắc về AI và hy vọng điều tốt nhất - Spec Kit thực thi một cách tiếp cận có kỷ luật: 

1. **Xác định** điều bạn muốn (thông số kỹ thuật) 
2. **Xác thực** nó hợp lý (hiến pháp) 
3. **Tạo** triển khai (mã) 
4. **Xác minh** nó phù hợp với thông số kỹ thuật (kiểm tra) 

## Bắt đầu 

### Điều kiện tiên quyết 

- **[uv](https://docs.astral.sh/uv/)** - Trình quản lý gói Python 
- Tác nhân mã hóa AI (Copilot, Claude Code, Codex CLI, v.v.) 
- Đã cài đặt Git 

### Bước 1: Cài đặt Chỉ định CLI 

``` bash 
# Cài đặt bằng uv 
cài đặt công cụ uv chỉ định-cli \ 
--từ git+https://github.com/github/spec-kit.git@latest 

# Xác minh cài đặt 
chỉ định --version 
``` 

### Bước 2: Khởi tạo Project 

``` bash 
# Tạo một dự án mới với spec-kit 
chỉ định init my-awesome-app --integration copilot 

# Điều hướng vào dự án 
cd ứng dụng tuyệt vời của tôi 

# Cấu trúc dự án đã tạo: 
# ├── .spec-kit/ 
# │ ├── hiến pháp.md 
# │ ├── thông số kỹ thuật/ 
# │ └── mẫu/ 
# ├── SPEC.md 
# └── README.md 
``` 

### Bước 3: Thiết lập nguyên tắc dự án 

Khởi chạy tác nhân mã hóa của bạn trong thư mục dự án và sử dụng lệnh `/speckit.constitution`: 

``` bash 
# Trong tác nhân mã hóa AI của bạn: 
/speckit.constitution Tạo các nguyên tắc tập trung vào: 
- Tiêu chuẩn chất lượng mã 
- Yêu cầu kiểm tra 
- Điểm chuẩn hiệu suất 
- Nguyên tắc bảo mật 
- Kỳ vọng về tài liệu 
``` 

Điều này tạo ra một tệp `constitution.md` chi phối tất cả các quyết định phát triển tiếp theo. 

### Bước 4: Viết thông số kỹ thuật đầu tiên của bạn 

Sử dụng lệnh `/speckit.specify` để mô tả những gì bạn muốn xây dựng: 

``` bash 
/speckit.specify Xây dựng ứng dụng tổ chức ảnh với các tính năng sau: 
- Người dùng có thể tạo album được nhóm theo ngày 
- Album có thể được sắp xếp lại bằng cách kéo và thả 
- Ảnhs hỗ trợ chỉnh sửa siêu dữ liệu 
- Album được chia sẻ với sự cộng tác 
``` 

Thông số kỹ thuật được lưu dưới dạng tài liệu có cấu trúc mà các tác nhân AI có thể sử dụng. 

## Cách thức hoạt động của Bộ thông số kỹ thuật 

### Quy trình phát triển dựa trên thông số kỹ thuật 

``` 
┌────────────────────────────── ───────────────────────────────┐ 
│ Quy trình làm việc của Bộ công cụ đặc biệt │ 
├────────────────────────────── ───────────────────────────────┤ 
│ │ 
│ 1. HIỂU PHÁP │ 
│ └─ Xác định các nguyên tắc và hướng dẫn của dự án │ 
│ │ 
│ 2. XÁC ĐỊNH │ 
│ └─ Mô tả những gì cần xây dựng (cái gì/tại sao, không phải như thế nào) │ 
│ │ 
│ 3. KẾ HOẠCH │ 
│ └─ Chia thông số kỹ thuật thành các nhiệm vụ có thể thực hiện được │ 
│ │ 
│ 4. TẠO RA │ 
│ └─ Tạo triển khai từ thông số kỹ thuật │ 
│ │ 
│ 5. XÁC NHẬN │ 
│ └─ Đảm bảo việc triển khai phù hợp với thông số kỹ thuật │ 
│ │ 
│ 6. TRIỂN KHAI │ 
│ └─ Vận chuyển đến nơi sản xuất │ 
│ │ 
└────────────────────────────── ───────────────────────────────┘ 
``` 

### Định dạng thông số 

Thông số kỹ thuật tuân theo một định dạng có cấu trúc: 

``` đánh dấu 
# Thông số: Trình quản lý album ảnh 

## Tóm tắt 
Một ứng dụng web để sắp xếp ảnh thành album theo ngày tháng. 

## Câu chuyện của người dùng 
1. Với tư cách là người dùng, tôi muốn tạo các album được nhóm theo ngày 
2. Với tư cách là người dùng, tôi muốn kéo và thả ảnh giữa các album 
3. Alà người dùng, tôi muốn chia sẻ album với cộng tác viên 

## Yêu cầu kỹ thuật 
- Khung: React + TypeScript 
- Quản lý nhà nước: Zustand 
- Lưu trữ: IndexedDB với đồng bộ hóa đám mây 
- Thử nghiệm: Vitest + Nhà viết kịch 

## Tiêu chí thành công 
- [ ] Album có thể được tạo, đổi tên, xóa 
- [] Kéo và thả hoạt động trên máy tính để bàn và thiết bị di động 
- [] Đồng bộ album được chia sẻ trên các thiết bị 
- [ ] Hiệu suất: <100ms cho 1000 ảnh 
``` 

### Tích hợp tác nhân AI 

Spec Kit hoạt động với nhiều tác nhân mã hóa AI: 

| Đại lý | Phương pháp tích hợp | 
|-------|-------------------| 
| Phi công phụ GitHub | `/speckit.*` lệnh gạch chéo | 
| Codex CLI | lệnh `$speckit-*` | 
| Mã Claude | Mẫu nhắc nhở đại lý | 
| Song Tử CLI | Cuộc gọi chức năng tùy chỉnh | 
| Mã mở | Định nghĩa kỹ năng | 

## Ví dụ trong thế giới thực 

### Ví dụ 1: Xây dựng REST API 

``` bash 
# Xác định thông số kỹ thuật 
/speckit.specify Xây dựng API REST cho nền tảng blog với: 
- Hoạt động CRUD cho bài viết 
- Xác thực người dùng với JWT 
- Hệ thống bình luận lồng nhau 
- Chức năng tìm kiếm 
- Giới hạn tỷ lệ 

# Tạo triển khai 
/speckit.create 

# Xác thực theo thông số kỹ thuật 
/speckit.validate 
``` 

### Ví dụ 2: Tạo ứng dụng di động 

``` bash 
# Xác định thông số kỹ thuật 
/speckit.specify Xây dựng ứng dụng di động theo dõi hoạt động thể chất với: 
- Ghi nhật ký tập luyện với thư viện bài tập 
- Biểu đồ tiến độ và thống kê 
- Tính năng xã hội (chia sẻ tập luyện) 
- Hỗ trợ ngoại tuyến 
- Tích hợp HealthKit/Google Fit 

# Tạo triển khai 
/speckit.create --framework rung 
``` 

### Ví dụ 3: Kiến trúc microservices 

``` bash 
# Xác định thông số kỹ thuật 
/speckit.specify Thiết kế kiến trúc vi dịch vụ cho: 
- Dịch vụ người dùng (xác thực, hồ sơ) 
- Dịch vụ đặt hàng (đặt hàng, thanh toán) 
- Dịch vụ kho bãi (kho, kho) 
- Dịch vụ thông báo (email, SMS, push) 
- Cổng API để định tuyến 

# Tạo triển khai 
/speckit.plan --vi dịch vụ kiến trúc 
/speckit.create --framework kubernetes 
``` 

## Gói: Thiết lập dựa trên vai trò 

Spec Kit bao gồm các gói được cấu hình sẵn cho các vai trò khác nhau trong nhóm: 

### Nhà phát triểnGói 

Tối ưu hóa cho các nhà phát triển cá nhân: 

``` bash 
chỉ định nhà phát triển init --bundle 
``` 

Bao gồm: 
- Quy trình làm việc đơn giản hóa 
- Vòng phản hồi nhanh 
- Phát triển theo địa phương 

### Nhóm nhóm 

Được thiết kế để hợp tác phát triển: 

``` bash 
chỉ định nhóm init --bundle 
``` 

Bao gồm: 
- Cổng xét duyệt mã 
- Quy tắc bảo vệ chi nhánh 
- Mẫu hiến pháp được chia sẻ 

### Gói doanh nghiệp 

Đối với các tổ chức lớn: 

``` bash 
chỉ định init --bundle doanh nghiệp 
``` 

Bao gồm: 
- Mẫu tuân thủ 
- Đường mòn kiểm toán 
- Hỗ trợ đa môi trường 
- Tích hợp tùy chỉnh 

## Tính năng nâng cao 

### Hệ thống mở rộng 

Spec Kit hỗ trợ các tiện ích mở rộng cho quy trình làm việc tùy chỉnh: 

``` bash 
# Cài đặt tiện ích mở rộng 
chỉ định cài đặt tiện ích mở rộng github/spec-kit-extension-ci 

# Tạo mẫu tùy chỉnh 
chỉ định mẫu tạo my-custom-spec 
``` 

### Cài đặt trước tùy chỉnh 

Xác định cài đặt trước thông số kỹ thuật của riêng bạn: 

```yaml 
# .spec-kit/presets.yaml 
cài đặt trước: 
ứng dụng web: 
khuôn khổ: phản ứng 
tiểu bang: zustand 
thử nghiệm: vitest 
dịch vụ api: 
khuôn khổ: fastapi 
cơ sở dữ liệu: postgresql 
bộ đệm: redis 
ứng dụng di động: 
khuôn khổ: rung động 
tiểu bang: riverpod 
thử nghiệm: tích hợp_test 
``` 

### Phát hiện trôi dạt 

Spec Kit tự động phát hiện khi triển khai sai lệch so với thông số kỹ thuật: 

``` bash 
# Kiểm tra độ lệch thông số kỹ thuật 
chỉ định kiểm tra độ trôi 

# Xem báo cáo trôi dạt 
chỉ định báo cáo trôi dạt --output html 
``` 

Các báo cáo bao gồm: 
- Thiếu tính năng từ thông số kỹ thuật 
- Các tính năng không được dùng nữa không có trong thông số kỹ thuật 
- Kiểm tra khoảng cách bảo hiểm 
- Tài liệu không nhất quán 

##So Sánh Với Phương Pháp Truyền Thống 

### Bộ công cụ đặc biệt so với PRD truyền thống 

| Khía cạnh | PRD truyền thống | Bộ thông số kỹ thuật | 
|--------|-------|----------| 
| Định dạng | Tài liệu dạng tự do | Thông số cấu trúc | 
| Tình trạng sống | Trở nên lỗi thời | Luôn đồng bộ | 
| Vật tư tiêu hao AI | Không | Có | 
| Xác thực | Hướng dẫn sử dụng | Tự động | 
| Kiểm soát phiên bản | Wiki riêng biệt | Theo dõi Git | 
| Phát hiện trôi dạt | Không có | Tích hợp | 

### Câu chuyện về Spec Kit và câu chuyện của người dùng Agile 

| Khía cạnh | Câu chuyện của người dùng | Bộ thông số kỹ thuật | 
|--------|-------------|----------| 
| Độ chi tiết | Cấp cao | Chi tiết | 
| Thông số kỹ thuật | Riêng biệt | Bao gồm | 
| Tiêu chí kiểm tra | ngầm định | Rõ ràng | 
| Sẵn sàng AI | Nghèo | Xuất sắc | 
| Truy xuất nguồn gốc | Hướng dẫn sử dụng | Tự động | 

## Các phương pháp hay nhất 

### Viết thông số kỹ thuật hiệu quả 

1. **Tập trung vào cái gì, không phải như thế nào** - Mô tả kết quả mong muốn, không phải việc thực hiện 
2. **Hãy cụ thể về các ràng buộc** - Yêu cầu về hiệu suất, bảo mật, khả năng tương thích 
3. **Bao gồm các tiêu chí chấp nhận** - Xóa các điều kiện đạt/không đạt 
4. **Phiên bản thông số kỹ thuật của bạn** - Theo dõi các thay đổi theo thời gian 
5. **Giữ thông số kỹ thuật luôn hoạt động** - Cập nhật thông số kỹ thuật khi yêu cầu phát triển 

### Tích hợp với CI/CD 

```yaml 
# .github/workflows/spec-validate.yml 
Tên: Xác thực thông số kỹ thuật 
trên: [pull_request] 

công việc: 
xác thực: 
đang chạy: ubuntu-mới nhất 
các bước: 
- sử dụng: hành động/checkout@v4 
- tên: Cài đặt Chỉ định CLI 
chạy: cài đặt công cụ uv chỉ định-cli 
- tên: Xác thực độ trôi thông số kỹ thuật 
chạy: chỉ định kiểm tra trôi 
- name: Chạy thử nghiệm dựa trên thông số kỹ thuật 
chạy: chỉ định kiểm tra --from-spec 
``` 

### Hợp tác nhóm 

- Chia sẻ các mẫu hiến pháp giữa các dự án 
- Sử dụng thư viện thông số kỹ thuật cho các mẫu phổ biến 
- Xem xét thông số kỹ thuật trước khi thực hiện 
- Theo dõi khả năng truy xuất nguồn gốc của thông số kỹ thuật 

## Câu hỏi thường gặp 

### Hỏi: Spec Kit có được sử dụng miễn phí không? 

Đúng! Spec Kit là **mã nguồn mở theo giấy phép MIT**. Nó hoàn toàn miễn phí cho mục đích sử dụng cá nhân và thương mại. 

### Hỏi: Tác nhân AI nào được hỗ trợ? 

Spec Kit chính thức hỗ trợ: 
- **GitHub Copilot** (tích hợp gốc) 
- **Mã Claude** (thông qua các mẫu) 
- **Codex CLI** (thông qua lệnh) 
- **Gemini CLI** (thông qua lệnh gọi hàm) 
- **OpenCode** (thông qua kỹ năng) 
- **Bất kỳ tác nhân nào** có thể sử dụng thông số kỹ thuật có cấu trúc 

### Hỏi: Tôi có cần sử dụng Spec Kit với tác nhân AI không? 

Không. Mặc dù Spec Kit được thiết kế dành cho các tác nhân AI nhưng nó cũng có thể được sử dụng cho hoạt động phát triển truyền thống do con người chỉ đạo. Định dạng thông số có cấu trúc cải thiện tính rõ ràng bất kể ai thực hiện nó. 

### Hỏi: Spec Kit xử lý các dự án phức tạp như thế nào? 

Bộ thông số kỹ thuậtquy mô thông qua: 
- **Thông số kỹ thuật mô-đun** - Chia thông số kỹ thuật lớn thành các phần nhỏ hơn, dễ quản lý hơn 
- **Thành phần** - Kết hợp nhiều thông số kỹ thuật cho các hệ thống phức tạp 
- **Tổ chức phân cấp** - Mối quan hệ đặc tả cha-con 
- **Quản lý phụ thuộc** - Theo dõi sự phụ thuộc lẫn nhau của thông số kỹ thuật 

### Hỏi: Tôi có thể di chuyển từ tài liệu hiện có không? 

Đúng! Spec Kit cung cấp các công cụ di chuyển: 
- Chuyển đổi tài liệu Markdown thành thông số kỹ thuật 
- Trích xuất yêu cầu từ Jira/Linear 
- Chuyển đổi PRD thành thông số kỹ thuật có cấu trúc 
- Nhập câu chuyện của người dùng vào định dạng đặc tả 

### Hỏi: Còn các nghi lễ linh hoạt thì sao? 

Spec Kit tích hợp với quy trình làm việc linh hoạt: 
- Thông số kỹ thuật trở thành câu chuyện sống động của người dùng 
- Hiến pháp thay thế thỏa thuận làm việc nhóm 
- Phát hiện trôi dạt hỗ trợ đánh giá nước rút 
- Xác nhận thông số kỹ thuật hỗ trợ định nghĩa đã hoàn thành 

## Kết luận 

Spec Kit thể hiện sự thay đổi cơ bản trong cách chúng ta tiếp cận việc phát triển phần mềm. Bằng cách làm cho các thông số kỹ thuật có thể thực thi được, được kiểm soát theo phiên bản và có thể sử dụng được bằng AI, nó thu hẹp khoảng cách giữa những gì chúng tôi dự định xây dựng và những gì thực sự được xây dựng. 

Cho dù bạn là nhà phát triển cá nhân đang tìm kiếm kết quả dễ dự đoán hơn hay một nhóm đang tìm cách chuẩn hóa quy trình phát triển của mình, Spec Kit sẽ cung cấp cấu trúc, tính linh hoạt và khả năng dựa trên AI mà bạn cần. 

Với sự hỗ trợ từ GitHub và sự chấp nhận nhanh chóng của cộng đồng nhà phát triển, Spec Kit sẵn sàng trở thành một công cụ thiết yếu trong bộ công cụ của nhà phát triển hiện đại. 

## Tài nguyên 

- [Kho lưu trữ GitHub](https://github.com/github/spec-kit) 
- [Tài liệu](https://github.github.io/spec-kit/) 
- [Hướng dẫn bắt đầu](https://github.com/github/spec-kit#getting-started) 
- [Thị trường tiện ích mở rộng](https://github.com/github/spec-kit/extensions) 
- [Bất hòa cộng đồng](https://discord.gg/speckit) 

**Nguồn:** 
- [Kho lưu trữ GitHub của Spec Kit](https://github.com/github/spec-kit) 
- [Tài liệu chính thức của Spec Kit](https://github.github.io/spec-kit/) 
- [Tuyên ngôn phát triển dựa trên thông số kỹ thuật](https://github.com/github/spec-kit/blob/main/docs/manifesto.md) 

--- 

💬 Tham gia Telegram của chúng tôinhóm thảo luận: [t.me/DIBI8_Group](https://t.me/DIBI8_Group)