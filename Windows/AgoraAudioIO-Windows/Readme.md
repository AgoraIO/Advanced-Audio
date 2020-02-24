#AgoraAudioIO-Windows

This demo show how extenal audio source give pcm data to agora sdk by using IAudioFrameObserver. This demo impement external audio source by dshow.

##Install Directx SDK

需要下载并安装[directx sdk 2010 June](https://www.microsoft.com/en-us/download/confirmation.aspx?id=6812)。安装成功之后需要重新启动计算机。

## Running the App

##安装Directx SDK

需要下载并安装[directx sdk 2010 June](https://www.microsoft.com/en-us/download/confirmation.aspx?id=6812)。安装之后需要重新启动。

## 运行示例程序
首先在 [Agora.io 注册](https://dashboard.agora.io/cn/signup/) 注册账号，并创建自己的测试项目，获取到 AppID。将 AppID 内容替换至 APP_ID 宏定义中

```
 #define APP_ID _T("Your App ID")
```

然后在 [Agora.io SDK](https://docs.agora.io/cn/Agora%20Platform/downloads) 下载 **视频通话 + 直播 SDK**，解压后将其中的 **sdk** 复制到本项目的 

## Developer Environment Requirements
* VC2013 or higher
* WIN7 or higher
