---
title: 'act: 70,410 GitHub Stars — Chạy GitHub Actions Local, Hướng Dẫn CI/CD Production 2026'
description: 'act (nektos/act) là công cụ CLI chạy GitHub Actions workflow local bằng Docker container. Tương thích với Docker, GitHub Actions, Go và VS Code. Bao gồm cài đặt, thiết lập, quản lý secrets, runner images và production hardening.'
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
github_repo: 'https://github.com/nektos/act'
stars: 70410
maintainer: 'nektos'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['act', 'github-actions', 'ci-cd', 'docker', 'phat-trien-local', 'devops', 'kiem-tra', 'tu-dong-hoa']
aliases:
- /vi/posts/act/
---

{{</* resource-info */>}}

![act logo](https://raw.githubusercontent.com/nektos/act/master/img/act-logo.png)

## Giới thiệu

Mọi lập trình viên từng viết workflow GitHub Actions đều biết nỗi đau này: bạn sửa đổi `.github/workflows/ci.yml`, commit, push, đợi 3-5 phút để runner thực thi, rồi chứng kiến nó thất bại ở bước 4 vì thiếu biến môi trường hoặc lỗi đánh máy trong lệnh shell. Vòng phản hồi chậm, tiêu tốn phút GitHub Actions của bạn, và làm ô nhiễm lịch sử commit bằng những thông điệp "fix CI". Năm 2026, khi pipeline CI/CD kiểm soát mọi lần triển khai, sự kém hiệu quả này không còn được chấp nhận. [act](https://github.com/nektos/act), công cụ dòng lệnh được Casey Lee và tổ chức nektos phát triển bằng Go, giải quyết vấn đề này bằng cách chạy workflow GitHub Actions local trong container Docker — tái tạo chính xác các biến môi trường, bố cục filesystem và hành vi runner của GitHub. Với 70,410 sao trên GitHub và hệ sinh thái tích hợp phát triển mạnh, act đã trở thành công cụ tiêu chuẩn cho phát triển CI/CD local.

## act là gì?

act là công cụ CLI đọc file workflow GitHub Actions từ `.github/workflows/` và thực thi chúng local bằng container Docker, tái tạo chính xác môi trường runtime GitHub Actions. Tutorial này đi qua thiết lập act đầy đủ — từ cài đặt đến production hardening — để bạn có thể xác thực mọi thay đổi workflow trước khi push lên GitHub.

## act hoạt động như thế nào

act hoạt động như một trình mô phỏng runner GitHub Actions local. Khi bạn chạy `act` trong một repository, nó thực hiện các bước sau:

1. **Khám phá Workflow**: Quét `.github/workflows/` để tìm file workflow YAML
2. **Phân tích Sự kiện**: Xác định workflow nào cần kích hoạt dựa trên loại sự kiện (push, pull_request, v.v.)
3. **Giải quyết Phụ thuộc**: Xây dựng đồ thị không chu trình có hướng (DAG) của các phụ thuộc job
4. **Chuẩn bị Image**: Pull hoặc build image Docker cho các runner được chỉ định
5. **Thực thi Container**: Chạy từng bước trong container Docker với biến môi trường và mount filesystem tương thích với GitHub
6. **Thu thập Artifact**: Thu thập output, artifact và log

![act architecture diagram](https://raw.githubusercontent.com/nektos/act/master/img/act-quickstart-2.gif)

Công cụ sử dụng Docker Engine API trực tiếp, nghĩa là mọi runtime container tương thích với Docker đều hoạt động như backend. Các biến môi trường (`GITHUB_SHA`, `GITHUB_REF`, `GITHUB_REPOSITORY`, v.v.) và cấu trúc filesystem (`/github/workspace`, `/github/event.json`, `/github/home`) được cấu hình để khớp với những gì GitHub cung cấp trên runner được lưu trữ.

### Kích thước Image Runner

act cung cấp ba cấp image để cân bằng giữa độ chính xác và dung lượng đĩa:

| Kích thước Image | Tải xuống | Dung lượng Đĩa | Trường hợp sử dụng |
|---|---|---|---|
| Micro | ~50 MB | <200 MB | Chỉ Node.js, kiểm thử smoke nhanh |
| Medium | ~200 MB | ~500 MB | Bao gồm công cụ thiết yếu, phù hợp hầu hết workflow |
| Large | ~5 GB | ~18-75 GB | Parity đầy đủ với GitHub runner, toolchain đầy đủ |

Image Medium mặc định (`catthehacker/ubuntu:act-latest`) bao gồm Python, Node.js, Go, Ruby, Java, .NET và các công cụ build thông dụng. Image Large (`catthehacker/ubuntu:full-*`) là bản dump filesystem của runner được lưu trữ thực tế trên GitHub và cung cấp độ parity gần nhất.

## Cài đặt & Thiết lập

act cài đặt trong vòng dưới 60 giây trên mọi nền tảng có Docker. Chọn phương pháp của bạn:

### macOS (Homebrew)

```bash
# Cài đặt act qua Homebrew
brew install act

# Xác minh cài đặt
act --version
# act version 0.2.88
```

### Linux (Bash Script)

```bash
# Trình cài đặt một dòng (yêu cầu bash và curl)
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Phương án khác: tải binary pre-built
wget https://github.com/nektos/act/releases/download/v0.2.88/act_Linux_x86_64.tar.gz
tar xzf act_Linux_x86_64.tar.gz
sudo mv act /usr/local/bin/
```

### Windows (Chocolatey / Scoop / WinGet)

```powershell
# Chocolatey
choco install act-cli

# Scoop
scoop install act

# WinGet
winget install nektos.act
```

### GitHub CLI Extension

```bash
# Cài đặt như gh CLI extension
gh extension install https://github.com/nektos/gh-act

# Chạy qua gh
gh act
```

### Build từ Source (Go 1.20+)

```bash
git clone https://github.com/nektos/act.git
cd act/
make build
sudo make install
```

### Thiết lập Sau cài đặt

Khi chạy lần đầu, act sẽ hỏi bạn chọn kích thước image mặc định:

```bash
# Lần chạy đầu — chọn image runner mặc định
act
? Please choose the default image you want to use with act:
  - Large size image: ~17GB download, ~75GB disk space, closest to GitHub runners
  - Medium size image: ~500MB, includes essential tools (RECOMMENDED)
  - Micro size image: <200MB, Node.js only
```

Điều này tạo ra `~/.actrc` với cấu hình mặc định của bạn:

```bash
# ~/.actrc — cấu hình mặc định
cat ~/.actrc
-P ubuntu-latest=catthehacker/ubuntu:act-latest
```

### Yêu cầu Docker

act yêu cầu Docker Engine API. Trước khi chạy:

```bash
# Xác minh Docker đang chạy
docker info

# Xác minh Docker API có thể truy cập
docker version
```

**Lưu ý:** Podman không được hỗ trợ chính thức (issue #303). Đối với thiết lập rootless hoặc các phương án thay thế, sử dụng Docker Desktop, Rancher Desktop, hoặc Colima trên macOS.

## Tích hợp với Docker, VS Code, GitHub Enterprise và Make

### Tích hợp Docker

act sử dụng Docker làm công cụ thực thi. Mọi job workflow chạy trong container cách ly:

```bash
# Chạy với image runner tùy chỉnh
act -P ubuntu-latest=node:20-slim

# Chỉ định Docker host tùy chỉnh (remote engine)
export DOCKER_HOST=tcp://remote-docker:2376
act

# Sử dụng cờ kiến trúc container cho Apple Silicon
act --container-architecture linux/amd64
```

Workflow Docker-in-Docker (DinD) được hỗ trợ bằng cách mount Docker socket của host:

```yaml
# .github/workflows/dind-test.yml
name: Docker Build Test
on: push
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build Docker image
        run: docker build -t myapp:latest .
```

### Tiện ích VS Code (GitHub Local Actions)

Tiện ích [GitHub Local Actions](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions) cho VS Code cung cấp GUI cho act:

```bash
# Cài đặt tiện ích từ VS Code marketplace
# Nhấn Cmd+Shift+P → "Extensions: Install Extensions" → Tìm "GitHub Local Actions"
```

Sau khi cài đặt tiện ích:
- Mở panel Act từ thanh bên
- Xem tất cả workflow trong `.github/workflows/`
- Nhấp vào bất kỳ workflow nào để chạy local
- Xem log thởi gian thực trong terminal tích hợp

![VS Code GitHub Local Actions Extension](https://raw.githubusercontent.com/SanjulaGanepola/github-local-actions/main/resources/screencast.gif)

### Hỗ trợ GitHub Enterprise

act hỗ trợ các phiên bản GitHub Enterprise Server riêng tư:

```bash
# Chạy với GitHub Enterprise Server
act --github-instance github.company.com

# Với xác thực
act --github-instance github.company.com -s GITHUB_TOKEN=ghp_xxxxxxxx
```

### Thay thế Make bằng act

Nhiều team sử dụng act như một task runner local, thay thế Makefile bằng workflow GitHub Actions:

```yaml
# .github/workflows/tasks.yml
name: Local Tasks
on: workflow_dispatch
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run linter
        run: npm run lint
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run tests
        run: npm test
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: npm run build
```

```bash
# Chạy task local thay vì make
act -j lint
act -j test
act -j build
```

## Benchmark / Trường hợp sử dụng thực tế

### So sánh Vòng phản hồi

| Tình huống | Push lên GitHub | Chạy local với act | Tiết kiệm Thởi gian |
|---|---|---|---|
| Sửa lỗi đánh máy trong workflow | 3-5 phút | 15-30 giây | 90% |
| Debug test thất bại | 5-10 phút (nhiều lần push) | 30-60 giây mỗi lần lặp | 85% |
| Test matrix (3 OS × 2 phiên bản Node) | 8-15 phút | 2-3 phút | 80% |
| Xác thực secret/config | 3-5 phút | 20-40 giây | 90% |
| Kiểm tra cú pháp workflow | 2-3 phút | 10-15 giây (dry-run) | 92% |

### Nghiên cứu: Giảm phút CI

Một team kỹ sư quy mô vừa (25 lập trình viên) chạy 200 lần push workflow mỗi ngày:

- **Trước act**: ~600 lần chạy CI thất bại/ngày, tiêu thụ ~3.000 phút GitHub Actions
- **Sau act**: Lập trình viên xác thực local trước; lần chạy CI thất bại giảm xuống ~80/ngày
- **Tiết kiệm hàng tháng**: ~66.000 phút GitHub Actions = khoảng $400-1.300/tháng tùy loại runner

### Thởi gian khởi động theo Kích thước Image

| Image | Pull lần đầu | Khởi động Lạnh | Khởi động Nóng |
|---|---|---|---|
| Micro (node:16-slim) | ~10 giây | 5 giây | 2 giây |
| Medium (catthehacker/ubuntu:act-latest) | ~45 giây | 15 giây | 5 giây |
| Large (catthehacker/ubuntu:full-latest) | ~8 phút | 45 giây | 15 giây |

## Sử dụng Nâng cao / Production Hardening

### Quản lý Secrets

Không bao giờ commit secrets để test. act cung cấp nhiều pattern bảo mật:

```bash
# Tùy chọn 1: Prompt tương tác (khuyến nghị cho chạy thủ công)
act -s MY_SECRET

# Tùy chọn 2: Tra cứu biến môi trường
export MY_SECRET=supersecurevalue
act -s MY_SECRET

# Tùy chọn 3: File secrets (.secrets, cùng định dạng với .env)
cat > .secrets << 'EOF'
MY_SECRET=supersecurevalue
AWS_ACCESS_KEY_ID=AKIA...
AWS_SECRET_ACCESS_KEY=...
EOF
act --secret-file .secrets

# Tùy chọn 4: Cho GITHUB_TOKEN (khuyến nghị PAT chỉ đọc)
act -s GITHUB_TOKEN=ghp_xxxxxxxxxxxx
```

Thêm `.secrets` vào `.gitignore` ngay lập tức:

```bash
echo ".secrets" >> .gitignore
echo "*.secrets" >> .gitignore
```

### Biến Repository (vars context)

Context `vars` của GitHub được hỗ trợ cho cấu hình cấp repository:

```bash
# Đặt biến
act --var DEPLOY_ENV=staging --var API_VERSION=v2

# Hoặc sử dụng file biến
cat > .variables << 'EOF'
DEPLOY_ENV=staging
API_VERSION=v2
EOF
act --var-file .variables
```

### Mô phỏng Sự kiện với File Payload

Test các workflow phụ thuộc vào dữ liệu sự kiện bằng cách cung cấp file payload JSON:

```bash
# Mô phỏng sự kiện pull_request
cat > pull-request.json << 'EOF'
{
  "pull_request": {
    "head": { "ref": "feature/new-login" },
    "base": { "ref": "main" },
    "number": 42
  }
}
EOF
act pull_request -e pull-request.json
```

```bash
# Mô phỏng push với tag
cat > tag-push.json << 'EOF'
{ "ref": "refs/tags/v1.2.3" }
EOF
act push -e tag-push.json
```

```bash
# Mô phỏng workflow_dispatch với input
cat > workflow-inputs.json << 'EOF'
{
  "inputs": {
    "environment": "production",
    "version": "2.0.0"
  }
}
EOF
act workflow_dispatch -e workflow-inputs.json
```

### Chế độ Dry-Run

Xác thực cú pháp workflow và xem kế hoạch thực thi mà không cần chạy thực tế:

```bash
# Liệt kê tất cả job sẽ chạy
act -l

# Dry run (không thực thi)
act -n

# Dry run chi tiết
act -n -v
```

### File Cấu hình (.actrc)

Cấu hình riêng cho dự án qua `.actrc`:

```bash
# .actrc trong thư mục gốc dự án
cat > .actrc << 'EOF'
--container-architecture linux/amd64
--action-offline-mode
-P ubuntu-latest=catthehacker/ubuntu:act-latest
--env-file .env
--secret-file .secrets
EOF
```

Thứ tự ưu tiên cấu hình (cao đến thấp):
1. Tham số CLI
2. `./.actrc` (thư mục gốc dự án)
3. `~/.actrc` (thư mục home)
4. `$XDG_CONFIG_HOME/act/actrc`

### Bỏ qua Job/Step cho Chạy Local

Đánh dấu các step không nên chạy local:

```yaml
# Trong file workflow của bạn
jobs:
  deploy:
    if: ${{ !github.event.act }}  # Bỏ qua job deploy khi chạy local
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

  notify:
    runs-on: ubuntu-latest
    steps:
      - name: Bỏ qua Slack notification khi chạy local
        if: ${{ !env.ACT }}
        run: |
          curl -X POST -H 'Content-type: application/json' \
            --data '{"text":"Deployment complete"}' ${{ secrets.SLACK_WEBHOOK }}
```

Truyền cờ act qua sự kiện:

```bash
cat > event.json << 'EOF'
{ "act": true }
EOF
act -e event.json
```

### Thu thập Artifact

Thu thập workflow artifact local:

```bash
# Chỉ định đường dẫn artifact server
act --artifact-server-path /tmp/artifacts

# Artifact sẽ được lưu vào /tmp/artifacts/<workflow>/<artifact-name>/
ls -la /tmp/artifacts/
```

### Chế độ Offline

Cho môi trường cách ly hoặc băng thông thấp:

```bash
# Pull image trước
act --action-offline-mode

# Tái sử dụng action repository và Docker image đã cache local
# mà không cần lấy từ GitHub hay Docker Hub
```

## So sánh với các Phương án thay thế

| Tính năng | act | GitHub Actions Runner | Drone CI | Jenkins |
|---|---|---|---|---|
| **Thực thi Local** | Native (Docker) | Có thể (thiết lập phức tạp) | Dựa trên Docker | Yêu cầu Java + plugin |
| **Parity với GitHub** | Cao (cùng cú pháp YAML) | Đầy đủ (runner chính thức) | Trung bình (cú pháp khác) | Thấp (phụ thuộc plugin) |
| **Thởi gian thiết lập** | <1 phút | 10-30 phút | 5-10 phút | 15-30 phút |
| **Sử dụng Tài nguyên** | Thấp (container Docker) | Trung-Cao (VM/Dịch vụ) | Trung bình (Docker) | Cao (JVM + plugin) |
| **Quản lý Secrets** | File, env, tương tác | Chỉ GitHub UI | Drone UI / CLI | Credentials plugin |
| **Tùy chọn Self-hosted** | Không áp dụng (chỉ local) | Self-hosted runner chính thức | Triển khai server đầy đủ | Triển khai server đầy đủ |
| **Giá** | Miễn phí (open source) | Miễn phí (repo công khai) / $0.008/phút (riêng tư) | Miễn phí (open source) / Cloud từ $15/tháng | Miễn phí (open source) |
| **Quy mô Cộng đồng** | 70,410 GitHub stars | GitHub-native | 27,000+ stars | Doanh nghiệp lâu đờ |
| **Đường cong Học tập** | Thấp (dùng cú pháp GitHub) | Trung bình | Trung bình | Cao |
| **Tích hợp IDE** | Tiện ích VS Code | Hạn chế | Hạn chế | Phong phú |

**Khi nào chọn act:**
- **act**: Phát triển local, debug workflow, xác thực trước khi commit, học GitHub Actions
- **GitHub Actions Runner**: CI/CD production trên hạ tầng GitHub hoặc self-hosted cluster
- **Drone CI**: Team muốn pipeline native container với cú pháp khác
- **Jenkins**: CI/CD doanh nghiệp quy mô lớn, cần hệ sinh thái plugin phong phú và tích hợp legacy

## Hạn chế / Đánh giá Trung thực

act là công cụ phát triển và debug, không phải thay thế CI/CD production. Hiểu các ràng buộc này trước khi áp dụng:

1. **Chỉ hỗ trợ Linux runner**: Windows (`windows-latest`) và macOS (`macos-latest`) runner không được hỗ trợ cho thực thi container hóa. Cờ `-self-hosted` có thể chạy job trực tiếp trên máy chủ macOS/Windows, nhưng điều này bỏ qua cách ly container và không khớp với môi trường runner của GitHub.

2. **Image mặc định không đầy đủ**: Image runner Medium không bao gồm mọi công cụ được cài đặt sẵn trên runner được lưu trữ của GitHub. Phần mềm như `swift`, `gcloud`, hoặc các thành phần Android SDK cụ thể có thể cần bước cài đặt thủ công trong workflow của bạn.

3. **Hạn chế Docker-in-Docker**: Chạy lệnh Docker trong container act hoạt động qua socket mounting, nhưng các kịch bản container lồng nhau và Kubernetes-in-Docker yêu cầu cấu hình bổ sung.

4. **Hỗ trợ Services không đầy đủ**: `services` Docker Compose trong định nghĩa job có hỗ trợ hạn chế (issue #173). Cơ sở dữ liệu và cache có thể cần điều phối bên ngoài.

5. **Khác biệt Mạng và Cache**: GitHub Actions caching (`actions/cache`) và service container hoạt động khác nhau ở local. Cache hit/miss và độ trễ mạng sẽ không khớp chính xác với production.

6. **Không parity với marketplace action được lưu trữ**: Một số composite action hoặc action phụ thuộc vào API nội bộ của GitHub có thể thất bại khi chạy local.

7. **Yêu cầu đĩa cho image Large**: Image Large tại ~18-75 GB là không thực tế cho laptop có dung lượng lưu trữ hạn chế. Hầu hết team nên sử dụng image Medium cho phát triển hàng ngày.

## Câu hỏi Thường gặp

### Q1: act có yêu cầu kết nối internet không?

Cho lần chạy đầu tiên, có — act cần pull image Docker và clone action repository từ GitHub. Sau đó, bạn có thể dùng `--action-offline-mode` để làm việc với image và action đã cache. Pull trước image với `docker pull` trước khi offline.

### Q2: Làm thế nào chỉ chạy một job cụ thể từ workflow?

Sử dụng cờ `-j` theo sau là job ID được định nghĩa trong file workflow YAML:

```bash
# Chỉ chạy job "test"
act -j test

# Chạy job từ file workflow cụ thể
act -j lint -W .github/workflows/checks.yml
```

### Q3: act có thể dùng với repository GitHub riêng tư hoặc GitHub Enterprise không?

Có. Cho repo riêng tư, cung cấp personal access token qua `-s GITHUB_TOKEN`. Cho GitHub Enterprise Server, dùng `--github-instance`:

```bash
act --github-instance github.mycompany.com -s GITHUB_TOKEN=ghp_xxx
```

### Q4: Tại sao workflow của tôi thất bại với "MODULE_NOT_FOUND"?

Lỗi này xảy ra khi dùng local action (ví dụ: `uses: ./`) mà không checkout đúng cách. Đảm bảo tên repository khớp với đường dẫn checkout. Nếu repo của bạn tên `my-project`, bước checkout nên bao gồm `path: "my-project"`.

### Q5: Làm thế nào debug một step thất bại?

Chạy act với verbose logging (`-v`) và giữ container để kiểm tra:

```bash
# Output chi tiết
act -v

# Chạy job cụ thể với output chi tiết
act -j test -v

# Tên container được in trong log; kiểm tra sau khi thất bại
docker exec -it <container-name> /bin/bash
```

### Q6: act có phù hợp để chạy pipeline CI/CD production không?

Không. act được thiết kế cho phát triển và debug local. Cho CI/CD production, hãy dùng GitHub-hosted runners, self-hosted runners, hoặc các nền tảng CI/CD chuyên dụng như GitHub Actions, Drone, hoặc Jenkins.

### Q7: Làm thế nào cập nhật act lên phiên bản mới nhất?

Dùng cùng package manager bạn đã cài đặt:

```bash
# Homebrew
brew upgrade act

# Chocolatey
choco upgrade act-cli

# Scoop
scoop update act

# Bash script (chạy lại trình cài đặt)
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

## Kết luận

Với 70.410 sao và nhịp độ phát hành theo kịp các cập nhật GitHub Actions, act đã khẳng định vị trí trong bộ công cụ của mọi lập trình viên. Khả năng xác thực workflow local trước khi push loại bỏ vòng phản hồi đắt đỏ của commit-push-wait-fail-fix. Cài đặt trong vòng một phút, cấu hình `.actrc`, và bắt đầu coi định nghĩa CI/CD của bạn như code hạng nhất mà bạn có thể test trên máy của mình.

**Các bước hành động:**
1. Cài đặt act bằng package manager bạn ưa thích
2. Chạy `act -l` trong repository có workflow để xem các job khả dụng
3. Tạo file `.actrc` với cấu hình runner mặc định của bạn
4. Thiết lập file `.secrets` (và thêm vào `.gitignore`) cho quản lý secret local
5. Chia sẻ hướng dẫn này với team để chuẩn hóa phát triển CI/CD local

Tham gia [cộng đồng lập trình viên dibi8 trên Telegram](https://t.me/dibi8) để thảo luận về thiết lập act, chia sẻ tối ưu workflow, và nhận trợ giúp từ các kỹ sư đang sử dụng act trong môi trường production.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu Tham khảo

- [act GitHub Repository](https://github.com/nektos/act) — Mã nguồn chính thức, 70.410 stars
- [act User Guide](https://nektosact.com/) — Tài liệu toàn diện
- [act Installation Guide](https://nektosact.com/installation/index.html) — Phương pháp cài đặt theo nền tảng
- [act Runners Reference](https://nektosact.com/usage/runners.html) — Tùy chọn và kích thước image Docker
- [act Usage Guide](https://nektosact.com/usage/index.html) — Sự kiện, secrets, cấu hình
- [VS Code: GitHub Local Actions Extension](https://marketplace.visualstudio.com/items?itemName=SanjulaGanepola.github-local-actions)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [catthehacker/docker_images](https://github.com/catthehacker/docker_images) — Community runner images mà act sử dụng
