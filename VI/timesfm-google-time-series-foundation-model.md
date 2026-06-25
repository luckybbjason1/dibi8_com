---
title: 'TimesFM 2.5: Mô hình chuỗi thời gian cách mạng của Google cho dự báo'
description: 'Hướng dẫn đầy đủ về TimesFM 2.5 — mô hình chuỗi thời gian tiên tiến nhất của Google Research. Cài đặt, cấu hình, benchmark và các ví dụ thực tế.'
date: 2026-06-19
tags: []
category: "data-science"
lang: vi
slug: timesfm-google-time-series-foundation-model
featureImage: /images/articles/fine-tuning-stack.png
---

# TimesFM 2.5: Mô hình nền tảng dự báo chuỗi thời gian mang tính cách mạng của Google 

Dự báo chuỗi thời gian từ lâu đã là một trong những vấn đề thách thức nhất trong khoa học dữ liệu. Từ dự đoán giá cổ phiếu đến dự báo mô hình thời tiết, từ dự báo doanh số đến ước tính mức tiêu thụ năng lượng — những dự đoán chính xác có thể tạo nên hoặc phá vỡ hoạt động kinh doanh. 

Nhập **[TimesFM](https://github.com/google-research/timesfm)**, mô hình nền tảng đột phá của Google Research để dự báo chuỗi thời gian. Với phiên bản 2.5 hiện đã có và hơn 23.000 sao GitHub, TimesFM thể hiện sự thay đổi mô hình trong cách chúng tôi tiếp cận phân tích dữ liệu thời gian. 

Trong hướng dẫn toàn diện này, chúng ta sẽ khám phá điều khiến TimesFM trở nên đặc biệt, cách cài đặt và sử dụng nó, so sánh nó với các phương pháp truyền thống và cung cấp các ví dụ thực tế để dự báo trong thế giới thực. 

## TimesFM là gì? 

TimesFM (Mô hình nền tảng chuỗi thời gian) là **mô hình nền tảng chỉ dành cho bộ giải mã** do Google Research phát triển dành riêng cho dự báo chuỗi thời gian. Không giống như các phương pháp dự báo truyền thống yêu cầu đào tạo các mô hình riêng biệt cho từng tập dữ liệu, TimesFM được đào tạo trước trên lượng lớn dữ liệu thời gian và có thể khái quát hóa các nhiệm vụ dự báo mới với mức tinh chỉnh tối thiểu. 

### Những đổi mới quan trọng 

Mô hình này giới thiệu một số cải tiến mang tính đột phá: 

![Dự báo chuỗi thời gian](https://images.pexels.com/photos/6332224/pexels-photo-6332224.jpeg)

1. **Kiến trúc chỉ dành cho bộ giải mã**: Lấy cảm hứng từ sự thành công của bộ giải mã biến áp trong mô hình hóa ngôn ngữ, TimesFM sử dụng kiến trúc bộ giải mã thuần túy được tối ưu hóa cho dự đoán tuần tự 
2. **Phương pháp tiếp cận mô hình nền tảng**: Được đào tạo trước trên lượng lớn dữ liệu tạm thời, cho phép khả năng dự báo không có lần bắn và ít lần bắn 
3. **Dự báo lượng tử liên tục**: Cung cấp các ước tính về độ không đảm bảo cùng với dự báo điểm thông qua đầu lượng tử tùy chọn 
4. **Cửa sổ ngữ cảnh mở rộng**: Hỗ trợ tới 16.000 bước thời gian của dữ liệu lịch sử để cải thiện các mối phụ thuộc tầm xa 
5. **Giảm số lượng tham số**: Phiên bản 2.5 chỉ sử dụng 200M tham số (giảm từ 500M ở phiên bản 2.0) trong khi cải thiện độ chính xác 

### Nghiên cứu đằng sau TimesFM 

Nghiên cứu cơ bản đã được công bố trên bài báo **"Mô hình nền tảng chỉ dành cho bộ giải mã để dự báo chuỗi thời gian"** tại ICML 2024. Kể từ đó, mô hình này đã phát triển qua nhiều phiên bản, trong đó v2.5 đại diện cho công nghệ tiên tiến nhất hiện nay trong mô hình nền tảng chuỗi thời gian. 

## TimesFM 2.5: Những cải tiến lớn 

Phiên bản 2.5 được phát hành vào tháng 9 năm 2025 mang đến những cải tiến đáng kể so với các phiên bản trước: 

![Kiến trúc mô hình](https://images.pexels.com/photos/8386449/pexels-photo-8386449.jpeg) 

| Tính năng | TimesFM 2.0 | TimesFM 2.5 | 
|----------|-------------|-------------| 
| Thông số | 500M | 200M | 
| Độ dài bối cảnh | 2.048 | 16.000 | 
| Dự báo lượng tử | Rời Rạc | Liên tục (lên tới 1.000 đường chân trời) | 
| Chỉ báo tần số | Bắt buộc | Đã xóa | 
| Tốc độ suy luận | Đường cơ sở | Nhanh hơn 2,5 lần | 
| Sử dụng bộ nhớ | Cao | Tối ưu hóa | 

### Tại sao ít tham số hơn, kết quả tốt hơn? 

Sự cải tiến phản trực giác này đạt được thông qua: 

![Mạng thần kinh](https://images.pexels.com/photos/3861959/pexels-photo-3861959.jpeg)

1. **Dữ liệu đào tạo trước tốt hơn**: Bộ dữ liệu thời gian đa dạng hơn và lớn hơn 
2. **Tinh chỉnh kiến trúc**: Cơ chế chú ý được tối ưu hóa cho chuỗi thời gian 
3. **Mục tiêu đào tạo được cải thiện**: Học tập đa tác vụ với nhiều tổn thất dự báo khác nhau 
4. **Cải tiến đầu lượng tử**: Đầu lượng tử 30M tùy chọn mang đến sự không chắc chắn mà không làm phồng mô hình chính 

## Hướng dẫn cài đặt 

Bắt đầu với TimesFM rất đơn giản. Mô hình này có sẵn thông qua PyPI, giúp việc cài đặt trở nên đơn giản như: 

### Cách 1: Cài đặt nhanh qua PyPI 

``` bash 
# Cài đặt với phụ trợ PyTorch 
cài đặt pip lầnfm[ngọn đuốc] 

# Hoặc với phần phụ trợ Flax/JAX (được khuyến nghị cho GPU/TPU) 
cài đặt pip lầnfm[flax] 

# Nếu bạn cần hỗ trợ đồng biến (XReg) 
cài đặt pip lầnfm[xreg] 
``` 

### Tùy chọn 2: Cài đặt phát triển 

Dành cho những người muốn đóng góp hoặc truy cập các tính năng mới nhất: 

``` bash 
# Sao chép kho lưu trữ 
bản sao git https://github.com/google-research/timesfm.git 
cd lầnfm 

#Tạo môi trường ảo 
uv venv 
nguồn .venv/bin/kích hoạt 

# Cài đặt ở chế độ có thể chỉnh sửa 
cài đặt uv pip -e .[đèn pin] 
# Hoặc cho phần phụ trợ Flax 
cài đặt uv pip -e .[flax] 
``` 

### Lựa chọn phụ trợ 

TimesFM hỗ trợ nhiều chương trình phụ trợ: 

- **PyTorch**: Tốt nhất cho người dùng CPU và GPU NVIDIA 
- **Flax/JAX**: Tối ưu cho môi trường TPU và Google Cloud 
- **Tiện ích mở rộng XReg**: Thêm hỗ trợ đồng biến cho các biến hồi quy bên ngoài 

Chọn chương trình phụ trợ dựa trên yêu cầu về phần cứng và triển khai của bạn. 

## Cách sử dụng cơ bản 

Hãy bắt đầu với một ví dụ dự báo đơn giản: 

### Dự báo không có phát bắn nào 

``` con trăn 
nhập numpy dưới dạng np 
nhập lầnfm 

# Tải mô hình đã được huấn luyện trước 
mô hình = timefm.TimesFM_2p5_200M.from_pretrain( 
"google/timesfm-2.5-200m-flax" 
) 

# Chuẩn bị dữ liệu chuỗi thời gian của bạn 
# Hình dạng: (num_series, context_length) 
lịch sử_data = np.random.randn(1, 1024) 

# Dự đoán 12 bước thời gian tiếp theo 
dự báo = model.forecast(lịch sử_data, chân trời=12) 
print(f"Dự báo hình dạng: {forecast.shape}") 
print(f"Giá trị dự đoán: {forecast}") 
``` 

### Với dự báo lượng tử

Để ước tính độ không đảm bảo, hãy bật đầu phân vị liên tục: 

``` con trăn 
dự báo_with_uncertainty = model.forecast( 
dữ liệu lịch sử, 
chân trời=12, 
lượng tử=[0,1, 0,5, 0,9] # phân vị thứ 10, 50, 90 
) 

# dự báo_với_không chắc chắn chứa dự báo điểm và khoảng tin cậy 
point_forecast = dự báo_với_không chắc chắn[:, :, 1] # trung vị 
giới hạn thấp hơn = dự báo_với_không chắc chắn[:, :, 0] # phân vị thứ 10 
giới hạn trên = dự báo_với_không chắc chắn[:, :, 2] # phân vị thứ 90 
``` 

### Sử dụng phần cuối PyTorch 

``` con trăn 
ngọn đuốc nhập khẩu 
nhập lầnfm 

# Đặt độ chính xác để tính toán nhanh hơn 
torch.set_float32_matmul_precision("cao") 

# Tải phiên bản PyTorch 
mô hình = timefm.TimesFM_2p5_200M_torch.from_pretrain( 
"google/timesfm-2.5-200m-pytorch" 
) 

# Biên dịch để suy luận tối ưu 
model.compile( 
timefm.ForecastConfig( 
max_context=1024, 
max_horizon=256, 
normalize_inputs=Đúng, 
use_continuous_quantile_head=Đúng, 
Force_flip_invariance=Đúng, 
suy luận_is_posid=Đúng, 
fix_quantile_crossing=Đúng, 
) 
) 

# Đưa ra dự đoán 
point_forecast, quantile_forecast = model.forecast( 
chân trời=12, 
đầu vào=[ 
np.linspace(0, 1, 100), 
np.sin(np.linspace(0, 20, 67)), 
] 
) 
``` 

## Tính năng nâng cao 

### Tinh chỉnh với LoRA 

Một trong những tính năng mạnh mẽ nhất của TimesFM 2.5 là khả năng tinh chỉnh bằng cách sử dụng Thích ứng xếp hạng thấp (LoRA): 

``` con trăn 
từ máy biến áp nhập khẩu AutoModelForSequenceClassification 
từ nhập peft LoraConfig, get_peft_model 

# Tải mô hình TimesFM cơ sở 
base_model = timefm.TimesFM_2p5_200M.from_pretrain( 
"google/timesfm-2.5-200m-flax" 
) 

# Cấu hình LoRA 
lora_config = LoraConfig( 
r=16, # Thứ hạng của ma trận cập nhật 
lora_alpha=32, # Hệ số tỷ lệ 
target_modules=["query", "value"], # Lớp để áp dụng LoRA cho 
lora_dropout=0,1, 
) 

# Áp dụng LoRA vào mô hình 
mô hình = get_peft_model(base_model, lora_config)

# Bây giờ bạn có thể tinh chỉnh tập dữ liệu cụ thể của mình 
# Điều này yêu cầu ít tham số hơn đáng kể so với tinh chỉnh đầy đủ 
``` 

### Hỗ trợ đồng biến với XReg 

Đối với các trường hợp trong đó bạn có các biến bên ngoài ảnh hưởng đến chuỗi thời gian của mình, TimesFM 2.5 hỗ trợ lập mô hình hiệp phương sai: 

``` con trăn 
# Cài đặt có hỗ trợ XReg 
# pip cài đặt lầnfm[xreg] 

nhập lầnfm 

# Tải mô hình có hỗ trợ đồng biến 
mô hình = timefm.TimesFM_2p5_200M_XReg.from_pretrain( 
"google/timesfm-2.5-200m-xreg" 
) 

# Dữ liệu chuỗi thời gian lịch sử 
y_train = np.random.randn(1000) 

# Các đồng biến bên ngoài (ví dụ: chi tiêu tiếp thị, các chỉ số thời vụ) 
X_train = np.random.randn(1000, 5) 

# Phù hợp với mô hình hiệp phương sai 
model.fit(y_train, X_train) 

# Dự báo với các đồng biến trong tương lai 
y_pred, độ tin cậy_intervals = model.predict( 
chân trời=12, 
X_future=np.random.randn(12, 5) 
) 
``` 

### Dự báo hàng loạt 

Đối với nhiều chuỗi thời gian cùng một lúc: 

``` con trăn 
# Chuẩn bị chuỗi thời gian 
batch_data = np.random.randn(10, 1024) # 10 chuỗi, mỗi chuỗi 1024 dấu thời gian 

# Dự báo tất cả các chuỗi cùng một lúc 
dự báo = model.forecast(batch_data, Horizon=24) 

# Hình dạng: (10, 24) - 10 dự báo, mỗi dự báo 24 bước thời gian 
print(f"Hình dạng dự báo hàng loạt: {forecasts.shape}") 
``` 

### Dự báo hàng loạt 

Đối với nhiều chuỗi thời gian cùng một lúc: 

``` con trăn 
# Chuẩn bị chuỗi thời gian 
batch_data = np.random.randn(10, 1024) # 10 chuỗi, mỗi chuỗi 1024 dấu thời gian 

# Dự báo tất cả các chuỗi cùng một lúc 
dự báo = model.forecast(batch_data, Horizon=24) 

# Hình dạng: (10, 24) - 10 dự báo, mỗi dự báo 24 bước thời gian 
print(f"Hình dạng dự báo hàng loạt: {forecasts.shape}") 
``` 

### Dự báo hàng loạt 

Đối với nhiều chuỗi thời gian cùng một lúc: 

``` con trăn 
# Chuẩn bị chuỗi thời gian 
batch_data = np.random.randn(10, 1024) # 10 chuỗi, mỗi chuỗi 1024 dấu thời gian 

# Dự báo tất cả các chuỗi cùng một lúc 
dự báo = model.forecast(batch_data, Horizon=24) 

# Hình dạng: (10, 24) - 10 dự báo, mỗi dự báo 24 bước thời gian 
print(f"Hình dạng dự báo hàng loạt: {forecasts.shape}") 
``` 

### Truyền suy luận 

Đối với các ứng dụng dự báo thời gian thực:

``` con trăn 
# Khởi tạo ứng dụng phát trực tuyến 
streaming_model = timefm.StreamingTimesFM( 
model_path="google/timesfm-2.5-200m-flax" 
) 

# Xử lý luồng dữ liệu đến 
trong khi Đúng: 
dữ liệu mới = get_next_time_step() 
dự báo = streaming_model.update_and_predict(new_data, Horizon=12) 
display_forecast(dự báo) 
``` 

## Điểm chuẩn hiệu suất 

TimesFM 2.5 đạt được kết quả tiên tiến trên nhiều bộ dữ liệu điểm chuẩn: 

### Kết quả điểm chuẩn 

| Bộ dữ liệu | TimesFM 2.5 | AutoARIMA | Tiên tri | N-BEATS | 
|----------|-------------|-------------|----------|----------| 
| ETTh1 | 0,312 | 0,487 | 0,523 | 0,398 | 
| Điện | 0,234 | 0,312 | 0,298 | 0,267 | 
| Giao thông | 0,198 | 0,287 | 0,276 | 0,245 | 
| Thời tiết | 0,156 | 0,234 | 0,221 | 0,189 | 
| Tỷ giá hối đoái | 0,287 | 0,398 | 0,412 | 0,334 | 

Giá trị thấp hơn cho thấy hiệu suất tốt hơn (MSE chuẩn hóa). 

### Hiệu suất thực tế 

Trong môi trường sản xuất, TimesFM 2.5 đã chứng minh: 

- **Độ chính xác 95%** khi dự báo nhu cầu cho chuỗi bán lẻ 
- **Giảm 40%** chi phí tồn kho so với phương pháp truyền thống 
- **nhanh hơn gấp 10 lần** thời gian đào tạo so với các phương pháp tiếp cận mạng thần kinh tùy chỉnh 
- **Hiệu suất nhất quán** trên nhiều lĩnh vực khác nhau (tài chính, chăm sóc sức khỏe, sản xuất) 

## Tích hợp với các sản phẩm của Google 

Một trong những lợi thế độc đáo của TimesFM là khả năng tích hợp với hệ sinh thái của Google: 

### BigQuery ML 

Đối với dự báo ở quy mô doanh nghiệp: 

```sql 
-- Sử dụng mô hình TimesFM trong BigQuery ML 
TẠO MÔ HÌNH my_project.my_timesfm_model 
TÙY CHỌN(model_type='TIMESFM') NHƯ 
CHỌN 
dấu thời gian_col, 
giá trị_col, 
EXTRACT(HOUR TỪ timestamp_col) AS giờ_of_day 
TỪ `my_dataset.time_series_data`; 
``` 

### Tích hợp Google Trang tính 

Đối với người dùng không rành về kỹ thuật: 

1. Cài đặt [tiện ích bổ sung TimesFM](https://workspaceupdates.googleblog.com/2026/02/forecast-data-in-connected-sheets-BigQueryML-TimesFM.html) 
2. Chọn phạm vi dữ liệu của bạn 
3. Chọn chân trời dự báo 
4. Nhận dự đoán trực tiếp trong bảng tính của bạn 

### Vườn mô hình AI của Vertex 

Để triển khai trên đám mây:

``` con trăn 
từ google.cloud nhập aiplatform 

# Triển khai mô hình TimesFM lên Vertex AI 
aiplatform.init(project="your-project", location="us-central1") 

điểm cuối = aiplatform.Endpoint.create( 
display_name="timesfm-forecasting-endpoint", 
description="Điểm cuối dự báo TimesFM 2.5" 
) 

model = aiplatform.Model.upload( 
display_name="timesfm-2.5", 
Artifact_uri="gs://your-bucket/timesfm-model" 
) 

endpoint.deploy(model=model, machine_type="n1-standard-4") 
``` 

## Ứng dụng trong thế giới thực 

### Ứng dụng 1: Dự báo doanh số 

Các công ty bán lẻ có thể sử dụng TimesFM để dự đoán doanh số bán hàng trong tương lai: 

``` con trăn 
nhập gấu trúc dưới dạng pd 
nhập lầnfm 

# Tải dữ liệu bán hàng lịch sử 
sales_data = pd.read_csv ("lịch sử_bán hàng.csv") 

# Chuẩn bị chuỗi thời gian 
lịch sử_bán hàng = sales_data["bán hàng"].values.reshape(1, -1) 

# Dự báo 30 ngày tới 
mô hình = timefm.TimesFM_2p5_200M.from_pretrain( 
"google/timesfm-2.5-200m-flax" 
) 

dự báo = model.forecast(lịch sử_bán hàng, chân trời=30) 
print(f"Doanh số dự kiến tháng tới: {forecast.mean():.2f}") 
``` 

### Ứng dụng 2: Dự đoán nhu cầu năng lượng 

Các công ty tiện ích có thể dự báo nhu cầu điện: 

``` con trăn 
# Tải dữ liệu tiêu thụ năng lượng 
energy_data = pd.read_csv("energy_consumption.csv") 

# Bao gồm các đồng biến thời tiết 
đồng biến = pd.DataFrame({ 
"nhiệt độ": Weather_data["temp"], 
"độ ẩm": Weather_data["độ ẩm"], 
"day_of_week": energy_data.index.dayofweek 
}) 

# Huấn luyện với đồng biến 
model.fit(energy_data["consumption"], covariates.values) 

# Dự đoán nhu cầu trong tương lai 
Future_demand = model.predict( 
chân trời=24, 
X_future=future_covariates.values 
) 
``` 

### Ứng dụng 3: Phân tích thị trường tài chính 

Tuy không phải là lời khuyên tài chính nhưng TimesFM có thể giúp phân tích các mô hình thị trường: 

``` con trăn 
#dự báo giá cổ phiếu 
stock_prices = pd.read_csv("stock_history.csv")["close"].values 

# Nhiều cổ phiếu 
batch_stocks = np.array([ 
stock_price[:-100], # Apple 
stock_price[100:-100], # Google 
stock_price[200:] # Amazon 
])

# Dự báo tất cả cổ phiếu 
dự đoán = model.forecast(batch_stocks, Horizon=30) 
``` 

##So Sánh Với Phương Pháp Truyền Thống 

### TimesFM so với ARIMA 

| Khía cạnh | TimesFM 2.5 | ARIMA | 
|--------|-------------|-------| 
| Thời gian thiết lập | Phút | Giờ-Ngày | 
| Điều chỉnh tham số | Tối thiểu | Mở rộng | 
| Nhiều loạt | Có | Không | 
| Mẫu phi tuyến tính | Xuất sắc | Hạn chế | 
| Khả năng giải thích | Hạ | Cao hơn | 
| Khả năng mở rộng | Cao | Trung bình | 

### TimesFM vs. Nhà tiên tri 

| Khía cạnh | TimesFM 2.5 | Tiên tri | 
|--------|-------------|----------| 
| Mô Hình Nền Tảng | Có | Không | 
| Chuyển tiếp học tập | Có | Không | 
| Ước tính độ không đảm bảo | Liên tục | Rời Rạc | 
| Hiệu quả tính toán | Cao | Trung bình | 
| Hỗ trợ cộng đồng | Đang phát triển | Trưởng thành | 

## Hạn chế và cân nhắc 

### Hạn chế hiện tại 

1. **Yêu cầu dữ liệu lịch sử**: Mặc dù việc học vài lần có ích nhưng vẫn cần một số dữ liệu lịch sử 
2. **Tài nguyên tính toán**: Cửa sổ ngữ cảnh lớn yêu cầu bộ nhớ đáng kể 
3. **Tính đặc hiệu của miền**: Có thể cần tinh chỉnh cho các miền chuyên dụng 
4. **Khả năng diễn giải**: Giống như tất cả các mô hình học sâu, hoạt động nội bộ có phần không rõ ràng 

### Các phương pháp hay nhất 

1. **Chất lượng dữ liệu**: Đảm bảo dữ liệu chuỗi thời gian rõ ràng, nhất quán 
2. **Độ dài ngữ cảnh**: Chọn cửa sổ lịch sử phù hợp cho trường hợp sử dụng của bạn 
3. **Cập nhật thường xuyên**: Đào tạo lại định kỳ khi có dữ liệu mới 
4. **Xác thực**: Luôn xác thực các dự đoán dựa trên các tập dữ liệu loại trừ 

### TimesFM so với ARIMA 

| Khía cạnh | TimesFM 2.5 | ARIMA | 
|--------|-------------|-------| 
| Thời gian thiết lập | Phút | Giờ-Ngày | 
| Điều chỉnh tham số | Tối thiểu | Mở rộng | 
| Nhiều loạt | Có | Không | 
| Mẫu phi tuyến tính | Xuất sắc | Hạn chế | 
| Khả năng giải thích | Hạ | Cao hơn | 
| Khả năng mở rộng | Cao | Trung bình | 

### TimesFM vs. Nhà tiên tri

| Khía cạnh | TimesFM 2.5 | Tiên tri | 
|--------|-------------|----------| 
| Mô Hình Nền Tảng | Có | Không | 
| Chuyển tiếp học tập | Có | Không | 
| Ước tính độ không đảm bảo | Liên tục | Rời Rạc | 
| Hiệu quả tính toán | Cao | Trung bình | 
| Hỗ trợ cộng đồng | Đang phát triển | Trưởng thành | 

## Hạn chế và cân nhắc 

### Hạn chế hiện tại 

1. **Yêu cầu dữ liệu lịch sử**: Mặc dù việc học vài lần có ích nhưng vẫn cần một số dữ liệu lịch sử 
2. **Tài nguyên tính toán**: Cửa sổ ngữ cảnh lớn yêu cầu bộ nhớ đáng kể 
3. **Tính đặc hiệu của miền**: Có thể cần tinh chỉnh cho các miền chuyên dụng 
4. **Khả năng diễn giải**: Giống như tất cả các mô hình học sâu, hoạt động nội bộ có phần không rõ ràng 

### Các phương pháp hay nhất 

1. **Chất lượng dữ liệu**: Đảm bảo dữ liệu chuỗi thời gian rõ ràng, nhất quán 
2. **Độ dài ngữ cảnh**: Chọn cửa sổ lịch sử phù hợp cho trường hợp sử dụng của bạn 
3. **Cập nhật thường xuyên**: Đào tạo lại định kỳ khi có dữ liệu mới 
4. **Xác thực**: Luôn xác thực các dự đoán dựa trên các tập dữ liệu loại trừ 

## Tương lai của dự báo chuỗi thời gian 

TimesFM chỉ là bước khởi đầu cho những gì các mô hình nền tảng có thể đạt được trong phân tích dữ liệu thời gian. Những phát triển sắp tới bao gồm: 

### Các tính năng dự kiến 

- **Dự báo đa biến**: Xử lý tốt hơn nhiều chuỗi thời gian liên quan 
- **Học theo thời gian thực**: Thích ứng trực tuyến mà không cần đào tạo lại đầy đủ 
- **Explainable AI**: Cải thiện khả năng diễn giải của các dự đoán 
- **Triển khai biên**: Phiên bản được tối ưu hóa cho thiết bị di động và thiết bị IoT 
- **Tích hợp đa phương thức**: Kết hợp chuỗi thời gian với hình ảnh, văn bản và các loại dữ liệu khác 

### Hướng nghiên cứu 

Nhóm Nghiên cứu của Google tiếp tục vượt qua các ranh giới bằng công việc đang diễn ra về: 

- Cửa sổ ngữ cảnh dài hơn (32K+ bước thời gian) 
- Ít thông số hơn với hiệu suất tương đương hoặc tốt hơn 
- Khái quát hóa liên miền 
- Khả năng suy luận nhân quả 

## Bắt đầu ngay hôm nay 

Bạn đã sẵn sàng cách mạng hóa quy trình dự báo của mình chưa? Đây là cách để bắt đầu:

1. **Cài đặt**: `pip install Timesfm[flax]` 
2. **Tải mô hình**: Sử dụng điểm kiểm tra đã được huấn luyện trước từ Ôm mặt 
3. **Chuẩn bị dữ liệu**: Định dạng chuỗi thời gian của bạn một cách thích hợp 
4. **Dự báo**: Gọi phương thức dự báo với đường chân trời mong muốn của bạn 
5. **Tinh chỉnh**: Tùy ý điều chỉnh mô hình cho phù hợp với miền cụ thể của bạn 

Cho dù bạn là nhà khoa học dữ liệu đang tìm kiếm các công cụ dự báo tốt hơn hay nhà phân tích kinh doanh muốn đưa ra dự đoán dựa trên dữ liệu, TimesFM 2.5 đều cung cấp giải pháp mạnh mẽ, linh hoạt, sẵn sàng triển khai ngay hôm nay. 

## Câu hỏi thường gặp 

### Hỏi: Sự khác biệt giữa TimesFM 2.0 và 2.5 là gì? 

TimesFM 2.5 chỉ sử dụng 200M tham số (giảm từ 500M ở 2.0) trong khi đạt được độ chính xác cao hơn. Nó hỗ trợ độ dài ngữ cảnh lên tới 16.000 (so với 2.048), dự báo lượng tử liên tục lên tới 1.000 đường chân trời và loại bỏ nhu cầu về chỉ báo tần số. 

### Hỏi: Tôi có cần GPU để chạy TimesFM không? 

Không, TimesFM có thể chạy trên CPU, mặc dù khả năng tăng tốc GPU cải thiện đáng kể tốc độ suy luận. Phần phụ trợ Flax/JAX được khuyến nghị cho người dùng GPU TPU và NVIDIA, trong khi PyTorch hoạt động tốt cho các thiết lập CPU và GPU NVIDIA. 

### Hỏi: Tôi có thể sử dụng TimesFM để dự báo tài chính không? 

Mặc dù về mặt kỹ thuật, TimesFM có thể dự báo chuỗi thời gian tài chính nhưng điều quan trọng cần lưu ý là thị trường tài chính bị ảnh hưởng bởi vô số yếu tố khó lường. Mô hình này nên được sử dụng như một công cụ trong số nhiều công cụ chứ không phải là cơ sở duy nhất cho các quyết định đầu tư. 

### Hỏi: Tính năng tinh chỉnh hoạt động như thế nào với TimesFM? 

Tinh chỉnh sử dụng Thích ứng cấp thấp (LoRA) thông qua Máy biến áp ôm mặt. Bạn chuẩn bị dữ liệu dành riêng cho miền của mình, định cấu hình các tham số LoRA và huấn luyện trong một vài kỷ nguyên. Điều này điều chỉnh mô hình nền tảng cho phù hợp với nhiệm vụ dự báo cụ thể của bạn mà không yêu cầu đào tạo lại toàn bộ mô hình. 

### Hỏi: Khoảng thời gian dự báo tối đa là bao nhiêu? 

TimesFM 2.5 hỗ trợ các chân trời lên tới 1.000 bước thời gian với đầu lượng tử liên tục. Đối với hầu hết các ứng dụng thực tế, khoảng thời gian 24-365 bước là đủ và mang lại độ chính xác tốt nhất.

### Hỏi: TimesFM có phù hợp để dự báo theo thời gian thực không? 

Có, sau khi được biên soạn và tối ưu hóa, TimesFM có thể đưa ra dự đoán theo thời gian thực. Các mô hình được biên dịch với cấu hình suy luận được tối ưu hóa có thể dự báo hàng trăm bước thời gian mỗi giây trên phần cứng hiện đại. 

## Kết luận 

TimesFM 2.5 thể hiện bước nhảy vọt trong lĩnh vực dự báo chuỗi thời gian. Bằng cách kết hợp sức mạnh của các mô hình nền tảng với các tối ưu hóa theo miền cụ thể cho dữ liệu thời gian, nó đạt được độ chính xác vượt trội với chi phí thiết lập và tính toán tối thiểu. 

Với sự tích hợp vào hệ sinh thái của Google, cộng đồng phát triển tích cực và những cải tiến liên tục, TimesFM sẵn sàng trở thành tiêu chuẩn để dự báo chuỗi thời gian trong các ngành. 

Đối với bất kỳ ai làm việc với dữ liệu tạm thời, việc đầu tư thời gian vào việc tìm hiểu và triển khai TimesFM không chỉ mang lại lợi ích mà nó còn trở nên cần thiết. 

--- 

**Nguồn:** 
- [Kho lưu trữ GitHub](https://github.com/google-research/timesfm) 
- [Bài báo ICML 2024](https://arxiv.org/abs/2310.10688) 
- [Blog nghiên cứu của Google](https://research.google/blog/a-decoding-only-foundation-model-for-time-series-forecasting/) 
- [Người mẫu ôm khuôn mặt](https://huggingface.co/collections/google/timesfm-release-66e4be5fdb56e960c1e482a6) 

**CTA:** Tham gia [nhóm Telegram DIBI8](https://t.me/DIBI8_Group/2) để biết thêm thông tin chi tiết về AI và khoa học dữ liệu! 

**Liên kết liên kết:** 
- [DigitalOcean](https://m.do.co/c/eca87ac14ee0) - Lưu trữ các mô hình ML của bạn 
- [HTStack](https://my.htstack.com/aff.php?aff=27187) - Lưu trữ máy chủ GPU đáng tin cậy 
- [虎网云](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367) - Máy chủ GPU dành cho đào tạo (tiếng Trung)
