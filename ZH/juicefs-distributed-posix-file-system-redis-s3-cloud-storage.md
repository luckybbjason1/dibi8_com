---


lang: zh
title: 'JuiceFS (14K⭐): 将云存储转化为本地存储的分布式 POSIX 文件系统'
description: 'JuiceFS（13,900+ 星标）将任何 S3 兼容的对象存储转换为符合 POSIX 标准的分布式文件系统。由 Redis 驱动元数据，它提供了具有本地文件系统语义的云原生性能——完美适用于 AI 训练、大数据和云工作负载。'
date: 2026-06-15
slug: 'juicefs-distributed-posix-file-system-redis-s3-cloud-storage'
category: dev-utils
tags: ['juicefs', 'distributed-file-system', 'cloud-storage', 's3', 'redis', 'posix', 'ai-training', 'big-data', 'go', 'cloud-native']
github_repo: 'https://github.com/juicedata/juicefs'
license: 'Apache-2.0'
featureImage: /articles/docker-compose-37-393-github-stars-multi-a62205.png/images/articles/docker-compose-37-393-github-stars-multi-a62205.png
---
# JuiceFS：云存储，本地速度

想象一下，你的团队需要在50多个工作人员之间共享用于人工智能训练的大型数据集。

每个工作节点都期望一个标准的 Linux 文件系统——但你的数据存储在 S3 中。

将 S3 挂载为本地文件系统令人沮丧：要么慢，要么不可靠，或两者兼而有之。

JuiceFS 通过结合两者的优点来解决这个问题。

凭借 13,900 多个 GitHub 星标以及主要云提供商的支持，JuiceFS 已成为 2026 年最受欢迎的云存储解决方案之一。

它为您提供具有本地磁盘性能特性的无限对象存储容量。

！

JuiceFS 架构图，显示元数据（Redis）和数据（S3）之间的分离](https://juicefs.com/docs/_media/juicefs-architecture.png)

## JuiceFS 的工作原理

JuiceFS 将文件元数据与文件数据分开。

这一建筑决策是其性能的关键。

```
┌─────────────────────────────────────────────────────┐
│                    JuiceFS Client                     │
│  ┌──────────────┐    ┌──────────────┐               │
│  │  Metadata DB  │    │  Object Store│               │
│  │  (Redis)      │    │  (S3/GCS/OSS)│               │
│  └──────┬───────┘    └──────┬───────┘               │
│         │                   │                        │
│  ┌──────┴───────────────────┴───────┐               │
│  │      POSIX Filesystem Interface  │               │
│  │   (mount -t juicefs juicefs /mnt)│               │
│  └──────────────────────────────────┘               │
└─────────────────────────────────────────────────────┘
```

元数据操作（文件列表、权限、时间戳）存储到 Redis —— 一个极快的内存数据存储。

文件数据（实际内容）会存储到任何兼容 S3 的对象存储中——容量无限，存储便宜。

这种分离意味着元数据总是快速的，而数据可以扩展到拍字节级别。

！

JuiceFS 元数据流程图，显示使用 Redis 作为元数据存储，S3 作为文件数据存储](https://juicefs.com/docs/_media/juicefs-metadata-flow.png)

**问：为什么使用 Redis 存储元数据而不是其他数据库？

**

A：Redis 是理想的选择，因为元数据操作很小但非常频繁。

打开文件、列出目录或检查权限每秒会发生成千上万次。

Redis 每秒处理数百万次操作，延迟低于毫秒级。

虽然 JuiceFS 支持其他元数据引擎（MySQL、PostgreSQL、TiKV），但对于典型工作负载，Redis 提供了最佳性能。

## 安装与快速开始

让 JuiceFS 运行只需几分钟。

这是一个完整的设置，使用 Redis 存储元数据，使用 AWS S3 进行存储：

```bash
# Install JuiceFS CLI
curl -sSL https://d.juicefs.com/install | sh -

# Create a JuiceFS filesystem
juicefs format \
  --storage s3 \
  --bucket https://my-bucket.s3.amazonaws.com \
  --access-key YOUR_ACCESS_KEY \
  --secret-key YOUR_SECRET_KEY \
  redis://localhost:6379/0 \
  mydata

# Mount it locally
juicefs mount mydata /mnt/juicefs
```

就是这样。

`/mnt/juicefs` 现在的行为就像一个普通的 Linux 文件系统。

运行 `ls`、`cp`、`python train`。

py`，或任何标准工具——都能无缝运行。

## 高级用法：分层存储

JuiceFS 强大的功能之一是分层存储。

冷数据会自动移动到更便宜的存储层：

```bash
# Mount with tiered storage (S3 as cache backend)
juicefs mount \
  --cache-size 10000 \
  --cache-dir /mnt/cache \
  --cache-compress \
  mydata \
  /mnt/juicefs
```

当本地缓存填满时，最久未使用的文件将被清除。

在下次访问时，它们会被透明地从 S3 获取。

这为您提供了热数据的 SSD 速度以及冷数据的 S3 容量。

### 缓存配置选项

为您的特定工作负载微调缓存行为：

```bash
# 50GB memory cache + 100GB disk cache with compression
juicefs mount \
  --read-only-false \
  --cache-size 50000 \
  --cache-dir /mnt/cache \
  --cache-partial \
  --cache-compress \
  --cache-full-gc-miss \
  mydata \
  /mnt/juicefs

# Verify cache stats
juicefs status mydata
# Cache usage: 45.2GB / 150.0GB (30%)
# Cache hit rate: 94.7%
# Cache miss: 2.1K ops
```

### 多挂载与读写协作

多个 JuiceFS 客户端可以同时挂载同一个文件系统以进行协作工作：

```bash
# Worker 1: Mount and start training
juicefs mount mydata /mnt/juicefs &
python train.py --data /mnt/juicefs/dataset --workers 8

# Worker 2: Mount the same filesystem (no sync needed)
juicefs mount mydata /mnt/juicefs &
python evaluate.py --data /mnt/juicefs/dataset

# Worker 3: Upload new data while training runs
rsync -av ./new_data/ /mnt/juicefs/dataset/
# Training workers see new data immediately
```

### S3 生命周期集成

将 JuiceFS 与 S3 生命周期策略结合，实现自动成本优化：

```bash
# Set S3 lifecycle rule via AWS CLI
aws s3api put-bucket-lifecycle-configuration \
  --bucket my-bucket \
  --lifecycle-configuration '{
    "Rules": [
      {
        "ID": "tieredStorage",
        "Status": "Enabled",
        "Filter": {"Prefix": ""},
        "Transitions": [
          {"Days": 90, "StorageClass": "GLACIER"},
          {"Days": 365, "StorageClass": "DEEP_ARCHIVE"}
        ]
      }
    ]
  }'

# JuiceFS automatically handles tier transitions
# Accessing a cold file triggers fetch from Glacier
```

## 性能基准

JuiceFS 在不同工作负载类型下都能提供令人印象深刻的性能：

| 工作负载类型 | JuiceFS | 本地 SSD | 云存储（原始） |

|