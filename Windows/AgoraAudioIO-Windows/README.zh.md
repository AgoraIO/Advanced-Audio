# AgoraAudioIO-Windows

*Read this in other languages: [English](README.md)*

Demo展示外部视频源如何通过音频裸数据接口IAudioFrameObserver把pcm数据传给agora sdk。Demo使用dshow作为外部音频源

##准备DShow依赖库

下载 [依赖库](https://github.com/AgoraIO/Advanced-Audio/releases/download/DShow/ThirdParty.zip)
解压 Thirdparty.zip, 拷贝 Dshow文件夹到sln所在文件夹。

## 运行环境
* VS2017 或更高版本
* WIN8.1 或更高版本


## 运行示例程序
首先, 在官网 [Agora.io](https://dashboard.agora.io/signin/)创建一个开发者账号。然后会获得一个appid， 用这个appid 定义demo里的宏APP_ID

```
 #define APP_ID _T("Your App ID")
```

下一步, 到官网[Agora.io SDK](https://docs.agora.io/en/Agora%20Platform/downloads)下载Agora视频SDK. 解压下载的sdk包，把文件夹**sdk**拷贝到项目文件夹下(AgoraAudioIO-Windows)。

最后，打开 AgoraExternalCapture.sln， 构建解决方案并运行。

**注意:**

  1. 程序编译后，在运行程序时如若出现：无法启动程序"xxx\xxx\xxx\Debug\Language\English.dll"的错误提示，
      请在解决方案资源管理器中选中OpenLive 项目，并右击，在弹出的菜单栏中选择 "设为启动项目"，即可解决。之后重新运行程序即可。
  2. 本开源项目在 debug 模式下运行可能会出现崩溃，请在 release 模式下运行。

## 联系我们

- [FAQ](https://docs.agora.io/cn/faq)
- [官方SDK](Github:https://github.com/AgoraIO)
- [官方案例](Github:https://github.com/AgoraIO-usecase)
- [社区](Github:https://github.com/AgoraIO-Community)
- 完整的 API 文档见 [文档中心](https://docs.agora.io/cn/)
- 如果在集成中遇到问题，你可以到 [开发者社区](https://rtcdeveloper.com/) 提问
- 如果发现了示例代码的 bug，欢迎提交 [issue](https://github.com/AgoraIO/<#Sample Repository>/issues)

## 代码许可

The MIT License (MIT)
