# Speech Recognizer

*English | [中文](README.zh.md)*

The SpeechRecognizer-iOS Sample App shows how to perform speech recognition on audio coming from the remote user in an Agora channel.

## Running the App

1. Create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Update "AppId.swift" with your App ID.

	``` swift
	let AppId: String = "Your App ID"
	```

2. Run `pod install` in the project directory to download and link Agora audio sdk.
3. Open `SpeechRecognizer-iOS.xcworkspace`, connect your iOS device, setup your development signing and run.

- Important: Apps must include the `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription` key in their `Info.plist` file and must request authorization to perform speech recognition.

## How to Use

1. Choose the language to recognize.
2. Enter a channel name in the TextFiled, and join.
3. The app begins routes the audio data received from remote user to the Speech framework, and displays the recognized text from Speech framework in the text view.
4. Press Leave channel to stop speech recognition and leave the channel.

- Important: Only the first remote user in channel will be performed speech recognition.

## Developer Environment Requirements

* Xcode 10.0 +
* Real devices (iPhone or iPad)
* iOS simulator is NOT supported

## Connect Us

- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advanced-Audio/issues)

## License

The MIT License (MIT).
