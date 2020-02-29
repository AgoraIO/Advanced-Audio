 #AgoraAudioIO-Windows

*Read this in other languages: [English](README.md)*

Demo展示外部视频源如何通过音频裸数据接口IAudioFrameObserver把pcm数据传给agora sdk。Demo使用dshow作为外部音频源

##安装 Directx SDK
需要 [directx sdk 2010 June](https://www.microsoft.com/en-us/download/confirmation.aspx?id=6812)。

成功安装dx之后，需要重启电脑。

## 运行环境
* VC++2013 或更高版本
* WIN7 或更高版本


##运行demo
首先, 在官网 [Agora.io](https://dashboard.agora.io/signin/)创建一个开发者账号。然后会获得一个appid， 用这个appid 定义demo里的宏APP_ID

```
 #define APP_ID _T("Your App ID")
```

下一步, 到官网[Agora.io SDK](https://docs.agora.io/en/Agora%20Platform/downloads)下载Agora视频SDK. 解压下载的sdk包，把文件夹**sdk**拷贝到项目文件夹

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
