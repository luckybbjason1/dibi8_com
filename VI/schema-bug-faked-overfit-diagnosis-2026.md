---
title: 'Lỗi schema đã ngụy tạo chẩn đoán overfit của tôi: Báo cáo postmortem backtest mà không ai nói đến'
description: 'Chạy 7 thí nghiệm quant, phát hiện «overfit kinh điển» (Train PF 2.08 → OOS 0.94, tỷ lệ 2.21). Sau đó phát hiện chính chẩn đoán đó là sai — lỗi không khớp tên trường schema âm thầm khiến optimizer chạy với leverage mặc định 10x thay vì 2x đã được tiến hóa. Phiên bản đã sửa thì lành mạnh (tỷ lệ 1.01). Bài học meta còn xấu xí hơn bản gốc.'
date: 2026-05-26 00:00:00+08:00
lastmod: 2026-05-26 00:00:00+08:00
tech_stack: ['Python', 'pandas', 'numpy', 'vectorbt', 'backtrader', 'pydantic']
application_domain: AI Trading
source_version: 'moss-trade-bot-skills v1.0.26'
licensing_model: Mã nguồn mở
license_type: MIT
github_repo: ''
stars: 0
maintainer: 'Ban biên tập dibi8'
last_maintained: '2026-05-26'
featureImage: ''
draft: false
categories: ['ai-trading']
tags: ['backtest', 'overfit', 'quant', 'schema-drift', 'walk-forward', 'postmortem', '2026']
aliases:
- /vi/posts/schema-bug-faked-overfit-diagnosis-2026/
faq:
  - q: "Schema drift là gì và tại sao nó lại ngụy tạo kết quả backtest?"
    a: "Schema drift nghĩa là tên trường tham số trong config của bạn không còn khớp với schema runtime nữa. Bộ deserialize sẽ âm thầm loại bỏ các trường lạ và dùng giá trị mặc định. Nếu các mặc định đó hung hãn (như leverage 10x trong khi bạn dự định 2x), kết quả backtest sẽ dao động kinh khủng. Các con số trông thật nhưng chúng đến từ một chiến lược khác hẳn với chiến lược bạn đã viết."
  - q: "Tại sao chẩn đoán overfit ban đầu trông thuyết phục đến vậy?"
    a: "Dấu hiệu kinh điển: Train PF 2.08, OOS PF 0.94, tỷ lệ 2.21. Bất kỳ quant trader nào cũng đã thấy mô hình này trong tài liệu — optimizer khớp với nhiễu không lặp lại. Kết luận «overfit» khớp hoàn hảo với hình dạng dữ liệu. Leverage 10x ẩn chỉ đơn giản là khuếch đại mọi thứ, khiến cả hai con số trở nên cực đoan. Với leverage 2x đúng, cùng tham số đó cho Train 1.494 / OOS 1.478 tỷ lệ 1.01 — ổn định một cách buồn tẻ."
  - q: "Bài học meta cho việc kiểm chứng backtest là gì?"
    a: "Trước khi tin bất kỳ kết quả backtest nào, hãy kiểm chứng rằng từ điển tham số của bạn thực sự đã nạp đúng các giá trị bạn đã viết. `print(vars(params))` sau `from_dict()`. Nếu một trường bị âm thầm loại bỏ, bạn đang chạy một chiến lược khác với cái bạn nghĩ. Kiểm tra 5 giây này đáng lẽ đã tiết kiệm 7 thí nghiệm tiếp theo."
  - q: "Vậy có phải overfit không tồn tại trong chiến lược này không?"
    a: "Không hẳn. Phiên bản đã sửa trên BTC 304 ngày là ổn định (tỷ lệ 1.01). Nhưng kiểm tra liên tài sản trên 8 cặp cho thấy chủ yếu là nhiễu (ratio_stdev > mean). Một tài sản (DOT) trông tuyệt vời cho đến khi phân rã walk-forward tiết lộ tỷ lệ IS/OOS 6.47 — overfit kinh điển thực sự ẩn sau câu chuyện «thành công liên tài sản». Chiến lược chỉ hòa vốn, vì lý do khác với chẩn đoán ban đầu."
  - q: "Làm sao để phòng vệ chống schema drift trong production?"
    a: "Ba lớp: (1) Dùng deserialization nghiêm ngặt (pydantic strict mode, dataclass với kw_only=True + frozen=True, hoặc Field validator rõ ràng từ chối các khóa lạ). (2) Cố định version schema của file tham số cùng với version framework. (3) In tham số hiệu lực ngay trước backtest và assert các giá trị chính (leverage, sl_atr_mult, weights). Riêng bộ deserializer nghiêm ngặt đã bắt được 90% lỗi loại này một cách thầm lặng."
  - q: "Danh sách «Bảy điều không nên» mới sau sự kiện này là gì?"
    a: "Mở rộng từ 7 lên 13. Các mục mới: không tin thí nghiệm khi không kiểm chứng schema, không kết luận trên dataset dưới 200 ngày giao dịch, không chấp nhận PF > 3 với dưới 30 giao dịch, không phát hành chiến lược nếu chưa kiểm chứng liên tài sản, không phớt lờ tỷ lệ stdev/mean (trên 1 = nhiễu), không báo cáo PF mà không phân rã theo từng đoạn, không chấp nhận báo cáo thiếu tỷ lệ IS/OOS."
---

{{< resource-info >}}

# Lỗi schema đã ngụy tạo chẩn đoán overfit của tôi

> **Meta Description**: Chạy 7 thí nghiệm quant, «overfit kinh điển» hóa ra là một lỗi schema. Phiên bản đã sửa thì ổn định. Bài học meta còn xấu xí hơn bản gốc.

Báo cáo gốc trông sạch sẽ. Train PF 2.08, OOS PF 0.94, tỷ lệ 2.21. Bất kỳ ai đã đọc tài liệu quant đều nhận ra dấu hiệu này — optimizer khớp với nhiễu không lặp lại. Đánh dấu là overfit, đóng lại, đi tiếp.

Rồi đến các thí nghiệm tiếp theo. Và phát hiện rằng chính chẩn đoán đó là sai.

Đây là báo cáo postmortem. Bug không nằm ở chiến lược. Bug nằm ở cách chúng ta đã tin vào các con số.

## ⚡ TL;DR

> **Kết luận ban đầu**: Overfit kinh điển trên BTC 304 ngày (PF 2.08 → 0.94, tỷ lệ 2.21).
>
> **Phát hiện thật**: Không khớp trường schema. `evolved_final_params.json` dùng tên trường `leverage` / `tp_atr_mult`; schema hiện tại dùng `base_leverage` / `tp_rr_ratio`. `from_dict()` đã âm thầm loại bỏ chúng. Lần chạy thực tế dùng leverage mặc định 10x, không phải 2x đã được tiến hóa.
>
> **Kết quả đã sửa**: PF 1.494 / 1.478, tỷ lệ 1.01. Ổn định một cách buồn tẻ. Không overfit.
>
> **Nhưng cũng**: Kiểm tra liên tài sản vẫn chỉ ra tốt nhất là hòa vốn. Tỷ lệ IS/OOS walk-forward của DOT 6.47 — overfit kinh điển thực sự ẩn trong câu chuyện «đoạn may mắn».
>
> **Bài học meta**: Kiểm chứng việc nạp tham số trước khi tin output backtest. Năm giây `print(vars(params))` đáng lẽ đã tiết kiệm bảy thí nghiệm.

## «Phát hiện» ban đầu

Chúng tôi đã chạy moss-trade-bot-skills v1.0.26 ở chế độ paper trên các nến 15m của BTC/USDC, từ tháng 7/2025 → tháng 4/2026. 304 ngày, 29184 nến, chia 70/30.

Chiến lược là một biến thể mean-revert được tiến hóa bởi optimizer tham số của framework. Cấu hình đã tiến hóa trông hợp lý: trọng số trend thấp, trọng số mean-revert cao, leverage 2x thận trọng, sl/tp đối xứng.

Kết quả backtest trở về sạch sẽ:
- Train (212 ngày): PF 2.08
- OOS (92 ngày): PF 0.94
- Tỷ lệ: 2.21

Tỷ lệ Train/OOS trên 2.0 là dấu hiệu overfit kinh điển. Chúng tôi đã phân loại nó là «tiến hóa tìm thấy nhiễu đặc thù của Q3-Q4 2025, không tổng quát hóa được.» Câu chuyện hợp lý, khớp dữ liệu, kết thúc phiên.

## Thí nghiệm tiếp theo phá vỡ câu chuyện

Hôm sau chúng tôi thử kiểm chứng đa tài sản — cùng tham số đã tiến hóa trên ETH cho cùng cửa sổ. Mô hình kỳ vọng: nếu tham số nắm bắt được tín hiệu, chúng nên tổng quát hóa được.

ETH chạy. PF 1.154 → 0.697, tỷ lệ 1.66. Overfit nhẹ, chủ yếu nhất quán với chẩn đoán của chúng tôi.

Sau đó chúng tôi đã kiểm tra BTC trên cửa sổ ngắn hơn 148 ngày khớp với phạm vi dữ liệu của ETH. Cửa sổ con khác của cùng một tài sản.

Kết quả: PF 0.980 → 1.581, tỷ lệ 0.62. Mô hình **đảo ngược**. OOS tốt hơn Train.

Đó là lúc chẩn đoán bắt đầu thất bại.

Cùng tham số, cùng tài sản, các cửa sổ thời gian khác nhau cho ra các mô hình ngược nhau. Hoặc chiến lược là nhiễu (đúng), hoặc các cửa sổ có chế độ thị trường rất khác nhau (cũng đúng), hoặc — và đây là điều cuối cùng chúng tôi đã kiểm tra — tham số không phải như chúng tôi nghĩ.

## Schema drift

Trong mẫu Python điển hình `dataclass.from_dict()`, các trường lạ bị âm thầm loại bỏ. Pydantic cũng làm vậy trừ khi bạn bật strict mode.

File cấu hình đã tiến hóa chứa:

```json
{
  "leverage": 2,
  "sl_atr_mult": 2.5,
  "tp_atr_mult": 2.5,
  ...
}
```

Schema `DecisionParams` runtime mong đợi:

```python
base_leverage: float = 10.0
max_leverage: float = 40.0
sl_atr_mult: float = ...
tp_rr_ratio: float = ...
```

`leverage` → âm thầm bị loại bỏ → `base_leverage` mặc định về **10.0**.
`tp_atr_mult` → âm thầm bị loại bỏ → `tp_rr_ratio` mặc định về giá trị riêng của nó.

«Leverage 2x đã tiến hóa với hệ số ATR đối xứng 2.5/2.5» mà chúng tôi nghĩ mình đang chạy thực ra là «leverage mặc định 10x với bất cứ tp_rr_ratio mặc định nào.»

Năm giây `print(vars(params))` sau `from_dict()` đáng lẽ đã chỉ ra điều này. Chúng tôi đã không làm.

## Các con số đã sửa

Cùng BTC 304 ngày, cùng chia 70/30, cùng tham số đã tiến hóa — nhưng được ánh xạ đúng vào các trường schema hiện tại:

- Train PF: 1.494
- OOS PF: 1.478
- Tỷ lệ: **1.01**

Đó không phải là overfit. Đó là một trong những tỷ lệ Train/OOS ổn định nhất mà chúng tôi từng thấy.

Chiến lược không bị hỏng. Chẩn đoán đã bị hỏng.

## Những gì vẫn còn đúng

Kết quả đã sửa là ổn định trên BTC 304 ngày, nhưng kiểm tra liên tài sản kể một câu chuyện ít đẹp đẽ hơn.

Tám cặp crypto, cùng cửa sổ 148 ngày, cùng tham số đã sửa:

| Tài sản | Train PF | OOS PF | Tỷ lệ |
|---|---|---|---|
| ETH | 1.154 | 0.697 | 1.66 |
| BNB | 1.512 | 0.213 | 7.10 |
| AVAX | 0.581 | 1.302 | 0.45 |
| LINK | 1.055 | 0.519 | 2.03 |
| ARB | 0.628 | 1.527 | 0.41 |
| DOT | 1.647 | 1.907 | 0.86 |
| NEAR | 0.358 | 1.415 | 0.25 |

Độ lệch chuẩn của tỷ lệ (2.42) vượt quá trung bình (1.82). Khi độ trải của một chỉ số lớn hơn xu hướng trung tâm của nó, bạn đang nhìn vào nhiễu.

DOT trông như nổi bật — Train 1.65, OOS 1.91, cả hai đều mạnh. Nhưng khi chia 148 ngày của DOT thành năm đoạn ~30 ngày, đoạn 1 (tháng 10-11/2025) một mình đã mang PF 7.82 và toàn bộ lợi nhuận +1.67%. Bốn đoạn còn lại cộng lại là -0.68%. «Alpha liên tài sản» chỉ là một tháng may mắn.

Một kiểm tra walk-forward đã xác nhận: đoạn 1 là in-sample, đoạn 2-5 là out-of-sample. IS PF 7.82 → OOS PF 1.21. **Tỷ lệ IS/OOS 6.47** — overfit kinh điển thực sự ẩn trong một tài sản mà các con số bề mặt trông tốt.

## Các lớp phòng vệ

Ba lớp, theo thứ tự nỗ lực/giá trị:

**1. Deserialization nghiêm ngặt.** Hãy làm cho bộ nạp tham số của bạn từ chối các trường lạ. Trong Python:

```python
@dataclass(frozen=True, kw_only=True)
class DecisionParams:
    base_leverage: float = 10.0
    # ...
    
    @classmethod
    def from_dict(cls, d: dict) -> "DecisionParams":
        valid = {f.name for f in cls.__dataclass_fields__.values()}
        unknown = set(d.keys()) - valid
        if unknown:
            raise ValueError(f"Unknown fields: {unknown}")
        return cls(**{k: v for k, v in d.items() if k in valid})
```

Hàm `from_dict()` gốc đã lọc xuống các trường hợp lệ *mà không raise* trên các trường lạ. Một `raise` bị thiếu đã tốn bảy thí nghiệm.

**2. In tham số hiệu lực trước khi backtest.** Ba dòng:

```python
params = DecisionParams.from_dict(raw)
print(f"Effective: leverage={params.base_leverage}, sl={params.sl_atr_mult}, tp={params.tp_rr_ratio}")
assert params.base_leverage == raw.get("base_leverage", raw.get("leverage")), "leverage mismatch"
```

**3. Cố định version schema của file tham số.** Khi schema của framework thay đổi, các file tham số cũ nên thất bại ầm ĩ, không âm thầm xuống cấp.

## «Bảy điều không nên» mới — Giờ là Mười ba

Bảy quy tắc kỷ luật backtest ban đầu đã tăng lên mười ba sau sự cố này. Sáu mục mới đến trực tiếp từ những thí nghiệm này:

- **Không tin thí nghiệm khi không kiểm chứng schema.** Hãy in tham số trước khi backtest.
- **Không kết luận trên dataset dưới 200 ngày giao dịch.** Các cửa sổ con 148 ngày của cùng một tài sản đã cho chẩn đoán ngược nhau.
- **Không chấp nhận PF > 3 với dưới 30 giao dịch.** Cờ đỏ mặc định.
- **Không phát hành chiến lược mà chưa kiểm chứng liên tài sản.** Ổn định trên một tài sản là cần thiết, không đủ.
- **Không phớt lờ tỷ lệ stdev/mean.** Trên 1 nghĩa là nhiễu, bất kể trung bình trông tốt thế nào.
- **Không báo cáo PF mà không phân rã theo từng đoạn.** Tóm tắt cửa sổ đơn ẩn giấu các hiện tượng đoạn may mắn.

## Phần khó

Báo cáo gốc đã nằm trong kho lưu trữ của chúng tôi một ngày trước khi thí nghiệm tiếp theo phơi bày nó. Nếu chúng tôi dừng lại ở «Train PF 2.08 → OOS 0.94, tỷ lệ 2.21», chúng tôi đã chia sẻ một chẩn đoán tự tin nhưng sai. Các con số là thật. Câu chuyện chúng tôi kể xung quanh chúng thì không.

Kết quả backtest dễ tạo ra, dễ tóm tắt, dễ chia sẻ. Kiểm chứng các giả định đằng sau các con số thì khó hơn, chậm hơn, và ít được tưởng thưởng hơn. Nhưng đó là bước duy nhất phân biệt «chúng tôi đã chạy một thứ và đây là những gì đã xảy ra» với «chúng tôi biết điều gì đã xảy ra.»

Nếu bạn chỉ lấy một thói quen từ bài postmortem này: hãy in tham số hiệu lực của bạn trước mỗi lần backtest. Năm giây. Tiết kiệm bảy thí nghiệm.

## Hạ tầng được đề xuất

Cho khung thí nghiệm walk-forward + đa tài sản:

- **{{< aff "digitalocean" "footer-cta" "DigitalOcean" >}}** — Tín dụng $200, droplet GPU/CPU dễ dùng
- **{{< aff "htstack" "footer-cta" "HTStack" >}}** — VPS Hong Kong, độ trễ thấp đến các API sàn châu Á

*Liên kết tiếp thị liên kết — cùng giá, ủng hộ dibi8.com.*

---

**Liên quan**: [Đánh giá Moss Trade Bot Factory 2026](https://dibi8.com/vi/resources/ai-trading/moss-trade-bot-factory-2026-review/) · [5 mô hình OVERFIT trong Backtest 2026](https://dibi8.com/vi/resources/ai-trading/backtest-overfit-5-patterns-2026/) · [Backtesting Python với Backtrader](https://dibi8.com/vi/resources/ai-trading/backtrader-python-backtesting/)
