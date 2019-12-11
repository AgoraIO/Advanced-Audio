# Pronunciation Assess iOS


This demo gives an example of the combined use of Agora RTC voice sdk and Chivox language assessment sdk.

With this sample app, you can:

- Join / leave channel
- Start a word test, read the word aloud and see the overall assessment result of your pronunciation.

## Prerequisites

- Xcode 10.0+
- Physical iOS device (iPhone or iPad)

## Quick Start

This section shows you how to prepare, build, and run the sample application.

### Obtain an Agora App ID

To build and run the sample application, get an App ID:
1. Create a developer account at [agora.io](https://dashboard.agora.io/signin/). Once you finish the signup process, you will be redirected to the Dashboard.
2. Navigate in the Dashboard tree on the left to **Projects** > **Project List**.
3. Save the **App ID** from the Dashboard for later use.
4. Generate a temp **Access Token** (valid for 24 hours) from dashboard page with given channel name, save for later use.

5. Open `Pronunciation-Assess.xcodeproj` and edit the `AppId.swift` file. In the `agoraKit` declaration, update `<#Your App Id#>` with your app ID, and assign the token variable with the temp Access Token generated from dashboard.

    ``` Swift
    let AppID: String = <#Your App ID#>
    // assign Token to nil if you have not enabled app certificate
    let Token: String? = <#Temp Token#>
    ```

### Integrate the Agora Audio SDK

1. Download the [Agora Audio SDK](https://www.agora.io/en/download/). Unzip the downloaded SDK package and copy the following files from the SDK `libs` folder into the sample application `Pronunciation-Assess` folder.
    - `AograAudioKit.framework`
  
### Integrate the Chivox SDK
  
1. You need to contact Chivox or Agora for the chivox keys, and the link of Chivox SDK and provision licence file. 

2. Open `Pronunciation-Assess.xcodeproj` and edit the `CXKeys.swift` file. Update following keys.

	```
   let CXAppKey = <#CX App Key#>
   let CXSecretKey = <#CX Secret Key#>
	```

3. Copy aiengine.h, aiengine.provision, libaiengine.a to **Pronunciation-Assess/CHIVOX**
  
### Run
  
Connect your iPhone or iPad device and run the project. Ensure a valid provisioning profile is applied or your project will not run.

## Resources

- You can find full Agora API document at [Document Center](https://docs.agora.io/en/)
- You can file bugs about this demo at [issue](https://github.com/AgoraIO/Advance-Audio/issues)

## License

The MIT License (MIT)
