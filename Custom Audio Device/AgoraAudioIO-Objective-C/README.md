# AgoraAudioIO

*其他语言版本： [简体中文](README.cn.md)*

The AgoraAudioIO Sample App is an open-source demo that will help you get audio chat integrated directly into your iOS/macOS applications using the Agora Audio SDK.

With this sample app, you can:

- 4 kind of audio modes (external audio handle or sdk audio handle)
- 2 channel modes (communication and livebroadcast)
- Join / leave channel
- Mute / unmute audio
- Change audio route


## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Update "AppID.m" with your App ID.

```
NSString * appID = @"YOUR APPID"; 
```

Next, download the **Agora Video SDK** from [Agora.io SDK](https://www.agora.io/en/blog/download/) for running AudioIO of macOS. Unzip the downloaded SDK package and copy **AgoraRtcEngineKit.framework** of the "libs" folder to the project folder **AgoraAudioIO/AgoraAudioIOmac**.

And download the **Agora Voice SDK** from [Agora.io SDK](https://www.agora.io/en/blog/download/) for running AudioIO of iOS. Unzip the downloaded SDK package and copy **AgoraAudioKit.framework** of the "libs" folder to the project folder **AgoraAudioIO/AgoraAudioIO**.

Finally, Open AgoraAudio.xcodeproj, selected **AgoraAudioIO Scheme** for running iOS, connect your iPhone／iPad device, setup your development signing and run.
Or selected **AgoraAudioIOmac Scheme** for running macOS,
and run it directly in Mac

## Developer Environment Requirements
* XCode 8.0 +
* macOS can run directly in Mac
* iOS can run in Real devices (iPhone or iPad) or simulator

## Connect Us

- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Agora-iOS-Tutorial-Objective-C-1to1/issues)

## License

The MIT License (MIT).
