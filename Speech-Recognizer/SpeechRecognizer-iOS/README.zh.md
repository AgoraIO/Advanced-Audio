# Speech Recognizer

*[English](README.md) | 中文*

本示例程序展示如何将 Agora 频道中的远端语音转化成文字。

## 运行示例程序

1. 在 [Agora.io](https://dashboard.agora.io/signin/) 注册账号， 并创建项目得到 AppID. 将 AppID 填入示例程序 `AppId.swift` 文件中。

	``` swift
	let AppId: String = "Your App ID"
	```

2. 在示例程序目录下运行 `pod install` 来下载和链接 Agora 音频 SDK.
3. 打开 `SpeechRecognizer-iOS.xcworkspace`，连接 iOS 设备，设置有效的开发者签名后即可运行。

- Important: 示例程序需要在 `Info.plist` 文件中添加 `NSMicrophoneUsageDescription` 和 `NSSpeechRecognitionUsageDescription` 两个字段，以获取麦克风采集和语音识别权限。

## 使用流程

1. 选择需要识别的语言；
2. 输入频道名并加入；
3. 示例程序将接收到的远端音频数据传入 Speech framework，并把 Speech framework 文字识别的结果展示在 text view 上；
4. 点击离 Leave channel 停止语音识别，并离开频道。

- Important: 只有第一个远端用户的音频会被识别。

## 开发环境

* Xcode 10.0 +
* iOS 真机

## 联系我们

- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题, 你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题, 可以拨打 400 632 6626，或加入官方Q群 12742516 提问
- 如果需要售后技术支持, 你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的 bug, 欢迎提交 [issue](https://github.com/AgoraIO/Advanced-Audio/issues)

## 代码许可

The MIT License (MIT).
