#AgoraAudioIO-Windows

This demo show how extenal audio source give pcm data to agora sdk by using IAudioFrameObserver. This demo impement external audio source by dshow.

##Install Directx SDK

You need to download and install [directx sdk 2010 June](https://www.microsoft.com/en-us/download/confirmation.aspx?id=6812)。

After install dx sdk successfully,you need to reboot your computer.

## Developer Environment Requirements
* VC2013 or higher
* WIN7 or higher

## Running the App
First, create a developer account at [Agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. define the APP_ID with your App ID.

```
 #define APP_ID _T("Your App ID")
```

Next, download the **Agora Video SDK** from [Agora.io SDK](https://docs.agora.io/en/Agora%20Platform/downloads). Unzip the downloaded SDK package and copy the **sdk** to the "AgoraMediaSource" folder in project(the old one may be over written).

Finally, Open AgoraMediaSource.sln, build the solution and run.

**Note：**

  1. After the program is compiled, if the program "xxx\xxx\xxx\Debug\Language\English.dll" cannot be started when running the program, 
      please select the AgoraMediaSource project in the Solution Explorer and right click. In the pop-up menu bar, select "Set as active project" to solve. Then run the program again.
  
  2. The dll library under the sdk/dll file needs to be placed in the corresponding execution path.
  
  Tips: The relevant dll library has been configured for you in this case tutorial. If you want to use the interface provided by agora for related development, you need to put the dll library into the corresponding execution path as prompted above.

## Contract Us

	- [FAQ](https://docs.agora.io/cn/faq)
	- [Agora SDK](Github:https://github.com/AgoraIO)
	- [Agora Use Case](Github:https://github.com/AgoraIO-usecase)
	- [Agora Community](Github:https://github.com/AgoraIO-Community)
	- You can find full API document at [Document Center](https://docs.agora.io/en/)
	- If you encounter problems during integration, you can ask question in [Developer Forum](https://rtcdeveloper.com/)
	- You can file bugs about this sample at [issue](https://github.com/AgoraIO/<#Sample Repository>/issues)

## License

The MIT License (MIT)
