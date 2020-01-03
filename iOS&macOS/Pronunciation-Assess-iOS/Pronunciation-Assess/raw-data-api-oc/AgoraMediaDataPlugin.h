//
//  AgoraMediaDataPlugin.h
//  OpenVideoCall
//
//  Created by CavanSu on 26/02/2018.
//  Copyright © 2018 Agora. All rights reserved.
//

#import "AgoraMediaRawData.h"

#if (!(TARGET_OS_IPHONE) && (TARGET_OS_MAC))
#import <Cocoa/Cocoa.h>
typedef NSImage AGImage;
#else
#import <UIKit/UIKit.h>
typedef UIImage AGImage;
#endif

typedef NS_OPTIONS(NSInteger, ObserverVideoType) {
    ObserverVideoTypeCaptureVideo                    = 1 << 0,
    ObserverVideoTypeRenderVideo                     = 1 << 1,
};

typedef NS_OPTIONS(NSInteger, ObserverAudioType) {
    ObserverAudioTypeRecordAudio                     = 1 << 0,
    ObserverAudioTypePlaybackAudio                   = 1 << 1,
    ObserverAudioTypePlaybackAudioFrameBeforeMixing  = 1 << 2,
    ObserverAudioTypeMixedAudio                      = 1 << 3
};

@class AgoraRtcEngineKit;
@class AgoraMediaDataPlugin;
@protocol AgoraVideoDataPluginDelegate <NSObject>
@optional
- (AgoraVideoRawData * _Nonnull)mediaDataPlugin:(AgoraMediaDataPlugin * _Nonnull)mediaDataPlugin didCapturedVideoRawData:(AgoraVideoRawData * _Nonnull)videoRawData;
- (AgoraVideoRawData * _Nonnull)mediaDataPlugin:(AgoraMediaDataPlugin * _Nonnull)mediaDataPlugin willRenderVideoRawData:(AgoraVideoRawData * _Nonnull)videoRawData ofUid:(uint)uid;
@end

@protocol AgoraAudioDataPluginDelegate <NSObject>
@optional
- (AgoraAudioRawData * _Nonnull)mediaDataPlugin:(AgoraMediaDataPlugin * _Nonnull)mediaDataPlugin didRecordAudioRawData:(AgoraAudioRawData * _Nonnull)audioRawData;
- (AgoraAudioRawData * _Nonnull)mediaDataPlugin:(AgoraMediaDataPlugin * _Nonnull)mediaDataPlugin willPlaybackAudioRawData:(AgoraAudioRawData * _Nonnull)audioRawData;
- (AgoraAudioRawData * _Nonnull)mediaDataPlugin:(AgoraMediaDataPlugin * _Nonnull)mediaDataPlugin willPlaybackBeforeMixingAudioRawData:(AgoraAudioRawData * _Nonnull)audioRawData;
- (AgoraAudioRawData * _Nonnull)mediaDataPlugin:(AgoraMediaDataPlugin * _Nonnull)mediaDataPlugin didMixedAudioRawData:(AgoraAudioRawData * _Nonnull)audioRawData;
@end

@interface AgoraMediaDataPlugin : NSObject
@property (nonatomic, weak) id<AgoraVideoDataPluginDelegate> _Nullable videoDelegate;
@property (nonatomic, weak) id<AgoraAudioDataPluginDelegate> _Nullable audioDelegate;
+ (instancetype _Nonnull)mediaDataPluginWithAgoraKit:(AgoraRtcEngineKit * _Nonnull)agoraKit;

- (void)registerVideoRawDataObserver:(ObserverVideoType)observerType;
- (void)deregisterVideoRawDataObserver:(ObserverVideoType)observerType;

- (void)registerAudioRawDataObserver:(ObserverAudioType)observerType;
- (void)deregisterAudioRawDataObserver:(ObserverAudioType)observerType;

- (void)setVideoRawDataFormatter:(AgoraVideoRawDataFormatter * _Nonnull)formatter;
- (AgoraVideoRawDataFormatter * _Nonnull)getCurrentVideoRawDataFormatter;

// you can call following methods before set videoDelegate
- (void)screenShotDidCaptureLocalWithImage:(void (^ _Nullable)(AGImage * _Nonnull image))completion;
- (void)screenShotWillRenderWithUid:(NSUInteger)uid image:(void (^ _Nullable)(AGImage * _Nonnull image))completion;
@end

