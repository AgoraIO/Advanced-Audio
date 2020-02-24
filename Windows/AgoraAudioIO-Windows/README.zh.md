#AgoraAudioIO-Windows

*Read this in other languages: [English](README.md)*

Demo展示外部视频源如何通过音频裸数据接口IAudioFrameObserver把pcm数据传给agora sdk。Demo使用dshow作为外部音频源

##安装 Directx SDK
需要 [directx sdk 2010 June](https://www.microsoft.com/en-us/download/confirmation.aspx?id=6812)。

After install dx sdk successfully,you need to reboot your computer.

## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. define the APP_ID with your App ID.

```
 #define APP_ID _T("Your App ID")
```

Next, download the **Agora Video SDK** from [Agora.io SDK](https://docs.agora.io/en/Agora%20Platform/downloads). Unzip the downloaded SDK package and copy the **sdk** to the project folder#(the old one may be over written).

## 运行环境
* VC++2013 或更高版本
* WIN7 或更高版本

