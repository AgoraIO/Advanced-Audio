//
//  MediaWorker.h
//  SpeechRecognizer-iOS
//
//  Created by GongYuhua on 2019/7/5.
//  Copyright © 2019 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class AgoraRtcEngineKit;

@protocol MediaWorkerDelegate <NSObject>
- (void)mediaWorkerDidReceiveRemotePCM:(AVAudioPCMBuffer * _Nonnull)buffer;
@end

@interface MediaWorker: NSObject
+ (void)setDelegate:(id<MediaWorkerDelegate> _Nullable)delegate;
+ (void)setRemoteUid:(NSUInteger)uid;
+ (void)registerAudioBufferInEngine:(AgoraRtcEngineKit * _Nonnull)kit;
+ (void)deregisterAudioBufferInEngine:(AgoraRtcEngineKit * _Nonnull)kit;
@end

