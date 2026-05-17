# dibi8_com — dibi8.com 文章备案仓库

dibi8.com 上线文章的镜像备份。每次 dibi8 上线新文章必须同步备案到这里。

## 目录映射

| 此仓库 | 对应 dibi8 语言 | ISO |
|---|---|---|
| `CN/` | dibi8 站点 `en/`（默认英语版） | en |
| `ZH/` | dibi8 站点 `zh/`（简体中文） | zh |
| `KR/` | dibi8 站点 `kr/`（韩语） | ko |
| `VI/` | dibi8 站点 `vi/`（越南语） | vi |

每篇文章按 `<lang>/<slug>.md` 命名（不按 dibi8 的 category 子分类，扁平存放方便检索）。

## 用途

灾难恢复：dibi8 站点内容丢失时从此仓库重建。
