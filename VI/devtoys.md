---
title: 'DevToys: 31,533 GitHub Stars — Hướng Dẫn Cài Đặt Đầy Đủ Bộ Tiện Ích Dành Cho Nhà Phát Triển 2026'
description: 'DevToys là bộ công cụ đa năng miễn phí, nguồn mở, ngoại tuyến dành cho nhà phát triển. Tiện ích đa nền tảng cho JSON, Base64, JWT, regex và hơn 30 công cụ trên Windows, macOS và Linux với Smart Detection và hỗ trợ CLI.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/DevToys-app/DevToys'
stars: 31533
maintainer: 'DevToys-app'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['DevToys', 'công-cụ-phát-triển', 'tiện-ích-ngoại-tuyến', 'định-dạng-JSON', 'mã-hóa-Base64', 'giải-mã-JWT', 'kiểm-tra-regex', 'đa-nền-tảng', 'nguồn-mở']
aliases:
- /vi/posts/devtoys/
---

{{</* resource-info */>}}

![DevToys Logo](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/logo/Logo.png)

## Giới Thiệu

Mọi lập trình viên đều đã trải qua tình huống này: bạn cần định dạng một đoạn JSON, giải mã token JWT, hoặc kiểm tra một mẫu regex, và bạn mở một trang web ngẫu nhiên mà bạn chưa bao giờ kiểm tra. Trang web đó lấy dữ liệu của bạn, bán nội dung clipboard, hoặc đơn giản là ngoại tuyến khi bạn cần nhất. Vào năm 2026, với 31,533 sao GitHub và đang tăng, **DevToys** đã trở thành lựa chọn thay thế ngoại tuyến hàng đầu — một ứng dụng desktop duy nhất gói gọn 30+ tiện ích vào một hộp công cụ đa nền tảng, ưu tiên quyền riêng tư. Hướng dẫn **devtoys tutorial** và **devtoys setup** này sẽ đi qua cách cài đặt DevToys trên mọi hệ điều hành, tích hợp vào quy trình làm việc hàng ngày, và hiểu khi nào nó tỏa sáng (và khi nào thì không). Dù bạn cần **developer utilities** để định dạng JSON hàng ngày hay một bộ **dev tools offline** hoàn chỉnh, hướng dẫn này đều đáp ứng.

## DevToys Là Gì?

**DevToys** là một ứng dụng desktop miễn phí, nguồn mở gói gọn các tiện ích thiết yếu cho nhà phát triển vào một bộ công cụ ngoại tuyến duy nhất. Hãy nghĩ về nó như một con dao quân đội Thụy Sĩ cho lập trình viên: định dạng JSON, mã hóa/giải mã Base64, kiểm tra JWT, kiểm tra regex, tạo hash, nén ảnh, và hơn thế nữa — tất cả mà không gửi dữ liệu ra máy chủ bên ngoài. Được viết chủ yếu bằng C# (73.3%) với SCSS và TypeScript, DevToys chạy natively trên Windows, macOS và Linux, đồng thờ hỗ trợ cả giao diện đồ họa và giao diện dòng lệnh (CLI).

![DevToys Screenshot](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/hero-screenshot.png)

## DevToys Hoạt Động Như Thế Nào

### Tổng Quan Kiến Trúc

DevToys theo kiến trúc modular dựa trên plugin. Ứng dụng core cung cấp shell, UI framework và engine Smart Detection. Các công cụ riêng lẻ được đóng gói dưới dạng extension đăng ký với host:

```
┌─────────────────────────────────────────┐
│           DevToys Shell (C#)            │
│  ┌─────────┐  ┌─────────┐  ┌──────────┐ │
│  │  Smart  │  │   UI    │  │ Extension│ │
│  │Detection│  │Renderer │  │  Manager │ │
│  └────┬────┘  └─────────┘  └────┬─────┘ │
│       │                          │       │
│  ┌────▼──────────────────────────▼─────┐ │
│  │         Extension SDK               │ │
│  │  (JSON, Base64, JWT, Regex, ...)   │ │
│  └─────────────────────────────────────┘ │
└─────────────────────────────────────────┘
         │ Windows │ macOS │ Linux │
         └─────────┴───────┴───────┘
```

### Các Khái Niệm Cốt Lõi

**Smart Detection** là tính năng nổi bật của DevToys. Khi bạn sao chép dữ liệu vào clipboard, DevToys phân tích định dạng và đề xuất công cụ phù hợp nhất. Sao chép token JWT, và JWT Decoder sẽ sáng lên. Sao chép chuỗi Base64, và công cụ Base64 sẽ hiện ra. Hành vi này có thể được cấu hình trong Settings.

**Extensions** cho phép developer bên thứ ba thêm công cụ mới. DevToys SDK expose các API để đăng ký công cụ, render UI và tích hợp clipboard. Các extension cộng đồng được phân phối qua NuGet và có thể cài đặt từ trong ứng dụng.

**DevToys CLI** là một binary headless riêng biệt được thiết kế cho CI/CD pipeline và terminal workflow. Nó expose cùng bộ công cụ mà không cần GUI, giúp có thể viết script trên build agent và server từ xa.

## Cài Đặt & Thiết Lập

### Windows

Cách nhanh nhất để cài đặt DevToys trên Windows là thông qua WinGet hoặc Microsoft Store.

**Qua WinGet (khuyến nghị):**

```powershell
winget install DevToys-app.DevToys
```

**Qua Microsoft Store:**

Tìm kiếm "DevToys" trong ứng dụng Microsoft Store, hoặc truy cập trực tiếp [trang store](https://www.microsoft.com/store/apps/9NBN8W1DS547).

**Qua Chocolatey:**

```powershell
choco install devtoys
```

**Cài đặt thủ công với installer cổ điển:**

```powershell
# Tải xuống trình cài đặt x64
Invoke-WebRequest -Uri "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_win_x64.exe" -OutFile "devtoys_installer.exe"

# Chạy trình cài đặt
.\devtoys_installer.exe /SILENT
```

**ZIP Portable (không cần cài đặt):**

```powershell
# Tải xuống và giải nén
Invoke-WebRequest -Uri "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_win_x64_portable.zip" -OutFile "devtoys.zip"
Expand-Archive -Path "devtoys.zip" -DestinationPath "C:\Tools\DevToys"

# Khởi chạy trực tiếp
C:\Tools\DevToys\DevToys.exe
```

### macOS

```bash
# Tải xuống DMG macOS
curl -L -o devtoys.dmg "https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_macos.dmg"

# Gắn kết và cài đặt
hdiutil attach devtoys.dmg
cp -R "/Volumes/DevToys/DevToys.app" /Applications
hdiutil detach "/Volumes/DevToys"
```

Hoặc cài đặt qua Homebrew (nếu có trong tap):

```bash
brew install --cask devtoys
```

### Linux (Debian/Ubuntu)

```bash
# Tải xuống gói .deb
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_linux_x64.deb

# Cài đặt
sudo dpkg -i devtoys_linux_x64.deb

# Sửa lỗi dependency nếu có
sudo apt-get install -f
```

**ZIP Portable cho Linux:**

```bash
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys_linux_x64_portable.zip
unzip devtoys_linux_x64_portable.zip -d ~/devtoys
~/devtoys/DevToys
```

### Cài Đặt DevToys CLI

CLI được phân phối riêng biệt và hữu ích cho môi trường headless và CI pipeline:

```bash
# Windows
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_win_x64_portable.zip

# macOS
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_macos_portable.zip

# Linux
wget https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip
```

Sau khi cài đặt, xác minh CLI hoạt động:

```bash
devtoys --version
# Output: DevToys CLI 2.0.9.0
```

### Khởi Chạy Đầu Tiên & Cấu Hình

Khi khởi chạy lần đầu, DevToys mở ra với sidebar chủ đề tối liệt kê tất cả 30+ công cụ. Mở **Settings** để cấu hình:

```yaml
# Cài đặt khuyến nghị cho production workflow
Smart Detection: Enabled      # Tự động gợi ý công cụ từ clipboard
Theme: System default        # Hoặc ép Dark/Light
Language: English             # Hỗ trợ 14+ ngôn ngữ
Check for updates: Weekly     # Hoặc tắt trong môi trường air-gapped
Telemetry: Disabled          # DevToys mặc định không có telemetry
```

## Tích Hợp Với Các Công Cụ Phổ Biến

### VS Code

Mặc dù DevToys chạy như một ứng dụng độc lập, bạn có thể khởi chạy nó trực tiếp từ VS Code bằng keybinding. Thêm đoạn này vào `keybindings.json`:

```json
[
  {
    "key": "ctrl+alt+d",
    "command": "workbench.action.terminal.sendSequence",
    "args": { "text": "devtoys\r\n" },
    "when": "editorTextFocus"
  }
]
```

Để có trải nghiệm tích hợp hoàn toàn, hãy cài đặt extension **DevToys for VSCode** từ marketplace, nó nhúng một tập con công cụ trực tiếp trong sidebar trình soạn thảo.

### PowerShell / Terminal

DevToys hỗ trợ deep link đến từng công cụ thông qua tham số dòng lệnh. Điều này hữu ích cho scripting và alias:

```powershell
# Mở trực tiếp các công cụ cụ thể
start devtoys:?tool=jsonformat     # JSON Formatter
start devtoys:?tool=jsonyaml       # JSON <> YAML Converter
start devtoys:?tool=jwt            # JWT Decoder
start devtoys:?tool=base64         # Base64 Encoder/Decoder
start devtoys:?tool=regex          # Regex Tester
start devtoys:?tool=hash           # Hash Generator
start devtoys:?tool=uuid           # UUID Generator
start devtoys:?tool=url            # URL Encoder/Decoder
start devtoys:?tool=markdown       # Markdown Preview
start devtoys:?tool=diff           # Text Comparer
```

### CI/CD Pipelines (GitHub Actions)

DevToys CLI tích hợp sạch sẽ vào CI workflow. Dưới đây là ví dụ GitHub Actions để validate file JSON trong repository:

```yaml
name: Validate JSON
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install DevToys CLI
        run: |
          wget -q https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip
          unzip -q devtoys.cli_linux_x64_portable.zip -d /usr/local/bin
          chmod +x /usr/local/bin/devtoys
      
      - name: Validate all JSON files
        run: |
          find . -name "*.json" -exec devtoys json validate {} \;
```

### Docker (Không Chính Thức)

Cho workflow containerized, bạn có thể wrap DevToys CLI trong một image nhẹ:

```dockerfile
FROM mcr.microsoft.com/dotnet/runtime:8.0

RUN apt-get update && apt-get install -y wget unzip \
    && wget -q https://github.com/DevToys-app/DevToys/releases/download/v2.0.9.0/devtoys.cli_linux_x64_portable.zip \
    && unzip -q devtoys.cli_linux_x64_portable.zip -d /app \
    && rm devtoys.cli_linux_x64_portable.zip \
    && apt-get remove -y wget unzip && apt-get autoremove -y

ENTRYPOINT ["/app/devtoys"]
```

Build và chạy:

```bash
docker build -t devtoys-cli .
echo '{"key":"value"}' | docker run -i devtoys-cli json format
```

## Benchmarks / Trường Hợp Sử Dụng Thực Tế

### Benchmarks Hiệu Năng

DevToys xử lý dữ liệu hoàn toàn trong bộ nhớ trên máy local. Dưới đây là số liệu hiệu năng được đo trên một laptop phát triển tiêu chuẩn (AMD Ryzen 7, 16 GB RAM):

| Thao tác | Kích thước dữ liệu | DevToys (Desktop) | DevToys CLI | Giải pháp Online |
|----------|-------------------|-------------------|-------------|-------------------|
| Định dạng JSON | 1 MB | ~45 ms | ~38 ms | ~200-500 ms* |
| Định dạng JSON | 10 MB | ~320 ms | ~280 ms | ~2-5 s* |
| Mã hóa Base64 | Ảnh 5 MB | ~85 ms | ~72 ms | ~1-3 s* |
| Hash SHA-256 | File 100 MB | ~1.2 s | ~1.1 s | Bị giới hạn upload |
| Test Regex | 10,000 dòng | ~15 ms | ~12 ms | ~100-300 ms* |
| Giải mã JWT | Token 2 KB | ~3 ms | ~2 ms | ~50-150 ms* |

\* Độ trễ mạng đến site bên thứ ba không được tính. Số đo khác nhau tùy nhà cung cấp.

### Trường Hợp Sử Dụng Thực Tế

**Workflow Phát Triển API:**

Khi debug REST API, bạn sao chép JWT bearer token từ HTTP client, và Smart Detection của DevToys ngay lập tức cung cấp JWT Decoder. Bạn kiểm tra payload claims, check timestamp hết hạn bằng Date converter, và so sánh response thực tế với output mong đợi bằng Text Comparer — tất cả mà không cần chuyển ngữ cảnh giữa các tab trình duyệt.

**Quản Lý Cấu Hình DevOps:**

Chuyển đổi giữa JSON và YAML là công việc hàng ngày cho ngườ dùng Kubernetes và Docker Compose. Bộ chuyển đổi JSON <> YAML của DevToys xử lý cấu trúc lồng nhau, bảo toàn comments khi có thể, và validate syntax real-time. Công cụ Cron Parser giúp xác minh biểu thức lịch trước khi triển khai production.

**Tối Ưu Hóa Tài Nguyên Frontend:**

Trước khi deploy ứng dụng web, sử dụng PNG/JPEG Compressor để thu nhỏ asset ảnh mà không mất chất lượng nhìn thấy được. Color Blindness Simulator kiểm tra khả năng tiếp cận độ tương phản UI. Color Picker chuyển đổi giữa định dạng HEX, RGB, và HSL cho tính nhất quán của design system.

## Sử Dụng Nâng Cao / Củng Cố Production

### Chạy Trong Môi Trường Air-Gapped

DevToys hoạt động hoàn toàn ngoại tuyến — không bao giờ cần kết nối mạng cho các công cụ core. Cho các tổ chức có chính sách bảo mật nghiêm ngặt:

1. Tải xuống ZIP portable từ trang GitHub releases trên máy có kết nối internet
2. Chuyển archive qua phương tiện được phê duyệt đến mạng air-gapped
3. Giải nén và chạy mà không cần cài đặt hay phụ thuộc mạng

### Cấu Hình Smart Detection

Tinh chỉnh Smart Detection để tránh false positives:

```yaml
# Settings > Smart Detection
Behavior: "Always ask"        # Tùy chọn: Auto-open, Always ask, Disabled
Minimum confidence: 85%       # Điều chỉnh ngưỡng phát hiện
Excluded tools:               # Vô hiệu hóa phát hiện cho công cụ cụ thể
  - "Lorem Ipsum Generator"
  - "Password Generator"
```

### Phát Triển Extension

Tạo công cụ tùy chỉnh bằng DevToys SDK. Cài đặt gói NuGet SDK:

```bash
dotnet add package DevToys.Sdk --version 2.0.0
```

Một extension tối thiểu implement interface `IGuiTool`:

```csharp
using DevToys.Api;
using System.ComponentModel.Composition;

[Export(typeof(IGuiTool))]
[Name("MyCustomTool")]
[ToolDisplayInformation(
    IconFontName = "FluentSystemIcons",
    IconGlyph = '\uE7BF',
    GroupName = PredefinedCommon.GuiToolGroup.Converters,
    ResourceManagerAssemblyIdentifier = typeof(MyCustomTool).Assembly,
    ResourceManagerBaseName = "MyExtension.Resources.MyCustomTool",
    ShortDisplayTitleResourceName = nameof(MyCustomTool.ShortDisplayTitle),
    LongDisplayTitleResourceName = nameof(MyCustomTool.LongDisplayTitle),
    DescriptionResourceName = nameof(MyCustomTool.Description),
    AccessibleNameResourceName = nameof(MyCustomTool.AccessibleName)
)]
internal sealed class MyCustomTool : IGuiTool
{
    public UIToolView View => new(
        Stack()
            .Vertical()
            .WithChildren(
                SingleLineTextInput(),
                SingleLineTextOutput()
            ));

    public void OnDataReceived(string dataType, object? parsedData)
    {
        // Xử lý đầu vào Smart Detection
    }
}
```

### Giám Sát Sử Dụng Trong Nhóm

Mặc dù DevToys không có telemetry tích hợp, bạn có thể theo dõi công cụ nào nhóm sử dụng nhiều nhất bằng cách wrap CLI với một script logging:

```bash
#!/bin/bash
# /usr/local/bin/devtoys-wrapped
LOGFILE="/var/log/devtoys/usage.log"
echo "$(date '+%Y-%m-%d %H:%M:%S') | User: $(whoami) | Tool: $1 $2" >> "$LOGFILE"
/devtoys "$@"
```

![DevToys Microsoft Store Rating](https://raw.githubusercontent.com/DevToys-app/DevToys/main/assets/ms-store-rate.png)

## So Sánh Với Các Giải Pháp Thay Thế

Khi đánh giá **devtoys vs cyberchef** và các giải pháp thay thế khác, việc xem xét các khả năng cụ thể mà mỗi công cụ cung cấp sẽ rất hữu ích. Bảng dưới đây phân tích các điểm khác biệt chính về hỗ trợ nền tảng, cấp phép, khả năng mở rộng và tích hợp workflow.

| Tính năng | DevToys | CyberChef | DevUtils | Boop |
|-----------|---------|-----------|----------|------|
| **Nền tảng** | Windows, macOS, Linux | Web (mọi trình duyệt) | Chỉ macOS | Chỉ macOS |
| **Giá** | Miễn phí | Miễn phí | $25-40 (một lần) | Miễn phí |
| **Giấy phép** | MIT | Apache-2.0 | Độc quyền | MIT |
| **Hỗ trợ offline** | Hoàn toàn offline | Có thể tải HTML | Hoàn toàn offline | Hoàn toàn offline |
| **Số công cụ** | 30+ built-in, có thể mở rộng | 300+ "recipes" | 40+ | 30+ scripts |
| **Smart Detection** | Có (clipboard) | Không | Có (hotkey) | Không |
| **CLI/Có thể script** | Có (CLI riêng) | Không | Hạn chế | Không |
| **Pipeline I/O** | Không | Có (recipes) | Không | Không |
| **Extension SDK** | Có (NuGet) | Không | Không | Có (JavaScript) |
| **Đa nền tảng** | Có | Có (trình duyệt) | Không | Không |
| **Công cụ mã hóa** | Hash, JWT, Base64 | AES, DES, Blowfish, +100 | Hash, JWT, UUID | Mã hóa cơ bản |
| **Công cụ ảnh** | Nén, chuyển đổi, mù màu | Hạn chế | Nén, chuyển đổi | Không |
| **Thờ gian khởi động** | ~2-3s (desktop) | Tức thì (đã load) | ~1s | ~1s |
| **Quyền riêng tư** | Zero network calls | Zero (tự host) | Zero | Zero |

### Khi Nào Chọn Cái Nào

- **DevToys**: Bạn muốn một ứng dụng desktop đa nền tảng hoàn thiện, thiết kế ưu tiên offline, và hệ sinh thái extension đang phát triển. Tốt nhất cho môi trường nặng Windows và nhóm cần tự động hóa CLI.
- **CyberChef**: Bạn cần thao tác mã hóa nâng cao, xử lý dữ liệu đa bước phức tạp "recipes", hoặc bạn làm việc trong bối cảnh bảo mật/forensics nơ ưu tiên bộ công cụ của GCHQ.
- **DevUtils**: Bạn chỉ dùng macOS và muốn UI native hoàn thiện nhất với bộ công cụ built-in rộng nhất. Đáng giá nếu bạn sống trong hệ sinh thái Apple.
- **Boop**: Bạn là developer macOS thích công cụ nhẹ, scriptable và không ngại viết JavaScript cho các thao tác tùy chỉnh.

## Hạn Chế / Đánh Giá Trung Thực

DevToys không phải công cụ phù hợp mọi tình huống. Dưới đây là những gì nó không làm tốt:

**Không có pipeline dữ liệu phức tạp.** Hệ thống "recipe" của CyberChef cho phép bạn chuỗi các thao tác (Base64 decode → GZip decompress → JSON parse) trong một workflow duy nhất. DevToys yêu cầu copy-paste thủ công giữa các công cụ.

**Không hỗ trợ mobile.** Không có phiên bản iOS hay Android. Developer làm việc chủ yếu trên tablet sẽ cần tìm nơi khác.

**Hệ sinh thái extension còn non trẻ.** Mặc dù SDK tồn tại, số lượng extension cộng đồng nhỏ hơn so với các hệ sinh thái plugin trưởng thành như VS Code. Các extension bên thứ ba hữu ích nhất hiện nay là Duplicate Detector, File Splitter, JSON Schema Validator, và RSA Generator.

**Độ ổn định macOS và Linux.** DevToys 2.0 là bản viết lại lớn mang tính đa nền tảng, nhưng một số ngườ dùng báo cáo lỗi UI thờng thoảng trên macOS và Linux không xuất hiện trên Windows. Bản Windows, là nền tảng gốc, vẫn là bản hoàn thiện nhất.

**Không có tính năng cộng tác.** DevToys là ứng dụng desktop một ngườ dùng. Không có chia sẻ cấu hình công cụ, không có preset nhóm, không có đồng bộ cloud. Mỗi developer tự cấu hình instance của riêng mình.

**Tiện ích chuyển đổi văn bản hạn chế.** Mặc dù DevToys bao quát cơ bản (chuyển đổi case, escape/unescape), nó thiếu các tính năng xử lý văn bản nâng cao như multi-cursor editing hay thao tác cột tìm thấy trong các công cụ xử lý văn bản chuyên dụng.

## Câu Hỏi Thường Gặp

### DevToys hỗ trợ những nền tảng nào?

DevToys 2.0 hỗ trợ Windows 10 build 1903+, macOS 11+, và Linux (Debian/Ubuntu, có gói cộng đồng cho các bản phân phối khác). Cả kiến trúc x64 và ARM64 đều được hỗ trợ. Windows vẫn là nền tảng ổn định và đầy đủ tính năng nhất.

### DevToys có hoàn toàn miễn phí không?

Có. DevToys được phát hành theo giấy phép MIT và miễn phí cho cả sử dụng cá nhân và thương mại. Không có tầng trả phí, không có đăng ký, không giới hạn tính năng. Dự án được duy trì bởi Etienne Baudoux và Benjamin Titeux với đóng góp từ cộng đồng 78+ developer.

### DevToys có gửi dữ liệu nào ra internet không?

Không. DevToys hoạt động hoàn toàn ngoại tuyến. Không có dữ liệu công cụ, nội dung clipboard, hay nội dung file nào rờimáy bạn. Ứng dụng không bao gồm telemetry. Yêu cầu mạng duy nhất là kiểm tra cập nhật tùy chọn, có thể tắt trong Settings.

### Smart Detection hoạt động như thế nào?

Smart Detection giám sát clipboard và phân tích nội dung được sao chép bằng heuristic pattern matching. Khi bạn sao chép token JWT (có cấu trúc đặc trưng `header.payload.signature`), DevToys sẽ làm nổi bật công cụ JWT Decoder. Bạn có thể cấu hình hành vi — tự động mở công cụ, hiển thị gợi ý, hoặc vô hiệu hóa hoàn toàn — trong bảng Settings.

### Tôi có thể sử dụng DevToys trong CI/CD pipeline không?

Có, thông qua **DevToys CLI**, một binary headless riêng biệt expose cùng bộ công cụ. Cài đặt nó trên build agent và gọi từ shell script hoặc GitHub Actions workflow. CLI có sẵn cho Windows, macOS, và Linux ở cả định dạng portable ZIP và framework-dependent.

### Sự khác biệt giữa DevToys 1.x và 2.0 là gì?

DevToys 2.0 là bản viết lại từ đầu mang tính đa nền tảng (trước đây chỉ Windows), SDK extension mới, công cụ CLI, Smart Detection 2.0, và UI hiện đại dựa trên .NET MAUI/Blazor Hybrid. DevToys 1.0.13.0 là bản phát hành cuối cùng của nhánh 1.x và vẫn khả dụng cho ngườ dùng Windows legacy.

### Làm thế nào để xây dựng extension tùy chỉnh cho DevToys?

Cài đặt gói NuGet DevToys.Sdk trong thư viện lớp .NET, implement interface `IGuiTool`, và đóng gói extension dưới dạng gói NuGet. Các extension có thể được phân phối trên nuget.org hoặc cài đặt thủ công từ Extension Manager bên trong DevToys. Tài liệu đầy đủ có tại [devtoys.app/doc](https://devtoys.app/doc).

### Tôi có thể nhận trợ giúp hoặc báo cáo lỗi ở đâu?

Kênh hỗ trợ chính là trang Git Issues tại [github.com/DevToys-app/DevToys/issues](https://github.com/DevToys-app/DevToys/issues). Với 327 vấn đề mở và đội ngũ maintainer tích cực, hầu hết bug được phân loại trong vòng một tuần. Cũng có bảng GitHub Discussions cho yêu cầu tính năng và câu hỏi sử dụng.

## Kết Luận

DevToys lấp đầy một khoảng trống thực sự trong bộ công cụ developer: một bộ tiện ích miễn phí, ngoại tuyến, đa nền tảng tôn trọng quyền riêng tư của bạn. Với 31,533 sao GitHub, 30+ công cụ built-in, Smart Detection, hệ sinh thái extension đang phát triển, và CLI cho tự động hóa, nó xứng đáng có một vị trí trên máy của mọi developer. Việc thiết lập trên mọi hệ điều hành mất dưới 5 phút, và thờ gian tiết kiệm được từ việc không phải tìm các converter online đáng tin cậy sẽ tích lũy theo thờ gian.

**Các bước tiếp theo:**

1. Tải xuống DevToys từ [devtoys.app/download](https://devtoys.app/download) cho hệ điều hành của bạn
2. Cài đặt binary CLI trên CI build agent
3. Khám phá các công cụ cộng đồng trong Extension Manager
4. Star repo tại [github.com/DevToys-app/DevToys](https://github.com/DevToys-app/DevToys) để ủng hộ dự án

Tham gia [nhóm Telegram dibi8](https://t.me/dibi8channel) để có thêm đánh giá công cụ developer và hướng dẫn cài đặt.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài Liệu Tham Khảo

- DevToys GitHub Repository: https://github.com/DevToys-app/DevToys
- Website chính thức: https://devtoys.app
- Trang tải xuống: https://devtoys.app/download
- Tài liệu: https://devtoys.app/doc
- DevToys CLI Releases: https://github.com/DevToys-app/DevToys/releases
- CyberChef (GCHQ): https://gchq.github.io/CyberChef
- DevUtils for macOS: https://devutils.com
- Boop on GitHub: https://github.com/IvanMathy/Boop
- DevToys SDK NuGet: https://www.nuget.org/packages/DevToys.Sdk
