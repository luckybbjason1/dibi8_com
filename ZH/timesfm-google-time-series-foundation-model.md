---
title: 'TimesFM 2.5：用于预测的谷歌革命性时间序列基础模型'
description: 'TimesFM 2.5 完整指南——用于时间序列预测的 Google Research 仅解码器基础模型。涵盖安装、微调、基准测试和实际应用。'
date: 2026-06-19
tags: []
category: "data-science"
lang: zh
slug: timesfm-google-time-series-foundation-model
featureImage: /images/articles/timesfm-google-time-series-foundation-model-4cb99070.png
---

# TimesFM 2.5：Google 革命性的预测时间序列基础模型

 时间序列预测长期以来一直是数据科学中最具挑战性的问题之一。 从预测股票价格到预测天气模式，从销售预测到能源消耗估算——准确的预测可以成就企业，也可以毁掉企业。 

输入 **[TimesFM](https://github.com/google-research/timesfm)**，Google Research 用于时间序列预测的突破性基础模型。 TimesFM 现已推出 2.5 版本，并拥有超过 23,000 名 GitHub star，它代表了我们处理时态数据分析方式的范式转变。 

在这份综合指南中，我们将探讨 TimesFM 的特殊之处、如何安装和使用它、将其与传统方法进行比较，并为现实世界的预测提供实际示例。 

## TimesFM 是什么？ 

TimesFM（时间序列基础模型）是 Google Research 专门针对时间序列预测开发的**仅解码器基础模型**。 与需要为每个数据集训练单独模型的传统预测方法不同，TimesFM 在大量时态数据上进行预训练，并且可以通过最少的微调推广到新的预测任务。 

### 关键创新

 该模型引入了多项突破性创新：

 ![时间序列预测](https://images.pexels.com/photos/6332224/pexels-photo-6332224.jpeg)

1. **仅解码器架构**：受到语言建模中变压器解码器成功的启发，TimesFM 使用针对顺序预测优化的纯解码器架构
 2. **基础模型方法**：对大量时态数据进行预训练，实现零样本和少样本预测能力
 3. **连续分位数预测**：通过可选的分位数头提供不确定性估计以及点预测
 4. **扩展上下文窗口**：支持多达 16,000 个时间步长的历史数据，以改善远程依赖性
 5. **减少参数数量**：2.5 版本仅使用 200M 参数（低于 v2.0 中的 500M），同时提高了准确性

 ### TimesFM 背后的研究

 该基础研究发表在 ICML 2024 上的论文**“用于时间序列预测的仅解码器基础模型”**中。此后，该模型经历了多个版本的演变，其中 v2.5 代表了当前时间序列基础建模的最先进水平。 

## TimesFM 2.5：重大改进

 2.5 版本于 2025 年 9 月发布，较之前版本带来了显着改进：

 ![模型架构](https://images.pexels.com/photos/8386449/pexels-photo-8386449.jpeg)

 | 特色 | 时代FM 2.0 | 时代FM 2.5 |
 |---------|-------------|----------|
 | 参数| 500M | 200M |
 | 上下文长度 | 2,048 | 2,048 16,000 |
 | 分位数预测 | 离散| 连续（最多 1,000 个水平线）|
 | 频率指示器| 必填| 已删除 |
 | 推理速度 | 基线| 快 2.5 倍 |
 | 内存使用情况| 高| 优化|

 ### 为什么参数更少，结果更好？ 

这种违反直觉的改进是通过以下方式实现的：

 ![神经网络](https://images.pexels.com/photos/3861959/pexels-photo-3861959.jpeg)

1. **更好的预训练数据**：更多样化、更大的时间数据集
 2. **架构改进**：优化时间序列的注意力机制
 3. **改进的训练目标**：具有各种预测损失的多任务学习
 4. **分位数头创新**：可选的30M分位数头提供了不确定性，而不会使主模型膨胀

 ## 安装指南

 TimesFM 入门非常简单。 该模型可通过 PyPI 获得，安装非常简单：

 ### 选项 1：通过 PyPI 快速安装

 ````bash
 # 使用 PyTorch 后端安装
 pip install timesfm[火炬]

 # 或者使用 Flax/JAX 后端（推荐用于 GPU/TPU）
 pip 安装 timesfm[flax]

 # 如果需要协变量支持 (XReg)
 pip 安装 timesfm[xreg]
 ````

 ### 选项 2：开发安装

 对于那些想要贡献或访问最新功能的人：

 ````bash
 # 克隆存储库
 git 克隆 https://github.com/google-research/timesfm.git
 光盘时代调频

 # 创建虚拟环境
 紫外线
 源 .venv/bin/activate

 # 以可编辑模式安装
 uv pip install -e .[火炬]
 # 或者对于 Flax 后端
 uv pip install -e .[亚麻]
 ````

 ### 后端选择

 TimesFM 支持多个后端：

 - **PyTorch**：最适合 CPU 和 NVIDIA GPU 用户
 - **Flax/JAX**：最适合 TPU 和 Google Cloud 环境
 - **XReg 扩展**：添加对外部回归量的协变量支持

 根据您的硬件和部署要求选择后端。 

## 基本用法

 让我们从一个简单的预测示例开始：

 ### 零样本预测

 ````蟒蛇
 将 numpy 导入为 np
 导入时间调频

 # 加载预训练模型
 模型 = timesfm.TimesFM_2p5_200M.from_pretrained(
 “谷歌/timesfm-2.5-200m-flax”
 ）

 # 准备你的时间序列数据
 # 形状：(num_series, context_length)
 历史数据 = np.random.randn(1, 1024)

 # 预测接下来的12个时间步
 预测= model.forecast（历史数据，地平线= 12）
 print(f"预测形状：{forecast.shape}")
 print(f"预测值：{预测}")
 ````

 ### 使用分位数预测

对于不确定性估计，启用连续分位数头：

 ````蟒蛇
 Forecast_with_uncertainty = model.forecast(
 历史数据，
 地平线=12，
 分位数=[0.1, 0.5, 0.9] # 第 10、50、90 个百分位数
 ）

 # Forecast_with_uncertainty 包含点预测和置信区间
 point_forecast = Forecast_with_uncertainty[:, :, 1] # 中位数
 lower_bound = Forecast_with_uncertainty[:, :, 0] # 第 10 个百分位数
 upper_bound = Forecast_with_uncertainty[:, :, 2] # 第 90 个百分位
 ````

 ### 使用 PyTorch 后端

 ````蟒蛇
 进口火炬
 导入时间调频

 # 设置精度以加快计算速度
 torch.set_float32_matmul_ precision（“高”）

 # 加载 PyTorch 版本
 模型 = timesfm.TimesFM_2p5_200M_torch.from_pretrained(
 “谷歌/timesfm-2.5-200m-pytorch”
 ）

 # 编译优化推理
 模型.编译(
 timesfm.ForecastConfig(
 最大上下文=1024，
 最大地平线=256，
 Normalize_inputs=真，
 use_continuous_quantile_head=真，
 force_flip_invariance=真，
 infer_is_positive=真，
 fix_quantile_crossing=真，
 ）
 ）

 # 进行预测
 point_forecast, quantile_forecast = model.forecast(
 地平线=12，
 输入=[
 np.linspace(0, 1, 100),
 np.sin(np.linspace(0, 20, 67)),
 ]
 ）
 ````

 ## 高级功能

 ### 使用 LoRA 进行微调

 TimesFM 2.5 最强大的功能之一是使用低秩适应 (LoRA) 进行微调的能力：

 ````蟒蛇
 从变压器导入 AutoModelForSequenceClassification
 从 peft 导入 LoraConfig，get_peft_model

 # 加载基本 TimesFM 模型
 base_model = timesfm.TimesFM_2p5_200M.from_pretrained(
 “谷歌/timesfm-2.5-200m-flax”
 ）

 # 配置LoRA
 洛拉配置 = 洛拉配置（
 r=16, # 更新矩阵的秩
 lora_alpha=32, # 缩放因子
 target_modules=["query", "value"], # 应用 LoRA 的层
 劳拉_dropout=0.1,
 ）

 # 将 LoRA 应用于模型
 模型 = get_peft_model(base_model, lora_config)

# 现在您可以对特定数据集进行微调
 # 与完全微调相比，这需要明显更少的参数
 ````

 ### XReg 的协变量支持

 对于有影响时间序列的外部变量的场景，TimesFM 2.5 支持协变量建模：

 ````蟒蛇
 # 安装 XReg 支持
 # pip 安装 timesfm[xreg]

 导入时间调频

 # 加载具有协变量支持的模型
 模型 = timesfm.TimesFM_2p5_200M_XReg.from_pretrained(
 “谷歌/timesfm-2.5-200m-xreg”
 ）

 # 历史时间序列数据
 y_train = np.random.randn(1000)

 # 外部协变量（例如营销支出、季节性指标）
 X_train = np.random.randn(1000, 5)

 # 拟合协变量模型
 model.fit(y_train, X_train)

 # 使用未来协变量进行预测
 y_pred，confidence_intervals = model.predict（
 地平线=12，
 X_future=np.random.randn(12, 5)
 ）
 ````

 ### 批量预测

 同时对于多个时间序列：

 ````蟒蛇
 # 准备一批时间序列
 batch_data = np.random.randn(10, 1024) # 10 个系列，每个系列 1024 个时间步

 # 一次性预测所有系列
 预测 = model.forecast(batch_data, Horizon=24)

 # 形状：(10, 24) - 10 个预测，每个预测 24 个时间步长
 print(f"批量预测形状：{forecasts.shape}")
 ````

 ### 批量预测

 同时对于多个时间序列：

 ````蟒蛇
 # 准备一批时间序列
 batch_data = np.random.randn(10, 1024) # 10 个系列，每个系列 1024 个时间步

 # 一次性预测所有系列
 预测 = model.forecast(batch_data, Horizon=24)

 # 形状：(10, 24) - 10 个预测，每个预测 24 个时间步长
 print(f"批量预测形状：{forecasts.shape}")
 ````

 ### 批量预测

 同时对于多个时间序列：

 ````蟒蛇
 # 准备一批时间序列
 batch_data = np.random.randn(10, 1024) # 10 个系列，每个系列 1024 个时间步

 # 一次性预测所有系列
 预测 = model.forecast(batch_data, Horizon=24)

 # 形状：(10, 24) - 10 个预测，每个预测 24 个时间步长
 print(f"批量预测形状：{forecasts.shape}")
 ````

 ### 流式推理

 对于实时预测应用：

````蟒蛇
 # 初始化流媒体客户端
 Streaming_model = timesfm.StreamingTimesFM(
 model_path="google/timesfm-2.5-200m-flax"
 ）

 # 处理传入的数据流
 而真实：
 新数据 = get_next_time_step()
 预测=streaming_model.update_and_predict（new_data，地平线= 12）
 显示预测（预测）
 ````

 ## 性能基准

 TimesFM 2.5 在多个基准数据集上取得了最先进的结果：

 ### 基准测试结果

 | 数据集 | 时代FM 2.5 | 自动ARIMA | 先知| N-节拍 |
 |--------|-------------|------------|---------|---------|
 | ETTh1 | 0.312 | 0.312 0.487 | 0.487 0.523 | 0.523 0.398 | 0.398
 | 电力 | 0.234 | 0.234 0.312 | 0.312 0.298 | 0.298 0.267 | 0.267
 | 交通 | 0.198 | 0.198 0.287 | 0.287 0.276 | 0.276 0.245 | 0.245
 | 天气 | 0.156 | 0.156 0.234 | 0.234 0.221 | 0.221 0.189 | 0.189
 | 汇率 | 0.287 | 0.287 0.398 | 0.398 0.412 | 0.412 0.334 | 0.334

 值越低表示性能越好（标准化 MSE）。 

### 真实世界性能

 在生产环境中，TimesFM 2.5 展示了：

 - **95% 准确度** 零售连锁店的需求预测
 - 与传统方法相比，**库存成本降低 40%**
 - 与自定义神经网络方法相比，**训练时间快 10 倍**
 - **在不同领域（金融、医疗保健、制造）保持一致的性能**

 ## 与 Google 产品集成

 TimesFM 的独特优势之一是它与 Google 生态系统的集成：

 ### BigQuery 机器学习

 对于企业规模的预测：

 ``sql
 -- 在 BigQuery ML 中使用 TimesFM 模型
 创建模型 my_project.my_timesfm_model
 选项(model_type='TIMESFM') AS
 选择
 时间戳_列，
 值_列，
 EXTRACT(HOUR FROM timestamp_col) AS hour_of_day
 来自`my_dataset.time_series_data`；
 ````

 ### Google 表格集成

 对于非技术用户：

 1. 安装 [TimesFM 插件](https://workspaceupdates.googleblog.com/2026/02/forecast-data-in-connected-sheets-BigQueryML-TimesFM.html)
 2. 选择您的数据范围
 3. 选择预测范围
 4. 直接在电子表格中获取预测

 ### Vertex AI 模型花园

 对于云部署：

````蟒蛇
 从 google.cloud 导入 aiplatform

 # 将 TimesFM 模型部署到 Vertex AI
 aiplatform.init（项目=“您的项目”，位置=“us-central1”）

 端点 = aiplatform.Endpoint.create(
 display_name="timesfm-forecasting-endpoint",
 描述=“TimesFM 2.5 预测端点”
 ）

 模型 = aiplatform.Model.upload(
 显示名称=“timesfm-2.5”，
 artifact_uri =“gs://your-bucket/timesfm-model”
 ）

 端点.部署（模型=模型，machine_type =“n1-standard-4”）
 ````

 ## 实际应用

 ### 应用1：销售预测

 零售公司可以使用 TimesFM 来预测未来的销售：

 ````蟒蛇
 将 pandas 导入为 pd
 导入时间调频

 # 加载历史销售数据
 sales_data = pd.read_csv("historical_sales.csv")

 # 准备时间序列
 历史销售 = sales_data["销售"].values.reshape(1, -1)

 # 未来 30 天的预测
 模型 = timesfm.TimesFM_2p5_200M.from_pretrained(
 “谷歌/timesfm-2.5-200m-flax”
 ）

 预测 = model.forecast(historical_sales, Horizon=30)
 print(f"下个月预计销售额：{forecast.mean():.2f}")
 ````

 ### 应用2：能源需求预测

 公用事业公司可以预测电力需求：

 ````蟒蛇
 # 加载能耗数据
 energy_data = pd.read_csv("energy_conspiration.csv")

 # 包括天气协变量
 协变量 = pd.DataFrame({
 “温度”：weather_data[“温度”]，
 “湿度”：weather_data[“湿度”]，
 “day_of_week”：energy_data.index.dayofweek
 })

 # 使用协变量进行训练
 model.fit(energy_data["消耗"], covariates.values)

 # 预测未来需求
 future_demand = model.predict(
 地平线=24，
 X_future=future_covariates.values
 ）
 ````

 ### 应用3：金融市场分析

 TimesFM 虽然不是财务建议，但可以帮助分析市场模式：

 ````蟒蛇
 # 股价预测
 stock_prices = pd.read_csv("stock_history.csv")["close"].values

 # 多只股票
 batch_stocks = np.array([
 stock_prices[:-100], # 苹果
 stock_prices[100:-100], # 谷歌
 stock_prices[200:] # 亚马逊
 ]）

# 预测所有股票
 预测 = model.forecast(batch_stocks, Horizon=30)
 ````

 ## 与传统方法的比较

 ### TimesFM 与 ARIMA

 | 方面| 时代FM 2.5 | 华睿玛 |
 |--------|-------------|--------|
 | 设置时间| 分钟 | 小时-天 |
 | 参数调优 | 最小 | 广泛 |
 | 多系列 | 是的 | 没有 |
 | 非线性模式| 优秀| 有限公司|
 | 可解释性| 降低| 更高 |
 | 可扩展性| 高| 中等|

 ### TimesFM vs. Prophet

 | 方面| 时代FM 2.5 | 先知|
 |--------|-------------|---------|
 | 基础模型| 是的 | 没有 |
 | 迁移学习 | 是的 | 没有 |
 | 不确定性估计| 连续 | 离散|
 | 计算效率 | 高| 中等|
 | 社区支持 | 成长| 成熟|

 ## 限制和注意事项

 ### 当前限制

 1. **需要历史数据**：虽然小样本学习有帮助，但仍然需要一些历史数据
 2. **计算资源**：大型上下文窗口需要大量内存
 3. **领域特异性**：可能需要针对专业领域进行微调
 4. **可解释性**：像所有深度学习模型一样，内部运作有些不透明

 ### 最佳实践

 1. **数据质量**：确保时间序列数据干净、一致
 2. **上下文长度**：为您的用例选择适当的历史窗口
 3. **定期更新**：当新数据可用时定期重新训练
 4. **验证**：始终根据保留数据集验证预测

 ### TimesFM 与 ARIMA

 | 方面| 时代FM 2.5 | 华睿玛 |
 |--------|-------------|--------|
 | 设置时间| 分钟 | 小时-天 |
 | 参数调优 | 最小 | 广泛 |
 | 多系列 | 是的 | 没有 |
 | 非线性模式| 优秀| 有限公司|
 | 可解释性| 降低| 更高 |
 | 可扩展性| 高| 中等|

 ### TimesFM vs. Prophet

| 方面| 时代FM 2.5 | 先知|
 |--------|-------------|---------|
 | 基础模型| 是的 | 没有 |
 | 迁移学习 | 是的 | 没有 |
 | 不确定性估计| 连续 | 离散|
 | 计算效率 | 高| 中等|
 | 社区支持 | 成长| 成熟|

 ## 限制和注意事项

 ### 当前限制

 1. **需要历史数据**：虽然小样本学习有帮助，但仍然需要一些历史数据
 2. **计算资源**：大型上下文窗口需要大量内存
 3. **领域特异性**：可能需要针对专业领域进行微调
 4. **可解释性**：像所有深度学习模型一样，内部运作有些不透明

 ### 最佳实践

 1. **数据质量**：确保时间序列数据干净、一致
 2. **上下文长度**：为您的用例选择适当的历史窗口
 3. **定期更新**：当新数据可用时定期重新训练
 4. **验证**：始终根据保留数据集验证预测

 ## 时间序列预测的未来

 TimesFM 代表了基础模型在时态数据分析中可以实现的目标的开始。 即将到来的发展包括：

 ### 计划的功能

 - **多元预测**：更好地处理多个相关时间序列
 - **实时学习**：在线适应，无需完全再培训
 - **可解释的人工智能**：提高预测的可解释性
 - **边缘部署**：针对移动和物联网设备的优化版本
 - **多模态集成**：将时间序列与图像、文本和其他数据类型相结合

 ### 研究方向

 Google 研究团队不断突破界限，开展以下工作：

 - 更长的上下文窗口（32K+ 时间步长）
 - 更少的参数具有相同或更好的性能
 - 跨域泛化
 - 因果推理能力

 ## 今天开始

 准备好彻底改变您的预测工作流程了吗？ 以下是如何开始：

1. **安装**：`pip install timesfm[flax]`
 2. **加载模型**：使用 Hugging Face 中的预训练检查点
 3. **准备数据**：适当设置时间序列的格式
 4. **预测**：根据您想要的范围调用预测方法
 5. **微调**：可选择使模型适应您的特定领域

 无论您是寻求更好预测工具的数据科学家，还是想要进行数据驱动预测的业务分析师，TimesFM 2.5 都提供了强大、灵活的解决方案，可以立即部署。 

## 常见问题

 ### 问：TimesFM 2.0 和 2.5 有什么区别？ 

TimesFM 2.5 仅使用 200M 参数（低于 2.0 中的 500M），同时实现了更好的准确性。 它支持高达 16,000 个上下文长度（相对于 2,048 个）、高达 1,000 个范围的连续分位数预测，并且无需频率指示​​器。 

### 问：我需要 GPU 来运行 TimesFM 吗？ 

不，TimesFM 可以在 CPU 上运行，尽管 GPU 加速显着提高了推理速度。 建议 TPU 和 NVIDIA GPU 用户使用 Flax/JAX 后端，而 PyTorch 非常适合 CPU 和 NVIDIA GPU 设置。 

### 问：我可以使用 TimesFM 进行财务预测吗？ 

虽然 TimesFM 从技术上可以预测金融时间序列，但值得注意的是，金融市场受到无数不可预测因素的影响。 该模型应作为众多工具中的一种，而不是作为投资决策的唯一依据。 

### 问：如何使用 TimesFM 进行微调？ 

微调通过 HuggingFace Transformers 使用低秩适应 (LoRA)。 您准备特定于域的数据、配置 LoRA 参数并训练几个时期。 这可以使基础模型适应您的特定预测任务，而不需要完整的模型重新训练。 

### 问：最大预测范围是多少？ 

TimesFM 2.5 通过其连续分位数头支持高达 1,000 个时间步的范围。 对于大多数实际应用，24-365 个时间步长的范围就足够了，并且可以提供最佳精度。

### 问：TimesFM 适合实时预测吗？ 

是的，一旦编译和优化，TimesFM 就可以提供实时预测。 具有优化推理配置的编译模型可以在现代硬件上每秒预测数百个时间步。 

## 结论

 TimesFM 2.5 代表了时间序列预测的巨大飞跃。 通过将基础模型的强大功能与时态数据的特定领域优化相结合，它以最小的设置和计算开销实现了卓越的准确性。 

通过融入 Google 的生态系统、活跃的开发社区和持续改进，TimesFM 有望成为跨行业时间序列预测的标准。 

对于任何使用时态数据的人来说，投入时间学习和部署 TimesFM 不仅是有益的，而且变得至关重要。 

---

 **来源：**
 - [GitHub 存储库](https://github.com/google-research/timesfm)
 - [ICML 2024 论文](https://arxiv.org/abs/2310.10688)
 - [谷歌研究博客](https://research.google/blog/a-decoder-only-foundation-model-for-time-series-forecasting/)
 - [拥抱脸部模型](https://huggingface.co/collections/google/timesfm-release-66e4be5fdb56e960c1e482a6)

 **CTA：** 加入 [DIBI8 Telegram 群组](https://t.me/DIBI8_Group/2) 了解更多人工智能和数据科学见解！ 

**附属链接：**
 - [DigitalOcean](https://m.do.co/c/eca87ac14ee0) - 托管您的 ML 模型
 - [HTStack](https://my.htstack.com/aff.php?aff=27187) - 可靠的 GPU 服务器托管
 - [虎网云](https://www.huwangyun.cn/gpu-server/?aff_id=f872dfc7e2864e62822c83c023354367) - 用于训练的GPU服务器（中文）
