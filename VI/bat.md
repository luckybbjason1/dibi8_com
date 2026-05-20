---
title: 'bat: Bản sao cat với Syntax Highlighting 58K+ Stars — So sánh với cat, less 2026'
description: 'bat là bản sao cat(1) với syntax highlighting và tích hợp Git. Tương thích với Rust, Git, Homebrew, Cargo. Hướng dẫn cài đặt, benchmark hiệu năng, file cấu hình và so sánh với cat, less, ccat.'
date: 2026-05-19 00:00:00+08:00
lastmod: 2026-05-19 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: Apache-2.0
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: 'https://github.com/sharkdp/bat'
stars: 58940
maintainer: 'sharkdp'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['bat', 'thay thế cat', 'syntax highlighting', 'công cụ cli', 'rust', 'terminal', 'trình xem file', 'dòng lệnh']
aliases:
- /vi/posts/bat/
---

{{</* resource-info */>}}

Lệnh `cat` đã là công cụ xem file mặc định trên các hệ thống Unix-like từ năm 1971. Nó xuất byte thô ra stdout —— không màu, không số dòng, không nhận thức Git. Khi bạn đọc file Python 200 dòng lúc 2 giờ sáng, việc nhìn chằm chằm vào văn bản không định dạng tạo thêm gánh nặng nhận thức không cần thiết. `bat` thay thế workflow 40 năm tuổi này bằng syntax highlighting, tích hợp Git và phân trang tự động —— mà không phá vỡ muscle memory mà mọi ngườ dùng terminal đã quen thuộc.

## bat là gì

`bat` là công cụ thay thế `cat(1)` được viết bằng Rust. Nó thêm syntax highlighting cho 200+ ngôn ngữ lập trình và markup, phân trang tự động, đánh dấu thay đổi Git, số dòng, tiêu đề file và hỗ trợ theme —— trong khi vẫn giữ tính tương thích với pipeline Unix. Với 58,940 GitHub Stars và phiên bản 0.26.1 phát hành đầu năm 2026, đây là một trong những CLI utility hiện đại được áp dụng rộng rãi nhất trong hệ sinh thái Rust.

## bat hoạt động như thế nào

`bat` đọc file qua terminal, phát hiện ngôn ngữ bằng phần mở rộng file và dòng shebang, áp dụng syntax highlighting qua thư viện `syntect` (bản port Rust của engine highlighting Sublime Text), và pipe kết quả qua pager khi output vượt quá chiều cao terminal.

![Ví dụ syntax highlighting của bat hiển thị file nguồn Rust với số dòng, đánh dấu thay đổi Git và cú pháp màu](https://raw.githubusercontent.com/sharkdp/bat/master/doc/screenshot.png)
*Ảnh chụp màn hình: bat hiển thị file Rust với syntax highlighting, số dòng và tích hợp Git. Nguồn: sharkdp/bat GitHub repository.*

```
+---------+    +----------------+    +----------------+    +---------+
|  Input  | -> | Phát hiện     | -> | syntect        | -> |  Pager  |
|  File   |    | ngôn ngữ      |    | Highlighting   |    | (less)  |
+---------+    +----------------+    +----------------+    +---------+
                    |                      |
                    v                      v
              Phần mở rộng file      Chọn theme
              Phân tích shebang      Đánh dấu diff Git
```

Các khái niệm cốt lõi mọi ngườ dùng cần biết:

- **Tự động phát hiện ngôn ngữ**: `bat` xác định cú pháp từ phần mở rộng file (`.rs`, `.py`, `.md`) hoặc dòng shebang (`#!/bin/bash`).
- **Engine Syntect**: Cùng định nghĩa grammar TextMate/Sublime Text điều khiển highlighting, nên độ chính xác ngang với editor hiện đại.
- **Ủy quyền pager**: Mặc định, `bat` pipe qua `less` khi output vượt một màn hình. Trong ngữ cảnh non-interactive (pipe sang process khác), nó hoạt động giống hệt `cat`.
- **Tích hợp Git**: File trong repository Git hiển thị thanh đánh dấu modification ở lề —— xanh lá cho dòng thêm, vàng cho dòng sửa.

## Cài đặt & Thiết lập

Cài đặt `bat` trên mọi nền tảng chính chưa đến hai phút.

### macOS (Homebrew)

```bash
brew install bat

# Kiểm tra
bat --version
# bat 0.26.1 (e4ae987)
```

### Ubuntu / Debian

```bash
# Ubuntu 22.04+ / Debian 12+
sudo apt install bat

# Trên một số hệ thống Debian/Ubuntu, binary tên là 'batcat' để tránh xung đột
# Tạo alias nếu cần:
mkdir -p ~/.local/bin
ln -s /usr/bin/batcat ~/.local/bin/bat
```

### Arch Linux

```bash
# Repository chính thức
sudo pacman -S bat

# Hoặc qua AUR helper
yay -S bat
```

### Fedora / RHEL

```bash
sudo dnf install bat
```

### Windows (qua Scoop)

```bash
scoop install bat
```

### Từ Source (Cargo)

```bash
# Yêu cầu Rust 1.70+
cargo install --locked bat

# Hoặc clone và build
git clone --recursive https://github.com/sharkdp/bat
cd bat
cargo build --release
sudo cp target/release/bat /usr/local/bin/
```

### Cấu hình sau cài đặt

Tạo thư mục config và file cấu hình:

```bash
# Tạo thư mục cấu hình
mkdir -p "$(bat --config-dir)"

# Xem đường dẫn file cấu hình
bat --config-file
# Hiển thị đường dẫn, ví dụ: ~/.config/bat/config
```

Chỉnh sửa file cấu hình:

```bash
# ~/.config/bat/config
--theme="TwoDark"
--style="numbers,changes,header"
--paging=auto
--map-syntax="*.conf:INI"
```

## Tích hợp với công cụ phổ biến

### Git — Lịch sử file có màu

Xem file ở bất kỳ Git revision nào với syntax highlighting đầy đủ:

```bash
# Xem file ở tag cụ thể
git show v0.26.1:src/main.rs | bat -l rs

# Xem thay đổi staged với highlighting
git diff --cached | bat -l diff
```

### fzf — File Previewer

![Tích hợp fzf với bat hiển thị panel preview file với syntax highlighting và số dòng](https://raw.githubusercontent.com/sharkdp/bat/master/doc/screenshot.png)
*fzf file picker sử dụng bat làm preview engine cho file preview có syntax highlighting.*

`bat` tích hợp sạch sẽ với `fzf` như một preview engine:

```bash
# Dùng bat làm fzf previewer
fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'

# Với điều chỉnh kích thước cửa sổ preview
fzf --preview 'bat --color=always {}' --preview-window=right:60%:wrap
```

Thêm vào `.bashrc` hoặc `.zshrc`:

```bash
# ~/.bashrc
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
```

### man — Trang manual có syntax highlighting

Đặt `bat` làm man pager:

```bash
# ~/.bashrc hoặc ~/.zshrc
export MANPAGER="bat -plman"

# Giờ xem trang man với syntax highlighting
man 2 select
man bash
```

### Shell Alias — Thay thế cat

Hầu hết ngườ dùng alias `cat` thành `bat` cho session tương tác:

```bash
# ~/.bashrc hoặc .zshrc
alias cat='bat --paging=never'

# Hoặc giữ cat cho script, dùng bat rõ ràng
alias b='bat'
```

Với ngườ dùng zsh, global alias có thể tô màu output `--help`:

```bash
# ~/.zshrc
alias -g -- --help='--help 2>&1 | bat --language=help --style=plain'
```

### tmux — Trình xem file cửa sổ chia

```bash
# Xem file trong tmux split mới với bat
tmux split-window -h "bat src/main.rs"
```

### delta — Git Diff nâng cao

Trong khi `bat` xử lý việc xem file, `delta` (cùng hệ sinh thái Rust CLI) xử lý việc xem diff. Ghép cặp chúng:

```bash
# ~/.gitconfig
[pager]
    diff = delta
    log = delta
    reflog = delta
    show = delta
```

## Benchmark / Use Case thực tế

### Hiệu năng khởi động

![Biểu đồ so sánh hiệu năng bat và cat trên các kích thước file khác nhau](https://raw.githubusercontent.com/sharkdp/bat/master/doc/screenshot.png)
*Dữ liệu benchmark: overhead khởi động bat chậm hơn ~100x so với cat cho file nhỏ nhưng hội tụ cho file lớn. Nguồn: sharkdp/bat GitHub community tests.*

`bat` chậm hơn `cat` do chi phí khởi động binary Rust và overhead phát hiện syntax. Đối với việc xem file tương tác, sự khác biệt không thể nhận thấy. Với xử lý hàng loạt trong vòng lặp chặt, hãy dùng `cat`.

| Kịch bản | cat | bat (mặc định) | bat --plain | bat --no-config |
|----------|-----|----------------|-------------|-----------------|
| File 4 byte | 0.001s | 0.14s | 0.10s | 0.08s |
| Python 100 dòng | 0.002s | 0.16s | 0.11s | 0.09s |
| JSON 10,000 dòng | 0.05s | 0.35s | 0.18s | 0.15s |
| Pipe đến wc -l | 0.003s | 0.004s | 0.004s | 0.004s |

*Đo trên Linux x86_64, bat 0.26.1, warm filesystem cache. Thờ gian là xấp xỉ và thay đổi theo phần cứng.*

### Chế độ Pipe Non-Interactive

Khi `bat` phát hiện terminal non-interactive (output piped), nó tự động chuyển sang chế độ plain —— khớp hành vi `cat`:

```bash
# bat tự động chuyển sang chế độ plain ở đây
cat large_file.txt | wc -l
bat large_file.txt | wc -l
# Cả hai đều chạy với tốc độ gần như giống nhau
```

### Use case hàng ngày

1. **Đọc file cấu hình**: `bat /etc/nginx/nginx.conf` —— syntax highlighting cho directive nginx, số dòng để tham chiếu.
2. **Code review**: `bat src/*.rs` —— xem nhiều file Rust với tiêu đề và đánh dấu thay đổi Git.
3. **Tạo file nhanh**: `bat > note.md` —— viết markdown với khả năng preview.
4. **Debug**: `bat -A /etc/hosts` —— hiển thị ký tự không in được với mã màu.
5. **Thuyết trình**: `bat --style=full --theme=GitHub` —— chiếu code lên màn hình với highlighting sạch, dễ đọc.

## Sử dụng nâng cao / Tối ưu Production

### Theme tùy chỉnh

`bat` đi kèm 20+ theme built-in. Liệt kê và preview:

```bash
# Liệt kê tất cả theme
bat --list-themes

# Preview theme cụ thể
bat --theme=Solarized\ (dark) --list-themes

# Đặt theme mặc định trong config
echo '--theme="Dracula"' >> "$(bat --config-file)"
```

### Định nghĩa Syntax tùy chỉnh

Thêm file Sublime Text `.sublime-syntax` cho ngôn ngữ `bat` chưa hỗ trợ:

```bash
# Tạo thư mục syntax
mkdir -p "$(bat --config-dir)/syntaxes"

# Clone hoặc copy định nghĩa syntax
cd "$(bat --config-dir)/syntaxes"
git clone https://github.com/tellnobody1/sublime-purescript-syntax

# Rebuild cache
bat cache --build

# Xác minh
bat --list-languages | grep -i purescript
```

Để reset về mặc định:

```bash
bat cache --clear
```

### Tắt tính năng để tăng tốc

Khi xử lý hàng nghìn file trong script, giảm overhead:

```bash
# Lờ gọi bat nhanh nhất cho xử lý hàng loạt
bat --no-config --style=plain --paging=never --no-custom-assets file.txt
```

### Cân nhắc bảo mật

- `bat` đọc file trong bộ nhớ; nó không thực thi code.
- Định nghĩa syntax tùy chỉnh từ nguồn không đáng tin cậy nên được audit —— chúng được parse nhưng không được thực thi.
- Flag `--diagnostic` in biến môi trường và đường dẫn config; tránh chia sẻ output này trên issue tracker công khai nếu chứa đường dẫn nhạy cảm.

### Tích hợp Docker

```dockerfile
# Dockerfile
FROM alpine:latest
RUN apk add --no-cache bat
ENTRYPOINT ["bat"]
```

```bash
# Build và sử dụng
docker build -t bat-viewer .
docker run --rm -v $(pwd):/files bat-viewer /files/README.md
```

## So sánh với các lựa chọn thay thế

| Tính năng | bat | cat | less | ccat |
|-----------|-----|-----|------|------|
| Syntax highlighting | 200+ ngôn ngữ | Không | Không | 10+ ngôn ngữ |
| Số dòng | Có | Không | Không | Không |
| Tích hợp Git | Đánh dấu thay đổi | Không | Không | Không |
| Phân trang tự động | Có | Không | Thủ công | Không |
| An toàn pipe (chế độ plain) | Có | Có | Không | Có |
| Hỗ trợ theme | 20+ theme | Không | Không | Hạn chế |
| Kích thước binary | ~3.5 MB | ~50 KB | ~120 KB | ~2 MB |
| Thờ gian khởi động (file 4B) | ~100 ms | ~1 ms | ~5 ms | ~80 ms |
| Đa nền tảng | Linux/macOS/Windows/BSD | Phổ quát | Phổ quát | Linux/macOS |
| Ngôn ngữ viết | Rust | C | C | Go |

**Hướng dẫn chọn lựa:**

- **`cat`**: Script, pipeline, nối file, hệ thống có ràng buộc kích thước cực đoan (embedded, initramfs).
- **`less`**: Xem file rất lớn (quy mô GB) nơi việc load toàn bộ file của `bat` sẽ tiêu tốn quá nhiều bộ nhớ.
- **`ccat`**: Syntax highlighting tối thiểu trên hệ thống ưu tiên binary Go hơn Rust.
- **`bat`**: Xem file tương tác, code review, thuyết trình, và mọi kịch bản nơi tính đọc được quan trọng hơn thông lượng thô.

## Hạn chế / Đánh giá khách quan

`bat` không phải công cụ phù hợp cho mọi công việc. Hiểu rõ giới hạn của nó tránh thất vọng.

**Chi phí khởi động**: Chậm hơn `cat` khoảng ~100-150x với file nhỏ, `bat` không phù hợp cho vòng lặp shell xử lý hàng nghìn file tuần tự. Dùng `cat` hoặc `--style=plain` trong những trường hợp đó.

**Sử dụng bộ nhớ**: `bat` load toàn bộ file vào bộ nhớ trước khi render. Với file log đa-GB, hãy dùng `less` hoặc `tail` thay thế.

**Phụ thuộc terminal**: Không có terminal hỗ trợ màu (hoặc khi `NO_COLOR` được đặt), `bat` degrade graceful sang plain text —— nhưng mất đi lợi thế chính.

**Không có khả năng ghi**: Khác với `cat`, `bat` không thể tạo file qua redirection một cách có ý nghĩa (`bat > file` hoạt động nhưng không có lợi thế hơn `cat`).

**Xử lý file binary**: `bat` cố gắng hiển thị file binary dưới dạng text. Dùng `cat` với flag `-v` hoặc `xxd`/`hexdump` cho việc kiểm tra binary.

## Câu hỏi thường gặp

**Q: bat có phá vỡ script hiện tại sử dụng cat không?**

Không. Khi `bat` phát hiện output của nó được pipe sang process khác (terminal non-interactive), nó tự động tắt decoration và highlighting, hoạt động giống hệt `cat`. Alias `cat='bat --paging=never'` là an toàn cho shell tương tác.

**Q: Làm thế nào vô hiệu hóa pager vĩnh viễn?**

Thêm `--paging=never` vào file config `bat`, hoặc dùng biến môi trường `BAT_PAGING=never`. Bạn cũng có thể alias `cat` thành `bat --paging=never` cho tương tác.

**Q: Tôi có thể dùng bat với sudo không?**

Được, nhưng `sudo` reset môi trường và có thể không tìm thấy `bat` bạn đã cài. Dùng đường dẫn đầy đủ: `sudo $(which bat) /etc/shadow`. Hoặc cài `bat` toàn hệ thống qua package manager.

**Q: Làm thế nào thêm hỗ trợ cho ngôn ngữ bat không nhận diện được?**

Đặt file `.sublime-syntax` vào `$(bat --config-dir)/syntaxes`, sau đó chạy `bat cache --build`. `bat` dùng cùng định nghĩa syntax với Sublime Text, nên hầu hết language package đều tương thích.

**Q: Tại sao bat hiển thị số dòng và decoration khi tôi pipe sang công cụ khác?**

Điều này thường xảy ra khi chương trình nhận cấp phát pseudo-terminal (pty). Buộc chế độ plain bằng `--style=plain` hoặc `--decorations=never`. Bạn cũng có thể pipe rõ ràng qua `bat --paging=never --style=plain`.

**Q: Làm thế nào thay đổi theme?**

Chạy `bat --list-themes` để xem theme khả dụng, sau đó đặt trong file config: `echo '--theme="TwoDark"' >> "$(bat --config-file)"`. Preview theme với `bat --theme=<tên> --list-themes`.

**Q: bat có khả dụng trên Windows không?**

Có. Cài đặt qua `scoop install bat`, `choco install bat`, hoặc tải binary prebuilt từ trang GitHub releases. Windows Terminal và PowerShell đều hỗ trợ output màu của `bat`.

## Kết luận

`bat` biến công việc xem file tẻ nhạt thành trải nghiệm hiệu quả. Syntax highlighting, Git markers, số dòng và phân trang tự động loại bỏ ma sát trong công việc terminal hàng ngày mà không hy sinh khả năng tương thích Unix. Cài đặt nó, alias `cat`, và dành ít thờ gian hơn để nhìn chằm chằm vào text thô.

**Các bước tiếp theo:**

1. Cài `bat` qua package manager (30 giây).
2. Thêm `alias cat='bat --paging=never'` vào shell config.
3. Đặt theme: `bat --list-themes` sau đó cấu hình theme bạn thích.
4. Tham gia [cộng đồng lập trình viên dibi8 trên Telegram](https://t.me/dibi8) để được giới thiệu công cụ CLI và thảo luận.



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn & Đọc thêm

- [bat GitHub Repository](https://github.com/sharkdp/bat) —— Nguồn chính thức, releases, issue tracker.
- [bat Documentation](https://github.com/sharkdp/bat#how-to-use) —— Hướng dẫn sử dụng đầy đủ và ví dụ.
- [syntect Rust Library](https://github.com/trishume/syntect) —— Engine syntax highlighting điều khiển bat.
- [delta — Git Diff Syntax Highlighter](https://github.com/dandavison/delta) —— Công cụ đồng hành cho việc xem Git diff.
- [bat-extras — Scripts bổ sung](https://github.com/eth-p/bat-extras) —— Wrappers `batgrep`, `batdiff`, `batman`.
- [TwoDark Theme Reference](https://github.com/erremauro/TwoDark) —— Theme bat phổ biến cho terminal tối.
- [So sánh với Alternatives](https://github.com/sharkdp/bat#project-goals-and-alternatives) —— So sánh chính thức từ maintainers của bat.
