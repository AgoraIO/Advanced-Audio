//
//  RoomViewController.h
//  AgoraAudioIO
//
//  Created by suleyu on 2017/12/15.
//  Copyright © 2017 Agora. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AudioOptions.h"

@class RoomViewControllerMac;
@protocol RoomVCMacDelegate
- (void)roomVCNeedClose:(RoomViewControllerMac *)roomVC;
@end

@interface RoomViewControllerMac : NSViewController
@property (nonatomic, assign) int sampleRate;
@property (nonatomic, assign) AudioCRMode audioMode;
@property (nonatomic, assign) ChannelMode channelMode;
@property (nonatomic, assign) ClientRole role;
@property (nonatomic, strong) id<RoomVCMacDelegate> delegate;
@property (nonatomic, copy)   NSString *channelName;
@end
