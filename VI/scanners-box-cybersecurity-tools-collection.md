---
title: 'Scanners-Box: Bộ Sưu Tập 200+ Công Cụ An Ninh Mạng — Dành Cho Chuyên Gia Bảo
  Mật'
description: Khám phá Scanners-Box — bộ sưu tập 200+ công cụ an ninh mạng mã nguồn
  mở, bao gồm kiểm thử xâm nhập, quét lỗ hổng và nghiên cứu bảo mật.
date: 2026-05-15 04:20:25+09:00
lastmod: 2026-05-15 04:20:25+09:00
tech_stack:
- Docker
- Go
- JavaScript
- Python
- Rust
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: "236 KB"
file_md5: ''
download_url: https://github.com/luckybbjason1/Scanners-Box
backup_url: ''
github_repo: https://github.com/luckybbjason1/Scanners-Box
stars: 0
maintainer: "luckybbjason1"
last_maintained: "2023-09-21"
featureImage: ''
draft: false
aliases:
- /vi/posts/scanners-box-cybersecurity-tools-collection/
faqs:
  - q: 'Scanners-Box là gì?'
    a: 'Scanners-Box là một bộ sưu tập được tuyển chọn gồm hơn 200 công cụ an ninh mạng mã nguồn mở thuộc hơn 15 danh mục, bao gồm liệt kê tên miền phụ, SQL injection, fuzzing, quét cổng, social engineering và nhiều lĩnh vực khác. Ban đầu nó được tạo ra cho cộng đồng bảo mật Trung Quốc (t00ls) và hướng đến các kiểm thử viên thâm nhập cũng như nhà nghiên cứu bảo mật.'
  - q: 'Scanners-Box khuyến nghị những công cụ nào để kiểm thử SQL injection?'
    a: 'Khuyến nghị chính của nó là sqlmap, công cụ tự động phát hiện và khai thác SQL injection, hỗ trợ 6 loại cơ sở dữ liệu và bao gồm các tamper script để vượt qua WAF. Bộ sưu tập cũng liệt kê jsql-injection, SQLiScanner và NoSQLAttack.'
  - q: 'Sự khác biệt giữa Nmap và masscan trong quét cổng là gì?'
    a: 'Nmap là trình quét mạng tiêu chuẩn, cung cấp khả năng phát hiện dịch vụ/phiên bản và scripting (ví dụ các script dò lỗ hổng thông qua --script=vuln), trong khi masscan là trình quét cổng Internet nhanh nhất, có thể quét toàn bộ Internet trong khoảng 6 phút bằng cách truyền dữ liệu bất đồng bộ. masscan tương thích với Nmap, nên hai công cụ này thường được dùng cùng nhau.'
  - q: 'Scanners-Box bao gồm những công cụ fuzzing nào?'
    a: 'Nó liệt kê hơn 20 fuzzer, bao gồm AFL (American Fuzzy Lop), honggfuzz, syzkaller và libFuzzer. AFL hoạt động dựa trên độ phủ (coverage-guided) và đã phát hiện hàng nghìn lỗi trong phần mềm thực tế, còn syzkaller là một fuzzer dành cho nhân Linux đã tìm ra hơn 3000 lỗi nhân và được Google cùng Microsoft sử dụng.'
  - q: 'Các công cụ kiểm thử thâm nhập như những công cụ trong Scanners-Box có hợp pháp khi sử dụng không?'
    a: 'Những công cụ này chỉ hợp pháp khi dùng cho kiểm thử bảo mật được cấp phép; sử dụng chúng nhắm vào các hệ thống mà không có sự cho phép bằng văn bản rõ ràng là bất hợp pháp và phi đạo đức. Các luật liên quan bao gồm Đạo luật Gian lận và Lạm dụng Máy tính của Hoa Kỳ (CFAA), Đạo luật Lạm dụng Máy tính của Anh, Luật An ninh mạng của Trung Quốc và GDPR của EU, vì vậy hãy luôn xin ủy quyền bằng văn bản và xác định phạm vi trước khi kiểm thử.'
---
{</* resource-info */>}

## Scanners-Box là gì?

**Scanners-Box** là một bộ sưu tập được tuyển chọn gồm **200+ công cụ an ninh mạng mã nguồn mở** dành cho các chuyên gia bảo mật, kiểm thử viên xâm nhập và hacker đạo đức. Ban đầu được tạo cho cộng đồng bảo mật Trung Quốc (t00ls), nó bao gồm mọi khía cạnh của an ninh mạng từ trinh sát đến khai thác.

**GitHub**: https://github.com/luckybbjason1/Scanners-Box  
**Giấy phép**: Bộ sưu tập mã nguồn mở  
**Số lượng công cụ**: 200+  
**Danh mục**: 15+

---

## Tổng Quan Danh Mục Công Cụ

| Danh mục | Số lượng công cụ | Ví dụ |
|----------|-----------|----------|
| **Liệt kê tên miền phụ** | 15+ | subDomainsBrute, amass, subfinder, OneForAll |
| **Cơ sở dữ liệu & SQL Injection** | 10+ | sqlmap, jsql-injection, SQLiScanner, NoSQLAttack |
| **Công cụ Fuzzing** | 20+ | AFL, honggfuzz, syzkaller, libFuzzer |
| **Quét cổng & Nhận dạng** | 25+ | Nmap, masscan, whatweb, wafw00f |
| **Mật khẩu yếu & Rò rỉ thông tin** | 15+ | htpwdScan, BBScan, GitHack, truffleHog |
| **Quét thiết bị IoT** | 5+ | IoTSeeker, RouterSploit, routersploit |
| **Khai thác XSS** | 10+ | BruteXSS, XSS-Radar, XSSTracer, easyXssPayload |
| **Kỹ thuật xã hội** | 15+ | SET, gophish, evilginx2, blackeye |
| **Phát hiện WebShell** | 10+ | findWebshell, HaboMalHunter, PHP-Shell-Detector |
| **Kiểm toán mạng doanh nghiệp** | 5+ | theHarvester, xunfeng, LNScan |
| **Máy quét lỗ hổng** | 15+ | vulfocus, vulhub, VulApps, upload-labs |
| **Bảo mật không dây** | 5+ | fern-wifi-cracker, aircrack-ng |
| **Khám phá tài sản** | 5+ | linglong, H, nemo_go, NextScan |
| **Tình báo mối đe dọa** | 3+ | threat-intelligence, VirusTotal, ThreatBook |
| **Tài nguyên học tập** | 20+ | sec-wiki, FreeBuf, Web Hacking 101 |

---

## Phân Tích Sâu Các Công Cụ Nổi Bật

### 1. Liệt kê tên miền phụ

**OneForAll** — Công cụ thu thập tên miền phụ toàn diện nhất
- Tích hợp 20+ nguồn dữ liệu
- Hỗ trợ khóa API để có kết quả tốt hơn
- Xuất ra nhiều định dạng

**amass** — Liệt kê tên miền phụ bằng Go
- Nhanh và hiệu quả
- DNS, thu thập dữ liệu và minh bạch chứng chỉ
- Đầu ra trực quan hóa đồ thị

### 2. SQL Injection

**sqlmap** — Vua của các công cụ SQL injection
- Phát hiện và khai thác tự động
- Hỗ trợ 6 loại cơ sở dữ liệu
- Script can thiệp để vượt qua WAF

```bash
# Cách sử dụng cơ bản
sqlmap -u "http://target.com/page.php?id=1" --dbs

# Kết xuất bảng cụ thể
sqlmap -u "http://target.com/page.php?id=1" -D database -T users --dump
```

### 3. Khung Fuzzing

**AFL (American Fuzzy Lop)** — Fuzzing hướng dẫn bởi độ phủ
- Phát hiện lỗ hổng tự động
- Tạo các trường hợp thử nghiệm
- Tìm thấy hàng nghìn lỗi trong phần mềm thực tế

**syzkaller** — Fuzzer nhân Linux
- Tìm thấy 3000+ lỗi nhân Linux
- Được Google, Microsoft sử dụng
- Hỗ trợ nhiều hệ điều hành

### 4. Quét cổng

**Nmap** — Vua của máy quét mạng
```bash
# Quét cơ bản
nmap -sV -sC target.com

# Quét toàn bộ cổng với script
nmap -p- -sV --script=vuln target.com

# Quét tích cực
nmap -A target.com
```

**masscan** — Máy quét cổng Internet nhanh nhất
- Quét toàn bộ Internet trong 6 phút
- Tương thích với Nmap
- Truyền tải không đồng bộ

### 5. Bộ công cụ kỹ thuật xã hội

**SET (Social-Engineer Toolkit)** — Khung phishing hoàn chỉnh
- Sao chép website
- Spear-phishing qua email
- Thu thập thông tin xác thực
- Nhiều vector tấn công

**evilginx2** — Khung phishing vượt qua 2FA
- Tấn công man-in-the-middle
- Bắt cookie phiên
- Vượt qua xác thực hai yếu tố

---

## Tài Nguyên Học Tập Bảo Mật

### Dành cho người mới bắt đầu
- **sec-wiki** — Bách khoa toàn thư bảo mật
- **FreeBuf** — Tin tức hacker và geek
- **Web Hacking 101** — Cơ bản về bảo mật web
- **Sách hướng dẫn kiểm thử xâm nhập Web Kali Linux**

### Dành cho người trung cấp
- **Hướng dẫn thực chiến Burpsuite** — Kiểm thử xâm nhập web
- **API-Security-Checklist** — Thực hành tốt nhất về bảo mật API
- **Web-Security-Learning** — Bảo mật web toàn diện
- **Ghi chú thực chiến ứng phó khẩn cấp** — Ứng phó khẩn cấp

### Chủ đề nâng cao
- **Hướng dẫn phát triển khai thác Linux**
- **Kiểm thử xâm nhập Android**
- **Vấn đề bảo mật Web Node.js**
- **Loạt bài về bảo mật Python**

---

## Mục tiêu dễ bị tổn thương để luyện tập

| Nền tảng | Mô tả | Liên kết |
|----------|-------------|------|
| **vulfocus** | Nền tảng lỗ hổng dựa trên Docker | GitHub |
| **vulhub** | Môi trường dễ bị tổn thương được xây dựng sẵn | GitHub |
| **VulApps** | Bộ sưu tập ứng dụng dễ bị tổn thương | GitHub |
| **upload-labs** | Luyện tập lỗ hổng tải lên tệp | GitHub |
| **bWAPP** | Ứng dụng Web có lỗi | SourceForge |
| **DVWA** | Ứng dụng Web dễ bị tổn thương | GitHub |
| **WebGoat** | Luyện tập bảo mật Web OWASP | GitHub |

---

## Tiết Lộ Có Trách Nhiệm

> **⚠️ Cảnh báo**: Tất cả các công cụ được liệt kê ở đây chỉ dành cho kiểm thử bảo mật được ủy quyền. Việc sử dụng các công cụ này chống lại các hệ thống không có sự cho phép rõ ràng là bất hợp pháp và phi đạo đức.

### Khung pháp lý
- **CFAA** (Đạo luật gian lận và lạm dụng máy tính) — Hoa Kỳ
- **Đạo luật lạm dụng máy tính** — Vương quốc Anh
- **Luật an ninh mạng** — Trung Quốc
- **GDPR** — Bảo vệ dữ liệu EU

### Thực hành tốt nhất
1. Luôn nhận được sự cho phép bằng văn bản
2. Xác định rõ ràng phạm vi
3. Tôn trọng giờ làm việc
4. Báo cáo phát hiện kịp thời
5. Xóa dữ liệu sau khi kiểm thử

---

## Hướng Dẫn Chọn Công Cụ

### Kiểm thử ứng dụng web
```
Trinh sát: amass, subfinder, theHarvester
Quét: Nmap, masscan, whatweb
Lỗ hổng: sqlmap, máy quét XSS, dirsearch
Khai thác: Burp Suite, script tùy chỉnh
Báo cáo: Dradis, Faraday
```

### Kiểm thử xâm nhập mạng
```
Khám phá: Nmap, masscan, nbtscan
Liệt kê: enum4linux, snmp-check
Lỗ hổng: OpenVAS, Nessus
Khai thác: Metasploit, Cobalt Strike
Hậu khai thác: PowerShell Empire, Mimikatz
```

### Hoạt động Red Team
```
Truy cập ban đầu: SET, gophish, evilginx2
Duy trì: Implant tùy chỉnh, tác vụ đã lên lịch
Leo thang đặc quyền: PowerUp, BeRoot
Di chuyển ngang: Pass-the-hash, Kerberoasting
Rò rỉ dữ liệu: Đường hầm DNS, HTTPS C2
```

---

## Bài Viết Liên Quan

- [Agent Reach: Truy cập Internet AI Agent](/vi/resources/llm-frameworks/agent-reach-ai-agent-internet-access/) — Tự động hóa bảo mật dựa trên AI
- [Free Claude Code: Mã hóa AI mã nguồn mở](/vi/resources/ai-tools/free-claude-code-open-source-proxy/) — Thực hành mã hóa an toàn

---

*Tuyên bố miễn trừ: Bài viết này chỉ dành cho mục đích giáo dục. Tất cả các công cụ nên được sử dụng có trách nhiệm và chỉ trên các hệ thống bạn sở hữu hoặc có sự cho phép rõ ràng để kiểm thử. Tác giả và dibi8.com không chịu trách nhiệm về bất kỳ việc lạm dụng thông tin được cung cấp nào.*

---

## Công Cụ Đề Xuất

Cho developer xây dựng hoặc triển khai công cụ AI mã nguồn mở:

- **{{< aff "digitalocean" "footer-cta-legacy" "DigitalOcean" >}}** — $200 tín dụng miễn phí cho người dùng mới, 14+ region toàn cầu, droplet GPU/CPU một-cú-click cho AI workload.
- **{{< aff "htstack" "category-footer" "HTStack" >}}** — Hong Kong VPS, cùng IDC host dibi8.com. Self-host security scanner trên VPS riêng, low-latency Asia coverage, không shared-tenant noise.
- **{{< aff "hostinger" "footer-cta-legacy" "Hostinger" >}}** — Lựa chọn VPS giá tốt cho thị trường Việt Nam.

*Affiliate link — không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

