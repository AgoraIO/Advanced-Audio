# AgoraAudioIO

*其他语言版本： [简体中文](README.zh.md)*

The AgoraAudioIO Sample App is an open-source demo that will help you get audio chat integrated directly into your iOS/macOS applications using the Agora Audio SDK.

With this sample app, you can:

- 4 kind of audio modes (external audio handle or sdk audio handle)
- 2 channel modes (communication and livebroadcast)
- Join / leave channel
- Mute / unmute audio
- Change audio route

## Prerequisites
- Xcode 10.0+
- Physical iOS device (iPhone or iPad)
- iOS simulator is NOT supported

## Quick Start

This section shows you how to prepare, build, and run the sample application.

### Obtain an App Id

To build and run the sample application, get an App Id:

1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the signup process, you will be redirected to the Dashboard.
2. Navigate in the Dashboard tree on the left to **Projects** > **Project List**.
3. Save the **App Id** from the Dashboard for later use.
4. Generate a temp **Access Token** (valid for 24 hours) from dashboard page with given channel name, save for later use.

5. Open `Agora-RTC-With-ASMR.xcodeproj` and edit the `AppID.swift` file. Update `<#Your App Id#>` with your App Id, and assign the token variable with the temp Access Token generated from dashboard.

    ``` Swift
    let AppID: String = <#Your App Id#>
    // assign Token to nil if you have not enabled app certificate
    let Token: String? = <#Temp Token#>
    ```

### Integrate the Agora Audio SDK

1. Download the [Agora Voice SDK](https://www.agora.io/en/download/). Unzip the downloaded iOS SDK package and copy the following files from the SDK `libs` folder into `iOS&macOS/libs/iOS` folder.

    - `AograRtcKit.framework`
 
2. Download the [Agora Voice SDK](https://www.agora.io/en/download/). Unzip the downloaded macOS SDK package and copy the following files from the SDK `libs` folder into `iOS&macOS/libs/macOS` folder.
  
2. Open AgoraAudio.xcodeproj, selected **AgoraAudioIO Scheme** for running iOS app, connect your iPhone／iPad device, setup your development signing and run.
Or selected **AgoraAudioIOmac Scheme** for running macOS app.

## Contact Us

- For potential issues, take a look at our [FAQ](https://docs.agora.io/en/faq) first
- Dive into [Agora SDK Samples](https://github.com/AgoraIO) to see more tutorials
- Take a look at [Agora Use Case](https://github.com/AgoraIO-usecase) for more complicated real use case
- Repositories managed by developer communities can be found at [Agora Community](https://github.com/AgoraIO-Community)
- You can find full API documentation at [Document Center](https://docs.agora.io/en/)
- If you encounter problems during integration, you can ask question in [Stack Overflow](https://stackoverflow.com/questions/tagged/agora.io)
- You can file bugs about this sample at [issue](https://github.com/AgoraIO/Advanced-Audio/issues)

## License

The MIT License (MIT).
