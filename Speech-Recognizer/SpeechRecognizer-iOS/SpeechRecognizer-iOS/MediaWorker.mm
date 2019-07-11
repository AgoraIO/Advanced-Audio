//
//  MediaWorker.m
//  SpeechRecognizer-iOS
//
//  Created by GongYuhua on 2019/7/5.
//  Copyright © 2019 Apple. All rights reserved.
//

#import "MediaWorker.h"
#import <AgoraAudioKit/AgoraRtcEngineKit.h>
#import <AgoraAudioKit/IAgoraRtcEngine.h>
#import <AgoraAudioKit/IAgoraMediaEngine.h>
#import <string.h>

static NSUInteger remoteUid;
static id<MediaWorkerDelegate> theDelegate;

class AgoraAudioFrameObserver : public agora::media::IAudioFrameObserver
{
public:
    virtual bool onRecordAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    
    virtual bool onPlaybackAudioFrame(AudioFrame& audioFrame) override
    {
        return true;
    }
    
    virtual bool onPlaybackAudioFrameBeforeMixing(unsigned int uid, AudioFrame& audioFrame) override
    {
        if (uid == 0 || uid != remoteUid) {
            return true;
        }
        
        AVAudioChannelLayout *chLayout = [[AVAudioChannelLayout alloc] initWithLayoutTag:kAudioChannelLayoutTag_Mono];
        AVAudioFormat *chFormat = [[AVAudioFormat alloc] initWithCommonFormat:AVAudioPCMFormatInt16
                                                                   sampleRate:audioFrame.samplesPerSec
                                                                  interleaved:NO
                                                                channelLayout:chLayout];
        
        size_t size = audioFrame.bytesPerSample * audioFrame.samples;
        
        AVAudioPCMBuffer *thePCMBuffer = [[AVAudioPCMBuffer alloc] initWithPCMFormat:chFormat frameCapacity:size];
        
        thePCMBuffer.frameLength = audioFrame.samples;
        
        memcpy(thePCMBuffer.int16ChannelData[0], audioFrame.buffer, size);
        
        if ([theDelegate respondsToSelector:@selector(mediaWorkerDidReceiveRemotePCM:)]) {
            [theDelegate mediaWorkerDidReceiveRemotePCM:thePCMBuffer];
        }
        
        return true;
    }
    
    virtual bool onMixedAudioFrame(AudioFrame &audioFrame) override {
        return true;
    }
};

static AgoraAudioFrameObserver s_audioFrameObserver;

@implementation MediaWorker
+ (void)setDelegate:(id<MediaWorkerDelegate> _Nullable)delegate {    theDelegate = delegate;
}

+ (void)setRemoteUid:(NSUInteger)uid {
    remoteUid = uid;
}

+ (void)registerAudioBufferInEngine:(AgoraRtcEngineKit * _Nonnull)kit {
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine) {
        mediaEngine->registerAudioFrameObserver(&s_audioFrameObserver);
    }
}

+ (void)deregisterAudioBufferInEngine:(AgoraRtcEngineKit * _Nonnull)kit {
    agora::rtc::IRtcEngine* rtc_engine = (agora::rtc::IRtcEngine*)kit.getNativeHandle;
    agora::util::AutoPtr<agora::media::IMediaEngine> mediaEngine;
    mediaEngine.queryInterface(rtc_engine, agora::AGORA_IID_MEDIA_ENGINE);
    if (mediaEngine) {
        mediaEngine->registerAudioFrameObserver(NULL);
    }
}

@end
