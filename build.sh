#!/bin/bash

# 设置工作目录
cd "$GITHUB_WORKSPACE"

# 检查环境变量
if [ -z "$APP_STORE_CONNECT_API_KEY" ]; then
    echo "Error: Missing APP_STORE_CONNECT_API_KEY"
    exit 1
fi

if [ -z "$APP_STORE_CONNECT_API_ISSUER_ID" ]; then
    echo "Error: Missing APP_STORE_CONNECT_API_ISSUER_ID"
    exit 1
fi

if [ -z "$APP_STORE_CONNECT_API_KEY_ID" ]; then
    echo "Error: Missing APP_STORE_CONNECT_API_KEY_ID"
    exit 1
fi

# 安装依赖
sudo gem install cocoapods
pod install

# 构建应用
xcodebuild -workspace StrangerChat.xcworkspace -scheme StrangerChat -configuration Release build

# 测试应用
xcodebuild -workspace StrangerChat.xcworkspace -scheme StrangerChat -configuration Release test

# 归档应用
xcodebuild -archivePath StrangerChat.xcarchive -workspace StrangerChat.xcworkspace -scheme StrangerChat archive

# 导出IPA
xcodebuild -exportArchive -archivePath StrangerChat.xcarchive -exportPath StrangerChat -exportOptionsPlist ExportOptions.plist

# 上传到TestFlight
fastlane pilot upload \
    --api_key_path "$APP_STORE_CONNECT_API_KEY" \
    --api_key_issuer_id "$APP_STORE_CONNECT_API_ISSUER_ID" \
    --api_key_key_id "$APP_STORE_CONNECT_API_KEY_ID" \
    --ipa "StrangerChat/StrangerChat.ipa" \
    --skip_waiting_for_build_processing true

# 上传到App Store
fastlane deliver upload \
    --api_key_path "$APP_STORE_CONNECT_API_KEY" \
    --api_key_issuer_id "$APP_STORE_CONNECT_API_ISSUER_ID" \
    --api_key_key_id "$APP_STORE_CONNECT_API_KEY_ID" \
    --ipa "StrangerChat/StrangerChat.ipa" \
    --skip_screenshots true \
    --skip_metadata true \
    --force true
