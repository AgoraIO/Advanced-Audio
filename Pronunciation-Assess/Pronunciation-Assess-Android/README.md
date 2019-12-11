# Pronunciation Assess Android


This demo gives an example of the combined use of Agora RTC voice sdk and Chivox language assessment sdk.

With this sample app, you can:

- Join / leave channel
- Start a word test, read the word aloud and see the overall assessment result of your pronunciation.

## Config Agora SDK
**First**, create a developer account at [agora.io](https://dashboard.agora.io/signin/), and obtain an App ID. Note you can get a temp token from dashboard project page (Can be used to join given channel only). Update "app/src/main/res/values/strings-config.xml" with your App ID.

```
<resources>
    <string name="AGORA_APP_ID"></string>
</resources>
```

**Next**, you can add Agora Voice SDK into project in two ways:

- From JCenter (which is recommended and default in the app/build.gradle):

```
implementation 'io.agora.rtc:voice-sdk:2.9.1'
```

- Download from Agora official website:

Download **Agora Voice SDK** from [Agora.io SDK](https://www.agora.io/en/download/). Unzip the downloaded archive package and copy ***.jar** under **libs** to **app/libs**, **arm64-v8a**/**x86**/**armeabi-v7a** under **libs** to **app/src/main/jniLibs**.

Then, add the fllowing code in the property of the dependence of the "app/build.gradle":

```
compile fileTree(dir: 'libs', include: ['*.jar'])
```

**Finally**, open project with Android Studio, connect your Android device, build and run.

Or use `Gradle` to build and run.

## Config Chivox SDK
**First**, you need to contact Chivox for the app keys, and the link of Chivox SDK and provision licence file.

**Second**, change Chivox provision file name to "aiengine.provision" (if is not), and copy to **app/src/main/assets/** folder (create if not exists). Then copy all *.so libraries to **app/src/main/jniLibs**.

The structure of jniLibs folder should be like:
```
    main
    |_  jniLibs
        |_ armeabi-v7a
           |_ libaiengine.so
              libmp3lame.so
        |_ arm64-v8a
           |_ libaiengine.so
              libmp3lame.so
```
**Last**, update "app/src/main/res/values/strings-config.xml" with your Chivox app key and secret key
```
<resources>
    <string name="CHIVOX_APP_KEY"></string>
    <string name="CHIVOX_SECRET_KEY"></string>
</resources>
```

## Developer Environment Requirements
- Android Studio 3.0 or above
- Real devices (Nexus 5X or other devices)
- Some simulators are function missing or have performance issue, so real device is the best choice

## Connect Us
- You can find full API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Basic-Audio-Call/issues)

## License
The MIT License (MIT).