---
title: 'Công Cụ Tìm Kiếm và Thay Thế Mã: Từ grep đến ripgrep, sd và Các Lựa Chọn Thay Thế Hiện Đại'
description: 'Hướng dẫn đầy đủ về công cụ tìm kiếm và thay thế code: so sánh grep, ack, ag, ripgrep, fzf, sd. Bảng benchmark, workflow thực tế và cách xây dựng bộ công cụ tìm kiếm hiệu quả.'
date: 2026-05-18 00:00:00+08:00
lastmod: 2026-05-18 00:00:00+08:00
tech_stack: []
application_domain: Dev Utils
source_version: ''
licensing_model: Open Source
license_type: MIT
file_size: ''
file_md5: ''
download_url: ''
backup_url: ''
github_repo: ''
stars: 0
maintainer: 'dibi8'
last_maintained: '2026-05-18'
featureImage: ''
draft: false
aliases:
- /posts/code-search-replace-tools-grep-modern-alternatives/
---

{</* resource-info */>}

Tìm kiếm trong codebase là một trong những thao tác thường xuyên nhất của lập trình viên. Dù là truy tìm hàm được gọi ở đâu, tìm kiếm TODO cần xử lý, hay refactor tên biến trên toàn bộ dự án — một công cụ tìm kiếm nhanh và đáng tin cậy có thể tiết kiệm hàng giờ mỗi tuần.

Từ `grep` — công cụ 50 năm tuổi có mặt trên mọi hệ thống Unix — đến [ripgrep](https://github.com/BurntSushi/ripgrep) viết bằng Rust hiện đại, [fzf](https://github.com/junegunn/fzf) mang tính tương tác, và [sd](https://github.com/chmln/sd) thay thế `sed` — hệ sinh thái công cụ tìm kiếm code đã phát triển vượt bậc. Bài viết này dẫn bạn qua lộ trình tiến hóa của công cụ tìm kiếm code và giúp xây dựng workflow tối ưu.

## Tại Sao grep Không Còn Đủ Cho Developer?

`grep` là công cụ tuyệt vờii cho việc tìm kiếm đơn giản trong một hoặc vài file. Tuy nhiên, khi làm việc với codebase hiện đại, `grep` gặp phải nhiều hạn chế:

- **Không tự động đệ quy**: Phải thêm flag `-r` hoặc kết hợp với `find`
- **Không tôn trọng .gitignore**: Tìm kiếm vào cả `node_modules/`, `.git/`, `vendor/`, tạo ra kết quả nhiễu
- **Tốc độ chậm hơn**: Không song song hóa, không tối ưu cho large codebase
- **Xử lý Unicode kém**: Gặp vấn đề với file UTF-8 có BOM
- **Output không tối ưu**: Cú pháp flags phức tạp, màu sắc cần bật thủ công

Các công cụ hiện đại sinh ra để giải quyết chính xác những vấn đề này, trong khi vẫn giữ nguyên sức mạnh của regex.

## grep: Nền Tảng Bất Diệt

### Cú Pháp Cơ Bản Và Các Flags Thông Dụng

```bash
# Tìm kiếm đơn giản
grep "pattern" file.txt

# Tìm đệ quy trong thư mục
grep -r "pattern" ./src/

# Hiển thị số dòng, tên file, màu sắc
grep -rn --color=auto "pattern" ./src/

# Tìm toàn bộ từ (word boundary)
grep -w "class" *.js

# Bỏ qua case
grep -i "error" log.txt

# Đếm số kết quả
grep -c "TODO" *.py

# Tìm file KHÔNG chứa pattern
grep -L "pattern" *.txt
```

### Khi Nào grep Vẫn Là Lựa Chọn Đúng?

- **Scripting và pipeline**: grep có mặt trên mọi hệ thống Unix, không cần cài đặt
- **Simple file search**: Tìm trong một vài file, không cần .gitignore
- **Remote servers**: SSH vào server không có ripgrep hoặc ag cài sẵn
- **POSIX compliance**: Khi cần đảm bảo script chạy trên mọi nền tảng

## ack: grep Dành Riêng Cho Developer

[ack](https://beyondgrep.com) (viết bằng Perl) là bước tiến đầu tiên trong việc tạo công cụ tìm kiếm "developer-friendly":

- **Tự động đệ quy**: Không cần flag `-r`
- **Tôn trọng .gitignore**: Tự động bỏ qua file trong `.gitignore` và các thư mục như `.git/`, `node_modules/`
- **Nhận diện file type**: `--js` tìm trong file JavaScript, `--py` cho Python, `--html` cho HTML
- **Output có màu**: Mặc định highlight kết quả
- **Hiển thị số dòng**: Mặc định

```bash
# Cài đặt
cpan App::Ack          # macOS/Linux có Perl
brew install ack       # macOS với Homebrew

# Ví dụ sử dụng
ack "class User" --js        # Tìm trong file JavaScript
ack "def " --py -C 2          # Tìm trong Python, hiển thị 2 dòng context
ack "TODO|FIXME"              # Tìm TODO hoặc FIXME
```

ack đặt nền móng cho thế hệ công cụ tiếp theo, mặc dù hiện tại đã bị vượt mặt về tốc độ.

## The Silver Searcher (ag): Tốc Độ Lên Ngôi

[The Silver Searcher](https://github.com/ggreer/the_silver_searcher) (`ag`) được viết bằng C, nhanh hơn ack từ 3-5 lần nhờ song song hóa và tối ưu hệ thống file. `ag` giữ lại tất cả ưu điểm của ack và bổ sung tốc độ.

```bash
# Cài đặt
brew install the_silver_searcher    # macOS
apt install silversearcher-ag       # Ubuntu/Debian
pacman -S the_silver_searcher       # Arch

# Cú pháp tương tự ack
ag "pattern"                        # Tìm đệ quy, tôn trọng .gitignore
ag -i "pattern"                     # Không phân biệt hoa thường
ag --js "pattern"                   # Chỉ tìm trong JavaScript
ag -l "pattern"                     # Chỉ liệt kê tên file
ag -C 3 "pattern"                   # Hiển thị 3 dòng context
```

Tuy nhiên, dự án ag hiện ít được bảo trì tích cực so với ripgrep — commit cuối cùng thường cách đây nhiều tháng.

## ripgrep (rg): Tiêu Chuẩn Mới

### Tại Sao ripgrep Thống Trị Code Search Ngày Nay?

[ripgrep](https://github.com/BurntSushi/ripgrep) (`rg`) được viết bằng Rust bởi Andrew Gallant, hiện là công cụ tìm kiếm code phổ biến nhất trong cộng đồng developer. Lý do chiếm ưu thế:

1. **Tốc độ cực nhanh**: Nhanh hơn grep 10x, nhanh hơn ag ~2-3x trong hầu hết benchmarks
2. **Song song hóa tự động**: Sử dụng tất cả CPU core có sẵn
3. **Smart defaults**: Đệ quy, hiển thị số dòng, tôn trọng .gitignore, hidden files — tất cả là mặc định
4. **Unicode support tuyệt vờii**: Xử lý đa ngôn ngữ tốt hơn bất kỳ đối thủ nào
5. **Type filtering linh hoạt**: `--type`, `--type-add` cho phép định nghĩa loại file tùy chỉnh
6. **Configuration file**: Hỗ trợ `.ripgreprc` để lưu cấu hình mặc định
7. **Integration hoàn hảo**: Backend search cho VS Code, fzf, Vim, Emacs

### Bảng Benchmark: grep vs ack vs ag vs ripgrep

| Công cụ | Ngôn ngữ | Kích thước code tìm kiếm | Thờii gian tương đối | Đệ quy mặc định | .gitignore | Unicode |
|---------|----------|------------------------|---------------------|----------------|------------|---------|
| grep | C | Linux kernel (~3GB) | 1x (baseline) | Không | Không | Hạn chế |
| ack | Perl | Linux kernel | ~0.5x grep (chậm hơn) | Có | Có | Tốt |
| ag | C | Linux kernel | ~0.2x grep | Có | Có | Tốt |
| **ripgrep** | **Rust** | **Linux kernel** | **~0.1x grep (10x nhanh)** | **Có** | **Có** | **Xuất sắc** |

> Dữ liệu benchmark từ [ripgrep GitHub repository](https://github.com/BurntSushi/ripgrep#quick-examples-comparing-tools), thử nghiệm tìm kiếm `fn run` trong Linux kernel source tree.

### Các Pattern Tìm Kiếm Thông Dụng Với ripgrep

```bash
# Tìm kiếm cơ bản — đệ quy, tôn trọng .gitignore mặc định
rg "function name"

# Tìm trong loại file cụ thể (js, py, rs, go...)
rg "class User" --type js

# Hoặc nhiều loại file
rg "import" -t py -t js

# Hiển thị context (dòng trước/sau)
rg "TODO" -C 3

# Chỉ liệt kê tên file (không nội dung)
rg "pattern" -l

# Tìm với regex
rg "^export\s+(const|let|function)"

# Tìm và thay thế (kết hợp với sd hoặc perl)
rg "oldPattern" -l | xargs sd "oldPattern" "newPattern"

# Tìm trong file ẩn (không .gitignore)
rg "pattern" --hidden

# Thêm loại file tùy chỉnh trong .ripgreprc
--type-add
web:*.{html,css,js,jsx,ts,tsx,vue}
```

### File Cấu Hình .ripgreprc

```bash
# ~/.ripgreprc
--max-columns=150
--max-columns-preview
--type-add
web:*.{html,css,js,jsx,ts,tsx,vue,svelte}
--smart-case
--follow
--hidden
--glob=!.git/
--glob=!node_modules/
--glob=!vendor/
--glob=!.next/
--glob=!dist/
```

Kết hợp với biến môi trường: `export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc`

## fzf: Cách Mạng Tìm Kiếm Tương Tác

### fzf Không Phải Công Cụ Tìm Kiếm — Nó Là Cuộc Cách Mạng

[fzf](https://github.com/junegunn/fzf) khác biệt với ripgrep ở chỗ: **fzf không quét file system**. Thay vào đó, fzf nhận một danh sách đầu vào (từ stdin) và cho phép bạn **lọc tương tác** theo thờii gian thực khi gõ. Điều này tạo ra workflow tìm kiếm hoàn hảo: một công cụ (rg, fd, find) tạo danh sách, fzf giúp bạn chọn từ danh sách đó.

### Combo ripgrep + fzf + bat: Workflow Tìm Kiếm Hoàn Hảo

```bash
# Tìm file và xem preview với syntax highlighting
rg --files | fzf --preview 'bat --style=numbers --color=always {}'

# Tìm kiếm nội dung file với preview
rg --line-number --no-heading --smart-case "pattern" | \
  fzf --delimiter ':' \
      --preview 'bat --style=numbers --color=always --highlight-line {2} {1}'

# Duyệt Git branches
 git branch | fzf --preview ' git log --oneline --graph --decorate {1}'

# Duyệt Git commits
 git log --oneline | fzf --preview ' git show --stat {1}'
```

### Key Bindings Mặc Định

| Phím tắt | Chức năng |
|----------|-----------|
| `Ctrl+T` | Chèn file đã chọn vào dòng lệnh |
| `Alt+C` | Chuyển đến thư mục đã chọn (`cd`) |
| `Ctrl+R` | Tìm kiếm tương tác trong lịch sử lệnh |
| `Tab` | Chọn nhiều mục (multi-select) |
| `Ctrl+/` | Chuyển đổi giữa match chính xác và fuzzy |

## sd: Thay Thế Find & Replace Trực Quan

### Tại Sao sd Thay Thế sed Cho Hầu Hết Tác Vụ?

[sd](https://github.com/chmln/sd) là công cụ tìm và thay thế dòng lệnh với cú pháp đơn giản hơn `sed` đáng kể:

| Tác vụ | sed | sd |
|--------|-----|-----|
| Thay thế đơn giản | `sed 's/old/new/g'` | `sd 'old' 'new'` |
| Thay thế file | `sed -i 's/old/new/g' file` | `sd 'old' 'new' file` |
| Thay thế đệ quy | `find . -exec sed -i 's/old/new/g' {} +` | `sd 'old' 'new' **/*.rs` |
| Regex phức tạp | `sed 's/\(foo\)\(bar\)/\2\1/g'` | `sd '(foo)(bar)' '$2$1'` |
| Preview trước khi áp dụng | Không có | `sd -p 'old' 'new' file` |

### Các Tính Năng Nổi Bật CủA sd

- **Không cần escape dấu `/`**: `sd 'http://localhost:3000' 'https://api.example.com'` hoạt động bình thường
- **Preview mode** (`-p`): Xem thay đổi trước khi áp dụng — cực kỳ quan trọng cho refactoring
- **Recursive**: `sd 'pattern' 'replacement' **/*.js` thay thế tất cả file JavaScript
- **Syntax regex hiện đại**: Sử dụng Rust regex engine, hỗ trợ capture groups với `$1`, `$2`

### So Sánh: sd vs sed vs perl -pi

```bash
# Thay thế đơn giản — sd rõ ràng hơn
sed -i 's/old/new/g' file.txt           # sed
sd 'old' 'new' file.txt                  # sd — đơn giản hơn
perl -pi -e 's/old/new/g' file.txt      # perl

# Thay thế có dấu / trong pattern
sed -i 's/http:\/\/localhost/http:\/\/127.0.0.1/g' file  # sed — escape hỗn loạn
sd 'http://localhost' 'http://127.0.0.1' file             # sd — không cần escape

# Thay thế recursive trong nhiều file
find . -name "*.js" -exec sed -i 's/var/const/g' {} +     # sed
sd 'var' 'const' **/*.js                                   # sd
```

## Tìm Kiếm Trong IDE Và Editor Hiện Đại

### VS Code: Global Search Với Regex

VS Code sử dụng ripgrep làm backend cho tính năng global search (`Ctrl+Shift+F`), hỗ trợ regex, include/exclude patterns, và replace across files. Điểm mạnh: tích hợp sâu với refactoring — sau khi tìm, bạn có thể rename symbol hoặc extract function ngay lập tức.

### JetBrains: Structural Search And Replace

Các IDE của JetBrains (IntelliJ IDEA, PyCharm, WebStorm) cung cấp **Structural Search and Replace** (SSR) — tìm kiếm dựa trên cấu trúc cú pháp AST thay vì text thuần. Ví dụ, bạn có thể tìm "tất cả vòng lặp for có 3 statements trong body" hoặc "tất cả hàm gọi method X với argument kiểu String" — những truy vấn không thể thực hiện bằng regex.

### NeoVim: Telescope Với Live Grep

Trong hệ sinh thái NeoVim, [Telescope](https://github.com/nvim-telescope/telescope.nvim) kết hợp với ripgrep tạo ra trải nghiệm tìm kiếm code tuyệt vờii ngay trong editor. `Telescope live_grep` tìm kiếm toàn bộ project theo thờii gian thực khi bạn gõ.

## Các Nền Tảng Tìm Kiếm Code Quy Mô Lớn

### Sourcegraph: Nền Tảng Trí Tuệ Code

[Sourcegraph](https://about.sourcegraph.com) là nền tảng tìm kiếm và phân tích code dành cho doanh nghiệp, hỗ trợ tìm kiếm across hàng nghìn repository. Tính năng nổi bật: **code intelligence** (hover để xem definition, references), **batch changes** (refactoring trên quy mô lớn), và **Code Insights** (theo dõi xu hướng code theo thờii gian). Sourcegraph miễn phí cho team nhỏ (dưới 10 users); gói Enterprise có giá tùy chỉnh.

### GitHub Code Search

GitHub cung cấp [Code Search](https://github.com/features/code-search) mới với regex support, symbol search, và path filtering. Ví dụ: `language:rust repo:tokio-rs/tokio fn spawn` tìm hàm `spawn` trong repository tokio, giới hạn file Rust. Đây là công cụ miễn phí và mạnh mẽ cho việc tìm kiếm trong mã nguồn mở.

### Livegrep: Tìm Kiếm Regex Trên Codebase Khổng Lồ

[Livegrep](https://github.com/livegrep/livegrep) là công cụ tự host cho phép tìm kiếm regex trên codebase lớn (hàng triệu dòng code) gần như tức thờii. Được sử dụng nội bộ tại nhiều công ty lớn như Stripe và Google. Livegrep phù hợp cho tổ chức có codebase monorepo lớn cần tìm kiếm nhanh.

## Các Workflow Tìm Kiếm Thực Tế

### Workflow Hàng Ngày: rg + fzf + bat

```bash
# 1. Tìm kiếm file
eza --files | fzf --preview 'bat --style=numbers --color=always {}'

# 2. Tìm kiếm nội dung
grep_func() {
  rg --line-number --no-heading --color=always "$1" | \
    fzf --ansi --delimiter ':' --preview 'bat --style=numbers --color=always --highlight-line {2} {1}'
}

# 3. Xem nội dung file
cat() { bat "$@"; }
```

### Workflow Refactoring Hàng Loạt: rg + sd

```bash
# Bước 1: Tìm tất cả file chứa pattern cần thay đổi
rg "oldFunctionName" -l

# Bước 2: Xem preview thay đổi
sd -p "oldFunctionName" "newFunctionName" $(rg "oldFunctionName" -l)

# Bước 3: Áp dụng thay đổi
sd "oldFunctionName" "newFunctionName" $(rg "oldFunctionName" -l)

# Bước 4: Kiểm tra bằng test
 npm test
```

### Tìm Kiếm Lịch Sử Git

```bash
# Tìm commit thêm/xóa một dòng code cụ thể
 git log -S "function name" --oneline

# Tìm commit thay đổi một pattern regex
 git log -G "pattern" --oneline

# Tìm trong tất cả các branch
 git grep "pattern" $( git branch -a | cut -c3- )

# Tìm khi một file được đề cập
 git log --all --full-history -- "**/config.ts"
```

## Kết Luận: Xây Dựng Bộ Công Cụ Tìm Kiếm CủA Bạn

Bộ công cụ tìm kiếm code hiệu quả nhất năm 2025 gồm ba thành phần cốt lõi:

1. **ripgrep** (`rg`): Tìm kiếm code siêu tốc trên toàn bộ codebase
2. **fzf**: Lọc và chọn tương tác từ bất kỳ danh sách nào
3. **sd**: Thay thế text đơn giản, trực quan hơn sed

Kết hợp ba công cụ này với **bat** (cat nâng cao) tạo ra workflow tìm kiếm và duyệt code mượt mà mà không cần rờii terminal. Bổ sung **GitHub Code Search** hoặc **Sourcegraph** khi cần tìm kiếm across nhiều repository hoặc codebase monorepo khổng lồ.

Tương lai của code search đang hướng về **AI-powered search** — các công cụ như GitHub Copilot Chat cho phép tìm kiếm bằng ngôn ngữ tự nhiên ("tìm hàm xử lý authentication trong project này"). Tuy nhiên, công cụ CLI truyền thống vẫn sẽ giữ vị trí không thể thay thế nhờ tốc độ, độ tin cậy, và khả năng tích hợp vào workflow tự động hóa.

## FAQ

### ripgrep có nhanh hơn grep không?

Có, ripgrep nhanh hơn grep khoảng 10 lần trong hầu hết các tình huống tìm kiếm codebase thực tế. Sự khác biệt đến từ: (1) ripgrep song song hóa mặc định sử dụng nhiều CPU core; (2) ripgrep tôn trọng .gitignore nên quét ít file hơn; (3) ripgrep được viết bằng Rust với memory management tối ưu. Tuy nhiên, grep vẫn có mặt trên mọi hệ thống và không cần cài đặt.

### Công cụ nào tốt nhất để tìm kiếm code trong nhiều file?

ripgrep (`rg`) là lựa chọn tốt nhất cho tìm kiếm code trong nhiều file nhờ tốc độ nhanh, tôn trọng .gitignore, và cú pháp đơn giản. Kết hợp với fzf để có trải nghiệm tương tác. Nếu cần tìm kiếm across nhiều repository, GitHub Code Search hoặc Sourcegraph là lựa chọn phù hợp.

### Làm thế nào để thay thế text trong nhiều file từ dòng lệnh?

Sử dụng **sd** cho cú pháp đơn giản nhất: `sd "oldText" "newText" $(rg "oldText" -l)`. Lệnh `rg -l` liệt kê tất cả file chứa pattern, sau đó sd thay thế trong từng file. Luôn thêm flag `-p` (preview) trước để xem thay đổi: `sd -p "old" "new" $(rg "old" -l)`. Nếu không có sd, dùng `perl -pi -e 's/old/new/g' $(rg "old" -l)`.

### Có thể dùng ripgrep với VS Code không?

VS Code đã sử dụng ripgrep làm backend cho tính năng tìm kiếm mặc định (global search và file search). Bạn không cần cấu hình gì thêm. Trong terminal tích hợp của VS Code, bạn có thể cài ripgrep và sử dụng trực tiếp. Ngoài ra, extension "ripgrep" cho phép tìm kiếm nâng cao với các tùy chọn ripgrep từ command palette.

### ack, ag và rg khác nhau như thế nào?

Đây là ba thế hệ công cụ tìm kiếm code: **ack** (Perl, ~2006) là ngườii tiên phong với .gitignore support và file type detection; **ag — The Silver Searcher** (C, ~2011) nhanh hơn ack 3-5x nhờ song song hóa; **ripgrep** (Rust, ~2016) nhanh hơn tất cả, hỗ trợ Unicode tốt hơn, và được bảo trì tích cực nhất. Ngày nay, **ripgrep là lựa chọn được khuyến nghị** cho hầu hết use case.

## Tài Liệu Tham Khảo

- [ripgrep GitHub Repository](https://github.com/BurntSushi/ripgrep)
- [fzf GitHub Repository](https://github.com/junegunn/fzf)
- [sd GitHub Repository](https://github.com/chmln/sd)
- [ack — Beyond grep](https://beyondgrep.com)
- [The Silver Searcher GitHub](https://github.com/ggreer/the_silver_searcher)
- [Sourcegraph](https://about.sourcegraph.com)
- [GitHub Code Search](https://github.com/features/code-search)
- [Livegrep GitHub Repository](https://github.com/livegrep/livegrep)

---

## Hạ Tầng Đề Xuất

Để chạy các công cụ trên 24/7 ổn định, lựa chọn hạ tầng rất quan trọng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — $200 tín dụng miễn phí 60 ngày, 14+ region toàn cầu.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp. dibi8.com cũng host ở đây.
- **[Hostinger](https://www.hostinger.com/vn?REFERRALCODE=22RPIAOJIYJN)** — VPS giá tốt cho thị trường Việt Nam.

*Đây là affiliate link, không tăng chi phí của bạn nhưng giúp dibi8.com duy trì hoạt động.*

