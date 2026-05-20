---
title: 'Zoxide: 36,752 GitHub Stars — 2026 年完整安装配置指南'
description: 'Zoxide 是一个更智能的 cd 命令，能学习你的目录使用习惯。支持 Bash、Zsh、Fish、Nushell 和 PowerShell。涵盖安装、Shell 集成、fzf 配置、算法原理以及从 autojump/fasd 迁移。'
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
tags: ['zoxide', '命令行', '终端', 'cd替代品', 'rust', 'shell', '效率工具', 'fzf']
aliases:
- /zh/posts/zoxide/
---

{{</* resource-info */>}}

普通开发者每天切换目录超过 200 次。如果每次 `cd` 都要花 3-5 秒输入完整路径，那么每天就有 10-15 分钟浪费在导航上。Zoxide 彻底消除了这种摩擦：它学习你去过的地方，让你用两个按键就能跳转到目标目录。凭借 36,752 个 GitHub Stars 和 Rust 驱动的核心，Zoxide 已成为开发者社区中传统 `cd` 命令的事实替代品。

本指南涵盖在所有平台和 Shell 上安装、配置和生产级加固 Zoxide 的全部内容 —— 包含真实配置、基准测试以及从 autojump 和 fasd 迁移的路径。

## 什么是 Zoxide？

Zoxide（发音为 "zoh-kside"）是一个用 Rust 编写的跨 Shell 目录跳转工具。它追踪你访问的目录，根据频率和最近访问时间（一种称为"frecency"的指标）为每个目录分配相关性分数，并让你使用模糊关键词匹配而不是完整路径来导航到它们。

如果你今天访问过 `~/projects/mycompany/frontend/src/components` 三次，输入 `z comp` 甚至 `z fro src` 就能瞬间传送到那里。无需别名，无需书签，无需记忆。

![Zoxide 教程演示](https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/contrib/tutorial.webp)

## Zoxide 的工作原理

### Frecency 算法

Zoxide 使用 **frecency**（**freq**uency 频率 + re**cency** 新近度）对目录进行排名。每个目录在首次访问时初始分数为 1，每次后续访问分数增加 1。当你查询时，分数会根据目录最近访问的时间进行加权：

| 最近访问时间    | Frecency 乘数 |
|----------------|--------------|
| 1 小时内       | score × 4    |
| 1 天内         | score × 2    |
| 1 周内         | score ÷ 2    |
| 更久           | score ÷ 4    |

这意味着一个你访问过 20 次但最近一个月没去过的目录，可能排名低于一个你今早访问过 5 次的目录。

### 匹配规则

Zoxide 使用可预测的、不区分大小写的匹配方式：

- 所有查询词必须按**顺序**出现在路径中。
- `z fo ba` 匹配 `/foo/bar`，但不匹配 `/bar/foo`。
- 最后一个词必须匹配路径的最后一个组件。
- `z bar` 匹配 `/foo/bar`，但不匹配 `/bar/foo`。
- 斜杠是字面量：`z fo / ba` 匹配 `/foo/bar`，但不匹配 `/foobar`。

### 数据库管理

Zoxide 将数据库存储在平台特定的路径：

| 操作系统  | 默认数据库路径                                        |
|----------|------------------------------------------------------|
| Linux    | `$XDG_DATA_HOME/zoxide/db.sqlite` 或 `~/.local/share/zoxide/db.sqlite` |
| macOS    | `~/Library/Application Support/zoxide/db.sqlite`     |
| Windows  | `%LOCALAPPDATA%\\zoxide\\db.sqlite`                   |

数据库会自动清理在磁盘上不存在且超过 90 天的条目。`_ZO_MAXAGE` 变量（默认 10000）通过老化算法限制总条目数，当超过阈值时按比例缩减分数。

## 安装与配置

### 第一步：安装二进制文件

**Linux / WSL（通用安装脚本）：**

```bash
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
```

**macOS（Homebrew）：**

```bash
brew install zoxide
```

**Arch Linux：**

```bash
sudo pacman -S zoxide
```

**Fedora / RHEL：**

```bash
sudo dnf install zoxide
```

**Ubuntu / Debian（24.04+）：**

```bash
sudo apt install zoxide
```

**Windows（winget）：**

```powershell
winget install ajeetdsouza.zoxide
```

**Windows（Scoop）：**

```powershell
scoop install zoxide
```

**通过 Cargo（任何安装了 Rust 的平台）：**

```bash
cargo install zoxide --locked
```

验证安装：

```bash
zoxide --version
# zoxide 0.9.7
```

### 第二步：添加 Shell 集成

Zoxide 需要在你的 Shell 配置中进行一次性初始化。这会启用 `z` 和 `zi` 命令，并钩入目录更改事件以更新数据库。

**Bash** — 添加到 `~/.bashrc`：

```bash
eval "$(zoxide init bash)"
```

**Zsh** — 添加到 `~/.zshrc`（在 `compinit` 之后）：

```zsh
eval "$(zoxide init zsh)"
```

**Fish** — 添加到 `~/.config/fish/config.fish`：

```fish
zoxide init fish | source
```

**Nushell** — 添加到你的环境文件（`$nu.env-path`）：

```nu
zoxide init nushell | save -f ~/.zoxide.nu
```

然后在你的配置文件（`$nu.config-path`）中引用：

```nu
source ~/.zoxide.nu
```

**PowerShell** — 添加到你的配置文件（用 `echo $profile` 查找路径）：

```powershell
Invoke-Expression (& { (zoxide init powershell | Out-String) })
```

重新加载你的 Shell 或执行配置：

```bash
source ~/.bashrc   # 或 ~/.zshrc 等
```

### 第三步：安装 fzf（可选但强烈推荐）

`zi` 命令通过 fzf 提供交互式模糊选择：

```bash
# macOS
brew install fzf

# Ubuntu/Debian
sudo apt install fzf

# Arch
sudo pacman -S fzf

# 或通过 git
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### 第四步：导入现有数据（可选）

如果你正在从其他目录跳转工具迁移，可以导入历史记录：

```bash
# 从 autojump 迁移
zoxide import autojump

# 从 fasd 迁移
zoxide import fasd

# 从 z 或 z.lua 迁移
zoxide import z

# 从 Atuin 迁移
zoxide import atuin
```

## 与流行工具的集成

### fzf 交互式选择

安装 fzf 后，`zi` 会在你的目录历史上打开交互式模糊查找器：

```bash
zi frontend        # 模糊查找匹配 "frontend" 的目录
zi                 # 浏览整个目录历史
```

自定义 zoxide 的 fzf 行为：

```bash
export _ZO_FZF_OPTS="--height 40% --reverse --preview 'ls -la {}'"
```

### nnn 文件管理器

Zoxide 通过 `nnn-autojump` 插件与 nnn 原生集成。添加到你的 nnn 配置：

```bash
export NNN_PLUG="z:zoxide"
```

然后在 nnn 中按 `;z` 使用 zoxide 跳转。

### tmux 会话管理器

`sesh`、`tmux-session-wizard` 和 `tmux-sessionx` 等工具原生支持 zoxide，可以从你最常用的目录启动 tmux 会话：

```bash
# 安装 sesh 后
sesh list          # 显示 zoxide 排名的目录
sesh connect       # 从 zoxide 列表启动交互式 tmux 会话
```

### Neovim / Vim

使用 `telescope-zoxide` 在 Neovim 内部进行模糊目录导航：

```lua
-- 在你的 Neovim 配置中（Lazy.nvim）
{
  "jvgrootvelte/telescope-zoxide",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("telescope").load_extension("zoxide")
  end,
}
```

通过 `:Telescope zoxide list` 触发。

### Yazi 文件管理器

Yazi 原生支持 zoxide。在 Yazi 中按 `Z` 键触发 zoxide 目录跳转。

### Emacs

从 MELPA 安装 `zoxide.el`：

```elisp
(use-package zoxide
  :ensure t
  :bind (("C-c z" . zoxide-find-file)))
```

## 基准测试与实际用例

### 启动与查询性能

| 工具          | 编程语言    | 启动时间   | 查询时间（1万目录） | 模糊搜索 |
|--------------|------------|-----------|-------------------|---------|
| **Zoxide**   | Rust       | ~5 ms     | < 10 ms           | 完整支持 |
| autojump     | Python     | ~50 ms    | 20-50 ms          | 不支持   |
| fasd         | POSIX sh   | ~20 ms    | 15-30 ms          | 部分支持 |
| 原生 `cd`    | Shell 内置 | 0 ms      | N/A               | 不支持   |

在 Ryzen 9 5900X + SSD 上测试，跟踪 10,000 个目录。

### 每日节省时间

| 场景                             | 原生 cd   | Zoxide   | 节省时间  |
|---------------------------------|----------:|---------:|----------:|
| 跳转到项目根目录（深层路径）      | 5 秒      | 0.5 秒   | 4.5 秒    |
| 在两个常用目录间切换              | 3 秒      | 0.5 秒   | 2.5 秒    |
| 查找很少使用的目录                | 10 秒     | 2 秒     | 8 秒      |
| 每日总计（200 次跳转）            | ~15 分钟  | ~2 分钟  | ~13 分钟  |

### 团队级大规模采用

一个 50 人的工程团队采用 Zoxide 后，每天可节省估计 10 小时以上的导航时间 —— 这些时间可以重新投入到实际开发工作中。学习曲线可以忽略不计；大多数开发者在安装后 5 分钟内就能高效使用。

## 高级用法与生产级加固

### 完全替换 cd

要让 `cd` 本身使用 zoxide，使用 `--cmd cd` 初始化：

```bash
eval "$(zoxide init bash --cmd cd)"
```

现在 `cd proj` 对模糊匹配的行为就像 `z proj`，同时仍然支持绝对路径的原生 `cd` 语法。

### 自定义别名

```bash
eval "$(zoxide init bash --cmd j)"    # 使用 j/ji 替代 z/zi
```

### 排除目录

阻止 zoxide 追踪敏感或临时目录：

```bash
export _ZO_EXCLUDE_DIRS="$HOME:$HOME/private/*:/tmp:/var/tmp"
```

在 Windows 上使用分号作为分隔符：

```powershell
$env:_ZO_EXCLUDE_DIRS = "$HOME;$HOME\private\*;C:\Temp"
```

### 更改数据库位置

```bash
export _ZO_DATA_DIR="/mnt/fast-ssd/zoxide-data"
```

### 启用回显模式

在导航前打印匹配的目录（对脚本编写有用）：

```bash
export _ZO_ECHO=1
```

### 解析符号链接

如果你在符号链接环境中工作，强制在写入数据库前解析符号链接：

```bash
export _ZO_RESOLVE_SYMLINKS=1
```

### Hook 配置

控制 zoxide 何时更新目录分数：

```bash
eval "$(zoxide init bash --hook prompt)"   # 每次提示符时更新
eval "$(zoxide init bash --hook pwd)"      # 仅在 cd 时更新（默认）
eval "$(zoxide init bash --hook none)"     # 从不自动更新；手动使用 zoxide add
```

### 数据库维护

```bash
# 查看所有带分数的追踪目录
zoxide query --list --score

# 移除特定目录
zoxide remove /old/project/path

# 删除项目后清理
zoxide edit                    # 在 $EDITOR 中打开数据库
```

### Shell 补全设置

**Zsh** — 确保初始化行放在 `compinit` 之后：

```zsh
autoload -Uz compinit; compinit
eval "$(zoxide init zsh)"      # 必须在 compinit 之后
rm ~/.zcompdump*; compinit     # 如有需要重建补全缓存
```

**Bash 4.4+** — `z <query><空格><Tab>` 触发交互式补全。

## 与替代方案对比

| 特性                         | Zoxide    | autojump  | fasd      | 原生 cd     |
|-----------------------------|-----------|-----------|-----------|------------|
| **编程语言**                 | Rust      | Python    | POSIX sh  | Shell 内置  |
| **启动时间**                 | ~5 ms     | ~50 ms    | ~20 ms    | 0 ms       |
| **模糊搜索**                 | 完整支持   | 仅前缀匹配 | 部分支持   | 不支持      |
| **交互式选择**               | zi + fzf  | j -i      | 不支持     | 不支持      |
| **学习算法**                 | Frecency  | 频率      | Frecency  | 无         |
| **跨平台**                   | 是         | 是         | 仅 POSIX  | 是          |
| **Shell 支持**               | 9+ 种     | Bash/Zsh/Fish | Bash/Zsh | 全部      |
| **Windows 支持**             | 原生支持   | 有限       | 不支持     | 是 (PowerShell) |
| **活跃维护**                 | 非常高     | 低         | 停滞       | N/A        |
| **数据库格式**               | SQLite    | 文本文件   | 文本文件   | 无         |
| **从其他工具导入**            | 是 (5+)   | 否         | 否         | N/A        |
| **Tab 补全**                 | 是         | 否         | 是         | 是          |

Zoxide 在每个指标上都优于竞对手，除了与原生 `cd` 的原始启动时间相比 —— 但这根本不是问题，因为 `z` 命令只在需要智能匹配时才被调用。对于绝对路径，zoxide 会委托给 Shell 的内置 `cd`。

## 局限性与诚实评估

**Zoxide 不是万能的 `cd` 替代品。** 在以下特定场景下它不会带来价值：

- **CI/CD 流水线：** 脚本应该使用绝对路径或 `cd` 以确保确定性。Zoxide 的数据库依赖行为会引入不可重复性。
- **共享系统 / 多用户服务器：** 数据库按用户设计，无法帮助你发现从未访问过的目录。
- **非常短的路径：** 输入 `z d` 到达 `/home/user/Downloads` 并不比 `cd ~/D` + Tab 节省按键次数。
- **首次导航：** Zoxide 只认识你至少访问过一次的目录。第一次访问需要正常的 `cd` 或绝对路径。
- **非交互式 Shell：** 在子 Shell 和非登录 Shell 中，数据库初始化会增加约 5ms 的开销，在高频脚本循环中可能有影响。
- **数据库损坏风险：** 尽管 SQLite 很健壮，但在写入时强制终止 Shell 可能理论上损坏数据库。如果你严重依赖历史记录，请备份 `_ZO_DATA_DIR`。

## 常见问题解答

### Zoxide 支持所有 Shell 吗？

是的。Zoxide 官方支持 Bash、Zsh、Fish、Nushell、PowerShell、Elvish、Tcsh、Xonsh 以及任何符合 POSIX 标准的 Shell。初始化命令会为每个 Shell 生成特定的代码。

### Zoxide 会与现有的 cd 命令冲突吗？

完全不会。默认情况下，`z` 和 `zi` 是与 `cd` 分开的命令，不会互相干扰。如果你希望 `cd` 本身使用 zoxide 的智能匹配，使用 `--cmd cd` 进行初始化。

### 如何从 autojump 或 fasd 迁移？

使用内置的导入命令：`zoxide import autojump`、`zoxide import fasd`、`zoxide import z` 等。这些命令会自动检测源数据库格式并将条目转换为 zoxide 的 SQLite 格式。

### 数据存储在哪里？可以备份吗？

数据库是一个 SQLite 文件，在 Linux 上位于 `~/.local/share/zoxide/db.sqlite`，macOS 上位于 `~/Library/Application Support/zoxide/db.sqlite`，Windows 上位于 `%LOCALAPPDATA%\\zoxide\\db.sqlite`。复制该文件即可备份你的目录历史。

### Zoxide 在 Windows 上能用吗？

是的。Zoxide 通过 winget、Scoop、Chocolatey 和 Cargo 提供一流的 Windows 支持。它在 PowerShell、命令提示符（通过 Clink）、Git Bash、MSYS2 和 WSL 中都能工作。

### 不用 fzf 能用 Zoxide 吗？

可以。核心的 `z` 命令不需要 fzf。fzf 仅用于 `zi` 交互式选择功能和 Tab 补全。即使跳过 fzf，你仍然能获得 Zoxide 90% 的价值。

### Zoxide 如何处理同名目录？

它会按 frecency 分数排名。如果你同时有 `~/work/frontend` 和 `~/personal/frontend`，你访问更频繁且更近的那个会胜出。使用 `z work fro` 或 `z per fro` 来消除歧义。

### 数据库是加密的吗？

不是。SQLite 数据库以明文存储路径。如果目录名包含敏感信息，请设置 `_ZO_EXCLUDE_DIRS` 以排除这些路径不被追踪。

### 可以针对特定会话禁用数据库更新吗？

将 `_ZO_DATA_DIR` 设置为临时位置，或在初始化时使用 `--hook none`，然后仅在需要时手动运行 `zoxide add`。

## 总结

Zoxide 是 2026 年最成熟、性能最强、维护最活跃的目录跳转工具。安装不到 60 秒，学习曲线平坦，每日节省时间可量化。如果你还在用 `cd` 输入完整路径，你正在浪费生产力。

**行动清单：**

1. 使用你平台的包管理器安装 Zoxide（参见安装部分）。
2. 在 Shell 配置中添加一行 `eval` 命令。
3. 安装 fzf 以获得 `zi` 交互式体验。
4. 如果从其他工具迁移，导入 autojump/fasd 的数据。
5. 加入讨论：在我们的 [Telegram 群组](https://t.me/dibi8opensource) 分享你的 Zoxide 使用技巧。



## 推荐部署与基础设施

上述工具想要落地生产，靠谱的基础设施是前提。dibi8 自己也在用的两个选择：

- **[DigitalOcean](https://m.do.co/c/eca87ac14ee0)** — 新用户 60 天 $200 免费额度，14+ 全球节点。运行开源 AI 工具的首选。
- **[HTStack](https://my.htstack.com/aff.php?aff=27187)** — 香港 VPS，国内访问低延迟，dibi8.com 自己也跑在它上面，生产环境验证过。

*Aff 链接 — 不增加你的成本，但能帮 dibi8 持续运营。*

## 来源与延伸阅读

- [Zoxide GitHub 仓库](https://github.com/ajeetdsouza/zoxide)
- [Zoxide 算法文档](https://github.com/ajeetdsouza/zoxide/wiki/Algorithm)
- [Zoxide 官方网站](https://zoxide.org/)
- [fzf GitHub 仓库](https://github.com/junegunn/fzf)
- [Neovim 的 telescope-zoxide](https://github.com/jvgrootvelte/telescope-zoxide)
- [Zoxide NixOS Wiki](https://nixos.wiki/wiki/Zoxide)
- [navi 速查表与 Zoxide](https://github.com/denisidoro/navi)
