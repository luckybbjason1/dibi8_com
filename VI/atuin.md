---
title: 'Atuin: 29,794 GitHub Stars — Hướng Dẫn Cài Đặt Đồng Bộ Shell History 2026'
description: 'Atuin thay thế lịch sử shell bằng SQLite, ghi ngữ cảnh lệnh (mã thoát, thư mục, thờ gian), đồng bộ hóa lịch sử qua nhiều máy với mã hóa E2E. Hỗ trợ Bash, Zsh, Fish, Nushell. Bao gồm cài đặt, tự host, cấu hình và so sánh Atuin vs mcfly vs fzf vs Hstr.'
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
github_repo: 'https://github.com/atuinsh/atuin'
stars: 29794
maintainer: 'atuinsh'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['atuin', 'lich-su-shell', 'cong-cu-cli', 'sqlite', 'rust', 'dong-bo', 'bash', 'zsh', 'fish']
aliases:
- /vi/posts/atuin/
---

{{</* resource-info */>}}

![Atuin Shell History](https://raw.githubusercontent.com/atuinsh/atuin/main/docs/static/img/atuin.png)

*Atuin thay thế lịch sử shell hiện tại bằng cơ sở dữ liệu SQLite và giao diện tìm kiếm mờ toàn màn hình được kích hoạt qua Ctrl+R.*

![Atuin Stats](https://docs.atuin.sh/assets/images/stats.png)

*Lệnh `atuin stats` hiển thị các lệnh bạn dùng nhiều nhất, tổng số lệnh và phân tích lệnh duy nhất.*

## Giới thiệu

Bạn đã gõ lệnh `kubectl` phức tạp đó ít nhất ba lần trong tuần này. Bạn biết nó nằm đâu đó trong lịch sử — có lẽ bị chôn vùi dưới 40.000 lệnh khác — nhưng `Ctrl+R` tìm kiếm ngược chỉ lặp qua từng kết quả một, còn `grep ~/.bash_history` trả về một bức tường nhiễu. Với developer sống trong terminal, lịch sử shell là bộ nhớ thứ hai. Khi nó thất bại, năng suất giảm sút.

Atuin giải quyết vấn đề này bằng cơ sở dữ liệu lịch sử dùng SQLite, ghi lại không chỉ lệnh mà cả ngữ cảnh xung quanh: mã thoát, thư mục làm việc, tên máy, ID phiên và thờ gian thực thi. Với 29.794 GitHub Stars và codebase Rust, Atuin thêm tìm kiếm mờ (fuzzy), đồng bộ máy-to-máy có mã hóa, và phân tích sử dụng vào mọi phiên shell. Hướng dẫn này đi qua cài đặt Atuin production-grade, từ lệnh đầu tiên đến server đồng bộ tự host.

## Atuin là gì?

Atuin là công cụ thay thế lịch sử shell viết bằng Rust, lưu trữ lệnh trong cơ sở dữ liệu SQLite local với metadata phong phú, sau đó tùy chọn đồng bộ hóa lịch sử qua nhiều máy bằng mã hóa đầu cuối. Được duy trì bởi tổ chức atuinsh, phát hành theo giấy phép MIT, hỗ trợ Bash, Zsh, Fish, Nushell, Xonsh và PowerShell (tier 2).

## Atuin hoạt động như thế nào

Atuin hoạt động như trình chặn lịch sử phía client và client đồng bộ tùy chọn. Hiểu rõ kiến trúc giúp ích khi debug vấn đề đồng bộ hoặc lập kế hoạch triển khai tự host.

### Tổng quan kiến trúc

```
+-------------+     hook preexec/precmd     +------------------+
|   Shell     |  -------------------------->  |   Atuin Client   |
| (bash/zsh)  |                             |   (Rust binary)  |
+-------------+                             +--------+---------+
                                                     |
                                            +--------v---------+
                                            |   SQLite (local) |
                                            |   ~/.local/share |
                                            +--------+---------+
                                                     |
                              +----------------------v----------------------+
                              |              Giao thức đồng bộ V2            |
                              |   PASETO V4 (XChaCha20-Poly1305 + Blake2b) |
                              +----------------------+----------------------+
                                                     |
                              +----------------------v----------------------+
                              |         Server Atuin (tự host hoặc cloud)   |
                              |         Backend PostgreSQL hoặc SQLite      |
                              +---------------------------------------------+
```

### Các thành phần chính

1. **Lớp Shell Hook**: Atuin đăng ký hook `preexec` (trước lệnh) và `precmd` (sau lệnh) qua plugin shell cụ thể. Các hook này ghi lại chuỗi lệnh, thư mục làm việc, thờ gian bắt đầu và mã thoát.
2. **Cơ sở dữ liệu SQLite local**: Mọi lịch sử được lưu tại `~/.local/share/atuin/history.db` sử dụng SQLite với chế độ WAL để đảm bảo hiệu năng đọc/ghi đồng thờ.
3. **Client đồng bộ**: Đồng bộ nền tùy chọn đẩy record đã mã hóa lên server Atuin. Dữ liệu được envelope-encrypted với content encryption key riêng cho mỗi record trước khi rồi khỏi máy.
4. **Giao diện TUI tìm kiếm**: Giao diện terminal toàn màn hình (xây dựng bằng `ratatui`) thay thế `Ctrl+R` bằng tìm kiếm fuzzy/prefix/fulltext và chế độ lọc.

### Chi tiết mã hóa

| Giao thức | Thuật toán | Trạng thái |
|-----------|------------|------------|
| V1 (legacy) | XSalsa20Poly1305 (NaCl secretbox) | Đang loại bỏ |
| V2 (hiện tại) | PASETO V4 Local (XChaCha20-Poly1305 + Blake2b) | Đang hoạt động |

V2 sử dụng envelope encryption: mỗi record nhận một CEK ngẫu nhiên được wrap bằng master key của ngườ dùng. Master key nằm tại `~/.local/share/atuin/key` và không bao giờ rồi khỏi thiết bị.

## Cài đặt & Thiết lập

### Cài đặt một dòng (Khuyến nghị)

```bash
# Unix/macOS — cài đặt tương tác với prompt thiết lập shell
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

# Không tương tác (CI, Dockerfile)
curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
```

Trình cài đặt đặt binary tại `~/.atuin/bin/atuin` và thêm tích hợp shell vào file rc.

### Trình quản lý gói

```bash
# Homebrew (macOS/Linux)
brew install atuin

# Cargo (yêu cầu Rust toolchain)
cargo install atuin

# Arch Linux
sudo pacman -S atuin

# NixOS / nix
nix-env -iA nixpkgs.atuin

# Debian/Ubuntu (từ GitHub releases)
VERSION="18.16.1"
curl -LO "https://github.com/atuinsh/atuin/releases/download/v${VERSION}/atuin_${VERSION}_amd64.deb"
sudo dpkg -i "atuin_${VERSION}_amd64.deb"

# Windows (WinGet)
winget install -e Atuinsh.Atuin
```

### Tích hợp Shell

Sau cài đặt, thêm Atuin vào file rc của shell:

```bash
# Bash — thêm vào ~/.bashrc
eval "$(atuin init bash)"

# Zsh — thêm vào ~/.zshrc
eval "$(atuin init zsh)"

# Fish — thêm vào ~/.config/fish/config.fish
atuin init fish | source

# Nushell — thêm vào config.nu
atuin init nu | save ~/.config/nushell/atuin.nu
source ~/.config/nushell/atuin.nu
```

Tải lại shell hoặc chạy `exec $SHELL` để kích hoạt.

### Nhập lịch sử hiện có

```bash
# Tự động phát hiện shell và nhập
atuin import auto

# Hoặc chỉ định rõ ràng
atuin import bash
atuin import zsh
atuin import fish

# Kiểm tra số lệnh đã nhập
atuin stats
```

### Xác minh cài đặt

```bash
$ atuin --version
atuin 18.16.1

$ atuin doctor
Atuin Doctor
Checking for diagnostics
[✓] Atuin is compiled with sqlite support
[✓] Atuin is compiled with sync support
[✓] Atuin config directory exists
```

## Cấu hình cốt lõi

File cấu hình Atuin nằm tại `~/.config/atuin/config.toml`. Trước khi đi sâu vào cài đặt, đây là giao diện tìm kiếm trong thực tế với các chế độ lọc khác nhau:

![Atuin Search UI](https://docs.atuin.sh/assets/images/search.png)

*Giao diện TUI của Atuin hiển thị cửa sổ tìm kiếm nội tuyến với fuzzy matching và kết quả theo phạm vi thư mục.* Đây là cấu hình production-hardened:

```toml
# ~/.config/atuin/config.toml
[settings]
# Chế độ tìm kiếm: prefix, fulltext, fuzzy, skim
search_mode = "fuzzy"

# Chế độ lọc: global, host, session, directory
filter_mode = "global"

# Kiểu UI: compact, full
style = "compact"

# Cài đặt đồng bộ
auto_sync = true
sync_frequency = "5m"
sync_address = "https://api.atuin.sh"

# Không ghi lại lệnh nhạy cảm (mẫu regex)
history_filter = [
    "^export.*KEY",
    "^export.*SECRET",
    "^export.*PASSWORD",
    "^aws configure",
    "^ssh-keygen",
]

# Bộ lọc thư mục làm việc — không ghi trong các đường dẫn này
cwd_filter = [
    "/tmp/secrets",
    "~/.*cred",
]

# Enter chấp nhận lệnh; false = Tab để chỉnh sửa trước
enter_accept = true

# Hiển thị gợi ý trợ giúp trong UI tìm kiếm
show_help = false

# Số kết quả
inline_height = 20
```

### Giải thích các tùy chọn cấu hình chính

```bash
# Xem giá trị cấu hình hiện tại
atuin config get search_mode
# fuzzy

# Xem giá trị resolved (hiệu lực)
atuin config get search_mode --resolved
# fuzzy

# Đặt giá trị cấu hình inline
atuin config set search_mode fulltext
atuin config set filter_mode directory

# In toàn bộ cấu hình
atuin config print
```

### Chế độ tìm kiếm và lọc

```bash
# Ctrl+R chuyển đổi giữa các chế độ lọc một cách tương tác
# Chế độ lọc mặc định: global -> host -> session -> directory

# Tìm kiếm dòng lệnh với bộ lọc
atuin search --exit 0 --after "yesterday 3pm" make
atuin search --before "2026-01-01" --cwd /project deploy
atuin search --exit 1 --session       # lệnh thất bại trong phiên này

# Xóa mục khớp
atuin search --delete "rm -rf /accident"
```

## Tích hợp với công cụ phổ biến

### Starship Prompt

Starship hoạt động cùng Atuin không có xung đột. Cả hai đều hook vào sự kiện shell độc lập:

```toml
# ~/.config/starship.toml — không cần cấu hình đặc biệt
# Atuin xử lý lịch sử; Starship xử lý prompt
# Đảm bảo Atuin init chạy trước Starship init trong file rc
```

```bash
# ~/.zshrc — thứ tự quan trọng
eval "$(atuin init zsh)"       # Atuin trước
eval "$(starship init zsh)"    # Starship sau
```

### tmux

Atuin tích hợp sạch sẽ với phiên tmux. Mỗi cửa sổ tmux nhận ID phiên riêng, cho phép lọc lịch sử theo cửa sổ:

```bash
# ~/.tmux.conf — gán phím mở tìm kiếm Atuin
bind-key r run-shell "tmux send-keys C-r"

# Atuin tự động phát hiện phiên tmux qua biến môi trường
# Lọc theo phiên: nhấn Ctrl+R rồi chuyển chế độ lọc
```

### fzf

Một số ngườ dùng kết hợp Atuin với fzf để tìm file fuzzy, dùng Atuin cho lịch sử:

```bash
# Giữ fzf cho file, Atuin cho lịch sử
# Vô hiệu hóa fzf history binding (trong ~/.bashrc hoặc ~/.zshrc)
export FZF_DEFAULT_COMMAND='fd --type f --hidden'
# Không bind Ctrl+R — để Atuin xử lý

# fzf cho file
alias ff='fzf --preview "bat --style=numbers --color=always {}"'

# Atuin cho lịch sử (tự động bind Ctrl+R)
```

### Nushell

Tích hợp Nushell yêu cầu thiết lập rõ ràng vì Nushell dùng hệ thống cấu hình khác:

```nushell
# config.nu
source ~/.config/nushell/atuin.nu

# Đặt biến môi trường
$env.ATUIN_NOBIND = true  # nếu muốn keybind tùy chỉnh
```

### Docker / Dev Containers

```dockerfile
# Dockerfile.dev
RUN curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh -s -- --non-interactive
COPY config.toml /root/.config/atuin/config.toml
RUN echo 'eval "$(atuin init bash)"' >> /root/.bashrc
```

## Server đồng bộ tự host

Cho team hoặc ngườ dùng quan tâm quyền riêng tư, server đồng bộ Atuin có thể được tự host bằng Docker.

### Thiết lập Docker Compose

```yaml
# docker-compose.yml
version: "3"
services:
  atuin:
    restart: always
    image: ghcr.io/atuinsh/atuin:latest
    command: server start
    volumes:
      - ./config:/config
      - ./atuin-data:/atuin-data
    links:
      - postgresql
    ports:
      - "8888:8888"
    environment:
      ATUIN_HOST: "0.0.0.0"
      ATUIN_PORT: "8888"
      ATUIN_OPEN_REGISTRATION: "true"
      ATUIN_DB_URI: "postgres://atuin:change-me@postgresql/atuin"
      RUST_LOG: "info,atuin_server=debug"
    user: "1000:1000"

  postgresql:
    image: postgres:14
    restart: always
    volumes:
      - ./postgres-data:/var/lib/postgresql/data
    environment:
      POSTGRES_USER: atuin
      POSTGRES_PASSWORD: change-me
      POSTGRES_DB: atuin
    user: "1000:1000"

  # Tùy chọn: sao lưu tự động
  backup:
    image: prodrigestivill/postgres-backup-local
    restart: always
    volumes:
      - ./backups:/backups
    links:
      - postgresql
    environment:
      POSTGRES_HOST: postgresql
      POSTGRES_DB: atuin
      POSTGRES_USER: atuin
      POSTGRES_PASSWORD: change-me
      POSTGRES_EXTRA_OPTS: "-Z6 --schema=public --blobs"
      SCHEDULE: "@daily"
      BACKUP_KEEP_DAYS: "7"
```

### Khởi động Server

```bash
# Tạo thư mục dữ liệu
mkdir -p atuin-data postgres-data backups

# Khởi động dịch vụ
docker compose up -d

# Kiểm tra sức khỏe
curl http://localhost:8888/health
# {"status":"ok"}
```

### Cấu hình Client cho tự host

```toml
# ~/.config/atuin/config.toml
[settings]
sync_address = "http://your-server:8888"
auto_sync = true
sync_frequency = "5m"
```

```bash
# Đăng ký tài khoản mới trên server tự host
atuin register -u myuser -e myuser@example.com -p securepassword

# Hoặc đăng nhập trên máy bổ sung
atuin login -u myuser -p securepassword

# Lấy encryption key (sao lưu an toàn)
atuin key
# c2e2d6e5a9b1c3f4d7e8a9b0c1d2e3f4...

# Kích hoạt đồng bộ
atuin sync
```

### Triển khai Kubernetes

```yaml
# atuin-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: atuin-server
spec:
  replicas: 2
  selector:
    matchLabels:
      app: atuin
  template:
    metadata:
      labels:
        app: atuin
    spec:
      containers:
        - name: atuin
          image: ghcr.io/atuinsh/atuin:18.16.1
          command: ["atuin", "server", "start"]
          ports:
            - containerPort: 8888
          env:
            - name: ATUIN_HOST
              value: "0.0.0.0"
            - name: ATUIN_DB_URI
              valueFrom:
                secretKeyRef:
                  name: atuin-db-secret
                  key: uri
---
apiVersion: v1
kind: Service
metadata:
  name: atuin-service
spec:
  selector:
    app: atuin
  ports:
    - port: 8888
      targetPort: 8888
```

## Benchmark / Trường hợp sử dụng thực tế

### Đặc tính hiệu năng

Triển khai Rust và backend SQLite của Atuin cung cấp hiệu năng ổn định trên dataset lịch sử lớn:

| Chỉ số | Giá trị | Ghi chú |
|--------|---------|---------|
| Truy vấn lịch sử (100K mục) | ~15ms | tìm kiếm fuzzy, cache lạnh |
| Truy vấn lịch sử (500K mục) | ~45ms | tìm kiếm fuzzy, cache ấm |
| Đồng bộ upload ban đầu (50K lệnh) | ~30s | phụ thuộc băng thông |
| Đồng bộ gia tăng | ~1-3s | delta hàng ngày điển hình |
| Kích thước binary | ~12MB | binary tĩnh đơn |
| Bộ nhớ resident | ~15MB | khi idle |
| Kích thước SQLite DB | ~100MB/100K lệnh | với metadata đầy đủ |

### Trường hợp sử dụng production

1. **Phát triển đa thiết bị**: Developer với laptop công việc, desktop cá nhân và VM cloud giữ lịch sử shell đồng bộ. Chạy `docker compose up` trên một máy có thể tìm kiếm từ máy khác.
2. **Bảo toàn kiến thức team**: Team DevOps tự host Atuin để duy trì audit trail lệnh infrastructure có thể tìm kiếm qua các kỹ sư on-call luân phiên.
3. **Khôi phục môi trường remote**: Developer dùng workspace cloud tạm thờ (Gitpod, Coder) đồng bộ lịch sử để việc teardown workspace không xóa ngữ cảnh lệnh.

### Output lệnh Stats

```bash
$ atuin stats
[▮▮▮▮▮▮▮▮▮▮]  9,607 fg
[▮▮▮▮▮▮▮▮▮ ]  9,458 vim
[▮▮▮       ]  3,144 ag
[▮▮▮       ]  3,095 git status
[▮▮        ]  2,248 git diff
[▮         ]  1,787 curl
[▮         ]  1,571 jq
[▮         ]  1,357 rg
[▮         ]  1,348 cd
[▮         ]  1,322 git log
Total commands:   62,849
Unique commands:  26,908
```

## Sử dụng nâng cao / Củng cố production

### Bộ lọc quyền riêng tư lịch sử

Ngăn lệnh nhạy cảm vào cơ sở dữ liệu:

```toml
# ~/.config/atuin/config.toml
[settings]
history_filter = [
    # AWS credentials
    "^aws configure",
    "^export AWS_SECRET_ACCESS_KEY",
    # Secrets chung
    "^export.*SECRET",
    "^export.*PASSWORD",
    "^export.*TOKEN",
    "^echo.*password",
    # SSH keys
    "^ssh-add",
    "^ssh-keygen",
    # Chuỗi kết nối database
    "^psql.*://.*:",
    "^mysql.*-p",
]
```

### Sao lưu lịch sử

```bash
# Sao lưu SQLite (an toàn, không vấn đề khóa)
sqlite3 ~/.local/share/atuin/history.db ".backup '/backup/atuin-$(date +%Y%m%d).db'"

# Hoặc copy với WAL checkpoint
cp ~/.local/share/atuin/history.db ~/backups/atuin-backup.db

# Tự động sao lưu hàng ngày qua cron
0 2 * * * sqlite3 ~/.local/share/atuin/history.db ".backup '/backups/atuin/atuin-$(date +\%Y\%m\%d).db'" && find /backups/atuin -mtime +30 -delete
```

### Giám sát sức khỏe đồng bộ

```bash
# Kiểm tra lần đồng bộ cuối
atuin sync --force  # force sync và hiển thị trạng thái

# Xem thông tin đồng bộ
atuin info
# Atuin v18.16.1
# Sync interval: 5m
# Sync address: https://api.atuin.sh
# Last sync: 2026-05-20T08:15:32Z
# History count: 47,231

# Kiểm tra vấn đề
atuin doctor
```

### Tùy chỉnh giao diện TUI

```toml
# ~/.config/atuin/config.toml
[theme]
# Dùng màu mặc định terminal
use_default_colors = true

# Hoặc chỉ định màu rõ ràng
base = "#1e1e2e"
layer1 = "#313244"
text = "#cdd6f4"
accent = "#89b4fa"
```

### Di chuyển key đa máy

Khi thiết lập máy mới, chuyển encryption key một cách an toàn:

```bash
# Trên máy cũ — copy key vào clipboard (hoặc chuyển an toàn)
cat ~/.local/share/atuin/key

# Trên máy mới — sau cài đặt và đăng nhập
mkdir -p ~/.local/share/atuin
echo "YOUR_KEY_HERE" > ~/.local/share/atuin/key
chmod 600 ~/.local/share/atuin/key

# Xác minh đồng bộ hoạt động
atuin sync
atuin stats
```

## So sánh với lựa chọn thay thế

| Tính năng | Atuin | mcfly | fzf + history | Hstr |
|-----------|-------|-------|---------------|------|
| **Cơ sở dữ liệu** | SQLite | SQLite | File text | File text |
| **Đồng bộ máy-to-máy** | Có (E2EE) | Không | Không | Không |
| **UI tìm kiếm** | TUI tích hợp | TUI tích hợp | Tích hợp fzf | TUI tích hợp |
| **Ghi ngữ cảnh** | cwd, exit, thờ gian, host | cwd, exit | Không | Không |
| **Thống kê** | `atuin stats` | Không | Không | Không |
| **Hỗ trợ shell** | bash, zsh, fish, nu, xonsh | bash, zsh, fish | Mọi shell | bash, zsh |
| **Mã hóa** | PASETO V4 | Không | Không | Không |
| **Server tự host** | Có (Docker/K8s) | N/A | N/A | N/A |
| **Tích hợp AI** | Có (tùy chọn) | Không | Không | Không |
| **Nhập lịch sử** | bash, zsh, fish, nu | bash, zsh, fish | N/A | bash, zsh |
| **GitHub Stars** | 29,794 | 6,800 | 67,000 (fzf) | 3,900 |
| **Kích thước binary** | ~12MB | ~4MB | ~4MB (chỉ fzf) | ~2MB |

### Khi nào chọn công cụ nào

- **Atuin**: Bạn cần đồng bộ mã hóa qua nhiều máy, metadata ngữ cảnh phong phú, và UI tìm kiếm đầy đủ tính năng. Tốt nhất cho developer dùng 2+ máy và đánh giá cao phân tích lịch sử.
- **mcfly**: Bạn cần công cụ nhẹ, hoàn toàn local với thuật toán xếp hạng theo ngữ cảnh thông minh. Tốt nhất cho ngườ dùng một máy, không phụ thuộc mạng.
- **fzf + history**: Bạn đã dùng fzf cho file và muốn giải pháp lịch sử tối thiểu. Tốt nhất cho ngườ muốn một công cụ fuzzy cho mọi thứ.
- **Hstr**: Bạn cần TUI lịch sử đơn giản, nhẹ không cần cơ sở dữ liệu. Tốt nhất cho ngườ minimal trên bash/zsh.

## Hạn chế / Đánh giá trung thực

Atuin không phải công cụ phù hợp mọi kịch bản:

1. **Không theo dõi ngườ thực thi**: Atuin ghi lệnh nhưng không biết lệnh được gõ thủ công, chạy bởi script, hay tạo bởi AI assistant. Mọi nguồn đều giống nhau trong CSDL.

2. **CSDL local không mã hóa**: CSDL SQLite tại `~/.local/share/atuin/` được lưu dạng plain text để đảm bảo hiệu năng tìm kiếm. Đồng bộ có mã hóa nhưng lưu trữ local thì không. Dùng mã hóa hệ thống file (LUKS, FileVault) để bảo vệ.

3. **Tích hợp Bash có thể mong manh**: Hook `preexec` của Bash phụ thuộc DEBUG trap, có thể xung đột với công cụ khác (pyenv, nodenv, một số thiết lập PROMPT_COMMAND). Tích hợp Zsh và Fish đáng tin cậy hơn.

4. **Đồng bộ yêu cầu tài khoản**: Ngay cả đồng bộ tự host cũng cần đăng ký ngườ dùng. Không có chế độ ẩn danh hoặc "đồng bộ trực tiếp lên S3".

5. **Binding phím mũi tên lên gây bối rối**: Atuin thay thế phím mũi tên lên mặc định, có thể làm ngườ mới bối rối khi chỉ muốn duyệt lệnh gần đây. Đặt `filter_mode_shell_up_key = "session"` hoặc vô hiệu hóa hoàn toàn.

6. **Hỗ trợ PowerShell là tier 2**: Mặc dù hoạt động, tích hợp PowerShell ít được test hơn và có thể thiếu tính năng so với shell Unix.

## Câu hỏi thường gặp

### Làm sao tắt binding phím mũi tên lên?

Thêm `filter_mode_shell_up_key = "global"` hoặc `show_preview = false` trong cấu hình. Để hoàn toàn tắt Atuin trên phím mũi tên lên, thêm `export ATUIN_NOBIND=1` trước dòng init và bind thủ công chỉ `Ctrl+R`:

```bash
# ~/.bashrc
export ATUIN_NOBIND=1
eval "$(atuin init bash)"
bind '"\C-r": "\C-aatuin search\C-j"'
```

### Có thể dùng Atuin không đồng bộ không?

Có. Atuin hoạt động hoàn toàn như công cụ local. Bỏ qua đăng ký, bỏ qua mọi lệnh đồng bộ. Lịch sử lưu trong SQLite local và mọi tính năng tìm kiếm hoạt động offline.

### Dữ liệu của tôi được mã hóa như thế nào?

Mọi dữ liệu đồng bộ được mã hóa client-side bằng PASETO V4 (XChaCha20-Poly1305 + Blake2b) trước khi rồi khỏi máy. Server đồng bộ (tự host hoặc atuin.sh) chỉ thấy blob đã mã hóa — không thể giải mã hay đọc lệnh. CSDL SQLite local không mã hóa để đảm bảo hiệu năng tìm kiếm.

### Nếu mất encryption key thì sao?

Encryption key cần thiết để giải mã lịch sử đã đồng bộ. Nếu mất, không thể khôi phục dữ liệu đã đồng bộ trước đó. Key hiển thị trong thiết lập ban đầu qua `atuin key` — sao lưu vào trình quản lý mật khẩu. Lịch sử local vẫn truy cập được bất kể key.

### Hai ngườ dùng có thể chia sẻ CSDL lịch sử không?

Không trực tiếp. Mô hình đồng bộ của Atuin thiết kế cho một ngườ dùng qua nhiều thiết bị. Cho lịch sử chia sẻ team, mỗi ngườ giữ CSDL và tài khoản đồng bộ riêng. Server tự host hỗ trợ nhiều tài khoản độc lập.

### Atuin có làm chậm shell không?

Không có tác động đo được. Binary Rust thêm ~5-10ms vào thờ gian khởi động shell (một lần), và capture lệnh diễn ra không đồng bộ qua shell hook. Chế độ SQLite WAL đảm bảo ghi không chặn prompt shell.

### Làm sao xóa lệnh khỏi lịch sử?

```bash
# Xóa theo mẫu tìm kiếm
atuin search --delete "sensitive-command"

# Hoặc dùng TUI — tìm lệnh, rồi nhấn Alt+Delete
```

## Kết luận

Atuin biến lịch sử shell từ file text phẳng thành cơ sở dữ liệu có cấu trúc, có thể tìm kiếm và di động. Với 29.794 GitHub Stars, đồng bộ mã hóa đầu cuối, và hỗ trợ mọi shell chính, đây là nâng cấp thực tế cho mọi developer sống trong terminal.

**Các bước tiếp theo:**
1. Chạy `curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh` để cài đặt
2. Nhập lịch sử hiện có bằng `atuin import auto`
3. Đăng ký đồng bộ hoặc cấu hình server tự host
4. Tham gia [cộng đồng developer Telegram](https://t.me/dibi8dev) để tips và khắc phục sự cố



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Tài liệu tham khảo

- [Atuin GitHub Repository](https://github.com/atuinsh/atuin)
- [Atuin Tài liệu chính thức](https://docs.atuin.sh/)
- [Atuin Hướng dẫn tự host](https://docs.atuin.sh/self-hosting/docker/)
- [Atuin Tham khảo cấu hình](https://docs.atuin.sh/cli/reference/config/)
- [PASETO V4 Đặc tả](https://paseto.io/)
- [Ellie Huxtable — Blog ngườ tạo Atuin](https://ellie.wtf/projects/atuin)
- [mcfly GitHub Repository](https://github.com/cantino/mcfly)
- [fzf GitHub Repository](https://github.com/junegunn/fzf)
- [Hstr GitHub Repository](https://github.com/dvorka/hstr)
