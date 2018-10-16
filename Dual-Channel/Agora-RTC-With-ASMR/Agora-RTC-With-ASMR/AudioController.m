//
//  AudioController.m
//  Agora-RTC-With-ASMR
//
//  Created by CavanSu on 10/11/2017.
//  Copyright © 2017 Agora. All rights reserved.
//

#import "AudioController.h"
#import "AudioWriteToFile.h"

#define InputBus 1
#define OutputBus 0

@interface AudioController ()

@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) int channelCount;
@property (nonatomic, assign) AudioUnit remoteIOUnit;

@end

@implementation AudioController

static double preferredIOBufferDuration = 0.02;

+ (instancetype)audioController {
    AudioController *audioController = [[self alloc] init];
    
    return audioController;
}

#pragma mark - <Capture Call Back>
static OSStatus captureCallBack(void *inRefCon,
                                AudioUnitRenderActionFlags *ioActionFlags,
                                const AudioTimeStamp *inTimeStamp,
                                UInt32 inBusNumber, // inputBus = 1
                                UInt32 inNumberFrames,
                                AudioBufferList *ioData)
{
    AudioController *audioController = (__bridge AudioController *)inRefCon;
    
    AudioUnit captureUnit = [audioController remoteIOUnit];
    
    if (!inRefCon) return 0;
    
    AudioBuffer buffer;
    buffer.mData = NULL;
    buffer.mDataByteSize = 0;
    buffer.mNumberChannels = audioController.channelCount;
    
    AudioBufferList bufferList;
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0] = buffer;
    
    OSStatus status = AudioUnitRender(captureUnit,
                                      ioActionFlags,
                                      inTimeStamp,
                                      inBusNumber,
                                      inNumberFrames,
                                      &bufferList);
    
    if (!status) {
        if ([audioController.delegate respondsToSelector:@selector(audioController:didCaptureData:bytesLength:)]) {
            [audioController.delegate audioController:audioController didCaptureData:(unsigned char *)bufferList.mBuffers[0].mData bytesLength:bufferList.mBuffers[0].mDataByteSize];
        }
    }
    
    return 0;
}


#pragma mark - <Render Call Back>
static OSStatus renderCallBack(void *inRefCon,
                               AudioUnitRenderActionFlags *ioActionFlags,
                               const AudioTimeStamp *inTimeStamp,
                               UInt32 inBusNumber,
                               UInt32 inNumberFrames,
                               AudioBufferList *ioData)
{
    AudioController *audioController = (__bridge AudioController *)(inRefCon);

    if (*ioActionFlags == kAudioUnitRenderAction_OutputIsSilence) {
        return noErr;
    }
    
    int result = 0;
    
    if ([audioController.delegate respondsToSelector:@selector(audioController:didRenderData:bytesLength:)]) {
        result = [audioController.delegate audioController:audioController didRenderData:(uint8_t*)ioData->mBuffers[0].mData bytesLength:ioData->mBuffers[0].mDataByteSize];
    }
    
    if (result == 0) {
        *ioActionFlags = kAudioUnitRenderAction_OutputIsSilence;
        ioData->mBuffers[0].mDataByteSize = 0;
    }
    
    return noErr;
}


#pragma mark - <Step 1, Set Up Audio Session>
- (void)setUpAudioSessionWithSampleRate:(int)sampleRate channelCount:(int)channelCount {
    
    self.sampleRate = sampleRate;
    self.channelCount = channelCount;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSUInteger sessionOption = AVAudioSessionCategoryOptionMixWithOthers;
    sessionOption |= AVAudioSessionCategoryOptionAllowBluetooth;
    
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:sessionOption error:nil];
    [audioSession setMode:AVAudioSessionModeDefault error:nil];
  
    [audioSession setActive:YES error:nil];
    [audioSession setPreferredIOBufferDuration:preferredIOBufferDuration error:nil];
    
    [self setupRemoteIO];
}

#pragma mark - <Step 2, Set Up Audio Capture>
- (void)setupRemoteIO {
 
    OSStatus status;
    
    // AudioComponentDescription
    AudioComponentDescription remoteIODesc;
    remoteIODesc.componentType = kAudioUnitType_Output;
    remoteIODesc.componentSubType = kAudioUnitSubType_RemoteIO;
    remoteIODesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    remoteIODesc.componentFlags = 0;
    remoteIODesc.componentFlagsMask = 0;
    
    AudioComponent remoteIOComponent = AudioComponentFindNext(NULL, &remoteIODesc);
    AudioComponentInstanceNew(remoteIOComponent, &_remoteIOUnit);
    
    // EnableIO
    UInt32 one = 1;
    status = AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Input,
                                  InputBus,
                                  &one,
                                  sizeof(one));

    status = AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioOutputUnitProperty_EnableIO,
                                  kAudioUnitScope_Output,
                                  OutputBus,
                                  &one,
                                  sizeof(one));
    
    // AudioStreamBasicDescription
    AudioStreamBasicDescription streamFormatDesc;
    streamFormatDesc.mSampleRate = _sampleRate;
    streamFormatDesc.mFormatID = kAudioFormatLinearPCM;
    streamFormatDesc.mFormatFlags = (kAudioFormatFlagIsSignedInteger | kAudioFormatFlagsNativeEndian | kAudioFormatFlagIsPacked);
    streamFormatDesc.mChannelsPerFrame = _channelCount;
    streamFormatDesc.mFramesPerPacket = 1;
    streamFormatDesc.mBitsPerChannel = 16;
    streamFormatDesc.mBytesPerFrame = streamFormatDesc.mBitsPerChannel / 8 * streamFormatDesc.mChannelsPerFrame;
    streamFormatDesc.mBytesPerPacket = streamFormatDesc.mBytesPerFrame * streamFormatDesc.mFramesPerPacket;
    
    status = AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Output,
                                  InputBus,
                                  &streamFormatDesc,
                                  sizeof(streamFormatDesc));
    
    status = AudioUnitSetProperty(_remoteIOUnit,
                                  kAudioUnitProperty_StreamFormat,
                                  kAudioUnitScope_Input,
                                  OutputBus,
                                  &streamFormatDesc,
                                  sizeof(streamFormatDesc));

    // CallBack
    AURenderCallbackStruct captureCallBackStruck;
    captureCallBackStruck.inputProcRefCon = (__bridge void * _Nullable)(self);
    captureCallBackStruck.inputProc = captureCallBack;
    
    AudioUnitSetProperty(_remoteIOUnit,
                         kAudioOutputUnitProperty_SetInputCallback,
                         kAudioUnitScope_Global,
                         InputBus,
                         &captureCallBackStruck,
                         sizeof(captureCallBackStruck));
    
    AURenderCallbackStruct renderCallback;
    renderCallback.inputProcRefCon = (__bridge void * _Nullable)(self);
    renderCallback.inputProc = renderCallBack;
    AudioUnitSetProperty(_remoteIOUnit,
                         kAudioUnitProperty_SetRenderCallback,
                         kAudioUnitScope_Input,
                         OutputBus,
                         &renderCallback,
                         sizeof(renderCallback));
    
    AudioUnitInitialize(_remoteIOUnit);
}

- (void)startWork {
    AudioOutputUnitStart(_remoteIOUnit);
}

- (void)stopWork {
    AudioOutputUnitStop(_remoteIOUnit);
}

- (void)dealloc {
    AudioOutputUnitStop(_remoteIOUnit);
    AudioComponentInstanceDispose(_remoteIOUnit);
    _remoteIOUnit = nil;
}

@end
