---
title: "WiFi-Forge — Sandbox An Toàn và Hợp Pháp Để Học Hack WiFi"
description: "WiFi Forge: phòng thí nghiệm hack WiFi an toàn cho nghiên cứu bảo mật. Học kiểm thử xâm nhập, bảo mật không dây và hack đạo đức trong môi trường được kiểm soát."
date: 2026-05-15T04:20:25+09:00
lastmod: 2026-05-15T04:20:25+09:00
tech_stack:
  - Python
application_domain: "Ai Tools"
source_version: ""
licensing_model: "Open Source"
license_type: "MIT"
file_size: "16.4 MB"
file_md5: ""
download_url: "https://github.com/her3ticAVI/MiniNet-framework"
backup_url: ""
github_repo: "https://github.com/her3ticAVI/MiniNet-framework"
stars: 813
maintainer: "blackhillsinfosec"
last_maintained: "2026-05-15"
featureImage: ""
draft: false
aliases:
- /vi/posts/wifi-forge-safe-wifi-hacking-lab/
faqs:
  - q: 'WiFi-Forge là gì?'
    a: 'WiFi-Forge là dự án mã nguồn mở của Black Hills InfoSec, cung cấp môi trường sandbox an toàn và hợp pháp để luyện tập các kỹ thuật tấn công không dây. Nó chạy một phòng lab ảo ngay trên laptop của bạn, không cần mua phần cứng và không có rủi ro đụng chạm vào mạng của người khác.'
  - q: 'Tôi có cần adapter WiFi đặc biệt để học tấn công WiFi với WiFi-Forge không?'
    a: 'Không. WiFi-Forge mô phỏng toàn bộ access point, station và sóng vô tuyến bằng phần mềm, hoàn toàn loại bỏ nhu cầu dùng USB adapter hỗ trợ monitor mode. Bạn chỉ cần card thật khi muốn tìm hiểu lớp vật lý RF, phần mà môi trường mô phỏng này không đề cập đến.'
  - q: 'WiFi-Forge được xây dựng trên nền tảng công nghệ gì?'
    a: 'WiFi-Forge được xây dựng trên mininet-wifi, một trình giả lập mạng 802.11 tạo ra các access point và client ảo bên trong Linux network namespace. Mỗi AP và client là một tiến trình Linux thực sự, vì vậy các công cụ như airodump-ng, tcpdump, Reaver và Hashcat hoạt động y hệt như khi xử lý lưu lượng vô tuyến thực.'
  - q: 'Bạn có thể luyện tập những kiểu tấn công WiFi nào trong WiFi-Forge?'
    a: 'Các lab đi kèm bao gồm: bắt gói handshake WPA/WPA2, tấn công WPS (brute-force PIN với Reaver và Pixie-Dust), AP giả mạo kiểu evil-twin/Karma, tấn công deauthentication flood, beacon flooding, phân tích MAC randomization và tấn công PMKID. Mỗi lab khởi động một topology cụ thể và đặt ra một mục tiêu nhỏ theo phong cách CTF.'
  - q: 'Tôi cần gì để cài đặt và chạy WiFi-Forge?'
    a: 'Bạn cần Linux (Ubuntu hoặc Debian là tốt nhất), Python 3 và quyền root vì mininet-wifi sử dụng các tính năng của kernel. Sau khi clone repo, chạy sudo ./install.sh để cài đặt các dependency, rồi chạy sudo python3 wififorge.py để khởi động.'
---
{</* resource-info */>}

Nếu bạn từng thử học các cuộc tấn công WiFi theo cách truyền thống, quy trình thường như sau: đặt một USB WiFi adapter hỗ trợ chế độ monitor và packet injection, vật lộn với driver Linux cả buổi tối, dựng một access point thử nghiệm mà bạn thực sự sở hữu, và *sau đó* mới bắt đầu luyện kỹ thuật bạn muốn học. **WiFi-Forge** bỏ qua toàn bộ quá trình chuẩn bị này.

![Banner WiFi-Forge](https://github.com/her3ticAVI/MiniNet-framework/raw/main/images/WifiForgeVersion2.png)

[WiFi-Forge](https://github.com/blackhillsinfosec/WifiForge) là một dự án mã nguồn mở của [Black Hills InfoSec](https://www.blackhillsinfosec.com/), cung cấp môi trường **an toàn và hợp pháp** để luyện tấn công không dây. Không cần phần cứng, không có nguy cơ vô tình tác động vào mạng người khác, và không lo brick driver. Khởi động một lab ảo và bắt đầu hack ngay.

## Vì sao tồn tại —— ba cái bẫy khi học WiFi

Học WiFi truyền thống có ba điểm khiến nhiều người bỏ cuộc:

1. **Hên xui phần cứng.** Không phải USB adapter nào cũng hỗ trợ monitor + injection sạch sẽ. Những cái đáng tin (Alfa AWUS036, Panda PAU09, v.v.) tốn 30–60 USD, và một lần chỉ dùng được một cái.
2. **Vùng xám pháp lý.** Ở hầu hết các nước, chạm vào bất kỳ mạng nào bạn không sở hữu —— kể cả nghe lén bị động —— đều là phạm pháp. *"Tôi chỉ sniff thôi"* không phải lý do biện hộ được.
3. **Chi phí reset.** Phần cứng thật không reset bằng một lệnh. Bạn không thể `git checkout` để hoàn tác cấu hình hỏng.

WiFi-Forge gói gọn cả ba vấn đề này vào một sandbox duy nhất trên laptop của bạn.

## Cấu trúc bên trong

WiFi-Forge được xây dựng trên [mininet-wifi](https://github.com/intrig-unicamp/mininet-wifi) —— một bộ mô phỏng mạng 802.11 tạo các access point ảo, station và "sóng vô tuyến" trong các Linux network namespace. Mỗi AP và client là một process Linux thực —— bạn có thể dùng `iwconfig`, `airodump-ng`, `tcpdump`, thậm chí cả Reaver và Hashcat trên traffic mô phỏng, và tất cả các công cụ tiêu chuẩn đều hành xử như đang chạm vào sóng radio thật.

WiFi-Forge thêm vào trên đó: các topology dựng sẵn, các kịch bản tấn công sẵn sàng chạy, và cấu trúc hướng dẫn để bạn không phải thiết kế mạng từ đầu mỗi lần muốn luyện tập.

## Có thể luyện gì

![WiFi-Forge đang chạy](https://github.com/her3ticAVI/MiniNet-framework/raw/main/images/wififorge-running.png)

Các lab có sẵn bao phủ những loại tấn công WiFi phổ biến:

- **Bắt handshake WPA/WPA2** —— deauth một client, bắt 4-way handshake, crack offline bằng hashcat hoặc aircrack-ng
- **Tấn công WPS** —— brute-force PIN bằng Reaver, tấn công Pixie-Dust
- **Evil-twin / Karma** —— dựng AP giả mạo SSID mục tiêu, xem các client tự động kết nối
- **Deauth flood** —— đá client khỏi các AP hợp pháp
- **Beacon flooding** —— phát hàng nghìn AP giả để làm rối các scanner
- **Phân tích MAC randomization** —— xem cách các thiết bị hiện đại che giấu danh tính (và rò rỉ ở đâu)
- **Tấn công PMKID** —— bắt handshake mà không cần client đang kết nối

Mỗi lab khởi động một topology cụ thể, đưa bạn vào shell, và đặt ra mục tiêu kiểu CTF nhỏ.

## Bắt đầu

```bash
git clone https://github.com/blackhillsinfosec/WifiForge
cd WifiForge
sudo ./install.sh
sudo python3 wififorge.py
```

Cần Linux (Ubuntu hoặc Debian là tốt nhất), Python 3, và quyền root (mininet-wifi dùng các tính năng kernel). Script cài đặt sẽ xử lý dependencies —— mininet-wifi, aircrack-ng, hashcat, reaver, v.v.

## Dành cho ai

![Phòng lab không dây](https://www.bobology.com/members/images/249.jpg?cb=20250922025150)

- **Người ôn OSCP / OSWP** —— luyện các kịch bản giống lab thi mà không cần mua phần cứng
- **Người tổ chức CTF** —— dựng nhanh các challenge wireless mà không cần radio thật
- **Giảng viên bảo mật** —— cấp cho mỗi học viên một lab độc lập, reset trong vài giây
- **Lập trình viên tò mò** —— cuối cùng cũng hiểu được 4-way handshake thực sự trông như thế nào, với debugger gắn vào

> ⚠️ **WiFi-Forge không dạy được gì:** lớp vật lý —— RF, chọn ăng-ten, suy hao tín hiệu thực. Phần đó cuối cùng vẫn cần một card thật. Nhưng ở lớp giao thức, nơi 90% các cuộc tấn công thực tế diễn ra, mô phỏng và traffic thật về cơ bản không phân biệt được.

## Một lưu ý về hợp pháp và đạo đức

Loại dự án này bắt buộc phải nói thẳng: **chỉ sử dụng các kỹ thuật này trên các mạng bạn sở hữu hoặc có giấy phép kiểm thử bằng văn bản.** WiFi-Forge tồn tại *chính vì* lab mô phỏng loại bỏ mọi cám dỗ "thử một chút" với WiFi của quán cà phê bên cạnh. Học một cách an toàn —— đó là toàn bộ ý nghĩa.

---

- **Repo:** [github.com/blackhillsinfosec/WifiForge](https://github.com/blackhillsinfosec/WifiForge)
- **Dựa trên:** [mininet-wifi](https://github.com/intrig-unicamp/mininet-wifi)
- **Bảo trì bởi:** [Black Hills InfoSec](https://www.blackhillsinfosec.com/)

---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "shiyunapi" "ai-tools-footer" "Shiyunapi Claude API" >}}** — Proxy Anthropic Claude / OpenAI / DeepSeek API. Hầu hết AI tool ở trên (chatbot, code gen, translation, search, v.v.) cần LLM API key — proxy này cho access ổn định top model với ~30% giá chính thức.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

