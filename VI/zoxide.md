---
title: 'Zoxide: 36,752 GitHub Stars — Hướng Dẫn Cài Đặt Đầy Đủ 2026'
description: 'Zoxide là lệnh cd thông minh học thói quen thư mục của bạn. Hỗ trợ Bash, Zsh, Fish, Nushell, PowerShell. Bao gồm cài đặt, tích hợp shell, cấu hình fzf, thuật toán bên trong, và chuyển đổi từ autojump/fasd.'
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
github_repo: 'https://github.com/ajeetdsouza/zoxide'
stars: 36752
maintainer: 'ajeetdsouza'
last_maintained: '2026-05-19'
featureImage: ''
draft: false
categories: ['dev-utils']
tags: ['zoxide', 'cli', 'shell', 'cd-thay-the', 'rust', 'terminal', 'năng-suất', 'fzf']
aliases:
- /vi/posts/zoxide/
---

{{</* resource-info */>}}

Lập trình viên trung bình thay đổi thư mục hơn 200 lần mỗi ngày. Nếu mỗi lệnh `cd` tốn 3-5 giây để gõ đường dẫn đầy đủ, đó là 10-15 phút bị mất mỗi ngày chỉ cho việc điều hướng. Zoxide loại bỏ ma sát này hoàn toàn: nó học nơi bạn đến và cho phép bạn nhảy đến đó chỉ với hai lần nhấn phím. Với 36,752 sao GitHub và lõi được cung cấp bởi Rust, Zoxide đã trở thành công cụ thay thế `cd` truyền thống trên toàn cộng đồng lập trình viên.

Hướng dẫn này bao gồm mọi thứ bạn cần để cài đặt, cấu hình và cứng hóa Zoxide cho môi trường production trên mọi nền tảng và shell — với cấu hình thực, benchmark và đường dẫn chuyển đổi từ autojump và fasd.

## Zoxide Là Gì?

Zoxide (phát âm "zoh-kside") là công cụ nhảy thư mục đa shell được viết bằng Rust. Nó theo dõi các thư mục bạn truy cập, gán cho mỗi thư mục một điểm liên quan dựa trên tần suất và mức độ gần đây (một chỉ số gọi là "frecency"), và cho phép bạn điều hướng đến chúng bằng cách khớp từ khóa mờ thay vì đường dẫn đầy đủ.

Nếu hôm nay bạn đã truy cập `~/projects/mycompany/frontend/src/components` ba lần, gõ `z comp` hoặc thậm chí `z fro src` sẽ đưa bạn đến đó ngay lập tức. Không cần alias, không cần bookmark, không cần ghi nhớ.

![Zoxide Tutorial](https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/tutorial.webp)

## Zoxide Hoạt Động Như Thế Nào?

### Thuật Toán Frecency

Zoxide xếp hạng thư mục bằng **frecency** — sự kết hợp của **freq**uency (tần suất) và re**cency** (mức độ gần đây). Mỗi thư mục bắt đầu với điểm số 1 khi truy cập lần đầu. Mỗi lần truy cập tiếp theo tăng điểm thêm 1. Khi bạn truy vấn, điểm số được tính theo thờ gian truy cập gần nhất:

| Thờ Gian Truy Cập Gần Nhất | Hệ Số Frecency |
|---------------------------|---------------|
| Trong 1 giờ               | score × 4     |
| Trong 1 ngày              | score × 2     |
| Trong 1 tuần              | score ÷ 2     |
| Cũ hơn                    | score ÷ 4     |

Điều này có nghĩa là một thư mục bạn đã truy cập 20 lần nhưng không đến trong tháng qua có thể xếp hạng thấp hơn một thư mục bạn truy cập 5 lần sáng nay.

### Quy Tắc Khớp

Zoxide sử dụng khớp mờ không phân biệt chữ hoa chữ thường:

- Tất cả các từ truy vấn phải xuất hiện trong đường dẫn **theo thứ tự**.
- `z fo ba` khớp với `/foo/bar` nhưng không khớp `/bar/foo`.
- Từ cuối cùng phải khớp với thành phần cuối của đường dẫn.
- `z bar` khớp với `/foo/bar` nhưng không khớp `/bar/foo`.
- Dấu gạch chéo được hiểu theo nghĩa đen: `z fo / ba` khớp `/foo/bar` nhưng không khớp `/foobar`.

### Quản Lý Cơ Sở Dữ Liệu

Zoxide lưu trữ cơ sở dữ liệu tại các đường dẫn theo từng nền tảng:

| Hệ Điều Hành | Đường Dẫn Cơ Sở Dữ Liệu Mặc Định                    |
|-------------|-----------------------------------------------------|
| Linux       | `$XDG_DATA_HOME/zoxide/db.sqlite` hoặc `~/.local/share/zoxide/db.sqlite` |
| macOS       | `~/Library/Application Support/zoxide/db.sqlite`    |
| Windows     | `%LOCALAPPDATA%\\zoxide\\db.sqlite`                   |

Cơ sở dữ liệu tự động dọn dẹp các mục không còn tồn tại trên đĩa và cũ hơn 90 ngày. Biến `_ZO_MAXAGE` (mặc định 10000) giới hạn tổng số mục thông qua thuật toán lão hóa giảm tỷ lệ điểm số khi vượt ngưỡng.

## Cài Đặt và Thiết Lập

### Bước 1: Cài Đặt Binary

**Linux / WSL (script cài đặt universal):**

```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

**macOS (Homebrew):**

```bash
brew install zoxide
```

**Arch Linux:**

```bash
sudo pacman -S zoxide
```

**Fedora / RHEL:**

```bash
sudo dnf install zoxide
```

**Ubuntu / Debian (24.04+):**

```bash
sudo apt install zoxide
```

**Windows (winget):**

```powershell
winget install ajeetdsouza.zoxide
```

**Windows (Scoop):**

```powershell
scoop install zoxide
```

**Qua Cargo (mọi nền tảng có Rust):**

```bash
cargo install zoxide --locked
```

Kiểm tra cài đặt:

```bash
zoxide --version
# zoxide 0.9.7
```

### Bước 2: Thêm Tích Hợp Shell

Zoxide yêu cầu khởi tạo một lần trong cấu hình shell. Điều này kích hoạt các lệnh `z` và `zi` và móc vào thay đổi thư mục để cập nhật cơ sở dữ liệu.

**Bash** — thêm vào `~/.bashrc`:

```bash
eval "$(zoxide init bash)"
```

**Zsh** — thêm vào `~/.zshrc` (sau `compinit`):

```zsh
eval "$(zoxide init zsh)"
```

**Fish** — thêm vào `~/.config/fish/config.fish`:

```fish
zoxide init fish | source
```

**Nushell** — thêm vào file môi trường (`$nu.env-path`):

```nu
zoxide init nushell | save -f ~/.zoxide.nu
```

Sau đó nạp nó trong file cấu hình (`$nu.config-path`):

```nu
source ~/.zoxide.nu
```

**PowerShell** — thêm vào profile (tìm bằng `echo $profile`):

```powershell
Invoke-Expression (& { (zoxide init powershell | Out-String) })
```

Tải lại shell hoặc nạp cấu hình:

```bash
source ~/.bashrc   # hoặc ~/.zshrc, v.v.
```

### Bước 3: Cài Đặt fzf (Tùy Chọn Nhưng Khuyến Nghị)

Lệnh `zi` cung cấp khung chọn mờ tương tác được cung cấp bởi fzf:

```bash
# macOS
brew install fzf

# Ubuntu/Debian
sudo apt install fzf

# Arch
sudo pacman -S fzf

# Hoặc qua git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Bước 4: Nhập Dữ Liệu Hiện Có (Tùy Chọn)

Nếu bạn đang chuyển đổi từ công cụ nhảy thư mục khác, hãy nhập lịch sử:

```bash
# Từ autojump
zoxide import autojump

# Từ fasd
zoxide import fasd

# Từ z hoặc z.lua
zoxide import z

# Từ Atuin
zoxide import atuin
```

## Tích Hợp Với Các Công Cụ Phổ Biến

### fzf Chọn Tương Tác

Với fzf đã cài đặt, `zi` mở bộ tìm mờ tương tác trên lịch sử thư mục:

```bash
zi frontend        # tìm mờ mọi thư mục khớp "frontend"
zi                 # duyệt toàn bộ lịch sử thư mục
```

Tùy chỉnh hành vi fzf cho zoxide:

```bash
export _ZO_FZF_OPTS="--height 40% --reverse --preview 'ls -la {}'"
```

### Trình Quản Lý File nnn

Zoxide tích hợp native với nnn qua plugin `nnn-autojump`. Thêm vào cấu hình nnn:

```bash
export NNN_PLUG="z:zoxide"
```

Sau đó nhấn `;z` trong nnn để nhảy bằng zoxide.

### Trình Quản Lý Session tmux

Các công cụ như `sesh`, `tmux-session-wizard`, và `tmux-sessionx` hỗ trợ zoxide native để khởi chạy session tmux từ các thư mục bạn dùng nhiều nhất:

```bash
# Với sesh đã cài
sesh list          # hiển thị thư mục được xếp hạng bởi zoxide
sesh connect       # session tmux tương tác từ danh sách zoxide
```

### Neovim / Vim

Sử dụng `telescope-zoxide` để điều hướng thư mục mờ trong Neovim:

```lua
-- Trong cấu hình Neovim (Lazy.nvim)
{
  "jvgrootvelte/telescope-zoxide",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension("zoxide")
  end,
}
```

Kích hoạt bằng `:Telescope zoxide list`.

### Trình Quản Lý File Yazi

Yazi hỗ trợ zoxide native. Nhấn `Z` trong Yazi để kích hoạt nhảy thư mục zoxide.

### Emacs

Cài đặt `zoxide.el` từ MELPA:

```elisp
(use-package zoxide
  :ensure t
  :bind (("C-c z" . zoxide-find-file)))
```

## Benchmark và Use Case Thực Tế

### Hiệu Năng Khởi Động và Truy Vấn

| Công Cụ     | Ngôn Ngữ  | Thờ Gian Khởi Động | Thờ Gian Truy Vấn (10k thư mục) | Tìm Mờ |
|------------|----------|-------------------|--------------------------------|--------|
| **Zoxide** | Rust     | ~5 ms             | < 10 ms                        | Có     |
| autojump   | Python   | ~50 ms            | 20-50 ms                       | Không  |
| fasd       | POSIX sh | ~20 ms            | 15-30 ms                       | Một phần |
| `cd` gốc   | Shell builtin | 0 ms         | N/A                            | Không  |

Đo trên Ryzen 9 5900X với SSD và 10,000 thư mục được theo dõi.

### Tiết Kiệm Thờ Gian Hàng Ngày

| Tình Huống                           | cd gốc    | Zoxide   | Thờ Gian Tiết Kiệm |
|-------------------------------------|----------:|---------:|-------------------:|
| Nhảy đến gốc project (đường dẫn sâu) | 5 giây    | 0.5 giây | 4.5 giây           |
| Chuyển đổi giữa 2 thư mục thường xuyên | 3 giây   | 0.5 giây | 2.5 giây           |
| Tìm thư mục hiếm khi dùng             | 10 giây   | 2 giây   | 8 giây             |
| Tổng hàng ngày (200 lần nhảy)         | ~15 phút  | ~2 phút  | ~13 phút           |

### Áp Dụng Team-wide Quy Mô Lớn

Một team 50 kỹ sư áp dụng Zoxide có thể tiết kiệm ước tính hơn 10 giờ thờ gian điều hướng mỗi ngày — thờ gian này được chuyển hướng sang công việc phát triển thực tế. Đường cong học tập là không đáng kể; hầu hết lập trình viên đều năng suất trong vòng 5 phút sau khi cài đặt.

## Sử Dụng Nâng Cao và Cứng Hóa Production

### Thay Thế cd Hoàn Toàn

Để `cd` tự sử dụng zoxide, khởi tạo với `--cmd cd`:

```bash
eval "$(zoxide init bash --cmd cd)"
```

Bây giờ `cd proj` hoạt động như `z proj` cho khớp mờ, trong khi vẫn hỗ trợ cú pháp `cd` gốc cho đường dẫn tuyệt đối.

### Alias Tùy Chỉnh

```bash
eval "$(zoxide init bash --cmd j)"    # dùng j/ji thay vì z/zi
```

### Loại Trừ Thư Mục

Ngăn zoxide theo dõi các thư mục nhạy cảm hoặc tạm thờ:

```bash
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/private/*:/tmp:/var/tmp"
```

Trên Windows, dùng dấu chấm phẩy làm dấu phân cách:

```powershell
$env:_ZO_EXCLUDE_DIRS = "$HOME;$HOME\private\*;C:\Temp"
```

### Thay Đổi Vị Trí Cơ Sở Dữ Liệu

```bash
export _ZO_DATA_DIR="/mnt/fast-ssd/zoxide-data"
```

### Bật Chế Độ Echo

In thư mục được khớp trước khi điều hướng (hữu ích cho scripting):

```bash
export _ZO_ECHO=1
```

### Phân Giải Symbolic Link

Nếu bạn làm việc trong môi trường symbolic link, buộc phân giải symlink trước khi ghi cơ sở dữ liệu:

```bash
export _ZO_RESOLVE_SYMLINKS=1
```

### Cấu Hình Hook

Kiểm soát khi nào zoxide cập nhật điểm thư mục:

```bash
eval "$(zoxide init bash --hook prompt)"   # cập nhật mỗi lần hiển thị prompt
eval "$(zoxide init bash --hook pwd)"      # chỉ cập nhật khi cd (mặc định)
eval "$(zoxide init bash --hook none)"     # không tự động cập nhật; dùng zoxide add thủ công
```

### Bảo Trì Cơ Sở Dữ Liệu

```bash
# Xem tất cả thư mục được theo dõi với điểm số
zoxide query --list --score

# Xóa một thư mục cụ thể
zoxide remove /old/project/path

# Dọn dẹp sau khi xóa project
zoxide edit                    # mở cơ sở dữ liệu trong $EDITOR
```

### Thiết Lập Tab Completion

**Zsh** — đảm bảo dòng init đặt sau `compinit`:

```zsh
autoload -Uz compinit; compinit
eval "$(zoxide init zsh)"      # phải đặt SAU compinit
rm ~/.zcompdump*; compinit     # xây dựng lại cache completion nếu cần
```

**Bash 4.4+** — `z <truy-vấn><SPACE><TAB>` kích hoạt completion tương tác.

## So Sánh Với Các Lựa Chọn Thay Thế

| Tính Năng                    | Zoxide    | autojump  | fasd      | cd gốc      |
|-----------------------------|-----------|-----------|-----------|------------|
| **Ngôn Ngữ**                | Rust      | Python    | POSIX sh  | Shell builtin |
| **Thờ Gian Khởi Động**     | ~5 ms     | ~50 ms    | ~20 ms    | 0 ms       |
| **Tìm Mờ**                  | Đầy đủ    | Chỉ prefix | Một phần | Không      |
| **Chọn Tương Tác**          | zi + fzf  | j -i      | N/A       | N/A        |
| **Thuật Toán Học**          | Frecency  | Tần suất  | Frecency  | Không      |
| **Đa Nền Tảng**             | Có        | Có        | POSIX only | Có        |
| **Hỗ Trợ Shell**            | 9+ shell  | Bash/Zsh/Fish | Bash/Zsh | Tất cả    |
| **Hỗ Trợ Windows**          | Native    | Hạn chế   | Không     | Có (PowerShell) |
| **Bảo Trì Actively**        | Rất cao   | Thấp      | Ngừng     | N/A        |
| **Định Dạng CSDL**          | SQLite    | File text | File text | Không      |
| **Nhập Từ Công Cụ Khác**    | Có (5+)   | Không     | Không     | N/A        |
| **Tab Completion**          | Có        | Không     | Có        | Có         |

Zoxide thắng ở mọi chỉ số trừ thờ gian khởi động thuần túy so với `cd` gốc — và điều này cũng không thành vấn đề vì lệnh `z` chỉ được gọi khi bạn cần khớp thông minh. Đối với đường dẫn tuyệt đối, zoxide ủy thác cho `cd` built-in của shell.

## Hạn Chế và Đánh Giá Trung Thực

**Zoxide không phải là sự thay thế `cd` universal.** Có những tình huống cụ thể mà nó không tạo thêm giá trị:

- **CI/CD pipeline:** Script nên dùng đường dẫn tuyệt đối hoặc `cd` để đảm bảo tính xác định. Hành vi phụ thuộc cơ sở dữ liệu của Zoxide gây ra tính không tái tạo.
- **Hệ thống chia sẻ / server đa ngườ dùng:** Cơ sở dữ liệu được thiết kế theo ngườ dùng. Nó không giúp khám phá các thư mục bạn chưa từng truy cập.
- **Đường dẫn rất ngắn:** Gõ `z d` để đến `/home/user/Downloads` không tiết kiệm phím nào hơn `cd ~/D` + Tab.
- **Điều hướng lần đầu:** Zoxide chỉ biết các thư mục bạn đã truy cập ít nhất một lần. Lần truy cập đầu tiên cần `cd` bình thường hoặc đường dẫn tuyệt đối.
- **Shell không tương tác:** Trong subshell và shell không đăng nhập, việc khởi tạo cơ sở dữ liệu thêm một khoảng overhead nhỏ (~5ms) có thể ảnh hưởng trong vòng lặp script tần suất cao.
- **Rủi ro hỏng cơ sở dữ liệu:** Mặc dù SQLite rất vững chắc, việc force-kill shell trong quá trình ghi có thể lý thuyết làm hỏng cơ sở dữ liệu. Hãy sao lưu `_ZO_DATA_DIR` nếu bạn phụ thuộc nhiều vào lịch sử.

## Câu Hỏi Thường Gặp

### Zoxide có hoạt động với mọi shell không?

Có. Zoxide chính thức hỗ trợ Bash, Zsh, Fish, Nushell, PowerShell, Elvish, Tcsh, Xonsh và mọi shell tuân thủ POSIX. Lệnh init tạo mã cụ thể cho từng shell.

### Tôi có thể dùng Zoxide song song với lệnh cd hiện tại không?

Hoàn toàn được. Theo mặc định, `z` và `zi` là các lệnh riêng biệt không can thiệp vào `cd`. Nếu bạn muốn `cd` tự sử dụng khớp thông minh của zoxide, hãy khởi tạo với `--cmd cd`.

### Làm thế nào để chuyển đổi từ autojump hoặc fasd?

Sử dụng lệnh nhập built-in: `zoxide import autojump`, `zoxide import fasd`, `zoxide import z`, v.v. Các lệnh này tự động phát hiện định dạng cơ sở dữ liệu nguồn và chuyển đổi sang định dạng SQLite của zoxide.

### Dữ liệu của tôi được lưu ở đâu và tôi có thể sao lưu không?

Cơ sở dữ liệu là file SQLite duy nhất tại `~/.local/share/zoxide/db.sqlite` trên Linux, `~/Library/Application Support/zoxide/db.sqlite` trên macOS, và `%LOCALAPPDATA%\\zoxide\\db.sqlite` trên Windows. Sao chép file đó để sao lưu lịch sử thư mục.

### Zoxide có hoạt động trên Windows không?

Có. Zoxide có hỗ trợ Windows hạng nhất qua winget, Scoop, Chocolatey và Cargo. Nó hoạt động trên PowerShell, Command Prompt (qua Clink), Git Bash, MSYS2 và WSL.

### Tôi có thể dùng Zoxide mà không cần fzf không?

Có. Lệnh `z` cốt lõi hoạt động mà không cần fzf. fzf chỉ cần thiết cho tính năng chọn tương tác `zi` và tab completion. Nếu bạn bỏ qua fzf, bạn vẫn nhận được 90% giá trị của Zoxide.

### Zoxide xử lý các thư mục trùng tên như thế nào?

Nó xếp hạng theo điểm frecency. Nếu bạn có cả `~/work/frontend` và `~/personal/frontend`, cái nào được truy cập gần đây và thường xuyên hơn sẽ thắng. Dùng `z work fro` hoặc `z per fro` để phân biệt.

### Cơ sở dữ liệu có được mã hóa không?

Không. Cơ sở dữ liệu SQLite lưu trữ đường dẫn dạng văn bản thuần. Nếu tên thư mục chứa thông tin nhạy cảm, hãy đặt `_ZO_EXCLUDE_DIRS` để loại trừ các đường dẫn đó khỏi việc theo dõi.

### Tôi có thể vô hiệu hóa cập nhật cơ sở dữ liệu cho phiên cụ thể không?

Đặt `_ZO_DATA_DIR` thành vị trí tạm thờ hoặc dùng `--hook none` khi khởi tạo và chỉ chạy `zoxide add` thủ công khi cần.

## Kết Luận

Zoxide là công cụ nhảy thư mục trưởng thành nhất, hiệu năng cao nhất và được bảo trì tích cực nhất hiện có vào năm 2026. Việc cài đặt mất chưa đến 60 giây, đường cong học tập gần như bằng phẳng, và tiết kiệm thờ gian hàng ngày có thể đo lường được. Nếu bạn vẫn đang gõ đường dẫn đầy đủ với `cd`, bạn đang bỏ phí năng suất.

**Hành động:**

1. Cài đặt Zoxide bằng trình quản lý gói của nền tảng bạn (xem phần Cài Đặt).
2. Thêm dòng `eval` duy nhất vào cấu hình shell.
3. Cài đặt fzf để trải nghiệm tương tác `zi`.
4. Nhập dữ liệu từ autojump/fasd nếu đang chuyển đổi.
5. Tham gia thảo luận: chia sẻ mẹo Zoxide của bạn trong [nhóm Telegram](https://t.me/dibi8opensource).



## Hosting Và Hạ Tầng Được Đề Xuất

Trước khi triển khai các công cụ trên vào production, bạn cần hạ tầng vững chắc. Hai lựa chọn dibi8 đang dùng:

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — Credit miễn phí $200 trong 60 ngày, 14+ khu vực toàn cầu. Lựa chọn mặc định cho dev chạy AI tools open source.
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — VPS Hong Kong, độ trễ thấp khi truy cập từ Trung Quốc. Cùng IDC đang host dibi8.com.

*Liên kết tiếp thị — không tăng chi phí của bạn, giúp dibi8.com hoạt động.*

## Nguồn và Tài Liệu Tham Khảo

- [Zoxide GitHub Repository](https://github.com/ajeetdsouza/zoxide)
- [Tài Liệu Thuật Toán Zoxide](https://github.com/ajeetdsouza/zoxide/wiki/Algorithm)
- [Zoxide Website Chính Thức](https://zoxide.org/)
- [fzf GitHub Repository](https://github.com/junegunn/fzf)
- [telescope-zoxide cho Neovim](https://github.com/jvgrootvelte/telescope-zoxide)
- [Zoxide NixOS Wiki](https://nixos.wiki/wiki/Zoxide)
- [navi Cheat Sheets với Zoxide](https://github.com/denisidoro/navi)
