#!/usr/bin/env python3
"""Dibi8.com Cloudflare Pages 直接部署脚本"""

import os
import sys
import json
import zipfile
import subprocess
from pathlib import Path
import shutil

# 配置
ACCOUNT_ID = "e575ee29fb0430bc53bf8e991b226d19"
TOKEN = "cfut_1Ll6uxuEQ8aKaA2ETWXQVoIXLN3brV1ZiXApEeeRc845bb72"
PROJECT_NAME = "dibi8-com"

print("=" * 40)
print("  Dibi8.com 直接部署到 Cloudflare Pages")
print("=" * 40)
print()

# 创建临时目录
build_dir = Path.home() / "dibi8_deploy"
zip_path = Path.home() / "deploy.zip"

# 清理并创建目录
if build_dir.exists():
    shutil.rmtree(str(build_dir))
build_dir.mkdir(parents=True, exist_ok=True)

# 复制构建文件
src = Path("/data/data/com.termux/files/home/dibi8_com/public")
for item in src.iterdir():
    if item.is_dir():
        shutil.copytree(item, build_dir / item.name, dirs_exist_ok=True)
    else:
        shutil.copy2(item, build_dir / item.name)

print(f"✅ 复制构建文件完成 ({len(list(build_dir.rglob('*')))} 个文件)")

# 创建ZIP压缩包
with zipfile.ZipFile(zip_path, 'w', zipfile.ZIP_DEFLATED) as zf:
    for file_path in build_dir.rglob("*"):
        if file_path.is_file():
            arcname = file_path.relative_to(build_dir)
            zf.write(file_path, str(arcname))

file_size = zip_path.stat().st_size
print(f"✅ 创建压缩包: {file_size / 1024:.1f} KB")

# 上传到Cloudflare（使用multipart upload API）
print("📤 上传到 Cloudflare...")
try:
    import requests
    
    # 获取deployment ID
    manifest_resp = requests.post(
        f"https://api.cloudflare.com/client/v4/accounts/{ACCOUNT_ID}/pages/projects/{PROJECT_NAME}/deployments/queue",
        headers={"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"},
        json={
            "name": f"manual-deploy-{int(subprocess.check_output(['date', '%s']))}",
            "production": True
        }
    )
    
    manifest = manifest_resp.json()
    if 'result' not in manifest:
        print("❌ 获取deployment ID失败:", manifest)
        sys.exit(1)
    
    deployment_id = manifest['result']['id']
    upload_url = manifest['result']['upload_url']
    print(f"✅ Deployment ID: {deployment_id}")
    
    # 上传ZIP文件
    with open(zip_path, 'rb') as f:
        headers = {
            "Content-Type": "application/zip",
            "CF-Logging": "true"
        }
        upload_resp = requests.put(upload_url, data=f, headers=headers)
    
    if upload_resp.status_code != 200:
        print("❌ 上传失败:", upload_resp.status_code, upload_resp.text)
        sys.exit(1)
    
    print("✅ 上传成功!")
    print()
    print("部署URL: https://", PROJECT_NAME, ".pages.dev", sep="")
    
except Exception as e:
    print(f"❌ 上传失败: {e}")
    import traceback
    traceback.print_exc()

print()
print("部署脚本已完成")
