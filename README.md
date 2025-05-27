# StrangerChat

一个陌生人社交聊天应用

## 功能特性

- 用户注册和登录
- 个人资料管理（用户名、性别、年龄、星座等）
- 实时聊天功能
- 附近的人发现功能
- 在线状态显示
- 位置共享
- 图片上传和分享
- 个人简介和兴趣爱好设置

## 技术栈

- SwiftUI
- Firebase (认证、数据库、存储)
- Alamofire (网络请求)
- Kingfisher (图片处理)
- Stripe (支付处理)
- CoreLocation (位置服务)

## 系统要求

- iOS 15.0 及以上
- Xcode 13.0 及以上

## 安装依赖

```bash
pod install
```

## 运行项目

1. 打开 `StrangerChat.xcworkspace`
2. 配置 Firebase 项目（将 GoogleService-Info.plist 添加到项目中）
3. 选择模拟器或真机
4. 点击运行按钮

## 配置说明

### Firebase 配置
1. 访问 [Firebase Console](https://console.firebase.google.com)
2. 创建新项目或选择现有项目
3. 下载 `GoogleService-Info.plist` 文件
4. 将文件添加到 Xcode 项目中

## 许可证

MIT
