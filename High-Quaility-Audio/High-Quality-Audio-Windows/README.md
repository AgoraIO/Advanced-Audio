# Agora High Quality Audio

这个开源示例项目演示了如何基于 Qt Quick（32bit） 快速集成 [Agora](www.agora.io) 音频 SDK，实现高音频demo。

在这个示例项目中包含以下功能：

Agora 

- 加入通话和离开频道
- 切换声卡
- 调节播放音量
- 是否启用Local LoopBack

Qt Quick

- UI 界面

本项目采用了 Qt Quick 的 UI 界面功能，使用了 Agora 提供的声音音频采集、编码、传输、解码和播放功能。

Qt Quick功能实现请参考 [Qt Quick 官方文档](https://doc.qt.io/qt-5/qtquick-index.html)

Agora 功能实现请参考 [Agora 官方文档](https://docs.agora.io/cn/Interactive Broadcast/product_live?platform=All Platforms)

## 运行示例程序
首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。将 AppID 填写进 `agorartcengine.cpp`

```c++
context.appId = ""; // Specify your APP ID here
```
然后在 [Agora.io SDK](https://www.agora.io/cn/download/) 下载 视频通话 + 直播 SDK，并解压后将其中的

* Windows：`sdk`复制到本项目文件夹下

最后使用 Qt Creator 打开 `AgoraHighSound.pro` 工程文件，点击构建成功后即可运行。

## 运行环境
* Windows

## FAQ
- 如果遇到问题请联系技术支持

## 联系我们

- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题，你可以到 [开发者社区](https://dev.agora.io/cn/) 提问
- 如果有售前咨询问题，可以拨打 400 632 6626，或加入官方QQ群 12742516 提问
- 如果需要售后技术支持，你可以在 [Agora Dashboard](https://dashboard.agora.io) 提交工单
- 如果发现了示例代码的bug，欢迎提交 [issue](https://github.com/AgoraIO/Agora-with-QT/issues)

## 代码许可

The MIT License (MIT).test

